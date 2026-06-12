[Page 229]

###### 4.3.4 Multiclass logistic regression

- Section 4.2 In our discussion of generative models for multiclass classiﬁcation, we have seen that for a large class of distributions, the posterior probabilities are given by a softmax transformation of linear functions of the feature variables, so that


exp(ak) j exp(aj)

p(Ck|φ) = yk(φ) =

(4.104)

where the ‘activations’ ak are given by

###### ak = wkTφ. (4.105)

There we used maximum likelihood to determine separately the class-conditional densities and the class priors and then found the corresponding posterior probabilities using Bayes’ theorem, thereby implicitly determining the parameters {wk}. Here we consider the use of maximum likelihood to determine the parameters {wk} of this model directly. To do this, we will require the derivatives of yk with respect to all of

- Exercise 4.17 the activations aj. These are given by ∂yk

∂aj

= yk(Ikj − yj) (4.106)

where Ikj are the elements of the identity matrix. Next we write down the likelihood function. This is most easily done using

the 1-of-K coding scheme in which the target vector tn for a feature vector φn belonging to class Ck is a binary vector with all elements zero except for element k, which equals one. The likelihood function is then given by

p(T|w1,...,wK) =

N

n=1

K

k=1

p(Ck|φn)tnk =

N

n=1

K

k=1

yt

nk

nk (4.107)

where ynk = yk(φn), and T is an N × K matrix of target variables with elements tnk. Taking the negative logarithm then gives

E(w1,...,wK) = −lnp(T|w1,...,wK) = −

N

n=1

K

k=1

tnk lnynk (4.108)

which is known as the cross-entropy error function for the multiclass classiﬁcation problem.

We now take the gradient of the error function with respect to one of the parameter vectors wj. Making use of the result (4.106) for the derivatives of the softmax

- Exercise 4.18 function, we obtain


E(w1,...,wK) =

∇wj

N

(ynj − tnj)φn (4.109)

n=1
