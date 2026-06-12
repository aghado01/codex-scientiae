[Page 639]

the messages that are propagated along the chain (Jordan, 2007). We shall focus on the most widely used of these, known as the alpha-beta algorithm.

As well as being of great practical importance in its own right, the forwardbackward algorithm provides us with a nice illustration of many of the concepts introduced in earlier chapters. We shall therefore begin in this section with a ‘conventional’ derivation of the forward-backward equations, making use of the sum and product rules of probability, and exploiting conditional independence properties which we shall obtain from the corresponding graphical model using d-separation. Then in Section 13.2.3, we shall see how the forward-backward algorithm can be obtained very simply as a speciﬁc example of the sum-product algorithm introduced in Section 8.4.4.

It is worth emphasizing that evaluation of the posterior distributions of the latent variables is independent of the form of the emission density p ( x | z ) or indeed of whether the observed variables are continuous or discrete. All we require is the values of the quantities p ( x n | z n ) for each value of z n for every n . Also, in this section and the next we shall omit the explicit dependence on the model parameters θ old because these ﬁxed throughout.

We therefore begin by writing down the following conditional independence properties (Jordan, 2007)

$$
\begin{array} { r l r } { p ( X | z _ { n } ) } & = } & { p ( x _ { 1 } , \dots , x _ { n } | z _ { n } ) } \\ & { p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } ) } \end{array}
$$

$$
p ( X | z _ { n } ) \ & = \ p ( x _ { 1 } , \dots , x _ { n } | z _ { n } ) \\ p ( x _ { 1 } , \dots , x _ { n - 1 } | x _ { n } , z _ { n } ) \ & = \ p ( x _ { 1 } , \dots , x _ { n - 1 } | z _ { n } ) \\ p ( x _ { 1 } , \dots , x _ { n - 1 } | z _ { n - 1 } , z _ { n } ) \ & = \ p ( x _ { 1 } , \dots , x _ { n - 1 } | z _ { n - 1 } ) \\ p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } , z _ { n + 1 } ) \ & = \ p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n + 1 } ) \\ p ( x _ { n + 2 } , \dots , x _ { N } | z _ { n + 1 } , x _ { n + 1 } ) \ & = \ p ( x _ { n + 2 } , \dots , x _ { N } | z _ { n + 1 } ) \\ p ( X | z _ { n - 1 } , z _ { n } ) \ & = \ p ( x _ { 1 } , \dots , x _ { n - 1 } | z _ { n - 1 } ) \\ p ( x _ { N + 1 } | X , z _ { N + 1 } ) \ & = \ p ( x _ { N + 1 } | z _ { N + 1 } ) \\ p ( z _ { N + 1 } | z _ { N } , X ) \ & = \ p ( z _ { N + 1 } | z _ { N } )
$$

$$
\ p ( z _ { N + 1 } | z _ { N } , X ) \ = \ p ( z _ { N + 1 } | z _ { N } )
$$

where X = { x 1 ,..., x N } . These relations are most easily proved using d-separation. For instance in the ﬁrst of these results, we note that every path from any one of the nodes x 1 ,..., x n − 1 to the node x n passes through the node z n , which is observed. Because all such paths are head-to-tail, it follows that the conditional independence property must hold. The reader should take a few moments to verify each of these properties in turn, as an exercise in the application of d-separation. These relations can also be proved directly, though with signiﬁcantly greater effort, from the joint distribution for the hidden Markov model using the sum and product rules of probability.

Let us begin by evaluating γ ( z nk ) . Recall that for a discrete multinomial random variable the expected value of one of its components is just the probability of that component having the value 1 . Thus we are interested in ﬁnding the posterior distribution p ( z n | x 1 ,..., x N ) of z n given the observed data set x 1 ,..., x N . This
