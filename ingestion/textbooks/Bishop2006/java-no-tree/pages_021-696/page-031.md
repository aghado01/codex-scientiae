[Page 31]

Table 1.2 Table of the coefﬁcients w for M = 9 polynomials with various values for the regularization parameter λ. Note that ln λ = −∞ corresponds to a model with no regularization, i.e., to the graph at the bottom right in Figure 1.4. We see that, as the value of λ increases, the typical magnitude of the coefﬁcients gets smaller.

| |lnλ = −∞ lnλ = −18 lnλ = 0|
|---|---|
|w 0<br><br>w 1<br><br>w 2<br><br>w 3<br><br>w 4<br><br>w 5<br><br>w 6<br><br>w 7<br><br>w 8<br><br>w 9<br><br><br>|0.35 0.35 0.13 232.37 4.74 -0.05<br><br>-5321.83 -0.77 -0.06 48568.31 -31.97 -0.05<br>-231639.30 -3.89 -0.03 640042.26 55.28 -0.02<br>-1061800.52 41.32 -0.01 1042400.18 -45.95 -0.00<br>-557682.99 -91.53 0.00 125201.43 72.68 0.01<br>|


the magnitude of the coefﬁcients.

The impact of the regularization term on the generalization error can be seen by plotting the value of the RMS error (1.3) for both training and test sets against lnλ, as shown in Figure 1.8. We see that in effect λ now controls the effective complexity of the model and hence determines the degree of over-ﬁtting.

The issue of model complexity is an important one and will be discussed at length in Section 1.3. Here we simply note that, if we were trying to solve a practical application using this approach of minimizing an error function, we would have to ﬁnd a way to determine a suitable value for the model complexity. The results above suggest a simple way of achieving this, namely by taking the available data and partitioning it into a training set, used to determine the coefﬁcients w, and a separate validation set, also called a hold-out set, used to optimize the model complexity (either M or λ). In many cases, however, this will prove to be too wasteful of

Section 1.3 valuable training data, and we have to seek more sophisticated approaches.

So far our discussion of polynomial curve ﬁtting has appealed largely to intuition. We now seek a more principled approach to solving problems in pattern recognition by turning to a discussion of probability theory. As well as providing the foundation for nearly all of the subsequent developments in this book, it will also

- Figure 1.8 Graph of the root-mean-square error (1.3) versus ln λ for the M = 9 polynomial.


- 0.5
- 1


||Training<br><br>Test|
|---|
|
|---|


ERMS

0

−35 −30 ln λ −25 −20
