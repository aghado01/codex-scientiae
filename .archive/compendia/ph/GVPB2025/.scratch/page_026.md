[Page 26]

![The image is a line graph that shows the percentage of people who have heard of a particular brand of beer. The x-axis represents the number of people who have heard of the brand, ranging from 0 to 100. The y-axis represents the percentage of people who have heard of the brand, ranging from 0 to 100. The graph shows that the percentage of people who have heard of the brand has been increasing over time.](<GVPB2025/imageFile17.png>)

# 5-block sliding window


Llama 3 8B

Llama 2 7B


Pythia


Mistral

random







30]

32]

10]

14]

20]

12]

22]

16]

26]

24]

28]

18]


[20

[14

[16

[18

[10

Figure 16: Hellaswag 5-shot benchmark run on Llama3 8B, Llama2 7B, Mistral and Pythia. A sliding window of size 5 is applied to cut blocks every 2 layers.

5-block sliding window

Llama 3 8B

Llama 2 7B

Mistral

random


[14 1

[10

[20_24]

[22_26]

[24_28]

![The image is a line graph that shows the percentage of people who have used the 5-block sliding window in the United States from 2000 to 2010. The graph is titled 5-block sliding window and is labeled as 2000-2010. The x-axis represents the years, and the y-axis represents the percentage of people who have used the 5-block sliding window. The graph shows a trend of increasing usage of the 5-block sliding window from 2000 to 2010. The percentage of people who have used the 5-block sliding window has increased from 2000 to 2010, with a peak in 2010. Here is a detailed description of the graph: - **X-axis (Years):** The x-axis represents the years, starting from 2000](<GVPB2025/imageFile18.png>)

3-block sliding window


Llama 3 8B

Llama 2 7B

Mistral

random


30]

32]

[23_25]

[27_29]

[29_31]

[24_26]

[25_27]



[30

2-block sliding window


Llama 3 8B

Llama 2 7B

Mistral

random

[27_28]

[26_27]



30]

32]

Figure 17: MMLU 5-shot benchmark run on Llama3 8B, Llama2 7B and Mistral. The different benchmarks shown are done by cutting blocks of layers with a fixed size and by changing the starting point with a sliding window. Left Panel : benchmark made with a block size of 5 and sliding windows of 2, Middle Panel : benchmark made with block size of 3 and sliding windows of 1, Right Panel : with a block size of 2 and sliding window of 1.



| [18-28] |
|---|




Table 2: Table with the With a given N prune we show the layers cut with our method and for the Angular Distance and the Bi Score (Other works).
