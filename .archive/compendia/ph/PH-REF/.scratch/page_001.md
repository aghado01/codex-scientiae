[Page 1]

# PERSISTENT HOMOLOGY

## Contents

|1.|Filtrations| |1|
|---|---|---|---|
|2.|Starting with a Few Examples| |2|
|3.|and Persistence Diagrams| |6|
|4.|Space of Persistence Diagrams| |8|
|5.|Stability| |9|
|5.1.| |A General Result|9|
|5.2.| |Stability for Functions|10|
|5.3.| |Stability for Spaces|11|
|6. Rates of Convergence for Random Point Clouds| | |13|
|6.1.| |Minimax Upper Bound|13|
|6.2.| |Minimax Lower Bound|15|
|7. Persistence Landscapes| | |16|
|7.1.| |Construction|16|
|7.2.| |Stability|17|
|7.3.| |Central Tendency for Persistent Homology|17|
|8. Further Sources| | |19|
|References| | |19|


Persistent homology is a powerful tool to compute, study and encode efﬁciently multiscale topological features of nested families of simplicial complexes and topological spaces. It does not only provide eﬃcient algorithms to compute the Betti numbers of each complex in the considered families, as required for homology inference in the previous section, but also encodes the evolution of the homology groups of the nested complexes across the scales.

## 1. Filtrations

Deﬁnition 1.1 (Filtration) . A ﬁltration of a simplicial complex K is a nested family of subcomplexes ( K r ) r ∈ T , where T ⊂ R , such that for any r,r ∈ T , if r r then K r ⊂ K r , and K = ∪ r ∈ T K r .

More generally, a ﬁltration of a topological space M is a nested family of subspaces ( M r ) r ∈ T , where T ⊂ R , such that for any r,r ∈ T , if r r then M r ⊂ M r and, M = ∪ r ∈ T M r . For example, if f : M → R is a function, then the family M r = f − 1 (( −∞ ,r ]), r ∈ R deﬁnes a ﬁltration called the sublevel set ﬁltration of f .

Remark 1.2. (i) The subset T may be either ﬁnite or inﬁnite.

(ii) In practical situations, the parameter r ∈ T can often be interpreted as a scale parameter and ﬁltrations classically used in TDA often belong to one of the two following families.
