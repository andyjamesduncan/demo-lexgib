import logging
from dotenv import load_dotenv
from llama_index.server import LlamaIndexServer, UIConfig
from fastapi.staticfiles import StaticFiles
from app.settings import init_settings
from app.workflow import create_workflow

logger = logging.getLogger("uvicorn")
COMPONENT_DIR = "components"

load_dotenv()
init_settings()

def create_app():
    app = LlamaIndexServer(
        workflow_factory=create_workflow,
        ui_config=UIConfig(
            component_dir=COMPONENT_DIR,
            dev_mode=False,
        ),
        logger=logger,
        env="production",
    )

    @app.get("/")
    async def root():
        return {"message": "✅ LlamaIndex server is running"}

    app.mount("/chat", StaticFiles(directory=".ui", html=True), name="chat-ui")
    return app

app = create_app()
