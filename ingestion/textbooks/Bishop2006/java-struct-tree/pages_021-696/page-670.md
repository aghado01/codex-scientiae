[Page 670]

(13.68) where the quantities ω(zn) are deﬁned by (13.70). Show that the initial condition for this recursion is given by (13.69).

13.17 (�) www Show that the directed graph for the input-output hidden Markov model, given in Figure 13.18, can be expressed as a tree-structured factor graph of the form shown in Figure 13.15 and write down expressions for the initial factor h(z1) and for the general factor fn(zn−1,zn) where 2 � n � N.

13.18 (���) Using the result of Exercise 13.17, derive the recursion equations, including the initial conditions, for the forward-backward algorithm for the input-output hidden Markov model shown in Figure 13.18.

13.19 (�) www The Kalman ﬁlter and smoother equations allow the posterior distributions over individual latent variables, conditioned on all of the observed variables, to be found efﬁciently for linear dynamical systems. Show that the sequence of latent variable values obtained by maximizing each of these posterior distributions individually is the same as the most probable sequence of latent values. To do this, simply note that the joint distribution of all latent and observed variables in a linear dynamical system is Gaussian, and hence all conditionals and marginals will also be Gaussian, and then make use of the result (2.98).

13.20 (��) www Use the result (2.115) to prove (13.87). 13.21 (��) Use the results (2.115) and (2.116), together with the matrix identities (C.5)

and (C.7), to derive the results (13.89), (13.90), and (13.91), where the Kalman gain matrix Kn is deﬁned by (13.92).

13.22 (��) www Using (13.93), together with the deﬁnitions (13.76) and (13.77) and

the result (2.115), derive (13.96).

13.23 (��) Using (13.93), together with the deﬁnitions (13.76) and (13.77) and the result

(2.116), derive (13.94), (13.95) and (13.97).

13.24 (��) www Consider a generalization of (13.75) and (13.76) in which we include

constant terms a and c in the Gaussian means, so that

p(zn|zn−1) = N(zn|Azn−1 + a,Γ) (13.127) p(xn|zn) = N(xn|Czn + c,Σ). (13.128)

Show that this extension can be re-case in the framework discussed in this chapter by deﬁning a state vector z with an additional component ﬁxed at unity, and then augmenting the matrices A and C using extra columns corresponding to the parameters a and c.

13.25 (��) In this exercise, we show that when the Kalman ﬁlter equations are applied to independent observations, they reduce to the results given in Section 2.3 for the maximum likelihood solution for a single Gaussian distribution. Consider the problem of ﬁnding the mean µ of a single Gaussian random variable x, in which we are given a set of independent observations {x1,...,xN}. To model this we can use
