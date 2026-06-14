[Page 34]

where M ( ε 11 ) , M ( ε ↑ I 1 ) , M ( π 11 ) and M ( π ↓ I 1 ) are given by

$$
$$
\begin{align*}
M(\varepsilon_{11}) &= \left[ \delta_{a,c(a')} M_{a',c(a')} \right]_{(a',a) \in sc(\uparrow I) \times sc(I)}, \\
M(\varepsilon_1^{\uparrow I}) &= \left[ \begin{matrix} M_{a_{12},a_1} & -M_{a_{12},a_2} \\ & M_{a_{23},a_2} & -M_{a_{23},a_3} \\ & & \ddots & \ddots \\ & & & M_{a_{k-1,k},a_{k-1}} & -M_{a_{k-1,k},a_k} \end{matrix} \right], \\
M(\pi_{11}) &= \left[ \delta_{b,d(b')} M_{d(b'),b'} \right]_{(b,b') \in sk(I) \times sk(\uparrow I)}, \text{ and } \\
M(\pi_1^{\downarrow I}) &= \left[ \begin{matrix} M_{b_1,b_{12}} \\ -M_{b_2,b_{12}} & M_{b_2,b_{23}} \\ & -M_{b_3,b_{23}} & \ddots \\ & & \ddots & M_{b_{t-1},b_{t-1,t}} \\ & & & -M_{b_t,b_{t-1,t}} \end{matrix} \right].
\end{align*}
$$
$$

Remark 3.36. We set M ( ε 1 ) = M ( ε 1 ) 1 ,M ( ε 1 ) 2 and M ( π 1 ) = M ( π 1 ) 1 M ( π 1 ) 2 , where M ( ε 1 ) 1 has dim M ( a 1 ) columns and M ( π 1 ) 1 has dim M ( b 1 ) rows. Then the matrix R ( M,I ) in the first term of ( 3.42 ) has the following form:

$$
$$
R(M,I) = \begin{bmatrix} M(\varepsilon_1)_1 & M(\varepsilon_1)_2 & 0 \\ M_{b_1,a_1} & 0 & M(\pi_1)_1 \\ 0 & 0 & M(\pi_1)_2 \end{bmatrix}.
$$
$$

We denote by E r the identity matrix of rank r . By elementary column transformations within the second block column and elementary row transformations within the first block row, we can transform M ( ε 1 ) 2 to the normal form E r 1 ⊕ 0 ; and by elementary column transformations within the third block column and elementary row transformations within the third block row, we can transform M ( π 1 ) 2 to the normal form E r 2 ⊕ 0 , where the obtained matrix R ( M,I ) 1 is equivalent to R ( M,I ) , and has the form:

$$
$$
R(M,I)_1 = \left[ \begin{array}{c|cccc} M'_1 & E_{r_1} & 0 & 0 & 0 \\ M_1 & 0 & 0 & 0 & 0 \\ \hline M_2 & 0 & 0 & M'_3 & 0 \\ 0 & 0 & 0 & E_{r_2} & 0 \\ 0 & 0 & 0 & 0 & 0 \end{array} \right] \sim \left[ \begin{array}{c|cccc} 0 & E_{r_1} & 0 & 0 & 0 \\ M_1 & 0 & 0 & 0 & 0 \\ \hline M_2 & 0 & 0 & 0 & M'_3 \\ 0 & 0 & 0 & 0 & M_3 \\ 0 & 0 & 0 & 0 & 0 \end{array} \right].
$$
$$
