[Page 694]

densities and the mixing coefﬁcients share the hidden units of the neural network. Furthermore, in the mixture density network, the splits of the input space are further relaxed compared to the hierarchical mixture of experts in that they are not only soft, and not constrained to be axis aligned, but they can also be nonlinear.

# Exercises

14.1 ( ) www Consider a set models of the form p ( t | x , z h , θ h ,h ) in which x is the input vector, t is the target vector, h indexes the different models, z h is a latent variable for model h , and θ h is the set of parameters for model h . Suppose the models have prior probabilities p ( h ) and that we are given a training set X = { x 1 ,..., x N } and T = { t 1 ,..., t N } . Write down the formulae needed to evaluate the predictive distribution p ( t | x , X , T ) in which the latent variables and the model index are marginalized out. Use these formulae to highlight the difference between Bayesian averaging of different models and the use of latent variables within a single model.

14.2 ( ) The expected sum-of-squares error E AV for a simple committee model can be deﬁned by (14.10), and the expected error of the committee itself is given by (14.11). Assuming that the individual errors satisfy (14.12) and (14.13), derive the result (14.14).

14.3 ( ) www By making use of Jensen’s inequality (1.115), for the special case of the convex function f ( x ) = x 2 , show that the average expected sum-of-squares error E AV of the members of a simple committee model, given by (14.10), and the expected error E COM of the committee itself, given by (14.11), satisfy

$$
E _ { C O M } \leqslant E _ { A V } .
$$

14.4 ( ) By making use of Jensen’s in equality (1.115), show that the result (14.54) derived in the previous exercise hods for any error function E ( y ) , not just sum-ofsquares, provided it is a convex function of y .

14.5 ( ) www Consider a committee in which we allow unequal weighting of the constituent models, so that

$$
y _ { \text {COM} } ( x ) = \sum _ { m = 1 } ^ { M } \alpha _ { m } y _ { m } ( x ) . \\ \intertext { t h a t h the predictions y _ { \text {COM} } ( x ) \text { remain within sensible limits, sup-} }
$$

In order to ensure that the predictions y COM ( x ) remain within sensible limits, suppose that we require that they be bounded at each value of x by the minimum and maximum values given by any of the members of the committee, so that

$$
y _ { \min } ( x ) \leqslant y _ { C O M } ( x ) \leqslant y _ { \max } ( x ) .
$$

Show that a necessary and sufﬁcient condition for this constraint is that the coefﬁcients α m satisfy M

$$
\alpha _ { m } \geqslant 0 , \quad \sum _ { m = 1 } ^ { M } \alpha _ { m } = 1 .
$$
