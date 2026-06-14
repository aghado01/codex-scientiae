[Page 21]


![In this image, we can see a graph.](<DLST2026/imageFile10.png>)

Figure 12. The poset of ( MVF ( X ) , ⊑ ) for simplicial complex X .

Definition 4.25 (Combinatorial continuation of an isolated invariant set) . [ 18 , Definition 10] Let V 0 ⊑ V 1 or V 0 ⊒ V 1 . An isolated invariant set S 0 in V 0 continues to S 1 in V 1 if there exists a set B , which is an isolating block both in V 0 and V 1 , and Inv V 0 B = S 0 and Inv V 1 B = S 1 .

The above definition differs from the one introduced in [ 18 ], but they are equivalent through Proposition 4.17 . Moreover, the concept of continuation can be easily extended to any parametrized multivector field V . In particular, S 0 in V 0 continues to S T in V T if there is a sequence S 0 ,S 1 ,...,S T , where S λ is an isolated invariant set in V λ and S λ continues to S λ +1 for each λ . Intuitively, if an isolated invariant set continues to another, then they play the same qualitative role in the corresponding dynamical systems; in particular, their Conley indices are isomorphic.

Theorem 4.26. [ 18 , Theorem 22] If the isolated invariant set S continues to S ′ then Con( S ) ∼ = Con( S ′ ).

# 5. Transition Diagram for a Zigzag Filtration of Block Decompositions

The notion of continuation identifies isolated invariant sets at different steps of a parameterization and relates their Conley indices directly via isomorphisms. In [ 18 ], we explored how persistence can be used to capture changes in a Conley index. Here, we take the next step and develop a framework that allows us to track all Conley indices simultaneously, providing additional insight into their mutual interactions and encoding the nature of these changes.

5.1. Filtration of block decompositions. Let V = {V λ } λ ∈ Λ be a parameterized multivector field and M = { ( M λ , V λ ) } λ ∈ Λ be the corresponding Morse decompositions, such that, for each λ , M λ is a Morse decomposition for V λ . To track the changes we require the existence of a sequence of covering block decompositions B = { ( B λ , V λ ) } λ ∈ Λ (that is, B λ • = M λ for each λ ∈ Λ) forming a zigzag filtration as defined below.
