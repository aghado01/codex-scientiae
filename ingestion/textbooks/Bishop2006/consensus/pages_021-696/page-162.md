[Page 162]

Setting this gradient to zero gives

N

N

tnφ(xn)T − wT

φ(xn)φ(xn)T . (3.14)

0 =

n=1

n=1

Solving for w we obtain

wML = ΦTΦ −1 ΦTt (3.15) which are known as the normal equations for the least squares problem. Here Φ is an N×M matrix, called the design matrix, whose elements are given by Φnj = φj(xn), so that

⎛ ⎜ ⎝

###### ⎞ ⎟ ⎠. (3.16)

φ0(x1) φ1(x1) ··· φM−1(x1) φ0(x2) φ1(x2) ··· φM−1(x2)

Φ =

... .

. .

φ0(xN) φ1(xN) ··· φM−1(xN)

The quantity

###### Φ† ≡ ΦTΦ −1 ΦT (3.17)

is known as the Moore-Penrose pseudo-inverse of the matrix Φ (Rao and Mitra, 1971; Golub and Van Loan, 1996). It can be regarded as a generalization of the notion of matrix inverse to nonsquare matrices. Indeed, if Φ is square and invertible, then using the property (AB)−1 = B−1A−1 we see that Φ† ≡ Φ−1.

At this point, we can gain some insight into the role of the bias parameter w0. If we make the bias parameter explicit, then the error function (3.12) becomes

1 2

ED(w) =

N

{tn − w0 −

n=1

M−1

wjφj(xn)}2. (3.18)

j=1

Setting the derivative with respect to w0 equal to zero, and solving for w0, we obtain

where we have deﬁned

w0 = t −

M−1

wjφj (3.19)

j=1

N

N

1 N

1 N

t =

tn, φj =

φj(xn). (3.20)

n=1

n=1

Thus the bias w0 compensates for the difference between the averages (over the training set) of the target values and the weighted sum of the averages of the basis function values.

We can also maximize the log likelihood function (3.11) with respect to the noise precision parameter β, giving

N

1 βML

1 N

=

{tn − wMLT φ(xn)}2 (3.21)
