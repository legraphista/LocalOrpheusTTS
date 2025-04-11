# Local Orpheus TTS

You can find the Orpheus TTS project here: https://github.com/canopyai/Orpheus-TTS

This project provides a local text-to-speech (TTS) solution using Orpheus and Ollama. It includes a FastAPI server for TTS inference and integrates with the Ollama model server.

## Prerequisites

- OS
    - Ubuntu/Debian-based Linux system (recommended, tested)
    - Windows WSL (tested)
    - Should work on other systems (macOS, etc.)
- Python 3.10 
    - Recommended to use [pyenv](https://github.com/pyenv/pyenv) if 3.10 is not installed
- Git
- curl

## Setup

1. Clone the repository:
```bash
git clone https://github.com/legraphista/LocalOrpheusTTS.git
cd LocalOrpheusTTS
```

2. Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Install required system dependencies (libportaudio2)
- Install uv package manager if not already installed
- Set up the Python environment using uv
- Install Ollama
- Apply the TTS inference patch to the Orpheus FastAPI engine

## Starting the Services

To start the services, run:
```bash
chmod +x start.sh
./start.sh
```

This will:
- Start the Ollama server (if not already running)
- Pull the required Orpheus model
- Start the Orpheus FastAPI server

### Optional Parameters

- `--use-existing-ollama`: Use an existing Ollama server instead of starting a new one
```bash
./start.sh --use-existing-ollama
```

## Service Information

- Ollama server runs on port 11434
- Orpheus FastAPI server runs on port 5005
- Logs are stored in:
  - `ollama.log` for Ollama server
  - `orpheus_api.log` for Orpheus API server

## Stopping the Services

Press `Ctrl+C` in the terminal where the services are running to gracefully stop all services.

## Environment Configuration

The project uses a `.env` file for configuration. Make sure to set up the following variables:
- `ORPHEUS_MODEL_NAME`: The name of the Orpheus model to use (default: "legraphista/Orpheus:3b-ft-q8")
    - You can find the available models here: https://ollama.com/legraphista/Orpheus/tags

## Troubleshooting

If you encounter any issues:
1. Check the log files for error messages
2. Ensure all prerequisites are installed
3. Verify that the ports 11434 and 5005 are not in use by other services 