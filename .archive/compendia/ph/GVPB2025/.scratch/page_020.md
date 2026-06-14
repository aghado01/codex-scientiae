[Page 20]

![The image is a bar graph depicting the relationship between two variables, specifically the birth rate and the death rate. The x-axis represents the birth rate, ranging from 0 to 100, while the y-axis represents the death rate, ranging from 0 to 100. The graph is divided into four sections, each representing a different birth rate and death rate. The birth rate is represented by a blue bar, which is higher than the death rate. The birth rate is shown as a solid blue line, while the death rate is shown as a dashed blue line. The birth rate is shown as a solid blue line, while the death rate is shown as a dashed blue line. The graph also includes two additional bars, one for each of the two variables. The first bar is blue and represents the birth rate, while the second bar is red and represents the death rate. The graph is labeled with the names of the variables, which](<GVPB2025/imageFile8.png>)

Llama 2 7B vs. Llama 3 8B

Llama 2 7B vs. Mistral

Llama 2 7B vs. Pythia

100

100

100




10-1

10-1

10-1

10-2

10-2

10-2










10-;

10-2




10-1

~10-1

~100

~100

100



















Birth Layer (lbirth)

Birth Layer (Ebirth)

Birth Layer (Lbirth)

Llama 3 8B vs. Mistral

Llama 3 8B vs. Pythia

Mistral vs. Pythia


100

100




10-1

10-1

10-1

10-2

10-2

10-2













~10-2

10-1

10-1

~10-1

~100

~100

~100

















Birth Layer (lbirth)

Birth Layer (Zbirth)

Birth Layer (Ebirth)

Figure 7: Element-wise difference of effective persistence image calculated for Llama 2, Llama 3, Mistral and Pythia on the SST dataset. The color bar indicates a normalized difference between − 1 and 1 , on a logarithmic scale.

# E.2 Larger Models

We verify that our topological descriptors exhibit the same qualitative results for larger models, namely Llama 2 13B, Llama 2 70B and Llama 3 70B, using the SST dataset. We show the births’ relative frequency and inter-layer persistence in Figure 8 in the left and right panels, respectively. As a representative value, we choose a weight of α = 0 for both descriptors, which gives equal weight to shortand long-lived features.

# E.3 Varying Datasets

We test our topological descriptors on 4 different datasets, as presented in Section 4. As a reference, we consider the Llama 3 8B model and choose α = 0 as weight for both the births’ relative frequency and inter-layer persistence. We show results averaged over subsets of size 500 points in Figure 9. We note qualitative similarity for both descriptors across all datasets, though quantitative differences can clearly be seen especially for inter-layer persistence. Interestingly, we observe that the code dataset has a slight divergent behaviour in middle layers. To investigate this further, we filter the Code dataset for 5 programming languages with different levels of verbosity (C, Java, HTML, Markdown, Python) and for each one we extract 10K prompts. We then calculate the inter-layer persistence for α = − 1 and α = 2 for these datasets so as to highlight separately shortand long-lived features. In this case, we average over 8 subsets of size 1000 for computational convenience. We show results in Figure 10. From these calculations, we gather that most programming languages generally exhibit a drop in the amount of short-lived features in the middle layer, the effect being more visible for verbose codes (java, C). This feature is not seen for other types of datasets. These results deserve further investigation, which we leave to future work.

# E.4 Results as a Function of Varying Subsets

Here we show that our topological descriptors show consistent results across various subset sizes. While the variance increases for smaller subsets, descriptors computer over different subset sizes are within a standard deviation. We
