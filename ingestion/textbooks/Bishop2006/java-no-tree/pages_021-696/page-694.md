[Page 694]

densities and the mixing coefﬁcients share the hidden units of the neural network. Furthermore, in the mixture density network, the splits of the input space are further relaxed compared to the hierarchical mixture of experts in that they are not only soft, and not constrained to be axis aligned, but they can also be nonlinear.

###### Exercises

- 14.1 ( ) www Consider a set models of the form p(t|x,zh,θh,h) in which x is the input vector, t is the target vector, h indexes the different models, zh is a latent variable for model h, and θh is the set of parameters for model h. Suppose the models have prior probabilities p(h) and that we are given a training set X = {x1,...,xN} and T = {t1,...,tN}. Write down the formulae needed to evaluate the predictive distribution p(t|x,X,T) in which the latent variables and the model index are marginalized out. Use these formulae to highlight the difference between Bayesian averaging of different models and the use of latent variables within a single model.

- 14.2 ( ) The expected sum-of-squares error EAV for a simple committee model can be deﬁned by (14.10), and the expected error of the committee itself is given by (14.11). Assuming that the individual errors satisfy (14.12) and (14.13), derive the result (14.14).
- 14.3 ( ) www By making use of Jensen’s inequality (1.115), for the special case of the convex function f(x) = x2, show that the average expected sum-of-squares error EAV of the members of a simple committee model, given by (14.10), and the expected error ECOM of the committee itself, given by (14.11), satisfy

ECOM EAV. (14.54)

- 14.4 ( ) By making use of Jensen’s in equality (1.115), show that the result (14.54) derived in the previous exercise hods for any error function E(y), not just sum-ofsquares, provided it is a convex function of y.
- 14.5 ( ) www Consider a committee in which we allow unequal weighting of the constituent models, so that


M

yCOM(x) =

αmym(x). (14.55)

m=1

In order to ensure that the predictions yCOM(x) remain within sensible limits, suppose that we require that they be bounded at each value of x by the minimum and maximum values given by any of the members of the committee, so that

ymin(x) yCOM(x) ymax(x). (14.56) Show that a necessary and sufﬁcient condition for this constraint is that the coefﬁcients αm satisfy

M

αm 0,

αm = 1. (14.57)

m=1
