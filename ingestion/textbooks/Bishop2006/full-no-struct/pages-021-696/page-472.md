[Page 472]

Figure 9.12

![The image depicts a graph with two axes labeled as KL(q_p) = 0 and ln p(X_p) = 0. The graph is a horizontal line graph with a single point labeled ln p(X_p) = 0. The x-axis is labeled ln p(X_p) and the y-axis is labeled KL(q_p). The graph has two horizontal lines, one labeled ln p(X_p) and the other labeled ln k(q_p). The graph is connected with a vertical line labeled ln p(X_p) = 0. ### Graph Description: - **Horizontal Axis (X-axis)**: Labeled as ln p(X_p) and labeled as ln k(q_p). - **Vertical Axis (Y-axis)**: Labeled as ln p(X_p) and](../images/imageFile227.png)

||

KL( q

q

p

= 0

old )

old )

L

|

θ

θ

(

q,

)

ln p

p

(

)

X

shown in Figure 9.13. If we substitute q ( Z ) = p ( Z | X , θ old ) into (9.71), we see that, after the E step, the lower bound takes the form

$$
a n t e l e s t e , t i n e l o w b o u d t a k e t h s i l l \\ \mathcal { L } ( q , \theta ) & \ = \ \sum _ { Z } p ( Z | X , \theta ^ { o l d } ) \ln p ( X , Z | \theta ) - \sum _ { Z } p ( Z | X , \theta ^ { o l d } ) \ln p ( Z | X , \theta ^ { o l d } ) \\ & = \ \mathcal { Q } ( \theta , \theta ^ { o l d } ) + c o n s t \\ \intertext { w h e r e } \text {where the constant } \text {is simply the negative entropy of the } \text {a distribution and is there} .
$$

where the constant is simply the negative entropy of the q distribution and is therefore independent of θ . Thus in the M step, the quantity that is being maximized is the expectation of the complete-data log likelihood, as we saw earlier in the case of mixtures of Gaussians. Note that the variable θ over which we are optimizing appears only inside the logarithm. If the joint distribution p ( Z , X | θ ) comprises a member of the exponential family, or a product of such members, then we see that the logarithm will cancel the exponential and lead to an M step that will be typically much simpler than the maximization of the corresponding incomplete-data log likelihood function p ( X | θ ) . The operation of the EM algorithm can also be viewed in the space of parame-

ters, as illustrated schematically in Figure 9.14. Here the red curve depicts the (in-

Figure 9.13

Illustration of the M step of the EM algorithm. The distribution q ( Z ) is held ﬁxed and the lower bound L ( q, θ ) is maximized with respect to the parameter vector θ to give a revised value θ new . Because the KL divergence is nonnegative, this causes the log likelihood ln p ( X | θ ) to increase by at least as much as the lower bound does.

![In this image there is a graph with two nodes and one of them is labeled as KL(q,l).](../images/imageFile228.png)

||

KL( q

q

p

)

new )

new )

L

|

θ

θ

(

q,

)

ln p

p

(

)

X
