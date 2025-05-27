FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies directly
RUN pip install --upgrade pip
RUN pip install llama-index llama-index-server fastapi uvicorn python-dotenv

# Copy application files
COPY start.sh .
COPY main.py .
COPY app ./app
COPY components ./components

# Ensure the entrypoint script is executable
RUN chmod +x start.sh

# Expose port
EXPOSE 8000

# Start the app
ENTRYPOINT ["./start.sh"]
