[Page 89]

Exercise 2.1

Section 2.4

where 0 µ 1 , from which it follows that p ( x = 0 | µ ) = 1 − µ . The probability distribution over x can therefore be written in the form

$$
\ B e r n ( x | \mu ) & = \mu ^ { x } ( 1 - \mu ) ^ { 1 - x } & ( 2 . 2 ) \\ \\
$$

which is known as the Bernoulli distribution. It is easily veriﬁed that this distribution is normalized and that it has mean and variance given by

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
\ v a r [ x ] \ = \ \mu ( 1 - \mu ) . \\
$$

Now suppose we have a data set D = { x 1 ,...,x N } of observed values of x . We can construct the likelihood function, which is a function of µ , on the assumption that the observations are drawn independently from p ( x | µ ) , so that

$$
p ( \mathcal { D } | \mu ) = \prod _ { n = 1 } ^ { N } p ( x _ { n } | \mu ) = \prod _ { n = 1 } ^ { N } \mu ^ { x _ { n } } ( 1 - \mu ) ^ { 1 - x _ { n } } . \\ \text {request} \, t i n g t s e c k e a n d e s i m a t e a v i l e f o r \mu \, b y \, \max i m i z i n g h e t l i k h o o d
$$

In a frequentist setting, we can estimate a value for µ by maximizing the likelihood function, or equivalently by maximizing the logarithm of the likelihood. In the case of the Bernoulli distribution, the log likelihood function is given by

$$
\ln p ( \mathcal { D } | \mu ) = \sum _ { n = 1 } ^ { N } \ln p ( x _ { n } | \mu ) = \sum _ { n = 1 } ^ { N } \{ x _ { n } \ln \mu + ( 1 - x _ { n } ) \ln ( 1 - \mu ) \} \, . \quad ( 2 . 6 ) \\ \intertext { a t h i s p o n t i s w h o r $ t h i s p o w n o w $ } \At t h i s p o w n o w \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext { a t h i s p o w n o w } \intertext
$$

At this point, it is worth noting that the log likelihood function depends on the N observations x n only through their sum n x n . This sum provides an example of a sufﬁcient statistic for the data under this distribution, and we shall study the important role of sufﬁcient statistics in some detail. If we set the derivative of ln p ( D| µ ) with respect to µ equal to zero, we obtain the maximum likelihood estimator

$$
\mu _ { M L } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n }
$$

![image 10](../images/imageFile10.png)

# Jacob Bernoulli 1654–1705

Jacob Bernoulli, also known as Jacques or James Bernoulli, was a Swiss mathematician and was the ﬁrst of many in the Bernoulli family to pursue a career in science and mathematics. Although compelled and theology against his will by

to study philosophy his parents, he travelled extensively after graduating in order to meet with many of the leading scientists of

his time, including Boyle and Hooke in England. When he returned to Switzerland, he taught mechanics and became Professor of Mathematics at Basel in 1687. Unfortunately, rivalry between Jacob and his younger brother Johann turned an initially productive collaboration into a bitter and public dispute. Jacob’s most signiﬁcant contributions to mathematics appeared in The Art of Conjecture published in 1713, eight years after his death, which deals with topics in probability theory including what has become known as the Bernoulli distribution.
