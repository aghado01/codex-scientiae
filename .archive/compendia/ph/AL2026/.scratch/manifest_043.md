# Manifest: Page 043

## REPAIR_PROSE

- RAW: ```
The source code implementing the computational procedures used in this study is publicly available via a GitHub repository at https://github.com/Enhao-Liu/ interval-replacement .
```
  FIX: ```
The source code implementing the computational procedures used in this study is publicly available via a GitHub repository at https://github.com/Enhao-Liu/interval-replacement.
```

## REPAIR_MATH

- RAW: ```
Thus, how to compute some algebraically defined invariants (for example, the interval rank invariant and interval multiplicity) directly from the given filtration over P , without computing the persistent homology in advance, becomes a critical problem to be solved from the TDA perspective.
```
  FIX: ```
Thus, how to compute some algebraically defined invariants (for example, the interval rank invariant and interval multiplicity) directly from the given filtration over \( P \), without computing the persistent homology in advance, becomes a critical problem to be solved from the TDA perspective.
```

- RAW: ```
Definition 4.1. (1) For each linear category B , a linear category B , called the formal additive hull of B , is defined as follows:
```
  FIX: ```
Definition 4.1. (1) For each linear category \( B \), a linear category \( \bigoplus B \), called the formal additive hull of \( B \), is defined as follows:
```

- RAW: ```
$$
( \bigoplus B ) _ { 0 } \colon = \{ ( x _ { i } ) _ { i \in [ l ] } = ( x _ { 1 } , \dots , x _ { l } ) \ | \ x _ { 1 } , \dots , x _ { l } \in B _ { 0 } , \, l \geq 0 \} .
$$
```
  FIX: ```
\[
( \bigoplus B ) _ { 0 } \colon = \{ ( x _ { i } ) _ { i \in [ l ] } = ( x _ { 1 } , \dots , x _ { l } ) \ | \ x _ { 1 } , \dots , x _ { l } \in B _ { 0 } , \, l \geq 0 \} .
\]
```

- RAW: ```
Note that if l = 0 above, then [ l ] = ∅ , and ( x i ) i ∈ [ l ] is an empty sequence () . For each x = ( x i ) i ∈ [ l ] ∈ (   B ) 0 , we set | x | : = l , and call it the size of x .
```
  FIX: ```
Note that if \( l = 0 \) above, then \( [ l ] = \emptyset \), and \( ( x _ { i } ) _ { i \in [ l ] } \) is an empty sequence \( () \). For each \( x = ( x _ { i } ) _ { i \in [ l ] } \in ( \bigoplus B ) _ { 0 } \), we set \( | x | \colon = l \), and call it the size of \( x \).
```

- RAW: ```
Morphisms. For any x,y ∈ ( B ) 0 with x = ( x i ) i ∈ [ l ] , y = ( y j ) j ∈ [ m ] the set of morphisms from x to y is defined by setting
```
  FIX: ```
Morphisms. For any \( x , y \in ( \bigoplus B ) _ { 0 } \) with \( x = ( x _ { i } ) _ { i \in [ l ] } \), \( y = ( y _ { j } ) _ { j \in [ m ] } \) the set of morphisms from \( x \) to \( y \) is defined by setting
```

- RAW: ```
$$
( \bigoplus B ) ( x , y ) \colon = \{ \, [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \, | \, \alpha _ { j i } \in B ( x _ { i } , y _ { j } ) \text { for all } ( j , i ) \in [ m ] \times [ l ] \} ,
$$
```
  FIX: ```
\[
( \bigoplus B ) ( x , y ) \colon = \{ \, [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \, | \, \alpha _ { j i } \in B ( x _ { i } , y _ { j } ) \text { for all } ( j , i ) \in [ m ] \times [ l ] \} ,
\]
```

- RAW: ```
where α ji ( j,i ) ∈ [ m ] × [ l ] is a matrix of size ( m,l ) , which is defined to be the triple ( m,l, ( α ji ) ( j,i ) ∈ [ m ] × [ l ] ) of integers l,m ≥ 0 and a family of morphisms α ji ∈ B ( x i ,y j ) .
```
  FIX: ```
where \( [ \alpha _ { j i } ] _ { ( j , i ) \in [ m ] \times [ l ] } \) is a matrix of size \( ( m , l ) \), which is defined to be the triple \( ( m , l , ( \alpha _ { j i } ) _ { ( j , i ) \in [ m ] \times [ l ] } ) \) of integers \( l , m \geq 0 \) and a family of morphisms \( \alpha _ { j i } \in B ( x _ { i } , y _ { j } ) \).
```
