[Page 47]

Section 1.1

Exercise 1.12

function can be written in the form

$$
\ln p \left ( \mathbf x | \mu , \sigma ^ { 2 } \right ) = - \frac { 1 } { 2 \sigma ^ { 2 } } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } - \frac { N } { 2 } \ln \sigma ^ { 2 } - \frac { N } { 2 } \ln ( 2 \pi ) . \\ \intertext { \text {Maximizing } ( 1 . 5 4 ) \text { with respect to } \mu , \text { we obtain the maximum likelihood solution} }
$$

Maximizing (1.54) with respect to µ , we obtain the maximum likelihood solution given by

$$
\mu _ { M L } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n } & & ( 1 . 5 5 ) \\ \intertext { a n , i . e . , the mean of the observed values \{ x _ { n } \} . \text { Similarly,} }
$$

which is the sample mean , i.e., the mean of the observed values { x n } . Similarly, maximizing (1.54) with respect to σ 2 , we obtain the maximum likelihood solution for the variance in the form

$$
\sigma _ { M L } ^ { 2 } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu _ { M L } ) ^ { 2 } \\ \intertext { l e a r i a n c e m a s u r e d w i t h e r s e c t o t h e t a m e a n w i t h e r s e d }
$$

which is the sample variance measured with respect to the sample mean µ ML . Note that we are performing a joint maximization of (1.54) with respect to µ and σ 2 , but in the case of the Gaussian distribution the solution for µ decouples from that for σ 2 so that we can ﬁrst evaluate (1.55) and then subsequently use this result to evaluate (1.56).

Later in this chapter, and also in subsequent chapters, we shall highlight the signiﬁcant limitations of the maximum likelihood approach. Here we give an indication of the problem in the context of our solutions for the maximum likelihood parameter settings for the univariate Gaussian distribution. In particular, we shall show that the maximum likelihood approach systematically underestimates the variance of the distribution. This is an example of a phenomenon called bias and is related to the problem of over-ﬁtting encountered in the context of polynomial curve ﬁtting. We ﬁrst note that the maximum likelihood solutions µ ML and σ 2 ML are functions of the data set values x 1 ,...,x N . Consider the expectations of these quantities with respect to the data set values, which themselves come from a Gaussian distribution with parameters µ and σ 2 . It is straightforward to show that

$$
\mathbb { E } [ \mu _ { M L } ] \ = \ \mu
$$

$$
\mathbb { E } [ \mu _ { M L } ] \ & = \ \mu \\ \mathbb { E } [ \sigma _ { M L } ^ { 2 } ] \ & = \ \left ( \frac { N - 1 } { N } \right ) \sigma ^ { 2 } \\ \intertext { t h e m y i m u m l i k l i o b h o d e s t i m o t e w i l l o w i n t h e o r r o e t m o n p h u t }
$$

so that on average the maximum likelihood estimate will obtain the correct mean but will underestimate the true variance by a factor ( N − 1) /N . The intuition behind this result is given by Figure 1.15.

From (1.58) it follows that the following estimate for the variance parameter is unbiased N

$$
\widetilde { \sigma } ^ { 2 } = \frac { N } { N - 1 } \sigma _ { M L } ^ { 2 } = \frac { 1 } { N - 1 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu _ { M L } ) ^ { 2 } .
$$
