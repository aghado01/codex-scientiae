# Manifest: Page 009

## REPLACE_TABLES
- USE_ARTIFACT: page_009_tables.md#Table_1
  REPLACE_FROM: `|Dataset/Methods|ED-1NN|DTW-1NN-I|DTW-1NN-D|MLSTM-FCN|ShapeNet|WEASEL+MUSE|OS-CNN|MOS-CNN|Z Z -G RIL|
|---|---|---|---|---|---|---|---|---|---|
|FingerMovements|0.550|0.520|0.530|0.580|0.589|0.490|0.568|0.568|0.590|
|Heartbeat|0.620|0.659|0.717|0.663|0.756|0.727|0.489|0.604|0.721|
|MotorImagery NATOPS|0.510|0.390|0.500|0.510|0.610|0.500|0.535|0.515|0.580|
|NATOPS|0.860|0.850|0.883|0.889|0.883|0.460|0.968|0.510|0.850|
|SelfRegulationSCP2|0.483|0.533|0.539|0.472|0.578|0.460|0.532|0.510|0.522|`
  REPLACE_TO: `FILL_ME_IN`
- USE_ARTIFACT: page_009_tables.md#Table_2
  REPLACE_FROM: `|Dataset/Methods|TapNet|TapNet+Z Z -G RIL|TodyNet|TodyNet+Z Z -G RIL|
|---|---|---|---|---|
|FingerMovements|0.530|0.630|0.570|0.660|
|Heartbeat|0.751|0.751|0.756|0.756|
|MotorImagery|0.580|0.600|0.640|0.660|
|NATOPS|0.927|0.922|0.972|0.961|
|SelfRegulationSCP2|0.538|0.544|0.550|0.600|`
  REPLACE_TO: `FILL_ME_IN`

## REPAIR_PROSE
- REPLACE_FROM: `Sequence of graphs



-









Quasi zigzag bifiltration


Sequence of point clouds


Splicing with windows











Multivariate Time Series

Machine Learning Model (e.g. Spatiotemporal GNNs)




`
  REPLACE_TO: ``
- REPLACE_FROM: `Z Z -G RIL`
  REPLACE_TO: `ZZ-GRIL`
- REPLACE_FROM: `sequence of time-series , each`
  REPLACE_TO: `sequence of time-series, each`

## REPAIR_MATH
- REPLACE_FROM: `with m time-series`
  REPLACE_TO: `with \( m \) time-series`
- REPLACE_FROM: `length w .`
  REPLACE_TO: `length \( w \).`
- REPLACE_FROM: `width w ,`
  REPLACE_TO: `width \( w \),`
- REPLACE_FROM: `overlap of λ .`
  REPLACE_TO: `overlap of \( \lambda \).`
- REPLACE_FROM: `length w )`
  REPLACE_TO: `length \( w \))`
- REPLACE_FROM: `m nodes.`
  REPLACE_TO: `\( m \) nodes.`
- REPLACE_FROM: `top k percentile`
  REPLACE_TO: `top \( k \) percentile`
- REPLACE_FROM: `point in R w .`
  REPLACE_TO: `point in \( \mathbb{R}^w \).`
- REPLACE_FROM: `if we have m time series`
  REPLACE_TO: `if we have \( m \) time series`
- REPLACE_FROM: `have m points in R w in each`
  REPLACE_TO: `have \( m \) points in \( \mathbb{R}^w \) in each`
- REPLACE_FROM: `point clouds in R w .`
  REPLACE_TO: `point clouds in \( \mathbb{R}^w \).`
