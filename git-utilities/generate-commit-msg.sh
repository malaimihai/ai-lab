#!/bin/bash

MODEL_NAME="llama3:latest"

# 1. Stage all changes
echo "Staging all changes with: git add ."
git add .

# 2. Check if there are any staged changes to commit
if git diff --cached --quiet; then
    echo "No staged changes found. Aborting commit."
    exit 1
fi

# 3. Get the diff of staged changes
DIFF_OUTPUT=$(git diff --cached)

# 4. Construct the prompt
PROMPT=$(cat <<EOF
You are an expert developer assistant.
Analyze the following Git diff and generate a concise, conventional, and clear commit message.
The commit message must be the ONLY output (no preamble, no markdown, no explanation)
Output ONLY the single-line commit message and nothing else.

Diff:
$DIFF_OUTPUT
EOF
)

# 5. Generate the commit message using Ollama
echo "Generating commit message with ${MODEL_NAME}..."
COMMIT_MSG=$(ollama run $MODEL_NAME "${PROMPT}" | tr -d '\n' | sed 's/^"//;s/"$//')

# Basic cleanup (remove leading/trailing whitespace/quotes)
CLEAN_MSG=$(echo "${COMMIT_MSG}" | xargs)

# 6. Final Commit
if [ -n "$CLEAN_MSG" ]; then
    echo "---"
    echo "Generated Message:"
    echo "$CLEAN_MSG"
    echo "---"

    # Pass any arguments from the command line to 'git commit'
    # E.g., 'git aicommit --no-verify' or 'git aicommit -e'
    git commit -m "$CLEAN_MSG" "$@"

    # Check if the commit succeeded
    if [ $? -eq 0 ]; then
        echo "✅ Commit successful: $(git log -1 --pretty=format:%s)"
    else
        echo "❌ Git commit failed. See error above."
        exit 1
    fi
else
    echo "❌ AI failed to generate a commit message. Aborting commit."
    exit 1
fi
