[Page 573]

![The image depicts a simple geometric figure, specifically a square. The square is divided into two equal parts by two straight lines, which are labeled as ( r ) and ( r + 1 ). The length of the side of the square is equal to the length of the line segment connecting the two points on the side of the square. The length of the side of the square is 2 units, and the length of the line segment connecting the two points on the side is 1 unit. The length of the side of the square is equal to the length of the line segment connecting the two points on the side. The image is a simple geometric figure, and the length of the side of the square is given by the length of the line segment connecting the two points. The length of the side of the square is equal to the length of the line segment connecting the two points on the side. The image does not contain any other objects, such](../images/imageFile268.png)

r

i

z

i

![The image shows a right-angled triangle with the right angle at the bottom vertex. The base of the triangle is marked with a horizontal line, and the height is marked with a vertical line. The line segment connecting the bottom vertex to the top vertex is perpendicular to the horizontal line. The base of the triangle is marked with a horizontal line, and the height is marked with a vertical line. The line segment connecting the bottom vertex to the top vertex is perpendicular to the horizontal line. The Pythagorean theorem can be used to find the length of the hypotenuse of the right triangle. The Pythagorean theorem states that in a right triangle, the square of the length of the hypotenuse (the side opposite the right angle) is equal to the sum of the squares of the lengths of the other two sides. Let the length of the hypotenuse be $h$ and the length of the other two sides be $w$ and $w'$. Then, we](../images/imageFile269.png)

′

r

i

′

z

i

Figure 11.14 Each step of the leapfrog algorithm (11.64)–(11.66) modiﬁes either a position variable z i or a momentum variable r i . Because the change to one variable is a function only of the other, any region in phase space will be sheared without change of volume.

Exercise 11.17

$$
\frac { 1 } { Z _ { H } } \exp ( - H ( \mathcal { R } ^ { \prime } ) ) \delta V \frac { 1 } { 2 } \min \left \{ 1 , \exp ( - H ( \mathcal { R } ^ { \prime } ) + H ( \mathcal { R } ) ) \right \} .
$$

It is easily seen that the two probabilities (11.68) and (11.69) are equal, and hence detailed balance holds. Note that this proof ignores any overlap between the regions R and R but is easily generalized to allow for such overlap. It is not difﬁcult to construct examples for which the leapfrog algorithm returns

to its starting position after a ﬁnite number of iterations. In such cases, the random replacement of the momentum values before each leapfrog integration will not be sufﬁcient to ensure ergodicity because the position variables will never be updated. Such phenomena are easily avoided by choosing the magnitude of the step size at random from some small interval, before each leapfrog integration.

We can gain some insight into the behaviour of the hybrid Monte Carlo algorithm by considering its application to a multivariate Gaussian. For convenience, consider a Gaussian distribution p ( z ) with independent components, for which the Hamiltonian is given by

$$
H ( z , r ) = \frac { 1 } { 2 } \sum _ { i } \frac { 1 } { \sigma _ { i } ^ { 2 } } z _ { i } ^ { 2 } + \frac { 1 } { 2 } \sum _ { i } r _ { i } ^ { 2 } . \\ \intertext { s n s w i l b e q u a l l y a l d i f o r a G u a s i g n a t i o n g h a v i n g o r r e l a t e d }
$$

Our conclusions will be equally valid for a Gaussian distribution having correlated components because the hybrid Monte Carlo algorithm exhibits rotational isotropy. During the leapfrog integration, each pair of phase-space variables z i ,r i evolves independently. However, the acceptance or rejection of the candidate point is based on the value of H , which depends on the values of all of the variables. Thus, a signiﬁcant integration error in any one of the variables could lead to a high probability of rejection. In order that the discrete leapfrog integration be a reasonably
