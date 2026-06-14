[Page 1]

# Persistent Homology: An Introduction and a New Text Representation for Natural Language Processing

## Xiaojin Zhu

Department of Computer Sciences, University of Wisconsin-Madison Madison, Wisconsin, USA 53706 jerryzhu@cs.wisc.edu

## Abstract

Persistent homology is a mathematical tool from topological data analysis. It performs multi-scale analysis on a set of points and identiﬁes clusters, holes, and voids therein. These latter topological structures complement standard feature representations, making persistent homology an attractive feature extractor for artiﬁcial intelligence. Research on persistent homology for AI is in its infancy, and is currently hindered by two issues: the lack of an accessible introduction to AI researchers, and the paucity of applications. In response, the ﬁrst part of this paper presents a tutorial on persistent homology speciﬁcally aimed at a broader audience without sacriﬁcing mathematical rigor. The second part contains one of the ﬁrst applications of persistent homology to natural language processing. Speciﬁcally, our Similarity Filtration with Time Skeleton (SIFTS) algorithm identiﬁes holes that can be interpreted as semantic “tie-backs” in a text document, providing a new document structure representation. We illustrate our algorithm on documents ranging from nursery rhymes to novels, and on a corpus with child and adolescent writings.

## 1 Introduction

Imagine dividing a document into smaller units such as paragraphs. A paragraph can be represented by a point in some space, for example, as the bag-of-words vector in R d where d is the vocabulary size. All paragraphs in the document form a point cloud in this space. Now let us “connect the dots” by linking the point for the ﬁrst paragraph to the second, the second to the third, and so on. What does the curve look like? Certain structures of the curve capture information relevant to Natural Language Processing (NLP). For instance, a good essay may have a conclusion paragraph that “ties back” to the introduction paragraph. Thus the starting point and the ending point of the curve may be close in the space. If we further connect all points within some small diameter, the curve may become a loop with a hole in the middle. In contrast, an essay without any tying back may not contain holes, no matter how large is.

There has been geometric methods for visualizing documents and information ﬂow, e.g. based on differential geometry [ Lebanon et al. , 2007; Lebanon, 2006; Gous, 1999; Hall and Hofmann, 2000 ] . In contrast, we introduce an algebraic method based on persistent homology. As a branch of topological data analysis, persistent homology has the advantage of capturing novel invariant structural features of documents. Intuitively, persistent homology can identify clusters (0-th order holes), holes (1st order, as in our loopy curve), voids (2nd order holes, the inside of a balloon), and so on in a point cloud. Considering the importance of clustering today, the value of these higher order structures is tantalizing. Indeed, in the last few years persistent homology has found applications in data analysis, including neuroscience [ Singh et al. , 2008 ] , bioinformatics [ Kasson et al. , 2007 ] , sensor networks [ de Silva and Ghrist, 2007a; de Silva and Ghrist, 2007b ] , medical imaging [ Chung et al. , 2009 ] , shape analysis [ Gamble and Heo, 2010 ] , and computer vision [ Freedman and Chen, 2011 ] .

Unfortunately, existing homology literature requires advanced mathematical background not easily accessible to a broader audience. Our ﬁrst contribution is an accessible yet rigorous tutorial that contains many unpublished materials. Although a tutorial is unconventional in a technical paper, we feel that there is value to the AI community as it paves the way to further interdisciplinary research. Our second contribution is a novel text representation using persistent homology. It formalizes the curve-and-loop intuition based on Vietoris-Rips ﬁltration over semantic similarity. We hope this paper inspires future innovations on topology and AI.

## 2 Persistent Homology

We aim for mathematical rigor and intuition, but have to sacriﬁce completeness. Readers can follow up with [ Singh et al. , 2008; Giblin, 2010; Freedman and Chen, 2011; Zomorodian, 2001; Rote and Vegter, 2006; Edelsbrunner and Harer, 2010; Hatcher, 2001; Carlsson, 2009; Edelsbrunner and Harer, 2007; Balakrishnan et al. , 2012; 2013 ] for detailed treatment.

Persistent homology ﬁnds “holes” by identifying equivalent cycles: Consider the following space in yellow with a small white hole. Imagine the blue cycle as a rubber band. It can be stretched and bent within the space into the green cycle, but not the red one without tearing itself.
