#!/bin/bash

# Example script demonstrating Whisper Audio Recorder usage
# This script shows different ways to use the recording and transcription system

echo "🎙️ Whisper Audio Recorder - Usage Examples"
echo "==========================================="
echo

# Function to show example with description
show_example() {
    local description="$1"
    local command="$2"
    
    echo "📝 Example: $description"
    echo "   Command: $command"
    echo
}

echo "🚀 Basic Usage Examples:"
echo

show_example "Simple recording and transcription" \
    "./record-and-transcribe.sh"

show_example "Use small model for better accuracy" \
    "./record-and-transcribe.sh --model small"

show_example "Use large model for best quality" \
    "./record-and-transcribe.sh --model large"

show_example "Custom output directory" \
    "./record-and-transcribe.sh --output ~/my-recordings"

show_example "High sample rate for music/complex audio" \
    "./record-and-transcribe.sh --rate 44100"

show_example "Combined options for professional use" \
    "./record-and-transcribe.sh -m large -o ~/important-meetings -r 22050"

echo "🔧 Setup and Help:"
echo

show_example "Install dependencies automatically" \
    "./setup.sh"

show_example "Show all available options" \
    "./record-and-transcribe.sh --help"

echo "🌍 Environment Variable Examples:"
echo

echo "📝 Set default model to large:"
echo "   export WHISPER_MODEL=large"
echo "   ./record-and-transcribe.sh"
echo

echo "📝 Set default output directory:"
echo "   export OUTPUT_DIR=~/recordings"
echo "   ./record-and-transcribe.sh"
echo

echo "📝 Set default sample rate:"
echo "   export SAMPLE_RATE=22050"
echo "   ./record-and-transcribe.sh"
echo

echo "🎯 Model Comparison Guide:"
echo

echo "For quick notes and testing:"
echo "   ./record-and-transcribe.sh --model tiny    # Fastest, basic quality"
echo

echo "For general use (recommended):"
echo "   ./record-and-transcribe.sh --model base    # Good balance"
echo

echo "For important meetings:"
echo "   ./record-and-transcribe.sh --model small   # Better accuracy"
echo

echo "For professional transcription:"
echo "   ./record-and-transcribe.sh --model large   # Best quality"
echo

echo "💡 Pro Tips:"
echo

echo "• First run downloads the model (requires internet)"
echo "• Subsequent runs are much faster (models are cached)"
echo "• Speak clearly and reduce background noise for best results"
echo "• Check microphone permissions if recording fails"
echo "• Files are automatically organized by timestamp"
echo

echo "🎮 Try it now:"
echo "   ./setup.sh                    # Install dependencies"
echo "   ./record-and-transcribe.sh    # Start recording!"
echo

echo "For more information, see README.md" 