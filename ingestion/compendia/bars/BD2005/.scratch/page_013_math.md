[Page 13]

In implementing the RJMCMC algorithm described above, we run a burn-in period of several thousand iterations until convergence is apparent. Convergence is evidenced by the stationarity of the distribution of the marginal likelihood in (5) and the distribution of k, the dimension of sampled models. Then the sampler is run for an additional period, during which each selected piecewise linear function is saved. Final estimates of the population regression function are based on averages over all the saved models, and credible intervals for the response can be calculated for any set of covariate values. In addition, the subject-speciﬁc coeﬃcients are saved at each step, so that the individual regression function can be estimated and individual credible intervals can be calculated.

The analysis is conducted using Matlab version 7.0.1. The method is computationally intensive, especially for large datasets. However, the rates of convergence and mixing are good enough that it can be practically implemented even in complex settings, such as that described in the data example.

The simulated data do not mimic longitudinal data with reference points. Rather, we illustrate the broad applicability of the method by simulating clustered data with a covariate-dependent random eﬀect. We simulated data for 200 subjects, with each subject contributing 30 observations from the following distribution:

$$
( y _ { i j } | x _ { i j } ) \sim N \left ( x _ { 1 i j } - x _ { 2 i j } ^ { 2 } + x _ { 1 i j } x _ { 2 i j } + b _ { i } \sqrt { 2 | x _ { 1 i j } | }, \ 2 \right )
$$

where the covariates x 1 ij and x 2 ij for the j t h observation from subject i are randomly generated integers between -4 and 4, and b i is a N (0, 1) random term for subject i.Note that the random eﬀect varies non-linearly with x 1.We want the method to be able to detect this variation. In addition, the model-estimated population mean, subject-
