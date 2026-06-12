[Page 680]

2 m = 2

2 m = 3

2

m = 1

0

0

0

−2

−2

−2

−1 0 1 2

−1 0 1 2

−1 0 1 2

2 m = 10

2 m = 150

2

m = 6

0

0

0

−2

−2

−2

−1 0 1 2

−1 0 1 2

−1 0 1 2

Figure 14.2 Illustration of boosting in which the base learners consist of simple thresholds applied to one or other of the axes. Each ﬁgure shows the number m of base learners trained so far, along with the decision boundary of the most recent base learner (dashed black line) and the combined decision boundary of the ensemble (solid green line). Each data point is depicted by a circle whose radius indicates the weight assigned to that data point when training the most recently added base learner. Thus, for instance, we see that points that are misclassiﬁed by the m = 1 base learner are given greater weight when training the m = 2 base learner.

Instead of doing a global error function minimization, however, we shall suppose that the base classiﬁers y1(x),...,ym−1(x) are ﬁxed, as are their coefﬁcients α1,...,αm−1, and so we are minimizing only with respect to αm and ym(x). Separating off the contribution from base classiﬁer ym(x), we can then write the error function in the form

exp�−tnfm−1(xn) −

tnαmym(xn)�

�N

1 2

E =

n=1

wn(m) exp�−

tnαmym(xn)� (14.22)

�N

1 2

=

n=1

where the coefﬁcients wn(m) = exp{−tnfm−1(xn)} can be viewed as constants because we are optimizing only αm and ym(x). If we denote by Tm the set of data points that are correctly classiﬁed by ym(x), and if we denote the remaining misclassiﬁed points by Mm, then we can in turn rewrite the error function in the
