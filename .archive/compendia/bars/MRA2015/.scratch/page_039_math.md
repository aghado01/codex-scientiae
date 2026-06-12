[Page 39]

$$
Y _ { t } = A _ { 0 } + \sum _ { j = 1 } ^ { ( n - 1 ) / 2 } [ A _ { j } \cos ( 2 \pi \omega _ { j } t ) + B _ { j } \sin ( 2 \pi \omega _ { j } t ) ]
$$

for t = 1,...,n and suitably chosen coeﬃcients (see Shumway and Soﬀer (2011)). The coeﬃcients A  and B  can be found using regression results. The Fourier frequencies, /n,  = 1,..., ( n − 1) / 2 lead to simple expressions for A  and B , since for these frequencies the sines and cosines are orthogonal. These expressions for A 0, the A  ’s and B  ’s are ˆ A 0 = Y,

$$
\hat { A } _ { j } = \frac { 2 } { n } \sum _ { t = 1 } ^ { n } y _ { t } \cos ( 2 \pi t / n ), \quad \text {and} \quad \hat { B } _ { j } = \frac { 2 } { n } \sum _ { t = 1 } ^ { n } y _ { t } \sin ( 2 \pi t / n ),
$$

respectively. In the case where n is even, the estimates for A 0, A j ’s and B j ’s are similar.

Given data y 1,...,y n, the discrete Fourier transform (DFT), where i = √ − 1, is deﬁned as n

$$
d ( \omega _ { j } ) = \frac { 1 } { \sqrt { n } } \sum _ { t = 1 } ^ { n } y _ { t } e ^ { - 2 \pi i \omega _ { j } t } \\
$$

for  = 0, 1,...,n − 1 and ω  = /n (Fourier frequencies). The periodogram is deﬁned as

$$
I _ { n } ( \omega _ { j } ) = \left | d ( \omega _ { j } ) \right | ^ { 2 }, \ \jmath = 0, 1, \dots, n - 1 .
$$

Let the cosine and sine transforms be deﬁned as

$$
d _ { \mathcal { C } } ( \omega _ { j } ) = \frac { 1 } { \sqrt { n } } \sum _ { t = 1 } ^ { n } y _ { t } \cos ( - 2 \pi \omega _ { j } t ) \quad \text {and} \quad d _ { \mathcal { S } } ( \omega _ { j } ) = \frac { 1 } { \sqrt { n } } \sum _ { t = 1 } ^ { n } y _ { t } \sin ( - 2 \pi \omega _ { j } t ),
$$

receptively, where ω  = /n,  = 0, 1,...,n − 1 (Shumway and Soﬀer, 2011). Then

$$
I _ { n } ( \omega _ { j } ) = d _ { \mathcal { C } } ^ { 2 } ( \omega _ { j } ) + d _ { \mathcal { S } } ^ { 2 } ( \omega _ { j } ) .
$$

$$
I _ { n } ( \omega _ { j } ) & = \frac { n } { 4 } [ \hat { A } _ { j } ^ { 2 } + \hat { B } _ { j } ^ { 2 } ] \\ & = \frac { 1 } { n } \left | \sum _ { t = 1 } ^ { n } y _ { t } e ^ { - 2 \pi i \omega _ { j } t } \right | ^ { 2 } .
$$

The overall behavior of time series can then be summarized by identifying the cosine-sine pairs in the time series. The relative strength of the cosine-sine pairs is determined by the heights at the various frequencies ω  = /n,  = 0, 1,...,n − 1 (Cryer and Chan, 2008).
