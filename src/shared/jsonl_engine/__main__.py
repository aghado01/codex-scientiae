"""`python -m jsonl_engine` -- the command surface jso-shell.ps1 marshals into."""

import sys

from .cli import main

sys.exit(main())
