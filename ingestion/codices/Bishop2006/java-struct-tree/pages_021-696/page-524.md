[Page 524]

With this factorization we can appeal to the general result (10.9) to ﬁnd expressions for the optimal factors. Consider ﬁrst the distribution q(w). Discarding terms that are independent of w, we have

lnq(w) = Eα [ln{h(w,ξ)p(w|α)p(α)}] + const

= lnh(w,ξ) + Eα [lnp(w|α)] + const.

We now substitute for lnh(w,ξ) using (10.153), and for lnp(w|α) using (10.165), giving

�N

E[α] 2

�

�

lnq(w) = −

wTw +

(tn − 1/2)wTφn − λ(ξn)wTφnφTnw

+ const.

n=1

We see that this is a quadratic function of w and so the solution for q(w) will be Gaussian. Completing the square in the usual way, we obtain

q(w) = N(w|µN,ΣN) (10.174) where we have deﬁned

�N

Σ−1

N µN =

(tn − 1/2)φn (10.175)

n=1

�N

Σ−1

N = E[α]I + 2

λ(ξn)φnφTn. (10.176)

n=1

Similarly, the optimal solution for the factor q(α) is obtained from

lnq(α) = Ew [lnp(w|α)] + lnp(α) + const. Substituting for lnp(w|α) using (10.165), and for lnp(α) using (10.166), we obtain

�

�

α 2

M 2

lnα −

lnq(α) =

+ (a0 − 1)lnα − b0α + const. We recognize this as the log of a gamma distribution, and so we obtain

wTw

E

1 Γ(a0)

q(α) = Gam(α|aN,bN) =

ab

0−1e−b

0 αa

0α (10.177)

0

where

M 2

aN = a0 +

1 2

�

bN = b0 +

Ew

�

wTw

(10.178)

. (10.179)
