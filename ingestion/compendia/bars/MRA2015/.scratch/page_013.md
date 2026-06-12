
# 1.2 Time Series

A time series is a sequence of random variables $\{Y_t\}$ at time points $t = 0, \pm 1, \pm 2, \pm 3, \dots$, which can also be viewed as a stochastic process. The expected value of the process at time t is given by

$$
E ( Y _ { t } ) = \mu _ { t } , \ \ t = 0 , \pm 1 , \pm 2 , \pm 3 , \dots ,
$$

and its autocovariance function , $\gamma_{t,s}$ , is defined to be

$$
E \left [ ( Y _ { t } - \mu _ { t } ) ( Y _ { s } - \mu _ { s } ) \right ] = \text{Cov} ( Y _ { t } , Y _ { s } ) = \gamma _ { t , s } ,
$$

for all time points $t,s = 0, \pm 1, \pm 2, \pm 3, \dots$ . For a time series, analysis can be done in either the time domain or in the frequency domain. When we speak of time domain analysis, data are analyzed over a period of time. The time unit can be seconds, minutes, hours, etc.

The monthly values of the Southern Oscillation Index (SOI) are an example of a time series, see Figure 1.2. In Chapter 5, more details will be given for this particular time series.

Correlation properties of a time series are usually the basis for the analysis in the time domain. Parametric models that we wish to fit to a time series take this correlation into account. For example, consider the process $\{Y_t\}$ . If we wish to fit the following autoregressive model of order 2

$$
Y _ { t } = \phi _ { 1 } Y _ { t - 1 } + \phi _ { 2 } Y _ { t - 2 } + e _ { t }
$$

then the data $y_1, \dots, y_n$ are used to estimate the parameters $\phi_1$ and $\phi_2$ . The error terms $e_1, \dots, e_n$ are assumed independent, identically distributed random variables with mean zero and variance $\sigma^2_e$ .

In frequency domain analysis, a time series is analyzed based on its frequency properties. Consider the cosine wave

$$
Y _ { t } = R \cos ( 2 \pi \omega t + \Phi ) + e _ { t } ,
$$
