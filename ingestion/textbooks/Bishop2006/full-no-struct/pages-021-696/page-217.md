[Page 217]

# Figure 4.9

Plot of the logistic sigmoid function σ ( a ) deﬁned by (4.59), shown in red, together with the scaled probit function Φ( λa ) , for λ 2 = π/ 8 , shown in dashed blue, where Φ( a ) is deﬁned by (4.114). The scaling factor π/ 8 is chosen so that the derivatives of the two curves are equal for a = 0 .

![The image shows a graph with two lines. The x-axis is labeled as y and the y-axis is labeled as x. The graph has a single line that starts at the point (0, 0) and extends upwards to the right, while the other line starts at the point (1, 0) and extends downwards to the right. The line that starts at the point (0, 0) is a straight line, while the line that starts at the point (1, 0) is a curved line. The graph has a scale of range from 0 to 5 on the y-axis, and a scale of range from 0 to 5 on the x-axis, with a minimum of 0 and a maximum of 5. The graph is drawn with a single line, and the line starts at the point (0, 0) and extends upwards to the right, while the line starts at the point (](../images/imageFile100.png)

1

0.5

0

−5

0

5

approach in which we model the class-conditional densities p ( x |C k ) , as well as the class priors p ( C k ) , and then use these to compute posterior probabilities p ( C k | x ) through Bayes’ theorem.

Consider ﬁrst of all the case of two classes. The posterior probability for class C 1 can be written as

$$
p ( \mathcal { C } _ { 1 } | x ) & \ = \ \frac { p ( x | \mathcal { C } _ { 1 } ) p ( \mathcal { C } _ { 1 } ) } { p ( x | \mathcal { C } _ { 1 } ) p ( \mathcal { C } _ { 1 } ) + p ( x | \mathcal { C } _ { 2 } ) p ( \mathcal { C } _ { 2 } ) } \\ & = \ \frac { 1 } { 1 + \exp ( - a ) } = \sigma ( a ) \\ \intertext { v e h a v e d i n f e }
$$

where we have deﬁned

$$
a = \ln \frac { p ( x | \mathcal { C } _ { 1 } ) p ( \mathcal { C } _ { 1 } ) } { p ( x | \mathcal { C } _ { 2 } ) p ( \mathcal { C } _ { 2 } ) } \\ \intertext { a = \ln \frac { p ( x | \mathcal { C } _ { 1 } ) p ( \mathcal { C } _ { 1 } ) } { p ( x | \mathcal { C } _ { 2 } ) p ( \mathcal { C } _ { 2 } ) } } \\ \intertext { c s i g m o i d f u n g h e f f o n d e x }
$$

and σ ( a ) is the logistic sigmoid function deﬁned by

$$
\sigma ( a ) = \frac { 1 } { 1 + \exp ( - a ) } \intertext { i n v e r $ 4 . 0 $ T h e t m o n $ \dot { \cdot } $ v e r $ s $ o n d $ T h e t v e r $ f $ o n d $ T h e t m o n $ }
$$

which is plotted in Figure 4.9. The term ‘sigmoid’ means S-shaped. This type of function is sometimes also called a ‘squashing function’ because it maps the whole real axis into a ﬁnite interval. The logistic sigmoid has been encountered already in earlier chapters and plays an important role in many classiﬁcation algorithms. It satisﬁes the following symmetry property

$$
\sigma ( - a ) = 1 - \sigma ( a )
$$

as is easily veriﬁed. The inverse of the logistic sigmoid is given by

$$
\begin{array} { c } \text {invcse or the logistic sigmoid is given by} \\ a = \ln \left ( \frac { \sigma } { 1 - \sigma } \right ) \\ \end{array} \\ \text {t function. It represents the log of the ratio of probabilities}
$$

and is known as the logit function. It represents the log of the ratio of probabilities ln[ p ( C 1 | x ) /p ( C 2 | x )] for the two classes, also known as the log odds .
