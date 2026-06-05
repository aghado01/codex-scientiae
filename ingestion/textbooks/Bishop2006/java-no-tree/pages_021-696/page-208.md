[Page 208]

| |
|---|


| |
|---|


4

4

2

2

0

0

−2

−2

−2 2 6

−2

2 6

- Figure 4.6 The left plot shows samples from two classes (depicted in red and blue) along with the histograms resulting from projection onto the line joining the class means. Note that there is considerable class overlap in the projected space. The right plot shows the corresponding projection based on the Fisher linear discriminant, showing the greatly improved class separation.


is the mean of the projected data from class Ck. However, this expression can be made arbitrarily large simply by increasing the magnitude of w. To solve this

problem, we could constrain w to have unit length, so that i wi2 = 1. Using Appendix E a Lagrange multiplier to perform the constrained maximization, we then ﬁnd that

- Exercise 4.4 w ∝ (m2 −m1). There is still a problem with this approach, however, as illustrated in Figure 4.6. This shows two classes that are well separated in the original two-

dimensional space (x1,x2) but that have considerable overlap when projected onto the line joining their means. This difﬁculty arises from the strongly nondiagonal covariances of the class distributions. The idea proposed by Fisher is to maximize a function that will give a large separation between the projected class means while also giving a small variance within each class, thereby minimizing the class overlap.

The projection formula (4.20) transforms the set of labelled data points in x into a labelled set in the one-dimensional space y. The within-class variance of the transformed data from class Ck is therefore given by

s2k =

n∈Ck

(yn − mk)2 (4.24)

where yn = wTxn. We can deﬁne the total within-class variance for the whole data set to be simply s21 + s22. The Fisher criterion is deﬁned to be the ratio of the between-class variance to the within-class variance and is given by

J(w) =

(m2 − m1)2 s21 + s22

. (4.25)

We can make the dependence on w explicit by using (4.20), (4.23), and (4.24) to

- Exercise 4.5 rewrite the Fisher criterion in the form
