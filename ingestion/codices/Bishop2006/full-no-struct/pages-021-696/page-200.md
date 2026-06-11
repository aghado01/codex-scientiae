[Page 200]

$$
t = ( 0 , 1 , 0 , 0 , 0 ) ^ { T } .
$$

Again, we can interpret the value of t k as the probability that the class is C k . For nonprobabilistic models, alternative choices of target variable representation will sometimes prove convenient.

In Chapter 1, we identiﬁed three distinct approaches to the classiﬁcation problem. The simplest involves constructing a discriminant function that directly assigns each vector x to a speciﬁc class. A more powerful approach, however, models the conditional probability distribution p ( C k | x ) in an inference stage, and then subsequently uses this distribution to make optimal decisions. By separating inference and decision, we gain numerous beneﬁts, as discussed in Section 1.5.4. There are two different approaches to determining the conditional probabilities p ( C k | x ) . One technique is to model them directly, for example by representing them as parametric models and then optimizing the parameters using a training set. Alternatively, we can adopt a generative approach in which we model the class-conditional densities given by p ( x |C k ) , together with the prior probabilities p ( C k ) for the classes, and then we compute the required posterior probabilities using Bayes’ theorem

$$
p ( \mathcal { C } _ { k } | \mathbf x ) = \frac { p ( \mathbf x | \mathcal { C } _ { k } ) p ( \mathcal { C } _ { k } ) } { p ( \mathbf x ) } .
$$

We shall discuss examples of all three approaches in this chapter.

In the linear regression models considered in Chapter 3, the model prediction y ( x , w ) was given by a linear function of the parameters w . In the simplest case, the model is also linear in the input variables and therefore takes the form y ( x ) = w T x + w 0 , so that y is a real number. For classiﬁcation problems, however, we wish to predict discrete class labels, or more generally posterior probabilities that lie in the range (0 , 1) . To achieve this, we consider a generalization of this model in which we transform the linear function of w using a nonlinear function f ( · ) so that

$$
\text {car function of } w \text { using a nonterminal function } f \text { ( } ^ { \cdot } ) \text { so that } \\ y ( x ) = f \left ( w ^ { \top } x + w _ { 0 } \right ) . \\ \text {inging literature } f ( \cdot ) \text { is known as an activation function, whereas } \\ \text {a link function in the statistics literature. The decision surfaces}
$$

In the machine learning literature f ( · ) is known as an activation function , whereas its inverse is called a link function in the statistics literature. The decision surfaces correspond to y ( x ) = constant , so that w T x + w 0 = constant and hence the decision surfaces are linear functions of x , even if the function f ( · ) is nonlinear. For this reason, the class of models described by (4.3) are called generalized linear models
