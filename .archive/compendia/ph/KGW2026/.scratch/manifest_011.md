# Manifest: Page 011

## REPAIR_PROSE
- RAW: ```
(a)


4 node-feedback loop


![The image depicts a mathematical problem involving a 3x3 grid. The grid is filled with a sequence of numbers, which are represented by arrows. The arrows are connected to each other, indicating that the values of the numbers are connected. The numbers in the grid are: 1. 1 2. 2 3. 3 4. 4 5. 5 6. 6 7. 7 8. 8 9. 9 10. 10 11. 11 12. 12 13. 13 14. 14 15. 15 16. 16 17. 17 18. 18 19. 19 20. 20 21. 21 22. 22 23. 23 2](<KGW2026/imageFile5.png>)

(b)


Bi-parallel


Figure 4: Digraphs used in Example 3.4

(c)



Bi-fan
```
  FIX: ```
![Figure 4: Digraphs used in Example 3.4: (a) 4 node-feedback loop (b) Bi-parallel (c) Bi-fan](<KGW2026/imageFile5.png>)
```

## REPAIR_MATH
- RAW: ```
It is known that standard path homology can distinguish certain motifs, such as the biparallel and the bi-fan structures. However, it fails to differentiate between others; in particular, the 4-node feedback loop and the bi-fan yield identical path homology groups. Similarly, the biparallel and the feed-forward loop are not distinguished by path complexes, as they also produce the same path homology. In contrast, Mayer path homology provides a finer invariant: for N = 3, it assigns distinct Betti numbers to each of these motifs, thereby distinguishing structures that are indistinguishable under standard path homology. This highlights the increased sensitivity of Mayer path homology in detecting higher-order structural differences in directed networks.
```
  FIX: ```
It is known that standard path homology can distinguish certain motifs, such as the biparallel and the bi-fan structures. However, it fails to differentiate between others; in particular, the 4-node feedback loop and the bi-fan yield identical path homology groups. Similarly, the biparallel and the feed-forward loop are not distinguished by path complexes, as they also produce the same path homology. In contrast, Mayer path homology provides a finer invariant: for \( N = 3 \), it assigns distinct Betti numbers to each of these motifs, thereby distinguishing structures that are indistinguishable under standard path homology. This highlights the increased sensitivity of Mayer path homology in detecting higher-order structural differences in directed networks.
```
- RAW: ```
Example 3.4. Let L 1 ,L 2 and L 3 be the digraphs as in Figure 4 with V to be common vertex set and E i be the edge set for each. For each cases Ω N 0 ( L i ) = Z 2 , 1 0 ( L i ) = Z 3 , 1 0 ( L i ) = Z 3 , 2 0 ( L i ) = < V > , Ω N 1 ( L i ) = Z 3 , 2 1 ( L i ) = < E i > where i = 1 , 2 , 3 . Observe that Ω N 2 ( L 1 ) = Ω N 2 ( L 3 ) = ∅ where Ω N 2 ( L 2 ) = ⟨ e 1 , 4 , 3 − e 1 , 2 , 3 ⟩
```
  FIX: ```
Example 3.4. Let \( L_1 \), \( L_2 \) and \( L_3 \) be the digraphs as in Figure 4 with \( V \) to be common vertex set and \( E_i \) be the edge set for each. For each cases \( \Omega_N^0(L_i) = Z_{2,1}^0(L_i) = Z_{3,1}^0(L_i) = Z_{3,2}^0(L_i) = \langle V \rangle \), \( \Omega_N^1(L_i) = Z_{3,2}^1(L_i) = \langle E_i \rangle \) where \( i = 1, 2, 3 \). Observe that \( \Omega_N^2(L_1) = \Omega_N^2(L_3) = \emptyset \) where \( \Omega_N^2(L_2) = \langle e_{1,4,3} - e_{1,2,3} \rangle \)
```
- RAW: ```
e _ { 1 , 2 } \, \ e _ { 1 , 4 } \, \ e _ { 3 , 2 } \, \ e _ { 4 , 3 } & & \ e _ { 1 , 2 } \, \ e _ { 1 , 4 } \, \ e _ { 3 , 2 } \, \ e _ { 3 , 4 }
```
  FIX: ```
$$
e _ { 1 , 2 } \, \ e _ { 1 , 4 } \, \ e _ { 3 , 2 } \, \ e _ { 4 , 3 } & & \ e _ { 1 , 2 } \, \ e _ { 1 , 4 } \, \ e _ { 3 , 2 } \, \ e _ { 3 , 4 }
$$
```
- RAW: ```
\Omega _ { 2 } ^ { ( N } ( L _ { 2 } ) } & = \, \begin{matrix} \xi _ { 1 , 4 , 3 } - e _ { 1 , 2 , 3 } \\ \\ \ e _ { 1 , 2 } & \ e _ { 1 , 4 } & \ e _ { 3 , 2 } & \ e _ { 4 , 3 } \\ \\ & & & \\ & e _ { 1 } & \left ( \begin{array} { c c c c } \xi & \xi & 0 & 0 \\ 1 & 0 & 1 & 0 \\ 0 & 0 & \xi & 1 \\ 0 & 1 & 0 & \xi \end{array} \right ) , & B _ { 1 } ( L _ { 3 } ) = \, \begin{matrix} e _ { 1 } & \xi & \xi & 0 \\ \xi & 0 & 0 & 0 \\ 1 & 0 & 1 & 0 \\ 0 & 0 & \xi & \xi \\ \end{matrix} \right ) \\ & & & e _ { 1 , 2 } & e _ { 1 , 4 } & e _ { 2 , 3 } & e _ { 4 , 3 } \\ & e _ { 1 } \left ( \begin{array} { c c c c } \xi & \xi & 0 & 0 \\ 1 & 0 & \xi & 0 \\ 0 & 0 & 1 & 1 \\ e _ { 2 , 3 } & 0 & 0 & \xi \\ 0 & 0 & 0 & \xi \end{array} \right ) , & B _ { 2 } ( L _ { 2 } ) = \, \begin{matrix} e _ { 1 , 2 } \\ \xi & \xi & 0 & 0 \\ \xi ^ { 2 } & 0 & \xi & \left ( \begin{array} { c } \xi & \xi & 0 & 0 \\ \xi ^ { 2 } & \end{array} \right ) \\ e _ { 4 } \left ( \begin{array} { c c c c } 0 & 0 & 1 & 1 \\ 0 & 0 & 0 & \xi \\ 0 & 1 & 0 & \xi \end{array} \right ) & & & e _ { 4 , 3 } \\ & & & e _ { 1 , 4 , 3 } = e _ { 1 , 2 , 3 } \\ & & & e _ { 1 } \left ( \begin{array} { c } 0 \\ - \xi ^ { 2 } - \xi \\ 0 \\ \xi ^ { 2 } + \xi \end{array} \right ) . \\ & & & B _ { 1 } B _ { 2 } ( L _ { 2 } ) = \begin{matrix} e _ { 2 } \\ e _ { 3 } \\ e _ { 4 } \end{matrix} \left ( \begin{array} { c } 0 \\ - \xi ^ { 2 } - \xi \\ \xi ^ { 2 } + \xi \end{array} \right ) .
```
  FIX: ```
$$
\Omega _ { 2 } ^ { ( N } ( L _ { 2 } ) } & = \, \begin{matrix} \xi _ { 1 , 4 , 3 } - e _ { 1 , 2 , 3 } \\ \\ \ e _ { 1 , 2 } & \ e _ { 1 , 4 } & \ e _ { 3 , 2 } & \ e _ { 4 , 3 } \\ \\ & & & \\ & e _ { 1 } & \left ( \begin{array} { c c c c } \xi & \xi & 0 & 0 \\ 1 & 0 & 1 & 0 \\ 0 & 0 & \xi & 1 \\ 0 & 1 & 0 & \xi \end{array} \right ) , & B _ { 1 } ( L _ { 3 } ) = \, \begin{matrix} e _ { 1 } & \xi & \xi & 0 \\ \xi & 0 & 0 & 0 \\ 1 & 0 & 1 & 0 \\ 0 & 0 & \xi & \xi \\ \end{matrix} \right ) \\ & & & e _ { 1 , 2 } & e _ { 1 , 4 } & e _ { 2 , 3 } & e _ { 4 , 3 } \\ & e _ { 1 } \left ( \begin{array} { c c c c } \xi & \xi & 0 & 0 \\ 1 & 0 & \xi & 0 \\ 0 & 0 & 1 & 1 \\ e _ { 2 , 3 } & 0 & 0 & \xi \\ 0 & 0 & 0 & \xi \end{array} \right ) , & B _ { 2 } ( L _ { 2 } ) = \, \begin{matrix} e _ { 1 , 2 } \\ \xi & \xi & 0 & 0 \\ \xi ^ { 2 } & 0 & \xi & \left ( \begin{array} { c } \xi & \xi & 0 & 0 \\ \xi ^ { 2 } & \end{array} \right ) \\ e _ { 4 } \left ( \begin{array} { c c c c } 0 & 0 & 1 & 1 \\ 0 & 0 & 0 & \xi \\ 0 & 1 & 0 & \xi \end{array} \right ) & & & e _ { 4 , 3 } \\ & & & e _ { 1 , 4 , 3 } = e _ { 1 , 2 , 3 } \\ & & & e _ { 1 } \left ( \begin{array} { c } 0 \\ - \xi ^ { 2 } - \xi \\ 0 \\ \xi ^ { 2 } + \xi \end{array} \right ) . \\ & & & B _ { 1 } B _ { 2 } ( L _ { 2 } ) = \begin{matrix} e _ { 2 } \\ e _ { 3 } \\ e _ { 4 } \end{matrix} \left ( \begin{array} { c } 0 \\ - \xi ^ { 2 } - \xi \\ \xi ^ { 2 } + \xi \end{array} \right ) .
$$
```

