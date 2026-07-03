#!/bin/bash
# ============================================================
#  ScreenMirror - adb.sh (Backward compatibility)
#  Coded by Xnuvers007
#  This script forwards to the new screenmirror.sh
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "  [→] Forwarding to screenmirror.sh (new version)..."
chmod +x "$SCRIPT_DIR/screenmirror.sh" 2>/dev/null
exec "$SCRIPT_DIR/screenmirror.sh" "$@"
