from pathlib import Path
import re
p = Path('mclachlan2000.cleaned copy.md')
text = p.read_text(encoding='utf-8')
start = text.index('# Contents')
end = text.index('# Preface', start)
block = text[start:end]
lines = block.splitlines()

skip_words = {'vii','viii','xiii','xiv','xv','xvi','xvii','xviii','contents','content'}

PAGE_RE = re.compile(r'^[0-9]+$|^[ivx]+$', re.I)


def parse_parts(line):
    return [part.strip() for part in line.strip('|').split('|')]

def should_skip_text(txt):
    low = txt.lower()
    if any(word in low for word in skip_words):
        return True
    return False

def is_separator(line):
    s=line.strip()
    return not s or should_skip_text(s) or re.match(r'^\|[-\s\|]+$', s)

def is_page_token(tok):
    return bool(PAGE_RE.match(tok.strip()))

def is_page_row(parts):
    return len(parts)>=4 and not parts[0].strip() and not parts[1].strip() and not parts[2].strip() and parts[3].strip() and is_page_token(parts[3])

def is_section(tok):
    return bool(re.match(r'^[0-9]+(\.[0-9]+)*$', tok.strip()))

items=[]
current=None
for line in lines[1:]:
    if is_separator(line):
        continue
    if not line.strip().startswith('|'):
        txt=line.strip()
        if txt and not should_skip_text(txt):
            items.append({'sec':'','text':txt,'level':0,'page':None})
            current=items[-1]
        continue
    parts=parse_parts(line)
    if is_page_row(parts):
        if current is not None:
            current['page']=parts[3].strip()
        continue
    while len(parts)<4:
        parts.append('')
    a,b,c,d = parts[:4]
    sec=''; title=''; page=d.strip() or None
    if is_section(a):
        sec=a; title=b or c or a
    elif is_section(b):
        sec=b; title=c or a or b
    elif is_section(c):
        sec=c; title=d or b or a
    elif a and not b and not c:
        title=a
    elif not a and c:
        title=c
    elif b and not a:
        title=b
    else:
        title=' '.join(t for t in [a,b,c] if t)
    title = title.strip()
    if not title or should_skip_text(title):
        continue
    if title.isdigit() and page is None:
        continue
    level = sec.count('.') if sec else 0
    if not sec and not a and not b and c and current is not None:
        level = current['level'] + 1
    items.append({'sec':sec,'text':title,'level':level,'page':page})
    current=items[-1]

out=['# Contents']
for item in items:
    t=item['text']
    if should_skip_text(t):
        continue
    if t.isdigit() and item['page'] is None:
        continue
    prefix='  ' * item['level'] + '- '
    line = prefix + t
    if item['page']:
        line += ' — ' + item['page']
    out.append(line)
Path('formatted_toc7.md').write_text('\n'.join(out) + '\n', encoding='utf-8')
print('wrote formatted_toc7.md')
