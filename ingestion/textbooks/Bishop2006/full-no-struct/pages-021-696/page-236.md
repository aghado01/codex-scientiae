[Page 236]

One major weakness of the Laplace approximation is that, since it is based on a Gaussian distribution, it is only directly applicable to real variables. In other cases it may be possible to apply the Laplace approximation to a transformation of the variable. For instance if 0 τ < ∞ then we can consider a Laplace approximation of ln τ . The most serious limitation of the Laplace framework, however, is that it is based purely on the aspects of the true distribution at a speciﬁc value of the variable, and so can fail to capture important global properties. In Chapter 10 we shall consider alternative approaches which adopt a more global perspective.

# 4.4.1 Model comparison and BIC

As well as approximating the distribution p ( z ) we can also obtain an approximation to the normalization constant Z . Using the approximation (4.133) we have

$$
\text { As well as approximating the distribution } p ( z ) \text { we can also obtain an approxi-} \\ \text {ation to the normalization constant } Z . \text { Using the approximation } ( 4 . 1 3 ) \text { we have} \\ Z \ = \ \int f ( z ) \, d z \\ \simeq \ f ( z _ { 0 } ) \int \exp \left \{ \frac { 1 } { 2 } ( z - z _ { 0 } ) ^ { T } A ( z - z _ { 0 } ) \right \} \, d z \\ \simeq \ f ( z _ { 0 } ) \frac { ( 2 \pi ) ^ { M / 2 } } { | A | ^ { 1 / 2 } } \\ \text {here we have noted that the integral is Gaussian and made use of the standard } \\ \text {result (2.43) for a normalized Gaussian distribution. We can use the result (4.135) to }
$$

where we have noted that the integrand is Gaussian and made use of the standard result (2.43) for a normalized Gaussian distribution. We can use the result (4.135) to obtain an approximation to the model evidence which, as discussed in Section 3.4, plays a central role in Bayesian model comparison.

Consider a data set D and a set of models {M i } having parameters { θ i } . For each model we deﬁne a likelihood function p ( D| θ i , M i ) . If we introduce a prior p ( θ i |M i ) over the parameters, then we are interested in computing the model evidence p ( D|M i ) for the various models. From now on we omit the conditioning on M i to keep the notation uncluttered. From Bayes’ theorem the model evidence is given by

$$
p ( \mathcal { D } ) & = \int p ( \mathcal { D } | \theta ) p ( \theta ) \, d \theta . \\ = p ( \mathcal { D } | \theta ) p ( \theta ) \, \text { and } Z & = p ( \mathcal { D } ) , \, \text { and applying the result } ( 4 . 1 3 5 ) , \, \text { we }
$$

Identifying f ( θ ) = p ( D| θ ) p ( θ ) and Z = p ( D ) , and applying the result (4.135), we obtain

Exercise 4.22

$$
\text {obtain} \\ \ln p ( \mathcal { D } ) \simeq \ln p ( \mathcal { D } | \theta _ { \text {MAP} } ) + \underbrace { \ln p ( \theta _ { \text {MAP} } ) + \frac { M } { 2 } \ln ( 2 \pi ) - \frac { 1 } { 2 } \ln | \mathbf A | } _ { \text {Occam factor} } \\
$$
