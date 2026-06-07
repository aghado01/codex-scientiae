[Page 535]

![Figure 10.18](../images/imageFile251.png)

Figure 10.18 On the left is a simple factor graph from Figure 8.51 and reproduced here for convenience. On the right is the corresponding factorized approximation.

$\widetilde{f}_b(x_2, x_3) = \widetilde{f}_{b2}(x_2)\widetilde{f}_{b3}(x_3)$. We ﬁrst remove this factor from the approximating distribution to give

$$
q^{\setminus b}(\mathbf{x}) = \widetilde{f}_{a1}(x_1) \widetilde{f}_{a2}(x_2) \widetilde{f}_{c2}(x_2) \widetilde{f}_{c4}(x_4) \tag{10.228}
$$

and we then multiply this by the exact factor $f_b(x_2, x_3)$ to give

$$
\widehat{p}(\mathbf{x}) = q^{\setminus b}(\mathbf{x})f_b(x_2, x_3) = \widetilde{f}_{a1}(x_1) \widetilde{f}_{a2}(x_2) \widetilde{f}_{c2}(x_2) \widetilde{f}_{c4}(x_4)f_b(x_2, x_3). \tag{10.229}
$$

We now ﬁnd $q^{\text{new}}(\mathbf{x})$ by minimizing the Kullback-Leibler divergence $\text{KL}(\widehat{p} || q^{\text{new}})$. The result, as noted above, is that $q^{\text{new}}(\mathbf{z})$ comprises the product of factors, one for each variable $x_i$, in which each factor is given by the corresponding marginal of $\widehat{p}(\mathbf{x})$. These four marginals are given by

$$
\widehat{p}(x_1) \propto \widetilde{f}_{a1}(x_1) \tag{10.230}
$$

$$
\widehat{p}(x_2) \propto \widetilde{f}_{a2}(x_2) \widetilde{f}_{c2}(x_2) \sum_{x_3} f_b(x_2, x_3) \tag{10.231}
$$

$$
\widehat{p}(x_3) \propto \sum_{x_2} \left\{ f_b(x_2, x_3) \widetilde{f}_{a2}(x_2) \widetilde{f}_{c2}(x_2) \right\} \tag{10.232}
$$

$$
\widehat{p}(x_4) \propto \widetilde{f}_{c4}(x_4) \tag{10.233}
$$

and $q^{\text{new}}(\mathbf{x})$ is obtained by multiplying these marginals together. We see that the only factors in $q(\mathbf{x})$ that change when we update $\widetilde{f}_b(x_2, x_3)$ are those that involve the variables in $f_b$ namely $x_2$ and $x_3$. To obtain the reﬁned factor $\widetilde{f}_b(x_2, x_3) = \widetilde{f}_{b2}(x_2) \widetilde{f}_{b3}(x_3)$ we simply divide $q^{\text{new}}(\mathbf{x})$ by $q^{\setminus b}(\mathbf{x})$, which gives

$$
\widetilde{f}_{b2}(x_2) \propto \sum_{x_3} f_b(x_2, x_3) \tag{10.234}
$$

$$
\widetilde{f}_{b3}(x_3) \propto \sum_{x_2} \left\{ f_b(x_2, x_3) \widetilde{f}_{a2}(x_2) \widetilde{f}_{c2}(x_2) \right\}. \tag{10.235}
$$
