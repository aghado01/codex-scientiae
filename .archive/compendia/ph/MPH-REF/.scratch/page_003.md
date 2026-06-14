[Page 3]

We can now give two examples of ﬁltrations indexed by P = ⇥ op , each of which induces a P -persistence module via the observation above. The ﬁrst one formalizes the discussion at the beginning of the chapter. The second one applies a similar idea to the Čech complex.

Example 9.5. Let X be a ﬁnite metric space. Then the family ( r d ( X )) r 2 ,d 2 deﬁned above is a ﬁltration indexed by ⇥ op . It is called the degree-Rips biﬁltration . n

Example 9.6. Let X ✓ be a ﬁnite point cloud. For r 2 and d 2 , deﬁne

$$
\mathcal { M } \mathcal { C } _ { d } ^ { r } = \{ x \in \mathbb { R } ^ { n } \colon | B ( x , r ) \cap X | \geqslant d \} \subseteq \mathbb { R } ^ { n } .
$$

Note that, for d = 1 , this is just the union-of-balls used to deﬁne the Čech complex. The family ( MC r d ( X )) r 2 ,d 2 is a ﬁltration (of topological spaces) indexed by ⇥ op . It is called the multicover biﬁltration .

Both of the ﬁltrations above can also be thought of as indexed over 2 (after a reparameterization). In general, we call an n -ﬁltration (resp. n -persistence module) an n -parameter ﬁltration (resp. n -parameter persistence module). For n > 2 , we also say ‘multiparameter’. For n = 2 the terms biﬁltration and bipersistence module are common.

## 9.2 Representing persistence modules indexed by posets

## 9.2.1 Barcodes?

Recall that a p.f.d. persistence module indexed by can be uniquely represented by a barcode. In Chapter 6, we saw that this follows from the fact that any such can be decomposed into interval modules in a unique way:

$$
\mathbb { U } \cong \bigoplus _ { i \in I } \mathbb { I } _ { \langle a , b \rangle } .
$$

Each interval in this decomposition corresponds to a bar in the barcode of . We could hope a similar statement holds for modules indexed by any poset P . The following deﬁnition and theorem should give us some hope:

Deﬁnition 9.7. A persistence module is called indecomposable if ⇠ = 1 2 implies that 1 = 0 or 2 = 0 .

Exercise 9.8. Show that interval modules (indexed by ) are indecomposable.

Theorem 9.9. Let be a p.f.d. persistence module (indexed by a poset P ). Then, there is a unique decomposition:

$$
U \cong \bigoplus _ { i \in I } \mathbb { U } _ { i } , \\ 1 _ { i } = 1 .
$$

where each persistence module i is indecomposable.
