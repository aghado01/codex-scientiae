[Page 542]

where Zj is the normalization constant deﬁned by (10.197). By applying this result recursively, and initializing with p0(D) = 1, derive the result

p(D) � �

Zj. (10.243)

j

10.37 (�) www Consider the expectation propagation algorithm from Section 10.7, and

suppose that one of the factors f0(θ) in the deﬁnition (10.188) has the same exponential family functional form as the approximating distribution q(θ). Show that if

the factor f�0(θ) is initialized to be f0(θ), then an EP update to reﬁne f�0(θ) leaves f�0(θ) unchanged. This situation typically arises when one of the factors is the prior p(θ), and so we see that the prior factor can be incorporated once exactly and does not need to be reﬁned.

10.38 (���) In this exercise and the next, we shall verify the results (10.214)–(10.224) for the expectation propagation algorithm applied to the clutter problem. Begin by using the division formula (10.205) to derive the expressions (10.214) and (10.215) by completing the square inside the exponential to identify the mean and variance. Also, show that the normalization constant Zn, deﬁned by (10.206), is given for the clutter problem by (10.216). This can be done by making use of the general result (2.115).

10.39 (���) Show that the mean and variance of qnew(θ) for EP applied to the clutter problem are given by (10.217) and (10.218). To do this, ﬁrst prove the following results for the expectations of θ and θθT under qnew(θ)

E[θ] = m\n + v\n∇m\n lnZn (10.244) E[θTθ] = 2(v\n)2∇v\n lnZn + 2E[θ]Tm\n − �m\n�2 (10.245)

and then make use of the result (10.216) for Zn. Next, prove the results (10.220)– (10.222) by using (10.207) and completing the square in the exponential. Finally, use (10.208) to derive the result (10.223).
