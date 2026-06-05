[Page 75]

which is called the conditional entropy of y given x. It is easily seen, using the

- Exercise 1.37 product rule, that the conditional entropy satisﬁes the relation H[x,y] = H[y|x] + H[x] (1.112)


where H[x,y] is the differential entropy of p(x,y) and H[x] is the differential entropy of the marginal distribution p(x). Thus the information needed to describe x and y is given by the sum of the information needed to describe x alone plus the additional information required to specify y given x.

###### 1.6.1 Relative entropy and mutual information

So far in this section, we have introduced a number of concepts from information theory, including the key notion of entropy. We now start to relate these ideas to pattern recognition. Consider some unknown distribution p(x), and suppose that we have modelled this using an approximating distribution q(x). If we use q(x) to construct a coding scheme for the purpose of transmitting values of x to a receiver, then the average additional amount of information (in nats) required to specify the value of x (assuming we choose an efﬁcient coding scheme) as a result of using q(x) instead of the true distribution p(x) is given by

KL(p q) = − p(x)lnq(x)dx − − p(x)lnp(x)dx

q(x) p(x)

= − p(x)ln

dx. (1.113)

This is known as the relative entropy or Kullback-Leibler divergence, or KL divergence (Kullback and Leibler, 1951), between the distributions p(x) and q(x). Note that it is not a symmetrical quantity, that is to say KL(p q)  ≡ KL(q p).

We now show that the Kullback-Leibler divergence satisﬁes KL(p q) 0 with equality if, and only if, p(x) = q(x). To do this we ﬁrst introduce the concept of convex functions. A function f(x) is said to be convex if it has the property that every chord lies on or above the function, as shown in Figure 1.31. Any value of x in the interval from x = a to x = b can be written in the form λa + (1 − λ)b where 0 λ 1. The corresponding point on the chord is given by λf(a) + (1 − λ)f(b),

###### Claude Shannon

![image 18](../../../../../images/imageFile18.png)

ory. This paper introduced the word ‘bit’, and his concept that information could be sent as a stream of 1s and 0s paved the way for the communications revolution. It is said that von Neumann recommended to Shannon that he use the term entropy, not only because of its similarity to the quantity used in physics, but also because “nobody knows what entropy really is, so in any discussion you will always have an advantage”.

###### 1916–2001

After graduating from Michigan and MIT, Shannon joined the AT&T Bell Telephone laboratories in 1941. His paper ‘A Mathematical Theory of Communication’ published in the Bell System Technical Journal in

1948 laid the foundations for modern information the-
