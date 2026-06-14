[Page 24]

Let { x α i , i = 1 , ··· , s } be the location coordinates of all s atoms in an atom pair, where α denotes the atom type of the atom either in the protein or in the ligand. For this atom pair, a level set function can then be obtained by considering the negative sum of Gaussian density functions defined at the xyz coordinates of all atoms, given as

$$
\rho ( \mathbf x , \tau ) = - \sum _ { i = 1 } ^ { s } \exp \left ( - \left ( \frac { \| \mathbf x - \mathbf x _ { i } ^ { \alpha } \| } { \tau r _ { i } ^ { \alpha } } \right ) ^ { 2 } \right ) ,
$$

where || x − x α i || is the Euclidean distance from position x to the location x α i of the i -th atom, τ is a scalar value, and r α i is the van der Waals radius of the i -th atom, determined by the atom type α . Given an isovalue c , the sublevel set

$$
M = \{ \mathbf x | \rho ( \mathbf x , \tau ) \leq c \}
$$

defines a compact manifold in R 3 with its boundary given by the isosurface ∂ M = { x | ρ ( x ,τ ) = c } . A filtration of a manifold for the atom pair can then be obtained by choosing a list of evenly spaced isovalues of this level set function (5.1). Let c 1 < c 2 < ··· < c s be such isovalues. We have their corresponding sublevel sets given as follows:

$$
M _ { 1 } \subset M _ { 2 } \subset \cdots \subset M _ { s } ,
$$

where M i is the compact manifold associated to isovalue c i . In Figure 9, we present one example of the resulting filtration of manifolds at 3 di ff erent isovalues for atom pair OH in protein-ligand complex 4tmn. Note that the function (5.1) is a special case of the flexibility rigidity index (FRI) density function [47], which has been shown computationally stable in converting discrete point cloud representations to continuous embeddings, and been used for generating protein boundary surfaces [18] and interactive manifolds [47]. Therefore, one can also make other reasonable choices of FRI density functions to generate the filtration of manifolds.

![In this image we can see a group of people.](<STGW2024/imageFile10.png>)
