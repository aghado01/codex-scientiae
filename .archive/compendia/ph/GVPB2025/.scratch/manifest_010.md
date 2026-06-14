# Manifest: Page 010

## REPLACE_TABLES
- USE_ARTIFACT: page_010_tables.md#Table_1
  REPLACE_FROM: `| |MMLU| | |HellaSwag| | |WinoGrande| | |`
  REPLACE_TO: `|Pythia|-|-|-|49.70 we|31.43|34.96|63.30|55.71|58.09|`

## REPAIR_PROSE
- REPLACE_FROM: `Benchmark Table. the model`
  REPLACE_TO: `Benchmark Table. (i) Full, the model`
- REPLACE_FROM: `Table 1, 12 where`
  REPLACE_TO: `Table 1, where`

## REPAIR_MATH
- REPLACE_FROM: `N prune`
  REPLACE_TO: `\(N_{\text{prune}}\)`
