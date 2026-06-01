@echo off
chcp 65001 >nul
title SGM Caloi - Sistema de Gestao de Manutencao
cd /d "%~dp0"

echo ============================================
echo   SGM Caloi - iniciando...
echo ============================================

rem Detecta o Python (python ou py)
where python >nul 2>&1 && (set "PY=python") || (set "PY=py")

echo Verificando dependencias...
%PY% -m pip install -r requirements.txt >nul 2>&1

echo Abrindo o navegador em http://localhost:5001
start "" http://localhost:5001

echo.
echo Servidor rodando. Para PARAR, feche esta janela ou tecle Ctrl+C.
echo ============================================
%PY% app.py

pause
