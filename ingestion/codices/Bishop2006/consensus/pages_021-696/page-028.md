[Page 28]

Figure 1.5 Graphs of the root-mean-square error, defined by (1.3), evaluated on the training set and on an independent test set for various values of $M$.

![The image is a line graph titled Training and Test. The graph is composed of two lines, each represented by a different color. The x-axis is labeled M and the y-axis is labeled Ers. The line on the left side of the graph is blue and represents Training and the line on the right side of the graph is red and represents Test. The graph shows a trend of decreasing training and test scores over time. The training line starts at a low point and then decreases, reaching a low point in the middle of the graph. The test line starts at a high point and then decreases, reaching a high point in the middle of the graph. The graph also includes a scale from 0 to 1, which indicates the range of values represented by the lines. The x-axis is labeled M and the y-axis is labeled Ers. The graph is labeled as Training and Test](../images/imageFile8.png)

For $M = 9$, the training set error goes to zero, as we might expect because this polynomial contains $10$ degrees of freedom corresponding to the $10$ coefficients $w_0, \ldots, w_9$, and so can be tuned exactly to the $10$ data points in the training set. However, the test set error has become very large and, as we saw in Figure 1.4, the corresponding function $y(x, \mathbf{w}^{\star})$ exhibits wild oscillations.

This may seem paradoxical because a polynomial of given order contains all lower order polynomials as special cases. The $M = 9$ polynomial is therefore capable of generating results at least as good as the $M = 3$ polynomial. Furthermore, we might suppose that the best predictor of new data would be the function $\sin(2\pi x)$ from which the data was generated (and we shall see later that this is indeed the case). We know that a power series expansion of the function $\sin(2\pi x)$ contains terms of all orders, so we might expect that results should improve monotonically as we increase $M$.

We can gain some insight into the problem by examining the values of the coefficients $\mathbf{w}^{\star}$ obtained from polynomials of various order, as shown in Table 1.1. We see that, as $M$ increases, the magnitude of the coefficients typically gets larger. In particular for the $M = 9$ polynomial, the coefficients have become finely tuned to the data by developing large positive and negative values so that the correspond-

Table 1.1 Table of the coefficients $\mathbf{w}^{\star}$ for polynomials of various order. Observe how the typical magnitude of the coefficients increases dramatically as the order of the polynomial increases.

| | $M = 0$ | $M = 1$ | $M = 3$ | $M = 9$ |
| :--- | :--- | :--- | :--- | :--- |
| $w_0^{\star}$ | $0.19$ | $0.82$ | $0.31$ | $0.35$ |
| $w_1^{\star}$ | | $-1.27$ | $7.99$ | $232.37$ |
| $w_2^{\star}$ | | | $-25.43$ | $-5321.83$ |
| $w_3^{\star}$ | | | $17.37$ | $48568.31$ |
| $w_4^{\star}$ | | | | $-231639.30$ |
| $w_5^{\star}$ | | | | $640042.26$ |
| $w_6^{\star}$ | | | | $-1061800.52$ |
| $w_7^{\star}$ | | | | $1042400.18$ |
| $w_8^{\star}$ | | | | $-557682.99$ |
| $w_9^{\star}$ | | | | $125201.43$ |
