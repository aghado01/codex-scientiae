[Page 659]

where we have deﬁned

$$
P _ { n - 1 } = A V _ { n - 1 } A ^ { T } + \Gamma . \\
$$

We can now combine this result with the ﬁrst factor on the right-hand side of (13.86) by making use of (2.115) and (2.116) to give

$$
\mu _ { n } \ = \ A \mu _ { n - 1 } + K _ { n } ( x _ { n } - C A \mu _ { n - 1 } ) & & ( 1 3 . 8 9 ) \\ V \ = \ ( I - K \ C ) P _ { 1 } & & ( 1 3 . 9 0 )
$$

$$
V _ { n } \ & = \ ( I - K _ { n } C ) P _ { n - 1 } & & ( 1 3 . 9 0 ) \\ \mathcal { C } \ & = \ N ( \mathbf Y \ | C \mathbf A \mathbf u \ \mathbf C P \ \mathbf C ^ { T } + \mathbf \Sigma ) & & ( 1 3 . 9 1 )
$$

$$
c _ { n } \ = \ \mathcal { N } ( x _ { n } | C A \mu _ { n - 1 } , C P _ { n - 1 } C ^ { T } + \Sigma ) .
$$

Here we have made use of the matrix inverse identities (C.5) and (C.7) and also deﬁned the Kalman gain matrix

$$
K _ { n } = P _ { n - 1 } C ^ { T } \left ( C P _ { n - 1 } C ^ { T } + \Sigma \right ) ^ { - 1 } . \\ \intertext { h e x } \intertext { l a n t u l e s o f } \mu _ { n - 1 } \, \text { and } V _ { n - 1 } , \text { together with the new observation } x _ { n } , \, \mu \, \text { } \text {gaussian} \, \text { } \text {gaussian} \, \text { } \text {gaussian} \, \text { } V \,
$$

Thus, given the values of µ n − 1 and V n − 1 , together with the new observation x n , we can evaluate the Gaussian marginal for z n having mean µ n and covariance V n , as well as the normalization coefﬁcient c n . The initial conditions for these recursion equations are obtained from

The initial conditions for these recursion equations are obtained from

c 1 α ( z 1 ) = p ( z 1 ) p ( x 1 | z 1 ) . (13.93) Because p ( z 1 ) is given by (13.77), and p ( x 1 | z 1 ) is given by (13.76), we can again make use of (2.115) to calculate c 1 and (2.116) to calculate µ 1 and V 1 giving

$$
\mu _ { 1 } \ & = \ \mu _ { 0 } + K _ { 1 } ( x _ { 1 } - C \mu _ { 0 } ) & & ( 1 3 . 9 4 ) \\ V _ { 1 } \ & = \ ( I - K _ { 1 } C ) V _ { 0 } & & ( 1 3 . 9 5 )
$$

$$
V _ { 1 } \ & = \ ( I - K _ { 1 } C ) V _ { 0 } & & ( 1 3 . 9 5 ) \\ \mathcal { C } _ { 1 } \ & = \ N ( ( \mathbf x _ { 1 } | C \mu _ { 0 } \ C V _ { 0 } C ^ { T } + \Sigma ) \ & & ( 1 3 . 9 6 )
$$

$$
c _ { 1 } \ = \ \mathcal { N } ( x _ { 1 } | C \mu _ { 0 } , C V _ { 0 } C ^ { T } + \Sigma )
$$

where

$$
K _ { 1 } = V _ { 0 } C ^ { T } \left ( C V _ { 0 } C ^ { T } + \Sigma \right ) ^ { - 1 } . \\ \text {likehoid function for the linear dynamical system is given by } ( 1 3 . 6 3 ) \\ \text {actors } c _ { n } \text { are found using the Kalman filtering equations.}
$$

Similarly, the likelihood function for the linear dynamical system is given by (13.63) in which the factors c n are found using the Kalman ﬁltering equations. We can interpret the steps involved in going from the posterior marginal over

z n − 1 to the posterior marginal over z n as follows. In (13.89), we can view the quantity A µ n − 1 as the prediction of the mean over z n obtained by simply taking the mean over z n − 1 and projecting it forward one step using the transition probability matrix A . This predicted mean would give a predicted observation for x n given by CAz n − 1 obtained by applying the emission probability matrix C to the predicted hidden state mean. We can view the update equation (13.89) for the mean of the hidden variable distribution as taking the predicted mean A µ n − 1 and then adding a correction that is proportional to the error x n − CAz n − 1 between the predicted observation and the actual observation. The coefﬁcient of this correction is given by the Kalman gain matrix. Thus we can view the Kalman ﬁlter as a process of making successive predictions and then correcting these predictions in the light of the new observations. This is illustrated graphically in Figure 13.21.
