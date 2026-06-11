[Page 15]

This research was partially supported by grants from the U.S. National Science Foundation and National Institutes of Health.

In order to prove that detailed balance holds for this chain, we have to show that

$$
\pi ( M _ { k } ) \, \text {pr} ( M _ { k - 1 } | M _ { k } ) = \pi ( M _ { k - 1 } ) \, \text {pr} ( M _ { k } | M _ { k - 1 } ),
$$

where M k denotes the parameters of the model with k knots: M k = {k, j 1,..., j k }, for k = 1, 2,...and j i µ (0, 1). The p (M k ) density is the target from which we want to draw observations; in our case p (M k ) is the posterior distribution of M k, namely

$$
\pi ( M _ { k } ) = \frac { p ( y | \xi _ { 1 }, \dots, \xi _ { k } ) p ( \xi _ { 1 }, \dots, \xi _ { k } | k ) p ( k ) } { p ( y ) } .
$$

The formula pr (M k − 1 | M k ) is a Markov transition kernel, the transition probability of going from M k to M k − 1.Let

$$
M _ { k } & = \{ k, \xi _ { 1 }, \xi _ { 2 }, \dots, \xi _ { j ^ { * } - 1 }, \xi _ { j ^ { * } }, \xi _ { j ^ { * } + 1 }, \dots, \xi _ { k } \}, \\ M _ { k - 1 } & = \{ k - 1, \xi _ { 1 }, \xi _ { 2 }, \dots, \xi _ { j ^ { * } - 1 }, \xi _ { j ^ { * } + 1 }, \dots, \xi _ { k } \} .
$$

The sets of knots in the two spaces di ﬀ er only in the j* th element. We can now write the transition probabilities as follows:

$$
p r ( M _ { k - 1 } | M _ { k } ) & = \underbrace { \Pr ( k - 1 | k ) \times \underbrace { \Pr ( \text {delete } \xi _ { j } \ast | k ) \times \underbrace { ( \text {acceptance probability} ) } _ { a _ { k } } } _ { 4 } } _ { 4 } \times \underbrace { \underbrace { ( \text {acceptance probability} ) } _ { z _ { a } } } \\ & = d _ { k } \frac { 1 } { k } \min ( 1, A ), \\ & \Pr ( M _ { k } | M _ { k - 1 } ) = \underbrace { \Pr ( k | k - 1 ) \times \underbrace { \Pr ( \text {add } \xi _ { j } \ast | k - 1 ) \times \underbrace { ( \text {acceptance probability} ) } _ { b _ { k - 1 } } } _ { 1 ( k - 1 ) \sum _ { k } \text {h} ( \xi _ { j } \ast | \xi _ { i } ) } } _ { 1 ( k - 1 ) \sum _ { k } \text {h} ( \xi _ { j } \ast | \xi _ { i } ) } \times \underbrace { z _ { b } } \\ & = b _ { k - 1 } \frac { 1 } { k - 1 } \sum _ { i } h _ { B } ( \xi _ { j } \ast | \xi _ { i } ) \min ( 1, B ), \\ \intertext { where }
$$

where

$$
A = \frac { \pi ( M _ { k - 1 } ) } { \pi ( M _ { k } ) } \, \frac { b _ { k - 1 } ( k - 1 ) ^ { - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) } { d _ { k } k ^ { - 1 } }, \ \ B = \frac { \pi ( M _ { k } ) } { \pi ( M _ { k - 1 } ) } \, \frac { d _ { k } k ^ { - 1 } } { b _ { k - 1 } ( k - 1 ) ^ { - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) } = 1 / A .
$$

We can now verify (A1). If A < 1, then a d = A and a b = 1, and therefore rewriting (A1) we have that

$$
\pi ( M _ { k } ) \, \text {pr} ( M _ { k - 1 } | M _ { k } ) & = \pi ( M _ { k } ) d _ { k } \, \frac { 1 } { k } \, A = \pi ( M _ { k } ) d _ { k } \, \frac { 1 } { k } \, \frac { \pi ( M _ { k - 1 } ) } { \pi ( M _ { k } ) } \, \frac { b _ { k - 1 } ( k - 1 ) ^ { - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) } { d _ { k } k ^ { - 1 } } \\ & = \pi ( M _ { k - 1 } ) b _ { k - 1 } \, \frac { 1 } { k - 1 } \sum _ { i } h _ { B } ( \xi _ { j ^ { * } } | \xi _ { i } ) = \pi ( M _ { k - 1 } ) \, \text {pr} ( M _ { k } | M _ { k - 1 } ).\\ \intertext { t h a n s w h a r } \pi ( M _ { k } ) \, \text {pr} ( M _ { k - 1 } | M _ { k } ) & = \pi ( M _ { k } ) \, \Delta _ { k } \, \text { the } \sigma \, \text {self} \, \text { the } \text {dated} \, \text {length} \, \text {condition} \, \text {wher} \, \text {we}
$$

The case when A > 1 is now obvious. Also the proof of the detailed balance condition when we move from M k to M ∞ k, a relocation step, is straightforward.
