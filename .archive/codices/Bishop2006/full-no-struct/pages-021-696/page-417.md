[Page 417]

Figure 8.38 The marginal distribution p ( x n ) for a node x n along the chain is obtained by multiplying the two messages µ α ( x n ) and µ β ( x n ) , and then normalizing. These messages can themselves be evaluated recursively by passing messages from both ends of the chain towards node x n .

![image 197](../images/imageFile197.png)

(

x

)

(

x

)

µ

µ

µ

(

x

)

µ

(

x

)

β

n

β

n

-

α

n

α

n

+1 )

1

x

x

x

x

x

-

n

n

n

N

1

1

+1

along the chain to node x n from node x n +1 . Note that each of the messages comprises a set of K values, one for each choice of x n , and so the product of two messages should be interpreted as the point-wise multiplication of the elements of the two messages to give another set of K values.

The message µ α ( x n ) can be evaluated recursively because

$$
The message \mu _ { \alpha } ( x _ { n } ) \, \text { can be evaluated recursively because} \\ \\ \mu _ { \alpha } ( x _ { n } ) \ = \ \sum _ { n = 1 } \psi _ { n - 1 , n } ( x _ { n - 1 } , x _ { n } ) \begin{bmatrix} \sum _ { n = 2 } \dots \\ \sum _ { n - 1 } \end{bmatrix} \\ = \ \sum _ { x _ { n - 1 } } \psi _ { n - 1 , n } ( x _ { n - 1 } , x _ { n } ) \mu _ { \alpha } ( x _ { n - 1 } ) . \\
$$

We therefore ﬁrst evaluate

$$
\text {evaluate} \\ \mu _ { \alpha } ( x _ { 2 } ) = \sum _ { x _ { 1 } } \psi _ { 1 , 2 } ( x _ { 1 } , x _ { 2 } ) \\ \\ 5 5 ) \text {rotally until} \, \text {wo} \, \text {reach} \, \text {the} \, \text {dod} \, \text {node} \, \text {. Note} \, \text {are} \, \text {fully} \, \text {the}
$$

and then apply (8.55) repeatedly until we reach the desired node. Note carefully the structure of the message passing equation. The outgoing message µ α ( x n ) in (8.55) is obtained by multiplying the incoming message µ α ( x n − 1 ) by the local potential involving the node variable and the outgoing variable and then summing over the node variable.

Similarly, the message µ β ( x n ) can be evaluated recursively by starting with node x N and using

$$
x _ { N } \text { and using} \\ \mu _ { \beta } ( x _ { n } ) \ = \ \sum _ { x _ { n + 1 } } \psi _ { n + 1 , n } ( x _ { n + 1 } , x _ { n } ) \begin{bmatrix} \sum ( \dots ) \\ \sum ( x _ { n + 2 } ) \end{bmatrix} \\ = \ \sum _ { x _ { n + 1 } } \psi _ { n + 1 , n } ( x _ { n + 1 } , x _ { n } ) \mu _ { \beta } ( x _ { n + 1 } ) . \\ \intertext { c r e u s i v e m s s a g e p a s i n g s i l u r a t i o n } \text {recursive message passing is illustrated in Figure 8.38. The normalization con- }
$$

This recursive message passing is illustrated in Figure 8.38. The normalization constant Z is easily evaluated by summing the right-hand side of (8.54) over all states of x n , an operation that requires only O ( K ) computation. Graphs of the form shown in Figure 8.38 are called , and the

Markov chains corresponding message passing equations represent an example of the ChapmanKolmogorov equations for Markov processes (Papoulis, 1984).
