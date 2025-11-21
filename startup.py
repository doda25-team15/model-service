import os
import requests
import joblib

MODEL_DIR = "/app/output"
MODEL_FILE = "model.joblib"
PREPROCESSOR_FILE = "preprocessor.joblib"

MODEL_PATH = os.path.join(MODEL_DIR, MODEL_FILE)
PREPROCESSOR_PATH = os.path.join(MODEL_DIR, PREPROCESSOR_FILE)


MODEL_URL = f"https://github.com/doda25-team15/model-service/releases/latest/download/{MODEL_FILE}"
PREPROCESSOR_URL = f"https://github.com/doda25-team15/model-service/releases/latest/download/{PREPROCESSOR_FILE}"

def ensure_file_available(path: str, url: str):
    """Checks if a file exists. If not, downloads it once."""
    os.makedirs(MODEL_DIR, exist_ok=True)

    if os.path.exists(path):
        print(f" {os.path.basename(path)} found in volume mount.")
        return path

    print(f" No {os.path.basename(path)} found — downloading latest from GitHub Releases…")
    response = requests.get(url)
    if response.status_code != 200:
        raise RuntimeError(f"Failed to download {os.path.basename(path)} from {url}")

    with open(path, "wb") as f:
        f.write(response.content)

    print(f"{os.path.basename(path)} downloaded to: {path}")
    return path

def load_model():
    ensure_file_available(MODEL_PATH, MODEL_URL)
    ensure_file_available(PREPROCESSOR_PATH, PREPROCESSOR_URL)

    print("Loading model and preprocessor…")
    model = joblib.load(MODEL_PATH)
    preprocessor = joblib.load(PREPROCESSOR_PATH)
    return model, preprocessor
