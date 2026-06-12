[Page 525]

We also need to optimize the variational parameters ξn, and this is also done by maximizing the lower bound L(q,ξ). Omitting terms that are independent of ξ, and integrating over α, we have

L(q,ξ) = q(w)lnh(w,ξ)dw + const. (10.180)

Note that this has precisely the same form as (10.159), and so we can again appeal to our earlier result (10.163), which can be obtained by direct optimization of the marginal likelihood function, leading to re-estimation equations of the form

(ξnnew)2 = φTn ΣN + µNµTN φn. (10.181) We have obtained re-estimation equations for the three quantities q(w), q(α),

and ξ, and so after making suitable initializations, we can cycle through these quanAppendix B tities, updating each in turn. The required moments are given by

aN bN

E[α] =

(10.182) E wTw = ΣN + µTNµN. (10.183)

###### 10.7. Expectation Propagation

We conclude this chapter by discussing an alternative form of deterministic approximate inference, known as expectation propagation or EP (Minka, 2001a; Minka, 2001b). As with the variational Bayes methods discussed so far, this too is based on the minimization of a Kullback-Leibler divergence but now of the reverse form, which gives the approximation rather different properties.

Consider for a moment the problem of minimizing KL(p q) with respect to q(z) when p(z) is a ﬁxed distribution and q(z) is a member of the exponential family and so, from (2.194), can be written in the form

q(z) = h(z)g(η)exp ηTu(z) . (10.184) As a function of η, the Kullback-Leibler divergence then becomes

KL(p q) = −lng(η) − ηTEp(z)[u(z)] + const (10.185)

where the constant terms are independent of the natural parameters η. We can minimize KL(p q) within this family of distributions by setting the gradient with respect to η to zero, giving

−∇lng(η) = Ep(z)[u(z)]. (10.186) However, we have already seen in (2.226) that the negative gradient of lng(η) is given by the expectation of u(z) under the distribution q(z). Equating these two results, we obtain

Eq(z)[u(z)] = Ep(z)[u(z)]. (10.187)
