@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Buscar la ruta de Git de forma automática
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: Crear un pequeño archivo invisible con la hora exacta para obligar a Vercel a limpiar la caché
echo %DATE% %TIME% > version.txt

:: Sincronización rápida con Git
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion automatica con control de cache" --allow-empty
"%GIT_EXE%" push origin main --porcelain
exit