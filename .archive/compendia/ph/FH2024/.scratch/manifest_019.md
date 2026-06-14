# Manifest: Page 019

## REPAIR_PROSE
- RAW: ```
# Definition 4.6 (Shift functors) op
```
  FIX: ```
# Definition 4.6 (Shift functors)
```
- RAW: ```
# Definition 4.7 ( v -interleaving) op
```
  FIX: ```
# Definition 4.7 (\( v \)-interleaving)
```

## REPAIR_MATH
- RAW: ```
Let v = ( v 1 ,v 2 ,v 3 ) ∈ op × × be such that v 1 ≤ 0 and v 2 ,v 3 ≥ 0 .
```
  FIX: ```
Let \( v = ( v_1 ,v_2 ,v_3 ) \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \) be such that \( v_1 \leq 0 \) and \( v_2 ,v_3 \geq 0 \).
```
- RAW: ```
The v -shift functor ( − ) v : vec × × → vec op × × is defined as follows: 1. For F ∈ vec op × × , we define F v ∈ vec op × × in the following way: F v ( x ) = F ( x + v ) for all x ∈ op × × and F v ( x ≤ x ′ ) := F ( x + v ≤ x ′ + v ) for all x ≤ x ′ ∈ op × × and all structure maps.
```
  FIX: ```
The \( v \)-shift functor \( ( - ) ^ v : \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \to \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \) is defined as follows: 1. For \( F \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \), we define \( F ^ v \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \) in the following way: \( F ^ v ( x ) = F ( x + v ) \) for all \( x \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \) and \( F ^ v ( x \leq x ' ) := F ( x + v \leq x ' + v ) \) for all \( x \leq x ' \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \) and all structure maps.
```
- RAW: ```
2. Let F,G ∈ vec op × × . For any morphism η : F → G , the corresponding morphism η v : F v → G v is defined as η v ( x ) = η ( x + v ) : F v ( x ) → G v ( x ) for all x ∈ op × × .
```
  FIX: ```
2. Let \( F,G \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \). For any morphism \( \eta : F \to G \), the corresponding morphism \( \eta ^ v : F ^ v \to G ^ v \) is defined as \( \eta ^ v ( x ) = \eta ( x + v ) : F ^ v ( x ) \to G ^ v ( x ) \) for all \( x \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \).
```
- RAW: ```
We say that F,G ∈ vec × × are v -interleaved if there are natural transformations η : F → G v and ν : G → F v such that 2 v
```
  FIX: ```
We say that \( F,G \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \) are \( v \)-interleaved if there are natural transformations \( \eta : F \to G ^ v \) and \( \nu : G \to F ^ v \) such that
```
- RAW: ```
1 . \ \nu _ { v } \circ \eta = \psi _ { F } ^ { 2 v } ,
```
  FIX: ```
$$
1 . \ \nu _ { v } \circ \eta = \psi _ { F } ^ { 2 v } ,
$$
```
- RAW: ```
2 . \eta _ { v } \circ \nu = \psi _ { G } ^ { 2 v } ,
```
  FIX: ```
$$
2 . \eta _ { v } \circ \nu = \psi _ { G } ^ { 2 v } ,
$$
```
- RAW: ```
where ψ v F : F → F v denotes the natural transformation whose restriction to F ( x ) is the linear map F ( x ≤ x + v ) .
```
  FIX: ```
where \( \psi ^ v _ F : F \to F ^ v \) denotes the natural transformation whose restriction to \( F ( x ) \) is the linear map \( F ( x \leq x + v ) \).
```
- RAW: ```
# Definition 4.8 (Interleaving distance) Let ε = ε ( − 1 , 1 , 1) with ε ≥ 0 and let further F,G ∈ vec op × × . The interleaving distance between F and G is defined as
```
  FIX: ```
# Definition 4.8 (Interleaving distance) Let \( \varepsilon = \varepsilon ( - 1 , 1 , 1 ) \) with \( \varepsilon \geq 0 \) and let further \( F,G \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \). The interleaving distance between \( F \) and \( G \) is defined as
```
- RAW: ```
d _ { I } ( F , G ) \coloneqq \inf \{ \varepsilon \geq 0 \, \colon \, F , G \ a r e \ \varepsilon { \text {-intralevel} } \}
```
  FIX: ```
$$
d _ { I } ( F , G ) \coloneqq \inf \{ \varepsilon \geq 0 \, \colon \, F , G \ a r e \ \varepsilon { \text {-intralevel} } \}
$$
```
- RAW: ```
and as d I ( F,G ) = ∞ if there is no ε -interleaving.
```
  FIX: ```
and as \( d _ I ( F,G ) = \infty \) if there is no \( \varepsilon \)-interleaving.
```
- RAW: ```
For extended zigzag modules M,N we define the interleaving distance as
```
  FIX: ```
For extended zigzag modules \( M,N \) we define the interleaving distance as
```
- RAW: ```
d _ { I } ( M , N ) \colon = d _ { I } ( \mathcal { E } ( M ) , \mathcal { E } ( N ) ) .
```
  FIX: ```
$$
d _ { I } ( M , N ) \colon = d _ { I } ( \mathcal { E } ( M ) , \mathcal { E } ( N ) ) .
$$
```
- RAW: ```
Let M,N be extended zigzag modules. It holds
```
  FIX: ```
Let \( M,N \) be extended zigzag modules. It holds
```
- RAW: ```
d _ { \lambda } ^ { \infty } ( M , N ) \leq d _ { I } ( M , N ) .
```
  FIX: ```
$$
d _ { \lambda } ^ { \infty } ( M , N ) \leq d _ { I } ( M , N ) .
$$
```
- RAW: ```
Proof: Assume that M,N are ε -interleaved. Let ( x,z ) ∈ ZZ × . Without loss of generality let r = λ k ( M )( x,z ) ≥ λ k ( N )( x,z ) and let λ k ( M )( x,z ) ≥ ε . Since M,N are ε -interleaved we obtain the commutative diagram
```
  FIX: ```
Proof: Assume that \( M,N \) are \( \varepsilon \)-interleaved. Let \( ( x,z ) \in \mathbb{Z} \times \mathbb{Z} \). Without loss of generality let \( r = \lambda _ k ( M ) ( x,z ) \geq \lambda _ k ( N ) ( x,z ) \) and let \( \lambda _ k ( M ) ( x,z ) \geq \varepsilon \). Since \( M,N \) are \( \varepsilon \)-interleaved we obtain the commutative diagram
```
- RAW: ```
\mathcal { E } ( M ) ( x + r , x - r , z - r ) \longrightarrow \mathcal { E } ( M ) ( x - r , x + r , z + r ) \\ \downarrow & & \uparrow \\ \mathcal { E } ( N ) ( x + h , x - h , z - h ) \longrightarrow \mathcal { E } ( N ) ( x - h , x + h , z + h )
```
  FIX: ```
$$
\mathcal { E } ( M ) ( x + r , x - r , z - r ) \longrightarrow \mathcal { E } ( M ) ( x - r , x + r , z + r ) \\ \downarrow & & \uparrow \\ \mathcal { E } ( N ) ( x + h , x - h , z - h ) \longrightarrow \mathcal { E } ( N ) ( x - h , x + h , z + h )
$$
```
- RAW: ```
)
```
  FIX: ```
$$
)
$$
```

