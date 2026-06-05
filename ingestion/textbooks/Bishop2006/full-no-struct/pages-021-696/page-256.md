[Page 256]

![The image depicts a diagram of a cylindrical object with a diameter of 10 cm and a height of 10 cm. The object is labeled as W and has a label E on the top. The object is a cylinder with a circular base and a circular top. The base of the cylinder is a circle with a diameter of 10 cm. The top of the cylinder is a circle with a diameter of 10 cm. The object is labeled as W and has a label E on the top. ### Objects in the Image: 1. **Cylinder**: The object is a cylinder with a circular base and a circular top. 2. **Circular Base**: The base of the cylinder is a circle with a diameter of 10 cm. 3. **Circular Top**: The top of the cylinder is a circle with a diameter of 10 cm. 4. **Label**: The label](../images/imageFile111.png)

A a local minimum and w B is the global minimum. At any point w C , the local gradient of the error surface is given by the vector ∇ E .

Figure 5.5 E ( w )

∇ E

w

1

A

B

w

C

w

w

w

∇

E

2

Exercise 5.7

Following the discussion of Section 4.3.4, we see that the output unit activation function, which corresponds to the canonical link, is given by the softmax function

$$
y _ { k } ( x , w ) = \frac { \exp ( a _ { k } ( x , w ) ) } { \sum _ { j } \exp ( a _ { j } ( x , w ) ) } \\
$$

which satisﬁes 0 y k 1 and k y k = 1 . Note that the y k ( x , w ) are unchanged if a constant is added to all of the a k ( x , w ) , causing the error function to be constant for some directions in weight space. This degeneracy is removed if an appropriate regularization term (Section 5.5) is added to the error function.

Once again, the derivative of the error function with respect to the activation for a particular output unit takes the familiar form (5.18).

In summary, there is a natural choice of both output unit activation function and matching error function, according to the type of problem being solved. For regression we use linear outputs and a sum-of-squares error, for (multiple independent) binary classiﬁcations we use logistic sigmoid outputs and a cross-entropy error function, and for multiclass classiﬁcation we use softmax outputs with the corresponding multiclass cross-entropy error function. For classiﬁcation problems involving two classes, we can use a single logistic sigmoid output, or alternatively we can use a network with two outputs having a softmax output activation function.

# 5.2.1 Parameter optimization

We turn next to the task of ﬁnding a weight vector w which minimizes the chosen function E ( w ) . At this point, it is useful to have a geometrical picture of the error function, which we can view as a surface sitting over weight space as shown in Figure 5.5. First note that if we make a small step in weight space from w to w + δ w then the change in the error function is δE δ w T ∇ E ( w ) , where the vector ∇ E ( w ) points in the direction of greatest rate of increase of the error function. Because the error E ( w ) is a smooth continuous function of w , its smallest value will occur at a
