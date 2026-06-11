[Page 715]

Appendix C. Properties of Matrices

In this appendix, we gather together some useful properties and identities involving matrices and determinants. This is not intended to be an introductory tutorial, and it is assumed that the reader is already familiar with basic linear algebra. For some results, we indicate how to prove them, whereas in more complex cases we leave the interested reader to refer to standard textbooks on the subject. In all cases, we assume that inverses exist and that matrix dimensions are such that the formulae are correctly deﬁned. A comprehensive discussion of linear algebra can be found in Golub and Van Loan (1996), and an extensive collection of matrix properties is given by Lutkepohl (1996). Matrix derivatives are discussed in Magnus and Neudecker¨ (1999).

Basic Matrix Identities

A matrix A has elements Aij where i indexes the rows, and j indexes the columns. We use IN to denote the N × N identity matrix (also called the unit matrix), and where there is no ambiguity over dimensionality we simply use I. The transpose matrix AT has elements (AT)ij = Aji. From the deﬁnition of transpose, we have

(AB)T = BTAT (C.1)

which can be veriﬁed by writing out the indices. The inverse of A, denoted A−1, satisﬁes

AA−1 = A−1A = I. (C.2) Because ABB−1A−1 = I, we have

(AB)−1 = B−1A−1. (C.3) Also we have �

�−1

�

A−1�T

=

AT

(C.4)

695
