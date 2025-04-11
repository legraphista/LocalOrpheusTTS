#!/bin/bash
set -e;

# Load environment variables from .env file
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found"
    exit 1
fi

echo "Activating virtual environment..."
source .venv/bin/activate

# Verify activation
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Failed to activate virtual environment. Exiting."
    exit 1
else
    echo "Virtual environment activated successfully."
    # Print Python version for verification
    python --version
fi


# Parse command line arguments
USE_EXISTING_OLLAMA=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --use-existing-ollama)
            USE_EXISTING_OLLAMA=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Start Ollama in the background if not using existing server
if [ "$USE_EXISTING_OLLAMA" = false ]; then
    echo "Starting Ollama server in the background..."
    ollama serve > ollama.log 2>&1 &

    # Store the Ollama process ID
    OLLAMA_PID=$!
    echo "Ollama started with PID: $OLLAMA_PID"

    # Give Ollama a moment to initialize
    sleep 2

    # Check if Ollama is running
    if ps -p $OLLAMA_PID > /dev/null; then
        echo "Ollama server is running successfully"
    else
        echo "Failed to start Ollama server. Check ollama.log for details."
        exit 1
    fi
else
    echo "Using existing Ollama server on port 11434"
    OLLAMA_PID=0
fi

# Pull the Orpheus model if not already downloaded
echo "Ensuring Orpheus model is available..."
MODEL_NAME=${ORPHEUS_MODEL_NAME:-"legraphista/Orpheus:3b-ft-q8"}

echo "Pulling Orpheus model: $MODEL_NAME"

ollama pull $MODEL_NAME

# Make a link from .env to git-modules/Orpheus-FastAPI
if [ ! -f git-modules/Orpheus-FastAPI/.env ]; then
    ln -sf "$(pwd)/.env" "$(pwd)/git-modules/Orpheus-FastAPI/.env"
fi

# Start the Orpheus API server
cd git-modules/Orpheus-FastAPI
# Start the FastAPI server with uvicorn in the background
echo "Starting Orpheus FastAPI server..."
uvicorn app:app --host 0.0.0.0 --port 5005 --reload > ../../orpheus_api.log 2>&1 &

# Store the Orpheus API process ID
ORPHEUS_API_PID=$!
echo "Orpheus API started with PID: $ORPHEUS_API_PID"

# Give the API server a moment to initialize
sleep 2

# Check if the API server is running
if ps -p $ORPHEUS_API_PID > /dev/null; then
    echo "Orpheus API server is running successfully"
else
    echo "Failed to start Orpheus API server. Check orpheus_api.log for details."
    exit 1
fi


# Set up a trap to handle Ctrl+C (SIGINT) and other termination signals
trap cleanup SIGINT SIGTERM EXIT

# Cleanup function to kill all background processes
cleanup() {
    echo "Shutting down services..."
    
    # Kill the Orpheus API server if it's running
    if ps -p $ORPHEUS_API_PID > /dev/null 2>&1; then
        echo "Stopping Orpheus API server (PID: $ORPHEUS_API_PID)..."
        kill -TERM $ORPHEUS_API_PID
    fi
    
    # Kill the Ollama server if it's running and we started it
    if [ "$USE_EXISTING_OLLAMA" = false ] && ps -p $OLLAMA_PID > /dev/null 2>&1; then
        echo "Stopping Ollama server (PID: $OLLAMA_PID)..."
        kill -TERM $OLLAMA_PID
    fi
    
    echo "All services stopped."
    exit 0
}

echo "Services are running. Press Ctrl+C to stop all services."


# Read port from environment variable
PORT=${ORPHEUS_PORT:-5005}

echo "You can now open http://localhost:$PORT to access the interface."
echo "Api docs are available at http://localhost:$PORT/docs"

# Keep the script running until interrupted
wait

