[Page 45]

(2) Let \( F \colon B \to C \) be a linear functor between linear categories. Then a functor \( \bigoplus F \colon \bigoplus B \to \bigoplus C \) is defined as follows: We set \( (\bigoplus F)((x_i)_{i \in [m]}) \coloneqq (F(x_i))_{i \in [m]} \) for each object \( (x_i)_{i \in [m]} \in (\bigoplus B)_0 \), and for each morphism

$$
$$
\alpha \coloneqq [ \alpha _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] } ,
$$
$$

we set

$$
$$
( \bigoplus F ) ( \alpha ) \colon = [ F ( \alpha _ { j i } ) ] _ { ( j , i ) \in [ n ] \times [ n ] } \colon ( F ( x _ { i } ) ) _ { i \in [ m ] } \to ( F ( y _ { j } ) ) _ { j \in [ n ] } .
$$
$$

In particular, \( (\bigoplus F)(()) \coloneqq () \), and \( (\bigoplus F)(J) \coloneqq J \) for all \( J \in \{ J_{n, 0}, J_{0, m} \mid m,n \geq 0 \} \). For example, \( J_{0, m} \colon (x_i)_{i \in [m]} \to () \) is sent to \( J_{0, m} \colon (F(x_i))_{i \in [m]} \to () \). If there is no confusion, we denote \( \bigoplus F \) simply by \( F \).

Since \( () \) is a zero object in \( \bigoplus B \), we may write \( () = 0 \) in \( \bigoplus B \).

**Example 4.2.** Let \( \zeta \colon Z \to P \) be an order-preserving map between posets. Then we have a linear functor \( k[\zeta] \colon k[Z] \to k[P] \), which yields a linear functor \( \bigoplus k[\zeta] \colon \bigoplus k[Z] \to \bigoplus k[P] \). If \( \alpha \coloneqq [\alpha_{ji}]_{(j,i) \in [n] \times [m]} \) is a morphism in \( \bigoplus k[Z] \), we denote \( (\bigoplus k[\zeta])(\alpha) \) simply by \( \zeta(\alpha) = [\zeta(\alpha_{ji})]_{(j,i) \in [n] \times [m]} \).

**Proposition 4.3.** Let \( B \) be a linear category and \( C \) an additive linear category. Then each linear functor \( F \colon B \to C \) uniquely extends to a linear functor \( \hat{F} \colon \bigoplus B \to C \), which we denote by the same letter \( F \) if there seems to be no confusion.

*Proof.* Define a linear functor \( \hat{F} \colon \bigoplus B \to C \) as the composite \( \hat{F} \coloneqq \eta_C \circ (\bigoplus F) \). Namely, for each morphism \( \alpha = [\alpha_{ji}]_{(j,i) \in [n] \times [m]} \colon (x_i)_{i \in [m]} \to (y_j)_{j \in [n]} \) in \( \bigoplus B \), we set

$$
$$
\hat { F } ( \alpha ) \coloneqq [ F ( \alpha _ { i j } ) ] _ { j , i } \colon \bigoplus _ { i \in [ m ] } F ( x _ { i } ) \to \bigoplus _ { j \in [ n ] } F ( y _ { j } ) .
$$
$$

It is easy to see that this is the unique extension of \( F \).


Since each finitely generated projective module over \( k[P] \) is isomorphic to a finite direct sum of representable functors \( P_x \coloneqq k[P](x, -) \), (\( x \in P \)), we have the following by applying the proposition above to the case where \( B = k[P] = A \).

**Corollary 4.4.** The Yoneda embedding \( Y_A \colon A^{\mathrm{op}} \to \mathrm{prj}\,A \), \( x \mapsto P_x \coloneqq A(x, -) \) extends to an equivalence \( P \colon (\bigoplus A)^{\mathrm{op}} \to \mathrm{prj}\,A \), \( (x_i)_{i \in [m]} \mapsto \bigoplus_{i \in [m]} P_{x_i} \). Note that \( P \) maps each morphism \( p_{y,x} \colon x \to y \) in \( P \) to \( P_{y,x} \colon P_y \to P_x \). Therefore, it maps each morphism

$$
$$
[ p _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] }
$$
$$

in A to the morphism

$$
$$
\left [ P _ { y _ { j } , x _ { i } } \right ] _ { ( i , j ) \in [ m ] \times [ n ] } = t ^ { [ P _ { y _ { j } , x _ { i } } ] } _ { ( j , i ) \in [ n ] \times [ m ] } \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } }
$$
$$
