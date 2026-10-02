@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Buscar la ruta de Git
for /d %%i in ("C:\Users\jose_\AppData\Local\GitHubDesktop\app-*") do (
    if exist "%%i\resources\app\git\cmd\git.exe" set "GIT_EXE=%%i\resources\app\git\cmd\git.exe"
)
if "%GIT_EXE%"=="" set "GIT_EXE=git"

:: 1. Generar una estampa de tiempo única basada en la fecha y hora actual (ej. version=202610021420)
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%"
set "TIMESTAMP=%YYYY%%MM%%DD%%HH%%Min%"

:: 2. Actualizar un archivo de versión o el index para forzar el caché en móviles
echo %TIMESTAMP% > version.txt

:: 3. Subir cambios a GitHub de inmediato
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion movil %TIMESTAMP%" --allow-empty
"%GIT_EXE%" push origin main --porcelai

exit