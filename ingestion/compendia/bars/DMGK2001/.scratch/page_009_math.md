[Page 9]

Table 1. Simulation study. Average mean squared errors with estimated standard errors in brackets based on 10 samples obtained using four di V erent procedures





Modiﬁed



Example 1

0·144 (0·030)

0·206 (0·029)

0·103 (0·019)

0·066 (0·007)

Example 2

0·015 (0·001)

0·025 (0·002)

0·012 (0·001)

0·008 (0·001)

Example 3

0·044 (0·006)

0·106 (0·007)

0·091 (0·004)

0·019 (0·003)

Methods: , spatially adaptive regression splines; , Denison et al. (1998); Modiﬁed, modiﬁed Denison et al.; , Bayesian adaptive regression splines.

However, in Examples 1 and 3, Bayesian adaptive regression splines provides substantial further improvement, in part as a result of the locality heuristic for generating new knots. In Fig. 2, we see the true function of Example 3 together with its estimates obtained using di ﬀ erent procedures. Figure 2 suggests that the success of Bayesian adaptive regression splines results from its avoiding overﬁtting and its ability to adapt to sharp jumps in the curves.

(

)

f

x

6

4

2

0

_

2

_

4

_

6

(a) SARS

0·0

0·2

0·4

0·6

x

0·8

1·0

(

)

f

x

6

4

2

0

_

2

_

4

_

6

(b) DMS

0·0

0·2

0·4

0·6

x

0·8

1·0

(

)

f

x

(c) ModiﬁedDMS

6

4

2

0

_

2

_

4

_

6

0·0

0·2

0·4

0·6

0·8

1·0

x

(

)

f

x

6

4

2

0

_

2

_

4

_

6

(d) BARS

0·0

0·2

0·4

0·6

x

0·8

1·0

Fig. 2. Simulation study. Comparisons of the estimates of the discontinuous function of Example 3: solid lines, true curves; dashed lines, estimates of the curve. Methods: , spatially adaptive regression splines; , Denison et al. (1998); Modiﬁed, modiﬁed Denison et al.; , Bayesian adaptive regression splines.

For the functions in both Examples 1 and 3 the posterior mode for the number of knots is the true number of knots, which is three and ﬁve respectively, and the conditional posterior of the locations of the knots given that the modal number of knots is concentrated around the true locations of the knots.
