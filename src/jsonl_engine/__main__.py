"""`python -m jsonl_engine` -- the command protocol used by jsonl_engine-client."""

import sys

from .cli import main

sys.exit(main())
