[Page 642]

# Figure 13.13

Illustration of the backward recursion (13.38) for evaluation of the β variables. In this fragment of the lattice, we see that the quantity β ( z n 1 ) is obtained by taking the components β ( z n +1 ,k ) of β ( z n +1 ) at step n + 1 and summing them up with weights given by the products of A 1 k , corresponding to the values of p ( z n +1 | z n ) and the corresponding values of the emission density p ( x n | z n +1 ,k ) .

![In this image, we can see a diagram with some text and numbers. There are some objects and there are some lines.](../images/imageFile313.png)

)

β

(

z

)

β

(

z

n,

n

,

1

+1

1

A

11

k

= 1

|

p

(

z

)

A

n

n

,

+1

1

12

x

β

(

z

)

n

,

+1

2

k

= 2

A

13

|

p

(

z

)

n

n

,

+1

2

x

)

β

(

z

n

,

+1

3

k

= 3

n

n

- 1

|

p

(

z

)

n

n

,

+1

3

x

Making use of the deﬁnition (13.35) for β ( z n ) , we then obtain

$$
\text {ing use of the definition (13.55) for } & \beta ( z _ { n } ) , \text { we then obtain} \\ & \beta ( z _ { n } ) = \sum _ { z _ { n + 1 } } \beta ( z _ { n + 1 } ) p ( x _ { n + 1 } | z _ { n + 1 } ) p ( z _ { n + 1 } | z _ { n } ) . \\ \text {that in this case we have a backward message passing algorithm that evaluates}
$$

Note that in this case we have a backward message passing algorithm that evaluates β ( z n ) in terms of β ( z n +1 ) . At each step, we absorb the effect of observation x n +1 through the emission probability p ( x n +1 | z n +1 ) , multiply by the transition matrix p ( z n +1 | z n ) , and then marginalize out z n +1 . This is illustrated in Figure 13.13. Again we need a starting condition for the recursion, namely a value for β ( z N ) .

This can be obtained by setting n = N in (13.33) and replacing α ( z N ) with its deﬁnition (13.34) to give

$$
p ( z _ { N } | X ) = \frac { p ( X , z _ { N } ) \beta ( z _ { N } ) } { p ( X ) }
$$

which we see will be correct provided we take β ( z N ) = 1 for all settings of z N . In the M step equations, the quantity ( X ) will cancel out, as can be seen,

p for instance, in the M-step equation for µ k given by (13.20), which takes the form

$$
\text {e, in the } M { \text {step equation for } \mu _ { k } \text { given by } ( 1 3 . 2 0 ) , \text { which takes the form } \\ \sum _ { n = 1 } ^ { n } \gamma ( z _ { n k } ) x _ { n } & \sum _ { n = 1 } ^ { n } \alpha ( z _ { n k } ) \beta ( z _ { n k } ) x _ { n } \\ \mu _ { k } = \frac { n = 1 } { n } & = \frac { n = 1 } { n } . \\ \sum _ { n = 1 } ^ { n } \gamma ( z _ { n k } ) & \sum _ { n = 1 } ^ { n } \alpha ( z _ { n k } ) \beta ( z _ { n k } ) \\ \text {er, the quantity } p ( X ) \text { represents the likelihood function whose value we typ-} \\
$$

However, the quantity p ( X ) represents the likelihood function whose value we typically wish to monitor during the EM optimization, and so it is useful to be able to evaluate it. If we sum both sides of (13.33) over z n , and use the fact that the left-hand side is a normalized distribution, we obtain Thus we can evaluate the likelihood function by computing this sum, for any convenient choice of n . For instance, if we only want to evaluate the likelihood function, then we can do this by running the α recursion from the start to the end of the chain, and then use this result for n = N , making use of the fact that β ( z N ) is a vector of 1s. In this case no β recursion is required, and we simply have

$$
d \text { distribution, we obtain } & & p ( X ) = \sum _ { z _ { n } } \alpha ( z _ { n } ) \beta ( z _ { n } ) .
$$
