[Page 13]

# 3.2 Statistics

In the setting of oneparameter persistent homology, one major advantage of the use of persistence landscapes over persistence diagrams is that in contrast to persistence diagrams, persistence landscapes allow for a unique mean [4]. Analogously to the case of oneand multiparameter landscapes, for spatiotemporal persistence landscapes we can also define a mean landscape of a set of landscapes by taking the pointwise mean. The resulting landscape is in general not the landscape of a persistence module, however, local maxima of the mean landscapes can be interpreted as parameter values where persistent topological features in space and time are located. Furthermore, taking the average landscape over a set of noisy measurements could reduce the influence of noise.

Under suitable finiteness assumptions the landscapes are elements of a Banach space, namely the Lebesgue space L p ( × 2 ) equipped with the usual p -norm. We apply the theory of probability in Banach spaces in order to obtain statistical results. In order to guarantee separability of the Lebesgue space we assume that 1 ≤ p < ∞ . For more details on that topic, see [20] and Appendix C.

Following the procedures for oneparameter and multiparameter persistence landscapes ( [4,40]), we view the spatiotemporal persistence landscapes as random variables that take values in a Banach space. To be precise, let X be a random variable on the probability space (Ω , F ,P ) , i.e. X ( ω ) is the data for ω ∈ Ω with corresponding landscape Λ( ω ) = λ ( X ( ω )) . Thus, Λ : (Ω , F ,P ) → L p ( × 2 ) is a random variable with values in a Banach space. We denote the expectation value of a real random variable X by E ( X ) . The analogue to the expactation values in case of a random variable V with values in a Banach space is the so-called Pettis integral (see Definition C.1) and is also denoted by E ( V ) .

We assume that X i are independent identically distributed copies of X with corresponding landscapes Λ i . By Λ n we denote the pointwise mean of the first n landscapes. Analogously to the case of oneparameter and multiparameter persistence landscapes, applying the theory of random variables with values in a Banach space yields the following results. These results are stated without proofs because these theorems follow directly from the developed theory for multiparameter persistence landscapes [40]. This comes from the fact that spatiotemporal persistence landscapes and biparameter persistence landscapes take values in the same Banach space even though we define them for different kind of data.

Theorem 3.7 (Strong law of large numbers for spatiotemporal persistence landscapes) Λ n → E (Λ) almost surely if and only if E ( ∥ Λ ∥ ) < ∞ .

Theorem 3.8 (Central limit theorem for spatiotemporal persistence landscapes) Let p ≥ 2 , E ( ∥ Λ ∥ ) < ∞ and E ( ∥ Λ ∥ 2 ) < ∞ . Then √ n ( Λ n − E (Λ)) converges weakly to a Gaussian random variable with the same covariance structure as Λ .

# 4 Stability of Spatiotemporal Persistence Landscapes

In this section, we show the stability of spatiotemporal persistence landscapes. Stability is a central part of persistent homology to assure that small perturbations of the input data do not alter the invariant too much.
