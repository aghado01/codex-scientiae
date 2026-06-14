[Page 18]

**Notation 3.4.** For a totally ordered set \( T \), we set \( C_2 T \coloneqq \{ \{ i,j \} \subseteq T \mid i \neq j \} \) to be the set of two-element subsets of \( T \), and for any \( a \in C_2 T \), we set \( \underline{a} \coloneqq \min a \) and \( \bar{a} \coloneqq \max a \). Thus \( a = \{ \underline{a} , \bar{a} \} \).


Let \( U \) be a subset of \( P \).

- (1) Suppose \( | sc( U ) | = n \) (resp. \( | sk( U ) | = m \)). We give a total order on the set \( sc( U ) \) (resp. \( sk( U ) \)) by giving a poset isomorphism \( a : [ n ] \to sc( U ) \), \( i \mapsto a_i \) (resp. \( b : [ m ] \to sk( U ) \), \( i \mapsto b_i \)), and apply the notation above for \( T = sc( U ) \) and \( sk( U ) \).
- (2) Let \( \{ a,b \} \subseteq P \) with \( a \neq b \). Then we denote by \( \vee' \{ a,b \} \) (resp. \( \wedge' \{ a,b \} \)) the set of minimal upper (resp. maximal lower) bounds of \( a \) and \( b \) in \( P \). Since \( P \) is a finite poset, if \( \vee' \{ a,b \} \) (resp. \( \wedge' \{ a,b \} \)) consists of a single element, then it coincides with the join \( a \vee b = \vee\{ a,b \} \) (resp. the meet \( a \wedge b = \wedge\{ a,b \} \)). We call \( \vee' \{ a,b \} \) (resp. \( \wedge' \{ a,b \} \)) the pre-join (resp. pre-meet) of \( \{ a,b \} \). For example, if \( P \) is presented by the following Hasse diagram, then the pre-join of \( \{ a,b \} \) is given by \( \vee' \{ a,b \} = \{ c,d \} \):




![image 3](<AL2026/imageFile3.png>)





We adopt this notation to each \( a \in C_2 sc( U ) \) (resp. \( b \in C_2 sk( U ) \)). Thus \( \vee' a \) (resp. \( \wedge' b \)) is the pre-join of \( a \) (resp. the pre-meet of \( b \)), more explicitly

\[
\vee ^ { \prime } a \coloneqq s c ( \uparrow _ { P } \underline { a } \cap \uparrow _ { P } \bar { a } ) , \quad \wedge ^ { \prime } b \coloneqq s k ( \downarrow _ { P } \underline { b } \cap \downarrow _ { P } \bar { b } ) .
\]

We fix a linear order on \( \vee' a \) (resp. \( \wedge' b \))^2 . Note that if \( U \) is an up-set (resp. a down-set), then \( \vee' a \subseteq U \) (resp. \( \wedge' b \subseteq U \)) by the definition of up-sets (resp. down-sets).

(3) We further set \( sc_1 ( U ) \) (resp. \( sk_1 ( U ) \)) to be the disjoint union of the pre-joins (pre-meets) of the two-element subsets of \( sc( U ) \) (resp. \( sk( U ) \)):

\[
\begin{aligned}
s c _ { 1 } ( U ) & \coloneqq \bigsqcup _ { a \in C _ { 2 } s c ( U ) } \vee ^ { \prime } a \, = \{ a _ { c } \colon = ( a , c ) \, | \, a \in C _ { 2 } s c ( U ) , \, c \in \vee ^ { \prime } a \} , \\ s k _ { 1 } ( U ) & \coloneqq \bigsqcup _ { b \in C _ { 2 } s k ( U ) } \wedge ^ { \prime } b \, = \{ b _ { d } \colon = ( b , d ) \, | \, b \in C _ { 2 } s k ( U ) , \, d \in \wedge ^ { \prime } b \} .
\end{aligned}
\]

^2 For example, we fix a linear order on \( P \), and define a linear order on every subset \( S \) of \( P \) in such a way that the inclusion from \( S \) to \( P \) becomes an order-preserving map.
