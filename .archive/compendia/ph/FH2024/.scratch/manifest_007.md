# Manifest: Page 007

## REPAIR_MATH
- RAW: ```
M \ \colon \quad 0 \, \longleftrightarrow \, \mathbb { F } \ \xrightarrow { ( 1 \, 0 ) } \, \mathbb { F } ^ { 2 } \, \longleftrightarrow \, \mathbb { C } \ \xrightarrow { ( 0 \, 1 ) } \, \mathbb { F } \ \xrightarrow { 0 } \, 0 ,
```
  FIX: ```
$$
M \ \colon \quad 0 \, \longleftrightarrow \, \mathbb { F } \ \xrightarrow { ( 1 \, 0 ) } \, \mathbb { F } ^ { 2 } \, \longleftrightarrow \, \mathbb { C } \ \xrightarrow { ( 0 \, 1 ) } \, \mathbb { F } \ \xrightarrow { 0 } \, 0 ,
$$
```
- RAW: ```
N \, \colon \quad 0 \, \longleftrightarrow \, \mathbb { F } \, \xrightarrow { ( 1 \, 1 ) } \, \mathbb { F } ^ { 2 } \, \longleftrightarrow \, \mathbb { F } \, \xrightarrow { 0 } \, 0 ,
```
  FIX: ```
$$
N \, \colon \quad 0 \, \longleftrightarrow \, \mathbb { F } \, \xrightarrow { ( 1 \, 1 ) } \, \mathbb { F } ^ { 2 } \, \longleftrightarrow \, \mathbb { F } \, \xrightarrow { 0 } \, 0 ,
$$
```
- RAW: ```
For zigzag modules, we require a generalization of the rank invariant that is equivalent to the barcode, because we seek to obtain information about the persistence of features in time. In [32], the author defined the rank invariant for multiparameter persistence modules as the map that sends a tuple of points ( a,b ) , where a < b , to the rank of the map M ( a < b ) . However, for zigzag modules only adjacent indices are comparable (i.e. a < b or b < a ). The following example shows that the rank invariant in [32] does not contain all the information about the interval decomposition of the zigzag module.
```
  FIX: ```
For zigzag modules, we require a generalization of the rank invariant that is equivalent to the barcode, because we seek to obtain information about the persistence of features in time. In [32], the author defined the rank invariant for multiparameter persistence modules as the map that sends a tuple of points \( ( a,b ) \), where \( a < b \), to the rank of the map \( M ( a < b ) \). However, for zigzag modules only adjacent indices are comparable (i.e. \( a < b \) or \( b < a \)). The following example shows that the rank invariant in [32] does not contain all the information about the interval decomposition of the zigzag module.
```
- RAW: ```
indexed by { 1 , 2 , 3 , 4 , 5 } . They both have the same rank invariant, but since M = [2 , 3] ⊕ [3 , 4] and N = [2 , 4] ⊕ [3 , 3] , they are not isomorphic.
```
  FIX: ```
indexed by \( \{ 1 , 2 , 3 , 4 , 5 \} \). They both have the same rank invariant, but since \( M = [2 , 3] \oplus [3 , 4] \) and \( N = [2 , 4] \oplus [3 , 3] \), they are not isomorphic.
```
- RAW: ```
Definition 2.9 Let P be a poset. We call a nonempty subset I of P an interval of P if for all p,q ∈ I and p ≤ r ≤ q it holds that r ∈ I and I is connected, i.e. for all p,q ∈ I there is a sequence p = p 1 ,...,p l = q of elements in I such that p i and p i +1 are comparable ( p i ≤ p i +1 or p i ≥ p i +1 for all 1 ≤ i ≤ l − 1 ).
```
  FIX: ```
Definition 2.9 Let \( P \) be a poset. We call a nonempty subset \( I \) of \( P \) an interval of \( P \) if for all \( p,q \in I \) and \( p \le r \le q \) it holds that \( r \in I \) and \( I \) is connected, i.e. for all \( p,q \in I \) there is a sequence \( p = p_1 , \dots , p_l = q \) of elements in \( I \) such that \( p_i \) and \( p_{i+1} \) are comparable (\( p_i \le p_{i+1} \) or \( p_i \ge p_{i+1} \) for all \( 1 \le i \le l - 1 \)).
```
- RAW: ```
For a persistence module M : P → Vec we denote by M | I its restriction to a subset I of P . Furthermore, we denote by lim ←− M | I = ( L, ( π p : L → M p ) p ∈ I ) the limit of M | I and by lim −→ M | I = ( C, ( i p : M p → C ) p ∈ I ) the colimit of M | I . See Appendix A for the definitions of limits and colimits.
```
  FIX: ```
For a persistence module \( M : P \to \text{Vec} \) we denote by \( M|_I \) its restriction to a subset \( I \) of \( P \). Furthermore, we denote by \( \lim_{\longleftarrow} M|_I = ( L, ( \pi_p : L \to M_p )_{p \in I} ) \) the limit of \( M|_I \) and by \( \lim_{\longrightarrow} M|_I = ( C, ( i_p : M_p \to C )_{p \in I} ) \) the colimit of \( M|_I \). See Appendix A for the definitions of limits and colimits.
```

## REPAIR_PROSE
- RAW: ```
(




)


(




)


...



















(




)


(




)


...



















(




)


(




)


...










.

.

.

.

.

.

.

.

.

.

.

.

.

.

.

```
  FIX: ```
```
