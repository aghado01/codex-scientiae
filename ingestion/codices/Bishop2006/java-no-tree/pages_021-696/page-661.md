[Page 661]

Figure 13.22 An illustration of a linear dynamical system being used to track a moving object. The blue points indicate the true positions of the object in a two-dimensional space at successive time steps, the green points denote noisy measurements of the positions, and the red crosses indicate the means of the inferred posterior distributions of the positions obtained by running the Kalman ﬁltering equations. The covariances of the inferred positions are indicated by the red ellipses, which correspond to contours having one standard deviation.

β(zn), which, for continuous latent variables, can be written in the form

###### cn+1 β(zn) = β(zn+1)p(xn+1|zn+1)p(zn+1|zn)dzn+1. (13.99)

We now multiply both sides of (13.99) by α(zn) and substitute for p(xn+1|zn+1) and p(zn+1|zn) using (13.75) and (13.76). Then we make use of (13.89), (13.90)

- Exercise 13.29 and (13.91), together with (13.98), and after some manipulation we obtain µn = µn + Jn µn+1 − AµN (13.100) Vn = Vn + Jn Vn+1 − Pn JTn (13.101)


where we have deﬁned

###### Jn = VnAT (Pn)−1 (13.102)

and we have made use of AVn = PnJTn. Note that these recursions require that the forward pass be completed ﬁrst so that the quantities µn and Vn will be available for the backward pass.

For the EM algorithm, we also require the pairwise posterior marginals, which can be obtained from (13.65) in the form

ξ(zn−1,zn) = (cn)−1 α(zn−1)p(xn|zn)p(zn|z−1) β(zn)

= N(zn−1|µn−1,Vn−1)N(zn|Azn−1,Γ)N(xn|Czn,Σ)N(zn| µn, Vn) cn α(zn)

.

(13.103)

Substituting for α(zn) using (13.84) and rearranging, we see that ξ(zn−1,zn) is a Gaussian with mean given with components γ(zn−1) and γ(zn), and a covariance

###### Exercise 13.31 between zn and zn−1 given by cov[zn,zn−1] = Jn−1 Vn. (13.104)
