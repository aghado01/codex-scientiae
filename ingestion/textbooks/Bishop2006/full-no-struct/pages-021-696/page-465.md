[Page 465]

Consider a set of D binary variables x i , where i = 1 ,...,D , each of which is governed by a Bernoulli distribution with parameter µ i , so that

$$
p ( x | \mu ) = \prod _ { i = 1 } ^ { D } \mu _ { i } ^ { x _ { i } } ( 1 - \mu _ { i } ) ^ { ( 1 - x _ { i } ) } \\ \\ \sigma _ { i } ) ^ { T } \text { and } \mu _ { i } = ( \mu _ { i } + \mu _ { i } ) ^ { T } \text { \ } W o \text { so that the individual}
$$

where x = ( x 1 ,...,x D ) T and µ = ( µ 1 ,...,µ D ) T . We see that the individual variables x i are independent, given µ . The mean and covariance of this distribution are easily seen to be

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
c o v [ x ] \ = \ d i a g \{ \mu _ { i } ( 1 - \mu _ { i } ) \} .
$$

Now let us consider a ﬁnite mixture of these distributions given by

$$
p ( x | \mu , \pi ) = \sum _ { k = 1 } ^ { K } \pi _ { k } p ( x | \mu _ { k } ) \\ \\ \mu _ { k } \} \, \pi = \{ \pi _ { k } \} _ { \ } a n d
$$

where µ = { µ 1 ,..., µ K } , π = { π 1 ,...,π K } , and

$$
p ( x | \mu _ { k } ) = \prod _ { i = 1 } ^ { D } \mu _ { k i } ^ { x _ { i } } ( 1 - \mu _ { k i } ) ^ { ( 1 - x _ { i } ) } . \\ \intertext { d o v a r i a n c e $ of $ this m i t u r e $ d i t u r $ a g r i n g b y }
$$

The mean and covariance of this mixture distribution are given by Exercise 9.12

$$
\mathbb { E } [ x ] \ = \ \sum _ { k = 1 } ^ { K } \pi _ { k } \mu _ { k }
$$

$$
c o v [ x ] \ = \ \sum _ { k = 1 } ^ { K } \pi _ { k } \left \{ \Sigma _ { k } + \mu _ { k } \mu _ { k } ^ { T } \right \} - \mathbb { E } [ x ] \mathbb { E } [ x ] ^ { T } \\ \ e \sum _ { k = 1 } ^ { K } \ = \ \text {diag} \left \{ \mu _ { k } ( 1 - \mu _ { k } ) \right \} _ { \ } \text {Because the covariance matrix cov} [ x ] \text { is no}
$$

where Σ k = diag { µ ki (1 − µ ki ) } . Because the covariance matrix cov[ x ] is no longer diagonal, the mixture distribution can capture correlations between the variables, unlike a single Bernoulli distribution.

If we are given a data set X = { x 1 ,..., x N } then the log likelihood function for this model is given by

$$
\text {m} o r \, \text {is given by} \\ \ln p ( X | \mu , \pi ) = \sum _ { n = 1 } ^ { N } \ln \left \{ \sum _ { k = 1 } ^ { K } \pi _ { k } p ( x _ { n } | \mu _ { k } ) \right \} . \\ \text {we, see the appearance of the summation inside the logarithm  so that the}
$$

Again we see the appearance of the summation inside the logarithm, so that the maximum likelihood solution no longer has closed form.

We now derive the EM algorithm for maximizing the likelihood function for the mixture of Bernoulli distributions. To do this, we ﬁrst introduce an explicit latent
