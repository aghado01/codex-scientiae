[Page 14]

The resulting Bayesian adaptive regression splines ﬁts for the posterior means E{f(t) | y} are given together with the raw counts in Fig. 6. Bayesian adaptive regression splines nicely adapts to the changing irregularities of the intensity functions producing estimates that are consistent with intuition: the intensities may change sharply on time scales of about 50 milliseconds, but are quite smooth on ﬁner time scales. Table 2 gives the posterior means and posterior standard deviations for the quantities of interest. The maximal ﬁring rate was, for example, deﬁned as g( b, k, j ) = arg max t f(t) j arg max t i B b.The substantive conclusion is that the drops from the ﬁrst, highest peak to the following trough for Conditions 1 and 2 were 131·8 ± 4·4 and 181·8 ± 20·3 spikes per second; Condition 2 had a more pronounced drop, estimated to be 50·0 ± 20·8 spikes per second greater than that for Condition 1, with 95% probability interval (8·4, 91·7).

Table 2. Neuronal ﬁring example. Posterior means of maximal ﬁring rate, local minimal ﬁring rate just after the maximal ﬁring rate, and the drop, i.e. the di V erence between these two ﬁring rates, for each condition. Posterior standard deviations are shown in parentheses

Firing rate

Condition 1

Condition 2

Maximum

166·5 (5·2)

193·0 (20·6)

Local min.

34·8 (1·9)

11·5 (1·5)

Di ﬀ erence

131·8 (4·4)

181·8 (20·4)

Bayesian adaptive regression splines is a fully Bayesian, ﬂexible spline model suitable for both normal and nonnormal data. It provides a mechanism for deriving useful uncertainties in function estimates and can easily be inserted as a component in a larger hierarchical model, as we have demonstrated here in § 5. Balancing against this advantage is the additional computational cost of the simulation: spatially adaptive regression splines is notably faster than Bayesian adaptive regression splines. However, this should not be a serious handicap in applications involving small or moderately large datasets. Key advantages of the method adopted here that distinguish it from the closely related approach applied by Biller (2000) are the placement of knots by a continuous proposal distribution and the introduction of the unit-information prior as a default, so that the chain simulates the approximate marginal posterior of (k, j ) after integrating b ; this increases e ﬃ ciency (Liu et al., 1994).

Bayesian adaptive regression splines results and performance depend to some extent on the choice of knot priors. Thus, user input on the expected number of knots is needed as a kind of smoothing parameter. We used this to our advantage in the functional magnetic resonance imaging example to adapt Bayesian adaptive regression splines to di ﬀ erent tasks. However, for large signal-to-noise ratios, or large samples, Bayesian adaptive regression splines will correctly ﬁnd the appropriate number of knots regardless of the prior.

This paper has focused on estimates and standard errors, but one big advantage of a Bayesian formulation is the ability to estimate a wide range of features for the function of interest. We intend to explore Bayesian adaptive regression splines’ e ﬀ ectiveness as a component of Bayesian hierarchical models in future work.
