[Page 2]

Aluminium

Cobalt

Chromium

(a)

Copper

Nickel

Iron

![In this image there is a diagram with two parts. On the left side of the diagram there is a sphere with a number of small circles on it. On the right side of the diagram there are two balls.](<MNO2019/imageFile1.png>)

(b)

(c)

FIG. 1: (a) Image of APT data with atomic neighborhoods shown in detail on the left. Each pixel represents a diﬀerent atom, the neighborhood of which is considered. Certain patterns with distinct crystal structures exist, e.g., the orange region is copper-rich (left), but overall no pattern is identiﬁed. Putting a single atomic cubic unit cell under a microscope, the true crystal structure of the material, which could be either body-centered cubic (BCC) (b) or face-centered cubic (FCC) (c), is not revealed. This distinction is obscured due to further experimental noise. Notice there is an essential topological diﬀerence between the two structures in (b) and (c): The BCC structure has one atom at its center, whereas the FCC is hollow in its center, but has one atom in the center of each of its faces.

In this work, we speciﬁcally classify unit cells that are either body-centered cubic (BCC) or face-centered cubic (FCC). These lattice structures are the essential building blocks of HEAs [61] and have fundamental diﬀerences that set them apart in the case of noise-free, complete materials data. The BCC structure has a single atom in the center of the cube, while the FCC has a void in its center but has atoms on the center of the cubes’ faces, see Figure 1 (b-c). These two crystal structures are distinct when viewed through the lens of topology. Diﬀerentiating between the empty space and connectedness of these two lattice structures allows us to create an accurate classiﬁcation rule. This fundamental distinction between BCC and FCC point clouds is captured well by topological methods and explains the high degree of accuracy in the classiﬁcation scheme presented herein. Indeed, we oﬀer a Bayesian classiﬁcation framework for persistence homology.

Overall, topological data analysis (TDA) encompasses a broad set of techniques that explore topological structure in datasets [12,17,22,59]. One of these techniques, persistent homology, associates shapes to data and summarizes salient features with persistence diagrams – multisets of points that represent homological features along with their appearance and disappearance scales [17]. Features of a persistence diagram that exhibit long persistence describe global topological properties in the underlying dataset, while those with shorter persistence encode information about local geometry and/or noise. Hence, persistence diagrams can be considered multiscale summaries of data’s shape. While there are several methods present in literature to compute persistence diagrams, we adopt geometric complexes that are typically used for applications of persistent homology to data analysis in various settings such as handwriting analysis [2], studying of brain arteries [4,5], image analysis [7,10,11], neuroscience [3,14,54], sensor network [16,52], protein structure [20,31], biology [39,45,51], dynamical system [29], action recognition [58], signal analysis [34–36,47], chemistry [60], genetics [26], object data [46], etc.

Researchers desire to utilize persistence diagrams for inference and classiﬁcation problems. Several achieve this directly with persistence diagrams [6,9,19,35,40,41,49], while others elect to ﬁrst map them into a Hilbert space [1,8,18,48,57]. The latter approach enables one to adopt traditional machine learning and statistical tools such as principal component analysis, random forests, support vector machines, and more general kernel-based learning schemes. Despite progress toward statistical inference, to the best of our knowledge,
