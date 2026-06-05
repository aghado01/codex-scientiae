[Page 69]

- 0
- 1
- 2


- 0
- 1
- 2


|q = 0.3<br><br>|
|---|


|q = 1<br><br>|
|---|


q|−|yt

q|−|yt

−2 −1 0 1 2

−2 −1 0 1 2

y − t

y − t

- 0
- 1
- 2


- 0
- 1
- 2


|q = 2<br><br>|
|---|


|q = 10<br><br>|
|---|


q|−|yt

q|−|yt

−2 −1 0 1 2

−2 −1 0 1 2

y − t

y − t

Figure 1.29 Plots of the quantity Lq = |y − t|q for various values of q.

###### h(x) = −log2 p(x) (1.92)

where the negative sign ensures that information is positive or zero. Note that low probability events x correspond to high information content. The choice of basis for the logarithm is arbitrary, and for the moment we shall adopt the convention prevalent in information theory of using logarithms to the base of 2. In this case, as we shall see shortly, the units of h(x) are bits (‘binary digits’).

Now suppose that a sender wishes to transmit the value of a random variable to a receiver. The average amount of information that they transmit in the process is obtained by taking the expectation of (1.92) with respect to the distribution p(x) and is given by

p(x)log2 p(x). (1.93)

H[x] = −

x

This important quantity is called the entropy of the random variable x. Note that limp→0 plnp = 0 and so we shall take p(x)lnp(x) = 0 whenever we encounter a value for x such that p(x) = 0.

So far we have given a rather heuristic motivation for the deﬁnition of informa-
