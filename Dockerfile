# Use slim Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Install pip (no poetry)
RUN pip install --upgrade pip

# Install FastAPI and Uvicorn directly
RUN pip install fastapi uvicorn

# Copy test app file into container
COPY test_main.py ./main.py

# Expose port 8000 to Fly.io proxy
EXPOSE 8000

# Run test app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
