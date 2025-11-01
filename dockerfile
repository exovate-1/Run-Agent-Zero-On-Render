# Use a lightweight Python base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy everything to container
COPY . .

# Install system build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Check if requirements.txt exists, then install
RUN if [ -f "requirements.txt" ]; then \
        echo "📦 Installing dependencies from requirements.txt..."; \
        pip install --no-cache-dir -r requirements.txt; \
    else \
        echo "⚠️ No requirements.txt found. Skipping dependency installation."; \
    fi

# Detect and run the main script automatically
CMD if [ -f "run_ui.py" ]; then \
        echo "▶️ Running run_ui.py"; python3 run_ui.py; \
    elif [ -f "main.py" ]; then \
        echo "▶️ Running main.py"; python3 main.py; \
    elif [ -f "app.py" ]; then \
        echo "▶️ Running app.py"; python3 app.py; \
    else \
        echo "❌ No startup file found (run_ui.py, main.py, or app.py)."; exit 1; \
    fi
