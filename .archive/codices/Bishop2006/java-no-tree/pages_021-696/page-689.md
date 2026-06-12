[Page 689]

problem, in which the term corresponding to the nth data point carries a weighting coefﬁcient given by βγnk, which could be interpreted as an effective precision for each data point. We see that each component linear regression model in the mixture, governed by its own parameter vector wk, is ﬁtted separately to the whole data set in the M step, but with each data point n weighted by the responsibility γnk that model

- k takes for that data point. Setting the derivative of (14.39) with respect to wk equal to zero gives


N

0 =

γnk tn − wkTφn φn (14.40) which we can write in matrix notation as

n=1

###### 0 = ΦTRk(t − Φwk) (14.41)

where Rk = diag(γnk) is a diagonal matrix of size N × N. Solving for wk, we obtain

wk = ΦTRkΦ −1 ΦTRkt. (14.42) This represents a set of modiﬁed normal equations corresponding to the weighted least squares problem, of the same form as (4.99) found in the context of logistic regression. Note that after each E step, the matrix Rk will change and so we will have to solve the normal equations afresh in the subsequent M step.

Finally, we maximize Q(θ,θold) with respect to β. Keeping only terms that depend on β, the function Q(θ,θold) can be written

N

###### K

Q(θ,θold) =

γnk

n=1

k=1

1 2

β 2

lnβ −

tn − wkTφn 2 . (14.43)

Setting the derivative with respect to β equal to zero, and rearranging, we obtain the M-step equation for β in the form

N

###### K

1 β

1 N

γnk tn − wkTφn 2 . (14.44)

=

n=1

k=1

In Figure 14.8, we illustrate this EM algorithm using the simple example of ﬁtting a mixture of two straight lines to a data set having one input variable x and one target variable t. The predictive density (14.34) is plotted in Figure 14.9 using the converged parameter values obtained from the EM algorithm, corresponding to the right-hand plot in Figure 14.8. Also shown in this ﬁgure is the result of ﬁtting a single linear regression model, which gives a unimodal predictive density. We see that the mixture model gives a much better representation of the data distribution, and this is reﬂected in the higher likelihood value. However, the mixture model also assigns signiﬁcant probability mass to regions where there is no data because its predictive distribution is bimodal for all values of x. This problem can be resolved by extending the model to allow the mixture coefﬁcients themselves to be functions of x, leading to models such as the mixture density networks discussed in Section 5.6, and hierarchical mixture of experts discussed in Section 14.5.3.
