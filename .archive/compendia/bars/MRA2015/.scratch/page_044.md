
In this section we explore the model presented via Monte Carlo simulations. Samples are generated from an AR(2) model,

$$
Y _ { t } = \phi _ { 1 } Y _ { t - 1 } + \phi _ { 2 } Y _ { t - 2 } + e _ { t } , \ \ e _ { t } \sim N ( 0 , \sigma _ { e } ^ { 2 } ) .
$$

In the first simulation setting, φ 1 = 1 . 5 and φ 2 = − 0 . 75 while in the second simulation setting, φ 1 = 0 . 1 and φ 2 = 0 . 4. The theoretical spectral density for an AR(2) process is

$$
f ( \omega ) = \frac { \sigma _ { e } ^ { 2 } } { 1 + \phi _ { 1 } ^ { 2 } + \phi _ { 2 } ^ { 2 } - 2 \phi _ { 1 } ( 1 - \phi _ { 2 } ) \cos ( 2 \pi \omega ) - 2 \phi _ { 2 } \cos ( 4 \pi \omega ) } .
$$

This spectral density may have different shapes depending on the values of φ 1 and φ 2 . The first setting has peaked spectrum, while the second one has trough spectrum. Ten samples of size 1000 are generated from each setting. Each sample was run for 2000 MCMC iterations with a burn-in period of 500. Two versions of the model were fit to the samples: spatially adaptive and non spatially adaptive. Quadratic basis functions and K κ = 30 knots were used for the non-adaptive and adaptive fits. For the adaptive case, K ι = 10 knots with basis functions of degree q = 0 are used. Additionally, the plots also display the “smoothed” periodogram using a third (frequentist) method presented by Cryer and Chan (2008). For the Bayesian methods, pointwise 95% credible intervals are also displayed. For the frequentist methods, pointwise 95% confidence intervals are computed as follows:

$$
\log [ \bar { f } ( \omega ) ] + \log \left [ \frac { d f } { \chi _ { d f , 1 - \alpha / 2 } ^ { 2 } } \right ] \leq \log [ f ( \omega ) ] \leq \log [ \bar { f } ( \omega ) ] \leq + \log \left [ \frac { d f } { \chi _ { d f , \alpha / 2 } ^ { 2 } } \right ] ,
$$

where f ( ω ) is the smoothed periodogram given by

$$
\bar { f } ( \omega ) = \sum _ { \ell = - a } ^ { a } W _ { a } ( \ell ) I _ { n } \left ( \omega + \frac { \ell } { n } \right ) .
$$

In equation (4.19), The degrees of freedom in equation (4.18) are given by

$$
W _ { a } ( \ell ) = \frac { 1 } { 2 a + 1 } , \quad - a \leq \ell \leq a .
$$
