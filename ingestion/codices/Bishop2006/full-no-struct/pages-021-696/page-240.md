[Page 240]

We now apply the approximation σ ( a ) Φ( λa ) to the probit functions appearing on both sides of this equation, leading to the following approximation for the convolution of a logistic sigmoid with a Gaussian

$$
\text {agnostic sigmoid with a Gaussian} \\ \int \sigma ( a ) \mathcal { N } ( a | \mu , \sigma ^ { 2 } ) \, d a \simeq \sigma \left ( \kappa ( \sigma ^ { 2 } ) \mu \right ) \\ \intertext { v e f i n d e f } \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \quad \, \
$$

where we have deﬁned

$$
\kappa ( \sigma ^ { 2 } ) = ( 1 + \pi \sigma ^ { 2 } / 8 ) ^ { - 1 / 2 } .
$$

Applying this result to (4.151) we obtain the approximate predictive distribution in the form 2

p ( C 1 | φ , t ) = σ κ ( σ a ) µ a (4.155) where µ a and σ 2 a are deﬁned by (4.149) and (4.150), respectively, and κ ( σ 2 a ) is deﬁned by (4.154).

Note that the decision boundary corresponding to p ( C 1 | φ , t ) = 0 . 5 is given by µ a = 0 , which is the same as the decision boundary obtained by using the MAP value for w . Thus if the decision criterion is based on minimizing misclassiﬁcation rate, with equal prior probabilities, then the marginalization over w has no effect. However, for more complex decision criteria it will play an important role. Marginalization of the logistic sigmoid model under a Gaussian approximation to the posterior distribution will be illustrated in the context of variational inference in Figure 10.13.

# Exercises

4.1 ( ) Given a set of data points { x n } , we can deﬁne the convex hull to be the set of all points x given by

$$
x & = \sum _ { n } \alpha _ { n } x _ { n } \\ n & = 1 . \, \text {Consider a second set of points} \, \{ y _ { n } \} \, \text { together with}
$$

n where α n 0 and n α n = 1 . Consider a second set of points { y n } together with their corresponding convex hull. By deﬁnition, the two sets of points will be linearly separable if there exists a vector w and a scalar w 0 such that w T x n + w 0 > 0 for all x n , and w T y n + w 0 < 0 for all y n . Show that if their convex hulls intersect, the two sets of points cannot be linearly separable, and conversely that if they are linearly separable, their convex hulls do not intersect.

4.2 ( ) www Consider the minimization of a sum-of-squares error function (4.15), and suppose that all of the target vectors in the training set satisfy a linear constraint

$$
a ^ { T } t _ { n } + b = 0
$$

where t n corresponds to the n th row of the matrix T in (4.15). Show that as a consequence of this constraint, the elements of the model prediction y ( x ) given by the least-squares solution (4.17) also satisfy this constraint, so that

$$
a ^ { T } y ( x ) + b = 0 .
$$
