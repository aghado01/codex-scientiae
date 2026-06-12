[Page 433]

the results (8.66) and (8.69) derived earlier for the sum-product algorithm, we can readily write down the max-sum algorithm in terms of message passing simply by replacing 'sum' with 'max' and replacing products with sums of logarithms to give

$$
\mu_{f \to x}(x) = \max_{x_1, \dots, x_M} \left[ \ln f(x, x_1, \dots, x_M) + \sum_{m \in \text{ne}(f) \setminus x} \mu_{x_m \to f}(x_m) \right] \tag{8.93}
$$
$$
\mu_{x \to f}(x) = \sum_{l \in \text{ne}(x) \setminus f} \mu_{f_l \to x}(x). \tag{8.94}
$$

The initial messages sent by the leaf nodes are obtained by analogy with (8.70) and (8.71) and are given by

$$
\mu_{x \to f}(x) = 0 \tag{8.95}
$$
$$
\mu_{f \to x}(x) = \ln f(x) \tag{8.96}
$$

while at the root node the maximum probability can then be computed, by analogy with (8.63), using

$$
p^{\max} = \max_x \left[ \sum_{s \in \text{ne}(x)} \mu_{f_s \to x}(x) \right]. \tag{8.97}
$$

So far, we have seen how to ﬁnd the maximum of the joint distribution by propagating messages from the leaves to an arbitrarily chosen root node. The result will be the same irrespective of which node is chosen as the root. Now we turn to the second problem of ﬁnding the conﬁguration of the variables for which the joint distribution attains this maximum value. So far, we have sent messages from the leaves to the root. The process of evaluating (8.97) will also give the value $x^{\max}$ for the most probable value of the root node variable, deﬁned by

$$
x^{\max} = \underset{x}{\arg \max} \left[ \sum_{s \in \text{ne}(x)} \mu_{f_s \to x}(x) \right]. \tag{8.98}
$$

At this point, we might be tempted simply to continue with the message passing algorithm and send messages from the root back out to the leaves, using (8.93) and (8.94), then apply (8.98) to all of the remaining variable nodes. However, because we are now maximizing rather than summing, it is possible that there may be multiple conﬁgurations of $\mathbf{x}$ all of which give rise to the maximum value for $p(\mathbf{x})$. In such cases, this strategy can fail because it is possible for the individual variable values obtained by maximizing the product of messages at each node to belong to different maximizing conﬁgurations, giving an overall conﬁguration that no longer corresponds to a maximum.

The problem can be resolved by adopting a rather different kind of message passing from the root node to the leaves. To see how this works, let us return once again to the simple chain example of $N$ variables $x_1, \dots, x_N$ each having $K$ states,
