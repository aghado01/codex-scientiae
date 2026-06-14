[Page 21]

![In this image, we can see a diagram with some text and numbers.](<FH2024/imageFile8.png>)







,



,



,



,



,








,



,



,



,



,








,



,



,



,



,








,



,



,



,



,








,



,



,



,



,


We connect the lower and upper fence by the path that goes through the next smaller square centered at the same point to implicitly compute the rank of the next smaller square. We repeat this procedure iteratively. This is based on the assumptions of Theorem 2.23, that state that the only condition for the intermediate path is that it has to connect the lower and the upper fence. As a result, for every point x we obtain one zigzag diagram along the path that contains the information of the rank of every square centered at point x . Such a path at point x = (4 , 4) would look like the red arrows in the following diagram.

![In this image, we can see a diagram. There are arrows in the image.](<FH2024/imageFile9.png>)









,



,



,



,



,



,



,










,



,



,



,



,



,



,










,



,



,



,



,



,



,










,



,



,



,



,



,



,










,



,



,



,



,



,



,










,



,



,



,



,



,



,










,



,



,



,



,



,



,


To compute all spatiotemporal persistence landscapes at all points x in the parameter space of size n × m , one has to calculate n · m barcodes. Since they are independent of each other this step can be parallelized. In view of Lemma 2.7 for the multiparameter persistence landscapes one has to compute only n + m − 1 barcodes.

For every zigzag path in the parameter space, we calculate the sequence of simplicial complexes along this path. Then, we calculate the barcodes along this paths using FastZigzag [8], an algorithm to obtain a barcode from a zigzag filtration in O ( k ω ) time, where k is the length of the input filtration and ω is the matrix multiplication exponent. Since FastZigzag requires a simplexwise filtration as input we convert every zigzag sequence into a simplexwise zigzag sequence. Unfortunately, in our case the length of the input filtration can get very large since when going from one to the next window we delete all simplices of one window and add all simplices of the next window. At worst case, the number of possible insertions or deletions for one arrow in the zigzag module could be 2 N with N being the number of points in the window. This is a very unlikely case, but in this case the length of the zigzag filtration is quadratic in min(2 t -1 , n ) , where n is the number of spatial parameter values ε 1 , ..., ε n and t number of windows. Furthermore, the length of the zigzag filtration is exponential in the number of points per window. From this we deduce that it is much more efficient to segment the time series such that we have as little points per windows as necessary. For periodic time series it means that one should aim to choose the window size as the length of the period.
