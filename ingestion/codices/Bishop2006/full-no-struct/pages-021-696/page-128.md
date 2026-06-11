[Page 128]

![The image is a graph that shows the relationship between two variables, represented by the red and blue lines. The x-axis represents the values of the variables, while the y-axis represents the values of the variables. The graph shows a downward trend, with the blue line decreasing as the red line increases. The red line is a straight line, which means it is a straight line that does not have any bends or curves. The blue line is a curved line, which means it has a more complex and irregular shape. The graph is labeled with the variables m and s, which are likely the values of the variables in the graph. The x-axis is labeled x, and the y-axis is labeled y. The graph is drawn on a white background, which makes the lines and their colors stand out clearly. The graph is not labeled, but it is clear that the variables are related. The red line is a straight line,](../images/imageFile60.png)

m

= 5,

θ

=

π/ 4

4

0

m

= 1,

θ

= 3

π/ 4

4

0

![In this image, we can see a diagram with two lines and a circle. We can also see some text on the image.](../images/imageFile61.png)

π/ 4

4

3

π/ 4

4

0

2

π

m

= 5,

θ

=

π/ 4

4

0

m

= 1,

θ

= 3

π/ 4

4

0

Figure 2.19 The von Mises distribution plotted for two different parameter values, shown as a Cartesian plot on the left and as the corresponding polar plot on the right.

where ‘const’ denotes terms independent of θ , and we have made use of the following trigonometrical identities Exercise 2.51

$$
\cos ^ { 2 } A + \sin ^ { 2 } A \ = \ 1
$$

$$
\cos A \cos B + \sin A \sin B \ = \ \cos ( A - B ) . \\ \intertext { c o s $ A $ \cos $ B $ + \sin $ A $ \sin $ B $ } \intertext { c o s $ A $ \cos $ B $ + \sin $ A $ \sin $ B $ } = \intertext { c o s $ ( A - B ) $ . }
$$

If we now deﬁne m = r 0 /σ 2 , we obtain our ﬁnal expression for the distribution of p ( θ ) along the unit circle r = 1 in the form

$$
p ( \theta | \theta _ { 0 } , m ) = \frac { 1 } { 2 \pi I _ { 0 } ( m ) } \exp \left \{ m \cos ( \theta - \theta _ { 0 } ) \right \}
$$

which is called the von Mises distribution, or the circular normal . Here the parameter θ 0 corresponds to the mean of the distribution, while m , which is known as the concentration parameter, is analogous to the inverse variance (precision) for the Gaussian. The normalization coefﬁcient in (2.179) is expressed in terms of I 0 ( m ) , which is the zeroth-order Bessel function of the ﬁrst kind (Abramowitz and Stegun, 1965) and is deﬁned by

$$
\text {defined by} \\ I _ { 0 } ( m ) = \frac { 1 } { 2 \pi } \int _ { 0 } ^ { 2 \pi } \exp \{ m \cos \theta \} \, d \theta . \\ \text {the distribution becomes approximately Gaussian. The von Mises dis-}
$$

For large m , the distribution becomes approximately Gaussian. The von Mises disExercise 2.52 tribution is plotted in Figure 2.19, and the function I 0 ( m ) is plotted in Figure 2.20.

Now consider the maximum likelihood estimators for the parameters θ 0 and m for the von Mises distribution. The log likelihood function is given by

$$
\ln p ( \mathcal { D } | \theta _ { 0 } , m ) = - N \ln ( 2 \pi ) - N \ln I _ { 0 } ( m ) + m \sum _ { n = 1 } ^ { N } \cos ( \theta _ { n } - \theta _ { 0 } ) . \quad ( 2 . 1 8 1 )
$$
