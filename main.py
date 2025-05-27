import logging
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv

from llama_index.server import LlamaIndexServer, UIConfig

from app.settings import init_settings
from app.workflow import create_workflow

logger = logging.getLogger("uvicorn")
load_dotenv()
init_settings()

app = FastAPI()

@app.get("/")
def root():
    return {"message": "🧪 Base FastAPI app is running"}

@app.get("/debug")
def debug():
    return {"status": "✅ FastAPI is live"}

# Mount LlamaIndex UI under a subpath
try:
    llama_server = LlamaIndexServer(
        workflow_factory=create_workflow,
        ui_config=UIConfig(component_dir="components", dev_mode=False),
        logger=logger,
        env="production",
    )
    app.mount("/llama", llama_server)
except Exception as e:
    logger.error(f"Failed to start LlamaIndexServer: {e}")
