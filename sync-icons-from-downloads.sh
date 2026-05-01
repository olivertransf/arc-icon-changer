#!/usr/bin/env bash
set -euo pipefail

# Copies the three Arc .icns files from ~/Downloads (original macOS Icons filenames) into icons/.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_DIR="$SCRIPT_DIR/icons"
DL="${DOWNLOADS_DIR:-$HOME/Downloads}"

mkdir -p "$ICON_DIR"

copy_one() {
    local src="$1" dest="$2"
    if [[ ! -f "$src" ]]; then
        echo "Missing: $src" >&2
        return 1
    fi
    cp "$src" "$dest"
    echo "Installed $(basename "$dest")"
}

ERR=0
copy_one "$DL/icnsFile_05011554296b948d8ff7f6d10229d35d_Arc.icns" "$ICON_DIR/arc-icon-variant-1.icns" || ERR=1
copy_one "$DL/icnsFile_b4845df88338de5edf6ddc11863e07aa_Arc.icns" "$ICON_DIR/arc-icon-variant-2.icns" || ERR=1
copy_one "$DL/icnsFile_cc24c8b676f7e8fc0d3d6d24d5346cf2_Arc.icns" "$ICON_DIR/arc-icon-variant-3.icns" || ERR=1

if [[ "$ERR" -ne 0 ]]; then
    echo "" >&2
    echo "Some files were not found in $DL." >&2
    echo "Download Arc icons from https://macosicons.com/ or place .icns files at:" >&2
    echo "  $ICON_DIR/arc-icon-variant-1.icns" >&2
    echo "  $ICON_DIR/arc-icon-variant-2.icns" >&2
    echo "  $ICON_DIR/arc-icon-variant-3.icns" >&2
    exit 1
fi

echo "All bundled icons updated under $ICON_DIR"
