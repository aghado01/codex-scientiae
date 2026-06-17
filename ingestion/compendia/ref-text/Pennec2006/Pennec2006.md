[Page 1]

![image 1](<Pennec2006/imageFile1.png>)

International Journal of Computer Vision 66(1), 41–66, 2006

©

+

c

2006 Springer Science

Business Media, Inc. Manufactured in The Netherlands.

DOI: 10.1007/s11263-005-3222-z

# A Riemannian Framework for Tensor Computing

# XAVIER PENNEC, PIERRE FILLARD AND NICHOLAS AYACHE

EPIDAURE/ASCLEPIOS Project-team, INRIA Sophia-Antipolis, 2004 Route des Lucioles BP 93, F-06902 Sophia Antipolis Cedex, France

Xavier.Pennec@sophia.inria.fr

Received August 4, 2004; Revised March 7, 2005; Accepted March 09, 2005

Abstract. Tensors are nowadays a common source of geometric information. In this paper, we propose to endow the tensor space with an afﬁne-invariant Riemannian metric. We demonstrate that it leads to strong theoretical properties: the cone of positive deﬁnite symmetric matrices is replaced by a regular and complete manifold without boundaries (null eigenvalues are at the inﬁnity), the geodesic between two tensors and the mean of a set of tensors are uniquely deﬁned, etc.

We have previously shown that the Riemannian metric provides a powerful framework for generalizing statistics to manifolds. In this paper, we show that it is also possible to generalize to tensor ﬁelds many important geometric data processing algorithms such as interpolation, ﬁltering, diffusion and restoration of missing data. For instance, most interpolation and Gaussian ﬁltering schemes can be tackled efﬁciently through a weighted mean computation. Linear and anisotropic diffusion schemes can be adapted to our Riemannian framework, through partial differential evolution equations, provided that the metric of the tensor space is taken into account. For that purpose, we provide intrinsic numerical schemes to compute the gradient and Laplace-Beltrami operators. Finally, to enforce the ﬁdelity to the data (either sparsely distributed tensors or complete tensors ﬁelds) we propose least-squares criteria based on our invariant Riemannian distance which are particularly simple and efﬁcient to solve.

Keywords: tensors, diffusion tensor MRI, regularization, interpolation, extrapolation, PDE, Riemannian manifold, afﬁne-invariant metric.

# 1. Introduction

Positive deﬁnite symmetric matrices (so-called tensors in this article) are often encountered in image processing, for instance as covariance matrices for characterizing statistics on deformations, or as an encoding of the principal diffusion directions in Diffusion Tensor Imaging (DTI). The measurements of these tensors is often noisy in real applications and we would like to perform estimation, smoothing and interpolation of ﬁelds of this type of features. The main problem is that the tensor space is a manifold that is not a vector space withtheusualadditivestructure.Assymmetricpositive deﬁnite matrices constitute a convex half-cone in the vector space of matrices, many usual operations (like

In previous works (Pennec, 1996; Pennec and Ayache, 1998), we used invariance requirements to develop some basic probability tools on transformation groups and homogeneous manifolds. This statistical framework was then reorganized and extended in Pennec (1999, 2004) for general Riemannian manifolds, invariance properties leading in some case to a natural choice for the metric. In this paper, we show how this theory can be applied to tensors, leading to a new intrinsic computing framework for these geometric features with many important theoretical properties as well as practical computing properties.

[Page 2]

In the remaining of this section, we quickly investigate some connected works on tensors. Then, we summarize in Section 2 the main ideas of the statistical framework we developed on Riemannian manifolds. The aim is to exemplify the fact that choosing a Riemannian metric “automatically” determines a powerful framework to work on the manifold through the introduction of a few tools from differential geometry. In order to use this Riemannian framework on our tensor manifold, we propose in Section 3 an afﬁne-invariant Riemannian metric on tensors. We demonstrate that it leads to very strong theoretical properties, as well as some important practical algorithms such as an intrinsic geodesic gradient descent. Section 4 focuses on the application of this framework to an important geometric data processing problem: interpolation of tensor values. We show that this problem can be tackled efﬁciently through a weighted mean optimization. However, if weights are easy to deﬁne for regularly sampled tensors (e.g. for linear or tri-linear interpolation), the problem proved to be more difﬁcult for irregularly sampled values.

With Section 5 , we turn to tensors ﬁeld computing, and more particularly ﬁltering. If the Gaussian ﬁltering may still be deﬁned through weighted means, the partial differential equation (PDE) approach is slightly more complex. In particular, the metric of the tensor space has to be taken into account when computing the magnitude of the spatial gradient of the tensor ﬁeld. Thanks to our Riemannian framework, we propose efﬁcient numerical schemes to compute the gradient, its amplitude, and the Laplace-Beltrami operator used in linear diffusion. We also propose an adjustment of this manifold Laplacian that realizes an anisotropic ﬁltering. Finally, Section 6 focuses on simple statistical approaches to regularize and restore missing values in tensor ﬁelds. Here, the use of the Riemannian distance inherited from the chosen metric is fundamental to deﬁne least-squares data attachment criteria for dense and sparsely distributed tensor ﬁelds that lead to simple implementation schemes in our intrinsic computing framework.

# 1.1. Related Work

Quite an impressive literature has now been issued on the estimation and regularization of tensor ﬁelds, especially in the context of Diffusion Tensor Imaging (DTI)(Basseretal., 1994 ;LeBihanetal., 2001 ;Westin et al., 2002 ). Most of the works dealing with the geometric nature of the tensors has been performed for the discontinuity-preserving regularization of the tensor ﬁelds using Partial Differential Equations (PDEs). For instance, Coulon et al. ( 2004 ) anisotropically restores the principal direction of the tensor, and uses this regularized directions map as an input for the anisotropic regularization of the eigenvalues. A quite similar idea is adopted in Tschumperle ( 2002 ), where a spectral decomposition W ( x ) = U ( x ) D ( x ) U ( x ) T of the tensor ﬁeld is performed at each points to independently regularize the eigenvalues and eigenvectors (orientations). This approach requires an additional reorientation step of the rotation matrices due to the non-uniqueness of the decomposition (each eigenvector is deﬁned up its sign and there may be joint permutations of the eigenvectors and eigenvalues) in order to avoid the creation of artiﬁcial discontinuities. Another problem arises when two or more eigenvalues become equal: a whole subspace of unit eigenvectors is possible, and even a re-orientation becomes difﬁcult. An intrinsic integration scheme for PDEs that uses the exponential map has been added in Chefd’hotel et al. ( 2002 ), and allows to perform PDEs evolution on the considered manifold without re-projections. In essence, this is an inﬁnitesimal version of the intrinsic gradient descent technique on manifolds we introduced in Pennec ( 1996 , 1999 ) for the computation of the mean.

The afﬁne-invariant Riemannian metric we detail in Section 3.3 may be traced back to the work of Nomizu ( 1954 ) on afﬁne invariant connections on homogeneous spaces. It is implicitly hidden under very general theorems on symmetric spaces in many differential geometry textbooks (Kobayashi and Nomizu 1969 ; Helgason 1978 ; Gamkrelidze, 1991 ) and sometimes considered as a well known result as in Bhatia ( 2003 ). In statistics, it has been introduced as the Fisher information metric (Skovgaard, 1984 ) to model the geometry of the multivariate normal family. The idea of the invariant metric came to the mind of the ﬁrst author during the IPMI conference in 2001 (Coulon et al., 2001 ; Batchelor et al., 2001 ), as an application to diffusion tensor imaging (DTI) of the statistical methodology on Riemannian manifolds previously developed

[Page 3]

(and summarized in the next Section). However, this idea was not exploited until the end of 2003, when the visit of P. Thompson (UCLA, USA) raised the need to interpolate tensors that represent the variability from speciﬁc locations on sulci to the whole volume. The expertise of the second author on DTI (Fillard et al., 2003 ) provided an ideal alternative application ﬁeld. During the writing of this paper, we discovered that the invariant metric has been independently proposed by F¨ orstner and Moonen ( 1999 ) to deal with covariance matrices, and very recently by Fletcher and Joshi ( 2004 ) for the analysis of principal modes of sets of diffusion tensors. By looking for a suitable metric on the space of Gaussian distributions for the segmentation of diffusion tensor images, Lenglet et al. ( 2004a , b ) also end-up with the same metric. It is interesting to see that completely different approaches, relying on an afﬁne-invariant requirement on the one hand, and relying on an information measure to evaluate the distance between distributions on the other hand, lead to the same metric on the tensor space. However, to our knowledge, this Riemannian metric has not been promoted as a complete computing framework, as we propose in this paper.

This is a continuous collection of scalar products on the tangent space at each point of the manifold. Thus, if we consider a curve on the manifold, we can compute at each point its instantaneous speed vector and its norm, the instantaneous speed. To compute the length of the curve, we can proceed as usual by integrating this value along the curve. The distance between two pointsofaconnectedRiemannianmanifoldistheminimum length among the curves joining these points. The curves realizing this minimum for any two points of the manifold are called geodesics. The calculus of variations shows that geodesics are the solutions of a system of second order differential equations depending on the Riemannian metric. In the following, we assume that the manifold is geodesically complete , i.e., that the definition domain of all geodesics can be extended to R . This means that the manifold has no boundary nor any singular point that we can reach in a ﬁnite time. As an important consequence, the Hopf-Rinow-De Rham theorem states that there always exists at least one minimizing geodesic between any two points of the manifold (i.e., whose length is the distance between the two points).

# 2. Statistics on Geometric Features

We summarize in this Section the theory of statistics on Riemannian manifolds developed in Pennec ( 1999 , 2004 ). The aim is to exemplify the fact that choosing a Riemannian metric “automatically” determines a powerful framework to work on the manifold through the use of a few tools from differential geometry.

In the geometric framework, one can specify the structure of a manifold M by a Riemannian metric .

# 2.1. Exponential Chart

Let x be a point of the manifold that we consider as a local reference and − → xy a vector of the tangent space T x M at that point. From the theory of second order differential equations, we know that there exists one and only one geodesic starting from that point with this tangent vector. This allows to develop the manifold in the tangent space along the geodesics (think of rolling a sphere along its tangent plane at a given point). The geodesics going through the reference point are transformed into straight lines and the distance along these

![In this image, we can see a diagram with some lines and points. There are some lines and points in the diagram.](<Pennec2006/imageFile2.png>)

Tx M

M

Y

Figure 1. Left : The tangent planes at points x and y of the sphere S 2 are different: the vectors v and w of T x M cannot be compared to the vectors t and u of T y M . Thus, it is natural to deﬁne the scalar product on each tangent plane. Right : The geodesics starting at x are straight lines in the exponential map and the distance along them is conserved.

[Page 4]

of x . Thefunctionthatmapstoeachvector − → xy ∈ T x M the point y of the manifold that is reached after a unit time by the geodesic starting at x with this tangent vector is called the exponential map . This map is deﬁned in the whole tangent space T x M (since the manifold is geodesically complete) but it is generally one-toone only locally around 0 in the tangent space (i.e., around x in the manifold). In the sequel, we denote by − → xy = log x ( y )theinverseoftheexponential map: thisis the smallest vector such that y = exp x ( − → xy ). If we look for the maximal deﬁnition domain, we ﬁnd out that it is a star-shaped domain delimited by a continuous curve C x called the tangential cut-locus . The image of C x by the exponential map is the cut locus C x of point x . This is the closure of the set of points where several minimizing geodesics starting from x meet. On the sphere S 2 (1) for instance, the cut locus of a point x is its antipodal point and the tangential cut locus is the circle of radius π .

The exponential map within this domain realizes a chart called the exponential chart . It covers all the manifold except the cut locus of the reference point x , which has a null measure. In this chart, geodesics starting from x are straight lines, and the distance from the reference point are conserved. This chart is somehow the “most linear” chart of the manifold with respect to the reference point x .

# 2.2. Practical Implementation

In fact, most of the usual operations using additions and subtractions may be reinterpreted in a Riemannian frameworkusingthenotionof bipoint , anantecedentof vector introduced during the 19th Century. Indeed, one deﬁnes vectors as equivalent classes of bipoints (oriented couples of points) in a Euclidean space. This is possible because we have a canonical way (the translation) to compare what happens at two different points. In a Riemannian manifold, we can still compare things locally (by parallel transportation), but not any more globally. This means that each “vector” has to remember at which point of the manifold it is attached, which comes back to a bipoint.

However, one can also see a vector − → xy (attached at point x ) as a vector of the tangent space at that point. Such a vector may be identiﬁed to a point on the manifold using the geodesic starting at x with tangent vector − → xy , i.e., using the exponential map: y = exp x ( − → xy ).

Table 1. Re-interpretation of basic standard operations in a Riemannian manifold.

| |Vector space|Riemannian manifold|
|---|---|---|
|Subtraction|− → xy = y − x|− → xy = log x ( y )|
|Addition|y = x + - → xy|y = exp x ( - → xy )|
|Distance|dist( x , y ) = ‖ y - x ‖|dist( x , y ) = ‖ - → xy ‖ x|
|Mean value (implicit)|∑ i - → ¯ xx i = 0|∑ i log ¯ x ( x i ) = 0|
|Gradient descent|( t ) = x 1 + t − → x 1 x 2|x t + ε = exp x t ( - ε ∇ C ( x t ))|
|Linear (geodesic) interpolation|x ( t ) = x 1 + t - - → x 1 x 2|x ( t ) = exp x 1 ( t - - → x 1 x 2 )|


Conversely, the logarithmic map may be used to map almost any bipoint ( x , y ) into a vector − → xy = log x ( y ) of T x M . This reinterpretation of addition and subtraction using logarithmic and exponential maps is very powerful to generalize algorithms working on vector spaces to algorithms on Riemannian manifolds, as illustrated by Table 1 . It is also very powerful in terms of implementation since we can practically express all the geometric operations in these terms: the implementationoflog x andexp x isthebasisofanyprogrammingon Riemannian manifolds, as we will see in the following.

# 2.3. Basic Statistical Tools

The Riemannian metric induces an inﬁnitesimal volume element on each tangent space, and thus a measure d M on the manifold that can be used to measure random events on the manifold and to deﬁne the probability density function (if it exists) of these random elements. It is worth noticing that the induced measure d M represents the notion of uniformity according to the chosen Riemannian metric. This automatic derivation of the uniform measure from the metric gives a rather elegant solution to the Bertrand paradox for geometric probabilities (Poincar´ e, 1912 ; Kendal and Moran, 1963 ). However, the problem is only shifted: which Riemannian metric do we have to choose? We address this question in Section 3 for real positive definite symmetric matrices (tensors): it turns out that requiring an invariance by the full linear group will lead to a very regular and convenient manifold structure.

Let us come back to the basic statistical tools. With the probability measure of a random element, we can integrate functions from the manifold to any vector space, thus defining the expected value of this function. However, we generally cannot integrate manifoldvalued functions. Thus, one cannot define the mean or expected 'value' of a random manifold element using a weighted sum or an integral as usual. One solution is to rely on a distance-based variational formulation: the Fr´ echet or Karcher expected features basically minimize globally (or locally) the variance. As the mean is now defined through a minimization procedure, its existence and uniqueness are not ensured any more (except for distributions with a sufficiently small compact support). In practice, one mean value almost always exists, and it is unique as soon as the distribution is sufficiently peaked. The properties of the mean are very similar to those of the modes (that can be defined as central Karcher values of order 0) in the vectorial case.

[Page 5]

To compute the mean value, we designed in Pennec ( 1999 , 2004 ) an original Gauss-Newton gradient descent algorithm that essentially alternates the computation of the barycenter in the exponential chart centered at the current estimation of the mean value, and a recentering step of the chart at the point of the manifold that corresponds to the computed barycenter (geodesic marching step). To deﬁne higher moments of the distribution,weusedtheexponentialchartatthemeanpoint: the random feature is thus represented as a random vector with null mean in a star-shaped domain. With this representation, there is no difﬁculty to deﬁne the covariance matrix and potentially higher order moments. Based on this covariance matrix, we deﬁned a Mahalanobis distance between a random and a deterministic feature that basically weights the distance between the deterministic feature and the mean feature using the inverse of the covariance matrix. Interestingly, the expected Mahalanobis distance of a random element with itself is independent of the distribution and is equal to the dimension of the manifold, as in the vectorial case.

As for the mean, we chose in Pennec ( 1996 , 1999 , 2004 ) a variational approach to generalize the Normal Law: we deﬁne it as the distribution that minimizes the information knowing the mean and the covariance. This amounts to consider a Gaussian distribution on the exponential chart centered at the mean point that is truncated at the cut locus (if there is one). However, the relation between the concentration matrix (the “metric” used in the exponential of the probability density function) and the covariance matrix is slightly more complex than the simple inversion of the vectorial case, as it has to be corrected for the curvature of

# 3. Working on the Tensor Space

Let us now focus on the space S ym + n of positive deﬁnite symmetric matrices (tensors). The goal is to ﬁnd a Riemannian metric with interesting enough properties. It turns out that it is possible to require an invariance by the full linear group (Section 3.3 ). This leads to a very regular manifold structure where tensors with null and inﬁnite eigenvalues are both at an inﬁnite distance of any positive deﬁnite symmetric matrix: the cone of positive deﬁnite symmetric matrices is replaced by a space which has an inﬁnite development in each of its n ( n +1)/2 directions. Moreover, there is one and only one geodesic joining any two tensors, and we can even deﬁne globally consistent orthonormal coordinate systems of tangent spaces. Thus, the structure we obtain is very close to a vector space, except that the space is curved.

# 3.1. Exponential, Logarithm and Square Root of Tensors

In the following, we will make an extensive use of a few functions on symmetric matrices. The exponential of any matrix can be deﬁned using the series exp( A ) =   +∞ k = 0 A k k ! . In the case of symmetric matrices, we have some important simpliﬁcations. Let W = U D U T be a diagonalization, where U is an orthonormal matrix, and D = DIAG( d i ) is the diagonal matrix of the eigenvalues. We can write any power of W in the same basis: W k = U D k U T . This means that we may factor out the rotation matrices in the series and map the exponential individually to each eigenvalue:

$$
\exp ( W ) = \sum _ { k = 0 } ^ { + \infty } \frac { W ^ { k } } { k ! } = U \ D I A G ( \exp ( d _ { i } ) ) \, U ^ { T } .
$$

The series defining the exponential function converges for any (symmetric) matrix argument, but this is generally not the case for the series defining its inverse function: the logarithm. However, any tensor can be diagonalized into /Sigma1 = U DIAG( di ) U T with strictly positive eigenvalues di . Thus, the function

[Page 6]

$$
\log ( \Sigma ) = U \left ( D I A G ( \log ( d _ { i } ) ) \right ) U ^ { \top }
$$

is always well deﬁned on tensors. Moreover, if all the eigenvalues are small enough (| d i − 1| < 1), then the series deﬁning the usual log converges and we have:

$$
log ( \Sigma ) & = U \left ( D i A G \left ( \sum _ { k = 1 } ^ { + \infty } \frac { ( - 1 ) ^ { k + 1 } } { k } ( d _ { i } - 1 ) ^ { k } \right ) \right ) U ^ { T } & \quad \text {dist} \\ & = \sum _ { k = 1 } ^ { + \infty } \frac { ( - 1 ) ^ { k + 1 } } { k } ( \Sigma - I d ) ^ { k } . & ( 1 ) \\ \\ \text {The logarithm we defined is obviously the inverse func} .
$$

Thelogarithmwedeﬁnedisobviouslytheinversefunction of exp. Thus, the matrix exponential realizes a one-to-one mapping between the space of symmetric matrices to the space of tensors.

Classically, one deﬁnes the (left) square root of a matrix B as the set { B 1 / 2 L } = { A ∈ GL n / AA T = B } . One could also deﬁne the right square root: { B 1 / 2 R } = { A ∈ GL n / A T A = B } . For tensors, we deﬁne the square root as:

$$
\Sigma ^ { 1 / 2 } = \{ \Lambda \in \mathcal { S } y m _ { n } ^ { + } / \Lambda ^ { 2 } = \Sigma \} .
$$

Thesquarerootisalwaysdeﬁnedandmoreoverunique: let   = UD 2 U T be a diagonalization (with positives values for the d i ’s). Then   = U DU T is of course a square root of   , which proves the existence. For the uniqueness, let us consider two symmetric and positive square roots   1 and   2 of   . Then,   2 1 =   and   2 2 =   obviously commute and thus they can be diagonalized in the same basis: this means that the diagonal matrices D 2 1 and D 2 2 are equal. As the elements of D 1 and D 2 are positive, they are also equal and   1 =   2 . Last but not least, we have the property that

$$
\Sigma ^ { 1 / 2 } = \exp \left ( \frac { 1 } { 2 } ( \log \Sigma ) \right ) .
$$

# 3.2. An Afﬁne Invariant Distance

Let us consider the following action of the linear group GL n on the tensor space S ym + n :

$$
A * \Sigma = A \Sigma A ^ { T } \ \forall A \in G L _ { n } \ \text { and } \ \Sigma \in \mathcal { S } y m _ { n } ^ { + } .
$$

This action is naturally extended to tangent vectors is the same way: if   ( t ) =   + t W + O ( t 2 ) is a curve passing at   with tangent vector W , then the curve A ∗   ( t ) = A   A T + t A W A T + O ( t 2 ) passes through A *   with tangent vector A * W .

Following Pennec and Ayache, ( 1998 ), any invariant distance on S ym + n veriﬁes dist( A ∗   1 , A ∗   2 ) = dist(   1 ,  2 ). Choosing A =   − 1 / 2 1 , we can reduce this to a pseudo-norm, or distance to the identity:

$$
d i s t ( \Sigma _ { 1 } , \Sigma _ { 2 } ) & = d i s t ( I d , \Sigma _ { 1 } ^ { - \frac { 1 } { 2 } } \Sigma _ { 2 } \Sigma _ { 1 } ^ { - \frac { 1 } { 2 } } ) \\ & = N \left ( \Sigma _ { 1 } ^ { - \frac { 1 } { 2 } } \Sigma _ { 2 } \Sigma _ { 1 } ^ { - \frac { 1 } { 2 } } \right ) . \\
$$

Moreover,astheinvariancehastoholdforanytransformation, N should be invariant under the action of the isotropy group H (Id) = O n = { U ∈ GL n / UU T = Id } :

$$
\forall U \in O _ { n } , \ N ( U \ \Sigma \ U ^ { \top } ) = N ( \Sigma ) .
$$

Using the spectral decomposition   = UD 2 U T , it is easy to see that N (   ) has to be a symmetric function of the eigenvalues. Moreover, the symmetry of the distance dist (   , Id) = dist (Id,   ) imposes that N (   ) = N (   ( − 1) ). Thus, a good candidate is the sum of the squared logarithms of the eigenvalues:

$$
N ( \Sigma ) ^ { 2 } = \| \log ( \Sigma ) \| ^ { 2 } = \sum _ { i = 1 } ^ { n } ( \log ( \sigma _ { i } ) ) ^ { 2 } . \quad ( 2 ) \\
$$

This “norm” veriﬁes by construction the symmetry and positiveness. N (   ) = 0 implies that σ i = 1 (and conversely), so that the separation axiom is veriﬁed. However, we do not know any simple proof of the triangle inequality, which should read N (   1 ) + N (   2 ) ≥ N (   − 1 / 2 1   2   − 1 / 2 1 ), even if we can verify it experimentally (see e.g. F¨ orstner and Moonen, 1999 ).

# 3.3. An Invariant Riemannian Metric

Another way to determine the invariant distance is through the Riemannian metric. Let us take the most simple scalar product on the tangent space at the identity matrix: if W 1 and W 2 are tangent vectors (i.e., symmetric matrices, not necessarily definite nor positive), we define the scalar product to be the standard matrix scalar product 〈 W 1 | W 2 〉 = Tr( W T 1 W 2). This scalar product if obviously invariant by the isotropy group On . Now, if W 1 and W 2 are two tangent vectors at /Sigma1 , we require their scalar product to be invariant by the action of any transformation: 〈 W 1 | W 2 〉 /Sigma1 = 〈 A ∗ W 1 | A ∗ W 2 〉 A ∗ /Sigma1 . This should be true in particular for A = /Sigma1 -1 / 2 , which allows us to define the scalar product at any /Sigma1 from the scalar product at the identity:

[Page 7]

$$
\langle W _ { 1 } \, | \, W _ { 2 } \rangle _ { \Sigma } & = \langle \Sigma ^ { - \frac { 1 } { 2 } } W _ { 1 } \Sigma ^ { - \frac { 1 } { 2 } } \, | \, \Sigma ^ { - \frac { 1 } { 2 } } W _ { 2 } \Sigma ^ { - \frac { 1 } { 2 } } \rangle _ { I d } \\ & = \text {Tr} \left ( \Sigma ^ { - \frac { 1 } { 2 } } W _ { 1 } \Sigma ^ { - 1 } W _ { 2 } \Sigma ^ { - \frac { 1 } { 2 } } \right ) .
$$

One can easily verify that this deﬁnition is left unchanged if we use any other transformation A = U   − 1 / 2 (where U is a free orthonormal matrix) that transports   to the identity: A ∗   = A   A T = U U T = Id. To ﬁnd the geodesic without going though the com-

putation of Christoffel symbols, we may rely on a result from differential geometry (Gamkrelidze, 1991 ; Helgason, 1978 ; Kobayashi and Nomizu, 1969 ) which says that the geodesics for the invariant metrics on afﬁne symmetric spaces are generated by the action of the one-parameter subgroups of the acting Lie group. 1 Since the one-parameter subgroups of the linear group are given by the matrix exponential exp( t A ), geodesics on our tensor manifold going through   with tangent vector W should have the following form:

$$
\Gamma _ { ( \Sigma , W ) } ( t ) & = \exp ( t \ A ) \ \Sigma \ \exp ( t \ A ) ^ { T } \\ \text {with} \quad W & = A \ \Sigma + \Sigma \ A ^ { T } . \quad \quad \text {($(3)$} \\
$$

For our purpose, we need to relate explicitly the geodesic to the tangent vector in order to deﬁne the exponential chart. Since   is a symmetric matrix, there is hopefully an explicit solution to the Sylvester equation W = A   +   A T . We get A = 1 2   W   ( − 1) +   1 / 2 Z   − 1 / 2   , where Z is a free skew-symmetric matrix. However, introducing this solution into the equation of geodesics (Eq. ( 3 )) does not lead to a very tractable expression. Let us look at an alternative solution.

Since our metric (and thus the geodesics) is invariant under the action of the group, we can focus on the geodesics going through the origin (the identity). In that case, a symmetric solution of the Sylvester equation is A = 1 2 W , which gives the following equation

$$
\ p y \quad \Gamma _ { ( I d , W ) } ( t ) = \exp \left ( \frac { t } { 2 } \ W \right ) \exp \left ( \frac { t } { 2 } \ W \right ) ^ { T } = \exp ( t \ W ) .
$$

We may observe that the tangent vector along this curve is the parallel transportation of the initial tangent vector. If W = U DIAG( w i ) U T , d   ( t ) 1 1

$$
\begin{array} { r l } & { \frac { d \Gamma ( t ) } { d t } = U \ D I A G \left ( w _ { i } \exp ( t \ w _ { i } ) \right ) U ^ { T } = \Gamma ( t ) ^ { \frac { 1 } { 2 } } \ W \Gamma ( t ) ^ { \frac { 1 } { 2 } } } \\ & { = \Gamma ( t ) ^ { \frac { 1 } { 2 } } * W . } \end{array}
$$

By deﬁnition of our invariant metric, the norm of this vector is constant:     ( t ) 1 2 ∗ W   2   ( t ) 1 2 ∗ Id =   W   2 Id =   W   2 2 . This was expected since geodesics are parameterized by arc-length. Thus, the length of the curve between time 0 and 1 is

$$
\mathcal { L } = \int _ { 0 } ^ { 1 } \left \| \frac { d \Gamma ( t ) } { d t } \right \| _ { \Gamma ( t ) } ^ { 2 } d t = \| W \| _ { I d } ^ { 2 } .
$$

Solving for   (Id , W ) (1) =   , we obtain the “norm” N (   ) of Eq. ( 2 ). Using the invariance of our metric, we easily obtain the geodesic starting from any other point of the manifold using our group action:

$$
\Gamma _ { ( \Sigma , W ) } ( t ) & = \Sigma ^ { \frac { 1 } { 2 } } * \Gamma _ { ( I d , \Sigma ^ { - 1 / 2 } * W ) } ( t ) \\ & = \Sigma ^ { \frac { 1 } { 2 } } \exp \left ( t \, \Sigma ^ { - \frac { 1 } { 2 } } W \, \Sigma ^ { - \frac { 1 } { 2 } } \right ) \Sigma ^ { \frac { 1 } { 2 } } .
$$

Coming back to the distance dist 2 (  , Id) =   i (log σ i ) 2 , it is worth noticing that tensors with null eigenvalues are located as far from the identity as tensors with inﬁnite eigenvalues: at the inﬁnity. Thanks to the invariance by the linear group, this property holds for the distance to any (positive deﬁnite) tensor of the manifold. Thus, the original cone of positive deﬁnite symmetricmatrices(alinearmanifoldwithaﬂatmetric but which is incomplete: there is a boundary at a ﬁnite distance) has been changed into a regular and complete (but curved) manifold with an inﬁnite development in each of its n ( n + 1)/2 directions.

# 3.4. Exponential and Logarithm Maps

As a general property of Riemannian manifolds, geodesics realize a local diffeomorphism from the tangent space at a given point of the manifold to the manifold:   (  , W ) (1) = exp   ( W ) associates to each tangent vector W ∈ T   S ym + n a point of the manifold.

[Page 8]

This mapping is called the exponential map, because it corresponds to the usual exponential in some matrix groups. This is exactly our case for the exponential map around the identity:

$$
\exp _ { \text {Id} } ( U \, D U ^ { \top } ) & = \exp \left ( U \, D U ^ { \top } \right ) \\ & = U \, \text {DIAG} ( \exp ( d _ { i } ) ) \, U ^ { \top } .
$$

However, the Riemannian exponential map associated to our invariant metric has a more complex expression at other tensors:

$$
\exp _ { \Sigma } ( W ) = \Sigma ^ { \frac { 1 } { 2 } } \exp \left ( \Sigma ^ { - \frac { 1 } { 2 } } W \Sigma ^ { - \frac { 1 } { 2 } } \right ) \Sigma ^ { \frac { 1 } { 2 } } .
$$

In our case, this diffeomorphism is global, and we can uniquely deﬁne the inverse mapping everywhere:

$$
\log _ { \Sigma } ( \Lambda ) = \Sigma ^ { \frac { 1 } { 2 } } \log \left ( \Sigma ^ { - \frac { 1 } { 2 } } \Lambda \Sigma ^ { - \frac { 1 } { 2 } } \right ) \Sigma ^ { \frac { 1 } { 2 } } .
$$

Thus, exp   gives us a collection of one-to-one and complete maps of the manifold, centered at any point   . As explained in Section 2.1 , these charts can be viewed as the development of the manifold onto the tangent space along the geodesics. Moreover, as the manifold has a non-positive curvature (Skovgaard, 1984 ), there is no cut-locus and the statistical properties detailed in Pennec ( 2004 ) hold in their most general form. For instance, we have the existence and uniqueness of the mean of any distribution with a compact support (Kendall, 1990 ).

# 3.5. Induced and Orthonormal Coordinate Systems

One has to be careful because the coordinate system of all these charts is not orthonormal. Indeed, the coordinate system of each chart is induced by the standard coordinate system (here the matrix coefﬁcients), so that the vector − →    corresponds to the standard derivative in the vector space of matrices: we have   =   + − →    + O (   − →      2 ). Even if this basis is orthonormal at some points of the manifold (such as at the identity for our tensors), it has to be corrected for the Riemannian metric at other places due to the manifold curvature.

From the expression of the metric, one can observe that

$$
\| \overrightarrow { \Sigma \Lambda } \| _ { \Sigma } ^ { 2 } & = \| \log _ { \Sigma } ( \Lambda ) \| _ { \Sigma } ^ { 2 } = \| \Sigma ^ { - \frac { 1 } { 2 } } \log _ { \Sigma } ( \Lambda ) \Sigma ^ { - \frac { 1 } { 2 } } \| _ { I d } ^ { 2 } \\ & = \| \log ( \Sigma ^ { - \frac { 1 } { 2 } } * \Lambda ) \| _ { 2 } ^ { 2 } .
$$

For some statistical operations, we need to use a minimal representation (e.g. 6 parameters for 3 × 3 tensors) in a (locally) orthonormal basis. This can be realized through the classical “Vec” operator that maps the element a i , j of a n × n matrix A to the ( i n + j )th elementVec( A ) i n + j ofa n × n dimensionalvectorVec( A ). Since we are working with symmetric matrices, we have only n ( n + 1) / 2 independent coefﬁcients say the upper triangular part. However, the off-diagonal coefﬁcients are counted twice in the L 2 norm at the identity:   W   2 2 =   n i = 1 w 2 i , i + 2   i < j ≤ n w 2 i , j . Thus, to express our minimal representation in an orthonormal basis, we need to multiply the off diagonal terms by √ 2:

$$
\begin{array} { r l } { t } & { w i n e d o w i n a r y a r e o n d a n d e r s o w a r v e r . } \\ { a r d , } & { v e c _ { l d } ( W ) = ( w _ { 1 , 1 } , \sqrt { 2 } \, w _ { 1 , 2 } , w _ { 2 , 2 } , \sqrt { 2 } \, w _ { 1 , 3 } , \sqrt { 2 } \, w _ { 2 , 3 } , } \\ { o p - } & { w _ { 3 , 3 } , \dots \sqrt { 2 } \, w _ { 1 , n } , \dots \sqrt { 2 } w _ { ( n - 1 ) , n } , w _ { n , n } ) ^ { T } . } \end{array}
$$

Now, for a vector − →    ∈ T   S ym + n , we deﬁne its minimal representation in the orthonormal coordinate system as:

$$
\ V e c _ { \Sigma } ( \overrightarrow { \Sigma } \, \Lambda ) & = \ V e c _ { I d } ( \overrightarrow { \Sigma } \, \Lambda _ { \perp } ) = \ V e c _ { I d } ( \Sigma ^ { - \frac { 1 } { 2 } } \, \overline { \Sigma } \, \Lambda \, \Sigma ^ { - \frac { 1 } { 2 } } ) \\ & = \ V e c _ { I d } ( \log \left ( \Sigma ^ { - \frac { 1 } { 2 } } * \Lambda \right ) ) .
$$

The mapping Vec   realizes an explicit isomorphism between T   S ym + n and R n ( n + 1) / 2 with the canonical metric.

# 3.6. Gradient Descent and PDEs: An Intrinsic Geodesic Marching Scheme

Let f (   ) be an objective function to minimize,   t the current estimation of   , and W t = ∂   f = [ ∂ f /∂σ ij ] its matrix derivative at that point, which is of course symmetric. The principle of a ﬁrst order gradient descent is to go toward the steepest descent, in the direction opposite to the gradient for a short time-step ε , and iterate the process. However, the standard operator

[Page 9]

  t + 1 =   t − ε W t is only valid for very short timesteps in the ﬂat Euclidean matrix space, and we could easily go out of the cone of positive deﬁnite tensors. A much more interesting numerical operator is given by following the geodesic backward starting at   with tangent vector W t during a time ε . This intrinsic gradient descent ensures that we cannot leave the manifold. It can easily be expressed using the exponential map:

$$
\Sigma _ { t + 1 } & = \Gamma _ { ( \Sigma _ { t } , W _ { t } ) } ( - \varepsilon ) = \exp _ { \Sigma _ { t } } ( - \varepsilon W _ { t } ) \\ & = \Sigma ^ { \frac { 1 } { 2 } } \exp ( - \varepsilon \Sigma ^ { - \frac { 1 } { 2 } } W _ { t } \Sigma ^ { - \frac { 1 } { 2 } } ) \Sigma ^ { \frac { 1 } { 2 } } .
$$

This intrinsic scheme is trivially generalized to partial differential evolution equations (PDEs) on tensor ﬁelds such as ∂ t   ( x , t ) = − W ( x , t ): we obtain   ( x , t + dt ) = exp   ( x , t ) ( − dtW ( x , t )).

# 3.7. Example with the Mean Value

Let   1 ...  N be a set of measures of the same Tensor. The Karcher or Fr´ echet mean is the set of tensors minimizing the sum of squared distances: C (   ) =   N i = 1 dist 2 (  ,  i ). In the case of tensors, the manifold has a non-positive curvature (Skovgaard, 1984 ), so that there is one and only one mean value ¯   (Kendall, 1990 ). Moreover, a necessary and sufﬁcient condition for an optimum is a null gradient of the criterion. Thus, the intrinsic Newton gradient descent algorithm gives the following mean value at estimation step t + 1:

$$
\bar { \Sigma } _ { t + 1 } & = \exp _ { \bar { \Sigma } _ { t } } \left ( \frac { 1 } { N } \sum _ { i = 1 } ^ { N } \log _ { \bar { \Sigma } _ { t } } ( \Sigma _ { i } ) \right ) \\ & = \bar { \Sigma } _ { t } ^ { \frac { 1 } { 2 } } \exp \left ( \frac { 1 } { N } \sum _ { i = 1 } ^ { N } \log \left ( \bar { \Sigma } _ { t } ^ { - \frac { 1 } { 2 } } \Sigma _ { i } \bar { \Sigma } _ { t } ^ { - \frac { 1 } { 2 } } \right ) \right ) \bar { \Sigma } _ { t } ^ { \frac { 1 } { 2 } } . \quad \text { and } \quad \begin{array} { c c } \\ \\ ( 4 ) \end{array} \\
$$

Note that we cannot easily simplify this expression further as in general the data   i and the mean value ¯   t cannot be diagonalized in a common basis. However, this gradient descent algorithm usually converges very fast (about 10 iterations, see Fig. 2 ).

# 3.8. Simple Statistical Operations on Tensors

As described in Pennec (2004), we may generalize most of the usual statistical methods by using the exponential chart at the mean point. For instance, the empirical covariance matrix of a set of N tensors /Sigma1 i of mean ¯ /Sigma1 is defined using the tensor product: 1 N -1 ∑ n i = 1 - - → ¯ /Sigma1 /Sigma1 i ⊗ - - → ¯ /Sigma1 /Sigma1 i . Using our Vec mapping, we may come back to more usual matrix notations and write its expression in a minimal representation with an orthonormal coordinate system:

$$
C o v = \frac { 1 } { N - 1 } \sum _ { i = 1 } ^ { N } \text {Vec} _ { \bar { \Sigma } } \left ( \overrightarrow { \bar { \Sigma } \, \Sigma _ { i } } \right ) \, \text {Vec} _ { \bar { \Sigma } } \left ( \overrightarrow { \bar { \Sigma } \, \vec { \Sigma } _ { i } } \right ) ^ { T } .
$$

One may also deﬁne the Mahalanobis distance

$$
\mu _ { ( \bar { \Sigma } , C o v ) } ^ { 2 } ( \Sigma ) = V e c _ { \Sigma } \left ( \overrightarrow { \bar { \Sigma } \, \Sigma } \right ) ^ { T } \, C o v ^ { ( - 1 ) } \, V e c _ { \Sigma } \left ( \overrightarrow { \bar { \Sigma } \, \bar { \Sigma } } \right ) .
$$

Looking for the probability density function that minimizes the information with a constrained mean and covariance, we obtain a generalization of the Gaussian distribution of the form:

$$
N _ { \bar { \Sigma } , \Gamma } ( \Sigma ) = k \, \exp \left ( - \frac { 1 } { 2 } \mu _ { \bar { \Sigma } , \Gamma } ^ { 2 } ( \Sigma ) \right ) .
$$

The main difference with a Euclidean space is that we have a curvature to take into account: the invariant measure induced on the manifold by our metric is linked to the usual matrix measure by d M (   ) = d  / det(   ). Likewise, the curvature slightly modiﬁes the usual relation between the covariance matrix, the concentration matrix   and the normalization parameter k oftheGaussiandistribution(Pennec, 2004 ). These differences have an impact on the calculations using continuous probability density functions. However, from a practical point of view, we only deal with a discrete sample set of measurements, so that the measureinduced corrections are hidden. For instance, we can generate a random (generalized) Gaussian tensor using the following procedure: we sample n ( n + 1) / 2 independent and normalized real Gaussian samples, multiply the corresponding vector by the square root of the desired covariance matrix (expressed in our Vec coordinate system), and come back to the tensor manifold using the inverse Vec mapping. Using this procedure, we can easily generate noisy measurements of known tensors (see e.g. Fig. 7 ).

To check the implementation of our charts and geodesic marching algorithms, we verified experimentally the central limit theorem. This theorem states that the empirical mean of N independently and identically distributed (IID) random variables with a variance γ 2 asymptotically follows a Gaussian law of variance γ 2 / N , centered at the exact mean value. The principle of our experiments is now as follows. We randomly generated N random Gaussian tensors around a random tensor ¯ /Sigma1 with a variance of γ 2 = 1. We computed the mean ˆ /Sigma1 using the algorithm of Eq. (4). The convergence is clearly very fast (Fig. 2, left). Now, if the error between the computed and the exact mean really follows a Gaussian law of variance γ 2 / N , then the normalized Mahalanobis distance µ 2 = N dist( ¯ /Sigma1 , ˆ /Sigma1 ) 2 /γ 2 should follow a χ 2 6 distribution. However, this simple experiment only gives us one measurement. Thus, to verify the distribution, we repeated this experiment with N varying from 10 to 1000. Figure 2 presents the histogram of the normalized Mahalanobis distances we obtain. The empirical distribution follows quite well the theoretical χ 2 6 distribution, as expected, with an empirical mean of 5.85 and a variance of 12.17 (expected values are 6 and 12). Moreover, a Kolmogorov-Smirnov test confirms that the distance between the empirical and theoretical cumulative pdf is not significant ( p -value of 0.19).

[Page 10]

![The image is a line graph that shows the number of deaths from a specific disease over time. The x-axis represents the number of deaths, while the y-axis represents the number of deaths. The graph is labeled Number of deaths from a specific disease. The graph shows a clear trend of increasing the number of deaths from the disease over time. The number of deaths increases from 10 to 15 deaths, and then from 15 to 20 deaths. The number of deaths then decreases to 10 deaths, and then from 10 to 15 deaths. There are several key observations: 1. **Initial Increase**: The number of deaths starts at 10 and increases to 15. 2. **Peak**: The number of deaths reaches its peak, with 20 deaths. 3. **Decrease**: The number of deaths decreases to 10, and then to 15.](<Pennec2006/imageFile3.png>)

0,16

1.8

0,14

1

1.6

0.1

0,08

08

0,06

0.6

1

0,.04

0.4

0,02

02

Numnber of iterations

Figure 2. Mean of random Gaussian tensors. Left: Typical evolution of the distance between successive iterations of the mean computation. The convergence is clearly very fast. Right : Histogram of the renormalized Mahalanobis distance µ 2 = N dist( ¯  , ˆ   ) 2 /γ 2 between the computed and the exact mean tensors. The curve is the pdf of the χ 2 6 distribution.

# 4. Tensor Interpolation

One of the important operations in geometric data processing is to interpolate values between known measurements. In 3D image processing, (tri-) linear interpolationisoftenusedthankstoitsverylowcomputational load and comparatively much better results than nearest neighbor interpolation. Other popular methods include the cubic and, more generally, spline interpolations (Th´ evenaz et al., 2000 ; Meijering, 2002 ).

The standard way to deﬁne an interpolation on a regular lattice of dimension d is to consider that the interpolated function f ( x ) is a linear combination of samples f k at integer (lattice) coordinates k ∈ Z d : f ( x ) =   k w ( x − k ) f k . To realize an interpolation, the “sample weight” function w has to vanish at all integer coordinates except 0 where it has to be one. A typical example where the convolution kernel has an inﬁnite support is the sinus cardinal interpolation. With the nearest-neighbor, linear (or tri-linear in 3D), and higher order spline interpolations, the kernel is piecewisepolynomial,andlimitedtoafewneighboring points in the lattice.

When it comes to an irregular sampling (i.e., a set of measurements f k at positions x k ), interpolation may still be deﬁned using a weighted mean: f ( x ) =   N k = 1 w k ( x ) f k . To ensure that this is an interpolating function, one has to require that w i ( x j ) = δ ij (where δ ij is the Kronecker symbol). Moreover, the coordinates are usually normalized so that   N k = 1 w k ( x ) = 1 for all position x within the domain of interest. Typical examples in triangulations or tetrahedrizations are barycentric and natural neighbor coordinates (Sibson, 1981 ).

# 4.1. Interpolation through Weighted Mean

To generalize interpolation methods defined using weighted means to our tensor manifold, let us assume that the sample weights w k ( x ) are defined as above in R d . Thanks to their normalization, the value f ( x ) interpolated from vectors f k verifies ∑ N i = 1 w i ( x ) ( f i - f ( x )) = 0. Thus, similarly to the Fr´ echet mean, we can define the interpolated value /Sigma1 ( x ) on our tensor manifold as the tensor that minimizes the weighted sum of squared distances to the measurements /Sigma1 i : C ( /Sigma1 ( x )) = ∑ N i = 1 w i ( x ) dist 2 ( /Sigma1 i , /Sigma1 ( x )). Of course, we loose in general the existence and uniqueness properties. However, for positive weights, the existence and uniqueness theorems for the Karcher mean can be adapted. In practice, this means that we have a unique tensor that verifies ∑ N i = 1 w i ( x ) - - - - → /Sigma1 ( x ) /Sigma1 i = 0. To reach this solution, it is easy to adapt the Gauss-Newton scheme proposed for the Karcher mean. The algorithm becomes:

[Page 11]

# 4.2. Example of the Linear Interpolation

$$
\Sigma _ { t + 1 } ( x ) & = \exp _ { \Sigma _ { t } ( x ) } \left ( \sum _ { i = 1 } ^ { N } w _ { i } ( x ) \, \log _ { \Sigma _ { t } ( x ) } ( \Sigma _ { i } ) \right ) = \\ \Sigma _ { t } ( x ) ^ { \frac { 1 } { 2 } } \exp \left ( \sum _ { i = 1 } ^ { N } w _ { i } ( x ) \log \left ( \Sigma _ { t } ( x ) ^ { - \frac { 1 } { 2 } } \Sigma _ { i } \Sigma _ { t } ( x ) ^ { - \frac { 1 } { 2 } } \right ) \right ) \Sigma _ { t } ( x ) ^ { \frac { 1 } { 2 } } . \quad \text {cresents} \\ & \quad \text {grows} \\ & \quad \text {much}
$$

Once again, this expression cannot be easily simpliﬁed, but the convergence is very fast (usually less than 10 iterations as for the mean).

The linear interpolation is simple as this is a walk along the geodesic joining the two tensors. For instance, the interpolation in the standard Euclidean matrix space would give     ( t ) = (1 − t )   1 + t   2 . In our Riemannian space, we have the closed-form expression:   ( t ) = exp   1 ( t log   1 (   2 )) = exp   2 ((1 − t ) log   2 (   1 )) for t ∈ [0 , 1]. We displayed in Fig. 3 the ﬂat and the Riemannian interpolations between 2D tensors of eigenvalues(5,1)horizontallyand(1,50)at45degrees, along with the evolution of the eigenvalues, their mean (i.e., trace of the matrix) and product (i.e., determinant of the matrix or volume of the ellipsoid).

With the standard matrix coefﬁcient interpolation, the evolution of the trace is perfectly linear (which was expected since this is a linear function of the coefﬁcients), and the principal eigenvalue regularly grows almost linearly, while the smallest eigenvalue slightly grows toward a local maxima before lowering. What is much more annoying is that the determinant (i.e., the volume) does not grow regularly in between the two tensors, but goes through a maximum. If we interpret our tensors as covariance matrices of Gaussian distributions, this means that the probability of a random

![The image is a scatter plot with two axes labeled x and y. The x-axis is labeled x and the y-axis is labeled y. There are two sets of data points plotted on the graph. The first set of data points is represented by a green line and the second set of data points is represented by a red line. The green line is plotted on the x-axis and the red line is plotted on the y-axis. The points on the graph are connected by a line.](<Pennec2006/imageFile4.png>)

mcan

mcon

50

20

10

20

12 1

16

18

Figure 3. Top: Linear interpolation between 2D tensors of eigenvalues (5,1) horizontally and (1,50) at 45 degrees. Left: Interpolation in the standard matrix space (interpolation of the coefﬁcients). Right: Geodesic interpolation in our Riemannian space. Bottom: Evolution of the eigenvalues, their mean (i.e., trace of the matrix) and product (i.e., determinant of the matrix or volume of the ellipsoid).

[Page 12]

![In this image we can see the graph.](<Pennec2006/imageFile5.png>)

Figure 4. Top left: Bi-linear interpolation between the four 2D tensors at the corners in the standard matrix space (interpolation of the coefﬁcients). Top right: Equivalent bi-linear interpolation in our Riemannian space. Bottom left: A slice of the tri-linear interpolation between 3D tensors in the standard matrix space (interpolation of the coefﬁcients). Bottom right: Equivalent tri-linear interpolation in our Riemannian space.

# 4.3. Tri-Linear Interpolation

The biand tri-linear interpolation of tensors on a regular grid in 2D or 3D are almost as simple, except that we do not have any longer an explicit solution using geodesics since there are more than two reference points. After computing the (bi-)tri-linear weights with respect to the neighboring sites of the point we want to evaluate, we now have to go through the iterative optimization of the weighted mean (Eq. ( 5 )) to com-

# 4.4. Interpolation of Nonregular Measurements

When tensors are not measured on a regular grid but “randomly” localized in space, deﬁning neighbors becomes an issue. One solution, proposed by Sibson ( 1981 ) and later used for surfaces by Cazals and Boissonnat ( 2001 ), is the natural neighbor interpolation. For any point x , its natural neighbors are the points x i whose Voronoi cells are chopped off upon insertion of x into the Voronoi diagram. The weight w i of each natural neighbor x i is the proportion of the new

[Page 13]

Another idea is to rely on radial-basis functions to deﬁne the relative inﬂuence of each measurement point. For instance, a Gaussian inﬂuence would give a weight w i ( x ) = G σ ( x − x i ) to the measurement   i located at x i . Since weights need to be renormalized in our setup, this would lead to the following evolution equation:

$$
\Sigma _ { t + 1 } ( x ) = & \exp _ { \Sigma _ { t } ( x ) } \left ( \frac { \sum _ { i = 1 } ^ { N } G _ { \sigma } ( x - x _ { i } ) \, \overrightarrow { \Sigma _ { t } ( x ) \, \overrightarrow { \Sigma _ { i } } } } { \sum _ { i = 1 } ^ { N } G _ { \sigma } ( x - x _ { i } ) } \right ) .
$$

The initialization could be the (normalized) Gaussian mean in the matrix space. An example of the result of this evolution scheme is provided on top of Fig. 10 . However, this algorithm does not lead to an interpolation, but rather to an approximation, since the weights are not zero at other measurement points. Moreover, we have little control on the quality of this approximation. It is only at the limit where σ goes to zero that we end-up with a (non-continuous) closest point interpolation.

We will describe in Section 6.3 a last alternative that performs the interpolation and extrapolation of sparsely distributed tensor measurements using diffusion.

# 5. Filtering Tensor Fields

Let us now consider that we have a tensor ﬁeld, for instance like in Diffusion Tensor Imaging (DTI) (Le Bihan et al., 2001 ), where the tensor is a ﬁrst order approximation of the anisotropic diffusion of the water molecules at each point of the imaged tissues. In the brain, the diffusion is much favored in the direction of oriented structures (ﬁbers of axons). One of the goal of DTI is to retrieve the main tracts along these ﬁbers. However, the tensor ﬁeld obtained from the images is noisy and needs to be regularized before being further analyzed. A naive but simple and often efﬁcient regularization on signal or images is the convolution by a Gaussian. The generalization to tensor ﬁelds is quitestraightforwardusingonceagainweightedmeans (Section 5.1 below). An alternative is to consider a regularization using diffusion. This will be the subject of Sections 5.3 and 5.4 .

# 5.1. Gaussian Filtering

In the continuous setting, the convolution of a vector ﬁeld F 0 ( x ) by a Gaussian is:

$$
F ( x ) = \int _ { y } G _ { \sigma } ( y - x ) \, F _ { 0 } ( y ) \, d y .
$$

In the discrete setting, coefﬁcients are renormalized since the neighborhood V is usually limited to points within one to three times the standard deviation:

$$
F ( x ) & = \frac { \sum _ { u \in \mathcal { V } ( x ) } G _ { \sigma } ( u ) \, F _ { 0 } ( x + u ) } { \sum _ { u \in \mathcal { V } ( x ) } G _ { \sigma } ( u ) } \\ & = \arg \min _ { F } \sum _ { u \in \mathcal { V } ( x ) } G _ { \sigma } ( u ) \, \| F _ { 0 } ( x + u ) - F \| ^ { 2 } . \\
$$

Like previously, this weighted mean can be solved on our manifold using our intrinsic gradient descent scheme. Starting from the measured tensor ﬁeld   0 ( x ), the evolution equation is

$$
\begin{array} { r l } & { v _ { \sigma _ { i } } } \\ & { \sum _ { t + 1 } ( x ) = \exp _ { \Sigma _ { t } ( x ) } \left ( \frac { \sum _ { u \in \mathcal { V } } G _ { \sigma } ( u ) \ \overline { \Sigma _ { t } ( x ) \Sigma _ { t } ( x + u ) } } { \sum _ { u \in \mathcal { V } } G _ { \sigma } ( u ) } \right ) . } \\ & { i n t } \end{array}
$$

We illustrate in Fig. 5 the comparative Gaussian ﬁltering of a slice of a DT MR image using the ﬂat metric on the coefﬁcient (since weights are positive, a weighted sum of positive deﬁnite matrices is still positive deﬁnite) and our invariant Riemannian metric. One can see a more important blurring of the corpus callosum ﬁber tracts using the ﬂat metric. However, the integration of this ﬁltering scheme into a complete ﬁber tracking system would be necessary to fully evaluate the pros and cons of each metric.

# 5.2. Spatial Gradient of Tensor Fields

On a n -dimensional vector ﬁeld F ( x ) = ( f 1 ( x 1 ,... x d ) ,... f n ( x 1 ,... x d )) T over R d , one may expressthespatialgradientinanorthonormalbasisas:

$$
\nabla F ^ { T } = \left ( \frac { \partial F } { \partial x } \right ) = [ \partial _ { 1 } F , \dots \partial _ { d } F ] \\ = \left [ \begin{array} { c c c } \frac { \partial f _ { 1 } } { \partial x _ { 1 } } , & \cdots & \frac { \partial f _ { 1 } } { \partial x _ { d } } \\ \vdots & \ddots & \vdots \\ \frac { \partial f _ { n } } { \partial x _ { 1 } } , & \cdots & \frac { \partial f _ { n } } { \partial x _ { d } } \end{array} \right ] .
$$

[Page 14]

![In this image we can see a diagram.](<Pennec2006/imageFile6.png>)

Figure 5. Regularization of a DTI slice around the corpus callosum by isotropic Gaussian ﬁltering. Left: Raw estimation of the tensors. The color codes for the direction of the principal eigenvector (red: left/right, green: anterior/posterior, blue: top/bottom). Middle: Gaussian ﬁltering of the coefﬁcients (5 × 5 window, σ = 2.0). Right: Equivalent ﬁltering (same parameters) using the Riemannian metric.

The linearity of the derivatives implies that we could use directional derivatives in more than the d orthogonal directions. This is especially well adapted to stabilize the discrete computations: the ﬁnite difference estimation of the directional derivative is ∂ u F ( x ) = F ( x + u ) − F ( x ). By deﬁnition, the spatial gradient is related to the directional derivatives through ∇ F T u = ∂ u F ( x ). Thus, we may compute ∇ F as the matrix that best approximates (in the least-square sense) the directional derivatives in the neighborhood V (e.g. 6, 18 or 26 connectivity in 3D):

$$
\nabla F ( x ) & = \arg \min _ { G } \sum _ { u \in \mathcal { V } } \| G ^ { T } u - \partial _ { u } F ( x ) \| ^ { 2 } \\ & = \left ( \sum _ { u \in \mathcal { V } } u \, u ^ { T } \right ) ^ { ( - 1 ) } \left ( \sum _ { u \in \mathcal { V } } u \, \partial _ { u } F ( x ) ^ { T } \right ) \\ & \simeq \left ( \sum _ { u \in \mathcal { V } } u \, u ^ { T } \right ) ^ { ( - 1 ) } \left ( \sum _ { u \in \mathcal { V } } u \, ( F ( x + u ) - F ( x ) ) ^ { T } \right ) \, . \quad \text {As} \quad \text {this} \quad \text {max} \quad \text {min} \quad .
$$

We experimentally found in other applications (e.g. to compute the Jacobian of a deformation ﬁeld in nonrigid registration (Rey et al., 2002 , p. 169) that this gradientapproximationschemewasmorestableandmuch faster than computing all derivatives using convolutions, for instance by the derivative of the Gaussian.

To quantify the local amount of variability independently of the space direction, one usually takes the norm of the gradient:  ∇ F ( x )   2 =   d i = 1   ∂ i F ( x )   2 . Once again, this can be approximated using all direc-

$$
\begin{array} { r l } { \tt ^ { g } _ { \tt } } & \| \nabla F ( x ) \| ^ { 2 } \simeq \frac { d } { C a r d ( \mathcal { V } ) } \sum _ { u \in \mathcal { V } } \frac { \| F ( x + u ) - F ( x ) \| ^ { 2 } } { \| u \| ^ { 2 } } . } \\ { \tt } & = } \end{array}
$$

Notice that this approximation is consistent with the previous one only if the directions u are normalized to unity. d

For a manifold valued ﬁeld   ( x ) deﬁne on R , we can proceed similarly, except that the directional derivatives ∂ i   ( x ) are now tangent vectors of T   ( x ) M . They can be approximated just like above using ﬁnite “differences” in our exponential chart:

$$
\partial _ { u } \Sigma ( x ) & \simeq \overrightarrow { \Sigma ( x ) \, \Sigma ( x + u ) } \\ & = \Sigma ( x ) ^ { \frac { 1 } { 2 } } \log \left ( \Sigma ( x ) ^ { - \frac { 1 } { 2 } } \, \Sigma ( x + u ) \, \Sigma ( x ) ^ { - \frac { 1 } { 2 } } \right ) \Sigma ( x ) ^ { \frac { 1 } { 2 } } .
$$

As observed in Section 3.5 , we must be careful that this directional derivative is expressed in the standard matrixcoordinate system(coefﬁcients). Thus, the basis is not orthonormal: to quantify the local amount of variation, we have to take the metric at the point   ( x ) into account, so that:

$$
\bar { u } ^ { - } & = \| \nabla \Sigma ( x ) \| _ { \Sigma ( x ) } ^ { 2 } = \sum _ { i = 1 } ^ { d } \| \partial _ { i } \Sigma ( x ) \| _ { \Sigma ( x ) } ^ { 2 } \\ \intertext { h e } & = \frac { d } { C a r d ( \mathcal { V } ) } \sum _ { u \in \mathcal { V } } \frac { \| \log ( \Sigma ( x ) ^ { - \frac { 1 } { 2 } } \Sigma ( x + u ) \, \Sigma ( x ) ^ { - \frac { 1 } { 2 } } ) \| _ { 2 } ^ { 2 } } { \| u \| ^ { 2 } } . \\
$$

[Page 15]

# 5.3. Filtering Using PDEs

Regularizing a scalar, vector or tensor ﬁeld F aims at reducing the amount of its spatial variations. The ﬁrst order measure of such variations is the spatial gradient ∇ F thatwedealtwithintheprevioussection.Toobtain a regularity criterion over the domain   , we just have to integrate: Reg ( F ) =      ∇ F ( x )   2 dx . Starting from an initial ﬁeld F 0 (x), the goal is to ﬁnd at each step a ﬁeld F t ( x ) that minimizes the regularity criterion by gradient descent in the space of (sufﬁciently smooth and square integrable) functions.

To compute the ﬁrst order variation, we write a Taylor expansion for an incremental step in the direction of the ﬁeld H . Notice that H ( x ) is a tangent vector at F ( x ):

$$
R e g ( F + \varepsilon \, H ) & & \text {tioriy} \\ & = R e g ( F ) + 2 \, \varepsilon \int _ { \Omega } \langle \nabla F ( x ) \, | \, \nabla H ( x ) \rangle \, d x + O ( \varepsilon ^ { 2 } ) . & & \text {tioriy} \\ W o _ { \ } g o t _ { \ } t h e r _ { \ } d i r o t i o n _ { \ } d o r i v i v _ { \ } a _ { \ } a r _ { \ } P a _ { \ } G ( F ) & & = \\
$$

We get the directional derivative: ∂ H Reg ( F ) = 2      ∇ F ( x ) | ∇ H ( x )   dx . To compute the steepest descent, we now have to ﬁnd the gradient ∇ Reg ( F ) such that for all variation H , we have ∂ H Reg ( F ) =      ∇ Reg ( F )( x ) | H ( x )   F ( x ) dx . Notice that ∇ Reg ( F )( x ) and H ( x ) are elements of the tangent space at F ( x ), so that the scalar product should be taken at F ( x ) for a tensor ﬁeld.

The case of a scalar ﬁeld. Let f : R d → R be a scalar ﬁeld. Our regularization criterion is Reg ( f ) =      ∇ f ( x )   2 dx . Let us introduce the divergence div( · ) =  ∇ | ·  and the Laplacian operator   f = div( ∇ f ). The divergence is usually written ∇ T = ( ∂ 1 ,...,∂ d ), so that in an orthonormal coordinate system we have   f =  ∇ | ∇ f   =   d i = 1 ∂ 2 i f . Let now G ( x ) be a vector ﬁeld. Typically, we will use G ( x ) = ∇ f ( x ). Using the standard differentiation rules, we have:

$$
\text {div} ( h \ G ) = \langle \nabla | h \ G \rangle = h \text { div} ( G ) + \langle \nabla h \ | \ G \rangle .
$$

Now, thanks to the Green’s formula (see e.g. Gallot et al., 1993 ), we know that the ﬂux going out of the boundaries of a (sufﬁciently smooth) region   is equal to the integral of the divergence inside this region. If we denote by n the normal pointing outward at a boundary point, we have:

$$
\int _ { \partial \Omega } ( h \ G \ | \ n \rangle d n & = \int _ { \Omega } \text {div} ( h \ G ) \\ & = \int _ { \Omega } h \text { div} ( G ) + \int _ { \Omega } \langle \nabla h \ | \ G \rangle .
$$

This result can also be interpreted as an integration by part in R d . Assuming homogeneous Neumann boundary conditions (gradient orthogonal to the normal on ∂  :   G | n   = 0), the ﬂow across the boundary vanishes, and we are left with:       G | ∇ h   = −     h div( G ). Thus, coming back to our original problem, we have:

$$
\partial _ { h } R e g ( f ) ( x ) & = 2 \, \int _ { \Omega } \langle \nabla f ( x ) \, | \, \nabla h ( x ) \rangle \, d x \\ & = - 2 \int _ { \Omega } h ( x ) \, \Delta f ( x ) \, d x .
$$

Since this last formula is no more than the scalar product on the space L 2 (   , R ) of square integrable functions, we end-up with the classical Euler-Lagrange equation: ∇ Reg ( f ) = − 2   f ( x ). The evolution equation used to ﬁlter the data is thus

$$
\begin{array} { r l } { = } & f _ { t + 1 } ( x ) = f _ { t } ( x ) - \varepsilon \nabla R e g ( f ) ( x ) = f _ { t } ( x ) + 2 \, \varepsilon \Delta f _ { t } ( x ) . } \\ { e p \text {-} } \end{array}
$$

The vector case. Let us decompose our vector ﬁeld F ( x ) into its n scalar components f i ( x ). Likewise, we can decompose the d × n gradient ∇ F into the gradient of the n scalar components ∇ f i ( x ) (columns). Thus, choosing an orthonormal coordinate system on the space R n , our regularization criterion is decoupled into n independent scalar regularization problems:

$$
\begin{array} { r l } { \bar { = } } & { R e g ( F ) ( x ) = \sum _ { i = 1 } ^ { n } \int _ { \Omega } \| \nabla f _ { i } ( x ) \| ^ { 2 } \ d x = \sum _ { i = 1 } ^ { n } R e g ( f _ { i } ) . } \\ { s - } & { R e g ( F ) ( x ) = \sum _ { i = 1 } ^ { n } \int _ { \Omega } \| \nabla f _ { i } ( x ) \| ^ { 2 } \ d x = \sum _ { i = 1 } ^ { n } R e g ( f _ { i } ) . } \end{array}
$$

Thus, each component f i has to be independently regularized with the Euler-Lagrange equation: ∇ Reg ( f i ) = − 2   f i . With the convention that the Laplacian is applied component-wise (so that we still have   F = div( ∇ F ) = ∇ T ∇ F = (   f 1 ,...  f n ) T ), we end-up with the vectorial equation:

$$
\begin{array} { r l } { a l l o t } & { f i n t h e } & { \nabla R e g ( F ) = - 2 \Delta F \quad f o r \quad R e g ( F ) = \int _ { \Omega } \| \nabla F ( x ) \| \, d x . } \\ { q u a l } & { \quad } \end{array}
$$

The associated evolution equation is F t + 1 ( x ) = F t ( x ) + 2 ε  F t ( x ). +

Tensor fields. For a tensor field /Sigma1 ( x ) ∈ S ym + n over R d , the procedure is more complex as we should use the covariant derivative (the connection) to differentiate vectors fields on our manifold. However, we may avoid the introduction of additional complex mathematical tools by coming back to the basic definitions. We summarize below the main ideas, while the full calculations are worked out in Appendix A.1. Let ( x 1 , . . . xd ) be an orthonormal coordinate system of R d . Our regularization criterion is:

[Page 16]

![The image is a black and white medical image, which appears to be a brain scan. The brain scan is divided into three sections, each labeled with a different color. The top left section is white, the top right section is black, and the bottom left section is white. The brain scan is labeled with the following text: Brain Scan in the top left section, Brain in the top right section, and Brain in the bottom left section. The brain scan is divided into three sections, each labeled with a different color. The top left section is white, the top right section is black, and the bottom left section is white. The brain scan is labeled with the following text: Brain in the top left section, Brain in the top right section, and Brain in the bottom left section. The brain scan is divided into three sections, each labeled with a different color. The top left section is white, the top](<Pennec2006/imageFile7.png>)

05

0 4

0,35

0 3

0 2

0.05

Figure 6. Norm of the gradient of the tensor ﬁeld. Left: computed on the coefﬁcients with Eq. ( 7 ) (with the ﬂat metric). Middle: we computed the directional derivatives with the exponential map (Eq. ( 8 )), but the norm is taken without correcting for the metric. As this should be very close to the ﬂat gradient norm, we only display the difference image. The main differences are located on very sharp boundaries, where the curvature of our metric has the most important impact. However, the relative differences remains small (less than 10%), which shows the stability of both the gradient and the log / exp computation schemes. Right: Riemannian norm of the Riemannian gradient (Eq. ( 9 )). One can see much more detailed structures within the brain, which will now be preserved during an anisotropic regularization step.

$$
R e g ( \Sigma ) = \int _ { \Omega } \| \nabla \Sigma ( x ) \| _ { \Sigma ( x ) } ^ { 2 } \, d x = \sum _ { i = 1 } ^ { d } \int _ { \Omega } \| \partial _ { i } \Sigma \| _ { \Sigma } ^ { 2 } \, .
$$

The idea is to write this criterion as the trace of sums and products of standard Euclidean matrices and to compute its directional derivative ∂ W Reg for a perturbation ﬁeld W . This expression contains of course derivatives ∂ i W that we need to integrate. However, as everything is expressed in the standard Euclidean chart (matrix coefﬁcients), and assuming the proper Neumann boundary conditions, we shall safely use the previous integration by part formula     Tr(( ∂ i W )   i ) = −     Tr( W ( ∂ i   i )). Notice that we are using the matrix coefﬁcients only as a chart and not as a metric. Eventually, we rewrite the obtained expression in terms of our Riemannian metric to obtain the formula deﬁning the gradient of the criterion:   ∂ W | Reg   =       W ∇ | Reg     . By identiﬁcation, we get: ∇ Reg (   ) = − 2    , where   is the LaplaceBeltrami operator on our manifold:

$$
\Delta \Sigma = \sum _ { i = 1 } ^ { d } \Delta _ { i } \Sigma \quad \text {with} \quad & & \quad \begin{array} { c c c } T o r \\ \Delta _ { i } \Sigma = \partial _ { i } ^ { 2 } \Sigma - ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } \, ( \partial _ { i } \Sigma ) . & ( 1 1 ) & d o r \end{array}
$$

As we can see, the ﬂat Euclidean second order directional derivatives ∂ 2 i   are corrected by an additional term due to the curvature of our manifold. To conclude, the gradient descent on the regularization criterion with the intrinsic geodesic marching scheme of Section 3.6 leads to:

$$
\Sigma _ { t + 1 } ( x ) & = \exp _ { \Sigma _ { t } ( x ) } ( - \varepsilon \, \nabla R e g ( \Sigma ) ( x ) ) \\ & = \exp _ { \Sigma _ { t } ( x ) } ( 2 \, \varepsilon \, \Delta \Sigma ( x ) ) .
$$

For the numerical computation of the Laplacian, we may approximate the ﬁrst and second order tensor derivative by their Euclidean derivatives. This gives a fourth order approximation of the LaplaceBeltrami operator (see Appendix A.2 ). However, this numerical scheme is extrinsic since it is based on (Euclidean) differences of tensors. We propose here an intrinsic scheme based on the exponential chart at the current point. We already know from Eq. ( 8 ) that − −−−−−−−− →   ( x )   ( x + u ) is an approximation of the ﬁrst order directional derivative ∂ u   ( x ). We show in Appendix A.2 that − −−−−−−−− →   ( x )   ( x + u ) + − −−−−−−−− →   ( x )   ( x − u ) is a forth order approximation of the Laplace Beltrami operator in the direction u :

$$
\Omega _ { 0 } \colon \quad \Delta _ { u } \Sigma & = \partial _ { u } ^ { 2 } \Sigma - 2 \left ( \partial _ { u } \Sigma \right ) \Sigma ^ { ( - 1 ) } \left ( \partial _ { u } \Sigma \right ) \\ & = \overrightarrow { \Sigma ( x ) \Sigma ( x + u ) } + \overrightarrow { \Sigma ( x ) \Sigma ( x - u ) } + O ( \| u \| ^ { 4 } )
$$

To compute the complete manifold Laplacian of Eq. (11), we just have to compute the above numerical approximations of the tensor field derivatives along d orthonormal basis vectors xi . However, like for the computation of the gradient, we may improve the stability of the numerical scheme by averaging the derivatives in all possible directions in the neighborhood V . Assuming a symmetric and isotropic neighborhood, we finally obtain:

[Page 17]

![In this image there are many vegetables.](<Pennec2006/imageFile8.png>)

Figure 7. Left: 3D synthetic tensor ﬁeld with a clear discontinuity. Middle: The ﬁeld has been corrupted by a Gaussian noise (in the Riemannian sense). Right: result of the regularization after 30 iterations (time step ε = 0 . 01).

$$
\Delta \Sigma ( x ) & = \frac { d } { C a r d ( \mathcal { V } ) } \sum _ { u \in \mathcal { V } } \frac { \Delta _ { u } ^ { 2 } \Sigma ( x ) } { \| u \| ^ { 2 } } \\ & \simeq \frac { 2 \, d } { C a r d ( \mathcal { V } ) } \sum _ { u \in \mathcal { V } } \frac { \overline { \Sigma ( x ) \Sigma ( x + u ) } } { \| u \| ^ { 2 } } . \quad ( 1 3 ) \quad \text {date} \\ \Delta A n i s o t r o p i c \, F i l t e r i n g
$$

# 5.4. Anisotropic Filtering

In practice, we would like to ﬁlter within the homogeneous regions, but not across their boundaries. The basic idea is to penalize the smoothing in the directions where the derivative is important (Perona and Malik, 1990 ; Gerig et al., 1992). If c ( · ) is a weighting function decreasing from c (0) = 1to c ( +∞ ) = 0, this can be realized directly in the discrete implementation of the Laplacian (Eq. ( 13 )): the contribution   u   of the spatial direction u to the Laplace-Beltrami operator is weighted by our decreasing function according to the norm   ∂ u       of the gradient in that direction. The important point here is that we should evaluate the norm of directional derivatives of the tensor ﬁeld with our invariant metric. With our ﬁnite difference approximations, this leads to the following modiﬁed Laplacian:

$$
t iONS , \text { this leads to the following modified Laplacian: } & & \text {tan} \\ \Delta _ { a n i s o } \Sigma ( x ) & & \text {tan} \\ = \frac { d } { C a r d ( \mathcal { V } ) } \sum _ { u \in \mathcal { V } } c \left ( \frac { \| \partial _ { u } \Sigma ( x ) \| _ { \Sigma ( x ) } } { \| u \| } \right ) \frac { \Delta _ { u } ^ { 2 } \Sigma ( x ) } { \| u \| ^ { 2 } } & & \text {tan} \\ \simeq \frac { 2 \, d } { C a r d ( \mathcal { V } ) } \sum _ { u \in \mathcal { V } } c \left ( \frac { \| \overline { \Sigma ( x ) \Sigma ( x + u ) } \| } { \| u \| } \right ) & & \text {diff} \\ \times \frac { \overline { \Sigma ( x ) \Sigma ( x + u ) } } { \| u \| ^ { 2 } } .
$$

Figures 7 and 8 present example results of this very simple anisotropic ﬁltering scheme on synthetic and real DTI images. We used the function c ( x ) = exp( − x 2 /κ 2 ), where the threshold κ controls the amount of local regularization: for a gradient magnitude greater than 2 to 3 times κ , there is virtually no regularization, while the ﬁeld is almost linearly smoothed for gradient magnitudes below a fraction (say 0.1) of κ . For both synthetic and real data, the histogram of the gradient norm is very clearly bimodal so that the threshold κ is easily determined.

In Fig. 7 , we generated a tensor ﬁeld with a discontinuity, and add independent Gaussian noises according to Section 3.8 . The anisotropic smoothing perfectly preserves the discontinuity while completely smoothing each region. In this synthetic experiment, we retrieve tensor values that are very close to the initial tensor ﬁeld. This could be expected since the two regions are perfectly homogeneous. After enough regularization steps, each region is a constant ﬁeld equal to the mean of the 48 initially noisy tensors of the region. Thus, similarly to the Euclidean mean of identically and independently distributed measurements, we expect the standard deviation of the regularized tensors to be roughly 7   √ 48 times smaller than the one of the noisy input tensors.

In Fig. 8 , we display the evolution of (a slice of) the tensor ﬁeld, the norm of the gradient and the fractional anisotropy (FA) at different steps of the anisotropic ﬁltering of a 3D DTI. The FA is based on the normalized variance of the eigenvalues. It shows the differences between an isotropic diffusion in the brain (where the diffusion tensor is represented by a sphere, FA = 0) and a highly directional diffusion (cigar-shaped ellipsoid, FA = 1). Consequently, the bright regions in the image are the potential areas where nervous ﬁbers are located. One can see that the tensors are regularized in

[Page 18]

![In this image we can see the brain images.](<Pennec2006/imageFile9.png>)

Figure 8. Anisotropic ﬁltering of a DTI slice (time step 0.01, κ = 0 . 046). From left to right: at the beginning, after 10 and after 50 iterations. Top: A 3D view of the tensors as ellipsoids. The color codes for the direction of the principal eigenvector. The results could be compared with the isotropic Gaussian ﬁltering displayed in Fig. 5 . Middle: Riemannian norm of the gradient. Bottom: Fractional anisotropy.

“homogeneous” regions (ventricles, temporal areas), while the main tracts are left unchanged. It is worth noticing that the fractional anisotropy is very well regularized even though this measure has almost nothing in common with our invariant tensor metric.

Figure 9 displays closeups around the ventricles to compare the different regularization methods developed so far. One can see that the Riemannian metric gives much less weight to large tensors, thus providing a regularization which is more robust to outliers.

[Page 19]

![In this image we can see a collage of four images. In the first image there is a person and a person is standing. In the second image there is a person and a person is standing. In the third image there is a person and a person is standing. In the fourth image there is a person and a person is standing.](<Pennec2006/imageFile10.png>)

Figure 9. Closeup on the results of the different ﬁltering methods around the splenium of the corpus callosum. The color codes for the direction of the principal eigenvector (red: left-right, green: posterior-anterior, blue: inferior-superior). Top left: Original image. Top right: Gaussian ﬁltering using the ﬂat metric (5 × 5 window, σ = 2 . 0). This metric gives too much weight to tensors with large eigenvalues, thus leading to clear outliers in the ventricles or in the middle of the splenium tract. Bottom left: Gaussian ﬁltering using the Riemannian metric (5 × 5 window, σ = 2 . 0). Outliers disappeared, but the discontinuities are not well preserved, for instance in the ventricles at the level of the cortico-spinal tracts (upper-middle part of the images). Bottom right: Anisotropic ﬁltering in the Riemannian framework (time step 0.01, 50 iterations). The ventricles boundary is very well conserved with an anisotropic ﬁlter and both isotropic (ventricles) and anisotropic (splenium) regions are regularized. Note that the U-shaped tracts at the boundary of the grey/white matter (lower left and right corners of each image) are preserved with an anisotropic ﬁlter and not with a Gaussian ﬁlter.

The anisotropic ﬁltering further improves the results by preserving the discontinuities of the tensor scale (e.g. at the boundary of the ventricles), but also the discontinuities of the tensor orientation, which is exactly what is needed for ﬁber tracking in DTI.

# 6. Regularization and Restoration of Tensor Fields

The pure diffusion is efﬁcient to reduce the noise in the data, but it also reduces the amount of information.

[Page 20]

![In this image, we can see a chart.](<Pennec2006/imageFile11.png>)

Figure 10. Interpolation and extrapolation of tensor values from four measurements using diffusion. Top left: The four initial tensor measurements. Top right: Initialization of the tensor ﬁeld using a soft closest point interpolation (mean of the four tensors with a renormalized spatial Gaussian inﬂuence). Bottom left: result of the diffusion without the data attachment term (1000 iterations, time-stem ε = 1 ,λ = +∞ ). Bottom right: result of the diffusion with an attachment term after (1000 iterations, time-step ε = 1 ,λ = 0 . 01 ,σ = 1 pixel of the reconstruction grid). The algorithm did converge in about 100 iterations.

Moreover, the amount of smoothing is controlled by the time of diffusion (time step ε times the number of iterations), which is not an easy parameter to tune. At an inﬁnite diffusion time, the tensor ﬁeld will be completely homogeneous (or homogeneous by part for some anisotropic diffusion schemes), with a value corresponding to the mean of the measurements over the region (with Neumann boundary conditions). Thus, the absolute minimum of our regularization criterion alone is of little interest.

To keep close to the measured tensor field /Sigma1 0 ( x ) while still regularizing, a more theoretically grounded approach is to consider an optimization problem with a competition between a data attachment term and a possibly non-linear anisotropic regularization term:

$$
C ( \Sigma ) = S i m ( \Sigma , \Sigma _ { 0 } ) + \lambda \, R e g ( \Sigma ) .
$$

Like before, the intrinsic evolution equation leading to a local minimum is:

$$
\Sigma _ { t + 1 } ( x ) & = \exp _ { \Sigma _ { t } ( x ) } ( - \varepsilon \ ( \nabla S i m ( \Sigma , \Sigma _ { 0 } ) \\ & + \lambda \, \nabla R e g ( \Sigma ) ( x ) ) ) \, .
$$

[Page 21]

# 6.1. The Regularization Term

As we saw in the previous section, the simplest regularization criterion is the norm of the gradient of the ﬁeld Reg ( F ) =      ∇ F ( x )   2 dx . To preserve the discontinuities, the gradient of this criterion (the Laplacian) may be tailored to prevent the smoothing across them, as we have done in Section 5.4 . However, there is no more convergence guarantee, since this anisotropic regularization “force” may not derive from a well-posed criterion (energy). Following the pioneer work of Perona and Malik ( 1990 ), there has been quite an extensive amount of work to propose well posed PDEs for the non-linear, anisotropic and non-stationary regularization of scalar and vector ﬁelds (seee.g. Weickert, 1998 , Sapiro, 2001 tociteonlyafew recent books). Some of these techniques were recently adapted to work on matrix valued ﬁelds (Weickert and Brox, 2002 ) (with the ﬂat metric) or on the rotation manifolds (Tschumperle and Deriche, 2002 ).

One of the main idea is to replace the usual simple regularization term Reg ( F ) =      ∇ F ( x )   2 dx by an increasing function   of the norm of the spatial gradient: Reg ( F ) =       (  ∇ F ( x )   ) dx . With some regularity conditions on the   -function (Aubert and Kornprobst, 2001 ), one can recompute the previous derivations with this   -function, and we end-up with:

$$
\nabla R e g ( F ) ( x ) & = - \text {div} \left ( \frac { \Phi ^ { \prime } ( \| \nabla F \| ) } { \| \nabla F \| } \nabla F \right ) \\ & = - \sum _ { i = 1 } ^ { d } \partial _ { i } \left ( \frac { \Phi ^ { \prime } ( \| \nabla F \| ) } { \| \nabla F \| } \partial _ { i } F \right ) . \\ \intertext { This scheme was used in Chefdefhotelel et al. (2004 ) }
$$

This scheme was used in Chefdhotel et al. ( 2004 ) with the ﬂat Euclidean metric on tensors, in conjunction with a geometric numerical integration scheme that preserves the rank of the matrix. Their conclusion was that the rank /signature preserving ﬂow tends to blend the orientation and diffusivity features (eigenvalue swelling effect). This rank-signature preserving ﬂow is based on the matrix exponential but does not make any reference to a speciﬁc metric. Reformulated in our notations, their evolution equation is:   ( x , t + dt ) = exp( dt A ( x , t ))   ( x , t )exp( dt A ( x , t )) , where A ( x, t ) is implicitly related to the driving tangent vector ﬁeld using: ∂ t   ( x , t ) = − W ( x , t ) = A ( x , t )   ( x , t ) +   ( x , t ) A ( x , t ). From the ﬁrst expression of our geodesics (Eq. ( 3 ) in Section 3.3 ), we can see that this is a geodesic marching scheme for our metric. However, they use the ﬂat Euclidean metric on

We are currently investigating how to adapt the   -function formalism to our Riemannian tensor framework. The gradient of the modiﬁed criterion can be computed with the invariant metric like in Appendix A.1 to obtain a weighted manifold Laplacian with an additional anisotropic correction term. However, designing an efﬁcient discrete computation scheme is more difﬁcult. We may compute the directional derivatives using ﬁnite differences in the ﬂat matrix space and use the intrinsic evolution scheme, but we believe that there are more efﬁcient ways to do it using the exponential map. In the following, we keep the isotropic regularization based on the squared amplitude of the gradient.

# 6.2. A Least-Squares Attachment Term

Usually, one considers that the data (e.g. a scalar image or a displacement vector ﬁeld F 0 ( x )) are corrupted by a uniform(isotropic)Gaussiannoiseindependentateach spatial position. With a maximum likelihood approach, this amounts to considering a least-squares criterion Sim ( F ) =       F ( x ) − F 0 ( x )   2 dx . Likeintheprevious section, we compute the ﬁrst order variation by writing the Taylor expansion

$$
\begin{array} { r l } & { i n - } & { S i m ( F + \varepsilon \, H ) } \\ & { v _ { \varepsilon } } & { = S i m ( F ) + 2 \varepsilon \int _ { \Omega } \langle H ( x ) \, | \, F ( x ) - F _ { 0 } ( x ) \rangle d x + O ( \varepsilon ^ { 2 } ) . } \\ & { o r - } & { \quad } \end{array}
$$

This time, the directional derivative ∂ H Sim ( F ) is directly expressed using a scalar product with H in the proper functional space, so that the steepest ascent direction is ∇ Sim ( F ) = 2 ( F ( x ) − F 0 ( x )). On the tensor manifold, assuming a uniform (gen-

eralized) Gaussian noise independent at each position also leads to a least-squares criterion through a maximum likelihood approach. The only difference is that

[Page 22]

$$
S i m ( \Sigma ) & = \int _ { \Omega } \text {dist} ^ { 2 } \left ( \Sigma ( x ) \, , \ \Sigma _ { 0 } ( x ) \right ) \, d x \\ & = \int _ { \Omega } \left \| \overrightarrow { \Sigma ( x ) \Sigma _ { 0 } ( x ) } \right \| _ { \Sigma ( x ) } ^ { 2 } \, d x .
$$

Thanks to the properties of the exponential map, one can show that the gradient of the squared distance is: ∇   dist 2 (   ,   0 ) = − 2 − − →    0 (Pennec, 2004 ). One can verify that this is a tangent vector at   whereas − − →   0   is not. Finally, we obtain a steepest ascent direction of our criterion which is very close to the vector case:

$$
\nabla S i m ( \Sigma ) ( x ) = - 2 \, \overrightarrow { \Sigma ( x ) \Sigma _ { 0 } ( x ) } .
$$

# 6.3. A Least-Squares Attachment Term for Sparsely Distributed Tensors

Now, let us consider the case where we do not have a dense measure of our tensor ﬁeld, but only N measures   i atirregularlydistributedsamplepoints x i .Assuming a uniform Gaussian noise independent at each position still leads to a least-squares criterion:

$$
S i m ( \Sigma ) & = \sum _ { i = 1 } ^ { N } \text {dist} ^ { 2 } \left ( \Sigma ( x _ { i } ) \, , \, \Sigma _ { i } \right ) \\ & = \int _ { \Omega } \sum _ { i = 1 } ^ { N } \text {dist} ^ { 2 } \left ( \Sigma ( x ) \, , \, \Sigma _ { i } \right ) \, \delta ( x - x _ { i } ) \, d x . \\ \intertext { I n t h i s c r i t i o n } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \
$$

In this criterion, the tensor ﬁeld   ( x ) is related to the data only at the measurement points x i through the Dirac distributions δ ( x − x i ). If the introduction of distributions may be dealt with for the theoretical differentiation of the criterion with respect to the continuous tensor ﬁeld   , it is a real problem for the numerical implementation. In order to regularize the problem, we consider the Dirac distribution as the limit of the Gaussian function G σ when σ goes to zero. Using that scheme, our criterion becomes the limit case σ = 0 of:

$$
S i m _ { \sigma } ( \Sigma ) = \int _ { \Omega } \sum _ { i = 1 } ^ { N } \text {dist} ^ { 2 } \left ( \Sigma ( x ) \, , \, \Sigma _ { i } \right ) \, G _ { \sigma } ( x - x _ { i } ) \, d x .
$$

From a practical point of view, we need to use a value of σ which is of the order of the spatial resolution of the

Now that we came back to a smooth criterion, we may differentiate it exactly as we did for the dense measurement setup. The ﬁrst order variation is:

$$
\begin{array} { r l } & { S i m _ { \sigma } ( \Sigma + \varepsilon W ) = S i m _ { \sigma } ( \Sigma ) } \\ { \varepsilon } \\ { \vdots } \\ & { - 2 \varepsilon \sum _ { i = 1 } ^ { N } \int _ { \Omega } \langle W ( x ) | G _ { \sigma } ( x - x _ { i } ) \, \overrightarrow { \Sigma ( x ) \Sigma _ { i } } \rangle d x + O ( \varepsilon ^ { 2 } ) , } \\ { \vdots } \\ { f } \end{array}
$$

so that we get:

$$
\nabla S i m _ { \sigma } ( x ) = - 2 \, \sum _ { i = 1 } ^ { N } G _ { \sigma } ( x - x _ { i } ) \, \overrightarrow { \Sigma ( x ) \Sigma _ { i } } . \ \ ( 1 7 ) \\ \\ \intertext { t h s c r } \, \text {Interval through Diffusion}
$$

# 6.4. Interpolation through Diffusion

With the sparse data attachment term (16) and the isotropic ﬁrst order regularization term (10), we are looking for a tensor ﬁeld that minimizes its spatial variations while interpolating (or more precisely approximating at the desired precision) the measurement values:

$$
C ( \Sigma ) & = \int _ { \Omega } \sum _ { i = 1 } ^ { N } G _ { \sigma } ( x - x _ { i } ) \, \text {dist} ^ { 2 } \left ( \Sigma ( x _ { i } ) \, , \, \Sigma _ { i } \right ) \\ & + \lambda \int _ { \Omega } \| \nabla \Sigma ( x ) \| _ { \Sigma ( x ) } ^ { 2 } \, d x .
$$

According to the previous sections, the gradient of this criterion is

$$
\nabla C ( \Sigma ) ( x ) & = - 2 \sum _ { i = 1 } ^ { N } G _ { \sigma } ( x - x _ { i } ) \, \overrightarrow { \Sigma ( x ) \, \Sigma _ { i } } \\ & - 2 \, \lambda \, \Delta \, \Sigma ( x ) .
$$

Using our ﬁnite difference approximation scheme (Eq. ( 13 )), the intrinsic geodesic gradient descent scheme (Section 3.6 ) is ﬁnally:

$$
\Sigma _ { t + 1 } ( x ) = \exp _ { \Sigma _ { t } ( x ) } \left ( \varepsilon \left \{ \sum _ { i = 1 } ^ { N } G _ { \sigma } ( x - x _ { i } ) \overrightarrow { \Sigma ( x ) \Sigma _ { i } } \\ + \lambda ^ { \prime } \sum _ { u \in \mathcal { V } } \frac { \overline { \Sigma ( x ) \Sigma ( x + u ) } } { \| u \| ^ { 2 } } \right \} \right ) .
$$

Lastbutnotleast,weneedaninitializationofthetensor ﬁeld   0 ( x ) to obtain a fully operational algorithm.

[Page 23]

This is easily done with any radial basis function approximation, for instance the renormalized Gaussian scheme that we investigated in Section 4.4 . Figure 10 displays the result of this algorithm on the interpolation between 4 tensors. On can see that the soft closest point approximation is well regularized into a constant ﬁeld equal to the mean of the four tensors if data attachment term is neglected. On the contrary, a very small value of λ is sufﬁcient for regularizing the ﬁeld between known tensors (as soon as σ is much smaller than the typical spatial distance between two measurements).

Thechoiceoftheinitializationisacriticalissuefrom a computational point of view. For instance, starting with a constant (or any harmonic) ﬁeld is a bad idea: there is a null Laplacian everywhere, except at the immediate neighborhood of the sparse tensors, exactly where the data attachment term acts. Thus, we have a potentially destructive competition between the two termsofthecriterioninverylocalizedarea.Onthecontrary, starting with a soft closest point approximation leads to a Laplacian which is non null on the boundaries of the Voronoi cells of the measurement points, i.e., the farthest possible place from the sparse measures. In that case, the Laplacian regularization will spread from these boundaries with no constraints until it reaches the counterbalancing forces of the data attachment term in the immediate vicinity of the sparse measurements. Thus, we may expect to reach the maximal efﬁciency in terms of convergence rate.

# 7. Conclusion

We propose in this paper an afﬁne invariant metric that endows the space of positive deﬁne symmetric matrices (tensors) with a very regular manifold structure. In particular, tensors with null and inﬁnite eigenvalues are both at an inﬁnite distance of any positive deﬁnite symmetric matrix: the cone of positive deﬁnite symmetric matrices is replaced by a space which has an inﬁnite development in each of its n ( n + 1) / 2 directions. Moreover, there is one and only one geodesic joining any two tensors, and we can even deﬁne globally consistent orthonormal coordinate systems of the tangent spaces. Thus, the structure we obtain is very close to a vector space, except that the space is curved. We exemplify some the the good metric properties for some simple statistical operations. For instance, the Karcher mean in Riemannian manifolds has to be deﬁned through a distance-based variational formulation.

With our invariant metric on tensors, the existence and uniqueness is insured, which is generally not the case.

A second contribution of the paper is the application of this framework to important geometric data processing problem such as interpolation, ﬁltering, diffusion and restoration of tensor ﬁelds. We show that interpolation and Gaussian ﬁltering can be tackled efﬁciently through a weighted mean computation. However, if weightsareeasytodeﬁne forregularlysampledtensors (e.g. for linear to tri-linear interpolation), the problem proved to be more difﬁcult for irregularly sampled values. The solution we propose is to consider this type of interpolation as a statistical restoration problem where we want to retrieve a regular tensor ﬁeld between (possibly noisy) measured tensor values at sparse points. This type of problem is usually solved using a PDE evolution equation. We show that the usual linear regularization (minimizing the magnitude of the gradient) and someanisotropic diffusionschemes canbe adapted to our Riemannian framework, provided that the metric of the tensor space is taken into account. We also provide intrinsic numerical schemes for the computation of the gradient and Laplace-Beltrami operators. Finally, simple statistical considerations led us to propose least-squares data attachment criteria for dense and sparsely distributed tensor ﬁelds. The differentiation of these criteria is particularly efﬁcient thanks to the use of the Riemannian distance inherited from the chosen metric.

From a theoretical point of view, this paper is a striking illustration of the general framework we are developing since (Pennec, 1996 ) to provide a rigorous computing environment for geometric objects. This framework is based on the choice of a Riemannian metric on one side, which leads to powerful differential geometry tools such as the the exponential maps and geodesic marching techniques, and on the transformation of linear combinations or integrals into minimization problems on the other side. The Karcher mean and the generalized Gaussian distribution are a typical example that we previously investigated (Pennec, 2004 ). In the present paper, we provide new examples with interpolation, ﬁltering and PDEs on Riemannian-valued ﬁelds.

Many research avenues are still left open, in particular the choice of the metric to use. In a more practical domain, we believe that investigating new intrinsic numerical schemes to compute the derivatives in the PDEs could lead to important gains in accuracy and efficiency. Last but not least, all the results presented in this paper still need to be confronted to other existing methods and validated in the context of medical DTI applications. We are currently investigating another very interesting application field in collaboration with P. Thompson and A. Toga at UCLA: the modeling and analysis of the variability of the brain anatomy.

[Page 24]

# Appendix A: Tensor Regularization: The Laplace-Beltrami Operator

# A.1. Gradient of the L 2 Regularization of a Tensor Field

Let   ( x ) ∈ S ym + n be a tensor ﬁeld over R d , and ( x 1 , ... x d ) be an orthonormal coordinate system. To simplify the notations, we use in this section ∂ i for the spatial derivative ∂ /( ∂ x i ) and we do not specify the (spatial) integration variable x . The L 2 regularization criterion is:

$$
c r i t e r i o n s & \colon \\ & R e g ( \Sigma ) = \int _ { \Omega } \| \nabla \Sigma ( x ) \| _ { \Sigma ( x ) } ^ { 2 } \ d x = \sum _ { i = 1 } ^ { d } \int _ { \Omega } \| \partial _ { i } \Sigma \| _ { \Sigma } ^ { 2 } \\ & = \sum _ { i = 1 } ^ { d } \int _ { \Omega } \text {Tr} ( ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } \, ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } ) . \\ & U \text {ising the Taylor expansion} \, ( \Sigma + \varepsilon W ) ^ { ( - 1 ) } = \Sigma ^ { ( - 1 ) } -
$$

Using the Taylor expansion (   + ε W ) ( − 1) =   ( − 1) − ε  ( − 1) W   ( − 1) + O ( ε 2 ) in the the Taylor expansion of our regularization criterion and identifying the ﬁrst order term to Reg (   + ε W ) = Reg (   ) + ε ∂ W Reg + O ( ε 2 ), we get the directional derivative:

$$
\partial _ { W } R e g = 2 \sum _ { i = 1 } ^ { d } \int _ { \Omega } \text {Tr} ( ( \partial _ { i } W ) \, \Sigma ^ { ( - 1 ) } \, ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } \\ - ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } \, ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } \, W \Sigma ^ { ( - 1 ) } ) \\
$$

The main goal is to ﬁnd out the ﬁeld of tangent vectors ∇ Reg ( x ) ∈ T   ( x ) S ym + n such that, by deﬁnition of the gradient, we have the equality: ∂ W Reg =       W |∇ Reg     dx for every ﬁeld of tangent vectors W ( x ) ∈ T   ( x ) S ym + n .Astheaboveexpressionof ∂ W Reg is in the standard Euclidean chart (matrix coefﬁcients), we shall safely use the computations of the previous sections. Notice that we are using the matrix coefﬁcients only as a chart and not as a metric. Let   i =   ( − 1) | ( ∂ i   )   ( − 1) . We get: d

$$
\Lambda _ { i } = & \quad | ( \Gamma _ { i } ) - \Lambda _ { i } ^ { d } \rangle \\ \partial _ { W } R e g = & \, 2 \sum _ { i = 1 } ^ { d } \int _ { \Omega } \left ( \text {Tr} ( ( \partial _ { i } W ) \ \Lambda _ { i } ) \\ & - \langle W | ( \partial _ { i } \Sigma ) \ \Sigma ^ { ( - 1 ) } \left ( \partial _ { i } \Sigma \right ) \rangle _ { \Sigma } \right )
$$

Now, assuming the proper Neumann boundary conditions, we can apply the previous integration by part formula     Tr(( ∂ i W )   i ) = −     Tr( W ( ∂ i   i )) to the ﬁrst term:

$$
\partial _ { W } R e g & = - 2 \sum _ { i = 1 } ^ { d } \int _ { \Omega } \left ( \text {Tr} ( W \, \Sigma ^ { ( - 1 ) } ( \Sigma ( \partial _ { i } \Lambda _ { i } ) \Sigma ) \Sigma ^ { ( - 1 ) } ) \\ & + \langle W | ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } ( \partial _ { i } \Sigma ) \rangle _ { \Sigma } \right ) \\ & = - 2 \sum _ { i = 1 } ^ { d } \int _ { \Omega } \langle W | \Sigma ( \partial _ { i } \Lambda _ { i } ) \Sigma + ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } ( \partial _ { i } \Sigma ) \rangle _ { \Sigma } \\ \dots \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \
$$

We have obtained the expression that deﬁnes the gradient of our regularization criterion:

$$
\text {for} \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

To compute explicitly its value, let us observe ﬁrst that ∂ i   ( − 1) = −   ( − 1) ( ∂ i   )   ( − 1) because ∂ i (   ( − 1)   ) = 0. Thus, thanks to the chain rule, we have:

$$
\Sigma \ ( \partial _ { i } \Lambda _ { i } ) \ \Sigma & = \Sigma \ \partial _ { i } \left ( \Sigma ^ { ( - 1 ) } \left ( \partial _ { i } \Sigma \right ) \Sigma ^ { ( - 1 ) } \right ) \Sigma \\ & = \partial _ { i } ^ { 2 } \Sigma - 2 \left ( \partial _ { i } \Sigma \right ) \Sigma ^ { ( - 1 ) } \left ( \partial _ { i } \Sigma \right )
$$

Eventually, we end up with ∇ Reg (   ) = − 2    , where   is the Laplace-Beltrami operator on our manifold:

$$
\Delta \Sigma & = \sum _ { i = 1 } ^ { d } \Delta _ { i } \Sigma \quad \text {with} \\ \Delta _ { i } \Sigma & = \partial _ { i } ^ { 2 } \Sigma - ( \partial _ { i } \Sigma ) \, \Sigma ^ { ( - 1 ) } \, ( \partial _ { i } \Sigma )
$$

# A.2 Numerical Implementation of the Laplace-Beltrami Operator

From the Taylor expansion of a tensor ﬁeld (considered as a matrix ﬁeld)   at x , we have   ( x + ε u ) =   ( x ) + ε∂ u   ( x ) + ε 2 ∂ 2 u   ( x ) / 2 + ε 3 ∂ 3 u   ( x ) / 6 + O ( ε 4 ). Thus, we may approximate the ﬁrst and second order tensor derivatives by their Euclidean derivatives:

$$
\partial _ { u } \Sigma ( x ) & = \frac { 1 } { 2 } ( \Sigma ( x + u ) - \Sigma ( x - u ) ) + O ( \| u \| ^ { 3 } ) \\ \partial _ { u } ^ { 2 } \Sigma ( x ) & = ( \Sigma ( x + u ) - \Sigma ( x ) ) \\ & + ( \Sigma ( x - u ) - \Sigma ( x ) ) + O ( \| u \| ^ { 4 } )
$$

[Page 25]

This ﬁnally gives us a fourth order approximation of the Laplace-Beltrami operator in the spatial direction u :

$$
\Delta _ { u } \Sigma ( x ) & = \partial _ { u } ^ { 2 } \Sigma - 2 \left ( \partial _ { u } \Sigma \right ) \Sigma ^ { ( - 1 ) } \left ( \partial _ { u } \Sigma \right ) \\ & = \Sigma ( x + u ) + \Sigma ( x - u ) - 2 \Sigma ( x ) \\ & \quad - \frac { 1 } { 2 } ( \Sigma ( x + u ) - \Sigma ( x - u ) ) \Sigma ^ { ( - 1 ) } \\ & \quad \times ( \Sigma ( x + u ) - \Sigma ( x - u ) ) + O ( \| u \| ^ { 4 } ) \\ & \quad \\ \text {However, this numerical scheme is extensible since}
$$

However, this numerical scheme is extrinsic since it is based on (Euclidean) differences of tensors. We propose here an intrinsic scheme based on the exponential chart at the current point: we claim that − −−−−−−−− →   ( x )   ( x + u ) + − −−−−−−−− →   ( x )   ( x − u ) is a forth order approximation of the Laplace Beltrami operator in the direction u . Indeed, we have

- - - - - - - - - - → /Sigma1 ( x ) /Sigma1 ( x + ε u )

$$
\ = \Sigma ^ { \frac { 1 } { 2 } } ( x ) \, \log \left ( \Sigma ^ { - \frac { 1 } { 2 } } ( x ) \, \Sigma ( x + \varepsilon u ) \, \Sigma ^ { - \frac { 1 } { 2 } } ( x ) \right ) \, \Sigma ^ { \frac { 1 } { 2 } } ( x )
$$

$$
& = \Sigma ^ { \frac { 1 } { 2 } } ( x ) \, \log \left ( \Sigma ^ { - \frac { 1 } { 2 } } ( x ) \, \Sigma ( x + \varepsilon u ) \, \Sigma ^ { - \frac { 1 } { 2 } } ( x ) \\ & = \Sigma ^ { \frac { 1 } { 2 } } ( x ) \, \log \left ( \text {Id} + \varepsilon W + \frac { \varepsilon ^ { 2 } } { 2 } H + O ( \varepsilon ^ { 3 } ) \right )
$$

$$
= \Sigma ^ { \frac { 1 } { 2 } } ( x ) \, \log \left ( I d + \varepsilon W + \frac { \varepsilon ^ { 2 } } { 2 } H + O ( \varepsilon ^ { 3 } ) \right ) \, \Sigma ^ { \frac { 1 } { 2 } } ( x )
$$

where we put W =   − 1 2 ∂ u     − 1 2 and H =   − 1 2 ∂ 2 u     − 1 2 . From the Log series (Eq. ( 1 )), we get:

- - - - - - - - - - → /Sigma1 ( x ) /Sigma1 ( x + ε u )

$$
2 ( x ) 2 ( x + \varepsilon u ) \\ = \ \Sigma ^ { \frac { 1 } { 2 } } \left [ + \varepsilon W + \frac { \varepsilon ^ { 2 } } { 2 } H - \frac { 1 } { 2 } \left ( \varepsilon ^ { 2 } W ^ { 2 } \\ + \frac { \varepsilon ^ { 3 } } { 2 } ( W H + H W ) \right ) + \frac { \varepsilon ^ { 3 } } { 3 } W ^ { 3 } + O ( \varepsilon ^ { 4 } ) \right ] \, \Sigma ^ { \frac { 1 } { 2 } }
$$

The Taylor expansion of − −−−−−−−−− →   ( x )   ( x − ε u ) is obtained by replacing ε by − ε , so that we ﬁnally end up with − −−−−−−−−− →   ( x )   ( x + ε u ) + − −−−−−−−−− →   ( x )   ( x − ε u ) =   1 2 [ ε 2 H − ε 2 W 2 + O ( ε 4 )]   1 2 , which proves that

$$
\overline { \Sigma ( x ) \Sigma ( x + u ) } + \overline { \Sigma ( x ) \Sigma ( x - u ) } \\ = \partial _ { u } ^ { 2 } \Sigma - 2 \left ( \partial _ { u } \Sigma \right ) \Sigma ^ { - 1 } \left ( \partial _ { u } \Sigma \right ) + O ( \| u \| ^ { 4 } ) \\ = \Delta _ { u } \Sigma + O ( \| u \| ^ { 4 } )
$$

$$
= \Delta _ { u } \Sigma + O ( \| u \| ^ { 4 } )
$$

# Notes

1. To be mathematically correct, we should consider the quotient space S ym + n = GL + n / SO n instead of S ym + n = GL n / O n so that all spaces are simply connected.

2. On most homogeneous manifolds, this can only be realized locally. For instance, on the sphere, there is a singularity at the antipodal point of the chosen origin for any otherwise smooth placement function.

# References

Aubert, G. and Kornprobst, P. 2001. Mathematical Problems in Image Processing , vol. 147 of Applied Mathematical Sciences , Springer.

Basser, P., Mattiello, J., and Bihan, D.L. 1994. MR diffusion tensor spectroscopy and imaging. Biophysical Journal , 66:259–267.

Batchelor, P., Hill, D., Calamante, F., and Atkinson, D. 2001. Study of the connectivity in the brain using the full diffusion tensor from MRI. In Proc. of the 17th Int. Conf. on Information Processing in Medical Imaging (IPMI 2001) , M. Insana and R. Leahy (Eds.), vol. 2082 of LNCS , Springer Verlag, pp. 121–133. Bhatia, R. 2003. On the exponential metric increasing property.

Bhatia, R. 2003. On the exponential metric increasing Linear Algebra and its Applications , 375:211-220.

Cazals, F. and Boissonnat, J.-D. 2001. Natural coordinates of points on a surface. Comp. Geometry Theory and Applications , 19:155–173.

Chefd’hotel, C., Tschumperl´ e, D., Deriche, R., and Faugeras, O. 2002. Constrained ﬂows of matrix-valued functions: Application todiffusiontensorregularization.In Proc.ofECCV2002 ,Hayden et al., (Eds.), vol. 2350 of LNCS , Springer Verlag, pp. 251–265.

Chefd’hotel, C., Tschumperl´ e, D., Deriche, R. and Faugeras, O. 2004. Regularizing ﬂows for constrained matrix-valued images. J. Math. Imaging and Vision , 20(1/2):147–162.

Coulon, O., Alexander, D., and Arridge, S. 2001. A regularization scheme for diffusion tensor magnetic resonance images. In Proc. of the 17th Int. Conf. on Information Processing in Medical Imaging (IPMI 2001) , M. Insana, and R. Leahy (Eds.), vol. 2082 of LNCS , Springer Verlag. pp. 92–105.

Coulon, O., Alexander, D. and Arridge, S. 2004. Diffusion tensor magnetic resonance image regularization. Medical Image Analysis , 8(1):47–67.

Fillard, P., Gilmore, J., Piven, J., Lin, W., and Gerig, G. 2003. Quantitative analysis of white matter ﬁber properties along geodesic paths. In Proc. of MICCAI’03, Part II , R.E. Ellis and T.M. Peters (Eds.), vol. 2879 of LNCS , Montreal, Springer Verlag, pp. 16–23.

Fletcher, P.T. and Joshi, S.C. 2004. Principal geodesic analysis on symmetric spaces: Statistics of diffusion tensors. In Computer Vision and Mathematical Methods in Medical and Biomedical Image Analysis, ECCV 2004 Workshops CVAMIA and MMBIA, Prague, Czech Republic, May 15, 2004, vol. 3117 of LNCS , pp. 87–98. Springer.

F¨ orstner, W. and Moonen, B. 1999. A metric for covariance matrices. In Qua vadis geodesia ··· ? Festschrift for Erik W. Grafarend on the occasion of his 60th Birthday , F. Krumm and V.S. Schwarze (Eds.) number 1999.6 in Tech. Report of the Dpt of Geodesy and Geoinformatics, Stuttgart University, pp. 113–128.

Gallot, S., Hulin, D., and Lafontaine, J. 1993. Riemannian Geometry , 2nd edition, Springer Verlag.

Gamkrelidze, R. (Ed.) 1991. Geometry I , vol. 28 of Encyclopaedia of Mathematical Sciences , Springer Verlag.

Gerig, G., Kikinis, R., K¨ ubler, O., and Jolesz, F. 1992. Nonlinear anisotropic ﬁltering of MRI data. IEEE Transactions on Medical Imaging , 11(2):221–232.

[Page 26]

Helgason, S. 1978. Differential Geometry, Lie Groups, and Symmetric Spaces . Academic Press.

Kendall, M. and Moran, P. 1963. Geometrical Probability . No. 10 in Grifﬁn’s statistical monographs and courses. Charles Grifﬁn & Co. Ltd.

Kendall, W. 1990. Probability, convexity, and harmonic maps with small image I: Uniqueness and ﬁne existence. Proc. London Math. Soc. , 61(2):371–406.

Kobayashi, S. and Nomizu, K. 1969. Foundations of Differential Geometry , vol. II of Interscience Tracts in Pure and Applied Mathematics . John Wiley & Sons.

Le Bihan, D., Manguin, J.-F., Poupon, C., Clark, C., Pappata, S., Molko, N., and Chabriat, H. 2001. Diffusion tensor imaging: Concepts and applications. Journal Magnetic Resonance Imaging , 13(4):534–546.

Lenglet, C., Rousson, M., Deriche, R., and Faugeras, O. 2004a. Statistics on multivariate normal distributions: A geometric approach and its application to diffusion tensor MRI. Research Report 5242, INRIA.

Lenglet, C., Rousson, M., Deriche, R., and Faugeras, O. 2004b. Toward segmentation of 3D probability density ﬁelds by surface evolution: Application to diffusion MRI. Research Report 5243, INRIA.

Meijering, E. 2002. A chronology of interpolation: From ancient astronomy to modern signal and image processing. Proceedings of the IEEE , 90(3):319–342.

Nomizu, K. 1954. Invariant afﬁne connections on homogeneous spaces. American J. of Math. , 76:33–65.

Pennec, X. 1996. L’incertitude dans les probl ` emes de reconnaissance et de recalage—Applications en imagerie m ´ edicale et biologie mol ´ eculaire . Th` ese de sciences (PhD thesis), Ecole Polytechnique, Palaiseau (France).

Pennec, X. 1999. Probabilities and statistics on Riemannian manifolds: Basic tools for geometric measurements. In Proc. of Nonlinear Signal and Image Processing (NSIP’99) , A. Cetin, L. Akarun, A. Ertuzun, M. Gurcan, and Y. Yardimci (Eds.) June 20–23, Antalya, Turkey. vol. 1, pp. 194–198. IEEE-EURASIP,

Pennec, X. 2004. Probabilities and statistics on Riemannian manifolds: A geometric approach. Research Report 5093, INRIA. Int. Journal of Mathematical Imaging and Vision (submitted).

Pennec, X. and Ayache, N. 1998. Uniform distribution, distance and expectation problems for geometric features processing. Journal of Mathematical Imaging and Vision , 9(1):49–67.

Pennec, X. and Thirion, J.-P. 1997. A framework for uncertainty and validation of 3D registration methods based on points and frames. Int. Journal of Computer Vision , 25(3):203–229.

Perona, P. and Malik, J. 1990. Scale-space and edge detection using anisotropic diffusion. IEEE Trans. Pattern Analysis and Machine Intelligence (PAMI) , 12(7):629–639.

Poincar´ e, H. 1912. Calcul des probabilit ´ es , 2nd edition, Paris.

Rey, D., Subsol, G., Delingette, H., and Ayache, N. 2002. Automatic detection and segmentation of evolving processes in 3D medical images: Application to multiple sclerosis. Medical Image Analysis , 6(2):163–179.

Sapiro, G. 2001. Geometric Partial Differential Equations and Image Analysis . Cambridge University Press.

Sibson, R. 1981. A brief description of natural neighbour interpolation. In Interpreting Multivariate Data , V. Barnet (Ed.), John Wiley & Sons, Chichester, pp. 21–36.

Skovgaard, L. 1984. A Riemannian geometry of the multivariate normal model. Scand. J. Statistics , 11:211–223.

Th´ evenaz, P., Blu, T., and Unser, M. 2000. Interpolation revisited. IEEE Transactions on Medical Imaging , 19(7):739– 758.

Tschumperl´ e, D. 2002. PDE-Based Regularization of Multivalued Images and Applications . PhD thesis, University of Nice-Sophia Antipolis.

Tschumperl´ e, D. and Deriche, R. 2002. Orthonormal vector sets regularization with PDE’s and applications. International Journal on Computer Vision , 50(3):237–252.

Weickert, J. 1998. Anisotropic Diffusion in Image Processing . Teubner-Verlag.

Weickert, J. and Brox, T. 2002. Diffusion and regularization of vectorand matrix-valued images. In Inverse Problems, Image Analysis, and Medical Imaging. , M. Nashed and O. Scherzer (Eds.), vol. 313 of Contemporary Mathematics , Providence. AMS. pp. 251–268.

Westin, C., Maier, S., Mamata, H., Nabavi, A., Jolesz, F., and Kikinis, R. 2002. Processing and visualization for diffusion tensor MRI. Medical Image Analysis , 6(2):93–108.

