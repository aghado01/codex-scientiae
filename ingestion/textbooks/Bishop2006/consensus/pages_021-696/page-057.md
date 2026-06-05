[Page 57]

Figure 1.22 Plot of the fraction of the volume of a sphere lying in the range $r = 1 - \epsilon$ to $r = 1$ for various values of the dimensionality $D$.

![image 27](../../../../../images/imageFile27.png)

Although the curse of dimensionality certainly raises important issues for pattern recognition applications, it does not prevent us from ﬁnding effective techniques applicable to high-dimensional spaces. The reasons for this are twofold. First, real data will often be conﬁned to a region of the space having lower effective dimensionality, and in particular the directions over which important variations in the target variables occur may be so conﬁned. Second, real data will typically exhibit some smoothness properties (at least locally) so that for the most part small changes in the input variables will produce small changes in the target variables, and so we can exploit local interpolation-like techniques to allow us to make predictions of the target variables for new values of the input variables. Successful pattern recognition techniques exploit one or both of these properties. Consider, for example, an application in manufacturing in which images are captured of identical planar objects on a conveyor belt, in which the goal is to determine their orientation. Each image is a point

Figure 1.23 Plot of the probability density with respect to radius $r$ of a Gaussian distribution for various values of the dimensionality $D$. In a high-dimensional space, most of the probability mass of a Gaussian is located within a thin shell at a speciﬁc radius.

![image 28](../../../../../images/imageFile28.png)
