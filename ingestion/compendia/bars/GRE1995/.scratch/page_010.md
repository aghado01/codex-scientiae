[Page 10]

### 4.3. Using Reversible Jumps for Step Functions

In developing a reversible jump Monte Carlo sampler for the change-point problem; we are guided by intuition in designing appropriate moves; coupled with the requirements that the dimensions can be balanced properly, that the moves can be simulated conveniently, and that the acceptance ratio can be computed economically. As always with Hastings methods, there is flexibility in this process, and we are not constrained by fine details of the model in question We make no claim of optimality for the particular choices made.

When the object x is a step function on [0, L], some possible transitions are: (a) a change to the height of a randomly chosen step, (b) a change to the position of a randomly chosen step, (c) 'birth' of a new step at a randomly chosen location in [0, L], and (d) 'death' of a randomly chosen step. Note that (c) and (d) involve changing the dimension of x, so that standard Markov chain Monte Carlo theory does not apply. In the general framework of 8 3 these transitions can be attained with a countable set of moves, which we denote by {H, P,0, 1,2, } Here H means a a position change; and m = 0, 1, 2, denotes the birth-death pair that increases the number of steps from m to m + 1 steps, or reduces it from m+1 to m

In some applications; the number of steps would be fixed in advance; often, changepoint analysis assumes   exactly one Nevertheless; there  are clear advantages for efficient Monte Carlo computation in allowing k to vary, but to condition on k when drawing information from the realisation: This will allow much better mixing: step.

We now describe these transitions in more detail. At each transition; an independent random choice is made between attempting each of the at most four available move types (H, P;k,k _ 1) signifying height change; position change; birth or death respectively. These have probabilities nk for H, Tx for P, bk for k, and dk for k _ 1, depending only on the current number of steps k, and satisfying nk + Tk + bx + dk = 1. Naturally, do = To = 0, and 0 to impose the preassigned upper limit on the number of steps. Apart from these constraints; these probabilities were chosen so that kmax

$$
b _ { k } = c \min \{ 1 , p ( k + 1 ) / p ( k ) \} , \ \ d _ { k + 1 } = c \min \{ 1 , p ( k ) / p ( k + 1 ) \} ,
$$

with the constant C as as possible subject to $b_k + d_k \leq 1$ for all $k = 0, 1, \ldots$ This choice ensures that $b_k p(k) = d_{k+1} p(k+1)$, which is the condition on $b_k$ and $d_k$ that would guarantee certain acceptance in the corresponding, but much simpler, Hastings sampler for the number of steps alone. Finally for $k \neq 0$, we took $\eta_k = \tau_k$ for all $k < k_{\max}$.

If a move of type H or P is chosen; the remaining details are straightforward. A change to a height is attempted by first choosing one of $h_0, h_1, \ldots, h_k$ at random, obtaining $h_j$ say, then proposing a change to $h'_j$ such that $\log(h'_j/h_j)$ is uniformly distributed on the interval $[-4, +4]$; this choice is made from convenience, the proposal density ratio taking a simple form: The acceptance probability for this move is found to be

$$
\min [ 1 , ( \text {likelihood ratio} ) \times ( h ^ { \prime } _ { j } / h _ { j } ) ^ { \alpha } \exp \{ - \beta ( h ^ { \prime } _ { j } - h _ { j } ) \} ]
$$

in the usual way. Here and later, 'likelihood ratio' means p(ylx')/p(ylx) where x and x' stand for the current and proposed new values of all parameters. For a position change move, one of $s_1, s_2, \ldots, s_k$ is drawn at random, obtaining $s_j$ say. The proposed replacement value $s'_j$ is drawn uniformly on $[s_{j-1}, s_{j+1}]$, and the acceptance probability turns out to be
