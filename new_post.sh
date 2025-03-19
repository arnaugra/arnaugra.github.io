#!/bin/bash

# Cargar las variables del archivo .env
export $(grep -v '^#' .env | xargs)

# Rutas
JSON_FILE="_includes/_data/posts.json"
POSTS_DIR="_includes/posts/contents"

# Generar UUID único
UUID=$(powershell.exe -Command "[guid]::NewGuid().ToString()")
echo "UUID: $UUID"

# Obtener la fecha y hora actual en formato YYYY-MM-DDTHH:MM:SS con la zona horaria
DATE=$(TZ="$TIMEZONE" date +"%Y-%m-%dT%H:%M:%S%:z")
echo "Date: $DATE"

# Pedir el título del post
read -p "Enter the title of the post: " TITLE

# Crear el archivo markdown
POST_FILE="$POSTS_DIR/$UUID.md"
echo "# New post" > "$POST_FILE"

# Modificar el JSON sin jq usando PowerShell
if [ -f "$JSON_FILE" ]; then
    # Leer el archivo JSON y convertir los posts a una lista (ArrayList)
    powershell.exe -Command "
    \$json = Get-Content '$JSON_FILE' | ConvertFrom-Json
    \$newPost = @{
        uuid = '$UUID'
        date = '$DATE'
        title = '$TITLE'
    }
    # Convertir a ArrayList para insertar en el principio
    \$postsList = New-Object System.Collections.ArrayList
    \$json.posts | ForEach-Object { \$postsList.Add(\$_) | Out-Null }
    \$postsList.Insert(0, \$newPost)
    \$json.posts = \$postsList
    \$json | ConvertTo-Json -Depth 3 | Set-Content '$JSON_FILE'
    "
else
    # Si el archivo no existe, crearlo con la estructura base usando PowerShell
    powershell.exe -Command "
    \$newPost = @{
        uuid = '$UUID'
        date = '$DATE'
        title = '$TITLE'
    }
    \$json = @{
        posts = @(\$newPost)
    }
    \$json | ConvertTo-Json -Depth 3 | Set-Content '$JSON_FILE'
    "
fi

# Imprimir mensaje con la URL
echo "file created on: $POSTS_DIR/$UUID.md"

# Fin del script
