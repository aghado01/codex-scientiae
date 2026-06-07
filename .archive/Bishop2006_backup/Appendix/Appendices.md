## Appendix A. Data Sets

In this appendix, we give a brief introduction to the data sets used to illustrate some of the algorithms described in this book. Detailed information on file formats for these data sets, as well as the data files themselves, can be obtained from the book web site:

http://research.microsoft.com/ ∼ cmbishop/PRML

#### Handwritten Digits

The digits data used in this book is taken from the MNIST data set (LeCun et al., 1998), which itself was constructed by modifying a subset of the much larger data set produced by NIST (the National Institute of Standards and Technology). It comprises a training set of 60, 000 examples and a test set of 10, 000 examples. Some of the data was collected from Census Bureau employees and the rest was collected from high-school children, and care was taken to ensure that the test examples were written by different individuals to the training examples.

The original NIST data had binary (black or white) pixels. To create MNIST, these images were size normalized to fit in a 20 × 20 pixel box while preserving their aspect ratio. As a consequence of the anti-aliasing used to change the resolution of the images, the resulting MNIST digits are grey scale. These images were then centred in a 28 × 28 box. Examples of the MNIST digits are shown in Figure A.1. Error rates for classifying the digits range from 12 % for a simple linear classi- fier, through 0. 56 % for a carefully designed support vector machine, to 0. 4 % for a convolutional neural network (LeCun et al., 1998).

Figure A.1 One hundred examples of the MNIST digits chosen at random from the training set.

4 3 1 3 U 7 2 7 | 1? 4 2 } 5 | 2 4 6 3 5 5 6 0 4 | 9 5 0

![image 50](Bishop2006_images/imageFile50.png)

#### Oil Flow

This is a synthetic data set that arose out of a project aimed at measuring noninvasively the proportions of oil, water, and gas in North Sea oil transfer pipelines (Bishop and James, 1993). It is based on the principle of dual-energy gamma densitometry. The ideas is that if a narrow beam of gamma rays is passed through the pipe, the attenuation in the intensity of the beam provides information about the density of material along its path. Thus, for instance, the beam will be attenuated more strongly by oil than by gas.

A single attenuation measurement alone is not sufficient because there are two degrees of freedom corresponding to the fraction of oil and the fraction of water (the fraction of gas is redundant because the three fractions must add to one). To address this, two gamma beams of different energies (in other words different frequencies or wavelengths) are passed through the pipe along the same path, and the attenuation of each is measured. Because the absorbtion properties of different materials vary differently as a function of energy, measurement of the attenuations at the two energies provides two independent pieces of information. Given the known absorbtion properties of oil, water, and gas at the two energies, it is then a simple matter to calculate the average fractions of oil and water (and hence of gas) measured along the path of the gamma beams.

There is a further complication, however, associated with the motion of the materials along the pipe. If the flow velocity is small, then the oil floats on top of the water with the gas sitting above the oil. This is known as a laminar or stratified flow configuration and is illustrated in Figure A.2. As the flow velocity is increased, more complex geometrical configurations of the oil, water, and gas can arise. For the purposes of this data set, two specific idealizations are considered. In the annular configuration the oil, water, and gas form concentric cylinders with the water around the outside and the gas in the centre, whereas in the homogeneous configuration the oil, water and gas are assumed to be intimately mixed as might occur at high flow velocities under turbulent conditions. These configurations are also illustrated in Figure A.2.

Figure A.2 The three geometrical configurations of the oil, water, and gas phases used to generate the oilflow data set. For each configuration, the proportions of the three phases can vary.

![image 336](Bishop2006_images/imageFile336.png)

Figure A.3 Cross section of the pipe showing the arrangement of the six beam lines, each of which comprises a single dualenergy gamma densitometer. Note that the vertical beams are asymmetrically arranged relative to the central axis (shown by the dotted line).

![image 337](Bishop2006_images/imageFile337.png)

For safety reasons, the intensity of the gamma beams is kept relatively weak and so to obtain an accurate measurement of the attenuation, the measured beam intensity is integrated over a specific time interval. For a finite integration time, there are random fluctuations in the measured intensity due to the fact that the gamma beams comprise discrete packets of energy called photons. In practice, the integration time is chosen as a compromise between reducing the noise level (which requires a long integration time) and detecting temporal variations in the flow (which requires a short integration time). The oil flow data set is generated using realistic known values for the absorption properties of oil, water, and gas at the two gamma energies used, and with a specific choice of integration time (10 seconds) chosen as characteristic of a typical practical setup.

Each point in the data set is generated independently using the following steps:

- 1. Choose one of the three phase configurations at random with equal probability.
- 2. Choose three random numbers f 1, f 2 and f 3 from the uniform distribution over (0, 1) and define

$$
f _ { o i l } =\frac { f _ { 1 } } { f _ { 1 } + f _ { 2 } + f _ { 3 } },\quad f _ { w a t e r } =\frac { f _ { 2 } } { f _ { 1 } + f _ { 2 } + f _ { 3 } }.
$$

This treats the three phases on an equal footing and ensures that the volume fractions add to one.

- 3. For each of the six beam lines, calculate the effective path lengths through oil and water for the given phase configuration.
- 4. Perturb the path lengths using the Poisson distribution based on the known beam intensities and integration time to allow for the effect of photon statistics.

Each point in the data set comprises the 12 path length measurements, together with the fractions of oil and water and a binary label describing the phase configuration. The data set is divided into training, validation, and test sets, each of which comprises 1, 000 independent data points. Details of the data format are available from the book web site.

In Bishop and James (1993), statistical machine learning techniques were used to predict the volume fractions and also the geometrical configuration of the phases shown in Figure A.2, from the 12 -dimensional vector of measurements. The 12 dimensional observation vectors can also be used to test data visualization algorithms.

This data set has a rich and interesting structure, as follows. For any given configuration there are two degrees of freedom corresponding to the fractions of oil and water, and so for infinite integration time the data will locally live on a twodimensional manifold. For a finite integration time, the individual data points will be perturbed away from the manifold by the photon noise. In the homogeneous phase configuration, the path lengths in oil and water are linearly related to the fractions of oil and water, and so the data points lie close to a linear manifold. For the annular configuration, the relationship between phase fraction and path length is nonlinear and so the manifold will be nonlinear. In the case of the laminar configuration the situation is even more complex because small variations in the phase fractions can cause one of the horizontal phase boundaries to move across one of the horizontal beam lines leading to a discontinuous jump in the 12 -dimensional observation space. In this way, the two-dimensional nonlinear manifold for the laminar configuration is broken into six distinct segments. Note also that some of the manifolds for different phase configurations meet at specific points, for example if the pipe is filled entirely with oil, it corresponds to specific instances of the laminar, annular, and homogeneous configurations.

#### Old Faithful

Old Faithful, shown in Figure A.4, is a hydrothermal geyser in Yellowstone National Park in the state of Wyoming, U.S.A., and is a popular tourist attraction. Its name stems from the supposed regularity of its eruptions.

The data set comprises 272 observations, each of which represents a single eruption and contains two variables corresponding to the duration in minutes of the eruption, and the time until the next eruption, also in minutes. Figure A.5 shows a plot of the time to the next eruption versus the duration of the eruptions. It can be seen that the time to the next eruption varies considerably, although knowledge of the duration of the current eruption allows it to be predicted more accurately. Note that there exist several other data sets relating to the eruptions of Old Faithful.

Figure A.4 The Old Faithful geyser in Yellowstone National Park. c Bruce T. Gourley www.brucegourley.com.

![image 51](Bishop2006_images/imageFile51.png)

Figure A.5 Plot of the time to the next eruption in minutes (vertical axis) versus the duration of the eruption in minutes (horizontal axis) for the Old Faithful data set.

data set.

![image 339](Bishop2006_images/imageFile339.png)

#### Synthetic Data

Throughout the book, we use two simple synthetic data sets to illustrate many of the algorithms. The first of these is a regression problem, based on the sinusoidal function, shown in Figure A.6. The input values { x n } are generated uniformly in range (0, 1), and the corresponding target values { t n } are obtained by first computing the corresponding values of the function sin(2 πx), and then adding random noise with a Gaussian distribution having standard deviation 0. 3. Various forms of this data set, having different numbers of data points, are used in the book.

The second data set is a classification problem having two classes, with equal prior probabilities, and is shown in Figure A.7. The blue class is generated from a single Gaussian while the red class comes from a mixture of two Gaussians. Because we know the class priors and the class-conditional densities, it is straightforward to evaluate and plot the true posterior probabilities as well as the minimum misclassification-rate decision boundary, as shown in Figure A.7.

1

0

1

0

−1

−1

0

1

0

1

Figure A.6 The left-hand plot shows the synthetic regression data set along with the underlying sinusoidal function from which the data points were generated. The right-hand plot shows the true conditional distribution p (t | x) from which the labels are generated, in which the green curve denotes the mean, and the shaded region spans one standard deviation on each side of the mean.

![image 52](Bishop2006_images/imageFile52.png)

Figure A.7 The left plot shows the synthetic classification data set with data from the two classes shown in red and blue. On the right is a plot of the true posterior probabilities, shown on a colour scale going from pure red denoting probability of the red class is 1 to pure blue denoting probability of the red class is 0. Because these probabilities are known, the optimal decision boundary for minimizing the misclassification rate (which corresponds to the contour along which the posterior probabilities for each class equal 0. 5) can be evaluated and is shown by the green curve. This decision boundary is also plotted on the left-hand figure.

## Appendix B. Probability Distributions

In this appendix, we summarize the main properties of some of the most widely used probability distributions, and for each distribution we list some key statistics such as the expectation E [x], the variance (or covariance), the mode, and the entropy H[x]. All of these distributions are members of the exponential family and are widely used as building blocks for more sophisticated probabilistic models.

#### Bernoulli

This is the distribution for a single binary variable x ∈ { 0, 1 } representing, for example, the result of flipping a coin. It is governed by a single continuous parameter µ ∈ [0, 1] that represents the probability of x = 1.

$$
\ B e r n (x |\mu)\ & =\\mu ^ { x } (1 -\mu) ^ { 1 - x } & & (B. 1)\\\mathbb { F } [x] &\ =\\mu & & (B. 2)
$$

$$
\mathbb { E } [x]\ =\\mu
$$

$$
\ v a r [x]\ =\\mu (1 -\mu) & & (B. 3)\\ & &\\ & (\ 1\\text {if}\\mu > 0\ 5 &
$$

$$
\var { u } [x] &\ =\\mu (1 -\mu)\quad & (B. 3)\\\mod [x] &\ =\\begin{cases}\ 1 &\text {if }\mu\geqslant 0. 5,\\\ 0 &\text {otherwise}\end{cases}\\ H [x] &\ =\ -\mu\ln\mu - (1 -\mu)\ln (1 -\mu).
$$

$$
H [x]\ =\ -\mu\ln\mu - (1 -\mu)\ln (1 -\mu).
$$

The Bernoulli is a special case of the binomial distribution for the case of a single observation. Its conjugate prior for µ is the beta distribution.

![image 342](Bishop2006_images/imageFile342.png)

#### Beta

This is a distribution over a continuous variable µ ∈ [0, 1], which is often used to represent the probability for some binary event. It is governed by two parameters a and b that are constrained by a > 0 and b > 0 to ensure that the distribution can be normalized.

$$
\ B e t a (\mu | a, b)\ =\\frac {\Gamma (a + b) } {\Gamma (a)\Gamma (b) }\mu ^ { a - 1 } (1 -\mu) ^ { b - 1 } & & (B. 6)
$$

$$
\mathbb { E } [\mu]\ =\\frac { a } { a + b } & & (B. 7)
$$

$$
\var { v } [\mu]\ =\\frac { a b } { (a + b) ^ { 2 } (a + b + 1) }
$$

$$
\mod [\mu]\ =\\frac { a - 1 } { a + b - 2 }.\\\intertext { t h e c h i g u a t e r $ p r i o n $ f o r $ t h e R e p o u l l i $ d i r b u t i o n $ f o r $ w h i c h a $ a $ d h e $ c a n $ }
$$

The beta is the conjugate prior for the Bernoulli distribution, for which a and b can be interpreted as the effective prior number of observations of x = 1 and x = 0, respectively. Its density is finite if a 1 and b 1, otherwise there is a singularity at µ = 0 and/or µ = 1. For a = b = 1, it reduces to a uniform distribution. The beta distribution is a special case of the K -state Dirichlet distribution for K = 2.

![image 343](Bishop2006_images/imageFile343.png)

#### Binomial

The binomial distribution gives the probability of observing m occurrences of x = 1 in a set of N samples from a Bernoulli distribution, where the probability of observing x = 1 is µ ∈ [0, 1].

$$
\i s\,\mu\subset [0, 1].\\\quad\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
$$

$$
\mathbb { E } [m]\ =\ N\mu
$$

$$
\begin{array} { c c c }\text {var} [m] & = & N\mu (1 -\mu) & & (B. 1 2)\\\\\text {mode} [m] & = & |\left (N + 1\right)\mu | & & (B. 1 3)\end{array}
$$

$$
\mod [m]\ =\\lfloor (N + 1)\mu\rfloor
$$

where (N + 1) µ denotes the largest integer that is less than or equal to (N + 1) µ, and the quantity

$$
\begin{pmatrix} N\\ m\end{pmatrix} =\frac { N! } { m! (N - m)! } & (B. 1 4)\\\text {of ways of choosing $m$ objects out of a total of $N$ identical}
$$

denotes the number of ways of choosing m objects out of a total of N identical objects. Here m!, pronounced 'factorial m ', denotes the product m × (m − 1) ×..., × 2 × 1. The particular case of the binomial distribution for N = 1 is known as the Bernoulli distribution, and for large N the binomial distribution is approximately Gaussian. The conjugate prior for µ is the beta distribution.

![image 53](Bishop2006_images/imageFile53.png)

#### Dirichlet

The Dirichlet is a multivariate distribution over K random variables 0 µ k 1, where k = 1,...,K, subject to the constraints

$$
0\leqslant\mu _ { k }\leqslant 1,\quad\sum _ { k = 1 } ^ { K }\mu _ { k } = 1.\\
$$

Denoting µ = (µ 1,...,µ K) T and α = (α 1,...,α K) T, we have

$$
D i r (\mu |\alpha)\ =\ C (\alpha)\prod _ { k = 1 } ^ { K }\mu _ { k } ^ {\alpha _ { k } - 1 }\\\mathbb { E } [\mu _ { k }]\ =\\frac {\alpha _ { k } } {\alpha }\,\Lambda _ { k }
$$

$$
\mathbb { E } [\mu _ { k }]\ =\\frac {\alpha _ { k } } {\widehat {\alpha } }\sum _ {\substack { (\widehat {\alpha })\\ (\widehat {\beta }) } } ^ {\infty }\,\Omega (1 - 1)
$$

$$
\mathbb { E } [\mu _ { k }]\ & =\\frac {\alpha _ { k } } {\widehat {\alpha } }\\\quad &\quad\\varbar {\alpha } [\mu _ { k }]\ =\\frac {\alpha _ { k } (\widehat {\alpha } -\alpha _ { k }) } {\widehat {\alpha } ^ { 2 } (\widehat {\alpha } + 1) }\\\quad &\quad\\cot [\mu _ { j }\mu _ { k }]\ =\ -\frac {\alpha _ { j }\alpha _ { k } } {\widehat {\alpha } ^ { 2 } (\widehat {\alpha } + 1) }
$$

$$
\var { r } [\mu _ { k }] & =\\frac {\alpha ^ { k } (\alpha ^ {\sigma } +\alpha ^ { k }) } {\widehat {\alpha } ^ { 2 } (\widehat {\alpha } + 1) }\\\cot [\mu _ { j }\mu _ { k }] & =\ -\frac {\alpha _ { j }\alpha _ { k } } {\widehat {\alpha } ^ { 2 } (\widehat {\alpha } + 1) }\\ & =\\alpha _ { k } - 1
$$

$$
\begin{array} { l c l } & &\text {cov} [\mu _ { j }\mu _ { k }] & = & -\frac { } {\widehat {\alpha } ^ { 2 } (\widehat {\alpha } + 1) }\\ & &\\ &\text {mode} [\mu _ { k }] & = &\frac {\alpha _ { k } - 1 } {\widehat {\alpha } - K }\\ & &\mathbb { E } [\ln\mu _ { k }] & = &\psi (\alpha _ { k }) -\psi (\widehat {\alpha })\end{array}\quad (B. 1)
$$

$$
\mod [\mu _ { k }]\ & =\\frac {\alpha ^ { k } } {\widehat {\alpha } - K }\\\mathbb { E } [\ln\mu _ { k }]\ & =\\psi (\alpha _ { k }) -\psi (\widehat {\alpha })\\\\ H [\mu]\ & =\ -\sum _ { k } ^ { K } (\alpha _ { k } - 1)\left\{\psi (\alpha _ { k }) -\psi (\widehat {\alpha })\right\} -\ln C (\alpha)
$$

$$
\mathbb { E } [\ln\mu _ { k }]\ & =\\psi (\alpha _ { k }) -\psi (\widehat {\alpha })\\ H [\mu]\ & =\ -\sum _ { k = 1 } ^ { K } (\alpha _ { k } - 1)\left\{\psi (\alpha _ { k }) -\psi (\widehat {\alpha })\right\} -\ln C (\alpha)\\\intertext { r e } C (\alpha _ { k }) -\intertext { s u p l a r }\mathbb { E } (B)
$$

where

$$
C (\alpha) =\frac {\Gamma (\widehat {\alpha }) } {\Gamma (\alpha _ { 1 })\cdots\Gamma (\alpha _ { K }) } & & (B. 2 3)\\
$$

and

$$
\widehat {\alpha } =\sum _ { k = 1 } ^ { K }\alpha _ { k }.\\\\\psi (a) =\frac { d } { }\ln\Gamma (a)
$$

Here

$$
\psi (a) &\equiv\frac { d } { d a }\ln\Gamma (a) & (B. 2 5)\\
$$

is known as the digamma function (Abramowitz and Stegun, 1965). The parameters α k are subject to the constraint α k > 0 in order to ensure that the distribution can be normalized.

The Dirichlet forms the conjugate prior for the multinomial distribution and represents a generalization of the beta distribution. In this case, the parameters α k can be interpreted as effective numbers of observations of the corresponding values of the K -dimensional binary observation vector x. As with the beta distribution, the Dirichlet has finite density everywhere provided α k 1 for all k.

![image 345](Bishop2006_images/imageFile345.png)

#### Gamma

The Gamma is a probability distribution over a positive random variable τ > 0 governed by parameters a and b that are subject to the constraints a > 0 and b > 0 to ensure that the distribution can be normalized.

$$
\ G a m (\tau | a, b)\ =\\frac { 1 } {\Gamma (a) } b ^ { a }\tau ^ { a - 1 } e ^ { - b\tau } & & (B. 2 6)
$$

$$
\mathbb { E } [\tau]\ =\\frac { a } {\bar { b } }\quad & &\quad (B. 2 7)
$$

$$
\var { v } [\tau]\ =\\frac { a } { b ^ { 2 } } & & (B. 2 8)
$$

$$
\mod [\tau]\ =\\frac { a - 1 } { b }\quad\text {for }\alpha\geqslant 1\\\mod [\tau]\ =\\frac { a - 1 } { b }\quad\text {for }\alpha\geqslant 1
$$

$$
\mathbb { E } [\ln\tau]\ & =\\psi (a) -\ln b & (B. 3 0)\\\mathbb { H } [\tau]\ & =\\ln\Gamma (a) = (a - 1) v (a) -\ln b + a & (B. 3 1)
$$

$$
H [\tau]\ =\\ln\Gamma (a) - (a - 1)\psi (a) -\ln b + a
$$

where ψ (·) is the digamma function defined by (B.25). The gamma distribution is the conjugate prior for the precision (inverse variance) of a univariate Gaussian. For a 1 the density is everywhere finite, and the special case of a = 1 is known as the exponential distribution.

![image 346](Bishop2006_images/imageFile346.png)

#### Gaussian

The Gaussian is the most widely used distribution for continuous variables. It is also known as the normal distribution. In the case of a single variable x ∈ (−∞, ∞) it is governed by two parameters, the mean µ ∈ (−∞, ∞) and the variance σ 2 > 0.

$$
\mathcal { N } (x |\mu,\sigma ^ { 2 })\ =\\frac { 1 } { (2\pi\sigma ^ { 2 }) ^ { 1 / 2 } }\exp\left\{ -\frac { 1 } { 2\sigma ^ { 2 } } (x -\mu) ^ { 2 }\right\}\\\mathbb { E } [x]\ =\\mu
$$

$$
\mathbb { E } [x]\ =\\mu
$$

$$
\ v a r [x]\ =\\sigma ^ { 2 }
$$

$$
\mod [x]\ =\\mu
$$

$$
H [x]\ =\\frac { 1 } { 2 }\ln\sigma ^ { 2 } +\frac { 1 } { 2 }\left (1 +\ln (2\pi)\right).
$$

The inverse of the variance τ = 1 /σ 2 is called the precision, and the square root of the variance σ is called the standard deviation. The conjugate prior for µ is the Gaussian, and the conjugate prior for τ is the gamma distribution. If both µ and τ are unknown, their joint conjugate prior is the Gaussian-gamma distribution.

For a D -dimensional vector x, the Gaussian is governed by a D -dimensional mean vector µ and a D × D covariance matrix Σ that must be symmetric and

$$
\text {positive-demin.}\\\mathcal { N } (x |\mu,\Sigma)\ =\\frac { 1 } { (2\pi) ^ { D / 2 } }\frac { 1 } { |\Sigma | ^ { 1 / 2 } }\exp\left\{ -\frac { 1 } { 2 } (x -\mu) ^ { T }\Sigma ^ { - 1 } (x -\mu)\right\} (B. 3 7)\\\mathbb { E } [x]\ =\\mu
$$

$$
\mathbb { E } [x]\ =\\mu
$$

$$
c o v [x]\ =\\Sigma
$$

$$
\mod [x]\ =\\mu
$$

$$
H [x]\ =\\frac { 1 } { 2 }\ln |\Sigma | +\frac { D } { 2 }\left (1 +\ln (2\pi)\right).
$$

The inverse of the covariance matrix Λ = Σ − 1 is the precision matrix, which is also symmetric and positive definite. Averages of random variables tend to a Gaussian, by the central limit theorem, and the sum of two Gaussian variables is again Gaussian. The Gaussian is the distribution that maximizes the entropy for a given variance (or covariance). Any linear transformation of a Gaussian random variable is again Gaussian. The marginal distribution of a multivariate Gaussian with respect to a subset of the variables is itself Gaussian, and similarly the conditional distribution is also Gaussian. The conjugate prior for µ is the Gaussian, the conjugate prior for Λ is the Wishart, and the conjugate prior for (µ, Λ) is the Gaussian-Wishart.

If we have a marginal Gaussian distribution for x and a conditional Gaussian distribution for y given x in the form

$$
\begin{array} { c c c } p (x) & = &\mathcal { N } (x |\mu,\Lambda ^ { - 1 }) & & (B. 4 2)\\ p (x | x) & = &\mathcal { N } (x | A x + b\ L ^ { - 1 }) & & (B. 4 3)\end{array}
$$

$$
p (y | x)\ =\\mathcal { N } (y | A x + b, L ^ { - 1 })\\\\\ t w _ { 0 }\ t w _ { 1 } =\\mathcal { N } (y | A x + b, L ^ { - 1 })
$$

then the marginal distribution of y, and the conditional distribution of x given y, are given by

$$
\begin{array} { r c l } p (y) & = &\mathcal { N } (y | A\mu + b, L ^ { - 1 } + A\Lambda ^ { - 1 } A ^ { T })\\ p (x | y) & = &\mathcal { N } (x |\Sigma\{ A ^ { T } L (y - b) +\Lambda\mu\}\\Sigma)\end{array}
$$

$$
p (x | y)\ =\\mathcal { N } (x |\Sigma\{ A ^ {\top } L (y - b) +\Lambda\mu\},\Sigma)
$$

where

$$
\Sigma = (\Lambda + A ^ { T } L A) ^ { - 1 }.
$$

If we have a joint Gaussian distribution N (x | µ, Σ) with Λ ≡ Σ − 1 and we define the following partitions

$$
x & =\begin{pmatrix} x _ { a }\\ x _ { b }\end{pmatrix},\quad\mu =\begin{pmatrix}\mu _ { a }\\\mu _ { b }\end{pmatrix}\\
$$

$$
\Sigma =\begin{pmatrix}\Sigma _ { a a } &\Sigma _ { a b }\\\Sigma _ { b a } &\Sigma _ { b b }\end{pmatrix},\quad\Lambda =\begin{pmatrix}\Lambda _ { a a } &\Lambda _ { a b }\\\Lambda _ { b a } &\Lambda _ { b b }\end{pmatrix}\\\text {conditional distribution}\, p (x _ { a } | x _ { b })\,\text {is given by}
$$

then the conditional distribution p (x a | x b) is given by 1

$$
p (x _ { a } | x _ { b })\ =\\mathcal { N } (x |\mu _ { a | b },\Lambda _ { a a } ^ { - 1 })\\\\
$$

$$
\mu _ { a | b }\ =\\mu _ { a } -\Lambda _ { a a } ^ { - 1 }\Lambda _ { a b } (x _ { b } -\mu _ { b })
$$

and the marginal distribution p (x a) is given by

$$
p (\mathbf x _ { a }) =\mathcal { N } (\mathbf x _ { a } |\mu _ { a },\Sigma _ { a a }).
$$

![image 347](Bishop2006_images/imageFile347.png)

#### Gaussian-Gamma

This is the conjugate prior distribution for a univariate Gaussian N (x | µ,λ − 1) in which the mean µ and the precision λ are both unknown and is also called the normal-gamma distribution. It comprises the product of a Gaussian distribution for µ, whose precision is proportional to λ, and a gamma distribution over λ.

$$
\mu,\text { whose precision is }\beta\text { pointon}\lambda\,\sigma,\,\alpha\text { and } a\,\text { gamin}\,\delta\text {union}\, 0\,\text { over}\,\chi\,.\\ p (\mu,\lambda |\mu _ { 0 },\beta, a, b) =\mathcal { N }\left (\mu |\mu _ { o }, (\beta\lambda) ^ { - 1 }\right)\text { Gam} (\lambda | a, b).
$$

#### Gaussian-Wishart

This is the conjugate prior distribution for a multivariate Gaussian N (x | µ, Λ) in which both the mean µ and the precision Λ are unknown, and is also called the normal-Wishart distribution. It comprises the product of a Gaussian distribution for µ, whose precision is proportional to Λ, and a Wishart distribution over Λ.

$$
\mu,\text { whose precision is }\rho\text { or than }\mathcal { N },\text { and }\mathbf A\text { is }\mathbf A\text { is }\mathbf A\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A\,\mathbf A
$$

For the particular case of a scalar x, this is equivalent to the Gaussian-gamma distribution.

#### Multinomial

If we generalize the Bernoulli distribution to an K -dimensional binary variable x with components x k ∈ { 0, 1 } such that k x k = 1, then we obtain the following discrete distribution K

$$
p (x)\ & =\\prod _ { k = 1 } ^ { K }\mu _ { k } ^ { x _ { k } } & & (B. 5 4)\\\mathbb { E } [x _ { k }] &\ =\\mu _ { k } & & (B. 5 5)
$$

$$
\mathbb { E } [x _ { k }]\ =\\mu _ { k }
$$

$$
\var { v } [x _ { k }] &\ =\\mu _ { k } (1 -\mu _ { k }) & & (B. 5 6)\\\cot [x _ { i } - x _ { j }] &\ =\ I _ { i }\cdot\mu _ { i } & & (B. 5 7)
$$

$$
c o v [x _ { j } x _ { k }]\ =\ I _ { j k }\mu _ { k }
$$

$$
H [x]\ =\ -\sum _ { k = 1 } ^ { M }\mu _ { k }\ln\mu _ { k }
$$

where I jk is the j,k element of the identity matrix. Because p (x k = 1) = µ k, the parameters must satisfy 0 µ k 1 and k µ k = 1. The multinomial distribution is a multivariate generalization of the binomial and gives the distribution over counts m k for a K -state discrete variable to be in state k given a total number of observations N.

$$
\ n _ { K } |\mu, N)\ =\\begin{pmatrix} N\\ m _ { 1 } m _ { 2 }\dots m _ { M }\end{pmatrix}\prod _ { k = 1 } ^ { M }\mu _ { k } ^ { m _ { k } }\quad (B. 5 9)\\\mathbb { E } [m _ { k }]\ =\ N\mu _ { k }\\\text {var} [m _ { k }]\ =\ N\mu _ { k } (1 -\mu _ { k })\\\text {ov} [m _ { j } m _ { k }]\ =\ - N\mu _ { j }\mu _ { k }\end{pmatrix}
$$

$$
M u l t (m _ { 1 }, m _ { 2 },\dots, m _ { K } |\mu, N)\ =\\binom { N } { m _ { 1 } m _ { 2 }\dots m _ { M } }\prod _ { k = 1 } ^ { M }\mu _ { k } ^ { m _ { k } }\\ (B. 5 9)
$$

$$
\mathbb { E } [m _ { k }]\ =\ N\mu _ { k }
$$

$$
\ v a r [m _ { k }]\ =\ N\mu _ { k } (1 -\mu _ { k })
$$

$$
c o v [m _ { j } m _ { k }]\ =\ - N\mu _ { j }\mu _ { k }
$$

where µ = (µ 1,...,µ K) T, and the quantity

$$
0,\frac { N } { m _ { 1 } m _ { 2 }\dots m _ { K } }) =\frac { N! } { m _ { 1 }!\dots m _ { K }! }
$$

gives the number of ways of taking N identical objects and assigning m k of them to bin k for k = 1,...,K. The value of µ k gives the probability of the random variable taking state k, and so these parameters are subject to the constraints 0 µ k 1 and k µ k = 1. The conjugate prior distribution for the parameters { µ k } is the Dirichlet.

#### Normal

The normal distribution is simply another name for the Gaussian. In this book, we use the term Gaussian throughout, although we retain the conventional use of the symbol N to denote this distribution. For consistency, we shall refer to the normalgamma distribution as the Gaussian-gamma distribution, and similarly the normalWishart is called the Gaussian-Wishart.

![image 348](Bishop2006_images/imageFile348.png)

#### Student's t

This distribution was published by William Gosset in 1908, but his employer, Guiness Breweries, required him to publish under a pseudonym, so he chose 'Student'. In the univariate form, Student's t-distribution is obtained by placing a conjugate gamma prior over the precision of a univariate Gaussian distribution and then integrating out the precision variable. It can therefore be viewed as an infinite mixture

$$
S t (x |\mu,\lambda,\nu)\ =\\frac {\Gamma (\nu / 2 + 1 / 2) } {\Gamma (\nu / 2) }\left (\frac {\lambda } {\pi\nu }\right) ^ { 1 / 2 }\left [1 +\frac {\lambda (x -\mu) ^ { 2 } } {\nu }\right] ^ { -\nu / 2 - 1 / 2 }\quad (B. 6 4)\\\mathbb { E } [x]\ =\\mu\quad\text {for }\nu > 1
$$

$$
\mathbb { E } [x]\ =\\mu\quad\text {for }\nu > 1
$$

$$
[] & =\frac { 1 } {\lambda }\frac {\nu } {\nu - 2 }\quad\text {for }\nu > 2\\\text {mode} [x] &\ =\\mu.
$$

$$
\mod [x]\ =\\mu.
$$

Here ν > 0 is called the number of degrees of freedom of the distribution. The particular case of ν = 1 is called the Cauchy distribution.

For a D -dimensional variable x, Student's t-distribution corresponds to marginalizing the precision matrix of a multivariate Gaussian with respect to a conjugate Wishart prior and takes the form

$$
S t (x |\mu,\Lambda,\nu)\ & =\\frac {\Gamma (\nu / 2 + D / 2) } {\Gamma (\nu / 2) }\frac { |\Lambda | ^ { 1 / 2 } } { (\nu\pi) ^ { D / 2 } }\left [1 +\frac {\Delta ^ { 2 } } {\nu }\right] ^ { -\nu / 2 - D / 2 }\\\mathbb { E } [x] &\ =\\mu\quad\text {for }\nu > 1
$$

$$
\mathbb { E } [x]\ =\\mu\quad\text {for }\nu > 1
$$

$$
\mathbb { E } [x] & =\mu ^ {\nu }\text { for }\nu > 1\\\text {cov} [x] & =\frac {\nu } {\nu - 2 }\Lambda ^ { - 1 }\quad\text {for }\nu > 2\\\text {mode} [x] & =\mu
$$

$$
\mod [x]\ =\\mu
$$

where ∆ 2 is the squared Mahalanobis distance defined by

$$
\Delta ^ { 2 } = (x -\mu) ^ {\text {T} }\Lambda (x -\mu).
$$

In the limit ν → ∞, the t-distribution reduces to a Gaussian with mean µ and precision Λ. Student's t-distribution provides a generalization of the Gaussian whose maximum likelihood parameter values are robust to outliers.

![image 349](Bishop2006_images/imageFile349.png)

#### Uniform

This is a simple distribution for a continuous variable x defined over a finite interval x ∈ [a,b] where b > a.

$$
U (x | a, b)\ =\\frac { 1 } { b - a } & & (B. 7 3)\\\mathbb { F } [a] & & (b + a)
$$

$$
\mathbb { E } [x]\ =\\frac { (b + a) } { 2 }\quad\\
$$

$$
\var { v } [x]\ =\\frac { (b - a) ^ { 2 } } { 1 2 } & & (B. 7 5)\\
$$

$$
H [x]\ =\\ln (b - a).
$$

If x has distribution U(x | 0, 1), then a + (b − a) x will have distribution U(x | a,b).

![image 350](Bishop2006_images/imageFile350.png)

#### Von Mises

The von Mises distribution, also known as the circular normal or the circular Gaussian, is a univariate Gaussian-like periodic distribution for a variable θ ∈ [0, 2 π).

$$
p (\theta |\theta _ { 0 }, m)\ =\\frac { 1 } { 2\pi I _ { 0 } (m) }\exp\left\{ m\cos (\theta -\theta _ { 0 })\right\}
$$

where I 0 (m) is the zeroth-order Bessel function of the first kind. The distribution has period 2 π so that p (θ + 2 π) = p (θ) for all θ. Care must be taken in interpreting this distribution because simple expectations will be dependent on the (arbitrary) choice of origin for the variable θ. The parameter θ 0 is analogous to the mean of a univariate Gaussian, and the parameter m > 0, known as the concentration parameter, is analogous to the precision (inverse variance). For large m, the von Mises distribution is approximately a Gaussian centred on θ 0.

#### Wishart

The Wishart distribution is the conjugate prior for the precision matrix of a multivariate Gaussian.

$$
\text {variate Gaussian}.\\\mathcal { W } (\Lambda | W,\nu) = B (W,\nu) |\Lambda | ^ { (\nu - D - 1) / 2 }\exp\left (-\frac { 1 } { 2 } T r (W ^ { - 1 }\Lambda)\right)\\
$$

where

))

((

-

1

∏

- ν

-

-

- ν/ νD/ 2

/

2

2 (

1.

4

≡

|

|

2 π

Γ (

,ν)

)

(B.79)

2

=1

$$
\mathbb { E } [\Lambda]\ =\\nu W
$$

$$
\mathbb { E } [\Lambda]\ & =\\nu W\\\mathbb { E }\left [\ln |\Lambda |\right]\ & =\\sum _ { i = 1 } ^ { D }\psi\left (\frac {\nu + 1 - i } { 2 }\right) + D\ln 2 +\ln | W |\\\\ H [\Lambda]\ & =\\sum _ { i = 1 } ^ { D } B (W _ { i }\,\mu)\,\frac { (\nu - D - 1) } { }\mathbb { F }\left [\ln |\Lambda |\right] +\frac {\nu D } { }\\
$$

$$
H [\Lambda]\ =\ -\ln B (W,\nu) -\frac { (\nu - D - 1) } { 2 }\mathbb { E }\left [\ln |\Lambda |\right] +\frac {\nu D } { 2 }\quad (B. 8 2)
$$

where W is a D × D symmetric, positive definite matrix, and ψ (·) is the digamma function defined by (B.25). The parameter ν is called the number of degrees of freedom of the distribution and is restricted to ν > D − 1 to ensure that the Gamma function in the normalization factor is well-defined. In one dimension, the Wishart reduces to the gamma distribution Gam(λ | a,b) given by (B.26) with parameters a = ν/ 2 and b = 1 / 2 W.

## Appendix C. Properties of Matrices

In this appendix, we gather together some useful properties and identities involving matrices and determinants. This is not intended to be an introductory tutorial, and it is assumed that the reader is already familiar with basic linear algebra. For some results, we indicate how to prove them, whereas in more complex cases we leave the interested reader to refer to standard textbooks on the subject. In all cases, we assume that inverses exist and that matrix dimensions are such that the formulae are correctly defined. A comprehensive discussion of linear algebra can be found in Golub and Van Loan (1996), and an extensive collection of matrix properties is given by L¨ utkepohl (1996). Matrix derivatives are discussed in Magnus and Neudecker (1999).

#### Basic Matrix Identities

A matrix A has elements A ij where i indexes the rows, and j indexes the columns. We use I N to denote the N × N identity matrix (also called the unit matrix), and where there is no ambiguity over dimensionality we simply use I. The transpose matrix A T has elements (A T) ij = A ji. From the definition of transpose, we have

$$
(A B) ^ { T } = B ^ { T } A ^ { T }
$$

which can be verified by writing out the indices. The inverse of A, denoted A − 1, satisfies 1 1

$$
A A ^ { - 1 } = A ^ { - 1 } A = I.
$$

Because ABB − 1 A − 1 = I, we have

$$
(A B) ^ { - 1 } = B ^ { - 1 } A ^ { - 1 }.
$$

Also we have which is easily proven by taking the transpose of (C.2) and applying (C.1).

$$
(A ^ { T }) ^ { - 1 } = (A ^ { - 1 }) ^ { T } & & (C. 4)
$$

A useful identity involving matrix inverses is the following

$$
(P ^ { - 1 } + B ^ { T } R ^ { - 1 } B) ^ { - 1 } B ^ { T } R ^ { - 1 } = P B ^ { T } (B P B ^ { T } + R) ^ { - 1 }.\quad (C. 5)
$$

which is easily verified by right multiplying both sides by (BPB T + R). Suppose that P has dimensionality N × N while R has dimensionality M × M, so that B is M × N. Then if M N, it will be much cheaper to evaluate the right-hand side of (C.5) than the left-hand side. A special case that sometimes arises is

$$
(I + A B) ^ { - 1 } A = A (I + B A) ^ { - 1 }. & & (C. 6)
$$

Another useful identity involving inverses is the following:

$$
(A + B D ^ { - 1 } C) ^ { - 1 } = A ^ { - 1 } - A ^ { - 1 } B (D + C A ^ { - 1 } B) ^ { - 1 } C A ^ { - 1 }\quad (C. 7)
$$

which is known as the Woodbury identity and which can be verified by multiplying both sides by (A + BD − 1 C). This is useful, for instance, when A is large and diagonal, and hence easy to invert, while B has many rows but few columns (and conversely for C) so that the right-hand side is much cheaper to evaluate than the left-hand side.

A set of vectors { a 1,..., a N } is said to be linearly independent if the relation n α n a n = 0 holds only if all α n = 0. This implies that none of the vectors can be expressed as a linear combination of the remainder. The rank of a matrix is the maximum number of linearly independent rows (or equivalently the maximum number of linearly independent columns).

#### Traces and Determinants

Trace and determinant apply to square matrices. The trace Tr (A) of a matrix A is defined as the sum of the elements on the leading diagonal. By writing out the indices, we see that

$$
T r (A B) = T r (B A).
$$

By applying this formula multiple times to the product of three matrices, we see that

$$
T r (A B C) = T r (C A B) = T r (B C A)
$$

which is known as the cyclic property of the trace operator and which clearly extends to the product of any number of matrices. The determinant | A | of an N × N matrix A is defined by

$$
| A | =\sum (\pm 1) A _ { 1 i _ { 1 } } A _ { 2 i _ { 2 } }\cdots A _ { N i _ { N } } & & (C. 1 0)\\\intertext { y } | A | =\sum (\pm 1) A _ { 1 i _ { 1 } } A _ { 2 i _ { 2 } }\cdots A _ { N i _ { N } } & & (C. 1 0)\\\intertext { u n }\intertext { i n s t a k e n o v e r a l l }\intertext { o r s i n t i o n s i s t i n g o f p r e c i l y }\intertext { e n t e n g e f r o w s }\intertext { e q n o w s }
$$

in which the sum is taken over all products consisting of precisely one element from each row and one element from each column, with a coefficient +1 or − 1 according to whether the permutation i 1 i 2...i N is even or odd, respectively. Note that | I | = 1. Thus, for a 2 × 2 matrix, the determinant takes the form

$$
2\times 2\,\text {matrix},\,\text {the determinant takes the form}\\ | A | =\left |\begin{array} { c c } a _ { 1 1 } & a _ { 1 2 }\\ a _ { 2 1 } & a _ { 2 2 }\end{array}\right | = a _ { 1 1 } a _ { 2 2 } - a _ { 1 2 } a _ { 2 1 }.\\\intertext { t e r\minant a\,\text {product of two matrices is given by}\\ | A | = | A | - | A | | B |
$$

The determinant of a product of two matrices is given by

$$
| A B | = | A | | B |
$$

as can be shown from (C.10). Also, the determinant of an inverse matrix is given by

$$
| A ^ { - 1 } | & =\frac { 1 } { | A | }\\\intertext { k i n g the d e r t e m i n a n t o r $ (C. 2) $ a n d a p l y i n g $ (C. 1 2). }\text {es of size } N\times N\\nearrow\\text {then}
$$

which can be shown by taking the determinant of (C.2) and applying (C.12).

If A and B are matrices of size N × M, then

$$
a\ m a t h s c r { I } _ { N } + A B ^ { T } | & = | I _ { M } + A ^ { T } B |.\\\intertext { a n d }\left | I _ { N } + a b ^ { T }\right | & = 1 + a ^ { T } b
$$

A useful special case is

$$
\begin{array} { c | c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c
$$

    where a and b are N -dimensional column vectors.

#### Matrix Derivatives

Sometimes we need to consider derivatives of vectors and matrices with respect to scalars. The derivative of a vector a with respect to a scalar x is itself a vector whose components are given by

$$
\left (\frac {\partial a } {\partial x }\right) _ { i } =\frac {\partial a _ { i } } {\partial x } & & (C. 1 6)\\\text {ion for the derivative of a matrix. Derivatives with respect}
$$

with an analogous definition for the derivative of a matrix. Derivatives with respect to vectors and matrices can also be defined, for instance

$$
\left (\frac {\partial x } {\partial a }\right) _ { i } =\frac {\partial x } {\partial a _ { i } }
$$

and similarly

$$
\left (\frac {\partial a } {\partial b }\right) _ { i j } =\frac {\partial a _ { i } } {\partial b _ { j } }.\\\text {widely proven by writing out the components}
$$

The following is easily proven by writing out the components

$$
\frac {\partial } {\partial x }\left (x ^ { T } a\right) =\frac {\partial } {\partial x }\left (a ^ { T } x\right) = a.
$$

Similarly

$$
\frac {\partial } {\partial x }\left (A B\right) =\frac {\partial A } {\partial x } B + A\frac {\partial B } {\partial x }.
$$

The derivative of the inverse of a matrix can be expressed as

$$
\frac {\partial } {\partial x }\left (A ^ { - 1 }\right) = - A ^ { - 1 }\frac {\partial A } {\partial x } A ^ { - 1 } & & (C. 2 1)\\\intertext { b y d i f f e r e n t i a g t i n g t h e q u a t i o n A ^ { - 1 } A = I\, u s i g (C. 2 0)\, a n d\, t h e r }
$$

as can be shown by differentiating the equation A − 1 A = I using (C.20) and then right multiplying by A − 1. Also

$$
\frac {\partial } {\partial x }\ln | A | =\text {Tr}\left (A ^ { - 1 }\frac {\partial A } {\partial x }\right)\\\intertext { w h e r e }\intertext { s u n t h e f w h e r e }
$$

which we shall prove later. If we choose x to be one of the elements of A, we have

$$
\frac {\partial } {\partial A _ { i j } }\text {Tr}\left (A B\right) = B _ { j i }
$$

as can be seen by writing out the matrices using index notation. We can write this result more compactly in the form

$$
\frac {\partial } {\partial A } T r\left (A B\right) = B ^ { T }.
$$

With this notation, we have the following properties

$$
\frac {\partial } {\partial A }\text {Tr}\left (A ^ {\top } B\right)\ =\ B & & (C. 2 5)\\\frac {\partial } {\partial A }\text {Tr} (A)\ =\ I & & (C. 2 6)
$$

$$
\int _ { 0 } ^ {\infty }\frac {\partial } {\partial A } T r (A)\ =\ I
$$

$$
\frac {\partial } {\partial A } T r (A B A ^ { T })\ =\ A (B + B ^ { T })
$$

which can again be proven by writing out the matrix indices. We also have

$$
\frac {\partial } {\partial A }\ln | A | =\left (A ^ { - 1 }\right) ^ { T }\\ C. 2 2)\text { and } (C. 2 6).
$$

which follows from (C.22) and (C.26).

#### Eigenvector Equation

For a square matrix A of size M × M, the eigenvector equation is defined by

$$
A u _ { i } =\lambda _ { i } u _ { i }
$$

for i = 1,...,M, where u i is an eigenvector and λ i is the corresponding eigenvalue. This can be viewed as a set of M simultaneous homogeneous linear equations, and the condition for a solution is that

$$
| A -\lambda _ { i } I | = 0
$$

which is known as the characteristic equation. Because this is a polynomial of order M in λ i, it must have M solutions (though these need not all be distinct). The rank of A is equal to the number of nonzero eigenvalues.

Of particular interest are symmetric matrices, which arise as covariance matrices, kernel matrices, and Hessians. Symmetric matrices have the property that A ij = A ji, or equivalently A T = A. The inverse of a symmetric matrix is also symmetric, as can be seen by taking the transpose of A − 1 A = I and using AA − 1 = I together with the symmetry of I.

In general, the eigenvalues of a matrix are complex numbers, but for symmetric matrices the eigenvalues λ i are real. This can be seen by first left multiplying (C.29) by (u i) T, where denotes the complex conjugate, to give

$$
(u _ { i } ^ { * }) ^ { T }\, A u _ { i } =\lambda _ { i }\, (u _ { i } ^ { * }) ^ { T }\, u _ { i }.
$$

Next we take the complex conjugate of (C.29) and left multiply by u T i to give

$$
u _ { i } ^ {\top } A u _ { i } ^ { * } =\lambda _ { i } ^ { * } u _ { i } ^ {\top } u _ { i } ^ { * }.
$$

where we have used A = A because we consider only real matrices A. Taking the transpose of the second of these equations, and using A T = A, we see that the left-hand sides of the two equations are equal, and hence that λ i = λ i and so λ i must be real.

The eigenvectors u i of a real symmetric matrix can be chosen to be orthonormal (i.e., orthogonal and of unit length) so that

$$
u _ { i } ^ { T } u _ { j } = I _ { i j }
$$

where I ij are the elements of the identity matrix I. To show this, we first left multiply (C.29) by u T j to give T T

$$
u _ { j } ^ { T } A u _ { i } =\lambda _ { i } u _ { j } ^ { T } u _ { i }
$$

and hence, by exchange of indices, we have

$$
u _ { i } ^ { T } A u _ { j } =\lambda _ { j } u _ { i } ^ { T } u _ { j }.
$$

We now take the transpose of the second equation and make use of the symmetry property A T = A, and then subtract the two equations to give

$$
(\lambda _ { i } -\lambda _ { j })\, u _ { i } ^ {\top } u _ { j } & = 0.\\
$$

Hence, for λ i = λ j, we have u T i u j = 0, and hence u i and u j are orthogonal. If the two eigenvalues are equal, then any linear combination α u i + β u j is also an eigenvector with the same eigenvalue, so we can select one linear combination arbitrarily,

/negationslash and then choose the second to be orthogonal to the first (it can be shown that the degenerate eigenvectors are never linearly dependent). Hence the eigenvectors can be chosen to be orthogonal, and by normalizing can be set to unit length. Because there are M eigenvalues, the corresponding M orthogonal eigenvectors form a complete set and so any M -dimensional vector can be expressed as a linear combination of the eigenvectors.

We can take the eigenvectors u i to be the columns of an M × M matrix U, which from orthonormality satisfies

$$
U ^ { T } U = I.
$$

Such a matrix is said to be orthogonal. Interestingly, the rows of this matrix are also orthogonal, so that UU T = I. To show this, note that (C.37) implies U T UU − 1 = U − 1 = U T and so UU − 1 = UU T = I. Using (C.12), it also follows that | U | = 1. The eigenvector equation (C.29) can be expressed in terms of U in the form

The eigenvector equation (C.29) can be expressed in terms of U in the form

$$
A U = U\Lambda
$$

where Λ is an M × M diagonal matrix whose diagonal elements are given by the eigenvalues λ i. If we consider a column vector x that is transformed by an orthogonal matrix U

If we consider a column vector x that is transformed by an orthogonal matrix U to give a new vector x = Ux then the length of the vector is preserved because x T x = x T U T Ux =

$$
\tilde { x } = U x
$$

$$
\widetilde { x } ^ { T }\widetilde { x } = x ^ { T } U ^ { T } U x = x ^ { T } x
$$

x T x and similarly the angle between any two such vectors is preserved because x T y = x T U T Uy = x T y. (C.41) Thus, multiplication by U can be interpreted as a rigid rotation of the coordinate system.

From (C.38), it follows that

$$
U ^ { T } A U =\Lambda
$$

and because Λ is a diagonal matrix, we say that the matrix A is diagonalized by the matrix U. If we left multiply by U and right multiply by U T, we obtain

$$
A = U\Lambda U ^ { T }
$$

Taking the inverse of this equation, and using (C.3) together with U − 1 = U T, we have 1 1 T

$$
A ^ { - 1 } = U\Lambda ^ { - 1 } U ^ { T }.
$$

These last two equations can also be written in the form

$$
A\ =\\sum _ { i = 1 } ^ { M }\lambda _ { i } u _ { i } u _ { i } ^ { T } & & (C. 4 5)\\
$$

$$
A ^ { - 1 }\ =\\sum _ { i = 1 } ^ { M }\frac { 1 } {\lambda _ { i } } u _ { i } ^ {\top }.
$$

If we take the determinant of (C.43), and use (C.12), we obtain

$$
| A | =\prod _ { i = 1 } ^ { M }\lambda _ { i }.\\\intertext { f o r (C. 4 3) }\int o f (C. 4 3)\,\text { and using the cyclic property } (C. 8)\, o f t h e trace
$$

Similarly, taking the trace of (C.43), and using the cyclic property (C.8) of the trace operator together with U T U = I, we have

$$
Tr (A) =\sum _ { i = 1 } ^ { M }\lambda _ { i }.
$$

We leave it as an exercise for the reader to verify (C.22) by making use of the results (C.33), (C.45), (C.46), and (C.47). T

A matrix A is said to be positive definite, denoted by A 0, if w Aw > 0 for all values of the vector w. Equivalently, a positive definite matrix has λ i > 0 for all of its eigenvalues (as can be seen by setting w to each of the eigenvectors in turn, and by noting that an arbitrary vector can be expanded as a linear combination of the eigenvectors). Note that positive definite is not the same as all the elements being positive. For example, the matrix

$$
\begin{array} { c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c
$$

has eigenvalues λ 1 5. 37 and λ 2 − 0. 37. A matrix is said to be positive semidefinite if w T Aw 0 holds for all values of w, which is denoted A 0, and is equivalent to λ i 0.

## Appendix D. Calculus of Variations

We can think of a function y (x) as being an operator that, for any input value x, returns an output value y. In the same way, we can define a functional F [y] to be an operator that takes a function y (x) and returns an output value F. An example of a functional is the length of a curve drawn in a two-dimensional plane in which the path of the curve is defined in terms of a function. In the context of machine learning, a widely used functional is the entropy H[x] for a continuous variable x because, for any choice of probability density function p (x), it returns a scalar value representing the entropy of x under that density. Thus the entropy of p (x) could equally well have been written as H[p].

A common problem in conventional calculus is to find a value of x that maximizes (or minimizes) a function y (x). Similarly, in the calculus of variations we seek a function y (x) that maximizes (or minimizes) a functional F [y]. That is, of all possible functions y (x), we wish to find the particular function for which the functional F [y] is a maximum (or minimum). The calculus of variations can be used, for instance, to show that the shortest path between two points is a straight line or that the maximum entropy distribution is a Gaussian.

If we weren't familiar with the rules of ordinary calculus, we could evaluate a conventional derivative d y/ d x by making a small change to the variable x and then expanding in powers of, so that

$$
y (x +\epsilon) = y (x) +\frac { d y } { d x }\epsilon + O (\epsilon ^ { 2 })
$$

and finally taking the limit → 0. Similarly, for a function of several variables y (x 1,...,x D), the corresponding partial derivatives are defined by

$$
y (x _ { 1 } +\epsilon _ { 1 },\dots, x _ { D } +\epsilon _ { D }) = y (x _ { 1 },\dots, x _ { D }) +\sum _ { i = 1 } ^ { D }\frac {\partial y } {\partial x _ { i } }\epsilon _ { i } + O (\epsilon ^ { 2 }).\quad (D. 2)\\\intertext { The analogous definition of a functional derivative arises when we consider how }
$$

The analogous definition of a functional derivative arises when we consider how much a functional F [y] changes when we make a small change /epsilon1η (x) to the function y (x), where η (x) is an arbitrary function of x, as illustrated in Figure D.1. We denote the functional derivative of E [f] with respect to f (x) by δF/δf (x), and define it by the following relation:

Figure D.1 A functional derivative can be defined by considering how the value of a functional F [y] changes when the function y (x) is changed to y (x) + η (x) where η (x) is an arbitrary function of x.

![image 351](Bishop2006_images/imageFile351.png)

$$
f [y (x) +\epsilon\eta (x)] & = F [y (x)] +\epsilon\int\frac {\delta F } {\delta y (x) }\eta (x)\, d x + O (\epsilon ^ { 2 }).\\\intertext { t h i s c a n b e s e n a s a r y a l $ i n t u r a l $ extensi o n f o r $ D $) i n w h i c h $ F [y] $ n o w d e n p e s o n a }
$$

This can be seen as a natural extension of (D.2) in which F [y] now depends on a continuous set of variables, namely the values of y at all points x. Requiring that the functional be stationary with respect to small variations in the function y (x) gives

$$
\text {y with respect to small variations in the function}\, y (x)\text { gives}\\\int\frac {\delta E } {\delta y (x) }\eta (x)\, d x = 0.\\\text {old for an arbitrary choice of }\eta (x)\text { if follows that the functional}
$$

Because this must hold for an arbitrary choice of η (x), it follows that the functional derivative must vanish. To see this, imagine choosing a perturbation η (x) that is zero everywhere except in the neighbourhood of a point x, in which case the functional derivative must be zero at x = x. However, because this must be true for every choice of x, the functional derivative must vanish for all values of x. Consider a functional that is defined by an integral over a function G (y,y,x) that depends on both y (x) and its derivative y (x) as well as having a direct depen-

̂ Consider a functional that is defined by an integral over a function G (y, y ′, x) that depends on both y (x) and its derivative y ′ (x) as well as having a direct dependence on x

$$
F [y] & =\int G\left (y (x), y ^ {\prime } (x), x\right)\, d x\\\text {of } y (x)\text { is assumed to be fixed at the boundary of the region of }
$$

where the value of y (x) is assumed to be fixed at the boundary of the region of integration (which might be at infinity). If we now consider variations in the function y (x), we obtain

$$
y (x), &\text {we obtain}\\ & F [y (x) +\epsilon (x)] = F [y (x)] +\epsilon\int\left\{\frac {\partial G } {\partial y }\eta (x) +\frac {\partial G } {\partial y ^ {\prime } }\eta ^ {\prime } (x)\right\}\, d x + O (\epsilon ^ { 2 }).\\ (D. 6)\\ &\text {We now have to cast this in the form (D 3). To do so, we integrate the second term by}
$$

We now have to cast this in the form (D.3). To do so, we integrate the second term by parts and make use of the fact that η (x) must vanish at the boundary of the integral (because y (x) is fixed at the boundary). This gives

$$
(\text {because}\, y (x)\,\text { is fixed at the boundary}).\text { This gives}\\ F [y (x) +\epsilon\eta (x)] = F [y (x)] +\epsilon\int\left\{\frac {\partial G } {\partial y } -\frac {\text {d} } {\text {d} x }\left (\frac {\partial G } {\partial y ^ {\prime } }\right)\right\}\eta (x)\,\text {d} x + O (\epsilon ^ { 2 })\,\text { (D.7)}
$$

Appendix E from which we can read off the functional derivative by comparison with (D.3). Requiring that the functional derivative vanishes then gives

$$
\frac {\partial G } {\partial y } -\frac { d } { d x }\left (\frac {\partial G } {\partial y ^ {\prime } }\right) = 0\\
$$

which are known as the Euler-Lagrange equations. For example, if

$$
G = y (x) ^ { 2 } + (y ^ {\prime } (x)) ^ { 2 }
$$

then the Euler-Lagrange equations take the form

$$
y (x) -\frac { d ^ { 2 } y } { d x ^ { 2 } } = 0.
$$

This second order differential equation can be solved for y (x) by making use of the boundary conditions on y (x).

Often, we consider functionals defined by integrals whose integrands take the form G (y,x) and that do not depend on the derivatives of y (x). In this case, stationarity simply requires that ∂G/∂y (x) = 0 for all values of x.

If we are optimizing a functional with respect to a probability distribution, then we need to maintain the normalization constraint on the probabilities. This is often most conveniently done using a Lagrange multiplier, which then allows an unconstrained optimization to be performed.

The extension of the above results to a multidimensional variable x is straightforward. For a more comprehensive discussion of the calculus of variations, see Sagan (1969).

## Appendix E. Lagrange Multipliers

Lagrange multipliers, also sometimes called undetermined multipliers, are used to find the stationary points of a function of several variables subject to one or more constraints.

Consider the problem of finding the maximum of a function f (x 1,x 2) subject to a constraint relating x 1 and x 2, which we write in the form

$$
g (x _ { 1 }, x _ { 2 }) = 0.
$$

One approach would be to solve the constraint equation (E.1) and thus express x 2 as a function of x 1 in the form x 2 = h (x 1). This can then be substituted into f (x 1,x 2) to give a function of x 1 alone of the form f (x 1,h (x 1)). The maximum with respect to x 1 could then be found by differentiation in the usual way, to give the stationary value x 1, with the corresponding value of x 2 given by x 2 = h (x 1).

One problem with this approach is that it may be difficult to find an analytic solution of the constraint equation that allows x 2 to be expressed as an explicit function of x 1. Also, this approach treats x 1 and x 2 differently and so spoils the natural symmetry between these variables.

A more elegant, and often simpler, approach is based on the introduction of a parameter λ called a Lagrange multiplier. We shall motivate this technique from a geometrical perspective. Consider a D -dimensional variable x with components x 1,...,x D. The constraint equation g (x) = 0 then represents a (D − 1) -dimensional surface in x -space as indicated in Figure E.1.

We first note that at any point on the constraint surface the gradient ∇ g (x) of the constraint function will be orthogonal to the surface. To see this, consider a point x that lies on the constraint surface, and consider a nearby point x + that also lies on the surface. If we make a Taylor expansion around x, we have

$$
g (x +\epsilon)\simeq g (x) +\epsilon ^ {\mathrm T }\nabla g (x).
$$

Because both x and x + /epsilon1 lie on the constraint surface, we have g (x) = g (x + /epsilon1) and hence /epsilon1 T ∇ g (x) /similarequal 0. In the limit ‖ /epsilon1 ‖ → 0 we have /epsilon1 T ∇ g (x) = 0, and because /epsilon1 is A geometrical picture of the technique of Lagrange multipliers in which we seek to maximize a function f (x), subject to the constraint g (x) = 0. If x is D dimensional, the constraint g (x) = 0 corresponds to a subspace of dimensionality D -1, indicated by the red curve. The problem can be solved by optimizing the Lagrangian function L (x, λ) = f (x) + λg (x).

Figure E.1

![image 352](Bishop2006_images/imageFile352.png)

$$
\nabla f +\lambda\nabla g & = 0\\\intertext { t a l g r a n g e m u l t i n l i r }\
$$

/negationslash where λ = 0 is known as a Lagrange multiplier. Note that λ can have either sign. At this point, it is convenient to introduce the Lagrangian function defined by

$$
L (x,\lambda) &\equiv f (x) +\lambda g (x).\\\dot {\cdot } &\quad\dot {\cdot },\quad\dot {\cdot }\cdot _ { x }\dot {\cdot }\cdot _ { y }\dot {\cdot },\quad\dot {\cdot }\cdot _ { x }\dot {\cdot }\cdot _ { y }\dot {\cdot },\quad\Sigma _ { x }\dot {\cdot },\quad\Sigma _ { y }\dot {\cdot },\quad\Sigma _ { x }\dot {\cdot },\quad\Sigma _ { y }\dot {\cdot }
$$

The constrained stationarity condition (E.3) is obtained by setting ∇ x L = 0. Furthermore, the condition ∂L/∂λ = 0 leads to the constraint equation g (x) = 0.

Thus to find the maximum of a function f (x) subject to the constraint g (x) = 0, we define the Lagrangian function given by (E.4) and we then find the stationary point of L (x,λ) with respect to both x and λ. For a D -dimensional vector x, this gives D +1 equations that determine both the stationary point x and the value of λ. If we are only interested in x, then we can eliminate λ from the stationarity equations without needing to find its value (hence the term 'undetermined multiplier').

As a simple example, suppose we wish to find the stationary point of the function f (x 1,x 2) = 1 − x 2 1 − x 2 2 subject to the constraint g (x 1,x 2) = x 1 + x 2 − 1 = 0, as illustrated in Figure E.2. The corresponding Lagrangian function is given by

$$
L (x,\lambda) = 1 - x _ { 1 } ^ { 2 } - x _ { 2 } ^ { 2 } +\lambda (x _ { 1 } + x _ { 2 } - 1).\\\dot { x } _ { i }.\quad f _ { i }\colon\quad _ { 1 }\colon\quad _ { 2 }\colon\quad _ { 1 }\colon\quad _ { 2 }\colon\quad _ { i }\colon\quad _ { 1 }\colon\quad _ { 2 }\colon\quad _ { i }\colon
$$

The conditions for this Lagrangian to be stationary with respect to x 1, x 2, and λ give the following coupled equations:

$$
- 2 x _ { 1 } +\lambda\ & =\ 0\\ = & 2 x _ { 0 } +\lambda\ & =\ 0
$$

$$
- 2 x _ { 2 } +\lambda\ =\ 0\\ r _ { 1 } + r _ { 0 } - 1\ =\ 0
$$

$$
x _ { 1 } + x _ { 2 } - 1\ =\ 0.
$$

Figure E.2 A simple example of the use of Lagrange multipliers in which the aim is to maximize f (x 1, x 2) = 1 − x 2 1 − x 2 2 subject to the constraint g (x 1, x 2) = 0 where g (x 1, x 2) = x 1 + x 2 − 1. The circles show contours of the function f (x 1, x 2), and the diagonal line shows the constraint surface g (x 1, x 2) = 0.

![image 353](Bishop2006_images/imageFile353.png)

So far, we have considered the problem of maximizing a function subject to an equality constraint of the form g (x) = 0. We now consider the problem of maximizing f (x) subject to an inequality constraint of the form g (x) 0, as illustrated in Figure E.3.

There are now two kinds of solution possible, according to whether the constrained stationary point lies in the region where g (x) > 0, in which case the constraint is inactive, or whether it lies on the boundary g (x) = 0, in which case the constraint is said to be active. In the former case, the function g (x) plays no role and so the stationary condition is simply ∇ f (x) = 0. This again corresponds to a stationary point of the Lagrange function (E.4) but this time with λ = 0. The latter case, where the solution lies on the boundary, is analogous to the equality constraint discussed previously and corresponds to a stationary point of the Lagrange function (E.4) with λ = 0. Now, however, the sign of the Lagrange multiplier is crucial, because the function f (x) will only be at a maximum if its gradient is oriented away from the region g (x) > 0, as illustrated in Figure E.3. We therefore have ∇ f (x) = − λ ∇ g (x) for some value of λ > 0. For either of these two cases, the product λg (x) = 0. Thus the solution to the

/negationslash

For either of these two cases, the product λg (x) = 0. Thus the solution to the

Figure E.3 Illustration of the problem of maximizing f (x) subject to the inequality constraint g (x) 0.

![image 354](Bishop2006_images/imageFile354.png)

$$
g (x)\\geq\ 0
$$

$$
\lambda\\geq\ 0\\
$$

$$
\lambda g (x)\ =\ 0
$$

Note that if we wish to minimize (rather than maximize) the function f (x) subject to an inequality constraint g (x) 0, then we minimize the Lagrangian function L (x,λ) = f (x) − λg (x) with respect to x, again subject to λ 0. Finally, it is straightforward to extend the technique of Lagrange multipliers to the case of multiple equality and inequality constraints. Suppose we wish to maximize f (x) subject to g j (x) = 0 for j = 1,...,J, and h k (x) 0 for k = 1,...,K. We then introduce Lagrange multipliers { λ j } and { µ k }, and then optimize the Lagrangian function given by

$$
L (x,\{\lambda _ { j }\},\{\mu _ { k }\}) & = f (x) +\sum _ { j = 1 } ^ { J }\lambda _ { j } g _ { j } (x) +\sum _ { k = 1 } ^ { K }\mu _ { k } h _ { k } (x)\\ L ^ {\cdot }\cdot\dots &\cdot\ > 0\\ _ { 1 }\quad L ^ {\cdot }\cdot\dots\\ _ { 0 }\\ _ { 1 }\quad L ^ {\cdot }\cdot\dots\\ _ { 1 }\quad V\\ F\cdot\dots\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\cdot\quad\
$$

subject to µ k 0 and µ k h k (x) = 0 for k = 1,...,K. Extensions to constrained functional derivatives are similarly straightforward. For a more detailed discussion of the technique of Lagrange multipliers, see Nocedal and Wright (1999).
