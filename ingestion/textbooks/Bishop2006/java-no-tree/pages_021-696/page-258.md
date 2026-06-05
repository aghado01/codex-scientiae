[Page 258]

where cubic and higher terms have been omitted. Here b is deﬁned to be the gradient of E evaluated at w

b ≡ ∇E|w=wb (5.29) and the Hessian matrix H = ∇∇E has elements

∂E ∂wi∂wj w=wb

(H)ij ≡

. (5.30)

From (5.28), the corresponding local approximation to the gradient is given by

∇E b + H(w − w). (5.31)

For points w that are sufﬁciently close to w, these expressions will give reasonable approximations for the error and its gradient.

Consider the particular case of a local quadratic approximation around a point w that is a minimum of the error function. In this case there is no linear term, because ∇E = 0 at w , and (5.28) becomes

1 2

E(w) = E(w ) +

###### (w − w )TH(w − w ) (5.32)

where the Hessian H is evaluated at w . In order to interpret this geometrically, consider the eigenvalue equation for the Hessian matrix

Hui = λiui (5.33) where the eigenvectors ui form a complete orthonormal set (Appendix C) so that

uTi uj = δij. (5.34) We now expand (w − w ) as a linear combination of the eigenvectors in the form

###### w − w =

αiui. (5.35)

i

This can be regarded as a transformation of the coordinate system in which the origin is translated to the point w , and the axes are rotated to align with the eigenvectors (through the orthogonal matrix whose columns are the ui), and is discussed in more detail in Appendix C. Substituting (5.35) into (5.32), and using (5.33) and (5.34), allows the error function to be written in the form

1 2 i

E(w) = E(w ) +

λiαi2. (5.36)

A matrix H is said to be positive deﬁnite if, and only if,

vTHv > 0 for all v. (5.37)
