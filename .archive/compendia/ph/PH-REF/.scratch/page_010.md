[Page 10]

Deﬁnition 5.2. Let δ 0. Two persistence modules V , W are δ -interleaved if there exists two homomorphism of degree δ , Φ, from V to W and Ψ, from W to V such that ΨΦ = 1 2 δ V and ΦΨ = 1 2 δ W .

![image 9](<PH-REF/imageFile9.png>)


-




+


+

+

/

/

/

/




+



-





=

=

=

=



-




+





-






-





!

!

!

!



-




+



/

/

/

/




+



-







-




+


Although it does not deﬁne a metric on the space of persistence modules, the notion of closeness between two persistence modules may be deﬁned as the smallest non negative δ such that they are δ -interleaved. Moreover, it allows to formalize the following fundamental result.

Theorem 5.3 (Stability of Persistence) . Let V and W be two q-tame persistence modules. If V and W are δ -interleaved for some δ 0 , then

$$
d _ { b } ( d g m ( \mathbb { V } ) , d g m ( \mathbb { W } ) ) \leqslant \delta .
$$

Proof.

$$
P r o f . \, \text { See } [ \text {CdSGO116} ] . & & \Box
$$

Remark 5.4. One can actually show that there is an isometry between q-tame persistence modules a purely algebraic construction —, and persistence diagrams points above the diagonal [CdSGO16]. Indeed, deﬁning the interleaving distance as

$$
d _ { i } ( \mathbb { V } , \mathbb { W } ) = \inf \left \{ \delta > 0 | \mathbb { V } \text { and } \mathbb { W } \text { are } \delta \text {-interleaved} \right \} ,
$$

we have, for all q-tame persistence modules V and W ,

$$
d _ { b } ( d g m ( \mathbb { V } ) , d g m ( \mathbb { W } ) ) = d _ { i } ( \mathbb { V } , \mathbb { W } ) .
$$

5.2. Stability for Functions. Although purely algebraic and rather abstract, this result is an eﬃcient tool to easily establish concrete stability results such as the following.

Deﬁnition 5.5 (q-Tame Function) . Let f : M → R be a real-valued functions deﬁned on a topological space M . We say that f is q-tame if the sublevel sets ﬁltrations of f induces a q-tame module at the homology level.

Proposition 5.6 . If f : M → R is continuous and M is ﬁnitely triangulable (i.e. homeomorphic to a ﬁnite simplicial complex), then f is q-tame.

Proof. Fpr simplicity, let us write M r = f − 1 (( −∞ ,r ]), for r ∈ R . For all b < c , we must show that H ( M b ) → H ( M c ) has ﬁnite rank. Begin with any ﬁnite triangulation of M , and subdivide it repeatedly until no simplex meets both f − 1 ( b ) and f − 1 ( c ). If we deﬁne K to be the union of the closed simplices which meet M b , then we have

$$
M _ { b } \subset \mathcal { K } \subset M _ { c } ,
$$
