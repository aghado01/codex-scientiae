from pathlib import Path
import re

def normalize_section_label(label):
    match = re.match(r'^([0-9]+(?:\.[0-9]+)*)', label)
    if match:
        return match.group(1)
    return None

def normalize_text_label(text):
    s = re.sub(r'[^0-9a-zA-Z]+', '-', text.lower()).strip('-')
    return re.sub(r'-+', '-', s)

def make_id(heading):
    h = heading[2:].strip()
    section = normalize_section_label(h)
    if section:
        return 'sec-' + section.replace('.', '-')
    return 'sec-' + normalize_text_label(h)

def is_skip_heading_text(txt):
    txt = txt.strip()
    if re.fullmatch(r'[0-9]+(?:\.[0-9]+)*', txt):
        return True
    if re.fullmatch(r'[ivx]+', txt, re.IGNORECASE):
        return True
    return False

def parse_toc_entries(block):
    entries=[]
    for line in block.splitlines()[1:]:
        s=line.strip()
        if not s or s.startswith('```') or not s.startswith('-'):
            continue
        content = s[1:].strip()
        if '—' in content:
            left,right = content.rsplit('—',1)
            page = right.strip()
            title = left.strip()
        elif '--' in content:
            left,right = content.rsplit('--',1)
            page = right.strip()
            title = left.strip()
        else:
            title = content.strip()
            page = ''
        section = normalize_section_label(title)
        entries.append({'raw': title, 'page': page, 'section': section, 'title': title})
    return entries

text = Path('mclachlan2000.cleaned copy.md').read_text(encoding='utf-8')
start = text.index('# Contents')
end = text.index('# Preface', start)
toc_block = text[start:end]
rest = text[end:]
entries = parse_toc_entries(toc_block)
section_pages = {}
name_pages = {}
for e in entries:
    if e['section']:
        section_pages[e['section']] = e['page']
    else:
        name_pages[normalize_text_label(e['title'])] = e['page']

heading_lines = [line for line in rest.splitlines() if line.startswith('# ')]
linked_lines = ['# Contents']
for h in heading_lines:
    text_content = h[2:].strip()
    if is_skip_heading_text(text_content):
        continue
    section = normalize_section_label(text_content)
    if section:
        level = section.count('.')
        id_ = 'sec-' + section.replace('.', '-')
    else:
        level = 0
        id_ = 'sec-' + normalize_text_label(text_content)
    page = ''
    if section and section in section_pages:
        page = section_pages[section]
    else:
        page = name_pages.get(normalize_text_label(text_content), '')
    indent = '  ' * level
    line = f"{indent}- [{text_content}](#{id_})"
    if page:
        line += f" — {page}"
    linked_lines.append(line)

rest_lines = rest.splitlines()
output = []
for line in rest_lines:
    if line.startswith('# '):
        text_content = line[2:].strip()
        if is_skip_heading_text(text_content):
            output.append(line)
            continue
        id_ = make_id(line)
        prev = output[-1] if output else ''
        if prev != f'<a id="{id_}"></a>':
            output.append(f'<a id="{id_}"></a>')
    output.append(line)
new_text = text[:start] + '\n'.join(linked_lines) + '\n' + '\n'.join(output)
Path('mclachlan2000.cleaned copy.md').write_text(new_text, encoding='utf-8')
print('replaced TOC with cleaned linked version')
