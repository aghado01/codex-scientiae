[Page 680]

![The image is a diagram consisting of six different sections, each labeled with a letter and a number. The sections are arranged in a grid-like pattern, with each section containing a different number of dots. The dots are arranged in a way that they form a pattern of dots, with each dot being a different color. The dots are arranged in a way that they are spaced out evenly, with no gaps between them. Here is a detailed description of the image: ### Description of the Image: 1. **Top Section:** - The top section contains a grid with a number of dots. The dots are arranged in a grid-like pattern, with each dot being a different color. The dots are spaced out evenly, with no gaps between them. 2. **Middle Section:** - The middle section contains a grid with a number of dots. The dots are arranged in a grid-like pattern, with each dot being a different color. The dots are spaced](../images/imageFile326.png)

2

2

2

m

= 1

m

= 2

m

= 3

0

0

0

−2

−2

−2

−1

0

1

2

−1

0

1

2

−1

0

1

2

2

2

2

m

= 6

m

= 10

m

= 150

0

0

0

−2

−2

−2

−1

0

1

2

−1

0

1

2

−1

0

1

2

Figure 14.2 Illustration of boosting in which the base learners consist of simple thresholds applied to one or other of the axes. Each ﬁgure shows the number m of base learners trained so far, along with the decision boundary of the most recent base learner (dashed black line) and the combined decision boundary of the ensemble (solid green line). Each data point is depicted by a circle whose radius indicates the weight assigned to that data point when training the most recently added base learner. Thus, for instance, we see that points that are misclassiﬁed by the m = 1 base learner are given greater weight when training the m = 2 base learner.

Instead of doing a global error function minimization, however, we shall suppose that the base classiﬁers y 1 ( x ) ,...,y m − 1 ( x ) are ﬁxed, as are their coefﬁcients α 1 ,...,α m − 1 , and so we are minimizing only with respect to α m and y m ( x ) . Separating off the contribution from base classiﬁer y m ( x ) , we can then write the error function in the form

$$
\text {function in the form} \\ E \ = \ \sum _ { n = 1 } ^ { N } \exp \left \{ - t _ { n } f _ { m - 1 } ( x _ { n } ) - \frac { 1 } { 2 } t _ { n } \alpha _ { m } y _ { m } ( x _ { n } ) \right \} \\ = \ \sum _ { n = 1 } ^ { N } w _ { n } ^ { ( m ) } \exp \left \{ - \frac { 1 } { 2 } t _ { n } \alpha _ { m } y _ { m } ( x _ { n } ) \right \} \\ \text {here the coefficients } w _ { n } ^ { ( m ) } \ = \ \exp \{ - t _ { n } f _ { m - 1 } ( x _ { n } ) \} \, \text { can be viewed as constants}
$$

where the coefﬁcients w ( m ) n = exp {− t n f m − 1 ( x n ) } can be viewed as constants because we are optimizing only α m and y m ( x ) . If we denote by T m the set of data points that are correctly classiﬁed by y m ( x ) , and if we denote the remaining misclassiﬁed points by M m , then we can in turn rewrite the error function in the
