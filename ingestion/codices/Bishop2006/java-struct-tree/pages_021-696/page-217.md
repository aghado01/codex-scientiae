[Page 217]

Figure 4.9 Plot of the logistic sigmoid function σ(a) deﬁned by (4.59), shown in red, together with the scaled probit function Φ(λa), for λ2 = π/8, shown in dashed blue, where Φ(a) is deﬁned by (4.114). The scaling factor π/8 is chosen so that the derivatives of the two curves are equal for a = 0.

1

0.5

0

−5 0 5

approach in which we model the class-conditional densities p(x|Ck), as well as the class priors p(Ck), and then use these to compute posterior probabilities p(Ck|x) through Bayes’ theorem.

Consider ﬁrst of all the case of two classes. The posterior probability for class C1 can be written as

p(x|C1)p(C1) p(x|C1)p(C1) + p(x|C2)p(C2)

p(C1|x) =

1 1 + exp(−a)

=

= σ(a) (4.57)

where we have deﬁned

p(x|C1)p(C1) p(x|C2)p(C2)

a = ln

(4.58) and σ(a) is the logistic sigmoid function deﬁned by

1 1 + exp(−a)

σ(a) =

(4.59)

which is plotted in Figure 4.9. The term ‘sigmoid’ means S-shaped. This type of function is sometimes also called a ‘squashing function’ because it maps the whole real axis into a ﬁnite interval. The logistic sigmoid has been encountered already in earlier chapters and plays an important role in many classiﬁcation algorithms. It satisﬁes the following symmetry property

σ(−a) = 1 − σ(a) (4.60) as is easily veriﬁed. The inverse of the logistic sigmoid is given by

a = ln� σ 1 − σ� (4.61)

and is known as the logit function. It represents the log of the ratio of probabilities ln[p(C1|x)/p(C2|x)] for the two classes, also known as the log odds.
