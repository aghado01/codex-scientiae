[Page 3]

Except for only a few cases, the category of d -dimensional persistence modules has infinitely many indecomposables up to isomorphism if d > 1 Leszczyński ( 1994 ); Bauer et al. ( 2020 ). In these cases, dealing with all indecomposable persistence modules is very difficult and is usually inefficient.

For the practical analysis, analog to the one-parameter persistence case, one can also restrict to the well-defined interval modules in the general poset setting as intervals encode lifetimes of topological features emerging from data and admit simple characterizations. On the other hand, the multiplicity of interval modules plays a key role in relating other invariants. For example, the interval rank invariants defined in Asashiba et al. ( 2024 ) can be interpreted as the multiplicity of some interval module after the restriction. Therefore, computing the multiplicity of each interval summand 1 of a given persistence module over P becomes a central task.

# 1.1 Notation conventions

Throughout this paper, we fix a field k , and all vector spaces are assumed to be over k , and the word “linear” always means “ k -linear”. The category of finite-dimensional vector spaces is denoted by mod k . We always assume the tameness on the filtration. For each positive integer n , we set [ n ] : = { 1 , 2 ,...,n } .

We also fix a finite poset P and regard it as a category in an obvious way, and for any x, y ∈ P with x ≤ y , a unique morphism x → y is denoted by p y,x . Then the incidence category k [ P ] of P is defined as a linearization of the category P (see Definition 2.2 ). Each functor F : P → mod k is uniquely extended to a linear functor ¯ F : k [ P ] → mod k . Therefore, we identify F with ¯ F , and denote it simply by F .

Let C be a linear category with only a finite number of objects. Then covariant (resp. contravariant) functors C → mod k are called finite-dimensional left (resp. right) modules over C or shortly left (resp. right) C -modules, the category of which is denoted by mod C (resp. mod C op ). We usually consider finite-dimensional left modules and call them simply modules unless otherwise stated. In this paper, modules over the incidence category of a finite poset will be called persistence modules. By the Krull-Schmidt Theorem, every persistence module M is uniquely decomposed into indecomposables up to isomorphism, which gives the multiplicity of each indecomposable L , denoted by d M ( L ) , in the decomposition of M (see Theorem 2.6 ).

A full subposet I of P is called an interval if it is convex in P and connected (see Definition 2.3 ). The set of all intervals of P is denoted by I . Each I ∈ I defines an indecomposable k [ P ] -module V I with support I , which is called an interval module (see Definition 2.5 ). A persistence module is said to be interval-decomposable if it is isomorphic to the direct sum of a finite number of interval modules. In what follows, we call d M ( L ) the interval multiplicity of L in M if L is an interval module.

The following is necessary to state our main results.

Notation 1.1. (1) Let x ∈ P , and I an interval of P . We set ↑ x : = { y ∈ P | x ≤ y } (resp. ↓ x : = { y ∈ P | y ≤ x } ), and call it the up-set (resp. down-set ) of x . In

1 A direct summand is sometimes called just a summand for short in this paper.
