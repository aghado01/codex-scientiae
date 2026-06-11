[Page 536]

Section 8.4.4 These are precisely the messages obtained using belief propagation in which messages from variable nodes to factor nodes have been folded into the messages from factor nodes to variable nodes. In particular, f�b2(x2) corresponds to the message µf

b→x2(x2) sent by factor node fb to variable node x2 and is given by (8.81). Similarly, if we substitute (8.78) into (8.79), we obtain (10.235) in which f�a2(x2) corresponds to µf

a→x2(x2) and f�c2(x2) corresponds to µf

c→x2(x2), giving the message f�b3(x3) which corresponds to µf

b→x3(x3).

This result differs slightly from standard belief propagation in that messages are passed in both directions at the same time. We can easily modify the EP procedure to give the standard form of the sum-product algorithm by updating just one of the factors at a time, for instance if we reﬁne only f�b3(x3), then f�b2(x2) is unchanged by deﬁnition, while the reﬁned version of f�b3(x3) is again given by (10.235). If we are reﬁning only one term at a time, then we can choose the order in which the reﬁnements are done as we wish. In particular, for a tree-structured graph we can follow a two-pass update scheme, corresponding to the standard belief propagation schedule, which will result in exact inference of the variable and factor marginals. The initialization of the approximation factors in this case is unimportant.

Now let us consider a general factor graph corresponding to the distribution

�

fi(θi) (10.236)

p(θ) =

i

where θi represents the subset of variables associated with factor fi. We approximate this using a fully factorized distribution of the form

q(θ) ∝ �

�

f�ik(θk) (10.237)

i

k

where θk corresponds to an individual variable node. Suppose that we wish to reﬁne the particular term f�jl(θl) keeping all other terms ﬁxed. We ﬁrst remove the term f�j(θj) from q(θ) to give

q\j(θ) ∝ � i�=j

�

f�ik(θk) (10.238)

k

and then multiply by the exact factor fj(θj). To determine the reﬁned term f�jl(θl), we need only consider the functional dependence on θl, and so we simply ﬁnd the corresponding marginal of

q\j(θ)fj(θj). (10.239) Up to a multiplicative constant, this involves taking the marginal of fj(θj) multiplied by any terms from q\j(θ) that are functions of any of the variables in θj. Terms that correspond to other factors f�i(θi) for i �= j will cancel between numerator and denominator when we subsequently divide by q\j(θ). We therefore obtain

f�jl(θl) ∝ �

�

�

f�km(θm). (10.240)

fj(θj)

θm=� l∈θj

m=� l

k
