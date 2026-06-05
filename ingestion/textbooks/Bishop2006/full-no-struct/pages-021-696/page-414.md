[Page 414]

Figure 8.37 A graphical representation of Bayes’ theorem. See the text for details.

x

x

x

![image 196](../images/imageFile196.png)

y

y

y

(a)

(b)

(c)

To start with, let us consider the graphical interpretation of Bayes’ theorem. Suppose we decompose the joint distribution p ( x,y ) over two variables x and y into a product of factors in the form p ( x,y ) = p ( x ) p ( y | x ) . This can be represented by the directed graph shown in Figure 8.37(a). Now suppose we observe the value of y , as indicated by the shaded node in Figure 8.37(b). We can view the marginal distribution p ( x ) as a prior over the latent variable x , and our goal is to infer the corresponding posterior distribution over x . Using the sum and product rules of probability we can evaluate

$$
p ( y ) = \sum _ { x ^ { \prime } } p ( y | x ^ { \prime } ) p ( x ^ { \prime } ) \\ \intertext { s e d i n $ B a v e s $ the o r m e t o c u l l a p l e c u l l a t i o n }
$$

which can then be used in Bayes’ theorem to calculate

$$
p ( x | y ) = \frac { p ( y | x ) p ( x ) } { p ( y ) } .
$$

Thus the joint distribution is now expressed in terms of p ( y ) and p ( x | y ) . From a graphical perspective, the joint distribution p ( x,y ) is now represented by the graph shown in Figure 8.37(c), in which the direction of the arrow is reversed. This is the simplest example of an inference problem for a graphical model.

# 8.4.1 Inference on a chain

Now consider a more complex problem involving the chain of nodes of the form shown in Figure 8.32. This example will lay the foundation for a discussion of exact inference in more general graphs later in this section.

Speciﬁcally, we shall consider the undirected graph in Figure 8.32(b). We have already seen that the directed chain can be transformed into an equivalent undirected chain. Because the directed graph does not have any nodes with more than one parent, this does not require the addition of any extra links, and the directed and undirected versions of this graph express exactly the same set of conditional independence statements.
