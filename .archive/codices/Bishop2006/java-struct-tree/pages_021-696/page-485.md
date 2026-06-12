[Page 485]

It should be emphasized that we are making no further assumptions about the distribution. In particular, we place no restriction on the functional forms of the individual factors qi(Zi). This factorized form of variational inference corresponds to an approximation framework developed in physics called mean ﬁeld theory (Parisi, 1988).

Amongst all distributions q(Z) having the form (10.5), we now seek that distribution for which the lower bound L(q) is largest. We therefore wish to make a free form (variational) optimization of L(q) with respect to all of the distributions qi(Zi), which we do by optimizing with respect to each of the factors in turn. To achieve this, we ﬁrst substitute (10.5) into (10.3) and then dissect out the dependence on one of the factors qj(Zj). Denoting qj(Zj) by simply qj to keep the notation uncluttered, we then obtain

qi �lnp(X,Z) − �

lnqi� dZ

L(q) = � �

i

i

= � qj �� lnp(X,Z)

qi dZi� dZj − � qj lnqj dZj + const

�

i�=j

= � qj ln�p(X,Zj)dZj − � qj lnqj dZj + const (10.6)

where we have deﬁned a new distribution �p(X,Zj) by the relation

ln�p(X,Zj) = Ei�=j[lnp(X,Z)] + const. (10.7)

Here the notation Ei�=j[···] denotes an expectation with respect to the q distributions over all variables zi for i �= j, so that

Ei�=j[lnp(X,Z)] = � lnp(X,Z)

�

qi dZi. (10.8)

i�=j

Now suppose we keep the {qi�=j} ﬁxed and maximize L(q) in (10.6) with respect to all possible forms for the distribution qj(Zj). This is easily done by recognizing that (10.6) is a negative Kullback-Leibler divergence between qj(Zj) and �p(X,Zj). Thus maximizing (10.6) is equivalent to minimizing the Kullback-Leibler

Leonhard Euler

![image 112](../../../../../images/imageFile112.png)

contributions, he formulated the modern theory of the function, he developed (together with Lagrange) the calculus of variations, and he discovered the formula eiπ = −1, which relates four of the most important numbers in mathematics. During the last 17 years of his life, he was almost totally blind, and yet he produced nearly half of his results during this period.

1707–1783

Euler was a Swiss mathematician and physicist who worked in St. Petersburg and Berlin and who is widely considered to be one of the greatest mathematicians of all time. He is certainly the most proliﬁc, and

his collected works ﬁll 75 volumes. Amongst his many
