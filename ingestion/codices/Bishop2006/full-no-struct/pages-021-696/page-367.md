[Page 367]

Exercise 7.10

# Exercise 7.12

Section 3.5.3

in the predictions made by the model and so are effectively pruned out, resulting in a sparse model.

Using the result (3.49) for linear regression models, we see that the posterior distribution for the weights is again Gaussian and takes the form

$$
p ( w | t , X , \alpha , \beta ) = \mathcal { N } ( w | m , \Sigma )
$$

where the mean and covariance are given by

$$
m \ = \ \beta \Sigma \Phi ^ { T } \mathbf t
$$

$$
\begin{array} { r l } { m } & { = \beta \Phi ^ { T } t } \\ { \Sigma } & { = } & { ( A + \beta \Phi ^ { T } \Phi ) ^ { - 1 } } \\ { \times M } & { \design r i g n a r x i n t h e v e l g e n t s } & { \Phi _ { n i } = \phi _ { i } ( x _ { n } ) , a n d A = } \\ { i n t h e s t i c f a c t e o f t h e m o d l e s } & { ( 7 7 8 ) , w e h a v e \Phi = K _ { \ } w h e r e } \end{array}
$$

where Φ is the N × M design matrix with elements Φ ni = φ i ( x n ) , and A = diag( α i ) . Note that in the speciﬁc case of the model (7.78), we have Φ = K , where K is the symmetric ( N + 1) × ( N + 1) kernel matrix with elements k ( x n , x m ) . The values of α and β are determined using type-2 maximum likelihood, also

known as the evidence approximation , in which we maximize the marginal likelihood function obtained by integrating out the weight parameters

$$
\text {section of the algorithm of the Gauvais-Gianchi} \text { and } \text {in} \\ p ( \mathbf t | X , \alpha , \beta ) = \int p ( \mathbf t | X , w , \beta ) p ( w | \alpha ) \, d w . \\ \intertext { this represents the convection of two Gauvais-Gianchi, it isReadily evaluated to }
$$

Because this represents the convolution of two Gaussians, it is readily evaluated to give the log marginal likelihood in the form

$$
\ln p ( t | X , \alpha , \beta ) \ & = \ \ln \mathcal { N } ( t | 0 , C ) \\ & = \ - \frac { 1 } { 2 } \left \{ N \ln ( 2 \pi ) + \ln | C | + t ^ { T } C ^ { - 1 } t \right \} \\ \intertext { w h e r e } \text {where } t = ( t _ { 1 } , \dots , t _ { N } ) ^ { T } , \text { and we have defined the } N \times N \text { matrix } C \text { given by }
$$

where t = ( t 1 ,...,t N ) T , and we have deﬁned the N × N matrix C given by

$$
C = \beta ^ { - 1 } I + \Phi A ^ { - 1 } \Phi ^ { T } .
$$

Our goal is now to maximize (7.85) with respect to the hyperparameters α and β . This requires only a small modiﬁcation to the results obtained in Section 3.5 for the evidence approximation in the linear regression model. Again, we can identify two approaches. In the ﬁrst, we simply set the required derivatives of the marginal likelihood to zero and obtain the following re-estimation equations

$$
\alpha _ { i } ^ { \text {new} } \ = \ \frac { \gamma _ { i } } { m _ { i } ^ { 2 } } \quad \\
$$

$$
( \beta ^ { \text {new} } ) ^ { - 1 } \ = \ \frac { \| t - \Phi m \| ^ { 2 } } { N - \sum _ { i } \gamma _ { i } } \\ i ^ { t } \, \text {component of the posterior mean} \, m \, \text { defined by } ( 7 . 8 2 ) . \ \text {The} \\ \text {rows well the corresponding parameter} \, w \colon \text {is determined by the}
$$

where m i is the i th component of the posterior mean m deﬁned by (7.82). The quantity γ i measures how well the corresponding parameter w i is determined by the data and is deﬁned by
