[Page 1]

# P ERSISTENT T OPOLOGICAL F EATURES IN L ARGE L ANGUAGE M ODELS

Yuri Gardinazzi 1 , 2 ∗ , Karthik Viswanathan 3 , 1 ∗ , Giada Panerai 1

Alessio Ansuini 1 , Alberto Cazzaniga 1 and Matteo Biagetti 1 †

1 Area Science Park, Trieste, Italy 2

University of Trieste, Trieste, Italy 3

University of Amsterdam, Amsterdam, the Netherlands

June 16, 2025

# A BSTRACT

Understanding the decision-making processes of large language models is critical given their widespread applications. To achieve this, we aim to connect a formal mathematical framework—zigzag persistence from topological data analysis —with practical and easily applicable algorithms. Zigzag persistence is particularly effective for characterizing data as it dynamically transforms across model layers. Within this framework, we introduce topological descriptors that measure how topological features, p -dimensional holes, persist and evolve throughout the layers. Unlike methods that assess each layer individually and then aggregate the results, our approach directly tracks the full evolutionary path of these features. This offers a statistical perspective on how prompts are rearranged and their relative positions changed in the representation space, providing insights into the system’s operation as an integrated whole. To demonstrate the expressivity and applicability of our framework, we highlight how sensitive these descriptors are to different models and a variety of datasets. As a showcase application to a downstream task, we use zigzag persistence to establish a criterion for layer pruning, achieving results comparable to state-of-the-art methods while preserving the system-level perspective.

# 1 Introduction

Large Language Models (LLMs) have revolutionized natural language processing by achieving unprecedented performance levels across a wide range of tasks (see [1] for a review). Despite their success, the black-box nature of these models has raised significant concerns about interpretability and transparency [2]. Moreover, their large scale demands a considerable amount of computational resources [3, 4], making it essential to reduce their size without compromising performance [5, 6, 7].

One strategy for addressing these issues has been to study the models’ internal representations. Early works [8] demonstrated that visualization techniques can effectively uncover hierarchical representations within convolutional neural networks, highlighting how lower layers focus on edge detection while higher layers correspond to object parts and semantic concepts. Additionally, [9] illustrated that analyzing weight matrices and neuron activations can reveal interpretable features and organizational structures within deep networks, providing insights into how complex patterns are encoded and processed.

More recently, geometric studies made progress by introducing concepts like intrinsic dimension to characterize the manifold of internal representations and its evolution across layers [10, 11, 12]. These methods have been successfully applied to transformer models in various works [13, 14, 15, 16, 17]. One notable achievement of this approach has been to show the emergence of semantic knowledge and abstraction phases in the middle layers of models, rather than at the final layers, as might be intuitively expected.

∗ These authors contributed equally to this work.

† Correspondence: matteo.biagetti@areasciencepark.it
