[Page 14]

Table 4: MSE on test data of five methods in Cases 1.1 − 1.4

Methods


Case 1.1

Case 1.2

Case 1.3

Case 1.4

EBARS γ =

0.181(0.124)

0.332(0.118)

0.828(0.529)

0.370(0.366)

EBARS γ = 0

0.230(0.136)

0.389(0.184)

1.412(0.783)

0.368(0.150)

EBARS γ =

200

0.341(0.229)

0.464(0.201)

1.960(0.985)

0.418(0.155)

BARS

0.178(0.150)

0.368(0.139)

0.731(0.403)

3.003(0.504)


0.137(0.088)

0.329(0.132)

3.772(1.687)

0.443(0.155)

EBARS γ =

0.068(0.033)

0.147(0.061)

0.361(0.168)

0.079(0.033)

EBARS γ = 0

0.082(0.039)

0.156(0.059)

0.536(0.215)

0.112(0.034)

EBARS γ =

500

0.170(0.073)

0.231(0.083)

1.053(0.410)

0.144(0.042)

BARS SS

0.071(0.032)

0.160(0.054)

0.317(0.140)

0.364(0.615)


0.053(0.026)

0.139(0.041)

1.914(0.418)

0.229(0.066)

Table 5: MSE on test data of five methods in Cases 2.1 − 2.4

Methods


Case 2.1

Case 2.2

Case 2.3

Case 2.4

EBARS γ =

500

0.163(0.044)

0.624(0.107)

0.664(0.216)

1.133(0.443)

EBARS γ =

0.148(0.038)

0.616(0.111)

0.597(0.192)

1.101(0.287)

EBARS γ

0.138(0.042)

0.609(0.089)

0.568(0.136)

1.076(0.269)

BARS

0.169(0.050)

0.671(0.160)

0.660(0.199)

1.968(0.485)

TPS

0.102(0.031)

0.587(0.092)

1.958(0.625)

2.324(0.466)

EBARS γ =

1000

0.064(0.011)

0.355(0.051)

0.230(0.061)

0.331(0.077)

EBARS γ =

0.066(0.016)

0.326(0.056)

0.222(0.053)

0.343(0.078)

EBARS γ BARS

0.065(0.014)

0.306(0.058)

0.242(0.067)

0.336(0.058)

BARS

0.057(0.015)

0.319(0.032)

0.313(0.074)

1.379(0.214)

TPS

0.057(0.015)

0.319(0.032)

1.205(0.215)

1.379(0.214)

To graphically illustrate the difference in surface spline regression, we visualize the prediction results with m = 1000 by contour maps in Figure 6. Initially, the fitted contours approximately overlap with the ground truth in Cases 2.1 and 2.2, see the top 2 rows. We can see from the (3, 6) and (4, 6) panels that TPS fails to estimate the jump discontinuity in Cases 2.3 and 2.4. Actually, the fitted surfaces by TPS are always smooth regardless of the smoothness of true models. BARS obtains a nice performance in Cases 2.1-2.3, but is trapped in Case 2.4 when the required k is enormous. Conversely, Columns 2 − 4 of Figure 6 show that our EBARS makes precise predictions in all cases successfully.
