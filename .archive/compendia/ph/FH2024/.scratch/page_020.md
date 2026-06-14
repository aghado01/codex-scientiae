[Page 20]

where \( h = r - \varepsilon \). Using Lemma 4.4, we obtain the commutative diagram

$$
\lim _ { \leftarrow } M ( \cdot , z - r ) | _ { [ x - r , x + r ] } \stackrel { \phi } { \longrightarrow } & \lim _ { \substack { \longmapsto & \longmapsto \\ \downarrow \\ \leftarrow \right ] } } M ( \cdot , z + r ) | _ { [ x - r , x + r ] } \\ \lim _ { \leftarrow } N ( \cdot , z - h ) | _ { [ x - h , x + h ] } \stackrel { \psi } { \longrightarrow } & \underset { \longrightarrow } { \lim } N ( \cdot , z + h ) | _ { [ x - h , x + h ] }
$$

.

It follows that \( k = \text{rank} M |_{R_r(x,z)} = \text{rank} \phi \leq \text{rank} \psi = \text{rank} N |_{R_{r-\varepsilon}(x,z)} \). Hence, \( \lambda_k(N)(x,z) \geq r - \varepsilon \) and so \( \lambda_k(M)(x,z) - \lambda_k(N)(x,z) \leq \varepsilon \), completing the proof. □

Remark 4.10 In the case where one would like to consider rectangular regions as mentioned in Remark 3.2, an analogous stability theorem can be obtained by considering an adapted inclusion from \( \mathbb{Z} \times \mathbb{Z} \) to \( \mathbb{R}^{\text{op}} \times \mathbb{R} \) and therefore also an adapted interleaving distance.

# 5 Algorithm

In practice, we regard finite and discrete time series and restrict our calculations to finitely many values of the distance parameter \( \varepsilon \). Therefore, the obtained persistence module has the following form:

![The image presents a commutative diagram with 10 rows and 7 columns.](<FH2024/imageFile7.png>)

Regarding the definition of persistence landscapes (Def. 3.1), we are interested in the rank of \( M \) restricted to quadratic regions \( R_\varepsilon^x \) in the parameter space centered at a point \( x \). According to Theorem 2.23, the generalized rank of an interval in the persistence module \( M \) can be computed as the rank of the module restricted to a zigzag path along certain boundary points of \( M \). To be precise, this path starts with a path through the lower fence and ends with a path through the upper fence. It holds that the lower fence contains all minimal elements and the upper fence contains all maximal elements. In the case of squares \( R_\varepsilon^x \), the minimal and maximal points are points on the lower and upper edge of the square. For example, in the following diagram the minimal elements are colored in blue and the maximal elements are colored in green. The respective lower and upper fence is
