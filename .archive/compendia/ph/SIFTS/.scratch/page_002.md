[Page 2]

![image 1](<SIFTS/imageFile1.png>)

There are two equivalent classes of rubber bands: some surround the hole and others do not. Conversely, two equivalent classes indicate one hole. To formalize this idea, we need to introduce some algebraic concepts.

## 2.1 Group Theory

Definition 1. A group \( G, * \) is a set \( G \) with a binary operation \( * \) such that (1. associative) \( a * (b * c) = (a * b) * c \) for all \( a,b,c \in G \). (2. identity) \( \exists e \in G \) so that \( e * a = a * e = a \) for all \( a \in G \). (3. inverse) \( \forall a \in G \), \( \exists a^{-1} \in G \) where \( a * a^{-1} = a^{-1} * a = e \). For example, integer addition \( \mathbb{Z}, + \), real number addition

 \( \mathbb{R}, + \) are groups with identity \( 0 \) and \( a \)'s inverse \( -a \). Positive real numbers and multiplication is a group \( \mathbb{R}^+, \times \) with identity \( 1 \) and \( a \)'s inverse \( \frac{1}{a} \). However, \( \mathbb{R}, \times \) is not a group since \( 0 \in \mathbb{R} \) does not have an inverse under \( \times \). Real numbers except 0 is again a group \( \mathbb{R} \setminus \{ 0 \}, \times \). \( \mathbb{Z}_2 \) is the only group (up to element renaming) of size two:

FILL_ME_IN

We can think of \( +_2 \) as the XOR function or mod-2 addition. For any set \( A = \{ a_1 ,...,a_n \} \), its power set forms a group \( 2^A, +_2 \) where \( +_2 \) is the symmetric difference: \( B +_2 C = ( B \cup C ) \setminus ( B \cap C ) \). The identity is the empty set \( \emptyset \), and the inverse of any \( B \subseteq A \) is \( B \) itself.

Definition 2. A group \( G \) is abelian if the operation \( * \) is commutative: \( \forall a, b \in G, a * b = b * a \).

non-abelian groups, consider \( n \times n \) invertible matrices under matrix multiplication.

Definition 3. A subset \( H \subseteq G \) of a group \( G, * \) is a subgroup of \( G \) if \( H, * \) is itself a group. \( \{ e \} \) is the trivial subgroup of any group \( G \) (we often omit

the operation when it is clear). \( \mathbb{R}^+, \times \) is a subgroup of \( \mathbb{R} \setminus \{0\}, \times \) by restricting multiplication to positive numbers. Note however multiplication on negative numbers \( \mathbb{R}^-, \times \) is not a subgroup because the result is not in \( \mathbb{R}^- \). Definition 4. Given a subgroup \( H \) of an abelian group \( G \), for

any \( a \in G \), the set \( a * H = \{ a * h \mid h \in H \} \) is the coset of \( H \) represented by \( a \).

Consider \( H = \mathbb{R}^+ \) and \( G = \mathbb{R} \setminus \{ 0 \} \). Then \( 3.14 \times \mathbb{R}^+ \) is a coset which is the same as \( \mathbb{R}^+ \). In fact for any \( a > 0 \), \( a \times \mathbb{R}^+ = \mathbb{R}^+ \), i.e., many different \( a \)'s represent the same coset. On the other hand, \( -1 \times \mathbb{R}^+ = \mathbb{R}^- \), so \( \mathbb{R}^- \) is a coset represented by \( -1 \) (or any negative number, for that matter). Since \( \mathbb{R}^- \) is not a group, we see the cosets do not have to be subgroups. Also note that the two cosets, \( \mathbb{R}^+ \) and \( \mathbb{R}^- \), have equal size and partition \( G \). This fact will be important for counting cycles for homology later.

We now consider mappings from one group \( G, * \) to another \( G', \cdot \).

Definition 5. A map \( \phi : G \to G' \) is a homomorphism if \( \phi(a * b) = \phi(a) \phi(b) \) for \( \forall a,b \in G \). For example, the groups \( \mathbb{R}^+, \times \) and \( \mathbb{Z}_2, +_2 \) do not look

similar at all. But there is a trivial homomorphism \( \phi(a) = 0, \forall a \in \mathbb{R}^+ \). Note the last 0 is in \( \mathbb{Z}_2 \). This simply says that we map all positive real numbers to the "0" in mod-2 addition. Obviously \( 0 = \phi(a \times b) = \phi(a) +_2 \phi(b) = 0 +_2 0 = 0 \) for \( \forall a,b \in \mathbb{R}^+ \). As another example, consider the group of (somewhat arti-

ficial) negation in natural language: \( G_N = \{ \sqcup, \text{not} \} \) with the following operation, where \( \sqcup \) stands for whitespace:

FILL_ME_IN

i.e., single negation stays while double negation cancels. There is a homomorphism between \( G_N \) and \( \mathbb{Z}_2 \): \( \phi(\sqcup) = 0, \phi(\text{not}) = 1 \). In fact, \( G_N \) and \( \mathbb{Z}_2 \) are identical up to renaming. There is a name for such homomorphisms:

Definition 6. A homomorphism that is a one-to-one correspondence is called an isomorphism.

Definition 7. The kernel of a homomorphism \( \phi : G \to G' \) is \( \ker \phi = \{ a \in G \mid \phi(a) = e' \} \). In other words, the kernel is the elements that map to identity.

Theorem 1. For any homomorphism \( \phi : G \to G' \), \( \ker \phi \) is a subgroup of \( G \).

![image 2](<SIFTS/imageFile2.png>)






\( \ker \phi \)

Because \( \ker \phi \) is a subgroup (depicted as the blue square above), we can partition \( G \) into cosets of the form \( a * \ker \phi \) for \( a \in G \). These cosets are the white or blue squares. For example, \( \phi : \mathbb{R} \setminus \{ 0 \}, \times \to G_N \) with \( \phi(a) = \sqcup \) if \( a > 0 \) and "not" if \( a < 0 \), then \( \ker \phi = \mathbb{R}^+ \) is one coset and \( \mathbb{R}^- \) is the only other coset.

We need one more piece of definition. Let \( H, * \) be a subgroup of an abelian group \( G, * \). We can introduce a new binary operation not on the elements of \( G \) but on the cosets of \( H \): \( (a * H) \cdot (b * H) = (a * b) * H, \forall a,b \in G \). The operation is well-defined and does not depend on the particular choice of representer.

Definition 8. The cosets \( \{ a * H \mid a \in G \} \) under the operation \( \cdot \) form a group, called the quotient group \( G/H \).

It is useful to think of quotient groups as "higher level" groups defined on the squares in the previous picture. \( \ker \phi \) (the blue square) is a subgroup of \( G \). The elements of the quotient group \( G / \ker \phi \) are the cosets of \( \ker \phi \), i.e. all the squares. In a previous example \( G = \mathbb{R} \setminus \{ 0 \} \) and \( \ker \phi = \mathbb{R}^+ \), and there were two cosets: \( \mathbb{R}^+ \) and \( \mathbb{R}^- \). Thus the quotient group \( (\mathbb{R} \setminus \{ 0 \}) / \mathbb{R}^+ \) is a small group with those two cosets as elements. Furthermore, note \( \mathbb{R}^- \cdot \mathbb{R}^- = (-1 \times \mathbb{R}^+) \cdot (-1 \times \mathbb{R}^+) = (-1 \times -1) \times \mathbb{R}^+ = 1 \times \mathbb{R}^+ = \mathbb{R}^+ \). Therefore, this quotient group \( (\mathbb{R} \setminus \{ 0 \}) / \mathbb{R}^+ \) is isomorphic to \( \mathbb{Z}_2 \).
