@echo off
setlocal EnableExtensions
set "SERVER=D:/aghado01/codex-scientiae/src/mcp-server.ps1"

if defined AGY_MCP_PWSH if exist "%AGY_MCP_PWSH%" (
  "%AGY_MCP_PWSH%" -NoProfile -File "%SERVER%"
  exit /b %ERRORLEVEL%
)

set "APP_AGENT=C:/Users/azrie/PDenv/PowerShell/PowerShell-7.6.2-win-x64-antigravity-gemini/powershell.exe"
if exist "%APP_AGENT%" (
  "%APP_AGENT%" -NoProfile -File "%SERVER%"
  exit /b %ERRORLEVEL%
)

set "IDE_AGENT=C:/Users/azrie/PDenv/PowerShell/PowerShell-7.6.0-win-x64-antigravity-ide-gemini/powershell.exe"
"%IDE_AGENT%" -NoProfile -File "%SERVER%"
exit /b %ERRORLEVEL%
