[Page 8]

0.12

0.10

0.08

0.06

0.04

0.02

0.00

a = =1.0

a =0.0

a = 1.0

a = 2.0

Uniform Distribution

Llama 3 8B




Layer



![This is a graph. There are three lines on the graph. The x-axis is labeled Layer. The y-axis is labeled Interlude.](<GVPB2025/imageFile4.png>)

0.12

a = =1.00

0.5

a = 0.50

0.10


a = 2.00

0.4

0.08

0.3

0.06


0.2

0.04

0.1

0.02

Llama 3 8B

0.00






Layer

Llama 3 8B

Llama 2 7B

Pythia

Mistral




Layer



Figure 3: Left Panel: Births’ Relative Frequency, B 1 , as a function of model’s layers for Llama 3 8B on the SST dataset, for varying α , which traces short-(long-)lived features for negative(positive) values. Short-lived features peak early in the model and progressively decrease, while long-lived features peak in middle layers. All features experience a sharp growth in the last two layers. The dashed line represents a uniform distribution of births across the layers. Middle Panel: Inter-Layer Persistence as a function of model’s layers for Llama 3 8B on the SST dataset, for varying α . The persistence of short-lived features consistently grows and plateaus towards the end of the model, while longlived features are primarily present across middle layers. Right Panel: Inter-Layer Persistence for Llama 3, Llama 2, Mistral and Pythia for the SST dataset at α = 2 . The models considered exhibit qualitatively similar, but quantitatively different behavior, with Pythia experiencing the higher peak, and Mistral the lowest. This seems inversely related to model’s performance once pruning layers in this range. In all panels, curves and shaded regions represent the mean and standard deviation over 16 subsets of 500 prompts, respectively.

Inter-Layer Persistence. We show the power-weighted inter-layer persistence (Eq. equation 8) in the middle and right panel of Figure 3. In the middle panel, we use Llama 3 with the SST dataset at varying α = − 1 , 0 , 0 . 5 , 1 , 2 . As for B 1 , we can distinguish two behaviors for short-lived and long-lived features, though now ¯ Z 1 traces the probability of features that are alive at a given layer to be still alive in earlier or later layers. We see that for short-lived features, this probability grows steadily until the second half of the model’s depth, where it reaches a plateau, and then suddenly drops in the last few layers. On the other hand, for long-lived features, there is a peak in probability at the middle layers. We can qualitatively see the same behavior for the other models in the right panel of Figure 3, though with quantitative differences across models. We cross-check for other datasets in Appendix E.3, also finding qualitatively similar, but quantitatively different results across datasets.

# 4.3 Interpretation and implications for the model’s performance

In interpreting our results, it is essential to recognize that: 1) models process each token of the prompt, while we use only the last token as a proxy for the entire prompt; and 2) each prompt is processed separately from the others, such that each point moves a priori independently from the others in the representation space. Within this framework, the zigzag algorithm effectively tracks how the models dynamically organize prompts across both spatial and temporal dimensions (layers). Our findings, as illustrated in Figure 3, reveal four distinct phases:

- Early to Middle Layers: In the first layers, a large number of short-lived 1 -dimensional holes are formed, indicating that most prompts are fastly rearranged within a few layers. This finding relates with previous work identifying local contextualization [42] and increased dimensionality [13].
- Middle Layers: In this phase, 1 -dimensional holes born in middle layers have the highest probability of being long-lived than in other phases. This implies that relative positions before, but especially after these layers are kept relatively stable. This would seem related to the decreasing dimensionality found in [16], since relevant degrees of freedom estimated by intrinsic dimension are progressively better distinguishable and more stable to noise.
- Middle to Late Layers: Short-lived 1 -dimensional holes born after the first layers decrease in number. At the same time, the probability that a 1 -dimensional hole is short-lived increases until after the middle layers when it reaches a plateau. Concurrently, the probability (and the amount) of long-lived ones drops. This indicates a phase of relatively few short-lived adjustments in the relative positions of prompts since many of the features that formed in the middle layers are still there (because they are long-lived). We expect that these short-lived adjustments relate to a phase of specialization [42] and to a phase of relatively constant dimensionality [13].
