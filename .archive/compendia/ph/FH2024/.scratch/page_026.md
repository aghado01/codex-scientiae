[Page 26]

# 7 Discussion

In this paper, we applied persistent homology to time series by regarding special kind of persistent modules which we call extended zigzag modules. The main advantage over the existing techniques is that one calculates features that are persistent simultaneously in space and time direction by combining ideas from multiparameter and zigzag persistent homology. We proposed a way of visualization by defining spatiotemporal persistence landscapes for the extended zigzag modules. Furthermore, we define an interleaving distance for extended zigzag modules and proof stability of the spatiotemporal persistence landscapes with respect to the interleaving distance. To summarize, we defined a stable invariant taking values in a Banach space that carries useful statistical properties and can be used as an input for machine learning algorithms.

Since the behavior of the homological features can be observed over several spatial scales, one can utilize the landscapes to detect a suitable spatial scale to compute the ordinary zigzag persistent homology. In other applications, where zigzag homology was applied to time series [38], it was a priori not clear how to choose a good spatial scale on which the persistence of features in time was observed. Our spatiotemporal persistence landscapes overcome this issue.

However, currently one disadvantage is the large computational cost and the high memory consumption. For every index in the parameter space one has to compute the persistence landscape as the barcode of a zigzag module through the parameter space. The application of techniques to reduce the size of the simplicial complex is expected to speed up the calculations as well as to reduce the storage needed.

# Acknowledgments

This work has been supported by the German Federal Ministry of Education and Research (BMBF-Projekt 05M20WBA und 05M20WWA: Verbundprojekt 05M2020 DyCA). The first author (M.F.) thanks Michael Kerber (Graz University of Technology, Austria) for useful discussions.

# A Categorical definitions

In this section, we revise some necessary categorical definitions. Let C be a category.

# A.1 Limits and Colimits

Definition A.1 A diagram F indexed by a poset ( P, ≤ ) is a functor from the poset category P to C , i.e. every p ∈ P is mapped to an object F p in C and any p ≤ q to a morphism ϕ p,q : F p → F q in C , such that for any p ≤ q and q ≤ r , it holds that ϕ q,r ◦ ϕ p,q = ϕ p,r .

Definition A.2 Let F : ( P, ≤ ) → C be a diagram indexed by ( P, ≤ ) . A cone of F is an object A of C together with a family ( ρ p ) p ∈ P of morphisms ρ p : A → F p , such that for any morphism ϕ p,q : F p → F q we have that ρ q = ϕ p,q ◦ ρ p .

A limit of the diagram F is a universal cone in the following sense: it is a cone ( L, ( ψ p ) p ∈ P )
