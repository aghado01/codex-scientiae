[Page 17]

error , a boolean indicator of failure

β , the random variate. Only defined if not error .

- β curr ← β ̂
- for i ← 0 to MHI 1


$$
\beta _ { c u r r } & \leftarrow \beta \\ \text {for} & i \leftarrow 0 \, t o M H I - 1 \\ & \quad i t e r \leftarrow 0 , \, e r r o \leftarrow \text {false, exit} \leftarrow \text {false} \\ & \quad \text {repeat} \\ & \quad i t e r \leftarrow \text {iter} + 1 \\ & \quad z \sim N ( 0 , I ) \\ & \quad A \leftarrow \text {Solution to U} ^ { T } A = z . \\ & \quad \text {error} \leftarrow ( \text {unable to solve equation} ) \\ & \quad \text {exit} \leftarrow ( \text {not error} ) \, \text {or} \, ( \text {iter} \geq 2 0 ) ) \\ & \quad \text {until} \left ( \text {exit} \right ) \\ & \quad \text {if} \left ( \text {error} \right ) \text { exit} \\ & \quad \text {else} \\ & \quad \beta _ { c a n d } \leftarrow + \beta + A \\ & \quad \\ r & \leftarrow \log \left ( \frac { L \left ( k , \xi , \beta _ { c a n d } \right ) } { L \left ( k , \xi , \beta _ { c a n d } \right ) } \frac { \pi \left ( \beta _ { c a n d } | k , \xi \right ) } { \pi \left ( \beta _ { c u r } | k , \xi \right ) } \frac { \pi ^ { * } \left ( \beta _ { c u r } | k \right ) } { \pi ^ { * } \left ( \beta _ { c u r } | k \right ) }
$$

$$
r \leftarrow \log \left ( \frac { L ( k , \xi , \beta _ { c o n d } ) } { L ( k , \xi , \beta _ { c u r r } ) } \frac { \pi ( \beta _ { c o n d } | k , \xi ) } { \pi ( \beta _ { c u r r } | k , \xi ) } \frac { \pi ^ { * } ( \beta _ { c u r r } | k , \xi , D a t a ) } { \pi ^ { * } ( \beta _ { c o n d } | k , \xi , D a t a ) } \right )
$$

$$
\text {if} \left ( ( i = 0 ) \text { and } ( r > M H T ) \right )
$$

comment: Accept the initial variate. No additional Metropolis-Hastings steps.

$$
\begin{array} { l } { { c o m m e n t \colon A c c } } \\ { i \leftarrow M H I } \\ { u \leftarrow r - 1 . 0 } \\ { e l s e } \\ { u \leftarrow U ( 0 , 1 ) } \\ { u \leftarrow \log ( u ) } \\ { i f ( u < r ) } \\ { c o m m e n t \colon A c c } \end{array}
$$

comment: Accept the candidate β


$$
\beta _ { c u r r } \gets \beta _ { c a n d }
$$

- beta ← β curr .
- return


## Acknowledgments

Support for the current work was provided by NIMH Program Project MH56193. The authors are grateful for helpful comments from the referees.
