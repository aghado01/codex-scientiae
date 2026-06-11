[Page 11]

Mathematical notation

I have tried to keep the mathematical content of the book to the minimum necessary to achieve a proper understanding of the ﬁeld. However, this minimum level is nonzero, and it should be emphasized that a good grasp of calculus, linear algebra, and probability theory is essential for a clear understanding of modern pattern recognition and machine learning techniques. Nevertheless, the emphasis in this book is on conveying the underlying concepts rather than on mathematical rigour.

I have tried to use a consistent notation throughout the book, although at times this means departing from some of the conventions used in the corresponding research literature. Vectors are denoted by lower case bold Roman letters such as x, and all vectors are assumed to be column vectors. A superscript T denotes the transpose of a matrix or vector, so that xT will be a row vector. Uppercase bold roman letters, such as M, denote matrices. The notation (w1,...,wM) denotes a row vector with M elements, while the corresponding column vector is written as w = (w1,...,wM)T.

The notation [a,b] is used to denote the closed interval from a to b, that is the interval including the values a and b themselves, while (a,b) denotes the corresponding open interval, that is the interval excluding a and b. Similarly, [a,b) denotes an interval that includes a but excludes b. For the most part, however, there will be little need to dwell on such reﬁnements as whether the end points of an interval are included or not.

The M × M identity matrix (also known as the unit matrix) is denoted IM, which will be abbreviated to I where there is no ambiguity about it dimensionality. It has elements Iij that equal 1 if i = j and 0 if i �= j.

A functional is denoted f[y] where y(x) is some function. The concept of a functional is discussed in Appendix D.

The notation g(x) = O(f(x)) denotes that |f(x)/g(x)| is bounded as x → ∞. For instance if g(x) = 3x2 + 2, then g(x) = O(x2).

The expectation of a function f(x,y) with respect to a random variable x is de-

noted by Ex[f(x,y)]. In situations where there is no ambiguity as to which variable is being averaged over, this will be simpliﬁed by omitting the sufﬁx, for instance

xi
