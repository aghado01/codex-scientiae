# Manifest: Page 020

## REPAIR_MATH
- RAW: ```
\lim _ { \leftarrow } M ( \cdot , z - r ) | _ { [ x - r , x + r ] } \stackrel { \phi } { \longrightarrow } & \lim _ { \substack { \longmapsto & \longmapsto \\ \downarrow \\ \leftarrow \right ] } } M ( \cdot , z + r ) | _ { [ x - r , x + r ] } \\ \lim _ { \leftarrow } N ( \cdot , z - h ) | _ { [ x - h , x + h ] } \stackrel { \psi } { \longrightarrow } & \underset { \longrightarrow } { \lim } N ( \cdot , z + h ) | _ { [ x - h , x + h ] }
```
  FIX: ```
$$
\lim _ { \leftarrow } M ( \cdot , z - r ) | _ { [ x - r , x + r ] } \stackrel { \phi } { \longrightarrow } & \lim _ { \substack { \longmapsto & \longmapsto \\ \downarrow \\ \leftarrow \right ] } } M ( \cdot , z + r ) | _ { [ x - r , x + r ] } \\ \lim _ { \leftarrow } N ( \cdot , z - h ) | _ { [ x - h , x + h ] } \stackrel { \psi } { \longrightarrow } & \underset { \longrightarrow } { \lim } N ( \cdot , z + h ) | _ { [ x - h , x + h ] }
$$
```

## REPAIR_PROSE
- RAW: ```
![The image presents a table with 10 rows and 7 columns. Each cell in the table contains a mathematical expression. The expressions are written in a different font and color, and the cells are connected by arrows. The cells in the table are connected by arrows, indicating that the values in the cells are connected by arrows. The table is titled M1,M2,M3,M4,M5,M6,M7 and is labeled as M1,M2,M3,M4,M5,M6,M7.](<FH2024/imageFile7.png>)





···




,



,



,



,




-








···




,



,



,



,




-




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

.

.

.

.

.

.





···











n,m −

-


n,m
```
  FIX: ```
![The image presents a commutative diagram with 10 rows and 7 columns.](<FH2024/imageFile7.png>)
```

- RAW: ```
where h = r − ε . Using Lemma 4.4, we obtain the commutative diagram
```
  FIX: ```
where \( h = r - \varepsilon \). Using Lemma 4.4, we obtain the commutative diagram
```

- RAW: ```
It follows that k = rank M | R r ( x,z ) = rank ϕ ≤ rank ψ = rank N | R r − ε ( x,z ) . Hence, λ k ( N )( x,z ) ≥ r − ε and so λ k ( M )( x,z ) − λ k ( N )( x,z ) ≤ ε , completing the proof. □
```
  FIX: ```
It follows that \( k = \text{rank} M |_{R_r(x,z)} = \text{rank} \phi \leq \text{rank} \psi = \text{rank} N |_{R_{r-\varepsilon}(x,z)} \). Hence, \( \lambda_k(N)(x,z) \geq r - \varepsilon \) and so \( \lambda_k(M)(x,z) - \lambda_k(N)(x,z) \leq \varepsilon \), completing the proof. □
```

- RAW: ```
from ZZ × to op × ×
```
  FIX: ```
from \( \mathbb{Z} \times \mathbb{Z} \) to \( \mathbb{R}^{\text{op}} \times \mathbb{R} \)
```

- RAW: ```
distance parameter ε .
```
  FIX: ```
distance parameter \( \varepsilon \).
```

- RAW: ```
Regarding the definition of persistence landscapes (Def. 3.1), we are interested in the rank of M restricted to quadratic regions R ε x in the parameter space centered at a point x . According to Theorem 2.23, the generalized rank of an interval in the persistence module M can be computed as the rank of the module restricted to a zigzag path along certain boundary points of M .
```
  FIX: ```
Regarding the definition of persistence landscapes (Def. 3.1), we are interested in the rank of \( M \) restricted to quadratic regions \( R_\varepsilon^x \) in the parameter space centered at a point \( x \). According to Theorem 2.23, the generalized rank of an interval in the persistence module \( M \) can be computed as the rank of the module restricted to a zigzag path along certain boundary points of \( M \).
```

- RAW: ```
In the case of squares R ε x , the minimal and maximal points are points on the lower and upper edge of the square.
```
  FIX: ```
In the case of squares \( R_\varepsilon^x \), the minimal and maximal points are points on the lower and upper edge of the square.
```
