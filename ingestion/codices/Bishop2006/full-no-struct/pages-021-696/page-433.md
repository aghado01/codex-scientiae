[Page 433]

$$
\begin{array} { r l } & { \text {replacing $sum$ with $max$ and replacing products with sums of logarithmhs to give} } \\ \\ & { \quad \mu _ { f \to x } ( x ) } & { = } & { \max _ { x _ { 1 } , \dots , x _ { M } } \left [ \ln f ( x , x _ { 1 } , \dots , x _ { M } ) + \sum _ { m \in \real ( f _ { s } ) \smallsetminus f ( x _ { m } ) } \right ] ( 8 . 9 3 ) } \\ \\ & { \mu _ { x \to f } ( x ) } & { = } & { \sum _ { m \in \real ( f _ { i } \to x ) } ( \mu _ { f \to x } ( x ) . } \end{array}
$$

$$
\mu _ { x \to f } ( x ) \ = \ \sum _ { l \in \text {ne} ( x ) \ \ f } \mu _ { f _ { l } \to x } ( x ) . \\
$$

The initial messages sent by the leaf nodes are obtained by analogy with (8.70) and (8.71) and are given by

$$
\mu _ { x \rightarrow f } ( x ) \ & = \ 0 \\ \mu _ { x } ( x ) & = \ \ln f ( x )
$$

$$
\mu _ { f \rightarrow x } ( x ) \ = \ \ln f ( x )
$$

while at the root node the maximum probability can then be computed, by analogy with (8.63), using

$$
\text {using} \\ p ^ { \max } = \max _ { x } \left [ \sum _ { s \in \text {ne} ( x ) } \mu _ { f _ { s } \to x } ( x ) \right ] . \\ \intertext { t o o n d e l o w s i n t h e f i m a m u l } \text {ages from the leaves to an arbitrarily chosen root node. The result will}
$$

So far, we have seen how to ﬁnd the maximum of the joint distribution by propagating messages from the leaves to an arbitrarily chosen root node. The result will be the same irrespective of which node is chosen as the root. Now we turn to the second problem of ﬁnding the conﬁguration of the variables for which the joint distribution attains this maximum value. So far, we have sent messages from the leaves to the root. The process of evaluating (8.97) will also give the value x max for the most probable value of the root node variable, deﬁned by

$$
\text {value of the root node variable, defined by} \\ x ^ { \max } = \arg \max _ { x } \left [ \sum _ { s \in \text {ne} ( x ) } \mu _ { f _ { s } + x } ( x ) \right ] . \\ \intertext { t , w \, \text {might be temputed simply to continue with the message passing al-} }
$$

At this point, we might be tempted simply to continue with the message passing algorithm and send messages from the root back out to the leaves, using (8.93) and (8.94), then apply (8.98) to all of the remaining variable nodes. However, because we are now maximizing rather than summing, it is possible that there may be multiple conﬁgurations of x all of which give rise to the maximum value for p ( x ) . In such cases, this strategy can fail because it is possible for the individual variable values obtained by maximizing the product of messages at each node to belong to different maximizing conﬁgurations, giving an overall conﬁguration that no longer corresponds to a maximum.

The problem can be resolved by adopting a rather different kind of message passing from the root node to the leaves. To see how this works, let us return once again to the simple chain example of N variables x 1 ,...,x N each having K states,
