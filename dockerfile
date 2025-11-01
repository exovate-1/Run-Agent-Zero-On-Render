# Use a lightweight Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy everything into the container
COPY . .

# Install system dependencies (optional but helps avoid missing build tools)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install all required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Automatically find a startup script
# If run_ui.py exists, use it. If not, fallback to main.py or app.py
CMD if [ -f "run_ui.py" ]; then \
        python3 run_ui.py; \
    elif [ -f "main.py" ]; then \
        python3 main.py; \
    elif [ -f "app.py" ]; then \
        python3 app.py; \
    else \
        echo "❌ No startup file found (run_ui.py, main.py, or app.py)"; exit 1; \
    fi
