#!/bin/bash

# Git Automation Script
# Usage: ./git-auto.sh "Your commit message"

# Check if commit message is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a commit message"
    echo "Usage: $0 \"Your commit message\""
    exit 1
fi

# Store the commit message
COMMIT_MESSAGE="$1"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if there are any changes to commit
if git diff --quiet && git diff --staged --quiet; then
    echo "No changes to commit"
    exit 0
fi

echo "Starting git automation..."

# Add all changes
echo "Adding all changes..."
git add .

# Check if add was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to add files"
    exit 1
fi

# Commit with the provided message
echo "Committing with message: '$COMMIT_MESSAGE'"
git commit -m "$COMMIT_MESSAGE"

# Check if commit was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to commit changes"
    exit 1
fi

# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Push to current branch
echo "Pushing to current branch: $CURRENT_BRANCH"
git push origin "$CURRENT_BRANCH"

# Check if push was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to push to remote repository"
    exit 1
fi

echo "Git automation completed successfully!"
echo "   - Files added."
echo "   - Committed with message: '$COMMIT_MESSAGE'"
echo "   - Pushed to branch: $CURRENT_BRANCH"