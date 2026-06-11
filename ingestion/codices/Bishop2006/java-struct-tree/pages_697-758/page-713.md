[Page 713]

Von Mises

The von Mises distribution, also known as the circular normal or the circular Gaussian, is a univariate Gaussian-like periodic distribution for a variable θ ∈ [0,2π).

1 2πI0(m)

p(θ|θ0,m) =

exp{mcos(θ − θ0)} (B.77)

where I0(m) is the zeroth-order Bessel function of the ﬁrst kind. The distribution has period 2π so that p(θ + 2π) = p(θ) for all θ. Care must be taken in interpreting this distribution because simple expectations will be dependent on the (arbitrary) choice of origin for the variable θ. The parameter θ0 is analogous to the mean of a univariate Gaussian, and the parameter m > 0, known as the concentration parameter, is analogous to the precision (inverse variance). For large m, the von Mises distribution is approximately a Gaussian centred on θ0.

Wishart

The Wishart distribution is the conjugate prior for the precision matrix of a multivariate Gaussian.

W(Λ|W,ν) = B(W,ν)|Λ|(ν−D−1)/2 exp�−

Tr(W−1Λ)� (B.78)

1 2

where

��−1 (B.79)

�2νD/2 πD(D−1)/4

Γ�

�D

ν + 1 − i 2

B(W,ν) ≡ |W|−ν/2

i=1

E[Λ] = νW (B.80)

ψ �

� + D ln2 + ln|W| (B.81)

�D

ν + 1 − i 2

E[ln|Λ|] =

i=1

(ν − D − 1) 2

νD 2

H[Λ] = −lnB(W,ν) −

E[ln|Λ|] +

(B.82)

where W is a D × D symmetric, positive deﬁnite matrix, and ψ(·) is the digamma function deﬁned by (B.25). The parameter ν is called the number of degrees of freedom of the distribution and is restricted to ν > D − 1 to ensure that the Gamma function in the normalization factor is well-deﬁned. In one dimension, the Wishart reduces to the gamma distribution Gam(λ|a,b) given by (B.26) with parameters a = ν/2 and b = 1/2W.
