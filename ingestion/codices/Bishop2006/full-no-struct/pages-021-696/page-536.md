[Page 536]

# Section 8.4.4

These are precisely the messages obtained using belief propagation in which messages from variable nodes to factor nodes have been folded into the messages from factor nodes to variable nodes. In particular, f b 2 ( x 2 ) corresponds to the message µ f b → x 2 ( x 2 ) sent by factor node f b to variable node x 2 and is given by (8.81). Similarly, if we substitute (8.78) into (8.79), we obtain (10.235) in which f a 2 ( x 2 ) corresponds to µ f a → x 2 ( x 2 ) and f c 2 ( x 2 ) corresponds to µ f c → x 2 ( x 2 ) , giving the message f b 3 ( x 3 ) which corresponds to µ f b → x 3 ( x 3 ) . This result differs slightly from standard belief propagation in that messages are

passed in both directions at the same time. We can easily modify the EP procedure to give the standard form of the sum-product algorithm by updating just one of the factors at a time, for instance if we reﬁne only f b 3 ( x 3 ) , then f b 2 ( x 2 ) is unchanged by deﬁnition, while the reﬁned version of f b 3 ( x 3 ) is again given by (10.235). If we are reﬁning only one term at a time, then we can choose the order in which the reﬁnements are done as we wish. In particular, for a tree-structured graph we can follow a two-pass update scheme, corresponding to the standard belief propagation schedule, which will result in exact inference of the variable and factor marginals. The initialization of the approximation factors in this case is unimportant.

Now let us consider a general factor graph corresponding to the distribution

$$
\ a \text { general factor graph corresponding to the distribution } \\ p ( \theta ) = \prod _ { i } f _ { i } ( \theta _ { i } ) & & ( 1 0 . 2 3 6 ) \\ \intertext { s u b s e } \text { subset of variables associated with factor } f _ { i } . \text { We approximate }
$$

where θ i represents the subset of variables associated with factor f i . We approximate this using a fully factorized distribution of the form

$$
& \text {organized distribution of the form} \\ & \quad q ( \theta ) \subset \prod _ { i \ k } \widetilde { f } _ { i k } ( \theta _ { k } ) \\ & \text {s to an individual variable node. Suppose that we wish to refine} \\ & \quad ( 0 ) \, \text {learning all other terms, fixed} \, \text {We first guess the term}
$$

where θ k corresponds to an individual variable node. Suppose that we wish to reﬁne the particular term f jl ( θ l ) keeping all other terms ﬁxed. We ﬁrst remove the term f j ( θ j ) from q ( θ ) to give q \ j ( θ ) ∝ i = j k f ik ( θ k ) (10.238)

$$
\text {give} & & q ^ { \vee j } ( \theta ) \, \infty \prod _ { i \neq j \, \ k } \widetilde { f } _ { i k } ( \theta _ { k } ) & & ( 1 0 . 2 3 8 ) \\ \intertext { y } \text {the exact factor } f _ { j } ( \theta _ { j } ) . \text { To determine the refined term } \widetilde { f } _ { j l } ( \theta _ { l } ) , & &
$$

/negationslash

and then multiply by the exact factor f j ( θ j ) . To determine the reﬁned term f jl ( θ l ) , we need only consider the functional dependence on θ l , and so we simply ﬁnd the corresponding marginal of q \ j ( θ ) f ( θ ) . (10.239)

$$
q ^ { \langle j } ( \theta ) f _ { j } ( \theta _ { j } ) .
$$

Up to a multiplicative constant, this involves taking the marginal of f j ( θ j ) multiplied by any terms from q \ j ( θ ) that are functions of any of the variables in θ j . Terms that correspond to other factors f i ( θ i ) for i = j will cancel between numerator and denominator when we subsequently divide by q \ j ( θ ) . We therefore obtain f jl ( θ l ) ∝ f j ( θ j ) f km ( θ m ) . (10.240)

/negationslash

$$
\sigma \text { when we subsequently divide by } q ^ { \varnothing } ( \theta ) . \text { We therefore obtain } \\ \widetilde { f } _ { j l } ( \theta _ { l } ) \, \infty \, \sum _ { \theta _ { m } \neq \iota \in \theta _ { j } } f _ { j } ( \theta _ { j } ) \prod _ { k \ m \neq l } \prod _ { \widetilde { f } _ { k m } ( \theta _ { m } ) } ( 1 0 . 2 4 0 )
$$

/negationslash

/negationslash
