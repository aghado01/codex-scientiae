from pathlib import Path
import re
p = Path('mclachlan2000.cleaned copy.md')
text = p.read_text(encoding='utf-8')
start = text.index('# Contents')
end = text.index('# Preface', start)
block = text[start:end]
lines = block.splitlines()

def skip_line(line):
    s = line.strip()
    if not s:
        return True
    if s.lower() in {'vii','viii','xiii','xiv','xv','xvi','xvii','xviii','contents','content'}:
        return True
    if re.match(r'^\|[-\s\|]+$', s):
        return True
    if s.startswith('|') and all(not part.strip() for part in s.strip('|').split('|')):
        return True
    return False

out = ['# Contents']
for line in lines[1:]:
    if skip_line(line):
        continue
    s = line.strip()
    if s.startswith('|'):
        parts = [part.strip() for part in s.strip('|').split('|')]
        parts = [part for part in parts]
        # remove leading/trailing blanks
        while parts and parts[0] == '':
            parts.pop(0)
        while parts and parts[-1] == '':
            parts.pop()
        if not parts:
            continue
        if len(parts) == 1:
            out.append(f'**{parts[0]}**')
            continue
        if len(parts) == 2:
            a,b = parts
            if re.match(r'^\d+[\d\.\s]*$', a):
                out.append(f'- {a} {b}')
            else:
                out.append(f'- **{a}** — {b}')
            continue
        if len(parts) == 3:
            a,b,c = parts
            if re.match(r'^\d+[\d\.\s]*$', a) and c:
                out.append(f'- {a} {b} — {c}')
            elif not a and re.match(r'^\d+[\d\.\s]*$', b):
                out.append(f'  - {b} {c}')
            elif a and not b:
                out.append(f'- **{a}** — {c}')
            else:
                out.append(f'- {a} {b} {c}'.strip())
            continue
        if len(parts) >= 4:
            a,b,c,d = parts[:4]
            if a and b and d and not c:
                out.append(f'- {a} {b} — {d}')
            elif not a and b and c and d:
                out.append(f'  - {b} {c} — {d}')
            elif a and not b and c and d:
                out.append(f'- {a} {c} — {d}')
            elif a and b and c and not d:
                out.append(f'- {a} {b} {c}')
            elif a and not b and not c and d:
                out.append(f'- **{a}** — {d}')
            elif a and not b and c:
                out.append(f'- **{a}** {c}')
            elif not a and b and c:
                out.append(f'  - {b} {c}')
            else:
                out.append('- ' + ' | '.join([x for x in parts if x]))
            continue
    else:
        out.append(f'**{s}**')

Path('formatted_toc2.md').write_text('\n'.join(out) + '\n', encoding='utf-8')
print('wrote formatted_toc2.md')
