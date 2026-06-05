[Page 535]

x

x

x

x

x

x

![The image is a diagram or a diagrammatic representation of a set of interconnected circles. Each circle is connected to the others by a red line, forming a network. The circles are connected by red dots, which are used to represent the points of interest or points of interest in the diagram. The diagram is structured with a series of circles, each connected to the others by a red line. The circles are labeled with different numbers, which are used to represent the distances between the points of interest. The circles are connected by red dots, which are used to represent the points of interest. The diagram is structured with a series of circles, each connected to the others by a red line. The circles are labeled with different numbers, which are used to represent the distances between the points of interest. The circles are connected by red dots, which are used to represent the points of interest. The diagram is structured with a series of circles, each connected to the others by a red](../images/imageFile251.png)

1

2

3

1

2

3

˜

˜

˜

˜

f

f

f

f

f

f

a

b

a

a

b

b

1

2

2

3

˜

f

c

2

f

c

˜

f

c

4

x

x

4

4

Figure 10.18 On the left is a simple factor graph from Figure 8.51 and reproduced here for convenience. On the right is the corresponding factorized approximation.

f b ( x 2 ,x 3 ) = f b 2 ( x 2 ) f b 3 ( x 3 ) . We ﬁrst remove this factor from the approximating distribution to give q \ b ( x ) = f ( x ) f ( x ) f ( x ) f ( x ) (10.228)

$$
q ^ { \vee b } ( x ) & = \widetilde { f } _ { a 1 } ( x _ { 1 } ) \widetilde { f } _ { a 2 } ( x _ { 2 } ) \widetilde { f } _ { c 2 } ( x _ { 2 } ) \widetilde { f } _ { c 4 } ( x _ { 4 } ) \\ \intertext { e n t i p l y s i t h y b e y t e x a c t f o r $ f _ { b } ( x _ { 2 } , x _ { 3 } ) $ t o g i v e } & \widetilde { f } _ { 2 } & \widetilde { f } _ { 3 } & \widetilde { f } _ { 2 } & \widetilde { f } _ { 3 }
$$

        and we then multiply this by the exact factor f b ( x 2 ,x 3 ) to give

p ( x ) = q \ b ( x ) f b ( x 2 ,x 3 ) = f a 1 ( x 1 ) f a 2 ( x 2 ) f c 2 ( x 2 ) f c 4 ( x 4 ) f b ( x 2 ,x 3 ) . (10.229) We now ﬁnd q new ( x ) by minimizing the Kullback-Leibler divergence KL( p q new ) . The result, as noted above, is that q new ( z ) comprises the product of factors, one for each variable x i , in which each factor is given by the corresponding marginal of p ( x ) . These four marginals are given by p ( x 1 ) ∝ f a 1 ( x 1 ) (10.230) p ( x 2 ) ∝ f a 2 ( x 2 ) f c 2 ( x 2 ) x 3 f b ( x 2 ,x 3 ) (10.231) p ( x 3 ) ∝ f b ( x 2 ,x 3 ) f a 2 ( x 2 ) f c 2 ( x 2 ) (10.232)

$$
\widehat { p } ( x _ { 3 } ) & \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

p ( x 4 ) ∝ f c 4 ( x 4 ) (10.233) and q new ( x ) is obtained by multiplying these marginals together. We see that the only factors in q ( x ) that change when we update f b ( x 2 ,x 3 ) are those that involve the variables in f b namely x 2 and x 3 . To obtain the reﬁned factor f b ( x 2 ,x 3 ) = f b 2 ( x 2 ) f b 3 ( x 3 ) we simply divide q new ( x ) by q \ b ( x ) , which gives f b 2 ( x 2 ) ∝ f b ( x 2 ,x 3 ) (10.234)

$$
f _ { b 3 } ( x _ { 3 } ) & \ w c \text { simply and} \ q ^ { ( x ) \ b y \ q ^ { \prime } \cdot ( x ) , \text { when} \ g v c s } \\ & \widetilde { f } _ { b 2 } ( x _ { 2 } ) \ \times \ \sum _ { x _ { 3 } } f _ { b } ( x _ { 2 } , x _ { 3 } ) & & ( 1 0 . 2 3 4 ) \\ & \widetilde { f } _ { b 3 } ( x _ { 3 } ) \ \times \ \sum \left \{ f _ { b } ( x _ { 2 } , x _ { 3 } ) \widetilde { f } _ { a 2 } ( x _ { 2 } ) \widetilde { f } _ { c 2 } ( x _ { 2 } ) \right \} . & & ( 1 0 . 2 3 5 )
$$

$$
\widetilde { f } _ { b 3 } ( x _ { 3 } ) \ \subset \ \sum _ { x _ { 2 } } \left \{ f _ { b } ( x _ { 2 } , x _ { 3 } ) \widetilde { f } _ { a 2 } ( x _ { 2 } ) \widetilde { f } _ { c 2 } ( x _ { 2 } ) \right \} .
$$
