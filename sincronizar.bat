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

:: Copiar el PDF principal con nombre limpio y fijo
copy /y "reporte.pdf" "reporte.pdf" >nul

:: Limpiar cualquier archivo HTML viejo para que no estorbe
if exist index.html del index.html

:: 2. Empaquetar y enviar a GitHub
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion directa de reporte.pdf %TIMESTAMP%" --allow-empty
"%GIT_EXE%" push origin main --force-with-lease

echo.
echo ========================================================
echo ¡Sincronizacion completada con exito!
echo ========================================================
pause