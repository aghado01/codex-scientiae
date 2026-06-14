# Manifest: Page 024

## REPAIR_MATH
- RAW: ```
\begin{pmatrix} 0 1 2 & 0 2 3 \\ 0 1 & 1 & 0 \\ 1 & 1 & 0 \\ 1 & 0 & 1 \\ 0 & 1 & 0 \\ 0 & - 1 & 1 \end{pmatrix} .
```
  FIX: ```
$$
\begin{pmatrix} 0 1 2 & 0 2 3 \\ 0 1 & 1 & 0 \\ 1 & 1 & 0 \\ 1 & 0 & 1 \\ 0 & 1 & 0 \\ 0 & - 1 & 1 \end{pmatrix} .
$$
```
- RAW: ```
\begin{matrix} 0 1 2 & 0 2 3 \\ 0 2 \left ( \begin{array} { c c } - 1 & 1 \end{array} \right ) \end{matrix}
```
  FIX: ```
$$
\begin{matrix} 0 1 2 & 0 2 3 \\ 0 2 \left ( \begin{array} { c c } - 1 & 1 \end{array} \right ) \end{matrix}
$$
```
- RAW: ```
\begin{matrix} 0 1 2 & 0 2 3 + 0 1 2 \\ 0 1 & 1 & 1 \\ 1 & 1 & 1 \\ 0 & 1 & 0 \\ 0 & - 1 & 0 \end{matrix} .
```
  FIX: ```
$$
\begin{matrix} 0 1 2 & 0 2 3 + 0 1 2 \\ 0 1 & 1 & 1 \\ 1 & 1 & 1 \\ 0 & 1 & 0 \\ 0 & - 1 & 0 \end{matrix} .
$$
```
- RAW: ```
0 2 3 + 0 1 2 
 0 1 \left ( \begin{array} { c } 0 2 3 + 0 1 2 \\ 1 \\ 1 \\ 1 \\ - 1 \end{array} \right ) .
```
  FIX: ```
$$
0 2 3 + 0 1 2 
 0 1 \left ( \begin{array} { c } 0 2 3 + 0 1 2 \\ 1 \\ 1 \\ 1 \\ - 1 \end{array} \right ) .
$$
```

