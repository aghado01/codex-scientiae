[Page 22]

$$
$$
P _ { 1 } ^ { M } \oplus P _ { 0 } ^ { M ^ { \prime } } \stackrel { \eta _ { 1 } } { \longrightarrow } P _ { 0 } ^ { M } \stackrel { \eta _ { 0 } } { \longrightarrow } M / M ^ { \prime } \to 0 .
$$
$$

Here \( \eta_0 := \pi \varepsilon_0^M \) and \( \eta_1 := [\varepsilon_1^M, \eta_{11}] \), where \( \eta_{11} : P_0^{M'} \to P_0^M \) is a lift of \( \iota \varepsilon_0^{M'} \) along \( \varepsilon_0^M \), i.e., a morphism satisfying the equality \( \varepsilon_0^M \eta_{11} = \iota \varepsilon_0^{M'} \), the existence of which is guaranteed by the projectivity of \( P_0^{M'} \).

Proof Express \( \varepsilon_1^M \) as the composite \( \varepsilon_1^M = \iota_0 \tau_1 : P_1^M \stackrel{\tau_1}{\longrightarrow} \text{Im} \varepsilon_1^M \stackrel{\iota_0}{\longrightarrow} P_0^M \), where \( \iota_0 \) is the inclusion and \( \tau_1 \) is an epimorphism obtained from \( \varepsilon_1^M \) by restricting the codomain. Consider the following commutative diagram of solid arrows with exact rows surrounded by dashed lines:

$$
$$
\text {following commutative diagram of solid arrows with exact rows surrounded by dashed
: } & \quad \underset { \substack { 1 \\ 0 \\ 1 \\ 1 \\ 0 \\ \sim \cdots \sim 1 } } { \longrightarrow } P _ { 1 } \stackrel { [ 1 ] } { \longrightarrow } P _ { 1 } ^ { M } \oplus P _ { 0 } ^ { M ^ { \prime } } \stackrel { [ 0 , 1 ] } { \longrightarrow } P _ { 0 } ^ { M ^ { \prime } } \longrightarrow 0 \stackrel { \cdots } { \vdots } \\ & \quad \stackrel { [ \tau _ { 1 } } { \sim } \quad \downarrow _ { 1 } \quad \downarrow _ { \eta _ { 1 } } \stackrel { [ \eta _ { 1 } } { \sim } \stackrel { \cdots } { \longrightarrow } \quad \downarrow _ { \tau _ { 0 } } M ^ { M ^ { \prime } } \stackrel { \cdots } { \sim } \stackrel { \cdots } { \equiv } \\ & \quad \stackrel { [ 0 \longrightarrow M ^ { M } \longrightarrow 0 \stackrel { \sim } { \longrightarrow } P _ { 0 } ^ { M } \stackrel { \kappa ^ { \prime } } { \longrightarrow } M } { \longrightarrow } \stackrel { [ 0 \longrightarrow M ^ { M } \longrightarrow 0 \stackrel { \sim } { \longrightarrow } P _ { 0 } ^ { M } ] } { \sim } \stackrel { [ \tau _ { 1 } } { \longrightarrow } \\ & \quad \stackrel { [ 0 \longrightarrow \tilde { c } o k \eta _ { 1 } ] } { \sim } \stackrel { \downarrow _ { \tau _ { 0 } } } { \longrightarrow } \stackrel { \stackrel { \frac { M } { \tau _ { 0 } } } { \sim } } { \longrightarrow } M / M ^ { \prime } \longrightarrow 0 \\ & \quad \stackrel { \downarrow _ { 0 } } { \sim } \stackrel { \downarrow _ { 1 } } { \longrightarrow } \stackrel { \downarrow _ { 0 } } { \stackrel { \downarrow } { \sim } } \\ & \quad \stackrel { \downarrow _ { 0 } } { \sim } \stackrel { \downarrow _ { 0 } } { \longrightarrow }
$$
$$

Notice that the right-most column

$$
$$
P _ { 0 } ^ { M ^ { \prime } } \stackrel { \iota \varepsilon _ { 0 } ^ { M ^ { \prime } } } { \longrightarrow } M \stackrel { \pi } { \rightarrow } M / M ^ { \prime } \rightarrow 0
$$
$$

is exact since \( \text{Im} \iota \varepsilon_0^{M'} = \text{Im} \iota = M' = \text{Ker} \pi \). By applying the snake lemma to this diagram, we obtain that \( \varepsilon_0^M : \text{Coker} \eta_1 \to M/M' \) is an isomorphism. Since \( \varepsilon_0^M \circ \text{coker} \eta_1 = \pi \varepsilon_0^M = \eta_0 \), the central column yields the exact sequence

$$
$$
P _ { 0 } ^ { M ^ { \prime } } \oplus P _ { 1 } ^ { M } \stackrel { \eta _ { 1 } } { \longrightarrow } P _ { 0 } ^ { M } \stackrel { \eta _ { 0 } } { \longrightarrow } M / M ^ { \prime } \to 0 . \quad \square
$$
$$

# Notation 3.16. Let \( I \) be an interval of \( P \).

- (1) Note that \( \text{sc}(I) = \text{sc}(\uparrow I) \), and hence also \( \text{sc}_1(I) = \text{sc}_1(\uparrow I) \). Therefore, \( \varepsilon_1^{\uparrow I} : P_{\text{sc}_1(\uparrow I)} \to P_{\text{sc}(\uparrow I)} \) is denoted by \( \varepsilon_1^{\uparrow I} : P_{\text{sc}_1(I)} \to P_{\text{sc}(I)} \), where the definition of \( \varepsilon_1^{\uparrow I} \) is given by (3.15) for \( U := \uparrow I \).
- (2) Note that for each \( a' \in \text{sc}(\Uparrow I) \), we have \( \text{sc}(I) \cap \downarrow a' \neq \emptyset \) because \( a' \in \uparrow I \). Fixing one element in \( \text{sc}(I) \cap \downarrow a' \) for each \( a' \in \text{sc}(\Uparrow I) \) yields a map \( c : \text{sc}(\Uparrow I) \to \text{sc}(I) = \text{sc}(\uparrow I) \). We call such \( c \) a choice map.



The following is used in the computations below.

Lemma 3.17. Let \( M \in \text{mod} A \), \( x, y \in P \), and \( a \in M(x) \). Then the composite of morphisms \( P_y \stackrel{P_{y,x}}{\longrightarrow} P_x \stackrel{\rho_a^M}{\longrightarrow} M \) is given by

$$
$$
\rho _ { a } ^ { M } \cdot P _ { y , x } = \rho _ { M ( p _ { y , x } ) ( a ) } ^ { M } .
$$
$$
