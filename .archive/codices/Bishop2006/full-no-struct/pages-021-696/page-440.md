[Page 440]

Figure 8.54 Example of a graphical model used to explore the conditional independence properties of the head-to-head path a – c – b when a descendant of c , namely the node d , is observed.

![image 214](../images/imageFile214.png)

a

b

c

d

8.10 ( ) Consider the directed graph shown in Figure 8.54 in which none of the variables is observed. Show that a ⊥ b | ∅ . Suppose we now observe the variable d . Show that in general a ⊥ b | d .

8.11 ( ) Consider the example of the car fuel system shown in Figure 8.21, and suppose that instead of observing the state of the fuel gauge G directly, the gauge is seen by the driver D who reports to us the reading on the gauge. This report is either that the gauge shows full D = 1 or that it shows empty D = 0 . Our driver is a bit unreliable, as expressed through the following probabilities

$$
p ( D & = 1 | G = 1 ) \ = \ 0 . 9 \\ p ( D & = 0 | G = 0 ) \ = \ 0 . 9
$$

$$
p ( D = 0 | G = 0 ) \ = \ 0 . 9 .
$$

Suppose that the driver tells us that the fuel gauge shows empty, in other words that we observe D = 0 . Evaluate the probability that the tank is empty given only this observation. Similarly, evaluate the corresponding probability given also the observation that the battery is ﬂat, and note that this second probability is lower. Discuss the intuition behind this result, and relate the result to Figure 8.54.

8.12 ( ) www Show that there are 2 M ( M − 1) / 2 distinct undirected graphs over a set of M distinct random variables. Draw the 8 possibilities for the case of M = 3 .

8.13 ( ) Consider the use of iterated conditional modes (ICM) to minimize the energy function given by (8.42). Write down an expression for the difference in the values of the energy associated with the two states of a particular variable x j , with all other variables held ﬁxed, and show that it depends only on quantities that are local to x j in the graph.

8.14 ( ) Consider a particular case of the energy function given by (8.42) in which the coefﬁcients β = h = 0 . Show that the most probable conﬁguration of the latent variables is given by x i = y i for all i .

8.15 ( ) www Show that the joint distribution p ( x n − 1 ,x n ) for two neighbouring nodes in the graph shown in Figure 8.38 is given by an expression of the form (8.58).
