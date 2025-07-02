# Script de PowerShell para habilitar/deshabilitar el login moderno en Snipe-IT
# Uso: .\Toggle-ModernLogin.ps1 [Enable|Disable|Status]

param(
    [Parameter(Position=0)]
    [ValidateSet("Enable", "Disable", "Status", "Help")]
    [string]$Action = "Status"
)

$EnvFile = ".env"
$BackupFile = ".env.backup"

# Función para mostrar ayuda
function Show-Help {
    Write-Host ""
    Write-Host "Uso: .\Toggle-ModernLogin.ps1 [Enable|Disable|Status|Help]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Comandos:" -ForegroundColor Yellow
    Write-Host "  Enable   - Habilita el login moderno" -ForegroundColor Green
    Write-Host "  Disable  - Deshabilita el login moderno" -ForegroundColor Red
    Write-Host "  Status   - Muestra el estado actual" -ForegroundColor Blue
    Write-Host "  Help     - Muestra esta ayuda" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Ejemplos:" -ForegroundColor Yellow
    Write-Host "  .\Toggle-ModernLogin.ps1 Enable   # Habilita el login moderno"
    Write-Host "  .\Toggle-ModernLogin.ps1 Disable  # Deshabilita el login moderno"
    Write-Host "  .\Toggle-ModernLogin.ps1 Status   # Muestra si está habilitado o no"
    Write-Host ""
}

# Función para verificar el estado actual
function Get-ModernLoginStatus {
    if (Test-Path $EnvFile) {
        $content = Get-Content $EnvFile
        $modernLoginLine = $content | Where-Object { $_ -match "^MODERN_LOGIN=" }
        
        if ($modernLoginLine -match "^MODERN_LOGIN=true") {
            Write-Host "✅ Login moderno está HABILITADO" -ForegroundColor Green
            return $true
        }
        elseif ($modernLoginLine -match "^MODERN_LOGIN=false") {
            Write-Host "❌ Login moderno está DESHABILITADO" -ForegroundColor Red
            return $false
        }
        else {
            Write-Host "⚠️  Variable MODERN_LOGIN no encontrada (por defecto: DESHABILITADO)" -ForegroundColor Yellow
            return $false
        }
    }
    else {
        Write-Host "❌ Archivo .env no encontrado" -ForegroundColor Red
        return $false
    }
}

# Función para habilitar el login moderno
function Enable-ModernLogin {
    Write-Host "🔄 Habilitando login moderno..." -ForegroundColor Cyan
    
    # Crear backup del .env
    if (Test-Path $EnvFile) {
        Copy-Item $EnvFile $BackupFile -Force
        Write-Host "📋 Backup creado: $BackupFile" -ForegroundColor Blue
    }
    
    # Leer contenido actual
    $content = Get-Content $EnvFile -ErrorAction SilentlyContinue
    if (-not $content) { $content = @() }
    
    # Verificar si la línea ya existe
    $lineExists = $false
    for ($i = 0; $i -lt $content.Length; $i++) {
        if ($content[$i] -match "^MODERN_LOGIN=") {
            $content[$i] = "MODERN_LOGIN=true"
            $lineExists = $true
            Write-Host "✏️  Variable MODERN_LOGIN actualizada" -ForegroundColor Green
            break
        }
    }
    
    # Si no existe, agregar nueva línea
    if (-not $lineExists) {
        $content += "MODERN_LOGIN=true"
        Write-Host "➕ Variable MODERN_LOGIN agregada" -ForegroundColor Green
    }
    
    # Escribir de vuelta al archivo
    $content | Set-Content $EnvFile
    
    Write-Host "✅ Login moderno habilitado exitosamente" -ForegroundColor Green
    
    # Limpiar caché de configuración
    Write-Host "🔄 Limpiando caché de configuración..." -ForegroundColor Cyan
    try {
        & php artisan config:clear 2>$null
        Write-Host "✅ Caché limpiado" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  No se pudo limpiar el caché (ejecutar manualmente: php artisan config:clear)" -ForegroundColor Yellow
    }
}

# Función para deshabilitar el login moderno
function Disable-ModernLogin {
    Write-Host "🔄 Deshabilitando login moderno..." -ForegroundColor Cyan
    
    # Crear backup del .env
    if (Test-Path $EnvFile) {
        Copy-Item $EnvFile $BackupFile -Force
        Write-Host "📋 Backup creado: $BackupFile" -ForegroundColor Blue
    }
    
    # Leer contenido actual
    $content = Get-Content $EnvFile -ErrorAction SilentlyContinue
    if (-not $content) { $content = @() }
    
    # Verificar si la línea ya existe
    $lineExists = $false
    for ($i = 0; $i -lt $content.Length; $i++) {
        if ($content[$i] -match "^MODERN_LOGIN=") {
            $content[$i] = "MODERN_LOGIN=false"
            $lineExists = $true
            Write-Host "✏️  Variable MODERN_LOGIN actualizada" -ForegroundColor Green
            break
        }
    }
    
    # Si no existe, agregar nueva línea
    if (-not $lineExists) {
        $content += "MODERN_LOGIN=false"
        Write-Host "➕ Variable MODERN_LOGIN agregada" -ForegroundColor Green
    }
    
    # Escribir de vuelta al archivo
    $content | Set-Content $EnvFile
    
    Write-Host "❌ Login moderno deshabilitado exitosamente" -ForegroundColor Red
    
    # Limpiar caché de configuración
    Write-Host "🔄 Limpiando caché de configuración..." -ForegroundColor Cyan
    try {
        & php artisan config:clear 2>$null
        Write-Host "✅ Caché limpiado" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠️  No se pudo limpiar el caché (ejecutar manualmente: php artisan config:clear)" -ForegroundColor Yellow
    }
}

# Verificar que existe el archivo .env
if (-not (Test-Path $EnvFile)) {
    Write-Host "❌ Error: Archivo $EnvFile no encontrado" -ForegroundColor Red
    Write-Host "💡 Asegúrate de ejecutar este script desde el directorio raíz de Snipe-IT" -ForegroundColor Yellow
    exit 1
}

# Procesar acción
switch ($Action) {
    "Enable" {
        Enable-ModernLogin
        Write-Host ""
        Get-ModernLoginStatus | Out-Null
    }
    "Disable" {
        Disable-ModernLogin
        Write-Host ""
        Get-ModernLoginStatus | Out-Null
    }
    "Status" {
        Get-ModernLoginStatus | Out-Null
    }
    "Help" {
        Show-Help
    }
    default {
        Write-Host "❌ Comando no reconocido: $Action" -ForegroundColor Red
        Show-Help
        exit 1
    }
}

Write-Host ""
Write-Host "💡 Recuerda que también puedes editar manualmente el archivo .env" -ForegroundColor Cyan
Write-Host "   Agregar o cambiar: MODERN_LOGIN=true (para habilitar) o MODERN_LOGIN=false (para deshabilitar)" -ForegroundColor Gray
