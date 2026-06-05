[Page 364]

Figure 7.8 Illustration of the ν-SVM for regression applied to the sinusoidal synthetic data set using Gaussian kernels. The predicted regression curve is shown by the red line, and the �-insensitive tube corresponds to the shaded region. Also, the data points are shown in green, and those with support vectors are indicated by blue circles.

1

t

0

−1

0 1

x

7.1.5 Computational learning theory

Historically, support vector machines have largely been motivated and analysed using a theoretical framework known as computational learning theory, also sometimes called statistical learning theory (Anthony and Biggs, 1992; Kearns and Vazirani, 1994; Vapnik, 1995; Vapnik, 1998). This has its origins with Valiant (1984) who formulated the probably approximately correct, or PAC, learning framework. The goal of the PAC framework is to understand how large a data set needs to be in order to give good generalization. It also gives bounds for the computational cost of learning, although we do not consider these here.

Suppose that a data set D of size N is drawn from some joint distribution p(x,t) where x is the input variable and t represents the class label, and that we restrict attention to ‘noise free’ situations in which the class labels are determined by some (unknown) deterministic function t = g(x). In PAC learning we say that a function f(x;D), drawn from a space F of such functions on the basis of the training set D, has good generalization if its expected error rate is below some pre-speciﬁed threshold �, so that

Ex,t [I (f(x;D) �= t)] < � (7.75)

where I(·) is the indicator function, and the expectation is with respect to the distribution p(x,t). The quantity on the left-hand side is a random variable, because it depends on the training set D, and the PAC framework requires that (7.75) holds, with probability greater than 1 − δ, for a data set D drawn randomly from p(x,t). Here δ is another pre-speciﬁed parameter, and the terminology ‘probably approximately correct’ comes from the requirement that with high probability (greater than 1−δ), the error rate be small (less than �). For a given choice of model space F, and for given parameters � and δ, PAC learning aims to provide bounds on the minimum size N of data set needed to meet this criterion. A key quantity in PAC learning is the Vapnik-Chervonenkis dimension, or VC dimension, which provides a measure of the complexity of a space of functions, and which allows the PAC framework to be extended to spaces containing an inﬁnite number of functions.

The bounds derived within the PAC framework are often described as worst-
