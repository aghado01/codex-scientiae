[Page 676]

that when we trained multiple polynomials using the sinusoidal data, and then averaged the resulting functions, the contribution arising from the variance term tended to cancel, leading to improved predictions. When we averaged a set of low-bias models (corresponding to higher order polynomials), we obtained accurate predictions for the underlying sinusoidal function from which the data were generated.

In practice, of course, we have only a single data set, and so we have to ﬁnd a way to introduce variability between the different models within the committee. One approach is to use bootstrap data sets, discussed in Section 1.2.3. Consider a regression problem in which we are trying to predict the value of a single continuous variable, and suppose we generate M bootstrap data sets and then use each to train a separate copy y m ( x ) of a predictive model where m = 1 ,...,M . The committee prediction is given by

$$
y _ { \ } y c o m ( x ) & = \frac { 1 } { M } \sum _ { m = 1 } ^ { M } y _ { m } ( x ) . \\ \intertext { k n o w n } \text {known as bootstrap aggregation or bagging } ( B e r i m a n , 1 9 9 6 ) .
$$

This procedure is known as bootstrap aggregation or bagging (Breiman, 1996).

Suppose the true regression function that we are trying to predict is given by h ( x ) , so that the output of each of the models can be written as the true value plus an error in the form

$$
y _ { m } ( x ) = h ( x ) + \epsilon _ { m } ( x ) .
$$

The average sum-of-squares error then takes the form

$$
\mathbb { E } _ { x } \left [ \{ y _ { m } ( x ) - h ( x ) \} ^ { 2 } \right ] & = \mathbb { E } _ { x } \left [ \epsilon _ { m } ( x ) ^ { 2 } \right ] \\ \intertext { ] } \detotes a f r e q u i n t i s t e x p e c t i o n w i s t r e f o r t a d i s t o r } \intertext { r } x , \, \text {The average error made by the models } \text {acting independently} \, i s \, \text {there} \, f o r }
$$

where E x [ · ] denotes a frequentist expectation with respect to the distribution of the input vector x . The average error made by the models acting individually is therefore

$$
E _ { A V } = \frac { 1 } { M } \sum _ { m = 1 } ^ { M } \mathbb { E } _ { x } \left [ \epsilon _ { m } ( x ) ^ { 2 } \right ] . \\ \text {expected error from the committee} \left ( 1 4 . 7 \right ) \text { is given by}
$$

Similarly, the expected error from the committee (14.7) is given by

$$
\text {early, the expected error from the committee (14.7) is given by} \\ E _ { \text {COM} } \ = \ \mathbb { E } _ { x } \left [ \left \{ \frac { 1 } { M } \sum _ { m = 1 } ^ { M } y _ { m } ( x ) - h ( x ) \right \} ^ { 2 } \right ] \\ = \ \mathbb { E } _ { x } \left [ \left \{ \frac { 1 } { M } \sum _ { m = 1 } ^ { M } \epsilon _ { m } ( x ) \right \} ^ { 2 } \right ] \\ \text {assume that the errors have zero mean and are uncorrelated, so that}
$$

If we assume that the errors have zero mean and are uncorrelated, so that

$$
\mathbb { E } _ { x } \left [ \epsilon _ { m } ( x ) \right ] \ = \ 0
$$

/negationslash Exercise 14.2

$$
\mathbb { E } _ { x } \left [ \epsilon _ { m } ( x ) \epsilon _ { l } ( x ) \right ] \ = \ 0 , \quad m \neq l
$$
