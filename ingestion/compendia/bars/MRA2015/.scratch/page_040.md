
# 4.1.3 The Spectral Density

If the autocovariance function, γ , of a stationary process satisfies

$$
\sum _ { \ell = - \infty } ^ { \infty } | \gamma _ { \ell } | < \infty ,
$$

then it can be represented as

$$
\gamma _ { \ell } = \int _ { - 1 / 2 } ^ { 1 / 2 } f ( \omega ) \exp ( - 2 \pi i \ell \omega ) d \omega , \quad \ell = 0 , \pm 1 , \pm 2 , \dots
$$

where the spectral density, f ( ω ), has the representation

$$
f ( \omega ) = \sum _ { \ell = - \infty } ^ { \infty } \gamma _ { \ell } \exp ( - 2 \pi i \ell \omega ) , \quad - 1 / 2 \leq \omega \leq 1 / 2 .
$$

The spectral density is symmetric over the domain − 1 / 2 ≤ ω ≤ 1 / 2, i.e., f ( ω ) = f ( − ω ), periodic and nonnegrative. From (4.10), for = 0, γ 0 = Var( Y t ) = 1 / 2 − 1 / 2 f ( ω ) dω . This shows that the total variance of the time series is the integral of f ( ω ) over the entire range of frequencies. All mathematical properties of probability density functions can be applied to spectral densities with the exception that the area under the spectral density is Var( Y t ).

# 4.2 Model

Let ω m = m/n , for m = 1 ,...,M , be the Fourier frequencies where M = n − 1) / 2 . The notation w represents the largest integer not greater than w . Again, let C = [ X,Z ] where X denotes the m × ( p + 1) matrix whose i th row is (1 ,ω i ,...,ω p i ) and Z is a matrix whose i th row is equal to (( ω i − κ 1 ) p + ,..., ( ω i − κ K κ ) p + ). Given a stationary process { Y t } , Whittle (1957) shows that the values I n ( ω m ) are approximately independent and exponentially distributed with mean f ( ω m ), i.e., the pdf of I n ( ω m ) is given by

$$
p ( I _ { n } ( \omega _ { m } ) ) = f ( \omega _ { m } ) ^ { - 1 } \exp ( - I _ { n } ( \omega _ { m } ) / f ( \omega _ { m } ) ) .
$$
