[Page 90]

Figure 2.1 Histogram plot of the binomial distribution (2.9) as a function of m for N = 10 and µ = 0.25.

0.3

0.2

0.1

0

0 1 2 3 4 5 6 7 8 9 10

m

which is also known as the sample mean. If we denote the number of observations of x = 1 (heads) within this data set by m, then we can write (2.7) in the form

m N

µML =

(2.8)

so that the probability of landing heads is given, in this maximum likelihood framework, by the fraction of observations of heads in the data set.

Now suppose we ﬂip a coin, say, 3 times and happen to observe 3 heads. Then N = m = 3 and µML = 1. In this case, the maximum likelihood result would predict that all future observations should give heads. Common sense tells us that this is unreasonable, and in fact this is an extreme example of the over-ﬁtting associated with maximum likelihood. We shall see shortly how to arrive at more sensible conclusions through the introduction of a prior distribution over µ.

We can also work out the distribution of the number m of observations of x = 1, given that the data set has size N. This is called the binomial distribution, and from (2.5) we see that it is proportional to µm(1 − µ)N−m. In order to obtain the normalization coefﬁcient we note that out of N coin ﬂips, we have to add up all of the possible ways of obtaining m heads, so that the binomial distribution can be written

N m

µm(1 − µ)N−m (2.9) where

Bin(m|N,µ) =

N! (N − m)!m!

N m ≡

(2.10)

- Exercise 2.3 is the number of ways of choosing m objects out of a total of N identical objects. Figure 2.1 shows a plot of the binomial distribution for N = 10 and µ = 0.25.


The mean and variance of the binomial distribution can be found by using the result of Exercise 1.10, which shows that for independent events the mean of the sum is the sum of the means, and the variance of the sum is the sum of the variances. Because m = x1 + ... + xN, and for each observation the mean and variance are
