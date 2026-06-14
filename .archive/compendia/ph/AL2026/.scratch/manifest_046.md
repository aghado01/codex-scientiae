# Manifest: Page 046

## REPAIR_PROSE
- RAW: `Similarly, the Yoneda embedding Y A : A → prj( A op ) , x  → P ′ x : = A (,x ) extends to an equivalence P ′ : A → prj A op , ( x i ) i ∈ [ m ]  → i ∈ [ m ] P ′ x i .`
  FIX: `Similarly, the Yoneda embedding \( Y_A : A \to \text{prj}( A^{\text{op}} ) , x \mapsto P' x := A (-,x) \) extends to an equivalence \( P' : A \to \text{prj} A^{\text{op}} , ( x_i )_{i \in [ m ]} \mapsto \bigoplus_{i \in [ m ]} P' x_i \).`

- RAW: `Definition 4.5. Let I be an interval of P . Choose any choice maps c : sc( ⇑ I ) → sc( I ) and d : sk( ⇓ I ) → sk( I ) , and set ε 1 : = ε 1 ( c ) , π 1 : = π 1 ( d ) as in Propositions 3.18 and 3.23 . Choose also any ( b,a ) ∈ sk( I ) × sc( I ) such that b ≥ a , and set λ : = λ ( b,a ) as in Proposition 3.24 . Then by Corollary 4.4 , there exists a unique triple ( g 1 , g 2 , g 3 ) of morphisms in k [ P ] such that`
  FIX: `Definition 4.5. Let \( I \) be an interval of \( P \). Choose any choice maps \( c : \text{sc}( \Uparrow I ) \to \text{sc}( I ) \) and \( d : \text{sk}( \Downarrow I ) \to \text{sk}( I ) \), and set \( \varepsilon_1 := \varepsilon_1 ( c ) \), \( \pi_1 := \pi_1 ( d ) \) as in Propositions 3.18 and 3.23. Choose also any \( ( b,a ) \in \text{sk}( I ) \times \text{sc}( I ) \) such that \( b \geq a \), and set \( \lambda := \lambda ( b,a ) \) as in Proposition 3.24. Then by Corollary 4.4, there exists a unique triple \( ( g_1 , g_2 , g_3 ) \) of morphisms in \( k [ P ] \) such that`

- RAW: `3 The following are the explicit forms of g 1 , g 2 , g 3 :`
  FIX: `The following are the explicit forms of \( g_1 , g_2 , g_3 \):`

- RAW: `for all a c ∈ sc 1 ( I ) and a ∈ sc( I ) ; and`
  FIX: `for all \( a_c \in \text{sc}_1( I ) \) and \( a \in \text{sc}( I ) \); and`

- RAW: `for all b ∈ sk( I ) and b d ∈ sk 1 ( I ) ; and g 3 is the block matrix with the size sk( I ) × sc( I ) , the ( b,a ) -entry of g 3 , given by p b,a , is the only non-zero entry.`
  FIX: `for all \( b \in \text{sk}( I ) \) and \( b_d \in \text{sk}_1( I ) \); and \( g_3 \) is the block matrix with the size \( \text{sk}( I ) \times \text{sc}( I ) \), the \( ( b,a ) \)-entry of \( g_3 \), given by \( p_{b,a} \), is the only non-zero entry.`

- RAW: `Notation 4.6. Let B be a linear category, W a B -module, and m,n positive integers, and consider a morphism g = g ji ( j,i ) ∈ [ n ] × [ m ] : ( x i ) i ∈ [ m ] → ( y j ) j ∈ [ n ] in B . Then by applying the convention in Proposition 4.3 in the case where C = mod k , we write`
  FIX: `Notation 4.6. Let \( \mathcal{B} \) be a linear category, \( W \) a \( \mathcal{B} \)-module, and \( m,n \) positive integers, and consider a morphism \( g = ( g_{ji} )_{( j,i ) \in [ n ] \times [ m ]} : ( x_i )_{i \in [ m ]} \to ( y_j )_{j \in [ n ]} \) in \( \mathcal{B} \). Then by applying the convention in Proposition 4.3 in the case where \( \mathcal{C} = \text{mod } k \), we write`

## REPAIR_MATH
- RAW: ```
$$
g _ { 1 } \colon = \begin{bmatrix} \hat { p } _ { a , a _ { c } } \end{bmatrix} _ { ( a _ { c } , a ) \in s c _ { 1 } ( I ) \times s c ( I ) } \quad \text {with}
$$

$$
) \left \lfloor \begin{array} { c } \ w i t h \ t h e n t r i e s \ g i v e n \ b y \end{array} \right \rfloor \ w i t h \left ( D \right )
$$
```
  FIX: ```
$$
g _ { 1 } \colon = \begin{bmatrix} \hat { p } _ { a , a _ { c } } \end{bmatrix} _ { ( a _ { c } , a ) \in \text{sc} _ { 1 } ( I ) \times \text{sc} ( I ) }
$$

with the entries given by
```
