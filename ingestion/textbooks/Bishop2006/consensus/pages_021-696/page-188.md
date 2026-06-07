[Page 188]

Figure 3.14 Plot of the model evidence versus the order $M$, for the polynomial regression model, showing that the evidence favours the model with $M = 3$.

![The image is a line graph that shows the trend of a variable over time. The x-axis represents the time in years, ranging from 0 to 26 years. The y-axis represents the value, ranging from 0 to 26. The graph shows a general upward trend, with a slight dip in the middle of the graph. The graph has a linear scale of range 0 to 26 on the x-axis, starting from 0 and ending at 26. The graph also has a linear scale of range from 0 to 26 on the y-axis, starting from 0 and ending at 26. The graph has a blue line that shows the trend of the variable over time. The line starts at a value of 0 and goes up to 26, then decreases to 0 and then up to 26. The line then goes down to 0 and then up to 2](../images/imageFile86.png)

for the evidence. Going to the $M = 1$ polynomial greatly improves the data ﬁt, and hence the evidence is signiﬁcantly higher. However, in going to $M = 2$, the data ﬁt is improved only very marginally, due to the fact that the underlying sinusoidal function from which the data is generated is an odd function and so has no even terms in a polynomial expansion. Indeed, Figure 1.5 shows that the residual data error is reduced only slightly in going from $M = 1$ to $M = 2$. Because this richer model suffers a greater complexity penalty, the evidence actually falls in going from $M = 1$ to $M = 2$. When we go to $M = 3$ we obtain a signiﬁcant further improvement in data ﬁt, as seen in Figure 1.4, and so the evidence is increased again, giving the highest overall evidence for any of the polynomials. Further increases in the value of $M$ produce only small improvements in the ﬁt to the data but suffer increasing complexity penalty, leading overall to a decrease in the evidence values. Looking again at Figure 1.5, we see that the generalization error is roughly constant between $M = 3$ and $M = 8$, and it would be difﬁcult to choose between these models on the basis of this plot alone. The evidence values, however, show a clear preference for $M = 3$, since this is the simplest model which gives a good explanation for the observed data.

### 3.5.2 Maximizing the evidence function

Let us ﬁrst consider the maximization of $p(\mathbf{t}|\alpha,\beta)$ with respect to $\alpha$. This can be done by ﬁrst deﬁning the following eigenvector equation

$$
(\beta \mathbf{\Phi}^{\mathrm{T}}\mathbf{\Phi}) \mathbf{u}_{i} = \lambda_{i}\mathbf{u}_{i}. \tag{3.87}
$$

From (3.81), it then follows that $\mathbf{A}$ has eigenvalues $\alpha+\lambda_{i}$. Now consider the derivative of the term involving $\ln|\mathbf{A}|$ in (3.86) with respect to $\alpha$. We have

$$
\frac{d}{d\alpha} \ln|\mathbf{A}| = \frac{d}{d\alpha} \ln \prod_{i}(\lambda_{i} + \alpha) = \frac{d}{d\alpha} \sum_{i}\ln(\lambda_{i} + \alpha) = \sum_{i}\frac{1}{\lambda_{i} + \alpha}. \tag{3.88}
$$

Thus the stationary points of (3.86) with respect to $\alpha$ satisfy

$$
0 = \frac{M}{2\alpha} - \frac{1}{2}\mathbf{m}_{N}^{\mathrm{T}}\mathbf{m}_{N} - \frac{1}{2}\sum_{i}\frac{1}{\lambda_{i} + \alpha}. \tag{3.89}
$$
