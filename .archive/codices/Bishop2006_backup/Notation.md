## 0. Mathematical notation

I have tried to keep the mathematical content of the book to the minimum necessary to achieve a proper understanding of the field. However, this minimum level is nonzero, and it should be emphasized that a good grasp of calculus, linear algebra, and probability theory is essential for a clear understanding of modern pattern recognition and machine learning techniques. Nevertheless, the emphasis in this book is on conveying the underlying concepts rather than on mathematical rigour.

I have tried to use a consistent notation throughout the book, although at times this means departing from some of the conventions used in the corresponding research literature. Vectors are denoted by lower case bold Roman letters such as x, and all vectors are assumed to be column vectors. A superscript T denotes the transpose of a matrix or vector, so that x T will be a row vector. Uppercase bold roman letters, such as M, denote matrices. The notation (w 1,...,w M) denotes a row vector with M elements, while the corresponding column vector is written as w = (w 1,...,w M) T. The notation [] is used to denote the interval from to, that is the a,b closed a b interval including the values a and b themselves, while (a,b) denotes the corresponding open interval, that is the interval excluding a and b. Similarly, [a,b) denotes an interval that includes a but excludes b. For the most part, however, there will be little need to dwell on such refinements as whether the end points of an interval are included or not.

The M × M identity matrix (also known as the unit matrix) is denoted I M, which will be abbreviated to I where there is no ambiguity about it dimensionality. It has elements I ij that equal 1 if i = j and 0 if i = j. A functional is denoted [] where () is some function. The concept of a

/negationslash

A functional is denoted f [y] where y (x) is some function. The concept of a functional is discussed in Appendix D.

The notation g (x) = O (f (x)) denotes that | f (x) /g (x) | is bounded as x → ∞. For instance if g (x) = 3 x 2 + 2, then g (x) = O (x 2).

The expectation of a function f (x, y) with respect to a random variable x is denoted by E x [f (x, y)]. In situations where there is no ambiguity as to which variable is being averaged over, this will be simplified by omitting the suffix, for instance E [x]. If the distribution of x is conditioned on another variable z, then the corresponding conditional expectation will be written E x [f (x) | z]. Similarly, the variance is denoted var[f (x)], and for vector variables the covariance is written cov[x, y]. We shall also use cov[x] as a shorthand notation for cov[x, x]. The concepts of expectations and covariances are introduced in Section 1.2.2.

If we have N values x 1,..., x N of a D -dimensional vector x = (x 1,...,x D) T, we can combine the observations into a data matrix X in which the n th row of X corresponds to the row vector x T n. Thus the n,i element of X corresponds to the i th element of the n th observation x n. For the case of one-dimensional variables we shall denote such a matrix by x, which is a column vector whose n th element is x n. Note that x (which has dimensionality N) uses a different typeface to distinguish it from x (which has dimensionality D).
