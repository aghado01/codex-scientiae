[Page 12]

![Semiparametric fit for Experiment 2: magnetic resonance signal (dotted), semiparametric fit (solid), and nonparametric trend estimate (dashed).](<images/DMGK2001/imageFile5.png>)

Fig. 5. Magnetic resonance example. The time-course shows the magnetic resonance signal for Experiment 2. Superimposed on the signal, thin dotted line, is a semiparametric fit, solid line, together with the nonparametric estimate of the linear trend, dashed line.

## 6. A Poisson Application: Neuronal Firing

In a recent experiment, the firing of individual neurons in the inferotemporal cortex of a macaque monkey were recorded while he watched images appear on a screen in front of him (Olson & Rollenhagen, 1999). In one experimental condition, Condition 1, a black patterned object was displayed as the stimulus for 600 milliseconds. In a second condition, Condition 2, prior to the display of the stimulus a pair of blue rectangles were displayed and these remained illuminated while the stimulus was displayed. The typical inferotemporal neuronal response to the stimulus was roughly damped-oscillatory firing. In the second condition, however, the oscillation tended to be more pronounced, with higher drop from peak to trough. We use the methodology developed in §§ 2 and 3 to fit the data for one neuron and quantify the comparison of initial peak-to-trough drop in firing rates.

The data consist of neuronal spike counts from 193 repeated trials binned into 10-millisecond intervals. As discussed in a related context by Kass & Ventura (2001) and Ventura et al. (2001), such count data may be expected to be very nearly Poisson, and preliminary examination of the data indicated that this assumption was very reasonable. The model we use, therefore, for the counts $\{Y_i,\, i = 1, \ldots, n\}$ at time $\{x_i,\, i = 1, \ldots, n\}$ is as follows:

$$
(Y_i \mid \beta, k, \xi) \sim \mathrm{Po}(\lambda_i), \quad \log(\lambda_i) = B(x_i)\beta, \quad \beta \mid k, \xi \sim N(0, D), \quad p(k, \xi),
$$

where $D$ is the matrix from the unit-information prior. We do not have to write down $D$ explicitly because, as explained in §§ 2 and 3, we use the BIC-based reversible-jump Markov chain Monte Carlo scheme together with importance reweighting. As our importance function for the posterior on $\beta$, we have used a Normal approximation based on the maximum likelihood estimates and the observed information matrix. Comparison of the results before and after importance reweighting indicates that the Normal distribution is in fact a good approximation. We did all our computations in S-Plus.
