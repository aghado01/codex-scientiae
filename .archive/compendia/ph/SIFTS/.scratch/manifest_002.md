# Manifest: Page 002

## REPLACE_TABLES
- RAW: ```
$$
\frac { + _ { 2 } } { 0 } \left | \begin{array} { c c c } 0 & 1 \\ 0 & 1 \\ 1 & 1 & 0 \end{array} \right |
$$
```
  FIX: ```
FILL_ME_IN
```

- RAW: ```
$$
\frac { * } { \sqcup } \left | \, \sqcup \, \, \text { not } \, \substack { \sqcup \\ \text { not } \, \sqcup } \right |
$$
```
  FIX: ```
FILL_ME_IN
```

## REPAIR_PROSE
- RAW: ```
Deﬁnition 1. A group G, ∗  is a set G with a binary operation ∗ such that (1. associative) a ∗ ( b ∗ c ) = ( a ∗ b ) ∗ c for all a,b,c ∈ G . (2. identity) ∃ e ∈ G so that e ∗ a = a ∗ e = a for all a ∈ G . (3. inverse) ∀ a ∈ G , ∃ a ∈ G where a ∗ a = a ∗ a = e . For example, integer addition Z , + , real number addition
```
  FIX: ```
Definition 1. A group \( G, * \) is a set \( G \) with a binary operation \( * \) such that (1. associative) \( a * (b * c) = (a * b) * c \) for all \( a,b,c \in G \). (2. identity) \( \exists e \in G \) so that \( e * a = a * e = a \) for all \( a \in G \). (3. inverse) \( \forall a \in G \), \( \exists a^{-1} \in G \) where \( a * a^{-1} = a^{-1} * a = e \). For example, integer addition \( \mathbb{Z}, + \), real number addition
```

- RAW: ```
 R , + are groups with identity 0 and a ’s inverse − a . Positive real numbers and multiplication is a group R + , ×  with identity 1 and a ’s inverse 1 a . However, R , ×  is not a group since 0 ∈ R does not have an inverse under × . Real numbers except 0 is again a group R \{ 0 } , ×  . Z 2 is the only group (up to element renaming) of size two:
```
  FIX: ```
 \( \mathbb{R}, + \) are groups with identity \( 0 \) and \( a \)'s inverse \( -a \). Positive real numbers and multiplication is a group \( \mathbb{R}^+, \times \) with identity \( 1 \) and \( a \)'s inverse \( \frac{1}{a} \). However, \( \mathbb{R}, \times \) is not a group since \( 0 \in \mathbb{R} \) does not have an inverse under \( \times \). Real numbers except 0 is again a group \( \mathbb{R} \setminus \{ 0 \}, \times \). \( \mathbb{Z}_2 \) is the only group (up to element renaming) of size two:
```

- RAW: ```
We can think of + 2 as the XOR function or mod-2 addition. For any set A = { a 1 ,...,a n } , its power set forms a group 2 A , + 2 where + 2 is the symmetric difference: B + 2 C = ( B ∪ C ) \ ( B ∩ C ) . The identity is the empty set ∅ , and the inverse of any B ⊆ A is B itself. Deﬁnition 2. A group G is abelian if the operation is com-

Definition 2. A group G is abelian if the operation ∗ is commutative: ∀ a, b ∈ G,a ∗ b = b ∗ a .
```
  FIX: ```
We can think of \( +_2 \) as the XOR function or mod-2 addition. For any set \( A = \{ a_1 ,...,a_n \} \), its power set forms a group \( 2^A, +_2 \) where \( +_2 \) is the symmetric difference: \( B +_2 C = ( B \cup C ) \setminus ( B \cap C ) \). The identity is the empty set \( \emptyset \), and the inverse of any \( B \subseteq A \) is \( B \) itself.

Definition 2. A group \( G \) is abelian if the operation \( * \) is commutative: \( \forall a, b \in G, a * b = b * a \).
```

- RAW: ```
non-abelian groups, consider n × n invertible matrices under matrix multiplication.
```
  FIX: ```
non-abelian groups, consider \( n \times n \) invertible matrices under matrix multiplication.
```

- RAW: ```
Deﬁnition 3. A subset H ⊆ G of a group G, ∗  is a subgroup of G if H, ∗  is itself a group. e is the trivial subgroup of any group G (we often omit

{ } the operation when it is clear). R + , ×  is a subgroup of R \{ 0 } , ×  by restricting multiplication to positive numbers. Note however multiplication on negative numbers R − , ×  is not a subgroup because the result is not in R − . Deﬁnition 4. Given a subgroup H of an abelian group G , for
```
  FIX: ```
Definition 3. A subset \( H \subseteq G \) of a group \( G, * \) is a subgroup of \( G \) if \( H, * \) is itself a group. \( \{ e \} \) is the trivial subgroup of any group \( G \) (we often omit

the operation when it is clear). \( \mathbb{R}^+, \times \) is a subgroup of \( \mathbb{R} \setminus \{0\}, \times \) by restricting multiplication to positive numbers. Note however multiplication on negative numbers \( \mathbb{R}^-, \times \) is not a subgroup because the result is not in \( \mathbb{R}^- \). Definition 4. Given a subgroup \( H \) of an abelian group \( G \), for
```

- RAW: ```
any a ∈ G , the set a ∗ H = { a ∗ h | h ∈ H } is the coset of H represented by a .
```
  FIX: ```
any \( a \in G \), the set \( a * H = \{ a * h \mid h \in H \} \) is the coset of \( H \) represented by \( a \).
```

- RAW: ```
Consider H = R + and G = R \{ 0 } . Then 3 . 14 × R + is a coset which is the same as R + . In fact for any a > 0 , a × R + = R + , i.e., many different a ’s represent the same coset. On the other hand, − 1 × R + = R − , so R − is a coset represented by -1 (or any negative number, for that matter). Since R − is not a group, we see the cosets do not have to be subgroups. Also note that the two cosets, R + and R − , have equal size and partition G . This fact will be important for counting cycles for homology later.
```
  FIX: ```
Consider \( H = \mathbb{R}^+ \) and \( G = \mathbb{R} \setminus \{ 0 \} \). Then \( 3.14 \times \mathbb{R}^+ \) is a coset which is the same as \( \mathbb{R}^+ \). In fact for any \( a > 0 \), \( a \times \mathbb{R}^+ = \mathbb{R}^+ \), i.e., many different \( a \)'s represent the same coset. On the other hand, \( -1 \times \mathbb{R}^+ = \mathbb{R}^- \), so \( \mathbb{R}^- \) is a coset represented by \( -1 \) (or any negative number, for that matter). Since \( \mathbb{R}^- \) is not a group, we see the cosets do not have to be subgroups. Also note that the two cosets, \( \mathbb{R}^+ \) and \( \mathbb{R}^- \), have equal size and partition \( G \). This fact will be important for counting cycles for homology later.
```

- RAW: ```
We now consider mappings from one group G, ∗  to another G , .
```
  FIX: ```
We now consider mappings from one group \( G, * \) to another \( G', \cdot \).
```

- RAW: ```
Deﬁnition 5. A map φ : G  → G is a homomorphism if φ ( a ∗ b ) = φ ( a ) φ ( b ) for ∀ a,b ∈ G . For example, the groups R , and Z , + do not look

  + × 2 2 similar at all. But there is a trivial homomorphism φ ( a ) = 0 , ∀ a ∈ R + . Note the last 0 is in Z 2 . This simply says that we map all positive real numbers to the “0” in mod-2 addition. Obviously 0 = φ ( a × b ) = φ ( a ) + 2 φ ( b ) = 0 + 2 0 = 0 for ∀ a,b ∈ R + . As another example, consider the group of (somewhat arti-
```
  FIX: ```
Definition 5. A map \( \phi : G \to G' \) is a homomorphism if \( \phi(a * b) = \phi(a) \phi(b) \) for \( \forall a,b \in G \). For example, the groups \( \mathbb{R}^+, \times \) and \( \mathbb{Z}_2, +_2 \) do not look

similar at all. But there is a trivial homomorphism \( \phi(a) = 0, \forall a \in \mathbb{R}^+ \). Note the last 0 is in \( \mathbb{Z}_2 \). This simply says that we map all positive real numbers to the "0" in mod-2 addition. Obviously \( 0 = \phi(a \times b) = \phi(a) +_2 \phi(b) = 0 +_2 0 = 0 \) for \( \forall a,b \in \mathbb{R}^+ \). As another example, consider the group of (somewhat arti-
```

- RAW: ```
ﬁcial) negation in natural language: G N = {  , not } with the following operation, where stands for whitespace: not
```
  FIX: ```
ficial) negation in natural language: \( G_N = \{ \sqcup, \text{not} \} \) with the following operation, where \( \sqcup \) stands for whitespace:
```

- RAW: ```
i.e., single negation stays while double negation cancels. There is a homomorphism between G N and Z 2 : φ ( ) = 0 ,φ ( not ) = 1 . In fact, G N and Z 2 are identical up to renaming. There is a name for such homomorphisms:
```
  FIX: ```
i.e., single negation stays while double negation cancels. There is a homomorphism between \( G_N \) and \( \mathbb{Z}_2 \): \( \phi(\sqcup) = 0, \phi(\text{not}) = 1 \). In fact, \( G_N \) and \( \mathbb{Z}_2 \) are identical up to renaming. There is a name for such homomorphisms:
```

- RAW: ```
Deﬁnition 6. A homomorphism that is a one-to-one correspondence is called an isomorphism .
```
  FIX: ```
Definition 6. A homomorphism that is a one-to-one correspondence is called an isomorphism.
```

- RAW: ```
Deﬁnition 7. The kernel of a homomorphism φ : G  → G   is ker φ = { a ∈ G | φ ( a ) = e   } . In other words, the kernel is the elements that map to identity.
```
  FIX: ```
Definition 7. The kernel of a homomorphism \( \phi : G \to G' \) is \( \ker \phi = \{ a \in G \mid \phi(a) = e' \} \). In other words, the kernel is the elements that map to identity.
```

- RAW: ```
Theorem 1. For any homomorphism φ : G  → G , ker φ is a subgroup of G .
```
  FIX: ```
Theorem 1. For any homomorphism \( \phi : G \to G' \), \( \ker \phi \) is a subgroup of \( G \).
```

- RAW: ```
ker φ
```
  FIX: ```
\( \ker \phi \)
```

- RAW: ```
Because ker φ is a subgroup (depicted as the blue square above), we can partition G into cosets of the form a ∗ ker φ for a ∈ G . These cosets are the white or blue squares. For example, φ : R \{ 0 } , × → G N with φ ( a ) = if a > 0 and “not” if a < 0 , then ker φ = R + is one coset and R − is the only other coset.
```
  FIX: ```
Because \( \ker \phi \) is a subgroup (depicted as the blue square above), we can partition \( G \) into cosets of the form \( a * \ker \phi \) for \( a \in G \). These cosets are the white or blue squares. For example, \( \phi : \mathbb{R} \setminus \{ 0 \}, \times \to G_N \) with \( \phi(a) = \sqcup \) if \( a > 0 \) and "not" if \( a < 0 \), then \( \ker \phi = \mathbb{R}^+ \) is one coset and \( \mathbb{R}^- \) is the only other coset.
```

- RAW: ```
We need one more piece of deﬁnition. Let H, ∗  be a subgroup of an abelian group G, ∗  . We can introduce a new binary operation not on the elements of G but on the cosets of H : ( a ∗ H ) ( b ∗ H ) = ( a ∗ b ) ∗ H, ∀ a,b ∈ G . The operation is well-deﬁned and does not depend on the particular choice of representer.
```
  FIX: ```
We need one more piece of definition. Let \( H, * \) be a subgroup of an abelian group \( G, * \). We can introduce a new binary operation not on the elements of \( G \) but on the cosets of \( H \): \( (a * H) \cdot (b * H) = (a * b) * H, \forall a,b \in G \). The operation is well-defined and does not depend on the particular choice of representer.
```

- RAW: ```
Deﬁnition 8. The cosets { a ∗ H | a ∈ G } under the operation   form a group, called the quotient group G/H .
```
  FIX: ```
Definition 8. The cosets \( \{ a * H \mid a \in G \} \) under the operation \( \cdot \) form a group, called the quotient group \( G/H \).
```

- RAW: ```
It is useful to think of quotient groups as “higher level” groups deﬁned on the squares in the previous picture. ker φ (the blue square) is a subgroup of G . The elements of the quotient group G/ ker φ are the cosets of ker φ , i.e. all the squares. In a previous example G = R \{ 0 } and ker φ = R + , and there were two cosets: R + and R − . Thus the quotient group ( R \{ 0 } ) / R + is a small group with those two cosets as elements. Furthermore, note R − R − = ( − 1 × R + ) ( − 1 × R + ) = ( − 1 × − 1) × R + = 1 × R + = R + . Therefore, this quotient group ( R \{ 0 } ) / R + is isomorphic to Z 2 .
```
  FIX: ```
It is useful to think of quotient groups as "higher level" groups defined on the squares in the previous picture. \( \ker \phi \) (the blue square) is a subgroup of \( G \). The elements of the quotient group \( G / \ker \phi \) are the cosets of \( \ker \phi \), i.e. all the squares. In a previous example \( G = \mathbb{R} \setminus \{ 0 \} \) and \( \ker \phi = \mathbb{R}^+ \), and there were two cosets: \( \mathbb{R}^+ \) and \( \mathbb{R}^- \). Thus the quotient group \( (\mathbb{R} \setminus \{ 0 \}) / \mathbb{R}^+ \) is a small group with those two cosets as elements. Furthermore, note \( \mathbb{R}^- \cdot \mathbb{R}^- = (-1 \times \mathbb{R}^+) \cdot (-1 \times \mathbb{R}^+) = (-1 \times -1) \times \mathbb{R}^+ = 1 \times \mathbb{R}^+ = \mathbb{R}^+ \). Therefore, this quotient group \( (\mathbb{R} \setminus \{ 0 \}) / \mathbb{R}^+ \) is isomorphic to \( \mathbb{Z}_2 \).
```
