[Page 232]

however, ﬁnd another use for the probit model when we discuss Bayesian treatments of logistic regression in Section 4.5.

One issue that can occur in practical applications is that of outliers , which can arise for instance through errors in measuring the input vector x or through mislabelling of the target value t . Because such points can lie a long way to the wrong side of the ideal decision boundary, they can seriously distort the classiﬁer. Note that the logistic and probit regression models behave differently in this respect because the tails of the logistic sigmoid decay asymptotically like exp( − x ) for x → ∞ , whereas for the probit activation function they decay like exp( − x 2 ) , and so the probit model can be signiﬁcantly more sensitive to outliers.

However, both the logistic and the probit models assume the data is correctly labelled. The effect of mislabelling is easily incorporated into a probabilistic model by introducing a probability that the target value t has been ﬂipped to the wrong value (Opper and Winther, 2000a), leading to a target value distribution for data point x of the form

$$
p ( t | x ) \ & = \ ( 1 - \epsilon ) \sigma ( x ) + \epsilon ( 1 - \sigma ( x ) ) \\ & = \ \epsilon + ( 1 - 2 \epsilon ) \sigma ( x ) \\ \intertext { r } \intertext { s i t a t i v a t i o n f u i c t i o n with i n p u t e r o t v e r $ x $ H e r c a m v e s a t i p e r }
$$

where σ ( x ) is the activation function with input vector x . Here may be set in advance, or it may be treated as a hyperparameter whose value is inferred from the data.

# 4.3.6 Canonical link functions

For the linear regression model with a Gaussian noise distribution, the error function, corresponding to the negative log likelihood, is given by (3.12). If we take the derivative with respect to the parameter vector w of the contribution to the error function from a data point n , this takes the form of the ‘error’ y n − t n times the feature vector φ n , where y n = w T φ n . Similarly, for the combination of the logistic sigmoid activation function and the cross-entropy error function (4.90), and for the softmax activation function with the multiclass cross-entropy error function (4.108), we again obtain this same simple form. We now show that this is a general result of assuming a conditional distribution for the target variable from the exponential family, along with a corresponding choice for the activation function known as the canonical link function .

We again make use of the restricted form (4.84) of exponential family distributions. Note that here we are applying the assumption of exponential family distribution to the target variable t , in contrast to Section 4.2.4 where we applied it to the input vector x . We therefore consider conditional distributions of the target variable of the form 1 t ηt

$$
p ( t | \eta , s ) & = \frac { 1 } { s } \left ( \frac { t } { s } \right ) g ( \eta ) \exp \left \{ \frac { \eta t } { s } \right \} . \\ \text {line of argument as led to the derivation of the result (2.226), we see} \\ \text {dilational mean of } t \, \text {which we denote by } s \, \text {is given by}
$$

Using the same line of argument as led to the derivation of the result (2.226), we see that the conditional mean of t , which we denote by y , is given by

$$
y \equiv \mathbb { E } [ t | \eta ] = - s \frac { d } { d \eta } \ln g ( \eta ) .
$$
