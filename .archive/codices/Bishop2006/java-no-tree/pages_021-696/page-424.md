[Page 424]

- Figure 8.46 A fragment of a factor graph illustrating the evaluation of the marginal p(x).


s→x(x)

µf

()Fx,Xss

| | |
|---|---|
| | |


fs x

fs, and Fs(x,Xs) represents the product of all the factors in the group associated with factor fs.

Substituting (8.62) into (8.61) and interchanging the sums and products, we obtain

Fs(x,Xs)

p(x) =

s∈ne(x) Xs

=

s→x(x). (8.63)

µf

s∈ne(x)

s→x(x), deﬁned by µf

Here we have introduced a set of functions µf

s→x(x) ≡

Fs(x,Xs) (8.64)

Xs

which can be viewed as messages from the factor nodes fs to the variable node x. We see that the required marginal p(x) is given by the product of all the incoming messages arriving at node x.

In order to evaluate these messages, we again turn to Figure 8.46 and note that

each factor Fs(x,Xs) is described by a factor (sub-)graph and so can itself be factorized. In particular, we can write

###### Fs(x,Xs) = fs(x,x1,...,xM)G1 (x1,Xs1)...GM (xM,XsM) (8.65)

where, for convenience, we have denoted the variables associated with factor fx, in addition to x, by x1,...,xM. This factorization is illustrated in Figure 8.47. Note that the set of variables {x,x1,...,xM} is the set of variables on which the factor fs depends, and so it can also be denoted xs, using the notation of (8.59).

Substituting (8.65) into (8.64) we obtain

s→x(x) =

µf

=

x1

x1

fs(x,x1,...,xM)

Gm(xm,Xsm)

###### ...

xM

m∈ne(fs)\x Xxm

fs(x,x1,...,xM)

m→fs(xm) (8.66)

###### ...

µx

xM

m∈ne(fs)\x
