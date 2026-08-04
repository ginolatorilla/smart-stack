#!/bin/bash

# Script to set up ~/.agents/skills directory and create symlinks to skill folders

set -e  # Exit on any error

echo "Setting up ~/.agents/skills directory..."

# Create the agents directory if it doesn't exist
mkdir -p ~/.agents/skills

echo "Created ~/.agents/skills directory"

# List of skill folders to symlink
SKILL_FOLDERS=(
    "arch-docs"
    "create-arch-proposal" 
    "merge-arch-proposals"
    "my-writing-style"
    "api-contract-designer"
    "project-planning"
)

# Create symlinks for each skill folder
for skill_folder in "${SKILL_FOLDERS[@]}"; do
    if [ -d "$skill_folder" ]; then
        echo "Creating symlink for $skill_folder..."
        ln -sf "$PWD/$skill_folder" ~/.agents/skills/
    else
        echo "Warning: $skill_folder directory not found"
    fi
done

echo "Installation complete!"
echo "Skills are now available in ~/.agents/skills/"