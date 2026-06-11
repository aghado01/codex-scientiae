[Page 54]

×

![The image is a scatter plot with a white background. The plot is divided into two main sections, each with a different color. The x-axis is labeled x and the y-axis is labeled y. The plot is filled with red and green circles, with the red circles being scattered throughout the plot and the green circles being more concentrated in the middle. The x-axis is labeled x and the y-axis is labeled y. The plot is divided into two main sections, each with a different color. The red section is labeled 1 and the green section is labeled 0.5. The x-axis is labeled x and the y-axis is labeled y. The plot is filled with red and green circles, with the red circles being scattered throughout the plot and the green circles being more concentrated in the middle. The x-axis is labeled x and the y-axis is labeled](../images/imageFile24.png)

2

1.5

x

1

7

0.5

0

0

0.25

0.5

0.75

1

x

6

of high dimensionality comprising many input variables. As we now discuss, this poses some serious challenges and is an important factor inﬂuencing the design of pattern recognition techniques.

In order to illustrate the problem we consider a synthetically generated data set representing measurements taken from a pipeline containing a mixture of oil, water, and gas (Bishop and James, 1993). These three materials can be present in one of three different geometrical conﬁgurations known as ‘homogenous’, ‘annular’, and ‘laminar’, and the fractions of the three materials can also vary. Each data point comprises a 12 -dimensional input vector consisting of measurements taken with gamma ray densitometers that measure the attenuation of gamma rays passing along narrow beams through the pipe. This data set is described in detail in Appendix A. Figure 1.19 shows 100 points from this data set on a plot showing two of the measurements x 6 and x 7 (the remaining ten input values are ignored for the purposes of this illustration). Each data point is labelled according to which of the three geometrical classes it belongs to, and our goal is to use this data as a training set in order to be able to classify a new observation ( x 6 ,x 7 ) , such as the one denoted by the cross in Figure 1.19. We observe that the cross is surrounded by numerous red points, and so we might suppose that it belongs to the red class. However, there are also plenty of green points nearby, so we might think that it could instead belong to the green class. It seems unlikely that it belongs to the blue class. The intuition here is that the identity of the cross should be determined more strongly by nearby points from the training set and less strongly by more distant points. In fact, this intuition turns out to be reasonable and will be discussed more fully in later chapters.

How can we turn this intuition into a learning algorithm? One very simple approach would be to divide the input space into regular cells, as indicated in Figure 1.20. When we are given a test point and we wish to predict its class, we first decide which cell it belongs to, and we then find all of the training data points that Illustration of a simple approach to the solution of a classification problem in which the input space is divided into cells and any new test point is assigned to the class that has a majority number of representatives in the same cell as the test point. As we shall see shortly, this simplistic approach has some severe shortcomings.
