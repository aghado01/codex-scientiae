[Page 22]

![The image is a line graph titled Log(evidence) vs. Estimate. The x-axis represents the number of people, while the y-axis represents the number of people. The graph shows a downward trend in the number of people, with a sharp decline in the number of people after a certain point. The graph is labeled as log(evidence) vs. Estimate. The graph has a legend on the right side of the graph, which is labeled as MLsegments. The legend indicates that MLsegments is a type of regression model used to predict the number of people. The graph shows a downward trend in the number of people, with a sharp decline after a certain point. The number of people decreases rapidly, and the graph shows a sharp decline in the number of people after a certain point. There are two lines on the graph: 1. The first line is labeled as log(evidence) vs. Estimate and is](<HTR2005/imageFile17.png>)

100


0.1


-200


-400

ML#segments

log(evidence)

-600


log(evidence)

-800

ML#segments


-1000

Estimate

-1200


-1400

-1600


sqrt(varseg)

![The image is a scatter plot with a white background. The x-axis is labeled 5774 and the y-axis is labeled 5374. There are several data points plotted on the graph, each represented by a blue dot. The data points are scattered across the graph, with some scattered points closer to the bottom and others closer to the top. The data points are scattered in a random pattern, with no clear pattern or pattern.](<HTR2005/imageFile18.png>)

3.5


2.5


1.5


0.5


-0.5


5374

5474

5574

5674

5774

Figure 17: [Gen31: Aberrant gene copy # of chromosome 1] log P ( y ) (blue) and ˆ k (green) as function of σ and our estimate ˆ σ of (arg)max σ P ( y ) and ˆ k (ˆ σ ) (black triangles).

Figure 18: [Gen59: normal gene copy # of chromosome 9] with Bayesian regression.

The “log-ratios” y of a normal cell (and also the ∆ of any cell) are very close to Gaussian distributed, so we chose Gaussian BPCR. The log-ratios y of chromosome 1 of a sample known to have multiple myeloma are shown in Figure 15, together with the regression results. Visually, the segmentation is very reasonable. Long segments (e.g. t = 89 .. 408) as well as very short ones around t = 87 and 641 of length 3 are detected. The Bayesian regression curve in Figure 16 also behaves nicely. It is very ﬂat i.e. smoothes the data in long and clear segments, wiggles in less clear segments, and has jumps at the segment boundaries. Compare this to local smoothing techniques [Rin05], which wiggle much more within a segment and severely smooth boundaries. In this sense our Bayesian regression curve is somewhere in-between local smoothing and hard segmentation. We also see that the regression curve has a broad dip around t =535 .. 565, although t =510 .. 599 has been assigned to a single segment. This shows that other contributions breaking the segment have been mixed into the Bayesian regression curve. The PCR favor for a single segment is close to “tip over” as can be seen from the spikes in the break probability (red curve) in this segment.

The dependence of evidence and segment number on σ is shown in Figure 17. Our estimate ˆ σ (black triangle) perfectly maximizes P ( y | σ ) (blue curve). It is at a deep slope of P ( k | y ,σ ) (green curve), which means that the segmentation is sensitive to a good estimate of ˆ σ . There is no unique (statistically) correct segmentation (number). Various segmentations within some range are supported by comparable evidence.

Figure 18 shows a healthy chromosome 9, correctly lumped into one big segment.

Posterior probability of the number of segments P ( k | y ) . One of the most
