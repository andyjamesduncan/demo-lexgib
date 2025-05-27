# Use official Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy only files needed to install dependencies
COPY pyproject.toml poetry.lock README.md ./

# Disable Poetry virtualenvs
RUN poetry config virtualenvs.create false

# Install dependencies WITHOUT installing the current app as a package
# If it fails, show the poetry error log
RUN poetry install --no-root --no-interaction --no-ansi || cat /root/.cache/pypoetry/log/* || true

# Copy application code after dependencies are installed
COPY app ./app
COPY main.py ./
COPY components ./components
COPY layout ./layout
COPY output ./output
COPY storage ./storage

# Expose app port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
