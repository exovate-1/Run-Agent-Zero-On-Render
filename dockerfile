# =========================
# Agent Zero Render Dockerfile
# =========================

FROM python:3.11-slim

# Working directory
WORKDIR /app

# Copy everything
COPY . .

# Install system dependencies for heavy packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    curl \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    tesseract-ocr \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Auto-detect requirements.txt; install fallback packages if not found
RUN REQ_FILE=$(find /app -type f -name "requirements.txt" | head -n 1) && \
    if [ -n "$REQ_FILE" ]; then \
        echo "📦 Installing dependencies from $REQ_FILE"; \
        pip install --upgrade pip && pip install --no-cache-dir -r "$REQ_FILE"; \
    else \
        echo "⚠️ No requirements.txt found. Installing default dependencies..."; \
        pip install --upgrade pip && pip install --no-cache-dir \
        a2wsgi==1.10.8 \
        ansio==0.0.1 \
        browser-use==0.5.11 \
        docker==7.1.0 \
        duckduckgo-search==6.1.12 \
        faiss-cpu==1.11.0 \
        fastmcp==2.3.4 \
        fasta2a==0.5.0 \
        flask[async]==3.0.3 \
        flask-basicauth==0.2.0 \
        flaredantic==0.1.4 \
        GitPython==3.1.43 \
        inputimeout==1.0.4 \
        kokoro>=0.9.2 \
        simpleeval==1.0.3 \
        langchain-core==0.3.49 \
        langchain-community==0.3.19 \
        langchain-unstructured[all-docs]==0.1.6 \
        openai-whisper==20240930 \
        lxml_html_clean==0.3.1 \
        markdown==3.7 \
        mcp==1.13.1 \
        newspaper3k==0.2.8 \
        paramiko==3.5.0 \
        playwright==1.52.0 \
        pypdf==6.0.0 \
        python-dotenv==1.1.0 \
        pytz==2024.2 \
        sentence-transformers==3.0.1 \
        tiktoken==0.8.0 \
        unstructured[all-docs]==0.16.23 \
        unstructured-client==0.31.0 \
        webcolors==24.6.0 \
        nest-asyncio==1.6.0 \
        crontab==1.0.1 \
        litellm==1.75.0 \
        markdownify==1.1.0 \
        pymupdf==1.25.3 \
        pytesseract==0.3.13 \
        pdf2image==1.17.0 \
        pathspec>=0.12.1 \
        psutil>=7.0.0 \
        soundfile==0.13.1; \
    fi

# Expose Render port
ENV PORT=10000
EXPOSE 10000

# Only run run_ui.py (auto-detect anywhere)
CMD SCRIPT=$(find /app -type f -name "run_ui.py" | head -n 1) && \
    if [ -n "$SCRIPT" ]; then \
        echo "▶️ Starting Agent Zero using $SCRIPT"; \
        python3 "$SCRIPT" --host 0.0.0.0 --port ${PORT:-10000}; \
    else \
        echo "❌ Could not find run_ui.py. Exiting."; \
        exit 1; \
    fi
