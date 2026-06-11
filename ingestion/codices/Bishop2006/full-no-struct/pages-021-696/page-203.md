[Page 203]

![In the image, we can see a diagram of a triangle. The diagram consists of two sides, one of which is labeled as R1. The other side is labeled as R2. There is a point labeled as C1 on the side R1. The line segment R1 is drawn from point C1 to the right side of the triangle.](../images/imageFile92.png)

C

3

C

1

?

R

1

R

R

3

1

C

?

R

1

2

C

3

C

1

R

2

R

3

C

C

2

2

C

not

1

C

2

C

not

2

Figure 4.2 Attempting to construct a K class discriminant from a set of two class discriminants leads to ambiguous regions, shown in green. On the left is an example involving the use of two discriminants designed to distinguish points in class C k from points not in class C k . On the right is an example involving three discriminant functions each of which is used to separate a pair of classes C k and C j .

example involving three classes where this approach leads to regions of input space that are ambiguously classiﬁed.

An alternative is to introduce K ( K − 1) / 2 binary discriminant functions, one for every possible pair of classes. This is known as a one-versus-one classiﬁer. Each point is then classiﬁed according to a majority vote amongst the discriminant functions. However, this too runs into the problem of ambiguous regions, as illustrated in the right-hand diagram of Figure 4.2.

We can avoid these difﬁculties by considering a single K -class discriminant comprising K linear functions of the form

$$
y _ { k } ( x ) = w _ { k } ^ { T } x + w _ { k 0 }
$$

/negationslash

and then assigning a point x to class C k if y k ( x ) > y j ( x ) for all j = k . The decision boundary between class C k and class C j is therefore given by y k ( x ) = y j ( x ) and hence corresponds to a ( D − 1) -dimensional hyperplane deﬁned by T

$$
( w _ { k } - w _ { j } ) ^ { T } x + ( w _ { k 0 } - w _ { j 0 } ) = 0 .
$$

This has the same form as the decision boundary for the two-class case discussed in Section 4.1.1, and so analogous geometrical properties apply.

The decision regions of such a discriminant are always singly connected and convex. To see this, consider two points x A and x B both of which lie inside decision region R k , as illustrated in Figure 4.3. Any point x that lies on the line connecting x A and x B can be expressed in the form x = λ x A + (1 − λ ) x B (4.11)

$$
\widehat { x } = \lambda x _ { A } + ( 1 - \lambda ) x _ { B }
$$
