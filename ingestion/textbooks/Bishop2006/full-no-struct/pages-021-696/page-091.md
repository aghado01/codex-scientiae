[Page 91]

given by (2.3) and (2.4), respectively, we have

$$
\mathbb { E } [ m ] & \equiv \sum _ { m = 0 } ^ { N } m \sin ( m | N , \mu ) \ = \ N \mu \\
$$

$$
var [ m ] & \equiv \sum _ { m = 0 } ^ { N } ( m - \mathbb { E } [ m ] ) ^ { 2 } \, \text {Bin} ( m | N , \mu ) \ = \ N \mu ( 1 - \mu ) . \quad ( 2 . 1 2 ) \\ \text {These results can also be proved directly using calculus.}
$$

These results can also be proved directly using calculus. Exercise 2.4

# 2.1.1 The beta distribution

We have seen in (2.8) that the maximum likelihood setting for the parameter µ in the Bernoulli distribution, and hence in the binomial distribution, is given by the fraction of the observations in the data set having x = 1 . As we have already noted, this can give severely over-ﬁtted results for small data sets. In order to develop a Bayesian treatment for this problem, we need to introduce a prior distribution p ( µ ) over the parameter µ . Here we consider a form of prior distribution that has a simple interpretation as well as some useful analytical properties. To motivate this prior, we note that the likelihood function takes the form of the product of factors of the form µ x (1 − µ ) 1 − x . If we choose a prior to be proportional to powers of µ and (1 − µ ) , then the posterior distribution, which is proportional to the product of the prior and the likelihood function, will have the same functional form as the prior. This property is called conjugacy and we will see several examples of it later in this chapter. We therefore choose a prior, called the beta distribution, given by

$$
\ B e t a ( \mu | a , b ) = \frac { \Gamma ( a + b ) } { \Gamma ( a ) \Gamma ( b ) } \mu ^ { a - 1 } ( 1 - \mu ) ^ { b - 1 }
$$

where Γ( x ) is the gamma function deﬁned by (1.141), and the coefﬁcient in (2.13) ensures that the beta distribution is normalized, so that

Exercise 2.5

$$
a \, \text {distribution is normalized, so that} \\ \int _ { 0 } ^ { 1 } \, B \, \alpha ( \mu | a , b ) \, d \mu = 1 . \\ \intertext { c o n s e f t h e \, b e t a \, d i s t r i b u t i o n are g i v e n b y }
$$

The mean and variance of the beta distribution are given by Exercise 2.6

$$
\mathbb { E } [ \mu ] \ = \ \frac { a } { a + b } \quad \\
$$

$$
v a r [ \mu ] \ = \ \frac { a b } { ( a + b ) ^ { 2 } ( a + b + 1 ) } .
$$

The parameters a and b are often called hyperparameters because they control the distribution of the parameter µ . Figure 2.2 shows plots of the beta distribution for various values of the hyperparameters.

The posterior distribution of µ is now obtained by multiplying the beta prior (2.13) by the binomial likelihood function (2.9) and normalizing. Keeping only the factors that depend on µ , we see that this posterior distribution has the form

$$
p ( \mu | m , l , a , b ) \, \infty \, \mu ^ { m + a - 1 } ( 1 - \mu ) ^ { l + b - 1 }
$$
