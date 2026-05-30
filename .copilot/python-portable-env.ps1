$venv = "$env:PORTABLE_ROOT/UserGithub/codex-scientiae/.venv"
& "$venv/Scripts/Activate.ps1"
$py_venv = "$venv/Scripts/python.exe"

# Ampersand source to launch python command with script
# & $py_venv -m {script-filename} {args}

# Dot source to launch REPL
# . $py_venv
