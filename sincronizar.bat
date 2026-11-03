@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Forzar el cierre temporal de visores locales que bloqueen el PDF
taskkill /f /im acroRd32.exe >nul 2>&1
taskkill /f /im msedge.exe /fi "WINDOWTITLE eq reporte.pdf*" >nul 2>&1

:: Buscar la ruta de Git de forma automática
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: 1. Sincronizar de forma limpia con la nube
"%GIT_EXE%" pull origin main --rebase --autostash

:: Generar un sello de tiempo único basado en la fecha y hora exactas
for /f "tokens=1-4 delims=/ " %%a in ("%DATE%") do set MYDATE=%%c%%b%%a
for /f "tokens=1-3 delims=:." %%a in ("%TIME%") do set MYTIME=%%a%%b%%c
set TIMESTAMP=%MYDATE%_%MYTIME: =0%

:: Crear una copia del PDF con nombre único para evitar la caché
copy /y "reporte.pdf" "reporte_%TIMESTAMP%.pdf" >nul

:: Generar el index.html usando PowerShell para evitar cualquier error de caracteres especiales
powershell -Command "$html = '<!DOCTYPE html><html lang=\"es\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store, must-revalidate\"><meta http-equiv=\"Pragma\" content=\"no-cache\"><meta http-equiv=\"Expires\" content=\"0\"><title>Reporte Rosarios</title><style>body { font-family: Arial, sans-serif; background: #525659; margin: 0; padding: 20px; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; box-sizing: border-box; }.card { background: white; padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.3); max-width: 400px; width: 100%%; }h1 { font-size: 22px; color: #333; margin-bottom: 10px; }p { color: #666; font-size: 14px; margin-bottom: 25px; }.btn { display: block; background: #0078D4; color: white; padding: 16px 20px; text-decoration: none; font-size: 18px; font-weight: bold; border-radius: 8px; margin-bottom: 12px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }.btn:active { background: #005a9e; }</style></head><body><div class=\"card\"><h1>Reporte Actualizado</h1><p>Pulsa el botón para ver la versión más reciente del reporte.</p><a class=\"btn\" href=\"reporte_%TIMESTAMP%.pdf\" target=\"_blank\">Abrir Reporte de Hoy</a></div></body></html>'; Set-Content -Path 'index.html' -Value $html -Encoding UTF8"

:: 2. Empaquetar y enviar de manera segura a GitHub
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion dinamica reporte_%TIMESTAMP%" --allow-empty
"%GIT_EXE%" push origin main --force-with-lease

echo.
echo ========================================================
echo Proceso de sincronizacion finalizado con exito.
echo ========================================================
pause