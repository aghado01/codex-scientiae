[Page 443]

Section 9.1

![In this image we can see a poster with some text.](../images/imageFile35.png)

9

# Mixture Models and EM

If we deﬁne a joint distribution over observed and latent variables, the corresponding distribution of the observed variables alone is obtained by marginalization. This allows relatively complex marginal distributions over observed variables to be expressed in terms of more tractable joint distributions over the expanded space of observed and latent variables. The introduction of latent variables thereby allows complicated distributions to be formed from simpler components. In this chapter, we shall see that mixture distributions, such as the Gaussian mixture discussed in Section 2.3.9, can be interpreted in terms of discrete latent variables. Continuous latent variables will form the subject of Chapter 12.

As well as providing a framework for building more complex probability distributions, mixture models can also be used to cluster data. We therefore begin our discussion of mixture distributions by considering the problem of ﬁnding clusters in a set of data points, which we approach ﬁrst using a nonprobabilistic technique called the K -means algorithm (Lloyd, 1982). Then we introduce the latent variable
