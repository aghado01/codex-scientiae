# Manifest: Page 018

## REPLACE_TABLES
- USE_ARTIFACT: page_018_tables.md#Table_8
  REPLACE_FROM: `|Dataset|Type|No. of series|Series length|No. of classes|Train size|Test size|`
  REPLACE_TO: `Table 8: Information about UEA Datasets used for experiments`
- USE_ARTIFACT: page_018_tables.md#Table_9
  REPLACE_FROM: `|Dataset|36 center points|25 center points|64 center points|`
  REPLACE_TO: `Table 9: Selection of number of center points to compute ZZ-GRIL`
- USE_ARTIFACT: page_018_tables.md#Table_10
  REPLACE_FROM: `|Dataset|. 7 ∗ window _ size , 5 ) max|( 0 . 3 ∗ window _ size , 2 )|max ( 0 . 5 ∗ window _ size , 3 )|`
  REPLACE_TO: `Table 10: Selection of overlap between time windows for time-series modelled as a sequence of graphs. The window _ size is fixed to be max (128 //series _ len, 5 ).`
- USE_ARTIFACT: page_018_tables.md#Table_11
  REPLACE_FROM: `|Dataset max|( series _ len // 128 , 5 ) max|( series _ len // 64 , 10 )|max ( series _ len // 256 , 3 )|`
  REPLACE_TO: `Table 11: Selection of window size for time-series modelled as a sequence of graphs. The overlap is fixed to be max (4 , 0 . 7 ∗ window _ size ) .`
- USE_ARTIFACT: page_018_tables.md#Table_12
  REPLACE_FROM: `|Dataset|Threshold (45% 55%)|Threshold (65% 75%)|Threshold (85% 95 %)|`
  REPLACE_TO: `Table 12: Selection of thresholding value range for retaining edges in the graph.`

## REPAIR_MATH
- REPLACE_FROM: `max(5 ,series _ length// 128)`
  REPLACE_TO: `\(\max(5, \text{series\_length} // 128)\)`
- REPLACE_FROM: `max(4 , 0 . 7 ∗ window _ size )`
  REPLACE_TO: `\(\max(4, 0.7 * \text{window\_size})\)`
- REPLACE_FROM: `min( series _ length/ 5 , 128)`
  REPLACE_TO: `\(\min(\text{series\_length} / 5, 128)\)`
- REPLACE_FROM: `0 . 7 ∗ window _ size`
  REPLACE_TO: `\(0.7 * \text{window\_size}\)`
- REPLACE_FROM: `1 e − 3`
  REPLACE_TO: `\(10^{-3}\)`
- REPLACE_FROM: `5 e − 5`
  REPLACE_TO: `\(5 \times 10^{-5}\)`

## REPAIR_PROSE
- REPLACE_FROM: `Z Z -G RIL at.`
  REPLACE_TO: `ZZ-GRIL.`
- REPLACE_FROM: `TodyNet+Z Z -G RIL`
  REPLACE_TO: `TodyNet+ZZ-GRIL`
