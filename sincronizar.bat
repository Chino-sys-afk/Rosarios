@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Buscar la ruta de Git de forma automática
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: Forzar actualización limpia
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion de reporte" --allow-empty
"%GIT_EXE%" push origin main --porcelain
exit