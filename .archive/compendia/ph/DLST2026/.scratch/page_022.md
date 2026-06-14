[Page 22]

**Definition 5.1** (Zigzag filtration of block decompositions). Let \( \mathcal{V}_0, \mathcal{V}_1, \dots, \mathcal{V}_T \) be a parameterized multivector field on \( X \). A sequence of pairs \( \mathfrak{B} = \{ (\mathcal{B}_\lambda, \mathcal{V}_\lambda) \}_{\lambda \in \Lambda} \), where \( \Lambda = [0, T]_{\mathbb{Z}} \), such that \( \mathcal{B}_\lambda \) is a block decomposition for \( \mathcal{V}_\lambda \) is called a zigzag filtration of block decompositions[^4] (or simply a zigzag filtration if it is clear from the context) if for all \( \lambda \in [0, T-1]_{\mathbb{Z}} \) either


$$
\mathcal{B}_\lambda \sqsubseteq \mathcal{B}_{\lambda+1} \quad \text{and} \quad \mathcal{V}_\lambda \sqsubseteq \mathcal{V}_{\lambda+1}
$$

$$
\mathcal{B}_{\lambda+1} \sqsubseteq \mathcal{B}_\lambda \quad \text{and} \quad \mathcal{V}_{\lambda+1} \sqsubseteq \mathcal{V}_\lambda,
$$

which we also denote as \( (\mathcal{B}_\lambda, \mathcal{V}_\lambda) \sqsubseteq (\mathcal{B}_{\lambda+1}, \mathcal{V}_{\lambda+1}) \) or \( (\mathcal{B}_\lambda, \mathcal{V}_\lambda) \sqsupseteq (\mathcal{B}_{\lambda+1}, \mathcal{V}_{\lambda+1}) \), respectively.

The sequence \( \mathfrak{B} \) is called a filtration if all relations are in the same direction. We denote the indexing set corresponding to \( \mathcal{B}_\lambda \) by \( P_\lambda \) and an element of \( \mathcal{B}_\lambda \) with index \( p \in P_\lambda \) by \( B_{p,\lambda} \). We usually write \( M_{p,\lambda} \coloneqq \operatorname{Inv}_{\mathcal{V}_\lambda}(B_{p,\lambda}) \). If non-empty, \( M_{p,\lambda} \) is a Morse set in the corresponding Morse decomposition \( \mathcal{M}_\lambda \). However, one should keep in mind that this set might be empty.

The canonical example of \( \mathcal{M} \) is a sequence of the finest Morse decompositions for the multivector fields in \( \mathcal{V} \). The simplest strategy to build a corresponding zigzag filtration \( \mathfrak{B} \) is to take the sequence of finest block partitions corresponding to \( \mathcal{V} \). We use this canonical choice in our examples as it is also natural from an algorithmic perspective, but all presented results work for non-canonical zigzag filtrations as well. Since a block decomposition carries all information about the underlying Morse decomposition (Proposition 4.10), we focus mainly on \( \mathfrak{B} \).

**Proposition 5.2.** Let \( \mathcal{B} \) and \( \mathcal{B}' \) be the finest block partitions for \( \mathcal{V} \) and \( \mathcal{V}' \), respectively. If \( \mathcal{V} \sqsubseteq \mathcal{V}' \) then \( \mathcal{B} \sqsubseteq \mathcal{B}' \).

*Proof.* Note that \( \mathcal{G}_{\mathcal{V}} \subset \mathcal{G}_{\mathcal{V}'} \), that is, whenever \( (x, y) \) is an edge in \( \mathcal{G}_{\mathcal{V}} \) then it is in \( \mathcal{G}_{\mathcal{V}'} \) as well. Therefore, the assertion follows directly from Theorem 4.12. ◻

**Example 5.3.** Figure 13 shows a sequence forming a parameterized multivector field \( \mathcal{V} \coloneqq \mathcal{V}_0 \sqsupseteq \mathcal{V}_1 \sqsubseteq \mathcal{V}_2 \sqsupseteq \mathcal{V}_3 \sqsupseteq \mathcal{V}_4 \). The central column in Figure 14 illustrates the corresponding finest block partitions \( \mathcal{B}_0 \), \( \mathcal{B}_1 \), \( \mathcal{B}_2 \), \( \mathcal{B}_3 \), and \( \mathcal{B}_4 \), which, by Proposition 5.2, form the following zigzag filtration of block decompositions:

$$
\mathfrak{B} \coloneqq (\mathcal{B}_0, \mathcal{V}_0) \sqsubseteq (\mathcal{B}_1, \mathcal{V}_1) \sqsubseteq (\mathcal{B}_2, \mathcal{V}_2) \sqsubseteq (\mathcal{B}_3, \mathcal{V}_3) \sqsubseteq (\mathcal{B}_4, \mathcal{V}_4).
$$

The central column in Figure 14 presents the isolating blocks highlighted in brown, and the corresponding Morse sets highlighted in green. The block decompositions consist of 2, 3, 2, 3, and 7 isolating blocks, respectively, the associated Morse decompositions, defined as \( \mathcal{M}_\lambda \coloneqq \mathcal{B}_\lambda^{\bullet, \mathcal{V}_\lambda} \) (see definition (4.2)) contain 1, 2, 2, 2 and 3 Morse sets, respectively. The corresponding flow induced partial orders are presented in Figure 15. ♢

**Example 5.4.** Another example of a parameterized multivector field was given in Section 2.1. In Figure 4 we have the sequence \( \mathcal{V}_0 \sqsupseteq \mathcal{V}_1 \sqsubseteq \mathcal{V}_2 \sqsupseteq \mathcal{V}_3 \sqsupseteq \mathcal{V}_4 \). The finest block partition of \( \mathcal{V}_0 \) consists of 7 blocks, each formed by a single multivector. The finest block partition of \( \mathcal{V}_1 \) consists of 8 isolating blocks, two formed by the 0-cells at the poles, 5 formed by gray regular multivectors, and the 8th one consists of the collection of 4 orange multivectors. The block partitions for the remaining steps should be also easy to find. In total we have a zigzag filtration of the following form:

[^4]: Since elements of the sequence are families of sets, this is not a zigzag filtration in the standard sense. Nevertheless, we keep the name because the philosophy is analogous. This can be seen as a higher-level form of filtration.
