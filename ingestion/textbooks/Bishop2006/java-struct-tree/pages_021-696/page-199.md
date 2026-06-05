[Page 199]

4

![image 60](../../../../../images/imageFile60.png)

Linear Models for Classiﬁcation

In the previous chapter, we explored a class of regression models having particularly simple analytical and computational properties. We now discuss an analogous class of models for solving classiﬁcation problems. The goal in classiﬁcation is to take an input vector x and to assign it to one of K discrete classes Ck where k = 1,...,K. In the most common scenario, the classes are taken to be disjoint, so that each input is assigned to one and only one class. The input space is thereby divided into decision regions whose boundaries are called decision boundaries or decision surfaces. In this chapter, we consider linear models for classiﬁcation, by which we mean that the decision surfaces are linear functions of the input vector x and hence are deﬁned by (D − 1)-dimensional hyperplanes within the D-dimensional input space. Data sets whose classes can be separated exactly by linear decision surfaces are said to be linearly separable.

For regression problems, the target variable t was simply the vector of real numbers whose values we wish to predict. In the case of classiﬁcation, there are various

179
