[Page 37]

Proposition 5.24 follows immediately from the next lemma.

Lemma 5.28. The sets { N p } p defined in formula ( 5.4 ) have the following properties:

- (a) Let p ∈ P 0 . Then B p, 0 ⊂ N p \ N p − 1 . 1
- (b) Let q ∈ P 1 , Q : = −→ ι − ( q ) and p : = max Q . Then B q, 1 ⊂ N p \ N p −| Q | .


Proof. By definition, B p, 0 ⊂ pf V 0 ( B p, 0 ,X ) ⊂ N p . Suppose that there exists an x ∈ B p, 0 ∩ N p − 1 . Since x ∈ N p − 1 we have two cases corresponding to formula ( 5.4 ); in the first one, there exists a p ′ ∈ P such that p ′ < p and x ∈ pf V 0 ( B p ′ , 0 ,X ); but x is also in B p, 0 , therefore there is a path ρ ∈ Paths V 0 ( B p ′ , 0 ,B p, 0 ,X ), and by (B2) we have p < p ′ , which is a contradiction. In the second case, there exists a p ′ ∈ P such that p ′ < p , q ′ : = −→ ι ( p ′ ) and x ∈ pf V 1 ( B q ′ , 1 ,X ). By the same argument, we can find a path ρ ′ ∈ Paths V 1 ( B q ′ , 1 ,B p, 0 ,X ). Since B p, 0 ⊂ B q, 1 , ρ is also a path from B q ′ , 1 to B q, 1 in V 1 . Thus, we obtain q < q ′ ; but p ′ < p implies −→ ι ( p ′ ) = q ′ < q = −→ ι ( p ), which gives a contradiction. Hence, (a) is proved.

For the second statement it is clear that B q, 1 ⊂ pf V 1 ( B q, 1 ,X ) ⊂ N p . To see that B q, 1 ∩ N p −| Q | = ∅ assume the contrary, that is, suppose there exists an x ∈ B q, 1 ∩ N p −| Q | . Again, we have two cases; in the first one there exists a p ′ ∈ P such that p ′ ≤ p − | Q | and x ∈ pf V 0 ( B p ′ , 0 ,X ). Therefore, there is a path ρ ∈ Paths V 0 ( B p ′ , 0 ,B q, 1 ,X ), which implies q < −→ ι ( p ′ ), but this contradicts the filtration consistent order assumption, in particular p ′ < p implies −→ ι ( p ′ ) < −→ ι ( p ) = q . In the second case, there exists a p ′ ∈ P such that p ′ ≤ p − | Q | , q ′ : = −→ ι ( p ′ ) and x ∈ pf V 1 ( B q ′ , 1 ). Therefore, Paths V 1 ( B q ′ , 1 ,B q, 1 ,X ) ̸ = ∅ , and again we obtain q < q ′ , while the assumption p ′ < p implies −→ ι ( p ′ ) = q ′ < q = −→ ι ( p ), which is a contradiction. □


In the following proofs we will also use the following remark which is an immediate corollary of Lemma 5.10 .

Remark 5.29 . Let B = { B } be a one element block decomposition of X then Inv V B = Inv V X .

Proof of Proposition 5.25 . We prove the statement by showing that ( N p ,N p − 1 ) satisfies the conditions of Proposition 4.18 . By Proposition 4.23 , the set N p \ N p − 1 is V 0 -compatible as a difference of V 0 -compatible sets; it is also locally closed as a difference of closed sets. Hence, N p \ N p − 1 is an isolating block by Proposition 4.3 . Lemmas 5.28(a) and 5.10 imply that { B p, 0 } is a one-element block decomposition of N p \ N p − 1 . By Remark 5.29 we have Inv V 0 N p \ N p − 1 = M p, 0 , which finishes the proof. □

Proof of Proposition 5.26 . Note that for the considered situation both N p and N p −| Q | are obtained by applying the second rule of formula ( 5.4 ). Therefore, by Proposition 4.23 , the set P \ E is V 1 -compatible and locally closed as a difference of V 1 -compatible, closed sets. In particular, it is also V 0 -compatible. Hence, it is an isolating block both in V 0 and V 1 .

To show that ( P,E ) is an index pair for M Q , 0 in V 0 , note that by Theorem 5.7(a) we know that B Q : = { B p, 0 | p ∈ Q } is a block decomposition of B q, 1 . By Lemma 5.28(a) B p, 0 ⊂ P \ E when p ∈ Q and B p, 0 ∩ P \ E = ∅ when p ̸∈ Q .
