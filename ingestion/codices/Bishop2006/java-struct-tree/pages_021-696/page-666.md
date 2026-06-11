[Page 666]

straightforward since, again using Bayes’ theorem

p(zn+1|Xn) = � p(zn+1|zn,Xn)p(zn|Xn)dzn

= � p(zn+1|zn)p(zn|Xn)dzn

= � p(zn+1|zn)p(zn|xn,Xn−1)dzn

� p(zn+1|zn)p(xn|zn)p(zn|Xn−1)dzn

=

� p(xn|zn)p(zn|Xn−1)dzn

�

=

wn(l)p(zn+1|z(nl)) (13.119)

l

where we have made use of the conditional independence properties

p(zn+1|zn,Xn) = p(zn+1|zn) (13.120) p(xn|zn,Xn−1) = p(xn|zn) (13.121)

which follow from the application of the d-separation criterion to the graph in Figure 13.5. The distribution given by (13.119) is a mixture distribution, and samples can be drawn by choosing a component l with probability given by the mixing coefﬁcients w(l) and then drawing a sample from the corresponding component.

In summary, we can view each step of the particle ﬁlter algorithm as comprising two stages. At time step n, we have a sample representation of the posterior distribution p(zn|Xn) expressed as samples {z(nl)} with corresponding weights {wn(l)}. This can be viewed as a mixture representation of the form (13.119). To obtain the corresponding representation for the next time step, we ﬁrst draw L samples from the mixture distribution (13.119), and then for each sample we use the new observation xn+1 to evaluate the corresponding weights wn(l+1) ∝ p(xn+1|z(nl+1) ). This is illustrated, for the case of a single variable z, in Figure 13.23.

The particle ﬁltering, or sequential Monte Carlo, approach has appeared in the literature under various names including the bootstrap ﬁlter (Gordon et al., 1993), survival of the ﬁttest (Kanazawa et al., 1995), and the condensation algorithm (Isard and Blake, 1998).

Exercises

13.1 (�) www Use the technique of d-separation, discussed in Section 8.2, to verify that the Markov model shown in Figure 13.3 having N nodes in total satisﬁes the conditional independence properties (13.3) for n = 2,...,N. Similarly, show that a model described by the graph in Figure 13.4 in which there are N nodes in total
