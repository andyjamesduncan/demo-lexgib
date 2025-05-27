# Use official Python 3.12 slim image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy project files
COPY . .

# Install dependencies via Poetry (no virtualenvs)
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Expose the default FastAPI port
EXPOSE 8000

# Command to run your FastAPI app in production
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

