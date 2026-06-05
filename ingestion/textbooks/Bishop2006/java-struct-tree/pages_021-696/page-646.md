[Page 646]

Figure 13.15 A simpliﬁed form of factor graph to describe the hidden Markov model.

h fn

z1 zn−1 zn

To derive the alpha-beta algorithm, we denote the ﬁnal hidden variable zN as the root node, and ﬁrst pass messages from the leaf node h to the root. From the general results (8.66) and (8.69) for message propagation, we see that the messages which are propagated in the hidden Markov model take the form

n−1→fn(zn−1) = µf

n−1→zn−1(zn−1) (13.47) µf

µz

�

n→zn(zn) =

fn(zn−1,zn)µz

n−1→fn(zn−1) (13.48)

zn−1

These equations represent the propagation of messages forward along the chain and are equivalent to the alpha recursions derived in the previous section, as we shall now show. Note that because the variable nodes zn have only two neighbours, they perform no computation.

n−1→fn(zn−1) from (13.48) using (13.47) to give a recursion for the f → z messages of the form

We can eliminate µz

�

n→zn(zn) =

fn(zn−1,zn)µf

n−1→zn−1(zn−1). (13.49)

µf

zn−1

If we now recall the deﬁnition (13.46), and if we deﬁne

α(zn) = µf

n→zn(zn) (13.50)

then we obtain the alpha recursion given by (13.36). We also need to verify that the quantities α(zn) are themselves equivalent to those deﬁned previously. This is easily done by using the initial condition (8.71) and noting that α(z1) is given by h(z1) = p(z1)p(x1|z1) which is identical to (13.37). Because the initial α is the same, and because they are iteratively computed using the same equation, all subsequent α quantities must be the same.

Next we consider the messages that are propagated from the root node back to the leaf node. These take the form

�

n+1→fn(zn) =

fn+1(zn,zn+1)µf

n+2→fn+1(zn+1) (13.51)

µf

zn+1

where, as before, we have eliminated the messages of the type z → f since the variable nodes perform no computation. Using the deﬁnition (13.46) to substitute for fn+1(zn,zn+1), and deﬁning

β(zn) = µf

n+1→zn(zn) (13.52)
