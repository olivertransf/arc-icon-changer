#!/usr/bin/env bash
set -euo pipefail

# Applies a custom .icns to Arc (dock + in-app icon themes).
# Repo: https://github.com/olivertransf/arc-icon-changer

ARC_APP="${ARC_APP:-/Applications/Arc.app}"
ASSETS_CAR="$ARC_APP/Contents/Resources/ARCClients_BaseAssets.bundle/Contents/Resources/Assets.car"
APP_ICON_ICNS="$ARC_APP/Contents/Resources/AppIcon.icns"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_SRC="$SCRIPT_DIR/ArcIconPatch"
TOOL_BUILD_DIR="$PATCH_SRC/.build/release/ArcIconPatch"
TOOL_BIN="${ARC_ICON_PATCH_BIN:-$TOOL_BUILD_DIR}"

usage() {
    echo "Usage: $0 [--no-quit] <path-to-your-icon.icns>" >&2
    echo "" >&2
    echo "Tip: type ./change-arc-icon.sh  then drag your .icns file into Terminal and press Enter." >&2
    exit 1
}

if ! command -v swift >/dev/null 2>&1; then
    echo "Swift is not installed. On your Mac, install Apple’s developer tools:" >&2
    echo "  1. Open Terminal and run:  xcode-select --install" >&2
    echo "  2. Complete the popup installer, then run this script again." >&2
    exit 1
fi

QUIT_AR=true
while [[ "${1:-}" == -* ]]; do
    case "$1" in
        --no-quit) QUIT_AR=false; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1" >&2; usage ;;
    esac
done

ICNS="${1:-${DEFAULT_ICNS:-}}"
[[ -n "$ICNS" ]] || usage
[[ -f "$ICNS" ]] || { echo "Could not find that file: $ICNS" >&2; exit 1; }
[[ -f "$ASSETS_CAR" ]] || {
    echo "Could not find Arc here: $ARC_APP" >&2
    echo "Install Arc from https://arc.net/ (it should live in Applications)." >&2
    exit 1
}

if ! [[ -x "$TOOL_BIN" ]]; then
    echo "First-time setup: building the helper (may take a minute)…" >&2
    (cd "$PATCH_SRC" && swift build -c release)
fi
[[ -x "$TOOL_BIN" ]] || { echo "Build failed; expected: $TOOL_BIN" >&2; exit 1; }

if $QUIT_AR; then
    if pgrep -x Arc >/dev/null 2>&1; then
        echo "Closing Arc…" >&2
        osascript -e 'tell application "Arc" to quit' || true
        sleep 2
    fi
    if pgrep -x Arc >/dev/null 2>&1; then
        echo "Arc is still open. Close it manually, or run: $0 --no-quit <icon.icns>" >&2
        exit 1
    fi
fi

BACKUP_ROOT="${ARC_ICON_BACKUP_DIR:-$HOME/Downloads}"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP="$BACKUP_ROOT/Arc_icon_backup_$STAMP"
mkdir -p "$BACKUP"
cp "$ASSETS_CAR" "$BACKUP/Assets.car"
cp "$APP_ICON_ICNS" "$BACKUP/AppIcon.icns"
echo "Backup saved: $BACKUP" >&2

cp "$ICNS" "$APP_ICON_ICNS"
xattr -cr "$APP_ICON_ICNS" 2>/dev/null || true

echo "Updating Arc’s icon assets…" >&2
"$TOOL_BIN" "$ASSETS_CAR" "$ICNS"
touch "$ARC_APP"
echo "" >&2
echo "Done. Open Arc again." >&2
echo "If the Dock still shows the old icon, run:  killall Dock" >&2
