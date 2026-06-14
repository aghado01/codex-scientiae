[Page 60]

Intuitively, for each \( j \in [s] \), if \( x_i \leq z_j \) in \( P \), then the \( j \)-th columns of \( P'(g_t)(x_i) \) and of \( g_t \) coincide, otherwise the \( j \)-th column of \( P'(g_t)(x_i) \) is zero.

On the other hand, \( P'_{(w_i)_{i \in [r]}}(\alpha) = \bigoplus_{i=1}^r P'_{w_i}(\alpha) \) is a diagonal block matrix, where for each \( i \in [r] \), the \( i \)-th block \( P'_{w_i}(\alpha) \) has the following coefficient matrix:

$$
\begin{bmatrix}
\delta_{(y_1 \le w_i)} a^{(1)} \\
\vdots \\
\delta_{(y_n \le w_i)} a^{(n)}
\end{bmatrix} .
$$

*Proof.* Set \( \text{Mat}(g_t) := [b_{ij}]_{(i,j) \in [r] \times [s]} \) and \( \text{Mat}(\alpha) := [a_{ji}]_{(j,i) \in [n] \times [m]} \), and let \( u \in P \). Then since \( P'(p_{w_i, z_j})(u) = A(u, p_{w_i, z_j}) \), we have

$$
P'(g_t)(u) = [b_{ij} A(u, p_{w_i, z_j})]_{(i,j) \in [r] \times [s]},
$$

where for any pair \( (w_i, z_j) \) with \( z_j \leq w_i \), the morphism \( A(u, p_{w_i, z_j}): A(u, z_j) \to A(u, w_i) \) is nonzero if and only if \( A(u, z_j) \neq 0 \), if and only if \( u \leq z_j \). Hence we have \( \text{Mat}(P'(g_t)(u)) = [b'_{ij}]_{(i,j) \in [r] \times [s]} \), where


$$
b'_{ij} = \delta_{(A(u, p_{w_i, z_j}) \neq 0)} b_{ij} = \delta_{(u \le z_j)} b_{ij}.
$$


Therefore, (5.76) follows by setting \( u := x_i \).

Similarly, since \( P'_u(p_{y_j, x_i}) = A(p_{y_j, x_i}, u) \), we have

$$
P'_u(\alpha) = {}^t[a_{ji} A(p_{y_j, x_i}, u)]_{(j,i) \in [n] \times [m]},
$$

where for any pair \( (x_i, y_j) \) with \( x_i \leq y_j \), the morphism \( A(p_{y_j, x_i}, u): A(y_j, u) \to A(x_i, u) \) is nonzero if and only if \( A(y_j, u) \neq 0 \), if and only if \( y_j \leq u \). Hence we have \( \text{Mat}(P'_u(\alpha)) = {}^t[a''_{ji}]_{(j,i) \in [n] \times [m]} \), where


$$
a''_{ji} = \delta_{(A(p_{y_j, x_i}, u) \neq 0)} a_{ji} = \delta_{(y_j \le u)} a_{ji}.
$$


By setting \( u = w_i \), this shows (5.77).


Example 5.12. We take a bifiltration example from Fugacci et al. (2023), as displayed in Fig. 3, to demonstrate our formulas. Set \( M := H_1(-; \mathbb{Z}/2\mathbb{Z}) \circ F \). Following the notation given in Theorem 5.1, the presentation matrix \( P(\alpha) \) is given by

$$
\begin{matrix}
& \begin{matrix} (1, 2) & (2, 1) \end{matrix} \\
\begin{matrix} (0, 0) \\ (1, 1) \end{matrix} & \begin{bmatrix} 1 & 0 \\ 1 & 1 \end{bmatrix}
\end{matrix},
$$

and thus \( x \) in (5.74) is given by a sequence of row indices of \( P(\alpha) \). Namely, \( x = ((0, 0), (1, 1)) \).

Now we consider an interval: \( I = [\{(0, 2), (1, 1)\}, \{(1, 2), (2, 1)\}] \). Thus more visually, \( \dim V_I = \begin{smallmatrix} 1 & 1 & 0 \\ 0 & 1 & 1 \\ 0 & 0 & 0 \end{smallmatrix} \). Three block matrices \( g_1, g_2, g_3 \) of the multiplicity matrix for \( I \) are given by

$$
\begin{matrix}
& (0, 2) & (1, 1) \\
(1, 2) & 1 & -1 \\
(2, 2) & 1 & 0 
\end{matrix}, \quad
\begin{matrix}
& (0, 1) & (2, 0) & (1, 1) \\
(2, 1) & 0 & 0 & 1 \\
& 1 & 1 & -1
\end{matrix}, \quad
\begin{matrix}
& (0, 2) & (1, 1) \\
(1, 2) & 0 & 1 & 0 \\
& 1 & 0 & 1 \\
& 0 & -1 & \dots
\end{matrix}, \quad
\begin{matrix}
(2, 1) & 1 & 0 \\
& 1 & 0 \\
& 0 & 0 
\end{matrix}
\tag{5.79}
$$
