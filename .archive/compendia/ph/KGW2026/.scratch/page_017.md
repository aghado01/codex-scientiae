[Page 17]

- If e i,k ,e j,l / ∈ A 1 , then the second and third faces are non-admissible and

$$
\phi ( v ) \in \{ S , W \} \times \{ N _ { w } \} \times \{ N _ { w } \} \times \{ S , W \} .
$$

So far this yields a finite list of candidate patterns, but most of them are excluded by the cancellation requirement defining Ω N, 1 3 of a simple digraph.

By Lemma 3.5, all patterns whose second entry is N w but fourth entry is not S , and all patterns whose third entry is N w but first entry is not S is not in C N, 1 . The surviving patterns are

$$
( S , T , N _ { w } , T ) , ( S , S , N _ { w } , T ) , ( S , W , N _ { w } , T ) , ( T , N _ { w } , T , S ) , ( T , N _ { w } , S , S ) , ( T , N _ { w } , W , S ) , ( S , N _ { w } , N _ { w } , S )
$$

Together with ( T,T,T,T ) (for all N ≥ 2) and ( T,S,S,T ), this gives | ϕ ( C N, 1 ) | = 9 for N ≥ 2.

The significance of this classification is that every component of a minimal element of Ω N, 1 3 belongs to one of finitely many types. Consequently, the problem of identifying generators reduces to determining which sequences of these types can be combined so that all non-admissible faces cancel.

Each vertex of Γ can be labeled by its type that is listed in the previous theorem. We determine the connectivity relations between types, which encode all possible cancellations. We label components types by

$$
\gamma _ { 1 } & = ( S , T , N _ { w } , T ) , \quad \gamma _ { 2 } = ( S , S , N _ { w } , T ) , \quad \gamma _ { 3 } = ( S , W , N _ { w } , T ) , \\ \gamma _ { 4 } & = ( T , N _ { w } , T , S ) , \quad \gamma _ { 5 } = ( T , N _ { w } , S , S ) , \quad \gamma _ { 6 } = ( T , N _ { w } , W , S ) , \\ \gamma _ { 7 } & = ( S , N _ { w } , N _ { w } , S ) .
$$

The non-admissible free elements labeled as follows

$$
\gamma _ { 8 } = ( T , S , S , T ) , \gamma _ { 9 } = ( T , T , T , T )
$$

For the following lemma, one-step connectable means, they share the N w face and the linear combination of these two elements will cancel the N w component.

Lemma 3.7. The components γ i are one-step connectable only to themselves and to γ 7 for i = 1 , 2 , 4 , 5 where γ 3 and γ 6 is one-step connectable to only γ 7 . The component γ 7 is one-step connectable to all elements of L .

Proof. Let w ∈ Ω N, 1 3 be a ( a,b )-cluster so that w = w i . The existence of e a,b will create partition of patterns. Thus the elements of N a,b = { γ 2 ,γ 3 ,γ 5 ,γ 6 } is not one-step connectable to the elements of A a,b = { γ 1 ,γ 4 } where A a,b is the set of types where e a,b is admissible and N a,b is non-admissible. Furthermore, they will not be in the linear combination together with γ 1 and γ 4 for generators of Ω N, 1 3 .

Similarly, the existence of multiple e a, ∗ ,b is possible for the patterns γ 2 ,γ 5 while there is a unique e a, ∗ ,b in γ 3 ,γ 6 . This results in three different groups such as { γ 1 ,γ 4 } , { γ 2 ,γ 5 } and { γ 3 ,γ 6 }

Observe that π 2 ( γ 1 ) = 0 and π 2 ( γ 4 ) = 1 which makes them incompatible for one-step connection where π 2 and π 3 are indicator maps that is defined in the proof of Theorem 3.6. The only element of L whose image-type contains non-admissible faces at both indices 2 and 3 is γ 7 . Therefore γ 1 and γ 4 are one-step connectable only to themselves and to γ 7 . The same reason is valid for pairs ( γ 3 ,γ 6 ) and ( γ 2 ,γ 5 )

Let ϕ ( e a,j 1 ,k 1 ,b ) = γ 3 and ϕ ( e a,j 1 ,k 2 ,b ) = γ 3 be two 3-paths so that their N w components aligns where γ 3 = ( S, W, N w , T ). The pattern induces that e a,k 2 ∈ A 1 and e a,k 1 ,b is only admissible which conditions that there is no e i,l or e i, ∗ ,l . Since e i,k 2 ∈ A 1 we have e i,k 2 ,l ∈ A 2 . Therefore this one-step connection is not possible. Thus γ 3 is only one-step connectable to γ 7 . Since γ 6 = ( T, N w , W, S ) is symmetric of γ 3 = ( S, W, N w , T ), the same reason is obstacle to create one-step connection γ 6 to itself. Therefore γ 6 is only one-step connectable to γ 7 . There is no restriction to connect γ 7 to itself which proves the last part of the claim.
