[Page 18]









![The image shows a geometric figure with several points and lines. Here are the details: 1. **Points and Lines**: - There are 6 points labeled as A, B, C, D, E, and F. - The lines connecting these points are labeled as AB, BC, CD, DA, EF, and FF. 2. **Triangles**: - There are 3 triangles labeled as A, B, C, and D. - The triangles are labeled as A, B, C, and D. 3. **Geometric Properties**: - The figure is a parallelogram, which is a quadrilateral with opposite sides parallel to each other. - The diagonals of the parallelogram are equal in length. - The angle bisectors of the parallelogram are equal in length. 4. **Geometric Properties**: - The angle subtended by an arc at the center of the parallelogram is](<DLST2026/imageFile9.png>)

Figure 11. Example of the finest block partition (brown sets in the left panel) and the corresponding finest Morse decomposition (green sets in the right panel) for a multivector field V from Figure 9 .

For our purposes we allow A and/or R to be empty.

Proposition 4.15. Let B = { B a ,B r } be a two-element block decomposition of an isolating block B such that r ̸ < a . Then ( M a ,M r ) : = (Inv V B a , Inv V B r ) is an AR-pair for S : = Inv V B .


Proof. By Proposition 4.10 , the pair M : = { M a ,M r } is a Morse decomposition of S as long as both are not empty. However, if M a and/or M b is empty the below argument remains virtually the same.

To show that M a is an attractor, suppose that there exists an x ∈ ( F V ( M a ) ∩ S ) \ M a . Since S is invariant there exists φ ∈ eSol V ( x,S ). We also have p ∈ { a,r } such that uim + ( φ ) ⊂ M p , because M is a Morse decomposition of S . If p = a then we can take y ∈ M a such that x ∈ F V ( y ) and ρ ⊂ φ such that ρ ⊏ = x and ρ ⊐ ∈ M a ; but then, path y · ρ implies x ∈ im ρ ⊂ M a contradicting (M2)(b) . Putting p = r , we can construct a similar path, but with ρ ⊐ ∈ M r , then y · ρ and (M2)(a) imply r < a , again a contradiction. Hence, M a is an attractor in S .

To show that Inv V ( S \ A ) = M r we notice first that B r ⊂ B \ A immediately implies M r = Inv V B r ⊂ Inv V B \ A . To see the other inclusion consider φ ∈ eSol V ( S \ M a ). Since M is a Morse decomposition we have uim ± V φ ⊂ M r , thus im φ ⊂ M r by (M2)(b) . □

# 4.3. Conley Index.

Definition 4.16. (Index pair) [ 33 , Definition 5.1] A pair of closed sets ( P,E ) such that E ⊂ P is an index pair for the isolated invariant set S if the following conditions hold:

(IP1) F V ( P \ E ) ⊂ P

(the exit set condition), F V ( E ) ∩ P ⊂ E (the positive invariance condition), S = Inv V ( P \ E ) (the invariant part condition).

- (IP2) F V ( E ) ∩ P ⊂ E
- (IP3) S = Inv V ( P \ E


It is easy to verify that P \ E is an isolating block. When we say that ( P,E ) is an index pair for an isolating block B we mean that ( P,E ) is an index pair for Inv B and B ⊂ P \ E . The following proposition is an immediate consequence of Proposition 4.3 and [ 18 , Proposition 9].
