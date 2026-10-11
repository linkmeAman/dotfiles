# ⚡ Dotfiles & Modern Developer Zsh Configuration

A high-performance, aesthetic, and fully calibrated **Zsh & Oh My Zsh** developer environment for macOS and Linux.

---

## 🚀 One-Line Installation (Fresh System)

On any new Mac or Linux machine, clone this repository and run the setup script:

```bash
git clone https://github.com/linkmeAman/dotfiles.git ~/dotfiles && bash ~/dotfiles/install.sh
```

The script will automatically:
- Install Homebrew (if missing on macOS)
- Install core CLI tools: `fzf`, `ripgrep`, `bat`, `eza`, `tlrc` (`tldr`)
- Install Oh My Zsh & required community plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`)
- Link all configuration files (`~/.zshrc`, custom theme, aliases, functions, options)
- Pre-cache 7,500+ offline `tldr` cheatsheets

---

## 🎨 Aesthetic `devpro` Prompt Bar

Connected rounded-tree prompt that shows path, git status, live timestamp, and command execution timer without overflowing:

```text
╭─ ~/Projects/my-app git:(main ✔) [2026-10-11 21:30:00] ⏱ 1.4s
╰─❯ 
```
*(If a command fails, turns red: `╰─✖ 1 ❯`)*

- **Bold Path**: Always shows full directory relative to home (`~`)
- **Git Realtime**: Branch name, clean (`✔`), or dirty (`✗`)
- **Execution Timer**: Automatically times any command taking >1.0s (e.g. `npm build`, `cargo run`)
- **No Line Overflow**: 2-line layout keeps typed commands clean and un-truncated

---

## 🛠️ Supercharged Tools & Features

### 1. 🧠 Command Understanding & Learning
* **`tldr <cmd>`** — Concise, practical real-world command usage (e.g., `tldr tar`, `tldr curl`).
* **`explain '<cmd>'`** — Opens [explainshell.com](https://explainshell.com) to visually dissect every argument and flag.
* **`why <alias_or_cmd>`** — Reveals the underlying code/definition of any command or alias.
* **`cheat <cmd>`** — Instant cheatsheet lookup from cheat.sh.

### 2. ⚡ Modern File Tools (`bat` & `eza`)
* **`cat <file>` / `preview <file>`** — Syntax-highlighted code viewer with line numbers and Git modifications.
* **`l` / `ll`** — Fast, colorful directory listing with file icons and Git status indicators.
* **`lt`** — 2-level directory tree view with file icons.

### 3. 🔍 Fuzzy Finder (`fzf` + `ripgrep`)
* **<kbd>Ctrl</kbd> + <kbd>R</kbd>** — Interactive fuzzy search through entire command history.
* **<kbd>Ctrl</kbd> + <kbd>T</kbd>** — Fuzzy file finder with **live syntax-highlighted preview pane** (`bat`).
* **<kbd>Alt/Option</kbd> + <kbd>C</kbd>** — Fuzzy folder switcher with **live tree preview pane** (`eza`).
* **`**<Tab>`** — Fuzzy argument completion (e.g. `cd **<Tab>`, `kill **<Tab>`).

### 4. ⏩ Typing Speed & Quality of Life
* **Autosuggestion Word-by-Word**: Press <kbd>Option</kbd> + <kbd>→</kbd> to accept ghost text word-by-word.
* **Autosuggestion Full Accept**: Press <kbd>→</kbd> or <kbd>Ctrl</kbd> + <kbd>Space</kbd> / <kbd>Ctrl</kbd> + <kbd>F</kbd>.
* **Typo Correction (`CORRECT`)**: Suggests corrections for mistyped commands before failing.
* **Global Pipe Shortcuts**:
  - `... G <query>` ➔ `| grep -i <query>`
  - `... C` ➔ `| pbcopy` *(copies output to Mac clipboard)*
  - `... H` / `... T` ➔ `| head -n 20` / `| tail -n 20`
  - `... L` / `... W` ➔ `| less` / `| wc -l`

### 5. 🧰 Developer Helper Functions
* **`killport <port>`** — Kill whatever process is occupying a port (e.g. `killport 3000`).
* **`serve [port]`** — Start an instant local HTTP web server in current directory.
* **`up [n]`** — Navigate up `n` directories at once (`up 3` = `cd ../../..`).
* **`mkcd <dir>`** — Create directory and immediately cd into it.
* **`cdtemp`** — Jump into a fresh scratch directory in `/tmp`.
* **`groot`** — Jump straight to the Git repository root.
* **`glog`** — Color-coded ASCII Git graph log.
* **`gundo`** — Safely undo the last commit while keeping files staged.
* **`nah`** — Discard all local uncommitted changes and clean untracked files.
* **`json <string|file>`** — Format and prettify JSON.
* **`calc '<expression>'`** — Fast terminal math calculator.
* **`myip`** — Show both LAN IP and public WAN IP.
* **`help` / `zhelp`** — Interactive in-terminal cheatsheet dashboard.

---

## 📁 Repository Structure

```text
dotfiles/
├── .gitignore
├── README.md
├── install.sh                  # Automated one-step setup script
├── zshrc                       # Clean ~/.zshrc configuration
└── custom/
    ├── aliases.zsh             # Modern shortcuts & global pipes
    ├── dev_options.zsh         # FZF previews, autosuggestions, history
    ├── functions.zsh           # Developer helper functions & help dashboard
    └── themes/
        └── devpro.zsh-theme    # Connected aesthetic prompt bar
```
