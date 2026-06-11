[Page 9]

Table 1. Simulation study. Average mean squared errors with estimated standard errors in brackets based on 10 samples obtained using four different procedures

| | SARS | DMS | Modified DMS | BARS |
|---|---|---|---|---|
| Example 1 | 0.144 (0.030) | 0.206 (0.029) | 0.103 (0.019) | 0.066 (0.007) |
| Example 2 | 0.015 (0.001) | 0.025 (0.002) | 0.012 (0.001) | 0.008 (0.001) |
| Example 3 | 0.044 (0.006) | 0.106 (0.007) | 0.091 (0.004) | 0.019 (0.003) |

*Methods: SARS, spatially adaptive regression splines; DMS, Denison et al. (1998); Modified DMS, modified Denison et al.; BARS, Bayesian adaptive regression splines.*

However, in Examples 1 and 3, Bayesian adaptive regression splines provides substantial further improvement, in part as a result of the locality heuristic for generating new knots. In Fig. 2, we see the true function of Example 3 together with its estimates obtained using different procedures. Figure 2 suggests that the success of Bayesian adaptive regression splines results from its avoiding overfitting and its ability to adapt to sharp jumps in the curves.

![Four panels comparing estimates of the discontinuous function of Example 3 for SARS, DMS, Modified DMS, and BARS methods.](<images/DMGK2001/imageFile2.png>)

Fig. 2. Simulation study. Comparisons of the estimates of the discontinuous function of Example 3: solid lines, true curves; dashed lines, estimates of the curve. Methods: SARS, spatially adaptive regression splines; DMS, Denison et al. (1998); Modified DMS, modified Denison et al.; BARS, Bayesian adaptive regression splines.

For the functions in both Examples 1 and 3 the posterior mode for the number of knots is the true number of knots, which is three and five respectively, and the conditional posterior of the locations of the knots given that the modal number of knots is concentrated around the true locations of the knots.
