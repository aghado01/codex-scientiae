[Page 554]

distribution p(z). If, as is often the case, p(z)f(z) is strongly varying and has a signiﬁcant proportion of its mass concentrated over relatively small regions of z space, then the set of importance weights {rl} may be dominated by a few weights having large values, with the remaining weights being relatively insigniﬁcant. Thus the effective sample size can be much smaller than the apparent sample size L. The problem is even more severe if none of the samples falls in the regions where p(z)f(z) is large. In that case, the apparent variances of rl and rlf(z(l)) may be small even though the estimate of the expectation may be severely wrong. Hence a major drawback of the importance sampling method is the potential to produce results that are arbitrarily in error and with no diagnostic indication. This also highlights a key requirement for the sampling distribution q(z), namely that it should not be small or zero in regions where p(z) may be signiﬁcant.

For distributions deﬁned in terms of a graphical model, we can apply the importance sampling technique in various ways. For discrete variables, a simple approach is called uniform sampling. The joint distribution for a directed graph is deﬁned by (11.4). Each sample from the joint distribution is obtained by ﬁrst setting those variables zi that are in the evidence set equal to their observed values. Each of the remaining variables is then sampled independently from a uniform distribution over the space of possible instantiations. To determine the corresponding weight associated with a sample z(l), we note that the sampling distribution q(z) is uniform over the possible choices for z, and that p(z|x) = p(z), where x denotes the subset of variables that are observed, and the equality follows from the fact that every sample z that is generated is necessarily consistent with the evidence. Thus the weights rl are simply proportional to p(z). Note that the variables can be sampled in any order. This approach can yield poor results if the posterior distribution is far from uniform, as is often the case in practice.

An improvement on this approach is called likelihood weighted sampling (Fung and Chang, 1990; Shachter and Peot, 1990) and is based on ancestral sampling of the variables. For each variable in turn, if that variable is in the evidence set, then it is just set to its instantiated value. If it is not in the evidence set, then it is sampled from the conditional distribution p(zi|pai) in which the conditioning variables are set to their currently sampled values. The weighting associated with the resulting sample z is then given by

p(zi|pai) p(zi|pai) z

p(zi|pai) 1

=

p(zi|pai). (11.24)

r(z) =

i∈e

zi∈e

zi ∈e

This method can be further extended using self-importance sampling (Shachter and Peot, 1990) in which the importance sampling distribution is continually updated to reﬂect the current estimated posterior distribution.

###### 11.1.5 Sampling-importance-resampling

The rejection sampling method discussed in Section 11.1.2 depends in part for its success on the determination of a suitable value for the constant k. For many pairs of distributions p(z) and q(z), it will be impractical to determine a suitable
