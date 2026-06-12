[Page 584]

where the {Zni} depend on the particular data point, whereas the {bd are constants that are the same for all data points. We are free to choose the {Ui}, the {Zni}, and the {bd so as to minimize the distortion introduced by the reduction in dimensionality. As our distortion measure, we shall use the squared distance between the original data point X n and its approximation X n , averaged over the data set, so that our goal is to minimize N

$$
J = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \| \mathbf x _ { n } - \widetilde { \mathbf x } _ { n } \| ^ { 2 } .
$$

Consider first of all the minimization with respect to the quantities {Zni}. Substituting for X n , setting the derivative with respect to Znj to zero, and making use of the orthonormality conditions, we obtain

$$
z _ { n j } = x _ { n } ^ { T } \mathbf u _ { j }
$$

where j = 1, ... ,M. Similarly, setting the derivative of J with respect to b i to zero, and again making use of the orthonormality relations, gives

$$
b _ { j } = \overline { x } ^ { T } u _ { j }
$$

where j = M + 1, ... ,D. If we substitute for Zni and b i , and make use of the general expansion (12.9), we obtain

$$
x _ { n } - \widetilde { x } _ { n } = \sum _ { i = M + 1 } ^ { D } \left \{ ( x _ { n } - \overline { x } ) ^ { T } u _ { i } \right \} u _ { i }
$$

from which we see that the displacement vector from X n to x n lies in the space orthogonal to the principal subspace, because it is a linear combination of {ud for i = M + 1, ... , D, as illustrated in Figure 12.2. This is to be expected because the projected points x n must lie within the principal subspace, but we can move them freely within that subspace, and so the minimum error is given by the orthogonal projection.

We therefore obtain an expression for the distortion measure J as a function purely of the {ud in the form

$$
J = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \sum _ { i = M + 1 } ^ { D } \left ( x _ { n } ^ { T } u _ { i } - \overline { x } ^ { T } u _ { i } \right ) ^ { 2 } = \sum _ { i = M + 1 } ^ { D } u _ { i } ^ { T } S u _ { i } .
$$

There remains the task of minimizing J with respect to the {Ui}, which must be a constrained minimization otherwise we will obtain the vacuous result Ui = O. The constraints arise from the orthonormality conditions and, as we shall see, the solution will be expressed in terms of the eigenvector expansion of the covariance matrix. Before considering a formal solution, let us try to obtain some intuition about the result by considering the case of a two-dimensional data space D = 2 and a onedimensional principal subspace M = 1. We have to choose a direction U2 so as to
