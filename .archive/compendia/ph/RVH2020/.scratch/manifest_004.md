# Manifest: Page 004

## REPLACE_TABLES

## REPAIR_MATH
- RAW: ```
$$
P [ ( X _ { k } , Y _ { k } ) \in A | X _ { k - 1 } , Y _ { k - 1 } ] = \int 1 _ { A } ( x , y ) \, P ( X _ { k - 1 } , d x ) \, \Phi ( X _ { k - 1 } , x , d y )
$$
```
  FIX: ```
\[
P [ ( X _ { k } , Y _ { k } ) \in A | X _ { k - 1 } , Y _ { k - 1 } ] = \int 1 _ { A } ( x , y ) \, P ( X _ { k - 1 } , d x ) \, \Phi ( X _ { k - 1 } , x , d y )
\]
```
- RAW: ```
$$
\pi _ { k } \colon = P [ X _ { k } \in \cdot | Y _ { 1 } , \dots , Y _ { k } ] .
$$
```
  FIX: ```
\[
\pi _ { k } \colon = P [ X _ { k } \in \cdot | Y _ { 1 } , \dots , Y _ { k } ] .
\]
```

## REPAIR_PROSE
- RAW: ```
Throughout this paper, we model dynamics with partial information as a Markov chain ( X k ,Y k ) k ≥ 0 that has the additional property that its transition kernel factorizes as
```
  FIX: ```
Throughout this paper, we model dynamics with partial information as a Markov chain \( (X_k, Y_k)_{k \ge 0} \) that has the additional property that its transition kernel factorizes as
```
- RAW: ```
for given transition kernels P and Φ: the factorization corresponds to the assumption that ( X k ) k ≥ 0 is a Markov chain in its own right, and that the observations ( Y k ) k ≥ 0 are conditionally independent given ( X k ) k ≥ 0 . Such models are frequently called hidden Markov models . While not essential for the development of our theory (see, e.g., [45] for a more general setting), the hidden Markov model setting is convenient mathematically and is ubiquitous in practice as a model of noisy observations of random dynamics.
```
  FIX: ```
for given transition kernels \( P \) and \( \Phi \): the factorization corresponds to the assumption that \( (X_k)_{k \ge 0} \) is a Markov chain in its own right, and that the observations \( (Y_k)_{k \ge 0} \) are conditionally independent given \( (X_k)_{k \ge 0} \). Such models are frequently called hidden Markov models. While not essential for the development of our theory (see, e.g., [45] for a more general setting), the hidden Markov model setting is convenient mathematically and is ubiquitous in practice as a model of noisy observations of random dynamics.
```
- RAW: ```
For the time being, we assume that X k and Y k take values in an arbitrary Polish space (we will deﬁne a more concrete inﬁnite-dimensional setting in section 2.2 below). The nonlinear ﬁlter is deﬁned as the regular conditional probability
```
  FIX: ```
For the time being, we assume that \( X_k \) and \( Y_k \) take values in an arbitrary Polish space (we will define a more concrete infinite-dimensional setting in section 2.2 below). The nonlinear filter is defined as the regular conditional probability
```
- RAW: ```
We are interested in the question of whether ( π k ) k ≥ 0 inherits the ergodic properties of the underlying dynamics ( X k ) k ≥ 0 . There are several diﬀerent but closely connected ways to make this question precise (cf. Remark 2.3 below). For concreteness, we will focus attention
```
  FIX: ```
We are interested in the question of whether \( (\pi_k)_{k \ge 0} \) inherits the ergodic properties of the underlying dynamics \( (X_k)_{k \ge 0} \). There are several different but closely connected ways to make this question precise (cf. Remark 2.3 below). For concreteness, we will focus attention
```
