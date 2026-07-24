<a id="ch-5"></a>

# 5. Phase Transition

## Table of Contents

- [The critical point](#sec-5-5-1)
- [Percolation probabilities](#sec-5-5-2)
- [Uniqueness of random-cluster measures](#sec-5-5-3)
- [The subcritical phase](#sec-5-5-4)
- [Exponential decay of volume](#sec-5-5-6)
- [The supercritical phase and the Wulff crystal](#sec-5-5-7)
- [Uniqueness when $q$ < 1](#sec-5-5-8)


Summary. When q ∈ [1, ∞), there exists a critical value pc(q) of the edgeparameter p, separating the phase with no infinite cluster from the phase with one or more infinite clusters. Partial results are known for both phases, but important open problems remain. In the subcritical phase, exponential decay is proved for sufficiently small p, and is conjectured to hold for all $p$ < pc(q). Much is known for the supercritical phase subject to the assumption that p exceeds a certain ‘slab critical point’ pc(q), conjectured to equal pc(q). The Wulff construction is a high point of the theory of the random-cluster model.

<a id="sec-5-1"></a>

## 5.1 The critical point

The random-cluster model possesses an infinite open cluster if and only if $p$ is sufficiently large. There is a critical value of $p$ separating the regime in which all open clusters are finite from that in which infinite clusters exist. We explore this phasetransitioninthischapter. WiththeexceptionofthefinalSection5.8,weshall assume for the entirety of the chapter that q ∈ [1,∞), and we shall concentrate on the extremal random-cluster measures φp0,q and φp1,q. The quantities of principal interest are the φpb,q-percolation-probabilities,

(5.1) θb(p,q) = φpb,q(0 ↔ ∞), b = 0,1. We define the critical points (5.2) pcb(q) = sup p : θb(p,q) = 0 , b = 0,1. By Proposition 4.28(a), the θb(·,q) are non-decreasing functions, and therefore (5.3) θb(p,q) = 0 if $p$ < pcb(q),

> 0 if $p$ > pcb(q).

By Theorem 4.63, φp0,$q$ = φp1,q for almost every p ∈ [0,1]. Therefore,

θ0(p,q) = θ1(p,q) for almost every p, and hence pc0(q) = pc1(q). Henceforth, we use the abbreviated notation

(5.4) pc(q) = pc0(q) = pc1(q), and we refer to pc(q) as the critical point of the random-cluster model.

It is almost trivial to prove that pc(q) = 1 in the very special case when the number d of dimensions satisfies d = 1. In contrast, it is fundamental that 0 < pc(q) < 1 when d ≥ 2. Not a great deal is known in general1 about the way in which pc(q) behaves when viewed as a function of q. The following basic inequalities are consequences of the comparison inequalities of Proposition 4.28.

- (5.5) Theorem [8]. We have that
- (5.6)

![image 396](../Images/imageFile396.png)

![image 397](../Images/imageFile397.png)

![image 398](../Images/imageFile398.png)

![image 399](../Images/imageFile399.png)

![image 400](../Images/imageFile400.png)

![image 401](../Images/imageFile401.png)

Since 0 < pc(1) < 1 for d ≥ 2, [154, Thm 1.10], we deduce the important fact that

(5.9) 0 < pc(q) < 1, q ≥ 1.

By (5.7), pc(q) is a continuous non-decreasing function of q. Strict monotonicity2 requires the further comparison inequality of Theorem 3.24.

(5.10) Theorem [151]. Let d ≥ 2. When viewed as a function of q, the critical value pc(q) is Lipschitz-continuousand strictly increasing on the interval [1,∞).

In advance of proving Theorems 5.5 and 5.10, we state and prove two facts of independent interest.

![image 402](../Images/imageFile402.png)

1Except for its behaviour for large q, see Theorem 7.34. 2The strict monotonicity of pc(q) as a function of the underlying lattice was proved in [39],

see also [148].

100 Phase Transition [5.1]

(5.11) Proposition [8]. For p ∈ [0,1] and $q$ ∈ [1,∞),

φ ,1 p,q(0 ↔ ∂ ) → θ1(p,q) as ↑ Zd.

There is no ‘elementary’ proof of the corresponding fact for the 0-boundarycondition measure φ ,0 p,q, and indeed this is unproven for general pairs (p,q).

(5.12) Proposition. Let φ , ⊆ Zd, be probability measures on ($\Omega, \mathcal{F}$) indexed by boxes and satisfying φ ⇒ φ as ↑ Zd. If φ has the 0/1-infinite-cluster property, then

φ (x ↔ y) → φ(x ↔ y), x, y ∈ Zd.

Proof of Proposition 5.11. It is clear that

φp1,q(0 ↔ ∂ ) ≤ φ ,1 p,q(0 ↔ ∂ ) ≤ φ ,1 p,q(0 ↔ ∂ ) for ⊆ ,

by positive association and the fact that {0 ↔ ∂ } ⊆ {0 ↔ ∂ } when ⊆ . We take the limits as ↑ Zd and ↑ Zd in that order to obtain the claim.

![image 403](../Images/imageFile403.png)

![image 404](../Images/imageFile404.png)

![image 405](../Images/imageFile405.png)

![image 406](../Images/imageFile406.png)

![image 407](../Images/imageFile407.png)

1 4q′

, 1 ≤ q′ < q,

![image 408](../Images/imageFile408.png)

whence pc(q) is Lipschitz-continuous on the interval [1,∞). Turning to strict monotonicity, let γ be given as in Theorem 3.24 with = 2d, and let 1 ≤ q2 < q1. Recall that γ(p,q) is continuous, and is strictly increasing in p and strictly decreasing in q. We apply Theorem 3.24 to the graph obtained from

by identifying all vertices of ∂ , with spanning set W = \ ∂ satisfying deg(W) = 2d, to obtain that

φ ,1 p1,q1(0 ↔ ∂ ) ≤ φ ,1 p2,q2(0 ↔ ∂ ) if γ(p1,q1) ≤ γ(p2,q2).

Let ↑ Zd and deduce by Proposition 5.11 that

(5.14) θ1(p1,q1) ≤ θ1(p2,q2) if γ(p1,q1) ≤ γ(p2,q2).

We claim that

(5.15) γ(pc(q1),q1) ≥ γ(pc(q2),q2).

Suppose on the contrary that γ(pc(q1),q1) < γ(pc(q2),q2). By the continuity of γ, there exist p1 > pc(q1) and p2 < pc(q2) such that γ(p1,q1) < γ(p2,q2). By (5.14),

θ1(p1,q1) ≤ θ1(p2,q2).

However, θ1(p1,q1) > 0 and θ1(p2,q2) = 0, a contradiction, and thus (5.15) holds. If pc(q1) = pc(q2), then the strict monotonicity of γ(·,·) and the fact that q2 < q1 are in contradiction of (5.15). Therefore pc(q2) < pc(q1) as claimed.

<a id="sec-5-2"></a>

## 5.2 Percolation probabilities

The continuityofthe percolationprobabilitiesθb(p,q)is relatedtothe uniqueness of random-cluster measures, in the sense that the θb(·,q) are continuous at p if and only if there is a unique random-cluster measure at this value.

(5.16) Theorem. Let d ≥ 2 and $q$ ∈ [1,∞). (a) The function θ0(·,q) is left-continuous on (0,1] \ {pc(q)}. (b) The function θ1(·,q) is right-continuous on [0,1). (c) θ0(p,q) = θ1(p,q) if and only if $p$ ∈/ Dq, where Dq is that of Theorem

4.63. (d) Let $p$ = pc(q). The functions θ0(·,q) and θ1(·,q) are continuous at the point p if and only if $p$ ∈/ Dq.

Clearly, θ0(p,q) = θ1(p,q) = 0 if $q$ ∈ [1,∞) and $p$ < pc(q), and hence Dq∩[0, pc(q)) = ∅, bypart(c). Itispresumablythecasethatθ0(·,q)andθ1(·,q) are continuous except possibly at $p$ = pc(q). In addition it may be conjectured that θ0(·,q) is left-continuous on the entire interval (0,1]. A verification of this conjecture would include a proof that

θ0(pc(q),q) = lim

θ0(p,q) = 0.

p↑pc(q)

This would in particular solve one of the famous open problems of percolation theory, namely to show that θ(pc(1),1) = 0, see [154, 161].

The functions θ0(p,q) and θ1(p,q) play, respectively, the roles of the magnetizations for Potts measures with free and constant-spin boundary conditions. We state this more fully as a theorem. As in Section 1.3, we write σu for the spin at vertex u of a Potts model with q local states (where $q$ is now assumed to be integral). We denote by πβ,q (respectively, πβ,1 q) the ‘free’ (respectively, ‘1’) q-state Potts measure on Ld with parameter β, see (4.89)–(4.90).

(5.17) Theorem. Let d ≥ 2, p ∈ (0,1), q ∈ {2,3,. . .}, and let β satisfy $p$ = 1 − e−β. We have that:

|u|→∞ (5.18) πβ,q(σ0 = σu) − q−1 , (5.19) (1 − q−1)θ1(p,q) = πβ,1 q(σ0 = 1) − q−1.

(1 − q−1)θ0(p,q)2 = lim

Equation (5.19) is standard (see [8, 108, 150]). Equation (5.18) is valid also

with θ0(p,q) and πβ,q replaced, respectively, by θ1(p,q) and πβ,1 q, and the proof is similar.

Proof of Theorem 5.16. We shall prove part (a) at the end of Section 8.8. Part (b) is a consequence of Proposition 4.28(b) applied to the indicator function of the increasingclosedevent{0 ↔ ∞}. Part(d)followsfrom(a)–(c)andTheorem4.63,

on noting that the θb(·,q) are non-decreasing. It remains to prove (c). Certainly φp0,$q$ = φp1,q if $p$ ∈/ Dq (by Theorem 4.63), whence θ0(p,q) = θ1(p,q) for $p$ ∈/ Dq. Suppose conversely that $q$ > 1 and

(5.20) θ0(p,q) = θ1(p,q). We shall now give the main steps in a proof that (5.21) h0(p,q) = h1(p,q). This will imply by Theorem 4.63 that p ∈/ Dq.

Let e = u,v be an edge, and Je the event that e is open. For w ∈ Zd, let Iw = {w ↔ ∞}, and let Hw be the event that w is in an infinite open path of Ed \ {e}. As in the proof of Proposition 4.6, there exists a probability measure ψ

on ($\Omega, \mathcal{F}$)2 with marginals φp0,q and φp1,q, and assigning probability 1 to the set of pairs (ω0,ω1) ∈ 2 satisfying ω0 ≤ ω1. Let F(ω) be the set of vertices that are joined to infinity by open paths of the configuration ω ∈ . We have that

φp1,q(Iw) − φp0,q(Iw) = 0, by (5.20). The event Je ∩ Iu ∩ Iv is increasing, whence (5.23) φp0,q(Je ∩ Iu ∩ Iv) ≤ φp1,q(Je ∩ Iu ∩ Iv). Also, (5.24) φp0,q(Je ∩ Iu ∩ Iv) = φp0,q(Je ∩ Hu ∩ Hv)

(5.22) 0 ≤ ψ F(ω0) = F(ω1) ≤

w∈Zd

![image 409](../Images/imageFile409.png)

![image 410](../Images/imageFile410.png)

= φp0,q(Je | Hu ∩ Hv)φp0,q(Hu ∩ Hv). However,

![image 411](../Images/imageFile411.png)

φp0,q(Je | Hu ∩ Hv) = φp1,q(Je | Hu ∩ Hv)

![image 412](../Images/imageFile412.png)

![image 413](../Images/imageFile413.png)

by Proposition 4.37(a) and the fact (Theorem 4.34) that φp0,q,φp1,q ∈ Rp,q. In addition, φp0,q(Hu ∩ Hv) ≤ φp1,q(Hu ∩ Hv) since Hu ∩ Hv is an increasing event. Therefore (5.24) implies that

(5.25) φp0,q(Je ∩ Iu ∩ Iv) ≤ φp1,q(Je | Hu ∩ Hv)φp1,q(Hu ∩ Hv)

![image 414](../Images/imageFile414.png)

![image 415](../Images/imageFile415.png)

= φp1,q(Je ∩ Hu ∩ Hv) = φp1,q(Je ∩ Iu ∩ Iv). Adding (5.23) and (5.25), we obtain that

![image 416](../Images/imageFile416.png)

![image 417](../Images/imageFile417.png)

φp0,q(Iu ∩ Iv) ≤ φp1,q(Iu ∩ Iv).

Equality holds here by (5.22), and therefore equality holds in (5.23), which is to say that

(5.26) φp0,q(Je ∩ Iu ∩ Iv) = φp1,q(Je ∩ Iu ∩ Iv).

It is obvious that

(5.27) φp0,q(Je ∩ Iu ∩ Iv) = φp1,q(Je ∩ Iu ∩ Iv)

![image 418](../Images/imageFile418.png)

![image 419](../Images/imageFile419.png)

since both sides equal 0; the same equation holds with Iu ∩ Iv replaced by Iu ∩ Iv. Finally, we prove that

![image 420](../Images/imageFile420.png)

![image 421](../Images/imageFile421.png)

(5.28) φp0,q(Je ∩ Iu ∩ Iv) = φp1,q(Je ∩ Iu ∩ Iv)

![image 422](../Images/imageFile422.png)

![image 423](../Images/imageFile423.png)

![image 424](../Images/imageFile424.png)

![image 425](../Images/imageFile425.png)

which, in conjunction with (5.26), (5.27), and the subsequent remark, implies the required (5.21) by addition. Let ǫ > 0. Let be a box containing u and v, and let A = {u ↔/ ∂ , v ↔/ ∂ }. We have that

0 ≤ φp0,q(A ) − φp1,q(A )

→ φp0,q(Iu ∩ Iv) − φp1,q(Iu ∩ Iv) as ↑ Zd ≤ ψ F(ω0) = F(ω1) = 0,

![image 426](../Images/imageFile426.png)

![image 427](../Images/imageFile427.png)

![image 428](../Images/imageFile428.png)

![image 429](../Images/imageFile429.png)

by (5.22). Therefore,

0 ≤ φp0,q(A ) − φp1,q(A ) < ǫ for all large ,

and we pick accordingly. The events {u ↔/ ∂ } and {v ↔/ ∂ } are cylinder events, whence

(5.29) 0 ≤ φ ,0 p,q(A ) − φ ,1 p,q(A ) < 2ǫ for all large ,

and we pick ⊇ accordingly. We now employ a certain coupling of φ ,0 p,q and φ ,1 p,q. Similar couplings will be encountered later.

(5.30) Proposition. Let p ∈ (0,1) and $q$ ∈ [1,∞), and let , be finite boxes of Zd satisfying ⊆ . For ω ∈ , let G = G(ω) = {x ∈ : x ↔/ ∂ }. There exists a probability measure ψ on 0 × 1 , with marginals φ ,0 p,q and φ ,1 p,q, that assigns probability 1 to pairs (ω0,ω1) satisfying ω0 ≤ ω1, and with the additional property that, conditional on the set G = G(ω1), both marginals of ψ on EG equal the free random-cluster measure φG,p,q.

Writing G for the class of all subsets of that contain both u and v, we have by the proposition that

φ ,1 p,q(Je, G = g) =

φ ,1 p,q(Je ∩ A ) =

ψ ω1 ∈ Je, G(ω1) = g

g∈G

g∈G

ψ ω1 ∈ Je G(ω1) = g ψ (G(ω1) = g)

=

g∈G

ψ ω0 ∈ Je G(ω1) = g ψ (G(ω1) = g)

=

g∈G

= ψ (ω0 ∈ Je, ω1 ∈ A ) ≤ ψ (ω0 ∈ Je, ω0 ∈ A ) = φ ,0 p,q(Je ∩ A ).

Therefore,

0 ≤ φ ,0 p,q(Je ∩ A ) − φ ,1 p,q(Je ∩ A ) = ψ (ω0 ∈ Je, ω0 ∈ A , ω1 ∈/ A ) ≤ ψ (ω0 ∈ A , ω1 ∈/ A ) ≤ 2ǫ,

by (5.29). Let ↑ Zd, ↑ Zd, and ǫ ↓ 0 in that order, to obtain (5.28).

Proof of Proposition 5.30. Let φb = φ ,b p,q. Since φ0 ≤st φ1, there exists a coupled probability measure on 0 × 1 with marginals φ0, φ1, and that allocates probability 1 to the set of pairs (ω0,ω1) with ω0 ≤ ω1. This fact is immediate from the stochastic ordering, but we require in addition the special property stated in the proposition, and to this end we shall develop a special coupling not dissimilar to those used in [38] and [259, p. 254]. We do this by building a random configuration (ω0,ω1) ∈ 0 × 1 in a sequential manner, and we shall speak of ω0 (respectively, ω1) as the lower (respectively, upper) configuration. We shall proceed edge by edge, and shall check the (conditional) stochastic ordering at each stage.

After stage n we will have found the (paired) states of edges belonging to some subset Sn of E . We begin with S0 = ∅, and we build inwards starting at the boundary of . Let (el : l = 1,2,. . ., L) be a deterministic ordering of the edges in E . Let ej1 be the earliest edge in this ordering that is incident to some vertex in ∂ , and let

I0b = {every edge outside E has state b}, b = 0,1. By the usual stochastic ordering, (5.31) φ0(ej1 is open | I00) ≤ φ1(ej1 is open | I01). Therefore,we may find {0,1}-valuedrandomvariables ω0(ej1), ω1(ej1) with mean values as in (5.31) and satisfying ω0(ej1) ≤ ω1(ej1). We set S1 = {ej1} and

I1b = I0b ∩ {ej1 has state ωb(ej1)}, b = 0,1.

We iterate this process. After stage r, we will have gathered the information Ir0 (respectively, Ir1) relevant to the lower (respectively, upper) process, and we will proceed to consider the state of some further edge ejr+1. The analogue of (5.31), namely

φ0(ejr+1 is open | Ir0) ≤ φ1(ejr+1 is open | Ir1),

is valid since, by construction, ω0(ejs) ≤ ω1(ejs) for s = 1,2,. . .,r. Thus we may pick a pair of random states ω0(ejr+1), ω1(ejr+1) for the new edge, these having the correct marginals and satisfying ω0(ejr+1) ≤ ω1(ejr+1).

Next is described how we choose the edges ej2,ej3,. . .. Suppose the first r stages of the above process are complete, and write Sr = {ejs : s = 1,2,. . .,r}. Let Kr be the set of vertices x ∈ such that there exists a path π joining x to some z ∈ ∂ , with the property that ω1(e) = 1 for all e ∈ π. (This requires that every edge e in π has been considered in the first r stages, and that the ω1-value of each such e was found to be 1.) We let ejr+1 be the earliest edge in the given ordering of E that does not belong to Sr but possesses an endvertex in Kr.

Let us call a temporary halt at the stage when no new edge can be found. At this stage, R say, we have revealed the states of edges in a certain (random) set SR. Let FR be the set of edges in E that are closed in the upper configuration. By construction, FR contains exactly those edges of E that have at least one endvertex in KR and that have been determined to be closed in the upper configuration. By the ordering, the edges in FR are closed in the lower configurationalso. By construction, the lower (respectively, upper) configuration so far revealed is governed by the measure φ0 (respectively, φ1).

Suppose for the moment that = , in which case G(ω1) = \ KR. When extending the upper and lower configurations to edges in EG, the only relevant informationgathered to date is that all edges in the edge-boundary eG are closed in both configurations. We may therefore complete ω0, ω1 at one stroke by taking them to be equal, with (common) law φG0 ,p,q. This proves the proposition in the special case when = . Consider now the general case ⊆ .

We explainnexthowto re-startthe processat stage R. We beganabovewith the ‘seed’ ∂ and we built a set of edges connected to ∂ by paths of open edges in the upper configuration, together with its closed edge-boundary. Having reached stage R, we choose a vertex x ∈ satisfying x ∈/ KR ∪ ( \ ∂ ) that is incident to some edge of FR. We then re-start the process with x as seed, and we continue until we have revealed the open cluster Cx(ω1) at x in the upper configuration. We add the vertex-set of Cx(ω1) to KR to obtain a larger set K′. To FR, we add all edges incident to vertices in this cluster that are closed in the upper configuration, obtaining thus a larger set F′. Next, we find another seed y ∈/ K′ ∪ ( \ ∂ ) incident to some edge in F′. This process is iterated until no new seed may be found.

At the end of all this, we have revealed the paired states of all edges in some set S. Let T be the union of the vertex-sets of the open clusters of all seeds. Since no further seed may be found, it is the case that G(ω1) = \ T. As before, the

lower and upper configurations may be completed at one stroke by sampling the states of edges in EG according to the free measure φG,p,q.

Proof of Theorem 5.17. Let µ be the (coupled) probability measure on × given by the recipe of Theorem 4.91(a). We have that

- µ(σ0 = 1 | 0 ↔/ ∞)[1 − θ1(p,q)]

![image 430](../Images/imageFile430.png)

![image 431](../Images/imageFile431.png)

The claim is proven once we have shown that (5.32) φp0,q(0 ↔ u) → θ0(p,q)2 as |u| → ∞. By the 0/1-infinite-cluster property of φp0,q, see the remark after (4.36),

φp0,q(0 ↔ u) = φp0,q(0 ↔ ∞, u ↔ ∞) + φp0,q(u ∈ C, |C| < ∞). The last probability tends to zero as |u| → ∞. Also,

φp0,q(0 ↔ ∞, u ↔ ∞) → φp0,q(0 ↔ ∞)2 as |u| → ∞, since φp0,$q$ is mixing, see Corollary 4.23.

<a id="sec-5-3"></a>

## 5.3 Uniqueness of random-cluster measures

We record in this section some information about the set of values of $p$ at which there exists a unique random-cluster measure.

(5.33) Theorem [8, 152]. Let q ∈ [1,∞) and d ≥ 2. There exists a unique random-cluster measure, in that |Wp,q| = |Rp,q| = 1, if either of the following holds:

(a) θ0(p,q) = θ1(p,q), which is to say that p ∈/ Dq, (b) $p$ > p′, where $p$′ = p′(q,d) ∈ [pc(q),1) is a certain real number.

By part (a), there is a unique random-cluster measure for any p such that θ1(p,q) = 0, [8, Thm A.2]. In particular, there exists a unique random-cluster measure throughout the subcritical phase, that is, when 0 ≤ $p$ < pc(q). It is an important open problem to establish the same conclusion when $p$ > pc(q).

108 Phase Transition [5.3]

(5.34) Conjecture. Let q ∈ [1,∞) and d ≥ 2. We have that φp0,$q$ = φp1,q, and therefore |Wp,q| = |Rp,q| = 1, if and only if either of the following holds:

(i) either $p$ < pc(q) or $p$ > pc(q), (ii) $p$ = pc(q) and θ1(pc(q),q) = 0.

Slightly more is known in the case of two dimensions. It is proved in Theorem 6.17 that there is a unique random-cluster measure when d = 2 and $p$ = psd(q), where psd(q) =

√q/(1 +

√q) is the ‘self-dual’ value of p. It is conjectured that pc(q) = psd(q) for $q$ ∈ [1,∞). Proof of Theorem 5.33. The sufficiency of (a) was proved in Theorem 5.16(c).

![image 432](../Images/imageFile432.png)

![image 433](../Images/imageFile433.png)

We sketch a proof that φp0,$q$ = φp1,q if $p$ is sufficiently close to 1. There are certain topological complications in this3, and we refrain from giving all the relevant details, most of which may be found in a closely related passage of [211, Section 2]. We begin by defining a lattice L with the same vertex set as Ld but with edge-relation

x ∼ y if |xi − yi| ≤ 1 for 1 ≤ i ≤ d.

For ω ∈ , we call a vertex x white if ω(e) = 1 for all e incident with x in Ld, and black otherwise. Foranyset V ofverticesof L, we defineits blackcluster B(V)as the union of V together with the set of all vertices x0 of L for which the following holds: there exists a path x0,e0, x1,e1,. . .,en−1, xn of alternating vertices and edges of L such that x0, x1,. . ., xn−1 ∈/ V, xn ∈ V, and x0, x1,. . ., xn−1 are black. Note that the colours of vertices in V have no effect on B(V), and that V ⊆ B(V). Let

d

|xi − yi| : x ∈ V, y ∈ B(V) .

B(V) = sup

i=1

When V is a singleton, V = {x} say, we abbreviate B(V) to B(x).

For an integer n and a vertex x, the event { B(x) ≥ n} is a decreasing event, whence

(5.35) φp0,q( B(x) ≥ n) ≤ φ ,0 p,q( B(x) ≥ n) for any box ≤ φ ,π( B(x) ≥ n),

where φ ,π is product measure on E with density π = p/[p + q(1 − p)], and we have used the comparison inequality of Proposition 4.28(a). By a Peierls argument (see [211, pp. 151–152]) there exists α(p) such that: the percolation (product) measure φπ = lim ↑Zd φ ,π satisfies

(5.36) φπ( B(x) ≥ n) ≤ e−nα(p), n ≥ 1,

![image 434](../Images/imageFile434.png)

3An alternative approach may be based on the methods of Section 7.2.

and furthermore α(p) > 0 if $p$ is sufficiently large, say $p$ > p′ for some p′ ∈ [pc(q),1).

Let A be an increasingcylinderevent, and find a finite box such that A ∈ F . Let be a box satisfying ⊆ . For any subset S of = Zd \ containing ∂ , we define the ‘internal boundary’ D(S) of S to be the set of all vertices x of L satisfying:

![image 435](../Images/imageFile435.png)

(a) x ∈/ S, (b) x is adjacent in L to some vertex of S, (c) there exists a path of Ld from x to some vertex in , this path using no

vertex of S.

Let S = S ∪ D(S), and denote by I(S) the set of vertices x0 for which there exists a path x0,e0, x1,e1,. . .,en−1, xn of Ld with xn ∈ , xi ∈/ S for all i. Note that every vertex of ∂I(S) is adjacent to some vertex in D(S). We shall concentrate on the case S = B(∂ ).

Let ǫ > 0 and $p$ > p′, where $p$′ is given after (5.36). By (5.35)–(5.36), there exists a box ′ sufficiently large that (5.37) φp0,q(K , ) ≥ 1 − ǫ, ⊇ ′, where K , = B(∂ ) ∩ = ∅ . We pick ′ accordingly, and let ⊇ ′.

Assume that K , occurs, so that I = I(B(∂ )) satisfies I ⊇ . Let H be the set of all subsets h of such that h ⊆ . We note three facts about B(∂ ) and D(B(∂ )):

![image 436](../Images/imageFile436.png)

![image 437](../Images/imageFile437.png)

(a) D(B(∂ )) is Ld-connected in that, for all pairs x, y ∈ D(B(∂ )), there

exists a path of Ld joining x to y using vertices of D(B(∂ )) only, (b) every vertex in D(B(∂ )) is white,

(c) D(B(∂ )) is measurable with respect to the colours of vertices in I = Zd \ I, in the following sense: for any h ∈ H , the event {B(∂ ) = h, D(B(∂ )) = D(h)} lies in the σ-field generated by the colours of vertices in I(h).

![image 438](../Images/imageFile438.png)

![image 439](../Images/imageFile439.png)

Claim (a) may be proved by adapting the argument used to prove [211, Lemma 2.23]; claim (b) is a consequence of the definition of D(B(∂ )); claim (c) holds since D(B(∂ )) is part of the boundary of the black cluster of L generated by ∂ . Full proofs of (a) and (c) are not given here. They would be rather long, and would have much in common with [211, Section 2].

Let h ∈ H . The φp0,q-probability of A, conditional on {B(∂ ) = h}, is given by the wired measure φ1I(h),p,q. This holds since: (a) every vertex in ∂I(h) is adjacent to some vertex of D(h), and (b) D(h) is Ld-connected and all vertices in D(h) are white. Therefore, by conditional probability and positive association,

(5.38) φp0,q(A) ≥ φp0,q φ1I,p,q(A)1K ,

≥ φp0,q φ ,1 p,q(A)1K , since I ⊆ ≥ φ ,1 p,q(A) − ǫ by (5.37).

Let ↑ Zd and ǫ ↓ 0 in that order, and deduce that φp0,q ≥st φp1,q. Since φp0,q ≤st φp1,q, we conclude that φp0,$q$ = φp1,q.

<a id="sec-5-4"></a>

## 5.4 The subcritical phase

The random-cluster model is said to be in the subcritical phase when $p$ < pc(q), and this phase is the subject of the next three sections. Let q ∈ [1,∞), d ≥ 2, and $p$ < pc(q). By Theorem 5.33(a), φp0,$q$ = φp1,q, and hence |Wp,q| = |Rp,q| = 1. We shall denote the unique random-cluster measure by φp0,q.

The subcritical phase is characterized by the (almost-sure) absence of an infinite open cluster. Thus all open clusters are almost-surely finite, and one seeks estimates on the tail of the size of such a cluster. As described in [154, Chapter 6], one may study both the ‘radius’ and the ‘volume’ of a cluster C. We concentrate here on the cluster C = C0 at the origin, and we define its radius4 by

(5.39) rad(C) = max{ y : y ∈ C} = max{ y : 0 ↔ y}.

It is immediate that rad(C) ≥ n if and only if 0 ↔ ∂ n, where n = [−n,n]d. We note for later use that there exists a positive constant β = β(d) such that

![image 440](../Images/imageFile440.png)

![image 441](../Images/imageFile441.png)

n→∞

It is quite another matter to show as expected that

(5.43) ψ(p,q) > 0, ζ(p,q) > 0 for $p$ < pc(q).

We confine ourselves in this section to ‘soft’ arguments concerning the existence of ψ and ζ; the ‘harder’ arguments relevant to strict positivity are deferred to the next two sections. We begin by considering the radius of the cluster at the origin. The existence of the limit in (5.41) relies essentially on positive association. We write en = (n,0,0,. . . ,0).

![image 442](../Images/imageFile442.png)

4Note the use of the distance function · rather than the function | · | of [154].

![image 443](../Images/imageFile443.png)

![image 444](../Images/imageFile444.png)

![image 445](../Images/imageFile445.png)

![image 446](../Images/imageFile446.png)

n→∞

n→∞

exists and satisfies 0 ≤ ψ = ψ(p,q) < ∞. There exists a constant σ = σ(d) such that

(5.46) φp0,q(0 ↔ en) ≤ e−nψ, φp0,q(0 ↔ ∂ n) ≤ σnd−1e−nψ, n ≥ 1.

Proofs of Theorem 5.44 and Corollary 5.45. The proof of Theorem 5.44 follows exactlythatofthecorrespondingpartsof[154,Thms6.10,6.44],andthedetailsare omitted. For the second proof, it suffices to check that φp0,q satisfies the conditions of Theorem 5.44.

We turn next to the volume |C| of the open cluster at the origin. A probability measure µ on ($\Omega, \mathcal{F}$) is said to satisfy the ‘uniform insertion-tolerancecondition’ if, for some α,β ∈ (0,1),

![image 447](../Images/imageFile447.png)

![image 448](../Images/imageFile448.png)

It is an easy consequence of (5.48)–(5.49) that (5.50) −

1 n

logµ(n ≤ |C| < ∞) → ζ(µ) as n → ∞.

![image 449](../Images/imageFile449.png)

![image 450](../Images/imageFile450.png)

![image 451](../Images/imageFile451.png)

Proofs of Theorem 5.47 and Corollary 5.51. These are obtained by following the proof of [154, Thm 6.78], and the details are omitted.

Since φp0,q(0 ↔ ∞) > 0 when $p$ > pc(q), it is elementary that (5.52) ψ(p,q) = 0 for $p$ > pc(q). It is rather less obvious that (5.53) ζ(p,q) = 0 for $p$ > pc(q), and this is implied (for sufficiently large p) by Theorem 5.108. It is an important open problem to prove that ψ(p,q) > 0 and ζ(p,q) > 0 when $p$ < pc(q). (5.54) Conjecture (Exponentialdecay). Let q ∈ [1,∞). Then ψ(p,q) > 0 and ζ(p,q) > 0 whenever $p$ < pc(q).

A partial result in this direction is the following rather weak statement; related results may be obtained via Theorem 3.79 as in Theorem 6.30. (5.55) Theorem. Let q ∈ [1,∞) and 0 < $p$ < pc(1). Then ψ(p,q) > 0 and ζ(p,q) > 0.

Proof. Let q ∈ [1,∞), while noting in passing that the method of proof is valid even when q ∈ (0,1), using the comparison inequalities of Theorem 3.21 as in (5.118). By Proposition 4.28(a), φp0,q ≤st φp. Therefore,

φp0,q(0 ↔ ∂ n) ≤ φp(0 ↔ ∂ n),

whence ψ(p,q) ≥ ψ(p,1), and the strict positivity of ψ follows by the corresponding statement for percolation, [154, Thm 6.14].

Similarly,

φp0,q(|C| = n) ≤ φp0,q(|C| ≥ n) ≤ φp(|C| ≥ n). By [154, eqn (6.82)],

1 n

logφp(|C| ≥ n) → ζ(p,1) as n → ∞. Furthermore, ζ(p,1) > 0 when $p$ < pc(1), by [154, Thm 6.78].

−

![image 452](../Images/imageFile452.png)

![image 453](../Images/imageFile453.png)

n→∞

follows from Corollary 5.45, and the problem is to determine for which p, q it is the case that ψ(p,q) > 0. See Conjecture 5.54.

In the case of percolation, a useful intermediate step was the proof by Hammersley [177] that ψ(p,1) > 0 whenever the two-point connectivity function is summable, that is,

φp(0 ↔ x) < ∞.

φp(|C|) =

x∈Zd

Similarly, Simon [300] and Lieb [234] proved the exponential decay of the twopoint function of Ising and other models under a summability assumption on this function, see Section 9.3. Such conclusions provoke the following question in the current context: if φp0,q(0 ↔ ∂ n) decays at some polynomial rate as n → ∞, then must it necessarily decay at an exponential rate? An affirmative answer is provided in the discussion that follows.

We concentrate here on the quantity (5.57) L(p,q) = lim sup

nd−1φp0,q(0 ↔ ∂ n) .

n→∞

By the comparison inequality, Proposition 4.28, L(p,q) is non-decreasing in p, and therefore,

< ∞ if $p$ < pc(q), = ∞ if $p$ > pc(q),

L(p,q)

where (5.58) pc(q) = sup p : L(p,q) < ∞ . Clearly pc(q) ≤ pc(q), and equality is believed to hold. (5.59) Conjecture [163]. If q ∈ [1,∞), then pc(q) = pc(q).

Certainly pc(q) = pc(q) when $q$ = 1, see [154], and we shall see at Theorem 7.33 that this holds also when $q$ is sufficiently large. It is in addition valid for $q$ = 2, see Theorem 9.53 and the remarks thereafter.

The condition L(p,q) < ∞ amounts to the statement that the radius R = rad(C)hasataildecayingatleastasfastasn−(d−1). Thisisslightlyweakerthanthe moment condition φp0,q(Rd−1) < ∞. In fact, L(p,q) = 0 if φp0,q(Rd−1) < ∞, since

∞

nd−1φp0,q(0 ↔ ∂ n) = nd−1φp0,q(R ≥ n) ≤

kd−1φp0,q(R = k).

k=n

There is a converse statement. If $p$ < pc(q) then L(p,q) < ∞, implying that ncφp0,q(0 ↔ ∂ n) → 0 for all c satisfying c < d − 1.

This in turn implies, as in [164, Exercise 5.6.4], that φp0,q(Rc) < ∞ for all c < d − 1.

We state nextthe main conclusionof this section. A related result is to be found at Theorem 5.86. (5.60) Theorem. Let q ∈ [1,∞). The function ψ in (5.56) satisfies ψ(p,q) > 0 whenever 0 < $p$ < pc(q).

The proof, which is delayed until later in the section, uses the method of exponential steepness described in Section 3.5. Let A be an event, and recall from (2.54) the definition of the random variable HA,

|ω′(e) − ω(e)| : ω′ ∈ A , ω ∈ .

HA(ω) = inf

e

We shall consider the event An = {0 ↔ ∂ n}, and we write Hn for HAn. The question of ascertaining the asymptotics of Hn may be viewed as a first-passage problem. Imagine you are travelling from 0 to ∂ n; travel along open edges is instantaneous, but along each closed edge requires time 1. The fastest route requires time Hn, and one is interested in the time-constant η, defined as η = limn→∞{n−1Hn}.

![image 454](../Images/imageFile454.png)

n→∞

The constant η(µ) is called the time-constant associated with µ.

Proof. See the comments in [119, 211], and the later paper [58]. The existence of the limit η is a consequence of a theorem attributed in [119, p. 748, Erratum] and [211, p. 259] to Derrienic.

We apply this to the measure µ = φp0,q to deduce the existence, φp0,q-almostsurely, of the associated (deterministic) time-constant (5.62) η(p,q) = lim

1 n

Hn . By Proposition 4.28, η(p,q) is non-increasing in p, and we define (5.63) ptc(q) = sup p : η(p,q) > 0 . We seek a condition under which η(p,q) > 0. As usual, C denotes the vertex set of the open cluster at the origin.

![image 455](../Images/imageFile455.png)

n→∞

(5.64) Theorem (Positivity of time-constant) [163]. Let p ∈ (0,1) and $q$ ∈ [1,∞). If φp0,q(|C|2d+ǫ) < ∞ for some ǫ > 0, then η(p,q) > 0.

We define the further critical point (5.65) pg(q) = sup p : ψ(p,q) > 0 , with ψ(p,q) as in (5.56). The correlation length ξ(p,q) is defined by

ξ(p,q) = ψ(p,q)−1, subject to the conventionthat 0−1 = ∞. Note that ξ(p,q) is non-decreasingin p. Thusφp0,q(0 ↔ ∂ n)decaysexponentially asn → ∞ if and only if ξ(p,q) < ∞. (5.66) Theorem. Let q ∈ [1,∞). It is the case that ptc(q) = pg(q).

By this theorem and the prior observations, (5.67) ptc(q) = pg(q) = pc(q) ≤ pc(q), with equality conjectured. From the next section onwards, we shall use the expression pc(q) for the common value of ptc(q), pg(q), pc(q).

In the percolation case (when $q$ = 1), the above first-passage problem and the associated time-constant η(p,q) have been studied in detail; see [208, 211]. Several authors have given serious attention to a closely related question when $q$ = 2 and d = 2, namely, the corresponding question for the two-dimensional Ising model with the ‘passage time’ Hn replaced by the minimum number of changes of spin along paths from the origin to ∂ n, see [1, 90, 119]. The timeconstant in the Ising case cannot exceed the corresponding random-cluster timeconstantη(p,2), sinceeachedgeoftheIsingmodelhavingendverticeswithunlike spins gives rise to a closed edge in the (coupled) random-cluster model.

![image 456](../Images/imageFile456.png)

![image 457](../Images/imageFile457.png)

![image 458](../Images/imageFile458.png)

![image 459](../Images/imageFile459.png)

Noteinpassingthatinequalities(5.68)and(5.69),with A = An = {0 ↔ ∂ n}, imply that the correlation length ξ(p,q) is strictly increasing in p whenever it is finite, cf. [154, Thm 6.14].

Proof of Theorem 5.66. Let r < s < ptc(q). Since s < ptc(q), there exists γ = γ(s,q) > 0 such that

(5.70) φs,q(Hn) ≥ nγ, n ≥ 1. Let A = An = {0 ↔ ∂ n}. In conjunction with (5.70), (5.68) implies the exponential decay of φr,q(An), whence r ≤ pg(q). Therefore ptc(q) ≤ pg(q).

Conversely, suppose that r < s < pg(q). There exists α = α(s,q) > 0 such that φs0,q(An) ≤ e−αn. By (5.69) with A = An and some β = β(r,s,q) > 0,

− log(e−αn) log[q/(s − r)] − β =

αn

φr0,q(Hn) ≥

log[q/(s − r)] − β, whence r ≤ ptc(q). Therefore pg(q) ≤ ptc(q).

![image 460](../Images/imageFile460.png)

![image 461](../Images/imageFile461.png)

There are two stages in the proof of Theorem 5.60. In the first, we apply (5.68)–(5.69) with A = An, and we utilize an iterative scheme to prove that φp0,q(An) decays ‘near-exponentially’ when $p$ < pc(q). In the second stage, we use Theorems 5.64 and 5.66 to deduce full exponential decay. The conclusion of the first stage may be summarized as follows.

- (5.71) Lemma. Let q ∈ [1,∞), and let 0 < $p$ < pc(q). There exist constants c = c(p,q) ∈ (0,∞), = (p,q) ∈ (0,1) such that
- (5.72) φp0,q(An) ≤ exp(−cn ), n ≥ 1.

Lemma 5.71 will be proved by an iterative scheme which may be continued further. If this is done, one obtains that φp0,q(An) decays at least as fast as exp(−αkn/logk n) for any k ≥ 1, where αk = αk(p,q) > 0 and logk n is the kth iterate of logarithm, that is,

log1 x = log x, logk x = log(1 ∨ logk−1 x), k ≥ 2.

Proof of Lemma 5.71. We shall use (5.68) and (5.69) in an iterative scheme. In the following, we shall sometimes use real quantities when integers are required. All terms of the form o(1) or O(1) are to be interpreted in the limit as n → ∞.

![image 462](../Images/imageFile462.png)

![image 463](../Images/imageFile463.png)

![image 464](../Images/imageFile464.png)

where 1 < D = q/(t − s) < ∞. We substitute this into (5.68) to obtain that

c2(r) nd−1+ 2(r) , n ≥ 1,

(5.74) φr0,q(An) ≤

![image 465](../Images/imageFile465.png)

for some strictly positive and finite c2(r) and 2(r). This holds for all r < pc(q), and is an improvement in order of magnitude over (5.73).

![image 466](../Images/imageFile466.png)

![image 467](../Images/imageFile467.png)

![image 468](../Images/imageFile468.png)

![image 469](../Images/imageFile469.png)

![image 470](../Images/imageFile470.png)

![image 471](../Images/imageFile471.png)

![image 472](../Images/imageFile472.png)

![image 473](../Images/imageFile473.png)

![image 474](../Images/imageFile474.png)

![image 475](../Images/imageFile475.png)

![image 476](../Images/imageFile476.png)

![image 477](../Images/imageFile477.png)

![image 478](../Images/imageFile478.png)

m→∞

The (inner) supremum is over all paths from the origin containing m vertices. We propose to show that φp0,q(K < ∞) = 1, whence η > 0 as required.

Let { Cx : x ∈ Zd} be a collection of independent subsets of Zd with the property that Cx has the same law as Cx. We claim, as in [119], that the family {|Cx| : x ∈ Zd} is dominated stochastically by {Mx : x ∈ Zd}, where

Mx = sup | Cy| : y ∈ Zd, x ∈ Cy ,

and we shall prove this inductively. Let v1,v2,. . . be a deterministic ordering of Zd. Given the random variables { Cx : x ∈ Zd}, we shall construct a family {Dx : x ∈ Zd} having the same joint law as {Cx : x ∈ Zd} and satisfying: for each x, there exists y such that Dx ⊆ Cy. First, we set Dv1 = Cv1. Given Dv1, Dv2,. . ., Dvn, we define E = ni=1 Dvi. If vn+1 ∈ E, we set Dvn+1 = Dvj for some j such that vn+1 ∈ Dvj . If vn+1 ∈/ E, we proceed as follows. Let

eE be the set of edges of Zd having exactly one endvertex in E. We may find a (random) subset F of Cvn+1 such that F has the conditional law of Cvn+1 given that all edges in eE are closed; we now set Dvn+1 = F. We are using two

properties of φp0,q here. Firstly, the law of Cvn+1 given Cv1,Cv2,. . .,Cvn depends only on eE, and secondly, φp0,$q$ is positively associated. We obtain the required stochastic domination accordingly.

![image 479](../Images/imageFile479.png)

![image 480](../Images/imageFile480.png)

m→∞

where the (inner) supremum is over all animals Ŵ of Ld having m vertices and containing the origin. By the main result of [97], the right side is almost-surely finite so long as each | Cx|2 has finite (d + ǫ)th moment for some ǫ > 0. The required conclusion follows.

Proof of Theorem 5.60. Let q ∈ [1,∞) and $p$ < pc(q). Find r such that $p$ < r < pc(q). By Lemma 5.71, there exist c, > 0 such that

φr0,q(An) ≤ exp(−cn ), n ≥ 1.

This implies that φr0,q(|C|2d+1) < ∞. By Theorem 5.64, η(r,q) > 0, and so r ≤ ptc(q). By Theorem 5.66, r ≤ pg(q), and the claim follows.

<a id="sec-5-6"></a>

## 5.6 Exponential decay of volume

For percolation, there is a beautiful proof of the exponential decay of volume using only that of radius. This proof hinges on the independence of the states of different edges, and may therefore not be extended at present to general randomcluster models, see [154, Thm 6.78]. We shall instead make use here of the block arguments of [209], obtaining thereby the exponential decay of volume subject to a condition on p believed but not known to hold throughout the subcritical phase. This condition differs slightly from that of the last section in that it involves the decay rate of certain finite-volume probabilities.

Let a ≥ 1, and let (5.83) La(p,q) = lim sup

nd−1φ1 an,p,q(0 ↔ ∂ n) . As at (5.57), La(p,q) is non-decreasing in p, and therefore,

n→∞

La(p,q) = 0 if $p$ < pca(q), ∈ (0,∞] if $p$ > pca(q),

120 Phase Transition [5.6]

where (5.84) pca(q) = sup p : La(p,q) = 0 . Clearly pca(q) is non-decreasing in a, and furthermore pca(q) ≤ pc(q) for all a ≥ 1. We set

pca(q). It is elementary that pc∞(q) ≤ pc(q), and we conjecture that equality holds. (5.85) Conjecture. If q ∈ [1,∞), then pc∞(q) = pc(q).

pc∞(q) = lim

a→∞

Here is the main result of this section.

(5.86) Theorem. Let q ∈ [1,∞). There exists ρ(p,q), satisfying ρ(p,q) > 0 when $p$ < pc∞(q), such that

φp0,q(|C| ≥ n) ≤ e−nρ, n ≥ 1.

The hypothesis $p$ < pc∞(q) is slightly stronger than that of Theorem 5.60, and so is the conclusion, since φp0,q(rad(C) ≥ n) ≤ φp0,q(|C| ≥ n). Proof. We adapt the arguments of [209, Section 2], from which we extract the main steps. For N ≥ 1 and i = 1,2,. . . ,d, we define the box

TN(i) = [0,3N]i−1 × [0, N] × [0,3N]d−i.

For ω ∈ , an i-crossing of TN(i) is an open path x0,e0, x1,e1,. . .,em of alternating vertices and edges of TN(i) such that the ith coordinate of x0 (respectively, xm) is 0 (respectively, N). Such crossings are in the short direction. For b > 3, we define

(5.87) τNb = φ1 bN,p,q TN(i) has an i-crossing ,

noting by rotation-invariance that τNb does not depend on the value of i.

Let N be a fixed positive integer. From Ld we construct a new lattice L as follows. First, LhasvertexsetZd. Twoverticesx,yofLaredeemedadjacentinL if andonlyif |xi −yi| ≤ 3 forall i = 1,2,. . .,d. The betterto distinguishvertices of Ld and L, we shall use bold letters to indicate the latter. Let ω ∈ . Vertex x of L is coloured white if there exists i ∈ {1,2,. . .,d} such that Nx + TN(i) has an i-crossing, and is coloured black otherwise. The event {x is white} is increasing, and is defined in terms of the states of edges in the box (x) = Nx + [0,3N]d.

The following lemma relates the size of the open cluster C at the origin of Ld to the sizes of white clusters of L. For x ∈ Zd, we write Wx for the connected cluster of white vertices of L containing x.

![image 481](../Images/imageFile481.png)

m≥An−1

where am is the number of connected sets w of m vertices of L containing 0, and Mp,q(m) = max φp0,q(all vertices in w are white) : |w| = m . By the final display of the proof of [209, Lemma 3], (5.93) am ≤ 72d(7de)m, and it remains to bound φp0,q(all vertices in w are white).

Fix b > 3, to be chosen later. Let w be as above with |w| = m. There exists a constantc = c(b) > 0 such that: w containsatleast t vertices y(1),y(2),. . .,y(t) such that t ≥ cm and the boxes Ny(r) + bN, r = 1,2,. . .,t, of Ld are disjoint. We may choose such a set {y(r) : r = 1,2,. . .,t} in a way which depends only on the set w. Then

(5.94) φp0,q(all vertices in w are white) ≤ φp0,q y(r) is white, r = 1,2,. . .,t . The events {y(r) is white}, r = 1,2,. . .,t, are dependent under φp0,q. However, by positive association, (5.95)

φp0,q y(r) is white, r = 1,2,. . .,t ≤ φp0,q y(r) is white, r = 1,2,. . .,t E ,

where E istheeventthateveryedgeehavingbothendverticesin Ny(r)+∂ bN, for any given r ∈ {1,2,. . .,t}, is open. Under the conditional measure φp0,q(· | E), the events {y(r) is white}, r = 1,2,. . .,t, are independent, whence by symmetry

(5.96) φp0,q y(r) is white, r = 1,2,. . .,t ≤ φ1 bN,p,q(0 is white) t

≤ (dτNb )t. By (5.92)–(5.96),

72d(7de)m(dτNb )⌊cm⌋.

(5.97) φp0,q(|C| ≥ n) ≤ 7d

m≥An−1

Let a > 1 and choose b > 3 + a, noting that x + aN ⊆ bN for all x ∈ Zd lying in the region R = [0,3N]d−1 × {0}. If TN(d) has a d-crossing, there exists x ∈ R such that x ↔ x + ∂ N. Since φ1 bN,p,q ≤st φ1 aN,p,q,

(5.98) φ1 bN,p,q(x ↔ x + ∂ N)

τNb ≤

x∈R

≤ |R|φ1 aN,p,q(0 ↔ ∂ N)

= (3N + 1)d−1φ1 aN,p,q(0 ↔ ∂ N).

Let $p$ < pc∞(q), and choose a > 1 such that $p$ < pca(q). With b > 3 + a, the right side of (5.98) may be made as small as required by a suitably large choice of N, and we choose N in such a way that 7de(dτNb )c < 21. Inequality (5.97) provides the required exponential bound.

![image 482](../Images/imageFile482.png)

<a id="sec-5-7"></a>

## 5.7 The supercritical phase and the Wulff crystal

Percolation theory is a source of intuition for the more general random-cluster model, but it has not always been possible to make such intuition rigorous. This is certainly so in the supercritical phase, where several of the basic questions remain unanswered to date. We shall work in this section with the free and wired measures, φp0,q and φp1,q, and we assume throughout that q ∈ [1,∞).

The first property of note is the almost-sure uniqueness of the infinite open cluster. A probability measure φ on ($\Omega, \mathcal{F}$) is said to have the 0/1-infinite-cluster property if the number I of infinite open clusters satisfies φ(I ∈ {0,1}) = 1. We recall from Theorem 4.33(c) that every translation-invariant member of the closed convex hull of Wp,q has the 0/1-infinite-cluster property. By ergodicity, see Corollary 4.23, we arrive at the following.

(5.99) Theorem (Uniqueness of infinite open cluster). Let p ∈ [0,1] and $q$ ∈ [1,∞). We have for b = 0,1 that (5.100) φpb,q(I = 1) = 1 whenever θb(p,q) > 0.

Let q ∈ [1,∞) and $p$ > pc(q). There exists (φpb,q-almost-surely) a unique infinite open cluster. What may be said about the shapes and sizes of finite open clusters? One expects finite clusters to have properties broadly similar to those of supercritical percolation. Much progress has been made in recent years towards proofs of such statements, but a vital step remains unresolved. As was true formerly for percolation, the results in question are proved only for $p$ exceeding a certain ‘slab critical point’ pc(q), and it is an important open problem to prove that pc(q) = pc(q) for all q ∈ [1,∞).

Here is an illustration. It is fundamental for supercritical percolation that the tails of the radius and volume of a finite open cluster decay exponentially in n and n(d−1)/d respectively, see [154, Thms 8.18, 8.65]. This provokes an important problem for the random-clustermodel whose full resolution remains open. Partial results are known when $p$ > pc(q), see Theorems 5.104 and 5.108.

(5.101) Conjecture. Let p ∈ [0,1] and $q$ ∈ [1,∞). There exist σ = σ(p,q), γ = γ(p,q), satisfying σ(p,q),γ(p,q) > 0 when $p$ > pc(q), such that

φp1,q(n ≤ rad(C) < ∞) ≤ e−nσ, φp1,q(n ≤ |C| < ∞) ≤ e−γn(d−1)/d, n ≥ 1.

We turn next to a discussion of the so-called ‘Wulff construction’. Much attention has been paidto the sizes andshapes of clustersformedin modelsof statistical mechanics. When a cluster C is infinite with a strictly positive probability, but is constrained to have some large finite size N, then C is said to form a large ‘droplet’. The asymptotic shape of such a droplet, in the limit of large N, is prescribed in general terms by the theory of the so-called Wulff crystal5. In the case of the random-cluster model, we ask for properties of the open cluster C at the origin, conditionalon the event {N ≤ |C| < ∞} for large N. The rigorouspicture is not yet complete, but techniques have emerged through the work of Cerf and Pisztora, [83, 84, 276], which may be expected to reveal in due course a complete account of the Wulff theory of large finite clusters in the random-clustermodel. A full account of this work would be too lengthy for inclusion here, and we content ourselves with a brief summary.

The study of the Wulff crystal is bound up with the law of the volume of a finite cluster, see Conjecture 5.101. It is straightforward to adapt the corresponding percolation proof (see [154, Thm 8.61]) to obtain that

φp1,q(|C| = n) ≥ e−γn(d−1)/d,

![image 483](../Images/imageFile483.png)

5Such shapes are named after the author of [325]. The first mathematical results on Wulff shapes were proved for the two-dimensional Ising model in [104], see the review [55].

for some γ satisfying γ < ∞ when pc(q) < $p$ < 1. It is believed as noted above that this is the correct order for the rate of decay of φp1,q(|C| = n) when $p$ > pc(q).

Before continuing, we make a commentconcerning the numberof dimensions. The case d = 2 is special (see Chapter 6). By the duality theory for planar graphs, the dual of a supercritical random-clustermeasure is a subcritical randomcluster measure, and this permits the use of special arguments. We shall therefore suppose for the majority of the rest of this section that d ≥ 3; some remarks about the two-dimensional case are made after Theorem 5.108.

A partial account of the Wulff construction and the decay of volume of a finite cluster is provided in [83], where the asymptotic shape of droplets is studied in the special case of the Ising model. The proofs to date rely on two assumptions on the value of $p$, namely that $p$ is such that φp0,$q$ = φp1,q, cf. Conjecture 5.34, and secondly that p exceeds a certain ‘slab critical point’ pc(q) which we introduce next.

Fix q ∈ [1,∞) and let d ≥ 3. Let S(L,n) be the slab given as S(L,n) = [0, L − 1] × [−n,n]d−1,

and let ψpL,,qn = φS0(L,n),p,q be the random-clustermeasure on S(L,n) with parameters p, q, and with free boundaryconditions. We denote by (p, L) the property that:

there exists α > 0 such that, for all n and all x ∈ S(L,n),ψpL,,qn(0 ↔ x) > α.

It is not hard to see that (p, L) ⇒ (p′, L′) if $p$ ≤ p′ and L ≤ L′, and it is thus natural to define the quantities

(5.102) pc(q, L) = inf p : (p, L) occurs , pc(q) = lim

pc(q, L).

L→∞

Clearly, pc(q) ≤ pc(q) < 1. It is believed that equality holds in that pc(q) = pc(q), and it is a major open problem to prove this6.

(5.103) Conjecture [276]. Let q ∈ [1,∞) and d ≥ 3. Then pc(q) = pc(q).

Thecase $q$ = 1 ofConjecture5.103isspecial, since percolationenjoysa spatial independence not shared with general random-cluster models. This additional property has been used in the formulation of a type of ‘dynamic renormalization’, which has in turn yielded a proof that pc(1) = pc(1) for percolation in three or more dimensions, see [24], [154, Chapter 7], [161]. Such arguments have been adapted by Bodineau to the Ising model, resulting in proofs that pc(2) = pc(2) and that the pure phases are the unique extremalGibbs states when $p$ = pc(2), see

![image 484](../Images/imageFile484.png)

6OnemayexpectthemethodsofSection7.5toyieldaproofthat pc(q) = pc(q)forsufficiently large q.

[53, 54]. Such arguments do not to date have a full random-cluster counterpart. Instead, in the random-cluster setting, one exploits what might be termed ‘static renormalization’methods, or ‘block arguments’, see [83, 276]. One divides space into blocks, constructs events of an appropriate nature on such blocks, having large probabilities, and then allows these events to combine across space. There have been substantial successes using this technique, of which the most striking is the resolution (subject to side conditions) of the Wulff construction for the Ising model.

We state next an exponential-decay theorem for the radius of a finite cluster; the proof is given at the end of this section. It is an immediate corollary that the ‘truncated two-point connectivity function’ φp1,q(x ↔ y, x ↔/ ∞) decays exponentially in the distance x − y , whenever $p$ > pc(q).

(5.104) Theorem. Let q ∈ [1,∞), d ≥ 3, and $p$ > pc(q). There exists σ = σ(p,q) > 0 such that

φp1,q(n ≤ rad(C) < ∞) ≤ e−nσ, n ≥ 1.

We turn now to the Wulff construction. Subject to a verification of Conjecture 5.103, and of a positive answerto the questionof the uniquenessof random-cluster measureswhen $p$ > pc(q),theblockargumentsofCerfandPisztorayieldalargely complete picture of the Wulff theory of random-cluster models with q ∈ [1,∞), see [83, 276] and also [84]. Paper [81] is a fine review of Wulff constructions for percolation, Ising, and random-cluster models.

The reader is referred to [81] for an introductory discussion to the physical background of the Wulff construction. It may be summarized as follows for random-cluster models. Let n = [−n,n]d, and consider the wired randomcluster measure φ1 n,p,q with $p$ > pc(q). The larger an open cluster, the more likely it is to be joined to the boundary ∂ n. Suppose that we condition on the event that there exists in n an open cluster C that does not intersect ∂ n and that has volume of the order of the volume nd of the box. What can be said about the shape of C? Since $p$ > pc(q), there is little cost in having large volume, and the price of such a cluster accumulates around its external boundary. It turns out that the price may be expressed as a surface integral of an appropriate function termed ‘surface tension’. This ‘surface tension’ may be specified as the exponential rate of decay of a certain probability. The Wulff prediction for the shape of C is that, when re-scaled in the limit of large n, it converges to the solution of a certain variational problem, that is, the limit shape is obtained by minimizing a certain surface integral subject to a constraint on its volume.

For A ⊆ Zd, let ρ(A) be the number of vertices x ∈ A such that x ↔ ∂ A. When $p$ > pc(q), ρ( n) has order | n|. Let C be the open cluster at the origin, and suppose we condition on the event {|C| ≥ αnd, C ∩∂ n = ∅} where α > 0. This conditioning implies a change in value of ρ( n)/| n| amounting to a large deviation. The link between Wulff theory and large deviations is made more concrete in the next theorem. The set Dq is given in Theorem 4.63 as the (at most

(5.106) Theorem [81]. Let q ∈ [1,∞) and d ≥ 3. Let p ∈ ( pc(q),1) be such that p ∈/ Dq. There exists a bounded, closed, convex set W of Rd containing the origin in its interior such that the following holds. Under the conditionalmeasure obtained from φp1,q by conditioning on the event {nd ≤ |C| < ∞}, the random measure

1 nd x∈C

δx/n

![image 485](../Images/imageFile485.png)

converges in probability, with respect to the bounded, uniformly continuous functions, towards the set {θ1W(a + x)dx : a ∈ R} of measures, where θ = θ1(p,q). The probabilities of deviations are of order exp(−cnd−1).

![image 486](../Images/imageFile486.png)

![image 487](../Images/imageFile487.png)

x∈W

≥ 1 − e−cnd−1, n ≥ 1,

where φ1p,$q$ is the measure obtained from φp1,q by conditioning on the event {nd ≤ |C| < ∞}, and | · | is the Euclidean norm on Rk. This is a way of saying that the external boundary of a large finite open cluster with cardinality approximately nd resembles the boundary of a translate of nW. Within this boundary, the open cluster has density approximately θ, whilst the density outside is zero. It is presumably the case that the a in (5.107) may be chosen independently of f and ǫ, but this has not yet been proved.

![image 488](../Images/imageFile488.png)

One important consequence of the analysis of [83] is an exact asymptotic for the probability that |C| is large. (5.108) Theorem [81]. Let q ∈ [1,∞) and d ≥ 3. Let p ∈ ( pc(q),1) be such that p ∈/ Dq. There exists γ = γ(p,q) ∈ (0,∞) such that

1 nd−1

logφp1,q(nd ≤ |C| < ∞) → −γ as n → ∞.

![image 489](../Images/imageFile489.png)

The above results are valid in two dimensions also although, as noted earlier, this case is special. When d = 2, the slab critical point pc(q) is replaced by the infimumofvalues patwhichthedualprocesshasexponentialdecayofconnections (see (6.5) for the relation between the dual and primal parameter-values). That is, when d = 2,

q(1 − pg(q)) pg(q) + q(1 − pg(q))

pc(q) =

![image 490](../Images/imageFile490.png)

where pg(q) is given at (5.65). Fluctuations in droplet shape for random-cluster models in two dimensions have been studied in [17, 18].

ProofofTheorem5.104. Weadapttheproofof[87]asreportedin[154,Thm8.21]. We shall build the cluster C at the origin (viewed as a set of open edges) step by step, in a manner akin to the proof of Proposition 5.30. First, we order the edges of Ld in some arbitrary but deterministic way, and we write ei for the ith edge in this ordering. Let ω ∈ . We shall construct a sequence (C0, D0),(C1, D1),. . . of pairs of (random) edge-sets such that Ci ⊆ Ci+1 and Di ⊆ Di+1 for each i. Every edge in each Ci (respectively, Di) will be open (respectively, closed). Let C0 = D0 = ∅. Having found (Cm, Dm) for m = 0,1,. . .,n, we find the earliest edge e ∈/ Cn ∪ Dn in the above ordering such that e has an endvertex in common with some member of Cn; if Cn = ∅ we take e ∈/ Dn to be the earliest edge incident to the origin if such an edge exists. We now define

(Cn+1, Dn+1) =

(Cn ∪ {e}, Dn) if e is open, (Cn, Dn ∪ {e}) if e is closed.

This process is continued until no candidate edge e may be found, which is to say that we have exhausted the open cluster C. If Cn = C for some n then we define Cl = C for l ≥ n, so that

(5.109) C = lim

Cn.

n→∞

Let Hn = {x ∈ Zd : x1 = n}, and let Gn be the event that the origin belongs to a finite cluster that intersects Hn. The box n has 2d faces, whence, by the rotation-invariance of φp0,q,

(5.110) φp1,q 0 ↔ ∂ n, |C| < ∞ ≤ 2dφp1,q(Gn). We shall prove that, for $p$ > pc(q), there exists γ > 0 such that (5.111) φp1,q(Gn) ≤ e−nγ , n ≥ 1, and the claim of the theorem is an immediate consequence.

The idea of the proof of (5.111) is as follows. Since $p$ > pc(q) by assumption, we may find an integer L such that $p$ > pc(q, L). Write S(L) = [0, L) × Zd−1, and

(5.112) Si(L) = S(L) + (i − 1)Le1 = (i − 1)L,iL × Zd−1,

where e1 = (1,0,0,. . .,0). Suppose that GmL occurs for some m ≥ 1. Then each of the regions Si(L), i = 1,2,. . .,m, is traversedby an open path π from the origin. Since $p$ > pc(q, L), there is φS0i(L),p,q-probability 1 that Si(L) contains an infinite open cluster, and π must avoid all such clusters for i = 1,2,. . .,m.

Let S(L, N) = [0, L)×[−N, N]d−1. Since $p$ > pc(q, L), we may find α > 0 such that

φS0(L,N),p,q(0 ↔ v) > α, v ∈ S(L, N). By positive association,

(5.113) φS0(L,N),p,q(v ↔ ∂ M) > α2, v ∈ S(L, N), 0 < M ≤ N.

Let n be a positive integer satisfying n ≥ L, and write n = rL + s where 0 ≤ s < L. Let n < M < N, and consider the probability ψN(Gn,M) where ψN = φ1 N,p,q and Gn,M = {0 ↔ Hn, 0 ↔/ ∂ M}. Later, we shall take the limit as M, N → ∞. On the event Gn,M, we have that T ≥ r, and vi ↔/ ∂ M in Si(L), for i = 1,2,. . .,r. Therefore,

(5.114) ψN(Gn,M) ≤ ψN(Ar), where

j

vi ↔/ ∂ M in Si(L) .

Aj = {T ≥ j} ∩

i=1

Now A0 = , and Aj ⊇ Aj+1 for j ≥ 1, whence

r

(5.115) ψN(Gn,M) ≤ ψN(A1)

ψN(Aj | Aj−1).

j=2

Let j ∈ {2,3,. . .,r}, and consider the conditionalprobability ψN(Aj | Aj−1); the case j = 1 is similar. We have that

ψN(Aj | Aj−1) ≤

ψN v ↔/ ∂ M in Sj(L) vj = v, T ≥ j, Aj−1 ×ψN(vj = v | T ≥ j, Aj−1)ψN(T ≥ j | Aj−1).

v∈H(j−1)L

We claim that (5.116) ψN v ↔/ ∂ M in Sj(L) vj = v, T ≥ j, Aj−1 ≤ 1 − α2. This will imply that

ψN(Aj | Aj−1) ≤ (1 − α2)

ψN(vj = v | T ≥ j, Aj−1)

v∈H(j−1)L

= 1 − α2, yielding in turn by (5.114)–(5.115) that ψN(Gn,M) ≤ (1 − α2)r.

[5.8] Uniqueness when $q$ < 1 131

Let N → ∞ and M → ∞ to obtain that

φp1,q(0 ↔ Hn, 0 ↔/ ∞) ≤ (1 − α2)⌊n/L⌋, n ≥ 1, and (5.111) follows as required.

It remains to prove (5.116), which we do by a coupling argument. Suppose that we have ‘built’ the cluster at the origin until the first epoch m = mj at which Cm touches Sj(L) and, in so doing, we have discovered that vj = v, T ≥ j, and Aj−1 occurs. The event Ev = {v ↔/ ∂ M in Sj(L)} is measurable on the σ-field generated by the edge-states in Sj(L), and the configuration on Sj(L) is governed by a certain conditional probability measure, namely that featuring in (5.116). This conditional measure on Sj(L) dominates (stochastically) the free random-cluster measure on Sj(L) ∩ N = S(L, N) + (j − 1)Le1. Since the last region is a translate of S(L, N),

ψN(Ev | vj = v, T ≥ j, Aj−1) ≤ 1 − α2, by (5.113), and (5.116) is proved.

<a id="sec-5-8"></a>

## 5.8 Uniqueness when $q$ < 1

Only a limited amount is known about the (non-)uniqueness of random-cluster measures on Ld when $q$ < 1, owing to the absence of stochastic ordering and the failure of positive association. By Theorems 4.31 and 4.33, there exists at least one translation-invariant member of coWp,q, and this measure is a DLRrandom-cluster measure. One may glean a little concerning uniqueness from the comparison inequalities, Theorem 3.21, from which we extract the facts that, for the random-cluster measure φG,p,q on a finite graph G = (V, E),

![image 491](../Images/imageFile491.png)

![image 492](../Images/imageFile492.png)

![image 493](../Images/imageFile493.png)

Onemaydeducethefollowingbymakingcomparisonswiththepercolationmodel. (5.119) Theorem. For d ≥ 2, there exists p′ = p′(d) < 1 such that the following holds. Let p ∈ (0,1), q ∈ (0,1], and write π = p/[p + q(1 − p)]. We have that |Wp,q| = |Rp,q| = 1 whenever either θ(π,1) = 0 or $p$ > p′.

Exponential decay holds similarly when q ∈ (0,1) and π < pc(1). That is,

there exists ψ = ψ(p,q) > 0 such that φp0,q(|C| = n) ≤ e−nψ, see the comment in the proof of Theorem 5.55.

Proof7. The proof is similar to that of Proposition 5.30 and is therefore only sketched. Let p, q be such that q ∈ (0,1) and θ(π,1) = 0, and let and be

![image 494](../Images/imageFile494.png)

7See also [8, 156, 281].

132 Phase Transition [5.8]

boxes satisfying ⊆ . A cutset is defined to be a subset S of E \ E such that: every path joining to ∂ uses at least one edge of S, and S is minimal with this property. For a cutset S, we write int S for the set of edges of E possessing no endvertex x such that x ↔ ∂ off S, and we write S = S ∪ int S. There is a partial order on cutsets given by S1 ≤ S2 if S1 ⊆ S2.

Let A ∈ F . Let , be boxes such that ⊆ ⊆ , and let ξ,τ ∈ . By (5.118), there exists a probability measure ψ on {0,1}E × {0,1}E × {0,1}E such that the following hold.

- (i) The set of triples (ω1,ω2,ω3) satisfying ω1 ≤ ω3 and ω2 ≤ ω3 has ψ probability 1.
- (ii) The first marginal of ψ is φ ,ξ p,q, the second marginal restricted to E is φ ,τ p,q, and the third marginal is the product measure φ ,π.
- (iii) Let M denote the maximal cutset of every edge of which is closed in ω3, and note that M exists if and only if ω3 ∈ {∂ ↔/ ∂ }. Conditional on M, the marginal law of both {ω1(e) : e ∈ int M} and {ω2(e) : e ∈ int M} is the free measure φint0 M,p,q.

By conditioning on M, (5.120) φ ,ξ p,q(A) − φ ,τ p,q(A) ≤ φ ,π(∂ ↔ ∂ ).

By Theorem 4.17(a), there exists a probability measure ρ ∈ Wp,q, and we choose τ ∈ and an increasing sequence = ( n : n = 1,2,. . .) such that

φτ n,p,q ⇒ ρ as n → ∞. Suppose thatρ′ ∈ Wp,q and ρ′ = ρ. Thereexists ξ ∈ and an increasing sequence = ( n : n = 1,2,. . .) such that φξ n,p,q ⇒ ρ′.

For m sufficientlylargethat ⊆ m, let n = nm satisfy m ⊆ n. By (5.120) with = m, = n, (5.121) φξ n,p,q(A) − φτ m,p,q(A) ≤ φ n,π(∂ ↔ ∂ m).

Let n → ∞ and m → ∞ in that order. Since θ(π,1) = 0, the right side tends to zero, and therefore ρ′(A) = ρ(A). This holds for all cylinders A, and therefore ρ′ = ρ, a contradiction. It follows that |Wp,q| = 1. An alternative argument uses the method of [117].

Suppose next that φ ∈ Rp,q so that, for any box ,

φ(A | T )(ξ) = φ ,ξ p,q(A) φ-a.s. By (5.120) with = = m and ρ as above, |φ(A) − ρ(A)| = lim

φ(φ(A | T m)) − φτ m,p,q(A) ≤ lim

m→∞

φ m,π(∂ ↔ ∂ m) = 0, whence Rp,$q$ = {ρ}.

m→∞

Asimilarproofofuniquenessisvalidforlarge p, using(5.117)andtheapproach taken for Theorem 5.33(b).

