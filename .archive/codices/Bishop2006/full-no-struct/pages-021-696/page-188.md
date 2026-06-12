[Page 188]

Figure 3.14 Plot of the model evidence versus the order M , for the polynomial regression model, showing that the evidence favours the model with M = 3 .

![The image is a line graph that shows the trend of a variable over time. The x-axis represents the time in years, ranging from 0 to 26 years. The y-axis represents the value, ranging from 0 to 26. The graph shows a general upward trend, with a slight dip in the middle of the graph. The graph has a linear scale of range 0 to 26 on the x-axis, starting from 0 and ending at 26. The graph also has a linear scale of range from 0 to 26 on the y-axis, starting from 0 and ending at 26. The graph has a blue line that shows the trend of the variable over time. The line starts at a value of 0 and goes up to 26, then decreases to 0 and then up to 26. The line then goes down to 0 and then up to 2](../images/imageFile86.png)

−18

−20

−22

−24

−26

0

2

4

6

8

M

# 3.5.2 Maximizing the evidence function

Let us ﬁrst consider the maximization of p ( t | α,β ) with respect to α . This can be done by ﬁrst deﬁning the following eigenvector equation

$$
\text {ing the following eigenvector equation} \\ ( \beta \Phi ^ { T } \Phi ) \, u _ { i } = \lambda _ { i } u _ { i } . \\ \text {allows that A has eigenvalues $\alpha+\lambda_{i}$. Now consider the deriva-
ring in | A | in (3.86) with respect to $\alpha$. We have
$$

From (3.81), it then follows that A has eigenvalues α + λ i . Now consider the derivative of the term involving ln | A | in (3.86) with respect to α . We have d d d 1

$$
t h e r o & \text {in} \ln | \alpha | \ln ( 3 . 8 0 ) \text { with respect to } \alpha \colon \text { we have } \\ & \frac { d } { d \alpha } \ln | A | = \frac { d } { d \alpha } \ln \prod _ { i } ( \lambda _ { i } + \alpha ) = \frac { d } { d \alpha } \sum _ { i } \ln ( \lambda _ { i } + \alpha ) = \sum _ { i } \frac { 1 } { \lambda _ { i } + \alpha } . \quad ( 3 . 8 8 ) \\ & \text {Thus the stationary points of } ( 3 . 8 6 ) \text { with respect to } \alpha \text { satisfy }
$$

Thus the stationary points of (3.86) with respect to α satisfy

$$
0 = \frac { M } { 2 \alpha } - \frac { 1 } { 2 } m _ { N } ^ { T } m _ { N } - \frac { 1 } { 2 } \sum _ { i } \frac { 1 } { \lambda _ { i } + \alpha } .
$$
