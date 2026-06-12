[Page 430]

x1 x2 x3

x1 x2 x3

x4

(a)

x4

(b)

Figure 8.52 Flow of messages for the sum-product algorithm applied to the example graph in Figure 8.51. (a) From the leaf nodes x1 and x4 towards the root node x3. (b) From the root node towards the leaf nodes.

One message has now passed in each direction across each link, and we can now evaluate the marginals. As a simple check, let us verify that the marginal p(x2) is given by the correct expression. Using (8.63) and substituting for the messages using the above results, we have

�p(x2) = µf

a→x2(x2)µf

b→x2(x2)µf

c→x2(x2)

= �

fa(x1,x2)��

fb(x2,x3)��

fc(x2,x4)�

�

�

�

x1

x3

x4

�

�

�

=

fa(x1,x2)fb(x2,x3)fc(x2,x4)

x1

x2

x4

�

�

�

=

x4 �p(x) (8.86) as required.

x1

x3

So far, we have assumed that all of the variables in the graph are hidden. In most practical applications, a subset of the variables will be observed, and we wish to calculate posterior distributions conditioned on these observations. Observed nodes are easily handled within the sum-product algorithm as follows. Suppose we partition x into hidden variables h and observed variables v, and that the observed value of v is denoted v�. Then we simply multiply the joint distribution p(x) by

�

i I(vi,�vi), where I(v,�v) = 1 if v = �v and I(v,�v) = 0 otherwise. This product corresponds to p(h,v = v�) and hence is an unnormalized version of p(h|v = v�). By running the sum-product algorithm, we can efﬁciently calculate the posterior marginals p(hi|v = v�) up to a normalization coefﬁcient whose value can be found efﬁciently using a local computation. Any summations over variables in v then collapse into a single term.

We have assumed throughout this section that we are dealing with discrete variables. However, there is nothing speciﬁc to discrete variables either in the graphical framework or in the probabilistic construction of the sum-product algorithm. For
