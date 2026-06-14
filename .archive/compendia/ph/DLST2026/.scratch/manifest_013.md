# Manifest: Page 013

## REPAIR_PROSE
- RAW: `We write Sol V ( A ) for the family of all solutions in the graph G V such that im ρ ⊂ A . It will be handy to distinguish the following subsets of Sol V ( A ):`
  FIX: `We write \( \text{Sol}_{\mathcal{V}}(A) \) for the family of all solutions in the graph \( G_{\mathcal{V}} \) such that \( \text{im } \rho \subset A \). It will be handy to distinguish the following subsets of \( \text{Sol}_{\mathcal{V}}(A) \):`

- RAW: `In particular, Paths V ( B s ,B e ,A ) contains all bounded solutions in A with the starting point in B s and the end point in B e . On the other hand iSol V ( A ) consists of all bi-infinite solutions in A , we call them full solutions .`
  FIX: `In particular, \( \text{Paths}_{\mathcal{V}}(B_s, B_e, A) \) contains all bounded solutions in \( A \) with the starting point in \( B_s \) and the end point in \( B_e \). On the other hand \( \text{iSol}_{\mathcal{V}}(A) \) consists of all bi-infinite solutions in \( A \), we call them full solutions.`

- RAW: `While useful, the above notion of a solution is not enough to capture the essential structure of a multivector field. Therefore, we distinguish another type of solutions, called essential . In particular, a full solution φ is called right-essential ( left-essential ) if for every t ∈ Z there exist s > t ( s < t ) such that [ φ ( t )] V ̸ = [ φ ( s )] V or [ φ ( s )] V is critical. A full solution φ is called essential if it is both rightand left-essential. In other words, a full solution is essential if it leaves every regular multivector it enters within a finite amount of steps—both in forward and backward time direction. Note that a regular multivector may still be visited an infinite number of times by a single essential solution. We denote the set of all essential solutions in A ⊂ X by eSol V ( A ), and the subset of essential solutions passing through x ∈ A by`
  FIX: `While useful, the above notion of a solution is not enough to capture the essential structure of a multivector field. Therefore, we distinguish another type of solutions, called essential. In particular, a full solution \( \varphi \) is called right-essential (left-essential) if for every \( t \in \mathbb{Z} \) there exist \( s > t \) (\( s < t \)) such that \( [\varphi(t)]_{\mathcal{V}} \neq [\varphi(s)]_{\mathcal{V}} \) or \( [\varphi(s)]_{\mathcal{V}} \) is critical. A full solution \( \varphi \) is called essential if it is both right- and left-essential. In other words, a full solution is essential if it leaves every regular multivector it enters within a finite amount of steps—both in forward and backward time direction. Note that a regular multivector may still be visited an infinite number of times by a single essential solution. We denote the set of all essential solutions in \( A \subset X \) by \( \text{eSol}_{\mathcal{V}}(A) \), and the subset of essential solutions passing through \( x \in A \) by`

- RAW: `We usually use ρ and γ for non-essential solutions and φ and ψ for essential solutions. To summarize, we have the following correspondence between the introduced families of solutions:`
  FIX: `We usually use \( \rho \) and \( \gamma \) for non-essential solutions and \( \varphi \) and \( \psi \) for essential solutions. To summarize, we have the following correspondence between the introduced families of solutions:`

- RAW: `Similarly to paths in a graph, given two solutions ρ, γ ∈ Sol V ( A ), right- and leftbounded, respectively, such that γ ⊏ ∈ F V ( ρ ⊐ ) we write ρ · γ for the new solution constructed as the concatenation 1 . Sometimes, for simplicity, we identify a point x ∈ X with the trivial solution ρ x : { 0 } → X , defined ρ x (0) := x . For instance, by x · y · z we mean the solution ρ := ρ x · ρ y · ρ z (under the assumption that y ∈ F V ( x ) and z ∈ F V ( y )), that is`
  FIX: `Similarly to paths in a graph, given two solutions \( \rho, \gamma \in \text{Sol}_{\mathcal{V}}(A) \), right- and left-bounded, respectively, such that \( \gamma^{\sqsubset} \in F_{\mathcal{V}}(\rho^{\sqsupset}) \) we write \( \rho \cdot \gamma \) for the new solution constructed as the concatenation 1. Sometimes, for simplicity, we identify a point \( x \in X \) with the trivial solution \( \rho_x : \{ 0 \} \to X \), defined \( \rho_x(0) \coloneqq x \). For instance, by \( x \cdot y \cdot z \) we mean the solution \( \rho \coloneqq \rho_x \cdot \rho_y \cdot \rho_z \) (under the assumption that \( y \in F_{\mathcal{V}}(x) \) and \( z \in F_{\mathcal{V}}(y) \)), that is`

## REPAIR_MATH
- RAW: ```
P a t h s _ { \nu } ( A ) \coloneqq \{ \rho \in S o l _ { \nu } ( A ) \, | \, \text {dom } \rho \text { is bounded} \} , \\ P a t h s _ { \nu } ( B _ { s } , B _ { e } , A ) \coloneqq \{ \rho \in P a t h s _ { \nu } ( A ) \, | \, \rho ^ { \sqsubset } \in B _ { s } \text { and } \rho ^ { \sqcup } \in B _ { e } \} , \\ i S o l _ { \nu } ( A ) \coloneqq \{ \rho \in S o l _ { \nu } ( A ) \, | \, \text {dom } \rho = \mathbb { Z } \} .
```
  FIX: ```
\[
\text{Paths}_{\mathcal{V}}(A) \coloneqq \{ \rho \in \text{Sol}_{\mathcal{V}}(A) \mid \text{dom } \rho \text{ is bounded} \} , \\
\text{Paths}_{\mathcal{V}}(B_s, B_e, A) \coloneqq \{ \rho \in \text{Paths}_{\mathcal{V}}(A) \mid \rho^{\sqsubset} \in B_s \text{ and } \rho^{\sqsupset} \in B_e \} , \\
\text{iSol}_{\mathcal{V}}(A) \coloneqq \{ \rho \in \text{Sol}_{\mathcal{V}}(A) \mid \text{dom } \rho = \mathbb{Z} \} .
\]
```
- RAW: ```
\ e S o l _ { \mathcal { V } } ( x , A ) \coloneqq \{ \varphi \in \text {eSol} _ { \mathcal { V } } ( A ) \ | \ \varphi ( 0 ) = x \} .
```
  FIX: ```
\[
\text{eSol}_{\mathcal{V}}(x, A) \coloneqq \{ \varphi \in \text{eSol}_{\mathcal{V}}(A) \mid \varphi(0) = x \} .
\]
```
- RAW: ```
\ e { \text {Sol} } _ { \nu } ( x , A ) \subset \ e { \text {Sol} } _ { \nu } ( A ) \subset \text {Isol} _ { \nu } ( A ) \subset \text {Sol} _ { \nu } ( A ) \supset \text {Paths} _ { \nu } ( A ) \supset \text {Paths} _ { \nu } ( x , y , A ) .
```
  FIX: ```
\[
\text{eSol}_{\mathcal{V}}(x, A) \subset \text{eSol}_{\mathcal{V}}(A) \subset \text{iSol}_{\mathcal{V}}(A) \subset \text{Sol}_{\mathcal{V}}(A) \supset \text{Paths}_{\mathcal{V}}(A) \supset \text{Paths}_{\mathcal{V}}(x, y, A) .
\]
```

