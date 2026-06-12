[Page 168]

$$
h ( x ) = \mathbb { E } [ t | x ] & = \int t p ( t | x ) \, d t . \\ \intertext { i s w o r h i n g u i s t h e w a r e n g h a r s u p l e c t i o n a r i s i n g } \intertext { h ( x ) = \mathbb { E } [ t | x ] = \int t p ( t | x ) \, d t . }
$$

At this point, it is worth distinguishing between the squared loss function arising from decision theory and the sum-of-squares error function that arose in the maximum likelihood estimation of model parameters. We might use more sophisticated techniques than least squares, for example regularization or a fully Bayesian approach, to determine the conditional distribution p ( t | x ) . These can all be combined with the squared loss function for the purpose of making predictions.

We showed in Section 1.5.5 that the expected squared loss can be written in the form

$$
\text {Form} \\ \mathbb { E } [ L ] = \int \{ y ( x ) - h ( x ) \} ^ { 2 } p ( x ) \, d x + \int \{ h ( x ) - t \} ^ { 2 } p ( x , t ) \, d x \, d t . \quad ( 3 . 3 7 ) \\ \\ \text {Roll} \, t h e t h e s o n d o r m e w h i o n g i s e f o n d e f o r ( y ) \, \text {arises from the intrinsio} \\
$$

Recall that the second term, which is independent of y ( x ) , arises from the intrinsic noise on the data and represents the minimum achievable value of the expected loss. The ﬁrst term depends on our choice for the function y ( x ) , and we will seek a solution for y ( x ) which makes this term a minimum. Because it is nonnegative, the smallest that we can hope to make this term is zero. If we had an unlimited supply of data (and unlimited computational resources), we could in principle ﬁnd the regression function h ( x ) to any desired degree of accuracy, and this would represent the optimal choice for y ( x ) . However, in practice we have a data set D containing only a ﬁnite number N of data points, and consequently we do not know the regression function h ( x ) exactly.

If we model the h ( x ) using a parametric function y ( x , w ) governed by a parameter vector w , then from a Bayesian perspective the uncertainty in our model is expressed through a posterior distribution over w . A frequentist treatment, however, involves making a point estimate of w based on the data set D , and tries instead to interpret the uncertainty of this estimate through the following thought experiment. Suppose we had a large number of data sets each of size N and each drawn independently from the distribution p ( t, x ) . For any given data set D , we can run our learning algorithm and obtain a prediction function y ( x ; D ) . Different data sets from the ensemble will give different functions and consequently different values of the squared loss. The performance of a particular learning algorithm is then assessed by taking the average over this ensemble of data sets.

Consider the integrand of the ﬁrst term in (3.37), which for a particular data set D takes the form { y ( x ; D ) − h ( x ) } 2 . (3.38)

$$
\{ y ( x ; \mathcal { D } ) - h ( x ) \} ^ { 2 } . \\ \dot { \ } w h { ( x ; \mathcal { D } ) } = 1 + \dot { \ } w h { ( x ) } .
$$

Because this quantity will be dependent on the particular data set D , we take its average over the ensemble of data sets. If we add and subtract the quantity E D [ y ( x ; D )]
