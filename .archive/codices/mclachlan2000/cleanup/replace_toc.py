from pathlib import Path
orig = Path('mclachlan2000.cleaned copy.md').read_text(encoding='utf-8')
new = Path('formatted_toc7.md').read_text(encoding='utf-8')
start = orig.index('# Contents')
end = orig.index('# Preface', start)
out = orig[:start] + new + '\n' + orig[end:]
Path('mclachlan2000.cleaned copy.md').write_text(out, encoding='utf-8')
print('replaced TOC block in mclachlan2000.cleaned copy.md')
