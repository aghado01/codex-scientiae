[Page 649]

Finally, we note that there is an alternative formulation of the forward-backward algorithm (Jordan, 2007) in which the backward pass is deﬁned by a recursion based the quantities γ(zn) = α�(zn)β�(zn) instead of using β�(zn). This α–γ recursion requires that the forward pass be completed ﬁrst so that all the quantities α�(zn) are available for the backward pass, whereas the forward and backward passes of the α–β algorithm can be done independently. Although these two algorithms have comparable computational cost, the α–β version is the most commonly encountered

Section 13.3 one in the case of hidden Markov models, whereas for linear dynamical systems a

recursion analogous to the α–γ form is more usual.

13.2.5 The Viterbi algorithm

In many applications of hidden Markov models, the latent variables have some meaningful interpretation, and so it is often of interest to ﬁnd the most probable sequence of hidden states for a given observation sequence. For instance in speech recognition, we might wish to ﬁnd the most probable phoneme sequence for a given series of acoustic observations. Because the graph for the hidden Markov model is a directed tree, this problem can be solved exactly using the max-sum algorithm. We recall from our discussion in Section 8.4.5 that the problem of ﬁnding the most probable sequence of latent states is not the same as that of ﬁnding the set of states that are individually the most probable. The latter problem can be solved by ﬁrst running the forward-backward (sum-product) algorithm to ﬁnd the latent variable marginals γ(zn) and then maximizing each of these individually (Duda et al., 2001). However, the set of such states will not, in general, correspond to the most probable sequence of states. In fact, this set of states might even represent a sequence having zero probability, if it so happens that two successive states, which in isolation are individually the most probable, are such that the transition matrix element connecting them is zero.

In practice, we are usually interested in ﬁnding the most probable sequence of states, and this can be solved efﬁciently using the max-sum algorithm, which in the context of hidden Markov models is known as the Viterbi algorithm (Viterbi, 1967). Note that the max-sum algorithm works with log probabilities and so there is no need to use re-scaled variables as was done with the forward-backward algorithm. Figure 13.16 shows a fragment of the hidden Markov model expanded as lattice diagram. As we have already noted, the number of possible paths through the lattice grows exponentially with the length of the chain. The Viterbi algorithm searches this space of paths efﬁciently to ﬁnd the most probable path with a computational cost that grows only linearly with the length of the chain.

As with the sum-product algorithm, we ﬁrst represent the hidden Markov model as a factor graph, as shown in Figure 13.15. Again, we treat the variable node zN as the root, and pass messages to the root starting with the leaf nodes. Using the results (8.93) and (8.94), we see that the messages passed in the max-sum algorithm are given by

n→zn(zn) (13.66) µf

n→fn+1(zn) = µf

µz

�

�

n+1→zn+1(zn+1) = max

lnfn+1(zn,zn+1) + µz

n→fn+1(zn)

. (13.67)

zn
