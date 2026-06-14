[Page 19]

Note here that the family \( ( \vee^{\prime} a )_{a \in \mathcal{C}_2\mathrm{sc}(U)} \) (resp. \( ( \wedge^{\prime} b )_{b \in \mathcal{C}_2\mathrm{sk}(U)} \)) does not need to be disjoint. For example, consider the case where \( U \) is presented as follows:

![image 4](<AL2026/imageFile4.png>)






Then \( \mathcal{C}_2\mathrm{sc}(U) = \{ \{a,b\}, \{a,c\}, \{b,c\} \} \), and \( \vee^{\prime}\{a,b\} = \{d\} \), \( \vee^{\prime}\{a,c\} = \{d\} \), \( \vee^{\prime}\{b,c\} = \{d,e\} \). Hence \( \mathrm{sc}_1(U) = \{ \{a,b\}d, \{a,c\}d, \{b,c\}d, \{b,c\}e \} \).

By the definition above, we see that if \( \mathrm{sc}(W) = \mathrm{sc}(U) \) (resp. \( \mathrm{sk}(W) = \mathrm{sk}(U) \)) for a \( W \subseteq P \), then \( \mathrm{sc}_1(W) = \mathrm{sc}_1(U) \) (resp. \( \mathrm{sk}_1(W) = \mathrm{sk}_1(U) \)).

Furthermore, we equip \( \mathrm{sc}_1(U) \) with another total order \( \preceq_{\mathrm{lex}} \), defined by \( ac \preceq_{\mathrm{lex}} a^{\prime}c^{\prime} \) if and only if \( (a, a, c) \leq_{\mathrm{lex}} (a^{\prime}, a^{\prime}, c^{\prime}) \), where \( \leq_{\mathrm{lex}} \) denotes the lexicographic order from left to right. Similarly, we give a total order to \( \mathrm{sk}_1(W) \). These total orders will be used to express matrices having \( \mathrm{sc}_1(U) \) or \( \mathrm{sk}_1(W) \) as an index set later.

(4) For any non-empty subset \( X \) of \( P \), or a disjoint union \( X = \bigsqcup_{s \in S} X_s := \{s_x \mid s \in S, x \in X_s\} \) of non-empty subsets \( X_s \) of \( P \) with non-empty index set \( S \), we set \( P_X := \bigoplus_{t \in X} P_t \) and \( P^{\prime}_X := \bigoplus_{t \in X} P^{\prime}_t \), where \( P_t := P_x \), \( P^{\prime}_t := P^{\prime}_x \) if \( t = s_x \in X = \bigsqcup_{s \in S} X_s \) with \( s \in S \) and \( x \in X_s \). In addition, we set \( P_X \) and \( P^{\prime}_X \) to be the zero modules if \( X = \emptyset \).

The following lemmas are necessary in the sequel.

Lemma 3.5. Let \( U \) be either an up-set or a down-set of \( P \). Then \( U \) is convex in \( P \). Moreover, if \( U \) is connected, then \( U \) is an interval. \( \square \)

Lemma 3.6. Let \( I \) be a connected subposet of \( P \). Then both \( {\uparrow}I \) and \( {\downarrow}I \) are again connected. \( \square \)

Lemma 3.7. Let \( I \) be an interval of \( P \). Then there exist up-sets \( U, U^{\prime} \) and down-sets \( W, W^{\prime} \) of \( P \) such that \( I = U \setminus U^{\prime} = W \setminus W^{\prime} \), which are given by

\[
U \coloneqq {\uparrow}I , U^{\prime} \coloneqq {\uparrow}I \setminus I ; \ \text{and} \ W \coloneqq {\downarrow}I , W^{\prime} \coloneqq {\downarrow}I \setminus I .
\]

Proof We only need to show that \( {\Uparrow}I := {\uparrow}I \setminus I \) is an up-set of \( P \). Take any \( u \in {\Uparrow}I \) and \( x \in P \) with \( u \leq x \). Then there exists \( y \in I \) with \( y \leq u \) since \( u \in {\uparrow}I \). Hence \( I \ni y \leq u \leq x \), which shows that \( x \in {\uparrow}I \). If \( x \in I \), then the convexity of \( I \) shows that \( u \in I \), a contradiction. Thus \( x \notin I \), and hence \( x \in {\Uparrow}I \). The proof for \( {\Downarrow}I := {\downarrow}I \setminus I \) to be a down-set of \( P \) is similar. \( \square \)

Remark 3.8. We note here that \( {\uparrow}I \) (resp. \( {\downarrow}I \)) is connected, thus an interval by the previous lemmas. However, \( {\Uparrow}I \) (resp. \( {\Downarrow}I \)) may not be connected in general.

Let \( U \) be a connected up-set, and \( W \) a connected down-set of \( P \). Note that \( V_U \) is projective (resp. \( V_W \) is injective) if and only if \( |\mathrm{sc}(U)| = 1 \) (resp. \( |\mathrm{sk}(W)| = 1 \))
