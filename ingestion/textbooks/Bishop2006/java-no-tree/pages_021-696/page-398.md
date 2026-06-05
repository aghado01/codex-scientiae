[Page 398]

and so p(F = 0|G = 0) > p(F = 0). Thus observing that the gauge reads empty makes it more likely that the tank is indeed empty, as we would intuitively expect. Next suppose that we also check the state of the battery and ﬁnd that it is ﬂat, i.e., B = 0. We have now observed the states of both the fuel gauge and the battery, as shown by the right-hand graph in Figure 8.21. The posterior probability that the fuel tank is empty given the observations of both the fuel gauge and the battery state is then given by

p(G = 0|B = 0,F = 0)p(F = 0) F∈{0,1} p(G = 0|B = 0,F)p(F)

p(F = 0|G = 0,B = 0) =

0.111 (8.33)

where the prior probability p(B = 0) has cancelled between numerator and denominator. Thus the probability that the tank is empty has decreased (from 0.257 to 0.111) as a result of the observation of the state of the battery. This accords with our intuition that ﬁnding out that the battery is ﬂat explains away the observation that the fuel gauge reads empty. We see that the state of the fuel tank and that of the battery have indeed become dependent on each other as a result of observing the reading on the fuel gauge. In fact, this would also be the case if, instead of observing the fuel gauge directly, we observed the state of some descendant of G. Note that the probability p(F = 0|G = 0,B = 0) 0.111 is greater than the prior probability p(F = 0) = 0.1 because the observation that the fuel gauge reads zero still provides some evidence in favour of an empty fuel tank.

###### 8.2.2 D-separation

We now give a general statement of the d-separation property (Pearl, 1988) for directed graphs. Consider a general directed graph in which A, B, and C are arbitrary nonintersecting sets of nodes (whose union may be smaller than the complete set of nodes in the graph). We wish to ascertain whether a particular conditional independence statement A ⊥ B | C is implied by a given directed acyclic graph. To do so, we consider all possible paths from any node in A to any node in B. Any such path is said to be blocked if it includes a node such that either

(a) the arrows on the path meet either head-to-tail or tail-to-tail at the node, and the

node is in the set C, or

(b) the arrows meet head-to-head at the node, and neither the node, nor any of its

descendants, is in the set C.

If all paths are blocked, then A is said to be d-separated from B by C, and the joint distribution over all of the variables in the graph will satisfy A ⊥ B | C.

The concept of d-separation is illustrated in Figure 8.22. In graph (a), the path from a to b is not blocked by node f because it is a tail-to-tail node for this path and is not observed, nor is it blocked by node e because, although the latter is a head-to-head node, it has a descendant c because is in the conditioning set. Thus the conditional independence statement a ⊥ b | c does not follow from this graph. In graph (b), the path from a to b is blocked by node f because this is a tail-to-tail node that is observed, and so the conditional independence property a ⊥ b | f will
