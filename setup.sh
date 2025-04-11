#!/bin/bash
set -e;

# Check if apt-get exists before using it
if command -v apt-get &> /dev/null; then
    echo "Installing libportaudio2..."
    sudo apt-get install -y libportaudio2
else
    echo "apt-get not found. Please install libportaudio2 manually for your distribution."
    # For non-apt systems, provide guidance for common distributions
    echo "For Fedora/RHEL/CentOS, try: sudo dnf install portaudio-devel"
    echo "For Arch Linux, try: sudo pacman -S portaudio"
    echo "For macOS with Homebrew, try: brew install portaudio"
    
    # Ask user to confirm they've installed the dependency
    read -p "Have you installed the required portaudio dependency? (y/n): " confirm
    if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
        echo "Please install the required dependency before continuing."
        exit 1
    fi
    echo "Continuing with setup..."
fi

# install uv
# Check if uv is already installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add uv to PATH for the current session if it's not already available
    if ! command -v uv &> /dev/null; then
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    
    echo "uv installed successfully."
else
    echo "uv is already installed, skipping installation."
fi

# install python dependencies
uv sync
# install ollama
curl -fsSL https://ollama.com/install.sh | sh

# apply patches
# Apply TTS inference patch
if [ -f "patches/tts_inference.patch" ] && [ -d "git-modules/Orpheus-FastAPI/tts_engine" ]; then
    echo "Applying TTS inference patch..."
    git apply --directory=git-modules/Orpheus-FastAPI patches/tts_inference.patch
    if [ $? -eq 0 ]; then
        echo "TTS inference patch applied successfully."
    else
        echo "Failed to apply TTS inference patch. Please check the patch file and directory structure."
        exit 1
    fi
else
    echo "Warning: Could not find patch file or target directory for TTS inference patch."
    echo "You will have to manually apply the patch to the TTS engine."
    # Ask user to confirm they applied the patch manually
    read -p "Did you manually apply the patch to the TTS engine? (y/n): " confirm
    if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
        echo "Please apply the patch manually before continuing."
        echo "You can find the patch file at patches/tts_inference.patch"
        exit 1
    fi
    echo "Continuing with setup..."
fi

