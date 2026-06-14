[Page 27]

Table 1. Model performance on PDBbind-v2007 and PDBbind-v2016 benchmarks.

| |Method|PCC|RMSE (kcal / mol)|
|---|---|---|---|
|PDBbind-v2007|PHL|0.794|2.066|
| |TF|0.795|2.006|
| |Consensus|0.826|1.954|
|PDBbind-v2016|PHL|0.808|1.863|
| |TF|0.836|1.716|
| |Consensus|0.849|1.728|


Abbreviations: PCC, Pearson correlation coe ffi cient; RMSE, root mean squared error.

![The image is a bar chart titled PCC (Programmed Cost-Effectiveness Comparison) - 2007. The x-axis represents the years, while the y-axis lists the different programs or categories. The chart is divided into two main categories: PCC and PDPB. **PCC (Programmed Cost-Effectiveness Comparison) - 2007** - **PDPB (Programmed Cost-Effectiveness Comparison) - 2007** - **PDPB** stands for Programmed Cost-Effectiveness Comparison. - **PDPB** is a program that compares the cost-effectiveness of different programs. - **PDPB** is a program that compares the cost-effectiveness of different programs. - **PDPB** is a program that compares the cost-effectiveness of different programs. - **PDPB** is a program that compares the](<STGW2024/imageFile11.png>)

0.826

0.819

0.817

0.803

0.8

PDBbind-v20o7

0.753

0.739

0.660

0.622

0.616

0.614

0.606

0.579

0.6

0.569

0.568

0.558

0.556

0.555

0.554

0.544

0.5

0.482

0.464

0.441

0.392



ASAS

PHOENIX

~dG@MOE

TOPBP-DL

X-ScoreHM

ChemScore@Gold

MLR::Vina

Vina

LUDI3@DS

-Score@SYBYL

ChemPLP@GOLD

ChemScore@SYBYL

PHLL

PLP1@DS

ASP@GOLD

LigScore2@DS

~Score

Cyscore

Autodock

EIC-

ASEC

Affinity-c

0.90

0.849

0.843

0840 0.835

0.85

0.828

0.8200.817

0.817

0.810

PDBbind-v2016

0.80

0.780

0.75

0.70

0.65

0.631

0.625

0.617

0.614

0.609

0.604

0.602

0.596

0.591

9590 0.581

0.60

0.574

0.563

0.552

0.540 0.531

0.55



~Score

OnionNet

Vina

TNet-BP

X-Score

PLEC-nn

~ScoreHM

SAS

SYBYL

~HB@MOE

PLEC-linear

ChemScore@Gold

PHLL

SYBYL

PPS-ML

Pafnucy

~dG@MOE

ASE@MOE

PerSpect-ML

LigScore2@DS

ChemPLP@GOLD

PLPI@DS

PLPZ@DS

ASP@GOLD

DrugScore2018

KDeep

Score

Autodock

~Score@S

ChemScorec

Alpha-+

Affinity-€

Figure 10. Performance comparison of the proposed model with other machine learning models for the two PDBbind datasets. The results of the proposed model (PHLL) are in red. The results of other methods are adapted from Refs. [7, 10, 36, 38, 41, 57].

## 6. Conclusions

Although there has been tremendous success of topological data analysis TDA [44,45], particularly, topological deep learning TDL on point cloud data [9, 49], there are few methods for the topological analysis of data on manifolds or manifold topological analysis [19]. To fill this gap, we presented a new method, persistent Hodge Laplacian PHL in the Eulerian representation, for manifold topological learning MTL of real-world data on manifolds. PHL differs from existing state-of-the-art TDA methods on point clouds in the sense that the proposed PHL is defined on manifolds, for which the traditional TDA methods do not work. Additionally, PHL extends our earlier evolutionary de RhamHodge theory constructed on the Lagrangian representation [18] to the Eulerian representation, which avoids numerical inconsistency over multi-scale manifolds. We offer two discrete Hodge stars that mimic the continuous operator and developed both a continuous theory for mapping of normal forms across manifolds in a filtration to enable persistent cohomology analysis and the associated topologypersevering discrete construction on Cartesian grids. A proof-of-principle test on two benchmark datasets validates our MTL model, highlighting its simplicity and promise for the predictions of data on manifolds.
