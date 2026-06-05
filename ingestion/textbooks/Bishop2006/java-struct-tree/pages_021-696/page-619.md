[Page 619]

![image 156](../../../../../images/imageFile156.png)

Exercises 599

bilistic foundation also makes it very straightforward to define generalizations of GTM (Bishop et al., 1998a) such as a Bayesian treatment, dealing with missing val-

Section 6.4 ues, a principled extension to discrete variables, the use of Gaussian processes to define the manifold, or a hierarchical GTM model (Tino and Nabney, 2002).

Because the manifold in GTM is defined as a continuous surface, not just at the prototype vectors as in the SOM, it is possible to compute the magnification factors corresponding to the local expansions and compressions of the manifold needed to fit the data set (Bishop et al., 1997b) as well as the directional curvatures of the manifold (Tino et al., 2001). These can be visualized along with the projected data and provide additional insight into the model.

Exercises

12.1 (**) lIB In this exercise, we use proof by induction to show that the linear projection onto an M -dimensional subspace that maximizes the variance of the projected data is defined by the M eigenvectors of the data covariance matrix S, given by (12.3), corresponding to the M largest eigenvalues. In Section 12.1, this result was proven for the case of M = 1. Now suppose the result holds for some general value of M and show that it consequently holds for dimensionality M + 1. To do this, first set the derivative of the variance of the projected data with respect to a vector UM+1 defining the new direction in data space equal to zero. This should be done subject to the constraints that UM+l be orthogonal to the existing vectors U1,"" UM, and also that it be normalized to unit length. Use Lagrange multipli-

Appendix E ers to enforce these constraints. Then make use of the orthonormality properties of the vectors U1,"" UM to show that the new vector UM+1 is an eigenvector of S. Finally, show that the variance is maximized if the eigenvector is chosen to be the one corresponding to eigenvector AM+1 where the eigenvalues have been ordered in decreasing value.

12.2 (**) Show that the minimum value of the PCA distortion measure J given by (12.15) with respect to the Ui, subject to the orthonormality constraints (12.7), is obtained when the Ui are eigenvectors of the data covariance matrix S. To do this, introduce a matrix H of Lagrange multipliers, one for each constraint, so that the modified distortion measure, in matrix notation reads

] = Tr{UTSU}+Tr{H(I - UTU)} (12.93) where Uis a m~trix of dimensio~D x (D - M) whose columns are gi:::..en b~Ui.

Now minimize J with respect to U and show that the s~ution satisfies SU = UH. Clearly, one possible solution is that the columns of U are eigenvectors of S, in which case H is a diagonal matrix containing the corresponding eigenvalues. To obtain the general solution, show that H can be assumed to be a symmetr~ ma~ix, and by using its eigenvect£r expansion show that the general solution to SU =~UH gives the same value for J as the specific solution in which the columns of U are
