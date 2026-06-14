[Page 21]

is a group homomorphism; and (2) the composition of two maps g ◦ f induces the composition of the linear transformation: ( g ◦ f ) ∗ = g ∗ ◦ f ∗ .

## Appendix B. Background on Geometry

The development of Morse theory has been instrumental in classifying manifolds and represents a pathway between geometry and topology. A classic reference is Milnor [24].

For some smooth f : M → R , consider a point p ∈ M where in local coordinates the derivative vanishes, ∂f/∂x 1 = 0 , . . ., ∂f/∂x d = 0. Then that point is called a critical point, and the evaluation f ( p ) is called a critical value. A critical point p ∈ M is called non-degenerate if the Hessian ( ∂ 2 f/∂ i ∂ j ) is nonsingular. Such functions are called Morse functions.

Since the Hessian at a critical point is nondegenerate, there will be a mixture of positive and negative eigenvalues. Let η be the number of negative eigenvalues of the Hessian at a critical point called the Morse index. The basic Morse lemma states that at a critical point p ∈ M with index η and some neighborhood U of p , there exists local coordinates x = ( x 1 , . . ., x d ) so that x ( p ) = 0 and

$$
f ( q ) = f ( p ) - x _ { 1 } ( q ) ^ { 2 } - \cdots - x _ { \eta } ( q ) ^ { 2 } + x _ { \eta + 1 } ( q ) ^ { 2 } + \cdots x _ { d } ( q ) ^ { 2 }
$$

$$
= f ( p ) - x _ { 1 } ( q ) ^ { 2 } - \dots - x _ { \eta } ( q ) ^ { 2 } + x _ { \eta + 1 } ( q ) ^ { 2 } + \dots x _ { d } ( q ) ^ { 2 } \\
$$

for all q ∈ U . Based on this

result one is able to show that at a critical point p ∈ M , with f ( p ) = a say, that the sublevel set M f ≤ a has the same homotopy type as that of the sublevel set M f ≤ a − ε (for some small ε > 0) with an η -dimensional cell attached to it. In fact, for a compact M , its homotopy type is that of a cell complex with one η -dimensional cell for each critical point of index η . This cell complex is known as a CW complex in homotopy theory, if the cells are attached in the order of their dimension.

The famous set of Morse inequalities states that if β k is the k − th Betti number and m k is the number of critical points of index k , then

$$
b _ { 1 } \, \text { and } m _ { k } \, \text { is the number of critical points of index } \\ \beta _ { 0 } \, \text { } & \leq \, m _ { 0 } \\ \beta _ { 1 } - \beta _ { 0 } \, \text { } & \leq \, m _ { 1 } - m _ { 0 } \\ \beta _ { 2 } - \beta _ { 1 } + \beta _ { 0 } \, \text { } & \leq \, m _ { 2 } - m _ { 1 } + m _ { 0 } \\ & \cdots \\ \chi ( M ) = \sum _ { k = 0 } ^ { d } ( - 1 ) ^ { k } \beta _ { k } \, \ = \, \sum _ { k = 0 } ^ { d } ( - 1 ) ^ { k } m _ { k } \\ \chi \, \text { denotes the Euler characteristic.}
$$

where χ denotes the Euler characteristic.
