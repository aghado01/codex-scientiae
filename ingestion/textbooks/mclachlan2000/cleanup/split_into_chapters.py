from pathlib import Path
import re

anchordata = [
    ('00-preface', 'sec-preface'),
    ('01-general-introduction', 'sec-general-introduction'),
    ('02-ml-fitting-of-mixture-models', 'sec-ml-fitting-of-mixture-models'),
    ('03-multivariate-normal-mixtures', 'sec-multivariate-normal-mixtures'),
    ('04-bayesian-approach-to-mixture-analysis', 'sec-bayesian-approach-to-mixture-analysis'),
    ('05-mixtures-with-nonnormal-components', 'sec-mixtures-with-nonnormal-components'),
    ('06-assessing-the-number-of-components-in-mixture-models', 'sec-assessing-the-number-of-components-in-mixture-models'),
    ('07-multivariate-t-mixtures', 'sec-multivariate-t-mixtures'),
    ('08-mixtures-of-factor-analyzers', 'sec-mixtures-of-factor-analyzers'),
    ('09-fitting-mixture-models-to-binned-data', 'sec-fitting-mixture-models-to-binned-data'),
    ('10-mixture-models-for-failure-time-data', 'sec-mixture-models-for-failure-time-data'),
    ('11-mixture-analysis-of-directional-data', 'sec-mixture-analysis-of-directional-data'),
    ('12-variants-of-the-em-algorithm-for-large-databases', 'sec-variants-of-the-em-algorithm-for-large-databases'),
    ('13-hidden-markov-models', 'sec-hidden-markov-models'),
]

text = Path('mclachlan2000.md').read_text(encoding='utf-8')
positions = []
for name, anchor in anchordata:
    m = re.search(rf'<a id="{re.escape(anchor)}"></a>', text)
    if not m:
        raise SystemExit(f'Anchor not found: {anchor}')
    positions.append((m.start(), name, anchor))
positions.sort()

chapter_dir = Path('mclachlan2000/chapters')
chapter_dir.mkdir(parents=True, exist_ok=True)
for idx, ((startpos, name, anchor), nextitem) in enumerate(zip(positions, positions[1:] + [(None,None,None)])):
    endpos = nextitem[0] if nextitem[0] is not None else len(text)
    segment = text[startpos:endpos].lstrip('\n')
    outpath = chapter_dir / f'chapter{idx:02d}-{name}.md'
    outpath.write_text(segment, encoding='utf-8')
    print(f'Wrote {outpath.name}: {len(segment)} chars')
