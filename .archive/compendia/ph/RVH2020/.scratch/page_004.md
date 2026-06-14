[Page 4]

As will rapidly become evident, the above results repeatedly exploit connections between ﬁltering in inﬁnite dimension, the statistical mechanics of disordered systems [5], and multidimensional ergodic theory [10, 22]. Some further connections with other probabilistic problems will be discussed in the ﬁnal section 6 of this paper.

The consideration of ﬁltering problems in inﬁnite dimension is far from esoteric. It is a long-standing problem in applied probability to develop eﬃcient algorithms to compute nonlinear ﬁlters in high-dimensional models (current algorithms require a computational eﬀort exponential in the dimension, a severe problem in data assimilation applications). Improved understanding of the ergodic and spatial mixing properties of the ﬁlter may be essential for progress on such practical problems. In recent work [40, 41], we have shown that local ﬁltering algorithms can attain dimension-free approximation errors in models that exhibit conditional decay of correlations. The machinery developed in [40, 41] to investigate high-dimensional ﬁltering problems is complementary to the present paper: the former provides strong quantitative results under strong (‘high-temperature’) assumptions, while our aim here is to address fundamental issues that arise in inﬁnite dimension. Regardless of any practical implications, however, the investigation of emergent phenomena that arise from conditioning is arguably of fundamental interest to the understanding of conditional distributions, and provides a compelling motivation for the investigation of conditional phenomena in probability theory.

## 2 Filtering in inﬁnite dimension

The goal of this section is to set up the basic ﬁltering problem that will be studied in the sequel. We begin by deﬁning a general setting for nonlinear ﬁltering and introduce and discuss the basic ergodicity question in section 2.1. We subsequently introduce our canonical inﬁnite-dimensional ﬁltering model in section 2.2.

## 2.1 Nonlinear ﬁltering and ergodicity

Throughout this paper, we model dynamics with partial information as a Markov chain \( (X_k, Y_k)_{k \ge 0} \) that has the additional property that its transition kernel factorizes as

\[
P [ ( X _ { k } , Y _ { k } ) \in A | X _ { k - 1 } , Y _ { k - 1 } ] = \int 1 _ { A } ( x , y ) \, P ( X _ { k - 1 } , d x ) \, \Phi ( X _ { k - 1 } , x , d y )
\]

for given transition kernels \( P \) and \( \Phi \): the factorization corresponds to the assumption that \( (X_k)_{k \ge 0} \) is a Markov chain in its own right, and that the observations \( (Y_k)_{k \ge 0} \) are conditionally independent given \( (X_k)_{k \ge 0} \). Such models are frequently called hidden Markov models. While not essential for the development of our theory (see, e.g., [45] for a more general setting), the hidden Markov model setting is convenient mathematically and is ubiquitous in practice as a model of noisy observations of random dynamics.

For the time being, we assume that \( X_k \) and \( Y_k \) take values in an arbitrary Polish space (we will define a more concrete infinite-dimensional setting in section 2.2 below). The nonlinear filter is defined as the regular conditional probability

\[
\pi _ { k } \colon = P [ X _ { k } \in \cdot | Y _ { 1 } , \dots , Y _ { k } ] .
\]

We are interested in the question of whether \( (\pi_k)_{k \ge 0} \) inherits the ergodic properties of the underlying dynamics \( (X_k)_{k \ge 0} \). There are several different but closely connected ways to make this question precise (cf. Remark 2.3 below). For concreteness, we will focus attention
