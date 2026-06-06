[Page 125]

Γ(D/2 + ν/2) Γ(ν/2)

|Λ|1/2 (πν)D/2

St(x|µ,Λ,ν) =

∆2 ν

1 +

−D/2−ν/2

(2.162)

where D is the dimensionality of x, and ∆2 is the squared Mahalanobis distance deﬁned by

∆2 = (x − µ)TΛ(x − µ). (2.163) This is the multivariate form of Student’s t-distribution and satisﬁes the following

- Exercise 2.49 properties


E[x] = µ, if ν > 1 (2.164) cov[x] =

ν (ν − 2)

Λ−1, if ν > 2 (2.165) mode[x] = µ (2.166)

with corresponding results for the univariate case.

###### 2.3.8 Periodic variables

Although Gaussian distributions are of great practical signiﬁcance, both in their own right and as building blocks for more complex probabilistic models, there are situations in which they are inappropriate as density models for continuous variables. One important case, which arises in practical applications, is that of periodic variables.

An example of a periodic variable would be the wind direction at a particular geographical location. We might, for instance, measure values of wind direction on a number of days and wish to summarize this using a parametric distribution. Another example is calendar time, where we may be interested in modelling quantities that are believed to be periodic over 24 hours or over an annual cycle. Such quantities can conveniently be represented using an angular (polar) coordinate 0 θ < 2π.

We might be tempted to treat periodic variables by choosing some direction as the origin and then applying a conventional distribution such as the Gaussian. Such an approach, however, would give results that were strongly dependent on the arbitrary choice of origin. Suppose, for instance, that we have two observations at θ1 = 1◦ and θ2 = 359◦, and we model them using a standard univariate Gaussian distribution. If we choose the origin at 0◦, then the sample mean of this data set will be 180◦ with standard deviation 179◦, whereas if we choose the origin at 180◦, then the mean will be 0◦ and the standard deviation will be 1◦. We clearly need to develop a special approach for the treatment of periodic variables.

Let us consider the problem of evaluating the mean of a set of observations D = {θ1,...,θN} of a periodic variable. From now on, we shall assume that θ is measured in radians. We have already seen that the simple average (θ1+···+θN)/N will be strongly coordinate dependent. To ﬁnd an invariant measure of the mean, we note that the observations can be viewed as points on the unit circle and can therefore be described instead by two-dimensional unit vectors x1,...,xN where xn = 1 for n = 1,...,N, as illustrated in Figure 2.17. We can average the vectors {xn}
