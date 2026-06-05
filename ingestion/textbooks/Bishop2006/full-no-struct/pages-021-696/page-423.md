[Page 423]

x

x

x

x

x

x

![The image is a diagram of a chemical reaction involving two chemical entities, labeled as A and B. The diagram is a line graph, with the arrows indicating the direction of the reaction. The arrows are connected to the reactants and products, indicating the direction of the reaction. The diagram includes the following elements: 1. **A** (A) is connected to **B** (B) on the left side of the graph. 2. **B** (B) is connected to **A** (A) on the right side of the graph. 3. **A** (A) is connected to **B** (B) on the left side of the graph. 4. **B** (B) is connected to **A** (A) on the right side of the graph. 5. **A** (A) is connected to **B** (B) on the left side of the graph. 6. **B**](../images/imageFile204.png)

f

1

2

1

2

1

2

a

f

(

x

,x 2

,x 3

)

1

2

3

f

f

b

c

x

x

x

3

3

3

(a)

(b)

(c)

Figure 8.45 (a) A fully connected undirected graph. (b) and (c) Two factor graphs each of which corresponds to the undirected graph in (a).

There is an algorithm for exact inference on directed graphs without loops known as belief propagation (Pearl, 1988; Lauritzen and Spiegelhalter, 1988), and is equivalent to a special case of the sum-product algorithm. Here we shall consider only the sum-product algorithm because it is simpler to derive and to apply, as well as being more general.

We shall assume that the original graph is an undirected tree or a directed tree or polytree, so that the corresponding factor graph has a tree structure. We ﬁrst convert the original graph into a factor graph so that we can deal with both directed and undirected models using the same framework. Our goal is to exploit the structure of the graph to achieve two things: (i) to obtain an efﬁcient, exact inference algorithm for ﬁnding marginals; (ii) in situations where several marginals are required to allow computations to be shared efﬁciently.

We begin by considering the problem of ﬁnding the marginal p ( x ) for particular variable node x . For the moment, we shall suppose that all of the variables are hidden. Later we shall see how to modify the algorithm to incorporate evidence corresponding to observed variables. By deﬁnition, the marginal is obtained by summing the joint distribution over all variables except x so that

$$
p ( x ) = \sum _ { x \vee x } p ( x ) \\ \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e r i g h l e s } \intertext { s o f v e
$$

where x \ x denotes the set of variables in x with variable x omitted. The idea is to substitute for p ( x ) using the factor graph expression (8.59) and then interchange summations and products in order to obtain an efﬁcient algorithm. Consider the fragment of graph shown in Figure 8.46 in which we see that the tree structure of the graph allows us to partition the factors in the joint distribution into groups, with one group associated with each of the factor nodes that is a neighbour of the variable node x . We see that the joint distribution can be written as a product of the form

$$
\ p ( x ) = \prod _ { s \in \real { n } ( x ) } F _ { s } ( x , X _ { s } ) \\ \intertext { t h e f f o r g h e d s t h e r w h e f n o w h e r w h e d }
$$

ne( x ) denotes the set of factor nodes that are neighbours of x , and X s denotes the set of all variables in the subtree connected to the variable node x via the factor node
