# Manifest: Page 024

## REPLACE_TABLES
- USE_ARTIFACT: page_024_tables.md#Table_2
  REPLACE_FROM: `|Algorithm 2 Pruning algorithm|`
  REPLACE_TO: `|if Z 1 [ l ] > max ∗ threshold then layersToRemove.append ( l ) end if end for model.removeLayers ( layersToRemove )|`

## REPAIR_PROSE
- RAW: ```
0.6

0.5

0.4

0.1

0.0

0.150

0.125

0.100

0.075

0.050

0.025

0.000

0 = = 1.00

a = 0.50

a = 2,00

0.5

0.4

a = = 1.00

a =0.00

a =0.50

a = 1.00

2,.00


0.6

0.5


0.4


0.3

0.2

Llama 2 7B




Layer



a = 0.0

a =0.5

a = 10

a = 2.0

Uniform Distribution

Llama 2 7B




Layer



Mistral






Layer

![This is a graph, which is in a table. There are five rows and five columns. The x-axis is labeled Layer, and the y-axis is labeled Light-dependent reaction. There are five lines in the graph, which are labeled Ligand, Methyldon, Methyldon, Methyldon, and Methyldon.](<GVPB2025/imageFile14.png>)

a = = 1.0

a = 0.0

0.10

a = 1.0

a = 2.0

0.08

Uniform Distribution

0.06

0.02

Mistral

0.00






Layer

0.14

0.12

0.10

0.08

0.06

0.04

0.02

0.00

a =0.00

a =0.50

a = 2.00

Pythia




Layer



a = = 1.0

a =0.5

a = 10

a = 2.0

Uniform Distribution

Pythia




Layer




Llama


Birth Layer ((birth)

4.0

3.5

3.0

2.0


;

0.5

0.0



Mistral



4.0

3.5

3.0

2.5


2.0

1.5

;

1.0

0.0



Pythia


Birth Layer ((birth)


;
```
  FIX: ```
![Figure 13: Supplementary plots for Llama 2, Mistral, and Pythia on the SST dataset. The first row displays Inter-layer persistence, the second row shows the Births’ relative frequency, and the third row presents the effective persistent images.](<GVPB2025/imageFile14.png>)
```

- RAW: ```
# G.2 Layer pruning algorithm
```
  FIX: ```
### G.2 Layer pruning algorithm
```

- RAW: ```
| if Z 1 [ l ] > max ∗ threshold then layersToRemove.append ( l ) end if end for model.removeLayers ( layersToRemove ) |
|---|
```
  FIX: ```
**Algorithm 2** Pruning algorithm

**Require:** `model`, `threshold`
1. `layersToRemove` \( \leftarrow \) `[]`
2. **for** \( l \leftarrow 1 \) **to** `model.getNumLayers()` **do**
3. &nbsp;&nbsp;&nbsp;&nbsp;**if** \( Z_1[l] > \max * \text{threshold} \) **then**
4. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`layersToRemove.append(l)`
5. &nbsp;&nbsp;&nbsp;&nbsp;**end if**
6. **end for**
7. `model.removeLayers(layersToRemove)`
```

## REPAIR_MATH
