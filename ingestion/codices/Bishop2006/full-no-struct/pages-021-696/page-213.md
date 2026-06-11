[Page 213]

$$
f ( a ) & = \left \{ \begin{array} { l l } + 1 , & a \geqslant 0 \\ - 1 , & a < 0 . \end{array} \\ \intertext { l l } \text {will typically include a bias, component } \varphi ( r ) & = 1 - \intertext { f ( a ) } \intertext { f ( a ) } \intertext { = } \left \{ \begin{array} { l l } + 1 , & a \geqslant 0 \\ - 1 , & a < 0 . \end{array}
$$

The vector φ ( x ) will typically include a bias component φ 0 ( x ) = 1 . In earlier discussions of two-class classiﬁcation problems, we have focussed on a target coding scheme in which t ∈ { 0 , 1 } , which is appropriate in the context of probabilistic models. For the perceptron, however, it is more convenient to use target values t = +1 for class C 1 and t = − 1 for class C 2 , which matches the choice of activation function.

The algorithm used to determine the parameters w of the perceptron can most easily be motivated by error function minimization. A natural choice of error function would be the total number of misclassiﬁed patterns. However, this does not lead to a simple learning algorithm because the error is a piecewise constant function of w , with discontinuities wherever a change in w causes the decision boundary to move across one of the data points. Methods based on changing w using the gradient of the error function cannot then be applied, because the gradient is zero almost everywhere.

We therefore consider an alternative error function known as the perceptron criterion . To derive this, we note that we are seeking a weight vector w such that patterns x n in class C 1 will have w T φ ( x n ) > 0 , whereas patterns x n in class C 2 have w T φ ( x n ) < 0 . Using the t ∈ {− 1 , +1 } target coding scheme it follows that we would like all patterns to satisfy w T φ ( x n ) t n > 0 . The perceptron criterion associates zero error with any pattern that is correctly classiﬁed, whereas for a misclassiﬁed pattern x n it tries to minimize the quantity − w T φ ( x n ) t n . The perceptron criterion is therefore given by

$$
E _ { P } ( w ) = - \sum _ { n \in \mathcal { M } } w ^ { T } \phi _ { n } t _ { n }
$$

![image 20](../images/imageFile20.png)

# Frank Rosenblatt

1928–1969

Rosenblatt’s perceptron played an important role in the history of machine learning. Initially, Rosenblatt simulated the perceptron on an IBM 704 computer at Cornell in 1957, but by the early 1960s he had built hardware that provided a direct, par-

special-purpose allel implementation of perceptron learning. Many of his ideas were encapsulated in “Principles of Neurodynamics: Perceptrons and the Theory of Brain Mechanisms” published in 1962. Rosenblatt’s work was criticized by Marvin Minksy, whose objections were published in the book “Perceptrons”, co-authored with

Seymour Papert. This book was widely misinterpreted at the time as showing that neural networks were fatally ﬂawed and could only learn solutions for linearly separable problems. In fact, it only proved such limitations in the case of single-layer networks such as the perceptron and merely conjectured (incorrectly) that they applied to more general network models. Unfortunately, however, this book contributed to the substantial decline in research funding for neural computing, a situation that was not reversed until the mid-1980s. Today, there are many hundreds, if not thousands, of applications of neural networks in widespread use, with examples in areas such as handwriting recognition and information retrieval being used routinely by millions of people.
