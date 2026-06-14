[Page 9]

![In this image, we can see a diagram. There are some text written on the image. We can also see some numbers written on the image.](<DS2026/imageFile6.png>)


Sequence of graphs



-









Quasi zigzag bifiltration


Sequence of point clouds


Splicing with windows











Multivariate Time Series

Machine Learning Model (e.g. Spatiotemporal GNNs)




Figure 6: Experimental setup.

|Dataset/Methods|ED-1NN|DTW-1NN-I|DTW-1NN-D|MLSTM-FCN|ShapeNet|WEASEL+MUSE|OS-CNN|MOS-CNN|ZZ-GRIL|
|---|---|---|---|---|---|---|---|---|---|
|FingerMovements|0.550|0.520|0.530|0.580|0.589|0.490|0.568|0.568|0.590|
|Heartbeat|0.620|0.659|0.717|0.663|0.756|0.727|0.489|0.604|0.721|
|MotorImagery NATOPS|0.510|0.390|0.500|0.510|0.610|0.500|0.535|0.515|0.580|
|NATOPS|0.860|0.850|0.883|0.889|0.883|0.460|0.968|0.510|0.850|
|SelfRegulationSCP2|0.483|0.533|0.539|0.472|0.578|0.460|0.532|0.510|0.522|


Table 1: Acccuracy comparison of ZZ-GRIL with some existing methods on UEA Multivariate Time Series Classification Datasets. Bold entries denote the best model and gray the second best.

### 5.1 Experimental Setup

Each data instance is a multivariate time-series which we convert into a quasi zigzag bi-filtration. The ZZ-GRIL framework takes in a quasi zigzag bi-filtration as input and provides a topological signature for the sequence as output. We augment the machine learning model with this topological information and train the model for classification. The framework is shown in Figure 6.

Given a sample of multivariate time-series data with m time-series, we splice each time-series into a sequence of time-series , each of length w . This splicing is done by a moving window of width w , where consecutive windows have an overlap of λ . We calculate the Pearson correlation coefficient Pearson & Lee (1903) between time-series in each window. We construct a graph for each window, where each time-series (of length w ) is a node, and edges with the Pearson correlation values as weights connect them. Thus, we get a complete graph with m nodes. We select the top k percentile of these edges to build the final graph in each window. This way we obtain a sequence of graphs. The topological information of this sequence of graphs encodes the evolution of correlation between time series. Alternately, we can also track the evolving time-series by converting it into a sequence of point clouds. From the sequence of time-series described above, we consider each time-series of length w as a point in R w . Thus, if we have m time series, we have m points in R w in each window. Thus, we get a sequence of point clouds in R w . This sequence of point clouds tracks the evolution of each time-series, and a Vietoris-Rips like construction on this point cloud tracks the evolution of the interaction between time-series. Refer to Figure 6 for an illustration.

### 5.2 UEA Multivariate Time Series Classification

UEA Multivariate Time Series Classification (MTSC) Bagnall et al. (2018) archive comprises of real-world multivariate time series data and is a widely recognized benchmark in time series analysis. The UEA MTSC collection encompasses a diverse range of application domains such as healthcare (ECG or EEG data), motion recognition (recorded using wearable sensors). See Table 8 in Appendix B.

|Dataset/Methods|TapNet|TapNet+ZZ-GRIL|TodyNet|TodyNet+ZZ-GRIL|
|---|---|---|---|---|
|FingerMovements|0.530|0.630|0.570|0.660|
|Heartbeat|0.751|0.751|0.756|0.756|
|MotorImagery|0.580|0.600|0.640|0.660|
|NATOPS|0.927|0.922|0.972|0.961|
|SelfRegulationSCP2|0.538|0.544|0.550|0.600|


Table 2: Test acccuracy of augmenting ZZ-GRIL to TapNet and TodyNet on UEA Multivariate Time Series Classification Datasets.
