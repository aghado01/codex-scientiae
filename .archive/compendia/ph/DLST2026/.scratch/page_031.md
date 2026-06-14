[Page 31]





)









)

•,0

•,0

![In this image we can see a diagram with some lines and some points.](<DLST2026/imageFile14.png>)







)



)










⊃ ∙ ∙








)



)















)



)

∙∙∙

















)



)

∙∙∙















)


,E ★

)

∙∙∙














,E ▼

)



)

∙∙∙

















)



)

∙∙∙

















)


,E ○

)

∙∙∙












Figure 17. Transition diagram for the first four steps of the zigzag filtration B from Example 5.3 (see also Figure 14 ).

blocks in Figure 17 represent such comparisons for B 0 ⊒ B 1 , B 1 ⊑ B 2 and B 2 ⊒ B 3 , from left to right, respectively. In each we have one AR-split diagram from step 1.1. and one equality from step 1.2. .

We construct index pairs for each pair of block decompositions independently; therefore P ⊢ p,λ ,E ⊢ p,λ and P ⊣ p,λ ,E ⊣ p,λ may differ. Thus, in the second step of the construction we join the comparison blocks using connection sequences introduced in Section 4.4 (see equation ( 4.5 )); they are represented in Figure 17 with the blue strips.

Note that in the top part of Figure 17 we indicate for which multivector field the given index pairs are well defined. For instance, since we have B 0 ⊒ B 1 , the index pair ( P • , 0 ,E • , 0 ) corresponding to B • , 0 is also a proper index pair for V 1 . It is the key fact that allows us to decompose B • , 0 in V 1 into B ⋆, 1 and B ◦ , 1 , which we utilized in Theorem 5.7 . ♢

We close the section with a straightforward, yet crucial property of acyclicity of the transition diagram.

Proposition 5.16. The digraph obtained from a transition diagram by taking the set of index pairs as nodes and the directed arrows given by inclusions is acyclic. In particular, its transitive closure is a partially ordered set; we call it the transition diagram induced partial order .

Proof. On the contrary, assume that there exists a loop in the induced graph. Consider a minimal loop. It corresponds to a sequence of index pairs such that ( P 0 ,E 0 ) ⊂ ( P 1 ,E 1 ) ⊂ ... ⊂ ( P n ,E n ) = ( P 0 ,E 0 ), which implies that all index pairs in the loop are equal. Necessarily, there exists an i such that index pairs ( P i ,E i ) is at step λ and index pairs ( P i − 1 ,E i − 1 ) and ( P i +1 ,E i +1 ) are at step λ − 1 and λ +1, respectively. This configuration is possible only if the three index pairs form an AR-split. Note that by Definition 5.11 , the index pairs cannot be equal, a contradiction. □
