#!/bin/bash

# Setup script for Whisper Audio Recorder & Transcriber
# Installs dependencies and prepares the environment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

echo "🔧 Whisper Audio Recorder Setup"
echo "==============================="
echo

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_warning "This setup script is optimized for macOS"
    print_warning "You may need to adapt the installation commands for your system"
fi

# Check if Homebrew is installed
print_status "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    print_error "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    print_success "Homebrew found"
fi

# Install sox
print_status "Installing sox (audio recording tool)..."
if command -v sox &> /dev/null; then
    print_success "sox already installed"
else
    if brew install sox; then
        print_success "sox installed successfully"
    else
        print_error "Failed to install sox"
        exit 1
    fi
fi

# Check if Python is available
print_status "Checking Python installation..."
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    print_error "Python not found. Please install Python 3.7+ first"
    print_status "You can install Python via Homebrew: brew install python"
    exit 1
else
    print_success "Python found"
fi

# Check if pip is available
print_status "Checking pip installation..."
if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    print_error "pip not found. Please install pip first"
    exit 1
else
    print_success "pip found"
fi

# Install Whisper
print_status "Installing OpenAI Whisper..."
if command -v whisper &> /dev/null; then
    print_success "Whisper already installed"
else
    # Try pip3 first, then pip
    if command -v pip3 &> /dev/null; then
        PIP_CMD="pip3"
    else
        PIP_CMD="pip"
    fi
    
    if $PIP_CMD install openai-whisper; then
        print_success "Whisper installed successfully"
    else
        print_error "Failed to install Whisper"
        print_status "You may need to run: $PIP_CMD install --user openai-whisper"
        exit 1
    fi
fi

# Optional: Install ffmpeg for additional audio format support
print_status "Installing ffmpeg (optional, for additional audio formats)..."
if command -v ffmpeg &> /dev/null; then
    print_success "ffmpeg already installed"
else
    if brew install ffmpeg; then
        print_success "ffmpeg installed successfully"
    else
        print_warning "Failed to install ffmpeg (optional dependency)"
    fi
fi

# Create directories
print_status "Creating project directories..."
mkdir -p recordings
mkdir -p transcriptions
print_success "Directories created: recordings/, transcriptions/"

# Test installations
echo
print_status "Testing installations..."

# Test sox
if sox --version &> /dev/null; then
    print_success "sox is working"
else
    print_error "sox installation test failed"
fi

# Test whisper
if whisper --help &> /dev/null; then
    print_success "whisper is working"
else
    print_error "whisper installation test failed"
fi

echo
print_success "Setup complete!"
echo
echo "Usage:"
echo "  ./record-and-transcribe.sh              # Basic recording and transcription"
echo "  ./record-and-transcribe.sh --help       # Show all options"
echo "  ./record-and-transcribe.sh -m large     # Use large model for best quality"
echo
echo "First run will download the Whisper model (~74MB for base model)"
echo "Subsequent runs will be faster as the model is cached locally" 