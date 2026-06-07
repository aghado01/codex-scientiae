[Page 684]

![Figure 14.6](../../../../../images/imageFile330.png)
**Figure 14.6** Binary tree corresponding to the partitioning of input space shown in Figure 14.5.

Within each region, there is a separate model to predict the target variable. For instance, in regression we might simply predict a constant over each region, or in classiﬁcation we might assign each region to a speciﬁc class. A key property of treebased models, which makes them popular in ﬁelds such as medical diagnosis, for example, is that they are readily interpretable by humans because they correspond to a sequence of binary decisions applied to the individual input variables. For instance, to predict a patient's disease, we might ﬁrst ask "is their temperature greater than some threshold?". If the answer is yes, then we might next ask "is their blood pressure less than some threshold?". Each leaf of the tree is then associated with a speciﬁc diagnosis.

In order to learn such a model from a training set, we have to determine the structure of the tree, including which input variable is chosen at each node to form the split criterion as well as the value of the threshold parameter $\theta_i$ for the split. We also have to determine the values of the predictive variable within each region.

Consider ﬁrst a regression problem in which the goal is to predict a single target variable $t$ from a $D$-dimensional vector $\mathbf{x} = (x_1, \dots, x_D)^{\text{T}}$ of input variables. The training data consists of input vectors $\{\mathbf{x}_1, \dots, \mathbf{x}_N\}$ along with the corresponding continuous labels $\{t_1, \dots, t_N\}$. If the partitioning of the input space is given, and we minimize the sum-of-squares error function, then the optimal value of the predictive variable within any given region is just given by the average of the values of $t_n$ for those data points that fall in that region.

Now consider how to determine the structure of the decision tree. Even for a ﬁxed number of nodes in the tree, the problem of determining the optimal structure (including choice of input variable for each split as well as the corresponding thresh-
