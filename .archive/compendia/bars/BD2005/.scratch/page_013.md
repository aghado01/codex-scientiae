[Page 13]

### 2.3 Computation

In implementing the RJMCMC algorithm described above, we run a burn-in period of several thousand iterations until convergence is apparent. Convergence is evidenced by the stationarity of the distribution of the marginal likelihood in (5) and the distribution of $k$, the dimension of sampled models. Then the sampler is run for an additional period, during which each selected piecewise linear function is saved. Final estimates of the population regression function are based on averages over all the saved models, and credible intervals for the response can be calculated for any set of covariate values. In addition, the subject-specific coefficients are saved at each step, so that the individual regression function can be estimated and individual credible intervals can be calculated.

The analysis is conducted using Matlab version 7.0.1. The method is computationally intensive, especially for large datasets. However, the rates of convergence and mixing are good enough that it can be practically implemented even in complex settings, such as that described in the data example.

## 3. Simulated Data Example

The simulated data do not mimic longitudinal data with reference points. Rather, we illustrate the broad applicability of the method by simulating clustered data with a covariate-dependent random effect. We simulated data for 200 subjects, with each subject contributing 30 observations from the following distribution:

$$
(y_{ij} \mid x_{ij}) \sim N\!\left(x_{1ij} - x_{2ij}^2 + x_{1ij}x_{2ij} + b_i\sqrt{2|x_{1ij}|},\; 2\right)
$$
