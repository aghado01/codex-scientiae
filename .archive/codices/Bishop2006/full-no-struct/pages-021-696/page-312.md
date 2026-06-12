[Page 312]

Section 12.3

Section 6.3

closest example from the training set. These are examples of memory-based methods that involve storing the entire training set in order to make predictions for future data points. They typically require a metric to be deﬁned that measures the similarity of any two vectors in input space, and are generally fast to ‘train’ but slow at making predictions for test data points.

Many linear parametric models can be re-cast into an equivalent ‘dual representation’ in which the predictions are also based on linear combinations of a kernel function evaluated at the training data points. As we shall see, for models which are based on a ﬁxed nonlinear feature space mapping φ ( x ) , the kernel function is given by the relation T

$$
k ( x , x ^ { \prime } ) = \phi ( x ) ^ { T } \phi ( x ^ { \prime } ) .
$$

From this deﬁnition, we see that the kernel is a symmetric function of its arguments so that k ( x , x ) = k ( x , x ) . The kernel concept was introduced into the ﬁeld of pattern recognition by Aizerman et al. (1964) in the context of the method of potential functions, so-called because of an analogy with electrostatics. Although neglected for many years, it was re-introduced into machine learning in the context of largemargin classiﬁers by Boser et al. (1992) giving rise to the technique of support vector machines . Since then, there has been considerable interest in this topic, both in terms of theory and applications. One of the most signiﬁcant developments has been the extension of kernels to handle symbolic objects, thereby greatly expanding the range of problems that can be addressed.

The simplest example of a kernel function is obtained by considering the identity mapping for the feature space in (6.1) so that φ ( x ) = x , in which case k ( x , x ) = x T x . We shall refer to this as the linear kernel.

The concept of a kernel formulated as an inner product in a feature space allows us to build interesting extensions of many well-known algorithms by making use of the kernel trick , also known as kernel substitution . The general idea is that, if we have an algorithm formulated in such a way that the input vector x enters only in the form of scalar products, then we can replace that scalar product with some other choice of kernel. For instance, the technique of kernel substitution can be applied to principal component analysis in order to develop a nonlinear variant of PCA (Sch¨ olkopf et al. , 1998). Other examples of kernel substitution include nearest-neighbour classiﬁers and the kernel Fisher discriminant (Mika et al. , 1999; Roth and Steinhage, 2000; Baudat and Anouar, 2000).

There are numerous forms of kernel functions in common use, and we shall encounter several examples in this chapter. Many have the property of being a function only of the difference between the arguments, so that k ( x , x ) = k ( x − x ) , which are known as stationary kernels because they are invariant to translations in input space. A further specialization involves homogeneous kernels, also known as radial basis functions , which depend only on the magnitude of the distance (typically Euclidean) between the arguments so that k ( x , x ) = k ( x − x ) . For recent textbooks on kernel methods, see Sch¨ olkopf and Smola (2002), Her-

For recent textbooks on kernel methods, see Sch¨ olkopf and Smola (2002), Herbrich (2002), and Shawe-Taylor and Cristianini (2004).
