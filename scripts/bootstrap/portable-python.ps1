$venv = "$env:PORTABLE_ROOT/UserGithub/codex-scientiae/.venv"
& "$venv/Scripts/Activate.ps1"
$py_venv = "$venv/Scripts/python.exe"
# Commented out to avoid launching the Python REPL when dot-sourcing.
# . $py_venv
