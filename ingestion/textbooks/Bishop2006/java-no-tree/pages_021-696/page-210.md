[Page 210]

the weights becomes equivalent to the Fisher solution (Duda and Hart, 1973). In particular, we shall take the targets for class C1 to be N/N1, where N1 is the number of patterns in class C1, and N is the total number of patterns. This target value approximates the reciprocal of the prior probability for class C1. For class C2, we shall take the targets to be −N/N2, where N2 is the number of patterns in class C2.

The sum-of-squares error function can be written

N

1 2

wTxn + w0 − tn 2 . (4.31)

E =

n=1

Setting the derivatives of E with respect to w0 and w to zero, we obtain respectively

###### N

wTxn + w0 − tn = 0 (4.32)

n=1

N

wTxn + w0 − tn xn = 0. (4.33)

n=1

From (4.32), and making use of our choice of target coding scheme for the tn, we obtain an expression for the bias in the form

w0 = −wTm (4.34) where we have used

N

N N1 − N2

N N2

tn = N1

= 0 (4.35)

n=1

and where m is the mean of the total data set and is given by

N

1 N

1 N

xn =

(N1m1 + N2m2). (4.36)

m =

n=1

After some straightforward algebra, and again making use of the choice of tn, the

- Exercise 4.6 second equation (4.33) becomes


N1N2 N

SW +

SB w = N(m1 − m2) (4.37)

where SW is deﬁned by (4.28), SB is deﬁned by (4.27), and we have substituted for the bias using (4.34). Using (4.27), we note that SBw is always in the direction of (m2 − m1). Thus we can write

w ∝ S−1

W (m2 − m1) (4.38) where we have ignored irrelevant scale factors. Thus the weight vector coincides with that found from the Fisher criterion. In addition, we have also found an expression for the bias value w0 given by (4.34). This tells us that a new vector x should be classiﬁed as belonging to class C1 if y(x) = wT(x−m) > 0 and class C2 otherwise.
