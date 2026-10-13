# Global Antigravity Agent Configuration & Development Guidelines

## 1. Developer Environment & Philosophy
- **Platform**: macOS (Apple Silicon / Darwin), Shell: Zsh, Multiplexer: Tmux, Terminal: WezTerm.
- **Editors & Tools**: Neovim / Vim (`nvim`), Lazygit (`lg`), Yazi (`y`), Btop (`top`), Ripgrep (`rg`), Fzf.
- **Core Directive**: The developer operates 100% from the keyboard within the terminal. Always prefer terminal commands, TUIs, and CLI flags over any GUI or mouse-driven steps.

## 2. Output & Code Generation Standards (Best Output)
- **Zero Hallucination / Grounding**: Always inspect existing project files, imports, and dependencies before writing code. Never assume package versions or directory structures.
- **Minimal, Surgical Diffs**: Modify only the specific lines or functions required. Never rewrite entire files or erase existing comments, docstrings, and formatting.
- **Verification Discipline**: After editing or creating files, proactively run syntax checks or project tests (e.g., `npm test`, `pytest`, `cargo check`, `tsc --noEmit`) to verify correctness before concluding.
- **Non-Interactive Command Execution**: Always supply non-interactive flags (e.g. `-y`, `--no-interaction`, `-q`) so processes don't stall waiting for confirmation prompts.

## 3. Communication Style
- Be concise, direct, and technically rigorous.
- Format file paths and symbols with markdown links using `file://` scheme.
- Focus on what changed, why, and how to verify it from the terminal.
