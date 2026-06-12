## 8. Graphical Models

### 8.1 Bayesian Networks

In order to motivate the use of directed graphs to describe probability distributions, consider ﬁrst an arbitrary joint distribution p(a,b,c) over three variables a, b, and c. Note that at this stage, we do not need to specify anything further about these variables, such as whether they are discrete or continuous. Indeed, one of the powerful aspects of graphical models is that a speciﬁc graph can make probabilistic statements for a broad class of distributions. By application of the product rule of probability (1.11), we can write the joint distribution in the form

p(a,b,c) = p(c|a,b)p(a,b). (8.1)

A second application of the product rule, this time to the second term on the righthand side of (8.1), gives

p(a,b,c) = p(c|a,b)p(b|a)p(a). (8.2)

Note that this decomposition holds for any choice of the joint distribution. We now represent the right-hand side of (8.2) in terms of a simple graphical model as follows. First we introduce a node for each of the random variables a, b, and c and associate each node with the corresponding conditional distribution on the right-hand side of

8.1 Bayesian Networks 361

Figure 8.1 A directed graphical model representing the joint probability distribution over three variables a, b, and c, corresponding to the decomposition on the right-hand side of (8.2).

a

b

c

(8.2). Then, for each conditional distribution we add directed links (arrows) to the graph from the nodes corresponding to the variables on which the distribution is conditioned. Thus for the factor p(c|a,b), there will be links from nodes a and b to node c, whereas for the factor p(a) there will be no incoming links. The result is the graph shown in Figure 8.1. If there is a link going from a node a to a node b, then we say that node a is the parent of node b, and we say that node b is the child of node a. Note that we shall not make any formal distinction between a node and the variable to which it corresponds but will simply use the same symbol to refer to both.

An interesting point to note about (8.2) is that the left-hand side is symmetrical with respect to the three variables a, b, and c, whereas the right-hand side is not. Indeed, in making the decomposition in (8.2), we have implicitly chosen a particular ordering, namely a,b,c, and had we chosen a different ordering we would have obtained a different decomposition and hence a different graphical representation. We shall return to this point later.

For the moment let us extend the example of Figure 8.1 by considering the joint

distribution over K variables given by p(x1,...,xK). By repeated application of the product rule of probability, this joint distribution can be written as a product of conditional distributions, one for each of the variables

p(x1,...,xK) = p(xK|x1,...,xK−1)...p(x2|x1)p(x1). (8.3)

For a given choice of K, we can again represent this as a directed graph having K nodes, one for each conditional distribution on the right-hand side of (8.3), with each node having incoming links from all lower numbered nodes. We say that this graph is fully connected because there is a link between every pair of nodes.

So far, we have worked with completely general joint distributions, so that the decompositions, and their representations as fully connected graphs, will be applicable to any choice of distribution. As we shall see shortly, it is the absence of links in the graph that conveys interesting information about the properties of the class of distributions that the graph represents. Consider the graph shown in Figure 8.2. This is not a fully connected graph because, for instance, there is no link from x1 to x2 or from x3 to x7.

We shall now go from this graph to the corresponding representation of the joint probability distribution written in terms of the product of a set of conditional distributions, one for each node in the graph. Each such conditional distribution will be conditioned only on the parents of the corresponding node in the graph. For instance, x5 will be conditioned on x1 and x3. The joint distribution of all 7 variables

Figure 8.8 A graphical model representing the process by which images of objects are created, in which the identity of an object (a discrete variable) and the position and orientation of that object (continuous variables) have independent prior probabilities. The image (a vector of pixel intensities) has a probability distribution that is dependent on the identity of the object as well as on its position and orientation.

Object Position Orientation

Image

For practical applications of probabilistic models, it will typically be the highernumbered variables corresponding to terminal nodes of the graph that represent the observations, with lower-numbered nodes corresponding to latent variables. The primary role of the latent variables is to allow a complicated distribution over the observed variables to be represented in terms of a model constructed from simpler (typically exponential family) conditional distributions.

We can interpret such models as expressing the processes by which the observed data arose. For instance, consider an object recognition task in which each observed data point corresponds to an image (comprising a vector of pixel intensities) of one of the objects. In this case, the latent variables might have an interpretation as the position and orientation of the object. Given a particular observed image, our goal is to ﬁnd the posterior distribution over objects, in which we integrate over all possible positions and orientations. We can represent this problem using a graphical model of the form show in Figure 8.8.

The graphical model captures the causal process (Pearl, 1988) by which the observed data was generated. For this reason, such models are often called generative models. By contrast, the polynomial regression model described by Figure 8.5 is not generative because there is no probability distribution associated with the input variable x, and so it is not possible to generate synthetic data points from this model. We could make it generative by introducing a suitable prior distribution p(x), at the expense of a more complex model.

The hidden variables in a probabilistic model need not, however, have any explicit physical interpretation but may be introduced simply to allow a more complex joint distribution to be constructed from simpler components. In either case, the technique of ancestral sampling applied to a generative model mimics the creation of the observed data and would therefore give rise to ‘fantasy’ data whose probability distribution (if the model were a perfect representation of reality) would be the same as that of the observed data. In practice, producing synthetic observations from a generative model can prove informative in understanding the form of the probability distribution represented by that model.

#### 8.1.3 Discrete variables

We have discussed the importance of probability distributions that are members

Section 2.4 of the exponential family, and we have seen that this family includes many wellknown distributions as particular cases. Although such distributions are relatively simple, they form useful building blocks for constructing more complex probability

8.1 Bayesian Networks 367

Figure 8.9 (a) This fully-connected graph describes a general distribution over two K-state discrete variables having a total of K2 − 1 parameters. (b) By dropping the link between the nodes, the number of parameters is reduced to 2(K − 1).

(a)

(b)

x1 x2

x1 x2

distributions, and the framework of graphical models is very useful in expressing the way in which these building blocks are linked together.

Such models have particularly nice properties if we choose the relationship between each parent-child pair in a directed graph to be conjugate, and we shall explore several examples of this shortly. Two cases are particularly worthy of note, namely when the parent and child node each correspond to discrete variables and when they each correspond to Gaussian variables, because in these two cases the relationship can be extended hierarchically to construct arbitrarily complex directed acyclic graphs. We begin by examining the discrete case.

The probability distribution p(x|µ) for a single discrete variable x having K possible states (using the 1-of-K representation) is given by

K

p(x|µ) =

k=1

µx

k (8.9)

k

and is governed by the parameters µ = (µ1,...,µK)T. Due to the constraint

k µk = 1, only K − 1 values for µk need to be speciﬁed in order to deﬁne the distribution.

Now suppose that we have two discrete variables, x1 and x2, each of which has K states, and we wish to model their joint distribution. We denote the probability of observing both x1k = 1 and x2l = 1 by the parameter µkl, where x1k denotes the kth component of x1, and similarly for x2l. The joint distribution can be written

K

p(x1,x2|µ) =

k=1

l=1

µx

1kx2l kl .

Because the parameters µkl are subject to the constraint k l µkl = 1, this distribution is governed by K2 − 1 parameters. It is easily seen that the total number of

parameters that must be speciﬁed for an arbitrary joint distribution over M variables is KM − 1 and therefore grows exponentially with the number M of variables.

Using the product rule, we can factor the joint distribution p(x1,x2) in the form p(x2|x1)p(x1), which corresponds to a two-node graph with a link going from the x1 node to the x2 node as shown in Figure 8.9(a). The marginal distribution p(x1) is governed by K − 1 parameters, as before, Similarly, the conditional distribution p(x2|x1) requires the speciﬁcation of K − 1 parameters for each of the K possible values of x1. The total number of parameters that must be speciﬁed in the joint distribution is therefore (K − 1) + K(K − 1) = K2 − 1 as before.

Now suppose that the variables x1 and x2 were independent, corresponding to the graphical model shown in Figure 8.9(b). Each variable is then described by

#### 8.1.4 Linear-Gaussian models

In the previous section, we saw how to construct joint probability distributions over a set of discrete variables by expressing the variables as nodes in a directed acyclic graph. Here we show how a multivariate Gaussian can be expressed as a directed graph corresponding to a linear-Gaussian model over the component variables. This allows us to impose interesting structure on the distribution, with the general Gaussian and the diagonal covariance Gaussian representing opposite extremes. Several widely used techniques are examples of linear-Gaussian models, such as probabilistic principal component analysis, factor analysis, and linear dynamical systems (Roweis and Ghahramani, 1999). We shall make extensive use of the results of this section in later chapters when we consider some of these techniques in detail.

Consider an arbitrary directed acyclic graph over D variables in which node i

represents a single continuous random variable xi having a Gaussian distribution. The mean of this distribution is taken to be a linear combination of the states of its

parent nodes pai of node i

⎛ ⎝xi

⎞ ⎠ (8.11)

p(xi|pai) = N

wijxj + bi,vi

j∈pai

where wij and bi are parameters governing the mean, and vi is the variance of the conditional distribution for xi. The log of the joint distribution is then the log of the product of these conditionals over all nodes in the graph and hence takes the form

D

lnp(x) =

lnp(xi|pai) (8.12)

i=1

⎛ ⎝xi −

⎞ ⎠

2

D

1 2vi

= −

- const (8.13)

wijxj − bi

j∈pai

i=1

where x = (x1,...,xD)T and ‘const’ denotes terms independent of x. We see that this is a quadratic function of the components of x, and hence the joint distribution p(x) is a multivariate Gaussian.

We can determine the mean and covariance of the joint distribution recursively

as follows. Each variable xi has (conditional on the states of its parents) a Gaussian distribution of the form (8.11) and so

wijxj + bi + √vi i (8.14)

xi =

j∈pai

where i is a zero mean, unit variance Gaussian random variable satisfying E[ i] = 0 and E[ i j] = Iij, where Iij is the i,j element of the identity matrix. Taking the expectation of (8.14), we have

E[xi] =

wijE[xj] + bi. (8.15)

j∈pai

8.1 Bayesian Networks 371

Figure 8.14 A directed graph over three Gaussian variables,

with one missing link.

x1 x2 x3

Thus we can ﬁnd the components of E[x] = (E[x1],...,E[xD])T by starting at the lowest numbered node and working recursively through the graph (here we again assume that the nodes are numbered such that each node has a higher number than its parents). Similarly, we can use (8.14) and (8.15) to obtain the i,j element of the covariance matrix for p(x) in the form of a recursion relation

cov[xi,xj] = E[(xi − E[xi])(xj − E[xj])]

⎧ ⎨

⎫ ⎬

⎡ ⎣(xi − E[xi])

⎤ ⎦

wjk(xk − E[xk]) + √vj j

= E

⎩

⎭

k∈paj

=

wjkcov[xi,xk] + Iijvj (8.16)

k∈paj

and so the covariance can similarly be evaluated recursively starting from the lowest numbered node.

Let us consider two extreme cases. First of all, suppose that there are no links in the graph, which therefore comprises D isolated nodes. In this case, there are no parameters wij and so there are just D parameters bi and D parameters vi. From the recursion relations (8.15) and (8.16), we see that the mean of p(x) is given by (b1,...,bD)T and the covariance matrix is diagonal of the form diag(v1,...,vD). The joint distribution has a total of 2D parameters and represents a set of D independent univariate Gaussian distributions.

Now consider a fully connected graph in which each node has all lower num-

bered nodes as parents. The matrix wij then has i − 1 entries on the ith row and hence is a lower triangular matrix (with no entries on the leading diagonal). Then

the total number of parameters wij is obtained by taking the number D2 of elements in a D×D matrix, subtracting D to account for the absence of elements on the leading diagonal, and then dividing by 2 because the matrix has elements only below the diagonal, giving a total of D(D−1)/2. The total number of independent parameters {wij} and {vi} in the covariance matrix is therefore D(D + 1)/2 corresponding to

Section 2.3 a general symmetric covariance matrix.

Graphs having some intermediate level of complexity correspond to joint Gaussian distributions with partially constrained covariance matrices. Consider for example the graph shown in Figure 8.14, which has a link missing between variables x1 and x3. Using the recursion relations (8.15) and (8.16), we see that the mean and

Exercise 8.7 covariance of the joint distribution are given by µ = (b1,b2 + w21b1,b3 + w32b2 + w32w21b1)T (8.17) Σ =

v1 w21v1 w32w21v1

w21v1 v2 + w212 v1 w32(v2 + w212 v1) w32w21v1 w32(v2 + w212 v1) v3 + w322 (v2 + w212 v1)

. (8.18)

We can readily extend the linear-Gaussian graphical model to the case in which the nodes of the graph represent multivariate Gaussian variables. In this case, we can write the conditional distribution for node i in the form

⎛ ⎝xi

⎞ ⎠ (8.19)

p(xi|pai) = N

Wijxj + bi,Σi

j∈pai

where now Wij is a matrix (which is nonsquare if xi and xj have different dimensionalities). Again it is easy to verify that the joint distribution over all variables is Gaussian.

Note that we have already encountered a speciﬁc example of the linear-Gaussian

Section 2.3.6 relationship when we saw that the conjugate prior for the mean µ of a Gaussian variable x is itself a Gaussian distribution over µ. The joint distribution over x and µ is therefore Gaussian. This corresponds to a simple two-node graph in which the node representing µ is the parent of the node representing x. The mean of the distribution over µ is a parameter controlling a prior, and so it can be viewed as a hyperparameter. Because the value of this hyperparameter may itself be unknown, we can again treat it from a Bayesian perspective by introducing a prior over the hyperparameter, sometimes called a hyperprior, which is again given by a Gaussian distribution. This type of construction can be extended in principle to any level and is an illustration of a hierarchical Bayesian model, of which we shall encounter further examples in later chapters.

### 8.2 Conditional Independence

An important concept for probability distributions over multiple variables is that of conditional independence (Dawid, 1980). Consider three variables a, b, and c, and suppose that the conditional distribution of a, given b and c, is such that it does not depend on the value of b, so that

p(a|b,c) = p(a|c). (8.20)

We say that a is conditionally independent of b given c. This can be expressed in a slightly different way if we consider the joint distribution of a and b conditioned on c, which we can write in the form

p(a,b|c) = p(a|b,c)p(b|c)

= p(a|c)p(b|c). (8.21)

where we have used the product rule of probability together with (8.20). Thus we see that, conditioned on c, the joint distribution of a and b factorizes into the product of the marginal distribution of a and the marginal distribution of b (again both conditioned on c). This says that the variables a and b are statistically independent, given c. Note that our deﬁnition of conditional independence will require that (8.20),

8.2 Conditional Independence 373

Figure 8.15 The ﬁrst of three examples of graphs over three variables a, b, and c used to discuss conditional independence properties of directed graphical models.

c

a b

or equivalently (8.21), must hold for every possible value of c, and not just for some values. We shall sometimes use a shorthand notation for conditional independence (Dawid, 1979) in which

a ⊥ b | c (8.22) denotes that a is conditionally independent of b given c and is equivalent to (8.20).

Conditional independence properties play an important role in using probabilistic models for pattern recognition by simplifying both the structure of a model and the computations needed to perform inference and learning under that model. We shall see examples of this shortly.

If we are given an expression for the joint distribution over a set of variables in terms of a product of conditional distributions (i.e., the mathematical representation underlying a directed graph), then we could in principle test whether any potential conditional independence property holds by repeated application of the sum and product rules of probability. In practice, such an approach would be very time consuming. An important and elegant feature of graphical models is that conditional independence properties of the joint distribution can be read directly from the graph without having to perform any analytical manipulations. The general framework for achieving this is called d-separation, where the ‘d’ stands for ‘directed’ (Pearl, 1988). Here we shall motivate the concept of d-separation and give a general statement of the d-separation criterion. A formal proof can be found in Lauritzen (1996).

#### 8.2.1 Three example graphs

We begin our discussion of the conditional independence properties of directed graphs by considering three simple examples each involving graphs having just three nodes. Together, these will motivate and illustrate the key concepts of d-separation. The ﬁrst of the three examples is shown in Figure 8.15, and the joint distribution corresponding to this graph is easily written down using the general result (8.5) to give

p(a,b,c) = p(a|c)p(b|c)p(c). (8.23)

If none of the variables are observed, then we can investigate whether a and b are independent by marginalizing both sides of (8.23) with respect to c to give

p(a,b) =

c

p(a|c)p(b|c)p(c). (8.24)

In general, this does not factorize into the product p(a)p(b), and so

a ⊥ b | ∅ (8.25)

Figure 8.20 As in Figure 8.19 but conditioning on the value of node c. In this graph, the act of conditioning induces a dependence between a and b.

a b

c

and so a and b are independent with no variables observed, in contrast to the two previous examples. We can write this result as

a ⊥ b | ∅. (8.29)

Now suppose we condition on c, as indicated in Figure 8.20. The conditional distribution of a and b is then given by

p(a,b|c) =

=

p(a,b,c) p(c)

p(a)p(b)p(c|a,b) p(c)

which in general does not factorize into the product p(a)p(b), and so

a ⊥ b | c.

Thus our third example has the opposite behaviour from the ﬁrst two. Graphically, we say that node c is head-to-head with respect to the path from a to b because it connects to the heads of the two arrows. When node c is unobserved, it ‘blocks’ the path, and the variables a and b are independent. However, conditioning on c ‘unblocks’ the path and renders a and b dependent.

There is one more subtlety associated with this third example that we need to consider. First we introduce some more terminology. We say that node y is a descendant of node x if there is a path from x to y in which each step of the path follows the directions of the arrows. Then it can be shown that a head-to-head path

Exercise 8.10 will become unblocked if either the node, or any of its descendants, is observed.

In summary, a tail-to-tail node or a head-to-tail node leaves a path unblocked unless it is observed in which case it blocks the path. By contrast, a head-to-head node blocks a path if it is unobserved, but once the node, and/or at least one of its descendants, is observed the path becomes unblocked.

It is worth spending a moment to understand further the unusual behaviour of the graph of Figure 8.20. Consider a particular instance of such a graph corresponding to a problem with three binary random variables relating to the fuel system on a car, as shown in Figure 8.21. The variables are called B, representing the state of a battery that is either charged (B = 1) or ﬂat (B = 0), F representing the state of the fuel tank that is either full of fuel (F = 1) or empty (F = 0), and G, which is the state of an electric fuel gauge and which indicates either full (G = 1) or empty

8.2 Conditional Independence 377

B F

G

B F

G

B F

G

Figure 8.21 An example of a 3-node graph used to illustrate the phenomenon of ‘explaining away’. The three nodes represent the state of the battery (B), the state of the fuel tank (F) and the reading on the electric fuel gauge (G). See the text for details.

(G = 0). The battery is either charged or ﬂat, and independently the fuel tank is either full or empty, with prior probabilities

p(B = 1) = 0.9 p(F = 1) = 0.9.

Given the state of the fuel tank and the battery, the fuel gauge reads full with probabilities given by

p(G = 1|B = 1,F = 1) = 0.8 p(G = 1|B = 1,F = 0) = 0.2 p(G = 1|B = 0,F = 1) = 0.2 p(G = 1|B = 0,F = 0) = 0.1

so this is a rather unreliable fuel gauge! All remaining probabilities are determined by the requirement that probabilities sum to one, and so we have a complete speciﬁcation of the probabilistic model.

Before we observe any data, the prior probability of the fuel tank being empty is p(F = 0) = 0.1. Now suppose that we observe the fuel gauge and discover that it reads empty, i.e., G = 0, corresponding to the middle graph in Figure 8.21. We can use Bayes’ theorem to evaluate the posterior probability of the fuel tank being empty. First we evaluate the denominator for Bayes’ theorem given by

p(G = 0|B,F)p(B)p(F) = 0.315 (8.30)

p(G = 0) =

B∈{0,1} F∈{0,1}

and similarly we evaluate

p(G = 0|F = 0) =

B∈{0,1}

and using these results we have

p(G = 0|B,F = 0)p(B) = 0.81 (8.31)

p(G = 0|F = 0)p(F = 0) p(G = 0)

p(F = 0|G = 0) =

0.257 (8.32)

and so p(F = 0|G = 0) > p(F = 0). Thus observing that the gauge reads empty makes it more likely that the tank is indeed empty, as we would intuitively expect. Next suppose that we also check the state of the battery and ﬁnd that it is ﬂat, i.e., B = 0. We have now observed the states of both the fuel gauge and the battery, as shown by the right-hand graph in Figure 8.21. The posterior probability that the fuel tank is empty given the observations of both the fuel gauge and the battery state is then given by

p(G = 0|B = 0,F = 0)p(F = 0) F∈{0,1} p(G = 0|B = 0,F)p(F)

p(F = 0|G = 0,B = 0) =

0.111 (8.33)

where the prior probability p(B = 0) has cancelled between numerator and denominator. Thus the probability that the tank is empty has decreased (from 0.257 to 0.111) as a result of the observation of the state of the battery. This accords with our intuition that ﬁnding out that the battery is ﬂat explains away the observation that the fuel gauge reads empty. We see that the state of the fuel tank and that of the battery have indeed become dependent on each other as a result of observing the reading on the fuel gauge. In fact, this would also be the case if, instead of observing the fuel gauge directly, we observed the state of some descendant of G. Note that the probability p(F = 0|G = 0,B = 0) 0.111 is greater than the prior probability p(F = 0) = 0.1 because the observation that the fuel gauge reads zero still provides some evidence in favour of an empty fuel tank.

#### 8.2.2 D-separation

We now give a general statement of the d-separation property (Pearl, 1988) for directed graphs. Consider a general directed graph in which A, B, and C are arbitrary nonintersecting sets of nodes (whose union may be smaller than the complete set of nodes in the graph). We wish to ascertain whether a particular conditional independence statement A ⊥ B | C is implied by a given directed acyclic graph. To do so, we consider all possible paths from any node in A to any node in B. Any such path is said to be blocked if it includes a node such that either

(a) the arrows on the path meet either head-to-tail or tail-to-tail at the node, and the

node is in the set C, or

(b) the arrows meet head-to-head at the node, and neither the node, nor any of its

descendants, is in the set C.

If all paths are blocked, then A is said to be d-separated from B by C, and the joint distribution over all of the variables in the graph will satisfy A ⊥ B | C.

The concept of d-separation is illustrated in Figure 8.22. In graph (a), the path from a to b is not blocked by node f because it is a tail-to-tail node for this path and is not observed, nor is it blocked by node e because, although the latter is a head-to-head node, it has a descendant c because is in the conditioning set. Thus the conditional independence statement a ⊥ b | c does not follow from this graph. In graph (b), the path from a to b is blocked by node f because this is a tail-to-tail node that is observed, and so the conditional independence property a ⊥ b | f will

Figure 8.24 A graphical representation of the ‘naive Bayes’ model for classiﬁcation. Conditioned on the class label z, the components of the observed vector x = (x1, . . . , xD)T are assumed to be independent.

z

x1 xD

However, if we integrate over µ, the observations are in general no longer independent

N

∞

p(D|µ)p(µ)dµ =

p(xn). (8.35)

p(D) =

0

n=1

Here µ is a latent variable, because its value is not observed.

Another example of a model representing i.i.d. data is the graph in Figure 8.7 corresponding to Bayesian polynomial regression. Here the stochastic nodes correspond to {tn}, w and t. We see that the node for w is tail-to-tail with respect to the path from t to any one of the nodes tn and so we have the following conditional independence property

t ⊥ tn | w. (8.36) Thus, conditioned on the polynomial coefﬁcients w, the predictive distribution for t is independent of the training data {t1,...,tN}. We can therefore ﬁrst use the training data to determine the posterior distribution over the coefﬁcients w and then we can discard the training data and use the posterior distribution for w to make

Section 3.3 predictions of t for new input observations x.

A related graphical structure arises in an approach to classiﬁcation called the naive Bayes model, in which we use conditional independence assumptions to simplify the model structure. Suppose our observed variable consists of a D-dimensional vector x = (x1,...,xD)T, and we wish to assign observed values of x to one of K classes. Using the 1-of-K encoding scheme, we can represent these classes by a Kdimensional binary vector z. We can then deﬁne a generative model by introducing a multinomial prior p(z|µ) over the class labels, where the kth component µk of µ is the prior probability of class Ck, together with a conditional distribution p(x|z) for the observed vector x. The key assumption of the naive Bayes model is that, conditioned on the class z, the distributions of the input variables x1,...,xD are independent. The graphical representation of this model is shown in Figure 8.24. We see that observation of z blocks the path between xi and xj for j = i (because such paths are tail-to-tail at the node z) and so xi and xj are conditionally independent given z. If, however, we marginalize out z (so that z is unobserved) the tail-to-tail path from xi to xj is no longer blocked. This tells us that in general the marginal density p(x) will not factorize with respect to the components of x. We encountered a simple application of the naive Bayes model in the context of fusing data from different sources for medical diagnosis in Section 1.5.

If we are given a labelled training set, comprising inputs {x1,...,xN} together with their class labels, then we can ﬁt the naive Bayes model to the training data

8.2 Conditional Independence 381

using maximum likelihood assuming that the data are drawn independently from the model. The solution is obtained by ﬁtting the model for each class separately using the correspondingly labelled data. As an example, suppose that the probability density within each class is chosen to be Gaussian. In this case, the naive Bayes assumption then implies that the covariance matrix for each Gaussian is diagonal, and the contours of constant density within each class will be axis-aligned ellipsoids. The marginal density, however, is given by a superposition of diagonal Gaussians (with weighting coefﬁcients given by the class priors) and so will no longer factorize with respect to its components.

The naive Bayes assumption is helpful when the dimensionality D of the input space is high, making density estimation in the full D-dimensional space more challenging. It is also useful if the input vector contains both discrete and continuous variables, since each can be represented separately using appropriate models (e.g., Bernoulli distributions for binary observations or Gaussians for real-valued variables). The conditional independence assumption of this model is clearly a strong one that may lead to rather poor representations of the class-conditional densities. Nevertheless, even if this assumption is not precisely satisﬁed, the model may still give good classiﬁcation performance in practice because the decision boundaries can be insensitive to some of the details in the class-conditional densities, as illustrated in Figure 1.27.

We have seen that a particular directed graph represents a speciﬁc decomposition of a joint probability distribution into a product of conditional probabilities. The graph also expresses a set of conditional independence statements obtained through the d-separation criterion, and the d-separation theorem is really an expression of the equivalence of these two properties. In order to make this clear, it is helpful to think of a directed graph as a ﬁlter. Suppose we consider a particular joint probability distribution p(x) over the variables x corresponding to the (nonobserved) nodes of the graph. The ﬁlter will allow this distribution to pass through if, and only if, it can be expressed in terms of the factorization (8.5) implied by the graph. If we present to the ﬁlter the set of all possible distributions p(x) over the set of variables x, then the subset of distributions that are passed by the ﬁlter will be denoted DF, for directed factorization. This is illustrated in Figure 8.25. Alternatively, we can use the graph as a different kind of ﬁlter by ﬁrst listing all of the conditional independence properties obtained by applying the d-separation criterion to the graph, and then allowing a distribution to pass only if it satisﬁes all of these properties. If we present all possible distributions p(x) to this second kind of ﬁlter, then the d-separation theorem tells us that the set of distributions that will be allowed through is precisely the set DF.

It should be emphasized that the conditional independence properties obtained from d-separation apply to any probabilistic model described by that particular directed graph. This will be true, for instance, whether the variables are discrete or continuous or a combination of these. Again, we see that a particular graph is describing a whole family of probability distributions.

At one extreme we have a fully connected graph that exhibits no conditional independence properties at all, and which can represent any possible joint probability distribution over the given variables. The set DF will contain all possible distribu-

8.3 Markov Random Fields 383

Figure 8.26 The Markov blanket of a node xi comprises the set of parents, children and co-parents of the node. It has the property that the conditional distribution of xi, conditioned on all the remaining variables in the graph, is dependent only on the variables in the Markov blanket. xi

of xi as well as on the co-parents, in other words variables corresponding to parents of node xk other than node xi. The set of nodes comprising the parents, the children and the co-parents is called the Markov blanket and is illustrated in Figure 8.26. We can think of the Markov blanket of a node xi as being the minimal set of nodes that isolates xi from the rest of the graph. Note that it is not sufﬁcient to include only the parents and children of node xi because the phenomenon of explaining away means that observations of the child nodes will not block paths to the co-parents. We must therefore observe the co-parent nodes also.

### 8.3. Markov Random Fields

We have seen that directed graphical models specify a factorization of the joint distribution over a set of variables into a product of local conditional distributions. They also deﬁne a set of conditional independence properties that must be satisﬁed by any distribution that factorizes according to the graph. We turn now to the second major class of graphical models that are described by undirected graphs and that again specify both a factorization and a set of conditional independence relations.

A Markov random ﬁeld, also known as a Markov network or an undirected graphical model (Kindermann and Snell, 1980), has a set of nodes each of which corresponds to a variable or group of variables, as well as a set of links each of which connects a pair of nodes. The links are undirected, that is they do not carry arrows. In the case of undirected graphs, it is convenient to begin with a discussion of conditional independence properties.

#### 8.3.1 Conditional independence properties

Section 8.2 In the case of directed graphs, we saw that it was possible to test whether a particular conditional independence property holds by applying a graphical test called d-separation. This involved testing whether or not the paths connecting two sets of nodes were ‘blocked’. The deﬁnition of blocked, however, was somewhat subtle due to the presence of paths having head-to-head nodes. We might ask whether it is possible to deﬁne an alternative graphical semantics for probability distributions such that conditional independence is determined by simple graph separation. This is indeed the case and corresponds to undirected graphical models. By removing the

the joint distribution is written as a product of potential functions ψC(xC) over the maximal cliques of the graph

1 Z

p(x) =

ψC(xC). (8.39)

C

Here the quantity Z, sometimes called the partition function, is a normalization constant and is given by

ψC(xC) (8.40)

Z =

x C

which ensures that the distribution p(x) given by (8.39) is correctly normalized. By considering only potential functions which satisfy ψC(xC) 0 we ensure that p(x) 0. In (8.40) we have assumed that x comprises discrete variables, but the framework is equally applicable to continuous variables, or a combination of the two, in which the summation is replaced by the appropriate combination of summation and integration.

Note that we do not restrict the choice of potential functions to those that have a speciﬁc probabilistic interpretation as marginal or conditional distributions. This is in contrast to directed graphs in which each factor represents the conditional distribution of the corresponding variable, conditioned on the state of its parents. However, in special cases, for instance where the undirected graph is constructed by starting with a directed graph, the potential functions may indeed have such an interpretation, as we shall see shortly.

One consequence of the generality of the potential functions ψC(xC) is that their product will in general not be correctly normalized. We therefore have to introduce an explicit normalization factor given by (8.40). Recall that for directed graphs, the joint distribution was automatically normalized as a consequence of the normalization of each of the conditional distributions in the factorization.

The presence of this normalization constant is one of the major limitations of undirected graphs. If we have a model with M discrete nodes each having K states, then the evaluation of the normalization term involves summing over KM states and so (in the worst case) is exponential in the size of the model. The partition function is needed for parameter learning because it will be a function of any parameters that govern the potential functions ψC(xC). However, for evaluation of local conditional distributions, the partition function is not needed because a conditional is the ratio of two marginals, and the partition function cancels between numerator and denominator when evaluating this ratio. Similarly, for evaluating local marginal probabilities we can work with the unnormalized joint distribution and then normalize the marginals explicitly at the end. Provided the marginals only involves a small number of variables, the evaluation of their normalization coefﬁcient will be feasible.

So far, we have discussed the notion of conditional independence based on simple graph separation and we have proposed a factorization of the joint distribution that is intended to correspond to this conditional independence structure. However, we have not made any formal connection between conditional independence and factorization for undirected graphs. To do so we need to restrict attention to potential functions ψC(xC) that are strictly positive (i.e., never zero or negative for any

8.3 Markov Random Fields 387

choice of xC). Given this restriction, we can make a precise relationship between factorization and conditional independence.

To do this we again return to the concept of a graphical model as a ﬁlter, corresponding to Figure 8.25. Consider the set of all possible distributions deﬁned over a ﬁxed set of variables corresponding to the nodes of a particular undirected graph. We can deﬁne UI to be the set of such distributions that are consistent with the set of conditional independence statements that can be read from the graph using graph separation. Similarly, we can deﬁne UF to be the set of such distributions that can be expressed as a factorization of the form (8.39) with respect to the maximal cliques of the graph. The Hammersley-Clifford theorem (Clifford, 1990) states that the sets UI and UF are identical.

Because we are restricted to potential functions which are strictly positive it is convenient to express them as exponentials, so that

ψC(xC) = exp{−E(xC)} (8.41)

where E(xC) is called an energy function, and the exponential representation is called the Boltzmann distribution. The joint distribution is deﬁned as the product of potentials, and so the total energy is obtained by adding the energies of each of the maximal cliques.

In contrast to the factors in the joint distribution for a directed graph, the potentials in an undirected graph do not have a speciﬁc probabilistic interpretation. Although this gives greater ﬂexibility in choosing the potential functions, because there is no normalization constraint, it does raise the question of how to motivate a choice of potential function for a particular application. This can be done by viewing the potential function as expressing which conﬁgurations of the local variables are preferred to others. Global conﬁgurations that have a relatively high probability are those that ﬁnd a good balance in satisfying the (possibly conﬂicting) inﬂuences of the clique potentials. We turn now to a speciﬁc example to illustrate the use of undirected graphs.

#### 8.3.3 Illustration: Image de-noising

We can illustrate the application of undirected graphs using an example of noise removal from a binary image (Besag, 1974; Geman and Geman, 1984; Besag, 1986). Although a very simple example, this is typical of more sophisticated applications. Let the observed noisy image be described by an array of binary pixel values yi ∈ {−1,+1}, where the index i = 1,...,D runs over all pixels. We shall suppose that the image is obtained by taking an unknown noise-free image, described by binary pixel values xi ∈ {−1,+1} and randomly ﬂipping the sign of pixels with some small probability. An example binary image, together with a noise corrupted image obtained by ﬂipping the sign of the pixels with probability 10%, is shown in Figure 8.30. Given the noisy image, our goal is to recover the original noise-free image.

Because the noise level is small, we know that there will be a strong correlation

between xi and yi. We also know that neighbouring pixels xi and xj in an image are strongly correlated. This prior knowledge can be captured using the Markov

![image 48](Bishop2006_images/imageFile48.png)

![image 49](Bishop2006_images/imageFile49.png)

![image 50](Bishop2006_images/imageFile50.png)

![image 51](Bishop2006_images/imageFile51.png)

Figure 8.30 Illustration of image de-noising using a Markov random ﬁeld. The top row shows the original binary image on the left and the corrupted image after randomly changing 10% of the pixels on the right. The bottom row shows the restored images obtained using iterated conditional models (ICM) on the left and using the graph-cut algorithm on the right. ICM produces an image where 96% of the pixels agree with the original image, whereas the corresponding number for graph-cut is 99%.

random ﬁeld model whose undirected graph is shown in Figure 8.31. This graph has two types of cliques, each of which contains two variables. The cliques of the form {xi,yi} have an associated energy function that expresses the correlation between these variables. We choose a very simple energy function for these cliques of the form −ηxiyi where η is a positive constant. This has the desired effect of giving a lower energy (thus encouraging a higher probability) when xi and yi have the same sign and a higher energy when they have the opposite sign.

The remaining cliques comprise pairs of variables {xi,xj} where i and j are indices of neighbouring pixels. Again, we want the energy to be lower when the pixels have the same sign than when they have the opposite sign, and so we choose an energy given by −βxixj where β is a positive constant.

Because a potential function is an arbitrary, nonnegative function over a maximal clique, we can multiply it by any nonnegative functions of subsets of the clique, or

Figure 8.33 Example of a simple directed graph (a) and the corresponding moral graph (b).

8.3 Markov Random Fields 391

x1 x3

x2

x4

(a)

x1 x3

x2

x4

(b)

This is easily done by identifying

ψ1,2(x1,x2) = p(x1)p(x2|x1) ψ2,3(x2,x3) = p(x3|x2)

.

ψN−1,N(xN−1,xN) = p(xN|xN−1)

where we have absorbed the marginal p(x1) for the ﬁrst node into the ﬁrst potential function. Note that in this case, the partition function Z = 1.

Let us consider how to generalize this construction, so that we can convert any distribution speciﬁed by a factorization over a directed graph into one speciﬁed by a factorization over an undirected graph. This can be achieved if the clique potentials of the undirected graph are given by the conditional distributions of the directed graph. In order for this to be valid, we must ensure that the set of variables that appears in each of the conditional distributions is a member of at least one clique of the undirected graph. For nodes on the directed graph having just one parent, this is achieved simply by replacing the directed link with an undirected link. However, for nodes in the directed graph having more than one parent, this is not sufﬁcient. These are nodes that have ‘head-to-head’ paths encountered in our discussion of conditional independence. Consider a simple directed graph over 4 nodes shown in Figure 8.33. The joint distribution for the directed graph takes the form

p(x) = p(x1)p(x2)p(x3)p(x4|x1,x2,x3). (8.46)

We see that the factor p(x4|x1,x2,x3) involves the four variables x1, x2, x3, and x4, and so these must all belong to a single clique if this conditional distribution is to be absorbed into a clique potential. To ensure this, we add extra links between all pairs of parents of the node x4. Anachronistically, this process of ‘marrying the parents’ has become known as moralization, and the resulting undirected graph, after dropping the arrows, is called the moral graph. It is important to observe that the moral graph in this example is fully connected and so exhibits no conditional independence properties, in contrast to the original directed graph.

Thus in general to convert a directed graph into an undirected graph, we ﬁrst add additional undirected links between all pairs of parents for each node in the graph and

then drop the arrows on the original links to give the moral graph. Then we initialize all of the clique potentials of the moral graph to 1. We then take each conditional distribution factor in the original directed graph and multiply it into one of the clique potentials. There will always exist at least one maximal clique that contains all of the variables in the factor as a result of the moralization step. Note that in all cases the partition function is given by Z = 1.

The process of converting a directed graph into an undirected graph plays an

Section 8.4 important role in exact inference techniques such as the junction tree algorithm. Converting from an undirected to a directed representation is much less common and in general presents problems due to the normalization constraints.

We saw that in going from a directed to an undirected representation we had to discard some conditional independence properties from the graph. Of course, we could always trivially convert any distribution over a directed graph into one over an undirected graph by simply using a fully connected undirected graph. This would, however, discard all conditional independence properties and so would be vacuous. The process of moralization adds the fewest extra links and so retains the maximum number of independence properties.

We have seen that the procedure for determining the conditional independence properties is different between directed and undirected graphs. It turns out that the two types of graph can express different conditional independence properties, and it is worth exploring this issue in more detail. To do so, we return to the view of

Section 8.2 a speciﬁc (directed or undirected) graph as a ﬁlter, so that the set of all possible distributions over the given variables could be reduced to a subset that respects the conditional independencies implied by the graph. A graph is said to be a D map (for ‘dependency map’) of a distribution if every conditional independence statement satisﬁed by the distribution is reﬂected in the graph. Thus a completely disconnected graph (no links) will be a trivial D map for any distribution.

Alternatively, we can consider a speciﬁc distribution and ask which graphs have the appropriate conditional independence properties. If every conditional independence statement implied by a graph is satisﬁed by a speciﬁc distribution, then the graph is said to be an I map (for ‘independence map’) of that distribution. Clearly a fully connected graph will be a trivial I map for any distribution.

If it is the case that every conditional independence property of the distribution is reflected in the graph, and vice versa, then the graph is said to be a perfect map for

Figure 8.34 Venn diagram illustrating the set of all distributions P over a given set of variables, together with the set of distributions D that can be represented as a perfect map using a directed graph, and the set U that can be represented as a perfect map using an undirected graph.

D U

P

Figure 8.35 A directed graph whose conditional independence properties cannot be expressed using an undirected graph over the same three variables.

A B

C

that distribution. A perfect map is therefore both an I map and a D map.

Consider the set of distributions such that for each distribution there exists a directed graph that is a perfect map. This set is distinct from the set of distributions such that for each distribution there exists an undirected graph that is a perfect map. In addition there are distributions for which neither directed nor undirected graphs offer a perfect map. This is illustrated as a Venn diagram in Figure 8.34.

Figure 8.35 shows an example of a directed graph that is a perfect map for a distribution satisfying the conditional independence properties A ⊥ B | ∅ and A ⊥ B | C. There is no corresponding undirected graph over the same three variables that is a perfect map.

Conversely, consider the undirected graph over four variables shown in Figure 8.36. This graph exhibits the properties A ⊥ B | ∅, C ⊥ D | A ∪ B and A ⊥ B | C ∪D. There is no directed graph over four variables that implies the same set of conditional independence properties.

The graphical framework can be extended in a consistent way to graphs that include both directed and undirected links. These are called chain graphs (Lauritzen and Wermuth, 1989; Frydenberg, 1990), and contain the directed and undirected graphs considered so far as special cases. Although such graphs can represent a broader class of distributions than either directed or undirected alone, there remain distributions for which even a chain graph cannot provide a perfect map. Chain graphs are not discussed further in this book.

Figure 8.36 An undirected graph whose conditional independence properties cannot be expressed in terms of a directed graph over the same variables.

C

A

B

D

### 8.4 Inference in Graphical Models

We turn now to the problem of inference in graphical models, in which some of the nodes in a graph are clamped to observed values, and we wish to compute the posterior distributions of one or more subsets of other nodes. As we shall see, we can exploit the graphical structure both to ﬁnd efﬁcient algorithms for inference, and

The joint distribution for this graph takes the form

1 Z

p(x) =

ψ1,2(x1,x2)ψ2,3(x2,x3)···ψN−1,N(xN−1,xN). (8.49)

We shall consider the speciﬁc case in which the N nodes represent discrete variables each having K states, in which case each potential function ψn−1,n(xn−1,xn) comprises an K × K table, and so the joint distribution has (N − 1)K2 parameters.

Let us consider the inference problem of ﬁnding the marginal distribution p(xn) for a speciﬁc node xn that is part way along the chain. Note that, for the moment, there are no observed nodes. By deﬁnition, the required marginal is obtained by summing the joint distribution over all variables except xn, so that

p(xn) =

x1

···

···

xn−1 xn+1

p(x). (8.50)

xN

In a naive implementation, we would ﬁrst evaluate the joint distribution and then perform the summations explicitly. The joint distribution can be represented as a set of numbers, one for each possible value for x. Because there are N variables each with K states, there are KN values for x and so evaluation and storage of the joint distribution, as well as marginalization to obtain p(xn), all involve storage and computation that scale exponentially with the length N of the chain.

We can, however, obtain a much more efﬁcient algorithm by exploiting the conditional independence properties of the graphical model. If we substitute the factorized expression (8.49) for the joint distribution into (8.50), then we can rearrange the order of the summations and the multiplications to allow the required marginal to be evaluated much more efﬁciently. Consider for instance the summation over xN. The potential ψN−1,N(xN−1,xN) is the only one that depends on xN, and so we can perform the summation

ψN−1,N(xN−1,xN) (8.51)

xN

ﬁrst to give a function of xN−1. We can then use this to perform the summation over xN−1, which will involve only this new function together with the potential ψN−2,N−1(xN−2,xN−1), because this is the only other place that xN−1 appears. Similarly, the summation over x1 involves only the potential ψ1,2(x1,x2) and so can be performed separately to give a function of x2, and so on. Because each summation effectively removes a variable from the distribution, this can be viewed as the removal of a node from the graph.

If we group the potentials and summations together in this way, we can express

Now suppose we wish to evaluate the marginals p(xn) for every node n ∈ {1,...,N} in the chain. Simply applying the above procedure separately for each node will have computational cost that is O(N2M2). However, such an approach would be very wasteful of computation. For instance, to ﬁnd p(x1) we need to propagate a message µβ(·) from node xN back to node x2. Similarly, to evaluate p(x2) we need to propagate a messages µβ(·) from node xN back to node x3. This will involve much duplicated computation because most of the messages will be identical in the two cases.

Suppose instead we ﬁrst launch a message µβ(xN−1) starting from node xN and propagate corresponding messages all the way back to node x1, and suppose we similarly launch a message µα(x2) starting from node x1 and propagate the corresponding messages all the way forward to node xN. Provided we store all of the intermediate messages along the way, then any node can evaluate its marginal simply by applying (8.54). The computational cost is only twice that for ﬁnding the marginal of a single node, rather than N times as much. Observe that a message has passed once in each direction across each link in the graph. Note also that the normalization constant Z need be evaluated only once, using any convenient node.

If some of the nodes in the graph are observed, then the corresponding variables are simply clamped to their observed values and there is no summation. To see this, note that the effect of clamping a variable xn to an observed value xn can be expressed by multiplying the joint distribution by (one or more copies of) an additional function I(xn, xn), which takes the value 1 when xn = xn and the value 0 otherwise. One such function can then be absorbed into each of the potentials that contain xn. Summations over xn then contain only one term in which xn = xn.

Now suppose we wish to calculate the joint distribution p(xn−1,xn) for two neighbouring nodes on the chain. This is similar to the evaluation of the marginal for a single node, except that there are now two variables that are not summed out.

Exercise 8.15 A few moments thought will show that the required joint distribution can be written

in the form

1 Z

p(xn−1,xn) =

µα(xn−1)ψn−1,n(xn−1,xn)µβ(xn). (8.58)

Thus we can obtain the joint distributions over all of the sets of variables in each of the potentials directly once we have completed the message passing required to obtain the marginals.

This is a useful result because in practice we may wish to use parametric forms for the clique potentials, or equivalently for the conditional distributions if we started from a directed graph. In order to learn the parameters of these potentials in situa-

Chapter 9 tions where not all of the variables are observed, we can employ the EM algorithm, and it turns out that the local joint distributions of the cliques, conditioned on any observed data, is precisely what is needed in the E step. We shall consider some examples of this in detail in Chapter 13.

#### 8.4.2 Trees

We have seen that exact inference on a graph comprising a chain of nodes can be performed efﬁciently in time that is linear in the number of nodes, using an algorithm

8.4 Inference in Graphical Models 407

as illustrated in Figure 8.49(b).

At this point, it is worth pausing to summarize the particular version of the sumproduct algorithm obtained so far for evaluating the marginal p(x). We start by viewing the variable node x as the root of the factor graph and initiating messages at the leaves of the graph using (8.70) and (8.71). The message passing steps (8.66) and (8.69) are then applied recursively until messages have been propagated along every link, and the root node has received messages from all of its neighbours. Each node can send a message towards the root once it has received messages from all of its other neighbours. Once the root node has received messages from all of its neighbours, the required marginal can be evaluated using (8.63). We shall illustrate this process shortly.

To see that each node will always receive enough messages to be able to send out a message, we can use a simple inductive argument as follows. Clearly, for a graph comprising a variable root node connected directly to several factor leaf nodes, the algorithm trivially involves sending messages of the form (8.71) directly from the leaves to the root. Now imagine building up a general graph by adding nodes one at a time, and suppose that for some particular graph we have a valid algorithm. When one more (variable or factor) node is added, it can be connected only by a single link because the overall graph must remain a tree, and so the new node will be a leaf node. It therefore sends a message to the node to which it is linked, which in turn will therefore receive all the messages it requires in order to send its own message towards the root, and so again we have a valid algorithm, thereby completing the proof.

Now suppose we wish to ﬁnd the marginals for every variable node in the graph. This could be done by simply running the above algorithm afresh for each such node. However, this would be very wasteful as many of the required computations would be repeated. We can obtain a much more efﬁcient procedure by ‘overlaying’ these multiple message passing algorithms to obtain the general sum-product algorithm as follows. Arbitrarily pick any (variable or factor) node and designate it as the root. Propagate messages from the leaves to the root as before. At this point, the root node will have received messages from all of its neighbours. It can therefore send out messages to all of its neighbours. These in turn will then have received messages from all of their neighbours and so can send out messages along the links going away from the root, and so on. In this way, messages are passed outwards from the root all the way to the leaves. By now, a message will have passed in both directions across every link in the graph, and every node will have received a message from all of its neighbours. Again a simple inductive argument can be

Exercise 8.20 used to verify the validity of this message passing protocol. Because every variable node will have received messages from all of its neighbours, we can readily calculate the marginal distribution for every variable in the graph. The number of messages that have to be computed is given by twice the number of links in the graph and so involves only twice the computation involved in ﬁnding a single marginal. By comparison, if we had run the sum-product algorithm separately for each node, the amount of computation would grow quadratically with the size of the graph. Note that this algorithm is in fact independent of which node was designated as the root,

where M is the total number of variables, and then substitute for p(x) using its expansion in terms of a product of factors. In deriving the sum-product algorithm, we made use of the distributive law (8.53) for multiplication. Here we make use of the analogous law for the max operator

max(ab,ac) = amax(b,c) (8.90)

which holds if a 0 (as will always be the case for the factors in a graphical model). This allows us to exchange products with maximizations.

Consider ﬁrst the simple example of a chain of nodes described by (8.49). The evaluation of the probability maximum can be written as

max

p(x) =

x

1 Z

max

=

x1

1 Z

···max

[ψ1,2(x1,x2)···ψN−1,N(xN−1,xN)]

max

x1

xN

ψ1,2(x1,x2) ···max

ψN−1,N(xN−1,xN) .

xN

As with the calculation of marginals, we see that exchanging the max and product operators results in a much more efﬁcient computation, and one that is easily interpreted in terms of messages passed from node xN backwards along the chain to node x1.

We can readily generalize this result to arbitrary tree-structured factor graphs by substituting the expression (8.59) for the factor graph expansion into (8.89) and again exchanging maximizations with products. The structure of this calculation is identical to that of the sum-product algorithm, and so we can simply translate those results into the present context. In particular, suppose that we designate a particular variable node as the ‘root’ of the graph. Then we start a set of messages propagating inwards from the leaves of the tree towards the root, with each node sending its message towards the root once it has received all incoming messages from its other neighbours. The ﬁnal maximization is performed over the product of all messages arriving at the root node, and gives the maximum value for p(x). This could be called the max-product algorithm and is identical to the sum-product algorithm except that summations are replaced by maximizations. Note that at this stage, messages have been sent from leaves to the root, but not in the other direction.

In practice, products of many small probabilities can lead to numerical underﬂow problems, and so it is convenient to work with the logarithm of the joint distribution. The logarithm is a monotonic function, so that if a > b then lna > lnb, and hence the max operator and the logarithm function can be interchanged, so that

lnp(x). (8.91) The distributive property is preserved because

ln max

p(x) = max

x

x

max(a + b,a + c) = a + max(b,c). (8.92)

Thus taking the logarithm simply has the effect of replacing the products in the max-product algorithm with sums, and so we obtain the max-sum algorithm. From

the results (8.66) and (8.69) derived earlier for the sum-product algorithm, we can readily write down the max-sum algorithm in terms of message passing simply by replacing ‘sum’ with ‘max’ and replacing products with sums of logarithms to give

⎡ ⎣lnf(x,x1,...,xM) +

⎤ ⎦ (8.93)

µf→x(x) = max

m→f(xm)

µx

x1,...,xM

m∈ne(fs)\x

µx→f(x) =

l→x(x). (8.94)

µf

l∈ne(x)\f

The initial messages sent by the leaf nodes are obtained by analogy with (8.70) and (8.71) and are given by

µx→f(x) = 0 (8.95) µf→x(x) = lnf(x) (8.96)

while at the root node the maximum probability can then be computed, by analogy with (8.63), using

⎡ ⎣

⎤ ⎦. (8.97)

pmax = max

s→x(x)

µf

x

s∈ne(x)

So far, we have seen how to ﬁnd the maximum of the joint distribution by propagating messages from the leaves to an arbitrarily chosen root node. The result will be the same irrespective of which node is chosen as the root. Now we turn to the second problem of ﬁnding the conﬁguration of the variables for which the joint distribution attains this maximum value. So far, we have sent messages from the leaves to the root. The process of evaluating (8.97) will also give the value xmax for the most probable value of the root node variable, deﬁned by

⎡ ⎣

⎤ ⎦. (8.98)

xmax = arg max

s→x(x)

µf

x

s∈ne(x)

At this point, we might be tempted simply to continue with the message passing algorithm and send messages from the root back out to the leaves, using (8.93) and (8.94), then apply (8.98) to all of the remaining variable nodes. However, because we are now maximizing rather than summing, it is possible that there may be multiple conﬁgurations of x all of which give rise to the maximum value for p(x). In such cases, this strategy can fail because it is possible for the individual variable values obtained by maximizing the product of messages at each node to belong to different maximizing conﬁgurations, giving an overall conﬁguration that no longer corresponds to a maximum.

The problem can be resolved by adopting a rather different kind of message passing from the root node to the leaves. To see how this works, let us return once again to the simple chain example of N variables x1,...,xN each having K states,

by the lines connecting the nodes. Once we know the most probable value of the ﬁnal node xN, we can then simply follow the link back to ﬁnd the most probable state of node xN−1 and so on back to the initial node x1. This corresponds to propagating a message back down the chain using

xmaxn−1 = φ(xmaxn ) (8.102)

and is known as back-tracking. Note that there could be several values of xn−1 all of which give the maximum value in (8.101). Provided we chose one of these values when we do the back-tracking, we are assured of a globally consistent maximizing conﬁguration.

In Figure 8.53, we have indicated two paths, each of which we shall suppose corresponds to a global maximum of the joint probability distribution. If k = 2 and k = 3 each represent possible values of xmaxN , then starting from either state and tracing back along the black lines, which corresponds to iterating (8.102), we obtain a valid global maximum conﬁguration. Note that if we had run a forward pass of max-sum message passing followed by a backward pass and then applied (8.98) at each node separately, we could end up selecting some states from one path and some from the other path, giving an overall conﬁguration that is not a global maximizer. We see that it is necessary instead to keep track of the maximizing states during the forward pass using the functions φ(xn) and then use back-tracking to ﬁnd a consistent solution.

The extension to a general tree-structured factor graph should now be clear. If a message is sent from a factor node f to a variable node x, a maximization is performed over all other variable nodes x1,...,xM that are neighbours of that factor node, using (8.93). When we perform this maximization, we keep a record of which values of the variables x1,...,xM gave rise to the maximum. Then in the back-tracking step, having found xmax, we can then use these stored values to assign consistent maximizing states xmax1 ,...,xmaxM . The max-sum algorithm, with back-tracking, gives an exact maximizing conﬁguration for the variables provided the factor graph is a tree. An important application of this technique is for ﬁnding the most probable sequence of hidden states in a hidden Markov model, in which

Section 13.2 case it is known as the Viterbi algorithm.

As with the sum-product algorithm, the inclusion of evidence in the form of observed variables is straightforward. The observed variables are clamped to their observed values, and the maximization is performed over the remaining hidden variables. This can be shown formally by including identity functions for the observed variables into the factor functions, as we did for the sum-product algorithm.

It is interesting to compare max-sum with the iterated conditional modes (ICM) algorithm described on page 389. Each step in ICM is computationally simpler because the ‘messages’ that are passed from one node to the next comprise a single value consisting of the new state of the node for which the conditional distribution is maximized. The max-sum algorithm is more complex because the messages are functions of node variables x and hence comprise a set of K values for each possible state of x. Unlike max-sum, however, ICM is not guaranteed to ﬁnd a global maximum even for tree-structured graphs.

#### 8.4.6 Exact inference in general graphs

The sum-product and max-sum algorithms provide efﬁcient and exact solutions to inference problems in tree-structured graphs. For many practical applications, however, we have to deal with graphs having loops.

The message passing framework can be generalized to arbitrary graph topologies, giving an exact inference procedure known as the junction tree algorithm (Lauritzen and Spiegelhalter, 1988; Jordan, 2007). Here we give a brief outline of the key steps involved. This is not intended to convey a detailed understanding of the algorithm, but rather to give a ﬂavour of the various stages involved. If the starting point is a directed graph, it is ﬁrst converted to an undirected graph by moralization, whereas if starting from an undirected graph this step is not required. Next the graph is triangulated, which involves ﬁnding chord-less cycles containing four or more nodes and adding extra links to eliminate such chord-less cycles. For instance, in the graph in Figure 8.36, the cycle A–C–B–D–A is chord-less a link could be added between A and B or alternatively between C and D. Note that the joint distribution for the resulting triangulated graph is still deﬁned by a product of the same potential functions, but these are now considered to be functions over expanded sets of variables. Next the triangulated graph is used to construct a new tree-structured undirected graph called a join tree, whose nodes correspond to the maximal cliques of the triangulated graph, and whose links connect pairs of cliques that have variables in common. The selection of which pairs of cliques to connect in this way is important and is done so as to give a maximal spanning tree deﬁned as follows. Of all possible trees that link up the cliques, the one that is chosen is one for which the weight of the tree is largest, where the weight for a link is the number of nodes shared by the two cliques it connects, and the weight for the tree is the sum of the weights for the links. If the tree is condensed, so that any clique that is a subset of another clique is absorbed into the larger clique, this gives a junction tree. As a consequence of the triangulation step, the resulting tree satisﬁes the running intersection property, which means that if a variable is contained in two cliques, then it must also be contained in every clique on the path that connects them. This ensures that inference about variables will be consistent across the graph. Finally, a two-stage message passing algorithm, essentially equivalent to the sum-product algorithm, can now be applied to this junction tree in order to ﬁnd marginals and conditionals. Although the junction tree algorithm sounds complicated, at its heart is the simple idea that we have used already of exploiting the factorization properties of the distribution to allow sums and products to be interchanged so that partial summations can be performed, thereby avoiding having to work directly with the joint distribution. The role of the junction tree is to provide a precise and efﬁcient way to organize these computations. It is worth emphasizing that this is achieved using purely graphical operations!

The junction tree is exact for arbitrary graphs and is efﬁcient in the sense that for a given graph there does not in general exist a computationally cheaper approach. Unfortunately, the algorithm must work with the joint distributions within each node (each of which corresponds to a clique of the triangulated graph) and so the computational cost of the algorithm is determined by the number of variables in the largest

clique and will grow exponentially with this number in the case of discrete variables. An important concept is the treewidth of a graph (Bodlaender, 1993), which is deﬁned in terms of the number of variables in the largest clique. In fact, it is deﬁned to be as one less than the size of the largest clique, to ensure that a tree has a treewidth of 1. Because there in general there can be multiple different junction trees that can be constructed from a given starting graph, the treewidth is deﬁned by the junction tree for which the largest clique has the fewest variables. If the treewidth of the original graph is high, the junction tree algorithm becomes impractical.

#### 8.4.7 Loopy belief propagation

For many problems of practical interest, it will not be feasible to use exact inference, and so we need to exploit effective approximation methods. An important class of such approximations, that can broadly be called variational methods, will be discussed in detail in Chapter 10. Complementing these deterministic approaches is a wide range of sampling methods, also called Monte Carlo methods, that are based on stochastic numerical sampling from distributions and that will be discussed at length in Chapter 11.

Here we consider one simple approach to approximate inference in graphs with loops, which builds directly on the previous discussion of exact inference in trees. The idea is simply to apply the sum-product algorithm even though there is no guarantee that it will yield good results. This approach is known as loopy belief propagation (Frey and MacKay, 1998) and is possible because the message passing rules (8.66) and (8.69) for the sum-product algorithm are purely local. However, because the graph now has cycles, information can ﬂow many times around the graph. For some models, the algorithm will converge, whereas for others it will not.

#### 8.4.8 Learning the graph structure

We have seen that a message can only be sent across a link from a node when all other messages have been received by that node across its other links. Because there are loops in the graph, this raises the problem of how to initiate the message passing algorithm. To resolve this, we suppose that an initial message given by the unit function has been passed across every link in each direction. Every node is then in a position to send a message.

There are now many possible ways to organize the message passing schedule. For example, the ﬂooding schedule simultaneously passes a message across every link in both directions at each time step, whereas schedules that pass one message at a time are called serial schedules.

Following Kschischnang et al. (2001), we will say that a (variable or factor) node a has a message pending on its link to a node b if node a has received any message on any of its other links since the last time it send a message to b. Thus, when a node receives a message on one of its links, this creates pending messages on all of its other links. Only pending messages need to be transmitted because

other messages would simply duplicate the previous message on the same link. For graphs that have a tree structure, any schedule that sends only pending messages will eventually terminate once a message has passed in each direction across every

Exercise 8.29 link. At this point, there are no pending messages, and the product of the received messages at every variable give the exact marginal. In graphs having loops, however, the algorithm may never terminate because there might always be pending messages, although in practice it is generally found to converge within a reasonable time for most applications. Once the algorithm has converged, or once it has been stopped if convergence is not observed, the (approximate) local marginals can be computed using the product of the most recently received incoming messages to each variable node or factor node on every link.

In some applications, the loopy belief propagation algorithm can give poor results, whereas in other applications it has proven to be very effective. In particular, state-of-the-art algorithms for decoding certain kinds of error-correcting codes are equivalent to loopy belief propagation (Gallager, 1963; Berrou et al., 1993; McEliece et al., 1998; MacKay and Neal, 1999; Frey, 1998).

#### 8.4.8 Learning the graph structure

In our discussion of inference in graphical models, we have assumed that the structure of the graph is known and ﬁxed. However, there is also interest in going beyond the inference problem and learning the graph structure itself from data (Friedman and Koller, 2003). This requires that we deﬁne a space of possible structures as well as a measure that can be used to score each structure.

From a Bayesian viewpoint, we would ideally like to compute a posterior distribution over graph structures and to make predictions by averaging with respect to this distribution. If we have a prior p(m) over graphs indexed by m, then the posterior distribution is given by

p(m|D) ∝ p(m)p(D|m) (8.103)

where D is the observed data set. The model evidence p(D|m) then provides the score for each model. However, evaluation of the evidence involves marginalization over the latent variables and presents a challenging computational problem for many models.

Exploring the space of structures can also be problematic. Because the number of different graph structures grows exponentially with the number of nodes, it is often necessary to resort to heuristics to ﬁnd good candidates.

