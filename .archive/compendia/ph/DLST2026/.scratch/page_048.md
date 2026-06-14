[Page 48]

![In this image there is a diagram.](<DLST2026/imageFile18.png>)


AA)

Figure 24. Choice of zigzag filtration (colored green): when the algorithm processes the point d , it chooses the zigzag filtration indicated green. While going backward, the path supporting the filtration faces a choice at a between the points b and c where it chooses the point c .

The cycle space Z ( K it ) contains the subspace of boundaries B ( K it ) ⊆ Z ( K it ). A subset of the columns of Z it constitute a basis of this boundary space. We denote the corresponding submatrix as B it ⊆ Z it and assume the column partition so that Z it = [ A it | B it ]. It follows from the fact that the quotient space Z ( K it ) / B ( K it ) represents the homology group H d ( K it ), all d -cycles given by the columns in the submatrix A it collectively provide representative cycles whose classes constitute a basis of H d ( K it ). These representative cycles also are representative cycles for all bars ending at a it which constitute a basis of the homology space H d ( K it ).

The matrix C it , on the other hand, represents a basis of the subspace of the chain space C ( K it ) in degree d + 1 whose boundaries constitute the basis in B it . We maintain the invariant that if c is a column in C it , then the boundary ∂c is a column in B it . In other words, ∂C it = B it .

8.1.1. Computing the bars. The bars for zigzag filtrations are incrementally computed as we move from time t to time t + 1 using the matrices described above.

Choice of zigzag filtration : When we arrive at point a it , we need to choose a zigzag filtration among the many that end at a it . We choose this zigzag filtration using the following procedure whose justification will become clear when we discuss the correctness of the algorithm. We move backward from a it . Assume that we have already arrived at the point a := a ∗ t ′ for t ′ ≤ t in this backward walk. If there is a single point a ′ := a ∗ ( t ′ − 1) so that a ′ and a are immediate points, we simply move to a ′ := a ∗ ( t ′ − 1) . Otherwise, there are exactly two points, say b := b ∗ ( t ′ − 1) and c := c ∗ ( t ′ − 1) where b → a and c ← a are two immediate pairs of points in P (we go against the arrow from a to b and along the arrow from a to c ). See Figure 24 . In this case, we move to c . Continuing backward this way, we obtain a unique zigzag filtration, say ZZ it , ending in a it . Implicitly we apply the algorithm in [ 21 ] on ZZ it which updates the matrices at time t to get the matrices at time t + 1. We have three cases:

Case 1: Point a it has a single immediate point a ℓ ( t +1) at time t +1 and matrices at point a ℓ ( t +1) have not been computed yet. In this case, the zigzag algorithm as described in [ 21 , Section 4.3] is applied to extend the bars for ZZ it from a it to a ℓ ( t +1) with the proper updates of the matrices.
