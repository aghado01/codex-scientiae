[Page 64]

![The image is a graph with two axes labeled as x and y. The x-axis is labeled as class and the y-axis is labeled as p(x_{1}|x_{2}). The graph is a line graph with two peaks and two troughs. The line is drawn from the point (0, 0) to the point (1, 0). The line starts at the point (0, 0) and goes up to the point (1, 0). It then goes down to the point (0, 0) and then up to the point (1, 0). The line then goes up to the point (1, 0) and then down to the point (0, 0). The line then goes up to the point (1, 0) and then down to the point (0, 0). The line then goes up to the point (1, 0) and then down to](../images/imageFile31.png)

5

1.2

C

|

C

|

p

(

x

)

p

(

x

)

1

2

|C

p

(

x

)

2

1

4

0.8

class densities

3

0.6

2

0.4

|C

p

(

x

)

1

1

0.2

0

0

0

0.2

0.4

0.6

0.8

1

0

0.2

0.4

0.6

0.8

1

x

x

Figure 1.27 Example of the class-conditional densities for two classes having a single input variable x (left plot) together with the corresponding posterior probabilities (right plot). Note that the left-hand mode of the class-conditional density p ( x |C 1 ) , shown in blue on the left plot, has no effect on the posterior probabilities. The vertical green line in the right plot shows the decision boundary in x that gives the minimum misclassiﬁcation rate.

However, if we only wish to make classiﬁcation decisions, then it can be wasteful of computational resources, and excessively demanding of data, to ﬁnd the joint distribution p ( x , C k ) when in fact we only really need the posterior probabilities p ( C k | x ) , which can be obtained directly through approach (b). Indeed, the classconditional densities may contain a lot of structure that has little effect on the posterior probabilities, as illustrated in Figure 1.27. There has been much interest in exploring the relative merits of generative and discriminative approaches to machine learning, and in ﬁnding ways to combine them (Jebara, 2004; Lasserre et al. , 2006).

An even simpler approach is (c) in which we use the training data to ﬁnd a discriminant function f ( x ) that maps each x directly onto a class label, thereby combining the inference and decision stages into a single learning problem. In the example of Figure 1.27, this would correspond to ﬁnding the value of x shown by the vertical green line, because this is the decision boundary giving the minimum probability of misclassiﬁcation.

With option (c), however, we no longer have access to the posterior probabilities p ( C k | x ) . There are many powerful reasons for wanting to compute the posterior probabilities, even if we subsequently use them to make decisions. These include:

Minimizing risk. Consider a problem in which the elements of the loss matrix are subjected to revision from time to time (such as might occur in a ﬁnancial
