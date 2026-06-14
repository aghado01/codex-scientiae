[Page 5]

(a)

(d)

(b)

![The image is a diagram consisting of various geometric shapes arranged in a grid-like pattern. The shapes are colored in different colors, and each shape is connected by lines. The lines are interconnected, forming a complex network. Here is a detailed description of the image: ### Description of the Image: 1. **Top Left Section**: - The top left section contains a green shape with a circle inside it. - The circle is connected to the top left shape by a line. 2. **Top Right Section**: - The top right section contains a red shape with a circle inside it. - The circle is connected to the top right shape by a line. 3. **Bottom Left Section**: - The bottom left section contains a blue shape with a circle inside it. - The circle is connected to the bottom left shape by a line. 4. **Bottom Right Section**: - The bottom right section contains a green shape with a](<GLL2026/imageFile3.png>)

(e)

(c)

(f)

Fig. 3: Generation of the initial Mapper graph, \( \theta_{ov} = 0.2 \). (a) Input point set \( X \). (b) \( X \) is colored according to the values of the filter function \( f \). The black dashed line passes through the center of \( X \), indicating the principal direction of \( X \). (c) Cover construction. Only a subset of intervals is visualized for clarity. Points corresponding to the same interval are enclosed between dashed lines, and the preimages of different intervals are translated for better visual separation. (d) Initial Mapper graph. (e) The result of the node merging operation. (f) The final Mapper graph.

where \( \mathrm{rch} \) and \( \rho \) denote the reach and convexity radius of \( \mathcal{M} \), respectively, and \( d_H \) denotes the Hausdorff distance. Here, the reach \( \mathrm{rch} \) is defined as the supremum of all \( r > 0 \) such that every point \( x \) with the Euclidean distance \( \mathrm{dist}(x, \mathcal{M}) < r \) admits a unique nearest point in \( \mathcal{M} \). The convexity radius \( \rho \) is the largest \( r > 0 \) such that for every \( p \in \mathcal{M} \), the geodesic ball \( B_{\mathcal{M}}(p, r) = \{ q \in \mathcal{M} : d_{\mathcal{M}}(p, q) < r \} \) is geodesically convex. Regarding condition (5), since each intersection point is

taken as the center of its corresponding bounding box, an upper bound for \( d_H(\mathcal{M}, X) \) is given by half the length of the bounding box diagonal. Accordingly, we select twice the diagonal length of the bounding box as the value of \( \delta \). For condition (6), if the intersection does not contain

singular points (i.e., points of tangential discontinuity), the numerical accuracy of standard surface/surface intersection algorithms is generally sufficient, and the above choice of \( \delta \) naturally satisfies this constraint. However, if the intersection contains singular points, the manifold induced by the corresponding bounding box set may fail to possess a positive reach radius \( \mathrm{rch} \) and convexity radius \( \rho \). This leads

issue later. Cover construction. Given the filter function \( f : X \to \mathbb{R} \), we construct a uniform cover of \( f(X) \) such that no more than two intervals overlap at any point. Specifically, we use \( S \) open intervals \( \{ I_s \}_{s=1}^S \) of equal length \( l \). The overlap ratio \( \theta_{ov} \) between adjacent intervals is defined as

$$
0 < \theta _ { o v } = \frac { \ell ( I _ { s } \cap I _ { s + 1 } ) } { l } < \frac { 1 } { 2 } ,
$$

where \( \ell(\cdot) \) denotes the Lebesgue measure on \( \mathbb{R} \). The interval length \( l \) should satisfy the following condition related to the clustering parameter \( \delta \) and the filter function \( f \):

$$
l > l _ { 0 } = \frac { | | x _ { i } - x _ { j } | | < \delta , \, x _ { i } \in X , \, x _ { j } \in X } { \theta _ { o v } } .
$$
