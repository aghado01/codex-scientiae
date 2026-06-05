[Page 59]

Before giving a more detailed analysis, let us ﬁrst consider informally how we might expect probabilities to play a role in making decisions. When we obtain the X-ray image x for a new patient, our goal is to decide which of the two classes to assign to the image. We are interested in the probabilities of the two classes given the image, which are given by p ( C k | x ) . Using Bayes’ theorem, these probabilities can be expressed in the form

$$
p ( \mathcal { C } _ { k } | \mathbf x ) = \frac { p ( \mathbf x | \mathcal { C } _ { k } ) p ( \mathcal { C } _ { k } ) } { p ( \mathbf x ) } .
$$

Note that any of the quantities appearing in Bayes’ theorem can be obtained from the joint distribution p ( x , C k ) by either marginalizing or conditioning with respect to the appropriate variables. We can now interpret p ( C k ) as the prior probability for the class C k , and p ( C k | x ) as the corresponding posterior probability. Thus p ( C 1 ) represents the probability that a person has cancer, before we take the X-ray measurement. Similarly, p ( C 1 | x ) is the corresponding probability, revised using Bayes’ theorem in light of the information contained in the X-ray. If our aim is to minimize the chance of assigning x to the wrong class, then intuitively we would choose the class having the higher posterior probability. We now show that this intuition is correct, and we also discuss more general criteria for making decisions.

# 1.5.1 Minimizing the misclassiﬁcation rate

Suppose that our goal is simply to make as few misclassiﬁcations as possible. We need a rule that assigns each value of x to one of the available classes. Such a rule will divide the input space into regions R k called decision regions , one for each class, such that all points in R k are assigned to class C k . The boundaries between decision regions are called decision boundaries or decision surfaces . Note that each decision region need not be contiguous but could comprise some number of disjoint regions. We shall encounter examples of decision boundaries and decision regions in later chapters. In order to ﬁnd the optimal decision rule, consider ﬁrst of all the case of two classes, as in the cancer problem for instance. A mistake occurs when an input vector belonging to class C 1 is assigned to class C 2 or vice versa. The probability of this occurring is given by

$$
p ( \text {mistake} ) & \ = \ p ( \mathbf x \in \mathcal { R } _ { 1 } , \mathcal { C } _ { 2 } ) + p ( \mathbf x \in \mathcal { R } _ { 2 } , \mathcal { C } _ { 1 } ) \\ & = \ \int _ { \mathcal { R } _ { 1 } } p ( \mathbf x , \mathcal { C } _ { 2 } ) \, d \mathbf x + \int _ { \mathcal { R } _ { 2 } } p ( \mathbf x , \mathcal { C } _ { 1 } ) \, d \mathbf x . \\ \intertext { o r e f r o t h o s o c h o s t h e d o c i s i m p u l t a s c r p a g n s o c h o n t r o s t h o n o r e f o w t h e t w h e r e }
$$

We are free to choose the decision rule that assigns each point x to one of the two classes. Clearly to minimize p (mistake) we should arrange that each x is assigned to whichever class has the smaller value of the integrand in (1.78). Thus, if p ( x , C 1 ) > p ( x , C 2 ) for a given value of x , then we should assign that x to class C 1 . From the product rule of probability we have p ( x , C k ) = p ( C k | x ) p ( x ) . Because the factor p ( x ) is common to both terms, we can restate this result as saying that the minimum
