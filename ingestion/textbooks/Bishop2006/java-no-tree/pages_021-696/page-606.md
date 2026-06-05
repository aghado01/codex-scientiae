[Page 606]

![image 143](../../../../../images/imageFile143.png)

###### 586 12. CONTINUOUS LATENT VARIABLES

to compute in O(D) steps), which is convenient because often M « D. Similarly,

the M-step equations take the form

Exercise 12.22

##### [~(x"-XllllIZn]"] [~Ill[Znz~I]-'

###### w

new

- (12.69)
- (12.70)


diag{s-W.'w~~1ll[Zn](Xn_xl"}

where the 'diag' operator sets all of the nondiagonal elements of a matrix to zero. A Bayesian treatment of the factor analysis model can be obtained by a straightforward application of the techniques discussed in this book.

Another difference between probabilistic PCA and factor analysis concerns their

- Exercise 12.25 different behaviour under transformations of the data set. For PCA and probabilistic PCA, if we rotate the coordinate system in data space, then we obtain exactly the same fit to the data but with the W matrix transformed by the corresponding rotation matrix. However, for factor analysis, the analogous property is that if we make a component-wise re-scaling of the data vectors, then this is absorbed into a corresponding re-scaling of the elements of \)i.


###### 12.3. Kernel peA

In Chapter 6, we saw how the technique of kernel substitution allows us to take an algorithm expressed in terms of scalar products of the form xT x' and generalize that algorithm by replacing the scalar products with a nonlinear kernel. Here we apply this technique of kernel substitution to principal component analysis, thereby obtaining a nonlinear generalization called kernel peA (Scholkopf et al., 1998).

Consider a data set {xn } of observations, where n = 1, ... ,N, in a space of dimensionality D. In order to keep the notation uncluttered, we shall assume that

weLnhaveXn=alreadyO. Thesubtractedfirst step isthetosampleexpressmeanconventionalfrom eachPCAof thein suchvectorsa formXn,thatso thatthe

data vectors {xn } appear only in the form of the scalar products x~X m . Recall that the principal components are defined by the eigenvectors Ui of the covariance matrix

SUi = AiUi (12.71) where i = 1, ... ,D. Here the D x D sample covariance matrix S is defined by

(12.72)

and the eigenvectors are normalized such that uTUi = 1.

Now consider a nonlinear transformation ¢(x) into an M -dimensional feature space, so that each data point X n is thereby projected onto a point ¢(xn ). We can
