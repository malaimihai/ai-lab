# Git Utilities

## Prerequisites

These scripts assume ollama is installed and configured locally.
Following models are required:

- `llama3:latest`

## To install generate-commit-msg.sh (Arch)

1. Cd into the directory where `generate-commit-msg.sh` is located.

2. Copy the `generate-commit-msg.sh` script to `~/.local/bin/<COMMAND_NAME>`, e.g. `aicommit`.

   ```bash
   mkdir -p ~/.local/bin && cp generate-commit-msg.sh ~/.local/bin/aicommit
   ```

3. Make the script executable:

   ```bash
   chmod +x ~/.local/bin/aicommit
   ```

4. Add the following line to your `~/.bashrc` or `~/.zshrc` file to ensure `~/.local/bin` is in your PATH:

   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```
