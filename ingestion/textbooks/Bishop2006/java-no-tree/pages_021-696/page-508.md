[Page 508]

where

mN = βSNΦTt (10.100) SN = E[α]I + βΦTΦ −1 . (10.101)

Note the close similarity to the posterior distribution (3.52) obtained when α was treated as a ﬁxed parameter. The difference is that here α is replaced by its expectation E[α] under the variational distribution. Indeed, we have chosen to use the same notation for the covariance matrix SN in both cases.

Using the standard results (B.27), (B.38), and (B.39), we can obtain the required moments as follows

E[α] = aN/bN (10.102) E[wwT] = mNmTN + SN. (10.103)

The evaluation of the variational posterior distribution begins by initializing the parameters of one of the distributions q(w) or q(α), and then alternately re-estimates these factors in turn until a suitable convergence criterion is satisﬁed (usually speciﬁed in terms of the lower bound to be discussed shortly).

It is instructive to relate the variational solution to that found using the evidence

framework in Section 3.5. To do this consider the case a0 = b0 = 0, corresponding to the limit of an inﬁnitely broad prior over α. The mean of the variational posterior distribution q(α) is then given by

aN bN

E[α] =

M/2 E[wTw]/2

=

M mTNmN + Tr(SN)

=

. (10.104)

Comparison with (9.63) shows that in the case of this particularly simple model, the variational approach gives precisely the same expression as that obtained by maximizing the evidence function using EM except that the point estimate for α is replaced by its expected value. Because the distribution q(w) depends on q(α) only through the expectation E[α], we see that the two approaches will give identical results for the case of an inﬁnitely broad prior.

###### 10.3.2 Predictive distribution

The predictive distribution over t, given a new input x, is easily evaluated for this model using the Gaussian variational posterior for the parameters

p(t|x,t) = p(t|x,w)p(w|t)dw

p(t|x,w)q(w)dw

= N(t|wTφ(x),β−1)N(w|mN,SN)dw

= N(t|mTNφ(x),σ2(x)) (10.105)
