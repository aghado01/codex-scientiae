[Page 16]

$$
d _ { b } ( d g m ( F i l t ( \mathbb { X } _ { 0 } ) ) , d g m ( F i l t ( \mathbb { X } _ { 1 , n } ) ) ) & = \min _ { p \in \Delta } \| p - ( 0 , \rho ( x , x _ { n } ) ) \$$
| _ { \infty }
$$ \\ & = \frac { \rho ( x , x _ { n } ) } { 2 } .
$$

$$
| _ { \infty }
$$

$$
^ { 2 }
$$

The proof is then complete using Le Cam’s lemma (Lemma 6.5).  

## 7. Persistence Landscapes

Persistence landscapes have been introduced in [Bub15] as an alternative representation of persistence diagrams. This approach aims at representing the topological information encoded in persistence diagrams as elements of an Hilbert space, for which statistical learning methods can be directly applied.

7.1. Construction. The persistence landscape is a collection of continuous, piecewise linear functions λ : N × R → R that summarizes a persistence diagram dgm (see Figure 7). The landscape is deﬁned by considering the set of tent functions at each point p = ( x,y ) = α birth + α death 2 , α death − α birth 2 representing a birth-death pair ( α birth ,α death ) ∈ dgm as follows:

![The image is a diagram, which consists of a graph with two axes labeled as x and y. The graph is a line graph, and it is drawn with a dashed line. The x-axis is labeled as x and the y-axis is labeled as y. The graph has two points labeled as A and B. Point A is located at the left side of the graph, and point B is located at the right side of the graph. The graph is connected by a dashed line, which is labeled as t. The dashed line is drawn from point A to point B.](<PH-REF/imageFile12.png>)

$$
Λ p ( t ) =      t - x + y t ∈ [ x - y, x ] x + y - t t ∈ ( x, x + y ] 0 otherwise =      t - α birth t ∈ [ α birth , α birth + α death 2 ] α death - t t ∈ ( α birth + α death 2 , α death ] 0 otherwise .
$$


-




+






,


)


+




,


)




,


)


Figure 7. An example of persistence landscape (right) associated to a persistence diagram (left). The ﬁrst landscape is in blue, the second one in red and the last one in orange. All the other landscapes are zero.

The persistence landscape of dgm is a summary of the arrangement of the tents display obtained by overlaying the graphs of the functions { Λ p } p ∈ dgm .
