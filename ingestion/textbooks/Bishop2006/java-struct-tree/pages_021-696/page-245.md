[Page 245]

5

![image 71](../../../../../images/imageFile71.png)

Neural Networks

In Chapters 3 and 4 we considered models for regression and classiﬁcation that comprised linear combinations of ﬁxed basis functions. We saw that such models have useful analytical and computational properties but that their practical applicability was limited by the curse of dimensionality. In order to apply such models to largescale problems, it is necessary to adapt the basis functions to the data.

Support vector machines (SVMs), discussed in Chapter 7, address this by ﬁrst deﬁning basis functions that are centred on the training data points and then selecting a subset of these during training. One advantage of SVMs is that, although the training involves nonlinear optimization, the objective function is convex, and so the solution of the optimization problem is relatively straightforward. The number of basis functions in the resulting models is generally much smaller than the number of training points, although it is often still relatively large and typically increases with the size of the training set. The relevance vector machine, discussed in Section 7.2, also chooses a subset from a ﬁxed set of basis functions and typically results in much

225
