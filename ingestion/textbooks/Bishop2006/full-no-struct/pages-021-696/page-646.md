[Page 646]

Figure 13.15 A simpliﬁed form of factor graph to describe the hidden Markov model.

f

![image 315](../images/imageFile315.png)

h

n

z

z

z

-

n

n

1

1

To derive the alpha-beta algorithm, we denote the ﬁnal hidden variable z N as the root node, and ﬁrst pass messages from the leaf node h to the root. From the general results (8.66) and (8.69) for message propagation, we see that the messages which are propagated in the hidden Markov model take the form

$$
\mu _ { z _ { n - 1 } \rightarrow f _ { n } } ( z _ { n - 1 } ) \ = \ \mu _ { f _ { n - 1 } \rightarrow z _ { n - 1 } } ( z _ { n - 1 } )
$$

$$
\mu _ { z _ { n - 1 } \to f _ { n } } ( z _ { n - 1 } ) \ = \ \mu _ { f _ { n - 1 } \to z _ { n - 1 } } ( z _ { n - 1 } ) \\ \mu _ { f _ { n } \to z _ { n } } ( z _ { n } ) \ = \ \sum _ { z _ { n - 1 } } f _ { n } ( z _ { n - 1 } , z _ { n } ) \mu _ { z _ { n - 1 } } \\
$$

$$
\mu _ { f _ { n } \to z _ { n } } ( z _ { n } ) \ = \ \sum _ { z _ { n - 1 } } f _ { n } ( z _ { n - 1 } , z _ { n } ) \mu _ { z _ { n - 1 } \to f _ { n } } ( z _ { n - 1 } ) \quad
$$

These equations represent the propagation of messages forward along the chain and are equivalent to the alpha recursions derived in the previous section, as we shall now show. Note that because the variable nodes z n have only two neighbours, they perform no computation.

We can eliminate µ z n − 1 → f n ( z n − 1 ) from (13.48) using (13.47) to give a recursion for the f → z messages of the form

$$
\mu _ { f _ { n } \to z _ { n } } ( z _ { n } ) & = \sum _ { z _ { n - 1 } } f _ { n } ( z _ { n - 1 } , z _ { n } ) \mu _ { f _ { n - 1 } \to z _ { n - 1 } } ( z _ { n - 1 } ) . \\ \\
$$

If we now recall the deﬁnition (13.46), and if we deﬁne

$$
\alpha ( z _ { n } ) = \mu _ { f _ { n } \rightarrow z _ { n } } ( z _ { n } )
$$

then we obtain the alpha recursion given by (13.36). We also need to verify that the quantities α ( z n ) are themselves equivalent to those deﬁned previously. This is easily done by using the initial condition (8.71) and noting that α ( z 1 ) is given by h ( z 1 ) = p ( z 1 ) p ( x 1 | z 1 ) which is identical to (13.37). Because the initial α is the same, and because they are iteratively computed using the same equation, all subsequent α quantities must be the same.

Next we consider the messages that are propagated from the root node back to the leaf node. These take the form

$$
\text {the real node.} \, \text {these take the 1from} \\ \mu _ { f _ { n + 1 } \to f _ { n } } ( z _ { n } ) = \sum _ { z _ { n + 1 } } f _ { n + 1 } ( z _ { n } , z _ { n + 1 } ) \mu _ { f _ { n + 2 } \to f _ { n + 1 } } ( z _ { n + 1 } ) \\ \\ \mu _ { n + 1 } \to f _ { n } ( z _ { n } ) = \sum _ { z _ { n + 1 } } f _ { n + 1 } ( z _ { n } , z _ { n + 1 } ) \mu _ { f _ { n + 2 } \to f _ { n + 1 } } ( z _ { n + 1 } ) \\
$$

where, as before, we have eliminated the messages of the type z → f since the variable nodes perform no computation. Using the deﬁnition (13.46) to substitute for f n +1 ( z n , z n +1 ) , and deﬁning

$$
\beta ( z _ { n } ) = \mu _ { f _ { n + 1 } \rightarrow z _ { n } } ( z _ { n } )
$$
