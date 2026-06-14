# Manifest: Page 004

## REPAIR_PROSE
- RAW: `and call them the up-set (resp. down-set ) of I , and the proper up-set (resp. proper down-set ) of I , respectively.`
  FIX: `and call them the up-set (resp. down-set) of \( I \), and the proper up-set (resp. proper down-set) of \( I \), respectively.`
- RAW: `(2) For any totally ordered set T = ( T, ⪯ ) , we denote by C 2 T the set of all subsets of T consisting of exactly two elements.`
  FIX: `(2) For any totally ordered set \( T = ( T, \preceq ) \), we denote by \( C_2 T \) the set of all subsets of \( T \) consisting of exactly two elements.`
- RAW: `For any a = { i,j } ∈ C 2 T with i ≺ j in T , we set a : = i (resp. a : = j ).`
  FIX: `For any \( a = \{ i, j \} \in C_2 T \) with \( i \prec j \) in \( T \), we set \( \underline{a} := i \) (resp. \( \overline{a} := j \)).`
- RAW: `Then we can write a = { a , a } .`
  FIX: `Then we can write \( a = \{ \underline{a}, \overline{a} \} \).`
- RAW: `Now, after giving total orders on sc( I ) and sk( I ) , for any a ∈ C 2 sc( I ) (resp. b ∈ C 2 sk( I ) ), we set ∨ ′ a : = sc( ↑ a ∩ ↑ a ) (resp. ∧ ′ b : = sk( ↓ b ∩ ↓ b ), and call it the pre-join (resp. pre-meet ) of a (resp. b ).`
  FIX: `Now, after giving total orders on \( \mathrm{sc}( I ) \) and \( \mathrm{sk}( I ) \), for any \( a \in C_2 \mathrm{sc}( I ) \) (resp. \( b \in C_2 \mathrm{sk}( I ) \)), we set \( \vee' a := \mathrm{sc}( \uparrow \underline{a} \cap \uparrow \overline{a} ) \) (resp. \( \wedge' b := \mathrm{sk}( \downarrow \underline{b} \cap \downarrow \overline{b} ) \)), and call it the pre-join (resp. pre-meet) of \( a \) (resp. \( b \)).`
- RAW: `We then set sc 1 ( I ) to be the disjoint union of all pre-joins of the two-element subsets of sc( I ) . Namely,`
  FIX: `We then set \( \mathrm{sc}_1( I ) \) to be the disjoint union of all pre-joins of the two-element subsets of \( \mathrm{sc}( I ) \). Namely,`
- RAW: `For example in Fig. 1 , for a : = { a 2 ,a 3 } ∈ C 2 sc( I ) (with the additional total order ⪯ ) we have a = a 2 and a = a 3 .`
  FIX: `For example in Fig. 1, for \( a := \{ a_2, a_3 \} \in C_2 \mathrm{sc}( I ) \) (with the additional total order \( \preceq \)) we have \( \underline{a} = a_2 \) and \( \overline{a} = a_3 \).`
- RAW: `Moreover, the element { a 2 ,a 3 } x is minimal in ↑ a ∩ ↑ a .`
  FIX: `Moreover, the element \( \{ a_2, a_3 \}_x \) is minimal in \( \uparrow \underline{a} \cap \uparrow \overline{a} \).`
- RAW: `(3) If sc( ⇑ I ) ̸ = ∅ , then for each a ′ ∈ sc( ⇑ I ) , we have sc( I ) ∩ ↓ a ′ ̸ = ∅ because a ′ ∈ ↑ I .`
  FIX: `(3) If \( \mathrm{sc}( \Uparrow I ) \neq \emptyset \), then for each \( a' \in \mathrm{sc}( \Uparrow I ) \), we have \( \mathrm{sc}( I ) \cap \downarrow a' \neq \emptyset \) because \( a' \in \uparrow I \).`
- RAW: `Fixing one element in sc( I ) ∩ ↓ a ′ for each a ′ ∈ sc( ⇑ I ) yields a map c : sc( ⇑ I ) → sc( I ) .`
  FIX: `Fixing one element in \( \mathrm{sc}( I ) \cap \downarrow a' \) for each \( a' \in \mathrm{sc}( \Uparrow I ) \) yields a map \( c \colon \mathrm{sc}( \Uparrow I ) \to \mathrm{sc}( I ) \).`
- RAW: `We call such c a choice map .`
  FIX: `We call such \( c \) a choice map.`
- RAW: `Dually, if sk( ⇓ I ) ̸ = ∅ , then for each b ′ ∈ sk( ⇓ I ) , we have sk( I ) ∩ ↑ b ′ ̸ = ∅ because b ′ ∈ ↓ I .`
  FIX: `Dually, if \( \mathrm{sk}( \Downarrow I ) \neq \emptyset \), then for each \( b' \in \mathrm{sk}( \Downarrow I ) \), we have \( \mathrm{sk}( I ) \cap \uparrow b' \neq \emptyset \) because \( b' \in \downarrow I \).`
- RAW: `Fixing one element b ∈ sk( I ) ∩ ↑ b ′ for each b ′ ∈ sk( ⇓ I ) yields another choice map d : sk( ⇓ I ) → sk( I ) that sends b ′ to b .`
  FIX: `Fixing one element \( b \in \mathrm{sk}( I ) \cap \uparrow b' \) for each \( b' \in \mathrm{sk}( \Downarrow I ) \) yields another choice map \( d \colon \mathrm{sk}( \Downarrow I ) \to \mathrm{sk}( I ) \) that sends \( b' \) to \( b \).`
- RAW: `See Fig. 1 for an illustration of such an a ′ ∈ sc( ⇑ I ) and a choice of a 1 ∈ sc( I ) such that a 1 ≤ a ′ .`
  FIX: `See Fig. 1 for an illustration of such an \( a' \in \mathrm{sc}( \Uparrow I ) \) and a choice of \( a_1 \in \mathrm{sc}( I ) \) such that \( a_1 \leq a' \).`
- RAW: `As a remark in Fig. 1 , there are two elements x and y in ∨ ′ { a 2 ,a 3 } , labeled as { a 2 ,a 3 } x and { a 2 ,a 3 } y in sc 1 ( I ) , respectively.`
  FIX: `As a remark in Fig. 1, there are two elements \( x \) and \( y \) in \( \vee' \{ a_2, a_3 \} \), labeled as \( \{ a_2, a_3 \}_x \) and \( \{ a_2, a_3 \}_y \) in \( \mathrm{sc}_1( I ) \), respectively.`
- RAW: `We address that sc 1 ( I ) may contain some elements which are not in I .`
  FIX: `We address that \( \mathrm{sc}_1( I ) \) may contain some elements which are not in \( I \).`
- RAW: `For example, y is not an element of I in this illustration.`
  FIX: `For example, \( y \) is not an element of \( I \) in this illustration.`
- RAW: `We also note that the element w / ∈ ∨ ′ { a 2 ,a 3 } since w is not minimal in ↑ a 2 ∩↑ a 3 , but w is in both ∨ ′ { a 1 ,a 2 } and ∨ ′ { a 1 ,a 3 } .`
  FIX: `We also note that the element \( w \notin \vee' \{ a_2, a_3 \} \) since \( w \) is not minimal in \( \uparrow a_2 \cap \uparrow a_3 \), but \( w \) is in both \( \vee' \{ a_1, a_2 \} \) and \( \vee' \{ a_1, a_3 \} \).`
- RAW: `By this we write { a 1 ,a 2 } w and { a 1 ,a 3 } w in sc 1 ( I ) , standing for w ∈ I .`
  FIX: `By this we write \( \{ a_1, a_2 \}_w \) and \( \{ a_1, a_3 \}_w \) in \( \mathrm{sc}_1( I ) \), standing for \( w \in I \).`

## REPAIR_MATH
- RAW: ```
\uparrow I \colon = \bigcup _ { x \in I } \uparrow x \ \ ( \text {resp. } \downarrow I \colon = \bigcup _ { x \in I } \downarrow x ) , \ \text {and } \uparrow I \colon = \uparrow I \ \ I \ \ ( \text {resp. } \downarrow I \colon = \downarrow I \ \ I ) ,
```
  FIX: ```
$$
\uparrow I \colon = \bigcup _ { x \in I } \uparrow x \ \ ( \text {resp. } \downarrow I \colon = \bigcup _ { x \in I } \downarrow x ) , \ \text {and } \uparrow \mathring{I} \colon = \uparrow I \setminus I \ \ ( \text {resp. } \downarrow \mathring{I} \colon = \downarrow I \setminus I ) ,
$$
```
- RAW: ```
\ s c _ { 1 } ( I ) \coloneqq \bigsqcup _ { a \in C _ { 2 } \ s c ( I ) } \vee ^ { \prime } a = \{ a _ { c } \colon = ( a , c ) \ | \ a \in C _ { 2 } \ s c ( I ) , \, c \in \vee ^ { \prime } a \} ,
```
  FIX: ```
$$
\mathrm{sc}_1( I ) \coloneqq \bigsqcup_{ a \in C_2 \mathrm{sc}( I ) } \vee' a = \{ a_c \colon = ( a, c ) \mid a \in C_2 \mathrm{sc}( I ), \, c \in \vee' a \} ,
$$
```
- RAW: ```
a n \text { similarly, } \, \text {sk} _ { 1 } ( I ) \coloneqq \bigsqcup _ { b \in C _ { 2 } \, \text {sk} ( I ) } \wedge ^ { \prime } b = \{ \, b _ { d } \coloneqq ( b , d ) \, | \, b \in C _ { 2 } \, \text {sk} ( I ) , \, d \in \wedge ^ { \prime } b \, \} .
```
  FIX: ```
$$
\text{and similarly, } \, \mathrm{sk}_1( I ) \coloneqq \bigsqcup_{ b \in C_2 \mathrm{sk}( I ) } \wedge' b = \{ \, b_d \coloneqq ( b, d ) \mid b \in C_2 \mathrm{sk}( I ), \, d \in \wedge' b \, \} .
$$
```
