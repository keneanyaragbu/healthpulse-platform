#!/bin/bash

cat > .git/hooks/pre-push <<'HOOK'
#!/bin/bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$current_branch" = "main" ] || [ "$current_branch" = "develop" ]; then
  echo "WARNING: You are pushing directly to protected branch: $current_branch"
  echo "Use a feature branch and pull request instead."
fi
HOOK

chmod +x .git/hooks/pre-push

echo "Pre-push hook installed successfully."
