[Page 600]

![Figure 12.11](../images/imageFile137.png)

Figure 12.11 Probabilistic PCA visualization of a portion of the oil ﬂow data set for the ﬁrst 100 data points. The left-hand plot shows the posterior mean projections of the data points on the principal subspace. The right-hand plot is obtained by ﬁrst randomly omitting 30% of the variable values and then using EM to handle the missing values. Note that each data point then has at least one missing measurement but that the plot is very similar to the one obtained without missing values.

subspace to minimize the squared reconstruction error in which the projections are given.

We can give a simple physical analogy for this EM algorithm, which is easily visualized for $D = 2$ and $M = 1$. Consider a collection of data points in two dimensions, and let the one-dimensional principal subspace be represented by a solid rod. Now attach each data point to the rod via a spring obeying Hooke’s law (so that the energy is proportional to the square of the spring’s length). In the E step, we keep the rod ﬁxed and allow the attachment points to slide up and down the rod so as to minimize the energy. This causes each attachment point (independently) to position itself at the orthogonal projection of the corresponding data point onto the rod. In the M step, we keep the attachment points ﬁxed and then release the rod and allow it to move to the minimum energy position. The E and M steps are then repeated until a suitable convergence criterion is satisﬁed, as is illustrated in Figure 12.12.

### 12.2.3 Bayesian PCA

So far in our discussion of PCA, we have assumed that the value $M$ for the dimensionality of the principal subspace is given. In practice, we must choose a suitable value according to the application. For visualization, we generally choose $M = 2$, whereas for other applications the appropriate choice for $M$ may be less clear. One approach is to plot the eigenvalue spectrum for the data set, analogous to the example in Figure 12.4 for the off-line digits data set, and look to see if the eigenvalues naturally form two groups comprising a set of small values separated by a signiﬁcant gap from a set of relatively large values, indicating a natural choice for $M$. In practice, such a gap is often not seen.
