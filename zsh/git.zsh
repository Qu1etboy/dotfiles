########################################################
# Git Helper Functions
########################################################

function ga {
  local files
  # 1. Use --color=always to keep the red/green formatting
  # The grep pattern changes slightly to handle hidden ANSI color codes
  local unstaged_list=$(git -c color.status=always status --short | grep -E '^ |^\?')

  if [[ -z "$unstaged_list" ]]; then
    echo "✨ Working tree clean (no unstaged changes)."
    return 0
  fi

  # 2. Run fzf
  # --ansi is the magic flag that renders the colors
  files=(${(f)"$(echo "$unstaged_list" | fzf --multi \
    --ansi \
    --nth 2.. \
    --prompt 'Stage files (TAB to select) ❯ ' \
    --preview 'git diff --color=always {-1} | sed "1,4d"' \
    --preview-window=right:60%)"}) || return

  if [[ -n "$files" ]]; then
    local targets
    targets=()
    for line in $files; do
      # We use 'echo' to strip the ANSI colors before passing to git add
      # and then clean up the git status prefix
      local clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
      targets+=("${clean_line#???}")
    done

    git add "${targets[@]}"
    
    echo "✅ Staged:"
    printf "  - %s\n" "${targets[@]}"
  fi
}

function gr {
  local files
  # 1. Filter for Staged files (Modified, Added, Deleted, Renamed, Copied in the index)
  # The first character is the index status. We look for anything that IS NOT a space.
  local staged_list=$(git -c color.status=always status --short | grep -E '^[^ ?]')

  if [[ -z "$staged_list" ]]; then
    echo "❄️  No staged changes to restore."
    return 0
  fi

  # 2. Run fzf
  # Preview uses --cached to show the diff that is actually staged
  files=(${(f)"$(echo "$staged_list" | fzf --multi \
    --ansi \
    --nth 2.. \
    --prompt 'Unstage files (TAB to select) ❯ ' \
    --preview 'git diff --cached --color=always {-1} | sed "1,4d"' \
    --preview-window=right:60%)"}) || return

  if [[ -n "$files" ]]; then
    local targets
    targets=()
    for line in $files; do
      # Strip ANSI colors and get the filename
      local clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
      targets+=("${clean_line#???}")
    done

    # 3. Use git restore --staged to unstage them
    git restore --staged "${targets[@]}"
    
    echo "🔙 Unstaged:"
    printf "  - %s\n" "${targets[@]}"
  fi
}

# in interactive mode, checkout the selected branch using fzf
function gcb {
  local list_cmd
  local preview_cmd
  
  # 1. Logic for "Opt-in" Remote branches
  # If you pass -r as an argument, include remote branches
  if [[ "$1" == "-r" || "$1" == "--remote" ]]; then
    # Shows both local and remote
    list_cmd="git branch --all --color=always --sort=-committerdate"
  else
    # Shows only local (Default)
    list_cmd="git branch --color=always --sort=-committerdate"
  fi

  # 2. Preview command (handling {1} as the branch name)
  preview_cmd="git log --graph --color=always --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -10 {1}"

  # 3. Run fzf
  local b
  b=$(eval "$list_cmd" | \
    grep -v 'HEAD ->' | \
    fzf --ansi \
        --height 50% \
        --border \
        --layout=reverse \
        --prompt='branch ❯ ' \
        --preview="$preview_cmd" \
        --preview-window=right:65%) || return

  [[ -z "$b" ]] && return

  # 4. Cleanup and Checkout
  # - Removes the '*' or ' ' prefix
  # - Removes 'remotes/origin/' if it's a remote branch
  local target=$(echo "$b" | sed 's/^[* ]*//' | sed 's#remotes/origin/##')
  
  git checkout "$target"
}

# in interactive mode, delete the selected branches using fzf
function gbd {
  local branches
  branches=$(git branch --color=always | grep -v '^\*' | fzf --multi --ansi --preview="git log --oneline --graph --color=always -10 {1}")

  if [[ -n "$branches" ]]; then
    # Remove the whitespace/formatting
    local targets=$(echo "$branches" | sed 's/^[* ]*//')
    echo "$targets" | xargs -n 1 git branch -d
  fi
}

function gsquash {
  # 1. Select the BASE commit (the one you want to keep as the "last good state")
  local base_commit
  base_commit=$(git log --oneline --color=always | \
    fzf --ansi \
        --height 50% \
        --layout=reverse \
        --prompt='Select the BASE commit (squash everything AFTER this) ❯ ' \
        --preview 'git show --stat --color=always {1}') || return

  local hash=$(echo "$base_commit" | awk '{print $1}')

  if [[ -n "$hash" ]]; then
    # 2. Get all the commit messages we are about to squash
    # This gathers all the "short" commit messages between the base and HEAD
    local squash_log=$(git log --format="- %s" ${hash}..HEAD)

    # 3. Soft reset to the base (keeps all your code changes in 'staged' area)
    git reset --soft "$hash"

    # 4. Prepare a new commit with the old messages as the body
    # This opens your editor with a clean summary + the list of squashed commits
    git commit -e -m "Squashed commits:" -m "$squash_log"
    
    echo "✅ Squashed! Your previous messages are in the commit description."
  fi
}

function gcp {
  # 1. Select the source branch
  local source_branch
  source_branch=$(git branch --color=always --sort=-committerdate | grep -v 'HEAD ->' | fzf --ansi --prompt='Source Branch ❯ ' --layout=reverse --height=40%) || return

  # Clean the branch name
  source_branch=$(echo "$source_branch" | sed 's/^[* ]*//' | sed 's#remotes/origin/##')

  # 2. Select the commit(s) from that branch
  # We use -m to allow selecting multiple commits with TAB
  local commits
  commits=$(git log "$source_branch" --oneline --color=always --graph | \
    fzf --ansi \
        --multi \
        --layout=reverse \
        --prompt="Select commits to cherry-pick (TAB to multi-select) ❯ " \
        --preview "git show --stat --color=always {2}" \
        --preview-window=right:60%) || return

  # 3. Extract the hashes (handling the graph lines if present)
  # We use {2} because {1} might be a graph character like | or *
  local hashes=$(echo "$commits" | grep -oE '[a-f0-9]{7,8}' | sed '1!G;h;$!d')

  if [[ -n "$hashes" ]]; then
    echo "🍒 Cherry-picking commits..."
    # xargs runs git cherry-pick for each hash
    echo "$hashes" | xargs -n 1 git cherry-pick
    echo "✅ Done!"
  fi
}
