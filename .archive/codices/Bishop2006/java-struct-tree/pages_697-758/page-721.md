[Page 721]

These last two equations can also be written in the form

�M

A =

λiuiuTi (C.45)

i=1

�M

1 λi

A−1 =

uiuTi . (C.46)

i=1

If we take the determinant of (C.43), and use (C.12), we obtain

�M

|A| =

λi. (C.47)

i=1

Similarly, taking the trace of (C.43), and using the cyclic property (C.8) of the trace operator together with UTU = I, we have

�M

Tr(A) =

λi. (C.48)

i=1

We leave it as an exercise for the reader to verify (C.22) by making use of the results (C.33), (C.45), (C.46), and (C.47).

A matrix A is said to be positive deﬁnite, denoted by A � 0, if wTAw > 0 for all values of the vector w. Equivalently, a positive deﬁnite matrix has λi > 0 for all of its eigenvalues (as can be seen by setting w to each of the eigenvectors in turn, and by noting that an arbitrary vector can be expanded as a linear combination of the eigenvectors). Note that positive deﬁnite is not the same as all the elements being positive. For example, the matrix

�

1 2 3 4 � (C.49)

has eigenvalues λ1 � 5.37 and λ2 � −0.37. A matrix is said to be positive semidefinite if wTAw � 0 holds for all values of w, which is denoted A � 0, and is

equivalent to λi � 0.
