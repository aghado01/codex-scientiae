[Page 279]

will remain unchanged under the weight transformations provided the regularization parameters are re-scaled using λ 1 → a 1 / 2 λ 1 and λ 2 → c − 1 / 2 λ 2 . The regularizer (5.121) corresponds to a prior of the form

The regularizer (5.121) corresponds to a prior of the form

$$
\text {the regularizer} \, ( 3 . 1 2 1 ) \text { corresponds to a prior of the one form} \\ p ( w | \alpha _ { 1 } , \alpha _ { 2 } ) \, \in & \exp \left ( - \frac { \alpha _ { 1 } } { 2 } \sum _ { w \in \mathcal { W } _ { 1 } } w ^ { 2 } - \frac { \alpha _ { 2 } } { 2 } \sum _ { w \in \mathcal { W } _ { 2 } } w ^ { 2 } \right ) . \\ \intertext { Note that priors of this form are imprmoner (they cannot be normalized) because the }
$$

Note that priors of this form are improper (they cannot be normalized) because the bias parameters are unconstrained. The use of improper priors can lead to difﬁculties in selecting regularization coefﬁcients and in model comparison within the Bayesian framework, because the corresponding evidence is zero. It is therefore common to include separate priors for the biases (which then break shift invariance) having their own hyperparameters. We can illustrate the effect of the resulting four hyperparameters by drawing samples from the prior and plotting the corresponding network functions, as shown in Figure 5.11.

More generally, we can consider priors in which the weights are divided into any number of groups W k so that

$$
p ( w ) \subset & \exp \left ( - \frac { 1 } { 2 } \sum _ { k } \alpha _ { k } \| w \| _ { k } ^ { 2 } \right )
$$

where

$$
\| w \| _ { k } ^ { 2 } & = \sum _ { j \in \mathcal { W } _ { k } } w _ { j } ^ { 2 } . \\ \intertext { i s p r i o . if we choose the groups to correspond to the sets }
$$

As a special case of this prior, if we choose the groups to correspond to the sets of weights associated with each of the input units, and we optimize the marginal likelihood with respect to the corresponding parameters α k , we obtain automatic relevance determination as discussed in Section 7.2.2.

# 5.5.2 Early stopping

An alternative to regularization as a way of controlling the effective complexity of a network is the procedure of early stopping . The training of nonlinear network models corresponds to an iterative reduction of the error function deﬁned with respect to a set of training data. For many of the optimization algorithms used for network training, such as conjugate gradients, the error is a nonincreasing function of the iteration index. However, the error measured with respect to independent data, generally called a validation set, often shows a decrease at ﬁrst, followed by an increase as the network starts to over-ﬁt. Training can therefore be stopped at the point of smallest error with respect to the validation data set, as indicated in Figure 5.12, in order to obtain a network having good generalization performance.

The behaviour of the network in this case is sometimes explained qualitatively in terms of the effective number of degrees of freedom in the network, in which this number starts out small and then to grows during the training process, corresponding to a steady increase in the effective complexity of the model. Halting training before
