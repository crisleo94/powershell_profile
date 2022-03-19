if (-not (Test-Path "C:\Users\crist\OneDrive\Backup\.minecraft\saves" -PathType Container)) {
  try {
    Copy-Item "C:\Users\crist\AppData\Roaming\.minecraft\saves" -Destination "C:\Users\crist\OneDrive\Backup\.minecraft" -Recurse
  } catch {
    Write-Error -Message "Unable to make the backup: $_" -ErrorAction Stop
  }
  "Minecraft saves folder backup mas been made sucessfully"
  
} else {
  try {
    Move-Item "C:\Users\crist\OneDrive\Backup\.minecraft\saves" -Destination "C:\Users\crist\Backup"
    if(Test-Path "C:\Users\crist\Backup" -PathType Container) {
      Remove-Item "C:\Users\crist\Backup\*" -Recurse -Force
    }
  } catch {
    Write-Error -Message "Unable to remove the folder: $_" -ErrorAction Stop
  }
  "The directory was deleted!"
}
