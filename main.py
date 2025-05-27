from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "✅ FastAPI is listening on 0.0.0.0:8000"}
