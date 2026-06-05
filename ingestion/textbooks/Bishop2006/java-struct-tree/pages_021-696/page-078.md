[Page 78]

Thus we can view the mutual information as the reduction in the uncertainty about x by virtue of being told the value of y (or vice versa). From a Bayesian perspective, we can view p(x) as the prior distribution for x and p(x|y) as the posterior distribution after we have observed new data y. The mutual information therefore represents the reduction in uncertainty about x as a consequence of the new observation y.

Exercises

1.1 (�) www Consider the sum-of-squares error function given by (1.2) in which the function y(x,w) is given by the polynomial (1.1). Show that the coefﬁcients w = {wi} that minimize this error function are given by the solution to the following set of linear equations

�M

Aijwj = Ti (1.122)

j=0

where

�N

�N

Aij =

(xn)i+j, Ti =

(xn)itn. (1.123)

n=1

n=1

Here a sufﬁx i or j denotes the index of a component, whereas (x)i denotes x raised to the power of i.

1.2 (�) Write down the set of coupled linear equations, analogous to (1.122), satisﬁed

by the coefﬁcients wi which minimize the regularized sum-of-squares error function given by (1.4).

1.3 (��) Suppose that we have three coloured boxes r (red), b (blue), and g (green). Box r contains 3 apples, 4 oranges, and 3 limes, box b contains 1 apple, 1 orange, and 0 limes, and box g contains 3 apples, 3 oranges, and 4 limes. If a box is chosen at random with probabilities p(r) = 0.2, p(b) = 0.2, p(g) = 0.6, and a piece of fruit is removed from the box (with equal probability of selecting any of the items in the box), then what is the probability of selecting an apple? If we observe that the selected fruit is in fact an orange, what is the probability that it came from the green box?

1.4 (��) www Consider a probability density px(x) deﬁned over a continuous variable x, and suppose that we make a nonlinear change of variable using x = g(y), so that the density transforms according to (1.27). By differentiating (1.27), show that the location �y of the maximum of the density in y is not in general related to the location �x of the maximum of the density over x by the simple functional relation �x = g(�y) as a consequence of the Jacobian factor. This shows that the maximum of a probability density (in contrast to a simple function) is dependent on the choice of variable. Verify that, in the case of a linear transformation, the location of the maximum transforms in the same way as the variable itself.

1.5 (�) Using the deﬁnition (1.38) show that var[f(x)] satisﬁes (1.39).
