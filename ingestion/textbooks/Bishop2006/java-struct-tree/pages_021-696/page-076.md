[Page 76]

Figure 1.31 A convex function f(x) is one for which every chord (shown in blue) lies on or above the function (shown in red).

chord

f(x)

a xλ b x

xλ

and the corresponding value of the function is f (λa + (1 − λ)b). Convexity then implies

f(λa + (1 − λ)b) � λf(a) + (1 − λ)f(b). (1.114) This is equivalent to the requirement that the second derivative of the function be

Exercise 1.36 everywhere positive. Examples of convex functions are xlnx (for x > 0) and x2. A function is called strictly convex if the equality is satisﬁed only for λ = 0 and λ = 1. If a function has the opposite property, namely that every chord lies on or below the function, it is called concave, with a corresponding deﬁnition for strictly concave. If a function f(x) is convex, then −f(x) will be concave.

Exercise 1.38 Using the technique of proof by induction, we can show from (1.114) that a

convex function f(x) satisﬁes

f � M

λixi� �

�M

�

λif(xi) (1.115)

i=1

i=1

�

where λi � 0 and

i λi = 1, for any set of points {xi}. The result (1.115) is known as Jensen’s inequality. If we interpret the λi as the probability distribution over a discrete variable x taking the values {xi}, then (1.115) can be written

f (E[x]) � E[f(x)] (1.116)

where E[·] denotes the expectation. For continuous variables, Jensen’s inequality takes the form

f �� xp(x)dx� � � f(x)p(x)dx. (1.117)

We can apply Jensen’s inequality in the form (1.117) to the Kullback-Leibler divergence (1.113) to give

KL(p�q) = −� p(x)ln�

� dx � −ln� q(x)dx = 0 (1.118)

q(x) p(x)
