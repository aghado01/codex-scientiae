[Page 14]

The resulting Bayesian adaptive regression splines fits for the posterior means $E\{f(t) \mid y\}$ are given together with the raw counts in Fig. 6. Bayesian adaptive regression splines nicely adapts to the changing irregularities of the intensity functions producing estimates that are consistent with intuition: the intensities may change sharply on time scales of about 50 milliseconds, but are quite smooth on finer time scales. Table 2 gives the posterior means and posterior standard deviations for the quantities of interest. The maximal firing rate was, for example, defined as $g(\beta, k, \xi) = \arg\max_t f(t)$. The substantive conclusion is that the drops from the first, highest peak to the following trough for Conditions 1 and 2 were $131.8 \pm 4.4$ and $181.8 \pm 20.3$ spikes per second; Condition 2 had a more pronounced drop, estimated to be $50.0 \pm 20.8$ spikes per second greater than that for Condition 1, with 95% probability interval $(8.4, 91.7)$.

Table 2. Neuronal firing example. Posterior means of maximal firing rate, local minimal firing rate just after the maximal firing rate, and the drop, i.e. the difference between these two firing rates, for each condition. Posterior standard deviations are shown in parentheses

| Firing rate | Condition 1 | Condition 2 |
|---|---|---|
| Maximum | 166.5 (5.2) | 193.0 (20.6) |
| Local min. | 34.8 (1.9) | 11.5 (1.5) |
| Difference | 131.8 (4.4) | 181.8 (20.4) |

## 7. Discussion

Bayesian adaptive regression splines is a fully Bayesian, flexible spline model suitable for both normal and nonnormal data. It provides a mechanism for deriving useful uncertainties in function estimates and can easily be inserted as a component in a larger hierarchical model, as we have demonstrated here in § 5. Balancing against this advantage is the additional computational cost of the simulation: spatially adaptive regression splines is notably faster than Bayesian adaptive regression splines. However, this should not be a serious handicap in applications involving small or moderately large datasets. Key advantages of the method adopted here that distinguish it from the closely related approach applied by Biller (2000) are the placement of knots by a continuous proposal distribution and the introduction of the unit-information prior as a default, so that the chain simulates the approximate marginal posterior of $(k, \xi)$ after integrating $\beta$; this increases efficiency (Liu et al., 1994).

Bayesian adaptive regression splines results and performance depend to some extent on the choice of knot priors. Thus, user input on the expected number of knots is needed as a kind of smoothing parameter. We used this to our advantage in the functional magnetic resonance imaging example to adapt Bayesian adaptive regression splines to different tasks. However, for large signal-to-noise ratios, or large samples, Bayesian adaptive regression splines will correctly find the appropriate number of knots regardless of the prior.

This paper has focused on estimates and standard errors, but one big advantage of a Bayesian formulation is the ability to estimate a wide range of features for the function of interest. We intend to explore Bayesian adaptive regression splines' effectiveness as a component of Bayesian hierarchical models in future work.
