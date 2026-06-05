[Page 716]

A useful identity involving matrix inverses is the following

$$
( P ^ { - 1 } + B ^ { T } R ^ { - 1 } B ) ^ { - 1 } B ^ { T } R ^ { - 1 } = P B ^ { T } ( B P B ^ { T } + R ) ^ { - 1 } . \quad ( C . 5 )
$$

which is easily veriﬁed by right multiplying both sides by ( BPB T + R ) . Suppose that P has dimensionality N × N while R has dimensionality M × M , so that B is M × N . Then if M N , it will be much cheaper to evaluate the right-hand side of (C.5) than the left-hand side. A special case that sometimes arises is

$$
( I + A B ) ^ { - 1 } A = A ( I + B A ) ^ { - 1 } . & & ( C . 6 )
$$

Another useful identity involving inverses is the following:

$$
( A + B D ^ { - 1 } C ) ^ { - 1 } = A ^ { - 1 } - A ^ { - 1 } B ( D + C A ^ { - 1 } B ) ^ { - 1 } C A ^ { - 1 } \quad ( C . 7 )
$$

which is known as the Woodbury identity and which can be veriﬁed by multiplying both sides by ( A + BD − 1 C ) . This is useful, for instance, when A is large and diagonal, and hence easy to invert, while B has many rows but few columns (and conversely for C ) so that the right-hand side is much cheaper to evaluate than the left-hand side.

A set of vectors { a 1 ,..., a N } is said to be linearly independent if the relation n α n a n = 0 holds only if all α n = 0 . This implies that none of the vectors can be expressed as a linear combination of the remainder. The rank of a matrix is the maximum number of linearly independent rows (or equivalently the maximum number of linearly independent columns).

# Traces and Determinants

Trace and determinant apply to square matrices. The trace Tr ( A ) of a matrix A is deﬁned as the sum of the elements on the leading diagonal. By writing out the indices, we see that

$$
T r ( A B ) = T r ( B A ) .
$$

By applying this formula multiple times to the product of three matrices, we see that

$$
T r ( A B C ) = T r ( C A B ) = T r ( B C A )
$$

which is known as the cyclic property of the trace operator and which clearly extends to the product of any number of matrices. The determinant | A | of an N × N matrix A is deﬁned by

$$
| A | = \sum ( \pm 1 ) A _ { 1 i _ { 1 } } A _ { 2 i _ { 2 } } \cdots A _ { N i _ { N } } & & ( C . 1 0 ) \\ \intertext { y } | A | = \sum ( \pm 1 ) A _ { 1 i _ { 1 } } A _ { 2 i _ { 2 } } \cdots A _ { N i _ { N } } & & ( C . 1 0 ) \\ \intertext { u n } \intertext { i n s t a k e n o v e r a l l } \intertext { o r s i n t i o n s i s t i n g o f p r e c i l y } \intertext { e n t e n g e f r o w s } \intertext { e q n o w s }
$$

in which the sum is taken over all products consisting of precisely one element from each row and one element from each column, with a coefﬁcient +1 or − 1 according
