[Page 16]

![The image is a graph titled M10 which is a linear scale with a linear scale of range 0 to 100 on the x-axis and a linear scale of range 0 to 100 on the y-axis. The graph is a line graph with a linear scale of range 0 to 100 on the x-axis and a linear scale of range 0 to 100 on the y-axis. The line is drawn from the bottom left to the top right of the graph. The graph has two axes, labeled as M10 and M10. The x-axis is labeled a and the y-axis is labeled M10. The graph is drawn with a blue line that is a linear scale of range 0 to 100 on the x-axis and a linear scale of range 0 to 100 on the y-axis.](<FH2024/imageFile3.png>)



Figure 4: (a) A visualization of the block extension functor and Lemma 4.4. The unique map is given by the universal property of colimits. Cf. Figure 2 in [3]. (b) The set U L .

Proof: This is a consequence of Lemma E.8 in [18] (only in version four), which itself is a slight extension of Lemma 4.1 in [3]. However, the reader can easily verify this by using the explicit formula in Lemma 4.4. □

In Figure 3, one can see examples of zigzag interval modules and the corresponding blocks after applying the block extension functor \(E\). The differences for the four different types are shown.

Under suitable finiteness assumptions the block extension functor preserves direct sums.

Lemma 4.3 Let \(M : \text{ZZ} \to \textbf{vec}\) such that for all \(\langle a,b \rangle \in \text{ZZ}\), \(\lim_{\leftarrow} M |_{\langle a,b \rangle \text{ZZ}}\) and \(\lim_{\rightarrow} M |_{\langle a,b \rangle \text{ZZ}}\) are finite dimensional. Then, if \(M \cong \bigoplus_{k \in K} I_{\langle a_k,b_k \rangle \text{ZZ}}\) then \(E(M) \cong \bigoplus_{k \in K} I_{\langle a_k,b_k \rangle \text{BL}}\).

Proof: This is a consequence of Lemma E.9 in [18] (only in version four). □

The next lemma shows how to actually calculate the components of \(E(M)\) and is crucial for the proof of the stability of persistence landscapes. In Figure 4, one can see how the components of \(E(M)\) for a zigzag module \(M\) are calculated.

Lemma 4.4 For \(( a,b ) \in \mathbb{Z}^{\text{op}} \times \mathbb{Z}\), it holds that

$$
E ( M ) ( a , b ) = \begin{cases} \lim _ { \overleftarrow { \ll } } M | _ { [ a , b ] } & \text {for } a \leq b , \\ \lim _ { \overleftarrow { \ll } } M | _ { [ b , a ] } & \text {for } a > b . \end{cases}
$$

Furthermore, the structure maps of \(E(M)\) are the maps given by the universal properties of limits and colimits, respectively.

Proof: We first proof the part \(E(M)(a,b) = \lim_{\rightarrow} M|_{[a,b]}\) for \(a \leq b\). By definition of left Kan extensions,

$$
E ( M ) ( a , b ) = \varprojlim _ { 1 6 } M | \{ i \in \mathbb { Z } \, | \, \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \text {op} } \times \mathbb { Z } \} . \\
$$
