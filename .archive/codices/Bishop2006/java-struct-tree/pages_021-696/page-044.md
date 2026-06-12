[Page 44]

see, is required in order to make predictions or to compare different models. The development of sampling methods, such as Markov chain Monte Carlo (discussed in Chapter 11) along with dramatic improvements in the speed and memory capacity of computers, opened the door to the practical use of Bayesian techniques in an impressive range of problem domains. Monte Carlo methods are very ﬂexible and can be applied to a wide range of models. However, they are computationally intensive and have mainly been used for small-scale problems.

More recently, highly efﬁcient deterministic approximation schemes such as variational Bayes and expectation propagation (discussed in Chapter 10) have been developed. These offer a complementary alternative to sampling methods and have allowed Bayesian techniques to be used in large-scale applications (Blei et al., 2003).

1.2.4 The Gaussian distribution

We shall devote the whole of Chapter 2 to a study of various probability distributions and their key properties. It is convenient, however, to introduce here one of the most important probability distributions for continuous variables, called the normal or Gaussian distribution. We shall make extensive use of this distribution in the remainder of this chapter and indeed throughout much of the book.

For the case of a single real-valued variable x, the Gaussian distribution is deﬁned by

exp�−

(x − µ)2� (1.46)

1 (2πσ2)1/2

1 2σ2

N �

�

=

x|µ,σ2

which is governed by two parameters: µ, called the mean, and σ2, called the variance. The square root of the variance, given by σ, is called the standard deviation, and the reciprocal of the variance, written as β = 1/σ2, is called the precision. We shall see the motivation for these terms shortly. Figure 1.13 shows a plot of the Gaussian distribution.

From the form of (1.46) we see that the Gaussian distribution satisﬁes

N(x|µ,σ2) > 0. (1.47) Exercise 1.7 Also it is straightforward to show that the Gaussian is normalized, so that

Pierre-Simon Laplace

![image 16](../../../../../images/imageFile16.png)

1749–1827

It is said that Laplace was seriously lacking in modesty and at one point declared himself to be the best mathematician in France at the time, a claim that was arguably true. As well as being proliﬁc in mathe-

matics, he also made numerous contributions to astronomy, including the nebular hypothesis by which the

earth is thought to have formed from the condensation and cooling of a large rotating disk of gas and dust. In 1812 he published the ﬁrst edition of Theorie´ Analytique des Probabilites´ , in which Laplace states that “probability theory is nothing but common sense reduced to calculation”. This work included a discussion of the inverse probability calculation (later termed Bayes’ theorem by Poincare), which he used to solve´ problems in life expectancy, jurisprudence, planetary masses, triangulation, and error estimation.
