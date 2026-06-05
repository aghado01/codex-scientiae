[Page 393]

Figure 8.15 The ﬁrst of three examples of graphs over three variables a , b , and c used to discuss conditional independence properties of directed graphical models.

![image 174](../images/imageFile174.png)

a

b

$$
a \perp b \, | \, c \\ \intertext { a n d o n d o n t o f b i g v o n $ a $ o n d i s o u v i o n t o $ ( 8 2 0 ) $ }
$$

denotes that a is conditionally independent of b given c and is equivalent to (8.20).

Conditional independence properties play an important role in using probabilistic models for pattern recognition by simplifying both the structure of a model and the computations needed to perform inference and learning under that model. We shall see examples of this shortly.

If we are given an expression for the joint distribution over a set of variables in terms of a product of conditional distributions (i.e., the mathematical representation underlying a directed graph), then we could in principle test whether any potential conditional independence property holds by repeated application of the sum and product rules of probability. In practice, such an approach would be very time consuming. An important and elegant feature of graphical models is that conditional independence properties of the joint distribution can be read directly from the graph without having to perform any analytical manipulations. The general framework for achieving this is called d-separation , where the ‘d’ stands for ‘directed’ (Pearl, 1988). Here we shall motivate the concept of d-separation and give a general statement of the d-separation criterion. A formal proof can be found in Lauritzen (1996).

# 8.2.1 Three example graphs

We begin our discussion of the conditional independence properties of directed graphs by considering three simple examples each involving graphs having just three nodes. Together, these will motivate and illustrate the key concepts of d-separation. The ﬁrst of the three examples is shown in Figure 8.15, and the joint distribution corresponding to this graph is easily written down using the general result (8.5) to give

$$
p ( a , b , c ) & = p ( a | c ) p ( b | c ) p ( c ) . \\ \intertext { i r i o n g l e s } \intertext { w i t h e a n d } \intertext { i n t h e a n d } \intertext { w i t h e a n d } \intertext { i n t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext { w i t h e a n d } \intertext {
$$

If none of the variables are observed, then we can investigate whether a and b are independent by marginalizing both sides of (8.23) with respect to c to give

$$
\text {marginalizing bounds of} \, ( 8 . 2 3 ) \text { with respect to } c \, \text {to give} \\ p ( a , b ) = \sum _ { c } p ( a | c ) p ( b | c ) p ( c ) . \\ \text {does not factorize into the product } p ( a ) p ( b ) \text { and so}
$$

In general, this does not factorize into the product p ( a ) p ( b ) , and so

$$
a \not { \subset } b \, | \, \emptyset
$$
