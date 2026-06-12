
$$
\alpha _ { v } = \min \left \{ \frac { \pi ( b _ { \gamma v } ^ { * } ) } { \pi ( b _ { \gamma v } ^ { ( t ) } ) } , 1 \right \}
$$

to update each block where the proposal distribution for the new value b ∗ γv is the prior distribution for b γ , i.e., π ( b γv ) = p ( b γv | b , b γ ( − v ) , γ ,τ,ξ 1 ,ξ 2 , γ ) and b γ ( − v ) is the vector containing the remaining vectors.

Details on the sampling scheme can be found in Appendix A.2.

# 3.6 Simulation Study

In this section we conduct Monte Carlo simulations using the BAPS model. Based on the examples presented, we compare the performance of the BAPS model with its non-adaptive version, the Bayesian Penalized Splines (BPS) model. Two different functions taken from Yue et al. (2012) are used for the simulation. One is a smoothly varying function, and the other is a spatially inhomogeneous function. For each setting, we present 10 different simulations. The number of knots for the BAPS and the BPS models is K κ = 30 with sub knots K ι = 10 for the BAPS model. Pointwise 95% credible intervals are also part of the displays. The fixed parameters were set to c 1 = c 2 = 1 in the posterior distributions for the parameters ρ 1 and ρ 2 in the BAPS model. For the BPS model A = A b = B = B b = 0

For the first setting, we consider a natural spline with knots located at the points (0 . 2 , 0 . 6 , 0 . 7) and coefficients (20 , 4 , 6 , 11 , 6). We evaluate the knots and coefficients at n=101 equally spaced points on [0 , 1]. Gaussian noise with mean zero and standard deviation τ − 1 / 2 = 0 . 9 was added to the function values. The degree of the basis functions used for the estimation is p = 2. Figures 3.1 and 3.2 show the BAPS estimates and BPS estimates for the natural spline function. Figure 3.1 shows the results corresponding to five simulated samples while Figure 3.2 displays the results for the remaining five simulated
