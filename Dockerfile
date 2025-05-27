# Use a slim Python base
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# Ensure Python can find your app/ modules
ENV PYTHONPATH=/app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN pip install --upgrade pip
RUN pip install \
    fastapi \
    uvicorn \
    llama-index \
    llama-index-server \
    python-dotenv

# Copy the entrypoint script and make it executable
COPY start.sh .
RUN chmod +x start.sh

# Copy application code into the image
COPY main.py .
COPY app ./app
COPY components ./components

# Expose the port your app will run on
EXPOSE 8000

# Start the app
ENTRYPOINT ["./start.sh"]
