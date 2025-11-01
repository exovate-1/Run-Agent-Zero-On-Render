# Use Python 3.11 as base
FROM python:3.11-slim

# Set work directory
WORKDIR /app

# Copy everything
COPY . .

# Install system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential findutils && \
    rm -rf /var/lib/apt/lists/*

# Auto-detect and install requirements.txt (searches all subdirectories)
RUN REQ_FILE=$(find /app -type f -name "requirements.txt" | head -n 1) && \
    if [ -n "$REQ_FILE" ]; then \
        echo "📦 Found requirements file at $REQ_FILE"; \
        pip install --no-cache-dir -r "$REQ_FILE"; \
    else \
        echo "⚠️ No requirements.txt found, skipping dependency install."; \
    fi

# Auto-detect and run run_ui.py (searches recursively)
CMD SCRIPT=$(find /app -type f -name "run_ui.py" | head -n 1) && \
    if [ -n "$SCRIPT" ]; then \
        echo "▶️ Starting Agent Zero using $SCRIPT"; \
        python3 "$SCRIPT"; \
    else \
        echo "❌ Could not find run_ui.py. Searching for fallback main/app.py..."; \
        FALLBACK=$(find /app -type f \( -name "main.py" -o -name "app.py" \) | head -n 1); \
        if [ -n "$FALLBACK" ]; then \
            echo "▶️ Running fallback: $FALLBACK"; \
            python3 "$FALLBACK"; \
        else \
            echo "🚨 No startup script found (run_ui.py, main.py, app.py). Exiting."; \
            exit 1; \
        fi; \
    fi
