FROM python:3.12-slim

WORKDIR /app

# Install system packages
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy only pyproject + README early
COPY pyproject.toml poetry.lock README.md ./

# Disable Poetry virtualenvs
RUN poetry config virtualenvs.create false

# Print debug info before install
RUN echo "Installing dependencies..." && poetry show || echo "Empty env"

# Install dependencies (with debug on failure)
RUN poetry install --no-root --no-interaction --no-ansi || (echo "❌ Poetry install failed!" && cat /root/.cache/pypoetry/log/* || true)

# Sanity check that uvicorn is installed
RUN echo "✅ Checking for uvicorn:" && which uvicorn || echo "❌ uvicorn NOT found"

# Copy source code
COPY app ./app
COPY main.py ./

# Expose FastAPI port
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
