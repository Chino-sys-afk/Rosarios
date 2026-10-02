@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Buscar la ruta de Git de forma directa
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: Comandos rápidos para empaquetar y subir al instante
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion rapida" --allow-empty
"%GIT_EXE%" push origin main --porcelain

pause
exit