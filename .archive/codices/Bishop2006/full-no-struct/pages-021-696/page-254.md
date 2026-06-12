[Page 254]

# Exercise 5.2

# Exercise 5.3

where we have discarded additive and multiplicative constants. The value of w found by minimizing E ( w ) will be denoted w ML because it corresponds to the maximum likelihood solution. In practice, the nonlinearity of the network function y ( x n , w ) causes the error E ( w ) to be nonconvex, and so in practice local maxima of the likelihood may be found, corresponding to local minima of the error function, as discussed in Section 5.2.1.

Having found w ML , the value of β can be found by minimizing the negative log likelihood to give

$$
\text {give} & & \frac { 1 } { \beta _ { M L } } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w _ { M L } ) - t _ { n } \} ^ { 2 } . \\ \text {s can be evaluated once the iterative optimization required to find } w _ { M L }
$$

Note that this can be evaluated once the iterative optimization required to ﬁnd w ML is completed. If we have multiple target variables, and we assume that they are independent conditional on x and w with shared noise precision β , then the conditional distribution of the target values is given by

$$
& \text {if the target values is given by} \\ & \quad p ( t | x , w ) = \mathcal { N } \left ( t | y ( x , w ) , \beta ^ { - 1 } I \right ) . \\ & \text {same argument as for a single target variable, we see that the maximum} \\ & \text {ights are determined by minimizing the sum-of-squares error function}
$$

Following the same argument as for a single target variable, we see that the maximum likelihood weights are determined by minimizing the sum-of-squares error function (5.11). The noise precision is then given by

$$
\frac { 1 } { \beta _ { M L } } = \frac { 1 } { N K } \sum _ { n = 1 } ^ { N } \| y ( x _ { n } , w _ { M L } ) - t _ { n } \| ^ { 2 } \\ \intertext { t h e n b u r m o f t a g r e t i v a r b i s . T h e a s u m p t i o n f i n d e n c e a n b e }
$$

where K is the number of target variables. The assumption of independence can be dropped at the expense of a slightly more complex optimization problem.

Recall from Section 4.3.6 that there is a natural pairing of the error function (given by the negative log likelihood) and the output unit activation function. In the regression case, we can view the network as having an output activation function that is the identity, so that y k = a k . The corresponding sum-of-squares error function has the property

$$
\frac { \partial E } { \partial a _ { k } } = y _ { k } - t _ { k } & & ( 5 . 1 8 ) \\ \intertext { s c r } \frac { \partial E } { \partial a _ { k } } = y _ { k } - t _ { k } & & ( 5 . 1 8 ) \\
$$

which we shall make use of when discussing error backpropagation in Section 5.3.

Now consider the case of binary classiﬁcation in which we have a single target variable t such that t = 1 denotes class C 1 and t = 0 denotes class C 2 . Following the discussion of canonical link functions in Section 4.3.6, we consider a network having a single output whose activation function is a logistic sigmoid

$$
y = \sigma ( a ) \equiv \frac { 1 } { 1 + \exp ( - a ) } \\ \ y ) < 1 \ \text {We can interpret } u ( x , w ) \text { as the conditional probability}
$$

so that 0 y ( x , w ) 1 . We can interpret y ( x , w ) as the conditional probability p ( C 1 | x ) , with p ( C 2 | x ) given by 1 − y ( x , w ) . The conditional distribution of targets given inputs is then a Bernoulli distribution of the form

$$
p ( t | x , w ) = y ( x , w ) ^ { t } \{ 1 - y ( x , w ) \} ^ { 1 - t } \, .
$$
