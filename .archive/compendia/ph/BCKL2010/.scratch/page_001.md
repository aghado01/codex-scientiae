[Page 1]

# STATISTICAL TOPOLOGY VIA MORSE THEORY PERSISTENCE AND NONPARAMETRIC ESTIMATION

PETER BUBENIK, GUNNAR CARLSON, PETER T. KIM, AND ZHI–MING LUO

Abstract. In this paper we examine the use of topological methods for multivariate statistics. Using persistent homology from computational algebraic topology, a random sample is used to construct estimators of persistent homology. This estimation procedure can then be evaluated using the bottleneck distance between the estimated persistent homology and the true persistent homology. The connection to statistics comes from the fact that when viewed as a nonparametric regression problem, the bottleneck distance is bounded by the sup-norm loss. Consequently, a sharp asymptotic minimax bound is determined under the sup–norm risk over Ho¨lder classes of functions for the nonparametric regression problem on manifolds. This provides good convergence properties for the persistent homology estimator in terms of the expected bottleneck distance.

## 1. Introduction

Quantitative scientists of diverse backgrounds are being asked to apply the techniques of their specialty to data which is greater in both size and complexity than that which has been studied previously. Massive, multivariate data sets, for which traditional linear methods are inadequate, pose challenges in representation, visualization, interpretation and analysis. A common ﬁnding is that these massive multivariate data sets require the development of new statistical methodology and that these advances are dependent on increasing technical sophistication. Two such data-analytic techniques that have recently come to the fore are computational algebraic topology and geometric statistics.

2000 Mathematics Subject Classiﬁcation. Primary 62C10, 62G08; Secondary 41A15, 55N99, 58J90.

Key words and phrases. Bottleneck distance, critical values, geometric statistics, minimax, nonparametric regression, persistent homology, Plex, Riemannian manifold, sublevel sets.

Support for the second author was partially funded by DARPA, ONR, Air Force Oﬃce of Scientiﬁc Research, and NSF..

Support for the third author was partially funded by NSERC grant DG 46204.
