[Page 424]

Figure 8.46 A fragment of a factor graph illustrating the evaluation of the marginal p ( x ) .

![The image is a diagram of a graph, which is a graphical representation of data points. The graph consists of two main components: a horizontal axis labeled as f(x) and a vertical axis labeled as f(x). The horizontal axis is labeled as f(x) = 0 and the vertical axis is labeled as f(x) = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 = 0 =](../images/imageFile205.png)

µ

(

x

)

→

f

x

s

)

s

x, X

(

f

x

s

s

F

Substituting (8.62) into (8.61) and interchanging the sums and products, we obtain

$$
\ m a t h s c r { G } & = \prod _ { s \in \text {ne} ( x ) } \left [ \sum _ { X _ { s } } F _ { s } ( x , X _ { s } ) \right ] \\ & = \prod _ { s \in \text {ne} ( x ) } \mu _ { f _ { s } \to x } ( x ) . \\ \intertext { i n t r o d u c e d a s t o f f u n c t i o n s \mu _ { f _ { s } \to x } ( x ) , \, \text { defined by } }
$$

Here we have introduced a set of functions µ f s → x ( x ) , deﬁned by

$$
\mu _ { f _ { s } \to x } ( x ) & \equiv \sum _ { X _ { s } } F _ { s } ( x , X _ { s } ) \\ \intertext { w e d a s m e g a s e r s } \mu _ { f _ { s } \to x } ( x ) & \equiv \sum _ { X _ { s } } F _ { s } ( x , X _ { s } ) \\ \intertext { w e d a s m e g a s e r s } \intertext { w e d a s m e g a s e r s } \intertext { x }
$$

which can be viewed as messages from the factor nodes f s to the variable node x . We see that the required marginal p ( x ) is given by the product of all the incoming messages arriving at node x .

In order to evaluate these messages, we again turn to Figure 8.46 and note that each factor F s ( x,X s ) is described by a factor (sub-)graph and so can itself be factorized. In particular, we can write

$$
F _ { s } ( x , X _ { s } ) = f _ { s } ( x , x _ { 1 } , \dots , x _ { M } ) G _ { 1 } \left ( x _ { 1 } , X _ { s 1 } \right ) \dots G _ { M } \left ( x _ { M } , X _ { s M } \right )
$$

where, for convenience, we have denoted the variables associated with factor f x , in addition to x , by x 1 ,...,x M . This factorization is illustrated in Figure 8.47. Note that the set of variables { x,x 1 ,...,x M } is the set of variables on which the factor f s depends, and so it can also be denoted x s , using the notation of (8.59).

Substituting (8.65) into (8.64) we obtain

$$
\text {Substituting (8.65) into (8.64) we obtain} \\ \mu _ { f _ { s } \to x } ( x ) \ = \ \sum _ { x _ { 1 } } \dots \sum _ { x _ { M } } f _ { s } ( x , x _ { 1 } , \dots , x _ { M } ) \prod _ { m \in \text {ne} ( f _ { s } ) \wedge x } \left [ \sum _ { X _ { x _ { m } } } G _ { m } ( x _ { m } , X _ { s m } ) \right ] \\ = \ \sum _ { x _ { 1 } } \dots \sum _ { x _ { M } } f _ { s } ( x , x _ { 1 } , \dots , x _ { M } ) \prod _ { m \in \text {ne} ( f _ { s } ) \wedge x } \mu _ { x _ { m } \to f _ { s } } ( x _ { m } ) \quad ( 8 . 6 6 )
$$
