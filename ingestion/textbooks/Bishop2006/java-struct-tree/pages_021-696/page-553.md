[Page 553]

samples {z(l)} drawn from q(z)

E[f] = � f(z)p(z)dz

= � f(z)

p(z) q(z)

q(z)dz

�L

p(z(l)) q(z(l))

1 L

f(z(l)). (11.19)

�

l=1

The quantities rl = p(z(l))/q(z(l)) are known as importance weights, and they correct the bias introduced by sampling from the wrong distribution. Note that, unlike rejection sampling, all of the samples generated are retained.

It will often be the case that the distribution p(z) can only be evaluated up to a normalization constant, so that p(z) = �p(z)/Zp where �p(z) can be evaluated easily, whereas Zp is unknown. Similarly, we may wish to use an importance sampling distribution q(z) = �q(z)/Zq, which has the same property. We then have

E[f] = � f(z)p(z)dz

� f(z)

�p(z) �q(z)

Zq Zp

q(z)dz

=

�L l=1 �rlf(z(l)). (11.20)

1 L

Zq Zp

�

where �rl = �p(z(l))/�q(z(l)). We can use the same sample set to evaluate the ratio Zp/Zq with the result

�

�p(z)dz = �

1 Zq

�p(z) �q(z)

Zp Zq

q(z)dz

=

�L l=1 �rl (11.21)

1 L

�

and hence

�L

wlf(z(l)) (11.22)

E[f] �

l=1

where we have deﬁned

�p(z(l))/q(z(l)) �

�rl

wl =

=

. (11.23)

�

m�p(z(m))/q(z(m))

m�rm

As with rejection sampling, the success of the importance sampling approach depends crucially on how well the sampling distribution q(z) matches the desired
