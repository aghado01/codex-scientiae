[Page 32]

give us some important insights into the concepts we have introduced in the context of polynomial curve ﬁtting and will allow us to extend these to more complex situations.

## 1.2. Probability Theory

A key concept in the ﬁeld of pattern recognition is that of uncertainty. It arises both through noise on measurements, as well as through the ﬁnite size of data sets. Probability theory provides a consistent framework for the quantiﬁcation and manipulation of uncertainty and forms one of the central foundations for pattern recognition. When combined with decision theory, discussed in Section 1.5, it allows us to make optimal predictions given all the information available to us, even though that information may be incomplete or ambiguous.

We will introduce the basic concepts of probability theory by considering a simple example. Imagine we have two boxes, one red and one blue, and in the red box we have 2 apples and 6 oranges, and in the blue box we have 3 apples and 1 orange. This is illustrated in Figure 1.9. Now suppose we randomly pick one of the boxes and from that box we randomly select an item of fruit, and having observed which sort of fruit it is we replace it in the box from which it came. We could imagine repeating this process many times. Let us suppose that in so doing we pick the red box 40% of the time and we pick the blue box 60% of the time, and that when we remove an item of fruit from a box we are equally likely to select any of the pieces of fruit in the box.

In this example, the identity of the box that will be chosen is a random variable, which we shall denote by $B$. This random variable can take one of two possible values, namely $r$ (corresponding to the red box) or $b$ (corresponding to the blue box). Similarly, the identity of the fruit is also a random variable and will be denoted by $F$. It can take either of the values $a$ (for apple) or $o$ (for orange).

To begin with, we shall deﬁne the probability of an event to be the fraction of times that event occurs out of the total number of trials, in the limit that the total number of trials goes to inﬁnity. Thus the probability of selecting the red box is $4/10$

![The image displays two identical circles, each containing a number of green circles. The circles are arranged vertically, with each circle occupying the same space. The circles are colored in a gradient of green, with the top circle being a darker shade of green and the bottom circle being a lighter shade. The circles are evenly spaced, with no gaps between them. The background of the image is white, which makes the circles stand out clearly. The circles are placed on a flat surface, possibly a table or a surface with a smooth texture. The image does not contain any text, numbers, or other objects that would typically be found in a photograph or illustration. The focus is solely on the two circles, their arrangement, and the gradient of the green circles. ### Analysis and Description: **Objects and Elements:** 1. **Circles:** Two identical circles with a gradient of green. 2. **Background:** White surface with a smooth texture. 3.](../images/imageFile12.png)

Figure 1.9 We use a simple example of two coloured boxes each containing fruit (apples shown in green and oranges shown in orange) to introduce the basic ideas of probability.
