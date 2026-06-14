[Page 10]



| 0.522 |
|---|



The datasets are preprocessed and split into training and testing sets. For this set of experiments, we convert the multivariate time series into a sequence of point clouds and compute ZZ-GRIL . We choose 5 datasets which have at least 7 multivariate time series. This ensures that each point cloud, in the sequence of point clouds, has at least 7 points, giving meaningful topological information. Refer to Figure 7 in Appendix B for a visualization of ZZ-GRIL on FingerMovements dataset.

In Table 2, we compare the performance of augmenting ZZ-GRIL to two specifically tailored machine learning models for multivariate time series classification on UEA MTSC datasets, TapNet Zhang et al. (2020) and TodyNet Liu et al. (2024). We can see from the table that ZZ-GRIL is adding meaningful topological information on most datasets which is seen as an improvement in performance. We picked these two models for augmenting ZZ-GRIL because of two reasons: (i) availability and ease-of-use of codebase, (ii) these models already have good performance on UEA MTSC Datasets and we wanted to test the additional value of the topological information that ZZ-GRIL adds. In order to do a comprehensive evaluation of ZZ-GRIL framework, we compare ZZ-GRIL in isolation with other methods Li et al. (2021); Tang et al. (2022); Karim et al. (2019); Schäfer & Leser (2017) on UEA MTSC task. We report the results in Table 1. We see that ZZ-GRIL has comparable performance. Here, we would like to remind the reader that ZZ-GRIL is a general framework which does not need to be tailored for these datasets in particular. Further, to show that we need both the spatial and the temporal information to be captured together, we compare ZZ-GRIL with standard zigzag persistence at various spatial scales. We report the results in Table 3. We can see that ZZ-GRIL performs better than standard zigzag persistence even across different scales.

We conduct two ablation studies. First, we find that converting time series into either, a sequence of point clouds or a sequence of graphs, is viable for extracting topological information as observed in Table 4). Second, to highlight the value of dynamic topological information, we show that ZZ-GRIL outperforms a “Snapshot PH” baseline, which vectorizes individual non-zigzag persistence modules. As shown in Table 5, ZZ-GRIL ’s superior performance confirms the importance of the features captured by zigzag persistence.



| 0.594 |
|---|





| 0.522 |
|---|



We report the computation times in Table 6 which indicate that ZZ-GRIL is, indeed, practical to use.
