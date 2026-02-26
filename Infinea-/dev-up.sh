#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"

export REACT_APP_BACKEND_URL="${REACT_APP_BACKEND_URL:-http://localhost:8001}"

if [ ! -f "$BACKEND_DIR/.env" ]; then
  echo "[dev-up] Missing $BACKEND_DIR/.env"
  echo "[dev-up] Add MONGO_URL, DB_NAME, JWT_SECRET before starting backend."
  exit 1
fi

if [ ! -d "$BACKEND_DIR/.venv" ]; then
  echo "[dev-up] Creating backend virtualenv..."
  python3 -m venv "$BACKEND_DIR/.venv"
fi

echo "[dev-up] Installing backend dependencies (safe to re-run)..."
source "$BACKEND_DIR/.venv/bin/activate"
pip install -q -r "$BACKEND_DIR/requirements.txt"

echo "[dev-up] Starting backend on http://localhost:8001"
(
  cd "$BACKEND_DIR"
  source .venv/bin/activate
  uvicorn server:app --reload --host 0.0.0.0 --port 8001
) &
BACKEND_PID=$!

cleanup() {
  echo "\n[dev-up] Stopping backend (pid=$BACKEND_PID)..."
  kill "$BACKEND_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
  echo "[dev-up] Installing frontend dependencies..."
  (
    cd "$FRONTEND_DIR"
    npm install --legacy-peer-deps
  )
fi

echo "[dev-up] Starting frontend on http://localhost:3000"
cd "$FRONTEND_DIR"
REACT_APP_BACKEND_URL="$REACT_APP_BACKEND_URL" npm start
