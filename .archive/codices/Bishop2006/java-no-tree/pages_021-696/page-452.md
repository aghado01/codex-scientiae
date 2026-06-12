[Page 452]

instead of the marginal distribution p(x), and this will lead to signiﬁcant simpliﬁcations, most notably through the introduction of the expectation-maximization (EM) algorithm.

Another quantity that will play an important role is the conditional probability

of z given x. We shall use γ(zk) to denote p(zk = 1|x), whose value can be found using Bayes’ theorem

γ(zk) ≡ p(zk = 1|x) =

=

p(zk = 1)p(x|zk = 1) K

p(zj = 1)p(x|zj = 1)

j=1

πkN(x|µk,Σk) K

. (9.13)

πjN(x|µj,Σj)

j=1

We shall view πk as the prior probability of zk = 1, and the quantity γ(zk) as the corresponding posterior probability once we have observed x. As we shall see later,

γ(zk) can also be viewed as the responsibility that component k takes for ‘explaining’ the observation x.

- Section 8.1.2 We can use the technique of ancestral sampling to generate random samples distributed according to the Gaussian mixture model. To do this, we ﬁrst generate a value for z, which we denote z, from the marginal distribution p(z) and then generate a value for x from the conditional distribution p(x| z). Techniques for sampling from standard distributions are discussed in Chapter 11. We can depict samples from the joint distribution p(x,z) by plotting points at the corresponding values of x and then colouring them according to the value of z, in other words according to which Gaussian component was responsible for generating them, as shown in Figure 9.5(a). Similarly samples from the marginal distribution p(x) are obtained by taking the samples from the joint distribution and ignoring the values of z. These are illustrated in Figure 9.5(b) by plotting the x values without any coloured labels.


We can also use this synthetic data set to illustrate the ‘responsibilities’ by evaluating, for every data point, the posterior probability for each component in the mixture distribution from which this data set was generated. In particular, we can represent the value of the responsibilities γ(znk) associated with data point xn by plotting the corresponding point using proportions of red, blue, and green ink given by γ(znk) for k = 1,2,3, respectively, as shown in Figure 9.5(c). So, for instance, a data point for which γ(zn1) = 1 will be coloured red, whereas one for which γ(zn2) = γ(zn3) = 0.5 will be coloured with equal proportions of blue and green ink and so will appear cyan. This should be compared with Figure 9.5(a) in which the data points were labelled using the true identity of the component from which they were generated.

###### 9.2.1 Maximum likelihood

Suppose we have a data set of observations {x1,...,xN}, and we wish to model this data using a mixture of Gaussians. We can represent this data set as an N × D
