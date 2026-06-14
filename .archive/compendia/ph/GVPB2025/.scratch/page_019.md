[Page 19]

To address this issue, we follow the approach in [25], which combines the k NN complex with the Vietoris-Rips complex. Starting from the k NN graph, the idea is to introduce a threshold radius R on each layer and use it to filter out edges of the graph whose lengths are less than or equal to R , and then expand, denoting this new complex k NN -VR. This filtering step allows us to focus on longer-range connections, uncovering significant topological features that may be hidden by shorter, more local connections.

To ensure consistency across layers, we select the radius R in each layer such that the number of connected components, β 0 , of the k NN complex falls in a pre-determined range. We then compute the observables presented in this work and verify the results. For clarity, we refer to k NN complex the construction used in the main body, and k NN -VR complexes the one presented in this section. For the sake of conciseness, we present only results for the inter-layer persistence ¯ Z .

In Figure 6 we show the inter-layer persistence of 1 -dimensional holes of the k NN and the k NN -VR complexes and the 0 -dimensional holes of the k NN -VR complexes computed by imposing β 0 = 500 ± 100 . 18 We observe all three curves are qualitatively similar. This indicates the stability of the results, even when removing a considerable amount of short edges. Moreover, we observe the same behavior also on 0 -dimensional holes, now that we modified the complex such that their statistics are large enough to reliably compute persistence. We argue this indicates a universal (in homology) tendency to retain relational connections among particles in the middle-late layers of the model.

![The image is a line graph that shows the relationship between two variables, specifically the inter-layer persistence and the layer-layer persistence. The x-axis represents the layer, and the y-axis represents the inter-layer persistence. The graph is titled Layer-Layer Persistence. The graph has two lines: 1. The first line is a blue line that starts at the bottom left and extends upwards to the top right. This line is labeled Layer-Layer Persistence. 2. The second line is a red line that starts at the top left and extends upwards to the bottom right. This line is labeled Layer-Layer Persistence. The graph has a scale from 0.0 to 0.8 on the x-axis, labeled Layer. The y-axis is labeled Inter-layer Persistence. The graph shows the following data points: 1. The blue line starts at a value of 0.](<GVPB2025/imageFile7.png>)

0.30

Knn(21)

0.25

VR (21)

0.20


0.15

0.10

Llama 3 8B

0.05

0.0

0.2

0.4

0.6

0.8

1.0

Layer

Figure 6: Inter-Layer Persistence with weight α = 0 as a function of model layers computed for Llama3 8B on the SST dataset for both k NN and k NN -VR complexes. We impose the number of connected components, β 0 = 500 ± 100 to build the k NN -VR complexes.

# E Consistency of Results

# E.1 Effective Persistent Images across Models

Given a fixed dataset, effective persistent images can be calculated across models and subtracted element-wise to highlight differences in how the models process the same information. We show all the possible comparisons for the 4 models considered in this work in Figure 7, which we calculate for the SST dataset. We can observe clear patterns in differences across models, reflecting what is observed in Figure 3.

17 Betti numbers have been used in previous works [25, 30] for interpreting internal representations of neural networks. However, they describe each layer independently from the others, which is not the purpose of this work. 18

We checked that results are stable as long as β 0 is much lower than the total number of points.
