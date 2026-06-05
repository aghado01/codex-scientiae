from pathlib import Path
import re

def normalize_section_label(label):
    match = re.match(r'^([0-9]+(?:\.[0-9]+)*)', label)
    return match.group(1) if match else None

def normalize_text_label(text):
    s = re.sub(r'[^0-9a-zA-Z]+', '-', text.lower()).strip('-')
    return re.sub(r'-+', '-', s)

def is_skip_heading_text(txt):
    txt = txt.strip()
    if re.fullmatch(r'[0-9]+(?:\.[0-9]+)*', txt):
        return True
    if re.fullmatch(r'[ivx]+', txt, re.IGNORECASE):
        return True
    return False

text = Path('mclachlan2000.cleaned copy.md').read_text(encoding='utf-8')
start = text.index('# Contents')
end = text.index('# Preface', start)
rest = text[end:]
for line in rest.splitlines():
    if line.startswith('# '):
        content=line[2:].strip()
        if is_skip_heading_text(content):
            print('SKIP:', repr(content))
        else:
            print('KEEP:', repr(content))
