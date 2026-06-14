[Page 4]

![image 2](<DS2026/imageFile2.png>)

Figure 2: The worm with blue boundary represents a worm centered at p with width δ = 1 . The worm with red boundary represents an expanded worm, centered at p with width δ = 2 .

Definition 3.4 (ZZ-GRIL ) . Let M be a quasi zigzag persistence module. Then, the ZigZag Generalized Rank Invariant Landscape is a function λ M : ZZ × Z × N → N defined as

where p ∈ ZZ × Z .

$$
\lambda ^ { M } ( p , k ) \coloneqq \sup \left \{ \delta \geq 0 \, \colon r k ^ { M } \left ( \boxed { p } \bmod { ^ { 2 } _ { \delta } } \right ) \geq k \right \} ,
$$

The basic idea of ZZ-GRIL is similar to G RIL . However, we note that the underlying poset structure is very different. For computations, we consider a finite subposet of ZZ × Z and cover it with worms. Then, we compute generalized rank over these worms to define the landscape function (ZZ-GRIL ).

### 3.1 Stability of ZZ-GRIL

We prove the stability of ZZ-GRIL by showing that its perturbation is bounded by the interleaving distance between two quasi zigzag persistence modules. The definition of interleaving distance, d I ( M,N ) , (see Definition A.3 in Appendix A) between two zigzag persistence modules M,N can be extended to quasi zigzag persistence modules.

There is an alternate notion of proximity on the space of persistence modules which uses Generalized Ranks computed on all intervals. This is known as erosion distance Kim & Mémoli (2021). We define a distance similar to erosion distance on the space of quasi zigzag persistence modules based on their generalized ranks computed over worms. For this, we need the notion of ϵ thickening .

Let I ( ZZ × Z ) denote the collection of all subposets in ZZ × Z such that their corresponding subposets in Z 2 are intervals. For ϵ ∈ Z + , the ϵ -thickening of I is defined as

$$
I ^ { \epsilon } \colon = \{ r \in \mathbb { Z } \mathbb { Z } \times \mathbb { Z } \colon \exists \mathfrak { q } \in I \text { such that } | | r - \mathfrak { q } | | _ { \infty } \leq \epsilon \} \, .
$$

Definition 3.5. Let L denote the collection of all worms in ZZ × Z . Let M and N be quasi zigzag persistence modules. The erosion distance is defined as:

$$
d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \coloneqq & \inf _ { \epsilon \geq 0 } \{ \forall \mathbf p \bigsqcup _ { \delta } ^ { 2 } \in \mathbf I ( \mathbb { Z } \mathbb { Z } \times \mathbb { Z } ) , \\ & r k ^ { M } \left ( \lfloor \mathbf p \rfloor _ { \delta } ^ { 2 } \right ) \geq r k ^ { N } \left ( \lfloor \mathbf p \rfloor _ { \delta + \epsilon } ^ { 2 } \right ) \text { and } \\ & r k ^ { N } \left ( \lfloor \mathbf p \rfloor _ { \delta } ^ { 2 } \right ) \geq r k ^ { M } \left ( \lfloor \mathbf p \rfloor _ { \delta + \epsilon } ^ { 2 } \right ) \} .
$$

Note that p 2 δ + ϵ contains the ϵ -thickening of p 2 δ .

Proposition 3.6. Given two quasi zigzag persistence modules M and N , d L E ( M,N ) ≤ d I ( M,N ) where d I denotes the interleaving distance between M and N .

Proposition 3.6 leads us to Theorem 3.7.

Theorem 3.7. Let M and N be two quasi zigzag persistence modules. Let λ M and λ N denote the ZZ-GRIL functions of M and N respectively. Then, M N

$$
| | \lambda ^ { M } - \lambda ^ { N } | | _ { \infty } = d _ { \mathcal { E } } ^ { \mathcal { L } } ( M , N ) \leq d _ { \mathcal { I } } ( M , N ) .
$$
