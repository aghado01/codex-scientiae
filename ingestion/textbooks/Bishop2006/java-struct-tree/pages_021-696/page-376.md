[Page 376]

2

0

−2

−2 0 2

![image 86](../../../../../images/imageFile86.png)

![image 87](../../../../../images/imageFile87.png)

Figure 7.12 Example of the relevance vector machine applied to a synthetic data set, in which the left-hand plot shows the decision boundary and the data points, with the relevance vectors indicated by circles. Comparison with the results shown in Figure 7.4 for the corresponding support vector machine shows that the RVM gives a much sparser model. The right-hand plot shows the posterior probability given by the RVM output in which the proportion of red (blue) ink indicates the probability of that point belonging to the red (blue) class.

which are combined using a softmax function to give outputs

exp(ak)

yk(x) =

�

j

The log likelihood function is then given by

. (7.121)

exp(aj)

�N

�K

yt

lnp(T|w1,...,wK) =

nk (7.122)

nk

n=1

k=1

where the target values tnk have a 1-of-K coding for each data point n, and T is a matrix with elements tnk. Again, the Laplace approximation can be used to optimize the hyperparameters (Tipping, 2001), in which the model and its Hessian are found using IRLS. This gives a more principled approach to multiclass classiﬁcation than the pairwise method used in the support vector machine and also provides probabilistic predictions for new data points. The principal disadvantage is that the Hessian matrix has size MK×MK, where M is the number of active basis functions, which gives an additional factor of K3 in the computational cost of training compared with the two-class RVM.

The principal disadvantage of the relevance vector machine is the relatively long training times compared with the SVM. This is offset, however, by the avoidance of cross-validation runs to set the model complexity parameters. Furthermore, because it yields sparser models, the computation time on test points, which is usually the more important consideration in practice, is typically much less.
