# 🎙️ Whisper Audio Recorder & Transcriber

A comprehensive Bash script that records audio using sox and transcribes it using offline Whisper AI. Perfect for creating meeting notes, voice memos, and transcriptions without requiring an internet connection.

## ✨ Features

- **Interactive Recording**: Start/stop recording with simple prompts
- **Offline Transcription**: Uses OpenAI's Whisper for local speech-to-text
- **High-Quality Audio**: Optimized recording settings for best transcription results
- **Multiple Whisper Models**: Choose from tiny to large models based on your needs
- **Organized Output**: Automatic file organization with timestamps
- **Error Handling**: Robust validation and meaningful error messages
- **Cross-Platform**: Works on macOS, Linux, and Windows (with WSL)

## 🚀 Quick Start

### 1. One-Command Setup
```bash
./setup.sh
```

### 2. Start Recording
```bash
./record-and-transcribe.sh
```

### 3. Record Your Audio
- Press Enter when you want to stop recording
- The script will automatically transcribe your audio
- View the transcription on screen and find saved files in the output directories

## 📋 Prerequisites

- **macOS** (Darwin) - Optimized for macOS, adaptable for other systems
- **Homebrew** - Package manager for macOS
- **Python 3.7+** - Required for Whisper
- **Microphone** - For audio input

## 🔧 Manual Installation

If you prefer to install dependencies manually:

### Install sox (audio recording)
```bash
brew install sox
```

### Install Whisper (speech-to-text)
```bash
pip install openai-whisper
```

### Optional: Install ffmpeg (additional audio format support)
```bash
brew install ffmpeg
```

## 📖 Usage

### Basic Usage
```bash
./record-and-transcribe.sh
```

### Advanced Options
```bash
# Use different Whisper model
./record-and-transcribe.sh --model large

# Custom output directory
./record-and-transcribe.sh --output ~/my-recordings

# Custom sample rate
./record-and-transcribe.sh --rate 44100

# Combine options
./record-and-transcribe.sh -m small -o ~/transcriptions -r 22050
```

### Command Line Options
| Option | Description | Default |
|--------|-------------|---------|
| `-m, --model` | Whisper model (tiny\|base\|small\|medium\|large) | base |
| `-o, --output` | Output directory for files | current directory |
| `-r, --rate` | Audio sample rate in Hz | 16000 |
| `-h, --help` | Show help message | - |

### Environment Variables
You can set default values using environment variables:
```bash
export WHISPER_MODEL=large
export SAMPLE_RATE=22050
export OUTPUT_DIR=~/recordings
./record-and-transcribe.sh
```

## 🎯 Whisper Models

Choose the right model for your needs:

| Model | Size | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| **tiny** | 39MB | ⚡⚡⚡⚡⚡ | ⭐⭐ | Quick drafts, testing |
| **base** | 74MB | ⚡⚡⚡⚡ | ⭐⭐⭐ | **Recommended for most users** |
| **small** | 244MB | ⚡⚡⚡ | ⭐⭐⭐⭐ | Better accuracy |
| **medium** | 769MB | ⚡⚡ | ⭐⭐⭐⭐⭐ | High accuracy needs |
| **large** | 1550MB | ⚡ | ⭐⭐⭐⭐⭐ | Maximum accuracy |

**Note**: First run downloads the selected model. Subsequent runs are much faster.

## 📁 File Organization

The script automatically organizes files:
```
whisper/
├── record-and-transcribe.sh    # Main script
├── setup.sh                    # Setup script
├── recordings/                 # Audio files (.wav)
│   └── recording_20240101_143022.wav
├── transcriptions/             # Text files (.txt)
│   └── transcription_20240101_143022.txt
└── memory-bank/               # Documentation
    ├── projectbrief.md
    ├── techContext.md
    └── activeContext.md
```

## 🎚️ Audio Settings

The script uses optimized settings for Whisper:
- **Sample Rate**: 16kHz (Whisper's preferred rate)
- **Format**: WAV (uncompressed for best quality)
- **Channels**: Mono (sufficient for speech)
- **Bit Depth**: 16-bit (balanced quality/size)

## 🔍 Troubleshooting

### Common Issues

#### "sox: command not found"
```bash
brew install sox
```

#### "whisper: command not found"
```bash
pip install openai-whisper
# or
pip3 install openai-whisper
```

#### Permission denied
```bash
chmod +x record-and-transcribe.sh
chmod +x setup.sh
```

#### No audio input detected
- Check microphone permissions in System Preferences > Security & Privacy > Microphone
- Test microphone with other applications
- Try different audio input device: `sox -d --show-device`

#### Whisper model download fails
- Check internet connection (required for first model download)
- Try a smaller model first: `./record-and-transcribe.sh -m tiny`
- Manual download: `whisper --model base /dev/null` (downloads base model)

#### Low transcription quality
- Use a better microphone or reduce background noise
- Try a larger Whisper model: `--model large`
- Ensure clear speech and proper distance from microphone
- Check audio file quality in recordings/ directory

### Performance Tips

1. **Choose the right model**: Start with `base`, upgrade to `large` if needed
2. **Optimal recording environment**: Quiet room, good microphone
3. **Recording distance**: 6-12 inches from microphone
4. **File management**: Regularly clean old recordings to save disk space

## 🌍 Language Support

Whisper supports 99+ languages. The script auto-detects language, but you can specify:
```bash
# Add language parameter to whisper command in script
whisper audio.wav --language en --model base
```

Common language codes: `en` (English), `es` (Spanish), `fr` (French), `de` (German), `it` (Italian), `pt` (Portuguese), `ja` (Japanese), `zh` (Chinese)

## 🔒 Privacy & Offline Use

- **Completely Offline**: No data sent to external servers
- **Local Processing**: All transcription happens on your machine
- **Your Data Stays Private**: Audio and transcriptions remain on your device

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- Additional audio format support
- GUI interface
- Real-time transcription
- Speaker diarization
- Batch processing

## 📄 License

This project is open source. Feel free to modify and distribute.

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Ensure all dependencies are properly installed
3. Test with a simple recording first
4. Check that your microphone works with other applications

---

**Happy Recording! 🎙️✨** 