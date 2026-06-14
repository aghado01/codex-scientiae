

![The image depicts a geometric figure with several points and lines. The diagram is a section of a graph or a diagram, and it is labeled as follows: - **Points and Lines**: - The diagram consists of a series of points and lines. - The points are labeled as follows: - **Point A**: Located at the top left corner of the diagram. - **Point B**: Located at the top right corner of the diagram. - **Point C**: Located at the bottom left corner of the diagram. - **Point D**: Located at the bottom right corner of the diagram. - **Point E**: Located at the bottom center of the diagram. - **Point F**: Located at the top center of the diagram. - **Point G**: Located at the top center of the diagram. - **Point H**: Located at the top center of the diagram. - **Point I**: Located at the top center of the diagram.](<AL2026/imageFile1.png>)







sk( I


)





{



}




{



}

,

{



}







{



}

{



}













sc( I


)





Fig. 1 Illustration of notations

More precisely, if we let the poset \( P \) be the set \( [n] \) together with the natural number ordering, \( F \) a \( P \)-filtration, and \( M := H_q( ; k ) \circ F \) the \( q \)-th persistent homology, then the multiplicity of each interval \( I := \{ x \in P \mid s \leq x \leq t \} \subseteq P \) (\( [s,t] \) for short) appearing in the \( q \)-th persistence barcodes of \( M \) is given by

\[
\mu _ { M } ( I ) = \text {rank} \, M ( p _ { t , s } ) - \text {rank} \, M ( p _ { t , s - 1 } ) - \text {rank} \, M ( p _ { t + 1 , s } ) + \text {rank} \, M ( p _ { t + 1 , s - 1 } ) \tag{1.1}
\]

where \( \mu_M(I) := d_M(V_I) \) denotes the multiplicity of \( I \), and \( \text{rank} \, M(p_{t,s}) \) denotes the rank of the linear map \( M(p_{t,s}) : M(s) \to M(t) \). As a demonstration, in Fig. 2 we consider the multiplicity of interval \( [3, 4] \). The intervals that appear in the righthand side of (1.1) are illustrated in the violet color. It is straightforward to see that \( \text{rank} \, M(p_{4,3}) = 2 \), \( \text{rank} \, M(p_{4,2}) = \text{rank} \, M(p_{5,3}) = 1 \), and \( \text{rank} \, M(p_{5,2}) = 0 \), thus \( \mu_M(I) = 0 \) follows by (1.1). The reader can similarly check by (1.1) that multiplicities of intervals \( [2, 4] \) and \( [3, 5] \) are both \( 1 \), and other intervals have zero multiplicities.

We recall that meanings of the multiplicity and the rank are different. The multiplicity of an interval \( [s,t] \) in persistence barcodes indicates the number of generators of homology that are newly born at \( s \) (do not exist before \( s \)) and die at \( t \) (do not exist after \( t \)), persisting from \( s \) to \( t \), while the rank along \( [s,t] \) only counts the number of generators of homology that persist from \( s \) to \( t \) without caring those generators whether are newly born or eventually die at endpoints. In other words, the rank (or persistent Betti number) along an interval \( [s,t] \) only needs the information of \( [s,t] \), but the multiplicity needs extra information of \( [s,t] \) that is recorded in a larger interval \( [s-1, t+1] \) which contains \( [s,t] \).
