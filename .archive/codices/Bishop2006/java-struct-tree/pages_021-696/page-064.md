[Page 64]

5

4

class densities

3

2

1

p(x|C1)

p(x|C2)

1.2

1

0.8

0.6

0.4

0.2

p(C1|x) p(C2|x)

0

0 0.2 0.4 0.6 0.8 1

x

0

0 0.2 0.4 0.6 0.8 1

x

Figure 1.27 Example of the class-conditional densities for two classes having a single input variable x (left plot) together with the corresponding posterior probabilities (right plot). Note that the left-hand mode of the class-conditional density p(x|C1), shown in blue on the left plot, has no effect on the posterior probabilities. The vertical green line in the right plot shows the decision boundary in x that gives the minimum misclassiﬁcation rate.

be of low accuracy, which is known as outlier detection or novelty detection (Bishop, 1994; Tarassenko, 1995).

However, if we only wish to make classiﬁcation decisions, then it can be wasteful of computational resources, and excessively demanding of data, to ﬁnd the joint distribution p(x,Ck) when in fact we only really need the posterior probabilities p(Ck|x), which can be obtained directly through approach (b). Indeed, the classconditional densities may contain a lot of structure that has little effect on the posterior probabilities, as illustrated in Figure 1.27. There has been much interest in exploring the relative merits of generative and discriminative approaches to machine learning, and in ﬁnding ways to combine them (Jebara, 2004; Lasserre et al., 2006).

An even simpler approach is (c) in which we use the training data to ﬁnd a discriminant function f(x) that maps each x directly onto a class label, thereby combining the inference and decision stages into a single learning problem. In the example of Figure 1.27, this would correspond to ﬁnding the value of x shown by the vertical green line, because this is the decision boundary giving the minimum probability of misclassiﬁcation.

With option (c), however, we no longer have access to the posterior probabilities

p(Ck|x). There are many powerful reasons for wanting to compute the posterior probabilities, even if we subsequently use them to make decisions. These include:

Minimizing risk. Consider a problem in which the elements of the loss matrix are subjected to revision from time to time (such as might occur in a ﬁnancial
