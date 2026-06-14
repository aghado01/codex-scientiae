## 5.4 Neural network training dynamics

We next consider the training dynamics of neural networks as a high-dimensional, non-physical system in which collective organization emerges in the space of parameters or learned representations. While no explicit spatial interactions are prescribed, stochastic gradient-based optimization induces an evolving geometry whose structure can be probed using topological methods.

We focus on supervised image classification tasks, where a neural network implements a parametric mapping

$$
f _ { \theta } \colon \mathcal { X } \rightarrow \mathcal { Y } ,
$$

with parameters $\theta \in \mathbb{R}^P$ optimized by minimizing an empirical loss function

$$
\mathcal { L } ( \theta ) & = \frac { 1 } { | \mathcal { D } | } \sum _ { ( x , y ) \in \mathcal { D } } \ell ( f _ { \theta } ( x ) , y ) , \\
$$

using stochastic gradient descent or adaptive variants. Training proceeds iteratively, producing a sequence of parameter values $\{ \theta(t) \}_{t \ge 0}$, where $t$ denotes the optimization step or epoch. Algorithm 2 summarizes the procedure used to compute persistent entropy from neural network training dynamics, treating training as a stochastic process and using metric embeddings of network parameters or representations to construct time-dependent persistence diagrams. Algorithm 2 was implemented as a Python notebook and executed on Google Colab; the code will be made publicly available.

Unlike classical physical models, neural network training does not admit a priori order parameters describing the internal organization of representations. Performance metrics such as accuracy provide only indirect information about the geometry induced by learning. Our goal is therefore to characterize the emergence of organized internal structure through topological observables derived from persistent homology.

### 5.4.1 Neural networks: experimental setup

We performed a systematic numerical study across multiple datasets and architectures, including DIGITS, MNIST, Fashion-MNIST, and CIFAR-10, using multilayer perceptrons (MLPs) and convolutional neural networks (CNNs). For each dataset, we considered architectures of increasing representational capacity and inductive bias. Fully connected models consisted of feedforward MLPs with one or two hidden layers (denoted MLP1 and MLP2), using ReLU nonlinearities and trained end-to-end on flattened input images. Convolutional models followed a standard CNN design with alternating convolutional and pooling layers, followed by one or more fully connected layers, thereby explicitly encoding spatial locality and weight sharing. Note that, for the DIGITS dataset, we restricted the analysis to fully connected architectures (MLP1 and MLP2) and did not include convolutional models. This choice is motivated by the low intrinsic complexity of the task: DIGITS images are low-dimensional, grayscale, and exhibit strong global structure with limited
