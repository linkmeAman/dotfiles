# ⚡ Dotfiles: Modern Developer Environment (Zsh, WezTerm & Vim)

A high-performance, aesthetic, and fully calibrated development environment for **macOS** and **Linux**.

---

## 🚀 One-Line Installation (Fresh System)

On any new Mac or Linux machine, clone this repository and run the setup script:

```bash
git clone https://github.com/linkmeAman/dotfiles.git ~/dotfiles && bash ~/dotfiles/install.sh
```

The script will automatically:
- Install Homebrew (if missing on macOS)
- Install core CLI tools: `fzf`, `ripgrep`, `bat`, `eza`, `tlrc` (`tldr`)
- Install **WezTerm** via Homebrew Cask
- Install **Oh My Zsh** & required community plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`)
- Link all configuration files (`~/.zshrc`, `~/.wezterm.lua`, `~/.vimrc`, custom theme, aliases, functions, options)
- Bootstrap Vim plugins via `vim-plug`
- Pre-cache 7,500+ offline `tldr` cheatsheets

---

## 🖥️ 1. WezTerm Terminal Emulator (`wezterm.lua`)

A GPU-accelerated terminal emulator configured for Apple Silicon and modern high-DPI displays.

### Key Capabilities:
* **Dynamic Theme Switching**: Automatically switches between **Tokyo Night** (Dark) and **Tokyo Night Day** (Light) matching your macOS system appearance.
* **Apple Silicon ProMotion**: Configured for buttery-smooth **120Hz** rendering (`max_fps = 120`).
* **Modern Typography**: JetBrains Mono with coding ligatures enabled (`calt`, `clig`, `liga`, `zero`).
* **macOS Window Aesthetics**: Integrated traffic-light window controls, 0.95 opacity, 30 blur, and custom padding.
* **Smart Inactive Panes**: Inactive split panes subtly dim to maintain visual focus on the active buffer.

### Essential WezTerm Shortcuts:
| Action | Shortcut (macOS) | Description |
| :--- | :--- | :--- |
| **Split Horizontal** | <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd> | Split current pane horizontally |
| **Split Vertical** | <kbd>Cmd</kbd> + <kbd>D</kbd> | Split current pane vertically |
| **Navigate Panes** | <kbd>Cmd</kbd> + <kbd>[</kbd> / <kbd>]</kbd> | Cycle through active split panes |
| **Close Pane** | <kbd>Cmd</kbd> + <kbd>W</kbd> | Close active pane or tab |
| **New Tab** | <kbd>Cmd</kbd> + <kbd>T</kbd> | Open a fresh terminal tab |
| **Switch Tabs** | <kbd>Cmd</kbd> + <kbd>1</kbd> - <kbd>9</kbd> | Direct tab switching |
| **Font Zoom** | <kbd>Cmd</kbd> + <kbd>+</kbd> / <kbd>-</kbd> / <kbd>0</kbd> | Increase, decrease, or reset font size |

---

## 📝 2. Modern Vim 9 IDE & AI Launchpad (`vimrc`)

A complete modal IDE configured with pure Vimscript for instantaneous startup, project-level workflows, and seamless AI agent execution.

* **Leader Key**: <kbd>Space</kbd>
* **Interactive Cheatsheet**: Press `<Space> ?` or run `:Guide` inside Vim to view the live in-editor cheat sheet.
* **Auto-Bootstrapping**: Downloads `vim-plug` and synchronizes all plugins on first launch.

### 🤖 Built-In AI Coding Agents Launchpad:
Launch any installed autonomous AI coding agent directly inside an integrated Vim terminal drawer:

| Shortcut | Command | Agent / Description |
| :--- | :--- | :--- |
| `<Space> a g` | `:Agy` | **Antigravity AI Agent (`agy`)**: Autonomous coding agent with tool execution. |
| `<Space> a c` | `:Claude` | **Claude Code (`claude`)**: Anthropic's official terminal coding agent. |
| `<Space> a d` | `:Aider` | **Aider (`aider`)**: AI pair programmer with multi-model support. |
| `<Space> a p` | `:PiAgent` | **Pi Coding Agent (`pi`)**: Autonomous agent toolkit. |
| `<Space> a o` | `:Ollama` | **Ollama / DeepSeek (`ollama`)**: Local open-weight coding LLMs. |
| `<Space> a s` | `:Copilot status` | **GitHub Copilot**: Inline ghost-text AI completions (<kbd>Tab</kbd> to accept). |
| `<Space> a m` | `:Copilot panel` | **Copilot Panel**: View multiple code completion suggestions. |

### 📁 Project Explorer & Search:
* `v .` $\rightarrow$ Open current folder from terminal with NERDTree automatically focused on the left.
* `<Space> e` / <kbd>Ctrl</kbd> + <kbd>N</kbd> $\rightarrow$ Toggle NERDTree file explorer sidebar.
* `<Space> e f` $\rightarrow$ Reveal and highlight the current file in NERDTree.
* `<Space> f` / <kbd>Ctrl</kbd> + <kbd>P</kbd> $\rightarrow$ Fuzzy file finder across the entire repository (`fzf`).
* `<Space> g` $\rightarrow$ Live full-text search with `ripgrep` across project files.
* `<Space> b` $\rightarrow$ Interactive open buffers switcher.

### 🌉 VS Code Bridge Commands:
* `<Space> o c` $\rightarrow$ Open current project folder in Visual Studio Code.
* `<Space> o f` $\rightarrow$ Open active file at exact cursor line in Visual Studio Code.

---

## 🎨 3. Aesthetic `devpro` Prompt Bar

Connected rounded-tree prompt that displays path, git status, live timestamp, and command execution timer without overflowing:

```text
╭─ ~/Projects/my-app git:(main ✔) [2026-10-12 16:00:00] ⏱ 1.4s
╰─❯ 
```
*(If a command fails, turns red: `╰─✖ 1 ❯`)*

- **Bold Path**: Always shows full directory relative to home (`~`)
- **Git Realtime**: Branch name, clean (`✔`), or dirty (`✗`)
- **Execution Timer**: Automatically times any command taking >1.0s (e.g. `npm build`, `cargo run`)
- **No Line Overflow**: 2-line layout keeps typed commands clean and un-truncated

---

## 🛠️ 4. Supercharged CLI Tools & Shortcuts

### 🧠 Command Understanding & Learning
* **`tldr <cmd>`** — Concise, practical real-world command usage (e.g., `tldr tar`, `tldr curl`).
* **`explain '<cmd>'`** — Opens [explainshell.com](https://explainshell.com) to visually dissect every argument and flag.
* **`why <alias_or_cmd>`** — Reveals the underlying code/definition of any command or alias.
* **`cheat <cmd>`** — Instant cheatsheet lookup from cheat.sh.

### ⚡ Modern File Tools (`bat` & `eza`)
* **`cat <file>` / `preview <file>`** — Syntax-highlighted code viewer with line numbers and Git modifications.
* **`l` / `ll`** — Fast, colorful directory listing with file icons and Git status indicators.
* **`lt`** — 2-level directory tree view with file icons.

### 🔍 Fuzzy Finder (`fzf` + `ripgrep`)
* **<kbd>Ctrl</kbd> + <kbd>R</kbd>** — Interactive fuzzy search through entire command history.
* **<kbd>Ctrl</kbd> + <kbd>T</kbd>** — Fuzzy file finder with **live syntax-highlighted preview pane** (`bat`).
* **<kbd>Alt/Option</kbd> + <kbd>C</kbd>** — Fuzzy folder switcher with **live tree preview pane** (`eza`).
* **`**<Tab>`** — Fuzzy argument completion (e.g. `cd **<Tab>`, `kill **<Tab>`).

### ⏩ Typing Speed & Quality of Life
* **Autosuggestion Word-by-Word**: Press <kbd>Option</kbd> + <kbd>→</kbd> to accept ghost text word-by-word.
* **Autosuggestion Full Accept**: Press <kbd>→</kbd> or <kbd>Ctrl</kbd> + <kbd>Space</kbd> / <kbd>Ctrl</kbd> + <kbd>F</kbd>.
* **Typo Correction (`CORRECT`)**: Suggests corrections for mistyped commands before failing.
* **Global Pipe Shortcuts**:
  - `... G <query>` ➔ `| grep -i <query>`
  - `... C` ➔ `| pbcopy` *(copies output to Mac clipboard)*
  - `... H` / `... T` ➔ `| head -n 20` / `| tail -n 20`
  - `... L` / `... W` ➔ `| less` / `| wc -l`

### 🧰 Developer Helper Functions
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
├── README.md                      # Comprehensive documentation & shortcuts
├── install.sh                     # Automated one-step setup script
├── zshrc                          # Calibrated ~/.zshrc configuration
├── wezterm.lua                    # GPU-accelerated terminal emulator configuration
├── vimrc                          # Modern Vim 9 IDE & AI agent launchpad
├── .vim/                          # Vim documentation & guides
│   ├── GUIDE.txt                  # In-editor interactive cheatsheet (:Guide)
│   └── README.md                  # Comprehensive Vim workflow guide
└── custom/
    ├── aliases.zsh                # Modern shortcuts & global pipes
    ├── dev_options.zsh            # FZF previews, autosuggestions, history
    ├── functions.zsh              # Developer helper functions & help dashboard
    └── themes/
        └── devpro.zsh-theme       # Connected aesthetic prompt bar
```
