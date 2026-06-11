# Mathematical Foundations of Geometric Deep Learning

\backgroundsetup

scale=1, color=lightline, opacity=0.75, angle=0, position=current page.east, hshift=-4cm, vshift=0cm, contents=

# Mathematical Foundations

of Geometric Deep Learning

Haitz Sáez de Ocáriz Borde and Michael Bronstein

University of Oxford

We review††margin: These notes were originally developed by Haitz Sáez de Ocáriz Borde for the ANAIS 2024 Geometric Deep Learning course in Kathmandu, Nepal. They are based on Michael Bronstein’s notes for the 2019 Computer Vision and Pattern Recognition course \[[1](https://arxiv.org/html/2508.02723v1#bib.bib1)\] at USI Lugano, Switzerland, as well as lecture slides from the 2024 Geometric Deep Learning course \[[2](https://arxiv.org/html/2508.02723v1#bib.bib2)\] at the University of Oxford, United Kingdom. the key mathematical concepts necessary for studying Geometric Deep Learning \[[3](https://arxiv.org/html/2508.02723v1#bib.bib3)\]. For a deeper understanding of specific topics, we encourage supplementing studies with additional resources.

## Introduction

Since the dawn of civilization, humans have tried to understand the nature of intelligence. With the advent of computers, there have been attempts to emulate human intelligence using computer algorithms – a field that was dubbed ‘Artificial Intelligence’ or ‘AI’ by the computer scientist John McCarthy in 1956 and has recently enjoyed an explosion of popularity. Many efforts in AI research have focused on the study and replication of what is considered the hallmark of human cognition, such as playing intelligent games, the faculty of language, visual perception, and creativity. While at the time of writing we have multiple successful takes at the above – computers nowadays play chess and Go better than any human, can translate English into Chinese without a dictionary, automatically drive a car in a crowded city, and generate poetry and art that wins artistic competitions – it is fair to say that we still do not have a full understanding of what human-like or ‘general’ intelligence entails and how to replicate it.

Most of the aforementioned examples of AI††margin: The Perceptron, introduced by Frank Rosenblatt in 1957, is perhaps the simplest form of an artificial neural network, consisting of only a single artificial neuron. Modern neural networks can contain millions of neurons with billions of weights. ![[Uncaptioned image]](figures/perceptron.png) are powered by Deep Learning, a class of algorithms whose history can be traced back to attempts in the early 20th century to replicate the connectivity and functioning of biological neurons in the brain in computers in a very abstract manner. Such systems are called (artificial) neural networks, by analogy to their biological counterparts, and consist of computational units called neurons, which are typically organized into multiple layers (the term ‘deep’ in Deep Learning refers to neural networks with many such layers). Neurons have parameters that can be tuned for a specific task in an optimization procedure referred to as ‘learning’. A subfield of AI studying mathematical methods for the design and optimization of such systems is called Machine Learning (ML).

Deep Learning is an umbrella term for Machine Learning algorithms that rely on artificial neural networks typically consisting of a large number of layers. Report issue for preceding element

### What is Geometric Deep Learning?

Report issue for preceding element ††margin: In the early 2020s there has been a clear convergence towards Transformer-based architectures across data modalities \[[4](https://arxiv.org/html/2508.02723v1#bib.bib4)\].

In recent years, there has been a rapid proliferation of various artificial neural network architectures, each suggesting different connectivity patterns and internal computations to be performed by the learning systems.

Geometric Deep Learning is a subfield of Deep Learning \[[5](https://arxiv.org/html/2508.02723v1#bib.bib5), [6](https://arxiv.org/html/2508.02723v1#bib.bib6)\] that focuses on developing artificial neural networks for data with non-Euclidean structures, such as graphs and manifolds. Traditional deep learning models, operate on grid-like data (e.g., images, time series, text), but many real-world problems involve more complex, irregular geometries. In particular, the field focuses on analyzing neural networks based on the geometric priors they leverage. Different models combat the curse of dimensionality by modeling signals on domains endowed with symmetry groups, which serve as inductive biases for the network. ††margin: Imposing inductive biases in learning systems becomes particularly important in data-scarce regimes. While modern Deep Learning is only loosely rooted in biological neural networks, some architectural choices, such as the inductive biases of Convolutional Neural Networks (CNNs), are directly inspired by the workings of the visual cortex. ![[Uncaptioned image]](figures/visual_cortex.png)

This inspiration can be traced back to the experiments of Hubel and Wiesel.

Geometric Deep Learning provides a structured approach to incorporating prior knowledge of physical symmetries into the design of new neural network architectures, while also unifying and understanding successful existing models under a common framework. Report issue for preceding element

![Refer to caption](figures/NN_zoo.png)
Figure 1: In the spirit of the Erlangen Program, Geometric Deep Learning provides a geometric unification of the zoo of Deep Learning architectures.

Report issue for preceding element††margin: In his landmark work known as the Erlangen Program, Felix Klein proposed that geometry should be approached as the study of invariants or symmetries. His vision offered a unifying framework at a time when the development of various non-Euclidean geometries had led to a fragmented mathematical landscape. Geometric Deep Learning adopts a similar perspective for understanding artificial neural network architectures by analyzing the symmetries and invariances they exploit. ![[Uncaptioned image]](figures/zoo_geometry.png)

In this text, we will not focus directly on (Geometric) Deep Learning and artificial neural networks. Instead, our objective is to provide the necessary preliminary mathematical background often overlooked in standard computer science curricula.

## 1 Algebraic Structures and Mathematics before Numbers

In this section, we study pre-numerical structures that are fundamental to understanding Geometric Deep Learning. Structures such as sets and maps allow us to mathematically describe collections of objects, the connections between them, and the operations that can be performed on them \[[7](https://arxiv.org/html/2508.02723v1#bib.bib7)\]. A key focus is on groups, which are used in Geometric Deep Learning to model the transformations of the data.

### 1.1 Sets, Maps, and Functions

At first glance, numbers may appear as the most elementary objects in mathematics. However, it is possible to identify even simpler and more basic structures. Indeed, numbers can be added, subtracted, multiplied, and so on, which requires a set of rules defining how these operations are done. But what if we consider just a collection of objects, stripped off any additional assumptions about them?

A set is a collection of distinct objects, called elements or members of the set. ††margin: The elements of a set are not restricted to being numbers; they could also be English words, for instance: {cat,dog}\{\textrm{cat},\,\textrm{dog}\}{ cat , dog }. Report issue for preceding element

These elements can be anything: numbers, symbols, or even other sets. What characterizes a set is that it does not allow for a repetition of elements (i.e., every element appears only once in a set)††margin: A \emmultiset is a set in which elements are allowed to appear more than once. Multisets are common in Geometric Deep Learning in the context of Graph Neural Networks (GNNs) \[[8](https://arxiv.org/html/2508.02723v1#bib.bib8)\], where they are used to model the neighborhood of a node in the graph. , and the order in which elements appear does not matter (i.e., sets are unordered). Sets are the basis for defining more complex mathematical structures.

They are typically denoted by capital letters, such as AAitalic_A, BBitalic_B, XXitalic_X, etc. The members of a set are listed inside curly braces {}\{\}{ }, and if an element xx belongs to a set AAitalic_A, we write x∈Ax\in A ∈ italic_A, which reads as ‘xx is an element of AAitalic_A’. If xx does not belong to AAitalic_A, we write x∉Ax\notin A ∉ italic_A. For instance, if A\={1,2,3},A=\{1,2,3\},italic_A = { 1 , 2 , 3 } , then 2∈A2\in A2 ∈ italic_A, but 4∉A4\notin A4 ∉ italic_A.

#### Examples of Sets

Report issue for preceding element ††margin: A non-example would be the collection of all sets: there is no set containing all sets.

- •

  ∅\emptyset∅: The empty set, a set with no elements. It is denoted by ∅\emptyset∅ or sometimes by {}\{\}{ }.

  Report issue for preceding element

- •

  Singleton Set: A set with exactly one element, for example, {1}\{1\}{ 1 }.

  Report issue for preceding element

- •

  ℕ\={1,2,3,…}\mathbb{N}=\{1,2,3,\ldots\} = { 1 , 2 , 3 , … }: The set of natural numbers. The ellipsis …\ldots… indicates that the set continues indefinitely with positive integers. ††margin: In some textbooks ℕ\mathbb{N} may include 0.

  Report issue for preceding element

- •

  ℤ\={…,−3,−2,−1,0,1,2,3,…}\mathbb{Z}=\{\ldots,-3,-2,-1,0,1,2,3,\ldots\} = { … , - 3 , - 2 , - 1 , 0 , 1 , 2 , 3 , … }:††margin: The notation ℤ\mathbb{Z} for integers comes from the German \emZahlen, which means ‘numbers’. The set of integers, which includes positive numbers, negative numbers, and zero.

  Report issue for preceding element

- •

  ℚ\={pq∣p∈ℤ,q∈ℕ}\mathbb{Q}=\left\{\frac{p}{q}\mid p\in\mathbb{Z},q\in\mathbb{N}\right\} = { divide  ∣  ∈  ,  ∈  }: The set of rational numbers, which are numbers that can be expressed as a ratio of two integers.

  Report issue for preceding element

- •

  ℝ\mathbb{R}: The set of all real numbers, including both rational numbers (e.g., 1,0.75,−31,0.75,-31 , 0.75 , - 3) and irrational numbers (e.g., π,2\pi,\sqrt{2}italic_π , square-root ).

  Report issue for preceding element

- •

  ℂ\mathbb{C}: The set of all complex numbers, which can be written as a+b​ia+bi +  , where aa and bb are real numbers and ii is the imaginary unit with i2\=−1i^{2}=-1  = - 1.

  Report issue for preceding element

#### Set Notation and Operations

- •

  Set Builder Notation: Set builder notation is used to describe a set by specifying an expression or the general form of an element, followed by a vertical bar separator |||††margin: Sometimes a colon is used instead of a vertical line: {x:𝔣​(x)}.\{x:\mathfrak{f}(x)\}.{  : fraktur_f (  ) } . , and, to its right, a rule that the expression on the left must satisfy.

  Report issue for preceding element

  {x|𝔣​(x)}\={expression|rule satisfied by the expression}.\{x|\mathfrak{f}(x)\}=\{\textrm{expression}|\textrm{rule satisfied by the expression}\}.{  | fraktur_f (  ) } = { expression | rule satisfied by the expression } .

  In words, it can be read as ‘xx such that (for which) 𝔣​(x)\mathfrak{f}(x)fraktur_f (  )’.

  Report issue for preceding element

- •

  Subset: A set AAitalic_A is a subset of a set BBitalic_B, written A⊆BA\subseteq Bitalic_A ⊆ italic_B, if every element of AAitalic_A is also an element of BBitalic_B. If A⊆BA\subseteq Bitalic_A ⊆ italic_B but A≠BA\neq Bitalic_A ≠ italic_B, we say that AAitalic_A is a proper subset, written A⊂BA\subset Bitalic_A ⊂ italic_B.

  Report issue for preceding element

- •

  Union: The union of two sets AAitalic_A and BBitalic_B, written A∪BA\cup Bitalic_A ∪ italic_B, is the set of all elements that are in AAitalic_A, in BBitalic_B, or in both.

  Report issue for preceding element

- •

  Intersection: The intersection of two sets AAitalic_A and BBitalic_B, written A∩BA\cap Bitalic_A ∩ italic_B, is the set of all elements that are in both AAitalic_A and BBitalic_B.

  Report issue for preceding element

- •

  Difference: The difference of two sets AAitalic_A and BBitalic_B, written A∖BA\setminus Bitalic_A ∖ italic_B, is the set of all elements that are in AAitalic_A but not in BBitalic_B.

  Report issue for preceding element

- •

  Complement: The complement of a set AAitalic_A, written AcA^{c}italic_A , is the set of all elements not in AAitalic_A, assuming a universal set UUitalic_U that contains all elements under consideration.

  Report issue for preceding element

- •

  Power Set: The power set of a set AAitalic_A, denoted 𝒫​(A)\mathcal{P}(A)caligraphic_P ( italic_A ), is the set of all subsets of AAitalic_A, including the empty set and AAitalic_A itself.

  Report issue for preceding element

- •

  Cardinality: ††margin: The cardinality of ℕ\mathbb{N} is denoted by the Hebrew letter ℵ0\aleph\_{0}roman_ℵ , which reads as aleph-nought or aleph-zero. This is the ‘smallest’ type of infinity and represents the size of any countable infinite set, which is a set that can be placed in a one-to-one correspondence (bijection) with ℕ\mathbb{N}. For example, even though they might appear ‘larger’ at first glance, the sets ℤ\mathbb{Z} and ℚ\mathbb{Q} also have cardinality ℵ0\aleph\_{0}roman_ℵ  since they are countably infinite. The cardinality of a set is the size or number of elements it contains. If a set is finite, its cardinality is a non-negative integer. For infinite sets, cardinality is definited more abstractly: two infinite sets are said to have the same cardinality if there exists a bijection between their elements. The cardinality of a set AAitalic_A is denoted by |A||A|| italic_A | or sometimes #​(A).\#(A).\# ( italic_A ) .

  Report issue for preceding element

#### Examples of Set Builder Notation

We provide some examples to build an intuitive understanding. We start with the set builder notation. Below, we show that there are multiple ways to specify a set containing natural even numbers:

{2​x|x∈ℕ}\={x∈ℕ|x​is even}\={2,4,6,8,…}.\{2x|x\in\mathbb{N}\}=\{x\in\mathbb{N}|x\,\textrm{is even}\}=\{2,4,6,8,...\}.{ 2  |  ∈  } = {  ∈  |  is even } = { 2 , 4 , 6 , 8 , … } .

Alternatively, sometimes the rule that must be satisfied by the elements of the set could be an equation:

{x∈ℤ|x\>0}\=ℕ,\{x\in\mathbb{Z}|x>0\}=\mathbb{N},{  ∈  |  > 0 } =  ,

{x∈ℚ|x2\=2}\=∅.\{x\in\mathbb{Q}|x^{2}=2\}=\emptyset.{  ∈  |   = 2 } = ∅ .

In the last example, the solutions to the equation x2\=2x^{2}=2  = 2 are the roots x\=±2x=\pm\sqrt{2} = ± square-root , which are irrational numbers and, therefore, not elements of ℚ\mathbb{Q}. Thus, the rule has no satisfying elements, meaning we have found a convoluted way of describing the empty set.

#### Examples of Finite Sets and Simple Operations

Next, let us consider the finite sets B\={1,2,3,4,5},B=\{1,2,3,4,5\},italic_B = { 1 , 2 , 3 , 4 , 5 } , A\={1,2,3},A=\{1,2,3\},italic_A = { 1 , 2 , 3 } , C\={1,2,3,4,5},C=\{1,2,3,4,5\},italic_C = { 1 , 2 , 3 , 4 , 5 } , then C⊆BC\subseteq Bitalic_C ⊆ italic_B and A⊂BA\subset Bitalic_A ⊂ italic_B. This is because A≠BA\neq Bitalic_A ≠ italic_B, whereas C\=BC=Bitalic_C = italic_B. Their cardinalities would be |A|\=3|A|=3| italic_A | = 3, |B|\=5|B|=5| italic_B | = 5, and |C|\=5|C|=5| italic_C | = 5. The unions and intersections in this example are C∪B\=C∩B\=C\=BC\cup B=C\cap B=C=Bitalic_C ∪ italic_B = italic_C ∩ italic_B = italic_C = italic_B, A∪B\=BA\cup B=Bitalic_A ∪ italic_B = italic_B, and A∩B\=AA\cap B=Aitalic_A ∩ italic_B = italic_A. Another interesting example is the cardinality of the empty set |∅|\=0|\emptyset|=0| ∅ | = 0 and the cardinality of the singleton set containing the empty set |{∅}|\=1.|\{\emptyset\}|=1.| { ∅ } | = 1 .

#### Examples of Infinite Sets and Simple Operations

Consider the infinite sets ℕ\={1,2,3,4,5,…}\mathbb{N}=\{1,2,3,4,5,\dots\} = { 1 , 2 , 3 , 4 , 5 , … } and 𝔼\={2,4,6,8,…}\mathbb{E}=\{2,4,6,8,\dots\} = { 2 , 4 , 6 , 8 , … }, the set of natural numbers and even natural numbers, respectively. Unsurprisingly, 𝔼⊂ℕ\mathbb{E}\subset\mathbb{N} ⊂  since every element of 𝔼\mathbb{E} is an element of ℕ\mathbb{N}. However, unlike finite sets, the cardinalities of ℕ\mathbb{N} and 𝔼\mathbb{E} are equal, denoted as |ℕ|\=|𝔼|\=ℵ0|\mathbb{N}|=|\mathbb{E}|=\aleph\_{0}|  | = |  | = roman_ℵ . ††margin: The Hilbert Hotel with infinitely many rooms that are fully occupied can host an infinite number of new guests by moving the old ones into even-numbered rooms and placing the new ones into odd-numbered rooms. 

Ifthere exists a one-to-one correspondence between two infinite sets, although we cannot say that they have the same number of elements, we think of them as having the “same size”. This intuition is formalized in set theory by defining two sets AAitalic_A and BBitalic_B to be equipotent (or having the same power), if there is a one-to-one correspondence from AAitalic_A to BBitalic_B. This is due to the fact that there exists a bijection between ℕ\mathbb{N} and 𝔼\mathbb{E} (we will explain bijections in more detail soon). One such bijection f:ℕ→𝔼f:\mathbb{N}\to\mathbb{E} :  →  can be defined as f​(n)\=2​nf(n)=2n (  ) = 2 . For every natural number n∈ℕn\in\mathbb{N} ∈ , f​(n)f(n) (  ) produces a unique element of 𝔼\mathbb{E}, and every element of 𝔼\mathbb{E} is hit exactly once. For example: f​(1)\=2,f​(2)\=4,f​(3)\=6,…f(1)=2,\,f(2)=4,\,f(3)=6,\,\dots ( 1 ) = 2 ,  ( 2 ) = 4 ,  ( 3 ) = 6 , … Hence, despite 𝔼\mathbb{E} being a proper subset of ℕ\mathbb{N}, their infinite cardinality remains the same.

In terms of other operations: 𝔼∪ℕ\=ℕ,𝔼∩ℕ\=𝔼\mathbb{E}\cup\mathbb{N}=\mathbb{N},\,\mathbb{E}\cap\mathbb{N}=\mathbb{E} ∪  =  ,  ∩  =  and ℕ∖𝔼\={1,3,5,7,…}\mathbb{N}\setminus\mathbb{E}=\{1,3,5,7,\dots\} ∖  = { 1 , 3 , 5 , 7 , … }. Notably, the cardinality of the set containing, for instance, the infinite sets ℝ\mathbb{R} and ℕ\mathbb{N} is actually |{ℝ,ℕ}|\=2|\{\mathbb{R},\mathbb{N}\}|=2| {  ,  } | = 2, since the set only contains two elements, despite the elements themselves being infinite.

Sets in Geometric Deep Learning and Graph Neural Networks. In Geometric Deep Learning, we are often interested in modeling signals on collections of nodes, edges, and patches on a manifold, for instance. As we will see later in Section [7](https://arxiv.org/html/2508.02723v1#S7 "7 Graph Theory ‣ Mathematical Foundations of Geometric Deep Learning"), in the context of GNNs, the geometric domain is defined as a graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ), which is a tuple consisting of a set of nodes VVitalic_V and a set of edges EEitalic_E. Similarly, to model the neighborhood of a node, multisets (sets that allow repetition of elements) are used. Report issue for preceding element

#### Cartesian Products

After introducing sets and some basic operations, let us define the Cartesian product. Although the concept may initially seem abstract, it plays an important role in discussing manifolds and constructing more complex spaces by combining elements from simpler subspaces.††margin: The term Cartesian product comes from the Cartesian coordinate system, which in turn is named after the French philosopher and scientist René Descartes. Descartes’s name was Latinized to Renatus Cartesius, hence the adjective Cartesian. The Cartesian product is used to model composite systems and relations between elements of two or more sets.

The Cartesian product of two sets AAitalic_A and BBitalic_B, denoted by A×BA\times Bitalic_A × italic_B, is the set of all ordered pairs (a,b)(a,b)(  ,  ) where a∈Aa\in A ∈ italic_A and b∈Bb\in B ∈ italic_B: A×B\={(a,b)∣a∈A,b∈B}.A\times B=\{(a,b)\mid a\in A,b\in B\}.italic_A × italic_B = { (  ,  ) ∣  ∈ italic_A ,  ∈ italic_B } . Report issue for preceding element

For instance, let A\={1,2}A=\{1,2\}italic_A = { 1 , 2 } and B\={b1,b2}B=\{b\_{1},b\_{2}\}italic_B = {   }. Their product A×BA\times Bitalic_A × italic_B is:

A×B\={(1,b1),(1,b2),(2,b1),(2,b2)}.A\times B=\{(1,b\_{1}),(1,b\_{2}),(2,b\_{1}),(2,b\_{2})\}.italic_A × italic_B = { ( 1 ,   ) } .

We can also represent it as a table:††margin: As we will see in Section [4.3](https://arxiv.org/html/2508.02723v1#S4.SS3 "4.3 Manifolds and Differential Geometry ‣ 4 Topological Foundations and Differential Geometry ‣ Mathematical Foundations of Geometric Deep Learning"), one application of the Cartesian product is to represent complex manifolds as combinations of simpler ones. For instance, by taking the Cartesian product of multiple 1-spheres (circles), we can define points on a hypertorus. In Geometric Deep Learning, this approach can encode data into complex latent spaces while maintaining a closed-form differentiable representation of the underlying geometry. ![[Uncaptioned image]](figures/torus.jpg)

A×Bb1b21(1,b1)(1,b2)2(2,b1)(2,b2)\begin{array}\[\]{c|c|c}A\times B&b\_{1}&b\_{2}\\ \hline\cr 1&(1,b\_{1})&(1,b\_{2})\\ 2&(2,b\_{1})&(2,b\_{2})\\ \end{array}start_ARRAY start_ROW start_CELL italic_A × italic_B end_CELL start_CELL   ) end_CELL end_ROW end_ARRAY

#### Maps

In many curricula, students are directly introduced to functions. However, before discussing functions, we can explore the more general concept of rules that define mappings between elements of different sets.

A map is a rule FFitalic_F which assigns to each element of a set AAitalic_A another element of a set BBitalic_B: F​(a)≡b∈B​∀a∈A.F(a)\equiv b\in B\ \forall a\in A.italic_F (  ) ≡  ∈ italic_B ∀  ∈ italic_A . Report issue for preceding element

In the above expression, we read ≡\equiv≡ as ‘is defined as’ or ‘is equivalent to’, indicating that F​(a)F(a)italic_F (  ) is explicitly assigned the value bb in the set B.B.italic_B . The symbol ∀\forall∀ is read as ‘for all’, emphasizing that this rule applies to every element aa in the set A.A.italic_A .

It is common to use the following notation F:A→B.F:A\rightarrow B.italic_F : italic_A → italic_B . We call AAitalic_A the domain and BBitalic_B the codomain, the element a∈Aa\in A ∈ italic_A fed into the map is the argument (or preimage), and F​(a)F(a)italic_F (  ) its image. Note that we use different notations to distinguish a mapping between sets and its behavior on individual elements. For example:

F:ℕ→ℤ,x↦F​(x)\=x2,F:\mathbb{N}\rightarrow\mathbb{Z},\quad x\mapsto F(x)=x^{2},italic_F :  →  ,  ↦ italic_F (  ) =   ,

where the expression on the left-hand side focuses on specifying the domain and codomain of FFitalic_F, whereas the right-hand side highlights the action of FFitalic_F on individual elements of the domain, that is, on particular inputs.

A function is a special type of mapping, which maps a set into the set of numbers. Report issue for preceding element

#### Types of Maps

Maps can be surjective,††margin: The terms injection, surjection, and bijection were introduced by a group of French mathematicians publishing under the collective pseudonym Nicholas Bourbaki in 1954, and the adjective forms first used by Claude Chevalley in 1956. ![[Uncaptioned image]](figures/Boubaki-2000_v2.jpg) injective, or bijective, depending on how they map elements from one set to another. We say that a map between two sets is bijective when it is both injective and surjective.

(a) Injective

(b) Surjective

(c) Bijective

Figure 2: Depiction of injective, surjective, and bijective maps between two sets whose elements are highlighted in blue and red respectively.

Injective (One-to-One):††margin: There are other alternative ways of expressing the injectivity property: If (a1,b)​\inF(a\_{1},b)\inF(   ,  ) and (a2,b)​\inF(a\_{2},b)\inF(   ,  ), then a1\=a2a\_{1}=a\_{2} , or bb has no more than one pre-image. A map F:A→BF:A\to Bitalic_F : italic_A → italic_B is called injective (or one-to-one) if different elements in the domain AAitalic_A map to different elements in the codomain BBitalic_B. That is, for all a1,a2∈Aa\_{1},a\_{2}\in A  ∈ italic_A, F​(a1)\=F​(a2)⟹a1\=a2.F(a\_{1})=F(a\_{2})\implies a\_{1}=a\_{2}.italic_F (   . Report issue for preceding element

Surjective (Onto):††margin: F:A​\toBF:A\toBitalic_F : italic_A is surjective if and only if ran​F\=B\textrm{ran}F=Bran italic_F = italic_B, where ran​F\={b:\existsa∋(a,b)​\inF}.\textrm{ran}F=\{b:\existsa\ni(a,b)\inF\}.ran italic_F = {  : ∋ (  ,  ) } . A map F:A→BF:A\to Bitalic_F : italic_A → italic_B is called surjective (or onto) if every element in the codomain BBitalic_B has at least one preimage in the domain AAitalic_A. That is, for every b∈Bb\in B ∈ italic_B, there exists an a∈Aa\in A ∈ italic_A such that F​(a)\=b.F(a)=b.italic_F (  ) =  . Report issue for preceding element

Bijective: A map F:A→BF:A\to Bitalic_F : italic_A → italic_B is bijective if it is both injective and surjective. In other words, each element of AAitalic_A maps to a unique element of BBitalic_B, and every element of BBitalic_B has a unique preimage in AAitalic_A. A bijective map has an inverse, denoted F−1:B→AF^{-1}:B\to Aitalic_F  : italic_B → italic_A, such that F−1​(F​(a))\=a​∀a∈A,F​(F−1​(b))\=b​∀b∈B.F^{-1}(F(a))=a\quad\forall\quad a\in A,\quad F(F^{-1}(b))=b\quad\forall\quad b\in B.italic_F  (  ) ) =  ∀  ∈ italic_B . Report issue for preceding element

#### Composition

Maps between different sets can be combined.

Given two maps, F1:A→BF\_{1}:A\to Bitalic_F  : italic_A → italic_B, and F2:B→CF\_{2}:B\to Citalic_F  : italic_B → italic_C, the composition of F1F\_{1}italic_F  and F2F\_{2}italic_F , denoted as F2∘F1F\_{2}\circ F\_{1}italic_F , is a new map: F2∘F1:A→C.F\_{2}\circ F\_{1}:A\to C.italic_F  : italic_A → italic_C . Report issue for preceding element

Note that when we compose injective maps, the result is also injective. Similarly, when we compose surjective maps or two bijective maps, the resulting maps are also surjective and bijective, respectively.

Like maps††margin: Note that composition of functions is associative but not commutative. , functions can also be composed to create new functions. If f:X→Yf:X\to Y : italic_X → italic_Y and g:Y→Zg:Y\to Z : italic_Y → italic_Z, their composition, denoted as g∘fg\circ f ∘ , is a function g∘f:X→Zg\circ f:X\to Z ∘  : italic_X → italic_Z defined by:

(g∘f)​(x)\=g​(f​(x)).(g\circ f)(x)=g(f(x)).(  ∘  ) (  ) =  (  (  ) ) .

For example, let f​(x)\=x2f(x)=x^{2} (  ) =   and g​(x)\=sin⁡(x)g(x)=\sin(x) (  ) =  (  ). Then the composition g∘fg\circ f ∘  is:

(g∘f)​(x)\=g​(f​(x))\=sin⁡(f​(x))\=sin⁡(x2).(g\circ f)(x)=g(f(x))=\sin(f(x))=\sin(x^{2}).(  ∘  ) (  ) =  (  (  ) ) =  (  (  ) ) =  (   ) .

Similarly, the reverse composition f∘gf\circ g ∘  is:

(f∘g)​(x)\=f​(g​(x))\=f​(sin⁡(x))\=(sin⁡(x))2.(f\circ g)(x)=f(g(x))=f(\sin(x))=(\sin(x))^{2}.(  ∘  ) (  ) =  (  (  ) ) =  (  (  ) ) = (  (  ) )  .

Function Composition and Deep Learning. Arguably, the foundation of Deep Learning lies in function composition, where the input undergoes iterative transformations through successive layers. Each layer processes the output (or activations) of the previous one, passing it as input to the next layer in the neural network. Also note that artificial neural networks are generally not bijective, as they are neither guaranteed to be injective nor surjective. Report issue for preceding element

For instance,††margin: It is possible to visualize the internal filters learned by deep CNNs. The filters in the initial layers typically capture primitive patterns such as edges, corners, and textures, while the filters in deeper layers learn to compose these primitives into more complex features. ![[Uncaptioned image]](figures/kernel_visualization.png) Figure [3](https://arxiv.org/html/2508.02723v1#S1.F3 "Figure 3 ‣ Composition ‣ 1.1 Sets, Maps, and Functions ‣ 1 Algebraic Structures and Mathematics before Numbers ‣ Mathematical Foundations of Geometric Deep Learning") displays a schematic of a LeNet-5 neural network. We can observe how the input image is processed from left to right. The feature maps (yet another term for layer outputs or activations) are processed by different layers in the architecture and passed as input to the next layer to produce the subsequent set of feature maps. This is an example of function composition.

![Refer to caption](figures/lenet-5.jpg)
Figure 3: LeNet-5 classical CNN architecture.

#### Hypothesis Class

In machine learning it is common to come across the concept of hypothesis class.††margin: In Machine Learning we want to exploit the underlying low-dimensional structure of the input high dimensional space \mathcalX\mathcalX. We can expect three sources of error in high-dimensional learning: approximation error, statistical error, and optimization error.

If 𝒳\mathcal{X}caligraphic_X is the input space and 𝒴\mathcal{Y}caligraphic_Y the label (or output) space, then a hypothesis class is any set ℱ⊆{f:𝒳→𝒴}\mathcal{F}\;\subseteq\;\{\,f:\mathcal{X}\to\mathcal{Y}\}caligraphic_F ⊆ {  : caligraphic_X → caligraphic_Y } of functions (hypotheses) from 𝒳\mathcal{X}caligraphic_X to 𝒴\mathcal{Y}caligraphic_Y from which a learning algorithm chooses its prediction rule. Report issue for preceding element

For instance, in linear regression the hypothesis class is the set of all possible lines. For the multivariate linear regression case, we have:

ℱlin\={fw,b:ℝd→ℝ|hw,b​(x)\=w⊤​x+b,w∈ℝd,b∈ℝ},\mathcal{F}\_{\text{lin}}=\bigl{\{}\,f\_{w,b}:\mathbb{R}^{d}\to\mathbb{R}\;\big{|}\;h\_{w,b}(x)=w^{\top}x+b,\;w\in\mathbb{R}^{d},\;b\in\mathbb{R}\bigr{\}},caligraphic_F  :   ,  ∈  } ,

i.e. the set of all affine (straight‐line) functions parameterized by (w,b)(w,b)(  ,  ).

††margin: An MLP is one of the first neural network architectures. It consists of stacking multiple ‘perceptrons’, which take a multidimensional input, assign a weight to each of its entries, add the results, and apply a non-linear transformation.

In Deep Learning, the hypothesis class is given by the neural network architecture construction we choose to implement. The model then learns to optimize the parameters via gradient descent (Section [3.7](https://arxiv.org/html/2508.02723v1#S3.SS7 "3.7 Gradient Descent Optimization in Deep Learning ‣ 3 Vector calculus ‣ Mathematical Foundations of Geometric Deep Learning")) and converges on a particular function given the data used to train it. For example, in the case of a MultiLayer Perceptron (MLP), the hypothesis class would be

ℱNN\displaystyle\mathcal{F}\_{\rm NN}caligraphic_F 

\={fθ:𝒳→𝒴∣θ∈Θ},\displaystyle=\;\bigl{\{}\,f\_{\theta}:\mathcal{X}\to\mathcal{Y}\mid\theta\in\Theta\,\},\= {   : caligraphic_X → caligraphic_Y ∣ italic_θ ∈ roman_Θ } ,

fθ​(x)\displaystyle f\_{\theta}(x)  (  )

\=σL​(W(L)​(⋯​σ2​(W(2)​(σ1​(W(1)​x+b(1)))+b(2))​⋯)+b(L)).\displaystyle=\;\sigma\_{L}\Bigl{(}W^{(L)}\bigl{(}\cdots\sigma\_{2}\bigl{(}W^{(2)}(\sigma\_{1}(W^{(1)}x+b^{(1)}))+b^{(2)}\bigr{)}\cdots\bigr{)}+b^{(L)}\Bigr{)}.\= italic_σ  ( italic_W  ) .

where LLitalic_L is the total number of layers, θ\={W(1),b(1),W(2),b(2),…,W(L),b(L)}\theta=\bigl{\{}W^{(1)},b^{(1)},\,W^{(2)},b^{(2)},\dots,W^{(L)},b^{(L)}\bigr{\}}italic_θ = { italic_W  } is the set of learnable parameters,††margin: In the past sigmoid functions were a standard activation function for hidden neural network layers. However, due to the so-called ‘vanishing gradient problem’, sigmoids are currently mainly used as a final non-linear transformation for binary classification problems. Rectified Linear Units (ReLUs) and its variants such as Exponential Linear Units (ELUs) and Leaky ReLUs are a more standard choice in the literature nowadays. For large scale Transformers the Sigmoid Linear Unit (SiLU) (also known as the swish function) is widely used instead. Many other activations functions have been proposed in the literature. Θ\Thetaroman_Θ is typically ℝ∑i(dimW(i)+dimb(i))\mathbb{R}^{\,\sum\_{i}(\dim W^{(i)}+\dim b^{(i)})} , and σ1,…​σL\sigma\_{1},...\sigma\_{L}italic_σ  are non-linear activation functions. In other words, the MLP architecture is a composition of affine transformations and non-linear functions.

Restricting the Hypothesis Class using Symmetries. The larger the hypothesis class, the better the best hypothesis models the underlying true function, but the harder it is to find that best hypothesis. In Geometric Deep Learning we often choose to restrict our neural network hypothesis class by embedding symmetry (invariance and equivariant) into our layer transformations. This can lead to more efficient learning in data scarce regimes. This is related to the bias-variance tradeoff often mentioned in the literature. Report issue for preceding element

### 1.2 Groups

A group is a way of organizing and understanding how a set of elements interact with one another through a well-defined operation. Groups are used to describe symmetry, structure, and transformations in various mathematical and physical contexts.

Let us consider a physical example before diving into the formal definition. Think of a square and the group of rotations of the square. The set of elements in this group consists of the different rotations C4\={0∘,90∘,180∘,270∘}C\_{4}=\{0^{\circ},90^{\circ},180^{\circ},270^{\circ}\}italic_C  = { 0  } that can be applied to the square. The operation here is combining rotations. For instance, applying two 90∘90^{\circ}90  rotations is equivalent to a single 180∘180^{\circ}180  rotation. Applying a 0∘0^{\circ}0  rotation followed by a 90∘90^{\circ}90  rotation results in just a 90∘90^{\circ}90  rotation. This shows that combining elements of the set results in elements within the same set.††margin: Many classes of physical operations can be associated with a group structure. Since Geometric Deep Learning architectures often aim to model such phenomena, groups become essential for designing artificial neural networks whose internal representations align with physical principles.

0∘0^{\circ}0 90∘90^{\circ}90 180∘180^{\circ}180 270∘270^{\circ}270 +90∘+90^{\circ}\+ 90 +90∘+90^{\circ}\+ 90 +90∘+90^{\circ}\+ 90 +90∘+90^{\circ}\+ 90 Report issue for preceding element

Figure 4: Rotational Symmetries of a Square (C4C\_{4}italic_C ).

This situation exemplifies††margin: The term symmetry has Greek origins ‘symmetria’ literally translates to ‘same measure’. symmetry: the square remains unchanged (invariant) under these rotations. In mathematics, symmetry refers to a property of an object or system that remains unchanged under specific transformations or operations.

Similar schematics can be created, for instance, to represent the symmetry of a triangle under both rotations and reflections. More generally, we refer to these as Cayley graphs.

![Refer to caption](figures/cayley_graph.png)
Figure 5: Cayley graph representing the symmetry of a triangle, where RRitalic_R stands for rotation and FFitalic_F for reflection.

A group is a set equipped with a binary operation that combines any two elements of the set to form a third element. In a group, the set and the operation can be denoted as (G,∘)(G,\circ)( italic_G , ∘ ), where GGitalic_G is the set and ∘\circ∘ is the binary operation. The operation must satisfy the following fundamental properties, known as the group axioms: ††margin: a​\circba\circb can be denoted by juxtaposition for brevity: a​\circb\=a​b.a\circb=ab. =   . Also, alternatively, one can use the symbol ∗\ast∗. • Associativity: For all a,b,c∈Ga,b,c\in G ,  ,  ∈ italic_G, we have (a∘b)∘c\=a∘(b∘c)(a\circ b)\circ c=a\circ(b\circ c)(  ∘  ) ∘  =  ∘ (  ∘  ). • Identity Element: There exists an element e∈Ge\in G ∈ italic_G such that for all a∈Ga\in G ∈ italic_G, e∘a\=a∘e\=ae\circ a=a\circ e=a ∘  =  ∘  = . This element is called the identity element. • Inverse Element: For each element a∈Ga\in G ∈ italic_G, there exists an element b∈Gb\in G ∈ italic_G such that a∘b\=b∘a\=ea\circ b=b\circ a=e ∘  =  ∘  = , where ee is the identity element. The element bb is called the inverse of aa and is denoted a−1a^{-1} . Report issue for preceding element

††margin: Group theory originated with Galois, who introduced the concept of permutation groups to show that general fifth-degree (quintic) polynomials cannot be solved by radicals. This settled a centuries-old problem that had perplexed mathematicians such as Lagrange and Ruffini. Interestingly, attempts to solve lower-degree equations (like quadratics) date back to ancient Babylonian mathematics.

Closure follows from the definition: for all a,b∈Ga,b\in G ,  ∈ italic_G, the result of the operation c\=a∘bc=a\circ b =  ∘  is also in GGitalic_G, c∈Gc\in G ∈ italic_G, and commutativity does not necessarily apply in general. Groups can be finite, infinite, discrete, or continuous.

#### Examples of Groups

- •

  Integers under Addition: The set of integers ℤ\mathbb{Z} with the operation of addition (+)(+)( + ) forms a group. The identity element is 0, and each integer aa has an additive inverse −a\-a\- .

  Report issue for preceding element

- •

  Non-zero Rational Numbers under Multiplication: The set of non-zero rational numbers ℚ∗\=ℚ∖{0}\mathbb{Q}^{\*}=\mathbb{Q}\setminus\{0\}  =  ∖ { 0 } with multiplication (⋅)(\cdot)( ⋅ ) forms a group. The identity element is 111, and each element aa has a multiplicative inverse 1a\frac{1}{a}divide .

  Report issue for preceding element

- •

  Symmetric Group: The symmetric group SNS\_{N}italic_S  consists of all permutations of NNitalic_N elements. The group operation is the composition of permutations, and it is an example of a finite group.

  Report issue for preceding element

#### More on Groups

- •

  Abelian Group: A group (G,∘)(G,\circ)( italic_G , ∘ ) is called abelian (or commutative) if the operation is commutative, meaning a∘b\=b∘aa\circ b=b\circ a ∘  =  ∘  for all a,b∈Ga,b\in G ,  ∈ italic_G.††margin: A non-abelian group contains at least some elements for which a​\circb​\neqb​\circaa\circb\neqb\circa.

  Report issue for preceding element

- •

  Subgroup: A subgroup HHitalic_H of a group GGitalic_G is a subset of GGitalic_G that is itself a group under the operation of GGitalic_G. If HHitalic_H is a subgroup of GGitalic_G, we write H≤GH\leq Gitalic_H ≤ italic_G.

  Report issue for preceding element

- •

  Order of a Group: The order of a group is the number of elements in the group, |G||G|| italic_G |.

  Report issue for preceding element

For instance, in our previous example, the group of rotations of a square, C4C\_{4}italic_C , is abelian and has an order of 4. ††margin: Another important abelian group is that formed by all rotations of three-dimensional space. The group of rotations C2\={0∘,180∘}C\_{2}=\{0^{\circ},180^{\circ}\}italic_C  = { 0  } is a subgroup C2≤C4.C\_{2}\leq C\_{4}.italic_C  .

Groups and Understanding Data Distributions through the Lens of Geometric Deep Learning. In Geometric Deep Learning, groups formalize the concept of symmetry in data. For instance, in computer vision, the group of translations ensures that object categories remain invariant when their positions shift, a property essential for tasks like visual object classification. In computational chemistry, predicting molecular properties requires outputs invariant to both rotations and translations, achieved through the Euclidean group E​(3)E(3)italic_E ( 3 ). ††margin: Graph Neural Networks (GNNs) are a type of artificial neural networks designed to process signals over graph structures. Similarly, for systems with discrete symmetries, such as permutations in graphs, the symmetric group SnS\_{n}italic_S  plays a central role. This group underpins transformations where elements (e.g., particles or nodes) can be arbitrarily reordered, a key aspect in GNNs and the message-passing framework (Section [7.3](https://arxiv.org/html/2508.02723v1#S7.SS3 "7.3 Vector Fields on Graphs ‣ 7 Graph Theory ‣ Mathematical Foundations of Geometric Deep Learning")). Report issue for preceding element

#### Group Homomorphisms

It is often that we may find groups which are equivalent, or that can be realized in different ways. The essence of a group homomorphism lies in preserving structure, rather than focusing solely on particular examples.

A group homomorphism is a map between two groups that preserves the group structure. Let (G,∘)(G,\circ)( italic_G , ∘ ) and (H,∗)(H,\ast)( italic_H , ∗ ) be two groups. A map ϕ:G→H\phi:G\to Hitalic_ϕ : italic_G → italic_H is called a group homomorphism if, ∀a,b∈G\forall a,b\in G∀  ,  ∈ italic_G, the following condition holds: ϕ​(a∘b)\=ϕ​(a)∗ϕ​(b).\phi(a\circ b)=\phi(a)\ast\phi(b).italic_ϕ (  ∘  ) = italic_ϕ (  ) ∗ italic_ϕ (  ) . Report issue for preceding element

A group isomorphism is a bijective homomorphism between two groups GGitalic_G and HHitalic_H, establishing a perfect identification between them.

Two groups (G,∘)(G,\circ)( italic_G , ∘ ) and (H,∗)(H,\ast)( italic_H , ∗ ) are said to be isomorphic, (G,∘)≅(H,∗),(G,\circ)\cong(H,\ast),( italic_G , ∘ ) ≅ ( italic_H , ∗ ) , if there exists a bijective map (a one-to-one and onto mapping) ϕ:G→H\phi:G\to Hitalic_ϕ : italic_G → italic_H such that ϕ\phiitalic_ϕ is a group homomorphism. Report issue for preceding element

The group††margin: The modulo operation (denoted as a​\modna\modn) finds the remainder when aa is divided by nn. Specifically, a​\modna\modn is the integer remainder rr such that 0​\leqr<n0\leqr<n0 <  and a\=n​\cdotq+ra=n\cdotq+r =  +  for some integer qq. C4\={0∘,90∘,180∘,270∘}C\_{4}=\{0^{\circ},90^{\circ},180^{\circ},270^{\circ}\}italic_C  = { 0  } is the group of rotations of a square, where the group operation is addition modulo 360∘360^{\circ}360 . Let the group ℤ4\={0,1,2,3}\mathbb{Z}\_{4}=\{0,1,2,3\}  = { 0 , 1 , 2 , 3 } be the group of integers under addition modulo 4. These groups are isomorphic, and the isomorphism can be described by a homomorphism.

Define the homomorphism ϕ:C4→ℤ4\phi:C\_{4}\to\mathbb{Z}\_{4}italic_ϕ : italic_C  as

ϕ​(0∘)\=0,ϕ​(90∘)\=1,ϕ​(180∘)\=2,ϕ​(270∘)\=3.\phi(0^{\circ})=0,\quad\phi(90^{\circ})=1,\quad\phi(180^{\circ})=2,\quad\phi(270^{\circ})=3.italic_ϕ ( 0  ) = 3 .

This mapping respects the group operation. Let us verify the homomorphism property. The group operation in C4C\_{4}italic_C  is addition modulo 360∘360^{\circ}360 , and the group operation in ℤ4\mathbb{Z}\_{4}  is addition modulo 4. To verify ϕ\phiitalic_ϕ is a homomorphism, check that:

ϕ​(a+bmod360∘)\=ϕ​(a)+ϕ​(b)mod4,∀a,b∈C4.\phi(a+b\mod 360^{\circ})=\phi(a)+\phi(b)\mod 4,\quad\forall a,b\in C\_{4}.italic_ϕ (  +   360  ) = italic_ϕ (  ) + italic_ϕ (  )  4 , ∀  ,  ∈ italic_C  .

Some examples include

ϕ​(90∘+180∘mod360∘)\=ϕ​(270∘)\=3,\phi(90^{\circ}+180^{\circ}\mod 360^{\circ})=\phi(270^{\circ})=3,italic_ϕ ( 90  ) = 3 ,

ϕ​(90∘)+ϕ​(180∘)mod4\=1+2mod4\=3.\phi(90^{\circ})+\phi(180^{\circ})\mod 4=1+2\mod 4=3.italic_ϕ ( 90  )  4 = 1 + 2  4 = 3 .

Next, let us illustrate a non-isomorphic mapping between C4C\_{4}italic_C  and C2\={0∘,180∘}C\_{2}=\{0^{\circ},180^{\circ}\}italic_C  = { 0  }. While both C4C\_{4}italic_C  and C2C\_{2}italic_C  are cyclic groups, their structures are fundamentally different, and no isomorphism exists between them. However, there are still homomorphisms that preserve the group structure.

Let C2\={0∘,180∘}C\_{2}=\{0^{\circ},180^{\circ}\}italic_C  = { 0  } where the group operation is addition modulo 360∘360^{\circ}360 . Define a homomorphism ψ:C4→C2\psi:C\_{4}\to C\_{2}italic_ψ : italic_C  as:

ψ​(0∘)\=0∘,ψ​(90∘)\=180∘,ψ​(180∘)\=0∘,ψ​(270∘)\=180∘.\psi(0^{\circ})=0^{\circ},\quad\psi(90^{\circ})=180^{\circ},\quad\psi(180^{\circ})=0^{\circ},\quad\psi(270^{\circ})=180^{\circ}.italic_ψ ( 0  .

This map is not injective (and therefore not bijective), which means that C4C\_{4}italic_C  and C2C\_{2}italic_C  are not isomorphic. Let us verify the homomorphism property. The group operation in both C4C\_{4}italic_C  and C2C\_{2}italic_C  is addition modulo 360∘360^{\circ}360 . To check that ψ\psiitalic_ψ is a homomorphism, we must verify:

ψ​(a+bmod360∘)\=ψ​(a)+ψ​(b)mod360∘,∀a,b∈C4.\psi(a+b\mod 360^{\circ})=\psi(a)+\psi(b)\mod 360^{\circ},\quad\forall a,b\in C\_{4}.italic_ψ (  +   360  , ∀  ,  ∈ italic_C  .

Some examples include: let a\=90∘a=90^{\circ} = 90  and b\=180∘b=180^{\circ} = 180 

ψ​(90∘+180∘mod360∘)\=ψ​(270∘)\=180∘,\psi(90^{\circ}+180^{\circ}\mod 360^{\circ})=\psi(270^{\circ})=180^{\circ},italic_ψ ( 90  ,

ψ​(90∘)+ψ​(180∘)mod360∘\=180∘+0∘mod360∘\=180∘.\psi(90^{\circ})+\psi(180^{\circ})\mod 360^{\circ}=180^{\circ}+0^{\circ}\mod 360^{\circ}=180^{\circ}.italic_ψ ( 90  .

#### Group Actions

A group action is a formal way of describing how a group interacts with a set while preserving its structure. It connects abstract group theory to concrete situations where groups act on mathematical or physical objects, such as transforming geometric shapes, permuting elements, or applying symmetry operations.

Let us revisit C4\={0∘,90∘,180∘,270∘}C\_{4}=\{0^{\circ},90^{\circ},180^{\circ},270^{\circ}\}italic_C  = { 0  } once more. These rotations act on the set of vertices of the square,

V\={A^,B^,C^,D^},V=\{\hat{A},\hat{B},\hat{C},\hat{D}\},italic_V = { over^  } ,

by permuting their positions. For example:

- •

  A 90∘90^{\circ}90  rotation maps A^→B^\hat{A}\to\hat{B}over^ , B^→C^\hat{B}\to\hat{C}over^ , C^→D^\hat{C}\to\hat{D}over^ , D^→A^\hat{D}\to\hat{A}over^ .

  Report issue for preceding element

- •

  A 180∘180^{\circ}180  rotation maps A^→C^\hat{A}\to\hat{C}over^ , B^→D^\hat{B}\to\hat{D}over^ , C^→A^\hat{C}\to\hat{A}over^ , D^→B^\hat{D}\to\hat{B}over^ .

  Report issue for preceding element

This interaction satisfies the structure-preserving properties of a group action.

A (left) group action of a group GGitalic_G on a set XXitalic_X is a mapping:††margin: The group operation vanishes on the right-hand side of the compatibility axiom because it is implicitly handled by the action itself. The key idea is that group actions are associative with respect to the group operation. This means that applying the action of a​\circba\circb to xx is the same as first applying bb to xx and then applying aa to the result. α:G×X→X,(g,x)↦α​(g,x)\=g⋅x,\alpha:G\times X\to X,\quad(g,x)\mapsto\alpha(g,x)=g\cdot x,italic_α : italic_G × italic_X → italic_X , (  ,  ) ↦ italic_α (  ,  ) =  ⋅  , satisfying the following axioms: • Identity: The identity element e∈Ge\in G ∈ italic_G acts as the identity transformation on XXitalic_X: α​(e,x)\=e⋅x\=x,∀x∈X.\alpha(e,x)=e\cdot x=x,\quad\forall x\in X.italic_α (  ,  ) =  ⋅  =  , ∀  ∈ italic_X . • Compatibility: ∀g,a∈G\forall g,a\in G∀  ,  ∈ italic_G and x∈Xx\in X ∈ italic_X, the action satisfies: (g∘a)⋅x\=g⋅(a⋅x),(g\circ a)\cdot x=g\cdot(a\cdot x),(  ∘  ) ⋅  =  ⋅ (  ⋅  ) , where ∘\circ∘ is the group operation in GGitalic_G. Report issue for preceding element

Groups Actions on Data.††margin: In Geometric Deep Learning, we assume there is a domain underlying our data, which we denote by Ω\Omegaroman_Ω, and study how groups act on Ω\Omegaroman_Ω and how we obtain actions on the same group on the space of signals 𝒳​(Ω)\mathcal{X}(\Omega)caligraphic_X ( roman_Ω ). In Geometric Deep Learning, rather than considering groups as abstract entities, we focus on how different mathematical operations, which we can prescribe for our artificial neural network, transform the input data. This enables us to design our model to perform transformations on the data that respect the structure of its domain. Report issue for preceding element

![Refer to caption](figures/monalisa_rotation.png)
Figure 6: Group action on an image (function). The type of an object can be defined by the way it is transformed by a group.

#### Group Orbits, Invariance, and Equivariance

We expand on our previous discussion by introducing a few formalisms.

The orbit of an element x∈Xx\in X ∈ italic_X under the action of GGitalic_G is defined as: Orb​(x)\={g⋅x∣g∈G}.\textrm{Orb}(x)=\{g\cdot x\mid g\in G\}.Orb (  ) = {  ⋅  ∣  ∈ italic_G } . Report issue for preceding element

That is, the orbit of xx under a group GGitalic_G is the set of all points one can reach from xx by applying every possible action in GGitalic_G.

Before proceeding further, it is useful to formalize the notions of invariant and equivariant functions. Let XXitalic_X and YYitalic_Y be sets on which a group GGitalic_G acts.

A function f:X→Yf:X\to Y : italic_X → italic_Y is called _GGitalic_G\-invariant_ if f​(g⋅x)\=f​(x)​∀g∈G,x∈X.f(g\cdot x)=f(x)\quad\forall\,g\in G,\,x\in X. (  ⋅  ) =  (  ) ∀  ∈ italic_G ,  ∈ italic_X . Report issue for preceding element

In contrast,

Let (X,⋅X)(X,\cdot\_{X})( italic_X , ⋅  ) and (Y,⋅Y)(Y,\cdot\_{Y})( italic_Y , ⋅  ) be GGitalic_G\-spaces, meaning that the group GGitalic_G acts on XXitalic_X via ⋅X\cdot\_{X}⋅  and on YYitalic_Y via ⋅Y\cdot\_{Y}⋅ . A function f:X→Yf:X\to Y : italic_X → italic_Y is said to be _GGitalic_G\-equivariant_ if f​(g⋅Xx)\=g⋅Yf​(x)​∀g∈G,x∈X.f(g\cdot\_{X}x)=g\cdot\_{Y}f(x)\quad\forall\,g\in G,\,x\in X. (  ⋅   (  ) ∀  ∈ italic_G ,  ∈ italic_X . Report issue for preceding element

Thus, while an invariant function collapses the entire orbit to a single value, an equivariant function transforms in a predictable way under the group action.

Perhaps somewhat abstractly, one common method to achieve invariance in a neural network is to aggregate over these orbits. For example, a group convolution operator is defined as

(f⋆ψ)​(x)\=∑g∈Gf​(g⋅x)​ψ​(g−1),(f\star\psi)(x)=\sum\_{g\in G}f(g\cdot x)\,\psi(g^{-1}),(  ⋆ italic_ψ ) (  ) = ∑   (  ⋅  ) italic_ψ (   ) ,

or in the continuous setting,

(f⋆ψ)​(x)\=∫Gf​(g⋅x)​ψ​(g−1)​𝑑g,(f\star\psi)(x)=\int\_{G}f(g\cdot x)\,\psi(g^{-1})\,dg,(  ⋆ italic_ψ ) (  ) = ∫   (  ⋅  ) italic_ψ (   )   ,

where ψ:G→ℝ\psi:G\to\mathbb{R}italic_ψ : italic_G →  is a kernel function and d​gdg  denotes the Haar measure on GGitalic_G.††margin: A kernel function ψ\psiitalic_ψ assigns weights to the contributions of different group elements, much like a filter in a convolution, while the Haar measure d​gdg  is a translation-invariant measure on GGitalic_G that ensures integration over the group is independent of the specific parametrization. This operator is GGitalic_G\-equivariant, meaning that applying a transformation to the input before the convolution yields the same result as applying it after convolution.

Let us give an intuitive explanation to unravel what our previous mathematical abstraction really means. Consider GGitalic_G as the group of rotations by 90∘90^{\circ}90 , again this is C4C\_{4}italic_C , acting on the set XXitalic_X of images. For a given image x∈Xx\in X ∈ italic_X (for example, the Mona Lisa), its orbit Orb​(x)\textrm{Orb}(x)Orb (  ) will contain all four rotated copies: x,R90​(x),R180​(x),R270​(x)∈Orb​(x)x,R\_{90}(x),R\_{180}(x),R\_{270}(x)\in\textrm{Orb}(x) , italic_R  (  ) ∈ Orb (  ). An invariant function ff (such as one used for face recognition) would output the same value for each image in the orbit

f​(x)\=f​(R90​(x))\=f​(R180​(x))\=f​(R270​(x)),f(x)=f(R\_{90}(x))=f(R\_{180}(x))=f(R\_{270}(x)), (  ) =  ( italic_R  (  ) ) ,

recognizing that they all represent the same underlying face despite different orientations.

Invariance and Equivariance in Geometric Deep Learning.††margin: The importance of invariance and equivariance came to the forefront much earlier in Physics: “Every \[differentiable\] symmetry of the action of a physical system \[with conservative forces\] has a corresponding conservation law” – Emmy Noether, 1918 “It is only slightly overstating the case to say that Physics is the study of symmetry” – Philip Anderson, 1972 By interleaving transformations that respect the symmetry of the input, Geometric Deep Learning architectures can be made both expressive and robust. This strategy enables the design of models that generalize better and are more interpretable in settings where the data exhibit natural symmetries. More concretely, stacking several equivariant layers enables the network to capture increasingly complex hierarchical patterns while respecting the underlying symmetry. The final invariant operation then distills these symmetry-preserving features into a robust representation suitable for tasks such as classification, segmentation, or regression, where the output should not depend on the particular transformation applied to the input. Note that stacking only invariant transformations would result in a strictly smaller hypothesis class. Report issue for preceding element

#### Fields

Before moving on to discussing vector spaces, let us briefly mention fields. Fields, groups, and vector spaces are interconnected in the hierarchy of algebraic structures. A group has a single binary operation with minimal axioms, while a field has two operations with stringent compatibility conditions. Hence, fields impose more structure than groups and belong to a different class of algebraic objects.

A field is a set 𝔽\mathbb{F} equipped with two binary operations, addition (+++) and multiplication (⋅\cdot⋅), satisfying the following properties: • (𝔽,+)(\mathbb{F},+)(  , + ) forms an abelian group (with identity element 0). • (𝔽∖{0},⋅)(\mathbb{F}\setminus\{0\},\cdot)(  ∖ { 0 } , ⋅ ) forms an abelian group (with identity element 111). • Multiplication is distributive over addition: ∀a,b,c∈𝔽\forall a,b,c\in\mathbb{F}∀  ,  ,  ∈ , a⋅(b+c)\=(a⋅b)+(a⋅c)a\cdot(b+c)=(a\cdot b)+(a\cdot c) ⋅ (  +  ) = (  ⋅  ) + (  ⋅  ). Report issue for preceding element

### 1.3 Vector Spaces

Now that we have a basic understanding of groups and fields, we can introduce the concept of a vector space. Vectors are ubiquitous in applications of mathematics, especially in physical sciences. Introductory courses often talk about vectors in geometric terms (‘arrows that have direction and length’) or computer science terms (‘arrays of numbers’). Each of these definitions are a crime against humanity: in order to think of vectors as ‘arrows’, one has to define direction and length by introducing additional structures called inner products and norms; in order to think of vectors as ‘arrays’, one has to define a basis, with respect to which vectors can be represented as ordered sets of coordinates. The correct mathematical way of thinking of vectors is as abstract objects that can be scaled and added.

††margin: A scalar is a single numerical value, such as a real number, with no direction or dimension. A vector is an ordered array of numbers, representing a point or direction in space, and can be one-dimensional or multi-dimensional. A tensor is a generalization of scalars and vectors to higher dimensions, represented as multi-dimensional arrays. For instance, scalars are 0th-order tensors, vectors are 1st-order tensors, and matrices are 2nd-order tensors. Higher-order tensors extend this concept, representing data with more than two dimensions, such as a sequence of matrices. In Deep Learning we tend to work with high-dimensional tensors. VVitalic_V is a vector space over a field 𝔽\mathbb{F} (typically 𝔽\=ℝ\mathbb{F}=\mathbb{R} =  or ℂ\mathbb{C}) with binary operations +:V×V→V+:V\times V\rightarrow V\+ : italic_V × italic_V → italic_V (vector addition) and ⋅:V×𝔽→V\cdot:V\times\mathbb{F}\rightarrow V⋅ : italic_V ×  → italic_V (scalar multiplication) if for any u,v,w∈Vu,v,w\in V ,  ,  ∈ italic_V and α,β∈𝔽\alpha,\beta\in\mathbb{F}italic_α , italic_β ∈  we have the following properties: • Associativity of +++: u+(v+w)\=(u+v)+wu+(v+w)=(u+v)+w + (  +  ) = (  +  ) +  • Commutativity of +++ : u+v\=v+uu+v=v+u +  =  +  • Identity element of +++: There exists a unique 0∈V0\in V0 ∈ italic_V such that u+0\=uu+0=u + 0 =  • Inverse element of +++: There exists a unique −v∈V\-v\in V\-  ∈ italic_V such that v+(−v)\=0v+(-v)=0 + ( -  ) = 0 • Distributivity of ⋅\cdot⋅ w.r.t. vector addition : α⋅(u+v)\=α⋅u+α⋅v\alpha\cdot(u+v)=\alpha\cdot u+\alpha\cdot vitalic_α ⋅ (  +  ) = italic_α ⋅  + italic_α ⋅  • Distributivity of ⋅\cdot⋅ w.r.t. scalar addition: (α+β)⋅v\=α⋅v+β⋅v(\alpha+\beta)\cdot v=\alpha\cdot v+\beta\cdot v( italic_α + italic_β ) ⋅  = italic_α ⋅  + italic_β ⋅  • Compatibility of ⋅\cdot⋅ with scalar multiplication: α⋅(β⋅v)\=(α⋅β)⋅v\alpha\cdot(\beta\cdot v)=(\alpha\cdot\beta)\cdot vitalic_α ⋅ ( italic_β ⋅  ) = ( italic_α ⋅ italic_β ) ⋅  • Identity element of ⋅\cdot⋅: ∃!⁡1∈ℝ​s.t.​1⋅u\=u\exists!1\in\mathbb{R}\quad\text{s.t.}\quad 1\cdot u=u∃ ! 1 ∈  s.t. 1 ⋅  =  Report issue for preceding element

Note that notation sometimes can be confusing and therefore should be used with care. The same notation is used for scalar addition α+β\alpha+\betaitalic_α + italic_β and vector addition u+vu+v + . It should be understood from context which addition is meant. The same notation is also used for scalar-by-scalar multiplication α⋅β\alpha\cdot\betaitalic_α ⋅ italic_β and vector-by-scalar multiplication α⋅u\alpha\cdot uitalic_α ⋅ . When no confusion arises, the vector-by-scalar multiplication is often denoted as α​u\alpha uitalic_α  for brevity. The zero vector 0∈V0\in V0 ∈ italic_V (identity element of vector addition) should not be confused with the zero scalar 0∈ℝ0\in\mathbb{R}0 ∈  (identity element of scalar addition), even though they are often denoted in the same way. Lastly, ∃!⁡u∈V\exists!u\in V∃ !  ∈ italic_V means ‘there exists a unique uu in VVitalic_V’, and it implies that there is exactly one element u∈Vu\in V ∈ italic_V such that a particular condition is satisfied.

#### Examples of Vector Spaces

- •

  Vectors: ℝn\={(v1,…,vn):vi∈ℝ,∀i\=1,…,n}\mathbb{R}^{n}=\{(v\_{1},\dots,v\_{n}):v\_{i}\in\mathbb{R},\forall i=1,\dots,n\}  = { (   ∈  , ∀  = 1 , … ,  } with u+v\=(u1+v1,…,un+vn)u+v=(u\_{1}+v\_{1},\dots,u\_{n}+v\_{n}) +  = (   )

  Report issue for preceding element

- •

  Functions: ℱ​(Ω)\={f:Ω→ℝ}\mathcal{F}(\Omega)=\{f:\Omega\rightarrow\mathbb{R}\}caligraphic_F ( roman_Ω ) = {  : roman_Ω →  } with (f+g)​(x)\=f​(x)+g​(x)(f+g)(x)=f(x)+g(x)(  +  ) (  ) =  (  ) +  (  ) ††margin: ℱ\mathcal{F}caligraphic_F is used to denote a set of functions on the domain Ω\Omegaroman_Ω. That is, the set ℱ​(Ω)\mathcal{F}(\Omega)caligraphic_F ( roman_Ω ) consists of functions whose domain is Ω\Omegaroman_Ω. Here, we talk about functions instead of maps, since we are considering special types of maps that map a set Ω\Omegaroman_Ω to ℝ\mathbb{R}, rather than to an arbitrary set.

  Report issue for preceding element

#### From Vector Spaces to Tensor Spaces

Although it is less commonly discussed in basic linear algebra than vector spaces, in practice in Deep Learning we work with tensor spaces. A tensor is a multi-dimensional generalization of vectors and matrices. Tensors are particularly relevant in Deep Learning for parallel data processing.

Next, we discuss some basic examples. A scalar is a tensor of order (or rank) 0, represented by a single value, say

a\=5a=5 = 5

A vector is a tensor of order 1, represented as a one-dimensional array

v\=\[123\].v=\begin{bmatrix}1\\ 2\\ 3\end{bmatrix}. = \[  \] .

A matrix is a tensor of order 2, represented as a two-dimensional array

M\=\[123456\].M=\begin{bmatrix}1&2\\ 3&4\\ 5&6\end{bmatrix}.italic_M = \[  \] .

A higher-order tensor, of order 3 in this example, is a nn\-dimensional array, represented as

Ti​j​k\=\[\[1234\],\[5678\],\[9101112\]\].T\_{ijk}=\begin{bmatrix}\begin{bmatrix}1&2\\ 3&4\end{bmatrix},&\begin{bmatrix}5&6\\ 7&8\end{bmatrix},&\begin{bmatrix}9&10\\ 11&12\end{bmatrix}\end{bmatrix}.italic_T  = \[  \] .

Ti​j​kT\_{ijk}italic_T  in this particular instance represents a 3×2×23\times 2\times 23 × 2 × 2 tensor. Alternatively, we can express the slices more clearly:

Ti​j​k\={T1,:,:\=\[1234\],T2,:,:\=\[5678\],T3,:,:\=\[9101112\].T\_{ijk}=\left\{\begin{aligned} T\_{1,:,:}&=\begin{bmatrix}1&2\\ 3&4\end{bmatrix},\\ T\_{2,:,:}&=\begin{bmatrix}5&6\\ 7&8\end{bmatrix},\\ T\_{3,:,:}&=\begin{bmatrix}9&10\\ 11&12\end{bmatrix}.\end{aligned}\right.italic_T  end_CELL start_CELL = \[  \] . end_CELL end_ROW

The Einstein summation convention is a shorthand for tensor expressions, where repeated indices imply summation over all their possible values. This convention makes it easier to work with high-dimensional tensors. Let us look at some examples of Einstein summation.

The dot product of two vectors uu and vv in Einstein notation is written as

ui​vi\=∑iui​vi\=a,u\_{i}v^{i}=\sum\_{i}u\_{i}v^{i}=a,    =  ,

where we can omit the summation symbol, and the product results in a scalar, aa.

For a matrix MMitalic_M and vector vv, the matrix-vector multiplication in Einstein notation is

Mi​j​vj\=∑jMi​j​vj\=ui,M\_{ij}v^{j}=\sum\_{j}M\_{ij}v^{j}=u\_{i},italic_M  ,

which results in another vector, uu.

Likewise, a tensor contraction, which is a generalization of matrix multiplication, can be written as:

Ti​j​k​vj\=∑jTi​j​k​vj\=Mi​k.T\_{ijk}v^{j}=\sum\_{j}T\_{ijk}v^{j}=M\_{ik}.italic_T  .

This involves summing over the index jj, since it is the repeated index. Multiplying an order 3 tensor and a vector, results in an order 2 tensor, that is, a matrix.

Tensor Spaces in Deep Learning. A tensor space can be thought of as a generalization of vector spaces to higher-dimensional objects, where tensors (multi-dimensional arrays) act as elements in these spaces. More formally, a tensor space can be described as a set of tensors where tensor addition and scalar multiplication follow the usual rules that hold for vector spaces, but are generalized to multi-dimensional arrays. For instance in Computer Vision, we typically process tensors of shape \[B,C,H,W\],\texttt{\[B,C,H,W\]},\[B,C,H,W\] , where B stands for batch size, C for channel dimension (RGB channels), and H and W are the height and width of the image. In the context of video we can further include a frames (or time) dimension and the tensor gains an additional dimension, \[B,C,F,H,W\]. However, oftentimes in research articles, transformations are represented in terms of matrices, and additional entries such as those for the batch dimension are omitted for clarity. Report issue for preceding element

## 2 Geometric and Analytical Structures

Geometric structures bring life to abstract mathematical objects by introducing familiar concepts like distance, size, and angles. While groups and vector spaces give us powerful ways to study relationships and transformations, they lack the geometric intuition we often need in real-world applications.

### 2.1 Norms and Normed Vector Spaces

A norm is a mathematical function that quantifies the size or magnitude of a mathematical object, generalizing our intuitive understanding of length or distance in physical space. Like physical length, a norm assigns a non-negative real number to an object while satisfying specific properties.

††margin: The field can also be 𝔽\=ℂ\mathbb{F}=\mathbb{C} = , but in the main text we stick to ℝ\mathbb{R} for simplicity. Given a vector space VVitalic_V over a field 𝔽\=ℝ\mathbb{F}=\mathbb{R} = , a norm is a function ∥∥:V→ℝ\|\,\|:V\rightarrow\mathbb{R}∥ ∥ : italic_V →  satisfying for any u,v∈Vu,v\in V ,  ∈ italic_V and α∈ℝ\alpha\in\mathbb{R}italic_α ∈ : • Positive homogeneity: ‖α​u‖\=|α|​‖u‖\|\alpha u\|=|\alpha|\|u\|∥ italic_α  ∥ = | italic_α | ∥  ∥ • Triangle inequality: ‖u+v‖≤‖u‖+‖v‖\|u+v\|\leq\|u\|+\|v\|∥  +  ∥ ≤ ∥  ∥ + ∥  ∥ • Positive definiteness: ‖u‖\=0⇒u\=0\|u\|=0\quad\Rightarrow\quad u=0∥  ∥ = 0 ⇒  = 0 (V,∥∥)(V,\|\,\|)( italic_V , ∥ ∥ ) is called a normed (vector) space. Intuitively, the norm measures the length of a vector. Report issue for preceding element

The following properties (often listed as part of axiomatic definition of the norm) are in fact consequences of the above definition:††margin: The notation ‖u‖\|u\|∥  ∥ refers to the norm of an element in a vector space, where uu is a vector. In contrast, |α||\alpha|| italic_α | denotes the absolute value of a scalar, which is a special case of a norm when the underlying field is the real or complex numbers. While the norm generalizes the concept of absolute value to vector spaces, the absolute value is specifically used for scalars.

- •

  ‖0‖\=‖0⋅u‖​\=(1)​|0|​‖u‖\=0\|0\|=\|0\cdot u\|\overset{\tiny{(1)}}{=}|0|\|u\|=0∥ 0 ∥ = ∥ 0 ⋅  ∥ start_OVERACCENT ( 1 ) end_OVERACCENT  | 0 | ∥  ∥ = 0, i.e. property (3) is iff: ‖u‖\=0⇔u\=0\|u\|=0\Leftrightarrow u=0∥  ∥ = 0 ⇔  = 0.

  Report issue for preceding element

- •

  ‖u‖≥0\|u\|\geq 0∥  ∥ ≥ 0,

  Report issue for preceding element

where (1) refers to positive homogeneity and (3) to positive definiteness.

#### Examples of Norms

- •

  LpL\_{p}italic_L \-norm on ℝn\mathbb{R}^{n} : ‖u‖p\=(∑i\=1n|ui|p)1/p\|u\|\_{p}=\left(\sum\_{i=1}^{n}|u\_{i}|^{p}\right)^{1/p}∥  ∥  , in particular

  Report issue for preceding element

  - –

    L1L\_{1}italic_L \-norm: ‖u‖1\=∑i\=1n|ui|\|u\|\_{1}=\sum\_{i=1}^{n}|u\_{i}|∥  ∥  |

    Report issue for preceding element

  - –

    L2L\_{2}italic_L \-norm (Euclidean norm): ‖u‖2\=∑i\=1n|ui|2\|u\|\_{2}=\sqrt{\sum\_{i=1}^{n}|u\_{i}|^{2}}∥  ∥   end_ARG††margin: The L2L\_{2}italic_L \-norm, also known as the Euclidean norm, is the most commonly used norm, and it provides the notion of the length of a vector.

    Report issue for preceding element

  - –

    L∞L\_{\infty}italic_L \-norm: ‖u‖∞\=max⁡{|u1|,…,|un|}\|u\|\_{\infty}=\max\{|u\_{1}|,\ldots,|u\_{n}|\}∥  ∥  | }

    Report issue for preceding element

- •

  LpL\_{p}italic_L \-norm on ℱ​(Ω)\mathcal{F}(\Omega)caligraphic_F ( roman_Ω ): ‖f‖p\=(∫Ω|f​(x)|p​𝑑x)1/p\|f\|\_{p}=\left(\int\_{\Omega}|f(x)|^{p}dx\right)^{1/p}∥  ∥  |  (  ) | 

  Report issue for preceding element

The summation in the vector case, is replaced by an integral in the function case. This is because functions can be thought of as vectors with infinitely many components, where the integral serves as a continuous analog of the sum.

Norms in Geometric Deep Learning. Norms quantify the magnitude of vectors and are fundamental for enabling invariant feature representations in Geometric Deep Learning architectures, particularly under transformations such as rotations and reflections. Additionally, norms play a key role in regularization in Deep Learning. For example, weight decay penalizes the Euclidean norm of model parameters to prevent overfitting and encourage generalization. Report issue for preceding element

### 2.2 Metrics Induced by Norms and Metric Spaces

Report issue for preceding element ††margin: A metric measures the distance between two elements in a space, generalizing our intuitive notion of distance in physical space. Unlike norms which measure the size of a single vector, metrics quantify the separation between pairs of elements.

A metric represents a mathematical way to measure distances between elements in a set, with norms being a special case that can generate metrics.

Given a normed vector space (V,∥⋅∥)(V,\|\cdot\|)( italic_V , ∥ ⋅ ∥ ), a metric d:V×V→ℝd:V\times V\to\mathbb{R} : italic_V × italic_V →  is naturally defined by: d​(u,v)\=‖u−v‖,∀u,v∈V.d(u,v)=\|u-v\|,\quad\forall u,v\in V. (  ,  ) = ∥  -  ∥ , ∀  ,  ∈ italic_V . This metric satisfies the following properties, making (V,d)(V,d)( italic_V ,  ) a metric space: • Non-negativity: d​(u,v)≥0d(u,v)\geq 0 (  ,  ) ≥ 0 ††margin: While normed vector spaces are inherently metric spaces, not all metric spaces have the additional algebraic structure of a vector space. A vector space requires operations like vector addition and scalar multiplication that satisfy specific axioms. Many metric spaces lack these operations or do not satisfy the vector space axioms. For instance, in ℝn\mathbb{R}^{n} , the metric d​(u,v)\=|u1−v1|+⋯+|un−vn|d(u,v)=\sqrt{|u\_{1}-v\_{1}|}+\cdots+\sqrt{|u\_{n}-v\_{n}|} (  ,  ) = square-root  is a valid metric but cannot be derived from a norm. • Identity of indiscernibles: d​(u,v)\=0⇔u\=vd(u,v)=0\Leftrightarrow u=v (  ,  ) = 0 ⇔  =  • Symmetry: d​(u,v)\=d​(v,u)d(u,v)=d(v,u) (  ,  ) =  (  ,  ) • Triangle inequality: d​(u,w)≤d​(u,v)+d​(v,w)d(u,w)\leq d(u,v)+d(v,w) (  ,  ) ≤  (  ,  ) +  (  ,  ) Report issue for preceding element

Note that every normed vector space is also a metric space with a metric induced by its norm. However, not all metric spaces are normed vector spaces.

#### Examples of Metrics Induced by Norms

- •

  LpL\_{p}italic_L  distance in ℝn\mathbb{R}^{n} : dp​(u,v)\=‖u−v‖p\=(∑i\=1n|ui−vi|p)1/pd\_{p}(u,v)=\|u-v\|\_{p}=\left(\sum\_{i=1}^{n}|u\_{i}-v\_{i}|^{p}\right)^{1/p}  , in particular

  Report issue for preceding element

  - –

    L1L\_{1}italic_L  distance: d1​(u,v)\=‖u−v‖1\=∑i\=1n|ui−vi|d\_{1}(u,v)=\|u-v\|\_{1}=\sum\_{i=1}^{n}|u\_{i}-v\_{i}|  |

    Report issue for preceding element

  - –

    L2L\_{2}italic_L  distance (Euclidean distance): d2​(u,v)\=‖u−v‖2\=∑i\=1n|ui−vi|2d\_{2}(u,v)=\|u-v\|\_{2}=\sqrt{\sum\_{i=1}^{n}|u\_{i}-v\_{i}|^{2}}   end_ARG

    Report issue for preceding element

  - –

    L∞L\_{\infty}italic_L  distance: ††margin: The Euclidean distance is the most intuitive metric, corresponding to the physical distance between points in space. d∞​(u,v)\=‖u−v‖∞\=max⁡{|u1−v1|,…,|un−vn|}d\_{\infty}(u,v)=\|u-v\|\_{\infty}=\max\{|u\_{1}-v\_{1}|,\ldots,|u\_{n}-v\_{n}|\}  | }

    Report issue for preceding element

- •

  LpL\_{p}italic_L  distance for functions: dp​(f,g)\=‖f−g‖p\=(∫Ω|f​(x)−g​(x)|p​𝑑x)1/pd\_{p}(f,g)=\|f-g\|\_{p}=\left(\int\_{\Omega}|f(x)-g(x)|^{p}dx\right)^{1/p}  |  (  ) -  (  ) | 

  Report issue for preceding element

#### Generalizations of Metrics

The following are important generalizations of metrics:

- •

  A pseudo-metric††margin: For instance, in the context of general relativity, the term pseudo-metric often refers to the metric tensor of spacetime, which is actually a pseudo-Riemannian metric. is a function d:V×V→ℝd:V\times V\to\mathbb{R} : italic_V × italic_V →  satisfying all properties of a metric except the identity of indiscernibles. That is, d​(u,v)\=0d(u,v)=0 (  ,  ) = 0 does not necessarily imply u\=v.u=v. =  .

  Report issue for preceding element

- •

  A quasi-metric also satisfies all properties of a metric space, but it relaxes the triangle inequality to:

  Report issue for preceding element

  d​(u,w)≤𝒞​(d​(u,v)+d​(v,w)),d(u,w)\leq\mathcal{C}(d(u,v)+d(v,w)), (  ,  ) ≤ caligraphic_C (  (  ,  ) +  (  ,  ) ) ,

  known as the 𝒞\mathcal{C}caligraphic_C\-relaxed triangle inequality. When 𝒞\=1\mathcal{C}=1caligraphic_C = 1, this reduces to a standard metric space.

  Report issue for preceding element

#### Hausdorff Distance

Report issue for preceding element ††margin: The Hausdorff distance is particularly useful in comparing shapes, curves, or other geometric objects in applications such as computer vision, shape analysis, and geometric deep learning. It is closely related to the Chamfer distance, which computes the average closest point distance instead. Furthermore, the Hausdorff distance can be generalized into the Gromov-Hausdorff distance, which is used to compare metric spaces rather than subsets of a fixed metric space. It provides a way to measure how ‘far apart’ two metric spaces are, considering their intrinsic geometry rather than their embedding into a common space.

The Hausdorff distance provides a way to measure how far apart two subsets of a metric space are.

Given two non-empty subsets A,B⊂VA,B\subset Vitalic_A , italic_B ⊂ italic_V in a metric space (V,d)(V,d)( italic_V ,  ), the Hausdorff distance dHd\_{H}  is defined as: dH​(A,B)\=max⁡{supa∈Ainfb∈Bd​(a,b),supb∈Binfa∈Ad​(b,a)}.d\_{H}(A,B)=\max\left\{\sup\_{a\in A}\inf\_{b\in B}d(a,b),\sup\_{b\in B}\inf\_{a\in A}d(b,a)\right\}.   (  ,  ) } . Report issue for preceding element

Here, d​(a,b)d(a,b) (  ,  ) is the distance between points a∈Aa\in A ∈ italic_A and b∈Bb\in B ∈ italic_B as defined by the metric dd on VVitalic_V. The Hausdorff distance satisfies the following properties:

- •

  Non-negativity: dH​(A,B)≥0d\_{H}(A,B)\geq 0  ( italic_A , italic_B ) ≥ 0, and dH​(A,B)\=0d\_{H}(A,B)=0  ( italic_A , italic_B ) = 0 if and only if A\=BA=Bitalic_A = italic_B (when AAitalic_A and BBitalic_B are closed sets).

  Report issue for preceding element

- •

  Symmetry: dH​(A,B)\=dH​(B,A)d\_{H}(A,B)=d\_{H}(B,A)  ( italic_B , italic_A ).

  Report issue for preceding element

- •

  Triangle inequality: dH​(A,C)≤dH​(A,B)+dH​(B,C)d\_{H}(A,C)\leq d\_{H}(A,B)+d\_{H}(B,C)  ( italic_B , italic_C ) for any subsets A,B,C⊂VA,B,C\subset Vitalic_A , italic_B , italic_C ⊂ italic_V.

  Report issue for preceding element

In ℝn\mathbb{R}^{n}  with the Euclidean distance, the Hausdorff distance is often used to compare geometric objects such as polygons or point clouds.

Metrics in Geometric Deep Learning. Metrics define distance measures for comparing data points across graph, manifold, and point cloud representations, as well as in neural latent (embedding) spaces. In particular, the Euclidean distance d2​(u,v)\=‖u−v‖2\=∑i\=1n|ui−vi|2d\_{2}(u,v)=\|u-v\|\_{2}=\sqrt{\sum\_{i=1}^{n}|u\_{i}-v\_{i}|^{2}}   end_ARG is a natural choice in many Deep Learning implementations. For instance, in Geometric Deep Learning and computational biology, Euclidean distance is commonly used to construct unit disk graphs or k-nearest neighbor graphs in ℝ3\mathbb{R}^{3} . This approach allows to define the connectivity structure of atomic point clouds, such as those derived from protein structures resolved via X-ray crystallography or cryo-Electron Microscopy, where nodes correspond to atoms and edges represent proximity-based interactions. Another notable example is vector quantization methods for neural discrete representation learning developed in the late 2010s, which use Euclidean distance to compare continuous latent embeddings with entries in a learned codebook. Moreover, beyond continuous metric spaces, we often leverage metrics induced by discrete structures such as graph geodesic distances to compute, for example, optimal commute times in transportation networks or information flow in social graphs. Report issue for preceding element

### 2.3 The Inner Product and Inner Product Spaces

In terms of hierarchy, metric spaces form the foundational mathematical structure defining distance, with normed vector spaces and inner product spaces representing progressively more specialized and structured mathematical environments. Normed vector spaces extend metric spaces by integrating a norm that naturally induces a metric, while inner product spaces further enhance this structure by introducing an inner product that generates a norm.

††margin: The field can also be 𝔽\=ℂ.\mathbb{F}=\mathbb{C}. =  . Given a vector space VVitalic_V over a field 𝔽\=ℝ\mathbb{F}=\mathbb{R} = , an inner product is a function ⟨,⟩:V×V→ℝ\langle\,,\,\rangle:V\times V\rightarrow\mathbb{R}⟨ , ⟩ : italic_V × italic_V →  satisfying for any u,v,w∈Vu,v,w\in V ,  ,  ∈ italic_V and α∈ℝ\alpha\in\mathbb{R}italic_α ∈ : • Conjugate (Hermitian) Symmetry: ⟨u,v⟩\=⟨v,u⟩¯\langle u,v\rangle=\overline{\langle v,u\rangle}⟨  ,  ⟩ = over¯ ††margin: The overline (⋅)¯\overline{(\cdot)}over¯  is used to denote the complex conjugate. For z\=a+b​i,z=a+bi, =  +   , then its complex conjugate is: z¯\=a−b​i.\overline{z}=a-bi.over¯  =  -   . Note that the complex conjugate of a real number is itself. • Linearity: ⟨α​u,v⟩\=α​⟨u,v⟩,⟨u+w,v⟩\=⟨u,v⟩+⟨w,v⟩\langle\alpha u,v\rangle=\alpha\langle u,v\rangle,\,\langle u+w,v\rangle=\langle u,v\rangle+\langle w,v\rangle⟨ italic_α  ,  ⟩ = italic_α ⟨  ,  ⟩ , ⟨  +  ,  ⟩ = ⟨  ,  ⟩ + ⟨  ,  ⟩ • Positive Semi-Definiteness: ⟨u,u⟩≥0,⟨u,u⟩\=0⇔u\=0\langle u,u\rangle\geq 0,\,\langle u,u\rangle=0\Leftrightarrow u=0⟨  ,  ⟩ ≥ 0 , ⟨  ,  ⟩ = 0 ⇔  = 0 (V,⟨,⟩)(V,\langle\,,\,\rangle)( italic_V , ⟨ , ⟩ ) is called an inner product space. Report issue for preceding element

The following additional property, called conjugate linearity in the second argument, is a consequence of the above definition (considering the field to be 𝔽\=ℂ\mathbb{F}=\mathbb{C} =  for more generality):††margin: Here, we have applied in order: conjugate symmetry, linearity in the second argument of the inner product, the distributive property of complex conjugation, and substitution from the conjugate symmetry.

⟨u,α​v⟩\=⟨α​v,u⟩¯\=α​⟨v,u⟩¯\=α¯⋅⟨v,u⟩¯\=α¯​⟨u,v⟩.\langle u,\alpha v\rangle=\overline{\langle\alpha v,u\rangle}=\overline{\alpha\langle v,u\rangle}=\overline{\alpha}\cdot\overline{\langle v,u\rangle}=\overline{\alpha}\langle u,v\rangle.⟨  , italic_α  ⟩ = over¯  ⟨  ,  ⟩ .

Also, note that as previously discussed, in Einstein summation convention, repeated indices are implicitly summed over. For example, in the case of real vectors, we can write the inner product as:

⟨u,v⟩\=ui​vi,\langle u,v\rangle=u\_{i}v\_{i},⟨  ,  ⟩ =   ,

where the repeated index ii is implicitly summed over from 111 to nn.††margin: Gram-Schmidt orthogonalization is a method to transform a set of linearly independent vectors into an orthogonal (or orthonormal) set of vectors; eigenvalue decomposition factors a square matrix into a product involving its eigenvalues and eigenvectors; and principal component analysis is used to reduce the dimensionality of a dataset while retaining as much variance as possible.

Inner products provide additional structure beyond what a norm alone can offer. In particular, they enable definitions of angles, orthogonality, and support advanced computational techniques like Gram-Schmidt orthogonalization, eigenvalue decomposition, and principal component analysis. These operations leverage the geometric insights intrinsic to inner product structures. Also, norms derived from inner products often have smoother behavior compared to arbitrary norms. This characteristic makes inner product spaces especially valuable in optimization contexts, where they facilitate natural gradient calculations and provide well-defined curvature representations. Finally note that inner products induce norms, but not vice versa.

#### Examples of Inner Products

- ††margin: A square-integrable function is a function ff defined on a domain Ω\Omegaroman_Ω such that the square of its absolute value is integrable over Ω\Omegaroman_Ω. Specifically, a function f​(x)f(x) (  ) belongs to the space L2​(Ω)L^{2}(\Omega)italic_L  ( roman_Ω ) if: ∫Ω|f​(x)|2​𝑑x<∞.\int\_{\Omega}|f(x)|^{2}\,dx<\infty.∫  |  (  ) |    < ∞ .
- •

  Real vectors ℝn\mathbb{R}^{n} : ⟨u,v⟩\=∑i\=1nui​vi\=ui​vi\=v⊤​u\langle u,v\rangle=\sum\_{i=1}^{n}u\_{i}v\_{i}=u\_{i}v\_{i}=v^{\top}u⟨  ,  ⟩ = ∑   

  Report issue for preceding element

- •

  Complex vectors ℂn\mathbb{C}^{n} : ⟨u,v⟩\=∑i\=1nui​v¯i\=ui​v¯i\=v∗​u\langle u,v\rangle=\sum\_{i=1}^{n}u\_{i}\overline{v}\_{i}=u\_{i}\overline{v}\_{i}=v^{\*}u⟨  ,  ⟩ = ∑   

  Report issue for preceding element

- •

  Real matrices: ⟨A,B⟩\=trace​(AB⊤)\langle A,B\rangle=\mathrm{trace(AB^{\top})}⟨ italic_A , italic_B ⟩ =  (   )

  Report issue for preceding element

- •

  Square-integrable functions L2​(Ω)L^{2}(\Omega)italic_L  ( roman_Ω ): ⟨f,g⟩\=∫Ωf​(x)​g​(x)¯​𝑑x\langle f,g\rangle=\int\_{\Omega}f(x)\overline{g(x)}dx⟨  ,  ⟩ = ∫   (  ) over¯   

  Report issue for preceding element

- •

  Square-summable real sequences ℓ2\ell^{2}roman_ℓ : ⟨x,y⟩\=∑i≥1xi​yi\langle x,y\rangle=\sum\_{i\geq 1}x\_{i}y\_{i}⟨  ,  ⟩ = ∑ ††margin: A square-summable real sequence is a sequence of real numbers {an}n\=1∞\{a\_{n}\}\_{n=1}^{\infty}{   }   such that the sum of the squares of its elements is finite: ∑n\=1\inftya<n2∞.\sum\_{n=1}^{\inftya}{}\_{n}^{2}<\infty.∑   < ∞ .

  Report issue for preceding element

#### Relation to Norms

The inner product naturally defines a norm, given by

‖u‖\=(⟨u,u⟩)1/2.\|u\|=\left(\langle u,u\rangle\right)^{1/2}.∥  ∥ = ( ⟨  ,  ⟩ )  .

This norm satisfies the Cauchy-Schwarz (Bunyakovsky) inequality:

|⟨u,v⟩|≤‖u‖⋅‖v‖.|\langle u,v\rangle|\leq\|u\|\cdot\|v\|.| ⟨  ,  ⟩ | ≤ ∥  ∥ ⋅ ∥  ∥ .

This inequality is crucial because it provides an upper bound on the inner product in terms of the magnitudes (norms) of the vectors, ensuring that the inner product cannot exceed the product of the norms of the vectors.

The cosine of the angle between two vectors is given by

cos⁡∠​(u,v)\=⟨u,v⟩‖u‖⋅‖v‖,\cos\angle(u,v)=\frac{\langle u,v\rangle}{\|u\|\cdot\|v\|}, ∠ (  ,  ) = divide  ,

which expresses the relationship between the vectors in terms of their geometric angle. When ⟨u,v⟩\=0\langle u,v\rangle=0⟨  ,  ⟩ = 0, the vectors are said to be orthogonal, meaning the angle between them is 90∘90^{\circ}90  (i.e., u⟂vu\perp v ⟂ ). This condition is essential for understanding orthogonality in inner product spaces.

Not every norm defines an inner product! A norm that satisfies the parallelogram law:

2​‖u‖2+2​‖v‖2\=‖u+v‖2+‖u−v‖2,2\|u\|^{2}+2\|v\|^{2}=\|u+v\|^{2}+\|u-v\|^{2},2 ∥  ∥  ,

can be used to define an inner product via the polarization identity:

⟨u,v⟩\=14​(‖u+v‖2−‖u−v‖2).\langle u,v\rangle=\frac{1}{4}\left(\|u+v\|^{2}-\|u-v\|^{2}\right).⟨  ,  ⟩ = divide  ( ∥  +  ∥  ) .

The parallelogram law provides a critical condition for determining whether a norm arises from an inner product. It describes how the lengths of vectors behave geometrically when combined through addition or subtraction. Specifically, it expresses a relationship between the squares of the lengths of the vectors and their sums and differences, mirroring the geometry of inner product spaces.

If the parallelogram law is not satisfied, then the norm cannot be derived from an inner product. Without this structure, we lose important geometric concepts like orthogonality, angles, and projections, which are fundamental to understanding the behavior of vectors in the space. For example, spaces with norms that do not satisfy the parallelogram law, such as the L1L\_{1}italic_L  norm, do not allow for meaningful definitions of orthogonality or angles.

###### Theorem 1 (Generalized Pythagorean Theorem).

Report issue for preceding element For a set of pairwise orthogonal vectors v1,v2,…,vn∈Vv\_{1},v\_{2},\dots,v\_{n}\in V  ∈ italic_V (i.e., ⟨vi,vj⟩\=0\langle v\_{i},v\_{j}\rangle=0⟨   ⟩ = 0 for i≠ji\neq j ≠ ), we have the following property: ‖∑i\=1nvi‖2\=∑i\=1n‖vi‖2.\left\|\sum\_{i=1}^{n}v\_{i}\right\|^{2}=\sum\_{i=1}^{n}\|v\_{i}\|^{2}.∥ ∑   . Report issue for preceding element

This result directly generalizes the Pythagorean theorem from Euclidean geometry: when vectors are orthogonal, the square of the norm of their sum is equal to the sum of the squares of their individual norms.††margin: The original Pythagorean theorem states that in a right triangle with legs of length aa and bb, and hypotenuse of length cc, the relation a2+b2\=c2a^{2}+b^{2}=c^{2}  holds. This theorem can be interpreted geometrically in Euclidean space as the sum of the squares of the orthogonal components of a vector. For non-orthogonal vectors, the sum will be less than or equal to the square of the norm of the sum, by virtue of the triangle inequality.

Inner products in Deep Learning. The inner product between two vectors encodes similarity, but is not invariant to scale since large magnitudes can dominate even if directions differ. To mitigate this, the cosine similarity, defined as the normalized inner product, captures the directional alignment between vectors while discarding scale information. Scale invariance can be particularly useful in Deep Learning, where activations can vary in norm due to factors such as network depth, normalization, or noise, but their direction in latent space often encodes semantic content. Inner products (and their normalized counterparts) are smooth, linear functions that provide more stable comparisons than raw norms, such as LpL\_{p}italic_L  distances. They underpin attention mechanisms in Transformers (the ubiquitous neural network architecture that has impregnated all realms of Deep Learning), where scaled dot-product attention is used. While the dot-product itself is not scale-invariant, scaling by 1d\frac{1}{\sqrt{d}}divide  reduces the sensitivity to vector norm and makes the softmax activation more numerically stable. Interestingly, in high-dimensional latent spaces the curse of dimensionality can become a blessing: random vectors are almost always nearly orthogonal which allows neural networks to store a large number of features in directions that do not interfere with each other. In short, high-dimensional latent spaces can pack more information than their dimension may initially suggest, thanks to near-orthogonality. Report issue for preceding element

## 3 Vector calculus

Scalar and vector fields represent quantities that vary across space. These concepts differ from the abstract notion of a vector space, which is purely an algebraic structure. In this section, we examine scalar fields, vector fields, and calculus, which provides essential tools for quantifying variations across space. The latter enables the description of scalar and vector field behavior through operations like differentiation and integration. Differentiation is used to quantify local field behavior, while integral operators establish relationships between infinitesimal variations and macroscopic field properties.

### 3.1 (Lipschitz) Continuity, Differentiability, and Smoothness

In practice, modeling scalar and vector fields is common in Geometric Deep Learning, particularly in applications such as data-driven physics simulations and 3D graphics. These fields are often represented as, or assumed to be, continuous functions that can be approximated using artificial neural networks.

#### Continuity

For a function to be continuous at a point, the limit of the function as we approach that point must exist and be equal to the function’s value at that point. In simpler terms, a continuous function has no abrupt jumps or breaks and ‘can be drawing without lifting your pen from the page’.

Continuity of a function ff at a point x0x\_{0}  requires: • The limit limx→x0f​(x)\lim\_{x\to x\_{0}}f(x)   (  ) exists, • limx→x0−f​(x)\=limx→x0+f​(x)\lim\_{x\to x\_{0}^{-}}f(x)=\lim\_{x\to x\_{0}^{+}}f(x)   (  ) (the limit is independent of the direction from which xx approaches x0x\_{0} ), • and the limit and function value must be equal f​(x0)\=limx→x0f​(x)f(x\_{0})=\lim\_{x\to x\_{0}}f(x) (    (  ). Report issue for preceding element

Note that the mention of one-sided limits (limx→x0−\lim\_{x\to x\_{0}^{-}}  and limx→x0+\lim\_{x\to x\_{0}^{+}} ) is specific to functions on ℝ\mathbb{R}, where continuity is analyzed along a single dimension. For higher dimensions, this concept generalizes to approaching x0x\_{0}  from any direction. If the requirements above are satisfied we say that ff is a continuous function.

A function ff is Lipschitz continuous with Lipschitz constant LLitalic_L if for all x,y∈ℝnx,y\in\mathbb{R}^{n} ,  ∈  : |f​(x)−f​(y)|≤L​|x−y||f(x)-f(y)|\leq L|x-y||  (  ) -  (  ) | ≤ italic_L |  -  | Report issue for preceding element

††margin: In optimization, the notion of Lipschitz continuity is sometimes used to provide guarantees regarding the convergence of algorithms based on iterative methods.

Lipschitz continuity bounds the rate of change of a function and ensures that it does not change too rapidly between any two points. The Lipschitz constant LLitalic_L provides an upper bound on the function’s local slope or steepness. Functions that are Lipschitz continuous are always continuous but not vice versa.

#### Differentiability and Smoothness

Differentiability is a stronger condition than continuity. While a continuous function ensures smooth variation, a differentiable function provides additional information about the rate of change. The existence of derivatives at every point implies that the function can be well-approximated by its tangent line or hyperplane locally.

A function ff is said to be smooth when its derivatives exist up to a certain order and are continuous. We denote this using 𝒞k\mathcal{C}^{k}caligraphic_C  notation: • 𝒞0\mathcal{C}^{0}caligraphic_C : Continuous function • 𝒞1\mathcal{C}^{1}caligraphic_C : Continuously differentiable (first derivatives are continuous) • 𝒞k\mathcal{C}^{k}caligraphic_C : kk times continuously differentiable • 𝒞∞\mathcal{C}^{\infty}caligraphic_C : Infinitely differentiable (derivatives of all orders exist and are continuous) Report issue for preceding element

Smoothness represents progressively stronger conditions on a function’s differentiability. As the smoothness class increases from 𝒞0\mathcal{C}^{0}caligraphic_C  to 𝒞∞\mathcal{C}^{\infty}caligraphic_C , the function becomes increasingly well-behaved. Note that being continuously differentiable is a stronger condition that being differentiable alone, since it implies that the derivative does not only exist but it is also continuous.

### 3.2 Scalar Fields, Vector Fields, and Signals

A scalar field is a function f:ℝn→ℝf:\mathbb{R}^{n}\to\mathbb{R} :   →  that assigns a single scalar value to every point in nn\-dimensional space, f​(x)\=f​(x1,…,xn).f(x)=f(x\_{1},\ldots,x\_{n}). (  ) =  (   ) . Report issue for preceding element

In ℝ3\mathbb{R}^{3} , f​(x,y,z)f(x,y,z) (  ,  ,  ) could represent the temperature at a specific point (x,y,z)(x,y,z)(  ,  ,  ) in a room. The value of f​(x)f(x) (  ) at each point is a scalar, meaning it has magnitude but no direction.

A vector field is a function F:ℝn→ℝmF:\mathbb{R}^{n}\to\mathbb{R}^{m}italic_F :   that assigns a vector to each point in space. Report issue for preceding element

For instance, in ℝ3\mathbb{R}^{3} , F​(x,y,z)\=(F1​(x,y,z),F2​(x,y,z),F3​(x,y,z))F(x,y,z)=(F\_{1}(x,y,z),F\_{2}(x,y,z),F\_{3}(x,y,z))italic_F (  ,  ,  ) = ( italic_F  (  ,  ,  ) ) might represent the velocity of a fluid or the direction and magnitude of a force at each point in space. In this physical example, the value of F​(x)F(x)italic_F (  ) at each point has both magnitude and direction, distinguishing it from a scalar field. Note, however, that in the mathematical sense, a vector field is simply a function that assigns a vector to each point in some domain, hence, strictly speaking each of the vector field components can be an independent scalar function.

While the definitions above assume the domain is Euclidean ℝn\mathbb{R}^{n} , they extend naturally to more general domains Ω\Omegaroman_Ω, such as graphs or manifolds. In such cases, derivatives are interpreted using the domain’s intrinsic structure (e.g., graph gradients or Laplacians for graphs, and covariant derivatives on manifolds). We will discuss this in more depth in Section [7](https://arxiv.org/html/2508.02723v1#S7 "7 Graph Theory ‣ Mathematical Foundations of Geometric Deep Learning").

What do we mean by Signals. We define signals as mappings from a domain Ω\Omegaroman_Ω to a vector space 𝒞\mathcal{C}caligraphic_C, whose dimensions are referred to as ‘channels’ in Deep Learning terminology. In the most general case, Ω\Omegaroman_Ω does not necessarily possess a vector space structure. Therefore, when we use the term ‘signal’, we are referring to a vector field F:Ω→𝒞F:\Omega\to\mathcal{C}italic_F : roman_Ω → caligraphic_C, where 𝒞\=ℝm\mathcal{C}=\mathbb{R}^{m}caligraphic_C =   and mm denotes the number of channel dimensions. In physics, Ω\Omegaroman_Ω is often Euclidean space, but in Geometric Deep Learning, it could be another non-Euclidean structure, such as a graph. If m\=1m=1 = 1 this would be a scalar field instead. We often can vectors in 𝒞\mathcal{C}caligraphic_C ‘feature vectors’. Report issue for preceding element

### 3.3 Derivatives and Gradients

A derivative captures how a function changes with respect to a change in its input. More concretely, it quantifies the rate of change or the slope of the function at a given point.

††margin: In this context, by smoothness we imply being at least twice continuously differentiable (often denoted as 𝒞2\mathcal{C}^{2}caligraphic_C ), i.e., having continuous second-order derivatives. Let f:ℝn→ℝf:\mathbb{R}^{n}\rightarrow\mathbb{R} :   →  be a smooth scalar field. A directional derivative of ff at xx in direction d∈ℝnd\in\mathbb{R}^{n} ∈   is given by ∂df​(x)\=fxi​(x)\=limϵ→0f​(x+ϵ​d)−f​(x)ϵ.

tial\_{d}f(x)=f\_{x\_{i}}(x)=\lim\_{\epsilon\rightarrow 0}\,\frac{f(x+\epsilon d)-f(x)}{\epsilon}.∂  divide  . Report issue for preceding element

††margin: The directional derivative quantifies how the function ff changes as one moves from the point xx in the direction specified by the vector dd. A partial derivative of ff at xx w.r.t. coordinate xix\_{i}  is given by ∂∂xi​f​(x)\=fxi​(x)\=limϵ→0f​(x1,…,xi+ϵ,…,xn)−f​(x1,…,xn)ϵ,\frac{

tial}{

tial x\_{i}}f(x)=f\_{x\_{i}}(x)=\lim\_{\epsilon\rightarrow 0}\,\frac{f(x\_{1},\ldots,x\_{i}+\epsilon,\ldots,x\_{n})-f(x\_{1},\ldots,x\_{n})}{\epsilon},divide  , and is thus a directional derivative in the direction xix\_{i} . Report issue for preceding element

Hence, partial derivatives are special cases of directional derivatives, where the direction aligns with the unit vector along the ii\-th coordinate axis.

In its simplest form, when the scalar field has a single input dimension f:ℝ→ℝf:\mathbb{R}\to\mathbb{R} :  → , the derivative f′​(x)f^{\prime}(x)  (  ) measures the rate of change of ff with respect to the single variable xx, and we can simply right f′​(x)\=dd​x​f​(x)f^{\prime}(x)=\frac{d}{dx}f(x)  (  ) = divide   (  ), instead of using the ∂

tial∂ notation.

#### Numerical Methods and Approximations of the Derivative

To compute derivatives in practical settings, especially when analytical expressions are unavailable, numerical methods are used. These approximations leverage finite differences to estimate derivatives.

For a scalar field f:ℝ→ℝf:\mathbb{R}\to\mathbb{R} :  → , the derivative f′​(x)f^{\prime}(x)  (  ) at a point xx can be approximated using finite differences:

- •

  Forward Difference:

  Report issue for preceding element

  f′​(x)≈f​(x+h)−f​(x)h,f^{\prime}(x)\approx\frac{f(x+h)-f(x)}{h},  (  ) ≈ divide  ,

  where h\>0h>0 > 0 is a small step size.

  Report issue for preceding element

- •

  Backward Difference:

  Report issue for preceding element

  f′​(x)≈f​(x)−f​(x−h)h.f^{\prime}(x)\approx\frac{f(x)-f(x-h)}{h}.  (  ) ≈ divide  .

- •

  Central Difference:

  Report issue for preceding element

  f′​(x)≈f​(x+h)−f​(x−h)2​h.f^{\prime}(x)\approx\frac{f(x+h)-f(x-h)}{2h}.  (  ) ≈ divide  .

Central differences are generally more accurate, as they reduce the truncation error to 𝒪​(h2)\mathcal{O}(h^{2})caligraphic_O (   ). ††margin: The notation, 𝒪​(h2)\mathcal{O}(h^{2})caligraphic_O (   ), is called ‘Big-O’ notation, and it indicates that the leading term of the truncation error is proportional to h2h^{2} . This effectively means that the error increases quadratically as a function of the step size.

Finite difference methods introduce truncation errors due to the approximation of the limit. The magnitude of the error depends on the choice of hh.

#### The Gradient

The gradient is a linear functional assigning to each direction how much the function ff changes in that direction.

The gradient of ff is a vector-valued function (vector field) ∇f:ℝn→ℝn\nabla f:\mathbb{R}^{n}\rightarrow\mathbb{R}^{n}∇  :   satisfying ⟨∇f​(x),d⟩\=∂df​(x)\langle\nabla f(x),d\rangle=

tial\_{d}f(x)⟨ ∇  (  ) ,  ⟩ = ∂   (  ) for all x,d∈ℝnx,d\in\mathbb{R}^{n} ,  ∈  . Report issue for preceding element

We stress that vectors should be correctly treated as abstract objects rather than their coordinates in some basis. However, if one wishes to express the gradient w.r.t. to the standard basis of unit vectors {e1,…,en}\{e\_{1},\ldots,e\_{n}\}{   } on ℝn\mathbb{R}^{n} , this is possible by applying ⟨∇f​(x),ei⟩\=∂∂xi​f​(x)\langle\nabla f(x),e\_{i}\rangle=\frac{

tial}{

tial x\_{i}}f(x)⟨ ∇  (  ) ,   end_ARG  (  ). This leads to the usual (somewhat primitive) way of thinking of the gradient as a vector of partial derivatives,

∇f​(x)\=(∂∂x1​f​(x),…,∂∂xn​f​(x)).\nabla f(x)=\left(\frac{

tial}{

tial x\_{1}}f(x),\ldots,\frac{

tial}{

tial x\_{n}}f(x)\right).∇  (  ) = ( divide   (  ) ) .

Using the gradient, one can provide a linear approximation (first-order Taylor expansion) of ff around xx,††margin: The Taylor series expansion provides a polynomial approximation of the smooth function ff.

f​(x+d​x)\=f​(x)+⟨∇f​(x),d​x⟩+𝒪​(‖d​x‖2),f(x+dx)=f(x)+\langle\nabla f(x),dx\rangle+\mathcal{O}(\|dx\|^{2}), (  +   ) =  (  ) + ⟨ ∇  (  ) ,   ⟩ + caligraphic_O ( ∥   ∥  ) ,

where d​xdx  is some infinitesimal displacement. Note the direct relation to numerical methods and the forward difference.

#### The Jacobian Matrix

The Jacobian matrix generalizes the gradient to vector fields.

For a vector-valued function F:ℝn→ℝmF:\mathbb{R}^{n}\to\mathbb{R}^{m}italic_F :  , the Jacobian matrix JF​(x)J\_{F}(x)italic_J  (  ) at a point x∈ℝnx\in\mathbb{R}^{n} ∈   is defined as the matrix of all first-order partial derivatives of the components of FFitalic_F. That is, JF​(x)\=\[∂Fi∂xj\]i\=1,…,m,j\=1,…,n\=\[∂F1∂x1∂F1∂x2⋯∂F1∂xn∂F2∂x1∂F2∂x2⋯∂F2∂xn⋮⋮⋱⋮∂Fm∂x1∂Fm∂x2⋯∂Fm∂xn\].J\_{F}(x)=\left\[\frac{

tial F\_{i}}{

tial x\_{j}}\right\]\_{i=1,\dots,m,j=1,\dots,n}=\begin{bmatrix}\frac{

tial F\_{1}}{

tial x\_{1}}&\frac{

tial F\_{1}}{

tial x\_{2}}&\cdots&\frac{

tial F\_{1}}{

tial x\_{n}}\\ \frac{

tial F\_{2}}{

tial x\_{1}}&\frac{

tial F\_{2}}{

tial x\_{2}}&\cdots&\frac{

tial F\_{2}}{

tial x\_{n}}\\ \vdots&\vdots&\ddots&\vdots\\ \frac{

tial F\_{m}}{

tial x\_{1}}&\frac{

tial F\_{m}}{

tial x\_{2}}&\cdots&\frac{

tial F\_{m}}{

tial x\_{n}}\end{bmatrix}.italic_J  end_ARG end_CELL end_ROW end_ARG \] . Report issue for preceding element

Each element of the Jacobian represents how a single component of the vector field FFitalic_F changes in response to a change in one of the coordinates of the domain. The Jacobian provides valuable information about the local behavior of the function, such as how the function stretches or compresses space.

### 3.4 Integrals

The integral of a function ff over a domain Ω\Omegaroman_Ω is a value that represents the total accumulation of ff across Ω\Omegaroman_Ω. For functions f:ℝn→ℝf:\mathbb{R}^{n}\to\mathbb{R} :   → , the integral is formally defined as ∫Ωf​(x)​𝑑V,\int\_{\Omega}f(x)\,dV,∫   (  )  italic_V , where d​VdV italic_V denotes the infinitesimal volume element. Report issue for preceding element

Integration generalizes the notion of summation to continuous domains. For scalar functions ff, the integral provides a measure of how ff ‘adds up’ across the domain Ω\Omegaroman_Ω. For instance, in the case of n\=1n=1 = 1, integration corresponds to calculating the signed area under the curve f​(x)f(x) (  ) over an interval. In higher ††margin: When the domain Ω\Omegaroman_Ω is defined by bounds on individual coordinates, the multi-dimensional integral can be split into a series of one-dimensional integrals. This is known as Fubini’s theorem. dimensions, the infinitesimal volume element d​VdV italic_V depends on the coordinate system used. For Cartesian coordinates in ℝn\mathbb{R}^{n} , d​V\=d​x1​d​x2​⋯​d​xndV=dx\_{1}dx\_{2}\cdots dx\_{n} italic_V =   . In polar, cylindrical, or spherical coordinates, d​VdV italic_V includes factors to account for the geometry of the domain.

#### Riemann Integral

The Riemann integral is one of the foundational approaches to defining integration.

For a bounded function f:\[a,b\]→ℝf:\[a,b\]\to\mathbb{R} : \[  ,  \] → , its Riemann integral is defined as the limit of Riemann sums: ††margin: If the function is not bounded or if it presents severe discontinuities, the Riemann integral fails. We say that such functions are not Riemann integrable. Alternatives like the Lebesgue integral can handle such cases. ∫abf​(x)​𝑑x\=limn→∞∑i\=1nf​(xi∗)​Δ​xi,\int\_{a}^{b}f(x)\,dx=\lim\_{n\to\infty}\sum\_{i=1}^{n}f(x\_{i}^{\*})\Delta x\_{i},∫  , where \[a,b\]\[a,b\]\[  ,  \] is divided into nn subintervals of width Δ​xi\Delta x\_{i}roman_Δ  , and xi∗x\_{i}^{\*}   is a chosen point in each subinterval. Report issue for preceding element

This approach intuitively captures the idea of summing up small contributions f​(xi∗)​Δ​xif(x\_{i}^{\*})\Delta x\_{i} (  . Similar to the forward difference method for approximating derivatives, when the closed-form solution to an integral is unknown, the Riemann sum is often used as a numerical approximation in computational methods.

#### Line and Surface Integrals

Integration extends beyond volumes to lower-dimensional objects, such as curves and surfaces.

A line integral accumulates a function ff along a curve CCitalic_C: ∫Cf​(x)​𝑑s,\int\_{C}f(x)\,ds,∫   (  )   , where d​sds  is the infinitesimal arc length. Report issue for preceding element

A surface integral accumulates a function ff on a SSitalic_S, with the infinitesimal area element d​AdA italic_A: ∫Sf​(x)​𝑑A.\int\_{S}f(x)\,dA.∫   (  )  italic_A . Report issue for preceding element

#### Fundamental Theorem of Calculus (FTC)

The Fundamental Theorem of Calculus bridges the concepts of integration and differentiation.

###### Theorem 2 (Fundamental Theorem of Calculus).

Report issue for preceding element In one dimension, for a function ff with antiderivative FFitalic_F: ∫abf​(x)​𝑑x\=F​(b)−F​(a),\int\_{a}^{b}f(x)\,dx=F(b)-F(a),∫    (  )   = italic_F (  ) - italic_F (  ) , where b\>ab>a > . Report issue for preceding element

An anti-derivative of a function ff is a function FFitalic_F such that F′\=fF^{\prime}=fitalic_F  = . Note that a given function can have infinite many anti-derivatives. For instance, if F′​(x)\=f​(x)F^{\prime}(x)=f(x)italic_F  (  ) =  (  ) then F​(x)+CF(x)+Citalic_F (  ) + italic_C for any constant CCitalic_C is also an anti-derivative of f​(x)f(x) (  ).

### 3.5 Divergence

Let F:ℝn→ℝmF:\mathbb{R}^{n}\rightarrow\mathbb{R}^{m}italic_F :   be a smooth vector field, F​(x)\=(F1​(x),…,Fn​(x))F(x)=(F\_{1}(x),\ldots,F\_{n}(x))italic_F (  ) = ( italic_F  (  ) ).

The divergence of FFitalic_F is a scalar field div​F:ℝn→ℝ\mathrm{div}F:\mathbb{R}^{n}\rightarrow\mathbb{R} italic_F :   → , satisfying div​F​(x)\=∑i\=1n∂∂xi​Fi​(x)≡∇⋅F.\mathrm{div}F(x)=\sum\_{i=1}^{n}\frac{

tial}{

tial x\_{i}}F\_{i}(x)\,\,\equiv\,\,\,\nabla\cdot F. italic_F (  ) = ∑  (  ) ≡ ∇ ⋅ italic_F . Report issue for preceding element

Thinking of F​(x)F(x)italic_F (  ) as a flow around xx, the divergence can be given the interpretation of the density of an outward flux from an infinitesimal volume around xx.

††margin: The unit normal vector n^​(x)\hat{n}(x)over^  (  ) is a vector of length 1 that is perpendicular to the tangent plane of the boundary ∂Ω

tial\Omega∂ roman_Ω at point xx. Its direction is chosen conventionally to point outward from Ω\Omegaroman_Ω unless stated otherwise. The boundary integral ∫∂Ω\int\_{

tial\Omega}∫  represents integration over the boundary surface ∂Ω

tial\Omega∂ roman_Ω. The scalar product \langleF,n^⟩\langleF,\hat{n}\rangle, over^  ⟩ measures how the vector field FFitalic_F aligns with the normal direction, while d​SdS italic_S indicates the infinitesimal surface area element on ∂Ω

tial\Omega∂ roman_Ω.###### Theorem 3 (Gauss-(Ostrogradsky-Stokes) or simply Divergence theorem).

Report issue for preceding element Let Ω⊆ℝn\Omega\subseteq\mathbb{R}^{n}roman_Ω ⊆   be a region in space with boundary ∂Ω

tial\Omega∂ roman_Ω. Then, ∫Ωdiv​F​𝑑V\=∫∂Ω⟨F,n^⟩​𝑑S,\int\_{\Omega}\mathrm{div}FdV=\int\_{

tial\Omega}\langle F,\hat{n}\rangle dS,∫  ⟨ italic_F , over^  ⟩  italic_S , where n^​(x)\hat{n}(x)over^  (  ) denotes the unit normal vector to the boundary surface ∂Ω

tial\Omega∂ roman_Ω at point xx on thereon. Report issue for preceding element

Note that in the above theorem one assumes that Ω\Omegaroman_Ω is a smooth region and likewise FFitalic_F is a sufficiently smooth vector field (at least continuously differentiable).

The divergence theorem is a mathematical statement of the physical conservation law that, in the absence of the creation or destruction of matter, the density within a region of space can change only by having it flow into or away from the region through its boundary.

In a sense, the divergence does an operation ‘opposite’ to that of the gradient; in fact, the two operators are adjoint w.r.t. the appropriate inner products defined on the spaces of scalar and vector fields: ††margin: The negative sign in the adjoint relationship does not prevent them from being adjoint operators; however, we sometimes refer to such operators as skew-adjoint operators to distinguish them from the perhaps more standard positive case.

⟨∇f,F⟩\=−⟨f,div​F⟩.\langle\nabla f,F\rangle=-\langle f,\mathrm{div}F\rangle.⟨ ∇  , italic_F ⟩ = - ⟨  ,  italic_F ⟩ .

More concretely, let Ω⊂ℝn\Omega\subset\mathbb{R}^{n}roman_Ω ⊂   be a bounded domain with smooth boundary ∂Ω

tial\Omega∂ roman_Ω. Define inner products, for scalar fields f,g∈C∞​(Ω)f,g\in C^{\infty}(\Omega) ,  ∈ italic_C  ( roman_Ω ):

⟨f,g⟩L2​(Ω)\=∫Ωf​g​𝑑x,\langle f,g\rangle\_{L^{2}(\Omega)}=\int\_{\Omega}fg\,dx,⟨  ,  ⟩      ,

and or vector fields F,G∈\[C∞​(Ω)\]nF,G\in\[C^{\infty}(\Omega)\]^{n}italic_F , italic_G ∈ \[ italic_C :

⟨F,G⟩L2​(Ω)\=∫ΩF⋅G​𝑑x.\langle F,G\rangle\_{L^{2}(\Omega)}=\int\_{\Omega}F\cdot G\,dx.⟨ italic_F , italic_G ⟩  italic_F ⋅ italic_G   .

The left side of the original expression expands as:

⟨∇f,F⟩L2​(Ω)\=∫Ω∇f⋅F​d​x\=∫Ω∑i\=1n∂f∂xi​Fi​d​x\langle\nabla f,F\rangle\_{L^{2}(\Omega)}=\int\_{\Omega}\nabla f\cdot F\,dx=\int\_{\Omega}\sum\_{i=1}^{n}\frac{

tial f}{

tial x\_{i}}F\_{i}\,dx⟨ ∇  , italic_F ⟩   

Let us apply integration by parts to each term in the summation above:

∫Ω∂f∂xi​Fi​𝑑x\=∫Ωf​Fi​𝑑x−∫Ωf​∂Fi∂xi​𝑑x\=∫∂Ωf​Fi​n^i​𝑑S−∫Ωf​∂Fi∂xi​𝑑x,\int\_{\Omega}\frac{

tial f}{

tial x\_{i}}F\_{i}\,dx=\int\_{\Omega}fF\_{i}dx-\int\_{\Omega}f\frac{

tial F\_{i}}{

tial x\_{i}}\,dx=\int\_{

tial\Omega}fF\_{i}\hat{n}\_{i}\,dS-\int\_{\Omega}f\frac{

tial F\_{i}}{

tial x\_{i}}\,dx,∫  end_ARG   ,

where the boundary terms comes from the divergence theorem (Theorem [3](https://arxiv.org/html/2508.02723v1#Thmtheorem3 "Theorem 3 (Gauss-(Ostrogradsky-Stokes) or simply Divergence theorem). ‣ 3.5 Divergence ‣ 3 Vector calculus ‣ Mathematical Foundations of Geometric Deep Learning")) and we transition from the volume element d​xdx  to the surface element d​SdS italic_S. Summing over ii from 1 to nn:

⟨∇f,F⟩L2​(Ω)\=∫∂Ωf​(F⋅n^)​𝑑S−∫Ωf​∑i\=1n∂Fi∂xi​d​x.\langle\nabla f,F\rangle\_{L^{2}(\Omega)}=\int\_{

tial\Omega}f(F\cdot\hat{n})\,dS-\int\_{\Omega}f\sum\_{i=1}^{n}\frac{

tial F\_{i}}{

tial x\_{i}}\,dx.⟨ ∇  , italic_F ⟩  end_ARG   .

Since div​F\=∇⋅F\=∑i\=1n∂Fi∂xi\mathrm{div}F=\nabla\cdot F=\sum\_{i=1}^{n}\frac{

tial F\_{i}}{

tial x\_{i}} italic_F = ∇ ⋅ italic_F = ∑  end_ARG:

⟨∇f,F⟩L2​(Ω)\=∫∂Ωf​(F⋅n^)​𝑑S−∫Ωf​(div​F)​𝑑x.\langle\nabla f,F\rangle\_{L^{2}(\Omega)}=\int\_{

tial\Omega}f(F\cdot\hat{n})\,dS-\int\_{\Omega}f(\mathrm{div}F)\,dx.⟨ ∇  , italic_F ⟩   (  italic_F )   .

The boundary term vanishes under any of these conditions:

- •

  Dirichlet boundary condition: f|∂Ω\=0f|\_{

tial\Omega}=0 |  = 0

  Report issue for preceding element

- •

  F|∂Ω\=0F|\_{

tial\Omega}=0italic_F |  = 0

  Report issue for preceding element

- •

  Normal component vanishes: F⋅n|∂Ω\=0F\cdot n|\_{

tial\Omega}=0italic_F ⋅  |  = 0

  Report issue for preceding element

- •

  If Ω\=ℝn\Omega=\mathbb{R}^{n}roman_Ω =   and FFitalic_F decays faster than ‖x‖−n\|x\|^{-n}∥  ∥  as ‖x‖→∞\|x\|\to\infty∥  ∥ → ∞

  Report issue for preceding element

Adopting any of the above:

⟨∇f,F⟩L2​(Ω)\=∫∂Ωf​(F⋅n^)​𝑑S−∫Ωf​(div​F)​𝑑x\=0−∫Ωf​(div​F)\=−⟨f,div​F⟩L2​(Ω).\langle\nabla f,F\rangle\_{L^{2}(\Omega)}=\int\_{

tial\Omega}f(F\cdot\hat{n})\,dS-\int\_{\Omega}f(\mathrm{div}F)\,dx=0\,-\int\_{\Omega}f(\mathrm{div}F)=-\langle f,\mathrm{div}F\rangle\_{L^{2}(\Omega)}.⟨ ∇  , italic_F ⟩  .

### 3.6 Laplacian

The Laplacian operator is a measure of how a function behaves locally in terms of its rate of change.

††margin: It is common to define the Laplacian as −div​\nablaf\-\mathrm{div}\nablaf\- , to make it a positive-semidefinite operator. The Laplacian of a scalar field ff is given by Δ​f​(x)\=div​∇f.\Delta f(x)=\mathrm{div}\nabla f.roman_Δ  (  ) =  ∇  . Report issue for preceding element

The quadratic functional ⟨f,Δ​f⟩\=⟨∇f,∇f⟩\langle f,\Delta f\rangle=\langle\nabla f,\nabla f\rangle⟨  , roman_Δ  ⟩ = ⟨ ∇  , ∇  ⟩, known in physics as the Dirichlet energy, is a measure of how variable the function ff is.

###### Theorem 4.

Report issue for preceding element The Laplacian is rotation-invariant. Report issue for preceding element

###### Proof.

Write the Laplacian as the trace of the Hessian, Δ​f​(x)\=tr​(∇2f​(x))\Delta f(x)=\mathrm{tr}(\nabla^{2}f(x))roman_Δ  (  ) =  ( ∇   (  ) ). Note that when representing the Hessian as a matrix w.r.t. the standard basis, its diagonal contains second order derivatives ∂2∂xi2​f​(x)\frac{

tial^{2}}{

tial x\_{i}^{2}}f(x)divide   (  ):

∇2f​(x)\=\[∂2f​(x)∂x12⋯∂2f​(x)∂x1​∂xn⋮⋱⋮∂2f​(x)∂xn​∂x1⋯∂2f​(x)∂xn2\]\nabla^{2}f(x)=\begin{bmatrix}\frac{

tial^{2}f(x)}{

tial x\_{1}^{2}}&\cdots&\frac{

tial^{2}f(x)}{

tial x\_{1}

tial x\_{n}}\\ \vdots&\ddots&\vdots\\ \frac{

tial^{2}f(x)}{

tial x\_{n}

tial x\_{1}}&\cdots&\frac{

tial^{2}f(x)}{

tial x\_{n}^{2}}\end{bmatrix}∇  end_ARG end_CELL end_ROW end_ARG \]

Let A​xAxitalic_A  be some transformation of coordinates. Then, applying the chain rule, we have

∇xf​(A​x)\displaystyle\nabla\_{x}f(Ax)∇   ( italic_A  )

\=\displaystyle=\=

A⊤​∇A​xf​(A​x)\displaystyle A^{\top}\nabla\_{Ax}f(Ax)italic_A  ∇   ( italic_A  )

∇x2f​(A​x)\displaystyle\nabla^{2}\_{x}f(Ax)∇    ( italic_A  )

\=\displaystyle=\=

A⊤​∇A​x2f​(A​x)​A.\displaystyle A^{\top}\nabla^{2}\_{Ax}f(Ax)A.italic_A    ( italic_A  ) italic_A .

Assuming AAitalic_A is an orthogonal matrix (A​A⊤\=A⊤​A\=IAA^{\top}=A^{\top}A=Iitalic_A italic_A  italic_A = italic_I) and using matrix commutativity††margin: The trace of a product of matrices has the property tr​(X​Y)\=tr​(Y​X).\text{tr}(XY)=\text{tr}(YX).tr ( italic_X italic_Y ) = tr ( italic_Y italic_X ) . under trace we get

Δx​f​(A​x)\displaystyle\Delta\_{x}f(Ax)roman_Δ   ( italic_A  )

\=\displaystyle=\=

tr​(A⊤​∇A​x2f​(A​x)​A)\displaystyle\mathrm{tr}(A^{\top}\nabla^{2}\_{Ax}f(Ax)A) ( italic_A    ( italic_A  ) italic_A )

\=\displaystyle=\=

tr​(∇A​x2f​(A​x)​A​A⊤)\displaystyle\mathrm{tr}(\nabla^{2}\_{Ax}f(Ax)AA^{\top}) ( ∇  )

\=\displaystyle=\=

tr​(∇A​x2f​(A​x))\=ΔA​x​f​(A​x)\displaystyle\mathrm{tr}(\nabla^{2}\_{Ax}f(Ax))=\Delta\_{Ax}f(Ax) ( ∇    ( italic_A  )

∎

This invariance ††margin: When transforming coordinates, a change of basis can be represented by multiplying by a matrix AAitalic_A. If AAitalic_A is an orthogonal matrix, the transformation does not distort the geometry of the space, that is, distances and angles remain unchanged. This is a necessary condition for the invariance of the Laplacian under rotation. suggests that the behavior of the Laplacian does not depend on the specific orientation of the coordinate system, but rather on the intrinsic geometry of the scalar field itself.

### 3.7 Gradient Descent Optimization in Deep Learning

In Deep Learning, gradients play a central role in training models, that is, in optimizing the parameters of artificial neural networks. Although we have not yet introduced artificial neural networks properly, we can think of them as mapping functions (vector fields) F​(x;w):ℝn→ℝmF(x;w):\mathbb{R}^{n}\to\mathbb{R}^{m}italic_F (  ;  ) :   parametrized by a set of weights (and biases) ww.

#### Loss Functions as Scalar Fields

A loss function can be thought of as a scalar field, ℒ​(w)\mathcal{L}(w)caligraphic_L (  ), where ww represents the model parameters. The loss function assigns a scalar value that indicates how well the model performs. In supervised learning, this is generally computed with respect to some reference ground truth prediction

ℒ​(w)\=ℒ​(F​(x;w),y^),\mathcal{L}(w)=\mathcal{L}(F(x;w),\hat{y}),caligraphic_L (  ) = caligraphic_L ( italic_F (  ;  ) , over^  ) ,

where y^\hat{y}over^  is the ground truth (or the label), F​(x;w)F(x;w)italic_F (  ;  ) represents the artificial neural network output (or prediction), and the loss is, for instance, the mean squared error loss in some regression tasks. Note, however, that the exact setup is task dependent, and more generally we can think of the loss function as returning a scalar based on the artificial neural network parameters ww.

A loss function ℒ​(w)\mathcal{L}(w)caligraphic_L (  ) is a scalar field that assigns a scalar value to each set of parameters ww, quantifying the model’s error. Report issue for preceding element

Just like in vector calculus, we are interested in how ℒ​(w)\mathcal{L}(w)caligraphic_L (  ) changes with respect to small changes in the parameters ww. This is captured by the gradient of ℒ​(w)\mathcal{L}(w)caligraphic_L (  ), denoted as ∇ℒ​(w)\nabla\mathcal{L}(w)∇ caligraphic_L (  ). The gradient tells us the direction and rate at which the loss function increases most rapidly. By adjusting the parameters in the opposite direction of the gradient (steepest descent), we can minimize the loss. ††margin: Loss plot credits to the research paper ’Visualizing the Loss Landscape of Neural Nets’.

![Refer to caption](figures/loss-landscape.png)
Figure 7: Example loss landscape visualization for a neural network.

#### Gradient Descent Optimization

Gradient descent is the most common optimization method used in Deep Learning††margin: Typically stochastic gradient descent (SGD) is mentioned as the optimization technique of choice in most textbooks. However, in contemporary Deep Learning more modern variations of SGD are used, such as the AdamW optimizer. .

Gradient descent leverages the gradient ∇ℒ​(w)\nabla\mathcal{L}(w)∇ caligraphic_L (  ) of the loss function to adjust the parameters of a parametrized model in order to minimize the loss, wt+1\=wt−η​∇ℒ​(wt),w\_{t+1}=w\_{t}-\eta\nabla\mathcal{L}(w\_{t}),  ) , where wtw\_{t}  are the model parameters at iteration (or time step) tt , η\etaitalic_η is the learning rate, a scalar that controls the step size, and ∇ℒ​(wt)\nabla\mathcal{L}(w\_{t})∇ caligraphic_L (   ) is the gradient of the loss function with respect to the parameters at wtw\_{t} . Report issue for preceding element

The gradient guides the model parameters toward a local minimum of the loss. Using this procedure we ‘translate the weights in space’, from an initial random configuration to a suitable location that is able to model the data with low error. That is, the final weight configuration is a able to mimic the patterns present in the data.

The Curse of Optimization. Finding global optima of generic high dimensional functions is NP-hard. Then, one may ask: How can we overcome this curse in optimization? In Geometric Deep Learning we argue that we can try to leverage the underlying low-dimensional structure of the input high-dimensional space. In particular, the geometric domain in which the signal lives provides new notions of regularity that can be exploited for more efficient learning. Report issue for preceding element

#### Backpropagation and the Chain Rule

The gradient of the loss function with respect to the model parameters is typically computed using backpropagation. This method relies on the chain rule of calculus to propagate gradients through the network.

Given a point x∈ℝnx\in\mathbb{R}^{n} ∈  , the composition of two vector fields f:ℝn→ℝmf:\mathbb{R}^{n}\to\mathbb{R}^{m} :   and g:ℝm→ℝpg:\mathbb{R}^{m}\to\mathbb{R}^{p} :   is written as g∘f​(x)\=g​(f​(x)),g\circ f(x)=g(f(x)), ∘  (  ) =  (  (  ) ) , which represents the transformation of xx through both functions ff and gg.

The chain rule states that given two vector fields f:ℝn→ℝmf:\mathbb{R}^{n}\to\mathbb{R}^{m} :   and g:ℝm→ℝpg:\mathbb{R}^{m}\to\mathbb{R}^{p} :   and their respective Jacobian matrices JfJ\_{f}italic_J  and JgJ\_{g}italic_J , the derivative of their composition is given by the matrix product: dd​x​(g∘f​(x))\=Jg​(f​(x))⋅Jf​(x)\frac{d}{dx}\left(g\circ f(x)\right)=J\_{g}(f(x))\cdot J\_{f}(x)divide  (  ∘  (  ) ) = italic_J  (  ) Report issue for preceding element

Artificial neural networks are composed of multiple layers, which can be understood in terms of function composition. The gradient of the loss function ℒ\mathcal{L}caligraphic_L with respect to each layer’s weights is computed iteratively:

∇w(l)ℒ\=JL​(a(L))⋅Ja(L)​(a(L−1))⋅…⋅Ja(l+1)​(w(l))\nabla\_{w^{(l)}}\mathcal{L}=J\_{L}(a^{(L)})\cdot J\_{a^{(L)}}(a^{(L-1)})\cdot...\cdot J\_{a^{(l+1)}}(w^{(l)})∇ start_POSTSUBSCRIPT   )

where a(l)a^{(l)}  is the activation (the output of an intermediate transformation) of the ll\-th layer.

The Jacobian-based representation can handle cases where activations or transformations are vector-valued, which is typically the case in Deep Learning (technically we work with tensors which becomes even more complex). In the scalar or element-wise gradient context, we can rewrite the expression above as

∇w(l)ℒ\=∂ℒ∂a(L)⋅∂a(L)∂a(L−1)⋅⋯⋅∂a(l+1)∂w(l),\nabla\_{w^{(l)}}\mathcal{L}=\frac{

tial\mathcal{L}}{

tial a^{(L)}}\cdot\frac{

tial a^{(L)}}{

tial a^{(L-1)}}\cdot\dots\cdot\frac{

tial a^{(l+1)}}{

tial w^{(l)}},∇ start_POSTSUBSCRIPT   end_ARG ,

which may be more accessible to readers less familiar with matrix calculus.

Backpropagation uses the chain rule to compute gradients of the loss function with respect to each layer’s weights, which are then used to update the weights of artificial neural networks in an iterative fashion. Report issue for preceding element

Vector Calculus and the Laplacian in Geometric Deep Learning. Beyond other use cases of the gradient such as in gradient descent optimization, in Geometric Deep Learning, the Laplacian is often used to understand the smoothness of functions defined on graphs or manifolds. These structures, such as the vertices and edges of a graph, or the points on a surface, require modifications of traditional calculus tools to account for the inherent irregularities of the data. Hence, vector calculus is not only foundational in classical analysis but are also key components in the development of algorithms for learning over non-Euclidean data. Report issue for preceding element

## 4 Topological Foundations and Differential Geometry

As we have seen so far, normed spaces add the ability to measure the length or magnitude of vectors. Metric spaces then enter the picture, with their additional structure allowing us to measure how far apart elements are, just as we measure distances in everyday space. And finally, inner products complete this geometric toolkit by defining angles between elements, enabling us to determine when vectors are perpendicular or parallel, for instance.

Students are often first introduced to this geometric foundations rather than topology \[[9](https://arxiv.org/html/2508.02723v1#bib.bib9), [10](https://arxiv.org/html/2508.02723v1#bib.bib10)\], because the former deal with tangible aspects of space, which are familiar in our everyday lives. However, this focus on geometry can sometimes overshadow topology, a more abstract field that underpins many concepts in geometry and other areas of mathematics. In essence, topology is concerned with connectivity and studies properties of space that remain unchanged under continuous deformations, such as stretching and bending. Topological spaces can later be augmented with additional structures to measure geometric quantities, such as a metric.

A solid understanding of topology provides deeper insights into the nature of space and is fundamental for grasping more advanced mathematical and scientific concepts. Therefore, in this section, we take a step back to introduce the reader to basic concepts in topology, with a particular focus on manifolds, which are central to many Geometric Deep Learning generalizations of traditional neural network models. We then complement this discussion by presenting key ideas from differential \[[11](https://arxiv.org/html/2508.02723v1#bib.bib11)\] and Riemannian geometry \[[12](https://arxiv.org/html/2508.02723v1#bib.bib12)\]. The text is kept succinct, with the goal of familiarizing the reader with the main concepts without going into excessive depth.††margin: Differential geometry and Riemannian geometry are closely related, but they are not the same. Differential geometry is the general study of geometry using calculus and linear algebra. It deals with smooth manifolds and smooth maps between them. On the other hand, Riemannian geometry is a special case of differential geometry where the manifold is equipped with a Riemannian metric.

### 4.1 A Brief Introduction to Topology

#### Historical Context

The word topology was coined by Johann Benedict Listing, a German mathematician, in his 1847 book Vorstudien zur Topologie, although he used the word as early as 1836 in correspondence. The etymology of the word stems from the Greek ‘topos’, meaning ‘location’ or ‘place’, and the suffix ‘-logy’ for ‘study of’. Topology was initially conceived as a type of geometry that focused on properties preserved under much more flexible transformations than those allowed in Euclidean or other specific geometries. It is often called ‘rubber-sheet geometry’ to illustrate this idea: one can stretch and deform the ‘rubber sheet’, but you cannot tear it or glue parts together. The French Henri Poincaré, with his Analysis Situs series of papers starting in 1895, is largely credited with establishing topology as a coherent and independent field. Indeed, nowadays geometry and topology are considered two separate branches of mathematics, concerned with measurement and connectedness, respectively, as we have repeatedly emphasized in this text.

#### Sets as a Collection of Objects with no Connectedness

As previously discussed in Section [1](https://arxiv.org/html/2508.02723v1#S1 "1 Algebraic Structures and Mathematics before Numbers ‣ Mathematical Foundations of Geometric Deep Learning"), a set is a collection of distinct elements and has no structure beyond membership. For example, the set of points in the plane ℝ2\mathbb{R}^{2}  can be written using the set builder notation as follows:

ℝ2\={(x,y)∣x,y∈ℝ}.\mathbb{R}^{2}=\{(x,y)\mid x,y\in\mathbb{R}\}.  = { (  ,  ) ∣  ,  ∈  } .

This is simply a collection of points. Thus, there is no notion of ‘closeness’ or ‘nearness’ between points: the points are not connected in any way. For instance, the point (0,0)(0,0)( 0 , 0 ) is neither closer to (0,1)(0,1)( 0 , 1 ) nor to (10,10)(10,10)( 10 , 10 ) because the elements of the set are considered unordered and unrelated beyond membership.

When we introduce a structure to this set, such as connectedness or topology, we begin to impose rules on how the points are related. For example, we can define which sets of points are considered ‘close’ to each other or which subsets of ℝ2\mathbb{R}^{2}  are ‘open’. This, in turn, leads to a concept of continuous connection among points.

#### Open Intervals and Open Sets

In the context of the real line ℝ\mathbb{R}, an open interval is a set of points that does not include its boundary points. For example, the open interval (a,b)(a,b)(  ,  ) is the set of points xx such that:

a<x<b.a<x<b. <  <  .

This interval contains all points between aa and bb, but does not include aa and bb themselves.

In a more general setting, a set UUitalic_U is called open if it contains a ‘neighborhood’ around each of its points. This means that for every point x∈Ux\in U ∈ italic_U, there is a small region around xx that is entirely contained within UUitalic_U.

![Refer to caption](figures/openset_yes_no.png)
Figure 8: Point x1x*{1}  has an open neighborhood fully contained in UUitalic_U, while point x2x*{2} , located on the boundary, does not.

In the context of metric spaces, this is formalized as follows:

Let (X,d)(X,d)( italic_X ,  ) be a metric space, where dd is the distance function. A subset U⊆XU\subseteq Xitalic_U ⊆ italic_X is open if, for every point x∈Ux\in U ∈ italic_U, there exists a radius r\>0r>0 > 0 such that the open ball B​(x,r)\={y∈X∣d​(x,y)<r}B(x,r)=\{y\in X\mid d(x,y)<r\}italic_B (  ,  ) = {  ∈ italic_X ∣  (  ,  ) <  } is entirely contained within UUitalic_U. Report issue for preceding element

Although the above definition is perhaps intuitive, it relies on a distance function. Actually, open sets can also be defined without relying on a metric space, and purely in terms of set theory, as we will see next.

#### Topological Spaces

The concept of open sets can be generalized in the context of topological spaces. A topological space is defined as a set XXitalic_X together with a collection of subsets 𝒯\mathcal{T}caligraphic_T (called open sets) that satisfy certain properties. These properties ensure that the notion of ‘openness’ is well-behaved.

Let XXitalic_X be a set, and 𝒯⊆𝒫​(X)\mathcal{T}\subseteq\mathcal{P}(X)caligraphic_T ⊆ caligraphic_P ( italic_X ) the power set of XXitalic_X. Then 𝒯\mathcal{T}caligraphic_T is a topology on XXitalic_X if:††margin: The symbols A​\cupBA\cupBitalic_A and A​\capBA\capBitalic_A refer specifically to the union and intersection of two sets, AAitalic_A and BBitalic_B. In contrast, ⋃α​\inAUα\bigcup\_{\alpha\inA}U\_{\alpha}⋃  and ⋂α​\inAUα\bigcap\_{\alpha\inA}U\_{\alpha}⋂  are more general notations used to describe the union or intersection of a collection of sets {Uα}α​\inA\{U\_{\alpha}\}\_{\alpha\inA}{ italic_U  } , where the index α\alphaitalic_α ranges over some set AAitalic_A. Also, note that the notation in the definition differs to highlight the axioms: any union ⋃α​\inA\bigcup\_{\alpha\inA}⋃  of open sets is open, but only finite intersections ⋂i\=1n\bigcap\_{i=1}^{n}⋂   are required to be open. The indices reflect this arbitrary vs. finite condition. • ∅,X∈𝒯\emptyset,X\in\mathcal{T}∅ , italic_X ∈ caligraphic_T, • ⋃α∈AUα∈𝒯, for any collection ​{Uα}α∈A⊆𝒯\bigcup\_{\alpha\in A}U\_{\alpha}\in\mathcal{T},\text{ for any collection }\{U\_{\alpha}\}\_{\alpha\in A}\subseteq\mathcal{T}⋃  }  ⊆ caligraphic_T, • ⋂i\=1nUi∈𝒯, for any finite collection ​{Ui}i\=1n⊆𝒯\bigcap\_{i=1}^{n}U\_{i}\in\mathcal{T},\text{ for any finite collection }\{U\_{i}\}\_{i=1}^{n}\subseteq\mathcal{T}⋂  }   ⊆ caligraphic_T. Report issue for preceding element

These conditions specify the following: the empty set and the entire set XXitalic_X must be included in 𝒯\mathcal{T}caligraphic_T, arbitrary unions of open sets must be open, and finite intersections of open sets must be open. Note that 𝒯\mathcal{T}caligraphic_T is a set of subsets.

The pair (X,𝒯)(X,\mathcal{T})( italic_X , caligraphic_T ) is called a topological space. Elements of XXitalic_X are referred to as points, and elements of 𝒯\mathcal{T}caligraphic_T are called open sets. Report issue for preceding element

A subset U⊆XU\subseteq Xitalic_U ⊆ italic_X is called open if U∈𝒯U\in\mathcal{T}italic_U ∈ caligraphic_T. Report issue for preceding element

Open sets are a generalization of intervals in ℝ\mathbb{R}, which are open in the sense that they do not include their boundary points. Metric spaces are specific examples of topological spaces, and, similarly, open balls in a metric space are examples of open sets.

#### Examples of Topological Spaces

- •

  Euclidean Topology: For X\=ℝnX=\mathbb{R}^{n}italic_X =  , the standard topology is generated by open balls. An open ball in ℝn\mathbb{R}^{n}  centered at x∈ℝnx\in\mathbb{R}^{n} ∈   with radius r\>0r>0 > 0 is defined as

  Report issue for preceding element

  B​(x,r)\={y∈ℝn:‖x−y‖<r}.B(x,r)=\{y\in\mathbb{R}^{n}:\|x-y\|<r\}.italic_B (  ,  ) = {  ∈   : ∥  -  ∥ <  } .

  The topology 𝒯\mathcal{T}caligraphic_T in this case is the collection of all open sets that can be expressed as arbitrary unions of open balls. That is,

  Report issue for preceding element

  𝒯\={U⊆ℝn:U\=⋃α∈AB​(xα,rα)​ for some index set ​A},\mathcal{T}=\left\{U\subseteq\mathbb{R}^{n}:U=\bigcup\_{\alpha\in A}B(x\_{\alpha},r\_{\alpha})\text{ for some index set }A\right\},caligraphic_T = { italic_U ⊆   : italic_U = ⋃  ) for some index set italic_A } ,

  where each B​(xα,rα)\=BαB(x\_{\alpha},r\_{\alpha})=B\_{\alpha}italic_B (   is an open ball.

  Report issue for preceding element

  ![Refer to caption](figures/euclidean_topologicalspace.png)
  Figure 9: Illustration of an open set UUitalic*U defined as the union of open balls, U=B1∪B2∪B2∪B3∪B4∪B5∪…U=B*{1}\cup B*{2}\cup B*{2}\cup B*{3}\cup B*{4}\cup B*{5}\cup\dotsitalic_U = italic_B  ∪ …. Each dashed circle represents an open ball BαB*{\alpha}italic*B , demonstrating how open sets in Euclidean topology are constructed.

  Report issue for preceding element

- •

  Discrete Topology: In the discrete topology, every subset of XXitalic_X is open. Therefore, for any set XXitalic_X, the topology 𝒯\mathcal{T}caligraphic_T is the power set of XXitalic_X, i.e.,

  Report issue for preceding element

  𝒯\=𝒫​(X)\={U⊆X:U​ is a subset of ​X}.\mathcal{T}=\mathcal{P}(X)=\{U\subseteq X:U\text{ is a subset of }X\}.caligraphic_T = caligraphic_P ( italic_X ) = { italic_U ⊆ italic_X : italic_U is a subset of italic_X } .

- •

  Trivial Topology: In the trivial topology, only the empty set ∅\emptyset∅ and the entire set XXitalic_X are open. Therefore, the topology 𝒯\mathcal{T}caligraphic_T is

  Report issue for preceding element

  𝒯\={∅,X}.\mathcal{T}=\{\emptyset,X\}.caligraphic_T = { ∅ , italic_X } .

The discrete topology is the finest topology because every subset of the space is an open set, making it the topology with the most open sets. In contrast, the trivial topology is the coarsest possible topology, as it contains the fewest open sets.

### 4.2 Topological Equivalences

Topology studies properties of spaces that are invariant under any continuous deformation. Report issue for preceding element

#### Continuity

Continuous maps between topological spaces do not ‘break’ the space, meaning that small changes in the input correspond to small changes in the output, without any sudden jumps or gaps. In other words, the map allows the space to be deformed without tearing it and it preserves the structure of the space, enabling smooth transitions from one point to another. ††margin: This definition of continuity does not require the notion of limits, as in the classical sense, but instead relies purely on the topological structure of the spaces involved.

A map F:X→YF:X\to Yitalic_F : italic_X → italic_Y between topological spaces is continuous if for every open set U∈𝒯YU\in\mathcal{T}\_{Y}italic_U ∈ caligraphic_T , the preimage F−1​(U)F^{-1}(U)italic_F  ( italic_U ) is an open set in XXitalic_X, i.e., F−1​(U)∈𝒯XF^{-1}(U)\in\mathcal{T}\_{X}italic_F  ( italic_U ) ∈ caligraphic_T . Report issue for preceding element

#### Homeomorphisms and Homotopy

A homeomorphism is a special type of continuous map that has a continuous inverse. ††margin: It is quite common to confuse homeomorphisms with homomorphisms. A homomorphism is a structure-preserving map between two algebraic structures of the same type, as we saw earlier for groups. In contrast, a homeomorphism is a bijective map between two topological spaces that is continuous and has a continuous inverse. In short, homomorphisms pertain to algebra, while homeomorphisms arise in the context of topology.

A map F:X→YF:X\to Yitalic_F : italic_X → italic_Y is a homeomorphism if it is bijective, continuous, and its inverse F−1:Y→XF^{-1}:Y\to Xitalic_F  : italic_Y → italic_X is also continuous. Report issue for preceding element

When such a map between two topological spaces exists, we say that XXitalic_X and YYitalic_Y are homeomorphic, meaning they are topologically equivalent. For example, the surface of a sphere and that of a cube are homeomorphic, as one can be continuously deformed into the other without tearing or gluing. Note that a homeomorphism is a strong equivalence and denotes that there is a one-to-one correspondence between points in the spaces.

![Refer to caption](figures/cube_to_sphere_surface.png)
Figure 10: The cube and the sphere are homeomorphic: they are both simply connected (no holes) and can be continuously deformed into each other.

On the other hand, two spaces are homotopic (or homotopy equivalent) if one can be continuously deformed into the other through a process called homotopy. This is a weaker equivalence than homeomorphism since it allows for more general deformations such as collapsing or stretching parts of the space.††margin: The collapsing of a circle to a point is an example of a homotopy, not a homeomorphism, precisely because the inverse operation is not continuous. While the forward map (circle to point) can be considered continuous, if one were to start from a single point and try to map it back to a circle, it would require ‘expanding’ that single point into an entire circle. A single point has dimension 0, while a circle has dimension 1. A continuous inverse would imply that a point is topologically equivalent to a circle, which is not true. For example, a circle and a point are homotopy equivalent because the circle can be continuously shrunk to a single point.

![Refer to caption](figures/circle_to_point.png)
Figure 11: Visualization of circle shrinking into a point. The map between them is surjective, but not injective since all points on the circle are mapped (or collapsed) into the same single point.

Discrete geometric representations, such as meshes or graphs, can also approximate topological features like homotopy, allowing us to reason about how shapes deform, connect, or contain loops, even in combinatorial settings. We will look at discrete representations later, in Section [7](https://arxiv.org/html/2508.02723v1#S7 "7 Graph Theory ‣ Mathematical Foundations of Geometric Deep Learning").

††margin: A polyhedron (plural: polyhedra) is a three-dimensional solid whose boundary consists of polygons. ![[Uncaptioned image]](figures/Platonic_Solids.png) For instance, the Platonic solids displayed above are a special, highly symmetric class of convex polyhedra characterized by faces that are all congruent regular polygons, with the same number of faces meeting at each vertex. All of them have an Euler characteristic of 2. Interestingly, they are named ‘Platonic’ after the ancient Greek philosopher Plato (despite also being studied by Theaetetus and Euclid), due to his role in associating them with the classical elements of fire, earth, air, and water in his cosmological theories.

#### Euler Characteristic

The Euler characteristic is a topological invariant that assigns a numerical value to a topological space. It is defined for a variety of spaces, both continuous (like surfaces) and discrete (like polyhedra), and remains unchanged under homeomorphisms (but not necessarily under homotopy equivalence). That is, if two spaces are topologically equivalent, they share the same Euler characteristic, regardless of differences in their geometric shape or size. For a closed surface (compact surfaces without boundary), the Euler characteristic can be computed using the genus, which represents the number of ‘holes’ (or ‘handles’) in the surface. For example, a sphere and a cube both have an Euler characteristic of 2, even though their geometric structures are quite different. On the other hand, a sphere and a point are homotopy equivalent (in the weak sense), but their Euler characteristics are different (2 and 1, respectively). While this text does not delve into the detailed calculation of the Euler characteristic (often done via homology), it is worth highlighting that there are methods for quantifying the equivalence of spaces based solely on their connectivity, entirely disregarding their geometric details.

### 4.3 Manifolds and Differential Geometry

Manifolds are mathematical objects used to describe and generalize to spaces that may not have a simple, flat, Euclidean structure. Indeed, many natural phenomena occur in spaces (or domains) that are curved.

#### Non-Euclidean Geometry and Historical Background

Report issue for preceding element ††margin: Euclid’s monopoly came to an end in the 19th century, with a remarkable burst of creativity that made geometry arguably the most exciting field of mathematics, primarily through the work of pioneers like Gauss, Bolyai, Lobachevsky, Riemann, and Beltrami. However, one of the first attempts at questioning Euclid’s fifth postulates dates back to the Italian mathematician Girolamo Saccheri (1667-1733) in his work Euclides ab omni naevo vindicatus. ![[Uncaptioned image]](figures/euclid.png)

Since Euclid of Alexandria (c. 300 BC) stated the fifth postulate—later renamed the parallel postulate or axiom of parallels—in his famous work Elements, it was accepted for two thousand years that through a point exterior to a given line, one and only one parallel line could be drawn, and that no logically consistent alternative to his geometric framework could exist. After numerous failed attempts at deriving this postulate from the previous four, mathematicians started exploring geometries for which the fifth postulate did not hold. They found that it was possible to construct logically consistent frameworks that did not satisfy the postulate, giving rise to, for instance, elliptical (or spherical; the differences are subtle and outside the scope of this text) and hyperbolic geometry. In these frameworks, our common notion of a line is replaced by the shortest path between two points while remaining on the surface of the space at hand: the geodesic. The aforementioned geometries are characterized by their geodesic dispersion: in elliptical geometry, initially parallel geodesics eventually converge, whereas in hyperbolic geometry, they diverge exponentially, unlike in Euclidean geometry where they remain equidistant (the space is flat).

But these were not the only examples. For instance, projective geometry, which formalizes the principles of perspective projection, notably treating parallel lines as meeting at ‘points at infinity’ and focusing on properties invariant under projection, was inspired by the arts.††margin: Renaissance artists, such as the Florentine Leonardo da Vinci and the German Albrecht Dürer, sought techniques to represent the three-dimensional world realistically on a two-dimensional surface like the canvas. Dürer, in particular, not only produced a large body of paintings but also authored written treatises on geometry related to this challenge. Below we display da Vinci’s The Last Supper, a classic example. ![[Uncaptioned image]](figures/The_Last_Supper_-_Leonardo_Da_Vinci-5.jpg) The emergence of these varied and equally consistent geometric systems prompted a fundamental question: what truly defines ‘geometry’? It was not until Felix Klein (aided by insights from his discussions with Sophus Lie) proposed a unifying framework in his Erlangen Program (1872) that geometry came to be understood not merely by its objects (points, lines) but as the study of properties that remain invariant under a specified group of transformations.

![Refer to caption](figures/manifold_geodesic.png)
Figure 12: The geodesic is the shortest path between the two points, while staying on the curved 2-dimensional surface: it is not a straight line.

#### Topological Manifolds

Report issue for preceding element ††margin: Note that a ‘basic’ manifold (topological or even smooth) does not inherently come equipped with a way to measure distances, angles, or curvature. Here, we are primarily concerned about the structure and connectivity of the space and its local resemblance to Euclidean (flat) space. On the other hand, geometry is about the study of measurement and properties on the space.

To understand manifolds, we begin with the simplest notion of a topological manifold, which captures the idea of spaces that locally resemble Euclidean space. From there, we can progressively add more structure to these spaces, eventually obtaining smooth manifolds, which allow for calculus and differential geometry, and Riemannian manifolds, which introduce a way to measure distances and angles.

A manifold is a topological space that locally resembles Euclidean space.

A topological space ℳ\mathcal{M}caligraphic_M is an nn\-dimensional (topological) manifold if for every point p∈ℳp\in\mathcal{M} ∈ caligraphic_M, there exists an open neighborhood U⊆ℳU\subseteq\mathcal{M}italic_U ⊆ caligraphic_M and a homeomorphism φ:U→ℝn\varphi:U\to\mathbb{R}^{n}italic_φ : italic_U →  . Report issue for preceding element

φα\varphi\_{\alpha}italic_φ φα−1\varphi^{-1}\_{\alpha}italic_φ  φβ−1\varphi^{-1}\_{\beta}italic_φ  φβ\varphi\_{\beta}italic_φ ℳ\mathcal{M}caligraphic_MUαU\_{\alpha}italic_U UβU\_{\beta}italic_U φα​(Uα)\varphi\_{\alpha}(U\_{\alpha})italic_φ  )ℝn\mathbb{R}^{n} ψα​β\psi\_{\alpha\beta}italic_ψ φβ​(Uβ)\varphi\_{\beta}(U\_{\beta})italic_φ  )ℝn\mathbb{R}^{n} Report issue for preceding element

Figure 13: Illustration of a manifold ℳ\mathcal{M}caligraphic_M with overlapping open subsets UαU\_{\alpha}italic_U  and UβU\_{\beta}italic_U . Each has a corresponding chart, represented by a homeomorphism φα\varphi\_{\alpha}italic_φ  and φβ\varphi\_{\beta}italic_φ , mapping it onto an open subset of the Euclidean space, ℝn\mathbb{R}^{n} . The transition map ψα​β\=φβ∘φα−1\psi\_{\alpha\beta}=\varphi\_{\beta}\circ\varphi\_{\alpha}^{-1}italic_ψ   describes how these charts relate to each other on their overlapping regions.

Report issue for preceding element††margin: In relativity, the manifold used to model the universe is a 4-dimensional Lorentzian manifold, which is commonly referred to as spacetime.

Manifolds can be classified based on their dimensionality, such as curves (1-dimensional manifolds), surfaces (2-dimensional manifolds), and higher-dimensional manifolds. They are the central objects in differential geometry and are fundamental in the study of geometry and physics, particularly in general relativity.

The local homeomorphisms between a manifold and Euclidean space are called charts. A collection of charts that cover the entire manifold is called an atlas.††margin: The term ‘atlas’ in mathematics draws an analogy to a collection of maps used in geography. Just as a geographic atlas contains individual maps that collectively describe different regions of the Earth’s surface, an atlas on a manifold consists of charts that collectively describe the manifold’s structure. ![[Uncaptioned image]](figures/geographic_atlas.png)

An atlas for a manifold ℳ\mathcal{M}caligraphic_M is a collection of charts {(Uα,φα)}\{(U\_{\alpha},\varphi\_{\alpha})\}{ ( italic_U  ) }, where UαU\_{\alpha}italic_U  is an open subset of ℳ\mathcal{M}caligraphic_M and φα:Uα→ℝn\varphi\_{\alpha}:U\_{\alpha}\to\mathbb{R}^{n}italic_φ  →   is a homeomorphism. The charts must be compatible, meaning that the transition maps ψα​β\=φβ∘φα−1\psi\_{\alpha\beta}=\varphi\_{\beta}\circ\varphi\_{\alpha}^{-1}italic_ψ   are homeomorphisms on their domains of overlap. Report issue for preceding element

#### Smooth Manifolds

A smooth manifold is a topological manifold equipped with a smooth structure. This means that, in addition to the local homeomorphisms to Euclidean space, the transition maps between overlapping neighborhoods are differentiable. More formally:

A topological space ℳ\mathcal{M}caligraphic_M is an nn\-dimensional smooth manifold if for every pair of points p,q∈ℳp,q\in\mathcal{M} ,  ∈ caligraphic_M, there exist open neighborhoods Uα⊆MU\_{\alpha}\subseteq Mitalic_U  ⊆ italic_M around pp and Uβ⊆ℳU\_{\beta}\subseteq\mathcal{M}italic_U  ⊆ caligraphic_M around qq such that the transition map between the homeomorphisms φα:Uα→ℝn\varphi\_{\alpha}:U\_{\alpha}\to\mathbb{R}^{n}italic_φ  →   and φβ:Uβ→ℝn\varphi\_{\beta}:U\_{\beta}\to\mathbb{R}^{n}italic_φ  →   is a smooth (infinitely differentiable) map. Report issue for preceding element

††margin: Lie groups are both groups and (smooth) manifolds.

The smooth structure of these manifolds allows for the definition of smooth functions, smooth curves, and other objects in differential geometry, making them central to the study of calculus on manifolds.

#### Diffeomorphisms

Diffeomorphisms allow for the transfer of geometric and differential properties between manifolds that share similar local structures.

A map between two manifolds φ:ℳ→𝒩\varphi:\mathcal{M}\to\mathcal{N}italic_φ : caligraphic_M → caligraphic_N is a diffeomorphism if: φ\varphiitalic_φ is smooth (infinitely differentiable), φ\varphiitalic_φ is bijective, and φ−1:𝒩→ℳ\varphi^{-1}:\mathcal{N}\to\mathcal{M}italic_φ  : caligraphic_N → caligraphic_M is also smooth. Report issue for preceding element

While both homeomorphisms and diffeomorphisms are bijections that preserve certain structures, homeomorphisms preserve topological properties (such as continuity and connectedness), whereas diffeomorphisms preserve smooth (differentiable) structures.

#### Tangent Spaces and Bundles

The tangent space is a key concept for understanding the local geometry of the manifold.

††margin: To project points from the tangent space to the manifold and back we use exponential and logarithmic maps. Given a smooth manifold ℳ\mathcal{M}caligraphic_M and a point p∈ℳp\in\mathcal{M} ∈ caligraphic_M, the tangent space at pp, denoted Tp​ℳT\_{p}\mathcal{M}italic_T  caligraphic_M, is a vector space that represents the possible directions in which one can move away from pp. Formally, it is the space of equivalence classes of smooth curves passing through pp. Report issue for preceding element

††margin: ⨆\bigsqcup⨆ refers to the disjoint union, whereas ⋃\bigcup⋃ is used to denote the regular union. The former preserves the identity of the original sets, treating overlapping elements as distinct. On the other hand, the latter merges sets, discarding duplicate elements. In the context of the definition of tangent bundles, ⨆\bigsqcup⨆ is used to emphasize that the tangent spaces at different points of the manifold are distinct and should be treated as separate entities, even if they may have overlapping elements.

The tangent bundle of a smooth manifold ℳ\mathcal{M}caligraphic_M, denoted T​ℳT\mathcal{M}italic_T caligraphic_M, is the disjoint union of all tangent spaces of ℳ\mathcal{M}caligraphic_M: T​ℳ\=⨆p∈ℳTp​ℳ.T\mathcal{M}=\bigsqcup\_{p\in\mathcal{M}}T\_{p}\mathcal{M}.italic_T caligraphic_M = ⨆  caligraphic_M . Each point (p,v)∈T​ℳ(p,v)\in T\mathcal{M}(  ,  ) ∈ italic_T caligraphic_M consists of a point p∈ℳp\in\mathcal{M} ∈ caligraphic_M and a tangent vector v∈Tp​ℳv\in T\_{p}\mathcal{M} ∈ italic_T  caligraphic_M. Report issue for preceding element

![Refer to caption](x1.png)
Figure 14: Illustration of the tangent space Tp​ℳT\_{p}\mathcal{M}italic_T  caligraphic_M at a point pp on the manifold ℳ\mathcal{M}caligraphic_M. The tangent space is a flat, vector-space approximation of the manifold at pp.

Report issue for preceding element††margin: “Manifolds in which, as in the plane and in space, the line-element may be reduced to the form \sumdx2\sqrt{\sumdx^{2}}square-root , are therefore only a particular case of the manifolds to be here investigated; they require a special name, and therefore these manifolds in which the square of the line-element may be expressed as the sum of the squares of complete differentials I will call flat.” – Bernhard Riemann, 1856

#### Riemannian Manifolds

A Riemannian manifold is a smooth manifold equipped with a Riemannian metric, which is a smoothly varying inner product on the tangent spaces of the manifold. Formally:

††margin: The sphere in particular is both a homogeneous manifold and has constant curvature. Without getting into formal definitions, a homogeneous manifold is a manifold with a high degree of symmetry, where the manifold looks the same at every point. A manifold is a constant curvature manifold if its curvature (a measure of how the manifold bends in space) is the same at every point. Note that, more generally, manifolds can have variable curvature and very intricate structures, and that homogeneous manifolds with constant curvature, as well as products thereof, are simply easier-to-study special cases. See below an example of variable-curvature Riemannian geometry on manifolds. ![[Uncaptioned image]](figures/variable_curvature.png) A smooth manifold ℳ\mathcal{M}caligraphic_M is a Riemannian manifold if it is equipped with a Riemannian metric, which is a smooth assignment of an inner product on the tangent space at each point p∈ℳp\in\mathcal{M} ∈ caligraphic_M, i.e., a map gp:Tp​ℳ×Tp​ℳ→ℝg\_{p}:T\_{p}\mathcal{M}\times T\_{p}\mathcal{M}\to\mathbb{R}  caligraphic_M →  that is smooth in pp, where Tp​ℳT\_{p}\mathcal{M}italic_T  caligraphic_M is the tangent space at pp. We typically denote the Riemannian manifold as a tuple (ℳ,g).(\mathcal{M},g).( caligraphic_M ,  ) . Report issue for preceding element

![Refer to caption](figures/sphere2.png)
Figure 15: The sphere is an example of a Riemannian manifold, locally resembling Euclidean space. Indeed, when walking on the surface of the Earth, it appears flat. We can define functions on this manifold to characterize various phenomena, such as the distribution of atmospheric pressure or the velocity of the wind.

The Riemannian metric enables the measurement of distances between points and the definition of geodesics.

A geodesic on a Riemannian manifold is a curve which locally minimizes the distance between points. Report issue for preceding element

In our day-to-day, we often say that ‘the shortest path between two points is always a straight line’, and this is true for flat Euclidean space. However, in more general spaces, geodesics may not be straight lines. For example, when connecting two points on the surface of a sphere, the shortest path is an arc of a great circle.††margin: Here, we only aim to provide the intuitive idea behind the concept of geodesics. For a more mathematically rigorous understanding of geodesics one would need to introduce the geodesic equation, which is derived from the principle of least action applied to the length of a curve. This relies on presenting concepts such as metric tensors, Euler-Lagrange equations, and Christoffel symbols, which we omit for simplicity.

#### Exponential and Logarithmic Maps

For any point pp on a Riemannian manifold (ℳ,g)(\mathcal{M},g)( caligraphic_M ,  ), as previously discussed, the tangent space Tp​ℳT\_{p}\mathcal{M}italic_T  caligraphic_M is a vector space that locally approximates the manifold. A fundamental tool in differential geometry is the exponential map at pp:

The exponential map, expp:Tp​ℳ→ℳ,\exp\_{p}:T\_{p}\mathcal{M}\to\mathcal{M},  caligraphic_M → caligraphic_M , takes a tangent vector v∈Tp​ℳv\in T\_{p}\mathcal{M} ∈ italic_T  caligraphic_M and returns a point on the manifold reached by following the unique geodesic starting at pp in the direction vv for a distance equal to the norm ‖v‖\|v\|∥  ∥. Report issue for preceding element

![Refer to caption](x2.png)
Figure 16: Illustration of the exponential map expp\exp*{p} , mapping a tangent vector vv at point pp in the tangent space Tp​ℳT*{p}\mathcal{M}italic*T  caligraphic_M to a point expp⁡(v)\exp*{p}(v)  (  ) on the manifold ℳ\mathcal{M}caligraphic_M. This mapping is realized by following the geodesic starting at pp in the direction of vv for a distance equal to ‖v‖\|v\|∥  ∥.

Next, we provide an example. Let p\=(0,0,1)∈S2⊂ℝ3p=(0,0,1)\in S^{2}\subset\mathbb{R}^{3} = ( 0 , 0 , 1 ) ∈ italic_S  be the north pole of the unit sphere, and let v\=(ϵ,0,0)∈Tp​S2v=(\epsilon,0,0)\in T\_{p}S^{2} = ( italic_ϵ , 0 , 0 ) ∈ italic_T  italic_S  be a small tangent vector. Note that Tp​S2T\_{p}S^{2}italic_T  italic_S  consists of all vectors in ℝ3\mathbb{R}^{3}  that are perpendicular to pp:

Tp​S2\={v∈ℝ3∣v⋅p\=0}\={(x,y,0)∈ℝ3}.T\_{p}S^{2}=\{v\in\mathbb{R}^{3}\mid v\cdot p=0\}=\{(x,y,0)\in\mathbb{R}^{3}\}.italic_T  italic_S  ∣  ⋅  = 0 } = { (  ,  , 0 ) ∈   } .

Since geodesics on S2S^{2}italic_S  are great circles, the geodesic starting at pp in the direction of vv can be expressed as: γ​(t)\=cos⁡(t)​p+sin⁡(t)​v^,\gamma(t)=\cos(t)\,p+\sin(t)\,\hat{v},italic_γ (  ) =  (  )  +  (  ) over^  , where v^\=v‖v‖\=(1,0,0)\hat{v}=\frac{v}{\|v\|}=(1,0,0)over^  = ( 1 , 0 , 0 ). Evaluating this at t\=‖v‖\=ϵt=\|v\|=\epsilon = ∥  ∥ = italic_ϵ gives:

expp⁡(v)\=cos⁡(ϵ)​(0,0,1)+sin⁡(ϵ)​(1,0,0)\=(sin⁡(ϵ),0,cos⁡(ϵ)).\exp\_{p}(v)=\cos(\epsilon)\,(0,0,1)+\sin(\epsilon)\,(1,0,0)=(\sin(\epsilon),0,\cos(\epsilon)).  (  ) =  ( italic_ϵ ) ( 0 , 0 , 1 ) +  ( italic_ϵ ) ( 1 , 0 , 0 ) = (  ( italic_ϵ ) , 0 ,  ( italic_ϵ ) ) .

For small ϵ\epsilonitalic_ϵ, this is approximately:

expp⁡(v)≈(ϵ,0,1−ϵ22),\exp\_{p}(v)\approx(\epsilon,0,1-\tfrac{\epsilon^{2}}{2}),  (  ) ≈ ( italic_ϵ , 0 , 1 - divide  ) ,

which captures the fact that the sphere is locally well-approximated by a flat plane.

The logarithmic map, logp:ℳ→Tp​ℳ,\log\_{p}:\mathcal{M}\to T\_{p}\mathcal{M},  caligraphic_M , is the local inverse of the exponential map. It maps a point q∈ℳq\in\mathcal{M} ∈ caligraphic_M (sufficiently close to pp) to the tangent vector v∈Tp​ℳv\in T\_{p}\mathcal{M} ∈ italic_T  caligraphic_M such that expp⁡(v)\=q\exp\_{p}(v)=q  (  ) = . In other words, it returns the initial velocity of the geodesic starting at pp and reaching qq. Report issue for preceding element

These tools allow us to conduct operation in the locally flat tangent space and to project point from and back to it.

Embedding Latent Representations into non-Euclidean Manifolds using the Exponential Map.††margin: The Poincaré ball is a model of hyperbolic geometry represented as a unit ball, where distances grow infinitely as one approaches the boundary. In 2D we often refer to it as the Poincaré disk instead. For instance, in the context of embedding hierarchical representations, the exponential map can be employed to project the output of an encoder onto a specific manifold, such as the Poincaré ball. Initially, one applies multiple non-linear transformations to the input (encoder), obtaining latent representations that (are assumed to) reside in a Euclidean space. Subsequently, these representations are mapped onto the desired manifold via the exponential map. Report issue for preceding element

#### Tangent Vector Fields

In the context of Geometric Deep Learning, tangent vector fields defined smoothly across a manifold can be used to encode local geometric information at each point, see Figure [17](https://arxiv.org/html/2508.02723v1#S4.F17 "Figure 17 ‣ Tangent Vector Fields ‣ 4.3 Manifolds and Differential Geometry ‣ 4 Topological Foundations and Differential Geometry ‣ Mathematical Foundations of Geometric Deep Learning") below.

A tangent vector field on a smooth manifold ℳ\mathcal{M}caligraphic_M is a smooth assignment of a tangent vector vp∈Tp​ℳv\_{p}\in T\_{p}\mathcal{M}  caligraphic_M to each point p∈ℳp\in\mathcal{M} ∈ caligraphic_M. Formally, it is a smooth mapping: V:ℳ→T​ℳ,p↦V​(p)\=vp∈Tp​ℳ.V:\mathcal{M}\rightarrow T\mathcal{M},\quad p\mapsto V(p)=v\_{p}\in T\_{p}\mathcal{M}.italic_V : caligraphic_M → italic_T caligraphic_M ,  ↦ italic_V (  ) =   caligraphic_M . This mapping ensures continuity and differentiability, allowing for consistent geometric analysis across the manifold. Report issue for preceding element

A natural question is: what is the difference between a tangent bundle and a tangent vector field? In short, the tangent bundle is the space of all possible tangent vectors at all points, while a tangent vector field is a smooth assignment of one specific tangent vector to each point on the manifold. For clarity, let us discuss an intuitive example. Imagine the Earth’s surface as your manifold, that is, a sphere. A tangent vector field is a specific weather map showing the wind direction and speed at every single point on the Earth right now. It is one specific wind pattern selected from all possibilities throughout the day, months, years, decades, etc. On the other hand, the tangent bundle would correspond to the entire collection of all possible wind arrows you could ever imagine drawing at every single point on the Earth, no matter the direction or speed (representing every conceivable instantaneous motion at that point).

![Refer to caption](figures/tangent_vector_field_on_manifold.png)
Figure 17: In many problems in Geometric Deep Learning and Geometric Data Processing we work with tangent vector fields.

#### Gauges and Gauge Transformations

In practical scenarios, for instance when we want to process a signal by applying a filter, we often need to select a local coordinate system, known as a gauge, at each point pp on the manifold.

Given a manifold ℳ\mathcal{M}caligraphic_M and a point p∈ℳp\in\mathcal{M} ∈ caligraphic_M, a gauge at pp is a local isomorphism ωp:ℝn→Tp​ℳ\omega\_{p}:\mathbb{R}^{n}\rightarrow T\_{p}\mathcal{M}italic_ω  caligraphic_M. Report issue for preceding element

††margin: Here we refer to isomorphisms: diffeomorphisms that preserve the relevant algebraic structure, like linearity. Note that a homeomorphism is not sufficient for the definition of a gauge.

In the above definition, ℝn\mathbb{R}^{n}  is an nn\-dimensional vector space (the model space); Tp​ℳT\_{p}\mathcal{M}italic_T  caligraphic_M is the tangent space of ℳ\mathcal{M}caligraphic_M at the point pp; and a local isomorphism is a linear mapping that preserves the structure and is invertible.

However, the choice of this local coordinate system is not unique. We can choose different, equally valid gauges. A gauge transformation describes how to switch between these different, equally valid local coordinate systems.

Given a manifold ℳ\mathcal{M}caligraphic_M and a point p∈ℳp\in\mathcal{M} ∈ caligraphic_M, a gauge transformation between two gauges ωp:ℝn→Tp​ℳ\omega\_{p}:\mathbb{R}^{n}\rightarrow T\_{p}\mathcal{M}italic_ω  caligraphic_M and ωp′:ℝn→Tp​ℳ\omega^{\prime}\_{p}:\mathbb{R}^{n}\rightarrow T\_{p}\mathcal{M}italic_ω  → italic_T  caligraphic_M at pp is an isomorphism τ:ℝn→ℝn\tau:\mathbb{R}^{n}\rightarrow\mathbb{R}^{n}italic_τ :   such that: ωp′\=ωp∘τ.\omega^{\prime}\_{p}=\omega\_{p}\circ\tau.italic_ω   ∘ italic_τ . Report issue for preceding element

††margin: τ\tauitalic_τ has type ℝn→ℝn\mathbb{R}^{n}\!\to\!\mathbb{R}^{n}  and it encodes how the two gauges differ, while ω\omegaitalic_ω has type ℝn→Tp​ℳ\mathbb{R}^{n}\!\to\!T\_{p}\mathcal{M}  → italic_T  caligraphic_M sending the standard basis to that of the tangent space. Thus the only way to form a composite ℝn​\toTp​ℳ\mathbb{R}^{n}\toT\_{p}\mathcal{M}   caligraphic_M is ω∘τ\omega\circ\tauitalic_ω ∘ italic_τ, not τ∘ω\tau\circ\omegaitalic_τ ∘ italic_ω.

#### Gauge Equivariance in Convolution Operators and Signal Processing

When designing operators (e.g., convolution) on manifolds, we typically define a filter function ψ\psiitalic_ψ on the tangent space that acts on features from a function f:ℳ→ℝCf:\mathcal{M}\to\mathbb{R}^{C} : caligraphic_M →  . To ensure the operation is independent of the arbitrary choice of gauge, the filter must be gauge equivariant. That is, under a gauge transformation τ\tauitalic_τ, the filter satisfies

ψ​(τ​(v))\=τ​(ψ​(v)),\psi\bigl{(}\tau\,(v)\bigr{)}\;=\;\tau\,(\psi(v)),italic_ψ ( italic_τ (  ) ) = italic_τ ( italic_ψ (  ) ) ,

††margin: Traditional neural network architectures can be adapted to work on manifolds, meshes, and geometric graphs by focusing on local neighborhoods. ![[Uncaptioned image]](figures/mmgg.png)

where the action of τ\tauitalic_τ on the feature vector ψ​(v)\psi(v)italic_ψ (  ) is defined by the same representation. Consequently, a gauge-equivariant convolution is defined as

(f⋆ψ)​(p)\=∫Tp​ℳψ​(v)​f​(expp⁡(v))​𝑑v,(f\star\psi)(p)\;=\;\int\_{T\_{p}\mathcal{M}}\psi(v)\,f\bigl{(}\exp\_{p}(v)\bigr{)}\,dv,(  ⋆ italic_ψ ) (  ) = ∫  (  ) )   ,

which ensures that any change in the local gauge is appropriately counteracted by the corresponding transformation of the filter. This property is essential in applications, as it guarantees that learned features and convolutions are intrinsic to the manifold and not contingent on an arbitrary choice of coordinates.

#### Product Manifolds

Moreover, similarly to Cartesian products between sets, it is also possible to define product manifolds based on the Cartesian product of two subspaces. For example, taking the Cartesian product of two circles (1-spheres) yields a torus. Product manifolds are useful for building more complex yet computationally tractable and interpretable spaces from simpler, well-understood components. Mathematically, the product of two manifolds ℳ\mathcal{M}caligraphic_M and 𝒩\mathcal{N}caligraphic_N is a new manifold ℳ×𝒩\mathcal{M}\times\mathcal{N}caligraphic_M × caligraphic_N. The tangent space at a point (p,q)∈ℳ×𝒩(p,q)\in\mathcal{M}\times\mathcal{N}(  ,  ) ∈ caligraphic_M × caligraphic_N is the direct sum of the tangent spaces at p∈ℳp\in\mathcal{M} ∈ caligraphic_M and q∈𝒩q\in\mathcal{N} ∈ caligraphic_N, i.e.,

T(p,q)​(ℳ×𝒩)\=Tp​ℳ⊕Tq​𝒩.T\_{(p,q)}(\mathcal{M}\times\mathcal{N})=T\_{p}\mathcal{M}\oplus T\_{q}\mathcal{N}.italic_T  caligraphic_N .

Here, the direct sum ⊕\oplus⊕ refers to the combination of two vector spaces (or tangent spaces) such that each element of the resulting space is uniquely a pair consisting of one element from each of the original spaces. A Riemannian metric on the product manifold is then defined as the sum of the individual metrics on ℳ\mathcal{M}caligraphic_M and 𝒩\mathcal{N}caligraphic_N. In certain applications, especially in machine learning models using latent spaces composed of constant-curvature manifolds such as spheres or hyperbolic spaces, it is common to define a distance on the product space by combining the individual geodesic distances as:

d​((x1,x2),(y1,y2)):=dℳ​(x1,y1)2+d𝒩​(x2,y2)2.d((x\_{1},x\_{2}),(y\_{1},y\_{2})):=\sqrt{d\_{\mathcal{M}}(x\_{1},y\_{1})^{2}+d\_{\mathcal{N}}(x\_{2},y\_{2})^{2}}. ( (   )  end_ARG .

This distance function does not generally coincide with the geodesic distance of the Riemannian product manifold but is instead a modeling choice that simplifies computations and leverages closed-form geodesics in the component spaces.

Manifolds in Geometric Deep Learning. Geometric Deep Learning aims to extend neural network architectures to effectively handle data defined on general non-Euclidean domains, including manifolds such as surfaces in 3D space or more abstract, higher-dimensional spaces. When we talk about data lying on a manifold, we often implicitly assume that this manifold has some geometric structure that we want our models to understand and leverage. This structure usually involves notions of distance or similarity, which falls under the umbrella of ‘geometry’. The manifold provides the framework, and the geometry provides the rules for measurement and relationships on that framework. This involves leveraging tools from differential geometry, like geodesics, curvature, and local charts, to design models that respect the manifold’s intrinsic geometry. For example, convolution-like operations on manifolds may be defined in terms of local neighborhoods, where the neighborhood structure is governed by the manifold’s geometry rather than a regular grid. Report issue for preceding element

### 4.4 The Manifold Hypothesis

Many ML and AI algorithms rely on the manifold hypothesis \[[13](https://arxiv.org/html/2508.02723v1#bib.bib13)\] (sometimes also called the manifold assumption), which suggests that although most datasets seem to be high-dimensional in the original data space, data points can actually be described by a low-dimensional manifold which resides within the observed high-dimensional space. This is often used to explain why datasets that appear to require a great number of parameters to be represented, can in practice be encoded using latent variables with few dimensions.††margin: Often the term manifold is abused in ML and AI. As a disclaimer, note that the term ‘manifold’ is used loosely in this context and not in a mathematically rigorous sense. There are no formal guarantees that the low-dimensional representation possesses the mathematical properties discussed earlier in Section [4.3](https://arxiv.org/html/2508.02723v1#S4.SS3 "4.3 Manifolds and Differential Geometry ‣ 4 Topological Foundations and Differential Geometry ‣ Mathematical Foundations of Geometric Deep Learning"). For example, the space may not be perfectly smooth, locally Euclidean, or even have consistent local dimensionality.

![Refer to caption](x3.png)
Figure 18: The manifold which encapsulates all images of faces, is expected to be substantially more low-dimensional than the space ℝ256×height×width\mathbb{R}^{256\times\textit{height}\times\textit{width}} . Points on the manifold correspond to valid face images, whereas the remaining points in the hypercube are likely to produce meaningless, noisy images.

This idea can be more clearly illustrated with a simple example. Consider a dataset of grayscale images with fixed height and width. Although the dataset 𝒟⊂ℝ256×height×width\mathcal{D}\subset\mathbb{R}^{256\times\textit{height}\times\textit{width}}caligraphic_D ⊂   formally lies within a high-dimensional space, most points in this space correspond to meaningless noise. Only a small subset—those lying on the data manifold—represent valid images, such as faces. As shown in Figure [18](https://arxiv.org/html/2508.02723v1#S4.F18 "Figure 18 ‣ 4.4 The Manifold Hypothesis ‣ 4 Topological Foundations and Differential Geometry ‣ Mathematical Foundations of Geometric Deep Learning"), points on the manifold correspond to structured, coherent data, whereas random coordinates in the space typically yield unrecognizable outputs. A key goal in many machine learning approaches is to uncover this low-dimensional manifold that captures the true structure of the data.

Figure [19](https://arxiv.org/html/2508.02723v1#S4.F19 "Figure 19 ‣ 4.4 The Manifold Hypothesis ‣ 4 Topological Foundations and Differential Geometry ‣ Mathematical Foundations of Geometric Deep Learning") illustrates that traversing the manifold allows for controlled variation (such as different facial expressions or poses) while remaining within the space of valid images. In contrast, simple linear interpolation between two images in pixel space generally produces noisy or implausible results. Empirically, smooth transitions can often be observed when interpolating in the latent space of models such as autoencoders. Still, there are no theoretical guarantees that smooth interpolations exist between any two arbitrary points.

![Refer to caption](x4.png)
Figure 19: Depiction of interpolation between images along the surface of the manifold.

## 5 Functional Analysis

Functional analysis is a branch of mathematical analysis that studies spaces of functions and the operators that act on them. Functional analysis provides a powerful framework for understanding infinite-dimensional spaces, where classical linear algebraic methods fail, and establishes the foundation for spectral theory. This section explores key concepts such as completeness, convergence, and the structural properties of vector spaces, with a focus on Banach and Hilbert spaces as fundamental mathematical structures.

Banach and Hilbert Spaces in Geometric Deep Learning. Banach and Hilbert spaces serve as a critical foundation for key concepts such as eigenfunctions, eigenvalues, and Fourier analysis, which we will study in Section [6](https://arxiv.org/html/2508.02723v1#S6 "6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning") and which are widely used in many Geometric Deep Learning algorithms. We encourage readers to review the material on Banach and Hilbert spaces, operators, and functionals. While an in-depth study of these concepts may not be necessary, a basic understanding is useful to tackle spectral theory. Report issue for preceding element

### 5.1 Cauchy Sequences and Banach Spaces

A sequence of vectors v1,v2,…∈Vv\_{1},v\_{2},\ldots\in V  , … ∈ italic_V in a normed vector space VVitalic_V is a Cauchy sequence if for every ϵ\>0\epsilon>0italic_ϵ > 0, there exists an integer NNitalic_N such that ‖vm−vn‖<ϵ​for all ​m,n\>N.\|v\_{m}-v\_{n}\|<\epsilon\quad\text{for all }m,n>N.∥   ∥ < italic_ϵ for all  ,  > italic_N . Report issue for preceding element

As indices mm and nn become arbitrarily large, the vectors vmv\_{m}  and vnv\_{n}  approach each other in norm, satisfying:

limm,n→∞‖vm−vn‖\=0.\lim\_{m,n\to\infty}\|v\_{m}-v\_{n}\|=0.  ∥ = 0 .

Critically, a Cauchy sequence does not inherently guarantee a limit within the space VVitalic_V. ††margin: Consider two spaces V1\=(0,1\]V\_{1}=(0,1\]italic_V  = ( 0 , 1 \] and V2\=(0,1)V\_{2}=(0,1)italic_V  = ( 0 , 1 ), and the sequence dn\=1−1n,d\_{n}=1-\frac{1}{n},  = 1 - divide  , where nn is a positive integer. As n→∞n\rightarrow\infty → ∞, the sequence tends to 111. In the case of V1V\_{1}italic_V  the sequence converges within the space. On the other hand, in V2V\_{2}italic_V  the boundary is not part of the space, and hence the sequence does not converge within V2V\_{2}italic_V  even though it is Cauchy. The existence of such a limit depends on the space’s completeness.

A Banach space is a normed vector space VVitalic_V that is complete, meaning every Cauchy sequence (vn)n≥1(v\_{n})\_{n\geq 1}(   has a limit v∈Vv\in V ∈ italic_V such that: limn→∞‖vn−v‖\=0,\lim\_{n\to\infty}\|v\_{n}-v\|=0,  -  ∥ = 0 , equivalently converging in the topology induced by the norm: limn→∞vn\=v.\lim\_{n\to\infty}v\_{n}=v.  =  . Report issue for preceding element

Banach spaces provide a framework for studying convergence in infinite-dimensional spaces, and they generalize the notion of completeness from real numbers to vector spaces.

A prototypical Banach space is ℓp\ell^{p}roman_ℓ  (for 1≤p<∞1\leq p<\infty1 ≤  < ∞), defined by sequences (xn)n≥1(x\_{n})\_{n\geq 1}(   satisfying:

‖x‖p\=(∑n\=1∞|xn|p)1/p<∞.\|x\|\_{p}=\left(\sum\_{n=1}^{\infty}|x\_{n}|^{p}\right)^{1/p}<\infty.∥  ∥   < ∞ .

The importance of completeness is illustrated by a counterexample in ℚ\mathbb{Q} with the absolute value norm. Consider the sequence approximating 2\sqrt{2}square-root :

vn\=the n\-th rational approximation of 2.v\_{n}=\text{the $n$-th rational approximation of $\sqrt{2}$}.  = the  -th rational approximation of square-root  .

This sequence is Cauchy in ℚ\mathbb{Q}, but its limit 2\sqrt{2}square-root  lies outside ℚ\mathbb{Q}. This demonstrates why completeness is crucial: it prevents Cauchy sequences from ‘escaping’ the original space.

### 5.2 Hilbert Spaces

A Hilbert space is a complete inner product space. ††margin: Hilbert spaces combine the algebraic structure of inner products with the topological properties of completeness. Completeness ensures that the space is well-suited for analyzing convergence of Fourier series, solving partial differential equations, and modeling quantum systems. Hilbert spaces unify algebra, geometry, and analysis in an infinite-dimensional setting. Report issue for preceding element

Hilbert spaces extend the notion of Banach spaces by introducing an inner product ⟨⋅,⋅⟩\langle\cdot,\cdot\rangle⟨ ⋅ , ⋅ ⟩ that induces the norm:

‖v‖\=⟨v,v⟩.\|v\|=\sqrt{\langle v,v\rangle}.∥  ∥ = square-root  .

The inner product allows Hilbert spaces to generalize the geometry of finite-dimensional Euclidean spaces to infinite dimensions. Key examples include L2L^{2}italic_L  (square-integrable) spaces, where functions are treated as infinite-dimensional vectors.

#### Orthogonal Bases

Let VVitalic_V be a Hilbert space and let S⊆VS\subseteq Vitalic_S ⊆ italic_V.

span​(S)\={∑i\=1nαi​vi:n∈ℕ,vi∈S,αi∈ℂ}\mathrm{span}(S)=\left\{\sum\_{i=1}^{n}\alpha\_{i}v\_{i}:n\in\mathbb{N},\,v\_{i}\in S,\,\alpha\_{i}\in\mathbb{C}\right\} ( italic_S ) = { ∑  ∈  }

††margin: The equation states (contrapositive form) that if the linear combination equals the zero vector, then all the coefficients αi\alpha\_{i}italic_α  must be zero. This is a defining property of linear independence.

is the set of all finite linear combinations from SSitalic_S.

SSitalic_S is linearly independent if for any finite subset {v1,…,vn}⊆S\{v\_{1},\ldots,v\_{n}\}\subseteq S{   } ⊆ italic_S and any coefficients α1,…,αn∈ℂ\alpha\_{1},\ldots,\alpha\_{n}\in\mathbb{C}italic_α  ∈ ,

∑i\=1nαi​vi\=0⟹αi\=0​∀i.\sum\_{i=1}^{n}\alpha\_{i}v\_{i}=0\implies\alpha\_{i}=0\,\forall i.∑  = 0 ∀  .

SSitalic_S is orthogonal if ⟨u,v⟩\=0\langle u,v\rangle=0⟨  ,  ⟩ = 0   ∀u,v∈S\forall u,v\in S∀  ,  ∈ italic_S s.t. u≠vu\neq v ≠ . ††margin: As mentioned in Section [2.3](https://arxiv.org/html/2508.02723v1#S2.SS3 "2.3 The Inner Product and Inner Product Spaces ‣ 2 Geometric and Analytical Structures ‣ Mathematical Foundations of Geometric Deep Learning"), orthogonality is typically denoted via u​\perpvu\perpv. To denote that vectors are orthonormal sometimes the following notation is used: u⟂\perpvu\perp\!\!\perpv ⟂.

SSitalic_S is orthonormal if it is orthogonal and all vectors have unit length, i.e. ‖u‖\=1\|u\|=1∥  ∥ = 1   ∀u∈S\forall u\in S∀  ∈ italic_S.

When {ei}i∈I\{e\_{i}\}\_{i\in I}{   }  forms an orthonormal basis for VVitalic_V, every element v∈Vv\in V ∈ italic_V has a unique infinite representation:

v\=v1​e1+v2​e2+⋯\=∑i∈Ivi​ei\=vi​ei\=∑i∈I⟨v,ei⟩​ei,v=v\_{1}e\_{1}+v\_{2}e\_{2}+\dots=\sum\_{i\in I}v\_{i}e\_{i}=v\_{i}e\_{i}=\sum\_{i\in I}\langle v,e\_{i}\rangle e\_{i}, =   ,

where ⟨v,ei⟩\langle v,e\_{i}\rangle⟨  ,   ⟩ are the Fourier coefficients (Section [6.2](https://arxiv.org/html/2508.02723v1#S6.SS2 "6.2 Fourier analysis ‣ 6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning")), and the series converges in the norm induced by the inner product.

#### Functions as Infinite-Dimensional Vectors in L2L^{2}italic_L 

Report issue for preceding element ††margin: Sometimes Hilbert spaces are tacitly assumed separable, yielding the property of isometry to ℓ2\ell^{2}roman_ℓ .

A square-integrable function is a function ff defined on a domain Ω\Omegaroman_Ω such that the square of its absolute value is integrable over Ω\Omegaroman_Ω. Specifically, a function f​(x)f(x) (  ) belongs to the space L2​(Ω)L^{2}(\Omega)italic_L  ( roman_Ω ) if:

∫Ω|f​(x)|2​𝑑x<∞.\int\_{\Omega}|f(x)|^{2}\,dx<\infty.∫  |  (  ) |    < ∞ .

Functions in L2L^{2}italic_L  spaces can be understood as infinite-dimensional vectors by representing them in terms of a set of basis functions. Just as finite-dimensional vectors in ℝn\mathbb{R}^{n}  can be expressed using a basis (e.g., v\=v1​e1+v2​e2+⋯+vn​en\=vi​eiv=v\_{1}e\_{1}+v\_{2}e\_{2}+\dots+v\_{n}e\_{n}=v\_{i}e\_{i} =  ), a function f​(x)f(x) (  ) in L2L^{2}italic_L  can be written as a linear combination of basis functions:

f​(x)\=f1​ϕ1​(x)+f2​ϕ2​(x)+f3​ϕ3​(x)+…f(x)=f\_{1}\phi\_{1}(x)+f\_{2}\phi\_{2}(x)+f\_{3}\phi\_{3}(x)+\dots (  ) =   (  ) + …

Here, {ϕk​(x)}k\=1∞\{\phi\_{k}(x)\}\_{k=1}^{\infty}{ italic_ϕ  (  ) }  ††margin: An orthonormal set of basis functions are orthogonal ⟨ϕi,ϕj⟩\=0\langle\phi\_{i},\phi\_{j}\rangle=0⟨ italic_ϕ  ⟩ = 0 for i​\neqji\neqj, and normalized ⟨ϕi,ϕi⟩\=1\langle\phi\_{i},\phi\_{i}\rangle=1⟨ italic_ϕ  ⟩ = 1. is a set of orthonormal basis functions, and the coefficients fkf\_{k}  represent how much of each basis function ϕk​(x)\phi\_{k}(x)italic_ϕ  (  ) contributes to f​(x)f(x) (  ). The coefficients fkf\_{k}  are computed using the inner product of f​(x)f(x) (  ) with the basis function ϕk​(x)\phi\_{k}(x)italic_ϕ  (  ):

fk\=⟨f,ϕk⟩\=∫f​(x)​ϕk​(x)​𝑑x.f\_{k}=\langle f,\phi\_{k}\rangle=\int f(x)\phi\_{k}(x)\,dx.  (  )   .

This step is analogous to finding the components of a vector in ℝn\mathbb{R}^{n}  by projecting it onto the coordinate axes. ††margin: Analogous to the expression above: ∑i​\inIvi​ei\=∑i​\inI\langlev,ei​\rangleei\sum\_{i\inI}v\_{i}e\_{i}=\sum\_{i\inI}\langlev,e\_{i}\ranglee\_{i}∑ . Once the coefficients f1,f2,f3,…f\_{1},f\_{2},f\_{3},\dots  , … are determined, the function f​(x)f(x) (  ) can be viewed as an infinite-dimensional vector:

f≡\[f1,f2,f3,…\].f\equiv\[f\_{1},f\_{2},f\_{3},\dots\]. ≡ \[   , … \] .

In this sense, the ‘vector’ \[f1,f2,f3,…\]\[f\_{1},f\_{2},f\_{3},\dots\]\[   , … \] describes f​(x)f(x) (  ) completely, just as the coordinates \[v1,v2,…,vn\]\[v\_{1},v\_{2},\dots,v\_{n}\]\[   \] describe a vector in finite-dimensional space.

For example, consider the interval X\=\[0,1\]X=\[0,1\]italic_X = \[ 0 , 1 \] with basis functions ϕ1​(x)\=1\phi\_{1}(x)=1italic_ϕ  (  ) = 1, ϕ2​(x)\=sin⁡(10​π​x)\phi\_{2}(x)=\sin(10\pi x)italic_ϕ  (  ) =  ( 10 italic_π  ), and ϕ3​(x)\=cos⁡(π​x)\phi\_{3}(x)=\cos(\pi x)italic_ϕ  (  ) =  ( italic_π  ). A function f​(x)\=2+17​sin⁡(10​π​x)−cos⁡(π​x)f(x)=2+17\sin(10\pi x)-\cos(\pi x) (  ) = 2 + 17  ( 10 italic_π  ) -  ( italic_π  ) can be written as:

f​(x)\=2⋅ϕ1​(x)+17⋅ϕ2​(x)−1⋅ϕ3​(x).f(x)=2\cdot\phi\_{1}(x)+17\cdot\phi\_{2}(x)-1\cdot\phi\_{3}(x). (  ) = 2 ⋅ italic_ϕ  (  ) .

In this case, the coefficients are f1\=2f\_{1}=2  = 2, f2\=17f\_{2}=17  = 17, and f3\=−1f\_{3}=-1  = - 1, and the function f​(x)f(x) (  ) is represented as the vector \[2,17,−1\]\[2,17,-1\]\[ 2 , 17 , - 1 \]. Extending this idea to infinitely many basis functions gives the full L2L^{2}italic_L  perspective, where f​(x)f(x) (  ) is reconstructed as a weighted sum of basis functions.

This approach provides an intuitive understanding of functions as vectors in infinite-dimensional spaces, where concepts like orthogonality, projection, and decomposition of functions naturally extend from finite-dimensional vector spaces.

### 5.3 Operators and Functionals

In the context of Banach and Hilbert spaces, operators and functionals serve as essential tools for understanding the relationships between elements within and across spaces. They form the backbone of functional analysis. For the sake of brevity, here we only provide a very concise and high-level description of the aforementioned concepts.

#### Operators on Banach and Hilbert Spaces

Operators are mappings that transform elements from one space into another while preserving structure. Through operators, we can describe how vectors interact, how they transform, and how these transformations affect the overall structure of the space.

An operator in this context is a map A:U→VA:U\rightarrow Vitalic_A : italic_U → italic_V between two spaces UUitalic_U and VVitalic_V (Banach or Hilbert), usually preserving some structure. Report issue for preceding element

Let (U,∥∥U)(U,\|\,\|\_{U})( italic_U , ∥ ∥  ) and (V,∥∥V)(V,\|\,\|\_{V})( italic_V , ∥ ∥  ) be Banach spaces with their respective norms, and consider an operator A:U→VA:U\rightarrow Vitalic_A : italic_U → italic_V.

AAitalic_A is continuous ††margin: unu\_{n}  here refers to a sequence in the space un\=(un)n≥1u\_{n}=(u\_{n})\_{n\geq 1} . if it preserves convergence, i.e., un​⟶∥∥U​u⇒A​un​⟶∥∥V​A​uu\_{n}\overset{\|\,\|\_{U}}{\longrightarrow}u\Rightarrow Au\_{n}\overset{\|\,\|\_{V}}{\longrightarrow}Au  end_OVERACCENT  italic_A .

AAitalic_A is bounded if ∃c\>0\exists c>0∃  > 0 s.t. ‖A​u‖V≤c​‖u‖U\|Au\|\_{V}\leq c\|u\|\_{U}∥ italic_A  ∥    ∀u∈U\forall u\in U∀  ∈ italic_U.

AAitalic_A is linear if A​(α​u+β​w)\=α​A​u+β​A​wA(\alpha u+\beta w)=\alpha Au+\beta Awitalic_A ( italic_α  + italic_β  ) = italic_α italic_A  + italic_β italic_A    ∀u,w∈U\forall u,w\in U∀  ,  ∈ italic_U and α,β∈ℂ\alpha,\beta\in\mathbb{C}italic_α , italic_β ∈ .

AAitalic_A is an isometry if it is length-preserving, i.e. ‖A​u‖V\=‖u‖U\|Au\|\_{V}=\|u\|\_{U}∥ italic_A  ∥ .

Let (V,⟨,⟩))(V,\langle\,,\,\rangle))( italic_V , ⟨ , ⟩ ) ) be a Hilbert space and consider an operator A:V→VA:V\rightarrow Vitalic_A : italic_V → italic_V. ††margin: In the context of Hilbert spaces we use the asterisk symbol (⋅)∗(\cdot)^{\*}( ⋅ )  to denote adjoint operators.

A∗A^{\*}italic_A  is adjoint to AAitalic_A if ⟨A​u,v⟩\=⟨u,A∗​v⟩\langle Au,v\rangle=\langle u,A^{\*}v\rangle⟨ italic_A  ,  ⟩ = ⟨  , italic_A   ⟩  ∀u,v∈V\forall u,v\in V∀  ,  ∈ italic_V.

AAitalic_A is self-adjoint if A∗\=AA^{\*}=Aitalic_A  = italic_A, i.e. ⟨A​u,v⟩\=⟨u,A​v⟩\langle Au,v\rangle=\langle u,Av\rangle⟨ italic_A  ,  ⟩ = ⟨  , italic_A  ⟩  ∀u,v∈V\forall u,v\in V∀  ,  ∈ italic_V.

AAitalic_A ††margin: Weak limit (vn​\rightharpoonupvv\_{n}\rightharpoonupv ): vnv\_{n}  converges weakly to vv if \langlevn,w⟩→\langlev,w⟩\langlev\_{n},w\rangle\to\langlev,w\rangle ,  ⟩ → ,  ⟩ for all w​\inVw\inV. This means that vnv\_{n}  converges to vv in the sense of how they interact with other vectors, but not necessarily in norm. 

Stronglimit (vn​\tovv\_{n}\tov ): vnv\_{n}  converges strongly to vv if ‖vn−v‖→0\|v\_{n}-v\|\to 0∥   -  ∥ → 0, i.e., the distance between vnv\_{n}  and vv in the norm goes to zero. is compact if it maps weak limits to strong limits, i.e. vn⇀vv\_{n}\rightharpoonup v  ⇀   ⇒\Rightarrow⇒  A​vn→A​vAv\_{n}\rightarrow Avitalic_A   → italic_A .

The rank of an operator AAitalic_A, denoted as rank​(A)\text{rank}(A)rank ( italic_A ), is the dimension of the image of AAitalic_A, i.e., the number of linearly independent vectors in the set of vectors that AAitalic_A maps to.

Note that in the space of finite-dimensional real vectors, operators can be expressed as matrices: ⟨A​u,v⟩\=(A​u)⊤​v\=u⊤​(A⊤​v)\=⟨u,A⊤​v⟩\langle Au,v\rangle=(Au)^{\top}v=u^{\top}(A^{\top}v)=\langle u,A^{\top}v\rangle⟨ italic_A  ,  ⟩ = ( italic_A  )   ⟩. More on this next.

#### Functionals on Hilbert Spaces

Functionals are maps that assign scalar values to vectors. They provide a way to probe and measure elements of a space.

A functional is a map of the form ϕ:V→ℂ\phi:V\rightarrow\mathbb{C}italic_ϕ : italic_V →  on a Hilbert space VVitalic_V. Report issue for preceding element

ϕ\phiitalic_ϕ is continuous††margin: Note that continuity implies boundedness, that is, there exists a constant CCitalic_C such that |ϕ​(v)|​\leqC​‖v‖V.|\phi(v)|\leqC\|v\|\_{V}.| italic_ϕ (  ) | ∥  ∥  . if it preserves convergence, i.e., if vn​⟶∥∥V​vv\_{n}\overset{\|\,\|\_{V}}{\longrightarrow}v  end_OVERACCENT   in VVitalic_V, then ϕ​(vn)​⟶​ϕ​(v)\phi(v\_{n})\overset{}{\longrightarrow}\phi(v)italic_ϕ (   ) start_OVERACCENT end_OVERACCENT  italic_ϕ (  ), where ∥⋅∥V\|\cdot\|\_{V}∥ ⋅ ∥  is the norm on VVitalic_V.

ϕ\phiitalic_ϕ is a linear functional if ϕ​(α​v+β​w)\=α​ϕ​(v)+β​ϕ​(w)\phi(\alpha v+\beta w)=\alpha\phi(v)+\beta\phi(w)italic_ϕ ( italic_α  + italic_β  ) = italic_α italic_ϕ (  ) + italic_β italic_ϕ (  ) ∀v,w∈V\forall v,w\in V∀  ,  ∈ italic_V and α,β∈ℂ.\alpha,\beta\in\mathbb{C}.italic_α , italic_β ∈  .

Dual (or conjugate) space to VVitalic_V is the space of linear continuous functionals on VVitalic_V, denoted

V∗\={ϕ:V→ℂ​linear+continuous}V^{\*}=\{\phi:V\rightarrow\mathbb{C}\,\,\,\text{linear+continuous}\}italic_V  = { italic_ϕ : italic_V →  linear+continuous }

The elements of V∗V^{\*}italic_V  are called dual vectors.

## 6 Spectral Theory

Spectral theory studies the properties of operators and matrices by analyzing their spectra, that is, their eigenfunctions and associated eigenvalues.

### 6.1 Eigenfunctions and Eigenvalues

Eigenfunctions and eigenvalues arise when we study linear transformations, whether on finite-dimensional vector spaces or infinite-dimensional spaces like function spaces. They allow us to decompose and diagonalize operators. This can enable us to work with a simplified version of the original problem, one that might exhibit complex, non-linear dynamics in the original space. These concepts are particularly central to spectral theory.

Let A:V→VA:V\rightarrow Vitalic_A : italic_V → italic_V be an operator on Hilbert space VVitalic_V. A vector v≠0v\neq 0 ≠ 0 satisfying for some λ\lambdaitalic_λ A​v\=λ​vAv=\lambda vitalic_A  = italic_λ  is called an eigenfunction of AAitalic_A, and λ\lambdaitalic_λ is the corresponding eigenvalue. Report issue for preceding element

Note that eigenfunctions are defined up to scale: if vv is an eigenfunction of AAitalic_A, so is α​v\alpha vitalic_α  for any α≠0\alpha\neq 0italic_α ≠ 0, since we can multiply both sides of the equation by A​(α​v)\=λ​(α​v)A(\alpha v)=\lambda(\alpha v)italic_A ( italic_α  ) = italic_λ ( italic_α  ) by α\alphaitalic_α. It is common to assume eigenfunctions of unit length, i.e. ‖v‖\=1\|v\|=1∥  ∥ = 1.

#### Eigenvectors and Eigenvalues in Finite-Dimensional Vector Spaces

When we are first introduced to eigenvectors and eigenvalues, AAitalic_A typically denotes a matrix, which is a finite, rectangular array of numbers that defines a linear transformation in a finite-dimensional vector space. Eigenvectors are the vectors in the vector space that are scaled by the linear transformation represented by AAitalic_A. In finite-dimensional spaces, eigenfunctions are essentially eigenvectors, but the term eigenfunction is more commonly used in the context of infinite-dimensional spaces. For example, if AAitalic_A is an n×nn\times n ×  matrix, eigenvalues and eigenvectors are solutions to the equation:

A​v\=λ​v,v≠0,Av=\lambda v,\quad v\neq 0,italic_A  = italic_λ  ,  ≠ 0 ,

where vv is a vector in ℝn\mathbb{R}^{n}  or ℂn\mathbb{C}^{n} . This is usually solved finding values of λ\lambdaitalic_λ that satisfy the characteristic equation:††margin: There can be multiple eigenvectors corresponding to the same eigenvalue. If λ\>0\lambda>0italic_λ > 0 the direction of vv remains unchanged, but it is stretched if |λ|\>1|\lambda|>1| italic_λ | > 1 or compressed if |λ|<1|\lambda|<1| italic_λ | < 1. Eigenvalues can be negative. If λ<0\lambda<0italic_λ < 0 the direction of vv is reversed, since multiplication by a negative scalar reflects the vector across the origin.

det​(A−λ​I)\=0,\mathrm{det}\,(A-\lambda I)=0, ( italic_A - italic_λ italic_I ) = 0 ,

where IIitalic_I is the n×nn\times n ×  identity matrix. The solutions λ1,λ2,…,λn\lambda\_{1},\lambda\_{2},\dots,\lambda\_{n}italic_λ  are the eigenvalues of AAitalic_A, and for each eigenvalue λ\lambdaitalic_λ, we find the corresponding eigenvector(s) vv by solving the system of linear equations:

(A−λ​I)​v\=0.(A-\lambda I)v=0.( italic_A - italic_λ italic_I )  = 0 .

The eigenvalue λ\lambdaitalic_λ determines how AAitalic_A stretches or compresses the direction vv, which remains unchanged under the transformation, except for sign flips.

#### Generalization to Hilbert Spaces: Eigenfunctions and Eigenvalues

Here, we are interested in the generalization from finite-dimensional vector spaces to infinite-dimensional spaces. In this generalized setting, AAitalic_A is a linear operator A:V→VA:V\to Vitalic_A : italic_V → italic_V which acts on vectors in the Hilbert space VVitalic_V, instead of a matrix. In a finite-dimensional space, a matrix AAitalic_A maps vectors in ℝn\mathbb{R}^{n}  to ℝn\mathbb{R}^{n} , whereas in an infinite-dimensional space, an operator AAitalic_A maps functions in a space such as L2L^{2}italic_L  to itself. The characteristic equation for eigenvectors A​v\=λ​vAv=\lambda vitalic_A  = italic_λ  still applies in this case, but here vv might be a function (hence called an eigenfunction), and λ\lambdaitalic_λ is a scalar eigenvalue associated with vv.

#### The Spectral Theorem

The spectral theorem states that self-adjoint operators, both in finite and infinite-dimensional spaces, can be fully diagonalized in terms of their eigenvalues and eigenfunctions. This theorem plays a crucial role in understanding the structure of such operators in Hilbert spaces. Remember that AAitalic_A is self-adjoint if A∗\=AA^{\*}=Aitalic_A  = italic_A, i.e. ⟨A​u,v⟩\=⟨u,A​v⟩\langle Au,v\rangle=\langle u,Av\rangle⟨ italic_A  ,  ⟩ = ⟨  , italic_A  ⟩  ∀u,v∈V\forall u,v\in V∀  ,  ∈ italic_V.

We begin by discussing important properties of self-adjoint operators.

###### Theorem 5 (Spectral Theorem for Self-Adjoint Operators).

Report issue for preceding element Self-adjoint operators have real eigenvalues. Report issue for preceding element

###### Proof.

Let A​v\=λ​vAv=\lambda vitalic_A  = italic_λ , with v≠0v\neq 0 ≠ 0. Since A\=A∗A=A^{\*}italic_A = italic_A , we have:

⟨A​v,v⟩\=⟨v,A​v⟩.\langle Av,v\rangle=\langle v,Av\rangle.⟨ italic_A  ,  ⟩ = ⟨  , italic_A  ⟩ .

Substituting A​v\=λ​vAv=\lambda vitalic_A  = italic_λ , we get:

⟨λ​v,v⟩\=⟨v,λ​v⟩.\langle\lambda v,v\rangle=\langle v,\lambda v\rangle.⟨ italic_λ  ,  ⟩ = ⟨  , italic_λ  ⟩ .

Because λ\lambdaitalic_λ is a scalar, we can factor it out of both inner products:

λ​⟨v,v⟩\=λ¯​⟨v,v⟩.\lambda\langle v,v\rangle=\overline{\lambda}\langle v,v\rangle.italic_λ ⟨  ,  ⟩ = over¯  ⟨  ,  ⟩ .

Note that on the right, we have applied conjugate linearity from Section [2.3](https://arxiv.org/html/2508.02723v1#S2.SS3 "2.3 The Inner Product and Inner Product Spaces ‣ 2 Geometric and Analytical Structures ‣ Mathematical Foundations of Geometric Deep Learning"). Since v≠0v\neq 0 ≠ 0, ⟨v,v⟩\>0\langle v,v\rangle>0⟨  ,  ⟩ > 0. Thus, we can divide both sides by ⟨v,v⟩\langle v,v\rangle⟨  ,  ⟩ to obtain:

λ\=λ¯,\lambda=\overline{\lambda},italic_λ = over¯  ,

which implies that λ∈ℝ\lambda\in\mathbb{R}italic_λ ∈ . ∎

###### Theorem 6 (Orthogonality of Eigenfunctions).

Report issue for preceding element Eigenfunctions of self-adjoint operators corresponding to different eigenvalues are orthogonal. Report issue for preceding element

###### Proof.

Let A​v\=λ​vAv=\lambda vitalic_A  = italic_λ  and A​w\=μ​wAw=\mu witalic_A  = italic_μ  with λ≠μ\lambda\neq\muitalic_λ ≠ italic_μ and v,w≠0v,w\neq 0 ,  ≠ 0. Since A\=A∗A=A^{\*}italic_A = italic_A , we have:

⟨A​v,w⟩\=⟨v,A​w⟩.\langle Av,w\rangle=\langle v,Aw\rangle.⟨ italic_A  ,  ⟩ = ⟨  , italic_A  ⟩ .

Substituting the eigenvalue equations, we get:

⟨λ​v,w⟩\=⟨v,μ​w⟩.\langle\lambda v,w\rangle=\langle v,\mu w\rangle.⟨ italic_λ  ,  ⟩ = ⟨  , italic_μ  ⟩ .

Since λ\lambdaitalic_λ and μ\muitalic_μ are real (from Theorem [5](https://arxiv.org/html/2508.02723v1#Thmtheorem5 "Theorem 5 (Spectral Theorem for Self-Adjoint Operators). ‣ The Spectral Theorem ‣ 6.1 Eigenfunctions and Eigenvalues ‣ 6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning")), we can factor out the scalars without conjugation:

λ​⟨v,w⟩\=μ​⟨v,w⟩.\lambda\langle v,w\rangle=\mu\langle v,w\rangle.italic_λ ⟨  ,  ⟩ = italic_μ ⟨  ,  ⟩ .

Thus,

(λ−μ)​⟨v,w⟩\=0.(\lambda-\mu)\langle v,w\rangle=0.( italic_λ - italic_μ ) ⟨  ,  ⟩ = 0 .

Since λ≠μ\lambda\neq\muitalic_λ ≠ italic_μ, it follows that:

⟨v,w⟩\=0,\langle v,w\rangle=0,⟨  ,  ⟩ = 0 ,

i.e., v⟂wv\perp w ⟂ .††margin: The set of eigenvalues can be either finite or countably infinite. A set is countable if there is a way to list its elements in a sequence, that is, there is a one-to-one correspondence between the set and the set of natural numbers, ℕ\mathbb{N}. When we say that the spectrum is discrete we mean that each eigenvalue is separated by some positive distance from others, that is, the eigenvalues are isolated. The only exception is λ\=0\lambda=0italic_λ = 0. There is no continuous spectrum where eigenvalues can form a continuous range or interval. ∎

###### Theorem 7 (Spectral Theorem).

Report issue for preceding element A compact self-adjoint operator A:V→VA:V\to Vitalic_A : italic_V → italic_V has eigenvalues {λ}\{\lambda\}{ italic_λ } with corresponding eigenfunctions {vλ}\{v\_{\lambda}\}{   } such that: A​vλ\=λ​vλ.Av\_{\lambda}=\lambda v\_{\lambda}.italic_A   . These eigenfunctions form an orthonormal basis of VVitalic_V, and the set of eigenvalues is countable. Furthermore, the eigenvalue spectrum is discrete, with the only possible accumulation point being λ\=0\lambda=0italic_λ = 0. Report issue for preceding element

This statement implies that the eigenvalues of a compact self-adjoint operator form a countable set, all of which are real. The corresponding eigenfunctions form an orthonormal basis of the Hilbert space VVitalic_V. If λ≠0\lambda\neq 0italic_λ ≠ 0, then λ\lambdaitalic_λ is an isolated eigenvalue (discrete spectrum). The only possible accumulation point of the spectrum is λ\=0\lambda=0italic_λ = 0.

Thus, the Spectral Theorem builds on the properties established in Theorems [5](https://arxiv.org/html/2508.02723v1#Thmtheorem5 "Theorem 5 (Spectral Theorem for Self-Adjoint Operators). ‣ The Spectral Theorem ‣ 6.1 Eigenfunctions and Eigenvalues ‣ 6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning") and [6](https://arxiv.org/html/2508.02723v1#Thmtheorem6 "Theorem 6 (Orthogonality of Eigenfunctions). ‣ The Spectral Theorem ‣ 6.1 Eigenfunctions and Eigenvalues ‣ 6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning") and provides a complete characterization of the structure of a Hilbert space under a compact self-adjoint operator. ††margin: Principal Component Analysis (PCA) uses a finite-dimensional version of the Spectral Theorem to identify key directions in data.

#### Spectral Theorem Example

In the following, we provide an illustration of the spectral theorem in the context of a differential operator and verify key properties like self-adjointness and orthogonality of eigenfunctions.

Let us work with

L2(\[−π,+π\])\={f:\[−π,+π\]:→ℂs.t.∫−π+π|f(x)|2dx<∞},L^{2}(\[-\pi,+\pi\])=\left\{f:\[-\pi,+\pi\]:\rightarrow\mathbb{C}\quad\text{s.t.}\quad\int\_{-\pi}^{+\pi}|f(x)|^{2}dx<\infty\right\},italic_L    < ∞ } ,

the space of square-integrable periodic functions, meaning their squared magnitude integrates to a finite value, with standard inner product

⟨f,g⟩\=12​π​∫−π+πf​(x)​g​(x)¯​𝑑x,\langle f,g\rangle=\frac{1}{2\pi}\int\_{-\pi}^{+\pi}f(x)\overline{g(x)}dx,⟨  ,  ⟩ = divide    ,

where g​(x)¯\overline{g(x)}over¯  denotes the complex conjugate of g​(x)g(x) (  ).

Consider the Laplacian operator (second-order derivative, see Section [3](https://arxiv.org/html/2508.02723v1#S3 "3 Vector calculus ‣ Mathematical Foundations of Geometric Deep Learning")): Δ\=d2d​x2.\Delta=\frac{d^{2}}{dx^{2}}.roman_Δ = divide  . First, we verify that Δ\Deltaroman_Δ is self-adjoint. To do so, we must show:

⟨Δ​f,g⟩\=⟨f,Δ​g⟩​∀f,g∈L2​(\[−π,π\]).\langle\Delta f,g\rangle=\langle f,\Delta g\rangle\quad\forall f,g\in L^{2}(\[-\pi,\pi\]).⟨ roman_Δ  ,  ⟩ = ⟨  , roman_Δ  ⟩ ∀  ,  ∈ italic_L  ( \[ - italic_π , italic_π \] ) .

From the product differentiation rule,

dd​x​(f​(x)​g​(x))\=f′​(x)​g​(x)+f​(x)​g′​(x).\frac{d}{dx}(f(x)g(x))=f^{\prime}(x)g(x)+f(x)g^{\prime}(x).divide  (  (  )  (  ) ) =   (  ) .

Also, the fundamental theorem of calculus tells us, ††margin: Assuming continuity and differentiability, or piecewise smoothness.

∫−π+πdd​x​(f​(x)​g​(x))​𝑑x\=f​(x)​g​(x)|−π+π,\int\_{-\pi}^{+\pi}\frac{d}{dx}(f(x)g(x))\,dx=\left.f(x)g(x)\right|\_{-\pi}^{+\pi},∫   ,

and given that we are considering periodic functions, we have the boundary conditions f​(π)\=f​(−π)f(\pi)=f(-\pi) ( italic_π ) =  ( - italic_π ) and g​(π)\=g​(−π)g(\pi)=g(-\pi) ( italic_π ) =  ( - italic_π ). Hence,

f​(x)​g​(x)|−π+π\=f​(π)​g​(π)−f​(−π)​g​(−π)\=f​(π)​g​(π)−f​(π)​g​(π)\=0.\left.f(x)g(x)\right|\_{-\pi}^{+\pi}=f(\pi)g(\pi)-f(-\pi)g(-\pi)=f(\pi)g(\pi)-f(\pi)g(\pi)=0. (  )  (  ) |   =  ( italic_π )  ( italic_π ) -  ( - italic_π )  ( - italic_π ) =  ( italic_π )  ( italic_π ) -  ( italic_π )  ( italic_π ) = 0 .

Therefore,

∫−π+πdd​x​(f​(x)​g​(x))​𝑑x\=0⟹∫−π+πf​(x)​g′​(x)​𝑑x\=−∫−π+πf′​(x)​g​(x)​𝑑x,\int\_{-\pi}^{+\pi}\frac{d}{dx}(f(x)g(x))dx=0\implies\int\_{-\pi}^{+\pi}f(x)g^{\prime}(x)dx=-\int\_{-\pi}^{+\pi}f^{\prime}(x)g(x)dx,∫   (  )  (  )   ,

where for simplicity, we ignore complex conjugates. Applying this result to f′​g′f^{\prime}g^{\prime}  we have ††margin: Let ff and gg swap roles to obtain both sides of the equation and perform a change of variables.

−∫−π+πf′​(x)​g​(x)​𝑑x\=∫−π+πf′​(x)​g′​(x)​𝑑x\=−∫−π+πf​(x)​g′​(x)​𝑑x\displaystyle-\int\_{-\pi}^{+\pi}f^{\prime}(x)g(x)dx=\int\_{-\pi}^{+\pi}f^{\prime}(x)g^{\prime}(x)dx=-\int\_{-\pi}^{+\pi}f(x)g^{\prime}(x)dx\- ∫   (  )  

from which self-adjointness ⟨Δ​f,g⟩\=⟨f,Δ​g⟩\langle\Delta f,g\rangle=\langle f,\Delta g\rangle⟨ roman_Δ  ,  ⟩ = ⟨  , roman_Δ  ⟩ follows

⟨Δ​f,g⟩\=∫−π+πf′​(x)​g​(x)​𝑑x\=∫−π+πf​(x)​g′​(x)​𝑑x\=⟨f,Δ​g⟩.\langle\Delta f,g\rangle=\int\_{-\pi}^{+\pi}f^{\prime}(x)g(x)dx=\int\_{-\pi}^{+\pi}f(x)g^{\prime}(x)dx=\langle f,\Delta g\rangle.⟨ roman_Δ  ,  ⟩ = ∫   (  )   = ⟨  , roman_Δ  ⟩ .

After having verified the self-adjointness of the Laplacian, let us now consider the Laplacian acting on the function ei​n​xe^{inx}  where n∈ℤn\in\mathbb{Z} ∈ . From Δ​ei​n​x\=d2d​x2​ei​n​x\=−n2​ei​n​x,\Delta e^{inx}=\frac{d^{2}}{dx^{2}}e^{inx}=-n^{2}e^{inx},roman_Δ   , ††margin: dd​x​ea​x\=a​ea​x\frac{d}{dx}e^{ax}=ae^{ax}divide    it immediately follows that eigenfunctions have the form ei​n​xe^{inx}  with corresponding real eigenvalues −n2\-n^{2}\-  . Remember that in infinite-dimensional space, eigenfunctions are linear operators: indeed the Laplacian scales linearly the function ei​n​xe^{inx}  by a factor of −n2\-n^{2}\-  .

In Theorem [5](https://arxiv.org/html/2508.02723v1#Thmtheorem5 "Theorem 5 (Spectral Theorem for Self-Adjoint Operators). ‣ The Spectral Theorem ‣ 6.1 Eigenfunctions and Eigenvalues ‣ 6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning") we stated that self-adjoint operators have real eigenvalues: −n2\-n^{2}\-   is real. Next, to verify orthogonality and Theorem [6](https://arxiv.org/html/2508.02723v1#Thmtheorem6 "Theorem 6 (Orthogonality of Eigenfunctions). ‣ The Spectral Theorem ‣ 6.1 Eigenfunctions and Eigenvalues ‣ 6 Spectral Theory ‣ Mathematical Foundations of Geometric Deep Learning"), write††margin: Remember we need to consider the complex conjugate of the eigenfunction: ei​m​x¯\=e−i​m​x\overline{e^{imx}}=e^{-imx}over¯ start_ARG  

⟨ei​n​x,ei​m​x⟩\=12​π​∫−π+πei​n​x​e−i​m​x​𝑑x\=12​π​∫−π+πei​(n−m)​x​𝑑x.\displaystyle\langle e^{inx},e^{imx}\rangle=\frac{1}{2\pi}\int\_{-\pi}^{+\pi}e^{inx}e^{-imx}dx=\frac{1}{2\pi}\int\_{-\pi}^{+\pi}e^{i(n-m)x}dx.⟨     .

For n≠mn\neq m ≠  ††margin: This can be shown using the integral of a complex exponential and rewriting the result in terms of the sine function. ,

∫−π+πei​(n−m)​x​𝑑x\=0⟹⟨ei​n​x,ei​m​x⟩\=0.\int\_{-\pi}^{+\pi}e^{i(n-m)x}dx=0\implies\langle e^{inx},e^{imx}\rangle=0.∫   ⟩ = 0 .

This is because the function is periodic with zero average over the full period and shows that distinct eigenfunctions are orthogonal. For n\=mn=m = ,

∫−π+πei​(n−m)​x​𝑑x\=∫−π+π1​𝑑x\=2​π⟹⟨ei​n​x,ei​n​x⟩\=1,\int\_{-\pi}^{+\pi}e^{i(n-m)x}dx=\int\_{-\pi}^{+\pi}1dx=2\pi\implies\langle e^{inx},e^{inx}\rangle=1,∫   ⟩ = 1 ,

which reflects normalization, that is, the eigenfunctions are orthonormal.

Hence we have that,††margin: The Kronecker delta is defined as δn​m\={1,if ​n\=m,0,if ​n​\neqm.\delta\_{nm}=\begin{cases}1,&\text{if }n=m,\\ 0,&\text{if }n\neqm.\end{cases}italic_δ  = { start_ROW start_CELL 1 , end_CELL start_CELL if  =  , end_CELL end_ROW start_ROW start_CELL 0 , end_CELL start_CELL if  . end_CELL end_ROW

⟨ei​n​x,ei​m​x⟩\=δn​m,\langle e^{inx},e^{imx}\rangle=\delta\_{nm},⟨   ⟩ = italic_δ  ,

where δm​n\delta\_{mn}italic_δ  is the Kronecker delta.

#### Singular Values

The spectral theorem focuses on self-adjoint operators. For more general operators, we turn to the concept of singular values and their corresponding singular vectors. Singular values provide a more general way to characterize how an operator transforms vectors in a space, and they are particularly useful when dealing with non-self-adjoint operators, such as general matrices.

Before providing formal definitions, let us clarify the intuitive difference between eigenvalues and singular values. These quantities capture different aspects of how a linear operator transforms elements of the space. Eigenvalues measure how much a transformation stretches or compresses an eigenfunction along its direction, without changing that direction (except for sign flips). On the other hand, singular values measure the overall magnitude of an operator’s action, independent of any specific direction, that is, they describe how much the operator stretches or compresses functions in general. These concepts provide fundamental tools for analyzing operators, whether finite-dimensional (as matrices) or infinite-dimensional.

An operator A:V→VA:V\rightarrow Vitalic_A : italic_V → italic_V is compact iff it can be written in the form A​w\=∑n≥1σn​⟨vn,w⟩​un,∀w∈V.Aw=\sum\_{n\geq 1}\sigma\_{n}\langle v\_{n},w\rangle u\_{n},\quad\forall w\in V.italic_A  = ∑  , ∀  ∈ italic_V . {σn}n≥1\{\sigma\_{n}\}\_{n\geq 1}{ italic_σ  }  are the singular values and {vn}n≥1\{v\_{n}\}\_{n\geq 1}{   } , {un}n≥1\{u\_{n}\}\_{n\geq 1}{   }  are the corresponding (left- and right-) singular vectors of AAitalic_A. ††margin: Singular vectors, both left and right, represent directions in the domain and codomain of AAitalic_A. Report issue for preceding element

Note that this is an alternative definition of compactness. Compact operators are often studied because they have certain nice properties, such as having a countable set of singular values. Importantly, these singular values can accumulate only at zero. This means that after some index NNitalic_N, the singular values become zero, indicating that the operator has finite rank. In this case, the rank of AAitalic_A is equal to NNitalic_N, and we have:

rank​(A)\=N.\text{rank}(A)=N.rank ( italic_A ) = italic_N .

In the finite-dimensional case the rank corresponds to the number of linearly independent rows or columns in the matrix representing the operator, whereas in the infinite-dimensional case the rank is the number of non-zero singular values. Even though the operator may act on an infinite-dimensional space, its rank remains finite.

After discussing the most general case, let us now examine particular cases. If AAitalic_A is self-adjoint, we can write it in the form:

A​w\=∑n≥1λn​⟨vn,w⟩​vn,∀w∈V.Aw=\sum\_{n\geq 1}\lambda\_{n}\langle v\_{n},w\rangle v\_{n},\quad\forall w\in V.italic_A  = ∑  , ∀  ∈ italic_V .

Here, {λn}\{\lambda\_{n}\}{ italic_λ  } are the eigenvalues of AAitalic_A, and {vn}\{v\_{n}\}{   } are the corresponding eigenvectors of AAitalic_A. This is a special case of the more general singular value decomposition, where the singular values coincide with the eigenvalues, and the left and right singular vectors are the same.

Next, let us discuss singular value decomposition (SVD) of matrices.

An m×nm\times n ×  matrix AAitalic_A can be written in the singular value decomposition (SVD) form: A\=U​Σ​V∗\=(||u1…un||)​(σ1⋱σn)​(−v¯1−⋮−v¯n−),A=U\Sigma V^{\*}=\begin{pmatrix}|&&|\\ u\_{1}&\dots&u\_{n}\\ |&&|\end{pmatrix}\begin{pmatrix}\sigma\_{1}&&\\ &\ddots&\\ &&\sigma\_{n}\end{pmatrix}\begin{pmatrix}-&\overline{v}\_{1}&-\\ &\vdots&\\ -&\overline{v}\_{n}&-\end{pmatrix},italic_A = italic_U roman_Σ italic_V  = (  ) , where UUitalic_U is an m×mm\times m ×  unitary matrix whose columns are the left singular vectors uiu\_{i} , Σ\Sigmaroman_Σ is an m×nm\times n ×  diagonal matrix containing the singular values σi\sigma\_{i}italic_σ , and V∗V^{\*}italic_V  is the conjugate transpose of the n×nn\times n ×  unitary matrix VVitalic_V, whose rows are the right singular vectors v¯i\overline{v}\_{i}over¯  . Report issue for preceding element

#### Example Eigenvalues vs Singular Values

To further build on our intuition regarding the difference between eigenvalues and singular values, let us consider a rotation matrix. A rotation matrix has no real eigenvalues because it does not stretch or compress space along fixed directions. However, it has singular values all equal to 111, reflecting that it preserves lengths. More concretly, a rotation matrix RRitalic_R in 2D is defined as:

R\=(cos⁡θ−sin⁡θsin⁡θcos⁡θ),R=\begin{pmatrix}\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta\end{pmatrix},italic_R = (  ) ,

where θ\thetaitalic_θ is the rotation angle. To find the eigenvalues, we solve the characteristic equation:

λ2−2​λ​cos⁡θ+1\=0.\lambda^{2}-2\lambda\cos\theta+1=0.italic_λ  - 2 italic_λ  italic_θ + 1 = 0 .

Thus, the eigenvalues are:

λ\=ei​θ,λ\=e−i​θ.\lambda=e^{i\theta},\quad\lambda=e^{-i\theta}.italic_λ =   .

These eigenvalues are complex and lie on the unit circle in the complex plane. Hence, there are no real eigenvalues unless θ\=0\theta=0italic_θ = 0 or π\piitalic_π (identity and reflection).

The singular values of RRitalic_R are obtained from the eigenvalues of RT​RR^{T}Ritalic_R  italic_R:

Multiplying RT​RR^{T}Ritalic_R  italic_R:

RT​R\=(cos⁡θsin⁡θ−sin⁡θcos⁡θ)​(cos⁡θ−sin⁡θsin⁡θcos⁡θ)\=(1001)\=I.R^{T}R=\begin{pmatrix}\cos\theta&\sin\theta\\ -\sin\theta&\cos\theta\end{pmatrix}\begin{pmatrix}\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta\end{pmatrix}=\begin{pmatrix}1&0\\ 0&1\end{pmatrix}=I.italic_R  italic_R = (  ) = italic_I .

The eigenvalues of RT​RR^{T}Ritalic_R  italic_R are therefore both 111, and the singular values of RRitalic_R (the square roots of these eigenvalues) are: σ1\=1\sigma\_{1}=1italic_σ  = 1 and σ2\=1.\sigma\_{2}=1.italic_σ  = 1 .

### 6.2 Fourier analysis

In eigenfunctions and eigenvalues, singular value decomposition, and Fourier series, the fundamental concept is the decomposition of an object—whether a self-adjoint operator, an operator, or a function—into a sum of components along specific directions or bases. More commonly, Fourier series are associated with a trigonometric basis (sine, cosine, or complex exponential). However, the concept is general and applies to any orthonormal basis.

Let {vα}\{v\_{\alpha}\}{   } be an orthonormal basis in a Hilbert space VVitalic_V. Then, u∈Vu\in V ∈ italic_V can be expressed as a Fourier series u\=∑α⟨u,vα⟩​vαu=\sum\_{\alpha}\langle u,v\_{\alpha}\rangle v\_{\alpha} = ∑  The coefficients ⟨u,vα⟩\=u^α\langle u,v\_{\alpha}\rangle=\hat{u}\_{\alpha}⟨  ,   in the above series are called Fourier coefficients (or transforms) of uu. Report issue for preceding element

For clarity, remember that the expression above can be expanded as follows:

u\=∑α⟨u,vα⟩​vα\=u^α​vα\=u^1​v1+u^2​v2+u^3​v3+…u=\sum\_{\alpha}\langle u,v\_{\alpha}\rangle v\_{\alpha}=\hat{u}\_{\alpha}v\_{\alpha}=\hat{u}\_{1}v\_{1}+\hat{u}\_{2}v\_{2}+\hat{u}\_{3}v\_{3}+... = ∑  + …

#### Fourier Decomposition for Vectors

For vectors, the Fourier decomposition can be written in matrix form:

u\=(||v1⋯vn||)⏟V​(−v¯1⊤−⋮−v¯n⊤−)⏟V†​u,u=\underbrace{\begin{pmatrix}|&&|\\ v\_{1}&\cdots&v\_{n}\\ |&&|\end{pmatrix}}\_{V}\underbrace{\begin{pmatrix}-&\overline{v}\_{1}^{\top}&-\\ &\vdots&\\ -&\overline{v}\_{n}^{\top}&-\end{pmatrix}}\_{V^{\dagger}}u, = under⏟ start_ARG ( start_ARG start_ROW start_CELL | end_CELL start_CELL end_CELL start_CELL | end_CELL end_ROW start_ROW start_CELL    ,

where V∈ℂn×nV\in\mathbb{C}^{n\times n}italic_V ∈   is the matrix whose columns are the basis vectors viv\_{i} , V†V^{\dagger}italic_V  is the Hermitian conjugate (conjugate transpose) of VVitalic_V, and V†​u\=(⟨u,v1⟩,⟨u,v2⟩,…,⟨u,vn⟩)⊤V^{\dagger}u=(\langle u,v\_{1}\rangle,\langle u,v\_{2}\rangle,\ldots,\langle u,v\_{n}\rangle)^{\top}italic_V  contains the Fourier coefficients. Thus

u\=V​(V†​u),u=V(V^{\dagger}u), = italic_V ( italic_V   ) ,

where V†​uV^{\dagger}uitalic_V   gives the coefficients, and V​(V†​u)V(V^{\dagger}u)italic_V ( italic_V   ) reconstructs the vector. From this, it is evident that it is a unitary operation (see below). ††margin: A unitary operation is a linear operation that preserves the inner product in a complex vector space.

#### Continuous Fourier Transform

Note that in general, α\alphaitalic_α here can be a continuous index, in which case the sum should be replaced with an integral:

⟨u,vα⟩\=∫u​(x)​vα​(x)¯​𝑑x.\langle u,v\_{\alpha}\rangle=\int u(x)\overline{v\_{\alpha}(x)}\,dx.⟨  ,   (  ) end_ARG   .

This is the case with the continuous Fourier transform using a basis of the form ei​ω​xe^{i\omega x} , with ω∈ℝ\omega\in\mathbb{R}italic_ω ∈ :

f​(x)\=∫−∞∞f^​(ω)​ei​ω​x​𝑑ω,f(x)=\int\_{-\infty}^{\infty}\hat{f}(\omega)e^{i\omega x}\,d\omega, (  ) = ∫    italic_ω ,

where f^​(ω)\hat{f}(\omega)over^  ( italic_ω ) are the Fourier coefficients of f​(x)f(x) (  ), representing the contribution of each frequency component. The Fourier coefficients are obtained based on the inner product:

f^​(ω)\=∫−∞∞f​(x)​e−i​ω​x​𝑑x.\hat{f}(\omega)=\int\_{-\infty}^{\infty}f(x)e^{-i\omega x}\,dx.over^  ( italic_ω ) = ∫     .

Note that the computations in the continuous case are analogous to obtaining the coefficients and reconstructing the vector using matrix multiplication, as discussed earlier in the context of vectors.

#### Fourier Series Example

Consider L2​(\[−π,+π\])L^{2}(\[-\pi,+\pi\])italic_L  ( \[ - italic_π , + italic_π \] ), the space of square-integrable periodic functions, with the standard inner product ⟨f,g⟩\=12​π​∫−π+πf​(x)​g​(x)¯​𝑑x\langle f,g\rangle=\frac{1}{2\pi}\int\_{-\pi}^{+\pi}f(x)\overline{g(x)}dx⟨  ,  ⟩ = divide    and the basis {ei​n​x}n≥1\{e^{inx}\}\_{n\geq 1}{   } . The Fourier series assume the classical form

f​(x)\=∑n≥112​π​∫−π+πf​(y)​e−i​n​y​𝑑y​ei​n​x.f(x)=\sum\_{n\geq 1}\frac{1}{2\pi}\int\_{-\pi}^{+\pi}f(y)e^{-iny}dy\,e^{inx}. (  ) = ∑   .

The Fourier series provides a discrete decomposition because the function being considered is periodic, leading to discrete frequencies.

#### Parseval’s Identity

Parseval’s identity establishes that the inner product, and hence the geometry, of a Hilbert space VVitalic_V is perfectly captured by the Fourier coefficients. The identity guarantees that this mapping is an isometry, and it allows us to work with Fourier coefficients as a proxy for the original function or vector.

###### Theorem 8 (Parseval’s identity).

Report issue for preceding element Let u\=∑αu^α​vα​and​w\=∑αw^α​vαu=\sum\_{\alpha}\hat{u}\_{\alpha}v\_{\alpha}\quad\text{and}\quad w=\sum\_{\alpha}\hat{w}\_{\alpha}v\_{\alpha} = ∑  be Fourier series of u,w∈Vu,w\in V ,  ∈ italic_V with respect to the orthonormal basis {vα}\{v\_{\alpha}\}{   }. Then ⟨u,w⟩\=∑αu^α​w^¯α\langle u,w\rangle=\sum\_{\alpha}\hat{u}\_{\alpha}\overline{\hat{w}}\_{\alpha}⟨  ,  ⟩ = ∑ . Report issue for preceding element

In other words, we can define a map V∋u↦u^\={⟨u,vα⟩}∈ℓ2V\ni u\mapsto\hat{u}=\{\langle u,v\_{\alpha}\rangle\}\in\ell^{2}italic_V ∋  ↦ over^  = { ⟨  ,   ⟩ } ∈ roman_ℓ  from vectors to (square summable) sequences. This map is an isometry ††margin: Recall that an isometry is length-preserving. :

‖u‖V2\=∑α|⟨u,vα⟩|2\=∑α|u^α|2\=‖u^‖ℓ22.\|u\|^{2}\_{V}=\sum\_{\alpha}|\langle u,v\_{\alpha}\rangle|^{2}=\sum\_{\alpha}|\hat{u}\_{\alpha}|^{2}=\|\hat{u}\|^{2}\_{\ell^{2}}.∥  ∥  end_POSTSUBSCRIPT .

This, in turn, is nothing else but the application of the Pythagorean theorem, Theorem [1](https://arxiv.org/html/2508.02723v1#Thmtheorem1 "Theorem 1 (Generalized Pythagorean Theorem). ‣ Relation to Norms ‣ 2.3 The Inner Product and Inner Product Spaces ‣ 2 Geometric and Analytical Structures ‣ Mathematical Foundations of Geometric Deep Learning") (possibly in infinite dimensions),

‖u‖2\=‖∑α⟨u,vα⟩​vα‖2\=∑α‖⟨u,vα⟩​vα‖2\=∑α|⟨u,vα⟩|2,\|u\|^{2}=\Big{\|}\sum\_{\alpha}\langle u,v\_{\alpha}\rangle v\_{\alpha}\Big{\|}^{2}=\sum\_{\alpha}\|\langle u,v\_{\alpha}\rangle v\_{\alpha}\|^{2}=\sum\_{\alpha}|\langle u,v\_{\alpha}\rangle|^{2},∥  ∥  ,

where we used the orthonormality of the basis {vα}\{v\_{\alpha}\}{   }.

#### The Heat Equation

Consider the following partial differential equation, called the heat equation, under Dirichlet boundary conditions:

{Δ​f​(x,t)\=ft​(x,t)f​(x,0)\=g​(x)(initial conditions)\left\{\begin{array}\[\]{lc}\Delta f(x,t)=f\_{t}(x,t)&\\ f(x,0)=g(x)&\text{(initial conditions)}\end{array}\right.{ start_ARRAY start_ROW start_CELL roman_Δ  (  ,  ) =   (  ,  ) end_CELL start_CELL end_CELL end_ROW start_ROW start_CELL  (  , 0 ) =  (  ) end_CELL start_CELL (initial conditions) end_CELL end_ROW end_ARRAY

on a circle, where f:S1×\[0,∞)→ℝf:S^{1}\times\[0,\infty)\rightarrow\mathbb{R} : italic_S  × \[ 0 , ∞ ) →  (periodic in the first coordinate) represents the temperature ††margin: f​(x,t)f(x,t) (  ,  ) is the temperature at point xx at time tt. , Δ\=∂2∂x2\Delta=\frac{

tial^{2}}{

tial x^{2}}roman_Δ = divide  is the one-dimensional Laplacian operator, and g​(x)g(x) (  ) is the initial temperature distribution at time t\=0t=0 = 0. Since S1S^{1}italic_S  is a circle, there are no boundary conditions on the spatial domain.

Fourier analysis was originally developed for solving this kind of partial differential equation (PDE), and we will show how it applies here. First, assume the solution has a separable form:

f​(x,t)\=X​(x)​T​(t),f(x,t)=X(x)T(t), (  ,  ) = italic_X (  ) italic_T (  ) ,

where X​(x)X(x)italic_X (  ) is the spatial part and T​(t)T(t)italic_T (  ) is the temporal part. Assuming X,TX,Titalic_X , italic_T never vanish, we substitute this into the heat equation:

Δ​f−∂∂t​f\=X′​T−X​T′\=0.\Delta f-\frac{

tial}{

tial t}f=X^{\prime}T-XT^{\prime}=0.roman_Δ  - divide   = italic_X  = 0 .

Since the above holds for any (x,t)(x,t)(  ,  ), it follows that:

X′X\=T′T\=−λ​(some constant).\displaystyle\frac{X^{\prime}}{X}=\frac{T^{\prime}}{T}=-\lambda\quad\text{(some constant)}.divide  = - italic_λ (some constant) .

In other words, the spatial and temporal parts of the solution are eigenfunctions of the Laplacian and first-order derivative operators, respectively:

X′\=Δ​X\=−λ​X,T′\=∂∂t​T\=−λ​T,X^{\prime}=\Delta X=-\lambda X,\quad T^{\prime}=\frac{

tial}{

tial t}T=-\lambda T,italic_X  = divide  italic_T = - italic_λ italic_T ,

which we can express in closed form as:

Δ​ei​n​x\=−n2​ei​n​x,∂∂t​e−n2​t\=−n2​e−n2​t,\Delta e^{inx}=-n^{2}e^{inx},\quad\frac{

tial}{

tial t}e^{-n^{2}t}=-n^{2}e^{-n^{2}t},roman_Δ   ,

where λ\=−n2\lambda=-n^{2}italic_λ = -   is the corresponding eigenvalue.

Hence, solutions to the equation take the form fn​(x,t)\=ei​n​x​e−n2​tf\_{n}(x,t)=e^{inx}e^{-n^{2}t}  (  ,  ) =  . Due to the linearity of the equation, any linear combination of such solutions is also a solution, so the general solution can be written as:

f​(x,t)\=∑n\=−∞∞an​ei​n​x​e−n2​t.f(x,t)=\sum\_{n=-\infty}^{\infty}a\_{n}e^{inx}e^{-n^{2}t}. (  ,  ) = ∑   .

Note that we sum over all integer values of nn (including both positive and negative values) to account for the full Fourier expansion.

To find a unique solution, we must use the initial condition. The set {ei​n​x}n∈ℤ\{e^{inx}\}\_{n\in\mathbb{Z}}{   }  forms an orthonormal basis for L2​(S1)L^{2}(S^{1})italic_L  ). Therefore, we can express the initial condition g​(x)g(x) (  ) as a Fourier series: ††margin: Note that g​(x)g(x) (  ) does not depend on time, so we use the eigenfunctions of the Laplacian.

g​(x)\=∑n\=−∞∞⟨g,ei​n​x⟩​ei​n​x,g(x)=\sum\_{n=-\infty}^{\infty}\langle g,e^{inx}\rangle e^{inx}, (  ) = ∑   ,

where ⟨g,ei​n​x⟩\langle g,e^{inx}\rangle⟨  ,   ⟩ is the Fourier coefficient for g​(x)g(x) (  ).

Since f​(x,0)\=g​(x)f(x,0)=g(x) (  , 0 ) =  (  ), we can identify an\=g^n\=⟨g,ei​n​x⟩a\_{n}=\hat{g}\_{n}=\langle g,e^{inx}\rangle  = ⟨  ,   ⟩. Using the standard inner product for periodic functions, we obtain the general solution:

f​(x,t)\displaystyle f(x,t) (  ,  )

\=\displaystyle=\=

∑n\=−∞∞12​π​∫−ππg​(y)​e−i​n​y​𝑑y​ei​n​x​e−n2​t\displaystyle\sum\_{n=-\infty}^{\infty}\frac{1}{2\pi}\int\_{-\pi}^{\pi}g(y)e^{-iny}\,dy\,e^{inx}e^{-n^{2}t}∑  

\=\displaystyle=\=

12​π​∫−ππg​(y)​∑n\=−∞∞e−n2​t​e−i​n​(x−y)⏟ht​(x−y)​𝑑y\=g⋆ht,\displaystyle\frac{1}{2\pi}\int\_{-\pi}^{\pi}g(y)\underbrace{\sum\_{n=-\infty}^{\infty}e^{-n^{2}t}e^{-in(x-y)}}\_{h\_{t}(x-y)}\,dy=g\star h\_{t},divide  ∫  ,

where ⋆\star⋆ denotes convolution.

The function ht​(x)h\_{t}(x)  (  ) is called the fundamental solution of the heat equation, or the heat kernel. In particular, for the case where the initial condition is the Dirac delta function, g​(x)\=δ​(x)g(x)=\delta(x) (  ) = italic_δ (  ) (an impulse initial condition), we have: ††margin: The Dirac delta function is analogous to the Kronecker delta but in the continuous case. It is defined as: δ​(x−y)\={∞,if ​x\=y,0,if ​x​\neqy,\delta(x-y)=\begin{cases}\infty,&\text{if }x=y,\\ 0,&\text{if }x\neqy,\end{cases}italic_δ (  -  ) = { start_ROW start_CELL ∞ , end_CELL start_CELL if  =  , end_CELL end_ROW start_ROW start_CELL 0 , end_CELL start_CELL if  , end_CELL end_ROW with the important property that its integral over the entire real line is equal to 1: ∫−∞∞δ​(x−y)​𝑑y\=1.\int\_{-\infty}^{\infty}\delta(x-y)\,dy=1.∫   italic_δ (  -  )   = 1 . 

In the context of Fourier analysis, the Dirac delta function can be represented as: δ​(x−y)\=∑n\=−∞∞ei​n​(x−y).\delta(x-y)=\sum\_{n=-\infty}^{\infty}e^{in(x-y)}.italic_δ (  -  ) = ∑   . 

The Dirac delta function acts as an identity element in the Fourier transform, meaning that for any function f​(x)f(x) (  ): ∫−∞∞f​(y)​δ​(x−y)​𝑑y\=f​(x).\int\_{-\infty}^{\infty}f(y)\delta(x-y)\,dy=f(x).∫    (  ) italic_δ (  -  )   =  (  ) .

⟨δ,ei​n​x⟩\=ei​n​0\=1,so​an\=1​∀n,\langle\delta,e^{inx}\rangle=e^{in0}=1,\quad\text{so}\quad a\_{n}=1\quad\forall n,⟨ italic_δ ,   = 1 , so   = 1 ∀  ,

which implies that the solution is:

f​(x,t)\=∑n\=−∞∞e−n2​t​ei​n​x\=ht​(x).f(x,t)=\sum\_{n=-\infty}^{\infty}e^{-n^{2}t}e^{inx}=h\_{t}(x). (  ,  ) = ∑  (  ) .

In signal processing terms, hth\_{t}  is referred to as the impulse response of the system.

#### A Short Note on Wavelets

Wavelets are a generalization of Fourier transforms. While Fourier transforms decompose functions into globally defined sinusoidal components, wavelets decompose functions using basis functions (often orthogonal, but not exclusively so) that are localized in both time and frequency. This localization enables wavelets to represent transient and hierarchical features in data. Before the advent of AlexNet in 2012 and the rise of deep learning, wavelet transforms were widely used in computer vision and signal processing due to their ability to simultaneously capture spatial and frequency information, making them particularly effective for tasks such as image compression, denoising, and texture analysis.

Spectral Theory in Geometric Deep Learning. Spectral theory provides a mathematically rigorous framework for extending traditional Deep Learning approaches for Euclidean data to irregular domains such as graphs and manifolds while maintaining important properties like translation invariance and locality. Report issue for preceding element

## 7 Graph Theory

While††margin: Note however that Geometric Deep Learning is a broader framework that extends Deep Learning techniques to non-Euclidean domains, with one such instantiation being learning over graphs. continuous geometry might examine smooth curves or surfaces, discrete geometry focuses on structures that can be enumerated or broken down into distinct, countable elements. Graph theory \[[14](https://arxiv.org/html/2508.02723v1#bib.bib14)\] is a subset of discrete geometry that is central to GNNs, which are perhaps the quintessential artificial neural network architecture in Geometric Deep Learning.

### 7.1 Preliminaries on Graphs and Notation

We start by discussing basic definitions and notation to describe graphs.††margin: The famous Königsberg Bridge Problem was solved by Euler in 1736 and is one of the earliest examples of graph theory. It is also deeply connected to topology.

A graph is an ordered tuple: G\=(V,E),G=(V,E),italic_G = ( italic_V , italic_E ) , where VVitalic_V is a set of nodes (or vertices), and E⊆(V×V)E\subseteq(V\times V)italic_E ⊆ ( italic_V × italic_V ) is a 2-tuple set representing the edges (or links) in the graph. Report issue for preceding element

††margin: J. Sylvester mentions the term ‘graph’ as early as 1878 in a chemical context. ![[Uncaptioned image]](figures/graph_chemistry.png)

Edges may be directed or undirected. Directed edges are uni-directional relations from a source node viv\_{i}  to a target node vjv\_{j} ; thus, (vi,vj)∈E(v\_{i},v\_{j})\in E(   ) ∈ italic_E, and importantly, (vi,vj)≠(vj,vi)(v\_{i},v\_{j})\neq(v\_{j},v\_{i})(   ).

A directed graph (or digraph) is a graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) where each edge in EEitalic_E is an ordered pair of nodes. Report issue for preceding element

In contrast, undirected edges are bidirectional, so (vi,vj)\=(vj,vi)(v\_{i},v\_{j})=(v\_{j},v\_{i})(   ). When an edge connects a node to itself, we call it a self-loop (vi,vi)(v\_{i},v\_{i})(   ).

The (one-hop) neighborhood of a node viv\_{i}  is the set of nodes that share an edge with viv\_{i} , denoted as 𝒩​(vi)\=𝒩i\={vj|(vi,vj)∈E}.\mathcal{N}(v\_{i})=\mathcal{N}\_{i}=\{v\_{j}|(v\_{i},v\_{j})\in E\}.caligraphic_N (   ) ∈ italic_E } . Report issue for preceding element

A subgraph H\=(VH,EH)H=(V\_{H},E\_{H})italic_H = ( italic_V  ) of a graph G\=(VG,EG)G=(V\_{G},E\_{G})italic_G = ( italic_V  ) is a graph where VH⊆VGV\_{H}\subseteq V\_{G}italic_V  and EH⊆EGE\_{H}\subseteq E\_{G}italic_E . Report issue for preceding element

If we consider the set {vi}∪𝒩​(vi)\{v\_{i}\}\cup\mathcal{N}(v\_{i}){   } ∪ caligraphic_N (   ) as nodes and include all edges in EEitalic_E that connect these nodes, this defines a neighborhood subgraph of viv\_{i} , which is a subgraph of GGitalic_G.

![Refer to caption](figures/graph_picture.png)
Figure 20: Diagram of a graph with nodes in gray and edges in black.

#### The Adjacency Matrix

Graphs can be represented using matrices. For a graph with N\=|V|N=|V|italic_N = | italic_V | number of nodes, its adjacency matrix A∈ℝN×NA\in\mathbb{R}^{N\times N}italic_A ∈   represents the connectivity structure between nodes. AAitalic_A can be weighted or unweighted. If it is weighted, its entries Ai​j∈ℝA\_{ij}\in\mathbb{R}italic_A  ∈  represent the weight or strength of the connection, and if (vi,vj)∉E(v\_{i},v\_{j})\notin E(   ) ∉ italic_E, then Ai​j\=0A\_{ij}=0italic_A  = 0. w:E→ℝ+w:E\rightarrow\mathbb{R}^{+} : italic_E →   is the weight function assigning positive real numbers to edges: if e\=(vi,vj)e=(v\_{i},v\_{j}) = (   ), then w​(e)\=Ai​jw(e)=A\_{ij} (  ) = italic_A . In the case of an unweighted adjacency matrix, Ai​j\=1A\_{ij}=1italic_A  = 1 when there is an edge and Ai​j\=0A\_{ij}=0italic_A  = 0 when there is no edge. So that,

Ai​j\={1if (vi,vj)∈E0if (vi,vj)∉E.A\_{ij}=\begin{cases}1&\text{if $(v\_{i},v\_{j})\in E$}\\ 0&\text{if $(v\_{i},v\_{j})\notin E$}.\end{cases}italic_A  ) ∉ italic_E . end_CELL end_ROW

Hence, if the graphs’ edges are unweighted and undirectional, the corresponding adjacency matrix is binary and symmetric. On the other hand, the adjacency matrix of a digraph is generally asymmetric, since Ai​j≠Aj​iA\_{ij}\neq A\_{ji}italic_A  in the case of directed edges. Lastly, the diagonal degree matrix D∈ℝN×ND\in\mathbb{R}^{N\times N}italic_D ∈   is defined as the matrix where each entry on the diagonal is the row-sum of the adjacency matrix: Di​i\=∑jAi​jD\_{ii}=\sum\_{j}A\_{ij}italic_D , which is also symmetric for undirected graphs.

For example, we can number the nodes of an undirected infinite binary tree in _level order_. Let V\={v1,v2,v3,…}V=\{v\_{1},v\_{2},v\_{3},\dots\}italic_V = {   , … }, where v1v\_{1}  is the root and for each viv\_{i} , its left child is v2​iv\_{2i}  and its right child is v2​i+1v\_{2i+1} . For v1v\_{1}  we have i\=1i=1 = 1, the left child is v2⋅1\=v2v\_{2\cdot 1}=v\_{2} , and the right child is v2⋅1+1\=v3v\_{2\cdot 1+1}=v\_{3} . Likewise for v3v\_{3} , i\=3i=3 = 3, and hence its left child is v2⋅3\=v6v\_{2\cdot 3}=v\_{6}  and its right child is v2⋅3+1\=v7v\_{2\cdot 3+1}=v\_{7} . In summary, the weight function is defined as

w​(vi,vj)\=w​(vj,vi)\={1,if ​{i,j}​ is a parent-child pair (i.e., ​j\=2​i​ or ​j\=2​i+1​),0,otherwise.w(v\_{i},v\_{j})=w(v\_{j},v\_{i})=\begin{cases}1,&\text{if }\{i,j\}\text{ is a parent-child pair (i.e., }j=2i\text{ or }j=2i+1\text{)},\\\[2.84526pt\] 0,&\text{otherwise}.\end{cases} (   ) = { start_ROW start_CELL 1 , end_CELL start_CELL if {  ,  } is a parent-child pair (i.e.,  = 2  or  = 2  + 1 ) , end_CELL end_ROW start_ROW start_CELL 0 , end_CELL start_CELL otherwise . end_CELL end_ROW

This weight function defines the entries of the adjacency matrix AAitalic_A of the infinite binary tree Ai​j\=Aj​i\=w​(vi,vj).A\_{ij}=A\_{ji}=w(v\_{i},v\_{j}).italic_A  ) . Since the tree is infinite, the full adjacency matrix is an infinite matrix too:

A\=(0110000⋯1001100⋯1000011⋯0100000⋯0100000⋯0010000⋯0010000⋯⋮⋮⋮⋮⋮⋮⋮⋱).A=\begin{pmatrix}0&1&1&0&0&0&0&\cdots\\ 1&0&0&1&1&0&0&\cdots\\ 1&0&0&0&0&1&1&\cdots\\ 0&1&0&0&0&0&0&\cdots\\ 0&1&0&0&0&0&0&\cdots\\ 0&0&1&0&0&0&0&\cdots\\ 0&0&1&0&0&0&0&\cdots\\ \vdots&\vdots&\vdots&\vdots&\vdots&\vdots&\vdots&\ddots\end{pmatrix}.italic_A = (  ) .

#### Graph Connectivity

Whether a graph is connected or not determines if information propagation across all vertices of the graph is possible.††margin: Convolutional Neural Networks operate on images and preserve the connectivity equivalent to that of a grid. ![[Uncaptioned image]](figures/grid.png)

A graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) is said to be connected if there is a path between every pair of nodes in the graph. In other words, for any two nodes viv\_{i}  and vjv\_{j} , there exists a sequence of edges e1,e2,…,ek∈Ee\_{1},e\_{2},\dots,e\_{k}\in E  ∈ italic_E such that viv\_{i}  and vjv\_{j}  are endpoints of this sequence. Report issue for preceding element

Conversely, in a disconnected graph, there exist pairs for which no such path exists.

At the node level, degree centrality is a measure of the importance or influence of a node in a graph based on its connectivity.

The degree centrality of a node measures the number of direct connections a node has. In an undirected graph, the degree d​(vi)d(v\_{i}) (   ) of a node viv\_{i}  is simply the number of edges connected to it: d​e​g​(vi)\=∑jAi​j\=∑jAj​i.deg(v\_{i})=\sum\_{j}A\_{ij}=\sum\_{j}A\_{ji}.   (   . In directed graphs, the in-degree and out-degree are defined as the number of incoming and outgoing edges, respectively: d​e​gi​n​(vi)\=∑jAj​i,d​e​go​u​t​(vi)\=∑jAi​j.deg\_{in}(v\_{i})=\sum\_{j}A\_{ji},\quad deg\_{out}(v\_{i})=\sum\_{j}A\_{ij}.    . Report issue for preceding element

Intuitively, a node with high degree centrality is likely to have smaller shortest path distances to other nodes.

The shortest path (graph geodesic) distance between two nodes vi,vj∈Vv\_{i},v\_{j}\in V  ∈ italic_V in a weighted graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ), denoted dG​(vi,vj)d\_{G}(v\_{i},v\_{j})  ), is the minimum total weight of any path connecting these nodes. Formally, for a path P\=(e1,…,ek)P=(e\_{1},\ldots,e\_{k})italic_P = (   ) where ei∈Ee\_{i}\in E  ∈ italic_E, we define: dG​(vi,vj)\=minP∈𝒫i​j​∑ek∈Pw​(ek)d\_{G}(v\_{i},v\_{j})=\min\_{P\in\mathcal{P}\_{ij}}\sum\_{e\_{k}\in P}w(e\_{k})  ) where 𝒫i​j\mathcal{P}\_{ij}caligraphic_P  is the set of all paths from viv\_{i}  to vjv\_{j}  in GGitalic_G, and w:E→ℝ+w:E\rightarrow\mathbb{R}^{+} : italic_E →   is the weight function assigning positive real numbers to edges. Report issue for preceding element

Consider a weighted graph GGitalic_G with the node set V\={v1,v2,v3,v4},V=\{v\_{1},v\_{2},v\_{3},v\_{4}\},italic_V = {   } , and weighted edges defined by w​(v1,v2)\=2,w​(v1,v3)\=4,w​(v2,v3)\=1,w​(v3,v4)\=3w(v\_{1},v\_{2})=2,w(v\_{1},v\_{3})=4,w(v\_{2},v\_{3})=1,w(v\_{3},v\_{4})=3 (   ) = 3. For all other pairs of nodes the weights are 0. This weight function is reflected in the adjacency matrix A∈ℝ4×4A\in\mathbb{R}^{4\times 4}italic_A ∈  , where each entry is given by

Ai​j\={w​(vi,vj)if ​(vi,vj)∈E,0if ​(vi,vj)∉E.A\_{ij}=\begin{cases}w(v\_{i},v\_{j})&\text{if }(v\_{i},v\_{j})\in E,\\\[3.01389pt\] 0&\text{if }(v\_{i},v\_{j})\notin E.\end{cases}italic_A  ) ∉ italic_E . end_CELL end_ROW

In our example, the explicit adjacency matrix is:

A\=(0240001000030000).A=\begin{pmatrix}0&2&4&0\\ 0&0&1&0\\ 0&0&0&3\\ 0&0&0&0\end{pmatrix}.italic_A = (  ) .

The possible paths from v1v\_{1}  to v4v\_{4}  are: P1:v1→v2→v3→v4P\_{1}:v\_{1}\rightarrow v\_{2}\rightarrow v\_{3}\rightarrow v\_{4}italic_P , with total weight w​(P1)\=w​(v1,v2)+w​(v2,v3)+w​(v3,v4)\=2+1+3\=6.w(P\_{1})=w(v\_{1},v\_{2})+w(v\_{2},v\_{3})+w(v\_{3},v\_{4})=2+1+3=6. ( italic_P  ) = 2 + 1 + 3 = 6 . P2:v1→v3→v4P\_{2}:v\_{1}\rightarrow v\_{3}\rightarrow v\_{4}italic_P , with total weight w​(P2)\=w​(v1,v3)+w​(v3,v4)\=4+3\=7.w(P\_{2})=w(v\_{1},v\_{3})+w(v\_{3},v\_{4})=4+3=7. ( italic_P  ) = 4 + 3 = 7 . Thus, the shortest path (graph geodesic) distance between v1v\_{1}  and v4v\_{4}  is dG​(v1,v4)\=min⁡{6,7}\=6.d\_{G}(v\_{1},v\_{4})=\min\{6,7\}=6.  ) =  { 6 , 7 } = 6 .

If no path exists between viv\_{i}  and vjv\_{j} , we define the shortest path to be dG​(vi,vj)\=∞.d\_{G}(v\_{i},v\_{j})=\infty.  ) = ∞ . ††margin: For optimization purposes alternative definitions of the distance between disconnected nodes may be more appropiate than using ∞\infty∞. For unweighted graphs, the distance equals the minimum number of edges in any path between the nodes. Note that the shortest path distance induces a metric space (V,dG)(V,d\_{G})( italic_V ,   ) over the vertex set of the graph GGitalic_G.

The diameter of a graph is the longest shortest path between any two nodes in a graph.

The diameter diam​(G)\text{diam}(G)diam ( italic_G ) is defined as the maximum value of the shortest path distances between all pairs of nodes: d​i​a​m​(G)\=maxvi,vj∈V⁡dG​(vi,vj),diam(G)=\max\_{v\_{i},v\_{j}\in V}d\_{G}(v\_{i},v\_{j}),    ( italic_G ) =   ) , where d​(vi,vj)d(v\_{i},v\_{j}) (   ) is the shortest path distance between nodes viv\_{i}  and vjv\_{j} . Report issue for preceding element

Let us compute the diameter for an undirected graph GGitalic_G with nodes V\={v1,v2,v3,v4}V=\{v\_{1},v\_{2},v\_{3},v\_{4}\}italic_V = {   } and weighted edges w​(v1,v2)\=2,w​(v1,v3)\=4,w​(v2,v3)\=1,w​(v3,v4)\=3.w(v\_{1},v\_{2})=2,w(v\_{1},v\_{3})=4,w(v\_{2},v\_{3})=1,w(v\_{3},v\_{4})=3. (   ) = 3 . For any pair of nodes that are not directly connected, we set the weight to 0. First we must compute the shortest paths between nodes. Between v1v\_{1}  and v2v\_{2}  we have dG​(v1,v2)\=2d\_{G}(v\_{1},v\_{2})=2  ) = 2 since there is a direct edge. Between v1v\_{1}  and v3v\_{3} , there is a direct edge with weight 444, but we also have the path v1→v2→v3v\_{1}\rightarrow v\_{2}\rightarrow v\_{3}  with total weight 2+1\=3.2+1=3.2 + 1 = 3 . Hence, dG​(v1,v3)\=min⁡{4,3}\=3.d\_{G}(v\_{1},v\_{3})=\min\{4,3\}=3.  ) =  { 4 , 3 } = 3 . Between v1v\_{1}  and v4v\_{4} , there are two possible paths: v1→v3→v4v\_{1}\rightarrow v\_{3}\rightarrow v\_{4} , with weight 3+3\=63+3=63 + 3 = 6 (using the shorter v1→v3v\_{1}\to v\_{3}  path computed above), and v1→v2→v3→v4v\_{1}\rightarrow v\_{2}\rightarrow v\_{3}\rightarrow v\_{4} , with weight 2+1+3\=62+1+3=62 + 1 + 3 = 6. Thus, dG​(v1,v4)\=min⁡{6,6}\=6.d\_{G}(v\_{1},v\_{4})=\min\{6,6\}=6.  ) =  { 6 , 6 } = 6 . Similarly, we have dG​(v2,v3)\=1,dG​(v2,v4)\=dG​(v2,v3)+dG​(v3,v4)\=1+3\=4,and​dG​(v3,v4)\=3.d\_{G}(v\_{2},v\_{3})=1,\quad d\_{G}(v\_{2},v\_{4})=d\_{G}(v\_{2},v\_{3})+d\_{G}(v\_{3},v\_{4})=1+3=4,\quad\text{and}\quad d\_{G}(v\_{3},v\_{4})=3.  ) = 3 . Therefore, the pairwise distances (ignoring the trivial zero distances from a node to itself) are {2, 3, 6, 1, 4, 3},\{2,\,3,\,6,\,1,\,4,\,3\},{ 2 , 3 , 6 , 1 , 4 , 3 } , and given that the diameter of a graph is defined as the maximum shortest path distance between any two nodes we obtain: diam​(G)\=max⁡{2, 3, 6, 1, 4, 3, 0}\=6.\text{diam}(G)=\max\{2,\,3,\,6,\,1,\,4,\,3,\,0\}=6.diam ( italic_G ) =  { 2 , 3 , 6 , 1 , 4 , 3 , 0 } = 6 .

††margin: The term point cloud is often associated with points (or nodes) having coordinates in ℝ2\mathbb{R}^{2}  or ℝ3\mathbb{R}^{3} , while the term null graph is more commonly used in graph theory textbooks to refer to graphs without feature vectors. ![[Uncaptioned image]](figures/horse1.png) However, in the GNN literature, point clouds do not necessarily have spatial coordinates.

#### Types of Graphs

Next, we discuss important types of graphs based on their connectivity structures, or graph topology. At one extreme, we can consider graphs that are completely disconnected, known as point clouds. These are actually common in many applications, such as remote sensing technology and surface reconstruction.

A point cloud (or null graph NNN\_{N}italic_N , where the subscript stands for N\=|V|N=|V|italic_N = | italic_V |) is a graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) whose edge set is the empty set E\=∅E=\emptysetitalic_E = ∅. Report issue for preceding element

At the other end of the spectrum, we have complete graphs, which represent the maximum possible number of edges in a graph with NNitalic_N vertices, where every vertex is directly connected to every other vertex.

A complete graph is a graph in which every pair of distinct vertices is connected by a unique edge. A complete graph with NNitalic_N vertices is denoted KNK\_{N}italic_K . Report issue for preceding element

Thus, in a complete graph there are no disconnected components and all vertices are reachable from each other, with a graph geodesic distance equal to 1 for unweighted graphs.††margin: The ubiquitous attention mechanism in Transformers performs computations over a complete graph, where NNitalic_N is the number of tokens in the context window.

A bipartite graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) consists of a set of vertices VVitalic_V, which can be partitioned into two disjoint subsets V1V\_{1}italic_V  and V2V\_{2}italic_V , such that V\=V1∪V2V=V\_{1}\cup V\_{2}italic_V = italic_V  and V1∩V2\=∅V\_{1}\cap V\_{2}=\emptysetitalic_V  = ∅, and a set of edges E⊆{{u,v}∣u∈V1,v∈V2}E\subseteq\{\{u,v\}\mid u\in V\_{1},v\in V\_{2}\}italic_E ⊆ { {  ,  } ∣  ∈ italic_V  }, meaning that edges only connect vertices in V1V\_{1}italic_V  to vertices in V2V\_{2}italic_V . Report issue for preceding element

In simpler terms, a bipartite graph is a graph in which the vertices can be divided into two disjoint sets, such that no two vertices within the same set are adjacent, and edges connect only vertices from different sets. Bipartite graphs are commonly used for modeling in recommendation systems and for matching products to users.

#### Paths and Cycles

Next, we discuss paths and cycles as graph substructures.

A path graph ††margin: Path graphs can represent linear sequences or chains in networks. ![[Uncaptioned image]](figures/path_graph_.png) is a graph where the vertices are arranged in a linear sequence, such that each vertex is connected to at most two others. A path graph with NNitalic_N vertices is denoted PNP\_{N}italic_P . Report issue for preceding element

PNP\_{N}italic_P  consists of NNitalic_N vertices and N−1N-1italic_N - 1 edges, where the endpoints (also called leaves) have degree 1, and all other vertices have degree 2. For instance, consider the vertex set V\={1,2,…,N}V=\{1,2,\dots,N\}italic_V = { 1 , 2 , … , italic_N }, where each vertex corresponds to an element of ℕ\mathbb{N} and the edge set is E\={(vi,vi+1)∣i∈{1,2,…,N−1}}E=\{(v\_{i},v\_{i+1})\mid i\in\{1,2,\dots,N-1\}\}italic_E = { (   ) ∣  ∈ { 1 , 2 , … , italic_N - 1 } }, representing the connections between consecutive numbers. This construction discretizes the natural numbers by treating them as evenly spaced points on a line.

A cycle in a graph is a path that starts and ends at the same node, with all intermediate vertices being distinct. An acyclic graph is one that does not contain any cycles (or closed loops).

A cycle graph ††margin: The circular structure of a cycle graph can be used to represent periodic phenomena. is a graph that consists of a single cycle, where each vertex is connected to exactly two others, forming a closed loop. A cycle graph with NNitalic_N vertices is denoted CNC\_{N}italic_C . Report issue for preceding element

A directed acyclic graph (DAG) ††margin: DAGs are often used to describe causality. is a directed graph that contains no cycles. In a DAG, the edges have a direction, and there is no directed path that leads back to the starting node. Report issue for preceding element

A tree is a connected, acyclic graph where there is exactly one path between any two nodes. It has |V|−1|V|-1| italic_V | - 1 edges for |V||V|| italic_V | vertices. Report issue for preceding element

A directed tree is a type of DAG, but trees can also be undirected. ††margin: Trees have negative curvature and exhibit exponential volume growth. ![[Uncaptioned image]](figures/tree.png)

#### Regular Graphs

In many applications where the underlying graph connectivity is unknown, such as in latent graph inference and bioinformatics, one assumes the underlying graph to be regular.

A regular graph is a graph where every vertex has the same degree. If each vertex has degree kk, the graph is called kk\-regular. Report issue for preceding element

- •

  The null graph NNN\_{N}italic_N , which is 0\-regular (no edges).

  Report issue for preceding element

- •

  The cycle graph CNC\_{N}italic_C , which is 222\-regular.

  Report issue for preceding element

- •

  The complete graph KNK\_{N}italic_K , which is (N−1)(N-1)( italic_N - 1 )\-regular.

  Report issue for preceding element

- •

  Cubic graphs, a special class of 333\-regular graphs, such as the Petersen graph††margin: The Petersen graph is a 10-vertex, 15-edge undirected graph that plays a prominent role in graph theory, often used as a key example or counterexample in various problems. .

  Report issue for preceding element

#### Geometric Graphs

In geometric graphs nodes are represented as points in Euclidean space and their relationships are often defined based on distance or some other notion of geometric proximity according to the space’s metric.††margin: Proximity is used to infer the graph connectivity of molecules based on electron cloud images obtained through X-ray crystallography.

![Refer to caption](figures/8v51_chain-A.jpeg)
Figure 21: Geometric graphs can be used as mathematical abstractions of biomolecules.

A geometric graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) is a graph where each node vi∈Vv\_{i}\in V  ∈ italic_V is associated with a point in a geometric space, typically ℝ2\mathbb{R}^{2}  or ℝ3\mathbb{R}^{3} , and edges (vi,vj)∈E(v\_{i},v\_{j})\in E(   ) ∈ italic_E are determined by the positions of the nodes. Report issue for preceding element

As discussed in the preliminaries in Section [7.1](https://arxiv.org/html/2508.02723v1#S7.SS1 "7.1 Preliminaries on Graphs and Notation ‣ 7 Graph Theory ‣ Mathematical Foundations of Geometric Deep Learning"), connections between nodes are represented by an adjacency matrix, but they also have geometric positions (e.g., atoms in 3D) and geometric features (e.g., velocities).

††margin: k-NN type properties might be desirable if the graph’s density is intended to remain consistent, as it can also prevent the occurrence of disconnected components. However, it imposes constraints on the graph’s connectivity structure and may result in connections between nodes that are unreasonably distant.

Often, in geometric graphs we use the unit disk graph approach where edges (vi,vj)∈E(v\_{i},v\_{j})\in E(   ) ∈ italic_E are included if the distance d​(vi,vj)d(v\_{i},v\_{j}) (   ) between nodes viv\_{i}  and vjv\_{j}  is less than or equal to a fixed threshold ϵ\epsilonitalic_ϵ, i.e., d​(vi,vj)≤ϵd(v\_{i},v\_{j})\leq\epsilon (   ) ≤ italic_ϵ.

An alternative approach is to use k-nearest neighbor (k-NN) graphs. In a k-NN graph, each node is connected to its kk\-closest neighbors in the geometric space, based on the distance metric d​(vi,vj)d(v\_{i},v\_{j}) (   ). This method does not rely on a fixed threshold, but instead ensures that each node is connected to exactly kk other nodes, that is, it is a k-regular graph.

#### Homophily and Heterophily

We can assign class labels yiy\_{i}  to each node viv\_{i} ††margin: It is also possible to assign labels at the graph or edge level. . Most real-world graph datasets adhere to the principle of homophily, where connected nodes tend to belong to the same class. For example, in citation networks, similar research works cite each other. Homophily can be calculated as the fraction of intra-class graph edges:††margin: Example highly homophilic graph. ![[Uncaptioned image]](figures/homophilic.png)

h\=1|E|​∑(vi,vj)∈E𝟙​(yi\=yj),h=\frac{1}{|E|}\sum\_{(v\_{i},v\_{j})\in E}\mathds{1}(y\_{i}=y\_{j}), = divide  ∑  ) ,

where 𝟙\mathds{1}blackboard_1 is the indicator function evaluating to one when the labels of adjacent nodes are equal. The homophily level hh can take values between 0 and 1. We refer to graphs with low hh values as being heterophilic or non-homophilic. Most classical GNN architectures rely on the implicit assumption that graph labels are homophilic.

#### Meshes and other Discrete Structures

Although the main focus in this section is on graphs, other structures such as meshes and simplicial complexes are also important in many computational applications. Rather than delving into the details, our goal here is to make the reader aware of the existence of such mathematical objects.

A mesh is a discrete representation of a geometric domain, typically composed of vertices, edges, and faces (often triangles or polygons) that approximate a continuous surface or manifold. Report issue for preceding element

Meshes are widely used in computer graphics, geometry processing, and physical simulation such as in computational fluid dynamics and other engineering applications.

![Refer to caption](figures/stanford_bunny.png)
Figure 22: The Stanford Bunny is now one of the most recognizable 3D test models in computer graphics. It was originally developed by Greg Turk and Marc Levoy in 1994 at Stanford University.

A simplicial complex is a combinatorial object built from simplices (points, line segments, triangles, tetrahedra, etc.) that are glued together in a way that satisfies certain intersection and inclusion rules. Report issue for preceding element

Simplicial complexes generalize meshes by allowing the construction of higher-dimensional elements. These structures allow for richer notions of locality and multi-scale representation, and are also key to extending graph-based methods into the realm of topological deep learning.

### 7.2 Group Theory and Graphs

#### Permutation-invariance

In many graph machine learning applications, it is important to preserve the structure of the data under reordering, since the numbering of the nodes is arbitrary to begin with. This is where symmetric groups and permutation-invariant aggregators come into play.

Let SSitalic_S be a set with |S|\=N|S|=N| italic_S | = italic_N. The symmetric group of SSitalic_S, denoted by SNS\_{N}italic_S , is the set of all bijections from SSitalic_S to itself: SN\={σ:S→S∣σ​ is a bijection}.S\_{N}=\{\sigma:S\to S\mid\sigma\text{ is a bijection}\}.italic_S  = { italic_σ : italic_S → italic_S ∣ italic_σ is a bijection } . Report issue for preceding element

A permutation-invariant aggregator is a function ⨁:𝒳N→𝒴\bigoplus:\mathcal{X}^{N}\to\mathcal{Y}⨁ : caligraphic_X  → caligraphic_Y that satisfies the condition ⨁(x1,x2,…,xN)\=⨁(xσ​(1),xσ​(2),…,xσ​(N)),\bigoplus(x\_{1},x\_{2},\dots,x\_{N})=\bigoplus(x\_{\sigma(1)},x\_{\sigma(2)},\dots,x\_{\sigma(N)}),⨁ (   ) , for any permutation σ∈SN\sigma\in S\_{N}italic_σ ∈ italic_S , and 𝒳N\mathcal{X}^{N}caligraphic_X  denotes the set of all ordered tuples of NNitalic_N elements from the set 𝒳\mathcal{X}caligraphic_X. Report issue for preceding element

Common examples of permutation-invariant aggregators include summation ∑i\=1Nxi\sum\_{i=1}^{N}x\_{i}∑ , mean 1N​∑i\=1Nxi\frac{1}{N}\sum\_{i=1}^{N}x\_{i}divide  ∑ , and maximum maxi\=1N⁡xi\max\_{i=1}^{N}x\_{i} , where xix\_{i}  are features vectors associated to each node viv\_{i}  as later discussed in Section [7.3](https://arxiv.org/html/2508.02723v1#S7.SS3 "7.3 Vector Fields on Graphs ‣ 7 Graph Theory ‣ Mathematical Foundations of Geometric Deep Learning"). These operations are commonly used at the end of GNN architectures to pool the features from all the nodes in the graph into a single feature vector which can be used for graph level classification or regression.

Permutation matrices formalize the reordering or relabeling of nodes in a graph. Such reordering preserves the intrinsic graph structure, as the node labeling is arbitrary.

A permutation matrix PPitalic_P is a square binary matrix where exactly one entry in each row and each column is equal to 1, and all other entries are 0. Formally, for an N×NN\times Nitalic_N × italic_N permutation matrix PPitalic_P, it holds that: Pi​j\={1if node ​i​ is mapped to node ​j,0otherwise.P\_{ij}=\begin{cases}1&\text{if node }i\text{ is mapped to node }j,\\\[3.01389pt\] 0&\text{otherwise}.\end{cases}italic_P  = { start_ROW start_CELL 1 end_CELL start_CELL if node  is mapped to node  , end_CELL end_ROW start_ROW start_CELL 0 end_CELL start_CELL otherwise . end_CELL end_ROW Such a matrix corresponds uniquely to an element of the symmetric group SNS\_{N}italic_S . Report issue for preceding element

Permutation matrices are orthogonal, which implies that P−1\=PTP^{-1}=P^{T}italic_P  and thus P​PT\=PT​P\=IPP^{T}=P^{T}P=Iitalic_P italic_P  italic_P = italic_I, where IIitalic_I is the identity matrix. When applying a permutation matrix PPitalic_P to a graph with adjacency matrix AAitalic_A, the adjacency matrix transforms as follows:

A′\=P​A​PT,A^{\prime}=PAP^{T},italic_A  ,

where A′A^{\prime}italic_A  is the permuted adjacency matrix, corresponding to the same graph with vertices relabeled according to PPitalic_P. Importantly, graph invariants such as the eigenvalues of the adjacency matrix, node degrees, and connectivity structure remain unchanged by permutations.

#### Graph Homomorphisms

Similar to group homomorphisms which allow us to relate equivalent groups that can be realized differently (Section [1.2](https://arxiv.org/html/2508.02723v1#S1.SS2 "1.2 Groups ‣ 1 Algebraic Structures and Mathematics before Numbers ‣ Mathematical Foundations of Geometric Deep Learning")), graph homomorphisms provide a mathematical framework for studying mappings between graphs that preserve their structural properties. This can be particularly relevant in the context of network compression, graph colorings, and GNN expressivity analysis.

A graph homomorphism is a mapping F:VG→VHF:V\_{G}\to V\_{H}italic_F : italic_V  between the vertex sets of two graphs G\=(VG,EG)G=(V\_{G},E\_{G})italic_G = ( italic_V  ) and H\=(VH,EH)H=(V\_{H},E\_{H})italic_H = ( italic_V  ) such that if (vi,vj)∈EG(v\_{i},v\_{j})\in E\_{G}(  , then (F​(vi),F​(vj))∈EH(F(v\_{i}),F(v\_{j}))\in E\_{H}( italic_F (  . Report issue for preceding element

Intuitively, a graph homomorphism maps edges of GGitalic_G to edges of HHitalic_H, preserving the adjacency structure: if viv\_{i}  and vjv\_{j}  are adjacent in GGitalic_G, their images F​(vi)F(v\_{i})italic_F (   ) and F​(vj)F(v\_{j})italic_F (   ) are adjacent in HHitalic_H. Note that in general, a homomorphism can map multiple vertices or edges of GGitalic_G onto a single vertex or edge in HHitalic_H. This enables the simplification (or coarsening) of graph structures while retaining connectivity properties.

A graph isomorphism is a bijective mapping F:VG→VHF:V\_{G}\to V\_{H}italic_F : italic_V  between the vertex sets of two graphs G\=(VG,EG)G=(V\_{G},E\_{G})italic_G = ( italic_V  ) and H\=(VH,EH)H=(V\_{H},E\_{H})italic_H = ( italic_V  ) such that (vi,vj)∈EG(v\_{i},v\_{j})\in E\_{G}(   if and only if (F​(vi),F​(vj))∈EH(F(v\_{i}),F(v\_{j}))\in E\_{H}( italic_F (  . Report issue for preceding element

Graph isomorphisms are a specific class of graph homomorphisms in which the mapping must be bijective, and the edge-preservation condition is bidirectional.

![Refer to caption](figures/WLtest.png)
Figure 23: The Weisfeiler-Lehman (WL) test is a method used to determine whether two graphs are isomorphic by iteratively refining node labels based on their neighborhoods.

#### Examples of Graph Homomorphisms

- •

  Consider a cycle graph C6C\_{6}italic_C  with six vertices and a complete graph K3K\_{3}italic_K . A homomorphism F:VC6→VK3F:V\_{C\_{6}}\to V\_{K\_{3}}italic_F : italic_V  exists, where vertices of C6C\_{6}italic_C  are mapped to vertices of K3K\_{3}italic_K  in a repeating pattern.

  Report issue for preceding element

- •

  For bipartite graphs, any homomorphism maps vertices in one partition to one set of vertices in the target graph and the other partition to the other set.

  Report issue for preceding element

- •

  Let P11P\_{11}italic_P  be a path graph with eleven vertices, and C10C\_{10}italic_C  be a cycle graph with ten vertices. A homomorphism F:VP11→VC10F:V\_{P\_{11}}\to V\_{C\_{10}}italic_F : italic_V  exists where each vertex of P11P\_{11}italic_P  is mapped to a vertex of C10C\_{10}italic_C , and edges of P11P\_{11}italic_P  are mapped to edges of C10C\_{10}italic_C . Note that in this case the vertices at the start and end of the path graph would be mapped (or collapsed) to a single vertex.

  Report issue for preceding element

### 7.3 Vector Fields on Graphs

Although so far our discussion has centered on graphs in terms of their connectivity structure, in practical scenarios and particularly in the context of Geometric Deep Learning, we primarily deal with graphs that have node attributes. Next, we consider graphs where each node has associated feature vectors and introduce relevant notation.

A feature vector xix\_{i}  at node viv\_{i}  is a DDitalic_D\-dimensional vector that represents the characteristics or attributes of the node in the graph. Report issue for preceding element

These vectors are organized into a matrix X∈ℝN×DX\in\mathbb{R}^{N\times D}italic_X ∈   for all nodes N\=|V|N=|V|italic_N = | italic_V | in the graph. In the following expression, each entry xi​jx\_{ij}  represents the jj\-th feature of node ii:

X\=\[−x1⊤−−x2⊤−⋮−xN⊤−\]\=\[x11x12⋯x1​Dx21x22⋯x2​D⋮⋮⋱⋮xN​1xN​2⋯xN​D\].X=\begin{bmatrix}-x\_{1}^{\top}-\\ -x\_{2}^{\top}-\\ \vdots\\ -x\_{N}^{\top}-\end{bmatrix}=\begin{bmatrix}x\_{11}&x\_{12}&\cdots&x\_{1D}\\ x\_{21}&x\_{22}&\cdots&x\_{2D}\\ \vdots&\vdots&\ddots&\vdots\\ x\_{N1}&x\_{N2}&\cdots&x\_{ND}\end{bmatrix}.italic_X = \[  \] .

Equivalently, linking this discussion back to Section [3.2](https://arxiv.org/html/2508.02723v1#S3.SS2 "3.2 Scalar Fields, Vector Fields, and Signals ‣ 3 Vector calculus ‣ Mathematical Foundations of Geometric Deep Learning"), we can define the feature vector field FFitalic_F as a mapping from the graph domain (nodes in the graph) to ℝD\mathbb{R}^{D} , where DDitalic_D is the number of features for each node:

F:V→ℝD,F(vi)\=xi∈ℝD,∀vi∈V.F:V\to\mathbb{R}^{D},\quad F(v\_{i})=x\_{i}\in\mathbb{R}^{D},\quad\forall v\_{i}\in V.italic_F : italic_V →   , ∀   ∈ italic_V .

In geometric graphs, the matrix S∈ℝN×DS\in\mathbb{R}^{N\times D}italic_S ∈   is sometimes used to denote scalar node features, while X∈ℝN×3X\in\mathbb{R}^{N\times 3}italic_X ∈   is reserved to represent 3D coordinates, and V∈ℝN×3V\in\mathbb{R}^{N\times 3}italic_V ∈   is used to represent additional geometric features.

#### Permuting Feature Vectors

Next, we give concrete examples, showing how the output produced by permutation-invariant aggregators remains unchanged when applying the permutation matrix to a matrix containing feature vectors. Let N\=3N=3italic_N = 3 and D\=2D=2italic_D = 2. Suppose our node feature matrix is

X\=\[123456\],X=\begin{bmatrix}1&2\\ 3&4\\ 5&6\end{bmatrix},italic_X = \[  \] ,

so x1\=\[1,2\]⊤,x2\=\[3,4\]⊤,x3\=\[5,6\]⊤x\_{1}=\[1,2\]^{\top},\;x\_{2}=\[3,4\]^{\top},\;x\_{3}=\[5,6\]^{\top}  = \[ 1 , 2 \] . Consider the permutation σ\sigmaitalic_σ that swaps nodes 1 and 2 (and leaves 3 fixed). The corresponding permutation matrix is

P\=\[010100001\].P=\begin{bmatrix}0&1&0\\ 1&0&0\\ 0&0&1\end{bmatrix}.italic_P = \[  \] .

Applying PPitalic_P to XXitalic_X yields

P​X\=\[010100001\]​\[123456\]\=\[341256\].P\,X=\begin{bmatrix}0&1&0\\ 1&0&0\\ 0&0&1\end{bmatrix}\begin{bmatrix}1&2\\ 3&4\\ 5&6\end{bmatrix}=\begin{bmatrix}3&4\\ 1&2\\ 5&6\end{bmatrix}.italic_P italic_X = \[  \] .

Check the sum:

∑i\=13xi\=\[1+3+52+4+6\]\=\[912\],∑i\=13(P​X)i\=\[3+1+54+2+6\]\=\[912\].\sum\_{i=1}^{3}x\_{i}=\begin{bmatrix}1+3+5\\ 2+4+6\end{bmatrix}=\begin{bmatrix}9\\ 12\end{bmatrix},\qquad\sum\_{i=1}^{3}(PX)\_{i}=\begin{bmatrix}3+1+5\\ 4+2+6\end{bmatrix}=\begin{bmatrix}9\\ 12\end{bmatrix}.∑  = \[  \] .

Thus ∑ixi\=∑i(P​X)i\=∑iP​xi\=P​∑ixi\sum\_{i}x\_{i}=\sum\_{i}(PX)\_{i}=\sum\_{i}Px\_{i}=P\sum\_{i}x\_{i}∑ , illustrating permutation‑invariance. Also, it is trivial to verify that for the mean the same logic holds:

mean​(X)\=13​∑i\=13xi\=13​\[1+3+52+4+6\]\=\[34\],\mathrm{mean}(X)=\frac{1}{3}\sum\_{i=1}^{3}x\_{i}=\frac{1}{3}\begin{bmatrix}1+3+5\\ 2+4+6\end{bmatrix}=\begin{bmatrix}3\\ 4\end{bmatrix}, ( italic_X ) = divide  \] ,

mean​(P​X)\=13​∑i\=13(P​X)i\=13​\[3+1+54+2+6\]\=\[34\].\mathrm{mean}(P\,X)=\frac{1}{3}\sum\_{i=1}^{3}(P\,X)\_{i}=\frac{1}{3}\begin{bmatrix}3+1+5\\ 4+2+6\end{bmatrix}=\begin{bmatrix}3\\ 4\end{bmatrix}. ( italic_P italic_X ) = divide  \] .

Thus mean​(X)\=mean​(P​X)\mathrm{mean}(X)=\mathrm{mean}(P\,X) ( italic_X ) =  ( italic_P italic_X ). Finally, for the max:

maxi\=13⁡xi\=\[max⁡{1,3,5}max⁡{2,4,6}\]\=\[56\],\max\_{i=1}^{3}x\_{i}=\begin{bmatrix}\max\{1,3,5\}\\\[1.50694pt\] \max\{2,4,6\}\end{bmatrix}=\begin{bmatrix}5\\ 6\end{bmatrix},  = \[ start_ARG start_ROW start_CELL  { 1 , 3 , 5 } end_CELL end_ROW start_ROW start_CELL  { 2 , 4 , 6 } end_CELL end_ROW end_ARG \] = \[  \] ,

maxi\=13(PX)i\=\[max⁡{3,1,5}max⁡{4,2,6}\]\=\[56\].\max\_{i=1}^{3}(P\,X)\_{i}=\begin{bmatrix}\max\{3,1,5\}\\\[1.50694pt\] \max\{4,2,6\}\end{bmatrix}=\begin{bmatrix}5\\ 6\end{bmatrix}.  = \[ start_ARG start_ROW start_CELL  { 3 , 1 , 5 } end_CELL end_ROW start_ROW start_CELL  { 4 , 2 , 6 } end_CELL end_ROW end_ARG \] = \[  \] .

Hence maxixi\=maxi(PX)i\max\_{i}x\_{i}=\max\_{i}(P\,X)\_{i} .

#### The Graph Laplacian

The Laplacian plays a key role in analyzing graph structures, particularly in spectral graph theory.

The graph Laplacian matrix LLitalic_L for a graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) is defined as: L\=D−A,L=D-A,italic_L = italic_D - italic_A , where AAitalic_A and DDitalic_D are the adjacency and degree matrices of the graph, respectively. Report issue for preceding element

For undirected graphs, the graph Laplacian is symmetric and positive-semidefinite.

The quadratic form associated with the graph Laplacian can be written as:

x⊤​L​x\=x⊤​(D−A)​x\=∑i\=1ndi​xi2−∑(vi,vj)∈Ewi​j​xi​xj\=12​∑(vi,vj)∈Ewi​j​(xi−xj)2,x^{\top}Lx=x^{\top}(D-A)x=\sum\_{i=1}^{n}d\_{i}x\_{i}^{2}-\sum\_{(v\_{i},v\_{j})\in E}w\_{ij}x\_{i}x\_{j}=\frac{1}{2}\sum\_{(v\_{i},v\_{j})\in E}w\_{ij}(x\_{i}-x\_{j})^{2},  ,

where wi​j\=w​(ei​j)\=w​((vi,vj))w\_{ij}=w(e\_{ij})=w((v\_{i},v\_{j}))  ) ) is the weight of the edge (vi,vj)(v\_{i},v\_{j})(   ), and xix\_{i}  and xjx\_{j}  are the feature values at nodes viv\_{i}  and vjv\_{j} , respectively. Note that this is effectively computing a gradient-like quantity over the graph, which measures the smoothness of the vector field over the graph and is analogous to the Dirichlet energy in continuous settings. ††margin: The Dirichlet energy is the continuous setting is the quadratic functional \langlef,\Deltaf⟩\=⟨\nablaf,\nablaf⟩\langlef,\Deltaf\rangle=\langle\nablaf,\nablaf\rangle, ⟩ = ⟨ , ⟩. It is often referred to as the graph Dirichlet energy or simply the Dirichlet energy on a graph.

The normalized graph Laplacian matrix LnormL\_{\text{norm}}italic_L  is defined as: Lnorm\=I−D−1/2​A​D−1/2,L\_{\text{norm}}=I-D^{-1/2}AD^{-1/2},italic_L  = italic_I - italic_D  , where IIitalic_I is the identity matrix, AAitalic_A is the adjacency matrix, and DDitalic_D is the degree matrix. Report issue for preceding element

The form above††margin: The multiplicity of the eigenvalue refers to the number of times a specific eigenvalue appears in the spectrum of a matrix. has several useful properties: the eigenvalues of LnormL\_{\text{norm}}italic_L  lie in the range \[0,2\]\[0,2\]\[ 0 , 2 \] and the multiplicity of the eigenvalue 0 corresponds to the number of connected components in the graph.

#### Spectral Properties and Graph Frequencies

The eigenvectors of the graph Laplacian provide a natural generalization of the classical Fourier basis to graphs. This spectral perspective enables us to decompose signals over a graph into components of varying smoothness.

Let L∈ℝN×NL\in\mathbb{R}^{N\times N}italic_L ∈   be the graph Laplacian of a graph G\=(V,E)G=(V,E)italic_G = ( italic_V , italic_E ) and N\=|V|N=|V|italic_N = | italic_V |. Since LLitalic_L is symmetric and positive-semidefinite for undirected graphs, it admits an eigen-decomposition: L\=U​Λ​U⊤,L=U\Lambda U^{\top},italic_L = italic_U roman_Λ italic_U  , where U\=\[u1,u2,…,uN\]U=\[u\_{1},u\_{2},\dots,u\_{N}\]italic_U = \[   \] is an orthonormal basis of eigenvectors (the graph Fourier basis) and Λ\=diag​(λ1,λ2,…,λN)\Lambda=\text{diag}(\lambda\_{1},\lambda\_{2},\dots,\lambda\_{N})roman_Λ = diag ( italic_λ  ) is the diagonal matrix of eigenvalues. Report issue for preceding element

Each eigenvector uku\_{k}  defines a basis function over the graph nodes, and its associated eigenvalue λk\lambda\_{k}italic_λ  determines the ‘frequency’ of that basis: lower eigenvalues correspond to smooth, slowly-varying functions over the graph, while higher eigenvalues capture more oscillatory variations. This frequency structure allows us to design filtering operations analogous to classical low-pass or high-pass filters.

††margin: The graph Laplacian eigenvectors form a global coordinate system over the graph. They can be leveraged as positional encodings by assigning each node viv\_{i}  a coordinate vector pi\=(u1​(i),u2​(i),…,uk​(i))p\_{i}=(u\_{1}(i),u\_{2}(i),\dots,u\_{k}(i))  (  ) ) obtained from the first kk nontrivial eigenvectors. These encodings are isomorphism-invariant and capture the intrinsic geometry of the graph.

Given a signal f:V→ℝf:V\to\mathbb{R} : italic_V →  defined on the graph nodes, it can be expressed as a linear combination of these eigenvectors:

f\=∑k\=1N⟨f,uk⟩​uk.f=\sum\_{k=1}^{N}\langle f,u\_{k}\rangle u\_{k}. = ∑  .

The coefficients ⟨f,uk⟩\langle f,u\_{k}\rangle⟨  ,   ⟩ constitute the graph Fourier transform of ff, allowing for the design of frequency-aware processing steps.

The graph Fourier transform of a signal ff is defined as f^\=U⊤​f\hat{f}=U^{\top}fover^  = italic_U  , and the inverse transform is given by f\=U​f^f=U\hat{f} = italic_U over^ . Report issue for preceding element

There will be as many eigenvectors as nodes in the graph. However, note that if there are degenerate eigenvalues (i.e., if an eigenvalue has multiplicity greater than one), the corresponding eigenvectors are not unique, but one can always choose an orthonormal basis consisting of N\=|V|N=|V|italic_N = | italic_V | eigenvectors.

This spectral framework forms the foundation of many techniques in graph signal processing and also serves as a key tool in developing expressive architectures that incorporate both local and global graph structure.

#### Message-Passing on Graphs

For GNNs, we say we are learning a signal over a graph, where the graph structure guides the flow of information between nodes. Typically, the graph on which the signal is defined is coupled with the computational graph of the artificial neural network.

More concretely, a message passing GNN layer ll over a graph GGitalic_G is computed as

xi(l+1)\=ϕ​(xi(l),⨁j∈𝒩​(vi)ψ​(xi(l),xj(l))),x\_{i}^{(l+1)}=\phi\Big{(}x\_{i}^{(l)},\bigoplus\_{j\in\mathcal{N}(v\_{i})}\psi(x\_{i}^{(l)},x\_{j}^{(l)})\Big{)},   ) ) ,

††margin: Transformers perform attentional message passing over a fully connected graph. Alternatively, one can interpret the attention scores as ‘discovering’ the underlying graph. ![[Uncaptioned image]](figures/transformer.png)

where ψ\psiitalic_ψ and ϕ\phiitalic_ϕ are non-linear functions, and ⨁\bigoplus⨁ is an aggregation function, which must be permutation-invariant. The above equation constrains the information flow for each layer to local neighbourhoods and can be further decomposed into three update rules:

mi​j(l)←ψ​(xi(l),xj(l)),m\_{ij}^{(l)}\leftarrow\psi(x\_{i}^{(l)},x\_{j}^{(l)}),   ) ,

(Message)

ai(l)←⨁j∈𝒩​(vi)mi​j(l),a\_{i}^{(l)}\leftarrow\bigoplus\_{j\in\mathcal{N}(v\_{i})}m\_{ij}^{(l)},   ,

(Aggregate)

xi(l+1)←ϕ​(xi(l),ai(l)).x\_{i}^{(l+1)}\leftarrow\phi\Big{(}x\_{i}^{(l)},a\_{i}^{(l)}\Big{)}.   ) .

(Update)

Graph Theory in Geometric Deep Learning. Graph theory plays a central role in Geometric Deep Learning, particularly in the context of GNNs, which are designed to learn signals over graph structures. The underlying graph domain serves as a geometric prior, typically assuming that connected nodes share similar features. GNNs have been applied to diverse areas, including social networks, recommendation systems, and bioinformatics, for both supervised learning and generative modeling. Report issue for preceding element

## References

- Bronstein \[2019\]↑ Michael Bronstein. _Computer Vision and Pattern Recognition Course Notes_. Università della Svizzera italiana, 2019.
- Bronstein \[2024\]↑ Michael Bronstein. _Geometric Deep Learning Course Slides_. University of Oxford, 2024.
- Bronstein et al. \[2021\]↑ Michael Bronstein, Joan Bruna, Taco Cohen, and Petar Veličković. _Geometric Deep Learning: Grids, Groups, Graphs, Geodesics, and Gauges_. 2021\. URL https://arxiv.org/abs/2104.13478.
- Vaswani et al. \[2017\]↑ Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, and Illia Polosukhin. Attention Is All You Need. In _Advances in Neural Information Processing Systems_, 2017.
- LeCun et al. \[2015\]↑ Yann LeCun, Yoshua Bengio, and Geoffrey Hinton. Deep learning. _Nature_, 521(7553):436, 2015.
- Goodfellow et al. \[2016\]↑ Ian Goodfellow, Yoshua Bengio, and Aaron Courville. _Deep Learning_. MIT Press, 2016. http://www.deeplearningbook.org.
- Pinter \[2014\]↑ Charles C. Pinter. _A Book of Set Theory_. Dover Books on Mathematics. Dover Publications, 2014. ISBN 9780486497082.
- Scarselli et al. \[2009\]↑ Franco Scarselli, Marco Gori, Ah Chung Tsoi, Markus Hagenbuchner, and Gabriele Monfardini. The Graph Neural Network Model. _IEEE Transactions on Neural Networks_, 20(1):61–80, 2009. doi: 10.1109/TNN.2008.2005605.
- Mendelson \[1975\]↑ Bert Mendelson. _Introduction to Topology_. Allyn & Bacon, Inc., Boston, 1st edition, 1975.
- Munkres \[2000\]↑ James R. Munkres. _Topology_. Prentice Hall, Upper Saddle River, NJ, 2nd edition, 2000.
- do Carmo \[1976\]↑ Manfredo P. do Carmo. _Differential Geometry of Curves and Surfaces_. Prentice‑Hall, 1976. ISBN 0‑13‑2125897, 978‑0132125895.
- Lee \[1997\]↑ John M. Lee. _Riemannian Manifolds: An Introduction to Curvature_, volume 176 of _Graduate Texts in Mathematics_. Springer-Verlag, New York, 1st edition, 1997. ISBN 978-0-387-22726-1. doi: 10.1007/0-387-22726-1.
- Bengio et al. \[2013\]↑ Yoshua Bengio, Aaron Courville, and Pascal Vincent. Representation learning: A review and new perspectives. _IEEE Trans. Pattern Anal. Mach. Intell._, 35(8):1798–1828, August 2013. ISSN 0162-8828. doi: 10.1109/TPAMI.2013.50. URL https://doi.org/10.1109/TPAMI.2013.50.
- Wilson \[2010\]↑ Robin J. Wilson. _Introduction to Graph Theory_. Prentice Hall/Pearson, New York, 2010. ISBN 027372889X 9780273728894.
