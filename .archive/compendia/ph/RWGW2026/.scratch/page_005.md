[Page 5]

![In this image there is a graph.](<RWGW2026/imageFile2.png>)

52648

52648


SheafLapNet

0.85

SheafLapNet

0.82

TNet-MP-2

0.94

TNet-MP-2


0.77

7.5

STRUM

STRUM

0.77

0.94

5.0

0.72

TNet-MP-1

TNet-MP-1

1.02

2.5


0.69

mCSM

mCSM

1.07

0.0


PoPMuSiC2.0

0.61

PoPMuSiC2.0

1.17


I-Mutant3.0

I-Mutant3.0

1.19

INPS

0.56

INPS

1.26


0.0

0.5

1.0

1.5

0.0

1.0

0.5

Predicted AAG (kcallmol)

PCC

RMSE

b.

5350

d.

5350

5350

SheafLapNet

0.82

SheafLapNet

10.91

TNet-MP-2

0.94

TNet-MP-2

STRUM

0.79

STRUM

0.98


TNet-MP-1

0.74

TNet-MP-1

1.07

0.73

mCSM

1.08

mCSM

INPS

0.68


INPS

PoPMuSiC2.0

0.67

PoPMuSiC2.0



0.53

I-Mutant3.0

I-Mutant3.0

1.35

0.48

Dmutant

1.38

Dmutant


0.46

Automute

1.42

Automute

CUPSAT

0.37

CUPSAT

0.35

Eris

Eris

1.49

0.29


I-Mutant 2.0

1.50

I-Mutant 2.0

0.5

1.0

0.0

0.0

0.5

1.0

1.5

Predicted AAG (kcallmol)

PCC

RMSE

Figure 2: Illustration of model performance in protein stability changes upon mutation. (a). 5-fold cross-validation performance of SheafLapNet for S2648 dataset compared to existing state-of-the-art models [4, 37, 55]. (b). Blind test performance of SheafLapNet for S350 dataset compared to existing state-of-the-art models [4, 6, 37, 55]. (c). Comparison of experimental protein stability changes with predicted ones from SheafLapNet for S2648 dataset. (d). Comparison of experimental protein stability changes with predicted ones from SheafLapNet for S350 dataset.

## 2.2 Prediction of Mutation-Induced Protein Stability Changes

Mutation-induced perturbations in protein stability are a fundamental mechanism underlying numerous genetic diseases. These stability alterations, quantified as ∆∆ G , frequently compromise protein function and structural integrity. To rigorously assess the capacity of our framework to capture these effects, we utilized the S2648 benchmark dataset, which comprises 2,648 single-point mutations across 131 protein structures annotated with experimentally determined stability changes. Our evaluation protocol consisted of two distinct phases designed to ensure robust Wild Type validation. First, we performed a fivefold cross validation on the complete S2648 dataset to establish baseline generalizability. This was followed by a targeted blind test using the S350 dataset, a high quality and curated subset of S2648 comprising 350 mutations across 67 proteins. This subset serves as a standard benchmark for independent model evaluation. To facilitate direct comparison with established methods in the literature [4, 37, 55], predictive performance was quantified using the Pearson correlation coefficient (PCC) and root mean squared error (RMSE) as defined in Section S1.1 of the Supporting Information.
