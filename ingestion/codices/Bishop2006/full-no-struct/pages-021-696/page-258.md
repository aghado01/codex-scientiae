[Page 258]

where cubic and higher terms have been omitted. Here b is deﬁned to be the gradient of E evaluated at w b ≡ ∇ E | w = b w (5.29) and the Hessian matrix H = ∇∇ E has elements

$$
\text {trix} \, H = \nabla \nabla E \, \text {has elements} \\ ( H ) _ { i j } \equiv \frac { \partial E } { \partial w _ { i } \partial w _ { j } } \Big | _ { w \equiv \widehat { w } } \cdot \\ \intertext { r e s p o n d i g n } \text {responding local approximation to the gradient is given by} \\ \nabla F \, _ { e } + \, U ( w _ { e } , \widehat { \widehat { w } } )
$$

From (5.28), the corresponding local approximation to the gradient is given by

∇ E /similarequal b + H ( w -̂ w ) . (5.31) For points w that are sufficiently close to ̂ w , these expressions will give reasonable approximations for the error and its gradient.

Consider the particular case of a local quadratic approximation around a point w /star that is a minimum of the error function. In this case there is no linear term, because ∇ E = 0 at w /star , and (5.28) becomes

$$
E ( w ) = E ( w ^ { * } ) + \frac { 1 } { 2 } ( w - w ^ { * } ) ^ { T } H ( w - w ^ { * } )
$$

where the Hessian H is evaluated at w . In order to interpret this geometrically, consider the eigenvalue equation for the Hessian matrix

$$
H u _ { i } = \lambda _ { i } u _ { i }
$$

where the eigenvectors u i form a complete orthonormal set (Appendix C) so that

$$
u _ { i } ^ { T } u _ { j } = \delta _ { i j } .
$$

We now expand ( w − w ) as a linear combination of the eigenvectors in the form

$$
w - w ^ { * } = \sum _ { i } \alpha _ { i } u _ { i } . \\ \intertext { a r t a s p r o m a t i o n } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D } } \intertext { w i t h s c r { D } } \intertext { s u n t r a g h s c r { D
$$

This can be regarded as a transformation of the coordinate system in which the origin is translated to the point w , and the axes are rotated to align with the eigenvectors (through the orthogonal matrix whose columns are the u i ), and is discussed in more detail in Appendix C. Substituting (5.35) into (5.32), and using (5.33) and (5.34), allows the error function to be written in the form

$$
E ( w ) = E ( w ^ { * } ) + \frac { 1 } { 2 } \sum _ { i } \lambda _ { i } \alpha _ { i } ^ { 2 } . \\ [ i s a i d t o b e n t i v e f i n t i v e f i n t a n d o w l y ]
$$

A matrix H is said to be positive deﬁnite if, and only if,

$$
v ^ { T } H v > 0 \quad \text {for all $v$.}
$$
