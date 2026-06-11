[Page 308]

$$
w _ { j } ^ { ( \tau ) } \simeq w _ { j } ^ { * } \ \text {when} \ \eta _ { j } \gg ( \rho \tau ) ^ { - 1 } & & ( 5 . 1 9 9 ) \\ ( \tau ) _ { 1 } & \dots & ( 1 + 1 ) ^ { 2 } & & ( - 1 ) ^ { 2 } \\
$$

$$
| w _ { j } ^ { ( \tau ) } | & \ll | w _ { j } ^ { * } | \quad \text {when } \eta _ { j } \ll ( \rho \tau ) ^ { - 1 } . \\ \vdots & \quad \ \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots
$$

Compare this result with the discussion in Section 3.5.3 of regularization with simple weight decay, and hence show that ( ρτ ) − 1 is analogous to the regularization parameter λ . The above results also show that the effective number of parameters in the network, as deﬁned by (3.91), grows as the training progresses.

5.26 ( ) Consider a multilayer perceptron with arbitrary feed-forward topology, which is to be trained by minimizing the tangent propagation error function (5.127) in which the regularizing function is given by (5.128). Show that the regularization term Ω can be written as a sum over patterns of terms of the form

$$
\Omega _ { n } = \frac { 1 } { 2 } \sum _ { k } ( \mathcal { G } y _ { k } ) ^ { 2 } \\ \intertext { a l $ o r $ a r $ o r $ d e f i n e $ d y $ } \left ( \begin{matrix} \Omega _ { n } = \frac { 1 } { 2 } \sum _ { k } ( \mathcal { G } y _ { k } ) ^ { 2 } & & ( 5 . 2 1 ) \\ \end{matrix} \right ) \\ \intertext { a l $ o r $ a r $ d e f i n e $ d y $ } \left ( \begin{matrix} 0 . 5 1 \\ 0 . 5 2 \end{matrix} \right )
$$

where G is a differential operator deﬁned by

$$
\mathcal { G } \equiv & \sum _ { i } \tau _ { i } \frac { \partial } { \partial x _ { i } } . \\ \text {propagation equations}
$$

By acting on the forward propagation equations

$$
\text {the forward propagation equations} \\ z _ { j } = h ( a _ { j } ) , \quad a _ { j } = \sum _ { i } w _ { j i } z _ { i } \\ \text {ator} \, \mathcal { G } , \text { show that } \Omega _ { n } \text { can be evaluated by forward propagation using}
$$

with the operator G , show that Ω n can be evaluated by forward propagation using the following equations:

$$
\begin{array} { c c } \arg \text {equalations} \colon \\ \alpha _ { j } = h ^ { \prime } ( \alpha _ { j } ) \beta _ { j } , & \beta _ { j } = \sum _ { i } w _ { j i } \alpha _ { i } . \\ \end{array} \quad ( 5 . 2 0 4 ) \\ \text {leave defined the new variables}
$$

where we have deﬁned the new variables

$$
\alpha _ { j } & \equiv \mathcal { G } z _ { j } , \quad \beta _ { j } \equiv \mathcal { G } a _ { j } . \\ \\ ( 1 - ( 1 + \alpha _ { j } ) ) & = \mathcal { G } z _ { j } , \quad \beta _ { j } \equiv \mathcal { G } a _ { j } .
$$

Now show that the derivatives of Ω n with respect to a weight w rs in the network can be written in the form

$$
\frac { \partial \Omega _ { n } } { \partial w _ { r s } } = \sum _ { k } \alpha _ { k } \left \{ \phi _ { k r } z _ { s } + \delta _ { k r } \alpha _ { s } \right \} \\ \text {defined}
$$

where we have deﬁned

$$
\delta _ { k r } \equiv \frac { \partial y _ { k } } { \partial a _ { r } } , \quad \phi _ { k r } \equiv \mathcal { G } \delta _ { k r } .
$$

Write down the backpropagation equations for δ kr , and hence derive a set of backpropagation equations for the evaluation of the φ kr .
