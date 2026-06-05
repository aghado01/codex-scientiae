[Page 439]

Table 8.2 The joint distribution over three binary variables.

| a   | b   | c   | p ( a, b, c ) |
| --- | --- | --- | ------------- |
| 0   | 0   | 0   | 0.192         |
| 0   | 0   | 1   | 0.144         |
| 0   | 1   | 0   | 0.048         |
| 0   | 1   | 1   | 0.216         |
| 1   | 0   | 0   | 0.192         |
| 1   | 0   | 1   | 0.064         |
| 1   | 1   | 0   | 0.048         |
| 1   | 1   | 1   | 0.096         |

![image 213](../images/imageFile213.png)

a

b

c

p

(

a, b, c

)

0

0

0

0.192

0

0

1

0.144

0

1

0

0.048

1

1

0.216

0

1

0

0

0.192

1

0

1

0.064

1

1

0

0.048

1

1

1

0.096

8.3 ( ) Consider three binary variables a,b,c ∈ { 0 , 1 } having the joint distribution given in Table 8.2. Show by direct evaluation that this distribution has the property that a and b are marginally dependent, so that p ( a,b ) = p ( a ) p ( b ) , but that they become independent when conditioned on c , so that p ( a,b | c ) = p ( a | c ) p ( b | c ) for both c = 0 and c = 1 .

/negationslash

8.4 ( ) Evaluate the distributions p ( a ) , p ( b | c ) , and p ( c | a ) corresponding to the joint distribution given in Table 8.2. Hence show by direct evaluation that p ( a,b,c ) = p ( a ) p ( c | a ) p ( b | c ) . Draw the corresponding directed graph.

8.5

( ) www Draw a directed probabilistic graphical model corresponding to the relevance vector machine described by (7.79) and (7.80).

8.6 ( ) For the model shown in Figure 8.13, we have seen that the number of parameters required to specify the conditional distribution p ( y | x 1 ,...,x M ) , where x i ∈ { 0 , 1 } , could be reduced from 2 M to M +1 by making use of the logistic sigmoid representation (8.10). An alternative representation (Pearl, 1988) is given by

$$
p ( y = 1 | x _ { 1 } , \dots , x _ { M } ) = 1 - ( 1 - \mu _ { 0 } ) \prod _ { i = 1 } ^ { M } ( 1 - \mu _ { i } ) ^ { x _ { i } } \quad ( 8 . 1 0 4 ) \\ \intertext { r o w t h e p o r m o t i m a r s } \left ( 0 , \dots , x _ { M } \right ) = \intertext { s o r w h e p o r m o t i m a r s } \intertext { a n d } \intertext { o n d } \intertext { s o r w h e p o r m o t i m a r s } \intertext { e q n o d } \intertext { i s e a n d }
$$

where the parameters µ i represent the probabilities p ( x i = 1) , and µ 0 is an additional parameters satisfying 0 µ 0 1 . The conditional distribution (8.104) is known as the noisy-OR . Show that this can be interpreted as a ‘soft’ (probabilistic) form of the logical OR function (i.e., the function that gives y = 1 whenever at least one of the x i = 1 ). Discuss the interpretation of µ 0 .

8.7 ( ) Using the recursion relations (8.15) and (8.16), show that the mean and covariance of the joint distribution for the graph shown in Figure 8.14 are given by (8.17) and (8.18), respectively.

8.8 ( ) www Show that a ⊥ b,c | d implies a ⊥ b | d .

8.9 ( ) www Using the d-separation criterion, show that the conditional distribution for a node x in a directed graph, conditioned on all of the nodes in the Markov blanket, is independent of the remaining variables in the graph.
