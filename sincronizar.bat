@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Buscar la ruta de Git de forma automática
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: 1. Sincronizar de forma limpia con la nube
"%GIT_EXE%" pull origin main --rebase --autostash

:: Generar un sello de tiempo único para evitar la memoria caché
for /f "tokens=1-4 delims=/ " %%a in ("%DATE%") do set MYDATE=%%c%%b%%a
for /f "tokens=1-3 delims=:." %%a in ("%TIME%") do set MYTIME=%%a%%b%%c
set TIMESTAMP=%MYDATE%_%MYTIME: =0%

:: Copiar el PDF principal con un nombre limpio
copy /y "reporte.pdf" "reporte_actual.pdf" >nul

:: Crear un index.html con un visor embebido que fuerza a abrirse en la misma pestaña
powershell -Command "$html = '<!DOCTYPE html><html lang=\"es\"><head><meta charset=\"UTF-8\"><meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store, must-revalidate\"><title>Reporte Rosarios</title><style>html, body { margin: 0; padding: 0; height: 100%%; overflow: hidden; background: #525659; }iframe { width: 100%%; height: 100%%; border: none; }</style></head><body><iframe src=\"reporte_actual.pdf?v=%TIMESTAMP%\"></iframe></body></html>'; Set-Content -Path 'index.html' -Value $html -Encoding UTF8"

:: 2. Empaquetar y enviar a GitHub
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion visor embebido %TIMESTAMP%" --allow-empty
"%GIT_EXE%" push origin main --force-with-lease

echo.
echo ========================================================
echo ¡Sincronizacion completada con exito!
echo ========================================================
pause