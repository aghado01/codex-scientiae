[Page 217]

Figure 4.9 Plot of the logistic sigmoid function $\sigma(a)$ defined by (4.59), shown in red, together with the scaled probit function $\Phi(\lambda a)$, for $\lambda^2 = \pi/8$, shown in dashed blue, where $\Phi(a)$ is defined by (4.114). The scaling factor $\pi/8$ is chosen so that the derivatives of the two curves are equal for $a = 0$.

![The image shows a graph with two lines. The x-axis is labeled as y and the y-axis is labeled as x. The graph has a single line that starts at the point (0, 0) and extends upwards to the right, while the other line starts at the point (1, 0) and extends downwards to the right. The line that starts at the point (0, 0) is a straight line, while the line that starts at the point (1, 0) is a curved line. The graph has a scale of range from 0 to 5 on the y-axis, and a scale of range from 0 to 5 on the x-axis, with a minimum of 0 and a maximum of 5. The graph is drawn with a single line, and the line starts at the point (0, 0) and extends upwards to the right, while the line starts at the point (](../images/imageFile100.png)

approach in which we model the class-conditional densities $p(\mathbf{x}|\mathcal{C}_k)$, as well as the class priors $p(\mathcal{C}_k)$, and then use these to compute posterior probabilities $p(\mathcal{C}_k|\mathbf{x})$ through Bayes’ theorem.

Consider first of all the case of two classes. The posterior probability for class $\mathcal{C}_1$ can be written as

$$
\begin{align}
p(\mathcal{C}_1|\mathbf{x}) &= \frac{p(\mathbf{x}|\mathcal{C}_1)p(\mathcal{C}_1)}{p(\mathbf{x}|\mathcal{C}_1)p(\mathcal{C}_1) + p(\mathbf{x}|\mathcal{C}_2)p(\mathcal{C}_2)} \\
&= \frac{1}{1 + \exp(-a)} = \sigma(a) \tag{4.57}
\end{align}
$$

where we have defined

$$
a = \ln \frac{p(\mathbf{x}|\mathcal{C}_1)p(\mathcal{C}_1)}{p(\mathbf{x}|\mathcal{C}_2)p(\mathcal{C}_2)} \tag{4.58}
$$

and $\sigma(a)$ is the logistic sigmoid function defined by

$$
\sigma(a) = \frac{1}{1 + \exp(-a)} \tag{4.59}
$$

which is plotted in Figure 4.9. The term ‘sigmoid’ means S-shaped. This type of function is sometimes also called a ‘squashing function’ because it maps the whole real axis into a finite interval. The logistic sigmoid has been encountered already in earlier chapters and plays an important role in many classification algorithms. It satisfies the following symmetry property

$$
\sigma(-a) = 1 - \sigma(a) \tag{4.60}
$$

as is easily verified. The inverse of the logistic sigmoid is given by

$$
a = \ln \left( \frac{\sigma}{1 - \sigma} \right) \tag{4.61}
$$

and is known as the logit function. It represents the log of the ratio of probabilities $\ln[p(\mathcal{C}_1|\mathbf{x})/p(\mathcal{C}_2|\mathbf{x})]$ for the two classes, also known as the log odds.
