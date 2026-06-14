[Page 13]

In this case, we define \( [ K,L ] := \{ y \in P \mid x \leq y \leq z \text{ for some } x \in K \text{ and for some } z \in L \} \). Therefore, every interval \( I \) of \( P \) can be expressed by \( [\text{sc}( I ) , \text{sk}( I )] \).

To each interval, one may associate a persistence module as follows.

# Definition 2.5. Let \( I \) be an interval of \( P \).

(1) A persistence module \( V_I \) over \( P \) is defined as follows. For \( x \in P \),

$$
$$
V _ { I } ( x ) \colon = \begin{cases} \mathbb { k } , & \text {if } x \in I , \\ 0 , & \text {otherwise} , \end{cases}
$$
$$

and for \( p \in k[P](x,y) \),

$$
$$
V _ { I } ( p ) \coloneqq \begin{cases} k \mathbb { I } _ { k } , & \text {if } ( x , y ) \in [ \leq ] _ { I } \text { and } p \coloneqq k p _ { y , x } \text { for some } k \in \mathbb { K } , \\ 0 , & \text {otherwise.} \end{cases}
$$
$$

It is easy to check that \( V_I \) is indecomposable.

- (2) A persistence module isomorphic to \( V_I \) for some \( I \in \mathcal{I} \) is called an interval module.
- (3) A persistence module is said to be interval-decomposable if it is isomorphic to a finite direct sum of interval modules. Thus \( 0 \) is trivially interval-decomposable.


We will use the notation \( d_M(L) \) to denote the multiplicity of an indecomposable direct summand \( L \) of a module \( M \) in its indecomposable decomposition as explained in the following well-known theorem.

Theorem 2.6 (Krull–Schmidt). Let \( \mathcal{C} \) be a finite \( k \)-linear category, and fix a complete set \( \mathcal{L} = \mathcal{L}_{\mathcal{C}} \) of representatives of isoclasses of indecomposable objects in \( \text{mod }\mathcal{C} \). Then every finite-dimensional left \( \mathcal{C} \)-module \( M \) is isomorphic to the direct sum \( \bigoplus_{L \in \mathcal{L}} L^{d_M(L)} \) for some unique function \( d_M : \mathcal{L} \to \mathbb{Z}_{\geq 0} \). Therefore another finite-dimensional left \( \mathcal{C} \)-module \( N \) is isomorphic to \( M \) if and only if \( d_M = d_N \). In this sense, the function \( d_M \) is a complete invariant of \( M \) under isomorphisms.

In the sequel, we simply call \( d_M(L) \) the interval multiplicity of \( L \) (in \( M \)) whenever \( L \) is an interval module. In one-parameter persistent homology, this function \( d_M \) corresponds to the persistence diagram of \( M \).

Notation 2.7. Let \( M \in \text{mod }A \), and \( x,y \in P \).

(1) We set \( P_x := A(x, -) \) (resp. \( P'_x := A^{\text{op}}(x, -) \)) to be the projective indecomposable \( A \)-module (resp. \( k[P^{\text{op}}] \)-module) corresponding to the vertex \( x \), and \( Q_x := D(A(-, x)) \) (resp. \( Q'_x := D(A^{\text{op}}(-, x)) \)) to be the injective indecomposable \( A \)-module (resp. \( A^{\text{op}} \)-module) corresponding to the vertex \( x \).
