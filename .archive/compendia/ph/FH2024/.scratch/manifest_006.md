# Manifest: Page 006

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
![image 2](<FH2024/imageFile2.png>)




···







-


















-



In this sequence, generators at time steps i and i + 1 that generate the same feature in X i ∪ X i +1 are said to belong to the same feature, but at different time steps.
```
  FIX: ```
![image 2](<FH2024/imageFile2.png>)

In this sequence, generators at time steps \( i \) and \( i + 1 \) that generate the same feature in \( X_i \cup X_{i+1} \) are said to belong to the same feature, but at different time steps.
```

- RAW: ```
Similarly to oneparameter modules,
```
  FIX: ```
Similarly to one-parameter modules,
```

## REPAIR_MATH
- RAW: ```
Y = \left \{ y \in \mathbb { R } ^ { d } \colon y = ( x _ { i } , \dots , x _ { i + ( d - 1 ) \tau } ) \right \}
```
  FIX: ```
$$
Y = \left \{ y \in \mathbb { R } ^ { d } \colon y = ( x _ { i } , \dots , x _ { i + ( d - 1 ) \tau } ) \right \}
$$
```

- RAW: ```
described by a socalled observation function , usually an univariate time series x = ( x 1 ,...,x n ) . The delay embedding of one observation function x is defined as
```
  FIX: ```
described by a so-called observation function, usually a univariate time series \( x = (x_1, \dots, x_n) \). The delay embedding of one observation function \( x \) is defined as
```

- RAW: ```
with embedding dimension d and delay parameter τ . According to Takens embedding theorem [37],
```
  FIX: ```
with embedding dimension \( d \) and delay parameter \( \tau \). According to Takens embedding theorem [37],
```

- RAW: ```
complexes of two neighboring point clouds X i and X i +1 ( i = 1 ,...,n − 1 ) into a bigger space X i ∪ X i +1 as follows:
```
  FIX: ```
complexes of two neighboring point clouds \( X_i \) and \( X_{i+1} \) \( (i = 1, \dots, n-1) \) into a bigger space \( X_i \cup X_{i+1} \) as follows:
```

- RAW: ```
To construct the simplicial complexes X i , the authors of [38] used Vietoris Rips complexes at specified radii ε i .
```
  FIX: ```
To construct the simplicial complexes \( X_i \), the authors of [38] used Vietoris Rips complexes at specified radii \( \varepsilon_i \).
```

- RAW: ```
where the superscript ε i denotes the scale of the Vietoris-Rips complex.
```
  FIX: ```
where the superscript \( \varepsilon_i \) denotes the scale of the Vietoris-Rips complex.
```
