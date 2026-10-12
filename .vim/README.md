# 🚀 Modern Vim Setup & Productivity Guide

Welcome to your modernized **Vim 9** setup! This configuration is designed for maximum speed, intuitive ergonomics, modern aesthetics, project-level development, and seamless AI agent workflows.

---

## 🤖 1. AI Agents & Harnesses Launchpad

All major industry AI coding harnesses are installed on your system and directly launchable inside Vim via the `<Space> a` menu:

| Shortcut | Command | Tool / Description |
| :--- | :--- | :--- |
| `<Space> a g` | `:Agy` | **Antigravity AI Agent (`agy`)**: Full autonomous agent with tool execution. |
| `<Space> a c` | `:Claude` | **Anthropic Claude Code (`claude`)**: Anthropic's official terminal coding agent. |
| `<Space> a d` | `:Aider` | **Aider (`aider`)**: The leading AI pair programmer (supports OpenAI Codex/GPT-4o, Claude, DeepSeek). |
| `<Space> a p` | `:PiAgent` | **Pi Coding Agent (`pi`)**: Autonomous AI agent toolkit. |
| `<Space> a o` | `:Ollama` | **Ollama / DeepSeek (`ollama`)**: Run open-weight models locally (`deepseek-r1`, `deepseek-coder`). |
| `<Space> a s` | `:Copilot status` | **GitHub Copilot**: Inline ghost-text AI completions as you type. |
| `<Space> a m` | `:Copilot panel` | **Copilot Multi-Suggestion Panel**: View multiple code completion suggestions. |

---

## 💻 2. VS Code Extensions & Bridge

### Installed in your Visual Studio Code:
* **`vscodevim.vim`**: Full modal Vim editing (motions, surround, sneak) inside native VS Code.
* **`saoudrizwan.claude-dev` (Cline)**: Autonomous AI coding agent extension.
* **`rooveterinaryinc.roo-cline` (Roo Code)**: Autonomous multi-agent extension.
* **`continue.continue`**: Open-source AI copilot supporting DeepSeek, Claude, and Ollama.
* **`github.copilot-chat`**: Built-in Copilot Chat assistant.

### Bridge Commands:
* `<Space> o c` $\rightarrow$ Open current project folder in Visual Studio Code.
* `<Space> o f` $\rightarrow$ Open active file at cursor line in Visual Studio Code.
* `code .` $\rightarrow$ Launch VS Code from terminal.

---

## 📁 3. Opening Folders & Project Workspaces

* **From your Terminal:**
  * `v .` $\rightarrow$ Opens the current directory. NERDTree automatically opens on the left showing all project files, sets your root directory, and leaves an editor pane ready on the right.
  * `v /path/to/project` $\rightarrow$ Opens any project folder directly.
* **Within Vim:**
  * `<Space> e` $\rightarrow$ Toggle NERDTree sidebar explorer.
  * `<Space> e f` $\rightarrow$ Reveal and locate current file in tree.
  * `<Space> f` $\rightarrow$ Search files across the open folder (`fzf`).
  * `<Space> g` $\rightarrow$ Search project text (`ripgrep`).

---

## 🛠️ Complete Keybindings Cheat Sheet

| Category | Shortcut | Command / Action |
| :--- | :--- | :--- |
| **Guidance** | `<Space> ?` | Open in-editor guide (`:Guide`) |
| | `<Space>` *(0.5s)* | Interactive Which-Key menu |
| | `<Space> s h` | Run system health check (`:VimHealth`) |
| **AI Harnesses** | `<Space> a g` | Launch Antigravity Agent (`:Agy`) |
| | `<Space> a c` | Launch Claude Code (`:Claude`) |
| | `<Space> a d` | Launch Aider Pair Programmer (`:Aider`) |
| | `<Space> a p` | Launch Pi Coding Agent (`:PiAgent`) |
| | `<Space> a o` | Launch Ollama / DeepSeek (`:Ollama`) |
| **VS Code Bridge** | `<Space> o c` | Open current folder in VS Code |
| | `<Space> o f` | Open active file at cursor in VS Code |
| **Terminal Drawer**| `<Space> t` | Toggle bottom terminal drawer |
| **Files & Search** | `<Space> f` / `<C-p>` | Fuzzy find files (`fzf`) |
| | `<Space> g` | Ripgrep project text |
| | `<Space> e` | Toggle file explorer sidebar (`NERDTree`) |
| **Motions** | `s{char}{char}` | Jump to 2 characters on screen (`vim-sneak`) |
| | `<C-d>` / `<C-u>` | Smooth animated scrolling (`vim-smoothie`) |
| **Editing** | `gcc` / `gc` | Toggle comments (`vim-commentary`) |
| | `ysiw"` / `cs"'` / `ds"` | Surround motions (`vim-surround`) |
| | `<C-n>` | Multi-cursor word selection |
| | `<Space> u` | Visual undo tree (`undotree`) |
| | `<Space> r w` | Search & replace word under cursor |
| | `<Space> c f` | Format code via LSP or auto-indent |
| | `<Space> y p` / `y r` / `y n` | Copy full path / relative path / file name |
| **Splits & Windows**| `<Ctrl-h/j/k/l>` | Move to left / down / up / right window |
| | `<Space> v s` / `v v` | Split horizontally / vertically |
| | `<Space> v c` | Close active window |
| **Buffers** | `Shift-L` / `Shift-H` | Next / previous buffer |
| | `<Space> b d` | Close active buffer |
| **Git** | `<Space> g s` | Interactive Git dashboard (`:Git`) |
| | `]c` / `[c` | Jump to next / previous diff hunk |
| | `<Space> g p` | Preview diff hunk at cursor |
| **Workspace** | `<Space> s s` / `s r` | Save / restore session |
| | `<Space> s v` | Reload `~/.vimrc` |
| | `<Space> w` / `q` | Save file / Quit |
