function prompt {
  # get only last folder location
  $p = Split-Path -leaf -path (Get-Location)
  $user = $env:UserName
  $host.UI.RawUI.WindowTitle = "@" + $user + "\" + $p + ">"
  $host.UI.RawUI.ForegroundColor = "Blue"

# detect if the current folder is a git repository in order to show the branch
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
  # checks if you're in a virtual python env and displays it
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
#to create new aliases that might require arguments in any context follow the same pattern
function Get-Git { & git $args }
New-Alias -Name g -Value Get-Git -Force -Option AllScope
function Get-Git-Status { & git status $args }
New-Alias -Name gs -Value Get-Git-Status -Force -Option AllScope
function Get-Git-Log { & git log $args }
New-Alias -Name gl -Value Get-Git-Log -Force -Option AllScope
function Get-Git-Add { & git add $args }
New-Alias -Name gad -Value Get-Git-Add -Force -Option AllScope
function Get-Git-Commit { & git commit $args }
New-Alias -Name gcm -Value Get-Git-Commit -Force -Option AllScope

# python alias
function Get-Python { & python $args }
New-Alias -Name py -Value Get-Python -Force -Option AllScope
function Get-Pipenv { & pipenv $args }
New-Alias -Name pv -Value Get-Pipenv -Force -Option AllScope

# docker alias
function Get-Docker { & docker $args }
New-Alias -Name d -Value Get-Docker -Force -Option AllScope
function Get-Docker-Compose { & docker-compose $args }
New-Alias -Name dc -Value Get-Docker-Compose -Force -Option AllScope

Invoke-Expression (&starship init powershell)
