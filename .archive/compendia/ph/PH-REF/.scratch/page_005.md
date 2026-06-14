[Page 5]

- a) For the radius r = 0, the union of balls is reduced to the initial ﬁnite set of point, each of them corresponding to a 0-dimensional feature, i.e. a connected component; an interval is created for the birth for each of these features at r = 0.
- b) Some of the balls started to overlap resulting in the death of some connected components that get merged together; the persistence diagram keeps track of these deaths, putting an end point to the corresponding intervals as they disappear.


![The image consists of a graph with two main components. The graph is titled C and has a horizontal axis labeled d and a vertical axis labeled c. The graph is divided into two parts, each with a different color. The first part of the graph is colored yellow and has a small blue dot at the top. The second part of the graph is colored red and has a small blue dot at the top. The graph has a horizontal axis labeled d and a vertical axis labeled c. The x-axis is labeled d and the y-axis is labeled c. The graph is divided into two parts, each with a different color. The first part of the graph is colored yellow and has a small blue dot at the top. The second part of the graph is colored red and has a small blue dot at the top. The graph is labeled as C and has a horizontal axis labeled d and a vertical](<PH-REF/imageFile2.png>)

c)

d)

- c) New components have merged giving rise to a single connected component and, so, all the intervals associated to a 0-dimensional feature have been ended, except the one corresponding to the remaining components; two new 1-dimensional features, have appeared resulting in two new intervals (in blue) starting at their birth scale.
- d) One of the two 1-dimensional cycles has been ﬁlled, resulting in its death in the ﬁltration and the end of the corresponding blue interval.


![The image is a diagram titled Premium Barbecue. It consists of a series of interconnected nodes and edges, each representing a different type of food item. The nodes are connected by edges, which represent the relationships between the nodes. The nodes are labeled with the following: - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a barbecue sauce. - **Premium Barbecue**: A type of food item that is typically served with a](<PH-REF/imageFile3.png>)

Persistence barcode

e)

Persistence diagram

e) all the 1-dimensional features have died, it only remains the long (and never dying) red interval. As in the previous examples, the ﬁnal barcode can also be equivalently represented as a persistence diagram where every interval ( a,b ) is represented by the the point of coordinate ( a,b ) in R 2 . Intuitively the longer is an interval in the barcode or, equivalently the farther from the diagonal is the corresponding point in the diagram, the more persistent, and thus relevant, is the corresponding homological feature across the ﬁltration. Notice also that for a given radius r , the k -th Betti number of the corresponding union of balls is equal of the number of persistence intervals corresponding to k -dimensional homological features and containing r . So, the persistence diagram can be seen as a multiscale topological signature encoding the homology of the union of balls for all radii as well as its evolution across the values of r .
