[Page 13]

![In the image provided, there are two triangles labeled as triangle ABC and triangle DEF. The angles of the triangles are labeled as 30 and 45 degrees. The sides of the triangles are labeled as a, b, and c.](<DLST2026/imageFile7.png>)


Figure 9. Example of a multivector field on a simplicial complex.

We write Sol V ( A ) for the family of all solutions in the graph G V such that im ρ ⊂ A . It will be handy to distinguish the following subsets of Sol V ( A ):

$$
\[
\text{Paths}_{\mathcal{V}}(A) \coloneqq \{ \rho \in \text{Sol}_{\mathcal{V}}(A) \mid \text{dom } \rho \text{ is bounded} \} , \\
\text{Paths}_{\mathcal{V}}(B_s, B_e, A) \coloneqq \{ \rho \in \text{Paths}_{\mathcal{V}}(A) \mid \rho^{\sqsubset} \in B_s \text{ and } \rho^{\sqsupset} \in B_e \} , \\
\text{iSol}_{\mathcal{V}}(A) \coloneqq \{ \rho \in \text{Sol}_{\mathcal{V}}(A) \mid \text{dom } \rho = \mathbb{Z} \} .
\]
$$

In particular, Paths V ( B s ,B e ,A ) contains all bounded solutions in A with the starting point in B s and the end point in B e . On the other hand iSol V ( A ) consists of all bi-infinite solutions in A , we call them full solutions .

While useful, the above notion of a solution is not enough to capture the essential structure of a multivector field. Therefore, we distinguish another type of solutions, called essential . In particular, a full solution φ is called right-essential ( left-essential ) if for every t ∈ Z there exist s > t ( s < t ) such that [ φ ( t )] V ̸ = [ φ ( s )] V or [ φ ( s )] V is critical. A full solution φ is called essential if it is both rightand left-essential. In other words, a full solution is essential if it leaves every regular multivector it enters within a finite amount of steps—both in forward and backward time direction. Note that a regular multivector may still be visited an infinite number of times by a single essential solution. We denote the set of all essential solutions in A ⊂ X by eSol V ( A ), and the subset of essential solutions passing through x ∈ A by


$$
\[
\text{eSol}_{\mathcal{V}}(x, A) \coloneqq \{ \varphi \in \text{eSol}_{\mathcal{V}}(A) \mid \varphi(0) = x \} .
\]
$$

We usually use ρ and γ for non-essential solutions and φ and ψ for essential solutions. To summarize, we have the following correspondence between the introduced families of solutions:

$$
\[
\text{eSol}_{\mathcal{V}}(x, A) \subset \text{eSol}_{\mathcal{V}}(A) \subset \text{iSol}_{\mathcal{V}}(A) \subset \text{Sol}_{\mathcal{V}}(A) \supset \text{Paths}_{\mathcal{V}}(A) \supset \text{Paths}_{\mathcal{V}}(x, y, A) .
\]
$$

Similarly to paths in a graph, given two solutions ρ, γ ∈ Sol V ( A ), right- and leftbounded, respectively, such that γ ⊏ ∈ F V ( ρ ⊐ ) we write ρ · γ for the new solution constructed as the concatenation 1 . Sometimes, for simplicity, we identify a point x ∈ X with the trivial solution ρ x : { 0 } → X , defined ρ x (0) := x . For instance, by x · y · z we mean the solution ρ := ρ x · ρ y · ρ z (under the assumption that y ∈ F V ( x ) and z ∈ F V ( y )), that is
