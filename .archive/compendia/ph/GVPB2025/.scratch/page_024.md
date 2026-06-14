[Page 24]

![Figure 13: Supplementary plots for Llama 2, Mistral, and Pythia on the SST dataset. The first row displays Inter-layer persistence, the second row shows the Births’ relative frequency, and the third row presents the effective persistent images.](<GVPB2025/imageFile14.png>)

Figure 13: Supplementary plots for Llama 2, Mistral, and Pythia on the SST dataset. The first row displays Inter-layer persistence, the second row shows the Births’ relative frequency, and the third row presents the effective persistent images.

##### G.2 Layer pruning algorithm

Here we schematically describe the algorithm for layer pruning used to produce results presented in Table 1.



**Algorithm 2** Pruning algorithm

**Require:** `model`, `threshold`
1. `layersToRemove` \( \leftarrow \) `[]`
2. **for** \( l \leftarrow 1 \) **to** `model.getNumLayers()` **do**
3. &nbsp;&nbsp;&nbsp;&nbsp;**if** \( Z_1[l] > \max * \text{threshold} \) **then**
4. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`layersToRemove.append(l)`
5. &nbsp;&nbsp;&nbsp;&nbsp;**end if**
6. **end for**
7. `model.removeLayers(layersToRemove)`


