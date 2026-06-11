[Page 279]

will remain unchanged under the weight transformations provided the regularization parameters are re-scaled using λ1 → a1/2λ1 and λ2 → c−1/2λ2.

The regularizer (5.121) corresponds to a prior of the form

p(w|α1,α2) ∝ exp�

w2�. (5.122)

2 �

2 �

α1

α2

w2 −

−

w∈W1

w∈W2

Note that priors of this form are improper (they cannot be normalized) because the bias parameters are unconstrained. The use of improper priors can lead to difﬁculties in selecting regularization coefﬁcients and in model comparison within the Bayesian framework, because the corresponding evidence is zero. It is therefore common to include separate priors for the biases (which then break shift invariance) having their own hyperparameters. We can illustrate the effect of the resulting four hyperparameters by drawing samples from the prior and plotting the corresponding network functions, as shown in Figure 5.11.

More generally, we can consider priors in which the weights are divided into any number of groups Wk so that

p(w) ∝ exp�

� (5.123)

1 2 �

αk�w�2k

−

k

where

�

�w�2k =

wj2. (5.124)

j∈Wk

As a special case of this prior, if we choose the groups to correspond to the sets of weights associated with each of the input units, and we optimize the marginal likelihood with respect to the corresponding parameters αk, we obtain automatic relevance determination as discussed in Section 7.2.2.

5.5.2 Early stopping

An alternative to regularization as a way of controlling the effective complexity of a network is the procedure of early stopping. The training of nonlinear network models corresponds to an iterative reduction of the error function deﬁned with respect to a set of training data. For many of the optimization algorithms used for network training, such as conjugate gradients, the error is a nonincreasing function of the iteration index. However, the error measured with respect to independent data, generally called a validation set, often shows a decrease at ﬁrst, followed by an increase as the network starts to over-ﬁt. Training can therefore be stopped at the point of smallest error with respect to the validation data set, as indicated in Figure 5.12, in order to obtain a network having good generalization performance.

The behaviour of the network in this case is sometimes explained qualitatively in terms of the effective number of degrees of freedom in the network, in which this number starts out small and then to grows during the training process, corresponding to a steady increase in the effective complexity of the model. Halting training before
