[Page 7]

We use 3 benchmarks for layer pruning performance evaluation: MMLU [73], HellaSwag [74], and Winogrande [75], which have been widely used for similar purposes in previous analyses. The benchmarks are evaluated for the models with the use of the library lm-eval-harness by [76] with a 5-shot setup.

# 4.2 Zigzag persistence applied to LLM models

We generate zigzag diagrams for each model and dataset and for each homology dimension up to p = 3 , for a range of values of k NN ∈ [1 , 15] . We find that 0 -, 2 − and 3 -dimensional holes are relatively lower in number, while 1 -dimensional holes reach tens of thousands of elements per layer. This behavior might be expected for a k NN -graphbased construction since connections are dense even for low values of k NN , especially if points are concentrated in low dimensional regions of the representation space. We examine this behavior in detail to make sure that our construction is stable for different choices on the k NN graph, see Appendix D for details. The choice of the hyperparameter k NN is done so as to maximize the total number of holes. Therefore, in what follows, we show results for our topological descriptors for 1 -dimensional holes and k NN = 4 only.

Effective Persistence Image. We show an example of an effective persistent image of 1 -dimensional holes in Figure 2, where we use the Llama 3 8B model and the SST dataset. The x-axis represents the layer at which a 1 -dimensional hole is born, and the y-axis represents persistence, i.e. death layer birth layer. The color bar measures the amount of 1 -dimensional holes on a given grid point. We see that features born after the first half of the model’s depth have a higher tendency to be long-lived with respect to features born earlier on. This aspect is going to be evident when computing also the topological descriptors, below. In the Appendix E.1, we show a wider range of images, comparing them across models by taking the element-wise difference of effective persistence images.

![The image is a bar chart titled Llama 3 8B. The x-axis represents the birth year, ranging from 0 to 30 years. The y-axis represents the persistence (measured in units of 1-dimensional linear scale from 0 to 100). The chart shows a clear upward trend in the persistence of the Llama 3 8B over the years. ### Breakdown of the Bar Chart: 1. **X-Axis (Birth Year)**: The x-axis is labeled Birth Year and ranges from 0 to 30 years. 2. **Y-Axis (Persistence)**: The y-axis is labeled Persistence (units of 1-dimensional linear scale from 0 to 100) and ranges from 0 to 100 units. ### Analysis: - **Growth Trend**: The chart shows a clear upward trend](<GVPB2025/imageFile3.png>)

4.0

Llama 3 8B


3.5



3.0



2.5

2.0


1.5


1.0


0.5


0.0







Birth Layer (lbirth)

Figure 2: Effective persistence image of 1 -dimensional holes for the Llama 3 8B model using the SST dataset, where we fix k NN = 4 . The density plot shows the number of holes (color bar) for a given birth-persistence pair (xand yaxis), where values refer to the model layer. This plot shows that a large amount of 1-dimensional holes are short-lived and that long-lived features appear after the first half of the model.

Births’ Relative Frequency. In the left panel of Figure 3 we show B 1 (Eq. 5) for Llama 3 8B on the SST dataset, for varying α = − 1 , 0 , 0 . 5 , 1 , 2 . We can clearly distinguish two behaviors for shortand long-lived 1 -dimensional holes: the former peaks at early layers and progressively decreases, while the latter peaks at middle layers. Additionally, a strong increase in births number is seen in the last few layers. We highlight a horizontal line corresponding to the uniform distribution for comparison. We complement these results in Appendix E.3 with a comparison across models and datasets, finding qualitatively similar results.
