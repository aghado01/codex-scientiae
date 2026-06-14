[Page 13]

## 6. Rates of Convergence for Random Point Clouds

Persistence homology by itself does not take into account the random nature of data and the intrinsic variability of the topological quantity they infer. We now present a statistical approach to persistent homology, which means that we consider data as generated from an unknown distribution.

6.1. Minimax Upper Bound. Assume that we observe an i.i.d. n -sample X n = { X 1 ,...,X n } in a metric space ( M,ρ ) drawn from an unknown probability measure µ , whose support is a compact set denoted by X µ .

Let Filt( X µ ) and Filt( X ) be two ﬁltrations deﬁned on X µ and X . Starting from Theorem 5.9, a natural strategy for estimating the persistent homology of Filt( X µ ) is to consider that of Filt( X ), where X is an estimator of X µ , meaning that d GH ( X µ , X ) is small.

Remark 6.1. Note that in some cases the space M can be unknown and the observations X 1 ...,X n are then only known through their pairwise distances ( ρ ( X i ,X j )) 1 i,j n . The use of the Gromov-Hausdorﬀ distance allows us to consider this set of observations as an abstract metric space of cardinality n , independently of the way it is embedded in M .

Deﬁnition 6.2 (( a,b )-Standard Measure) . The distribution µ is said to be ( a,b ) -standard if for all x ∈ supp( µ ) and all r 0,

$$
\mu \left ( B ( x , r ) \right ) \geqslant \min ( a r ^ { b } , 1 ) .
$$

The ﬁnite set X n := { X 1 ,...,X n } is a natural estimator of the support X µ . In several contexts discussed in the following, X n shows optimal rates of convergence to X µ with respect to the Hausdorﬀ distance. A slight variant of this assumption has already been used in the previous lessons.

Deﬁnition 6.3 (Statistical Model) . We let P M,a,b denote the set of Borel probability distributions µ over ( M,ρ ) such that

– X µ = supp µ is compact;

µ is ( a,b )-standard.

-µ is ( a, b

The following result gives an upper bound for the rate of convergence of persistence diagrams for ( a,b )-standard measures.

Theorem 6.4 . If µ is ( a,b ) -standard on ( M,ρ ) , then :

- (i) For all ε > 0 ,

$$
\mathbb { P } \left ( d _ { b } \left ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) \right ) > \varepsilon \right ) \leqslant \min \left ( \frac { 2 ^ { b } } { a \varepsilon ^ { b } } \exp ( - n a \varepsilon ^ { b } ) , 1 \right ) .
$$

- (ii) For n large enough,


$$
\sup _ { \mu \in \mathcal { P } _ { M , a , b } } \mathbb { E } _ { \mu } \left [ d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { \mu } ) ) , d g m ( F i l t ( \mathbb { X } _ { n } ) ) ) \right ] \leqslant C _ { a , b } \left ( \frac { \log n } { n } \right ) ^ { 1 / b } .
$$
