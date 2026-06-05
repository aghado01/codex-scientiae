[Page 205]

# Exercise 4.2

Section 2.3.7

where W is a matrix whose k th column comprises the D + 1 -dimensional vector w k = ( w k 0 , w T k ) T and x is the corresponding augmented input vector (1 , x T ) T with a dummy input x 0 = 1 . This representation was discussed in detail in Section 3.1. A new input x is then assigned to the class for which the output y k = w T k x is largest. We now determine the parameter matrix W by minimizing a sum-of-squares

error function, as we did for regression in Chapter 3. Consider a training data set { x n , t n } where n = 1 ,...,N , and deﬁne a matrix T whose n th row is the vector t T n , together with a matrix X whose n th row is x T n . The sum-of-squares error function can then be written as E D ( W ) = 1 Tr ( X W − T ) T ( X W − T ) . (4.15)

$$
& \text {ben written as} \\ & \quad E _ { D } ( \widetilde { W } ) = \frac { 1 } { 2 } \text {Tr} \left \{ ( \widetilde { X W } - T ) ^ { \text {Tr} } ( \widetilde { X W } - T ) \right \} . \\ \\ & \text {the derivative with respect to} \, \widetilde { W } \, \text {to zero, and rearranging, we then obtain the} \\ & \text {for} \, \widetilde { W } \, \text {in the form}
$$

Setting the derivative with respect to W to zero, and rearranging, we then obtain the solution for W in the form W = ( X T X ) − 1 X T T = X † T (4.16) where X † is the pseudo-inverse of the matrix X , as discussed in Section 3.1.1. We then obtain the discriminant function in the form y ( x ) = W T x = T T X † T x . (4.17)

$$
\text {discriminant function in the form} \\ y ( x ) = \widetilde { W } ^ { T } \widetilde { x } = T ^ { T } \left ( \widetilde { X } ^ { \dagger } \right ) ^ { T } \widetilde { x } . \\ \intertext { s i g h p o r y } \text {property of least-squares solutions with multiple target variables} \\ \text {target vector in the training set satisfies some linear constraint}
$$

            An interesting property of least-squares solutions with multiple target variables is that if every target vector in the training set satisﬁes some linear constraint

$$
a ^ { T } t _ { n } + b = 0
$$

for some constants a and b , then the model prediction for any value of x will satisfy the same constraint so that T

$$
a ^ { T } y ( x ) + b = 0 .
$$

Thus if we use a 1-ofK coding scheme for K classes, then the predictions made by the model will have the property that the elements of y ( x ) will sum to 1 for any value of x . However, this summation constraint alone is not sufﬁcient to allow the model outputs to be interpreted as probabilities because they are not constrained to lie within the interval (0 , 1) .

The least-squares approach gives an exact closed-form solution for the discriminant function parameters. However, even as a discriminant function (where we use it to make decisions directly and dispense with any probabilistic interpretation) it suffers from some severe problems. We have already seen that least-squares solutions lack robustness to outliers, and this applies equally to the classiﬁcation application, as illustrated in Figure 4.4. Here we see that the additional data points in the righthand ﬁgure produce a signiﬁcant change in the location of the decision boundary, even though these point would be correctly classiﬁed by the original decision boundary in the left-hand ﬁgure. The sum-of-squares error function penalizes predictions that are ‘too correct’ in that they lie a long way on the correct side of the decision
