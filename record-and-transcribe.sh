#!/bin/bash

# Whisper Audio Recorder & Transcriber
# Records audio using sox and transcribes using offline Whisper AI

set -euo pipefail

# Configuration
WHISPER_MODEL="${WHISPER_MODEL:-base}"
SAMPLE_RATE="${SAMPLE_RATE:-16000}"
CHANNELS="${CHANNELS:-1}"
BIT_DEPTH="${BIT_DEPTH:-16}"
OUTPUT_DIR="${OUTPUT_DIR:-$(pwd)}"
RECORDINGS_DIR="${OUTPUT_DIR}/recordings"
TRANSCRIPTIONS_DIR="${OUTPUT_DIR}/transcriptions"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command -v sox &> /dev/null; then
        missing_deps+=("sox")
    fi
    
    if ! command -v whisper &> /dev/null; then
        missing_deps+=("whisper")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        echo
        echo "To install missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            case $dep in
                "sox")
                    echo "  brew install sox"
                    ;;
                "whisper")
                    echo "  pip install openai-whisper"
                    ;;
            esac
        done
        exit 1
    fi
    
    print_success "All dependencies found"
}

# Function to create directories
setup_directories() {
    mkdir -p "$RECORDINGS_DIR"
    mkdir -p "$TRANSCRIPTIONS_DIR"
    print_status "Created directories: $RECORDINGS_DIR, $TRANSCRIPTIONS_DIR"
}

# Function to generate filename with timestamp
generate_filename() {
    local prefix="$1"
    local extension="$2"
    echo "${prefix}_$(date +%Y%m%d_%H%M%S).${extension}"
}

# Function to record audio
record_audio() {
    local output_file="$1"
    
    print_status "Starting audio recording..."
    print_status "Recording to: $output_file"
    print_status "Press Enter to stop recording"
    echo
    
    # Start sox recording in background
    sox -d -t wav -r "$SAMPLE_RATE" -c "$CHANNELS" -b "$BIT_DEPTH" "$output_file" &
    local sox_pid=$!
    
    # Wait for user input to stop recording
    read -r
    
    # Stop recording
    kill $sox_pid 2>/dev/null || true
    wait $sox_pid 2>/dev/null || true
    
    if [ -f "$output_file" ]; then
        local duration=$(sox --info -D "$output_file" 2>/dev/null || echo "unknown")
        print_success "Recording stopped. Duration: ${duration}s"
        return 0
    else
        print_error "Recording failed - no output file created"
        return 1
    fi
}

# Function to transcribe audio
transcribe_audio() {
    local audio_file="$1"
    local output_file="$2"
    
    print_status "Starting transcription with Whisper model: $WHISPER_MODEL"
    print_status "This may take a moment..."
    
    # Run whisper transcription
    if whisper "$audio_file" --model "$WHISPER_MODEL" --output_dir "$(dirname "$output_file")" --output_format txt --verbose False; then
        
        # Find the generated transcription file
        local base_name=$(basename "$audio_file" .wav)
        local whisper_output="$(dirname "$output_file")/${base_name}.txt"
        
        if [ -f "$whisper_output" ]; then
            # Move to our desired output filename
            mv "$whisper_output" "$output_file"
            print_success "Transcription completed: $output_file"
            return 0
        else
            print_error "Transcription file not found: $whisper_output"
            return 1
        fi
    else
        print_error "Whisper transcription failed"
        return 1
    fi
}

# Function to display transcription
display_transcription() {
    local transcription_file="$1"
    
    if [ -f "$transcription_file" ]; then
        echo
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "                                TRANSCRIPTION"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo
        cat "$transcription_file"
        echo
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
}

# Function to show usage
show_usage() {
    echo "Whisper Audio Recorder & Transcriber"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -m, --model MODEL     Whisper model to use (tiny|base|small|medium|large)"
    echo "                        Default: base"
    echo "  -o, --output DIR      Output directory for recordings and transcriptions"
    echo "                        Default: current directory"
    echo "  -r, --rate RATE       Sample rate in Hz (Default: 16000)"
    echo "  -h, --help           Show this help message"
    echo
    echo "Environment Variables:"
    echo "  WHISPER_MODEL        Default Whisper model"
    echo "  SAMPLE_RATE          Default sample rate"
    echo "  OUTPUT_DIR           Default output directory"
    echo
    echo "Examples:"
    echo "  $0                          # Use default settings"
    echo "  $0 -m small -o ~/recordings # Use small model, custom output dir"
    echo "  $0 --model large            # Use large model for best quality"
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -m|--model)
                WHISPER_MODEL="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                RECORDINGS_DIR="${OUTPUT_DIR}/recordings"
                TRANSCRIPTIONS_DIR="${OUTPUT_DIR}/transcriptions"
                shift 2
                ;;
            -r|--rate)
                SAMPLE_RATE="$2"
                shift 2
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Cleanup function
cleanup() {
    print_status "Cleaning up..."
    # Kill any background sox processes
    pkill -f "sox -d" 2>/dev/null || true
}

# Set trap for cleanup
trap cleanup EXIT INT TERM

# Main function
main() {
    echo "🎙️  Whisper Audio Recorder & Transcriber"
    echo "========================================="
    echo
    
    # Parse arguments
    parse_args "$@"
    
    # Check dependencies
    check_dependencies
    
    # Setup directories
    setup_directories
    
    # Generate filenames
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local audio_file="${RECORDINGS_DIR}/recording_${timestamp}.wav"
    local transcription_file="${TRANSCRIPTIONS_DIR}/transcription_${timestamp}.txt"
    
    echo
    print_status "Configuration:"
    echo "  Whisper Model: $WHISPER_MODEL"
    echo "  Sample Rate: $SAMPLE_RATE Hz"
    echo "  Channels: $CHANNELS (mono)"
    echo "  Bit Depth: $BIT_DEPTH bits"
    echo "  Output Directory: $OUTPUT_DIR"
    echo
    
    # Record audio
    if ! record_audio "$audio_file"; then
        exit 1
    fi
    
    echo
    
    # Transcribe audio
    if ! transcribe_audio "$audio_file" "$transcription_file"; then
        exit 1
    fi
    
    # Display results
    display_transcription "$transcription_file"
    
    echo
    print_success "Complete! Files saved:"
    echo "  Audio: $audio_file"
    echo "  Transcription: $transcription_file"
}

# Run main function with all arguments
main "$@" 