[Page 6]

Births’ Relative Frequency. A useful way to summarize a persistence diagram is by counting features within a specific region of interest. In our context, it is informative to measure the rate with which new \( p \)-dimensional holes are created, as this reflects the model’s propensity to move prompts toward each other in specific regions of space. We thus define the births’ relative frequencies as

$$
B _ { p } ( \ell ) = \frac { \sum _ { \ell _ { i } } \omega ( \ell , \ell _ { i } ) \widehat { P I } _ { p } ( \ell , \ell _ { i } ) } { \sum _ { \ell _ { i } } \omega ( \ell , \ell _ { i } ) \sum _ { \ell _ { i } } \widehat { P I } _ { p } ( \ell , \ell _ { i } ) } ,
$$

where

$$
\omega ( \ell , \ell _ { i } ) = | \ell - \ell _ { i } | ^ { \alpha }
$$

is a weight with varying exponent \( \alpha \). 6 For negative values of \( \alpha \), the average gives weight to counts with low death values, effectively tracing the fraction of short-lived features. On the other hand, positive values of \( \alpha \) give more weight to long-persistent features.

Inter-Layer Persistence. To better track the persistence of features across layers, we can calculate the fraction of \( p \)-dimensional holes in one layer, \( \ell_1 \), that exist in another layer, \( \ell_2 \), as well, and have existed throughout the layers in between. 7 Mathematically it can be expressed as

$$
\mathcal { Z } _ { p } ( \ell _ { 1 } , \ell _ { 2 } ) = \frac { \sum _ { \ell _ { 1 } \leq M _ { 1 } , \ell _ { 2 } > M _ { 2 } } \widehat { P I } _ { p } \left ( \ell _ { 1 } , \ell _ { 2 } \right ) } { \beta _ { p } ( \ell _ { 1 } ) } ,
$$

where \( M_1 = \min(\ell_1, \ell_2) \); \( M_2 = \max(\ell_1, \ell_2) \) and \( \beta_p(\ell) \) is the Betti number, i.e. the number of alive \( p \)-dimensional holes at layer \( \ell \). 8 We can then further summarize this quantity again by power-weighted averaging it,

$$
\bar { \mathcal { Z } } _ { p } ( \ell ) = \frac { \sum _ { \ell _ { i } = 1 } ^ { N _ { \text {layers} } } \omega ( \ell , \ell _ { i } ) \, \mathcal { Z } _ { p } ( \ell , \ell _ { i } ) } { \sum _ { \ell _ { i } = 1 } ^ { N _ { \text {layers} } } \omega ( \ell , \ell _ { i } ) }
$$

where we fix one of the two layers and average over all other layers, and the weight is the same as Eq. 6. Given that the birth or death of a given \( p \)-dimensional hole implies the rearrangements of points in space, \( \bar{\mathcal{Z}}_p \) tracks the dynamical movement of prompts’ relative positions in representation space as a function of the model’s depth.

# 4 Experiments

# 4.1 Models, Datasets and Benchmarks

We work with 4 models: Llama2 [66], Llama3 [67], Mistral [68] and Pythia 6.9B [69]. These models are opensource decoder-only transformers, and they achieve high performance in the benchmarks we consider in this work. We analyze Llama2-7B, Llama3-8B, Mistral 7B, and Pythia 6.9B because they have 32 hidden layers and have comparable parameter sizes. In Appendix E.2 we show results for larger models as a consistency check.

The input dataset from which we take internal representations must provide a fair test of how the model processes and understands language. We consider the following datasets: 1) The Standford Sentiment Treebank (SST) dataset [70]. 2) The Pile dataset [71] from which we take a subset of 10K prompts, accessible on HuggingFace. 9 3) A dataset of mathematical problems [72]. 4) A dataset of codes retrieved from GitHub. 10

Each prompt is processed from these datasets to extract the last token at each normalization layer and the final normalization is applied to the output layer. To ensure fair comparisons and eliminate potential biases in our descriptors caused by varying point cloud sizes, all datasets are reduced to the first 8,000 prompts. Additionally, we divide the datasets into incremental subsets of \( \{ 100, 200, \dots, 1000 \} \) prompts and compute the mean and standard deviation across subsets to systematically evaluate the scalability of our descriptors and to quantify their sensitivity to changes in point cloud size. For our experiments, we consider the 500 prompts subset, amounting to 16 subsets. In Appendix E.4 we

6 This type of weighting has been used previously for topological descriptors, see e.g. [63].

7 We note that this is related to the generalized rank invariants in the context of multiparameter and zigzag persistence [64, 65], which measures the rank of the homology maps between consecutive layers in a zigzag filtration. However, it differs in that it is normalized by the Betti number and explicitly enforces the continuity of holes throughout the intermediate layers.

8 Note that equation 7 is well-defined only when \( \beta_p(\ell) > 0 \). If there are no \( p \)-dimensional holes at either \( \ell_1 \) or \( \ell_2 \), \( \mathcal{Z}_p(\ell_1, \ell_2) \) should be 0 by definition. We omitted this limit case from equation 7 for readability.

9 https://huggingface.co/datasets/NeelNanda/pile-10k

10 https://huggingface.co/datasets/codeparrot/github-code
