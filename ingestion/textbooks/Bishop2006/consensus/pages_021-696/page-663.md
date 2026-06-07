[Page 663]

$$
\boldsymbol{\mu}_0^{\text{new}} = \mathbb{E}[\mathbf{z}_1] \tag{13.110}
$$
$$
\mathbf{V}_0^{\text{new}} = \mathbb{E}[\mathbf{z}_1\mathbf{z}_1^{\text{T}}] - \mathbb{E}[\mathbf{z}_1]\mathbb{E}[\mathbf{z}_1^{\text{T}}]. \tag{13.111}
$$

Similarly, to optimize $\mathbf{A}$ and $\mathbf{\Gamma}$, we substitute for $p(\mathbf{z}_n|\mathbf{z}_{n-1}, \mathbf{A}, \mathbf{\Gamma})$ in (13.108) using (13.75) giving

$$
Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}}) = -\frac{N-1}{2} \ln |\mathbf{\Gamma}| - \mathbb{E}_{\mathbf{Z}|\boldsymbol{\theta}^{\text{old}}}\left[ \frac{1}{2} \sum_{n=2}^N (\mathbf{z}_n - \mathbf{A}\mathbf{z}_{n-1})^{\text{T}} \mathbf{\Gamma}^{-1} (\mathbf{z}_n - \mathbf{A}\mathbf{z}_{n-1}) \right] + \text{const} \tag{13.112}
$$

in which the constant comprises terms that are independent of $\mathbf{A}$ and $\mathbf{\Gamma}$. Maximizing with respect to these parameters then gives

$$
\mathbf{A}^{\text{new}} = \left( \sum_{n=2}^N \mathbb{E}[\mathbf{z}_n\mathbf{z}_{n-1}^{\text{T}}] \right) \left( \sum_{n=2}^N \mathbb{E}[\mathbf{z}_{n-1}\mathbf{z}_{n-1}^{\text{T}}] \right)^{-1} \tag{13.113}
$$

$$
\begin{aligned}
\mathbf{\Gamma}^{\text{new}} = \frac{1}{N-1} \sum_{n=2}^N &\{ \mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}] - \mathbf{A}^{\text{new}}\mathbb{E}[\mathbf{z}_{n-1}\mathbf{z}_n^{\text{T}}] \\
&- \mathbb{E}[\mathbf{z}_n\mathbf{z}_{n-1}^{\text{T}}](\mathbf{A}^{\text{new}})^{\text{T}} + \mathbf{A}^{\text{new}}\mathbb{E}[\mathbf{z}_{n-1}\mathbf{z}_{n-1}^{\text{T}}](\mathbf{A}^{\text{new}})^{\text{T}} \}.
\end{aligned} \tag{13.114}
$$

Note that $\mathbf{A}^{\text{new}}$ must be evaluated ﬁrst, and the result can then be used to determine $\mathbf{\Gamma}^{\text{new}}$.

Finally, in order to determine the new values of $\mathbf{C}$ and $\mathbf{\Sigma}$, we substitute for $p(\mathbf{x}_n|\mathbf{z}_n, \mathbf{C}, \mathbf{\Sigma})$ in (13.108) using (13.76) giving

$$
Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}}) = -\frac{N}{2} \ln |\mathbf{\Sigma}| - \mathbb{E}_{\mathbf{Z}|\boldsymbol{\theta}^{\text{old}}}\left[ \frac{1}{2} \sum_{n=1}^N (\mathbf{x}_n - \mathbf{C}\mathbf{z}_n)^{\text{T}} \mathbf{\Sigma}^{-1} (\mathbf{x}_n - \mathbf{C}\mathbf{z}_n) \right] + \text{const}.
$$

Maximizing with respect to $\mathbf{C}$ and $\mathbf{\Sigma}$ then gives

$$
\mathbf{C}^{\text{new}} = \left( \sum_{n=1}^N \mathbf{x}_n\mathbb{E}[\mathbf{z}_n^{\text{T}}] \right) \left( \sum_{n=1}^N \mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}] \right)^{-1} \tag{13.115}
$$

$$
\begin{aligned}
\mathbf{\Sigma}^{\text{new}} = \frac{1}{N} \sum_{n=1}^N &\{ \mathbf{x}_n\mathbf{x}_n^{\text{T}} - \mathbf{C}^{\text{new}}\mathbb{E}[\mathbf{z}_n]\mathbf{x}_n^{\text{T}} \\
&- \mathbf{x}_n\mathbb{E}[\mathbf{z}_n^{\text{T}}](\mathbf{C}^{\text{new}})^{\text{T}} + \mathbf{C}^{\text{new}}\mathbb{E}[\mathbf{z}_n\mathbf{z}_n^{\text{T}}](\mathbf{C}^{\text{new}})^{\text{T}} \}.
\end{aligned} \tag{13.116}
$$
