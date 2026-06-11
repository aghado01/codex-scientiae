[Page 179]

![The image consists of a graph. The graph is a line graph, and it is colored blue. The graph has a few lines, but they are not very clear. The lines are yellow and orange, and they are not very distinct. The graph is not very detailed, and it is not clear what the title of the graph is.](../images/imageFile18.png)

Chapter 6

# 3.3.3 Equivalent kernel

The posterior mean solution (3.53) for the linear basis function model has an interesting interpretation that will set the stage for kernel methods, including Gaussian processes. If we substitute (3.53) into the expression (3.3), we see that the predictive mean can be written in the form

$$
y ( x , m _ { N } ) = m _ { N } ^ { T } \phi ( x ) = \beta \phi ( x ) ^ { T } S _ { N } \Phi ^ { T } t = \sum _ { n = 1 } ^ { N } \beta \phi ( x ) ^ { T } S _ { N } \phi ( x _ { n } ) t _ { n } \quad ( 3 . 6 0 ) \\ \intertext { w h e r s } \text {where } S _ { n } \text { is defined by } ( 3 . 5 1 ) \text {  Thus the mean of the predictive distribution at a point }
$$

where S N is deﬁned by (3.51). Thus the mean of the predictive distribution at a point x is given by a linear combination of the training set target variables t n , so that we can write N

$$
y ( x , m _ { N } ) = \sum _ { n = 1 } ^ { N } k ( x , x _ { n } ) t _ { n }
$$

where the function

$$
k ( x , x ^ { \prime } ) = \beta \phi ( x ) ^ { T } S _ { N } \phi ( x ^ { \prime } )
$$

is known as the smoother matrix or the equivalent kernel . Regression functions, such as this, which make predictions by taking linear combinations of the training set target values are known as linear smoothers . Note that the equivalent kernel depends on the input values x n from the data set because these appear in the deﬁnition of S N . The equivalent kernel is illustrated for the case of Gaussian basis functions in Figure 3.10 in which the kernel functions k ( x,x ) have been plotted as a function of x for three different values of x . We see that they are localized around x , and so the mean of the predictive distribution at x , given by y ( x, m N ) , is obtained by forming a weighted combination of the target values in which data points close to x are given higher weight than points further removed from x . Intuitively, it seems reasonable that we should weight local evidence more strongly than distant evidence. Note that this localization property holds not only for the localized Gaussian basis functions but also for the nonlocal polynomial and sigmoidal basis functions, as illustrated in Figure 3.11.
