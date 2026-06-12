[Page 16]

Unlike linear regression, nonparametric regression assumes that f is a smooth function, but not necessarily linear. Thus, the data analyst is not restricted by a pre-speciﬁed shape of the regression function. Consider the regression model

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i }, \ \epsilon _ { i } \stackrel { i i d } { \sim } N ( 0, \sigma _ { \epsilon } ^ { 2 } ),
$$

where f ( · ) is an unknown function. The goal of nonparametric regression is to estimate the function f ( · ).

Given a set of data { (( x 1,y 1 ),... ( x n,y n )) }, consider again model (2.1) where

$$
f ( x _ { i } ) = \beta _ { 0 } + \beta _ { 1 } x _ { i } + \dots + \beta _ { p } x _ { i } ^ { p } + \sum _ { j = 1 } ^ { K _ { \kappa } } b _ { j } ( x _ { i } - \kappa _ { j } ) _ { + } ^ { p } .
$$

In (2.2) p > 0 and { κ j } K κ j =1 are ordered ﬁxed knots. Let β = ( β 0,...,β p ) and b = ( b 1,...,b K κ ) be the vectors of unknown parameters. Also, let

$$
X = \begin{bmatrix} 1 & x _ { 1 } & \dots & x _ { 1 } ^ { p } \\ \vdots & \vdots & \ddots & \vdots \\ 1 & x _ { n } & \dots & x _ { n } ^ { p } \end{bmatrix}, \ \ Z = \begin{bmatrix} ( x _ { 1 } - \kappa _ { 1 } ) _ { + } ^ { p } & \dots & ( x _ { 1 } - \kappa _ { K _ { n } } ) _ { + } ^ { p } \\ \vdots & \ddots & \vdots & \vdots \\ ( x _ { n } - \kappa _ { 1 } ) _ { + } ^ { p } & \dots & ( x _ { n } - \kappa _ { K _ { n } } ) _ { + } ^ { p } \end{bmatrix} .
$$

In addition, deﬁne T = [ X,Z ], θ = ( β  , b )  , and let y = ( y 1,...,y n ) .

In ordinary linear regression, the estimators are given by

$$
\hat { \theta } = \arg \min _ { \theta } \left \{ \left \| y - T \theta \right \| ^ { 2 } \right \}
$$
