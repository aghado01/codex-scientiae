[Page 503]

Exercise 10.19

Exercise 10.20

Section 10.1.4

Exercise 10.21

where p ( π , µ , Λ | X ) is the (unknown) true posterior distribution of the parameters. Using (10.37) and (10.38) we can ﬁrst perform the summation over z to give

$$
w h e r e & p ( \pi , \mu , \Lambda | X ) \, \text { is the (unknown) true posterior distribution of the parameters.} \\ \text {Using (10.37) and (10.38) we can first perform the summation over \widehat { z } to give \\ & \quad p ( \widehat { x } | X ) = \sum _ { k = 1 } ^ { K } \iint \pi _ { k } \mathcal { N } \left ( \widehat { x } | \mu _ { k } , \Lambda _ { k } ^ { - 1 } \right ) p ( \pi , \mu , \Lambda | X ) \, d \pi \, d \mu \, d \Lambda . \quad ( 10 . 79 ) \\ \text {Because the remaining integrations are intracutable, we approximate the predictive } \\ \text {density by replacing the true posterior distribution } p ( \pi , \mu , \Lambda | X ) \, \text { with its variational }
$$

Because the remaining integrations are intractable, we approximate the predictive density by replacing the true posterior distribution p ( π , µ , Λ | X ) with its variational approximation q ( π ) q ( µ , Λ ) to give

$$
\text {app} \alpha \text {maided} q ( \mu , \L _ { k } ) \text {,} & \in g \text {c} \\ p ( \widehat { x } | X ) = \sum _ { k = 1 } ^ { K } \iint \pi _ { k } \mathcal { N } \left ( \widehat { x } | \mu _ { k } , \Lambda _ { k } ^ { - 1 } \right ) q ( \pi ) q ( \mu _ { k } , \Lambda _ { k } ) \, d \pi \, d \mu _ { k } \, d \Lambda _ { k } \quad ( 1 0 . 8 0 ) \\ \text {where we have made use of the factorization } ( 1 0 . 5 5 ) \text { and in each term we have im-} \\ \text {PLICITly integrated out all variables } \{ \mu _ { i } , \Lambda _ { i } \} \text { for } j \neq k \text { The remaining integrations}
$$

where we have made use of the factorization (10.55) and in each term we have implicitly integrated out all variables { µ j , Λ j } for j = k The remaining integrations can now be evaluated analytically giving a mixture of Student’s t-distributions

/negationslash

$$
p ( \widehat { x } | X ) & = \frac { 1 } { \widehat { \alpha } } \sum _ { k = 1 } ^ { K } \alpha _ { k } S t ( \widehat { x } | m _ { k } , L _ { k } , \nu _ { k } + 1 - D ) \\ \intertext { c h e t h } \text { } & \quad ( \nu _ { k } + 1 - D ) \beta _ { k }
$$

in which the k th component has mean m k , and the precision is given by

$$
L _ { k } = \frac { ( \nu _ { k } + 1 - D ) \beta _ { k } } { ( 1 + \beta _ { k } ) } \mathbf W _ { k }
$$

in which ν k is given by (10.63). When the size N of the data set is large the predictive distribution (10.81) reduces to a mixture of Gaussians.

# 10.2.4 Determining the number of components

We have seen that the variational lower bound can be used to determine a posterior distribution over the number K of components in the mixture model. There is, however, one subtlety that needs to be addressed. For any given setting of the parameters in a Gaussian mixture model (except for speciﬁc degenerate settings), there will exist other parameter settings for which the density over the observed variables will be identical. These parameter values differ only through a re-labelling of the components. For instance, consider a mixture of two Gaussians and a single observed variable x , in which the parameters have the values π 1 = a , π 2 = b , µ 1 = c , µ 2 = d , σ 1 = e , σ 2 = f . Then the parameter values π 1 = b , π 2 = a , µ 1 = d , µ 2 = c , σ 1 = f , σ 2 = e , in which the two components have been exchanged, will by symmetry give rise to the same value of p ( x ) . If we have a mixture model comprising K components, then each parameter setting will be a member of a family of K ! equivalent settings.

In the context of maximum likelihood, this redundancy is irrelevant because the parameter optimization algorithm (for example EM) will, depending on the initialization of the parameters, ﬁnd one speciﬁc solution, and the other equivalent solutions play no role. In a Bayesian setting, however, we marginalize over all possible
