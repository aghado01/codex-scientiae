[Page 646]

Figure 13.15 A simpliﬁed form of factor graph to describe the hidden Markov model.

![Figure 13.15](../images/imageFile315.png)

To derive the alpha-beta algorithm, we denote the ﬁnal hidden variable $\mathbf{z}_N$ as the root node, and ﬁrst pass messages from the leaf node $h$ to the root. From the general results (8.66) and (8.69) for message propagation, we see that the messages which are propagated in the hidden Markov model take the form

$$
\mu_{z_{n-1} \to f_n}(\mathbf{z}_{n-1}) = \mu_{f_{n-1} \to z_{n-1}}(\mathbf{z}_{n-1}) \tag{13.47}
$$
$$
\mu_{f_n \to z_n}(\mathbf{z}_n) = \sum_{\mathbf{z}_{n-1}} f_n(\mathbf{z}_{n-1}, \mathbf{z}_n)\mu_{z_{n-1} \to f_n}(\mathbf{z}_{n-1}) \tag{13.48}
$$

These equations represent the propagation of messages forward along the chain and are equivalent to the alpha recursions derived in the previous section, as we shall now show. Note that because the variable nodes $\mathbf{z}_n$ have only two neighbours, they perform no computation.

We can eliminate $\mu_{z_{n-1} \to f_n}(\mathbf{z}_{n-1})$ from (13.48) using (13.47) to give a recursion for the $f \to z$ messages of the form

$$
\mu_{f_n \to z_n}(\mathbf{z}_n) = \sum_{\mathbf{z}_{n-1}} f_n(\mathbf{z}_{n-1}, \mathbf{z}_n)\mu_{f_{n-1} \to z_{n-1}}(\mathbf{z}_{n-1}). \tag{13.49}
$$

If we now recall the deﬁnition (13.46), and if we deﬁne

$$
\alpha(\mathbf{z}_n) = \mu_{f_n \to z_n}(\mathbf{z}_n) \tag{13.50}
$$

then we obtain the alpha recursion given by (13.36). We also need to verify that the quantities $\alpha(\mathbf{z}_n)$ are themselves equivalent to those deﬁned previously. This is easily done by using the initial condition (8.71) and noting that $\alpha(\mathbf{z}_1)$ is given by $h(\mathbf{z}_1) = p(\mathbf{z}_1)p(\mathbf{x}_1|\mathbf{z}_1)$ which is identical to (13.37). Because the initial $\alpha$ is the same, and because they are iteratively computed using the same equation, all subsequent $\alpha$ quantities must be the same.

Next we consider the messages that are propagated from the root node back to the leaf node. These take the form

$$
\mu_{f_{n+1} \to z_n}(\mathbf{z}_n) = \sum_{\mathbf{z}_{n+1}} f_{n+1}(\mathbf{z}_n, \mathbf{z}_{n+1})\mu_{f_{n+2} \to z_{n+1}}(\mathbf{z}_{n+1}) \tag{13.51}
$$

where, as before, we have eliminated the messages of the type $z \to f$ since the variable nodes perform no computation. Using the deﬁnition (13.46) to substitute for $f_{n+1}(\mathbf{z}_n, \mathbf{z}_{n+1})$, and deﬁning

$$
\beta(\mathbf{z}_n) = \mu_{f_{n+1} \to z_n}(\mathbf{z}_n) \tag{13.52}
$$
