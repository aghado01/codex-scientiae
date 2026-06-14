[Page 64]

which coincides with the formula above in the case where sk 1 ( I ) = ∅ = sk( ⇓ I ) , and g 2 is an empty matrix. □

When applying Theorem 5.16 , the same remark as Remark 5.8 on the order of direct summands should be kept in mind.

# 6 Examples

We first provide an example to explain how to use the essential-cover technique to compute interval multiplicities from the filtration level.

# 6.1 The case of 2D-grids

Example 6.1. Let P = G 5 , 2 and let F be a P -filtration shown in Fig. 4 , page 65 . Set M : = H 1 (-; Z / 2 Z ) ◦ F . We compute the interval multiplicity of V I in M where

$$
\[
\[
I \coloneqq \bigcup _ { ( 2 , 1 ) } ( 1 , 2 ) \longrightarrow ( 2 , 2 ) \longrightarrow ( 3 , 2 ) \\ I \colon = \bigcup _ { ( 2 , 1 ) } \bigcup _ { \longrightarrow ( 3 , 1 ) } \bigcup _ { \longrightarrow ( 4 , 1 ) } \dots \longrightarrow ( 4 , 1 ) \longrightarrow ( 5 , 1 )
\]
\]
$$

.

To make the notations of morphisms in k [ P ] short, we denote each vertex ( i,j ) of P simply by ij . By suitable choice maps, we have the following multiplicity matrix for I :

$$
\[
\[
g = \begin{bmatrix} p _ { 2 2 , 2 1 } & - p _ { 2 2 , 1 2 } & 0 & 0 \\ 0 & p _ { 4 2 , 1 2 } & 0 & 0 \\ 0 & 0 & p _ { 5 1 , 1 1 } & p _ { 5 1 , 3 1 } \\ p _ { 3 2 , 2 1 } & 0 & 0 & - p _ { 3 2 , 3 1 } \end{bmatrix} .
\]
\]
$$

By looking at the entries of g , we define a subposet Z of P by

![image 9](<AL2026/imageFile9.png>)

$$
\[
Z := \{(1 , 2), (2 , 2), (3 , 2), (4 , 2), (1 , 1), (2 , 1), (3 , 1), (5 , 1)\} ,
\]
$$

which is a finite zigzag poset. Then by Definition 4.12, the inclusion map ζ : Z ↪ → P essentially covers I . Note that R ( V I ) turns out to be the interval module V I ′ over k [ Z ] , where I ′ is given by or equivalently, the dimension vector of V I ′ is [ 1110 0111 ] . Then by Theorem 4.16, we have d M ( V I ) = d R ( M ) ( V I ′ ) . Thus the problem is reduced to the computation of d R ( M ) ( V I ′ ) , the multiplicity of V I ′ in the barcodes of the zigzag persistence module R ( M ) = H 1 (-; Z / 2 Z ) ◦ F ◦ ζ , where F ◦ ζ =: F ′ is a Z -filtration shown in Fig. 5, page 65, in which arrows represent inclusions. This kind of problem is already solved in the filtration level (for instance, see Dey and Hou (2022); Milosavljević et al. (2011); Carlsson et al. (2009)).
