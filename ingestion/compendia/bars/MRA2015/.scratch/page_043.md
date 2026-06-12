
The posterior distribution for this model is given by

p ( β , b , b γ ,δ,η,g 1 ,g 2 | I ) ∝ p ( I | β , b ) p ( b | γ ,δ ) p ( δ | g 1 ) p ( g 1 ) p ( b γ | η ) p ( η | g 2 ) p ( g 1 ) p ( β ) ,

where I = ( I n ( ω 1 ) ,..., ( I n ( ω M )) . To draw ( β , b , b γ ,δ,η,g 1 ,g 2 ) from their joint posterior distribution, MCMC methods are employed as follows:

1. The parameter vectors β and b are sampled jointly as θ = ( β , b ) via a MetropolisHastings step from its conditional posterior distribution whose logarithm is

$$
\log p ( \theta | I , C ) = \sum _ { m = 1 } ^ { M } [ c _ { m } ^ { \prime } \theta - I _ { n } ( \omega _ { m } ) \exp ( c _ { m } ^ { \prime } \theta ) ] - \frac { 1 } { 2 } \theta ^ { \prime } \Lambda \theta ,
$$

where c m is the m th row of C .

- 2. The b γk ’s are sampled via a Metropolis-Hastings step from

$$
p ( b _ { \gamma } | \gamma , b , \delta , \eta ) \, \in \, | D _ { \gamma } | ^ { 1 / 2 } \exp \left \{ - \frac { \delta } { 2 } b ^ { \prime } D _ { \gamma } b - \frac { \eta } { 2 } b ^ { \prime } _ { \gamma } b _ { \gamma } \right \} .
$$

- 3. The parameter δ is sampled from the gamma distribution, G ( 1 2 ( K κ + ν 1 ) , 1 2 b D γ b + ν 1 g 1 ).
- 4. The parameter g 1 is sampled from the inverse gamma distribution,

$$
I G \left ( \frac { 1 } { 2 } ( \nu _ { 1 } + 1 ) , \nu _ { 1 } \delta + \frac { 1 } { G _ { 1 } ^ { 2 } } \right ) .
$$

- 5. The parameter η is sampled form the gamma distribution,

$$
G \left ( \frac { 1 } { 2 } ( K _ { \iota } + q + \nu _ { 2 } ) , \frac { 1 } { 2 } b _ { \gamma } ^ { \prime } b _ { \gamma } + \frac { \nu _ { 2 } } { g _ { 2 } } \right ) .
$$

- 6. The parameter g 2 is sampled from the inverse gamma distribution,


$$
I G \left ( \frac { 1 } { 2 } ( \nu _ { 2 } + 1 ) ) , \nu _ { 2 } \eta + \frac { 1 } { G _ { 2 } ^ { 2 } } \right ) .
$$

For further details on the derivations of the full conditional posterior distributions for the various parameters and the Metropolis-Hastings steps, refer to Appendix A.3.
