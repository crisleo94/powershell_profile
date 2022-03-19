# $date = Get-Date -format "yyyy-MM-dd"

$origin = "$($home + '\AppData\Roaming\.minecraft\saves\*')"
$destination = "$($home + '\OneDrive\Backup\minecraft_worlds_backup.zip')"

# Check if the destination file exists
If (-Not(Test-Path $destination)) {
  try {
    # Compress the folder
    Compress-Archive -Path $origin -CompressionLevel Fastest -Destination $destination
    Write-Host "Minecraft Worlds Backup created successfully"
  }
  catch {
    Write-Error "Minecraft Worlds Backup failed" -ErrorAction Stop
  }
}
Else {
  # If the file exists, update it
  Write-Host "File exists, updating..."
  try {
    Compress-Archive -Path $origin -CompressionLevel Fastest -Destination $destination -Update
    Write-Host "Minecraft Worlds Backup updated successfully"
  }
  catch {
    Write-Error "Minecraft Worlds Backup Update failed" -ErrorAction Stop
  }
}
