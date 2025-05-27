import sys
print("🚀 Starting LlamaIndex server...", file=sys.stderr)

import logging

from dotenv import load_dotenv
from llama_index.server import LlamaIndexServer, UIConfig
from app.settings import init_settings
from app.workflow import create_workflow
from fastapi.staticfiles import StaticFiles

# Setup logging for Uvicorn
logger = logging.getLogger("uvicorn")

# Set the path to your UI components (if customized)
COMPONENT_DIR = "components"

# Load environment variables
load_dotenv()

# Initialize app-specific settings
init_settings()


def create_app():
    app = LlamaIndexServer(
        workflow_factory=create_workflow,
        ui_config=UIConfig(
            component_dir=COMPONENT_DIR,
            dev_mode=False,  # ✅ Set to False for production
        ),
        logger=logger,
        env="production",  # Or use os.getenv("APP_ENV", "production")
    )

    # Health check
    app.add_api_route("/api/health", lambda: {"status": "ok"}, status_code=200)

    # Simple homepage to confirm deployment
    @app.get("/")
    async def root():
        return {"message": "✅ App is live and responding"}

    app.mount("/chat", StaticFiles(directory=".ui", html=True), name="chat-ui")

    return app


# Create the FastAPI app instance
app = create_app()
