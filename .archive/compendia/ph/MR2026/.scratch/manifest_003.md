# Manifest: Page 003

## REPAIR_MATH
- RAW: ```
$$
L = \sum _ { i = 1 } ^ { m } \ell _ { i } . \\ \\ L = \sum _ { i = 1 } ^ { m } \ell _ { i } .
$$
```
  FIX: ```
\[
L = \sum_{i=1}^{m} \ell_i.
\]
```

- RAW: ```
$$
p _ { i } = \frac { \ell _ { i } } { L } ,
$$
```
  FIX: ```
\[
p_i = \frac{\ell_i}{L},
\]
```

- RAW: ```
$$
P E ( D ) = - \sum _ { i = 1 } ^ { m } p _ { i } \log p _ { i } . \\ \intertext { t h e n o r m a l i z e d } \intertext { t h e n o r m a l i z e d } \frac { \ p _ { i } \log p _ { i } } { \ } d i s t r i b u t i }
$$
```
  FIX: ```
\[
PE(D) = -\sum_{i=1}^{m} p_i \log p_i.
\]
```

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
# 2 Related work and state of the art
```
  FIX: ```
## 2 Related work and state of the art
```

- RAW: ```
# 2.1 Persistent entropy
```
  FIX: ```
### 2.1 Persistent entropy
```

- RAW: ```
Definition 1 (Persistent Entropy) . Let D = { ( b i ,d i ) } m i =1 be a persistence diagram in a fixed homological degree, with finite lifetimes ℓ i = d i − b i > 0 . Define the total lifetime
```
  FIX: ```
**Definition 1 (Persistent Entropy).** Let \( D = \{ (b_i, d_i) \}_{i=1}^m \) be a persistence diagram in a fixed homological degree, with finite lifetimes \( \ell_i = d_i - b_i > 0 \). Define the total lifetime
```

- RAW: ```
If m = 0 , we set PE ( D ) = 0 . Otherwise, define probabilities
```
  FIX: ```
If \( m = 0 \), we set \( PE(D) = 0 \). Otherwise, define probabilities
```
