# Arc Icon Changer

Change the **Arc** browser icon on your Mac to any **`.icns`** file—for example one you download from [macOS Icons](https://macosicons.com/).

Arc normally resets custom icons when it starts. This tool updates the icons inside the app itself so your choice sticks (until Arc updates—then run the script again).

---

## Before you start

You need:

1. **Arc** installed (usually in your **Applications** folder). [Get Arc](https://arc.net/).
2. **A `.icns` icon file** (not a normal `.png`—see step 1 below).
3. **Terminal** (built into macOS) and a **one-time install** of Apple’s developer tools so your Mac can build a small helper (about one minute the first time only).

---

## Step 1 — Get an icon file (`.icns`)

1. Open **[macOS Icons](https://macosicons.com/)** in your browser.
2. Search for **Arc** (or any app you like).
3. Download the icon. The site gives you an **`.icns`** file—often in your **Downloads** folder.
4. Leave the file where it is for now (Downloads is fine). You’ll point the script at it in step 4.

---

## Step 2 — Download this project

**Easy way (no Git):**

1. Open **[this repository on GitHub](https://github.com/olivertransf/arc-icon-changer)**.
2. Click the green **Code** button → **Download ZIP**.
3. Unzip it (double-click). You’ll get a folder like **`arc-icon-changer-main`**.  
   Move it somewhere easy to find, for example your **Desktop** or **Documents**.

**If you use Git:**

```bash
git clone https://github.com/olivertransf/arc-icon-changer.git
cd arc-icon-changer
```

---

## Step 3 — Install Apple’s command-line tools (first time only)

1. Open **Terminal** (Spotlight: press `Cmd + Space`, type **Terminal**, press Enter).
2. Paste this line and press **Enter**:

   ```bash
   xcode-select --install
   ```

3. If a window appears, click **Install** and wait until it finishes.
4. If it says the tools are **already installed**, you’re good—continue to step 4.

---

## Step 4 — Run the script

1. In **Terminal**, go to the project folder.  
   **Easy trick:** type `cd ` (with a space after `cd`), then **drag the folder** from Finder into the Terminal window, then press **Enter**.

   Example (your path will look different):

   ```bash
   cd ~/Desktop/arc-icon-changer-main
   ```

2. Allow the script to run (first time only):

   ```bash
   chmod +x change-arc-icon.sh
   ```

3. Start the command, then add your icon path by **dragging the `.icns` file** into Terminal (this pastes the full path):

   ```bash
   ./change-arc-icon.sh 
   ```

   After `./change-arc-icon.sh ` (note the space at the end), drag your **`something.icns`** file from Finder into Terminal, then press **Enter**.

4. The **first run** may take **about a minute** while it builds a small helper. Later runs are quick.

5. When it says **Done**, **open Arc** again. You should see your new icon.

---

## If the Dock shows the old icon

Run this once in Terminal, then check the Dock again:

```bash
killall Dock
```

---

## After Arc updates

When Arc updates, it may replace its app files and your custom icon can disappear. **Run step 4 again** with the same `.icns` file.

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
| Script won’t run | Make sure you ran `chmod +x change-arc-icon.sh` from inside the project folder. |

---

## Credits

The patch step uses **[PrivateKits](https://github.com/SerenaKit/PrivateKits)** (same technique as the **[Samra](https://github.com/NSAntoine/Samra)** app) to edit Arc’s asset catalog safely. This project is an unofficial helper—not affiliated with The Browser Company.

---

## License

MIT
