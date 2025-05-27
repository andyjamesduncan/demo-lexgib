FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy only critical files first
COPY pyproject.toml poetry.lock README.md ./
RUN poetry config virtualenvs.create false
RUN poetry install --no-root --no-interaction --no-ansi || (echo "❌ Poetry install failed!" && cat /root/.cache/pypoetry/log/* || true)

COPY app ./app
COPY main.py ./

# Port FastAPI will use
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
