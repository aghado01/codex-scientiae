[Page 429]

Figure 8.51 A simple factor graph used to illustrate the

sum-product algorithm.

x1 x2 x3

fa fb

fc

x4

graph whose unnormalized joint distribution is given by

�p(x) = fa(x1,x2)fb(x2,x3)fc(x2,x4). (8.73)

In order to apply the sum-product algorithm to this graph, let us designate node x3 as the root, in which case there are two leaf nodes x1 and x4. Starting with the leaf nodes, we then have the following sequence of six messages

1→fa(x1) = 1 (8.74) µf

µx

�

a→x2(x2) =

fa(x1,x2) (8.75)

x1

4→fc(x4) = 1 (8.76) µf

µx

�

c→x2(x2) =

fc(x2,x4) (8.77)

x4

c→x2(x2) (8.78) µf

2→fb(x2) = µf

a→x2(x2)µf

µx

�

b→x3(x3) =

fb(x2,x3)µx

2→fb. (8.79)

x2

The direction of ﬂow of these messages is illustrated in Figure 8.52. Once this message propagation is complete, we can then propagate messages from the root node out to the leaf nodes, and these are given by

3→fb(x3) = 1 (8.80) µf

µx

�

b→x2(x2) =

fb(x2,x3) (8.81)

x3

c→x2(x2) (8.82) µf

2→fa(x2) = µf

b→x2(x2)µf

µx

�

2→fa(x2) (8.83) µx

a→x1(x1) =

fa(x1,x2)µx

x2

b→x2(x2) (8.84) µf

2→fc(x2) = µf

a→x2(x2)µf

�

c→x4(x4) =

fc(x2,x4)µx

2→fc(x2). (8.85)

x2
