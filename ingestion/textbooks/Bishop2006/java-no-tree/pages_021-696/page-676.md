[Page 676]

that when we trained multiple polynomials using the sinusoidal data, and then averaged the resulting functions, the contribution arising from the variance term tended to cancel, leading to improved predictions. When we averaged a set of low-bias models (corresponding to higher order polynomials), we obtained accurate predictions for the underlying sinusoidal function from which the data were generated.

In practice, of course, we have only a single data set, and so we have to ﬁnd a way to introduce variability between the different models within the committee. One approach is to use bootstrap data sets, discussed in Section 1.2.3. Consider a regression problem in which we are trying to predict the value of a single continuous variable, and suppose we generate M bootstrap data sets and then use each to train a separate copy ym(x) of a predictive model where m = 1,...,M. The committee prediction is given by

M

1 M

yCOM(x) =

ym(x). (14.7)

m=1

This procedure is known as bootstrap aggregation or bagging (Breiman, 1996).

Suppose the true regression function that we are trying to predict is given by h(x), so that the output of each of the models can be written as the true value plus an error in the form

ym(x) = h(x) + m(x). (14.8) The average sum-of-squares error then takes the form

###### Ex {ym(x) − h(x)}2 = Ex m(x)2 (14.9)

where Ex[·] denotes a frequentist expectation with respect to the distribution of the input vector x. The average error made by the models acting individually is therefore

1 M

EAV =

M

Ex m(x)2 . (14.10)

m=1

Similarly, the expected error from the committee (14.7) is given by

###### ⎡ ⎣ 1

###### 2⎤ ⎦

M

ECOM = Ex

ym(x) − h(x)

M

m=1

###### ⎡ ⎣ 1

2⎤ ⎦ (14.11)

M

= Ex

m(x)

M

m=1

If we assume that the errors have zero mean and are uncorrelated, so that

Ex [ m(x)] = 0 (14.12) Ex [ m(x) l(x)] = 0, m = l (14.13)
