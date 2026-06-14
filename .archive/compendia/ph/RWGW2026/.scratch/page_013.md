[Page 13]

![There is a graph with different colors and numbers on it.](<RWGW2026/imageFile5.png>)

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01



0.01

0.01

0.01

0.01

0.01

0.01

0.01

0.01


1-D Nonharmonic Spectra

1-D Harmonic Spectra

0-D Nonharmonic Spectra

0-D Harmonic Spectra

2.5

12.5

1.00

2.0

10.0

0.75


7.5

0.50

1.0

5.0

0.25

0.5

2.5

0.00

0.0

0.8.0

1.0

1.5

1.5

0.0

0.5

0.5

0.0

1.0

1.5

1.0

1.5

0.5

0.0

0.5

Figure 5: Illustration of persistent sheaf Laplacians. (a): a filtration process of the Rips complex from a point cloud data. (b): the persistent multiplicity of zero eigenvalues from the sheaf Laplacian matrices in 0-D and 1-D dimensions. (c): the minimal value of non-zero eigenvalues from the zero-dimensional and one-dimensional sheaf Laplacian matrices.

## 3.2 Sheaf Laplacian feature generation for protein

In the SheafLapNet architecture, protein structures are modeled as sets of simplicial complexes, from which PSLs are computed to extract topological features. To balance computational efficiency with the capability to capture essential physical interactions, the model employs an element-specific and site-specific atom subsetting strategy. Atoms within the three-dimensional protein structure are partitioned into mutation-site atoms, denoted as A m , and mutation neighborhood atoms located within a cutoff radius r , denoted as A mn ( r ). This partitioning is applied to both wild-type and mutant structures. Leveraging the element-specific representation framework [5], the model focuses on interactions involving carbon (C), nitrogen (N), and oxygen (O) atoms. By considering the intersections of these element types between the mutation site and its neighborhood, nine distinct pairwise atom combinations are constructed. These combinations encode specific interaction types. For instance, the pairing of carbon atoms in the mutation site ( A C ∩ A m ) with those in the neighborhood ( A C ∩ A mn ( r )) captures hydrophobic C-C interactions, whereas combinations involving carbon and oxygen ( A C ∩ A m and A O ∩ A mn ( r )) characterize polar C-O interactions. These element-specific and site-specific sets subsequently underpin the multiscale sheaf Laplacian embeddings.

To accurately capture the topological interactions within the defined atom sets, we construct VR complexes [46] and Alpha complexes [15]. For the VR complex construction, we employ a modified distance function, d , designed to specifically isolate interfacial interactions between distinct atom sets (e.g., between the mutation site A m and the neighborhood A mn ( r )). The modified metric is defined as:
