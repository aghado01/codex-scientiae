[Page 1]

![In this image I can see an apple and a table on which a cloth is placed. I can see the water.](<images/imageFile1.png>)

P -A ABSIL, R. MAHONY & R SEPULCHRE

[Page 2]

# Optimization   Algorithms   on   Matrix   Manifolds  

[Page 3]

# Optimization   Algorithms   on   Matrix   Manifolds  

P.-A.   Absil 


R.   Mahony 


R.   Sepulchre 


[Page 4]

Copyright c   2008 by Princeton University Press

Published by Princeton University Press 41 William Street, Princeton, New Jersey 08540

In the United Kingdom: Princeton University Press 3 Market Place, Woodstock, Oxfordshire OX20 1SY

All Rights Reserved

Library of Congress Control Number: 2007927538 ISBN: 978-0-691-13298-3

British Library Cataloging-in-Publication Data is available

This book has been composed in Computer Modern in L A T E X

The publisher would like to acknowledge the authors of this volume for providing the camera-ready copy from which this book was printed.

Printed on acid-free paper. ∞

press.princeton.edu

Printed in the United States of America

10 9 8 7 6 5 4 3 2 1

[Page 5]

# To   our   parents 


[Page 6]

# Contents  

|List   of   Algorithms  | | |xi  |
|---|---|---|---|
|Foreword,   by   Paul   Van   Dooren  | | |xiii  |
|Notation Conventions| | |xv|
|1. Introduction| | |1|
|2. Motivation and Applications| | |5|
|2.1|A case study: the eigenvalue problem| |5|
| |2.1.1|The eigenvalue problem as an optimization problem|7|
| |2.1.2|Some benefits of an optimization framework|9|
|2.2|Research problems| |10|
| |2.2.1|Singular value problem|10|
| |2.2.2|Matrix approximations|12|
| |2.2.3|Independent component analysis|13|
| |2.2.4|Pose estimation and motion recovery|12|
|2.3|Notes and references| |13|
|3. Matrix Manifolds: First-Order Geometry| | |14|
|3.1 Manifolds| | |16|
| |3.1.1|Definitions: charts, atlases, manifolds|17  |
| |3.1.2|The topology of a manifold*|20|
| |3.1.3|How to recognize a manifold|21|
| |3.1.4|Vector spaces as manifolds|20|
| |3.1.5|The manifolds R n × p ∗ and R n × p|21|
| |3.1.6|Product manifolds|22|
|3.2|Differentiable functions| |22|
| |3.2.1|Immersions and submersions|24|
|3.3|Embedded submanifolds| |24|
| |3.3.1|General theory|25|
| |3.3.2|The Stiefel manifold|25|
|3.4|Stiefel manifold| |26|
| |3.4.1|Theory of quotient manifolds|27|
| |3.4.2|Functions on quotient manifolds|29|
| |3.4.3|The real projective space RP n - 1|30|
| |3.4.4|The Grassmann manifold Grass( p,n )|30|
|3.5|and diﬀerential maps| |32|


[Page 7]

|viii 	| | |CONTENTS  |
|---|---|---|---|
| |3.5.1|Tangent vectors|33|
| |3.5.2|Tangent vectors to a vector space|35|
| |3.5.3|Tangent bundle|36|
| |3.5.4|Vector fields|36|
| |3.5.5|Tangent vectors as derivations ∗|37|
| |3.5.6|Differential of a mapping|38|
| |3.5.7|Tangent vectors to embedded submanifolds|39|
| |3.5.8|Tangent vectors to quotient manifolds|45|
|3.6|Riemannian|metric, distance, and gradients|47|
| |3.6.1|Riemannian submanifolds|48|
| |3.6.2|Riemannian quotient manifolds|48|
|3.7|Notes|and references|51|
|4.   Line-Search   Algorithms   on   Manifolds 	| | |54  |
|4.1|Retractions| |54|
| |4.1.1|Retractions on embedded submanifolds|56|
| |4.1.2|Retractions on quotient manifolds|59|
| |4.1.3|Retractions and local coordinates*|61|
|4.2| |Line-search methods|62|
|4.3|Convergence analysis| |63|
| |4.3.1|Convergence on manifolds|64|
| |4.3.2|A topological curiosity*|65|
| |4.3.3|Convergence of line-search methods|66|
|4.4|Stability|of fixed points|68|
|4.5|Speed|of convergence|68|
| |4.5.1|Order of convergence|68|
| |4.5.2|Rate of convergence of line-search methods*|70|
|4.6|Rayleigh quotient minimization on the sphere| |73|
| |4.6.1|Cost function and gradient calculation|74|
| |4.6.2|Critical points of the Rayleigh quotient|76|
| |4.6.3|Armijo line search|78|
| |4.6.4|Exact line search|78|
| |4.6.5|Accelerated line search: locally optimal conjugate gradient|78|
| |4.6.6|Links with the power method and inverse iteration|78|
|4.7|Refining eigenvector estimates| |80|
| |manifold| |80|
| |4.8.1|Cost function and search direction|80|
| |4.8.2 Critical points Rayleigh quotient minimization on the| |81|
| |Grassmann|manifold|83|
| |4.9.1|Cost function and gradient calculation|83|
|4.10|4.9.2|Line-search algorithm|85 86|
| |references| |91|
|5. Matrix Manifolds: Second-Order Geometry| | | |
|5.1|n| |91  |
| |Newton's method in R| |91|
|5.2|Affine connections| | |


[Page 8]

|CONTENTS 	| | |ix  |
|---|---|---|---|
|5.3|Riemannian connection| |96|
| |5.3.1|Symmetric connections|96|
| |5.3.2|Definition of the Riemannian connection|97|
| |5.3.3|Riemannian connection on Riemannian submanifolds|98|
| |5.3.4|Riemannian connection on quotient manifolds|100|
|5.4|exponential mapping, and translation|and|101|
|5.5|Hessian operator| |104|
|5.6|Second covariant derivative*| |108|
|5.7|references| |110|
|6. Newton's Method| | |111|
|6.1|Newton's method on manifolds| |111  |
|6.2|Riemannian Newton method for real-valued functions| |111|
|6.3|Local convergence| |113|
| |6.3.1 Calculus approach to local convergence analysis| |114|
|6.4|Rayleigh quotient algorithms| |118|
| |6.4.1|Rayleigh quotient on the sphere|118|
| |6.4.2|Rayleigh quotient on the Grassmann manifold|120|
| |6.4.3|Generalized eigenvalue problem|121|
| |6.4.4|The nonsymmetric eigenvalue problem|125|
| |6.4.5|acceleration: Jacobi-Davidson|126|
|6.5|Rayleigh quotient algorithms| |128|
| |6.5.1|Convergence analysis|128|
| |6.5.2|Numerical implementation|129 131|
|6.6|Notes and references| | |
|7.   Trust-Region   Methods 	| | |136  |
|7.1|Models| |137|
| |7.1.1|Models in R n|137|
| |7.1.2|Models in general Euclidean spaces|137|
| |7.1.3|Models on Riemannian manifolds|138|
|7.2|Trust-region methods| |140|
| |7.2.1|Trust-region methods in R n|140|
|7.3|trust-region step| |141|
| |7.3.1|Computing a nearly exact solution|142|
| |point| | |
| |7.3.2|Improving on the Cauchy|143|
|7.4|convergence| |145|
| |7.4.1|Global convergence|145|
| |7.4.2|Local convergence|158|
|7.5|Applications| |159|
| |7.5.1|Checklist|159|
| |7.5.2|Symmetric eigenvalue decomposition|161|
| |Computing an extreme| |165|
| |7.5.3|eigenspace|161|
|7.6 A|Notes and references Constellation of Superlinear Algorithms| |168  |


[Page 9]

|8.1|Vector|transport|168|
|---|---|---|---|
| |8.1.1|Vector transport and affine connections|172|
| |8.1.2|Vector transport by differentiated retraction|174|
| |8.1.3|Vector transport on Riemannian submanifolds|174|
| |8.1.4|Vector transport on quotient manifolds|175|
|8.2|Approximate Newton methods| |176|
| |8.2.1|Finite difference approximations|178|
| |8.2.2|Secant methods|178|
|8.3|Conjugate gradients| |184|
| |8.3.1|Application: Rayleigh quotient minimization|186|
|8.4|Levenberg-Marquardt methods| |187|
| |8.4.1|Gauss-Newton methods|188|
| |8.4.2|Levenberg-Marquardt methods|187|
|8.5|Notes and references| |189  |
|A. Elements of Linear Algebra, Topology, and Calculus| | |189|
|A.1|Linear algebra| |189|
|A.2|Topology| |191|
|A.3|Functions| |195|
|A.4|Asymptotic notation| |198|
|A.5|Derivatives| |195|
|A.6|Taylor's formula| |198|
|Bibliography| | |201|
|Index  | | |221  |


[Page 10]

# List   of   Algorithms  

|1|Accelerated Line Search (ALS)|63|
|---|---|---|
|2|Armijo line search for the Rayleigh quotient on S n - 1|76|
|3|Armijo line search for the Rayleigh quotient on Grass( p,n )|86|
|4|Geometric Newton method for vector fields|112|
|5|Riemannian Newton method for real-valued functions|119  |
|6|Riemannian Newton method for the Rayleigh quotient on S n - 1|119|
|7|Riemannian Newton method for the Rayleigh quotient on Grass( p,n )|121|
|8|Riemannian Newton method for the Rayleigh quotient on Grass( p,n )|124  |
|9|Jacobi-Davidson|127|
|10|Riemannian trust-region (RTR) meta-algorithm|142|
|11|Truncated CG(tCG) method for the trust-region subprob- lem|144  |
|12|Truncated CGmethod for the generalized eigenvalue prob- lem|164|
|13|Geometric CG method|182  |
|14|Gauss-Newton   method  |186  |


[Page 11]

# Foreword  

Constrained   optimization   is   quite   well   established   as   an   area   of   research,   and   there   exist   several   powerful   techniques   that   address   general   problems   in   that   area.   In   this   book   a   special   class   of   constraints   is   considered,   called   geometric   constraints,   which   express   that   the   solution   of   the   optimization   problem   lies   on   a   manifold.   This   is   a   recent   area   of   research   that   provides   powerful   alternatives   to   the   more   general   constrained   optimization   methods.   Classical   constrained   optimization   techniques   work   in   an   embedded   space   that   can   be   of   a   much   larger   dimension   than   that   of   the   manifold.   Optimization   algorithms   that   work   on   the   manifold   have   therefore   a   lower   complexity   and   quite   often   also   have   better   numerical   properties   (see,   e.g.,   the   numerical   integration   schemes   that   preserve   invariants   such   as   energy).   The   authors   refer   to   this   as   unconstrained   optimization   in   a   constrained   search   space.  

The   idea   that   one   can   describe   diﬀerence   or   diﬀerential   equations   whose   solution   lies   on   a   manifold   originated   in   the   work   of   Brockett,   Flaschka,   and   Rutishauser.   They   described,   for   example,   isospectral   ﬂows   that   yield   time-varying   matrices   which   are   all   similar   to   each   other   and   eventually   converge   to   diagonal   matrices   of   ordered   eigenvalues.   These   ideas   did   not   get   as   much   attention   in   the   numerical   linear   algebra   community   as   in   the   area   of   dynamical   systems   because   the   resulting   diﬀerence   and   diﬀerential   equations   did   not   lead   immediately   to   eﬃcient   algorithmic   implementations.  

An   important   book   synthesizing   several   of   these   ideas   is   Optimization and Dynamical Systems (Springer,   1994),   by   Helmke   and   Moore,   which   focuses   on   dynamical   systems   related   to   gradient   ﬂows   that   converge   exponentially   to   a   stationary   point   that   is   the   solution   of   some   optimization   problem.   The   corresponding   discrete-time   version   of   this   algorithm   would   then   have   linear   convergence,   which   seldom   compares   favorably   with   state-of-the-art   eigenvalue   solvers.  

The   formulation   of   higher-order   optimization   methods   on   manifolds   grew   out   of   these   ideas.   Some   of   the   people   that   applied   these   techniques   to   basic   linear   algebra   problems   include   Absil,   Arias,   Chu,   Dehaene,   Edelman,   Eld´ en,   Gallivan,   Helmke,   H¨ uper,   Lippert,   Mahony,   Manton,   Moore,   Sepulchre,   Smith,   and   Van   Dooren.   It   is   interesting   to   see,   on   the   other   hand,   that   several   basic   ideas   in   this   area   were   also   proposed   by   Luenberger   and   Gabay   in   the   optimization   literature   in   the   early   1980s,   and   this   without   any   use   of   dynamical   systems.  

In the present book the authors focus on higher-order methods and include Newton-type algorithms for optimization on manifolds. This requires a lot more machinery, which cannot currently be found in textbooks. The main focus of this book is on optimization problems related to invariant subspaces of matrices, but this is sufficiently general to encompass well the two main aspects of optimization on manifolds: the conceptual algorithm and its convergence analysis based on ideas of differential geometry, and the efficient numerical implementation using state-of-the-art numerical linear algebra techniques.

[Page 12]

The   book   is   quite   deep   in   the   presentation   of   the   machinery   of   diﬀerential   geometry   needed   to   develop   higher-order   optimization   techniques,   but   it   nevertheless   succeeds   in   explaining   complicated   concepts   with   simple   ideas.   These   ideas   are   then   used   to   develop   Newton-type   methods   as   well   as   other   superlinear   methods   such   as   trust-region   methods   and   inexact   and   quasiNewton   methods,   which   precisely   put   more   emphasis   on   the   eﬃcient   numerical   implementation   of   the   conceptual   algorithms.  

This   is   a   research   monograph   in   a   ﬁeld   that   is   quickly   gaining   momentum.   The   techniques   are   also   being   applied   to   areas   of   engineering   and   robotics,   as   indicated   in   the   book,   and   it   sheds   new   light   on   methods   such   as   the   JacobiDavidson   method,   which   originally   came   from   computational   chemistry.   The   book   makes   a   lot   of   interesting   connections   and   can   be   expected   to   generate   several   new   results   in   the   future.  

Paul Van Dooren January 2007

[Page 13]

# Notation   Conventions  

M , N

manifolds 


x , y

points   on   a   manifold 


ξ ,   η ,   ζ ,   χ  

tangent   vectors   or   vector   ﬁelds 


ξ x ,   η x ,   ζ x ,   χ x

tangent   vectors   at   x 


ϕ ,   ψ  

coordinate   charts 


A ,   B  

square   matrices 


W   ,   X ,   Y   ,   Z  

matrices 


W ,   X   ,   Y ,   Z  

linear   subspaces 


Conventions   related   to   the   deﬁnition   of   functions   are   stated   in   Section   A.3.  

[Page 14]

# Introduction  

This   book   is   about   the   design   of   numerical   algorithms   for   computational   problems   posed   on   smooth   search   spaces.   The   work   is   motivated   by   matrix   optimization   problems   characterized   by   symmetry   or   invariance   properties   in   the   cost   function   or   constraints.   Such   problems   abound   in   algorithmic   questions   pertaining   to   linear   algebra,   signal   processing,   data   mining,   and   statistical   analysis.   The   approach   taken   here   is   to   exploit   the   special   structure   of   these   problems   to   develop   eﬃcient   numerical   procedures.  

An   illustrative   example   is   the   eigenvalue   problem.   Because   of   their   scale   invariance,   eigenvectors   are   not   isolated   in   vector   spaces.   Instead,   each   eigendirection   deﬁnes   a   linear   subspace   of   eigenvectors.   For   numerical   computation,   however,   it   is   desirable   that   the   solution   set   consist   only   of   isolated   points   in   the   search   space.   An   obvious   remedy   is   to   impose   a   norm   equality   constraint   on   iterates   of   the   algorithm.   The   resulting   spherical   search   space   is   an   embedded submanifold of   the   original   vector   space.   An   alternative   approach   is   to   “factor”   the   vector   space   by   the   scale-invariant   symmetry   operation   such   that   any   subspace   becomes   a   single   point.   The   resulting   search   space   is   a   quotient manifold of   the   original   vector   space.   These   two   approaches   provide   prototype   structures   for   the   problems   considered   in   this   book.  

Scale   invariance   is   just   one   of   several   symmetry   properties   regularly   encountered   in   computational   problems.   In   many   cases,   the   underlying   symmetry   property   can   be   exploited   to   reformulate   the   problem   as   a   nondegenerate   optimization   problem   on   an   embedded   or   quotient   manifold   associated   with   the   original   matrix   representation   of   the   search   space.   These   constraint   sets   carry   the   structure   of   nonlinear   matrix   manifolds.   This   book   provides   the   tools   to   exploit   such   structure   in   order   to   develop   eﬃcient   matrix   algorithms   in   the   underlying   total   vector   space.  

Working with a search space that carries the structure of a nonlinear manifold introduces certain challenges in the algorithm implementation. In their classical formulation, iterative optimization algorithms rely heavily on the Euclidean vector space structure of the search space; a new iterate is generated by adding an update increment to the previous iterate in order to reduce the cost function. The update direction and step size are generally computed using a local model of the cost function, typically based on (approximate) fi rst and second derivatives of the cost function, at each step. In order to define algorithms on manifolds, these operations must be translated into the language of differential geometry. This process is a significant research program that builds upon solid mathematical foundations. Advances in that direction have been dramatic over the last two decades and have led to a solid conceptual framework. However, generalizing a given optimization algorithm on an abstract manifold is only the fi rst step towards the objective of this book. Turning the algorithm into an efficient numerical procedure is a second step that ultimately justifies or invalidates the fi rst part of the effort. At the time of publishing this book, the second step is more an art than a theory.

[Page 15]

Good   algorithms   result   from   the   combination   of   insight   from   diﬀerential   geometry,   optimization,   and   numerical   analysis.   A   distinctive   feature   of   this   book   is   that   as   much   attention   is   paid   to   the   practical   implementation   of   the   algorithm   as   to   its   geometric   formulation.   In   particular,   the   concrete   aspects   of   algorithm   design   are   formalized   with   the   help   of   the   concepts   of   retraction and   vector transport ,   which   are   relaxations   of   the   classical   geometric   concepts   of   motion   along   geodesics   and   parallel   transport.   The   proposed   approach   provides   a   framework   to   optimize   the   eﬃciency   of   the   numerical   algorithms   while   retaining   the   convergence   properties   of   their   abstract   geometric   counterparts.  

The   geometric   material   in   the   book   is   mostly   conﬁned   to   Chapters   3   and   5.   Chapter   3   presents   an   introduction   to   Riemannian   manifolds   and   tangent   spaces   that   provides   the   necessary   tools   to   tackle   simple   gradient-descent   optimization   algorithms   on   matrix   manifolds.   Chapter   5   covers   the   advanced   material   needed   to   deﬁne   higher-order   derivatives   on   manifolds   and   to   build   the   analog   of   ﬁrstand   second-order   local   models   required   in   most   optimization   algorithms.   The   development   provided   in   these   chapters   ranges   from   the   foundations   of   diﬀerential   geometry   to   advanced   material   relevant   to   our   applications.   The   selected   material   focuses   on   those   geometric   concepts   that   are   particular   to   the   development   of   numerical   algorithms   on   embedded   and   quotient   manifolds.   Not   all   aspects   of   classical   diﬀerential   geometry   are   covered,   and   some   emphasis   is   placed   on   material   that   is   nonstandard   or   diﬃcult   to   ﬁnd   in   the   established   literature.   A   newcomer   to   the   ﬁeld   of   diﬀerential   geometry   may   wish   to   supplement   this   material   with   a   classical   text.   Suggestions   for   excellent   texts   are   provided   in   the   references.  

A   fundamental,   but   deliberate,   omission   in   the   book   is   a   treatment   of   the   geometric   structure   of   Lie   groups   and   homogeneous   spaces.   Lie   theory   is   derived   from   the   concepts   of   symmetry   and   seems   to   be   a   natural   part   of   a   treatise   such   as   this.   However,   with   the   purpose   of   reaching   a   community   without   an   extensive   background   in   geometry,   we   have   omitted   this   material   in   the   present   book.   Occasionally   the   Lie-theoretic   approach   provides   an   elegant   shortcut   or   interpretation   for   the   problems   considered.   An   eﬀort   is   made   throughout   the   book   to   refer   the   reader   to   the   relevant   literature   whenever   appropriate.  

The algorithmic material of the book is interlaced with the geometric material. Chapter 4 considers gradient-descent line-search algorithms. These simple optimization algorithms provide an excellent framework within which to study the important issues associated with the implementation of practical algorithms. The concept of retraction is introduced in Chapter 4 as a key step in developing efficient numerical algorithms on matrix manifolds. The later chapters on algorithms provide the core results of the book: the development of Newton-based methods in Chapter 6 and of trust-region methods in Chapter 7, and a survey of other superlinear methods such as conjugate gradients in Chapter 8. We attempt to provide a generic development of each of these methods, building upon the material of the geometric chapters. The methodology is then developed into concrete numerical algorithms on specific examples. In the analysis of superlinear and second-order methods, the concept of vector transport (introduced in Chapter 8) is used to provide an efficient implementation of methods such as conjugate gradient and other quasi-Newton methods. The algorithms obtained in these sections of the book are competitive with state-of-the-art numerical linear algebra algorithms for certain problems.

[Page 16]

The   running   example   used   throughout   the   book   is   the   calculation   of   invariant   subspaces   of   a   matrix   (and   the   many   variants   of   this   problem).   This   example   is   by   far,   for   variants   of   algorithms   developed   within   the   proposed   framework,   the   problem   with   the   broadest   scope   of   applications   and   the   highest   degree   of   achievement   to   date.   Numerical   algorithms,   based   on   a   geometric   formulation,   have   been   developed   that   compete   with   the   best   available   algorithms   for   certain   classes   of   invariant   subspace   problems.   These   algorithms   are   explicitly   described   in   the   later   chapters   of   the   book   and,   in   part,   motivate   the   whole   project.   Because   of   the   important   role   of   this   class   of   problems   within   the   book,   the   ﬁrst   part   of   Chapter   2   provides   a   detailed   description   of   the   invariant   subspace   problem,   explaining   why   and   how   this   problem   leads   naturally   to   an   optimization   problem   on   a   matrix   manifold.   The   second   part   of   Chapter   2   presents   other   applications   that   can   be   recast   as   problems   of   the   same   nature.   These   problems   are   the   subject   of   ongoing   research,   and   the   brief   exposition   given   is   primarily   an   invitation   for   interested   researchers   to   join   with   us   in   investigating   these   problems   and   expanding   the   range   of   applications   considered.  

The   book   should   primarily   be   considered   a   research   monograph,   as   it   reports   on   recently   published   results   in   an   active   research   area   that   is   expected   to   develop   signiﬁcantly   beyond   the   material   presented   here.   At   the   same   time,   every   possible   eﬀort   has   been   made   to   make   the   book   accessible   to   the   broadest   audience,   including   applied   mathematicians,   engineers,   and   computer   scientists   with   little   or   no   background   in   diﬀerential   geometry.   It   could   equally   well   qualify   as   a   graduate   textbook   for   a   one-semester   course   in   advanced   optimization.   More   advanced   sections   that   can   be   readily   skipped   at   a   ﬁrst   reading   are   indicated   with   a   star.   Moreover,   readers   are   encouraged   to   visit   the   book   home   page 1 where   supplementary   material   is   available.  

The book is an extension of the fi rst author's Ph.D. thesis [Abs03], itself a project that drew heavily on the material of the second author's Ph.D. thesis [Mah94]. It would not have been possible without the many contributions of a quickly expanding research community that has been working in the area over the last decade. The Notes and References section at the end of each chapter is an attempt to give proper credit to the many contributors, even though this task becomes increasingly difficult for recent contributions. The authors apologize for any omission or error in these notes. In addition, we wish to conclude this introductory chapter with special acknowledgements to people without whom this project would have been impossible. The 1994 monograph [HM94] by Uwe Helmke and John Moore is a milestone in the formulation of computational problems as optimization algorithms on manifolds and has had a profound influence on the authors. On the numerical side, the constant encouragement of Paul Van Dooren and Kyle Gallivan has provided tremendous support to our efforts to reconcile the perspectives of differential geometry and numerical linear algebra. We are also grateful to all our colleagues and friends over the last ten years who have crossed paths as coauthors, reviewers, and critics of our work. Special thanks to Ben Andrews, Chris Baker, Alan Edelman, Michiel Hochstenbach, Knut H¨ uper, Jonathan Manton, Robert Orsi, and Jochen Trumpf. Finally, we acknowledge the useful feedback of many students on preliminary versions of the book, in particular, Mariya Ishteva, Michel Journ´ ee, and Alain Sarlette.

1 http://press.princeton.edu/titles/8586.html  

[Page 17]

[Page 18]

# Motivation   and   Applications  

The   problem   of   optimizing   a   real-valued   function   on   a   matrix   manifold   appears   in   a   wide   variety   of   computational   problems   in   science   and   engineering.   In   this   chapter   we   discuss   several   examples   that   provide   motivation   for   the   material   presented   in   later   chapters.   In   the   ﬁrst   part   of   the   chapter,   we   focus   on   the   eigenvalue   problem.   This   application   receives   special   treatment   because   it   serves   as   a   running   example   throughout   the   book.   It   is   a   problem   of   unquestionable   importance   that   has   been,   and   still   is,   extensively   researched.   It   falls   naturally   into   the   geometric   framework   proposed   in   this   book   as   an   optimization   problem   whose   natural   domain   is   a   matrix   manifold—the   underlying   symmetry   is   related   to   the   fact   that   the   notion   of   an   eigenvector   is   scale-invariant.   Moreover,   there   are   a   wide   range   of   related   problems   (eigenvalue   decompositions,   principal   component   analysis,   generalized   eigenvalue   problems,   etc.)   that   provide   a   rich   collection   of   illustrative   examples   that   we   will   use   to   demonstrate   and   compare   the   techniques   proposed   in   later   chapters.  

Later   in   this   chapter,   we   describe   several   research   problems   exhibiting   promising   symmetry   to   which   the   techniques   proposed   in   this   book   have   not   yet   been   applied   in   a   systematic   way.   The   list   is   far   from   exhaustive   and   is   very   much   the   subject   of   ongoing   research.   It   is   meant   as   an   invitation   to   the   reader   to   consider   the   broad   scope   of   computational   problems   that   can   be   cast   as   optimization   problems   on   manifolds.  

# 2.1 A CASE STUDY: THE EIGENV ALUE PROBLEM

The   problem   of   computing   eigenspaces   and   eigenvalues   of   matrices   is   ubiquitous   in   engineering   and   physical   sciences.   The   general   principle   of   computing   an   eigenspace   is   to   reduce   the   complexity   of   a   problem   by   focusing   on   a   few   relevant   quantities   and   dismissing   the   others.   Eigenspace   computation   is   involved   in   areas   as   diverse   as   structural   dynamics   [GR97],   control   theory   [PL V94],   signal   processing   [CG90],   and   data   mining   [BDJ99].   Considering   the   importance   of   the   eigenproblem   in   so   many   engineering   applications,   it   is   not   surprising   that   it   has   been,   and   still   is,   a   very   active   ﬁeld   of   research.  

Let   F   stand   for   the   ﬁeld   of   real   or   complex   numbers.   Let   A   be   an   n   ×   n   matrix   with   entries   in   F .   Any   nonvanishing   vector   v   ∈   C n that   satisﬁes   Av   =   λv  

$$
A v = \lambda v
$$

for some λ ∈ C is called an eigenvector of A ; λ is the associated eigen- value , and the couple ( λ, v ) is called an eigenpair . The set of eigenvalues of A is called the spectrum of A . The eigenvalues of A are the zeros of the characteristic polynomial of A ,

[Page 19]

$$
\mathcal { P } _ { A } ( z ) \equiv \det ( A - z I ) , \\ u \cdot _ { I } u \cdot _ { I } \cdot _ { i } u \cdot _ { i } \cdot _ { j } u \cdot _ { j } u \cdot _ { j } \cdot _ { i } u \cdot _ { i } \cdot _ { j } u
$$

and   their   algebraic multiplicity is   their   multiplicity   as   zeros   of   P A .   If   T   is   an   invertible   matrix   and   ( λ, v )   is   an   eigenpair   of   A ,   then   ( λ, T v )   is   an   eigenpair   of   T AT   − 1 .   The   transformation   A    →   T AT   − 1 is   called   a   similarity transformation of   A .   n n

A   (linear) subspace S   of   F is   a   subset   of   F that   is   closed   under   linear   combinations,   i.e.,  

$$
\forall x , y \in \mathcal { S } , \, \forall a , b \in \mathbb { F } \colon ( a x + b y ) \in \mathcal { S } . \\ \intertext { v a r $ x , y \in \mathcal { S } , \, \forall a , b \in \mathbb { F } $ } \omega _ { 0 } \intertext { v a r $ x , y \in \mathcal { S } , \, \forall a , b \in \mathbb { F } $ } \omega _ { 1 } \intertext { v a r $ x , y \in \mathcal { S } , \, \forall a , b \in \mathbb { F } $ } \omega _ { 2 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 3 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 4 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 5 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 6 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 7 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 8 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 9 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 10 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 11 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 12 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 13 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 14 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 15 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 16 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 17 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 18 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 19 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 20 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 21 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 22 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 23 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 24 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 25 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 26 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 27 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 28 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 29 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 30 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 31 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 32 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 33 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 34 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 35 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 36 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 37 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 38 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 39 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 40 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 41 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 42 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 43 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 44 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 45 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 46 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 47 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 48 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 49 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 50 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 51 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 52 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 53 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 54 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 55 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 56 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 57 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 58 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 59 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 60 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 61 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 62 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 63 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 64 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 65 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 66 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 67 } \intertext { v a r $ x , y \in \mathcal { S } $ } \omega _ { 68 } \intertext { v a r $
$$

A   set   { y 1 , . . . , y p }   of   elements   of   S   such   that   every   element   of   S   can   be   written   as   a   linear   combination   of   y 1 , . . . , y p is   called   a   spanning set of   S ;   we   say   that   S   is   the   column space or   simply   the   span of   the   n   ×   p   matrix   Y   = [ y 1 , . . . , y p ]   and   that   Y   spans S .   This   is   written   as     =   span( Y   ) =   Y x   :   x     F p   =   Y   F p .  

$$
\mathcal { S } = \text {span} ( Y ) = \{ Y x \colon x \in \mathbb { F } ^ { p } \} = Y \mathbb { F } ^ { p } . \\ \intertext { \ } \text {V} \colon \intertext { X } \intertext { i } \intertext { s p a n } \intertext { ( Y ) } \intertext { = } \intertext { \{ Y x \colon x \in \mathbb { F } ^ { p } \} } = Y \mathbb { F } ^ { p } .
$$

The   matrix   Y   is   said   to   have   full   (column)   rank   when   the   columns   of   Y   are   linearly   independent,   i.e.,   Y x   =   0   implies   x   =   0.   If   Y   spans   S   and   has   full   rank,   then   the   columns   of   Y   form   a   basis of   S .   Any   two   bases   of   S   have   the   same   number   of   elements,   called   the   dimension of   S .   The   set   of   all   p dimensional   subspaces   of   F n ,   denoted   by   Grass( p, n ),   plays   an   important   role   in   this   book.   We   will   see   in   Section   3.4   that   Grass( p, n )   admits   a   structure   of   manifold   called   the   Grassmann manifold .  

The   kernel   ker( B )   of   a   matrix   B   is   the   subspace   formed   by   the   vectors   x   such   that   Bx   =   0.   A   scalar   λ   is   an   eigenvalue   of   a   matrix   A   if   and   only   if   the   dimension   of   the   kernel   of   ( A   −   λI )   is   greater   than   zero,   in   which   case   ker( A   −   λI )   is   called   the   eigenspace of A   related to λ .   An   n   ×   n   matrix   A   naturally   induces   a   mapping   on   Grass( p, n )   deﬁned   by  

An n × n matrix A naturally induces a mapping on Grass( p, n ) defined by

$$
\mathcal { S } \in G r a s s ( p , n ) \ & \mapsto \ A \mathcal { S } \colon = \{ A y \colon y \in \mathcal { S } \} . \\ \mathfrak { C } \colon \quad \mathfrak { I } \cup \mathfrak { I } _ { 1 } \quad \mathfrak { I } \colon \quad \mathfrak { I } \quad \mathfrak { I } \quad \mathfrak { I } \colon \quad \mathfrak { I }
$$

A   subspace   S   is   said   to   be   an   invariant subspace or   eigenspace of   A   if   A S ⊆   S .   The   restriction A | S   of   A   to   an   invariant   subspace   S   is   the   operator   x    →   Ax   whose   domain   is   S .   An   invariant   subspace   S   of   A   is   called   spectral if,   for   every   eigenvalue   λ   of   A S   ,   the   multiplicities   of   λ   as   an   eigenvalue   of   A S | | and   as   an   eigenvalue   of   A   are   identical;   equivalently,   X T AX   and   X T AX ⊥ ⊥   have   no   eigenvalue   in   common   when   [ X | X ⊥ ]   satisﬁes   [ X | X ⊥ ] T [ X | X ⊥ ] =   I n and   span( X ) =   S .   In   many   (arguably   the   majority   of)   eigenproblems   of   interest,   the   matrix  

A   is   real   and   symmetric   ( A   =   A T ).   The   eigenvalues   of   an   n   ×   n   symmetric   matrix   A   are   reals   λ 1 ≤   ···   ≤   λ n ,   and   the   associated   eigenvectors   v 1 , . . . , v n are   real   and   can   be   chosen   orthonormal ,   i.e.,  

$$
\ s e n \ o r t h o n o r m a l , \, 1 . e . , \\ v _ { i } ^ { T } v _ { j } = \begin{cases} 1 \text { if } i = j , \\ 0 \text { if } i \neq j . \end{cases}
$$

/negationslash Equivalently, for every symmetric matrix A , there is an orthonormal matrix V (whose columns are eigenvectors of A ) and a diagonal matrix Λ such that A = V Λ V T . The eigenvalue λ 1 is called the leftmost eigenvalue of A , and an eigenpair ( λ 1 , v 1 ) is called a leftmost  eigenpair . A p -dimensional leftmost invariant  subspace is an invariant subspace associated with λ 1 , . . . , λ p . Similarly, a p -dimensional rightmost  invariant  subspace is an invariant subspace associated with λ n -p +1 , . . . , λ n . Finally, extreme eigenspaces refer collectively to leftmost and rightmost eigenspaces.

[Page 20]

Given   two   n   ×   n   matrices   A   and   B ,   we   say   that   ( λ, v )   is   an   eigenpair   of   the   pencil ( A, B )   if  

$$
A v = \lambda B v .
$$

Finding   eigenpairs   of   a   matrix   pencil   is   known   as   the   generalized eigenvalue problem .   The   generalized   eigenvalue   problem   is   said   to   be   symmetric / positive-deﬁnite when   A   is   symmetric   and   B   is   symmetric   positive-deﬁnite   (i.e.,   x T Bx   >   0   for   all   nonvanishing   x ).   In   this   case,   the   eigenvalues   of   the   pencil   are   all   real   and   the   eigenvectors   can   be   chosen   to   form   a   B orthonormal   basis.   A   subspace   Y   is   called   a   (generalized) invariant subspace (or   a   deﬂating subspace )   of   the   symmetric   /   positive-deﬁnite   pencil   ( A, B )   if   B − 1 Ay   ∈ Y   for   all   y   ∈ Y ,   which   can   also   be   written   B − 1 A Y ⊆ Y   or   A Y ⊆   B Y .   The   simplest   example   is   when   Y   is   spanned   by   a   single   eigenvector   of   ( A, B ),   i.e.,   a   nonvanishing   vector   y   such   that   Ay   =   λBy   for   some   eigenvalue   λ .   More   generally,   every   eigenspace   of   a   symmetric   /   positivedeﬁnite   pencil   is   spanned   by   eigenvectors   of   ( A, B ).   Obviously,   the   generalized   eigenvalue   problem   reduces   to   the   standard   eigenvalue   problem   when   B   =   I .  

# 2.1.1 The eigenvalue problem as an optimization problem

The   following   result   is   instrumental   in   formulating   extreme   eigenspace   computation   as   an   optimization   problem.   (Recall   that   tr( A ),   the   trace of   A ,   denotes   the   sum   of   the   diagonal   elements   of   A .)  

Proposition 2.1.1 Let A   and B   be symmetric n   ×   n   matrices and let B   be positive-deﬁnite. Let λ 1 ≤   ···   ≤   λ n be the eigenvalues of the pencil ( A, B ) . Consider the generalized   Rayleigh   quotient  

$$
f ( Y ) = \text {tr} ( Y ^ { T } A Y ( Y ^ { T } B Y ) ^ { - 1 } )
$$

deﬁned on the set of all n   ×   p   full-rank matrices. Then the following statements are equivalent:

- (i) span( Y ∗ )   is a leftmost invariant subspace of ( A, B ) ;
- (ii) Y ∗   is a global minimizer of (2.1)   over all n   ×   p   full-rank matrices; (iii) f ( Y ∗ ) =   p i =1 λ i .
- (iii) f ( Y ∗ ) = ∑ p i =1 λ i .


the   development   we   will   assume   that   λ p < λ p +1 ,   but the result also holds without   this   hypothesis.   Let   V   be   an   n   ×   n   matrix   for   which   V   T BV   =   I n and   V   T AV   =   diag( λ 1 , . . . , λ n ),   where   λ 1 ≤   ···   ≤   λ n .  

[Page 21]

Such   a   V   always   exists.   Let   Y   ∈   R n × p and   put   Y   =   V M .   Since   Y   T BY   =   I p ,   it   follows   that   M T M   =   I p .   Then  

$$
\text { such a v always exists. Let Y \in \mathbb { R } ^ { \cdots } \text { and put Y = V } M . \text { Since } Y ^ { - B Y } = I _ { p } , \\ \text { it follows that } M ^ { T } M = I _ { p } . \text { Then } \\ \text { tr(Y^{T} AY) = tr(M^{T} diag( \lambda _ { 1 } , \dots , \lambda _ { n } ) M ) } \\ = \sum _ { i = 1 } ^ { n } \lambda _ { i } \sum _ { j = 1 } ^ { p } m _ { i j } ^ { 2 } \\ = \sum _ { j = 1 } ^ { p } \left ( \lambda _ { p } + \sum _ { i = 1 } ^ { p } ( \lambda _ { i } - \lambda _ { p } ) m _ { i j } ^ { 2 } + \sum _ { i = p + 1 } ^ { n } ( \lambda _ { i } - \lambda _ { p } ) m _ { i j } ^ { 2 } \right ) \\ = \sum _ { i = 1 } ^ { p } \lambda _ { i } + \sum _ { i = 1 } ^ { p } ( \lambda _ { p } - \lambda _ { i } ) \left ( 1 - \sum _ { j = 1 } ^ { p } m _ { i j } ^ { 2 } \right ) + \sum _ { j = 1 } ^ { p } \sum _ { i = p + 1 } ^ { n } ( \lambda _ { i } - \lambda _ { p } ) m _ { i j } ^ { 2 } . \\ \text { Since the second and last terms are nonnegative, it follows that } \text {tr(Y^{T} AY) \geq } \\ \sum _ { i = 1 } ^ { p } \lambda _ { i } . \text { Equality holds if and only if the second and last terms vanish. This }
$$

Since   the   second   and   last   terms   are   nonnegative,   it   follows   that   tr( Y   T AY   )   ≥   p i =1 λ i .   Equality   holds   if   and   only   if   the   second   and   last   terms   vanish.   This   happens   if   and   only   if   the   ( n   −   p )   ×   p   lower   part   of   M   vanishes   (and   hence   the   p   ×   p   upper   part   of   M   is   orthogonal),   which   means   that   Y   =   V M   spans   a   p -dimensional   leftmost   invariant   subspace   of   ( A, B ).      

For   the   case   p   =   1   and   B   =   I ,   and   assuming   that   the   leftmost   eigenvalue   λ 1 of   A   has   multiplicity   1,   Proposition   2.1.1   implies   that   the   global   minimizers   of   the   cost   function  

$$
f \colon \mathbb { R } _ { * } ^ { n } \rightarrow \mathbb { R } \colon y \mapsto f ( y ) = \frac { y ^ { T } A y } { y ^ { T } y }
$$

are   the   points   v 1 r ,   r   ∈   R ∗ ,   where   R n is   R n with   the   origin   removed   and   v 1 ∗   is   an   eigenvector   associated   with   λ 1 .   The   cost   function   (2.2)   is   called   the   Rayleigh quotient of   A .   Minimizing   the   Rayleigh   quotient   can   be   viewed   as   an   optimization   problem   on   a   manifold   since,   as   we   will   see   in   Section   3.1.1,   R n admits   a   natural   manifold   structure.   However,   the   manifold   aspect   is   of   ∗   little   interest   here,   as   the   manifold   is   simply   the   classical   linear   space   R n with   the   origin   excluded.  

A   less   reassuring   aspect   of   this   minimization   problem   is   that   the   minimizers   are   not   isolated   but   come   up   as   the   continuum   v 1 R ∗ .   Consequently,   some   important   convergence   results   for   optimization   methods   do   not   apply,   and   several   important   algorithms   may   fail,   as   illustrated   by   the   following   proposition.  

Proposition 2.1.2 Newton ’s method applied to the Rayleigh quotient (2.2)   yields the iteration y    →   2 y   for every y   such that f ( y )   is not an eigenvalue of A .

Proof. Routine manipulations yield grad f ( y ) = y T 2 y ( Ay -f ( y ) y ) and Hess f ( y )[ z ] = D(grad f )( y )[ z ] = y 2 y ( y 4 y ) 2 ( Az -f ( y ) z ) -( y T Azy + y T zAy -2 f ( y ) y T zy ) = H y z , where T H y = y T 2 ( A -f ( y ) I T -T 2 ( yy T A + Ayy T -T T y y y 2 f ( y ) yy T )) = 2 ( I -2 yy )( A -f ( y ) I )( I -2 yy ). It follows that H y is y T y y T y y T y singular if and only if f ( y ) is an eigenvalue of A . When f ( y ) is not an eigenvalue of A , the Newton equation H y η = -grad f ( y ) admits one and only one solution, and it is easy to check that this solution is η = y . In conclusion, the Newton iteration maps y to y + η = 2 y . /square

[Page 22]

  This   result   is   not   particular   to   the   Rayleigh   quotient.   It   holds   for   any   function   f   homogeneous   of   degree   zero,   i.e.,   f ( yα ) =   f ( y )   for   all   real   α   =   0.   A   remedy   is   to   restrain   the   domain   of   f   to   some   subset   M   of   R n so   that   ∗   any   ray   y R ∗   contains   at   least   one   and   at   most   ﬁnitely   many   points   of   M .   Notably,   this   guarantees   that   the   minimizers   are   isolated.   An   elegant   choice   for   M   is   the   unit   sphere   n − 1       R n     T    

/negationslash

$$
S ^ { n - 1 } \colon = \{ y \in \mathbb { R } ^ { n } \, \colon y ^ { T } y = 1 \} . \\ 1 \colon 1 \quad \stackrel { \dots } { \sim } \, y \in ( 0 , 0 ) \, + \, c n - 1 \quad \cdot
$$

Restricting   the   Rayleigh   quotient   (2.2)   to   S n − 1 gives   us   a   well-behaved   cost   function   with   isolated   minimizers.   What   we   lose,   however,   is   the   linear   structure   of   the   domain   of   the   cost   function.   The   goal   of   this   book   is   to   provide   a   toolbox   of   techniques   to   allow   practical   implementation   of   numerical   optimization   methods   on   nonlinear   embedded   (matrix)   manifolds   in   order   to   address   problems   of   exactly   this   nature.   n

Instead   of   restraining   the   domain   of   f   to   some   subset   of   R ,   another   approach,   which   seems   a priori more   challenging   but   ﬁts   better   with   the   geometry   of   the   problem,   is   to   work   on   a   domain   where   all   points   on   a   ray   y R ∗   are   considered   just   one   point.   This   viewpoint   is   especially   well   suited   to   eigenvector   computation   since   the   useful   information   of   an   eigenvector   is   fully   contained   in   its   direction.   This   leads   us   to   consider   the   set  

$$
\mathcal { M } \colon = \{ y \mathbb { R } _ { * } \colon y \in \mathbb { R } _ { * } ^ { n } \} . \\ \dot { \cdot } \colon \, + ( 0 , 0 ) \quad \dot { \cdot } \colon c \quad \mathfrak { r } ( \real )
$$

Since   the   Rayleigh   quotient   (2.2)   satisﬁes   f ( yα ) =   f ( y ),   it   induces   a   welldeﬁned   function   f ˜ ( y R ∗ )   :=   f ( y )   whose   domain   is   M .   Notice   that   whereas   the   Rayleigh   quotient   restricted   to   S n − 1 has   two   minimizers   ± v 1 ,   the   Rayleigh   quotient   f ˜   has   only   one   minimizer   v 1 R ∗   on   M .   It   is   shown   in   Chapter   3   that   the   set   M ,   called   the   real projective space ,   admits   a   natural   structure   of   quotient manifold .   The   material   in   later   chapters   provides   techniques   tailored   to   (matrix)   quotient   manifold   structures   that   lead   to   practical   implementation   of   numerical   optimization   methods.   For   the   simple   case   of   a   single   eigenvector,   algorithms   proposed   on   the   sphere   are   numerically   equivalent   to   those   on   the   real-projective   quotient   space.   However,   when   the   problem   is   generalized   to   the   computation   of   p -dimensional   invariant   subspaces,   the   quotient   approach,   which   leads   to   the   Grassmann   manifold,   is   seen   to   be   the   better   choice.  

# 2.1.2 Some beneﬁts of an optimization framework

We   will   illustrate   throughout   the   book   that   optimization-based   eigenvalue   algorithms   have   a   number   of   desirable   properties.  

An   important   feature   of   all   optimization-based   algorithms   is   that   optimization   theory   provides   a   solid   framework   for   the   convergence   analysis.  

[Page 23]

Many   optimization-based   eigenvalue   algorithms   exhibit   almost   global   convergence   properties.   This   means   that   convergence   to   a   solution   of   the   optimization   problem   is   guaranteed   for   almost   every   initial   condition.   The   property   follows   from   general   properties   of   the   optimization   scheme   and   does   not   need   to   be   established   as   a   speciﬁc   property   of   a   particular   algorithm.  

The   speed   of   convergence   of   the   algorithm   is   also   an   intrinsic   property   of   optimization-based   algorithms.   Gradient-based   algorithms   converge   linearly ;   i.e.,   the   contraction   rate   of   the   error   between   successive   iterates   is   asymptotically   bounded   by   a   constant   c <   1.   In   contrast,   Newton-like   algorithms   have   superlinear convergence;   i.e.,   the   contraction   rate   asymptotically   converges   to   zero.   (We   refer   the   reader   to   Section   4.3   for   details.)  

Characterizing   the   global   behavior   and   the   (local)   convergence   rate   of   a   given   algorithm   is   an   important   performance   measure   of   the   algorithm.   In   most   situations,   this   analysis   is   a   free   by-product   of   the   optimization   framework.  

Another   challenge   of   eigenvalue   algorithms   is   to   deal   eﬃciently   with   largescale problems.   Current   applications   in   data   mining   or   structural   analysis   easily   involve   matrices   of   dimension   10 5 –   10 6 [AHLT05].   In   those   applications,   the   matrix   is   typically   sparse;   i.e.,   the   number   of   nonzero   elements   is   O ( n )   or   even   less,   where   n   is   the   dimension   of   the   matrix.   The   goal   in   such   applications   is   to   compute   a   few   eigenvectors   corresponding   to   a   small   relevant   portion   of   the   spectrum.   Algorithms   are   needed   that   require   a   small   storage   space   and   produce   their   iterates   in   O ( n )   operations.   Such   algorithms   permit   matrix-vector   products   x    →   Ax ,   which   require   O ( n )   operations   if   A   is   sparse,   but   they   forbid   matrix   factorizations,   such   as   QR   and   LU,   that   destroy   the   sparse   structure   of   A .   Algorithms   that   make   use   of   A   only   in   the   form   of   the   operator   x    →   Ax   are   called   matrix-free .   All   the   algorithms   in   this   book,   designed   and   analyzed   using   a   diﬀerential  

geometric   optimization   approach,   satisfy   at   least   some   of   these   requirements.   The   trust-region   approach   presented   in   Chapter   7   satisﬁes   all   the   requirements.   Such   strong   convergence   analysis   is   rarely   encountered   in   available   eigenvalue   methods.  

# 2.2 RESEARCH PROBLEMS

This   section   is   devoted   to   brieﬂy   presenting   several   general   computational   problems   that   can   be   tackled   by   a   manifold-based   optimization   approach.   Research   on   the   problems   presented   is   mostly   at   a   preliminary   stage   and   the   discussion   provided   here   is   necessarily   at   the   level   of   an   overview.   The   interested   reader   is   encouraged   to   consult   the   references   provided.  

# 2.2.1 Singular value problem

The   singular   value   decomposition   is   one   of   the   most   useful   tasks   in   numerical   computations   [HJ85,   GVL96],   in   particular   when   it   is   used   in   dimension  

[Page 24]

Matrices   U ,   Σ,   and   V   form   a   singular value decomposition (SVD)   of   an   arbitrary   matrix   A   ∈   R m × n (to   simplify   the   discussion,   we   assume   that   m   ≥   n )   if   A   =   U   Σ V   T ,   (2.3)  

$$
A = U \Sigma V ^ { T } ,
$$

with   U   ∈   R m × m ,   U T U   =   I m ,   V   ∈   R n × n ,   V   T V   =   I n , Σ   ∈   R m × n ,   Σ   diagonal   with   diagonal   entries   σ 1 ≥   ···   ≥   σ n ≥   0.   Every   matrix   A   admits   an   SVD.   The   diagonal   entries   σ i of   Σ   are   called   the   singular   values   of   A ,   and   the   corresponding   columns   u i and   v i of   U   and   V   are   called   the   left   and   right   singular   vectors   of   A .   The   triplets   ( σ i , u i , v i )   are   then   called   singular   triplets   of   A .   Note   that   an   SVD   expresses   the   matrix   A   as   a   sum   of   rank-1   matrices,   n

$$
A = \sum _ { i = 1 } ^ { n } \sigma _ { i } u _ { i } v _ { i } ^ { T } . \\ \text {several least-squares} \ p
$$

The   SVD   is   involved   in   several   least-squares   problems.   An   important   example   is   the   best   low-rank   approximation   of   an   m   ×   n   matrix   A   in   the   least-squares   sense,   i.e.,  

$$
\arg \min _ { X \in \mathcal { R } _ { p } } \| A - X \| _ { F } ^ { 2 } ,
$$

where   R p denotes   the   set   of   all   m   matrices   with   rank   p   and     ·   2 ×   n   F denotes   the   Frobenius   norm,   i.e.,   the   sum   of   the   squares   of   the   elements   of   its   argument.   The   solution   of   this   problem   is   given   by   a   truncated   SVD   p

$$
X = \sum _ { i = 1 } ^ { p } \sigma _ { i } u _ { i } v _ { i } ^ { T } , \\ \text {clartriplets of } A \ ( \text {order}
$$

where   ( σ i , u i , v i )   are   singular   triplets   of   A   (ordered   by   decreasing   value   of   σ ).   This   result   is   known   as   the   Eckart-Young-Mirsky   theorem;   see   Eckart   and   Young   [EY36]   or,   e.g.,   Golub   and   Van   Loan   [GVL96].  

The   singular   value   problem   is   closely   related   to   the   eigenvalue   problem.   It   follows   from   (2.3)   that   A T A   =   V   Σ 2 V   T ,   hence   the   squares   of   the   singular   values   of   A   are   the   eigenvalues   of   A T A   and   the   corresponding   right   singular   vectors   are   the   corresponding   eigenvectors   of   A T A .   Similarly,   AA T =   U Σ 2 U T ,   hence   the   left   singular   vectors   of   A   are   the   eigenvectors   of   AA T .   One   approach   to   the   singular   value   decomposition   problem   is   to   rely   on   eigenvalue   algorithms   applied   to   the   matrices   A T A   and   AA T .   Alternatively,   it   is   possible   to   compute   simultaneously   a   few   dominant   singular   triplets   (i.e.,   those   corresponding   to   the   largest   singular   values)   by   maximizing   the   cost   function  

$$
f ( U , V ) = \text {tr} ( U ^ { T } A V N )
$$

subject   to   U T U   =   I p and   V   T V   =   I p ,   where   N   =   diag( µ 1 , . . . , µ p ),   with   µ 1 >   > µ p >   0   arbitrary.   If   ( U, V   )   is   a   solution   of   this   maximization   problem,   ···   then   the   columns   u i of   U   and   v i of   V   are   the   i th   dominant   left   and   right   singular   vectors   of   A .   This   is   an   optimization   problem   on   a   manifold;   indeed,   constraint   sets   of   the   form   { U   ∈   R n × p :   U T U   =   I p }   have   the   structure   of   an   embedded   submanifold   of   R n × p called   the   (orthogonal) Stiefel manifold (Section   3.3),   and   the   constraint   set   for   ( U, V   )   is   then   a   product   manifold   (Section   3.1.6).  

[Page 25]

# 2.2.2 Matrix approximations

In   the   previous   section,   we   saw   that   the   truncated   SVD   solves   a   particular   kind   of   matrix   approximation   problem,   the   best   low-rank   approximation   in   the   least-squares   sense.   There   are   several   other   matrix   approximation   problems   that   can   be   written   as   minimizing   a   real-valued   function   on   a   manifold.  

Within   the   matrix   nearness   framework  

$$
\min _ { X \in \mathcal { M } } \| A - X \| _ { F } ^ { 2 } ,
$$

we   have,   for   example,   the   following   symmetric   positive-deﬁnite   least-squares   problem.  

$$
F i n d \ C \in \mathbb { R } ^ { n \times n } \\ \intertext { t o \minimize } \intertext { s u b t o \ r a k ( C ) = p , \ C = C ^ { T } , \ C \succeq 0 , } \intertext { R C \succ 0 \, \detotes c a n t , \ C is \, \text {positive-semidefinite} ; \ i , e , \ x ^ { T } C x > 0 \, \text { for all } }
$$

where   C       0   denotes   that   C   is   positive-semideﬁnite;   i.e.,   x T Cx   ≥   0   for   all   x   ∈   R n .   We   can   rephrase   this   constrained   problem   as   a   problem   on   the   set   R n ∗ × p of   all   n   ×   p   full-rank   matrices   by   setting   C   =   Y Y   T ,   Y   ∈   R n ∗ × p .   The   new   search   space   is   simpler,   but   the   new   cost   function  

$$
f \colon \mathbb { R } _ { * } ^ { n \times p } \rightarrow \mathbb { R } \colon Y \mapsto \| Y Y ^ { T } - C _ { 0 } \| ^ { 2 } \\ \\
$$

has   the   symmetry   property   f ( Y Q ) =   f ( Y   )   for   all   orthonormal   p × p   matrices   Q ,   hence   minimizers   of   f   are   not   isolated   and   the   problems   mentioned   in   Section   2.1   for   Rayleigh   quotient   minimization   are   likely   to   appear.   This   again   points   to   a   quotient   manifold   approach,   where   a   set   { Y Q   :   Q T Q   =   I } is   identiﬁed   as   one   point   of   the   quotient   manifold.  

A   variation   on   the   previous   problem   is   the   best   low-rank   approximation   of   a   correlation   matrix   by   another   correlation   matrix   [BX05]:  

$$
F \text { Find } \ C \in \mathbb { R } ^ { n \times n } \\ \text {to minimize } & \ \| C - C _ { 0 } \| ^ { 2 } \\ \text {subject to } & \ \text {rank} ( C ) = p , \ C _ { i i } = 1 \ ( i = 1 , \dots , n ) , \ C \geq 0 . \\ \text {Again } & \ \text {setting } C = Y Y ^ { T } \ Y \in \mathbb { R } ^ { n \times p } \ \text {tasks care of the rank constraint } \ Re .
$$

Again,   setting   C   =   Y Y   T ,   Y   ∈   R ∗   n × p ,   takes   care   of   the   rank   constraint.   Replacing   this   form   in   the   constraint   C ii =   1,   i   = 1 , . . . , n ,   yields   diag( Y Y   T ) =   I .   This   constraint   set   can   be   shown   to   admit   a   manifold   structure   called   an   oblique manifold :  

$$
\mathcal { O B } \coloneqq \{ Y \in \mathbb { R } _ { * } ^ { n \times p } \colon \text {diag} ( Y Y ^ { T } ) = I _ { n } \} ; \\ \intertext { o o } \Omega _ { \ } T I \Omega _ { \ } A O \Omega _ { \ } T I \Omega _ { \ } D i g ( Y Y ^ { T } ) = I _ { n } \} ;
$$

see,   e.g.,   [Tre99,   TL02,   AG06].   This   manifold-based   approach   is   further   developed   in   [GP07].  

A   more   general   class   of   matrix   approximation   problems   is   the   Procrustes problem [GD04]  

$$
\min _ { X \in \mathcal { M } } \| A X - B \| _ { F } ^ { 2 } , \ \ A \in \mathbb { R } ^ { l \times m } , B \in \mathbb { R } ^ { l \times n } , \quad \\
$$

[Page 26]

where   M ⊆   R m × n .   Taking   M   =   R m × n yields   a   standard   least-squares   problem.   The   orthogonal   case,   M   =   O n =   { X   ∈   R n × n :   X T X   =   I } ,   has   a   closed-form   solution   in   terms   of   the   polar   decomposition   of   B T A   [GVL96].   The   case   M   =   { X   ∈   R m × n :   X T X   =   I } ,   where   M   is   a   Stiefel   manifold,   is   known   as   the   unbalanced orthogonal Procrustes problem ;   see   [EP99]   and   references   therein.   The   case   M   =   { X   ∈   R n × n :   diag( X T X ) =   I n } ,   where   M   is   an   oblique   manifold,   is   called   the   oblique Procrustes problem [Tre99,   TL02].  

# 2.2.3 Independent component analysis

Independent   component   analysis   (ICA),   also   known   as   blind   source   separation   (BSS),   is   a   computational   problem   that   has   received   much   attention   in   recent   years,   particularly   for   its   biomedical   applications   [JH05].   A   typical   application   of   ICA   is   the   “cocktail   party   problem”,   where   the   task   is   to   recover   one   or   more   signals,   supposed   to   be   statistically   independent,   from   recordings   where   they   appear   as   linear   mixtures.   Speciﬁcally,   assume   that   n   measured   signals   x ( t ) = [ x 1 ( t ) , . . . , x n ( t )] T are   instantaneous   linear   mixtures   of   p   underlying,   statistically   independent   source   signals   s ( t ) = [ s 1 ( t ) , . . . , s p ( t )] T .   In   matrix   notation,   we   have  

$$
x ( t ) = A s ( t ) ,
$$

where   the   n   ×   p   matrix   A   is   an   unknown   constant   mixing matrix containing   the   mixture   coeﬃcients.   The   ICA   problem   is   to   identify   the   mixing   matrix   A   or   to   recover   the   source   signals   s ( t )   using   only   the   observed   signals   x ( t ).  

This   problem   is   usually   translated   into   ﬁnding   an   n   ×   p   separating matrix (or   demixing matrix )   W   such   that   the   signals   y ( t )   given   by  

$$
y ( t ) = W ^ { T } x ( t )
$$

are   “as   independent   as   possible”.   This   approach   entails   deﬁning   a   cost   function   f ( W   )   to   measure   the   independence   of   the   signals   y ( t ),   which   brings   us   to   the   realm   of   numerical   optimization.   This   separation   problem,   however,   has   the   structural   symmetry   property   that   the   measure   of   independence   of   the   components   of   y ( t )   should   not   vary   when   diﬀerent   scaling   factors   are   applied   to   the   components   of   y ( t ).   In   other   words,   the   cost   function   f   should   satisfy   the   invariance   property   f ( W D ) =   f ( W   )   for   all   nonsingular   diagonal   matrices   D .   A   possible   choice   for   the   cost   function   f   is   the   log   likelihood   criterion  

$$
f ( W ) & \coloneqq \sum _ { k = 1 } ^ { K } n _ { k } ( \log \det \text {diag} ( W ^ { * } C _ { k } W ) - \log \det ( W ^ { * } C _ { k } W ) ) , \\ \text {where } & \, \ C _ { k } \text {'s are covariance-like matrices constructed from } x ( t ) \text { and }
$$

where   the   C k ’s   are   covariance-like   matrices   constructed   from   x ( t )   and   diag( A )   denotes   the   diagonal   matrix   whose   diagonal   is   the   diagonal   of   A ;   see,   e.g.,   [Yer02]   for   the   choice   of   the   matrices   C k ,   and   [Pha01]   for   more   information   on   the   cost   function   (2.7).  

The invariance property f ( WD ) = f ( W ), similarly to the homogeneity property observed for the Rayleigh quotient (2.2), produces a continuum of minimizers if W is allowed to vary on the whole space of n × p matrices. Much as in the case of the Rayleigh quotient, this can be addressed by restraining the domain of f to a constraint set that singles out fi nitely many points in each equivalence class { WD : D diagonal } ; a possible choice for the constraint set is the oblique manifold

[Page 27]

$$
\mathcal { O B } = \{ W \in \mathbb { R } _ { * } ^ { n \times p } \colon d i a g ( W W ^ { T } ) = I _ { n } \} . \\ \intertext { . } \mathcal { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon \mathbb { I } \colon
$$

Another   possibility   is   to   identify   all   the   matrices   within   an   equivalence   class   { W D   :   D   diagonal }   as   a   single   point,   which   leads   to   a   quotient   manifold   approach.  

Methods   for   ICA   based   on   diﬀerential-geometric   optimization   have   been   proposed   by,   among   others,   Amari   et al. [ACC00],   Douglas   [Dou00],   Rahbar   and   Reilly   [RR00],   Pham   [Pha01],   Joho   and   Mathis   [JM02],   Joho   and   Rahbar   [JR02],   Nikpour   et al. [NMH02],   Afsari   and   Krishnaprasad   [AK04],   Nishimori   and   Akaho   [NA05],   Plumbley   [Plu05],   Absil   and   Gallivan   [AG06],   Shen   et al. [SHS06],   and   H¨ ueper   et al. [HSS06];   see   also   several   other   references   therein.  

# 2.2.4 Pose estimation and motion recovery

In   the   pose   estimation   problem,   an   object   is   known   via   a   set   of   landmarks   { m i } i =1 ,...,N ,   where   m i :=   ( x i , y i , z i ) T ∈   R 3 are   the   three   coordinates   of   ′   the   i th   landmark   in   an   object-centered   frame.   The   coordinates   m i of   the   landmarks   in   a   camera-centered   frame   obey   a   rigid   body   displacement   law  

$$
m _ { i } ^ { \prime } = R m _ { i } + t ,
$$

where   R   ∈   SO 3 (i.e.,   R T R   =   I   and   det( R )   =   1)   represents   a   rotation   and   t   ∈   R 3 stands   for   a   translation.   Each   landmark   point   produces   a   normalized   image   point   in   the   image   plane   of   the   camera   with   coordinates  

$$
u _ { i } = \frac { R m _ { i } + t } { e _ { 3 } ^ { T } ( R m _ { i } + t ) } .
$$

The   pose   estimation   problem   is   to   estimate   the   pose   ( R, t )   in   the   manifold   SO 3 ×   R 3 from   a   set   of   point   correspondences   { ( u i , m i ) } i =1 ,...,N .   A   possible   approach   is   to   minimize   the   real-valued   function  

$$
f \colon S O _ { 3 } \times \mathbb { R } ^ { 3 } & \to \mathbb { R } \colon ( R , t ) \mapsto \sum _ { i = 1 } ^ { N } \| ( I - u _ { i } u _ { i } ^ { T } ) ( R m _ { i } + t ) \| ^ { 2 } , \\ \text {which vanishes if and only if the points } u _ { i } \text { and } m _ { i } ^ { \prime } \text { are collinear, } i , e _ { i } , u _ { i } \text { is}
$$

′   which   vanishes   if   and   only   if   the   points   u i and   m i are   collinear,   i.e.,   u i is   indeed   the   coordinate   vector   of   the   projection   of   the   i th   landmark   onto   the   image   plane   of   the   camera.   This   is   an   optimization   problem   on   the   manifold   SO 3 × R 3 .   Since   rigid   body   motions   can   be   composed   to   obtain   another   rigid   body   motion,   this   manifold   possesses   a   group   structure   called   the   special Euclidean group SE 3 .  

A related problem is motion and structure recovery from a sequence of images. Now the object is unknown, but two or more images are available from different angles. Assume that N landmarks have been selected on the object and, for simplicity, consider only two images of the object. The coordinates ′ ′′ m i and m i of the i th landmark in the fi rst and second camera frames are related by a rigid body motion

[Page 28]

$$
m _ { i } ^ { \prime \prime } = R m _ { i } ^ { \prime } + t .
$$

Again   without   loss   of   generality,   the   coordinates   of   the   projections   of   the   ′ i i th   landmark   onto   each   camera   image   plane   are   given   by   p i =   e m m and   T ′ 3 i ′′ i q i =   e T m m ′′ .   The   motion   and   structure   recovery   problem   is,   from   a   set   of   3 i corresponding   image   points   { ( p i , q i ) } i =1 ,...,N ,   to   recover   the   camera   motion   ( R, t )   and   the   three-dimensional   coordinates   of   the   points   that   the   images   correspond   to.   It   is   a   classical   result   in   computer   vision   that   corresponding   coordinate   vectors   p   and   q   satisfy   the   epipolar constraint

$$
p ^ { T } R ^ { T } t ^ { \wedge } q = 0 ,
$$

where   t ∧   is   the   3   ×   3   skew-symmetric   matrix     0   t t

$$
\ s k e w { - s y m m e t r i c } \, \ m a t r i x \\ \ t ^ { \wedge } \colon = \begin{bmatrix} 0 & - t _ { 3 } & t _ { 2 } \\ t _ { 3 } & 0 & - t _ { 1 } \\ - t _ { 2 } & t _ { 1 } & 0 \end{bmatrix} . \\ \intertext { o n } ( R , t ) \in S O _ { 3 } \times \mathbb { R } ^ { 3 } \text { from a given } \quad \colon
$$

To   recover   the   motion   ( R, t )   ∈   SO 3 ×   R 3 from   a   given   set   of   image   correspondences   { ( p i , q i ) } i =1 ,...,N ,   it   is   thus   natural   to   consider   the   cost   function   N

$$
f ( R , t ) \colon = & \sum _ { i = 1 } ^ { N } ( p _ { i } ^ { T } R ^ { T } t ^ { \wedge } q _ { i } ) ^ { 2 } , \quad p _ { i } , q _ { i } \in \mathbb { R } ^ { 3 } , ( R , t ) \in S O _ { 3 } \times \mathbb { R } ^ { 3 } . \\ \intertext { This function is homogeneous in $t$. As in the case of Rayleigh quotient mini- }
$$

This   function   is   homogeneous   in   t .   As   in   the   case   of   Rayleigh   quotient   minimization,   this   can   be   addressed   by   restricting   t   to   the   unit   sphere   S 2 ,   which   yields   the   problem   of   minimizing   the   cost   function  

$$
f ( R , t ) \colon = & \sum _ { i = 1 } ^ { N } ( p _ { i } ^ { T } R ^ { T } t ^ { \wedge } q _ { i } ) ^ { 2 } , \quad p _ { i } , q _ { i } \in \mathbb { R } ^ { 3 } , ( R , t ) \in S O _ { 3 } \times S ^ { 2 } . \\ \text {Equivalently, this problem can be written as the minimization of the cost}
$$

Equivalently,   this   problem   can   be   written   as   the   minimization   of   the   cost   function  

$$
f ( E ) = & \colon \sum _ { i = 1 } ^ { N } ( p _ { i } ^ { T } E q _ { i } ) ^ { 2 } , \quad p _ { i } , q _ { i } \in \mathbb { R } ^ { 3 } , E \in \mathcal { E } _ { 1 } , \\ \text {is the normalized essential manifold}
$$

where E 1 is the normalized  essential  manifold

$$
\mathcal { E } _ { 1 } & \colon = \{ R t ^ { \wedge } \colon R \in S O _ { 3 } , \ t ^ { \wedge } \in \mathfrak { s o } _ { 3 } , \ \frac { 1 } { 2 } t r ( ( t ^ { \wedge } ) ^ { T } t ^ { \wedge } ) = 1 \} . \\ \{ O \subset \mathbb { T } ^ { 3 \times 3 } _ { 3 } \circ O T \quad O T \quad O ] \text { is } t _ { 3 } \cup \mathbb { E } _ { 3 } \cup \mathbb { S } O \ \{ O \subset \mathbb { T } ^ { 3 } \cup t _ { 3 } \cup t _ { 4 } \cup \mathbb { F } \subset t + 1 \} = 1 \} .
$$

( so 3 =   { Ω   ∈   R 3 × 3 : Ω T =   − Ω }   is   the   Lie   algebra   of   SO 3 ,   and   the   tr   function   returns   the   sum   of   the   diagonal   elements   of   its   argument.)  

For   more   details   on   multiple-view   geometry,   we   refer   the   reader   to   Hartley   and   Zisserman   [HZ03].   Applications   of   manifold   optimization   to   computer   vision   problems   can   be   found   in   the   work   of   Ma   et al. [MKS01],   Lee   and   Moore   [LM04],   Liu   et al. [LSG04],   and   Helmke   et al. [HHLM07].  

[Page 29]

# 2.3 NOTES AND REFERENCES

Each   chapter   of   this   book   (excepting   the   introduction)   has   a   Notes   and   References   section   that   contains   pointers   to   the   literature.   In   the   following   chapters,   all   the   citations   will   appear   in   these   dedicated   sections.  

Recent   textbooks   and   surveys   on   the   eigenvalue   problem   include   Golub   and   van   der   Vorst   [GvdV00],   Stewart   [Ste01],   and   Sorensen   [Sor02].   An   overview   of   applications   can   be   found   in   Saad   [Saa92].   A   major   reference   for   the   symmetric   eigenvalue   problem   is   Parlett   [Par80].   The   characterization   of   eigenproblems   as   minimax   problems   goes   back   to   the   time   of   Poincar´ e.   Early   references   are   Fischer   [Fis05]   and   Courant   [Cou20],   and   the   results   are   often   referred   to   as   the   Courant-Fischer   minimax   formulation.   The   formulation   is   heavily   exploited   in   perturbation   analysis   of   Hermitian   eigenstructure.   Good   overviews   are   available   in   Parlett   [Par80,   § 10   and   11,   especially   § 10.2],   Horn   and   Johnson   [HJ91,   § 4.2],   and   Wilkinson   [Wil65,   § 2].   See   also   Bhatia   [Bha87]   and   Golub   and   Van   Loan   [GVL96,   § 8.1].   Until   recently,   the   diﬀerential-geometric   approach   to   the   eigenproblem  

had   been   scarcely   exploited   because   of   tough   competition   from   some   highly   eﬃcient   mainstream   algorithms   combined   with   a   lack   of   optimization   algorithms   on   manifolds   geared   towards   computational   eﬃciency.   However,   thanks   in   particular   to   the   seminal   work   of   Helmke   and   Moore   [HM94]   and   Edelman,   Arias,   and   Smith   [Smi93,   Smi94,   EAS98],   and   more   recent   work   by   Absil   et al. [ABG04,   ABG07],   manifold-based   algorithms   have   now   appeared   that   are   competitive   with   state-of-the-art   methods   and   sometimes   shed   new   light   on   their   properties.   Papers   that   apply   diﬀerential-geometric   concepts   to   the   eigenvalue   problem   include   those   by   Chen   and   Amari   [CA01],   Lundstr¨ om   and   Eld´ en   [LE02],   Simoncinin   and   Eld´ en   [SE02],   Brandts   [Bra03],   Absil   et al. [AMSV02,   AMS04,   ASVM04,   ABGS05,   ABG06b],   and   Baker   et al. [BAG06].   One   “mainstream”   approach   capable   of   satisfying   all   the   requirements   in   Section   2.1.2   is   the   Jacobi-Davidson   conjugate   gradient   (JDCG)   method   of   Notay   [Not02].   Interestingly,   it   is   closely   related   to   an   algorithm   derived   from   a   manifold-based   trust-region   approach   (see   Chapter   7   or   [ABG06b]).  

The   proof   of   Proposition   2.1.1   is   adapted   from   [Fan49].   The   fact   that   the   classical   Newton   method   fails   for   the   Rayleigh   quotient   (Proposition   2.1.2)   was   pointed   out   in   [ABG06b],   and   a   proof   was   given   in   [Zho06].  

Major   references   for   Section   2.2   include   Helmke   and   Moore   [HM94],   Edelman   et al. [EAS98],   and   Lippert   and   Edelman   [LE00].   The   cost   function   suggested   for   the   SVD   (Section   2.2.1)   comes   from   Helmke   and   Moore   [HM94,   Ch.   3].   Problems   (2.4)   and   (2.5)   are   particular   instances   of   the   least-squares covariance adjustment problem recently   deﬁned   by   Boyd   and   Xiao   [BX05];   see   also   Manton   et al. [MMH03],   Grubisic   and   Pietersz   [GP07],   and   several   references   therein.  

[Page 30]

# Matrix   Manifolds:   First-Order   Geometry  

The   constraint   sets   associated   with   the   examples   discussed   in   Chapter   2   have   a   particularly   rich   geometric   structure   that   provides   the   motivation   for   this   book.   The   constraint   sets   are   matrix manifolds in   the   sense   that   they   are   manifolds   in   the   meaning   of   classical   diﬀerential   geometry,   for   which   there   is   a   natural   representation   of   elements   in   the   form   of   matrix   arrays.  

The   matrix   representation   of   the   elements   is   a   key   property   that   allows   one   to   provide   a   natural   development   of   diﬀerential   geometry   in   a   matrix   algebra   formulation.   The   goal   of   this   chapter   is   to   introduce   the   fundamental   concepts   in   this   direction:   manifold   structure,   tangent   spaces,   cost   functions,   diﬀerentiation,   Riemannian   metrics,   and   gradient   computation.  

There   are   two   classes   of   matrix   manifolds   that   we   consider   in   detail   in   this   book:   embedded   submanifolds   of   R n × p and   quotient   manifolds   of   R n × p (for   1   ≤   p   ≤   n ).   Embedded   submanifolds   are   the   easiest   to   understand,   as   they   have   the   natural   form   of   an   explicit   constraint   set   in   matrix   space   R n × p .   The   case   we   will   be   mostly   interested   in   is   the   set   of   orthonormal   n   ×   p   matrices   that,   as   will   be   shown,   can   be   viewed   as   an   embedded   submanifold   of   R n × p called   the   Stiefel   manifold   St( p, n ).   In   particular,   for   p   =   1,   the   Stiefel   manifold   reduces   to   the   unit   sphere   S n − 1 ,   and   for   p   =   n ,   it   reduces   to   the   set   of   orthogonal   matrices   O ( n ).  

Quotient   spaces   are   more   diﬃcult   to   visualize,   as   they   are   not   deﬁned   as   sets   of   matrices;   rather,   each   point   of   the   quotient   space   is   an   equivalence   class   of   n   ×   p   matrices.   In   practice,   an   example   n   ×   p   matrix   from   a   given   equivalence   class   is   used   to   represent   an   element   of   matrix   quotient   space   in   computer   memory   and   in   our   numerical   development.   The   calculations   related   to   the   geometric   structure   of   a   matrix   quotient   manifold   can   be   expressed   directly   using   the   tools   of   matrix   algebra   on   these   representative   matrices.  

The   focus   of   this   ﬁrst   geometric   chapter   is   on   the   concepts   from   diﬀerential   geometry   that   are   required   to   generalize   the   steepest-descent   method,   arguably   the   simplest   approach   to   unconstrained   optimization.   In   R n ,   the   steepest-descent   algorithm   updates   a   current   iterate   x   in   the   direction   where   the   ﬁrst-order   decrease   of   the   cost   function   f   is   most   negative.   Formally,   the   update   direction   is   chosen   to   be   the   unit   norm   vector   η   that   minimizes   the   directional   derivative  

$$
D f \left ( x \right ) \left [ \eta \right ] & = \lim _ { t \rightarrow 0 } \frac { f ( x + t \eta ) - f ( x ) } { t } . \\
$$

When the domain of f is a manifold M , the argument x + tη in (3.1) does not make sense in general since M is not necessarily a vector space. This leads to the important concept of a tangent vector (Section 3.5). In order to define the notion of a steepest-descent direction, it will then remain to define the length of a tangent vector, a task carried out in Section 3.6 where the concept of a Riemannian manifold is introduced. This leads to a definition of the gradient of a function, the generalization of steepest-descent direction on a Riemannian manifold.

[Page 31]

# 3.1 MANIFOLDS

We   deﬁne   the   notion   of   a   manifold   in   its   full   generality;   then   we   consider   the   simple   but   important   case   of   linear   manifolds,   a   linear   vector   space   interpreted   as   a   manifold   with   Euclidean   geometric   structure.   The   manifold   of   n × p   real   matrices,   from   which   all   concrete   examples   in   this   book   originate,   is   a   linear   manifold.  

A   d -dimensional   manifold   can   be   informally   deﬁned   as   a   set   M   covered   with   a   “suitable”   collection   of   coordinate   patches,   or   charts,   that   identify   certain   subsets   of   M   with   open   subsets   of   R d .   Such   a   collection   of   coordinate   charts   can   be   thought   of   as   the   basic   structure   required   to   do   diﬀerential   calculus   on   M .   It   is   often   cumbersome   or   impractical   to   use   coordinate   charts   to   (locally)  

turn   computational   problems   on   M   into   computational   problems   on   R d .   The   numerical   algorithms   developed   later   in   this   book   rely   on   exploiting   the   natural   matrix   structure   of   the   manifolds   associated   with   the   examples   of   interest,   rather   than   imposing   a   local   R d structure.   Nevertheless,   coordinate   charts   are   an   essential   tool   for   addressing   fundamental   notions   such   as   the   diﬀerentiability   of   a   function   on   a   manifold.  

# 3.1.1 Deﬁnitions: charts, atlases, manifolds

The   abstract   deﬁnition   of   a   manifold   relies   on   the   concepts   of   charts   and   atlases.  

Let   M   be   a   set.   A   bijection   (one-to-one   correspondence)   ϕ   of   a   subset   U of   M   onto   an   open   subset   of   R d is   called   a   d -dimensional   chart of the set M ,   denoted   by   ( U , ϕ ).   When   there   is   no   risk   of   confusion,   we   will   simply   write   ϕ   for   ( U , ϕ ).   Given   a   chart   ( U , ϕ )   and   x   ∈ U ,   the   elements   of   ϕ ( x )   ∈   R d are   called   the   coordinates of   x   in   the   chart   ( U , ϕ ).   The   interest   of   the   notion   of   chart   ( U , ϕ )   is   that   it   makes   it   possible   to  

study   objects   associated   with   U   by   bringing   them   to   the   subset   ϕ ( U )   of   R d .   For   example,   if   f   is   a   real-valued   function   on   U ,   then   f   ◦   ϕ − 1 is   a   function   from   R d to   R ,   with   domain   ϕ ( U ),   to   which   methods   of   real   analysis   apply.   To   take   advantage   of   this   idea,   we   must   require   that   each   point   of   the   set   M   be   at   least   in   one   chart   domain;   moreover,   if   a   point   x   belongs   to   the   domains   of   two   charts   ( U 1 , ϕ 1 )   and   ( U 2 , ϕ 2 ),   then   the   two   charts   must   give   compatible   information:   for   example,   if   a   real-valued   function   f   is   deﬁned  

[Page 32]

![In this image, we can see a diagram with some lines and points. There are some lines and points in the diagram.](<images/imageFile2.png>)

d

R

d

R

U

∩ V )

ϕ

(

)

U

∩ V )

ψ

(

)

-

1

◦

ψ

ϕ

U

ϕ

(

)

-

1

◦

ϕ

ψ

V

ψ

(

)

ϕ 	

ψ

U  

V  

Figure 3.1 Charts.

ϕ -1 ϕ -1 on U 1 ∩ U 2 , then f and f 2 should have the same differentiability ◦ 1 ◦ properties on U 1 ∩ U 2 .

The following concept takes these requirements into account. A ( C ∞ ) atlas of M into R d is a collection of charts ( U α , ϕ α ) of the set M such that

1. 	   α U α =   M ,   2. 	 for   any   pair   α ,   β   with   U α ∩U β =   ∅ ,   the   sets   ϕ α ( U α ∩U β )   and   ϕ β ( U α ∩U β )   are   open   sets   in   R d and   the   change   of   coordinates  

/negationslash

$$
\varphi _ { \beta } \circ \varphi _ { \alpha } ^ { - 1 } \colon \mathbb { R } ^ { d } \to \mathbb { R } ^ { d } \\
$$

(see   Appendix   A.3   for   our   conventions   on   functions)   is   smooth (class   C ∞ ,   i.e.,   diﬀerentiable   for   all   degrees   of   diﬀerentiation)   on   its   domain   ϕ α ( U α ∩ U β );   see   illustration   in   Figure   3.1.   We   say   that   the   elements   of   an   atlas   overlap smoothly .  

Two   atlases   A 1 and   A 2 are   equivalent if   A 1 ∪ A 2 is   an   atlas;   in   other   words,   for   every   chart   ( U , ϕ )   in   A 2 ,   the   set   of   charts   A 1 ∪ { ( U , ϕ ) }   is   still   an   atlas.   Given   an   atlas   A ,   let   A + be   the   set   of   all   charts   ( U , ϕ )   such   that   A ∪ { ( U , ϕ ) }   is   also   an   atlas.   It   is   easy   to   see   that   A + is   also   an   atlas,   called   the   maximal atlas (or   complete atlas )   generated   by   the   atlas   A .   Two   atlases   are   equivalent   if   and   only   if   they   generate   the   same   maximal   atlas.   A   maximal   atlas   of   a   set   M   is   also   called   a   diﬀerentiable structure on   M .   In   the   literature,   a   manifold   is   sometimes   simply   deﬁned   as   a   set   endowed  

with   a   diﬀerentiable   structure.   However,   this   deﬁnition   does   not   exclude   certain   unconventional   topologies.   For   example,   it   does   not   guarantee   that   convergent   sequences   have   a   single   limit   point   (an   example   is   given   in   Section   4.3.2).   To   avoid   such   counterintuitive   situations,   we   adopt   the   following   classical   deﬁnition.   A   ( d -dimensional) manifold is   a   couple   ( M ,   A + ),   where   M   is   a   set   and   A + is   a   maximal   atlas   of   M   into   R d ,   such   that   the   topology  

[Page 33]

A   maximal   atlas   of   a   set   M   that   induces   a   second-countable   Hausdorﬀ   topology   is   called   a   manifold structure on   M .   Often,   when   ( M ,   A + )   is   a   manifold,   we   simply   say   “the   manifold   M ”   when   the   diﬀerentiable   structure   is   clear   from   the   context,   and   we   say   “the   set   M ”   to   refer   to   M   as   a   plain   set   without   a   particular   diﬀerentiable   structure.   Note   that   it   is   not   necessary   to   specify   the   whole   maximal   atlas   to   deﬁne   a   manifold   structure:   it   is   enough   to   provide   an   atlas   that   generates   the   manifold   structure.   +

Given   a   manifold   ( M ,   A ),   an   atlas   of   the   set   M   whose   maximal   atlas   is   A + is   called   an   atlas of the manifold ( M ,   A + );   a   chart   of   the   set   M   that   belongs   to   A + is   called   a   chart of the manifold ( M ,   A + ),   and   its   domain   is   a   coordinate domain of   the   manifold.   By   a   chart   around   a   point   x   ∈ M ,   we   mean   a   chart   of   ( M ,   A + )   whose   domain   U   contains   x .   The   set   U   is   then   a   coordinate neighborhood of   x .   − 1

Given   a   chart   ϕ   on   M ,   the   inverse   mapping   ϕ is   called   a   local parameterization of   M .   A   family   of   local   parameterizations   is   equivalent   to   a   family   of   charts,   and   the   deﬁnition   of   a   manifold   may   be   given   in   terms   of   either.  

# 3.1.2 The topology of a manifold*

Recall   that   the   star   in   the   section   title   indicates   material   that   can   be   readily   skipped   at   a   ﬁrst   reading.  

It   can   be   shown   that   the   collection   of   coordinate   domains   speciﬁed   by   a   maximal   atlas   A + of   a   set   M   forms   a   basis   for   a   topology   of   the   set   M .   (We   refer   the   reader   to   Section   A.2   for   a   short   introduction   to   topology.)   We   call   this   topology   the   atlas topology of   M   induced   by   A .   In   the   atlas   topology,   a   subset   V   of   M   is   open   if   and   only   if,   for   any   chart   ( U , ϕ )   in   A + ,   ϕ ( V ∩ U )   is   an   open   subset   of   R d .   Equivalently,   a   subset   V   of   M   is   open   if   and   only   if,   for   each   x   ∈ V ,   there   is   a   chart   ( U , ϕ )   in   A + such   that   x   ∈ U   ⊂ V .   An   atlas   A   of   a   set   M   is   said   to   be   compatible with   a   topology   T   on   the   set   M if   the   atlas   topology   is   equal   to   T   .   An   atlas   topology   always   satisﬁes   separation   axiom   T 1 ,   i.e.,   given   any   two  

distinct   points   x   and   y ,   there   is   an   open   set   U   that   contains   x   and   not   y .   (Equivalently,   every   singleton   is   a   closed   set.)   But   not   all   atlas   topologies   are   Hausdorﬀ (i.e.,   T 2 ):   two   distinct   points   do   not   necessarily   have   disjoint   neighborhoods.   Non-Hausdorﬀ   spaces   can   display   unusual   and   counterintuitive   behavior.   From   the   perspective   of   numerical   iterative   algorithms   the   most   worrying   possibility   is   that   a   convergent   sequence   on   a   non-Hausdorﬀ   topological   space   may   have   several   distinct   limit   points.   Our   deﬁnition   of   manifold   rules   out   non-Hausdorﬀ   topologies.  

A   topological   space   is   second-countable if   there   is   a   countable   collection   B of   open   sets   such   that   every   open   set   is   the   union   of   some   subcollection   of   B .   Second-countability   is   related   to   partitions of unity ,   a   crucial   tool   in   resolving   certain   fundamental   questions   such   as   the   existence   of   a   Riemannian   metric   (Section   3.6)   and   the   existence   of   an   aﬃne   connection   (Section   5.2).  

[Page 34]

For   a   manifold   ( M ,   A ),   we   refer   to   the   atlas   topology   of   M   induced   by   A   as   the   manifold topology of M .   Note   that   several   statements   in   this   book   also   hold   without   the   Hausdorﬀ   and   second-countable   assumptions.   These   cases,   however,   are   of   marginal   importance   and   will   not   be   discussed.   +

Given   a   manifold   ( M ,   A )   and   an   open   subset   X   of   M   (open   is   to   be   understood   in   terms   of   the   manifold   topology   of   M ),   the   collection   of   the   charts   of   ( M ,   A + )   whose   domain   lies   in   X   forms   an   atlas   of   X   .   This   deﬁnes   a   diﬀerentiable   structure   on   of   the   same   dimension   as   With   this   X M .   structure,   X   is   called   an   open submanifold of   M .   A   manifold   is   connected if   it   cannot   be   expressed   as   the   disjoint   union   of  

two   nonempty   open   sets.   Equivalently   (for   a   manifold),   any   two   points   can   be   joined   by   a   piecewise   smooth   curve   segment.   The   connected   components   of   a   manifold   are   open,   thus   they   admit   a   natural   diﬀerentiable   structure   as   open   submanifolds.   The   optimization   algorithms   considered   in   this   book   are   iterative   and   oblivious   to   the   existence   of   connected   components   other   than   the   one   to   which   the   current   iterate   belongs.   Therefore   we   have   no   interest   in   considering   manifolds   that   are   not   connected.  

# 3.1.3 How to recognize a manifold

Assume   that   a   computational   problem   involves   a   search   space   X   .   How   can   we   check   that   X   is   a   manifold?   It   should   be   clear   from   Section   3.1.1   that   this   question   is   not   well   posed:   by   deﬁnition,   a   manifold   is   not   simply   a   set   X   but   rather   a   couple   ( X   ,   A + )   where   X   is   a   set   and   A + is   a   maximal   atlas   of   X   inducing   a   second-countable   Hausdorﬀ   topology.   A   well-posed   question   is   to   ask   whether   a   given   set   X   admits   an   atlas.  

There   are   sets   that   do   not   admit   an   atlas   and   thus   cannot   be   turned   into   a   manifold.   A   simple   example   is   the   set   of   rational   numbers:   this   set   does   not   even   admit   charts;   otherwise,   it   would   not   be   denumerable.   Nevertheless,   sets   abound   that   admit   an   atlas.   Even   sets   that   do   not   “look”   diﬀerentiable   may   admit   an   atlas.   For   example,   consider   the   curve   γ   :   R   →   R 2 :   γ ( t ) =   ( t,   | t | )   and   let   X   be   the   range   of   γ ;   see   Figure   3.2.   Consider   the   chart   ϕ   :   X →   R   : ( t,   | t | )    →   t .   It   turns   out   that   A   :=   { ( X   , ϕ ) }   is   an   atlas   of   the   set   X   ;   therefore,   ( X   ,   A + )   is   a   manifold.   The   incorrect   intuition   that   X   cannot   be   a   manifold   because   of   its   “corner”   corresponds   to   the   fact   that   X   is   not   a   submanifold of   R 2 ;   see   Section   3.3.  

A set X may admit more than one maximal atlas. As an example, take the set R and consider the charts ϕ 1 : x ↦→ x and ϕ 2 : x ↦→ x 3 . Note that ϕ 1 ϕ -1 and ϕ 2 are not compatible since the mapping ϕ 1 2 is not differentiable ◦ at the origin. However, each chart individually forms an atlas of the set R . These two atlases are not equivalent; they do not generate the same maximal atlas. Nevertheless, the chart x ↦→ x is clearly more natural than the chart x ↦→ x 3 . Most manifolds of interest admit a differentiable structure that is the most 'natural'; see in particular the notions of embedded and quotient matrix manifold in Sections 3.3 and 3.4.

[Page 35]

![image 3](<images/imageFile3.png>)

e

2

e

1

Figure 3.2 Image of the curve γ : t  → ( t, | t | ).

# 3.1.4 Vector spaces as manifolds

Let   E   be   a   d -dimensional   vector   space.   Then,   given   a   basis   ( e i ) i =1 ,...,d of   E ,   the   function    

$$
\psi \colon \mathcal { E } \rightarrow \mathbb { R } ^ { d } \colon x \mapsto \begin{bmatrix} x ^ { 1 } \\ \vdots \\ x ^ { d } \end{bmatrix}
$$

i such   that   x   =     d e i is   a   chart   of   the   set   E .   All   charts   built   in   this   way   i =1 x are   compatible;   thus   they   form   an   atlas   of   the   set   E ,   which   endows   E   with   a   manifold   structure.   Hence,   every   vector   space   is   a   linear manifold in   a   natural   way.  

Needless   to   say,   the   challenging   case   is   the   one   where   the   manifold   structure   is   nonlinear ,   i.e.,   manifolds   that   are   not   endowed   with   a   vector   space   structure.   The   numerical   algorithms   considered   in   this   book   apply   equally   to   linear   and   nonlinear   manifolds   and   reduce   to   classical   optimization   algorithms   when   the   manifold   is   linear.  

# 3.1.5 The manifolds R n × p and R n ∗ × p

Algorithms   formulated   on   abstract   manifolds   are   not   strictly   speaking   numerical   algorithms   in   the   sense   that   they   involve   manipulation   of   diﬀerentialgeometric   objects   instead   of   numerical   calculations.   Turning   these   abstract   algorithms   into   numerical   algorithms   for   speciﬁc   optimization   problems   relies   crucially   on   producing   adequate   numerical   representations   of   the   geometric   objects   that   arise   in   the   abstract   algorithms.   A   signiﬁcant   part   of   this   book   is   dedicated   to   building   a   toolbox   of   results   that   make   it   possible   to   perform   this   “geometric-to-numerical”   conversion   on   matrix   manifolds   (i.e.,   manifolds   obtained   by   taking   embedded   submanifolds   and   quotient   manifolds   of   R n × p ).   The   process   derives   from   the   manifold   structure   of   the   set   R n × p of   n   ×   p   real   matrices,   discussed   next.  

[Page 36]

The   manifold   R can   be   further   turned   into   a   Euclidean   space   with   the   inner   product  

$$
\langle Z _ { 1 } , Z _ { 2 } \rangle \colon = \text {vec} ( Z _ { 1 } ) ^ { T } \text {vec} ( Z _ { 2 } ) = \text {tr} ( Z _ { 1 } ^ { T } Z _ { 2 } ) .
$$

The   norm   induced   by   the   inner   product   is   the   Frobenius norm deﬁned   by  

$$
\| Z \| _ { F } ^ { 2 } = t r ( Z ^ { T } Z ) ,
$$

i.e.,     Z   2 is   the   sum   of   the   squares   of   the   elements   of   Z .   Observe   that   F the   manifold   topology   of   R n × p is   equivalent   to   its   canonical   topology   as   a   Euclidean   space   (see   Appendix   A.2).   n × p

Let   R ∗ ( p   ≤   n )   denote   the   set   of   all   n   ×   p   matrices   whose   columns   are   linearly   independent.   This   set   is   an   open   subset   of   R n × p since   its   complement   { X   ∈   R n × p :   det( X T X ) = 0 }   is   closed.   Consequently,   it   admits   a   structure   of   an   open   submanifold   of   R n × p .   Its   diﬀerentiable   structure   is   generated   by   R np the   chart   ϕ   :   R n ∗ × p →   :   X    →   vec( X ).   This   manifold   will   be   referred   to   as   the   manifold R n ∗ × p ,   or   the   noncompact Stiefel manifold of   full-rank   n   ×   p   matrices.  

In   the   particular   case   p   =   1,   the   noncompact   Stiefel   manifold   reduces   to   the   Euclidean   space   R n with   the   origin   removed.   When   p   =   n ,   the   noncompact   Stiefel   manifold   becomes   the   general   linear   group   GL n ,   i.e.,   the   set   of   all   invertible   n   ×   n   matrices.   Notice   that   the   chart   vec   :   R n × p R np is   unwieldy,   as   it   destroys   the   →

matrix   structure   of   its   argument;   in   particular,   vec( AB )   cannot   be   written   as   a   simple   expression   of   vec( A )   and   vec( B ).   In   this   book,   the   emphasis   is   on   preserving   the   matrix   structure.  

# 3.1.6 Product manifolds

Let   M 1 and   M 2 be   manifolds   of   dimension   d 1 and   d 2 ,   respectively.   The   set   M 1 × M 2 is   deﬁned   as   the   set   of   pairs   ( x 1 , x 2 ),   where   x 1 is   in   M 1 and   x 2 is   in   M 2 .   If   ( U 1 , ϕ 1 )   and   ( U 2 , ϕ 2 )   are   charts   of   the   manifolds   M 1 and   M 2 ,   respectively,   then   the   mapping   ϕ 1 ×   ϕ 2 :   U 1 × U 2 →   R d 1 ×   R d 2 : ( x 1 , x 2 )    → ( ϕ 1 ( x 1 ) , ϕ 2 ( x 2 ))   is   a   chart   for   the   set   M 1 ×M 2 .   All   the   charts   thus   obtained   form   an   atlas   for   the   set   M 1 ×M 2 .   With   the   diﬀerentiable   structure   deﬁned   by   this   atlas,   M 1 ×M 2 is   called   the   product of   the   manifolds   M 1 and   M 2 .   Its   manifold   topology   is   equivalent   to   the   product   topology.   Product   manifolds   will   be   useful   in   some   later   developments.  

[Page 37]

# 3.2 DIFFERENTIABLE FUNCTIONS

Mappings   between   manifolds   appear   in   many   places   in   optimization   algorithms   on   manifolds.   First   of   all,   any   optimization   problem   on   a   manifold   M   involves   a   cost   function,   which   can   be   viewed   as   a   mapping   from   the   manifold   M   into   the   manifold   R .   Other   instances   of   mappings   between   manifolds   are   inclusions   (in   the   theory   of   submanifolds;   see   Section   3.3),   natural   projections   onto   quotients   (in   the   theory   of   quotient   manifolds,   see   Section   3.4),   and   retractions   (a   fundamental   tool   in   numerical   algorithms   on   manifolds;   see   Section   4.1).   This   section   introduces   the   notion   of   diﬀerentiability   for   functions   between   manifolds.   The   coordinate-free   deﬁnition   of   a   diﬀerential   will   come   later,   as   it   requires   the   concept   of   a   tangent   vector.  

Let   F   be   a   function   from   a   manifold   M 1 of   dimension   d 1 into   another   manifold   M 2 of   dimension   d 2 .   Let   x   be   a   point   of   M 1 .   Choosing   charts   ϕ 1 and   ϕ 2 around   x   and   F   ( x ),   respectively,   the   function   F   around   x   can   be   “read   through   the   charts”,   yielding   the   function  

$$
\hat { F } = \varphi _ { 2 } \circ F \circ \varphi _ { 1 } ^ { - 1 } \colon \mathbb { R } ^ { d _ { 1 } } \to \mathbb { R } ^ { d _ { 2 } } , \\
$$

called   a   coordinate representation of   F   .   (Note   that   the   domain   of   F ˆ is   in   general   a   subset   of   R d 1 ;   see   Appendix   A.3   for   the   conventions.)   ˆ ∞  

We   say   that   F   is   diﬀerentiable or   smooth at   x   if   F is   of   class   C at   ϕ 1 ( x ).   It   is   easily   veriﬁed   that   this   deﬁnition   does   not   depend   on   the   choice   of   the   charts   chosen   at   x   and   F   ( x ).   A   function   F   :   M 1 → M 2 is   said   to   be   smooth if   it   is   smooth   at   every   point   of   its   domain.  

A   (smooth)   diﬀeomorphism F   :   M 1 → M 2 is   a   bijection   such   that   F   and   its   inverse   F   − 1 are   both   smooth.   Two   manifolds   M 1 and   M 2 are   said   to   be   diﬀeomorphic if   there   exists   a   diﬀeomorphism   on   M 1 onto   M 2 .   In this book, all functions are assumed to be smooth unless otherwise stated.

In this book, all functions are assumed to be smooth  unless otherwise stated.

# 3.2.1 Immersions and submersions

The   concepts   of   immersion   and   submersion   will   make   it   possible   to   deﬁne   submanifolds   and   quotient   manifolds   in   a   concise   way.   Let   F   :   M 1 → M 2 be   a   diﬀerentiable   function   from   a   manifold   M 1 of   dimension   d 1 into   a   manifold   M 2 of   dimension   d 2 .   Given   a   point   x   of   M 1 ,   the   rank of   F   at   x   is   the   dimension   of   the   range   of   D   F ˆ ( ϕ 1 ( x )) [ ]   :   R d 1 R d 2 ,   where   F ˆ is a   · → coordinate   representation   (3.3)   of   F   around   x ,   and   D   F ˆ ( ϕ 1 ( x ))   denotes   the   diﬀerential of   F ˆ at   ϕ 1 ( x )   (see   Section   A.5).   (Notice   that   this   deﬁnition   does   not   depend   on   the   charts   used   to   obtain   the   coordinate   representation   F ˆ of   F   .)   The   function   F   is   called   an   immersion if   its   rank   is   equal   to   d 1 at   each   point   of   its   domain   (hence   d 1 ≤   d 2 ).   If   its   rank   is   equal   to   d 2 at   each   point   of   its   domain   (hence   d 1 ≥   d 2 ),   then   it   is   called   a   submersion .   The   function   F   is   an   immersion   if   and   only   if,   around   each   point   of   its   do­

main,   it   admits   a   coordinate   representation   that   is   the   canonical immersion ( u 1 , . . . , u d 1 )    →   ( u 1 , . . . , u d 1 ,   0 , . . . ,   0).   The   function   F   is   a   submersion   if   and   only   if,   around   each   point   of   its   domain,   it   admits   the   canonical submersion

[Page 38]

( u 1 , . . . , u d 1 )    →   ( u 1 , . . . , u d 2 )   as   a   coordinate   representation.   A   point   y   ∈ M 2 is   called   a   regular value of   F   if   the   rank   of   F   is   d 2 at   every   x   ∈   F   − 1 ( y ).  

# 3.3 EMBEDDED SUBMANIFOLDS

A   set   X   may   admit   several   manifold   structures.   However,   if   the   set   X   is   a   subset   of   a   manifold   ( M ,   A + ),   then   it   admits   at   most   one   submanifold   structure.   This   is   the   topic   of   this   section.  

# 3.3.1 General theory

Let   ( M ,   A + )   and   ( N   ,   B + )   be   manifolds   such   that   N   ⊂ M .   The   manifold   ( N   ,   B + )   is   called   an   immersed submanifold of   ( M ,   A + )   if   the   inclusion   map   i   :   N   → M   :   x    →   x   is   an   immersion.   Let   ( N   ,   B + )   be   a   submanifold   of   ( M ,   A + ).   Since   M   and   N   are   manifolds,  

they   are   also   topological   spaces   with   their   manifold   topology.   If   the   manifold   topology   of   N   coincides   with   its   subspace   topology   induced   from   the   topological   space   M ,   then   N   is   called   an   embedded submanifold , a   regular submanifold ,   or   simply   a   submanifold of   the   manifold   M .   Asking   that   a   subset   N   of   a   manifold   M   be   an   embedded   submanifold   of   M   removes   all   freedom   for   the   choice   of   a   diﬀerentiable   structure   on   N   :   Proposition 3.3.1 Let   be a subset of a manifold . Then   admits at

Proposition 3.3.1 Let N be  a  subset  of  a  manifold M . Then N admits  at most  one  differentiable  structure  that  makes  it  an  embedded  submanifold  of M .

of   a   manifold   “is”   a   submanifold,   we   mean   that   it   admits   one   (unique)   differentiable   structure   that   makes   it   an   embedded   submanifold.   The   manifold   M   in   Proposition   3.3.1   is   called   the   embedding space .   When   the   embedding   space   is   R n × p or   an   open   subset   of   R n × p ,   we   say   that   N   is   a   matrix submanifold .  

To   check   whether   a   subset   N   of   a   manifold   M   is   an   embedded   submanifold   of   M   and   to   construct   an   atlas   of   that   diﬀerentiable   structure,   one   can   use   the   next   proposition,   which   states   that   every   embedded   submanifold   is   locally   a   coordinate   slice.   Given   a   chart   ( U , ϕ )   of   a   manifold   M , a   ϕ coordinate slice of   U   is   a   set   of   the   form   ϕ − 1 ( R m ×{ 0 } )   that   corresponds   to   all   the   points   of   U   whose   last   n   −   m   coordinates   in   the   chart   ϕ   are   equal   to   zero.  

Proposition 3.3.2 (submanifold property) A subset N   of a manifold M   is a d -dimensional embedded submanifold of M   if and only if, around each point x   ∈ N   , there exists a chart ( U , ϕ )   of M   such that N   ∩ U   is a ϕ -coordinate slice of U , i.e., N   ∩ U   =   { x   ∈ U   :   ϕ ( x )   ∈   R d × { 0 }} .  

$$
\mathcal { N } \cap \mathcal { U } & = \{ x \in \mathcal { U } \colon \varphi ( x ) \in \mathbb { R } ^ { d } \times \{ 0 \} \} . \\ \text {the chart } ( \mathcal { N } \cup \mathcal { U } _ { d } \varpi ) _ { \ } w h e r e \ \varpi \text { is seen as a main}
$$

In this case, the chart ( N   ∩ U , ϕ ) , where ϕ   is seen as a mapping into R d , is a chart of the embedded submanifold N   .

[Page 39]

The   next   propositions   provide   suﬃcient   conditions   for   subsets   of   manifolds   to   be   embedded   submanifolds.  

Proposition 3.3.3 (submersion theorem) Let F   :   M 1 → M 2 be a smooth mapping between two manifolds of dimension d 1 and d 2 , d 1 > d 2 , and let y   be a point of M 2 . If y   is a regular value of F   (i.e., the rank of F   is equal to d 2 at every point of F   − 1 ( y ) ), then F   − 1 ( y )   is a closed embedded submanifold of M 1 , and dim( F   − 1 ( y ))   =   d 1 −   d 2 .

Proposition 3.3.4 (subimmersion theorem) Let F   :   M 1 → M 2 be a smooth mapping between two manifolds of dimension d 1 and d 2 and let y   be a point of F   ( M 1 ) . If F   has constant rank k < d 1 in a neighborhood of F   − 1 ( y ) , then F   − 1 ( y )   is a closed embedded submanifold of M 1 of dimension d 1 −   k .

Functions   on   embedded   submanifolds   pose   no   particular   diﬃculty.   Let   N be   an   embedded   submanifold   of   a   manifold   M .   If   f   is   a   smooth   function   on   M ,   then   f | N   ,   the   restriction of   f   to   N   ,   is   a   smooth   function   on   N   .   Conversely,   any   smooth   function   on   N   can   be   written   locally   as   a   restriction   of   a   smooth   function   deﬁned   on   an   open   subset   U   ⊂ M .  

# 3.3.2 The Stiefel manifold

The   (orthogonal)   Stiefel   manifold   is   an   embedded   submanifold   of   R n × p that   will   appear   frequently   in   our   practical   examples.  

Let   St( p, n ) ( p   ≤   n )   denote   the   set   of   all   n   ×   p   orthonormal   matrices;   i.e.,           R n × p   T        

$$
S t ( p , n ) & \colon = \{ X \in \mathbb { R } ^ { n \times p } \colon X ^ { T } X = I _ { p } \} , \\ \intertext { s t } \intertext { a n d } \intertext { s t ( p , n ) } \intertext { s t ( X , n ) } \intertext { s t ( X \in \mathbb { R } ^ { n \times p } \colon X ^ { T } X = I _ { p } ) } & ,
$$

where   I p denotes   the   p   ×   p   identity   matrix.   The   set   St( p, n )   (endowed   with   its   submanifold   structure   as   discussed   below)   is   called   an   (orthogonal or compact) Stiefel manifold .   Note   that   the   Stiefel   manifold   St( p, n )   is   distinct   from   the   noncompact   Stiefel   manifold   R n ∗ × p deﬁned   in   Section   3.1.5.   R n × p R n × p

Clearly,   St( p, n )   is   a   subset   of   the   set   .   Recall   that   the   set   admits   a   linear   manifold   structure   as   described   in   Section   3.1.5.   To   show   that   St( p, n )   is   an   embedded   submanifold   of   the   manifold   R n × p ,   consider   the   function   F   :   R n × p → S sym ( p ) :   X    →   X T X   −   I p ,   where   S sym ( p )   denotes   the   set   of   all   symmetric   p   ×   p   matrices.   Note   that   S sym ( p )   is   a   vector   space.   Clearly,   St( p, n ) =   F   − 1 (0 p ).   It   remains   to   show   that   F   is   a   submersion   at   each   point   X   of   St( p, n ).   The   fact   that   the   domain   of   F   is   a   vector   space   exempts   us   from   having   to   read   F   through   a   chart:   we   simply   need   to   show   that   for   all   Z   in   S sym ( p ),   there   exists   Z   in   R n × p such   that   D F   ( X ) [ Z ] =   Z   .   We   have   (see   Appendix   A.5   for   details   on   matrix   diﬀerentiation)   D F   ( X ) [ Z ] =   X T Z   +   Z T X.  

$$
D F \left ( X \right ) \left [ Z \right ] = X ^ { T } Z + Z ^ { T } X .
$$

It   is   easy   to   see   that   D F   ( X )       2 1 XZ       =   Z   since   X T X   =   I p and   Z   T =   Z   .   This   shows   that   F   is   full   rank.   It   follows   from   Proposition   3.3.3   that   the   set   St( p, n )   deﬁned   in   (3.4)   is   an   embedded   submanifold   of   R n × p .  

[Page 40]

To   obtain   the   dimension   of   St( p, n ),   observe   that   the   vector   space   S sym ( p )   has   dimension   1 2 p ( p   +   1)   since   a   symmetric   matrix   is   completely   determined   by   its   upper   triangular   part   (including   the   diagonal).   From   Proposition   3.3.3,   we   obtain  

$$
\dim ( S t ( p , n ) ) & = n p - \frac { 1 } { 2 } p ( p + 1 ) . \\ \intertext { i s o n o m b o d d o d s u b m p i f o l d o f } \intertext { i s o n o m b o d d o d s u b m p i f o l d o f }
$$

2 Since   St( p, n )   is   an   embedded   submanifold   of   R n × p ,   its   topology   is   the   subset   topology   induced   by   R n × p .   The   manifold   St( p, n )   is   closed:   it   is   the   inverse   image   of   the   closed   set   { 0 p }   under   the   continuous   function   F   :   R n × p  →   S sym ( p ).   It   is   bounded:   each   column   of   X   ∈   St( p, n )   has   norm   1,   so   the   Frobenius   norm   of   X   is   equal   to   √ p .   It   then   follows   from   the   HeineBorel   theorem   (see   Section   A.2)   that   the   manifold   St( p, n )   is   compact .   n − 1

For p = 1, the Stiefel manifold St( p, n ) reduces to the unit  sphere S n -1 in R n . Notice that the superscript n -1 indicates the dimension of the manifold.

For p = n , the Stiefel manifold St( p, n ) becomes the orthogonal group O n . Its dimension is 1 n ( n -1). 2

# 3.4 QUOTIENT MANIFOLDS

Whereas   the   topic   of   submanifolds   is   covered   in   any   introductory   textbook   on   manifolds,   the   subject   of   quotient   manifolds   is   less   classical.   We   develop   the   theory   in   some   detail   because   it   has   several   applications   in   matrix   computations,   most   notably   in   algorithms   that   involve   subspaces   of   R n .   Computations   involving   subspaces   are   usually   carried   out   using   matrices   to   represent   the   corresponding   subspace   generated   by   the   span   of   its   columns.   The   diﬃculty   is   that   for   one   given   subspace,   there   are   inﬁnitely   many   matrices   that   represent   the   subspace.   It   is   then   desirable   to   partition   the   set   of   matrices   into   classes   of   “equivalent”   elements   that   represent   the   same   object.   This   leads   to   the   concept   of   quotient   spaces   and   quotient   manifolds.   In   this   section,   we   ﬁrst   present   the   general   theory   of   quotient   manifolds,   then   we   return   to   the   special   case   of   subspaces   and   their   representations.  

# 3.4.1 Theory of quotient manifolds

Let   M   be   a   manifold   equipped   with   an   equivalence relation ∼ ,   i.e.,   a   relation   that   is  

reflexive: x ∼ x for all x ∈ M ,

symmetric: x ∼ y if and only if y ∼ x for all x, y ∈ M ,

transitive: if x ∼ y and y ∼ z then x ∼ z for all x, y, z ∈ M .

The set

$$
[ x ] \colon = \{ y \in \mathcal { M } \colon y \sim x \} \\ \intertext { o w i v i r o n t $ t o o p i n t $ a i n s o l l o o n }
$$

of   all   elements   that   are   equivalent   to   a   point   x   is   called   the   equivalence class containing   x .   The   set  

$$
\mathcal { M } / \sim \colon = \{ [ x ] \colon x \in \mathcal { M } \}
$$

[Page 41]

of   all   equivalence   classes   of   ∼   in   M   is   called   the   quotient of   M   by   ∼ .   Notice   that   the   points   of   M /   ∼   are   subsets   of   M .   The   mapping   π   :   M → M /   ∼ deﬁned   by   x    →   [ x ]   is   called   the   natural projection or   canonical projection .   Clearly,   π ( x ) =   π ( y )   if   and   only   if   x   ∼   y ,   so   we   have   [ x ] =   π − 1 ( π ( x )).   We   will   use   π ( x )   to   denote   [ x ]   viewed   as   a   point   of   M / ∼ ,   and   π − 1 ( π ( x ))   for   [ x ]   viewed   as   a   subset   of   M .   The   set   M   is   called   the   total space of   the   quotient   M /   ∼ .   Let   ( M ,   A + )   be   a   manifold   with   an   equivalence   relation   ∼   and   let   B + be  

a   manifold   structure   on   the   set   M / ∼ .   The   manifold   ( M / ∼ ,   B + )   is   called   a   quotient manifold of   ( M ,   A + )   if   the   natural   projection   π   is   a   submersion.  

Proposition 3.4.1 Let M   be a manifold and let M / ∼   be a quotient of M . Then M / ∼   admits at most one manifold structure that makes it a quotient manifold of M .

Given   a   quotient   M /   ∼   of   a   manifold   M ,   we   say   that   the   set   M /   ∼   is a   quotient   manifold   if   it   admits   a   (unique)   quotient   manifold   structure.   In   this   case,   we   say   that   the   equivalence   relation   ∼   is   regular ,   and   we   refer   to   the   set   M / ∼   endowed   with   this   manifold   structure   as   the   manifold   M / ∼ .   The   following   result   gives   a   characterization   of   regular   equivalence   rela­

The following result gives a characterization of regular equivalence relations. Note that the graph of a relation ∼ is the set

$$
\text {graph} ( \sim ) \colon = \{ ( x , y ) \in \mathcal { M } \times \mathcal { M } \colon x \sim y \} .
$$

Proposition 3.4.2 An equivalence relation ∼   on a manifold M   is regular (and thus M / ∼   is a quotient manifold) if and only if the following conditions hold together:

- (i) The  graph  of ∼ is  an  embedded  submanifold  of  the  product  manifold M×M .
- (ii) The  projection π 1 : graph( ∼ ) →M , π 1 ( x, y ) = x is  a  submersion.
- (iii) The  graph  of ∼ is a closed subset of M×M (where M is  endowed with  its  manifold  topology).


The   dimension   of   M / ∼   is   given   by        

$$
\dim ( \mathcal { M } / \sim ) & = 2 \, \dim ( \mathcal { M } ) - \dim ( \text {graph} ( \sim ) ) . \\ \intertext { d i m ( \mathcal { M } / \sim ) = 2 \, \dim ( \mathcal { M } ) - \dim ( \text {graph} ( \sim ) ) . } \\ \intertext { i n t a l l } \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots \quad \ddots
$$

The   next   proposition   distinguishes   the   role   of   the   three   conditions   in   Proposition   3.4.2.  

Proposition 3.4.3 Conditions (i) and (ii) in Proposition 3.4.2 are necessary and suﬃcient for M /   ∼   to admit an atlas that makes π   a submersion. Such an atlas is unique, and the atlas topology of M /   ∼   is identical to its quotient topology. Condition (iii) in Proposition 3.4.2 is necessary and sufﬁcient for the quotient topology to be Hausdorﬀ.

The   following   result   follows   from   Proposition   3.3.3   by   using   the   fact   that   the   natural   projection   to   a   quotient   manifold   is   by   deﬁnition   a   submersion.  

[Page 42]

Proposition 3.4.4 Let M /   ∼   be a quotient manifold of a manifold M   and let π   denote the canonical projection. If dim( M /   ∼ )   <   dim( M ) , then each equivalence class π − 1 ( π ( x )) , x   ∈ M , is an embedded submanifold of M   of dimension dim( M )   −   dim( M / ∼ ) . − 1

If   dim( M /   ∼ )   =   dim( M ),   then   each   equivalence   class   π ( π ( x )),   x   ∈ M ,   is   a   discrete   set   of   points.   From   now   on   we   consider   only   the   case   dim( M / ∼ )   <   dim( M ).   When   M   is   R n × p or   a   submanifold   of   R n × p ,   we   call   M / ∼   a   matrix quo­

tient manifold .   For   ease   of   reference,   we   will   use   the   generic   name   structure space both   for   embedding   spaces   (associated   with   embedded   submanifolds)   and   for   total   spaces   (associated   with   quotient   manifolds).   We   call   a   matrix manifold any   manifold   that   is   constructed   from   R n × p by   the   operations   of   taking   embedded   submanifolds   and   quotient   manifolds.   The   major   matrix   manifolds   that   appear   in   this   book   are   the   noncompact   Stiefel   manifold   (deﬁned   in   Section   3.1.5),   the   orthogonal   Stiefel   manifold   (Section   3.3.2),   and   the   Grassmann   manifold   (Section   3.4.4).   Other   important   matrix   manifolds   are   the   oblique manifold

$$
\{ X \in \mathbb { R } ^ { n \times p } \colon d i a g ( X ^ { T } X ) = I _ { p } \} , \\ \intertext { f o n o t o s } \int d i a g ( X ^ { T } X ) \subsetneq \int d i a g ( X ^ { T } X ) = I _ { p } \} ,
$$

where   diag( M )   denotes   the   matrix   M   with   all   its   oﬀ-diagonal   elements   assigned   to   zero;   the   generalized   Stiefel   manifold  

$$
\{ X \in \mathbb { R } ^ { n \times p } \colon X ^ { T } B X = I \} \\ \text {triadic positive dofinito matrix} \colon \text {the} \, \forall
$$

where   B   is   a   symmetric   positive-deﬁnite   matrix;   the   ﬂag manifolds ,   which   are   quotients   of   R n ∗ × p where   two   matrices   are   equivalent   when   they   are   related   by   a   right   multiplication   by   a   block   upper   triangular   matrix   with   prescribed   block   size;   and   the   manifold   of   symplectic matrices

$$
\{ X \in \mathbb { R } ^ { 2 n \times 2 n } \colon X ^ { T } J X = J \} ,
$$

I n where J = [ 0 n ] . -I n 0 n

# 3.4.2 Functions  on  quotient  manifolds

A   function   f   on   M   is   termed   invariant under ∼   if   f ( x ) =   f ( y )   whenever   x   ∼   y ,   in   which   case   the   function   f   induces   a   unique   function   f ˜   on   M /   ∼ ,   called   the   projection of   f ,   such   that   f   =   f ˜   π . ◦    

![image 4](<images/imageFile4.png>)

M      

/d63

/d31

/d63

/d31

/d63

/d31

f

/d63

/d31

/d63

π    

/d63

/d31

/d63

/d31

/d63

/d31

/d63

/d63

/d31

/d15

/d15

/d31

/d31

/d63

M

∼

/d47

/d47

/

N  

˜

f

The   smoothness   of   f ˜   can   be   checked   using   the   following   result.  

Proposition 3.4.5 Let M / ∼   be a quotient manifold and let f ˜   be a function on M /   ∼ . Then f ˜   is smooth if and only if f   :=   f ˜   ◦   π   is a smooth function on M .

[Page 43]

# 3.4.3 The real projective space RP n − 1

The   real   projective   space   RP n − 1 is   the   set   of   all   directions   in   R n ,   i.e.,   the   set   of   all   straight   lines   passing   through   the   origin   of   R n .   Let   R n :=   R n −{ 0 } ∗   denote   the   Euclidean   space   R n with   the   origin   removed.   Note   that   R ∗   n is   the   p   =   1   particularization   of   the   noncompact   Stiefel   manifold   R n ∗ × p (Section   3.1.5);   hence   R n is   an   open   submanifold   of   R n .   The   real   projective   space ∗   RP n − 1 is   naturally   identiﬁed   with   the   quotient   R n ∗   / ∼ ,   where   the   equivalence   relation   is   deﬁned   by  

$$
x \sim y \quad \Leftrightarrow \quad \exists t \in \mathbb { R } _ { * } \colon y = x t ,
$$

$$
x \sim y \quad \Leftrightarrow \quad \exists t \in \mathbb { R } _ { * } \colon y =
$$

and   we   write  

$$
\mathbb { R } \mathbb { P } ^ { n - 1 } \simeq \mathbb { R } _ { * } ^ { n } / \sim \\ \intertext { w h e f t h e w h e s t o s t a }
$$

to   denote   the   identiﬁcation   of   the   two   sets.   n

The   proof   that   R ∗   /   ∼   is   a   quotient   manifold   follows   as   a   special   case   of   Proposition   3.4.6   (stating   that   the   Grassmann   manifold   is   a   matrix   quotient   manifold).   The   letters   RP   stand   for   “real   projective”,   while   the   superscript   ( n   −   1)   is   the   dimension   of   the   manifold.   There   are   also   complex   projective   spaces   and   more   generally   projective   spaces   over   more   abstract   vector   spaces.  

# 3.4.4 The Grassmann manifold Grass( p, n )  

Let   n   be   a   positive   integer   and   let   p   be   a   positive   integer   not   greater   than   n .   Let   Grass( p, n )   denote   the   set   of   all   p -dimensional   subspaces   of   R n .   In   this   section,   we   produce   a   one-to-one   correspondence   between   Grass( p, n )   and   a   quotient   manifold   of   R n × p ,   thereby   endowing   Grass( p, n )   with   a   matrix   manifold   structure.   n × p

Recall   that   the   noncompact   Stiefel   manifold   R ∗ is   the   set   of   all   n   ×   p   matrices   with   full   column   rank.   Let   ∼   denote   the   equivalence   relation   on   R n ∗ × p deﬁned   by  

$$
X \sim Y \quad \Leftrightarrow \quad \text {span} ( X ) = \text {span} ( Y ) , \\ \\ \intertext { s p a n } ( Y ) \, d \intertext { s p a n } \intertext { s p a n } \intertext { s p a n } ( Y ) \, d \intertext { s p a n } \intertext { s p a n } \intertext { s p a n }
$$

where   span( X )   denotes   the   subspace   { Xα   :   α   ∈   R p }   spanned   by   the   columns   of   X   ∈   R n ∗ × p .   Since   the   ﬁbers   of   span( )   are   the   equivalence   classes   of   ∼   and · since   span( )   is   onto   Grass( p, n ),   it   follows   that   span( )   induces   a   one-to-one · · correspondence   between   Grass( p, n )   and   R n ∗ × p / ∼ .  

×

n

p

![image 5](<images/imageFile5.png>)

R

∗

/d74

/d74

/d74

span

/d74

/d74

π

/d74

/d74

/d74

/d74

/d74

/d74

/d15

/d15

/d36

/d36

/d74

×

n

p

R

/d111

/d111

/d47

/d47

Grass( p,

p, n

)

∼

/

∗

˜

f

Before showing that the set R n ∗ × p / ∼ is a quotient manifold, we introduce some notation and terminology. If a matrix X and a subspace X satisfy X = span( X ), we say that X is the span of X , that X spans X , or that X is a matrix  representation of X . The set of all matrix representations of span( X ) is the equivalence class π -1 ( π ( X )). We have π -1 ( π ( X )) = { XM : M ∈ GL p } =: X GL p ; indeed, the operations X ↦→ XM , M ∈ GL p , correspond to all possible changes of basis for span( X ). We will thus use the notation R n ∗ × p / GL p for R n ∗ × p / ∼ . Therefore we have

[Page 44]

X  

GL p

![The image consists of a diagram with two parallel lines labeled as \( x \) and \( y \). There is a point labeled as \( x \) on the line \( x \) and a point labeled as \( y \) on the line \( y \). The line \( x \) is drawn as a straight line, while the line \( y \) is a line.](<images/imageFile6.png>)

p

X  

0

Figure 3.3 Schematic illustration of the representation of Grass( p, n ) as the quotient space R n ∗ × p / GL p . Each point is an n -byp matrix. Each line is an equivalence class of the matrices that have the same span. Each line corresponds to an element of Grass( p, n ). The ﬁgure corresponds to the case n = 2, p = 1.

$$
G r a s s ( p , n ) \simeq \mathbb { R } _ { * } ^ { n \times p } / G L _ { p } . \\
$$

A   schematic   illustration   of   the   quotient   R n ∗ × p / GL p is   given   in   Figure   3.3.   R n × p

The   identiﬁcation   of   ∗ / GL p with   the   set   of   p -dimensional   subspaces   ( p -planes)   in   R n makes   this   quotient   particularly   worth   studying.   Next,   the   quotient   R n ∗ × p / GL p is   shown   to   be   a   quotient   manifold.  

Proposition 3.4.6 (Grassmann manifold) The quotient set R n ∗ × p / GL p (i.e., the quotient of R n ∗ × p by the equivalence relation deﬁned in (3.6) ) admits a (unique) structure of quotient manifold.

Proof. We   show   that   the   conditions   in   Proposition   3.4.2   are   satisﬁed.   We   ﬁrst   prove   condition   (ii).   Let   ( X 0 , Y 0 )   be   in   graph( ∼ ).   Then   there   exists   M   such   that   Y 0 =   X 0 M .   Given   any   V   in   R n × p ,   the   curve   t    →   ( X 0 + tV,   ( X 0 + tV   ) M )   is   into   graph( ∼ )   and   satisﬁes   d ( π 1 ( γ ( t )))   t =0 =   V   .   This   shows   that   π 1 is   d t a   submersion.   For   condition   (iii),   observe   that   the   graph   of   ∼   is   closed   as   it   is   the   preimage   of   the   closed   set   { 0 n × p }   under   the   continuous   function   R n ∗ × p ×   R n ∗ × p →   R n × p : ( X, Y   )    →   ( I   −   X ( X T X ) − 1 X T ) Y   .   For   condition   (i),   the   idea   is   to   produce   submersions   F i with   open   domain   Ω i ⊂   ( R n ∗ × p R n ∗ × p )   such   that   graph( ∼ )   ∩   Ω i is   the   zero-level   set   of   F i and   that   the   Ω i × ’s   cover   graph( ∼ ).   It   then   follows   from   Proposition   3.3.3   that   graph( ∼ )   is   an  

[Page 45]

$$
\mathbb { R } _ { * } ^ { n \times p } \to & \ S t ( n - p , n ) \, \colon X \mapsto X _ { \perp } \\ T _ { X } \, & \quad o \, c \, \prod _ { X } X \, \cdot \, \cdot \, \cdot \, \cdot \, \tilde { O } \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \
$$

such   that   X T X ⊥   =   0   for   all   X   in   an   open   domain   ˜ Ω   and   consider  

$$
F \colon \tilde { \Omega } \times \mathbb { R } _ { * } ^ { n \times p } \rightarrow \mathbb { R } ^ { ( n - p ) \times p } \colon ( X , Y ) \mapsto X _ { \perp } ^ { T } Y . \\ = & 1 ( 0 ) \quad _ { 1 } ( 0 ) \subsetneq 1 ( 1 ) \subsetneq 1 _ { 1 } ( 1 ) \subsetneq X _ { 1 } \cup X _ { 2 } \cup X _ { 3 } \cup X _ { 4 } .
$$

Then   F   − 1 (0)   =   graph( ∼ )   ∩   dom( F   ).   Moreover,   F   is   a   submersion   on   its   domain   since   for   any   V   ∈   R ( n − p ) × p ,           T      

$$
D F ( X , Y ) [ 0 , X _ { \perp } V ] = X _ { \perp } ^ { T } ( X _ { \perp } V ) = V .
$$

It   remains   to   deﬁne   the   smooth   function   (3.7).   Depending   on   n   and   p ,   it   may   or   may   not   be   possible   to   deﬁne   such   a   function   on   the   whole   R n ∗ × p .   However,   there   are   always   such   functions,   constructed   as   follows,   whose   domain   ˜ Ω   is   open   and   dense   in   R n ∗ × p .   Let   E   ∈   R n × ( n − p ) be   a   constant   matrix   of   the   form            

$$
L e t \, E \in \mathbb { R } ^ { n } ( ^ { \prime \prime } \, P ) \, \text { be a com} \\ E = [ e _ { i _ { 1 } } | \cdots | e _ { i _ { n - p } } ] \, , \\ \text {canonical vectors in } \mathbb { R } ^ { n } \, ( \text {unit} \, v \\ \text {the orthogonal matrix} \, \alpha
$$

where   the   e i ’s   are   the   canonical   vectors   in   R n (unit   vectors   with   a   1   in   the   i th   entry),   and   deﬁne   X ⊥   as   the   orthonormal   matrix   obtained   by   taking   the   last   n   −   p   columns   of   the   Gram-Schmidt   orthogonalization   of   the   matrix   [ X E ].   Ω =   { X   ∈   R n × p : [ X | X T | This   function   is   smooth   on   the   domain   ˜ ∗   E ]   full   rank } ,   which   is   an   open   dense   subset   of   R n ∗ × p .   Consequently,   F   ( X, Y   ) =   ⊥   Y   is   smooth   (and   submersive)   on   the   domain   Ω   =   Ω ˜ ×   R ∗   n × p .   This   shows   that   graph( ∼ )   ∩   Ω   is   an   embedded   submanifold   of   ( R n ∗ × p ×   R n ∗ × p ).   Taking   other   matrices   E   yields   other   domains   Ω   which   together   cover   ( R n ∗ × p ×   R n ∗ × p ),   so   graph( ∼ )   is   an   embedded   submanifold   of   ( R n ∗ × p ×   R n ∗ × p ),   and   the   proof   is   complete.      

Endowed   with   its   quotient   manifold   structure,   the   set   R n ∗ × p / GL p is   called   the   Grassmann manifold of   p -planes   in   R n and   denoted   by   Grass( p, n ).   The   particular   case   Grass(1 , n ) =   RP n is   the   real   projective   space   discussed   in   Section   3.4.3.   From   Proposition   3.3.3,   we   have   that   dim(graph( ∼ ))   =   2 np   − ( n   −   p ) p .   It   then   follows   from   (3.5)   that            

$$
\dim ( G r a s s ( p , n ) ) = p ( n - p ) .
$$

# 3.5 TANGENT VECTORS AND DIFFERENTIAL MAPS

There   are   several   possible   approaches   to   generalizing   the   notion   of   a   directional derivative

$$
D f \left ( x \right ) \left [ \eta \right ] = \lim _ { t \rightarrow 0 } \frac { f ( x + t \eta ) - f ( x ) } { t } \quad \ \ ( 3 . 8 )
$$

to a real-valued function f defined on a manifold. A fi rst possibility is to view η as a derivation  at x , that is, an object that, when given a real-valued function f defined on a neighborhood of x ∈ M , returns a real ηf , and that satisfies the properties of a derivation operation: linearity and the Leibniz rule (see Section 3.5.5). This 'axiomatization' of the notion of a directional derivative is elegant and powerful, but it gives little intuition as to how a tangent vector could possibly be represented as a matrix array in a computer.

[Page 46]

A   second,   perhaps   more   intuitive   approach   to   generalizing   the   directional   derivative   (3.8)   is   to   replace   t    →   ( x + tη )   by   a   smooth   curve   γ   on   M   through   x   (i.e.,   γ (0)   =   x ).   This   yields   a   well-deﬁned   directional   derivative   d( f ( d γ t ( t ))) .     t =0 (Note   that   this   is   a   classical   derivative   since   the   function   t    →   f ( γ ( t ))   is   a   smooth   function   from   R   to   R .)   Hence   we   have   an   operation,   denoted   by   ˙ γ (0),   that   takes   a   function   f ,   deﬁned   locally   in   a   neighbourhood   of   x ,   and   returns   the   real   number   d( f ( γ ( t ))) . d t   t =0 These   two   approaches   are   reconciled   by   showing   that   every   derivative   along   a   curve   deﬁnes   a   pointwise   derivation   and   that   every   pointwise   deriva­

∣ These two approaches are reconciled by showing that every derivative along a curve defines a pointwise derivation and that every pointwise derivation can be realized as a derivative along a curve. The fi rst claim is direct. The second claim can be proved using a local coordinate representation, a third approach used to generalize the notion of a directional derivative.

# 3.5.1 Tangent vectors

Let   M   be   a   manifold.   A   smooth   mapping   γ   :   R   → M :   t    →   γ ( t )   is   termed   a   curve in M .   The   idea   of   deﬁning   a   derivative   γ   ′   ( t )   as              

$$
\gamma ^ { \prime } ( t ) \coloneqq \lim _ { \tau \to 0 } \frac { \gamma ( t + \tau ) - \gamma ( t ) } { \tau }
$$

requires   a   vector   space   structure   to   compute   the   diﬀerence   γ ( t + τ   ) − γ ( t )   and   thus   fails   for   an   abstract   nonlinear   manifold.   However,   given   a   smooth   realvalued   function   f   on   M ,   the   function   f γ   :   t    →   f ( γ ( t ))   is   a   smooth   function   ◦ from   R   to   R   with   a   well-deﬁned   classical   derivative.   This   is   exploited   in   the   following   deﬁnition.   Let   x   be   a   point   on   M ,   let   γ   be   a   curve   through   x   at   t   =   0,   and   let   F x ( M )   denote   the   set   of   smooth   real-valued   functions   deﬁned   on   a   neighborhood   of   x .   The   mapping   ˙ γ (0)   from   F x ( M )   to   R   deﬁned   by    

$$
\text {throughhood of } x \colon \text {The mapping } \gamma ( 0 ) \text { from } \mathfrak { s } _ { x } ( \mathcal { M } ) \text { to } \mathbb { R } \text { defined by } \\ \dot { \gamma } ( 0 ) f \colon = \frac { d ( f ( \gamma ( t ) ) ) } { d t } \Big | _ { t = 0 } , \quad f \in \mathfrak { s } _ { x } ( \mathcal { M } ) , \\ \intertext { h o r b h o o d } \text {the tangent vector to the curve } \gamma \text { at } t = 0 . \quad \\ \text {mhasize that } \dot { \gamma } ( 0 ) \text { is defined as a mapping from } \mathfrak { s } _ { x } ( \mathcal { M } ) \text { to } \mathbb { R } \text { and }
$$

  is   called   the   tangent vector to the curve γ   at t   =   0.  

We   emphasize   that   γ ˙ (0)   is   deﬁned   as   a   mapping   from   F x ( M )   to   R   and   not   as   the   time   derivative   γ   ′   (0)   as   in   (3.9),   which   in   general   is   meaningless.   However,   when   M   is   (a   submanifold   of)   a   vector   space   E ,   the   mapping   ˙ γ (0)   from   F x ( M )   to   R   and   the   derivative   γ   ′   (0)   :=   lim t → 0 1 ( γ ( t ) − γ (0))   are   closely   t related:   for   all   functions   f   deﬁned   in   a   neighborhood   U   of   γ (0)   in   E ,   we   have   ′  

$$
\dot { \gamma } ( 0 ) f = D \bar { f } \left ( \gamma ( 0 ) \right ) \left [ \gamma ^ { \prime } ( 0 ) \right ] ,
$$

where   f   denotes   the   restriction   of   f   to   U ∩M ;   see   Sections   3.5.2   and   3.5.7   for   details.   It   is   useful   to   keep   this   interpretation   in   mind   because   the   derivative   γ   ′   (0)   is   a   more   familiar   mathematical   object   than   γ ˙ (0).  

We   can   now   formally   deﬁne   the   notion   of   a   tangent   vector.  

[Page 47]

Deﬁnition 3.5.1 (tangent vector) A tangent   vector   ξ x to a manifold M at a point x   is a mapping from F x ( M )   to R   such that there exists a curve γ   on M   with γ (0)   =   x , satisfying  

$$
= x , \ s a t i s f y i n g \\ \xi _ { x } f = \dot { \gamma } ( 0 ) f \colon = \frac { d ( f ( \gamma ( t ) ) ) } { d t } \Big | _ { t = 0 } \\ ) . \ S u c h a c u r v e \ \gamma \ i s \ s a i d \ t o \ r e a l i z e \ t h e \ t a l \\ \text {called the foot of the tangent vector} \ \xi
$$

  for all f   ∈   F x ( M ) . Such a curve γ   is said to realize   the tangent vector ξ x .

The   point   x   is   called   the   foot of   the   tangent   vector   ξ x .   We   will   often   omit   the   subscript   indicating   the   foot   and   simply   write   ξ   for   ξ x .  

Given   a   tangent   vector   ξ   to   M   at   x ,   there   are   inﬁnitely   many   curves   γ   that   realize   ξ   (i.e.,   γ ˙ (0)   =   ξ ).   They   can   be   characterized   as   follows   in   local   coordinates.  

Proposition 3.5.2 Two curves γ 1 and γ 2 through a point x   at t   = 0   satisfy γ ˙ 1 (0)   =   γ ˙ 2 (0)   if and only if, given a chart ( U , ϕ )   with x   ∈ U , it holds that d( ϕ ( γ ( t )))   d( ϕ ( γ ( t )))  

$$
\begin{array} { r l } & { i f a n d o n l y i f , g i v e n a c h a r t ( \mathcal { U } , \varphi ) w i t h x \in \mathcal { U } , } \\ & { \quad } \\ & { \quad } & { \frac { d ( \varphi ( \gamma _ { 1 } ( t ) ) ) } { d t } \Big | _ { t = 0 } = \frac { d ( \varphi ( \gamma _ { 2 } ( t ) ) ) } { d t } \Big | _ { t = 0 } . } \\ & { \quad } \\ & { \text {only if} ^ { \prime \prime } p a r t i s s t r a i g h t f o r w a r d s i n c e a h c o m p h s } \\ & { \omega b e l o n g s t o \mathfrak { F } _ { \mathfrak { M } } ( \mathcal { M } ) , F o r t h e "if" p a r t , g i v e n a c h a r t } \end{array}
$$

1 2 =   .   d t     t =0 d t     t =0 Proof. The   “only   if”   part   is   straightforward   since   each   component   of   the   vector-valued   ϕ   belongs   to   F x ( M ).   For   the   “if”   part,   given   any   f   ∈   F x ( M ),   we   have  

$$
f \circ \varphi ^ { - 1 } ( \varphi ( \gamma _ { 2 } ( t ) ) ) | _ { \substack { t = 0 \\ d t } } & = \frac { d ( ( f \circ \varphi ^ { - 1 } ) ( \varphi ( \gamma _ { 1 } ( t ) ) ) ) } { d t } | _ { t = 0 } \\ \intertext { f o \varphi ^ { - 1 } ( \varphi ( \gamma _ { 2 } ( t ) ) ) | } & = \dot { \gamma } _ { 2 } ( 0 ) f . \\ & \square \\ \mathcal { M } a t x , d e n o t e d b y T _ { x } \mathcal { M } , i s t e t o f a l t a n g e n
$$

$$
\dot { \gamma } _ { 1 } ( 0 ) f & = \frac { d ( f ( \gamma _ { 1 } ( t ) ) ) } { d t } \Big | _ { t = 0 } = \frac { d ( ( f \circ \varphi ^ { - 1 } ) ( \varphi ( \gamma _ { 1 } ( t ) ) ) ) } { d t } \Big | _ { t = 0 } \\ & = \frac { d ( ( f \circ \varphi ^ { - 1 } ) ( \varphi ( \gamma _ { 2 } ( t ) ) ) ) } { d t } \Big | _ { t = 0 } = \dot { \gamma } _ { 2 } ( 0 ) f .
$$

The   tangent space to   M   at   x ,   denoted   by   T x M ,   is   the   set   of   all   tangent   vectors   to   M   at   x .   This   set   admits   a   structure   of   vector space as   follows.   Given   γ ˙ 1 (0)   and   ˙ γ 2 (0)   in   T x M   and   a, b   in   R ,   deﬁne                      

$$
( a \dot { \gamma } _ { 1 } ( 0 ) + b \dot { \gamma } _ { 2 } ( 0 ) ) \, f \coloneqq a \left ( \dot { \gamma } _ { 1 } ( 0 ) f \right ) + b \left ( \dot { \gamma } _ { 2 } ( 0 ) f \right ) .
$$

To   show   that   ( aγ ˙ 1 (0)   +   bγ ˙ 2 (0))   is   a   well-deﬁned   tangent   vector,   we   need   to   show   that   there   exists   a   curve   γ   such   that   γ ˙ (0)   =   aγ ˙ 1 (0)   +   bγ ˙ 2 (0).   Such   a   curve   is   obtained   by   considering   a   chart   ( U , ϕ )   with   x   ∈ U   and   deﬁning   γ ( t ) =   ϕ − 1 ( aϕ ( γ 1 ( t ) +   bϕ ( γ 2 ( t )).   It   is   readily   checked   that   this   γ   satisﬁes   the   required   property.  

The   property   that   the   tangent   space   T x M   is   a   vector   space   is   very   important.   In   the   same   way   that   the   derivative   of   a   real-valued   function   provides   a   local   linear   approximation   of   the   function,   the   tangent   space   T x M   provides   a   local   vector   space   approximation   of   the   manifold.   In   particular,   in   Section   4.1,   we   deﬁne   mappings,   called   retractions ,   between   M   and   T x M ,   which   can   be   used   to   locally   transform   an   optimization   problem   on   the   manifold   M   into   an   optimization   problem   on   the   more   friendly   vector   space   T x M .  

[Page 48]

Using   a   coordinate   chart,   it   is   possible   to   show   that   the   dimension   of   the   vector   space   T x M   is   equal   to   d ,   the   dimension   of   the   manifold   M :   given   a   chart   ( U , ϕ )   at   x ,   a   basis   of   T x M   is   given   by   ( ˙ γ 1 (0) , . . . ,   γ ˙ d (0)),   where   γ i ( t )   :=   ϕ − 1 ( ϕ ( x ) +   te i ),   with   e i denoting   the   i th   canonical   vector   of   R d .   Notice   that   γ ˙ i (0) f   =   ∂ i ( f ϕ − 1 )( ϕ ( x )),   where   ∂ i denotes   the   partial   ◦ derivative   with   respect   to   the   i th   component:  

$$
\partial _ { i } h ( x ) \colon = \lim _ { t \to 0 } \frac { h ( x + t e _ { i } ) - h ( x ) } { t } .
$$

One   has,   for   any   tangent   vector   γ ˙ (0),   the   decomposition  

$$
\dot { \gamma } ( 0 ) & = \sum _ { i } ( \dot { \gamma } ( 0 ) \varphi _ { i } ) \dot { \gamma } _ { i } ( 0 ) , \\ i t h \, \text {component of } \varphi _ { i } \, \text { This provide }
$$

where   ϕ i denotes   the   i th   component   of   ϕ .   This   provides   a   way   to   deﬁne   the   coordinates   of   tangent   vectors   at   x   using   the   chart   ( U , ϕ ),   by   deﬁning   the   element   of   R d  

$$
\begin{pmatrix} \dot { \gamma } ( 0 ) \varphi _ { 1 } \\ \vdots \\ \dot { \gamma } ( 0 ) \varphi _ { d } \end{pmatrix}
$$

as   the   representation   of   the   tangent   vector   γ ˙ (0)   in   the   chart   ( U , ϕ ).  

# 3.5.2 Tangent vectors to a vector space

Let   E   be   a   vector   space   and   let   x   be   a   point   of   E .   As   pointed   out   in   Section   3.1.4,   E   admits   a   linear   manifold   structure.   Strictly   speaking,   a   tangent   vector   ξ   to   E   at   x   is   a   mapping    

$$
\begin{array} { r l } & { \mathcal { E } a t x i s a m p p i n g } \\ & { \quad \xi \colon \mathfrak { F } _ { x } ( \mathcal { E } ) \to \mathbb { R } \colon f \mapsto \xi f = \frac { d ( f ( \gamma ( t ) ) ) } { d t } \Big | _ { t = 0 } , } \\ & { \quad \text {is a curve in } \mathcal { E } w i t h \gamma ( 0 ) = x . \, \text {Defining } \gamma ^ { \prime } ( 0 ) \in \mathcal { E } a s i n } \end{array}
$$

∣ where γ is a curve in E with γ (0) = x . Defining γ ′ (0) ∈ E as in (3.9), we have

$$
\xi f = D f \left ( x \right ) \left [ \gamma ^ { \prime } ( 0 ) \right ] .
$$

Moreover,   γ   ′   (0)   does   not   depend   on   the   curve   γ   that   realizes   ξ .   This   deﬁnes   a   canonical   linear   one-to-one   correspondence   ξ    →   γ   ′   (0),   which   identiﬁes   T x E with   E :  

$$
T _ { x } \mathcal { E } \simeq \mathcal { E } . \\ \\
$$

Since   tangent   vectors   are   local   objects   (a   tangent   vector   at   a   point   x   acts   on   smooth   real-valued   functions   deﬁned   in   any   neighborhood   of   x ),   it   follows   that   if   E ∗   is   an   open   submanifold   of   E ,   then  

$$
T _ { x } \mathcal { E } _ { * } \simeq \mathcal { E } \\ \\ \intertext { t } T _ { x } \mathcal { E } _ { * } \simeq \mathcal { E }
$$

for   all   x   ∈ E ∗ .   A   schematic   illustration   is   given   in   Figure   3.4.  

[Page 49]

![The image is a diagram of a geometric figure, specifically a circle. The diagram consists of a circle with a diameter labeled as \(d\). The circle is divided into two parts, each with a radius labeled as \(r\). The diagram includes a point labeled as \(A\) and a point labeled as \(B\). The diagram is drawn with a line segment connecting the points \(A\) and \(B\). The line segment \(d\) is drawn from point \(A\) to point \(B\). The line segment \(r\) is drawn from point \(A\) to point \(B\). The diagram is labeled with the following labels: - \(d\) - \(r\) The diagram is a simple geometric figure, with no additional objects or additional labels. The line segment \(d\) is drawn from point \(](<images/imageFile7.png>)

E ∗  

E  

Figure 3.4 Tangent vectors to an open subset E ∗ of a vector space E .

# 3.5.3 Tangent bundle

Given   a   manifold   M ,   let   T   M   be   the   set   of   all   tangent   vectors   to   M :    

$$
T \mathcal { M } \, \text { be the set of all $\tan$} \\ T \mathcal { M } \colon = \bigcup _ { x \in \mathcal { M } } T _ { x } \mathcal { M } . \\ \text { one and only one tangent}
$$

Since   each   ξ   ∈   T   M   is   in   one   and   only   one   tangent   space   T x M ,   it   follows   that   M   is   a   quotient   of   T   M   with   natural   projection   x,   π   :   T     :   ξ     T    

$$
\pi \colon T \mathcal { M } \to \mathcal { M } \colon \xi \in T _ { x } \mathcal { M } \ \mapsto \ x , \\ \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x } ( x ) = \intertext { \intertext { \pi \colon T \mathcal { M } \to \mathcal { M } } \ f _ { x }
$$

i.e.,   π ( ξ )   is   the   foot   of   ξ .   The   set   T   M   admits   a   natural   manifold   structure   as   follows.   Given   a   chart   ( U , ϕ )   of   M ,   the   mapping   ξ     T     ( ϕ ( x ) , . . . , ϕ ( x ) , ξϕ , . . . , ξϕ ) T

$$
\xi \in T _ { x } \mathcal { M } \ & \mapsto \ ( \varphi _ { 1 } ( x ) , \dots , \varphi _ { d } ( x ) , \xi \varphi _ { 1 } , \dots , \xi \varphi _ { d } ) ^ { T } \\ \text {out of the} \ t A \ \text {with} \ d o m \, \text {in} \ \, \varphi _ { d } = \text {1} ( 1 ) \ \, \tt U _ { \ } o n \ h o b { o w } \, \tt h
$$

is   a   chart   of   the   set   T   M   with   domain   π − 1 ( U ).   It   can   be   shown   that   the   collection   of   the   charts   thus   constructed   forms   an   atlas   of   the   set   T   M ,   turning   it   into   a   manifold   called   the   tangent bundle of   M .  

# 3.5.4 Vector ﬁelds

A   vector ﬁeld ξ   on   a   manifold   M   is   a   smooth   function   from   M   to   the   tangent   bundle   T   M   that   assigns   to   each   point   x   ∈ M   a   tangent   vector   ξ x ∈   T x M .   On   a   submanifold   of   a   vector   space,   a   vector   ﬁeld   can   be   pictured   as   a   collection   of   arrows,   one   at   each   point   of   M .   Given   a   vector   ﬁeld   ξ   on   M and   a   (smooth)   real-valued   function   f   ∈   F ( M ),   we   let   ξf   denote   the   realvalued   function   on   M   deﬁned   by   ( ξf )( x )   :=   ξ ( f )  

$$
( \xi f ) ( x ) \colon = \xi _ { x } ( f )
$$

for   all   x   in   M .   The   addition   of   two   vector   ﬁelds   and   the   multiplication   of   a   vector   ﬁeld   by   a   function   f   ∈   F ( M )   are   deﬁned   as   follows:   ( f ξ ) :=   f ( x ) ξ ,  

$$
( f \xi ) _ { x } & \colon = f ( x ) \xi _ { x } , \\ ( \xi + \zeta ) _ { x } & \colon = \xi _ { x } + \zeta _ { x } \quad \text {for all } x \in \mathcal { M } .
$$

[Page 50]

Smoothness   is   preserved   by   these   operations.   We   let   X ( M )   denote   the   set   of   smooth   vector   ﬁelds   endowed   with   these   two   operations.  

Let   ( U , ϕ )   be   a   chart   of   the   manifold   M .   The   vector   ﬁeld   E i on   U   deﬁned   by  

$$
( E _ { i } f ) ( x ) & \colon = \partial _ { i } ( f \circ \varphi ^ { - 1 } ) ( \varphi ( x ) ) = D ( f \circ \varphi ^ { - 1 } ) \left ( \varphi ( x ) \right ) [ e _ { i } ] \\ \intertext { w l } 1 0 1 0 1 \colon = 0 1 0 \circ \varphi ^ { - 1 } ) ( \varphi ( x ) ) & = D ( f \circ \varphi ^ { - 1 } ) \left ( \varphi ( x ) \right ) [ e _ { i } ] \\
$$

is   called   the   i th coordinate vector ﬁeld of   ( U , ϕ ).   These   coordinate   vector   ﬁelds   are   smooth,   and   every   vector   ﬁeld   ξ   admits   the   decomposition  

$$
\xi = \sum _ { i } ( \xi \varphi _ { i } ) E _ { i } \\ \text {of this result was given}
$$

on U . (A pointwise version of this result was given in Section 3.5.1.)

If the manifold is an n -dimensional vector space E , then, given a basis ( e i ) i =1 ,...,d of E , the vector fi elds E i , i = 1 , . . . , n , defined by

$$
( E _ { i } f ) ( x ) \colon = \lim _ { t \to 0 } \frac { f ( x + t e _ { i } ) - f ( x ) } { t } = D f \left ( x \right ) \left [ e _ { i } \right ]
$$

form   a   basis   of   X ( E ).  

# 3.5.5 Tangent vectors as derivations ∗  

Let   x   and   η   be   elements   of   R n .   The   derivative   mapping   that,   given   a   realvalued   function   f   on   R n ,   returns   the   real   D f   ( x ) [ η ]   can   be   axiomatized   as   follows   on   manifolds.   Let   M   be   a   manifold   and   recall   that   F ( M )   denotes   the   set   of   all   smooth   real-valued   functions   on   M .   Note   that   F ( M )   ⊂   F x ( M )   for   all   x   ∈ M . A   derivation at x   ∈ M   is   a   mapping   ξ x from   F ( M )   to   R   that   is  

- 1. 	 R -linear:   ξ x ( af   +   bg ) =   aξ x ( f ) +   bξ x ( g ),   and  
- 2. 	 Leibnizian:   ξ x ( f g ) =   ξ x ( f ) g ( x ) +   f ( x ) ξ x ( g ),   for   all   a,   b   ∈   R   and   f,   g   ∈ F ( M ).  


With   the   operations  

$$
( \xi _ { x } + \zeta _ { x } ) f & \colon = \xi _ { x } ( f ) + \zeta _ { x } ( f ) , \\ ( a \xi _ { x } ) f & \colon = a \xi _ { x } ( f ) \quad \text {for all } f \in \mathfrak { F } ( \mathcal { M } ) , \ a \in \mathbb { R } , \\ \intertext { s o t o f o l l d o r i v i o n s $ t o r $ b o g o m o s $ t o r $ v o t o r $ s p n o $ }
$$

the   set   of   all   derivations   at   x   becomes   a   vector   space.   It   can   also   be   shown   that   a   derivation   ξ x at   x   is   a   local   notion:   if   two   real-valued   functions   f   and   g   are   equal   on   a   neighborhood   of   x ,   then   ξ x ( f ) =   ξ x ( g ).  

The   concept   of   a   tangent   vector   at   x ,   as   deﬁned   in   Section   3.5.1,   and   the   notion   of   a   derivation   at   x   are   equivalent   in   the   following   sense:   (i)   Given   a   curve   γ   on   M   through   x   at   t   =   0,   the   mapping   ˙ γ (0)   from   F ( M )   ⊆   F x ( M )   to   R ,   deﬁned   in   (3.10),   is   a   derivation   at   x .   (ii)   Given   a   derivation   ξ   at   x ,   there   exists   a   curve   γ   on   M   through   x   at   t   =   0   such   that   γ ˙ (0)   =   ξ .   For   example,   the   curve   γ   deﬁned   by   γ ( t ) =   ϕ − 1 ( ϕ (0)   +   t     i ( ξ ( ϕ i ) e i ))   satisﬁes   the   property.   A   (global)   derivation on   F ( M )   is   a   mapping   D   :   F ( M )   F ( M )   that   is   →  

A (global) derivation on F ( M ) is a mapping D : F ( M ) F ( M ) that is →

[Page 51]

- 1.   R -linear:   D ( af   +   bg ) =   a   D ( f ) +   b   D ( g ),   ( a,   b   ∈   R ),   and  

$$
\text {linear} \colon \mathcal { D } ( a f + b g ) = a \, \mathcal { D } ( f ) + b \, \mathcal { D } ( g ) , \, ( a , \, b \in \mathbb { R } ) , \, \text {and} \\ \text {libnizian} \colon \mathcal { D } ( f g ) = \mathcal { D } ( f ) g + f \, \mathcal { D } ( g ) .
$$

- 2.   Leibnizian:   D ( f g ) =   D ( f ) g   +   f   D ( g ).                


Every vector ﬁeld ξ ∈ X ( M ) deﬁnes a derivation   f    →   ξf .   Conversely,   every   derivation   on   F ( M )   can   be   realized   as   a   vector   ﬁeld.   (Viewing   vector   ﬁelds   as   derivations   comes   in   handy   in   understanding   Lie   brackets;   see   Section   5.3.1.)  

# 3.5.6 Diﬀerential of a mapping

Let   F   :   M → N   be   a   smooth   mapping   between   two   manifolds   M   and   N   .   Let   ξ x be   a   tangent   vector   at   a   point   x   of   M .   It   can   be   shown   that   the   mapping   D F   ( x ) [ ξ x ]   from   F F ( x ) ( N   )   to   R   deﬁned   by                  

$$
( D F \left ( x \right ) [ \xi ] ) \, f \coloneqq \xi ( f \circ F ) & & ( 3 . 1 3 ) \\ + \, \{ f \subsetneq F \left ( x \right ) \, \left [ \xi \right ] \right ) \, f \coloneqq \xi ( f \circ F ) & & ( 3 . 1 3 ) \\
$$

is   a   tangent   vector   to   N   at   F   ( x ).   The   tangent   vector   D F   ( x ) [ ξ x ]   is   realized   by   F γ ,   where   γ   is   any   curve   that   realizes   ξ x .   The   mapping   ◦ 
                 


$$
D F ( x ) & \colon T _ { x } \mathcal { M } \to T _ { F ( x ) } \mathcal { N } \colon \xi \mapsto D F \left ( x \right ) [ \xi ] \\ \vdots & \quad v \, _ { x } \, 1 _ { x } \, \dots \, 1 _ { x } \, \cdots \, ( x ) \, \cdots \, v \, _ { x } \, ( x )
$$

is   a   linear   mapping   called   the   diﬀerential (or   diﬀerential map ,   derivative ,   or   tangent map )   of   F   at   x   (see   Figure   3.5).  

![In this image, we can see a diagram with some lines and points. There are two triangles and one angle labeled as \( T_M \).](<images/imageFile8.png>)

ξ x  

F

x

ξx

D

(

)[

]

F

x

D

(

)

N

TF

(

x

)

M  

T x

F

x

(

)

x  

γ

t

F

(

(

))

γ

t

(

)

N  

F  

M  

Figure 3.5 Diﬀerential map of F at x .

Note   that   F   is   an   immersion   (respectively,   submersion)   if   and   only   if   D F   ( x ) :   T x M →   T F ( x ) N   is   an   injection   (respectively,   surjection)   for   every   x   ∈ M .   If   N   is   a   vector   space   E ,   then   the   canonical   identiﬁcation   T F ( x ) E ≃ E  

If N is a vector space E , then the canonical identification T F ( x ) E /similarequal E yields

$$
D F \left ( x \right ) \left [ \xi _ { x } \right ] = \sum _ { i } \left ( \xi _ { x } F ^ { i } \right ) e _ { i } , \\ F , F ^ { i } ( x ) e _ { i } \text { is the decomposition of } F ( x ) \text { in a basis } ( e _ { i } ) _ { i } = 1 ,
$$

where F ( x ) = ∑ i F i ( x ) e i is the decomposition of F ( x ) in a basis ( e i ) i =1 ,...,n of E .

If N = R , then F ∈ F x ( M ), and we simply have

$$
D F ( x ) [ \xi _ { x } ] = \xi _ { x } F
$$

[Page 52]

using   the   identiﬁcation   T x R   ≃   R .   We   will   often   use   D F   ( x ) [ ξ x ]   as   an   alternative   notation   for   ξ x F   ,   as   it   better   emphasizes   the   derivative   aspect.  

If   M   and   N   are   linear   manifolds,   then,   with   the   identiﬁcation   T x M ≃ M   and   T y N   ≃ N   , D F   ( x )   reduces   to   its   classical   deﬁnition   F   ( x   +   tξ )     F   ( x )  

$$
D F \left ( x \right ) \left [ \xi _ { x } \right ] = \lim _ { t \rightarrow 0 } \frac { F ( x + t \xi _ { x } ) - F ( x ) } { t } . \\
$$

Given   a   diﬀerentiable   function   F   :   M    →   N   and   a   vector   ﬁeld   ξ   on   M ,   we   let   D F   [ ξ ]   denote   the   mapping  

$$
D F [ \xi ] \colon \mathcal { M } \to T \mathcal { N } \colon x & \mapsto D F \left ( x \right ) [ \xi _ { x } ] \, . \\ \cdot \quad & 1 \, \quad 1 \, \cdot \, 1 \, f \quad \cdot \quad f \quad \cdot \quad \cdot \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \, \quad 1 \, \cdot \, 1 \
$$

In   particular,   given   a   real-valued   function   f   on   M   and   a   vector   ﬁeld   ξ   on   M ,      

$$
D f [ \xi ] = \xi f .
$$

# 3.5.7 Tangent vectors to embedded submanifolds

We   now   investigate   the   case   where   M   is   an   embedded   submanifold   of   a   vector   space   E .   Let   γ   be   a   curve   in   M ,   with   γ (0)   =   x .   Deﬁne   γ ( t )     γ (0)  

$$
\gamma ^ { \prime } ( 0 ) \colon = \lim _ { t \to 0 } \frac { \gamma ( t ) - \gamma ( 0 ) } { t } ,
$$

where   the   subtraction   is   well   deﬁned   since   γ ( t )   belongs   to   the   vector   space   E for   all   t .   (Strictly   speaking,   one   should   write   i ( γ ( t ))   −   i ( γ (0)),   where   i   is   the   natural   inclusion   of   M   in   E ;   the   inclusion   is   omitted   to   simplify   the   notation.)   It   follows   that   γ   ′   (0)   thus   deﬁned   is   an   element   of   T x E ≃ E   (see   Figure   3.6).   Since   γ   is   a   curve   in   M ,   it   also   induces   a   tangent   vector   γ ˙ (0)   ∈   T x M .   Not  

![The image depicts a geometric figure involving a circle and two points labeled as point A and point B. The circle is a circle with a diameter labeled as diameter A and a diameter labeled as diameter B. The points A and B are located on the circumference of the circle. ### Description of the Figure: 1. **Circle**: The circle is a circle with a diameter labeled as diameter A. 2. **Points**: Point A and point B are located on the circumference of the circle. 3. **Diameter**: The diameter of the circle is labeled as diameter A. 4. **Center**: The center of the circle is marked as point C. 5. **Angles**: The angles at the points A and B are labeled as 180 degrees. ### Analysis: 1. **Diameter**: The diameter of the circle is the longest diameter. 2. **Center**: The center of the circle is marked as point C.](<images/imageFile9.png>)

R  

R  

γ  

γ

t

(

)

′

γ

(0)

x  

γ

=

(0)

f  

-

S n −

1

Figure 3.6 Curves and tangent vectors on the sphere. Since S n − 1   is an embedded submanifold of R n , the tangent vector γ ˙ (0) can be pictured as the directional derivative γ ′ (0).

surprisingly, γ ′ (0) and ˙ γ (0) are closely related: If f is a real-valued function in a neighborhood U of x in E and f denotes the restriction of f to U ∩ M (which is a neighborhood of x in M since M is embedded), then we have

[Page 53]

$$
( \text {which is a neighborhood of } x \text { in } \mathcal { M } \text { since } \mathcal { M } \text { is embedded), then we have } \\ \dot { \gamma } ( 0 ) f = \frac { d } { d t } \, f ( \gamma ( t ) ) \Big | _ { t = 0 } = \frac { d } { d t } \, \bar { f } ( \gamma ( t ) ) \Big | _ { t = 0 } = D \bar { f } \left ( \gamma ^ { \prime } ( 0 ) \right ] . \\ \text {This yields a natural identification of } T _ { x } \mathcal { M } \text { with the set } \\ \{ \gamma ^ { \prime } ( 0 ) \colon \gamma \text { curve in } \mathcal { M } , \, \gamma ( 0 ) = x \} ,
$$

$$
\{ \gamma ^ { \prime } ( 0 ) \colon \gamma \text { curve in } \mathcal { M } , \ \gamma ( 0 ) = x \} , \\ \intertext { i n g r a n d s } \ \{ \gamma ^ { \prime } ( 0 ) \colon \gamma \text { curve in } \mathcal { M } , \ \gamma ( 0 ) = x \} ,
$$

which   is   a   linear   subspace   of   the   vector   space   T x E ≃ E .   In   particular,   when   M   is   a   matrix   submanifold   (i.e.,   the   embedding   space   is   R n × p ),   we   have   T x E   =   R n × p ,   hence   the   tangent   vectors   to   M   are   naturally   represented   by   n   ×   p   matrix   arrays.   Graphically,   a   tangent   vector   to   a   submanifold   of   a   vector   space   can   be  

thought   of   as   an   “arrow”   tangent   to   the   manifold.   It   is   convenient   to   keep   this   intuition   in   mind   when   dealing   with   more   abstract   manifolds;   however,   one   should   bear   in   mind   that   the   notion   of   a   tangent   arrow   cannot   always   be   visualized   meaningfully   in   this   manner,   in   which   case   one   must   return   to   the   deﬁnition   of   tangent   vectors   as   objects   that,   given   a   real-valued   function,   return   a   real   number,   as   stated   in   Deﬁnition   3.5.1.   ′  

In   view   of   the   identiﬁcation   of   T x M   with   (3.18),   we   now   write   γ ˙ ( t ),   γ   ( t ),   and   d γ ( t )   interchangeably.   We   also   use   the   equality   sign,   such   as   in   (3.19)   d t below,   to   denote   the   identiﬁcation   of   T x M   with   (3.18).   When   M   is   (locally   or   globally)   deﬁned   as   a   level   set   of   a   constant-rank  

When M is (locally or globally) defined as a level set of a constant-rank function F : E ↦→ R n , we have

$$
T _ { x } \mathcal { M } = \ker ( D F ( x ) ) . & & ( 3 . 1 9 ) \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\ & & \\
$$

In   other   words,   the   tangent   vectors   to   M   at   x   correspond   to   those   vectors   ξ   that   satisfy   D F   ( x ) [ ξ ]   =   0.   Indeed,   if   γ   is   a   curve   in   M   with   γ (0)   =   x ,   we   have   F   ( γ ( t )) = 0   for   all   t ,   hence  

$$
= 0 \text { for all } t , \text { hence} \\ \ D F \left ( x \right ) [ \dot { \gamma } ( 0 ) ] = \frac { d ( F ( \gamma ( t ) ) ) } { d t } \Big | _ { t = 0 } = 0 , \\ \text {that } \dot { \gamma } ( 0 ) \in \ker ( D F ( x ) ) . \text { By counting dimensions } t \text { follows that } T _ { x } \mathcal { M } \text { and } \ker ( D F ( x ) ) \text { are two vectors}
$$

D F   ( x ) [ ˙ γ (0)] =   = 0 , d t     t =0 which   shows   that   ˙ γ (0)   ∈   ker(D F   ( x )).   By   counting   dimensions   using   Proposition   3.3.4,   it   follows   that   T x M   and   ker(D F   ( x ))   are   two   vector   spaces   of   the   same   dimension   with   one   included   in   the   other.   This   proves   the   equality   (3.19).  

# Example 3.5.1 Tangent   space   to   a   sphere   n − 1

Let t    →   x ( t )   be a curve in the unit sphere S through x 0 at t   = 0 . Since x ( t )   ∈   S n − 1 for all t , we have x   T ( t ) x ( t ) = 1  

$$
x ^ { T } ( t ) x ( t ) = 1
$$

for all t . Diﬀerentiating this equation with respect to t   yields

$$
\dot { x } ^ { T } ( t ) x ( t ) + x ^ { T } ( t ) \dot { x } ( t ) = 0 ,
$$

hence x ˙ (0)   is an element of the set

$$
\{ z \in \mathbb { R } ^ { n } \colon x _ { 0 } ^ { T } z = 0 \} .
$$

[Page 54]

![The image consists of a geometric figure with a circle and a point labeled as point z. The circle is positioned at the center of the image and is tangent to the circle at point z. The point z is located on the circumference of the circle.](<images/imageFile10.png>)

x

t

(

)

x

x

=

(0)

′

x

(0)

0

-

S n −

1

Figure 3.7 Tangent space on the sphere. Since S n − 1   is an embedded submanifold of R n , the tangent space T x S n − 1   can be pictured as the hyperplane tangent to the sphere at x , with origin at x .

This shows that T x 0 S n − 1 is a subset of (3.20) . Conversely, let z   belong to the set (3.20) . Then the curve t    →   x ( t )   :=   ( x 0 +   tz ) /   x 0 +   tz     is on S n − 1 and satisﬁes x ˙ (0)   =   z . Hence (3.20)   is a subset of T x 0 S n − 1 . In conclusion,

$$
T _ { x } S ^ { n - 1 } = \{ z \in \mathbb { R } ^ { n } \colon x ^ { T } z = 0 \} , \\ \\ + \ \ell _ { x } \ U _ { 1 } = \{ z \in \mathbb { R } ^ { n } \colon x ^ { T } z = 0 \} ,
$$

which is the set of all vectors orthogonal to x   in R n ; see Figure 3.7. n T

More directly, consider the function F   :   R →   R   :   x    →   x x   −   1 . Since S n − 1 =   { x   ∈   R n :   F   ( x ) = 0 }   and since F   is full rank on S n − 1 , it follows from (3.19)   that

$$
T _ { x } S ^ { n - 1 } & = \ker ( D F ( x ) ) = \{ z \in \mathbb { R } ^ { n } \colon x ^ { T } z + z ^ { T } x = 0 \} = \{ z \in \mathbb { R } ^ { n } \colon x ^ { T } z = 0 \} , \\ \intertext { a s \ i n \ ( 3 . 2 1 ) . }
$$

# Example 3.5.2 Orthogonal   Stiefel   manifold  

We consider the orthogonal Stiefel manifold

$$
S t ( p , n ) = \{ X \in \mathbb { R } ^ { n \times p } \colon X ^ { T } X = I _ { p } \} \\
$$

as an embedded submanifold of the Euclidean space R n × p (see Section 3.3.2). Let X 0 be an element of St( p, n )   and let t    →   X ( t )   be a curve in St( p, n )   through X 0 at t   = 0 ; i.e., X ( t )   ∈   R n × p , X (0)   =   X 0 , and T

$$
X ^ { T } ( t ) X ( t ) = I _ { p }
$$

for all t . It follows by diﬀerentiating (3.22)   that

$$
\dot { X } ^ { T } ( t ) X ( t ) + X ^ { T } ( t ) \dot { X } ( t ) = 0 .
$$

[Page 55]

We deduce that X ˙ (0)   belongs to the set

$$
\{ Z \in \mathbb { R } ^ { n \times p } \colon X _ { 0 } ^ { T } Z + Z ^ { T } X _ { 0 } = 0 \} . \\ \\ \L _ { 0 } \, \mu _ { 0 } \, T _ { 0 } \, C ( \mu _ { 0 } ) \, \colon \, _ { 0 } \, \mu _ { 0 } \, ( 0 , 0 ) \, \mu _ { 0 } \, , \quad _ { 0 } \, \mu _ { 0 } \, ,
$$

We have thus shown that T X 0 St( p, n )   is a subset of (3.24) . It is possible to conclude, as in the previous example, by showing that for all Z   in (3.24)   there is a curve in St( p, n )   through X 0 at t   such that X ˙ (0)   =   Z . A simpler argument is to invoke (3.19)   by pointing out that (3.24)   is the kernel of D F   ( X 0 ) , where F   :   X    →   X T X , so that I p is a regular value of F   and F   − 1 ( I p )   =   St( p, n ) . In conclusion, the set described in (3.24)   is the tangent space to St( p, n )   at X 0 . That is,

$$
T _ { X } \, S t ( p , n ) = \{ Z \in \mathbb { R } ^ { n \times p } \colon X ^ { T } Z + Z ^ { T } X = 0 \} . \\
$$

We now propose an alternative characterization of T X St( p, n ) . Without loss of generality, since X ˙ ( t )   is an element of R n × p and X ( t )   has full rank, we can set

$$
\dot { X } ( t ) = X ( t ) \Omega ( t ) + X _ { \perp } ( t ) K ( t ) ,
$$

where X ⊥ ( t )   is any n   ×   ( n   −   p )   matrix such that span( X ⊥ ( t ))   is the orthogonal complement of span( X ( t )) . Replacing (3.25)   in (3.23)   yields

$$
\Omega ( t ) ^ { T } + \Omega ( t ) = 0 ;
$$

i.e., Ω( t )   is a skew-symmetric matrix. Counting dimensions, we deduce that

$$
T _ { X } \, S t ( p , n ) = \{ X \Omega + X _ { \perp } K \, \colon \Omega ^ { T } = - \Omega , \ K \in \mathbb { R } ^ { ( n - p ) \times p } \} . \\ O l _ { X } \, \quad \cup _ { \substack { ( X ) = \Omega , \\ ( X ) = \Omega ) } } \, T _ { X } \, S t ( p , n ) = \{ X \Omega + X _ { \perp } K \, \colon \Omega ^ { T } = \mathbb { r } ( \Omega ) \ \Omega ( \Omega ) ^ { - 1 } \times \Omega ^ { ( n - p ) \times p } \} .
$$

Observe that the two characterizations of T X St( p, n )   are facilitated by the embedding of St( p, n )   in R n × p : T X St( p, n )   is identiﬁed with a linear subspace of R n × p .

# Example 3.5.3 Orthogonal   group  

Since the orthogonal group O n is St( p, n )   with p   =   n , it follows from the previous section that

$$
T _ { U } O _ { n } = \{ Z = U \Omega \colon \Omega ^ { T } = - \Omega \} = U \mathcal { S } _ { s k e w } ( n ) , \\ \intertext { t } \mathcal { O } _ { n } ( \Omega ) = \{ Z = U \Omega \colon \Omega ^ { T } = - \Omega \} = U \mathcal { S } _ { s k e w } ( n ) ,
$$

where S skew ( n )   denotes the set of all skew-symmetric n   ×   n   matrices.

# 3.5.8 Tangent vectors to quotient manifolds

We   have   seen   that   tangent   vectors   of   a   submanifold   embedded   in   a   vector   space   E   can   be   viewed   as   tangent   vectors   to   E   and   pictured   as   arrows   in   E tangent   to   the   submanifold.   The   situation   of   a   quotient   E /   ∼   of   a   vector   space   E   is   more   abstract.   Nevertheless,   the   structure   space   E   also   oﬀers   convenient   representations   of   tangent   vectors   to   the   quotient.  

For generality, we consider an abstract manifold M and a quotient manifold M = M / ∼ with canonical projection π . Let ξ be an element of T x M and let x be an element of the equivalence class π -1 ( x ). Any element ξ of T x M that satisfies D π ( x )[ ξ ] = ξ can be considered a representation of ξ . Indeed, for any smooth function f : M→ R , the function f := f ◦ π : M→ R is smooth (Proposition 3.4.5), and one has

[Page 56]

$$
D \bar { f } ( \bar { x } ) [ \bar { \xi } ] = D f ( \pi ( \bar { x } ) ) [ D \pi ( \bar { x } ) [ \bar { \xi } ] ] = D f ( x ) [ \xi ] .
$$

A   diﬃculty   with   this   approach   is   that   there   are   inﬁnitely   many   valid   representations   ξ   of   ξ   at   x .  

It   is   desirable   to   identify   a   unique   “lifted”   representation   of   tangent   vectors   of   T x M   in   T x M   in   order   that   we   can   use   the   lifted   tangent   vector   representation   unambiguously   in   numerical   computations.   Recall   from   Proposition   3.4.4   that   the   equivalence   class   π − 1 ( x )   is   an   embedded   submanifold   of   M .   Hence   π − 1 ( x )   admits   a   tangent   space     − 1  

$$
\mathcal { V } _ { \overline { x } } & = T _ { \overline { x } } ( \pi ^ { - 1 } ( x ) ) \\ - \ \Lambda _ { x } & = \dot { \cdot } _ { x } \cdot 2 ( \mu + 1 )
$$

called   the   vertical space at   x .   A   mapping   H   that   assigns   to   each   element   x   of   M   a   subspace   H x of   T x M   complementary   to   V x (i.e.,   such   that   H x ⊕ V x =   T x M )   is   called   a   horizontal distribution on   M .   Given   x   ∈ M ,   the   subspace   H x of   T x M   is   then   called   the   horizontal space at   x ;   see   Figure   3.8.   Once   M   is   endowed   with   a   horizontal   distribution,   there   exists   one   and   only   one   element   ξ x that   belongs   to   H x and   satisﬁes   D π ( x )[ ξ x ] =   ξ .   This   unique   vector   ξ is   called   the   horizontal lift of   ξ   at   x . x                     R n × p    

In particular, when the structure space is (a subset of) , the horizontal   lift   ξ is   an   n   ×   p   matrix,   which   lends   itself   to   representation   in   a   x computer   as   a   matrix   array.  

# Example 3.5.4 Real   projective   space  

Recall from Section 3.4.3 that the projective space RP n − 1 is the quotient R n ∗   / ∼ , where x   ∼   y   if and only if there is an α   ∈   R ∗   such that y   =   xα . The equivalence class of a point x   of R n is ∗  

$$
[ x ] & = \pi ^ { - 1 } ( \pi ( x ) ) = x \mathbb { R } _ { * } \colon = \{ x \alpha \colon \alpha \in \mathbb { R } _ { * } \} . \\ \intertext { l } 1 \intertext { l } x \intertext { l } \intertext { i } x ^ { 2 } + x ^ { 2 } \in \mathbb { T } ^ { n } \colon
$$

The vertical space at a point x   ∈   R n is ∗     R    

$$
\mathcal { V } _ { x } = x \mathbb { R } \colon = \{ x \alpha \colon \alpha \in \mathbb { R } \} . \\ \intertext { v } \mathcal { V } _ { x } = x \mathbb { R } \colon = \{ x \alpha \colon \alpha \in \mathbb { R } \} .
$$

A suitable choice of horizontal distribution is

$$
\mathcal { H } _ { x } \colon = ( \mathcal { V } _ { x } ) ^ { \perp } \colon = \{ z \in \mathbb { R } ^ { n } \colon x ^ { T } z = 0 \} . \\ \cdot \quad _ { t } \ u l \, \cdot \, _ { t } \ u l \, \cdot \, _ { t } \ u l \quad _ { t } \ u l \, \cdot \, _ { t } \ u l \quad _ { t } \cdot \, _ { t } \ u l \quad _ { t } \cdot \, _ { t } \ G \quad _ { t } \cdot \, _ { t } \ G \quad _ { t } \cdot \, _ { t } \ G \quad _ { t } \cdot \, _ { t }
$$

(This horizontal distribution will play a particular role in Section 3.6.2 where the projective space is turned into a Riemannian quotient manifold.) n − 1

A tangent vector ξ   ∈   T π ( x ) RP is represented by its horizontal lift ξ x ∈   H x at a point x   ∈   R n ∗   . It would be equally valid to use another representation ξ y ∈ H y of the same tangent vector at another point y   ∈   R n such that x   ∼   y . ∗   The two representations ξ x and ξ y are not equal as vectors in R n but are related by a scaling factor, as we now show. First, note that x   ∼   y   if and only if there exists a nonzero scalar α   such that y   =   αx . Let f   :   RP n − 1 R → be an arbitrary smooth function and deﬁne f   :=   f π   :   R n R . Consider ◦   ∗   → the function g   :   x    →   αx , where α   is an arbitrary nonzero scalar. Since

[Page 57]

![The image is a geometric figure consisting of a circle and a line segment. The circle is positioned at the top of the image and is tangent to the line segment at a point called point A. The line segment is drawn from point A to the center of the circle. The circle is a circle with a radius of 2 units. The line segment is a straight line with a length of 1 unit. The image is labeled as follows: - The circle is labeled as circle A. - The line segment is labeled as line segment A. - The point A is labeled as point A. - The radius of the circle is labeled as 2 units. - The center of the circle is labeled as point A. - The line segment is labeled as line segment A. - The point A is labeled as point A. - The radius of the circle is labeled as 2 units. - The center of the circle is labeled as point A](<images/imageFile11.png>)

-

1

π

π

x

(

(

))

V

x

E  

x  

H

x

π 


E

∼  

/

x  

π

x

=

(

)

Figure 3.8 Schematic illustration of a quotient manifold. An equivalence class π − 1 ( π ( x )) is pictured as a subset of the total space E and corresponds to the single point π ( x ) in the quotient manifold E / ∼ . At x , the tangent space to the equivalence class is the vertical space V x , and the horizontal space H x is chosen as a complement of the vertical space.

π ( g ( x ))   =   π ( x )   for all x , we have f ( g ( x ))   =   f ( x )   for all x , and it follows by taking the diﬀerential of both sides that

$$
D \bar { f } ( g ( x ) ) [ D g ( x ) [ \bar { \xi } _ { x } ] ] = D \bar { f } ( x ) [ \bar { \xi } _ { x } ] .
$$

By the deﬁnition of ξ x , we have D f ( x )[ ξ x ] = D f ( π ( x ))[ ξ ] . Moreover, we have D g ( x )[ ξ x ] =   αξ x . Thus (3.28)   yields D f ( αx )[ αξ x ]]   =   D f ( π ( αx ))[ ξ ] .   This result, since it is valid for any smooth function f , implies that D π ( αx )[ αξ x ] =   ξ . This, along with the fact that αξ is an element of H αx , implies that αξ x x is the horizontal lift of ξ   at αx , i.e.,

$$
\bar { \xi } _ { \alpha x } = \alpha \bar { \xi } _ { x } .
$$

# Example 3.5.5 Grassmann   manifolds  

Tangent vectors to the Grassmann manifolds and their matrix representations are presented in Section 3.6.

[Page 58]

# 3.6 RIEMANNIAN METRIC, DISTANCE, AND GRADIENTS

Tangent   vectors   on   manifolds   generalize   the   notion   of   a   directional   derivative.   In   order   to   characterize   which   direction   of   motion   from   x   produces   the   steepest   increase   in   f ,   we   further   need   a   notion   of   length   that   applies   to   tangent   vectors.   This   is   done   by   endowing   every   tangent   space   T x M   with   an   inner product  · ,   ·  x ,   i.e.,   a   bilinear,   symmetric   positive-deﬁnite   form.   The   inner   product    · ,   ·  x induces   a   norm,  

$$
\| \xi _ { x } \| _ { x } \coloneqq \sqrt { \langle \xi _ { x } , \xi _ { x } \rangle _ { x } } , \\ t \ x \text { may be omitted if there} \\ \text {ion of octon descent} \text { is the}
$$

on   T x M .   (The   subscript   x   may   be   omitted   if   there   is   no   risk   of   confusion.)   The   (normalized)   direction   of   steepest   ascent   is   then   given   by  

$$
\arg \max _ { \xi \in T _ { x } \mathcal { M } \colon \| \xi _ { x } \| = 1 } \ D f \left ( x \right ) \left [ \xi _ { x } \right ] .
$$

A   manifold   whose   tangent   spaces   are   endowed   with   a   smoothly   varying   inner   product   is   called   a   Riemannian manifold .   The   smoothly   varying   inner   product   is   called   the   Riemannian metric .   We   will   use   interchangeably   the   notation  

$$
g ( \xi _ { x } , \zeta _ { x } ) = g _ { x } ( \xi _ { x } , \zeta _ { x } ) = \langle \xi _ { x } , \zeta _ { x } \rangle = \langle \xi _ { x } , \zeta _ { x } \rangle _ { x } \\ \\ g ( \xi _ { x } , \zeta _ { x } ) = g _ { x } ( \xi _ { x } , \zeta _ { x } ) = \langle \xi _ { x } , \zeta _ { x } \rangle = \langle \xi _ { x } , \zeta _ { x } \rangle _ { x } \\ \\ g ( \xi _ { x } , \zeta _ { x } ) = g _ { x } ( \xi _ { x } , \zeta _ { x } ) = \langle \xi _ { x } , \zeta _ { x } \rangle _ { x } \\ \\ g ( \xi _ { x } , \zeta _ { x } ) = g _ { x } ( \xi _ { x } , \zeta _ { x } ) = \langle \xi _ { x } , \zeta _ { x } \rangle _ { x } \\
$$

to   denote   the   inner   product   of   two   elements   ξ x and   ζ x of   T x M .   Strictly   speaking,   a   Riemannian   manifold   is   thus   a   couple   ( M , g ),   where   M   is   a   manifold   and   g   is   a   Riemannian   metric   on   M .   Nevertheless,   when   the   Riemannian   metric   is   unimportant   or   clear   from   the   context,   we   simply   talk   about   “the   Riemannian   manifold   M ”.   A   vector   space   endowed   with   an   inner   product   is   a   particular   Riemannian   manifold   called   Euclidean space .   Any   (second-countable   Hausdorﬀ)   manifold   admits   a   Riemannian   structure.  

Let   ( U , ϕ )   be   a   chart   of   a   Riemannian   manifold   ( M , g ).   The   components   of   g   in   the   chart   are   given   by  

$$
g _ { i j } \colon = g ( E _ { i } , E _ { j } ) ,
$$

where   E i denotes   the   i th   coordinate   vector   ﬁeld   (see   Section   3.5.4).   Thus,   for   vector   ﬁelds   ξ   =     i ξ i E i and   ζ   =     i ζ i E i ,   we   have   g ( ξ, ζ ) =     ξ, η     =       g ij ξ i ζ j .  

$$
- \sum _ { i } \zeta \, \sum _ { \imath } g _ { i } \zeta & = \sum _ { i } g _ { i } \zeta \, \sum _ { \xi } i , \, \text {we have} \\ g ( \xi , \zeta ) & = \langle \xi , \eta \rangle = \sum _ { i , j } g _ { i j } \xi ^ { i } \zeta ^ { j } . \\ \intertext { g ( \xi , \zeta ) = \langle \xi , \eta \rangle = \sum _ { i , j } g _ { i j } \xi ^ { i } \zeta ^ { j } . } \text {are real valued functions on } \mathcal { U } \subset M \ \subset M \ \subset M
$$

Note   that   the   g ij ’s   are   real-valued   functions   on   U ⊆ M .   One   can   also   deﬁne   the   real-valued   functions   g ij ◦ ϕ − 1 on   ϕ ( U )   ⊆   R d ;   we   use   the   same   notation   g ij for   both.   We   also   use   the   notation   G   : ˆ x for   the   matrix-valued   function   x    →   G ˆ such   that   the   ( i, j )   element   of   G x ˆ is   g ij | .   If   we   let   ξ ˆ x ˆ = D ϕ     ϕ − 1 (ˆ x )     [ ξ x ] x ˆ and   ζ ˆ x ˆ = D ϕ     ϕ − 1 (ˆ x )     [ ζ x ],   with   ˆ x   =   ϕ ( x ),   denote   the   representations   of   ξ x and   ζ x in   the   chart,   then   we   have,   in   matrix   notation,   ˆ T ˆ

$$
g ( \xi _ { x } , \zeta _ { x } ) & = \langle \xi _ { x } , \zeta _ { x } \rangle = \hat { \xi } _ { \hat { x } } ^ { T } G _ { \hat { x } } \hat { \zeta } _ { \hat { x } } . \\ \\ \intertext { g ( \xi _ { x } , \zeta _ { x } ) = \langle \xi _ { x } , \zeta _ { x } \rangle = \hat { \xi } _ { \hat { x } } ^ { T } G _ { \hat { x } } \hat { \zeta } _ { \hat { x } } . } \\ \intertext { g ( \xi _ { x } , \cdot \cdot \cdot ) = 1 , \zeta _ { x } \cdot \cdot \cdot } \\
$$

Note   that   G   is   a   symmetric,   positive   deﬁnite   matrix   at   every   point.  

[Page 59]

$$
L ( \gamma ) = \int _ { a } ^ { b } \sqrt { g ( \dot { \gamma } ( t ) , \dot { \gamma } ( t ) ) } \, d t . \\ \intertext { l a s t a n c e o n a c o n n e c t e d R i e m a n n i a n m }
$$

The Riemannian distance on a connected Riemannian manifold ( M , g ) is

$$
\text {dist} \colon \mathcal { M } \times \mathcal { M } \rightarrow \mathbb { R } \colon \text {dist} ( x , y ) = \inf _ { \Gamma } L ( \gamma ) \\
$$

where   Γ   is   the   set   of   all   curves   in   M   joining   points   x   and   y .   Assuming   (as   usual)   that   M   is   Hausdorﬀ,   it   can   be   shown   that   the   Riemannian   distance   deﬁnes   a   metric ;   i.e.,  

- 1. 	 dist( x, y )   ≥   0,   with   dist( x, y )   =   0   if   and   only   if   x   =   y   (positivedeﬁniteness);  
- 2. 	 dist( x, y )   =   dist( y, x )   (symmetry);  


dist( x, z ) + dist( z, y ) ≥ dist( x, y ) (triangle inequality).

A   metric   is   an   abstraction   of   the   notion   of   distance,   whereas   a   Riemannian   metric   is   an   inner   product   on   tangent   spaces.   There   is,   however,   a   link   since   any   Riemannian   metric   induces   a   distance,   the   Riemannian   distance.  

Given   a   smooth   scalar   ﬁeld   f   on   a   Riemannian   manifold   M ,   the   gradient of   f   at   x ,   denoted   by   grad   f ( x ),   is   deﬁned   as   the   unique   element   of   T x M that   satisﬁes  

$$
\langle \text {grad} \, f ( x ) , \xi \rangle _ { x } = D f \left ( x \right ) \left [ \xi \right ] , \quad \forall \xi \in T _ { x } \mathcal { M } . \\ \text {ordineto} \, \text {covariance} \, \text {of} \, \text {grad} \, f \, \text {is} \, \text { in} \, \text {multi} \, \text {notion}
$$

The   coordinate   expression   of   grad   f   is,   in   matrix   notation,  

  grad   f (ˆ x ) =   G − 1 Grad   f   (ˆ x ) , 	 (3.32)   x ˆ where   G   is   the   matrix-valued   function   deﬁned   in   (3.29)   and   Grad   denotes   the   Euclidean gradient in   R d ,    

$$
\ n t \text { in } \mathbb { R } ^ { d } , \\ \text {Grad } \widehat { f } ( \hat { x } ) \colon = \begin{pmatrix} \partial _ { 1 } \widehat { f } ( \hat { x } ) \\ \vdots \\ \partial _ { d } \widehat { f } ( \hat { x } ) \end{pmatrix} . \\ \text {and } ( 3 . 3 2 ) , \, w e h a v e \, \langle \text {grad } f , \xi \rangle =
$$

̂ (Indeed, from (3.29) and (3.32), we have 〈 grad f, ξ 〉 = ξ ˆ T G ( G -1 Grad f ̂ ) = ξ ˆ T Grad f = D f [ ξ ˆ ] = D f [ ξ ] for any vector fi eld ξ .)

̂ ̂ The gradient of a function has the following remarkable steepest-ascent properties (see Figure 3.9):

- • 	 The   direction   of   grad   f ( x )   is   the   steepest-ascent   direction   of   f   at   x :   grad   f ( x )  

$$
\frac { \text {grad} f ( x ) } { \| \text {grad} f ( x ) \| } & = \underset { \xi \in T _ { x } \mathcal { M } \colon \| \xi \| = 1 } { \arg \max } \ D f \left ( x \right ) \left [ \xi \right ] . \\ \text {of grad} \, f ( x ) \text { gives the st e p e sst } \sl s l o p \text { of } f \text { at } x \colon
$$

- • 	 The   norm   of   grad   f ( x )   gives   the   steepest   slope   of   f   at   x : 
   grad   f ( x )   



$$
\text {of grad f} ( x ) \text { gives the stepest slope of } f \text { at } x \colon \\ \| \text {grad f} ( x ) \| & = D f \left ( x \right ) \left [ \frac { \text {grad f} ( x ) } { \| \text {grad f} ( x ) \| } \right ] . \\ \text {properties are important in the scope of optimization}
$$

These   two   properties   are   important   in   the   scope   of   optimization   methods.  

[Page 60]

![The image consists of a diagram with two circles labeled as \( D \) and \( Df \). The diagram includes a line segment labeled as \( \overline{D} \) and a line segment labeled as \( \overline{Df} \). The line segment \( \overline{D} \) is a line segment that connects the points \( D \) and \( Df \). The line segment \( \overline{D} \) is a line segment that connects the points \( D \) and \( Df \). The diagram also includes a line segment labeled as \( \overline{D} \) and a line segment labeled as \( \overline{Df} \). The line segment \( \overline{D} \) is a line segment that connects the points \( D \) and \( Df \). The line segment \(](<images/imageFile12.png>)

{

}

{

-

}

ξ

f

x

ξ

ξ

f

x

ξ

: D

(

) [

] = 1

: D

(

) [

] =

1

0

x

{

‖

‖

}

ξ

ξ

:

=

1

-

f

x

grad f

(

)

{

}

ξ

f

x

ξ

: D

(

) [

] = 0

Figure 3.9 Illustration of steepest descent.

# 3.6.1 Riemannian submanifolds

If   a   manifold   M   is   endowed   with   a   Riemannian   metric,   one   would   expect   that   manifolds   generated   from   M   (such   as   submanifolds   and   quotient   manifolds)   can   inherit   a   Riemannian   metric   in   a   natural   way.   This   section   considers   the   case   of   embedded   submanifolds;   quotient   manifolds   are   dealt   with   in   the   next   section.  

Let   M   be   an   embedded   submanifold   of   a   Riemannian   manifold   M .   Since   every   tangent   space   T x M   can   be   regarded   as   a   subspace   of   T x M ,   the   Riemannian   metric   g   of   M   induces   a   Riemannian   metric   g   on   M   according   to  

$$
g _ { x } ( \xi , \zeta ) = \bar { g } _ { x } ( \xi , \zeta ) , \ \xi , \ \zeta \in T _ { x } \mathcal { M } , \\ \\ g _ { x } ( \xi , \zeta ) = \bar { g } _ { x } ( \xi , \zeta ) , \ \xi , \ \zeta \in T _ { x } \mathcal { M } , \\
$$

where   ξ   and   ζ   on   the   right-hand   side   are   viewed   as   elements   of   T x M .   This   turns   M   into   a   Riemannian   manifold.   Endowed   with   this   Riemannian   metric,   M   is   called   a   Riemannian submanifold of   M .   The   orthogonal   complement   of   T x M   in   T x M   is   called   the   normal space to M   at x   and   is   denoted   by   ( T x M ) ⊥ :   ⊥  

$$
( T _ { x } \mathcal { M } ) ^ { \perp } = \{ \xi \in T _ { x } \overline { \mathcal { M } } \colon \bar { g } _ { x } ( \xi , \zeta ) = 0 \text { for all } \zeta \in T _ { x } \mathcal { M } \} . \\ \\ \intertext { ( T _ { x } \mathcal { M } ) ^ { \perp } = \{ \xi \in T _ { x } \overline { \mathcal { M } } \colon \bar { g } _ { x } ( \xi , \zeta ) = 0 \text { for all } \zeta \in T _ { x } \mathcal { M } \} . } \\
$$

Any   element   ξ   ∈   T x M   can   be   uniquely   decomposed   into   the   sum   of   an   element   of   T x M   and   an   element   of   ( T x M ) ⊥ :   ⊥  

$$
\xi = P _ { x } \xi + P _ { x } ^ { \perp } \xi ,
$$

where   P x denotes   the   orthogonal   projection   onto   T x M   and   P ⊥   denotes   the   x orthogonal   projection   onto   ( T x M ) ⊥   .  

# Example 3.6.1 Sphere   n − 1

On the unit sphere S considered a Riemannian submanifold of R n , the inner product inherited from the standard inner product on R n is given by

$$
\langle \xi , \eta \rangle _ { x } \colon = \xi ^ { T } \eta .
$$

[Page 61]

$$
( T _ { x } S ^ { n - 1 } ) ^ { \perp } = \{ x \alpha \colon \alpha \in \mathbb { R } \} , \\ \overset { . } { x } \cdot \overset { \cdot } { x } = \{ x \alpha \colon \alpha \in \mathbb { R } \} ,
$$

and the projections are given by

for x   ∈   S n − 1 .

$$
P _ { x } \xi = ( I - x x ^ { T } ) \xi , \quad P _ { x } ^ { \perp } \xi = x x ^ { T } \xi
$$

# Example 3.6.2 Orthogonal   Stiefel   manifold  

Recall that the tangent space to the orthogonal Stiefel manifold St( p, n )   is

$$
T _ { X } \, S t ( p , n ) = \{ X \Omega + X _ { \perp } K \colon \Omega ^ { T } = - \Omega , \ K \in \mathbb { R } ^ { ( n - p ) \times p } \} . \\ T w \colon \quad \stackrel { T _ { X } } { \sim } \quad \stackrel { \cdot } { \sim } \quad \stackrel { \cdot } { \sim } \quad \stackrel { \cdot } { \sim } \quad \stackrel { \cdot } { \sim } \quad \stackrel { \cdot } { \sim } \quad \stackrel { \cdot } { \sim } \quad \stackrel { \cdot } { \sim } \quad \mathbb { W } ^ { n \times p } \colon
$$

The Riemannian metric inherited from the embedding space R n × p is

$$
\langle \xi , \eta \rangle _ { X } \colon = & \text {tr} ( \xi ^ { T } \eta ) . & & ( 3 . 3 4 ) \\ V _ { 1 } & \quad \text {, } \quad V O \quad \cdot \quad V _ { 2 } \quad V _ { 3 } \quad \cdot \quad U \quad ( C _ { 2 } \ \cup \ \cdot \quad ) \quad + \ ( O T O \ \cup \ \cdot \quad ) \\
$$

If ξ   =   X Ω ξ +   X ⊥ K ξ and η   =   X Ω η +   X ⊥ K η , then   ξ, η   X =   tr(Ω T Ω η + ξ K ξ T K η ) . In view of the identity tr( S T Ω)   =   0   for all S   ∈ S sym ( p ) , Ω   ∈   S skew ( p ) , the normal space is ⊥            

$$
( T _ { X } \, S t ( p , n ) ) ^ { \perp } = \{ X S \colon S \in \mathcal { S } _ { s y m } ( p ) \} . \\
$$

The projections are given by

$$
P _ { X } \xi & = ( I - X X ^ { T } ) \xi + X \text { skew} ( X ^ { T } \xi ) , & ( 3 . 3 5 ) \\ & \quad \ D ^ { \perp } c - Y \text { even} ( Y ^ { T } c )
$$

$$
P _ { X } ^ { \perp } \xi = X \, \text {sym} ( X ^ { T } \xi ) ,
$$

where sym( A )   :=   1 2 ( A   +   A T )   and skew( A )   :=   1 2 ( A   −   A T )   denote the components of the decomposition of A   into the sum of a symmetric term and a skew-symmetric term.

Let   f   be   a   cost   function   deﬁned   on   a   Riemannian   manifold   M   and   let   f   denote   the   restriction   of   f   to   a   Riemannian   submanifold   M .   The   gradient   of   f   is   equal   to   the   projection   of   the   gradient   of   f   onto   T x M :          

$$
\text {grad} \, f ( x ) = P _ { x } \, \text {grad} \, \overline { f } ( x ) .
$$

Indeed,   P x grad   f ( x )   belongs   to   T x M   and   (3.31)   is   satisﬁed   since,   for   all   ζ   ∈   T x M ,   we   have     P x grad   f ( x ) , ζ     =     grad   f ( x )   −   P ⊥   grad   f ( x ) , ζ     =   x   grad   f ( x ) , ζ     = D f   ( x ) [ ζ ] = D f   ( x ) [ ζ ].  

# 3.6.2 Riemannian quotient manifolds

We   now   consider   the   case   of   a   quotient   manifold   M   =   M /   ∼ ,   where   the   structure   space   M   is   endowed   with   a   Riemannian   metric   g .   The   horizontal   space   H x at   x   ∈ M   is   canonically   chosen   as   the   orthogonal   complement   in   T x M   of   the   vertical   space   V x =   T x π − 1 ( x ),   namely,     ⊥                  

$$
\mathcal { H } _ { \overline { x } } & \colon = ( T _ { \overline { x } } \mathcal { V } _ { \overline { x } } ) ^ { \perp } = \{ \eta _ { \overline { x } } \in T _ { \overline { x } } \overline { \mathcal { M } } \colon \bar { g } ( \chi _ { \overline { x } } , \eta _ { \overline { x } } ) = 0 \text { for all } \chi _ { \overline { x } } \in \mathcal { V } _ { \overline { x } } \} . \\ \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { D } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext { \mathcal { H } } \mathcal { D } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } + \mathcal { U } _ { \overline { x } } \, \cdot \, \mathcal { U } _ { \overline { x } } = \, - \, \mathcal { U } _ { \overline { x } } \, , \, \intertext {
$$

Recall   that   the   horizontal   lift   at   x   ∈   π − 1 ( x )   of   a   tangent   vector   ξ x ∈   T x M is   the   unique   tangent   vector   ξ x ∈ H x that   satisﬁes   D π ( x )[ ξ x ].   If,   for   every  

[Page 62]

x   ∈ M   and   every   ξ x , ζ x ∈   T x M ,   the   expression   g ( ξ , ζ )   does   not depend   x x x on   x   ∈   π − 1 ( x ),   then  

$$
g _ { x } ( \xi _ { x } , \zeta _ { x } ) \colon = \bar { g } _ { \overline { x } } ( \bar { \xi } _ { \overline { x } } , \bar { \zeta } _ { \overline { x } } )
$$

deﬁnes   a   Riemannian   metric   on   M .   Endowed   with   this   Riemannian   metric,   M   is   called   a   Riemannian quotient manifold of   M ,   and   the   natural   projection   π   :   M → M   is   a   Riemannian submersion .   (In   other   words,   a   Riemannian   submersion   is   a   submersion   of   Riemannian   manifolds   such   that   D π   preserves   inner   products   of   vectors   normal   to   ﬁbers.)  

Riemannian   quotient   manifolds   are   interesting   because   several   diﬀerential   objects   on   the   quotient   manifold   can   be   represented   by   corresponding   objects   in   the   structure   space   in   a   natural   manner   (see   in   particular   Section   5.3.4).   Notably,   if   f   is   a   function   on   M   that   induces   a   function   f   on   M ,   then   one   has  

$$
\overline { \text {grad} } f _ { \overline { x } } = \text {grad} \, \bar { f } ( \overline { x } ) .
$$

Note   that   grad   f ( x )   belongs   to   the   horizontal   space:   since   f   is   constant   on   each   equivalence   class,   it   follows   that   g x (grad   f ( x ) , ξ )   ≡   D f   ( x ) [ ξ ] = 0   for   all   vertical   vectors   ξ ,   hence   grad   f ( x )   is   orthogonal   to   the   vertical   space.   h v

We   use   the   notation   P ξ x and   P ξ x for   the   projection   of   ξ x ∈   T x M   onto   x x H x and   V x .  

# Example 3.6.3 Projective   space   n − 1

On the projective space RP , the deﬁnition

$$
\langle \xi , \eta _ { x \mathbb { R } } \colon = \frac { 1 } { x ^ { T } x } \bar { \xi } _ { x } ^ { T } \bar { \eta } _ { x }
$$

turns the canonical projection π   :   R ∗   n RP n − 1 into a Riemannian submer→ sion.

# Example 3.6.4 Grassmann   manifolds  

We show that the Grassmann manifold Grass( p, n ) =   R n ∗ × p / GL p admits a structure of a Riemannian quotient manifold when R n ∗ × p is endowed with the Riemannian metric  

$$
\bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) & = \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Z _ { 1 } ^ { T } Z _ { 2 } \right ) . \\ \intertext { s p a c e \ a t Y \ i s \ b y \ d e f i n i t i o n \ t h e \ t a n g e n t \ s p a c e \ t o } ) = \{ Y M \cdot M \in \mathbb { P } ^ { p \times p } \} _ { \ } w h i c h \ w i l d s
$$

The vertical space at Y   is by deﬁnition the tangent space to the equivalence class π − 1 ( π ( Y   ))   =   { Y M   :   M   ∈   R p ∗ × p } , which yields R p × p

$$
\mathcal { V } _ { Y } = \{ Y M \colon M \in \mathbb { R } ^ { p \times p } \} . \\
$$

The horizontal space at Y   is then deﬁned as the orthogonal complement of the vertical space with respect to the metric g . This yields

$$
\mathcal { H } _ { Y } = \{ Z \in \mathbb { R } ^ { n \times p } \colon Y ^ { T } Z = 0 \} , \\ \quad \\ \quad ; \quad \dot { X } \colon = \{ Z \in \mathbb { R } ^ { n \times p } \colon Y ^ { T } Z = 0 \} ,
$$

and the orthogonal projection onto the horizontal space is given by

$$
P _ { Y } ^ { h } Z = ( I - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } ) Z .
$$

[Page 63]

![In this image, we can see a diagram with a diagram of a triangle and a line. We can also see a point labeled as W and a point labeled as M.](<images/imageFile13.png>)

W  

GL p  

p

ξ

/diamondmath

W

M

Y  

GL p  

W  

M  

p

ξ

/diamondmath

W

S

W

W  

σ

(span( Y

Y

))  

W

Y  

0  

Figure 3.10 Grass( p, n ) is shown as the quotient R n ∗ × p / GL p for the case p = 1, n = 2. Each point, the origin excepted, is an element of R n ∗ × p = R 2   − { 0 } . Each line is an equivalence class of elements of R n ∗ × p that have the same span. So each line through the origin corresponds to an element of Grass( p, n ). The aﬃne subspace S W is an aﬃne cross section as deﬁned in (3.43). The relation (3.42) satisﬁed by the horizontal lift ξ of a tangent vector ξ ∈ T W Grass( p, n ) is also illustrated. This ﬁgure can help to provide insight into the general case, however, one nonetheless has to be careful when drawing conclusions from it. For example, in general there does not exist a submanifold of R n × p that is orthogonal to the ﬁbers Y GL p at each point, although it is obviously the case for p = 1 (any centered sphere in R n will do).

Given ξ   ∈   T span( Y ) Grass( p, n ) , there exists a unique horizontal lift ξ Y ∈   T Y R n ∗ × p satisfying

$$
D \pi ( Y ) [ \bar { \xi } _ { Y } ] = \xi .
$$

In order to show that Grass( p, n )   admits a structure of a Riemannian quotient manifold of ( R n ∗ × p , g ) , we have to show that

$$
\bar { g } ( \bar { \xi } _ { Y M } , \bar { \zeta } _ { Y M } ) = \bar { g } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } )
$$

for all M   ∈   R p ∗ × p . This relies on the following result. n × p

Proposition   3.6.1   Given Y   ∈   R ∗ and ξ   ∈   T span( Y ) Grass( p, n ) , we have

$$
\bar { \xi } _ { Y M } = \bar { \xi } _ { Y } \cdot M & & ( 3 . 4 2 ) \\
$$

for all M   ∈   R p ∗ × p , where the center dot (usually omitted) denotes matrix multiplication.

Proof. Let W   ∈   R n ∗ × p . Let U W =   { span( Y   ) :   W   T Y   invertible } . Notice that U W is the set of all the p -dimensional subspaces Y   of R n that do not contain any direction orthogonal to span( W   ) . Consider the mapping

$$
\sigma _ { W } \colon \mathcal { U } _ { W } \to \mathbb { R } _ { * } ^ { n \times p } \colon \text {span} ( Y ) \mapsto Y ( W ^ { T } Y ) ^ { - 1 } W ^ { T } W ;
$$

[Page 64]

see Figure 3.10. One has π ( σ W ( Y ))   =   span( σ W ( Y ))   =   Y   for all Y   ∈ U W ; i.e., σ W is a right inverse of π . Consequently, D π ( σ W ( Y ))   D σ W ( Y )   =   id . ◦ Moreover, the range of σ W is

$$
\mathcal { S } _ { W } \coloneqq \{ Y \in \mathbb { R } _ { * } ^ { n \times p } \colon W ^ { T } ( Y - W ) = 0 \} , \\ \intertext { s u m t h s c r { S } _ { W } \colon = \{ Y \in \mathbb { R } _ { * } ^ { n \times p } \colon W ^ { T } ( Y - W ) = 0 \} , }
$$

from which it follows that the range of D σ W ( Y ) =   { Z   ∈   R n × p :   W   T Z   =   0 }   =   H W . In conclusion,

$$
D \sigma _ { W } ( \mathcal { W } ) [ \xi ] & = \bar { \xi } _ { W } . \\ \\ \zeta _ { W } ( \zeta _ { W } ) & = 1 - \pi n \times n
$$

Now, σ W M ( Y ) =   σ W ( Y ) M   for all M   ∈   R p ∗ × p and all Y ∈ U W . It follows that

$$
\bar { \xi } _ { W M } & = D \sigma _ { W M } ( \mathcal { W } ) [ \xi ] = D ( \sigma _ { W } \cdot M ) ( \mathcal { W } ) [ \xi ] = D \sigma _ { W } ( \mathcal { W } ) [ \xi ] \cdot M = \bar { \xi } _ { W } \cdot M , \\ \text {where the center dot denotes the matrix multiplication.} & \quad \Box
$$

where the center dot denotes the matrix multiplication.

Using this result, we have

$$
U s n g \text { this result, we have} \\ \bar { g } _ { Y M } ( \bar { \xi } _ { Y M } , \bar { \zeta } _ { Y M } ) & = \bar { g } _ { Y M } ( \bar { \xi } _ { Y } M , \bar { \zeta } _ { Y } M ) \\ & = \text {tr} \left ( ( ( Y M ) ^ { T } Y M ) ^ { - 1 } ( \bar { \xi } _ { Y } M ) ^ { T } ( \bar { \zeta } _ { Y } M ) \right ) \\ & = \text {tr} \left ( M ^ { - 1 } ( Y ^ { T } Y ) ^ { - 1 } M ^ { - T } M ^ { \bar { T } } \bar { \xi } _ { Y } ^ { T } \bar { \zeta } _ { Y } M \right ) \\ & = \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } \bar { \xi } _ { Y } ^ { T } \bar { \zeta } _ { Y } \right ) \\ & = \bar { g } _ { Y } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } ) . \\ \text {This shows that Grass(p,n), endowed with the Riemannian metric}
$$

This shows that Grass( p, n ) , endowed with the Riemannian metric

$$
g _ { \text {span} ( Y ) } ( \xi , \zeta ) \colon = \bar { g } _ { Y } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } ) ,
$$

is a Riemannian quotient manifold of ( R n ∗ × p , g ) . In other words, the canonical projection π   :   R n ∗ × p Grass( p, n )   is a Riemannian submersion from → ( R n ∗ × p , g )   to (Grass( p, n ) , g ) .

# 3.7 NOTES AND REFERENCES

Differential geometry textbooks that we have referred to when writing this book include Abraham et al. [AMR88], Boothby [Boo75], Brickell and Clark [BC70], do Carmo [dC92], Kobayashi and Nomizu [KN63], O'Neill [O'N83], Sakai [Sak96], and Warner [War83]. Some material was also borrowed from the course notes of M. De Wilde at the University of Li` ege [DW92]. Do Carmo [dC92] is well suited for engineers, as it does not assume any background in abstract topology; the prequel [dC76] on the differential geometry of curves and surfaces makes the introduction even smoother. Abraham et al. [AMR88] and Brickell and Clark [BC70] cover global analysis questions (submanifolds, quotient manifolds) at an introductory level. Brickell and Clark [BC70] has a detailed treatment of the topology of manifolds. O'Neill [O'N83] is an excellent reference for Riemannian connections of submanifolds and quotient manifolds (Riemannian submersions). Boothby [Boo75] provides an excellent introduction to differential geometry with a perspective on Lie theory, and Warner [War83] covers more advanced material in this direction. Other references on differential geometry include the classic works of Kobayashi and Nomizu [KN63], Helgason [Hel78], and Spivak [Spi70]. We also mention Darling [Dar94], which introduces abstract manifold theory only after covering Euclidean spaces and their submanifolds.

[Page 65]

Several   equivalent   ways   of   deﬁning   a   manifold   can   be   found   in   the   literature.   The   deﬁnition   in   do   Carmo   [dC92]   is   based   on   local   parameterizations.   O’Neill   [O’N83,   p.   22]   points   out   that   for   a   Hausdorﬀ   manifold   (with   countably   many   components),   being   second-countable   is   equivalent   to   being   paracompact.   (In   abstract   topology,   a   space   X   is   paracompact if   every   open   covering   of   X   has   a   locally   ﬁnite   open   reﬁnement   that   covers   X .)   A   diﬀerentiable   manifold   M   admits   a   partition   of   unity   if   and   only   if   it   is   paracompact   [BC70,   Th.   3.4.4].   The   material   on   the   existence   and   uniqueness   of   atlases   has   come   chieﬂy   from   Brickell   and   Clark   [BC70].   A   function   with   constant   rank   on   its   domain   is   called   a   subimmersion in   most   textbooks.   The   terms   “canonical   immersion”   and   “canonical   submersion”   have   been   borrowed   from   Guillemin   and   Pollack   [GP74,   p.   14].   The   manifold   topology   of   an   immersed   submanifold   is   always   ﬁner   than   its   topology   as   a   subspace   [BC70],   but   they   need   not   be   the   same   topology.   (When   they   are,   the   submanifold   is   called   embedded .)   Examples   of   subsets   of   a   manifold   that   do   not   admit   a   submanifold   structure,   and   examples   of   immersed   submanifolds   that   are   not   embedded,   can   be   found   in   most   textbooks   on   diﬀerential   geometry,   such   as   do   Carmo   [dC92].   Proposition   3.3.1,   on   the   uniqueness   of   embedded   submanifold   structures,   is   proven   in   Brickell   and   Clark   [BC70]   and   O’Neill   [O’N83].   Proposition   3.3.3   can   be   found   in   several   textbooks   without   the   condition   d 1 > d 2 .   In   the   case   where   d 1 =   d 2 ,   F   − 1 ( y )   is   a   discrete   set   of   points   [BC70,   Prop.   6.2.1].   In   several   references,   embedded   submanifolds   are   called   regular submanifolds or   simply   submanifolds .   Proposition   3.3.2,   on   coordinate   slices,   is   sometimes   used   to   deﬁne   the   notion   of   an   embedded   submanifold,   such   as   in   Abraham   et al. [AMR88].   Our   deﬁnition   of   a   regular   equivalence   relation   follows   that   of   Abraham   et al. [AMR88].   The   characterization   of   quotient   manifolds   in   Proposition   3.4.2   can   be   found   in   Abraham   et al. [AMR88,   p.   208].   A   shorter   proof   of   Proposition   3.4.6   (showing   that   R n ∗ × p / GL p admits   a   structure   of   quotient   manifold,   the   Grassmann   manifold)   can   be   given   using   the   theory   of   homogeneous   spaces,   see   Boothby   [Boo75]   or   Warner   [War83].  

Most   textbooks   deﬁne   tangent   vectors   as   derivations.   Do   Carmo   [dC92]   introduces   tangent   vectors   to   curves,   as   in   Section   3.5.1.   O’Neill   [O’N83]   proposes   both   deﬁnitions.   A   tangent   vector   at   a   point   x   of   a   manifold   can   also   be   deﬁned   as   an   equivalence   class   of   all   curves   that   realize   the   same   derivation:   γ 1 ∼   γ 2 if   and   only   if,   in   a   chart   ( U, ϕ )   around   x   =   γ 1 (0)   =   γ 2 (0),   we   have   ( ϕ γ 1 )   ′   (0)   =   ( ϕ γ 2 )   ′   (0).   This   notion   does   not   depend   on   the   chart   ◦ ◦  

[Page 66]

since,   if   ( V , ψ )   is   another   chart   around   x ,   then     ′       − 1   ′      

$$
( \psi \circ \gamma ) ^ { \prime } ( 0 ) & = ( \psi \circ \varphi ^ { - 1 } ) ^ { \prime } ( \varphi ( m ) ) \cdot ( \varphi \circ \gamma ) ^ { \prime } ( 0 ) . \\ \\ 1 & \quad + 1 \quad f r a c { 1 } { 0 } ( \varphi ) .
$$

This   is   the   approach   taken,   for   example,   by   Gallot   et al. [GHL90].  

The   notation   D F   ( x ) [ ξ ]   is   not   standard.   Most   textbooks   use   dF x ξ   or   F ∗ x ξ .   Our   notation   is   slightly   less   compact   but   makes   it   easier   to   distinguish   the   three   elements   F   ,   x ,   and   ξ   of   the   expression   and   has   proved   more   ﬂexible   when   undertaking   explicit   computations   involving   matrix   manifolds.  

An   alternative   way   to   deﬁne   smoothness   of   a   vector   ﬁeld   is   to   require   that   the   function   ξf   be   smooth   for   every   f   ∈   F ( M );   see   O’Neill   [O’N83].   In   the   parlance   of   abstract   algebra,   the   set   F ( M )   of   all   smooth   real-valued   functions   on   M ,   endowed   with   the   usual   operations   of   addition   and   multiplication,   is   a   commutative ring ,   and   the   set   X ( M )   of   vector   ﬁelds   is   a   module over   F ( M )   [O’N83].   Formula   (3.26)   for   the   tangent   space   to   the   orthogonal   group   can   also   be   obtained   by   treating   O n as   a   Lie   group:   the   operation   of   left   multiplication   by   U ,   L U :   X    →   U X ,   sends   the   neutral   element   I   to   U ,   and   the   diﬀerential   of   L U at   I   sends   T I O n =   o ( n ) =   S skew ( n )   to   U S skew ( n );   see,   e.g.,   Boothby   [Boo75]   or   Warner   [War83].   For   a   proof   that   the   Riemannian   distance   satisﬁes   the   three   axioms   of   a   metric,   see   O’Neill   [O’N83,   Prop.   5.18].   The   axiom   that   fails   to   hold   in   general   for   non-Hausdorﬀ   manifolds   is   that   dist( x, y )   =   0   if   and   only   if   x   =   y .   An   example   can   be   constructed   from   the   material   in   Section   4.3.2.   Riemannian   submersions   are   covered   in   some   detail   in   Cheeger   and   Ebin   [CE75],   do   Carmo   [dC92],   Klingenberg   [Kli82],   O’Neill   [O’N83],   and   Sakai   [Sak96].   The   term   “Riemannian   quotient   manifold”   is   new.  

The   Riemannian   metric   given   in   (3.44)   is   the   essentially   unique   rotationinvariant   Riemannian   metric   on   the   Grassmann   manifold   [Lei61,   AMS04].   More   information   on   Grassmann   manifolds   can   be   found   in   Ferrer   et al. [FGP94],   Edelman   et al. [EAS98],   Absil   et al. [AMS04],   and   references   therein.  

In   order   to   deﬁne   the   steepest-descent   direction   of   a   real-valued   function   f   on   a   manifold   M ,   it   is   enough   to   endow   the   tangent   spaces   to   M   with   a   norm.   Under   smoothness   assumptions,   this   turns   M   into   a   Finsler manifold .   Finsler   manifolds   have   received   little   attention   in   the   literature   in   comparison   with   the   more   restrictive   notion   of   Riemannian   manifolds.   For   recent   work   on   Finsler   manifolds,   see   Bao   et al. [BCS00].  

[Page 67]

# Line-Search   Algorithms   on   Manifolds  

Line-search   methods   in   R n are   based   on   the   update   formula  

$$
x _ { k + 1 } = x _ { k } + t _ { k } \eta _ { k } ,
$$

where   η k ∈   R n is   the   search direction and   t k ∈   R   is   the   step size .   The   goal   of   this   chapter   is   to   develop   an   analogous   theory   for   optimization   problems   posed   on   nonlinear   manifolds.  

The   proposed   generalization   of   (4.1)   to   a   manifold   M   consists   of   selecting   η k as   a   tangent   vector   to   M   at   x k and   performing   a   search   along   a   curve   in   M   whose   tangent   vector   at   t   =   0   is   η k .   The   selection   of   the   curve   relies   on   the   concept   of   retraction,   introduced   in   Section   4.1.   The   choice   of   a   computationally   eﬃcient   retraction   is   an   important   decision   in   the   design   of   high-performance   numerical   algorithms   on   nonlinear   manifolds.   Several   practical   examples   are   given   for   the   matrix   manifolds   associated   with   the   main   examples   of   interest   considered   in   this   book.  

This   chapter   also   provides   the   convergence   theory   of   line-search   algorithms   deﬁned   on   Riemannian   manifolds.   Several   example   applications   related   to   the   eigenvalue   problem   are   presented.  

# 4.1 RETRACTIONS

Conceptually,   the   simplest   approach   to   optimizing   a   diﬀerentiable   function   is   to   continuously   translate   a   test   point   x ( t )   in   the   direction   of   steepest   descent,   − grad   f ( x ),   on   the   constraint   set   until   one   reaches   a   point   where   the   gradient   vanishes.   Points   x   where   grad   f ( x )   =   0   are   called   stationary points or   critical points of   f .   A   numerical   implementation   of   the   continuous   gradient   descent   approach   requires   the   construction   of   a   curve   γ   such   that   γ ˙ ( t ) =   − grad   f ( γ ( t ))   for   all   t .   Except   in   very   special   circumstances,   the   construction   of   such   a   curve   using   numerical   methods   is   impractical.   The   closest   numerical   analogy   is   the   class   of   optimization   methods   that   use   line-search procedures,   namely,   iterative   algorithms   that,   given   a   point   x ,   compute   a   descent   direction   η   :=   − grad   f ( x )   (or   some   approximation   of   the   gradient)   and   move   in   the   direction   of   η   until   a   “reasonable”   decrease   in   f   is   found.   In   R n ,   the   concept   of   moving   in   the   direction   of   a   vector   is   straightforward.   On   a   manifold,   the   notion   of   moving   in   the   direction   of   a   tangent   vector,   while   staying   on   the   manifold,   is   generalized   by   the   notion   of   a   retraction   mapping.  

[Page 68]

Conceptually,   a   retraction   R   at   x ,   denoted   by   R x ,   is   a   mapping   from   T x M   to   M   with   a   local   rigidity   condition   that   preserves   gradients   at   x ;   see   Figure   4.1.  

![In the image, we can see a diagram of a geometric figure. The diagram consists of two parallel lines, a transversal, and two angles. Let's break down the information given in the image: 1. **Parallel Lines**: - The diagram shows two parallel lines, labeled as \(M\) and \(T\). - The transversal is drawn from \(M\) to \(T\). 2. **Angles**: - The angles in the diagram are labeled as \(T\) and \(M\). - The angles are marked as \(T\) and \(M\). 3. **Intersection Point**: - The intersection point of the lines \(M\) and \(T\) is marked as \(R\). - The intersection point is located at the bottom of the diagram. 4. **Angles and Their Properties**: - The angles](<images/imageFile14.png>)

M  

T x

x  

ξ  

Rx

ξ

(

)

M  

Figure 4.1 Retraction.

Deﬁnition 4.1.1 (retraction) A retraction   on a manifold M   is a smooth mapping R   from the tangent bundle T   M   onto M   with the following properties. Let R x denote the restriction of R   to T x M .  

- (i) R x (0 x ) = x ,  where 0 x denotes  the  zero  element  of T x M .
- (ii) With  the  canonical  identification T 0 x satisfies T x M/similarequal T x M , R x


$$
D R _ { x } ( 0 _ { x } ) = \text {id} _ { T _ { x } \mathcal { M } } ,
$$

where id T x M   denotes the identity mapping on T x M .

We   generally   assume   that   the   domain   of   R   is   the   whole   tangent   bundle   T   M .   This   property   holds   for   all   practical   retractions   considered   in   this   book.  

Concerning   condition   (4.2),   notice   that,   since   R x is   a   mapping   from   T x M to   M   sending   0 x to   x ,   it   follows   that   D R x (0 x )   is   a   mapping   from   T 0 x ( T x M )   to   T x M   (see   Section   3.5.6).   Since   T x M   is   a   vector   space,   there   is   a   natural   identiﬁcation   T 0 x ( T x M )   ≃   T x M   (see   Section   3.5.2).   We   refer   to   the   condition   D R x (0 x )   =   id T x M   as   the   local rigidity condition.   Equivalently,   for   every   tangent   vector   ξ   in   T x M ,   the   curve   γ ξ :   t    →   R x ( tξ )   satisﬁes   ˙ γ ξ (0)   =   ξ .   Moving   along   this   curve   γ ξ is   thought   of   as   moving   in   the   direction   ξ   while   constrained   to   the   manifold   M .   Besides   turning   elements   of   T x M   into   points   of   M ,   a   second   important  

purpose   of   a   retraction   R x is   to   transform   cost   functions   deﬁned   in   a   neighborhood   of   x   ∈ M   into   cost   functions   deﬁned   on   the   vector   space   T x M .   Speciﬁcally,   given   a   real-valued   function   f   on   a   manifold   M   equipped   with   a   retraction   R ,   we   let   f   =   f R   denote   the   pullback of   f   through   R .   For   ◦   x   ∈ M ,   we   let   f x =   f R x (4.3)   ◦  

$$
\widehat { f } _ { x } = f \circ R _ { x }
$$

[Page 69]

    denote   the   restriction   of   f   to   T x M .   Note   that   f x is   a   real-valued   function   on   a   vector   space.   Observe   that   because   of   the   local   rigidity   condition   (4.2),   we   have   (with   the   canonical   identiﬁcation   (3.11))   D   f   x (0 x ) = D f ( x ).   If   M   is   endowed   with   a   Riemannian   metric   (and   thus   T x M   with   an   inner   product),   we   have  

grad   f   x (0 x )   =   grad   f ( x ) .   (4.4)   All   the   main   examples   that   are   considered   in   this   book   (and   most   matrix   manifolds   of   interest)   admit   a   Riemannian   metric.   Every   manifold   that   admits   a   Riemannian   metric   also   admits   a   retraction   deﬁned   by   the   Riemannian exponential mapping (see   Section   5.4   for   details).   The   domain   of   the   exponential   mapping   is   not   necessarily   the   whole   T   M .   When   it   is,   the   Riemannian   manifold   is   called   complete .   The   Stiefel   and   Grassmann   manifolds,   endowed   with   the   Riemannian   metrics   deﬁned   in   Section   3.6,   are   complete.  

The   Riemannian   exponential   mapping   is,   in   the   geometric   sense,   the   most   natural   retraction   to   use   on   a   Riemannian   manifold   and   featured   heavily   in   the   early   literature   on   the   development   of   numerical   algorithms   on   Riemannian   manifolds.   Unfortunately,   the   Riemannian   exponential   mapping   is   itself   deﬁned   as   the   solution   of   a   nonlinear   ordinary   diﬀerential   equation   that,   in   general,   poses   signiﬁcant   numerical   challenges   to   compute   cheaply.   In   most   cases   of   interest   in   this   book,   the   solution   of   the   Riemannian   exponential   can   be   expressed   in   terms   of   classical   analytic   functions   with   matrix   arguments.   However,   the   evaluation   of   matrix   analytic   functions   is   also   a   challenging   problem   and   usually   computationally   intensive   to   solve.   Indeed,   computing   the   exponential   may   turn   out   to   be   more   diﬃcult   than   the   original   Riemannian   optimization   problem   under   consideration   (see   Section   7.5.2   for   an   example).   These   drawbacks   are   an   invitation   to   consider   alternatives   in   the   form   of   approximations   to   the   exponential   that   are   computationally   cheap   without   jeopardizing   the   convergence   properties   of   the   optimization   schemes.   Retractions   provide   a   framework   for   analyzing   such   alternatives.   All   the   algorithms   in   this   book   make   use   of   retractions   in   one   form   or   another,   and   the   convergence   analysis   is   carried   out   for   general   retractions.  

In   the   remainder   of   this   Section   4.1,   we   show   how   several   structures   (embedded   submanifold,   quotient   manifold)   and   mathematical   objects   (local   coordinates,   projections,   factorizations)   can   be   exploited   to   deﬁne   retractions.  

# 4.1.1 Retractions on embedded submanifolds

Let   M   be   an   embedded   submanifold   of   a   vector   space   E .   Recall   that   T x M can   be   viewed   as   a   linear   subspace   of   T x E   (Section   3.5.7)   which   itself   can   be   identiﬁed   with   E   (Section   3.5.2).   This   allows   us,   slightly   abusing   notation,   to   consider   the   sum   x   +   ξ   of   a   point   x   of   M ,   viewed   as   an   element   of   E ,   and   a   tangent   vector   ξ   ∈   T x M ,   viewed   as   an   element   of   T x E ≃ E .   In   this   setting,   it   is   tempting   to   deﬁne   a   retraction   along   the   following   lines.   Given   x   in   M and   ξ   ∈   T x M ,   compute   R x ( ξ )   by  

[Page 70]

1.   moving   along   ξ   to   get   the   point   x   +   ξ   in   the   linear   embedding   space;  

'projecting' the point x + ξ back to the manifold M .

  into   a   welldeﬁned   retraction   and   (ii)   is   computationally   eﬃcient.   In   the   embedded   submanifolds   of   interest   in   this   book,   as   well   as   in   several   other   cases,   the   second   step   can   be   based   on   matrix   decompositions.   Examples   of   such   decompositions   include   QR   factorization   and   polar   decomposition.   The   purpose   of   the   present   section   is   to   develop   a   general   theory   of   decomposition-based   retractions.   With   this   theory   at   hand,   it   will   be   straightforward   to   show   that   several   mappings   constructed   along   the   above   lines   are   well-deﬁned   retractions.  

Let   M   be   an   embedded   manifold   of   a   vector   space   E   and   let   N   be   an   abstract   manifold   such   that   dim( M )   +   dim( N   )   =   dim( E ).   Assume   that   there   is   a   diﬀeomorphism  

$$
\phi \colon \mathcal { M } \times \mathcal { N } \to \mathcal { E } _ { * } \colon ( F , G ) \mapsto \phi ( F , G ) , \\ \intertext { b o n o n s u b { c o t } f $ \mathcal { E } ( t h u s $ \mathcal { E } _ { * } $ i s o n o n o p h u m o n i f o l } }
$$

where   E ∗   is   an   open   subset   of   E   (thus   E ∗   is   an   open   submanifold   of   E ),   with   a   neutral   element   I   ∈ N   satisfying   φ ( F, I ) =   F,   F   .  

$$
\phi ( F , I ) = F , \ \forall F \in \mathcal { M } . \\ \int \lim i t s _ { \ } p a r { ( F , I ) } = F , \ \int \lim i t s _ { \ } p a r { ( F , I ) } = F ,
$$

(The   letter   I   is   chosen   in   anticipation   that   the   neutral   element   will   be   the   identity   matrix   of   a   matrix   manifold   N   in   cases   of   interest.)  

Proposition 4.1.2 Under the above assumptions on φ , the mapping

$$
R _ { X } ( \xi ) \colon = \pi _ { 1 } ( \phi ^ { - 1 } ( X + \xi ) ) ,
$$

where π 1 :   M × N   → M   : ( F, G )    →   F   is the projection onto the ﬁrst component, deﬁnes a retraction on M .                              

Proof. Since E ∗   is open, it follows that X + ξ belongs to E ∗   for all ξ in some   neighborhood   of   0 X .   Since   φ − 1 is   deﬁned   on   the   whole   E ∗ ,   it   follows   that   R X ( ξ )   is   deﬁned   for   all   ξ   in   a   neighborhood   of   the   origin   of   T X M .   Smoothness   of   R   and   the   property   R X (0 X ) =   X   are   direct.   For   the   local   rigidity   property,   ﬁrst   note   that   for   all   ξ   ∈   T X M ,   we   have   D φ ( X, I )[ ξ ] = D φ ( X, I )[( ξ,   0)]   =   ξ.  

$$
D _ { 1 } \phi ( X , I ) [ \xi ] = D \phi ( X , I ) [ ( \xi , 0 ) ] = \xi .
$$

Since π 1 ◦ φ -1 ( φ ( F, I )) = F , it follows that, for all ξ ∈ T X M ,

ξ = D( π 1 φ -1 )( φ ( X,I )) [D 1 φ ( X,I )[ ξ ]] = D( π 1 φ -1 )( X )[ ξ ] = D R X (0 X )[ ξ ] , ◦ ◦ which proves the claim that R X is a retraction. /square

Example 4.1.1 Retraction   on   the   sphere   S n − 1 n − 1

Let M   =   S , let N   =   { x   ∈   R   :   x >   0 } , and consider the mapping φ   :       R n : ( x, r )     xr.  

$$
\phi \colon \mathcal { M } \times \mathcal { N } \to \mathbb { R } _ { * } ^ { n } \colon ( x , r ) \mapsto x r . \\ \intertext { a r d t o w i f w t h a t }
$$

It is straightforward to verify that φ   is a diﬀeomorphism. Proposition 4.1.2 yields the retraction

$$
R _ { x } ( \xi ) = \frac { x + \xi } { \| x + \xi \| } ,
$$

[Page 71]

deﬁned for all ξ   ∈   T x S n − 1 . Note that R x ( ξ )   is the point of S n − 1 that minimizes the distance to x   +   ξ .

# Example 4.1.2 Retraction   on   the   orthogonal   group  

Let M   =   O n be the orthogonal group. The QR   decomposition   of a matrix A   ∈   R n × n is the decomposition of A   as A   =   QR , where Q   belongs to O n and ∗   R   belongs to S upp+ ( n ) , the set of all upper triangular matrices with strictly positive diagonal elements. The inverse of QR decomposition is the mapping

$$
\phi \colon O _ { n } \times S _ { \text {upp} ^ { + } } ( n ) \to \mathbb { R } _ { * } ^ { n \times n } \colon ( Q , R ) \mapsto Q R . \\ \intertext { t e f a } \phi \colon = \pi _ { + } \circ \phi ^ { - 1 } \ d e n o t e { \ t h e } \ m a m p i n a { \ t h o t } \ s e n d e { \ a } { \ m a t r i x } \ t o { \ t h e } \ O
$$

We let qf   :=   π 1 φ − 1 denote the mapping that sends a matrix to the Q ◦ factor of its QR decomposition. The mapping qf   can be computed using the Gram-Schmidt   orthonormalization .

We have to check that φ   satisﬁes all the assumptions of Proposition 4.1.2. The identity matrix is the neutral element: φ ( Q, I ) =   Q   for all Q   ∈   O n . It follows from the existence and uniqueness properties of the QR decomposition that φ   is bijective. The mapping φ   is smooth since it is the restriction of a smooth map (matrix product) to a submanifold. Concerning φ − 1 , notice that its ﬁrst matrix component Q   is obtained by a Gram-Schmidt process, which is C ∞   on the set of full-rank matrices. Since the second component R   is obtained as Q − 1 M   , it follows that φ − 1 is C ∞ . In conclusion, the assumptions of Proposition 4.1.2 hold for (4.5) , and consequently,

$$
R _ { X } ( X \Omega ) \colon = q f ( X + X \Omega ) = q f ( X ( I + \Omega ) ) = X q f ( I + \Omega )
$$

is a retraction on the orthogonal group O n .

A second possibility is to consider the polar   decomposition   of a matrix A   =   QP   , where Q   ∈   O n and P   ∈ S sym+ ( n ) , the set of all symmetric positivedeﬁnite matrices of size n . The inverse of polar decomposition is a mapping

$$
\phi \colon O _ { n } \times \mathcal { S } _ { s y m + } ( n ) & \to \mathbb { R } _ { * } ^ { n \times n } \colon ( Q , P ) \mapsto Q P . \\ \phi ^ { - 1 } ( \ A ) - ( \ A ( \ A ^ { T } \ A ) ^ { - 1 / 2 } \ ( \ A ^ { T } \ A ) ^ { 1 / 2 } ) \ \ T h i _ { \ } e h o w _ { \ } t h a t _ { \ } \phi _ { \ } i s
$$

We have φ − 1 ( A ) = ( A ( A T A ) − 1 / 2 ,   ( A T A ) 1 / 2 ) . This shows that φ   is a diﬀeomorphism, and thus

$$
R _ { X } ( X \Omega ) & = X ( I + \Omega ) ( ( X ( I + \Omega ) ) ^ { T } X ( I + \Omega ) ) ^ { - 1 / 2 } \\ & = X ( I + \Omega ) ( I - \Omega ^ { 2 } ) ^ { - 1 / 2 } \\ \intertext { s a r t r a c t i o n $ o n $ O _ { n } \colon $ C o m p u t i n q $ h i s $ r e t r a c t i o n $ requires an e i q e n v a l u e $ d e $ }
$$

is a retraction on O n . Computing this retraction requires an eigenvalue decomposition of the n   ×   n   symmetric matrix ( I   −   Ω 2 ) . Note that it does not make sense to use this retraction in the context of an eigenvalue algorithm on O n since the computational cost of computing a single retraction is comparable to that for solving the original optimization problem.

A third possibility is to use Givens   rotations . For an n × n   skew-symmetric matrix Ω , let Giv(Ω)   =     1 ≤ i<j ≤ n G ( i, j,   Ω ij ) , where the order of multiplication is any ﬁxed order and where G ( i, j, θ )   is the Givens rotation of angle θ   in the ( i, j )   plane, namely, G ( i, j, θ )   is the identity matrix with the substitutions e T i G ( i, j, θ ) e i =   e T j G ( i, j, θ ) e j =   cos( θ )   and e T i G ( i, j, θ ) e j =   − e j T G ( i, j, θ ) e i =   sin( θ ) . Then the mapping R   :   T O n →   O n deﬁned by R ( X Ω)   =   X   Giv(Ω)  

$$
R _ { X } ( X \Omega ) = X \text { Giv} ( \Omega )
$$

[Page 72]

is a retraction on O n .

Another retraction on O n , based on the Cayley   transform , is given by

$$
R _ { X } ( X \Omega ) = X ( I - \frac { 1 } { 2 } \Omega ) ^ { - 1 } ( I + \frac { 1 } { 2 } \Omega ) . \\ \intertext { a t h e m a t e r i a l i n v e c h a p t e r } \intertext { s u n t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t h a t
$$

Anticipating the material in Chapter 5, we point out that the Riemannian exponential mapping on O n (viewed as a Riemannian submanifold of R n × n ) is given by

$$
E x p _ { X } ( X \Omega ) = X \exp ( \Omega ) ,
$$

Exp X ( X Ω)   =   X   exp(Ω) ,   1 where exp   denotes the matrix exponential deﬁned by exp(Ω)   :=     ∞   Ω i . i =0 i ! Note that Riemannian exponential mappings are always retractions (Proposition 5.4.1). Algorithms for accurately evaluating the exponential have a numerical cost at best similar to those for evaluating (4.6) . However, there are several computationally eﬃcient Lie group-based algorithms for approximating the exponential that ﬁt the deﬁnition of a retraction (see pointers in Notes and References).

# Example 4.1.3 Retraction   on   the   Stiefel   manifold   n × p

Consider the Stiefel manifold St( p, n ) =   { X   ∈   R :   X T X   =   I p } . The retraction based on the polar decomposition is

$$
R _ { X } ( \xi ) = ( X + \xi ) ( I _ { p } + \xi ^ { T } \xi ) ^ { - 1 / 2 } ,
$$

where we have used the fact that ξ , as an element of T X St( p, n ) , satisﬁes X T ξ   +   ξ T X   = 0 . When p   is small, the numerical cost of evaluating (4.7)   is reasonable since it involves the eigenvalue decomposition of the small p   ×   p   matrix ( I p +   ξ T ξ ) − 1 / 2 along with matrix linear algebra operations that require only O ( np 2 )   additions and multiplications.

Much as in the case of the orthogonal group, an alternative to choice is

(4.7)  

$$
R _ { X } ( \xi ) \coloneqq q f ( X + \xi ) ,
$$

where qf( A )   denotes the Q   factor of the decomposition of A   ∈   R n ∗ × p as A   =   QR , where Q   belongs to St( p, n )   and R   is an upper triangular n   ×   p   matrix with strictly positive diagonal elements. Computing R X ( ξ )   can be done in a ﬁnite number of basic arithmetic   operations   (addition, subtraction, multiplication, division) and square roots using, e.g., the modiﬁed GramSchmidt algorithm.

# 4.1.2 Retractions on quotient manifolds

We   now   consider   the   case   of   a   quotient   manifold   M   =   M /   ∼ .   Recall   the   notation   π   for   the   canonical   projection   and   ξ x for   the   horizontal   lift   at   x   of   a   tangent   vector   ξ   ∈   T π ( x ) M .  

Proposition 4.1.3 Let M   =   M / ∼   be a quotient manifold with a prescribed horizontal distribution. Let R   be a retraction on M   such that for all x   ∈ M   and ξ   ∈   T x M , π ( R ( ξ ))   =   π ( R ( ξ ))   (4.9)  

$$
\pi ( \overline { R } _ { \overline { x } _ { a } } ( \bar { \xi } _ { \overline { x } _ { a } } ) ) = \pi ( \overline { R } _ { \overline { x } _ { b } } ( \bar { \xi } _ { \overline { x } _ { b } } ) )
$$

[Page 73]

for all x a , x b ∈   π − 1 ( x ) . Then

$$
R _ { x } ( \xi ) \colon = \pi ( \overline { R } _ { \overline { x } } ( \bar { \xi } _ { \overline { x } } ) )
$$

deﬁnes a retraction on M .    

Proof. Equation (4.9) guarantees   that   R   is   well   deﬁned   as   a   mapping   from   T   M   to   M .   Since   R   is   a   retraction,   it   also   follows   that   the   property   R x (0 x ) =   x   is   satisﬁed.   Finally,   the   local   rigidity   condition   holds   since,   given   x   ∈ π − 1 ( x ),  

$$
D R _ { x } \left ( 0 _ { x } \right ) \left [ \eta \right ] & = D \pi ( \overline { x } ) \circ D \overline { R } _ { \overline { x } } \left ( 0 _ { \overline { x } } \right ) \left [ \bar { \eta } _ { \overline { x } } \right ] = D \pi \left ( \overline { x } \right ) \left [ \bar { \eta } _ { \overline { x } } \right ] = \eta \\ \intertext { r } \mathbb { W } _ { x } = \mathbb { T } _ { x } \mathbb { Q } _ { x } \, \mathbb { I } _ { x } \quad \mathbb { I } _ { x } \cdots \quad \mathbb { I } _ { x } + \mathbb { I } _ { x } \quad \mathbb { I } _ { x } + \mathbb { I } _ { x } \cdots \quad \mathbb { I } _ { x }
$$

for   all   η   ∈   T x M ,   by   deﬁnition   of   the   horizontal                  

lift. /square

From now on we consider the case where the   structure   space   M   is   an   open,   dense   (not   necessarily   proper)   subset   of   a   vector   space   E .   Assume   that   a   horizontal   distribution   H   has   been   selected   that   endows   every   tangent   vector   to   M   with   a   horizontal   lift.   The   natural   choice   for   R   is   then          

$$
\overline { R } _ { y } ( \zeta ) = y + \bar { \zeta } _ { y } .
$$

However,   this   choice   does   not   necessarily   satisfy   (4.9).   In   other   words,   if   x   and   y   satisfy   π ( x ) =   π ( y ),   the   property   π ( x   +   ξ x ) =   π ( y   +   ξ y )   may   fail   to   hold.   2

As   an   example,   take   the   quotient   of   R for   which   the   graphs   of   the   curves   x 1 =   a   +   a 3 x 2 2 are   equivalence   classes,   where   a   ∈   R   parameterizes   the   set   of   all   equivalence   classes.   Deﬁne   the   horizontal   distribution   as   the   constant   subspace   e 1 R .   Given   a   tangent   vector   ξ   to   the   quotient   at   the   equivalence   class   e 2 R   (corresponding   to   a   =   0),   we   obtain   that   the   horizontal   lift   ξ (0 ,x 2 ) is   a   constant   ( C,   0)   independent   of   x 2 .   It   is   clear   that   the   equivalence   class   of   (0 , x 2 ) +   ξ (0 ,x 2 ) = ( C, x 2 )   depends   on   x 2 .                                

If we further require the equivalence classes to be the orbits of a Lie group acting   linearly   on   M ,   with   a   horizontal   distribution   that   is   invariant   by   the   Lie   group   action,   then   condition   (4.9)   holds.   In   particular,   this   is   the   case   for   the   main   examples   considered   in   this   book.  

# Example 4.1.4 Retraction   on   the   projective   space   n − 1 n

Consider the real projective space RP =   R ∗   / R ∗   with the horizontal distribution deﬁned in (3.27) . A retraction can be deﬁned as

$$
R _ { \pi ( y ) } \xi = \pi ( y + \bar { \xi } _ { y } ) ,
$$

where ξ y ∈   R n is the horizontal lift of ξ   ∈   T π ( y ) RP n − 1 at y .

# Example 4.1.5 Retraction   on   the   Grassmann   manifold   n × p

Consider the Grassmann manifold Grass( p, n ) =   R ∗ / GL p with the horizontal distribution deﬁned in (3.40) . It can be checked using the homogeneity property of horizontal lifts (Proposition 3.6.1) that

$$
R _ { \text {span} ( Y ) } ( \xi ) = \text {span} ( Y + \bar { \xi } _ { Y } )
$$

is well-deﬁned. Hence (4.11)   deﬁnes a retraction on Grass( p, n ) .

[Page 74]

Note that the matrix Y   +   ξ Y is in general not orthonormal. In particular, if Y   is orthonormal, then Y   +   ξ Y is not orthonormal unless ξ   = 0 . In the scope of a numerical algorithm, in order to avoid ill-conditioning, it may be advisable to use qf     Y   +   ξ Y     instead of Y   +   ξ Y as a basis for the subspace R span( Y ) ( ξ ) .

# 4.1.3 Retractions and local coordinates*

In   this   section   it   is   shown   that   every   smooth   manifold   can   be   equipped   with   “local”   retractions   derived   from   its   coordinate   charts   and   that   every   retraction   generates   an   atlas   of   the   manifold.   These   operations,   however,   may   pose   computational   challenges.  

For   every   point   x   of   a   smooth   manifold   M ,   there   exists   a   smooth   map   µ x :   R d  →   M ,   µ x (0)   =   x ,   that   is   a   local   diﬀeomorphism   around   0   ∈   R d ;   the   map   µ x is   called   a   local parameterization around x   and   can   be   thought   of   as   the   inverse   of   a   coordinate   chart   around   x   ∈ M .   If   U   is   a   neighborhood   of   a   point   x ∗   of   M ,   and   µ   :   U ×   R d → M   is   a   smooth   map   such   that   µ ( x, z ) =   µ x ( z )   for   all   x   ∈ U   and   z   ∈   R d ,   then   { µ x } x ∈M   is   called   a   locally smooth family of parameterizations around x ∗ .   Note   that   a   locally   smooth   parameterization   µ   around   x ∗   can   be   constructed   from   a   single   chart   around   x ∗   by   deﬁning   µ x ( z ) =   ϕ − 1 ( z   +   ϕ ( x )).  

If   { µ x } x ∈M   is   a   locally   smooth   family   of   parameterizations   around   x ∗ ,   then   the   mappings  

$$
R _ { x } \colon T _ { x } \mathcal { M } \to \mathcal { M } \colon \xi & \mapsto \mu _ { x } ( D \mu _ { x } ^ { - 1 } ( x ) \left [ \xi \right ] ) \\ \mu _ { x } \colon \quad R _ { x } \ \ 1 \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad 1 \quad \cdot \quad 1 \quad \cdot \quad 1 \quad \cdot \quad 1 \quad \cdot \quad 1
$$

deﬁne   a   retraction   R   whose   domain   is   in   general   not   the   whole   T   M .   (It   is   readily   checked   that   R x satisﬁes   the   requirements   in   Deﬁnition   4.1.1.)   Conversely,   to   deﬁne   a   smooth   family   of   parameterizations   around   x ∗   from   a   retraction   R ,   we   can   select   smooth   vector   ﬁelds   ξ 1 , . . . , ξ d on   M   such   that,   for   all   x   in   a   neighborhood   of   x ∗ , ( ξ 1 ( x ) , . . . , ξ d ( x ))   forms   a   basis   of   T x M ,   and   then   deﬁne  

$$
\mu _ { x } ( u _ { 1 } , \dots , u _ { d } ) & = R _ { x } ( u _ { 1 } \xi _ { 1 } ( x ) + \cdots + u _ { d } \xi _ { d } ( x ) ) . \\ \\
$$

Note,   however,   that   such   a   basis   ξ 1 , . . . , ξ d of   vector   ﬁelds   can   in   general   be   deﬁned   only   locally.   Moreover,   producing   the   ξ ’s   in   practical   cases   may   be   tedious.   For   example,   on   the   unit   sphere   S n − 1 ,   the   set   T x S n − 1 is   a   vector   space   of   dimension   ( n   −   1)   identiﬁed   with   x ⊥   :=   { y   ∈   R n :   x T y   = 0 } ;   however,   when   n   is   large,   generating   and   storing   a   basis   of   x ⊥   is   impractical,   as   this   requires   ( n − 1)   vectors   of   n   components.   In   other   words,   even   though   the   ( n   −   1)-dimensional   vector   space   T x S n − 1 is   known   to   be   isomorphic   to   R n − 1 ,   creating   an   explicit   isomorphism   is   computationally   diﬃcult.   In   comparison,   it   is   computationally   inexpensive   to   generate   an   element   of   x ⊥   (using   the   projection   onto   x ⊥ )   and   to   perform   in   x ⊥   the   usual   operations   of   addition   and   multiplication   by   a   scalar.  

In   view   of   the   discussion   above,   one   could   anticipate   diﬃculty   in   dealing   with   pullback   cost   functions   f   x :=   f R x because   they   are   deﬁned   on   vector   ◦  

[Page 75]

spaces   T x M   that   we   may   not   want   to   explicitly   represent   as   R d .   Fortunately,   many   classical   optimization   techniques   can   be   deﬁned   on   abstract   vector   spaces,   especially   when   the   vector   space   has   a   structure   of   Euclidean   space,   which   is   the   case   for   T x M   when   M   is   Riemannian.   We   refer   the   reader   to   Appendix   A   for   elements   of   calculus   on   abstract   Euclidean   spaces.  

# 4.2 LINE-SEARCH METHODS

Line-search   methods   on   manifolds   are   based   on   the   update   formula  

$$
x _ { k + 1 } = R _ { x _ { k } } ( t _ { k } \eta _ { k } ) ,
$$

where   η k is   in   T x k M   and   t k is   a   scalar.   Once   the   retraction   R   is   chosen,   the   two   remaining   issues   are   to   select   the   search   direction   η k and   then   the   step   length   t k .   To   obtain   global   convergence   results,   some   restrictions   must   be   imposed   on   η k and   t k .  

Deﬁnition 4.2.1 (gradient-related sequence) Given a cost function f   on a Riemannian manifold M , a sequence { η k } , η k ∈   T x k M , is gradientrelated   if, for any subsequence { x k } k ∈K   of { x k }   that converges to a noncritical point of f , the corresponding subsequence { η k } k ∈K   is bounded and satisﬁes

$$
\lim _ { k \to \infty , \ k \in \mathcal { K } } \langle \text {grad} f ( x _ { k } ) , \eta _ { k } \rangle < 0 .
$$

The   next   deﬁnition,   related   to   the   choice   of   t k ,   relies   on   Armijo’s   backtracking   procedure.  

Deﬁnition 4.2.2 (Armijo point) Given a cost function f   on a Riemannian manifold M   with retraction R , a point x   ∈ M , a tangent vector η   ∈   T x M , and scalars α >   0 , β, σ   ∈   (0 ,   1) , the Armijo   point   is η A =   t A η   =   β m αη , where m   is the smallest nonnegative integer such that

$$
f ( x ) - f ( R _ { x } ( \beta ^ { m } \overline { \alpha } \eta ) ) & \geq - \sigma \left \langle \text {grad} \, f ( x ) , \beta ^ { m } \overline { \alpha } \eta \right \rangle _ { x } . \\ \intertext { f ( x ) - f ( R _ { x } ( \beta ^ { m } \overline { \alpha } \eta ) ) \geq - \sigma \left \langle \text {grad} \, f ( x ) , \beta ^ { m } \overline { \alpha } \eta \right \rangle _ { x } . }
$$

The real t A is the Armijo   step   size .

We   propose   the   accelerated   Riemannian   line-search   framework   described   in   Algorithm   1.  

[Page 76]

# Algorithm 1 Accelerated   Line   Search   (ALS)  

Require: Riemannian   manifold   M ;   continuously   diﬀerentiable   scalar   ﬁeld   f   on   M ;   retraction   R   from   T   M   to   M ;   scalars   α >   0,   c, β, σ   ∈   (0 ,   1).  

M M M ∈

Input: Initial iterate x 0 ∈ M .

{ k } .

Output: Sequence of iterates x

- 1:   for k   = 0 ,   1 ,   2 , . . .   do
- 2: 	 Pick   η k in   T x k M   such   that   the   sequence   { η i } i =0 , 1 ,... is   gradient-related   (Deﬁnition   4.2.1).  
- 3: 	 Select   x k +1 such   that  


$$
f ( x _ { k } ) - f ( x _ { k + 1 } ) & \geq c ( f ( x _ { k } ) - f ( R _ { x _ { k } } ( t _ { k } ^ { A } \eta _ { k } ) ) ) , \quad \\ \intertext { a $ A $ ; $ \vdots $ } f ( x _ { k } ) - f ( x _ { k + 1 } ) & \geq c ( f ( x _ { k } ) - f ( R _ { x _ { k } } ( t _ { k } ^ { A } \eta _ { k } ) ) ) , \quad \\
$$

where   t A k is   the   Armijo   step   size   (Deﬁnition   4.2.2)   for   the   given   α, β, σ, η k .  

4:   end for

If   there   exists   a   computationally   eﬃcient   procedure   to   minimize   f R x k ◦ on   a   two-dimensional   subspace   of   T x k M ,   then   a   possible   choice   for   x k +1 in   Step   3   is   R x k ( ξ k ),   with   ξ k deﬁned   by    

$$
3 \text { step } 3 \text { is } R _ { x _ { k } } ( \xi _ { k } ) , & \text { with } \xi _ { k } \text { defined by } \\ & \xi _ { k } \colon = \arg \min _ { \xi \in S _ { k } } f ( R _ { x _ { k } } ( \xi ) ) , \quad \mathcal { S } _ { k } \colon = \text {span } \{ \eta _ { k } , R _ { x _ { k } } ^ { - 1 } ( x _ { k - 1 } ) \} \, , \\ \text {where } \text {span } \{ u , v \} & = \{ a u + b v \colon a , b \in \mathbb { R } \} . \text { This is a minimization over a two- }
$$

where   span   { u, v }   =   { au   +   bv   :   a, b   ∈   R } .   This   is   a   minimization   over   a   twodimensional   subspace   S k of   T x k M .   It   is   clear   that   S k contains   the   Armijo   point   associated   with   η k ,   since   η k is   in   S k .   It   follows   that   the   bound   (4.12)   on   x k +1 holds   with   c   =   1.   This   “two-dimensional   subspace   acceleration”   is   well   deﬁned   on   a   Riemannian   manifold   as   long   as   x k is   suﬃciently   close   to   x k − 1 that   R x − k 1 ( x k − 1 )   is   well   deﬁned.   The   approach   is   very   eﬃcient   in   the   context   of   eigensolvers   (see   Section   4.6).  

# 4.3 CONVERGENCE ANALYSIS

In   this   section,   we   deﬁne   and   discuss   the   notions   of   convergence   and   limit   points   on   manifolds,   then   we   give   a   global   convergence   result   for   Algorithm   1.  

# 4.3.1 Convergence on manifolds

[Page 77]

![The image presents a diagram consisting of a graph with two axes labeled as y and x. The graph is a Cartesian coordinate system, where the x-axis represents the horizontal axis and the y-axis represents the vertical axis. The graph is labeled as Representative element of fiber (0, y 0). The graph consists of two main components: 1. **Graph Representation**: - The graph is a Cartesian coordinate graph. - The x-axis is labeled as y and the y-axis is labeled as x. - The graph is divided into two sections, labeled as Representative element of fiber (0, y 0) and The set H - G. 2. **Graph Elements**: - The graph has two main components: - The first component is labeled as Representative element of fiber (0, y 0). - The second component is labeled as The set](<images/imageFile15.png>)

Representative element  

{

}

, y

y >

of

ﬁber

(0

) :

0

Fibers

y  

′

x  

x

=

y

+

′

-

y

x  

-

y

′

y

+

-

H  

G  

The set

Representative element    

{

}

, y

y <

of

ﬁber

(0

) :

0

Figure 4.2 Left: A few equivalence classes of the quotient deﬁned in Section 4.3.2. Right: The graph G consists of all the points in H ≡ R 3   that do not lie on the dashed planes indicated.

An   equivalent   and   more   concise   deﬁnition   is   that   a   sequence   on   a   manifold   is   convergent   if   it   is   convergent   in   the   manifold   topology,   i.e.,   there   is   a   point   x ∗   such   that   every   neighborhood   of   x ∗   contains   all   but   ﬁnitely   many   points   of   the   sequence.  

Given   a   sequence   { x k } k =0 , 1 ,... ,   we   say   that   x   is   an   accumulation point or   a   limit point of   the   sequence   if   there   exists   a   subsequence   { x j k } k =0 , 1 ,... that   converges   to   x .   The   set   of   accumulation   points   of   a   sequence   is   called   the   limit set of   the   sequence.  

# 4.3.2 A topological curiosity*

We   present   a   non-Hausdorﬀ   quotient   and   a   convergent   sequence   with   two   limit   points.   2

  Consider   the   set   M   =   R ∗ ,   i.e.,   the   real   plane   with   the   origin   excerpted.   Consider   the   equivalence   relation   ∼   on   M ,   where   ( x, y )   ∼   ( x   ′   , y   ′   )   if   and   only   if   x   =   x   ′   and   the   straight   line   between   ( x, y )   and   ( x   ′   , y   ′   )   lies   wholly   in   R 2 ∗ .   In   other   words,   the   equivalence   classes   of   ∼   are   the   two   vertical   half-lines   { (0 , y ) :   y >   0 }   and   { (0 , y ) :   y <   0 }   and   all   the   vertical   lines   { ( x, y ) :   y   ∈   R } ,   x   =   0;   see   Figure   4.2.  

/negationslash Proposition 3.4.3.

Using   Proposition   3.4.3,   we   show   that   M /   ∼   admits   a   (unique)   diﬀerentiable   structure   that   makes   the   natural   projection   π   a   submersion,   and   we   show   that   the   topology   induced   by   this   diﬀerentiable   structure   is   not   Hausdorﬀ.   Consider   the   graph   G   =   { (( x, y ) ,   ( x   ′   , y   ′   ))   :   ( x, y )   ∼   ( x   ′   , y   ′ ′   ′   ) }   ⊂   M×   M .   Set   H   =   { (( x, y ) ,   ( x   , y   ′   ))   :   x   =   x   }   and   observe   that   G ⊆ H   and   H   is   an   embedded   submanifold   of   M×   M .   The   set   H−G   =   { (( x, y ) ,   ( x   ′   , y   ′   ))   :   x   =   x   ′   =   0 ,   sign( y )     =   sign( y   ′   ) }   is   a   closed   subset   of   H .   It   follows   that   G   is   an   open   submanifold   of   H   and   consequently   an   embedded   submanifold   of   M ×   M .   It   is   straightforward   to   verify   that   π 1 :   G →   M   is   a   submersion.   However,   G is   open   in   H ,   hence   G   is   not   closed   in   M ×   M .   The   conclusion   follows   from  

/negationslash

[Page 78]

To   help   the   intuition,   we   produce   a   diﬀeomorphism   between   M /   ∼   and   a   subset   of   M .   Let   X 0 =   { ( x,   0)   :   x   =   0 }   denote   the   horizontal   axis   of   the   real   plane   with   the   origin   excluded.   The   quotient   set   M /   ∼   is   in   one-toone   correspondence   with   N   :=   X 0 ∪{ (0 ,   1) ,   (0 ,   − 1) }   through   the   mapping   Φ   that   sends   each   equivalence   class   to   its   element   contained   in   N   .   Let   U + :=   X 0 ∪ { (0 ,   1) }   and   U −   :=   X 0 ∪ { (0 ,   − 1) } .   Deﬁne   charts   ψ + and   ψ −   of   the   set   into   R   with   domains   U + and   U −   by   ψ ± (( x,   0))   =   x   for   all   x   =   0   and   N   ψ + ((0 ,   1))   =   0,   ψ − ((0 ,   − 1))   =   0.   These   charts   form   an   atlas   of   the   set   N and   thus   deﬁne   a   diﬀerentiable   structure   on   N   .   It   is   easy   to   check   that   the   mapping   Φ   π   :   M → N   ,   where   π   :   M →   M / ∼   is   the   natural   projection,   is   ◦ a   submersion.   In   view   of   Proposition   3.4.3,   this   implies   that   the   sets   M /   ∼ and   N   ,   endowed   with   their   diﬀerentiable   structures,   are   diﬀeomorphic.   It   is   easy   to   produce   a   convergent   sequence   on   N   with   two   limit   points.  

/negationslash the inequality above reads

/negationslash

The   sequence   { (1 /k,   0) } k =1 , 2 ,... converges   to   (0 ,   1)   since   { ψ + (1 /k,   0) }   converges   to   ψ + (0 ,   1).   It   also   converges   to   (0 ,   − 1)   since   { ψ − (1 /k,   0) }   converges   to   ψ − (0 ,   − 1).  

# 4.3.3 Convergence of line-search methods

We   give   a   convergence   result   for   the   line-search   method   deﬁned   in   Algorithm   1.   The   statement   and   the   proof   are   inspired   by   the   classical   theory   in   R n .   However,   even   when   applied   to   R n ,   our   statement   is   more   general   than   the   standard   results.   First,   the   line   search   is   not   necessarily   done   along   a   straight   line.   Second,   points   other   than   the   Armijo   point   can   be   selected;   for   example,   using   a   minimization   over   a   subspace   containing   the   Armijo   point.  

Theorem 4.3.1 Let { x k }   be an inﬁnite sequence of iterates generated by Algorithm 1. Then every accumulation point of { x k }   is a critical point of the cost function f .

Proof. By   contradiction.   Suppose   that   there   is   a   subsequence   { x k } k ∈K   converging   to   some   x ∗   with   grad   f ( x ∗ ) =   0.   Since   { f ( x k ) }   is   nonincreasing,   it   follows   that   the   whole   sequence   { f ( x k ) }   converges   to   f ( x ∗ ).   Hence   f ( x k )   − f ( x k +1 )   goes   to   zero.   By   construction   of   the   algorithm,  

/negationslash

$$
f ( x _ { k } ) - f ( x _ { k + 1 } ) & \geq - c \sigma \alpha _ { k } \langle \text {grad} \, f ( x _ { k } ) , \eta _ { k } \rangle _ { x _ { k } } . \\ \eta _ { k } \} _ { \ } i s _ { \ } r o d i o n t \, r o l o t o d \, \ y v o w \, \mu v o \, \{ \sigma _ { k } \} _ { \ } i s _ { \ } r o l o t o d \, \mu v o \, \{ \sigma _ { k } \} _ { \ } i s _ { \ } r o l o t o d \, \mu v o
$$

Since   { η k }   is   gradient-related,   we   must   have   { α k } k ∈K   →   0.   The   α k ’s   are   determined   from   the   Armijo   rule,   and   it   follows   that   for   all   k   greater   than   some   k ,   α k =   β m k α ,   where   m k is   an   integer   greater   than   zero.   This   means   that   the   update   α β k η k did   not   satisfy   the   Armijo   condition.   Hence      

$$
\text {that the update } \frac { \theta } { \beta } \eta _ { k } \text { did not satisfy the Armijo condition. Hence} \\ f ( x _ { k } ) - f \left ( R _ { x _ { k } } \left ( \frac { \alpha _ { k } } { \beta } \eta _ { k } \right ) \right ) & < - \sigma \frac { \alpha _ { k } } { \beta } \langle \text {grad} \, f ( x _ { k } ) , \eta _ { k } \rangle _ { x _ { k } } , \quad \forall k \in \mathcal { K } , \, k \geq \bar { k } . \\ \text {Denoting}
$$

Denoting  

$$
\tilde { \eta } _ { k } = \frac { \eta _ { k } } { \| \eta _ { k } \| } \ \text { and } \ \tilde { \alpha } _ { k } = \frac { \alpha _ { k } \| \eta _ { k } \| } { \beta } ,
$$

[Page 79]

$$
& \frac { \widehat { f } _ { x _ { k } } ( 0 ) - \widehat { f } _ { x _ { k } } ( \tilde { \alpha } _ { k } \tilde { \eta } _ { k } ) } { \tilde { \alpha } _ { k } } < - \sigma \langle \text {grad} f ( x _ { k } ) , \tilde { \eta } _ { k } \rangle _ { x _ { k } } , \quad \forall k \in \mathcal { K } , \ k \geq \bar { k } , \\ \text {where } & \widehat { f } \text { is defined as in } ( 4 . 3 ) . \text { The mean value theorem ensures that there}
$$

where f ̂ is defined as in (4.3). The mean value theorem ensures that there exists t ∈ [0 , α ˜ k ] such that

  k k where   the   diﬀerential   is   taken   with   respect   to   the   Euclidean   structure   on   T x k M .   Since   { α k } k ∈K   →   0   and   since   η k is   gradient-related,   hence   bounded,   it   follows   that   { α ˜ k } k ∈K   →   0.   Moreover,   since   η ˜ k has   unit   norm,   ˜ it   thus   belongs   to   a   compact   set,   and   therefore   there   exists   an   index   set   K ⊆ K   such   that   { η ˜ k } k ∈K ˜ →   η ˜ ∗   for   some   ˜ η ∗   with     η ˜ ∗     =   1.   We   now   take   the   limit   in   (4.15)   over   K ˜ .   Since   the   Riemannian   metric   is   continuous   (by   deﬁnition),   and   f   ∈   C 1 ,   and   Df ˆ   x k (0)[˜ η k ] =     grad   f ( x k ) , η ˜ k   x k —see   (3.31)   and   (4.4)—we   obtain  

$$
- \langle \text {grad} \, f ( x _ { * } ) , \tilde { \eta } _ { * } \rangle _ { x _ { * } } & \leq - \sigma \langle \text {grad} \, f ( x _ { * } ) , \tilde { \eta } _ { * } \rangle _ { x _ { * } } . \\ + 1 \colon \text {f} \, \tau \, \rangle _ { x _ { * } } & = 1 \, \rangle _ { x _ { * } } .
$$

Since   σ <   1,   it   follows   that     grad   f ( x ∗ ) , η ˜ ∗   x ∗ ≥   0.   On   the   other   hand,   from   the   fact   that   { η k }   is   gradient-related,   one   obtains   that     grad   f ( x ∗ ) , η ˜ ∗   x ∗ <   0,   a   contradiction.      

More   can   be   said   under   compactness   assumptions   using   a   standard   argument.  

Corollary 4.3.2 Let { x k }   be an inﬁnite sequence of iterates generated by Algorithm 1. Assume that the level set L   =   { x   ∈ M   :   f ( x )   ≤   f ( x 0 ) } is compact (which holds in particular when M   itself is compact). Then lim k →∞     grad   f ( x k )     = 0 .                    

    Proof. By contradiction, assume the contrary. Then there is a subsequence { x k } k ∈K   and   ǫ >   0   such   that     grad   f ( x k )     > ǫ   for   all   k   ∈ K .   Because   f   is   nonincreasing   on   { x k } ,   it   follows   that   x k ∈ L   for   all   k .   Since   L   is   compact,   { x k } k ∈K   has   an   accumulation   point   x ∗   in   L .   By   the   continuity   of   grad   f ,   one   has     grad   f ( x ∗ )   ≥   ǫ ;   i.e.,   x ∗   is   not   critical,   a   contradiction   to   Theorem   4.3.1.  

# 4.4 STABILITY OF FIXED POINTS

Theorem   4.3.1   states   that   only   critical   points   of   the   cost   function   f   can   be   accumulation   points   of   sequences   { x k }   generated   by   Algorithm   1.   This   result   gives   useful   information   on   the   behavior   of   Algorithm   1.   Still,   it   falls   short   of   what   one   would   expect   of   an   optimization   method.   Indeed,   Theorem   4.3.1   does   not   specify   whether   the   accumulation   points   are   local   minimizers,   local   maximizers,   or   saddle points (critical   points   that   are   neither   local   minimizers   nor   local   maximizers).  

[Page 80]

Unfortunately,   avoiding   saddle   points   and   local   maximizers   is   too   much   to   ask   of   a   method   that   makes   use   of   only   ﬁrst-order   information   on   the   cost   function.   We   illustrate   this   with   a   very   simple   example.   Let   x ∗   be   any   critical   point   of   a   cost   function   f   and   consider   the   sequence   { ( x k , η k ) } ,   x k =   x ∗ ,   η k =   0.   This   sequence   satisﬁes   the   requirements   of   Algorithm   1,   and   { x k } trivially   converges   to   x ∗   even   if   x ∗   is   a   saddle   point   or   a   local   minimizer.  

Nevertheless,   it   is   observed   in   practice   that   unless   the   initial   point   x 0 is   carefully   crafted,   methods   within   the   framework   of   Algorithm   1   do   produce   sequences   whose   accumulation   points   are   local   minima   of   the   cost   function.   This   observation   is   supported   by   the   following   stability   analysis   of   critical   points.  

Let   F   be   a   mapping   from   M   to   M .   A   point   x ∗   ∈ M   is   a   ﬁxed point of   F   if   F   ( x ∗ ) =   x ∗ .   Let   F   ( n ) denote   the   result   of   n   applications   of   F   to   x ,   i.e.,   F   (1) ( x ) =   F   ( x ) , F   ( i +1) ( x ) =   F   ( F   ( i ) ( x )) , i   = 1 ,   2 , . . . .  

A   ﬁxed   point   x ∗   of   F   is   a   stable point of   F   if,   for   every   neighborhood   U   of   x ∗ ,   there   exists   a   neighborhood   V   of   x ∗   such   that,   for   all   x   ∈ V   and   all   positive   integer   n ,   it   holds   that   F   ( n ) ( x )   ∈ U .   The   ﬁxed   point   x ∗   is   asymptotically stable if   it   is   stable,   and,   moreover,   lim n →∞   F   ( n ) ( x ) =   x ∗   for   all   x   suﬃciently   close   to   x ∗ .   The   ﬁxed   point   x ∗   is   unstable if   it   is   not   stable;   in   other   words,   there   exists   a   neighborhood   U   of   x ∗   such   that,   for   all   neighborhood   V   of   x ∗ ,   there   is   a   point   x   ∈ V   such   that   F   ( n ) ( x )   / ∈ U   for   some   n .   We   say   that   F   is   a   descent mapping for   a   cost   function   f   if  

$$
f ( F ( x ) ) & \leq f ( x ) \quad \text {for all } x \in \mathcal { M } . \\ ( \, & \quad ( \, ) , \, ) \leq f ( x ) \quad \text {for all } x \in \mathcal { M } .
$$

Theorem 4.4.1 (unstable ﬁxed points) Let F   :   M → M   be a descent mapping for a smooth cost function f   and assume that for every x   ∈ M , all the accumulation points of { F   ( k ) ( x ) } k =1 , 2 ,... are critical points of f . Let x ∗   be a ﬁxed point of F   (thus x ∗   is a critical point of f ). Assume that x ∗   is not a local minimum of f . Further assume that there is a compact neighborhood U   of x ∗   where, for every critical point y   of f   in U , f ( y ) =   f ( x ∗ ) . Then x ∗   is an unstable point for F   .

Proof. Since   x ∗   is   not   a   local   minimum   of   f ,   it   follows   that   every   neighborhood   V   of   x ∗   contains   a   point   y   with   f ( y )   < f ( x ∗ ).   Consider   the   sequence   y k :=   F   ( k ) ( y ).   Suppose   for   the   purpose   of   establishing   a   contradiction   that   y k ∈ U   for   all   k .   Then,   by   compactness,   { y k }   has   an   accumulation   point   z   in   U .   By   assumption,   z   is   a   critical   point   of   f ,   hence   f ( z ) =   f ( x ∗ ).   On   the   other   hand,   since   F   is   a   descent   mapping,   it   follows   that   f ( z )   ≤   f ( y )   < f ( x ∗ ),   a   contradiction.      

The   assumptions   made   about   f   and   F   in   Theorem   4.4.1   may   seem   complicated,   but   they   are   satisﬁed   in   many   circumstances.   The   conditions   on   F   are   satisﬁed   by   any   method   in   the   class   of   Algorithm   1.   As   for   the   condition   on   the   critical   points   of   f ,   it   holds   for   example   when   f   is   real   analytic.   (This   property   can   be   recovered   from     Lojasiewicz’s   gradient   inequality:   if   f   is   real   analytic   around   x ∗ ,   then   there   are   constants   c >   0   and   µ   ∈   [0 ,   1)   such   that     grad   f ( x )   ≥   c | f ( x )   −   f ( x ∗ ) | µ

$$
\| \text {grad} \, f ( x ) \| \geq c | f ( x ) - f ( x _ { * } ) | ^ { \mu }
$$

[Page 81]

for   all   x   in   some   neighborhood   of   x ∗ .)  

We   now   give   a   stability   result.  

Theorem 4.4.2 (capture theorem) Let F   :   M → M   be a descent mapping for a smooth cost function f   and assume that, for every x   ∈ M , all the accumulation points of { F   ( k ) ( x ) } k =1 , 2 ,... are critical points of f . Let x ∗   be a local minimizer and an isolated critical point of f . Assume further that dist( F   ( x ) , x )   goes to zero as x   goes to x ∗ . Then x ∗   is an asymptotically stable point of F   .

Proof. Let   U   be   a   neighborhood   of   x ∗ .   Since   x ∗   is   an   isolated   local   minimizer   of   f ,   it   follows   that   there   exists   a   closed   ball  

$$
\overline { B } _ { \epsilon } ( x _ { * } ) \colon = \{ x \in \mathcal { M } \colon \text {dist} ( x , x _ { * } ) \leq \epsilon \} \\ ( x _ { r } ) \subsetneq \mathcal { U } _ { r } \text { and } f ( x ) \geq f ( x _ { r } ) \text { for all} ] \ x \in \overline { B } \ ( x
$$

such   that   B ǫ ( x ∗ )   ⊂ U   and   f ( x )   > f ( x ∗ )   for   all   x   ∈   B ǫ ( x ∗ )   − { x ∗ } .   In   view   of   the   condition   on   dist( F   ( x ) , x ),   there   exists   δ >   0   such   that,   for   all   x   ∈   B δ ( x ∗ ),   F   ( x )   ∈   B ǫ ( x ∗ ).   Let   α   be   the   minimum   of   f   on   the   compact   set   B ǫ ( x ∗ )   −   B δ ( x ∗ ).   Let     =   x     B ǫ ( x ∗ ) :   f ( x )   < α .  

$$
\mathcal { V } = \{ x \in \overline { B } _ { \epsilon } ( x _ { * } ) \colon f ( x ) < \alpha \} . \\ \text {d} \, i n \, B _ { \epsilon } ( x ) \ \text {Hence} \, \text {for every} \, x \text { in } \mathcal { V } \text { } i t
$$

This   set   is   included   in   B δ ( x ∗ ).   Hence,   for   every   x   in   V ,   it   holds   that   F   ( x )   ∈ B ǫ ( x ∗ ),   and   it   also   holds   that   f ( F   ( x ))   ≤   f ( x )   < α   since   F   is   a   descent   mapping.   It   follows   that   F   ( x )   ∈ V   for   all   x   ∈ V ,   hence   F   ( n ) ( x )   ∈ V ⊂ U   for   all   x   ∈ V   and   all   n .   This   is   stability.   Moreover,   since   by   assumption   x ∗   is   the   only   critical   point   of   f   in   V ,   it   follows   that   lim n →∞   F   ( n ) ( x ) =   x ∗   for   all   x   ∈ V ,   which   shows   asymptotic   stability.                              

The additional condition on dist( F ( x ) , x ) in Theorem 4.4.2 is not satisﬁed by   every   instance   of   Algorithm   1   because   our   accelerated   line-search   framework   does   not   put   any   restriction   on   the   step   length.   The   distance   condition   is   satisﬁed,   for   example,   when   η k is   selected   such   that     η k   ≤   c   grad   f ( x k )   for   some   constant   c   and   x k +1 is   selected   as   the   Armijo   point.  

In   this   section,   we   have   assumed   for   simplicity   that   the   next   iterate   depends   only   on   the   current   iterate:   x k +1 =   F   ( x k ).   It   is   possible   to   generalize   the   above   result   to   the   case   where   x k +1 depends   on   x k and   on   some   “memory   variables”:   ( x k +1 , y k +1 ) =   F   ( x k , y k ).  

# 4.5 SPEED OF CONVERGENCE

We   have   seen   that,   under   reasonable   assumptions,   if   the   ﬁrst   iterate   of   Algorithm   1   is   suﬃciently   close   to   an   isolated   local   minimizer   x ∗   of   f ,   then   the   generated   sequence   { x k }   converges   to   x ∗ .   In   this   section,   we   address   the   issue   of   how   fast   the   sequence   converges   to   x ∗ .  

# 4.5.1 Order of convergence

A sequence { x k } k =0 , 1 ,... of points of R n is said to converge linearly to a point x ∗ if there exists a constant c ∈ (0 , 1) and an integer K ≥ 0 such that, for all k ≥ K , it holds that ‖ x k +1 -x ∗ ‖ ≤ c ‖ x k -x ∗ ‖ . In order to generalize this notion to manifolds, it is tempting to fall back to the R n definition using charts and state that a sequence { x k } k =0 , 1 ,... of points of a manifold M converges linearly to a point x ∗ ∈ M if, given a chart ( U , ψ ) with x ∈ U , the sequence { ψ ( x k ) } k =0 , 1 ,... converges linearly to ψ ( x ∗ ). Unfortunately, the notion is not independent of the chart used. For example, let M be the set R n with its canonical manifold structure and consider the sequence { x k } k =0 , 1 ,... defined by x k = 2 -k e 1 if k is even and by x k = 2 -k +2 e 2 if k is odd. In the identity chart, this sequence is not linearly convergent because of the requirement that the constant c be smaller than 1. However, in the chart defined by ψ ( xe 1 + ye 2 ) = xe 1 + ( y/ 4) e 2 , the sequence converges linearly with constant c = 1 2 .

[Page 82]

2 If   M   is   a   Riemannian   manifold,   however,   then   the   induced   Riemannian   distance   makes   it   possible   to   deﬁne   linear   convergence   as   follows.  

Deﬁnition 4.5.1 (linear convergence) Let M   be a Riemannian manifold and let dist   denote the Riemannian distance on M . We say that a sequence { x k } k =0 , 1 ,... converges   linearly   to a point x ∗   ∈ M   if there exists a constant c   ∈   (0 ,   1)   and an integer K   ≥   0   such that, for all k   ≥   K , it holds that

The limit Definition 4.5.2 Let M be a manifold  and let { x k } k =0 , 1 ,... be a sequence on M converging  to x ∗ . Let ( U , ψ ) be a chart  of M with x ∈ U . If

$$
\text {dist} ( x _ { k + 1 } , x _ { * } ) \leq c \text { dist} ( x _ { k } , x _ { * } ) .
$$

$$
\lim _ { k \to \infty } \sup _ { k \to \infty } \frac { \text {dist} ( x _ { k + 1 } , x _ { * } ) } { \text {dist} ( x _ { k } , x _ { * } ) }
$$

is called the linear   convergence   factor   of the sequence. An iterative algorithm on M   is said to converge   locally   linearly   to a point x ∗   if there exists a neighborhood U   of x ∗   and a constant c   ∈   (0 ,   1)   such that, for every initial point x 0 ∈ U , the sequence { x k }   generated by the algorithm satisﬁes (4.16) .

A   convergent   sequence   { x k }   on   a   Riemannian   manifold   M   converges   linearly   to   x ∗   with   constant   c   if   and   only   if  

$$
\| R _ { x _ { * } } ^ { - 1 } ( x _ { k + 1 } ) - R _ { x _ { * } } ^ { - 1 } ( x _ { * } ) \| & \leq c \| R _ { x _ { * } } ^ { - 1 } ( x _ { k } ) - R _ { x _ { * } } ^ { - 1 } ( x _ { * } ) \| \\ \intertext { v . } \| R _ { x _ { * } } ^ { - 1 } ( x _ { k + 1 } ) - R _ { x _ { * } } ^ { - 1 } ( x _ { * } ) \| & \leq c \| R _ { x _ { * } } ^ { - 1 } ( x _ { k } ) - R _ { x _ { * } } ^ { - 1 } ( x _ { * } ) \| \\
$$

for   all   k   suﬃciently   large,   where   R   is   any   retraction   on   M   and     ·     denotes   the   norm   on   T x ∗ M   deﬁned   by   the   Riemannian   metric.   (To   see   this,   let   Exp x ∗ denote   the   exponential   mapping   introduced   in   Section   5.4,   restricted   to   a   neighborhood   U ˆ of 0 x ∗ in   T x ∗ M   such   that   U   :=   Exp ( U ˆ )   is   a   norx ∗ mal   neighborhood   of   x ∗ .   We   have   dist( x, x ∗ ) =     Exp − x ∗ 1 ( x )   −   Exp − x ∗ 1 ( x ∗ )     =     Exp − 1 ( x )     for   all   x   ∈ U .   Moreover,   since   Exp   is   a   retraction,   we   have   x ∗ D( R x − ∗ 1 Exp x ∗ )(0 x ∗ )   =   id.   Hence     R − x ∗ 1 ( x )   −   R x − ∗ 1 ( x ∗ )     =     Exp − x ∗ 1 ( x )   − Exp − 1 ( x ◦   ∗ )     +   o (   Exp − 1 ( x )   −   Exp − 1 ( x ∗ )   )   =   dist( x, x ∗ ) +   o (dist( x, x ∗ )).)   x ∗ x ∗ x ∗ In   contrast   to   linear   convergence,   the   notions   of   superlinear   convergence  

In contrast to linear convergence, the notions of superlinear convergence and order of convergence can be defined on a manifold independently of any other structure.

[Page 83]

$$
\lim _ { k \to \infty } \frac { \| \psi ( x _ { k + 1 } ) - \psi ( x _ { * } ) \| } { \| \psi ( x _ { k } ) - \psi ( x _ { * } ) \| } = 0 , \\ \intertext { t o g o n v o r g o u r l i n o r l y } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s } \intertext { t o g h a r r e s
$$

then { x k }   is said to converge   superlinearly   to x ∗ . If there exist constants p >   0 , c   ≥   0 , and K   ≥   0   such that, for all k   ≥   K , there holds p

$$
\| \psi ( x _ { k + 1 } ) - \psi ( x _ { * } ) \| & \leq c \| \psi ( x _ { k } ) - \psi ( x _ { * } ) \| ^ { p } , \\ ) _ { k } & = \| x _ { k + 1 } \| ^ { p } - \| \psi ( x _ { * } ) \| ^ { p } ,
$$

then { x k }   is said to converge to x ∗   with order at least p . An iterative algorithm on a manifold M   is said to converge locally to a point x ∗   with order at least p   if there exists a chart ( U , ψ )   at x ∗   and a constant c >   0   such that, for every initial point x 0 ∈ U , the sequence { x k }   generated by the algorithm satisﬁes (4.17) . If p   = 2 , the convergence is said to be quadratic , and cubic   if p   = 3 .

Since   by   deﬁnition   charts   overlap   smoothly,   it   can   be   shown   that   the   deﬁnitions   above   do   not   depend   on   the   choice   of   the   chart   ( U , ψ ).   (The   multiplicative   constant   c   depends   on   the   chart,   but   for   any   chart,   there   exists   such   a   constant.)  

Theorem   4.5.3   below   gives   calculus-based   local   convergence   results   for   iterative   methods   deﬁned   by   x k +1 =   F   ( x k ),   where   the   iteration   mapping   F   :   M → M   has   certain   smoothness   properties.  

Theorem 4.5.3 Let F   :   M → M   be a C 1 mapping whose domain and range include a neighborhood of a ﬁxed point x ∗   of F   .

- (i) If D F   ( x ∗ ) = 0 , then the iterative algorithm with iteration mapping F   converges locally superlinearly to x ∗ . 2
- (ii) If D F   ( x ∗ ) = 0   and F   is C , then the iterative algorithm with mapping F   converges locally quadratically to x ∗ .


Although   Theorem   4.5.3   is   very   powerful   for   smooth   iteration   mappings,   it   is   rarely   useful   for   practical   line-search   and   trust-region   methods   because   of   the   nondiﬀerentiability   of   the   step   selection   process.  

# 4.5.2 Rate of convergence of line-search methods*

In   this   section   we   give   an   asymptotic   convergence   bound   for   Algorithm   1   when   η k is   chosen   as   − grad   f ( x k ),   without   any   further   assumption   on   how   x k +1 is   selected.  

The   result   invokes   the   smallest   and   largest   eigenvalues   of   the   Hessian   of   f   at   a   critical   point   x ∗ .   We   have   not   yet   given   a   deﬁnition   for   the   Hessian   of   a   cost   function   on   a   Riemannian   manifold.   (This   is   done   in   Section   5.5.)   Nevertheless,   regardless   of   this   deﬁnition,   it   makes   sense   to   talk   about   the   eigenvalues   of   the   Hessian   at   a   critical   point   because   of   the   following   results.  

[Page 84]

Lemma 4.5.4 Let f   :   R n R   and x ∗   ∈   R n such that D f ( x ∗ ) = 0 . Let F   :   R n R n and y ∗   ∈   R n → such that F   ( y ∗ ) =   x ∗   and that the Jacobian   → matrix   of F   at y ∗ ,  

$$
F _ { \ } a t \ y _ { * } , \\ J _ { F } ( y _ { * } ) \colon = \begin{bmatrix} \partial _ { 1 } F ^ { 1 } ( y _ { * } ) & \cdots & \partial _ { n } F ^ { 1 } ( y _ { * } ) \\ \vdots & \ddots & \vdots \\ \partial _ { 1 } F ^ { \dot { n } } ( y _ { * } ) & \cdots & \partial _ { n } F ^ { \dot { n } } ( y _ { * } ) \end{bmatrix} , \\ \ n a l \ ( i . e . , \ J _ { F } ^ { T } ( y _ { * } ) J _ { F } ( y _ { * } ) = I ) . \ L e t \ H \ b e \ t h e \ H e s s i a n \ m a t
$$

is orthogonal (i.e., J T ( y ∗ )J F ( y ∗ ) =   I ). Let H   be the Hessian matrix of f   at F x ∗ ; i.e., H ij =   ∂ i ∂ j f ( x ∗ ) . Let H ˆ be the Hessian matrix of f F   at y ∗ . Then λ ( H ) =   λ ( H ˆ ) ; i.e., the spectrum of H   and the spectrum of H ˆ ◦   are the same.

Proof. Since   ∂ j ( f   ◦   F   )( y ) =     k ∂ k f ( F   ( y ))   ∂ j F   k ( y ),   we   have   H ˆ ij =   ∂ i ∂ j ( f F   )( y ∗ )     ◦    

$$
\hat { H } _ { i j } & = \partial _ { i } \partial _ { j } ( f \circ F ) ( y _ { * } ) \\ & = \sum _ { k , \ell } \partial _ { \ell } \partial _ { k } f ( F ( y _ { * } ) ) \, \partial _ { i } F ^ { \ell } ( y _ { * } ) \, \partial _ { j } F ^ { k } ( y _ { * } ) + \sum _ { k } \partial _ { k } f ( F ( y _ { * } ) ) \, \partial _ { i } \partial _ { j } F ^ { k } ( y _ { * } ) . \\ \text {Since } x _ { j } \text { is a critical point of } f \text { , } \text { it follows that } \partial _ { k } f ( F ( y _ { * } ) ) = 0 , \text { Hence we }
$$

Since   x ∗   is   a   critical   point   of   f ,   it   follows   that   ∂ k f ( F   ( y ∗ ))   =   0.   Hence   we   have,   in   matrix   notation,  

$$
\hat { H } = J _ { F } ^ { T } ( y _ { * } ) H J _ { F } ( y _ { * } ) = J _ { F } ^ { - 1 } ( y _ { * } ) H J _ { F } ( y _ { * } ) .
$$

This   shows   that   H   and   H ˆ have   the   same   spectrum   because   they   are   related   by   a   similarity   transformation.      

Corollary 4.5.5 Let f   be a cost function on a Riemannian manifold ( M , g )   and let x ∗   ∈ M   be a critical point of f , i.e., grad   f ( x ∗ ) = 0 . Let ( U , ψ )   be any chart such that x ∗   ∈ U   and that the representation of g x ∗ in the chart is the identity, i.e., g ij =   δ ij at x ∗ . Then the spectrum of the Hessian matrix of f ψ − 1 at ψ ( x ∗ )   does not depend on the choice of ψ . ◦  

We   can   now   state   the   main   result   of   this   section.   When   reading   the   theorem   below,   it   is   useful   to   note   that   0   < r ∗   <   1   since   β, σ   ∈   (0 ,   1).   Also,   in   common   instances   of   Algorithm   1,   the   constant   c   in   the   descent   condition   (4.12)   is   equal   to   1,   hence   (4.18)   reduces   to   f ( x k +1 )   −   f ( x ∗ )   ≤   r   ( f ( x k )   −   f ( x ∗ )).  

Theorem 4.5.6 Let { x k }   be an inﬁnite sequence of iterates generated by Algorithm 1 with η k :=   − grad   f ( x k ) , converging to a point x ∗ . (By Theorem 4.3.1, x ∗   is a critical point of f .) Let λ H, min and λ H,max be the smallest and largest eigenvalues of the Hessian of f   at x ∗ . Assume that λ H, min >   0   (hence x ∗   is a local minimizer of f ). Then, given r   in the interval ( r ∗ ,   1)   αλ H, min ,   4 σ (1   −   σ ) β   λ H, min with r ∗   = 1   −   min     2 σ   ¯   , there exists an integer λ H, max K   ≥   0   such that

$$
f ( x _ { k + 1 } ) - f ( x _ { * } ) & \leq ( r + ( 1 - r ) ( 1 - c ) ) \left ( f ( x _ { k } ) - f ( x _ { * } ) \right ) \\ \\ f ( x _ { k + 1 } ) - f ( x _ { * } ) & \leq ( r + ( 1 - r ) ( 1 - c ) ) \left ( f ( x _ { k } ) - f ( x _ { * } ) \right )
$$

for all k   ≥   K , where c   is the parameter in Algorithm 1.

[Page 85]

Proof. Let   ( U , ψ )   be   a   chart   of   the   manifold   M   with   x ∗   ∈ U .   We   use   the   notation   ζ x :=   − grad   f ( x ).   Coordinate   expressions   are   denoted   with   a   hat,   e.g.,   x ˆ :=   ψ ( x ),   U ˆ =   ψ ( U ),   f ˆ (ˆ x )   :=   f ( x ),   ζ ˆ x ˆ :=   D ψ   ( x ) [ ζ x f ],   ˆ   R ˆ x ˆ ( ζ ˆ )   :=   ψ ( R x ( ζ )).   We   also   let   y x ˆ denote   the   Euclidean   gradient   of   at   x ˆ,   i.e.,   y x ˆ :=   ( ∂ 1 f ˆ (ˆ x ) , . . . , ∂ d f ˆ (ˆ x )) T .   We   let   G x ˆ denote   the   matrix   representation   of   the   Riemannian   metric   in   the   coordinates,   and   we   let   H x ˆ ∗ denote   the   Hessian   matrix   of   f ˆ at   ˆ x ∗ .   Without   loss   of   generality,   we   assume   that   ˆ x ∗   = 0   and   that   G x ˆ ∗ =   I ,   the   identity   matrix.  

The   major   work   is   to   obtain,   at   a   current   iterate   x ,   a   suitable   upper   bound   on   f ( R x ( t A ζ x )),   where   t A is   the   Armijo   step   (so   t A ζ x is   the   Armijo   point).   The   Armijo   condition   is  

$$
f ( R _ { x } ( t ^ { A } \zeta _ { x } ) ) & \leq f ( x ) - \sigma \langle \zeta _ { x } , t ^ { A } \zeta _ { x } \rangle \\ & \leq f ( x ) - \sigma t ^ { A } \langle \zeta _ { x } , \zeta _ { x } \rangle . \\ \intertext { w e a l o w r e b o und o n } & \quad \langle \zeta _ { x } , \zeta _ { x } \rangle \text { in terms of } f ( x ) . \text { Recall from } ( 3 . 3 2 )
$$

We   ﬁrst   give   a   lower   bound   on     ζ x , ζ x     in   terms   of   f ( x ).   Recall   from   (3.32)   x =   G − 1 that   ζ ˆ ˆ x ˆ y x ˆ ,   from   which   it   follows   that  

$$
\langle \zeta _ { x } , \zeta _ { x } \rangle = \hat { \zeta } ^ { T } _ { \hat { x } } G _ { \hat { x } } \hat { \zeta } = y _ { \hat { x } } G _ { \hat { x } } ^ { - 1 } y _ { \hat { x } } = \| y _ { \hat { x } } \| ^ { 2 } ( 1 + O ( \hat { x } ) ) \quad ( 4 . 2 0 ) \\ \intertext { o n o w h o v e a s c u m o d } \ t h o t \, C _ { x } \, \text { is the } \text { idontity } \, J \ t h o l l o w s \, \text { from } \, y _ { \hat { x } } = H _ { \hat { x } } \hat { r } \, |
$$

since   we   have   assumed   that   G 0 is   the   identity.   It   follows   from   y x ˆ =   H 0 x ˆ +   O (ˆ x 2 )   and   f ˆ (ˆ x ) =   f ˆ (0)   +   2 1 x ˆ T H 0 x ˆ +   O (ˆ x 3 )   that,   given   ǫ   ∈   (0 , λ H, min ),   1   1 1  

$$
\hat { f } ( \hat { x } ) - \hat { f } ( 0 ) & = \frac { 1 } { 2 } y _ { \hat { x } } ^ { T } H _ { 0 } ^ { - 1 } y _ { \hat { x } } + O ( \hat { x } ^ { 3 } ) \leq \frac { 1 } { 2 } \frac { 1 } { \lambda _ { H , \min } - \epsilon } \| y _ { \hat { x } } \| ^ { 2 } \\ \text {holds for all } \hat { x } \text { sufficiently close to } 0 . \text { From } ( 4 . 2 0 ) \text { and } ( 4 . 2 1 ) , \text { we conclude}
$$

holds   for   all   ˆ x   suﬃciently   close   to   0.   From   (4.20)   and   (4.21),   we   conclude   that,   given   ǫ   ∈   (0 , λ H, min ),   1 1  

$$
f ( x ) - f ( x _ { * } ) & \leq \frac { 1 } { 2 } \frac { 1 } { \lambda _ { H , \min } - \epsilon } \langle \zeta _ { x } , \zeta _ { x } \rangle , \\ \intertext { h e r s i d e r l o w r e b o u n } & \quad \langle \zeta _ { x } , \zeta _ { x } \rangle , \, U s i n g \, ( 4 . 2 2 ) \, i n \, ( 4 . 1 9 ) \, \text { yields }
$$

which is the desired lower bound on 〈 ζ x , ζ x 〉 . Using (4.22) in (4.19) yields

$$
f ( R _ { x } ( t ^ { A } \zeta _ { x } ) ) - f ( x _ { * } ) \leq ( 1 - 2 ( \lambda _ { H , \min } - \epsilon ) \sigma t ^ { A } ) ( f ( x ) - f ( x _ { * } ) ) .
$$

We   now   turn   to   ﬁnding   a   lower   bound   on   the   Armijo   step   t A .   We   use   the   notation  

$$
\gamma _ { \hat { x } , u } ( t ) \colon = \hat { f } ( \hat { R } _ { \hat { x } } ( t u ) )
$$

and  

$$
h _ { x } ( t ) & = f ( R _ { x } ( - t \zeta _ { x } ) ) . \\ \L _ { x } ( t ) \text { and } t h o t \text { } \dot { h } \text { } ( 0 ) = \L _ { x } / \zeta
$$

− Notice   that   h x ( t ) =   γ x, − ˆ h x (0)   =   −  ζ x , ζ x     = ˙ ˆ (0),   from   ˆ ( t )   and   that   ˙ γ x, − ˆ ζ x ˆ ζ x ˆ which   it   follows   that   the   Armijo   condition   (4.19)   reads  

$$
h _ { x } ( t ^ { A } ) \leq h _ { x } ( 0 ) - \sigma t ^ { A } \dot { h } _ { x } ( 0 ) . \\ \intertext { d a l o w r b o u n d } \intertext { a l l o w r b o u n d }
$$

We   want   to   ﬁnd   a   lower   bound   on   t A .   From   a   Taylor   expansion   of   h x with   the   residual   in   Lagrange   form   (see   Appendix   A.6),   it   follows   that   the   t ’s   at   which   the   leftand   right-hand   sides   of   (4.24)   are   equal   satisfy  

$$
t = \frac { - 2 ( 1 - \sigma ) \dot { h } _ { x } ( 0 ) } { \ddot { h } _ { x } ( \tau ) } ,
$$

[Page 86]

where   τ   ∈   (0 , t ).   In   view   of   the   deﬁnition   of   the   Armijo   point,   we   conclude   that    

$$
t ^ { A } \geq \min \left ( \bar { \alpha } , \frac { - 2 \beta ( 1 - \sigma ) \dot { h } _ { x } ( 0 ) } { \max _ { \tau \in ( 0 , \bar { \alpha } ) } \ddot { h } _ { x } ( \tau ) } \right ) .
$$

Let   B δ :=   { x ˆ :     x ˆ     < δ }   and   M   :=  

$$
M \colon = \sup _ { \hat { x } \in B _ { \delta } , \| u \| = 1 , t \in ( 0 , \bar { \alpha } \| \hat { \zeta } _ { \hat { x } } \| ) } \ddot { \gamma } _ { \hat { x } , u } ( t ) .
$$

Then   max τ ∈ (0 , ¯ h ¨   x ζ x ˆ   2 .   Notice   also   that   γ ˆ (0)   =   u ≤ α ) ( τ )   ≤   M     ˆ ¨ x,u T H 0 u   λ H, max   u   2 ,   so   that   M   →   λ H, max as   δ   →   0.   Finally,   notice   that   h ˙ x (0)   =   − ζ ˆ x ˆ T G x ˆ ζ ˆ x ˆ =     ζ ˆ x ˆ   2 (1 +   O (ˆ x )).   Using   these   results   in   (4.25)   yields   that,   given   ǫ >   0,      

$$
t ^ { A } \geq \min \left ( \bar { \alpha } , \frac { 2 \beta ( 1 - \sigma ) } { \lambda _ { H , \max } + \epsilon } \right ) \\ \text {specificly close to } 0 \ x _ { * } ,
$$

holds   for   all   x   suﬃciently   close   to   x ∗ .  

We   can   now   combine   (4.26)   and   (4.23)   to   obtain   a   suitable   upper   bound   on   f ( R x ( t A ζ x )):  

$$
f ( R _ { x } ( t ^ { A } \zeta _ { x } ) ) - f ( x _ { * } ) \leq c _ { 1 } ( f ( x ) - f ( x _ { * } ) )
$$

with  

$$
c _ { 1 } = 1 - \sigma \min \left ( \bar { \alpha } , \frac { 2 \beta ( 1 - \sigma ) } { \lambda _ { H , \max } + \epsilon } \right ) 2 ( \lambda _ { H , \min } - \epsilon ) . \\ \text {fully, the bound } ( 4 . 2 7 ) , \, \text {along with the bound } ( 4 . 1 2 ) \, \text { is imposed}
$$

Finally,   the   bound   (4.27),   along   with   the   bound   (4.12)   imposed   on   the   value   of   f   at   the   next   iterate,   yields  

$$
value & \text { of } f \text { at the next iterate, yields } \\ & f ( x _ { k + 1 } ) - f ( x _ { * } ) = f ( x _ { k + 1 } ) - f ( x _ { k } ) + f ( x _ { k } ) - f ( x _ { * } ) \\ & \leq - c ( f ( x _ { k } ) - f ( R _ { x _ { k } } ( t ^ { A } _ { \zeta _ { x _ { k } } } ) ) ) + f ( x _ { k } ) - f ( x _ { * } ) \\ & = ( 1 - c ) ( f ( x _ { k } ) - f ( x _ { * } ) ) + c ( f ( R _ { x _ { k } } ( t ^ { A } _ { \zeta _ { x _ { k } } } ) ) - f ( x _ { * } ) ) \\ & \leq ( 1 - c + c _ { 1 } ) ( f ( x _ { k } ) - f ( x _ { * } ) ) \\ & = ( c _ { 1 } + ( 1 - c _ { 1 } ) ( 1 - c ) ) ( f ( x _ { k } ) - f ( x _ { * } ) ) , \\ \text {where } c \in ( 0 , 1 ) \text { is the constant in the bound } ( 4 . 1 2 ) . \quad \square
$$

where   c   ∈   (0 ,   1)   is   the   constant   in   the   bound   (4.12).  

# 4.6 RAYLEIGH QUOTIENT MINIMIZATION ON THE SPHERE

In   this   section   we   apply   algorithms   of   the   class   described   by   Algorithm   1   to   the   problem   of   ﬁnding   a   minimizer   of  

$$
f \colon S ^ { n - 1 } \to \mathbb { R } \colon x \mapsto x ^ { T } A x , \\ \intertext { f \colon S ^ { n - 1 } \to \mathbb { R } \colon x \mapsto x ^ { T } A x , } \text {will } \intertext { w i t i o n t h e p h o w s } T h e p h o w s \colon T h e p t i w i \colon ( i o e o w u m e d t h e b o w e r m o w )
$$

the   Rayleigh   quotient   on   the   sphere.   The   matrix   A   is   assumed   to   be   symmetric   ( A   =   A T )   but   not   necessarily   positive-deﬁnite.   We   let   λ 1 denote   the   smallest   eigenvalue   of   A   and   v 1 denote   an   associated   unit-norm   eigenvector.  

[Page 87]

# 4.6.1 Cost function and gradient calculation

Consider   the   function  

$$
\overline { f } \colon \mathbb { R } ^ { n } & \to \mathbb { R } \colon x \mapsto x ^ { T } A x , \\ \intertext { b e u n i t s p h e r e } \text { } S ^ { n - 1 } \text { } v i e l d s \, ( 4 \, 2 8 )
$$

whose   restriction   to   the   unit   sphere   S n − 1 yields   (4.28).   n − 1

We   view   S as   a   Riemannian   submanifold   of   the   Euclidean   space   R n endowed   with   the   canonical   Riemannian   metric  

$$
\bar { g } ( \xi , \zeta ) = \xi ^ { T } \zeta .
$$

Given x ∈ S n -1 , we have

$$
D \overline { f } \left ( x \right ) \left [ \zeta \right ] = \zeta ^ { T } A x + x ^ { T } A \zeta = 2 \zeta ^ { T } A x
$$

for   all   ζ   ∈   T x R n ≃   R n ,   from   which   it   follows,   recalling   the   deﬁnition   (3.31)   of   the   gradient,   that  

$$
\text {grad} \, \overline { f } ( x ) = 2 A x .
$$

The tangent space to S n -1 , viewed as a subspace of T x R n /similarequal R n , is

$$
T _ { x } S ^ { n - 1 } = \{ \xi \in \mathbb { R } ^ { n } \colon x ^ { T } \xi = 0 \} .
$$

The   normal   space   is  

$$
( T _ { x } S ^ { n - 1 } ) ^ { \perp } = \{ x \alpha \colon \alpha \in \mathbb { R } \} . \\ \text {cases on the $t$-augment and the non}
$$

The   orthogonal   projections   onto   the   tangent   and   the   normal   space   are  

$$
P _ { x } \xi = \xi - x x ^ { T } \xi , \quad P _ { x } ^ { \perp } \xi = x x ^ { T } \xi . \\ \text {the identity} \ ( 3 \ 3 7 ) \ r e l t i n g \ t h e \ r a d i e n t \ o n \ 2 \ s
$$

It   follows   from   the   identity   (3.37),   relating   the   gradient   on   a   submanifold   to   the   gradient   on   the   embedding   manifold,   that  

$$
\text {grad} \, f ( x ) = 2 P _ { x } ( A x ) = 2 ( A x - x x ^ { T } A x ) . \\ \text {formulas} \, \text {above} \, \text {are summized in Tabble} \, 1 \, \text { }
$$

The   formulas   above   are   summarized   in   Table   4.1.  

# 4.6.2 Critical points of the Rayleigh quotient

To   analyze   an   algorithm   based   on   the   Rayleigh   quotient   cost   on   the   sphere,   the   ﬁrst   step   is   to   characterize   the   critical   points.  

Proposition 4.6.1 Let A   =   A T be an n × n   symmetric matrix. A unit-norm vector x   ∈   R n is an eigenvector of A   if and only if it is a critical point of the Rayleigh quotient (4.28) .

    Proof. Let   x   be   a   critical   point   of   (4.28),   i.e.,   grad   f ( x )   =   0   with   x   ∈   S n − 1 .   From   the   expression   (4.29)   of   grad   f ( x ),   it   follows   that   x   statisﬁes   Ax   =   ( x T Ax ) x ,   where   x T Ax   is   a   scalar.   Conversely,   if   x   is   a   unit-norm   eigenvector   of   A ,   i.e.,   Ax   =   λx   for   some   scalar   λ ,   then   a   left   multiplication   by   x T yields   λ   =   x T Ax   and   thus   Ax   = ( x T Ax ) x ,   hence   grad   f ( x )   =   0   in   view   of   (4.29).  

We   already   know   from   Proposition   2.1.1   that   the   two   points   ± v 1 corresponding   to   the   “leftmost”   eigendirection   are   the   global   minima   of   the   Rayleigh   quotient   (4.28).   Moreover,   the   other   eigenvectors   are   not   local   minima:  

[Page 88]

Table 4.1 Rayleigh quotient on the unit sphere.

| |Manifold   ( S n − 1 )  |Embedding   space   ( R n )  |
|---|---|---|
|cost|=   x T Ax ,   x   ∈   S n − 1 f|( x ) =   x T Ax ,   x   ∈   R n T|
|metric  |induced   metric   R n T|g ( ξ, ζ ) =   ξ ζ   R n|
|tangent space|ξ ∈ R n : x T ξ = 0|R n|
|normal space|ξ ∈ R n : ξ = αx|∅|
|projection onto tangent space|P x ξ = ( I - xx T ) ξ|identity|
|gradient   grad|  f ( x ) = P x grad   f ( x )  |grad   f ( x ) = 2 Ax  |
|retraction   R|x ( ξ )   =   qf( x   +   ξ )  |R x ( ξ ) =   x   +   ξ  |


Proposition 4.6.2 Let A   =   A T be an n   ×   n   symmetric matrix with eigenvalues λ 1 ≤ ≤   λ n and associated orthonormal eigenvectors v 1 , . . . , v n . ···   Then

- (i) ± v 1 are local and global minimizers of the Rayleigh quotient (4.28) ; if the eigenvalue λ 1 is simple, then they are the only minimizers.
- (ii) ± v n are local and global maximizers of (4.28) ; if the eigenvalue λ n is simple, then they are the only maximizers.
- (iii) ± v q corresponding to interior eigenvalues (i.e., strictly larger than λ 1 and strictly smaller than λ n ) are saddle points of (4.28) .


Proof. Point   (i)   follows   from   Proposition   2.1.1.   Point   (ii)   follows   from   the   same   proposition   by   noticing   that   replacing   A   by   − A   exchanges   maxima   with   minima   and   leftmost   eigenvectors   with   rightmost   eigenvectors.   For   point   (iii),   let   v q be   an   eigenvector   corresponding   to   an   interior   eigenvalue   λ q and   consider   the   curve   γ   :   t    →   ( v q +   tv 1 ) /   v q +   tv 1   .   Simple   calculus   shows   that   2

$$
\frac { d ^ { 2 } } { d t ^ { 2 } } ( f ( \gamma ( t ) ) | _ { t = 0 } = \lambda _ { 1 } - \lambda _ { q } < 0 .
$$

Likewise,   for   the   curve   γ   :   t    →   ( v q +   tv n ) /   v q +   tv n   ,   we   have   2

$$
\frac { d ^ { 2 } } { d t ^ { 2 } } ( f ( \gamma ( t ) ) | _ { t = 0 } = \lambda _ { n } - \lambda _ { q } > 0 .
$$

It   follows   that   v q is   a   saddle   point   of   the   Rayleigh   quotient   f .      

It   follows   from   Proposition   4.6.1   and   the   global   convergence   analysis   of   line-search   methods   (Proposition   4.3.1)   that   all   methods   within   the   class   of   Algorithm   1   produce   iterates   that   converge   to   the   set   of   eigenvectors   of   A .   Furthermore,   in   view   of   Proposition   4.6.1,   and   since   we   are   considering  

[Page 89]

Hereafter   we   consider   the   instances   of   Algorithm   1   where  

$$
\eta _ { k } \colon = - \text {grad} \, f ( x _ { k } ) = 2 ( A x _ { k } - x _ { k } x _ { k } ^ { T } A x _ { k } ) . \\ \ t h o t \, + \, \text {this above, of course, division, is, symmetric} \, \ r o l o t \, + \, \ r o l o t \, + \, \ r o l o t
$$

It   is   clear   that   this   choice   of   search   direction   is   gradient-related.   Next   we   have   to   pick   a   retraction.   A   reasonable   choice   is   (see   Example   4.1.1)  

$$
R _ { x } ( \xi ) \coloneqq \frac { x + \xi } { \| x + \xi \| } , \\ \intertext { h e f u c l i d e a n p o r m i p $ \mathbb { R } ^ { n } $ }
$$

  x   +   ξ     where     ·     denotes   the   Euclidean   norm   in   R n ,     y     :=     y T y .   Another   possibility   is   ξ  

$$
R _ { x } ( \xi ) \colon = x \cos \| \xi \| + \frac { \xi } { \| \xi \| } \sin \| \xi \| , \\ \text {one curve} \ t \mapsto R _ { x } ( t \xi ) \text { is a big circle on the sphere. (The second}
$$

for   which   the   curve   t    →   R x ( tξ )   is   a   big   circle   on   the   sphere.   (The   second   retraction   corresponds   to   the   exponential   mapping   deﬁned   in   Section   5.4.)  

# 4.6.3 Armijo line search

We   now   have   all   the   necessary   ingredients   to   apply   a   simple   backtracking   in
 stance   of   Algorithm   1   to   the   problem   of   minimizing   the   Rayleigh   quotient   on 
 the   sphere   S n − 1 .   This   yields   the   matrix   algorithm   displayed   in   Algorithm   2. 
 Note   that   with   the   retraction   R   deﬁned   in   (4.30),   the   function   f ( R x k ( tη k )) 
 is   a   quadratic   rational   function   in   t .   Therefore,   the   Armijo   step   size   is   easily 
 computed   as   an   expression   of   the   reals   η k T η k ,   η k T Aη k ,   x k T Aη k ,   and   x k T Ax k . 


# Algorithm 2 Armijo   line   search   for   the   Rayleigh   quotient   on   S n − 1

Require: Symmetric matrix A , scalars α > 0, β, σ ∈ (0 , 1).

Initial iterate x 0 , ‖ x 0 ‖ = 1.

Input:

Sequence of iterates { x k } .

Output:

- 1: for k = 0 , 1 , 2 , . . . do
- 2: Compute η k = - 2( Ax k - x k x k T Ax k ).
- 3: Find the smallest integer m ≥ 0 such that


$$
f \left ( R _ { x _ { k } } \left ( \overline { \alpha } \beta ^ { m } \eta _ { k } \right ) \right ) & \leq f ( x _ { k } ) - \sigma \overline { \alpha } \beta ^ { m } \eta _ { k } ^ { T } \eta _ { k } , \\ c _ { k } \colon _ { 1 } \colon _ { 0 } ( \sigma _ { 0 } ) _ { 1 } \colon _ { 1 } D _ { k } \colon _ { 1 } ( \sigma _ { 0 } ) _ { 0 } \colon _ { 1 } ( \sigma _ { k } ) _ { k } ,
$$

with   f   deﬁned   in   (4.28)   and   R   deﬁned   in   (4.30).  

- 4:   Set  

$$
x _ { k + 1 } = R _ { x _ { k } } ( \overline { \alpha } \beta ^ { m } \eta _ { k } ) .
$$

- 5:   end for


Numerical   results   for   Algorithm   2   are   presented   in   Figure   4.3   for   the   case   A   =   diag(1 ,   2 , . . . ,   100),   σ   = 0 . 5,   α   =   1,   β   = 0 . 5.   The   initial   point   x 0 is   chosen   from   a   uniform   distribution   on   the   sphere.   (The   point   x 0 is   obtained   by   normalizing   a   vector   whose   entries   are   selected   from   a   normal   distribution).  

[Page 90]

Let   us   evaluate   the   upper   bound   r ∗   on   the   linear   convergence   factor   given   by   Theorem   4.5.6.   The   extreme   eigenvalues   λ H, min and   λ H, max of   the   Hessian   at   the   solution   v 1 can   be   obtained   as  

$$
\begin{array} { r l } & { e n t i o n v _ { 1 } c a n b e o b t a i n d \lambda _ { H , \min } a n d \lambda _ { H , \max } o n t i o n v _ { 1 } c a n b e o b t a i n d as } \\ & { \quad } & { \lambda _ { H , \min } = \min _ { v _ { 1 } ^ { T } u = 0 , u ^ { T } u = 1 } \frac { d ^ { 2 } ( f ( \gamma _ { v _ { 1 } , u } ( t ) ) ) } { d t ^ { 2 } } \Big | _ { t = 0 } } \\ & { \quad } & { \lambda _ { H , \max } = \max _ { v _ { 1 } ^ { T } u = 0 , u ^ { T } u = 1 } \frac { d ^ { 2 } ( f ( \gamma _ { v _ { 1 } , u } ( t ) ) ) } { d t ^ { 2 } } \Big | _ { t = 0 } , } \\ & { \quad } & { \gamma _ { v _ { 1 } , u } ( t ) \colon = R _ { v _ { 1 } } ( t u ) = \frac { v _ { 1 } + t u } { \| v _ { 1 } + t u \| } . } \end{array}
$$

where  

$$
\gamma _ { v _ { 1 } , u } ( t ) \colon = R _ { v _ { 1 } } ( t u ) = \frac { v _ { 1 } + t u } { \| v _ { 1 } + t u \| } .
$$

This   yields  

$$
\frac { d ^ { 2 } ( f ( \gamma _ { v _ { 1 } , u } ( t ) ) ) } { d t ^ { 2 } } | _ { t = 0 } & = 2 ( u ^ { T } A u - \lambda _ { 1 } ) \\ \\ \lambda _ { H , \min } = \lambda _ { 2 } - \lambda _ { 1 } , & \quad \lambda _ { H , \max } = \lambda _ { n } - \lambda _ { 1 } .
$$

and   thus  

$$
\lambda _ { H , \min } & = \lambda _ { 2 } - \lambda _ { 1 } , \quad \lambda _ { H , \max } = \lambda _ { n } - \lambda _ { 1 } . \\ \cdot 1 _ { n } & = 1 \quad \cdot 1 _ { 1 } \quad 1 \quad \cdot \iota _ { n } \ \iota _ { 1 } \quad \cdot 1 _ { 1 } + \omega _ { 1 } + 1 _ { 1 } .
$$

For   the   considered   numerical   example,   it   follows   that   the   upper   bound   on   the   linear   convergence   factor   given   by   Theorem   4.5.6   is   r ∗   = 0 . 9949 ... .   The   convergence   factor   estimated   from   the   experimental   result   is   below   0 . 97,   which   is   in   accordance   with   Theorem   4.5.6.   This   poor   convergence   factor,   very   close   to   1,   is   due   to   the   small   value   of   the   ratio  

$$
\frac { \lambda _ { H , \min } } { \lambda _ { H , \max } } = \frac { \lambda _ { 2 } - \lambda _ { 1 } } { \lambda _ { n } - \lambda _ { 1 } } \approx 0 . 0 1 .
$$

The   convergence   analysis   of   Algorithm   2   is   summarized   as   follows.  

Theorem 4.6.3 Let { x k }   be an inﬁnite sequence of iterates generated by Algorithm 2. Let λ 1 ≤   ···   ≤   λ n denote the eigenvalues of A .    

- (i) The sequence { x k } converges to the eigenspace of A associated to some eigenvalue.
- (ii) The eigenspace related to λ 1 is an attractor of the iteration deﬁned by Algorithm 2. The other eigenspaces are unstable.
- (iii) Assuming that the eigenvalue λ 1 is simple, the linear convergence factor to the eigenvector ± v 1 associated with λ 1 is smaller or equal to    


$$
r _ { * } = 1 - 2 \sigma ( \lambda _ { 2 } - \lambda _ { 1 } ) \min \left ( \overline { \alpha } , \frac { 2 \beta ( 1 - \sigma ) } { \lambda _ { n } - \lambda _ { 1 } } \right ) . \\ \intertext { s . ( i ) } \text { and } ( i j i ) \text { follow directly from the convergence analysis }
$$

Proof. Points   (i)   and   (iii)   follow   directly   from   the   convergence   analysis   of   the   general   Algorithm   1   (Theorems   4.3.1   and   4.5.6).   For   (ii),   let   S 1 :=   { x   ∈ S n − 1 :   Ax   =   λ 1 x }   denote   the   eigenspace   related   to   λ 1 .   Any   neighborhood   of   S 1 contains   a   sublevel   set   L   of   f   such   that   the   only   critical   points   of   f   in   L   are   the   points   of   S 1 .   Any   sequence   of   Algorithm   2   starting   in   L   converges   to   S 1 .   The   second   part   follows   from   Theorem   4.4.1.      

[Page 91]

# 4.6.4 Exact line search

In   this   version   of   Algorithm   1,   x k +1 is   selected   as   R x k ( t k η k ),   where  

$$
t _ { k } \colon = \arg \min _ { t > 0 } f ( R _ { x _ { k } } ( t \eta _ { k } ) ) .
$$

  We   consider   the   case   of   the   projected   retraction   (4.30),   and   we   deﬁne   again   η k :=   − grad   f ( x k ).   It   is   assumed   that   grad   f ( x k )   =   0,   from   which   it   also   follows   that   η T Ax k =   0.   An   analysis   of   the   function     t    →   f ( R x k ( tη k ))   reveals   k that   it   admits   one   and   only   one   minimizer   t k >   0.   This   minimizer   is   the   positive   solution   of   a   quadratic   equation.   In   view   of   the   particular   choice   of   the   retraction,   the   points   ± R x k ( t k η k )   can   also   be   expressed   as   arg min   f ( x ) ,  

/negationslash is arguably the simplest method for eigenvector computation. Let A be a symmetric matrix, assume that there is an eigenvalue λ that is simple and larger in absolute value than all the other eigenvalues, and let v denote the corresponding eigenvector. Then the power method converges to ± v for almost all initial points x 0 .

/negationslash

$$
\arg \min _ { x \in S ^ { n - 1 } , x \in \text {span} \{ x _ { k } , \eta _ { k } \} } f ( x ) ,
$$

which   are   also   equal   to  

$$
\pm X w , \\ \dot { \cdot } _ { i }
$$

where   X   :=   [ x k ,     η k     η k ]   and   w   is   a   unit-norm   eigenvector   associated   with   the   smaller   eigenvalue   of   the   interaction   matrix   X T AX .  

Numerical   results   are   presented   in   Figure   4.3.   Note   that   in   this   example   the   distance   to   the   solution   as   a   function   of   the   number   of   iterates   is   slightly   better   with   the   selected   Armijo   method   than   with   the   exact   linesearch   method.   This   may   seem   to   be   in   contradiction   to   the   fact   that   the   exact   line-search   method   chooses   the   optimal   step   size.   However,   the   exact   minimization   only   implies   that   if   the   two   algorithms   start   at   the   same   point   x 0 ,   then   the   cost function will   be   lower   at   the   ﬁrst iterate   of   the   exact   linesearch   method   than   at   the   ﬁrst iterate   of   the   Armijo   method.   This   does   not   imply   that   the   distance   to   the   solution   will   be   lower   with   the   exact   line   search.   Neither   does   it   mean   that   the   exact   line   search   will   achieve   a   lower   cost   function   at   subsequent   iterates.   (The   ﬁrst   step   of   the   Armijo   method   may   well   produce   an   iterate   from   which   a   larger   decrease   can   be   obtained.)  

# 4.6.5 Accelerated line search: locally optimal conjugate gradient

In   this   version   of   Algorithm   1,   η k is   selected   as   − grad   f ( x k )   and   x k +1 is   selected   as   R x k ( ξ k ),   where   ξ k is   a   minimizer   over   the   two-dimensional   subspace   of   T x k M   spanned   by   η k and   R − 1 ( x k − 1 ),   as   described   in   (4.13).   When   x k applied   to   the   Rayleigh   quotient   on   the   sphere,   this   method   reduces   to   the   locally   optimal   conjugate-gradient   (LOCG)   algorithm   of   A.   Knyazev.   Its   fast   convergence   (Figure   4.3)   can   be   explained   by   its   link   with   conjugate-gradient   (CG)   methods   (see   Section   8.3).  

# 4.6.6 Links with the power method and inverse iteration

The   power   method,  

$$
x _ { k + 1 } = \frac { A x _ { k } } { \| A x _ { k } \| } ,
$$

[Page 92]

![The image is a line graph titled DISTRIBUTION. The x-axis represents the range of values, ranging from 0 to 100, while the y-axis represents the values of a variable, which is not specified in the image. The graph is titled DISTRIBUTION and has a legend at the top of the graph. The graph has a linear scale from 0 to 100 on the x-axis, with a minimum of 0 and a maximum of 100 on the y-axis. The graph has a linear scale from 0 to 100 on the x-axis, with a minimum of 0 and a maximum of 100 on the y-axis. The graph has a trend of decreasing values as the x-axis increases. The line starts at a value of 0 and decreases to a value of 100. The line then increases again to a](<images/imageFile16.png>)

2

10

Armijo    

Exact

2D−Exact  

0

10

-2

10

dist to solution  

-4

10

-6

10

-8

10

0  

10  

20  

30  

40  

50

60  

70  

80  

90  

100  

k

Figure 4.3 Minimization of the Rayleigh quotient of A = diag(1 , 2 , . . . , n ) on S n − 1   , with n = 100. The distance to the solution is deﬁned as the angle between the direction of the current iterate and the eigendirection associated with the smallest eigenvalue of A .

0 We   mention,   as   a   curiosity,   a   relation   between   the   power   method   and   the   steepest-descent   method   for   the   Rayleigh   quotient   on   the   sphere.   Using   the   projective   retraction   (4.30),   the   choice   t k =   2 x T 1 Ax k yields   k

k

$$
R _ { x _ { k } } ( t _ { k } \, \text {grad} \, f ( x _ { k } ) ) = \frac { \overset { A } { A } x _ { k } } { \| A x _ { k } \| } ,
$$

i.e.,   the   power   method.  

There   is   no   such   relation   for   the   inverse   iteration   − 1

$$
x _ { k + 1 } & = \frac { A ^ { - 1 } x _ { k } } { \| A ^ { - 1 } x _ { k } \| } . \\ \text {in general much more}
$$

    In   fact,   inverse   iteration   is   in   general   much   more   expensive   computationally   than   the   power   method   since   the   former   requires   solving   a   linear   system   of   size   n   at   each   iteration   while   the   latter   requires   only   a   matrix-vector   multiplication.   A   comparison   between   inverse   iteration   and   the   previous   direct   methods   in   terms   of   the   number   of   iterations   is   not   informative   since   an   iteration   of   inverse   iteration   is   expected   to   be   computationally   more   demanding   than   an   iteration   of   the   other   methods.  

[Page 93]

# 4.7 REFINING EIGENVECTOR ESTIMATES

All   the   critical   points   of   the   Rayleigh   quotient   correspond   to   eigenvectors   of   A ,   but   only   the   extreme   eigenvectors   correspond   to   extrema   of   the   cost   function.   For   a   given   cost   function   f ,   it   is,   however,   possible   to   deﬁne   a   new   cost   function   that   transforms   all critical   points   of   f   into   (local)   minimizers.   The   new   cost   function   is   simply   deﬁned   by  

$$
\tilde { f } ( x ) \colon = \| g r a d \, f ( x ) \| ^ { 2 } . \\ \intertext { f t h e r $ B $ v e i g h $ a u t i o n $ ( 4 $ 2 8 $ ) $ }
$$

In   the   particular   case   of   the   Rayleigh   quotient   (4.28),   one   obtains  

$$
\tilde { f } \colon S ^ { n - 1 } & \to \mathbb { R } \colon x \mapsto \| P _ { x } A x \| ^ { 2 } = x ^ { T } A P _ { x } A x = x ^ { T } A ^ { 2 } x - ( x ^ { T } A x ) ^ { 2 } , \\ \text {where } P \ & - ( I = r x ^ { T } ) \text { is the orthogonal projection on the tangent space}
$$

where   P x = ( I   −   xx T )   is   the   orthogonal   projector   onto   the   tangent   space   T x S n − 1 =   { ξ   ∈   R n :   x T ξ   = 0 } .   Following   again   the   development   in   Section   3.6.1,   we   deﬁne   the   function  

$$
\overline { f } \colon \mathbb { R } ^ { n } & \to \mathbb { R } \colon x \mapsto x ^ { T } A ^ { 2 } x - ( x ^ { T } A x ) ^ { 2 } \\ t i o n \, t o \, S ^ { n - 1 } \, & \text {is} \, \tilde { f } \ W e o b t { a i n }
$$

→  → whose   restriction   to   S n − 1 is   f ˜ .   We   obtain  

$$
\text {grad} \, \bar { f } ( x ) = 2 ( A ^ { 2 } x - 2 A x x ^ { T } A x ) ,
$$

hence  

$$
\text {grad} \, \tilde { f } ( x ) = P _ { x } ( \text {grad} \, \bar { f } ( x ) ) = 2 P _ { x } ( A A x - 2 A x x ^ { T } A x ) . \\ \text {impling} \, a \, \text {line search method} \, \text {to the} \, \text {eff} \, \tilde { \ f } \text { provides} \, a \, \text { degree} \, x
$$

− Applying   a   line-search   method   to   the   cost   function   f ˜   provides   a   descent   algorithm   that   (locally)   converges   to   any   eigenvector   of   A .  

# 4.8 BROCKETT COST FUNCTION ON THE STIEFEL MANIFOLD

Following   up   on   the   study   of   descent   algorithms   for   the   Rayleigh   quotient   on   the   sphere,   we   now   consider   a   cost   function   deﬁned   as   a   weighted   sum T   i µ i x ( i ) Ax ( i ) of   Rayleigh   quotients   on   the   sphere   under   an   orthogonality   constraint,   x T ( i ) x ( j ) =   δ ij .  

# 4.8.1 Cost function and search direction

The   cost   function   admits   a   more   friendly   expression   in   matrix   form:  

$$
f \colon & S t ( p , n ) \to \mathbb { R } \colon X \mapsto \text {tr} ( X ^ { T } A X N ) , \\ = \text {diag} ( \mu _ { 0 } , \dots , \mu _ { n } ) \text { } \text { with } 0 < \mu _ { 0 } < \dots < \mu _ { n } \text { and } S t ( p _ { n } ) \text { denotes}
$$

where   N   =   diag( µ 1 ,   , µ p ),   with   0   ≤   µ 1 ≤   . . .   ≤   µ p ,   and   St( p, n )   denotes   ···   the   orthogonal   Stiefel   manifold  

$$
S t ( p , n ) = \{ X \in \mathbb { R } ^ { n \times p } \colon X ^ { T } X = I _ { p } \} . \\ \intertext { o n $ 3 $ 2 $ 3 $ 2 $ w e v i w $ S t ( p , n ) $ a s $ an e m b e d d e d $ s u b m }
$$

As   in   Section   3.3.2,   we   view   St( p, n )   as   an   embedded   submanifold   of   the   Euclidean   space   R n × p .   The   tangent   space   is   (see   Section   3.5.7)  

$$
T _ { X } \, S t ( p , n ) & = \{ Z \in \mathbb { R } ^ { n \times p } \colon X ^ { T } Z + Z ^ { T } X = 0 \} \\ & = \{ X \Omega + X _ { \perp } K \colon \, \Omega ^ { T } = - \Omega , \ K \in \mathbb { R } ^ { ( n - p ) \times p } \} .
$$

[Page 94]

We   further   consider   St( p, n )   as   a   Riemannian   submanifold   of   R n × p endowed   with   the   canonical   inner   product    

$$
\langle Z _ { 1 } , Z _ { 2 } \rangle \colon = & \text { tr } \left ( Z _ { 1 } ^ { T } Z _ { 2 } \right ) .
$$

It   follows   that   the   normal   space   to   St( p, n )   at   a   point   X   is  

$$
( T _ { X } \, S t ( p , n ) ) ^ { \perp } & = \{ X S \colon \, S ^ { T } = S \} . \\ \vdots \, & \quad \vdots \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \,
$$

The   orthogonal   projection   P X onto   T X St( p, n )   is   given   by  

where  

$$
P _ { X } Z = Z - X \, \text {sym} ( X ^ { T } Z ) = ( I - X X ^ { T } ) Z + X \, \text {skew} ( X ^ { T } Z ) , \\
$$

$$
\ s y m ( M ) \colon = \frac { 1 } { 2 } ( M + M ^ { T } ) , \quad \ s k e w ( M ) = \frac { 1 } { 2 } ( M - M ^ { T } )
$$

$$
M ) \colon = \frac { 1 } { 2 } ( M + M ^ { T } ) , \quad \text {skew} ( M ) = \frac { 1 } { 2 } ( M - M ^ { T } ) \\
$$

denote   the   symmetric   part   and   the   skew-symmetric   part   of   the   decomposition   of   M   into   a   symmetric   and   a   skew-symmetric   term.  

Consider   the   function  

$$
\bar { f } \colon \mathbb { R } ^ { n \times p } \to \mathbb { R } \colon X \mapsto t r ( X ^ { T } A X N ) , \\
$$

so that f = f ∣ ∣ St( p,n ) . We have

$$
D \overline { f } \left ( X \right ) \left [ Z \right ] & = 2 \ t r \left ( Z ^ { T } A X N \right ) , \\
$$

hence  

$$
\text {grad} \, \overline { f } ( X ) = 2 A X N
$$

and  

$$
g r a d \, f ( X ) & = P _ { X } \, g r a d \, \bar { f } ( X ) \\ & = 2 A X N - 2 X \, \text {sym} ( X ^ { T } A X N ) \\ & = 2 A X N - X X ^ { T } A X N - X N X ^ { T } A X . \\ \text {remains to select a retraction. Choices are proposed in Section 4}
$$

It   remains   to   select   a   retraction.   Choices   are   proposed   in   Section   4.1.1,   such   as  

$$
R _ { X } ( \xi ) \colon = q f ( X + \xi ) .
$$

This   is   all   we   need   to   turn   various   versions   of   the   general   Algorithm   1   into   practical   matrix   algorithms   for   minimizing   the   cost   fuction   (4.32)   on   the   orthogonal   Stiefel   manifold.  

# 4.8.2 Critical points

We   now   show   that   X   is   a   critical   point   of   f   if   and   only   if   the   columns   of   X   are   eigenvectors   of   A .  

The   gradient   of   f   admits   the   expression  

$$
\text {grad} \, f ( X ) & = 2 ( I - X X ^ { T } ) A X N + 2 X \, \text {skew} ( X ^ { T } A X N ) \\ & = 2 ( I - X X ^ { T } ) A X N + X [ X ^ { T } A X , N ] ,
$$

[Page 95]

Table 4.2 Brockett cost function on the Stiefel manifold.

| |Manifold (St( p, n )) T T|Total space ( R n × p ) T n × p|
|---|---|---|
|cost|AXN ), X X = I p|tr( X AXN ), X ∈ R T|
|metric R|induced metric n × p T|  Z 1 , Z 2   = tr( Z 1   Z 2 ) R n × p|
|tangent space|Z ∈ R n × p : sym( X T Z ) = 0|R n × p|
|normal space|Z ∈ R n × p : Z = XS, S T = S|∅|
|projection onto tangent space|P X Z = Z - X sym( X T Z )|identity|
|gradient grad f|( X ) = P X grad f ( X )|grad f ( X ) = 2 AXN|
|retraction R X|( Z ) = qf( X + Z )|R X ( Z ) = X + Z|


where  

$$
[ A , B ] \colon = A B - B A
$$

denotes   the   (matrix)   commutator   of   A   and   B .   Since   the   columns   of   the   ﬁrst   term   in   the   expression   of   the   gradient   belong   to   the   orthogonal   complement   of   span( X ),   while   the   columns   of   the   second   term   belong   to   span( X ),   it   follows   that   grad   f ( X )   vanishes   if   and   only   if  

and  

$$
( I - X X ^ { T } ) A X N = 0
$$

$$
[ X ^ { T } A X , N ] = 0 .
$$

Since   N   is   assumed   to   be   invertible,   equation   (4.34)   yields  

which   means   that  

$$
( I - X X ^ { T } ) A X = 0 ,
$$

$$
A X = X M
$$

for   some   M .   In   other   words,   span( X )   is   an   invariant   subspace   of   A .   Next,   in   view   of   the   speciﬁc   form   of   N ,   equation   (4.35)   implies   that   X T AX   is   diagonal   which,   used   in   (4.36),   implies   that   M   is   diagonal,   hence   the   columns   of   X   are   eigenvectors   of   A .   Showing   conversely   that   any   such   X   is   a   critical   point   of   f   is   straightfoward.  

In   the   case   p   =   n ,   St( n, n ) =   O n ,   and   critical   points   of   the   Brockett   cost   function   are   orthogonal   matrices   that   diagonalize   A .   (Note   that   I   −   XX T =   0,   so   the   ﬁrst   term   in   (4.33)   trivially   vanishes.)   This   is   equivalent   to   saying   that   the   columns   of   X   are   eigenvectors   of   A .  

[Page 96]

# 4.9 RAYLEIGH QUOTIENT MINIMIZATION ON THE GRASSMANN MANIFOLD

Finally,   we   consider   a   generalized   Rayleigh   quotient   cost   function   on   the   Grassmann   manifold.   The   Grassmann   manifold   is   viewed   as   a   Riemannian   quotient   manifold   of   R n ∗ × p ,   which   allows   us   to   exploit   the   machinery   for   steepest-descent   methods   on   quotient   manifolds   (see,   in   particular,   Sections   3.4,   3.5.8,   3.6.2,   and   4.1.2).  

# 4.9.1 Cost function and gradient calculation

We   start   with   a   review   of   the   Riemannian   quotient   manifold   structure   of   the   Grassmann   manifold   (Section   3.6.2).   Let   the   structure   space   M   be   the   noncompact   Stiefel   manifold   R n ∗ × p =   { Y   ∈   R n × p :   Y   full   rank } .   We   consider   on   M   the   equivalence   relation   R n × p

$$
X \sim Y \quad & \Leftrightarrow \quad \exists M \in \mathbb { R } _ { * } ^ { n \times p } \colon Y = X M . \\ \intertext { l } 1 _ { \ } + \intertext { l } X \sim Y \quad & \Leftrightarrow \quad \exists M \in \mathbb { R } _ { * } ^ { n \times p } \colon Y = X M . \\
$$

In   other   words,   two   elements   of   R n ∗ × p belong   to   the   same   equivalence   class   if   and   only   if   they   have   the   same   column   space.   There   is   thus   a   one-to-one   correspondence   between   R n ∗ × p /   ∼   and   the   set   of   p -dimensional   subspaces   of   R n .   The   set   R ∗   n × p /   ∼   has   been   shown   (Proposition   3.4.6)   to   admit   a   unique   structure   of   quotient   manifold,   called   the   Grassmann   manifold   and   denoted   by   Grass( p, n )   or   R ∗   n × p / GL p .   Moreover,   R ∗   n × p / GL p has   been   shown   (Section   3.6.2)   to   have   a   structure   of   Riemannian   quotient   manifold   when   R n ∗ × p is   endowed   with   the   Riemannian   metric    

$$
\bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) = & \text { tr } ( ( Y ^ { T } Y ) ^ { - 1 } Z _ { 1 } ^ { T } Z _ { 2 } ) \, . \\ \intertext { a c e a t Y is by definition the t a n g e n t s p a c e t o t } ( Y ) ) = & \, \{ Y M \colon M \in \mathbb { P } ^ { p \times p } \} \quad \text {which yields}
$$

The   vertical   space   at   Y   is   by   deﬁnition   the   tangent   space   to   the   equivalence   class   of   π − 1 ( π ( Y   ))   =   { Y M   :   M   ∈   R p ∗ × p } ,   which   yields   R p × p

$$
\mathcal { V } _ { Y } = \{ Y M \colon M \in \mathbb { R } ^ { p \times p } \} . \\
$$

The   horizontal   space   at   Y   is   deﬁned   as   the   orthogonal   complement   of   the   vertical   space   with   respect   to   the   metric   g ,   which   yields  

$$
\mathcal { H } _ { Y } = \{ Z \in \mathbb { R } ^ { n \times p } \colon Y ^ { T } Z = 0 \} . \\
$$

Given   ξ   ∈   T span( Y ) Grass( p, n ),   there   exists   a   unique   horizontal   lift   ξ Y ∈   T Y R n ∗ × p satisfying  

Since In other words, the canonical projection π is a Riemannian submersion from ( R n ∗ × p , g ) to (Grass( p, n ) , g ).

$$
D \pi ( Y ) [ \bar { \xi } _ { Y } ] = \xi .
$$

$$
\bar { g } ( \bar { \xi } _ { Y M } , \bar { \zeta } _ { Y M } ) = \bar { g } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } )
$$

for   all   M   ∈   R p ∗ × p ,   it   follows   that   (Grass( p, n ) , g )   is   a   Riemannian   quotient   manifold   of   ( R n ∗ × p , g )   with  

$$
g _ { \text {span} ( Y ) } ( \xi , \zeta ) \colon = \bar { g } _ { Y } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } ) .
$$

[Page 97]

∗ Let   A   be   an   n   ×   n   symmetric   matrix,   not   necessarily   positive-deﬁnite.   Consider   the   cost   function   on   the   total   space   R n ∗ × p deﬁned   by  

$$
\overline { f } \colon \mathbb { R } _ { * } ^ { n \times p } \to \mathbb { R } \colon Y & \mapsto \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) . \\ \overline { f } ( Y M ) \, = \, \overline { f } ( Y ) \, \text { whenever } \, M \, \in \, \mathbb { R } _ { * } ^ { p \times p } , \, \text { it follows that } \, \overline { f } \text { includes a }
$$

Since   f ( Y M ) =   f ( Y   )   whenever   M   ∈   R ∗   p × p ,   it   follows   that   f   induces   a   function   f   on   the   quotient   Grass( p, n )   such   that   f   =   f π .   The   function   f ◦ can   be   described   as  

$$
c a n b o d e r a b e d a & = a \\ f \colon & G r a s ( p , n ) \to \mathbb { R } \colon \text {span} ( Y ) \mapsto t r \left ( ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) . \\ \intertext { This function can be thought of as a generalized Rayleigh quotient. Since \bar { f } }
$$

This   function   can   be   thought   of   as   a   generalized   Rayleigh   quotient.   Since   f   is   smooth   on   R n ∗ × p ,   it   follows   from   Proposition   3.4.5   that   f   is   a   smooth   cost   function   on   the   quotient   Grass( p, n ).  

In   order   to   obtain   an   expression   for   the   gradient   of   f ,   we   will   make   use   of   the   trace   identities   (A.1)   and   of   the   formula   (A.3)   for   the   derivative   of   the   inverse   of   a   matrix.   For   all   Z   ∈   R n × p ,   we   have    

$$
D \bar { f } \left ( Y \right ) \left [ Z \right ] & = \text {tr} \left ( - ( Y ^ { T } Y ) ^ { - 1 } ( Z ^ { T } Y + Y ^ { T } Z ) ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) \\ & + \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Z ^ { T } A Y \right ) + \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Z \right ) . \\ \text {For the last term, we have, using the two properties (A.1) of the trace,}
$$

For   the   last   term,   we   have,   using   the   two   properties   (A.1)   of   the   trace,  

$$
& \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Z \right ) = \text {tr} \left ( Z ^ { T } A Y ( Y ^ { T } Y ) ^ { - 1 } \right ) = \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Z ^ { T } A Y \right ) . \\ & \text {Using the same properties, the first term can be rewritten as}
$$

Using   the   same   properties,   the   ﬁrst   term   can   be   rewritten   as  

$$
- 2 \ t r \left ( ( Y ^ { T } Y ) ^ { - 1 } Z ^ { T } Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) . \\ \intertext { f o r s u l t s i n ( 4 . 3 9 ) y i e l d s }
$$

Replacing   these   results   in   (4.39)   yields  

$$
D \bar { f } \left ( Y \right ) \left [ Z \right ] & = \text {tr} \left ( \left ( Y ^ { T } Y \right ) ^ { - 1 } Z ^ { T } \, 2 ( A Y - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y ) \right ) \\ & = \bar { g } _ { Y } \left ( Z , 2 ( A Y - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y ) \right ) .
$$

It   follows   that  

$$
\text {grad} \bar { f } ( Y ) = 2 \left ( A Y - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) = P _ { Y } ^ { h } ( 2 A Y ) , \\ \text {where}
$$

where  

$$
P _ { Y } ^ { h } = ( I - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } )
$$

is   the   orthogonal   projection   onto   the   horizontal   space.   Note   that,   in   accordance   with   the   theory   in   Section   3.6.2,   grad   f ( Y   )   belongs   to   the   horizontal   space.   It   follows   from   the   material   in   Section   3.6.2,   in   particular   (3.39),   that  

$$
\overline { \text {grad} } f _ { Y } = 2 P _ { Y } ^ { h } A Y = 2 \left ( A Y - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) .
$$

[Page 98]

Table 4.3 Rayleigh quotient cost function on the Grassmann manifold.

| |Grass( p, n )|Total space R n × p ∗ T − 1 T|
|---|---|---|
|cost|span( Y ) ↦→ f ( Y )|) = tr(( Y Y ) Y AY ) Z 1 , Z 2 )|
|metric|g span( Y ) ( ξ, ζ ) = g Y ( ξ Y , ζ Y )|= tr(( Y T Y ) − 1 Z T 1   Z 2 )|
|horizontal space Z ∈|R n × p : Y T Z = 0|/|
|projection onto P h Y Z = horizontal space|Z − Y ( Y T Y ) − 1 Y T Z|/|
|gradient grad|f Y = grad f ( Y )|grad f ( Y ) = P h Y (2 AY )|
|retraction R span( Y|) ( ξ ) = span( Y + ξ Y )|R Y ( Z ) = Y + Z|


# 4.9.2 Line-search algorithm

In   order   to   obtain   a   line-search   algorithm   for   the   Rayleigh   quotient   on   the   Grassmann   manifold,   it   remains   to   pick   a   retraction.   According   to   Section   4.1.2,   a   natural   choice   is  

$$
R _ { s p a n ( Y ) } ( \xi ) = \text {span} ( Y + \bar { \xi } _ { Y } ) .
$$

In   other   words,   ( Y   +   ξ Y ) M   is   a   matrix   representation   of   R span( Y ) ( ξ )   for   any   M   ∈   R ∗   p × p .   The   matrix   M   can   be   viewed   as   a   normalization   factor   that   can   be   used   to   prevent   the   iterates   from   becoming   ill-conditioned,   the   bestconditioned   form   being   orthonormal   matrices.   We   now   have   all   the   necessary   elements   (see   the   summary   in   Table   4.3)   to   write   down   explicitly   a   line-search   method   for   the   Rayleigh   quotient   (4.38).  

The   matrix   algorithm   obtained   by   applying   the   Armijo   line-search   version   of   Algorithm   1   to   the   problem   of   minimizing   the   generalized   Rayleigh   quotient   (4.38)   is   stated   in   Algorithm   3.  

The   following   convergence   results   follow   from   the   convergence   analysis   of   the   general   line-search   Algorithm   1   (Theorems   4.3.1   and   4.5.6).  

Theorem 4.9.1 Let { Y k }   be an inﬁnite sequence of iterates generated by Algorithm 3. Let λ 1 ≤   ···   ≤   λ n denote the eigenvalues of A .  

- (i) The sequence { span( Y k ) } converges to the set of p -dimensional invariant subspaces of A .
- (ii) Assuming that the eigenvalue λ p is simple, the (unique) invariant subspace associated with ( λ 1 , . . . , λ p )   is asymptotically stable for the iteration deﬁned by Algorithm 3, and the convergence is linear with a factor smaller than or equal to    


$$
\text {actor smaller than or equal to} \\ r _ { * } = 1 - 2 \sigma ( \lambda _ { p + 1 } - \lambda _ { p } ) \min \left ( \bar { \alpha } , \frac { 2 \beta ( 1 - \sigma ) } { \lambda _ { n } - \lambda _ { 1 } } \right ) .
$$

[Page 99]

Algorithm 3 Armijo   line   search   for   the   Rayleigh   quotient   on   Grass( p, n ) 


Require: Symmetric matrix A , scalars α > 0, β, σ ∈ (0 , 1).

Input: Initial iterate Y 0 ∈ R n × p , Y 0 full rank.

Sequence of iterates { Y k }

Output:

.

- 1: for k = 0 , 1 , 2 , . . . do
- 2: Compute η k = -2( AY -Y ( Y T Y ) -1 AY ).
- 3: Find the smallest integer m ≥ 0 such that


$$
\overline { f } \left ( Y _ { k } + \overline { \alpha } \beta ^ { m } \eta _ { k } \right ) \leq \overline { f } ( Y _ { k } ) - \sigma \overline { \alpha } \beta ^ { m } \text { tr} ( \eta _ { k } ^ { T } \eta _ { k } ) , \\ \overline { r } _ { 1 } \, c _ { k } \, \cdot \, 1 \colon \, ( \sigma \overline { \alpha } \overline { \beta } ^ { m } \eta _ { k } ) \leq \overline { f } ( Y _ { k } ) - \sigma \overline { \alpha } \beta ^ { m } \text { tr} ( \eta _ { k } ^ { T } \eta _ { k } ) ,
$$

with   f   deﬁned   in   (4.37).  

- 4: 	 Select   Y k +1 :=   ( Y k +   αβ m η k ) M ,   with   some   invertible   p   ×   p   matrix   M   chosen   to   preserve   good   conditioning.   (For   example,   select   Y k +1 as   the   Q   factor   of   the   QR   decomposition   of   Y k +   αβ m η k .)  
- 5:   end for


The other invariant subspaces are unstable.

Numerical   results   are   presented   in   Figure   4.4.  

# 4.10 NOTES AND REFERENCES

Classical   references   on   numerical   optimization   include   Bertsekas   [Ber95],   Dennis   and   Schnabel   [DS83],   Fletcher   [Fle01],   Luenberger   [Lue73],   Nash   and   Sofer   [NS96],   Polak   [Pol71],   and   Nocedal   and   Wright   [NW99].  

The   choice   of   the   qualiﬁcation   complete for   Riemannian   manifolds   is   not   accidental:   it   can   be   shown   that   a   Riemannian   manifold   M   is   complete   (i.e.,   the   domain   of   the   exponential   is   the   whole   T   M )   if   and   only   if   M ,   endowed   with   the   Riemannian   distance,   is   a   complete   metric   space;   see,   e.g.,   O’Neill   [O’N83].  

The   idea   of   using   computationally   eﬃcient   alternatives   to   the   Riemannian   exponential   was   advocated   by   Manton   [Man02,   §   IX]   and   was   also   touched   on   in   earlier   works   [MMH94,   Smi94,   EAS98].   Retraction   mappings   are   common   in   the   ﬁeld   of   algebraic   topology   [Hir76].   The   deﬁnition   of   retraction   used   in   this   book   comes   from   Shub   [Shu86];   see   also   Adler   et al. [ADM + 02].   Most   of   the   material   about   retractions   on   the   orthogonal   group   comes   from   [ADM + 02].  

Selecting   a   computationally   eﬃcient   retraction   is   a   crucial   step   in   developing   a   competitive   algorithm   on   a   manifold.   This   problem   is   linked   to   the   question   of   approximating   the   exponential   in   such   a   way   that   the   approximation   resides   on   the   manifold.   This   is   a   major   research   topic   in   computational   mathematics,   with   important   recent   contributions;   see,   e.g.,   [CI01,   OM01,   IZ05,   DN05]   and   references   therein.  

The   concept   of   a   locally   smooth   family   of   parameterizations   was   introduced   by   H¨ uper   and   Trumpf   [HT04].  

[Page 100]

![The image is a line graph titled Armlo. The graph has a linear scale of range 0 to 100 on the x-axis, labeled Armlo. The y-axis is labeled diet solution, and it ranges from 0 to 100. The graph shows a downward trend in the diet solution over the years, with the lowest point being around 100 and the highest point being around 100. The graph has a linear scale of range 0 to 100 on the x-axis, labeled Armlo. The y-axis is labeled diet solution, and it ranges from 0 to 100. The graph shows a downward trend in the diet solution over the years, with the lowest point being around 100 and the highest point being around 100. There are two lines on the graph: 1. The first line](<images/imageFile17.png>)

1

10

Armijo  

0

10

-1

10

dist to solution  

-2

10

-3

10

-4

10

-5

10

0  

20  

40  

60  

80  

100

120  

140  

160  

180  

200

k

Figure 4.4 Rayleigh quotient minimization on the Grassmann manifold of p -planes in R n , with p = 5 and n = 100. Upper curve: A = diag(1 , 2 , . . . , 100). Middle curve: A = diag(1 , 102 , 103 , . . . , 200). Lower curve: A = diag(1 , . . . , 5 , 106 , 107 , . . . , 200).

Details   on   the   QR   and   polar   decompositions   and   algorithms   to   compute   them   can   be   found   in   Golub   and   Van   Loan   [GVL96];   the   diﬀerentiability   of   the   qf   mapping   is   studied   in   Dehane   [Deh95],   Dieci   and   Eirola   [DE99],   and   Chern   and   Dieci   [CD00].   Formulas   for   the   diﬀerential   of   qf   and   other   smooth   matrix   functions   can   be   found   in   Dehaene   [Deh95].  

Deﬁnition   4.2.1,   on   gradient-related   sequences,   is   adapted   from   [Ber95].   Armijo’s   backtracking   procedure   was   proposed   in   [Arm66]   (or   see   [NW99,   Ber95]   for   details).  

Several   key   ideas   for   line-search   methods   on   manifolds   date   back   to   Luenberger   [Lue73,   Ch.   11].   Luenberger   proposed   to   use   a   search   direction   obtained   by   projecting   the   gradient   in   R n onto   the   tangent   space   of   the   constraint   set   and   mentioned   the   idea   of   performing   a   line   search   along   the   geodesic,   “which   we   would   use   if   it   were   computationally   feasible   (which   it   deﬁnitely   is   not)”.   He   also   proposed   an   alternative   to   following   the   geodesic   that   corresponds   to   retracting   orthogonally   to   the   tangent   space.   Other   early   contributions   to   optimization   on   manifolds   can   be   found   in   Gabay   [Gab82].   Line-search   methods   on   manifolds   are   also   proposed   and   analyzed   in   Udri¸ ste   [Udr94].   Recently,   Yang   [Yan07]   proposed   an   Armijo   linesearch   strategy   along   geodesics.   Exact   and   approximate   line-search   methods   were   proposed   for   matrix   manifolds   in   a   burst   of   research   in   the   early   1990s   [MMH94,   Mah94,   Bro93,   Smi94].   Algorithm   1   comes   from   [AG05].  

[Page 101]

Many   reﬁnements   exist   for   choosing   the   step   length   in   line-search   methods.   For   example,   the   backtracking   parameter   β   can   be   adapted   during   the   backtracking   procedure.   We   refer   to   Dennis   and   Schnabel   [DS83,   § 6.3.2]   and   Ortega   and   Rheinboldt   [OR70].  

The   non-Hausdorﬀ   example   given   in   Section   4.3.2   was   inspired   by   Brickell   and   Clark   [BC70,   Ex.   3.2.1],   which   refers   to   Haeﬂiger   and   Reeb   [HR57].  

For   a   local   convergence   analysis   of   classical   line-search   methods,   see,   e.g.,   Luenberger   [Lue73]   or   Bertsekas   [Ber95].   The   proof   of   Theorem   4.3.1   (the   global   convergence   of   line-search   methods)   is   a   generalization   of   the   proof   of   [Ber95,   Prop.   1.2.1].   In   Section   4.4,   it   is   pointed   out   that   convergence   to   critical   points   that   are   not   local   minima   cannot   be   ruled   out.   Another   undesirable   behavior   that   cannot   be   ruled   out   in   general   is   the   existence   of   several   (even   inﬁnitely   many)   accumulation   points.   Details   can   be   found   in   Absil   et al. [AMA05];   see   also   [GDS05].   Nevertheless,   such   algorithms   do   converge   to   single   accumulation   points,   and   the   gap   between   theory   and   practice   should   not   prevent   one   from   utilizing   the   most   computationally   eﬀective   algorithm.  

The   notions   of   stability   of   ﬁxed   points   have   counterparts   in   dynamical   systems   theory;   see,   e.g.,   Vidyasagar   [Vid02]   or   Guckenheimer   and   Holmes   [GH83].   In   fact,   iterations   x k +1 =   F   ( x k )   can   be   thought   of   as   discrete-time   dynamical   systems.  

  Further   information   on   Lojasiewicz’s   gradient   inequality   can   be   found   in     Lojasiewicz   [  Loj93].   The   concept   of   Theorem   4.4.2   (the   capture   theorem)   is   borrowed   from   Bertsekas   [Ber95].   A   coordinate-free   proof   of   our   Theorem   4.5.6   (local   convergence   of   line-search   methods)   is   given   by   Smith   [Smi94]   in   the   particular   case   where   the   next   iterate   is   obtained   via   an   exact   line   search   minimization   along   geodesics.   Optimization   algorithms   on   the   Grassmann   manifold   can   be   found   in   Smith   [Smi93],   Helmke   and   Moore   [HM94],   Edelman   et al. [EAS98],   Lippert   and   Edelman   [LE00],   Manton   [Man02],   Manton   et al. [MMH03],   Absil   et al. [AMS04],   and   Liu   et al. [LSG04].  

Gradient-descent algorithms for the Rayleigh quotient were considered as early as 1951 by Hestenes and Karush [HK51]. A detailed account is given in Faddeev and Faddeeva [FF63, § 74, p. 430]. There has been limited investigation of line-search descent algorithms as numerical methods for linear algebra problems since it is clear that such algorithms are not competitive with existing numerical linear algebra algorithms. At the end of his paper on the design of gradient systems, Brockett [Bro93] provides a discrete-time analog, with an analytic step-size selection method, for a specific class of problems. In independent work, Moore et al. [MMH94] (see also [HM94, p. 68]) consider the symmetric eigenvalue problem directly. Chu [Chu92] proposes numerical methods for the inverse singular value problem. Smith et al. [Smi93, Smi94, EAS98] consider line-search and conjugate gradient updates to eigenspace tracking problems. Mahony et al. [Mah94, MHM96] proposes gradient fl ows and considers discrete updates for principal component analysis. A related approach is to consider explicit integration of the gradient fl ow dynamical system with a numerical integration technique that preserves the underlying matrix constraint. Moser and Veselov [MV91] use this approach directly in building numerical algorithms for matrix factorizations. The literature on structure-preserving integration algorithms is closely linked to work on the integration of Hamiltonian systems. This fi eld is too vast to cover here, but we mention the excellent review by Iserles et al. [IMKNZ00] and an earlier review by Sanz-Serna [SS92].

[Page 102]

The   locally   optimal   conjugate   gradient   algorithm   for   the   symmetric   eigenvalue   problem   is   described   in   Knyazev   [Kny01];   see   Hetmaniuk   and   Lehoucq   [HL06]   for   recent   developments.   The   connection   between   the   power   method   and   line-search   methods   for   the   Rayleigh   quotient   was   studied   in   Mahony   et al. [MHM96].  

More   information   on   the   eigenvalue   problem   can   be   found   in   Golub   and   van   der   Vorst   [GvdV00],   Golub   and   Van   Loan   [GVL96],   Parlett   [Par80],   Saad   [Saa92],   Stewart   [Ste01],   Sorensen   [Sor02],   and   Bai   et al. [BDDR00].  

Linearly   convergent   iterative   numerical   methods   for   eigenvalue   and   subspace   problems   are   not   competitive   with   the   classical   numerical   linear   algebra   techniques   for   one-oﬀ   matrix   factorization   problems.   However,   a   domain   in   which   linear   methods   are   commonly   employed   is   in   tracking   the   principal   subspace   of   a   covariance   matrix   associated   with   observations   of   a   noisy   signal.   Let   { x 1 , x 2 , . . . }   be   a   sequence   of   elements   of   vectors   in   R n and   deﬁne   k + N      

$$
E _ { k } ^ { N } = \frac { 1 } { N } \sum _ { i = k + 1 } ^ { k + N } x _ { i } x _ { i } ^ { T } \in \mathbb { R } ^ { n \times n } , \quad A _ { k } ^ { N } = \left [ x _ { k + 1 } \ \cdots \ x _ { N } \right ] \in \mathbb { R } ^ { n \times N } . \\ \text {The signal subspace tracking problem is either to track a principal sub-}
$$

The   signal   subspace   tracking   problem   is   either   to   track   a   principal   subspace   of   the   covariance   matrix   E k N (a   Hermitian   eigenspace   problem)   or   to   directly   track   a   k signal   subspace   of   the   signal   array   A N (a   singular   value   problem).   Common   and   Golub   [CG90]   studied   classical   numerical   linear   algebra   techniques   for   this   problem   with   linear   update   complexity.   More   recent   review   material   is   provided   in   DeGroat   et al. [DDL99].   Most   (if   not   all)   high-accuracy   linear   complexity   algorithms   belong   to   a   family   of   powerbased   algorithms   [HXC + 99].   This   includes   the   Oja   algorithm   [Oja89],   the   PAST   algorithm   [Yan95],   the   NIC   algorithm   [MH98b],   and   the   Bi-SVD   algorithm   [Str97],   as   well   as   gradient-based   updates   [FD95,   EAS98].   Research   in   this   ﬁeld   is   extremely   active   at   this   time,   with   the   focus   on   reducedcomplexity   updates   [OH05,   BDR05].   We   also   refer   the   reader   to   the   Bayesian   geometric   approach   followed   in   [Sri00,   SK04].  

In line-search algorithms, the limit case where the step size goes to zero corresponds to a continuous-time dynamical system of the form x ˙ = η x , where η x ∈ T x M denotes the search direction at x ∈ M . There is a vast literature on continuous-time systems that solve computational problems, spanning several areas of computational science, including, but not limited to, linear programming [BL89a, BL89b, Bro91, Fay91b, Hel93b], continuous nonlinear optimization [Fay91a, LW00], discrete optimization [Hop84, HT85, Vid95, AS04], signal processing [AC98, Dou00, CG03], balanced realization of linear systems [Hel93a, GL93], model reduction [HM94, YL99], and automatic control [HM94, MH98a, GS01]. Applications in linear algebra, and especially in eigenvalue and singular value problems, are particularly abundant. Important advances in the area have come from the work on isospectral flows in the early 1980s. We refer the reader to Helmke and Moore [HM94] as the seminal monograph in this area and the thesis of Dehaene [Deh95] for more information; see also [Chu94, DMV99, CG02, Prz03, MA03, BI04, CDLP05, MHM05] and the many references therein.

[Page 103]

[Page 104]

# Matrix   Manifolds:   Second-Order   Geometry  

Many   optimization   algorithms   make   use   of   second-order   information   about   the   cost   function.   The   archetypal   second-order   optimization   algorithm   is   Newton’s   method.   This   method   is   an   iterative   method   that   seeks   a   critical   point   of   the   cost   function   f   (i.e.,   a   zero   of   grad   f )   by   selecting   the   update   vector   at   x k as   the   vector   along   which   the   directional   derivative   of   grad   f   is   equal   to   − grad   f ( x k ).   The   second-order   information   on   the   cost   function   is   incorporated   through   the   directional   derivative   of   the   gradient.   n

For   a   quadratic   cost   function   in   R ,   Newton’s   method   identiﬁes   a   zero   of   the   gradient   in   one   step.   For   general   cost   functions,   the   method   is   not   expected   to   converge   in   one   step   and   may   not   even   converge   at   all.   However,   the   use   of   second-order   information   ensures   that   algorithms   based   on   the   Newton   step   display   superlinear   convergence   (when   they   do   converge)   compared   to   the   linear   convergence   obtained   for   algorithms   that   use   only   ﬁrst-order   information   (see   Section   4.5).  

A   Newton   method   on   Riemannian   manifolds   will   be   deﬁned   and   analyzed   in   Chapter   6.   However,   to   provide   motivation   for   the   somewhat   abstract   theory   that   follows   in   this   chapter,   we   begin   by   brieﬂy   recapping   Newton’s   method   in   R n and   identify   the   blocks   to   generalizing   the   iteration   to   a   manifold   setting.   An   important   step   in   the   development   is   to   provide   a   meaningful   deﬁnition   of   the   derivative   of   the   gradient   and,   more   generally,   of   vector   ﬁelds;   this   issue   is   addressed   in   Section   5.2   by   introducing   the   notion   of   an   aﬃne   connection.   An   aﬃne   connection   also   makes   it   possible   to   deﬁne   parallel   translation,   geodesics,   and   exponentials   (Section   5.4).   These   tools   are   not   mandatory   in   deﬁning   a   Newton   method   on   a   manifold,   but   they   are   fundamental   objects   of   Riemannian   geometry,   and   we   will   make   use   of   them   in   later   chapters.   On   a   Riemannian   manifold,   there   is   one   preferred   aﬃne   connection,   termed   the   Riemannian connection ,   that   admits   elegant   specialization   to   Riemannian   submanifolds   and   Riemannian   quotient   manifolds   (Section   5.3).   The   chapter   concludes   with   a   discussion   of   the   concept   of   a   Hessian   on   a   manifold   (Sections   5.5   and   5.6).  

# 5.1 NEWTON’S METHOD IN R N

In its simplest formulation, Newton's method is an iterative method for finding a solution of an equation in one unknown. Let F be a smooth function from R to R and let x ∗ be a zero (or root ) of F , i.e., F ( x ∗ ) = 0. From an initial point x 0 in R , Newton's method constructs a sequence of iterates according to

[Page 105]

$$
x _ { k + 1 } = x _ { k } - \frac { F ( x _ { k } ) } { F ^ { \prime } ( x _ { k } ) } ,
$$

′   where   F   denotes   the   derivative   of   F   .   Graphically,   x k +1 corresponds   to   the   intersection   of   the   tangent   to   the   graph   of   F   at   x k with   the   horizontal   axis   (see   Figure   5.1).   In   other   words,   x k +1 is   the   zero   of   the   ﬁrst-order   Taylor   expansion   of   F   around   x k .   This   is   clearly   seen   when   (5.1)   is   rewritten   as  

$$
F ( x _ { k } ) + F ^ { \prime } ( x _ { k } ) ( x _ { k + 1 } - x _ { k } ) = 0 .
$$

y  

![In this image, we can see a diagram. There are two lines, one is a line with a point at the bottom and the other is a line with a point at the top.](<images/imageFile18.png>)

y  

F

x

=

(

)

∗

x

x  

x k  

xk

+1

Figure 5.1 Newton’s method in R .

  Let   G   :   R n →   R n :   G ( x )   :=   x   −   F   ( x ) /F   ′   ( x )   be   the   iteration   map   from   (5.1)   and   note   that   x ∗   is   a   ﬁxed   point   of   G .   For   a   generic   ﬁxed   point   where   F   ( x ∗ ) = 0   and   F   ′   ( x ∗ )   =   0,   the   derivative  

/negationslash

$$
G ^ { \prime } ( x _ { * } ) = 1 - \frac { F ^ { \prime } ( x _ { * } ) } { F ^ { \prime } ( x _ { * } ) } + \frac { F ( x _ { * } ) F ^ { \prime \prime } ( x _ { * } ) } { ( F ^ { \prime } ( x _ { * } ) ) ^ { 2 } } = 0 ,
$$

and   it   follows   that   Newton’s   method   is   locally   quadratically   convergent   to   x ∗   (see   Theorem   4.5.3).   R n R n

Newton’s   method   can   be   generalized   to   functions   F   from   to   .   Equation   (5.2)   becomes  

$$
F ( x _ { k } ) + D F \left ( x _ { k } \right ) [ x _ { k + 1 } - x _ { k } ] = 0 , \\ ( 5 . 3 )
$$

where   D F   ( x ) [ z ]   denotes   the   directional derivative of   F   along   z ,   deﬁned   by  

$$
D F \left ( x \right ) [ z ] \colon = \lim _ { t \rightarrow 0 } \, \frac { 1 } { t } ( F ( x + t z ) - F ( x ) ) .
$$

A   generalization   of   the   argument   given   above   shows   that   Newton’s   method   locally   quadratically   converges   to   isolated   roots   of   F   for   which   DF   ( x ∗ )   is   full   rank.  

Newton’s   method   is   readily   adapted   to   the   problem   of   computing   a   critical   point   of   a   cost   function   f   on   R n .   Simply   take   F   :=   grad   f ,   where  

$$
\text {grad} \, f ( x ) = ( \partial _ { 1 } f ( x ) , \dots , \partial _ { n } f ( x ) ) ^ { T }
$$

[Page 106]

is   the   Euclidean   gradient   of   f .   The   iterates   of   Newton’s   method   then   converge   locally   quadratically   to   the   isolated   zeros   of   grad   f ,   which   are   the   isolated   critical   points   of   f .   Newton’s   equation   then   reads  

$$
\text {grad} \, f ( x _ { k } ) + D ( \text {grad} \, f ) \left ( x _ { k } \right ) \left [ x _ { k + 1 } - x _ { k } \right ] & = 0 . \\
$$

To   generalize   this   approach   to   manifolds,   we   must   ﬁnd   geometric   analogs   to   the   various   components   of   the   formula   that   deﬁnes   the   Newton   iterate   on   R n .   When   f   is   a   cost   function   an   abstract   Riemannian   manifold,   the   Euclidean   gradient   naturally   becomes   the   Riemannian   gradient   grad   f   deﬁned   in   Section   3.6.   The   zeros   of   grad   f   are   still   the   critical   points   of   f .   The   diﬀerence   x k +1 −   x k ,   which   is   no   longer   deﬁned   since   the   iterates   x k +1 and   x k belong   to   the   abstract   manifold,   is   replaced   by   a   tangent   vector   η x k in   the   tangent   space   at   x k .   The   new   iterate   x k +1 is   obtained   from   η x k as   x k +1 =   R x k ( η x k ),   where   R   is   a   retraction;   see   Section   4.1   for   the   notion   of   retraction.   It   remains   to   provide   a   meaningful   deﬁnition   for   “D(grad   f )( x k )[ η x k ]”.                                

More generally, for ﬁnding a zero of a tangent vector ﬁeld ξ on a manifold, Newton’s   method   takes   the   form  

$$
\xi _ { x _ { k } } + \i D \xi ( x _ { k } ) [ \eta _ { x _ { k } } ] ^ { \prime \prime } & = 0 , \\ x _ { k + 1 } & = R _ { x _ { k } } ( \eta _ { x _ { k } } ) .
$$

The   only   remaining   task   is   to   provide   a   geometric   analog   of   the   directional   derivative   of   a   vector   ﬁeld.  

Recall   that   tangent   vectors   are   deﬁned   as   derivations   of   real   functions:   given   a   scalar   function   f   and   a   tangent   vector   η   at   x ,   the   real   D f   ( x ) [ η ]   is   deﬁned   as   d( f ( γ ( t ))) ,   where   γ   is   a   curve   representing   η ;   see   Section   3.5.   d t   t =0 If   we   try   to   apply   the   same   concept   to   vector   ﬁelds   instead   of   scalar   ﬁelds,   we   obtain  

$$
\frac { d \xi _ { \gamma ( t ) } } { d t } \Big | _ { t = 0 } & = \lim _ { t \to 0 } \frac { \xi _ { \gamma ( t ) } - \xi _ { \gamma ( 0 ) } } { t } . \\ \intertext { h e t w o v e c t o r s } T _ { \ } C o n g ( t ) \text { and there is in general no prediction } \intertext { d t } \intertext { w h e t w o v e c t o r s } T _ { \ } C o n g ( t ) \text { and there is in general no prediction }
$$

γ ( t ) γ ( t ) − γ (0) =   lim   .   d t     t =0 t → 0 t   The   catch   is   that   the   two   vectors   ξ γ ( t ) and   ξ γ (0) belong   to   two   diﬀerent   vector   spaces   T γ ( t ) M   and   T γ (0) M ,   and   there   is   in   general   no   predeﬁned   correspondence   between   the   vector   spaces   that   allows   us   to   compute   the   diﬀerence.   Such   a   correspondence   can   be   introduced   by   means   of   aﬃne   connections.  

# 5.2 AFFINE CONNECTIONS

The   deﬁnition   of   an   aﬃne   connection   on   a   manifold   is   one   of   the   most   fundamental   concepts   in   diﬀerential   geometry.   An   aﬃne   connection   is   an   additional   structure   to   the   diﬀerentiable   structure.   Any   manifold   admits   inﬁnitely   many   diﬀerent   aﬃne   connections.   Certain   aﬃne   connections,   however,   may   have   particular   properties   that   single   them   out   as   being   the   most   appropriate   for   geometric   analysis.   In   this   section   we   introduce   the   concept  

[Page 107]

Let   X ( M )   denote   the   set   of   smooth   vector   ﬁelds   on   M .   An   aﬃne connection ∇   (pronounced   “del”   or   “nabla”)   on   a   manifold   M   is   a   mapping                

$$
\nabla \colon \mathfrak { X } ( \mathcal { M } ) \times \mathfrak { X } ( \mathcal { M } ) & \to \mathfrak { X } ( \mathcal { M } ) , \\ \nabla & \quad ,
$$

∇ which   is   denoted   by   ( η, ξ )   −→   ∇ η ξ   and   satisﬁes   the   following   properties:                 


$$
i ) \Im ( \mathcal { M } ) \text {-linearity in } \eta & \quad \nabla _ { \eta + g \chi } \xi = f \nabla _ { \eta } \xi + g \nabla _ { \chi } \xi , \\ i i ) \mathbb { R } \text {-linearity in } \xi & \quad \nabla _ { \eta } ( a \xi + b \zeta ) = a \nabla _ { \eta } \xi + b \nabla _ { \eta } \zeta , \\ i i ) \text {Product rule (Leibniz' law)} & \colon \quad \nabla _ { \eta } ( f \xi ) = ( \eta f ) \xi + f \nabla _ { \eta } \xi , \\ \text {in which } n \, \chi \, \xi \, \zeta & \in \Re ( \mathcal { M } ) , \, f \, g \in \Im ( \mathcal { M } ) , \, \text {and} \, a \, h \in \mathbb { R } \, ( \text {Notice that} )
$$

in   which   η, χ, ξ, ζ   ∈   X ( M ),   f, g   ∈   F ( M ),   and   a, b   ∈   R .   (Notice   that   ηf   denotes   the   application   of   the   vector   ﬁeld   η   to   the   function   f ,   as   deﬁned   in   Section   3.5.4.)   The   vector   ﬁeld   ∇ η ξ   is   called   the   covariant derivative of   ξ   with   respect   to   η   for   the   aﬃne   connection   ∇ .   In   R n ,   the   classical   directional   derivative   deﬁnes   an   aﬃne   connection,  

In R n , the classical directional derivative defines an affine connection,

$$
( \nabla _ { \eta } \xi ) _ { x } = \lim _ { t \to 0 } \frac { \xi _ { x + t \eta _ { x } } - \xi _ { x } } { t } ,
$$

called   the   canonical (Euclidean) connection .   (This   expression   is   well   deﬁned   in   view   of   the   canonical   identiﬁcation   T x E ≃ E   discussed   in   Section   3.5.2,   and   it   is   readily   checked   that   (5.4)   satisﬁes   all   the   properties   of   aﬃne   connections.)   This   fact,   along   with   several   properties   discussed   below,   suggests   that   the   covariant   derivatives   are   a   suitable   generalization   of   the   classical   directional   derivative.  

Proposition 5.2.1 Every (second-countable Hausdorﬀ ) manifold admits an aﬃne connection.

In   fact,   every   manifold   admits   inﬁnitely   many   aﬃne   connections,   some   of   which   may   be   computationally   more   tractable   than   others.  

We   ﬁrst   characterize   all   the   possible   aﬃne   connections   on   the   linear   manifold   R n .   Let   ( e 1 , . . . , e n )   be   the   canonical   basis   of   R n .   If   ∇   is   a   connection   on   R n ,   we   have  

$$
\mathbb { R } ^ { n } , \, & \text {we have} \\ \\ \nabla _ { \eta } \xi = \nabla _ { \sum _ { i } \eta ^ { i } e _ { i } } \left ( \sum _ { j } \xi ^ { j } e _ { j } \right ) = \sum _ { i } \eta ^ { i } \nabla _ { e _ { i } } \left ( \sum _ { j } \xi ^ { j } e _ { j } \right ) \\ = & \sum _ { i , j } \left ( \eta ^ { i } \xi ^ { j } \nabla _ { e _ { i } } e _ { j } + \eta ^ { i } \partial _ { i } \xi ^ { j } e _ { j } \right ) , \\ \text {here } \eta , \xi , e _ { i } , \nabla _ { \eta } \xi , \nabla _ { e _ { i } } e _ { j } \text { are all vector fields on } \mathbb { R } ^ { n } . \text { To define } \nabla , \, it suffices
: \mathfrak { f } _ { \Delta } ( \eta , \xi ) & \triangle q \Delta _ { \Delta } ( \eta , \Gamma ) ; \quad \Gamma = 1 , \, \Gamma _ { 0 } \triangle q \Gamma , \\
$$

where   η, ξ, e i ,   ∇ η ξ,   ∇ e i e j are   all   vector   ﬁelds   on   R n .   To   deﬁne   ∇ ,   it   suﬃces   to   specify   the   n 2 vector   ﬁelds   ∇ e i e j ,   i   = 1 , . . . , n ,   j   = 1 , . . . , n .   By   convention,   the   k th   component   of   ∇ e i e j in   the   basis   ( e 1 , . . . , e n )   is   denoted   by   Γ k .   The   n 3 ij real-valued   functions   Γ k are   called   Christoﬀel symbols .   Each   choice   ij on   R n of   smooth   functions   Γ k deﬁnes   a   diﬀerent   aﬃne   connection   on   R n .   The   ij Euclidean   connection   corresponds   to   the   choice   Γ k ij ≡   0.  

[Page 108]

On   an   n -dimensional   manifold   M ,   locally   around   any   point   x ,   a   similar   development   can   be   based   on   a   coordinate   chart   ( U , ϕ ).   The   following   coordinate-based   development   shows   how   an   aﬃne   connection   can   be   deﬁned   on   U ,   at   least   in   theory   (in   practice,   the   use   of   coordinates   to   deﬁne   an   aﬃne   connection   can   be   cumbersome).   The   canonical   vector   e i is   replaced   by   the   i th   coordinate   vector   ﬁeld   E i of   ( U , ϕ )   which,   at   a   point   y   of   U ,   is   represented   by   the   curve   t    →   ϕ − 1 ( ϕ ( y ) +   te i );   in   other   words,   given   a   real-valued   function   f   deﬁned   on   U ,   E i f   =   ∂ i ( f   ◦ ϕ − 1 ).   Thus,   one   has   D ϕ ( y )[( E i ) y ] =   e i .   We   will   also   use   the   notation   ∂ i f   for   E i f .   A   vector   ﬁeld   ξ   can   be   decomposed   as   ξ   =     ξ j E j ,   where   ξ i ,   i   = 1 , . . . , d ,   are   real-valued   functions   on   U ,   i.e.,   j elements   of   F ( U ).   Using   the   characteristic   properties   of   aﬃne   connections,   we   obtain      

$$
\text {elements of } & \zeta ( a ) . \text { using the characteristic properties of arithmetic,} \\ \text {we obtain} & \\ & \nabla _ { \eta } \xi = \nabla _ { \sum _ { i } \eta ^ { i } E _ { i } } \left ( \sum _ { j } \xi ^ { j } E _ { j } \right ) = \sum _ { i } \eta ^ { i } \nabla _ { E _ { i } } \left ( \sum _ { j } \xi ^ { j } E _ { j } \right ) \\ & = \sum _ { i , j } \left ( \eta ^ { i } \xi ^ { j } \nabla _ { E _ { i } } E _ { j } + \eta ^ { i } \partial _ { i } \xi ^ { j } E _ { j } \right ) . \\ \text {It follows that the affine connection is fully specified once the } n ^ { 2 } \text { vector fields}
$$

It   follows   that   the   aﬃne   connection   is   fully   speciﬁed   once   the   n 2 vector   ﬁelds   ∇ E i E j are   selected.   We   again   use   the   Christoﬀel   symbol   Γ ij k to   denote   the   k th   component   of   ∇ E i E j in   the   basis   ( E 1 , . . . , E n );   in   other   words,     k

$$
j \text { in the basis } ( E _ { 1 } , \dots , E _ { n } ) ; \\ \nabla _ { E _ { i } } E _ { j } = \sum _ { k } \Gamma _ { i j } ^ { k } E _ { k } . \\ \Gamma _ { i j } ^ { k } \text { at a point } x \text { can be the } \\
$$

The   Christoﬀel   symbols   Γ k 3 ij at   a   point   x   can   be   thought   of   as   a   table   of   n real   numbers   that   depend   both   on   the   point   x   in   M   and   on   the   choice   of   the   chart   ϕ   (for   the   same   aﬃne   connection,   diﬀerent   charts   produce   diﬀerent   Christoﬀel   symbols).   We   thus   have  

$$
\nabla _ { \eta } \xi = \sum _ { i , j , k } \left ( \eta ^ { i } \xi ^ { j } \Gamma _ { i j } ^ { k } E _ { k } + \eta ^ { i } \partial _ { i } \xi ^ { j } E _ { j } \right ) . \\ \intertext { m i n g of i n d i c e s y i l d e s }
$$

A   simple   renaming   of   indices   yields    

$$
\text {warning of indices yields} \\ \nabla _ { \eta } \xi = \sum _ { i , j , k } \eta ^ { j } \left ( \xi ^ { k } \Gamma _ { j k } ^ { i } + \partial _ { j } \xi ^ { i } \right ) E _ { i } . \\ \text {contain a matrix expression as follows. Letting hat quantities de-}
$$

We   also   obtain   a   matrix   expression   as   follows.   Letting   hat   quantities   denote   the   (column)   vectors   of   components   in   the   chart   ( U , φ ),   we   have     ˆ ˆ

$$
\widehat { \nabla _ { \eta _ { x } } \xi } = \hat { \Gamma } _ { \hat { x } , \hat { \xi } } \hat { \eta } _ { \hat { x } } + D \hat { \xi } \left ( \hat { x } \right ) \left [ \hat { \eta } _ { \hat { x } } \right ] ,
$$

where   Γ ˆ ˆ ˆ denotes   the   matrix   whose   ( i, j )   element   is   the   real-valued   function   x,ξ  

$$
\sum _ { k } \left ( \xi ^ { k } \Gamma _ { j k } ^ { i } \right ) \\
$$

evaluated   at   x .  

From   the   coordinate   expression   (5.5),   one   can   deduce   the   following   properties   of   aﬃne   connections.  

[Page 109]

1. 	 Dependence   on   η x .   The   vector   ﬁeld   ∇ η ξ   at   a   point   x   depends   only   on   the   value   η x of   η   at   x .   Thus,   an   aﬃne   connection   at   x   is   a   mapping   T x M ×   X ( x )   →   X ( x ) : ( η x , ξ )    →   ∇ η x ξ ,   where   X ( x )   denotes   the   set   of   vector   ﬁelds   on   M   whose   domain   includes   x .   2. 	 Local   dependence   on   ξ .   In   contrast,   ξ x does   not   provide   enough   infor­

Local dependence on ξ . In contrast, ξ x does not provide enough information about the vector fi eld ξ to compute ∇ η ξ at x . However, if the vector fi elds ξ and ζ agree on some neighborhood of x , then ∇ η ξ and ∇ η ζ coincide at x . Moreover, given two affine connections ∇ and ∇ ˜ , ∇ η ξ -∇ ˜ η ξ at x depends only on the value ξ x of ξ at x .

Uniqueness at zeros. Let ∇ and ∇ ˜ be two affine connections on M and let ξ and η be vector fi elds on M . Then, as a corollary of the previous property,

$$
( \nabla _ { \eta } \xi ) _ { x } = \left ( \tilde { \nabla } _ { \eta } \xi \right ) _ { x } \text { if } \xi _ { x } = 0 . \\ \text {pretty is particularly important in the concrete}
$$

This   ﬁnal   property   is   particularly   important   in   the   convergence   analysis   of   optimization   algorithms   around   critical   points   of   a   cost   function.  

# 5.3 RIEMANNIAN CONNECTION

On   an   arbitrary   (second-countable   Hausdorﬀ)   manifold,   there   are   inﬁnitely   many   aﬃne   connections,   and   a priori ,   no   one   is   better   than   the   others.   In   contrast,   on   a   vector   space   E   there   is   a   preferred   aﬃne   connection,   the   canonical   connection   (5.4),   which   is   simple   to   calculate   and   preserves   the   linear   structure   of   the   vector   space.   On   an   arbitrary   Riemannian   manifold,   there   is   also   a   preferred   aﬃne   connection,   called   the   Riemannian   or   the   Levi-Civita   connection.   This   connection   satisﬁes   two   properties   (symmetry,   and   invariance   of   the   Riemannian   metric)   that   have   a   crucial   importance,   notably   in   relation   to   the   notion   of   Riemannian   Hessian.   Moreover,   the   Riemannian   connection   on   Riemannian   submanifolds   and   Riemannian   quotient   manifolds   admits   a   remarkable   formulation   in   terms   of   the   Riemannian   connection   in   the   structure   space   that   makes   it   particularly   suitable   in   the   context   of   numerical   algorithms.   Furthermore,   on   a   Euclidean   space,   the   Riemannian   connection   reduces   to   the   canonical   connection—the   classical   directional   derivative.  

# 5.3.1 Symmetric connections

An   aﬃne   connection   is   symmetric   if   its   Christoﬀel   symbols   satisfy   the   symmetry   property   Γ k Γ k This   deﬁnition   is   equivalent   to   a   more   abstract   ij =   ji .   coordinate-free   approach   to   symmetry   that   provides   more   insight   into   the   underlying   structure   of   the   space.  

To define symmetry of an affine connection in a coordinate-free manner, we will require the concept of a Lie bracket of two vector fi elds. Let ξ and ζ be vector fi elds on M whose domains meet on an open set U . Recall that F ( U ) denotes the set of smooth real-valued functions whose domains include U . Let [ ξ, η ] denote the function from F ( U ) into itself defined by

[Page 110]

$$
[ \xi , \zeta ] f & \coloneqq \xi ( \zeta f ) - \zeta ( \xi f ) . \\ + 1 \, _ { [ \zeta , \zeta ] } \colon _ { \mathbb { T } } \mathbb { m } { 1 } \colon _ { r }
$$

It   is   easy   to   show   that   [ ξ, ζ ]   is   R -linear,  

$$
[ \xi , \eta ] ( a f + b g ) = a [ \xi , \eta ] f + b [ \xi , \eta ] g ,
$$

and   satisﬁes   the   product   rule   (Leibniz’   law),  

$$
[ \xi , \eta ] ( f g ) = f ( [ \xi , \eta ] g ) + ( [ \xi , \eta ] f ) g .
$$

Therefore,   [ ξ, ζ ]   is   a   derivation   and   deﬁnes   a   tangent   vector   ﬁeld,   called   the   Lie bracket of   ξ   and   ζ .  

An   aﬃne   connection   ∇   on   a   manifold   M   is   said   to   be   symmetric when        

$$
\nabla _ { \eta } \xi - \nabla _ { \xi } \eta = [ \eta , \xi ]
$$

for all η, ξ ∈ X ( M ).

ϕ ),   denoting   by   E i the   i th   coordinate   vector   ﬁeld,   we   have,   for   a   symmetric   connection   ∇ ,    

$$
\nabla _ { E _ { i } } E _ { j } - \nabla _ { E _ { j } } E _ { i } = [ E _ { i } , E _ { j } ] = 0 \\ 2 \, 2 \, r _ { i } = 2 \, 2 \, r _ { j } = 0 \, r _ { i } = \widetilde { r } ( 1 )
$$

since   [ E i , E j ] f   =   ∂ i ∂ j f   −   ∂ j ∂ i f   =   0   for   all   f   F ( M ).   It   follows   that   Γ k Γ k ∈   ij =   ji for   every   symmetric   connection.   Conversely,   it   is   easy   to   show   that   connections   satisfying   Γ k ij = Γ ji k are   symmetric   in   the   sense   of   (5.10)   by   expanding   in   local   coordinates.  

# 5.3.2 Deﬁnition of the Riemannian connection

The   following   result   is   sometimes   referred   to   as   the   fundamental   theorem   of   Riemannian   geometry.   Let    · ,   ·    denote   the   Riemannian   metric.  

Theorem 5.3.1 (Levi-Civita) On a Riemannian manifold M   there exists a unique aﬃne connection ∇   that satisﬁes      

- (i) ∇ η ξ -∇ ξ η = [ η, ξ ] (symmetry),  and
- (ii)


〈

〉

〈∇

〉

〈

∇

〉

χ

η, ξ

=

η, ξ

+

η,

ξ

(compatibility with the Riemannian

χ

χ

metric),

for all χ, η, ξ   ∈   X ( M ) . This aﬃne connection ∇ , called the Levi-Civita   connection   or the Riemannian   connection   of M , is characterized by the Koszul   formula  

$$
2 \langle \nabla _ { \chi } \eta , \xi \rangle = \chi \langle \eta , \xi \rangle + \eta \langle \xi , \chi \rangle - \xi \langle \chi , \eta \rangle - \langle \chi , [ \eta , \xi ] \rangle + \langle \eta , [ \xi , \chi ] \rangle + \langle \xi , [ \chi , \eta ] \rangle .
$$

Recall   that   for   vector   ﬁelds   η, ξ, χ   ∈   X ( M ),     η, ξ     is   a   real-valued   function   on   M   and   χ   η, ξ     is   the   real-valued   function   given   by   the   application   of   the   vector   ﬁeld   (i.e.,   derivation)   χ   to     η, ξ   .)   Since   the   Riemannian   connection   is   symmetric,   it   follows   that   the   Christof­

Since the Riemannian connection is symmetric, it follows that the Christoffel symbols of the Riemannian connection satisfy Γ k = Γ k Moreover, it ij ji .

[Page 111]

follows   from   the   Koszul   formula   (5.11)   that   the   Christoﬀel   symbols   for   the   Riemannian   connection   are   related   to   the   coeﬃcients   of   the   metric   by   the   formula  

$$
\Gamma _ { i j } ^ { k } = \frac { 1 } { 2 } \sum _ { \ell } g ^ { k \ell } ( \partial _ { i } g _ { \ell j } + \partial _ { j } g _ { \ell i } - \partial _ { \ell } g _ { i j } ) \, , \\ \\ \ell \, \text { denotes the matrix} \, \text {inv} \, \sigma _ { j } \, \text { over } \, \Sigma \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \, \text { } \
$$

where   g kℓ denotes   the   matrix   inverse   of   g kℓ ,   i.e.,     i g ki g iℓ =   δ ℓ k .   In   theory,   the   formula   (5.12)   provides   a   means   to   compute   the   Riemannian   connection.   However,   working   in   coordinates   can   be   cumbersome   in   practice,   and   we   will   use   a   variety   of   tricks   to   avoid   using   (5.12)   as   a   computational   formula.  

Note   that   on   a   Euclidean   space,   the   Riemannian   connection   reduces   to   the   canonical   connection   (5.4).   A   way   to   see   this   is   that,   in   view   of   (5.12),   the   Christoﬀel   symbols   vanish   since   the   metric   is   constant.  

# 5.3.3 Riemannian connection on Riemannian submanifolds

Let   M   be   a   Riemannian   submanifold   of   a   Riemannian   manifold   M .   By   deﬁnition,   the   Riemannian   metric   on   the   submanifold   M   is   obtained   by   restricting   to   M   the   Riemannian   metric   on   M ;   therefore   we   use   the   same   notation    · ,   ·    for   both.   Let   ∇   denote   the   Riemannian   connection   of   M ,   and   ∇   the   Riemannian   connection   of   M .   Let   X ( M )   denote   the   set   of   vector   ﬁelds   on   M ,   and   X ( M )   the   set   of   vector   ﬁelds   on   M .   Given   η x ∈   T x M   and   ξ   ∈   X ( M ),   we   begin   by   deﬁning   the   object   ∇ η ξ .   To  

Given η x ∈ T x M and ξ ∈ X ( M ), we begin by defining the object ∇ η ξ . To this end, since T x M is a subspace of T x M , let η x be η x viewed as an element of T x M ; moreover, let ξ be a smooth local extension of ξ over a coordinate neighborhood U of x in M . Then define

$$
\overline { \nabla } _ { \eta _ { x } } \xi \coloneqq \overline { \nabla } _ { \bar { \eta } _ { x } } \overline { \xi } .
$$

This   expression   does   not   depend   on   the   local   extension   of   ξ .   However,   in   general,   ∇ η x ξ   does   not   lie   in   T x M ,   as   illustrated   in   Figure   5.2.   Hence   the   restriction   of   ∇   to   M ,   as   deﬁned   in   (5.13),   does   not   qualify   as   a   connection   on   M .  

![The image is a diagram of a geometric figure, which consists of a series of interconnected lines and points. The lines are labeled with different symbols and angles. Here is a detailed description of the image: - **Title**: The title at the top of the image reads Geometric Figures, indicating that this is a diagram of geometric figures. - **Labels**: There are several labels on the diagram, including: - **M**: A point on the diagram. - **M_1**: A point on the diagram. - **M_2**: A point on the diagram. - **M_3**: A point on the diagram. - **M_4**: A point on the diagram. - **M_5**: A point on the diagram. - **M_6**: A point on the diagram. - **M_7**: A point on the diagram. - **M_8**: A point on the diagram.](<images/imageFile19.png>)

∇

ξξ

ξ  

M  

M  

Figure 5.2 Riemannian connection ∇ in a Euclidean space M applied to a tangent vector ﬁeld ξ to a circle. We observe that ∇ ξ ξ is not tangent to the circle.

[Page 112]

Recall   from   Section   3.6.1   that,   using   the   Riemannian   metric   on   M ,   each   tangent   space   T x M   can   be   decomposed   as   the   direct   sum   of   T x M   and   its   orthogonal   complement   ( T x M ) ⊥ ,   called   the   normal   space   to   the   Riemannian   submanifold   M   at   x .   Every   vector   ξ x ∈   T x M ,   x   ∈ M ,   has   a   unique   decomposition  

$$
\xi _ { x } = P _ { x } \xi _ { x } + P _ { x } ^ { \perp } \xi _ { x } ,
$$

where   P x ξ x belongs   to   T x M   and   P ⊥ ξ x belongs   to   ( T x M ) ⊥   .   We   have   the   x following   fundamental   result.  

Proposition 5.3.2 Let M   be a Riemannian submanifold of a Riemannian manifold M   and let ∇   and ∇   denote the Riemannian connections on M and M . Then

$$
\nabla _ { \eta _ { x } } \xi = P _ { x } \overline { \nabla } _ { \eta _ { x } } \xi \\
$$

for all η x ∈   T x M   and ξ   ∈   X ( M ) .

This   result   is   particularly   useful   when   M   is   a   Riemannian   submanifold   of   a   Euclidean   space;   then   (5.14)   reads  

$$
\nabla _ { \eta _ { x } } \xi = P _ { x } \left ( D \xi \left ( x \right ) \left [ \eta _ { x } \right ] \right ) ,
$$

i.e.,   a   classical   directional   derivative   followed   by   an   orthogonal   projection.  

# Example 5.3.1 The   sphere   S n − 1 n − 1

On the sphere S viewed as a Riemannian submanifold of the Euclidean space R n , the projection P x is given by

$$
P _ { x } \xi = ( I - x x ^ { T } ) \xi
$$

and the Riemannian connection is given by

$$
\nabla _ { \eta _ { x } } \xi & = ( I - x x ^ { T } ) \, D \xi \left ( x \right ) \left [ \eta _ { x } \right ] \\
$$

for all x   ∈   S n − 1 , η x ∈   T x S n − 1 , and ξ   ∈   X ( S n − 1 ) . A practical application of this formula is presented in Section 6.4.1.

# Example 5.3.2 The   orthogonal   Stiefel   manifold   St( p, n )  

On the Stiefel manifold St( p, n )   viewed as a Riemannian submanifold of the Euclidean space R n × p , the projection P X is given by

$$
P _ { X } \xi = ( I - X X ^ { T } ) \xi + X \, \text {skew} ( X ^ { T } \xi )
$$

and the Riemannian connection is given by

$$
\nabla _ { \eta _ { X } } \xi = P _ { X } ( D \xi ( x ) [ \eta _ { X } ] )
$$

for all X   ∈   St( p, n ) , η X ∈   T X St( p, n ) , and ξ   ∈   X (St( p, n )) .

[Page 113]

# 5.3.4 Riemannian connection on quotient manifolds

Let   M   be   a   Riemannian   manifold   with   a   Riemannian   metric   g   and   let   M   =   M /   ∼   be   a   Riemannian   quotient   manifold   of   M ,   i.e.,   M   is   endowed   with   a   manifold   structure   and   a   Riemannian   metric   g   that   turn   the   natural   projection   π   :   M → M   into   a   Riemannian   submersion.   As   in   Section   3.6.2,   the   horizontal   space   H y at   a   point   y   ∈ M   is   deﬁned   as   the   orthogonal   complement   of   the   vertical   space,   and   ξ   denotes   the   horizontal   lift   of   a   tangent   vector   ξ .  

Proposition 5.3.3 Let M   =   M /   ∼   be a Riemannian quotient manifold and let ∇   and ∇   denote the Riemannian connections on M   and M . Then h  

$$
\text {one line} \, \text {Mainline} \, \text {Connections} \, \text {on} \, \mathbb { J } \, \text {(a} \, \text {a} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text {e} \, \text {J} \, \text
$$

for all vector ﬁelds ξ   and η   on M , where P h denotes the orthogonal projection onto the horizontal space.

This   is   a   very   useful   result,   as   it   provides   a   practical   way   to   compute   covariant   derivatives   in   the   quotient   space.   The   result   states   that   the   horizontal   lift   of   the   covariant   derivative   of   ξ   with   respect   to   η   is   given   by   the   horizontal   projection   of   the   covariant   derivative   of   the   horizontal   lift   of   ξ   with   respect   to   the   horizontal   lift   of   η .  

If   the   structure   space   M   is   (an   open   subset   of)   a   Euclidean   space,   then   formula   (5.18)   simply   becomes    

$$
\overline { \nabla _ { \eta } \xi } & = P ^ { h } \left ( D \bar { \xi } [ \bar { \eta } ] \right ) . \\ , \, \overline { \mathcal { M } } \text { is a vector space end} _ { t } \, ,
$$

In   some   practical   cases,   M   is   a   vector   space   endowed   with   a   Riemannian   metric   g   that   is   not   constant   (hence   M   is   not   a   Euclidean   space)   but   that   is   nevertheless   horizontally invariant ,   namely,  

$$
D ( \bar { g } ( \nu , \lambda ) ) \left ( y \right ) \left [ \eta _ { y } \right ] = \bar { g } ( D \nu \left ( y \right ) \left [ \eta _ { y } \right ] , \lambda _ { y } ) + \bar { g } ( \nu _ { y } , D \lambda \left ( y \right ) \left [ \eta _ { y } \right ] )
$$

for   all   y   ∈ M ,   all   η y ∈ H y ,   and   all   horizontal   vector   ﬁelds   ν ,   λ   on   M .   In   this   case,   the   next   proposition   states   that   the   Riemannian   connection   on   the   quotient   is   still   a   classical   directional   derivative   followed   by   a   projection.  

Proposition 5.3.4 Let M   be a Riemannian quotient manifold of a vector space M   endowed with a horizontally invariant Riemannian metric and let ∇   denote the Riemannian connection on M . Then h  

$$
\text {connection on } \mathcal { M } . \ 1 \, \text {he} \\ \overline { \nabla _ { \eta } \xi } = P ^ { h } \left ( D \bar { \xi } [ \bar { \eta } ] \right ) \\ \eta \ o n \ \mathcal { M } .
$$

for all vector ﬁelds ξ   and η   on M .

Proof. Let g ( , ) = 〈· , ·〉 denote the Riemannian metric on M and let ∇ · · denote the Riemannian connection of M . Let χ , ν , λ be horizontal vector fi elds on M . Notice that since M is a vector space, one has [ ν, λ ] = D λ [ ν ] -D ν [ λ ], and likewise for permutations between χ , ν , and λ . Moreover, since it is assumed that g is horizontally invariant, it follows that D g ( ν, λ )[ χ ] = g (D ν [ χ ] , λ )+ g ( ν, D λ [ χ ]); and likewise for permutations. Using these identities, it follows from Koszul's formula (5.11) that

[Page 114]

$$
2 \langle \overline { \nabla } _ { \chi } \nu , \lambda \rangle & = \chi \langle \nu , \lambda \rangle + \nu \langle \lambda , \chi \rangle - \lambda \langle \chi , \nu \rangle + \langle \lambda , [ \chi , \nu ] \rangle + \langle \nu , [ \lambda , \chi ] \rangle - \langle \chi , [ \nu , \lambda ] \rangle \\ & = 2 \bar { g } ( D \nu [ \chi ] , \lambda ) ,
$$

hence   P h ( ∇ χ ν ) = P h (D ν [ χ ]).   The   result   follows   from   Proposition   5.3.3.      

# Example 5.3.3 The   Grassmann   manifold  

We follow up on the example in Section 3.6.2. Recall that the Grassmann manifold Grass( p, n )   was viewed as a Riemannian quotient manifold of ( R n ∗ × p , g )   with  

$$
\int w h t & & \bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) = \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Z _ { 1 } ^ { T } Z _ { 2 } \right ) . \\ \intertext { t a n t a l d i s t r i b u t i o n $ i s $ } & & \intertext { t a n t a l d i s t r i b u t i o n $ i s $ } & & 2 ( Z _ { 1 } \subset \mathbb { m } { N } \times \mathbb { m } { P } _ { Y } \ X T _ { Z } \ Z _ { 1 } ) .
$$

The horizontal distribution is

$$
\mathcal { H } _ { Y } = \{ Z \in \mathbb { R } ^ { n \times p } \colon Y ^ { T } Z = 0 \} \\ \text {option} \, \ a n t o \, t h o \, h o m i s t o l \, o p a o \, o j \, o i \, o u \, o n \, b y
$$

and the projection onto the horizontal space is given by

$$
P _ { Y } ^ { h } Z & = ( I - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } ) Z . \\ \intertext { w h o o l o d \ t h a t \ f o r a l l \ h o m i o n t a l l \ o v o t o n o \ Z \subset \mathcal { U } }
$$

It is  readily  checked  that,  for  all  horizontal  vectors Z ∈ H Y , it holds  that

$$
D \bar { g } ( \bar { \xi } , \bar { \zeta } ) \left ( Y \right ) \left [ Z \right ] & = D _ { Y } \left ( \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } ( \bar { \xi } _ { Y } ) ^ { T } \bar { \zeta } _ { Y } \right ) \right ) ( Y ) \left [ Z \right ] \\ & = \bar { g } ( D \bar { \xi } \left ( Y \right ) [ Z ] , \bar { \zeta } _ { Y } ) + \bar { g } ( \bar { \xi } _ { Y } , D \bar { \zeta } \left ( Y \right ) [ Z ] )
$$

since Y   T Z   = 0   for all Z   ∈ H Y . The Riemannian metric g   is thus horizontally invariant. Consequently, we can apply the formula for the Riemannian connection on a Riemannian quotient of a manifold with a horizontally invariant metric (Proposition 5.3.4) and obtain  

∇ η ξ   = P h   D ξ   ( Y   ) [ η Y ]   .   (5.22)   Y We refer the reader to Section 6.4.2 for a practical application of this formula.

# 5.4 GEODESICS, EXPONENTIAL MAPPING, AND PARALLEL TRANSLATION

Geodesics   on   manifolds   generalize   the   concept   of   straight   lines   in   R n . A   geometric   deﬁnition   of   a   straight   line   in   R n is   that   it   is   the   image   of   a   curve   γ   with   zero   acceleration;   i.e.,  

$$
\frac { d ^ { 2 } } { d t ^ { 2 } } \, \gamma ( t ) = 0
$$

for   all   t .  

On   manifolds,   we   have   already   introduced   the   notion   of   a   tangent   vector   γ ˙ ( t ),   which   can   be   interpreted   as   the   velocity of   the   curve   γ   at   t .   The   mapping   t    →   γ ˙ ( t )   deﬁnes   the   velocity vector ﬁeld along   γ .   Next   we   deﬁne   the   acceleration   vector   ﬁeld   along   γ .  

[Page 115]

Let   M   be   a   manifold   equipped   with   an   aﬃne   connection   ∇   and   let   γ   be   a   curve   in   M   with   domain   I   ⊆   R . A   vector ﬁeld on the curve γ   smoothly   assigns   to   each   t   ∈   I   a   tangent   vector   to   M   at   γ ( t ).   For   example,   given   any   vector   ﬁeld   ξ   on   M ,   the   mapping   t    →   ξ γ ( t ) is   a   vector   ﬁeld   on   γ .   The   velocity   vector   ﬁeld   t    →   γ ˙ ( t )   is   also   a   vector   ﬁeld   on   γ .   The   set   of   all   (smooth)   vector   ﬁelds   on   γ   is   denoted   by   X ( γ ).   It   can   be   shown   that   there   is   a   unique   function   ξ   from   X ( γ )   to   X ( γ )   such   that   d t ξ    →   D D D D R

D ( aξ + bζ ) = a D ξ + b D ζ ( a, b ∈ R ), d t d t d t

D ( fξ ) = f ′ ξ + f D ξ ( f ∈ F ( I )), d t d t

d D t ( η ◦ γ )( t ) = ∇ γ ˙ ( t ) η ( t ∈ I, η ∈ X ( M )).

The   acceleration vector ﬁeld d t 2 γ   on   γ   is   deﬁned   by  

$$
\frac { D ^ { 2 } } { d t ^ { 2 } } \, \gamma \colon = \frac { D } { d t } \, \dot { \gamma } . \\
$$

Note   that   the   acceleration   depends   on   the   choice   of   the   aﬃne   connection,   while   the   velocity   ˙ γ   does   not.   Speciﬁcally,   in   a   coordinate   chart   ( U , ϕ ),   using   the   notation   ( x 1 ( t ) , . . . , x n ( t ))   :=   ϕ ( γ ( t )),   the   velocity   ˙ γ   simply   reads   d d t k x ,   which   does   not   depend   on   the   Christoﬀel   symbol;   on   the   other   hand,   the   D 2 acceleration   d t 2 γ   reads  

$$
\frac { d ^ { 2 } } { d t ^ { 2 } } \, x ^ { k } + \sum _ { i , j } \Gamma _ { i j } ^ { k } ( \gamma ) \, \frac { d } { d t } \, x ^ { i } \, \frac { d } { d t } \, x ^ { j } , \\ \text {are the Christoffel symbols evaluated at}
$$

where Γ k ( γ ( t )) are the Christoffel symbols, evaluated at the point γ ( t ), of ij the affine connection in the chart ( U , ϕ ).

A geodesic γ on a manifold M endowed with an affine connection ∇ is a curve with zero acceleration:

$$
\frac { D ^ { 2 } } { d t ^ { 2 } } \, \gamma ( t ) = 0 & & ( 5 . 2 4 ) \\
$$

for   all   t   in   the   domain   of   γ .   Note   that   diﬀerent   aﬃne   connections   produce   diﬀerent   geodesics.  

For   every   ξ   ∈   T x M ,   there   exists   an   interval   I   about   0   and   a   unique   geodesic   γ ( t ;   x, ξ ) :   I   → M   such   that   γ (0)   =   x   and   ˙ γ (0)   =   ξ .   Moreover,   we   have   the   homogeneity   property   γ ( t ;   x, aξ ) =   γ ( at ;   x, ξ ).   The   mapping  

$$
E x p _ { x } \colon T _ { x } \mathcal { M } \to \mathcal { M } \colon \xi \mapsto E x p _ { x } \xi = \gamma ( 1 ; x , \xi ) \\ \ t h _ { x } \, \underset { \ } s u p _ { x } \, \underset { \ } s u t i _ { x } \, \underset { \ } l \, \underset { \ } w h _ { x } \, \underset { \ } t h _ { x } \, \underset { \ } s u r _ { x } \, \underset { \ } s u t i _ { x } \, \underset { \ } s u r _ { x } \, \underset { \ } s u t i _ { x }
$$

is   called   the   exponential map at x .   When   the   domain   of   deﬁnition   of   Exp x is   the   whole   T x M   for   all   x   ∈ M ,   the   manifold   M   (endowed   with   the   aﬃne   connection   ∇ )   is   termed   (geodesically) complete .   It   can   be   shown   that   Exp x deﬁnes   a   diﬀeomorphism   (smooth   bijection)   of  

It can be shown that Exp x defines a diffeomorphism (smooth bijection) of a neighborhood U ̂ of the origin 0 x ∈ T x M onto a neighborhood U of x ∈ M . If, moreover, U ̂ is star-shaped (i.e., ξ ∈ U ̂ implies tξ ∈ U ̂ for all 0 ≤ t ≤ 1), then U is called a normal  neighborhood of x . We can further define

$$
E _ { \ } \exp \colon T \mathcal { M } \to \mathcal { M } \colon \xi \mapsto E _ { \ } \exp _ { x } \xi ,
$$

[Page 116]

where   x   is   the   foot   of   ξ .   The   mapping   Exp   is   diﬀerentiable,   and   Exp x 0 x =   x   for   all   x   ∈ M .   Further,   it   can   be   shown   that   DExp x (0 x ) [ ξ ] =   ξ   (with   the   canonical   identiﬁcation   T 0 x T x M ≃   T x M ).   This   yields   the   following   result.    

Proposition 5.4.1 Let M be a manifold endowed with an aﬃne connection ∇ . The exponential map on M   induced by ∇   is a retraction, termed the exponential   retraction .

The   exponential   mapping   is   an   important   object   in   diﬀerential   geometry,   and   it   has   featured   heavily   in   previously   published   geometric   optimization   algorithms   on   manifolds.   It   generalizes   the   concept   of   moving   “straight”   in   the   direction   of   a   tangent   vector   and   is   a   natural   way   to   update   an   iterate   given   a   search   direction   in   the   tangent   space.   However,   computing   the   exponential   is,   in   general,   a   computationally   daunting   task.   Computing   the   exponential   amounts   to   evaluating   the   t   =   1   point   on   the   curve   deﬁned   by   the   second-order   ordinary   diﬀerential   equation   (5.24).   In   a   coordinate   chart   ( U , ϕ ),   (5.24)   reads   d 2   d   d  

$$
\frac { d ^ { 2 } } { d t ^ { 2 } } \, x ^ { k } + \sum _ { i , j } \Gamma _ { i j } ^ { k } ( \gamma ) \, \frac { d } { d t } \, x ^ { i } \, \frac { d } { d t } \, x ^ { j } = 0 , \quad k = 1 , \dots , n , \\ \text {re.} \, ( x ^ { 1 } ( t ) , \dots x ^ { n } ( t ) ) \, \colon = \, \varphi ( \gamma ( t ) ) \, \text { and } \Gamma _ { i j } ^ { k } \, \text { are the Christoffel symbols}
$$

where   ( x 1 ( t ) , . . . , x n ( t ))   :=   ϕ ( γ ( t ))   and   Γ k are   the   Christoﬀel   symbols   of   ij the   aﬃne   connection   in   the   chart   ( U , ϕ ).   In   general,   such   a   diﬀerential   equation   does   not   admit   a   closed-form   solution,   and   numerically   computing   the   geodesic   involves   computing   an   approximation   to   the   Christoﬀel   symbols   if   they   are   not   given   in   closed   form   and   then   approximating   the   geodesic   using   a   numerical   integration   scheme.   The   theory   of   general   retractions   is   introduced   to   provide   an   alternative   to   the   exponential   in   the   design   of   numerical   algorithms   that   retains   the   key   properties   that   ensure   convergence   results.  

Assume   that   a   basis   is   given   for   the   vector   space   T y M   and   let   U   be   a   normal   neighborhood   of   y .   Then   a   chart   can   be   deﬁned   that   maps   x   ∈ U   to   the   components   of   the   vector   ξ   ∈   T y M   satisfying   Exp ξ   =   x .   The   y coordinates   deﬁned   by   this   mapping   are   called   normal coordinates .  

We   also   point   out   the   following   fundamental   result   of   diﬀerential   geometry:   if   M   is   a   Riemannian   manifold,   a   curve   with   minimal   length   between   two   points   of   M   is   always   a   monotone   reparameterization   of   a   geodesic   relative   to   the   Riemannian   connection.   These   curves   are   called   minimizing geodesics .  

# Example 5.4.1 Sphere  

Consider the unit sphere S n − 1 endowed with the Riemannian metric (3.33)   obtained by embedding S n − 1 in R n and with the associated Riemannian connection (5.16) . Geodesics t    →   x ( t )   are expressed as a function of x (0)   ∈   S n − 1 and x ˙ (0)   ∈   T x (0) S n − 1 as follows (using the canonical inclusion of T x 0 S n − 1 in R n ):

$$
x ( t ) = x ( 0 ) \cos ( \| \dot { x } ( 0 ) \| t ) + \dot { x } ( 0 ) \frac { 1 } { \| \dot { x } ( 0 ) \| } \, \sin ( \| \dot { x } ( 0 ) \| t ) . \\ \intertext { I n d e e d \, i t \, i s \, r e a d i l y \, c h e c k e d \, t h a t \, \frac { \mathcal { D } ^ { 2 } } { D } \, x ( t ) = ( I _ { \mu } = x ( t ) x ( t ) ^ { T } ) \, \frac { \mathcal { d } ^ { 2 } } { x ( t ) } \, x ( t ) = - ( I _ { \mu } = }
$$

(Indeed, it is readily checked that d D t 2 2 x ( t ) = ( I   −   x ( t ) x ( t ) T )   d d t 2 2 x ( t ) =   − ( I   −   x ( t ) x ( t ) T )   x ˙ (0)   2 x ( t ) = 0 .)

[Page 117]

# Example 5.4.2 Orthogonal   Stiefel   manifold  

Consider the orthogonal Stiefel manifold St( p, n )   endowed with its Riemannian metric (3.34)   inherited from the embedding in R n × p and with the corresponding Riemannian connection ∇ . Geodesics t    →   X ( t )   are expressed as a function of X (0)   ∈   St( p, n )   and X ˙ (0)   ∈   T X (0) St( p, n )   as follows (using again the canonical inclusion of T X (0) St( p, n )   in R n × p ):    

$$
\text { again the canonical inclusion of } T _ { X ( 0 ) } & S ( t , n ) \text { in } \mathbb { R } ^ { n \times p } \colon \\ X ( t ) & = [ X ( 0 ) \ \dot { X } ( 0 ) ] \exp \left ( t \begin{bmatrix} A ( 0 ) & - S ( 0 ) \\ I & A ( 0 ) \end{bmatrix} \right ) \left [ \begin{matrix} I \\ 0 \end{matrix} \right ] \exp ( - A ( 0 ) t ) , \quad ( 5 . 2 6 ) \\ \text {where } A ( t ) & \colon = X ^ { T } ( t ) \dot { X } ( t ) \text { and } S ( t ) \, \colon = \, \dot { X } ^ { T } ( t ) \dot { X } ( t ) . \ \text {It can be shown that} \\ A \text { in } \text { any subset of } \mathcal { I } & \text {a} t \, \colon = \, \dot { X } ( t ) \, \dot { A } ( 0 ) \, \text { for } \text { all } t \, \colon \, \text {d} t \, \colon \, \text {that} \\
$$

where A ( t )   :=   X T ( t ) X ˙ ( t )   and S ( t )   :=   X ˙ T ( t ) X ˙ ( t ) . It can be shown that A   is an invariant of the trajectory, i.e., A ( t ) =   A (0)   for all t , and that S ( t ) =   e At S (0) e − At .

# Example 5.4.3 Grassmann   manifold  

Consider the Grassmann manifold Grass( p, n )   viewed as a Riemannian quotient manifold of R n ∗ × p with the associated Riemannian connection (5.22) . Then −

$$
\mathcal { Y } ( t ) = \text {span} ( Y _ { 0 } ( Y _ { 0 } ^ { T } Y _ { 0 } ) ^ { - 1 / 2 } V \cos ( \Sigma t ) + U \sin ( \Sigma t ) ) \\ \ t h e a n d e d o w i s e t i f u i n g e r \, \mathcal { Y } ( 0 ) = \underset { \overline { \dot { \jmath } } } { \text {overline { \ } } } \sum _ { \overline { \dot { \jmath } } } U \sum _ { \overline { \psi } ( 0 ) } T \quad \text {upharpoonleft}
$$

is the geodesic satisfying Y (0)   =   span( Y 0 )   and Y ˙ (0) =   U Σ V   T , where Y 0 U Σ V   T is a thin singular value decomposition, i.e., U   is n   ×   p   orthonormal, V   is p   ×   p   orthonormal, and Σ   is p   ×   p   diagonal with nonnegative elements. Note that choosing Y 0 orthonormal simpliﬁes the expression (5.27) .

Let   M   be   a   manifold   endowed   with   an   aﬃne   connection   ∇ .   A   vector   ﬁeld   ξ   on   a   curve   γ   satisfying   d D t ξ   =   0   is   called   parallel .   Given   a   ∈   R   in   the   domain   of   γ   and   ξ γ ( a ) ∈   T γ ( a ) M ,   there   is   a   unique   parallel   vector   ﬁeld   ξ   on   γ   such   that   ξ ( a ) =   ξ γ ( a ) .   The   operator   P γ b ← a sending   ξ ( a )   to   ξ ( b )   is   called   parallel translation along γ .   In   other   words,   we   have    

$$
\frac { \ D } { \ D t } \left ( P _ { \gamma } ^ { t \leftarrow a } \xi ( a ) \right ) = 0 .
$$

If M is a Riemannian manifold and ∇ is the Riemannian connection, then the parallel translation induced by ∇ is an isometry.

translation   is   a   particular   instance   of   a   more   general   concept   termed   vector   transport,   introduced   in   Section   8.1.   More   information   on   vector   transport   by   parallel   translation,   including   formulas   for   parallel   translation   on   special   manifolds,   can   be   found   in   Section   8.1.1.   The   machinery   of   retraction   (to   replace   geodesic   interpolation)   and   vector   transport   (to   replace   parallel   translation)   are   two   of   the   key   insights   in   obtaining   competitive   numerical   algorithms   based   on   a   geometric   approach.  

# 5.5 RIEMANNIAN HESSIAN OPERATOR

We   conclude   this   chapter   with   a   discussion   of   the   notion   of   a   Hessian.   The   Hessian   matrix   of   a   real-valued   function   f   on   R n at   a   point   x   ∈   R n is   classically   deﬁned   as   the   matrix   whose   ( i, j )   element   ( i th   row   and   j th   column)  

[Page 118]

is   given   by   ∂ 2 f ( x ) =   ∂ 2 ij ∂ i ∂ j f ( x ).   To   formalize   this   concept   on   a   manifold   we   need   to   think   of   the   Hessian   as   an   operator   acting   on   geometric   objects   and   returning   geometric   objects.   For   a   real-valued   function   f   on   an   abstract   Euclidean   space   E ,   the   Hessian   operator   at   x   is   the   (linear)   operator   from   E to   E   deﬁned   by   2 1 n j  

$$
\text {Hess} f ( x ) [ z ] \colon = & \sum _ { i j } \partial _ { i j } ^ { 2 } \hat { f } ( x ^ { 1 } , \dots , x ^ { n } ) z ^ { j } e _ { i } , \\ \quad \vdots & \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \hat { f } ( x ) .
$$

j where   ( e i ) i =1 ,...,n is   an   orthonormal   basis   of   E ,   z   =     z e j and   f ˆ   is   the   j function   on   R n deﬁned   by   f ˆ ( x 1 , . . . , x n ) =   f ( x 1 e 1 + +   x n e n ).   It   is   a ···   standard   real   analysis   exercise   to   show   that   the   deﬁnition   does   not   depend   on   the   choice   of   the   orthonormal   basis.   Equivalently,   the   Hessian   operator   of   f   at   x   can   be   deﬁned   as   the   operator   from   E   to   E   that   satisﬁes,   for   all   y, z   ∈ E ,   2

1.     Hess   f ( x )[ y ] , y     = D 2 f ( x )[ y, y ]   :=   d   t =0 f ( x   +   ty ) , d t 2 2.     Hess   f ( x )[ y ] , z     =     y,   Hess   f ( x )[ z ]     (symmetry).   On   an   arbitrary   Riemannian   manifold,   the   Hessian   operator

On an arbitrary Riemannian manifold, the Hessian operator is generalized as follows.

Deﬁnition 5.5.1 Given a real-valued function f   on a Riemannian manifold M , the Riemannian   Hessian   of f   at a point x   in M   is the linear mapping Hess   f ( x )   of T x M   into itself deﬁned by

$$
H e s s \, f ( x ) [ \xi _ { x } ] & = \nabla _ { \xi _ { x } } \, g r a d \, f \\
$$

for all ξ x in T x M , where ∇   is the Riemannian connection on M .

If   M   is   a   Euclidean   space,   this   deﬁnition   reduces   to   (5.28).   (A   justiﬁcation   for   the   name   “Riemannian   Hessian”   is   that   the   function   m x ( y )   :=   f ( x ) +     grad   f ( x ) ,   Exp − x 1 ( y )   x +   1 x 2   Hess   f ( x )[Exp − 1 ( y )] ,   Exp − 1 ( y )     is   a   second-order   x model   of   f   around   x ;   see   Section   7.1.)  

Proposition 5.5.2 The Riemannian Hessian satisﬁes the formula

$$
\langle H e s s \, f [ \xi ] , \eta \rangle = \xi ( \eta f ) - ( \nabla _ { \xi } \eta ) f \\
$$

for all ξ, η   ∈   X ( M ) .

Proof. We   have     Hess   f [ ξ ] , η     =    ∇ ξ grad   f, η   .   Since   the   Riemannian   connection   leaves   the   Riemannian   metric   invariant,   this   is   equal   to   ξ   grad   f, η  −     grad   f,   ∇ ξ η   .   By   deﬁnition   of   the   gradient,   this   yields   ξ ( ηf )   −   ( ∇ ξ η ) f .      

Proposition 5.5.3 The Riemannian Hessian is symmetric (in the sense of the Riemannian metric). That is,

for all ξ, η   ∈   X ( M ) .

$$
\langle H e s s \, f [ \xi ] , \eta \rangle = \langle \xi , H e s s \, f [ \eta ] \rangle
$$

[Page 119]

The following result shows that the Riemannian Hessian of a function f at   a   point   x   coincides   with   the   Euclidean   Hessian   of   the   function   f   Exp ◦   x at   the   origin   0 x ∈   T x M .   Note   that   f   Exp is   a   real-valued   function   on   the   ◦   x Euclidean   space   T x M .  

Proposition 5.5.4 Let M   be a Riemannian manifold and let f   be a realvalued function on M . Then Hess   f ( x )   =   Hess   ( f   Exp )(0 )   (5.30)    

$$
H e s s \, f ( x ) & = H e s s \left ( f \circ \exp _ { x } ( ) ( 0 _ { x } ) & ( 5 . 3 0 ) \\ \\ \Lambda _ { 4 } \ w h o r a \ H o s s \, f ( x ) & \, d o n o t a _ { \ } t h o \, \ B i o m n i a n \, \ H o s i o n \, \ o f \, f \, \colon
$$

for all x   ∈ M , where Hess   f ( x )   denotes the Riemannian Hessian of f   :   M →   R   at x   and Hess ( f   ◦   Exp x )(0 x )   denotes the Euclidean Hessian of f   Exp x :   T x M →   R   at the origin of T x M   endowed with the inner product ◦ deﬁned by the Riemannian structure on M .                      

Proof. This result can be proven by working in normal coordinates and invoking   the   fact   that   the   Christoﬀel   symbols   vanish   in   these   coordinates.   We   provide   an   alternative   proof   that   does   not   make   use   of   index   notation.   We   have   to   show   that  

$$
\langle H e s s \, f ( x ) [ \xi ] , \eta \rangle & = \langle H e s s \, ( f \circ E x p _ { x } ) ( 0 _ { x } ) [ \xi ] , \eta \rangle \\ \| \varsigma _ { x } \, \cap \, T \, \mathcal { M } \, \sin o b { \, t i d s o f } \, ( 5 \, 3 1 ) \, o r \, \text {symmetr i a bilinear forms}
$$

for   all   ξ, η   ∈   T x M .   Since   both   sides   of   (5.31)   are   symmetric   bilinear   forms   in   ξ   and   η ,   it   is   suﬃcient   to   show   that  

$$
\langle H e s s \, f ( x ) [ \xi ] , \xi \rangle & = \langle H e s s \, ( f \circ E x p _ { x } ) ( 0 _ { x } ) [ \xi ] , \xi \rangle \\ \| \varsigma \subset T \ A d o d \ \text { for any symmetric form } B \ \text { over } t h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o w h o
$$

for   all   ξ   ∈   T x M .   Indeed,   for   any   symmetric   linear   form   B ,   we   have   the   polarization identity

$$
2 B ( \xi , \eta ) = B ( \xi + \eta , \xi + \eta ) - B ( \xi , \xi ) - B ( \eta , \eta ) , \\ \text {shows } \tt t h o t \, + \tt t h o \, \ m o p i n g \, \left ( \xi _ { \ } n \right ) \, + \, B ( \xi _ { \ } n ) \, \text { is full } \tt t h o \, \Omega o i f o d \,
$$

which   shows   that   the   mapping   ( ξ, η )    →   B ( ξ, η )   is   fully   speciﬁed   by   the   mapping   ξ    →   B ( ξ, ξ ).   Since   the   right-hand   side   of   (5.32)   involves   a   classical   (Euclidean)   Hessian,   we   have  

$$
( E u c l i d e a ) \, H e s i _ { \ } m e a \, & \quad \text {, we have} \\ ( H e s s ( f \circ E x p _ { x } ) ( 0 _ { x } ) [ \xi ] , \xi ) = \frac { d ^ { 2 } } { d t ^ { 2 } } ( f \circ E x p _ { x } ) ( t \xi ) \Big | _ { t = 0 } \\ = \frac { d } { d t } \left ( \frac { d } { d t } \, f ( E x p _ { x } ( t \xi ) ) \right ) \Big | _ { t = 0 } \, = \frac { d } { d t } \left ( D f ( E x p _ { x } \xi ) \left [ \frac { d } { d t } \, E x p _ { t } \xi \right ] \right ) \Big | _ { t = 0 } . \\ \intertext { It follows from the definition of the gradient that this last expression is } \, \text {equal to } \frac { d } { d t } ( g r a d f ( E x p _ { x } \xi ) , \frac { d } { d t } \, E x p _ { x } \xi ) | _ { t = 0 } . \, By the invariance property of }
$$

=   d t     d t f (Exp x ( tξ ))       t =0 =   d t     D f (Exp x tξ )     d t   Exp x tξ        t =0 .   It   follows   from   the   deﬁnition   of   the   gradient   that   this   last   expression   is   equal   to   d d t   grad   f (Exp x tξ ) ,   d d t x tξ     t =0 Exp .   By   the   invariance   property   of   the   metric,   this   is   equal   to       D D 2 grad   f (Exp tξ ) , ξ     +     grad   f ( x ) ,   Exp tξ   . d t x d t 2 x By   deﬁnition   of   the   exponential   mapping,   we   have   D 2 Exp tξ   =   0   and   d t x tξ   t =0 d t 2 x d Exp =   ξ .   Hence   the   right-hand   side   of   (5.32)   reduces   to  

d t ∣ ∣ t =0

$$
\langle \nabla _ { \xi } \text { grad } f , \xi \rangle ,
$$

[Page 120]

and   the   proof   is   complete.  

/square

The   result   is   in   fact   more   general.   It   holds   whenever   the   retraction   and   the   Riemannian   exponential   agree   to   the   second   order   along   all   rays.   This   result   will   not   be   used   in   the   convergence   analyses,   but   it   may   be   useful   to   know   that   various   retractions   yield   the   same   Hessian   operator.  

Proposition 5.5.5 Let R   be a retraction and suppose in addition that

$$
2 5 . 5 \, \text { Let } R \, \text { be a retraction and suppose in addition that} \\ \frac { D ^ { 2 } } { d t ^ { 2 } } \, R ( t \xi ) \Big | _ { t = 0 } \, \text { for all } \xi \in T _ { x } \mathcal { M } , \\ \gamma \, \text { denotes acceleration of the curve } \gamma \, \text { as defined in } ( 5 . 2 3 ) . \text { Then}
$$

∣ where d D t 2 2 γ denotes  acceleration  of  the  curve γ as defined in (5.23) . Then

$$
H e s s \, f ( x ) = H e s s \left ( f \circ R _ { x } \right ) ( 0 _ { x } ) . \\ \\ c _ { \ } s \, v _ { 0 } = 1 - \hat { c } _ { 0 } \hat { c } _ { 1 } - 2 \hat { c } _ { 0 } + \hat { c } _ { 1 } + 1 - \hat { c } _ { 0 } \hat { c } _ { 2 }
$$

Proof. The   proof   follows   the   proof   of   Proposition   5.5.4,   replacing   Exp x by   R x throughout.   The   ﬁrst-order   ridigidity   condition   of   the   retraction   implies   that   d R x =   ξ .   Because   of   this   and   of   (5.33),   we   conclude   as   in   the   d t tξ   t =0 proof   of   Proposition   5.5.4.       Proposition   5.5.5   provides   a   way   to   compute   the   Riemannian   Hessian   as  

the   Hessian   of   a   real-valued   function   f R x deﬁned   on   the   Euclidean   space   ◦ T x M .   In   particular,   this   yields   a   way   to   compute     Hess   f ( x )[ ξ ] , η     by   taking   second   derivatives   along   curves,   as   follows.   Let   R   be   any   retraction   satisfying   the   acceleration   condition   (5.33).   First,   observe   that,   for   all   ξ   ∈   T x M ,   d 2

$$
t \, \text {acceleration condition (5.33). First, observe that, for all } \xi \in T _ { x } \mathcal { M } , \\ ( H e s s \, f ( x ) [ \xi ] , \xi ) = \langle H e s s \, ( f \circ R _ { x } ) ( 0 _ { x } [ \xi ] , \xi ) = \frac { d ^ { 2 } } { d t ^ { 2 } } \, f ( R _ { x } ( t \xi ) ) \Big | _ { t = 0 } . \quad ( 5 . 3 5 ) \\ \text {Second, in view of the symmetry of the linear operator H e s s } f ( x ) , \, \text {we have} \\ \text {the polarization identity}
$$

∣ Second, in view of the symmetry of the linear operator Hess f ( x ), we have the polarization identity

$$
\langle H e s s \, f ( x ) [ \xi ] , \eta \rangle = \frac { 1 } { 2 } ( \langle H e s s \, f ( x ) [ \xi + \eta ] , \xi + \eta \rangle \\ - \langle H e s s \, f ( x ) [ \xi ] , \xi \rangle - \langle H e s s \, f ( x ) [ \eta ] , \eta \rangle ) . \quad ( 5 . 3 6 ) \\ \text {Equations (5.3 5) and (5.3 6) yield the identity}
$$

Equations   (5.35)   and   (5.36)   yield   the   identity  

$$
\langle H e s f ( x ) [ \xi ] , \eta \rangle \\ = \frac { 1 } { 2 } \, \frac { d ^ { 2 } } { d t ^ { 2 } } \left ( f ( R _ { x } ( t ( \xi + \eta ) ) ) - f ( R _ { x } ( t \xi ) ) - f ( R _ { x } ( \eta ) ) \right ) _ { t = 0 } ^ { 2 } , \quad ( 5 . 3 ) \\ \text {valid for any retraction } R \text { that satisfies the zero initial acceleration condition} \\ \text {tion (5.33). This holds in particular for } R = \exp , \text { the exponential retraction.}
$$

∣ valid for any retraction R that satisfies the zero initial acceleration condition (5.33). This holds in particular for R = Exp, the exponential retraction.

Retractions   that   satisfy   the   zero   initial   acceleration   condition   (5.33)   will   be   called   second-order retractions .   For   general   retractions   the   equality   of   the   Hessians   stated   in   (5.34)   does   not   hold.   Nevertheless,   none   of   our   quadratic   convergence   results   will   require   the   retraction   to   be   second   order.   The   fundamental   reason   can   be   traced   in   the   following   property.  

Proposition 5.5.6 Let R   be a retraction and let v   be a critical point of a real-valued function f   (i.e., grad   f ( v ) = 0 ). Then

$$
H e s s \, f ( v ) = H e s s ( f \circ R _ { v } ) ( 0 _ { v } ) .
$$

[Page 121]

# 5.6 SECOND COV ARIANT DERIV ATIVE*

In   the   previous   section,   we   assumed   that   the   manifold   M   was   Riemannian.   This   assumption   made   it   possible   to   replace   the   diﬀerential   D f ( x )   of   a   function   f   at   a   point   x   by   the   tangent   vector   grad   f ( x ),   satisfying  

$$
\langle \text {grad} \, f ( x ) , \xi \rangle = D f ( x ) [ \xi ] \quad \text {for all} \, \xi \in T _ { x } \mathcal { M } . \\ \intertext { t o t h o d f i n t i o n o f H o c s f ( e ) }
$$

This   led   to   the   deﬁnition   of   Hess   f ( x ) :   ξ x  →   ∇ ξ x grad   f   as   a   linear   operator   of   T x M   into   itself.   This   formulation   has   several   advantages:   eigenvalues   and   eigenvectors   of   the   Hessian   are   well   deﬁned   and,   as   we   will   see   in   Chapter   6,   the   deﬁnition   leads   to   a   streamlined   formulation   (6.4)   for   the   Newton   equation.   However,   on   an   arbitrary   manifold   equipped   with   an   aﬃne   connection,   it   is   equally   possible   to   deﬁne   a   Hessian   as   a   second   covariant   derivative   that   applies   bilinearly   to   two   tangent   vectors   and   returns   a   scalar.   This   second   covariant   derivative   is   often   called   “Hessian”   in   the   literature,   but   we   will   reserve   this   term   for   the   operator   ξ x  →   ∇ ξ x grad   f .   To   develop   the   theory   of   second   covariant   derivative,   we   will   require   the  

∗ concept   of   a   covector.   Let   T x M   denote   the   dual   space   of   T x M ,   i.e.,   the   set   of   linear   functionals   (linear   maps)   µ x :   T x M   →   R .   The   set   T x ∗   M   is   termed   the   cotangent space of   M   at   x ,   and   its   elements   are   called   covectors .   The   bundle   of   cotangent   spaces  

$$
T ^ { * } \mathcal { M } = \cup _ { x \in \mathcal { M } } T _ { x } ^ { * } \mathcal { M } \\ \intertext { w n d l o } \intertext { s u p d l o } T h o w t h o o t o n g o n t h o w n d }
$$

is   termed   the   cotangent bundle .   The   cotangent   bundle   can   be   given   the   structure   of   a   manifold   in   an   analogous   manner   to   the   structure   of   the   tangent   bundle.   A   smooth   section   of   the   cotangent   bundle   is   a   smooth   assignment   x    →   µ x ∈   T x ∗   M .   A   smooth   section   of   the   cotangent   bundle   is   termed   a   covector ﬁeld or   a   one-form on   M .   The   name   comes   from   the   fact   that   a   one-form   ﬁeld   µ   acts   on   “one”   vector   ﬁeld   ξ   ∈   X ( M )   to   generate   a   scalar   ﬁeld   on   a   manifold,  

$$
\mu [ \xi ] \in \widetilde { \mathfrak { F } } ( \mathcal { M } ) , \\ T h _ { o } o t i o n _ { o } f _ { o }
$$

deﬁned   by   ( µ [ ξ ]) x =   µ x [ ξ x ].   The   action   of   a   covector   ﬁeld   µ   on   a   vector   | ﬁeld   ξ   is   often   written   simply   as   a   concatenation   of   the   two   objects,   µξ . A  

[Page 122]

covector   is   a   (0 ,   1)-tensor.   The   most   common   covector   encountered   is   the   diﬀerential   of   a   smooth   function   f   :   M →   R :   µ x = D f ( x ) .  

$$
\mu _ { x } = D f ( x ) .
$$

Note   that   the   covector   ﬁeld   D f   is   zero   exactly   at   critical   points   of   the   function   f .   Thus,   another   way   of   solving   for   the   critical   points   of   f   is   to   search   for   zeros   of   D f .  

Given   a   manifold   M   with   an   aﬃne   connection   ∇ ,   a   real-valued   function   f   on   M ,   a   point   x   ∈ M ,   and   a   tangent   vector   ξ x ∈   T x M ,   the   covariant   derivative   of   the   covector   ﬁeld   D f   along   ξ x is   a   covector   ∇ ξ x (D f )   deﬁned   by   imposing   the   property  

$$
D ( D f [ \eta ] ) ( x ) [ \xi _ { x } ] & = ( \nabla _ { \xi _ { x } } ( D f ) ) \left [ \eta _ { x } \right ] + D f ( x ) [ \nabla _ { \xi _ { x } } \eta ] \\ \left \| \, \eta \in \mathfrak { F } ( \mathcal { M } ) \ \text {It is read-only checked} \ \text {using coordinate expressions} \right \|
$$

for   all   η   ∈   X ( M ).   It   is   readily   checked,   using   coordinate   expressions,   that   ( ∇ ξ x (D f )) [ η x ]   deﬁned   in   this   manner   depends   only   on   η   through   η x and   that   ( ∇ ξ x (D f )) [ η x ]   is   a   linear   expression   of   ξ x and   η x .   The   second covariant derivative of   the   real-valued   function   f   is   deﬁned   by  

$$
\nabla ^ { 2 } \, f ( x ) [ \xi _ { x } , \eta _ { x } ] = ( \nabla _ { \xi _ { x } } ( D f ) ) \, [ \eta _ { x } ] . \\ \text {sk of confusing } [ \xi _ { x } \, , \eta _ { x } ] \text { with } a \text { } I j e \text { bracket } \text { } s k e t \text { }
$$

∇ ∇ x (There   is   no   risk   of   confusing   [ ξ x , η x ]   with   a   Lie   bracket   since   ∇ 2 f ( x )   is   known   to   apply   to   two   vector   arguments.)   The   notation   ∇ 2 rather   than   D 2 is   used   to   emphasize   that   the   second   covariant   derivative   depends   on   the   choice   of   the   aﬃne   connection   ∇ .   With   development   analogous   to   that   in   the   preceding   section,   one   may  

With development analogous to that in the preceding section, one may show that

$$
\nabla ^ { 2 } \, f ( x ) [ \xi _ { x } , \eta _ { x } ] = \xi _ { x } ( \eta f ) - ( \nabla _ { \xi _ { x } } \eta ) f . \\ \text {variant derivative is symmetric if and only if } \nabla
$$

The   second   covariant   derivative   is   symmetric   if   and   only   if   ∇   is   symmetric.   For   any   second-order   retraction   R ,   we   have  

$$
\nabla ^ { 2 } \, f ( x ) = D ^ { 2 } \left ( f \circ R _ { x } \right ) ( 0 _ { x } ) , \\ \, ) \, \text {is the classical second-order derivative}
$$

∇ ◦ where   D 2 ( f R x )(0 x )   is   the   classical   second-order   derivative   of   f R x at   0 x ◦ ◦ (see   Section   A.5).   In   particular,  

$$
\nabla ^ { 2 } \, f ( x ) [ \xi _ { x } , \xi _ { x } ] = D ^ { 2 } \left ( f \circ \exp _ { x } ( 0 _ { x } ) [ \xi _ { x } , \xi _ { x } ] = \frac { d ^ { 2 } } { d t ^ { 2 } } f ( \exp _ { x } ( t \xi ) ) | _ { t = 0 } . \\ \intertext { W h o n $ j $ o r i t i o l $ p $ o r $ f $ o r $ v $ h o w $ }
$$

When   x   is   a   critical   point   of   f ,   we   have  

$$
\nabla ^ { 2 } f ( x ) = D ^ { 2 } \left ( f \circ R _ { x } \right ) ( 0 _ { x } )
$$

for   any retraction   R .  

When   M   is   a   Riemannian   manifold   and   ∇   is   the   Riemannian   connection,   we   have  

$$
\nabla ^ { 2 } \, f ( x ) [ \xi _ { x } , \eta _ { x } ] = \langle H e s s \, f ( x ) [ \xi _ { x } ] , \eta _ { x } \rangle .
$$

When   F   is   a   function   on   M   into   a   vector   space   E ,   it   is   still   possible   to   uniquely   deﬁne  

$$
\nabla ^ { 2 } \, F ( x ) [ \xi _ { x } , \eta _ { x } ] = \sum _ { i = 1 } ^ { n } ( \nabla ^ { 2 } \, F ^ { i } ( x ) [ \xi _ { x } , \eta _ { x } ] ) e _ { i } , \\ \dots , e _ { n } ) \, \text { is a basis of } \mathcal { E } .
$$

where   ( e 1 , . . . , e n )   is   a   basis   of   E .  

[Page 123]

# 5.7 NOTES AND REFERENCES

Our   main   sources   for   this   chapter   are   O’Neill   [O’N83]   and   Brickell   and   Clark   [BC70].   n

A   proof   of   superlinear   convergence   for   Newton’s   method   in   R can   be   found   in   [DS83,   Th.   5.2.1].   A   proof   of   Proposition   5.2.1   (the   existence   of   aﬃne   connections)   is   given   in   [BC70,   Prop.   9.1.4].   It   relies   on   partitions   of   unity   (see   [BC70,   Prop.   3.4.4]   or   [dC92,   Th.   0.5.6]   for   details).   For   a   proof   of   the   existence   and   uniqueness   of   the   covariant   derivative   along   curves   d D t ,   we   refer   the   reader   to   [O’N83,   Prop.   3.18]   for   the   Riemannian   case   and   Helgason   [Hel78,   § I.5]   for   the   general   case.   More   details   on   the   exponential   can   be   found   in   do   Carmo   [dC92]   for   the   Riemannian   case,   and   in   Helgason   [Hel78]   for   the   general   case.   For   a   proof   of   the   minimizing   property   of   geodesics,   see   [O’N83,   § 5.19].   The   material   about   the   Riemannian   connection   on   Riemannian   submanifolds   comes   from   O’Neill   [O’N83].   For   more   details   on   Riemannian   submersions   and   the   associated   Riemannian   connections,   see   O’Neill   [O’N83,   Lemma   7.45],   Klingenberg   [Kli82],   or   Cheeger   and   Ebin   [CE75].  

The   equation   (5.26)   for   the   Stiefel   geodesic   is   due   to   R.   Lippert;   see   Edelman   et al. [EAS98].   The   formula   (5.27)   for   the   geodesics   on   the   Grassmann   manifold   can   be   found   in   Absil   et al. [AMS04].   Instead   of   considering   the   Stiefel   manifold   as   a   Riemannian   submanifold   of   R n × p ,   it   is   also   possible   to   view   the   Stiefel   manifold   as   a   certain   Riemannian   quotient   manifold   of   the   orthogonal   group.   This   quotient   approach   yields   a   diﬀerent   Riemannian   metric   on   the   Stiefel   manifold,   called   the   canonical metric in   [EAS98].   The   Riemannian   connection,   geodesics,   and   parallel   translation   associated   with   the   canonical   metric   are   diﬀerent   from   those   associated   with   the   Riemannian   metric   (3.34)   inherited   from   the   embedding   of   St( p, n )   in   R n × p .   We   refer   the   reader   to   Edelman   et al. [EAS98]   for   more   information   on   the   geodesics   and   parallel   translations   on   the   Stiefel   manifold.  

The   geometric   Hessian   is   not   a   standard   topic   in   diﬀerential   geometry.   Some   results   can   be   found   in   [O’N83,   dC92,   Sak96,   Lan99].   The   Hessian   is   often   deﬁned   as   a   tensor   of   type   (0 ,   2)—it   applies   to   two   vectors   and   returns   a   scalar—using   formula   (5.29).   This   does   not   require   a   Riemannian   metric.   Such   a   tensor   varies   under   changes   of   coordinates   via   a   congruence   transformation.   In   this   book,   as   in   do   Carmo   [dC92],   we   deﬁne   the   Hessian   as   a   tensor   of   type   (1 ,   1),   which   can   thus   be   viewed   as   a   linear   transformation   of   the   tangent   space.   It   transforms   via   a   similarity   transformation,   therefore   its   eigenvalues   are   well   deﬁned   (they   do   not   depend   on   the   chart).  

[Page 124]

# Newton’s   Method  

This   chapter   provides   a   detailed   development   of   the   archetypal   second-order   optimization   method,   Newton’s   method,   as   an   iteration   on   manifolds.   We   propose   a   formulation   of   Newton’s   method   for   computing   the   zeros   of   a   vector   ﬁeld   on   a   manifold   equipped   with   an   aﬃne   connection   and   a   retraction.   In   particular,   when   the   manifold   is   Riemannian,   this   geometric   Newton   method   can   be   used   to   compute   critical   points   of   a   cost   function   by   seeking   the   zeros   of   its   gradient   vector   ﬁeld.   In   the   case   where   the   underlying   space   is   Euclidean,   the   proposed   algorithm   reduces   to   the   classical   Newton   method.   Although   the   algorithm   formulation   is   provided   in   a   general   framework,   the   applications   of   interest   in   this   book   are   those   that   have   a   matrix   manifold   structure   (see   Chapter   3).   We   provide   several   example   applications   of   the   geometric   Newton   method   for   principal   subspace   problems.  

# 6.1 NEWTON’S METHOD ON MANIFOLDS

In   Chapter   5   we   began   a   discussion   of   the   Newton   method   and   the   issues   involved   in   generalizing   such   an   algorithm   on   an   arbitrary   manifold.   Section   5.1   identiﬁed   the   task   as   computing   a   zero   of   a   vector   ﬁeld   ξ   on   a   Riemannian   manifold   M   equipped   with   a   retraction   R .   The   strategy   proposed   was   to   obtain   a   new   iterate   x k +1 from   a   current   iterate   x k by   the   following   process.  

1. 	 Find   a   tangent   vector   η k ∈   T x k M   such   that   the   “directional   derivative”   of   ξ   along   η k is   equal   to   − ξ .   2. 	 Retract   η k to   obtain   x k +1 .  

Retract η k to obtain x k +1 .

In   Section   5.1   we   were   unable   to   progress   further   without   providing   a   generalized   deﬁnition   of   the   directional   derivative   of   ξ   along   η k .   The   notion   of   an   aﬃne   connection,   developed   in   Section   5.2,   is   now   available   to   play   such   a   role,   and   we   have   all   the   tools   necessary   to   propose   Algorithm   4,   a   geometric   Newton   method   on   a   general   manifold   equipped   with   an   aﬃne   connection   and   a   retraction.  

By   analogy   with   the   classical   case,   the   operator  

$$
J ( x ) \colon T _ { x } \mathcal { M } \to T _ { x } \mathcal { M } \colon \eta \mapsto \nabla _ { \eta } \xi \\
$$

involved   in   (6.1)   is   called   the   Jacobian of ξ   at x .   Equation   (6.1)   is   called   the   Newton equation ,   and   its   solution   η k ∈   T x k M   is   called   the   Newton vector .  

[Page 125]

# Algorithm 4 Geometric   Newton   method   for   vector   ﬁelds  

Require: Manifold M ; retraction R on M ; affine connection ∇ on M ; vector fi eld ξ on M .

Goal: Find a zero of ξ , i.e., x ∈ M such that ξ x = 0.

Initial iterate x 0 ∈ M .

Input:

Output: Sequence of iterates { x k } .

- 1: for k = 0 , 1 , 2 , . . . do
- 2:   Solve   the   Newton   equation  


$$
J ( x _ { k } ) \eta _ { k } & = \ - \xi _ { x _ { k } } \\ \\ \bar { \ } _ { T } \, \bar { \ } _ { T } \, \bar { \ } _ { k } \, \bar { \ } _ { T } \, \bar { \ } _ { k } \, \bar { \ } _ { T } \, \bar { \ } _ { k } \, \bar { \ } _ { T }
$$

for   the   unknown   η k ∈   T x k M ,   where   J ( x k ) η k :=   ∇ η k ξ .   Set  

- 3: Set

$$
x _ { k + 1 } \colon = R _ { x _ { k } } ( \eta _ { k } ) .
$$

- 4:   end for


In   Algorithm   4,   the   choice   of   the   retraction   R   and   the   aﬃne   connection   ∇   is   not   prescribed.   This   freedom   is   justiﬁed   by   the   fact   that   superlinear   convergence   holds   for   every   retraction   R   and   every   aﬃne   connection   ∇   (see   forthcoming   Theorem   6.3.2).   Nevertheless,   if   M   is   a   Riemannian   manifold,   there   is   a   natural   connection—the   Riemannian   connection—and   a   natural   retraction—the   exponential   mapping.   From   a   computational   viewpoint,   choosing   ∇   as   the   Riemannian   connection   is   generally   a   good   choice,   notably   because   it   admits   simple   formulas   on   Riemannian   submanifolds   and   on   Riemannian   quotient   manifolds   (Sections   5.3.3   and   5.3.4).   In   contrast,   instead   of   choosing   R   as   the   exponential   mapping,   it   is   usually   desirable   to   consider   alternative   retractions   that   are   computationally   more   eﬃcient;   examples   are   given   in   Section   4.1.  

When   M   is   a   Riemannian   manifold,   it   is   often   advantageous   to   wrap   Algorithm   4   in   a   line-search   strategy   using   the   framework   of   Algorithm   1.   At   the   current   iterate   x k ,   the   search   direction   η k is   computed   as   the   solution   of   the   Newton   equation   (6.1),   and   x k +1 is   computed   to   satisfy   the   descent   condition   (4.12)   in   which   the   cost   function   f   is   deﬁned   as  

$$
f \colon = \langle \xi , \xi \rangle . \\ \intertext { f \colon = \langle \xi , \xi \rangle . } \intertext { a o f f o r o w t h o w }
$$

Note   that   the   global   minimizers   of   f   are   the   zeros   of   the   vector   ﬁeld   ξ .   Moreover,   if   ∇   is   the   Riemannian   connection,   then,   in   view   of   the   compatibility   with   the   Riemannian   metric   (Theorem   5.3.1.ii),   we   have  

$$
D \langle \xi , \xi \rangle \left ( x _ { k } \right ) [ \eta _ { k } ] = \langle \nabla _ { \eta _ { k } } \xi , \xi \rangle + \langle \xi , \nabla _ { \eta _ { k } } \xi \rangle = - 2 \langle \xi , \xi \rangle _ { x _ { k } } < 0 \\ \intertext { w h o n o v o r } \intertext { w h o n o v o r } \xi \neq 0 \ \intertext { I t h o l l w o r w e t h o t + h o t } \intertext { N o w t o n w o r t o n w o r t o n } \intertext { i n a n d o s c o n t d i r o t i o n }
$$

/negationslash

  whenever   ξ   =   0.   It   follows   that   the   Newton   vector   η k is   a   descent   direction   for   f ,   although   { η k }   is   not   necessarily   gradient-related.   This   perspective   provides   another   motivation   for   choosing   ∇   in   Algorithm   4   as   the   Riemannian   connection.  

Note that an analytical expression of the Jacobian J ( x ) in the Newton equation (6.1) may not be available. The Jacobian may also be singular or ill-conditioned, in which case the Newton equation cannot be reliably solved for η k . Remedies to these difficulties are provided by the quasi-Newton approaches presented in Section 8.2.

[Page 126]

# 6.2 RIEMANNIAN NEWTON METHOD FOR REAL-V ALUED FUNCTIONS

We   now   discuss   the   case   ξ   =   grad   f ,   where   f   is   a   cost   function   on   a   Riemannian   manifold   M .   The   Newton   equation   (6.1)   becomes            

$$
H e s s \, f ( x _ { k } ) \eta _ { k } = - \text {grad} \, f ( x _ { k } ) ,
$$

where  

$$
H e s s \, f ( x ) \colon T _ { x } \mathcal { M } \to T _ { x } \mathcal { M } \colon \eta \mapsto \nabla _ { \eta } \text { grad } f \\ \vdots \quad _ { x } \, f \, _ { x } \, \dots \, _ { x } \, f \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x } \, \dots \, _ { x
$$

is   the   Hessian   of   f   at   x   for   the   aﬃne   connection   ∇ .   We   formalize   the   method   in   Algorithm   5   for   later   reference.   Note   that   Algorithm   5   is   a   particular   case   of   Algorithm   4.  

# Algorithm 5 Riemannian   Newton   method   for   real-valued   functions  

Require: Riemannian manifold M ; retraction R on M ; affine connection

∇ on M ; real-valued function f on M .

Goal: Find a critical point of f , i.e., x ∈ M such that grad f ( x ) = 0.

Initial iterate x 0 ∈ M .

Input:

Sequence of iterates { x k } .

Output:

- 1: for k = 0 , 1 , 2 , . . . do
- 2:   Solve   the   Newton   equation  


$$
& \text {Hess} \, f ( x _ { k } ) \eta _ { k } = \, - \text {grad} \, f ( x _ { k } ) & \\ & \quad - \tau \, \Omega ( x _ { k } ) \Omega ( x _ { k } ) &
$$

for   the   unknown   η k ∈   T x k M ,   where   Hess   f ( x k ) η k :=   ∇ η k grad   f .   Set  

- 3: Set

$$
x _ { k + 1 } \colon = R _ { x _ { k } } ( \eta _ { k } ) .
$$

- 4:   end for


In   general,   the   Newton   vector   η k ,   solution   of   (6.2),   is   not   necessarily   a   descent   direction   of   f .   Indeed,   we   have  

$$
D f \left ( x _ { k } \right ) \left [ \eta _ { k } \right ] & = \left \langle \text {grad} \, f ( x _ { k } ) , \eta _ { k } \right \rangle = - \left \langle \text {grad} \, f ( x _ { k } ) , \left ( \text {Hess} \, f ( x _ { k } ) \right ) ^ { - 1 } \text {grad} \, f ( x _ { k } ) \right \rangle , \\ \\ \intertext { D f \left ( x _ { k } \right ) \left [ \eta _ { k } \right ] } & = \left \langle \text {grad} \, f ( x _ { k } ) , \eta _ { k } \right \rangle = - \left \langle \text {grad} \, f ( x _ { k } ) , \left ( \text {Hess} \, f ( x _ { k } ) \right ) ^ { - 1 } \text {grad} \, f ( x _ { k } ) \right \rangle , \\
$$

which   is   not   guaranteed   to   be   negative   without   additional   assumptions   on   the   operator   Hess   f ( x k ).   A   suﬃcient   condition   for   η k to   be   a   descent   direction   is   that   Hess   f ( x k )   be   positive-deﬁnite (i.e.,     ξ,   Hess   f ( x k )[ ξ ]     >   0   for   all   ξ   =   0 x k ).   When   ∇   is   a   symmetric   aﬃne   connection   (such   as   the   Riemannian   connection),   Hess   f ( x k )   is   positive-deﬁnite   if   and   only   if   all   its   eigenvalues   are   strictly   positive.  

/negationslash

[Page 127]

In   order   to   obtain   practical   convergence   results,   quasi-Newton   methods   have   been   proposed   that   select   an   update   vector   η k as   the   solution   of  

$$
( H e s s \, f ( x _ { k } ) + E _ { k } ) \eta _ { k } & = - \text {grad} \, f ( x _ { k } ) , \\ \\ ( H e s s \, f ( x _ { k } ) + E _ { k } ) \eta _ { k } & = - \text {grad} \, f ( x _ { k } ) ,
$$

where   the   operator   E k is   chosen   so   as   to   make   the   operator   (Hess   f ( x k ) +   E k )   positive-deﬁnite.   For   a   suitable   choice   of   operator   E k this   guarantees   that   the   sequence   { η k }   is   gradient-related,   thereby   fulﬁlling   the   main   hypothesis   in   the   global   convergence   result   of   Algorithm   1   (Theorem   4.3.1).   Care   should   be   taken   that   the   operator   E k does   not   destroy   the   superlinear   convergence   properties   of   the   pure   Newton   iteration   when   the   desired   (local   minimum)   critical   point   is   reached.  

# 6.3 LOCAL CONVERGENCE

In   this   section,   we   study   the   local   convergence   of   the   plain   geometric   Newton   method   as   deﬁned   in   Algorithm   4.   Well-conceived   globally   convergent   modiﬁcations   of   Algorithm   4   should   not   aﬀect   its   superlinear   local   convergence.  

The   convergence   result   below   (Theorem   6.3.2)   shows   quadratic   convergence   of   Algorithm   4.   Recall   from   Section   4.3   that   the   notion   of   quadratic   convergence   on   a   manifold   M   does   not   require   any   further   structure   on   M ,   such   as   a   Riemannian   structure.   Accordingly,   we   make   no   such   assumption.   Note   also   that   since   Algorithm   5   is   a   particular   case   of   Algorithm   4,   the   convergence   analysis   of   Algorithm   4   applies   to   Algorithm   5   as   well.  

We   ﬁrst   need   the   following   lemma.  

Lemma 6.3.1 Let  ·    be any consistent norm on R n × n such that   I     = 1 . If   E     <   1 , then ( I   −   E ) − 1 exists and 1  

$$
\| ( I - E ) ^ { - 1 } \| & \leq \frac { 1 } { 1 - \| E \| } . \\ \intertext { \| ( I - E ) ^ { - 1 } \| } \intertext { d \| A ^ { - 1 } ( B _ { \ } A ) \| } & < 1 + \hbar { c } n \, B _ { \ } R _ { i _ { 0 } }
$$

If A   is nonsingular and   A − 1 ( B   −   A )     <   1 , then B   is nonsingular and − 1

$$
\| B ^ { - 1 } \| & \leq \frac { \| A ^ { - 1 } \| } { 1 - \| A ^ { - 1 } ( B - A ) \| } . \\
$$

Theorem 6.3.2 (local convergence of Newton’s method) Under the requirements and notation of Algorithm 4, assume that there exists x ∗   ∈ M   such that ξ x ∗ = 0   and J ( x ∗ ) − 1 exists. Then there exists a neighborhood U   of x ∗   in M   such that, for all x 0 ∈ U , Algorithm 4 generates an inﬁnite sequence { x k }   converging superlinearly (at least quadratically) to x ∗ .

Proof. Let   ( U , ϕ ),   x ∗   ∈ U ,   be   a   coordinate   chart.   According   to   Section   4.3,   it   is   suﬃcient   to   show   that   the   sequence   { ϕ ( x k ) }   in   R d converges   quadratically   to   ϕ ( x ∗ ).   To   simplify   the   notation,   coordinate   expressions   are   denoted   by   hat   quantities.   In   particular,   ˆ x k =   ϕ ( x k ),   ξ ˆ x ˆ k = D ϕ   ( x k ) [ ξ ],   J ˆ (ˆ x k )   =   (D ϕ ( x k ))   ˆ ˆ ˆ J ( x k )   (D ϕ ( x k )) − 1 ,   R x ˆ ζ   =   ϕ ( R x ζ ).   Note   that   J (ˆ x k )   is   a   linear   operator   ◦   ◦  

[Page 128]

from   R d to   R d ,   i.e.,   a   d   ×   d   matrix.   Note   also   that   R ˆ x ˆ is   a   function   from   R d to   R d whose   diﬀerential   at   zero   is   the   identity.  

The   iteration   deﬁned   by   Algorithm   4   reads  

$$
\hat { x } _ { k + 1 } & = \hat { R } _ { \hat { x } _ { k } } ( - \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \hat { \xi } _ { \hat { x } _ { k } } ) , \\ \vdots \, _ { 1 } \, _ { N } \, _ { k + 1 } & = \hat { R } _ { \hat { x } _ { k } } ( - \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \hat { \xi } _ { \hat { x } _ { k } } ) ,
$$

whereas   the   classical   Newton   method   applied   to   the   function   ξ ˆ :   R d  →   R d would   yield  

$$
\hat { x } _ { k + 1 } = \hat { x } _ { k } + ( - D \hat { \xi } ( \hat { x } _ { k } ) ^ { - 1 } \hat { \xi } _ { \hat { x } _ { k } } ) . \\ \intertext { i s t h i n g w h s f i n t h s a r r e s }
$$

The   strategy   in   this   proof   is   to   show   that   (6.7)   is   suﬃciently   close   to   (6.8)   that   the   superlinear   convergence   result   of   the   classical   Newton   method   is   preserved.   We   are   going   to   prove   more   than   is   strictly   needed,   in   order   to   obtain   information   about   the   multiplicative   constant   in   the   quadratic   convergence   result.   ˆ − 1 ˆ

Let   β   :=     J (ˆ x ∗ )   .   Since   ξ   is   a   (smooth)   vector   ﬁeld,   it   follows   that   J is   smooth,   too,   and   therefore   there   exists   r J >   0   and   γ J >   0   such   that  

$$
\text {both, too, and therefore there exists } r _ { J } & > 0 \text { and } \gamma _ { J } > 0 \text { such } \\ & \| \hat { J } ( \hat { x } ) - \hat { J } ( \hat { y } ) \| \leq \gamma _ { J } \| \hat { x } - \hat { y } \| \\ \text {all } \hat { x } , \hat { y } \in B _ { r _ { J } } ( \hat { x } _ { * } ) \colon = \{ \hat { x } \in \mathbb { R } ^ { d } \colon \| \hat { x } - \hat { x } _ { * } \| < r _ { J } \} . \text { Let } \\ & \epsilon = \min \left \{ r _ { J } , \frac { 1 } { 2 \beta \gamma _ { J } } \right \} .
$$

for   all   ˆ x,   y ˆ ∈   B r J (ˆ x ∗ )   :=   { x ˆ ∈   R d :     x ˆ −   x ˆ ∗     < r J } .      

Assume   that   ˆ x k ∈   B ǫ (ˆ x ∗ ).   It   follows   that   − 1 − 1

$$
\| \hat { J } ( \hat { x } _ { * } ) ^ { - 1 } ( \hat { J } ( \hat { x } _ { k } ) - \hat { J } ( \hat { x } _ { * } ) ) \| & \leq \| \hat { J } ( \hat { x } _ { * } ) \| ^ { - 1 } \| \hat { J } ( \hat { x } _ { k } ) - \hat { J } ( \hat { x } _ { * } ) \| \\ & \leq \beta \gamma _ { J } \| \hat { x } _ { k } - \hat { x } _ { * } \| \leq \beta \gamma _ { J ^ { \prime } } \leq \frac { 1 } { 2 } .
$$

It   follows   from   Lemma   6.3.1   that   J ˆ (ˆ x k )   is   nonsingular   and   that  

$$
\| \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \| & \leq \frac { \| \hat { J } ( \hat { x } _ { * } ) ^ { - 1 } \| } { 1 - \| \hat { J } ( \hat { x } _ { * } ) ^ { - 1 } ( \hat { J } ( \hat { x } _ { k } ) - \hat { J } ( \hat { x } _ { * } ) ) \| } \leq 2 \| \hat { J } ( \hat { x } _ { * } ) ^ { - 1 } \| \leq 2 \beta . \\ \intertext { l t a l s o f l o w s t h a t f o r a l l \hat { x } _ { r } \in B \left ( \hat { x } \right ) }
$$

It   also   follows   that   for   all   ˆ x k ∈   B ǫ (ˆ x ∗ ),   the   Newton   vector   ˆ η k :=   J ˆ (ˆ x k ) − 1 ξ ˆ ˆ x k is   well   deﬁned.   Since   R   is   a   retraction   (thus   a   smooth   mapping)   and   ˆ x ∗   is   a   zero   of   ξ ˆ ,   it   follows   that   there   exists   r R and   γ R >   0   such   that  

$$
\| \hat { R } _ { \hat { x } _ { k } } \hat { \eta } _ { k } - ( \hat { x } _ { k } + \hat { \eta } _ { k } ) \| & \leq \gamma _ { R } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ D _ { \ } ( \hat { \ } _ { x } ) _ { k } ( \hat { \ } _ { x } ) _ { k } & = 1 - \| \hat { x } ( \hat { \ } _ { x } ) - 1 \| \cdot \hat { x } _ { k }
$$

for   all   ˆ x k ∈   B ǫ (ˆ x ∗ ).   (Indeed,   since     J ˆ (ˆ x k ) − 1     is   bounded   on   B ǫ (ˆ x ∗ ),   and   ξ ˆ is   smooth   and   ξ ˆ ˆ =   0,   we   have   a   bound     η ˆ k   ≤   c   x ˆ k −   x ˆ ∗     for   all   x k in   a   neighborhood   of   x ∗ ;   and   in   view   of   the   local   rigidity   property   of   R ,   we   have     R ˆ x ˆ k η ˆ k −   (ˆ x k + ˆ η k )   ≤   c   η ˆ k   2 for   all   x k in   a   neighborhood   of   x ∗   and   all   η k suﬃciently   small.)   x ∗

Deﬁne   Γ ˆ ˆ by   Γ ˆ ˆ ζ ˆ :=   J ˆ (ˆ x ) ζ ˆ −   D ξ ˆ (ˆ x )     ζ ˆ   ;   see   (5.7).   Note   that   Γ ˆ ˆ is   a   x, ˆ x, ˆ ξ x,ξ ˆ ξ linear   operator.   Again   by   a   smoothness   argument,   it   follows   that   there   exists   r Γ and   γ Γ such   that  

$$
\| \hat { \Gamma } _ { \hat { x } , \hat { \xi } } - \hat { \Gamma } _ { \hat { y } , \hat { \xi } } \| \leq \gamma _ { \Gamma } \| \hat { x } - \hat { y } \|
$$

[Page 129]

for   all   ˆ x,   y ˆ ∈   B r Γ (ˆ x ∗ ).   In   particular,   since   ξ ˆ x ˆ ∗ =   0,   it   follows   from   the   uniqueness   of   the   connection   at   critical   points   that   Γ ˆ x ˆ ∗ ,ξ ˆ =   0,   hence  

$$
\| \hat { \Gamma } _ { \hat { x } , \hat { \xi } } \| \leq \gamma _ { \Gamma } \| \hat { x } _ { k } - \hat { x } _ { * } \|
$$

for all ˆ x k ∈ B /epsilon1 (ˆ x ∗ ).

  constant   for   D ξ ˆ . For all   ˆ x,   y ˆ ∈   B min { r J ,r Γ } (ˆ x ∗ ),   we   have  

$$
\text {have} & & \| \hat { D } \hat { \xi } ( \hat { x } ) - D \hat { \xi } ( \hat { y } ) \| - \| \hat { \Gamma } _ { \hat { x } , \hat { \xi } } - \hat { \Gamma } _ { \hat { y } , \hat { \xi } } \| \\ & \leq \| \hat { D } \hat { \xi } ( \hat { x } ) + \hat { \Gamma } _ { \hat { x } , \hat { \xi } } - \left ( D \hat { \xi } ( \hat { y } ) + \hat { \Gamma } _ { \hat { y } , \hat { \xi } } \right ) \| = \| \hat { J } ( \hat { x } ) - \hat { J } ( \hat { y } ) \| \leq \gamma _ { J } \| \hat { x } - \hat { y } \| , \\ \text {hence} & & \| \hat { D } \hat { \xi } ( \hat { \hat { \tau } } ) - \hat { D } \hat { \xi } ( \hat { \hat { y } } ) \| < ( \gamma _ { x } - | \sigma _ { x } | ) \| \hat { \hat { x } } \, \hat { \hat { y } } \| \\
$$

hence  

$$
\| D \hat { \xi } ( \hat { x } ) - D \hat { \xi } ( \hat { y } ) \| \leq ( \gamma _ { J } + \gamma _ { \Gamma } ) \| \hat { x } - \hat { y } \| .
$$

From   (6.7)   we   have  

$$
\hat { x } _ { k + 1 } - \hat { x } _ { * } = \hat { R } _ { \hat { x } _ { k } } ( - \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \hat { \xi } _ { \hat { x } _ { k } } ) - \hat { x } _ { * } . \\ \text {bounds developed above, one obtains}
$$

k k Applying   the   bounds   developed   above,   one   obtains  

$$
x _ { k + 1 } - x _ { * } ^ { * } & = R _ { \hat { x } _ { k } } ( - J ( x _ { k } ) ^ { \xi } \hat { x } _ { k } ) - x _ { * } ^ { * } . \\ \text {Applying the bounds developed above, one obtains
       \| \hat { x } _ { k + 1 } - \hat { x } _ { * } \| \leq & \| \hat { x } _ { k } - \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \hat { x } _ { k } - \hat { x } _ { * } \| + \gamma _ { R } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ & \leq \| \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \left ( \hat { \xi } _ { * } - \hat { \xi } _ { k } - \hat { J } ( \hat { x } _ { k } ) ( \hat { x } _ { * } - \hat { x } _ { k } ) \right ) \| + \gamma _ { R } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ & \leq \| \hat { J } ( \hat { x } _ { k } ) ^ { - 1 } \| \| \hat { \xi } _ { * } - \hat { \xi } _ { k } - D \hat { \xi } ( \hat { x } _ { k } ) \left [ \hat { x } _ { * } - \hat { x } _ { k } \right ] \| \\ & + \| J ( \hat { x } _ { k } ) ^ { - 1 } \| \| \Gamma _ { \hat { x } _ { k } , \hat { \xi } } ( \hat { x } _ { * } - \hat { x } _ { k } ) \| + \gamma _ { R } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ & \leq 2 \beta \frac { 1 } { 2 } ( \gamma _ { J } + \gamma _ { \Gamma } ) \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ & + 2 \beta \gamma _ { \Gamma } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } + \gamma _ { R } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ \text {whenever } \| \hat { x } _ { k } - \hat { x } _ { * } \| \leq \min \{ \epsilon , r _ { \Gamma } , r _ { R } \} , \text {where we have used Proposition A.6.1.} \\ \text {This completes the proof.} \quad \square
$$

  −     −   whenever     x ˆ k − x ˆ ∗   ≤   min { ǫ, r Γ , r R } ,   where   we   have   used   Proposition   A.6.1.   This   completes   the   proof.      

It   is   interesting   to   note   that   in   the   classical   Euclidean   case,   the   proof   holds   with   γ R =   0   (because   R x ζ   :=   x   +   ζ )   and   γ Γ =   0   (because   J ( x ) ζ   ≡ ∇ ζ ξ   :=   D ξ   ( x ) [ ζ ]).  

In   the   case   where   M   is   a   Riemannian   metric   and   the   Riemannian   connection   is   used   along   with   a   second-order   retraction   (e.g.,   the   exponential   retraction),   it   is   also   possible   to   obtain   a   better   bound.   Consider   normal   coordinates   around   the   point   x ∗ .   The   Christoﬀel   symbols   Γ i vanish   at   ˆ x ∗ , jk and   the   constant   γ Γ can   be   replaced   by   O (   x ˆ k −   x ˆ ∗   ).   Since   we   are   working   in   normal   coordinates   around   x ∗ ,   it   follows   that   the   Christoﬀel   symbols   at   x ∗   vanish,   hence   the   acceleration   condition   d D t 2 2 R x ∗ ( tζ x ∗ ) = 0   t =0 yields   d d t 2 2 R ˆ x ˆ ∗ ( tζ ˆ x ˆ ∗ )   t =0 =   0   and,   by   the   smoothness   of   R ,   we   have   D 2 R ˆ x ˆ k =   O (   x ˆ k −   x ˆ ∗   ).   It   follows   that   γ R may   be   replaced   by   O (   x ˆ k −   x ˆ ∗   ).   Thus,   the   convergence   bound   becomes  

$$
\text {the concrete bound becomes} \\ \| \hat { x } _ { k + 1 } - \hat { x } _ { * } \| & \leq 2 \beta \frac { 1 } { 2 } ( \gamma _ { J } + \gamma _ { \Gamma } ) \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } + 2 \beta \gamma _ { \Gamma } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } + \gamma _ { R } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } \\ & \leq \beta \gamma _ { J } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } + O ( \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 3 } ) . \\ \intertext { \text {In the summary, and in this part, the $x_{k}$-th $hat{x}+dint(x_{k})$} }
$$

$$
\leq & \beta \gamma _ { J } \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 2 } + O ( \| \hat { x } _ { k } - \hat { x } _ { * } \| ^ { 3 } ) . \\ \text {local coordinates at } x \text { one has that dist} ( x _ { r } , x )
$$

≤   −     −   In   normal   coordinates   at   x ∗   one   has   that   dist( x k , x ∗ ) =     x ˆ k −   x ˆ ∗   .  

[Page 130]

# 6.3.1 Calculus approach to local convergence analysis

Theorem   6.3.2   provides   a   strong   convergence   analysis   of   the   geometric   Newton   method   along   with   explicit   convergence   bounds.   A   weaker   quadratic   convergence   result   can   be   obtained   from   a   local   coordinate   analysis   of   the   Newton   iteration   using   the   calculus-based   convergence   result   of   Theorem   4.5.3.  

Let   x ∗   be   a   critical   point   of   a   vector   ﬁeld   ξ   with   a   nondegenerate   Jacobian   ∗   at   x ∗ .   Choose   a   coordinate   chart   around   x   and   use   the   hat   notation   to   represent   the   coordinate   expression   of   geometric   objects.   Without   loss   of   generality   we   choose   ˆ x ∗   =   0.   The   iteration   deﬁned   in   Algorithm   4   reads  

$$
\hat { x } _ { k + 1 } = \hat { R } _ { \hat { x } _ { k } } ( \hat { \eta } _ { k } ) ,
$$

$$
\hat { \nabla } _ { \hat { \eta } _ { k } } \hat { \xi } = - \hat { \xi } _ { \hat { x } _ { k } } . \\ \xi \text { and the rotation } R \text { are smooth } b \text { as sum} \eta \text { is}
$$

Since   the   vector   ﬁeld   ξ   and   the   retraction   R   are   smooth   by   assumption,   this   deﬁnes   a   smooth   iteration   mapping   ˆ x k +1 (ˆ x k ).   Evaluating   the   Newton   x k  →   ˆ equation   (6.10)   at   ˆ x k =   x ˆ ∗   =   0   yields  

$$
\hat { \nabla } _ { \hat { \eta } _ { 0 } } \hat { \xi } = 0 \\ \L c o b { i } { \eta } _ { 0 } \ L ( x
$$

and   thus   η ˆ 0 =   0   because   the   Jacobian   J ( x ∗ ) :   ζ   ∈   T x ∗ M    →   ∇ ζ ξ   ∈   T x ∗ M is   assumed   to   be   nondegenerate.   Since   R   satisﬁes   the   consistency   property   R x (0 x ) =   x   for   all   x ,   it   follows   that   x ˆ ∗   =   0   is   a   ﬁxed   point   of   the   iteration   mapping.   Recalling   Theorem   4.5.3,   it   is   suﬃcient   to   show   that   Dˆ x k +1 ( x ∗ )   =   0   to   prove   local   quadratic   convergence.   For   clarity,   we   use   the   notation   R ˆ (ˆ x,   η ˆ)   for   R ˆ x ˆ (ˆ η ),   and   we   let   D 1 R ˆ and   D 2 R ˆ denote   the   diﬀerentials   with   respect   to   the   ﬁrst   and   second   arguments   of   the   function   R ˆ .   (Note   that   R ˆ is   a   function   from   R d ×   R d into   R d ,   where   d   is   the   dimension   of   the   manifold   M .)   Diﬀerentiating   the   iteration   mapping   ˆ x k  →   x ˆ k +1 (ˆ x k )   at   0   along   ζ ˆ ,   one   obtains  

$$
D \hat { x } _ { k + 1 } ( 0 ) [ \hat { \zeta } ] = D _ { 1 } \hat { R } ( 0 , 0 ) [ \hat { \zeta } ] + D _ { 2 } \hat { R } ( 0 , 0 ) [ D \hat { \eta } ( 0 ) [ \hat { \zeta } ] ] , \quad ( 6 . 1 1 )
$$

where   ˆ η (ˆ x )   is   the   function   implicitly   deﬁned   by   the   Newton   equation   x    →   ˆ ˆ ξ ˆ =   ξ ˆ .   (6.12)

$$
\hat { \nabla } _ { \hat { \eta } ( \hat { x } ) } \hat { \xi } & = - \hat { \xi } _ { \hat { x } } . & & ( 6 . 1 2 ) \\ \hat { \hat { \zeta } } _ { 1 } & = \hat { \zeta } _ { 1 } + \hat { \zeta } _ { 2 } . & & \vdots + \quad \vdots \cdot \hat { \zeta } _ { 2 } \cdot \hat { \eta } ( 0 )
$$

We   have   D 1 R ˆ (0 ,   0)[ ζ ˆ ]   =   ζ ˆ because   of   the   consistency   condition   R (0 x ) =   x .   Moreover,   the   local   rigidity   condition   D R x (0 x )   =   id T x M   (see   Deﬁnition   4.1.1)   ensures   that   D 2 R ˆ (0 ,   0)[Dˆ η (0)[ ζ ˆ ]]   =   Dˆ η (0)[ ζ ˆ ].   Hence   (6.11)   yields  

$$
D \hat { x } _ { k + 1 } ( 0 ) [ \hat { \zeta } ] = \hat { \zeta } + D \hat { \eta } ( 0 ) [ \hat { \zeta } ] .
$$

Using   the   local   expression   (5.7)   for   the   aﬃne   connection,   the   Newton   equation   (6.12)   reads  

$$
D \hat { \xi } ( \hat { x } ) [ \hat { \eta } ( \hat { x } ) ] + \hat { \Gamma } _ { \hat { x } , \hat { \xi } _ { \hat { x } } } \hat { \eta } ( \hat { x } ) & = - \hat { \xi } _ { \hat { x } } . \\ \\
$$

(Recall   that   Γ ˆ x, ˆ ξ ˆ ˆ is   a   matrix   and   Γ ˆ ˆ ξ ˆ x ˆ η ˆ(ˆ x )   is   a   matrix-vector   product.)   x x, Diﬀerentiating   this   equation   with   respect   to   ˆ x   along   ζ ˆ ,   one   obtains  

$$
D ^ { 2 } \hat { \xi } ( \hat { x } ) [ \hat { \eta } ( \hat { x } ) , \hat { \zeta } ] + D \hat { \xi } ( \hat { x } ) [ D \hat { \eta } ( \hat { x } ) [ \hat { \zeta } ] ] + D \hat { \Gamma } _ { \cdot , \xi } ( \hat { x } ) [ \hat { \zeta } ] \hat { \eta } ( \hat { x } ) + \hat { \Gamma } _ { \hat { x } , \hat { \xi } _ { \hat { t } } } D \hat { \eta } ( \hat { x } ) [ \hat { \zeta } ] \\ = - D \hat { \xi } ( \hat { x } ) [ \hat { \zeta } ] .
$$

[Page 131]

Most   of   the   terms   in   this   equation   vanish   when   evaluated   at   ˆ x   =   0   since   ξ ˆ 0 = 0 and   ˆ η 0 =   0.   (In   particular,   observe   that   Γ ˆ 0 , 0 =   0   in   view   of   (5.8).)   This   leaves   us   with  

$$
D \hat { \xi } ( 0 ) [ D \hat { \eta } ( 0 ) [ \hat { \zeta } ] ] & = - D \hat { \xi } ( 0 ) [ \hat { \zeta } ] . \\ \\ D \hat { \xi } ( 0 ) [ D \hat { \eta } ( 0 ) [ \hat { \zeta } ] ] & = - D \hat { \xi } ( 0 ) [ \hat { \zeta } ] .
$$

Since   J ( x ∗ )   is   nonsingular   and   Γ ˆ x ˆ ∗ ,ξ ˆ x ˆ ∗ =   0,   it   follows   in   view   of   (5.7)   that   the   linear   operator   D ξ ˆ (0)   =   J ˆ (ˆ x ∗ )   is   nonsingular.   Hence   (6.14)   reduces   to  

$$
D \hat { \eta } ( 0 ) [ \hat { \zeta } ] & = - \hat { \zeta } . \\ \\ \intertext { d \hat { \eta } ( 0 ) [ \hat { \zeta } ] } \intertext { d \hat { \eta } } \intertext { \intertext { d \hat { \zeta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \zeta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext { d \hat { \eta } } } \intertext { \intertext {
$$

Using   this   result   in   (6.13)   yields   Dx ˆ k +1 ( x ∗ )   =   0.   From   Theorem   4.5.3,   it   follows   that   the   iteration   ˆ x k +1 (ˆ x k )   converges   locally   quadratically   to   x k  →   ˆ x ˆ ∗ .   Since   quadratic   convergence   is   independent   of   coordinate   representation,   this   property   holds   for   the   Newton   iteration   on   the   manifold.  

# 6.4 RAYLEIGH QUOTIENT ALGORITHMS

In   this   section   we   show   how   the   geometric   Newton   algorithms   can   be   turned   into   practical   numerical   algorithms   for   the   optimization   of   various   cost   functions   of   the   Rayleigh   quotient   type.  

# 6.4.1 Rayleigh quotient on the sphere

Recall   the   example   of   the   Rayleigh   quotient   on   the   sphere   ﬁrst   considered   in   Section   4.6.   The   main   points   were   summarized   in   Table   4.1.   The   cost   function   is   the   Rayleigh   quotient  

$$
f \colon S ^ { n - 1 } & \to \mathbb { R } \colon x \mapsto x ^ { T } A x , \\ \intertext { f \colon S ^ { n - 1 } } \intertext { a n } \intertext { 1 } \intertext { a n }
$$

on   the   unit   sphere   S n − 1 ,   viewed   as   a   Riemannian   submanifold   of   the   Euclidean   space   R n .   We   also   use   the   extension  

$$
\bar { f } \colon \mathbb { R } ^ { n } & \to \mathbb { R } \colon x \mapsto x ^ { T } A x , \\ \intertext { s c h } x _ { 1 } + x _ { 2 } & = x _ { 1 } - x _ { 2 } + x _ { 3 } - 1 ,
$$

whose   restriction   to   S n − 1 is   f .   In   Section   4.6,   we   obtained  

$$
\text {grad} \, f ( x ) = 2 \, P _ { x } ( A x ) = 2 \, ( A x - x x ^ { T } A x ) , \\
$$

where   P x is   the   orthogonal   projector   onto   T x S n − 1 ,   i.e.,  

$$
P _ { x } z & = z - x x ^ { T } z . \\ \\
$$

(Note   that   P x can   also   be   viewed   as   the   matrix   ( I   − xx T ).)   We   also   expressed   a   preference   for   the   retraction  

$$
R _ { x } ( \xi ) \coloneqq \frac { x + \xi } { \| x + \xi \| } . \\ \intertext { w t o n m o t h o d \ ( A l o r i t h m \ 4 ) \ r o u i r o s \ o n f i n o p n o g }
$$

The geometric Newton method (Algorithm 4) requires an affine connection ∇ . There is no reason not to pick the natural choice, the Riemannian connection. Since S n -1 is a Riemannian submanifold of the Euclidean space R n , it follows from the material in Section 5.3.3 that

[Page 132]

$$
\nabla _ { \eta } \xi & = P _ { x } \left ( D \xi \left ( x \right ) \left [ \eta \right ] \right ) \\ \\ \tau _ { \eta } & = T _ { x } \, c n = 1 \quad ( c _ { x } = \mathbb { T } \tau )
$$

for   every   η   in   the   tangent   space   T x S n − 1 =   { z   ∈   R n :   x T z   = 0 }   and   every   vector   ﬁeld   ξ   on   S n − 1 .  

We   are   ready   to   apply   the   geometric   Newton   method   (Algorithm   4)   to   the   vector   ﬁeld   ξ   :=   grad   f ,   where   f   is   the   Rayleigh   quotient   (6.15).   For   every   η   ∈   T x k S n − 1 ,   we   have            

$$
\nabla _ { \eta } g r a d \, f ( x ) & = 2 P _ { x } \left ( D \, g r a d \, f ( x ) [ \eta ] \right ) \\ & = 2 P _ { x } ( A \eta - \eta x ^ { T } A x ) \\ & = 2 ( P _ { x } A P _ { x } \eta - \eta x ^ { T } A x ) , \\ \intertext { o k i n t o c a n c o u n t h a t P _ { x } x = 0 a n d P _ { x } \eta = \eta . T h e l a s }
$$

where   we   took   into   account   that   P x x   = 0   and   P x η   =   η .   The   last   expression   underscores   the   symmetry   of   the   Hessian   operator   (in   the   sense   of   Proposition   5.5.3).   Consequently,   the   Newton   equation   (6.1)   reads  

$$
\text {Consequently, the Newton equation (6.1) reads} \\ \begin{cases} P _ { x } A P _ { x } \eta - \eta x ^ { T } A x = - P _ { x } A x , \\ x ^ { T } \eta = 0 , \end{cases}
$$

where the second equation is the expression of the requirement η ∈ T x S n -1 .

where   f   is   the   Rayleigh   quotient   (6.15)   on   the   sphere   S n − 1 ,   viewed   as   a   Riemannian   submanifold   of   R n endowed   with   its   Riemannian   connection   and   with   the   retraction   (6.16),   yields   the   matrix   algorithm   displayed   in   Algorithm   6.   Since   Algorithm   6   is   a   particular   case   of   the   forthcoming   Algorithms   7   and   8,   we   postpone   its   analysis   to   Section   6.5.1.  

Algorithm 6 Riemannian   Newton   method   for   the   Rayleigh   quotient   on   S n − 1

Require: Symmetric   matrix   A .  

Initial iterate x 0 ∈ M .

Input:

Sequence of iterates { x k }

Output:

.

- 1: for k = 0 , 1 , 2 , . . . do
- 2:   Solve   the   linear   system   (6.17),   i.e.,  


$$
\begin{cases} P _ { x _ { k } } A P _ { x _ { k } } \eta _ { k } - \eta _ { k } x _ { k } ^ { T } A x _ { k } = - P _ { x _ { k } } A x _ { k } , \\ x _ { k } ^ { T } \eta _ { k } = 0 , \end{cases}
$$

for   the   unknown   η k ∈   R n .   Set  

3: Set

with   R   deﬁned   in   (6.16).  

4:   end for

$$
x _ { k + 1 } \colon = R _ { x _ { k } } \eta _ { k } ,
$$

[Page 133]

# 6.4.2 Rayleigh quotient on the Grassmann manifold

Consider   the   cost   function  

$$
& \text {Consider the cost function} \\ & \quad f \colon \text {Grass} ( p , n ) \to \mathbb { R } \colon \text {span} ( Y ) \mapsto t \left ( ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) . \\ & \text {The first-order geometry of this cost function was investigated in Section 4.9} \\ & ( \text {see Table 4.3} ) \ \text {The Grassmann manifold} \text {grass} ( p , n ) \text { was viewed as a Lie} .
$$

The   ﬁrst-order   geometry   of   this   cost   function   was   investigated   in   Section   4.9   (see   Table   4.3).   The   Grassmann   manifold   Grass( p, n )   was   viewed   as   a   Riemannian   quotient   manifold   of   ( R n ∗ × p , g )   with    

$$
\text {notent manifold of } ( \mathbb { R } _ { * } \ ^ { * } , g ) \text { with} \\ \bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) = \text {tr} \left ( ( Y ^ { T } Y ) ^ { - 1 } Z _ { 1 } ^ { T } Z _ { 2 } \right ) . \\ \text {total distribution is}
$$

The   horizontal   distribution   is  

$$
\mathcal { H } _ { Y } = \{ Z \in \mathbb { R } ^ { n \times p } \colon Y ^ { T } Z = 0 \} , \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\
$$

the   projection   onto   the   horizontal   space   is  

$$
P _ { Y } ^ { h } = ( I - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } ) , \\
$$

and   we   obtained  

$$
\overline { \ g r a d f _ { Y } } = 2 P _ { Y } ^ { h } A Y & = 2 \left ( A Y - Y ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) . \\ \text {follows from this expression that if grad f ( \text {span} ( Y ) ) = 0 , then span} \\ \text {invariant subspace of } A \, \text { Conversely if } \text {span} ( Y ) \text { is an invariant span}
$$

It   follows   from   this   expression   that   if   grad   f (span( Y   ))   =   0,   then   span( Y   )   is   an   invariant   subspace   of   A .   Conversely,   if   span( Y   )   is   an   invariant   subspace   of   A ,   then   there   exists   an   M   such   that   AY   =   Y M ;   premultiplying   this   equation   by   ( Y   T Y   ) − 1 Y   T yields   M   = ( Y   T Y   ) − 1 Y   T AY   ,   and   we   obtain   grad   f (span( Y   ))   =   0.   In   conclusion,   the   critical   points   of   f   are   the   invariant   subspaces   of   A .  

In   Section   5.3.4,   we   established   the   formula  

$$
4 , \, \text {we established the formula} \\ \overline { \nabla _ { \eta } \xi } = P _ { Y } ^ { h } \left ( D \bar { \xi } \left ( Y \right ) \left [ \bar { \eta } _ { Y } \right ] \right ) \\ \text {ian connection on the Grassmann manifold. This yields the} \\ \text {ion for the Hessian of the Rayleigh quotient cost function}
$$

for   the   Riemannian   connection   on   the   Grassmann   manifold.   This   yields   the   following   expression   for   the   Hessian   of   the   Rayleigh   quotient   cost   function   f :      

$$
f & \colon \\ & \overline { \nabla _ { \eta } r a d \, f } = P _ { Y } ^ { h } \left ( D \overline { \text {grad} } \, f \left ( Y \right ) \left [ \bar { \eta } _ { Y } \right ] \right ) = 2 \, P _ { Y } ^ { h } \left ( A \bar { \eta } _ { Y } - \bar { \eta } _ { Y } ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) , \\ & \text {where we have utilized the identity } P _ { Y } ^ { h } ( Y M ) = ( P _ { Y } ^ { h } Y ) M = 0 . \text { Taking the } \\ & \text {horizontal lift of the Newton equation } \nabla _ { \ } \text {grad} \, f = - \text {grad} \, f ( r ) \text { yields the }
$$

where   we   have   utilized   the   identity   P h Y ( Y M )   =   (P h Y Y   ) M   =   0.   Taking   the   horizontal   lift   of   the   Newton   equation   ∇ η grad   f   =   − grad   f ( x )   yields   the   equation    

$$
P _ { Y } ^ { h } \left ( A \bar { \eta } _ { Y } - \bar { \eta } _ { Y } ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) & = - P _ { Y } ^ { h } A Y , \quad \bar { \eta } _ { Y } \in \mathcal { H } _ { Y } , \\ \text {whose solution } \bar { \eta } _ { Y } \text { in the horizontal space } \mathcal { H } _ { Y } \text { is the horizontal lift of the} \\ \text {solution } \eta \text { of the Newton equation}
$$

whose   solution   η Y in   the   horizontal   space   H Y is   the   horizontal   lift   of   the   solution   η   of   the   Newton   equation.  

In   conclusion,   the   geometric   Newton   method   in   Algorithm   4,   for   the   Rayleigh   quotient   cost   function   (6.19),   with   the   aﬃne   connection   ∇   chosen   as   the   Riemannian   connection   on   Grass( p, n )   seen   as   the   Riemannian   quotient   manifold   of   ( R n ∗ × p , g )   with   g   in   (6.20),   and   with   the   retraction   R   chosen   as   (4.40)   yields   the   matrix   algorithm   displayed   in   Algorithm   7.   The   notation   Z k =   η Y k is   used   to   make   the   matrix   expression   resemble   contemporary   algorithms   from   the   ﬁeld   of   numerical   linear   algebra.   The   expression  

[Page 134]

Require: Symmetric   matrix   A . 
 n × p

Input: Initial iterate Y 0 ∈ R n ∗ × p .

n × p

Sequence of iterates { Y k } in R ∗ .

Output:

- 1: for k = 0 , 1 , 2 , . . . do
- 2:   Solve   the   linear   system  


$$
\begin{array} { c c c } & & \text {Solve the linear system} \\ & & \begin{cases} P _ { Y _ { k } } ^ { h } \left ( A Z _ { k } - Z _ { k } ( Y _ { k } ^ { T } Y _ { k } ) ^ { - 1 } Y _ { k } ^ { T } A Y _ { k } \right ) = - P _ { Y _ { k } } ^ { h } ( A Y _ { k } ) & \\ & & \text {Y} _ { k } ^ { T } Z _ { k } = 0 & \end{cases} \\ \end{array}
$$

for   the   unknown   Z k ,   where   P h Y is   the   orthogonal   projector   deﬁned   in   (6.22).   (The   condition   Y k T Z k expresses   that   Z k belongs   to   the   horizontal   space   H Y k .)   Set  

3: Set where Y is a full-rank n × p matrix and span( Y ) denotes the column space of Y . It is readily checked that the right-hand side depends only on span( Y ), so that f is a well-defined real-valued function on the Grassmann manifold Grass( p, n ).

$$
Y _ { k + 1 } = ( Y _ { k } + Z _ { k } ) N _ { k }
$$

where   N k is   a   nonsingular   p   ×   p   matrix   chosen   for   normalization   purposes.  

4:   end for

in   (6.24)   can   be   simpliﬁed   since   P h Y k Z k =   Z k .   We   will   tend   not   to   simplify   such   expressions   in   the   matrix   equations   in   order   that   the   equations   clearly   reveal   the   underlying   geometric   structure   (e.g.,   the   quantity   considered   belongs   to   the   range   of   P h Y k )   or   to   emphasize   the   symmetry   of   certain   operators.  

Note   that   Algorithm   7   is   the   matrix   expression   of   an   algorithm   deﬁned   on   Grass( p, n ).   In   other   words,   if   { Y k }   and   { Y ˇ k }   are   two   sequences   generated   by   Algorithm   7   (with   same   matrix   A )   and   if   span( Y 0 )   =   span(   Y ˇ 0 ),   then   span( Y k )   =   span(   Y ˇ k )   for   all   k .   Algorithm   7   thus   could   be   written   formally   as   an   algorithm   generating   a   sequence   on   Grass( p, n ),   by   taking   as   input   an   element   Y 0 of   Grass( p, n ),   picking   Y 0 ∈   R n ∗ × p with   span( Y 0 ) =   Y 0 ,   proceeding   as   in   Algorithm   7,   and   returning   the   sequence   { span( Y k ) } .   Note   also   that   when   p   =   1   and   N k (now   a   scalar)   is   chosen   as     Y k + Z k   − 1 ,  

Note also that when p = 1 and N k (now a scalar) is chosen as ‖ Y k + Z k ‖ -1 , Algorithm 7 reduces to Algorithm 6.

# 6.4.3 Generalized eigenvalue problem

We   assume   that   A   and   B   are   n   ×   n   symmetric   matrices   with   B   positivedeﬁnite,   and   we   consider   the   generalized   eigenvalue   problem  

$$
A v = \lambda B v
$$

described   in   Section   2.1.   With   a   view   towards   computing   eigenspaces   of   a   pencil   ( A, B ),   we   consider   the   Rayleigh   quotient   function  

$$
f ( \text {span} ( Y ) ) = \text {tr} ( ( Y ^ { T } A Y ) ( Y ^ { T } B Y ) ^ { - 1 } ) ,
$$

[Page 135]

As   in   the   previous   section,   we   view   Grass( p, n )   as   a   Riemannian   quotient   manifold   of   ( R n ∗ × p , g )   with  

$$
\bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) = \text {tr} ( ( Y ^ { T } Y ) ^ { - 1 } Z _ { 1 } ^ { T } Z _ { 2 } ) .
$$

With   a   view   towards   applying   the   Riemannian   Newton   method   given   in   Algorithm   5,   we   need   formulas   for   the   gradient   and   the   Hessian   of   the   Rayleigh   cost   function   (6.25).   Mimicking   the   calculations   in   Section   4.9,   we   obtain  

where  

$$
\frac { 1 } { 2 } \overline { \text {grad} } f _ { Y } = P _ { B Y , Y } A Y ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } Y ,
$$

$$
P _ { U , V } = I - U ( V ^ { T } U ) ^ { - 1 } V ^ { T } \\ \\ \mathfrak { U } , \mathfrak { V } = I - U ( V ^ { T } U ) ^ { - 1 } V ^ { T } \\
$$

denotes   the   projector   parallel   to   the   span   of   U   onto   the   orthogonal   complement   of   the   span   of   V   .   Note   that   the   projection   P h Y onto   the   horizontal   space   H Y is   given   by   h    

$$
P _ { Y } ^ { h } = P _ { Y , Y } .
$$

Using   the   result   in   Proposition   5.3.4   (on   the   Riemannian   connection   on   Riemannian   quotient   manifolds)   and   the   deﬁnition   Hess   f [ ζ ] =   ∇ ζ grad   f ,   we   also   have    

$$
\text {have} & & \frac { 1 } { 2 } \overline { H e s s } \, f [ \zeta ] _ { Y } = \frac { 1 } { 2 } \, P _ { Y , Y } D \overline { \text {grad} } \, f \left ( Y \right ) \left [ \zeta _ { Y } \right ] . \\ \intertext { s g h i n g h i s p e x i m p l e s } \text {equation. Foruntanely, simpler } \text {Newton} \, \text {equations can be obtained}
$$

Expanding   this   expression   is   possible   but   tedious   and   leads   to   a   complicated   Newton   equation.   Fortunately,   simpler   Newton   equations   can   be   obtained   by   exploiting   the   freedom   in   (i)   the   choice   of   the   Riemannian   metric   g ;   (ii)   the   choice   of   the   horizontal   spaces   H Y ,   which   need   not   be   orthogonal   to   the   vertical   spaces   V Y with   respect   to   g ;   (iii)   the   choice   of   the   aﬃne   connection   ∇ ,   which   need   not   be   the   Riemannian   connection   induced   by   g .   We   ﬁrst   consider   an   alternative   Riemannian   metric.   We   still   view   the  

Grassmann   manifold   Grass( p, n )   as   the   quotient   R n ∗ × p /   ∼ ,   where   the   equivalence   classes   of   ∼   are   the   sets   of   elements   of   R ∗   n × p that   have   the   same   column   space.   However,   instead   of   (6.26),   we   consider   on   R n ∗ × p the   metric    

$$
& \text {space. However, instead of } ( 6 . 2 6 ) , \text { we consider on } \mathbb { R } _ { * } \text { the metric } \\ & \quad \bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) = \text {tr} \left ( ( Y ^ { T } B Y ) ^ { - 1 } Z _ { 1 } ^ { T } B Z _ { 2 } \right ) , \\ & \text {is the symmetric positive-definite matrix that appears in the defi- } \\ & \text {f in } ( 6 . 2 5 ) \text { Defining again the horizontal space as the orthogonal }
$$

where   B   is   the   symmetric   positive-deﬁnite   matrix   that   appears   in   the   deﬁnition   of   f   in   (6.25).   Deﬁning   again   the   horizontal   space   as   the   orthogonal   complement—with   respect   to   the   new   inner   product   (6.29)—of   the   vertical   space  

we obtain The orthogonal projection onto H Y is given by

$$
\mathcal { V } _ { Y } \coloneqq T _ { Y } ( \pi ^ { - 1 } ( \pi ( Y ) ) ) = \{ Y M \colon M \in \mathbb { R } ^ { p \times p } \} , \\
$$

$$
\mathcal { H } _ { Y } = \{ Z \in \mathbb { R } ^ { n \times p } \colon Y ^ { T } B Z = 0 \} .
$$

[Page 136]

![The image is a diagram of a coordinate system. The diagram consists of a horizontal line labeled as x and a vertical line labeled as y. The x-axis is labeled as x and the y-axis is labeled as y. The diagram is divided into two parts, with the x-axis and y-axis being the axes of the diagram. The diagram is labeled as follows: - The horizontal line labeled as x is drawn from the bottom left corner to the top right corner. - The vertical line labeled as y is drawn from the bottom left corner to the top left corner. The diagram is divided into two parts, with the x-axis and y-axis being the axes of the diagram. The diagram is labeled as follows: - The horizontal line labeled as x is drawn from the bottom left corner to the top right corner. - The vertical line labeled as y](<images/imageFile20.png>)

U

span( U

)

V

span( V

)

x  

0

-

T U

1

V T

-

P U,V  

x  

I

U

V

x

:= ( I  

(

)

)

V

span( V

)

⊥

Figure 6.1 The projector P U,V .

$$
P _ { Y } ^ { h } = P _ { Y , B Y } = I - Y ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } B . \\ \cdot \\
$$

The   homogeneity   property  

$$
\bar { \xi } _ { Y M } = \bar { \xi } _ { Y } M
$$

$$
\xi _ { Y M } = \xi _ { Y } M
$$

of   Proposition   3.6.1   still   holds   with   the   new   Riemannian   metric   (6.29).   Moreover,  

$$
\bar { g } _ { Y M } ( \bar { \xi } _ { Y M } , \bar { \zeta } _ { Y M } ) = \bar { g } _ { Y } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } ) .
$$

Therefore,   the   Grassmann   manifold   Grass( p, n )   admits   a   unique   Riemannian   metric  

$$
g ( \xi , \zeta ) \colon = \bar { g } _ { Y } ( \bar { \xi } _ { Y } , \bar { \zeta } _ { Y } ) ,
$$

that   makes   (Grass( p, n ) , g )   a   Riemannian   quotient   manifold   of   ( R n ∗ × p , g )   with   g   deﬁned   in   (6.29).  

Before   proceeding   to   obtain   formulas   for   the   gradient   and   the   Hessian   of   f   in   (Grass( p, n ) , g ),   we   ﬁrst   point   out   some   useful   properties   of   the   projector  

$$
P _ { U , V } & = I - U ( V ^ { T } U ) ^ { - 1 } V ^ { T } . \\ \vdots \, _ { U , V } & = \vdots \, _ { U } + \vdots \, _ { V } .
$$

Recall   that   P U,V is   the   projector   that   projects   parallel   to   span( U )   onto   span( V   );   see   Figure   6.1.   Therefore,   we   have   the   identities  

$$
P _ { U , V } U M = 0 \quad \text {and} \quad P _ { U , V } V M = V M .
$$

We   also   have   the   identity  

$$
P _ { U , V } K = K P _ { K ^ { - 1 } U , K ^ { T } V } .
$$

Using   the   above   identities   and   the   technique   of   Section   3.6.2,   we   obtain  

$$
\overline { \text {grad} \, f } _ { Y } = P _ { Y , B Y } B ^ { - 1 } A Y = B ^ { - 1 } P _ { B Y , Y } A Y .
$$

[Page 137]

It   can   be   checked   that   the   new   Riemannian   metric   (6.29)   is   horizontally   invariant.   Consequently,   it   follows   from   Proposition   5.3.4   that   the   Riemannian   Hessian   is   given   by  

$$
\text {Hessian is given by} \\ \overline { \text {Hess} } \, f ( \mathcal { Y } ) [ \eta ] _ { Y } & = \overline { \nabla _ { \eta } \, \text {grad} } \, f _ { Y } \\ & = P _ { Y } ^ { h } D \overline { \text {grad} } \, f \left ( Y \right ) [ \bar { \eta } _ { Y } ] \\ & = P _ { Y , B } \, P _ { B } ^ { - 1 } \, A \bar { \eta } _ { Y } - P _ { Y , B } \, \bar { \eta } _ { Y } ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } A Y \\ & = B ^ { - 1 } P _ { B Y , Y } \left ( A \bar { \eta } _ { Y } - B \bar { \eta } _ { Y } ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } A Y \right ) . \quad ( 6 . 3 4 ) \\ \text {The Newton equation } \nabla _ { \eta } \, \text {grad} \, f & = - \text {grad} \, f ( x ) \, \text {thus yields the equation} \\ B ^ { - 1 } P _ { B Y } \, ( A \bar { \eta } _ { Y } - B \bar { \eta } _ { Y } ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } A Y ) & = - B ^ { - 1 } P _ { B Y } \, A Y ,
$$

The   Newton   equation   ∇ η grad   f   =   − grad   f ( x )   thus   yields   the   equation   − 1     T   − 1   T       − 1  

$$
1 \, \text {the Newton equation } \, v _ { \eta } \, \text {grad} \, f & = - \text {grad} \, f ( x ) \, \text { thus yields the equation} \\ B ^ { - 1 } P _ { B Y , Y } \left ( A \bar { \eta } _ { Y } - B \bar { \eta } _ { Y } ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } A Y \right ) & = - B ^ { - 1 } P _ { B Y , Y } A Y , \\ \text {or equivalently,} \\
$$

$$
& \text { for equivalently, } \\ & \quad P _ { B Y , Y } \left ( A \bar { \eta } _ { Y } - B \bar { \eta } _ { Y } ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } A Y \right ) = - P _ { B Y , Y } A Y . \\ & \text { on conclusion, the geometric Newton method in Algorithm 4, for the Rayleigh
 quotient cost function (6 25) with the affine connection $\nabla$ chosen as the B i g r
$$

In   conclusion,   the   geometric   Newton   method   in   Algorithm   4,   for   the   Rayleigh   quotient   cost   function   (6.25),   with   the   aﬃne   connection   ∇   chosen   as   the   Riemannian   connection   on   Grass( p, n )   seen   as   the   Riemannian   quotient   manifold   of   ( R n ∗ × p , g )   with   g   deﬁned   in   (6.29),   and   with   the   retraction   R   chosen   as   (4.40),   yields   the   matrix   algorithm   displayed   in   Algorithm   8.   The   notation   Z k =   η Y k is   used   so   that   the   algorithm   resembles   contemporary   algorithms   from   the   ﬁeld   of   numerical   linear   algebra.  

# Algorithm 8 Riemannian   Newton   method   for   the   Rayleigh   quotient   on   Grass( p, n )  

Require: Symmetric   matrix   A ,   symmetric   positive-deﬁnite   matrix   B . 
 n × p

Initial iterate Y 0 ∈ R n ∗ × p .

Input:

Output: Sequence of iterates { Y k } in R n ∗ × p .

- 1: for k = 0 , 1 , 2 , . . . do
- 2:   Solve   the   linear   system  


$$
\begin{cases} - \begin{cases} 1 K + E \end{cases} \infty \\ \end{cases}
$$

$$
& \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

for   the   unknown   Z k ,   where   P BY,Y =   I   −   BY   ( Y   T BY   ) − 1 Y   T .   (The   condition   Y k T BZ k expresses   that   Z k belongs   to   the   horizontal   space   H Y k (6.30).)   Set  

3: Set R n A × p concern with the Newton equation (6.35) is that the domain { Z ∈ : Y T BZ = 0 } of the map F : Z ↦→ P BY,Y ( AZ -BZ ( Y T BY ) -1 Y T AY ) differs from its range { Z ∈ R n × p : Y T Z = 0 } . Hence, powers of F cannot be formed, and linear equation solvers based on Krylov subspaces cannot be applied directly to (6.35). A remedy based on preconditioners is discussed in Section 6.5.2. Another remedy is to exploit the freedom in the choice of the affine connection ∇ , which, according to Algorithm 5, need not be the Riemannian connection. To this end, let us view Grass( p, n ) as a Riemannian quotient manifold of ( R n ∗ × p , g ) with

$$
Y _ { k + 1 } = ( Y _ { k } + Z _ { k } ) N _ { k }
$$

where   N k is   a   nonsingular   p   ×   p   matrix   chosen   for   normalization   purposes.  

4:   end for

Algorithm   8   is   related   to   several   eigenvalues   methods;   see   Notes   and   References.  

[Page 138]

$$
\bar { g } _ { Y } ( Z _ { 1 } , Z _ { 2 } ) = \text {tr} ( ( Y ^ { T } B Y ) ^ { - 1 } Z _ { 1 } ^ { T } Z _ { 2 } ) .
$$

Note   that   this   Riemannian   metric   is   diﬀerent   from   the   canonical   Riemannian   metric   (6.26).   The   horizontal   space   deﬁned   as   the   orthogonal   complement   of   the   vertical   space   is   still   given   by   (6.21),   but   the   expression   of   the   gradient   becomes  

$$
\frac { 1 } { 2 } \overline { \text {grad} } f _ { Y } = P _ { B Y , Y } A Y ,
$$

which   is   simpler   than   (6.27).   Now,   instead   of   choosing   the   aﬃne   connection   ∇   as   the   Riemannian   connection,   we   deﬁne   ∇   by   ξ   =   P D ξ   ( Y   ) [ η ]   .   (6.38)  

$$
\text {mannian connection, we define } V \text { by } & & ( \nabla _ { \eta } \xi ) _ { Y } = P _ { B Y , Y } D \bar { \xi } \left ( Y \right ) [ \bar { \eta } _ { Y } ] . & & ( 6 . 3 8 ) \\ \text {checked that } ( 6 . 3 8 ) \text { defines a horizontal lift, } i . e . , \, \left ( \overline { \nabla _ { \eta } \xi } \right ) _ { Y M } = & &
$$

  ∇ η   BY,Y Y Y It   is   readily   checked   that   (6.38)   deﬁnes   a   horizontal   lift,   i.e.,     ∇ η ξ     =   Y M   ∇ η ξ     M ,   and   that   ∇   is   indeed   an   aﬃne   connection   (see   Section   5.2).   With   Y this   aﬃne   connection,   the   horizontal   lift   of   the   Newton   equation   ∇ η grad   f   =   − grad   f ( Y )   reads   P AZ     BZ ( Y   T BY   ) − 1 Y   T AY     =   P AY,   Y   T Z   = 0 ,   (6.39)  

$$
- \text {grad} \, f ( \mathcal { Y } ) \, & \text {reads} \\ P _ { B Y , Y } \left ( A Z - B Z ( Y ^ { T } B Y ) ^ { - 1 } Y ^ { T } A Y \right ) = P _ { B Y , Y } A Y , \ \ Y ^ { T } Z = 0 , \quad ( 6 . 3 9 ) \\ \text {where} \, Z \text { stands for } \bar { \eta } _ { Y } . \text { Observe that the map} \\ & \quad Z \, \underset { \ } { \underset { T } { \, } } \, P _ { B Y , Y } \left ( A Z \, \underset { Z } { \, } \, Z ( \mathcal { Y } \, \text {TV} \, \mathcal { P } ) \, \text {-} \, \text {TV} \, \mathcal { A } \, \right )
$$

where   Z   stands   for   η Y .   Observe   that   the   map   Z    →   P BY,Y   AZ   −   BZ ( Y   T BY   ) − 1 Y   T AY       involved   in   (6.39)   is   now   from   { Z   ∈   R n ∗ × p :   Y   T Z   = 0 }   into   itself.   The   resulting   iteration   is   still   guaranteed   by   Theorem   6.3.2   to   converge   locally   at   least   quadratically   to   the   spectral   invariant   subspaces   of   B − 1 A   (see   Section   6.5.1   for   details).  

Note   that   in   this   section   we   have   always   chosen   the   horizontal   space   as   the   orthogonal   complement   of   the   vertical   space.   The   possibility   of   choosing   other   horizontal   spaces   is   exploited   in   Section   7.5.3.  

# 6.4.4 The nonsymmetric eigenvalue problem

The   Rayleigh   quotient  

f : Grass( p, n ) R : span( Y ) ↦→ tr ( ( Y T Y ) -1 Y T AY ) → depends only on the symmetric part of A ; it is thus clear that when A is nonsymmetric, computing critical points of f in general does not produce invariant subspaces of A . A way to tackle the nonsymmetric eigenvalue problem is to consider instead the tangent vector fi eld on the Grassmann manifold defined by

[Page 139]

$$
\bar { \xi } _ { Y } \coloneqq P _ { Y } ^ { h } A Y ,
$$

where   P h Y denotes   the   projector   (6.22)   onto   the   horizontal   space   (6.21).   This   expression   is   homogeneous   ( ξ Y M =   ξ Y M   )   and   horizontal;   therefore,   as   a   consequence   of   Proposition   3.6.1,   it   is   a   well-deﬁned   horizontal   lift   and   deﬁnes   a   tangent   vector   ﬁeld   given   by   ξ Y = D π   ( Y   )     ξ Y     on   the   Grassmann   manifold.   Moreover,   ξ Y   =   0   if   and   only   if   Y   is   an   invariant   subspace   of   A .   Obtaining   the   Newton   equation   (6.1)   for   ξ   deﬁned   in   (6.40)   is   straightforward:   formula   (6.23),   giving   the   horizontal   lift   of   the   connection,   leads   to  

$$
\overline { \nabla _ { \eta } \xi } _ { Y } = P _ { Y } ^ { h } \left ( A \bar { \eta } _ { Y } - \bar { \eta } _ { Y } ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) \\ \\ + \quad \dot { \cdot } \cdot \quad ( c _ { 1 } ) _ { 1 } \quad ,
$$

and   the   Newton   equation   (6.1)   reads  

$$
\text {the newton equation (6.1)} \, \text {reads} \\ \begin{cases} P _ { Y } ^ { h } \left ( A \bar { \eta } _ { Y } - \bar { \eta } _ { Y } ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) = - P _ { Y } ^ { h } \, A Y , \\ Y ^ { T } \bar { \eta } _ { Y } = 0 , \end{cases}
$$

where   the   second   equation   expresses   that   η Y is   in   the   horizontal   space.   The   resulting   Newton   iteration   turns   out   to   be   identical   to   Algorithm   7,   except   that   A   is   no   longer   required   to   be   symmetric.  

# 6.4.5 Newton with subspace acceleration: Jacobi-Davidson

The   Jacobi-Davidson   approach   is   a   powerful   technique   for   solving   a   variety   of   eigenproblems.   It   has   recently   become   widely   popular   among   chemists   and   solid-state   physicists   for   computing   a   few   extreme   eigenpairs   of   large-scale   eigenvalue   problems.   In   this   section,   the   principles   of   the   Jacobi-Davidson   approach   are   brieﬂy   reviewed   and   the   method   is   interpreted   as   a   Rayleighbased   Riemannian   Newton   method   within   a   sequential   subspace   optimization   scheme.  

For   simplicity   we   focus   on   the   standard   eigenvalue   problem   and   let   A   be   a   symmetric   n   ×   n   matrix.   Central   to   the   Jacobi-Davidson   approach   is   the   Jacobi correction equation

$$
( I - x _ { k } x _ { k } ^ { T } ) ( A - \tau _ { k } I ) ( I - x _ { k } x _ { k } ^ { T } ) s _ { k } & = - ( A - \tau _ { k } I ) x _ { k } , \ \ x _ { k } ^ { T } s _ { k } = 0 , \quad ( 6 . 4 2 ) \\ \vdots \vdots \ \intertext { ( I - x _ { k } x _ { k } ^ { T } ) ( A - \tau _ { k } I ) ( I - x _ { k } x _ { k } ^ { T } ) s _ { k } & = - ( A - \tau _ { k } I ) x _ { k } , \ \ x _ { k } ^ { T } s _ { k } = 0 , \quad ( 6 . 4 2 ) \\ \intertext { ( I - x _ { k } x _ { k } ^ { T } ) ( A - \tau _ { k } I ) ( I - x _ { k } x _ { k } ^ { T } ) s _ { k } & = 0 , \quad ( 6 . 4 2 )
$$

which,   for   the   usual   choice   of   shift   τ k =   x k T Ax k ,   reduces   to   the   Newton   equation   for   the   Rayleigh   quotient   on   the   sphere   (see   Algorithm   6).  

In   the   Riemannian   Newton   method   the   update   vector   s k is   retracted   onto   the   manifold   to   produce   the   next   iterate   x k +1 =   R x k s k ;   for   example,   the   choice   (6.16)   of   the   retraction   R   yields   x k +1 = ( x k +   s k ) /   x k +   s k   .   Instead,   in   the   Jacobi-Davidson   approach,   the   update   vector   is   used   to   expand   a   low-dimensional   search   space   on   which   the   given   eigenproblem   is   projected.   This   is   the   standard   Rayleigh-Ritz   procedure   that   underlies   all   Davidson-like   methods,   as   well   as   the   Lanczos   and   Arnoldi   methods.   The   small   projected   problem   is   solved   by   standard   techniques,   and   this   leads   to   approximations  

[Page 140]

# Algorithm 9 Jacobi-Davidson  

Require: Symmetric   matrix   A .  

Input: Select   a   set   of   k 0 ( ≥   1)   orthonomal   vectors   v 1 , . . . , v k 0 and   set   V 1 =   [ v 1 . . .   v k 0 ].   | | Output: Sequence   of   iterates   { x k } .  

Output: Sequence of iterates { x k } .

- 1: for k = 1 , 2 , . . . do
- 2: Compute the interaction matrix H k = V k T AV k .
- 3: Compute the leftmost eigenpair ( ρ k , y k ) of H k (with ‖ y k ‖ = 1).
- 4: Compute the Ritz vector x k = V k y k .
- 5: 	 If   needed,   shrink   the   search   space:   compute   the   j min leftmost   eigenpairs   ( ρ ( k j ) , y k ( j ) )   of   H k and   reset   V k :=   V k [ y k (1) |···   | y k ( j min ) ].   6: 	 Obtain   s k by   solving   (approximately)   the   Jacobi   equation   (6.42).  
- 6: Obtain s k by solving (approximately) the Jacobi equation (6.42).
- 7: 	 Orthonormalize   [ V k s k ]   into   V k +1 . | 8:   end for
- 8: end  for


for   the   wanted   eigenvector   and   eigenvalues   of   the   given   large   problem.   The   procedure   is   described   in   Algorithm   9   for   the   case   where   the   leftmost   eigenpair   of   A   is   sought.  

Practical   implementations   of   Algorithm   9   vary   widely   depending   on   the   methods   utilized   to   solve   the   Jacobi   equation   approximately   and   to   reduce   the   search   space.  

Concerning   the   solution   of   the   Jacobi   equation,   anticipating   the   development   in   Chapter   7,   we   point   out   that   the   solution   s k of   (6.42)   is   the   critical   point   of   the   model  

  m x k ( s )   :=   x k T Ax k + 2 s   T Ax k +   s   T ( A   −   x k T Ax k I ) s,   x k T s   = 0 .   This   model   is   the   quadratic   Taylor   expansion   of   the   cost   function   ( x k +   s ) T A ( x k +   s ) f     R :   T S n − 1   R   :   s    

$$
f \circ R _ { x _ { k } } \colon T _ { x _ { k } } S ^ { n - 1 } \to \mathbb { R } \colon s \mapsto \frac { ( x _ { k } + s ) ^ { T } A ( x _ { k } + s ) } { ( x _ { k } + s ) ^ { T } ( x _ { k } + s ) }
$$

  around   the   origin   0   of   the   Euclidean   space   T x k S n − 1 ,   where   f   denotes   the   Rayleigh   quotient   on   the   sphere   and   R   denotes   the   retraction   (6.16).   When   the   goal   of   the   algorithm   is   to   minimize   the   Rayleigh   quotient   (in   order   to   ﬁnd   the   leftmost   eigenpair),   the   idea   of   solving   the   Jacobi   equation,   which   amounts   to   computing   the   critical   point   s ∗   of   the   model   m x k ( s ),   presents   two   drawbacks:   (i)   the   critical   point   is   not   necessarily   a   minimizer   of   the   model,   it   may   be   a   saddle   point   or   a   maximizer;   (ii)   even   when   the   critical   point   is   a   minimizer,   it   may   be   so   far   away   from   the   origin   of   the   Taylor   expansion   that   there   is   an   important   mismatch   between   the   model   m   x k ( s ∗ )   and   the   cost   function   f R x k ( s ∗ ).   The   trust-region   approach   presented   in   ◦ Chapter   7   remedies   these   drawbacks   by   selecting   the   update   vector   s k as   an   approximate   minimizer   of   the   model     ,   constrainted   to   a   region   around   m x k s   =   0   where   its   accuracy   is   trusted.   Therefore,   algorithms   for   approximately   solving   trust-region   subproblems   (see   Section   7.3)   can   be   fruitfully   used   as   “intelligent”   approximate   solvers   for   the   Jacobi   equation   that   are   aware   of   the   underlying   Rayleigh   quotient   optimization   problem.  

[Page 141]

Concerning   the   sequential   subspace   approach,   if   the   sequence   of   computed   s k ’s   is   gradient-related,   then   the   Jacobi-Davidson   method   ﬁts   within   the   framework   of   Algorithm   1   (an   accelerated   line   search)   and   the   convergence   analysis   of   Section   4.3   applies.   In   particular,   it   follows   from   Theorem   4.3.1   that   every   accumulation   point   of   the   sequence   { x k }   is   a   critical   point   of   the   Rayleigh   quotient,   and   thus   an   eigenvector   of   A .   A   simple   way   to   guarantee   that   { x k }   stems   from   a   gradient-related   sequence   is   to   include   grad   f ( x k ) =   Ax k −   x k x T Ax k as   a   column   of   the   new   basis   matrix   V k +1 . k

# 6.5 ANALYSIS OF RAYLEIGH QUOTIENT ALGORITHMS

In   this   section,   we   ﬁrst   formally   prove   quadratic   convergence   of   the   Newton   algorithms   for   the   Rayleigh   quotient   developed   in   the   previous   section.   After   this,   the   remainder   of   the   section   is   devoted   to   a   discussion   of   the   numerical   implementation   of   the   proposed   algorithms.   Eﬃciently   solving   the   Newton   equations   is   an   important   step   in   generating   numerically   tractable   algorithms.   The   structured   matrix   representation   of   the   Newton   equations   that   result   from   the   approach   taken   in   this   book   means   that   we   can   exploit   the   latest   tools   from   numerical   linear   algebra   to   analyze   and   solve   these   equations.  

# 6.5.1 Convergence analysis

For   the   convergence   analysis,   we   focus   on   the   case   of   Algorithm   8   (iteration   on   the   Grassmann   manifold   for   the   generalized   eigenvalue   problem).   The   convergence   analysis   of   Algorithm   7   (standard   eigenvalue   problem,   on   the   Grassmann   manifold)   follows   by   setting   B   =   I .   These   results   also   apply   to   Algorithm   6   (on   the   sphere)   since   it   ﬁts   in   the   framework   of   Algorithm   7.  

Since   Algorithm   8   is   a   particular   instance   of   the   general   geometric   Newton   method   (Algorithm   4),   the   convergence   analysis   in   Theorem   6.3.2   applies   to   Algorithm   8.   A   p -dimensional   subspace   span( Y ∗ )   is   a   critical   point   of   the   Rayleigh   quotient   (6.25)   if   and   only   if   span( Y ∗ )   is   an   invariant   subspace   of   the   pencil   ( A, B ).   The   condition   in   Theorem   6.3.2   that   the   Jacobian   (here,   the   Hessian   of   f )   at   span( Y ∗ )   be   invertible   becomes   the   condition   that   the   Hessian   operator    

$$
& \text {Hessian operator} \\ & \quad Z \in \mathcal { H } _ { Y _ { * } } \, \leftrightarrow \, B ^ { - 1 } P _ { B Y _ { * } , Y _ { * } } \left ( A Z - B Z ( Y _ { * } ^ { T } B Y _ { * } ) ^ { - 1 } Y _ { * } ^ { T } A Y _ { * } \right ) \in \mathcal { H } _ { Y _ { * } } \\ & \text {given in } ( 6 . 3 4 ) \, \text { be invertible. It can be shown that this happens if and only } \\ & \text {if the invariant subspace span(Y_) is semtrcal, i.e. for every eigenvalue } \, \} \, \text {of}
$$

given   in   (6.34)   be   invertible.   It   can   be   shown   that   this   happens   if   and   only   if   the   invariant   subspace   span( Y ∗ )   is   spectral ,   i.e.,   for   every   eigenvalue   λ   of   B − 1 A | span( Y ∗ ) the   multiplicities   of   λ   as   an   eigenvalue   of   B − 1 A | span( Y ∗ ) and   as   an   eigenvalue   of   B − 1 A   are   identical.   (To   prove   this,   one   chooses   a   basis   where   B   is   the   identity   and   A   is   diagonal   with   the   eigenvalues   of   B − 1 A | span( Y ∗ ) in   the   upper   left   block.   The   operator   reduced   to   H Y ∗ turns   out   to   be   diagonal   with   all   diagonal   elements   diﬀerent   from   zero.)  

[Page 142]

Theorem 6.5.1 (local convergence of Algorithm 8) Under the requirements of Algorithm 8, assume that there is a Y ∗   ∈   R n × p such that span( Y ∗ )   is a spectral invariant subspace of B − 1 A . Then there exists a neighborhood U   of span( Y ∗ )   in Grass( p, n )   such that, for all Y 0 ∈   R n × p with span( Y 0 )   ∈ U , Algorithm 8 generates an inﬁnite sequence { Y k }   such that { span( Y k ) }   converges superlinearly (at least quadratically) to Y ∗   on Grass( p, n ) .

Concerning   the   algorithm   for   the   nonsymmetric   eigenvalue   problem   presented   in   Section   6.4.4,   it   follows   by   a   similar   argument   that   the   iterates   of   the   method   converge   locally   superlinearly   to   the   spectral   invariant   subspaces   of   A .  

# 6.5.2 Numerical implementation

A   crucial   step   in   a   numerical   implementation   of   the   Newton   algorithms   lies   in   solving   the   Newton   equations.   We   ﬁrst   consider   the   Grassmann   case   with   B   =   I   (standard   eigenvalue   problem).   For   clarity,   we   drop   the   subscript   k .   The   Newton   equation   (6.24)   reads    

$$
\text {Newton equation} \left ( 6 . 2 4 \right ) \text { reads} \\ \begin{cases} P _ { Y } ^ { h } \left ( A Z - Z ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } A Y \right ) = - P _ { Y } ^ { h } ( A Y ) \\ Y ^ { T } Z = 0 , \end{cases} \\ \text {zero} \, Z \text { is the unknown and } P _ { h } ^ { h } = ( I \, \ V ( Y ^ { T } Y ) ^ { - 1 } Y ^ { T } ) \text { in order to colomo this}
$$

where   Z   is   the   unknown   and   P   h = ( I   − Y   ( Y   T Y   ) − 1 Y   T ).   In   order   to   make   this   Y equation   simpler,   the   ﬁrst   thing   to   do   is   to   choose   Y   orthonormal,   so   that   Y   T Y   =   I .   Since   Y   T AY   is   symmetric,   it   is   possible   to   further   choose   Y   such   that   Y   T AY   is   diagonal.   This   can   be   done   by   computing   a   matrix   M   such   that   ( Y M ) T AY   M   ≡   M T ( Y   T AY   ) M   is   diagonal   and   making   Y   ←   Y M .   This   corresponds   to   solving   a   small-scale   p   ×   p   eigenvalue   problem.   The   diagonal   elements   ρ 1 , . . . , ρ p of   the   diagonal   matrix   Y   T AY   are   called   the   Ritz values related   to   ( A,   span( Y   )),   and   the   columns   of   Y   are   the   corresponding   Ritz vectors .   This   decouples   (6.43)   into   p   independent   systems   of   linear   equations   of   the   form  

$$
\begin{cases} P _ { Y } ^ { h } ( A - \rho _ { i } I ) P _ { Y } ^ { h } z _ { i } = - P _ { Y } ^ { h } A y _ { i } , \\ Y ^ { T } z _ { i } = 0 , \end{cases}
$$

where   z 1 , . . . , z p ∈   R p are   the   columns   of   Z .   Note   that   (6.44)   resembles   a   parallel   implementation   of   p   Newton   methods   (6.17).   However,   the   projection   operator   P h in   (6.44)   is   equal   to   ( I   −   Y   ( Y   T Y   ) − 1 Y   T ),   whereas   the   parallel   Y implementation   of   (6.17)   would   lead   to  

$$
\begin{array} { c } \text {of (6.17) would lead to } \\ \\ \begin{cases} P _ { y _ { i } } ( A - \rho _ { i } I ) P _ { y _ { i } } z _ { i } = - P _ { y _ { i } } A y _ { i } , \\ y _ { i } ^ { T } z _ { i } = 0 , \end{cases} \\ \text { } \\ \end{array}
$$

i   = 1 , . . . , p ,   where   P y i = ( I   −   y i ( y i T y i ) − 1 y i T ).   Methods   for   solving   (6.44)   include   Krylov-based   methods   that   naturally   enforce   the   constraint   Y   T z i .   Another   approach   is   to   transform   (6.44)   into   the   saddle-point   problem      

$$
\text {er approach is to transform } ( 6 . 4 4 ) \text { into the saddle-point problem } \\ \begin{bmatrix} A - \rho _ { i } I & Y \\ Y ^ { T } & 0 \end{bmatrix} & \begin{bmatrix} z _ { i } \\ \ell \end{bmatrix} = \begin{bmatrix} - ( A - f ( y _ { i } ) I ) y _ { i } \\ 0 \end{bmatrix} ,
$$

[Page 143]

a   structured   linear   system   for   which   several   algorithms   have   been   proposed   in   the   literature.  

We   now   look   speciﬁcally   into   the   p   =   1   case,   in   the   form   of   the   Newton   equation   (6.17)   on   the   sphere,   repeated   here   for   convenience:  

$$
\text {on the sphere, repeated here for convenience} \\ \begin{cases} P _ { x } A P _ { x } \eta - \eta x ^ { T } A x = - P _ { x } A x , \\ x ^ { T } \eta = 0 , \end{cases}
$$

where   P x = ( I   −   xx T ).   The   Newton   equation   (6.17)   is   a   system   of   linear   equations   in   the   unknown   η k ∈   R n .   It   admits   several   equivalent   formulations.   For   example,   using   the   fact   that   P x x   =   0,   (6.17)   can   be   rewritten   as  

$$
P _ { x } ( A - f ( x ) I ) ( x + \eta ) = 0 , \ \ x ^ { T } \eta = 0 , \\ \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \
$$

where   f ( x )   still   stands   for   the   Rayleigh   quotient   (6.15).   Equation   (6.17)   is   also   equivalent   to   the   saddle-point problem  

$$
\text {unit} \, \text {to the side-point problem} \\ \begin{bmatrix} A - f ( x ) I & x \\ x ^ { T } & 0 \end{bmatrix} \begin{bmatrix} \eta \\ \ell \end{bmatrix} & = \begin{bmatrix} - ( A - f ( x ) I ) y \\ 0 \end{bmatrix} . \\ f ( x ) I \text { is nonsingular} \, then \, the solution } \, \eta \text { of } ( 6 . 1 7 ) \text { is given explicitly}
$$

If   A   −   f ( x ) I   is   nonsingular,   then   the   solution   η   of   (6.17)   is   given   explicitly   by  

$$
\eta = - x + ( A - f ( x ) I ) ^ { - 1 } x \frac { 1 } { x ^ { T } ( A - f ( x ) I ) ^ { - 1 } x } . \\ \text {points to an interesting link with the Rayleigh quotient iteration} \text { with}
$$

This   points   to   an   interesting   link   with   the   Rayleigh   quotient   iteration:   with   the   retraction   deﬁned   in   (6.16),   the   next   iterate   constructed   by   Algorithm   6   is   given   by  

$$
\frac { x + \eta } { \| x + \eta \| } = \frac { ( A - f ( x ) I ) ^ { - 1 } x } { \| ( A - f ( x ) I ) ^ { - 1 } x \| } , \\ \text {ula defining the Rayleigh quotient} \, \text {iterating}
$$

which   is   the   formula   deﬁning   the   Rayleigh   quotient   iteration.   n × ( n − 1) T

With   U   ∈   R chosen   such   that   [ x | U ] [ x | U ] =   I ,   (6.17)   is   also   equivalent   to  

$$
( U ^ { T } A U - f ( x ) I ) s & = - U ^ { T } A x , \quad \eta = U s , \\ \vdots & \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \
$$

which   is   a   linear   system   in   classical   form   in   the   unknown   s .   Note   that   when   A   is   a   large   sparse   matrix,   the   matrix   U   is   large   and   dense,   and   there   may   not   be   enough   memory   space   to   store   it.   Moreover,   the   sparsity   of   A   is   in   general   not   preserved   in   the   reduced   matrix   U T AU .   The   approach   (6.48)   should   thus   be   avoided   in   the   large   sparse   case.   It   is   preferable   to   solve   the   system   in   the   form   (6.17)   or   (6.46)   using   an   iterative   method.  

/negationslash

  We   now   brieﬂy   discuss   the   generalized   case   B   =   I .   The   Newton   equation   (6.35)   can   be   decoupled   into   p   independent   equations   of   the   form  

$$
P _ { B Y , Y } ( A - \rho _ { i } I ) P _ { Y , B Y } z _ { i } & = - P _ { B Y , Y } A y _ { i } , \, Y ^ { T } B z _ { i } = 0 . \\ \vdots & \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \vdots \
$$

The   corresponding   saddle-point   formulation   is    

$$
\text {respounding saddle-point formulation is} \\ \begin{bmatrix} A - \rho _ { i } B & B Y \\ ( B Y ) ^ { T } & 0 \end{bmatrix} \begin{bmatrix} z _ { i } \\ \ell \end{bmatrix} = \begin{bmatrix} - ( A - \rho _ { i } B ) y _ { i } \\ 0 \end{bmatrix} ,
$$

[Page 144]

where   ρ i :=   y i T Ay i / ( y i T By i ).   For   the   purpose   of   applying   a   Krylov-like   iterative   method,   the   Newton   equations   (6.49)   present   the   diﬃculty   that   the   operator   on   the   left-hand   side   sends   z i ∈   (span( BY   )) ⊥   to   the   subspace   (span( Y   )) ⊥ .   A   remedy   is   to   solve   the   equivalent   equation   obtained   by   applying   the   projector   P BY,BY to   (6.49).  

This trick is a particular instance of a more general technique called   predenote the pseudo-inverse. Then (6.49) is equivalent to   †   conditioning .   Assume   that   we   have   a   matrix   K   that   is   a   reasonably   good   approximation   of   ( A   −   ρ i B )   and   such   that   the   operator   K − 1 is   easily   available   (in   other   words,   systems   Kx   =   b   are   easy   to   solve).   Let   the   superscript   †  

$$
( P _ { B Y , Y } K P _ { Y , B Y } ) ^ { \dagger } \, P _ { B Y , Y } ( A - \rho _ { i } I ) P _ { Y , B Y } \, z _ { i } \\ = - \, ( P _ { B Y , Y } K P _ { Y , B Y } ) ^ { \dagger } \, P _ { B Y , Y } \, A _ { y _ { i } } , \quad Y ^ { T } B z _ { i } = 0 . \quad ( 6 . 5 1 ) \\ \text {The advantage is that the operator acting on $z_{i}$ on the left-hand side of $(6,5 1)$}
$$

The advantage is that the operator acting on   on the left-hand side of (6.51) z i is close to the identity, which improves the speed of convergence of Krylovbased iterative solvers. In practice, applying this operator is made possible   by   the   Olsen   formula  

$$
\text {by the Oseen limita} \\ & \left ( P _ { \widetilde { Q } , Q } K P _ { U , \widetilde { U } } \right ) ^ { \dagger } = P _ { U , U } P _ { K ^ { - 1 } \widetilde { Q } , \widetilde { U } } K ^ { - 1 } P _ { Q , Q } = P _ { U , U } K ^ { - 1 } P _ { \widetilde { Q } , K ^ { - 1 } \widetilde { U } } P _ { Q , Q } \\ \text {since we have assumed that the operator } K ^ { - 1 } \text { is easily available.}
$$

since   we   have   assumed   that   the   operator   K − 1 is   easily   available.  

# 6.6 NOTES AND REFERENCES

The   history   of   Newton’s   method   on   manifolds   can   be   traced   back   to   Luenberger   [Lue72],   if   not   earlier.   Gabay   [Gab82]   proposed   a   Newton   method   on   embedded   submanifolds   of   R n .   Smith   [Smi93,   Smi94]   and   Udri¸ ste   [Udr94]   formulated   the   method   on   general   Riemannian   manifolds,   and   Smith   [Smi93,   Smi94]   provided   a   proof   of   quadratic   convergence.   Mahony’s   thesis   [Mah94,   Mah96,   MM02]   develops   a   Newton   method   on   Lie   groups   and   homogeneous   spaces.   Related   work   includes   [Shu86,   EAS98,   OW00,   Man02,   MM02,   ADM + 02,   FS02,   DPM03,   HT04,   ABM06].  

Smith   [Smi93,   Smi94]   proposes   a   geometric   Newton   method   that   seeks   a   zero   of   a   one-form   (instead   of   a   vector   ﬁeld).   The   underlying   idea   is   that   aﬃne   connections   can   be   extended   to   general   tensors,   and   in   particular   to   one-forms.   This   approach   makes   it   possible   to   deﬁne   a   Newton   method   that   seeks   a   critical   point   of   a   cost   function   deﬁned   on   a   manifold   equipped   with   an   aﬃne   connection   and   a   retraction   (cf.   the   requirements   of   Algorithm   4)   but   not   necessarily   with   a   Riemannian   metric   since   the   Riemannian   metric   is   no   longer   needed   to   deﬁne   the   gradient   vector   ﬁeld.   (Smith   nevertheless   requires   the   manifold   to   be   Riemannian,   notably   because   his   algorithms   use   the   Riemannian   exponential   to   perform   the   update.)  

Our convergence analysis (Theorem 6.3.2) of the geometric Newton method, which was built from the R n proof given by Dennis and Schnabel [DS83, Th. 5.2.1] and is strongly based on coordinates. A coordinate-free approach can be found in Smith [Smi93, Smi94] for the case of a real-valued function on a Riemannian manifold with its Riemannian connection and exponential retraction; this elegant proof exploits bounds on the second and third covariant derivatives of the cost function and on the curvature of the manifold in a neighborhood of the critical point.

[Page 145]

The   calculus-based   local   analysis   in   Section   6.3.1   was   inspired   by   the   work   of   H¨ uper;   see,   e.g.,   [HH00,   H¨ up02,   HT04].  

In   general,   it   cannot   be   guaranteed   that   the   Jacobian   J ( x k )   in   Newton’s   method   (Algorithm   4)   is   nonsingular.   In   other   words,   the   Newton   equation   (6.1)   may   not   admit   one   and   only   one   solution.   Even   if   it   does,   the   Jacobian   operator   may   be   poorly   conditioned,   so   that   the   linear   system   (6.1)   cannot   be   reliably   solved.   If   this   happens   while   x k is   far   away   from   the   solution,   a   possible   remedy   is   to   fall   back   to   a   ﬁrst-order,   steepest-descent-like   method.   Several   other   remedies   exist   that   pertain   to   globally   convergent   modiﬁcations   of   Newton’s   method;   see,   e.g.,   Dennis   and   Schnabel   [DS83]   and   Nocedal   and   Wright   [NW99].  

Several   ways   to   combine   Newton   and   line-search   approaches   are   discussed   in   Dennis   and   Schnabel   [DS83,   Ch.   6].   For   more   information   on   positivedeﬁnite   modiﬁcations   of   the   Hessian,   see   Nocedal   and   Wright   [NW99,   § 6.3].  

Theorem   6.3.2   states   that   the   sequences   { x k }   generated   by   Algorithm   4   (the   geometric   Newton   method)   converge   to   any   nondegenerate   zero   x ∗   of   the   vector   ﬁeld   whenever   the   initial   point   x 0 belongs   to   some neighborhood   of   x ∗ ;   however,   Theorem   6.3.2   is   silent   about   the   size of   this   neighborhood.   For   Newton’s   method   in   R n applied   to   ﬁnding   a   zero   of   a   function   F   ,   Kantorovich’s   theorem   [Kan52]   (or   see   [Den71,   DS83])   states   that   if   the   product   of   a   Lipschitz   constant   for   the   Jacobian   times   a   bound   on   the   inverse   of   the   Jacobian   at   x 0 times   a   bound   on   the   ﬁrst   Newton   vector   is   smaller   than   1 2 ,   then   the   function   F   has   a   unique   zero   x ∗   in   a   ball   around   x 0 larger   than   a   certain   bound   and   the   iterates   of   Newton’s   method   converge   to   x ∗ .   This   is   a   very   powerful   result,   although   in   applications   it   is   often   diﬃcult   to   ensure   that   the   Kantorovich   condition   holds.   Kantorovich’s   theorem   was   generalized   to   the   Riemannian   Newton   method   by   Ferreira   and   Svaiter   [FS02].   Another   way   to   obtain   information   about   the   basins   of   attraction   for   Newton’s   method   is   to   use   Smale’s   γ   and   α   theorems,   which   were   generalized   to   the   Riemannian   Newton   method   by   Dedieu   et al. [DPM03].  

For the application to the computation of invariant subspaces of a matrix, Theorem 6.5.1 states that the sequences { span( Y k ) } produced by Algorithm 7 converge locally to any p -dimensional spectral invariant subspace V of A provided that the initial point is in a basin of attraction that contains an open ball around V in the Grassmann manifold, but it does not give any information about the size of the basin of attraction. This is an important issue since a large basin of attraction means that the iteration converges to the target invariant subspace even if the initial estimate is quite imprecise. It has been shown for previously available methods that the basins of attraction are prone to deteriorate when some eigenvalues are clustered. Batterson and Smillie [BS89] have drawn the basins of attraction of the Rayleigh quotient iteration (RQI) for n = 3 and have shown that they deteriorate when two eigenvalues are clustered. The bounds involved in the convergence results of the methods analyzed by Demmel [Dem87] blow up when the external gap vanishes. It was shown in [ASVM04], analytically and numerically, that the Riemannian Newton method applied to the Rayleigh quotient on the Grassmann manifold suffers from a similar dependence on the eigenvalue gap. It was also shown how this drawback can be remedied by considering a Levenberg-Marquardt-like modification of the Newton algorithm. The modified algorithm depends on a real parameter whose extreme values yield the Newton method on the one hand, and the steepest-descent method for the cost function ‖ ξ ‖ with ξ defined in (6.40) on the other hand. A specific choice for this parameter was proposed that significantly improves the size of the basins of attraction around each invariant subspace.

[Page 146]

The   formula   for   the   Hessian   of   the   Brockett   cost   function   (4.32)   on   the   Stiefel   manifold   is   straightforward   using   formula   (5.15)   for   the   Riemannian   connection   on   Riemannian   submanifolds   of   Euclidean   spaces.   The   resulting   Newton   equation,   however,   is   signiﬁcantly   more   complex   than   the   Newton   equation   (6.24)   for   the   Rayleigh   quotient   on   the   Grassmann   manifold.   This   outcome   is   due   to   the   fact   that   the   projection   (3.35)   onto   the   tangent   space   to   the   Stiefel   manifold   has   one   more   term   than   the   projection   (3.41)   onto   the   horizontal   space   of   the   Grassmann   manifold   (viewed   as   a   quotient   of   the   noncompact   Stiefel   manifold).   The   extra   complexity   introduced   into   the   Newton   equation   signiﬁcantly   complicates   the   evaluation   of   each   iterate   and   does   not   signiﬁcantly   add   to   the   performance   of   the   method   since   the   Grassmann   Newton   method   identiﬁes   an   invariant   p -dimensional   subspace   and   the   numerical   cost   of   identifying   the   Ritz   vectors   of   this   subspace   is   a   negligible   additional   cost   on   top   of   the   subspace   problem.  

The   term   “ spectral invariant   subspace”   is   used   by   Rodman   et al. [GLR86,   RR02];   Stewart   [Ste01]   uses   the   term   “ simple invariant   subspace”.   The   material   in   Section   6.4.4   comes   from   [AMS04].   There   is   a   vast   literature   on   saddle-point   problems   such   as   (6.46);   see   Benzi   et al. [BGL05]   for   a   survey.   For   the   numerical   computation   of   U   in   (6.48),   we   refer   the   reader   to   [NW99,   § 16.2],   for   example.   Saad   [Saa96]   is   an   excellent   reference   on   iterative   solvers   for   linear   systems   of   equations.   Practical   implementation   issues   for   Newton   methods   applied   to   the   Rayleigh   quotient   are   further   discussed   in   Absil   et al. [ASVM04].  

Several   methods   proposed   in   the   literature   are   closely   related   to   the   eigenvalue   algorithms   proposed   in   this   chapter.   These   methods   diﬀer   on   three   points:   (i)   the   matrix   BY   in   the   structured   matrix   involved   in   the   Newton   equation   (6.50).   (ii)   the   shifts   ρ i .   (iii)   the   way   the   z i ’s   are   used   to   compute   the   new   iterate.  

[Page 147]

The   modiﬁed   block   newton   method   proposed   by   L¨ osche   et al. [LST98]   corresponds   to   Algorithm   8   with   B   =   I .   The   authors   utilize   formula   (6.50)   and   prove   quadratic   convergence.   In   fact,   the   order   of   convergence   is   even   cubic   [AMS04].  

The   Newton   method   discussed   by   Edelman   et al. [EAS98,   p.   344]   corresponds   to   Algorithm   5   applied   to   the   Rayleigh   quotient   (6.19)   on   the   Grassmann   manifold   with   ∇   chosen   as   the   Riemannian   connection   and   R   chosen   as   the   exponential   mapping.  

Smith   [Smi93,   Smi94]   mentions   Algorithm   6   but   focuses   on   the   version   where   the   retraction   R   is   the   exponential   mapping.  

The   shifted   Tracemin   algorithm   of   Sameh   and   Wisniewski   [SW82,   ST00]   can   be   viewed   as   a   modiﬁcation   of   Algorithm   8   where   the   shifts   ρ i in   (6.49)  or   equivalently   (6.50)—are   selected   using   a   particular   strategy.   The   simple   (unshifted)   version   of   Tracemin   corresponds   to   ρ i =   0.   This   algorithm   is   mathematically   equivalent   to   a   direct   subspace   iteration   with   matrix   A − 1 B .   The   choice   ρ i =   0   is   further   discussed   and   exploited   in   the   context   of   a   trust-region   method   with   an   adaptive   model   in   [ABGS05].  

Equation   (6.47)   corresponds   to   equation   (2.10)   in   Sameh   and   Tong   [ST00]   and   to   algorithm   2   in   Lundstr¨ om   and   Elden   [LE02,   p.   825]   to   some   extent.  

Relations   between   the   RQI   and   various   Newton-based   approaches   are   mentioned   in   several   references,   e.g.,   [PW79,   Shu86,   Smi94,   ADM + 02,   MA03].   This   equivalence   still   holds   when   certain   Galerkin   techniques   are   used   to   approximately   solve   the   Newton   and   RQI   equations   [SE02].   A   block   generalization   of   the   RQI   is   proposed   in   [Smi97,   AMSV02].   The   connection   with   the   Newton   method   does   not   hold   for   the   block   version   [AMSV02].  

The   method   proposed   by   Fattebert   [Fat98]   is   connected   with   (6.50).   The   idea   is   to   replace   BY   in   (6.50)   by   thinner   matrices   where   some   columns   that   are   not   essential   for   the   well   conditioning   of   the   linear   system   are   omitted.   This   approach   is   thus   midway   between   that   of   the   Newton   method   and   the   RQI.  

As   discussed   in   [EAS98,   AMSV02],   the   Newton   method   proposed   by   Chatelin   [Cha84,   Dem87]   corresponds   to   performing   a   classical   Newton   method   in   a   ﬁxed   coordinate   chart   of   the   Grassmann   manifold.   In   contrast,   the   algorithms   proposed   in   this   chapter   can   be   viewed   as   using   an   adaptive   coordinate   chart,   notably   because   the   retraction   used,   for   example,   in   Step   3   of   Algorithm   6   depends   on   the   current   iterate   x k .  

For   more   information   on   the   Jacobi-Davidson   approach   and   related   generalized   Davidson   methods,   see   Sleijpen   et al. [SVdV96,   SvdVM98],   Morgan   and   Scott   [MS86],   Stathopoulos   et al. [SS98,   Sta05,   SM06],   Notay   [Not02,   Not03,   Not05],   van   den   Eshof   [vdE02],   Brandts   [Bra03],   and   references   therein.   Methods   for   (approximately)   solving   the   Jacobi   (i.e.,   Newton)   equation   can   also   be   found   in   these   references.   The   Newton   algorithm   on   the   sphere   for   the   Rayleigh   quotient   (Algorithm   6)   is   very   similar   to   the   simpliﬁed   Jacobi-Davidson   algorithm   given   in   [Not02];   see   the   discussion   in   [ABG06b].   The   Newton   equations   (6.24),   (6.35),   and   (6.39)   can   be   thought   of   as   block   versions   of   particular   instances   of   the   Jacobi   correction  

[Page 148]

[Page 149]

# Trust-Region   Methods  

The   plain   Newton   method   discussed   in   Chapter   6   was   shown   to   be   locally   convergent   to   any   critical   point   of   the   cost   function.   The   method   does   not   distinguish   among   local   minima,   saddle   points,   and   local   maxima:   all   (nondegenerate)   critical   points   are   asymptotically   stable   ﬁxed   points   of   the   Newton   iteration.   Moreover,   it   is   possible   to   construct   cost   functions   and   initial   conditions   for   which   the   Newton   sequence   does   not   converge.   There   even   exist   examples   where   the   set   of   nonconverging   initial   conditions   contains   an   open   subset   of   search   space.  

To   exploit   the   desirable   superlinear   local   convergence   properties   of   the   Newton   algorithm   in   the   context   of   global   optimization,   it   is   necessary   to   embed   the   Newton   update   in   some   form   of   descent   method.   In   Chapter   6   we   brieﬂy   outlined   how   the   Newton   equation   can   be   used   to   generate   a   descent   direction   that   is   used   in   a   line-search   algorithm.   Such   an   approach   requires   modiﬁcation   of   the   Newton   equation   to   ensure   that   the   resulting   sequence   of   search   directions   is   gradient-related   and   an   implementation   of   a   standard   line-search   iteration.   The   resulting   algorithm   will   converge   to   critical   points   of   the   cost   function   for   all initial   points.   Moreover,   saddle   points   and   local   maxima   are   rendered   unstable,   thus   favoring   convergence   to   local   minimizers.  

Trust-region   methods   form   an   alternative   class   of   algorithms   that   combine   desirable   global   convergence   properties   with   a   local   superlinear   rate   of   convergence.   In   addition   to   providing   good   global   convergence,   trust-region   methods   also   provide   a   framework   to   relax   the   computational   burden   of   the   plain   Newton   method   when   the   iterates   are   too   far   away   from   the   solution   for   fast   local   convergence   to   set   in.   This   is   particularly   important   in   the   development   of   optimization   algorithms   on   matrix   manifolds,   where   the   inverse   Hessian   computation   can   involve   solving   relatively   complex   matrix   equations.  

Trust-region   methods   can   be   understood   as   an   enhancement   of   Newton’s   method.   To   this   end,   however,   we   need   to   consider   this   method   from   another   viewpoint:   instead   of   looking   for   an   update   vector   along   which   the   derivative   of   grad   f   is   equal   to   − grad   f ( x k ),   it   is   equivalent   to   think   of   Newton’s   method   (in   R n )   as   the   algorithm   that   selects   the   new   iterate   x k +1 to   be   the   critical   point   of   the   quadratic   Taylor   expansion   of   the   cost   function   f   about   x k .  

To this end, the chapter begins with a discussion of generalized quadratic models on manifolds (Section 7.1). Here again, a key role is played by the concept of retraction, which provides a way to pull back the cost function on the manifold to a cost function on the tangent space. It is therefore sufficient to define quadratic models on abstract vector spaces and to understand how these models correspond to the real-valued function on the manifold M .

[Page 150]

M Once   the   notion   of   a   quadratic   model   is   established,   a   trust-region   algorithm   can   be   deﬁned   on   a   manifold   (Section   7.2).   It   is   less   straightforward   to   show   that   all   the   desirable   convergence   properties   of   classical   trust-region   methods   in   R n still   hold,   mutatis mutandis ,   for   their   manifold   generalizations.   The   diﬃculty   comes   from   the   fact   that   trust-region   methods   on   manifolds   do   not   work   with   a   single   cost   function   but   rather   with   a   succession   of   cost   functions   whose   domains   are   diﬀerent   tangent   spaces.   The   issue   of   computing   an   (approximate   but   suﬃciently   accurate)   solution   of   the   trustregion   subproblems   is   discussed   in   Section   7.3.   The   convergence   analysis   is   carried   out   in   Section   7.4.   The   chapter   is   concluded   in   Section   7.5   with   a   “checklist”   of   steps   one   has   to   go   through   in   order   to   turn   the   abstract   geometric   trust-region   schemes   into   practical   numerical   algorithms   on   a   given   manifold   for   a   given   cost   function;   this   checklist   is   illustrated   for   several   examples   related   to   Rayleigh   quotient   minimization.  

# 7.1 MODELS

Several   classical   optimization   schemes   rely   on   successive   local   minimization   of   quadratic   models   of   the   cost   function.   In   this   section,   we   review   the   notion   of   quadratic   models   in   R n and   in   general   vector   spaces.   Then,   making   use   of   retractions,   we   extend   the   concept   to   Riemannian   manifolds.  

# 7.1.1 Models in R n

The   fundamental   mathematical   tool   that   justiﬁes   the   use   of   local   models   is   Taylor’s   theorem   (see   Appendix   A.6).   In   particular,   we   have   the   following   results.  

Proposition 7.1.1 Let f   be a smooth real-valued function on R n , x   ∈   R n , U   a bounded neighborhood of x , and H   any symmetric matrix. Then there exists c >   0   such that, for all ( x   +   h )   ∈ U , f ( x   +   h )     f ( x ) +   ∂f ( x ) h   + h T Hh     c h 1 2 ,  

∥ ∥ f ( x + h ) -( f ( x ) + ∂f ( x ) h + h T Hh )∥ ∥ ≤ c ‖ h ‖ 1 2 2 , where ∂f ( x ) := ( ∂ 1 f ( x ) , . . . , ∂ n f ( x )) . If, moreover, H i,j = ∂ i ∂ j f ( x ) , then there exists c > 0 such  that, for all ( x + h ) ∈ U ,

$$
\text {re exists} \, c > 0 \text { such that, for all } ( x + h ) \in \mathcal { U } , \\ \| f ( x + h ) - ( f ( x ) + \partial f ( x ) h + \frac { 1 } { 2 } h ^ { T } H h ) \| \leq c \| h \| ^ { 3 } . \\ \\ \text {Models in general Euclidean spaces}
$$

# 7.1.2 Models in general Euclidean spaces

The   ﬁrst   step   towards   deﬁning   quadratic   models   on   Riemannian   manifolds   is   to   generalize   the   above   results   to   (abstract)   Euclidean   spaces,   i.e.,   ﬁnitedimensional   vector   spaces   endowed   with   an   inner   product    · ,   ·  .   This   is   readily   done   using   the   results   in   Appendix   A.6.   (Note   that   Euclidean   spaces  

[Page 151]

[Page 152]

[Page 153]

[Page 154]

[Page 155]

[Page 156]

[Page 157]

[Page 158]

[Page 159]

[Page 160]

[Page 161]

[Page 162]

[Page 163]

[Page 164]

[Page 165]

[Page 166]

[Page 167]

[Page 168]

[Page 169]

[Page 170]

[Page 171]

[Page 172]

[Page 173]

[Page 174]

[Page 175]

[Page 176]

[Page 177]

[Page 178]

[Page 179]

[Page 180]

[Page 181]

[Page 182]

[Page 183]

[Page 184]

[Page 185]

[Page 186]

[Page 187]

[Page 188]

[Page 189]

[Page 190]

[Page 191]

[Page 192]

[Page 193]

[Page 194]

[Page 195]

[Page 196]

[Page 197]

[Page 198]

[Page 199]

[Page 200]

[Page 201]

[Page 202]

[Page 203]

[Page 204]

[Page 205]

[Page 206]

[Page 207]

[Page 208]

[Page 209]

[Page 210]

[Page 211]

[Page 212]

[Page 213]

[Page 214]

[Page 215]

[Page 216]

[Page 217]

[Page 218]

[Page 219]

[Page 220]

[Page 221]

[Page 222]

[Page 223]

[Page 224]

[Page 225]

[Page 226]

[Page 227]

[Page 228]

[Page 229]

[Page 230]

[Page 231]

[Page 232]

[Page 233]

[Page 234]

[Page 235]

[Page 236]

[Page 237]

