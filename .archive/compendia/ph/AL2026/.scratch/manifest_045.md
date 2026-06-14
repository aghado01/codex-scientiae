# Manifest: Page 045

## REPAIR_MATH
- RAW: ```
\alpha \coloneqq [ \alpha _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] } ,
```
  FIX: ```
$$
\alpha \coloneqq [ \alpha _ { j i } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] } ,
$$
```
- RAW: ```
( \bigoplus F ) ( \alpha ) \colon = [ F ( \alpha _ { j i } ) ] _ { ( j , i ) \in [ n ] \times [ n ] } \colon ( F ( x _ { i } ) ) _ { i \in [ m ] } \to ( F ( y _ { j } ) ) _ { j \in [ n ] } .
```
  FIX: ```
$$
( \bigoplus F ) ( \alpha ) \colon = [ F ( \alpha _ { j i } ) ] _ { ( j , i ) \in [ n ] \times [ n ] } \colon ( F ( x _ { i } ) ) _ { i \in [ m ] } \to ( F ( y _ { j } ) ) _ { j \in [ n ] } .
$$
```
- RAW: ```
\hat { F } ( \alpha ) \coloneqq [ F ( \alpha _ { i j } ) ] _ { j , i } \colon \bigoplus _ { i \in [ m ] } F ( x _ { i } ) \to \bigoplus _ { j \in [ n ] } F ( y _ { j } ) .
```
  FIX: ```
$$
\hat { F } ( \alpha ) \coloneqq [ F ( \alpha _ { i j } ) ] _ { j , i } \colon \bigoplus _ { i \in [ m ] } F ( x _ { i } ) \to \bigoplus _ { j \in [ n ] } F ( y _ { j } ) .
$$
```
- RAW: ```
[ p _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] }
```
  FIX: ```
$$
[ p _ { y _ { j } , x _ { i } } ] _ { ( j , i ) \in [ n ] \times [ m ] } \colon ( x _ { i } ) _ { i \in [ m ] } \to ( y _ { j } ) _ { j \in [ n ] }
$$
```
- RAW: ```
\left [ P _ { y _ { j } , x _ { i } } \right ] _ { ( i , j ) \in [ m ] \times [ n ] } = t ^ { [ P _ { y _ { j } , x _ { i } } ] } _ { ( j , i ) \in [ n ] \times [ m ] } \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } }
```
  FIX: ```
$$
\left [ P _ { y _ { j } , x _ { i } } \right ] _ { ( i , j ) \in [ m ] \times [ n ] } = t ^ { [ P _ { y _ { j } , x _ { i } } ] } _ { ( j , i ) \in [ n ] \times [ m ] } \colon \bigoplus _ { j \in [ n ] } P _ { y _ { j } } \to \bigoplus _ { i \in [ m ] } P _ { x _ { i } }
$$
```



## REPAIR_MATH
- RAW: ```
(2) Let F : B → C be a linear functor between linear categories. Then a functor F : B → C is defined as follows: We set ( F )(( x i ) i ∈ [ m ] ) : = ( F ( x i )) i ∈ [ m ] for each object ( x i ) i ∈ [ m ] ∈ ( B ) 0 , and for each morphism
```
  FIX: ```
(2) Let \( F \colon B \to C \) be a linear functor between linear categories. Then a functor \( \bigoplus F \colon \bigoplus B \to \bigoplus C \) is defined as follows: We set \( (\bigoplus F)((x_i)_{i \in [m]}) \coloneqq (F(x_i))_{i \in [m]} \) for each object \( (x_i)_{i \in [m]} \in (\bigoplus B)_0 \), and for each morphism
```
- RAW: ```
In particular, (   F )(()) : = () , and F ( J ) : = J for all J ∈ { J n, 0 , J 0 ,m | m,n ≥ 0 } . For example, J 0 ,m : ( x i ) i ∈ [ m ] → () is sent to J 0 ,m : ( F ( x i )) i ∈ [ m ] → () . If there is no confusion, we denote   F simply by F .
```
  FIX: ```
In particular, \( (\bigoplus F)(()) \coloneqq () \), and \( (\bigoplus F)(J) \coloneqq J \) for all \( J \in \{ J_{n, 0}, J_{0, m} \mid m,n \geq 0 \} \). For example, \( J_{0, m} \colon (x_i)_{i \in [m]} \to () \) is sent to \( J_{0, m} \colon (F(x_i))_{i \in [m]} \to () \). If there is no confusion, we denote \( \bigoplus F \) simply by \( F \).
```
- RAW: ```
Since () is a zero object in B , we may write () = 0 in B .
```
  FIX: ```
Since \( () \) is a zero object in \( \bigoplus B \), we may write \( () = 0 \) in \( \bigoplus B \).
```
- RAW: ```
Example 4.2. Let ζ : Z → P be an order-preserving map between posets. Then we have a linear functor k [ ζ ]: k [ Z ] → k [ P ] , which yields a linear functor k [ ζ ]: k [ Z ] → k [ P ] . If α : = [ α ji ] ( j,i ) ∈ [ n ] × [ m ] is a morphism in k [ Z ] , we denote ( k [ ζ ])( α ) simply by ζ ( α ) = [ ζ ( α ji )] ( j,i ) ∈ [ n ] × [ m ] .
```
  FIX: ```
**Example 4.2.** Let \( \zeta \colon Z \to P \) be an order-preserving map between posets. Then we have a linear functor \( k[\zeta] \colon k[Z] \to k[P] \), which yields a linear functor \( \bigoplus k[\zeta] \colon \bigoplus k[Z] \to \bigoplus k[P] \). If \( \alpha \coloneqq [\alpha_{ji}]_{(j,i) \in [n] \times [m]} \) is a morphism in \( \bigoplus k[Z] \), we denote \( (\bigoplus k[\zeta])(\alpha) \) simply by \( \zeta(\alpha) = [\zeta(\alpha_{ji})]_{(j,i) \in [n] \times [m]} \).
```
- RAW: ```
Proposition 4.3. Let B be a linear category and C an additive linear category. Then each linear functor F : B → C uniquely extends to a linear functor ˆ F : B → C , which we denote by the same letter F if there seems to be no confusion.
```
  FIX: ```
**Proposition 4.3.** Let \( B \) be a linear category and \( C \) an additive linear category. Then each linear functor \( F \colon B \to C \) uniquely extends to a linear functor \( \hat{F} \colon \bigoplus B \to C \), which we denote by the same letter \( F \) if there seems to be no confusion.
```
- RAW: ```
Proof Define a linear functor ˆ F : B → C as the composite ˆ F : = η C ◦ ( F ) . Namely, for each morphism α = α ji ( j,i ) ∈ [ n ] × [ m ] : ( x i ) i ∈ [ m ] → ( y j ) j ∈ [ n ] in B , we set
```
  FIX: ```
*Proof.* Define a linear functor \( \hat{F} \colon \bigoplus B \to C \) as the composite \( \hat{F} \coloneqq \eta_C \circ (\bigoplus F) \). Namely, for each morphism \( \alpha = [\alpha_{ji}]_{(j,i) \in [n] \times [m]} \colon (x_i)_{i \in [m]} \to (y_j)_{j \in [n]} \) in \( \bigoplus B \), we set
```
- RAW: ```
It is easy to see that this is the unique extension of F .
```
  FIX: ```
It is easy to see that this is the unique extension of \( F \).
```
- RAW: ```
Since each finitely generated projective module over k [ P ] is isomorphic to a finite direct sum of representable functors P x : = k [ P ]( x, -) , ( x ∈ P ), we have the following by applying the proposition above to the case where B = k [ P ] = A .
```
  FIX: ```
Since each finitely generated projective module over \( k[P] \) is isomorphic to a finite direct sum of representable functors \( P_x \coloneqq k[P](x, -) \), (\( x \in P \)), we have the following by applying the proposition above to the case where \( B = k[P] = A \).
```
- RAW: ```
Corollary 4.4. The Yoneda embedding Y A : A op → prj A , x  → P x : = A ( x, -) extends to an equivalence P : ( A ) op → prj A , ( x i ) i ∈ [ m ]  → i ∈ [ m ] P x i . Note that P maps each morphism p y,x : x → y in P to P y,x : P y → P x . Therefore, it maps each morphism
```
  FIX: ```
**Corollary 4.4.** The Yoneda embedding \( Y_A \colon A^{\mathrm{op}} \to \mathrm{prj}\,A \), \( x \mapsto P_x \coloneqq A(x, -) \) extends to an equivalence \( P \colon (\bigoplus A)^{\mathrm{op}} \to \mathrm{prj}\,A \), \( (x_i)_{i \in [m]} \mapsto \bigoplus_{i \in [m]} P_{x_i} \). Note that \( P \) maps each morphism \( p_{y,x} \colon x \to y \) in \( P \) to \( P_{y,x} \colon P_y \to P_x \). Therefore, it maps each morphism
```
