
Moreover, he shows that for large n the likelihood for { Y t } , conditional on f , can be approximated by

$$
\text {proximated by} \\ p ( y | f ) & = \prod _ { m = 1 } ^ { M } f ( \omega _ { m } ) ^ { - 1 } \exp \left \{ - I _ { n } ( \omega _ { m } ) / f ( \omega _ { m } ) \right \} \\ & = \prod _ { m = 1 } ^ { M } \exp \{ - \log f ( \omega _ { m } ) - I _ { n } ( \omega _ { m } ) / f ( \omega _ { m } ) \} \\ & = \prod _ { m = 1 } ^ { M } \exp \{ - \log f ( \omega _ { m } ) - I _ { n } ( \omega _ { m } ) \exp [ - \log f ( \omega _ { m } ) ] \} \, . \\ \text {et.} \, - \log f ( \omega _ { m } ) & = c ^ { \prime } \, \theta . \text { where } c ^ { \prime } \text { is the math row of } C . \text { Then } ( 4 . 1 3 ) \text { becomes}
$$

Let − log f ( ω m ) = c m θ , where c m is the m th row of C . Then (4.13) becomes

$$
p ( y | f ) = \exp \left \{ \sum _ { m = 1 } ^ { M } [ c _ { m } ^ { \prime } \theta - I _ { n } ( \omega _ { m } ) \exp ( c _ { m } ^ { \prime } \theta ) ] \right \} .
$$

Whittle likelihood has been used before to estimate the spectral density. Early references include Wahba (1980) who modeled the log-spectral density using cubic smoothing splines and Pawitan and O’Sullivan (1994) who used a penalized version of the Whittle likelihood. The next section will be devoted to prior specification on the parameters for this model.

# 4.3 Priors

In this section, the priors for the Whittle likelihood result in a spatially adaptive estimate of the spectral density, similar to the spatially adaptive estimates in Chapter 3. Firstly, the prior placed on the fixed coefficients β remains the same, as in Chapter 2. Recall that in order to make the estimate spatially adaptive, we placed a normal prior on the b j ’s with variance δ − 1 j . For spectral smoothing, we make a slight alteration to the precisions. The parameter τ no longer appears in the likelihood, so δ in this chapter is simply a scale parameter, no longer equal to τξ 1 , as was the case in Chapter 2. Then, let δ j = δ exp( γ j ). The prior placed on b is

$$
( b | \gamma , \delta ) \sim N ( 0 , \delta ^ { - 1 } D _ { \gamma } ^ { - 1 } ) ,
$$
