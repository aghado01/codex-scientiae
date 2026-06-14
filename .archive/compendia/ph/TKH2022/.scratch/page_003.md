[Page 3]




![In this image there is a diagram with some text and a diagram with some text.](<TKH2022/imageFile1.png>)

Fig. 1. Topological data analysis pipeline. ( A ) Illustration of topological features captured by persistence. Take data X as the image on the left. Homology is an invariant from algebraic topology that captures shape, but ignores geometry. Dimension 0 homology describes connected components whereas dimension 1 homology ( H 1 ð X Þ ) describes 1D loops. Persistent homology (PH) quantiﬁes the shape of data through a multiscale lens called a ﬁltration. Here, we use a sublevel set ﬁltration of the data X a ¼ f 0 ; 1 ; ... ; 4 g , which only includes data to the left of the index, forming a nested sequence of data spaces. PH provides additional information than homology; for this ﬁltration of the data, PH gives the number and location of loops. Extended persistent homology (EPH) requires three computations (ordinary persistence, relative persistence and extended persistence). For this dataset, EPH provides information on the number of loops, size and location. ( B , C ) The output of persistence computations is summarized by a multi-set of intervals given by birth, death pairs ( b , d ), where b is when a loop forms and d is when a loop ends and can be visualized as a persistence diagram. This persistence diagram is then converted into birth, persistence pairs, where persistence is given by ð d b Þ , and then vectorized using kernels into persistence images ( Adams et al. , 2017 ). Persistence images generate topological statistics of the data that can then be applied in statistical inference. The persistent homology (in B) captures only the birth of the loop with the death at 1 , whereas the extended component of the extended persistence (in C) also captures the death of the loop

We build the simplicial complex and filtration from the final timepoint of model simulation data following Nardini et al. (2021) . All cells in the 2D square lattice that have vasculature present are assigned a value of one, and zero elsewhere. The centroid of each non-zero cell is a 0-simplex. The simplicial complex is built on these 0-simplices based on so-called Moore neighbourhoods: if any of the eight cells surrounding a vertex are also non-zero, then we connect them via 1-simplices (edges) for two points pairwise connected, or 2-simplices for three points pairwise connected by an edge. The union of these simplices form a simplicial complex . There are different ways to study vascular data at multiple scales using filtrations ( Bendich et al. , 2016 ; Stolz et al. , 2020 ). Here, we construct sequences of filtered simplicial complexes using a sweeping plane filtration ( Bendich et al. , 2016 ; Nardini et al. , 2021 ). In the sweeping plane filtration, we move a vertical line from left to right across the 2D lattice domain and include simplices in the filtration only to the left of this line. This filtration can be considered a sublevel set filtration corresponding to a height function h : X ! R on this simplicial complex.

## 3.2 Approximate Bayesian computation

In Bayesian inference, we aim to derive the posterior distribution of the parameters of a model given some observed data. To do so we first define a prior distribution on the model parameters, treating them as random variables. This describes our belief in the distribution of the parameters before having observed any data. We then perform a so-called Bayesian update of the model having observed some data. This is done using the likelihood of the observed data given the model and parameters. From this, we arrive at a posterior distribution that describes the conditional distribution of the parameters given the observed data. If we denote the model parameters by h , and the data by x , we can first write the prior as p ð h Þ , and the likelihood of the data as p ð x j h Þ . In the Bayesian framework, we apply Bayes rule to update the prior distribution having observed the data, giving us the posterior distribution as

$$
p ( \theta | x ) = \frac { p ( x | \theta ) p ( \theta ) } { p ( x ) } ,
$$

where p ( x ) is known as the evidence or marginal likelihood, and plays a key role in Bayesian model selection. Evaluation of the marginal likelihood is often computationally expensive or intractable. However, in many settings (e.g. when sampling from the posterior using Markov chain Monte Carlo techniques), it is sufficient to be able to write down the posterior up to proportionality

$$
p ( \theta | x ) \propto p ( x | \theta ) p ( \theta ) .
$$

This approach relies on the ability to calculate both the prior of the parameters p ð h Þ , which is generally tractable, and the likelihood p ð x j h Þ . However in many models of interest it is not tractable or not possible to directly evaluate p ð x j h Þ , for example in population genetics ( Beaumont et al. , 2002 ), random graph models ( Thorne and Stumpf, 2012 ) and some models of dynamical systems ( Liepe et al. ,
