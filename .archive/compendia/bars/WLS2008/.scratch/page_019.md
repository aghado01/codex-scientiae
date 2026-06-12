
until ( exit ) if ( error ) exit else β cand ←   β + A r ← log   L ( k,ξ,β cand ) L ( k,ξ,β curr ) π ( β cand | k,ξ ) π ( β curr | k,ξ ) π ∗ ( β curr | k,ξ, Data ) π ∗ ( β cand | k,ξ, Data )   if (( i = 0) and ( r > MHT )) comment : Accept the initial variate. No additional Metropolis-Hastings steps. i ← MHI u ← r − 1 . 0 else u ← U (0 , 1) u ← log( u ) if ( u < r ) comment : Accept the candidate β . β curr ← β cand

beta ← β curr .

return

# Acknowledgments

Support for the current work was provided by NIMH Program Project MH56193. The authors are grateful for helpful comments from the referees.

# References

Anderson E, Bai Z, Bischof C, Blackford S, Demmel J, Dongarra J, Du Croz J, Greenbaum A, Hammarling S, McKenney A, Sorensen D (1999). LAPACK Users’ Guide . 3rd edition. Society for Industrial and Applied Mathematics, Philadelphia, PA.

Baker CI, Behrmann M, Olson CR (2002). “Impact of Learning on Representation of Parts and Wholes in Monkey Inferotemporal Cortex.” Nature Neuroscience , 5 (11), 1210–1216.

Brown BW, Lovato J (1996). “Library of C Routines for Random Number Generation.” URL http://www.stat.umn.edu/HELP/ranlib-docs/ranlib.c.chs .

Denison DGT, Mallick BK, Smith AFM (1998). “Bayesian MARS.” Statistics and Comping , 8 , 337–346.

DiMatteo I, Genovese CR, Kass RE (2001). “Bayesian Curve Fitting with Free-Knot Splines.” Biometrika , 88 , 1055–1073.
