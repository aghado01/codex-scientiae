[Page 4]

Example 4. The surface in Figure 2 has Morse function f defined by projection onto the horizontal axis. Instances of open, closed and half-open intervals all occur in DgmZZ( f ) . The short closed interval on the left can be identified by considering part of the levelset zigzag sequence

$$
$$
\mathbb { X } _ { 0 } ^ { 0 } \rightarrow \mathbb { X } _ { 0 } ^ { 1 } \leftarrow \mathbb { X } _ { 1 } ^ { 1 } \rightarrow \mathbb { X } _ { 1 } ^ { 2 } \leftarrow \mathbb { X } _ { 2 } ^ { 2 } \rightarrow \dots .
$$
$$

and applying H 1 to get the following diagram of vector spaces, spanned by the indicated basis vectors:

$$
$$
0 \to \langle \alpha , \beta \rangle \gets \langle \alpha , \beta \rangle \to \langle \alpha , \beta \rangle \stackrel { g } { \leftarrow } \langle \gamma \rangle \to \dots
$$
$$

The map g is defined by g ( γ ) = α + β . This part of the diagram may be decomposed as a direct sum of

$$
$$
0 \to \langle \alpha \rangle \leftarrow \langle \alpha \rangle \to \langle \alpha \rangle \leftarrow 0 \to \dots
$$
$$

with

$$
$$
0 \to \langle \alpha + \beta \rangle \gets \langle \alpha + \beta \rangle \to \langle \alpha + \beta \rangle \gets \langle \gamma \rangle \to \dots
$$
$$

from which we infer the interval [ X 1 0 , X 2 1 ] or [ a 1 , a 2 ] .

Levelset zigzag persistence has two useful properties that follow almost tautologically from the definitions. The first property is locality . The zigzag diagram associated to a slice X I and the restricted function f I is always a subdiagram of the zigzag diagram associated to the original ( X , f ). Thus, there is an immediate bijection between levelset zigzag intervals of ( X , f ) which meet I , and levelset zigzag intervals of ( X I , f I ). The second property is symmetry : ( X , f ) and ( X , − f ) have the same levelset zigzag intervals after reflection. Indeed, the associated zigzag diagrams are isomorphic by reflection.

Pyramid. Given ( X , f ) of Morse type, we construct a gigantic commutative diagram which resembles a pyramid viewed from above. At the nodes of the diagram are spaces or relative pairs derived from the slices of X . The south face contains the slices, X j i with i ≤ j , themselves. The west face contains the pairs ( X j 0 , X i 0 ) with i ≤ j . The east face contains the pairs ( X n i , X n j ) with i ≤ j . Finally, the north face contains the pairs ( X n 0 , X i 0 ∪ X n j ) with i < j . These spaces and pairs are assembled in the manner suggested by Figure 3, which depicts the case n = 3. Degenerate pairs of the form ( X i 0 , X i 0 ) or ( X n j , X n j ) are shown compactly as ∅ . The arrows represent inclusion maps.

The remarkable property of this pyramid is that the diamonds are Mayer–Vietoris. Indeed, each diamond is an instance of

$$
$$
\begin{CD}
( A_1 \cup A_2 , B_1 \cup B_2 ) @>>> ( A_1 , B_1 ) \\
@VVV @VVV \\
( A_2 , B_2 ) @>>> ( A_1 \cap A_2 , B_1 \cap B_2 )
\end{CD}
$$
$$

![image 4](<CDSM2009/imageFile4.png>)









which is the prescribed configuration for the relative Mayer– Vietoris theorem [14].

From the pyramid we can extract a profusion of zigzag diagrams. Most relevant to us are the monotone zigzags, which stretch from the western edge to the eastern edge without backtracking. These have 2 n +1 nodes, excluding the initial and terminal ∅ . The four most important monotone zigzags are those constructed out of the highlighted (solid) arrows in Figure 3. The levelset zigzag tracks the southern edge of the pyramid.

Pyramid Theorem . Let ( X , f ) be of Morse type. Any two monotone zigzags X 1 , X 2 in the pyramid diagram carry the same information in their persistent homology. Moreover, there exists an explicit bijection between Pers( H ∗ ( X 1 )) and Pers( H ∗ ( X 2 )), which respects homological dimension except for possible shifts of degree ± 1.

Proof. We include both the initial and final ∅ in our description of each X i . Then X 1 can be transformed to X 2 by a sequence of diamond moves (which transform the persistence intervals bijectively, by the Diamond Lemma) and shifts of either terminal ∅ (which have no effect on the intervals). Thus X 1 , X 2 carry the same zigzag persistence information.

To construct the bijection explicitly, it is enough to track the birth and death of each interval type through the transformation process. Diamond moves transform births in the following way:

![image 5](<CDSM2009/imageFile5.png>)




In other words, if the arrow immediately to the left of the birth points northwest then the birth travels along the southwest–northeast axis . Whereas, if the arrow immediately to the left of the birth points northeast then the birth travels along the southeast–northwest axis .

Similarly, diamond moves transform deaths in the following way:

![image 6](<CDSM2009/imageFile6.png>)




In other words, if the arrow immediately to the right of the death points northwest then the death travels along the southwest–northeast axis . Whereas, if the arrow immediately to the right of the death points northeast then the death travels along the southeast–northwest axis .

The simplifying observation is that the axis of travel, once determined, remains fixed for each birth or death. There are two exceptions to this. If a birth or death reaches the east or west extreme, then it ‘bounces’ and changes travel direction thereafter. If a birth collides with its associated death (so the persistence interval is supported on one node only) in the north or south node of a diamond, then that diamond move causes the following transformation with a dimension shift of +1 from the left configuration to the right configuration:

![image 7](<CDSM2009/imageFile7.png>)


Note that if all the diamond moves are taken in the same direction (downwards, say), then any given interval type is afflicted by at most one dimension-shifting incident. Indeed, after such an incident the birth and death are travelling away from each other and do not have time to bounce off the walls and meet again. By comparing X 1 and X 2 to the levelset zigzag in such a way, it can be verified that the composite transformation between Pers( H ∗ ( X 1 )) and Pers( H ∗ ( X 2 )) does not shift any intervals in dimension by more than 1.  

In principle, the rules outlined in the proof of the Pyramid Theorem can be used to determine the interval transformation law between any pair of monotone zigzags. As an example, Figure 4 illustrates the transformation between
