[Page 204]

Figure 4.3 Illustration of the decision regions for a multiclass linear discriminant, with the decision boundaries shown in red. If two points x A and x B both lie inside the same decision region R k , then any point b x that lies on the line connecting these two points must also lie in R k , and hence the decision region must be singly connected and convex.

![The image is a diagram of a geometric figure, specifically a right triangle. The triangle is labeled as R, with vertices labeled as A, B, and C. The vertices are connected by lines, and the triangle is formed by connecting the points of intersection of these lines. ### Description of the Triangle: - **Points of Intersection**: - A - B - C - R - R' - R' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R'' - R''](../images/imageFile93.png)

R

j

R

i

R

k

B

x

A

ˆ

x

x

where 0 λ 1 . From the linearity of the discriminant functions, it follows that

y k ( x ) = λy k ( x A ) + (1 − λ ) y k ( x B ) . (4.12) Because both x A and x B lie inside R k , it follows that y k ( x A ) > y j ( x A ) , and y k ( x B ) > y j ( x B ) , for all j = k , and hence y k ( x ) > y j ( x ) , and so x also lies inside R k . Thus R k is singly connected and convex. Note that for two classes, we can either employ the formalism discussed here, based on two discriminant functions y 1 ( x ) and y 2 ( x ) , or else use the simpler but

/negationslash

Note that for two classes, we can either employ the formalism discussed here, based on two discriminant functions y 1 ( x ) and y 2 ( x ) , or else use the simpler but equivalent formulation described in Section 4.1.1 based on a single discriminant function y ( x ) .

We now explore three approaches to learning the parameters of linear discriminant functions, based on least squares, Fisher’s linear discriminant, and the perceptron algorithm.

# 4.1.3 Least squares for classiﬁcation

In Chapter 3, we considered models that were linear functions of the parameters, and we saw that the minimization of a sum-of-squares error function led to a simple closed-form solution for the parameter values. It is therefore tempting to see if we can apply the same formalism to classiﬁcation problems. Consider a general classiﬁcation problem with K classes, with a 1-ofK binary coding scheme for the target vector t . One justiﬁcation for using least squares in such a context is that it approximates the conditional expectation E [ t | x ] of the target values given the input vector. For the binary coding scheme, this conditional expectation is given by the vector of posterior class probabilities. Unfortunately, however, these probabilities are typically approximated rather poorly, indeed the approximations can have values outside the range (0 , 1) , due to the limited ﬂexibility of a linear model as we shall see shortly.

Each class C k is described by its own linear model so that

$$
y _ { k } ( x ) = w _ { k } ^ { T } x + w _ { k 0 }
$$

where k = 1 ,...,K . We can conveniently group these together using vector nota-

tion so that

$$
y ( x ) = \widetilde { W } ^ { \top } \widetilde { x }
$$
