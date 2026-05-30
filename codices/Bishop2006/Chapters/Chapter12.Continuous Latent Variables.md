## 12. Continuous Latent Variables

In Chapter 9, we discussed probabilistic models having discrete latent variables, such as the mixture of Gaussians. We now explore models in which some, or all, of the latent variables are continuous. An important motivation for such models is that many data sets have the property that the data points all lie close to a manifold of much lower dimensionality than that of the original data space. To see why this might arise, consider an artificial data set constructed by taking one of the off-line digits, represented by a 64 x 64 pixel grey-level image, and embedding it in a larger image of size 100 x 100 by padding with pixels having the value zero (corresponding to white pixels) in which the location and orientation of the digit is varied at random, as illustrated in Figure 12.1. Each of the resulting images is represented by a point in the 100 x 100 = 10, OOO-dimensional data space. However, across a data set of such images, there are only three degrees offreedom of variability, corresponding to the vertical and horizontal translations and the rotations. The data points will therefore live on a subspace of the data space whose intrinsic dimensionality is three. Note

Appendix A

3

Figure 12.1 A synthetic data sel obtained by taking one of the off-line digit images and creating multiple copies in each of which the digit has undergone a random displacement and rotation within some larger image field. The resulting images each have 100)(100 = 10.000 pixels.

SeCTion 8.1..J that the manifold will be nonlinear because. for instance. if we translate the digit past a particular pixel, that pixel value will go from zero (white) 10 one (black) and back to zero again. which is clearly a nonlinear function of the digit position. In this example.!.he lranslation and rotation parameters are latent variables because we observe only the image vectors and are not told which values of the translation or rotation variables were used to create them.

For real digit image data, there will be a funher degree of freedom arising from scaling. Moreover there will be multiple addilional degrees of freedom associaled wilh more complex deformations due to the variability in an individual's wriling 3S well as lhe differences in writing slyles between individuals. evenheless. the number of such degrees of freedom will be small compared to the dimensionality of Ihe data set.

Another example is provided by the oil flow data set. in which (for a given geometrical configuration of the gas, WOller, and oil phases) there are only two degrees of freedom of variability corresponding to the fraction of oil in the pipe and the fraction of water (the fraction of gas Ihen being determined). Ahhough the data space comprises 12 measuremenlS, a data set of points will lie close to a Iwo-dimensional manifold embedded within this space. In this case, the manifold comprises scveral distinct segments corresponding to different flow regimes. each such segment being a (noisy) continuous two-dimensional manifold. If our goal is data compression. or density modelling, then there can be benefits in exploiling this manifold struclUre.

In praclice. the data points will not be confined precisely to a smooth lowdimensional manifold, and we can interpret the departures of data points from the manifold as ·noise'. This leads naturally to a generative view of such models in which we first select a poinl within the manifold according to some latent variable distribution and then generate an observed data point by:ldding noise, drawn from some conditional distribution of the data varillbles given the latent varillbles.

Thc simplest continuous latent variable model assumes Gaussian distributions for both thc latent and observed variables and makes use of a linear,Gaussian dependence of the observed variables on Ihe slate of the latent variables. This leads to a probabilislic fonnulation of the well-known technique of principal component analysis (PeA), as well as 10 a related model called factor analysis.

In this chapter w will begin wilh a slandard, nonprobabilistic treatment of PeA. and thcn we show how PeA arises naturally as the maximum likelihood solution 10

Flgu,e12.2 P'if>cipal compooont a",,~" seeks" $pace 01!owe, dimensionality. kt"(>WIl as!he P<lno> pal subSpace "nd denoted I:Jy the magenta line. SUCh Itlet the Grthogonet [jiojectiOh 01!he data points ('ed doIsl onto tP'Ns ~ """'imizes the varia,..,., of!he proja<:ted points (green doIs). An "It",nati""....finilion 01 PCA is based on m.. mizing the """,-<>I·squares of!he projection errors. ind'cated by the bfi.>e lines.

""",-<>I·squares lines.

"1

S'crio" 12.2 S'di"" 12.4 a panlcula, fonn of linear-Gau"ian latem "ariable model. This probabilistic reformulation bring~ many ad\'imlag~s, su~h as tl>l: use I)f EM for parameter eslimalion, rrinciple<J c~tensioos 10 Oli~turc, of PeA model" and Ba)'~sian formulat;ons that allow tbe number of rrincipal com[>Oncnts to be detennined aUlOmatically from!be data. Finally, we discuss briefly several generalizations of the latent variable concept that go beyond the linear-Gaussian assumption, including non-Gaussian latent variables, which lead to the framework of independent component analysis as well as models having a nonlinear relationship between latent and observed variables.

### 12.1 Principal Component Analysis

---

Principal compooem analy,;" or rcA.;s a technique tha! is "'idely u<ed for appli. cations such as dimensionality.-eduction, lossy data comprc"ion, feature e>tracti"". and data v;,ualizatiOll (Jolliffe, 2(02). It;s also kno...." as tile Karoan.n·I..,;"" tran,· f~.

lbcrc an: t....o commonly used definitions of PeA that giye rise to the >arne algorithm. PeA can be defined as the unhog<lnal projtttion of the data O/1tO a lo....er dimensionallincar space. kno....n as the pri/lcip.al $uh.• p.aa. soch that the\'ariance of the projttted data i' ma~imi,e<J (1I",.lIing. 1933). Equi"alemly,;t can be defined as tbe linear projection that minimi"'. the average projttlion cost. defined as t~ mean squa.-ed distance!letween the data [>Oint< and tbeir p<ojtttioo, (Pearson, 19(1). The l"J'"OC"s< of onhogonal projection i' illustraled in FiguTe 12.2. We con,ider each of these definitions in tum.

12,1.1 Mllximllm variance lormulation

Con,ider a dala set <If obser"\lations {x,,} where" = 1..... S, and x" i, a Euclidean variable "'ilh dimen,ionality D. Our goal is to project If>/:: data onto a 'pace ha"ing dimen,ionality M < D" hile Ill3Jli",i,illg the "ariallCe of the projttted data. For the!noll..nl. we 'hall assume that tbe "alue of M is g;\·en. Latcr in this chapter, we shall consider techniques to determine an appropriate value of IV! from the data.

To begin with, consider the projection onto a one-dimensional space (M = 1). We can define the direction of this space using a D-dimensional vector Ul, which for convenience (and without loss of generality) we shall choose to be a unit vector so that uf Ul = 1 (note that we are only interested in the direction defined by Ul, not in the magnitude of Ul itself). Each data point X n is then projected onto a scalar value uf X n. The mean of the projected data is ufx where x is the sample set mean given by

$$
\overline { x } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N } x _ { n }
$$

and the variance of the projected data is given by

$$
\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\left\{ u _ { 1 } ^ { T } x _ { n } - u _ { 1 } ^ { T }\overline { x }\right\} ^ { 2 } = u _ { 1 } ^ { T } S u _ { 1 }\,
$$

where S is the data covariance matrix defined by

$$
S =\frac { 1 } { N }\sum _ { n = 1 } ^ { N } (x _ { n } -\overline { x }) (x _ { n } -\overline { x }) ^ { T }.
$$

We now maximize the projected variance UfSUl with respect to Ul. Clearly, this has to be a constrained maximization to prevent Ilulll..... 00. The appropriate constraint comes from the normalization condition uf Ul = 1. To enforce this constraint, we introduce a Lagrange multiplier that we shall denote by AI, and then make an unconstrained maximization of

$$
(1 2. 4)
$$

By setting the derivative with respect to Ul equal to zero, we see that this quantity will have a stationary point when

$$
S u _ { 1 } =\lambda _ { 1 } u _ { 1 }
$$

which says that Ul must be an eigenvector of S. If we left-multiply by uf and make use of uf Ul = 1, we see that the variance is given by

$$
\Im u _ { 1 } =\lambda _ { 1 }
$$

and so the variance will be a maximum when we set Ul equal to the eigenvector having the largest eigenvalue AI. This eigenvector is known as the first principal component.

We can define additional principal components in an incremental fashion by choosing each new direction to be that which maximizes the projected variance

Appendix C amongst all possible directions orthogonal to those already considered. If we consider the general case of an M -dimensional projection space, the optimal linear projection for which the variance of the projected data is maximized is now defined by the M eigenvectors U 1,..., U M of the data covariance matrix S corresponding to the M largest eigenvalues >'1,..., AM. This is easily shown using proof by induction.

To summarize, principal component analysis involves evaluating the mean x and the covariance matrix S of the data set and then finding the M eigenvectors of S corresponding to the M largest eigenvalues. Algorithms for finding eigenvectors and eigenvalues, as well as additional theorems related to eigenvector decomposition, can be found in Golub and Van Loan (1996). Note that the computational cost of computing the full eigenvector decomposition for a matrix of size D x Dis O(D3). If we plan to project our data onto the first M principal components, then we only need to find the first M eigenvalues and eigenvectors. This can be done with more efficient techniques, such as the power method (Golub and Van Loan, 1996), that scale like O(MD 2), or alternatively we can make use of the EM algorithm.

#### 12.1.2 Minimum-error formulation

We now discuss an alternative formulation of peA based on projection error minimization. To do this, we introduce a complete orthonormal set of D-dimensional basis vectors {Ui} where i = 1,..., D that satisfy

$$
\mathbf u _ { i } ^ { 1 }\mathbf u _ { j } =\delta _ { i j }.
$$

Because this basis is complete, each data point can be represented exactly by a linear combination of the basis vectors

$$
x _ { n } =\sum _ { i = 1 } ^ { D }\alpha _ { n i } u _ { i }
$$

where the coefficients ani will be different for different data points. This simply corresponds to a rotation of the coordinate system to a new system defined by the {Ui}, and the original D components {Xnl'..., XnD} are replaced by an equivalent set {anl'...,anD}. Taking the inner product with Uj, and making use of the orthonormality property, we obtain anj = x; Uj, and so without loss of generality we can write D

$$
x _ { n } =\sum _ { i = 1 } ^ { D }\left (x _ { n } ^ { T } u _ { i }\right) u _ { i }.\\
$$

Our goal, however, is to approximate this data point using a representation involving a restricted number M < D of variables corresponding to a projection onto a lower-dimensional subspace. The M -dimensional linear subspace can be represented, without loss of generality, by the first M of the basis vectors, and so we approximate each data point X n by

$$
\widetilde { x } _ { n } =\sum _ { i = 1 } ^ { M } z _ { n i } u _ { i } +\sum _ { i = M + 1 } ^ { D } b _ { i } u _ { i }
$$

where the {Zni} depend on the particular data point, whereas the {bd are constants that are the same for all data points. We are free to choose the {Ui}, the {Zni}, and the {bd so as to minimize the distortion introduced by the reduction in dimensionality. As our distortion measure, we shall use the squared distance between the original data point X n and its approximation X n, averaged over the data set, so that our goal is to minimize N

$$
J =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\|\mathbf x _ { n } -\widetilde {\mathbf x } _ { n }\| ^ { 2 }.
$$

Consider first of all the minimization with respect to the quantities {Zni}. Substituting for X n, setting the derivative with respect to Znj to zero, and making use of the orthonormality conditions, we obtain

$$
z _ { n j } = x _ { n } ^ { T }\mathbf u _ { j }
$$

where j = 1,...,M. Similarly, setting the derivative of J with respect to b i to zero, and again making use of the orthonormality relations, gives

$$
b _ { j } =\overline { x } ^ { T } u _ { j }
$$

where j = M + 1,...,D. If we substitute for Zni and b i, and make use of the general expansion (12.9), we obtain

$$
x _ { n } -\widetilde { x } _ { n } =\sum _ { i = M + 1 } ^ { D }\left\{ (x _ { n } -\overline { x }) ^ { T } u _ { i }\right\} u _ { i }
$$

from which we see that the displacement vector from X n to x n lies in the space orthogonal to the principal subspace, because it is a linear combination of {ud for i = M + 1,..., D, as illustrated in Figure 12.2. This is to be expected because the projected points x n must lie within the principal subspace, but we can move them freely within that subspace, and so the minimum error is given by the orthogonal projection.

We therefore obtain an expression for the distortion measure J as a function purely of the {ud in the form

$$
J =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\sum _ { i = M + 1 } ^ { D }\left (x _ { n } ^ { T } u _ { i } -\overline { x } ^ { T } u _ { i }\right) ^ { 2 } =\sum _ { i = M + 1 } ^ { D } u _ { i } ^ { T } S u _ { i }.
$$

There remains the task of minimizing J with respect to the {Ui}, which must be a constrained minimization otherwise we will obtain the vacuous result Ui = O. The constraints arise from the orthonormality conditions and, as we shall see, the solution will be expressed in terms of the eigenvector expansion of the covariance matrix. Before considering a formal solution, let us try to obtain some intuition about the result by considering the case of a two-dimensional data space D = 2 and a onedimensional principal subspace M = 1. We have to choose a direction U2 so as to

Appendix A minimize J = UISU2' subject to the normalization constraint uI U2 = 1. Using a Lagrange multiplier A2 to enforce the constraint, we consider the minimization of

$$
\widetilde { J } =\mathbf u _ { 2 } ^ {\top }\mathbf S u _ { 2 } +\lambda _ { 2 }\left (1 -\mathbf u _ { 2 } ^ {\top }\mathbf u _ { 2 }\right).
$$

Setting the derivative with respect to U2 to zero, we obtain SU2 = A2U2 so that U2 is an eigenvector of S with eigenvalue A2. Thus any eigenvector will define a stationary point of the distortion measure. To find the value of J at the minimum, we back-substitute the solution for U2 into the distortion measure to give J = A2. We therefore obtain the minimum value of J by choosing U2 to be the eigenvector corresponding to the smaller of the two eigenvalues. Thus we should choose the principal subspace to be aligned with the eigenvector having the larger eigenvalue. This result accords with our intuition that, in order to minimize the average squared projection distance, we should choose the principal component subspace to pass through the mean of the data points and to be aligned with the directions of maximum variance. For the case when the eigenvalues are equal, any choice of principal direction will give rise to the same value of J.

The general solution to the minimization of J for arbitrary D and arbitrary M < D is obtained by choosing the {Ui} to be eigenvectors of the covariance matrix given by

$$
\S u _ { i } =\lambda _ { i }\mathbf u _ { i }
$$

where i = 1,...,D, and as usual the eigenvectors {Ui} are chosen to be orthonormal. The corresponding value of the distortion measure is then given by

$$
J =\sum _ { i = M + 1 } ^ { D }\lambda _ { i }
$$

which is simply the sum of the eigenvalues of those eigenvectors that are orthogonal to the principal subspace. We therefore obtain the minimum value of J by selecting these eigenvectors to be those having the D M smallest eigenvalues, and hence the eigenvectors defining the principal subspace are those corresponding to the M largest eigenvalues.

Although we have considered M < D, the PCA analysis still holds if M = D, in which case there is no dimensionality reduction but simply a rotation of the coordinate axes to align with principal components.

Finally, it is worth noting that there exists a closely related linear dimensionality reduction technique called canonical correlation analysis, or CCA (Hotelling, 1936; Bach and Jordan, 2002). Whereas PCA works with a single random variable, CCA considers two (or more) variables and tries to find a corresponding pair of linear subspaces that have high cross-correlation, so that each component within one of the subspaces is correlated with a single component from the other subspace. Its solution can be expressed in terms of a generalized eigenvector problem.

#### 12.1.3 Applications of PCA

We can illustrate the use of PCA for data compression by considering the offline digits data set. Because each eigenvector of the covariance matrix is a vector

Mean

3

3

16

3

Figure 12.3 The mean ~'" x aklog with!he II"'t lou' PCA e;gerrvecl<)rll Ul,... '" lor the 011-..... cligits data set. t<>getl'ler with!he correspondi~ ~.

,

,

, "

to'

;n the OIigi",,1 D-<limensional space. we can represent tho eigenw:cto<s as imago< of tho same silO as,1>0 data poi",,\_ 11,. first Ih'e.ig.n,'occOfS. along wich tl>o corresponding.igen,'slue,. are <IIo"'n in Figure 12,3, A plO! ofll>o complete spect"'m uf oigo",·alue,. sone<! into decreasing order. is shown in Figure 12.4{ai. The di'tortion measure J aSSQCiated wilh choo<ing a particular value of M is gi.'en by tho sum of the eig.n",lues from M + I up to 0 and is ptO!ted for different,'aluo< of.\1 in Figure 12,4(b).

If "'e <utlslitut. (12, 12) and (12.13) into (12.10). we can write the I'CA appro~imation to a data "eel'" x~ i" the fonn

$$
\widetilde { x } _ { n }\ =\\sum _ { i = 1 } ^ { M } (x _ { n } ^ { T } u _ { i }) u _ { i } +\sum _ { i = M + 1 } ^ { D }\left (\bar { x } ^ { T } u _ { i }\right) u _ { i }\quad (1 2. 1 9)
$$

$$
=\bar { x } +\sum _ { i = 1 } ^ { M }\left (x _ { n } ^ { T } u _ { i } -\overline { x } ^ { T } u _ { i }\right) u _ { i }\quad (1 2. 2 0)
$$

,

,

,

,

10'

, "

",

~,.,

~

~

;

"- "

0 ",

~,.,

~

~ "

FIIIUre 12,4 (a) PIol at!he eJoI;nv.loo.".,etrum lor the off·1ine digits data set (b) P10t 01!he sum at the <:liscarded."".Ioos, which "'l'fesoots!he s.um-ol·SQ"",es distortlon J i<\*~ by projecti<Xl the data onto a p<incipal componenl slll>spaee '" dimensionalitv M.

Original

3

3

3

5

FIIIUr. 1:1:.5 An ",>gi",,1 ~mpIe Irom lI>e 011·\_ digils data...ttOll"1her with its PeA re<:onstnxlions oblair...:! by 'e1aio"li!Xl,If j)<incipal ~n1S 10< various val,," 01,If. As,II increason!tie re<:onst,uctiOfI ~s more ao::urate and woukl ~ portee! when.-If K D ~ 28 x 28 ~."-1.

AI''''''''/;'\' A

Seer/on 9.1 where we ha"e made moe of the relation

$$
\bar { x } =\sum _ { i = 1 } ^ { D }\left (\bar { x } ^ { T } u _ { i }\right) u _ { i } & & (1 2, 2 1)
$$

which follow. from the completene" of the {u, I, Thi. represent. a contpre"ioo "f the data >ct. Ilttau>e for each data poim we ha,.. repla«d the V·dimensiooal "o<:lor x" Wilh an,I[.din>en,ional "o<:tor having componem, (x~ '"\_ X'",). 11Ie 'mailer the "alue of M. the greater the degree of comp.-e",ion. Example. of PeA,""on't""tioos of data points for the digits data set are shown in Figure 12.5

Anolher application of priocipal compcmenl analy,i. i' to data pre-processing. In thi' case, lhe goal is nO! dimensionality redUC1ion but rather the tmn,formmion of a data sel in or<k' to standa'lli'.e eenain of ilS pmpenies. This can be in'portanl in allowing.ubsequent pallem,""ognition algorithm. 10 be applied successfully 10 the data >ct. Typically. il is done wilen the original "ariable. are mea,ured in "arioos dif. ferent unil' or!la"e significantly difTerent,'ariabilil}'. For instance in the Old Faithful data sel. the time betv.-een eruption. i. typicany an order of magni1Ude greater than lhe dUrali"" of.n erupt;,,". When W'e applied the ".nlCans algorill"" 10 thi< data set, ".-e first made a separ.te linear re-sealing of the individual "anable' socb thm each "ariable had zero mean and unit "ariance. llUs is known as slllNlardiv·.,g the dota. and the cO\'anance matrix for lhe 'lando,di/,ed dala has components

$$
\rho _ { i j } =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\frac { (x _ { n i } -\overline { x } _ { i }) } {\sigma _ { i } }\frac { (x _ { n j } -\overline { x } _ { j }) } {\sigma _ { j } }
$$

where <1, is the,'anaoce of:c,. This i< known as the (",,,el,,,;,,,, matri.' of the original dota and ha' the propeny thai if t""o rompooent, X; and x, of the data are perfee1ly correl.ted. then Ai _ I.•nd if they a.-e uocorrelated. then Ai _ O.

11",,'1""', using PeA we can make a It>Of'e subst.mial nonnalizat;oo of the data to gi\'C it zero mean and unit co'·ariance. so that different "anables become derorrelate<l To do this. we first ""rile the ei8Cn"cclor equation (12, 17) in the form

$$
\text { SU } =\text { UL}
$$

100

90

80

70

60

50

40

00'

,=~o

2

4

6

2

0

-2

-2

0

2

2

0

-2

000

0

0

08

0

0

~ cPO

0

0

O~

~OOID

-2

0

2

Figure 12.6 Illustration of the effects of linear pre-processing applied to the Old Faithful data set. The plot on the left shows the original data. The centre plot shows the result of standardizing the individual variables to zero mean and unit variance. Also shown are the principal axes of this normalized data set, plotted over the range ±A~/2. The plot on the right shows the result of whitening of the data to give it zero mean and unit covariance.

Appendix A

Appendix A where L is a D x D diagonal matrix with elements Ai, and U is a D x D orthogonal matrix with columns given by Ui. Then we define, for each data point X n, a transformed value given by

$$
y _ { n } = L ^ { - 1 / 2 } U ^ {\mathrm T } (x _ { n } -\overline { x })
$$

where x is the sample mean defined by (12.1). Clearly, the set {Yn} has zero mean, and its covariance is given by the identity matrix because

$$
\frac { 1 } { N }\sum _ { n = 1 } ^ { N } y _ { n } y _ { n } ^ { T }\ & =\\frac { 1 } { N }\sum _ { n = 1 } ^ { N } L ^ { - 1 / 2 } U ^ { T } (x _ { n } -\overline { x }) (x _ { n } -\overline { x }) ^ { T } U L ^ { - 1 / 2 }\\ & =\ L ^ { - 1 / 2 } U ^ { T } S U L ^ { - 1 / 2 } = L ^ { - 1 / 2 } L L ^ { - 1 / 2 } = I.\quad (1 2. 2 5)
$$

This operation is known as whitening or sphereing the data and is illustrated for the Old Faithful data set in Figure 12.6.

It is interesting to compare PCA with the Fisher linear discriminant which was discussed in Section 4.1.4. Both methods can be viewed as techniques for linear dimensionality reduction. However, PCA is unsupervised and depends only on the values X n whereas Fisher linear discriminant also uses class-label information. This difference is highlighted by the example in Figure 12.7.

Another common application of principal component analysis is to data visualization. Here each data point is projected onto a two-dimensional (M = 2) principal subspace, so that a data point X n is plotted at Cartesian coordinates given by x'J. U1 and x'J. U2, where Ul and U2 are the eigenvectors corresponding to the largest and second largest eigenvalues. An example of such a plot, for the oil flow data set, is shown in Figure 12.8.

A comparison 01 pro:ipal compoMnt analysis.... 111 Fisha(s linaar discriminant 101 """", <\*man""'" ality r&duclion. Here too data in two dimansions, belonging to two classes sIIOWI1 in red and blue. is to be PfOI"Cled onto a s.ingle di· mension. PCA c/>xlsas the direc· tion 01 maximum varia""e. sIIOWI1 try tha ma9""ta Co""'. wt11ch leads to strong class overlap. whereas!he Fisl>ef IiMar diSCfOrnillant takes accoun1 <:A too class labels and leads to a projection onto the g<ean CUM! giving much t>etler class Fig"", 12.7 separation "

.

- '~'" -

~

\_',

.•••.

.• ".,..

''''

.

~

..

..,

..

..

..-:--' '

~ ':r-'---~+·\_

~-J

~,

.,

."

.,':----;!---;-"\_.S 0 3

\_.S

0

3

Fig"", 12.8 Visualilatlon 01!he oill'low <lata lIet obtained try projoecting the <lata onto the lirst two prin. cipal compone<1ts. The <ed, blue, and 9r&en points corre-spond to!he 'IamiNI(, 't>omogenoous', and '8nnula~ flow oonligurations ",specriveIy.

4+

12.1.4 peA for high-dimensional data

In some application. of pliTlCipal component analysis. the number of data points is smaller than t!>c dimensionality of troe data 'pace. FOI" example. ",e might want to apply PeA to a data <el of a few hundred images, each of,,'hich rorrespoOOs to a "eetor in a 'pace of poIentially.....ml million dimensiOlls (COITesponding tn thfl'e enlour "alues for each of the pi.",ls in troe image), NOIe that in a D-<limen,ional space a set of jY points. ",'here N < D. defines a linear subspa::e ",hose dimensi"nality is at ""'st N 1, and SO there is linle point in applying PeA for,'alue< of M thaI"'" greater than N I, Indeed, if "'e pelf"",, PeA we will find that at least D N + I of the eigen".lues art lero. eorrespnnding tQ eigenvectors aloog ",hose direclioos the data <el has 10m varianee. Funhem>ore. typical algOl"ithm, for finding the eigen,'eet"" of a D x D matrix ha"e a computatiooal eosl thm scales like O(D~ J. aOO so for appliealions such as the image e,ample. a direc' application of PeA will be computatiooally infe,,-sibJe.

W. can resoh'e this problem as foIl",",'" Fir;l. let us define X to be the (N " DJ· dimensional centred data matrix, whose nth row is given by (x n X)T. The covariance matrix (12.3) can then be written as S = N1 XTX, and the corresponding eigenvector equation becomes

$$
\frac { 1 } { N } X ^ { T } X u _ { i } =\lambda _ { i } u _ { i }.
$$

Now pre-multiply both sides by X to give

$$
\frac { 1 } { N } X X ^ { T } (X u _ { i }) =\lambda _ { i } (X u _ { i }).
$$

If we now define Vi = XUi, we obtain

$$
\frac { 1 } { N } X X ^ { T } v _ { i } =\lambda _ { i } v _ { i }
$$

which is an eigenvector equation for the N x N matrix N1 XX T. We see that this has the same N -1 eigenvalues as the original covariance matrix (which itself has an additional D N + 1 eigenvalues of value zero). Thus we can solve the eigenvector problem in spaces of lower dimensionality with computational cost O(N 3) instead of O(D 3). In order to determine the eigenvectors, we multiply both sides of (12.28) by X T to give

$$
\left (\frac { 1 } { N } X ^ { T } X\right) (X ^ { T } v _ { i }) =\lambda _ { i } (X ^ { T } v _ { i })
$$

from which we see that (XTVi) is an eigenvector of S with eigenvalue Ai. Note, however, that these eigenvectors need not be normalized. To determine the appropriate normalization, we re-scale Ui ex: X T Vi by a constant such that Ilui II = 1, which, assuming Vi has been normalized to unit length, gives

$$
u _ { i } =\frac { 1 } { (N\lambda _ { i }) ^ { 1 / 2 } } X ^ {\top } v _ { i }.
$$

In summary, to apply this approach we first evaluate XX T and then find its eigenvectors and eigenvalues and then compute the eigenvectors in the original data space using (12.30).

### 12.2 Probabilistic PCA

The formulation of PCA discussed in the previous section was based on a linear projection of the data onto a subspace of lower dimensionality than the original data space. We now show that PCA can also be expressed as the maximum likelihood solution of a probabilistic latent variable model. This reformulation of PCA, known as probabilistic peA, brings several advantages compared with conventional PCA:

• Probabilistic PCA represents a constrained form of the Gaussian distribution in which the number of free parameters can be restricted while still allowing the model to capture the dominant correlations in a data set.

• We can derive an EM algorithm for PCA that is computationally efficient in situations where only a few leading eigenvectors are required and that avoids having to evaluate the data covariance matrix as an intermediate step.

- • The combination of a probabilistic model and EM allows us to deal with missing values in the data set.
- • Mixtures of probabilistic PCA models can be formulated in a principled way and trained using the EM algorithm.
- • Probabilistic PCA forms the basis for a Bayesian treatment of PCA in which the dimensionality of the principal subspace can be found automatically from the data.

- • The existence of a likelihood function allows direct comparison with other probabilistic density models. By contrast, conventional PCA will assign a low reconstruction cost to data points that are close to the principal subspace even if they lie arbitrarily far from the training data.
- • Probabilistic PCA can be used to model class-conditional densities and hence be applied to classification problems.
- • The probabilistic PCA model can be run generatively to provide samples from the distribution.

This formulation of PCA as a probabilistic model was proposed independently by Tipping and Bishop (1997, 1999b) and by Roweis (1998). As we shall see later, it is closely related to factor analysis (Basilevsky, 1994).

Probabilistic PCA is a simple example of the linear-Gaussian framework, in which all of the marginal and conditional distributions are Gaussian. We can formulate probabilistic PCA by first introducing an explicit latent variable z corresponding to the principal-component subspace. Next we define a Gaussian prior distribution p(z) over the latent variable, together with a Gaussian conditional distribution p(xl z) for the observed variable x conditioned on the value of the latent variable. Specifically, the prior distribution over z is given by a zero-mean unit-covariance Gaussian

$$
p (z) =\mathcal { N } (z | 0, I).
$$

Similarly, the conditional distribution of the observed variable x, conditioned on the value of the latent variable z, is again Gaussian, of the form

$$
p (x | z) =\mathcal { N } (x | W z +\mu,\sigma ^ { 2 } I)
$$

in which the mean of x is a general linear function of z governed by the D x M matrix Wand the D-dimensional vector J-L. Note that this factorizes with respect to the elements of x, in other words this is an example of the naive Bayes model. As we shall see shortly, the columns of W span a linear subspace within the data space that corresponds to the principal subspace. The other parameter in this model is the scalar a 2 governing the variance of the conditional distribution. Note that there is no

P(x|:

,

/

.-

,

,

,

,

,

,

,

, p(x)

Flgu.. 12.9 I\n ~I"'tfat"" oIlt>e II"""fative vi&w oI1t>e p<ot>abi!;st", PeA modeIfof" two-dimensiooal <!ala space and a on&-<lirnent.ionallat/l<1t space, An Ob&erved <!ala point x Is generated by first drawing a value i fof 1t>e Iat&n1 vafiatlle /f(lm ~s prior dist,~t"" P(~) and Itlen drawing a val"" fof x lrom an iSO/fopK: Gaussian distr~t"" (iijust,al&(l by the red cir<:ie's) having mean wi +" and coY8r1.once,,'1 The l/f&er\ ellips.&$ show l!le density """toors!of the marg'''''1 dis1r1bulion PIx).

E,e,,-ise 12,7 loss of ge""raJity in assuming a zero mean. unit co\'ariance Gau"ian for the latent distributi"n II{Z) because a more gcneral Gau"i3n di"ributi"n would gi"e rise to an equivalent probabili"ic n>odel.

We can view the probabilistic PeA model from a geoerati"e\'iew""int in "hich a sampled '-alue of the ob""Yed,..riable is obIained by first choo,ing a,..Iue for the latent,'ariahle aod then >ampling the OO",,,'e;j,-ariable cooditioned on this lao tent\'alue, Specifically, the V-dimen'ional OO"''''ed '-ariable x is defined by a lin· ea, tran,formati,," of the '\/·dimen,i"nal latcnt '-ariable z plu, additi'-e Gaussian 'noise', <0 that

$$
x = W z +\mu +\epsilon
$$

w!>ere z is an M-di""'nsional Gaussian lalent variable. and.. is a V·dimensi"nal,ero-mean Gau..ian-distributed noi.., "ariable witb co'-ariance,,21. This generative process is illustrated in Figure 12.9. NOIe that this frame".-orl< is based on a mapping from latent,pace 10 data space. in contrast 10 the nl()l'(: C(""'cnti,,,,"1 "iew "f I'CA dis.cus"'d alx",e, 11Ie ",,'e= mapping, from data space to the latent space.,,-ill he OOlained,honly using Ha ycs· lhwn:m.

SUf!ll'OSC we wish 10 deten"ine the "alues ofll>o parameters\V. I' and,,' uSIng maximum likelihuo<l, To write """"n lhe likeliltood function, we need an ""pression for tl>o marginal distributioo p{") of tl>o ~,,'ed... riahle\_ This is exprt\_\_ sed. fmn' the sum aod p,oduct rules "fprobability, in the form

$$
p (x) =\left /\ p (x | z) p (z)\, d z.
$$

ll""auS(: this corresponds to a linear·Gau"i,n lT1(llIcL thi< marginal di,tribulion is again Gaussian. atld is given by

$$
p (x) = N (x |\mu, C)
$$

Exercise 12.8 where the D x D covariance matrix C is defined by

$$
C = W W ^ { T } +\sigma ^ { 2 } I.
$$

This result can also be derived more directly by noting that the predictive distribution will be Gaussian and then evaluating its mean and covariance using (12.33). This gives

$$
\begin{array} { r l } {\mathbb { E } [x] } & { = } & {\mathbb { E } [W z +\mu +\epsilon] =\mu }\\ { c o v [x] } & { = } & {\mathbb { E }\left [(W z +\epsilon) (W z +\epsilon) ^ { T }\right] }\\ & { = } & {\mathbb { E }\left [W z z ^ { T } W ^ { T }\right] +\mathbb { E } [\epsilon\epsilon ^ { T }] = W W ^ { T } +\sigma ^ { 2 } I }\end{array}
$$

$$
\mathbb { E } [x]\ =\\mathbb { E } [\mathbb { W } z +\mu +\epsilon] =\mu
$$

$$
\ =\\mathbb { E }\left [\text {W} z z ^ { T } W ^ { T }\right] +\mathbb { E } [\epsilon\epsilon ^ { T }] =\text {W} W ^ { T } +\sigma ^ { 2 } I\quad (1 2. 3 8)
$$

where we have used the fact that z and E are independent random variables and hence are uncorrelated.

Intuitively, we can think of the distribution p(x) as being defined by taking an isotropic Gaussian 'spray can' and moving it across the principal subspace spraying Gaussian ink with density determined by 02 and weighted by the prior distribution. The accumulated ink density gives rise to a 'pancake' shaped distribution representing the marginal density p(x). 2

The predictive distribution p(x) is governed by the parameters JL, W, and 0• However, there is redundancy in this parameterization corresponding to rotations of the latent space coordinates. To see this, consider a matrix W = WR where R is an orthogonal matrix. Using the orthogonality property RR T = I, we see that the quantity WW T that appears in the covariance matrix C takes the form

$$
\widetilde { W }\widetilde { W } ^ { T } = W R R ^ { T } W ^ { T } = W W ^ { T }
$$

and hence is independent of R. Thus there is a whole family of matrices W all of which give rise to the same predictive distribution. This invariance can be understood in terms of rotations within the latent space. We shall return to a discussion of the number of independent parameters in this model later. 1

When we evaluate the predictive distribution, we require C, which involves the inversion of a D x D matrix. The computation required to do this can be reduced by making use of the matrix inversion identity (C.7) to give

$$
C ^ { - 1 } =\sigma ^ { - 1 } I -\sigma ^ { - 2 } W M ^ { - 1 } W ^ { T }
$$

where the M x M matrix M is defined by

$$
M = W ^ { T } W +\sigma ^ { 2 } I.
$$

Because we invert M rather than inverting C directly, the cost of evaluating C1 is reduced from O(D 3) to O(M 3).

As well as the predictive distribution p(x), we will also require the posterior distributionp(zlx), which can again be written down directly using the result (2.116) for linear-Gaussian models to give

$$
p (z |\mathbf x) =\mathcal { N }\left (z | M ^ { - 1 } W ^ {\top } (\mathbf x -\mu),\sigma ^ { - 2 } M\right).
$$

Note that the posterior mean depends on x, whereas the posterior covariance is independent of x.

Figure 12.10 The probabilistic PCA model for a data set of N observations of x can be expressed as a directed graph in which each observation X n is associated with a value of the latent variable.

Zn of the latent variable.

02

..-+--w

#### 12.2.1 Maximum likelihood PCA

We next consider the determination of the model parameters using maximum likelihood. Given a data set X = {x n } of observed data points, the probabilistic peA model can be expressed as a directed graph, as shown in Figure 12.10. The corresponding log likelihood function is given, from (12.35), by

$$
\ln p (X |\mu, W,\sigma ^ { 2 }) & =\sum _ { n = 1 } ^ { N }\ln p (x _ { n } | W,\mu,\sigma ^ { 2 })\\ & =\ -\frac { N D } { 2 }\ln (2\pi) -\frac { N } { 2 }\ln | C | -\frac { 1 } { 2 }\sum _ { n = 1 } ^ { N } (x _ { n } -\mu) ^ { T } C ^ { - 1 } (x _ { n } -\mu).
$$

Setting the derivative of the log likelihood with respect to JL equal to zero gives the expected result JL = x where x is the data mean defined by (12.1). Back-substituting we can then write the log likelihood function in the form

$$
\ln p (X | W,\mu,\sigma ^ { 2 }) = -\frac { N } { 2 }\left\{ D\ln (2\pi) +\ln | C | +\text {Tr}\left (C ^ { - 1 } S\right)\right\}\quad
$$

where S is the data covariance matrix defined by (12.3). Because the log likelihood is a quadratic function of JL, this solution represents the unique maximum, as can be confirmed by computing second derivatives.

Maximization with respect to W and 0'2 is more complex but nonetheless has an exact closed-form solution. It was shown by Tipping and Bishop (1999b) that all of the stationary points of the log likelihood function can be written as

$$
W _ { M L } = U _ { M } (L _ { M } -\sigma ^ { 2 } I) ^ { 1 / 2 } R
$$

where U M is a D x M matrix whose columns are given by any subset (of size M) of the eigenvectors of the data covariance matrix S, the M x M diagonal matrix L M has elements given by the corresponding eigenvalues..\, and R is an arbitrary M x M orthogonal matrix.

Furthermore, Tipping and Bishop (1999b) showed that the maximum of the likelihood function is obtained when the M eigenvectors are chosen to be those whose eigenvalues are the M largest (all other solutions being saddle points). A similar result was conjectured independently by Roweis (1998), although no proof was given.

Again, we shall assume that the eigenvectors have been arranged in order of decreasing values of the corresponding eigenvalues, so that the M principal eigenvectors are Ul,"" UM. In this case, the columns of W define the principal subspace of standard PCA. The corresponding maximum likelihood solution for (J'2 is then given by

$$
\sigma _ { M L } ^ { 2 } =\frac { 1 } { D - M }\sum _ { i = M + 1 } ^ { D }\lambda _ { i }
$$

so that (J'~L is the average variance associated with the discarded dimensions.

Because R is orthogonal, it can be interpreted as a rotation matrix in the M x M latent space. If we substitute the solution for W into the expression for C, and make use of the orthogonality property RR T = I, we see that C is independent of R. This simply says that the predictive density is unchanged by rotations in the latent space as discussed earlier. For the particular case of R = I, we see that the columns of W are the principal component eigenvectors scaled by the variance parameters Ai (J'2. The interpretation of these scaling factors is clear once we recognize that for a convolution of independent Gaussian distributions (in this case the latent space distribution and the noise model) the variances are additive. Thus the variance Ai in the direction of an eigenvector Ui is composed of the sum of a contribution Ai (J'2 from the projection of the unit-variance latent space distribution into data space through the corresponding column of W, plus an isotropic contribution of variance (J'2 which is added in all directions by the noise model.

It is worth taking a moment to study the form of the covariance matrix given by (12.36). Consider the variance of the predictive distribution along some direction specified by the unit vector v, where vTv = 1, which is given by vTCv. First suppose that v is orthogonal to the principal subspace, in other words it is given by some linear combination of the discarded eigenvectors. Then v TV = 0 and hence vTCv = (J'2. Thus the model predicts a noise variance orthogonal to the principal subspace, which, from (12.46), is just the average of the discarded eigenvalues. Now suppose that v = Ui where Ui is one of the retained eigenvectors defining the principal subspace. Then vTCv = (Ai (J'2) + (J'2 = Ai. In other words, this model correctly captures the variance of the data along the principal axes, and approximates the variance in all remaining directions with a single average value (J'2.

One way to construct the maximum likelihood density model would simply be to find the eigenvectors and eigenvalues of the data covariance matrix and then to evaluate Wand (J'2 using the results given above. In this case, we would choose R = I for convenience. However, if the maximum likelihood solution is found by numerical optimization of the likelihood function, for instance using an algorithm such as conjugate gradients (Fletcher, 1987; Nocedal and Wright, 1999; Bishop and Nabney, 2008) or through the EM algorithm, then the resulting value of R is essentially arbitrary. This implies that the columns of W need not be orthogonal. If an orthogonal basis is required, the matrix W can be post-processed appropriately (Golub and Van Loan, 1996). Alternatively, the EM algorithm can be modified in such a way as to yield orthonormal principal directions, sorted in descending order of the corresponding eigenvalues, directly (Ahn and Oh, 2003).

Exercise 12.11

Exercise 12.12

The rotational invariance in latent space represents a form of statistical nonidentifiability, analogous to that encountered for mixture models in the case of discrete latent variables. Here there is a continuum of parameters all of which lead to the same predictive density, in contrast to the discrete nonidentifiability associated with component re-labelling in the mixture setting.

If we consider the case of M = D, so that there is no reduction of dimensionality, then U M = U and L M = L. Making use of the orthogonality properties UU T = I and RR T = I, we see that the covariance C of the marginal distribution for x becomes

$$
C = U (L -\sigma ^ { 2 } I) ^ { 1 / 2 } R R ^ { T } (L -\sigma ^ { 2 } I) ^ { 1 / 2 } U ^ { T } +\sigma ^ { 2 } I = U L U ^ { T } = S\quad (1 2. 4 7)
$$

and so we obtain the standard maximum likelihood solution for an unconstrained Gaussian distribution in which the covariance matrix is given by the sample covariance.

Conventional PCA is generally formulated as a projection of points from the Ddimensional data space onto an M -dimensional linear subspace. Probabilistic PCA, however, is most naturally expressed as a mapping from the latent space into the data space via (12.33). For applications such as visualization and data compression, we can reverse this mapping using Bayes' theorem. Any point x in data space can then be summarized by its posterior mean and covariance in latent space. From (12.42) the mean is given by

$$
\mathbb { E } [z | x] = M ^ { - 1 } W _ { M L } ^ { T } (x -\bar { x })
$$

where M is given by (12.41). This projects to a point in data space given by

$$
W\mathbb { E } [z | x] +\mu.
$$

Note that this takes the same form as the equations for regularized linear regression and is a consequence of maximizing the likelihood function for a linear Gaussian model. Similarly, the posterior covariance is given from (12.42) by 0-2M1 and is independent of x. 2

If we take the limit 0----t 0, then the posterior mean reduces to

$$
(W _ { M L } ^ { T } W _ { M L }) ^ { - 1 } W _ { M L } ^ { T } (x -\overline { x })
$$

which represents an orthogonal projection of the data point onto the latent space, and so we recover the standard PCA model. The posterior covariance in this limit is zero, however, and the density becomes singular. For 02 > 0, the latent projection is shifted towards the origin, relative to the orthogonal projection.

Finally, we note that an important role for the probabilistic PCA model is in defining a multivariate Gaussian distribution in which the number of degrees of freedom, in other words the number of independent parameters, can be controlled whilst still allowing the model to capture the dominant correlations in the data. Recall that a general Gaussian distribution has D(D + 1)/2 independent parameters in its covariance matrix (plus another D parameters in its mean). Thus the number of parameters scales quadratically with D and can become excessive in spaces of high dimensionality. If we restrict the covariance matrix to be diagonal, then it has only D independent parameters, and so the number of parameters now grows linearly with dimensionality. However, it now treats the variables as if they were independent and hence can no longer express any correlations between them. Probabilistic PeA provides an elegant compromise in which the M most significant correlations can be captured while still ensuring that the total number of parameters grows only linearly with D. We can see this by evaluating the number of degrees of freedom in the PPCA model as follows. The covariance matrix C depends on the parameters W, which has size D x M, and a 2, giving a total parameter count of DM + 1. However, we have seen that there is some redundancy in this parameterization associated with rotations of the coordinate system in the latent space. The orthogonal matrix R that expresses these rotations has size M x M. In the first column of this matrix there are M 1 independent parameters, because the column vector must be normalized to unit length. In the second column there are M 2 independent parameters, because the column must be normalized and also must be orthogonal to the previous column, and so on. Summing this arithmetic series, we see that R has a total of M(M -1)/2 independent parameters. Thus the number of degrees of freedom in the covariance matrix C is given by

$$
^ { 2 }\ D M + 1 - M (M - 1) / 2.
$$

The number of independent parameters in this model therefore only grows linearly with D, for fixed M. If we take M = D 1, then we recover the standard result for a full covariance Gaussian. In this case, the variance along D 1 linearly independent directions is controlled by the columns of W, and the variance along the remaining direction is given by a 2. If M = 0, the model is equivalent to the isotropic covariance case.

#### 12.2.2 EM algorithm for PCA

As we have seen, the probabilistic PCA model can be expressed in terms of a marginalization over a continuous latent space z in which for each data point X n, there is a corresponding latent variable Zn. We can therefore make use of the EM algorithm to find maximum likelihood estimates of the model parameters. This may seem rather pointless because we have already obtained an exact closed-form solution for the maximum likelihood parameter values. However, in spaces of high dimensionality, there may be computational advantages in using an iterative EM procedure rather than working directly with the sample covariance matrix. This EM procedure can also be extended to the factor analysis model, for which there is no closed-form solution. Finally, it allows missing data to be handled in a principled way.

We can derive the EM algorithm for probabilistic PCA by following the general framework for EM. Thus we write down the complete-data log likelihood and take its expectation with respect to the posterior distribution of the latent distribution evaluated using 'old' parameter values. Maximization of this expected completedata log likelihood then yields the 'new' parameter values. Because the data points are assumed independent, the complete-data log likelihood function takes the form

$$
\ln p\left (X, Z |\mu,\mathbb { W },\sigma ^ { 2 }\right) =\sum _ { n = 1 } ^ { N }\{\ln p (x _ { n } | z _ { n }) +\ln p (z _ { n })\}
$$

where the nth row of the matrix Z is given by Zn. We already know that the exact maximum likelihood solution for JL is given by the sample mean x defined by (12.1), and it is convenient to substitute for JL at this stage. Making use of the expressions (12.31) and (12.32) for the latent and conditional distributions, respectively, and taking the expectation with respect to the posterior distribution over the latent variables, we obtain

$$
\mathbb { E } [\ln p\left (X, Z |\mu, W,\sigma ^ { 2 }\right)] & = -\sum _ { n = 1 } ^ { N }\left\{\frac { D } { 2 }\ln (2\pi\sigma ^ { 2 }) +\frac { 1 } { 2 }\text {Tr}\left (\mathbb { E } [z _ { n } z _ { n } ^ { T }]\right)\\ & +\frac { 1 } { 2\sigma ^ { 2 } }\| x _ { n } -\mu\| ^ { 2 } -\frac { 1 } {\sigma ^ { 2 } }\mathbb { E } [z _ { n }] ^ { 1 } W ^ { 1 } (x _ { n } -\mu)\\ & +\frac { 1 } { 2\sigma ^ { 2 } }\text {Tr}\left (\mathbb { E } [z _ { n } z _ { n } ^ { T }] W ^ { T } W\right)\right\}.\\\intertext { e t s depend s o n t h e p o r t i o n d i v e r $ d o w h a t h e s t i c t i s }
$$

Note that this depends on the posterior distribution only through the sufficient statistics of the Gaussian. Thus in the E step, we use the old parameter values to evaluate

$$
\begin{array} { r l r } {\mathbb { E } [z _ { n }] } & = } & { M ^ { - 1 } W ^ { T } (x _ { n } -\overline { x } _ { n }) }\end{array}
$$

$$
\AA]\ =\ M ^ { - 1 } W ^ { T } (x _ { n } -\overline { x })
$$

$$
[z _ { n } z _ { n } ^ { T }]\ =\\sigma ^ { 2 } M ^ { - 1 } +\mathbb { E } [z _ { n }]\mathbb { E } [z _ { n }] ^ { T }
$$

which follow directly from the posterior distribution (12.42) together with the standard result lE[znz~] = cov[zn] + JE[zn]JE[zn]T. Here M is defined by (12.41).

In the M step, we maximize with respect to Wand (J2, keeping the posterior statistics fixed. Maximization with respect to (T2 is straightforward. For the maximization with respect to W we make use of (C.24), and obtain the M-step equations

$$
W _ { n e w }\, =\,\left [\sum _ { n = 1 } ^ { N } (x _ { n } -\overline { x })\mathbb { E } [z _ { n }] ^ { T }\right]\left [\sum _ { n = 1 } ^ { N }\mathbb { E } [z _ { n } z _ { n } ^ { T }]\right] ^ { - 1 }\,
$$

$$
\sigma _ { n e w } ^ { 2 }\, =\,\frac { 1 } { N D }\sum _ { n = 1 } ^ { N }\{\| x _ { n } -\overline { x }\| ^ { 2 } - 2\mathbb { E } [z _ { n }] ^ { T } W _ { n e w } ^ { T } (x _ { n } -\overline { x })\\ +\text {Tr}\left (\mathbb { E } [z _ { n } z _ { n } ^ { T }] W _ { n e w } ^ { T } W _ { n e w }\right)\}.
$$

The EM algorithm for probabilistic PCA proceeds by initializing the parameters and then alternately computing the sufficient statistics of the latent space posterior distribution using (12.54) and (12.55) in the E step and revising the parameter values using (12.56) and (12.57) in the M step.

One of the benefits of the EM algorithm for PCA is computational efficiency for large-scale applications (Roweis, 1998). Unlike conventional PCA based on an eigenvector decomposition of the sample covariance matrix, the EM approach is iterative and so might appear to be less attractive. However, each cycle of the EM algorithm can be computationally much more efficient than conventional PCA in spaces of high dimensionality. To see this, we note that the eigendecomposition of the covariance matrix requires O(D 3) computation. Often we are interested only in the first M eigenvectors and their corresponding eigenvalues, in which case we can use algorithms that are 0 (M D 2). However, the evaluation of the covariance matrix itself takes 0 (ND 2) computations, where N is the number of data points. Algorithms such as the snapshot method (Sirovich, 1987), which assume that the eigenvectors are linear combinations of the data vectors, avoid direct evaluation of the covariance matrix but are O(N 3) and hence unsuited to large data sets. The EM algorithm described here also does not construct the covariance matrix explicitly. Instead, the most computationally demanding steps are those involving sums over the data set that are 0 (NDM). For large D, and M « D, this can be a significant saving compared to 0 (ND 2) and can offset the iterative nature of the EM algorithm.

Note that this EM algorithm can be implemented in an on-line form in which each D-dimensional data point is read in and processed and then discarded before the next data point is considered. To see this, note that the quantities evaluated in the E step (an M-dimensional vector and an M x M matrix) can be computed for each data point separately, and in the M step we need to accumulate sums over data points, which we can do incrementally. This approach can be advantageous if both Nand D are large.

Because we now have a fully probabilistic model for PCA, we can deal with missing data, provided that it is missing at random, by marginalizing over the distribution of the unobserved variables. Again these missing values can be treated using the EM algorithm. We give an example of the use of this approach for data visualization in Figure 12.11. 2

Another elegant feature ofthe EM approach is that we can take the limit a ----t 0, corresponding to standard PCA, and still obtain a valid EM-like algorithm (Roweis, 1998). From (12.55), we see that the only quantity we need to compute in the Estep is JE[zn]. Furthermore, the M step is simplifie~ because M = WTW. To emphasize the simplicity of the algorithm, let us define X to be a matrix of size N x D whose nth row is given by the vector X n x and similarly define 0 to be a matrix of size D x M whose nth row is given by the vector JE[zn]. The Estep (12.54) of the EM algorithm for PCA then becomes

$$
\Omega = (W _ { o l d } ^ { T } W _ { o l d }) ^ { - 1 } W _ { o l d } ^ { T }\widetilde { X }
$$

and the M step (12.56) takes the form

$$
W _ { n e w } =\tilde { X } ^ { T }\Omega ^ { T } (\Omega\Omega ^ { T }) ^ { - 1 }.
$$

Again these can be implemented in an on-line form. These equations have a simple interpretation as follows. From our earlier discussion, we see that the E step involves an orthogonal projection of the data points onto the current estimate for the principal subspace. Correspondingly, the M step represents a re-estimation of the principal

0 €

0

0

Fig".. 12.11 Probabilistic PCA visoo,zsbon 01 a portion 0I1he ""!low data setlo< Ihe!irsl 100 (lata »einls, The left..,...nd plot oIIOWS Ihe I'O"leoo< mean proj9c1ions oIlhfI (lata poims on lhe principal subspace. The,;gtrI·hi\nd plot is obtained by firsl ran<lomly omitting 30% 0I1he variable.aloo. and lhen us>rlg EM 10 MndIe I"" mi...... values. Note I!IaI eac/1 data poinl1hen NoS allea., one missing mea.u,ement but lhoallhe plot i. ""ry..mia, to lhe ona obtained wit"""l miss.... valL>ll$ subspace to minimize!he squared reoonslruCtioo error in 'oIhich the proje<:tion, are C.,N.

We ean gh'e a,imple physical analogy for this EM algorithm. which is easily visualized for D = 2 and M = 1. Coo,ider a collectioo nf data point',n tWI) dimension', aod let tile u""'-dimensiunal principal subspace be represented by a <ohd rod. Now atlaCh each data point to the nxI via a,pring oo<:)"ing HooI;:e', law ("umJ energy i, propol1ional 10,lie square of lile spring". length). In ll1e E 'tel', we keep the nxI hed and allow the attachment point' tn,Iide up and <I<,wn ll1e nxI '" a, to minimize ll1e e",,'llY, This cau",. each attachment point (independently) 10 position Itself at the orthogonal pmjeclion of the c~sponding data point onto the nxI. In the M 'tel'. we keep the attachment poiOl' fil<ed and then release tile nxI and allow it to m'>,'e 10 tile minimum energy posilion. 11Ie E and M 'teps are then repeated until a,uitable c""vergence cri.eri"" is..,isfled. a. is illuSlrated in Figure 12.12.

#### 12.2.3 Bayesian PCA

S<J far in OIlr di",""ioo of PeA. we have ",'.nled Ihal tile '"Ine,II for,lie dl,nen,ionalit)" of tile principal.ubspace is gi"en, In praclice. ".-e nlmt cOOose a suilable,..I"" according 10 the application. For,isuali,a,ion. we ge""",ny choose.\1 = 2. whereas for OIher application, the approrrialC choice for,1/ ma)" be less dea,. One appmao:h i. 10 pi", the eigen"alue 'peclrum for lhe data set. analog,•." 10 the example in Figure 12.4 for the off_line digits dala SCI, and look to see if lite eige",,,I.... nmurally form two groups comprising a set of,mall,'alues separated by a,ign;flcant gap from a ",t of relativel)" large,'alues, indicating a natural cholcc f<>r AI, In practice. such a gap i, oflen ''''' seen

![image 44](Bishop2006_images/imageFile44.png)

(b)

(e)

Flgu.. 12.12 Synt"'elic <lata illustrating too EM algorithm!of PCA defined by (12.58) and (1259). (8) A data set X with the data points shown in 1JI'e«l, t"ll"tM' W'i1!1l!>e t'IM pMdpal """"""",IS (shown as eigenveclor1 scaled by It>e squafll 'OOIS 04 the eigeJ'l\lllluel). (b) Initial configurat"'" 01 too principalsul>sl>a<:<t defined by W, shown in md, tOO"lhfIr with the fK'(Ijeclions 01 the latll<11 points Z inlo too <lata space, giItoo by ZW T, shown in cyan, (oj Alter""" M step, too laten! SI'B«l P>as been update<! wiIh Z r>el(l nxed. (d) Me' tt>e success.... E Slep, It>e ""'-'eo 01 Z havu been up<!atll<:1. ~ '" Ihogoooal r>rojecliQn$, with W h&k! fixed. (e) Aft.... tile se<:o<l<l M S!flp. <') After l!Ie MC()<>;l E st"l'

Be<:au,", th~ pm/xlhi li>lic PeA modd has a well·defined likelillood f"flCtion, we <wId employ cros,-,-.1idation to delermine the\"aJue of di"",nsiooa!ity by "'Iecting tit<: large,t log likelihood t>I1 a '-alidation data set Such an opprooch. hov.·~\-er. can become computationally ro<lly. p3rticularl)' if we CQnsid<:, • probabilistic miXlUre of PeA modds (Tipping and Bishop. 1999a) in "hich we seek 10 <!etermi'" the appropriate dimen,ionalily ",paraltly for toch componenl in lt1e mixm"" w.

#### S,uion I.J

Gi'-en thai ha,-e a probabilislic formulalion of PeA, il s«ms natural 10 s«k u Buye,ian approach 10 model seleclion. To do thi,.,,"'e nee<! 10 marginalize 001 the model paramele" /'.\V. und,,' wilh ""peel to appropriate prior distribution'. This Can be done by u,ing a,-ariation.l framework to.pproxim'le the allulylic.lly intractable murginaliUOi;oo, (Bi,hop. 1mb). 1lIc marginal likelihood v.lues. given by ttle,'ari.,ionallower bour.d, cun lhen be c<>mpun:d for a r.nge of different '"Tue' "f;\I ar.d Itie '"Iue giving Iht largest marginal likelihood ",Iecloo\_ l1ere we consider. simpler approach introducoo by b.ased on the rddmu "p-

Probabilistic graphical model for Bayesian peA in which the distribution over the parameter matrix W is governed by a vector a of hyperparameters.

proximation, which is appropriate when the number of data points is relatively large and the corresponding posterior distribution is tightly peaked (Bishop, 1999a). It involves a specific choice of prior over W that allows surplus dimensions in the principal subspace to be pruned out of the model. This corresponds to an example of automatic relevance determination, or ARD, discussed in Section 7.2.2. Specifically, we define an independent Gaussian prior over each column of W, which represent the vectors defining the principal subspace. Each such Gaussian has an independent variance governed by a precision hyperparameter O:i so that

$$
p (W |\alpha) =\prod _ { i = 1 } ^ { M }\left (\frac {\alpha _ { i } } { 2\pi }\right) ^ { D / 2 }\exp\left\{ -\frac { 1 } { 2 }\alpha _ { i } w _ { i } ^ { T } w _ { i }\right\}
$$

where Wi is the i th column of W. The resulting model can be represented using the directed graph shown in Figure 12.13.

The values for O:i will be found iteratively by maximizing the marginallikelihood function in which W has been integrated out. As a result of this optimization, some of the O:i may be driven to infinity, with the corresponding parameters vector Wi being driven to zero (the posterior distribution becomes a delta function at the origin) giving a sparse solution. The effective dimensionality of the principal subspace is then determined by the number of finite O:i values, and the corresponding vectors Wi can be thought of as 'relevant' for modelling the data distribution. In this way, the Bayesian approach is automatically making the trade-off between improving the fit to the data, by using a larger number of vectors Wi with their corresponding eigenvalues Ai each tuned to the data, and reducing the complexity of the model by suppressing some of the Wi vectors. The origins of this sparsity were discussed earlier in the context of relevance vector machines.

The values of O:i are re-estimated during training by maximizing the log marginal likelihood given by

$$
p (X |\alpha,\mu,\sigma ^ { 2 }) =\int p (X | W,\mu,\sigma ^ { 2 }) p (W |\alpha)\, d W
$$

where the log of p(XIW, J-L, 0'2) is given by (12.43). Note that for simplicity we also treat J-L and 0'2 as parameters to be estimated, rather than defining priors over these parameters.

Because this integration is intractable, we make use of the Laplace approximation. If we assume that the posterior distribution is sharply peaked, as will occur for sufficiently large data sets, then the re-estimation equations obtained by maximizing the marginal likelihood with respect to ai take the simple form

$$
\alpha _ { i } ^ {\text {new} } =\frac { D } { w _ { i } ^ {\text {T} } w _ { i } }
$$

which follows from (3.98), noting that the dimensionality of Wi is D. These reestimations are interleaved with the EM algorithm updates for determining Wand a 2 • The E-step equations are again given by (12.54) and (12.55). Similarly, the Mstep equation for a 2 is again given by (12.57). The only change is to the M-step equation for W, which is modified to give

$$
W _ { n e w } =\left [\sum _ { n = 1 } ^ { N } (x _ { n } -\overline { x })\mathbb { E } [z _ { n }] ^ {\intercal }\right]\left [\sum _ { n = 1 } ^ { N }\mathbb { E } [z _ { n } z _ { n } ^ {\intercal }] +\sigma ^ { 2 } A\right] ^ { - 1 }\quad (1 2. 6 3)
$$

where A = diag(ai)' The value of I-" is given by the sample mean, as before.

If we choose M = D 1 then, if all ai values are finite, the model represents a full-covariance Gaussian, while if all the ai go to infinity the model is equivalent to an isotropic Gaussian, and so the model can encompass all pennissible values for the effective dimensionality of the principal subspace. It is also possible to consider smaller values of M, which will save on computational cost but which will limit the maximum dimensionality of the subspace. A comparison of the results of this algorithm with standard probabilistic PCA is shown in Figure 12.14.

Bayesian PCA provides an opportunity to illustrate the Gibbs sampling algorithm discussed in Section 11.3. Figure 12.15 shows an example of the samples from the hyperparameters In ai for a data set in D = 4 dimensions in which the dimensionality of the latent space is M = 3 but in which the data set is generated from a probabilistic PCA model having one direction of high variance, with the remaining directions comprising low variance noise. This result shows clearly the presence of three distinct modes in the posterior distribution. At each step of the iteration, one of the hyperparameters has a small value and the remaining two have large values, so that two of the three latent variables are suppressed. During the course of the Gibbs sampling, the solution makes sharp transitions between the three modes.

The model described here involves a prior only over the matrix W. A fully Bayesian treatment of PCA, including priors over 1-", a 2, and n, and solved using variational methods, is described in Bishop (1999b). For a discussion of various Bayesian approaches to detennining the appropriate dimensionality for a PCA model, see Minka (2001c).

#### 12.2.4 Factor analysis

Factor analysis is a linear-Gaussian latent variable model that is closely related to probabilistic PCA. Its definition differs from that of probabilistic PCA only in that the conditional distribution of the observed variable x given the latent variable z is

•

•

•

••

•

•

•

••

•

•

•

•

•

•

•

•

•

•

•

•

•

•

•

•

•

•

••

•

•

•

•

•

•

•

•

•

•

•

• • • • • • • • • • Figure 12.14 'Hinloo' diagrams of the matrix W in which each element 01 the matrix is depicted as a square (white lor positive and black lor negative values) whose area is proportional to the magnitude of that element. The synthetic data sel comprises 300 data points in D = 10 dimensions sampled from a Gaussian distribution having standard deviation 1.0 in 3 directions and standard deviation 0.5 in the remaining 7 directions for a data set in D = 10 dimensions having AT = 3 directions with larger variance than the remaining 7 directions. The left-hand plol shows the result Irom maximum likelihood probabilistic PCA, and the left·hand plot shows the corresponding resuft from Bayesian peA. We see how the Bayesian model is able to discover the appropriate dimensionality by suppressing the 6 surplus degrees of freedom.

taken to have a diagonal rather than an isotropic covariance so that

$$
p (x | z) =\mathcal { N } (x | W z +\mu,\Psi)
$$

where ill is a D x D diagonal matrix. Note that the factor analysis model, in common with probabilistic PCA. assumes that the observed variables Xl,...,Xo are independent. given the latent variable z. In essence. the factor analysis model is explaining the observed covariance structure of the data by representing the independent variance associated with each coordinate in the matrix 1J.' and capturing the covariance between variables in the matrix W. In the factor analysis literature. the columns of W. which capture the correlations between observed variables. are calledfaclOr loadings. and the diagonal elements of 1J.'. which represent the independent noise variances for each of the variables, are called llniqllenesses.

The origins of factor analysis are as old as those of PCA. and discussions of factor analysis can be found in the books by Everitt (1984). Bartholomew (1987), and Basilevsky (1994). Links between factor analysis and PCA were investigated by Lilwley (1953) and Anderson (1963) who showed that at stationary points of the likelihood function. for a faclOr analysis model with 1J.' = (121, the columns of W are scaled eigenvectors of the sample covariance matrix. and (12 is the average of the discarded eigenvalues. Later. Tipping and Bishop (1999b) showed that the maximum of the log likelihood function occurs when the eigenvectors comprising Ware chosen to be the principal eigenvectors.

Making use of (2.115). we see that the marginal distribution for the observed

FllIure12.15

Gillbs.,,,,>p!j"lllo< Bay<lslan PCA sh<Ming plots oj Ino, versus ~eralion number br three " values. showing tr"""tions betw..... tbe th"'" moOts <A!he posterior distribution.

10

10

5

10

S"na" 12.4

,-"riabl, i' gi,-,n by 1'(x) ~ N(Xlj', C) whe... now

$$
C = W W ^ { T } +\Psi.
$$

As with probabilistic PC A, thi, moMI is im-"ri.rrl to 'Olalions in 11><0 latent 'pace.

Histoocally, factor anal)',;s has been lhe,ubjerl of cOl1tro,-ersy wroe" a!tempt< h",-e bttn "'a<k: to place an intc'P"'t"lioo on the ind;vidual faclon (the cOOfdinates in z_space). which h3.\ pm"en problematic due to lr.e """i<lcmifiabilily of factOf analysis associmed with Mation' in this 'pace. From oor perspeoh-e, howe,-er. we shall.iew factor analysis as a form of lalent "ariable densily model. in which the form of tl>c lalent 'pace i' of interest but nO! the particular choicc of coordinates used to descrit>c il. If we wish to remove the degeneracy a'sociated with latent 'pace roIations. ""e mu,t con'ider non-Gaussian latent,-"riable di'tribution,. gi"irrg rise 10 independent component.n.lysi, (lCA) models.

We can detenni"e the parameters I'.\V. "nd.... in the fac!Of an.ly,i, model by muimum likelihood. 11.. solution for I' i' ag"in given by the ",,,,pie "'ean. How· eyC'. "nli~e probabili,tic l'CA.lllcre i' no longer a closed-form maximum likelihood solution for\V. ",'hich mu.\ltherdorc be found i'er.li,'c1)'\_ Because faclor anal)',i. is a latent variable modeL thi' can be don. using an EM algorilhm (R.bin and Thayer. 1982)!h"t is "nalogou, to the one used (Of pml>;lbili.tie PeA. Specihcally. lhe E-'lep eqnJtioo, are g;'-en by

$$
\mathbb { E } [z _ { n }]\, =\, G W ^ {\dagger }\Psi ^ { - 1 } (x _ { n } -\bar { x })
$$

$$
\mathbb { E } [z _ { n } z _ { n } ^ { T }]\ =\ G +\mathbb { E } [z _ { n }]\mathbb { E } [z _ { n }] ^ { T }
$$

where ""e h",'e defi""d

$$
(1 2. 6 8)
$$

NOie th"t thi' i' e.pre,<ed in a for'" thai in,-oh'es inycrsi"n of mal rices "f SilO,\ I x,If rathe'lhan D x D (ex"",,,, for tbe D x D diagooal matrix oJ' "'hose in,-erse i.' 'ri"ial

Exercise 12.25 to compute in O(D) steps), which is convenient because often M « D. Similarly, the M-step equations take the form

$$
W ^ { n }\ =\\left [\sum _ { n = 1 } ^ { N } (x _ { n } -\overline { x })\mathbb { E } [z _ { n }] ^ { T }\right]\left [\sum _ { n = 1 } ^ { N }\mathbb { E } [z _ { n } z _ { n } ^ { T }]\right] ^ { - 1 }\quad (1 2. 6)
$$

$$
\Psi ^ { n e w }\ =\ d i a g\left\{ S - W _ { n e w }\frac { 1 } {\overline { N } }\sum _ { n = 1 } ^ { N }\mathbb { E } [z _ { n }] (x _ { n } -\overline { x }) ^ { T }\right\}\quad (1 2. 7 0)
$$

where the 'diag' operator sets all of the nondiagonal elements of a matrix to zero. A Bayesian treatment of the factor analysis model can be obtained by a straightforward application of the techniques discussed in this book.

Another difference between probabilistic PCA and factor analysis concerns their different behaviour under transformations of the data set. For PCA and probabilistic PCA, if we rotate the coordinate system in data space, then we obtain exactly the same fit to the data but with the W matrix transformed by the corresponding rotation matrix. However, for factor analysis, the analogous property is that if we make a component-wise re-scaling of the data vectors, then this is absorbed into a corresponding re-scaling of the elements of\)i.

12.3 Kernel peA

In Chapter 6, we saw how the technique of kernel substitution allows us to take an algorithm expressed in terms of scalar products of the form x T x' and generalize that algorithm by replacing the scalar products with a nonlinear kernel. Here we apply this technique of kernel substitution to principal component analysis, thereby obtaining a nonlinear generalization called kernel peA (Scholkopf et al., 1998).

Consider a data set {x n } of observations, where n = 1,..., N, in a space of dimensionality D. In order to keep the notation uncluttered, we shall assume that we have already subtracted the sample mean from each of the vectors X n, so that Ln X n = O. The first step is to express conventional PCA in such a form that the data vectors {x n } appear only in the form of the scalar products x~ X m. Recall that the principal components are defined by the eigenvectors Ui of the covariance matrix

$$
\text {Su} _ { i } =\lambda _ { i }\mathbf u _ { i }
$$

where i = 1,...,D. Here the D x D sample covariance matrix S is defined by

$$
S =\frac { 1 } { N }\sum _ { n = 1 } ^ { N } x _ { n } x _ { n } ^ { T },
$$

and the eigenvectors are normalized such that uT Ui = 1. Now consider a nonlinear transformation ¢(x) into an M -dimensional feature space, so that each data point X n is thereby projected onto a point ¢(x n). We can '\

...

Figu'.12.16 SctIematic _,.lion 01 kernel PeA. A <Utll HI In lhe Oflglnal <Uta space l~'_ plot}.. PfOlEled by' """'*tranllklfmalion ~,,} 1nIo. fa.tur. space (fIght\_ plot). By I*b'~ PCA in the!Hue 111**. we oblaO'Ilha pmeiIlaI ~"llS. "'who<:tllha tnt Ie......... in blUe.,..,.. oJano4ed by lha * v, Tha gr-..... In IMIuN apam indicMa Iha * plOlKlio". onIO lhe Iirsl poiridl* '"""......... 11. """'*'\_od 110 ""'\*poOf&Cllu. in.... <lfisIonaI Oillll 111**. Hole IIuIIIn gMefM' la nol pox '.. 110 '...... 1ha,... iIio\_ poi........ 00i'........ by.\_1n "apam.

\__ ptrform)l-.bnl PeA ill fnlllK lopICe...-Iudl,mpIiclIly «lIi'Il'S • -'_ prinClpaI....-.. model ill onpnll cbuo ~ as,1lU>tr\*d in FllIft 12-16.

Fu "IO.. It.. lei '" lOS!oUlllt 1Nl Illt ~ diu. ~ lObo halnro mean, jI)!hal L. 4>("'. J.. O. We dWl rctlll'1l 10 Itl,~ pol'".Ihonly. 1llt.1f ".If "'"""_ CO\-.ullCC mMfU,n (~.If_'e,~ l"" by,

$$
\text {in feature space is given by}\\ C =\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\phi (x _ { n })\phi (x _ { n }) ^ { T } & & (1 2. 7 3)\\\text {for expansion is defined by}
$$

and,l~ ",,,,n'"MOl" opan,ion i' «lined by

$$
C v _ { i } =\lambda _ { i } v _ { i }
$$

; = 1...,. M. Our goal is 10 soh'" lhis eigen"lIlue problem WilhoUl ha"inlllO work."plici,ly in,he f.lIture 'pace. From!he definilion of C. lhe.ill"""""l"'" equal ions lell' U, thaI Y,!-ali,fies.

$$
O\text { gain is to solve eigenvalue problem without having to work}\\\text {feature space. From the definition of $C$, the eigenvector equations}\\\text {satisfies}\\\intertext { t a s i f i s }\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\phi (x _ { n })\left\{\phi (x _ { n }) ^ { T } v _ { i }\right\} =\lambda _ { i } v _ { i }\quad (1 2. 7 5)\\\text {that (provided $\lambda_{i}>0$) the vector $v_{i}$ is given by a linear combination}
$$

..........-".lN1 (proo.idcd A, > 0) tilt "CC'lor v, is li''n by • Ii\_ rombllla"on of Illt d>(J..... JO <;.he "-"llm iIllhc (orm,

$$
n\,\text {be written in the form}\\ v _ { i } =\sum _ { n = 1 } ^ { N } a _ { i n }\phi (x _ { n }).
$$

Exercise 12.26

Substituting this expansion back into the eigenvector equation, we obtain

$$
\frac { 1 } { N }\sum _ { n = 1 } ^ { N }\phi (x _ { n })\phi (x _ { n }) ^ { T }\sum _ { m = 1 } ^ { N } a _ { i m }\phi (x _ { m }) =\lambda _ { i }\sum _ { n = 1 } ^ { N } a _ { i n }\phi (x _ { n }).
$$

The key step is now to express this in terms of the kernel function k (x n, x m) = ¢(Xn)T ¢(x m), which we do by multiplying both sides by ¢(xZ)T to give

$$
\frac { 1 } { N }\sum _ { n = 1 } ^ { N } k (x _ { l }, x _ { n })\sum _ { m = 1 } ^ { m } a _ { i m } k (x _ { n }, x _ { m }) =\lambda _ { i }\sum _ { n = 1 } ^ { N } a _ { i n } k (x _ { l }, x _ { n }).
$$

This can be written in matrix notation as

$$
K ^ { 2 } a _ { i } =\lambda _ { i } N K a _ { i }
$$

where ai is an N-dimensional column vector with elements ani for n = 1,...,N. We can find solutions for ai by solving the following eigenvalue problem

$$
K a _ { i } =\lambda _ { i } N a _ { i }
$$

in which we have removed a factor of K from both sides of (12.79). Note that the solutions of (12.79) and (12.80) differ only by eigenvectors of K having zero eigenvalues that do not affect the principal components projection.

The normalization condition for the coefficients ai is obtained by requiring that the eigenvectors in feature space be normalized. Using (12.76) and (12.80), we have

$$
1 = v _ { i } ^ { T } v _ { i } =\sum _ { n = 1 } ^ { N }\sum _ { m = 1 } ^ { N } a _ { i n } a _ { i m }\phi (x _ { n }) ^ { T }\phi (x _ { m }) = a _ { i } ^ { T } K a _ { i } =\lambda _ { i } N a _ { i } ^ { T } a _ { i }.\quad (1 2. 8 1)
$$

Having solved the eigenvector problem, the resulting principal component projections can then also be cast in terms of the kernel function so that, using (12.76), the projection of a point x onto eigenvector i is given by

$$
y _ { i } (x) =\phi (x) ^ {\top } v _ { i } =\sum _ { n = 1 } ^ { N } a _ { i n }\phi (x) ^ {\top }\phi (x _ { n }) =\sum _ { n = 1 } ^ { N } a _ { i n } k (x, x _ { n })
$$

and so again is expressed in terms of the kernel function.

In the original D-dimensional x space there are D orthogonal eigenvectors and hence we can find at most D linear principal components. The dimensionality M of the feature space, however, can be much larger than D (even infinite), and thus we can find a number of nonlinear principal components that can exceed D. Note, however, that the number of nonzero eigenvalues cannot exceed the number N of data points, because (even if M > N) the covariance matrix in feature space has rank at most equal to N. This is reflected in the fact that kernel PCA involves the eigenvector expansion of the N x N matrix K.

Exercise 12.27

So far we have assumed that the projected data set given by ¢(x n) has zero mean, which in general will not be the case. We cannot simply compute and then subtract off the mean, since we wish to avoid working directly in feature space, and so again, we formulate the algorithm purely in-!erms of the kernel function. The projected data points after centralizing, denoted ¢(x n), are given by

$$
\widetilde {\phi } (x _ { n }) =\phi (x _ { n }) -\frac { 1 } { N }\sum _ { l = 1 } ^ { N }\phi (x _ { l })
$$

and the corresponding elements of the Gram matrix are given by

$$
and the corresponding elements of the Gram matrix are given by\\ &\widetilde { K } _ { n m }\ =\\widetilde {\phi } (x _ { n }) ^ { T }\widetilde {\phi } (x _ { m })\\ & =\\phi (x _ { n }) ^ { T }\phi (x _ { m }) -\frac { 1 } { N }\sum _ { l = 1 } ^ { N }\phi (x _ { n }) ^ { T }\phi (x _ { l })\\ & -\frac { 1 } { N }\sum _ { l = 1 } ^ { N }\phi (x _ { l }) ^ { T }\phi (x _ { m }) +\frac { 1 } { N ^ { 2 } }\sum _ { j = 1 } ^ { N }\sum _ { l = 1 } ^ { N }\phi (x _ { j }) ^ { T }\phi (x _ { l })\\ & =\ k (x _ { n }, x _ { m }) -\frac { 1 } { N }\sum _ { l = 1 } ^ { N } k (x _ { l }, x _ { m })\\ & -\frac { 1 } { N }\sum _ { l = 1 } ^ { N } k (x _ { n }, x _ { l }) +\frac { 1 } { N ^ { 2 } }\sum _ { j = 1 } ^ { N }\sum _ { l = 1 } ^ { N } k (x _ { j }, x _ { l }).\\\intertext { This can be expressed in matrix notation as }
$$

This can be expressed in matrix notation as

$$
(1 2. 8 5)
$$

where IN denotes the N x N matrix in which every element takes the value l/N. ~ ~ Thus we can evaluate K using only the kernel function and then use K to determine the eigenvalues and eigenvectors. Note that the standard PCA algorithm is recovered as a special case if we use a linear kernel k(x, x') = xTx/. Figure 12.17 shows an example of kernel PCA applied to a synthetic data set (Scholkopf et al., 1998). Here a 'Gaussian' kernel of the form

$$
k (x, x ^ {\prime }) =\exp (-\| x - x ^ {\prime }\| ^ { 2 } / 0. 1)
$$

is applied to a synthetic data set. The lines correspond to contours along which the projection onto the corresponding principal component, defined by is constant.

$$
\phi (x) ^ { T } v _ { i } =\sum _ { n = 1 } ^ { N } a _ { i n } k (x, x _ { n })
$$

\_.

Eigervale-2.53

Figure 12.11 E"llmple 01 kernel PCA, with a Gaussian kernel awIiOO 10 a synthetic <lata sat in two <:Iirnensions, showing!he firsl flight eigenfunclions along w~h l!>eir e9tnvailNls. The oootours am lines along which!he projoc1ion onlo t"" COffaspMding principal componen1ls co<>stam, Nola haw Ihe firsl two ~....,..rat.!he th"'" dusters.!he ""'" Ill"'" ~ spIiI ""'\*' oIlhe eluste, into haMoS. and t"" lolIowing Ihree ~ again spI~!he duste," into halves along directions orthogonal 10 tho prEMouS splils,

One obvioo' dls.aJmota~e of I:emel!'CA Is thaf if invoh'es finding lhe elgen"e<tors of the N x N malri>: K raW. Ihan lhe D x D malri, S of cor,..emionallinear!'CA. and!iO In prac1lce for large data "'1' appro,lmation< are often uS(:d

Finally. ""e OOIe that i" <tandard linear I'CA, we often retain some redoce<l num· ber L < Dof eigenvectors and then appro,lmale 0 data vttl<:>r X n b}' its projection i~ 0,,1" lhe L-dimensional principal subspace, defined by

$$
\text {local principal subspace, defined by}\\\widehat { x } _ { n } =\sum _ { i = 1 } ^ { L }\left (x _ { n } ^ { T } u _ { i }\right) u _ { i }.
$$

I" kernell'CA. this will in gencr~1 not be flO'slble, To see thl', OOIe Ihat the mapping 4'(x) maps the D-dimensional x space i"t" 0 D-dimensioo.l manijQiII in lhe M-dimemioo.l femure space <1>. TlIe:.'ector x i' koown a< lhe f'",.imagr of lhe c","""ponding poi"l 4'(x). However, fhe projec1ioo of poinl> in feature <J'3C" ""to the linear rcA,ub,p""" in that 'pace will typically"''' lie On fhe nonlinear Ddimensional manifold and!iO will nul ha.,. a c"""",pondlng p",.lmo~e in dOlO spa<."C, Technlque< ho.-e lherefore bttn proposed for finding approximale pre-image< iB""lr Nat.. 2(04).

### 12.4 Nonlinear Latent Variable Models

Exercise 12.28

In this chapter, we have focussed on the simplest class of models having continuous latent variables, namely those based on linear-Gaussian distributions. As well as having great practical importance, these models are relatively easy to analyse and to fit to data and can also be used as components in more complex models. Here we consider briefly some generalizations of this framework to models that are either nonlinear or non-Gaussian, or both.

In fact, the issues of nonlinearity and non-Gaussianity are related because a general probability density can be obtained from a simple fixed reference density, such as a Gaussian, by making a nonlinear change of variables. This idea forms the basis of several practical latent variable models as we shall see shortly.

#### 12.4.1 Independent component analysis

We begin by considering models in which the observed variables are related linearly to the latent variables, but for which the latent distribution is non-Gaussian. An important class of such models, known as independent component analysis, or leA, arises when we consider a distribution over the latent variables that factorizes, so that M

$$
p (z) =\prod _ { j = 1 } ^ { M } p (z _ { j }).
$$

To understand the role of such models, consider a situation in which two people are talking at the same time, and we record their voices using two microphones. If we ignore effects such as time delay and echoes, then the signals received by the microphones at any point in time will be given by linear combinations of the amplitudes of the two voices. The coefficients of this linear combination will be constant, and if we can infer their values from sample data, then we can invert the mixing process (assuming it is nonsingular) and thereby obtain two clean signals each of which contains the voice of just one person. This is an example of a problem called blind source separation in which 'blind' refers to the fact that we are given only the mixed data, and neither the original sources nor the mixing coefficients are observed (Cardoso, 1998).

This type of problem is sometimes addressed using the following approach (MacKay, 2003) in which we ignore the temporal nature of the signals and treat the successive samples as i.i.d. We consider a generative model in which there are two latent variables corresponding to the unobserved speech signal amplitudes, and there are two observed variables given by the signal values at the microphones. The latent variables have a joint distribution that factorizes as above, and the observed variables are given by a linear combination of the latent variables. There is no need to include a noise distribution because the number of latent variables equals the number of observed variables, and therefore the marginal distribution of the observed variables will not in general be singular, so the observed variables are simply deterministic linear combinations of the latent variables. Given a data set of observations, the likelihood function for this model is a function of the coefficients in the linear combination. The log likelihood can be maximized using gradient-based optimization giving rise to a particular version of independent component analysis.

The success of this approach requires that the latent variables have non-Gaussian distributions. To see this, recall that in probabilistic PCA (and in factor analysis) the latent-space distribution is given by a zero-mean isotropic Gaussian. The model therefore cannot distinguish between two different choices for the latent variables where these differ simply by a rotation in latent space. This can be verified directly by noting that the marginal density (12.35), and hence the likelihood function, is unchanged if we make the transformation W -) WR where R is an orthogonal matrix satisfying RR T = I, because the matrix C given by (12.36) is itself invariant. Extending the model to allow more general Gaussian latent distributions does not change this conclusion because, as we have seen, such a model is equivalent to the zero-mean isotropic Gaussian latent variable model.

Another way to see why a Gaussian latent variable distribution in a linear model is insufficient to find independent components is to note that the principal components represent a rotation of the coordinate system in data space such as to diagonalize the covariance matrix, so that the data distribution in the new coordinates is then uncorrelated. Although zero correlation is a necessary condition for independence it is not, however, sufficient. In practice, a common choice for the latent-variable distribution is given by

$$
p (z _ { j }) =\frac { 1 } {\pi\cosh (z _ { j }) } =\frac { 1 } {\pi (e ^ { z _ { j } } + e ^ { - z _ { j } }) }
$$

which has heavy tails compared to a Gaussian, reflecting the observation that many real-world distributions also exhibit this property.

The original ICA model (Bell and Sejnowski, 1995) was based on the optimization of an objective function defined by information maximization. One advantage of a probabilistic latent variable formulation is that it helps to motivate and formulate generalizations of basic ICA. For instance, independent factor analysis (Attias, 1999a) considers a model in which the number of latent and observed variables can differ, the observed variables are noisy, and the individual latent variables have flexible distributions modelled by mixtures of Gaussians. The log likelihood for this model is maximized using EM, and the reconstruction of the latent variables is approximated using a variational approach. Many other types of model have been considered, and there is now a huge literature on ICA and its applications (Jutten and Herault, 1991; Comon et at., 1991; Amari et at., 1996; Pearlmutter and Parra, 1997; Hyvarinen and Oja, 1997; Hinton et at., 2001; Miskin and MacKay, 2001; Hojen-Sorensen et at., 2002; Choudrey and Roberts, 2003; Chan et at., 2003; Stone, 2004).

#### 12.4.2 Autoassociative neural networks

In Chapter 5 we considered neural networks in the context of supervised learn­ ing, where the role of the network is to predict the output variables given values for the input variables. However, neural networks have also been applied to un­ supervised learning where they have been used for dimensionality reduction. This is achieved by using a network having the same number of outputs as inputs, and optimizing the weights so as to minimize some measure of the reconstruction error between inputs and outputs with respect to a set of training data.

Figure 12.18 An autoassociative mUltilayer perceptron having two layers of weights. Such a network is trained to map input vectors onto themselves by minimization ot a sum-ot-squares error. Even with nonlinear units in the hidden layer, such a network is equivalent to linear principal component analysis. Links representing bias parameters have been omitted for clarity.

inputs

11 outputs

11

Consider first a multilayer perceptron of the form shown in Figure 12.18, having D inputs, D output units and M hidden units, with M < D. The targets used to train the network are simply the input vectors themselves, so that the network is attempting to map each input vector onto itself. Such a network is said to form an autoassociative mapping. Since the number of hidden units is smaller than the number of inputs, a perfect reconstruction of all input vectors is not in general possible. We therefore determine the network parameters w by minimizing an error function which captures the degree of mismatch between the input vectors and their reconstructions. In particular, we shall choose a sum-of-squares error of the form

$$
E (w) =\frac { 1 } { 2 }\sum _ { n = 1 } ^ { N }\| y (x _ { n }, w) - x _ { n }\| ^ { 2 }.
$$

If the hidden units have linear activations functions, then it can be shown that the error function has a unique global minimum, and that at this minimum the network performs a projection onto the M -dimensional subspace which is spanned by the first M principal components of the data (Bourlard and Kamp, 1988; Baldi and Hornik, 1989). Thus, the vectors of weights which lead into the hidden units in Figure 12.18 form a basis set which spans the principal subspace. Note, however, that these vectors need not be orthogonal or normalized. This result is unsurprising, since both principal component analysis and the neural network are using linear dimensionality reduction and are minimizing the same sum-of-squares error function.

It might be thought that the limitations of a linear dimensionality reduction could be overcome by using nonlinear (sigmoidal) activation functions for the hidden units in the network in Figure 12.18. However, even with nonlinear hidden units, the minimum error solution is again given by the projection onto the principal component subspace (Bourlard and Kamp, 1988). There is therefore no advantage in using twolayer neural networks to perform dimensionality reduction. Standard techniques for principal component analysis (based on singular value decomposition) are guaranteed to give the correct solution in finite time, and they also generate an ordered set of eigenvalues with corresponding orthonormal eigenvectors.

Figure 12.19 Addition of extra hidden layers of noolinear units gives an auloassocialive network which can perform a noolinear dimensiooality reduction.

inputs

F,

•

F,

• outputs x, non-linear x,

X3

The situation is different, however. if additional hidden layers are pcrmillcd in the network. Consider the four-layer autoassociativc network shown in Figure 12.19. Again the output units are linear, and the M units in the second hidden layer can also be linear. however, the first and third hidden layers have sigmoidal nonlinear activation functions. The network is again trained by minimization of the error function (12.91). We can view this network as two successive functional mappings F] and F 2, as indicated in Figure 12.19. The first mapping F] projects the original Ddimensional data onto an AI-dimensional subspace S defined by the activations of the units in the second hidden layer. Because of the presence of the first hidden layer of nonlinear units. this mapping is very general. and in particular is not restricted to being linear. Similarly. the second half of the network defines an arbitrary functional mapping from the M -dimensional space back into the original D-dimensional input space. This has a simple geometrical interpretation. as indicated for the case D = 3 and M = 2 in Figure 12.20.

Such a network effectively perfonns a nonlinear principal component analysis.

•

F, "

F2

13 x, "

12

12

Figure 12.20 Geometrical interpretation of the mappings performed by the network in Figure 12.1 g for the case of 0 = 3 inputs and AI = 2 units in the middle hidden layer. The function F, maps from an M-dimensional space S into a D-dimensiooal space and therefore defines the way in which the space S is embedded within the original x-space. Since the mapping F, can be r"I()(llinear, the embedding 01 S can be nonplanar, as indicated in the figure. The mapping F. then defines a projectiorl of points in the original D-dimensional space into the M -dimensional subspace S.

It has the advantage of not being limited to linear transformations, although it contains standard principal component analysis as a special case. However, training the network now involves a nonlinear optimization problem, since the error function (12.91) is no longer a quadratic function of the network parameters. Computationally intensive nonlinear optimization techniques must be used, and there is the risk of finding a suboptimal local minimum of the error function. Also, the dimensionality of the subspace must be specified before training the network.

#### 12.4.3 Modelling nonlinear manifolds

As we have already noted, many natural sources of data correspond to lowdimensional, possibly noisy, nonlinear manifolds embedded within the higher dimensional observed data space. Capturing this property explicitly can lead to improved density modelling compared with more general methods. Here we consider briefly a range of techniques that attempt to do this.

One way to model the nonlinear structure is through a combination of linear models, so that we make a piece-wise linear approximation to the manifold. This can be obtained, for instance, by using a clustering technique such as K -means based on Euclidean distance to partition the data set into local groups with standard PCA applied to each group. A better approach is to use the reconstruction error for cluster assignment (Kambhatla and Leen, 1997; Hinton et al., 1997) as then a common cost function is being optimized in each stage. However, these approaches still suffer from limitations due to the absence of an overall density model. By using probabilistic PCA it is straightforward to define a fully probabilistic model simply by considering a mixture distribution in which the components are probabilistic PCA models (Tipping and Bishop, 1999a). Such a model has both discrete latent variables, corresponding to the discrete mixture, as well as continuous latent variables, and the likelihood function can be maximized using the EM algorithm. A fully Bayesian treatment, based on variational inference (Bishop and Winn, 2000), allows the number of components in the mixture, as well as the effective dimensionalities of the individual models, to be inferred from the data. There are many variants of this model in which parameters such as the W matrix or the noise variances are tied across components in the mixture, or in which the isotropic noise distributions are replaced by diagonal ones, giving rise to a mixture of factor analysers (Ghahramani and Hinton, 1996a; Ghahramani and Beal, 2000). The mixture of probabilistic PCA models can also be extended hierarchically to produce an interactive data visualization algorithm (Bishop and Tipping, 1998).

An alternative to considering a mixture of linear models is to consider a single nonlinear model. Recall that conventional PCA finds a linear subspace that passes close to the data in a least-squares sense. This concept can be extended to onedimensional nonlinear surfaces in the form of principal curves (Hastie and Stuetzle, 1989). We can describe a curve in a D-dimensional data space using a vector-valued function f ().), which is a vector each of whose elements is a function of the scalar).. There are many possible ways to parameterize the curve, of which a natural choice is the arc length along the curve. For any given point x in data space, we can find the point on the curve that is closest in Euclidean distance. We denote this point by

> .. = gf(X) because it depends on the particular curve f(>"). For a continuous data density p(x), a principal curve is defined as one for which every point on the curve is the mean of all those points in data space that project to it, so that

$$
\mathbb { E }\left [x | g _ { f } (x) =\lambda\right] = f (\lambda).
$$

For a given continuous density, there can be many principal curves. In practice, we are interested in finite data sets, and we also wish to restrict attention to smooth curves. Hastie and Stuetzle (1989) propose a two-stage iterative procedure for finding such principal curves, somewhat reminiscent of the EM algorithm for PCA. The curve is initialized using the first principal component, and then the algorithm alternates between a data projection step and curve re-estimation step. In the projection step, each data point is assigned to a value of >.. corresponding to the closest point on the curve. Then in the re-estimation step, each point on the curve is given by a weighted average of those points that project to nearby points on the curve, with points closest on the curve given the greatest weight. In the case where the subspace is constrained to be linear, the procedure converges to the first principal component and is equivalent to the power method for finding the largest eigenvector of the covariance matrix. Principal curves can be generalized to multidimensional manifolds called principal surfaces although these have found limited use due to the difficulty of data smoothing in higher dimensions even for two-dimensional manifolds.

PCA is often used to project a data set onto a lower-dimensional space, for example two dimensional, for the purposes of visualization. Another linear technique with a similar aim is multidimensional scaling, or MDS (Cox and Cox, 2000). It finds a low-dimensional projection of the data such as to preserve, as closely as possible, the pairwise distances between data points, and involves finding the eigenvectors of the distance matrix. In the case where the distances are Euclidean, it gives equivalent results to PCA. The MDS concept can be extended to a wide variety of data types specified in terms of a similarity matrix, giving nonmetric MDS.

Two other nonprobabilistic methods for dimensionality reduction and data visualization are worthy of mention. Locally linear embedding, or LLE (Roweis and Saul, 2000) first computes the set of coefficients that best reconstructs each data point from its neighbours. These coefficients are arranged to be invariant to rotations, translations, and scalings of that data point and its neighbours, and hence they characterize the local geometrical properties of the neighbourhood. LLE then maps the high-dimensional data points down to a lower dimensional space while preserving these neighbourhood coefficients. If the local neighbourhood for a particular data point can be considered linear, then the transformation can be achieved using a combination of translation, rotation, and scaling, such as to preserve the angles formed between the data points and their neighbours. Because the weights are invariant to these transformations, we expect the same weight values to reconstruct the data points in the low-dimensional space as in the high-dimensional data space. In spite of the nonlinearity, the optimization for LLE does not exhibit local minima.

In isometric feature mapping, or isomap (Tenenbaum et ai., 2000), the goal is to project the data to a lower-dimensional space using MDS, but where the dissimilarities are defined in terms of the geodesic distances measured along the mani-

Chapter JJ fold. For instance, if two points lie on a circle, then the geodesic is the arc-length distance measured around the circumference of the circle not the straight line distance measured along the chord connecting them. The algorithm first defines the neighbourhood for each data point, either by finding the K nearest neighbours or by finding all points within a sphere of radius E. A graph is then constructed by linking all neighbouring points and labelling them with their Euclidean distance. The geodesic distance between any pair of points is then approximated by the sum of the arc lengths along the shortest path connecting them (which itself is found using standard algorithms). Finally, metric MDS is applied to the geodesic distance matrix to find the low-dimensional projection.

Our focus in this chapter has been on models for which the observed variables are continuous. We can also consider models having continuous latent variables together with discrete observed variables, giving rise to latent trait models (Bartholomew, 1987). In this case, the marginalization over the continuous latent variables, even for a linear relationship between latent and observed variables, cannot be performed analytically, and so more sophisticated techniques are required. Tipping (1999) uses variational inference in a model with a two-dimensional latent space, allowing a binary data set to be visualized analogously to the use of PCA to visualize continuous data. Note that this model is the dual of the Bayesian logistic regression problem discussed in Section 4.5. In the case of logistic regression we have N observations of the feature vector <l>n which are parameterized by a single parameter vector w, whereas in the latent space visualization model there is a single latent space variable x (analogous to <1» and N copies of the latent variable W n. A generalization of probabilistic latent variable models to general exponential family distributions is described in Collins et al. (2002).

We have already noted that an arbitrary distribution can be formed by taking a Gaussian random variable and transforming it through a suitable nonlinearity. This is exploited in a general latent variable model called a density network (MacKay, 1995; MacKay and Gibbs, 1999) in which the nonlinear function is governed by a multilayered neural network. If the network has enough hidden units, it can approximate a given nonlinear function to any desired accuracy. The downside of having such a flexible model is that the marginalization over the latent variables, required in order to obtain the likelihood function, is no longer analytically tractable. Instead, the likelihood is approximated using Monte Carlo techniques by drawing samples from the Gaussian prior. The marginalization over the latent variables then becomes a simple sum with one term for each sample. However, because a large number of sample points may be required in order to give an accurate representation of the marginal, this procedure can be computationally costly.

If we consider more restricted forms for the nonlinear function, and make an appropriate choice of the latent variable distribution, then we can construct a latent variable model that is both nonlinear and efficient to train. The generative topographic mapping, or GTM (Bishop et aI., 1996; Bishop et aI., 1997a; Bishop et aI., 1998b) uses a latent distribution that is defined by a finite regular grid of delta functions over the (typically two-dimensional) latent space. Marginalization over the latent space then simply involves summing over the contributions from each of the grid locations.

8

.•. '"

'"

FllIu.e 12.21?lot ot trle oillkYw <:lata Wllisualiz.ed using PeA on the left and GTM on Itle ngr,t FOf tile GTM model. each <lata poinIls plollfld at tile mean ot its posM'k>< dislribution in.. tent s;>ace, Tile "","ineanty mlhe GTM 1TlOd8I.\_lha sepamlion betwoon the groups of data points to be.....n """. ckl.arfy,

Ch"l'l~f j

S~etioo /.4

The no"liotar mapping is gi,'en by a linear regression model thaI allow, for general IIO/llinearily while being a linear fuoction of tile adapli'-e parameler<, NOIe thaI tilt usual limitation of linear regression models arising from the en"", of dimen,iooalily does 1101 arise in the Contr~1 of lhe GT~I si""'e the "\3nifold generall)' ha< t,,'o di"ltn· sions irrespecti'-e of the dimensionality of the data space, A coo""!",,nce of Illese 11"0 cooices is that the likelihood funclion can be e~pressed analytically in dosed form and can be optimilC<.! efficiently o,ing the EM algorithm\_ The resolting GTM model hIs a lwo-dimensional nonlinear manifold 10 tile dala sel. and by e"alualing the posterior distrilJ",lion (Wer latent space for the data poi"", they can he projectt<J back to the lalent 'JI'K'" for.'isualilalion purposes, Figure 12,21 sl"""s a comparison of the oil data..,1 "isualired wilh lincar PeA and wilh lhe IIO/lhnear GT~I, '''If

TIlt GTM can be seen as a probabilistic "'rsion of an earlier nlOd<l callM the org"nidng ""'p. or SOM (Kohonen. 1982: Kobonen. (995). which also represents a Iwo-dimensiooal IIO/llincar manifoid as a regular array of disc"'le points. The SOM i' somewhat remin;""'nt of the K·trlCan, algorithm in that data points are a.,igr.ed to nearby ProlOl)'j>C '-eclon thaI are lhen subsc<juenlly updale<!. Initially. lhe proIOI)'jl('S are distribuled at random, and during the training process they 'selr organize' so as to aPl'ro~imale a smoolh manifold. Unlike K -mean'. how'e"e.. the SOM is TIOI optimizing any well.ddine<! cost function (Erwin.. al.. 1992) making" difficult to s." the parameters of the model and 10 assess con'-ergence. There i' also no guarantee that the '",If-<>rganilalion' will take place.. this is depen""nl 00 the choice of appropriate paranlttcr "aloC' f,,, any particular data sel.

By OOfItrast, GTM optimize, the log likelihood functioo, and the resolting model define' a probabilily den,ity in dma,pace, In faeL il corre,ponds to a con,m,incd mi,ture of Gaussian, in which the component.',h.re a COnlnlOn ".riance.• nd the mean, are con'trained to lie on a 'mooIh tw-o-diITlCn,iooal n1anifold. This proba- bilistic foundation also makes it very straightforward to define generalizations of GTM (Bishop et al., 1998a) such as a Bayesian treatment, dealing with missing values, a principled extension to discrete variables, the use of Gaussian processes to define the manifold, or a hierarchical GTM model (Tino and Nabney, 2002).

Because the manifold in GTM is defined as a continuous surface, not just at the prototype vectors as in the SOM, it is possible to compute the magnification factors corresponding to the local expansions and compressions of the manifold needed to fit the data set (Bishop et al., 1997b) as well as the directional curvatures of the manifold (Tino et al., 2001). These can be visualized along with the projected data and provide additional insight into the model.
