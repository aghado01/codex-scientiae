[Page 14]

$$
\rho ( t ) \colon = \begin{cases} x ; & t = 0 , \\ y ; & t = 1 , \\ z ; & t = 2 . \end{cases}
$$

With the notion of an essential solution we are ready to define the notion of invariance and isolation in the context of multivector fields. The invariant part of a set \( A \subset X \) is defined as \( \mathrm{Inv}_V(A) := \{ x \in A \mid \mathrm{eSol}_V(x, A) \neq \emptyset \} = \{ \mathrm{im}\, \varphi \mid \varphi \in \mathrm{eSol}_V(A) \} \) . A set \( S \subset X \) is called an invariant if \( \mathrm{Inv}_V S = S \) . Clearly, an invariant part forms an invariant set.


Definition 4.2. (Isolating block and isolated invariant set) A set \( N \subset X \) is a (combinatorial) isolating block if for every path \( x \cdot y \cdot z \) such that \( x,z \in N \) implies \( y \in N \) . An invariant set \( S \) is called an isolated invariant set if there exists an isolating block \( N \) such that \( S = \mathrm{Inv}_V N \) .

Proposition 4.3. A set \( N \) is an isolating block if and only if \( N \) is locally closed and \( V \)-compatible.

Proof. Assume that \( N \) is an isolating block. To prove that \( N \) is \( V \)-compatible, we need to show that for any \( x \in N \), \( [x]_V \) is a subset of \( N \). To do so, fix \( x \in N \) and \( y \in [x]_V \) and notice that \( y \in F_V(x) \) and \( x \in F_V(y) \). By definition, path \( x \cdot y \cdot x \) implies that \( y \in N \). Thus, \( [x]_V \subset N \), which proves that N is V -compatible. Similarly, let \( x,z \in N \) and \( y \in X \) such that \( x > y > z \). It follows that \( y \in F_V(x) \) and \( z \in F_V(y) \). Therefore, a path \( x \cdot y \cdot z \) is a solution and \( y \in N \) by definition of isolating block, which proves that N is locally closed.

Now assume that N is a locally closed and V -compatible set. Suppose that there exists a path x · y · z such that \( x,z \in N \) and \( y \notin N \). Necessarily, \( [x]_V \neq [y]_V \neq [z]_V \), because of the \( V \)-compatibility of \( N \). Thus, we have \( y \in \mathrm{cl}(x) \), \( z \in \mathrm{cl}(y) \) and \( y \in \mathrm{mo}\, N \). Lastly, since \( N \) is locally closed, \( \mathrm{mo}\, N \) is closed and \( z \in \mathrm{mo}\, N \), a contradiction. \(\square\)



Proposition 4.4. [ 33 , Propositions 4.10, 4.11 & 4.12] An invariant set S is an isolated invariant set if and only if it is locally closed and V -compatible.

Corollary 4.5. An isolated invariant set S is itself the minimal isolating block for \( S \).

Example 4.6. The left panel of Figure 10 shows a multivector field with four isolating blocks highlighted in brown. Three of them, \( B_1 \), \( B_2 \) and \( B_3 \), have nonempty invariant part, which are respectively denoted \( M_1 \), \( M_2 \), and \( M_3 \), and highlighted in green in the right panel of Figure 10 . \(\lozenge\)

1 Clearly, the concatenation of two solutions requires adjusting the domain of the new path. There are couple ways of doing that (for instance, see [ 33 , Section 4.2]); nevertheless the choice of reparameterization is irrelevant here.
