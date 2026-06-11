from pathlib import Path
import re
text = Path('mclachlan2000.cleaned copy.md').read_text(encoding='utf-8')
start = text.index('# Contents')
end = text.index('# Preface', start)
block = text[start:end]
lines = block.splitlines()[1:]
entries=[]
for line in lines:
    s=line.strip()
    if not s or s.startswith('```'):
        continue
    if s.startswith('-') or s.startswith('**') or s.startswith('#'):
        entries.append(s)
print('TOC entries sample:')
for e in entries[:40]:
    print(repr(e))
print('---')
# headings after TOC
rest=text[end:]
headings=[l for l in rest.splitlines() if l.startswith('# ')]
print('first 20 headings:')
for h in headings[:20]:
    print(repr(h))
