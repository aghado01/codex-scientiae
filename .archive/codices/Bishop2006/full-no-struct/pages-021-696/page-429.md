[Page 429]

Figure 8.51 A simple factor graph used to illustrate the sum-product algorithm.

x

x

x

![The image depicts a diagram of a geometric figure, specifically a circle. The circle is represented by a red circle with a diameter labeled as d and a radius labeled as r. The circle is divided into three smaller circles, each with a diameter labeled as d, and a radius labeled as r. These smaller circles are connected to each other by lines, forming a three-dimensional structure. The diagram includes the following elements: 1. **Circle**: The central circle is a circle with a diameter labeled as d. 2. **Smaller Circles**: There are three smaller circles connected to the central circle. These smaller circles are labeled as f1, f2, and f3. 3. **Line Segments**: There are two lines connecting the smaller circles to the central circle. These lines are labeled as d and r. 4. **Diameter and Radius**: The diameter of the circle is](../images/imageFile210.png)

1

2

3

f

f

a

b

f

c

x

4

p ( x ) = f a ( x 1 ,x 2 ) f b ( x 2 ,x 3 ) f c ( x 2 ,x 4 ) . (8.73) In order to apply the sum-product algorithm to this graph, let us designate node x 3 as the root, in which case there are two leaf nodes x 1 and x 4 . Starting with the leaf nodes, we then have the following sequence of six messages

$$
\mu _ { x _ { 1 } \rightarrow f _ { a } } ( x _ { 1 } ) \ = \ 1 \\
$$

$$
\mu _ { x _ { 1 } \rightarrow f _ { a } } ( x _ { 1 } ) \ & = \ 1 \\ \mu _ { f _ { a } \rightarrow x _ { 2 } } ( x _ { 2 } ) \ & = \ \sum _ { x _ { 1 } } f _ { a } ( x _ { 1 } , x _ { 2 } ) \\ \mu _ { x _ { 4 } \rightarrow f _ { c } } ( x _ { 4 } ) \ & = \ 1
$$

$$
\mu _ { x _ { 4 } \rightarrow f _ { c } } ( x _ { 4 } ) \ = \ 1 \\
$$

$$
\mu _ { x _ { 4 } \to f _ { c } } ( x _ { 4 } ) \ & = \ 1 \\ \mu _ { f _ { c } \to x _ { 2 } } ( x _ { 2 } ) \ & = \ \sum _ { x _ { 4 } } f _ { c } ( x _ { 2 } , x _ { 4 } ) \\ \mu _ { x _ { 2 } \to f _ { b } } ( x _ { 2 } ) \ & = \ \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { c } \to x _ { 3 } } ( x _ { 2 } )
$$

$$
\mu _ { x _ { 2 } \rightarrow f _ { b } } ( x _ { 2 } ) \ = \ \mu _ { f _ { a } \rightarrow x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { c } \rightarrow x _ { 2 } } ( x _ { 2 } ) \\
$$

$$
\mu _ { x _ { 2 } \to f _ { b } } ( x _ { 2 } ) \ & = \ \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { c } \to x _ { 2 } } ( x _ { 2 } ) \\ \mu _ { f _ { b } \to x _ { 3 } } ( x _ { 3 } ) \ & = \ \sum _ { x _ { 2 } } f _ { b } ( x _ { 2 } , x _ { 3 } ) \mu _ { x _ { 2 } \to f _ { b } } . \\ \intertext { t i o n f o f $ \i v o f $ the $ o s h e c $ m a s g h e c $ i s i l l u s t r o t d i n $ i n $ E i g u r o $ 8 . 5 $ O n o n $ this m a s }
$$

The direction of ﬂow of these messages is illustrated in Figure 8.52. Once this message propagation is complete, we can then propagate messages from the root node out to the leaf nodes, and these are given by

$$
\mu _ { x _ { 3 } \rightarrow f _ { b } } ( x _ { 3 } ) \ = \ 1 \\
$$

$$
\mu _ { x _ { 3 } \to f _ { b } } ( x _ { 3 } ) \ & = \ 1 \\ \mu _ { f _ { b } \to x _ { 2 } } ( x _ { 2 } ) \ & = \ \sum _ { x _ { 3 } } f _ { b } ( x _ { 2 } , x _ { 3 } ) \\ \mu _ { x _ { 2 } \to f _ { a } } ( x _ { 2 } ) \ & = \ \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } )
$$

$$
\mu _ { x _ { 2 } \to f _ { a } } ( x _ { 2 } ) \ = \ \mu _ { f _ { b } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { c } \to x _ { 2 } } ( x _ { 2 } ) \\ \\
$$

$$
\mu _ { x _ { 2 } \to f _ { a } } ( x _ { 2 } ) \ & = \ \mu _ { f _ { b } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { c } \to x _ { 2 } } ( x _ { 2 } ) \\ \mu _ { f _ { a } \to x _ { 1 } } ( x _ { 1 } ) \ & = \ \sum _ { x _ { 2 } } f _ { a } ( x _ { 1 } , x _ { 2 } ) \mu _ { x _ { 2 } \to f _ { a } } ( x _ { 2 } ) \\ \mu _ { x _ { 2 } \to f _ { c } } ( x _ { 2 } ) \ & = \ \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { b } \to x _ { 2 } } ( x _ { 2 } )
$$

$$
\mu _ { x _ { 2 } \to f _ { c } } ( x _ { 2 } ) \ = \ \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { b } \to x _ { 2 } } ( x _ { 2 } ) \\ \\
$$

$$
\mu _ { x _ { 2 } \to f _ { c } } ( x _ { 2 } ) \ & = \ \mu _ { f _ { a } \to x _ { 2 } } ( x _ { 2 } ) \mu _ { f _ { b } \to x _ { 2 } } ( x _ { 2 } ) \\ \mu _ { f _ { c } \to x _ { 4 } } ( x _ { 4 } ) \ & = \ \sum _ { x _ { 2 } } f _ { c } ( x _ { 2 } , x _ { 4 } ) \mu _ { x _ { 2 } \to f _ { c } } ( x _ { 2 } ) .
$$
