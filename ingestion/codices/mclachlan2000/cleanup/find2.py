from pathlib import Path
text = Path('mclachlan2000.cleaned copy.md').read_text(encoding='utf-8')
for i,line in enumerate(text.splitlines(),1):
    if '[2](' in line or '][2]' in line or line.startswith('- [2'):
        print(i, repr(line))
