# one time bootstrap local python from portable python

$venv = "D:/aghado01/codex-scientiae/.venv"

$py = "$env:PORTABLE_PYTHON/python.exe"
& $py -m venv $venv

$py_venv = "$venv/Scripts/python.exe"

& "$venv/Scripts/Activate.ps1"
& $py_venv -m pip install --upgrade pip

& $py_venv -m pip install -r requirements.txt
