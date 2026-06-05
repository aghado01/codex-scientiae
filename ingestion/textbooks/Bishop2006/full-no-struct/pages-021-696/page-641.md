[Page 641]

# Figure 13.12

Illustration of the forward recursion (13.36) for evaluation of the α variables. In this fragment of the lattice, we see that the quantity α ( z n 1 ) is obtained by taking the elements α ( z n − 1 ,j ) of α ( z n − 1 ) at step n − 1 and summing them up with weights given by A j 1 , corresponding to the values of p ( z n | z n − 1 ) , and then multiplying by the data contribution p ( x n | z n 1 ) .

![The image is a diagram of a mathematical problem involving a sequence of numbers. The problem is presented as a sequence of numbers, with each number being a different value. The sequence starts with the number 1 and goes up to the number 10. The sequence is represented by a sequence of 10 numbers, with each number being a different value. The sequence starts with the number 1, which is represented by the letter a in the image. The sequence then goes up to the number 10, which is represented by the letter a1 in the image. The sequence then goes up to the number 11, which is represented by the letter a2 in the image. The sequence then goes up to the number 12, which is represented by the letter a3 in the image. The sequence then goes up to the number 13, which is represented by the letter a4 in the image.](../images/imageFile312.png)

)

)

α

(

z

α

(

z

-

n

,

n,

1

1

1

A

11

k

= 1

A

|

p

(

z

)

21

n

n,

1

x

)

α

(

z

-

n

,

1

2

k

= 2

A

31

)

α

(

z

-

n

,

1

3

k

= 3

-

n

1

n

It is worth taking a moment to study this recursion relation in some detail. Note that there are K terms in the summation, and the right-hand side has to be evaluated for each of the K values of z n so each step of the α recursion has computational cost that scaled like O ( K 2 ) . The forward recursion equation for α ( z n ) is illustrated using a lattice diagram in Figure 13.12.

In order to start this recursion, we need an initial condition that is given by

$$
\alpha ( z _ { 1 } ) = p ( x _ { 1 } , z _ { 1 } ) = p ( z _ { 1 } ) p ( x _ { 1 } | z _ { 1 } ) = \prod _ { k = 1 } ^ { K } \{ \pi _ { k } p ( x _ { 1 } | \phi _ { k } ) \} ^ { z _ { 1 k } } \\ \intertext { w h i o n t l o s w h e t h o r } \quad \intertext { w h i o n t l o s w h e t h o r }
$$

which tells us that α ( z 1 k ) , for k = 1 ,...,K , takes the value π k p ( x 1 | φ k ) . Starting at the ﬁrst node of the chain, we can then work along the chain and evaluate α ( z n ) for every latent node. Because each step of the recursion involves multiplying by a K × K matrix, the overall cost of evaluating these quantities for the whole chain is of O ( K 2 N ) .

We can similarly ﬁnd a recursion relation for the quantities β ( z n ) by making use of the conditional independence properties (13.27) and (13.28) giving

$$
\text {use of the conditional independence properties (13.27) and (13.28) giving} \\ & \quad \beta ( z _ { n } ) \ = \ p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } ) \\ & = \ \sum _ { z _ { n + 1 } } p ( x _ { n + 1 } , \dots , x _ { N } , z _ { n + 1 } | z _ { n } ) \\ & = \ \sum _ { z _ { n + 1 } } p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n } , z _ { n + 1 } ) p ( z _ { n + 1 } | z _ { n } ) \\ & = \ \sum _ { z _ { n + 1 } } p ( x _ { n + 1 } , \dots , x _ { N } | z _ { n + 1 } ) p ( z _ { n + 1 } | z _ { n } ) \\ & = \ \sum _ { z _ { n + 1 } } p ( x _ { n + 2 } , \dots , x _ { N } | z _ { n + 1 } ) p ( x _ { n + 1 } | z _ { n + 1 } ) p ( z _ { n + 1 } | z _ { n } ) .
$$
