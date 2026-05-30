# one time bootstrap local python from portable python

$venv = "$env:PORTABLE_ROOT/UserGithub/codex-scientiae/.venv"

$py = "$env:PORTABLE_PYTHON/python.exe"
& $py -m venv $venv

$py_venv = "$venv/Scripts/python.exe"s

& "$venv/Scripts/Activate.ps1"
& $py_venv -m pip install --upgrade pip

& $py_venv -m pip install -r requirements.txt
