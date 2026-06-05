[Page 669]

using modiﬁed forms of (13.18 ) and (13.19) given by

πk =

Ajk =

R

γ(z1(rk))

r=1

R

###### K

γ(z1(rj))

r=1

j=1

R

###### N

ξ(zn(r−)1,j,zn,k(r) )

r=1

n=2

R

###### K

###### N

ξ(zn(r−)1,j,zn,l(r))

r=1

n=2

l=1

(13.124)

(13.125)

where, for notational convenience, we have assumed that the sequences are of the same length (the generalization to sequences of different lengths is straightforward). Similarly, show that the M-step equation for re-estimation of the means of Gaussian emission models is given by

R

###### N

γ(znk(r))x(nr)

r=1

n=1

µk =

. (13.126)

R

###### N

γ(znk(r))

r=1

n=1

Note that the M-step equations for other emission model parameters and distributions take an analogous form.

- 13.13 ( ) www Use the deﬁnition (8.64) of the messages passed from a factor node to a variable node in a factor graph, together with the expression (13.6) for the joint distribution in a hidden Markov model, to show that the deﬁnition (13.50) of the alpha message is the same as the deﬁnition (13.34).

- 13.14 ( ) Use the deﬁnition (8.67) of the messages passed from a factor node to a variable node in a factor graph, together with the expression (13.6) for the joint distribution in a hidden Markov model, to show that the deﬁnition (13.52) of the beta message is the same as the deﬁnition (13.35).
- 13.15 ( ) Use the expressions (13.33) and (13.43) for the marginals in a hidden Markov model to derive the corresponding results (13.64) and (13.65) expressed in terms of re-scaled variables.
- 13.16 ( ) In this exercise, we derive the forward message passing equation for the Viterbi algorithm directly from the expression (13.6) for the joint distribution. This


involves maximizing over all of the hidden variables z1,...,zN. By taking the logarithm and then exchanging maximizations and summations, derive the recursion
