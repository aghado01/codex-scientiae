[Page 314]

Exercise 6.1

Exercise 6.2

If we substitute this back into the linear regression model, we obtain the following prediction for a new input x

$$
y ( x ) = w ^ { T } \phi ( x ) = a ^ { T } \Phi \phi ( x ) = k ( x ) ^ { T } \left ( K + \lambda I _ { N } \right ) ^ { - 1 } \text {t}
$$

where we have deﬁned the vector k ( x ) with elements k n ( x ) = k ( x n , x ) . Thus we see that the dual formulation allows the solution to the least-squares problem to be expressed entirely in terms of the kernel function k ( x , x ) . This is known as a dual formulation because, by noting that the solution for a can be expressed as a linear combination of the elements of φ ( x ) , we recover the original formulation in terms of the parameter vector w . Note that the prediction at x is given by a linear combination of the target values from the training set. In fact, we have already obtained this result, using a slightly different notation, in Section 3.3.3.

In the dual formulation, we determine the parameter vector a by inverting an N × N matrix, whereas in the original parameter space formulation we had to invert an M × M matrix in order to determine w . Because N is typically much larger than M , the dual formulation does not seem to be particularly useful. However, the advantage of the dual formulation, as we shall see, is that it is expressed entirely in terms of the kernel function k ( x , x ) . We can therefore work directly in terms of kernels and avoid the explicit introduction of the feature vector φ ( x ) , which allows us implicitly to use feature spaces of high, even inﬁnite, dimensionality.

The existence of a dual representation based on the Gram matrix is a property of many linear models, including the perceptron. In Section 6.4, we will develop a duality between probabilistic linear models for regression and the technique of Gaussian processes. Duality will also play an important role when we discuss support vector machines in Chapter 7.

# 6.2. Constructing Kernels

In order to exploit kernel substitution, we need to be able to construct valid kernel functions. One approach is to choose a feature space mapping φ ( x ) and then use this to ﬁnd the corresponding kernel, as is illustrated in Figure 6.1. Here the kernel function is deﬁned for a one-dimensional input space by

$$
k ( x , x ^ { \prime } ) = \phi ( x ) ^ { \text {T} } \phi ( x ^ { \prime } ) = \sum _ { i = 1 } ^ { M } \phi _ { i } ( x ) \phi _ { i } ( x ^ { \prime } ) \\
$$

where φ i ( x ) are the basis functions. An alternative approach is to

construct kernel functions directly. In this case, we must ensure that the function we choose is a valid kernel, in other words that it corresponds to a scalar product in some (perhaps inﬁnite dimensional) feature space. As a simple example, consider a kernel function given by

$$
k ( x , z ) = ( x ^ { \top } z ) ^ { 2 } .
$$
