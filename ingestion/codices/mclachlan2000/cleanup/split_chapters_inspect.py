from pathlib import Path
import re
text = Path('mclachlan2000.md').read_text(encoding='utf-8')
anchors = [(m.group(1), m.start()) for m in re.finditer(r'<a id="([^\"]+)"></a>', text)]
for name,pos in anchors:
    print(name)
print('--- total', len(anchors))
