[Page 60]

x0 x p(x,C1)

p(x,C2)

x

R1 R2

- Figure 1.24 Schematic illustration of the joint probabilities p(x, Ck) for each of two classes plotted against x, together with the decision boundary x = xb. Values of x x b are classiﬁed as class C2 and hence belong to decision region R2, whereas points x < xb are classiﬁed as C1 and belong to R1. Errors arise from the blue, green, and red regions, so that for x < xb the errors are due to points from class C2 being misclassiﬁed as C1 (represented by the sum of the red and green regions), and conversely for points in the region x x b the


errors are due to points from class C1 being misclassiﬁed as C2 (represented by the blue region). As we vary the location xb of the decision boundary, the combined areas of the blue and green regions remains constant, whereas the size of the red region varies. The optimal choice for xb is where the curves for p(x, C1) and p(x, C2) cross, corresponding to xb = x0, because in this case the red region disappears. This is equivalent to the minimum misclassiﬁcation rate decision rule, which assigns each value of x to the class having the higher posterior probability p(Ck|x).

probability of making a mistake is obtained if each value of x is assigned to the class for which the posterior probability p(Ck|x) is largest. This result is illustrated for two classes, and a single input variable x, in Figure 1.24.

For the more general case of K classes, it is slightly easier to maximize the probability of being correct, which is given by

p(correct) =

=

K

p(x ∈ Rk,Ck)

k=1

K

p(x,Ck)dx (1.79)

k=1 Rk

which is maximized when the regions Rk are chosen such that each x is assigned to the class for which p(x,Ck) is largest. Again, using the product rule p(x,Ck) = p(Ck|x)p(x), and noting that the factor of p(x) is common to all terms, we see that each x should be assigned to the class having the largest posterior probability p(Ck|x).
