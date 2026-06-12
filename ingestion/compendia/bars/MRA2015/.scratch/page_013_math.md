[Page 13]

A time series is a sequence of random variables { Y t } at time points t = 0, ± 1, ± 2, ± 3,..., which can also be viewed as a stochastic process. The expected value of the process at time t is given by

$$
E ( Y _ { t } ) = \mu _ { t }, \ \ t = 0, \pm 1, \pm 2, \pm 3, \dots,
$$

and its autocovariance function, γ t,s, is deﬁned to be

$$
E \left [ ( Y _ { t } - \mu _ { t } ) ( Y _ { s } - \mu _ { s } ) \right ] = C o v ( Y _ { t }, Y _ { s } ) = \gamma _ { t, s },
$$

for all time points t,s = 0, ± 1, ± 2, ± 3,....For a time series, analysis can be done in either the time domain or in the frequency domain. When we speak of time domain analysis, data are analyzed over a period of time. The time unit can be seconds, minutes, hours, etc.

The monthly values of the Southern Oscillation Index (SOI) are an example of a time series, see Figure 1.2. In Chapter 5, more details will be given for this particular time series.

Correlation properties of a time series are usually the basis for the analysis in the time domain. Parametric models that we wish to ﬁt to a time series take this correlation into account. For example, consider the process { Y t }.If we wish to ﬁt the following autoregressive model of order 2

$$
Y _ { t } = \phi _ { 1 } Y _ { t - 1 } + \phi _ { 2 } Y _ { t - 2 } + e _ { t }
$$

then the data y 1,...,y n are used to estimate the parameters φ 1 and φ 2.The error terms e 1,...e n are assumed independent, identically distributed random variables with mean zero and variance σ 2 e .

In frequency domain analysis, a time series is analyzed based on its frequency properties. Consider the cosine wave

$$
Y _ { t } = R \cos ( 2 \pi \omega t + \Phi ) + e _ { t },
$$
