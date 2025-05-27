FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install required Python packages
RUN pip install --upgrade pip
RUN pip install fastapi uvicorn

# Copy the test app and entrypoint script
COPY test_main.py ./main.py
COPY start.sh .

# Make sure the script is executable (in case Docker needs it)
RUN chmod +x start.sh

# Expose the port your app will run on
EXPOSE 8000

# Launch the app using the entrypoint script
ENTRYPOINT ["./start.sh"]