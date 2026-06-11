[Page 640]

represents a vector of length K whose entries correspond to the expected values of znk. Using Bayes’ theorem, we have

p(X|zn)p(zn) p(X)

γ(zn) = p(zn|X) =

. (13.32)

Note that the denominator p(X) is implicitly conditioned on the parameters θold of the HMM and hence represents the likelihood function. Using the conditional independence property (13.24), together with the product rule of probability, we obtain

p(x1,...,xn,zn)p(xn+1,...,xN|zn) p(X)

α(zn)β(zn) p(X)

γ(zn) =

=

(13.33) where we have deﬁned

α(zn) ≡ p(x1,...,xn,zn) (13.34) β(zn) ≡ p(xn+1,...,xN|zn). (13.35)

The quantity α(zn) represents the joint probability of observing all of the given data up to time n and the value of zn, whereas β(zn) represents the conditional probability of all future data from time n + 1 up to N given the value of zn. Again, α(zn) and β(zn) each represent set of K numbers, one for each of the possible settings of the 1-of-K coded binary vector zn. We shall use the notation α(znk) to denote the value of α(zn) when znk = 1, with an analogous interpretation of β(znk).

We now derive recursion relations that allow α(zn) and β(zn) to be evaluated efﬁciently. Again, we shall make use of conditional independence properties, in particular (13.25) and (13.26), together with the sum and product rules, allowing us to express α(zn) in terms of α(zn−1) as follows

α(zn) = p(x1,...,xn,zn)

= p(x1,...,xn|zn)p(zn)

= p(xn|zn)p(x1,...,xn−1|zn)p(zn)

= p(xn|zn)p(x1,...,xn−1,zn)

= p(xn|zn)

p(x1,...,xn−1,zn−1,zn)

zn−1

= p(xn|zn)

p(x1,...,xn−1,zn|zn−1)p(zn−1)

zn−1

= p(xn|zn)

p(x1,...,xn−1|zn−1)p(zn|zn−1)p(zn−1)

zn−1

= p(xn|zn)

###### p(x1,...,xn−1,zn−1)p(zn|zn−1)

zn−1

Making use of the deﬁnition (13.34) for α(zn), we then obtain

###### α(zn) = p(xn|zn)

zn−1

###### α(zn−1)p(zn|zn−1). (13.36)
