# Manifest: Page 019

## REPAIR_MATH
- RAW: ```
Note here that the family ( ∨ ′ a ) a ∈ C 2 sc( U ) (resp. ( ∧ ′ b ) b ∈ C 2 sk( U ) ) does not need to be disjoint. For example, consider the case where U is presented as follows:
```
  FIX: ```
Note here that the family \( ( \vee^{\prime} a )_{a \in \mathcal{C}_2\mathrm{sc}(U)} \) (resp. \( ( \wedge^{\prime} b )_{b \in \mathcal{C}_2\mathrm{sk}(U)} \)) does not need to be disjoint. For example, consider the case where \( U \) is presented as follows:
```

## REPAIR_MATH
- RAW: ```
Then C 2 sc( U ) = {{ a,b } , { a,c } , { b,c }} , and ∨ ′ { a,b } = { d } , ∨ ′ { a,c } = { d } , ∨ ′ { b,c } = { d,e } . Hence sc 1 ( U ) = {{ a,b } d , { a,c } d , { b,c } d , { b,c } e } .
```
  FIX: ```
Then \( \mathcal{C}_2\mathrm{sc}(U) = \{ \{a,b\}, \{a,c\}, \{b,c\} \} \), and \( \vee^{\prime}\{a,b\} = \{d\} \), \( \vee^{\prime}\{a,c\} = \{d\} \), \( \vee^{\prime}\{b,c\} = \{d,e\} \). Hence \( \mathrm{sc}_1(U) = \{ \{a,b\}d, \{a,c\}d, \{b,c\}d, \{b,c\}e \} \).
```

## REPAIR_MATH
- RAW: ```
By the definition above, we see that if sc( W ) = sc( U ) (resp. sk( W ) = sk( U ) ) for a W ⊆ P , then sc 1 ( W ) = sc 1 ( U ) (resp. sk 1 ( W ) = sk 1 ( U ) ).
```
  FIX: ```
By the definition above, we see that if \( \mathrm{sc}(W) = \mathrm{sc}(U) \) (resp. \( \mathrm{sk}(W) = \mathrm{sk}(U) \)) for a \( W \subseteq P \), then \( \mathrm{sc}_1(W) = \mathrm{sc}_1(U) \) (resp. \( \mathrm{sk}_1(W) = \mathrm{sk}_1(U) \)).
```

## REPAIR_MATH
- RAW: ```
Furthermore, we equip sc 1 ( U ) with another total order ⪯ lex , defined by a c ⪯ lex a ′ c ′ if and only if ( a , a ,c ) ≤ lex ( a ′ , a ′ ,c ′ ) , where ≤ lex denotes the lexicographic order from left to right. Similarly, we give a total order to sk 1 ( W ) . These total orders will be used to express matrices having sc 1 ( U ) or sk 1 ( W ) as an index set later.
```
  FIX: ```
Furthermore, we equip \( \mathrm{sc}_1(U) \) with another total order \( \preceq_{\mathrm{lex}} \), defined by \( ac \preceq_{\mathrm{lex}} a^{\prime}c^{\prime} \) if and only if \( (a, a, c) \leq_{\mathrm{lex}} (a^{\prime}, a^{\prime}, c^{\prime}) \), where \( \leq_{\mathrm{lex}} \) denotes the lexicographic order from left to right. Similarly, we give a total order to \( \mathrm{sk}_1(W) \). These total orders will be used to express matrices having \( \mathrm{sc}_1(U) \) or \( \mathrm{sk}_1(W) \) as an index set later.
```

## REPAIR_MATH
- RAW: ```
(4) For any non-empty subset X of P , or a disjoint union X =   s ∈ S X s : = { s x | s ∈ S, x ∈ X s } of non-empty subsets X s of P with non-empty index set S , we set P X : =   t ∈ X P t and P ′ X : =   t ∈ X P ′ t , where P t : = P x , P ′ t : = P ′ x if t = s x ∈ X =   s ∈ S X s with s ∈ S and x ∈ X s . In addition, we set P X and P ′ X to be the zero modules if X = ∅ .
```
  FIX: ```
(4) For any non-empty subset \( X \) of \( P \), or a disjoint union \( X = \bigsqcup_{s \in S} X_s := \{s_x \mid s \in S, x \in X_s\} \) of non-empty subsets \( X_s \) of \( P \) with non-empty index set \( S \), we set \( P_X := \bigoplus_{t \in X} P_t \) and \( P^{\prime}_X := \bigoplus_{t \in X} P^{\prime}_t \), where \( P_t := P_x \), \( P^{\prime}_t := P^{\prime}_x \) if \( t = s_x \in X = \bigsqcup_{s \in S} X_s \) with \( s \in S \) and \( x \in X_s \). In addition, we set \( P_X \) and \( P^{\prime}_X \) to be the zero modules if \( X = \emptyset \).
```

## REPAIR_MATH
- RAW: ```
Lemma 3.5. Let U be either an up-set or a down-set of P . Then U is convex in P . Moreover, if U is connected, then U is an interval. □
```
  FIX: ```
Lemma 3.5. Let \( U \) be either an up-set or a down-set of \( P \). Then \( U \) is convex in \( P \). Moreover, if \( U \) is connected, then \( U \) is an interval. \( \square \)
```

## REPAIR_MATH
- RAW: ```
Lemma 3.6. Let I be a connected subposet of P . Then both ↑ I and ↓ I are again connected. □
```
  FIX: ```
Lemma 3.6. Let \( I \) be a connected subposet of \( P \). Then both \( {\uparrow}I \) and \( {\downarrow}I \) are again connected. \( \square \)
```

## REPAIR_MATH
- RAW: ```
Lemma 3.7. Let I be an interval of P . Then there exist up-sets U, U ′ and down-sets W, W ′ of P such that I = U \ U ′ = W \ W ′ , which are given by
```
  FIX: ```
Lemma 3.7. Let \( I \) be an interval of \( P \). Then there exist up-sets \( U, U^{\prime} \) and down-sets \( W, W^{\prime} \) of \( P \) such that \( I = U \setminus U^{\prime} = W \setminus W^{\prime} \), which are given by
```

## REPAIR_MATH
- RAW: ```
$$
U \coloneqq \uparrow I , U ^ { \prime } \coloneqq \uparrow I \coloneqq \uparrow I \ \smallsetminus I \ \smallsetminus I ; \ a n d \ W \coloneqq \downarrow I , W ^ { \prime } \coloneqq \downarrow I \ \colon = \downarrow I \ \smallsetminus I .
$$
```
  FIX: ```
\[
U \coloneqq {\uparrow}I , U^{\prime} \coloneqq {\uparrow}I \setminus I ; \ \text{and} \ W \coloneqq {\downarrow}I , W^{\prime} \coloneqq {\downarrow}I \setminus I .
\]
```

## REPAIR_MATH
- RAW: ```
Proof We only need to show that ⇑ I : = ↑ I \ I is an up-set of P . Take any u ∈ ⇑ I and x ∈ P with u ≤ x . Then there exists y ∈ I with y ≤ u since u ∈ ↑ I . Hence I ∋ y ≤ u ≤ x , which shows that x ∈ ↑ I . If x ∈ I , then the convexity of I shows that u ∈ I , a contradiction. Thus x / ∈ I , and hence x ∈ ⇑ I . The proof for ⇓ I : = ↓ I \ I to be a down-set of P is similar. □
```
  FIX: ```
Proof We only need to show that \( {\Uparrow}I := {\uparrow}I \setminus I \) is an up-set of \( P \). Take any \( u \in {\Uparrow}I \) and \( x \in P \) with \( u \leq x \). Then there exists \( y \in I \) with \( y \leq u \) since \( u \in {\uparrow}I \). Hence \( I \ni y \leq u \leq x \), which shows that \( x \in {\uparrow}I \). If \( x \in I \), then the convexity of \( I \) shows that \( u \in I \), a contradiction. Thus \( x \notin I \), and hence \( x \in {\Uparrow}I \). The proof for \( {\Downarrow}I := {\downarrow}I \setminus I \) to be a down-set of \( P \) is similar. \( \square \)
```

## REPAIR_MATH
- RAW: ```
Remark 3.8. We note here that ↑ I (resp. ↓ I ) is connected, thus an interval by the previous lemmas. However, ⇑ I (resp. ⇓ I ) may not be connected in general.
```
  FIX: ```
Remark 3.8. We note here that \( {\uparrow}I \) (resp. \( {\downarrow}I \)) is connected, thus an interval by the previous lemmas. However, \( {\Uparrow}I \) (resp. \( {\Downarrow}I \)) may not be connected in general.
```

## REPAIR_MATH
- RAW: ```
Let U be a connected up-set, and W a connected down-set of P . Note that V U is projective (resp. V W is injective) if and only if | sc( U ) | = 1 (resp. | sk( W ) | = 1 )
```
  FIX: ```
Let \( U \) be a connected up-set, and \( W \) a connected down-set of \( P \). Note that \( V_U \) is projective (resp. \( V_W \) is injective) if and only if \( |\mathrm{sc}(U)| = 1 \) (resp. \( |\mathrm{sk}(W)| = 1 \))
```
