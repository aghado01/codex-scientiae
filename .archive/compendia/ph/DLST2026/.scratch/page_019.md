[Page 19]

Proposition 4.17. Let \( B \) be an isolating block in \( V \). Then \( (\operatorname{cl} B, \operatorname{mo} B) \) is an index pair for \( \operatorname{Inv}_V B \). In particular, by Corollary 4.5, \( (\operatorname{cl} S, \operatorname{mo} S) \) is the minimal index pair for an isolated invariant set \( S \).

Proposition 4.18. Let \( (P, E) \) be a pair of closed sets such that \( E \subset P \) and \( P \setminus E \) is \( V \)-compatible. Then \( (P, E) \) is an index pair for \( S := \operatorname{Inv}_V (P \setminus E) \).

Proof. To see (IP1): let \( x \in P \setminus E \) and \( y \in F_V(x) = [x]_V \cup \operatorname{cl} x \). If \( y \in [x]_V \) then \( y \in P \), because \( P \setminus E \) is \( V \)-compatible. If \( y \in \operatorname{cl} x \) then \( y \in P \), because \( P \) is closed. Therefore, \( y \in P \). To see (IP2): let \( x \in E \) and \( y \in F_V(x) \). If \( y \in [x]_V \cap P \) then necessarily \( y \in E \) because \( P \setminus E \) is \( V \)-compatible and \( x \notin P \setminus E \). If \( y \in \operatorname{cl} x \) then \( y \in E \), because \( E \) is closed. Therefore, \( y \in E \). Condition (IP3) is given by the assumption. □

Theorem 4.19. [33, Theorem 5.16] Let \( (P_1, E_1) \) and \( (P_2, E_2) \) be two index pairs for an isolated invariant set \( S \) in \( V \). Then \( H(P_1, E_1) \cong H(P_2, E_2) \).

Definition 4.20. (Conley index) [33, Section 5.2] The Conley index of an isolated invariant set \( S \) is defined as \( \operatorname{Con}(S) := [H_0(P,E), H_1(P,E), \dots] \), where \( (P, E) \) is an index pair for \( S \) and the relative homology is calculated over the field \( k \). We also denote each component of \( \operatorname{Con}(S) \) as \( \operatorname{Con}_i(S) := H_i(P,E) \).

Note that the Conley index is well defined due to Theorem 4.19; and that every \( \operatorname{Con}_i(S) \) is isomorphic to the vector space \( k^{d_i} \), where \( d_i = \dim H_i(P,E) \).

Example 4.21. Conley indices for the Morse sets in \( M \) from Example 4.11 are as follows: \( \operatorname{Con}(M_1) = [k, k, 0] \), \( \operatorname{Con}(M_2) = [0, 0, k] \), and \( \operatorname{Con}(M_3) = [0, 0, 0] \). In case of \( M' \) from Example 4.13 we have \( \operatorname{Con}(M'_3) = [k, 0, 0] \) and \( \operatorname{Con}(M'_4) = [0, k, 0] \). Morse sets \( M'_1 \) and \( M'_2 \) coincide with \( M_1 \) and \( M_2 \). ♢

Theorem 4.19 can be proved by constructing a sequence of index pairs related by isomorphisms. We show such a sequence explicitly, as it will come in handy later. Moreover, the construction already hints at connections with persistence theory. To do that, let us recall Theorem 4.22 and the notion of push forward.

Theorem 4.22. [18, Theorem 28] If \( (P, E) \) and \( (P', E') \) are index pairs for \( S \) in \( V \) such that \( (P, E) \subset (P', E') \) then the inclusion induces an isomorphism in homology.

The push forward of a set \( A \) in \( Y \subset X \) with respect to \( V \) is defined by:

\[
\operatorname{pf}_V(A, Y) := \{ x \in Y \mid \exists_{a \in A} \exists_{\rho \in \operatorname{Paths}_V(Y)} \rho^\square = a \text{ and } \rho^\square = x \} .
\]

The crucial property of the push forward is captured by the following proposition, which can be easily proved by adapting the proof of [ 33 , Proposition 5.11].

Proposition 4.23. Let \( B \) be a locally closed, \( V \)-compatible subset of \( X \). Then, for any set \( A \subset B \), the push forward \( \operatorname{pf}_V(A, \operatorname{cl} B) \) is closed. Moreover, \( \operatorname{pf}_V(A, B) \) is locally closed and \( V \)-compatible.

Assume that \( (P, E) \) and \( (P', E') \) are two index pairs for \( S \) in \( V \). Now take \( B \), an isolating block for \( S \), such that \( B \subset P \setminus E \) and \( B \subset P' \setminus E' \) (by Corollary 4.5
