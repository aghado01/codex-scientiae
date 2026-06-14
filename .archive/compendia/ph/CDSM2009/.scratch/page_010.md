[Page 10]

$$
$$
$$
\begin{array} { r l r } { c _ { i } ^ { j k } } & { = } & { \dim ( ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) / ( ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) \cup ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) ) ) } \\ & { = } & { ( \dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) ) } \\ & { \quad - ( \dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k - 1 } ) ) , } \end{array}
$$
$$
$$

and from the Reduction Lemma it follows that

$$
$$
$$
\dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) = 1
$$
$$
$$

if and only if there is a k ≤ k such that low( T [ k ]) = j .

It is therefore possible to find a levelset that splits the domain into two roughly equal halves (the sublevel set and the superlevel set), and delegate the computation of the levelset zigzag on each half to a separate processor. The idea generalizes naturally to multiple processors, although one has to take greater care of the intervals spanning more than two processors.

Interval persistence. It is not difficult to see that the pairs given by the interval persistence of Dey and Wenger [10] appear naturally in the pyramid of Section 2. As a consequence pairs defined by the interval persistence are a subset of the pairs given by the levelset zigzag. In particular, the pairs of Type III in Table 1 are not captured by the interval persistence of function f or − f . It also follows that Section 4 resolves the open question of finding an efficient algorithm to compute interval persistence. We omit the details for lack of space.

Stability. We show stability of the levelset zigzag pairs because the notion of a perturbation of the defining function with respect to which the pairs are stable is straightforward. Recently the utility of stability in contexts more general than a single function has become apparent [4, 5, 8]. However, the notions of perturbation in these papers mirror the situation with a function and take advantage of the same direction of maps between vector spaces in the ordinary persistence. What are meaningful generalizations of perturbation and subsequently stability for zigzags?

One idea is suggested by the combinatorial proof of stability of ordinary persistence [9] that considers changes to pairing after transpositions of contiguous simplices. Such transpositions make sense in a zigzag sequence built by adding or removing simplices one at a time as in Section 4. Fortunately, even if the arrows describing the transposing simplices point in the opposite directions (i.e. the transposition is not covered by the analysis of the ordinary persistence) such transpositions have the structure of Mayer–Vietoris diamonds:

![image 11](<CDSM2009/imageFile11.png>)

+




+


-


:

:






. . . 

. . . 







/

/



/

/



/

/



/

/


-









:

:




-


+


-



and therefore a proof of stability similar to the one in [9] follows.

# 6. ACKNOWLEDGEMENTS

inspiring discussions and helpful correspondence. The second author wishes to thank Pomona College and Stanford University for, respectively, granting and hosting his sabbatical during late 2008.

## References

Multidimensional Scaling. Encyclopedia of Measurement and Statistics , 598–605, Sage, 2007.

[2] Gunnar Carlsson. Topology and Data. Available at http://comptop.stanford.edu, 2008.

- [3] Gunnar Carlsson and Vin de Silva. Zigzag Persistence. Manuscript, Stanford University, 2008. arXiv:0812.0197v1 [cs.CG]
- [4] Fr ´ ed ´ eric Chazal, David Cohen-Steiner, Marc Glisse, Leonidas J. Guibas, and Steve Y. Oudot. Proximity of Persistence Modules and their Diagrams. To appear in Proceedings of the Annual Symposium on Computational Geometry, 2009.


- [5] Fr ´ ed ´ eric Chazal, Leonidas J. Guibas, Steve Y. Oudot, and Primoz Skraba. Analysis of Scalar Fields over Point Cloud Data. Proceedings of the Annual Symposium on Discrete Algorithms, pages 1021–1030, New York, NY, 2009.
- [6] David Cohen-Steiner, Herbert Edelsbrunner, and John Harer. Stability of Persistence Diagrams. Discrete and Computational Geometry, 37 :103–120, 2007.
- [7] David Cohen-Steiner, Herbert Edelsbrunner, and John Harer. Extending Persistence Using Poincar´e and Lefschetz Duality. Foundations of Computational Mathematics, 8 :79–103, 2009.


- [8] David Cohen-Steiner, Herbert Edelsbrunner, John Harer, and Dmitriy Morozov. Persistent Homology for Kernels, Images, and Cokernels. Proceedings of the Annual Symposium on Discrete Algorithms, pages 1011–1020, New York, NY, 2009.
- [9] David Cohen-Steiner, Herbert Edelsbrunner, and Dmitriy Morozov. Vines and Vineyards by Updating Persistence in Linear Time. Proceedings of the Annual Symposium on Computational Geometry, pages 119–126, New York, NY, 2006.


- [10] Tamal K. Dey and Rephael Wenger. Stability of Critical Points with Interval Persistence. Discrete and Computational Geometry, 38 :479–512, 2007.
- [11] Herbert Edelsbrunner, David Letscher, and Afra Zomorodian. Topological Persistence and Simplification. Discrete and Computational Geometry, 28 :511–533, 2002.


[12] Peter Gabriel. Unzerlegbare Darstellungen I. Manuscripta Mathematica , 6 :71–103, 1972.

[13] John A. Hartigan. Clustering Algorithms . J. Wiley and sons, 1975.

[14] Allen Hatcher. Algebraic Topology . Cambridge University Press, 2002.

[15] Joshua B. Tenenbaum, Vin de Silva, and John C. Langford. A Global Geometric Framework for Nonlinear Dimensionality Reduction. Science, 290 (5500):2319–2323, 2000.

[16] Afra Zomorodian and Gunnar Carlsson. Computing Persistent Homology. Discrete and Computational Geometry, 33 (2):249–274, 2005.
