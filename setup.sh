#!/bin/bash
set -e;

sudo apt-get install libportaudio2

uv sync

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
fi


# curl -OL https://huggingface.co/lex-au/Orpheus-3b-FT-Q8_0.gguf/resolve/main/Orpheus-3b-FT-Q8_0.gguf
# curl -OL https://github.com/ggml-org/llama.cpp/releases/download/b5117/llama-b5117-bin-ubuntu-x64.zip
# unzip llama-b5117-bin-ubuntu-x64.zip
# rm llama-b5117-bin-ubuntu-x64.zip
# mkdir -p llama-cpp
# mv build/bin/* llama-cpp/
# rm -r build


