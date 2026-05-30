## Local python

This repository exists in a portable env and python is not yet configured in the workspace. But there is a local python installed under `.venv`

Use `.venv\python-portable-env.ps1` to launch your pwsh shells with path to venv python stored in `$py_venv` in order to issue commands to the python interpreter

## Hygiene

write scratch helper scripts to `.copilot/helpers` and write scratch artifacts and backup files to `.copilot/temp`
