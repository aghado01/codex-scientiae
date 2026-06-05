[Page 584]

![image 121](../../../../../images/imageFile121.png)

###### 564 12. CONTINUOUS LATENT VARIABLES

where the {Zni} depend on the particular data point, whereas the {bd are constants that are the same for all data points. We are free to choose the {Ui}, the {Zni}, and the {bd so as to minimize the distortion introduced by the reduction in dimensionality. As our distortion measure, we shall use the squared distance between the original data point X n and its approximation Xn , averaged over the data set, so that our goal is to minimize

N

J = ~ L Ilxn - xn112.

(12.11)

n=l

Consider first of all the minimization with respect to the quantities {Zni}. Sub-

stituting for Xn , setting the derivative with respect to Znj to zero, and making use of the orthonormality conditions, we obtain

(12.12)

where j = 1, ... ,M. Similarly, setting the derivative of J with respect to bi to zero, and again making use of the orthonormality relations, gives

bj = -TX Uj (12.13)

where j = M +1, ... ,D. Ifwe substitute for Zni and bi, and make use ofthe general expansion (12.9), we obtain

D

Xn - Xn = L {(Xn - x)TudUi

(12.14)

i=M+l

from which we see that the displacement vector from Xn to x

n lies in the space orthogonal to the principal subspace, because it is a linear combination of {ud for i = M + 1, ... ,D, as illustrated in Figure 12.2. This is to be expected because the projected points xn must lie within the principal subspace, but we can move them freely within that subspace, and so the minimum error is given by the orthogonal projection.

We therefore obtain an expression for the distortion measure J as a function purely of the {ud in the form

###### J = N1 L~ ~L (T _T)2 D T

XnUi - X Ui = L Ui SUi.

(12.15)

n=l i=M+l i=M+l

There remains the task of minimizing J with respect to the {Ui}, which must be a constrained minimization otherwise we will obtain the vacuous result Ui = O. The constraints arise from the orthonormality conditions and, as we shall see, the solution will be expressed in terms of the eigenvector expansion of the covariance matrix. Before considering a formal solution, let us try to obtain some intuition about the result by considering the case of a two-dimensional data space D = 2 and a onedimensional principal subspace M = 1. We have to choose a direction U2 so as to
