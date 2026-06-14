# Manifest: Page 005

## REPAIR_MATH
- RAW: ```
f ( t ) = & \frac { \lambda ( t ) } { \int _ { 0 } ^ { T } \lambda ( u ) \, d u }
```
  FIX: ```
$$
f ( t ) = & \frac { \lambda ( t ) } { \int _ { 0 } ^ { T } \lambda ( u ) \, d u }
$$
```

## REPAIR_PROSE
- RAW: ```
then it becomes clear that estimation of λ( t ) amounts to estimation of the probability density f ( t ), together with estimation of . We use N = n as an estimate of , and apply logspline to estimate f ( t ). logspline returns a set of knots for a cubic spline, and these are used as initial values for BARS in the Poisson case.
```
  FIX: ```
then it becomes clear that estimation of \( \lambda(t) \) amounts to estimation of the probability density \( f(t) \), together with estimation of FILL_ME_IN. We use \( N = n \) as an estimate of FILL_ME_IN, and apply logspline to estimate \( f(t) \). logspline returns a set of knots for a cubic spline, and these are used as initial values for BARS in the Poisson case.
```

- RAW: ```
In describing the Poisson regressions we take the Poisson parameter to be μ . Thus, at time points t 1 , . . . , t n we have corresponding mean values μ 1 , . . . , μ n . (In the neuronal setting with m repeated trials, for the histogram bin centered at t j , the expected number of spiking events is μ j = mwλ ( t j ) where w is the bin width in seconds and λ( t ) is in units of spiking events per second.)
```
  FIX: ```
In describing the Poisson regressions we take the Poisson parameter to be \( \mu \). Thus, at time points \( t_1, \dots, t_n \) we have corresponding mean values \( \mu_1, \dots, \mu_n \). (In the neuronal setting with \( m \) repeated trials, for the histogram bin centered at \( t_j \), the expected number of spiking events is \( \mu_j = m w \lambda(t_j) \) where \( w \) is the bin width in seconds and \( \lambda(t) \) is in units of spiking events per second.)
```

- RAW: ```
- 4. Run MCMC. For g = 1, . . . , G b , where G b is the number of burn-in iterations, do steps (a) and (b) only; subsequently do all of (a)-(e):
```
  FIX: ```
- 4. Run MCMC. For \( g = 1, \dots, G_b \), where \( G_b \) is the number of burn-in iterations, do steps (a) and (b) only; subsequently do all of (a)-(e):
```

- RAW: ```
- a. Take knot step: addition, deletion, or relocation. This produces ξ ( g ) .
```
  FIX: ```
- a. Take knot step: addition, deletion, or relocation. This produces \( \xi^{(g)} \).
```

- RAW: ```
- c. Generate β ( g ) .
- d. Using β ( g ) , obtain fits and also BIC, loglikelihood, maximum, location of the maximum, and number of interior knots.
```
  FIX: ```
- c. Generate \( \beta^{(g)} \).
- d. Using \( \beta^{(g)} \), obtain fits and also BIC, loglikelihood, maximum, location of the maximum, and number of interior knots.
```
