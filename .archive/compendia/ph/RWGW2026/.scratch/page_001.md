[Page 1]

# Persistent Sheaf Laplacian Analysis of Protein Stability and Solubility Changes upon Mutation

Yiming Ren 1 , Junjie Wee 1 , Xi Chen 2 , Grace Qian 3 , and Guo-Wei Wei 1 , 4 , 5∗

1 Department of Mathematics,

Michigan State University, East Lansing, MI 48824, USA. 2 The Frazer School, 4700 NW 89 Blvd, Gainesville, FL 32606, USA 3 Lassiter High School, Marietta, GA 30066, USA 4 Department of Biochemistry and Molecular Biology, Michigan State University, East Lansing, MI 48824, USA. 5 Department of Electrical and Computer Engineering, Michigan State University, East Lansing, MI 48824, USA.

January 21, 2026

## Abstract

Genetic mutations frequently disrupt protein structure, stability, and solubility, acting as primary drivers for a wide spectrum of diseases. Despite the critical importance of these molecular alterations, existing computational models often lack interpretability, and fail to integrate essential physicochemical interaction. To overcome these limitations, we propose SheafLapNet, a unified predictive framework grounded in the mathematical theory of Topological Deep Learning (TDL) and Persistent Sheaf Laplacian (PSL). Unlike standard Topological Data Analysis (TDA) tools such as persistent homology, which are often insensitive to heterogeneous information, PSL explicitly encodes specific physical and chemical information such as partial charges directly into the topological analysis. SheafLapNet synergizes these sheaf-theoretic invariants with advanced protein transformer features and auxiliary physical descriptors to capture intrinsic molecular interactions in a multiscale and mechanistic manner. To validate our framework, we employ rigorous benchmarks for both regression and classification tasks. For stability prediction, we utilize the comprehensive S2648 and S350 datasets. For solubility prediction, we employ the PON-Sol2 dataset, which provides annotations for increased, decreased, or neutral solubility changes. By integrating these multi-perspective features, SheafLapNet achieves state-of-the-art performance across these diverse benchmarks, demonstrating that sheaf-theoretic modeling significantly enhances both interpretability and generalizability in predicting mutation-induced structural and functional changes.

Key words: Protein folding stability, protein soluability, mutation, persistent topological Laplacians, Sheaf Laplacian networks

∗ Corresponding author. Email: weig@msu.edu
