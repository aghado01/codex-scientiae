[Page 433]

the results (8.66) and (8.69) derived earlier for the sum-product algorithm, we can readily write down the max-sum algorithm in terms of message passing simply by replacing ‘sum’ with ‘max’ and replacing products with sums of logarithms to give

⎡ ⎣lnf(x,x1,...,xM) +

⎤ ⎦ (8.93)

µf→x(x) = max

m→f(xm)

µx

x1,...,xM

m∈ne(fs)\x

µx→f(x) =

l→x(x). (8.94)

µf

l∈ne(x)\f

The initial messages sent by the leaf nodes are obtained by analogy with (8.70) and (8.71) and are given by

µx→f(x) = 0 (8.95) µf→x(x) = lnf(x) (8.96)

while at the root node the maximum probability can then be computed, by analogy with (8.63), using

###### ⎡ ⎣

⎤ ⎦. (8.97)

pmax = max

s→x(x)

µf

x

s∈ne(x)

So far, we have seen how to ﬁnd the maximum of the joint distribution by propagating messages from the leaves to an arbitrarily chosen root node. The result will be the same irrespective of which node is chosen as the root. Now we turn to the second problem of ﬁnding the conﬁguration of the variables for which the joint distribution attains this maximum value. So far, we have sent messages from the leaves to the root. The process of evaluating (8.97) will also give the value xmax for the most probable value of the root node variable, deﬁned by

###### ⎡ ⎣

⎤ ⎦. (8.98)

xmax = arg max

s→x(x)

µf

x

s∈ne(x)

- At this point, we might be tempted simply to continue with the message passing algorithm and send messages from the root back out to the leaves, using (8.93) and (8.94), then apply (8.98) to all of the remaining variable nodes. However, because we are now maximizing rather than summing, it is possible that there may be multiple conﬁgurations of x all of which give rise to the maximum value for p(x). In such cases, this strategy can fail because it is possible for the individual variable values obtained by maximizing the product of messages at each node to belong to different maximizing conﬁgurations, giving an overall conﬁguration that no longer corresponds to a maximum.


The problem can be resolved by adopting a rather different kind of message passing from the root node to the leaves. To see how this works, let us return once again to the simple chain example of N variables x1,...,xN each having K states,
