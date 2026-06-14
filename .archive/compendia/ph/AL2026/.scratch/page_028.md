[Page 28]

Proof Without loss of generality, we may assume that \( a_i = a_1 \) and \( b_j = b_1 \). Then

$$
$$
   \lambda = \begin{bmatrix} P _ { b _ { 1 } , a _ { 1 } } & 0 \\ 0 & 0 \end{bmatrix} .
  $$
$$

By ( Gabriel 1980 , Section 3.6), an almost split sequence ( 3.9 ) can be obtained as a pushout of the sequence ( 3.32 ) along a morphism \( \eta \colon P_{\text{sk}(I)} \to V_I \) as follows:

$$
$$
      P _ { \text {sk} ( I ) } \xrightarrow { \psi ^ { \ell } } P _ { 1 } \xrightarrow { \text {coker} \, \psi ^ { \ell } \sim 1 } & V _ { I } \longrightarrow 0 \\ \begin{vmatrix} \downarrow \eta & \downarrow \theta & \left \| & & \ddots & \\ & & \downarrow \theta & & \left \| & \\ & & V _ { I } & \xrightarrow { \mu } E \xrightarrow { \varepsilon } \xrightarrow { \varepsilon - 1 } V _ { I } & \longrightarrow 0 \end{vmatrix}
  $$
$$

Here, \( \eta \) is the composite of morphisms

$$
$$
   P _ { s k ( I ) } \xrightarrow { \text {can.} } \text {top} \, P _ { s k ( I ) } \stackrel { \sim } { \to } \, \text {soc} \, \nu P _ { s k ( I ) } \stackrel { \sim } { \to } \, \text {soc} \, V _ { I } \stackrel { \alpha } { \to } S \stackrel { \sim } { \to } \, \text {soc} \, V _ { I } \stackrel { \sim } { \to } V _ { I } ,
  $$
$$

where \( \nu \) is the Nakayama functor \( \nu := D \circ \operatorname{Hom}_A(-, A) \), \( S \) is any simple \( A \)-\( \operatorname{End}_A(V_I) \)-subbimodule of \( \operatorname{soc} V_I \), and \( \alpha \) is a retraction.

Here we claim that any simple \( A \)-submodule \( S \) of \( \operatorname{soc} V_I \) is automatically a simple \( A \)-\( \operatorname{End}_A(V_I) \)-subbimodule of \( \operatorname{soc} V_I \). Indeed, this follows from the fact that \( \operatorname{soc} V_I = \bigoplus_{i \in [m]} V_{\{b_i\}} \), where \( V_{\{b_i\}} \) are mutually non-isomorphic simple \( A \)-modules. More precisely, it is enough to show that \( f(S) \subseteq S \) for any \( f \in \operatorname{End}_A(V_I)^{\text{op}} \) because if this is shown, then \( S \) turns out to be a right \( \operatorname{End}_A(V_I) \)-submodule and a simple \( A \)-\( \operatorname{End}_A(V_I) \)-subbimodule of \( \operatorname{soc} V_I \). By the fact above, \( S \cong V_{\{b_i\}} \) for a unique \( i \in [m] \), and hence \( \operatorname{pr}_j(S) = 0 \) for all \( j \in [m] \setminus \{i\} \), where \( \operatorname{pr}_j \colon \operatorname{soc} V_I \to V_{\{b_j\}} \) is the canonical projection. Thus \( S \subseteq V_{\{b_i\}} \), which shows that \( S = V_{\{b_i\}} \) because the both hand sides are simple. Now if \( f = 0 \), then \( f(S) = 0 \subseteq S \); otherwise \( f(S) \cong S \), and then we have \( f(S) = V_{\{b_i\}} = S \) by applying the argument above to the simple \( A \)-submodule \( f(S) \) of \( \operatorname{soc} V_I \). This proves our claim.

Therefore, we may take \( S := V_{\{b_1\}} \), and

$$
$$
   \eta \coloneqq \left [ \rho _ { 1 _ { b _ { 1 } } } ^ { V _ { I } } , 0 , \dots , 0 \right ] \colon P _ { s k ( I ) } = P _ { b _ { 1 } } \oplus P _ { b _ { 2 } } \oplus \cdots \oplus P _ { b _ { m } } \to V _ { I } .
  $$
$$

By assumption, \( a_1 \le b_1 \) in \( I \). Hence we have a commutative diagram

$$
$$
   \eta ^ { \prime } \coloneqq \begin{bmatrix} P _ { b _ { 1 } , a _ { 1 } } & 0 & P _ { s c ( I ) } = P _ { a _ { 1 } } \oplus \cdots \oplus P _ { a _ { n } } \\ 0 & 0 & \widehat { \ } c \end{bmatrix} & \underset { \eta } { \searrow } \begin{bmatrix} V _ { I } \\ \varepsilon _ { 0 } = \left [ \rho _ { 1 a _ { 1 } } ^ { V _ { I } } , \dots , \rho _ { 1 a _ { n } } ^ { V _ { I } } \right ] \, . \\ \end{bmatrix} \\ P _ { s k ( I ) } \underset { \eta } { \leq } & \underset { \eta } { \longrightarrow } V _ { I }
  $$
$$

Indeed, by Lemma 3.17 , we have

$$
$$
   \varepsilon _ { 0 } \eta ^ { \prime } = \left [ \rho _ { 1 _ { a _ { 1 } } } ^ { V _ { I } } P _ { b _ { 1 } , a _ { 1 } } , 0 , \dots , 0 \right ] = \left [ \rho _ { V _ { I } ( p _ { b _ { 1 } , a _ { 1 } } ) ( 1 _ { a _ { 1 } } ) } ^ { V _ { I } } , 0 , \dots , 0 \right ] = \left [ \rho _ { 1 _ { b _ { 1 } } } ^ { V _ { I } } , 0 , \dots , 0 \right ] = \eta .
  $$
$$

The pushout diagram ( 3.34 ) yields the exact sequence

$$
$$
   P _ { s k ( I ) } \xrightarrow { \left [ \begin{smallmatrix} \eta \\ \Psi ^ { t } \end{smallmatrix} \right ] } V _ { I } \oplus P _ { 1 } \xrightarrow { [ \mu , - \theta ] } E \to 0 .
  $$
$$

Since \( P_1 \oplus P_2 = P_{\text{sk}(\downarrow I)} \oplus P_{\text{sk}_1(I)} \) and \( \pi_1 = \left[ \begin{smallmatrix} \Psi^t \\ 0 \end{smallmatrix} \right] \), this yields the exact sequence

$$
$$
   P _ { s k ( I ) } \xrightarrow { [ \eta _ { 1 } ] } V _ { I } \oplus ( P _ { s k ( \downarrow I ) } \oplus P _ { s k _ { 1 } ( I ) } ) \xrightarrow { \pi } E \oplus P _ { 2 } \to 0 ,
  $$
$$
