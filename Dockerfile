FROM python:3.12-slim

WORKDIR /app
ENV PYTHONPATH="/app"

# Install build tools
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy pyproject and lock file
COPY pyproject.toml poetry.lock* ./

# Disable Poetry virtualenvs and install
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --no-interaction --no-ansi

# Copy source code
COPY main.py ./
COPY app ./app

# Ensure port is exposed
EXPOSE 8000

# Start the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
