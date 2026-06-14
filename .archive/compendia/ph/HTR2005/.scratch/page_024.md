[Page 24]

While using the variance of ∆ as estimate for ˆ σ tends to overestimate σ for low noise, the quartile method does not suﬀer from this (non)problem.

The usefulness of quoting the evidence cannot be overestimated. While the absolute number itself is hard to comprehend, comparisons (based on this absolute(!) number) are invaluable. Consider, for instance, the three segment medium Gaussian noise data y GM from Figure 2. Table 2 shows that log E (GM) = − 48, while log E (GMwC)= − 70, i.e. the odds that y GM has Cauchy rather than Gaussian noise is tiny e 48 − 70 < 10 − 9 , and similarly the odds that y CM has Gaussian rather than Cauchy noise is e 127 − 160 < 10 − 14 . This can be used to decide on the model to use. For instance it clearly indicates that noise in Gene31 and Gen59 is not Cauchy for which log-evidences would be − 398 and − 406, respectively. The smallness of the relative log-likelihoods does not indicate any gross misspeciﬁcation.

The indicated 4 th segment for GH and CH is spurious, since it has length zero (two breaks at the same position). In Gene31, only 15 out of the indicated 34 segments are real. The spurious ones would be real had we estimated the breaks ˆ t jointly, rather than the marginals t p separately. They would often be single data segments at the current boundaries, since it costs only a single extra break to cut oﬀ an “outlier” at a boundary versus two breaks in the middle of a segment.

In the last column we indicated the conﬁdence C ˆ k ( C ˆ k − 1 ,C ˆ k +1 ) of BPCR in the estimate ˆ k . For clean data (GL,GM,CL,GM) it is certain that there are at least 3 segments. We already explained the general tendency to also believe in higher number of segments.

## 11 Extensions & Outlook

The core Regression( A ,n,k max ) algorithm does not care where the in-segment evidence matrix and moments A come from. This allows for plenty of easy extensions of the basic idea.

If the segment levels are known to belong to a discrete set (e.g. integer DNA copy numbers [PRLD05]), this simply corresponds to a discrete prior on µ and leads naturally to a Grid sum (rather than by need) as in EstGeneral().

If each segment can have its own (unknown) variance σ 2 m , we can assume some prior over σ m and average (16) (which depends on σ m , notationally suppressed) additionally over σ m . Possibly P ( σ m | ... ) depends on some hyper-parameter that now has to be estimated instead of σ ; all the better if not.

We assumed a constant regression function within a segment. Actually any other function could be used. We simply choose likelihood and prior for a single segment and compute its evidence A 0 ij . This is all what Regression() needs to determine the segment number and boundaries. Once we have the segment boundaries it is easy to compute the in-segment quantities we are interested in, e.g. the MAP or mean regression curve.

For instance, if we consider all linear functions within a segment, we get a piece- wise linear regression curve. But note that this curve is not continuous. This model is, for instance good, if the true function is essentially piecewise constant, but there is an additional underlying trend (slope) in the segments. Using non-linear functions allows to handle more complicated trends.
