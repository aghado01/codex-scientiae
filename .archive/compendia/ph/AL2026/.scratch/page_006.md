[Page 6]

![In this image we can see a diagram.](<AL2026/imageFile2.png>)














ranks

Fig. 2 An illustration of the formula of persistent Betti numbers and multiplicities in one-parameter persistent homology. The barcodes of the 1 -st persistent homology are shown in blue. The red bar [3 , 4] is the interval that we would like to demonstrate the computation of its multiplicity. The violet bars are intervals along which we take the ranks to recover the multiplicity.

given in ( Asashiba et al. 2017 , Theorem 3) (see Theorem 3.3 for detail) in terms of the dimensions of Hom-spaces Hom k [ P ] ( X,M ) with X ∈ { L,E L ,τ − 1 L } , where there exists a minimal left almost split morphism from L to E L (see also ( Dowbor and Mróz 2007 , Corollary 2.3)). Thus, to apply this formula, we have to know a minimal left almost split morphism f : L → E L , τ − 1 L = Coker f and the dimensions of Hom-spaces above, which are in general hard to do if the computation of the Auslander-Reiten quiver (AR-quiver for short) is not easy. For example, in the finite 2D-grid case, namely when P is the product poset G m,n : = [ m ] × [ n ] for some m,n ≥ 2 , let L be an interval module and M a k [ P ] -module. Then by ( Asashiba et al. 2017 , Propositions 42 and 43), the time complexity of the computation of { f,E L ,τ − 1 L } and that of multiplicity d L ( M ) was given as O ( mnz ω ) and O (((dim M ) ω + mn ) z ω ) , respectively, where z : = min { m,n } and ω < 2 . 373 is the matrix multiplication exponent.

However, when the AR-quiver is known, the general formula can easily be applied. For example, the AR-quiver of k [ P ] for P = [ n ] with n ≥ 1 is well-known, and the formula ( 1.1 ) follows from Theorem 3.3 by computing the dimensions dimHom k [ P ] ( X,M ) in terms of the structure linear maps of M as was shown in ( Asashiba et al. 2017 , Formula (9) in Example 3). Hence Theorem 3.3 can be seen as a generalization of ( 1.1 ).

Concerning the formula ( 1.1 ), the following general question naturally arises: For a given interval I , which structure of M determines the multiplicity d M ( V I ) ? If we find a formula of multiplicities of intervals in terms of the structure linear maps of M analogous to ( 1.1 ), then it will give an answer to the question. However, this kind of formula is not yet given explicitly in the literature. The main purpose of this paper is to give such an explicit formula for the interval multiplicity in the finite poset case. This makes it clear which structure of M is essential to determine the multiplicity d M ( V I ) , and leads to an idea of essential cover explained in the next subsection 1.3 (3). On the other hand, in ( Asashiba et al. 2024 , Lemma 4.8), we developed a way (Lemma 2.10 in the present paper) to compute dimHom k [ P ] ( X,M ) in terms of the structure
