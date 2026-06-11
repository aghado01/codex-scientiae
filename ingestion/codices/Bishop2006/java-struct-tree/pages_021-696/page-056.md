[Page 56]

extend this approach to deal with input spaces having several variables. If we have D input variables, then a general polynomial with coefﬁcients up to order 3 would take the form

�D

�D

�D

�D

�D

�D

y(x,w) = w0 +

wixi +

wijxixj +

wijkxixjxk. (1.74)

i=1

i=1

j=1

i=1

j=1

k=1

As D increases, so the number of independent coefﬁcients (not all of the coefﬁcients are independent due to interchange symmetries amongst the x variables) grows proportionally to D3. In practice, to capture complex dependencies in the data, we may need to use a higher-order polynomial. For a polynomial of order M, the growth in

Exercise 1.16 the number of coefﬁcients is like DM. Although this is now a power law growth, rather than an exponential growth, it still points to the method becoming rapidly unwieldy and of limited practical utility.

Our geometrical intuitions, formed through a life spent in a space of three dimensions, can fail badly when we consider spaces of higher dimensionality. As a simple example, consider a sphere of radius r = 1 in a space of D dimensions, and ask what is the fraction of the volume of the sphere that lies between radius r = 1−� and r = 1. We can evaluate this fraction by noting that the volume of a sphere of radius r in D dimensions must scale as rD, and so we write

VD(r) = KDrD (1.75) Exercise 1.18 where the constant KD depends only on D. Thus the required fraction is given by

VD(1) − VD(1 − �) VD(1)

= 1 − (1 − �)D (1.76)

which is plotted as a function of � for various values of D in Figure 1.22. We see that, for large D, this fraction tends to 1 even for small values of �. Thus, in spaces of high dimensionality, most of the volume of a sphere is concentrated in a thin shell near the surface!

As a further example, of direct relevance to pattern recognition, consider the behaviour of a Gaussian distribution in a high-dimensional space. If we transform from Cartesian to polar coordinates, and then integrate out the directional variables,

Exercise 1.20 we obtain an expression for the density p(r) as a function of radius r from the origin. Thus p(r)δr is the probability mass inside a thin shell of thickness δr located at radius r. This distribution is plotted, for various values of D, in Figure 1.23, and we see that for large D the probability mass of the Gaussian is concentrated in a thin shell.

The severe difﬁculty that can arise in spaces of many dimensions is sometimes called the curse of dimensionality (Bellman, 1961). In this book, we shall make extensive use of illustrative examples involving input spaces of one or two dimensions, because this makes it particularly easy to illustrate the techniques graphically. The reader should be warned, however, that not all intuitions developed in spaces of low dimensionality will generalize to spaces of many dimensions.
