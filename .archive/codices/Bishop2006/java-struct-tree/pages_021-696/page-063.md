[Page 63]

subsequent decision stage in which we use these posterior probabilities to make optimal class assignments. An alternative possibility would be to solve both problems together and simply learn a function that maps inputs x directly into decisions. Such a function is called a discriminant function.

In fact, we can identify three distinct approaches to solving decision problems, all of which have been used in practical applications. These are given, in decreasing order of complexity, by:

(a) First solve the inference problem of determining the class-conditional densities p(x|Ck) for each class Ck individually. Also separately infer the prior class probabilities p(Ck). Then use Bayes’ theorem in the form

p(x|Ck)p(Ck) p(x)

p(Ck|x) =

(1.82)

to ﬁnd the posterior class probabilities p(Ck|x). As usual, the denominator in Bayes’ theorem can be found in terms of the quantities appearing in the numerator, because

�

p(x|Ck)p(Ck). (1.83)

p(x) =

k

Equivalently, we can model the joint distribution p(x,Ck) directly and then normalize to obtain the posterior probabilities. Having found the posterior probabilities, we use decision theory to determine class membership for each new input x. Approaches that explicitly or implicitly model the distribution of inputs as well as outputs are known as generative models, because by sampling from them it is possible to generate synthetic data points in the input space.

(b) First solve the inference problem of determining the posterior class probabilities

p(Ck|x), and then subsequently use decision theory to assign each new x to one of the classes. Approaches that model the posterior probabilities directly are called discriminative models.

(c) Find a function f(x), called a discriminant function, which maps each input x directly onto a class label. For instance, in the case of two-class problems, f(·) might be binary valued and such that f = 0 represents class C1 and f = 1 represents class C2. In this case, probabilities play no role.

Let us consider the relative merits of these three alternatives. Approach (a) is the most demanding because it involves ﬁnding the joint distribution over both x and Ck. For many applications, x will have high dimensionality, and consequently we may need a large training set in order to be able to determine the class-conditional densities to reasonable accuracy. Note that the class priors p(Ck) can often be estimated simply from the fractions of the training set data points in each of the classes. One advantage of approach (a), however, is that it also allows the marginal density of data p(x) to be determined from (1.83). This can be useful for detecting new data points that have low probability under the model and for which the predictions may
