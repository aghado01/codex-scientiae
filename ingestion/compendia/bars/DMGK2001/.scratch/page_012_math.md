[Page 12]

600

500

400

300

0

200

400

600

800

Time (sec)

Fig. 5. Magnetic resonance example. The time-course shows the magnetic resonance signal for Experiment 2. Superimposed on the signal, thin dotted line, is a semiparametric ﬁt, solid line, together with the nonparametric estimate of the linear trend, dashed line.

In a recent experiment, the ﬁring of individual neurons in the inferotemporal cortex of a macaque monkey were recorded while he watched images appear on a screen in front of him (Olson & Rollenhagen, 1999). In one experimental condition, Condition 1, a black patterned object was displayed as the stimulus for 600 milliseconds. In a second condition, Condition 2, prior to the display of the stimulus a pair of blue rectangles were displayed and these remained illuminated while the stimulus was displayed. The typical inferotemporal neuronal response to the stimulus was roughly damped-oscillatory ﬁring. In the second condition, however, the oscillation tended to be more pronounced, with higher drop from peak to trough. We use the methodology developed in §§ 2 and 3 to ﬁt the data for one neuron and quantify the comparison of initial peak-to-trough drop in ﬁring rates.

The data consist of neuronal spike counts from 193 repeated trials binned into 10-millisecond intervals. As discussed in a related context by Kass & Ventura (2001) and Ventura et al. (2001), such count data may be expected to be very nearly Poisson, and preliminary examination of the data indicated that this assumption was very reasonable. The model we use, therefore, for the counts {Y i, i = 1,..., n} at time {x i, i = 1,..., n} is as follows:

$$
( Y _ { i } | \beta, k, \xi ) \sim \text {Po} ( \lambda _ { i } ), \ \log ( \lambda _ { i } ) = B ( x _ { i } ) \beta, \quad \beta | k, \xi \sim N ( 0, D ), \ \ p ( k, \xi ),
$$

where D is the matrix from the unit-information prior. We do not have to write down D explicitly because, as explained in §§ 2 and 3, we use the  -based reversible-jump Markov chain Monte Carlo scheme together with importance reweighting. As our importance function for the posterior on b, we have used a Normal approximation based on the maximum likelihood estimates and the observed information matrix. Comparison of the results before and after importance reweighting indicates that the Normal distribution is in fact a good approximation. We did all our computations in S-Plus.
