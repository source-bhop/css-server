#!/bin/bash

echo "🚀 Сервер запущен"
exec "$CSS_DIR/srcds_run" -game cstrike -console -port 27015 +map de_dust2