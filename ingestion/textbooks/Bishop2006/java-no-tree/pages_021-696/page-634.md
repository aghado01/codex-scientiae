[Page 634]

Figure 13.9 Example of the state transition diagram for a 3-state left-to-right hidden Markov model. Note that once a state has been vacated, it cannot later be re-entered.

A11 A22 A33

A12 A23

k = 1 k = 2 k = 3

A13

state transition diagram for a 3-state HMM in Figure 13.9. Typically for such models the initial state probabilities for p(z1) are modiﬁed so that p(z11) = 1 and p(z1j) = 0 for j = 1, in other words every sequence is constrained to start in state j = 1. The transition matrix may be further constrained to ensure that large changes in the state index do not occur, so that Ajk = 0 if k > j + ∆. This type of model is illustrated using a lattice diagram in Figure 13.10.

Many applications of hidden Markov models, for example speech recognition, or on-line character recognition, make use of left-to-right architectures. As an illustration of the left-to-right hidden Markov model, we consider an example involving handwritten digits. This uses on-line data, meaning that each digit is represented by the trajectory of the pen as a function of time in the form of a sequence of pen coordinates, in contrast to the off-line digits data, discussed in Appendix A, which comprises static two-dimensional pixellated images of the ink. Examples of the online digits are shown in Figure 13.11. Here we train a hidden Markov model on a subset of data comprising 45 examples of the digit ‘2’. There are K = 16 states, each of which can generate a line segment of ﬁxed length having one of 16 possible angles, and so the emission distribution is simply a 16 × 16 table of probabilities associated with the allowed angle values for each state index value. Transition probabilities are all set to zero except for those that keep the state index k the same or that increment it by 1, and the model parameters are optimized using 25 iterations of EM. We can gain some insight into the resulting model by running it generatively, as shown in Figure 13.11.

Figure 13.10 Lattice diagram for a 3-state leftto-right HMM in which the state index k is allowed to increase by at most 1 at each transition. k = 1

A11 A11 A11

- k = 2
- k = 3


A33 A33 A33

n − 2 n − 1 n n + 1
