[Page 691]

![image 165](../../../../../images/imageFile165.png)

- Figure 14.9 The left plot shows the predictive conditional density corresponding to the converged solution in Figure 14.8. This gives a log likelihood value of −3.0. A vertical slice through one of these plots at a particular value of x represents the corresponding conditional distribution p(t|x), which we see is bimodal. The plot on the right shows the predictive density for a single linear regression model ﬁtted to the same data set using maximum likelihood. This model has a smaller log likelihood of −27.6.


function is then given by

N

###### K

###### nk [1 − ynk]1−tn (14.46)

p(t|θ) =

πkyt

n

n=1

k=1

where ynk = σ(wkTφn) and t = (t1,...,tN)T. We can maximize this likelihood function iteratively by making use of the EM algorithm. This involves introducing

latent variables znk that correspond to a 1-of-K coded binary indicator variable for each data point n. The complete-data likelihood function is then given by

N

###### K

###### nk [1 − ynk]1−tn znk (14.47)

p(t,Z|θ) =

πkyt

n

n=1

k=1

where Z is the matrix of latent variables with elements znk. We initialize the EM algorithm by choosing an initial value θold for the model parameters. In the E step, we then use these parameter values to evaluate the posterior probabilities of the components k for each data point n, which are given by

nk [1 − ynk]1−tn j πjyt

πkyt

n

γnk = E[znk] = p(k|φn,θold) =

. (14.48)

nj [1 − ynj]1−tn

n

These responsibilities are then used to ﬁnd the expected complete-data log likelihood as a function of θ, given by

Q(θ,θold) = EZ [lnp(t,Z|θ)]

N

###### K

=

γnk {lnπk + tn lnynk + (1 − tn)ln(1 − ynk)}. (14.49)

n=1

k=1
