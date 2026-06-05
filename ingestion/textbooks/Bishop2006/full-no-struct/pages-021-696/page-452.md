[Page 452]

Section 8.1.2

instead of the marginal distribution p ( x ) , and this will lead to signiﬁcant simpliﬁcations, most notably through the introduction of the expectation-maximization (EM) algorithm.

Another quantity that will play an important role is the conditional probability of z given x . We shall use γ ( z k ) to denote p ( z k = 1 | x ) , whose value can be found using Bayes’ theorem

$$
\text {ing Bayes} ^ { \ } the orem \\ \gamma ( z _ { k } ) \equiv p ( z _ { k } = 1 | x ) \ = \ \frac { p ( z _ { k } = 1 ) p ( x | z _ { k } = 1 ) } { K } \\ \sum _ { j = 1 } ^ { K } p ( z _ { j } = 1 ) p ( x | z _ { j } = 1 ) \\ = \ \frac { \pi _ { k } \mathcal { N } ( x | \mu _ { k } , \Sigma _ { k } ) } { K } . \\ \sum _ { j = 1 } ^ { K } \pi _ { j } \mathcal { N } ( x | \mu _ { j } , \Sigma _ { j } ) \\ \intertext { e l s h a l l v e w } \text {the } \pi _ { k } \text { as the prior probability of } z _ { k } \, = \, 1 , \text { and the quantity } \gamma ( z _ { k } ) \text { as the } \text { corresponding posterior probability once we have observed } x \text { . As we shall see later }
$$

We shall view π k as the prior probability of z k = 1 , and the quantity γ ( z k ) as the corresponding posterior probability once we have observed x . As we shall see later, γ ( z k ) can also be viewed as the responsibility that component k takes for ‘explaining’ the observation x .

We can use the technique of ancestral sampling to generate random samples distributed according to the Gaussian mixture model. To do this, we ﬁrst generate a value for z , which we denote z , from the marginal distribution p ( z ) and then generate a value for x from the conditional distribution p ( x | z ) . Techniques for sampling from standard distributions are discussed in Chapter 11. We can depict samples from the joint distribution p ( x , z ) by plotting points at the corresponding values of x and then colouring them according to the value of z , in other words according to which Gaussian component was responsible for generating them, as shown in Figure 9.5(a). Similarly samples from the marginal distribution p ( x ) are obtained by taking the samples from the joint distribution and ignoring the values of z . These are illustrated in Figure 9.5(b) by plotting the x values without any coloured labels.

We can also use this synthetic data set to illustrate the ‘responsibilities’ by evaluating, for every data point, the posterior probability for each component in the mixture distribution from which this data set was generated. In particular, we can represent the value of the responsibilities γ ( z nk ) associated with data point x n by plotting the corresponding point using proportions of red, blue, and green ink given by γ ( z nk ) for k = 1 , 2 , 3 , respectively, as shown in Figure 9.5(c). So, for instance, a data point for which γ ( z n 1 ) = 1 will be coloured red, whereas one for which γ ( z n 2 ) = γ ( z n 3 ) = 0 . 5 will be coloured with equal proportions of blue and green ink and so will appear cyan. This should be compared with Figure 9.5(a) in which the data points were labelled using the true identity of the component from which they were generated.

# 9.2.1 Maximum likelihood

Suppose we have a data set of observations { x 1 ,..., x N } , and we wish to model this data using a mixture of Gaussians. We can represent this data set as an N × D
