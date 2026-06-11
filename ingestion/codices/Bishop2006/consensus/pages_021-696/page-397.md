[Page 397]

Figure 8.21 An example of a 3-node graph used to illustrate the phenomenon of ‘explaining away’. The three nodes represent the state of the battery ($B$), the state of the fuel tank ($F$) and the reading on the electric fuel gauge ($G$). See the text for details.

![image 180](../images/imageFile180.png)

($G = 0$). The battery is either charged or ﬂat, and independently the fuel tank is either full or empty, with prior probabilities

$$
p(B = 1) = 0.9 \\
p(F = 1) = 0.9.
$$

Given the state of the fuel tank and the battery, the fuel gauge reads full with probabilities given by

$$
\begin{align}
p(G = 1|B = 1, F = 1) &= 0.8 \\
p(G = 1|B = 1, F = 0) &= 0.2 \\
p(G = 1|B = 0, F = 1) &= 0.2 \\
p(G = 1|B = 0, F = 0) &= 0.1
\end{align}
$$

so this is a rather unreliable fuel gauge! All remaining probabilities are determined by the requirement that probabilities sum to one, and so we have a complete speciﬁcation of the probabilistic model.

Before we observe any data, the prior probability of the fuel tank being empty is $p(F = 0) = 0.1$. Now suppose that we observe the fuel gauge and discover that it reads empty, i.e., $G = 0$, corresponding to the middle graph in Figure 8.21. We can use Bayes’ theorem to evaluate the posterior probability of the fuel tank being empty. First we evaluate the denominator for Bayes’ theorem given by

$$
p(G = 0) = \sum_{B \in \{0, 1\}} \sum_{F \in \{0, 1\}} p(G = 0|B, F)p(B)p(F) = 0.315 \tag{8.30}
$$

and similarly we evaluate

$$
p(G = 0|F = 0) = \sum_{B \in \{0, 1\}} p(G = 0|B, F = 0)p(B) = 0.81 \tag{8.31}
$$

and using these results we have

$$
p(F = 0|G = 0) = \frac{p(G = 0|F = 0)p(F = 0)}{p(G = 0)} \simeq 0.257 \tag{8.32}
$$
