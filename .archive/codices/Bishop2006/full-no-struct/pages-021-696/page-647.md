[Page 647]

Exercise 13.11

we obtain the beta recursion given by (13.38). Again, we can verify that the beta variables themselves are equivalent by noting that (8.70) implies that the initial message send by the root variable node is µ z N → f N ( z N ) = 1 , which is identical to the initialization of β ( z N ) given in Section 13.2.2. The sum-product algorithm also speciﬁes how to evaluate the marginals once all

the messages have been evaluated. In particular, the result (8.63) shows that the local marginal at the node z n is given by the product of the incoming messages. Because we have conditioned on the variables X = { x 1 ,..., x N } , we are computing the joint distribution

$$
p ( z _ { n } , X ) = \mu _ { f _ { n } \to z _ { n } } ( z _ { n } ) \mu _ { f _ { n + 1 } \to z _ { n } } ( z _ { n } ) = \alpha ( z _ { n } ) \beta ( z _ { n } ) .
$$

Dividing both sides by p ( X ) , we then obtain

$$
\gamma ( z _ { n } ) = \frac { p ( z _ { n } , X ) } { p ( X ) } = \frac { \alpha ( z _ { n } ) \beta ( z _ { n } ) } { p ( X ) }
$$

in agreement with (13.33). The result (13.43) can similarly be derived from (8.72).

# 13.2.4 Scaling factors

There is an important issue that must be addressed before we can make use of the forward backward algorithm in practice. From the recursion relation (13.36), we note that at each step the new value α ( z n ) is obtained from the previous value α ( z n − 1 ) by multiplying by quantities p ( z n | z n − 1 ) and p ( x n | z n ) . Because these probabilities are often signiﬁcantly less than unity, as we work our way forward along the chain, the values of α ( z n ) can go to zero exponentially quickly. For moderate lengths of chain (say 100 or so), the calculation of the α ( z n ) will soon exceed the dynamic range of the computer, even if double precision ﬂoating point is used.

In the case of i.i.d. data, we implicitly circumvented this problem with the evaluation of likelihood functions by taking logarithms. Unfortunately, this will not help here because we are forming sums of products of small numbers (we are in fact implicitly summing over all possible paths through the lattice diagram of Figure 13.7). We therefore work with re-scaled versions of α ( z n ) and β ( z n ) whose values remain of order unity. As we shall see, the corresponding scaling factors cancel out when we use these re-scaled quantities in the EM algorithm.

In (13.34), we deﬁned α ( z n ) = p ( x 1 ,..., x n , z n ) representing the joint distribution of all the observations up to x n and the latent variable z n . Now we deﬁne a normalized version of α given by

$$
\widehat { \alpha } ( z _ { n } ) = p ( z _ { n } | x _ { 1 } , \dots , x _ { n } ) = \frac { \alpha ( z _ { n } ) } { p ( x _ { 1 } , \dots , x _ { n } ) } \\ \intertext { w e p e c t o b e w l e b h a v e d u n m e r i c a l l y c a u b i l i t y d i s t r i g h e r } \ker K \text { variables for any value of } n . \text { In order to relate the scaled and original al- }
$$

which we expect to be well behaved numerically because it is a probability distribution over K variables for any value of n . In order to relate the scaled and original alpha variables, we introduce scaling factors deﬁned by conditional distributions over the observed variables

$$
c _ { n } = p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) .
$$
