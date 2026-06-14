[Page 5]

![The image is a scatter plot with two axes labeled X and Y. The x-axis is labeled X and the y-axis is labeled Y. The plot is divided into two sections, each with a different color. The first section is colored red and blue, and the second section is colored red and blue. ### Description of the Scatter Plot: - **X-Axis (X-axis)**: The x-axis is labeled X and is marked with a numerical value of 1. - **Y-Axis (Y-axis)**: The y-axis is labeled Y and is marked with a numerical value of 0.5. - **Color Coding**: The x-axis is colored red and blue, and the y-axis is colored red and blue. ### Analysis: - **Red and Blue Colors**: The red and blue colors are used to represent different ranges of values. The](<FH2024/imageFile1.png>)







Figure 1: The left hand side shows a persistence diagram (black dots) and the right hand side the corresponding landscapes \( \lambda_1 \) and \( \lambda_2 \).

The rescaled rank function \( \beta \colon \mathbb{R}^{2n} \to \mathbb{R} \) is defined as

$$
\beta ( x , h ) \coloneqq \begin{cases} \dim ( \text {im} ( M ( x - h \leq x + h ) ) ) & \text {if } h \geq 0 , \\ 0 & \text {otherwise} . \end{cases}
$$

Definition 2.6 (Multiparameter persistence landscape [40]) The multiparameter persistence landscape considers the maximal radius over which \( k \) features persist in every (positive) direction through \( x \) in the parameter space

$$
\lambda _ { k } ( x ) \colon = \sup \{ \varepsilon \geq 0 \ \colon \ \beta ( x , h ) \geq k \ \text { for all } h \geq 0 \ \text { with } \| h \| _ { \infty } \leq \varepsilon \} .
$$

Restricting the multiparameter persistence landscape to oneparameter persistence modules gives exactly the definition of a oneparameter persistence landscape.

The following lemma from [40] allows to reduce the computational cost for the calculation of the multiparameter persistence landscape.

Lemma 2.7 Let \( M \) be a multiparameter persistence module with rank function \( \beta_0 ( \cdot , \cdot ) \). Let \( \mathbf{1} \in \mathbb{R}^n \) be the vector where every entry is \( 1 \). For all \( h \geq 0 \) we have \( \beta_0 ( x - \| h \|_\infty \mathbf{1}, x + \| h \|_\infty \mathbf{1} ) \leq \beta_0 ( x - h, x + h ) \).

An immediate consequence is that one only needs to compute \( \sup \{ \varepsilon \geq 0 : \beta_0 ( x - \varepsilon \mathbf{1}, x + \varepsilon \mathbf{1} ) \geq k \} \) in order to get the value of the multiparameter persistence landscape \( \lambda_k \) at point \( x \). In other words, the barcode in a diagonal direction contains the information about all landscapes of all points lying on that diagonal.

Intuitively, regions in the landscape with large values correspond to features which are robust with respect to changes in the filtration parameters. Furthermore, if for large \( k \) the landscape is non-zero it indicates that there is a large number of homological features.

# 2.3 Persistent homology for time series
