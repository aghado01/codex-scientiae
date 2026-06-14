[Page 14]

![The image is a diagram consisting of a grid with various lines and points. The grid is filled with a light color, and the lines and points are arranged in a specific pattern. The lines are connected to each other, forming a series of interconnected points. Here is a detailed description of the image: ### Description of Objects: 1. **Grid**: The grid is filled with a light color. 2. **Lines and Points**: There are multiple lines and points in the grid. 3. **Lines and Points**: The lines and points are connected to each other. 4. **Grid**: The grid is filled with a light color. 5. **Lines and Points**: The lines and points are connected to each other. 6. **Grid**: The grid is filled with a light color. 7. **Lines and Points**: The lines and points are connected to each other. 8. **Grid**: The grid is filled with a light color](<FH2024/imageFile1.png>)





Figure 2: Inclusion of the zigzag poset into \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\).

### 4.1 Block extension functor for zigzag modules

To define an interleaving distance on extended zigzag modules we extend the approach in [3] and in [18] (version 4 on arXiv). In both approaches, the authors send a zigzag persistence module to a \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\)-indexed module which allows them to define an interleaving distance for zigzag modules. Here, by \(\mathrm{op}\) we mean the opposite category. The partial order on \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\) (or \(\mathbb{R}^{\mathrm{op}} \times \mathbb{R}\), respectively) is given by \((a,b) \leq (c,d)\) iff \(c \leq a \leq b \leq d\). This can be motivated by the partial order on intervals, where \([a,b] \subset [c,d]\) iff \(c \leq a \leq b \leq d\). We slightly change and extend this approach to send an extended zigzag module to an \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \times \mathbb{R}\)-indexed module in order to define the interleaving distance.

At first, we show how to extend a zigzag module to a \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\)-indexed module. By zigzag module we mean a functor from the poset \(\mathbb{ZZ}\) to \(\mathrm{vec}\). We include \(\mathbb{ZZ}\) into the poset \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\) as follows: we map a sink index \(i\) to \((i,i)\) and a source index \(j\) to \((j+1, j-1)\), shown in Figure 2. Note that we required the maps being strictly alternating so that every index is either a sink or a source index. Since this is an order-preserving map the inclusion \(\iota \colon \mathbb{ZZ} \to \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\) is a functor. To map a zigzag module to a \(\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\)-indexed module we consider the composition of three functors: first, we define \(E_1 \colon \mathrm{vec}^{\mathbb{ZZ}} \to \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}}\) as the left Kan extension (see Appendix A.2) along the inclusion functor \(\iota\). Second, we restrict the module to the set \(U \colon= \{ (i,j) \in \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z} \mid i \leq j \}\) by the restriction functor \((-) |_U \colon \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}} \to \mathrm{vec}^U\). Finally, we define \(E_2 \colon \mathrm{vec}^U \to \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}}\) as the right Kan extension along the canonical inclusion \(\kappa \colon U \hookrightarrow \mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}\). In total, we define the block extension functor

$$
E \colon= E_2 \circ (-) |_U \circ E_1 \colon \mathrm{vec}^{\mathbb{ZZ}} \to \mathrm{vec}^{\mathbb{Z}^{\mathrm{op}} \times \mathbb{Z}}.
$$

It is known that any zigzag module decomposes into a direct sum of interval modules [5]. Following [3], we distinguish four different types of interval modules. Here, we denote by \(<\) and \(\leq\) the partial order in \(\mathbb{Z}^2\).

$$
\begin{aligned}
( a , b ) _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) < \iota ( i ) < ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ - \infty , \infty \} , \\
[ a , b ) _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) \leq \iota ( i ) < ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ \infty \} , \\
( a , b ] _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) < \iota ( i ) \leq ( b , b ) \} \quad \text {for } a < b \in \mathbb { Z } \cup \{ - \infty \} , \\
[ a , b ] _ { \mathbb{ZZ} } &\colon= \{ i \in \mathbb { Z } \mid ( a , a ) \leq \iota ( i ) \leq ( b , b ) \} \quad \text {for } a \leq b \in \mathbb { Z } .
\end{aligned}
$$
