[Page 31]

Table 1.2 Table of the coefficients $\mathbf{w}$ for $M = 9$ polynomials with various values for the regularization parameter $\lambda$. Note that $\ln \lambda = -\infty$ corresponds to a model with no regularization, i.e., to the graph at the bottom right in Figure 1.4. We see that, as the value of $\lambda$ increases, the typical magnitude of the coefficients gets smaller.

| coefficient | $\ln \lambda = -\infty$ | $\ln \lambda = -18$ | $\ln \lambda = 0$ |
| ----------- | ----------------------: | ------------------: | ----------------: |
| $w_0$       |                    0.35 |                0.35 |              0.13 |
| $w_1$       |                  232.37 |                4.74 |             -0.05 |
| $w_2$       |                -5321.83 |               -0.77 |             -0.06 |
| $w_3$       |                48568.31 |              -31.97 |             -0.05 |
| $w_4$       |              -231639.30 |               -3.89 |             -0.03 |
| $w_5$       |               640042.26 |               55.28 |             -0.02 |
| $w_6$       |             -1061800.52 |               41.32 |             -0.01 |
| $w_7$       |              1042400.18 |              -45.95 |             -0.00 |
| $w_8$       |              -557682.99 |              -91.53 |              0.00 |
| $w_9$       |               125201.43 |               72.68 |              0.01 |

the magnitude of the coefficients.

The impact of the regularization term on the generalization error can be seen by plotting the value of the RMS error (1.3) for both training and test sets against $\ln \lambda$, as shown in Figure 1.8. We see that in effect $\lambda$ now controls the effective complexity of the model and hence determines the degree of over-ﬁtting.

The issue of model complexity is an important one and will be discussed at length in Section 1.3. Here we simply note that, if we were trying to solve a practical application using this approach of minimizing an error function, we would have to ﬁnd a way to determine a suitable value for the model complexity. The results above suggest a simple way of achieving this, namely by taking the available data and partitioning it into a training set, used to determine the coefﬁcients $\mathbf{w}$, and a separate validation set, also called a hold-out set, used to optimize the model complexity (either $M$ or $\lambda$). In many cases, however, this will prove to be too wasteful of valuable training data, and we have to seek more sophisticated approaches.

So far our discussion of polynomial curve ﬁtting has appealed largely to intuition. We now seek a more principled approach to solving problems in pattern recognition by turning to a discussion of probability theory. As well as providing the foundation for nearly all of the subsequent developments in this book, it will also

Figure 1.8 Graph of the root-mean-square error (1.3) versus $\ln \lambda$ for the $M = 9$ polynomial.

![The image is a line graph titled Training and Test. The graph has a blue and red color scheme. The x-axis is labeled Enms, and the y-axis is labeled Enms. The graph shows the percentage of employees who have been trained and tested in the last 30 days. The training and testing percentages are shown as blue bars, and the percentage of employees who have been trained and tested is shown as red bars. The graph has a horizontal axis labeled Enms and a vertical axis labeled Enms. The x-axis is labeled Enms, and the y-axis is labeled Enms. The graph shows the percentage of employees who have been trained and tested in the last 30 days. The training and testing percentages are shown as blue bars, and the percentage of employees who have been trained and tested is shown as red bars. The graph has a title at the top of the image, which reads](../../../../../images/imageFile11.png)

1

Training

Test

E RMS

0.5

E

0

−35

−30

−25

−20

ln λ

λ
