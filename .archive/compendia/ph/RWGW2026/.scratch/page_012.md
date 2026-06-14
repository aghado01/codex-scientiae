[Page 12]

![In this image, we can see a diagram with some lines and points.](<RWGW2026/imageFile5.png>)

We define the subspace C q +1 S , T as C q +1 S , T = { c ∈ C q +1 T | ( d q T ) ∗ ( c ) ∈ C q S } . Let d q S , T denote the adjoint map of the restricted operator ( d q T ) ∗ | C q +1 S , T . The q -th PSL, denoted as ∆ S , T q , is defined as: , q q q 1 q 1

$$
\Delta _ { q } ^ { \mathcal { I } , \mathcal { T } } = ( d _ { \mathcal { I } , \mathcal { T } } ^ { q } ) ^ { * } d _ { \mathcal { I } , \mathcal { T } } ^ { q } + d _ { \mathcal { I } } ^ { q - 1 } ( d _ { \mathcal { I } } ^ { q - 1 } ) ^ { * } .
$$

The spectral properties of the PSL provide key topological invariants. Specifically, the dimension of the zero-eigenspace (kernel) of the operator corresponds to the q -th persistent sheaf Betti number, denoted β S , T q with β S , T q = dim(ker∆ S , T q ). This study utilizes cellular sheaves constructed on labeled simplicial complexes to model

protein structures using atomic partial charges, following methodologies established in existing literature [53]. A general framework is first defined for constructing sheaves on a labeled simplicial complex X , where each vertex is associated with a quantity q . Let F : X → R be a nowhere-zero function. The sheaf is constructed by assigning the stalk R to each simplex. For a face relation [ v 0 ,...,v n ] ≤ [ v 0 ,...,v n ,v n +1 ,...,v m ] (where orientation is not relevant), the linear morphism S ([ v 0 ,...,v n ] ≤ [ v 0 ,...,v n ,v n +1 ,...,v m ]) is defined as the scalar multiplication by:

$$
\frac { F ( [ v _ { 0 } , \dots , v _ { n } ] ) q _ { n + 1 } \cdots q _ { m } } { F ( [ v _ { 0 } , \dots , v _ { n } , v _ { n + 1 } , \dots , v _ { m } ] ) } .
$$

To adapt this framework for protein analysis, non-geometrical information is incorporated by employing atomic partial charges obtained from the PDB2PQR package [24]. A Rips or Alpha filtration of graphs is constructed wherein vertices v i represent atoms and edges e ij represent interactions between atoms v i and v j . The cellular sheaf is defined such that each stalk is the real line R . For the specific face relation v i ⪯ e ij (where a vertex v i is a face of the edge e ij ), the restriction morphism is explicitly defined as multiplication by q j r ij , where q j is the partial charge of the neighboring atom v j , and r ij represents the Euclidean length of the edge e ij . The harmonic spectra of the resulting PSL reveal topological invariants, while the nonharmonic spectra represent geometric information of the data. Consequently, these spectra are utilized as the input features for the SheafLapNet model.

To illustrate the Persistent Sheaf Laplacian framework, we present an example using a point cloud dataset consisting of 12 points, as depicted in Figure 5. The topological structure is modeled through a Vietoris-Rips (VR) complex filtration, visualized in Figure 5(a). Here, heterogeneous information is explicitly mapped onto the domain, with nodes assigned distinct "charge" values of 1 and 0.01. As the filtration parameter increases, the connectivity of the point cloud evolves, generating a sequence of nested simplicial complexes that serves as the domain for our sheaf-theoretic analysis. Figure 5(b) presents the corresponding harmonic spectral analysis derived from the persistent sheaf Laplacians, specifically plotting the persistent multiplicities of the zero eigenvalues. These multiplicities correspond to the Sheaf Betti numbers, which generalize standard topological invariants by incorporating heterogeneous information such as atomic partial charges. Complementing this harmonic analysis, Figure 5(c) displays the nonharmonic spectral information, specifically the evolution of the minimum non-zero eigenvalues. These values quantify the connectivity strength and local geometric rigidity, offering a continuous measure of the intrinsic physical and chemical interactions encoded within the sheaf.
