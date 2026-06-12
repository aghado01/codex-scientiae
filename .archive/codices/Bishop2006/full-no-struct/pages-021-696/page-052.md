[Page 52]

dard deviation around the mean.

![The image depicts a graph with two main lines. The first line is a red dashed line, and the second line is a green dashed line. Both lines are connected by a dashed line. The red dashed line is positioned at the top of the graph, while the green dashed line is positioned at the bottom. The graph has a white background, and the lines are drawn with a black line. The x-axis is labeled as t, and the y-axis is labeled as t. The graph is titled Theory of Quantum Mechanics. The red dashed line is positioned at the top of the graph, while the green dashed line is positioned at the bottom. The red dashed line is positioned at the top of the graph, while the green dashed line is positioned at the bottom. The graph has a dashed line that is not clearly defined. The dashed line is not a straight line, but rather a curved line that appears to be a wave or a wave](../images/imageFile22.png)

1

t

0

−1

0

1

x

# 1.3. Model Selection

In our example of polynomial curve ﬁtting using least squares, we saw that there was an optimal order of polynomial that gave the best generalization. The order of the polynomial controls the number of free parameters in the model and thereby governs the model complexity. With regularized least squares, the regularization coefﬁcient λ also controls the effective complexity of the model, whereas for more complex models, such as mixture distributions or neural networks there may be multiple parameters governing complexity. In a practical application, we need to determine the values of such parameters, and the principal objective in doing so is usually to achieve the best predictive performance on new data. Furthermore, as well as ﬁnding the appropriate values for complexity parameters within a given model, we may wish to consider a range of different types of model in order to ﬁnd the best one for our particular application.

We have already seen that, in the maximum likelihood approach, the performance on the training set is not a good indicator of predictive performance on unseen data due to the problem of over-ﬁtting. If data is plentiful, then one approach is simply to use some of the available data to train a range of models, or a given model with a range of values for its complexity parameters, and then to compare them on independent data, sometimes called a validation set , and select the one having the best predictive performance. If the model design is iterated many times using a limited size data set, then some over-ﬁtting to the validation data can occur and so it may be necessary to keep aside a third test set on which the performance of the selected model is ﬁnally evaluated.
