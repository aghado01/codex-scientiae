# Manifest: Page 005

## REPAIR_MATH
- RAW: ```
0 < \theta _ { o v } = \frac { \ell ( I _ { s } \cap I _ { s + 1 } ) } { l } < \frac { 1 } { 2 } ,
```
  FIX: ```
$$
0 < \theta _ { o v } = \frac { \ell ( I _ { s } \cap I _ { s + 1 } ) } { l } < \frac { 1 } { 2 } ,
$$
```
- RAW: ```
l > l _ { 0 } = \frac { | | x _ { i } - x _ { j } | | < \delta , \, x _ { i } \in X , \, x _ { j } \in X } { \theta _ { o v } } .
```
  FIX: ```
$$
l > l _ { 0 } = \frac { | | x _ { i } - x _ { j } | | < \delta , \, x _ { i } \in X , \, x _ { j } \in X } { \theta _ { o v } } .
$$
```

## REPAIR_PROSE
- RAW: ```
Fig. 3: Generation of the initial Mapper graph, 𝜃 ov = 0 . 2 . (a)Input point set 𝑋 . (b) 𝑋 is colored according to the values of the filter function 𝑓 . The black dashed line passes through the center of 𝑋 , indicating the principal direction of 𝑋 . (c)Cover construction. Only a subset of intervals is visualized for clarity. Points corresponding to the same interval are enclosed between dashed lines, and the preimages of different intervals are translated for better visual separation (d)Initial Mapper graph. (e)The result of the node merging operation. (f)The final Mapper graph.
```
  FIX: ```
Fig. 3: Generation of the initial Mapper graph, \( \theta_{ov} = 0.2 \). (a) Input point set \( X \). (b) \( X \) is colored according to the values of the filter function \( f \). The black dashed line passes through the center of \( X \), indicating the principal direction of \( X \). (c) Cover construction. Only a subset of intervals is visualized for clarity. Points corresponding to the same interval are enclosed between dashed lines, and the preimages of different intervals are translated for better visual separation. (d) Initial Mapper graph. (e) The result of the node merging operation. (f) The final Mapper graph.
```
- RAW: ```
where 𝑟𝑐ℎ and 𝜌 denote the reach and convexity radius of  , respectively, and 𝑑 H denotes the Hausdorff distance. Here,the reach 𝑟𝑐ℎ is defined as the supremum of all 𝑟 > 0 such that every point 𝑥 with the Euclidean distance dist( 𝑥,  ) < 𝑟 admits a unique nearest point in  . The convexity radius 𝜌 is the largest 𝑟 > 0 such that for every 𝑝 ∈  , the geodesic ball 𝐵  ( 𝑝,𝑟 ) = { 𝑞 ∈  ∶ 𝑑  ( 𝑝,𝑞 ) < 𝑟 } is geodesically convex. Regarding condition ( 5 ), since each intersection point is
```
  FIX: ```
where \( \mathrm{rch} \) and \( \rho \) denote the reach and convexity radius of \( \mathcal{M} \), respectively, and \( d_H \) denotes the Hausdorff distance. Here, the reach \( \mathrm{rch} \) is defined as the supremum of all \( r > 0 \) such that every point \( x \) with the Euclidean distance \( \mathrm{dist}(x, \mathcal{M}) < r \) admits a unique nearest point in \( \mathcal{M} \). The convexity radius \( \rho \) is the largest \( r > 0 \) such that for every \( p \in \mathcal{M} \), the geodesic ball \( B_{\mathcal{M}}(p, r) = \{ q \in \mathcal{M} : d_{\mathcal{M}}(p, q) < r \} \) is geodesically convex. Regarding condition (5), since each intersection point is
```
- RAW: ```
taken as the center of its corresponding bounding box, an upper bound for 𝑑 H (  ,𝑋 ) is given by half the length of the bounding box diagonal. Accordingly, we select twice the diagonal length of the bounding box as the value of 𝛿 . For condition ( 6 ), if the intersection does not contain
```
  FIX: ```
taken as the center of its corresponding bounding box, an upper bound for \( d_H(\mathcal{M}, X) \) is given by half the length of the bounding box diagonal. Accordingly, we select twice the diagonal length of the bounding box as the value of \( \delta \). For condition (6), if the intersection does not contain
```
- RAW: ```
singular points (i.e., points of tangential discontinuity), the numerical accuracy of standard surface/surface intersection algorithms is generally sufficient, and the above choice of 𝛿 naturally satisfies this constraint. However, if the intersection contains singular points, the manifold induced by the corresponding bounding box set may fail to possess a positive reach radius 𝑟𝑐ℎ and convexity radius 𝜌 . This leads
```
  FIX: ```
singular points (i.e., points of tangential discontinuity), the numerical accuracy of standard surface/surface intersection algorithms is generally sufficient, and the above choice of \( \delta \) naturally satisfies this constraint. However, if the intersection contains singular points, the manifold induced by the corresponding bounding box set may fail to possess a positive reach radius \( \mathrm{rch} \) and convexity radius \( \rho \). This leads
```
- RAW: ```
issue later. Cover construction . Given the filter function 𝑓 ∶ 𝑋 → ℝ , we construct a uniform cover of 𝑓 ( 𝑋 ) such that no more than two intervals overlap at any point. Specifically, we use 𝑆 open intervals { 𝐼 𝑠 } 𝑆 𝑠 =1 of equal length 𝑙 . The overlap ratio 𝜃 ov between adjacent intervals is defined as
```
  FIX: ```
issue later. Cover construction. Given the filter function \( f : X \to \mathbb{R} \), we construct a uniform cover of \( f(X) \) such that no more than two intervals overlap at any point. Specifically, we use \( S \) open intervals \( \{ I_s \}_{s=1}^S \) of equal length \( l \). The overlap ratio \( \theta_{ov} \) between adjacent intervals is defined as
```
- RAW: ```
where 𝓁 ( ⋅ ) denotes the Lebesgue measure on ℝ . The interval length should satisfy the

𝑙 following condition related to the clustering parameter 𝛿 and the filter function 𝑓 :
```
  FIX: ```
where \( \ell(\cdot) \) denotes the Lebesgue measure on \( \mathbb{R} \). The interval length \( l \) should satisfy the following condition related to the clustering parameter \( \delta \) and the filter function \( f \):
```
