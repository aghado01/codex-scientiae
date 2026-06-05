[Page 513]

# 10.5. Local Variational Methods

Section 1.6.1

The variational framework discussed in Sections 10.1 and 10.2 can be considered a ‘global’ method in the sense that it directly seeks an approximation to the full posterior distribution over all random variables. An alternative ‘local’ approach involves ﬁnding bounds on functions over individual variables or groups of variables within a model. For instance, we might seek a bound on a conditional distribution p ( y | x ) , which is itself just one factor in a much larger probabilistic model speciﬁed by a directed graph. The purpose of introducing the bound of course is to simplify the resulting distribution. This local approximation can be applied to multiple variables in turn until a tractable approximation is obtained, and in Section 10.6.1 we shall give a practical example of this approach in the context of logistic regression. Here we focus on developing the bounds themselves.

We have already seen in our discussion of the Kullback-Leibler divergence that the convexity of the logarithm function played a key role in developing the lower bound in the global variational approach. We have deﬁned a (strictly) convex function as one for which every chord lies above the function. Convexity also plays a central role in the local variational framework. Note that our discussion will apply equally to concave functions with ‘min’ and ‘max’ interchanged and with lower bounds replaced by upper bounds.

Let us begin by considering a simple example, namely the function f ( x ) = exp( − x ) , which is a convex function of x , and which is shown in the left-hand plot of Figure 10.10. Our goal is to approximate f ( x ) by a simpler function, in particular a linear function of x . From Figure 10.10, we see that this linear function will be a lower bound on f ( x ) if it corresponds to a tangent. We can obtain the tangent line y ( x ) at a speciﬁc value of x , say x = ξ , by making a ﬁrst order Taylor expansion

$$
y ( x ) = f ( \xi ) + f ^ { \prime } ( \xi ) ( x - \xi )
$$

so that y ( x ) f ( x ) with equality when x = ξ . For our example function f ( x ) =

Figure 10.10 In the left-hand ﬁgure the red curve shows the function exp( − x ) , and the blue line shows the tangent at x = ξ deﬁned by (10.125) with ξ = 1 . This line has slope λ = f ( ξ ) = − exp( − ξ ) . Note that any other tangent line, for example the ones shown in green, will have a smaller value of y at x = ξ . The right-hand ﬁgure shows the corresponding plot of the function λξ − g ( λ ) , where g ( λ ) is given by (10.131), versus λ for ξ = 1 , in which the maximum corresponds to λ = − exp( − ξ ) = − 1 /e .

1

0.5

0

0

ξ

1.5

x

3

![image 242](../images/imageFile242.png)

0.4

-

λξ

g

(

λ

)

0.2

0

-1

−0.5

0

λ
