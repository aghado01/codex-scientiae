[Page 282]

Figure 5.13 A schematic illustration of why early stopping can give similar results to weight decay in the case of a quadratic error function. The ellipse shows a contour of constant error, and wML denotes the minimum of the error function. If the weight vector starts at the origin and moves according to the local negative gradient direction, then it will follow the path shown by the curve. By stopping training early, a weight vector we is found that is qualitatively similar to that obtained with a simple weight-decay regularizer and training to the minimum of the regularized error, as can be seen by comparing with Figure 3.15.

###### w

|2|w<br><br>wML|
|---|---|
| |w|


1

digit is shifted to a different position in each image.

- 2. A regularization term is added to the error function that penalizes changes in the model output when the input is transformed. This leads to the technique of tangent propagation, discussed in Section 5.5.4.
- 3. Invariance is built into the pre-processing by extracting features that are invariant under the required transformations. Any subsequent regression or classiﬁcation system that uses such features as inputs will necessarily also respect these invariances.
- 4. The ﬁnal option is to build the invariance properties into the structure of a neural network (or into the deﬁnition of a kernel function in the case of techniques such as the relevance vector machine). One way to achieve this is through the use of local receptive ﬁelds and shared weights, as discussed in the context of convolutional neural networks in Section 5.5.6.


Approach 1 is often relatively easy to implement and can be used to encourage complex invariances such as those illustrated in Figure 5.14. For sequential training algorithms, this can be done by transforming each input pattern before it is presented to the model so that, if the patterns are being recycled, a different transformation (drawn from an appropriate distribution) is added each time. For batch methods, a similar effect can be achieved by replicating each data point a number of times and transforming each copy independently. The use of such augmented data can lead to signiﬁcant improvements in generalization (Simard et al., 2003), although it can also be computationally costly.

Approach 2 leaves the data set unchanged but modiﬁes the error function through the addition of a regularizer. In Section 5.5.5, we shall show that this approach is closely related to approach 2.
