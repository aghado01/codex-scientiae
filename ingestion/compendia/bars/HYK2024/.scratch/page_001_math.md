[Page 1]

Department of Mathematical Sciences

Tsinghua University Beijing, China hejh22@mails.tsinghua.edu.cn

Department of Mathematical Sciences Tsinghua University Beijing, China yangying@tsinghua.edu.cn

Department of Biostatistics University of Michigan, Ann Arbor Michigan, United States jiankang@umich.edu

In multivariate spline regression, the number and locations of knots influence the performance and interpretability significantly. However, due to non-differentiability and varying dimensions, there is no desirable frequentist method to make inference on knots. In this article, we propose a fully Bayesian approach for knot inference in multivariate spline regression. The existing Bayesian method often uses BIC to calculate the posterior, but BIC is too liberal and it will heavily overestimate the knot number when the candidate model space is large. We specify a new prior on the knot number to take into account the complexity of the model space and derive an analytic formula in the normal model. In the non-normal cases, we utilize the extended Bayesian information criterion to approximate the posterior density. The samples are simulated in the space with differing dimensions via reversible jump Markov chain Monte Carlo. We apply the proposed method in knot inference and manifold denoising. Experiments demonstrate the splendid capability of the algorithm, especially in function fitting with jumping discontinuity.

Spline regression [Wahba, 1990, Schumaker, 2007, Gu, 2013] is a nonparametric method for modelling the complex dependencies between features, widely used in many fields including machine learning, econometrics and biomedicine. It is an ideal alternative to linear regression in the nonlinear data analysis. However, given the number and location of knots, the spline space is actually a linear space with a spline basis. Thus, the spline regression degenerates to a simple linear regression with respect to the basis, posing a strict limitation on its representative capacity. The ordinary solution is to assign sufficiently many knots and locate them uniformly, leading to a trade-off between the complexity and the flexibility of splines; see smoothing splines and thin plate splines [Wood, 2003]. Furthermore, the splines with fixed knots usually assume each knot is used only once. This means the spline function has continuous derivatives up to its degree minus one. Consequently, it is inappropriate for the distinct-knot spline to fit curves with jumping discontinuity.

Rather than equally-spaced knots, we develop a Bayesian approach for the automatic selection of the spline knots. The basic principle is modelling the intricate relationships with a few knots and the optimal location. The adaptive knot method reduces the complexity of splines when preserving the
