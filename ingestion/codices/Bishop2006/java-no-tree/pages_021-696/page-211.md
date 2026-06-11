[Page 211]

###### 4.1.6 Fisher’s discriminant for multiple classes

We now consider the generalization of the Fisher discriminant to K > 2 classes, and we shall assume that the dimensionality D of the input space is greater than the number K of classes. Next, we introduce D > 1 linear ‘features’ yk = wkTx, where k = 1,...,D . These feature values can conveniently be grouped together to form a vector y. Similarly, the weight vectors {wk} can be considered to be the columns of a matrix W, so that

y = WTx. (4.39)

Note that again we are not including any bias parameters in the deﬁnition of y. The generalization of the within-class covariance matrix to the case of K classes follows from (4.28) to give

K

SW =

Sk (4.40)

k=1

where

Sk =

(xn − mk)(xn − mk)T (4.41)

n∈Ck

1 Nk

mk =

xn (4.42)

n∈Ck

and Nk is the number of patterns in class Ck. In order to ﬁnd a generalization of the between-class covariance matrix, we follow Duda and Hart (1973) and consider ﬁrst the total covariance matrix

N

ST =

(xn − m)(xn − m)T (4.43)

n=1

where m is the mean of the total data set

N

K

1 N

1 N

m =

xn =

Nkmk (4.44)

n=1

k=1

and N = k Nk is the total number of data points. The total covariance matrix can be decomposed into the sum of the within-class covariance matrix, given by (4.40)

and (4.41), plus an additional matrix SB, which we identify as a measure of the between-class covariance

ST = SW + SB (4.45) where

K

SB =

Nk(mk − m)(mk − m)T. (4.46)

k=1
