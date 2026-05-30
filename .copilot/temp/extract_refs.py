from pathlib import Path
root = Path(r"c:\Users\azrie\PDenv\UserGithub\PowerShellCore\ps.core.pwshspc\refs\Kisung You")
processed = []
for path in sorted(root.glob('*.cleaned.md')):
    text = path.read_text(encoding='utf-8')
    lines = text.splitlines()
    start = next((i for i, line in enumerate(lines) if line.strip() == '# References'), None)
    if start is None:
        print(f'No references header found in {path.name}')
        continue
    before = '\n'.join(lines[:start]).rstrip() + '\n'
    references = '\n'.join(lines[start:]).rstrip() + '\n'
    basename = path.name.replace('.cleaned.md', '')
    ref_path = root / f"{basename}_references.md"
    ref_path.write_text(references, encoding='utf-8')
    path.write_text(before, encoding='utf-8')
    processed.append((path.name, ref_path.name))
print('Processed:', processed)
