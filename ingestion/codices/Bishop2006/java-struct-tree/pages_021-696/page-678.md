[Page 678]

Figure 14.1 Schematic illustration of the boosting framework. Each base classiﬁer ym(x) is trained on a weighted form of the training set (blue arrows) in which the weights wn(m) depend on the performance of the previous base classiﬁer ym−1(x) (green arrows). Once all base classiﬁers have been trained, they are combined to give the ﬁnal classiﬁer YM(x) (red arrows).

{wn(1)} {wn(2)} {wn(M)}

y1(x) y2(x) yM(x)

YM(x) = sign� M

αmym(x)�

�

m

AdaBoost

1. Initialize the data weighting coefﬁcients {wn} by setting wn(1) = 1/N for

n = 1,...,N.

2. For m = 1,...,M: (a) Fit a classiﬁer ym(x) to the training data by minimizing the weighted error function

�N

Jm =

wn(m)I(ym(xn) �= tn) (14.15)

n=1

where I(ym(xn) �= tn) is the indicator function and equals 1 when ym(xn) �= tn and 0 otherwise.

(b) Evaluate the quantities

�N

wn(m)I(ym(xn) �= tn)

n=1

�m =

(14.16)

�N

wn(m)

n=1

and then use these to evaluate

αm = ln�

�. (14.17)

1 − �m �m

(c) Update the data weighting coefﬁcients

wn(m+1) = wn(m) exp{αmI(ym(xn) �= tn)} (14.18)
