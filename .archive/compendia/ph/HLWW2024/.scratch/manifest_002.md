# Manifest: Page 002

## REPLACE_TABLES
*(No tables found on this page)*

## REPAIR_MATH
- RAW: ```
SP (


(

)


(

)

SN (


(

)


(

)
```
  FIX: ```
\[
\begin{CD}
\Omega^{SP}(X) @>>> L^{vs}(X) \\
@VVV @VVV \\
\Omega^{SN}(X) @>>> X \otimes MSG
\end{CD}
\]
```

## REPAIR_PROSE
- RAW: `in case X is represented by a ﬁnite simplicial complex and [CDH + 23, Variant 4.4.15] for a general treatment. Here ( D ( Z ) /X ) f denotes the full subcategory of the compact objects ( D ( Z ) /X ) ω of D ( Z ) /X on ﬁnite objects, i.e. those whose K -theory class lies in the image of K 0 ( Z ) → K 0 ( Z π 1 ( X )) ∼ = K 0 (( D ( Z ) /X ) ω ) and ǫ denotes the trivial rank 0 spherical ﬁbration over X to align with notation from [CDH + 23, CDH + 20a]. The visible L-spectra are functorial in X ; for a map f : X → Y we write f ! : L vr ( X ) → L vr ( Y ) for the induced map. We also have Ϙ vq ǫ = Ϙ q ǫ , so that visible quadratic Ltheory is simply quadratic L-theory. Moreover, the algebraic π π -theorem says that for X connected, the map X → Bπ 1 ( X ) induces an isomorphism in visible quadratic L-theory, see [Ran92, Section 10] and [CDH + 20b, Corollary 1.2.33]. The coﬁbre of the map L vq ( X ) → L vs ( X ) is denoted L vn ( X ) and called the visible normal L-theory of X . In classical terminology, the choice of working with ﬁnite objects corresponds to choosing decoration "h" for the L-spectra. vq q vs s vn n`
  FIX: `in case \( X \) is represented by a finite simplicial complex and [CDH+23, Variant 4.4.15] for a general treatment. Here \( (\mathcal{D}(\mathbb{Z})/X)^f \) denotes the full subcategory of the compact objects \( (\mathcal{D}(\mathbb{Z})/X)^\omega \) of \( \mathcal{D}(\mathbb{Z})/X \) on finite objects, i.e. those whose \( K \)-theory class lies in the image of \( K_0(\mathbb{Z}) \to K_0(\mathbb{Z}[\pi_1(X)]) \cong K_0((\mathcal{D}(\mathbb{Z})/X)^\omega) \) and \( \epsilon \) denotes the trivial rank 0 spherical fibration over \( X \) to align with notation from [CDH+23, CDH+20a]. The visible \( L \)-spectra are functorial in \( X \); for a map \( f : X \to Y \) we write \( f_! : L^{vr}(X) \to L^{vr}(Y) \) for the induced map. We also have \( \Qoppa^{vq}_\epsilon = \Qoppa^q_\epsilon \), so that visible quadratic \( L \)-theory is simply quadratic \( L \)-theory. Moreover, the algebraic \( \pi\text{-}\pi \)-theorem says that for \( X \) connected, the map \( X \to B\pi_1(X) \) induces an isomorphism in visible quadratic \( L \)-theory, see [Ran92, Section 10] and [CDH+20b, Corollary 1.2.33]. The cofibre of the map \( L^{vq}(X) \to L^{vs}(X) \) is denoted \( L^{vn}(X) \) and called the visible normal \( L \)-theory of \( X \). In classical terminology, the choice of working with finite objects corresponds to choosing decoration "h" for the \( L \)-spectra.`

- RAW: `- (ii) We have L ( ∗ ) = L ( Z ), L ( ∗ ) = L ( Z ), and L ( ∗ ) = L ( Z ), the usual quadratic, symmetric, and normal L-theory spectrum of the integers, the latter two of which are ring spectra. In fact, they are E ∞ -ring spectra, but this will not matter for the purposes of this paper. From L n 0 ( Z ) ∼ = Z / 8 Z we see that L n ( Z )[ 1 2 ] = 0 so that the map L q ( Z )[ 1 2 ] → L s ( Z )[ 1 2 ] is an equivalence. Note also that L q ( Z ) does not refer to the qth symmetric L-group as it would in Ranicki's notation.`
  FIX: `- (ii) We have \( L^{vq}(*) = L^q(\mathbb{Z}) \), \( L^{vs}(*) = L^s(\mathbb{Z}) \), and \( L^{vn}(*) = L^n(\mathbb{Z}) \), the usual quadratic, symmetric, and normal \( L \)-theory spectrum of the integers, the latter two of which are ring spectra. In fact, they are \( E_\infty \)-ring spectra, but this will not matter for the purposes of this paper. From \( L^n_0(\mathbb{Z}) \cong \mathbb{Z}/8\mathbb{Z} \) we see that \( L^n(\mathbb{Z})[1/2] = 0 \) so that the map \( L^q(\mathbb{Z})[1/2] \to L^s(\mathbb{Z})[1/2] \) is an equivalence. Note also that \( L^q(\mathbb{Z}) \) does not refer to the \( q \)-th symmetric \( L \)-group as it would in Ranicki's notation.`

- RAW: `- (iii) When P is an oriented Poincare´ complex of dimension d , there is a canonical point σ vs ( P ) in Ω d L vs ( P ), called the visible symmetric signature of P , see [Ran92, Example 9.13] and [CDH + 23, Corollary 4.4.20]. Its image σ vn ( P ) in Ω d L vn ( P ) is called the visible normal signature of P . These data ﬁt into the following commutative square whose left vertical arrow is the canonical forgetful map between oriented Poincare´ bordism and oriented normal bordism [Ran79].`
  FIX: `- (iii) When \( P \) is an oriented Poincaré complex of dimension \( d \), there is a canonical point \( \sigma^{vs}(P) \) in \( \Omega^d L^{vs}(P) \), called the visible symmetric signature of \( P \), see [Ran92, Example 9.13] and [CDH+23, Corollary 4.4.20]. Its image \( \sigma^{vn}(P) \) in \( \Omega^d L^{vn}(P) \) is called the visible normal signature of \( P \). These data fit into the following commutative square whose left vertical arrow is the canonical forgetful map between oriented Poincaré bordism and oriented normal bordism [Ran79].`

- RAW: `The upper horizontal map takes the (Poincare´ bordism class of a) map f : P → X to f ! ( σ vs ( P )). In particular σ vs ( P ) is the image of [id P ] in Ω SP n ( P ), see [Ran92, Section 19]. Oriented normal bordism satisﬁes excision giving an equivalence Ω SN ( X ) ≃ X ⊗ MSG, and the lower horizontal arrow for X = ∗ is called Ranicki's normal orientation , while the top horizontal arrow is often referred to as the Sullivan–Ranicki orientation .`
  FIX: `The upper horizontal map takes the (Poincaré bordism class of a) map \( f : P \to X \) to \( f_!(\sigma^{vs}(P)) \). In particular \( \sigma^{vs}(P) \) is the image of \( [\mathrm{id}_P] \) in \( \Omega^{SP}_n(P) \), see [Ran92, Section 19]. Oriented normal bordism satisfies excision giving an equivalence \( \Omega^{SN}(X) \simeq X \otimes MSG \), and the lower horizontal arrow for \( X = * \) is called Ranicki's normal orientation, while the top horizontal arrow is often referred to as the Sullivan–Ranicki orientation.`

- RAW: `- (iv) For an oriented closed topological manifold M , we may view [id M ] as an element of Ω STop n ( M ), the oriented bordism of topological manifolds. By topological transversality [KS77], Ω STop ( X ) is equivalent to X ⊗ MSTop for any space X , showing that σ vs ( M ) canonically lifts along the assembly map M ⊗ L s ( Z ) → L vs ( M ) in this case.`
  FIX: `- (iv) For an oriented closed topological manifold \( M \), we may view \( [\mathrm{id}_M] \) as an element of \( \Omega^{STop}_n(M) \), the oriented bordism of topological manifolds. By topological transversality [KS77], \( \Omega^{STop}(X) \) is equivalent to \( X \otimes MSTop \) for any space \( X \), showing that \( \sigma^{vs}(M) \) canonically lifts along the assembly map \( M \otimes L^s(\mathbb{Z}) \to L^{vs}(M) \) in this case.`

- RAW: `- (v) To better incorporate the orientation behaviour of the above elements, one considers L n 1 / 2 ( Z ) = Z × Z / 8 Z τ ≥ 0 L n ( Z ), the 1/2-connective normal L-theory . We then obtain canonical maps MSG → L n 1 / 2 ( Z ) as well as τ ≥ 0 L s ( Z ) → L n 1 / 2 ( Z ) lifting the normal orientation MSG → L n ( Z ) and the canonical projection L s ( Z ) → L n ( Z ).`
  FIX: `- (v) To better incorporate the orientation behaviour of the above elements, one considers \( L^n_{1/2}(\mathbb{Z}) = \mathbb{Z} \times_{\mathbb{Z}/8\mathbb{Z}} \tau_{\geq 0} L^n(\mathbb{Z}) \), the 1/2-connective normal \( L \)-theory. We then obtain canonical maps \( MSG \to L^n_{1/2}(\mathbb{Z}) \) as well as \( \tau_{\geq 0} L^s(\mathbb{Z}) \to L^n_{1/2}(\mathbb{Z}) \) lifting the normal orientation \( MSG \to L^n(\mathbb{Z}) \) and the canonical projection \( L^s(\mathbb{Z}) \to L^n(\mathbb{Z}) \).`

## DELETE
- RAW: ` vq q vs s vn n`
  FIX: ``
