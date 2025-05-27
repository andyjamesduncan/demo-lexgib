import logging
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv

logger = logging.getLogger("uvicorn")
logger.setLevel(logging.DEBUG)

print("📦 Loading environment...")
load_dotenv()

print("🛠 Initializing settings...")
try:
    from app.settings import init_settings
    init_settings()
except Exception as e:
    print(f"❌ Failed to init settings: {e}")

print("🚀 Creating FastAPI app...")
app = FastAPI()

@app.get("/")
def root():
    return {"message": "🧪 Basic app responding"}

try:
    print("📚 Importing LlamaIndex...")
    from llama_index.server import LlamaIndexServer, UIConfig
    from app.workflow import create_workflow

    print("⚙️ Starting LlamaIndexServer...")
    llama_server = LlamaIndexServer(
        workflow_factory=create_workflow,
        ui_config=UIConfig(component_dir="components", dev_mode=False),
        logger=logger,
        env="production",
    )
    app.mount("/llama", llama_server)
    print("✅ LlamaIndexServer mounted at /llama")
except Exception as e:
    print(f"❌ LlamaIndexServer failed: {e}")
