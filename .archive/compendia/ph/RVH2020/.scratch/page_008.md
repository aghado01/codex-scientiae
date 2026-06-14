[Page 8]

$$
X _ { k } = ( X _ { k } ^ { v } ) _ { v \in \mathbb { Z } ^ { d } } \in E ^ { \mathbb { Z } ^ { d } } \quad \text {and} \quad Y _ { k } = ( Y _ { k } ^ { v } ) _ { v \in \mathbb { Z } ^ { d } } \in F ^ { \mathbb { Z } ^ { d } } .
$$

Each \( v \in \mathbb{Z}^d \) should be viewed as a single ‘dimension’ of the model. 2 We now deﬁne a hidden Markov model that respects the spatial structure of the problem by assuming that both the underlying dynamics and the observations are local : that is, we assume that the transition and observation kernels P and Φ factorize as

$$
P ( x , d z ) = \prod _ { v \in \mathbb { Z } ^ { d } } P ^ { v } ( x , d z ^ { v } ) , \quad \Phi ( x , z , d y ) = \prod _ { v \in \mathbb { Z } ^ { d } } \Phi ^ { v } ( x , z , d y ^ { v } ) ,
$$

where

$$
P ^ { v } ( x , A ) \ \text { and } \ \Phi ^ { v } ( x , z , B ) \ \text { depend only on } x ^ { w } , z ^ { w } \text { for } \| w - v \| \leq 1 .
$$

Such a model should be viewed as a hidden Markov model counterpart of probabilistic cellular automata [30] or interacting particle systems [31] that have been widely investigated in the literature as natural models of space-time dynamics. Alternatively, one might view such a model as an inﬁnite collection \( (X_k^v, Y_k^v)_{k \ge 0} \) of hidden Markov models whose dynamics and observations are locally coupled to their neighbors in \( \mathbb{Z}^d \).

While problems of this type have been rarely considered in ﬁltering theory, the inﬁnitedimensional model that we have formulated is in principle a special case of the general model described in the previous section. However, its structure is such that the assumptions of a result such as Theorem 2.2 typically cannot hold. Let us consider, for example, the setting where each local observation Y v has a positive density of the form \( \Phi^v(x, z, dy^v) = g(z^v, y^v) \phi(dy^v) \), so that the observations are locally nondegenerate. Choose two values \( e, e' \in E \) such that \( g(e, \cdot) = g(e', \cdot) \), and deﬁne the constant conﬁgurations \( z, z' \) as \( z^v = e \) and \( z^v = e' \) for all \( v \in \mathbb{Z}^d \). Then the measures \( \Phi(x, z, \cdot) \) and \( \Phi(x, z', \cdot) \) are two distinct laws of an inﬁnite number of i.i.d. random variables, and are therefore mutually singular. This immediately rules out the possibility that the observations are nondegenerate in the sense of Theorem 2.2. It is precisely this problem that lies at the heart of the diﬃculties in inﬁnite-dimensional models: probability measures in inﬁnite dimension are typically mutually singular, even when they admit densities locally (that is, for any ﬁnite-dimensional marginal). In the absence of densities, classical results in ﬁltering theory cannot be taken for granted, and the study of ﬁltering in inﬁnite dimension gives rise to fundamentally diﬀerent problems than have been studied in the literature to date. We initiate the investigation of such problems in the sequel.

Remark 2.5. The singularity of measures in infinite dimension is problematic not only for the nondegeneracy of observations, but also for the ergodic theory of Markov chains. For example, the uniform stability property in Theorem 2.2 will rarely hold in infinite dimension: it is often the case that the law of \( X_k \) is singular with respect to \( \lambda \) for all \( k < \infty \), which rules out total variation convergence (see [46, Example 2.3] for a simple illustration). However, this issue is surmounted in [46] using a form of localization: by performing the analysis of Theorem 2.2 locally (that is, to finite-dimensional projections of the original model), we can avoid the singularity of the full infinite-dimensional problem. This allows to extend the conclusion of Theorem 2.2 to a wide range of infinite-dimensional models with nondegenerate observations. In practice, this implies that much of the classical filtering theory extends, at least in spirit, to models where \( X_k \) is infinite-dimensional but \( Y_k \) is (effectively) finite-dimensional. It is only when the observations \( Y_k \) are also infinitedimensional that new phenomena arise.

2 The present setting is easily extended to the setting of more general locally ﬁnite graphs and to the setting where each location \( v \) may possess a diﬀerent local state space \( E_v \). Such an extension does not illuminate signiﬁcantly the phenomena that will be investigated in the sequel. On the other hand, a nontrivial extension of substantial interest in applications is to continuous inﬁnite-dimensional models such as stochastic partial diﬀerential equations, cf. [44]. While we do not investigate such models here, the present setting may be viewed as prototypical for more complicated models of this type, see [40] for further discussion.
