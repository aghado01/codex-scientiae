[Page 23]



![In this image, we can see a diagram with different shapes and lines. We can see some points and lines.](<DLST2026/imageFile11.png>)




Figure 13. From top left to bottom right, multivector fields \( \mathcal{V}_0 \), \( \mathcal{V}_1 \), \( \mathcal{V}_2 \), \( \mathcal{V}_3 \), and \( \mathcal{V}_4 \) on a simplicial complex \( K \). In particular, \( \mathcal{V}_0 \sqsupseteq \mathcal{V}_1 \sqsubseteq \mathcal{V}_2 \sqsupseteq \mathcal{V}_3 \sqsupseteq \mathcal{V}_4 \).

\[
( \mathcal { B } _ { 0 } , \mathcal { V } _ { 0 } ) \supseteq ( \mathcal { B } _ { 1 } , \mathcal { V } _ { 1 } ) \subseteq ( \mathcal { B } _ { 2 } , \mathcal { V } _ { 2 } ) \supseteq ( \mathcal { B } _ { 3 } , \mathcal { V } _ { 3 } ) \supseteq ( \mathcal { B } _ { 4 } , \mathcal { V } _ { 4 } ) .
\]

Whenever we have inscribed block decompositions \( (\mathcal{B}, \mathcal{V}) \sqsubseteq (\mathcal{B}', \mathcal{V}') \) with corresponding index sets \( \mathbb{P} \) and \( \mathbb{P}' \), we can define the indexing map \( \iota \colon \mathbb{P} \to \mathbb{P}' \) such that \( \iota(p) := r \) if \( \mathcal{B} \ni B_p \subset B_r \in \mathcal{B}' \). We leave it as an easy exercise to the reader to verify that \( \iota \) is an order preserving map between the flow induced partial orders.

In the case of zigzag filtration \( \mathcal{B} \), we distinguish two types of indexing maps: for \( \mathcal{B}_\lambda \sqsubseteq \mathcal{B}_{\lambda+1} \) we have the \( \lambda \)-forward map denoted and defined as:

\[
\overrightarrow { \iota } _ { \lambda } \colon \mathbb { P } _ { \lambda } \ni p \mapsto r \in \mathbb { P } _ { \lambda + 1 }
\]

such that \( \mathcal{B}_\lambda \ni B_{p,\lambda} \subset B_{r,\lambda+1} \in \mathcal{B}_{\lambda+1} \). Analogously, for \( \mathcal{B}_\lambda \sqsupseteq \mathcal{B}_{\lambda+1} \) we have the \( \lambda \)-backward map:

\[
\overleftarrow { \iota } _ { \lambda } \colon \mathbb { P } _ { \lambda + 1 } \ni r \mapsto p \in \mathbb { P } _ { \lambda }
\]

such that \( \mathcal{B}_{\lambda+1} \ni B_{r,\lambda+1} \subset B_{p,\lambda} \in \mathcal{B}_{\lambda+1} \). Whenever we refer to \( \mathcal{B} \) we assume that the corresponding indexing sets \( \mathbb{P}_\lambda \), and \( \lambda \)-forward/backward maps, \( \overrightarrow{\iota}_\lambda \) and \( \overleftarrow{\iota}_\lambda \), are implied.

Example 5.5. For the zigzag filtration \( \mathcal{B} \) from Example 5.3 we have four indexing maps: \( \overleftarrow{\iota}_0 \), \( \overrightarrow{\iota}_1 \), \( \overleftarrow{\iota}_2 \), and \( \overleftarrow{\iota}_3 \), as shown in Figure 16. \( \diamondsuit \)
