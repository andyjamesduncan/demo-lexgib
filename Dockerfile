FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y build-essential curl && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN pip install fastapi uvicorn

COPY start.sh .
COPY main.py .

RUN chmod +x start.sh

EXPOSE 8000

ENTRYPOINT ["./start.sh"]
