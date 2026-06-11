$py = "$env:PORTABLE_PYTHON/python.exe"
$venv = "$env:PORTABLE_ROOT/UserGithub/PowerShellCore/ps.core.pdfdig/.venv"

# 1. Create venv
& $py -m venv $venv
& "$venv/Scripts/Activate.ps1"

$py_venv = "$venv/Scripts/python.exe"

& $py_venv -m pip install --upgrade pip

# 2. Install opendataloader-pdf with hybrid extras, then install cuda torch
& $py_venv -m pip install "opendataloader-pdf[hybrid]"

& $py_venv -m pip install torch torchvision `
    --index-url https://download.pytorch.org/whl/cu128 `
    --force-reinstall
