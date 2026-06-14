[Page 18]

![The image is a scatter plot with a legend at the bottom right corner. The plot is titled Layers and has a legend at the top center. The legend is labeled Layers and has a color gradient from red to blue. The x-axis is labeled Layers and has a scale from 0 to 15. The y-axis is labeled Percentage and has a scale from 0 to 15. The plot is divided into three sections, each representing a different layer. The layers are represented by different colors, with the red layer representing Layer 0 and the blue layer representing Layer 1. The legend indicates that Layer 0 represents the first layer, Layer 1 represents the second layer, and so on. The plot is divided into three sections, each representing a different layer. The layers are represented by different colors, with the red layer representing Layer 0 and the blue layer representing Layer 1. The legend](<GVPB2025/imageFile6.png>)

Layer 13

Layer 20

Layer 6

Layer 32

Layer 0

Layer 27

Dec

Sept

May

Jan



Layers

Layer 0

Layer 6

Layer 13

Layer 20

Layer 27

Layer 32

Dec

Sept

May

Jan

15.0

12.5


5.0

2.5

0.0

Layers

Figure 5: Zigzag persistence analysis of calendar arithmetic tokens. Top panel: Month token representations exhibit persistent topological structure emerging at layer 5 and persisting until layer 14. The points are plotted with the first and second component of PCA, respectively X and Y axis. Bottom panel: Answer token representations show lateemerging persistent structure from layers 21-32, with the points plotted on the first and second component of PCA. For each panel, the upper half displays k -nearest neighbor graphs ( k = 2 ) for the 12 prompts across selected transformer layers, while the lower half shows the corresponding 1-dimensional persistence barcodes tracking topological feature evolution across all 33 layers. The red dotted lines in the barcode plots indicate the specific layers visualized in the upper half.

- Differential patterns: Different token types exhibit distinct persistence signatures.

This toy example illustrates the framework’s ability to visualize geometric structure evolution in transformer representations.

# D Combining the k NN graph with the Vietoris-Rips complex

The k-Nearest Neighbors ( k NN ) complex is built by expanding the corresponding k NN graph to a fixed dimension m . A key limitation of the k NN complex is that it ranks points by proximity without considering their actual distances. As a result, once k is fixed on each layer, each point is connected to its k-Nearest Neighbors, regardless of the absolute distances involved. In our setting, the number of connected components (the Betti 17 number β 0 ) of the k NN complexes as a function of the layers tends to be unity, i.e. the whole complex is connected, even for relatively small values of k NN ≳ 6 . This implies that connected components contain no useful topological information on the internal representations.
