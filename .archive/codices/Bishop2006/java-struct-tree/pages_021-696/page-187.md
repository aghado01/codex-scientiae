[Page 187]

where M is the dimensionality of w, and we have deﬁned E(w) = βED(w) + αEW(w)

β 2 �t − Φw�2 +

α 2

=

wTw. (3.79)

We recognize (3.79) as being equal, up to a constant of proportionality, to the regExercise 3.18 ularized sum-of-squares error function (3.27). We now complete the square over w

giving

1 2

E(w) = E(mN) +

(w − mN)TA(w − mN) (3.80) where we have introduced

A = αI + βΦTΦ (3.81) together with

β 2 �t − ΦmN�2 +

α 2

E(mN) =

mTNmN. (3.82) Note that A corresponds to the matrix of second derivatives of the error function

A = ∇∇E(w) (3.83) and is known as the Hessian matrix. Here we have also deﬁned mN given by

mN = βA−1ΦTt. (3.84) Using (3.54), we see that A = S−1

N , and hence (3.84) is equivalent to the previous deﬁnition (3.53), and therefore represents the mean of the posterior distribution.

The integral over w can now be evaluated simply by appealing to the standard Exercise 3.19 result for the normalization coefﬁcient of a multivariate Gaussian, giving

� exp{−E(w)} dw

= exp{−E(mN)}� exp�−

(w − mN)TA(w − mN)� dw

1 2

= exp{−E(mN)}(2π)M/2|A|−1/2. (3.85) Using (3.78) we can then write the log of the marginal likelihood in the form

1 2

M 2

N 2

N 2

lnp(t|α,β) =

ln(2π) (3.86) which is the required expression for the evidence function.

lnα +

lnβ − E(mN) −

ln|A| −

Returning to the polynomial regression problem, we can plot the model evidence against the order of the polynomial, as shown in Figure 3.14. Here we have assumed a prior of the form (1.65) with the parameter α ﬁxed at α = 5 × 10−3. The form of this plot is very instructive. Referring back to Figure 1.4, we see that the M = 0 polynomial has very poor ﬁt to the data and consequently gives a relatively low value
