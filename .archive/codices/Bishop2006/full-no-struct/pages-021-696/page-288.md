[Page 288]

![The image is a diagram consisting of three main components: Input Image, Convolutional Layer, and Sub-sampling Layer. The diagram is labeled as follows: - Input Image: A square with a red square in the top left corner. - Convolutional Layer: A square with a red square in the top left corner. - Sub-sampling Layer: A square with a red square in the top left corner. The diagram is divided into three main sections: 1. **Convolutions**: The first section is labeled as Convolutions and contains a red square in the top left corner. 2. **Sub-sampling Layer**: The second section is labeled as Sub-sampling Layer and contains a red square in the top left corner. 3. **Convolutions**: The third section is labeled as Convolutions and contains a red square in the top left corner. ### Detailed Description: ####](../images/imageFile123.png)

Sub-sampling

Input image

Convolutional layer

layer

Figure 5.17 Diagram illustrating part of a convolutional neural network, showing a layer of convolutional units followed by a layer of subsampling units. Several successive pairs of such layers may be used.

These notions are incorporated into convolutional neural networks through three mechanisms: (i) local receptive ﬁelds, (ii) weight sharing, and (iii) subsampling. The structure of a convolutional network is illustrated in Figure 5.17. In the convolutional layer the units are organized into planes, each of which is called a feature map . Units in a feature map each take inputs only from a small subregion of the image, and all of the units in a feature map are constrained to share the same weight values. For instance, a feature map might consist of 100 units arranged in a 10 × 10 grid, with each unit taking inputs from a 5 × 5 pixel patch of the image. The whole feature map therefore has 25 adjustable weight parameters plus one adjustable bias parameter. Input values from a patch are linearly combined using the weights and the bias, and the result transformed by a sigmoidal nonlinearity using (5.1). If we think of the units as feature detectors, then all of the units in a feature map detect the same pattern but at different locations in the input image. Due to the weight sharing, the evaluation of the activations of these units is equivalent to a convolution of the image pixel intensities with a ‘kernel’ comprising the weight parameters. If the input image is shifted, the activations of the feature map will be shifted by the same amount but will otherwise be unchanged. This provides the basis for the (approximate) invariance of
