from cleanup_misc_standards import SKIP_SECTION_RE, first_boilerplate_index, INTERSECTIONS
import re

for doc in ["GVPB2025", "TKH2022", "MMO2019"]:
    lines = (INTERSECTIONS / f"{doc}.md").read_text(encoding="utf-8").splitlines()
    idx = first_boilerplate_index(lines)
    print(doc, "cut", idx)
    for i, l in enumerate(lines):
        m = re.match(r"^#{2,4}\s+(.+)$", l)
        if m and SKIP_SECTION_RE.search(m.group(1).strip()):
            print(" ", i, m.group(1))
