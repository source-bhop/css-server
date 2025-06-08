#!/bin/bash

echo "🚀 Сервер запущен"
exec "$CSS_DIR/srcds_run" -game cstrike -console -secure -port 27015 +map de_dust2 +sv_lan 0