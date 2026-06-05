[Page 389]

Figure 8.11 An extension of the model of Figure 8.10 to include Dirichlet priors over the parameters governing the discrete distributions.

µ

µ

µ

![The image depicts a diagram with three interconnected circles. Each circle is connected to the others by a line, forming a network. The circles are labeled with the following: - **Circle A**: This circle is connected to Circle B, which is connected to Circle C, and to Circle D, which is connected to Circle E. - **Circle B**: This circle is connected to Circle A, which is connected to Circle C, and to Circle F, which is connected to Circle G. - **Circle C**: This circle is connected to Circle B, which is connected to Circle A, and to Circle H, which is connected to Circle J. - **Circle D**: This circle is connected to Circle E, which is connected to Circle F, and to Circle H, which is connected to Circle J. The diagram is labeled with the following: - **Circle A**: The circle is connected to Circle B, which is connected to](../images/imageFile170.png)

M

1

2

M

1

2

x

x

x

Figure 8.12 As in Figure 8.11 but with a single set of parameters µ shared amongst all of the conditional distributions p ( x i | x i − 1 ) .

µ

µ

![In this image, we can see a diagram with some lines and points. We can also see some text and numbers.](../images/imageFile171.png)

1

M

1

2

x

x

x

ter µ i representing the probability p ( x i = 1) , giving M parameters in total for the parent nodes. The conditional distribution p ( y | x 1 ,...,x M ) , however, would require 2 M parameters representing the probability p ( y = 1) for each of the 2 M possible settings of the parent variables. Thus in general the number of parameters required to specify this conditional distribution will grow exponentially with M . We can obtain a more parsimonious form for the conditional distribution by using a logistic sigmoid function acting on a linear combination of the parent variables, giving

$$
\text {sign} o d \, f o r \, x _ { 1 } \, \dots , x _ { M } \, ) = \sigma \left ( w _ { 0 } + \sum _ { i = 1 } ^ { M } w _ { i } x _ { i } \right ) = \sigma ( w ^ { T } x ) \quad ( 8 . 1 0 ) \\ \intertext { w h e r $ \sigma ( a ) = ( 1 + \exp ( \ a ) ) ^ { - 1 } $ }
$$

where σ ( a ) = (1+exp( − a )) − 1 is the logistic sigmoid, x = ( x 0 ,x 1 ,...,x M ) T is an ( M + 1) -dimensional vector of parent states augmented with an additional variable x 0 whose value is clamped to 1, and w = ( w 0 ,w 1 ,...,w M ) T is a vector of M + 1 parameters. This is a more restricted form of conditional distribution than the general case but is now governed by a number of parameters that grows linearly with M . In this sense, it is analogous to the choice of a restrictive form of covariance matrix (for example, a diagonal matrix) in a multivariate Gaussian distribution. The motivation for the logistic sigmoid representation was discussed in Section 4.2.

Figure 8.13 A graph comprising M parents x 1 , . . . , x M and a single child y , used to illustrate the idea of parameterized conditional distributions for discrete variables.

x

x

![image 172](../images/imageFile172.png)

M

1

y
