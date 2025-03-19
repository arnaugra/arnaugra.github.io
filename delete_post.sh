#!/bin/bash

# Rutas
JSON_FILE="_includes/_data/posts.json"
POSTS_DIR="_includes/posts/contents"

# Pedir el UUID del post a eliminar
read -p "Enter the UUID of the post to delete: " UUID

# Verificar si el archivo Markdown existe y eliminarlo
POST_FILE="$POSTS_DIR/$UUID.md"
if [ -f "$POST_FILE" ]; then
    rm "$POST_FILE"
    echo "Deleted: $POST_FILE"
else
    echo "Markdown file not found: $POST_FILE"
fi

# Modificar el JSON sin jq usando PowerShell
if [ -f "$JSON_FILE" ]; then
    powershell.exe -Command "
    \$json = Get-Content '$JSON_FILE' -Raw | ConvertFrom-Json
    \$json.posts = @(@(\$json.posts) | Where-Object { \$_.uuid -ne '$UUID' })
    if (-not \$json.posts) { \$json.posts = @() }
    \$json | ConvertTo-Json -Depth 3 | Set-Content '$JSON_FILE'
    "
    echo "Updated: $JSON_FILE"
else
    echo "JSON file not found: $JSON_FILE"
fi

# Fin del script