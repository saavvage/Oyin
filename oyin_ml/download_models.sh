#!/usr/bin/env bash
# Downloads both GGUF models into ./models/ on a vast.ai host.
# Idempotent: re-running skips files that already exist.
#
# Usage:
#   bash download_models.sh            # downloads both
#   bash download_models.sh gemma4     # only gemma 4
#   bash download_models.sh gemma2     # only your fine-tuned gemma 2 (needs GDRIVE_FILE_ID)

set -euo pipefail

MODELS_DIR="$(cd "$(dirname "$0")" && pwd)/models"
mkdir -p "$MODELS_DIR"

# ---- Gemma 4 26B A4B (MoE) Q4_K_M from HuggingFace -----------------------
GEMMA4_REPO="unsloth/gemma-4-26b-a4b-it-GGUF"
GEMMA4_FILE="gemma-4-26b-a4b-it-Q4_K_M.gguf"

# ---- Your fine-tuned Gemma 2 from Google Drive ---------------------------
# Paste the file ID from your GDrive share link here, e.g.:
#   https://drive.google.com/file/d/<THIS_PART>/view  ->  GDRIVE_FILE_ID="<THIS_PART>"
GDRIVE_FILE_ID=""
GEMMA2_FILE="sports-health-gemma2.gguf"

TARGET="${1:-all}"

ensure_pip_pkg() {
  python3 -c "import $1" 2>/dev/null || pip install --quiet "$2"
}

download_gemma4() {
  local out="$MODELS_DIR/$GEMMA4_FILE"
  if [[ -f "$out" ]]; then
    echo "[skip] $GEMMA4_FILE already exists ($(du -h "$out" | cut -f1))"
    return
  fi
  echo "[download] $GEMMA4_REPO :: $GEMMA4_FILE"
  ensure_pip_pkg huggingface_hub "huggingface_hub[cli]"
  huggingface-cli download "$GEMMA4_REPO" "$GEMMA4_FILE" \
    --local-dir "$MODELS_DIR" --local-dir-use-symlinks False
}

download_gemma2() {
  local out="$MODELS_DIR/$GEMMA2_FILE"
  if [[ -f "$out" ]]; then
    echo "[skip] $GEMMA2_FILE already exists ($(du -h "$out" | cut -f1))"
    return
  fi
  if [[ -z "$GDRIVE_FILE_ID" ]]; then
    echo "[warn] GDRIVE_FILE_ID is empty — edit download_models.sh and paste your GDrive file ID."
    return
  fi
  echo "[download] GDrive ($GDRIVE_FILE_ID) -> $GEMMA2_FILE"
  ensure_pip_pkg gdown gdown
  gdown --id "$GDRIVE_FILE_ID" -O "$out"
}

case "$TARGET" in
  all)    download_gemma4; download_gemma2 ;;
  gemma4) download_gemma4 ;;
  gemma2) download_gemma2 ;;
  *) echo "unknown target: $TARGET (use: all|gemma4|gemma2)"; exit 1 ;;
esac

echo
echo "Models in $MODELS_DIR:"
ls -lh "$MODELS_DIR"/*.gguf 2>/dev/null || echo "  (none yet)"
echo
echo "To pick which one to load, set in .env:"
echo "  MODEL_FILE=$GEMMA4_FILE     # use Gemma 4 (default recommendation)"
echo "  MODEL_FILE=$GEMMA2_FILE     # use your fine-tuned Gemma 2"
