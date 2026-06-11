[Page 184]

Figure 3.13 Schematic illustration of the distribution of data sets for three models of different complexity, in which M1 is the simplest and M3 is the most complex. Note that the distributions are normalized. In this example, for the particular observed data set D0, the model M2 with intermediate complexity has the largest evidence.

p(D)

M1

M2

M3

D D0

model can generate a variety of different data sets since the parameters are governed by a prior probability distribution, and for any choice of the parameters there may be random noise on the target variables. To generate a particular data set from a speciﬁc model, we ﬁrst choose the values of the parameters from their prior distribution p(w), and then for these parameter values we sample the data from p(D|w). A simple model (for example, based on a ﬁrst order polynomial) has little variability and so will generate data sets that are fairly similar to each other. Its distribution p(D) is therefore conﬁned to a relatively small region of the horizontal axis. By contrast, a complex model (such as a ninth order polynomial) can generate a great variety of different data sets, and so its distribution p(D) is spread over a large region of the space of data sets. Because the distributions p(D|Mi) are normalized, we see that the particular data set D0 can have the highest value of the evidence for the model of intermediate complexity. Essentially, the simpler model cannot ﬁt the data well, whereas the more complex model spreads its predictive probability over too broad a range of data sets and so assigns relatively small probability to any one of them.

Implicit in the Bayesian model comparison framework is the assumption that the true distribution from which the data are generated is contained within the set of models under consideration. Provided this is so, we can show that Bayesian model comparison will on average favour the correct model. To see this, consider two models M1 and M2 in which the truth corresponds to M1. For a given ﬁnite data set, it is possible for the Bayes factor to be larger for the incorrect model. However, if we average the Bayes factor over the distribution of data sets, we obtain the expected Bayes factor in the form

p(D|M1) p(D|M2)

p(D|M1)ln

dD (3.73)

where the average has been taken with respect to the true distribution of the data.

- Section 1.6.1 This quantity is an example of the Kullback-Leibler divergence and satisﬁes the property of always being positive unless the two distributions are equal in which case it is zero. Thus on average the Bayes factor will always favour the correct model.


We have seen that the Bayesian framework avoids the problem of over-ﬁtting and allows models to be compared on the basis of the training data alone. However,
