[Page 329]

![The image is a line graph that shows the trend of a variable over time. The x-axis represents the time, ranging from 0 to 3, while the y-axis represents the value. The graph has two lines, each representing a different time period. The first line starts at 0 and goes up to 1, then goes up to 2, and finally to 3. The second line starts at 0 and goes up to 3, then goes up to 4, and finally to 5. The graph is labeled as trend, and the title of the graph is trend. The x-axis is labeled t, and the y-axis is labeled t. The graph is drawn with a simple, linear scale of range 0 to 3, with a minimum of 0 and a maximum of 3. The line graph shows a general upward trend over time. The first line starts at 0](../images/imageFile136.png)

3

t

0

-3

x

-1

0

1

Exercise 6.21

suitable kernels.

Note that the mean (6.66) of the predictive distribution can be written, as a function of x N +1 , in the form

$$
m ( x _ { N + 1 } ) = \sum _ { n = 1 } ^ { N } a _ { n } k ( x _ { n } , x _ { N + 1 } ) \\ \\ \intertext { s u t h s c r . } \intertext { a n d } \intertext { w i t h s c r . } \intertext { a n d } \intertext { s u t h s c r . } \intertext { i n t h s c r . }
$$

where a n is the n th component of C − 1 N t . Thus, if the kernel function k ( x n , x m ) depends only on the distance x n − x m , then we obtain an expansion in radial basis functions.

The results (6.66) and (6.67) deﬁne the predictive distribution for Gaussian process regression with an arbitrary kernel function k ( x n , x m ) . In the particular case in which the kernel function k ( x , x ) is deﬁned in terms of a ﬁnite set of basis functions, we can derive the results obtained previously in Section 3.3.2 for linear regression starting from the Gaussian process viewpoint.

For such models, we can therefore obtain the predictive distribution either by taking a parameter space viewpoint and using the linear regression result or by taking a function space viewpoint and using the Gaussian process result.
