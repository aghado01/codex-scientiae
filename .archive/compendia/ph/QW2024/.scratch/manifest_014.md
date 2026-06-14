# Manifest: Page 014

## REPAIR_MATH
- RAW: ```
\begin{matrix} a & b & c \\ a \begin{pmatrix} 2 & - 1 & - 1 \\ - 1 & 2 & - 1 \\ c & - 1 & - 1 \end{pmatrix} . \end{matrix}
```
  FIX: ```
$$
\begin{matrix} a & b & c \\ a \begin{pmatrix} 2 & - 1 & - 1 \\ - 1 & 2 & - 1 \\ c & - 1 & - 1 \end{pmatrix} . \end{matrix}
$$
```
- RAW: ```
\begin{matrix} & & a b & b c & a c \\ & & a & & b c & a c \\ & & a \begin{pmatrix} - 1 & 0 & - 1 \\ & 1 & - 1 & 0 \\ & & c \begin{pmatrix} 0 & 1 & 1 \end{pmatrix} \end{matrix} ,
```
  FIX: ```
$$
\begin{matrix} & & a b & b c & a c \\ & & a & & b c & a c \\ & & a \begin{pmatrix} - 1 & 0 & - 1 \\ & 1 & - 1 & 0 \\ & & c \begin{pmatrix} 0 & 1 & 1 \end{pmatrix} \end{matrix} ,
$$
```
- RAW: ```
\begin{pmatrix} - 1 & 0 & - 1 \\ 1 & - 1 & 0 \\ 0 & 1 & 1 \end{pmatrix} \begin{pmatrix} - 1 & 1 & 0 \\ 0 & - 1 & 1 \\ - 1 & 0 & 1 \end{pmatrix} = \begin{pmatrix} 2 & - 1 & - 1 \\ - 1 & 2 & - 1 \\ - 1 & - 1 & 2 \end{pmatrix} .
```
  FIX: ```
$$
\begin{pmatrix} - 1 & 0 & - 1 \\ 1 & - 1 & 0 \\ 0 & 1 & 1 \end{pmatrix} \begin{pmatrix} - 1 & 1 & 0 \\ 0 & - 1 & 1 \\ - 1 & 0 & 1 \end{pmatrix} = \begin{pmatrix} 2 & - 1 & - 1 \\ - 1 & 2 & - 1 \\ - 1 & - 1 & 2 \end{pmatrix} .
$$
```
- RAW: ```
\begin{matrix} & & a b & b c & a c \\ & & a & & \\ & & & 0 & & - 1 \\ & & & 1 & & 0 \\ & & & & 0 & & 1 \end{matrix} ,
```
  FIX: ```
$$
\begin{matrix} & & a b & b c & a c \\ & & a & & \\ & & & 0 & & - 1 \\ & & & 1 & & 0 \\ & & & & 0 & & 1 \end{matrix} ,
$$
```

