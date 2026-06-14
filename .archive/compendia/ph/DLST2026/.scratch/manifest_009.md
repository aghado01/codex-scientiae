# Manifest: Page 009

## REPAIR_MATH
- RAW: ```
H ( N _ { 2 } , N _ { 0 } ) & \longrightarrow H ( N _ { 2 } , N _ { 1 } ) & [ 0 , 0 , k ] & \stackrel { [ 0 , 0 , I d ] } { \longrightarrow } [ 0 , k , k ] \\ & \stackrel { \longmapsto } { \sim } \stackrel { \uparrow } { \stackrel { \longmapsto } { I } } & \cong & \stackrel { \longmapsto } { \stackrel { \uparrow } { \longrightarrow } } & \stackrel { \uparrow } { \stackrel { \longmapsto } { I } } & ( 2 . 1 ) \\ & \stackrel { H ( N _ { 1 } , N _ { 0 } ) } { \longrightarrow } & [ k , 0 , 0 ]
```
  FIX: ```
\[
\begin{aligned}
H ( N _ { 2 } , N _ { 0 } ) & \longrightarrow H ( N _ { 2 } , N _ { 1 } ) & [ 0 , 0 , k ] & \stackrel { [ 0 , 0 , I d ] } { \longrightarrow } [ 0 , k , k ] \\ 
& \stackrel { \longmapsto } { \sim } \stackrel { \uparrow } { \stackrel { \longmapsto } { I } } & \cong & \stackrel { \longmapsto } { \stackrel { \uparrow } { \longrightarrow } } & \stackrel { \uparrow } { \stackrel { \longmapsto } { I } } \\ 
& \stackrel { H ( N _ { 1 } , N _ { 0 } ) } { \longrightarrow } & [ k , 0 , 0 ]
\end{aligned}
\tag{2.1}
\]
```
- RAW: ```
N _ { 0 } & \coloneqq \{ a , b , c , d , a b , b c , c d , a d \} , \\ N _ { 1 } & \coloneqq N _ { 0 } \cup \{ e \} , \\ N _ { 2 } & \coloneqq N _ { 1 } \cup \{ a e , b e , c e , d e , a b e , b c e , c d e , a d e \} .
```
  FIX: ```
\[
\begin{aligned}
N_0 &\coloneqq \{ a, b, c, d, ab, bc, cd, ad \}, \\
N_1 &\coloneqq N_0 \cup \{ e \}, \\
N_2 &\coloneqq N_1 \cup \{ ae, be, ce, de, abe, bce, cde, ade \}.
\end{aligned}
\]
```
- RAW: `Define N 0 as the blue ring and N 2 as the brown disc in the left panel of Figure 5 . Let N 1 be the union of N 0 and the light brown disc in the right panel. In particular, we have N 0 ⊂ N 1 ⊂ N 2 .`
  FIX: `Define \( N_0 \) as the blue ring and \( N_2 \) as the brown disc in the left panel of Figure 5 . Let \( N_1 \) be the union of \( N_0 \) and the light brown disc in the right panel. In particular, we have \( N_0 \subset N_1 \subset N_2 \).`
- RAW: `As discussed earlier, R in λ = 0 continues to the invariant disc at λ = 1that is, the union of E , O and the trajectories connecting them—because both sets are isolated by a common isolating block N 2 .`
  FIX: `As discussed earlier, \( R \) in \( \lambda = 0 \) continues to the invariant disc at \( \lambda = 1 \) that is, the union of \( E \), \( O \) and the trajectories connecting them—because both sets are isolated by a common isolating block \( N_2 \).`
- RAW: `With N 1 and N 0 , we can decompose the Conley index of R as follows.`
  FIX: `With \( N_1 \) and \( N_0 \), we can decompose the Conley index of \( R \) as follows.`
- RAW: `First, observe that B E : = cl( N 1 \ N 0 ), B O : = cl( N 2 \ N 1 ), and B R : = cl( N 2 \ N 0 ) are isolating blocks for E , O , and R , respectively.`
  FIX: `First, observe that \( B_E := \operatorname{cl}(N_1 \setminus N_0) \), \( B_O := \operatorname{cl}(N_2 \setminus N_1) \), and \( B_R := \operatorname{cl}(N_2 \setminus N_0) \) are isolating blocks for \( E \), \( O \), and \( R \), respectively.`
- RAW: `However, we can compute the Conley index directly using N 0 , N 1 and N 2 .`
  FIX: `However, we can compute the Conley index directly using \( N_0 \), \( N_1 \) and \( N_2 \).`
- RAW: `By the excision property, we have H ( N 2 ,N 0 ) ∼ = H ( B R ,B − R ); similarly, H ( N 1 ,N 0 ) ∼ = H ( B E ,B − E ) and H ( N 2 ,N 1 ) ∼ = H ( B O ,B − O ) for B E and B O .`
  FIX: `By the excision property, we have \( H(N_2, N_0) \cong H(B_R, B_R^-) \); similarly, \( H(N_1, N_0) \cong H(B_E, B_E^-) \) and \( H(N_2, N_1) \cong H(B_O, B_O^-) \) for \( B_E \) and \( B_O \).`
- RAW: `In particular, we see that the degree-2 generator of R is mapped into the Conley index of O .`
  FIX: `In particular, we see that the degree-2 generator of \( R \) is mapped into the Conley index of \( O \).`
- RAW: `Both properties are illustrated in diagram ( 2.1 ): first, because the degree-2 generator is mapped from R to O ; second, two new generators, of degree-0 and 1, are born together during the split.`
  FIX: `Both properties are illustrated in diagram ( 2.1 ): first, because the degree-2 generator is mapped from \( R \) to \( O \); second, two new generators, of degree-0 and 1, are born together during the split.`
- RAW: `Figure 6 shows a combinatorial version of that bifurcation. In particular, it is the top view of the octahedron in Figure 4 , where point e corresponds to the vertex at the north pole. The combinatorial counterparts of N 0 , N 1 and N 2 are`
  FIX: `Figure 6 shows a combinatorial version of that bifurcation. In particular, it is the top view of the octahedron in Figure 4 , where point \( e \) corresponds to the vertex at the north pole. The combinatorial counterparts of \( N_0 \), \( N_1 \) and \( N_2 \) are`
- RAW: `Moreover, E = N 1 \ N 0 , R = N 2 \ N 0 , and O = N 2 \ N 1 are combinatorial isolating blocks (see Definition 4.2 ) for the corresponding combinatorial isolated invariant sets.`
  FIX: `Moreover, \( E = N_1 \setminus N_0 \), \( R = N_2 \setminus N_0 \), and \( O = N_2 \setminus N_1 \) are combinatorial isolating blocks (see Definition 4.2 ) for the corresponding combinatorial isolated invariant sets.`
