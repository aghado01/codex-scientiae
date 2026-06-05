[Page 718]

Similarly

∂A ∂x

∂B ∂x

∂ ∂x

(AB) =

B + A

. (C.20) The derivative of the inverse of a matrix can be expressed as

∂ ∂x

A−1 = −A−1∂A ∂x

A−1 (C.21)

as can be shown by differentiating the equation A−1A = I using (C.20) and then right multiplying by A−1. Also

ln|A| = Tr A−1∂A ∂x

∂ ∂x

(C.22)

which we shall prove later. If we choose x to be one of the elements of A, we have

∂ ∂Aij

Tr(AB) = Bji (C.23)

as can be seen by writing out the matrices using index notation. We can write this result more compactly in the form

###### ∂ ∂A

Tr(AB) = BT. (C.24) With this notation, we have the following properties

###### ∂ ∂A

Tr ATB = B (C.25)

###### ∂ ∂A

Tr(A) = I (C.26) ∂ ∂A

Tr(ABAT) = A(B + BT) (C.27) which can again be proven by writing out the matrix indices. We also have

###### ∂ ∂A

ln|A| = A−1 T (C.28) which follows from (C.22) and (C.26).

###### Eigenvector Equation

For a square matrix A of size M × M, the eigenvector equation is deﬁned by

Aui = λiui (C.29)
