#!/usr/bin/env python3
import re
from pathlib import Path

md_path = Path(r"c:\Users\azrie\PDenv\UserGithub\PowerShellCore\ps.core.pdfdig\converted\Voroninski\1506.01437v2\full\1506.01437v2.md")
if not md_path.exists():
    print('ERROR: markdown file not found:', md_path)
    raise SystemExit(1)

text = md_path.read_text(encoding='utf-8')
backup = md_path.with_suffix(md_path.suffix + '.bak')
backup.write_text(text, encoding='utf-8')

# normalize intertext spacing: \intertext { ... } -> \intertext{...}
text = re.sub(r'\\intertext\s*\{\s*(.*?)\s*\}', r'\\intertext{\1}', text, flags=re.DOTALL)

pattern = re.compile(r'\$\$(.*?)\$\$', re.DOTALL)

changed = False

def wrap_if_needed(m):
    global changed
    content = m.group(1)
    if ('&' in content) or ('\\intertext' in content) or ('\\\\' in content):
        if ('\\begin{aligned}' in content) or ('\\begin{align' in content) or ('\\end{aligned}' in content):
            return m.group(0)
        inner = content.strip('\n')
        newblock = '\\begin{aligned}\n' + inner + '\n\\end{aligned}'
        changed = True
        return '$$' + newblock + '$$'
    return m.group(0)

new_text = pattern.sub(wrap_if_needed, text)

if changed:
    md_path.write_text(new_text, encoding='utf-8')
    print('modified')
else:
    print('no changes')
