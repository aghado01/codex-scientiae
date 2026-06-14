[Page 12]

Definition 2.2. The poset P is regarded as a category as follows. The set P 0 of objects is defined by P 0 : = P . For each pair ( x,y ) ∈ P × P , the set P ( x,y ) of morphisms from x to y is defined by P ( x,y ) : = { p y,x } if x ≤ y , and P ( x,y ) : = ∅ otherwise, where we set p y,x : = ( y,x ) . The composition is defined by p z,y p y,x = p z,x for all x,y,z ∈ P with x ≤ y ≤ z . The identity 1 l x at an object x ∈ P is given by 1 l x = p x,x .

- (1) The incidence category k [ P ] of P is defined as the k -linearization of the category P . Namely, it is a k -linear category defined as follows. The set of objects k [ P ] 0 is equal to P , for each pair ( x,y ) ∈ P × P , the set of morphisms k [ P ]( x,y ) is the vector space with basis P ( x,y ) ; thus it is a one-dimensional vector space k p y,x if x ≤ y , or zero otherwise. The composition is defined as the k -bilinear extension of that of P . Note that k [ P ] is a finite k -linear category.
- (2) Covariant ( k -linear) functors k [ P ] → mod k are called persistence modules over or indexed by P .


In the sequel, we set [ ≤ ] P : = { ( x,y ) ∈ P × P | x ≤ y } , and A : = k [ P ] (therefore, A 0 = P ), and so the category of finite-dimensional persistence modules is denoted by mod A .

Definition 2.3. Let I be a nonempty full subposet of P .

- (1) For any ( x,y ) ∈ [ ≤ ] P , we set [ x,y ] : = { z ∈ P | x ≤ z ≤ y } , and call it the segment from x to y in P .
- (2) A source (resp. sink ) of I is nothing but a minimal (resp. maximal) element in I . The set of all sources (sinks) of I is denoted by sc( I ) (resp. sk( I ) ). If I has the maximum (resp. minimum) element, then it is denoted by max( I ) (resp. min( I ) ). By convention, we set sc( ∅ ) : = ∅ and sk( ∅ ) : = ∅ .
- (3) I is said to be connected if for all x,y ∈ I , there is a sequence of elements x = z 0 ,z 1 ,...,z n − 1 ,z n = y in I satisfying that every two consecutive elements z i and z i +1 are comparable. Namely, either z i ≤ z i +1 or z i +1 ≤ z i holds for i = 0 ,...,n − 1 .
- (4) I is said to be convex if for any x,y ∈ I with x ≤ y , we have [ x,y ] ⊆ I .
- (5) I is called an interval if I is connected and convex.
- (6) The set of all intervals of P is denoted by I ( P ) , or simply by I . We regard I as a poset I = ( I , ≤ ) with the inclusion relation: I ≤ J ⇔ I ⊆ J for all I,J ∈ I . Since P is finite, I is also finite.


Note that any segment [ x,y ] is an interval with source x and sink y . Following Blanchette et al. ( 2024 ), we introduce the subsequent definition.

Definition 2.4. A subset K of P is called an antichain in P if every two distinct elements of K are incomparable under the partial order of P . We denote by Ac( P ) the set of all antichains in P . For any K,L ∈ Ac( P ) , we define K ≤ L if for all x ∈ K , there exists z x ∈ L such that x ≤ z x , and for all z ∈ L , there exists x z ∈ K such that x z ≤ z .
