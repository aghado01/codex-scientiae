[Page 724]

Figure D.1 A functional derivative can be deﬁned by considering how the value of a functional F [ y ] changes when the function y ( x ) is changed to y ( x ) + η ( x ) where η ( x ) is an arbitrary function of x .

![The image depicts a graph with two lines. The graph is titled Y(x) + c(x) and has a horizontal axis labeled y(x) and a vertical axis labeled x. The graph is defined by two lines: one line labeled y(x) and the other line labeled x(x). The line y(x) is a straight line that starts at the point (0, 0) and extends upwards to the point (1, 1) on the graph. The line x(x) is a line that starts at the point (0, 0) and extends upwards to the point (1, 1) on the graph. The graph is drawn with a dashed line, which is a type of line that is drawn with a dashed line. The dashed line starts at the point (0, 0) and extends upwards to the point (1, 1) on the graph. The dashed line](../images/imageFile351.png)

y

(

x

)

y

(

x

) +

/epsilon1η

(

x

)

x

$$
f [ y ( x ) + \epsilon \eta ( x ) ] & = F [ y ( x ) ] + \epsilon \int \frac { \delta F } { \delta y ( x ) } \eta ( x ) \, d x + O ( \epsilon ^ { 2 } ) . \\ \intertext { t h i s c a n b e s e n a s a r y a l $ i n t u r a l $ extensi o n f o r $ D $ ) i n w h i c h $ F [ y ] $ n o w d e n p e s o n a }
$$

This can be seen as a natural extension of (D.2) in which F [ y ] now depends on a continuous set of variables, namely the values of y at all points x . Requiring that the functional be stationary with respect to small variations in the function y ( x ) gives

$$
\text {y with respect to small variations in the function} \, y ( x ) \text { gives} \\ \int \frac { \delta E } { \delta y ( x ) } \eta ( x ) \, d x = 0 . \\ \text {old for an arbitrary choice of } \eta ( x ) \text {  if  follows that the functional}
$$

Because this must hold for an arbitrary choice of η ( x ) , it follows that the functional derivative must vanish. To see this, imagine choosing a perturbation η ( x ) that is zero everywhere except in the neighbourhood of a point x , in which case the functional derivative must be zero at x = x . However, because this must be true for every choice of x , the functional derivative must vanish for all values of x . Consider a functional that is deﬁned by an integral over a function G ( y,y ,x ) that depends on both y ( x ) and its derivative y ( x ) as well as having a direct depen-

̂ Consider a functional that is defined by an integral over a function G ( y, y ′ , x ) that depends on both y ( x ) and its derivative y ′ ( x ) as well as having a direct dependence on x

$$
F [ y ] & = \int G \left ( y ( x ) , y ^ { \prime } ( x ) , x \right ) \, d x \\ \text {of } y ( x ) \text { is assumed to be fixed at the boundary of the region of }
$$

where the value of y ( x ) is assumed to be ﬁxed at the boundary of the region of integration (which might be at inﬁnity). If we now consider variations in the function y ( x ) , we obtain

$$
y ( x ) , & \text {we obtain} \\ & F [ y ( x ) + \epsilon ( x ) ] = F [ y ( x ) ] + \epsilon \int \left \{ \frac { \partial G } { \partial y } \eta ( x ) + \frac { \partial G } { \partial y ^ { \prime } } \eta ^ { \prime } ( x ) \right \} \, d x + O ( \epsilon ^ { 2 } ) . \ \ ( D . 6 ) \\ & \text {We now have to cast this in the form (D 3) . To do so, we integrate the second term by}
$$

We now have to cast this in the form (D.3). To do so, we integrate the second term by parts and make use of the fact that η ( x ) must vanish at the boundary of the integral (because y ( x ) is ﬁxed at the boundary). This gives

$$
( \text {because} \, y ( x ) \, \text { is fixed at the boundary} ) . \text { This gives} \\ F [ y ( x ) + \epsilon \eta ( x ) ] = F [ y ( x ) ] + \epsilon \int \left \{ \frac { \partial G } { \partial y } - \frac { \text {d} } { \text {d} x } \left ( \frac { \partial G } { \partial y ^ { \prime } } \right ) \right \} \eta ( x ) \, \text {d} x + O ( \epsilon ^ { 2 } ) \, \text { (D.7)}
$$
