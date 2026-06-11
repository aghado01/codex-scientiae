[Page 684]

- Figure 14.6 Binary tree corresponding to the partitioning of input space shown in Figure 14.5.


x1 > θ1

x2 θ2

x2 > θ3

x1 θ4

A B C D E

divides the whole of the input space into two regions according to whether x1 θ1 or x1 > θ1 where θ1 is a parameter of the model. This creates two subregions, each of which can then be subdivided independently. For instance, the region x1 θ1 is further subdivided according to whether x2 θ2 or x2 > θ2, giving rise to the regions denoted A and B. The recursive subdivision can be described by the traversal of the binary tree shown in Figure 14.6. For any new input x, we determine which region it falls into by starting at the top of the tree at the root node and following a path down to a speciﬁc leaf node according to the decision criteria at each node. Note that such decision trees are not probabilistic graphical models.

Within each region, there is a separate model to predict the target variable. For instance, in regression we might simply predict a constant over each region, or in classiﬁcation we might assign each region to a speciﬁc class. A key property of treebased models, which makes them popular in ﬁelds such as medical diagnosis, for example, is that they are readily interpretable by humans because they correspond to a sequence of binary decisions applied to the individual input variables. For instance, to predict a patient’s disease, we might ﬁrst ask “is their temperature greater than some threshold?”. If the answer is yes, then we might next ask “is their blood pressure less than some threshold?”. Each leaf of the tree is then associated with a speciﬁc diagnosis.

In order to learn such a model from a training set, we have to determine the structure of the tree, including which input variable is chosen at each node to form the split criterion as well as the value of the threshold parameter θi for the split. We also have to determine the values of the predictive variable within each region.

Consider ﬁrst a regression problem in which the goal is to predict a single target variable t from a D-dimensional vector x = (x1,...,xD)T of input variables. The training data consists of input vectors {x1,...,xN} along with the corresponding continuous labels {t1,...,tN}. If the partitioning of the input space is given, and we minimize the sum-of-squares error function, then the optimal value of the predictive variable within any given region is just given by the average of the values of tn for

- Exercise 14.10 those data points that fall in that region. Now consider how to determine the structure of the decision tree. Even for a


ﬁxed number of nodes in the tree, the problem of determining the optimal structure (including choice of input variable for each split as well as the corresponding thresh-
