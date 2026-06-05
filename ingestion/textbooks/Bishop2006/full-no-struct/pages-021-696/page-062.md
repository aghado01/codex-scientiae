[Page 62]

Figure 1.26

Illustration of the reject option. Inputs x such that the larger of the two posterior probabilities is less than or equal to some threshold θ will be rejected.

![The image is a graph that shows the relationship between two variables, represented by the variables p and c. The graph is a line graph, and the x-axis is labeled reject region and the y-axis is labeled p(c1)c2. The graph shows a downward trend in the p(c1) variable as the c variable increases. The graph also shows a downward trend in the c variable as the c variable increases.](../images/imageFile30.png)

|

C

|

C

x

)

p

(

x

)

p

(

1

2

1

.

0

θ

0

.

0

x

reject region

new x to the class j for which the quantity

$$
\sum _ { k } L _ { k j } p ( \mathcal { C } _ { k } | x ) & & ( 1 . 8 1 ) \\ \text {early trivial to do} \ \text {once we know the posterior class} \ \text {proba} &
$$

is a minimum. This is clearly trivial to do, once we know the posterior class probabilities p ( C k | x ) .

# 1.5.3 The reject option

We have seen that classiﬁcation errors arise from the regions of input space where the largest of the posterior probabilities p ( C k | x ) is signiﬁcantly less than unity, or equivalently where the joint distributions p ( x , C k ) have comparable values. These are the regions where we are relatively uncertain about class membership. In some applications, it will be appropriate to avoid making decisions on the difﬁcult cases in anticipation of a lower error rate on those examples for which a classiﬁcation decision is made. This is known as the reject option . For example, in our hypothetical medical illustration, it may be appropriate to use an automatic system to classify those X-ray images for which there is little doubt as to the correct class, while leaving a human expert to classify the more ambiguous cases. We can achieve this by introducing a threshold θ and rejecting those inputs x for which the largest of the posterior probabilities p ( C k | x ) is less than or equal to θ . This is illustrated for the case of two classes, and a single continuous input variable x , in Figure 1.26. Note that setting θ = 1 will ensure that all examples are rejected, whereas if there are K classes then setting θ < 1 /K will ensure that no examples are rejected. Thus the fraction of examples that get rejected is controlled by the value of θ .

We can easily extend the reject criterion to minimize the expected loss, when a loss matrix is given, taking account of the loss incurred when a reject decision is made.

# 1.5.4 Inference and decision

We have broken the classification problem down into two separate stages, the inference stage in which we use training data to learn a model for p ( C k | x ) , and the subsequent decision stage in which we use these posterior probabilities to make optimal class assignments. An alternative possibility would be to solve both problems together and simply learn a function that maps inputs x directly into decisions. Such a function is called a discriminant function .
