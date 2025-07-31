azdo-done() {
  # Check if the current directory is a git repository
  if [ ! -d .git ]; then
    echo "This is not a git repository."
    return 1
  fi

  # Check if pr.md file exists
  if [ ! -f pr.md ]; then
    echo "Error: pr.md file not found. Please provide a pr.md file."
    return 1
  fi

  # Check for required tools
  for tool in pre-commit jq; do
    if ! command -v $tool &> /dev/null; then
      echo "[INFO] $tool not found. Installing via Homebrew..."
      if command -v brew &> /dev/null; then
        brew install $tool
      else
        echo "[ERROR] Homebrew is not installed. Cannot install $tool."
        return 1
      fi
    fi
  done

  # Get the current branch name
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # Check if on master or main branch
  if [[ "$CURRENT_BRANCH" == "master" || "$CURRENT_BRANCH" == "main" ]]; then
    echo "Error: You are on the ${CURRENT_BRANCH} branch. Please switch to a feature branch."
    return 1
  fi

  pre-commit run --all-files
  if [ $? -ne 0 ]; then
    echo "Pre-commit checks failed. Please fix the issues before committing."
    return 1
  fi

  # Function to read commit type
  get_commit_type() {
    read -p "Enter commit type (fix/feat): " commit_type
    if [[ "$commit_type" != "fix" && "$commit_type" != "feat" ]]; then
      echo "Error: Invalid commit type. Please enter 'fix' or 'feat'."
      return 1
    fi
  }

  # Get commit type
  get_commit_type || return 1

  # Ask for commit message
  read -p "Enter commit message: " commit_message

  # Add all changed files except pr.md
  git add -A
  git reset pr.md

  # Create commit
  git commit -m "${commit_type}: ${commit_message}"
  git push --set-upstream origin "$CURRENT_BRANCH"

  # Azure DevOps details
  AZURE_DEVOPS_ORG_URL="https://dev.azure.com/youlend"
  AZURE_DEVOPS_PROJECT_NAME="Youlend-Infrastructure"
  AZURE_DEVOPS_REPO_NAME=$(basename "$PWD")

  # Get or prompt for PAT token
  TOKEN_FILE="$HOME/.azure_devops_pat"
  if [ -f "$TOKEN_FILE" ]; then
    AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN=$(cat "$TOKEN_FILE")
  else
    read -s -p "Enter your Azure DevOps Personal Access Token: " AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN
    echo
    echo "$AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN" > "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
    echo "[INFO] Token saved for future use at $TOKEN_FILE"
  fi

  # Create the pull request
  PR_TITLE="${commit_type}: ${CURRENT_BRANCH}: ${commit_message}"
  PR_DESCRIPTION=$(cat pr.md)

  PR_RESPONSE=$(curl -s -u ":${AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{
          \"sourceRefName\": \"refs/heads/${CURRENT_BRANCH}\",
          \"targetRefName\": \"refs/heads/master\",
          \"title\": \"${PR_TITLE}\",
          \"description\": \"${PR_DESCRIPTION}\",
          \"reviewers\": []
        }" \
    "${AZURE_DEVOPS_ORG_URL}/${AZURE_DEVOPS_PROJECT_NAME}/_apis/git/repositories/${AZURE_DEVOPS_REPO_NAME}/pullrequests?api-version=6.0")

  # Extract PR link
  PR_ID=$(echo "$PR_RESPONSE" | jq -r .pullRequestId)
  if [ "$PR_ID" == "null" ]; then
    echo "Failed to create pull request. Response: ${PR_RESPONSE}"
    return 1
  fi

  PR_LINK="${AZURE_DEVOPS_ORG_URL}/${AZURE_DEVOPS_PROJECT_NAME}/_git/${AZURE_DEVOPS_REPO_NAME}/pullrequest/${PR_ID}"
  echo "✅ Pull Request created: ${PR_LINK}"
}