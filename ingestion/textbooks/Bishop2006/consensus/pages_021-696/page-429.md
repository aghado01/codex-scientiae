[Page 429]

Figure 8.51 A simple factor graph used to illustrate the sum-product algorithm.

![image 210](../images/imageFile210.png)

graph whose unnormalized joint distribution is given by

$$
\widetilde{p}(\mathbf{x}) = f_a(x_1, x_2)f_b(x_2, x_3)f_c(x_2, x_4). \tag{8.73}
$$

In order to apply the sum-product algorithm to this graph, let us designate node $x_3$ as the root, in which case there are two leaf nodes $x_1$ and $x_4$. Starting with the leaf nodes, we then have the following sequence of six messages

$$
\mu_{x_1 \to f_a}(x_1) = 1 \tag{8.74}
$$
$$
\mu_{f_a \to x_2}(x_2) = \sum_{x_1} f_a(x_1, x_2) \tag{8.75}
$$
$$
\mu_{x_4 \to f_c}(x_4) = 1 \tag{8.76}
$$
$$
\mu_{f_c \to x_2}(x_2) = \sum_{x_4} f_c(x_2, x_4) \tag{8.77}
$$
$$
\mu_{x_2 \to f_b}(x_2) = \mu_{f_a \to x_2}(x_2) \mu_{f_c \to x_2}(x_2) \tag{8.78}
$$
$$
\mu_{f_b \to x_3}(x_3) = \sum_{x_2} f_b(x_2, x_3) \mu_{x_2 \to f_b}(x_2). \tag{8.79}
$$

The direction of ﬂow of these messages is illustrated in Figure 8.52. Once this message propagation is complete, we can then propagate messages from the root node out to the leaf nodes, and these are given by

$$
\mu_{x_3 \to f_b}(x_3) = 1 \tag{8.80}
$$
$$
\mu_{f_b \to x_2}(x_2) = \sum_{x_3} f_b(x_2, x_3) \tag{8.81}
$$
$$
\mu_{x_2 \to f_a}(x_2) = \mu_{f_b \to x_2}(x_2) \mu_{f_c \to x_2}(x_2) \tag{8.82}
$$
$$
\mu_{f_a \to x_1}(x_1) = \sum_{x_2} f_a(x_1, x_2) \mu_{x_2 \to f_a}(x_2) \tag{8.83}
$$
$$
\mu_{x_2 \to f_c}(x_2) = \mu_{f_a \to x_2}(x_2) \mu_{f_b \to x_2}(x_2) \tag{8.84}
$$
$$
\mu_{f_c \to x_4}(x_4) = \sum_{x_2} f_c(x_2, x_4) \mu_{x_2 \to f_c}(x_2). \tag{8.85}
$$
