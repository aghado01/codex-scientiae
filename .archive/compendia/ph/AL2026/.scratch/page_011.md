[Page 11]

Finally, we will provide several examples to demonstrate the use of essential-cover technique. In Example 6.1 we show how to compute the interval multiplicity in 2Dgrid case from the level of filtration. Example 6.3 shows that in some cases, the essential cover of intervals starts from a directed tree formed by connecting several zigzag posets, not a single zigzag poset. In Examples 6.4 and 6.5 we compute the interval multiplicity in another type of posets, namely the posets of Dynkin type D . Furthermore, we investigate the computation in bipath posets , the posets that always possess the interval decomposability studied initially by Aoki et al. ( 2023 ). We propose an alternative way of computing the bipath persistence diagram from a given bipath filtration. Compared with the original algorithm provided in Aoki et al. ( 2024 ), an advantage of our approach is that we do not need to do the basis changes at the global minimum and maximum of bipath poset.

# 1.4 Organization

We outline the paper as follows. In Section 2 , we will introduce some preliminaries. In Section 3 , we will give the formula for computing the interval multiplicities in the general finite poset setting (Section 3.1 ), and particularly in the 2D-grid setting (Section 3.2 ). 3.2 has a simpler formula and easier to grasp than 3.1 . The reader may read 3.2 first by looking at Example 3.37 to have a rough outline. It contains enough information to apply the formula for 2D-grids. The details of proofs written in 3.1 can be read afterward. In Section 4 , we develop the essential-cover technique for the sake of practical data analysis. In Section 5 , we give formulas for computing interval multiplicities by using (co)presentations. In Section 6 , we show some examples of the use of essential-cover technique in different types of underlying posets.

# 2 Preliminaries

Throughout this paper, k is a field, P = ( P , ≤ ) is a finite poset. The category of finite-dimensional k -vector spaces is denoted by mod k .

Definition 2.1. A k -linear category C is said to be finite if it has only finitely many objects and for each pair ( x,y ) of objects, the Hom-space C ( x,y ) is finite-dimensional.

Covariant functors C → mod k are called left C -modules . They together with natural transformations between them as morphisms form a k -linear category, which is denoted by mod C .

Similarly, contravariant functors C → mod k are called right C -modules , which are usually identified with covariant functors C op → mod k . The category of right C -modules is denoted by mod C op .

We denote by D the usual k -duality Hom k (, k ) , which induces the duality functors mod C → mod C op and mod C op → mod C .
