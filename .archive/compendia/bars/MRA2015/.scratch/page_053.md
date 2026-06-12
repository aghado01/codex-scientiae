
![The image is a bar chart titled SOC with a linear scale of range 0 to 20 on the y-axis, labeled SOC with a linear scale of range 0 to 20 on the x-axis. The x-axis is labeled Year and is defined with a linear scale of range 1880 to 2000. The y-axis is labeled SOC with a linear scale of range 0 to 20. The chart is designed to show the percentage of people who are in the SOC, which stands for Social Security in the United States. The chart is labeled as SOC and has a legend on the right side of the chart that explains the meaning of the colors used on the y-axis. The legend is circular and consists of four colors: blue, purple, light blue, and dark blue. The x-axis is labeled](<images/MRA2015/imageFile14.png>)



SOI

−20

−40

1880

1900

1920

1940

1960

1980

2000

2020

Year

Figure 5.1: Monthly values of the Southern Oscillation Index (SOI).

# 5.2 Analysis

Two settings are considered for the application: The first setting utilizes quadratic basis functions to smooth the log periodogram of the SOI time series; the second setting utilizes cosine basis functions. The adaptive and non-adaptive methods were fit to the data running the algorithm for 2000 iterations with a burn-in period of 500. The number of knots for both fits is K κ = 50. In the adaptive case, K ι = 15 knots are used for the piecewise constant basis functions. Figure 5.2 displays the log periodogram and the pointwise 95% credible intervals for the fits based on quadratic basis functions.
