<a id="sec-variants-of-the-em-algorithm-for-large-databases"></a>

# Variants of the EM Algorithm for Large Databases

<a id="sec-12-1"></a>

# 12.1 INTRODUCTION

As set out in some detail in McLachlan and Krishnan (1997, Section 1.7), the EM algorithm has a number of desirable properties, including reliable global convergence. That is, starting from an arbitrary [(o) in the parameter space, convergence is nearly always to a local maximizer; barring very bad luck in the choice of OI some local pathology in the likelihood function. In particular; the likelihood is not decreased after each EM iteration: We have seen in the preceding chapters that the ML of finite mixture models is straightforward using the EM algorithm; at least for independent data. The E-step is simply equivalent to updating the posterior probabilities of component membership, and the M-step exists in closed form for component distributions belonging to commonly used parametric families such as the normal . point log fitting=

In considering methods for speeding up the convergence of the EM algorithm, it is highly desirable if the simplicity and stability of the EM algorithm can be preserved. Against this background in the context of mixture models; we considered in Chapter 2 some methods that have been suggested for speeding up the convergence of the EM algorithm. In this chapter we shall focus on methods for improving the speed of the EM algorithm for the ML of mixture models to large databases that preserve the simplicity of implementation of the EM in its standard form. One of these methods is the incremental version of the EM algorithm as proposed recently by Neal and Hinton (1998), whereby an M-step is performed after a single or block of observations have had their component posterior probabilities updated. With this version; the likelihood is still increased after each scan. We shall also consider how the EM algorithm can be scaled to handle very large databases with a limited memory buffer, as with the fitting scalable version proposed recently by Bradley et al. (1999); see also Bradley and Fayyad (1998), Bradley , Fayyad, and Reina (1998), and Fayyad, Reina; and Bradley (1998).

In other recent work on speeding up the EM algorithm for mixtures; Celeux et al. (1999) have proposed a componentwise EM (CEM) algorithm; which is similar in construction to a version of the general-purpose space-alternating generalized EM (SAGE) algorithm of Fessler and Hero (1994, 1995);see also Hero and Fessler (1995).

<a id="sec-12-2"></a>

# 12.2 INCREMENTAL EM ALGORITHM

<a id="sec-12-2-1"></a>

# 12.2.1 Introduction

We consider here the Incremental EM (IEM) algorithm proposed by Neal and Hinton (1998) for improving the rate of convergence of the EM algorithm: With the standard EM algorithm in the context of a finite mixture model being fitted t0 independent data, the E-step updates the posterior probabilities of component membership of each observation before the M-step is performed. With the IEM algorithm; only a partial E-step is undertaken before the next M-step is performed. More specifically; suppose the observed data %1, Un are divided into B blocks. If r equals the integer part of n/B,then we let each block contain r observations apart from; say; the Bth, which will have more than r when n is not a multiple of B. The IEM algorithm proceeds by implementing the E-step for only a block of observations at a time before performing M-step. In this way; each data point %j is visited after B partial E-steps and B (full) M-steps have been performed. That is, a "pass" or scan of the IEM algorithm consists of B partial E-steps and B full M-steps.

<a id="sec-12-2-2"></a>

# 12.2.2 Definition of Partial E-Step

value of € after the bth iteration on the (k + 1)th scan (b = 1, B) . In the context of a g-component mixture model, the IEM algorithm is implemented on the (6+ 1)th iteration of the (k + 1)th scan as follows for b = 0, B - 1:

E-step For i = 1, 9, replace the unobservable component-indicator var iable zij in the complete-data those Uj in the (6 + 1)th block. log

<a id="sec-12-2-3"></a>

# 12.2.3 Block Updating of Sufficient Statistics

If the component distributionsbelong to the exponential family as, for example; in the case of normal components, then it is computationally advantageous to work in terms of the current conditional expectations of the sufficient statistics. We now illustrate this for normal components, but firstly we nced the following notation.

For the bth block (b = 1, B) and current value for $\Psi$, let

$$
T _ { i 1 , b } ^ { ( k ) } \, = \, \sum _ { j \in S _ { b } } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \, , \\
$$

$$
\null _ { b } = \sum _ { i \in S _ { b } } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \, y _ { j } ,
$$

and

$$
( 1 2 . 3 )
$$

for i 9, where S6 is a subset of {1, n} , containing the subscripts of those Uj that to the bth block (b = 1, B) . The (current) conditional expectations of the sufficient statistics can then be expressed in terms of sums over the B blocks of the terms (12.1) to (12.3) to give belong

$$
T _ { i q } ^ { ( k ) } = \sum _ { b = 1 } ^ { B } T _ { i q , b } ^ { ( k ) } \quad ( i = 1 , \dots , g ; \ q = 1 , 2 , 3 ) .
$$

$$
( 1 2 . 4 )
$$

In the definitions (12.1)t0 (12.4), the superscript k denotes a general iteration number

and not necessarily the scan number of the IEM algorithm:

From (3.2) to (3.8), it follows that on the M-step on the (b + 1)th iteration of the (k + 1)th scan of the IEM algorithm, the estimates of pi, and $Z_j$ are updated as follows: T;,

$$
( 1 2 . 5 )
$$

$$
=
$$

$$
( 1 2 . 6 )
$$

and

$$
\Sigma _ { i } ^ { ( k + ( b + 1 ) / B ) } = \left \{ T _ { i 3 } ^ { ( k + b / B ) } - T _ { i 1 } ^ { ( k + b / B ) ^ { - 1 } } T _ { i 2 } ^ { ( k + b / B ) } T _ { i 2 } ^ { ( k + b / B ) ^ { T } } \right \} / T _ { i 1 } ^ { ( k + b / B ) } \\
$$

for i = 1,

The conditional expectations 1{4+6/B) of the sufficient statistics on the right-hand side of (12.5) to (12.7), which are calculated effectively on the E-step to this M-step, can be expressed in terms of their values on the previous iteration; the result prior using

$$
T _ { i q } ^ { ( k + b / B ) } = T _ { i q } ^ { ( k + ( b - 1 ) / B ) } - T _ { i q , b + 1 } ^ { ( k - 1 + b / B ) } + T _ { i q , b + 1 } ^ { ( k + b / B ) } \ ( i = 1 , \dots , g ; \ q = 1 , 2 , 3 ) . \\ T _ { i q } \text { is on the} \, t o \, s o t i o n \, F \, e x t a n d \, o r \, ( k + 1 ) \, t h i t e o n \, o f t h e \, ( k + 1 ) \, t h e \, o n \, o w h t h e .
$$

That is, on the partial E-step on the (b + 1)th iteration of the (k + 1)th scan, only the

(6 + 1)th block terms

$$
^ { 1 } _ { 1 } ( i = 1 , \dots , g ; \, q = 1 , 2 , 3 )
$$

have to be computed, since the first and second terms on the right-hand side of (12.8) are already available from the previous iteration and the previous scan, respectively.

<a id="sec-12-2-4"></a>

# 12.2.4 Justification of IEM Algorithm

The argument for improved rate of convergence is that the IEM algorithm exploits new information more quickly rather than waiting for a complete scan of the data before parameters are updated by an M-step. The theoretical justification for the IEM algorithm has been provided by Neal and Hinton (1998).

As pointed out by Thiesson, Meek, and Heckerman (1999), the use of a E-step raises two issues not encountered with the standard EM algorithm. One is how to assess convergence when the IEM algorithm with the E-step implemented partially through blocks of the data. After the (b + 1)th iteration on the (k + 1)th scan; the log likelihood can be approximated as partial using

$$
\log L ( \Psi ^ { ( k + ( b + 1 ) / B ) } ) & \approx \log L ( \Psi ^ { ( k + b / B ) } ) \\ & + \sum _ { j \in S _ { j } } \{ \log f ( y _ { j } ; \Psi ^ { ( k + ( b + 1 ) / B ) } ) - \log f ( y _ { j } ; \Psi ^ { ( k + ( b + 1 ) / B ) } )
$$

The second issue is related to the initial scan through the data. The first few blocks may contain few observations with a high probability of membership of a component of the mixture; which may result in that component having a negligible estimate for its mixing proportion. As aconsequence; observations in the subsequent blocks may have practically zero estimates for their posterior probabilities of membership of that component, even if had actually arisen from that component. This problem of 'premature component starvation? can be avoided by running the standard EM algorithm for the first few scans or by at least waiting until the E-step is performed for several blocks before performing the first M-step. they

Of course this would be regarded as overly conservative in most data mining applications involr very large databases; see, for example, Fayyad and Smyth (1999) and the references therein: being~

<a id="sec-12-2-5"></a>

# 12.2.5 Gain in Convergence Time

Concerning the time taken to perform the IEM algorithm for one scan, the B partial E-steps take more time to implement than the one full E-step of the standard EM algorithm; the additional time involving the subtraction of the second term on the right-hand side of (12.8) and the inversion of the component-covariances matrices; which have to be performed after each of the B partial steps. Also, one scan of the IEM algorithm requires (B 1) additional M-steps in updating the estimates (12.5) to (12.7). McLachlan and Ng (2000a) have investigated the tradeoff between this additional computation on one scan of the IEM algorithm and the fewer number of scans. In Sections 12.3 we present some of their simulation results for normal mixtures, in which the performance of the IEM version is compared with the standard EM algorithm for various number of blocks B. It shall be seen that the time to convergence is reduced by up to a factor of 419. using

The choice of the number of blocks B s0 as to optimize the convergence time of the IEM algorithm is an interesting problem. The initial work of McLachlan and Ng (2000a) suggests B ~ as a simple The optimal choice will depend n2/5 guide. using on the number of unknown parameters; and McLachlan and Ng (2000a) suggest modifying this guide to B ~ in the case of component-covariance matrices specified to be diagonal. n1/3

<a id="sec-12-2-6"></a>

# 12.2.6 IEM Algorithm for Singleton Blocks

We will sce in the simulations in Section 12.3 that the time to convergence starts to increase as the number of blocks B becomes sufficiently large. This is because of the additional computation time required in having t0 perform more M-steps and having to invert the component-covariance matrices in the more frequent updating of the posterior probabilities of component membership on each scan of the whole data set\_

one observation per block. In order for the updating of the posterior probabilities of component membership to be feasible in practice for multivariate data, some further computational shortcuts are needed beyond those that work in terms of block updates In particular, one needs to avoid having to invert the component-covariance matrices after each of the component posterior probabilities for a single observation. update

There are formulas that express the inverse of a sample covariance matrix in terms of the inverse of the sample covariance matrix based on one more observation; see, for example, Friedman (1989) and the references therein. McLachlan and Ng (2000a) have modified these formulas to suit the present situation where the weight of a single observation in the full sample does not change from to 0 (that is, is deleted) but is merely updated to another value between 0 and 1.

<a id="sec-12-2-7"></a>

# 12.2.7 Efficient Updating Formulas

We assume without loss of generality that the jth block consists of the jth observation = 1, n). It can be seen from Section 12.2.3 that in order to update the posterior probabilities from

$$
\Psi ^ { ( k + ( j - 1 ) / n ) } ) \ \ t o \ \ \tau _ { i } ( y _ { j } ; \Psi ^ { ( k + j / n ) } )
$$

on the (j + 1)th iteration of the (k + 1)th scan of the IEM algorithm; we need to for i = 1, 9 .

For convenience, in the remainder of this section we write Ti(uj; %k+ (j-1)/n)), z(k+

McLachlan and Ng (2000a) showedthat when in can be updated as follows: T;($y_j$;

$$
\pi _ { i } ^ { * } \ = \ ( n \pi _ { i } - \tau _ { i j } + \tau _ { i j } ^ { * } ) / n \, , \\  \pi _ { i } ^ { * } \ = \ ( n \pi _ { i } - \tau _ { i j } + \tau _ { i j } ^ { * } ) / n \, ,
$$

$$
\mu _ { i } ^ { * } \ = \ \mu _ { i } - ( \tau _ { i j } - \tau _ { i j } ^ { * } ) ( y _ { j } - \mu _ { i } ) / ( n \pi _ { i } ^ { * } ) \, ,
$$

and

$$
\Sigma _ { i } ^ { * - 1 } \ = \ \frac { \pi _ { i } ^ { * } } { \pi _ { i } } \left [ \Sigma _ { i } ^ { - 1 } + \frac { ( \tau _ { i j } - \tau _ { i j } ^ { * } ) \Sigma _ { i } ^ { - 1 } ( y _ { j } - \mu _ { i } ) ( y _ { j } - \mu _ { i } ) ^ { T } \Sigma _ { i } ^ { - 1 } } { n \pi _ { i } ^ { * } - ( \tau _ { i j } - \tau _ { i j } ^ { * } ) ( y _ { j } - \mu _ { i } ) ^ { T } \Sigma _ { i } ^ { - 1 } ( y _ { j } - \mu _ { i } ) } \right ] \, ,
$$

$$
\tau_{ij} ( y _ { j } - \mu _ { i } ) ^ { T } \, \Sigma _ { i } ^ { - 1 } ( y _ { j } - \mu _ { i } ) \Big | \quad ( 1 2 . 1 2 )
$$

for i = 1, 9.

The use of (12.9)t0 (12.12) considerably reduces the amount of computation time in the updating of the g component posteriorprobabilitiesfor $y_j$ ' In particular; the use of (12.11)and(12.12)avoids havingtocalculate directly the inverses and determinants oftheg component-covariance matrices. Unfortunately, it is notpossible to generalize these updating formulas to the case of blocks consisting of more than one observation.

<a id="sec-12-3"></a>

# 12.3 SIMULATIONS FOR IEM ALGORITHM

In this section we report some recent simulations of McLachlan and Ng (2000a) on the performance of the IEM algorithm with different number of blocks B relative to the standard EM algorithm.

<a id="sec-12-3-1"></a>

# 12.3.1 Simulation 1

A sample of size n = 256 x 256 was generated from a seven-component trivariate normal mixture . The estimates obtained in MacFall, and Harrington (1994) were used as the values of our population parameters. These seven components correspond to seven tissue types in the segmentation of a two-dimensional magnetic resonance image (MRI) of the human brain. The standard EM algorithm and the IEM version for various number of blocks B were fitted to these simulated data; using the same random starts\_ In order to avoid the problem of premature component starvation with the IEM algorithm; a full E-step was performed before running the initial M-step. Liang,

With this implementation, the EM and IEM algorithms converged to the same local maximum of the likelihood . The overall CPU time (in seconds) and the number of scans are displayed in Table 12.1. In addition, the average CPU times of the E-step (TE) and the M-step (Tm for each scan are displayed in parentheses It can be seen that when the data are partitionedinto blocks with the IEM algorithm; the average times TE and TM increase, but the number of scans toconvergence decreases; relative to the standard EM algorithm: The overall CPU time is a tradeoff between the additional time of computation per scan and the fewer number of scans required because of the more frequent updating due to B partial E-steps instead of one full E-step (B = more and more blocks, the time to convergence eventually starts to rise. Similar results have been reported by Thiesson et al. (1999) with the IEM algorithm used to fit mixtures to two real-world databases . Their first data set, MSNBC, is a sparse data log

Table 12.1 CPU Times (in Seconds) and the Number of Scans for the Standard EM Algorithm and the IEM Version for B Blocks (Simulation 1)

| Algorithm                     | CPU Times         | No. of Scans |
| ----------------------------- | ----------------- | ------------ |
| Standard EM                   | 601 (4.76,1.07)   | 101          |
| Incremental EM                |                   |              |
| B = 4                         | 458 (4.89,1.26)   | 72           |
| B = 8                         | 427 (4.89,1.26)   | 67           |
| B = 16                        | 414 (4.89,1.26)   | 65           |
| B = 32                        | 408 (4.90, 1.25)  | 64           |
| B = 64                        |                   | 63           |
| B =128                        | 407 (4.92, 1.28)  | 63           |
| B = 256                       | 411 (4.94,1.32)   | 63           |
| B = 2562 =n                   | 2352 (28.40,6.87) | 63           |
| B 2562 with updating formulas | 1143 (10.34,6.80) | 63           |

Source: Adapted from McLachlan and Ng (2000a)

set, which encoded the stories that people read on the MSNBC web site on December 22, 1998. The second data set holds data records for a single particular subphonetic event observed for continuous speech. For the extreme case of B = n, the use of the updating formulas (12.9)t0 (12.12) considerably reduces the amount of computation time.

In Figure 12.1, the log likelihood is plotted against the number of scans. It shows how the log likelihood changes in the initial scans It can be seen that the IEM algorithm converges with fewer scans than the standard EM algorithm. In Figure 12.2, fifty the likelihood is plotted against the elapsed time. It shows how the likelihood changes during the initial 400 seconds. It can be seen that the fastest time to converwith the IEM algorithm was obtained with B =64 blocks. For this value of B, the time to convergence is reduced by a factor of 339. log gence

10'

1

Fig. 12.1 likelihood versus number of scans. Standard EM (solid curve); Incremental EM: B = 4 (dotted curve); B = 64 (dashed curve) From McLachlan and Ng (2000a) Log

10'

}

100

150

200

250

300

350

400

- 12.2 Log likelihood versus elapsed time. Standard EM (solid curve); Incremental EM: B 24 (dotted curve); B 64 (dashed curve); B = 256 x 256 with updating formulas (dashed-dotted curve) From McLachlan and Ng (2000a) Fig.
- 12.3.2 Simulation 2

In the second simulated data set considered by McLachlan and Ng (2000a), a sample of size n = 2000 was generated from a four-component eight-dimensional normal mixture. The population parameters are those described in Fukunaga (1990, p. 46) B were applied t0 this simulated data set, the same random starts . For this simulated data; both the EM and its IEM variant converge to the same local maximum of the likelihood. The overall CPU time, the average times TE and Tv for the E- and M-steps respectively; and the number of scans are displayed in Table 12.2. partitioned into blocks, the overall CPU time decreases, but eventually starts to rise as the data are partitioned into more and more blocks: It can be seen that the fastest time to convergence with the IEM algorithm was obtained with B = 20 blocks. For this value of B, convergence time is reduced by a factor of 419 \_ using log

As demonstrated in these two simulation examples, the decrease in the number of scans eventually slows down as the data are partitioned into more and more blocks, while at the same time the average times of the E-step (TE) and the M-step (Tu) for each scan continue to rise. Subsequently; the overall CPU time stops decreasing and commences to increase . Thus it is more beneficial to choose a relatively small B.

Table 12.2 CPU Times (in Seconds) and the Number of Scans for the Standard EM rithm and the IEM Version for B Blocks (Simulation 2) Algo-

| Algorithm                       | CPU Times Overall (TE , TM) | No. of Scans |
| ------------------------------- | --------------------------- | ------------ |
| Standard EM                     | 186 (0.34,0.07)             | 446          |
| Incremental EM                  |                             |              |
| B = 4                           | 137 (0.37,0.10)             | 287          |
| B = 8                           | 119 (0.37,0.10)             | 249          |
| B = 16                          | 112 (0.38,0.10)             | 230          |
| B = 20                          |                             | 218          |
| B = 40                          | 113 (0.40,0.11)             | 215          |
| B = 80                          | 118 (0.42,0.12)             | 213          |
| B = 200                         | 144 (0.52, 0.14)            | 210          |
| B = 400                         | 196 (0.68,0.20)             | 210          |
| B = 2000 = n                    |                             | 210          |
| B = 2000 with updating formulas | 249 (0.63,0.49)             | 210          |

Source: Adapted from McLachlan and Ng (2000a) .

<a id="sec-12-4"></a>

# 12.4 LAZY EM ALGORITHM

In a mixture model to a data set by maximum likelihood via the EM algorithm; for some Vj are often observed to be close to one for some i; that is, fitting

$$
\max _ { i } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \geq C
$$

close to one, say C 2 0.95. If (12.13) continues to hold beyond the kth iteration; then there would be no need to update these posterior probabilities when performing the E step on subsequent EM iterations. Tothisend, suppose that the n sample observations Un are dividedinto blocks as before with the IEM algorithm; but where now there are only B = 2 blocks and the %; belonging to the first block satisfy (12.13) with the remaining observations put in the second block. Then the EM (LEM) algorithm would be implemented in the same manner as the standard EM algorithm; except that on the E-steps only the posterior probabilities of component membership of those observations $y_j$ in the second block would be updated. lazy

The empirical justilication for the LEM algorithm is that if an observation %; has a very strong posterior probability of belonging t0 one of the components of the mixture, then there is a chance that it will not change its probabilistic component membership in subsequent iterations; and if it does, then the change will occur gradually rather than suddenly. The idea therefore is to run the LEM algorithm for a number of iterations k1 (say, k1 < 8) between full E-steps. Initially; the EM good algorithm would be run for ko iterations before switching t0 the LEM algorithm; which is then run for k1 iterations in between full EM steps.

The LEM algorithm is justified theoretically by noticing that the formulation of Neal and Hinton (1998) is applicable for an arbitrary and not necessarily an exhaustive set of data blocks, as as the data are visited regularly. Hence the LEM algorithm is guaranteed to converge to a local maximum (or saddle point). long

<a id="sec-12-5"></a>

# 12.5 SPARSE EM ALGORITHM

We have seen with the LEM algorithm that for some observations U; their posterior probabilities of component membership are not updated on every E-step. With the so-called Sparse EM (SPEM) algorithm, proposed by Neal and Hinton (1998), some of these posterior probabilities for a given data Yj are held fixed for some components while the posterior probabilities of %; for the remaining components in the mixture are updated. For example, if the current values of the posterior abilities of component membership for a given Uj were very small (for example, = 0.01) say, the first three components of a six-component mixture being fitted, then with the SPEM algorithm we would fix the posterior probabilities for membership with respect to the first three components at their current values and only update the posterior probabilities for the last threc components. To algorithm and suppose that the SPEM version is to be implemented on the next itera tion; where the posterior probabilities of component membership of %; are to be held fixed for components i, where i € Aj, with Aj being a subset of {1, 9} We let on the (k + 1)th iteration, if Aj is the null set for observation %; update the posterior probabilities of component membership to T; [{\*)) (i = 1, 9) . If Aj is not the null set, then the posterior probabilities of component membership to point prob for; update

$$
\frac { \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) } { C _ { h \in A _ { j } ^ { o } } \tau _ { h } ( y _ { j } ; \Psi ^ { ( k ) } ) }
$$

for those components i which do not belong to Aj; otherwise do not update the posterior probabilities $\tau_i(y_j; %\*-1)). As (12.14) reduces to

$$
\sum _ { h \in A _ { j } ^ { c } } \tau _ { h } ( y _ { j } ; \Psi ^ { ( k - 1 ) } ) \, \frac { \pi _ { i } ^ { ( k ) } \, f _ { i } ( y _ { j } ; \theta _ { i } ^ { ( k ) } ) } { \sum _ { h \in A _ { j } ^ { c } } \pi _ { h } ^ { ( k ) } \, f _ { h } ( y _ { j } ; \theta _ { h } ^ { ( k ) } ) } ,
$$

only the updates of the prior-weighted component densities; "} to be calculated for those components i € A; . Therefore; this sparse E-step will take time proportional only to the number of components ; € A; (j = 1, n) The M-step can also be done efficiently by updating only the contribution to the sufficient statistics for those components i € A;\_ For example,

$$
T _ { i 1 } ^ { ( k ) } = \sum _ { j = 1 } ^ { \infty } \left [ I _ { A _ { j } } ( i ) \tau _ { i } ( y _ { j } ; \Psi ^ { ( k - 1 ) } ) + I _ { A _ { j } ^ { c } } ( i ) \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) \right ] ,
$$

where The first term on the right-hand side of (12.16) can be saved for use in the subsequent SPEM iterations. Similar

After running the SPEM version a number of iterations k1, a full EM step is then performed, and a new set A; (j = 1, n) is selected. Note that if we replace by in the first term in (12.14) or (12.15), then we obtain the updated posterior probabilities of component membership as on the E-step of the standard EM algorithm: Hence we can switch on any E-stepto the standard EM algorithmby using 9)

<a id="sec-12-6"></a>

# 12.6 SPARSE IEM ALGORITHM

A sparse version of the IEM algorithm (SPIEM) can be formulated by combining the sparse E-step of SPEM algorithm and the partial E-step of the IEM algorithm. Let be the value of € after the kth scan and suppose that the SPEM algorithm is to be implemented on the subsequent bth iteration of the (k + 1)th scan (6 = 1, B) . Then on the E-step on the (b + 1)th iteration for b =0 B 1, the posterior probabilities of component membership for all j € S(b+1) are updated to

$$
\sum _ { h \in A _ { j } ^ { c } } \tau _ { h } ( y _ { j } ; \Psi ^ { ( k - 1 ) } ) \, \frac { \tau _ { i } ( y _ { j } ; \Psi ^ { ( k + 1 ) } ) } { \sum _ { h \in A _ { j } ^ { c } } \tau _ { h } ( y _ { j } ; \Psi ) }
$$

for those components ; which do not belong to Aj; otherwise leave the posterior probabilities unchanged as

To avoid the problem of premature component starvation; we suggest running a full EM step at the first scan and then performing the IEM for five scans before running the SPIEM algorithm. After running the SPIEM algorithm for a number of scans k1, a full EM step (B iterations of IEM) is then performed, and a new set Aj (j = 1, n) is selected . The efficient M-step described in the previous section can also be applied in the SPIEM algorithm.

<a id="sec-12-6-1"></a>

# 12.6.1 Some Simulation Results

McLachlan and Ng (2000a) performed two simulations to compare the relative per formances of the SPIEM, IEM, and standard EM algorithms. Their first simulation used the same simulated data set used in Section 12.3.1. The number of blocks B was set to be 64, and considered the combinations of k1 = 2,3,4,5,6 and C = 0.05,0.01,0.005. For these simulated data, all the algorithms converged to they the same local maximum of the log likelihood. The overall CPU time; the average times for the E-step (TE) and M-step (TM ), and the number of scans are displayed in Table 12.3.

Table 12.3 CPU Times (in Seconds) and the Number of Scans for the SPIEM Algorithm for B = 64 Blocks (Simulation 1)

|     | CPU Times |                  |              |
| --- | --------- | ---------------- | ------------ |
| k1  |           | Overall (TE, Tm) | No. of Scans |
| 2   | 0.05      | 323 (2.88,0.75)  | 83           |
| 2   | 0.01      | 319 (3.31,0.88)  |              |
| 2   | 0.005     | 325 (3.39,0.89)  | 71           |
| 3   | 0.05      | 316 (2.62,0.69)  | 89           |
| 3   | 0.01      | 300 (3,03,0.80)  | 73           |
| 3   | 0.005     | 308 (3.12,0.82)  | 73           |
|     | 0.05      | 343 (2.42,0.64)  | 105          |
|     | 0.01      | 318 (2.84, 0.74) | 83           |
|     | 0.005     | 313 (2.97, 0.78) | 78           |
| 5   | 0.05      | 325 (2.25,0.59)  | 107          |
| 5   | 0.01      | 304 (2.82, 0.71) |              |
| 5   | 0.005     | 291 (2.84,0.72)  |              |
| 6   | 0.05      | 369 (2.22, 0.57) | 124          |
| 6   | 0.01      | 312 (2.73,0.69)  | 85           |
| 6   | 0.005     | 315 (2.82, 0.71) | 83           |

Source: Adapted from McLachlan and Ng (2000a)

= 64, it can be seen that the number of scans to convergence for each combination of C and k1 with the SPIEM algorithmis than that for the IEM algorithm. However; as tobe anticipated, TE and TM for the SPIEM algorithm are smaller than that for the IEM algorithm, which allows the SPIEM algorithm for the present combinations of C and k1 to converge faster than the IEM algorithm: Concerning the optimal choice of C and k1, the overall CPU time is a tradeoff between the computation time per scan and the number of scans required. It can be seen from Table 12.3 that the SPIEM algorithm converges fastest for C = 0.005 and k1 = 5. larger

In Figure 12.3, the likelihood is plotted against the number of scans for the various algorithms. It shows how the likelihood changes in the initial fifty scans for these algorithms. It is noted that for the implementation of the SPIEM algorithm; the IEM algorithm is performed for the first five scans before running the first SPIEM rithms coincide up to the fifth scan. From Figure 12.3,it is observed that the SPIEM algorithm takes more scans to converge compared with the IEM algorithm. But, the SPIEM algorithm takes less scans when compared to the standard EM algorithm. In Figure 12.4, the log likelihood is plotted the elapsed time for the various algorithms. It shows how the likelihood changes during the initial 250 seconds. log Iog against log The second simulation of McLachlan and Ng (2000a) used the simulated data set adopted in Section 12.3.2. The number of blocks B was set to be 20, and the combinations of k1 = 2, 3,4, 5, 6 and C = 0.05,0.01,0.005 were considered. For these simulated data; some runs of the SPIEM algorithm with C = 0.05 and C = 0.01 converged to a slightly smaller local maximum ofthe log likelihood. The overall CPU time, the number of scans, and the values of the local maxima of the likelihood are displayed in Table 12.4. log

105

~3,8

1

8

20

25

30

Number of scans

12.3 likelihood versus number of scans. Standard EM (solid curve); Incremental SPIEM with B = 64,k1 5, and C = 0.05 (dashed-dotted curve) From McLachlan and Ng (2000a) Fig. Log

~3.8

1

8

100

150

200

250

Fig. 12.4 likelihood versus elapsed time. Standard EM (solid curve); Incremental EM with B=64 (dotted curve); SPIEM with B =64,k1 5,and C =0.005 (dashed curve); SPIEM with B = 64,k1 = 5, and C =0.05 (dashed-dotted curve) From McLachlan and Ng (2000a) Log

Table 12.4 CPU Times (in Seconds) and the Number of Scans for the SPIEM Algorithm for B = 20 Blocks (Simulation 2)

| k1  |       | CPU Times Overall (TE, Tm) | No. of Scans | Likelihood Log |
| --- | ----- | -------------------------- | ------------ | -------------- |
| 2   | 0.05  | 96 (0.30,0.07)             | 254          | 30384.7        |
| 2   | 0.01  | 86 (0.34,0.08)             | 203          | 30381.6        |
| 2   | 0.005 | 91 (0.35,0.09)             | 203          | 30381.6        |
| 3   | 0.05  | 95 (0.27,0.07)             | 273          | 30384.7        |
| 3   | 0.01  | 84 (0.31,0.08)             | 209          | 30381.6        |
| 3   | 0.005 | 86 (0.34,0.08)             | 201          | 30381.6        |
|     | 0.05  | 100 (0.26, 0.07)           | 300          | 30384.7        |
|     | 0.01  | 84 (0.30,0.07)             | 215          | 30381.6        |
|     | 0.005 | 85 (0.32,0.08)             | 205          | 30381.6        |
| 5   | 0.05  | 100 (0.25, 0.06)           | 317          | 30384.7        |
| 5   | 0.01  | 83 (0.30,0.07)             | 221          | 30381.6        |
| 5   | 0.005 | 81 (0.31,0.08)             | 203          | 30381.6        |
| 6   | 0.05  | 104 (0.24,0.06)            | 341          | 30384.7        |
| 6   | 0.01  | 90 (0.29,0.07)             | 243          | 30384.7        |
| 6   | 0.005 | 82 (0.31,0.07)             | 208          | 30381.6        |

Source: Adapted from McLachlan and Ng (2000a).

On comparing Table 12.4 with Table 12.2 for B 20, it can be seen that TE considered than that for the IEM algorithm; which is to be expected. For some of these combinations of C and k1, the SPIEM algorithm required a fewer number of scans to convergence, while for all combinations its time to convergence is smaller than that of the IEM algorithm. As in the first simulation, the convergence time of the SPIEM algorithm is smallest for C = 0.005 and k1 = 5.

<a id="sec-12-6-2"></a>

# 12.6.2 Summary of Results for the IEM and SPIEM Algorithms

From the results obtained for the IEM and SPIEM algorithms to these two simulated data sets, we see that the overall CPU time is smallest for the SPIEM algorithm (comparing Table 121t0 12.3 and Table 12.2t0 12.4). For the implementation of the SPIEM algorithm; we suggest taking € = 0.005 and k1 = 5 . For these applied values of C and k1, the time to convergence is reduced by a factor of 529 for the first simulated data set, compared with the standard EM algorithm, and a factor of 289, compared with the IEM algorithm for B = 64. For the second simulation;, the time to convergence is reduced by a factor of 569, compared with the standard EM algorithm; and a factor of 269, compared with the IEM algorithm for B = 20. It can be seen that the reduction in the time t0 convergence between the IEM and the SPIEM algorithms is smaller for the second simulated data set, the apparent reason being that there are only 9 = 4 components being fitted to the second set.

<a id="sec-12-7"></a>

# 12.7 SCALABLE EM ALGORITHM

<a id="sec-12-7-1"></a>

# 12.7.1 Introduction

The standard EM algorithm and its variants require multiple scans of the data to converge. Bradley et al. (1999) have developed a scalable EM algorithm requiring at most one scan of the database. Their algorithm works within the confines of a limited memory (RAM) buffer allocated by the user, and it utilizes a forward-only cursor. We now describe a scalable EM algorithm proposed by Bradley et al. (1999) for fitting a g-component normal mixture model. It is bascd on identifying of the data that are compressible and regions that must be maintained in memory. The algorithm of Bradley et al. (1999) uses primary and secondary compression of the data. Their primary compression purges sample that are unlikely to change component membership during the iterative process. Their secondary compression identifies dense regions of data that are not near the current values of the component means of the mixture model. We firstly describe their algorithm without secondary data compression. regions points fitting

<a id="sec-12-7-2"></a>

# 12.7.2 Primary Compression of the Data

Thescalable EM algorithm is designed for useinthecase of a fixed maximum memory buffer size. It proceeds by selecting a random sample of size n(0) from the available data to fill up the memory buffer. The standard EM algorithm is implemented from After completion of this first standard EM iteration; primary compression is performed by locating those observations that are strongly identified with a component of the mixture model. To this end, the blocks B{1) B41) are formed, where

$$
B _ { b } ^ { ( 1 ) } = \{ y _ { j } \, \colon \, ( y _ { j } - \mu _ { b } ^ { ( 1 ) } ) ^ { T } \Sigma _ { b } ^ { ( 1 ) ^ { - 1 } } ( y _ { j } - \mu _ { b } ^ { ( 1 ) } ) \leq C _ { b } \} \quad ( b = 1 , \dots , g ) , \ \ ( 1 2 . 1 7 )
$$

where C1, Cg are chosen so that the proportionœPc of the existing observations in the memory buffer are in B81) . Figure 12.5 illustrates the ideaofprimary compression; the elliptical regions correspond to the blocks B{'

Fig. 12.5 Illustration of the idea of primary compression; the elliptical regions correspond to the blocks

If an observation %; belongs to more than one block according to (12.17), then it is given a unique assignment to block Bh , where

$$
h = \arg \min _ { b } ( y _ { j } - \mu _ { b } ^ { ( 1 ) } ) ^ { T } \Sigma _ { b } ^ { ( 1 ) ^ { - 1 } } ( y _ { j } - \mu _ { b } ^ { ( 1 ) } ) \quad ( b = 1 , \dots , g ) .
$$

Bradley et al. (1999) set aPc =0.5 in their experiments.

The observations in B(1) are purged from memory and replaced by the scalar T{ , the vector and the distinct elements of the symmetric matrix 1{,2 for b = 1, 9, where is the number of observations in

and where

and for b = 1, 9. Here and and

$$
T _ { 1 , b } ^ { ( 1 ) } = \sum _ { j = 1 } ^ { n ^ { ( 0 ) } } \delta _ { b j } ^ { ( 1 ) }
$$

$$
T _ { 2 , b } ^ { ( 1 ) } = \sum _ { j = 1 } ^ { n ^ { ( 0 ) } } \delta _ { b j } ^ { ( 1 ) } y _ { j }
$$

$$
T _ { 3 , b } ^ { ( 1 ) } = \sum _ { j = 1 } ^ { n ^ { ( 0 ) } } \delta _ { b j } ^ { ( 1 ) } y _ { j } y _ { j } ^ { T }
$$

$$
( 1 2 . 2 1 )
$$

$$
n _ { P C } ^ { ( 1 ) } = \sum _ { b = 1 } ^ { g } T _ { 1 , b } ^ { ( 1 ) } .
$$

Thus n(2 denotes the number of observations that have undergone primary compression after the first EM iteration.

Before the second iteration is undertaken, the available memory space, as a consequence of the primary data compression, is filled by a random sample from the balance of observations in the original data set. We let new and retained singleton observations now in the memory; and relabel them U;(j = 1, We let we

$$
n ^ { ( 1 ) } = n _ { P C } ^ { ( 1 ) } + n _ { s } ^ { ( 1 ) } .
$$

<a id="sec-12-7-3"></a>

# 12.7.3 Updating of Parameter Estimates

After the buffer refill , the parameter estimates are updated on the basis of the new sample of observations; the set of observations retained in the buffer, and the compressed representations of the discarded data as follows:

$$
\pi _ { i } ^ { ( 2 ) } \ = \ n ^ { ( 1 ) - 1 } \{ \sum _ { i } ^ { n _ { i } ^ { ( 1 ) } } \tau _ { i } ( y _ { j } ; \Psi ^ { ( 1 ) } ) + \sum _ { i } ^ { g } \tau _ { i } ( \overline { y } _ { b } ; \Psi ^ { ( 1 ) } ) \, T _ { 1 , b } ^ { ( 1 ) } \} ,
$$

$$
\mu _ { i } ^ { ( 2 ) } \ = \ \frac { \sum _ { j = 1 } ^ { j = 1 } i ( y _ { j } , \Psi ^ { - } ) \, y _ { j } + \sum _ { b = 1 } ^ { b } i _ { 1 } ( y _ { b } , \Psi ^ { - } ) \, 1 _ { 2 , b } } { 1 - \sqrt { 1 + ( 1 - ( 2 ) ) ^ { ( 2 ) } } } ,
$$

$$
\Sigma _ { i } ^ { ( 2 ) } \ = \ ( n ^ { ( 1 ) } \pi _ { i } ^ { ( 2 ) } ) ^ { - 1 } \{ \sum _ { j = 1 } ^ { n ^ { ( 1 ) } } \tau _ { i } ( y _ { j } ; \Psi ^ { ( 1 ) } ) y _ { j } y _ { j } ^ { T } + \sum _ { b = 1 } ^ { g } \tau _ { i } ( \bar { y } _ { b } ; \Psi ^ { ( 1 ) } ) \, T _ { 3 , b } ^ { ( 1 ) } \} \\ - \mu _ { i } ^ { ( 2 ) } \mu _ { i } ^ { ( 2 ) ^ { T } }
$$

for i = 1,

Provided that the current mixing proportions %{1, 741) orthe current componentcovariance matrices '(1) are not too disparate, then for a given block sam 6 and, in many situations, close to one for i = b and hence close to zero for i # b.

<a id="sec-12-7-4"></a>

# 12.7.4 Merging of Sufficient Statistics

Primary data compression is then undertaken on the singleton observations in the memory as on the first iteration but with y(1) replaced by We let B42) be the blocks of observations so obtained. The compressed quantities (sufficient statistics) for these new g blocks are merged with those statistics from the previous iteration to give B(2)

$$
T _ { 1 , b } ^ { ( 1 ) } + \sum _ { j = 1 } ^ { n ^ { ( 1 ) } } \delta _ { b j } ^ { ( 2 ) } \, , & & ( 1 2 . 2 6 )
$$

$$
T _ { 2 , b } ^ { ( 2 ) } \ = \ T _ { 2 , b } ^ { ( 1 ) } + \sum ^ { n ^ { ( 1 ) } } \delta _ { b j } ^ { ( 2 ) } y _ { j } \, ,
$$

$$
\overline { j = 1 }
$$

$$
T _ { 3 , b } ^ { ( 1 ) } + \sum _ { j = 1 } ^ { n ^ { ( 1 ) } } \delta _ { b j } ^ { ( 2 ) } y _ { j } y _ { j } ^ { T }
$$

and

for b = 9, where is one or zero, according to whether %; is in or not in block

With the twosets of sufficient statistics so merged, a thirdrandom sample is selected from the original data set to fillupthe memory before proceeding to the third iteration, and so on The process is terminated when the change in the log likelihood after an iteration is arbitrarily small. The algorithm has the provision to handle components that have small estimates for their mixing proportions.

<a id="sec-12-7-5"></a>

# 12.7.5 Secondary Data Compression

The scalable algorithm of Bradley et al. (1999) also has the provision for secondary compression of the data, which we now describe. As explained by Bradley et al. (1999) the motivation for secondary data compression is based on the observation that for a dense region of data not near the normal component means, the posterior probabilities will be approximately the same for all %; constituting the dense region. This secondary compression phase has three stages. The first consists of locating candidate dense regions (clusters) in the data in the buffer. The second consists of applying a criterion to see if the candidate clusters are sufficiently dense. The third state merges acceptably dense clusters with those obtained on the previous iteration provided the merged clusters remain dense according to the criterion (12.29) below. After the kth iteration, the k-means algorithm is used t0 cluster those observations that are not in one of the g blocks, B{_) B4_) , into = are normalized first to have a global sample variance of one for each variable in the feature vector. We let S6 denote the sample covariance matrix of the observations in the bth block so formed (b = 1, 29). If

$$
\max _ { v } ( S _ { b } ) _ { v v } \leq \alpha _ { S C } \, ,
$$

then the observations in this block are purged and replaced by the sufficient statis-

tics which is one or zero, according to whether Vj is in or not in the bth block for 6 = 1, 2g; see Figure 12.6 in which the elliptical (almost spherical) regions correspond to the dense regions. Bradley et al. (1999) set the threshold @sc for sec ondary compression to be equal to 0.5. Suppose that g{_) of these 2g blocks satisfy (12.29). We relabel the sufficient statistics corresponding to these g{) blocks so that are given by and 6 for b = 9+ 1, equations (12.26)t0 (12.28), a given set is merged with a set obtained from secondary compression on the previous iteration if their means are nearest (in Euclidean distance) and the resulting merged block satisfies criterion (12.29). Now let g{_) denote the number k) of distinct sets of sufficient statistics after this merging process. Then these g{ sets of sufficient statistics are appended to the g sets of sufficient statistics obtained by primary compression after the kth M-step to give 9 + g{\*) sets of and =l before proceeding to the (k + 1)th iteration. Using they

![image 35](mclachlan2000_images/imageFile35.png)

Fig. 12.6 Illustration of the idea of secondary compression

<a id="sec-12-7-6"></a>

# 12.7.6 Tuning Constants

As noted by Bradley et al. (1999), their algorithm can handle the simultaneous fitting of multiple mixture models. The scalable algorithm of Bradley et al. (1999) has asc in the secondary compression; and the number of secondary clusters in the application of the k-means algorithm: In order to assess the sensitivity of their fit (multivariate) normal mixture models to synthetic data generated from a mixture of g =10 normal components whose means were chosen uniformly on the interval [0.0, 10.0] and diagonal covariance matrices whose diagonal elements were chosen uniformly on [0.8, 1.2]

For values of the primary compression factor aPc near zero, there is little compression; and so the memory buffer fills and the scalable EM algorithm terminates before the entire database is able to be processed. Hence poor results are obtained as measured by the size of the likelihood at the solution. For large values of @Pc almost all of the data are compressed in the primary compression and so data resolu tion is lost with poor results being obtained for the fit of the mixture model . Optimal values for @Pc occur between these two extremes . On the basis of some simula tion results for various œPc Bradley et al. (1999) noted that the scalable algorithm was fairly insensitive to @Pc away from the extrema; the optimal value occurred at @PC = 0.5Concerning the tuning constant œsc in the secondary compression of the data; there is little compression for small œsc and so data resolution is preserved. Asasc increases from zero, the loss of data resolution starts to increase. But Bradley et al. (1999) found that there is practically no falloff in the resulting fit of the mixture model until @sc goes past 0.6. log

<a id="sec-12-7-7"></a>

# 12.7.7 Simulation Results

On the basis of some simulated data and four real-world data sets, Bradley et al. (1999) compared their scalable EM (SCEM) algorithm with the main de facto practices for dealing with large databases: sampling-based and online methods. In reporting their results below; we let ONEM denote their online version of the EM algorithm whereby single observation is read at a time and the mixture fit updated before purging the observation from memory. The sampling-based version of the EM algorithm; which is applied to a randomly selected sample of the available set is denoted by SAEM. In its applications to the real-world data sets, the sampling rate used by Bradley et al. (1999) varied from 1% to 109 for smaller data sets and varied from 0.19 to 19 for larger data sets to keep the buffer sizes small in the move to the large databases.

Bradley et al. (1999) the scalable EM algorithm to fourreal-world databases: (1) Reuter's information retrieval database; consisting of n = 12,902 news articles with the observation vector V; containing the word count for p = 302 keywords for an article; (2) a subset of the U.S. Bureau Census "adult;" containing n = 299, 285 numeric observations of p 11 dimensions; (3) the astronomy database from the Second Palomar Sky Survey at Caltech with n = 648, 291 observations, each representing objects on a photographic plate with p = 29 numeric attributes; (4) the REV digits recognition database with n = 13, 711 observations of p = 64 dimensions, where each observation represents the gray-scale level of an 8 x 8 image of a handwritten digit. Normal mixture models were fitted to each database, random starts\_ The results for the first three of these databases are summarized in Tables 12.5 to 12.7, which gives the average (over several runs) of the likelihoodat the solution found by the three variants of the EM algorithm minus the value of the log likelihood for the best solution forthe scalable version. The results given are averages; for example, for the first database, are averages of 10solutions for the scalable version, 50 solutions for SAEM (109 and 59), and 100 solutions for ONEM and SAEM (19) It can be seen that for each of these three databases, the scalable version outperforms the sampling-based version. Of course the sampling-based version would generally applicd using log they be the best given enough memory. Rather surprisingly the online version is the best for the astronomy database. For the fourth databasc (REV digits), the scalable and sampling-based versions comparable results superior to the online version for version deteriorated to that of the online version. gave

Table 12.5 Likelihood Difference at Solution for Variants of the EM Algorithm for Reuter's Information Retrieval Database Log

| Version of EM     | Buffer Size as Percentage of Database Sizc |     |                     |
| ----------------- | ------------------------------------------ | --- | ------------------- |
|                   |                                            |     | 19                  |
| Scalable Sampling | 63.9 x 104                                 | 104 | 228.8 ~1568.9 x 104 |
| Online            | 1009 408.4                                 |     |                     |

Source: Adapted from Bradley et al. (1999)

Table 12.6 Likelihood Difference at Solution for Variants of the EM Algorithm for Census Database Log

| Version of EM | Buffer Size as Percentage of Database Size |         |         |           |
| ------------- | ------------------------------------------ | ------- | ------- | --------- |
|               | 59                                         |         | 0.5%    | 0.19      |
| Scalable      | ~0.0178                                    |         | ~1.8706 | ~3.0047   |
| Sampling      | ~8.119                                     | 14204.2 |         | ~85241.84 |
|               | 1009                                       |         |         |           |
| Online        | ~33.6861                                   |         |         |           |

Source: Adapted from Bradley et al. (1999).

Table 12.7 Likelihood Difference at Solution for Variants of the EM Algorithm for Astronomy Database Log

| Version of EM | Buffer Size as Percentage of Database Size |        |         |
| ------------- | ------------------------------------------ | ------ | ------- |
|               |                                            | 5%     |         |
| Scalable      | 197.826                                    | 86.737 |         |
| Sampling      | 216.901                                    | 225.36 | ~892.29 |
|               | 1009                                       |        |         |
| Online        | 43.490                                     |        |         |

Source: Adapted from Bradley et al. (1999)

<a id="sec-12-8"></a>

# 12.8 MULTIRESOLUTION KD-TREES

<a id="sec-12-8-1"></a>

# 12.8.1 Introduction

Moore (1999) has made use of multiresolution kd-trees (mrkd-trees) to speed up the process of the EM algorithm. Here kd stands for k-dimensional where; in our notation, k = p; the dimension of a feature vector Uj = His approach builds a multiresolution data structure to summarize the database at all resolutions of interest simultaneously Precisely; the mrkd-tree is a binary tree that recursively splits the whole set of data points into partitions. Each node in the mrkd-tree is associated with a certain partition (subset) of the data points, and each non-leaf-node has two children nodes, which divide their parents' data points between them. Hence the root node owns all the data points; while the leaf-nodes are the smallest possible partitions this mrkd-tree offers . fitting

The mrkd-tree is constructed top-down; and the partition of the current node (a non-leaf-node) is implemented using the hyper-rectangle of the node, which is defined as the smallest bounding box that contains all the data owned by the node. Based on this p-dimensional hyper-rectangle; the splitting dimension v is identified as the dimension of the hyper-rectangle for which the range of the points is greatest. The current node is split at the midrange of this splitting dimension. That is, the left child of the current node contains those data owned by the node whose values in the v dimension are less than the midrange in the v dimension of the hyper-rectangle. The right child then contains the remainder of the parents' data points. The splitting procedure continues until the range of data points in the v dimension of the hyper-rectangle of the node is smaller than some threshold YThis node is then declared to be a leaf-node and is left =0, then all leaf nodes denote singleton or coincident points. Moore (1999) took Y to be 19 of the range in the v dimension. points points

<a id="sec-12-8-2"></a>

# 12.8.2 EM Algorithm Based on Multiresolution KD-Trees

Moore (1999) proposedto scale the EM algorithm for handling large databases; based on the mrkd-tree. He illustrated his approach for the normal mixture model, but noted that his approach is not necessarily confined to normal components

With the help of the multiresolution data structure built up by the mrk-d tree, the computation of the sufficient statistics can be restructured as follows on the (k + 1)th iteration of the EM algorithm. For the non-leaf-node NLN and current value %(k) for $\Psi$, let

$$
N \ = \ \sum _ { j \in N L N } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) ,
$$

and

for i = 1, For aleaf node LN , the (current) conditional expectations of the sufficient statistics are simplified by all the data in the node to have the same posterior where points

$$
T _ { i 2 , N L N } ^ { ( k ) } \, = \, \sum _ { j \in N L N } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) y _ { j } ,
$$

$$
T _ { i 3 , N L N } ^ { ( k ) } = \sum _ { j \in C N U } \tau _ { i } ( y _ { j } ; \Psi ^ { ( k ) } ) y _ { j } y _ { j } ^ { T }
$$

$$
j \in \overline { N L N }
$$

where

$$
\frac { \pi _ { i } ^ { ( k ) } f _ { i } ( y _ { L N } ; \theta _ { i } ^ { ( k ) } ) } { \sum _ { b = 1 } ^ { g } \pi _ { b } ^ { ( k ) } f _ { b } ( \overline { y } _ { L N } ; \theta _ { b } ^ { ( k ) } ) } \quad ( i = 1 , \dots , g ) ,
$$

$$
j \overline { \in L N }
$$

and where is the number of data belonging to the leaf node LN . Thus equations (12.30) to (12.32) are approximated as points nLN

$$
( 1 2 . 3 4 )
$$

$$
T _ { i 2 , L N } ^ { ( i , j ) }
$$

and

$$
T _ { i 3 , L N } ^ { ( k ) } = \tau _ { i } ( \overline { y } _ { L N } ; \Psi ^ { ( k ) } ) \sum _ { j \in L N } y _ { j } y _ { j } ^ { T }
$$

for i = 1, 9

To the estimates of the component mixing proportions, means, and covariance matrices on the M-step of the EM algorithm, it is first required to perform the E-step, which, for the normal mixture model, involves computing the (current) con{k) ditional expectations of the sufficient statistics; i2 and i3 on the basis of all the data points; that is, to compute equations (12.30) t0 (12.32) for the root node. As the data points of the root node are divided among its children nodes; it follows that update 2\*)

$$
T _ { i q , L N } ^ { ( k ) }
$$

where S denotes the set of all leaf nodes LN. In practice, the leaf nodes should be very small (or Y small) in order that the simplified equations (12.34) to (12.36) be applicable. However; in this situation; the number of leaf nodes will be close to the number of data points n, and hence there is very little computational over the standard EM algorithm. gain

Thus Moore (1999) introduced a further step to reduce the computation time as follows. For each i = 1, 9 at a given node, compute the minimum and maximum values that any point Uj in the node can have for its current posterior probabilities If the differences between these bounds satisfies

$$
\tau _ { i , \max } ^ { ( k ) } - \tau _ { i , \min } ^ { ( k ) } < n ^ { - 1 } \beta \tau _ { i , t o t a l } ^ { ( k ) }
$$

for all i = 1, 9, where ß is a small threshold (say; 0.1), the node is treated as if it is a leaf node. Hence its descendents need not be searched at this iteration. In (12.37), posterior probabilities of ith component membership for all '9

data points. It is not known in advance; but an approximation to it can be given by

It is very difficult to calculate because they dependnot only on the mean andcovariance matrix ofthe ithcomponent, but also on allof the other components. However, itis mucheasier toobtain the bounds on the density at the points belongingtothe node by computing the closest and farthest point from #{k) within the hyper-rectangle for = 1, 9. 44}) denote the Mahalanobis squared distance between +(k) and any points within the hyper-rectangle. Let distances; respectively. Then a bound on the ith component density at points Uj in the node is given by each lower

$$
f _ { i , \min } ^ { ( k ) } =
$$

$$
^ { k ) } _ { \min } = ( 2 \pi ) ^ { - p / 2 } \, | \, \Sigma _ { i } ^ { ( k ) } \, | ^ { - 1 / 2 } \, \exp (
$$

bound on the

#) is given by

$$
\tau _ { i , \min } ^ { ( i ) } = \pi _ { i } ^ { ( i ) } f _ { i , \min } ^ { ( i ) } / \langle \pi _ { i } ^ { ( i ) } f _ { i , \min } ^ { ( i ) } + \sum _ { h \neq i } \pi _ { h } ^ { ( i ) } f _ { h , \max } ^ { ( i ) } \rangle . \\
$$

Similarly, an upper bound of the T can be obtained .

Moore (1999) presented some simulations from normal mixture for various combinations of the parameter values. He reported that speedups vary from 8-foldto bivariate normal mixture, the number of nodes in the mrk-d tree was 22,737 with the default value of 0.1 for ß, yielding a speedup of about 200-fold. The speedup was defined to be the ratio of the time for the final iteration of the standard EM to that the mrkd-tree. As Moore (1999) notes, the cost of building the tree is not included in the speedup calculation, but it is negligible in all the cases he considered, He also notes that the quality of the clustering produced by the mrkd-tree version of the EM is indistinguishable from that obtained with the standard EM algorithm when viewed visually and when measured in terms of the likelihood. using log

Moore (1999) also reported encouraging results in preliminary experiments in applying the mrkd-tree-based EM algorithm to some large real data sets. For exam ple, on the clustering of 800,000 galaxies into 1,000 clusters on the basis of some three-dimensional data; the standard EM needed 35 minutes per iteration, while the mrkd-tree-based EM required only 13 seconds. With 1.6 million galaxies; the standard EM needed 70 minutes per iteration; while the mrkd-tree version required only 14 seconds.

The sparse EM algorithm may be applied under the mrkd-tree data structure That is, instead of considering all g components at all nodes; it is possible to freeze those T; of those nodes. In particular; near the tree's leaves, the posterior probabilities of component membership need to be computed only for a small fraction of the number of components 9. This leads to a further reduction in computation time.
