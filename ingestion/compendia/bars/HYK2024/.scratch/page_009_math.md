[Page 9]

Table 3: Summary of GMSD with respect to five methods in three manifolds

Arcs

Spiral

Swiss roll


500

1000

1500

Input

0.0404(0.0020)

0.0397(0.0021)

2.6033(0.0729)

TSME

0.0036(0.0021)

0.0019(0.0003)

0.5299(0.0653)

MFUN

0.0039(0.0011)

0.0112(0.0011)

2.5549(0.0735)

PMF

0.0051(0.0011)

0.0165(0.0017)

2.5994(0.0733)

PME

0.4790(0.2585)

2618.6(9887.4)



0.7661(0.0077)

2.9539(0.0633)



1000

1500

3000

Input

0.0399(0.0013)

0.0401(0.0013)

2.6423(0.0621)

TSME

0.0044(0.0033)

0.0015(0.0002)

0.5004(0.0605)

MFUN PMF

0.0018(0.0004)

0.0078(0.0005)

2.5377(0.0629)

PME

0.0023(0.0007)

0.0113(0.0008)

2.6241(0.0625)

PME

0.3135(0.1353)

151.87(449.52)



0.7589(0.0072)

2.9601(0.0699)


To evaluate the performance quantitatively, we define the geometric mean squared distance as

$$
G M S D = \frac { 1 } { m } \sum _ { i = 1 } ^ { m } \text {dist} ( \hat { f } \circ \hat { g } ( x _ { i } ), \mathbb { M } ^ { d } ) ^ { 2 },
$$

where dist ( x, M d ) = inf x ′ ∈ M d || x − x ′ ||.The GMSD measures the corrupted extent of the data away from the manifold. Table 3 illustrates the mean and standard deviation of GMSD in three manifolds of 20 duplicates. TSME obtains significantly smaller GMSD than the training samples in all scenarios and achieves the smallest GMSD in most cases, demonstrating that our method contributes to excellent manifold denoising. For MFUN and PMF, the performance in the d = 1 cases is satisfactory but the noise is not reduced in the Swiss roll. PME and PC are completely incapable of estimating the latent manifolds.

This article is motivated by the knot selection problem in the multivariate spline regression. The proposed method estimates the number and location of spline knots simultaneously and accurately. It provides a mechanism for easy interpretation and function fitting with jumping discontinuity. The trade-off for advantages is the additional computational cost, attributed to RJMCMC. Nevertheless, it will not cause a serious problem in small or moderately large datasets.

There are several potential jobs in the future. We intend to establish a theoretical framework of the algorithm including the consistency and convergence rate. The primary challenge is how to define an appropriate distance between parameters with varying dimensions. Furthermore, the domain space is required to be a cube. We aim for an extension in the general domain. A possible solution is substituting a flexible multivariate spline for the tensor product spline.

The source package EBARS is accessible on the GitHub repository https://github.com/ junhuihe2000/EBARS and R codes of examples in Section 4 are available on the GitHub repository https://github.com/junhuihe2000/exampleEBARS.The technical appendices include proofs of Lemmas 1 and 3, and additional simulations in curve and surface fitting.

Yang’s research was partially supported by the National Natural Science Foundation of China grant (12271286, 11931001). Kang’s research was partially supported by the following grants: NIH R01DA048993, NIH R01MH105561 and NSF IIS2123777.
