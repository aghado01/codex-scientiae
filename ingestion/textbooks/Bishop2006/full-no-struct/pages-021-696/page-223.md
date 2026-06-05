[Page 223]

2 classes) or softmax ( K 2 classes) activation functions. These are particular cases of a more general result obtained by assuming that the class-conditional densities p ( x |C k ) are members of the exponential family of distributions. Using the form (2.194) for members of the exponential family, we see that the

Using the form (2.194) for members of the exponential family, we see that the distribution of x can be written in the form

$$
& \text {or } X \text { can be written in the form } \\ & \quad p ( x | \lambda _ { k } ) = h ( x ) g ( \lambda _ { k } ) \exp \left \{ \lambda _ { k } ^ { T } u ( x ) \right \} . \\ & \text {strict attention to the subclass of such distributions for which } u ( x ) = x . \\ & \text {take use of } ( 2 \, ? 2 6 ) \, t o \, \text {introduce a scaling parameter } g \text {, so that we obtain }
$$

We now restrict attention to the subclass of such distributions for which u ( x ) = x . Then we make use of (2.236) to introduce a scaling parameter s , so that we obtain the restricted set of exponential family class-conditional densities of the form

$$
p ( x | \lambda _ { k } , s ) & = \frac { 1 } { s } h \left ( \frac { 1 } { s } x \right ) g ( \lambda _ { k } ) \exp \left \{ \frac { 1 } { s } \lambda _ { k } ^ { T } x \right \} . \\ \intertext { h o w a r o w l i n g a l l o w h e i s o w n o r m e r t o w e r }
$$

Note that we are allowing each class to have its own parameter vector λ k but we are assuming that the classes share the same scale parameter s .

For the two-class problem, we substitute this expression for the class-conditional densities into (4.58) and we see that the posterior class probability is again given by a logistic sigmoid acting on a linear function a ( x ) which is given by

$$
a ( x ) = ( \lambda _ { 1 } - \lambda _ { 2 } ) ^ { T } x + \ln g ( \lambda _ { 1 } ) - \ln g ( \lambda _ { 2 } ) + \ln p ( \mathcal { C } _ { 1 } ) - \ln p ( \mathcal { C } _ { 2 } ) .
$$

Similarly, for the K -class problem, we substitute the class-conditional density expression into (4.63) to give

$$
a _ { k } ( x ) = \lambda _ { k } ^ { T } x + \ln g ( \lambda _ { k } ) + \ln p ( \mathcal { C } _ { k } )
$$

and so again is a linear function of x .

# 4.3. Probabilistic Discriminative Models

For the two-class classiﬁcation problem, we have seen that the posterior probability of class C 1 can be written as a logistic sigmoid acting on a linear function of x , for a wide choice of class-conditional distributions p ( x |C k ) . Similarly, for the multiclass case, the posterior probability of class C k is given by a softmax transformation of a linear function of x . For speciﬁc choices of the class-conditional densities p ( x |C k ) , we have used maximum likelihood to determine the parameters of the densities as well as the class priors p ( C k ) and then used Bayes’ theorem to ﬁnd the posterior class probabilities.

However, an alternative approach is to use the functional form of the generalized linear model explicitly and to determine its parameters directly by using maximum likelihood. We shall see that there is an efﬁcient algorithm ﬁnding such solutions known as iterative reweighted least squares , or IRLS .

The indirect approach to ﬁnding the parameters of a generalized linear model, by ﬁtting class-conditional densities and class priors separately and then applying
