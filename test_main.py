from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "✅ Basic FastAPI test app is working"}
