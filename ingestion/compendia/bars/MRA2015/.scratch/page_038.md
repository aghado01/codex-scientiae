
# Chapter 4

# Spatially Adaptive Smoothing for Spectral Analysis

A brief introduction to time series was given in Chapter 1. It was mentioned that time series analysis can be done in either the time domain or the frequency domain. In this chapter we focus on the frequency domain.

# 4.1 Spectral Analysis

# 4.1.1 Stationarity

The idea of stationarity is that the mean and variance of a time series are constant for all time points t . A process is said to be weakly stationary, if it has a constant mean and

$$
\gamma _ { t , s } = C o v ( Y _ { t - s } , Y _ { 0 } ) = C o v ( Y _ { 0 } , Y _ { t - s } ) = C o v ( Y _ { 0 } , Y _ { | t - s | } ) = \gamma _ { | t - s | } ,
$$

for all time points t,s . Unlike weak stationarity, a process { Y t } is strictly stationary, when the joint distributions for the variables Y t 1 ,...,Y t n and Y t 1 − ,...,Y t n − are the same for all time points t = 1 ,...,n and lags (Cryer and Chan, 2008).

# 4.1.2 Periodogram

In Chapter 1, we briefly discussed the frequency domain and showed how the cosine wave (1.3) can be expanded using Trigonometric identities. In this section, the saturated cosine model will be introduced. For any time series sample y 1 ,...,y n , where n is odd, we can
