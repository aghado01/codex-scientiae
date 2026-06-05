[Page 201]

(McCullagh and Nelder, 1989). Note, however, that in contrast to the models used for regression, they are no longer linear in the parameters due to the presence of the nonlinear function f ( · ) . This will lead to more complex analytical and computational properties than for linear regression models. Nevertheless, these models are still relatively simple compared to the more general nonlinear models that will be studied in subsequent chapters.

The algorithms discussed in this chapter will be equally applicable if we ﬁrst make a ﬁxed nonlinear transformation of the input variables using a vector of basis functions φ ( x ) as we did for regression models in Chapter 3. We begin by considering classiﬁcation directly in the original input space x , while in Section 4.3 we shall ﬁnd it convenient to switch to a notation involving basis functions for consistency with later chapters.

# 4.1. Discriminant Functions

A discriminant is a function that takes an input vector x and assigns it to one of K classes, denoted C k . In this chapter, we shall restrict attention to linear discriminants , namely those for which the decision surfaces are hyperplanes. To simplify the discussion, we consider ﬁrst the case of two classes and then investigate the extension to K > 2 classes.

# 4.1.1 Two classes

The simplest representation of a linear discriminant function is obtained by taking a linear function of the input vector so that

$$
y ( x ) = w ^ { T } x + w _ { 0 }
$$

where w is called a weight vector , and w 0 is a bias (not to be confused with bias in the statistical sense). The negative of the bias is sometimes called a threshold . An input vector x is assigned to class C 1 if y ( x ) 0 and to class C 2 otherwise. The corresponding decision boundary is therefore deﬁned by the relation y ( x ) = 0 , which corresponds to a ( D − 1) -dimensional hyperplane within the D -dimensional input space. Consider two points x A and x B both of which lie on the decision surface. Because y ( x A ) = y ( x B ) = 0 , we have w T ( x A − x B ) = 0 and hence the vector w is orthogonal to every vector lying within the decision surface, and so w determines the orientation of the decision surface. Similarly, if x is a point on the decision surface, then y ( x ) = 0 , and so the normal distance from the origin to the decision surface is given by T

$$
\frac { w ^ { T } x } { \| w \| } = - \frac { w _ { 0 } } { \| w \| } . \\ \intertext { i n s } \text {bias parameter } w _ { 0 } \detemrimes the location of the decision }
$$

We therefore see that the bias parameter w 0 determines the location of the decision surface. These properties are illustrated for the case of D = 2 in Figure 4.1.

Furthermore, we note that the value of y ( x ) gives a signed measure of the perpendicular distance r of the point x from the decision surface. To see this, consider
