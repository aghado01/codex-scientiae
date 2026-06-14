[Page 8]

![The image depicts a graph with a horizontal axis labeled L and a vertical axis labeled F. The graph is a line graph with a linear scale of range 0 to 100 on the x-axis and a linear scale of range 0 to 100 on the y-axis. The graph has a blue line that is drawn from the bottom left corner to the top right corner. The line is relatively straight, with no significant deviation from the horizontal and vertical axes. There are several points marked on the graph, which are labeled as follows: - The first point on the graph is marked with the letter L and is located at the bottom left corner. - The second point is marked with the letter I and is located at the top left corner. - The third point is marked with the letter J and is located at the top right corner. - The fourth point is marked with the letter K](<DS2026/imageFile4.png>)

Figure 4: A worm I (shaded) on a quasi zigzag bi-filtration where the direction of the inclusion on horizontal arrows are shown at the bottom and on the vertical arrows on left. The worm centered at (3,3) has width 1. The part of the boundary colored green is ∂ L I connecting the minima shown as green points and the part in purple is ∂ U I connecting the maxima shown as purple points. The boundary cap is shown in orange which runs parallel to the boundary for a portion of it. Refer to Figure 5 for the zigzag filtration along the boundary cap of the worm. A sequence of graphs with T = 3 time steps is shown with the corresponding graph filtrations: F t 1 , F t 2 , F t 3 each with L = 5 levels. The filtration of the unions are encircled by ovals. Zigzag filtration at the topmost level Z L is shown in a rectangular box.

![image 5](<DS2026/imageFile5.png>)

Figure 5: This is the zigzag filtration Z bdry along the boundary cap of the worm shown in Figure 4.

**Algorithm 1: Compute ZZ-GRIL**

```
Input:  ZZ — quasi zigzag bi-filtration; k ≥ 1; p
Output: λ(p, k) — ZZ-GRIL value at point p for fixed k

Initialize: δ_min ← 1, δ_max ← len(F), λ ← 1
while δ_min ≤ δ_max do
    δ ← (δ_min + δ_max) / 2
    I ← p²_δ;  r ← ComputeRank(ZZ, I)
    if r ≥ k then
        λ ← δ;  δ_min ← δ + 1
    else
        δ_max ← δ − 1
    end if
end while
return λ
```

## 5 Experiments

In this section, we report the results of testing ZZ-GRIL on various datasets. We begin by giving a detailed description about the experimental setup. Then, we give a brief description of the datasets, followed by the experimental results. We use the benchmark UEA multivariate time-series Bagnall et al. (2018) datasets to test ZZ-GRIL on multivariate time series data to show that ZZ-GRIL can be applied to datasets from various domains. Further, we test ZZ-GRIL on a targeted application of sleep-stage classification by performing experiments on ISRUC-S3 Khalighi et al. (2016) dataset. In all these experiments, we augment the topological information captured by ZZ-GRIL to one of the specifically tailored machine learning methods on the respective datasets and compare. For each case, we select the machine learning model which has the highest performance to truly test and highlight the value of the topological information added by ZZ-GRIL to an already high-performing specifically tailored model.
