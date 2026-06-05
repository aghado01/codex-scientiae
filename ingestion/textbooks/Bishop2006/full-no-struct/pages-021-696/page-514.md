[Page 514]

![The image depicts a graph with two axes labeled as x and y. The graph is a line graph with a horizontal axis labeled as x and a vertical axis labeled as y. The graph has a single point labeled as x at the bottom of the graph, and there are two points labeled as y and y_1 at the top of the graph. The graph has a horizontal line labeled as f(x) at the point x, and a vertical line labeled as y at the point y_1. The line f(x) is a straight line, and the line y is a straight line. The graph also has a point labeled as x at the bottom of the graph, and there is a point labeled as y at the top of the graph. The graph has a horizontal line labeled as f(x) at the point x, and](../images/imageFile243.png)

y

f

(

x

)

x

λx

![The image consists of a graph with two axes labeled as ( y ) and ( x ). The graph has two lines, one labeled as ( f(x) ) and the other labeled as ( \lambda - g(x) ). The graph shows a downward trend, where the line ( f(x) ) decreases as ( x ) increases. The line ( \lambda - g(x) ) also decreases, but it is not as steep as the first line. The graph also includes a point labeled as ( \alpha ) on the graph, which is located at the bottom right corner. This point is connected to the line ( f(x) ) by a line that is not as steep as the first line. The graph also includes a point labeled as ( \beta ) on the graph, which is located at the bottom left corner. This point is connected to](../images/imageFile244.png)

y

f

(

x

)

-

g

(

λ

)

x

-

λx

g

(

λ

)

Figure 10.11 In the left-hand plot the red curve shows a convex function f ( x ) , and the blue line represents the linear function λx , which is a lower bound on f ( x ) because f ( x ) > λx for all x . For the given value of slope λ the contact point of the tangent line having the same slope is found by minimizing with respect to x the discrepancy (shown by the green dashed lines) given by f ( x ) − λx . This deﬁnes the dual function g ( λ ) , which corresponds to the (negative of the) intercept of the tangent line having slope λ .

exp( − x ) , we therefore obtain the tangent line in the form

$$
y ( x ) & = \exp ( - \xi ) - \exp ( - \xi ) ( x - \xi ) & ( 1 0 . 1 2 6 ) \\
$$

which is a linear function parameterized by ξ . For consistency with subsequent discussion, let us deﬁne λ = − exp( − ξ ) so that

$$
y ( x , \lambda ) = \lambda x - \lambda + \lambda \ln ( - \lambda ) . \\ \\
$$

Different values of λ correspond to different tangent lines, and because all such lines are lower bounds on the function, we have f ( x ) y ( x,λ ) . Thus we can write the function in the form

$$
f ( x ) = \max _ { \lambda } \{ \lambda x - \lambda + \lambda \ln ( - \lambda ) \} .
$$

We have succeeded in approximating the convex function f ( x ) by a simpler, linear function y ( x,λ ) . The price we have paid is that we have introduced a variational parameter λ , and to obtain the tightest bound we must optimize with respect to λ .

We can formulate this approach more generally using the framework of convex duality (Rockafellar, 1972; Jordan et al. , 1999). Consider the illustration of a convex function f ( x ) shown in the left-hand plot in Figure 10.11. In this example, the function λx is a lower bound on f ( x ) but it is not the best lower bound that can be achieved by a linear function having slope λ , because the tightest bound is given by the tangent line. Let us write the equation of the tangent line, having slope λ as λx − g ( λ ) where the (negative) intercept g ( λ ) clearly depends on the slope λ of the tangent. To determine the intercept, we note that the line must be moved vertically by an amount equal to the smallest vertical distance between the line and the function, as shown in Figure 10.11. Thus

$$
g ( \lambda ) \ & = \ - \min _ { x } \left \{ f ( x ) - \lambda x \right \} \\ & = \max _ { x } \left \{ \lambda x - f ( x ) \right \} .
$$
