FROM agent0ai/agent-zero:latest

# Make sure we’re in the right working directory
WORKDIR /app

# Expose the Render port
EXPOSE 10000

# Start the Agent Zero web UI manually
CMD ["python3", "run_ui.py", "--host", "0.0.0.0", "--port", "10000"]
