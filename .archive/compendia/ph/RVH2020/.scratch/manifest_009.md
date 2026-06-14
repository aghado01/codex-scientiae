# Manifest: Page 009

## REPAIR_MATH
- RAW: ```
X _ { k } = ( X _ { k } ^ { v } ) _ { v \in \mathbb { Z } } \in \{ - 1 , 1 \} ^ { \mathbb { Z } } \quad \text {and} \quad Y _ { k } = ( \bar { Y } _ { k } ^ { v } , \hat { Y } _ { k } ^ { v } ) _ { v \in \mathbb { Z } } \in ( \{ - 1 , 1 \} \times \{ - 1 , 1 \} ) ^ { \mathbb { Z } }
```
  FIX: ```
\[
X _ { k } = ( X _ { k } ^ { v } ) _ { v \in \mathbb { Z } } \in \{ - 1 , 1 \} ^ { \mathbb { Z } } \quad \text {and} \quad Y _ { k } = ( \bar { Y } _ { k } ^ { v } , \hat { Y } _ { k } ^ { v } ) _ { v \in \mathbb { Z } } \in ( \{ - 1 , 1 \} \times \{ - 1 , 1 \} ) ^ { \mathbb { Z } }
\]
```
- RAW: ```
( X _ { k } ^ { v } ) _ { k , v \in \mathbb { Z } } \text { are } i . i . d . \text { with } P [ X _ { k } ^ { v } = 1 ] = 1 / 2 ,
```
  FIX: ```
\[
( X _ { k } ^ { v } ) _ { k , v \in \mathbb { Z } } \text { are } i . i . d . \text { with } P [ X _ { k } ^ { v } = 1 ] = 1 / 2 ,
\]
```
- RAW: ```
\bar { Y } _ { k } ^ { v } = X _ { k } ^ { v } X _ { k - 1 } ^ { v } \bar { \xi } _ { k } ^ { v } , \quad \hat { Y } _ { k } ^ { v } = X _ { k } ^ { v } X _ { k } ^ { v + 1 } \hat { \xi } _ { k } ^ { v } ,
```
  FIX: ```
\[
\bar { Y } _ { k } ^ { v } = X _ { k } ^ { v } X _ { k - 1 } ^ { v } \bar { \xi } _ { k } ^ { v } , \quad \hat { Y } _ { k } ^ { v } = X _ { k } ^ { v } X _ { k } ^ { v + 1 } \hat { \xi } _ { k } ^ { v } ,
\]
```

## REPAIR_PROSE
- RAW: ```
Remark 2.6. Let us note that we have used the term ‘inﬁnite-dimensional’ to denote the situation where there are inﬁnitely many independent degrees of freedom, which is the key issue in our setting. The problem of dimension is unrelated to the linear algebraic or metric dimension of the state space: indeed, even each of the local state spaces E and F in our model can itself be an arbitrary Polish space. Conversely, it is possible to have inﬁnitedimensional systems that are ‘eﬀectively ﬁnite-dimensional’ in the sense that only ﬁnitely many degrees of freedom carry signiﬁcant information. This is common, for example, in stochastic partial diﬀerential equations (see, e.g., [46]).
```
  FIX: ```
Remark 2.6. Let us note that we have used the term ‘infinite-dimensional’ to denote the situation where there are infinitely many independent degrees of freedom, which is the key issue in our setting. The problem of dimension is unrelated to the linear algebraic or metric dimension of the state space: indeed, even each of the local state spaces \( E \) and \( F \) in our model can itself be an arbitrary Polish space. Conversely, it is possible to have infinite-dimensional systems that are ‘effectively finite-dimensional’ in the sense that only finitely many degrees of freedom carry significant information. This is common, for example, in stochastic partial differential equations (see, e.g., [46]).
```
- RAW: ```
At the same time, it should be noted that even in ﬁnite-dimensional systems where results such as Theorem 2.2 technically apply, the qualitative information contained in such statements may be misleading from the practical point of view: in ﬁnite but highdimensional systems, phenomena that arise qualitatively in inﬁnite dimension are still manifested in a quantitative fashion (see [40] for quantitative results and discussion on ﬁltering in high dimension). For example, if the ﬁlter is not stable for the inﬁnite-dimensional model, it will often still be the case that the ﬁlter is stable for every ﬁnite-dimensional truncation of the model; however, the quantitative rate of stability will vanish rapidly as the dimension is increased. Conversely, if the ﬁlter is stable for the inﬁnite-dimensional model, then the rate of stability of the ﬁlter for the ﬁnite-dimensional models will be dimension-free. As it is ultimately the quantitative behavior of ﬁltering algorithms that is of importance in practice, the qualitative phenomena investigated here in inﬁnite dimension can still provide more insight into the behavior of practical ﬁltering problems in high dimension than classical results in ﬁltering theory.
```
  FIX: ```
At the same time, it should be noted that even in finite-dimensional systems where results such as Theorem 2.2 technically apply, the qualitative information contained in such statements may be misleading from the practical point of view: in finite but high-dimensional systems, phenomena that arise qualitatively in infinite dimension are still manifested in a quantitative fashion (see [40] for quantitative results and discussion on filtering in high dimension). For example, if the filter is not stable for the infinite-dimensional model, it will often still be the case that the filter is stable for every finite-dimensional truncation of the model; however, the quantitative rate of stability will vanish rapidly as the dimension is increased. Conversely, if the filter is stable for the infinite-dimensional model, then the rate of stability of the filter for the finite-dimensional models will be dimension-free. As it is ultimately the quantitative behavior of filtering algorithms that is of importance in practice, the qualitative phenomena investigated here in infinite dimension can still provide more insight into the behavior of practical filtering problems in high dimension than classical results in filtering theory.
```
- RAW: ```
The goal of this section is to develop a simple example of the general inﬁnite-dimensional setting of section 2.2 where we observe nontrivial behavior of the inheritance of ergodicity. This model, to be described presently, is a natural inﬁnite-dimensional variation on Blackwell’s counterexample (Example 2.1 above).
```
  FIX: ```
The goal of this section is to develop a simple example of the general infinite-dimensional setting of section 2.2 where we observe nontrivial behavior of the inheritance of ergodicity. This model, to be described presently, is a natural infinite-dimensional variation on Blackwell’s counterexample (Example 2.1 above).
```
- RAW: ```
are binary random ﬁelds in one spatial dimension. We let
```
  FIX: ```
are binary random fields in one spatial dimension. We let
```
