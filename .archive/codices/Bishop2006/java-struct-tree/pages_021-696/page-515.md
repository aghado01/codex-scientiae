[Page 515]

Now, instead of ﬁxing λ and varying x, we can consider a particular x and then adjust λ until the tangent plane is tangent at that particular x. Because the y value of the tangent line at a particular x is maximized when that value coincides with its contact point, we have

f(x) = max

{λx − g(λ)}. (10.130)

λ

We see that the functions f(x) and g(λ) play a dual role, and are related through (10.129) and (10.130).

Let us apply these duality relations to our simple example f(x) = exp(−x). From (10.129) we see that the maximizing value of x is given by ξ = −ln(−λ), and back-substituting we obtain the conjugate function g(λ) in the form

g(λ) = λ − λln(−λ) (10.131)

as obtained previously. The function λξ −g(λ) is shown, for ξ = 1 in the right-hand plot in Figure 10.10. As a check, we can substitute (10.131) into (10.130), which gives the maximizing value of λ = −exp(−x), and back-substituting then recovers the original function f(x) = exp(−x).

For concave functions, we can follow a similar argument to obtain upper bounds, in which max’ is replaced with ‘min’, so that

{λx − g(λ)} (10.132) g(λ) = min

f(x) = min

λ

{λx − f(x)}. (10.133)

x

If the function of interest is not convex (or concave), then we cannot directly apply the method above to obtain a bound. However, we can ﬁrst seek invertible transformations either of the function or of its argument which change it into a convex form. We then calculate the conjugate function and then transform back to the original variables.

An important example, which arises frequently in pattern recognition, is the logistic sigmoid function deﬁned by

1 1 + e−x. (10.134)

σ(x) =

As it stands this function is neither convex nor concave. However, if we take the logarithm we obtain a function which is concave, as is easily veriﬁed by ﬁnding the

Exercise 10.30 second derivative. From (10.133) the corresponding conjugate function then takes

the form

{λx − f(x)} = −λlnλ − (1 − λ)ln(1 − λ) (10.135)

g(λ) = min

x

which we recognize as the binary entropy function for a variable whose probability Appendix B of having the value 1 is λ. Using (10.132), we then obtain an upper bound on the log

sigmoid

lnσ(x) � λx − g(λ) (10.136)
