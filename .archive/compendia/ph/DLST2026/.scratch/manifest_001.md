# Manifest: Page 001

## REPLACE_TABLES
- USE_ARTIFACT: page_001_tables.md#Table_1
  REPLACE_FROM: `|1.|Introduction|2|`
  REPLACE_TO: `|3.1.|Sets|10|`

## REPAIR_PROSE
- REPLACE_FROM: `# TAMAL K. DEY 1 , MICHA L LIPI ´ NSKI 2 ∗ AND MANUEL SORIANO-TRIGUEROS 2 , 3`
  REPLACE_TO: `# TAMAL K. DEY\(^1\), MICHAŁ LIPIŃSKI\(^{2,*}\) AND MANUEL SORIANO-TRIGUEROS\(^{2,3}\)`
- REPLACE_FROM: `1 Purdue University, IN, US`
  REPLACE_TO: `\(^1\) Purdue University, IN, US`
- REPLACE_FROM: `2 Institute of Science and Technology Austria (ISTA)`
  REPLACE_TO: `\(^2\) Institute of Science and Technology Austria (ISTA)`
- REPLACE_FROM: `3 Universidad de Sevilla, Spain`
  REPLACE_TO: `\(^3\) Universidad de Sevilla, Spain`
- REPLACE_FROM: `E-mail address : tamaldey@purdue.edu, michal.lipinski@ist.ac.at, msoriano4@us.es .`
  REPLACE_TO: `E-mail address: tamaldey@purdue.edu, michal.lipinski@ist.ac.at, msoriano4@us.es.`
- REPLACE_FROM: `∗ Corresponding author.`
  REPLACE_TO: `\(^*\) Corresponding author.`

## REPAIR_MATH
