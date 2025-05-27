FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install llama-index llama-index-server fastapi uvicorn python-dotenv

COPY main.py ./main.py
COPY start.sh .
COPY app ./app
COPY components ./components

RUN chmod +x start.sh

EXPOSE 8000

ENTRYPOINT ["./start.sh"]
