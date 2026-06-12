## 13. Sequential Data

So far in this book, we have focussed primarily on sets of data points that were assumed to be independent and identically distributed (i.i.d.). This assumption allowed us to express the likelihood function as the product over all data points of the probability distribution evaluated at each data point. For many applications, however, the i.i.d. assumption will be a poor one. Here we consider a particularly important class of such data sets, namely those that describe sequential data. These often arise through measurement of time series, for example the rainfall measurements on successive days at a particular location, or the daily values of a currency exchange rate, or the acoustic features at successive time frames used for speech recognition. An example involving speech data is shown in Figure 13.1. Sequential data can also arise in contexts other than time series, for example the sequence of nucleotide base pairs along a strand of DNA or the sequence of characters in an English sentence. For convenience, we shall sometimes refer to 'past' and 'future' observations in a sequence. However, the models explored in this chapter are equally applicable to all

Figure 13.1 Example of a spectrogram of the spoken words "Bayes' theorem" showing a plot of the intensity of the spectral coefficients versus time index.

![image 46](Bishop2006_images/imageFile46.png)

It is useful to distinguish between stationary and nonstationary sequential distributions. In the stationary case, the data evolves in time, but the distribution from which it is generated remains the same. For the more complex nonstationary situation, the generative distribution itself is evolving with time. Here we shall focus on the stationary case.

For many applications, such as financial forecasting, we wish to be able to predict the next value in a time series given observations of the previous values. Intuitively, we expect that recent observations are likely to be more informative than more historical observations in predicting future values. The example in Figure 13.1 shows that successive observations of the speech spectrum are indeed highly correlated. Furthermore, it would be impractical to consider a general dependence of future observations on all previous observations because the complexity of such a model would grow without limit as the number of observations increases. This leads us to consider Markov models in which we assume that future predictions are inde-

Figure 13.2 The simplest approach to modelling a sequence of observations is to treat them as independent, corresponding to a graph without links.

![image 302](Bishop2006_images/imageFile302.png)

Although such models are tractable, they are also severely limited. We can obtain a more general framework, while still retaining tractability, by the introduction of latent variables, leading to state space models. As in Chapters 9 and 12, we shall see that complex models can thereby be constructed from simpler components (in particular, from distributions belonging to the exponential family) and can be readily characterized using the framework of probabilistic graphical models. Here we focus on the two most important examples of state space models, namely the hidden Markov model, in which the latent variables are discrete, and linear dynamical systems, in which the latent variables are Gaussian. Both models are described by directed graphs having a tree structure (no loops) for which inference can be performed efficiently using the sum-product algorithm.

### 13.1 Markov Models

The easiest way to treat sequential data would be simply to ignore the sequential aspects and treat the observations as i.i.d., corresponding to the graph in Figure 13.2. Such an approach, however, would fail to exploit the sequential patterns in the data, such as correlations between observations that are close in the sequence. Suppose, for instance, that we observe a binary variable denoting whether on a particular day it rained or not. Given a time series of recent observations of this variable, we wish to predict whether it will rain on the next day. If we treat the data as i.i.d., then the only information we can glean from the data is the relative frequency of rainy days. However, we know in practice that the weather often exhibits trends that may last for several days. Observing whether or not it rains today is therefore of significant help in predicting if it will rain tomorrow.

To express such effects in a probabilistic model, we need to relax the i.i.d. assumption, and one of the simplest ways to do this is to consider a Markov model. First of all we note that, without loss of generality, we can use the product rule to express the joint distribution for a sequence of observations in the form

$$
p (x _ { 1 },\dots, x _ { N }) =\prod _ { n = 1 } ^ { N } p (x _ { n } | x _ { 1 },\dots, x _ { n - 1 }).
$$

If we now assume that each of the conditional distributions on the right-hand side is independent of all previous observations except the most recent, we obtain the first-order Markov chain, which is depicted as a graphical model in Figure 13.3. The

Figure 13.3 A first-order Markov chain of observations { x n } in which the distribution p (x n | x n − 1) of a particular observation x n is conditioned on the value of the previous observation.

![image 304](Bishop2006_images/imageFile304.png)

$$
p (x _ { 1 },\dots, x _ { N }) = p (x _ { 1 })\prod _ { n = 2 } ^ { N } p (x _ { n } | x _ { n - 1 }).\\\intertext { d - s e r a p o r y, w e s e e t h a t the c o n t i o n a l d i t u b i o n f o r a s e r a - }
$$

From the d-separation property, we see that the conditional distribution for observation x n, given all of the observations up to time n, is given by

$$
p (x _ { n } | x _ { 1 },\dots, x _ { n - 1 }) = p (x _ { n } | x _ { n - 1 })\\\\
$$

which is easily verified by direct evaluation starting from (13.2) and using the product rule of probability. Thus if we use such a model to predict the next observation in a sequence, the distribution of predictions will depend only on the value of the immediately preceding observation and will be independent of all earlier observations.

In most applications of such models, the conditional distributions p (x n | x n − 1) that define the model will be constrained to be equal, corresponding to the assumption of a stationary time series. The model is then known as a homogeneous Markov chain. For instance, if the conditional distributions depend on adjustable parameters (whose values might be inferred from a set of training data), then all of the conditional distributions in the chain will share the same values of those parameters.

Although this is more general than the independence model, it is still very restrictive. For many sequential observations, we anticipate that the trends in the data over several successive observations will provide important information in predicting the next value. One way to allow earlier observations to have an influence is to move to higher-order Markov chains. If we allow the predictions to depend also on the previous-but-one value, we obtain a second-order Markov chain, represented by the graph in Figure 13.4. The joint distribution is now given by

$$
p (x _ { 1 },\dots, x _ { N }) = p (x _ { 1 }) p (x _ { 2 } | x _ { 1 })\prod _ { n = 3 } ^ { N } p (x _ { n } | x _ { n - 1 }, x _ { n - 2 }).\\\text { again, using } d\text { separation or by direct evaluation, we see that the conditional distrib-}
$$

Again, using d-separation or by direct evaluation, we see that the conditional distribution of x n given x n − 1 and x n − 2 is independent of all observations x 1,... x n − 3.

Figure 13.4

A second-order Markov chain, in which the conditional distribution of a particular observation x n depends on the values of the two previous observations x n − 1 and x n − 2.

![image 303](Bishop2006_images/imageFile303.png)

Figure 13.5 We can represent sequential data using a Markov chain of latent variables, with each observation conditioned on the state of the corresponding latent variable. This important graphical structure forms the foundation both for the hidden Markov model and for linear dynamical systems.

![image 305](Bishop2006_images/imageFile305.png)

Each observation is now influenced by two previous observations. We can similarly consider extensions to an M th order Markov chain in which the conditional distribution for a particular variable depends on the previous M variables. However, we have paid a price for this increased flexibility because the number of parameters in the model is now much larger. Suppose the observations are discrete variables having K states. Then the conditional distribution p (x n | x n − 1) in a first-order Markov chain will be specified by a set of K − 1 parameters for each of the K states of x n − 1 giving a total of K (K − 1) parameters. Now suppose we extend the model to an M th order Markov chain, so that the joint distribution is built up from conditionals p (x n | x n − M,..., x n − 1). If the variables are discrete, and if the conditional distributions are represented by general conditional probability tables, then the number of parameters in such a model will have K M − 1 (K − 1) parameters. Because this grows exponentially with M, it will often render this approach impractical for larger values of M.

For continuous variables, we can use linear-Gaussian conditional distributions in which each node has a Gaussian distribution whose mean is a linear function of its parents. This is known as an autoregressive or AR model (Box et al., 1994; Thiesson et al., 2004). An alternative approach is to use a parametric model for p (x n | x n − M,..., x n − 1) such as a neural network. This technique is sometimes called a tapped delay line because it corresponds to storing (delaying) the previous M values of the observed variable in order to predict the next value. The number of parameters can then be much smaller than in a completely general model (for example it may grow linearly with M), although this is achieved at the expense of a restricted family of conditional distributions.

Suppose we wish to build a model for sequences that is not limited by the Markov assumption to any order and yet that can be specified using a limited number of free parameters. We can achieve this by introducing additional latent variables to permit a rich class of models to be constructed out of simple components, as we did with mixture distributions in Chapter 9 and with continuous latent variable models in Chapter 12. For each observation x n, we introduce a corresponding latent variable z n (which may be of different type or dimensionality to the observed variable). We now assume that it is the latent variables that form a Markov chain, giving rise to the graphical structure known as a state space model, which is shown in Figure 13.5. It satisfies the key conditional independence property that z n − 1 and z n +1 are independent given z n, so that z z z

$$
z _ { n + 1 }\perp _ { n - 1 } z _ { n - 1 }\, |\, z _ { n }.
$$

The joint distribution for this model is given by

$$
1\text { the joint disunion for this model is given by}\\ p (x _ { 1 },\dots, x _ { N }, z _ { 1 },\dots, z _ { N }) = p (z _ { 1 })\left [\prod _ { n = 2 } ^ { N } p (z _ { n } | z _ { n - 1 })\right]\prod _ { n = 1 } ^ { N } p (x _ { n } | z _ { n }).\quad (1 3. 6)\\\text {Using the $d$-separation criterion, we see that there is always a path connecting any}
$$

Using the d-separation criterion, we see that there is always a path connecting any two observed variables x n and x m via the latent variables, and that this path is never blocked. Thus the predictive distribution p (x n +1 | x 1,..., x n) for observation x n +1 given all previous observations does not exhibit any conditional independence properties, and so our predictions for x n +1 depends on all previous observations. The observed variables, however, do not satisfy the Markov property at any order. We shall discuss how to evaluate the predictive distribution in later sections of this chapter.

There are two important models for sequential data that are described by this graph. If the latent variables are discrete, then we obtain the hidden Markov model, or HMM (Elliott et al., 1995). Note that the observed variables in an HMM may be discrete or continuous, and a variety of different conditional distributions can be used to model them. If both the latent and the observed variables are Gaussian (with a linear-Gaussian dependence of the conditional distributions on their parents), then we obtain the linear dynamical system.

### 13.2 Hidden Markov Models

The hidden Markov model can be viewed as a specific instance of the state space model of Figure 13.5 in which the latent variables are discrete. However, if we examine a single time slice of the model, we see that it corresponds to a mixture distribution, with component densities given by p (x | z). It can therefore also be interpreted as an extension of a mixture model in which the choice of mixture component for each observation is not selected independently but depends on the choice of component for the previous observation. The HMM is widely used in speech recognition (Jelinek, 1997; Rabiner and Juang, 1993), natural language modelling (Manning and Sch¨ utze, 1999), on-line handwriting recognition (Nag et al., 1986), and for the analysis of biological sequences such as proteins and DNA (Krogh et al., 1994; Durbin et al., 1998; Baldi and Brunak, 2001).

As in the case of a standard mixture model, the latent variables are the discrete multinomial variables z n describing which component of the mixture is responsible for generating the corresponding observation x n. Again, it is convenient to use a 1 -ofK coding scheme, as used for mixture models in Chapter 9. We now allow the probability distribution of z n to depend on the state of the previous latent variable z n − 1 through a conditional distribution p (z n | z n − 1). Because the latent variables are K -dimensional binary variables, this conditional distribution corresponds to a table of numbers that we denote by A, the elements of which are known as transition probabilities. They are given by A jk ≡ p (z nk = 1 | z n − 1,j = 1), and because they are probabilities, they satisfy 0 A jk 1 with k A jk = 1, so that the matrix A

Figure 13.6 Transition diagram showing a model whose latent variables have three possible states corresponding to the three boxes. The black lines denote the elements of the transition matrix A jk.

![image 306](Bishop2006_images/imageFile306.png)

$$
p (z _ { n } | z _ { n - 1, A }) =\prod _ { k = 1 } ^ { K }\prod _ { j = 1 } ^ { K } A _ { j k } ^ { z _ { n - 1, j } z _ { n k } }.\\\intertext { l o t. n o t. n o d. g. i s o m o j i l. p h t t i d e s n o t h e v o r n o r p e d o n d o s e }
$$

The initial latent node z 1 is special in that it does not have a parent node, and so it has a marginal distribution p (z 1) represented by a vector of probabilities π with elements π k ≡ p (z 1 k = 1), so that

$$
p (z _ { 1 } |\pi) =\prod _ { k = 1 } ^ { K }\pi _ { k } ^ { z _ { 1 k } }
$$

where k π k = 1. The transition matrix is sometimes illustrated diagrammatically by drawing the states as nodes in a state transition diagram as shown in Figure 13.6 for the case of K = 3. Note that this does not represent a probabilistic graphical model, because the nodes are not separate variables but rather states of a single variable, and so we have shown the states as boxes rather than circles.

It is sometimes useful to take a state transition diagram, of the kind shown in Figure 13.6, and unfold it over time. This gives an alternative representation of the transitions between latent states, known as a lattice or trellis diagram, and which is shown for the case of the hidden Markov model in Figure 13.7.

The specification of the probabilistic model is completed by defining the conditional distributions of the observed variables p (x n | z n, φ), where φ is a set of parameters governing the distribution. These are known as emission probabilities, and might for example be given by Gaussians of the form (9.11) if the elements of x are continuous variables, or by conditional probability tables if x is discrete. Because x n is observed, the distribution p (x n | z n, φ) consists, for a given value of φ, of a vector of K numbers corresponding to the K possible states of the binary vector z n.

Figure 13.7 If we unfold the state transition diagram of Figure 13.6 over time, we obtain a lattice, or trellis, representation of the latent states. Each column of this diagram corresponds to one of the latent variables z n.

![image 307](Bishop2006_images/imageFile307.png)

- 1

$$
p (x _ { n } | z _ { n },\phi) =\prod _ { k = 1 } ^ { K } p (x _ { n } |\phi _ { k }) ^ { z _ { n k } }.\\
$$

We shall focuss attention on homogeneous models for which all of the conditional distributions governing the latent variables share the same parameters A, and similarly all of the emission distributions share the same parameters φ (the extension to more general cases is straightforward). Note that a mixture model for an i.i.d. data set corresponds to the special case in which the parameters A jk are the same for all values of j, so that the conditional distribution p (z n | z n − 1) is independent of z n − 1. This corresponds to deleting the horizontal links in the graphical model shown in Figure 13.5.

The joint probability distribution over both latent and observed variables is then given by

$$
\text {given by} & & p (X, Z |\theta) = p (z _ { 1 } |\pi)\left [\prod _ { n = 2 } ^ { N } p (z _ { n } | z _ { n - 1 }, A)\right]\prod _ { m = 1 } ^ { N } p (x _ { m } | z _ { m },\phi)\\\text {where } X =\{ x _ { 1 },\quad x _ { n }\} _ { Z } =\{ z _ { 1 },\quad z _ { n }\} _ { Z }\text {, and }\theta =\{\pi\ A\\phi\}\text { denotes the set}
$$

where X = { x 1,..., x N }, Z = { z 1,..., z N }, and θ = { π, A, φ } denotes the set of parameters governing the model. Most of our discussion of the hidden Markov model will be independent of the particular choice of the emission probabilities. Indeed, the model is tractable for a wide range of emission distributions including discrete tables, Gaussians, and mixtures of Gaussians. It is also possible to exploit discriminative models such as neural networks. These can be used to model the emission density p (x | z) directly, or to provide a representation for p (z | x) that can be converted into the required emission density p (x | z) using Bayes' theorem (Bishop et al., 2004).

We can gain a better understanding of the hidden Markov model by considering it from a generative point of view. Recall that to generate samples from a mixture of

![image 308](Bishop2006_images/imageFile308.png)

Figure 13.8 Illustration of sampling from a hidden Markov model having a 3-state latent variable z and a Gaussian emission model p (x | z) where x is 2-dimensional. (a) Contours of constant probability density for the emission distributions corresponding to each of the three states of the latent variable. (b) A sample of 50 points drawn from the hidden Markov model, colour coded according to the component that generated them and with lines connecting the successive observations. Here the transition matrix was fixed so that in any state there is a 5% probability of making a transition to each of the other states, and consequently a 90% probability of remaining in the same state.

Gaussians, we first chose one of the components at random with probability given by the mixing coefficients π k and then generate a sample vector x from the corresponding Gaussian component. This process is repeated N times to generate a data set of N independent samples. In the case of the hidden Markov model, this procedure is modified as follows. We first choose the initial latent variable z 1 with probabilities governed by the parameters π k and then sample the corresponding observation x 1. Now we choose the state of the variable z 2 according to the transition probabilities p (z 2 | z 1) using the already instantiated value of z 1. Thus suppose that the sample for z 1 corresponds to state j. Then we choose the state k of z 2 with probabilities A jk for k = 1,...,K. Once we know z 2 we can draw a sample for x 2 and also sample the next latent variable z 3 and so on. This is an example of ancestral sampling for a directed graphical model. If, for instance, we have a model in which the diagonal transition elements A kk are much larger than the off-diagonal elements, then a typical data sequence will have long runs of points generated from a single component, with infrequent transitions from one component to another. The generation of samples from a hidden Markov model is illustrated in Figure 13.8.

There are many variants of the standard HMM model, obtained for instance by imposing constraints on the form of the transition matrix A (Rabiner, 1989). Here we mention one of particular practical importance called the left-to-right HMM, which is obtained by setting the elements A jk of A to zero if k < j, as illustrated in the

Figure 13.9 Example of the state transition diagram for a 3-state left-to-right hidden Markov model. Note that once a state has been vacated, it cannot later be re-entered.

![image 309](Bishop2006_images/imageFile309.png)

state transition diagram for a 3-state HMM in Figure 13.9. Typically for such models the initial state probabilities for p (z 1) are modified so that p (z 11) = 1 and p (z 1 j) = 0 for j = 1, in other words every sequence is constrained to start in state j = 1. The transition matrix may be further constrained to ensure that large changes in the state index do not occur, so that A jk = 0 if k > j + ∆. This type of model is illustrated using a lattice diagram in Figure 13.10.

/negationslash

Many applications of hidden Markov models, for example speech recognition, or on-line character recognition, make use of left-to-right architectures. As an illustration of the left-to-right hidden Markov model, we consider an example involving handwritten digits. This uses on-line data, meaning that each digit is represented by the trajectory of the pen as a function of time in the form of a sequence of pen coordinates, in contrast to the off-line digits data, discussed in Appendix A, which comprises static two-dimensional pixellated images of the ink. Examples of the online digits are shown in Figure 13.11. Here we train a hidden Markov model on a subset of data comprising 45 examples of the digit '2'. There are K = 16 states, each of which can generate a line segment of fixed length having one of 16 possible angles, and so the emission distribution is simply a 16 × 16 table of probabilities associated with the allowed angle values for each state index value. Transition probabilities are all set to zero except for those that keep the state index k the same or that increment it by 1, and the model parameters are optimized using 25 iterations of EM. We can gain some insight into the resulting model by running it generatively, as shown in Figure 13.11.

Figure 13.10 Lattice diagram for a 3-state leftto-right HMM in which the state index k is allowed to increase by at most 1 at each transition.

![image 310](Bishop2006_images/imageFile310.png)

- 1

Figure 13.11

Top row: examples of on-line handwritten digits. Bottom row: synthetic digits sampled generatively from a left-to-right hidden Markov model that has been trained on a data set of 45 handwritten digits.

![image 311](Bishop2006_images/imageFile311.png)

One of the most powerful properties of hidden Markov models is their ability to exhibit some degree of invariance to local warping (compression and stretching) of the time axis. To understand this, consider the way in which the digit '2' is written in the on-line handwritten digits example. A typical digit comprises two distinct sections joined at a cusp. The first part of the digit, which starts at the top left, has a sweeping arc down to the cusp or loop at the bottom left, followed by a second moreor-less straight sweep ending at the bottom right. Natural variations in writing style will cause the relative sizes of the two sections to vary, and hence the location of the cusp or loop within the temporal sequence will vary. From a generative perspective such variations can be accommodated by the hidden Markov model through changes in the number of transitions to the same state versus the number of transitions to the successive state. Note, however, that if a digit '2' is written in the reverse order, that is, starting at the bottom right and ending at the top left, then even though the pen tip coordinates may be identical to an example from the training set, the probability of the observations under the model will be extremely small. In the speech recognition context, warping of the time axis is associated with natural variations in the speed of speech, and again the hidden Markov model can accommodate such a distortion and not penalize it too heavily.

#### 13.2.1 Maximum likelihood for the HMM

If we have observed a data set X = { x 1,..., x N }, we can determine the parameters of an HMM using maximum likelihood. The likelihood function is obtained from the joint distribution (13.10) by marginalizing over the latent variables

$$
p (X |\theta) =\sum _ { Z } p (X, Z |\theta).\\
$$

Because the joint distribution p (X, Z | θ) does not factorize over n (in contrast to the mixture distribution considered in Chapter 9), we cannot simply treat each of the summations over z n independently. Nor can we perform the summations explicitly because there are N variables to be summed over, each of which has K states, resulting in a total of K N terms. Thus the number of terms in the summation grows exponentially with the length of the chain. In fact, the summation in (13.11) corresponds to summing over exponentially many paths through the lattice diagram in Figure 13.7.

We have already encountered a similar difficulty when we considered the inference problem for the simple chain of variables in Figure 8.32. There we were able to make use of the conditional independence properties of the graph to re-order the summations in order to obtain an algorithm whose cost scales linearly, instead of exponentially, with the length of the chain. We shall apply a similar technique to the hidden Markov model.

A further difficulty with the expression (13.11) for the likelihood function is that, because it corresponds to a generalization of a mixture distribution, it represents a summation over the emission models for different settings of the latent variables. Direct maximization of the likelihood function will therefore lead to complex expressions with no closed-form solutions, as was the case for simple mixture models (recall that a mixture model for i.i.d. data is a special case of the HMM).

We therefore turn to the expectation maximization algorithm to find an efficient framework for maximizing the likelihood function in hidden Markov models. The EM algorithm starts with some initial selection for the model parameters, which we denote by θ old. In the E step, we take these parameter values and find the posterior distribution of the latent variables p (Z | X, θ old). We then use this posterior distribution to evaluate the expectation of the logarithm of the complete-data likelihood function, as a function of the parameters θ, to give the function Q (θ, θ old) defined by

$$
Q (\theta,\theta ^ {\text {old} }) & =\sum _ { z } p (Z | X,\theta ^ {\text {old} })\ln p (X, Z |\theta).\\\intertext { p o n t, i t is convenient t o introduce some notation. We shall use\gamma (z _ { n }) to }
$$

At this point, it is convenient to introduce some notation. We shall use γ (z n) to denote the marginal posterior distribution of a latent variable z n, and ξ (z n − 1, z n) to denote the joint posterior distribution of two successive latent variables, so that

$$
\gamma (z _ { n })\ =\ p (z _ { n } | X,\theta ^ {\text {old} }) & & (1 3. 1 3)\\\xi (\tau _ { n },\tau _ { 1 })\ =\ p (\tau _ { n },\tau _ { 1 }\, | X\,\theta ^ {\text {old} }) & & (1 3. 1 4)
$$

$$
\xi (z _ { n - 1 }, z _ { n })\ =\ p (z _ { n - 1 }, z _ { n } | X,\theta ^ {\text {old} }).
$$

For each value of n, we can store γ (z n) using a set of K nonnegative numbers that sum to unity, and similarly we can store ξ (z n − 1, z n) using a K × K matrix of nonnegative numbers that again sum to unity. We shall also use γ (z nk) to denote the conditional probability of z nk = 1, with a similar use of notation for ξ (z n − 1,j,z nk) and for other probabilistic variables introduced later. Because the expectation of a binary random variable is just the probability that it takes the value 1, we have

$$
\gamma (z _ { n k })\ & =\\mathbb { E } [z _ { n k }] =\sum _ { z }\gamma (z) z _ { n k }\\\xi (z _ { n - 1 } i, z _ { n k })\ & =\\mathbb { E } [z _ { n - 1 } i z _ { n k }] =\sum _ { z }\gamma (z) z _ { n - 1 } i z _ { n k }.
$$

$$
\xi (z _ { n - 1, j }, z _ { n k })\ =\\mathbb { E } [z _ { n - 1, j } z _ { n k }] =\sum _ { z }\gamma (z) z _ { n - 1, j } z _ { n k }.\\\\\text {If two substituto the joint distribution } n (X, Z |\theta)\text { given by } (1 3. 1 0)\text { into } (1 3. 1 2)
$$

If we substitute the joint distribution p (X, Z | θ) given by (13.10) into (13.12),

Exercise 13.6 and make use of the definitions of γ and ξ, we obtain

$$
Q (\theta,\theta ^ {\text {old} }) & =\sum _ { k = 1 } ^ { K }\gamma (z _ { 1 k })\ln\pi _ { k } +\sum _ { n = 2 } ^ { N }\sum _ { j = 1 } ^ { K }\xi (z _ { n - 1, j }, z _ { n k })\ln A _ { j k }\\ & +\sum _ { n = 1 } ^ { N }\sum _ { k = 1 } ^ { K }\gamma (z _ { n k })\ln p (x _ { n } |\phi _ { k }).\\\intertext { The goal of the E step will be to evaluate the quantities\gamma (z _ { n })\text { and }\xi (z _ { n - 1 }, z _ { n })\text {effi-} }
$$

The goal of the E step will be to evaluate the quantities γ (z n) and ξ (z n − 1, z n) efficiently, and we shall discuss this in detail shortly. old

In the M step, we maximize Q (θ, θ) with respect to the parameters θ = { π, A, φ } in which we treat γ (z n) and ξ (z n − 1, z n) as constant. Maximization with respect to π and A is easily achieved using appropriate Lagrange multipliers with the results

$$
\pi _ { k }\ =\\frac {\gamma (z _ { 1 k }) } { K } & & (1 3. 1 8)\\\sum _ { j = 1 } ^ { N }\gamma (z _ { 1 j }) & &\\
$$

$$
j = & 1\int _ { N } ^ { N }\sum _ {\substack { N\\\leq n = 2 } } ^ { N }\xi (z _ { n - 1, j }, z _ { n k })\\\sum _ { l = 1 } ^ { N }\sum _ { n = 2 } ^ { N }\xi (z _ { n - 1, j }, z _ { n l })\\\intertext { a n t h m u s t h e i n i l a z e d y b o c h i s o n g t a n t r i g h e r s }
$$

The EM algorithm must be initialized by choosing starting values for π and A, which should of course respect the summation constraints associated with their probabilistic interpretation. Note that any elements of π or A that are set to zero initially will remain zero in subsequent EM updates. A typical initialization procedure would involve selecting random starting values for these parameters subject to the summation and non-negativity constraints. Note that no particular modification to the EM results are required for the case of left-to-right models beyond choosing initial values for the elements A jk in which the appropriate elements are set to zero, because these will remain zero throughout. old

To maximize Q (θ, θ) with respect to φ k, we notice that only the final term in (13.17) depends on φ k, and furthermore this term has exactly the same form as the data-dependent term in the corresponding function for a standard mixture distribution for i.i.d. data, as can be seen by comparison with (9.40) for the case of a Gaussian mixture. Here the quantities γ (z nk) are playing the role of the responsibilities. If the parameters φ k are independent for the different components, then this term decouples into a sum of terms one for each value of k, each of which can be maximized independently. We are then simply maximizing the weighted log likelihood function for the emission density p (x | φ k) with weights γ (z nk). Here we shall suppose that this maximization can be done efficiently. For instance, in the case of

Gaussian emission densities we have p (x | φ k) = N (x | µ k, Σ k), and maximization of the function Q (θ, θ old) then gives

$$
\begin{array} { c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c
$$

$$
\sum _ { n = 1 } ^ { N }
$$

For the case of discrete multinomial observed variables, the conditional distribution of the observations takes the form

$$
p (x | z) =\prod _ { i = 1 } ^ { D }\prod _ { k = 1 } ^ { K }\mu _ { i k } ^ { x _ { i } z _ { k } } & & (1 3. 2 2)\\\intertext { g M step equations are given by }
$$

and the corresponding M-step equations are given by Exercise 13.8

$$
\sum _ {\mu _ { i k } =\frac { n = 1 } { N } } ^ { N }\gamma (z _ { n k }) x _ { n i } & & (1 3. 2 3)\\\sum _ { n = 1 } ^ { N }\gamma (z _ { n k }) & &\\\intertext { o n d s }\text {for Bernoulli observed variables}.
$$

An analogous result holds for Bernoulli observed variables.

The EM algorithm requires initial values for the parameters of the emission distribution. One way to set these is first to treat the data initially as i.i.d. and fit the emission density by maximum likelihood, and then use the resulting values to initialize the parameters for EM.

#### 13.2.2 The forward-backward algorithm

Next we seek an efficient procedure for evaluating the quantities γ (z nk) and ξ (z n − 1,j,z nk), corresponding to the E step of the EM algorithm. The graph for the hidden Markov model, shown in Figure 13.5, is a tree, and so we know that the posterior distribution of the latent variables can be obtained efficiently using a twostage message passing algorithm. In the particular context of the hidden Markov model, this is known as the forward-backward algorithm (Rabiner, 1989), or the Baum-Welch algorithm (Baum, 1972). There are in fact several variants of the basic algorithm, all of which lead to the exact marginals, according to the precise form of the messages that are propagated along the chain (Jordan, 2007). We shall focus on the most widely used of these, known as the alpha-beta algorithm.

As well as being of great practical importance in its own right, the forwardbackward algorithm provides us with a nice illustration of many of the concepts introduced in earlier chapters. We shall therefore begin in this section with a 'conventional' derivation of the forward-backward equations, making use of the sum and product rules of probability, and exploiting conditional independence properties which we shall obtain from the corresponding graphical model using d-separation. Then in Section 13.2.3, we shall see how the forward-backward algorithm can be obtained very simply as a specific example of the sum-product algorithm introduced in Section 8.4.4.

It is worth emphasizing that evaluation of the posterior distributions of the latent variables is independent of the form of the emission density p (x | z) or indeed of whether the observed variables are continuous or discrete. All we require is the values of the quantities p (x n | z n) for each value of z n for every n. Also, in this section and the next we shall omit the explicit dependence on the model parameters θ old because these fixed throughout.

We therefore begin by writing down the following conditional independence properties (Jordan, 2007)

$$
\begin{array} { r l r } { p (X | z _ { n }) } & = } & { p (x _ { 1 },\dots, x _ { n } | z _ { n }) }\\ & { p (x _ { n + 1 },\dots, x _ { N } | z _ { n }) }\end{array}
$$

$$
p (X | z _ { n })\ & =\ p (x _ { 1 },\dots, x _ { n } | z _ { n })\\ p (x _ { 1 },\dots, x _ { n - 1 } | x _ { n }, z _ { n })\ & =\ p (x _ { 1 },\dots, x _ { n - 1 } | z _ { n })\\ p (x _ { 1 },\dots, x _ { n - 1 } | z _ { n - 1 }, z _ { n })\ & =\ p (x _ { 1 },\dots, x _ { n - 1 } | z _ { n - 1 })\\ p (x _ { n + 1 },\dots, x _ { N } | z _ { n }, z _ { n + 1 })\ & =\ p (x _ { n + 1 },\dots, x _ { N } | z _ { n + 1 })\\ p (x _ { n + 2 },\dots, x _ { N } | z _ { n + 1 }, x _ { n + 1 })\ & =\ p (x _ { n + 2 },\dots, x _ { N } | z _ { n + 1 })\\ p (X | z _ { n - 1 }, z _ { n })\ & =\ p (x _ { 1 },\dots, x _ { n - 1 } | z _ { n - 1 })\\ p (x _ { N + 1 } | X, z _ { N + 1 })\ & =\ p (x _ { N + 1 } | z _ { N + 1 })\\ p (z _ { N + 1 } | z _ { N }, X)\ & =\ p (z _ { N + 1 } | z _ { N })
$$

$$
\ p (z _ { N + 1 } | z _ { N }, X)\ =\ p (z _ { N + 1 } | z _ { N })
$$

where X = { x 1,..., x N }. These relations are most easily proved using d-separation. For instance in the first of these results, we note that every path from any one of the nodes x 1,..., x n − 1 to the node x n passes through the node z n, which is observed. Because all such paths are head-to-tail, it follows that the conditional independence property must hold. The reader should take a few moments to verify each of these properties in turn, as an exercise in the application of d-separation. These relations can also be proved directly, though with significantly greater effort, from the joint distribution for the hidden Markov model using the sum and product rules of probability.

Let us begin by evaluating γ (z nk). Recall that for a discrete multinomial random variable the expected value of one of its components is just the probability of that component having the value 1. Thus we are interested in finding the posterior distribution p (z n | x 1,..., x N) of z n given the observed data set x 1,..., x N. This

$$
\gamma (z _ { n }) = p (z _ { n } | X) =\frac { p (X | z _ { n }) p (z _ { n }) } { p (X) }.
$$

Note that the denominator p (X) is implicitly conditioned on the parameters θ old of the HMM and hence represents the likelihood function. Using the conditional independence property (13.24), together with the product rule of probability, we obtain

$$
\gamma (z _ { n }) =\frac { p (x _ { 1 },\dots, x _ { n }, z _ { n }) p (x _ { n + 1 },\dots, x _ { N } | z _ { n }) } { p (X) } =\frac {\alpha (z _ { n })\beta (z _ { n }) } { p (X) }\quad (1 3. 3 3)
$$

where we have defined

$$
\alpha (z _ { n }) &\\equiv\ p (x _ { 1 },\dots, x _ { n }, z _ { n }) & & (1 3. 3 4)\\\beta (z _ { n }) &\\equiv\ p (x _ { n } +\quad x _ { n } | z _ { n }) & & (1 3. 3 5)
$$

$$
\beta (z _ { n })\\equiv\ p (x _ { n + 1 },\dots, x _ { N } | z _ { n }).\\ (-\, _ { n })\\underset {\ } {\underset {\ } {\ } }\ n\,\underset {\ } {\ }\ t h\colon\, i\sin t\,\underset {\ } {\ }\ t h\colon\, i\sin t\,\underset {\ } {\ }\ t h\cdot\, _ { n }\,\underset {\ } {\ }\ t h\cdot\, _ { n + 1 }\,\underset {\ } {\ }\ t h
$$

The quantity α (z n) represents the joint probability of observing all of the given data up to time n and the value of z n, whereas β (z n) represents the conditional probability of all future data from time n + 1 up to N given the value of z n. Again, α (z n) and β (z n) each represent set of K numbers, one for each of the possible settings of the 1-ofK coded binary vector z n. We shall use the notation α (z nk) to denote the value of α (z n) when z nk = 1, with an analogous interpretation of β (z nk). (z) (z)

We now derive recursion relations that allow α n and β n to be evaluated efficiently. Again, we shall make use of conditional independence properties, in particular (13.25) and (13.26), together with the sum and product rules, allowing us to express α (z n) in terms of α (z n − 1) as follows

$$
particular (1 3. 2 5)\text { and (1 3. 2 6), together with the sum and product rules, allowing us}\\ to express\alpha (z _ { n })\text { in terms of }\alpha (z _ { n - 1 })\text { as follows}\\\alpha (z _ { n })\quad =\quad p (x _ { 1 },\dots, x _ { n }, z _ { n })\\\quad =\quad p (x _ { 1 },\dots, x _ { n } | z _ { n }) p (z _ { n })\\\quad =\quad p (x _ { n } | z _ { n }) p (x _ { 1 },\dots, x _ { n - 1 } | z _ { n }) p (z _ { n })\\\quad =\quad p (x _ { n } | z _ { n })\sum _ { z _ { n - 1 } } p (x _ { 1 },\dots, x _ { n - 1 }, z _ { n - 1 }, z _ { n })\\\quad =\quad p (x _ { n } | z _ { n })\sum _ { z _ { n - 1 } } p (x _ { 1 },\dots, x _ { n - 1 }, z _ { n } | z _ { n - 1 }) p (z _ { n - 1 })\\\quad =\quad p (x _ { n } | z _ { n })\sum _ { z _ { n - 1 } } p (x _ { 1 },\dots, x _ { n - 1 } | z _ { n - 1 }) p (z _ { n - 1 }) p (z _ { n - 1 })\\\quad =\quad p (x _ { n } | z _ { n })\sum _ { z _ { n - 1 } } p (x _ { 1 },\dots, x _ { n - 1 }, z _ { n - 1 }) p (z _ { n } | z _ { n - 1 })\\\quad =\quad p (x _ { n } | z _ { n })\sum _ { z _ { n - 1 } } p (x _ { 1 },\dots, x _ { n - 1 }, z _ { n - 1 }) p (z _ { n } | z _ { n - 1 })\\\quad\text {Making use of the definition (13.34) for }\alpha (z _ { n }),\text { we then obtain }\\\alpha (z _ { n }) = p (x _ { n } | z _ { n })\sum _ {\alpha (z _ { n - 1 }) }\alpha (z _ { n - 1 }) p (z _ { n } | z _ { n - 1 }).
$$

Making use of the definition (13.34) for α (z n), we then obtain

$$
\text {use of the definition (13.54) for $\alpha(z_{n}),\text {we then obtain} }\\\alpha (z _ { n }) = p (x _ { n } | z _ { n })\sum _ { z _ { n - 1 } }\alpha (z _ { n - 1 }) p (z _ { n } | z _ { n - 1 }).
$$

#### Figure 13.12

Illustration of the forward recursion (13.36) for evaluation of the α variables. In this fragment of the lattice, we see that the quantity α (z n 1) is obtained by taking the elements α (z n − 1,j) of α (z n − 1) at step n − 1 and summing them up with weights given by A j 1, corresponding to the values of p (z n | z n − 1), and then multiplying by the data contribution p (x n | z n 1).

![image 312](Bishop2006_images/imageFile312.png)

It is worth taking a moment to study this recursion relation in some detail. Note that there are K terms in the summation, and the right-hand side has to be evaluated for each of the K values of z n so each step of the α recursion has computational cost that scaled like O (K 2). The forward recursion equation for α (z n) is illustrated using a lattice diagram in Figure 13.12.

In order to start this recursion, we need an initial condition that is given by

$$
\alpha (z _ { 1 }) = p (x _ { 1 }, z _ { 1 }) = p (z _ { 1 }) p (x _ { 1 } | z _ { 1 }) =\prod _ { k = 1 } ^ { K }\{\pi _ { k } p (x _ { 1 } |\phi _ { k })\} ^ { z _ { 1 k } }\\\intertext { w h i o n t l o s w h e t h o r }\quad\intertext { w h i o n t l o s w h e t h o r }
$$

which tells us that α (z 1 k), for k = 1,...,K, takes the value π k p (x 1 | φ k). Starting at the first node of the chain, we can then work along the chain and evaluate α (z n) for every latent node. Because each step of the recursion involves multiplying by a K × K matrix, the overall cost of evaluating these quantities for the whole chain is of O (K 2 N).

We can similarly find a recursion relation for the quantities β (z n) by making use of the conditional independence properties (13.27) and (13.28) giving

$$
\text {use of the conditional independence properties (13.27) and (13.28) giving}\\ &\quad\beta (z _ { n })\ =\ p (x _ { n + 1 },\dots, x _ { N } | z _ { n })\\ & =\\sum _ { z _ { n + 1 } } p (x _ { n + 1 },\dots, x _ { N }, z _ { n + 1 } | z _ { n })\\ & =\\sum _ { z _ { n + 1 } } p (x _ { n + 1 },\dots, x _ { N } | z _ { n }, z _ { n + 1 }) p (z _ { n + 1 } | z _ { n })\\ & =\\sum _ { z _ { n + 1 } } p (x _ { n + 1 },\dots, x _ { N } | z _ { n + 1 }) p (z _ { n + 1 } | z _ { n })\\ & =\\sum _ { z _ { n + 1 } } p (x _ { n + 2 },\dots, x _ { N } | z _ { n + 1 }) p (x _ { n + 1 } | z _ { n + 1 }) p (z _ { n + 1 } | z _ { n }).
$$

#### Figure 13.13

Illustration of the backward recursion (13.38) for evaluation of the β variables. In this fragment of the lattice, we see that the quantity β (z n 1) is obtained by taking the components β (z n +1,k) of β (z n +1) at step n + 1 and summing them up with weights given by the products of A 1 k, corresponding to the values of p (z n +1 | z n) and the corresponding values of the emission density p (x n | z n +1,k).

![image 313](Bishop2006_images/imageFile313.png)

- 1

$$
\text {ing use of the definition (13.55) for } &\beta (z _ { n }),\text { we then obtain}\\ &\beta (z _ { n }) =\sum _ { z _ { n + 1 } }\beta (z _ { n + 1 }) p (x _ { n + 1 } | z _ { n + 1 }) p (z _ { n + 1 } | z _ { n }).\\\text {that in this case we have a backward message passing algorithm that evaluates}
$$

Note that in this case we have a backward message passing algorithm that evaluates β (z n) in terms of β (z n +1). At each step, we absorb the effect of observation x n +1 through the emission probability p (x n +1 | z n +1), multiply by the transition matrix p (z n +1 | z n), and then marginalize out z n +1. This is illustrated in Figure 13.13. Again we need a starting condition for the recursion, namely a value for β (z N).

This can be obtained by setting n = N in (13.33) and replacing α (z N) with its definition (13.34) to give

$$
p (z _ { N } | X) =\frac { p (X, z _ { N })\beta (z _ { N }) } { p (X) }
$$

which we see will be correct provided we take β (z N) = 1 for all settings of z N. In the M step equations, the quantity (X) will cancel out, as can be seen, p for instance, in the M-step equation for µ k given by (13.20), which takes the form

$$
\text {e, in the } M {\text {step equation for }\mu _ { k }\text { given by } (1 3. 2 0),\text { which takes the form }\\\sum _ { n = 1 } ^ { n }\gamma (z _ { n k }) x _ { n } &\sum _ { n = 1 } ^ { n }\alpha (z _ { n k })\beta (z _ { n k }) x _ { n }\\\mu _ { k } =\frac { n = 1 } { n } & =\frac { n = 1 } { n }.\\\sum _ { n = 1 } ^ { n }\gamma (z _ { n k }) &\sum _ { n = 1 } ^ { n }\alpha (z _ { n k })\beta (z _ { n k })\\\text {er, the quantity } p (X)\text { represents the likelihood function whose value we typ-}\\
$$

However, the quantity p (X) represents the likelihood function whose value we typically wish to monitor during the EM optimization, and so it is useful to be able to evaluate it. If we sum both sides of (13.33) over z n, and use the fact that the left-hand side is a normalized distribution, we obtain Thus we can evaluate the likelihood function by computing this sum, for any convenient choice of n. For instance, if we only want to evaluate the likelihood function, then we can do this by running the α recursion from the start to the end of the chain, and then use this result for n = N, making use of the fact that β (z N) is a vector of 1s. In this case no β recursion is required, and we simply have

$$
d\text { distribution, we obtain } & & p (X) =\sum _ { z _ { n } }\alpha (z _ { n })\beta (z _ { n }).
$$

$$
p (X) =\sum _ { z _ { N } }\alpha (z _ { N }).\\
$$

Let us take a moment to interpret this result for p (X). Recall that to compute the likelihood we should take the joint distribution p (X, Z) and sum over all possible values of Z. Each such value represents a particular choice of hidden state for every time step, in other words every term in the summation is a path through the lattice diagram, and recall that there are exponentially many such paths. By expressing the likelihood function in the form (13.42), we have reduced the computational cost from being exponential in the length of the chain to being linear by swapping the order of the summation and multiplications, so that at each time step n we sum the contributions from all paths passing through each of the states z nk to give the intermediate quantities α (z n). Next we consider the evaluation of the quantities (z z), which correspond ξ n − 1, n to the values of the conditional probabilities p (z n − 1, z n | X) for each of the K × K settings for (z n − 1, z n). Using the definition of ξ (z n − 1, z n), and applying Bayes' theorem, we have

$$
\text {theorem, we have } &\quad\ p (z _ { n - 1 }, z _ { n }) = p (z _ { n - 1 }, z _ { n } | X)\\ & =\\frac {\ p (X | z _ { n - 1 }, z _ { n }) p (z _ { n - 1 }, z _ { n }) } { p (X) }\\ & =\\frac {\ p (X _ { 1 },\dots, X _ { n - 1 } | z _ { n - 1 }) p (X _ { n } | z _ { n }) p (X _ { n + 1 },\dots, X _ { N } | z _ { n }) p (z _ { n } | z _ { n - 1 }) p (z _ { n - 1 }) } { p (X) }\\ & =\\frac {\alpha (z _ { n - 1 }) p (x _ { n } | z _ { n }) p (z _ { n } | z _ { n - 1 })\beta (z _ { n }) } { p (X) }\\ &\text {where we have made use of the conditional independence property (13 29) together}
$$

where we have made use of the conditional independence property (13.29) together with the definitions of α (z n) and β (z n) given by (13.34) and (13.35). Thus we can calculate the ξ (z n − 1, z n) directly by using the results of the α and β recursions. Let us summarize the steps required to train a hidden Markov model using the EM algorithm. We first make an initial selection of the parameters θ old where θ ≡ (π, A, φ). The A and π parameters are often initialized either uniformly or randomly from a uniform distribution (respecting their non-negativity and summation constraints). Initialization of the parameters φ will depend on the form of the distribution. For instance in the case of Gaussians, the parameters µ k might be initialized by applying the K -means algorithm to the data, and Σ k might be initialized to the covariance matrix of the corresponding K means cluster. Then we run both the forward α recursion and the backward β recursion and use the results to evaluate γ (z n) and ξ (z n − 1, z n). At this stage, we can also evaluate the likelihood function.

