
# 3.2 Bayesian Adpative Penalized Splines

The trade-off between bias and variance is controlled by the smoothing parameter λ as was mentioned in Chapter 2. However, for functions with varying oscillations or functions with discontinuities, a single smoothing parameter is inadequate (Scheipl and Kneib, 2009). In this chapter, we introduce spatially adaptive smoothing. Allowing λ to be locally adaptive improves the accuracy of inference and reduces the mean squared error (Ruppert and Carroll, 2000). The following method is referred to as Bayesian Adaptive Penalized Splines (BAPS).

# 3.3 Model

Consider the model

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i } ,
$$

where

$$
f ( x _ { i } ) = \beta _ { 0 } + \beta _ { 1 } x _ { i } + \dots + \beta _ { p } x _ { i } ^ { p } + \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ( x _ { i } - \kappa _ { j } ) _ { + } ^ { p } .
$$

In Chapter 2, b ∼ N ( 0 ,σ 2 b I K κ ), i.e., σ 2 b is common to all the b j , j = 1 ,...,K κ . To make the model spatially adaptive, Yue et al. (2012) proposed spatially adaptive precisions δ j ,

$$
( b _ { j } | \delta _ { j } ) \stackrel { i n d } { \sim } N ( 0 , \delta _ { j } ^ { - 1 } ) , \quad j = 1 , \dots , K _ { \kappa } .
$$

Moreover, define δ j as

$$
\delta _ { j } = \delta \exp ( \gamma _ { j } ) ,
$$

where δ is a scale parameter.

Let ι 1 ,...,ι K ι be a second layer of knots that covers the range of the knots κ 1 ,...,κ K κ . The model proposed by Yue et al. (2012) then specifies γ j as

$$
\gamma _ { j } = \sum _ { k = 1 } ^ { K _ { \iota } } b _ { \gamma k } I ( \kappa _ { j } \geq \iota _ { k } ) , \ \ j = 1 , \dots , K _ { \kappa } ,
$$
