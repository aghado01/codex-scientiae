[Page 15]

In our general notation; the candidate models are indexed by k € % = {1,2, and hood assumed here will be that based on independent Gaussian noise:

$$
p(y \mid k, \theta^{(k)}) \propto \exp\!\left[-\frac{1}{2\sigma^2}\sum_{(u,v)}\bigl\{y(u,v) - h_{i(u,v)}\bigr\}^2\right]
$$

over all pixels.

The number of tiles k is modelled to have a Poisson distribution with parameter 2, truncated to k =1,2, Given k, the locations (ui, v) of the generating points are independently and uniformly distributed over the unit square representing the field of view, and prior kmax

The move types used in this problem correspond closely to H, and m = of 8 43; it is not computationally convenient to perform the analogue of P; to move generating point. However, the TILEA package includes routines for adding and deleting generating points, corresponding to birth and death of a and changing the height h; in one tile under detailed balance is entirely straightforward. To explain the birth and death transitions in more detail, some further notation is needed. Let the probabilities of proposing a birth or death when the current number of steps, namely tiles, is k be bk, dk respectively. Consider a proposed birth which would increase the number of steps from k to k+ 1, and suppose that the   new generating point is labelled k* . Its   location (uk*, Uk*) is drawn uniformly from the unit square, and the tessellation modified by the addition of this point; this modification is done on a trial basis; as this birth may not be accepted.  In the updated tessellation the new point has 'neighbours' (Green & Sibson; 1978), which we label as ie$. We compute the old and new areas of these tiles, and denote them by S; + t; and t; respectively. The total reduction Zie sS; gives the area of the tile of the new point k*. The height assigned to the new point is given by h* = hv, where ñ is the weighted geometric mean of the original heights for the neighbouring tiles: step,

$$
\tilde { h } = \left ( \prod _ { i \in \mathcal { I } } h _ { i } ^ { s _ { i } } \right ) ^ { 1 / \sum _ { i } s _ { i } } ;
$$

and v is drawn independently with density function f(v) = 5v4/(1 + v5)2, so that v has distribution symmetric about 0. Finally, the new heights for those tiles modified by the log addition are given by
