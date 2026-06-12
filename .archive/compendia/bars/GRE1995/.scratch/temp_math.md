--- ENRICHED TEXT OUTPUT ---

[Page 1]

Peter J. Green

Biometrika, Vol. 82, No. 4. (Dec., 1995), pp. 711-732.

Stable URL:

http://links.jstor.org/sici?sici=0006-3444%28199512%2982%3A4%3C711%3ARJMCMC%3E2.0.CO%3B2-F

Biometrika is currently published by Biometrika Trust.

Your use of the JSTOR archive indicates your acceptance of JSTOR's Terms and Conditions of Use, available at http://www.jstor.org/about/terms.html.JSTOR's Terms and Conditions of Use provides, in part, that unless you have obtained prior permission, you may not download an entire issue of a journal or multiple copies of articles, and you may use content in the JSTOR archive only for your personal, non-commercial use.

Please contact the publisher regarding any further use of this work. Publisher contact information may be obtained at http://www.jstor.org/journals/bio.html .

Each copy of any part of a JSTOR transmission must contain the same copyright notice that appears on the screen or printed page of such transmission.

JSTOR is an independent not-for-profit organization dedicated to and preserving a digital archive of scholarly journals. For more information regarding JSTOR, please contact support@jstor.org.


[Page 2]

Department of Mathematics; University of Bristol, Bristol BS8 1TW, UK.

Markov chain Monte Carlo methods for Bayesian computation have until recently been restricted to problems  where the joint distribution of all variables has a density with respect to some fixed standard underlying measure. have therefore not been available for application to Bayesian model determination; where the dimensionality of the parameter vector is typically not fixed. This paper proposes a new framework for the construction of reversible Markov chain samplers that jump between parameter subspaces of differing dimensionality, which is flexible and entirely constructive It should therefore have wide applicability in model determination problems. The methodology is illustrated with appli cations to multiple change-point analysis in one and two dimensions; and to a Bayesian comparison of binomial experiments: They

Some key words: Change-point analysis; Image segmentation; Jump diffusion; Markov chain Monte Carlo; Multiple binomial experiments; Multiple shrinkage; Step function; Voronoi tessellation.

There are a number of challenging statistical problems; often involving inference about curves; surfaces or images, where the dimension of the object of inference is not fixed. One example discussed in detail later in this paper concerns the multiple change-point problem for Poisson processes; where it is assumed that the rate is piecewise constant; but changes an unknown number of times. The times of change and the different rates are unknown. The object of inference is therefore a step function.

There are many problems of broadly similar vein; with the same general ingredients: a discrete choice   between a set of  models, a parameter vector with an interpretation depending on the model in question; and data, influenced by the model and parameter values, to be used as a basis for inference. Some examples are:

(a) factorial experiments, with a allowing factor effects to tie; prior

variable selection in regression;

non-nested regression models;

mixture deconvolution with an unknown number of components;

Bayesian choice between models with different numbers of parameters;

(f) multiple change-point problems;

image segmentation; the two-dimensional analogue of the change-point problem;

(h) object recognition; approached via marked spatial processes. point

Model criticism; model choice, model selection; model averaging, etc, all require the same basic computational tasks; and it is a technology for these tasks that is the focus here. The aim of this paper is to add further weight to the assertions (i) that a Bayesian approach is attractive for such problems; and (ii) that the computations for such inference can be handled by Markov chain Monte Carlo methods. In particular, in $ 3 we introduce à novel class of such methods capable of jumping between subspaces of differing dimensionality. This   considerably  extends the scope of   Metropolis-Hastings  methods; and applies to very many varying-dimension problems.


[Page 3]

Suppose that we have a countable collection of candidate models { Alk, k € % }. Model Ak has a vector 0(k) of unknown parameters; assumed to lie in 9", where the dimension nk may vary from model to model.  With obvious changes; our methods would apply to an arbitrary collection of parameter subspaces:  We observe data y There is a natural hierarchical structure expressed by modelling the joint distribution of (k, 0(), y) as

$$
p ( k, \theta ^ { ( k ) }, y ) = p ( k ) p ( \theta ^ { ( k ) } | k ) p ( y | k, \theta ^ { ( k ) } ),
$$

abbreviate the over 8 = pair

As a concrete example; consider a change-point problem in which there is an unknown number of change-points in a piecewise constant regression function on the interval [0, L]. }, model Mk says that there are exactly k change-points. To parametrise the resulting step function; we need to specify the position of each change-point; and the value of the function on each of the (k + 1) subintervals into which [0,L] is divided. Thus 0() is a vector of length nx = 2k + 1.

Bayesian inference about k and will be based on the joint posterior 0(k)|y), which is the target of the Markov chain Monte Carlo computations described below. It will often be appropriate to factorise this as 0(k) p(k,

$$
p ( k, \theta ^ { ( k ) } | y ) = p (
$$

and to interpret the two terms separately, thus avoiding any 'model averaging.Inference about the model indicator may sometimes be phrased in terms, not of p(kly) but of the Bayes factor for one model relative to another:

$$
\overline { p ( k _ { 0 } | y ) } \overset { \circledast } { \cdot } \overline { p ( k _ { 0 } ) },
$$

which does not depend on the hyperprior p(k) All these quantities are readily estimated from the Markov chain Monte Carlo sample obtained by the methods below; if Bayes factors be specified to implement the computation, but it can be chosen on grounds of convenience. Note that regarding the posterior p(k, 0()|y) as the objective of the computation does not preclude model selection Or prediction ultimately based on a non-coherent principle such as that advocated by Madigan & Raftery (1994); thus the methods of the present paper would be applicable to their analysis. being

Recent work on Markov chain Monte Carlo computation with application to aspects of Bayesian model determination includes Phillips & Smith (1995), based on the jump diffusion samplers of Grenander & Miller (1994), Carlin & Chib (1995) who effectively work with M. Piccioni and G.


[Page 4]

onto subsets of a single parameter space. Each of these approaches has its merits and its disadvantages. In jump-diffusion; there is a conflict between minimising the distortion caused by using a positive time increment; and improving Monte Carlo efficiency.Further, although the jump-diffusion principle is really rather general, the range of jump transitions discussed by Grenander & Miller; and used by Phillips & Smith, is somewhat limited, amounting to conditional versions of Gibbs kernels; and Hastings kernels based on proposals   generated from While these moves   seem adequate for Grenander & Miller's applications; they are perhaps too restricted for general Bayesian computation: The product space approach of Carlin & Chib requires that irrelevant parameters; the 0() for k different from the current k, need to be continually updated, which apparently limits the approach to a small set of models %.In recent unpublished work, A. OHagan and the author have pointed out that there is no need to update the irrelevant parameters to ensure the proper limiting distribution of the chain; but performance of the modified method is not very encouraging The embedding method seems cumbersome and inexplicit in use.

a target distribution of interest. In Bayesian inference, this is the posterior distribution for the parameters given the data, and in the present context of model determination; 'parameters' include the indicator k for the model itself, as well as tation; we construct a Markov transition kernel P(x,dx' ) that is aperiodic and irreducible; and satisfies detailed balance:

$$
= \int _ { B } \int _ { A } \pi ( d x ^ { \prime } ) P ( x ^ { \prime }, d x ),
$$

for all appropriate A, B, and then simulate this chain to obtain a dependent; approximate; the correct limiting distribution, in practical design of samplers it is a convenient restriction to impose.

In straightforward cases; r(dx) is either a discrete probability distribution; or has a joint density with respect to some simple measure, usually Lebesgue; then methods for constructing suitable transition kernels are familiar: The two most popular methods are the Gibbs (Geman & Geman;   1984) and the Metropolis-Hastings method (Metropolis et al, 1953; Hastings, 1970). A full description and some comparisons are given by Tierney (1994), Besag et al. (1995), elsewhere. Briefly, each method proceeds by sweeping around all the variables x = (X1 X2, xn) visiting subsets of the indices in turn; either randomly or systematically. When a subset T of {1,2, n} is visited, the variables Xr:= {xi:ie T} are updated. In the Gibbs sampler, the new values are drawn method, proposed new values xr for these variables are drawn from an essentially arbitrary distribution qr(xr; x) Then; with probability sampler and

$$
\min \left \{ 1, \frac { \pi ( x _ { T } | x _ { - T } ) q _ { T } ( x _ { T }, x ) } { \pi ( x _ { T } | x _ { - T } ) q _ { T } ( x _ { T } ^ { \prime } ; x ) } \right \}
$$

the proposed values are accepted; otherwise; the existing values are retained.


[Page 5]

The Gibbs sampler hardly even makes sense when x has a length that is not fixed, and elements which need not have a fixed interpretation across all models; to resample some components conditional on the remainder would rarely be meaningful. We therefore concentrate on adapting the wider class of Hastings algorithms to the present situation; following the approach outlined by Green (1994), in discussion of Grenander & Miller (1994). This gives a framework for dealing with the case where there is no simple under lying measure.

In a typical application with multiple parameter subspaces {8} of different dimen sionality; it will be necessary to devise different types of move between the subspaces. These will be combined to form what Tierney (1994) calls a hybrid sampler, by random choice between available moves at each transition; in order to traverse freely across the combined parameter space 8. We restrict attention to Markov chains in which detailed balance is attained within each move type.

When the current state is x; we propose a move of type m, that would take the state to dx' with probability qm(x; dx' ). For the moment, this is an arbitrary sub-probability measure on to the present state is proposed. Not all moves m will be available from all starting states

As usual probability of acceptance will be denoted by am(x, x' ), and is left undefined at present; the objective of the following analysis is to derive an expression for %m(x, x') which achieves the stated aim of attaining detailed balance within each move type.

The transition kernel we have defined can be written

$$
P ( x, B ) = \sum _ { m } \left | \Big | _ { B } \right |
$$

$$
s ( x ) \colon = \sum _ { x } \left | \begin{matrix} 1 \\ 0 \end{matrix} \right |
$$

is the probability of not moving from x, either through a proposed move being rejected;, or because no move is attempted.

The detailed balance relation (1) requires the equilibrium probability of moving from A to B to equal that from B to A, for all Borel sets A, B in <. Substituting (2), we need

For this to hold, it is sufficient that

$$
( d x ^ { \prime } ) \int _ { A } q _ { m } ( x ^ { \prime }, d x ) \alpha _ { m } ( x ^ { \prime }, x ) + \int _ { B } \bigcap _ { A } \pi ( d x ^ { \prime } ) s ( x ^ { \prime } ).\ \ ( 3 )
$$

$$
\int _ { A } \pi ( d x ) \left | _ { B } q _ { m } ( x, d x ^ { \prime } ) \alpha _ { m } ( x, x ^ { \prime } ) = \left | _ { B } \pi ( d x ^ { \prime } ) \right | _ { A } q _ { m } ( x ^ { \prime }, d x ) \alpha _ { m } ( x ^ { \prime }, x )
$$

for each m, A, B, and to achieve this we choose %m(x, x) as follows.


[Page 6]

Then

$$
\int _ { A } \pi ( d x ) \int _ { B } q _ { m } ( x, d x ^ { \prime } ) \alpha _ { m } ( x, x ^ { \prime } ) & = \int _ { A } \int _ { B } \xi _ { m } ( d x, d x ^ { \prime } ) \\ & = \int _ { B } \int _ { A } \xi _ { m } ( d x ^ { \prime }, d x ) \\ & = \int _ { B } \pi ( d x ^ { \prime } ) \int _ { A } q _ { m } ( x )
$$

as that

$$
\alpha _ { m } ( x, x ^ { \prime } ) f _ { m } ( x, x ^ { \prime } ) = \alpha _ { m } ( x ^ { \prime }, x ) f _ { m } ( x ^ { \prime }, x ) .
$$

As shown by Peskun (1973) with a proof only for the finite state space case, it is optimal, in the sense of reducing autocorrelation in the realised chain, to make the acceptance probability as large as possible subject to retaining detailed balance. Thus we take

$$
= \min \left \{ 1, \frac { f _ { m } ( x ^ { \prime }, x ) } { f _ { m } ( x, x ^ { \prime } ) } \right \}
$$

which satisfies (4). The possibility that the denominator of the ratio above is zero is not of concern, since for such x;, dx' there is zero probability of proposing such a move, by definition of f; the ratio can therefore safely be set to an arbitrary value. Less formally; but more transparently, we could write this expression using a ratio of measures

$$
= \min \left \{ 1, \frac { \kappa ( \mu \pi ) / q _ { m } ( \lambda ^ { \prime }, \omega \lambda ) } { \omega } \right \} .
$$

For straightforward cases, the dimension-matching requirement can be imposed fairly simply; by following a standard 'template'.We give further details in $ 3-3, but in the meantime add a few remarks.


[Page 7]

Remark 4. Our general framework includes various familiar special cases. When there is only one parameter subspace; with a single dominating measure; it is just the random scan Hastings  method.  Our framework   provides a natural   generalisation methods to general parameter spaces. In the case of point processes; the method is closely related to the spatial birth and death process studied by Preston (1977). Recently; Geyer & Møller (1994) have developed a Hastings sampler for point processes; which is a special case of our construction; derive likelihood inference procedures for point patterns based on this, and  prove results on convergence. The jump-diffusion processes of Grenander & Miller (1994), proposed for Bayesian computation in certain computer vision problems, also provide a special case of our method, but one in which withinparameter-subspace moves are made by a continuous-time diffusion process; which, when discretised temporally for computational purposes; only approximately maintains detailed balance. The range of jump transitions presented by Grenander & Miller is also somewhat restricted. they

The rather obscure 'dimension-matching' Assumption in $ 3-2 deserves interpretation in more intuitive terms. Suppose first that there are just two subspaces < {1} x 9 and move might be to {1, {(01 + 02)}. For this move type; the equilibrium joint proposal probability good

$$
\left | \pi ( d x ) \right | _ { \mathcal { Q } _ { m } } q _ { m } ( x, d x ^ { \prime } ),
$$

where and Bc 2, must have a density with respect to a singular measure on on 93. For detailed balance to be attainable, therefore, it is necessary that the reverse move from A to B should be defined via a proposal distribution qm(x, dx') that for each X = For example, we might draw a random variable u from some distribution; independently of the current state 0, and set 01 = 0+u, 02 = 0 _ u. All that the Assumption does is to ensure that singularities of the sort arising above are self-consistent.

To describe in detail how to  implement the   dimension-matching   requirement in many standard cases, we consider a set-up a little more general than the example just and 'Ik = 2) are proper densities in 9" and 9n2. Consider just one move type; which always switches subspaces; so that q(x, 81) = 0 for x € subscript m is suppressed.The probability of choosing this move will be denoted by j(x). A typical way of accomplishing a transition from < to <2 will be by generating a vector of continuous random variables u(1) of length m1 independently of 0(1), and then of length m2 will be generated and 0(1) set to some function of 0(2) and u(2).For dimensionmatching, there must be a bijection between (0(1), and u(2) ). In particular, the lengths of u(1) and u(2) must satisfy n1 + m1 = n2 + mz The proposal distribution q(x, dx') can now be defined by the distributions of u(1) and which we suppose given by proper p(0(2) | being u(2) u(1)) (0(2), 4(2)


[Page 8]

set

$$
\xi ( A \times B ) = \xi ( B \times A ) = \lambda \{ ( \theta ^ { ( 1 ) }, u ^ { ( 1 ) } ) \colon \theta ^ { ( 1 ) } \in A, \, \theta ^ { ( 2 ) } ( \theta ^ { ( 1 ) }, u ^ { ( 1 ) } ) \in B \},
$$

$$
\xi ( A \times B ) = \xi \{ ( A \cap \mathcal { C } _ { 1 } ) \times ( B \cap \mathcal { C } _ { 2 } ) \} + \xi \{ ( A \cap \mathcal { C } _ { 2 } ) \times ( B \cap \mathcal { C } _ { 1 } ) \} .
$$

$$
f ( x, x ^ { \prime } ) = p ( 1, \theta ^ { ( 1 ) } | y ) j ( 1, \theta ^ { ( 1 ) } ) q _ { 1 } ( u ^ { ( 1 ) } ),
$$

$$
f ( x ^ { \prime }, x ) = p (
$$

$$
= p ( 2, \theta
$$

4 of the equilibrium joint proposal distribution n(dx)q(x, dx')

According to (5), the appropriate acceptance probability for the proposed transition from x = (1,0(1)) to x' = (2,0(2)) is

$$
\min \left \{ 1, \frac { p ( 2, \theta ^ { ( 2 ) } | y ) j ( 2, \theta ^ { ( 2 ) } ) q _ { 2 } ( u ^ { ( 2 ) } ) } { p ( 1, \theta ^ { ( 1 ) } | y ) j ( 1, \theta ^ { ( 1 ) } ) q _ { 1 } ( u ^ { ( 1 ) } ) } \left [ \frac { \partial ( \theta ^ { ( 2 ) }, u ^ { ( 2 ) } ) } { \partial ( \theta ^ { ( 1 ) }, u ^ { ( 1 ) } ) } \right ] \right \},
$$

used above.

then; there is no need to generate the corresponding and the expression for the acceptance probability simplifies. For example; with m2 = 0, it becomes u(i)

$$
\min \left \{ 1, \frac { p ( 2, \theta ^ { ( 2 ) } | y ) j ( 2, \theta ^ { ( 2 ) } ) } { p ( 1, \theta ^ { ( 1 ) } | y ) j ( 1, \theta ^ { ( 1 ) } ) q _ { 1 } ( u ^ { ( 1 ) } ) } \left | \frac { \partial ( \theta ( \theta ^ { ( 1 ) } ) } { \partial ( \theta ^ { ( 1 ) } ) } \right |
$$

Finally, this example is somewhat simplified compared with many real applications; and appropriate modifications may need to be made: For example; may be generated dependently on 0(1, in which case q1(u(1)) is replaced by the conditional density. If other discrete variables are generated in making the proposals; the probability functions of their realised  values are multiplied into the move probabilities j(x). With this latter change, (8) is used repeatedly in the applications later in this paper. u(1)

As our first application of the general construction of $ 3, we present a new Bayesian model for multiple change-point analysis; and develop a reversible jump Markov chain Monte Carlo sampler to compute the posterior distribution

A data set that has been frequently used in illustrating new methods for change-point analysis is the process of dates of serious coal-mining disasters between 1851 and 1962, given by Raftery & Akman (1986) In contrast to some other previous analyses of these data, we will work in continuous time with the points recorded in rather than Figure 1 displays the dates of the 192 disasters in these 112 years 40 907 days as a jittered dot plot, together with the cumulative counting process; shown as a dotted line. n} e [0, L] from a Poisson process with rate given by the point days years.


[Page 9]

0010

0-008

0-006

1

0-004

0002

200

150

100

50

0000

10000

20000

Time (days)

30000

40000

1. Coal mining disaster data, 1851-1962: dates of disasters, cumulative counting process (dotted curve) and posterior mean rate of occurrence (solid curve). Fig

function x(t) the log-likelihood is

$$
\sum _ { i = 1 } ^ { n } \log \{ x ( y _ { i } ) \} - \left [ \sum _ { x ( t ) } x ( t ) \, d t .
$$

We develop a assuming that the rate function x(.) on [0,L] is a function: In this section; we formulate a prior distribution for x step

<S2 < <Sk < L, and that the step function takes the value hj, which k, The prior model is specified by supposing that k is drawn from the Poisson distribution

$$
p ( k ) = e ^ { - \lambda } \frac { \lambda ^ { k } } { k ! },
$$

but conditioned on k < Given k, the step positions 51, S2, Sk are distributed as the even-numbered order statistics from 2k + 1 points uniformly distributed on and the heights ho, h1, hk are independently drawn from the kmax:

This model for step functions is intended to be close to 'uninformative.It is not appropriate to select an improper gamma distribution F(0, 0) for the heights, because that causes insurmountable difficulties with normalisation across differing numbers of steps; all of the probability in the posterior would be assigned to the simplest model. It would perhaps have been more natural to take the step positions independently uniformly distrib prior small:. Since there may be no data in the interval (sj, Sj+1), such short intervals are barely penalised by the likelihood and s0 survive in the posterior, giving a more complicated picture of the true step function than is really justified by the data. The modification used here has the effect of probabilistically spacing out the positions. step


[Page 10]

In developing a reversible jump Monte Carlo sampler for the change-point problem; we are guided by intuition in designing appropriate moves; coupled with the requirements that the dimensions can be balanced properly, that the moves can be simulated conveniently, and that the acceptance ratio can be computed economically. As always with Hastings methods, there is flexibility in this process, and we are not constrained by fine details of the model in question We make no claim of optimality for the particular choices made.

When the object x is a step function on [0, L], some possible transitions are: (a) a change to the height of a randomly chosen step, (b) a change to the position of a randomly chosen step, (c) 'birth' of a new step at a randomly chosen location in [0, L], and (d) 'death' of a randomly chosen step. Note that (c) and (d) involve changing the dimension of x, s0 that standard Markov chain Monte Carlo theory does not apply. In the general framework of 8 3 these transitions can be attained with a countable set of moves, which we denote by {H, P,0, 1,2, } Here H means a a position change; and m = 0, 1, 2, denotes the birth-death pair that increases the number of steps from m to m + 1 steps, or reduces it from m+1 to m

In some applications; the number of steps would be fixed in advance; often, changepoint analysis assumes   exactly one Nevertheless; there  are clear advantages for efficient Monte Carlo computation in allowing k to vary, but to condition on k when drawing information from the realisation: This will allow much better mixing: step.

We now describe these transitions in more detail. At each transition; an independent random choice is made between attempting each of the at most four available move types (H, P;k,k _ 1) signifying height change; position change; birth or death respectively. These have probabilities nk for H, Tx for P, bk for k, and dk for k _ 1, depending only on the current number of steps k, and satisfying nk + Tk + bx + dk = 1. Naturally, do = To = 0, and 0 to impose the preassigned upper limit on the number of steps. Apart from these constraints; these probabilities were chosen s0 that kmax

$$
b _ { k } = c \min \{ 1, p ( k + 1 ) / p ( k ) \}, \ \ d _ { k + 1 } = c \min \{ 1, p ( k ) / p ( k + 1 ) \},
$$

with the constant C as as possible subject to bk +dk < 09 for all k =0, 1, This choice ensures that bkp(k) = dk+1p(k + 1), which is the condition on bk and dk that would guarantee certain acceptance in the corresponding, but much simpler, Hastings sampler for the number of steps alone. Finally for k # 0, we took nk = Tklarge kmax'

If a move of type H or P is chosen; the remaining details are straightforward. A change

to a height is attempted by first choosing one of ho, h1, hx at random; obtaining h; say, then proposing a change to h; such that log(h;/h;) is uniformly distributed on the interval [_4 +4]; this choice is made from convenience, the proposal density ratio taking a simple form: The acceptance probability for this move is found to be

$$
\min [ 1, ( \text {likelihood ratio} ) \times ( h ^ { \prime } _ { j } / h _ { j } ) ^ { \alpha } \exp \{ - \beta ( h ^ { \prime } _ { j } - h _ { j } ) \} ]
$$

in the usual way. Here and later, 'likelihood ratio' means p(ylx')/p(ylx) where x and x' stand for the current and proposed new values of all parameters. For a position change move; one of S1, S2, Sk is drawn at random; obtaining say $j. The proposed replacement value is s5, drawn uniformly on Sj+1], and the acceptance probability turns out to be [sj-1


[Page 11]

$$
\min \left \{ 1, ( \text {likelihood ratio} ) \times \frac { ( s _ { j + 1 } - s _ { j } ) ( s _ { j } - s _ { j - 1 } ) } { ( s _ { j + 1 } - s _ { j } ) ( s _ { j } - s _ { j - 1 } ) } \right \} .
$$

The details for a birth of a step are more complicated, and follow the prescription in 8 3.3. We first choose a position $* for the proposed new step, uniformly distributed on [0L] This must lie, with probability 1, within an If accepted, Sj+1 will be set to s* and Sj+1, Sj+2, Sk will be relabelled as Sj+2, Sj+3, 8k+1, with corresponding changes to the labelling of heights. We wish to propose new heights hj, hj+1 for the step function on the subintervals (Sj, s* and (s*, Sj+1) which recognise that the current height hj on the union of these two intervals is typically well-supported in the posterior distribution; and should therefore not be completely discarded.  Thus the new heights h;, hj+1 should be perturbed in either direction from h; in such a way that h; is a compromise between them. To preserve positivity and maintain simplicity in the acceptance ratio calculations; we use a weighted geometric mean for this compromise; so that step

$$
( s ^ { * } - s _ { j } ) \log ( h ^ { \prime } _ { j } ) + ( s _ { j + }
$$

and define the perturbation to be such that

$$
\frac { \frac { h _ { j + 1 } } { h _ { j } ^ { \prime } } } { u } = \frac { 1 } { u }
$$

with u drawn uniformly from [0,1]

Following the analysis of $ 3-3, the acceptance probability for this proposal has to be calculated to achieve detailed balance with the corresponding death move, which we must therefore first specify.Dimension matching is achieved by reversing the above calculation; weighted geometric mean satisfying

$$
( s _ { j + 1 } - s _ { j } ) \log ( h _ { j } ) + ( s _ { j + 2 } - s _ { j + 1 } ) \log ( h _ { j + 1 } ) = ( s _ { j + 1 } ^ { \prime } - s _ { j + 1 } ^ { \prime } )
$$

The $j+1 that is proposed for removal is simply drawn at random from S1, 82, Sk

The of birth and death moves thus defined satisfies the dimension-matching requirement. The birth increases the dimensionality from 2k +1 to 2k + 3, the difference accounted for by two continuous variables, the new position s* and the u used to separate hj and hj+1. pair being

In deriving an expression for the acceptance probability of the birth proposal, it is helpful to re-write (8) in the form

min {1, (likelihood ratio) x (prior ratio) x (proposal ratio) x (Jacobian)},

noting that p(xly) = p(ylx)p(x)/p(y). In the present context; the likelihood ratio is straightforward, using (9); the ratio, which was previously p(2, 0(2)/p(1, 0(1)), becomes prior

$$
\frac { p ( k + 1 ) } { p ( k ) } \, \frac { 2 ( k + 1 ) ( 2 k + 3 ) } { L ^ { 2 } } \, \frac { ( s ^ { * } - s _ { j } ) ( s _ { j + 1 } - s ^ { * } ) } { s _ { j + 1 } - s _ { j } } \times \frac { \beta ^ { \alpha } } { \Gamma ( \alpha ) } \left ( \frac { h _ { j } ^ { \prime } h _ { j + 1 } ^ { \prime } } { h _ { j } } \right ) ^ { \alpha - 1 } \exp \{ - \beta ( h _ { j } ^ { \prime } h _ { j + 1 } ^ { \prime } )
$$


[Page 12]

the proposal ratio; which was j(2,062))/j(1, (u(1)), becomes

$$
\frac { d _ { k + 1 } L } { b _ { k } ( k + 1 ) },
$$

and the Jacobian is which is not a step function: Figure 2 shows the posterior distribution of k, the number of steps: In Fig: 3, we show the posterior densities of the step positions; conditional on values k = 1, 2 and 3; the graphs become confusing to interpret with more than this many superimposed. The density estimates are obtained a Gaussian kernel with standard deviation 625 Similarly, Fig: 4 shows the corresponding conditional posterior density estimates of height, kernel standard deviation 00003 using days. using days step Some comparisons and contrasts with previous analyses of these data can be made: Raftery & Akman (1986) assume a single change-point, with location assumed a priori to be uniform on the interval [0, L] The step heights are drawn independently from the improper Gamma distribution F6, 0) use the point process likelihood, and calculate the posterior density of r and of the relative change in step height; and the Bayes factor for comparing the hypothesis of a change versus no change; all by numerical integration. The Bayes factor turns out to be over overwhelming evidence for a change. The posterior mode of the time of change is 10 March 1890 = 14313 and a 95% credible interval is [15 1887, 3 August 1895]=[13283,16285] in which compare with a mode of 25 June 1890=day 14420 and an interval of [24 1887, 7 1896] = [13292, 16563] for our analysis; conditional on k =1 Raftery & Akman also give substantive interpretation of their inference in the context of the historical circumstances underlying the data. Carlin, Gelfand & Smith (1992) develop a hierarchical Bayesian approach for the single change-point problem for regression: They apply this to Poisson process data such as the coal mining disaster data by discretising into counts in annual intervals. The position of change is taken as a discrete variable; the step heights are drawn produce posterior densities of heights change is 1891. Barry & Hartigan (1992, 1993) analyse change-point problems product-partition models; Markov chain Monte Carlo methods are used, but the change-points are coded discretely, s0 that they can be handled a fixed set of indicator variables. Stephens (1994) and Phillips & Smith (1995) develop Bayesian analyses for the multiple change-point regression problem; with the positions of change taken as discrete variables; and computations performed by Gibbs sampling and jump-diffusion sampling respectively; however, they do not adapt these methodologies for the process problem: None of these approaches treats the multiple change-point problem in genuinely continuous time; as does our proposed methodology. We see no difficulty with introducing a hierarchical structure into our modelling, if desired. They 1013 day May days, May May They step using again using point

$$
h _ { j }
$$

The acceptance probability for the corresponding death step has the same form with the appropriate change of labelling of the variables; and the ratio terms inverted.

There have been at least two previous proposals for dealing with step functions with a variable number of steps by Markov chain Monte Carlo methods. Newton; Guttorp & Abkowitz (1992) build a model for a biological process a hidden continuous-time Markov chain; and Arjas & Gasbarra (1994) develop a nonparametric approach to sur vival analysis assuming a step function form for the hazard rate. In both of these cations, the step function is not tied down at the right-hand end of the observation interval, so that it can be encoded in a way that side-steps the varying dimensionality problem. using appli -

Presentation of conclusions from Bayesian inference about any reasonably complicated partial. The displays given in Figs 1-4 should not be taken as examples of the last word, either about this particular data set, or about how to present inference for step functions in general. Figures 1 to 4 show different aspects of one particular analysis, in which the hyperparameters are fixed as 2 = 3, = and ß = 200. The Monte Carlo simulation was run for 40 000 updates; after a burn-in period of 4000 updates: A run established that one could have confidence that convergence had taken place by this The computation took 45 seconds on a workstation. In Fig: 1, the solid curve shows the estimated posterior mean curve E{x(t)ly}, kmax pilot point.

03

02

01

00

2

Number of change points

2. Coal mining disaster data: posterior distribution of k, the number of change-points. Fig


[Page 13]

0-0004

0-0003

0-0002

0-0001

00000

10000

20000

30000

40000

change

points

Positions of

3. Coal mining disaster data: posterior density estimates of positions of changepoints;   conditional on number of change-points k =1 (solid curve) k =2 (dotted curves) and k = 3 (broken curves). Fig

800

600

400

200

0002

0-0

0-004

0006

0-008

0010

0012

Rate of process

4. Coal mining disaster data: posterior density estimates of heights of segments k = 2 (dotted curves) and k = 3 (broken curves) Fig


[Page 14]

There are various two-dimensional analogues of change-point analysis. The problem discussed briefly in this section is intended to give an idea of one possibility.

Image segmentation is the process of subdividing a digital image into homogeneous regions, generally as a prelude to further analysis; see Sonka, Hlavac & Boyle (1993). What should be regarded as 'homogeneous' depends on context; often; for example, it involves texture more than intensity. However, here we consider only the simplest version of the problem; in which we wish to subdivide a image; ie. observations arranged on a noise, occurring independently and without blur at each pixel, it is natural to specify a regression model with a piecewise constant mean function; a form of two-dimensional step function: noisy regular tessellation of that part of the plane that is within the field of view. For a flexible and convenient tessellation; we use the Voronoi, or Dirichlet, tessellation; in which each individual polygon; or is defined to be that region of the plane nearer to that tiles generating than to any other. The tessellation is thus specified by the coordinates (u;, ") for i =1,2, k of the k generating points; and the entire step function by these points and the heights h; of the function within the ith tile The step function x therefore satisfies tile, point For a general discussion of the Voronoi tessellation; and an algorithm for its computation; see Green & Sibson (1978). The basic algorithm described there and its subsequent development in the TILE4 package by Sibson and co-workers at the University of Bath are ideally suited to the birth-death Markov chain Monte Carlo simulation methodology used in 8 4 for the one-dimensional change-point problem; appropriately modified.

For computational tractability, we consider here only step functions of this form in which the regions of constancy are polygonal; and we are thus concerned with a polygonal


[Page 15]

In our general notation; the candidate models are indexed by k € % = {1,2, and hood assumed here will be that based on independent Gaussian noise:

$$
p ( y | k, \theta ^ { ( k ) } ) \infty \exp \left [ - \frac { 1 } { 2 \sigma ^ { 2 } } \sum \left \{ y \right \}
$$

over all pixels.

The number of tiles k is modelled to have a Poisson distribution with parameter 2, truncated to k =1,2, Given k, the locations (ui, v) of the generating points are independently and uniformly distributed over the unit square representing the field of view, and prior kmax

The move types used in this problem correspond closely to H, and m = of 8 43; it is not computationally convenient to perform the analogue of P; to move generating point. However, the TILEA package includes routines for adding and deleting generating points, corresponding to birth and death of a and changing the height h; in one tile under detailed balance is entirely straightforward. To explain the birth and death transitions in more detail, some further notation is needed. Let the probabilities of proposing a birth or death when the current number of steps, namely tiles, is k be bk, dk respectively. Consider a proposed birth which would increase the number of steps from k to k+ 1, and suppose that the   new generating point is labelled k*.Its   location (uk*, Uk*) is drawn uniformly from the unit square, and the tessellation modified by the addition of this point; this modification is done on a trial basis; as this birth may not be accepted.  In the updated tessellation the new point has 'neighbours' (Green & Sibson; 1978), which we label as ie$. We compute the old and new areas of these tiles, and denote them by S; + t; and t; respectively. The total reduction Zie sS; gives the area of the tile of the new point k*. The height assigned to the new point is given by h* = hv, where ñ is the weighted geometric mean of the original heights for the neighbouring tiles: step,

$$
\tilde { h } = \left ( \prod _ { i \in \mathcal { I } } h _ { i } ^ { s _ { i } } \right ) ^ { 1 / \sum _ { i } s _ { i } } ;
$$

and v is drawn independently with density function f(v) = 5v4/(1 + v5)2, so that v has distribution symmetric about 0. Finally, the new heights for those tiles modified by the log addition are given by


[Page 16]

$$
h _ { i } ^ { \prime } = \{ h _ { i } ^ { s _ { i } + t _ { i } } ( h ^ { * } ) ^ { - s _ { i } } \} ^ { 1 / t _ { i } } .
$$

The motivation for making these particular assignments is that the integral of h over the whole unit square is thereby left unchanged, while the height assigned to the new tile is a compromise between the heights previously assigned to points in that tile; modified by For the death transition corresponding to this birth; a randomly chosen generating point is deleted; and the points in its tile re-assigned to neighbours. Using ti and Si + t; to denote the old and new areas for neighbouring tile i, its height is changed to log

$$
\{ h _ { i } ^ { t _ { i } } ( h ^ { * } ) ^ { s _ { i } } \} ^ { 1 / ( s _ { i } + t _ { i } ) },
$$

which has the effect of reversing the birth move exactly.

With this of proposal mechanisms; it turns out after some straightforward algebra that the acceptance ratio for the birth is min(1, R) and for the death min(1, R-1), where pair

$$
R = ( \text {likelihood ratio} ) \times \lambda \, \frac { \beta ^ { x } } { \Gamma ( \alpha ) } \left ( h ^ { * } \right ) ^ { x - 1 } \prod _ { i \in \mathcal { I } } \left ( \frac { h _ { i } ^ { x } } { h _ { i } } \right ) ^ { x - 1 } \exp \left [ - \beta \left \{ h ^ { * } + \sum _ { i \in \mathcal { I } } \left ( h _ { i } ^ { \prime } - h _ { i } \right ) \right \} \right ]
$$

$$
R = ( \text {likelihood ratio} ) \times \lambda \, \frac { \beta ^ { x } } { \Gamma ( \alpha ) } \left ( h ^ { * } \right ) ^ { x - 1 } \prod _ { i \in \mathcal { I } } \left ( \frac { h _ { i } ^ { h _ { i } ^ { \prime } } } { h _ { i } } \right ) ^ { x - 1 } \exp \left [ - \beta \left \{ h ^ { * } \\ \\ x \, \frac { d _ { k + 1 } } { b _ { k } ( k + 1 ) f ( v ) } \times \tilde { h } \sum _ { i \in \mathcal { I } } \left \{ \frac { ( s _ { i } + t _ { i } ) h _ { i } ^ { \prime } } { t _ { i } h _ { i } } \right \}, \\
$$

using (8).

Figure 5 displays results from one simple example testing this methodology; based on synthetic data. A 'true' image consisting of a disc of intensity 20 against a background of a lower intensity 05 was degraded with additive Gaussian noise, independently at each pixel on a 50 x 50 grid, with standard deviation 0-7. Note that a disc cannot be perfectly fitted a finite union of Voronoi polygons: The hyperparameters in the were fixed at = = 10 and ß = 10. Figure 5 shows, on the left, the data y(u, v) and, on the right; the posterior mean surface E{x(u; v)ly}, estimated from a run of the sampling method described above, 20 000 sweeps  after a burn-in period of 4000 sweeps. by prior kmax Notwithstanding the apparent complexity of the geometrical calculations to maintain the tessellation and its modifications; and of the computations described in the paragraphs above; the entire sampler runs quickly. On a Sun Sparc 2 workstation, the run described above takes approximately 260 seconds. quite

50

40

30

20

50

40

30

20

10

10

20

30

40

50

10

20

30

40

50

Fig 5. Synthetic segmentation problem: on the left; noisy data; on the right, estimated posterior mean Upper plots show perspective views of the same surfaces displayed as images below.


[Page 17]

selection in regression and mixture deconvolution; have the common feature that the discrete model-choice problem is equivalent to determining a partition; either of the original data units or of some other labels applying to the data, for example factor levels. Here we describe a general partition sampler; and its application to an ANOVA-like problem for binomial data discussed by Consonni & Veronese 1995).

A partition of a set I = {1,2, n} is a collection g = {S1, S2, Sa} of subsets of I, which we call groups; where the S; are disjoint with union I. The number d of groups into which I is divided by g will be called the degree of g, and written d(g) To emphasise

Suppose we have n responses Yns assumed drawn independently   from binomial distributions: Yi Bin(wi, 0;), where the index parameters {w;} are known; and the probabilities {@;} unknown. We construct a distribution for {@;} that acknowledges that these parameters may have similar values within groups defined by a partition g of I = {1, 2, n}.Within each group $;(g) the 0; are drawn independently from beta distributions: prior

$$
, d ( g ) ) .
$$

The group mean parameters   {%j} are in turn drawn independently from the uniform distribution U(O, 1) while the group precision parameter q is either fixed at a known value, Or drawn from a hyperdensity p(q) This is essentially the model proposed by Consonni & Veronese; except that took a more general beta distribution than U(O, 1) only. It would be routine to modify what follows to deal with this situation. Consonni & Veronese  used conventional numerical techniques to ft their model, and so were constrained to use conjugate distributions; for which these techniques were practicable. With reversible jump Markov chain Monte Carlo computation such constraints need not have been imposed. they

Following Consonni & Veronese; the distribution for g is taken as prior

$$
p ( g ) \circ c \frac { d ( g ) ^ { - 1 } } { \# \{ g ^ { \prime } \colon d ( g ^ { \prime } ) = d ( g ) }
$$


[Page 18]

giving equal probability to all partitions of the same degree, and placing probability on the set of g with degree d. Calculation with this is straightforward. It is necessary to count the number of partitions of degree d of a set of n items: this count c(n, d) is the solution of the recurrence relation prior

$$
c ( n, d ) = d c ( n - 1, d ) + c ( n - 1, d - 1 ) .
$$

Such counts become very large with n, and some care is needed to avoid overflow. An alternative model for the partitions that could have been used is Hartigan's productpartition model (Barry & Hartigan; 1992); for given d(g), this favours a more unequal distribution of the items into groups.

The joint distribution of all variables is now determined as

$$
& \quad = p ( g ) \times \prod _ { j = 1 } ^ { d ( g ) } 1 \times p ( q ) \times \prod _ { j = 1 } ^ { d ( g ) } \prod _ { i \in S _ { j } ( g ) } \frac { \theta _ { i } ^ { q \alpha _ { j } - 1 } ( 1 - \theta _ { i } ) ^ { q ( 1 - \theta _ { i } ) } } { B \{ q \alpha _ { j }, q ( 1 - \alpha _ { j } ), q ( 1 - \theta _ { i } ) \} } \\ & \quad \times \prod _ { j = 1 } ^ { n } \left ( w _ { i } \right ) \theta _ { i } ^ { y _ { i } } ( 1 - \theta _ { i } ) ^ { w _ { i } - y _ { i } },
$$

$$
y _ { i }
$$

where B(.,.) is the beta function. In the general notation of $ 2, the model indicator k is g, while the   parameter vector 0(k) is 9 01, 0n), of dimension ng = n + d(g) + 1. d(g)

Much of the following discussion would apply, with few changes; to other partition problems. First we deal with updating the elements of 0(k).(i =1,2, n) are independent beta distributions

$$
, q ( 1 - \alpha _ { j } ) + w _ { i } - y _ { i } ) \} \quad ( i \in S _ { j } ( g ) ),
$$

where, here and below, we use to denote all other variables among

$$
\{ g, \alpha _ { 1 }, \dots, \alpha _ { d ( g ) }, q, \theta _ { 1 }, \dots, \theta _ { n } \} .
$$

Therefore each 0; can be updated with a Gibbs kernel:. For 9 we find

$$
p ( q | \dots ) \circ c \, p ( q ) \times \prod _ { j = 1 } ^ { d ( g ) } \left \{ \prod _ { i \in S _ { j } ( g ) } \theta _ { i } ^ { q \alpha _ { j } - 1 } ( 1 - \theta _ { i } ) ^ { q ( 1 - \alpha _ { j } ) - 1 } \right \},
$$

which is not a standard distribution but is easily evaluated;, and so we use it in a Hastings with proposal that, on the scale, is uniformly distributed about the current value. The group mean parameters are also conditionally independent: step, log

$$
B \{ q \alpha _ { j }, q ( 1 -
$$

Application of Stirling's formula shows that this full conditional has a normal approximation; for large q:

$$
\dots \sim N \left \{ \mu, \frac { \mu ( 1 - \mu ) } { q \# S _ { j } ( g ) } \right \},
$$


[Page 19]

approximately,  where ie S;(g). This approximation could have been used explicitly in an approximate Gibbs sampler; but we choose to use it as a proposal distribution for a Hastings step.

Turning now to the step updating the partition g to g, say, we note that with the prior p(g) specified above all partitions have positive probability, and process that jumps between partitions making only the modest changes of splitting a group; a birth', and combining two groups; a 'death, will be irreducible. It would have been quite natural to have included a move that changed the partition by reallocation of items while fixing the number of groups, but that was not implemented here. We have found the following mechanisms for the partition moves effective in practice; applied to partitions of up to a few dozen objects.

first choose a group to uniformly among those with at least two items. This group is then split at random 'binomially, ie. each item is assigned to one of the two daughter subgroups independently, with probability one-half for each, but conditional on neither subgroup being empty: For a death; attempted with probability dg, we simply choose two groups at random to be combined into one. split;

Jumping to a new partition necessitates a change also to the vector a, since its length has to increase or decrease by 1. Our proposal for the additional component is Gaussian on a logit scale; and takes account of the numbers of binary responses influenced by each of the relevant %j. Specifically, suppose that a proposed birth Sj into subgroups Sj1 and $j2 Let aj be the current value, and aj1, %j2 the new values for the two subgroups. Then we set splits

$$
\alpha _ { j 1 } = \frac { \alpha _ { j } e ^ { \sigma z / W _ { 1 } } } { 1 - \alpha _ { j } + \alpha _ { j } e ^ { \sigma z / W _ { 1 } } }, \quad \alpha _ { j 2 } = \frac { \alpha _ { j } e ^ { - \sigma z / W _ { 2 } } } { 1 - \alpha _ { j } + \alpha _ { j } e ^ { - \sigma z / W _ { 2 } } },
$$

where W = wi (r = 1,2), z is an independent standard Gaussian random variable, and 0 is a spread  parameter to be chosen later. For the corresponding death move;

This   completes the specification of the jump proposal; its acceptance probability is necessarily somewhat complicated in form, but is calculated as usual from (8). For the birth and death, the probabilities are respectively min(1, R) and min(1, R-1), where

$$
third \text { and } \text { death, the probabilities are respectively } \min ( 1, R ) \text { and } \min ( 1, R ^ { - 1 } ), \\ R = \frac { B \{ q \alpha _ { j }, q ( 1 - \alpha _ { j } ) \} ^ { \# S _ { j } } } { B \{ q \alpha _ { j 1 }, q ( 1 - \alpha _ { j 1 } ) \} ^ { \# S _ { 1 } } B \{ q \alpha _ { j 2 }, q ( 1 - \alpha _ { j 2 } ) \} ^ { \# S _ { j 2 } } } \\ \times \ \prod _ { i \in S _ { j 1 } } \left ( \frac { \theta _ { i } } { 1 - \theta _ { i } } \right ) ^ { q ( \alpha _ { j 1 } - \alpha _ { j } ) } \prod _ { i \in S _ { j 2 } } \left ( \frac { \theta _ { i } } { 1 - \theta _ { i } } \right ) ^ { q ( \alpha _ { j 2 } - \alpha _ { j } ) } \times \frac { p ( g ^ { \prime } ) } { p ( g ) } \\ \times \frac { d _ { g ^ { \prime } } } { b _ { g } } \# \{ j \colon \S _ { j } ( g ) \geqslant 2 \} \ \frac { 2 } { d ( g ) \{ d ( g ) + 1 \} } \left ( 2 ^ { \# s _ { j } - 1 } - 1 \right ) \\ \times \frac { \alpha _ { j 1 } ( 1 - \alpha _ { j 1 } ) \alpha _ { j 2 } ( 1 - \alpha _ { j 2 } ) } { \alpha _ { j } ( 1 - \alpha _ { j } ) } \sigma ( W _ { 1 } ^ { - 1 } + W _ { 2 } ^ { - 1 } ) \div ( 2 \pi ) ^ { - \ddagger } \exp ( - \frac { 1 } { 2 } z ^ { 2 } ) .
$$

We apply the methodology described above to a small data set, one of those analysed by Consonni & Veronese (1955). This concerns 4 binomial responses y = (59,89,88,95), each based on wi = 100 trials. The data arise from a 2 x 2 factorial experiment; comparing two treatments (H, planting too high; D, planting too deep) on two varieties of pine seedling (L, longleaf; S, slash) The responses are indexed in the order (LH, LD, SH, SD). Consonni & Veronese   compare various statistical methods a Bayesian method based on their model described above, which has an 'adaptive multiple shrinkage'   property; see   also George (1986) The data determine a partition of the group S; borrow strength by shrinking towards a common value %j- Alternative estimators considered include the maximum likelihood estimators for both a saturated model and for an additive logistic regression; a parametric empirical Bayes estimator which shrinks all   0; together, and a nonparametric empirical Bayes estimator, which has   the multiple shrinkage property. again Our analysis has been confined to repeating that of Consonni & Veronese, but obtained reversible jump Markov chain Monte Carlo instead of their analytic approximations. We extend their results very slightly by allowing 9 to be random; as well as fixed at each of the values they use (100, 200 and 300). This adaptation made use of a p(q) under which 9 is uniform on the interval [log 100, 300]; the proposal for updating q described in the previous section was interpreted as wrapped periodically onto this interval. There were no other unspecified hyperparameters in the model defined above. using prior log log We refer the reader to Consonni & Veronese for further background, including discussion of some of the philosophical issues that arise in the modelling:


[Page 20]

The samplers were also completely specified above; except for the scale factor 0, which we took as 50, after a little experimentation, and the probabilities assigned to each move type. We took the birth and death rates bg and dg each to be 0-3 for all g, except for the extreme partitions where d(g) = 1 or n ( = 4) where bg and dg were taken as (0 6,0) and (0,0.6) At each transition, 0 was  updated with probability 02, and similarly for the (a, 9) pair

Results  are presented in Table 1, based on run lengths of 40 000 attempted updates; after burn-in periods of 4000; such runs took 36 seconds on a Sun Sparc 2 Posterior expectations of {0;} are close to those obtained by Consonni & Veronese: For the case where 9 was taken as random; with the hyperprior specified above; its posterior mean and standard deviation were estimated as 181 and 58. The sampling-based computation

Table 1. Mortality of pine seedlings: posterior means and standard deviations, in parentheses, of {@;}

Consonni & Veronese

Reversible jump MCMC

Experiment

Yi

9 = 100

9 = 200

9 = 300

9 = 100

9 = 200

9 =300

random q

LH

59

0-589

0-588

0588

0.587

0-585

0-586

0588

(0059)

(0056)

(0054)

(0049)

(0050)

(0047)

(0-049)

LD

89

0894

0-895

0+892

0-893

0-894

0893

(0031)

(0-028)

(0027)

(0-027)

(0-026)

(0025)

(0-026)

SH

88

0-886

0.889

0-891

0-886

0-890

0-890

0-888

(0.032)

(0-029)

(0-028)

(0.027)

(0026)

(0-026)

SD

95

0-929

0-924

0.922

0-930

0-926

0-921

0-926

(0-027)

(0-026)

(0-026)

(0.023)

(0-025)

(0.025)

(0-024)

MCMC, Monte Carlo Markov chain method.

H, planting too high; D, planting too deep; L, longleaf seedling; s, slash seedling we show posterior density estimates for the {0;}, under the random q version of the model, together with the raw data, plotted with tick marks at the points yilwi. The adaptive multiple shrinkage is evident are shrunk together, and correspondingly have smaller posterior   variance The data suggest that treatment H increases mortality, but only on seedlings of type L: a more subtle conclusion than from the logistic regression analysis; which simply concludes that both treatment and variety factors have significant effects.


[Page 21]

15

10

1

5

LH

SH

SD

0-0

0-2

06

08

1-0

Fig: 6. Posterior density estimates of {0;} for the pine seedling mortality data; together with raw data plotted as tick marks. H, planting too high; D, planting too longleaf seedling; s, slash seedling: deep;

The theory and applications presented in this paper have demonstrated that the advan tages of Markov chain Monte Carlo computation can be extended to new classes  of problems, where the object of inference has a dimension that is not fixed, including difficult Bayesian model-determination problems.

We have presented three applications of a new Markov chain Monte Carlo method other   implementations have also been developed. For example; jointly with Dr S. Richardson; the author is investigating Bayesian mixture estimation with an unknown number of components, Ph.D. students at Bristol are applying the methods to and in his PhD. thesis at Cambridge   University Dr R Morris has developed a new method of removal of scratches from movie film: ology;

There remain a number of questions about the methodology, to be resolved in future work: One concerns the development of understanding about moves that are likely to be effective generically, to aid intuition about the design of moves. Secondly; in situations where the collection of candidate models is restricted by practical or statistical consider -


[Page 22]

ations; there is the question of whether inventing additional models and corresponding parameter subspaces may facilitate mixing, and if so, how to do it effectively. In problems involving partitions of larger sets of items than those arising in 8 6, we need new jump proposal mechanisms. The proposals used in the pine seedling mortality study were completely 'blind in that made no reference to the current values of any of the other variables. It might be anticipated that taking account of the {%j} would allow the construction of much more efficient proposals; and indeed this is borne out in our recent experience with mixture estimation. Finally, the complications of multiple parameter subspaces of differing dimensionality make the problems of assessing convergence yet more difficult; and there is an urgent need for research on effective diagnostics of broad applicability. they

I wish particularly to thank Sylvia Richardson for stimulating discussions about this work, and for making many valuable suggestions. I also acknowledge comments, connec tions; corrections and correspondence from Julian Besag, Andrew Gelman; Charlie Geyer, Paolo Giudici, Vincent Granville; Andrew Lawson; Jesper   Møller, OHagan; David Stephens; Mike Titterington; and the referee and associate editor. Tony

ARJAS, E: & GASBARRA, D. (1994). Nonparametric Bayesian inference from right censored survival data the Gibbs sampler. Statist. Sinica 4, 505-24. using

BESAG, J., GREEN, P. J., HIGDON, D. & MENGERSEN, K. (1995). Bayesian computation and stochastic systems (with Discussion). Statist. Sci. 10, 3-66.

CARLIN, B P. & CHIB, S. (1995). Bayesian model choice via Markov chain Monte Carlo. J. R. Statist. Soc: B 57, 473-84.

CARLIN B P. GELFAND, A E & SMITH, A F. M. 1992). Hierarchical Bayesian analysis of changepoint problems. Appl. Statist. 41, 389-405.

CONSONNI, G. & VERONESE, P. (1995). A Bayesian method for combining results from several binomial experi ments J Am. Statist. Assoc. 90, 935-44.

GEMAN, $. & GEMAN; D. (1984): Stochastic relaxation; Gibbs distributions and the Bayesian restoration of images. IEEE Trans. Pat. Anal. Mach. Intel 6, 721-41.

GEORGE, E I. (1986). Combining minimax shrinkage estimators J Am. Statist. Assoc. 81, 437-45.

GEYER, C. J & MøLLER; J. (1994) Simulation procedures and likelihood inference for spatial point processes

GREEN, P J. (1994). Discussion of paper by U. Grenander and M. Miller. J. R. Statist. Soc. B 56, 589-90.

GREEN, P J. & SIBSON, R. (1978). Computing Dirichlet tessellations in the plane. Comp. J. 21, 168-73

GRENANDER, U. & MILLER, M. (1994). Representations of knowledge in complex systems (with Discussion).J.R. Statist. Soc. B 56, 549-603.

HASTINGS, W. K. (1970). Monte Carlo sampling methods  using Markov chains  and their   applications. Biometrika 57, 97-109.

MADIGAN, D & RAFTERY, A E. (1994) Model selection and accounting for model uncertainty in graphical models Occam's window. J. Am. Statist. Assoc. 89, 1335-46. using

METROPOLIS, N. ROosENBLUTH, A W ROsENBLUTH, M. N. TELLER, A. H. & TELLER, E. (1953). Equations of state calculations by fast computing machines. J Chem. Phys. 21, 1087-91.

NEWTON, M. A., GUTTORP; P & ABKOWITZ, J. A. (1992). Bayesian inference by simulation in stochastic model from hematology. In Computing Science and Statistics; 24, Ed. H. J. Newton; pp. 449-55. Fairfax Station;, VA: Interface Foundation of North America Inc.

PESKUN, P H. (1973). Optimum Monte-Carlo sampling using Markov chains. Biometrika 60, 607-12


[Page 23]

F:M. (1995) Bayesian model comparison via jump diffusions. In Markov Chain Monte Carlo in Practice, Ed. W T. Richardson and D. J. Spiegelhalter, Ch. 13. London: Chapman and Hall.

PRESTON, C J. (1977). Spatial birth-and-death processes. Bull. Int. Statist. Inst. 46 (2), 371-91.

RAFTERY, A_ E. & AKMAN, V.E. (1986) Bayesian analysis of a Poisson process with a change point. Biometrika 73, 85-9.

SONKA, M., HLAVAC, V. & BOYLE, R. (1993). Image Processing;  Analysis   and Machine Vision. London: Chapman and Hall.

STEPHENS, D. A. (1994). Bayesian retrospective multiple-changepoint identification: Appl. Statist. 43, 159-78. TIERNEY, L. (1994) Markov chains for exploring posterior distributions. Ann. Statist. 22, 1701-28.

[Received January 1995. Revised June 1995]
