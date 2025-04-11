# Local TTS Project

This project provides a local text-to-speech (TTS) solution using Orpheus and Ollama. It includes a FastAPI server for TTS inference and integrates with the Ollama model server.

## Prerequisites

- Ubuntu/Debian-based Linux system
- Python 3.10
- uv
- Git
- curl
- libportaudio2

## Setup

1. Clone the repository:
```bash
git clone https://github.com/legraphista/LocalOrpheus.git
cd LocalOrpheus
```

2. Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Install required system dependencies
- Set up the Python environment using uv
- Install Ollama
- Apply necessary patches to the TTS engine

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

## Troubleshooting

If you encounter any issues:
1. Check the log files for error messages
2. Ensure all prerequisites are installed
3. Verify that the ports 11434 and 5005 are not in use by other services 