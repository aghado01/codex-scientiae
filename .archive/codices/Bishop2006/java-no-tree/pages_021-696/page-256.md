[Page 256]

Figure 5.5 Geometrical view of the error function E(w) as a surface sitting over weight space. Point wA is a local minimum and wB is the global minimum. At any point wC, the local gradient of the error surface is given by the vector ∇E.

E(w)

w1

###### wA wB wC

w2

###### ∇E

Following the discussion of Section 4.3.4, we see that the output unit activation function, which corresponds to the canonical link, is given by the softmax function

exp(ak(x,w))

yk(x,w) =

exp(aj(x,w))

j

(5.25)

which satisﬁes 0 yk 1 and k yk = 1. Note that the yk(x,w) are unchanged if a constant is added to all of the ak(x,w), causing the error function to be constant for some directions in weight space. This degeneracy is removed if an appropriate regularization term (Section 5.5) is added to the error function.

Once again, the derivative of the error function with respect to the activation for

- Exercise 5.7 a particular output unit takes the familiar form (5.18). In summary, there is a natural choice of both output unit activation function


and matching error function, according to the type of problem being solved. For regression we use linear outputs and a sum-of-squares error, for (multiple independent) binary classiﬁcations we use logistic sigmoid outputs and a cross-entropy error function, and for multiclass classiﬁcation we use softmax outputs with the corresponding multiclass cross-entropy error function. For classiﬁcation problems involving two classes, we can use a single logistic sigmoid output, or alternatively we can use a network with two outputs having a softmax output activation function.

###### 5.2.1 Parameter optimization

We turn next to the task of ﬁnding a weight vector w which minimizes the chosen function E(w). At this point, it is useful to have a geometrical picture of the error function, which we can view as a surface sitting over weight space as shown in Figure 5.5. First note that if we make a small step in weight space from w to w+δw then the change in the error function is δE δwT∇E(w), where the vector ∇E(w) points in the direction of greatest rate of increase of the error function. Because the error E(w) is a smooth continuous function of w, its smallest value will occur at a
