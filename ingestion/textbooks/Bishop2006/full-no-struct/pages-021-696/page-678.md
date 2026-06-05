[Page 678]

Figure 14.1

Schematic illustration of the boosting framework. Each base classiﬁer y m ( x ) is trained on a weighted form of the training set (blue arrows) in which the weights w ( m ) n depend on the performance of the previous base classiﬁer y m − 1 ( x ) (green arrows). Once all base classiﬁers have been trained, they are combined to give the ﬁnal classiﬁer Y M ( x ) (red arrows).

![The image is a diagram showing the relationship between two variables, specifically the variables y and x. The diagram is labeled as y(x) = sign(m(x)), where m(x) is the variable representing the sign of the variable y. The diagram is divided into two main sections: the left section and the right section. The left section contains two lines, labeled as y(x) and y_{\frac{1}{2}}x, respectively. These lines represent the variables y and x, respectively. The right section contains two lines, labeled as y_{\frac{1}{2}}x and y_{\frac{2}{2}}x, respectively. These lines represent the variables y and x, respectively. The diagram also includes arrows, which are used to indicate the direction of the relationship between the variables. The arrows are colored red and green, with the red arrow pointing to the left and the green](../images/imageFile325.png)

M

(1)

(2)

(

)

{

}

{

}

{

}

w

w

w

n

n

n

y

(

)

y

(

)

y

(

)

M

1

2

x

x

x

$$
Y M ( x ) = sign ( M ∑ m α m y m ( x ) )
$$

# AdaBoost

- 1. Initialize the data weighting coefﬁcients { w n } by setting w (1) n = 1 /N for n = 1 ,...,N .
- 2. For m = 1 ,...,M :

(a) Fit a classiﬁer y m ( x ) to the training data by minimizing the weighted error function

$$
J _ { m } = \sum _ { n = 1 } ^ { N } w _ { n } ^ { ( m ) } I ( y _ { m } ( x _ { n } ) \neq t _ { n } ) & & ( 1 4 . 1 5 ) \\
$$

/negationslash

/negationslash

where I ( y m ( x n ) = t n ) is the indicator function and equals 1 when y m ( x n ) = t n and 0 otherwise.

/negationslash

(b) Evaluate the quantities

$$
\sum _ { \epsilon _ { m } = \frac { n = 1 } { n } } w _ { n } ^ { ( m ) } I ( y _ { m } ( x _ { n } ) \neq t _ { n } ) \\ \sum _ { n = 1 } ^ { N } w _ { n } ^ { ( m ) } \\ \text {use these to evaluate}
$$

/negationslash

and then use these to evaluate

$$
\text {see to evaluate} \\ \alpha _ { m } = \ln \left \{ \frac { 1 - \epsilon _ { m } } { \epsilon _ { m } } \right \} .
$$

(c) Update the data weighting coefﬁcients

$$
w _ { n } ^ { ( m + 1 ) } = w _ { n } ^ { ( m ) } \exp \left \{ \alpha _ { m } I ( y _ { m } ( { x } _ { n } ) \neq t _ { n } ) \right \}
$$

/negationslash Section 14.4
