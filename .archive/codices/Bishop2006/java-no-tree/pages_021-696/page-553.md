[Page 553]

samples {z(l)} drawn from q(z)

E[f] = f(z)p(z)dz

p(z) q(z)

q(z)dz

= f(z)

L

p(z(l)) q(z(l))

1 L

f(z(l)). (11.19)

l=1

The quantities rl = p(z(l))/q(z(l)) are known as importance weights, and they correct the bias introduced by sampling from the wrong distribution. Note that, unlike rejection sampling, all of the samples generated are retained.

It will often be the case that the distribution p(z) can only be evaluated up to a normalization constant, so that p(z) = p(z)/Zp where p(z) can be evaluated easily, whereas Zp is unknown. Similarly, we may wish to use an importance sampling distribution q(z) = q(z)/Zq, which has the same property. We then have

E[f] = f(z)p(z)dz

=

p(z) q(z)

Zq Zp

f(z)

q(z)dz

L

1 L

Zq Zp

rlf(z(l)). (11.20)

l=1

where rl = p(z(l))/ q(z(l)). We can use the same sample set to evaluate the ratio Zp/Zq with the result

Zp Zq

=

1 Zq

p(z) q(z)

q(z)dz

p(z)dz =

L

1 L

rl (11.21)

l=1

and hence

where we have deﬁned

E[f]

L

wlf(z(l)) (11.22)

l=1

rl m rm

wl =

=

p(z(l))/q(z(l)) m p(z(m))/q(z(m))

. (11.23)

As with rejection sampling, the success of the importance sampling approach depends crucially on how well the sampling distribution q(z) matches the desired
