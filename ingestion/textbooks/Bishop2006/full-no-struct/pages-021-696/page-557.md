[Page 557]

Now suppose we move from a maximum likelihood approach to a full Bayesian treatment in which we wish to sample from the posterior distribution over the parameter vector θ . In principle, we would like to draw samples from the joint posterior p ( θ , Z | X ) , but we shall suppose that this is computationally difﬁcult. Suppose further that it is relatively straightforward to sample from the complete-data parameter posterior p ( θ | Z , X ) . This inspires the data augmentation algorithm, which alternates between two steps known as the I-step (imputation step, analogous to an E step) and the P-step (posterior step, analogous to an M step).

# IP Algorithm

I-step. We wish to sample from p ( Z | X ) but we cannot do this directly. We therefore note the relation

$$
\text {none the relation} \\ p ( Z | X ) = \int p ( Z | \theta , X ) p ( \theta | X ) \, d \theta \\
$$

and hence for l = 1 ,...,L we ﬁrst draw a sample θ ( l ) from the current estimate for p ( θ | X ) , and then use this to draw a sample Z ( l ) from p ( Z | θ ( l ) , X ) . P-step. Given the relation

$$
\ p ( \theta | X ) & = \int p ( \theta | Z , X ) p ( Z | X ) \, d Z \\
$$

we use the samples { Z ( l ) } obtained from the I-step to compute a revised estimate of the posterior distribution over θ given by

$$
p ( \theta | X ) \simeq \frac { 1 } { L } \sum _ { l = 1 } ^ { L } p ( \theta | Z ^ { ( l ) } , X ) . \quad ( 1 1 . 3 2 ) \\ \intertext { i n t w i l b e f a s i c h l e t o s m a p l e c h o w s }
$$

By assumption, it will be feasible to sample from this approximation in the I-step.

Note that we are making a (somewhat artiﬁcial) distinction between parameters θ and hidden variables Z . From now on, we blur this distinction and focus simply on the problem of drawing samples from a given posterior distribution.

# 11.2. Markov Chain Monte Carlo

In the previous section, we discussed the rejection sampling and importance sampling strategies for evaluating expectations of functions, and we saw that they suffer from severe limitations particularly in spaces of high dimensionality. We therefore turn in this section to a very general and powerful framework called Markov chain Monte Carlo (MCMC), which allows sampling from a large class of distributions,
