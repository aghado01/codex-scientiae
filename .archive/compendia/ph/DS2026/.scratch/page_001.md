[Page 1]

# Quasi Zigzag Persistence: A Topological Framework for Analyzing Time-Varying Data

*A Preprint*

Tamal K. Dey

Department of Computer Science Purdue University West Lafayette, IN tamaldey@purdue.edu

Shreyas N. Samaga

Department of Computer Science Purdue University West Lafayette, IN ssamaga@purdue.edu In this paper, we find that one such method, GRIL Xin et al. (2023) , which computes a landscape function Bubenik (2015) using generalized ranks of intervals Kim & Mémoli (2021), adapts naturally to the QZPH framework. This adaptation leads to our key contribution, ZZ-GRIL, a new topological invariant that extends the GRIL framework to capture multiscale topological information in time-evolving data. On the theoretical front, we prove the stability of ZZ-GRIL and show that the generalized rank over a specific type of subposet can be computed efficiently using an algorithm from Dey et al. (2024). This allows us to devise a practical algorithm for computing ZZ-GRIL. We demonstrate its value by augmenting machine learning models for tasks like sleep-stage detection from ECG and action classification from multivariate time-series, showing improved performance (Section 5). 1 .

January 21, 2026

## Abstract

In this paper, we propose Quasi Zigzag Persistent Homology (QZPH) as a framework for analyzing time-varying data by integrating multiparameter persistence and zigzag persistence. To this end, we introduce a stable topological invariant that captures both static and dynamic features at different scales. We present an algorithm to compute this invariant efficiently. We show that it enhances the machine learning models when applied to tasks such as sleep-stage detection, demonstrating its effectiveness in capturing the evolving patterns in time-varying datasets.

## 1 Introduction

Time varying data analysis Hamilton (1994); Box & Jenkins (1976) has been a fundamental challenge in the machine learning community, ranging from traditional time-series data to more complex structures such as sequences of graphs or point clouds. While traditional time-series have been handled effectively Wu et al. (2020), the complexity of modern applications necessitates novel methodologies. Spatiotemporal Graph Neural Networks Yu et al. (2018); Oreshkin et al. (2021); Kan et al. (2022); Chu et al. (2023) and specialized architectures for point cloud sequences Liu et al. (2019); Fan et al. (2021); Huang et al. (2021); Rempe et al. (2020) have emerged as powerful tools. However, most of these approaches utilize local geometric information, potentially missing crucial global patterns. This is particularly apparent where the overall shape carries significant meaning, such as in brain connectivity patterns. Topological methods offer a compelling solution by capturing these global, multi-scale structures. By augmenting models with topological information, we can leverage both local geometric patterns and global characteristics for improved performance.

Recently, Topological Data Analysis (TDA) has become a prominent field for leveraging such hidden information. Persistent Homology (PH), a cornerstone of TDA, provides a succinct method to extract multiscale topological features. This has been transformative in enhancing machine learning models. Analyzing time-varying data requires extending classical PH in two directions. First, the temporal component necessitates an additional parameter, bringing multiparameter persistence homology (MPH) Botnan & Lesnick (2023) into the picture. Second, standard PH computations use monotone filtrations which cannot accommodate the deletions required for time-varying data. This calls for zigzag persistent homology (ZPH) Carlsson & de Silva (2010), which captures dynamic topological features in time-series data Myers et al. (2023); Chen et al. (2021); Tinarrage et al. (2025); Hacquard & Lebovici (2024); Coskunuzer et al. (2024); Beltramo et al. (2022). Effectively, we need a combination of MPH and ZPH, allowing standard PH filtration along one parameter and ZPH along another. This requires structuring the underlying partiallyordered set (poset) as a quasi-zigzag poset , leading to what we term Quasi Zigzag Persistent Homology (QZPH) , which introduces a new set of challenges.

While MPH captures rich information, it suffers from the lack of a complete invariant, motivating the search for other informative, though incomplete, invariants Vipond (2020); Corbet et al. (2019); Carrière & Blumberg (2020); Scoccola et al. (2024); Loiseaux et al. (2023); Russold & Kerber (2024); Xin et al. (2023); Mukherjee et al. (2024). The application of ZPH to MPH requires zigzag generalizations of these methods.
