function prompt {
  $p = Split-Path -leaf -path (Get-Location)
  $user = $env:UserName
  $host.UI.RawUI.WindowTitle = "@" + $user + "\" + $p + ">"
  $host.UI.RawUI.ForegroundColor = "Blue"

  if (Test-Path .git) {
    $p = Split-Path -leaf -path (Get-Location)
    git branch | ForEach-Object {
      if ($_ -match "^\*(.*)") {
        $branch = $matches[1] + " ) "
        Write-Host -NoNewLine $user -ForegroundColor Magenta
        Write-Host -NoNewLine "@\"
        Write-Host -NoNewLine $p -ForegroundColor Yellow
        Write-Host -NoNewLine " (" -ForegroundColor DarkGreen
        Write-Host -NoNewLine " branch:" -ForegroundColor DarkGreen
        Write-Host -NoNewLine $branch -ForegroundColor DarkGreen
      }
    }
  }
  else {
    Write-Host -NoNewLine $user -ForegroundColor Magenta
    Write-Host -NoNewLine "@\"
    Write-Host -NoNewLine $p -ForegroundColor Yellow
    Write-Host -NoNewLine " " -ForegroundColor Black
  }
  if ($env:PIPENV_ACTIVE -eq 1) {
    # @TODO: works only on Windows
    $venv = (($env:VIRTUAL_ENV -split "\\")[-1] -split "-")[0] + ") "
    Write-Host -NoNewLine "(" -ForegroundColor Cyan
    Write-Host -NoNewLine "env:" -ForegroundColor Cyan
    Write-Host -NoNewLine $venv -ForegroundColor Cyan
  }
  "> "
}

# git alias
function Get-Git { & git $args }
New-Alias -Name g -Value Get-Git -Force -Option AllScope
# git status alias
function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus -Force -Option AllScope
# git commit alias
function Get-GitCommit { & git commit -m $args }
New-Alias -Name gcm -Value Get-GitCommit -Force -Option AllScope
# git add alias
function Get-GitAdd { & git add $args }
New-Alias -Name gad -Value Get-GitAdd -Force -Option AllScope
# git gitree alias
function Get-GitTree { & git log --graph --oneline --decorate $args }
New-Alias -Name gtr -Value Get-GitTree -Force -Option AllScope
# git push alias
function Get-GitPush { & git push origin $args }
New-Alias -Name gps -Value Get-GitPush -Force -Option AllScope
# git pull alias
function Get-GitPull { & git pull origin $args }
New-Alias -Name gpl -Value Get-GitPull -Force -Option AllScope
# git fetch alias
function Get-GitFetch { & git fetch $args }
New-Alias -Name gf -Value Get-GitFetch -Force -Option AllScope
# git checkout alias
function Get-GitCheckout { & git checkout $args }
New-Alias -Name gco -Value Get-GitCheckout -Force -Option AllScope
# git checkout branch alias
function Get-GitCheckoutBranch { & git checkout -b $args }
New-Alias -Name gcob -Value Get-GitCheckoutBranch -Force -Option AllScope
# git branch alias
function Get-GitBranch { & git branch $args }
New-Alias -Name gb -Value Get-GitBranch -Force -Option AllScope
# git remote alias
function Get-GitRemote { & git remote $args }
New-Alias -Name gre -Value Get-GitRemote -Force -Option AllScope
# git clone
function Get-GitClone { & git clone $args }
New-Alias -Name gcl -Value Get-GitClone -Force -Option AllScope
# git stash
function Get-GitStash { & git stash $args }
New-Alias -Name gst -Value Get-GitStash -Force -Option AllScope
# pipenv
function Get-Pipenv { & pipenv $args }
New-Alias -Name pv -Value Get-Pipenv -Force -Option AllScope

# custom env vars
$proj = "C:\Users\crist\Projects"
$learn = "C:\Users\crist\Learning"
$test ="C:\Users\crist\Test"
