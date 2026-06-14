# Manifest: Page 010

## REPLACE_TABLES
- USE_ARTIFACT: page_010_tables.md#Table_3
  REPLACE_FROM: `|Dataset|Zigzag (scale =|0.5) Zigzag (scale =|Zizag (full graph)|ZZ-GRIL|`
  REPLACE_TO: `Table 3: Accuracy of 1-parameter zigzag persistence at different scales compared with Z Z -G RIL . We use a Random Forest Classifier for classifying the topological signatures. The empty entries denote that the model does not train on the topological features because the features are not distinct enough at that scale.`
- USE_ARTIFACT: page_010_tables.md#Table_4
  REPLACE_FROM: `|Dataset|+ Z Z -G RIL point clouds|TodyNet + Z Z -G RIL graphs|`
  REPLACE_TO: `Table 4: Comparison of converting multivariate time series as a sequence of point clouds versus converting it as a sequence of graphs to extract the topological information.`
- USE_ARTIFACT: page_010_tables.md#Table_5
  REPLACE_FROM: `|Dataset|Snapshot|PH Z Z -G RIL|`
  REPLACE_TO: `Table 5: Comparison of vectorizing each non-zigzag filtration individually (Snapshot PH) versus Z Z -G RIL .`

## REPAIR_PROSE
- REPLACE_FROM: `Z Z -G RIL .`
  REPLACE_TO: `ZZ-GRIL.`
- REPLACE_FROM: `Z Z -G RIL ,`
  REPLACE_TO: `ZZ-GRIL,`
- REPLACE_FROM: `Z Z -G RIL`
  REPLACE_TO: `ZZ-GRIL`
- REPLACE_FROM: `Table 4).`
  REPLACE_TO: `Table 4.`
  REPLACE_TO: `Table 4.`
