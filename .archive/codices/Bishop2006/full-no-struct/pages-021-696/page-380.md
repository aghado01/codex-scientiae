[Page 380]

3. Complex computations, required to perform inference and learning in sophisticated models, can be expressed in terms of graphical manipulations, in which underlying mathematical expressions are carried along implicitly.

A graph comprises nodes (also called vertices ) connected by links (also known as edges or arcs ). In a probabilistic graphical model, each node represents a random variable (or group of random variables), and the links express probabilistic relationships between these variables. The graph then captures the way in which the joint distribution over all of the random variables can be decomposed into a product of factors each depending only on a subset of the variables. We shall begin by discussing Bayesian networks , also known as directed graphical models , in which the links of the graphs have a particular directionality indicated by arrows. The other major class of graphical models are Markov random ﬁelds , also known as undirected graphical models , in which the links do not carry arrows and have no directional signiﬁcance. Directed graphs are useful for expressing causal relationships between random variables, whereas undirected graphs are better suited to expressing soft constraints between random variables. For the purposes of solving inference problems, it is often convenient to convert both directed and undirected graphs into a different representation called a factor graph .

In this chapter, we shall focus on the key aspects of graphical models as needed for applications in pattern recognition and machine learning. More general treatments of graphical models can be found in the books by Whittaker (1990), Lauritzen (1996), Jensen (1996), Castillo et al. (1997), Jordan (1999), Cowell et al. (1999), and Jordan (2007).

# 8.1. Bayesian Networks

In order to motivate the use of directed graphs to describe probability distributions, consider ﬁrst an arbitrary joint distribution p ( a,b,c ) over three variables a , b , and c . Note that at this stage, we do not need to specify anything further about these variables, such as whether they are discrete or continuous. Indeed, one of the powerful aspects of graphical models is that a speciﬁc graph can make probabilistic statements for a broad class of distributions. By application of the product rule of probability (1.11), we can write the joint distribution in the form

$$
p ( a , b , c ) = p ( c | a , b ) p ( a , b ) .
$$

A second application of the product rule, this time to the second term on the righthand side of (8.1), gives

$$
p ( a , b , c ) = p ( c | a , b ) p ( b | a ) p ( a ) .
$$

Note that this decomposition holds for any choice of the joint distribution. We now represent the right-hand side of (8.2) in terms of a simple graphical model as follows. First we introduce a node for each of the random variables a , b , and c and associate each node with the corresponding conditional distribution on the right-hand side of
