export ZSH="$HOME/.oh-my-zsh"
export PATH="/opt/homebrew/bin:$PATH"

ZSH_THEME="xiong-chiamiov-plus"
plugins=(git)
source $ZSH/oh-my-zsh.sh

alias bye-res='git checkout -- "*.resolved"'
alias gs="git status"
alias c="cursor ."
alias reci='git commit --allow-empty -m "Retrigger CI" && ggpush'

# Custom functions
gac() {
  if [ -z "$1" ]; then
    echo "Error: Commit message required."
    return 1 # Exit the function with an error code
  fi

  # Get the current branch name
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  # Extract the prefix before the first '/'
  # Check if there's a '/' in the branch name
  if [[ "$current_branch" == *"/"* ]]; then
    prefix=$(echo "$current_branch" | cut -d'/' -f1)
    # Capitalize the prefix and append a colon
    formatted_prefix="${(U)prefix}: "
  else
    # If no '/', no prefix is added
    formatted_prefix=""
  fi

  # Combine the formatted prefix with the user's commit message
  full_commit_message="${formatted_prefix}$1"

  # Add all changes and commit
  git add .
  git commit -m "$full_commit_message"
}

# Git branch copy function - copies current branch name to clipboard
gbc() {
    local branch_name=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch_name" ]; then
        echo -n "$branch_name" | pbcopy
        echo "Copied branch name to clipboard: $branch_name"
    else
        echo "Error: Not in a git repository or no current branch found"
        return 1
    fi
}

function git-up() {
  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [ -z "$current_branch" ]; then
    echo "Error: Not in a Git repository or no branch checked out."
    return 1
  fi

  echo "Setting upstream for '$current_branch' to 'origin/$current_branch'..."
  git branch --set-upstream-to=origin/"$current_branch" "$current_branch"
  echo "Upstream set successfully!"
}
