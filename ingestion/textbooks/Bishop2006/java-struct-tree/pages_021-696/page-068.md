[Page 68]

(b) First solve the inference problem of determining the conditional density p(t|x),

and then subsequently marginalize to ﬁnd the conditional mean given by (1.89). (c) Find a regression function y(x) directly from the training data.

The relative merits of these three approaches follow the same lines as for classiﬁcation problems above.

The squared loss is not the only possible choice of loss function for regression. Indeed, there are situations in which squared loss can lead to very poor results and where we need to develop more sophisticated approaches. An important example concerns situations in which the conditional distribution p(t|x) is multimodal, as

Section 5.6 often arises in the solution of inverse problems. Here we consider brieﬂy one simple generalization of the squared loss, called the Minkowski loss, whose expectation is given by

E[Lq] = �� |y(x) − t|qp(x,t)dxdt (1.91)

which reduces to the expected squared loss for q = 2. The function |y − t|q is plotted against y − t for various values of q in Figure 1.29. The minimum of E[Lq] is given by the conditional mean for q = 2, the conditional median for q = 1, and

Exercise 1.27 the conditional mode for q → 0.

1.6. Information Theory

In this chapter, we have discussed a variety of concepts from probability theory and decision theory that will form the foundations for much of the subsequent discussion in this book. We close this chapter by introducing some additional concepts from the ﬁeld of information theory, which will also prove useful in our development of pattern recognition and machine learning techniques. Again, we shall focus only on the key concepts, and we refer the reader elsewhere for more detailed discussions (Viterbi and Omura, 1979; Cover and Thomas, 1991; MacKay, 2003) .

We begin by considering a discrete random variable x and we ask how much information is received when we observe a speciﬁc value for this variable. The amount of information can be viewed as the ‘degree of surprise’ on learning the value of x. If we are told that a highly improbable event has just occurred, we will have received more information than if we were told that some very likely event has just occurred, and if we knew that the event was certain to happen we would receive no information. Our measure of information content will therefore depend on the probability distribution p(x), and we therefore look for a quantity h(x) that is a monotonic function of the probability p(x) and that expresses the information content. The form of h(·) can be found by noting that if we have two events x and y that are unrelated, then the information gain from observing both of them should be the sum of the information gained from each of them separately, so that h(x,y) = h(x) + h(y). Two unrelated events will be statistically independent and so p(x,y) = p(x)p(y). From these two relationships, it is easily shown that h(x)

Exercise 1.28 must be given by the logarithm of p(x) and so we have
