[Page 18]

For all the experiments with sequence of point clouds, we choose a window size that is max(5 ,series _ length// 128) and overlap max(4 , 0 . 7 ∗ window _ size ) . For the experiments with sequence of graphs, we choose a window size of min( series _ length/ 5 , 128) and an overlap of 0 . 7 ∗ window _ size . Then, from the complete graph, we randomly choose a percentage between 65 and 75 of the edges depending on their weights. This is to ensure that the number of edges does not remain the same for all the graphs in the sequence. For all our experiments, we use 36 center points to compute ZZ-GRIL at. For model parameters, mostly, we use the same parameters as specified by the respective models Liu et al. (2024); Zhao et al. (2023). We notice that the training is sensitive to learning rate and we optimize the learning rate between 1 e − 3 and 5 e − 5 for different datasets. These choice of hyperparameters are based on preliminary experiments, the results of which we report in Table 9, Table 10 , Table 11 and Table 12. The results reported here are for TodyNet+ZZ-GRIL model.



| 180 |
|---|





| 0.600 Z -G |
|---|





| 0.578 |
|---|





| 0.550 |
|---|





| 0.550 |
|---|


