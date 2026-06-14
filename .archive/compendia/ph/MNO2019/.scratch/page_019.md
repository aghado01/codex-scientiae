[Page 19]



BCC Persistence Diagram

Birth

(a)

![The image is a bar graph titled BCC Persistence Diagram and it is sourced from FCC Persistence Diagram. The graph is titled BCC Persistence Diagram and it is sourced from FCC Persistence Diagram. The graph is a bar graph with three vertical bars representing the BCC Persistence and FCC Persistence data. The x-axis is labeled Birth and the y-axis is labeled Persistence. The data points are represented by red dots on the graph. The x-axis is labeled Birth and the y-axis is labeled Persistence. The data points are represented by red dots on the graph. The data points are arranged in a triangular pattern, with the highest point at the top of the graph and the lowest point at the bottom. The graph is labeled as follows: - BCC Persistence is represented by a red dot on the graph. -](<MNO2019/imageFile9.png>)

FCC Persistence Diagram


|


Birth

(b)

FIG. 9: Persistence diagrams for members of the BCC and FCC classes.

TABLE 4

Parameters for the prior intensities used in cross-validation of materials science data. Each prior λ is indexed by its corresponding class for Prior-1 or U in the case of the Prior-2. The summary of AUCs across 10-folds for materials science data after scoring with Algorithm 1 is presented in the last three columns.

|Priors|Parameters for Prior Intensities µ D i σ D i c D i 5th| | | |Summary of AUC| | |
|---|---|---|---|---|---|---|---|
| | |µ D i|σ D i|c D i|5th per- centile|Mean|95th per- centile|
|Prior-1|λ BCC|(3.6,3.6) (3.7,0.65)|2 2 1 1|1 1 1|0 . 931|0 . 941 0|. 958|
| |λ FCC|(0.4,0.27) (2.8,1.2)|2 2 1 1|1 1 1| | | |
|Prior-2|λ U|(1,1)|20|1|0 . 928|0.94 0|. 951|


## 5 Discussion and Conclusions

This work is the ﬁrst approach to introduce a Bayesian framework for persistent homology. This toolbox will give the opportunity to an expert to incorporate their prior belief about the data as well as analyze the data using topological data analysis methods. To that end, we introduce point processes to model random persistence diagrams. Indeed, we incorporate the prior uncertainty by modeling persistence diagrams as Poisson point processes and noisy observations of persistence diagrams as marked Poisson PP to model the level of conﬁdence that observations are representatives of the ground truth. Considering a Poisson point process, one needs to focus on the intensity of the random process. Adapting a prior intensity and a pertinent likelihood, we prove that a posterior intensity can be retrieved. It should be noted that our Bayesian model considers persistence diagrams, which are summaries of the data at hand, for deﬁning a substitution likelihood rather than using the underlying point cloud data. This does not adhere to a strict Bayesian viewpoint, as we model the behavior of the persistence diagrams without considering the underlying data (materials data in our example) used to create it; however, our paradigm incorporates prior knowledge and observed data summaries to create posterior probabilities, analogous to the notion of substitution likelihood detailed in [27]. The general relationship between the likelihood models related to point cloud data and those of
