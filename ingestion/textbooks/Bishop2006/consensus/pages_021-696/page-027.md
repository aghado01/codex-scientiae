[Page 27]

![The image is a graph consisting of four different lines, each represented by a different color. The lines are connected by a horizontal line and a vertical line. The x-axis is labeled as t and the y-axis is labeled as M. The graph is titled M = 0 and has a label M = 1. Each line in the graph has a different color: 1. The first line is red and has a label of M = 0 on the x-axis. 2. The second line is green and has a label of M = 0 on the x-axis. 3. The third line is blue and has a label of M = 0 on the x-axis. 4. The fourth line is green and has a label of M = 0 on the x-axis. Each line has a different slope and a different value of M.](../images/imageFile7.png)

Figure 1.4 Plots of polynomials having various orders $M$, shown as red curves, fitted to the data set shown in Figure 1.2.

(RMS) error defined by

$$
E_{\text{RMS}} = \sqrt{2E(\mathbf{w}^{\star})/N} \tag{1.3}
$$

in which the division by $N$ allows us to compare different sizes of data sets on an equal footing, and the square root ensures that $E_{\text{RMS}}$ is measured on the same scale (and in the same units) as the target variable $t$. Graphs of the training and test set RMS errors are shown, for various values of $M$, in Figure 1.5. The test set error is a measure of how well we are doing in predicting the values of $t$ for new data observations of $x$. We note from Figure 1.5 that small values of $M$ give relatively large values of the test set error, and this can be attributed to the fact that the corresponding polynomials are rather inflexible and are incapable of capturing the oscillations in the function $\sin(2\pi x)$. Values of $M$ in the range $3 \le M \le 8$ give small values for the test set error, and these also give reasonable representations of the generating function $\sin(2\pi x)$, as can be seen, for the case of $M = 3$, from Figure 1.4.
