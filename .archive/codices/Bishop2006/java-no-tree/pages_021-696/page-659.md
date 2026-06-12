[Page 659]

where we have deﬁned

###### Pn−1 = AVn−1AT + Γ. (13.88)

We can now combine this result with the ﬁrst factor on the right-hand side of (13.86) by making use of (2.115) and (2.116) to give

µn = Aµn−1 + Kn(xn − CAµn−1) (13.89) Vn = (I − KnC)Pn−1 (13.90)

cn = N(xn|CAµn−1,CPn−1CT + Σ). (13.91)

Here we have made use of the matrix inverse identities (C.5) and (C.7) and also deﬁned the Kalman gain matrix

###### Kn = Pn−1CT CPn−1CT + Σ −1 . (13.92)

Thus, given the values of µn−1 and Vn−1, together with the new observation xn, we can evaluate the Gaussian marginal for zn having mean µn and covariance Vn, as well as the normalization coefﬁcient cn.

The initial conditions for these recursion equations are obtained from

###### c1 α(z1) = p(z1)p(x1|z1). (13.93)

Because p(z1) is given by (13.77), and p(x1|z1) is given by (13.76), we can again make use of (2.115) to calculate c1 and (2.116) to calculate µ1 and V1 giving

µ1 = µ0 + K1(x1 − Cµ0) (13.94) V1 = (I − K1C)V0 (13.95)

c1 = N(x1|Cµ0,CV0CT + Σ) (13.96) where

K1 = V0CT CV0CT + Σ −1 . (13.97) Similarly, the likelihood function for the linear dynamical system is given by (13.63) in which the factors cn are found using the Kalman ﬁltering equations.

We can interpret the steps involved in going from the posterior marginal over zn−1 to the posterior marginal over zn as follows. In (13.89), we can view the quantity Aµn−1 as the prediction of the mean over zn obtained by simply taking the mean over zn−1 and projecting it forward one step using the transition probability matrix A. This predicted mean would give a predicted observation for xn given by CAzn−1 obtained by applying the emission probability matrix C to the predicted hidden state mean. We can view the update equation (13.89) for the mean of the hidden variable distribution as taking the predicted mean Aµn−1 and then adding a correction that is proportional to the error xn − CAzn−1 between the predicted observation and the actual observation. The coefﬁcient of this correction is given by the Kalman gain matrix. Thus we can view the Kalman ﬁlter as a process of making successive predictions and then correcting these predictions in the light of the new observations. This is illustrated graphically in Figure 13.21.
