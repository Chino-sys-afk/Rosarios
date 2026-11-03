@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

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

:: Generar un index.html con redirección automática instantánea al PDF del día
powershell -Command "$html = '<!DOCTYPE html><html lang=\"es\"><head><meta charset=\"UTF-8\"><meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store, must-revalidate\"><meta http-equiv=\"Pragma\" content=\"no-cache\"><meta http-equiv=\"Expires\" content=\"0\"><meta http-equiv=\"refresh\" content=\"0;url=reporte_%TIMESTAMP%.pdf\"><title>Abriendo Reporte...</title><script>window.location.replace(\"reporte_%TIMESTAMP%.pdf\");</script></head><body style=\"font-family: Arial; text-align: center; padding-top: 100px; background: #525659; color: white;\"><h2>Abriendo el reporte actualizado...</h2><p><a href=\"reporte_%TIMESTAMP%.pdf\" style=\"color: #85c1e9;\">Pulsa aquí si no se abre automáticamente</a></p></body></html>'; Set-Content -Path 'index.html' -Value $html -Encoding UTF8"

:: 2. Empaquetar y enviar de manera segura a GitHub
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion automatica reporte_%TIMESTAMP%" --allow-empty
"%GIT_EXE%" push origin main --force-with-lease

echo.
echo ========================================================
echo Sincronizacion y redireccion automatica listas.
echo ========================================================
pause