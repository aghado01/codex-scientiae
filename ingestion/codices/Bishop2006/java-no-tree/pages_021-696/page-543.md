[Page 543]

# 11

![image 113](../../../../../images/imageFile113.png)

###### Sampling Methods

For most probabilistic models of practical interest, exact inference is intractable, and so we have to resort to some form of approximation. In Chapter 10, we discussed inference algorithms based on deterministic approximations, which include methods such as variational Bayes and expectation propagation. Here we consider approximate inference methods based on numerical sampling, also known as Monte Carlo techniques.

Although for some applications the posterior distribution over unobserved variables will be of direct interest in itself, for most situations the posterior distribution is required primarily for the purpose of evaluating expectations, for example in order to make predictions. The fundamental problem that we therefore wish to address in this chapter involves ﬁnding the expectation of some function f(z) with respect to a probability distribution p(z). Here, the components of z might comprise discrete or continuous variables or some combination of the two. Thus in the case of continuous

###### 523
