# Manifest: Page 003

## REPAIR_MATH
- RAW: ```
( 2 )
```
  FIX: ```
\[ \tag{2} \]
```

## REPAIR_PROSE
- RAW: ```
[ A, B ] can be difficult in some problems due to spline boundary conditions (see Hansen and Kooperberg 2002, and the accompanying discussion), but in many problems such as the neuronal spiking problem, it is rarely an issue because data are often available outside of the time interval of interest, [ A, B ]. The hard part of the problem is determining the knot set ξ , and using the data to do so provides the ability to fit a wide range of functions (as reviewed by Hansen and Kooperberg 2002). BARS is an MCMC-based algorithm that samples from a suitable approximate posterior distribution on the knot set ξ .
```
  FIX: ```
\([A, B]\) can be difficult in some problems due to spline boundary conditions (see Hansen and Kooperberg 2002, and the accompanying discussion), but in many problems such as the neuronal spiking problem, it is rarely an issue because data are often available outside of the time interval of interest, \([A, B]\). The hard part of the problem is determining the knot set \(\xi\), and using the data to do so provides the ability to fit a wide range of functions (as reviewed by Hansen and Kooperberg 2002). BARS is an MCMC-based algorithm that samples from a suitable approximate posterior distribution on the knot set \(\xi\).
```

- RAW: ```
Key features of the MCMC implementation of BARS include (i) a reversible-jump chain on ξ after integrating the marginal density
```
  FIX: ```
Key features of the MCMC implementation of BARS include (i) a reversible-jump chain on \(\xi\) after integrating the marginal density
```

- RAW: ```
(where y = ( y 1 , . . . , y n )), the integration being performed exactly for normal data and approximately, by Laplace’s method, otherwise, (ii) continuous proposals for ξ , and (iii) a locality heuristic for the proposals that attempts to place potential new knots near existing knots. For notational convenience here we are supressing the dependence of the knot set ξ on the number of knots k but BARS explores the space of generalized regression models defined by ξ and k and the prior on k can, in some cases, control the algorithm in important ways (see DiMatteo et al. 2001; Hansen and Kooperberg 2002; Kass and Wallstrom 2002).
```
  FIX: ```
(where \(y = (y_1, \ldots, y_n)\)), the integration being performed exactly for normal data and approximately, by Laplace’s method, otherwise, (ii) continuous proposals for \(\xi\), and (iii) a locality heuristic for the proposals that attempts to place potential new knots near existing knots. For notational convenience here we are supressing the dependence of the knot set \(\xi\) on the number of knots \(k\) but BARS explores the space of generalized regression models defined by \(\xi\) and \(k\) and the prior on \(k\) can, in some cases, control the algorithm in important ways (see DiMatteo et al. 2001; Hansen and Kooperberg 2002; Kass and Wallstrom 2002).
```

- RAW: ```
In doing so the “unit-information” prior discussed by Kass and Wasserman (1995) and Pauler (1998) has been used (as π in (2)), and this gives the interpretation that the algorithm is essentially using BIC to define a Markov chain on the knot sets.
```
  FIX: ```
In doing so the “unit-information” prior discussed by Kass and Wasserman (1995) and Pauler (1998) has been used (as \(\pi\) in (2)), and this gives the interpretation that the algorithm is essentially using BIC to define a Markov chain on the knot sets.
```

- RAW: ```
For each draw ξ ( g ) from the posterior distribution of ξ , a draw is obtained from the conditional posterior of β ξ , conditionally on ξ ( g ) . The conditional posterior of β ξ often may be assumed normal, but in some cases the normal approximation is not very good.
```
  FIX: ```
For each draw \(\xi^{(g)}\) from the posterior distribution of \(\xi\), a draw is obtained from the conditional posterior of \(\beta_\xi\), conditionally on \(\xi^{(g)}\). The conditional posterior of \(\beta_\xi\) often may be assumed normal, but in some cases the normal approximation is not very good.
```
