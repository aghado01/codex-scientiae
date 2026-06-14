[Page 21]

![The image is a line graph that shows the inter-layer persistence over time. The x-axis represents the relative depth, ranging from 0.0 to 1.0, while the y-axis represents the births per 1,000 population density. The graph shows three lines: the blue line, the orange line, and the purple line. The blue line is the most prominent line in the graph, indicating the highest level of births per 1,000 population density. It shows a sharp increase in births per 1,000 population density as the depth increases, suggesting that the population density is increasing rapidly. The orange line is the second-most prominent line in the graph, indicating the lowest level of births per 1,000 population density. It shows a similar trend to the blue line, with a sharp increase in births per 1,000 population density as the depth increases. The purple](<GVPB2025/imageFile9.png>)

0.35

0.07

3 8B

Llama

Llama 2 13B

0.30

0.06

2 70B

Llama

Llama 3 70B

0.05

0.25

0.20


0.03

0.15

0.02

0.10

0.01

0.05

0.00

0.00

0.0

0.2

0.4

0.6

0.8

1.0

0.0

Relative Depth

Llama 3 8B

2 13B

Llama

Llama 2 7OB

Llama 3 7OB

0.2

0.4

0.6

0.8

1.0

Figure 8: Births’ relative frequency (left) and inter-layer persistence (right) as a function of the models’ depth for larger models, namely Llama 2 13B, Llama 2 70B, and Llama 3 70B, compared to Llama 3 8B, computed for the SST dataset with weight α = 0 .

![This is a graph, which is titled Inter-Layers Relative Frequency. The graph shows the birth rate for different variables over a period of time. The x-axis represents the layer, and the y-axis represents the birth rate. The graph shows the following variables: - **Lama 38B**: The graph shows the birth rate for the Llama 38B population. - **Llama 38B**: The graph shows the birth rate for the Llama 38B population. - **Llama 38B**: The graph shows the birth rate for the Llama 38B population. - **Llama 38B**: The graph shows the birth rate for the Llama 38B population. - **Llama 38B**: The graph shows the birth rate for the Llama 38B population. - **L](<GVPB2025/imageFile10.png>)

0.35

CODE

0.07

SST

MATH

0.30

0.06

PILE

0.25

0.05

0.04

0.20


0.03

0.15

0.02

0.10

0.01

0.05

Llama 3 8B

0.00






Layer

CODE

SST

MATH

PILE

Llama 3 8B




Layer



Figure 9: Births’ Relative Frequency and Inter-Layer Persistence for weight α = − 0 as a function of model layers for Llama 3 8B for a range of datasets, averaged over 16 subsets of size 500 .

Variance of ¯ Z 1 as a function of data points. Given all the subsets with { 100, 200, ..., 1000 } points, we can calculate how the variance of these subsets scales as compared to the size of the subset. As a test case, we take the Llama 3 8B model with the SST dataset and compute the inter-layer persistence at weight α = 0 over all the subsets. We then plot the variance of each subset as a function of the subset size for different layers. We choose 4 layers so that they are roughly representative of the dynamical phases identified in the main text. We show results in Figure 12, where we overlay a fitted curve in black. Apart for the first layers, where the variance grows with the number of points, N, in later layers the relation seems to be approximately σ 2 ∝ N 3 / 2 .
