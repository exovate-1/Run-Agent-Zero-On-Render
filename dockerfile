# Use the official Agent Zero base image
FROM agent0ai/agent-zero:latest

# Default working directory (Render expects something like this)
WORKDIR /

# Expose Render's port
ENV PORT=10000
EXPOSE 10000

# Entrypoint script that auto-finds the correct launch file
RUN echo '#!/bin/bash' > /start-agent.sh && \
    echo 'set -e' >> /start-agent.sh && \
    echo 'echo "🔍 Searching for Agent Zero startup file..."' >> /start-agent.sh && \
    echo 'START_SCRIPT=$(find / -type f -name "run_ui.py" 2>/dev/null | head -n 1)' >> /start-agent.sh && \
    echo 'if [ -z "$START_SCRIPT" ]; then' >> /start-agent.sh && \
    echo '  START_SCRIPT=$(find / -type f -name "main.py" 2>/dev/null | head -n 1)' >> /start-agent.sh && \
    echo 'fi' >> /start-agent.sh && \
    echo 'if [ -z "$START_SCRIPT" ]; then' >> /start-agent.sh && \
    echo '  echo "❌ Could not find a startup script (run_ui.py or main.py)."' >> /start-agent.sh && \
    echo '  echo "Contents of root directory:"' >> /start-agent.sh && \
    echo '  ls -la /' >> /start-agent.sh && \
    echo '  exit 1' >> /start-agent.sh && \
    echo 'fi' >> /start-agent.sh && \
    echo 'echo "✅ Found startup script: $START_SCRIPT"' >> /start-agent.sh && \
    echo 'exec python3 "$START_SCRIPT" --host 0.0.0.0 --port ${PORT:-10000}' >> /start-agent.sh && \
    chmod +x /start-agent.sh

# Run the script
CMD ["/bin/bash", "/start-agent.sh"]
