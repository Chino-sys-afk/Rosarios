@echo off
cd /d "C:\Users\jose_\Documents\GitHub\Rosarios"

:: Forzar el cierre temporal de cualquier proceso o visor que bloquee el PDF
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

:: Actualizar automáticamente el index.html con el nuevo sello único
echo ^<!DOCTYPE html^> > index.html
echo ^<html lang="es"^> >> index.html
echo ^<head^> >> index.html
echo      ^<meta charset="UTF-8"^> >> index.html
echo      ^<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"^> >> index.html
echo      ^<title^>Reporte Rosarios^</title^> >> index.html
echo      ^<style^> >> index.html
echo          body, html { margin: 0; padding: 0; height: 100%%; overflow: hidden; background: #525659; } >> index.html
echo          iframe { width: 100%%; height: 100%%; border: none; } >> index.html
echo      ^</style^> >> index.html
echo ^</head^> >> index.html
echo ^<body>^> >> index.html
echo      ^<iframe src="reporte_%TIMESTAMP%.pdf"^>^</iframe^> >> index.html
echo ^</body^> >> index.html
echo ^</html^> >> index.html

:: 2. Empaquetar y enviar de manera segura a GitHub
"%GIT_EXE%" add -A
"%GIT_EXE%" commit -m "Actualizacion dinamica reporte_%TIMESTAMP%" --allow-empty
"%GIT_EXE%" push origin main --force-with-lease

echo.
echo ========================================================
echo Proceso de sincronizacion finalizado con exito.
echo ========================================================
pause