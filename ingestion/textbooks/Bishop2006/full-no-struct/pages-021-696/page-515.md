[Page 515]

Exercise 10.30

Appendix B

Now, instead of ﬁxing λ and varying x , we can consider a particular x and then adjust λ until the tangent plane is tangent at that particular x . Because the y value of the tangent line at a particular x is maximized when that value coincides with its contact point, we have

$$
f ( x ) = \max _ { \lambda } \left \{ \lambda x - g ( \lambda ) \right \} .
$$

We see that the functions f ( x ) and g ( λ ) play a dual role, and are related through (10.129) and (10.130).

Let us apply these duality relations to our simple example f ( x ) = exp( − x ) . From (10.129) we see that the maximizing value of x is given by ξ = − ln( − λ ) , and back-substituting we obtain the conjugate function g ( λ ) in the form

$$
g ( \lambda ) = \lambda - \lambda \ln ( - \lambda )
$$

as obtained previously. The function λξ − g ( λ ) is shown, for ξ = 1 in the right-hand plot in Figure 10.10. As a check, we can substitute (10.131) into (10.130), which gives the maximizing value of λ = − exp( − x ) , and back-substituting then recovers the original function f ( x ) = exp( − x ) . For concave functions, we can follow a similar argument to obtain upper bounds,

For concave functions, we can follow a similar argument to obtain upper bounds, in which max ' is replaced with ' min ', so that

$$
f ( x ) \ = \ \min _ { \lambda } \left \{ \lambda x - g ( \lambda ) \right \} \\ \\
$$

$$
g ( \lambda ) \ = \ \min _ { x } \{ \lambda x - f ( x ) \} .
$$

If the function of interest is not convex (or concave), then we cannot directly apply the method above to obtain a bound. However, we can ﬁrst seek invertible transformations either of the function or of its argument which change it into a convex form. We then calculate the conjugate function and then transform back to the original variables.

An important example, which arises frequently in pattern recognition, is the logistic sigmoid function deﬁned by

$$
\sigma ( x ) = \frac { 1 } { 1 + e ^ { - x } } .
$$

As it stands this function is neither convex nor concave. However, if we take the logarithm we obtain a function which is concave, as is easily veriﬁed by ﬁnding the second derivative. From (10.133) the corresponding conjugate function then takes the form

$$
g ( \lambda ) = \min _ { x } \{ \lambda x - f ( x ) \} = - \lambda \ln \lambda - ( 1 - \lambda ) \ln ( 1 - \lambda ) \quad ( 1 0 . 1 3 5 )
$$

which we recognize as the binary entropy function for a variable whose probability of having the value 1 is λ . Using (10.132), we then obtain an upper bound on the log sigmoid

$$
\ln \sigma ( x ) \leqslant \lambda x - g ( \lambda )
$$
