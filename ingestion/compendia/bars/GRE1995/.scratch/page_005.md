[Page 5]

The Gibbs sampler hardly even makes sense when x has a length that is not fixed, and elements which need not have a fixed interpretation across all models; to resample some components conditional on the remainder would rarely be meaningful. We therefore concentrate on adapting the wider class of Hastings algorithms to the present situation; following the approach outlined by Green (1994), in discussion of Grenander & Miller (1994). This gives a framework for dealing with the case where there is no simple under lying measure.

### 3.2. The General Case

In a typical application with multiple parameter subspaces {8} of different dimen sionality; it will be necessary to devise different types of move between the subspaces. These will be combined to form what Tierney (1994) calls a hybrid sampler, by random choice between available moves at each transition; in order to traverse freely across the combined parameter space 8. We restrict attention to Markov chains in which detailed balance is attained within each move type.

When the current state is x; we propose a move of type m, that would take the state to dx' with probability qm(x; dx' ). For the moment, this is an arbitrary sub-probability measure on to the present state is proposed. Not all moves m will be available from all starting states

As usual probability of acceptance will be denoted by am(x, x' ), and is left undefined at present; the objective of the following analysis is to derive an expression for %m(x, x') which achieves the stated aim of attaining detailed balance within each move type.

The transition kernel we have defined can be written

$$
P(x, B) = \sum_m \int_B q_m(x, dx')\,\alpha_m(x, x') + s(x)\,\mathbf{1}(x \in B) \tag{2}
$$

$$
s(x) := 1 - \sum_m \int q_m(x, dx')\,\alpha_m(x, x')
$$

is the probability of not moving from x, either through a proposed move being rejected;, or because no move is attempted.

The detailed balance relation (1) requires the equilibrium probability of moving from A to B to equal that from B to A, for all Borel sets A, B in <. Substituting (2), we need

For this to hold, it is sufficient that

$$
\int_B \pi(dx')\int_A q_m(x,dx')\alpha_m(x,x') = \int_A \pi(dx)\int_B q_m(x',dx)\alpha_m(x',x) + \int_{B \cap A}\pi(dx')s(x') \tag{3}
$$

$$
\int _ { A } \pi ( d x ) \left | _ { B } q _ { m } ( x , d x ^ { \prime } ) \alpha _ { m } ( x , x ^ { \prime } ) = \left | _ { B } \pi ( d x ^ { \prime } ) \right | _ { A } q _ { m } ( x ^ { \prime } , d x ) \alpha _ { m } ( x ^ { \prime } , x )
$$

for each m, A, B, and to achieve this we choose %m(x, x) as follows.
