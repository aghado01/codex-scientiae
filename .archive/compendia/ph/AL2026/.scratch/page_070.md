[Page 70]

![image 20](<AL2026/imageFile20.png>)





{




′′′

,


∈ { 2

,

,

,

}

,






and







=


,



(

: =




∈ { 1

,

,

}

.




′′′


However, Z ′ is not the poset of Dynkin type A .

# 6.3 The case of bipath posets

Recently, Aoki–Escolar–Tada provided a complete classification of posets whose module category only consists of interval-decomposable modules Aoki et al. ( 2023 ). They showed that every persistence module in mod k [ P ] is interval-decomposable if and only if P is either a poset of Dynkin type A or a bipath poset. The former poset is well studied and applied in the one-parameter persistent homology, while the latter is not commonly considered in the multi-parameter setting. They subsequently investigated the so-called bipath persistent homology in Aoki et al. ( 2024 ). To obtain the visualization of the bipath persistence diagram, decomposing the bipath persistent homology in each dimension becomes the central task. In this subsection, we would apply our formula to compute the multiplicities of interval modules in the bipath poset setting, and inspired by the obtained formulas, we propose an alternate way of computing the bipath persistence diagram in the practical TDA pipeline, without obtaining the bipath persistent homology.

To begin with, we review the definition of bipath poset. Let n,m ∈ Z ≥ 1 . Then the bipath poset B n,m is defined to be a poset having the following Hasse quiver:

![image 21](<AL2026/imageFile21.png>)

···




.








···




We set [ m ] ′ : = { 1 ′ ,...,m ′ } . The full subposet U : = { ˆ 0 , ˆ 1 }⊔ [ n ] (resp. D : = { ˆ 0 , ˆ 1 }⊔ [ m ] ′ ) is called the upper (resp. lower ) path of B n,m . In the sequel, we would let the ambient poset P be B n,m . It is easy to check the interval I of B n,m belongs to the following five types:

- (i) I = B n,m .
- (ii) I : = [ s,t ] : = { x ∈ B n,m | s ≤ x ≤ t } for some s,t ∈ [ n ] . We write I u to denote the set of all intervals having this type.
