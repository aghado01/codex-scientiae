[Page 4]

$$
$$
\uparrow I \colon = \bigcup _ { x \in I } \uparrow x \ \ ( \text {resp. } \downarrow I \colon = \bigcup _ { x \in I } \downarrow x ) , \ \text {and } \uparrow \mathring{I} \colon = \uparrow I \setminus I \ \ ( \text {resp. } \downarrow \mathring{I} \colon = \downarrow I \setminus I ) ,
$$
$$

and call them the up-set (resp. down-set ) of I , and the proper up-set (resp. proper down-set ) of I , respectively.

(2) For any totally ordered set T = ( T, ⪯ ) , we denote by C 2 T the set of all subsets of T consisting of exactly two elements. For any a = { i,j } ∈ C 2 T with i ≺ j in T , we set a : = i (resp. a : = j ). Then we can write a = { a , a } .

Now, after giving total orders on sc( I ) and sk( I ) , for any a ∈ C 2 sc( I ) (resp. b ∈ C 2 sk( I ) ), we set ∨ ′ a : = sc( ↑ a ∩ ↑ a ) (resp. ∧ ′ b : = sk( ↓ b ∩ ↓ b ), and call it the pre-join (resp. pre-meet ) of a (resp. b ). We then set sc 1 ( I ) to be the disjoint union of all pre-joins of the two-element subsets of sc( I ) . Namely,

$$
$$
\mathrm{sc}_1( I ) \coloneqq \bigsqcup_{ a \in C_2 \mathrm{sc}( I ) } \vee' a = \{ a_c \colon = ( a, c ) \mid a \in C_2 \mathrm{sc}( I ), \, c \in \vee' a \} ,
$$
$$

$$
$$
\text{and similarly, } \, \mathrm{sk}_1( I ) \coloneqq \bigsqcup_{ b \in C_2 \mathrm{sk}( I ) } \wedge' b = \{ \, b_d \coloneqq ( b, d ) \mid b \in C_2 \mathrm{sk}( I ), \, d \in \wedge' b \, \} .
$$
$$

For example in Fig. 1 , for a : = { a 2 ,a 3 } ∈ C 2 sc( I ) (with the additional total order ⪯ ) we have a = a 2 and a = a 3 . Moreover, the element { a 2 ,a 3 } x is minimal in ↑ a ∩ ↑ a .

(3) If sc( ⇑ I ) ̸ = ∅ , then for each a ′ ∈ sc( ⇑ I ) , we have sc( I ) ∩ ↓ a ′ ̸ = ∅ because a ′ ∈ ↑ I . Fixing one element in sc( I ) ∩ ↓ a ′ for each a ′ ∈ sc( ⇑ I ) yields a map c : sc( ⇑ I ) → sc( I ) . We call such c a choice map . Dually, if sk( ⇓ I ) ̸ = ∅ , then for each b ′ ∈ sk( ⇓ I ) , we have sk( I ) ∩ ↑ b ′ ̸ = ∅ because b ′ ∈ ↓ I . Fixing one element b ∈ sk( I ) ∩ ↑ b ′ for each b ′ ∈ sk( ⇓ I ) yields another choice map d : sk( ⇓ I ) → sk( I ) that sends b ′ to b . See Fig. 1 for an illustration of such an a ′ ∈ sc( ⇑ I ) and a choice of a 1 ∈ sc( I ) such that a 1 ≤ a ′ .





As a remark in Fig. 1 , there are two elements x and y in ∨ ′ { a 2 ,a 3 } , labeled as { a 2 ,a 3 } x and { a 2 ,a 3 } y in sc 1 ( I ) , respectively. We address that sc 1 ( I ) may contain some elements which are not in I . For example, y is not an element of I in this illustration. We also note that the element w / ∈ ∨ ′ { a 2 ,a 3 } since w is not minimal in ↑ a 2 ∩↑ a 3 , but w is in both ∨ ′ { a 1 ,a 2 } and ∨ ′ { a 1 ,a 3 } . By this we write { a 1 ,a 2 } w and { a 1 ,a 3 } w in sc 1 ( I ) , standing for w ∈ I .

# 1.2 Purposes

In the standard one-parameter persistent homology, the multiplicity of an interval can be computed by taking ranks (a.k.a., persistent Betti numbers) along some larger intervals and then operating an alternating sum of the ranks by the inclusion-exclusion principle. This computation is well-known as the formula of the persistent Betti numbers and the multiplicity in one-parameter persistent homology (see ( Edelsbrunner and Harer 2010 , Chapter VII)).
