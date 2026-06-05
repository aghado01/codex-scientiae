[Page 580]

![image 117](../../../../../images/imageFile117.png)

560 12. CONTINUOUS LATENT VARIABLES

Figure 12.1 A synthetic data sel obtained by taking one of the off-line digit images and creating multi-

ple copies in each of which the digit has undergone a random displacement and rotation

within some larger image field. The resulting images each have 100 )( 100 = 10.000

pixels.

that the manifold will be nonlinear because. for instance. if we translate the digit past a particular pixel, that pixel value will go from zero (white) 10 one (black) and back to zero again. which is clearly a nonlinear function of the digit position. In this example. !.he lranslation and rotation parameters are latent variables because we observe only the image vectors and are not told which values of the translation or rotation variables were used to create them.

For real digit image data, there will be a funher degree of freedom arising from scaling. Moreover there will be multiple addilional degrees of freedom associaled wilh more complex deformations due to the variability in an individual's wriling 3S well as lhe differences in writing slyles between individuals. evenheless. the number of such degrees of freedom will be small compared to the dimensionality of Ihe data set.

AppendiX A Another example is provided by the oil flow data set. in which (for a given geometrical configuration of the gas, WOller, and oil phases) there are only two degrees of freedom of variability corresponding to the fraction of oil in the pipe and the fraction of water (the fraction of gas Ihen being determined). Ahhough the data space comprises 12 measuremenlS, a data set of points will lie close to a Iwo-dimensional manifold embedded within this space. In this case, the manifold comprises scveral distinct segments corresponding to different flow regimes. each such segment being a (noisy) continuous two-dimensional manifold. If our goal is data compression. or density modelling, then there can be benefits in exploiling this manifold struclUre.

In praclice. the data points will not be confined precisely to a smooth lowdimensional manifold, and we can interpret the departures of data points from the manifold as ·noise'. This leads naturally to a generative view of such models in which we first select a poinl within the manifold according to some latent variable distribution and then generate an observed data point by :ldding noise, drawn from some conditional distribution of the data varillbles given the latent varillbles.

Thc simplest continuous latent variable model assumes Gaussian distributions for both thc latent and observed variables and makes use of a linear,Gaussian de-

SeCTion 8.1..J pendence of the observed variables on Ihe slate of the latent variables. This leads to a probabilislic fonnulation of the well-known technique of principal component analysis (PeA), as well as 10 a related model called factor analysis.

Section 12.1 In this chapter w will begin wilh a slandard, nonprobabilistic treatment of PeA. and thcn we show how PeA arises naturally as the maximum likelihood solution 10
