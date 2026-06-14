[Page 17]

We commence our classiﬁcation scheme with a persistence diagram D belonging to an unknown class. We assume that D is sampled from a Poisson point process D in W with the prior intensity λ D having the form in (M2 ). Consequently, its probability density has the form

$$
p _ { \mathcal { D } } ( D ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \lambda _ { \mathcal { D } } ( d ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \sum _ { i = 1 } ^ { N } c _ { i } ^ { P } \mathcal { N } ^ { * } ( d ; \mu _ { i } ^ { \mathcal { D } } , \sigma _ { i } ^ { \mathcal { D } } I ) ,
$$

where λ =   W λ D = E ( |D| ), with probability α as in (M2   ). Next suppose we have two training sets T Y := D Y 1: n and T Y   := D Y   1: m from two classes of random diagrams D Y and D Y   , respectively. The likelihood densities of respective classes take the form of Equation (6). We then follow Equation (8) to obtain the posterior intensities of D given the training sets T Y and T Y   from the prior intensities and likelihood densities. In particular, the corresponding posterior probability density of D given the training set T Y is N

$$
p _ { D | \mathcal { D } _ { Y } } ( D | T _ { Y } ) & = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \lambda _ { D | T _ { Y } } ( d ) = \frac { e ^ { - \lambda } } { | D | ! } \prod _ { d \in D } \left [ ( 1 - \alpha ) \lambda _ { \mathcal { D } } ( d ) + \frac { \alpha } { n } \sum _ { y _ { j } \in T _ { Y } } \sum _ { i = 1 } ^ { N } C _ { i } ^ { d | y _ { j } } \mathcal { N } ( d ; \mu _ { i } ^ { d | y _ { j } } , \sigma _ { i } ^ { d | y _ { j } } I ) \right ] , \ ( 1 0 )
$$

and the posterior probability density given T   Y is given by an analogous expression. The Bayes factor deﬁned by BF ( D ) = p D |D Y ( D | T Y ) (11)

$$
B F ( D ) = \frac { p _ { D | \mathcal { D } _ { Y } } ( D | T _ { Y } ) } { p _ { D | \mathcal { D } _ { Y ^ { \prime } } } ( D | T _ { Y ^ { \prime } } ) }
$$

provides the decision criterion for assigning D to either D Y or D Y . More speciﬁcally, for a threshold c , BF ( D ) > c implies that D belongs to D Y and BF ( D ) < c implies otherwise. We summarize this scheme in Algorithm 1 .

## Algorithm 1 Bayes Factor Classiﬁcation of Persistence Diagrams

- 1: Input 1 : Prior intensities λ D Y , and λ D Y for two classes of diagrams D Y and D Y respectively; a threshold c > 0.
- 2: Input 2 : Two training sets T Y and T Y sampled from D Y and D Y , respectively.
- 3: for D Y and , D Y do
- 4: Compute p D|D Y ( D | T Y ) and p D|D Y   ( D | T Y   ).
- 5: end for
- 6: Compute BF ( D ) as in Equation (11)
- 7: if BF ( D ) > c then
- 8: assign D to D Y .
- 9: else
- 10: assign D to D Y .
- 11: end if


## 4.1 Atom Probe Tomography Data

Our goal in this section is to use Algorithm 1 to classify the crystal lattice of a noisy and sparse materials dataset, where the unit cells are either Body centered cubic (BCC) or Face centered cubic (FCC); recall Figure 1. The BCC structure has a single atom in the center of the cube, while the FCC has a void in its center but has atoms on the centers of the cubes’ faces (Figure 1 (b-c)). However, sparsity and noise do not allow the crystal structure to be revealed. For high-entropy alloys, our object of interest, APT, provides the best atomic level characterization possible. Due to the sparsity and noise in the resulting data, there
