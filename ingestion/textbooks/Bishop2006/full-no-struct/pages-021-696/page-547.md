[Page 547]

![The image depicts a graph with two lines, labeled p(y) and h(y). The graph is a line graph, with the x-axis labeled as y and the y-axis labeled as h(y). The graph shows two peaks and two troughs. ### Graph Description: - **Line 1:** - The graph starts at the point (0, 0) and extends upwards to the left. - The line starts at the point (0, 0) and extends upwards to the left. - The line then starts at the point (0, 0) and extends upwards to the left. - The line then starts at the point (0, 0) and extends upwards to the left. - The line then starts at the point (0, 0) and extends upwards to the left. - The line then starts at the point (0, 0) and extends upwards to](../images/imageFile254.png)

Figure 11.2 Geometrical interpretation of the transformation method for generating nonuniformly distributed random numbers. h ( y ) is the indeﬁnite integral of the desired distribution p ( y ) . If a uniformly distributed random variable z is transformed using y = h − 1 ( z ) , then y will be distributed according to p ( y ) .

1

h

(

y

)

p

(

y

)

0

y

# Exercise 11.3

Another example of a distribution to which the transformation method can be applied is given by the Cauchy distribution

$$
p ( y ) = \frac { 1 } { \pi } \frac { 1 } { 1 + y ^ { 2 } } .
$$

In this case, the inverse of the indeﬁnite integral can be expressed in terms of the ‘ tan ’ function.

The generalization to multiple variables is straightforward and involves the Jacobian of the change of variables, so that

$$
& \text {an of the change of variables, so that} \\ & \quad p ( y _ { 1 } , \dots , y _ { M } ) = p ( z _ { 1 } , \dots , z _ { M } ) \left | \frac { \partial ( z _ { 1 } , \dots , z _ { M } ) } { \partial ( y _ { 1 } , \dots , y _ { M } ) } \right | . \\ & \text {As a final example of the transformation method we consider the Box-Muller} \\ & \text {for generating samples from a Gaussian distribution. First suppose we gen-}
$$

p ( y 1 ,...,y M ) = p ( z 1 ,...,z M ) 1 M ∂ ( y 1 ,...,y M ) . (11.9) As a ﬁnal example of the transformation method we consider the Box-Muller method for generating samples from a Gaussian distribution. First, suppose we generate pairs of uniformly distributed random numbers z 1 ,z 2 ∈ ( − 1 , 1) , which we can do by transforming a variable distributed uniformly over (0 , 1) using z → 2 z − 1 . Next we discard each pair unless it satisﬁes z 2 1 + z 2 2 1 . This leads to a uniform distribution of points inside the unit circle with p ( z 1 ,z 2 ) = 1 /π , as illustrated in Figure 11.3. Then, for each pair z 1 ,z 2 we evaluate the quantities

Figure 11.3 The Box-Muller method for generating Gaussian distributed random numbers starts by generating samples from a uniform distribution inside the unit circle.

![image 255](../images/imageFile255.png)

1

z

2

-

1

z

-

1

1

1
