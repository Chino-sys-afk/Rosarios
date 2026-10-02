@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Encontrar la ruta exacta de Git de GitHub Desktop de forma limpia
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)

:: Si no lo encuentra en el Escritorio, usa el git global del sistema
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: Ejecutar el flujo de git dentro del proyecto
"%GIT_EXE%" add .
"%GIT_EXE%" commit -m "Actualizacion automatica desde Excel"
"%GIT_EXE%" push origin main

pause
pause
exit