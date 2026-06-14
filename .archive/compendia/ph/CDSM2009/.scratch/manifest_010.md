# Manifest: Page 010

## REPAIR_MATH
- RAW: ```
\begin{array} { r l r } { c _ { i } ^ { j k } } & { = } & { \dim ( ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) / ( ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) \cup ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) ) ) } \\ & { = } & { ( \dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) ) } \\ & { \quad - ( \dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k - 1 } ) ) , } \end{array}
```
  FIX: ```
$$
\begin{array} { r l r } { c _ { i } ^ { j k } } & { = } & { \dim ( ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) / ( ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) \cup ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) ) ) } \\ & { = } & { ( \dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) ) } \\ & { \quad - ( \dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k - 1 } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k - 1 } ) ) , } \end{array}
$$
```
- RAW: ```
\dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) = 1
```
  FIX: ```
$$
\dim ( R _ { i } ^ { j } \cap L _ { i } ^ { k } ) - \dim ( R _ { i } ^ { j - 1 } \cap L _ { i } ^ { k } ) = 1
$$
```
- RAW: `if and only if there is a k ≤ k such that low( T [ k ]) = j .`
  FIX: `if and only if there is a \( k \leq k \) such that \( \text{low}(T[k]) = j \).`
- RAW: `interval persistence of function f or − f .`
  FIX: `interval persistence of function \( f \) or \( -f \).`

## REPAIR_PROSE
- RAW: `# 7. REFERENCES`
  FIX: `## References`


- RAW: ```
![image 11](<CDSM2009/imageFile11.png>)

+




+


-


:

:






. . . 

. . . 








/

/



/

/



/

/



/

/


-









:

:




-


+


-



and therefore a proof of stability similar to the one in [9] follows.
```
  FIX: ```
![image 11](<CDSM2009/imageFile11.png>)

and therefore a proof of stability similar to the one in [9] follows.
```
