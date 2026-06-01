@echo off
chcp 65001 >nul
title SGM Caloi - Copiar para C:\Projetos (fora do OneDrive)
cd /d "%~dp0"

set "DEST=C:\Projetos\SGM_Caloi"

echo ============================================
echo   Copiando o SGM para uma pasta limpa
echo   Origem : %~dp0
echo   Destino: %DEST%
echo ============================================
echo.
echo (sem OneDrive e sem o .git da pasta de usuario - o git funciona certo la)
echo.
pause

if not exist "C:\Projetos" mkdir "C:\Projetos"

rem Copia tudo, menos cache, previews e dados de runtime
robocopy "%~dp0." "%DEST%" /E ^
  /XD __pycache__ _preview sgm uploads backups .git ^
  /XF *.pyc *.log

echo.
echo ============================================
echo   Pronto! Agora:
echo   1) Abra a pasta %DEST%
echo   2) De dois cliques em SUBIR_GITHUB.bat (de la)
echo   3) Depois siga o DEPLOY.md para o Railway
echo ============================================
echo.
echo Dica: a partir de agora, trabalhe o projeto em %DEST%
echo (a copia no OneDrive pode ficar so como backup).
pause
