[Page 17]

It is easy to see that when p = 0, the p -persistent Hodge Laplacian gives exactly the usual Hodge Laplacian ∆ n , l : Ω k n ( M l ) → Ω k n ( M l ) restricted to the space of normal forms. We then define the p persistent normal harmonic fields as the kernel of the p -persistent Hodge Laplacian H k , p n = ker ∆ p n , l , which can be identified with the space ker ˜ δ l , p ∩ ker d l . Note that by the extension construction and R l , p ◦ I l , p = Id, one can see that ker ˜ δ l , p ⊂ ker δ gets smaller as p increases, which confirms that fewer cohomology generators persist longer.

## 4.2. Discretization of p-persistent de Rham cohomology

The regular Cartesian grid allows one to define persistent graph Laplacian on manifolds in the same way as persistent graph Laplacian [61]. It also allows defining persistent Hodge Laplacian in a consistent way, with the inclusion of nontrivial Hodge stars.

Recall that the discrete di ff erential k -forms can be seen as a k -co-chain, i.e., a linear mapping from the chain space C k to R that sends a k -chain c k = i a i σ i to c k ω = i a i W i , where W i = σ i ω is the integral of a smooth k -form ω over the k -cell σ i .

By varying the isovalue of the level set function f , we can get a sequence of cell complexes given as nested sequences of sub-cell complexes of K satisfying the normal boundary conditions.

$$
\emptyset = K _ { 0 } \subset K _ { 1 } \subset \cdots \subset K _ { s - 1 } \subset K _ { s } = K .
$$

See Figure 4 for an example of such a nested sequence of sub-cell complexes in a 2D Cartesian grid. Denote by C k ( K l ) the space of discrete k -forms on sub-complex K l with 0 ≤ l ≤ s . Note that K l ⊂ K l + 1 . A discrete k -form on K l can be easily extended to K l + 1 by solving the discrete Laplace equation with the above boundary conditions for values on every k -cells in K l , l + 1 = Cl( K l + 1 \ K l ), the closure of the di ff erence complex. We denote this extension map as I l , 1 : C k ( K l ) → C k ( K l + 1 ) and by I l , p = I l + p − 1 , 1 ◦ I l + p − 2 , 1 ◦ ··· ◦ I l , 1 : C k ( K l ) → C k ( K l + p ) the extension mapping from the space of discrete k -forms on K l to the space of discrete k -forms on K l + p , which may also be constructed directly by solving the Laplace equation on K l , l + p = Cl( K l + p \ K l ). With this extension mapping, the space of discrete k -forms on K l can be seen as a subspace of discrete k -forms on K l + p .

![In this image we can see a graph.](<STGW2024/imageFile5.png>)

#

Figure 4. An example of a nested sequence of sub-cell complexes in a 2D Cartesian grid under the normal boundary condition, illustrating the inclusion of normal supports for 0, 1, and 2 discrete di ff erential forms for an evolution of manifolds. Here the manifolds are represented by the bounded regions of the blue isocurves of a level set function.
