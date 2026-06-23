[Page 1]

# Mathematical Foundations of Geometric Deep Learning

Haitz S´ aez de Oc´ ariz Borde and Michael Bronstein

University of Oxford

We review the key mathematical concepts necessary for studying Geometric Deep Learning [3]. For a deeper understanding of specific topics, we encourage supplementing studies with additional resources.

# Introduction

Since the dawn of civilization, humans have tried to understand the nature of intelligence. With the advent of computers, there have been attempts to emulate human intelligence using computer algorithms – a field that was dubbed ‘Artificial Intelligence’ or ‘AI’ by the computer scientist John McCarthy in 1956 and has recently enjoyed an explosion of popularity. Many efforts in AI research have focused on the study and replication of what is considered the hallmark of human cognition, such as playing intelligent games, the faculty of language, visual perception, and creativity. While at the time of writing we have multiple successful takes at the above – computers nowadays play chess and Go better than any human, can translate English into Chinese without a dictionary, automatically drive a car in a crowded city, and generate poetry and art that wins artistic competitions – it is fair to say that we still do not have a full understanding of what human-like or ‘general’ intelligence entails and how to replicate it.

Most of the aforementioned examples of AI are powered by Deep Learning, a class of algorithms whose history can be traced back to attempts in the early 20th century to replicate the connectivity and functioning of biological neurons in the brain in computers in a very abstract manner. Such systems are called (artificial) neural networks, by analogy to their biological counterparts, and consist of computational units called neurons, which are typically organized into multiple layers (the term ‘deep’ in Deep Learning refers to neural networks with many such layers). Neurons have parameters that can be tuned for a specific task in an optimization procedure referred to as ‘learning’. A subfield of AI studying mathematical methods for the design and optimization of such systems is called Machine Learning (ML).

Deep Learning is an umbrella term for Machine Learning algorithms that rely on artificial neural networks typically consisting of a large number of layers.

These notes were originally developed by Haitz S´ aez de Oc´ ariz Borde for the ANAIS 2024 Geometric Deep Learning course in Kathmandu, Nepal. They are based on Michael Bronstein’s notes for the 2019 Computer Vision and Pattern Recognition course [1] at USI Lugano, Switzerland, as well as lecture slides from the 2024 Geometric Deep Learning course [2] at the University of Oxford, United Kingdom.

The Perceptron, introduced by Frank Rosenblatt in 1957, is perhaps the simplest form of an artificial neural network, consisting of only a single artificial neuron. Modern neural networks can contain millions of neurons with billions of weights.

![image 1](<BordeBronstein2025/imageFile1.png>)

[Page 2]

# What is Geometric Deep Learning?

In recent years, there has been a rapid proliferation of various artificial neural network architectures, each suggesting different connectivity patterns and internal computations to be performed by the learning systems.

Geometric Deep Learning is a subfield of Deep Learning [5, 6] that focuses on developing artificial neural networks for data with non-Euclidean structures, such as graphs and manifolds. Traditional deep learning models, operate on grid-like data (e.g., images, time series, text), but many real-world problems involve more complex, irregular geometries. In particular, the field focuses on analyzing neural networks based on the geometric priors they leverage. Different models combat the curse of dimensionality by modeling signals on domains endowed with symmetry groups, which serve as inductive biases for the network.

Geometric Deep Learning provides a structured approach to incorporating prior knowledge of physical symmetries into the design of new neural network architectures, while also unifying and understanding successful existing models under a common framework.

![In this image there are four animals. One is a goat, another is a lion, another is a buffalo and the last one is a snake.](<BordeBronstein2025/imageFile2.png>)

CNN

GNN

DeepSets

RNN

{transformgr

Figure 1: In the spirit of the Erlangen Program, Geometric Deep Learning provides a geometric unification of the zoo of Deep Learning architectures.

In this text, we will not focus directly on (Geometric) Deep Learning and artificial neural networks. Instead, our objective is to provide the necessary preliminary mathematical background often overlooked in standard computer science curricula.

In the early 2020s there has been a clear convergence towards Transformer-based architectures across data modalities [4].

Imposing inductive biases in learning systems becomes particularly important in data-scarce regimes. While modern Deep Learning is only loosely rooted in biological neural networks, some architectural choices, such as the inductive biases of Convolutional Neural Networks (CNNs), are directly inspired by the workings of the visual cortex.

![image 3](<BordeBronstein2025/imageFile3.png>)

hom bnlr

This inspiration can be traced back to the experiments of Hubel and Wiesel.

In his landmark work known as the Erlangen Program, Felix Klein proposed that geometry should be approached as the study of invariants or symmetries. His vision offered a unifying framework at a time when the development of various non-Euclidean geometries had led to a fragmented mathematical landscape. Geometric Deep Learning adopts a similar perspective for understanding artificial neural network architectures by analyzing the symmetries and invariances they exploit.

![image 4](<BordeBronstein2025/imageFile4.png>)

elliptic

affine

[Page 3]

# Contents

|1 Algebraic Structures and Mathematics before Numbers| | |4|
|---|---|---|---|
| |1.1|Sets, Maps, and Functions . . . . . . . . . . . . . . . .|4|
| |1.2|Groups . . . . . . . . . . . . . . . . . . . . . . . . . . .|10|
| |1.3|Vector Spaces . . . . . . . . . . . . . . . . . . . . . . .|16|
|2|Analytical Structures| |20|
| |2.1|Norms and Normed Vector Spaces . . . . . . . . . . . .|20|
| |2.2|Metrics Induced by Norms and Metric Spaces . . . . . .|21|
| |2.3|The Inner Product and Inner Product Spaces . . . . . . .|23|
|3|Vector calculus| |26|
| |3.1|(Lipschitz) Continuity, Differentiability, and Smoothness|26|
| |3.2|Scalar Fields, Vector Fields, and Signals . . . . . . . . .|27|
| |3.3|Derivatives and Gradients . . . . . . . . . . . . . . . . .|28|
| |3.4|. . . . . . . . . . . . . . . . . . . . . . . .|30|
| |3.5|Divergence . . . . . . . . . . . . . . . . . . . . . . . .|31|
| |3.6|Laplacian . . . . . . . . . . . . . . . . . . . . . . . . .|33|
| |3.7|Gradient Descent Optimization in DL . . . . . . . . . .|33|
|4|and Differential Geometry| |37|
| |4.1|A Brief Introduction to Topology . . . . . . . . . . . . .|37|
| |4.2|Topological Equivalences . . . . . . . . . . . . . . . . .|40|
| |4.3|Manifolds and Differential Geometry . . . . . . . . . . .|41|
| |4.4|The Manifold Hypothesis . . . . . . . . . . . . . . . . .|49|
|5|Functional Analysis| |51|
| |5.1|Cauchy Sequences and Banach Spaces . . . . . . . . . .|51|
| |5.2|Hilbert Spaces . . . . . . . . . . . . . . . . . . . . . . .|52|
| |5.3|Operators and Functionals . . . . . . . . . . . . . . . .|53|
|6|Spectral Theory| |55|
| |6.1|Eigenfunctions and Eigenvalues . . . . . . . . . . . . .|55|
| |6.2|Fourier analysis . . . . . . . . . . . . . . . . . . . . . .|61|
|7|Graph Theory| |65|
| |7.1|Preliminaries on Graphs and Notation . . . . . . . . . .|65|
| |7.2|Group Theory and Graphs . . . . . . . . . . . . . . . .|72|
| |7.3|Vector Fields on Graphs . . . . . . . . . . . . . . . . . .|74|


[Page 4]

# 1 Algebraic Structures and Mathematics before Numbers

In this section, we study pre-numerical structures that are fundamental to understanding Geometric Deep Learning. Structures such as sets and maps allow us to mathematically describe collections of objects, the connections between them, and the operations that can be performed on them [7]. A key focus is on groups, which are used in Geometric Deep Learning to model the transformations of the data.

# 1.1 Sets, Maps, and Functions

At first glance, numbers may appear as the most elementary objects in mathematics. However, it is possible to identify even simpler and more basic structures. Indeed, numbers can be added, subtracted, multiplied, and so on, which requires a set of rules defining how these operations are done. But what if we consider just a collection of objects, stripped off any additional assumptions about them?

A set is a collection of distinct objects, called elements or members of the set.

These elements can be anything: numbers, symbols, or even other sets. What characterizes a set is that it does not allow for a repetition of elements (i.e., every element appears only once in a set) , and the order in which elements appear does not matter (i.e., sets are unordered ). Sets are the basis for defining more complex mathematical structures.

They are typically denoted by capital letters, such as A , B , X , etc. The members of a set are listed inside curly braces {} , and if an element x belongs to a set A , we write x ∈ A , which reads as ‘ x is an element of A ’. If x does not belong to A , we write x / ∈ A . For instance, if A = { 1 , 2 , 3 } , then 2 ∈ A , but 4 / ∈ A .

# Examples of Sets

- • ∅ : The empty set, a set with no elements. It is denoted by ∅ or sometimes by {} .
- • Singleton Set : A set with exactly one element, for example, { 1 } .
- • N = { 1 , 2 , 3 ,... } : The set of natural numbers. The ellipsis ... indicates that the set continues indefinitely with positive integers.


• Z = { ..., − 3 , − 2 , − 1 , 0 , 1 , 2 , 3 ,... } : The set of integers, which includes positive numbers, negative numbers, and zero.

- • Q =   p q | p ∈ Z ,q ∈ N   : The set of rational numbers, which are numbers that can be expressed as a ratio of two integers.
- • R : The set of all real numbers, including both rational numbers (e.g., 1 , 0 . 75 , − 3 ) and irrational numbers (e.g., π, √ 2 ).
- • C : The set of all complex numbers, which can be written as a + bi , where a and b are real numbers and i is the imaginary unit with i 2 = − 1 .


The elements of a set are not restricted to being numbers; they could also be English words, for instance: { cat , dog } .

A multiset is a set in which elements are allowed to appear more than once. Multisets are common in Geometric Deep Learning in the context of Graph Neural Networks (GNNs) [8], where they are used to model the neighborhood of a node in the graph.

A non-example would be the collection of all sets: there is no set containing all sets.

In some textbooks N may include 0.

The notation Z for integers comes from the German Zahlen , which means ‘numbers’.

[Page 5]

# Set Notation and Operations

• Set Builder Notation : Set builder notation is used to describe a set by specifying an expression or the general form of an element, followed by a vertical bar separator | , and, to its right, a rule that the expression on the left must satisfy.

{ x | f ( x ) } = { expression | rule satisfied by the expression } .

In words, it can be read as ‘ x such that (for which) f ( x ) ’.

• Subset : A set A is a subset of a set B , written A ⊆ B , if every element of A is also an element of B . If A ⊆ B but A ̸ = B , we say that A is a proper subset, written A ⊂ B .

̸

- • Union : The union of two sets A and B , written A ∪ B , is the set of all elements that are in A , in B , or in both.
- • Intersection : The intersection of two sets A and B , written A ∩ B , is the set of all elements that are in both A and B .
- • Difference : The difference of two sets A and B , written A \ B , is the set of all elements that are in A but not in B .
- • Complement : The complement of a set A , written A c , is the set of all elements not in A , assuming a universal set U that contains all elements under consideration.
- • Power Set : The power set of a set A , denoted P ( A ) , is the set of all subsets of A , including the empty set and A itself.
- • Cardinality : The cardinality of a set is the size or number of elements it contains. If a set is finite, its cardinality is a non-negative integer. For infinite sets, cardinality is definited more abstractly: two infinite sets are said to have the same cardinality if there exists a bijection between their elements. The cardinality of a set A is denoted by | A | or sometimes #( A ) .


Examples of Set Builder Notation We provide some examples to build an intuitive understanding. We start with the set builder notation. Below, we show that there are multiple ways to specify a set containing natural even numbers:

$$
\{ 2 x | x \in \mathbb { N } \} = \{ x \in \mathbb { N } | x \text { is even} \} = \{ 2 , 4 , 6 , 8 , \dots \} .
$$

Alternatively, sometimes the rule that must be satisfied by the elements of the set could be an equation:

$$
\{ x \in \mathbb { Z } | x > 0 \} = \mathbb { N } ,
$$

$$
\{ x \in \mathbb { Q } | x ^ { 2 } = 2 \} = \emptyset .
$$

In the last example, the solutions to the equation x 2 = 2 are the roots x = ± √ 2 , which are irrational numbers and, therefore, not elements of Q . Thus, the rule has no satisfying elements, meaning we have found a convoluted way of describing the empty set.

Sometimes a colon is used instead of a vertical line:

$$
\{ x \colon f ( x ) \} .
$$

The cardinality of N is denoted by the Hebrew letter ℵ 0 , which reads as aleph-nought or aleph-zero . This is the ‘smallest’ type of infinity and represents the size of any countable infinite set, which is a set that can be placed in a one-to-one correspondence (bijection) with N . For example, even though they might appear ‘larger’ at first glance, the sets Z and Q also have cardinality ℵ 0 since they are countably infinite.

[Page 6]

Examples of Finite Sets and Simple Operations Next, let us consider the finite sets B = { 1 , 2 , 3 , 4 , 5 } , A = { 1 , 2 , 3 } , C = { 1 , 2 , 3 , 4 , 5 } , then C ⊆ B and A ⊂ B . This is because A ̸ = B , whereas C = B . Their cardinalities would be | A | = 3 , | B | = 5 , and | C | = 5 . The unions and intersections in this example are C ∪ B = C ∩ B = C = B , A ∪ B = B , and A ∩ B = A . Another interesting example is the cardinality of the empty set |∅| = 0 and the cardinality of the singleton set containing the empty set |{∅}| = 1 .

̸

Examples of Infinite Sets and Simple Operations Consider the infinite sets N = { 1 , 2 , 3 , 4 , 5 ,... } and E = { 2 , 4 , 6 , 8 ,... } , the set of natural numbers and even natural numbers, respectively. Unsurprisingly, E ⊂ N since every element of E is an element of N . However, unlike finite sets, the cardinalities of N and E are equal , denoted as | N | = | E | = ℵ 0 . This is due to the fact that there exists a bijection between N and E (we will explain bijections in more detail soon). One such bijection f : N → E can be defined as f ( n ) = 2 n . For every natural number n ∈ N , f ( n ) produces a unique element of E , and every element of E is hit exactly once. For example: f (1) = 2 , f (2) = 4 , f (3) = 6 , ... Hence, despite E being a proper subset of N , their infinite cardinality remains the same.

In terms of other operations: E ∪ N = N , E ∩ N = E and N \ E = { 1 , 3 , 5 , 7 ,... } . Notably, the cardinality of the set containing, for instance, the infinite sets R and N is actually |{ R , N }| = 2 , since the set only contains two elements, despite the elements themselves being infinite.

Sets in Geometric Deep Learning and Graph Neural Networks. In Geometric Deep Learning, we are often interested in modeling signals on collections of nodes, edges, and patches on a manifold, for instance. As we will see later in Section 7, in the context of GNNs, the geometric domain is defined as a graph G = ( V,E ) , which is a tuple consisting of a set of nodes V and a set of edges E . Similarly, to model the neighborhood of a node, multisets (sets that allow repetition of elements) are used.

Cartesian Products After introducing sets and some basic operations, let us define the Cartesian product. Although the concept may initially seem abstract, it plays an important role in discussing manifolds and constructing more complex spaces by combining elements from simpler subspaces. The Cartesian product is used to model composite systems and relations between elements of two or more sets.

The Cartesian product of two sets A and B , denoted by A × B , is the set of all ordered pairs ( a,b ) where a ∈ A and b ∈ B :

$$
A \times B = \{ ( a , b ) \ | \ a \in A , b \in B \} .
$$

For instance, let A = { 1 , 2 } and B = { b 1 ,b 2 } . Their product A × B is:

$$
A \times B = \{ ( 1 , b _ { 1 } ) , ( 1 , b _ { 2 } ) , ( 2 , b _ { 1 } ) , ( 2 , b _ { 2 } ) \} .
$$

The Hilbert Hotel with infinitely many rooms that are fully occupied can host an infinite number of new guests by moving the old ones into even-numbered rooms and placing the new ones into odd-numbered rooms.

If there exists a one-to-one correspondence between two infinite sets, although we cannot say that they have the same number of elements, we think of them as having the “same size”. This intuition is formalized in set theory by defining two sets A and B to be equipotent (or having the same power ), if there is a one-to-one correspondence from A

correspondence from to B .

The term Cartesian product comes from the Cartesian coordinate system, which in turn is named after the French philosopher and scientist Ren´ e Descartes. Descartes’s name was Latinized to Renatus Cartesius, hence the adjective Cartesian .

[Page 7]

We can also represent it as a table:

$$
\frac { A \times B } { 1 } \left | \begin{array} { c | c } b _ { 1 } & b _ { 2 } \\ ( 1 , b _ { 1 } ) & ( 1 , b _ { 2 } ) \\ 2 & ( 2 , b _ { 1 } ) \end{array} \right | \left ( 2 , b _ { 2 } \right )
$$

Maps In many curricula, students are directly introduced to functions. However, before discussing functions, we can explore the more general concept of rules that define mappings between elements of different sets.

A map is a rule F which assigns to each element of a set A another element of a set B : F ( a ) ≡ b ∈ B ∀ a ∈ A.

In the above expression, we read ≡ as ‘is defined as’ or ‘is equivalent to’, indicating that F ( a ) is explicitly assigned the value b in the set B. The symbol ∀ is read as ‘for all’, emphasizing that this rule applies to every element a in the set A.

It is common to use the following notation F : A → B. We call A the domain and B the codomain , the element a ∈ A fed into the map is the argument (or preimage ), and F ( a ) its image . Note that we use different notations to distinguish a mapping between sets and its behavior on individual elements. For example:

$$
F \colon \mathbb { N } \to \mathbb { Z } , \ \ x \mapsto F ( x ) = x ^ { 2 } ,
$$

where the expression on the left-hand side focuses on specifying the domain and codomain of F , whereas the right-hand side highlights the action of F on individual elements of the domain, that is, on particular inputs.

A function is a special type of mapping, which maps a set into the set of numbers.

Types of Maps Maps can be surjective , injective , or bijective , depending on how they map elements from one set to another. We say that a map between two sets is bijective when it is both injective and surjective .

(a) Injective

(b) Surjective

(c) Bijective

Figure 2: Depiction of injective, surjective, and bijective maps between two sets whose elements are highlighted in blue and red respectively.

As we will see in Section 4.3, one application of the Cartesian product is to represent complex manifolds as combinations of simpler ones. For instance, by taking the Cartesian product of multiple 1-spheres (circles), we can define points on a hypertorus. In Geometric Deep Learning, this approach can encode data into complex latent spaces while maintaining a closed-form differentiable representation of the underlying geometry.

![image 5](<BordeBronstein2025/imageFile5.png>)

The terms injection, surjection, and bijection were introduced by a group of French mathematicians publishing under the collective pseudonym Nicholas Bourbaki in 1954, and the adjective forms first used by Claude Chevalley in

1956.

![image 6](<BordeBronstein2025/imageFile6.png>)

[Page 8]

$$
F ( a _ { 1 } ) = F ( a _ { 2 } ) \, \Longrightarrow \, a _ { 1 } = a _ { 2 } .
$$

Surjective (Onto): A map F : A → B is called surjective (or onto) if every element in the codomain B has at least one preimage in the domain A . That is, for every b ∈ B , there exists an a ∈ A such that

$$
F ( a ) = b .
$$

Bijective: A map F : A → B is bijective if it is both injective and surjective. In other words, each element of A maps to a unique element of B , and every element of B has a unique preimage in A . A bijective map has an inverse, denoted F − 1 : B → A , such that

$$
F ^ { - 1 } ( F ( a ) ) = a \ \forall \ \ a \in A , \ \ F ( F ^ { - 1 } ( b ) ) = b \ \forall \ \ b \in B .
$$

Composition Maps between different sets can be combined.

Given two maps, F 1 : A → B , and F 2 : B → C , the composition of F 1 and F 2 , denoted as F 2 ◦ F 1 , is a new map:

$$
F _ { 2 } \circ F _ { 1 } \colon A \rightarrow C .
$$

Note that when we compose injective maps, the result is also injective. Similarly, when we compose surjective maps or two bijective maps, the resulting maps are also surjective and bijective, respectively.

Like maps , functions can also be composed to create new functions. If f : X → Y and g : Y → Z , their composition, denoted as g ◦ f , is a function g ◦ f : X → Z defined by:

$$
( g \circ f ) ( x ) = g ( f ( x ) ) .
$$

For example, let f ( x ) = x 2 and g ( x ) = sin( x ) . Then the composition g ◦ f is:

$$
( g \circ f ) ( x ) = g ( f ( x ) ) = \sin ( f ( x ) ) = \sin ( x ^ { 2 } ) .
$$

Similarly, the reverse composition f ◦ g is:

$$
( f \circ g ) ( x ) = f ( g ( x ) ) = f ( \sin ( x ) ) = ( \sin ( x ) ) ^ { 2 } .
$$

There are other alternative ways of expressing the injectivity property: If

( a 1 , b ) ∈ F and ( a 2 , b ) ∈ F , then a 1 = a 2 , or b has no more than one pre-image.

F : A → B is surjective if and only if ran F = B , where ran F = { b : ∃ a ∋ ( a, b ) ∈ F } .

Note that composition of functions is associative but not commutative.

[Page 9]

Function Composition and Deep Learning. Arguably, the foundation of Deep Learning lies in function composition, where the input undergoes iterative transformations through successive layers. Each layer processes the output (or activations) of the previous one, passing it as input to the next layer in the neural network. Also note that artificial neural networks are generally not bijective, as they are neither guaranteed to be injective nor surjective.

For instance, Figure 3 displays a schematic of a LeNet-5 neural network. We can observe how the input image is processed from left to right. The feature maps (yet another term for layer outputs or activations) are processed by different layers in the architecture and passed as input to the next layer to produce the subsequent set of feature maps. This is an example of function composition.

![In this image there is a graph with some text and numbers. There is a graph with some text and numbers. There is a graph with some text and numbers. There is a graph with some text and numbers. There is a graph with some text and numbers.](<BordeBronstein2025/imageFile7.png>)

C3

maps 16010x10

16@5x5

C1:feature maps

S4{

maps

INPUT

6@28x28

C5 layer

OUTPUT

F6: layer

6@14*14

120

10

84

Gaussian connections

Full connection

Subsampling

Subsampling

Full connection

Convolutions

Convolutions

Figure 3: LeNet-5 classical CNN architecture.

Hypothesis Class In machine learning it is common to come across the concept of hypothesis class .

If X is the input space and Y the label (or output) space, then a hypothesis class is any set

$$
\mathcal { F } \subseteq \{ f \colon \mathcal { X } \rightarrow \mathcal { Y } \}
$$

of functions (hypotheses) from X to Y from which a learning algorithm chooses its prediction rule.

For instance, in linear regression the hypothesis class is the set of all possible lines. For the multivariate linear regression case, we have:

$$
\mathcal { F } _ { \text {lin} } = \left \{ \, f _ { w , b } \colon \mathbb { R } ^ { d } \to \mathbb { R } \, \Big | \, h _ { w , b } ( x ) = w ^ { \top } x + b , \, w \in \mathbb { R } ^ { d } , \, b \in \mathbb { R } \right \} ,
$$

i.e. the set of all affine (straight-line) functions parameterized by ( w,b ) .

In Deep Learning, the hypothesis class is given by the neural network architecture construction we choose to implement. The model then learns to optimize the parameters via gradient descent (Section 3.7) and converges on a particular function given the data used to train it. For example, in the case of a MultiLayer Perceptron (MLP), the hypothesis class would be

$$
\mathcal { F } _ { \text {NN} } & = \ \{ \ f _ { \theta } \colon \mathcal { X } \to \mathcal { Y } \ | \ \theta \in \Theta \} , \\ \ f _ { \theta } ( x ) & = \ \sigma _ { L } \left ( W ^ { ( L ) } \left ( \cdots \sigma _ { 2 } \left ( W ^ { ( 2 ) } ( \sigma _ { 1 } ( W ^ { ( 1 ) } x + b ^ { ( 1 ) } ) ) + b ^ { ( 2 ) } \right ) \cdots \right ) + b ^ { ( L ) } \right ) .
$$

It is possible to visualize the internal filters learned by deep CNNs. The filters in the initial layers typically capture primitive patterns such as edges, corners, and textures, while the filters in deeper layers learn to compose these primitives into more complex features.

![image 8](<BordeBronstein2025/imageFile8.png>)

In Machine Learning we

want to exploit the underlying low-dimensional structure of the input high dimensional space X . We can expect three sources of error in high-dimensional learning: approximation error, statistical error, and optimization error.

An MLP is one of the first neural network architectures. It consists of stacking multiple ‘perceptrons’, which take a multidimensional input, assign a weight to each of its entries, add the results, and apply a non-linear transformation.

[Page 10]

where L is the total number of layers, θ =   W (1) ,b (1) , W (2) ,b (2) ,...,W ( L ) ,b ( L )   is the set of learnable parameters, Θ is typically R   i (dim W ( i ) +dim b ( i ) ) , and σ 1 ,...σ L are non-linear activation functions. In other words, the MLP architecture is a composition of affine transformations and non-linear functions.

Restricting the Hypothesis Class using Symmetries. The larger the hypothesis class, the better the best hypothesis models the underlying true function, but the harder it is to find that best hypothesis. In Geometric Deep Learning we often choose to restrict our neural network hypothesis class by embedding symmetry (invariance and equivariant) into our layer transformations. This can lead to more efficient learning in data scarce regimes. This is related to the bias-variance tradeoff often mentioned in the literature.

# 1.2 Groups

A group is a way of organizing and understanding how a set of elements interact with one another through a well-defined operation. Groups are used to describe symmetry, structure, and transformations in various mathematical and physical contexts.

Let us consider a physical example before diving into the formal definition. Think of a square and the group of rotations of the square . The set of elements in this group consists of the different rotations C 4 = { 0 ◦ , 90 ◦ , 180 ◦ , 270 ◦ } that can be applied to the square. The operation here is combining rotations. For instance, applying two 90 ◦ rotations is equivalent to a single 180 ◦ rotation. Applying a 0 ◦ rotation followed by a 90 ◦ rotation results in just a 90 ◦ rotation. This shows that combining elements of the set results in elements within the same set.

![In this image, we can see a diagram with a square and four corners.](<BordeBronstein2025/imageFile10.png>)

◦

◦

◦

+90 ◦

+90 ◦

+90 ◦

◦

◦

◦

◦

0

90 ◦

180 ◦

270 ◦

◦

+90 ◦

Figure 4: Rotational Symmetries of a Square ( C 4 ).

This situation exemplifies symmetry: the square remains unchanged ( invariant ) under these rotations. In mathematics, symmetry refers to a property of an object or system that remains unchanged under specific transformations or operations.

Similar schematics can be created, for instance, to represent the symmetry of a triangle under both rotations and reflections. More generally, we refer to these as Cayley graphs.

In the past sigmoid functions were a standard activation function for hidden neural network layers. However, due to the so-called ‘vanishing gradient problem’, sigmoids are currently mainly used as a final non-linear transformation for binary classification problems. Rectified Linear Units (ReLUs) and its variants such as Exponential Linear Units (ELUs) and Leaky ReLUs are a more standard choice in the literature nowadays. For large scale Transformers the Sigmoid Linear Unit (SiLU) (also known as the swish function) is widely used instead. Many other activations functions have been proposed in the literature.

Many classes of physical operations can be associated with a group structure. Since Geometric Deep Learning architectures often aim to model such phenomena, groups become essential for designing artificial neural networks whose internal representations align with physical principles.

The term symmetry has Greek origins ‘symmetria’ literally translates to ‘same measure’.

[Page 11]

![In this image, we can see a diagram with some text.](<BordeBronstein2025/imageFile9.png>)

3

R

2

R

R

F

R

R

Figure 5: Cayley graph representing the symmetry of a triangle, where R stands for rotation and F for reflection.

A group is a set equipped with a binary operation that combines any two elements of the set to form a third element. In a group, the set and the operation can be denoted as ( G, ◦ ) , where G is the set and ◦ is the binary operation. The operation must satisfy the following fundamental properties, known as the group axioms:

- • Associativity : For all a,b,c ∈ G , we have ( a ◦ b ) ◦ c = a ◦ ( b ◦ c ) .
- • Identity Element : There exists an element e ∈ G such that for all a ∈ G , e ◦ a = a ◦ e = a . This element is called the identity element.
- • Inverse Element : For each element a ∈ G , there exists an element b ∈ G such that a ◦ b = b ◦ a = e , where e is the identity element. The element b is called the inverse of a and is denoted a − 1 .


Closure follows from the definition: for all a,b ∈ G , the result of the operation c = a ◦ b is also in G , c ∈ G , and commutativity does not necessarily apply in general. Groups can be finite, infinite, discrete, or continuous.

# Examples of Groups

- • Integers under Addition : The set of integers Z with the operation of addition (+) forms a group. The identity element is 0 , and each integer a has an additive inverse − a .
- • Non-zero Rational Numbers under Multiplication : The set of non-zero rational numbers Q ∗ = Q \ { 0 } with multiplication ( · ) forms a group. The identity element is 1 , and each element a has a multiplicative inverse 1 a .


a ◦ b can be denoted by juxtaposition for brevity: a ◦ b = ab. Also, alternatively, one can use the symbol ∗ .

Group theory originated with Galois, who introduced the concept of permutation groups to show that general fifth-degree (quintic) polynomials cannot be solved by radicals. This settled a centuries-old problem that had perplexed mathematicians such as Lagrange and Ruffini. Interestingly, attempts to solve lower-degree equations (like quadratics) date back to ancient Babylonian mathematics.

[Page 12]

• Symmetric Group : The symmetric group S N consists of all permutations of N elements. The group operation is the composition of permutations, and it is an example of a finite group.

# More on Groups

• Abelian Group : A group ( G, ◦ ) is called abelian (or commutative) if the operation is commutative, meaning a ◦ b = b ◦ a for all a,b ∈ G .

• Subgroup : A subgroup H of a group G is a subset of G that is itself a group under the operation of G . If H is a subgroup of G , we write H ≤ G .

• Order of a Group : The order of a group is the number of elements in the group, | G | .

For instance, in our previous example, the group of rotations of a square, C 4 , is abelian and has an order of 4. The group of rotations C 2 = { 0 ◦ , 180 ◦ } is a subgroup C 2 ≤ C 4 .

Groups and Understanding Data Distributions through the Lens of Geometric Deep Learning. In Geometric Deep Learning, groups formalize the concept of symmetry in data. For instance, in computer vision, the group of translations ensures that object categories remain invariant when their positions shift, a property essential for tasks like visual object classification. In computational chemistry, predicting molecular properties requires outputs invariant to both rotations and translations, achieved through the Euclidean group E (3) . Similarly, for systems with discrete symmetries, such as permutations in graphs, the symmetric group S n plays a central role. This group underpins transformations where elements (e.g., particles or nodes) can be arbitrarily reordered, a key aspect in GNNs and the message-passing framework (Section 7.3).

A non-abelian group contains at least some elements for which a ◦ b ̸ = b ◦ a .

̸

Another important abelian group is that formed by all rotations of three-dimensional space.

Graph Neural Networks (GNNs) are a type of artificial neural networks designed to process signals over graph structures.

Group Homomorphisms It is often that we may find groups which are equivalent, or that can be realized in different ways. The essence of a group homomorphism lies in preserving structure, rather than focusing solely on particular examples.

A group homomorphism is a map between two groups that preserves the group structure. Let ( G, ◦ ) and ( H, ∗ ) be two groups. A map ϕ : G → H is called a group homomorphism if, ∀ a,b ∈ G , the following condition holds:

$$
\phi ( a \circ b ) = \phi ( a ) * \phi ( b ) .
$$

A group isomorphism is a bijective homomorphism between two groups G and H , establishing a perfect identification between them.

Two groups ( G, ◦ ) and ( H, ∗ ) are said to be isomorphic , ( G, ◦ ) ∼ = ( H, ∗ ) , if there exists a bijective map (a one-to-one and onto mapping) ϕ : G → H such that ϕ is a group homomorphism.

[Page 13]

Define the homomorphism ϕ : C 4 → Z 4 as

$$
\phi ( 0 ^ { \circ } ) = 0 , \quad \phi ( 9 0 ^ { \circ } ) = 1 , \quad \phi ( 1 8 0 ^ { \circ } ) = 2 , \quad \phi ( 2 7 0 ^ { \circ } ) = 3 .
$$

This mapping respects the group operation. Let us verify the homomorphism property. The group operation in C 4 is addition modulo 360 ◦ , and the group operation in Z 4 is addition modulo 4. To verify ϕ is a homomorphism, check that:

$$
\phi ( a + b \mod 3 6 0 ^ { \circ } ) = \phi ( a ) + \phi ( b ) \mod 4 , \ \forall a , b \in C _ { 4 } .
$$

Some examples include

$$
\phi ( 9 0 ^ { \circ } + 1 8 0 ^ { \circ } \mod 3 6 0 ^ { \circ } ) & = \phi ( 2 7 0 ^ { \circ } ) = 3 , \\ \phi ( 9 0 ^ { \circ } ) + \phi ( 1 8 0 ^ { \circ } ) & \mod 4 = 1 + 2 \mod 4 = 3 .
$$

Next, let us illustrate a non-isomorphic mapping between C 4 and C 2 = { 0 ◦ , 180 ◦ } . While both C 4 and C 2 are cyclic groups, their structures are fundamentally different, and no isomorphism exists between them. However, there are still homomorphisms that preserve the group structure.

Let C 2 = { 0 ◦ , 180 ◦ } where the group operation is addition modulo 360 ◦ . Define a homomorphism ψ : C 4 → C 2 as:

$$
\psi ( 0 ^ { \circ } ) = 0 ^ { \circ } , \quad \psi ( 9 0 ^ { \circ } ) = 1 8 0 ^ { \circ } , \quad \psi ( 1 8 0 ^ { \circ } ) = 0 ^ { \circ } , \quad \psi ( 2 7 0 ^ { \circ } ) = 1 8 0 ^ { \circ } .
$$

This map is not injective (and therefore not bijective), which means that C 4 and C 2 are not isomorphic. Let us verify the homomorphism property. The group operation in both C 4 and C 2 is addition modulo 360 ◦ . To check that ψ is a homomorphism, we must verify:

$$
\psi ( a + b \mod 3 6 0 ^ { \circ } ) = \psi ( a ) + \psi ( b ) \mod 3 6 0 ^ { \circ } , \ \forall a , b \in C _ { 4 } .
$$

Some examples include: let a = 90 ◦ and b = 180 ◦

$$
\psi ( 9 0 ^ { \circ } + 1 8 0 ^ { \circ } \mod 3 6 0 ^ { \circ } ) = \psi ( 2 7 0 ^ { \circ } ) = 1 8 0 ^ { \circ } ,
$$

$$
\psi ( 9 0 ^ { \circ } ) + \psi ( 1 8 0 ^ { \circ } ) \mod 3 6 0 ^ { \circ } = 1 8 0 ^ { \circ } + 0 ^ { \circ } \mod 3 6 0 ^ { \circ } = 1 8 0 ^ { \circ } .
$$

Group Actions A group action is a formal way of describing how a group interacts with a set while preserving its structure. It connects abstract group theory to concrete situations where groups act on mathematical or physical objects, such as transforming geometric shapes, permuting elements, or applying symmetry operations.

Let us revisit C 4 = { 0 ◦ , 90 ◦ , 180 ◦ , 270 ◦ } once more. These rotations act on the set of The modulo operation (denoted as a mod n ) finds the remainder when a is divided by n . Specifically, a mod n is the integer remainder r such that 0 ≤ r < n and a = n · q + r for some integer q .

[Page 14]

vertices of the square,

$$
V = \{ \hat { A } , \hat { B } , \hat { C } , \hat { D } \} ,
$$

by permuting their positions. For example:

- • A 90 ◦ rotation maps ˆ A → ˆ B , ˆ B → ˆ C , ˆ C → ˆ D , ˆ D → ˆ A .
- • A 180 ◦ rotation maps ˆ A → ˆ C , ˆ B → ˆ D , ˆ C → ˆ A , ˆ D → ˆ B .


This interaction satisfies the structure-preserving properties of a group action.

A (left) group action of a group G on a set X is a mapping:

$$
\alpha \colon G \times X \to X , \ \ ( g , x ) \mapsto \alpha ( g , x ) = g \cdot x ,
$$

satisfying the following axioms:

- • Identity : The identity element e ∈ G acts as the identity transformation on X :

$$
\alpha ( e , x ) = e \cdot x = x , \ \forall x \in X .
$$

- • Compatibility : ∀ g,a ∈ G and x ∈ X , the action satisfies:


$$
( g \circ a ) \cdot x = g \cdot ( a \cdot x ) ,
$$

where ◦ is the group operation in G .

Groups Actions on Data. In Geometric Deep Learning, rather than considering groups as abstract entities, we focus on how different mathematical operations, which we can prescribe for our artificial neural network, transform the input data. This enables us to design our model to perform transformations on the data that respect the structure of its domain.

9

Figure 6: Group action on an image (function). The type of an object can be defined by the way it is transformed by a group.

Group Orbits, Invariance, and Equivariance We expand on our previous discussion by introducing a few formalisms.

The group operation vanishes on the right-hand side of the compatibility axiom because it is implicitly handled by the action itself. The key idea is that group actions are associative with respect to the group operation. This means that applying the action of a ◦ b to x is the same as first applying b to x and then applying a to the result.

In Geometric Deep Learning, we assume there is a domain underlying our data, which we denote by Ω , and study how groups act on Ω and how we obtain actions on the same group on the space of signals X (Ω) .

[Page 15]

$$
O r b ( x ) = \{ g \cdot x \, | \, g \in G \} .
$$

That is, the orbit of x under a group G is the set of all points one can reach from x by applying every possible action in G .

Before proceeding further, it is useful to formalize the notions of invariant and equivariant functions. Let X and Y be sets on which a group G acts.

A function f : X → Y is called G -invariant if

$$
f ( g \cdot x ) = f ( x ) \ \forall \, g \in G , \, x \in X .
$$

In contrast,

Let ( X, · X ) and ( Y, · Y ) be G -spaces, meaning that the group G acts on X via · X and on Y via · Y . A function f : X → Y is said to be G -equivariant if

$$
f ( g \cdot _ { X } x ) = g \cdot _ { Y } f ( x ) \ \forall g \in G , \, x \in X .
$$

Thus, while an invariant function collapses the entire orbit to a single value, an equivariant function transforms in a predictable way under the group action.

Perhaps somewhat abstractly, one common method to achieve invariance in a neural network is to aggregate over these orbits. For example, a group convolution operator is defined as

$$
( f * \psi ) ( x ) = \sum _ { g \in G } f ( g \cdot x ) \, \psi ( g ^ { - 1 } ) ,
$$

or in the continuous setting,

$$
( f * \psi ) ( x ) = \int _ { G } f ( g \cdot x ) \, \psi ( g ^ { - 1 } ) \, d g ,
$$

where ψ : G → R is a kernel function and dg denotes the Haar measure on G . This operator is G -equivariant, meaning that applying a transformation to the input before the convolution yields the same result as applying it after convolution.

Let us give an intuitive explanation to unravel what our previous mathematical abstraction really means. Consider G as the group of rotations by 90 ◦ , again this is C 4 , acting on the set X of images. For a given image x ∈ X (for example, the Mona Lisa), its orbit Orb ( x ) will contain all four rotated copies: x,R 90 ( x ) ,R 180 ( x ) ,R 270 ( x ) ∈ Orb ( x ) . An invariant function f (such as one used for face recognition) would output the same value for each image in the orbit

$$
f ( x ) = f ( R _ { 9 0 } ( x ) ) = f ( R _ { 1 8 0 } ( x ) ) = f ( R _ { 2 7 0 } ( x ) ) ,
$$

recognizing that they all represent the same underlying face despite different orientations.

A kernel function ψ assigns weights to the contributions of different group elements, much like a filter in a convolution, while the Haar measure dg is a translation-invariant measure on G that ensures integration over the group is independent of the specific parametrization.

[Page 16]

# 1.3 Vector Spaces

Invariance and Equivariance in Geometric Deep Learning. By interleaving transformations that respect the symmetry of the input, Geometric Deep Learning architectures can be made both expressive and robust. This strategy enables the design of models that generalize better and are more interpretable in settings where the data exhibit natural symmetries. More concretely, stacking several equivariant layers enables the network to capture increasingly complex hierarchical patterns while respecting the underlying symmetry. The final invariant operation then distills these symmetry-preserving features into a robust representation suitable for tasks such as classification, segmentation, or regression, where the output should not depend on the particular transformation applied to the input. Note that stacking only invariant transformations would result in a strictly smaller hypothesis class.

Fields Before moving on to discussing vector spaces, let us briefly mention fields. Fields, groups, and vector spaces are interconnected in the hierarchy of algebraic structures. A group has a single binary operation with minimal axioms, while a field has two operations with stringent compatibility conditions. Hence, fields impose more structure than groups and belong to a different class of algebraic objects.

A field is a set F equipped with two binary operations, addition ( + ) and multiplication ( · ), satisfying the following properties:

- • ( F , +) forms an abelian group (with identity element 0 ).
- • ( F \ { 0 } , · ) forms an abelian group (with identity element 1 ).
- • Multiplication is distributive over addition: ∀ a,b,c ∈ F , a · ( b + c ) = ( a · b ) + ( a · c ) .


# 1.3 Vector Spaces

Now that we have a basic understanding of groups and fields, we can introduce the concept of a vector space . Vectors are ubiquitous in applications of mathematics, especially in physical sciences. Introductory courses often talk about vectors in geometric terms (‘arrows that have direction and length’) or computer science terms (‘arrays of numbers’). Each of these definitions are a crime against humanity: in order to think of vectors as ‘arrows’, one has to define direction and length by introducing additional structures called inner products and norms; in order to think of vectors as ‘arrays’, one has to define a basis, with respect to which vectors can be represented as ordered sets of coordinates. The correct mathematical way of thinking of vectors is as abstract objects that can be scaled and added.

The importance of invariance and equivariance came to the forefront much earlier in Physics:

“Every [differentiable] symmetry of the action of a physical system [with conservative forces] has a corresponding conservation law” – Emmy Noether, 1918

“It is only slightly overstating the case to say that Physics is the study of symmetry” – Philip Anderson, 1972

[Page 17]

V is a vector space over a field F (typically F = R or C ) with binary operations + : V × V → V ( vector addition ) and · : V × F → V ( scalar multiplication ) if for any u,v,w ∈ V and α,β ∈ F we have the following properties:

- • Associativity of + : u + ( v + w ) = ( u + v ) + w
- • Commutativity of + : u + v = v + u
- • Identity element of + : There exists a unique 0 ∈ V such that u + 0 = u
- • Inverse element of + : There exists a unique − v ∈ V such that v +( − v ) = 0
- • Distributivity of · w.r.t. vector addition : α · ( u + v ) = α · u + α · v
- • Distributivity of · w.r.t. scalar addition: ( α + β ) · v = α · v + β · v
- • Compatibility of · with scalar multiplication: α · ( β · v ) = ( α · β ) · v
- • Identity element of · : ∃ !1 ∈ R s.t. 1 · u = u


Note that notation sometimes can be confusing and therefore should be used with care. The same notation is used for scalar addition α + β and vector addition u + v . It should be understood from context which addition is meant. The same notation is also used for scalar-by-scalar multiplication α · β and vector-by-scalar multiplication α · u . When no confusion arises, the vector-by-scalar multiplication is often denoted as αu for brevity. The zero vector 0 ∈ V (identity element of vector addition) should not be confused with the zero scalar 0 ∈ R (identity element of scalar addition), even though they are often denoted in the same way. Lastly, ∃ ! u ∈ V means ‘there exists a unique u in V ’, and it implies that there is exactly one element u ∈ V such that a particular condition is satisfied.

# Examples of Vector Spaces

- • Vectors : R n = { ( v 1 ,...,v n ) : v i ∈ R , ∀ i = 1 ,...,n } with u + v = ( u 1 + v 1 ,...,u n + v n )
- • Functions : F (Ω) = { f : Ω → R } with ( f + g )( x ) = f ( x ) + g ( x )


From Vector Spaces to Tensor Spaces Although it is less commonly discussed in basic linear algebra than vector spaces, in practice in Deep Learning we work with tensor spaces . A tensor is a multi-dimensional generalization of vectors and matrices. Tensors are particularly relevant in Deep Learning for parallel data processing.

Next, we discuss some basic examples. A scalar is a tensor of order (or rank) 0, represented by a single value, say

$$
a = 5
$$

A scalar is a single numerical value, such as a real number, with no direction or dimension. A vector is an ordered array of numbers, representing a point or direction in space, and can be one-dimensional or multi-dimensional. A tensor is a generalization of scalars and vectors to higher dimensions, represented as multi-dimensional arrays. For instance, scalars are 0th-order tensors, vectors are 1st-order tensors, and matrices are 2nd-order tensors. Higher-order tensors extend this concept, representing data with more than two dimensions, such as a sequence of matrices. In Deep Learning we tend to work with high-dimensional tensors.

F is used to denote a set of functions on the domain Ω . That is, the set F (Ω) consists of functions whose domain is Ω . Here, we talk about functions instead of maps, since we are considering special types of maps that map a set Ω to R , rather than to an arbitrary set.

[Page 18]

A vector is a tensor of order 1, represented as a one-dimensional array

$$
v = \begin{bmatrix} 1 \\ 2 \\ 3 \end{bmatrix} .
$$

A matrix is a tensor of order 2, represented as a two-dimensional array

$$
M = \begin{bmatrix} 1 & 2 \\ 3 & 4 \\ 5 & 6 \end{bmatrix} .
$$

A higher-order tensor, of order 3 in this example, is a n -dimensional array, represented as

$$
T _ { i j k } = \left [ \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix} , \ \begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} , \ \begin{bmatrix} 9 & 1 0 \\ 1 1 & 1 2 \end{bmatrix} \right ] .
$$

T ijk in this particular instance represents a 3 × 2 × 2 tensor. Alternatively, we can express the slices more clearly:

$$
T _ { i j k } = \begin{cases} T _ { 1 , \colon , \colon } = \begin{bmatrix} 1 & 2 \\ 3 & 4 \end{bmatrix} , \\ T _ { i j k } = \begin{cases} T _ { 2 , \colon , \colon } = \begin{bmatrix} 5 & 6 \\ 7 & 8 \end{bmatrix} , \\ T _ { 3 , \colon , \colon } = \begin{cases} 9 & 1 0 \\ 1 1 & 1 2 \end{cases} .
$$

The Einstein summation convention is a shorthand for tensor expressions, where repeated indices imply summation over all their possible values. This convention makes it easier to work with high-dimensional tensors. Let us look at some examples of Einstein summation.

The dot product of two vectors u and v in Einstein notation is written as

$$
u _ { i } v ^ { i } = \sum _ { i } u _ { i } v ^ { i } = a ,
$$

where we can omit the summation symbol, and the product results in a scalar, a .

For a matrix M and vector v , the matrix-vector multiplication in Einstein notation is

$$
M _ { i j } v ^ { j } = \sum _ { j } M _ { i j } v ^ { j } = u _ { i } ,
$$

which results in another vector, u .

Likewise, a tensor contraction, which is a generalization of matrix multiplication, can be written as:

$$
T _ { i j k } v ^ { j } = \sum _ { j } T _ { i j k } v ^ { j } = M _ { i k } .
$$

This involves summing over the index j , since it is the repeated index. Multiplying an order 3 tensor and a vector, results in an order 2 tensor, that is, a matrix.

[Page 19]

Tensor Spaces in Deep Learning. A tensor space can be thought of as a generalization of vector spaces to higher-dimensional objects, where tensors (multidimensional arrays) act as elements in these spaces. More formally, a tensor space can be described as a set of tensors where tensor addition and scalar multiplication follow the usual rules that hold for vector spaces, but are generalized to multi-dimensional arrays. For instance in Computer Vision, we typically process tensors of shape [B,C,H,W] , where B stands for batch size, C for channel dimension (RGB channels), and H and W are the height and width of the image. In the context of video we can further include a frames (or time) dimension and the tensor gains an additional dimension, [B,C,F,H,W] . However, oftentimes in research articles, transformations are represented in terms of matrices, and additional entries such as those for the batch dimension are omitted for clarity.

[Page 20]

# 2 Geometric and Analytical Structures

Geometric structures bring life to abstract mathematical objects by introducing familiar concepts like distance, size, and angles. While groups and vector spaces give us powerful ways to study relationships and transformations, they lack the geometric intuition we often need in real-world applications.

# 2.1 Norms and Normed Vector Spaces

A norm is a mathematical function that quantifies the size or magnitude of a mathematical object, generalizing our intuitive understanding of length or distance in physical space. Like physical length, a norm assigns a non-negative real number to an object while satisfying specific properties.

Given a vector space V over a field F = R , a norm is a function ∥∥ : V → R satisfying for any u,v ∈ V and α ∈ R :

• Positive homogeneity: ∥ αu ∥ = | α |∥ u ∥

+ ∥ v ∥ u = 0

- • Triangle inequality: ∥ u + v ∥ ≤ ∥ u ∥
- • Positive definiteness: ∥ u ∥ = 0 ⇒


( V, ∥∥ ) is called a normed (vector) space . Intuitively, the norm measures the length of a vector.

The following properties (often listed as part of axiomatic definition of the norm) are in fact consequences of the above definition:

- • ∥ 0 ∥ = ∥ 0 · u ∥ (1) = | 0 |∥ u ∥ = 0 , i.e. property (3) is iff: ∥ u ∥ = 0 ⇔ u = 0 .

$$
^ { - } =
$$

- • ∥ u ∥ ≥ 0 ,


where (1) refers to positive homogeneity and (3) to positive definiteness.

# Examples of Norms

• L p -norm on R n : ∥ u ∥ p = (   n i =1 | u i | p ) 1 /p , in particular

- – L 1 -norm: ∥ u ∥ 1 =   n i =1 | u i |
- – L 2 -norm (Euclidean norm): ∥ u ∥ 2 =     n i =1 | u i | 2


– L ∞ -norm: ∥ u ∥ ∞ = max {| u 1 | ,..., | u n |}

• L p -norm on F (Ω) : ∥ f ∥ p =    Ω | f ( x ) | p dx   1 /p

The summation in the vector case, is replaced by an integral in the function case. This is because functions can be thought of as vectors with infinitely many components, where the integral serves as a continuous analog of the sum.

The field can also be F = C , but in the main text we stick to R for simplicity.

The notation ∥ u ∥ refers to the norm of an element in a vector space, where u is a vector. In contrast, | α | denotes the absolute value of a scalar, which is a special case of a norm when the underlying field is the real or complex numbers. While the norm generalizes the concept of absolute value to vector spaces, the absolute value is specifically used for scalars.

The L 2 -norm, also known as the Euclidean norm, is the most commonly used norm, and it provides the notion of the length of a vector.

[Page 21]

Norms in Geometric Deep Learning. Norms quantify the magnitude of vectors and are fundamental for enabling invariant feature representations in Geometric Deep Learning architectures, particularly under transformations such as rotations and reflections. Additionally, norms play a key role in regularization in Deep Learning. For example, weight decay penalizes the Euclidean norm of model parameters to prevent overfitting and encourage generalization.

# 2.2 Metrics Induced by Norms and Metric Spaces

A metric represents a mathematical way to measure distances between elements in a set, with norms being a special case that can generate metrics.

Given a normed vector space ( V, ∥ · ∥ ) , a metric d : V × V → R is naturally defined by:

$$
d ( u , v ) = \| u - v \| , \ \forall u , v \in V .
$$

This metric satisfies the following properties, making ( V,d ) a metric space :

• Non-negativity: d ( u,v ) ≥ 0

- • Identity of indiscernibles: d ( u,v ) = 0 ⇔ u = v
- • Symmetry: d ( u,v ) = d ( v,u )
- • Triangle inequality: d ( u,w ) ≤ d ( u,v ) + d ( v,w )


Note that every normed vector space is also a metric space with a metric induced by its norm. However, not all metric spaces are normed vector spaces.

# Examples of Metrics Induced by Norms

• L p distance in R n : d p ( u,v ) = ∥ u − v ∥ p = (   n i =1 | u i − v i | p ) 1 /p , in particular

- – L 1 distance: d 1 ( u,v ) = ∥ u − v ∥ 1 =   n i =1 | u i − v i |
- – L 2 distance (Euclidean distance): d 2 ( u,v ) = ∥ u − v ∥ 2 =     n i =1 | u i − v i | 2
- – L ∞ distance: d ∞ ( u,v ) = ∥ u − v ∥ ∞ = max {| u 1 − v 1 | ,..., | u n − v n |}


• L p distance for functions: d p ( f,g ) = ∥ f − g ∥ p =    Ω | f ( x ) − g ( x ) | p dx   1 /p

Generalizations of Metrics The following are important generalizations of metrics:

• A pseudo-metric is a function d : V × V → R satisfying all properties of a metric except the identity of indiscernibles. That is, d ( u,v ) = 0 does not necessarily imply u = v.

A metric measures the distance between two elements in a space, generalizing our intuitive notion of distance in physical space. Unlike norms which measure the size of a single vector, metrics quantify the separation between pairs of elements.

While normed vector spaces are inherently metric spaces, not all metric spaces have the additional algebraic structure of a vector space. A vector space requires operations like vector addition and scalar multiplication that satisfy specific axioms. Many metric spaces lack these operations or do not satisfy the vector space axioms. For instance, in R n , the metric d ( u, v ) = | u 1 − v 1 | + · · · +   | u n − v n | is a valid metric but cannot be derived from a norm.

The Euclidean distance is the most intuitive metric, corresponding to the physical distance between points in space.

For instance, in the context of general relativity, the term pseudo-metric often refers to the metric tensor of spacetime, which is actually a pseudo-Riemannian metric.

[Page 22]

• A quasi-metric also satisfies all properties of a metric space, but it relaxes the triangle inequality to:

$$
d ( u , w ) \leq \mathcal { C } ( d ( u , v ) + d ( v , w ) ) ,
$$

known as the C -relaxed triangle inequality . When C = 1 , this reduces to a standard metric space.

Hausdorff Distance The Hausdorff distance provides a way to measure how far apart two subsets of a metric space are.

Given two non-empty subsets A,B ⊂ V in a metric space ( V,d ) , the Hausdorff distance d H is defined as:

$$
d _ { H } ( A , B ) = \max \left \{ \sup _ { a \in A } \inf _ { b \in B } d ( a , b ) , \sup _ { b \in B } \inf _ { a \in A } d ( b , a ) \right \} .
$$

Here, d ( a,b ) is the distance between points a ∈ A and b ∈ B as defined by the metric d on V . The Hausdorff distance satisfies the following properties:

- • Non-negativity: d H ( A,B ) ≥ 0 , and d H ( A,B ) = 0 if and only if A = B (when A and B are closed sets).
- • Symmetry: d H ( A,B ) = d H ( B,A ) .
- • Triangle inequality: d H ( A,C ) ≤ d H ( A,B )+ d H ( B,C ) for any subsets A,B,C ⊂ V .


In R n with the Euclidean distance, the Hausdorff distance is often used to compare geometric objects such as polygons or point clouds.

Metrics in Geometric Deep Learning. Metrics define distance measures for comparing data points across graph, manifold, and point cloud representations, as well as in neural latent (embedding) spaces. In particular, the Euclidean distance d 2 ( u,v ) = ∥ u − v ∥ 2 =     n i =1 | u i − v i | 2 is a natural choice in many Deep Learning implementations. For instance, in Geometric Deep Learning and computational biology, Euclidean distance is commonly used to construct unit disk graphs or k-nearest neighbor graphs in R 3 . This approach allows to define the connectivity structure of atomic point clouds, such as those derived from protein structures resolved via X-ray crystallography or cryo-Electron Microscopy, where nodes correspond to atoms and edges represent proximity-based interactions. Another notable example is vector quantization methods for neural discrete representation learning developed in the late 2010s, which use Euclidean distance to compare continuous latent embeddings with entries in a learned codebook. Moreover, beyond continuous metric spaces, we often leverage metrics induced by discrete structures such as graph geodesic distances to compute, for example, optimal commute times in transportation networks or information flow in social graphs.

The Hausdorff distance is particularly useful in comparing shapes, curves, or other geometric objects in applications such as computer vision, shape analysis, and geometric deep learning. It is closely related to the Chamfer distance, which computes the average closest point distance instead. Furthermore, the Hausdorff distance can be generalized into the Gromov-Hausdorff distance, which is used to compare metric spaces rather than subsets of a fixed metric space. It provides a way to measure how ‘far apart’ two metric spaces are, considering their intrinsic geometry rather than their embedding into a common space.

[Page 23]

# 2.3 The Inner Product and Inner Product Spaces

In terms of hierarchy, metric spaces form the foundational mathematical structure defining distance, with normed vector spaces and inner product spaces representing progressively more specialized and structured mathematical environments. Normed vector spaces extend metric spaces by integrating a norm that naturally induces a metric, while inner product spaces further enhance this structure by introducing an inner product that generates a norm.

Given a vector space V over a field F = R , an inner product is a function ⟨ , ⟩ : V × V → R satisfying for any u,v,w ∈ V and α ∈ R :

• Conjugate (Hermitian) Symmetry: ⟨ u,v ⟩ = ⟨ v,u ⟩

- • Linearity: ⟨ αu,v ⟩ = α ⟨ u,v ⟩ , ⟨ u + w,v ⟩ = ⟨ u,v ⟩ + ⟨ w,v ⟩
- • Positive Semi-Definiteness: ⟨ u,u ⟩ ≥ 0 , ⟨ u,u ⟩ = 0 ⇔ u = 0


( V, ⟨ , ⟩ ) is called an inner product space .

The following additional property, called conjugate linearity in the second argument, is a consequence of the above definition (considering the field to be F = C for more generality):

$$
\langle u , \alpha v \rangle = \langle \alpha v , u \rangle = \alpha \langle v , u \rangle = \overline { \alpha } \cdot \langle v , u \rangle = \overline { \alpha } \langle u , v \rangle .
$$

Also, note that as previously discussed, in Einstein summation convention, repeated indices are implicitly summed over. For example, in the case of real vectors, we can write the inner product as:

$$
\langle u , v \rangle = u _ { i } v _ { i } ,
$$

where the repeated index i is implicitly summed over from 1 to n .

Inner products provide additional structure beyond what a norm alone can offer. In particular, they enable definitions of angles, orthogonality, and support advanced computational techniques like Gram-Schmidt orthogonalization, eigenvalue decomposition, and principal component analysis. These operations leverage the geometric insights intrinsic to inner product structures. Also, norms derived from inner products often have smoother behavior compared to arbitrary norms. This characteristic makes inner product spaces especially valuable in optimization contexts, where they facilitate natural gradient calculations and provide well-defined curvature representations. Finally note that inner products induce norms, but not vice versa.

# Examples of Inner Products

- • Real vectors R n : ⟨ u,v ⟩ =   n i =1 u i v i = u i v i = v ⊤ u
- • Complex vectors C n : ⟨ u,v ⟩ =   n i =1 u i v i = u i v i = v ∗ u
- • Real matrices: ⟨ A,B ⟩ = trace(AB ⊤ )


The field can also be F = C .

The overline ( · ) is used to denote the complex conjugate. For z = a + bi, then its complex conjugate is: z = a − bi. Note that the complex conjugate of a real number is itself.

Here, we have applied in order: conjugate symmetry, linearity in the second argument of the inner product, the distributive property of complex conjugation, and substitution from the conjugate symmetry.

Gram-Schmidt orthogonalization is a method to transform a set of linearly independent vectors into an orthogonal (or orthonormal) set of vectors; eigenvalue decomposition factors a square matrix into a product involving its eigenvalues and eigenvectors; and principal component analysis is used to reduce the dimensionality of a dataset while retaining as much variance as possible.

A square-integrable function is a function f defined on a domain Ω such that the square of its absolute value is integrable over Ω . Specifically, a function f ( x ) belongs to the space L 2 (Ω) if:

$$
\int _ { \Omega } | f ( x ) | ^ { 2 } \, d x < \infty ,
$$

[Page 24]

# 2.3 The Inner Product and Inner Product Spaces Mathematical Background for GDL

- • Square-integrable functions L 2 (Ω) : ⟨ f,g ⟩ =   Ω f ( x ) g ( x ) dx
- • Square-summable real sequences ℓ 2 : ⟨ x,y ⟩ =   i ≥ 1 x i y i


Relation to Norms The inner product naturally defines a norm, given by

$$
\| u \| = ( \langle u , u \rangle ) ^ { 1 / 2 } \, .
$$

This norm satisfies the Cauchy-Schwarz (Bunyakovsky) inequality:

$$
| \langle u , v \rangle | \leq \| u \| \cdot \| v \| .
$$

This inequality is crucial because it provides an upper bound on the inner product in terms of the magnitudes (norms) of the vectors, ensuring that the inner product cannot exceed the product of the norms of the vectors.

The cosine of the angle between two vectors is given by

$$
\cos \angle ( u , v ) = \frac { \langle u , v \rangle } { \| u \| \cdot \| v \| } ,
$$

which expresses the relationship between the vectors in terms of their geometric angle. When ⟨ u,v ⟩ = 0 , the vectors are said to be orthogonal, meaning the angle between them is 90 ◦ (i.e., u ⊥ v ). This condition is essential for understanding orthogonality in inner product spaces.

Not every norm defines an inner product! A norm that satisfies the parallelogram law :

$$
2 \| u \| ^ { 2 } + 2 \| v \| ^ { 2 } = \| u + v \| ^ { 2 } + \| u - v \| ^ { 2 } ,
$$

can be used to define an inner product via the polarization identity :

$$
\langle u , v \rangle = \frac { 1 } { 4 } \left ( \| u + v \| ^ { 2 } - \| u - v \| ^ { 2 } \right ) .
$$

The parallelogram law provides a critical condition for determining whether a norm arises from an inner product. It describes how the lengths of vectors behave geometrically when combined through addition or subtraction. Specifically, it expresses a relationship between the squares of the lengths of the vectors and their sums and differences, mirroring the geometry of inner product spaces.

If the parallelogram law is not satisfied, then the norm cannot be derived from an inner product. Without this structure, we lose important geometric concepts like orthogonality, angles, and projections, which are fundamental to understanding the behavior of vectors in the space. For example, spaces with norms that do not satisfy the parallelogram law, such as the L 1 norm, do not allow for meaningful definitions of orthogonality or angles.

A square-summable real sequence is a sequence of real numbers

{ a n } ∞ n =1 such that the sum of the squares of its elements is finite:

$$
\sum _ { n = 1 } ^ { \infty } a _ { n } ^ { 2 } < \infty ,
$$

[Page 25]

Theorem 1 (Generalized Pythagorean Theorem) . For a set of pairwise orthogonal vectors v 1 ,v 2 ,...,v n ∈ V (i.e., ⟨ v i ,v j ⟩ = 0 for i ̸ = j ), we have the following property: 2

̸

$$
\left \| \sum _ { i = 1 } ^ { n } v _ { i } \right \| ^ { 2 } = \sum _ { i = 1 } ^ { n } \| v _ { i } \| ^ { 2 } .
$$

This result directly generalizes the Pythagorean theorem from Euclidean geometry: when vectors are orthogonal, the square of the norm of their sum is equal to the sum of the squares of their individual norms. For non-orthogonal vectors, the sum will be less than or equal to the square of the norm of the sum, by virtue of the triangle inequality.

Inner products in Deep Learning. The inner product between two vectors encodes similarity, but is not invariant to scale since large magnitudes can dominate even if directions differ. To mitigate this, the cosine similarity, defined as the normalized inner product, captures the directional alignment between vectors while discarding scale information. Scale invariance can be particularly useful in Deep Learning, where activations can vary in norm due to factors such as network depth, normalization, or noise, but their direction in latent space often encodes semantic content. Inner products (and their normalized counterparts) are smooth, linear functions that provide more stable comparisons than raw norms, such as L p distances. They underpin attention mechanisms in Transformers (the ubiquitous neural network architecture that has impregnated all realms of Deep Learning), where scaled dot-product attention is used. While the dot-product itself is not scale-invariant, scaling by 1 √ d reduces the sensitivity to vector norm and makes the softmax activation more numerically stable. Interestingly, in high-dimensional latent spaces the curse of dimensionality can become a blessing: random vectors are almost always nearly orthogonal which allows neural networks to store a large number of features in directions that do not interfere with each other. In short, high-dimensional latent spaces can pack more information than their dimension may initially suggest, thanks to near-orthogonality.

The original Pythagorean theorem states that in a right triangle with legs of length a and b , and hypotenuse of length c , the relation 2 2 2

a + b = c holds. This theorem can be interpreted geometrically in Euclidean space as the sum of the squares of the orthogonal components

of a vector.

[Page 26]

# 3 Vector calculus

Scalar and vector fields represent quantities that vary across space. These concepts differ from the abstract notion of a vector space, which is purely an algebraic structure. In this section, we examine scalar fields, vector fields, and calculus, which provides essential tools for quantifying variations across space. The latter enables the description of scalar and vector field behavior through operations like differentiation and integration. Differentiation is used to quantify local field behavior, while integral operators establish relationships between infinitesimal variations and macroscopic field properties.

# 3.1 (Lipschitz) Continuity, Differentiability, and Smoothness

In practice, modeling scalar and vector fields is common in Geometric Deep Learning, particularly in applications such as data-driven physics simulations and 3D graphics. These fields are often represented as, or assumed to be, continuous functions that can be approximated using artificial neural networks.

Continuity For a function to be continuous at a point, the limit of the function as we approach that point must exist and be equal to the function’s value at that point. In simpler terms, a continuous function has no abrupt jumps or breaks and ‘can be drawing without lifting your pen from the page’.

Continuity of a function f at a point x 0 requires:

- • The limit lim x → x 0 f ( x ) exists,
- • lim x → x − 0 f ( x ) = lim x → x + 0 f ( x ) (the limit is independent of the direction from which x approaches x 0 ),
- • and the limit and function value must be equal f ( x 0 ) = lim x → x 0 f ( x ) .


Note that the mention of one-sided limits ( lim x → x − 0 and lim x → x + 0 ) is specific to functions on R , where continuity is analyzed along a single dimension. For higher dimensions, this concept generalizes to approaching x 0 from any direction. If the requirements above are satisfied we say that f is a continuous function .

A function f is Lipschitz continuous with Lipschitz constant L if for all x,y ∈ R n :

$$
| f ( x ) - f ( y ) | \leq L | x - y |
$$

Lipschitz continuity bounds the rate of change of a function and ensures that it does not change too rapidly between any two points. The Lipschitz constant L provides an upper bound on the function’s local slope or steepness. Functions that are Lipschitz continuous are always continuous but not vice versa.

In optimization, the notion of Lipschitz continuity is sometimes used to provide guarantees regarding the convergence of algorithms based on iterative methods.

[Page 27]

Differentiability and Smoothness Differentiability is a stronger condition than continuity. While a continuous function ensures smooth variation, a differentiable function provides additional information about the rate of change. The existence of derivatives at every point implies that the function can be well-approximated by its tangent line or hyperplane locally.

A function f is said to be smooth when its derivatives exist up to a certain order and are continuous. We denote this using C k notation:

- • C 0 : Continuous function
- • C 1 : Continuously differentiable (first derivatives are continuous)
- • C k : k times continuously differentiable
- • C ∞ : Infinitely differentiable (derivatives of all orders exist and are continuous)


Smoothness represents progressively stronger conditions on a function’s differentiability. As the smoothness class increases from C 0 to C ∞ , the function becomes increasingly wellbehaved. Note that being continuously differentiable is a stronger condition that being differentiable alone, since it implies that the derivative does not only exist but it is also continuous.

# 3.2 Scalar Fields, Vector Fields, and Signals

A scalar field is a function f : R n → R that assigns a single scalar value to every point in n -dimensional space, f ( x ) = f ( x 1 ,...,x n ) .

In R 3 , f ( x,y,z ) could represent the temperature at a specific point ( x,y,z ) in a room. The value of f ( x ) at each point is a scalar, meaning it has magnitude but no direction.

A vector field is a function F : R n → R m that assigns a vector to each point in space.

For instance, in R 3 , F ( x,y,z ) = ( F 1 ( x,y,z ) ,F 2 ( x,y,z ) ,F 3 ( x,y,z )) might represent the velocity of a fluid or the direction and magnitude of a force at each point in space. In this physical example, the value of F ( x ) at each point has both magnitude and direction, distinguishing it from a scalar field. Note, however, that in the mathematical sense, a vector field is simply a function that assigns a vector to each point in some domain, hence, strictly speaking each of the vector field components can be an independent scalar function.

While the definitions above assume the domain is Euclidean R n , they extend naturally to more general domains Ω , such as graphs or manifolds. In such cases, derivatives are interpreted using the domain’s intrinsic structure (e.g., graph gradients or Laplacians for graphs, and covariant derivatives on manifolds). We will discuss this in more depth in Section 7.

[Page 28]

What do we mean by Signals. We define signals as mappings from a domain Ω to a vector space C , whose dimensions are referred to as ‘channels’ in Deep Learning terminology. In the most general case, Ω does not necessarily possess a vector space structure. Therefore, when we use the term ‘signal’, we are referring to a vector field F : Ω → C , where C = R m and m denotes the number of channel dimensions. In physics, Ω is often Euclidean space, but in Geometric Deep Learning, it could be another non-Euclidean structure, such as a graph. If m = 1 this would be a scalar field instead. We often can vectors in C ‘feature vectors’.

# 3.3 Derivatives and Gradients

A derivative captures how a function changes with respect to a change in its input. More concretely, it quantifies the rate of change or the slope of the function at a given point.

Let f : R n → R be a smooth scalar field. A directional derivative of f at x in direction d ∈ R n is given by

$$
\partial _ { d } f ( x ) = f _ { x _ { i } } ( x ) = \lim _ { \epsilon \rightarrow 0 } \, \frac { f ( x + \epsilon d ) - f ( x ) } { \epsilon } .
$$

A partial derivative of f at x w.r.t. coordinate x i is given by

$$
\frac { \partial } { \partial x _ { i } } f ( x ) = f _ { x _ { i } } ( x ) = \lim _ { \epsilon \rightarrow 0 } \frac { f ( x _ { 1 } , \dots , x _ { i } + \epsilon , \dots , x _ { n } ) - f ( x _ { 1 } , \dots , x _ { n } ) } { \epsilon } ,
$$

and is thus a directional derivative in the direction x i .

Hence, partial derivatives are special cases of directional derivatives, where the direction aligns with the unit vector along the i -th coordinate axis.

In its simplest form, when the scalar field has a single input dimension f : R → R , the derivative f ′ ( x ) measures the rate of change of f with respect to the single variable x , and we can simply right f ′ ( x ) = d dx f ( x ) , instead of using the ∂ notation.

Numerical Methods and Approximations of the Derivative To compute derivatives in practical settings, especially when analytical expressions are unavailable, numerical methods are used. These approximations leverage finite differences to estimate derivatives.

For a scalar field f : R → R , the derivative f ′ ( x ) at a point x can be approximated using finite differences:

• Forward Difference:

$$
f ^ { \prime } ( x ) \approx \frac { f ( x + h ) - f ( x ) } { h } ,
$$

where h > 0 is a small step size.

• Backward Difference:

$$
f ^ { \prime } ( x ) \approx \frac { f ( x ) - f ( x - h ) } { h } .
$$

In this context, by smoothness we imply being at least twice continuously differentiable (often denoted as C 2 ), i.e., having continuous second-order derivatives.

The directional derivative quantifies how the function f changes as one moves from the point x in the direction specified by the vector d .

[Page 29]

• Central Difference:

$$
f ^ { \prime } ( x ) \approx \frac { f ( x + h ) - f ( x - h ) } { 2 h } .
$$

Central differences are generally more accurate, as they reduce the truncation error to O ( h 2 ) .

Finite difference methods introduce truncation errors due to the approximation of the limit. The magnitude of the error depends on the choice of h .

The Gradient The gradient is a linear functional assigning to each direction how much the function f changes in that direction.

The gradient of f is a vector-valued function ( vector field ) ∇ f : R n → R n satisfying ⟨∇ f ( x ) ,d ⟩ = ∂ d f ( x ) for all x,d ∈ R n .

We stress that vectors should be correctly treated as abstract objects rather than their coordinates in some basis. However, if one wishes to express the gradient w.r.t. to the standard basis of unit vectors { e 1 ,...,e n } on R n , this is possible by applying ⟨∇ f ( x ) ,e i ⟩ = ∂ ∂x i f ( x ) . This leads to the usual (somewhat primitive) way of thinking of the gradient as a vector of partial derivatives,

$$
\nabla f ( x ) = \left ( \frac { \partial } { \partial x _ { 1 } } f ( x ) , \dots , \frac { \partial } { \partial x _ { n } } f ( x ) \right ) .
$$

Using the gradient, one can provide a linear approximation (first-order Taylor expansion ) of f around x ,

$$
f ( x + d x ) = f ( x ) + \langle \nabla f ( x ) , d x \rangle + \mathcal { O } ( \| d x \| ^ { 2 } ) ,
$$

where dx is some infinitesimal displacement. Note the direct relation to numerical methods and the forward difference.

The Jacobian Matrix The Jacobian matrix generalizes the gradient to vector fields.

For a vector-valued function F : R n → R m , the Jacobian matrix J F ( x ) at a point x ∈ R n is defined as the matrix of all first-order partial derivatives of the components of F . That is,

$$
J _ { F } ( x ) = \left [ \frac { \partial F _ { i } } { \partial x _ { j } } \right ] _ { i = 1 , \dots , m , j = 1 , \dots , n } = \left [ \begin{array} { c c c c } \frac { \partial F _ { 1 } } { \partial x _ { 1 } } & \frac { \partial F _ { 2 } } { \partial x _ { 2 } } & \dots & \frac { \partial F _ { 1 } } { \partial x _ { n } } \\ \frac { \partial F _ { 2 } } { \partial x _ { 1 } } & \frac { \partial F _ { 2 } } { \partial x _ { 2 } } & \dots & \frac { \partial F _ { 2 } } { \partial x _ { n } } \\ \vdots & \vdots & \ddots & \vdots \\ \frac { \partial F _ { m } } { \partial x _ { 1 } } & \frac { \partial F _ { m } } { \partial x _ { 2 } } & \dots & \frac { \partial F _ { m } } { \partial x _ { n } } \end{array} \right ] .
$$

Each element of the Jacobian represents how a single component of the vector field F changes in response to a change in one of the coordinates of the domain. The Jacobian provides valuable information about the local behavior of the function, such as how the function stretches or compresses space.

The notation, O ( h 2 ) , is called ‘Big-O’ notation, and it indicates that the leading term of the truncation error is proportional to h 2 . This effectively means that the error increases quadratically as a function of the step size.

The Taylor series expansion provides a polynomial approximation of the smooth function f .

[Page 30]

# 3.4 Integrals

The integral of a function f over a domain Ω is a value that represents the total accumulation of f across Ω . For functions f : R n → R , the integral is formally defined as

$$
\int _ { \Omega } f ( x ) \, d V ,
$$

where dV denotes the infinitesimal volume element.

Integration generalizes the notion of summation to continuous domains. For scalar functions f , the integral provides a measure of how f ‘adds up’ across the domain Ω . For instance, in the case of n = 1 , integration corresponds to calculating the signed area under the curve f ( x ) over an interval. In higher dimensions, the infinitesimal volume element dV depends on the coordinate system used. For Cartesian coordinates in R n , dV = dx 1 dx 2 ··· dx n . In polar, cylindrical, or spherical coordinates, dV includes factors to account for the geometry of the domain.

Riemann Integral The Riemann integral is one of the foundational approaches to defining integration.

For a bounded function f : [ a,b ] → R , its Riemann integral is defined as the limit of Riemann sums:

$$
\int _ { a } ^ { b } f ( x ) \, d x = \lim _ { n \to \infty } \sum _ { i = 1 } ^ { n } f ( x _ { i } ^ { * } ) \Delta x _ { i } ,
$$

where [ a,b ] is divided into n subintervals of width ∆ x i , and x ∗ i is a chosen point in each subinterval.

This approach intuitively captures the idea of summing up small contributions f ( x ∗ i )∆ x i . Similar to the forward difference method for approximating derivatives, when the closedform solution to an integral is unknown, the Riemann sum is often used as a numerical approximation in computational methods.

Line and Surface Integrals Integration extends beyond volumes to lower-dimensional objects, such as curves and surfaces.

A line integral accumulates a function f along a curve C :

$$
\int _ { C } f ( x ) \, d s ,
$$

where ds is the infinitesimal arc length.

When the domain Ω is defined by bounds on individual coordinates, the multi-dimensional integral can be split into a series of one-dimensional integrals. This is known as Fubini’s theorem.

If the function is not bounded or if it presents severe discontinuities, the Riemann integral fails. We say that such functions are not Riemann integrable. Alternatives like the Lebesgue integral can handle such cases.

[Page 31]

A surface integral accumulates a function f on a S , with the infinitesimal area element dA :

$$
\int _ { S } f ( x ) \, d A .
$$

Fundamental Theorem of Calculus (FTC) The Fundamental Theorem of Calculus bridges the concepts of integration and differentiation.

Theorem 2 (Fundamental Theorem of Calculus) . In one dimension, for a function f with antiderivative F :

where b > a .

$$
\int _ { a } ^ { b } f ( x ) \, d x = F ( b ) - F ( a ) ,
$$

An anti-derivative of a function f is a function F such that F ′ = f . Note that a given function can have infinite many anti-derivatives. For instance, if F ′ ( x ) = f ( x ) then F ( x ) + C for any constant C is also an anti-derivative of f ( x ) .

# 3.5 Divergence

Let F : R n → R m be a smooth vector field , F ( x ) = ( F 1 ( x ) ,...,F n ( x )) .

The divergence of F is a scalar field div F : R n → R , satisfying

$$
\text {div} F ( x ) = \sum _ { i = 1 } ^ { n } \frac { \partial } { \partial x _ { i } } F _ { i } ( x ) \ \equiv \ \nabla \cdot F .
$$

Thinking of F ( x ) as a flow around x , the divergence can be given the interpretation of the density of an outward flux from an infinitesimal volume around x .

Theorem 3 (Gauss-(Ostrogradsky-Stokes) or simply Divergence theorem) . Let Ω ⊆ R n be a region in space with boundary ∂ Ω . Then,

$$
\int _ { \Omega } d i v F d V = \int _ { \partial \Omega } \langle F , \hat { n } \rangle d S ,
$$

where ˆ n ( x ) denotes the unit normal vector to the boundary surface ∂ Ω at point x on thereon.

Note that in the above theorem one assumes that Ω is a smooth region and likewise F is a sufficiently smooth vector field (at least continuously differentiable).

The divergence theorem is a mathematical statement of the physical conservation law that, in the absence of the creation or destruction of matter, the density within a region of space can change only by having it flow into or away from the region through its boundary.

In a sense, the divergence does an operation 'opposite' to that of the gradient; in fact, the The unit normal vector ˆ n ( x ) is a vector of length 1 that is perpendicular to the tangent plane of the boundary ∂ Ω at point x . Its direction is chosen conventionally to point outward from Ω unless stated otherwise. The boundary integral ∫ ∂ Ω represents integration over the boundary surface ∂ Ω . The scalar product ⟨ F, ˆ n ⟩ measures how the vector field F aligns with the normal direction, while dS indicates the infinitesimal surface area element on ∂ Ω .

[Page 32]

two operators are adjoint w.r.t. the appropriate inner products defined on the spaces of scalar and vector fields:

$$
\langle \nabla f , F \rangle = - \langle f , d i v F \rangle .
$$

More concretely, let Ω ⊂ R n be a bounded domain with smooth boundary ∂ Ω . Define inner products, for scalar fields f,g ∈ C ∞ (Ω) :

$$
\langle f , g \rangle _ { L ^ { 2 } ( \Omega ) } = \int _ { \Omega } f g \, d x ,
$$

and or vector fields F,G ∈ [ C ∞ (Ω)] n :

$$
\langle F , G \rangle _ { L ^ { 2 } ( \Omega ) } = \int _ { \Omega } F \cdot G \, d x .
$$

The left side of the original expression expands as:

$$
\langle \nabla f , F \rangle _ { L ^ { 2 } ( \Omega ) } = \int _ { \Omega } \nabla f \cdot F \, d x = \int _ { \Omega } \sum _ { i = 1 } ^ { n } \frac { \partial f } { \partial x _ { i } } F _ { i } \, d x
$$

Let us apply integration by parts to each term in the summation above:

$$
\int _ { \Omega } \frac { \partial f } { \partial x _ { i } } F _ { i } \, d x = \int _ { \Omega } f F _ { i } d x - \int _ { \Omega } f \frac { \partial F _ { i } } { \partial x _ { i } } \, d x = \int _ { \partial \Omega } f F _ { i } \hat { n } _ { i } \, d S - \int _ { \Omega } f \frac { \partial F _ { i } } { \partial x _ { i } } \, d x ,
$$

where the boundary terms comes from the divergence theorem (Theorem 3) and we transition from the volume element dx to the surface element dS . Summing over i from 1 to n : n

$$
\langle \nabla f , F \rangle _ { L ^ { 2 } ( \Omega ) } = \int _ { \partial \Omega } f ( F \cdot \hat { n } ) \, d S - \int _ { \Omega } f \sum _ { i = 1 } ^ { n } \frac { \partial F _ { i } } { \partial x _ { i } } \, d x .
$$

Since div F = ∇ · F =   n i =1 ∂F i ∂x i :

$$
\langle \nabla f , F \rangle _ { L ^ { 2 } ( \Omega ) } = \int _ { \partial \Omega } f ( F \cdot \hat { n } ) \, d S - \int _ { \Omega } f ( \text {div} F ) \, d x .
$$

The boundary term vanishes under any of these conditions:

- • Dirichlet boundary condition: f | ∂ Ω = 0
- • F | ∂ Ω = 0
- • Normal component vanishes: F · n | ∂ Ω = 0
- • If Ω = R n and F decays faster than ∥ x ∥ − n as ∥ x ∥ → ∞


Adopting any of the above:

$$
\langle \nabla f , F \rangle _ { L ^ { 2 } ( \Omega ) } = \int _ { \partial \Omega } f ( F \cdot \hat { n } ) \, d S - \int _ { \Omega } f ( \text {div} F ) \, d x = 0 - \int _ { \Omega } f ( \text {div} F ) = - \langle f , \text {div} F \rangle _ { L ^ { 2 } ( \Omega ) } .
$$

The negative sign in the adjoint relationship does not prevent them from being adjoint operators; however, we sometimes refer to such operators as skew-adjoint operators to distinguish them from the perhaps more standard positive case.

[Page 33]

# 3.6 Laplacian

The Laplacian operator is a measure of how a function behaves locally in terms of its rate of change.

The Laplacian of a scalar field f is given by

$$
\Delta f ( x ) = \text {div} \nabla f .
$$

The quadratic functional ⟨ f, ∆ f ⟩ = ⟨∇ f, ∇ f ⟩ , known in physics as the Dirichlet energy , is a measure of how variable the function f is.

Theorem 4. The Laplacian is rotation-invariant.

Proof. Write the Laplacian as the trace of the Hessian, ∆ f ( x ) = tr( ∇ 2 f ( x )) . Note that when representing the Hessian as a matrix w.r.t. the standard basis, its diagonal contains second order derivatives ∂ 2 ∂x 2 i f ( x ) :

$$
\nabla ^ { 2 } f ( x ) = \begin{bmatrix} \frac { \partial ^ { 2 } f ( x ) } { \partial x _ { 1 } ^ { 2 } } & \cdots & \frac { \partial ^ { 2 } f ( x ) } { \partial x _ { 1 } \partial x _ { n } } \\ \vdots & \ddots & \vdots \\ \frac { \partial ^ { 2 } f ( x ) } { \partial x _ { n } \partial x _ { 1 } } & \cdots & \frac { \partial ^ { 2 } f ( x ) } { \partial x _ { n } ^ { 2 } } \end{bmatrix}
$$

Let Ax be some transformation of coordinates. Then, applying the chain rule, we have

$$
\begin{array} { r l r } { \nabla _ { x } f ( A x ) } & = } & { A ^ { \top } \nabla _ { A x } f ( A x ) } \\ { \nabla _ { x } ^ { 2 } f ( A x ) } & = } & { A ^ { \top } \nabla _ { A x } ^ { 2 } f ( A x ) A . } \end{array}
$$

Assuming A is an orthogonal matrix ( AA ⊤ = A ⊤ A = I ) and using matrix commutativity under trace we get

$$
\Delta _ { x } f ( A x ) \ & = \ \ t r ( A ^ { \top } \nabla _ { A x } ^ { 2 } f ( A x ) A ) \\ & = \ \ t r ( \nabla _ { A x } ^ { 2 } f ( A x ) A A ^ { \top } ) \\ & = \ \ t r ( \nabla _ { A x } ^ { 2 } f ( A x ) ) = \Delta _ { A x } f ( A x )
$$

This invariance suggests that the behavior of the Laplacian does not depend on the specific orientation of the coordinate system, but rather on the intrinsic geometry of the scalar field itself.

# 3.7 Gradient Descent Optimization in Deep Learning

In Deep Learning, gradients play a central role in training models, that is, in optimizing the parameters of artificial neural networks. Although we have not yet introduced artificial neural networks properly, we can think of them as mapping functions (vector fields) F ( x ; w ) : R n → R m parametrized by a set of weights (and biases) w .

It is common to define the Laplacian as − div ∇ f , to make it a positive-semidefinite operator.

The trace of a product of matrices has the property tr ( XY ) = tr ( Y X ) .

When transforming coordinates, a change of basis can be represented by multiplying by a matrix A . If A is an orthogonal matrix, the transformation does not distort the geometry of the space, that is, distances and angles remain unchanged. This is a necessary condition for the invariance of the Laplacian under rotation.

[Page 34]

Loss Functions as Scalar Fields A loss function can be thought of as a scalar field, L ( w ) , where w represents the model parameters. The loss function assigns a scalar value that indicates how well the model performs. In supervised learning , this is generally computed with respect to some reference ground truth prediction

$$
\mathcal { L } ( w ) = \mathcal { L } ( F ( x ; w ) , \hat { y } ) ,
$$

where ˆ y is the ground truth (or the label), F ( x ; w ) represents the artificial neural network output (or prediction), and the loss is, for instance, the mean squared error loss in some regression tasks. Note, however, that the exact setup is task dependent, and more generally we can think of the loss function as returning a scalar based on the artificial neural network parameters w .

A loss function L ( w ) is a scalar field that assigns a scalar value to each set of parameters w , quantifying the model’s error.

Just like in vector calculus, we are interested in how L ( w ) changes with respect to small changes in the parameters w . This is captured by the gradient of L ( w ) , denoted as ∇L ( w ) . The gradient tells us the direction and rate at which the loss function increases most rapidly. By adjusting the parameters in the opposite direction of the gradient (steepest descent), we can minimize the loss.

![image 10](<BordeBronstein2025/imageFile10.png>)

Figure 7: Example loss landscape visualization for a neural network.

Gradient Descent Optimization Gradient descent is the most common optimization method used in Deep Learning .

Gradient descent leverages the gradient ∇L ( w ) of the loss function to adjust the parameters of a parametrized model in order to minimize the loss,

$$
w _ { t + 1 } = w _ { t } - \eta \nabla \mathcal { L } ( w _ { t } ) ,
$$

where w t are the model parameters at iteration (or time step) t , η is the learning rate, a scalar that controls the step size, and ∇L ( w t ) is the gradient of the loss function with respect to the parameters at w t .

The gradient guides the model parameters toward a local minimum of the loss. Using this procedure we ‘translate the weights in space’, from an initial random configuration to a

Typically stochastic gradient descent (SGD) is mentioned as the optimization technique of choice in most textbooks. However, in contemporary Deep Learning more modern variations of SGD are used, such as the AdamW optimizer.

[Page 35]

suitable location that is able to model the data with low error. That is, the final weight configuration is a able to mimic the patterns present in the data.

The Curse of Optimization. Finding global optima of generic high dimensional functions is NP-hard. Then, one may ask: How can we overcome this curse in optimization? In Geometric Deep Learning we argue that we can try to leverage the underlying low-dimensional structure of the input high-dimensional space. In particular, the geometric domain in which the signal lives provides new notions of regularity that can be exploited for more efficient learning.

Backpropagation and the Chain Rule The gradient of the loss function with respect to the model parameters is typically computed using backpropagation . This method relies on the chain rule of calculus to propagate gradients through the network.

Given a point x ∈ R n , the composition of two vector fields f : R n → R m and g : R m → R p is written as g ◦ f ( x ) = g ( f ( x )) , which represents the transformation of x through both functions f and g .

The chain rule states that given two vector fields f : R n → R m and g : R m → R p and their respective Jacobian matrices J f and J g , the derivative of their composition is given by the matrix product:

$$
\frac { d } { d x } \left ( g \circ f ( x ) \right ) = J _ { g } ( f ( x ) ) \cdot J _ { f } ( x )
$$

Artificial neural networks are composed of multiple layers, which can be understood in terms of function composition. The gradient of the loss function L with respect to each layer’s weights is computed iteratively:

$$
\nabla _ { w ^ { ( l ) } } \mathcal { L } = J _ { L } ( a ^ { ( L ) } ) \cdot J _ { a ^ { ( L ) } } ( a ^ { ( L - 1 ) } ) \cdot \dots \cdot J _ { a ^ { ( l + 1 ) } } ( w ^ { ( l ) } )
$$

where a ( l ) is the activation (the output of an intermediate transformation) of the l -th layer. The Jacobian-based representation can handle cases where activations or transformations are vector-valued, which is typically the case in Deep Learning (technically we work with tensors which becomes even more complex). In the scalar or element-wise gradient context, we can rewrite the expression above as

$$
\nabla _ { w ^ { ( l ) } } \mathcal { L } = \frac { \partial \mathcal { L } } { \partial a ^ { ( L ) } } \cdot \frac { \partial a ^ { ( L ) } } { \partial a ^ { ( L - 1 ) } } \cdot \dots \cdot \frac { \partial a ^ { ( l + 1 ) } } { \partial w ^ { ( l ) } } ,
$$

which may be more accessible to readers less familiar with matrix calculus.

Backpropagation uses the chain rule to compute gradients of the loss function with respect to each layer’s weights, which are then used to update the weights of artificial neural networks in an iterative fashion.

[Page 36]

Vector Calculus and the Laplacian in Geometric Deep Learning. Beyond other use cases of the gradient such as in gradient descent optimization, in Geometric Deep Learning, the Laplacian is often used to understand the smoothness of functions defined on graphs or manifolds. These structures, such as the vertices and edges of a graph, or the points on a surface, require modifications of traditional calculus tools to account for the inherent irregularities of the data. Hence, vector calculus is not only foundational in classical analysis but are also key components in the development of algorithms for learning over non-Euclidean data.

[Page 37]

# 4 Topological Foundations and Differential Geometry

As we have seen so far, normed spaces add the ability to measure the length or magnitude of vectors. Metric spaces then enter the picture, with their additional structure allowing us to measure how far apart elements are, just as we measure distances in everyday space. And finally, inner products complete this geometric toolkit by defining angles between elements, enabling us to determine when vectors are perpendicular or parallel, for instance.

Students are often first introduced to this geometric foundations rather than topology [9, 10], because the former deal with tangible aspects of space, which are familiar in our everyday lives. However, this focus on geometry can sometimes overshadow topology, a more abstract field that underpins many concepts in geometry and other areas of mathematics. In essence, topology is concerned with connectivity and studies properties of space that remain unchanged under continuous deformations, such as stretching and bending. Topological spaces can later be augmented with additional structures to measure geometric quantities, such as a metric.

A solid understanding of topology provides deeper insights into the nature of space and is fundamental for grasping more advanced mathematical and scientific concepts. Therefore, in this section, we take a step back to introduce the reader to basic concepts in topology, with a particular focus on manifolds, which are central to many Geometric Deep Learning generalizations of traditional neural network models. We then complement this discussion by presenting key ideas from differential [11] and Riemannian geometry [12]. The text is kept succinct, with the goal of familiarizing the reader with the main concepts without going into excessive depth.

# 4.1 A Brief Introduction to Topology

Historical Context The word topology was coined by Johann Benedict Listing, a German mathematician, in his 1847 book Vorstudien zur Topologie , although he used the word as early as 1836 in correspondence. The etymology of the word stems from the Greek ‘topos’, meaning ‘location’ or ‘place’, and the suffix ‘-logy’ for ‘study of’. Topology was initially conceived as a type of geometry that focused on properties preserved under much more flexible transformations than those allowed in Euclidean or other specific geometries. It is often called ‘rubber-sheet geometry’ to illustrate this idea: one can stretch and deform the ‘rubber sheet’, but you cannot tear it or glue parts together. The French Henri Poincar´ e, with his Analysis Situs series of papers starting in 1895, is largely credited with establishing topology as a coherent and independent field. Indeed, nowadays geometry and topology are considered two separate branches of mathematics, concerned with measurement and connectedness, respectively, as we have repeatedly emphasized in this text.

Sets as a Collection of Objects with no Connectedness As previously discussed in Section 1, a set is a collection of distinct elements and has no structure beyond membership. For example, the set of points in the plane R 2 can be written using the set builder notation as follows:

$$
\mathbb { R } ^ { 2 } = \{ ( x , y ) \ | \ x , y \in \mathbb { R } \} .
$$

Differential geometry and Riemannian geometry are closely related, but they are not the same. Differential geometry is the general study of geometry using calculus and linear algebra. It deals with smooth manifolds and smooth maps between them. On the other hand, Riemannian geometry is a special case of differential geometry where the manifold is equipped with a Riemannian metric.

[Page 38]

This is simply a collection of points. Thus, there is no notion of ‘closeness’ or ‘nearness’ between points: the points are not connected in any way. For instance, the point (0 , 0) is neither closer to (0 , 1) nor to (10 , 10) because the elements of the set are considered unordered and unrelated beyond membership.

When we introduce a structure to this set, such as connectedness or topology , we begin to impose rules on how the points are related. For example, we can define which sets of points are considered ‘close’ to each other or which subsets of R 2 are ‘open’. This, in turn, leads to a concept of continuous connection among points.

Open Intervals and Open Sets In the context of the real line R , an open interval is a set of points that does not include its boundary points. For example, the open interval ( a,b ) is the set of points x such that:

$$
a < x < b .
$$

This interval contains all points between a and b , but does not include a and b themselves. In a more general setting, a set U is called open if it contains a ‘neighborhood’ around each of its points. This means that for every point x ∈ U , there is a small region around x that is entirely contained within U .

![image 11](<BordeBronstein2025/imageFile11.png>)

X1

Xz

Figure 8: Point x 1 has an open neighborhood fully contained in U , while point x 2 , located on the boundary, does not.

In the context of metric spaces, this is formalized as follows:

Let ( X,d ) be a metric space, where d is the distance function. A subset U ⊆ X is open if, for every point x ∈ U , there exists a radius r > 0 such that the open ball B ( x,r ) = { y ∈ X | d ( x,y ) < r } is entirely contained within U .

Although the above definition is perhaps intuitive, it relies on a distance function. Actually, open sets can also be defined without relying on a metric space, and purely in terms of set theory, as we will see next.

Topological Spaces The concept of open sets can be generalized in the context of topological spaces. A topological space is defined as a set X together with a collection of subsets T (called open sets ) that satisfy certain properties. These properties ensure that the notion of ‘openness’ is well-behaved.

[Page 39]

Let X be a set, and T ⊆ P ( X ) the power set of X . Then T is a topology on X if:

- • ∅ ,X ∈ T ,
- •   α ∈ A U α ∈ T , for any collection { U α } α ∈ A ⊆ T ,
- •   n i =1 U i ∈ T , for any finite collection { U i } n i =1 ⊆ T .


These conditions specify the following: the empty set and the entire set X must be included in T , arbitrary unions of open sets must be open, and finite intersections of open sets must be open. Note that T is a set of subsets.

The pair ( X, T ) is called a topological space . Elements of X are referred to as points , and elements of T are called open sets .

A subset U ⊆ X is called open if U ∈ T .

Open sets are a generalization of intervals in R , which are open in the sense that they do not include their boundary points. Metric spaces are specific examples of topological spaces, and, similarly, open balls in a metric space are examples of open sets.

# Examples of Topological Spaces

• Euclidean Topology: For X = R n , the standard topology is generated by open balls. An open ball in R n centered at x ∈ R n with radius r > 0 is defined as

$$
B ( x , r ) = \{ y \in \mathbb { R } ^ { n } \colon \| x - y \| < r \} .
$$

The topology T in this case is the collection of all open sets that can be expressed as arbitrary unions of open balls. That is,

$$
\mathcal { T } = \left \{ U \subseteq \mathbb { R } ^ { n } \colon U = \bigcup _ { \alpha \in A } B ( x _ { \alpha } , r _ { \alpha } ) \text { for some index set } A \right \} ,
$$

where each B ( x α ,r α ) = B α is an open ball.

- • Discrete Topology: In the discrete topology, every subset of X is open. Therefore, for any set X , the topology T is the power set of X , i.e.,

$$
\mathcal { T } = \mathcal { P } ( X ) = \{ U \subseteq X \, \colon U \text { is a subset of } X \} .
$$

- • Trivial Topology: In the trivial topology, only the empty set ∅ and the entire set X are open. Therefore, the topology T is


$$
\mathcal { T } = \{ \emptyset , X \} .
$$

The discrete topology is the finest topology because every subset of the space is an open set, making it the topology with the most open sets. In contrast, the trivial topology is the coarsest possible topology, as it contains the fewest open sets.

The symbols A ∪ B and A ∩ B refer specifically to the union and intersection of two sets, A and B . In contrast, α ∈ A U α and   α ∈ A U α are more general notations used to describe the union or intersection of a collection of sets { U α } α ∈ A , where the index α ranges over some set A . Also, note that the notation in the definition differs to highlight the axioms: any union   α ∈ A of open sets is open, but only finite intersections   n i =1 are required to be open. The indices reflect this arbitrary vs. finite condition.

[Page 40]

![In this image, we can see a diagram.](<BordeBronstein2025/imageFile12.png>)

B

B5

Figure 9: Illustration of an open set U defined as the union of open balls, U = B 1 ∪ B 2 ∪ B 2 ∪ B 3 ∪ B 4 ∪ B 5 ∪ ... . Each dashed circle represents an open ball B α , demonstrating how open sets in Euclidean topology are constructed.

# 4.2 Topological Equivalences

Topology studies properties of spaces that are invariant under any continuous deformation.

Continuity Continuous maps between topological spaces do not ‘break’ the space, meaning that small changes in the input correspond to small changes in the output, without any sudden jumps or gaps. In other words, the map allows the space to be deformed without tearing it and it preserves the structure of the space, enabling smooth transitions from one point to another.

A map F : X → Y between topological spaces is continuous if for every open set U ∈ T Y , the preimage F − 1 ( U ) is an open set in X , i.e., F − 1 ( U ) ∈ T X .

Homeomorphisms and Homotopy A homeomorphism is a special type of continuous map that has a continuous inverse.

A map F : X → Y is a homeomorphism if it is bijective, continuous, and its inverse F − 1 : Y → X is also continuous.

When such a map between two topological spaces exists, we say that X and Y are homeomorphic , meaning they are topologically equivalent. For example, the surface of a sphere and that of a cube are homeomorphic, as one can be continuously deformed into the other without tearing or gluing. Note that a homeomorphism is a strong equivalence and denotes that there is a one-to-one correspondence between points in the spaces.

On the other hand, two spaces are homotopic (or homotopy equivalent ) if one can be continuously deformed into the other through a process called homotopy . This is a weaker This definition of continuity does not require the notion of limits, as in the classical sense, but instead relies purely on the topological structure of the spaces involved.

It is quite common to confuse homeomorphisms with homomorphisms. A homomorphism is a structure-preserving map between two algebraic structures of the same type, as we saw earlier for groups. In contrast, a homeomorphism is a bijective map between two topological spaces that is continuous and has a continuous inverse. In short, homomorphisms pertain to algebra, while homeomorphisms arise in the context of topology.

[Page 41]

![image 13](<BordeBronstein2025/imageFile13.png>)

Figure 10: The cube and the sphere are homeomorphic: they are both simply connected (no holes) and can be continuously deformed into each other.

equivalence than homeomorphism since it allows for more general deformations such as collapsing or stretching parts of the space. For example, a circle and a point are homotopy equivalent because the circle can be continuously shrunk to a single point.

![image 14](<BordeBronstein2025/imageFile14.png>)

Figure 11: Visualization of circle shrinking into a point. The map between them is surjective, but not injective since all points on the circle are mapped (or collapsed) into the same single point.

Discrete geometric representations, such as meshes or graphs, can also approximate topological features like homotopy, allowing us to reason about how shapes deform, connect, or contain loops, even in combinatorial settings. We will look at discrete representations later, in Section 7.

Euler Characteristic The Euler characteristic is a topological invariant that assigns a numerical value to a topological space. It is defined for a variety of spaces, both continuous (like surfaces) and discrete (like polyhedra), and remains unchanged under homeomorphisms (but not necessarily under homotopy equivalence). That is, if two spaces are topologically equivalent, they share the same Euler characteristic, regardless of differences in their geometric shape or size. For a closed surface (compact surfaces without boundary), the Euler characteristic can be computed using the genus , which represents the number of ‘holes’ (or ‘handles’) in the surface. For example, a sphere and a cube both have an Euler characteristic of 2, even though their geometric structures are quite different. On the other hand, a sphere and a point are homotopy equivalent (in the weak sense), but their Euler characteristics are different (2 and 1, respectively). While this text does not delve into the detailed calculation of the Euler characteristic (often done via homology), it is worth highlighting that there are methods for quantifying the equivalence of spaces based solely on their connectivity, entirely disregarding their geometric details.

# 4.3 Manifolds and Differential Geometry

Manifolds are mathematical objects used to describe and generalize to spaces that may not have a simple, flat, Euclidean structure. Indeed, many natural phenomena occur in spaces (or domains ) that are curved.

The collapsing of a circle to a point is an example of a homotopy, not a homeomorphism, precisely because the inverse operation is not continuous. While the forward map (circle to point) can be considered continuous, if one were to start from a single point and try to map it back to a circle, it would require ‘expanding’ that single point into an entire circle. A single point has dimension 0, while a circle has dimension 1. A continuous inverse would imply that a point is topologically equivalent to a circle, which is not true.

A polyhedron (plural: polyhedra) is a three-dimensional solid whose boundary consists of polygons.

![image 15](<BordeBronstein2025/imageFile15.png>)

For instance, the Platonic solids displayed above are a special, highly symmetric class of convex polyhedra characterized by faces that are all congruent regular polygons, with the same number of faces meeting at each vertex. All of them have an Euler characteristic of 2. Interestingly, they are named ‘Platonic’ after the ancient Greek philosopher Plato (despite also being studied by Theaetetus and Euclid), due to his role in associating them with the classical elements of fire, earth, air, and water in his cosmological theories.

[Page 42]

Non-Euclidean Geometry and Historical Background Since Euclid of Alexandria (c. 300 BC) stated the fifth postulate—later renamed the parallel postulate or axiom of parallels—in his famous work Elements , it was accepted for two thousand years that through a point exterior to a given line, one and only one parallel line could be drawn , and that no logically consistent alternative to his geometric framework could exist. After numerous failed attempts at deriving this postulate from the previous four, mathematicians started exploring geometries for which the fifth postulate did not hold. They found that it was possible to construct logically consistent frameworks that did not satisfy the postulate, giving rise to, for instance, elliptical (or spherical; the differences are subtle and outside the scope of this text) and hyperbolic geometry. In these frameworks, our common notion of a line is replaced by the shortest path between two points while remaining on the surface of the space at hand: the geodesic. The aforementioned geometries are characterized by their geodesic dispersion: in elliptical geometry, initially parallel geodesics eventually converge, whereas in hyperbolic geometry, they diverge exponentially, unlike in Euclidean geometry where they remain equidistant (the space is flat).

But these were not the only examples. For instance, projective geometry, which formalizes the principles of perspective projection, notably treating parallel lines as meeting at ‘points at infinity’ and focusing on properties invariant under projection, was inspired by the arts. The emergence of these varied and equally consistent geometric systems prompted a fundamental question: what truly defines ‘geometry’? It was not until Felix Klein (aided by insights from his discussions with Sophus Lie) proposed a unifying framework in his Erlangen Program (1872) that geometry came to be understood not merely by its objects (points, lines) but as the study of properties that remain invariant under a specified group of transformations.

![image 16](<BordeBronstein2025/imageFile16.png>)

Manifold

geodesic

Figure 12: The geodesic is the shortest path between the two points, while staying on the curved 2-dimensional surface: it is not a straight line.

Topological Manifolds To understand manifolds, we begin with the simplest notion of a topological manifold, which captures the idea of spaces that locally resemble Euclidean space. From there, we can progressively add more structure to these spaces, eventually obtaining smooth manifolds, which allow for calculus and differential geometry, and Riemannian manifolds, which introduce a way to measure distances and angles.

A manifold is a topological space that locally resembles Euclidean space.

A topological space M is an n -dimensional (topological) manifold if for every point p ∈ M , there exists an open neighborhood U ⊆ M and a homeomorphism φ : U → R n .

Euclid’s monopoly came to an end in the 19th century, with a remarkable burst of creativity that made geometry arguably the most exciting field of mathematics, primarily through the work of pioneers like Gauss, Bolyai, Lobachevsky, Riemann, and Beltrami. However, one of the first attempts at questioning Euclid’s fifth postulates dates back to the Italian mathematician Girolamo Saccheri (1667-1733) in his work Euclides ab omni naevo vindicatus .

![image 17](<BordeBronstein2025/imageFile17.png>)

Renaissance artists, such as the Florentine Leonardo da Vinci and the German Albrecht D¨ urer, sought techniques to represent the three-dimensional world realistically on a two-dimensional surface like the canvas. D¨ urer, in particular, not only produced a large body of paintings but also authored written treatises on geometry related to this challenge. Below we display da Vinci’s The Last Supper , a classic example.

![image 18](<BordeBronstein2025/imageFile18.png>)

Note that a ‘basic’ manifold (topological or even smooth) does not inherently come equipped with a way to measure distances, angles, or curvature. Here, we are primarily concerned about the structure and connectivity of the space and its local resemblance to Euclidean (flat) space. On the other hand, geometry is about the study of measurement and properties on the space.

[Page 43]

M

U

α

U

β

n

R

φ

α

-

1

φ

α

-

1

φ

β

φ

β

n

R

φ

(

U

)

α

α

ψ

αβ

φ

(

U

)

β

β

Figure 13: Illustration of a manifold M with overlapping open subsets U α and U β . Each has a corresponding chart, represented by a homeomorphism φ α and φ β , mapping it onto an open subset of the Euclidean space, R n . The transition map ψ αβ = φ β ◦ φ − 1 α describes how these charts relate to each other on their overlapping regions.

Manifolds can be classified based on their dimensionality, such as curves (1-dimensional manifolds), surfaces (2-dimensional manifolds), and higher-dimensional manifolds. They are the central objects in differential geometry and are fundamental in the study of geometry and physics, particularly in general relativity.

The local homeomorphisms between a manifold and Euclidean space are called charts . A collection of charts that cover the entire manifold is called an atlas .

An atlas for a manifold M is a collection of charts { ( U α ,φ α ) } , where U α is an open subset of M and φ α : U α → R n is a homeomorphism. The charts must be compatible, meaning that the transition maps ψ αβ = φ β ◦ φ − 1 α are homeomorphisms on their domains of overlap.

Smooth Manifolds A smooth manifold is a topological manifold equipped with a smooth structure. This means that, in addition to the local homeomorphisms to Euclidean space, the transition maps between overlapping neighborhoods are differentiable. More formally:

A topological space M is an n -dimensional smooth manifold if for every pair of points p,q ∈ M , there exist open neighborhoods U α ⊆ M around p and U β ⊆ M around q such that the transition map between the homeomorphisms φ α : U α → R n and φ β : U β → R n is a smooth (infinitely differentiable) map.

The smooth structure of these manifolds allows for the definition of smooth functions, smooth curves, and other objects in differential geometry, making them central to the study of calculus on manifolds.

Diffeomorphisms Diffeomorphisms allow for the transfer of geometric and differential properties between manifolds that share similar local structures.

In relativity, the manifold used to model the universe is a 4-dimensional Lorentzian manifold, which is commonly referred to as spacetime.

The term ‘atlas’ in mathematics draws an analogy to a collection of maps used in geography. Just as a geographic atlas contains individual maps that collectively describe different regions of the Earth’s surface, an atlas on a manifold consists of charts that collectively describe the manifold’s structure.

![image 19](<BordeBronstein2025/imageFile19.png>)

Lie groups are both groups and (smooth) manifolds.

[Page 44]

A map between two manifolds φ : M → N is a diffeomorphism if: φ is smooth (infinitely differentiable), φ is bijective, and φ − 1 : N → M is also smooth.

While both homeomorphisms and diffeomorphisms are bijections that preserve certain structures, homeomorphisms preserve topological properties (such as continuity and connectedness), whereas diffeomorphisms preserve smooth (differentiable) structures.

Tangent Spaces and Bundles The tangent space is a key concept for understanding the local geometry of the manifold.

Given a smooth manifold M and a point p ∈ M , the tangent space at p , denoted T p M , is a vector space that represents the possible directions in which one can move away from p . Formally, it is the space of equivalence classes of smooth curves passing through p .

The tangent bundle of a smooth manifold M , denoted T M , is the disjoint union of all tangent spaces of M :

$$
T \mathcal { M } = \bigsqcup _ { p \in \mathcal { M } } T _ { p } \mathcal { M } .
$$

Each point ( p,v ) ∈ T M consists of a point p ∈ M and a tangent vector v ∈ T p M .

![image 20](<BordeBronstein2025/imageFile20.png>)

space

Tangent =

Manifold

Figure 14: Illustration of the tangent space T p M at a point p on the manifold M . The tangent space is a flat, vector-space approximation of the manifold at p .

Riemannian Manifolds A Riemannian manifold is a smooth manifold equipped with a Riemannian metric, which is a smoothly varying inner product on the tangent spaces of the manifold. Formally:

To project points from the tangent space to the manifold and back we use exponential and logarithmic maps.

  refers to the disjoint union, whereas   is used to denote the regular union. The former preserves the identity of the original sets, treating overlapping elements as distinct. On the other hand, the latter merges sets, discarding duplicate elements. In the context of the definition of tangent bundles,   is used to emphasize that the tangent spaces at different points of the manifold are distinct and should be treated as separate entities, even if they may have overlapping elements.

“Manifolds in which, as in the plane and in space, the line-element may be reduced to the form     dx 2 , are therefore only a particular case of the manifolds to be here investigated; they require a special name, and therefore these manifolds in which the square of the line-element may be expressed as the sum of the squares of complete differentials I will call

[Page 45]

A smooth manifold M is a Riemannian manifold if it is equipped with a Riemannian metric, which is a smooth assignment of an inner product on the tangent space at each point p ∈ M , i.e., a map g p : T p M × T p M → R that is smooth in p , where T p M is the tangent space at p . We typically denote the Riemannian manifold as a tuple ( M ,g ) .

![image 21](<BordeBronstein2025/imageFile21.png>)

Figure 15: The sphere is an example of a Riemannian manifold, locally resembling Euclidean space. Indeed, when walking on the surface of the Earth, it appears flat. We can define functions on this manifold to characterize various phenomena, such as the distribution of atmospheric pressure or the velocity of the wind.

The Riemannian metric enables the measurement of distances between points and the definition of geodesics.

A geodesic on a Riemannian manifold is a curve which locally minimizes the distance between points.

In our day-to-day, we often say that ‘the shortest path between two points is always a straight line’, and this is true for flat Euclidean space. However, in more general spaces, geodesics may not be straight lines. For example, when connecting two points on the surface of a sphere, the shortest path is an arc of a great circle.

Exponential and Logarithmic Maps For any point p on a Riemannian manifold ( M ,g ) , as previously discussed, the tangent space T p M is a vector space that locally approximates the manifold. A fundamental tool in differential geometry is the exponential map at p :

The exponential map ,

$$
\exp _ { p } \colon T _ { p } \mathcal { M } \rightarrow \mathcal { M } ,
$$

takes a tangent vector v ∈ T p M and returns a point on the manifold reached by following the unique geodesic starting at p in the direction v for a distance equal to the norm ∥ v ∥ .

Next, we provide an example. Let p = (0 , 0 , 1) ∈ S 2 ⊂ R 3 be the north pole of the unit sphere, and let v = ( ϵ, 0 , 0) ∈ T p S 2 be a small tangent vector. Note that T p S 2 consists of all vectors in R 3 that are perpendicular to p :

$$
T _ { p } S ^ { 2 } = \{ v \in \mathbb { R } ^ { 3 } \, | \, v \cdot p = 0 \} = \{ ( x , y , 0 ) \in \mathbb { R } ^ { 3 } \} .
$$

The sphere in particular is both a homogeneous manifold and has constant curvature . Without getting into formal definitions, a homogeneous manifold is a manifold with a high degree of symmetry, where the manifold looks the same at every point. A manifold is a constant curvature manifold if its curvature (a measure of how the manifold bends in space) is the same at every point. Note that, more generally, manifolds can have variable curvature and very intricate structures, and that homogeneous manifolds with constant curvature, as well as products thereof, are simply easier-to-study special cases. See below an example of variable-curvature Riemannian geometry on manifolds.

![image 22](<BordeBronstein2025/imageFile22.png>)

Here, we only aim to provide the intuitive idea behind the concept of geodesics. For a more mathematically rigorous understanding of geodesics one would need to introduce the geodesic equation, which is derived from the principle of least action applied to the length of a curve. This relies on presenting concepts such as metric tensors, Euler-Lagrange equations, and Christoffel symbols, which we omit for simplicity.

[Page 46]

![image 23](<BordeBronstein2025/imageFile23.png>)

space

Tangent =

exp

Manifold

Figure 16: Illustration of the exponential map exp p , mapping a tangent vector v at point p in the tangent space T p M to a point exp p ( v ) on the manifold M . This mapping is realized by following the geodesic starting at p in the direction of v for a distance equal to ∥ v ∥ .

Since geodesics on S 2 are great circles, the geodesic starting at p in the direction of v can be expressed as: γ ( t ) = cos( t ) p + sin( t ) ˆ v, where ˆ v = v ∥ v ∥ = (1 , 0 , 0) . Evaluating this at t = ∥ v ∥ = ϵ gives:

$$
\exp _ { p } ( v ) = \cos ( \epsilon ) \left ( 0 , 0 , 1 \right ) + \sin ( \epsilon ) \left ( 1 , 0 , 0 \right ) = \left ( \sin ( \epsilon ) , 0 , \cos ( \epsilon ) \right ) .
$$

For small ϵ , this is approximately:

$$
\exp _ { p } ( v ) \approx ( \epsilon , 0 , 1 - \frac { \epsilon ^ { 2 } } { 2 } ) ,
$$

which captures the fact that the sphere is locally well-approximated by a flat plane.

The logarithmic map ,

$$
\log _ { p } \colon \mathcal { M } \rightarrow T _ { p } \mathcal { M } ,
$$

is the local inverse of the exponential map. It maps a point q ∈ M (sufficiently close to p ) to the tangent vector v ∈ T p M such that exp p ( v ) = q . In other words, it returns the initial velocity of the geodesic starting at p and reaching q .

These tools allow us to conduct operation in the locally flat tangent space and to project point from and back to it.

Embedding Latent Representations into non-Euclidean Manifolds using the Exponential Map. For instance, in the context of embedding hierarchical representations, the exponential map can be employed to project the output of an encoder onto a specific manifold, such as the Poincar´ e ball. Initially, one applies multiple non-linear transformations to the input (encoder), obtaining latent representations that (are assumed to) reside in a Euclidean space. Subsequently, these representations are mapped onto the desired manifold via the exponential map.

The Poincar´ e ball is a model of hyperbolic geometry represented as a unit ball, where distances grow infinitely as one approaches the boundary. In 2D we often refer to it as the Poincar´ e disk instead.

[Page 47]

Tangent Vector Fields In the context of Geometric Deep Learning, tangent vector fields defined smoothly across a manifold can be used to encode local geometric information at each point, see Figure 17 below.

A tangent vector field on a smooth manifold M is a smooth assignment of a tangent vector v p ∈ T p M to each point p ∈ M . Formally, it is a smooth mapping:

$$
V \colon \mathcal { M } \to T \mathcal { M } , \ \ p \mapsto V ( p ) = v _ { p } \in T _ { p } \mathcal { M } .
$$

This mapping ensures continuity and differentiability, allowing for consistent geometric analysis across the manifold.

A natural question is: what is the difference between a tangent bundle and a tangent vector field? In short, the tangent bundle is the space of all possible tangent vectors at all points, while a tangent vector field is a smooth assignment of one specific tangent vector to each point on the manifold. For clarity, let us discuss an intuitive example. Imagine the Earth’s surface as your manifold, that is, a sphere. A tangent vector field is a specific weather map showing the wind direction and speed at every single point on the Earth right now. It is one specific wind pattern selected from all possibilities throughout the day, months, years, decades, etc. On the other hand, the tangent bundle would correspond to the entire collection of all possible wind arrows you could ever imagine drawing at every single point on the Earth, no matter the direction or speed (representing every conceivable instantaneous motion at that point).

![In this image we can see a hand with two fingers.](<BordeBronstein2025/imageFile24.png>)

Figure 17: In many problems in Geometric Deep Learning and Geometric Data Processing we work with tangent vector fields.

Gauges and Gauge Transformations In practical scenarios, for instance when we want to process a signal by applying a filter, we often need to select a local coordinate system, known as a gauge , at each point p on the manifold.

Given a manifold M and a point p ∈ M , a gauge at p is a local isomorphism ω p : R n → T p M .

In the above definition, R n is an n -dimensional vector space (the model space); T p M is the tangent space of M at the point p ; and a local isomorphism is a linear mapping that preserves the structure and is invertible.

[Page 48]

However, the choice of this local coordinate system is not unique. We can choose different, equally valid gauges. A gauge transformation describes how to switch between these different, equally valid local coordinate systems.

Given a manifold M and a point p ∈ M , a gauge transformation between two gauges ω p : R n → T p M and ω ′ p : R n → T p M at p is an isomorphism τ : R n → R n such that:

$$
\omega _ { p } ^ { \prime } = \omega _ { p } \circ \tau .
$$

Gauge Equivariance in Convolution Operators and Signal Processing When designing operators (e.g., convolution) on manifolds, we typically define a filter function ψ on the tangent space that acts on features from a function f : M → R C . To ensure the operation is independent of the arbitrary choice of gauge, the filter must be gauge equivariant . That is, under a gauge transformation τ , the filter satisfies

$$
\psi ( \tau ( v ) ) \, = \, \tau \left ( \psi ( v ) \right ) ,
$$

where the action of τ on the feature vector ψ ( v ) is defined by the same representation. Consequently, a gauge-equivariant convolution is defined as

$$
( f * \psi ) ( p ) \, = \, \int _ { T _ { p } \mathcal { M } } \psi ( v ) \, f ( \exp _ { p } ( v ) ) \, d v ,
$$

which ensures that any change in the local gauge is appropriately counteracted by the corresponding transformation of the filter. This property is essential in applications, as it guarantees that learned features and convolutions are intrinsic to the manifold and not contingent on an arbitrary choice of coordinates.

Product Manifolds Moreover, similarly to Cartesian products between sets, it is also possible to define product manifolds based on the Cartesian product of two subspaces. For example, taking the Cartesian product of two circles (1-spheres) yields a torus. Product manifolds are useful for building more complex yet computationally tractable and interpretable spaces from simpler, well-understood components. Mathematically, the product of two manifolds M and N is a new manifold M × N . The tangent space at a point ( p,q ) ∈ M × N is the direct sum of the tangent spaces at p ∈ M and q ∈ N , i.e.,

$$
T _ { ( p , q ) } ( \mathcal { M } \times \mathcal { N } ) = T _ { p } \mathcal { M } \oplus T _ { q } \mathcal { N } .
$$

Here, the direct sum ⊕ refers to the combination of two vector spaces (or tangent spaces) such that each element of the resulting space is uniquely a pair consisting of one element from each of the original spaces. A Riemannian metric on the product manifold is then defined as the sum of the individual metrics on M and N . In certain applications, especially in machine learning models using latent spaces composed of constant-curvature manifolds such as spheres or hyperbolic spaces, it is common to define a distance on the product space by combining the individual geodesic distances as:

$$
d ( ( x _ { 1 } , x _ { 2 } ) , ( y _ { 1 } , y _ { 2 } ) ) \colon = \sqrt { d _ { \mathcal { M } } ( x _ { 1 } , y _ { 1 } ) ^ { 2 } + d _ { \mathcal { N } } ( x _ { 2 } , y _ { 2 } ) ^ { 2 } } .
$$

τ has type R n → R n and it encodes how the two gauges differ, while ω has type R n → T p M sending the standard basis to that of the tangent space. Thus the only way to form a composite R n → T p M is ω ◦ τ , not τ ◦ ω .

Traditional neural network architectures can be adapted to work on manifolds, meshes, and geometric graphs by focusing on local neighborhoods.

![image 25](<BordeBronstein2025/imageFile25.png>)

[Page 49]

Manifolds in Geometric Deep Learning. Geometric Deep Learning aims to extend neural network architectures to effectively handle data defined on general non-Euclidean domains, including manifolds such as surfaces in 3D space or more abstract, higher-dimensional spaces. When we talk about data lying on a manifold, we often implicitly assume that this manifold has some geometric structure that we want our models to understand and leverage. This structure usually involves notions of distance or similarity, which falls under the umbrella of ‘geometry’. The manifold provides the framework, and the geometry provides the rules for measurement and relationships on that framework. This involves leveraging tools from differential geometry, like geodesics, curvature, and local charts, to design models that respect the manifold’s intrinsic geometry. For example, convolution-like operations on manifolds may be defined in terms of local neighborhoods, where the neighborhood structure is governed by the manifold’s geometry rather than a regular grid.

# 4.4 The Manifold Hypothesis

Many ML and AI algorithms rely on the manifold hypothesis [13] (sometimes also called the manifold assumption), which suggests that although most datasets seem to be highdimensional in the original data space, data points can actually be described by a lowdimensional manifold which resides within the observed high-dimensional space. This is often used to explain why datasets that appear to require a great number of parameters to be represented, can in practice be encoded using latent variables with few dimensions. As a disclaimer, note that the term ‘manifold’ is used loosely in this context and not in a mathematically rigorous sense. There are no formal guarantees that the low-dimensional representation possesses the mathematical properties discussed earlier in Section 4.3. For example, the space may not be perfectly smooth, locally Euclidean, or even have consistent local dimensionality.

Often the term manifold is abused in ML and AI.

![In this image, we can see a diagram with a person and a graph.](<BordeBronstein2025/imageFile26.png>)

Figure 18: The manifold which encapsulates all images of faces, is expected to be substantially more low-dimensional than the space R 256 × height × width . Points on the manifold correspond to valid face images, whereas the remaining points in the hypercube are likely to produce meaningless, noisy images.

[Page 50]

Figure 19 illustrates that traversing the manifold allows for controlled variation (such as different facial expressions or poses) while remaining within the space of valid images. In contrast, simple linear interpolation between two images in pixel space generally produces noisy or implausible results. Empirically, smooth transitions can often be observed when interpolating in the latent space of models such as autoencoders. Still, there are no theoretical guarantees that smooth interpolations exist between any two arbitrary points.

![The image is a black and white diagram consisting of three different figures. The figures are labeled as follows: 1. **Figure 1**: This figure is a woman with long hair. She is wearing a dress. The background is plain and white. 2. **Figure 2**: This figure is a man with short hair. He is wearing a suit. The background is also plain and white. 3. **Figure 3**: This figure is a woman with long hair. She is wearing a dress. The background is also plain and white. The diagram is labeled with the following text: - **Figure 1**: The woman is wearing a dress. - **Figure 2**: The man is wearing a suit. - **Figure 3**: The woman is wearing a dress. The diagram is labeled with the following text: - **Figure 1**: The woman is wearing a dress. - **Figure 2**:](<BordeBronstein2025/imageFile27.png>)

Figure 19: Depiction of interpolation between images along the surface of the manifold.

[Page 51]

# 5 Functional Analysis

Functional analysis is a branch of mathematical analysis that studies spaces of functions and the operators that act on them. Functional analysis provides a powerful framework for understanding infinite-dimensional spaces, where classical linear algebraic methods fail, and establishes the foundation for spectral theory. This section explores key concepts such as completeness, convergence, and the structural properties of vector spaces, with a focus on Banach and Hilbert spaces as fundamental mathematical structures.

Banach and Hilbert Spaces in Geometric Deep Learning. Banach and Hilbert spaces serve as a critical foundation for key concepts such as eigenfunctions, eigenvalues, and Fourier analysis, which we will study in Section 6 and which are widely used in many Geometric Deep Learning algorithms. We encourage readers to review the material on Banach and Hilbert spaces, operators, and functionals. While an in-depth study of these concepts may not be necessary, a basic understanding is useful to tackle spectral theory.

# 5.1 Cauchy Sequences and Banach Spaces

A sequence of vectors v 1 ,v 2 ,... ∈ V in a normed vector space V is a Cauchy sequence if for every ϵ > 0 , there exists an integer N such that

$$
\| v _ { m } - v _ { n } \| < \epsilon \quad \text {for all } m , n > N .
$$

As indices m and n become arbitrarily large, the vectors v m and v n approach each other in norm, satisfying:

$$
\lim _ { m , n \to \infty } \| v _ { m } - v _ { n } \| = 0 .
$$

Critically, a Cauchy sequence does not inherently guarantee a limit within the space V . The existence of such a limit depends on the space’s completeness.

A Banach space is a normed vector space V that is complete, meaning every Cauchy sequence ( v n ) n ≥ 1 has a limit v ∈ V such that:

$$
\lim _ { n \to \infty } \| v _ { n } - v \| = 0 ,
$$

equivalently converging in the topology induced by the norm:

$$
\lim _ { n \to \infty } v _ { n } = v .
$$

Banach spaces provide a framework for studying convergence in infinite-dimensional spaces, and they generalize the notion of completeness from real numbers to vector spaces.

A prototypical Banach space is ℓ p (for 1 ≤ p < ∞ ), defined by sequences ( x n ) n ≥ 1 satisfying: 1 /p

$$
\| x \| _ { p } = \left ( \sum _ { n = 1 } ^ { \infty } | x _ { n } | ^ { p } \right ) ^ { 1 / p } < \infty .
$$

Consider two spaces V 1 = (0 , 1] and V 2 = (0 , 1) , and the sequence d n = 1 − 1 n , where n is a positive integer. As n → ∞ , the sequence tends to 1 . In the case of V 1 the sequence converges within the space. On the other hand, in V 2 the boundary is not part of the space, and hence the sequence does not converge within V 2 even though it is Cauchy.

[Page 52]

The importance of completeness is illustrated by a counterexample in Q with the absolute value norm. Consider the sequence approximating √ 2 :

$$
v _ { n } = \text {the $n$-th rational approximation of } \sqrt { 2 } .
$$

This sequence is Cauchy in Q , but its limit √ 2 lies outside Q . This demonstrates why completeness is crucial: it prevents Cauchy sequences from ‘escaping’ the original space.

# 5.2 Hilbert Spaces

A Hilbert space is a complete inner product space.

Hilbert spaces extend the notion of Banach spaces by introducing an inner product ⟨· , ·⟩ that induces the norm:

$$
\| v \| = \sqrt { \langle v , v \rangle } .
$$

The inner product allows Hilbert spaces to generalize the geometry of finite-dimensional Euclidean spaces to infinite dimensions. Key examples include L 2 (square-integrable) spaces, where functions are treated as infinite-dimensional vectors.

Orthogonal Bases Let V be a Hilbert space and let S ⊆ V .

$$
\text {span} ( S ) = \left \{ \sum _ { i = 1 } ^ { n } \alpha _ { i } v _ { i } \colon n \in \mathbb { N } , \, v _ { i } \in S , \, \alpha _ { i } \in \mathbb { C } \right \}
$$

is the set of all finite linear combinations from S .

S is linearly independent if for any finite subset { v 1 ,...,v n } ⊆ S and any coefficients α 1 ,...,α n ∈ C , n

$$
\sum _ { i = 1 } ^ { n } \alpha _ { i } v _ { i } = 0 \implies \alpha _ { i } = 0 \forall i .
$$

S is orthogonal if ⟨ u,v ⟩ = 0 ∀ u,v ∈ S s.t. u ̸ = v .

̸

S is orthonormal if it is orthogonal and all vectors have unit length, i.e. ∥ u ∥ = 1 ∀ u ∈ S . When { e i } i ∈ I forms an orthonormal basis for V , every element v ∈ V has a unique infinite representation:

$$
v = v _ { 1 } e _ { 1 } + v _ { 2 } e _ { 2 } + \dots = \sum _ { i \in I } v _ { i } e _ { i } = v _ { i } e _ { i } = \sum _ { i \in I } \langle v , e _ { i } \rangle e _ { i } ,
$$

where ⟨ v,e i ⟩ are the Fourier coefficients (Section 6.2), and the series converges in the norm induced by the inner product.

Hilbert spaces combine the algebraic structure of inner products with the topological properties of completeness.

Completeness ensures that the space is well-suited for analyzing convergence of Fourier series, solving partial differential equations, and modeling quantum systems. Hilbert spaces unify algebra, geometry, and analysis in an infinite-dimensional setting.

The equation states (contrapositive form) that if the linear combination equals the zero vector, then all the coefficients α i must be zero. This is a defining property of linear independence.

As mentioned in Section 2.3, orthogonality is typically denoted via u ⊥ v . To denote that vectors are orthonormal sometimes the following notation is used: u ⊥⊥ v .

[Page 53]

Functions as Infinite-Dimensional Vectors in L 2 A square-integrable function is a function f defined on a domain Ω such that the square of its absolute value is integrable over Ω . Specifically, a function f ( x ) belongs to the space L 2 (Ω) if:

$$
\int _ { \Omega } | f ( x ) | ^ { 2 } \, d x < \infty .
$$

Functions in L 2 spaces can be understood as infinite-dimensional vectors by representing them in terms of a set of basis functions. Just as finite-dimensional vectors in R n can be expressed using a basis (e.g., v = v 1 e 1 + v 2 e 2 + ··· + v n e n = v i e i ), a function f ( x ) in L 2 can be written as a linear combination of basis functions:

$$
f ( x ) = f _ { 1 } \phi _ { 1 } ( x ) + f _ { 2 } \phi _ { 2 } ( x ) + f _ { 3 } \phi _ { 3 } ( x ) + \dots
$$

Here, { ϕ k ( x ) } ∞ k =1 is a set of orthonormal basis functions, and the coefficients f k represent how much of each basis function ϕ k ( x ) contributes to f ( x ) . The coefficients f k are computed using the inner product of f ( x ) with the basis function ϕ k ( x ) :

$$
f _ { k } = \langle f , \phi _ { k } \rangle = \int f ( x ) \phi _ { k } ( x ) \, d x .
$$

This step is analogous to finding the components of a vector in R n by projecting it onto the coordinate axes. Once the coefficients f 1 ,f 2 ,f 3 ,... are determined, the function f ( x ) can be viewed as an infinite-dimensional vector:

$$
f \equiv [ f _ { 1 } , f _ { 2 } , f _ { 3 } , \dots ] .
$$

In this sense, the ‘vector’ [ f 1 ,f 2 ,f 3 ,... ] describes f ( x ) completely, just as the coordinates [ v 1 ,v 2 ,...,v n ] describe a vector in finite-dimensional space.

For example, consider the interval X = [0 , 1] with basis functions ϕ 1 ( x ) = 1 , ϕ 2 ( x ) = sin(10 πx ) , and ϕ 3 ( x ) = cos( πx ) . A function f ( x ) = 2 + 17sin(10 πx ) − cos( πx ) can be written as:

$$
f ( x ) = 2 \cdot \phi _ { 1 } ( x ) + 1 7 \cdot \phi _ { 2 } ( x ) - 1 \cdot \phi _ { 3 } ( x ) .
$$

In this case, the coefficients are f 1 = 2 , f 2 = 17 , and f 3 = − 1 , and the function f ( x ) is represented as the vector [2 , 17 , − 1] . Extending this idea to infinitely many basis functions gives the full L 2 perspective, where f ( x ) is reconstructed as a weighted sum of basis functions.

This approach provides an intuitive understanding of functions as vectors in infinitedimensional spaces, where concepts like orthogonality, projection, and decomposition of functions naturally extend from finite-dimensional vector spaces.

# 5.3 Operators and Functionals

In the context of Banach and Hilbert spaces, operators and functionals serve as essential tools for understanding the relationships between elements within and across spaces. They form the backbone of functional analysis. For the sake of brevity, here we only provide a very concise and high-level description of the aforementioned concepts.

An orthonormal set of basis functions are orthogonal ⟨ ϕ i , ϕ j ⟩ = 0 for i ̸ = j , and normalized ⟨ ϕ i , ϕ i ⟩ = 1 .

̸

Analogous to the expression above: i ∈ I v i e i =   i ∈ I ⟨ v, e i ⟩ e i .

[Page 54]

Operators on Banach and Hilbert Spaces Operators are mappings that transform elements from one space into another while preserving structure. Through operators, we can describe how vectors interact, how they transform, and how these transformations affect the overall structure of the space.

An operator in this context is a map A : U → V between two spaces U and V (Banach or Hilbert), usually preserving some structure.

Let ( U, ∥∥ U ) and ( V, ∥∥ V ) be Banach spaces with their respective norms, and consider an operator A : U → V .

A is continuous if it preserves convergence, i.e., u n ∥ ∥ U −→ u ⇒ Au n ∥ ∥ V −→ Au .

A is bounded if ∃ c > 0 s.t. ∥ Au ∥ V ≤ c ∥ u ∥ U ∀ u ∈ U .

A is linear if A ( αu + βw ) = αAu + βAw ∀ u,w ∈ U and α,β ∈ C .

A is an isometry if it is length-preserving, i.e. ∥ Au ∥ V = ∥ u ∥ U .

Let ( V, ⟨ , ⟩ )) be a Hilbert space and consider an operator A : V → V .

A ∗ is adjoint to A if ⟨ Au,v ⟩ = ⟨ u,A ∗ v ⟩ ∀ u,v ∈ V .

A is self-adjoint if A ∗ = A , i.e. ⟨ Au,v ⟩ = ⟨ u,Av ⟩ ∀ u,v ∈ V .

A is compact if it maps weak limits to strong limits, i.e. v n ⇀ v ⇒ Av n → Av .

The rank of an operator A , denoted as rank ( A ) , is the dimension of the image of A , i.e., the number of linearly independent vectors in the set of vectors that A maps to.

Note that in the space of finite-dimensional real vectors, operators can be expressed as matrices: ⟨ Au,v ⟩ = ( Au ) ⊤ v = u ⊤ ( A ⊤ v ) = ⟨ u,A ⊤ v ⟩ . More on this next.

Functionals on Hilbert Spaces Functionals are maps that assign scalar values to vectors. They provide a way to probe and measure elements of a space.

A functional is a map of the form ϕ : V → C on a Hilbert space V .

ϕ is continuous if it preserves convergence, i.e., if v n ∥ ∥ V −→ v in V , then ϕ ( v n ) −→ ϕ ( v ) , where ∥ · ∥ V is the norm on V .

ϕ is a linear functional if ϕ ( αv + βw ) = αϕ ( v ) + βϕ ( w ) ∀ v,w ∈ V and α,β ∈ C .

Dual (or conjugate ) space to V is the space of linear continuous functionals on V , denoted

$$
V ^ { * } = \{ \phi \colon V \rightarrow \mathbb { C } \text { linear+continuous} \}
$$

The elements of V ∗ are called dual vectors .

u n here refers to a sequence in the space u n = ( u n ) n ≥ 1 .

In the context of Hilbert spaces we use the asterisk symbol ( · ) ∗ to denote adjoint operators.

Weak limit ( v n ⇀ v ): v n converges weakly to v if ⟨ v n , w ⟩ → ⟨ v, w ⟩ for all w ∈ V . This means that v n converges to v in the sense of how they interact with other vectors, but not necessarily in norm.

Strong limit ( v n → v ): v n converges strongly to v if ∥ v n − v ∥ → 0 , i.e., the distance between v n and v in the norm goes to zero.

Note that continuity implies boundedness, that is, there exists a constant C such that | ϕ ( v ) | ≤ C ∥ v ∥ V .

[Page 55]

# 6 Spectral Theory

Spectral theory studies the properties of operators and matrices by analyzing their spectra, that is, their eigenfunctions and associated eigenvalues.

# 6.1 Eigenfunctions and Eigenvalues

Eigenfunctions and eigenvalues arise when we study linear transformations, whether on finite-dimensional vector spaces or infinite-dimensional spaces like function spaces. They allow us to decompose and diagonalize operators. This can enable us to work with a simplified version of the original problem, one that might exhibit complex, non-linear dynamics in the original space. These concepts are particularly central to spectral theory .

Let A : V → V be an operator on Hilbert space V . A vector v ̸ = 0 satisfying for some λ

̸

$$
A v = \lambda v
$$

is called an eigenfunction of A , and λ is the corresponding eigenvalue .

Note that eigenfunctions are defined up to scale: if v is an eigenfunction of A , so is αv for any α ̸ = 0 , since we can multiply both sides of the equation by A ( αv ) = λ ( αv ) by α . It is common to assume eigenfunctions of unit length, i.e. ∥ v ∥ = 1 .

̸

Eigenvectors and Eigenvalues in Finite-Dimensional Vector Spaces When we are first introduced to eigenvectors and eigenvalues, A typically denotes a matrix, which is a finite, rectangular array of numbers that defines a linear transformation in a finitedimensional vector space. Eigenvectors are the vectors in the vector space that are scaled by the linear transformation represented by A . In finite-dimensional spaces, eigenfunctions are essentially eigenvectors, but the term eigenfunction is more commonly used in the context of infinite-dimensional spaces. For example, if A is an n × n matrix, eigenvalues and eigenvectors are solutions to the equation:

$$
A v = \lambda v , \ v \neq 0 ,
$$

̸

where v is a vector in R n or C n . This is usually solved finding values of λ that satisfy the characteristic equation :

$$
\det \left ( A - \lambda I \right ) = 0 ,
$$

where I is the n × n identity matrix. The solutions λ 1 ,λ 2 ,...,λ n are the eigenvalues of A , and for each eigenvalue λ , we find the corresponding eigenvector(s) v by solving the system of linear equations:

$$
( A - \lambda I ) v = 0 .
$$

The eigenvalue λ determines how A stretches or compresses the direction v , which remains unchanged under the transformation, except for sign flips.

There can be multiple eigenvectors corresponding to the same eigenvalue. If λ > 0 the direction of v remains unchanged, but it is stretched if | λ | > 1 or compressed if | λ | < 1 . Eigenvalues can be negative. If λ < 0 the direction of v is reversed, since multiplication by a negative scalar reflects the vector across the origin.

[Page 56]

Generalization to Hilbert Spaces: Eigenfunctions and Eigenvalues Here, we are interested in the generalization from finite-dimensional vector spaces to infinite-dimensional spaces. In this generalized setting, A is a linear operator A : V → V which acts on vectors in the Hilbert space V , instead of a matrix. In a finite-dimensional space, a matrix A maps vectors in R n to R n , whereas in an infinite-dimensional space, an operator A maps functions in a space such as L 2 to itself. The characteristic equation for eigenvectors Av = λv still applies in this case, but here v might be a function (hence called an eigenfunction ), and λ is a scalar eigenvalue associated with v .

The Spectral Theorem The spectral theorem states that self-adjoint operators, both in finite and infinite-dimensional spaces, can be fully diagonalized in terms of their eigenvalues and eigenfunctions. This theorem plays a crucial role in understanding the structure of such operators in Hilbert spaces. Remember that A is self-adjoint if A ∗ = A , i.e. ⟨ Au,v ⟩ = ⟨ u,Av ⟩ ∀ u,v ∈ V .

We begin by discussing important properties of self-adjoint operators.

Theorem 5 (Spectral Theorem for Self-Adjoint Operators) . Self-adjoint operators have real eigenvalues.

Proof. Let Av = λv , with v ̸ = 0 . Since A = A ∗ , we have:

̸

$$
\langle A v , v \rangle = \langle v , A v \rangle .
$$

Substituting Av = λv , we get:

$$
\langle \lambda v , v \rangle = \langle v , \lambda v \rangle .
$$

Because λ is a scalar, we can factor it out of both inner products:

$$
\lambda \langle v , v \rangle = \bar { \lambda } \langle v , v \rangle .
$$

Note that on the right, we have applied conjugate linearity from Section 2.3. Since v ̸ = 0 , ⟨ v,v ⟩ > 0 . Thus, we can divide both sides by ⟨ v,v ⟩ to obtain:

̸

$$
\lambda = \lambda ,
$$

which implies that λ ∈ R .

Theorem 6 (Orthogonality of Eigenfunctions) . Eigenfunctions of self-adjoint operators corresponding to different eigenvalues are orthogonal.

Proof. Let Av = λv and Aw = µw with λ ̸ = µ and v,w ̸ = 0 . Since A = A ∗ , we have:

̸

̸

$$
\langle A v , w \rangle = \langle v , A w \rangle .
$$

[Page 57]

Substituting the eigenvalue equations, we get:

$$
\langle \lambda v , w \rangle = \langle v , \mu w \rangle .
$$

Since λ and µ are real (from Theorem 5), we can factor out the scalars without conjugation:

$$
\lambda \langle v , w \rangle = \mu \langle v , w \rangle .
$$

Thus,

Since λ ̸ = µ , it follows that:

̸

i.e., v ⊥ w .

$$
( \lambda - \mu ) \langle v , w \rangle = 0 .
$$

$$
\langle v , w \rangle = 0 ,
$$

Theorem 7 (Spectral Theorem) . A compact self-adjoint operator A : V → V has eigenvalues { λ } with corresponding eigenfunctions { v λ } such that:

$$
A v _ { \lambda } = \lambda v _ { \lambda } .
$$

These eigenfunctions form an orthonormal basis of V , and the set of eigenvalues is countable. Furthermore, the eigenvalue spectrum is discrete, with the only possible accumulation point being λ = 0 .

This statement implies that the eigenvalues of a compact self-adjoint operator form a countable set, all of which are real. The corresponding eigenfunctions form an orthonormal basis of the Hilbert space V . If λ ̸ = 0 , then λ is an isolated eigenvalue (discrete spectrum). The only possible accumulation point of the spectrum is λ = 0 .

̸

Thus, the Spectral Theorem builds on the properties established in Theorems 5 and 6 and provides a complete characterization of the structure of a Hilbert space under a compact self-adjoint operator.

Spectral Theorem Example In the following, we provide an illustration of the spectral theorem in the context of a differential operator and verify key properties like selfadjointness and orthogonality of eigenfunctions.

Let us work with

$$
L ^ { 2 } ( [ - \pi , + \pi ] ) = \left \{ f \colon [ - \pi , + \pi ] \colon \to \mathbb { C } \ \ s . t . \ \ \int _ { - \pi } ^ { + \pi } | f ( x ) | ^ { 2 } d x < \infty \right \} ,
$$

the space of square-integrable periodic functions, meaning their squared magnitude integrates to a finite value, with standard inner product

$$
\langle f , g \rangle = \frac { 1 } { 2 \pi } \int _ { - \pi } ^ { + \pi } f ( x ) \overline { g ( x ) } d x ,
$$

where g ( x ) denotes the complex conjugate of g ( x ) .

Consider the Laplacian operator (second-order derivative, see Section 3): ∆ = d 2 dx 2 . First, The set of eigenvalues can be either finite or countably infinite. A set is countable if there is a way to list its elements in a sequence, that is, there is a one-to-one correspondence between the set and the set of natural numbers, N . When we say that the spectrum is discrete we mean that each eigenvalue is separated by some positive distance from others, that is, the eigenvalues are isolated. The only exception is λ = 0 . There is no continuous spectrum where eigenvalues can form a continuous range or interval.

Principal Component Analysis (PCA) uses a finite-dimensional version of the Spectral Theorem to identify key directions in data.

[Page 58]

we verify that ∆ is self-adjoint. To do so, we must show:

$$
\langle \Delta f , g \rangle = \langle f , \Delta g \rangle \quad \forall f , g \in L ^ { 2 } ( [ - \pi , \pi ] ) .
$$

From the product differentiation rule,

$$
\frac { d } { d x } ( f ( x ) g ( x ) ) = f ^ { \prime } ( x ) g ( x ) + f ( x ) g ^ { \prime } ( x ) .
$$

Also, the fundamental theorem of calculus tells us,

$$
\int _ { - \pi } ^ { + \pi } \frac { d } { d x } ( f ( x ) g ( x ) ) \, d x = f ( x ) g ( x ) | _ { - \pi } ^ { + \pi } \, ,
$$

and given that we are considering periodic functions, we have the boundary conditions f ( π ) = f ( − π ) and g ( π ) = g ( − π ) . Hence,

$$
f ( x ) g ( x ) | _ { - \pi } ^ { + \pi } = f ( \pi ) g ( \pi ) - f ( - \pi ) g ( - \pi ) = f ( \pi ) g ( \pi ) - f ( \pi ) g ( \pi ) = 0 .
$$

Therefore,

$$
\int _ { - \pi } ^ { + \pi } \frac { d } { d x } ( f ( x ) g ( x ) ) d x = 0 \, \Longrightarrow \, \int _ { - \pi } ^ { + \pi } f ( x ) g ^ { \prime } ( x ) d x = - \int _ { - \pi } ^ { + \pi } f ^ { \prime } ( x ) g ( x ) d x ,
$$

where for simplicity, we ignore complex conjugates. Applying this result to f ′ g ′ we have

$$
- \int _ { - \pi } ^ { + \pi } f ^ { \prime } ( x ) g ( x ) d x = \int _ { - \pi } ^ { + \pi } f ^ { \prime } ( x ) g ^ { \prime } ( x ) d x = - \int _ { - \pi } ^ { + \pi } f ( x ) g ^ { \prime } ( x ) d x
$$

from which self-adjointness ⟨ ∆ f,g ⟩ = ⟨ f, ∆ g ⟩ follows

$$
\langle \Delta f , g \rangle = \int _ { - \pi } ^ { + \pi } f ^ { \prime } ( x ) g ( x ) d x = \int _ { - \pi } ^ { + \pi } f ( x ) g ^ { \prime } ( x ) d x = \langle f , \Delta g \rangle .
$$

After having verified the self-adjointness of the Laplacian, let us now consider the Laplacian acting on the function e inx where n ∈ Z . From ∆ e inx = d 2 dx 2 e inx = − n 2 e inx , it immediately follows that eigenfunctions have the form e inx with corresponding real eigenvalues − n 2 . Remember that in infinite-dimensional space, eigenfunctions are linear operators: indeed the Laplacian scales linearly the function e inx by a factor of − n 2 .

In Theorem 5 we stated that self-adjoint operators have real eigenvalues: − n 2 is real. Next, to verify orthogonality and Theorem 6, write

$$
\langle e ^ { i n x } , e ^ { i m x } \rangle = \frac { 1 } { 2 \pi } \int _ { - \pi } ^ { + \pi } e ^ { i n x } e ^ { - i m x } d x = \frac { 1 } { 2 \pi } \int _ { - \pi } ^ { + \pi } e ^ { i ( n - m ) x } d x .
$$

For n ̸ = m ,

̸

$$
\int _ { - \pi } ^ { + \pi } e ^ { i ( n - m ) x } d x = 0 \implies \langle e ^ { i n x } , e ^ { i m x } \rangle = 0 .
$$

This is because the function is periodic with zero average over the full period and shows

Assuming continuity and differentiability, or piecewise smoothness.

Let f and g swap roles to obtain both sides of the equation and perform a change of variables.

e ax

d

e

=

ae

dx

Remember we need to consider the complex conjugate of the eigenfunction: e imx = e − imx

This can be shown using the integral of a complex exponential and rewriting the result in terms of the sine function.

[Page 59]

that distinct eigenfunctions are orthogonal. For n = m ,

$$
\int _ { - \pi } ^ { + \pi } e ^ { i ( n - m ) x } d x = \int _ { - \pi } ^ { + \pi } 1 d x = 2 \pi \implies \langle e ^ { i n x } , e ^ { i n x } \rangle = 1 ,
$$

which reflects normalization, that is, the eigenfunctions are orthonormal. Hence we have that,

$$
\langle e ^ { i n x } , e ^ { i m x } \rangle = \delta _ { n m } ,
$$

where δ mn is the Kronecker delta.

Singular Values The spectral theorem focuses on self-adjoint operators. For more general operators, we turn to the concept of singular values and their corresponding singular vectors . Singular values provide a more general way to characterize how an operator transforms vectors in a space, and they are particularly useful when dealing with non-selfadjoint operators, such as general matrices.

Before providing formal definitions, let us clarify the intuitive difference between eigenvalues and singular values. These quantities capture different aspects of how a linear operator transforms elements of the space. Eigenvalues measure how much a transformation stretches or compresses an eigenfunction along its direction, without changing that direction (except for sign flips). On the other hand, singular values measure the overall magnitude of an operator’s action, independent of any specific direction, that is, they describe how much the operator stretches or compresses functions in general. These concepts provide fundamental tools for analyzing operators, whether finite-dimensional (as matrices) or infinite-dimensional.

An operator A : V → V is compact iff it can be written in the form

$$
A w = \sum _ { n \geq 1 } \sigma _ { n } \langle v _ { n } , w \rangle u _ { n } , \quad \forall w \in V .
$$

{ σ n } n ≥ 1 are the singular values and { v n } n ≥ 1 , { u n } n ≥ 1 are the corresponding (leftand right-) singular vectors of A .

Note that this is an alternative definition of compactness. Compact operators are often studied because they have certain nice properties, such as having a countable set of singular values. Importantly, these singular values can accumulate only at zero. This means that after some index N , the singular values become zero, indicating that the operator has finite rank. In this case, the rank of A is equal to N , and we have:

$$
\text {rank} ( A ) = N .
$$

In the finite-dimensional case the rank corresponds to the number of linearly independent rows or columns in the matrix representing the operator, whereas in the infinitedimensional case the rank is the number of non-zero singular values. Even though the operator may act on an infinite-dimensional space, its rank remains finite.

The Kronecker delta is defined as

$$
\delta _ { n m } = \begin{cases} 1 , & \text {if } n = m , \\ 0 , & \text {if } n \neq m . \end{cases}
$$

̸

Singular vectors, both left and right, represent directions in the domain and codomain of A .

[Page 60]

After discussing the most general case, let us now examine particular cases. If A is selfadjoint, we can write it in the form:

$$
A w = \sum _ { n \geq 1 } \lambda _ { n } \langle v _ { n } , w \rangle v _ { n } , \quad \forall w \in V .
$$

Here, { λ n } are the eigenvalues of A , and { v n } are the corresponding eigenvectors of A . This is a special case of the more general singular value decomposition, where the singular values coincide with the eigenvalues, and the left and right singular vectors are the same.

Next, let us discuss singular value decomposition (SVD) of matrices.

An m × n matrix A can be written in the singular value decomposition (SVD) form:

$$
A = U \Sigma V ^ { * } = \begin{pmatrix} | & & | \\ & & \dots & | \\ & & & | \end{pmatrix} \begin{pmatrix} \sigma _ { 1 } & & \\ & \ddots & \\ & & & | \end{pmatrix} \begin{pmatrix} - & \bar { v } _ { 1 } & - \\ & \vdots & \\ & & \ddots & \sigma _ { n } \end{pmatrix} \begin{pmatrix} - & \bar { v } _ { 1 } & - \\ & & \vdots & \\ & & & \sigma _ { n } \end{pmatrix} ,
$$

where U is an m × m unitary matrix whose columns are the left singular vectors u i , Σ is an m × n diagonal matrix containing the singular values σ i , and V ∗ is the conjugate transpose of the n × n unitary matrix V , whose rows are the right singular vectors v i .

Example Eigenvalues vs Singular Values To further build on our intuition regarding the difference between eigenvalues and singular values, let us consider a rotation matrix. A rotation matrix has no real eigenvalues because it does not stretch or compress space along fixed directions. However, it has singular values all equal to 1 , reflecting that it preserves lengths. More concretly, a rotation matrix R in 2D is defined as:

$$
R = \begin{pmatrix} \cos \theta & - \sin \theta \\ \sin \theta & \cos \theta \end{pmatrix} ,
$$

where θ is the rotation angle. To find the eigenvalues, we solve the characteristic equation:

Thus, the eigenvalues are:

$$
\lambda ^ { 2 } - 2 \lambda \cos \theta + 1 = 0 .
$$

$$
\lambda = e ^ { i \theta } , \ \lambda = e ^ { - i \theta } .
$$

These eigenvalues are complex and lie on the unit circle in the complex plane. Hence, there are no real eigenvalues unless θ = 0 or π (identity and reflection).

The singular values of R are obtained from the eigenvalues of R T R :

Multiplying R T R :

$$
R ^ { T } R = \left ( \begin{matrix} \cos \theta & \sin \theta \\ - \sin \theta & \cos \theta \end{matrix} \right ) \begin{pmatrix} \cos \theta & - \sin \theta \\ \sin \theta & \cos \theta \end{pmatrix} = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix} = I .
$$

[Page 61]

The eigenvalues of R T R are therefore both 1 , and the singular values of R (the square roots of these eigenvalues) are: σ 1 = 1 and σ 2 = 1 .

# 6.2 Fourier analysis

In eigenfunctions and eigenvalues, singular value decomposition, and Fourier series, the fundamental concept is the decomposition of an object—whether a self-adjoint operator, an operator, or a function—into a sum of components along specific directions or bases. More commonly, Fourier series are associated with a trigonometric basis (sine, cosine, or complex exponential). However, the concept is general and applies to any orthonormal basis.

Let { v α } be an orthonormal basis in a Hilbert space V . Then, u ∈ V can be expressed as a Fourier series

$$
u = \sum _ { \alpha } \langle u , v _ { \alpha } \rangle v _ { \alpha }
$$

The coefficients ⟨ u,v α ⟩ = ˆ u α in the above series are called Fourier coefficients (or transforms ) of u .

For clarity, remember that the expression above can be expanded as follows:

$$
u = \sum _ { \alpha } \langle u , v _ { \alpha } \rangle v _ { \alpha } = \hat { u } _ { \alpha } v _ { \alpha } = \hat { u } _ { 1 } v _ { 1 } + \hat { u } _ { 2 } v _ { 2 } + \hat { u } _ { 3 } v _ { 3 } + \dots
$$

Fourier Decomposition for Vectors For vectors, the Fourier decomposition can be written in matrix form:

$$
u = \begin{pmatrix} | & & | \\ v _ { 1 } & \cdots & v _ { n } \\ | & | & | \end{pmatrix} \underbrace { \left ( \begin{matrix} - & \bar { v } _ { 1 } ^ { \top } & - \\ & & \\ & \vdots & \\ & & v _ { n } ^ { \top } \end{matrix} \right ) } _ { V ^ { \dagger } } u ,
$$

where V ∈ C n × n is the matrix whose columns are the basis vectors v i , V † is the Hermitian conjugate (conjugate transpose) of V , and V † u = ( ⟨ u,v 1 ⟩ , ⟨ u,v 2 ⟩ ,..., ⟨ u,v n ⟩ ) ⊤ contains the Fourier coefficients. Thus

$$
u = V ( V ^ { \dagger } u ) ,
$$

where V † u gives the coefficients, and V ( V † u ) reconstructs the vector. From this, it is evident that it is a unitary operation (see below).

Continuous Fourier Transform Note that in general, α here can be a continuous index, in which case the sum should be replaced with an integral:

A unitary operation is a linear operation that preserves the inner product in a complex vector space.

[Page 62]

$$
\langle u , v _ { \alpha } \rangle = \int u ( x ) \overline { v _ { \alpha } ( x ) } \, d x .
$$

This is the case with the continuous Fourier transform using a basis of the form e iωx , with ω ∈ R :

$$
f ( x ) = \int _ { - \infty } ^ { \infty } \hat { f } ( \omega ) e ^ { i \omega x } \, d \omega ,
$$

where ˆ f ( ω ) are the Fourier coefficients of f ( x ) , representing the contribution of each frequency component. The Fourier coefficients are obtained based on the inner product:

$$
\hat { f } ( \omega ) = \int _ { - \infty } ^ { \infty } f ( x ) e ^ { - i \omega x } \, d x .
$$

Note that the computations in the continuous case are analogous to obtaining the coefficients and reconstructing the vector using matrix multiplication, as discussed earlier in the context of vectors.

Fourier Series Example Consider L 2 ([ − π, + π ]) , the space of square-integrable periodic functions, with the standard inner product ⟨ f,g ⟩ = 1 2 π   + π − π f ( x ) g ( x ) dx and the basis { e inx } n ≥ 1 . The Fourier series assume the classical form

$$
f ( x ) = \sum _ { n \geq 1 } \frac { 1 } { 2 \pi } \int _ { - \pi } ^ { + \pi } f ( y ) e ^ { - i n y } d y \, e ^ { i n x } .
$$

The Fourier series provides a discrete decomposition because the function being considered is periodic, leading to discrete frequencies.

Parseval’s Identity Parseval’s identity establishes that the inner product, and hence the geometry, of a Hilbert space V is perfectly captured by the Fourier coefficients. The identity guarantees that this mapping is an isometry, and it allows us to work with Fourier coefficients as a proxy for the original function or vector.

Theorem 8 (Parseval’s identity) . Let u =   α ˆ u α v α and w =   α ˆ w α v α be Fourier series of u,w ∈ V with respect to the orthonormal basis { v α } . Then ⟨ u,w ⟩ =   α ˆ u α ˆ w α .

In other words, we can define a map V ∋ u  → ˆ u = {⟨ u,v α ⟩} ∈ ℓ 2 from vectors to (square summable) sequences. This map is an isometry :

$$
\| u \| _ { V } ^ { 2 } = \sum _ { \alpha } | \langle u , v _ { \alpha } \rangle | ^ { 2 } = \sum _ { \alpha } | \hat { u } _ { \alpha } | ^ { 2 } = \| \hat { u } \| _ { \ell ^ { 2 } } ^ { 2 } .
$$

This, in turn, is nothing else but the application of the Pythagorean theorem, Theorem 2.3

Recall that an isometry is length-preserving.

[Page 63]

(possibly in infinite dimensions),

$$
\| u \| ^ { 2 } = \left \| \sum _ { \alpha } \langle u , v _ { \alpha } \rangle v _ { \alpha } \right \| ^ { 2 } = \sum _ { \alpha } \| \langle u , v _ { \alpha } \rangle v _ { \alpha } \| ^ { 2 } = \sum _ { \alpha } | \langle u , v _ { \alpha } \rangle | ^ { 2 } ,
$$

where we used the orthonormality of the basis { v α } .

The Heat Equation Consider the following partial differential equation, called the heat equation , under Dirichlet boundary conditions:

$$
\begin{cases} \ \Delta f ( x , t ) = f _ { t } ( x , t ) \\ \ f ( x , 0 ) = g ( x ) \quad ( \text {initial conditions} ) \end{cases}
$$

on a circle, where f : S 1 × [0 , ∞ ) → R (periodic in the first coordinate) represents the temperature , ∆ = ∂ 2 ∂x 2 is the one-dimensional Laplacian operator, and g ( x ) is the initial temperature distribution at time t = 0 . Since S 1 is a circle, there are no boundary conditions on the spatial domain.

Fourier analysis was originally developed for solving this kind of partial differential equation (PDE), and we will show how it applies here. First, assume the solution has a separable form:

$$
f ( x , t ) = X ( x ) T ( t ) ,
$$

where X ( x ) is the spatial part and T ( t ) is the temporal part. Assuming X,T never vanish, we substitute this into the heat equation:

$$
\Delta f - \frac { \partial } { \partial t } f = X ^ { \prime } T - X T ^ { \prime } = 0 .
$$

Since the above holds for any ( x,t ) , it follows that:

$$
\frac { X ^ { \prime } } { X } = \frac { T ^ { \prime } } { T } = - \lambda \ \ ( \text {some constant} ) .
$$

In other words, the spatial and temporal parts of the solution are eigenfunctions of the Laplacian and first-order derivative operators, respectively:

$$
X ^ { \prime } = \Delta X = - \lambda X , \ \ T ^ { \prime } = \frac { \partial } { \partial t } T = - \lambda T ,
$$

which we can express in closed form as:

$$
\Delta e ^ { i n x } = - n ^ { 2 } e ^ { i n x } , \quad \frac { \partial } { \partial t } e ^ { - n ^ { 2 } t } = - n ^ { 2 } e ^ { - n ^ { 2 } t } ,
$$

where λ = − n 2 is the corresponding eigenvalue.

Hence, solutions to the equation take the form f n ( x,t ) = e inx e − n 2 t . Due to the linearity of the equation, any linear combination of such solutions is also a solution, so the general solution can be written as:

$$
f ( x , t ) = \sum _ { n = - \infty } ^ { \infty } a _ { n } e ^ { i n x } e ^ { - n ^ { 2 } t } .
$$

Note that we sum over all integer values of n (including both positive and negative values) to account for the full Fourier expansion.

f ( x, t ) is the temperature at point x at time t .

[Page 64]

To find a unique solution, we must use the initial condition. The set { e inx } n ∈ Z forms an orthonormal basis for L 2 ( S 1 ) . Therefore, we can express the initial condition g ( x ) as a Fourier series:

$$
g ( x ) = \sum _ { n = - \infty } ^ { \infty } \langle g , e ^ { i n x } \rangle e ^ { i n x } ,
$$

where ⟨ g,e inx ⟩ is the Fourier coefficient for g ( x ) .

Since f ( x, 0) = g ( x ) , we can identify a n = ˆ g n = ⟨ g,e inx ⟩ . Using the standard inner product for periodic functions, we obtain the general solution:

$$
f ( x , t ) \ & = \ \sum _ { n = - \infty } ^ { \infty } \frac { 1 } { 2 \pi } \int _ { - \pi } ^ { \pi } g ( y ) e ^ { - i n y } \, d y \, e ^ { i n x } e ^ { - n ^ { 2 } t } \\ & = \ \frac { 1 } { 2 \pi } \int _ { - \pi } ^ { \pi } g ( y ) \underbrace { \sum _ { n = - \infty } ^ { \infty } e ^ { - n ^ { 2 } t } e ^ { - i n ( x - y ) } \, d y } _ { h _ { t } ( x - y ) } = g * h _ { t } ,
$$

where ⋆ denotes convolution.

The function h t ( x ) is called the fundamental solution of the heat equation, or the heat kernel . In particular, for the case where the initial condition is the Dirac delta function, g ( x ) = δ ( x ) (an impulse initial condition), we have:

$$
\langle \delta , e ^ { i n x } \rangle = e ^ { i n 0 } = 1 , \ \ \text {so} \ \ a _ { n } = 1 \ \ \forall n ,
$$

which implies that the solution is:

$$
f ( x , t ) = \sum _ { n = - \infty } ^ { \infty } e ^ { - n ^ { 2 } t } e ^ { i n x } = h _ { t } ( x ) .
$$

In signal processing terms, h t is referred to as the impulse response of the system.

A Short Note on Wavelets Wavelets are a generalization of Fourier transforms. While Fourier transforms decompose functions into globally defined sinusoidal components, wavelets decompose functions using basis functions (often orthogonal, but not exclusively so) that are localized in both time and frequency. This localization enables wavelets to represent transient and hierarchical features in data. Before the advent of AlexNet in 2012 and the rise of deep learning, wavelet transforms were widely used in computer vision and signal processing due to their ability to simultaneously capture spatial and frequency information, making them particularly effective for tasks such as image compression, denoising, and texture analysis.

Spectral Theory in Geometric Deep Learning. Spectral theory provides a mathematically rigorous framework for extending traditional Deep Learning approaches for Euclidean data to irregular domains such as graphs and manifolds while maintaining important properties like translation invariance and locality.

Note that g ( x ) does not depend on time, so we use the eigenfunctions of the Laplacian.

The Dirac delta function is analogous to the Kronecker delta but in the continuous case. It is defined as:

$$
\delta ( x - y ) = \begin{cases} \infty , & \text {if } x = y , \\ 0 , & \text {if } x \neq y , \end{cases}
$$

̸

with the important property that its integral over the entire real line is equal to 1:

$$
\int _ { - \infty } ^ { \infty } \delta ( x - y ) \, d y = 1 .
$$

In the context of Fourier analysis, the Dirac delta function can be represented as:

$$
\delta ( x - y ) = \sum _ { n = - \infty } ^ { \infty } e ^ { i n ( x - y ) } .
$$

The Dirac delta function acts as an identity element in the Fourier transform, meaning that for any function f ( x ) :

$$
\int _ { - \infty } ^ { \infty } f ( y ) \delta ( x - y ) \, d y = f ( x ) .
$$

[Page 65]

# 7 Graph Theory

While continuous geometry might examine smooth curves or surfaces, discrete geometry focuses on structures that can be enumerated or broken down into distinct, countable elements. Graph theory [14] is a subset of discrete geometry that is central to GNNs, which are perhaps the quintessential artificial neural network architecture in Geometric Deep Learning.

# 7.1 Preliminaries on Graphs and Notation

We start by discussing basic definitions and notation to describe graphs.

A graph is an ordered tuple:

$$
G = ( V , E ) ,
$$

where V is a set of nodes (or vertices), and E ⊆ ( V × V ) is a 2-tuple set representing the edges (or links) in the graph.

Edges may be directed or undirected. Directed edges are uni-directional relations from a source node v i to a target node v j ; thus, ( v i ,v j ) ∈ E , and importantly, ( v i ,v j ) ̸ = ( v j ,v i ) .

̸

A directed graph (or digraph ) is a graph G = ( V,E ) where each edge in E is an ordered pair of nodes.

In contrast, undirected edges are bidirectional, so ( v i ,v j ) = ( v j ,v i ) . When an edge connects a node to itself, we call it a self-loop ( v i ,v i ) .

The (one-hop) neighborhood of a node v i is the set of nodes that share an edge with v i , denoted as

$$
\mathcal { N } ( v _ { i } ) = \mathcal { N } _ { i } = \{ v _ { j } | ( v _ { i } , v _ { j } ) \in E \} .
$$

A subgraph H = ( V H ,E H ) of a graph G = ( V G ,E G ) is a graph where V H ⊆ V G and E H ⊆ E G .

If we consider the set { v i }∪N ( v i ) as nodes and include all edges in E that connect these nodes, this defines a neighborhood subgraph of v i , which is a subgraph of G .

![image 28](<BordeBronstein2025/imageFile28.png>)

Figure 20: Diagram of a graph with nodes in gray and edges in black.

Note however that Geometric Deep Learning is a broader framework that extends Deep Learning techniques to non-Euclidean domains, with one such instantiation being learning over graphs.

The famous K¨ onigsberg Bridge Problem was solved by Euler in 1736 and is one of the earliest examples of graph theory. It is also deeply connected to topology.

J. Sylvester mentions the term ‘graph’ as early as 1878 in a chemical context.

![image 29](<BordeBronstein2025/imageFile29.png>)

[Page 66]

The Adjacency Matrix Graphs can be represented using matrices. For a graph with N = | V | number of nodes, its adjacency matrix A ∈ R N × N represents the connectivity structure between nodes. A can be weighted or unweighted. If it is weighted, its entries A ij ∈ R represent the weight or strength of the connection, and if ( v i ,v j ) / ∈ E , then A ij = 0 . w : E → R + is the weight function assigning positive real numbers to edges: if e = ( v i ,v j ) , then w ( e ) = A ij . In the case of an unweighted adjacency matrix, A ij = 1 when there is an edge and A ij = 0 when there is no edge. So that,

$$
A _ { i j } = \begin{cases} 1 & \text {if } ( v _ { i } , v _ { j } ) \in E \\ 0 & \text {if } ( v _ { i } , v _ { j } ) \notin E . \end{cases}
$$

Hence, if the graphs’ edges are unweighted and undirectional, the corresponding adjacency matrix is binary and symmetric. On the other hand, the adjacency matrix of a digraph is generally asymmetric, since A ij ̸ = A ji in the case of directed edges. Lastly, the diagonal degree matrix D ∈ R N × N is defined as the matrix where each entry on the diagonal is the row-sum of the adjacency matrix: D ii =   j A ij , which is also symmetric for undirected graphs.

̸

For example, we can number the nodes of an undirected infinite binary tree in level order . Let V = { v 1 ,v 2 ,v 3 ,... } , where v 1 is the root and for each v i , its left child is v 2 i and its right child is v 2 i +1 . For v 1 we have i = 1 , the left child is v 2 · 1 = v 2 , and the right child is v 2 · 1+1 = v 3 . Likewise for v 3 , i = 3 , and hence its left child is v 2 · 3 = v 6 and its right child is v 2 · 3+1 = v 7 . In summary, the weight function is defined as

$$
w ( v _ { i } , v _ { j } ) = w ( v _ { j } , v _ { i } ) = \begin{cases} 1 , & \text {if } \{ i , j \} \text { is a parent-child pair } ( i . e . , j = 2 i \, or \, j = 2 i + 1 ) , \\ 0 , & \text {otherwise.} \end{cases}
$$

This weight function defines the entries of the adjacency matrix A of the infinite binary tree A ij = A ji = w ( v i ,v j ) . Since the tree is infinite, the full adjacency matrix is an infinite matrix too:

$$
\begin{array} { c | c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c
$$

Graph Connectivity Whether a graph is connected or not determines if information propagation across all vertices of the graph is possible.

Convolutional Neural Networks operate on images and preserve the connectivity equivalent to that of a grid.

![image 30](<BordeBronstein2025/imageFile30.png>)

[Page 67]

A graph G = ( V,E ) is said to be connected if there is a path between every pair of nodes in the graph. In other words, for any two nodes v i and v j , there exists a sequence of edges e 1 ,e 2 ,...,e k ∈ E such that v i and v j are endpoints of this sequence.

Conversely, in a disconnected graph, there exist pairs for which no such path exists.

At the node level, degree centrality is a measure of the importance or influence of a node in a graph based on its connectivity.

The degree centrality of a node measures the number of direct connections a node has. In an undirected graph, the degree d ( v i ) of a node v i is simply the number of edges connected to it:

$$
d e g ( v _ { i } ) = \sum _ { j } A _ { i j } = \sum _ { j } A _ { j i } .
$$

In directed graphs, the in-degree and out-degree are defined as the number of incoming and outgoing edges, respectively:

$$
d e g _ { i n } ( v _ { i } ) = \sum _ { j } A _ { j i } , \quad d e g _ { o u t } ( v _ { i } ) = \sum _ { j } A _ { i j } .
$$

Intuitively, a node with high degree centrality is likely to have smaller shortest path distances to other nodes.

The shortest path (graph geodesic) distance between two nodes v i ,v j ∈ V in a weighted graph G = ( V,E ) , denoted d G ( v i ,v j ) , is the minimum total weight of any path connecting these nodes. Formally, for a path P = ( e 1 ,...,e k ) where e i ∈ E , we define:

$$
d _ { G } ( v _ { i } , v _ { j } ) = \min _ { P \in \mathcal { P } _ { i j } } \sum _ { e _ { k } \in P } w ( e _ { k } )
$$

where P ij is the set of all paths from v i to v j in G , and w : E → R + is the weight function assigning positive real numbers to edges.

Consider a weighted graph G with the node set V = { v 1 ,v 2 ,v 3 ,v 4 } , and weighted edges defined by w ( v 1 ,v 2 ) = 2 ,w ( v 1 ,v 3 ) = 4 ,w ( v 2 ,v 3 ) = 1 ,w ( v 3 ,v 4 ) = 3 . For all other pairs of nodes the weights are 0 . This weight function is reflected in the adjacency matrix A ∈ R 4 × 4 , where each entry is given by

$$
A _ { i j } = \begin{cases} w ( v _ { i } , v _ { j } ) & \text {if } ( v _ { i } , v _ { j } ) \in E , \\ 0 & \text {if } ( v _ { i } , v _ { j } ) \notin E . \end{cases}
$$

In our example, the explicit adjacency matrix is:

$$
A = \begin{pmatrix} 0 & 2 & 4 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 3 \\ 0 & 0 & 0 & 0 \end{pmatrix} .
$$

The possible paths from v 1 to v 4 are: P 1 : v 1 → v 2 → v 3 → v 4 , with total weight w ( P 1 ) = w ( v 1 , v 2 ) + w ( v 2 , v 3 ) + w ( v 3 , v 4 ) = 2 + 1 + 3 = 6 . P 2 : v 1 → v 3 → v 4 , with total weight w ( P 2 ) = w ( v 1 , v 3 ) + w ( v 3 , v 4 ) = 4 + 3 = 7 . Thus, the shortest path (graph geodesic) distance between v 1 and v 4 is d G ( v 1 , v 4 ) = min { 6 , 7 } = 6 .

[Page 68]

If no path exists between v i and v j , we define the shortest path to be d G ( v i ,v j ) = ∞ . For unweighted graphs, the distance equals the minimum number of edges in any path between the nodes. Note that the shortest path distance induces a metric space ( V,d G ) over the vertex set of the graph G .

The diameter of a graph is the longest shortest path between any two nodes in a graph.

The diameter diam ( G ) is defined as the maximum value of the shortest path distances between all pairs of nodes:

$$
d i a m ( G ) = \max _ { v _ { i } , v _ { j } \in V } d _ { G } ( v _ { i } , v _ { j } ) ,
$$

where d ( v i ,v j ) is the shortest path distance between nodes v i and v j .

Let us compute the diameter for an undirected graph G with nodes V = { v 1 ,v 2 ,v 3 ,v 4 } and weighted edges w ( v 1 ,v 2 ) = 2 ,w ( v 1 ,v 3 ) = 4 ,w ( v 2 ,v 3 ) = 1 ,w ( v 3 ,v 4 ) = 3 . For any pair of nodes that are not directly connected, we set the weight to 0 . First we must compute the shortest paths between nodes. Between v 1 and v 2 we have d G ( v 1 ,v 2 ) = 2 since there is a direct edge. Between v 1 and v 3 , there is a direct edge with weight 4 , but we also have the path v 1 → v 2 → v 3 with total weight 2 + 1 = 3 . Hence, d G ( v 1 ,v 3 ) = min { 4 , 3 } = 3 . Between v 1 and v 4 , there are two possible paths: v 1 → v 3 → v 4 , with weight 3 + 3 = 6 (using the shorter v 1 → v 3 path computed above), and v 1 → v 2 → v 3 → v 4 , with weight 2 + 1 + 3 = 6 . Thus, d G ( v 1 ,v 4 ) = min { 6 , 6 } = 6 . Similarly, we have d G ( v 2 ,v 3 ) = 1 , d G ( v 2 ,v 4 ) = d G ( v 2 ,v 3 ) + d G ( v 3 ,v 4 ) = 1 + 3 = 4 , and d G ( v 3 ,v 4 ) = 3 . Therefore, the pairwise distances (ignoring the trivial zero distances from a node to itself) are { 2 , 3 , 6 , 1 , 4 , 3 } , and given that the diameter of a graph is defined as the maximum shortest path distance between any two nodes we obtain: diam ( G ) = max { 2 , 3 , 6 , 1 , 4 , 3 , 0 } = 6 .

Types of Graphs Next, we discuss important types of graphs based on their connectivity structures, or graph topology . At one extreme, we can consider graphs that are completely disconnected, known as point clouds. These are actually common in many applications, such as remote sensing technology and surface reconstruction.

A point cloud (or null graph N N , where the subscript stands for N = | V | ) is a graph G = ( V,E ) whose edge set is the empty set E = ∅ .

At the other end of the spectrum, we have complete graphs, which represent the maximum possible number of edges in a graph with N vertices, where every vertex is directly connected to every other vertex.

A complete graph is a graph in which every pair of distinct vertices is connected by a unique edge. A complete graph with N vertices is denoted K N .

For optimization purposes alternative definitions of the distance between disconnected nodes may be more appropiate than using ∞ .

The term point cloud is often associated with points (or nodes) having coordinates in R 2 or R 3 , while the term null graph is more commonly used in graph theory textbooks to refer to graphs without feature vectors.

![image 31](<BordeBronstein2025/imageFile31.png>)

However, in the GNN literature, point clouds do not necessarily have spatial coordinates.

[Page 69]

Thus, in a complete graph there are no disconnected components and all vertices are reachable from each other, with a graph geodesic distance equal to 1 for unweighted graphs.

A bipartite graph G = ( V,E ) consists of a set of vertices V , which can be partitioned into two disjoint subsets V 1 and V 2 , such that V = V 1 ∪ V 2 and V 1 ∩ V 2 = ∅ , and a set of edges E ⊆ {{ u,v } | u ∈ V 1 ,v ∈ V 2 } , meaning that edges only connect vertices in V 1 to vertices in V 2 .

In simpler terms, a bipartite graph is a graph in which the vertices can be divided into two disjoint sets, such that no two vertices within the same set are adjacent, and edges connect only vertices from different sets. Bipartite graphs are commonly used for modeling in recommendation systems and for matching products to users.

Paths and Cycles Next, we discuss paths and cycles as graph substructures.

A path graph is a graph where the vertices are arranged in a linear sequence, such that each vertex is connected to at most two others. A path graph with N vertices is denoted P N .

P N consists of N vertices and N − 1 edges, where the endpoints (also called leaves) have degree 1, and all other vertices have degree 2. For instance, consider the vertex set V = { 1 , 2 ,...,N } , where each vertex corresponds to an element of N and the edge set is E = { ( v i ,v i +1 ) | i ∈ { 1 , 2 ,...,N − 1 }} , representing the connections between consecutive numbers. This construction discretizes the natural numbers by treating them as evenly spaced points on a line.

A cycle in a graph is a path that starts and ends at the same node, with all intermediate vertices being distinct. An acyclic graph is one that does not contain any cycles (or closed loops).

A cycle graph is a graph that consists of a single cycle, where each vertex is connected to exactly two others, forming a closed loop. A cycle graph with N vertices is denoted C N .

A directed acyclic graph (DAG) is a directed graph that contains no cycles. In a DAG, the edges have a direction, and there is no directed path that leads back to the starting node.

A tree is a connected, acyclic graph where there is exactly one path between any two nodes. It has | V | − 1 edges for | V | vertices.

A directed tree is a type of DAG, but trees can also be undirected.

Regular Graphs In many applications where the underlying graph connectivity is unknown, such as in latent graph inference and bioinformatics, one assumes the underlying

Path graphs can represent linear sequences or chains in networks.

The circular structure of a cycle graph can be used to represent periodic phenomena.

DAGs are often used to describe causality.

Trees have negative curvature and exhibit exponential volume growth.

![image 32](<BordeBronstein2025/imageFile32.png>)

[Page 70]

graph to be regular.

A regular graph is a graph where every vertex has the same degree. If each vertex has degree k , the graph is called k -regular .

- • The null graph N N , which is 0 -regular (no edges).
- • The cycle graph C N , which is 2 -regular.
- • The complete graph K N , which is ( N − 1) -regular.
- • Cubic graphs , a special class of 3 -regular graphs, such as the Petersen graph .


Geometric Graphs In geometric graphs nodes are represented as points in Euclidean space and their relationships are often defined based on distance or some other notion of geometric proximity according to the space’s metric.

![image 33](<BordeBronstein2025/imageFile33.png>)

Figure 21: Geometric graphs can be used as mathematical abstractions of biomolecules.

A geometric graph G = ( V,E ) is a graph where each node v i ∈ V is associated with a point in a geometric space, typically R 2 or R 3 , and edges ( v i ,v j ) ∈ E are determined by the positions of the nodes.

As discussed in the preliminaries in Section 7.1, connections between nodes are represented by an adjacency matrix, but they also have geometric positions (e.g., atoms in 3D) and geometric features (e.g., velocities).

Often, in geometric graphs we use the unit disk graph approach where edges ( v i ,v j ) ∈ E are included if the distance d ( v i ,v j ) between nodes v i and v j is less than or equal to a fixed threshold ϵ , i.e., d ( v i ,v j ) ≤ ϵ .

An alternative approach is to use k-nearest neighbor (k-NN) graphs . In a k-NN graph, each node is connected to its k -closest neighbors in the geometric space, based on the distance metric d ( v i ,v j ) . This method does not rely on a fixed threshold, but instead ensures that each node is connected to exactly k other nodes, that is, it is a k-regular graph.

Homophily and Heterophily We can assign class labels y i to each node v i . Most realworld graph datasets adhere to the principle of homophily, where connected nodes tend to The Petersen graph is a 10-vertex, 15-edge undirected graph that plays a prominent role in graph theory, often used as a key example or counterexample in various problems.

Proximity is used to infer the graph connectivity of molecules based on electron cloud images obtained through X-ray crystallography.

k-NN type properties might be desirable if the graph’s density is intended to remain consistent, as it can also prevent the occurrence of disconnected components. However, it imposes constraints on the graph’s connectivity structure and may result in connections between nodes that are unreasonably distant.

It is also possible to assign labels at the graph or edge level.

[Page 71]

belong to the same class. For example, in citation networks, similar research works cite each other. Homophily can be calculated as the fraction of intra-class graph edges:

$$
h = \frac { 1 } { | E | } \sum _ { ( v _ { i } , v _ { j } ) \in E } 1 ( y _ { i } = y _ { j } ) ,
$$

where 1 is the indicator function evaluating to one when the labels of adjacent nodes are equal. The homophily level h can take values between 0 and 1. We refer to graphs with low h values as being heterophilic or non-homophilic. Most classical GNN architectures rely on the implicit assumption that graph labels are homophilic.

Meshes and other Discrete Structures Although the main focus in this section is on graphs, other structures such as meshes and simplicial complexes are also important in many computational applications. Rather than delving into the details, our goal here is to make the reader aware of the existence of such mathematical objects.

A mesh is a discrete representation of a geometric domain, typically composed of vertices, edges, and faces (often triangles or polygons) that approximate a continuous surface or manifold.

Meshes are widely used in computer graphics, geometry processing, and physical simulation such as in computational fluid dynamics and other engineering applications.

![image 34](<BordeBronstein2025/imageFile34.png>)

Figure 22: The Stanford Bunny is now one of the most recognizable 3D test models in computer graphics. It was originally developed by Greg Turk and Marc Levoy in 1994 at Stanford University.

A simplicial complex is a combinatorial object built from simplices (points, line segments, triangles, tetrahedra, etc.) that are glued together in a way that satisfies certain intersection and inclusion rules.

Simplicial complexes generalize meshes by allowing the construction of higher-dimensional elements. These structures allow for richer notions of locality and multi-scale representation, and are also key to extending graph-based methods into the realm of topological deep learning.

Example highly homophilic graph.

![image 35](<BordeBronstein2025/imageFile35.png>)

[Page 72]

# 7.2 Group Theory and Graphs

Permutation-invariance In many graph machine learning applications, it is important to preserve the structure of the data under reordering, since the numbering of the nodes is arbitrary to begin with. This is where symmetric groups and permutation-invariant aggregators come into play.

Let S be a set with | S | = N . The symmetric group of S , denoted by S N , is the set of all bijections from S to itself:

$$
S _ { N } = \{ \sigma \colon S \rightarrow S \, | \, \sigma \text { is a bijection} \} .
$$

A permutation-invariant aggregator is a function   : X N → Y that satisfies the condition

$$
\bigoplus ( x _ { 1 } , x _ { 2 } , \dots , x _ { N } ) = \bigoplus ( x _ { \sigma ( 1 ) } , x _ { \sigma ( 2 ) } , \dots , x _ { \sigma ( N ) } ) ,
$$

for any permutation σ ∈ S N , and X N denotes the set of all ordered tuples of N elements from the set X .

Common examples of permutation-invariant aggregators include summation   N i =1 x i , mean 1 N   N i =1 x i , and maximum max N i =1 x i , where x i are features vectors associated to each node v i as later discussed in Section 7.3. These operations are commonly used at the end of GNN architectures to pool the features from all the nodes in the graph into a single feature vector which can be used for graph level classification or regression.

Permutation matrices formalize the reordering or relabeling of nodes in a graph. Such reordering preserves the intrinsic graph structure, as the node labeling is arbitrary.

A permutation matrix P is a square binary matrix where exactly one entry in each row and each column is equal to 1, and all other entries are 0. Formally, for an N × N permutation matrix P , it holds that:

$$
P _ { i j } = \begin{cases} 1 & \text {if node $i$ is mapped to node $j$,} \\ 0 & \text {otherwise.} \end{cases}
$$

Such a matrix corresponds uniquely to an element of the symmetric group S N .

Permutation matrices are orthogonal, which implies that P − 1 = P T and thus PP T = P T P = I , where I is the identity matrix. When applying a permutation matrix P to a graph with adjacency matrix A , the adjacency matrix transforms as follows:

$$
A ^ { \prime } = P A P ^ { T } ,
$$

where A ′ is the permuted adjacency matrix, corresponding to the same graph with vertices relabeled according to P . Importantly, graph invariants such as the eigenvalues of the adjacency matrix, node degrees, and connectivity structure remain unchanged by permutations.

[Page 73]

Graph Homomorphisms Similar to group homomorphisms which allow us to relate equivalent groups that can be realized differently (Section 1.2), graph homomorphisms provide a mathematical framework for studying mappings between graphs that preserve their structural properties. This can be particularly relevant in the context of network compression, graph colorings, and GNN expressivity analysis.

A graph homomorphism is a mapping F : V G → V H between the vertex sets of two graphs G = ( V G ,E G ) and H = ( V H ,E H ) such that if ( v i ,v j ) ∈ E G , then ( F ( v i ) ,F ( v j )) ∈ E H .

Intuitively, a graph homomorphism maps edges of G to edges of H , preserving the adjacency structure: if v i and v j are adjacent in G , their images F ( v i ) and F ( v j ) are adjacent in H . Note that in general, a homomorphism can map multiple vertices or edges of G onto a single vertex or edge in H . This enables the simplification (or coarsening ) of graph structures while retaining connectivity properties.

A graph isomorphism is a bijective mapping F : V G → V H between the vertex sets of two graphs G = ( V G ,E G ) and H = ( V H ,E H ) such that ( v i ,v j ) ∈ E G if and only if ( F ( v i ) ,F ( v j )) ∈ E H .

Graph isomorphisms are a specific class of graph homomorphisms in which the mapping must be bijective, and the edge-preservation condition is bidirectional.

![image 36](<BordeBronstein2025/imageFile36.png>)

Figure 23: The Weisfeiler-Lehman (WL) test is a method used to determine whether two graphs are isomorphic by iteratively refining node labels based on their neighborhoods.

# Examples of Graph Homomorphisms

- • Consider a cycle graph C 6 with six vertices and a complete graph K 3 . A homomorphism F : V C 6 → V K 3 exists, where vertices of C 6 are mapped to vertices of K 3 in a repeating pattern.
- • For bipartite graphs, any homomorphism maps vertices in one partition to one set of vertices in the target graph and the other partition to the other set.
- • Let P 11 be a path graph with eleven vertices, and C 10 be a cycle graph with ten vertices. A homomorphism F : V P 11 → V C 10 exists where each vertex of P 11 is mapped to a vertex of C 10 , and edges of P 11 are mapped to edges of C 10 . Note that in this case the vertices at the start and end of the path graph would be mapped (or collapsed) to a single vertex.


[Page 74]

# 7.3 Vector Fields on Graphs

Although so far our discussion has centered on graphs in terms of their connectivity structure, in practical scenarios and particularly in the context of Geometric Deep Learning, we primarily deal with graphs that have node attributes. Next, we consider graphs where each node has associated feature vectors and introduce relevant notation.

A feature vector x i at node v i is a D -dimensional vector that represents the characteristics or attributes of the node in the graph.

These vectors are organized into a matrix X ∈ R N × D for all nodes N = | V | in the graph. In the following expression, each entry x ij represents the j -th feature of node i :

$$
X = \begin{bmatrix} - x _ { 1 } ^ { \top } - \\ - x _ { 2 } ^ { \top } - \\ \vdots \\ - x _ { N } ^ { \top } - \end{bmatrix} = \begin{bmatrix} x _ { 1 1 } & x _ { 1 2 } & \cdots & x _ { 1 D } \\ x _ { 2 1 } & x _ { 2 2 } & \cdots & x _ { 2 D } \\ \vdots & \vdots & \ddots & \vdots \\ x _ { N 1 } & x _ { N 2 } & \cdots & x _ { N D } \end{bmatrix} .
$$

Equivalently, linking this discussion back to Section 3.2, we can define the feature vector field F as a mapping from the graph domain (nodes in the graph) to R D , where D is the number of features for each node:

$$
F \colon V \rightarrow \mathbb { R } ^ { D } , \ \ F ( v _ { i } ) = x _ { i } \in \mathbb { R } ^ { D } , \ \forall v _ { i } \in V .
$$

In geometric graphs, the matrix S ∈ R N × D is sometimes used to denote scalar node features, while X ∈ R N × 3 is reserved to represent 3D coordinates, and V ∈ R N × 3 is used to represent additional geometric features.

Permuting Feature Vectors Next, we give concrete examples, showing how the output produced by permutation-invariant aggregators remains unchanged when applying the permutation matrix to a matrix containing feature vectors. Let N = 3 and D = 2 . Suppose our node feature matrix is

$$
X = \begin{bmatrix} 1 & 2 \\ 3 & 4 \\ 5 & 6 \end{bmatrix} ,
$$

so x 1 = [1 , 2] ⊤ , x 2 = [3 , 4] ⊤ , x 3 = [5 , 6] ⊤ . Consider the permutation σ that swaps nodes 1 and 2 (and leaves 3 fixed). The corresponding permutation matrix is

$$
P = \begin{bmatrix} 0 & 1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 1 \end{bmatrix} .
$$

Applying P to X yields

$$
P X = \begin{bmatrix} 0 & 1 & 0 \\ 1 & 0 & 0 \\ 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 1 & 2 \\ 3 & 4 \\ 5 & 6 \end{bmatrix} = \begin{bmatrix} 3 & 4 \\ 1 & 2 \\ 5 & 6 \end{bmatrix} .
$$

[Page 75]

Check the sum:

$$
\sum _ { i = 1 } ^ { 3 } x _ { i } = \left [ _ { 2 + 4 + 6 } ^ { 1 + 3 + 5 } \right ] = \left [ _ { 1 2 } ^ { 9 } \right ] , \quad \sum _ { i = 1 } ^ { 3 } ( P X ) _ { i } = \begin{bmatrix} 3 + 1 + 5 \\ 4 + 2 + 6 \end{bmatrix} = \begin{bmatrix} 9 \\ 1 2 \end{bmatrix} .
$$

Thus   i x i =   i ( PX ) i =   i Px i = P   i x i , illustrating permutation-invariance. Also, it is trivial to verify that for the mean the same logic holds:

$$
\text {mean} ( X ) & = \frac { 1 } { 3 } \sum _ { i = 1 } ^ { 3 } x _ { i } = \frac { 1 } { 3 } \begin{bmatrix} 1 + 3 + 5 \\ 2 + 4 + 6 \end{bmatrix} = \begin{bmatrix} 3 \\ 4 \end{bmatrix} , \\ \text {mean} ( P X ) & = \frac { 1 } { 3 } \sum _ { i = 1 } ^ { 3 } ( P X ) _ { i } = \frac { 1 } { 3 } \begin{bmatrix} 3 + 1 + 5 \\ 4 + 2 + 6 \end{bmatrix} = \begin{bmatrix} 3 \\ 4 \end{bmatrix} . \\
$$

$$
-
$$

Thus mean( X ) = mean( P X ) . Finally, for the max:

$$
3 _ { \max { x } _ { i } = \begin{bmatrix} \max \{ 1 , 3 , 5 \} \\ \max \{ 2 , 4 , 6 \} \end{bmatrix} } & = \begin{bmatrix} 5 \\ 6 \end{bmatrix} , \\ 3 _ { i = 1 } ^ { 3 } & ( P X ) _ { i } = \begin{bmatrix} \max \{ 3 , 1 , 5 \} \\ \max \{ 4 , 2 , 6 \} \end{bmatrix} = \begin{bmatrix} 5 \\ 6 \end{bmatrix} .
$$

Hence max i x i = max i ( P X ) i .

The Graph Laplacian The Laplacian plays a key role in analyzing graph structures, particularly in spectral graph theory.

The graph Laplacian matrix L for a graph G = ( V,E ) is defined as:

$$
L = D - A ,
$$

where A and D are the adjacency and degree matrices of the graph, respectively.

For undirected graphs, the graph Laplacian is symmetric and positive-semidefinite.

The quadratic form associated with the graph Laplacian can be written as:

$$
x ^ { \top } L x = x ^ { \top } ( D - A ) x = \sum _ { i = 1 } ^ { n } d _ { i } x _ { i } ^ { 2 } - \sum _ { ( v _ { i } , y _ { j } ) \in E } w _ { i j } x _ { i } x _ { j } = \frac { 1 } { 2 } \sum _ { ( v _ { i } , v _ { j } ) \in E } w _ { i j } ( x _ { i } - x _ { j } ) ^ { 2 } ,
$$

where w ij = w ( e ij ) = w (( v i ,v j )) is the weight of the edge ( v i ,v j ) , and x i and x j are the feature values at nodes v i and v j , respectively. Note that this is effectively computing a gradient-like quantity over the graph, which measures the smoothness of the vector field over the graph and is analogous to the Dirichlet energy in continuous settings. It is often referred to as the graph Dirichlet energy or simply the Dirichlet energy on a graph .

The Dirichlet energy is the continuous setting is the quadratic functional ⟨ f, ∆ f ⟩ = ⟨∇ f, ∇ f ⟩ .

[Page 76]

The normalized graph Laplacian matrix L norm is defined as:

$$
L _ { n o r m } = I - D ^ { - 1 / 2 } A D ^ { - 1 / 2 } ,
$$

where I is the identity matrix, A is the adjacency matrix, and D is the degree matrix.

The form above has several useful properties: the eigenvalues of L norm lie in the range [0 , 2] and the multiplicity of the eigenvalue 0 corresponds to the number of connected components in the graph.

Spectral Properties and Graph Frequencies The eigenvectors of the graph Laplacian provide a natural generalization of the classical Fourier basis to graphs. This spectral perspective enables us to decompose signals over a graph into components of varying smoothness.

Let L ∈ R N × N be the graph Laplacian of a graph G = ( V,E ) and N = | V | . Since L is symmetric and positive-semidefinite for undirected graphs, it admits an eigen-decomposition:

$$
L = U \Lambda U ^ { \top } ,
$$

where U = [ u 1 ,u 2 ,...,u N ] is an orthonormal basis of eigenvectors (the graph Fourier basis ) and Λ = diag ( λ 1 ,λ 2 ,...,λ N ) is the diagonal matrix of eigenvalues.

Each eigenvector u k defines a basis function over the graph nodes, and its associated eigenvalue λ k determines the ‘frequency’ of that basis: lower eigenvalues correspond to smooth, slowly-varying functions over the graph, while higher eigenvalues capture more oscillatory variations. This frequency structure allows us to design filtering operations analogous to classical low-pass or high-pass filters.

Given a signal f : V → R defined on the graph nodes, it can be expressed as a linear combination of these eigenvectors:

$$
f = \sum _ { k = 1 } ^ { N } \langle f , u _ { k } \rangle u _ { k } .
$$

The coefficients ⟨ f,u k ⟩ constitute the graph Fourier transform of f , allowing for the design of frequency-aware processing steps.

The graph Fourier transform of a signal f is defined as ˆ f = U ⊤ f , and the inverse transform is given by f = U ˆ f .

There will be as many eigenvectors as nodes in the graph. However, note that if there are degenerate eigenvalues (i.e., if an eigenvalue has multiplicity greater than one), the corresponding eigenvectors are not unique, but one can always choose an orthonormal basis consisting of N = | V | eigenvectors.

This spectral framework forms the foundation of many techniques in graph signal processing and also serves as a key tool in developing expressive architectures that incorporate

The graph Laplacian eigenvectors form a global coordinate system over the graph. They can be leveraged as positional encodings by assigning each node v i a coordinate vector p i = ( u 1 ( i ) , u 2 ( i ) , . . . , u k ( i )) obtained from the first k nontrivial eigenvectors. These encodings are isomorphism-invariant and capture the intrinsic geometry of the graph.

[Page 77]

both local and global graph structure.

Message-Passing on Graphs For GNNs, we say we are learning a signal over a graph , where the graph structure guides the flow of information between nodes. Typically, the graph on which the signal is defined is coupled with the computational graph of the artificial neural network.

More concretely, a message passing GNN layer l over a graph G is computed as

$$
x _ { i } ^ { ( l + 1 ) } = \phi \left ( x _ { i } ^ { ( l ) } , \bigoplus _ { j \in \mathcal { N } ( v _ { i } ) } \psi ( x _ { i } ^ { ( l ) } , x _ { j } ^ { ( l ) } ) \right ) ,
$$

where ψ and ϕ are non-linear functions, and   is an aggregation function, which must be permutation-invariant. The above equation constrains the information flow for each layer to local neighbourhoods and can be further decomposed into three update rules:

$$
m _ { i j } ^ { ( l ) } \leftarrow \psi ( x _ { i } ^ { ( l ) } , x _ { j } ^ { ( l ) } ) ,
$$

$$
a _ { i } ^ { ( l ) } \leftarrow \bigoplus _ { j \in \mathcal { N } ( v _ { i } ) } m _ { i j } ^ { ( l ) } ,
$$

$$
x _ { i } ^ { ( l + 1 ) } \leftarrow \phi \left ( x _ { i } ^ { ( l ) } , a _ { i } ^ { ( l ) } \right ) .
$$

Graph Theory in Geometric Deep Learning. Graph theory plays a central role in Geometric Deep Learning, particularly in the context of GNNs, which are designed to learn signals over graph structures. The underlying graph domain serves as a geometric prior, typically assuming that connected nodes share similar features. GNNs have been applied to diverse areas, including social networks, recommendation systems, and bioinformatics, for both supervised learning and generative modeling.

Transformers perform attentional message passing over a fully connected graph. Alternatively, one can interpret the attention scores as ‘discovering’ the underlying graph.

![image 37](<BordeBronstein2025/imageFile37.png>)

[Page 78]

# References

- [1] Michael Bronstein. Computer Vision and Pattern Recognition Course Notes . Universit` a della Svizzera italiana, 2019.
- [2] Michael Bronstein. Geometric Deep Learning Course Slides . University of Oxford, 2024.
- [3] Michael Bronstein, Joan Bruna, Taco Cohen, and Petar Veliˇ ckovi´ c. Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges . 2021. URL https://arxiv.org/abs/2104.13478 .
- [4] Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, and Illia Polosukhin. Attention Is All You Need. In Advances in Neural Information Processing Systems , 2017.
- [5] Yann LeCun, Yoshua Bengio, and Geoffrey Hinton. Deep learning. Nature , 521 (7553):436, 2015.
- [6] Ian Goodfellow, Yoshua Bengio, and Aaron Courville. Deep Learning . MIT Press, 2016. http://www.deeplearningbook.org .
- [7] Charles C. Pinter. A Book of Set Theory . Dover Books on Mathematics. Dover Publications, 2014. ISBN 9780486497082.
- [8] Franco Scarselli, Marco Gori, Ah Chung Tsoi, Markus Hagenbuchner, and Gabriele Monfardini. The Graph Neural Network Model. IEEE Transactions on Neural Networks , 20(1):61–80, 2009. doi: 10.1109/TNN.2008.2005605.
- [9] Bert Mendelson. Introduction to Topology . Allyn & Bacon, Inc., Boston, 1st edition, 1975.
- [10] James R. Munkres. Topology . Prentice Hall, Upper Saddle River, NJ, 2nd edition, 2000.
- [11] Manfredo P. do Carmo. Differential Geometry of Curves and Surfaces . Prentice-Hall, 1976. ISBN 0-13-2125897, 978-0132125895.
- [12] John M. Lee. Riemannian Manifolds: An Introduction to Curvature , volume 176 of Graduate Texts in Mathematics . Springer-Verlag, New York, 1st edition, 1997. ISBN 978-0-387-22726-1. doi: 10.1007/0-387-22726-1.
- [13] Yoshua Bengio, Aaron Courville, and Pascal Vincent. Representation learning: A review and new perspectives. IEEE Trans. Pattern Anal. Mach. Intell. , 35(8): 1798–1828, August 2013. ISSN 0162-8828. doi: 10.1109/TPAMI.2013.50. URL https://doi.org/10.1109/TPAMI.2013.50 .
- [14] Robin J. Wilson. Introduction to Graph Theory . Prentice Hall/Pearson, New York, 2010. ISBN 027372889X 9780273728894.


