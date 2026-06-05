[Page 626]

Figure 13.1 Example of a spectrogram of the spoken words “Bayes’ theorem” showing a plot of the intensity of the spectral coefﬁcients versus time index.

![The image is a graphical representation of a spectrum of frequencies. The spectrum is shown in a logarithmic scale, with the frequency represented in logarithmic units. The x-axis represents the time in seconds, while the y-axis represents the frequency in hertz. The frequency is shown in intervals of 100 Hz, with intervals of 1 Hz and 10 Hz. The spectrum is divided into two main sections: 1. **Upper Section (10 Hz to 100 Hz):** - The upper section shows a spectrum of frequencies at 10 Hz to 100 Hz. - The frequencies are shown in intervals of 1 Hz and 10 Hz. - The frequency values range from 0.0 to 0.3, with intervals of 1 Hz and 10 Hz. - The frequency values are shown in increments of 1 Hz. - The frequency values are shown in intervals of 1 Hz](../images/imageFile46.png)

1oo00

6000

4000

2000

0.3

0.15

1

-0.15

-0.3

0.6

0.2

0.4

0.8

Time (sec)

th |

ih |

bl

ey

er

em

Bayes'

Theorem

It is useful to distinguish between stationary and nonstationary sequential distributions. In the stationary case, the data evolves in time, but the distribution from which it is generated remains the same. For the more complex nonstationary situation, the generative distribution itself is evolving with time. Here we shall focus on the stationary case.

For many applications, such as ﬁnancial forecasting, we wish to be able to predict the next value in a time series given observations of the previous values. Intuitively, we expect that recent observations are likely to be more informative than more historical observations in predicting future values. The example in Figure 13.1 shows that successive observations of the speech spectrum are indeed highly correlated. Furthermore, it would be impractical to consider a general dependence of future observations on all previous observations because the complexity of such a model would grow without limit as the number of observations increases. This leads us to consider Markov models in which we assume that future predictions are inde-
