[Page 5]

For completeness, we note that it is possible to have reasonable barcodes for multiparameter persistence modules if we allow ‘bars’ to occur with negative multiplicity. This leads to so-called signed barcodes . Furthermore, there are several special classes of multiparameter persistence modules which do admit an interval decomposition (note that we did not formally deﬁne what an interval is in the poset-setting!). This is true in particular for so-called interlevel persistence . We will not discuss this further here.

## 9.2.2 Other representations and visualizations

Even though we cannot hope for a barcode-like representation of multiparameter persistence modules, there are still several useful (partial) representations available. We mention just three of them here:

- The Hilbert-function of a p.f.d. persistence module indexed by P sends p 2 P to dim U p 2 . It can be thought of as a ‘homological heatmap’.
- The rank-invariant of sends a pair ( p,p 0 ) , p p 0 to the rank rank ( u p,p 0 ) of the map between U p and U 0 p . Note that any two modules with ⇠ = have the same rank invariant. For modules indexed by , this implication also holds in the other direction. However, for general P , there exist nonisomorphic modules with the same rank-invariant;
- Let L : t 7! ta + b be an aﬃne line in 2 with non-negative slope. Then the restriction L of a persistence module indexed by 2 to the line L can be viewed as a persistence module indexed by (with its usual, total ordering). The Fibered Barcode of sends each such line L to the barcode B ( L ) . This idea can be extended to lines in n ;


Exercise 9.14. Show that the rank-invariant of an 2 -persistence module can be recovered from its ﬁbered barcode, and vice versa.

The RIVET software package ( rivet.readthedocs.io ) allows you to compute and visualize each of the invariants above for (among others) the degree-Rips biﬁltration.

## 9.3 Distances and robustness for P -persistence modules

As we generally do not have barcodes for P -persistence modules, we cannot rely on the Bottleneck distance to compare them. Instead, we work directly with interleaving distance, which is still well-deﬁned. For simplicity, we only consider P = n .

Deﬁnition 9.15. Write 1 = ( 1,1,...,1 ) 2 n . Two n -persistence modules , are ✏ -interleaved if there exist two families of linear maps, ' a : U a ! V a + ✏ 1 and
