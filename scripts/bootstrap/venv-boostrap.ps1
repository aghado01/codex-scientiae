# bootstrap local python from portable python

$py = "$env:PORTABLE_PYTHON/python.exe"
$venv = "$env:PORTABLE_ROOT/UserGithub/PowerShellCore/ps.core.pdfdig/.venv"

& $py -m venv $venv
& "$venv/Scripts/Activate.ps1"

$py_venv = "$venv/Scripts/python.exe"

& $py_venv -m pip install --upgrade pip

# 2. Install opendataloader-pdf with hybrid extras, then install cuda torch
& $py_venv -m pip install -r requirements.txt
