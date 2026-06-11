[Page 203]

?

C1

C3

R1

R2

R1

R3 C1 ?

C3

C1

R2

R3

C2

C2

not C1

C2

not C2

Figure 4.2 Attempting to construct a K class discriminant from a set of two class discriminants leads to ambiguous regions, shown in green. On the left is an example involving the use of two discriminants designed to distinguish points in class Ck from points not in class Ck. On the right is an example involving three discriminant functions each of which is used to separate a pair of classes Ck and Cj.

example involving three classes where this approach leads to regions of input space that are ambiguously classiﬁed.

An alternative is to introduce K(K − 1)/2 binary discriminant functions, one for every possible pair of classes. This is known as a one-versus-one classiﬁer. Each point is then classiﬁed according to a majority vote amongst the discriminant functions. However, this too runs into the problem of ambiguous regions, as illustrated in the right-hand diagram of Figure 4.2.

We can avoid these difﬁculties by considering a single K-class discriminant comprising K linear functions of the form

yk(x) = wkTx + wk0 (4.9)

and then assigning a point x to class Ck if yk(x) > yj(x) for all j �= k. The decision boundary between class Ck and class Cj is therefore given by yk(x) = yj(x) and hence corresponds to a (D − 1)-dimensional hyperplane deﬁned by

(wk − wj)Tx + (wk0 − wj0) = 0. (4.10)

This has the same form as the decision boundary for the two-class case discussed in Section 4.1.1, and so analogous geometrical properties apply.

The decision regions of such a discriminant are always singly connected and convex. To see this, consider two points xA and xB both of which lie inside decision region Rk, as illustrated in Figure 4.3. Any point x� that lies on the line connecting xA and xB can be expressed in the form

x� = λxA + (1 − λ)xB (4.11)
