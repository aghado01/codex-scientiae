[Page 19]

The following definitions are standard in the theory of multiparameter persistent homology and are adapted to our setting. Let \( v = ( v_1 ,v_2 ,v_3 $$
$$
)
$$
$$ \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \) be such that \( v_1 \leq 0 \) and \( v_2 ,v_3 \geq 0 \).

# Definition 4.6 (Shift functors)

The \( v \)-shift functor \( ( - ) ^ v : \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \to \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \) is defined as follows: 1. For \( F \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \), we define \( F ^ v \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \) in the following way: \( F ^ v ( x ) = F ( x + v ) \) for all \( x \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \) and \( F ^ v ( x \leq x ' ) := F ( x + v \leq x ' + v ) \) for all \( x \leq x ' \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \) and all structure maps.

2. Let \( F,G \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \). For any morphism \( \eta : F \to G \), the corresponding morphism \( \eta ^ v : F ^ v \to G ^ v \) is defined as \( \eta ^ v ( x ) = \eta ( x + v ) : F ^ v ( x ) \to G ^ v ( x ) \) for all \( x \in \mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R} \).

# Definition 4.7 (\( v \)-interleaving)

We say that \( F,G \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \) are \( v \)-interleaved if there are natural transformations \( \eta : F \to G ^ v \) and \( \nu : G \to F ^ v \) such that

$$
1 . \ \nu _ { v } \circ \eta = \psi _ { F } ^ { 2 v } ,
$$

$$
2 . \eta _ { v } \circ \nu = \psi _ { G } ^ { 2 v } ,
$$

where \( \psi ^ v _ F : F \to F ^ v \) denotes the natural transformation whose restriction to \( F ( x ) \) is the linear map \( F ( x \leq x + v ) \).

Finally, we can define the interleaving distance for extended zigzag modules.

# Definition 4.8 (Interleaving distance) Let \( \varepsilon = \varepsilon ( - 1 , 1 , 1 ) \) with \( \varepsilon \geq 0 \) and let further \( F,G \in \mathbf{vec}^{\mathbb{R}^{\mathrm{op}} \times \mathbb{R} \times \mathbb{R}} \). The interleaving distance between \( F \) and \( G \) is defined as

$$
d _ { I } ( F , G ) \coloneqq \inf \{ \varepsilon \geq 0 \, \colon \, F , G \ a r e \ \varepsilon { \text {-intralevel} } \}
$$

and as \( d _ I ( F,G ) = \infty \) if there is no \( \varepsilon \)-interleaving.

For extended zigzag modules \( M,N \) we define the interleaving distance as

$$
d _ { I } ( M , N ) \colon = d _ { I } ( \mathcal { E } ( M ) , \mathcal { E } ( N ) ) .
$$

Having the necessary definitions, we state the main result of this section.

# Theorem 4.9

(Stability of spatiotemporal persistence landscapes)

Let \( M,N \) be extended zigzag modules. It holds

$$
d _ { \lambda } ^ { \infty } ( M , N ) \leq d _ { I } ( M , N ) .
$$

Proof: Assume that \( M,N \) are \( \varepsilon \)-interleaved. Let \( ( x,z ) \in \mathbb{Z} \times \mathbb{Z} \). Without loss of generality let \( r = \lambda _ k ( M ) ( x,z ) \geq \lambda _ k ( N ) ( x,z ) \) and let \( \lambda _ k ( M ) ( x,z ) \geq \varepsilon \). Since \( M,N \) are \( \varepsilon \)-interleaved we obtain the commutative diagram

$$
\mathcal { E } ( M ) ( x + r , x - r , z - r ) \longrightarrow \mathcal { E } ( M ) ( x - r , x + r , z + r ) \\ \downarrow & & \uparrow \\ \mathcal { E } ( N ) ( x + h , x - h , z - h ) \longrightarrow \mathcal { E } ( N ) ( x - h , x + h , z + h )
$$

$$
)
$$
