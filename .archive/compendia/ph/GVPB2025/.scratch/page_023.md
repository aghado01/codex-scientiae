[Page 23]

![The image is a scatter plot with two sets of data points. The x-axis is labeled Subsets Size and the y-axis is labeled Interlayer Perience. The data points are represented by blue dots. The x-axis is labeled Subsets Size and the y-axis is labeled Interlayer Perience. The data points are plotted on a linear scale of range 0 to 1000000. The scatter plot is titled Interlayer Perience Variance. The title is written in a sans-serif font. The x-axis is labeled Subsets Size and the y-axis is labeled Interlayer Perience. The data points are plotted on a linear scale of range 0 to 1000000. The scatter plot is labeled as Layer 3. The title is written in a sans-serif font. The x-axis is labeled](<GVPB2025/imageFile13.png>)

Layer 3

0.00016

02,

02 & N2

0.00014

0.0008

0.00012


0.0006

0.00010

0.00008

0.0004

0.00006



0.00004

0.0002

0.00002

0.0000

400

600

1000

200

800

Subsets Size

Layer 23

0.0010



0.0008

0.0008

0.0006

0.0006

200

Layer 15

02,

N1.5

400

600

Subsets Size

Layer 32

800

1000

02 *

0.0004


0.0002

0.0000

200

400

600

Subsets Size

800

0.0004


0.0002

1000

0.0000

200

400

600

Subsets Size

800

1000

Figure 12: Variance of the inter-layer persistence with weight α = 0 for the Llama 3 8B model computed on the SST dataset as a function of subset sizes. We show four different layers: 3 , 15 , 23 and 32 . The black dashed lines represent a fitting function.

# G More on Pruning

# G.1 Sliding Window on Other Benchmarks

We can test the sliding window experiments on the other two benchmarks, MMLU and Hellaswag, show in Figures 17 and 16, respectively.

For the case of MMLU, we zoom in on the drop in performance seen at the end of the third phase: we show the performance of the MMLU benchmark against block sizes of 5, 3, and 2 adjacent layers with sliding windows of 2, 1 and 1 for the left, middle and right panels, respectively. We see that performance is at the level of random choice during the increasing phase and it maximizes close to the maximum Inter-Layer Persistence during the plateau phase. Consistently with the Winogrande benchmark, we see a drop in performance right in correspondence with
