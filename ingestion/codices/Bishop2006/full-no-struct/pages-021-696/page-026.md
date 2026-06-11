[Page 26]

Figure 1.3 The error function (1.2) corresponds to (one half of) the sum of the squares of the displacements (shown by the vertical green bars) of each data point from the function y ( x, w ) .

![The image depicts a graph with two lines, labeled as y(x, w) and y(x, w). The x-axis is labeled as t and the y-axis is labeled as w. The graph is a line graph, with the x-axis labeled as t and the y-axis labeled as w. The line is drawn from the point (0, 0) to the point (1, 1) on the graph. The line starts at the point (0, 0) and extends upwards to the point (1, 1) on the graph. The line then starts at the point (0, 0) and extends upwards to the point (1, 1) on the graph. The line then starts at the point (0, 0) and extends upwards to the point (1, 1) on the graph. The line then starts at the point (0, 0) and extends upwards](../images/imageFile6.png)

t

n

t

y

(

x

,

)

n

w

x

x

n

Exercise 1.1

We can solve the curve ﬁtting problem by choosing the value of w for which E ( w ) is as small as possible. Because the error function is a quadratic function of the coefﬁcients w , its derivatives with respect to the coefﬁcients will be linear in the elements of w , and so the minimization of the error function has a unique solution, denoted by w , which can be found in closed form. The resulting polynomial is given by the function y ( x, w ) .

There remains the problem of choosing the order M of the polynomial, and as we shall see this will turn out to be an example of an important concept called model comparison or model selection . In Figure 1.4, we show four examples of the results of ﬁtting polynomials having orders M = 0 , 1 , 3 , and 9 to the data set shown in Figure 1.2.

We notice that the constant ( M = 0 ) and ﬁrst order ( M = 1 ) polynomials give rather poor ﬁts to the data and consequently rather poor representations of the function sin(2 πx ) . The third order ( M = 3 ) polynomial seems to give the best ﬁt to the function sin(2 πx ) of the examples shown in Figure 1.4. When we go to a much higher order polynomial ( M = 9 ), we obtain an excellent ﬁt to the training data. In fact, the polynomial passes exactly through each data point and E ( w ) = 0 . However, the ﬁtted curve oscillates wildly and gives a very poor representation of the function sin(2 πx ) . This latter behaviour is known as over-ﬁtting .

As we have noted earlier, the goal is to achieve good generalization by making accurate predictions for new data. We can obtain some quantitative insight into the dependence of the generalization performance on M by considering a separate test set comprising 100 data points generated using exactly the same procedure used to generate the training set points but with new choices for the random noise values included in the target values. For each choice of M , we can then evaluate the residual value of E ( w ) given by (1.2) for the training data, and we can also evaluate E ( w ) for the test data set. It is sometimes more convenient to use the root-mean-square
