import os

manifest_path = r"c:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\compendia\ph2\TKH2022\.scratch\manifest_004.md"
page_path = r"c:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\compendia\ph2\TKH2022\.scratch\page_004.md"

with open(page_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# The first debris block: lines 3 to 106 (index 2 to 105)
debris1 = "".join(lines[2:106])
# The second debris block: lines 109 to 226 (index 108 to 225)
debris2 = "".join(lines[108:226])

# Math to repair
math1_raw = "realizations y from p ð x j h Þ , we can rewrite the posterior as"
math1_fix = "realizations \\( y \\) from \\( p(x | \\theta) \\), we can rewrite the posterior as"

math2_raw = "using a suitably small in Algorithm 1. Often when applying the rejection algorithm, we fix the number of samples S and select such that the set of samples ^ h s with d s < is some fraction a S .The ABC rejection sampler algorithm requires us to define a distance on the data, D ( x , y ), and in some cases this may itself be intractable. It is then possible to substitute a summary statistic of the data, g ( x ) in place of the data itself, leading to a distance on these summary statistics D ð g ð x Þ ; g ð y ÞÞ being considered. In the case where g is a sufficient statistic for the model, as ! 0 this will be equivalent to applying a distance on the x and y themselves."
math2_fix = "using a suitably small \\( \\epsilon \\) in Algorithm 1. Often when applying the rejection algorithm, we fix the number of samples \\( S \\) and select \\( \\epsilon \\) such that the set of samples \\( \\hat{\\theta}_s \\) with \\( d_s < \\epsilon \\) is some fraction \\( \\alpha S \\). The ABC rejection sampler algorithm requires us to define a distance on the data, \\( D(x, y) \\), and in some cases this may itself be intractable. It is then possible to substitute a summary statistic of the data, \\( g(x) \\) in place of the data itself, leading to a distance on these summary statistics \\( D(g(x), g(y)) \\) being considered. In the case where \\( g \\) is a sufficient statistic for the model, as \\( \\epsilon \\to 0 \\) this will be equivalent to applying a distance on the \\( x \\) and \\( y \\) themselves."

math3_raw = "represented as þ1 ."
math3_fix = "represented as \\( +\\infty \\)."

table_raw = """|Algorithm 1 ABC rejection sampler algorithm| |
|---|---|
|1: for s 2 1 ; ... ; S do| |
|2:|Sample ^ h s   p ð h Þ|
|3:|Simulate y   p ð y j ^ h s Þ|
|4:|Calculate d s D ð g ð y Þ ; g ð x ÞÞ|
|5: end for| |
|6: Return samples ^ h s where d s <  | |"""

table_replacement = f"""- USE_ARTIFACT: page_004_tables.md#Table_1
  REPLACE_FROM: ```
{table_raw}
```
  REPLACE_TO: `[TABLE_1]`
"""

# Read manifest
with open(manifest_path, 'r', encoding='utf-8') as f:
    manifest_content = f.read()

# Replace REPLACE_TABLES FILL_ME_IN
import re
manifest_content = re.sub(r"- USE_ARTIFACT: page_004_tables\.md#Table_1\n  REPLACE_FROM: `FILL_ME_IN`\n  REPLACE_TO: `FILL_ME_IN`", table_replacement, manifest_content)

# Add REPAIR_PROSE and REPAIR_MATH
repair_prose_block = f"""

## REPAIR_PROSE
- RAW: ```
{debris1.strip()}
```
  FIX: ```
```
- RAW: ```
{debris2.strip()}
```
  FIX: ```
```
"""

repair_math_block = f"""
- RAW: `{math1_raw}`
  FIX: `{math1_fix}`
- RAW: `{math2_raw}`
  FIX: `{math2_fix}`
- RAW: `{math3_raw}`
  FIX: `{math3_fix}`
"""

# Insert REPAIR_PROSE at the end, and append REPAIR_MATH to the existing REPAIR_MATH section
# Wait, the REPLACE_TABLES is at the end. We can just append REPAIR_PROSE.
# Let's just find `## REPLACE_TABLES` and insert `REPAIR_PROSE` before it.
# And insert `REPAIR_MATH` after the last REPAIR_MATH entry.

manifest_content = manifest_content.replace("## REPLACE_TABLES", repair_prose_block + "\n## REPLACE_TABLES")

# For the new REPAIR_MATH, we can just append it right before `## REPAIR_PROSE`
manifest_content = manifest_content.replace("## REPAIR_PROSE", repair_math_block + "\n## REPAIR_PROSE")

with open(manifest_path, 'w', encoding='utf-8') as f:
    f.write(manifest_content)

print("Manifest updated successfully.")
