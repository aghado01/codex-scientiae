# Manifest: Page 016

## REPAIR_PROSE
- RAW: ```
Mio







E(M)(7,2)=limM[2,7]


(a)









(b)

```
  FIX: ```
```

## REPAIR_MATH
- RAW: ```
In Figure 3, one can see examples of zigzag interval modules and the corresponding blocks after applying the block extension functor E . The differences for the four different types are shown.
```
  FIX: ```
In Figure 3, one can see examples of zigzag interval modules and the corresponding blocks after applying the block extension functor \(E\). The differences for the four different types are shown.
```
- RAW: ```
Lemma 4.3 Let M : ZZ → vec such that for all ⟨ a,b ⟩ ZZ , lim ←− M | ⟨ a,b ⟩ ZZ and lim −→ M | ⟨ a,b ⟩ ZZ are finite dimensional. Then, if M ∼ = ⊕ k ∈ K I ⟨ a k ,b k ⟩ ZZ then E ( M ) ∼ = ⊕ k ∈ K I ⟨ a k ,b k ⟩ BL .
```
  FIX: ```
Lemma 4.3 Let \(M : \text{ZZ} \to \textbf{vec}\) such that for all \(\langle a,b \rangle \in \text{ZZ}\), \(\lim_{\leftarrow} M |_{\langle a,b \rangle \text{ZZ}}\) and \(\lim_{\rightarrow} M |_{\langle a,b \rangle \text{ZZ}}\) are finite dimensional. Then, if \(M \cong \bigoplus_{k \in K} I_{\langle a_k,b_k \rangle \text{ZZ}}\) then \(E(M) \cong \bigoplus_{k \in K} I_{\langle a_k,b_k \rangle \text{BL}}\).
```
- RAW: ```
The next lemma shows how to actually calculate the components of E ( M ) and is crucial for the proof of the stability of persistence landscapes. In Figure 4, one can see how the components of E ( M ) for a zigzag module M are calculated.
```
  FIX: ```
The next lemma shows how to actually calculate the components of \(E(M)\) and is crucial for the proof of the stability of persistence landscapes. In Figure 4, one can see how the components of \(E(M)\) for a zigzag module \(M\) are calculated.
```
- RAW: ```
Lemma 4.4 For ( a,b ) ∈ op × , it holds that
```
  FIX: ```
Lemma 4.4 For \(( a,b ) \in \mathbb{Z}^{\text{op}} \times \mathbb{Z}\), it holds that
```
- RAW: ```
Furthermore, the structure maps of E ( M ) are the maps given by the universal properties of limits and colimits, respectively.
```
  FIX: ```
Furthermore, the structure maps of \(E(M)\) are the maps given by the universal properties of limits and colimits, respectively.
```
- RAW: ```
Proof: We first proof the part E ( M )( a,b ) = lim −→ M | [ a,b ] for a ≤ b . By definition of left Kan extensions,
```
  FIX: ```
Proof: We first proof the part \(E(M)(a,b) = \lim_{\rightarrow} M|_{[a,b]}\) for \(a \leq b\). By definition of left Kan extensions,
```
- RAW: ```
E ( M ) ( a , b ) = \begin{cases} \lim _ { \overleftarrow { \ll } } M | _ { [ a , b ] } & \text {for } a \leq b , \\ \lim _ { \overleftarrow { \ll } } M | _ { [ b , a ] } & \text {for } a > b . \end{cases}
```
  FIX: ```
$$
E ( M ) ( a , b ) = \begin{cases} \lim _ { \overleftarrow { \ll } } M | _ { [ a , b ] } & \text {for } a \leq b , \\ \lim _ { \overleftarrow { \ll } } M | _ { [ b , a ] } & \text {for } a > b . \end{cases}
$$
```
- RAW: ```
E ( M ) ( a , b ) = \varprojlim _ { 1 6 } M | \{ i \in \mathbb { Z } \, | \, \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \text {op} } \times \mathbb { Z } \} . \\
```
  FIX: ```
$$
E ( M ) ( a , b ) = \varprojlim _ { 1 6 } M | \{ i \in \mathbb { Z } \, | \, \iota ( i ) \leq ( a , b ) \in \mathbb { Z } ^ { \text {op} } \times \mathbb { Z } \} . \\
$$
```
