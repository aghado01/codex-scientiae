[Page 10]



| 58.09 |
|---|




Benchmark Table. the model without any layer pruned. (ii) This work , accuracy of the model, where layers are pruned following the algorithm 2). (iii) Other works , accuracy obtained by considering the same amount of layer pruned estimated with our method and then computing the layer to be pruned with two different similarity measures: angular distance from [6] and Bi-score from [7]. The chosen layers turn out to be the same for the two methods, so the results are condensed into one column.

We compare our layer pruning methods to recent work [6] and [7] performing pruning using similarity measures. Both approaches are designed to take as input the desired number of layers to prune N prune and measure performance as N prune grows. For a fair comparison, we feed the number of layers cut by our method as an input to the other two methods, and verify which layers they select to cut given this input, and the corresponding performance. We show which layers are cut for each method in Table 2 in Appendix G.2. Interestingly, both considered methods from [6] and [7] give the same result at fixed N prune , thus we refer to them simply as “other works”. We show performance results in Table 1, 12 where in bold we indicate the layer pruning method that has better or equal performance with respect to the other method. Despite often selecting different layers, our zigzag-based pruning strategy achieves comparable results to methods from [6] and [7].

# 5 Conclusions

Recent work has argued in different ways that large language models process inputs across layers through distinct phases, and that understanding these phases is important for the models’ interpretation. We exploit topological data analysis tools to build descriptors that allow to statistically characterize the dynamics of prompts within internal representations of large language models. Based on this characterization, we distinguish four phases and connect them to the model’s behavior through experiments based on layer pruning and performance benchmarking. Our method consistently provides qualitatively similar results across different models, datasets, and parameter selections. Simultaneously, our topological descriptors allow for quantitative differentiation across models and datasets, creating opportunities for experiments designed to address more specific and practical questions regarding particular models or datasets.

There are several limitations in our study that future research could address. First, while our method shows robustness across hyperparameters within the framework, these choices need not be optimal. Defining an appropriate criterion for connecting points in the representation space, and consequently, a filtration, is a delicate task in TDA that could require further investigations to detail the impact of the various choices on the construction of the filtration. Secondly, our study primarily focuses on static, pre-trained models. Extending this framework to track the evolution of internal representations during training might provide important insights into model efficiency and behavior.

# 6 Reproducibility

All the results contained in this work are reproducible by means of a GitHub repository that can be found at this link https://github.com/RitAreaSciencePark/ZigZagLLMs.
