[Page 10]

$$
\sum _ { j = 1 } ^ { N } \left [ \frac { c _ { j } ^ { \mathcal { D } _ { X } } \mathcal { N } ( y ; \mu _ { j } ^ { \mathcal { D } _ { X } } , ( \sigma ^ { \mathcal { D } _ { Y _ { O } } } + \sigma _ { j } ^ { \mathcal { D } _ { X } } ) I ) } { \lambda _ { \mathcal { D } _ { Y _ { S } } } ( y ) + \alpha \sum _ { j = 1 } ^ { N } c _ { j } ^ { \mathcal { D } _ { X } } \mathcal { N } ( y ; \mu _ { j } ^ { \mathcal { D } _ { X } } , ( \sigma ^ { \mathcal { D } _ { Y _ { O } } } + \sigma _ { j } ^ { \mathcal { D } _ { X } } ) I ) \int _ { \mathbb { W } } \mathcal { N } ( u ; \mu _ { j } ^ { x | y } , \sigma _ { j } ^ { x | y } I ) d u } \right ] \mathcal { N } ^ { * } ( x ; \mu _ { j } ^ { x | y } , \sigma _ { j } ^ { x | y } I ) ,
$$

where the bracketed expression is the deﬁnition of C y j .

glyph[squaresolid]

## 3.2.1 Example

Here, we present a detailed example of computing the posterior intensity according to Equation (8) for a range of parametric choices. Reproducing these results, the interested reader may download our R-package BayesTDA. We consider circular point clouds often associated with periodicity in signals [35] and focus on estimating homological features with k = 1 as they correspond to 1-dimensional holes, which describe the prominent topological feature of a circle. Precisely our goals are to: (i) illustrate posterior intensities and draw analogies to standard Bayesian inference; (ii) determine the relative contributions of the prior and observed data to the posterior; and (iii) perform sensitivity analysis.

TABLE 2 List of Gaussian mixture parameters of the prior intensities in Equation (5) . The means µ D X i are 2 × 1 vectors and the rest are scalars

.

| |µ D X i|µ D X i|c D X i|
|---|---|---|---|
|Informative|(0 . 5 , 1 . 2)|0 . 01|1|
|Weakly informative Prior|(0 . 5 , 1 . 2)|0 . 2|1|
|Unimodal Uninformative Prior|(1 , 1)|1|1|
|Bimodal Uninformative Prior|(0 . 5 , 0 . 5)|0 . 2|1 2|
| |(1 . 5 , 1 . 5)|0 . 2| |


We start by considering a Poisson PP with prior intensity λ D X that has the Gaussian mixture form given in (M2 ). We take into account four types of prior intensities: (i) informative, (ii) weakly informative, (iii) unimodal uninformative, and (iv) bimodal uninformative; see Figures 5–7 (a), (d), (g), (j), respectively. We use one Gaussian component in each of the ﬁrst three priors as the underlying shape has single 1 − dimensional feature and two for the last one to include a case where we have no information about the cardinality of the underlying true diagram. The parameters of the Gaussian mixture density in Equation (5) used to compute these prior intensities are listed in Table 2. To present the intensity maps uniformly throughout this example while preserving their shapes, we divide the intensities by their corresponding maxima. This ensures all intensities are on a scale from 0 to 1, and we call it the scaled intensity. The observed PDs are generated from point clouds sampled uniformly from the unit circle and then perturbed by varying levels of Gaussian noise; see Figure 4 wherein we present three point clouds sampled with Gaussian noise having variances 0 . 001 I 2 , 0 . 01 I 2 , and 0 . 1 I 2 , respectively. Consequently, these point clouds provide persistence diagrams D Y i for i = 1 , 2 , 3, which are considered as independent samples from Poisson point process D Y , exhibiting distinctive characteristics such as only one prominent feature with high persistence and no spurious features ( Case-I ), one prominent feature with high persistence and very few spurious features ( Case-II ), and one prominent feature with medium persistence and more spurious features ( Case-III ).

For each observed PD, persistence features are presented as green dots overlaid on their corresponding posterior intensity plots. For Cases-I-III , we set the probability α of the event that a feature in D X appears in D Y to 1, i.e., any feature in D X is certainly observed through a mark in D Y , and later in Case-IV , we decrease α to 0 . 5 while keeping all other parameters the same for the sake of comparison. The choice of α = 0 . 5 anticipates that any feature has equal probability to appear or disappear in the observation and in
