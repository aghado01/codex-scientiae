[Page 395]

Figure 8.18 As in Figure 8.17 but now conditioning on node c .

![image 177](../images/imageFile177.png)

a

c

b

which in general does not factorize into p ( a ) p ( b ) , and so

$$
a \not { \subset } b \, | \, \emptyset
$$

as before.

Now suppose we condition on node c , as shown in Figure 8.18. Using Bayes’ theorem, together with (8.26), we obtain

$$
\begin{array} { r l } { p ( a , b | c ) } & { = } & { \frac { p ( a , b , c ) } { p ( c ) } } \\ & { = } & { \frac { p ( a ) p ( c | a ) p ( b | c ) } { p ( c ) } } \\ & { = } & { p ( a | c ) p ( b | c ) } \end{array}
$$

and so again we obtain the conditional independence property

$$
a \perp b | c .
$$

As before, we can interpret these results graphically. The node c is said to be head-to-tail with respect to the path from node a to node b . Such a path connects nodes a and b and renders them dependent. If we now observe c , as in Figure 8.18, then this observation ‘blocks’ the path from a to b and so we obtain the conditional independence property a ⊥ b | c . Finally, we consider the third of our 3-node examples, shown by the graph in

Figure 8.19. As we shall see, this has a more subtle behaviour than the two previous graphs.

The joint distribution can again be written down using our general result (8.5) to give

$$
p ( a , b , c ) = p ( a ) p ( b ) p ( c | a , b ) . \\ \\ \intertext { p ( a , b , c ) = p ( a ) p ( b ) p ( c | a , b ) . }
$$

Consider ﬁrst the case where none of the variables are observed. Marginalizing both sides of (8.28) over c we obtain

$$
p ( a , b ) = p ( a ) p ( b )
$$

Figure 8.19 The last of our three examples of 3-node graphs used to explore conditional independence properties in graphical models. This graph has rather different properties from the two previous examples.

![image 178](../images/imageFile178.png)

a

b

c
