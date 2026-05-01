#!/usr/bin/env bash
set -euo pipefail

# One-shot entry point: applies bundled variant 2 by default, or variant 1-3 / a custom .icns path.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_DIR="$SCRIPT_DIR/icons"

usage() {
    cat >&2 <<'USAGE'
Usage: apply.sh [--no-quit] [1|2|3|/path/to/icon.icns]

  (no extra args)  Apply bundled variant 2 (default).

  1, 2, or 3       Apply icons/arc-icon-variant-N.icns.

  /path/to/icon    Any .icns file (same as change-arc-icon.sh).

  --no-quit        Do not quit Arc first.

If the Dock still shows the old icon: killall Dock
USAGE
    exit 1
}

NO_QUIT=false
while [[ "${1:-}" == -* ]]; do
    case "$1" in
        -h|--help) usage ;;
        --no-quit)
            NO_QUIT=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            ;;
    esac
done

if [[ $# -eq 0 ]]; then
    ICNS="$ICON_DIR/arc-icon-variant-2.icns"
elif [[ "$1" =~ ^[123]$ ]]; then
    ICNS="$ICON_DIR/arc-icon-variant-$1.icns"
elif [[ -f "$1" ]]; then
    ICNS="$1"
else
    echo "Not a file or variant 1-3: $1" >&2
    exit 1
fi

if [[ ! -f "$ICNS" ]]; then
    echo "Missing icon file: $ICNS" >&2
    echo "If icons are missing, run: ./sync-icons-from-downloads.sh" >&2
    exit 1
fi

if $NO_QUIT; then
    exec "$SCRIPT_DIR/change-arc-icon.sh" --no-quit "$ICNS"
else
    exec "$SCRIPT_DIR/change-arc-icon.sh" "$ICNS"
fi
