[Page 561]

for some set of mixing coefﬁcients α 1 ,...,α K satisfying α k 0 and k α k = 1 . Alternatively, the base transitions may be combined through successive application, so that

$$
s o t a t \\ T ( z ^ { \prime } , z ) & = \sum _ { z _ { 1 } } \dots \sum _ { z _ { n - 1 } } B _ { 1 } ( z ^ { \prime } , z _ { 1 } ) \dots B _ { K - 1 } ( z _ { K - 2 } , z _ { K - 1 } ) B _ { K } ( z _ { K - 1 } , z ) . \ \ ( 1 1 . 4 3 ) \\ \intertext { I f a d i b u t i o n is i n v a r i a n t w i t h e r s e c t o a t h e a c h o t h e b u s t i m p o r s }
$$

If a distribution is invariant with respect to each of the base transitions, then obviously it will also be invariant with respect to either of the T ( z , z ) given by (11.42) or (11.43). For the case of the mixture (11.42), if each of the base transitions satisﬁes detailed balance, then the mixture transition T will also satisfy detailed balance. This does not hold for the transition probability constructed using (11.43), although by symmetrizing the order of application of the base transitions, in the form B 1 ,B 2 ,...,B K ,B K ,...,B 2 ,B 1 , detailed balance can be restored. A common example of the use of composite transition probabilities is where each base transition changes only a subset of the variables.

# 11.2.2 The Metropolis-Hastings algorithm

Earlier we introduced the basic Metropolis algorithm, without actually demonstrating that it samples from the required distribution. Before giving a proof, we ﬁrst discuss a generalization, known as the Metropolis-Hastings algorithm (Hastings, 1970), to the case where the proposal distribution is no longer a symmetric function of its arguments. In particular at step τ of the algorithm, in which the current state is z ( τ ) , we draw a sample z from the distribution q k ( z | z ( τ ) ) and then accept it with probability A k ( z , z τ ) where

$$
& \text {it with probability } A _ { k } ( z ^ { * } , z _ { \tau } ) \text { where} \\ & \quad A _ { k } ( z ^ { * } , z ^ { ( \tau ) } ) = \min \left ( 1 , \frac { \widetilde { p } ( z ^ { * } ) q _ { k } ( z ^ { ( \tau ) } | z ^ { * } ) } { \widetilde { p } ( z ^ { ( \tau ) } ) q _ { k } ( z ^ { * } | z ^ { ( \tau ) } ) } \right ) . \\ & \text {labels the members of the set of possible transitions being considered.  Again,} \\
$$

A k ( z , z ) = min 1 , p ( z ( τ ) ) q k ( z | z ( τ ) ) . (11.44) Here k labels the members of the set of possible transitions being considered. Again, the evaluation of the acceptance criterion does not require knowledge of the normalizing constant Z p in the probability distribution p ( z ) = p ( z ) /Z p . For a symmetric proposal distribution the Metropolis-Hastings criterion (11.44) reduces to the standard Metropolis criterion given by (11.33). We can show that p ( z ) is an invariant distribution of the Markov chain deﬁned

by the Metropolis-Hastings algorithm by showing that detailed balance, deﬁned by (11.40), is satisﬁed. Using (11.44) we have

$$
p ( z ) q _ { k } ( z | z ^ { \prime } ) A _ { k } ( z ^ { \prime } , z ) & \ = \ \min \left ( p ( z ) q _ { k } ( z | z ^ { \prime } ) , p ( z ^ { \prime } ) q _ { k } ( z ^ { \prime } | z ) \right ) \\ & = \ \min \left ( p ( z ^ { \prime } ) q _ { k } ( z ^ { \prime } | z ) , p ( z ) q _ { k } ( z | z ^ { \prime } ) \right ) \\ & = \ p ( z ^ { \prime } ) q _ { k } ( z ^ { \prime } | z ) A _ { k } ( z , z ^ { \prime } ) \\ \intertext { as required }
$$

as required.

The specific choice of proposal distribution can have a marked effect on the performance of the algorithm. For continuous state spaces, a common choice is a Gaussian centred on the current state, leading to an important trade-off in determining the variance parameter of this distribution. If the variance is small, then the Schematic illustration of the use of an isotropic Gaussian proposal distribution (blue circle) to sample from a correlated multivariate Gaussian distribution (red ellipse) having very different standard deviations in different directions, using the Metropolis-Hastings algorithm. In order to keep the rejection rate low, the scale ρ of the proposal distribution should be on the order of the smallest standard deviation σ min , which leads to random walk behaviour in which the number of steps separating states that are approximately independent is of order ( σ max /σ min ) 2 where σ max is the largest standard deviation.
