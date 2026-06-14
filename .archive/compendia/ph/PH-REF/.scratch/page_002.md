[Page 2]

Example 1.3 (Filtrations Built on Top of Data) . Given a subset X of a compact metric space ( M,ρ ), the families of Rips-Vietoris complexes (Rips( X ,r )) r ∈ R and and ˇ Cech complexes ( ˇ Cech( X ,r )) r ∈ R are ﬁltrations 1 . Here, the parameter r can be interpreted as a resolution at which one considers the data set X . d

In particular, if X is a point cloud in R , thanks to the Nerve theorem, the ﬁltration ( ˇ Cech( X ,r )) r ∈ R encodes the topology of the whole family of unions of balls X r = ∪ x ∈ X B( x,r ), as r goes from 0 to + ∞ .

Example 1.4 (Sublevel Sets Filtrations) . Functions deﬁned on the vertices of a simplicial complex give rise to another important example of ﬁltration: let K be a simplicial complex with vertex set V and f : V → R . Then f can be extended to all simplices of K by f ([ v 0 , ··· ,v k ]) = max 1   i   k f ( v i ) for any simplex σ = [ v 0 , ··· ,v k ] ∈ K . The family of subcomplexes K r = { σ ∈ K| f ( σ )   r } deﬁnes a ﬁltration call the sublevel set ﬁltration of f . Similarly, one can deﬁne the upperlevel set ﬁltration of f .

In practice, even if the index set is inﬁnite, all the considered ﬁltrations are built on ﬁnite sets and are indeed ﬁnite. For example, when X is ﬁnite, the Vietoris-Rips complex Rips( X ,r ) changes only at a ﬁnite number of indices r . This allows to easily handle them from an algorithmic perspective.

## 2. Starting with a Few Examples

Given a ﬁltration Filt = ( F r ) r ∈ T of a simplicial complex or a topological space, the homology of F r changes as r increases: new connected components can appear, existing component can merge, loops and cavities can appear or be ﬁlled, etc. Persistent homology tracks these changes, identiﬁes the appearing features and associates a life time to them. The resulting information is encoded as a set of intervals called a barcode or, equivalently, as a multiset of points in R 2 where the coordinate of each point is the starting and end point of the corresponding interval.

Before giving formal deﬁnitions, we introduce and illustrate persistent homology on three simple examples.

Example 2.1 (Smooth Real Function) . Let f : [0 , 1] → R be the function of Figure 1 and let ( F r = f − 1 (( −∞ ,r ])) r ∈ R be the sublevel set ﬁltration of f .

( a 1 ) All the sublevel sets of f are either empty or a union of interval, so the only non trivial topological information they carry is their 0-dimensional homology, i.e. their number of connected components. For r < a 1 , F r is empty, but at r = a 1 a ﬁrst connected component appears in F a 1 . Persistent homology thus registers a 1 as the birth time of a connected component and start to keep track of it by creating an interval starting at a 1 .

( a 2 ) Then, F r remains connected until r reaches the value a 2 where a second connected component appears. Persistent homology starts to keep track of this new connected component by creating a second interval starting at a 2 .

1 we take here the convention that for r < 0, Rips( X , r ) = ˇ Cech( X , r ) = ∅
