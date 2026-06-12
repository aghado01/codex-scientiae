[Page 2]

106

firing rate (spikes/s)




−200


200

400

600

800

Time (ms)

Figure 1: Histogram and ﬁts using a Gaussian kernel density estimator (dotted line), logspline (thin line), and BARS (thick line). Units are in spiking events per second, the usual units for intensity functions based on neuronal spiking events. The data come from a neuron in inferotemporal cortex recorded during 16 replications (in physiological jargon, 16 trials) of an experiment described by Baker et al. ( 2002 ).

unbiased cross-validation ( Venables and Ripley 2002 ), which smooths the histogram. From a neurophysiological point of view, it is reasonable to expect the intensity function to vary slowly throughout much of its domain, but perhaps rapidly in a relative short interval. In this situation, the kernel density estimate oversmooths the rapid jump in the intensity, while undersmoothing the portion involving slow variation. It would be preferable to use a method of estimating the intensity function that adapts to functional variation across time.

For a Poisson process, when the events are put into small time bins, as in Figure 1, the data form a sequence of Poisson-distributed counts and estimation of the Poisson process intensity function becomes a Poisson regression problem. This problem motivated development of BARS (Bayesian adaptive regression splines, DiMatteo et al. 2001 ), which uses regression splines with knot sets determined adaptively via Markov chain Monte Carlo (MCMC). A
