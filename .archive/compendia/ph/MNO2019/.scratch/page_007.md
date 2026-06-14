[Page 7]


41.0

0.0

(a)

0.5

1.0

![The image is a graph with three axes labeled as x, y, and z. The x-axis is labeled as Birth and is marked with intervals of 0 to 10. The y-axis is labeled as 0 and is marked with intervals of 0 to 10. The z-axis is labeled as 0 and is marked with intervals of 0 to 10. The graph has a linear scale of range 0 to 10 on the x-axis, and a linear scale of range 0 to 10 on the y-axis. There are two lines on the graph, one for each category of data represented by the x-axis and one for each category of data represented by the y-axis. The x-axis is labeled as Birth and is marked with intervals of 0 to 10. The y-axis is labeled as 0 and is marked with intervals](<MNO2019/imageFile2.png>)





0.0



0.0




Birth

(b)


Birth

(c)


FIG. 2: (a) An example of a dataset; (b) Its persistence diagram; (c) Its tilted representation. 3.1 Model

Given a persistence diagram D , the map T : W → T ( W ) given by T ( b,d ) = ( b,d − b ) deﬁnes tilted representation of D as T ( D ) = ∪ ( b,d,k ) ∈D ( T ( b,d ) ,k ); see Figure 2. In the sequel, we assume all PDs are given in their tilted representations and, unless otherwise noted, abuse notation by writing W and D for T ( W ) and T ( D ), respectively. We also ﬁx the homological dimension of features in a PD by deﬁning D k := { ( b,d ) ∈ W | ( b,d,k ) ∈ D} .

According to Bayes’ theorem, posterior density is proportional to the product of a likelihood function and a prior. To adopt Bayesian framework to PDs, we need to deﬁne two models. In particular, our Bayesian framework views a random PD as a Poisson PP equipped with a prior intensity while observed PDs D Y are considered to be marks from a marked Poisson PP. This enables modiﬁcation of the prior intensity by incorporating observed PDs, yielding a posterior intensity based on data. Some parallels between our Bayesian framework and that for random variables (RVs) are illustrated in Table 1. Let ( D k X , D k Y ) ∈ W × W

TABLE 1 The parallels between the Bayesian framework for RVs and its counterpart for random PDs.

| |Bayesian Framework for RVs|Framework for Random PDs|
|---|---|---|
|Prior|Modeled by a prior density f|PP with prior intensity λ|
|Likelihood|Depends on observed data|that depends on observed PDs|
|Posterior|Compute the posterior density|with posterior intensity|


be a ﬁnite PP and consider the following:

(M1) For k 1 = k 2 , ( D k 1 X , D k 1 Y ) and ( D k 2 X , D k 2 Y ) are independent.

glyph[negationslash]

- (M2) For k ﬁxed, D k X = D k X O ∪ D k X V and some α : W → [0 , 1], D k X O and D k X V are independent Poisson PPs having intensity functions α ( x ) λ D k X ( x ) and (1 − α ( x )) λ D k X ( x ), respectively.
- (M3) For k ﬁxed, D k Y = D k Y O ∪ D k Y S where


- (i) ( D k X O , D k Y O ) is a marked Poisson PP with a stochastic kernel density   ( y | x ).
- (ii) D k Y O and D k Y S are independent ﬁnite Poisson PPs where D k Y S has intensity function λ D k Y S .


Hereafter we abuse notation by writing D X for D k X . The modeling assumption (M1) allows us to develop results independently for each homological dimension k then combine them using independence. In (M2), the random persistence diagram D X modeled as a Poisson PP with prior intensity λ D X . There are two cases we may encounter for any point x from the prior intensity due to the nature of persistence diagrams. We assign a probability function α ( x ) to accommodate these two possibilities. Depending upon the noise level in data, any feature x in D X may not be represented in observations and this scenario happens with probability 1 -α ( x ) and we denote this case as D X V in (M2). Otherwise a point x observed with a probability of α ( x ) and this scenario is presented as D X O in (M2). Consequently, the intensities of D X O and D X V are proportional to the intensity λ D X weighted by α ( x ) and 1 -α ( x ) respectively and the total prior intensity for D X is given by their sum. (M3) considers observed persistence diagram D Y and decomposes it into two independent PDs, D Y O and D Y S . D Y O is linked to D X O via a marked point process with likelihood glyph[lscript] ( y | x ) defined in Equation (1), whereas the component D Y S includes any point y that arises from noise or unanticipated geometry. See Figure 3 for a graphical representation of these ideas.
