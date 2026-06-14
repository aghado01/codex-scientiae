[Page 43]

Pereira, C. M. and de Mello, R. F. (2015). Persistent homology for time series and spatial data clustering. Expert Systems with Applications , 42(15):6026–6038.

Reininghaus, J., Huber, S., Bauer, S., and Kwitt, R. (2014). A stable multi-scale kernel for topological machine learning. arXiv:1412.6821

Repovs, G. (2010). Dealing with noise in EEG recording and data analysis. Informatica Medica Slovenica , 15(1):18-25

Scott, D. W. (2015). Multivariate density estimation: theory, practice, and visualization . John Wiley & Sons.

Seversky, L. M., Davis, S., and Berger, M. (2016). On time-series topological data analysis: New data and opportunities. The IEEE Conference on Computer Vision and Pattern Recognition , pages 59–67.

Sgouralis, I., Nebenf ¨ uhr, A., and Maroulas, V. (2017). A Bayesian topological framework for the identiﬁcation and reconstruction of subcellular motion. SIAM Journal on Imaging Sciences , 10(2):871–899.

Silverman, B. W. (1986). Density estimation for statistics and data analysis (Vol. 26). . CRC press, New York.

Simard, R. and L’Ecuyer, P. (2011). Computing the two-sided Kolmogorov Smirnov distribution. Journal of Statistical Software 39(11):1-18

Turner, K., Mileyko, Y., Mukherjee, S., and Harer, J. (2014). Fr´echet means for distribution of persistence diagrams. Discrete & Computational Geometry , 52:44–70.

Venkataraman, V., Ramamurthy, K. N., and Turaga, P. (2016). Persistent homology of attractors for action recognition. In 2016 IEEE International Conference on Image Processing (ICIP) , pages 4150–4154.

Xia, K., Feng, X., Tong, Y., and Wei, G. W. (2015). Persistent homology for the quantitative prediction of fullerene stability. Journal of computational chemistry , 36(6):408–422.

## Appendix A. Proofs from Section 4.3

## A.1. Proof of Proposition 38

Note that the lower bound integral is the probability for a pair z = ( x,y ) of independent standard normal variables to lie in B ((0 , 0) ,δ ). In order to bound the bottleneck distance W ∞ ( D, D ) < δσ , it is suﬃcient that each constituent feature does not stray too far from either its corresponding center or the diagonal (see Fig. 3 for reference). Speciﬁcally, we follow Def. 5 to build a correspondence between D and D so that the maximal distance undercuts δσ , and thus the (potentially smaller) bottleneck distance is also bounded by δσ . For clarity, features in D are denoted using ζ while features in D are denoted using ξ . j u

Consider each feature ξ j ∈ D u = D ∩{ d -b ≥ σ } and its associated random singleton diagram D j = { ζ j } or ∅ as in Def. 22. Assuming the disc neighborhood B j = B ( ξ j , δσ ) is contained in the wedge W = { ( b, d ) ∈ R 2 : d > b ≥ 0 } , the density of z j = ζ j -ξ j σ is a multiple ( > 1) of the density of the Gaussian random variable z ∼ N ((0 , 0) , I 2 ) in the region where ζ j ∈ B j (or equivalently z j ∈ B ((0 , 0) , δ )). Thus, we obtain P [ ζ j ∈ B ( ξ j , δσ ) ] ≥ P [ | z | ≤ δ ] for the probability that ζ j can be mapped to ξ j in a bounding correspondence. If B j glyph[notsubseteql] W , this probability is even higher because ξ j can be mapped to the diagonal and thus the case D j = ∅ is included.
