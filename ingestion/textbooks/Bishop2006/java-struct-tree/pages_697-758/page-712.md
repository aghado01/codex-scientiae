[Page 712]

of Gaussians having the same mean but different variances.

�

�1/2 �1 +

�−ν/2−1/2 (B.64)

Γ(ν/2 + 1/2) Γ(ν/2)

λ(x − µ)2 ν

λ πν

St(x|µ,λ,ν) =

E[x] = µ for ν > 1 (B.65) var[x] =

1 λ

ν ν − 2

for ν > 2 (B.66) mode[x] = µ. (B.67)

Here ν > 0 is called the number of degrees of freedom of the distribution. The particular case of ν = 1 is called the Cauchy distribution.

For a D-dimensional variable x, Student’s t-distribution corresponds to marginalizing the precision matrix of a multivariate Gaussian with respect to a conjugate Wishart prior and takes the form

�1 +

�−ν/2−D/2 (B.68)

Γ(ν/2 + D/2) Γ(ν/2)

∆2 ν

|Λ|1/2 (νπ)D/2

St(x|µ,Λ,ν) =

E[x] = µ for ν > 1 (B.69) cov[x] =

ν ν − 2

Λ−1 for ν > 2 (B.70)

mode[x] = µ (B.71) where ∆2 is the squared Mahalanobis distance deﬁned by

∆2 = (x − µ)TΛ(x − µ). (B.72)

In the limit ν → ∞, the t-distribution reduces to a Gaussian with mean µ and precision Λ. Student’s t-distribution provides a generalization of the Gaussian whose maximum likelihood parameter values are robust to outliers.

Uniform

This is a simple distribution for a continuous variable x deﬁned over a ﬁnite interval x ∈ [a,b] where b > a.

1 b − a

U(x|a,b) =

(B.73)

(b + a) 2

E[x] =

(B.74)

(b − a)2 12

var[x] =

(B.75)

H[x] = ln(b − a). (B.76) If x has distribution U(x|0,1), then a + (b − a)x will have distribution U(x|a,b).
