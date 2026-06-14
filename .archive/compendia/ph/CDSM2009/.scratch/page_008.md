[Page 8]

Case $ f_i $: We compute the representation of the boundary of simplex $ \sigma $ in terms of the cycles $ Z_i $, and then reduce the result among the boundaries, obtaining: $ \partial\sigma = Z_i v = Z_i ( B_i u + v ) $. There are two possibilities:

Birth: If v = 0, then ∂σ is already a boundary, and addition of σ creates a new cycle, for example, C i u − σ . We append this cycle to the matrix Z i , and we append i + 1 to both the birth vector b i and the index vector idx i to get b i +1 and idx i +1 , respectively.

Death: If $ v \neq 0 $, then let $ j $ be the row of the lowest nonzero element in vector $ v $. We output a pair ( b i [ j ] , i ). We append vector v to the matrix B i , and the corresponding chain ( C i u − σ ) to the matrix C i to obtain matrices B i +1 and C i +1 , respectively.



Case $ g_i $: There are once again two possibilities:

Birth: There is no cycle in matrix Z i that contains simplex σ . Let j be the index of the first column in C i that contains σ , let l be the index of the row of the lowest non-zero element in B i [ j ].

1. Prepend D i C i [ j ] to Z i to get Z i . Prepend i + 1 to the birth vector b i to get b i +1 .

2. Let c = C i [ j ][ σ ] be the coefficient of σ in the chain C i [ j ]. Let r σ be the row of σ in matrix C i . We prepend the row − r σ /c to the matrix B i to get B i .

- 3. Subtract ( r σ [ k ] /c ) · C i [ j ] from every column C i [ k ] to get C i .
- 4. Subtract ( B i [ k ][ l ] /B i [ j ][ l ]) · B i [ j ] from every other column B i [ k ].
- 5. Drop row l and column j from B i to get B i +1 , drop column l from Z i , and drop column j from C i to get C i +1 .


6. Reduce Z i +1 initially set to Z i :

- 1: while ∃ k < j s.t. low Z i +1 [ j ] = low Z i +1 [ k ] do j
- 2: s = low Z i +1 [ j ], s k = Z i +1 [ j ][ s ] /Z i +1 [ k ][ s ] j
- 3: Z i +1 [ j ] = Z i +1 [ j ] − s k · Z i +1 [ k ]
- 4: In B i +1 , add row j multiplied by s j k to row k


We set the index idx i +1 of the prepended cycle to be 1, and increase the index of every other column by 1. Figure 5 illustrates the changes made in this case.

Death: Let Z i [ j ] be the first cycle that contains simplex σ . Output ( b i [ j ] , i ).

1. Change basis to remove σ from matrix Z i :

- 1: for increasing k > j s.t. σ ∈ Z i [ k ] do k
- 2: Let σ j = Z i [ k ][ σ ] /Z i [ j ][ σ ] k
- 3: Z i +1 [ k ] = Z i [ k ] − σ j · Z i [ j ]


- 4: In B i , add row k multiplied by σ k j to row j
- 5: if low Z i +1 [ k ] > low Z i [ k ] then
- 6: j = k


- 2. Subtract cycle ( C i [ k ][ σ ] /Z i [ j ][ σ ]) · Z i [ j ] from every chain C i [ k ].

$$
$$
c _ { i } ^ { l } = \dim ( ( R _ { i } ^ { l } \cap \ K e r \, f ) / ( R _ { i } ^ { l - 1 } \cap \ K e r \, f ) ) = 1 ,
$$
$$

- 3. Drop Z i +1 [ j ], the corresponding entry in vectors b i and idx i , row j from B i , row σ from C i and Z i (as well as row and column of σ from D i ).


We increase the index of every column by 1, idx i +1 ( l ) = idx i ( l ) + 1.

We note that the sum of the columns in matrices Z and B is equal to the number of simplices in the complex. Therefore each step requires quadratic time in the worst case. As with ordinary persistence, we expect the performance on the realworld examples to be much better (closer to linear time).

Correctness. To show correctness of the above algorithm we need to show that the interval output at stage i is correct, and that the following invariant is maintained as we move from stage i to i + 1. We define Z j i = span( Z i [1 ..j ]), the subgroup of cycles spanned by the first j columns of matrix Z i ; and B = span( Z i B i ).

Invariant . B is the group of boundaries of the complex K i , and the k -th subgroup R k i of the right filtration R i is the quotient Z j i / ( Z j i ∩ B ), where j is the largest index such that idx i ( j ) does not exceed k .

Since we add or remove a single simplex at each stage of the algorithm, the rank of the homology group of the space changes by at most one. The same is true of the cycle group and the boundary group.

Map f . As with ordinary persistence, the correctness of our algorithm in the case of addition of a simplex rests on the following auxiliary lemma.

Reduction Lemma . If z is a cycle such that z = Z i v and v = B i u + v is a reduction of v among the columns of B , where v is a remainder of the reduction, then there exists a (non-trivial) cycle in Z l i with l = low( v ) homologous to z , and there does not exist a cycle in Z j i with j < l homologous to z .

Proof. Existence of a cycle in Z l i homologous to v is trivial; indeed Z l i Z i v = z − Z i B i u . Suppose that there is such a cycle in Z j i with j < l . Let it be Z j i Z i v = z + Z i B i u , low( v ) ≤ j < l . Then Z i ( v − v ) = ( z + Z i B i u ) − ( z − Z i B i u ) = Z i B i ( u + u ). Therefore, ( v − v ) = B i ( u + u ), which means that v can be reduced further, a contradiction.  

In the case where we add a simplex, the remainder vector v is 0 if and only if cycle ∂σ is a boundary in K i since the matrices Z i and B i are reduced. If it is 0, then ( C i u − σ ) is a cycle in K i +1 (it does not exist in K i ), since D i +1 ( C i u − σ ) = D i C i u − ∂σ = Z i B i u − ∂σ = 0. Since the map f is induced by inclusion, cycles Z i +1 [1 ..j ] = Z i [1 ..j ] remain bases for all f i ( R k i ) with idx i ( j ) ≤ k < idx i ( j + 1), and the last cycle ( C i u − σ ) adds the missing basis element to represent R i +1 i +1 = H ( K i +1 ). The kernel of map f is zero, and therefore nothing dies at this stage of the algorithm. 

If vector v is not zero, then let j = low( v ), and l = idx i ( j ). We know from the Reduction Lemma that there is a class ( Z i v + B ) in R l i that is homologous to the boundary of simplex σ , and there is no class homologous to ∂σ in R k i with k < l . This implies that

and the interval ( b i [ j ] , i ) we output is correct. Appending vector v to matrix B i results in matrix B i +1 whose product with Z i +1 = Z i provides a basis for the boundaries of K i +1 by construction. No changes occur to the group of cycles of K i .
