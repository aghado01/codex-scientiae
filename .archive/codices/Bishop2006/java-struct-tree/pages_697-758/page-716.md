[Page 716]

which is easily proven by taking the transpose of (C.2) and applying (C.1). A useful identity involving matrix inverses is the following

(P−1 + BTR−1B)−1BTR−1 = PBT(BPBT + R)−1. (C.5)

which is easily veriﬁed by right multiplying both sides by (BPBT + R). Suppose that P has dimensionality N × N while R has dimensionality M × M, so that B is M × N. Then if M � N, it will be much cheaper to evaluate the right-hand side of (C.5) than the left-hand side. A special case that sometimes arises is

(I + AB)−1A = A(I + BA)−1. (C.6) Another useful identity involving inverses is the following:

(A + BD−1C)−1 = A−1 − A−1B(D + CA−1B)−1CA−1 (C.7)

which is known as the Woodbury identity and which can be veriﬁed by multiplying both sides by (A + BD−1C). This is useful, for instance, when A is large and diagonal, and hence easy to invert, while B has many rows but few columns (and conversely for C) so that the right-hand side is much cheaper to evaluate than the left-hand side.

� A set of vectors {a1,...,aN} is said to be linearly independent if the relation

n αnan = 0 holds only if all αn = 0. This implies that none of the vectors can be expressed as a linear combination of the remainder. The rank of a matrix is the maximum number of linearly independent rows (or equivalently the maximum number of linearly independent columns).

Traces and Determinants

Trace and determinant apply to square matrices. The trace Tr(A) of a matrix A is deﬁned as the sum of the elements on the leading diagonal. By writing out the indices, we see that

Tr(AB) = Tr(BA). (C.8) By applying this formula multiple times to the product of three matrices, we see that Tr(ABC) = Tr(CAB) = Tr(BCA) (C.9)

which is known as the cyclic property of the trace operator and which clearly extends to the product of any number of matrices. The determinant |A| of an N × N matrix A is deﬁned by

�

(±1)A1i

|A| =

(C.10)

2 ···ANi

A2i

1

N

in which the sum is taken over all products consisting of precisely one element from each row and one element from each column, with a coefﬁcient +1 or −1 according
