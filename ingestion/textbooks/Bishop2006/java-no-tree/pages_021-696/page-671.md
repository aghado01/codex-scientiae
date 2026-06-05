[Page 671]

- a linear dynamical system governed by (13.75) and (13.76), with latent variables {z1,...,zN} in which C becomes the identity matrix and where the transition probability A = 0 because the observations are independent. Let the parameters m0 and V0 of the initial state be denoted by µ0 and σ02, respectively, and suppose that Σ becomes σ2. Write down the corresponding Kalman ﬁlter equations starting from the general results (13.89) and (13.90), together with (13.94) and (13.95). Show that these are equivalent to the results (2.141) and (2.142) obtained directly by considering independent data.
- 13.26 ( ) Consider a special case of the linear dynamical system of Section 13.3 that is equivalent to probabilistic PCA, so that the transition matrix A = 0, the covariance Γ = I, and the noise covariance Σ = σ2I. By making use of the matrix inversion identity (C.7) show that, if the emission density matrix C is denoted W, then the posterior distribution over the hidden states deﬁned by (13.89) and (13.90) reduces to the result (12.42) for probabilistic PCA.
- 13.27 ( ) www Consider a linear dynamical system of the form discussed in Section 13.3 in which the amplitude of the observation noise goes to zero, so that Σ = 0.

Show that the posterior distribution for zn has mean xn and zero variance. This accords with our intuition that if there is no noise, we should just use the current

observation xn to estimate the state variable zn and ignore all previous observations.

- 13.28 ( ) Consider a special case of the linear dynamical system of Section 13.3 in which the state variable zn is constrained to be equal to the previous state variable, which corresponds to A = I and Γ = 0. For simplicity, assume also that V0 → ∞ so that the initial conditions for z are unimportant, and the predictions are determined purely by the data. Use proof by induction to show that the posterior mean for state

zn is determined by the average of x1,...,xn. This corresponds to the intuitive result that if the state variable is constant, our best estimate is obtained by averaging the observations.

- 13.29 ( ) Starting from the backwards recursion equation (13.99), derive the RTS smoothing equations (13.100) and (13.101) for the Gaussian linear dynamical system.
- 13.30 ( ) Starting from the result (13.65) for the pairwise posterior marginal in a state space model, derive the speciﬁc form (13.103) for the case of the Gaussian linear dynamical system.
- 13.31 ( ) Starting from the result (13.103) and by substituting for α(zn) using (13.84), verify the result (13.104) for the covariance between zn and zn−1.
- 13.32 ( ) www Verify the results (13.110) and (13.111) for the M-step equations for µ0 and V0 in the linear dynamical system.

- 13.33 ( ) Verify the results (13.113) and (13.114) for the M-step equations for A and Γ in the linear dynamical system.
