[Page 9]

- Last Layers: In the last two to three layers, the births’ relative frequency grows rapidly while the inter-layer persistence drops. These two behaviors are compatible, given that the fraction of newborn 1 -dimensional holes is large, and that there are no layers left to persist. This results suggest another strong rearrangement of points, which can be linked to the model producing the required output [13, 42] and thus changing abruptly the position of prompts in representation space.

![The image is a line graph that shows the distribution of the number of blocks in a certain area. The x-axis represents the number of blocks, while the y-axis represents the number of blocks. The graph is labeled 5-block sliding window. The graph shows a general trend of decreasing numbers of blocks as the number of blocks increases. The number of blocks decreases from the bottom of the graph to the top, with a sharp increase in the top of the graph. There are several key points in the graph: 1. **Initial Data**: The graph starts with a small number of blocks, around 2-3 blocks. This is followed by a gradual increase, with the number of blocks increasing from 2-3 blocks to 5-6 blocks. 2. **Initial Decline**: The number of blocks starts to decrease, with the number of blocks decreasing from 2-3 blocks to 5-6 blocks. This is followed by a sharp](<GVPB2025/imageFile5.png>)

5-block sliding window


Llama

3 8B

Llama 2 7B


Pythia

Mistral


random







{



30]

20]

22]

14]

32]

10]

12]

18]

24]

28]

[12_16]



[10

[24

[16

[18

[20

[14

Figure 4: Winogrande performances for 4 models obtained with a sliding window of 5 blocks of adjacents layers and moved through the models every 2 layers. This experiment reflects 4 phases: 1) removing early layers brings performances close to random choice, 2) while performance grows to almost maximum after middle layers, and 3) plateaus; 4) removing late layers causes another drop in performance right before the end of the model.

Relation to model’s performance. As a test of the interpretation of the 4 phases, we perform the following experiment: we prune blocks of layers with a sliding window from early to late layers as a way to compare the relative importance of layers in the various phases. We show the results of the experiment in Figure 4, where we show the performance of the 4 models considered for the Winogrande benchmark, as a function of the sliding window of pruned layers. We see that removing layers in the first phase significantly affects performance. After the second phase, pruning weakly affects performance, being a phase of relative adjustments. Removing the last few layers causes another drop in performance. Interestingly, the overall performance of models is inversely related to the peak height of the inter-layer persistence of long-lived features. This relation is seen also in the other limit of α < 0 . We also notice that the two best-performing models, Mistral and Llama, 3 exhibit a drop in performance when removing layers at the end of the third phase, right before the fourth. We zoom in on these layers for the MMLU benchmark where the drop is particularly evident in Appendix G.1, confirming that the drop is caused by removing the last 2-3 layers of the third phase. Importantly, all these results are qualitatively the same across the three benchmarks considered in this work.

# 4.4 Layer Pruning

Recently, measures of layer similarity have been used to identify layers that contribute minimally to the performance of LLMs. These layers can be pruned, and the performance re-evaluated to validate this assumption. Given our results in Figure 4, we can argue that layers belonging to the third phase might be pruned without affecting for model’s performance. Consequently, we establish a pruning criterion based on the plateau observed in the inter-layer persistence of short-lived features. Specifically, we prune layers that lie within 10% of the maximum value of ¯ Z 1 . This is computed for each different model, using the Pile dataset as proxy. 11 We show a schematic summary of the algorithm in Appendix G.2.
