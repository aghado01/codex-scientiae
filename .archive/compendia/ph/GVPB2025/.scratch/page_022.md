[Page 22]

![The image is a line graph that shows the inter-layer persistence over a series of layers. The x-axis represents the layer, and the y-axis represents the inter-layer persistence. The graph has a linear scale of range 0.0 to 30 on the x-axis, and a linear scale of range 0.0 to 30 on the y-axis. The graph has a few key features: 1. **Title**: The title of the graph is Inter-Layer Persistence. 2. **Legend**: The legend on the right side of the graph is labeled Inter-Layer Persistence. It consists of five colors: - **Blue**: This color represents the inter-layer persistence. - **Purple**: This color represents the inter-layer persistence. - **Orange**: This color represents the inter-layer persistence. - **Yellow**: This color represents the inter-layer persistence.](<GVPB2025/imageFile11.png>)

HTML

0.06

Java

Markdown

0.05

0.4

Python

0.04

0.3



0.03

0.2

0.02

0.01

0.1

0.00

0.0







Layer

HTML

Java

Markdown

Python




Layer



Figure 10: Inter-Layer Persistence for weights α = − 1 (left panel) and α = 2 (right panel) as a function of model layers for Llama 3 8B for a range of programming languages, averaged over 8 subsets of size 1000 .

![The image is a line graph that shows the frequency of births in a population over a range of layers. The graph has a legend at the top, which indicates the different layers: N=100, N=250, N=500, N=1000, and N=1000. The x-axis is labeled Layer, and the y-axis is labeled Births Relative Frequency. The graph shows the following data points: 1. **N=100**: The graph shows a peak in the frequency of births at Layer 3. 2. **N=250**: The graph shows a peak in the frequency of births at Layer 3. 3. **N=500**: The graph shows a peak in the frequency of births at Layer 3. 4. **N=1000**: The graph shows a peak in the frequency of births at Layer](<GVPB2025/imageFile12.png>)

0.08

N=10o

0.30

N=250

0.07

N=500

0.06


N=10oo

0.25

0.05

0.20

0.04


0.02

0.10

0.01

0.05

Llama 3 8B

0.00







Layer

N=10o

N=250

N=500

N=10oo

Llama

3 8B




Layer



Figure 11: Births’ relative frequency (left) and inter-layer persistence (right) with weight α = 0 for the Llama 3 8B model computed on the SST dataset for different subset sizes as a function of model layers.

# E.5 Additional result across models

In this section we present supplementary evidence of the consistency of the results across models for our descriptors, effective persistence, Births’ Relative Frequency and Inter-Layer Persistence on Llama 2, Mistral, and Pythia, in Figure 13.

# F A shuffling test

As a test of our topological descriptors and the phases seen in Section 4, we perform a shuffling of tokens within the prompts of the SST dataset, as a way of destroying the structure and semantic coherence of the prompts, without modifying their unigram frequency distribution (see e.g. [16] for an application of shuffling to internal representations of transformers).

In Figures 14 and 15, we show the births' relative frequency and the inter-layer persistence for shuffled and structured prompts. For the former, we can see a clear difference in behavior on the birth of the long-lived features between the shuffled and structured cases, the peak at middle layers being higher for shuffled prompts. A reversed trend is seen for the inter-layer persistence. Overall, the frequency of births of short-lived features is not significantly affected by the shuffling, while the inter-layer persistence drops on the second half of the model's depth. These findings deserve further investigations, which we postpone to future work.
