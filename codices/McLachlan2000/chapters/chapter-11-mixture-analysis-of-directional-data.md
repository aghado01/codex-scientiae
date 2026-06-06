<a id="sec-mixture-analysis-of-directional-data"></a>

# Mixture Analysis of Directional Data

<a id="sec-11-1"></a>

# 11.1 INTRODUCTION

To illustrate the use of finite mixture models in the analysis of directional data, we present an example on the use of mixtures of Kent distributions as an aid in joint set identification: When examining a rock mass, joint sets and their orientations can play significant role with regard to how the rock mass will behave. To identify joint sets present in the rock mass, measurements of the orientation of individual fractures can be measured on exposed rock faces and the resulting data examined for heterogeneity. In this chapter, we focus on the recent case study of Peel, Whiten; and McLachlan (2001), who used the EM algorithm to fit mixtures of Kent component distributionsto the fracture data to aid in the identification of joint sets. An extra uniform component is also included in the model to accommodate the noise present in the data.

<a id="sec-11-2"></a>

# 11.2 JOINT SETS

We introduce the concept of directional data through the example considered by Peel et al. (2001) on joint sets In nature a rock mass is almost never single block of uniform solid rock, instead it usually contains many fractures, or discontinuities. Since these fractures arise from a force on the rock mass , will generally form in a nearly parallel fashion. These families of parallel fractures are termed joint sets . Figure 11.1 shows a hypotheticalcross-section of a rock mass with a single joint set present. acting they number of joint sets may be present (see Figure 11.2). How the rock mass will react to new external forces is greatly affected by the orientation of these joint sets, since the rock will most likely separate at its weakest point, being the fractures.

![image 31](mclachlan2000_images/imageFile31.png)

Fig. 11.1 Hypothetical cross-section of rock mass with single joint set present.

![image 32](mclachlan2000_images/imageFile32.png)

11.2 Hypothetical cross-section of rock mass with two joint sets present. Fig.

In the mining industry it is advantageous to be able to predict how a rock mass will react. Obviously; when modeling a mine tunnel, the rock structure of the roof of tunnel is extremely important. Other applications are in the design of ore extraction systems and the stability of open pit walls. When more than one 'joint set is present, blocks are formed (see Figure 11.3). The shape and location of these blocks is very significant. With certain configurations the roof will be very unstable; with the blocks fallingcausing a cave in. This isthecase in the block caving method of mining, where the roof is purposely caved in and the collapsed rock is progressively removed. In other cases, this situation can be very dangerous; at worst costing lives; at best costing extra time and resources to clear the debris. In both situations; it is paramount to be able to predict, with some confidence; the rock mass structure.

![image 33](mclachlan2000_images/imageFile33.png)

Fig. 11.3 Hypotheticalcross-sectionof rock mass with twojoint sets present forming blocks.

To determine the joint sets present, measurements are taken on site to determine what fractures are evident on an exposed rock face. This is accomplished by taking one or more lines across an exposed rock surface, and any fractures that intersect this line are described by two angles, dipdirection anddip angle (as shown in Figure 11.4), corresponding tothedirection of the normal to the fracture plane. Other measurements are also taken such as the distance the measurement line and the nature of the fracture; see Peel et al. (2001) for further details. along

The fracture measurements are used to discern clusters of fractures corresponding to joint sets. The current approach is to plot the dip direction and dip angle of each fracture on a polar plot. Then contours of the density of the data are added to enable the user to manually distinguish between joint sets (see Figure 11.5).

- Fig. 11.4 Representation of dip angle and dip direction.

![image 34](mclachlan2000_images/imageFile34.png)

- Fig. 11.5 Example of a contour plot.

Often since large dense joint set can overshadow the other joint sets, points belonging to the first joint set located are removed and the data recontoured. This procedure is repeated at the user's discretion. This method is quite effective; but can be ambiguous with different users producing very different interpretations of the data; Also; the amount of user time and input needed is quite high. Hence there is a need for an automated method of clustering the joint sets, as proposed in Peel et al. (2001)

<a id="sec-11-3"></a>

# 11.3 DIRECTIONAL DATA

The dip direction and dip angle measured are obviously directional vectors, so the measured samples are two-dimensional directional data. A two-dimensional direc tional sample can simply be thought of as a sample of points that lie on the surface of a unit sphere. Hence the sample points can be represented in either or Cartesian coordinates . Denoting the then Y1 would be the dip direction and 72 would be the dip angle, as described in Figure 11.4. The Cartesian coordinates of a are given by the directionalcosines, polar polar point

$$
x _ { 2 } & = \sin ( \gamma _ { 2 } ) \cos ( \gamma _ { 1 } ) , \\ x _ { 3 } & = \sin ( \gamma _ { 2 } ) \sin ( \gamma _ { 1 } ) ,
$$

where we have followed the notation of Kent (1982) in using 22, and 53 to refer to the z-, y-, and r-coordinates, respectively. 51,

The coordinates (Y1, Y2) can be obtained from the directional cosines by polar

$$
\gamma _ { 1 } = \tan ^ { - 1 } ( x _ { 1 }
$$

It is also useful to note that the angle, 0, between two vectors æ and y with directional the dot product of the two vectors; that is,

$$
\theta = \cos ^ { - }
$$

In the sequel both the and Cartesian representations will be used. polar

Concerning the use of the mixture model

$$
i ; \Psi ) = \sum _ { i = 1 } ^ { s } \pi _ { i } f _ { i } ( y _ { j } ; \theta _ { i } )
$$

for the analysis of directional data; an obvious choice for the component densities in (11.1) would be the Fisher distribution (due to R.A. Fisher) , which can be thought of as an extension of the von Mises distribution from a circle to a sphere. The Fisher distributionis analogous to a circular bivariate normal, which corresponds to a normal distribution with a diagonal covariance matrix with equal eigenvalues. This allows for distributions of circular shape of varying size on the surface of the sphere.

<a id="sec-11-4"></a>

# 11.4 INITIAL WORK ON CLUSTERING OF DIRECTIONAL DATA

We briefly consider work that existed to the study of Peel et al. (2001) for analyzing heterogeneous directional data. Fisher, Lewis; and Embleton (1987) state that there are three possible approaches to "multimodal' directional data: Partition the data into groups visually using contour plots; use a clustering method; or use a probability model (such as a mixture of Fisher distributions). Fisher et al. (1987) g0 on to out with regard to clustering methods for directional data, that there is 'little currently available in the literature which seems to be of practical use: One example is given of a clustering method based on a nonparametric density approach in Schaeben (1984). prior point

With regard to mixtures of Fisher distributions, Fisher et al. (1987) refer to Stephens (1969) who investigated mixtures of Fisher distributions and found the estimation of the parameters to be tedious. However; it must be stated that the comment of Stephens (1969) was made when the available computer power was considerably less than that available today and the EM algorithm was not available. fitting fitting

Hsu, Walker, and Ogren (1986) fitted amixture ofbivariate von Mises distributions; that is, the dip angle and direction were assumed to be distributed independently; each with a von Mises distribution. This assumption does not allow for any correlation between dip direction and dip angle, which can certainly occur. If the cluster's elliptical contours are visualized on the surface of the sphere, then the use of bivariate von Mises component distributions constrains the axis of the cluster ellipses to be parallel to the longitude and latitude lines of the sphere. Other work in the literature includes Lund (1999), which examines the cluster analysis of circular data.

Nonmixture based cluster analysis of joint set data is discussed in Pal (1995), Aler, Du Mouza, and Arnould (1996), and Hammah and Curran (1998). Roy

<a id="sec-11-5"></a>

# 11.5 MIXTURE OF KENT DISTRIBUTIONS

Peel et al. (2001) used the Kent, rather than the Fisher distribution for the mixture model components, so as to provide greater flexibility. The Kent distribution can be general 8-parameter family of distributionsknown as the Fisher-Bingham family; see Kent (1982). In the same way that the Fisher distributionis comparable to a bivariate normal with a constrained covariance matrix; the Kent distribution is comparable to a bivariate normal where the covariance matrices are unconstrained. This allows for distributionsof any elliptical size, and orientation on the surface of the sphere. shape, Hence the use of Kent distributions provides a more flexible alternative to model the data.

The Kent density is given in terms of the directional cosines y = and is given by

where

$$
f _ { K } ( $y_j$ \theta ) = C _ { K } \exp [ \kappa ( y ^ { T } \omega _ { 1 } ) + \beta \{ ( y ^ { T } \omega _ { 2 } ) ^ { 2 } - ( y ^ { T } \omega _ { 3 } ) ^ { 2 } \} ] ,
$$

$$
C _ { K } = ( 2 \pi ) ^ { - 1 } \exp \left ( - \kappa \right ) ( \kappa ^ { 2 } - 4 \beta ^ { 2 } ) ^ { 1 / 2 }
$$

and 0 The parameter w1 is the vector of the directional cosines that define the mean or center of the distribution. The parameters w2 and relate to the orientation of the distribution. If we visualize the elliptical contours of the distribution on the surface of the sphere, then w2 and w3 define the directions of the major and minor axes, respectively, of the ellipses. The parameter 02 is a vector 'containing thedirectional cosines correspondingto apoint on the major axis of the ellipse; while w3 contains the directional cosines corresponding to on the minor axis. Hence, in conjunction with the direction of the major and minor axes are defined. point

smaller the value of k, the more dispersed the distribution will be and, as k increases, there is the parameter ß which can be thoughtof as a circularity measure. The smaller the value of ß the closer the distribution is to circular; the larger the value of ß the more elliptical the distribution becomes . When ß = 0, corresponding to maximum circularity; the Kent distribution reduces to the Fisher distribution.

$$
= \sum \pi _ { i } f _ { K } ( y _ { j } ; \theta _ { i } ) ,
$$

where $f_x(y_j, \theta_i)$ is the Kent density with parameter vector

$$
\theta _ { i } = ( \kappa _ { i } , \, \beta _ { i } , \, \omega _ { i 1 } ^ { T } , \, \omega _ { i 2 } ^ { T } , \, \omega _ { i 3 } ^ { T } ) ^ { T } \quad ( i = 1 , \dots , g ) .
$$

The method to be described in the next section for the fitting of a mixture of Kent distributions involves approximating the MLEs of the Kent component distributions by their estimates obtained by the method of moments.

<a id="sec-11-6"></a>

# 11.6 MOMENT ESTIMATION OF KENT DISTRIBUTION

The following steps are proposed in Kent (1982) to estimate the parameters of a single Kent distributionfrom a sample (Y11, Y21)T (Yn, Y2n)T \_

timates are calculated as follows.

Step 1. Calculate the sample mean direction

and

where Sv1 =

given by

$$
\bar { \gamma } _ { 1 } = \sum _ { j = 1 } \gamma _ { 1 j } / n , \ \bar { \gamma } _ { 2 } = \sum _ { j = 1 } \gamma _ { 2 j } /
$$

$$
R ^ { 2 } = S
$$

$$
S = \left ( \begin{array} { c c c } \sum y _ { 1 j } ^ { 2 } & \sum y _ { 1 j } y _ { 2 j } & \sum y _ { 1 j } y _ { 3 j } \\ \sum y _ { 1 j } y _ { 2 j } & \sum y _ { 2 j } ^ { 2 } & \sum y _ { 2 j } y _ { 3 j } \\ \sum y _ { 1 j } y _ { 2 j } & \sum y _ { 2 j } ^ { 2 } & \sum y _ { 2 j } y _ { 3 j } \\ \end{array} \right ) \, .
$$

$$
y _ { 1 j } y _ { 3 j }
$$

<a id="sec-step-2-compute-the-matrix"></a>

**Step 2. Compute the matrix**

$$
\mathbf H = \left ( \begin{array} { c c c } \cos \bar { \gamma } _ { 2 } & - \sin \bar { \gamma } _ { 2 } & 0 \\ \sin \bar { \gamma } _ { 2 } \cos \bar { \gamma } _ { 1 } & \cos \bar { \gamma } _ { 2 } \cos \bar { \gamma } _ { 1 } & - \sin \bar { \gamma } _ { 1 } \\ \sin \bar { \gamma } _ { 2 } \sin \bar { \gamma } _ { 1 } & \cos \bar { \gamma } _ { 2 } \sin \bar { \gamma } _ { 1 } & \cos \bar { \gamma } _ { 1 } , \end{array} \right ) ,
$$

$$
\left ( \begin{array} { c c } \sin \overline { \gamma } _ { 2 } \sin \overline { \gamma } _ { 1 } & \cos \overline { \gamma } _ { 2 } \sin \overline { \gamma } _ { 1 } & \cos \overline { \gamma } _ { 1 } , \\ \end{array} \right ) ^ { 4 }
$$

and then compute the matrix B given by

$$
B = H ^ { T } S H .
$$

Then â is defined by

$$
\hat { \alpha } = \frac { 1 } { 2 } \tan ^ { - 1 } \{ 2 b _ { 2 3 } / ( b _ { 2 2 } - b _ { 3 3 } ) \} .
$$

Step 3. Compute the matrix K, where

Put and where = (Vij. Uij Step 4. the parameter estimates of @ and ß are given approx imately by large,

$$
K = \left ( \begin{array} { c c c } 1 & 0 & \sin \hat { \alpha } \\ 0 & \cos \hat { \alpha } & - \sin \hat { \alpha } \\ 0 & \sin \hat { \alpha } & \cos \hat { \alpha } \end{array} \right ) \, .
$$

$$
\hat { G } = H K = ( \hat { \omega } _ { 1 } , \hat { \omega } _ { 2 } , \hat { \omega } _ { 3 } ) ,
$$

1 column vectors. Then calculate

$$
V = \hat { G } ^ { T } S \hat { G }
$$

$$
W = v _ { 2 2 } -
$$

and

$$
\hat { \kappa } = ( 2 - 2 \bar { R } - W ) ^ { - 1 } + ( 2 - 2 \bar { R } + W ) ^ { - 1 }
$$

$$
( 1 1 . 5 )
$$

<a id="sec-11-7"></a>

# 11.7 UNIFORM COMPONENT FOR BACKGROUND NOISE

If the data contain a significant amount of noise; as in the example of Peelet al. (2001) an extra component can be included in the mixture model, corresponding to Poisson noise; as proposed in Banfield and Raftery (1993);see also Campbell et al. (1997). In the present context; a uniform distribution on the unit sphere is appropriate; defined by

$$
f _ { o } ( y _ { j } ) = 1 / ( 4 \pi ) \quad y _ { j } \in y ,
$$

where ) denotes the surface on the unit sphere. There is no problem defining the range of the uniform distribution because the whole data space is clearly defined in associated with the noise component so that now T; = 1 The mixture model can now be written as

$$
f ( y _ { j } ; \Psi ) = \sum _ { i = 1 } ^ { s } \pi _ { i } f _ { K } ( y _ { j } ; \theta _ { i } ) + \pi _ { 0 } f _ { 0 } ( y _ { j } ) .
$$

This formulation allows the data to determine the amount of noise present via the mixing proportion To, rather than the user setting the level in some ad hoc manner.

In the example of Peel et al. (2001), the data are axial (antipodally symmetric); that is, every data point is represented by two points on the surface of the sphere; a and a dipole. They handled the presence of antipodal symmetry by representing each data by the closest to the center of the cluster in question (using angular distance, as defined in Section 11.3). In effect, the data space is restricted to a hemisphere; and so if a uniform component distribution is used, it must be suitably changed to fo($y_j$) = 1/(2r). pole point pole

Another choice of distributionin place of the Kent for the component distributions under antipodal symmetry is the Bingham distribution. It applies only to antipodally symmetric data, and so it avoids having to adjust the data to be in a form amenable to Kent component distributions; which can handle data not necessarily antipodally symmetric.

<a id="sec-11-8"></a>

# 11.8 APPLICATION OF EM ALGORITHM

Peel et al. (2001) used the EM algorithm to fit the mixture model (11.7). As with the fitting ofafinite mixture model toindependent data, the E-step requires on the (k+1)th iteration the calculation ofthe current values of component membership. The M-step effectively requires the calculation of the MLEs of the parameters of the component Kent distributions considered separately. On the (k + 1)th iteration of the EM algorithm, it follows that the updated estimate 0{\*+1) for @; is obtained by solving

$$
\sum _ { j = 1 } ^ { \sum } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \partial \log f _ { K } ( y _ { j } ; \theta _ { i } ) / \partial \theta _ { i } = 0
$$

$$
( 1 1 . 8 )
$$

for each (i =1, 9). However, this solution does not exist in closed form; and soithas to be computed iteratively. A more convenient approach, as outlined by Kent (1982) is to use the moment estimates. Hence the moment estimates were used here in place of the MLEs. denotes the updated estimate of %so obtained on the of the component parameters 0; are used. However, the use of the moment estimates should make little difference, as Kent (1982) noted that if the eccentricity 28/k is small or if K is large, then the moment estimates are close to the MLEs. Peel et al. (2001) noted in their work that the likelihood function was not decreased after each such EM iteration. being

Of course one could check for each whether the inequality

$$
( 1 1 9 )
$$

holds. This inequality is sufficient to ensure that the likelihood is not decreased. Choosing v{k+1) sothat (11.9) holds corresponds tou 'ageneralized EM algorithm using

The algorithm can be initialized by fitting a mixture without the noise component and allocating all points beyond a specified threshold from all group means to the noisecomponent and refitting themixture with anoisecomponent. To provide starting values for the EM algorithm; a small number of random starts, modified versions of various hierarchical methods, and k-means the angle between vectors as distance measure can be used. This provides an automated approach with the user using simply providing the sample and specifying which of the above methods is to be utilized to provide starting values.

<a id="sec-example-11-1-two-mining-samples"></a>

**EXAMPLE 11.1: TWO MINING SAMPLES**

To demonstrate their mixture model-based approach, Peel et al. (2001) analyzed two mining samples, referred to as Site 1 and Site 2 (supplied by the Julius Kruttschnitt Mineral Research Centre (JKMRC) at the University of Queensland). Site 1 consists of 860 measurements of dip angle and direction; and Site 2 consists of 531 measurements Also available for these twosites were the user interpretations based on the use of contour plots, as described in Section 11.2. These user-defined groupings are given by rectangular regions bounded by the solid lines and labeled Jl, J2, Jg. The contour are superimposed on the plots, where the sample points are indicated by various symbols, depending on the number of values recorded at the or 0 is used if one, or three values, respectively; were recorded at a point). graphs point two,

To initialize the EM algorithm; Peel et al. (2001) used ten random starts, ten k-means, and seven hierarchical methods. The number of components fitted was taken to be the same as the user interpretation. The results produced are shown in Figures 11.6 and 11.7 for Sites and 2, respectively. In these and subsequent figures in this chapter, the points determined as noise are denoted by dots.

120

5693

JS

210

240

270

300

Mixture model

Human operator

Fig. 11.6 Polar plot of the results for Site 1. From Peel et al. (2001)

Firstly, we compare the result obtained by fitting a mixture model to the user interpretation for Site 1 (Figure 11.6). Thereissome agreement between the solutions; with the groups designated as JI, J2, and J3 by the user roughly corresponding to the groups denoted by the x, inverted A, and + symbols in the mixture model solution. However; the user-defined groups J4 and JS are modeled by single group in the mixture model solution (denoted by the symbol \*), and the extra component (denoted by the symbol 0) is used to fit the points to the right of J2.

20

150

90

0.8

180

210

330

240

270

300

Mixture model

Human operator

Fig. 11.7 Polar plot of the results for Site 2. From Peel et al. (2001).

The results produced when a mixture model for Site 2 were much closer to the user-defined groups (see Figure 11.7). The user-defined groups J1 and J2 matched very well to the mixture model solution (denoted by \* and 0 symbols, respectively) whereas group J3 the symbol x). Overall, the computed results correspond very nicely to what the human user determined. It should be noted that, as stated in Section 11.2, the user's solutions are not necessarily the only solutions; but are possible solutions. It is, however; encouraging that the two results are similar. fitting

<a id="sec-11-10"></a>

# 11.10 DETERMINING THE NUMBER OF JOINT SETS

An important question that needs to be addressed is how many joint sets are present in the mixture model framework, the value of g. This question has previously been examined for directional data by Hsu et al. (1986), who looked at a stepwise method for determining the number of components in a mixture with example applications to jointset data. Their stepwise procedure uses a bootstrap method to determine the null distribution of Watson's U2 statistic. An alternalive would be to utilize the likelihood ratio test statistic, as described in Chapter 6

For their example, Peel et al. (2001) felt that a quick, crude approximation would suffice due tothe need forreasonably fast analysis. For this reason; AIC and BIC were employed. To examine the use of the AIC and BIC criteria to provide a to the number of joint sets, Peel et al. (2001) conducted some simulations. Eight simulated samples, with various parameter configurations, were examined. The mixture model (11.7) was fitted to each sample for 9 =0 to g = 10, and the AIC and BIC criteria were used to determine the choice of g. Here 9 = 0 corresponds to just the uniform distribution. Each model was fitted ten random starts, ten k-means starts, and seven hierarchical methods to provide partitions of the sample to initialize the EM algorithm. guide fitting using The results are given in Table 11.1, which reports the number of groups estimated by AIC and BIC for the various samples. The number of sample and noise points are also given in Table 11.1. A comparison between the true grouping and the grouping obtained by fitting the mixture model for Sample 1 is given in Figure 11.8. cases; the true number of components lies between the estimates provided by AIC and BIC. In this way; AIC and BIC provided a useful interval or range for the number of components. The estimate given by BIC was correct in six simulations out of eight,

Table 11.1 Number of Groups Estimated by AIC and BIC for Simulated Samples

| Sample |     | no  | True g | AIC | BIC |
| ------ | --- | --- | ------ | --- | --- |
|        | 400 | 300 | 4      | 4   | 4   |
| 2      | 200 | 500 | 3      | 3   | 2   |
| 3      |     | 700 | 0      |     | 0   |
| 4      | 300 | 400 | 3      | ;   | 2   |
| 5      | 600 | 100 | 1      |     |     |
| 6      | 200 | 500 | 2      | 2   | 2   |
| 7      | 500 | 200 | 5      | 6   | 5   |
| 8      | 600 | 100 |        | 7   | 6   |
| Site   | 860 |     | 5\*    | 6   | 2   |
| Site 2 | 531 |     | 3\*    | 4   | 2   |

\*Number of groups estimated by user from contour plots .

Source: Adapted from Peel et al. (2001)

In the literature, AIC and BIC have been found to be very sensitive to the number of sample points and parameters (see Cutler and Windham; 1994), with the methods failing for small sample size relative to the number of parameters. To assess this sensitivity of these two criteria for this application; Peel et al. (2001) performed some further simulations to investigate the effect of sample size on the accuracy of the criteria. Samples of various sizes n were generated from four well-separated groups, each consisting of n/7 points. Theremaining 3n/7 points were noise points generated from a uniform distribution. The AIC and BIC criteria were applied to each of these samples. The experiment was repeated for three less separated groups. Their results are reported in Table 11.2 As expected, the criteria fail when the sample size is small. However, for reasonably large sample sizes, it can be seen that the results are excellent, with both criteria repeatedly determining values for 9 that correspond to the true number of groups.

Table 11.2 Number of Groups Estimated by AIC and BIC for a Range of Samples Sizes n

|      | True g = 4 |     | True g =3 |     |
| ---- | ---------- | --- | --------- | --- | --- | --- |
|      | AIC        | BIC | AIC       |     |
| 100  | 0          | 0   |           |     |
| 200  |            |     | 3         |     |
| 300  |            | 0   | 3         |     |
| 400  |            |     | 3         | ;   |
| 500  |            |     | 3         | 2   |
| 600  |            |     | 3         | 3   |
|      |            |     | 3         |     |
|      |            |     | 3         |     |
| 1000 |            |     | 3         | 3   |
| 1500 |            |     |           |     | 3   | 3   |
| 2000 |            |     | 4         | 3   |

Source: Adapted from Peel et al. (200/)

120

150

1.5678

0452

120

5878

52250

210

210

240

270

300

Fitted grouping

270

300

True grouping

Fig. 11.8 Comparisonof true grouping to that obtained a mixture model for simulated Sample 1. From Peel et al. (200/) fitting

<a id="sec-11-11"></a>

# 11.11 DISCUSSION

The mixture model approach described in the previous sections offers a practical method of analyzing joint sets in two ways: data and, secondly; to determine a range for the number of joint sets suggested by the data. In thecase of identifyingjointsets, the mixture approach using Kent component distributions (plus a uniformly distributed component) performed very well on actual data. The results approximately matched those independently obtained by an operator using contour plots. An exact match was not expected since even two experienced operators can produce differing results. However, the results produced by a mixture of Kentuniform distributions provided a reasonable interpretation of the data. An important feature of the model is that it is robust with respect to noise due to the inclusion of the extra uniform component in the model. With regard to determining the number of joint sets, in the simulation experiment discussed in Section 1.10, the AIC and BIC criteria were found to give useful and accurate bounds on the true number of simulated joint sets. fitting

This mixture model-based method of Peel et al. (2001) provides a fully automated method to identify how many joint sets are present and their location and shape, in the form of model parameters, a partition of the sample, andlor posterior probabilities. The manual interpretation of joint sets using the progressive contouring has several disadvantages. Firstly; the resulting interpretation is subjective and often varies according to who made the interpretation. Secondly; the presentation of the contours on a planar circle distorts the original hemisphere and may result in a biased inter pretation. Thirdly; it is difficult to remove accurately a particular joint set so that the remaining data can be examined, particularly in the case of overlapping joint sets. Fourthly; it is time-consuming and requires an experienced user. On the other hand, the mixture model approach is based on a sound statistical model of the joint set distribution that overcomes these problems as it provides a quantitative method not dependent on the user's interpretation; and it places no bias on the interpretation of joints at different angles. Moreover; it is capable of describing elongated clusters that often occur in practice as well as circular clusters, and it is able to handle overlapping clusters in a satisfactory manner. Further, it requires only a limited amount of the user' s time, this mainly to read the computer output; and does not require any special experience. being



