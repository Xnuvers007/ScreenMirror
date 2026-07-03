#!/bin/bash
# ============================================================
#  ScreenMirror - adb.sh (Kompatibilitas dengan versi lama)
#  Dibuat oleh Xnuvers007
#  Script ini diteruskan ke screenmirror.sh yang baru
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "  [→] Diteruskan ke screenmirror.sh (versi baru)..."
chmod +x "$SCRIPT_DIR/screenmirror.sh" 2>/dev/null
exec "$SCRIPT_DIR/screenmirror.sh" "$@"
