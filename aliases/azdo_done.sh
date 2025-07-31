azdo-done() {
  # Check shell compatibility
  if [[ "$SHELL" != */zsh && "$SHELL" != */bash ]]; then
    echo "❌ azdo-done requires Bash or Zsh. You're using: $SHELL"
    echo "👉 Please switch to bash or zsh: e.g., run 'zsh' then try again."
    return 1
  fi

  if [ ! -d .git ]; then
    echo "❌ This is not a git repository."
    return 1
  fi

  if [ ! -f pr.md ]; then
    echo "❌ pr.md file not found. Please provide a pr.md file."
    return 1
  fi

  for tool in jq pre-commit; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      echo "[INFO] Installing missing dependency: $tool"
      if command -v brew >/dev/null 2>&1; then
        brew install "$tool"
      else
        echo "❌ $tool is required but not found, and Homebrew is not available."
        return 1
      fi
    fi
  done

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ "$CURRENT_BRANCH" = "master" ] || [ "$CURRENT_BRANCH" = "main" ]; then
    echo "❌ You are on the ${CURRENT_BRANCH} branch. Please switch to a feature branch."
    return 1
  fi

  pre-commit run --all-files
  if [ $? -ne 0 ]; then
    echo "❌ Pre-commit checks failed. Please fix the issues before committing."
    return 1
  fi

  echo -n "Enter commit type (fix/feat): "
  read commit_type
  if [ "$commit_type" != "fix" ] && [ "$commit_type" != "feat" ]; then
    echo "❌ Invalid commit type. Please enter 'fix' or 'feat'."
    return 1
  fi

  echo -n "Enter commit message: "
  read commit_message

  git add -A
  git reset pr.md
  git commit -m "${commit_type}: ${commit_message}"
  git push --set-upstream origin "$CURRENT_BRANCH"

  AZURE_DEVOPS_ORG_URL="https://dev.azure.com/youlend"
  AZURE_DEVOPS_PROJECT_NAME="Youlend-Infrastructure"
  AZURE_DEVOPS_REPO_NAME=$(basename "$PWD")

  TOKEN_FILE="$HOME/.azure_devops_pat"
  if [ -f "$TOKEN_FILE" ]; then
    AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN=$(cat "$TOKEN_FILE")
  fi

  validate_token() {
    test_url="${AZURE_DEVOPS_ORG_URL}/_apis/projects?api-version=6.0"
    http_status=$(curl -s -o /dev/null -w "%{http_code}" -u ":$AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN" "$test_url")
    [ "$http_status" = "200" ]
  }

  if ! validate_token; then
    echo "⚠️  Your Azure DevOps token is invalid or expired."
    echo -n "Enter a new Azure DevOps Personal Access Token: "
    read -s AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN
    echo
    echo "$AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN" > "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
    echo "[INFO] Token saved to $TOKEN_FILE"

    if ! validate_token; then
      echo "❌ Token is still invalid. Exiting."
      return 1
    fi
  fi

  PR_TITLE="${commit_type}: ${CURRENT_BRANCH}: ${commit_message}"
  PR_DESCRIPTION=$(cat pr.md)

  PR_PAYLOAD="{
    \"sourceRefName\": \"refs/heads/${CURRENT_BRANCH}\",
    \"targetRefName\": \"refs/heads/master\",
    \"title\": \"${PR_TITLE}\",
    \"description\": \"${PR_DESCRIPTION}\",
    \"reviewers\": []
  }"

  PR_RESPONSE=$(curl -s -u ":${AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$PR_PAYLOAD" \
    "${AZURE_DEVOPS_ORG_URL}/${AZURE_DEVOPS_PROJECT_NAME}/_apis/git/repositories/${AZURE_DEVOPS_REPO_NAME}/pullrequests?api-version=6.0")

  PR_ID=$(echo "$PR_RESPONSE" | jq -r .pullRequestId)

  if [ "$PR_ID" = "null" ]; then
    echo "❌ Failed to create pull request. Raw response:"
    echo "$PR_RESPONSE" | jq || echo "$PR_RESPONSE"
    echo "📦 PR Payload was:"
    echo "$PR_PAYLOAD" | jq
    return 1
  fi

  PR_LINK="${AZURE_DEVOPS_ORG_URL}/${AZURE_DEVOPS_PROJECT_NAME}/_git/${AZURE_DEVOPS_REPO_NAME}/pullrequest/${PR_ID}"
  echo "✅ Pull Request created: $PR_LINK"
}