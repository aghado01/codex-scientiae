[Page 4]



![The image is a graph that shows the observed and posterior predictive of the ABC (abdominal aorta) and the X-axis is labeled as time. The graph is divided into two sections, one labeled observed and the other labeled posterior predictive. The observed section shows the data points for the ABC and the X-axis, while the posterior predictive section shows the data points for the ABC and the X-axis. The graph shows a trend of increasing data points for the ABC and a decreasing trend for the X-axis. The data points for the ABC and the X-axis are shown in red. The data points for the ABC and the X-axis are shown in blue. The data points for the ABC and the X-axis are shown in purple. The graph also shows a trend of decreasing data points for the ABC and a decreasing trend for the X-axis. The data points for the ABC and the X-](<TKH2022/imageFile2.png>)



Fig. 2. Visualizations of simulation output from the Anderson–Chaplain model for ﬁve parameter sets sampled from a uniform prior on the model parameters. The ﬁrst column shows the observed data, while the second shows a contour plot of the posterior density inferred by applying the TABC methodology, with the red cross indicating the known parameter values used to generate the observed data. The remaining three columns show simulations of parameter values drawn from the ABC posterior predictive distribution

2014 ; Toni et al. , 2009 ). To allow us to perform Bayesian inference in these situations, an approach named ABC was developed, based on initial work in Fu and Li (1997) and Tavar e et al. (1997) , developed further in Beaumont et al. (2002) and Marjoram et al. (2003) , and expanded in many works, see for example Sisson et al. (2007) ; Toni et al. (2009) ; Beaumont et al. (2009) ; Del Moral et al. (2012) ; Prangle et al. (2018) .

In an ABC framework, we rely on the observation that given the ability to sample realizations y from p ð x j h Þ , we can rewrite the posterior as


$$
p ( \theta | x ) = \left | p ( \theta , y | x ) d y ,
$$

$$
p ( \theta , y | x ) = \frac { 1 ( x = y ) p ( y | \theta ) p ( \theta ) } { p ( x ) } , \quad \quad ( 5 )
$$

and by relaxing this to

$$
p ( \theta , y | x ) \approx \frac { 1 ( D ( x , y ) \, < \, \epsilon ) p ( y | \theta ) p ( \theta ) } { p ( x ) } , \quad \quad ( 6 ) \quad \text {in the} \, \ t h e c k { G }
$$

we can generate samples from an approximate posterior (which we shall refer to as the ABC posterior ) by using a suitably small in Algorithm 1. Often when applying the rejection algorithm, we fix the number of samples S and select such that the set of samples ^ h s with d s < is some fraction a S .The ABC rejection sampler algorithm requires us to define a distance on the data, D ( x , y ), and in some cases this may itself be intractable. It is then possible to substitute a summary statistic of the data, g ( x ) in place of the data itself, leading to a distance on these summary statistics D ð g ð x Þ ; g ð y ÞÞ being considered. In the case where g is a sufficient statistic for the model, as ! 0 this will be equivalent to applying a distance on the x and y themselves. Often this is not the case, and this is another avenue

|Algorithm 1 ABC rejection sampler algorithm| |
|---|---|
|1: for s 2 1 ; ... ; S do| |
|2:|Sample ^ h s  p ð h Þ|
|3:|Simulate y  p ð y j ^ h s Þ|
|4:|Calculate d s D ð g ð y Þ ; g ð x ÞÞ|
|5: end for| |
|6: Return samples ^ h s where d s < | |


through which ABC produces an approximation to the posterior rather than a true evaluation of the posterior itself.

## 3.3 Topological statistics for approximate Bayesian computation

In previous work, Nardini et al. (2021) applied topological statistics of simulated data (2D binary images) to quantify different regimes in the parameter space of the Anderson–Chaplain model of angiogenesis. By constructing simplicial complexes from the output data of a spatial model, and using the same filtration as Nardini et al. (2021) , PH can be applied to describe the presence of topological features in the simulated data.

In some cases when calculating the persistence of the topological features of a filtration, it is possible for some features to persist indefinitely, so that their death in the filtration is represented as þ1 . In our application, this causes information about certain topological features to be lost, for example loops and some connected components, as although we know when they are born in the filtration, we have no measure of their extent. For this reason, Nardini et al. (2021) computed persistence of a left to right sweeping plane filtration and right to left sweeping plane filtration of the simplicial
