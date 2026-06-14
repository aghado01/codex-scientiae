[Page 11]



| 27s |
|---|





| 90.9 |
|---|



### 5.3 Sleep Stage Classification

We use ISRUC-S3 dataset, which is a part of the ISRUC (Iberian Studies and Research on Sleep) Sleep Dataset Khalighi et al. (2016). ISRUC-S3 contains PSG recordings from 10 subjects. Each recording includes multiple physiological signals, such as: EEG, ECG. The dataset is annotated with sleep stage labels for each epoch (30 second window). There are 5 sleep stage labels: Wake (W), N1, N2, N3 (non-REM stages) and REM. We use STDP-GCN Zhao et al. (2023) as the machine learning model to augment. In this experiment, we convert the time series into sequence of graphs and compare the performance in Table 7. We can see that augmenting ZZ-GRIL increases both the accuracy and the overall F-1 score.

We would like to clarify that the aim, for both sets of experiments, is primarily to show that an increase in accuracy upon augmentation signifies that ZZ-GRIL captures meaningful topological information which can be used to improve the existing models.

## 6 Conclusion

In this paper, we proposed QZPH as a framework to capture both static and dynamic topological features in time-varying data. We proposed ZZ-GRIL , a stable and computationally efficient topological invariant to address the challenges of integrating MPH and ZPH. Through applications in various domains, including sleep-stage detection, we showed that augmenting machine learning models with ZZ-GRIL improves the performance. These results highlight the potential of integrating topological information to address complex challenges while analyzing time-evolving data.

## 7 Acknowledgement

This work is partially supported by NSF grants DMS-2301360 and CCF-2437030. We acknowledge the discussion with Michael Lesnick who pointed out the theory about initial/terminal functors in the context of limits and colimits.
