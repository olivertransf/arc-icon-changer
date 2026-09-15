# Arc Icon Changer

Change the **Arc** browser icon on your Mac to any **`.icns`** file—for example one you download from [macOS Icons](https://macosicons.com/).

Arc normally resets custom icons when it starts. This tool updates the icons inside the app itself so your choice sticks (until Arc updates—then run the script again).

---

## Quick start (clone and run)

The **three** Arc `.icns` files live in **`icons/`** in the GitHub repo (no separate download). **Variant 2** (Golden Gate Dark) is the default.

**One line** (needs [Arc](https://arc.net/) in `/Applications/Arc.app` and Xcode Command Line Tools for the first build):

```bash
git clone https://github.com/olivertransf/arc-icon-changer.git && cd arc-icon-changer && bash apply.sh
```

That applies **`icons/arc-icon-variant-2.icns`**. Other bundled icons: `bash apply.sh 1` or `bash apply.sh 3`.

If Arc is not in the default location, set `ARC_APP` before running (example: `export ARC_APP="$HOME/Applications/Arc.app"`).

If the Dock still shows the old icon: `killall Dock`

**Optional:** If `icons/*.icns` are missing, restore from the macOS Icons filenames in **Downloads** with `bash sync-icons-from-downloads.sh`.

---

## Before you start

You need:

1. **Arc** installed (usually in your **Applications** folder). [Get Arc](https://arc.net/).
2. Either use the **bundled** icons with `./apply.sh`, or your own **`.icns`** file with `./change-arc-icon.sh` (see **Custom icon** below).
3. **Terminal** and a **one-time** install of Apple’s developer tools so your Mac can build a small helper (about one minute the first time only).

---

## Get the project

**ZIP:** [this repository on GitHub](https://github.com/olivertransf/arc-icon-changer) → **Code** → **Download ZIP** → unzip → `cd` into the folder.

**Git:**

```bash
git clone https://github.com/olivertransf/arc-icon-changer.git
cd arc-icon-changer
```

---

## Install Apple’s command-line tools (first time only)

1. Open **Terminal** (`Cmd + Space`, type **Terminal**).
2. Run:

   ```bash
   xcode-select --install
   ```

3. Complete the installer if prompted. If tools are already installed, continue.

---

## Bundled icons (`icons/`)

| File | `apply.sh` |
|------|------------|
| `arc-icon-variant-1.icns` | `./apply.sh 1` |
| `arc-icon-variant-2.icns` | `./apply.sh` or `./apply.sh 2` (default: Golden Gate Dark) |
| `arc-icon-variant-3.icns` | `./apply.sh 3` |

`./apply.sh --no-quit` forwards `--no-quit` to `change-arc-icon.sh` (same behavior as the lower-level script).

---

## Custom icon (`change-arc-icon.sh`)

1. Get a **`.icns`** file (for example from [macOS Icons](https://macosicons.com/)).
2. From the project folder:

   ```bash
   chmod +x change-arc-icon.sh
   ./change-arc-icon.sh /path/to/your.icns
   ```

   You can drag the `.icns` into Terminal after `./change-arc-icon.sh ` to paste the path.

3. The **first run** may take **about a minute** while it builds the helper. Later runs are quick.

4. When it says **Done**, open Arc again.

---

## If the Dock shows the old icon

Run this once in Terminal, then check the Dock again:

```bash
killall Dock
```

---

## After Arc updates

When Arc updates, it may replace its app files and your custom icon can disappear. **Run `./apply.sh` again** (or `./change-arc-icon.sh` with the same `.icns` file).

---

## Backups

Each time you run the script, it saves a backup of Arc’s original icon files in your **Downloads** folder, inside a folder named like:

`Arc_icon_backup_YYYYMMDD_HHMMSS`

To fully undo a change, you’d copy those files back into Arc’s app bundle (advanced). For most people, **reinstalling Arc** from the official site is simpler if something goes wrong.

---

## Troubleshooting

| Problem | What to try |
|--------|-------------|
| `swift: command not found` | Complete **Step 3** (`xcode-select --install`). |
| `Could not find Arc` | Install Arc and make sure it’s **`/Applications/Arc.app`**. |
| `Arc is still open` | Quit Arc completely (Cmd+Q), or close all windows and try again. |
| Script won’t run | Run `chmod +x apply.sh change-arc-icon.sh` from inside the project folder. |

---

## Credits

The patch step uses **[PrivateKits](https://github.com/SerenaKit/PrivateKits)** (same technique as the **[Samra](https://github.com/NSAntoine/Samra)** app) to edit Arc’s asset catalog safely. This project is an unofficial helper—not affiliated with The Browser Company.

---

## License

MIT
