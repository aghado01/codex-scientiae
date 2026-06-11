from pathlib import Path
import re
lines = Path('mclachlan2000.cleaned copy.md').read_text(encoding='utf-8').splitlines()
for i,line in enumerate(lines,1):
    if line.startswith('# 2'):
        print(i, repr(line), repr(line[2:].strip()), bool(re.fullmatch(r'[0-9]+(?:\.[0-9]+)*', line[2:].strip())))
