[Page 6]

  a : V a ! U a + ✏ 1 , a 2 n , such that the following diagrams (and their symmetric counterparts obtained by exchanging the role of and ) are commutative:




u a,a 0





+


/epsilon1




v a +

+

/epsilon1




+


/epsilon1




and






+


/epsilon1


u a,a +

+


/epsilon1





+


/epsilon1



+


/epsilon1



+



/epsilon1

The interleaving distance between , is d I ( , ) : = inf ✏ > 0 { , are ✏ -interleaved } .

The deﬁnition above agrees with our earlier deﬁnition of interleaving when n = 1 . Contrary to the 1 -dimensional case, computing the interleaving distance for n > 2 is an NP-hard problem (even if the persistence modules , are given to us in a ‘nice’ form). For this reason, the following alternative based on the ﬁbered barcode is sometimes used in practice. It is known to be eﬃciently computable when n = 2 .

Deﬁnition 9.16. The matching distance between p.f.d. n -persistence modules , is

$$
d _ { \text {match} } ( \mathbb { U } , \mathbb { V } ) \coloneqq \sup _ { L } \ \left \{ d _ { B } ( \mathcal { B } ( \mathbb { U } _ { L } ) , \ \mathcal { B } ( \mathbb { V } _ { L } ) ) \right \} , \\ \intertext { w h e r e } \ w h e r e \ t h e \ s u p r e m a y m i s t o k e n \ o v e r \ a l l \ l i n e s \ I \colon t \mapsto t a
$$

where the supremum is taken over all lines L : t 7! ta + b with a ⌫ 1 , b 2 n .

Theorem 9.17 (see [ 3 ]) . For any two p.f.d. n -persistence modules,

$$
d _ { \text {match} } ( \mathbb { U } , \mathbb { V } ) \leqslant d _ { I } ( \mathbb { U } , \mathbb { V } ) .
$$

Exercise 9.18. Prove that d B B ( L ) , B ( L ) 6 d I ( , ) for all lines L : t 7! t 1 + b .

## 9.3.1 Robustness of some bipersistence modules

Finally, we come back to the primary reason for studying multiparameter persistence: achieving robustness w.r.t. outliers in the data. To state formal guarantees of this form, we need to think about point-cloud data in a more probablistic way. For a ﬁnite (multi)set X ✓ n , we write µ X for the uniform probability measure on X , meaning the measure that assigns probability 1/ | X | to each x 2 X . The following can be thought of as a ‘probabilistic Hausdorﬀ distance’ between point clouds.

Deﬁnition 9.19. Let X,Y ✓ n ﬁnite. The Prohorov distance 1 between µ X ,µ Y is

$$
d _ { \Pr } ( \mu _ { X } , \mu _ { Y } ) \coloneqq \supinf _ { A } \{ \delta \geqslant 0 \colon \mu _ { X } ( A ) \leqslant \mu _ { Y } ( A ^ { \delta } ) + \delta \ a n d \ \mu _ { Y } ( A ) \leqslant \mu _ { X } ( A ^ { \delta } ) + \delta \} ,
$$

where A ranges over all closed subsets of n and A : = { y 2 n : dist ( y,A ) 6 } .

1 The Prohorov distance can be deﬁned between any two measures µ, ⌫ on (the same) metric space M .
