[Page 14]



SOI

−20

−40

1880

1900

1920

1940

1960

1980

2000

2020

Year

Figure 1.2: Monthly values of the Southern Osciallation Index (SOI).

where the amplitude of the cosine function (1.3) is R > 0, its frequency is ω, and Φ is its phase. The period of the wave, 1 /ω, is the time it takes to complete a cycle. Model (1.3) is not very convenient in estimation since it is not linear in Φ. Using a Trigonometric identity, model (1.3) can be rewritten as

$$
Y _ { t } = A \cos ( 2 \pi \omega t ) + B \sin ( 2 \pi \omega t ) + e _ { t },
$$

where R = √ A 2 + B 2 and Φ = arctan( − B/A ), and conversely, A = R cos(Φ) and B = − R sin(Φ). For a ﬁxed frequency ω, cos(2 πωt ) and sin(2 πωt ) are used as predictor variables and the A and B are estimated using ordinary least squares. In Chapter 4, we will see how this cosine wave helps motivate spectral analysis.

The thesis is structured as follows: Chapter 2 introduces penalized splines in a Bayesian approach and the core model of the thesis. Chapter 3 covers spatially adaptive nonparamtric regression. In Chapter 4, we discuss spectral time series analysis and deﬁne
