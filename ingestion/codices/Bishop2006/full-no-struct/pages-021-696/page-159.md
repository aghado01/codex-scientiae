[Page 159]

{ j } By using nonlinear basis functions, we allow the function y ( x , w ) to be a nonlinear function of the input vector x . Functions of the form (3.2) are called linear models, however, because this function is linear in w . It is this linearity in the parameters that will greatly simplify the analysis of this class of models. However, it also leads to some signiﬁcant limitations, as we discuss in Section 3.6.

The example of polynomial regression considered in Chapter 1 is a particular example of this model in which there is a single input variable x , and the basis functions take the form of powers of x so that φ j ( x ) = x j . One limitation of polynomial basis functions is that they are global functions of the input variable, so that changes in one region of input space affect all other regions. This can be resolved by dividing the input space up into regions and ﬁt a different polynomial in each region, leading to spline functions (Hastie et al. , 2001).

There are many other possible choices for the basis functions, for example

$$
\phi _ { j } ( x ) = \exp \left \{ - \frac { ( x - \mu _ { j } ) ^ { 2 } } { 2 s ^ { 2 } } \right \} \\
$$

where the µ j govern the locations of the basis functions in input space, and the parameter s governs their spatial scale. These are usually referred to as ‘Gaussian’ basis functions, although it should be noted that they are not required to have a probabilistic interpretation, and in particular the normalization coefﬁcient is unimportant because these basis functions will be multiplied by adaptive parameters w j . Another possibility is the sigmoidal basis function of the form

Another possibility is the sigmoidal basis function of the form

$$
\phi _ { j } ( x ) = \sigma \left ( \frac { x - \mu _ { j } } { s } \right ) \\ \text {stochastic function defined by}
$$

where σ ( a ) is the logistic sigmoid function deﬁned by

$$
\sigma ( a ) = \frac { 1 } { 1 + \exp ( - a ) } . \\
$$

Equivalently, we can use the ‘ tanh ’ function because this is related to the logistic sigmoid by tanh( a ) = 2 σ ( a ) − 1 , and so a general linear combination of logistic sigmoid functions is equivalent to a general linear combination of ‘ tanh ’ functions. These various choices of basis function are illustrated in Figure 3.1.

Yet another possible choice of basis function is the Fourier basis, which leads to an expansion in sinusoidal functions. Each basis function represents a speciﬁc frequency and has inﬁnite spatial extent. By contrast, basis functions that are localized to ﬁnite regions of input space necessarily comprise a spectrum of different spatial frequencies. In many signal processing applications, it is of interest to consider basis functions that are localized in both space and frequency, leading to a class of functions known as wavelets . These are also deﬁned to be mutually orthogonal, to simplify their application. Wavelets are most applicable when the input values live
