[Page 637]

Exercise 13.6

and make use of the deﬁnitions of γ and ξ , we obtain

$$
Q ( \theta , \theta ^ { \text {old} } ) & = \sum _ { k = 1 } ^ { K } \gamma ( z _ { 1 k } ) \ln \pi _ { k } + \sum _ { n = 2 } ^ { N } \sum _ { j = 1 } ^ { K } \xi ( z _ { n - 1 , j } , z _ { n k } ) \ln A _ { j k } \\ & + \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } \gamma ( z _ { n k } ) \ln p ( x _ { n } | \phi _ { k } ) . \\ \intertext { The goal of the E step will be to evaluate the quantities \gamma ( z _ { n } ) \text { and } \xi ( z _ { n - 1 } , z _ { n } ) \text {effi-} }
$$

The goal of the E step will be to evaluate the quantities γ ( z n ) and ξ ( z n − 1 , z n ) efﬁciently, and we shall discuss this in detail shortly. old

In the M step, we maximize Q ( θ , θ ) with respect to the parameters θ = { π , A , φ } in which we treat γ ( z n ) and ξ ( z n − 1 , z n ) as constant. Maximization with respect to π and A is easily achieved using appropriate Lagrange multipliers with the results

$$
\pi _ { k } \ = \ \frac { \gamma ( z _ { 1 k } ) } { K } & & ( 1 3 . 1 8 ) \\ \sum _ { j = 1 } ^ { N } \gamma ( z _ { 1 j } ) & & \\
$$

$$
j = & 1 \int _ { N } ^ { N } \sum _ { \substack { N \\ \leq n = 2 } } ^ { N } \xi ( z _ { n - 1 , j } , z _ { n k } ) \\ \sum _ { l = 1 } ^ { N } \sum _ { n = 2 } ^ { N } \xi ( z _ { n - 1 , j } , z _ { n l } ) \\ \intertext { a n t h m u s t h e i n i l a z e d y b o c h i s o n g t a n t r i g h e r s }
$$

The EM algorithm must be initialized by choosing starting values for π and A , which should of course respect the summation constraints associated with their probabilistic interpretation. Note that any elements of π or A that are set to zero initially will remain zero in subsequent EM updates. A typical initialization procedure would involve selecting random starting values for these parameters subject to the summation and non-negativity constraints. Note that no particular modiﬁcation to the EM results are required for the case of left-to-right models beyond choosing initial values for the elements A jk in which the appropriate elements are set to zero, because these will remain zero throughout. old

To maximize Q ( θ , θ ) with respect to φ k , we notice that only the ﬁnal term in (13.17) depends on φ k , and furthermore this term has exactly the same form as the data-dependent term in the corresponding function for a standard mixture distribution for i.i.d. data, as can be seen by comparison with (9.40) for the case of a Gaussian mixture. Here the quantities γ ( z nk ) are playing the role of the responsibilities. If the parameters φ k are independent for the different components, then this term decouples into a sum of terms one for each value of k , each of which can be maximized independently. We are then simply maximizing the weighted log likelihood function for the emission density p ( x | φ k ) with weights γ ( z nk ) . Here we shall suppose that this maximization can be done efﬁciently. For instance, in the case of
