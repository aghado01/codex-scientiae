from pathlib import Path
import re
p = Path('mclachlan2000.cleaned copy.md')
text = p.read_text(encoding='utf-8')
start = text.index('# Contents')
end = text.index('# Preface', start)
block = text[start:end]
lines = block.splitlines()

def parse_parts(line):
    parts = [part.strip() for part in line.strip('|').split('|')]
    # preserve empty columns
    return parts

def is_page_row(parts):
    return len(parts) >= 4 and not parts[0].strip() and not parts[1].strip() and not parts[2].strip() and parts[3].strip()

def is_separator(line):
    s=line.strip()
    return not s or s.lower() in {'vii','viii','xiii','xiv','xv','xvi','xvii','xviii','contents','content'} or re.match(r'^\|[-\s\|]+$', s)

def num_level(tok):
    if re.match(r'^[0-9]+(\.[0-9]+)*$', tok.strip()):
        return tok.count('.') + 1
    return None

items=[]
current=None
for line in lines[1:]:
    if is_separator(line):
        continue
    if not line.strip().startswith('|'):
        # plain title row
        txt=line.strip()
        if txt:
            items.append({'text':txt,'level':0,'page':None})
            current=items[-1]
        continue
    parts=parse_parts(line)
    if is_page_row(parts):
        if current is not None:
            current['page']=parts[3].strip()
        continue
    # normalize to 4 columns with blanks
    while len(parts) < 4:
        parts.append('')
    a,b,c,d = parts[:4]
    if a and not b and not c:
        items.append({'text':a,'level':0,'page':d.strip() or None})
        current=items[-1]
        continue
    if a and b and not c:
        txt=f"{a} {b}".strip()
        lvl = num_level(a)
        if lvl is None:
            items.append({'text':txt,'level':0,'page':d.strip() or None})
        else:
            items.append({'text':txt,'level':lvl-1,'page':d.strip() or None})
        current=items[-1]
        continue
    if not a and b and c:
        txt=f"{b} {c}".strip()
        lvl = num_level(b)
        if lvl is not None:
            items.append({'text':txt,'level':lvl,'page':d.strip() or None})
        else:
            items.append({'text':txt,'level':1,'page':d.strip() or None})
        current=items[-1]
        continue
    if not a and not b and c:
        items.append({'text':c,'level':1,'page':d.strip() or None})
        current=items[-1]
        continue
    if a and b and c:
        items.append({'text':f"{a} {b} {c}".strip(),'level':0,'page':d.strip() or None})
        current=items[-1]
        continue
    if a and not b and c:
        items.append({'text':f"{a} {c}".strip(),'level':0,'page':d.strip() or None})
        current=items[-1]
        continue
    if a and b and not c and d:
        items.append({'text':f"{a} {b}".strip(),'level':0,'page':d.strip() or None})
        current=items[-1]
        continue
    # fallback
    text = ' '.join([tok for tok in [a,b,c] if tok])
    items.append({'text':text,'level':0,'page':d.strip() or None})
    current=items[-1]

# Post-process: avoid duplicates and bogus headers
filtered=[]
for item in items:
    t=item['text']
    if t.lower() in {'contents','content','vii','viii','xiii','xiv','xv','xvi','xvii','xviii'}:
        continue
    if t.isdigit() and item['page'] is None:
        continue
    filtered.append(item)

out=['# Contents']
for item in filtered:
    prefix='  ' * item['level'] + '- '
    line = prefix + item['text']
    if item['page']:
        line += ' — ' + item['page']
    out.append(line)

Path('formatted_toc3.md').write_text('\n'.join(out) + '\n', encoding='utf-8')
print('wrote formatted_toc3.md')
