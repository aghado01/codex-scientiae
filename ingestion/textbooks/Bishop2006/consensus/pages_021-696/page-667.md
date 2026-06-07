[Page 667]

Figure 13.23 Schematic illustration of the operation of the particle ﬁlter for a one-dimensional latent space. At time step $n$, the posterior $p(z_n|x_n)$ is represented as a mixture distribution, shown schematically as circles whose sizes are proportional to the weights $w_n^{(l)}$. A set of $L$ samples is then drawn from this distribution and the new weights $w_{n+1}^{(l)}$ evaluated using $p(x_{n+1}|z_{n+1}^{(l)})$.

![Figure 13.23](../images/imageFile323.png)

satisﬁes the conditional independence properties

$$
p(\mathbf{x}_n|\mathbf{x}_1, \dots, \mathbf{x}_{n-1}) = p(\mathbf{x}_n|\mathbf{x}_{n-1}, \mathbf{x}_{n-2}) \tag{13.122}
$$

for $n = 3, \dots, N$.

**13.2** ($\star$) Consider the joint probability distribution (13.2) corresponding to the directed graph of Figure 13.3. Using the sum and product rules of probability, verify that this joint distribution satisﬁes the conditional independence property (13.3) for $n = 2, \dots, N$. Similarly, show that the second-order Markov model described by the joint distribution (13.4) satisﬁes the conditional independence property

$$
p(\mathbf{x}_n|\mathbf{x}_1, \dots, \mathbf{x}_{n-1}) = p(\mathbf{x}_n|\mathbf{x}_{n-1}, \mathbf{x}_{n-2}) \tag{13.123}
$$

for $n = 3, \dots, N$.

**13.3** ($\star$) By using d-separation, show that the distribution $p(\mathbf{x}_1, \dots, \mathbf{x}_N)$ of the observed data for the state space model represented by the directed graph in Figure 13.5 does not satisfy any conditional independence properties and hence does not exhibit the Markov property at any ﬁnite order.

**13.4** ($\star$) www Consider a hidden Markov model in which the emission densities are represented by a parametric model $p(\mathbf{x}|\mathbf{z}, \mathbf{w})$, such as a linear regression model or a neural network, in which $\mathbf{w}$ is a vector of adaptive parameters. Describe how the parameters $\mathbf{w}$ can be learned from data using maximum likelihood.
