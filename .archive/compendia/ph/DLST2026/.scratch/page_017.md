[Page 17]

Example 4.11. The four isolating blocks in Figure 10 (left) form a block decomposition B = { B 1 ,B 2 ,B 3 ,B 4 } of K for multivector field V , and the three isolated invariant sets shown in the right panel form the Morse decomposition M = { M 1 ,M 2 ,M 3 } . In particular, B covers M , that is B • = M . The graph in the middle of Figure 10 shows the flow induced partial order on P . ♢

A Morse decomposition M of S is said to be the finest if for any other Morse decomposition M ′ of S we have M ⊑ M ′ . We define the finest block decomposition and the finest block partition analogously. In particular, the finest Morse decomposition and the finest block decomposition coincide.

Finally, we evoke the result showing that the finest block partition, which always exists, can be easily obtained from G V , which in turn, gives the finest Morse decomposition. The following theorem is a direct consequence of the proof of [ 33 , Theorem 7.3] and Proposition 4.10 .

Theorem 4.12 (Decomposition by scc) . Let V be a multivector field on X . Then the family of strongly connected components of the graph G V forms the finest block partition B of X with respect to V . Moreover, B • is the finest Morse decomposition of X .

Example 4.13. Figure 11 illustrates another block and Morse decomposition for the multivector field V from Example 4.1 . Here, we have block decomposition B ′ = { B ′ 1 ,B ′ 2 ,B ′ 3 ,B ′ 4 ,B ′ 5 ,B ′ 6 ,B ′ 7 } . In fact, B ′ is the finest block partition of X (although, not the finest block decomposition, which would consists of { B ′ 1 ,B ′ 3 ,B ′ 4 ,B ′ 7 } ), because the union of blocks in B ′ gives the entire complex, and there is no room for a further refinement. Note, that breaking B ′ 1 into smaller pieces would violate both conditions (B1) and (B2) . The Morse decomposition M ′ = { M ′ 1 ,M ′ 2 ,M ′ 3 ,M ′ 4 } is the finest Morse (and block) decomposition and it is covered by B ′ , that is M ′ = B ′ • , . In particular, compared to M from Example 4.11 , we have M ′ ⊑ M . Note, that in case of B and B ′ we have neither B ⊑ B ′ nor B ′ ⊑ B . ♢

Finally, we introduce a special type of Morse and block decomposition, namely the attractor-repeller pair. An isolated invariant set A is an attractor (relative) to S if F V ( A ) ∩ S = A . Equivalently, an isolated invariant set is an attractor in S if it is closed in S , that is S ∩ cl A = A [ 33 , Theorem 6.2]. Analogously an isolated invariant set R is a repeller (relative) to S if F − 1 V ( R ) ∩ S = R . Equivalently, an isolated invariant set R is a repeller in S if it is open in S , that is S ∩ opn R = R [ 33 , Theorem 6.3].

Definition 4.14 (Attractor-repeller pair) . Let S be an isolated invariant set. Then a pair of isolated invariant sets A,R ⊂ S is an attractor-repeller pair (or an AR-pair ) if A is an attractor in S and R = Inv V S \ A . In particular, R is called
