[Page 15]

![This is a graph. On the graph, there are two lines. The first line is labeled as Wild. The second line is labeled as Mutant. There are two points on the graph.](<RWGW2026/imageFile7.png>)

C-0 atom set

0.06


0.04

Wild

Wild



Mutant

Mutant


0.00

2.0

0.0020

Wild

1.5

Mutant

0.0015

B1 1.0

0.0010

0.5

0.0005

Wild

Mutant

0.0

0.0000



Filtration Radius

Figure 7: An illustration of PSL descriptors for C-O interactions from VR complexes using modified distance filtration at residue 37 mutation site from L to S in protein 1A5E of S2648 dataset. Top panel: Illustration of zero-dimensional PSL descriptors. Bottom panel: Illustration of one-dimensional PSL descriptors. The left axis represents the Sheaf Betti numbers β 0 and β 1 . The right axis represents the minimal nonzero eigenvalues λ 0 and λ 1 of the persistent sheaf Laplacian.

## 3.3 Auxiliary Features

In addition to topological features, our model integrates a comprehensive set of physicochemical descriptors at both the atom and residue levels to characterize the mutation environment. At the atom level, we compute solvent-excluded surface areas, partial atomic charges, Coulombic and van der Waals interaction energies, and electrostatic solvation free energies [8, 24, 39]. Here, electrostatic solvation free energies were computed using the MIBPB solver for the PoissonBoltzmann model [8]. At the residue level, the feature set comprises the amino acid composition and physical properties of the local neighborhood, mutation-induced pKa shifts, evolutionary
