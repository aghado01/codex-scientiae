[Page 22]

- Figure 1.1 Examples of hand-written digits taken from US zip codes.


|![image 5](../../../../../images/imageFile5.png)|
|---|


|![image 6](../../../../../images/imageFile6.png)|
|---|


|![image 7](../../../../../images/imageFile7.png)|
|---|


|![image 8](../../../../../images/imageFile8.png)|
|---|


|![image 9](../../../../../images/imageFile9.png)|
|---|


|![image 10](../../../../../images/imageFile10.png)|
|---|


|![image 11](../../../../../images/imageFile11.png)|
|---|


|![image 12](../../../../../images/imageFile12.png)|
|---|


|![image 13](../../../../../images/imageFile13.png)|
|---|


|![image 14](../../../../../images/imageFile14.png)|
|---|


tackled using handcrafted rules or heuristics for distinguishing the digits based on the shapes of the strokes, but in practice such an approach leads to a proliferation of rules and of exceptions to the rules and so on, and invariably gives poor results.

Far better results can be obtained by adopting a machine learning approach in which a large set of N digits {x1,...,xN} called a training set is used to tune the parameters of an adaptive model. The categories of the digits in the training set are known in advance, typically by inspecting them individually and hand-labelling them. We can express the category of a digit using target vector t, which represents the identity of the corresponding digit. Suitable techniques for representing categories in terms of vectors will be discussed later. Note that there is one such target vector t for each digit image x.

The result of running the machine learning algorithm can be expressed as a function y(x) which takes a new digit image x as input and that generates an output vector y, encoded in the same way as the target vectors. The precise form of the function y(x) is determined during the training phase, also known as the learning phase, on the basis of the training data. Once the model is trained it can then determine the identity of new digit images, which are said to comprise a test set. The ability to categorize correctly new examples that differ from those used for training is known as generalization. In practical applications, the variability of the input vectors will be such that the training data can comprise only a tiny fraction of all possible input vectors, and so generalization is a central goal in pattern recognition.

For most practical applications, the original input variables are typically preprocessed to transform them into some new space of variables where, it is hoped, the pattern recognition problem will be easier to solve. For instance, in the digit recognition problem, the images of the digits are typically translated and scaled so that each digit is contained within a box of a ﬁxed size. This greatly reduces the variability within each digit class, because the location and scale of all the digits are now the same, which makes it much easier for a subsequent pattern recognition algorithm to distinguish between the different classes. This pre-processing stage is sometimes also called feature extraction. Note that new test data must be pre-processed using the same steps as the training data.

Pre-processing might also be performed in order to speed up computation. For example, if the goal is real-time face detection in a high-resolution video stream, the computer must handle huge numbers of pixels per second, and presenting these directly to a complex pattern recognition algorithm may be computationally infeasible. Instead, the aim is to ﬁnd useful features that are fast to compute, and yet that
