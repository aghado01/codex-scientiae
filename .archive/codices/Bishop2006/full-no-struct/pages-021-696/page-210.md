[Page 210]

the weights becomes equivalent to the Fisher solution (Duda and Hart, 1973). In particular, we shall take the targets for class C 1 to be N/N 1 , where N 1 is the number of patterns in class C 1 , and N is the total number of patterns. This target value approximates the reciprocal of the prior probability for class C 1 . For class C 2 , we shall take the targets to be − N/N 2 , where N 2 is the number of patterns in class C 2 . The sum-of-squares error function can be written

The sum-of-squares error function can be written

$$
E = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \left ( w ^ { T } x _ { n } + w _ { 0 } - t _ { n } \right ) ^ { 2 } . \\ \text {activatives of $E$ with respect to $w_{0}$ and $w$ to zero, we obtain respectively}
$$

Setting the derivatives of E with respect to w 0 and w to zero, we obtain respectively

$$
\sum _ { n = 1 } ^ { N } \left ( w ^ { T } x _ { n } + w _ { 0 } - t _ { n } \right ) \ = \ 0 \\ \sum _ { n = 1 } ^ { N } ( \sum _ { T } T )
$$

$$
\sum _ { n = 1 } ^ { N } \left ( w ^ { T } x _ { n } + w _ { 0 } - t _ { n } \right ) x _ { n } \ = \ 0 . \\ \intertext { a n d } \text {making use of our choice of target coding scheme for the } t _ { n } , \text { we }
$$

From (4.32), and making use of our choice of target coding scheme for the t n , we obtain an expression for the bias in the form

$$
w _ { 0 } = - w ^ { T } m
$$

where we have used

$$
\sum _ { n = 1 } ^ { N } t _ { n } = N _ { 1 } \frac { N } { N _ { 1 } } - N _ { 2 } \frac { N } { N _ { 2 } } = 0 \\ \text {the mean of the total data set and is given by}
$$

and where m is the mean of the total data set and is given by

$$
m = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n } = \frac { 1 } { N } ( N _ { 1 } m _ { 1 } + N _ { 2 } m _ { 2 } ) . \\ \intertext { e s t r a i g h t f o r w a r d e b r a , a n d a g a i n m a k i n g u s e f t h e c h i o f t _ { n } , the }
$$

After some straightforward algebra, and again making use of the choice of t n , the second equation (4.33) becomes

$$
\text {a} i \text { on } ( 4 . 3 5 ) \text { becomes } & \quad \\ & \left ( S _ { w } + \frac { N _ { 1 } N _ { 2 } } { N } S _ { B } \right ) w = N ( m _ { 1 } - m _ { 2 } ) \\ \text {is defined by } & ( 4 . 2 8 ) \text { S$_} _ { \ } i s \text { defined by } ( 4 . 2 7 ) \text { and we have substituted for }
$$

where S W is deﬁned by (4.28), S B is deﬁned by (4.27), and we have substituted for the bias using (4.34). Using (4.27), we note that S B w is always in the direction of ( m 2 − m 1 ) . Thus we can write 1

$$
w \otimes S _ { W } ^ { - 1 } ( m _ { 2 } - m _ { 1 } ) \\ \\
$$

where we have ignored irrelevant scale factors. Thus the weight vector coincides with that found from the Fisher criterion. In addition, we have also found an expression for the bias value w 0 given by (4.34). This tells us that a new vector x should be classiﬁed as belonging to class C 1 if y ( x ) = w T ( x − m ) > 0 and class C 2 otherwise.
