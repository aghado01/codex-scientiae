[Page 257]

point in weight space such that the gradient of the error function vanishes, so that

$$
\nabla E ( w ) = 0
$$

as otherwise we could make a small step in the direction of −∇ E ( w ) and thereby further reduce the error. Points at which the gradient vanishes are called stationary points, and may be further classiﬁed into minima, maxima, and saddle points.

Our goal is to ﬁnd a vector w such that E ( w ) takes its smallest value. However, the error function typically has a highly nonlinear dependence on the weights and bias parameters, and so there will be many points in weight space at which the gradient vanishes (or is numerically very small). Indeed, from the discussion in Section 5.1.1 we see that for any point w that is a local minimum, there will be other points in weight space that are equivalent minima. For instance, in a two-layer network of the kind shown in Figure 5.1, with M hidden units, each point in weight space is a member of a family of M !2 M equivalent points.

Furthermore, there will typically be multiple inequivalent stationary points and in particular multiple inequivalent minima. A minimum that corresponds to the smallest value of the error function for any weight vector is said to be a global minimum . Any other minima corresponding to higher values of the error function are said to be local minima . For a successful application of neural networks, it may not be necessary to ﬁnd the global minimum (and in general it will not be known whether the global minimum has been found) but it may be necessary to compare several local minima in order to ﬁnd a sufﬁciently good solution.

Because there is clearly no hope of ﬁnding an analytical solution to the equation ∇ E ( w ) = 0 we resort to iterative numerical procedures. The optimization of continuous nonlinear functions is a widely studied problem and there exists an extensive literature on how to solve it efﬁciently. Most techniques involve choosing some initial value w (0) for the weight vector and then moving through weight space in a succession of steps of the form

$$
w ^ { ( \tau + 1 ) } = w ^ { ( \tau ) } + \Delta w ^ { ( \tau ) }
$$

where τ labels the iteration step. Different algorithms involve different choices for the weight vector update ∆ w ( τ ) . Many algorithms make use of gradient information and therefore require that, after each update, the value of ∇ E ( w ) is evaluated at the new weight vector w ( τ +1) . In order to understand the importance of gradient information, it is useful to consider a local approximation to the error function based on a Taylor expansion.

# 5.2.2 Local quadratic approximation

Insight into the optimization problem, and into the various techniques for solving it, can be obtained by considering a local quadratic approximation to the error function.

$$
function . & \quad \text {Consider the Taylor expansion of } E ( w ) \text { around some point } \widehat { w } \text { in weight space } \\ & \quad E ( w ) \simeq E ( \widehat { w } ) + ( w - \widehat { w } ) ^ { T } b + \frac { 1 } { 2 } ( w - \widehat { w } ) ^ { T } H ( w - \widehat { w } ) \\
$$
