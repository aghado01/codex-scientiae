# Superparamagnetic Clustering of Data The Definitive Solution of an Ill-Posed Problem

# Eytan Domany

Department of Physics of Complex Systems, Weizmann Inst. of Science, Rehovot 76100, Israel

# Abstract

Clustering is an important technique in exploratory data analysis, with applications in image processing, object classification, target recognition, data mining etc. The aim is to partition data according to natural classes present in it, assigning data points that are "more similar" to the same "cluster". We solved this ill-posed problem without making any assumptions about the structure of the data, by using a physical system as an golana c The physical system we use is a disordered (granular) magnet. The method was tested successfully on a variety of artificial and real-life problems, such as classification of flowers, processing of satellite images, speech recognition and identification of textures and images. We are currently involved in several collaborations, applying the method to image classification, fMRI data analysis and classification of protein structures.

# 1 Introduction: "Definition" of the Problem

The only proper way to define an ill-posed problem is by means of an example. Imagine the following experiment: a young child, who has never before seen either a kangaroo or a giraffe is exposed to hundreds of pictures of these animals, with no explanation given. Chances are that after seeing a sufficiently large number of giraffes and kangaroos the child will form a fairly clear understanding of the fact that she has been introduced to two different kinds of creatures. The child has learned something new without being instructed. This form of u l is probably the most important means by which we acquire and process the incessant flow of information that reaches our senses from the world that surrounds us. Our brains learn, without a teacher's guidance, by grouping or binding together similar observations. Such a process, called c is used also in a wide variety of applications, ranging from pattern recognition[I] to data mining [

The standard definition of the clustering problem ]3[ is as follows. Partition N given points into K groups (e.g. clusters) so that two points that belong to the same group are, in some sense, more similar than two that belong to different ones. The i = 1 2, ...N data points are specified either in terms of their coordinates Xi in a D-dimensional space or, alternatively, by means of an N x N "distance matrix", whose elements d measure the dissimilarity of data points i and j. The traditional tasks of clustering algorithms are to

[Page 2]

determine K and to assign each data point to a cluster. To put the example presented above in this context, imagine that each picture of an animal is processed by the child's visual system and is represented as a point in some abstract high dimensional space. In this space there will be a cloud of points that correspond to kangaroos and another cloud whose points will represent giraffes; the points of the first cloud will be assigned to cluster No. 1 and those of the second cloud to cluster No 2.

No. 1 and those of the second cloud to cluster No 2.

in fact, the problem is inherently ill-posed, i any given set of points can be clustered in drastically different ways, with no clear criterion available to prefer one clustering over another. Difficulties and ambiguities may arise for a variety of reasons. For example, there may be data points that do not belong to either cloud; the shapes of the clouds may be complex and their density nonuniform. The most important source of ambiguity is that the manner in which data "should" be clustered depends on the desired r What appears as a single cloud may turn out, when examined with higher resolution, to be composed of several subclusters. Different tasks call for differing levels of resolution; furthermore, as we learn, our resolution improves. In the example presented above the child may pass from the initial operating point of lowest resolution, in which all observed creatures are assigned to one huge cluster of "objects" or "animals", to the highest resolution, in which every single observation is an independent cluster (having spent some years among the giraffes, we may recognize each individual). Any attempt at clustering must select one of several distinct approaches. The algorith-

mic manifestations of these different approaches are, for example, whether the number of clusters K is imposed as a hard constraint[4]? What controls the resolution, i a possible hierarchical organization of the data into subclusters? Is there an "ideal kangaroo" or prototype, which may serve as a representative center of the corresponding cluster? Are there any a-priori assumptions made about the distribution of the data?

there any a-priori assumptions made about the distribution of the data?

whose value can be calculated for any assignment of the data points to clusters. Methods differ in the particular cost function used and in what is to be done with the cost function e.g., i it to be minimized? If so under what constraints?

to be minimized? If so - under what constraints?

Super Paramagnetic C tering ( The motivation for the method originates in the physics of disordered granular magnets. In Sec 2.1 I introduce the cost function used by SPC; this cost function has the form of the Hamiltonian of a disordered Potts ferromagnet. The connection to Equilibrium Statistical Mechanics is natural and is explained in Sec 2.2. As we will see, the temperature T c the resolution at which the data are clustered. Various equilibrium properties of the system are measured by Monte Carlo; in particular, the correlations of neighboring pairs is measured and serves to determine the assignment of data points to clusters, as explained in Sec 2.3. In Sec 3 we apply the method to a variety of problems.

[Page 3]

# 2 Superparamagnetic Clustering of Data

# 2 The Cost Function

The basic premise of our approach is the following; data points i, j that are highly similar to one another, i.e. with small dij, are likely to belong to the same clusters; the closer two points are, the more unlikely they are to belong to different clusters. To put this statement on a formal ground, we assign to every data point i a Potts spin variable 2 Si = 1 2, . Any particular clustering assignment is represented as a configuration {S} = {$1, $ ...SN} of all the Potts spin variables. Losely speaking, Si = Sj indicates that i and j belong to the same cluster. An assignment with Si ~ Sj means that the two points are in different clusters, and such an assignment draws a penalty Jij. A cost function that reflects these statements has the form

$$
\mathcal { H } ( \{ S \} ) = \sum _ { < i , j > } J _ { i j } \, \left ( 1 - \delta _ { S _ { i } , S _ { j } } \right ) \, \quad \ \ ( 1 )
$$

with Jq a decreasing function of the "distance" dij between the data points i,j. In most applications we used a Gaussian decay of the interaction strength with distance, cut off beyond some distance or some number of neighbors; we expect, however, that neither the kind of spins used, nor the precise functional form of Jq(dij) has a qualitative effect on the results. In particular, the number of Potts components q has nothig to do with the number of clusters. At temperature T = 0 such a disordered ferromagnet is in its ground state, in which

all spins are aligned. At high temperatures the system is completely disordered, with vanishing correlation between any pair of spins. The manner in which the system changes as T varies between these extremes depends on the struture in the data. If we have one single cluster of data points, we expect a single (first order for q = 20) phase transition from the disordered paramagnetic phase to the fully ordered ferromagnetic one. If there are several clusters of data, we expect to observe one or more intermediate phases and transitions between them as the temperature is lowered; the spins associated with data points that form relatively dense clusters are expected to order at some high temperature, whereas less dense regions at lower T. Two ordered clusters can be uncorrelated with each other, acting like giant superspins this intermediate superparamagnetic regime serves to identify distinct clusters until at a lower T they become also relatively ordered. As we will see, if Si and Sj are highly correlated, our algorithm assigns the data points i and j to the same cluster. Hence indeed T controls the resolution at which we cluster the data, as mentioned above.

# 2.2 Statistical Mechanics

The connection to Equilibrium Statistical Mechanics arises through the following argument. Any assignment of the variables {S} represents a particular possible clustering of the data. Rather than minimizing the cost function, we realize that its value for {S}

[Page 4]

reflects the resolution at which this clustering assignment views the data. There are many configurations {S} with the same value of 7/ and we do not have any good reason to prefer one over the other. Hence it makes sense that for any desired resolution, i fixed value of 7i = E, we assign to all configurations with this value of 7/the same probability, whereas all {S} that correspond to different resolutions (and hence have different values 7/({ S }) ¢ E) get vanishing probability. The resulting ensemble of assignments {S} is nothing but the microcanonical ensemble which we replace by the computationally more convenient canonical ensemble, in which rather than fixing the value of ,47 we control its average value by a Lagrange multiplier, 1/T. The connection to Statistical Mechanics sketched above was first made by Rose et a They, however, used a very different cost function[8] one that minimizes the variance within each cluster and hence maps onto a model with glassy behavior. Another important difference between their work and ours is in the way they calculate the equilibrium properties of their model by means of deterministic annealing. This method is unable to deal with first-order transitions which seem to be prevalent in the generic situations[9]. We, on the other hand, calculate the equilibrium average of various quantities by Monte

Carlo. Using the Swendsen-Wang[10] algorithm, which is very efficient in flipping a large aligned cluster of spins, we generate an ensemble of clusterings ( Potts spin configurations {S}), each with weight

$$
P ( \{ \S \} ) \circ x \, e ^ { - \tilde { \ } N ( \langle \S \rangle ) / T }
$$

and measure the ensemble average of various properties of the resulting equilibrium problem. The temperature T controls the resolution at which we cluster the data; the simulations and measurements are carried out for a range of temperatures. We denote by (A) the ensemble average of the property A. The following properties of

We denote by (A) the ensemble average of the property A. The following properties of the system are measured:

Magnetization, M = (m) where

$$
m ( \{ S \} ) = \frac { q \, N _ { \max } ( \{ S \} ) - N } { ( q - 1 ) \, N } & & ( 3 )
$$

with

$$
N _ { \max } ( \{ S \} ) = \max \left \{ N _ { 1 } ( \{ \hat { S } \} ) , \, N _ { 2 } ( \{ S \} ) , \dots \, N _ { q } ( \{ S \} ) \right \} \, ,
$$

where N,({S}) = ~i 5s,,, is the number of spins with the value #. As the temperature increases from T = 0 to T = c~, M varies from 1 to 0, via one or more sharp ~' phase transitions. Susceptibility:

Susceptibility:

$$
\chi = \frac { N } { T } \left ( \left \langle m ^ { 2 } \right \rangle - \left \langle m \right \rangle ^ { 2 } \right ) \, ,
$$

[Page 5]

At low T the system is fully magnetized and the fluctuations in m are negligible. As T increases to the poit where the single cluster breaks into sub-clusters (or becomes completely disordered) fluctuations become very large. Hence we expect to identify the transitions at which clusters break up by sharp peaks of the susceptibility. Correlation function for pairs of neighboring 4 spins:

Correlation function for pairs of neighboring 4 spins:

$$
G _ { i j } = \langle \delta _ { s _ { i } , s _ { j } } \rangle \ ,
$$

# 2 Identifying Data sretsulC

Our startegy is to vary T and measure x(T). Transitions show up as peaks of ;X at temperatures between transitions we expect to observe relatively stable phases that correspond to some clusters being ordered internally and uncorrelated with other clusters. Within each such phase we measure jiG for all neighboring pairs of spins. The value of the correlation function Gij is the probability to find the two Potts spins Si and Sj in the same state; we interpret this as the probability of finding data points i, j in the same cluster. By the relation to granular ferromagnets we expect that the distribution of j,G is bimodal; if both spins belong to the same deredro grain (cluster), their correlation is close to ;1 if they belong to two clusters that are not relatively ordered, the correlation is close to zero. Rather than thresholding the secnatsid between pairs of points to decide their assignment to clusters, we use the pair correlations, which reflect a evitcelloc aspect of the data's distribution near the two points. The bimodality of the distribution of G and the fact that grains order at sharp phase transitions makes our methos much more robust and insensitive to the precise choice of various parameters. Clusters are identified in three steps.

Clusters are identified in three steps.

( procedure; if G > 0 a link is set between the neighbor data points v and vj. The resulting connected graph depends 1 and weakly on the value ( used in this thresholding, as long as it is bigger than less than 1 2 The reason is, as was pointed out above, that the distribution of the q correlations between two neighboring spins peaks strongly at these two values and is very small between them. ( Capture points lying on the periphery of the clusters by linking each point i to its

Capture points lying on the periphery of the clusters by linking each point i to its neighbor j of maximal correlation Gq. It may happen, of course, that points i and j were already linked in the previous step.

Data clusters are identified as the linked components of the graphs obtained in steps 1,2.

# 3 Applications

The method was tested on a large number of artificial and real data[6]. Here I review (for illustrative purposes) a simple example, taken from Botany (the Iris data); a very difficult problem from speech recognition (ISOLET data) and an example from computer vision and image processing, which demonstrates how a powerful clustering technique can

4 There are many w to d the neighbors of a data p

[Page 6]

![The image is a scatter plot with a categorical scale starting at 0 and ending at 10 on the y-axis, labeled second principal component. The x-axis is labeled first principal component, and the y-axis is labeled second principal component. There are four different categories on the x-axis, each represented by a different color: red, blue, green, and yellow. The plot has a legend at the top of the image that is labeled second principal component. The legend is circular and contains a small circle in the center. The circle is labeled first principal component. The plot contains four different categories on the x-axis: red, blue, green, and yellow. These categories are represented by different colors: red, blue, green, and yellow. The plot contains four different categories on the y-axis: red, blue, green, and yellow. These categories are represented by different colors: red, blue,](images/imageFile1.png)

# 3.1 Iris Data

The first "real" example we present is the time-honored Anderson Fisher Iris data, which has become a popular benchmark problem for clustering procedures. It consists of measurement of four quantities, performed on each of 1 f The specimens were chosen from three species of Iris. The data constitute 1 points in four-dimensional space. From the projection on the plane spanned by the first two principal components, pre-

sented on f ,1 we observe that there is a well separated cluster (corresponding to the Iris Setosa species) while clusters corresponding to the Iris Virginia and Iris Versieolor do overlap.

5.0

o

•

(5

•

4.0

o o

o

a

AA

E

00~0 °

°

HOG

•

•

8

o

a~ a

a a

~

&&

~3.0

oo

~\_

0%

~cp

~,,,, &

D

~a

a a

&

0

2.0

[1

Iris

Setosa

0

Iris

Versicolor

Virginica

• Iris

L

1"02.0

L 4.0

0

8~0

10.0

first

principal component

F .1 Projection of the Iris data on the plane spanned by its t principal components.

We determined neighbors in the D = 4 dimensional space according to the mutual K (K=5) nearest neighbors definition[6]; applied the SPC method and obtained the susceptibility curve of Fig. 2(a); it clearly shows two peaks! When heated, the system first breaks into two clusters at T ~ 0 At T = 0 we obtain two clusters, of sizes 80 and 4 points of the smaller cluster correspond to the species Iris Setosa. At T ~ 0 another transition occurs, where the larger cluster splits to two. At T = 0.7 we identified clusters of sizes 4 4 and 3 corresponding to the species Iris Versicolor, Virginica and Setosa respectively. 521 samples were classified correctly (as compared with manual classification); 2 were

left unclassified. No further breaking of clusters was observed; all three disorder at ,.pT 0.8 (since all three are of about the same density).

[Page 7]

(•) 0

0.15

0.1o

50.0

,

.

~

,

-

-

,

=

,

•

J

o.o

10

(b)

150 [

~

0.(]~

40.0

8

100

p

5o

Varskcobr

:

Seto~a

......

60.0

,

•

60.0

,

01.0

.

clusler

cluslør

duster

clustør

Set~a

Versicobr

00.0

0.0'2

40.0

T

60.0

80.0

01.0

F .2 ( The s d N ~ a a f of the temperature and )b( the size of the f b c o at e temperature f the I data.

# 3.2 Isolated Letter Speech Recognition (ISOLET)

In the isolated-letter speech recognition task, the "name" of a single letter i pronounced by a speaker. The resulting audio signal i recorded for a letters of the English alphabet for many speakers. The task i to f the structure of the data, which i expected to be a hierarchy reflecting the similarity that exists between different groups of letters, such as {B, D} or {M, N} which d only in a s articulatory feature. This analysis could be u for instance, to determine to what extent the chosen features succeed in differentiating the spoken letters. We used the ISOLET database of 7 examples created by Ron Cole[ll] which i

available at the UCI machine learning repository. The data w recorded from 051 speakers balanced for sex and representing many different accents and English dialects. Each speaker pronounce each of the 2 letters twice (there are 3 examples missing). Cole's group has developed a set of 6 features describing each example. All attributes are continuous and scaled into the range -1 to .1 The features include spectral c contour features, sonorant, pre sonorant, and post sonorant features. The order of appearance of the features i not known. We applied the SPC method at a s of temperatures. The resulting hierarchical

We applied the SPC method at a series of temperatures. The resulting hierarchical partitioning of the data is presented in fig. 3.

projections succeeded to reveal any relevant characteristic about the structure of the data. In assessing the extent to which the SPC method succeeded to recover the structure of the data, w built a "true" hierarchy by using the known labels of the examples. To do this, w first calculate the center of each class (letter) by averaging over a the examples belonging to it. Then a matrix 2 x 2 of the distances between these centers i constructed. Finally,

[Page 8]

ABCDEFGHIJKLMNOPQRSTUVWXYZ

ABCDEFGHIJKLMNOPQRSTUVXYZ

~

A.coEFo.J ,..opsTvxz

Ou,

i

i

Y

HFSX

ABCDEGJKLMNOPTVZ

I

ABCDEG,JKMNPTVZ

H

FSX

LO

I

M- M ~ N

ABCDI~GJKPTVZ

W

w

ABDEGJKPTV

BDEG~ J v~

J

v~

BDEGPTV

JK

G~i--"

CZ

cz

M

L

0

W

Q

U

P~ra

:/ .0~¢

aK

A c

L

H F

X

R

Y

F .3 I letter s h obtained by the Super-Paramagnetic m

The purity of the clustering was again very high ( and 3 of the samples w l as u points.

# 3.3 Computer Vision Clustering of Images

In the standard definition of the clustering problem, N data points are s in terms of their coordinates in a D-dimensional space. Mapping an image into such a space, where D i not too large, would require the computation of D measurements (or "features") that completely describe the image. This challenge has proved an e task. The task of image comparison, on the other hand, i more f rather than look for an explicit representation of images as vectors, one compares two images, that are f as input to an algorithm which returns as output the similarity between them. Such an algorithm, based on contour matching, was designed recently by Gdalyahu and Weinshall [ They collected 9 images of 6 different objects; toy models of a c w hippopotamus, two different cars, and a boy. Each object contributed 51 images, taken from different points of view (in a sector range of 4 ° azimuth and 2 ° elevation). The 9 × 9 dissimilarity matrix was computed for the database of 9 images; this matrix constitutes the input to the Superparamagnetic Clustering algorithm. The dissimilarities are used as the distances which, in turn, d the strength of the interactions between the pairs of spins associated with every image. The corresponding ferromagnetic system was now brought to thermal equilibrium. As the temperature was raised w measured the susceptibility X ( the fluctuation of

As the temperature was raised we measured the susceptibility X (i.e. the fluctuation of the system's magnetization), presented in Fig. 4. x(T) exhibits sharp features (peaks), which signal fairly sharp transitions. The different "phases" lie between the peaks. As outlined above, we measured the pair correlations in the various phases and used them to identify our clusters.

[Page 9]

60.0

0.04

Z

I--

0.02

/

00.0 0

0.00

T~

T~

T~

50.0 T

T

T 4

0.10

F .4 Susceptibility of the magnet constructed by associating with each of N = 09 images a spin and introducing ferromagnetic interactions between n w strength d with the "distance": At very wol temperatures all images belong to a s c As the temperature i the susceptibility exhibits pronounced peaks at T w correspond to a hierarchical breaking up of this cluster as indicated in F .5

At the lowest T all points belong to a single cluster. As shown in Fig. 5 when T increases to the value of the first, largest peak of ,X this cluster breaks up into three smaller ones, with 4 3 and 51 points; these contain, respectively, the 45 images of the three animals, the two cars ( and the boy (15)! that i the first level of clustering distinguished animals from humans and from cars. At the next transition the cluster of the 4 animals breaks into one of 30 (the hippo and cow) and one of 51 (the wolf), followed by separation into hippo, cow and w Finally, at the highest transition the cluster of the two cars breaks into two separate clusters. Thus, our clustering method was able not only to identify the images taken from the 6 objects as 6 different clusters, but it also yielded a reasonable hierarchical organization of the similarities of these images. Furthermore, we experimented with two slightly different versions of the curve matching

method which gave somewhat different dissimilarity matrices. The results shown here correspond to one of these the other gave similar end results ( clusters of 51 images in each), but the hierarchical structure was less in accord with human intuition. We mention this finding since it indictes the possibility of using the clustering method to select one of many alternative image comparison procedures, or even to optimize the parameters of the curve matching method. In other words, the clustering results can be used to learn the "correct" similarity function, which has been previously assumed to be given.

# 3 C Protein Structures

One of the most promising approaches taken in protein folding is based on classification of proteins by their chemical sequence and structure. Various groups have introduced different schemes to compare structures of two proteins and to measure a similarity index. Each group then proceeds to generate a tree or dendrogram that reflects the manner in which the proteins' structures are organized.

[Page 10]

ALL

PICTURES

(90)

ANIMALS

(45)

(30)

CARS

(30)

I

T1

I

T2

I

T3

I

T4

T

Fig. 5 The dendrogram produced by paramagnetic clustering from the distance matrix that was obtained by pairwise comparison of 9 images of 6 objects. At 1T 3 groups were identified, separating the pictures of the boy, animals, and cars. At ,2"7 3T the animal group was segmented into 3 sub-groups, corresponding to the pictures of the c wolf and hippo. Finally, at 4T the car group was segmented into 2 groups, each containing pictures of a different car. The final automatic classification is 1 correct, and the hierarchy reflects the true structure in the database.

We considered two different schemes: the FSSP (Fold classification based on StructureStructure alignment of Proteins) of Holm and Sander[15] database which provides paiwise similarities of about 1200 chains, and the CATH hierarchy[16] which arranges singledomain chains in a hierarchy according to their Class, Architecture, Topology and Homologous superfamily. We concentrated on the first two identifiers: class and architecture, and investigated the extent to which the clusters derived on the basis of the FSSP distance measure are consistent with the CATH classification. There are 479 proteins that appear in the FSSP database and also have been classified by CATH; these can serve to assess the agreement between the two. If we find that the two agree, we can propose the CATH classification for 165 proteins which also appear in the FSSP (but not in CATH) and have been identified as single-domain chains by the 3Dee database. By applying the SPC on the FSSP similarity matrix, we were able[17] to assign 80 %

By applying the SPC on the FSSP similarity matrix, we were able[17] to assign 80 % of the proteins to almost pure clusters that belonged to a single C,A category of CATH.

[Page 11]

Hence w expect that our success rate on the 561 single-domain proteins that have not yet been c by CATH to be around 8 % as w

# 3.5 fMRI Images

The last application presented here i still in progress; this work i done in collaboration with K.Grill-Spector and R. Malach, who collect fMRI data from subjects who are presented with various complex visual stimuli in the course of a s The neural activity of f s of the brain i recorded. By clustering temporal sequences of neural activity one hopes to identify anatomic regions that contain volume elements with similar functions (such as sensitivity to objects, to vertical or horizontal f of vision, etc. This work has yielded so far promising results, which w be presented e

# 4 Summary

Clustering i an important method in exploring the underlying structure of all kinds of data. There i a wide range of applications, both direct, as those r above and indirect. For example, once the underlying structure has been i by such an unsupervised technique, it i much easier to design a c (by a neural network or other method) to partition the data into clusters. For example, it would be quite d to train a neural net to partition the ISOLET data with more than 6 input features. Once w s the tree of Fig3, it i clear that one should f identify "W"; this i probably a very easy task. The remaining data should be submitted to a "QU detector" and those points that w c as "Q" or "U" are the presented to a sub-network that i trained only on such data, to separate the "Q" from the "U", etc. This way the knowledge acquired by the clustering procedure i used to break a large complex problem down into a hierarchy of small, manageable sub-problems. Another indirect use of the method w mentioned in section3.3. The experts who pre-

process the data must decide which aspects are important for classification and which are l important, what weight should be given to different features, etc. If their output ( the form of coordinates of individual points or pairwise distance matrices) i fed into the clustering algorithm and the resulting structure i f back to the preprocessing experts, they may use the information to improve and fine-tune their d Finally our method i a direct application of knowledge and expertise gained by

studying the statistical mechanics of model disordered ferromagnets. Perhaps one of the most important l i that one can never know which s and r applications w grow out of "curiosity driven" basic theoretical research.

# Acknowledgements

I benefited immensely from collaboration with my students, Marcelo Blatt, Shai Wiseman and, more recently, Gaddy Getz and Noam Shental. The work on images i the result of a most pleasant collaboration with two open-minded computer scientists: Daphna Weinshall and Yoram Gdalyahu. The fMRI work required considerable patience on the part of Kalanit Grill-Spector and Raft Malach. Discussions with s colleagues are warmly

[Page 12]

# References

- ]1[ Pattern Classification and Scene Analysis, R.O. Duda and P.E. Hart, Wiley, New York 1 K. Fukunaga, Introduction to statistical Pattern Recognition, (Academic Press, San Diego), 1
- ]2[ V. Faber, J. G. Hochberg, P. M. Kelly, T. R. Thomas and J. M. White, Los Alamos Science No. 2 321 (
- ]3[ A.K. Jain and R.C. Dubes, A for C D (Prentice Hall, Englewood C N J, 1
- ]4[ J.M. Buhmann and H. Kiihnel, IEEE T I T 39, 1133 (
- ]5[ M. Blatt, S Wiseman and E. Domany, P R L 76, 3251 (
- ]6[ M. Blatt, S Wiseman and E. Domany, N C 9 1805 (
- ]7[ K. Rose, E. Gurewitz and G. C. Fox, P R L 65,(1990).

S. P. Lloyd, IEEE Transactions on Information Theory 28, 129 (1982).

]9[ M. Blatt, Ph.D. Thesis, Weizmann Inst. of Science ( J. Schneider, Phys. Rev. E 57, 2 (

]01[ S Wang, and R.H. Swendsen, Physica A 167, 5 (

]11[ M. Fanty and R. Cole, A in N I Processing Systems 3 2 ( Lippmann, Moody and Touretzky, eds., Morgan-Kaufmann, San Mateo. P. M. Murphy and D. W. Aha, U r of m learning d http://www.ics.edu/mlearn/MLReposit ory.ht ml ]21[ J. H. Friedman, 82, 2 (

J. H. Friedman, Journal of the American statistical association 82, 249 (1987).

Y. Gdalyahu and D. Weinshall, Local Curve Matching for Object Recognition without Prior Knowledge. Proceedings: DARPA Image Understanding Workshop, New-Orleans, May 1997.

]41[ M. Blatt, Y. Gdalyahu, D. Weinshall and E. Domany, NIPS98 (submitted, 1

]51[ L. Holm and C. Sander, Science 273 5 ( The FSSP database is available on-line at http://www.sander.embl-heidelberg.de/fssp/database

]61[ C. A Orengo, A. D. Michie, S Jones, M.B. Swindells and J.M. Thornton, Structure 5 : 1 ( The CATH database is available on-line at ht tp://www.biochem.ucl.ac.uk/bsm/cath/ ]71[ G. Getz, M. Vendruscolo and E. Domauy (unpublished).

G. Getz, M. Vendruscolo and E. Domauy (unpublished).

]81[ K. Grill-Spector,T. Kushnir, T. Hendler, S Edehnan, Y. Itzchak and R. Malach, HBM (Oct. 1 can be obtained from http://www.wisdom.weizmann.ac.il/kalanit
