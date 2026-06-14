[Page 76]

Again, we compute the zigzag persistence diagram \( D_q(F_l) \) by utilizing the fast computation provided in Dey and Hou ( 2022 ), and obtain the remaining sub-diagram \( D_q(I_l) \) based on Proposition 6.9 .

Remark 6.11. It is possible to compute the bipath persistence diagram by computing the persistence diagram of a single zigzag filtration. Without loss of generality, we now assume the number of vertices in the lower path (i.e., \( m \)) is not greater than that in the upper path (i.e., \( n \)) of \( B_{n,m} \), in terms of the usual total order of \( \mathbb{Z} \).

Let \( S \) be a poset having the Hasse quiver:

![The image depicts a geometric figure with two sides labeled as 1 and 2, and two angles labeled as 1 and 2. The figure is a right triangle with the right angle at the bottom. The sides of the triangle are labeled as 1 and 2, and the angles are labeled as 1 and 2. The figure is also labeled as 1, 2, and 1, indicating that it is a right triangle. The figure is a right triangle with the right angle at the bottom. The sides of the triangle are labeled as 1 and 2, and the angles are labeled as 1 and 2. The figure is also labeled as 1, 2, and 1, indicating that it is a right triangle. The figure is a right triangle with the right angle at the bottom. The sides of the triangle are labeled as 1 and 2, and the angles are labeled as 1 and 2.](<AL2026/imageFile27.png>)









where we set \( [ m ]^{\prime\prime} := \{ 1^{\prime\prime} , \dots , m^{\prime\prime} \} \). Now, we define the order-preserving map \( \zeta : S \to P \) by setting

$$
\zeta ( x ) \coloneqq \begin{cases} x , & \text {if } x \in [ n ] \sqcup [ m ] ^ { \prime } \sqcup \{ \hat { 0 } , \hat { 1 } \} , \\ \hat { 0 } , & \text {if } x = \tilde { 0 } , \\ i ^ { \prime } , & \text {if } x \coloneqq i ^ { \prime \prime } \in [ m ] ^ { \prime \prime } . \end{cases}
$$

Then it is straightforward to check that \( \zeta \) essentially covers all intervals of \( B_{n,m} \), and hence we have

$$
d _ { M } ( V _ { I } ) = \bar { d } _ { R ( M ) } ( R ( V _ { I } ) ) .
$$

We remark here that in this case, \( \bar{d} \) appearing in (6.101) can not be changed to the usual symbol \( d \) for the multiplicity since \( R(V_I) \) may not be indecomposable in \( \operatorname{mod} k[S] \). For instance, considering an interval \( I = [s', t'] \in I_d \) of \( B_{n,m} \).

# Declarations

- Funding: H.A. is partially supported by JSPS Grant-in-Aid for Scientific Research (C) 18K03207, 25K06922, JSPS Grant-in-Aid for Transformative Research Areas (A) (22A201), and by Osaka Central Advanced Mathematical Institute (MEXT Promotion of Distinctive Joint Research Center Program JPMXP0723833165). E.L. was supported by JST SPRING, Grant Number JPMJSP2110.
