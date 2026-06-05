[Page 53]

- Figure 1.18 The technique of S-fold cross-validation, illustrated here for the case of S = 4, involves taking the available data and partitioning it into S groups (in the simplest case these are of equal size). Then S − 1 of the groups are used to train a set of models that are then evaluated on the remaining group. This procedure is then repeated for all S possible choices for the held-out group, indicated here by the red blocks, and the performance scores from the S runs are then averaged.


| | | | |
|---|---|---|---|


| | | | |
|---|---|---|---|


| | | | |
|---|---|---|---|


| | | | |
|---|---|---|---|


- run 1
- run 2
- run 3
- run 4


data to assess performance. When data is particularly scarce, it may be appropriate to consider the case S = N, where N is the total number of data points, which gives the leave-one-out technique.

One major drawback of cross-validation is that the number of training runs that must be performed is increased by a factor of S, and this can prove problematic for models in which the training is itself computationally expensive. A further problem with techniques such as cross-validation that use separate data to assess performance is that we might have multiple complexity parameters for a single model (for instance, there might be several regularization parameters). Exploring combinations of settings for such parameters could, in the worst case, require a number of training runs that is exponential in the number of parameters. Clearly, we need a better approach. Ideally, this should rely only on the training data and should allow multiple hyperparameters and model types to be compared in a single training run. We therefore need to ﬁnd a measure of performance which depends only on the training data and which does not suffer from bias due to over-ﬁtting.

Historically various ‘information criteria’ have been proposed that attempt to correct for the bias of maximum likelihood by the addition of a penalty term to compensate for the over-ﬁtting of more complex models. For example, the Akaike information criterion, or AIC (Akaike, 1974), chooses the model for which the quantity

lnp(D|wML) − M (1.73)

is largest. Here p(D|wML) is the best-ﬁt log likelihood, and M is the number of adjustable parameters in the model. A variant of this quantity, called the Bayesian information criterion, or BIC, will be discussed in Section 4.4.1. Such criteria do not take account of the uncertainty in the model parameters, however, and in practice they tend to favour overly simple models. We therefore turn in Section 3.4 to a fully Bayesian approach where we shall see how complexity penalties arise in a natural and principled way.

###### 1.4. The Curse of Dimensionality

In the polynomial curve ﬁtting example we had just one input variable x. For practical applications of pattern recognition, however, we will have to deal with spaces
