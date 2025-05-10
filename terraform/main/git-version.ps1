$gitUrl = echo "$(git config --get remote.origin.url | sed -e 's/\.git$//g')/tree/$(git rev-parse HEAD)"
$hash = @{
  git_url = $gitUrl
}
$hash | ConvertTo-Json