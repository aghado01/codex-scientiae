[Page 2]

Deﬁnition 9.1. A poset (partially ordered set) is a tuple ( P, ) consisting of a set P and a binary relation on P satisfying

- a a for all a 2 P ;
- a b and b a implies a = b for all a,b 2 P ;


a /precedesequal b and b /precedesequal c implies a /precedesequal c for all a, b, c ∈ P ;

We will sometimes simply write P if the (partial) ordering is clear from context.

Note that partial orderings allow for elements to be incomparable , i.e., it can happen for a,b 2 P that neither a b nor b a holds. In contrast, under a total ordering all elements in P must be comparable. All the posets we will see in this chapter are constructed from the following examples:

- The reals = ( , 6 ) and natural numbers = ( , 6 ) with their usual ordering are posets.
- If ( P, ) is a poset, and Q ✓ P , then ( Q, ) is a poset;
- For any poset ( P, ) , we have the opposite poset P op = ( P, ⌫ ) ,


/precedesequal op /followsequal , where

$$
a \preceq b \iff b \preceq a \quad \text {for all $a,b\in P$} .
$$

- For two posets ( P, P ) and ( Q, Q ) we have the product poset ( P ⇥ Q, ) , where

$$
( p , q ) \preceq ( p ^ { \prime } , q ^ { \prime } ) \iff p \preceq _ { P } p ^ { \prime } \text { and } q \preceq _ { Q } q ^ { \prime } \quad \text {for all } p , p ^ { \prime } \in P \text { and } q , q ^ { \prime } \in Q .
$$

We can now deﬁne ﬁltrations and persistence modules indexed by an arbitrary poset, generalizing our deﬁnitions from earlier chapters.

Deﬁnition 9.2. Let ( P, ) be a poset. A family ( X p ) p 2 P of topological spaces (or simplicial complexes) is called a P -ﬁltration if X p ✓ X p 0 for all p,p 0 2 P with p p 0 .

Deﬁnition 9.3. Let ( P, ) be a poset, and let be a ﬁeld. A P -persistence module (over ) consists of

- An -vector space U p for each p 2 P ;
- A linear map u p,p 0 : U p ! U p 0 for each p,p 0 2 P with p p 0 , satisfying u p 2 ,p 3 u p 1 ,p 2 = u p 1 ,p 3 for all p 1 ,p 2 ,p 3 2 P with p 1 p 2 p 3 .


′ ′ ◦ ∈ /precedesequal /precedesequal

Observation 9.4. If ( X p ) p 2 P is a P -ﬁltration for some poset P , then taking k -dimensional homology gives us a P -persistence module H k ( X p ) (where, as before, the maps u p,p 0 : H k ( X p ) ! H k ( X p 0 ) are induced by the inclusions X p , ! X p 0 ).
