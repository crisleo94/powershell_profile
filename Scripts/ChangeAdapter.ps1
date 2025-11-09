# SCRIPT DE CAMBIO DE RED (PowerShell)
# -----------------------------------------------------------------------------------
# Esta función debe ser cargada en el perfil ($PROFILE) usando el operador '.'
# Uso: CambioRed -Red CLARO
# -----------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------
# Configuración Global
# -----------------------------------------------------------------------------------
$ErrorActionPreference = "Stop" 
$RedesDeControl = @("CLARO", "SOMOS")
$AdaptadoresAExcluir = @(
    "vEthernet (Default Switch)", 
    "Ethernet 2" 
)

# -----------------------------------------------------------------------------------
# Funciones Auxiliares
# -----------------------------------------------------------------------------------

# Función para mostrar información detallada de adaptadores
function Show-AdapterDetails {
    param([string[]]$AdapterNames)
    
    foreach ($name in $AdapterNames) {
        $adapter = Get-NetAdapter -Name $name -ErrorAction SilentlyContinue
        if ($adapter) {
            Write-Host "Adaptador: $name" -ForegroundColor Cyan
            Write-Host "  Estado: $($adapter.Status)" -ForegroundColor White
            Write-Host "  Estado Admin: $($adapter.AdminStatus)" -ForegroundColor White
            Write-Host "  Tipo de Interfaz: $($adapter.InterfaceType)" -ForegroundColor White
            Write-Host "  Descripción: $($adapter.InterfaceDescription)" -ForegroundColor White
            Write-Host ""
        } else {
            Write-Host "Adaptador '$name' no encontrado" -ForegroundColor Red
        }
    }
}

# Función para listar los adaptadores disponibles para el control
function Get-ControlNetAdapters {
    # Función usada solo para LISTAR la información, no para cambiar.
    
    Get-NetAdapter | Where-Object { 
        $_.Name -notin $AdaptadoresAExcluir -and
        $_.Virtual -eq $false
    } | Select-Object Name, Status, Description, InterfaceType
}


# -----------------------------------------------------------------------------------
# FUNCIÓN PRINCIPAL EXPORTABLE (Carga en el Perfil)
# -----------------------------------------------------------------------------------
function Change-Adapter {
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("CLARO", "SOMOS")] # Validar que solo se acepta CLARO o SOMOS
        [string]$Red = ""
    )

    # El script usará el valor de $Red pasado en el parámetro.
    
    # 1. Comprobar si se especificó el parámetro -Red
    if (-not $Red) {
        
        # --- MODO LISTAR ---
        Write-Host "--- Redes de Control Disponibles ---" -ForegroundColor Cyan
        Write-Host "Usa: CambioRed -Red [CLARO|SOMOS]"
        Write-Host ""
        
        $ListaControl = Get-ControlNetAdapters
        $RedesAMostrar = $ListaControl | Where-Object {$_.Name -in $RedesDeControl}
        
        if ($RedesAMostrar) {
            $RedesAMostrar | Format-Table Name, Status, Description
            Write-Host "Total de adaptadores controlables: $($RedesAMostrar.Count)" -ForegroundColor Green
        } else {
            Write-Host "No se encontraron las redes de control ('CLARO', 'SOMOS')." -ForegroundColor Red
        }
        
    } else {
        
        # --- MODO CAMBIO ---
        $RedAHabilitar = $Red
        # Encontrar la otra red
        $RedADeshabilitar = $RedesDeControl | Where-Object { $_ -ne $RedAHabilitar } | Select-Object -First 1

        Write-Host "Solicitando cambio a '$RedAHabilitar'..." -ForegroundColor Green
        Write-Host "Nota: Windows solicitará permisos de Administrador para cada cambio." -ForegroundColor Yellow
        
        # 2. Deshabilitar la otra red
        Write-Host "Deshabilitando: '$RedADeshabilitar'..." -ForegroundColor Gray
        try {
            Disable-NetAdapter -Name $RedADeshabilitar -Confirm:$false
            Write-Host "Deshabilitado: '$RedADeshabilitar'" -ForegroundColor Green
        } catch {
            Write-Host "Error al deshabilitar '$RedADeshabilitar': $($_.Exception.Message)" -ForegroundColor Red
        }

        # 3. Habilitar la red solicitada
        Write-Host "Habilitando: '$RedAHabilitar'..." -ForegroundColor Green
        try {
            Enable-NetAdapter -Name $RedAHabilitar -Confirm:$false
            Write-Host "Habilitado: '$RedAHabilitar'" -ForegroundColor Green
        } catch {
            Write-Host "Error al habilitar '$RedAHabilitar': $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # 4. Mostrar el estado final
        Start-Sleep -Milliseconds 1000
        Write-Host ""
        Write-Host "--- Estado Final Detallado ---" -ForegroundColor Cyan
        Show-AdapterDetails -AdapterNames $RedesDeControl
    }
}