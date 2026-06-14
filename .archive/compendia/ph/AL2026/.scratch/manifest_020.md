# Manifest: Page 020

## REPAIR_MATH
- RAW: ```
U = \uparrow a _ { 1 } \cup ( \uparrow a _ { 2 } \cup \dots \cup \uparrow a _ { n } ) .
```
  FIX: ```
$$
U = \uparrow a _ { 1 } \cup ( \uparrow a _ { 2 } \cup \dots \cup \uparrow a _ { n } ) .
$$
```
- RAW: ```
\uparrow a _ { 1 } \cap ( \uparrow a _ { 2 } \cup \dots \cup \uparrow a _ { n } ) = \varnothing .
```
  FIX: ```
$$
\uparrow a _ { 1 } \cap ( \uparrow a _ { 2 } \cup \dots \cup \uparrow a _ { n } ) = \varnothing .
$$
```
- RAW: ```
( 2 ) \text { This is shown similarly.} \quad \Box
```
  FIX: ```
$$
( 2 ) \text { This is shown similarly.} \quad \Box
$$
```
- RAW: ```
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 ,
```
  FIX: ```
$$
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 ,
$$
```

## REPAIR_PROSE
- RAW: ```
because V U and V W are indecomposable modules and dim V U / rad V U = | sc( U ) | (resp. dimsoc V W = | sk( W ) | ). To show that the set sc 1 ( U ) (resp. sk 1 ( W ) ) is not empty if V U is not projective (resp. V W is not injective), we review a fundamental property of finite posets.
```
  FIX: ```
because \( V_U \) and \( V_W \) are indecomposable modules and \( \dim V_U / \operatorname{rad} V_U = | \operatorname{sc}( U ) | \) (resp. \( \dim\operatorname{soc} V_W = | \operatorname{sk}( W ) | \)). To show that the set \( \operatorname{sc}_1 ( U ) \) (resp. \( \operatorname{sk}_1 ( W ) \)) is not empty if \( V_U \) is not projective (resp. \( V_W \) is not injective), we review a fundamental property of finite posets.
```
- RAW: ```
Definition 3.9. Let S be a finite poset. A topology on S is defined by setting the set of up-sets to be the open sets of S , which is called the Alexandrov topology on S . It is easy to see that it has a basis {↑ S x | x ∈ S } .
```
  FIX: ```
Definition 3.9. Let \( S \) be a finite poset. A topology on \( S \) is defined by setting the set of up-sets to be the open sets of \( S \), which is called the Alexandrov topology on \( S \). It is easy to see that it has a basis \( \{ \uparrow_S x \mid x \in S \} \).
```
- RAW: ```
Lemma 3.10. Let S be a finite poset considered as a topological space by the Alexandrov topology on S . Then S is a connected space if and only if S is a connected poset. □
```
  FIX: ```
Lemma 3.10. Let \( S \) be a finite poset considered as a topological space by the Alexandrov topology on \( S \). Then \( S \) is a connected space if and only if \( S \) is a connected poset. \(\Box\)
```
- RAW: ```
Lemma 3.11. Let S be a finite poset considered as a topological space by the Alexandrov topology on S . Then S is a locally connected space. □
```
  FIX: ```
Lemma 3.11. Let \( S \) be a finite poset considered as a topological space by the Alexandrov topology on \( S \). Then \( S \) is a locally connected space. \(\Box\)
```
- RAW: ```
Proposition 3.12. Let U be a connected up-set, W a connected down-set of P .
```
  FIX: ```
Proposition 3.12. Let \( U \) be a connected up-set, \( W \) a connected down-set of \( P \).
```
- RAW: ```
(1) | sc( U ) | ≥ 2 if and only if sc 1 ( U ) ̸ = ∅ .
```
  FIX: ```
(1) \( | \operatorname{sc}( U ) | \geq 2 \) if and only if \( \operatorname{sc}_1( U ) \neq \emptyset \).
```
- RAW: ```
(2) | sk( W ) | ≥ 2 if and only if sk 1 ( W ) ̸ = ∅ .
```
  FIX: ```
(2) \( | \operatorname{sk}( W ) | \geq 2 \) if and only if \( \operatorname{sk}_1( W ) \neq \emptyset \).
```
- RAW: ```
Proof (1) Since the implication ( ⇐ ) is trivial, we show the implication ( ⇒ ). Set sc( U ) = { a 1 , . . . , a n } and assume that n ≥ 2 . By Remark 3.2 (1), we have
```
  FIX: ```
Proof (1) Since the implication \( (\Leftarrow) \) is trivial, we show the implication \( (\Rightarrow) \). Set \( \operatorname{sc}( U ) = \{ a_1, \dots, a_n \} \) and assume that \( n \geq 2 \). By Remark 3.2 (1), we have
```
- RAW: ```
Now suppose that sc 1 ( U ) = ∅ . Then for any { i, j } ∈ C 2 [ n ] , we have sc( ↑ a i ∩ ↑ a j ) = ∅ , and hence ↑ a i ∩ ↑ a j = ∅ . This shows that
```
  FIX: ```
Now suppose that \( \operatorname{sc}_1( U ) = \emptyset \). Then for any \( \{ i, j \} \in C_2[n] \), we have \( \operatorname{sc}( \uparrow a_i \cap \uparrow a_j ) = \emptyset \), and hence \( \uparrow a_i \cap \uparrow a_j = \emptyset \). This shows that
```
- RAW: ```
The equalities ( 3.13 ) and ( 3.14 ) show that the topological space U with Alexandrov topology is not connected (also by noticing Remark 3.2 (4)). Hence U is not a connected poset by Lemma 3.10 , a contradiction. As a consequence, sc 1 ( U ) ̸ = ∅ .
```
  FIX: ```
The equalities (3.13) and (3.14) show that the topological space \( U \) with Alexandrov topology is not connected (also by noticing Remark 3.2 (4)). Hence \( U \) is not a connected poset by Lemma 3.10, a contradiction. As a consequence, \( \operatorname{sc}_1( U ) \neq \emptyset \).
```
- RAW: ```
With the above preliminaries, we first give a projective presentation of V U ∈ mod A , where U is a connected up-set of P .
```
  FIX: ```
With the above preliminaries, we first give a projective presentation of \( V_U \in \operatorname{mod} A \), where \( U \) is a connected up-set of \( P \).
```
- RAW: ```
Proposition 3.13. Let U be a connected up-set of P . Then V U has the following (not necessarily minimal) projective presentation:
```
  FIX: ```
Proposition 3.13. Let \( U \) be a connected up-set of \( P \). Then \( V_U \) has the following (not necessarily minimal) projective presentation:
```
