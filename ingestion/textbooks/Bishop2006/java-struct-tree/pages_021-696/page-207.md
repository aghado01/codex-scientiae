[Page 207]

6

4

2

0

6

4

2

0

−2

−2

−4

−4

−6

−6 −4 −2 0 2 4 6

−6

−6 −4 −2 0 2 4 6

Figure 4.5 Example of a synthetic data set comprising three classes, with training data points denoted in red (×), green (+), and blue (◦). Lines denote the decision boundaries, and the background colours denote the respective classes of the decision regions. On the left is the result of using a least-squares discriminant. We see that the region of input space assigned to the green class is too small and so most of the points from this class are misclassiﬁed. On the right is the result of using logistic regressions as described in Section 4.3.2 showing correct classiﬁcation of the training data.

dimensional input vector x and project it down to one dimension using

y = wTx. (4.20)

If we place a threshold on y and classify y � −w0 as class C1, and otherwise class C2, then we obtain our standard linear classiﬁer discussed in the previous section. In general, the projection onto one dimension leads to a considerable loss of information, and classes that are well separated in the original D-dimensional space may become strongly overlapping in one dimension. However, by adjusting the components of the weight vector w, we can select a projection that maximizes the class separation. To begin with, consider a two-class problem in which there are N1 points of class C1 and N2 points of class C2, so that the mean vectors of the two classes are given by

N1 �

N2 �

1

1

m1 =

xn, m2 =

xn. (4.21)

n ∈ C1

n ∈ C2

The simplest measure of the separation of the classes, when projected onto w, is the separation of the projected class means. This suggests that we might choose w so as to maximize

m2 − m1 = wT(m2 − m1) (4.22) where

mk = wTmk (4.23)
