[Page 20]

because \( V_U \) and \( V_W \) are indecomposable modules and \( \dim V_U / \operatorname{rad} V_U = | \operatorname{sc}( U ) | \) (resp. \( \dim\operatorname{soc} V_W = | \operatorname{sk}( W ) | \)). To show that the set \( \operatorname{sc}_1 ( U ) \) (resp. \( \operatorname{sk}_1 ( W ) \)) is not empty if \( V_U \) is not projective (resp. \( V_W \) is not injective), we review a fundamental property of finite posets.

Definition 3.9. Let \( S \) be a finite poset. A topology on \( S \) is defined by setting the set of up-sets to be the open sets of \( S \), which is called the Alexandrov topology on \( S \). It is easy to see that it has a basis \( \{ \uparrow_S x \mid x \in S \} \).

The following lemmas are easy to show and the proofs are left to the reader.

Lemma 3.10. Let \( S \) be a finite poset considered as a topological space by the Alexandrov topology on \( S \). Then \( S \) is a connected space if and only if \( S \) is a connected poset. \(\Box\)

Lemma 3.11. Let \( S \) be a finite poset considered as a topological space by the Alexandrov topology on \( S \). Then \( S \) is a locally connected space. \(\Box\)

Under the preparation above, we prove the following.

Proposition 3.12. Let \( U \) be a connected up-set, \( W \) a connected down-set of \( P \).

(1) \( | \operatorname{sc}( U ) | \geq 2 \) if and only if \( \operatorname{sc}_1( U ) \neq \emptyset \).


(2) \( | \operatorname{sk}( W ) | \geq 2 \) if and only if \( \operatorname{sk}_1( W ) \neq \emptyset \).


Proof (1) Since the implication \( (\Leftarrow) \) is trivial, we show the implication \( (\Rightarrow) \). Set \( \operatorname{sc}( U ) = \{ a_1, \dots, a_n \} \) and assume that \( n \geq 2 \). By Remark 3.2 (1), we have

$$
$$
U = \uparrow a _ { 1 } \cup ( \uparrow a _ { 2 } \cup \dots \cup \uparrow a _ { n } ) .
$$
$$

Now suppose that \( \operatorname{sc}_1( U ) = \emptyset \). Then for any \( \{ i, j \} \in C_2[n] \), we have \( \operatorname{sc}( \uparrow a_i \cap \uparrow a_j ) = \emptyset \), and hence \( \uparrow a_i \cap \uparrow a_j = \emptyset \). This shows that

$$
$$
\uparrow a _ { 1 } \cap ( \uparrow a _ { 2 } \cup \dots \cup \uparrow a _ { n } ) = \varnothing .
$$
$$

The equalities (3.13) and (3.14) show that the topological space \( U \) with Alexandrov topology is not connected (also by noticing Remark 3.2 (4)). Hence \( U \) is not a connected poset by Lemma 3.10, a contradiction. As a consequence, \( \operatorname{sc}_1( U ) \neq \emptyset \).


$$
$$
( 2 ) \text { This is shown similarly.} \quad \Box
$$
$$

With the above preliminaries, we first give a projective presentation of \( V_U \in \operatorname{mod} A \), where \( U \) is a connected up-set of \( P \).

Proposition 3.13. Let \( U \) be a connected up-set of \( P \). Then \( V_U \) has the following (not necessarily minimal) projective presentation:

$$
$$
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 ,
$$
$$
