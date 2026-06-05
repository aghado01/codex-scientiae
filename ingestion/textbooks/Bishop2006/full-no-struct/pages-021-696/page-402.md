[Page 402]

![In this image, we can see a diagram.](../images/imageFile184.png)

p

(

)

DF

x

We can view a graphical model (in this case a directed graph) as a ﬁlter in which a probability distribution p ( x ) is allowed through the ﬁlter if, and only if, it satisﬁes the directed factorization property (8.5). The set of all possible probability distributions p ( x ) that pass through the ﬁlter is denoted DF . We can alternatively use the graph to ﬁlter distributions according to whether they respect all of the conditional independencies implied by the d-separation properties of the graph. The d-separation theorem says that it is the same set of distributions DF that will be allowed through this second kind of ﬁlter.

tions p ( x ) . At the other extreme, we have the fully disconnected graph, i.e., one having no links at all. This corresponds to joint distributions which factorize into the product of the marginal distributions over the variables comprising the nodes of the graph.

Note that for any given graph, the set of distributions DF will include any distributions that have additional independence properties beyond those described by the graph. For instance, a fully factorized distribution will always be passed through the ﬁlter implied by any graph over the corresponding set of variables.

We end our discussion of conditional independence properties by exploring the concept of a Markov blanket or Markov boundary . Consider a joint distribution p ( x 1 ,..., x D ) represented by a directed graph having D nodes, and consider the conditional distribution of a particular node with variables x i conditioned on all of the remaining variables x j = i . Using the factorization property (8.5), we can express this conditional distribution in the form

/negationslash

$$
\begin{array} { r l } { \tt a l d i b u t i o n i n e i n t h e f o r m } & { \quad p ( x _ { 1 } , \dots , x _ { D } ) } \\ & { \quad = } & { \int p ( x _ { 1 } , \dots , x _ { D } ) \, d x _ { i } } \\ & { \quad } & { \prod _ { k } p ( x _ { k } | p a _ { k } ) } \\ & { = } & { \int \prod _ { k } p ( x _ { k } | p a _ { k } ) \, d x _ { i } } \\ & { \quad } & { \int \prod _ { k } p ( x _ { k } | p a _ { k } ) \, d x _ { i } } \end{array}
$$

/negationslash

in which the integral is replaced by a summation in the case of discrete variables. We now observe that any factor p ( x k | pa k ) that does not have any functional dependence on x i can be taken outside the integral over x i , and will therefore cancel between numerator and denominator. The only factors that remain will be the conditional distribution p ( x i | pa i ) for node x i itself, together with the conditional distributions for any nodes x k such that node x i is in the conditioning set of p ( x k | pa k ) , in other words for which x i is a parent of x k . The conditional p ( x i | pa i ) will depend on the parents of node x i , whereas the conditionals p ( x k | pa k ) will depend on the children
