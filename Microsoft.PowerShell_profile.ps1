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
    $venv = (($env:VIRTUAL_ENV -split "\\")[-1] -split "-")[0] + ") "
    Write-Host -NoNewLine "(" -ForegroundColor Cyan
    Write-Host -NoNewLine "env:" -ForegroundColor Cyan
    Write-Host -NoNewLine $venv -ForegroundColor Cyan
  }
  "> "
}

# Define la ruta de la carpeta de scripts
# Usa $PSScriptRoot para hacer que la ruta sea relativa al perfil
$ScriptFolder = Join-Path (Split-Path $PROFILE -Parent) "Scripts"

# Asegúrate de que la carpeta existe
if (Test-Path $ScriptFolder) {
    
    Write-Host "Cargando funciones de la carpeta: $ScriptFolder" -ForegroundColor DarkCyan

    # Busca todos los archivos .ps1 dentro de la carpeta
    Get-ChildItem -Path $ScriptFolder -Filter "*.ps1" | ForEach-Object {
        
        # El operador '.' (punto) importa las funciones al contexto actual (el perfil)
        . $_.FullName 
        
        # Puedes añadir una línea para ver qué scripts se cargan si estás depurando:
        # Write-Host "  > Cargado: $($_.Name)" -ForegroundColor Gray
    }
} else {
    Write-Host "Advertencia: La carpeta de scripts '$ScriptFolder' no fue encontrada." -ForegroundColor Yellow
}

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

#OTHER ALIASES
# pipenv
function Get-Pipenv { & pipenv $args }
New-Alias -Name pv -Value Get-Pipenv -Force -Option AllScope
# hardhat execute
function Get-Hardhat { & npx hardhat $args }
New-Alias -Name hh -Value Get-Hardhat -Force -Option AllScope
# remove folder recursively
function Get-RemoveRecursive { & Remove-Item -Recurse -Force $args }
New-Alias -Name rmrf -Value Get-RemoveRecursive -Force -Option AllScope
# create react parcel app
function Get-CreateReactParcelApp { & npx create-react-parcel-app $args }
New-Alias -Name crpa -Value Get-CreateReactParcelApp -Force -Option AllScope
# create react app
function Get-CreateReactApp { & npx create-react-app $args }
New-Alias -Name cra -Value Get-CreateReactApp -Force -Option AllScope
# open vscode with no videocard support
function Get-CodeGUI { & code --disable-gpu --enable-use-zoom-for-dsf $args }
New-Alias -Name ncd -Value Get-CodeGUI -Force -Option AllScope
# flutter alias
function Get-Flutter { & flutter $args }
New-Alias -Name fl -Value Get-Flutter -Force -Option AllScope


Invoke-Expression (&starship init powershell)
