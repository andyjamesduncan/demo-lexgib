# Use official Python image
FROM python:3.12-slim

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy only poetry config first, to leverage Docker cache
COPY pyproject.toml poetry.lock ./

# Disable poetry virtualenvs (MUST happen before install)
RUN poetry config virtualenvs.create false

# Install Python dependencies globally
RUN poetry install --no-interaction --no-ansi

# Now copy everything else
COPY . .

# Expose the port used by uvicorn
EXPOSE 8000

# Run your FastAPI app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
