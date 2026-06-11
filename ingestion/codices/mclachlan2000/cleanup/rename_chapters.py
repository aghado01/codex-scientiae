from pathlib import Path
import re

paths = sorted(Path('.').glob('chapter-*.md'))
for p in paths:
    text = p.read_text(encoding='utf-8')
    m = re.search(r'^(?:#|##|###)\s+(.+)$', text, flags=re.MULTILINE)
    title = m.group(1).strip() if m else p.stem
    title = re.sub(r'^(chapter\s+)?\d+\.?\s*-?\s*', '', title, flags=re.I)
    slug = re.sub(r'[^a-z0-9]+', '-', title.strip().lower())
    slug = re.sub(r'-{2,}', '-', slug).strip('-')
    new_name = f'chapter-{p.stem.split("-")[1]}-{slug}.md'
    print(f'{p.name} => {new_name}')
    if new_name != p.name:
        p.rename(new_name)
