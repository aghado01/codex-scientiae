[Page 281]

0.45

| | |
|---|---|


| | |
|---|---|


0.25

0.4

0.2

0.15

0.35

0 10 20 30 40 50

0 10 20 30 40 50

- Figure 5.12 An illustration of the behaviour of training set error (left) and validation set error (right) during a typical training session, as a function of the iteration step, for the sinusoidal data set. The goal of achieving the best generalization performance suggests that training should be stopped at the point shown by the vertical dashed lines, corresponding to the minimum of the validation set error.


parameter λ. The effective number of parameters in the network therefore grows during the course of training.

###### 5.5.3 Invariances

In many applications of pattern recognition, it is known that predictions should be unchanged, or invariant, under one or more transformations of the input variables. For example, in the classiﬁcation of objects in two-dimensional images, such as handwritten digits, a particular object should be assigned the same classiﬁcation irrespective of its position within the image (translation invariance) or of its size (scale invariance). Such transformations produce signiﬁcant changes in the raw data, expressed in terms of the intensities at each of the pixels in the image, and yet should give rise to the same output from the classiﬁcation system. Similarly in speech recognition, small levels of nonlinear warping along the time axis, which preserve temporal ordering, should not change the interpretation of the signal.

If sufﬁciently large numbers of training patterns are available, then an adaptive model such as a neural network can learn the invariance, at least approximately. This involves including within the training set a sufﬁciently large number of examples of the effects of the various transformations. Thus, for translation invariance in an image, the training set should include examples of objects at many different positions.

This approach may be impractical, however, if the number of training examples is limited, or if there are several invariants (because the number of combinations of transformations grows exponentially with the number of such transformations). We therefore seek alternative approaches for encouraging an adaptive model to exhibit the required invariances. These can broadly be divided into four categories:

1. The training set is augmented using replicas of the training patterns, transformed according to the desired invariances. For instance, in our digit recognition example, we could make multiple copies of each example in which the
