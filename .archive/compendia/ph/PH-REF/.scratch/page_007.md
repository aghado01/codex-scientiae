[Page 7]

![image 6](<PH-REF/imageFile6.png>)

Figure 3. The set X = { 0 } ∪ n 1 { 1 /n } is compact, but β 0 ( X ) = ∞ and its oﬀsets ( X r ) r 0 are naturally indexed by the inﬁnite set T = R .

{ 1 /n } (see Figure 3). However, it is possible to show that persistence diagrams can be deﬁned as soon as the following simple condition is satisﬁed.

Deﬁnition 3.5 (q-tameness) . A persistence module V indexed by T ⊂ R is q-tame if for any r < s in T , the rank of the linear map v r s : V r → V s is ﬁnite.

Theorem 3.6 ([CdSGO16]) . If V is a q-tame persistence module, then it has a well-deﬁned persistence diagram.

Remark 3.7. (i) Theorem 3.6 is pretty strong, since its shows that the diagram is well-deﬁned, even though V may not be interval-decomposable.

- (ii) Such a persistence diagram dgm( V ) is the union of the points of the diagonal ∆ of R 2 , counted with inﬁnite multiplicity, and a multi-set above the diagonal in R 2 that is locally ﬁnite. Here, by locally ﬁnite we mean that for any rectangle R with sides parallel to the coordinate axes that does not intersect ∆, the number of points of dgm( V ), counted with multiplicity, contained in R is ﬁnite.
- (iii) (Insights on q-tameness) One can check [CdSGO16, Corollary 2.2] that the number of points in any rectangle [ a,b ] × [ c,d ] above the diagonal ( a b c d ) corresponds to rank( v c b ) − rank( v d b )+rank( v d a ) − rank( v c a ). Letting a → −∞ and d → ∞ , we get that the number of points in the quadrant ( −∞ ,b ] × [ c, ∞ ) is ﬁnite whenever c > b , explaining the term q-tame .


The construction of persistence diagrams of q-tame modules is beyond the scope of this lesson but it gives rise to the same notion as in the case of decomposable modules. It can be done either by following the algebraic approach based upon the decomposability properties of modules, or by adopting a measure theoretic approach that allows to deﬁne diagrams as integer valued measures on a space of rectangles in the plane. We refer the reader to [CdSGO16] for more information. Although persistence modules encountered in practice are decomposable, the general framework of q-tame persistence module plays a fundamental role in the mathematical and statistical analysis of persistent homology.
