[Page 184]

Figure 3.13 Schematic illustration of the distribution of data sets for three models of different complexity, in which M 1 is the simplest and M 3 is the most complex. Note that the distributions are normalized. In this example, for the particular observed data set D 0 , the model M 2 with intermediate complexity has the largest evidence.

evidence.

![The image depicts a graph with two axes labeled D and M1 and two lines representing the variables D and M1. The graph is divided into two sections, with the x-axis labeled from 0 to 100, and the y-axis labeled from 0 to 100. The graph is divided into two parts, with the x-axis labeled from 0 to 100, and the y-axis labeled from 0 to 100. The graph has two main lines: 1. The first line is labeled D and is represented by a red dashed line. 2. The second line is labeled M1 and is represented by a blue dashed line. The graph has a horizontal axis labeled D and a vertical axis labeled M1. The x-axis is labeled from 0 to 100 and the y-axis is labeled from](../images/imageFile85.png)

D

p

(

)

M

1

M

2

M

3

D

D

0

Section 1.6.1

model can generate a variety of different data sets since the parameters are governed by a prior probability distribution, and for any choice of the parameters there may be random noise on the target variables. To generate a particular data set from a speciﬁc model, we ﬁrst choose the values of the parameters from their prior distribution p ( w ) , and then for these parameter values we sample the data from p ( D| w ) . A simple model (for example, based on a ﬁrst order polynomial) has little variability and so will generate data sets that are fairly similar to each other. Its distribution p ( D ) is therefore conﬁned to a relatively small region of the horizontal axis. By contrast, a complex model (such as a ninth order polynomial) can generate a great variety of different data sets, and so its distribution p ( D ) is spread over a large region of the space of data sets. Because the distributions p ( D|M i ) are normalized, we see that the particular data set D 0 can have the highest value of the evidence for the model of intermediate complexity. Essentially, the simpler model cannot ﬁt the data well, whereas the more complex model spreads its predictive probability over too broad a range of data sets and so assigns relatively small probability to any one of them.

Implicit in the Bayesian model comparison framework is the assumption that the true distribution from which the data are generated is contained within the set of models under consideration. Provided this is so, we can show that Bayesian model comparison will on average favour the correct model. To see this, consider two models M 1 and M 2 in which the truth corresponds to M 1 . For a given ﬁnite data set, it is possible for the Bayes factor to be larger for the incorrect model. However, if we average the Bayes factor over the distribution of data sets, we obtain the expected Bayes factor in the form

$$
\int p ( \mathcal { D } | \mathcal { M } _ { 1 } ) \ln \frac { p ( \mathcal { D } | \mathcal { M } _ { 1 } ) } { p ( \mathcal { D } | \mathcal { M } _ { 2 } ) } \, d \mathcal { D } \\ \intertext { o n d } \text {ho} \, \text {bouon} \, \text {tokon with respect to the true distribution of the} \, \text {dots}
$$

where the average has been taken with respect to the true distribution of the data. This quantity is an example of the Kullback-Leibler divergence and satisﬁes the property of always being positive unless the two distributions are equal in which case it is zero. Thus on average the Bayes factor will always favour the correct model.

We have seen that the Bayesian framework avoids the problem of over-fitting and allows models to be compared on the basis of the training data alone. However, a Bayesian approach, like any approach to pattern recognition, needs to make assumptions about the form of the model, and if these are invalid then the results can be misleading. In particular, we see from Figure 3.12 that the model evidence can be sensitive to many aspects of the prior, such as the behaviour in the tails. Indeed, the evidence is not defined if the prior is improper, as can be seen by noting that an improper prior has an arbitrary scaling factor (in other words, the normalization coefficient is not defined because the distribution cannot be normalized). If we consider a proper prior and then take a suitable limit in order to obtain an improper prior (for example, a Gaussian prior in which we take the limit of infinite variance) then the evidence will go to zero, as can be seen from (3.70) and Figure 3.12. It may, however, be possible to consider the evidence ratio between two models first and then take a limit to obtain a meaningful answer.
