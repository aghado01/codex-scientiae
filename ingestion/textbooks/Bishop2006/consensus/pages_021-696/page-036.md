[Page 36]

![The image is a bar chart titled Y=1 with four different categories represented by blue bars. The x-axis is labeled Y and the y-axis is labeled P(X). The bars are color-coded to represent different values of P(X). ### Description of the Bar Chart: - **Y-Axis (X-Axis)**: The x-axis is labeled Y and the y-axis is labeled P(X). - **Bars**: There are four different categories represented by blue bars: - **X**: The category labeled x - **Y**: The category labeled y - **P(X)**: The category labeled P(X) ### Analysis: - **Bars Color Coding**: The bars are color-coded to represent different values of P(X). The colors are blue for x and red for y. - **](../images/imageFile14.png)

Figure 1.11 An illustration of a distribution over two variables, $X$, which takes $9$ possible values, and $Y$, which takes two possible values. The top left figure shows a sample of $60$ points drawn from a joint probability distribution over these variables. The remaining figures show histogram estimates of the marginal distributions $p(X)$ and $p(Y)$, as well as the conditional distribution $p(X|Y = 1)$ corresponding to the bottom row in the top left figure.

Again, note that these probabilities are normalized so that
$$
p(F = a|B = r) + p(F = o|B = r) = 1
\tag{1.20}
$$
and similarly
$$
p(F = a|B = b) + p(F = o|B = b) = 1.
\tag{1.21}
$$

We can now use the sum and product rules of probability to evaluate the overall probability of choosing an apple
$$
\begin{align}
p(F = a) &= p(F = a|B = r)p(B = r) + p(F = a|B = b)p(B = b) \\
&= \frac{1}{4} \times \frac{4}{10} + \frac{3}{4} \times \frac{6}{10} = \frac{11}{20}
\end{align}
\tag{1.22}
$$

from which it follows, using the sum rule, that $p(F = o) = 1 - 11/20 = 9/20$.
