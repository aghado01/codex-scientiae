[Page 9]

Birth:

![In this image, we can see a chart with some numbers and some text.](<CDSM2009/imageFile10.png>)

Figure 5: Adjustments made to matrices $Z_i$, $B_i$, $D_i$, and $C_i$ in case of birth after the removal of simplex $\sigma$.

Map $g$. The subtleties of our construction arise when we consider what happens when we remove a simplex $\sigma$ from complex $K_i$. If there is no cycle in matrix $Z_i$ that contains simplex $\sigma$, then there is a chain $C_i[j]$ that contains it. Otherwise, since $Z_i B_i = D_i C_i$ is a basis for the boundaries of $K_i$, and $\partial\sigma$ is a boundary, there would exist a chain $C_i u$ such that $D_i C_i u = \partial\sigma$. This would imply that $(C_i u - \sigma)$ is a cycle not in the span of $Z_i$, a contradiction. 

In the birth case, after the first two steps $Z_i B_i[j] = Z_i B_i[j] - D_i C_i[j] = 0$, and after the third step $Z_i B_i = D_{i+1} C_i$. Before we drop column $j$ from $B_i$ and $C_i$ we need to ensure that row $l$ of $B_i$ is empty (since we drop column $l$ from $Z_i$, which is linearly dependent on the columns that precede it). This is achieved in Step 4. Step 6 is straightforward: by adding columns to the right we only change the basis to ensure matrix $Z_{i+1}$ is reduced.

Cycle $Z_{i+1}[1]$ is in the kernel of map $g_i$ by construction: indeed we set it to be the boundary of a chain in $K_i$. The rest of the columns of $Z_{i+1}$ are affected only by a change of basis except for the column $Z_i[l]$; this becomes linearly dependent on the preceding columns, and we remove it from the matrix. Therefore $R^j_i = g(R^{j+1}_{i+1})$, and the invariant is preserved. The cokernel of the map $g$ is zero, therefore no interval terminates at this stage.

In the case where there is a cycle $z$ that contains simplex $\sigma$, we know that $z$ is not in the image of the map $g$, so the cokernel of map $g$ is non-trivial and an interval terminates at this stage. If $z = Z_i[j]$ is the first such cycle in matrix $Z_i$, then we can perform a change of basis (accomplished in Step 1) so that it is the only such cycle. As a result the rank of each group $R^{l+1}_{i+1}$ with $l > \text{idx}_i(j)$ is one lower than $R^l_i$ while the ranks of the preceding groups in the right filtration do not change, and the interval we output is correct. Once $Z_i[j]$ is the only basis cycle containing simplex $\sigma$, the row $j$ of matrix $B_i$ is zero. Indeed, if there were a column of $B_i$ with a non-zero element in row $j$, it would imply the existence of a boundary that contains $\sigma$. However, $\sigma$ has no cofaces in $K_i$ since $K_{i+1} = K_i - \sigma$ is a simplicial complex. Step 2 of the death case makes sure that the row of $\sigma$ in $C_i$ is 0. This step does not affect the boundaries since the boundary of every cycle is zero. Finally, Step 3 constructs the matrices $Z_{i+1}$, $B_{i+1}$, and $C_{i+1}$.

# 5. DISCUSSION

One can compute levelset zigzag persistence of a realvalued function using the algorithm of Section 4. Applying the transformation given in Table 1 to the resulting pairs, one can obtain extended persistence diagrams of the function. As with ordinary persistence one uses a function $f: K \to \mathbb{R}$ on a simplicial complex to represent the function of interest. Letting $n = |K|$ be the number of simplices in the complex, and $m = \max |f^{-1}(a)|$ be the size of the largest simplicial complex required to represent a levelset of the function, we observe that such computation requires $O(m^2)$ space to store matrices $Z$, $B$, and $C$, as opposed to $O(n^2)$ space required by the original algorithm described in [7]. Given that space is usually the main bottleneck in persistence computation, we find this result very encouraging. Similarly, the required time $O(nm^2)$ depends on the size of the levelsets rather than the entire space $O(n^3)$.

An inconvenience associated with our algorithm is that matrix $B$ representing boundaries requires both row and column representation. It is an interesting question whether it is possible to restructure the algorithm to get rid of this overhead.

Distributed computation. Given a zigzag

$$
$$
H ( K _ { 1 } ) \leftrightarrow \dots \leftrightarrow H ( K _ { i } ) \leftrightarrow \dots \leftrightarrow H ( K _ { n } ) ,
$$
$$

we can compute the right filtration $R_i = (R^0_i, \dots, R^i_i)$ at the vector space $H(K_i)$, and the symmetric notion of the left filtration $L_i = (L^0_i, \dots, L^{n-i+1}_i)$ at the same vector space by applying the algorithm of Section 4 to the right half of the zigzag processed from right to left. Denote by $Z_r$, $B_r$, $b_r$ the matrices and birth vector representing the right filtration, and by $Z_l$, $B_l$, $b_l$ those representing the left filtration. The full zigzag contains an interval $(b_r[j], b_l[k])$ if and only if the space

$$
$$
( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) / ( ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) \cup ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) )
$$
$$

is non-trivial [3].

To find the pairs in the full zigzag, we can reduce the matrix $[Z_r \mid Z_l]$ to get $Z_r \cdot [I \mid P]$, where submatrix $P$ gives representation of cycles $Z_l$ in terms of cycles $Z_r$. We continue by reducing $[B_r \mid P]$ to get $B_r \cdot [I \mid T]$. Naturally, all those cycles in $Z_l$ that are boundaries turn into zero columns in $T$ (so in practice there is no need to include them at all). However, those columns in $T$ that remain non-zero give us the answer we seek. Namely, we have a pair $(b_r[j], b_l[k])$ in the full zigzag if and only if $\operatorname{low}(T[k]) = j$. To see this,
