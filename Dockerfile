FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# ⬇️ Copy files needed for poetry install — includes your app package
COPY pyproject.toml poetry.lock README.md app/ ./

RUN poetry config virtualenvs.create false
RUN poetry install --no-root --no-interaction --no-ansi

# ⬇️ Now bring in the rest of your files (like main.py, components/, etc.)
COPY . .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
