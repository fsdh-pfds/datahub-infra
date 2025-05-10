$gitBranch = echo "$(git branch --show-current)"
$hash = @{
  git_branch = $gitBranch
}
$hash | ConvertTo-Json