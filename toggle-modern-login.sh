#!/bin/bash

# Script para habilitar/deshabilitar el login moderno en Snipe-IT
# Uso: ./toggle-modern-login.sh [enable|disable]

ENV_FILE=".env"
BACKUP_FILE=".env.backup"

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [enable|disable]"
    echo ""
    echo "Comandos:"
    echo "  enable   - Habilita el login moderno"
    echo "  disable  - Deshabilita el login moderno"
    echo "  status   - Muestra el estado actual"
    echo ""
    echo "Ejemplos:"
    echo "  $0 enable   # Habilita el login moderno"
    echo "  $0 disable # Deshabilita el login moderno"
    echo "  $0 status  # Muestra si está habilitado o no"
}

# Función para verificar el estado actual
check_status() {
    if grep -q "^MODERN_LOGIN=true" "$ENV_FILE" 2>/dev/null; then
        echo "✅ Login moderno está HABILITADO"
        return 0
    elif grep -q "^MODERN_LOGIN=false" "$ENV_FILE" 2>/dev/null; then
        echo "❌ Login moderno está DESHABILITADO"
        return 1
    else
        echo "⚠️  Variable MODERN_LOGIN no encontrada (por defecto: DESHABILITADO)"
        return 1
    fi
}

# Función para habilitar el login moderno
enable_modern_login() {
    echo "🔄 Habilitando login moderno..."
    
    # Crear backup del .env
    if [ -f "$ENV_FILE" ]; then
        cp "$ENV_FILE" "$BACKUP_FILE"
        echo "📋 Backup creado: $BACKUP_FILE"
    fi
    
    # Verificar si la línea ya existe
    if grep -q "^MODERN_LOGIN=" "$ENV_FILE" 2>/dev/null; then
        # Reemplazar línea existente
        sed -i 's/^MODERN_LOGIN=.*/MODERN_LOGIN=true/' "$ENV_FILE"
        echo "✏️  Variable MODERN_LOGIN actualizada"
    else
        # Agregar nueva línea
        echo "MODERN_LOGIN=true" >> "$ENV_FILE"
        echo "➕ Variable MODERN_LOGIN agregada"
    fi
    
    echo "✅ Login moderno habilitado exitosamente"
    echo "🔄 Limpiando caché de configuración..."
    php artisan config:clear 2>/dev/null || echo "⚠️  No se pudo limpiar el caché (ejecutar manualmente: php artisan config:clear)"
}

# Función para deshabilitar el login moderno
disable_modern_login() {
    echo "🔄 Deshabilitando login moderno..."
    
    # Crear backup del .env
    if [ -f "$ENV_FILE" ]; then
        cp "$ENV_FILE" "$BACKUP_FILE"
        echo "📋 Backup creado: $BACKUP_FILE"
    fi
    
    # Verificar si la línea existe
    if grep -q "^MODERN_LOGIN=" "$ENV_FILE" 2>/dev/null; then
        # Reemplazar línea existente
        sed -i 's/^MODERN_LOGIN=.*/MODERN_LOGIN=false/' "$ENV_FILE"
        echo "✏️  Variable MODERN_LOGIN actualizada"
    else
        # Agregar nueva línea
        echo "MODERN_LOGIN=false" >> "$ENV_FILE"
        echo "➕ Variable MODERN_LOGIN agregada"
    fi
    
    echo "❌ Login moderno deshabilitado exitosamente"
    echo "🔄 Limpiando caché de configuración..."
    php artisan config:clear 2>/dev/null || echo "⚠️  No se pudo limpiar el caché (ejecutar manualmente: php artisan config:clear)"
}

# Verificar que existe el archivo .env
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: Archivo $ENV_FILE no encontrado"
    echo "💡 Asegúrate de ejecutar este script desde el directorio raíz de Snipe-IT"
    exit 1
fi

# Procesar argumentos
case "${1:-status}" in
    "enable")
        enable_modern_login
        echo ""
        check_status
        ;;
    "disable")
        disable_modern_login
        echo ""
        check_status
        ;;
    "status")
        check_status
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ Comando no reconocido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""
echo "💡 Recuerda que también puedes editar manualmente el archivo .env"
echo "   Agregar o cambiar: MODERN_LOGIN=true (para habilitar) o MODERN_LOGIN=false (para deshabilitar)"
