param(
    [string]$Repo = "https://github.com/YANDong247/chn_artisan.git",
    [string]$Branch = "main",
    [string]$Message
)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git is not available in PATH. Install Git first."
    exit 1
}

if (-not $Message) {
    $Message = Read-Host "Commit message"
}

$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes to commit."
    exit 0
}

# Ensure origin exists
try {
    $origin = git remote get-url origin 2>$null
} catch {
    $origin = $null
}

if (-not $origin) {
    Write-Host "Adding origin $Repo"
    git remote add origin $Repo
}

Write-Host "Staging all changes..."
git add -A

Write-Host "Committing with message: $Message"
git commit -m "$Message"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Commit failed or no staged changes."
    exit $LASTEXITCODE
}

Write-Host "Pushing to origin/$Branch..."
git push origin $Branch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Push failed. Check authentication, branch protection, or remote URL."
    exit $LASTEXITCODE
}

Write-Host "Push succeeded."
