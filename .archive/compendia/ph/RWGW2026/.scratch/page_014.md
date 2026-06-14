[Page 14]

![In this image I can see a graph and a line chart. I can also see the numbers on the graph.](<RWGW2026/imageFile6.png>)

C-C atom set


0.06


Wild

Wild


0.04


Mutant

Mutant

0.02


0.00

2.0

0.00125

Wild

0.00100

1.5

Mutant

0.00075

Wild


1.0

Mutant

0.00050

0.5

0.00025

0.0


Filtration Radius

Figure 6: An illustration of PSL descriptors for C-C interactions from VR complexes using modified distance filtration at residue 37 mutation site from L to S in protein 1A5E of S2648 dataset. Top panel: Illustration of zero-dimensional PSL descriptors. Bottom panel: Illustration of one-dimensional PSL descriptors. The left axis represents the Sheaf Betti numbers β 0 and β 1 . The right axis represents the minimal nonzero eigenvalues λ 0 and λ 1 of the persistent sheaf Laplacian.

$$
d ( a _ { i } , a _ { j } ) = \begin{cases} E _ { d } ( a _ { i } , a _ { j } ) & \text {if } ( a _ { i } \in A _ { m } \wedge a _ { j } \in A _ { m n } ( r ) ) \vee ( a _ { i } \in A _ { m n } ( r ) \wedge a _ { j } \in A _ { m } ) , \\ \infty & \text {otherwise} , \end{cases} ( 7 )
$$

where E d ( a i ,a j ) denotes the Euclidean distance between atoms a i and a j . By assigning an infinite distance to atom pairs belonging to the same set, this metric effectively filters out intra-set edges, thereby focusing the topological analysis exclusively on the interactions between the mutation site and its surrounding environment. Complementing this, Alpha complexes [15] are constructed using the standard Euclidean distance on the same atom sets to capture local geometric constraints.

Spectral features are extracted from the constructed complexes to serve as local PSL descriptors. In this study, a cutoff distance of 16Å from the mutation site is employed to identify mutation neighborhood atoms. For the VR complex, the filtration is conducted over a range of 3Å to 9Å with a step size of 1Å. For each filtration step, spectral properties are derived from the Persistent Sheaf Laplacian. Regarding the harmonic components, the count of zero eigenvalues is recorded, generating a 7-dimensional feature vector for each atom set. For the non-harmonic components, eight statistical properties are extracted from the non-zero eigenvalue spectrum: maximum, minimum, mean, sum, standard deviation, variance, and the eigenvalue count. This procedure yields a 72-dimensional feature vector per atom set. Similarly, for the Alpha complex, the one-dimensional harmonic and non-harmonic components of the persistent sheaf Laplacians are analyzed using the same statistical extraction method. The final topological feature representation is constructed by combining the extracted features from the zero-dimensional VR models and the one-dimensional Alpha models. These feature vectors are computed for the wild-type structure, the mutant structure, and the difference between them. The concatenation of these vectors results in a comprehensive feature representation for a single protein, characterized by a 3402-dimensional vector. To illustrate the discriminative capacity of these features, Fig. 6 and Fig. 7 depict the zero-dimensional and one-dimensional PSL descriptors for both wild-type and mutant structures of protein 1A5E from the S2648 dataset. Fig. 6 utilizes atom sets A C ∩ A m and A C ∩ A mn ( r ) to generate VR complexes with a modified distance d -based filtration, effectively revealing hydrophobic C-C interactions. Similarly, Fig. 7 utilizes atom sets A C ∩ A m and A O ∩ A mn ( r ) to generate VR complexes with d -based filtration, revealing the polar C-O interactions.
