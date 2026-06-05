[Page 376]

2

0

−2

−2

0

2

![The image is a scatter plot with two axes. The x-axis is labeled as x and the y-axis is labeled as y. There are four clusters of dots plotted on the graph. The dots are colored in blue, red, green, and orange. The dots are scattered in a random pattern. The background of the graph is purple.](../images/imageFile32.png)

2

Figure 7.12 Example of the relevance vector machine applied to a synthetic data set, in which the left-hand plot shows the decision boundary and the data points, with the relevance vectors indicated by circles. Comparison with the results shown in Figure 7.4 for the corresponding support vector machine shows that the RVM gives a much sparser model. The right-hand plot shows the posterior probability given by the RVM output in which the proportion of red (blue) ink indicates the probability of that point belonging to the red (blue) class.

which are combined using a softmax function to give outputs

$$
y _ { k } ( x ) = \frac { \exp ( a _ { k } ) } { \sum _ { j } \exp ( a _ { j } ) } .
$$

The log likelihood function is then given by

$$
\ln p ( T | w _ { 1 } , \dots , w _ { K } ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } y _ { n k } ^ { t _ { n k } } \\ \intertext { r o g t . v u l o s . t . a h o v o . 1 } \intertext { s u n t h e f o r $ K $ c o d i n g f o r $ o o h $ d o t a p i n g $ o n $ a n d $ T $ i s o $ }
$$

where the target values t nk have a 1-ofK coding for each data point n , and T is a matrix with elements t nk . Again, the Laplace approximation can be used to optimize the hyperparameters (Tipping, 2001), in which the model and its Hessian are found using IRLS. This gives a more principled approach to multiclass classiﬁcation than the pairwise method used in the support vector machine and also provides probabilistic predictions for new data points. The principal disadvantage is that the Hessian matrix has size MK × MK , where M is the number of active basis functions, which gives an additional factor of K 3 in the computational cost of training compared with the two-class RVM.

The principal disadvantage of the relevance vector machine is the relatively long training times compared with the SVM. This is offset, however, by the avoidance of cross-validation runs to set the model complexity parameters. Furthermore, because it yields sparser models, the computation time on test points, which is usually the more important consideration in practice, is typically much less.
