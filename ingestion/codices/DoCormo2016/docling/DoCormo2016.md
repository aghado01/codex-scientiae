[Page 1]

# DIFFERENTIAL GEOMETRY OF CURVES & SURFACES

REVISED & UPDATEDSECONDEDITION

MANFREDO P DO CARMO

[Page 2]

[Page 3]

# DIFFERENTIAL GEOMETRY OF CURVES & SURFACES

[Page 4]

[Page 5]

# DIFFERENTIAL GEOMETRY OF CURVES & SURFACES

# Revised & Updated   SECOND EDITION

# Manfredo P. do Carmo

Instituto Nacional de Matemática Pura e Aplicada (IMPA) Rio de Janeiro, Brazil

DOVER PUBLICATIONS, INC. Mineola, New York

[Page 6]

# Bibliographical Note

  Differential Geometry of Curves and Surfaces: Revised & Updated Second Edition is a revised, corrected, and updated second edition of the work originally published in 1976 by Prentice-Hall, Inc., Englewood Cliffs, New Jersey. The author has also provided a new Preface for this edition.

International Standard Book Number ISBN-13: 978-0-486-80699-0 ISBN-10: 0-486-80699-5

Manufactured in the United States by LSC Communications 80699501 2016 www.doverpublications.com

[Page 7]

[Page 8]

[Page 9]

# Contents

# Preface to the Second Edition xi Preface xiii

# Some Remarks on Using this Book xv

# 1. Curves 1

- 1-1 Introduction 1
- 1-2 Parametrized Curves 2
- 1-3 Regular Curves; Arc Length 6
- 1-4 The Vector Product in R 3 12
- 1-5 The Local Theory of Curves Parametrized by Arc Length 17
- 1-6 The Local Canonical Form 28
- 1-7 Global Properties of Plane Curves 31


# 2. Regular Surfaces 53

- 2-1 Introduction 53
- 2-2 Regular Surfaces; Inverse Images of Regular Values 54
- 2-3 Change of Parameters; Differentiable Functions on Surface 72
- 2-4 The Tangent Plane; The Differential of a Map 85
- 2-5 The First Fundamental Form; Area 94
- 2-6 Orientation of Surfaces 105
- 2-7 A Characterization of Compact Orientable Surfaces 112
- 2-8 A Geometric Deﬁnition of Area 116


Appendix: A Brief Review of Continuity and Differentiability 120

[Page 10]

|3.|The Geometry of the Gauss Map 136|
|---|---|
|3-1|Introduction 136|
|3-2|The Definition of the Gauss Map and Its Fundamental Properties 137|
|3-3|The Gauss Map in Local Coordinates 155|
|3-4|Vector Fields 178|
|3-5|Ruled Surfaces and Minimal Surfaces 191|
| |Appendix: Self-Adjoint Linear Maps and Quadratic Forms 217|
|4.|The Intrinsic Geometry of Surfaces 220|
|4-1|Introduction 220|
|4-2|Isometries; Conformal Maps 221|
|4-3|The Gauss Theorem and the Equations of Compatibility 235|
|4-4|Parallel Transport. Geodesics. 241|
|4-5|The Gauss-Bonnet Theorem and Its Applications 267|
|4-6|The Exponential Map. Geodesic Polar Coordinates 287|
|4-7|Further Properties of Geodesics; Convex Neighborhoods 302|
| |Appendix: Proofs of the Fundamental Theorems of the Local Theory of Curves and Surfaces 315|
|5.|Global Differential Geometry 321|
|5-1|Introduction 321|
|5-2|The Rigidity of the Sphere 323|
|5-3|Complete Surfaces. Theorem of Hopf-Rinow 331|
|5-4|First and Second Variations of Arc Length; Bonnet's Theorem 344|
|5-5|Jacobi Fields and Conjugate Points 363|
|5-6|Covering Spaces; The Theorems of Hadamard 377|
|5-7|Global Theorems for Curves: The Fary-Milnor Theorem 396|
|5-8|Surfaces of Zero Gaussian Curvature 414|
|5-9|Jacobi's Theorems 421|
|5-10|Abstract Surfaces; Further Generalizations 430|
|5-11|Hilbert's Theorem 451|
| |Appendix: Point-Set Topology of Euclidean Spaces 460|
| |Bibliography and Comments 475|
| |Hints and Answers 478|
| |Index 503|


[Page 11]

In this edition, I have included many of the corrections and suggestions kindly senttomebythosewhohaveusedthebook. Forseveralreasonsitisimpossible tomentionthenamesofallthepeoplewhogenerouslydonatedtheirtimedoing that. Here I would like to express my deep appreciation and thank them all.

Thanks are also due to John Grafton, Senior Acquisitions Editor at Dover Publications, who believed that the book was still valuable and included in the text all of the changes I had in mind, and to the editor, James Miller, for his patience with my frequent requests.

As usual, my wife, Leny A. Cavalcante, participated in the project as if it was a work of her own; and I might say that without her this volume would not exist.

Finally, I would like to thank my son, Manfredo Jr., for helping me with several ﬁgures in this edition.

Manfredo P. do Carmo September 20, 2016

[Page 12]

[Page 13]

This book is an introduction to the differential geometry of curves and surfaces, both in its local and global aspects. The presentation differs from the traditional ones by a more extensive use of elementary linear algebra and by a certain emphasis placed on basic geometrical facts, rather than on machinery or random details.

We have tried to build each chapter of the book around some simple and fundamental idea. Thus, Chapter 2 develops around the concept of a regular surface in R 3 ; when this concept is properly developed, it is probably the best model for differentiable manifolds. Chapter 3 is built on the Gauss normal map and contains a large amount of the local geometry of surfaces in R 3 . Chapter 4 uniﬁes the intrinsic geometry of surfaces around the concept of covariant derivative; again, our purpose was to prepare the reader for the basic notion of connection in Riemannian geometry. Finally, in Chapter 5, we use the ﬁrst and second variations of arc length to derive some global properties of surfaces. Near the end of Cbapter 5 (Sec. 5-10), we show how questions on surface theory, and the experience of Chapters 2 and 4, lead naturally to the consideration of differentiable manifolds and Riemannian metrics.

To maintain the proper balance between ideas and facts, we have presented a large number of examples that are computed in detail. Furthermore, a reasonable supply of exercises is provided. Some factual material of classical differential geometry found its place in these exercises. Hints or answers are given for the exercises that are starred.

The prerequisites for reading this book are linear algebra and calculus. From linear algebra, only the most basic concepts are needed, and a standard undergraduate course on the subject should suffice. From calculus, a certain familiarity with calculus of several variables (including the statement of the implicit function theorem) is expected. For the reader's convenience, we have tried to restrict our references to R. C. Buck, Advanced Calculus , New York: McGraw-Hill, 1965 (quoted as Buck, Advanced Calculus ). A certain knowledge of differential equations will be useful but it is not required.

[Page 14]

This book is a free translation, with additional material, of a book and a set of notes, both published originally in Portuguese. Were it not for the enthusiasm and enormous help of Blaine Lawson, this book would not have comeintoEnglish.AlargepartofthetranslationwasdonebyLenyCavalcante. I am also indebted to my colleagues and students at IMPA for their comments and support. In particular, Elon Lima read part of the Portuguese version and made valuable comments.

Robert Gardner, Jürgen Kern, Blaine Lawson, and Nolan Wallach read criticallytheEnglishmanuscriptandhelpedmetoavoidseveralmistakes, both in English and Mathematics. Roy Ogawa prepared the computer programs for some beautiful drawings that appear in the book (Figs. 1-3, 1-8, 1-9, 1-10, 1-11, 3-45 and 4-4). Jerry Kazdan devoted his time generously and literally offered hundreds of suggestions for the improvement of the manuscript. This ﬁnal form of the book has beneﬁted greatly from his advice. To all these people—and to Arthur Wester, Editor of Mathematics at Prentice-Hall, and Wilson Góes at IMPA—I extend my sincere thanks.

Rio de Janeiro Manfredo P. do Carmo

[Page 15]

# Some Remarks on Using This Book

We tried to prepare this book so it could be used in more than one type of differential geometry course. Each chapter starts with an introduction that describes the material in the chapter and explains how this material will be used later in the book. For the reader’s convenience, we have used footnotes to point out the sections (or parts thereof) that can be omitted on a ﬁrst reading.

Although there is enough material in the book for a full-year course (or a topics course), we tried to make the book suitable for a ﬁrst course on differential geometry for students with some background in linear algebra and advanced calculus.

For a short one-quarter course (10 weeks), we suggest the use of the following material: Chapter 1: Secs. 1-2, 1-3, 1-4, 1-5 and one topic of Sec. 1-7—2 weeks. Chapter 2: Secs. 2-2 and 2-3 (omit the proofs), Secs. 2-4 and 2-5—3 weeks. Chapter 3: Secs. 3-2 and 3-3—2 weeks. Chapter 4: Secs. 4-2 (omit conformal maps and Exercises 4, 13–18, 20), 4-3 (up to Gauss theorema egregium), 4-4 (u p to Prop. 4; omit Exercises 12, 13, 16, 18–21), 4-5 (up to the local Gauss-Bonnet theorem; include applications (b) and (f))3 weeks.

The 10-week program above is on a pretty tight schedule. A more relaxed alternativeistoallowmoretimefortheﬁrstthreechaptersandtopresentsurvey lectures, on the last week of the course, on geodesics, the Gauss theorema egregium, and the Gauss-Bonnet theorem (geodesics can then be deﬁned as curves whose osculating planes contain the normals to the surface).

[Page 16]

Inaone-semestercourse, theﬁrstalternativecouldbetaughtmoreleisurely and the instructor could probably include additional material (for instance, Secs. 5-2 and 5-10 (partially), or Secs. 4-6, 5-3 and 5-4).

Please also note that an asterisk attached to an exercise does not mean the exercise is either easy or hard. It only means that a solution or hint is provided at the end of the book. Second, we have used for parametrization a bold-faced x and that might become clumsy when writing on the blackboard. Thus we have reserved the capital X as a suggested replacement.

Where letter symbols that would normally be italic appear in italic context, the letter symbols are set in roman. This has been done to distinguish these symbols from the surrounding text.

[Page 17]

# 1 Curves

# 1-1. Introduction

The differential geometry of curves and surfaces has two aspects. One, which may be called classical differential geometry, started with the beginnings of calculus. Roughly speaking, classical differential geometry is the study of local properties of curves and surfaces. By local properties we mean those properties which depend only on the behavior of the curve or surface in the neighborhood of a point. The methods which have shown themselves to be adequate in the study of such properties are the methods of differential calculus. Because of this, the curves and surfaces considered in differential geometry will be defined by functions which can be differentiated a certain number of times.

The other aspect is the so-called global differential geometry. Here one studies the influence of the local properties on the behavior of the entire curve or surface. We shall come back to this aspect of differential geometry later in the book.

Perhaps the most interesting and representative part of classical differential geometry is the study of surfaces. However, some local properties of curves appear naturally while studying surfaces. We shall therefore use this first chapter for a brief treatment of curves.

The chapter has been organized in such a way that a reader interested mostly in surfaces can read only Sees. 1-2 through 1-5. Sections 1-2 through 1-4 contain essentially introductory material (parametrized curves, arc length, vector product), which will probably be known from other courses and is included here for completeness. Section 1-5 is the heart of the chapter and

[Page 18]

# 1-2. Parametrized Curves

We denote by R 3 the set of triples (x,y,z) of real numbers. Our goal is to characterize certain subsets of R 3 (to be called curves) that are, in a certain sense, one-dimensional and to which the methods of differential calculus can be applied. A natural way of deﬁning such subsets is through differentiable functions. We say that a real function of a real variable is differentiable (or smooth ) if it has, at all points, derivatives of all orders (which are automatically continuous). A ﬁrst deﬁnition of curve, not entirely satisfactory but sufﬁcient for the purposes of this chapter, is the following.

DEFINITION. A parametrized differentiable curve is a differentiable map α : I → R 3 of an open interval I = ( a , b ) of the real line R into R 3 . †

The word differentiable in this deﬁnition means that α is a correspondence which maps each t ∈ I into a point α(t) = (x(t),y(t),z(t)) ∈ R 3 in such a waythatthefunctions x(t),y(t),z(t) aredifferentiable. Thevariable t iscalled the parameter of the curve. The word interval is taken in a generalized sense, so that we do not exclude the cases a = −∞ , b = +∞ . If we denote by x ′ (t) the ﬁrst derivative of x at the point t and use similar

notations for the functions y and z , the vector (x ′ (t),y ′ (t),z ′ (t)) = α ′ (t) ∈ R 3 is called the tangent vector (or velocity vector ) of the curve α at t . The image set α(I) ⊂ R 3 is called the trace of α . As illustrated by Example 5 below, one should carefully distinguish a parametrized curve, which is a map, from its trace, which is a subset of R 3 .

A warning about terminology. Many people use the term “inﬁnitely differentiable” for functions which have derivatives of all orders and reserve the word “differentiable” to mean that only the existence of the ﬁrst derivative is required. We shall not follow this usage.

Example 1. The parametrized differentiable curve given by

$$
\alpha ( t ) & = ( a \cos t , a \sin t , b t ) , \quad t \in R , \\ \vdots _ { \ } p ^ { 2 } _ { t } \, \dots \, \vdots _ { t } & = ( a \cos t , a \sin t , b t ) , \quad t \in R ,
$$

has as its trace in R 3 a helix of pitch 2 πb on the cylinder x 2 + y 2 = a 2 . The parameter t here measures the angle which the x axis makes with the line joining the origin 0 to the projection of the point α(t) over the xy plane (see Fig. 1-1).

†In italic context, letter symbols will not be italicized so they will be clearly distinguished from the surrounding text.

[Page 19]

z

![In the diagram, we can see a cylinder with a spiral. Inside the cylinder, we can see a line labeled as a(n). We can also see a line labeled as x and a line labeled as y.](<images/imageFile2.png>)

(

)

α´

t

(

)

α

t

0

y

t

x

Figure 1-1

y

![image 3](<images/imageFile3.png>)

x

0

Figure 1-2

Example 2. The map α : R → R 2 given by α(t) = (t 3 ,t 2 ) , t ∈ R , is a parametrized differentiable curve which has Fig. 1-2 as its trace. Notice that α ′ ( 0 ) = ( 0 , 0 ) ; that is, the velocity vector is zero for t = 0.

Example 3. The map α : R → R 2 given by α(t) = (t 3 − 4 t,t 2 − 4 ) , t ∈ R , is a parametrized differentiable curve (see Fig. 1-3). Notice that α( 2 ) = α( − 2 ) = ( 0 , 0 ) ; that is, the map α is not one-to-one.

y

![The image depicts a diagram with two circles labeled as Figure 1-3 and Figure 1-4. Both circles are centered at the origin (0, 0) and are tangent to each other at points labeled as \( x \) and \( y \). The tangent line at point \( x \) is drawn from the center of the circle to the line segment connecting the center of the circle to the point \( y \). The tangent line at point \( y \) is drawn from the center of the circle to the line segment connecting the center of the circle to the point \( x \). The diagram includes two labeled points, \( x \) and \( y \), which are the points of tangency between the two circles. The line segment connecting these points is drawn from the center of the circle to the point \( x \). This line segment is tangent to both circles at point \( x \) and point \](<images/imageFile4.png>)

x

0

y

x

0

Figure 1-3

Figure 1-4

Example 4. The map α : R → R 2 given by α(t) = (t, | t | ) , t ∈ R , is not a parametrized differentiable curve, since | t | is not differentiable at t = 0 (Fig. 1-4).

[Page 20]

# Example 5. The two distinct parametrized curves

$$
\alpha ( t ) & = ( \cos t , \sin t ) , \\ \beta ( t ) & = ( \cos 2 t , \sin 2 t ) ,
$$

$$
\beta ( t ) = ( \cos 2 t , \sin 2 t ) ,
$$

where t ∈ ( 0 − ǫ, 2 π + ǫ) , ǫ > 0, have the same trace, namely, the circle x 2 + y 2 = 1. Notice that the velocity vector of the second curve is the double of the ﬁrst one (Fig. 1-5).

y

![In this image, we can see a diagram with a circle and some lines. There are two points labeled as A and B.](<images/imageFile5.png>)

(

)

β´

t

x

0

(

)

α´

t

Figure 1-5

We shall now recall brieﬂy some properties of the inner (or dot) product of vectors in R 3 . Let u = (u 1 ,u 2 ,u 3 ) ∈ R 3 and deﬁne its norm (or length ) by

$$
| u | = \sqrt { u _ { 1 } ^ { 2 } + u _ { 2 } ^ { 2 } + u _ { 3 } ^ { 2 } } . \\
$$

Geometrically, | u | is the distance from the point (u 1 ,u 2 ,u 3 ) to the origin 0 = ( 0 , 0 , 0 ) . Now, let u = (u 1 ,u 2 ,u 3 ) and v = (v 1 ,v 2 ,v 3 ) belong to R 3 , and let θ , 0 ≤ θ ≤ π , be the angle formed by the segments 0 u and 0 v . The inner product u · v is deﬁned by (Fig. 1-6)

$$
u \cdot v = | u | | v | \cos \theta .
$$

# The following properties hold:

1. Assume that u and v are nonzero vectors. Then u · v = 0 if and only if u is orthogonal to v .

u · v = v · u .

λ(u · v) = λu · v = u · λv .

u · (v + w) = u · v + u · w .

A useful expression for the inner product can be obtained as follows. Let e 1 = ( 1 , 0 , 0 ) , e 2 = ( 0 , 1 , 0 ) , and e 3 = ( 0 , 0 , 1 ) . It is easily checked

[Page 21]

z

![The image depicts a geometric diagram involving a triangle and a right triangle. The diagram is labeled as V and V', where V is the hypotenuse of the right triangle and V' is the opposite side of the triangle. The diagram is labeled as V and V', where V is the hypotenuse of the right triangle and V' is the opposite side. The diagram consists of two triangles, labeled as V and V'. The vertices of the triangles are labeled as V and V'. The sides of the triangles are labeled as V and V'. The sides of the triangles are labeled as V and V'. The diagram includes a line segment labeled as v and a line segment labeled as v'. The line segment v is a line segment that connects the vertices of the triangles V and](<images/imageFile6.png>)

v

u

cos θ

θ

v

θ

u

3

0

y

v

3

v

u

1

1

v

2

u

2

x

Figure 1-6

$$
u = u _ { 1 } e _ { 1 } + u _ { 2 } e _ { 2 } + u _ { 3 } e _ { 3 } , \quad v = v _ { 1 } e _ { 1 } + v _ { 2 } e _ { 2 } + v _ { 3 } e _ { 3 } ,
$$

and using properties 2 to 4, we obtain

$$
u \cdot v = u _ { 1 } v _ { 1 } + u _ { 2 } v _ { 2 } + u _ { 3 } v _ { 3 } .
$$

From the above expression it follows that if u(t) and v(t) , t ∈ I , are differentiable curves, then u(t) · v(t) is a differentiable function, and

$$
\frac { d } { d t } ( u ( t ) \cdot v ( t ) ) = u ^ { \prime } ( t ) \cdot v ( t ) + u ( t ) \cdot v ^ { \prime } ( t ) .
$$

# EXERCISES

1. Find a parametrized curve α(t) whose trace is the circle x 2 + y 2 = 1 such that α(t) runs clockwise around the circle with α( 0 ) = ( 0 , 1 ) . 2. Let α(t) be a parametrized curve which does not pass through the origin.

If α(t 0 ) is a point of the trace of α closest to the origin and α ′ (t 0 )  = 0, show that the position vector α(t 0 ) is orthogonal to α ′ (t 0 ) .

- 3. A parametrized curve α(t) has the property that its second derivative α ′′ (t) is identically zero. What can be said about α ?
- 4. Let α : I → R 3 be a parametrized curve and let v ∈ R 3 be a ﬁxed vector. Assume that α ′ (t) is orthogonal to v for all t ∈ I and that α( 0 ) is also orthogonal to v . Prove that α(t) is orthogonal to v for all t ∈ I .


[Page 22]

5. Let α : I → R 3 be a parametrized curve, with α ′ (t)  = 0 for all t ∈ I . Show that | α(t) | is a nonzero constant if and only if α(t) is orthogonal to α ′ (t) for all t ∈ I .

# 1-3. Regular Curves; Arc Length

Let α : I → R 3 be a parametrized differentiable curve. For each t ∈ I where α ′ (t)  = 0, there is a well-deﬁned straight line, which contains the point α(t) and the vector α ′ (t) . This line is called the tangent line to α at t . For the study of the differential geometry of a curve it is essential that there exists such a tangent line at every point. Therefore, we call any point t where α ′ (t) = 0 a singularpoint of α andrestrictourattentiontocurveswithoutsingularpoints. Notice that the point t = 0 in Example 2 of Sec. 1-2 is a singular point. 3

DEFINITION. A parametrized differentiable curve α : I → R is said to be regular if α ′ ( t )  = 0 for all t ∈ I .

From now on we shall consider only regular parametrized differentiable curves (and, for convenience, shall usually omit the word differentiable). 3

Given t 0 ∈ I , the arc length of a regular parametrized curve α : I → R , from the point t 0 , is by deﬁnition

$$
s ( t ) = \int _ { t _ { 0 } } ^ { t } | \alpha ^ { \prime } ( t ) | \, d t ,
$$

where

$$
| \alpha ^ { \prime } ( t ) | & = \sqrt { ( x ^ { \prime } ( t ) ) ^ { 2 } + ( y ^ { \prime } ( t ) ) ^ { 2 } + ( z ^ { \prime } ( t ) ) ^ { 2 } } \\ \intertext { h o f t h e v e c t o r } \alpha ^ { \prime } ( t ) . \text {  Since } \alpha ^ { \prime } ( t ) \neq 0 , \text { the arc } \text { le }
$$

is the length of the vector α ′ (t) . Since α ′ (t)  = 0, the arc length s is a differentiable function of t and ds / dt = | α ′ (t) | . In Exercise 8 we shall present a geometric justiﬁcation for the above

In Exercise 8 we shall present a geometric justification for the above definition of arc length.

It can happen that the parameter t is already the arc length measured from some point. In this case, ds / dt = 1 = | α ′ (t) | ; that is, the velocity vector has constant length equal to 1. Conversely, if | α ′ (t) | ≡ 1, then

$$
s = \int _ { t _ { 0 } } ^ { t } \, d t = t - t _ { 0 } ;
$$

i.e., t is the arc length of α measured from some point.

To simplify our exposition, we shall restrict ourselves to curves parametrized by arc length; we shall see later (see Sec. 1-5) that this restriction is not essential. In general, it is not necessary to mention the origin of the

[Page 23]

It is convenient to set still another convention. Given the curve α parametrized by arc length s ∈ (a,b) , we may consider the curve β deﬁned in ( − b, − a) by β( − s) = α(s) , which has the same trace as the ﬁrst one but is described in the opposite direction. We say, then, that these two curves differ by a change of orientation .

# EXERCISES

1. Show that the tangent lines to the regular parametrized curve α(t) = ( 3 t, 3 t 2 , 2 t 3 ) make a constant angle with the line y = 0, z = x . 2. Acircular disk of radius 1 in the plane xy rolls without slipping along the

x axis. The ﬁgure described by a point of the circumference of the disk is called a cycloid (Fig. 1-7).

y

![In this image, we can see a diagram with some lines and points.](<images/imageFile7.png>)

l

t

0

x

Figure 1-7. The cycloid.

*a. Obtain a parametrized curve α : R → R 2 the trace of which is the cycloid, and determine its singular points.

b. Compute the arc length of the cycloid corresponding to a complete rotation of the disk.

3. Let0 A = 2 a bethediameterofacircle S 1 and0 y and AV bethetangents to S 1 at 0 and A , respectively. Ahalf-line r is drawn from 0 which meets the circle S 1 at C and the line AV at B . On 0 B mark off the segment 0 p = CB . If we rotate r about 0, the point p will describe a curve called the cissoid of Diocles . By taking 0 A as the x axis and 0 Y as the y axis, prove that

a. The trace of

$$
\alpha ( t ) = \left ( \frac { 2 a t ^ { 2 } } { 1 + t ^ { 2 } } , \frac { 2 a t ^ { 3 } } { 1 + t ^ { 2 } } \right ) , \quad t \in R , \\ \intertext { s s o i d o f D i c l e s ( t = t \tan \theta \colon s e e $ F i g $ $ 1 $ 8 ) }
$$

[Page 24]

- b. The origin ( 0 , 0 ) is a singular point of the cissoid.
- c. As t → ∞ , α(t) approaches the line x = 2 a , and α ′ (t) → 0 , 2 a . Thus, as t → ∞ , the curve and its tangent approach the line x = 2 a ; we say that x = 2 a is an asymptote to the cissoid. Let : 0 2 be given by


Let α : ( 0 , π) → R 2 be given by

$$
\alpha ( t ) = \left ( \sin t , \cos t + \log \tan \frac { t } { 2 } \right ) , \\ \\ \log ( t ) = \left ( \sin ^ { 2 } t , \cos ^ { 2 } t + \log \tan ^ { 2 } \frac { t } { 2 } \right ) ,
$$

where t is the angle that the y axis makes with the vector α ′ (t) . The trace of α is called the tractrix (Fig. 1-9). Show that

![The image consists of a diagram with several lines and points. Here is a detailed description of the objects present in the image: 1. **Lines and Points**: - There are two lines labeled as **AB** and **BC**. - **AB** is a line with a point labeled as **A** and a point labeled as **B**. - **BC** is a line with a point labeled as **C** and a point labeled as **D**. - **AB** and **BC** are both parallel to each other. - **AB** is a line with a point labeled as **A** and a point labeled as **B**. - **BC** is a line with a point labeled as **C** and a point labeled as **D**. 2. **Angles and Lines**: - There are two angles labeled as **A** and **B**. - **A** is a straight angle with a point labeled as **A](<images/imageFile8.png>)

y

V

r

B

C

p

θ

0

x

2

a

A

1

S

Figure 1-8. The cissoid of Diocles.

![In this image, we can see a diagram. There are some lines and points.](<images/imageFile9.png>)

y

t

l

l

t

(

)

α

t

x

l

0

Figure 1-9. The tractrix.

α is a differentiable parametrized curve, regular except at t = π/ 2.

The length of the segment of the tangent of the tractrix between the point of tangency and the y axis is constantly equal to 1.

5. Let α : ( − 1 , +∞ ) → R 2 be given by

-+∞ →

$$
\alpha ( t ) = \left ( \frac { 3 a t } { 1 + t ^ { 3 } } , \frac { 3 a t ^ { 2 } } { 1 + t ^ { 3 } } \right ) .
$$

[Page 25]

Prove that:

For t = 0, α is tangent to the x axis.

As t →+∞ , α(t) → ( 0 , 0 ) and α ′ (t) → ( 0 , 0 ) .

Take the curve with the opposite orientation. Now, as t →-1, the curve and its tangent approach the line x + y + a = 0.

α it becomes symmetric relative to the line y = x is called the folium of Descartes (see Fig. 1-10).

![The diagram consists of a line segment labeled as \( \overline{a} \), which is perpendicular to a line segment \( \overline{b} \). The line segment \( \overline{a} \) is drawn from point \( \overline{b} \) to the point \( \overline{a} \).](<images/imageFile10.png>)

y

0

x

a

a

Figure 1-10. Folium of Descartes.

6. Let α(t) = (ae bt cos t,ae bt sin t) , t ∈ R , a and b constants, a > 0, b < 0, be a parametrized curve.

- a. Showthatas t → +∞ , α(t) approachestheorigin0, spiralingaround it (because of this, the trace of α is called the logarithmic spiral ; see Fig. 1-11).
- b. Show that α ′ (t) → ( 0 , 0 ) as t → +∞ and that


$$
\lim _ { t \to + \infty } \int _ { t _ { 0 } } ^ { t } | \alpha ^ { \prime } ( t ) | \, d t
$$

[Page 26]

y

![The image depicts a geometric figure with several key elements. Here is a detailed description of the image: ### Description of the Image: - **Title**: The image is titled Geometric Figures and is likely a diagram or illustration. - **Objects**: - **Circle**: A circle is present in the image. - **Points**: There are two points labeled as \( \begin{matrix}x y \\ z w \end{matrix}\). - **Points on the Circle**: There are two points labeled as \( \begin{matrix}x y \\ z w \end{matrix}\). - **Points on the Circle**: There are two points labeled as \( \begin{matrix}x y \\ z w \end{matrix}\). - **Points on the Circle**: There are two points labeled as \( \begin{matrix}x y \\ z w \end{](<images/imageFile11.png>)

t

x

Figure 1-11. Logarithmic spiral.

7. A map α : I → R 3 is called a curve of class C k if each of the coordinate functions in the expression α(t) = (x(t),y(t),z(t)) has continuous derivatives up to order k . If α is merely continuous, we say that α is of class C 0 . Acurve α is called simple if the map α is one-to-one. Thus, the curve in Example 3 of Sec. 1-2 is not simple. 3 0

Let α : I → R be a simple curve of class C . We say that α has a weak tangent at t = t 0 ∈ I if the line determined by α(t 0 + h) and α(t 0 ) has a limit position when h → 0. We say that α has a strong tangent at t = t 0 if the line determined by α(t 0 + h) and α(t 0 + k) has a limit position when h,k → 0. Show that a. 3 2 , , has a weak tangent but not a strong tangent at

α(t) = (t 3 , t 2 ) , t ∈ R , has a weak tangent but not a strong tangent at t = 0.

*b. If α : I → R 3 is of class C 1 and regular at t = t 0 , then it has a strong tangent at t = t 0 .

The curve given by

$$
\alpha ( t ) = \begin{cases} ( t ^ { 2 } , t ^ { 2 } ) , & t \geq 0 , \\ ( t ^ { 2 } , - t ^ { 2 } ) , & t \leq 0 , \end{cases} \\
$$

is of class C 1 but not of class C 2 . Draw a sketch of the curve and its tangent vectors.

*8. Let α : I → R 3 be a differentiable curve and let [ a,b ] ⊂ I be a closed interval. For every partition

$$
a = t _ { 0 } < t _ { 1 } < \cdots < t _ { n } = b
$$

[Page 27]

of [ a,b ], consider the sum   n i = 1 | α(t i ) − α(t i − 1 ) | = l(α,P) , where P stands for the given partition. The norm | P | of a partition P is deﬁned as

$$
| P | = \max ( t _ { i } - t _ { i - 1 } ) , i = 1 , \dots , n . \\
$$

Geometrically, l(α,P) is the length of a polygon inscribed in α( [ a,b ] ) with vertices in α(t i ) (see Fig. 1-12). The point of the exercise is to show that the arc length of α( [ a,b ] ) is, in some sense, a limit of lengths of inscribed polygons.

)

(

![In this image, we can see a diagram with a circle and some points.](<images/imageFile12.png>)

α

t

i

α

(

)

α

t

(

)

α

t

-1

n

0

(

)

α

t

)

(

α

t

(

)

2

α

t

1

n

Figure 1-12

Prove that given ǫ > 0 there exists δ > 0 such that if | P | < δ then b

$$
\left | \int _ { a } ^ { b } | \alpha ^ { \prime } ( t ) | \, d t - l ( \alpha , P ) \right | & < \epsilon . \\ R ^ { 3 } \, b e a c u r v e \, o f c l a s s \, C ^ { 0 } \, ( \text {cf. Exercise 7}). \\ \text {polygons, described in Exercise 8 to give}
$$

    a | | −   9. a. Let α : I → R 3 beacurveofclass C 0 (cf. Exercise7). Usetheapproximation by polygons described in Exercise 8 to give a reasonable deﬁnition of arc length of α .

b. ( A Nonrectiﬁable Curve. ) The following example shows that, with any reasonable deﬁnition, the arc length of a C 0 curve in a closed interval may be unbounded. Let α : [0 , 1] → R 2 be given as α(t) = (t,t sin (π/t)) if t  = 0, and α( 0 ) = ( 0 , 0 ) . Show, geometrically, that thearclengthoftheportionofthecurvecorrespondingto1 /(n + 1 ) ≤ t ≤ 1 /n is at least 2 /(n + 1 2 ) . Use this to show that the length of the curve in the interval 1 /N ≤ t ≤ 1 is greater than 2   N n = 1 1 /(n + 1 ) , and thus it tends to inﬁnity as N → ∞ . ( Straight Lines as Shortest. ) Let α : I R 3 be a parametrized curve. Let

( Straight Lines as Shortest. ) Let α : I → R 3 be a parametrized curve. Let [ a, b ] ⊂ I and set α(a) = p , α(b) = q .

Show that, for any constant vector v , | v | = 1,

$$
( q - p ) \cdot v = \int _ { a } ^ { b } \alpha ^ { \prime } ( t ) \cdot v \, d t \leq \int _ { a } ^ { b } | \alpha ^ { \prime } ( t ) | \, d t .
$$

[Page 28]

$$
b . \, \text { Set} \\ v = \frac { q - p } { | q - p | }
$$

and show that

$$
| \alpha ( b ) - \alpha ( a ) | \leq \int _ { a } ^ { b } | \alpha ^ { \prime } ( t ) | \, d t ;
$$

that is, the curve of shortest length from α(a) to α(b) is the straight line joining these points.

# 1-4. The Vector Product in R 3

In this section, we shall present some properties of the vector product in R 3 . They will be found useful in our later study of curves and surfaces.

It is convenient to begin by reviewing the notion of orientation of a vector space. Two ordered bases e = { e i } and f = { f i } , i = 1 ,...,n , of an n -dimensional vector space V have the same orientation if the matrix of change of basis has positive determinant. We denote this relation by e ∼ f . From elementary properties of determinants, it follows that e ∼ f is an equivalence relation; i.e., it satisﬁes

e ∼ e .

If e ∼ f , then f ∼ e .

If e ∼ f , f ∼ g , then e ∼ g .

V thus decomposed into equivalence classes (theelementsofagivenclassarerelatedby ∼ )whichbyproperty3aredisjoint. Since the determinant of a change of basis is either positive or negative, there are only two such classes.

Each of the equivalence classes determined by the above relation is called an orientation of V . Therefore, V has two orientations, and if we ﬁx one of them arbitrarily, the other one is called the opposite orientation. 3

In the case V = R , there exists a natural ordered basis e 1 = ( 1 , 0 , 0 ) , e 2 = ( 0 , 1 , 0 ) , e 3 = ( 0 , 0 , 1 ) , and we shall call the orientation corresponding to this basis the positive orientation of R 3 , the other one being the negative orientation (of course, this applies equally well to any R n ). We also say that a given ordered basis of R 3 is positive (or negative ) if it belongs to the positive (or negative) orientation of R 3 . Thus, the ordered basis e 1 ,e 3 ,e 2 is a negative basis, since the matrix which changes this basis into e 1 ,e 2 ,e 3 has determinant equal to − 1.

[Page 29]

We now come to the vector product. Let u,v ∈ R 3 . The vector product of u and v (in that order) is the unique vector u ∧ v ∈ R 3 characterized by

$$
( u \wedge v ) \cdot w = \det ( u , v , w ) \quad \text {for all } v \in R ^ { 3 } .
$$

Here det (u,v,w) means that if we express u,v , and w in the natural basis { e i } ,

$$
u & = \sum u _ { i } e _ { i } , \quad v = \sum v _ { i } e _ { i } , \\ w & = \sum w _ { i } e _ { i } , \quad i = 1 , 2 , 3 ,
$$

then

$$
\det ( u , v , w ) = \begin{vmatrix} u _ { 1 } & u _ { 2 } & u _ { 3 } \\ v _ { 1 } & v _ { 2 } & v _ { 3 } \\ w _ { 1 } & w _ { 2 } & w _ { 3 } \end{vmatrix} , \\ \text {es the determinant of the matrix } ( a _ { i j } ) . \text { It is}
$$

  w 1 w 2 w 3   where | a ij | denotes the determinant of the matrix (a ij ) . It is immediate from the deﬁnition that

$$
u \wedge v = \begin{vmatrix} u _ { 2 } & u _ { 3 } & \\ v _ { 2 } & v _ { 3 } & \end{vmatrix} e _ { 1 } - \begin{vmatrix} u _ { 1 } & u _ { 3 } \\ v _ { 1 } & v _ { 3 } \end{vmatrix} e _ { 2 } + \begin{vmatrix} u _ { 1 } & u _ { 2 } \\ v _ { 1 } & v _ { 2 } \end{vmatrix} e _ { 3 } . \\ \intertext { R e m a r k . It is also very frequent to write u \wedge v as u \times v and refer to it as }
$$

∧ =   v 2 v 3   −   v 1 v 3   +   v 1 v 2   Remark. It is also very frequent to write u ∧ v as u × v and refer to it as the cross product .

The following properties can easily be checked (actually they just express the usual properties of determinants):

u ∧ v = -v ∧ u (anticommutativity).

u ∧ v depends linearly on u and v ; i.e., for any real numbers a, b , we have

$$
( a u + b w ) \wedge v = a u \wedge v + b w \wedge v .
$$

3. u ∧ v = 0 if and only if u and v are linearly dependent.

u ∧ v = u v

$$
4 . \ ( u \wedge v ) \cdot u & = 0 , \, ( u \wedge v ) \cdot v = 0 . \\ \\ U _ { \ } f \subset \mathbb { I } _ { 1 } & \quad \subset \mathbb { I } _ { 2 }
$$

It follows from property 4 that the vector product u ∧ v  = 0 is normal to a plane generated by u and v . To give a geometric interpretation of its norm and its direction, we proceed as follows. 2

First, we observe that (u ∧ v) · (u ∧ v) = | u ∧ v | > 0. This means that the determinant of the vectors u,v,u ∧ v is positive; that is, { u,v,u ∧ v } is a positive basis.

[Page 30]

Next, we prove the relation

$$
( u \wedge v ) \cdot ( x \wedge y ) & = \begin{vmatrix} u \cdot x & v \cdot x \\ u \cdot y & v \cdot y \end{vmatrix} , \\ \intertext { a r e \, a r b i t r a y \, v e c tors . \, \ } \intertext { r o w } \intertext { a r i n g r i n g } \intertext { o r $ u $ t h e r $ v $ e x } \intertext { s u p f i c s } \intertext { o f t h e q n e s }
$$

∧ · ∧ =   u · y v · y   where u,v,x,y are arbitrary vectors. This can easily be done by observing that both sides are linear in u,v,x,y . Thus, it sufﬁces to check that

$$
( e _ { i } \wedge e _ { j } ) \cdot ( e _ { k } \wedge e _ { l } ) & = \begin{vmatrix} e _ { i } \cdot e _ { k } & e _ { j } \cdot e _ { k } \\ e _ { i } \cdot e _ { l } & e _ { j } \cdot e _ { l } \end{vmatrix} \\ l = 1 , 2 , 3 . \text { This is a straightforward verification.}
$$

∧ · ∧ =   e i · e l e j · e l   for all i,j,k,l = 1 , 2 , 3. This is a straightforward veriﬁcation. It follows that

$$
| u \wedge v | ^ { 2 } = \begin{vmatrix} u \cdot u & u \cdot v \\ u \cdot v & v \cdot v \end{vmatrix} = | u | ^ { 2 } | v | ^ { 2 } ( 1 - \cos ^ { 2 } \theta ) = A ^ { 2 } , \\ \intertext { h e r $ \theta $ i s the angle of u and v , and A $ i s the area of the parallelogram generate } \intertext { v e q n o v i d e v }
$$

| ∧ | =   u · v v · v   = | | | | − = where θ istheangleof u and v , and A istheareaoftheparallelogramgenerated by u and v .

In short, the vector product of u and v is a vector u ∧ v perpendicular to a plane spanned by u and v , with a norm equal to the area of the parallelogram generated by u and v and a direction such that { u,v,u ∧ v } is a positive basis (Fig. 1-13).

![In the image there is a diagram with a right triangle and a line. The diagram is labeled as V sin θ.](<images/imageFile13.png>)

u ^ v

v

sin

v

θ

π

2

θ

u

Figure 1-13

The vector product is not associative. In fact, we have the following identity:

$$
( u \wedge v ) \wedge w = ( u \cdot w ) v - ( v \cdot w ) u ,
$$

which can be proved as follows. First we observe that both sides are linear in u,v,w ; thus, the identity will be true if it holds for all basis vectors. This last veriﬁcation is, however, straightforward; for instance,

[Page 31]

$$
( e _ { 1 } \wedge e _ { 2 } ) \wedge e _ { 1 } = e _ { 2 } = ( e _ { 1 } \cdot e _ { 1 } ) e _ { 2 } - ( e _ { 2 } \cdot e _ { 1 } ) e _ { 1 } .
$$

Finally, let u(t) = (u 1 (t),u 2 (t),u 3 (t)) and v(t) = (v 1 (t),v 2 (t),v 3 (t)) be differentiable maps from the interval (a,b) to R 3 , t ∈ (a,b) . It follows immediately from Eq. (1) that u(t) ∧ v(t) is also differentiable and that

$$
\frac { d } { d t } ( u ( t ) \wedge v ( t ) ) = \frac { d u } { d t } \wedge v ( t ) + u ( t ) \wedge \frac { d v } { d t } .
$$

V ector products appear naturally in many geometrical constructions.Actually, most of the geometry of planes and lines in R 3 can be neatly expressed in terms of vector products and determinants. We shall review some of this material in the following exercises.

# EXERCISES

1. Check whether the following bases are positive:

The basis { ( 1 , 3 ), ( 4 , 2 ) } in R 2 .

The basis { ( 1 , 3 , 5 ), ( 2 , 3 , 7 ), ( 4 , 8 , 3 ) } in R 3 .

- *2. P R ax + by + cz + d = 0. Show that the vector v = (a,b,c) is perpendicular to the plane and that | d | / √ a 2 + b 2 + c 2 measures the distance from the plane to the origin ( 0 , 0 , 0 ) .
- *3. Determine the angle of intersection of the two planes 5 x + 3 y + 2 z − 4 = 0 and 3 x + 4 y − 7 z = 0. *4. Given two planes a x b y c z d 0, i 1 , 2, prove that a


i + i + i + i = = necessary and sufﬁcient condition for them to be parallel is

$$
\frac { a _ { 1 } } { a _ { 2 } } = \frac { b _ { 1 } } { b _ { 2 } } = \frac { c _ { 1 } } { c _ { 2 } } ,
$$

where the convention is made that if a denominator is zero, the corresponding numerator is also zero (we say that two planes are parallel if they either coincide or do not intersect).

5. Showthatanequationofaplanepassingthroughthreenoncolinearpoints p 1 = (x 1 ,y 1 ,z 1 ) , p 2 = (x 2 ,y 2 ,z 2 ) , p 3 = (x 3 ,y 3 ,z 3 ) is given by

$$
( p - p _ { 1 } ) \wedge ( p - p _ { 2 } ) \cdot ( p - p _ { 3 } ) = 0 ,
$$

where p = (x,y,z) is an arbitrary point of the plane and p − p 1 , for instance, means the vector (x − x 1 ,y − y 1 ,z − z 1 ) .

[Page 32]

*6. Given two nonparallel planes a i x + b i y + c i z + d i = 0, i = 1 , 2, show that their line of intersection may be parametrized as

$$
x - x _ { 0 } = u _ { 1 } t , \ \ y - y _ { 0 } = u _ { 2 } t , \ \ z - z _ { 0 } = u _ { 3 } t ,
$$

where (x 0 ,y 0 ,z 0 ) belongs to the intersection and u = (u 1 ,u 2 ,u 3 ) is the vector product u = v 1 ∧ v 2 , v i = (a i ,b i ,c i ) , i = 1 , 2. Prove that a necessary and sufﬁcient condition for the plane

*7. Prove that a necessary and sufficient condition for the plane

$$
a x + b y + c z + d = 0
$$

and the line x − x 0 = u 1 t , y − y 0 = u 2 t , z − z 0 = u 3 t to be parallel is

$$
a u _ { 1 } + b u _ { 2 } + c u _ { 3 } = 0 .
$$

*8. Prove that the distance ρ between the nonparallel lines

$$
x - x _ { 0 } & = u _ { 1 } t , \quad y - y _ { 0 } = u _ { 2 } t , \quad z - z _ { 0 } = u _ { 3 } t , \\ x - x _ { 1 } & = v _ { 1 } t , \quad y - y _ { 1 } = v _ { 2 } t , \quad z - z _ { 1 } = v _ { 3 } t
$$

is given by

$$
\rho = \frac { | ( u \wedge v ) \cdot r | } { | u \wedge v | } , \\
$$

where u = (u 1 ,u 2 ,u 3 ), v = (v 1 ,v 2 ,v 3 ),r = (x 0 − x 1 ,y 0 − y 1 ,z 0 − z 1 ) . Determine the angle of intersection of the plane 3 x 4 y 7 z 8

Determine the angle of intersection of the plane 3 x + 4 y + 7 z + 8 = 0 and the line x -2 = 3 t , y -3 = 5 t , z -5 = 9 t .

area A of a parallelogram generated by two linearly independent vectors u,v ∈ R 2 . To do this, let { e i } , i = 1 , 2, be the natural ordered basis of R 2 , and write u = u 1 e 1 + u 2 e 2 , v = v 1 e 1 + v 2 e 2 . Observe the matrix relation

$$
\begin{pmatrix} u \cdot u & u \cdot v \\ v \cdot u & v \cdot v \end{pmatrix} = \begin{pmatrix} u _ { 1 } & u _ { 2 } \\ v _ { 1 } & v _ { 2 } \end{pmatrix} \begin{pmatrix} u _ { 1 } & v _ { 1 } \\ u _ { 2 } & v _ { 2 } \end{pmatrix}
$$

and conclude that

$$
A ^ { 2 } = \begin{vmatrix} u _ { 1 } & u _ { 2 } \\ v _ { 1 } & v _ { 2 } \end{vmatrix} ^ { 2 } .
$$

=   v 1 v 2   Since the last determinant has the same sign as the basis { u,v } , we can say that A is positive or negative according to whether the orientation of { u,v } is positive or negative. This is called the oriented area in R 2 .

[Page 33]

11. a. Show that the volume V of a parallelepiped generated by three linearly independent vectors u,v,w ∈ R 3 is given by V = | (u ∧ v) · w | , and introduce an oriented volume in R 3 .

b. Prove that

$$
V ^ { 2 } = \begin{vmatrix} u \cdot u & u \cdot v & u \cdot w \\ v \cdot u & v \cdot v & v \cdot w \\ w \cdot u & w \cdot v & w \cdot w \end{vmatrix} . \\ \intertext { v $ = 0 $ a n d $ w , $ show that there exists a } \intertext { v $ = 0 $ a n d $ w $ , $ } \intertext { a n d $ v , $ if $ w $ is perpendicular to $ w $ } \intertext { v $ = 0 $ a n d $ w $ , $ } \intertext { a n d $ v $ } \intertext { o n d $ w $ , $ } \intertext { i n d $ w $ } \intertext { a n d $ v $ } \intertext { o n d $ w $ }
$$

12. Given the vectors v  = 0 and w , show that there exists a vector u such that u ∧ v = w if and only if v is perpendicular to w . Is this vector u uniquely determined? If not, what is the most general solution?

Let and be differ-

entiable maps from the interval (a,b) into R . If the derivatives u ′ (t) and v ′ (t) satisfy the conditions

$$
u ^ { \prime } ( t ) = a u ( t ) + b v ( t ) , \ \ v ^ { \prime } ( t ) = c u ( t ) - a v ( t ) ,
$$

where a, b, and c are constants, show that u(t) ∧ v(t) is a constant vector.

14. and parallel to the plane determined by the points ( 0 , 0 , 0 ) , ( 1 , − 2 , 1 ) , ( − 1 , 1 , 1 ) .

# 1-5. The Local Theory of Curves Parametrized by Arc Length

This section contains the main results of curves which will be used in the later parts of the book. 3

Let α : I = (a,b) → R be a curve parametrized by arc length s . Since the tangent vector α ′ (s) has unit length, the norm | α ′′ (s) | of the second derivative measurestherateofchangeoftheanglewhichneighboringtangentsmakewith the tangent at s . | α ′′ (s) | gives, therefore, a measure of how rapidly the curve pulls away from the tangent line at s , in a neighborhood of s (see Fig. 1-14). This suggests the following deﬁnition.

DEFINITION. Let α : I → R 3 be a curve parametrized by arc length s ∈ I . The number | α ′′ ( s ) | = k ( s ) is called the curvature of α at s .

If α is a straight line, α(s) = us + v , where u and v are constant vectors ( | u | = 1), then k ≡ 0. Conversely, if k = | α ′′ (s) | ≡ 0, then by integration α(s) = us + v , and the curve is a straight line.

[Page 34]

(

)

![In the image, we can see a diagram with a diagram of a triangle and a diagram of a circle. The diagram of the triangle is labeled as \( \triangle A\), and the diagram of the circle is labeled as \( \triangle C\).](<images/imageFile14.png>)

α´

s

(

)

α´ ´

s

(

)

α´

s

(

)

α´

s

(

)

α´ ´

s

(

)

α´ ´

s

Figure 1-14

Notice that by a change of orientation, the tangent vector changes its direction; that is, if β( − s) = α(s) , then

$$
\frac { d \beta } { d ( - s ) } ( - s ) & = - \frac { d \alpha } { d s } ( s ) . \\ \intertext { t h e r w a t u r e } \intertext { s h e r w a t u r e } \intertext { i n v a r i a n }
$$

Therefore, α ′′ (s) and the curvature remain invariant under a change of orientation.

At points where k(s)  = 0, a unit vector n(s) in the direction α ′′ (s) is well deﬁned by the equation α ′′ (s) = k(s)n(s) . Moreover, α ′′ (s) is normal to α ′ (s) , because by differentiating α ′ (s) · α ′ (s) = 1 we obtain α ′′ (s) · α ′ (s) = 0. Thus, n(s) is normal to α ′ (s) and is called the normal vector at s . The plane determined by the unit tangent and normal vectors, α ′ (s) and n(s) , is called the osculating plane at s . (See Fig. 1-15.)

At points where k(s) = 0, the normal vector (and therefore the osculating plane) is not deﬁned (cf. Exercise 10). To proceed with the local analysis of curves, we need, in an essential way, the osculating plane. It is therefore convenient to say that s ∈ I is a singular point of order 1 if α ′′ (s) = 0 (in this context, the points where α ′ (s) = 0 are called singular points of order 0). In what follows, we shall restrict ourselves to curves parametrized by arc

In what follows, we shall restrict ourselves to curves parametrized by arc length without singular points of order 1. We shall denote by t (s) = α ′ (s) the unit tangent vector of α at s . Thus, t ′ (s) = k(s)n(s) .

will be called the binormal vector at s . Since b(s) is a unit vector, the length | b ′ (s) | measures the rate of change of the neighboring osculating planes with

[Page 35]

![In the diagram, there is a circle labeled as \( \mathbb{O} \) with a center \( \mathbb{O} \) marked as \( \mathbb{O} \) and a diameter \( \mathbb{O} \) as shown in the diagram. The circle is divided into two parts by two radii \( \mathbb{O} \) and \( \mathbb{O} \). The diameter \( \mathbb{O} \) is perpendicular to the diameter \( \mathbb{O} \) and is labeled as \( \mathbb{O} \).](<images/imageFile15.png>)

t

b

n

b

n

t

Figure 1-15

the osculating plane at s ; that is, | b ′ (s) | measures how rapidly the curve pulls away from the osculating plane at s , in a neighborhood of s (see Fig. 1-15).

To compute b ′ (s) we observe that, on the one hand, b ′ (s) is normal to b(s) and that, on the other hand,

$$
b ^ { \prime } ( s ) & = t ^ { \prime } ( s ) \wedge n ( s ) + t ( s ) \wedge n ^ { \prime } ( s ) = t ( s ) \wedge n ^ { \prime } ( s ) ; \\ \\ t \cdot _ { n } ( s ) & = t ^ { \prime } ( s ) \wedge n ( s ) + t ( s ) \wedge n ^ { \prime } ( s ) = t ( s ) \wedge n ^ { \prime } ( s ) ;
$$

that is, b ′ (s) is normal to t(s) . It follows that b ′ (s) is parallel to n(s) , and we may write

$$
b ^ { \prime } ( s ) = \tau ( s ) n ( s )
$$

for some function τ(s) . ( Warning : Many authors write − τ(s) instead of our τ(s) .)

DEFINITION. Let α : I → R 3 be a curve parametrized by arc length s such that α ′′ ( s )  = 0 , s ∈ I . The number τ( s ) deﬁned by b ′ ( s ) = τ( s ) n ( s ) is called the torsion of α at s .

If α is a plane curve (that is, α(I) is contained in a plane), then the plane of the curve agrees with the osculating plane; hence, τ ≡ 0. Conversely, if τ ≡ 0 (and k  = 0), we have that b(s) = b 0 = constant, and therefore

$$
( \alpha ( s ) \cdot b _ { 0 } ) ^ { \prime } & = \alpha ^ { \prime } ( s ) \cdot b _ { 0 } = 0 . \\
$$

It follows that α(s) · b 0 = constant; hence, α(s) is contained in a plane normal to b 0 . The condition that k  = 0 everywhere is essential here. In Exercise 10 we shall give an example where τ can be deﬁned to be identically zero and yet the curve is not a plane curve.

In contrast to the curvature, the torsion may be either positive or negative. The sign of the torsion has a geometric interpretation, to be given later (Sec. 1-6).

[Page 36]

Notice that by changing orientation the binormal vector changes sign, since b = t ∧ n . It follows that b ′ (s) , and, therefore, the torsion, remain invariant under a change of orientation.

Let us summarize our position. To each value of the parameter s , we have associated three orthogonal unit vectors t(s),n(s),b(s) . The trihedron thus formed is referred to as the Frenet trihedron at s . The derivatives t ′ (s) = kn , b ′ (s) = τn of the vectors t(s) and b(s) , when expressed in the basis { t,n,b } , yieldgeometricalentities(curvature k andtorsion τ )whichgiveusinformation about the behavior of α in a neighborhood of s .

The search for other local geometrical entities would lead us to compute n ′ (s) . However, since n = b ∧ t , we have

$$
n ^ { \prime } ( s ) = b ^ { \prime } ( s ) \wedge t ( s ) + b ( s ) \wedge t ^ { \prime } ( s ) = - \tau b - k t ,
$$

and we obtain again the curvature and the torsion.

For later use, we shall call the equations

$$
t ^ { \prime } & = k n , \\ n ^ { \prime } & = - k t - \tau b , \\ b ^ { \prime } & = \tau n .
$$

the Frenet formulas (we have omitted the s , for convenience). In this context, the following terminology is usual. The tb plane is called the rectifying plane , and the nb plane the normal plane . The lines which contain n(s) and b(s) and pass through α(s) are called the principal normal and the binormal , respectively. The inverse R = 1 /k of the curvature is called the radius of curvature at s . Of course, a circle of radius r has radius of curvature equal to r , as one can easily verify. 3

Physically, we can think of a curve in R as being obtained from a straight line by bending (curvature) and twisting (torsion). After reﬂecting on this construction, we are led to conjecture the following statement, which, roughly speaking, shows that k and τ describe completely the local behavior of the curve.

FUNDAMENTAL THEOREM OF THE LOCAL THEORY OF CURVES. Givendifferentiablefunctions k ( s ) > 0 and τ( s ) , s ∈ I, thereexists a regular parametrized curve α : I → R 3 such that s is the arc length , k(s) is the curvature, and τ (s) is the torsion of α . Moreover, any other curve ¯ α , satisfying the same conditions, differs from α by a rigid motion; that is, there exists an orthogonal linear map ρ of R 3 , with positive determinant, and a vector c such that ¯ α = ρ ◦ α + c.

The above statement is true. A complete proof involves the theorem of existence and uniqueness of solutions of ordinary differential equations and will be given in the appendix to Chap. 4. A proof of the uniqueness, up to

[Page 37]

Proof of the Uniqueness Part of the Fundamental Theorem. We ﬁrst remark that arc length, curvature, and torsion are invariant under rigid motions; that means, for instance, that if M : R 3 → R 3 is a rigid motion and α = α(t) is a parametrized curve, then

$$
\int _ { a } ^ { b } \left | \frac { d \alpha } { d t } \right | \, d t = \int _ { a } ^ { b } \left | \frac { d ( M \circ \alpha ) } { d t } \right | \, d t . \\ \text {e, since these concepts are defined by using
main derivative} \, (the derivatives are invariant under}
$$

  a   dt   =   a   dt   That is plausible, since these concepts are deﬁned by using inner or vector productsofcertainderivatives(thederivativesareinvariantundertranslations, and the inner and vector products are expressed by means of lengths and angles of vectors, and thus also invariant under rigid motions). A careful checking can be left as an exercise (see Exercise 6).

Now, assume that two curves α = α(s) and ¯ α = ¯ α(s) satisfy the conditions k(s) = ¯ k(s) and τ(s) = ¯ τ(s) , s ∈ I . Let t 0 ,n 0 ,b 0 and ¯ t 0 , ¯ n 0 , ¯ b 0 be the Frenet trihedrons at s = s 0 ∈ I of α and ¯ α , respectively. Clearly, there is a rigid motion which takes ¯ α(s 0 ) into α(s 0 ) and ¯ t 0 , ¯ n 0 , ¯ b 0 into t 0 ,n 0 ,b 0 . Thus, after performing this rigid motion on ¯ α , we have that ¯ α(s 0 ) = α(s 0 ) and that the Frenet trihedrons t(s),n(s),b(s) and ¯ t(s), ¯ n(s), ¯ b(s) of α and ¯ α , respectively, satisfy the Frenet equations:

$$
\Pi \text { connect equivalences} . \\ \frac { d t } { d s } = k n & & \frac { d \bar { t } } { d s } = k \bar { n } \\ d n & & \frac { d \bar { n } } { d s } = - k t - \tau b \\ \frac { d b } { d s } = \tau n & & \frac { d \bar { b } } { d s } = \tau \bar { n } ,
$$

$$
\frac { d v } { d s } = \tau n & & \frac { d v } { \frac { d s } { d s } } = \tau \bar { n } ,
$$

with t(s 0 ) = ¯ t(s 0 ) , n(s 0 ) = ¯ n(s 0 ) , b(s 0 ) = ¯ b(s 0 ) . We now observe, by using the Frenet equations,

We now observe, by using the Frenet equations, that

$$
\text {We now observe, by using the Frennet equations, that} \\ \frac { 1 } { 2 } \frac { d } { d s } \{ | t - \bar { t } | ^ { 2 } + | n - \bar { n } | ^ { 2 } + | b - \bar { b } | ^ { 2 } \} \\ = \langle t - \bar { t } , t ^ { \prime } - \bar { t } ^ { \prime } \rangle + \langle b - \bar { b } , b ^ { \prime } - \bar { b } ^ { \prime } \rangle + \langle n - \bar { n } , n ^ { \prime } - \bar { n } ^ { \prime } \rangle \\ = k \langle t - t , n - n \rangle + \tau \langle b - b , n - n \rangle - k \langle n - n , t - t \rangle \\ - \tau \langle n - \bar { n } , b - \bar { b } \rangle \\ = 0 \\ \text {for all $s \in I$. Thus, the above expression is constant, and, since it is zero for $n$} .
$$

for all s ∈ I . Thus, the above expression is constant, and, since it is zero for s = s 0 , it is identically zero. It follows that t(s) = ¯ t(s),n(s) = ¯ n(s),b(s) = ¯ b(s) for all s ∈ I . Since

[Page 38]

$$
\frac { d \alpha } { d s } = t = \bar { t } = \frac { d \bar { \alpha } } { d s } ,
$$

we obtain (d/ ds )(α − ¯ α) = 0. Thus, α(s) = ¯ α(s) + a , where a is a constant vector. Since α(s 0 ) = ¯ α(s 0 ) , we have a = 0; hence, α(s) = ¯ α(s) for all s ∈ I . Q.E.D.

Remark 1. In the particular case of a plane curve α : I → R 2 , it is possible to give the curvature k a sign. For that, let { e 1 ,e 2 } be the natural basis (see Sec. 1-4) of R 2 and deﬁne the normal vector n(s) , s ∈ I , by requiring the basis { t(s),n(s) } to have the same orientation as the basis { e 1 ,e 2 } . The curvature k is then deﬁned by

$$
\frac { d t } { d s } = k n
$$

and might be either positive or negative. It is clear that | k | agrees with the previous deﬁnition and that k changes sign when we change either the orientation of α or the orientation of R 2 (Fig. 1-16).

e

![The image is a geometric diagram consisting of a circle with a radius labeled as \( r \). The circle is divided into two parts by two radii, labeled as \( r_1 \) and \( r_2 \). The center of the circle is located at the intersection of the two radii. The diagram includes two lines, labeled as \( \alpha \) and \( \beta \), which are perpendicular to the radii \( r_1 \) and \( r_2 \). These lines intersect at a point labeled as \( \alpha \). The diagram also includes a point labeled as \( \alpha \), which is located at the intersection of the two radii \( r_1 \) and \( r_2 \). This point is connected to the center of the circle by a line segment labeled as \( \alpha \). The diagram also includes a line segment labeled as \( \beta \](<images/imageFile16.png>)

n

2

e

1

< 0

k

t

n

t

> 0

k

Figure 1-16

It should also be remarked that, in the case of plane curves (τ ≡ 0 ) , the proof of the fundamental theorem, refered to above, is actually very simple (see Exercise 9).

Remark 2. Given a regular parametrized curve α : I → R 3 (not necessarily parametrized by arc length), it is possible to obtain a curve β : J → R 3 parametrized by arc length which has the same trace as α . In fact, let

$$
s = s ( t ) = \int _ { t _ { 0 } } ^ { t } | \alpha ^ { \prime } ( t ) | \, d t , \ \ t , t _ { 0 } \in I .
$$

[Page 39]

Since ds / dt = | α ′ (t) |  = 0, the function s = s(t) has a differentiable inverse t = t(s) , s ∈ s(I) = J , where, by an abuse of notation, t also denotes the inverse function s − 1 of s . Now set β = α ◦ t : J → R 3 . Clearly, β(J) = α(I) and | β ′ (s) | = | (α ′ (t) · ( dt / ds ) | = 1. This shows that β has the same trace as α andisparametrizedbyarclength. Itisusualtosaythat β isa reparametrization of α(I) by arc length .

Thisfactallowsustoextendalllocalconceptspreviouslydeﬁnedtoregular curves with an arbitrary parameter. Thus, we say that the curvature k(t) of α : I → R 3 at t ∈ I is the curvature of a reparametrization β : J → R 3 of α(I) by arc length at the corresponding point s = s(t) . This is clearly independent of the choice of β and shows that the restriction, made at the end of Sec. 1-3, of considering only curves parametrized by arc length is not essential.

In applications, it is often convenient to have explicit formulas for the geometrical entities in terms of an arbitrary parameter; we shall present some of them in Exercise 12.

# EXERCISES

Unless explicity stated , α : I → R 3 is a curve parametrized by arc length s, with curvature k(s)  = 0, for all s ∈ I. 1. Given the parametrized curve (helix)

Given the parametrized curve (helix)

$$
\alpha ( s ) = \left ( a \cos \frac { s } { c } , a \sin \frac { s } { c } , b \frac { s } { c } \right ) , \quad s \in R , \\ = a ^ { 2 } + b ^ { 2 }
$$

where c 2 = a 2 + b 2 , a. Show that the

parameter s is the arc length.

- b. Determine the curvature and the torsion of α .
- c. Determine the osculating plane of α .
- d. Show that the lines containing n(s) and passing through α(s) meet the z axis under a constant angle equal to π/ 2.
- e. Show that the tangent lines to α make a constant angle with the z axis.


*2. Show that the torsion τ of α is given by

$$
\tau ( s ) = - \frac { \alpha ^ { \prime } ( s ) \wedge \alpha ^ { \prime \prime } ( s ) \cdot \alpha ^ { \prime \prime \prime } ( s ) } { | k ( s ) | ^ { 2 } } . \\
$$

3. Assume that α(I) ⊂ R 2 (i.e., α is a plane curve) and give k a sign as in the text. Transport the vectors t(s) parallel to themselves in such a way that the origins of t(s) agree with the origin of R 2 ; the end points of t(s) then describe a parametrized curve s → t(s) called the indicatrix

[Page 40]

of tangents of α . Let θ(s) be the angle from e 1 to t(s) in the orientation of R 2 . Prove (a) and (b) (notice that we are assuming that k  = 0). a. The indicatrix of tangents is a regular parametrized curve.

The indicatrix of tangents is a regular parametrized curve.

dt / ds = (dθ/ ds )n , that is, k = dθ/ ds .

*4. curve pass through a ﬁxed point. Prove that the trace of the curve is contained in a circle.

5. A regular parametrized curve α has the property that all its tangent lines pass through a ﬁxed point.

- a. Prove that the trace of α is a (segment of a) straight line.
- b. Does the conclusion in part a still hold if α is not regular?


6. A translation by a vector v in R 3 is the map A : R 3 → R 3 that is given by A(p) = p + v , p ∈ R 3 . A linear map ρ : R 3 → R 3 is an orthogonal transformation when ρu · ρv = u · v for all vectors u , v ∈ R 3 . A rigid motion in R 3 is the result of composing a translation with an orthogonal transformation with positive determinant (this last condition is included because we expect rigid motions to preserve orientation).

- a. Demonstrate that the norm of a vector and the angle θ between two vectors, 0 ≤ θ ≤ π , are invariant under orthogonal transformations with positive determinant.
- b. Show that the vector product of two vectors is invariant under orthogonal transformations with positive determinant. Is the assertion still true if we drop the condition on the determinant?
- c. Show that the arc length, the curvature, and the torsion of a parametrized curve are (whenever deﬁned) invariant under rigid motions.


*7. Let α : I → R 2 be a regular parametrized plane curve (arbitrary parameter), and deﬁne n = n(t) and k = k(t) as in Remark 1. Assume that k(t)  = 0, t ∈ I . In this situation, the curve

$$
\beta ( t ) = \alpha ( t ) + \frac { 1 } { k ( t ) } n ( t ) , \ \ t \in I ,
$$

is called the evolute of α (Fig. 1-17).

- a. Show that the tangent at t of the evolute of α is the normal to α at t.
- b. Consider the normal lines of α at two neighboring points t 1 ,t 2 , t 1  = t 2 . Let t 1 approach t 2 and show that the intersection points of the normals converge to a point on the trace of the evolute of α .


[Page 41]

![In this image we can see a diagram.](<images/imageFile17.png>)

α

β

Figure 1-17

8. The trace of the parametrized curve (arbitrary parameter)

$$
\alpha ( t ) = ( t , \cosh t ) , \ \ t \in R ,
$$

is called the catenary .

- a. Show that the signed curvature (cf. Remark 1) of the catenary is

$$
k ( t ) = \frac { 1 } { \cosh ^ { 2 } t } .
$$

- b. Show that the evolute (cf. Exercise 7) of the catenary is


$$
\beta ( t ) = ( t - \sinh t \cosh t , 2 \cosh t ) .
$$

9. Given a differentiable function k(s) , s ∈ I , show that the parametrized plane curve having k(s) = k as curvature is given by

$$
\alpha ( s ) = \left ( \int \cos \theta ( s ) \, d s + a , \int \sin \theta ( s ) \, d s + b \right ) , \\ \intertext { e r e } \theta ( s ) = \int k ( s ) \, d s + \varphi ,
$$

$$
=
$$

where

$$
\theta ( s ) = \int k ( s ) \, d s + \varphi , \\ \\ k ( s ) = \int k ( s ) \, d s + \varphi ,
$$

and that the curve is determined up to a translation of the vector (a,b) and a rotation of the angle ϕ .

[Page 42]

10. Consider the map

$$
\alpha ( t ) = \begin{cases} ( t , 0 , e ^ { - 1 / t ^ { 2 } } ) , & t > 0 \\ ( t , e ^ { - 1 / t ^ { 2 } } , 0 ) , & t < 0 \\ ( 0 , 0 , 0 ) , & t = 0 \end{cases} \\ \alpha \text { is a different curve.}
$$

- a. Prove that α is a differentiable curve.
- b. Prove that α is regular for all t and that the curvature k(t)  = 0, for t  = 0, t  = ±   2 / 3, and k( 0 ) = 0. c. Show that the limit of the osculating planes as t 0, t > 0, is the


√ c. Show that the limit of the osculating planes as t → 0, t > 0, is the plane y = 0but that the limit of the osculating planes as t → 0, t < 0, is the plane z = 0 (this implies that the normal vector is discontinuous at t = 0 and shows why we excluded points where k = 0).

Show that τ can be defined so that τ ≡ 0, even though α is not a plane curve.

11. One often gives a plane curve in polar coordinates by ρ = ρ(θ) , a ≤ θ ≤ b . a. Show that the arc length is

Show that the arc length is

$$
\int _ { a } ^ { b } \sqrt { \rho ^ { 2 } + ( \rho ^ { \prime } ) ^ { 2 } } \, d \theta ,
$$

where the prime denotes the derivative relative to θ .

b. Show that the curvature is

$$
k ( \theta ) = \frac { 2 ( \rho ^ { \prime } ) ^ { 2 } - \rho \rho ^ { \prime \prime } + \rho ^ { 2 } } { \{ ( \rho ^ { \prime } ) ^ { 2 } + \rho ^ { 2 } \} ^ { 3 / 2 } } . \\ \intertext { b . c r o g u l o r p o r m o t r i z o d u r v o ( n o t }
$$

12. Let α : I → R 3 be a regular parametrized curve (not necessarily by arc length) and let β : J → R 3 be a reparametrization of α(I) by the arc length s = s(t) , measured from t 0 ∈ I (see Remark 2). Let t = t(s) be the inverse function of s and set dα/ dt = α ′ , d 2 α/ dt 2 = α ′′ , etc. Prove that

a. dt / ds = 1 / | α ′ | , d 2 t/ ds 2 = − (α ′ · α ′′ / | α ′ | 4 ) . b. The curvature of α at t I is

The curvature of α at t ∈ I is

$$
k ( t ) = \frac { | \alpha ^ { \prime } \wedge \alpha ^ { \prime \prime } | } { | \alpha ^ { \prime } | ^ { 3 } } . \\
$$

c. The torsion of α at t ∈ I is

$$
\tau ( t ) = - \frac { ( \alpha ^ { \prime } \wedge \alpha ^ { \prime \prime } ) \cdot \alpha ^ { \prime \prime \prime } } { | \alpha ^ { \prime } \wedge \alpha ^ { \prime \prime } | ^ { 2 } } .
$$

[Page 43]

d. If α : I → R 2 is a plane curve α(t) = (x(t),y(t)) , the signed curvature (see Remark 1) of α at t is

$$
k ( t ) = \frac { x ^ { \prime } y ^ { \prime \prime } - x ^ { \prime \prime } y ^ { \prime } } { ( ( x ^ { \prime } ) ^ { 2 } + ( y ^ { \prime } ) ^ { 2 } ) ^ { 3 / 2 } } . \\
$$

*13. Assume that τ(s)  = 0 and k ′ (s)  = 0 for all s ∈ I . Show that a necessary and sufﬁcient condition for α(I) to lie on a sphere is that

$$
R ^ { 2 } + ( R ^ { \prime } ) ^ { 2 } T ^ { 2 } = \text {const} . ,
$$

where R = 1 /k , T = 1 /τ , and R ′ is the derivative of R relative to s . Let α : (a,b) R 2 be a regular parametrized plane curve. Assume

14. → that there exists t 0 , a < t 0 < b , such that the distance | α(t) | from the origin to the trace of α will be a maximum at t 0 . Prove that the curvature k of α at t 0 satisﬁes | k(t 0 ) | ≥ 1 / | α(t 0 ) | . *15. Show that the knowledge of the vector function b b(s) (binormal

= vector) of a curve α , with nonzero torsion everywhere, determines the curvature k(s) and the absolute value of the torsion τ(s) of α .

*16. Showthattheknowledgeofthevectorfunction n = n(s) (normalvector) of a curve α , with nonzero torsion everywhere, determines the curvature k(s) and the torsion τ(s) of α .

17. In general, a curve α is called a helix if the tangent lines of α make a constant angle with a ﬁxed direction. Assume that τ(s)  = 0, s ∈ I , and prove that:

*a. α is a helix if and only if k/ τ = const .

n(s) and passing through α(s) are parallel to a ﬁxed plane.

*c. α is a helix if and only if the lines containing b(s) and passing through α(s) make a constant angle with a ﬁxed direction.

d. The curve

$$
\alpha ( s ) & = \left ( \frac { a } { c } \int \sin \theta ( s ) \, d s , \, \frac { a } { c } \int \cos \theta ( s ) \, d s , \, \frac { b } { c } s \right ) , \\
$$

where c 2 = a 2 + b 2 , is a helix, and that k/τ = a/b . : 3 be a parametrized regular curve (not

*18. Let α I → R necessarily by arc length) with k(t)  = 0, τ(t)  = 0, t ∈ I . The curve α is called a Bertrand curve if there exists a curve ¯ α : I → R 3 such that the normal lines of α and ¯ α at t ∈ I are equal. In this case, ¯ α is called a Bertrand mate of α , and we can write

$$
\bar { \alpha } ( t ) = \alpha ( t ) + r n ( t ) .
$$

[Page 44]

Prove that

- a. r is constant.
- b. α is a Bertrand curve if and only if there exists a linear relation


$$
A k ( t ) + B \tau ( t ) = 1 , \ \ t \in I ,
$$

where A,B are nonzero constants and k and τ are the curvature and torsion of α , respectively.

c. If α has more than one Bertrand mate, it has inﬁnitely many Bertrand mates. This case occurs if and only if α is a circular helix.

# 1-6. The Local Canonical Form †

One of the most effective methods of solving problems in geometry consists of ﬁnding a coordinate system which is adapted to the problem. In the study of local properties of a curve, in the neighborhood of the point s , we have a natural coordinate system, namely the Frenet trihedron at s . It is therefore convenient to refer the curve to this trihedron. 3

Let α : I → R be a curve parametrized by arc length without singular points of order 1. We shall write the equations of the curve, in a neighborhood of s 0 , using the trihedron t(s 0 ),n(s 0 ),b(s 0 ) as a basis for R 3 . We may assume, without loss of generality, that s 0 = 0, and we shall consider the (ﬁnite) Taylor expansion

$$
\alpha ( s ) = \alpha ( 0 ) + s \alpha ^ { \prime } ( 0 ) + \frac { s ^ { 2 } } { 2 } \alpha ^ { \prime \prime } ( 0 ) + \frac { s ^ { 3 } } { 6 } \alpha ^ { \prime \prime \prime } ( 0 ) + R ,
$$

where lim s → 0 R/s 3 = 0. Since α ′ ( 0 ) = t , α ′′ ( 0 ) = kn , and

we obtain

$$
\alpha ^ { \prime \prime } ( 0 ) = ( k n ) ^ { \prime } = k ^ { \prime } n + k n ^ { \prime } = k ^ { \prime } n - k ^ { 2 } t - k \tau b ,
$$

$$
\alpha ( s ) - \alpha ( 0 ) = \left ( s - \frac { k ^ { 2 } s ^ { 3 } } { 3 ! } \right ) t + \left ( \frac { s ^ { 2 } k } { 2 } + \frac { s ^ { 3 } k ^ { \prime } } { 3 ! } \right ) n - \frac { s ^ { 3 } } { 3 ! } k \tau b + R ,
$$

where all terms are computed at s = 0. Let us now take the system Oxyz in

such a way that the origin O agrees with α( 0 ) and that t = ( 1 , 0 , 0 ) , n = ( 0 , 1 , 0 ) , b = ( 0 , 0 , 1 ) . Under these conditions, α(s) = (x(s),y(s),z(s)) is given by

†This section may be omitted on a ﬁrst reading.

[Page 45]

$$
x ( s ) & = s - \frac { k ^ { 2 } s ^ { 3 } } { 6 } + R _ { x } , \\ y ( s ) & = \frac { k } { 2 } s ^ { 2 } + \frac { k ^ { \prime } s ^ { 3 } } { 6 } + R _ { y } , \\ z ( s ) & = - \frac { k \tau } { 6 } s ^ { 3 } + R _ { z } , \\
$$

where R = (R x ,R y ,R z ) . The representation (1) is called the local canonical form of α , in a neighborhood of s = 0. In Fig. 1-18 is a rough sketch of the projections of the trace of α , for s small, in the tn,tb , and nb planes.

![In this image, we can see a diagram with some lines and arrows.](<images/imageFile18.png>)

b

t

n

n

t

Projection over the plane t n

b

b

t

n

Projection over the plane t b

Projection over the plane n b

Figure 1-18

Below we shall describe some geometrical applications of the local canonical form. Further applications will be found in the Exercises.

A ﬁrst application is the following interpretation of the sign of the torsion. Fromthethirdequationof(1)itfollowsthatif τ < 0and s issufﬁcientlysmall, then z(s) increases with s . Let us make the convention of calling the “positive side” of the osculating plane that side toward which b is pointing. Then, since z( 0 ) = 0, when we describe the curve in the direction of increasing arc length, the curve will cross the osculating plane at s = 0, pointing toward the positive

[Page 46]

![image 19](<images/imageFile19.png>)

Negative torsion

Figure 1-19

![image 20](<images/imageFile20.png>)

Positive torsion

The helix of Exercise 1 of Sec. 1-5 has negative torsion. An example of a curve with positive torsion is the helix

$$
\alpha ( s ) = \left ( a \cos \frac { s } { c } , a \sin \frac { s } { c } , - b \frac { s } { c } \right ) \\ \text {first one by a reflection in the z plane} \, ( s e )
$$

obtained from the ﬁrst one by a reﬂection in the xz plane (see Fig. 1-19).

Remark. It is also usual to deﬁne torsion by b ′ = − τn . With such a deﬁnition, the torsion of the helix of Exercise 1 becomes positive.

Another consequence of the canonical form is the existence of a neighborhood J ⊂ I of s = 0 such that α(J) is entirely contained in the one side of the rectifying plane toward which the vector n is pointing (see Fig. 1-18). In fact, since k > 0, we obtain, for s sufﬁciently small, y(s) ≥ 0, and y(s) = 0 if and only if s = 0. This proves our claim. As a last application of the canonical form, we mention the following

property of the osculating plane. The osculating plane at s is the limit position of the plane determined by the tangent line at s and the point α(s + h) when h → 0. To prove this, let us assume that s = 0. Thus, every plane containing the tangent at s = 0 is of the form z = cy or y = 0. The plane y = 0 is the rectifying plane that, as seen above, contains no points near α( 0 ) (except α( 0 ) itself) and that may therefore be discarded from our considerations. The condition for the plane z = cy to pass through α(s + h) is (s = 0 )

$$
c = \frac { z ( h ) } { y ( h ) } = \frac { - \frac { k } { 6 } \tau h ^ { 3 } + \cdots } { \frac { k } { 2 } h ^ { 2 } + \frac { k ^ { 2 } } { 6 } h ^ { 3 } + \cdots } .
$$

Letting h → 0, we see that c → 0. Therefore, the limit position of the plane z(s) = c(h)y(s) is the plane z = 0, that is, the osculating plane, as we wished.

[Page 47]

# EXERCISES

*1. Let α : I → R 3 be a curve parametrized by arc length with curvature k(s)  = 0, s ∈ I . Let P be a plane satisfying both of the following conditions:

- 1. P contains the tangent line at s .
- 2. Given any neighborhood J ⊂ I of s , there exist points of α(J) in both sides of P .


Prove that P is the osculating plane of α at s .

2. Let α : I → R 3 be a curve parametrized by arc length, with curvature k(s)  = 0, s ∈ I . Show that *a. The osculating plane at is the limit position of the plane passing

*a. The osculating plane at s is the limit position of the plane passing through α(s) , α(s + h 1 ) , α(s + h 2 ) when h 1 , h 2 → 0.

+ α(s + h 2 ) when h 1 , h 2 → 0 is a circle in the osculating plane at s , the center of which is on the line that contains n(s) and the radius of which is the radius of curvature 1 /k(s) ; this circle is called the osculating circle at s .

3. Show that the curvature k(t)  = 0 of a regular parametrized curve α : I → R 3 is the curvature at t of the plane curve π ◦ α , where π is the normal projection of α over the osculating plane at t .

# 1-7. Global Properties of Plane Curves †

In this section we want to describe some results that belong to the global differential geometry of curves. Even in the simple case of plane curves, the subject already offers examples of nontrivial theorems and interesting questions. To develop this material here, we must assume some plausible facts without proofs; we shall try to be careful by stating these facts precisely. Although we want to come back later, in a more systematic way, to global differential geometry (Chap. 5), we believe that this early presentation of the subject is both stimulating and instructive.

This section contains three topics in order of increasing difﬁculty: (A) the isoperimetric inequality, (B) the four-vertex theorem, and (C) the Cauchy-Crofton formula. The topics are entirely independent, and some or all of them can be omitted on a ﬁrst reading.

A differentiable function on a closed interval [ a,b ] is the restriction of a differentiable function deﬁned on an open interval containing [ a,b ].

†This section may be omitted on a ﬁrst reading.

[Page 48]

A closed plane curve is a regular parametrized curve α : [ a,b ] → R 2 such that α and all its derivatives agree at a and b ; that is,

$$
\alpha ( a ) = \alpha ( b ) , \quad \alpha ^ { \prime } ( a ) = \alpha ^ { \prime } ( b ) , \quad \alpha ^ { \prime \prime } ( a ) = \alpha ^ { \prime \prime } ( b ) , \dots .
$$

The curve α is simple if it has no further self-intersections; that is, if t 1 ,t 2 ∈ [ a,b) , t 1  = t 2 , then α(t 1 )  = α(t 2 ) (Fig. 1-20).

![image 21](<images/imageFile21.png>)

(a) A simple closed curve

![image 24](<images/imageFile24.png>)

(b) A (nonsimple) closed curve see Fig. 1-21(a)). Whenever we speak of the area bounded by a simple closed curve C , we mean the area of the interior of C . We assume further that the parameter of a simple closed curve can be so chosen that if one is going along the curve in the direction of increasing parameters, then the interior of the curve remains to the left (Fig. l-21(b)). Such a curve will be called positively oriented .

Figure 1-20

![image 22](<images/imageFile22.png>)

T

C

(a) A simple closed curve C

on a

C

torus T

;

bounds no region on T.

T

C

T.

Interior of C

![image 23](<images/imageFile23.png>)

C

C

(b) C is positively oriented.

Figure 1-21

We usually consider the curve α : [0 ,l ] → R 2 parametrized by arc length s ; hence, l is the length of α . Sometimes we refer to a simple closed curve C , meaning the trace of such an object. The curvature of α will be taken with a sign, as in Remark 1 of Sec. 1-5 (see Fig. 1-20).

We assume that a simple closed curve C in the plane bounds a region of this plane that is called the interior of C . This is part of the so-called Jordan curve theorem (a proof will be given in Sec. 5-7, Theorem 1), which does not hold, for instance, for simple curves on a torus (the surface of a doughnut;

[Page 49]

# A. The Isoperimetric Inequality

This is perhaps the oldest global theorem in differential geometry and is related to the following (isoperimetric) problem. Of all simple closed curves in the plane with a given length l, which one bounds the largest area ? In this form, the problem was known to the Greeks, who also knew the solution, namely, the circle. A satisfactory proof of the fact that the circle is a solution to the isoperimetric problem took, however, a long time to appear. The main reason seems to be that the earliest proofs assumed that a solution should exist. It was only in 1870 that K. Weierstrass pointed out that many similar questions did not have solutions and gave a complete proof of the existence of a solution to the isoperimetric problem. Weierstrass’ proof was somewhat hard, in the sense that it was a corollary of a theory developed by him to handle problems of maximizing (or minimizing) certain integrals (this theory is called calculus of variations and the isoperimetric problem is a typical example of the problems it deals with). Later, more direct proofs were found. The simple proof we shall present is due to E. Schmidt (1939). For another direct proof and further bibliography on the subject, one may consult Reference [10] in the Bibliography.

We shall make use of the following formula for the area A bounded by a positively oriented simple closed curve α(t) = (x(t),y(t)) , where t ∈ [ a,b ] is an arbitrary parameter:

$$
A = - \int _ { a } ^ { b } y ( t ) x ^ { \prime } ( t ) \, d t = \int _ { a } ^ { b } x ( t ) y ^ { \prime } ( t ) \, d t = \frac { 1 } { 2 } \int _ { a } ^ { b } ( x y ^ { \prime } - y x ^ { \prime } ) \, d t \quad ( 1 ) \\ \intertext { A = - \int _ { a } ^ { b } y ( t ) x ^ { \prime } ( t ) \, d t = \int _ { a } ^ { b } x ( t ) y ^ { \prime } ( t ) \, d t = \frac { 1 } { 2 } \int _ { a } ^ { b } ( x y ^ { \prime } - y x ^ { \prime } ) \, d t \quad ( 1 ) \\ \intertext { \ \ } \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

Notice that the second formula is obtained from the ﬁrst one by observing that

$$
\int _ { a } ^ { b } x y ^ { \prime } d t & = \int _ { a } ^ { b } ( x y ) ^ { \prime } d t - \int _ { a } ^ { b } x ^ { \prime } y d t = [ x y ( b ) - x y ( a ) ] - \int _ { a } ^ { b } x ^ { \prime } y d t \\ & = - \int _ { a } ^ { b } x ^ { \prime } y d t , \\ \intertext { s i n c h e r w i c h s e d . T h e r w i c h s e d i m a t i o n f u m l a } \intertext { s i n c h e r w i c h s e d . T h e r w i c h s e d i m a t i o n f u m l a }
$$

since the curve is closed. The third formula is immediate from the ﬁrst two.

To prove the ﬁrst formula in Eq. (1), we consider initially the case of Fig. 1-22 where the curve is made up of two straight-line segments parallel to the y axis and two arcs that can be written in the form

[Page 50]

y

![The image presents a graph with two axes labeled as x and y. The x-axis is labeled as x and the y-axis is labeled as y. The graph is a line graph with a linear scale of range 0 to 1.25. The line is drawn from the bottom left to the top right of the graph. The line is marked with a point at the bottom left of the graph. The graph has a scale from 0 to 1.25 on the x-axis, and a scale of range 0 to 1.25 on the y-axis. The graph is drawn with a black line.](<images/imageFile25.png>)

=

=

t

a, t

b

f

1

=

t

t

1

=

t

t

=

t

t

2

f

3

2

x

x

x

0

0

1

Figure 1-22

$$
y = f _ { 1 } ( x ) \ \text { and } \ y = f _ { 2 } ( x ) , x \in [ x _ { 0 } , x _ { 1 } ] , f _ { 1 } > f _ { 2 } .
$$

Clearly, the area bounded by the curve is

$$
A = \int _ { x _ { 0 } } ^ { x _ { 1 } } f _ { 1 } ( x ) \, d x - \int _ { x _ { 0 } } ^ { x _ { 1 } } f _ { 2 } ( x ) \, d x .
$$

Since the curve is positively oriented, we obtain, with the notation of Fig. l-22,

$$
A = - \int _ { a } ^ { t _ { 1 } } y ( t ) x ^ { \prime } ( t ) \, d t - \int _ { t _ { 2 } } ^ { t _ { 3 } } y ( t ) x ^ { \prime } ( t ) \, d t = - \int _ { a } ^ { b } y ( t ) x ^ { \prime } ( t ) \, d t ,
$$

since x ′ (t) = 0 along the segments parallel to the y axis. This proves Eq. (1) for this case.

To prove the general case, it must be shown that it is possible to divide the region bounded by the curve into a ﬁnite number of regions of the above type. This is clearly possible (Fig. 1-23) if there exists a straight line E in the plane such that the distance ρ(t) of α(t) to this line is a function with ﬁnitely many critical points (a critical point is a point where ρ ′ (t) = 0). The last assertion is true, but we shall not go into its proof. We shall mention, however, that Eq. (1) can also be obtained by using Stokes’ (Green’s) theorem in the plane (see Exercise 15).

THEOREM 1 (The Isoperimetric Inequality). Let C beasimpleclosed plane curve with length l, and let A be the area of the region bounded by C . Then

$$
l ^ { 2 } - 4 \pi A \geq 0 ,
$$

and equality holds if and only if C is a circle.

Proof . Let E and E ′ be two parallel lines which do not meet the closed curve C , and move them together until they ﬁrst meet C . We thus obtain two parallel tangent lines to C , L and L ′ , so that the curve is entirely contained

[Page 51]

[Page 52]

[Page 53]

[Page 54]

[Page 55]

[Page 56]

[Page 57]

[Page 58]

[Page 59]

[Page 60]

[Page 61]

[Page 62]

[Page 63]

[Page 64]

[Page 65]

[Page 66]

[Page 67]

[Page 68]

[Page 69]

[Page 70]

[Page 71]

[Page 72]

[Page 73]

[Page 74]

[Page 75]

[Page 76]

[Page 77]

[Page 78]

[Page 79]

[Page 80]

[Page 81]

[Page 82]

[Page 83]

[Page 84]

[Page 85]

[Page 86]

[Page 87]

[Page 88]

[Page 89]

[Page 90]

[Page 91]

[Page 92]

[Page 93]

[Page 94]

[Page 95]

[Page 96]

[Page 97]

[Page 98]

[Page 99]

[Page 100]

[Page 101]

[Page 102]

[Page 103]

[Page 104]

[Page 105]

[Page 106]

[Page 107]

[Page 108]

[Page 109]

[Page 110]

[Page 111]

[Page 112]

[Page 113]

[Page 114]

[Page 115]

[Page 116]

[Page 117]

[Page 118]

[Page 119]

[Page 120]

[Page 121]

[Page 122]

[Page 123]

[Page 124]

[Page 125]

[Page 126]

[Page 127]

[Page 128]

[Page 129]

[Page 130]

[Page 131]

[Page 132]

[Page 133]

[Page 134]

[Page 135]

[Page 136]

[Page 137]

[Page 138]

[Page 139]

[Page 140]

[Page 141]

[Page 142]

[Page 143]

[Page 144]

[Page 145]

[Page 146]

[Page 147]

[Page 148]

[Page 149]

[Page 150]

[Page 151]

Observe that F(x,y) = F(x,y + 2 π) . Thus, F is not one-to-one and has no global inverse. For each p ∈ R 2 , the inverse function theorem gives neighborhoods V of p and W of F(p) so that the restriction F : V → W is a diffeomorphism. In our case, V may be taken as the strip {−∞ < x < ∞ , 0 < y < 2 π } and W as R 2 −{ ( 0 , 0 ) } . However, as the example shows, even if the conditionsofthetheoremaresatisﬁedeverywhereandthedomainofdeﬁnition of F is very simple, a global inverse of F may fail to exist.

[Page 152]

# 3 The Geometry of the Gauss Map

# 3-1. Introduction

As we have seen in Chap. 1, the consideration of the rate of change of the tangent line to a curve C led us to an important geometric entity, namely, the curvature of C . In this chapter we shall extend this idea to regular surfaces; that is, we shall try to measure how rapidly a surface S pulls away from the tangent plane T p (S) in a neighborhood of a point p ∈ S . This is equivalent to measuring the rate of change at p of a unit normal vector ﬁeld N on a neighborhood of p . As we shall see shortly, this rate of change is given by a linear map on T p (S) which happens to be self-adjoint (see the appendix to Chap. 3). A surprisingly large number of local properties of S at p can be derived from the study of this linear map.

In Sec. 3-2, we shall introduce the relevant deﬁnitions (the Gauss map, principal curvatures and principal directions, Gaussian and mean curvatures, etc.) without using local coordinates. In this way, the geometric content of the deﬁnitions is clearly brought up. However, for computational as well as for theoreticalpurposes, itisimportanttoexpressallconceptsinlocalcoordinates. This is taken up in Sec. 3-3.

Sections 3-2 and 3-3 contain most of the material of Chap. 3 that will be used in the remaining parts of this book. The few exceptions will be explicitly pointed out. For completeness, we have proved the main properties of selfadjoint linear maps in the appendix to Chap. 3. Furthermore, for those who have omitted Sec. 2-6, we have included a brief review of orientation for surfaces at the beginning of Sec. 3-2.

[Page 153]

Section 3-4 contains a proof of the fact that at each point of a regular surface there exists an orthogonal parametrization, that is, a parametrization such that its coordinate curves meet orthogonally. The techniques used here are interesting in their own right and yield further results. However, for a short course it might be convenient to assume these results and omit the section.

In Sec. 3-5 we shall take up two interesting special cases of surfaces, namely, the ruled surfaces and the minimal surfaces. They are treated independently so that one (or both) of them can be omitted on a ﬁrst reading.

# 3-2. The Deﬁnition of the Gauss Map and Its Fundamental Properties

We shall begin by brieﬂy reviewing the notion of orientation for surfaces. 2

As we have seen in Sec. 2-4, given a parametrization x : U ⊂ R → S of a regular surface S at a point p ∈ S , we can choose a unit normal vector at each point of x (U) by the rule

$$
N ( q ) = \frac { \mathbf x _ { u } \wedge \mathbf x _ { v } } { | \mathbf x _ { u } \wedge \mathbf x _ { v } | } ( q ) , \quad q \in \mathbf x ( U ) . \\ \intertext { v c r } \mathbf x ( q ) = \frac { \mathbf x _ { u } \wedge \mathbf x _ { v } } { | \mathbf x _ { u } \wedge \mathbf x _ { v } | } ( q ) , \quad q \in \mathbf x ( U ) .
$$

Thus, we have a differentiable map N : x (U) → R 3 that associates to each q ∈ x (U) a unit normal vector N(q) . More generally, if V ⊂ S is an open set in S and N : V → R 3 is a differen-

tiable map which associates to each q ∈ V a unit normal vector at q , we say that N is a differentiable ﬁeld of unit normal vectors on V .

It is a striking fact that not all surfaces admit a differentiable field of unit normal vectors defined on the whole surface . For instance, on the Möbius strip of Fig. 3-1 one cannot define such a field. This can be seen intuitively by going around once along the middle circle of the figure: After one turn, the vector field N would come back as -N , a contradiction to the continuity of N . Intuitively, one cannot, on the Möbius strip, make a consistent choice of a definite 'side'; moving around the surface, we can go continuously to the 'other side' without leaving the surface.

![In this image we can see a diagram.](<images/imageFile26.png>)

Figure 3-1. The Möbius strip.

[Page 154]

We shall say that a regular surface is orientable if it admits a differentiable ﬁeld of unit normal vectors deﬁned on the whole surface; the choice of such a ﬁeld N is called an orientation of S .

For instance, the Möbius strip referred to above is not an orientable surface. Of course, every surface covered by a single coordinate system (for instance, surfaces represented by graphs of differentiable functions) is trivially orientable. Thus, every surface is locally orientable, and orientation is deﬁnitely a global property in the sense that it involves the whole surface.

An orientation N on S induces an orientation on each tangent space T p (S) , p ∈ S , as follows. Deﬁne a basis { v,w } ⊂ T p (S) to be positive if   v ∧ w,N   is positive. It is easily seen that the set of all positive bases of T p (S) is an orientation for T p (S) (cf. Sec. 1-4).

Further details on the notion of orientation are given in Sec. 2-6. However, for the purpose of Chaps. 3 and 4, the present description will sufﬁce.

Throughout this chapter, S will denote a regular orientable surface in which an orientation (i.e., a differentiable ﬁeld of unit normal vectors N ) has been chosen; this will be simply called a surface S with an orientation N .

DEFINITION 1. Let S ⊂ R 3 be a surface with an orientation N . The map N: S → R 3 takes its values in the unit sphere

$$
S ^ { 2 } = \{ ( x , y , z ) \in R ^ { 3 } ; x ^ { 2 } + y ^ { 2 } + z ^ { 2 } = 1 \}
$$

The map N: S → S 2 , thus deﬁned, is called the Gauss map of S (Fig. 3-2). †

It is straightforward to verify that the Gauss map is differentiable. The differential dN p of N at p ∈ S is a linear map from T p (S) to T N(p) (S 2 ) . Since T p (S) and T N(p) (S 2 ) are the same vector spaces, dN p can be looked upon as a linear map on T p (S) .

The linear map dN p : T p (S) → T p (S) operates as follows. For each parametrized curve α(t) in S with α( 0 ) = p , we consider the parametrized curve N ◦ α(t) = N(t) in the sphere S 2 ; this amounts to restricting the normal vector N to the curve α(t) . The tangent vector N ′ ( 0 ) = dN p (α ′ ( 0 )) is a vector in T p (S) (Fig. 3-3). It measures the rate of change of the normal vector N , restricted to the curve α(t) , at t = 0. Thus, dN p measures how N pulls

†In italic context, letter symbols set in roman rather than italics.

[Page 155]

![In the diagram, there is a circle labeled as \( M \) with a center point labeled as \( \omega \). There are two points labeled as \( \alpha \) and \( \beta \) on the circumference of the circle.](<images/imageFile27.png>)

(

)

N

p

N

2

S

(

)

N

p

p

S

Figure 3-2. The Gauss map.

![image 28](<images/imageFile28.png>)

(

)

(

)

N

p

N

t

(0) = υ

aÄ

υ

p

(

)

a

t

Figure 3-3

Example 1. For a plane P given by ax + by + cz + d = 0, the unit normal vector N = (a,b,c)/ √ a 2 + b 2 + c 2 is constant, and therefore dN ≡ 0 (Fig. 3-4).

Example 2. Consider the unit sphere

$$
S ^ { 2 } = \{ ( x , y , z ) \in R ^ { 3 } ; x ^ { 2 } + y ^ { 2 } + z ^ { 2 } = 1 \} .
$$

If α(t) = (x(t),y(t),z(t)) is a parametrized curve in S 2 , then

$$
2 x x ^ { \prime } + 2 y y ^ { \prime } + 2 z z ^ { \prime } = 0 ,
$$

[Page 156]

![In the image there is a diagram with a curve.](<images/imageFile29.png>)

N

a

Figure 3-4. Plane: dN p = 0.

which shows that the vector (x,y,z) is normal to the sphere at the point (x,y,z) . Thus, ¯ N = (x,y,z) and N = ( − x, − y, − z) are ﬁelds of unit normal vectors in S 2 . We ﬁx an orientation in S 2 by choosing N = ( − x, − y, − z) as a normal ﬁeld. Notice that N points toward the center of the sphere.

Restricted to the curve α(t) , the normal vector

$$
N ( t ) = ( - x ( t ) , - y ( t ) , - z ( t ) )
$$

is a vector function of t , and therefore

$$
d N ( x ^ { \prime } ( t ) , y ^ { \prime } ( t ) , z ^ { \prime } ( t ) ) = N ^ { \prime } ( t ) = ( - x ^ { \prime } ( t ) , - y ^ { \prime } ( t ) , - z ^ { \prime } ( t ) ) ;
$$

that is, dN p (v) = − v for all p ∈ S 2 and all v ∈ T p (S 2 ) . Notice that with the choice of ¯ N as a normal ﬁeld (that is, with the opposite orientation) we would have obtained d ¯ N p (v) = v (Fig. 3-5).

![The image depicts a geometric figure involving a circle and several points. The circle is depicted as a closed arc with a central point labeled as point A. The points A, B, and C are located on the circumference of the circle. The points are connected by lines, and the lines intersect at points D and E. ### Points and Lines: - **A**: The point where the line segment AB intersects the circle. - **B**: The point where the line segment BC intersects the circle. - **C**: The point where the line segment AC intersects the circle. - **D**: The point where the line segment AD intersects the circle. - **E**: The point where the line segment AD intersects the circle. ### Points and Lines: - **A**: The point where the line segment AB intersects the circle. - **B**: The point where the line segment BC intersects the circle. - **C**: The point where the line](<images/imageFile30.png>)

-

N

p

υ

a

Figure 3-5. Unit sphere: d ¯ N p (v) = v .

[Page 157]

Example 3. Consider the cylinder { (x,y,z) ∈ R 3 ; x 2 + y 2 = 1 } . By an argument similar to that of the previous example, we see that ¯ N = (x,y, 0 ) and N = ( − x, − y, 0 ) are unit normal vectors at (x,y,z) . We ﬁx an orientation by choosing N = ( − x, − y, 0 ) as the normal vector ﬁeld. By considering a curve (x(t),y(t),z(t)) contained in the cylinder, that is,

with (x(t)) 2 + (y(t)) 2 = 1, we are able to see that, along this curve, N(t) = ( − x(t), − y(t), 0 ) and therefore

$$
d N ( x ^ { \prime } ( t ) , y ^ { \prime } ( t ) , z ^ { \prime } ( t ) ) & = N ^ { \prime } ( t ) = ( - x ^ { \prime } ( t ) , - y ^ { \prime } ( t ) , 0 ) . \\
$$

We conclude the following: If v is a vector tangent to the cylinder and parallel to the z axis, then

$$
d N ( v ) = 0 = 0 v ; \\
$$

if w is a vector tangent to the cylinder and parallel to the xy plane, then dN (w) = − w (Fig. 3-6). It follows that the vectors v and w are eigenvectors of dN with eigenvalues 0 and − 1, respectively (see the appendix to Chap. 3).

z

![In this image, we can see a diagram of a cylinder. There are two arrows on the diagram. We can see a line labeled as w and another line labeled as x. We can also see a point labeled as y.](<images/imageFile31.png>)

υ

w

N

y

Figure 3-6

x

Example 4. Let us analyze the point p = ( 0 , 0 , 0 ) of the hyperbolic paraboloid z = y 2 − x 2 . For this, we consider a parametrization x (u,v) given by 2 2

$$
\mathbf x ( u , v ) = ( u , v , v ^ { 2 } - u ^ { 2 } ) ,
$$

and compute the normal vector N(u,v) . We obtain successively

$$
\text {and compute the normal vector } N ( u , v ) . \text { We obtain successively } \\ x _ { u } = ( 1 , 0 , - 2 u ) , \\ x _ { v } = ( 0 , 1 , 2 v ) , \\ N = \left ( \frac { u } { \sqrt { u ^ { 2 } + v ^ { 2 } + \frac { 1 } { 4 } } } , \frac { - v } { \sqrt { u ^ { 2 } + v ^ { 2 } + \frac { 1 } { 4 } } } , \frac { 1 } { 2 \sqrt { u ^ { 2 } + v ^ { 2 } + \frac { 1 } { 4 } } } \right ) .
$$

[Page 158]

Notice that at p = ( 0 , 0 , 0 ) x u and x v agree with the unit vectors along the x and y axes, respectively. Therefore, the tangent vector at p to the curve α(t) = x (u(t),v(t)) , with α( 0 ) = p , has, in R 3 , coordinates (u ′ ( 0 ),v ′ ( 0 ), 0 ) (Fig. 3-7). Restricting N(u,v) to this curve and computing N ′ ( 0 ) , we obtain

$$
N ^ { \prime } ( 0 ) = ( 2 u ^ { \prime } ( 0 ) , - 2 v ^ { \prime } ( 0 ) , 0 ) ,
$$

z

![The image consists of a geometric figure with a series of intersecting lines and points. Here is a detailed description of the image: ### Description: #### Objects in the Image: 1. **Points and Lines**: - There are two intersecting lines in the image. - The lines are labeled as **I** and **J**. - The points are labeled as **A** and **B**. - The lines are labeled as **A** and **B** respectively. 2. **Intersecting Lines**: - The lines intersect at points **A** and **B**. - The intersection points are labeled as **A** and **B**. 3. **Geometric Properties**: - The lines are parallel and intersect at points **A** and **B**. - The points are labeled as **A** and **B**. 4. **Geometric Properties**: - The lines are parallel and intersect at points **A** and](<images/imageFile32.png>)

y

x

and therefore, at p ,

Figure 3-7

$$
d N _ { p } ( u ^ { \prime } ( 0 ) , v ^ { \prime } ( 0 ) , 0 ) = ( 2 u ^ { \prime } ( 0 ) , - 2 v ^ { \prime } ( 0 ) , 0 ) .
$$

It follows that the vectors ( 1 , 0 , 0 ) and ( 0 , 1 , 0 ) are eigenvectors of dN p with eigenvalues 2 and − 2, respectively.

Example 5. The method of the previous example, applied to the point p = ( 0 , 0 , 0 ) of the paraboloid z = x 2 + ky 2 , k > 0, shows that the unit vectors of the x axis and the y axis are eigenvectors of dN p , with eigenvalues 2 and 2 k , respectively (assuming that N is pointing outwards from the region bounded by the paraboloid).

An important fact about dN p is contained in the following proposition.

PROPOSITION 1. The differential dN p : T p ( S ) → T p ( S ) of the Gauss map is a self-adjoint linear map (cf. the appendix to Chap. 3) .

Proof . Since dN p is linear, it sufﬁces to verify that   dN p (w 1 ),w 2   =   w 1 , dN p (w 2 )   for a basis { w 1 ,w 2 } of T p (S) . Let x (u,v) be a parametrization of S at p and { x u , x v } the associated basis of T p (S) . If α(t) = x (u(t),v(t)) is a parametrized curve in S , with α( 0 ) = p , we have

$$
d N _ { p } ( \alpha ^ { \prime } ( 0 ) ) & = d N _ { p } ( x _ { u } u ^ { \prime } ( 0 ) + x _ { v } v ^ { \prime } ( 0 ) ) \\ & = \frac { d } { d t } N ( u ( t ) , v ( t ) ) \Big | _ { t = 0 } \\ & = N _ { u } u ^ { \prime } ( 0 ) + N _ { v } v ^ { \prime } ( 0 ) ;
$$

[Page 159]

in particular, dN p ( x u ) = N u and dN p ( x v ) = N v . Therefore, to prove that dN p is self-adjoint, it sufﬁces to show that

$$
\langle N _ { u } , \mathbf x _ { v } \rangle = \langle \mathbf x _ { u } , N _ { v } \rangle . \\
$$

To sec this, take the derivatives of   N, x u   = 0 and   N, x v   = 0, relative to v and u , respectively, and obtain

$$
N _ { v } , \mathbf x _ { u } \rangle + \langle N , \mathbf x _ { u v } \rangle = 0 ,
$$

$$
\langle N _ { v } , \mathbf x _ { u } \rangle + \langle N , \mathbf x _ { u v } \rangle & = 0 , \\ \langle N _ { u } , \mathbf x _ { v } \rangle + \langle N , \mathbf x _ { v u } \rangle & = 0 .
$$

$$
\langle N _ { u } , \mathbf x _ { v } \rangle + \langle N , \mathbf x _ { v u } \rangle = 0 .
$$

Thus, Remark. The normal curvature of C does not depend on the orientation of C but changes sign with a change of orientation for the surface.

$$
\langle N _ { u } , \mathbf x _ { v } \rangle = - \langle N , \mathbf x _ { u v } \rangle = \langle N _ { v } , \mathbf x _ { u } \rangle .
$$

The fact that dN p : T p (S) → T p (S) is a self-adjoint linear map allows us to associate to dN p a quadratic form Q in T p (S) , given by Q(v) =   dN p (v),v   , v ∈ T p (S) (cf. the appendix to Chap. 3). To obtain a geometric interpretation of this quadratic form, we need a few deﬁnitions. For reasons that will be clear shortly, we shall use the quadratic form − Q .

DEFINITION 2. The quadratic form II p , deﬁned in T p ( S ) by II p ( v ) = −  dN p ( v ), v   is called the second fundamental form of S at p .

DEFINITION 3. Let C be a regular curve in S passing through p ∈ S , k the curvature of C at p , and cos θ =   n , N   , where n is the normal vector to C and N is the normal vector to S at p . The number k n = k cos θ is then called the normal curvature of C ⊂ S at p .

In other words, k n is the length of the projection of the vector kn over the normal to the surface at p , with a sign given by the orientation N of S at p (Fig. 3-8).

![In the diagram, there is a right triangle labeled as \( \triangle ABC \). The length of the hypotenuse \( \triangle ABC \) is \( 2 \sqrt{3} \). The lengths of the two sides of the triangle are \( \sqrt{3} \) and \( 2 \sqrt{3} \). The angle \( \angle C \) is a right angle. The line segment \( \overline{BC} \) is drawn from the point \( \triangle ABC \) to the right side of the hypotenuse \( \triangle ABC \). The line segment \( \overline{BC} \) is perpendicular to the line segment \( \overline{BC} \) and intersects the line segment \( \overline{BC} \) at point \( \overline{K} \).](<images/imageFile33.png>)

N

q

p

k n

C

n

kn

S

[Page 160]

To give an interpretation of the second fundamental form II p , consider a regular curve C ⊂ S parametrized by α(s) , where s is the arc length of C , and with α( 0 ) = p . If we denote by N(s) the restriction of the normal vector N to the curve α(s) , we have   N(s),α ′ (s)   = 0. Hence,

$$
\langle N ( s ) , \alpha ^ { \prime \prime } ( s ) \rangle = - \langle N ^ { \prime } ( s ) , \alpha ^ { \prime } ( s ) \rangle .
$$

Therefore,

$$
I I _ { p } ( \alpha ^ { \prime } ( 0 ) ) & = - \langle d N _ { p } ( \alpha ^ { \prime } ( 0 ) ) , \alpha ^ { \prime } ( 0 ) \rangle \\ & = - \langle N ^ { \prime } ( 0 ) , \alpha ^ { \prime } ( 0 ) \rangle = \langle N ( 0 ) , \alpha ^ { \prime \prime } ( 0 ) \rangle \\ & = \langle N , k n \rangle ( p ) = k _ { n } ( p ) . \\ \intertext { r o w r d s } \text {w r d} \, \L a r { v e c h o l f o r } \, I I _ { p } ( 0 ) & = k _ { n } ( p ) . \\ \intertext { s u r w d s } \text {w r d} \, \L a r { v e c h o l f o r } \, I I _ { p } ( 0 ) & = k _ { n } ( p ) .
$$

In other words, the value of the second fundamental form II p for a unit vector v ∈ T p (S) is equal to the normal curvature of a regular curve passing through p and tangent to v . In particular, we obtained the following result.

PROPOSITION 2 (Meusnier). All curves lying on a surface S and having at a given point p ∈ S the same tangent line have at this point the same normal curvatures.

The above proposition allows us to speak of the normal curvature along a given direction at p. It is convenient to use the following terminology. Given a unit vector v ∈ T p (S) , the intersection of S with the plane containing v and N(p) iscalledthe normalsection of S at p along v (Fig. 3-9). Inaneighborhood of p , a normal section of S at p is a regular plane curve on S whose normal vector n at p is ± N(p) or zero; its curvature is therefore equal to the absolute value of the normal curvature along v at p . With this terminology, the above

![In this image, we can see a diagram with a diagram of a triangle. There is a point labeled as P. We can see a line labeled as N. We can see a point labeled as C. We can see a line labeled as E. We can see a point labeled as A. We can see a line labeled as B. We can see a point labeled as D. We can see a line labeled as E. We can see a point labeled as F. We can see a line labeled as V. We can see a point labeled as V. We can see a line labeled as V. We can see a point labeled as V. We can see a line labeled as V. We can see a point labeled as V. We can see a line labeled as V. We can see a point labeled as V. We can see a line labeled as V. We can see a point labeled as V. We can see a line labeled as V. We can see a point](<images/imageFile34.png>)

N

p

υ

C

C n

Figure 3-9. Meusnier theorem: C and C n have the same normal curvature at p along v .

Normal section at p

along υ

p

υ

[Page 161]

Example 6. Consider the surface of revolution obtained by rotating the curve z = y 4 about the z axis (Fig. 3-10). We shall show that at p = ( 0 , 0 , 0 ) the differential dN p = 0. To see this, we observe that the curvature of the curve z = y 4 at p is equal to zero. Moreover, since the xy plane is a tangent plane to the surface at p , the normal vector N(p) is parallel to the z axis. Therefore, any normal section at p is obtained from the curve z = y 4 by rotation; hence, it has curvature zero. It follows that all normal curvatures are zero at p , and thus dN p = 0.

![The image depicts a geometric diagram with two parallel lines labeled as \( x \) and \( y \). The line \( x \) is drawn horizontally and the line \( y \) is drawn vertically. Both lines are parallel to each other. The diagram includes two points labeled as \( x \) and \( y \). These points are located on the horizontal line \( x \) and the vertical line \( y \). The line \( x \) is drawn from point \( x \) to point \( y \). The line \( y \) is drawn from point \( y \) to point \( x \). The diagram also includes two lines labeled as \( x \) and \( y \). These lines are parallel to each other. The diagram includes two points labeled as \( x \) and \( y \). These points are located on the horizontal line \(](<images/imageFile35.png>)

z

4

N

z

y

=

y

0

x

Figure 3-10

Example 7. In the plane of Example 1, all normal sections are straight lines; hence, all normal curvatures are zero. Thus, the second fundamental form is identically zero at all points. This agrees with the fact that dN ≡ 0. In the sphere S 2 of Example 2, with N as orientation, the normal sections

through a point p ∈ S 2 are circles with radius 1 (Fig. 3-11). Thus, all normal curvatures are equal to 1, and the second fundamental form is II p (v) = 1 for all p ∈ S 2 and all v ∈ T p (S) with | v | = 1.

![image 36](<images/imageFile36.png>)

N

p

2

S

[Page 162]

![image 37](<images/imageFile37.png>)

p

Figure 3-12. Normal sections on a cylinder.

However, an application of the theorem on quadratic forms of the appendix to Chap. 3 gives a simple proof of that. In fact, as we have seen in Example 3, the vectors w and v (corresponding to the directions of the normal curvatures 1 and 0, respectively) are eigenvectors of dN p with eigenvalues − 1 and 0, respectively. Thus, the second fundamental form takes up its extreme values in these vectors, as we claimed. Notice that this procedure allows us to check that such extreme values are l and 0.

We leave it to the reader to analyze the normal sections at the point p = ( 0 , 0 , 0 ) of the hyperbolic paraboloid of Example 4.

Let us come back to the linear map dN p . The theorem of the appendix to Chap. 3 shows that for each p ∈ S there exists an orthonormal basis { e 1 ,e 2 } of T p (S) such that dN p (e 1 ) = − k 1 e 1 , dN p (e 2 ) = − k 2 e 2 . Moreover, k 1 and k 2 (k 1 ≥ k 2 ) are the maximum and minimum of the second fundamental form II p restricted to the unit circle of T p (S) ; that is, they are the extreme values of the normal curvature at p .

DEFINITION 4. The maximum normal curvature k 1 and the minimum normalcurvature k 2 arecalledthe principalcurvatures at p ; thecorresponding directions, that is, the directions given by the eigenvectors e 1 , e 2 , are called principal directions at p .

For instance, in the plane all directions at all points are principal directions. The same happens with a sphere. In both cases, this comes from the fact that the second fundamental form at each point, restricted to the unit vectors, is constant (cf. Example 7); thus, all directions are extremals for the normal curvature.

[Page 163]

DEFINITION 5. If a regular connected curve C on S is such that for all p ∈ C the tangent line of C is a principal direction at p , then C is said to be a line of curvature of S .

PROPOSITION 3 (Olinde Rodrigues). A necessary and sufﬁcient condition for a connected regular curve C on S to be a line of curvature of S is that

$$
N ^ { \prime } ( t ) = \lambda ( t ) \alpha ^ { \prime } ( t ) ,
$$

for any parametrization α( t ) of C , where N ( t ) = N ◦ α( t ) and λ( t ) is a differentiable function of t . In this case, − λ( t ) is the ( principal ) curvature along α ′ ( t ) .

Proof . It sufﬁces to observe that if α ′ (t) is contained in a principal direction, then α ′ (t) is an eigenvector of dN and

$$
d N ( \alpha ^ { \prime } ( t ) ) = N ^ { \prime } ( t ) = \lambda ( t ) \alpha ^ { \prime } ( t ) .
$$

The converse is immediate.

Q.E.D.

The knowledge of the principal curvatures at p allows us to compute easily the normal curvature along a given direction of T p (S) . In fact, let v ∈ T p (S) with | v | = 1. Since e 1 and e 2 form an orthonormal basis of T p (S) , we have

| | = 1 2

$$
v = e _ { 1 } \cos \theta + e _ { 2 } \sin \theta ,
$$

where θ is the angle from e 1 to v in the orientation of T p (S) . The normal curvature k n along v is given by

$$
k _ { n } & = I I _ { p } ( v ) = - \langle d N _ { p } ( v ) , v \rangle \\ & = - \langle d N _ { p } ( e _ { 1 } \cos \theta + e _ { 2 } \sin \theta ) , \, e _ { 1 } \cos \theta + e _ { 2 } \sin \theta \rangle \\ & = \langle e _ { 1 } k _ { 1 } \cos \theta + e _ { 2 } k _ { 2 } \sin \theta , \, e _ { 1 } \cos \theta + e _ { 2 } \sin \theta \rangle \\ & = k _ { 1 } \cos ^ { 2 } \theta + k _ { 2 } \sin ^ { 2 } \theta . \\ \intertext { l e a t h s c r . } \text {last expression is known classically as the } F u l l a r \, f o r m u l g \colon \text { actually }
$$

The last expression is known classically as the Euler formula ; actually, it is just the expression of the second fundamental form in the basis { e 1 ,e 2 } .

[Page 164]

Given a linear map A : V → V of a vector space of dimension 2 and given a basis { v 1 ,v 2 } of V , we recall that

$$
\det \min { a _ { 1 1 } a _ { 2 2 } - a _ { 1 2 } a _ { 2 1 } } , \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

where (a ij ) is the matrix of A in the basis { v 1 ,v 2 } . It is known that these numbers do not depend on the choice of the basis { v 1 ,v 2 } and are, therefore, attached to the linear map A .

In our case, the determinant of dN is the product ( − k 1 )( − k 2 ) = k 1 k 2 of the principal curvatures, and the trace of dN is the negative − (k 1 + k 2 ) of the sum of principal curvatures. If we change the orientation of the surface, the determinant does not change (the fact that the dimension is even is essential here); the trace, however, changes sign.

DEFINITION 6. Let p ∈ S and let dN p : T p ( S ) → T p ( S ) be the differential of the Gauss map. The determinant of dN p is the Gaussian curvature K of S at p . The negative of half of the trace of dN p is called the mean curvature H of S at p .

In terms of the principal curvatures we can write

$$
K = k _ { 1 } k _ { 2 } , \ \ H = \frac { k _ { 1 } + k _ { 2 } } { 2 } .
$$

DEFINITION 7. A point of a surface S is called

- 1. Elliptic if det ( dN p ) > 0 .
- 2. Hyperbolic if det ( dN p ) < 0 .
- 3. Parabolic if det ( dN p ) = 0 , with dN p  = 0 . 4. Planar if dN p 0 .


Planar if dNp = 0 .

It is clear that this classiﬁcation does not depend on the choice of the orientation.

At an elliptic point the Gaussian curvature is positive. Both principal curvatures have the same sign, and therefore all curves passing through this point have their normal vectors pointing toward the same side of the tangent plane. The points of a sphere are elliptic points. The point (0, 0, 0) of the paraboloid z = x 2 + ky 2 , k > 0 (cf. Example 5), is also an elliptic point. At a hyperbolic point, the Gaussian curvature is negative. The principal

curvatures have opposite signs, and therefore there are curves through p whose normal vectors at p point toward any of the sides of the tangent plane at p . The point (0, 0, 0) of the hyperbolic paraboloid z = y 2 − x 2 (cf. Example 4) is a hyperbolic point.

At a parabolic point, the Gaussian curvature is zero, but one of the principal curvatures is not zero. The points of a cylinder (cf. Example 3) are parabolic points.

[Page 165]

Finally, at a planar point, all principal curvatures are zero. The points of a plane trivially satisfy this condition. A nontrivial example of a planar point was given in Example 6.

DEFINITION 8. If at p ∈ S , k 1 = k 2 , then p is called an umbilical point of S; in particular, the planar points ( k 1 = k 2 = 0 ) are umbilical points.

All the points of a sphere and a plane are umbilical points. Using the method of Example 6, we can verify that the point (0, 0, 0) of the paraboloid z = x 2 + y 2 is a (nonplanar) umbilical point. We shall now prove the interesting fact that the only surfaces made up

We shall now prove the interesting fact that the only surfaces made up entirely of umbilical points are essentially spheres and planes.

PROPOSITION 4. If all points of a connected surface S are umbilical points, then S is either contained in a sphere or in a plane.

Proof . Let p ∈ S and let x (u,v) be a parametrization of S at p such that the coordinate neighborhood V is connected.

Since each q ∈ V is an umbilical point, we have, for any vector w = a 1 x u + a 2 x v in T q (S) , dN (w) = λ(q)w,

$$
d N ( w ) = \lambda ( q ) w ,
$$

where λ = λ(q) is a real differentiable function in V . We ﬁrst show that λ(q) is constant in V . For that,

We first show that λ(q) is constant in V . For that, we write the above equation as

$$
N _ { u } a _ { 1 } + N _ { v } a _ { 2 } = \lambda ( { \mathbf x } _ { u } a _ { 1 } + { \mathbf x } _ { v } a _ { 2 } ) ;
$$

hence, since w is arbitrary,

$$
N _ { u } & = \lambda x _ { u } , \\ N _ { v } & = \lambda x _ { v } . \\
$$

Differentiatingtheﬁrstequationin v andthesecondonein u andsubtracting the resulting equations, we obtain

$$
\lambda _ { u } x _ { v } - \lambda _ { v } x _ { u } = 0 .
$$

Since x u and x v are linear independent, we conclude that

$$
\lambda _ { u } = \lambda _ { v } = 0
$$

for all q ∈ V . Since V is connected, λ is constant in V , as we claimed. If λ ≡ 0, N u = N v = 0 and therefore N = N 0 = constant in V .

If λ ≡ 0, Nu = Nv = 0 and therefore N = N 0 = constant in V . Thus, 〈 x (u, v), N 0 〉 u = 〈 x (u, v), N 0 〉 v = 0; hence,

$$
\langle x ( u , v ) , N _ { 0 } \rangle = \text {const} ,
$$

and all points x (u,v) of V belong to a plane.

[Page 166]

If λ  = 0, then the point x (u,v) − ( 1 /λ)N(u,v) = y (u,v) is ﬁxed, because

$$
\left ( \mathbf x ( u , v ) - \frac { 1 } { \lambda } N ( u , v ) \right ) _ { u } = \left ( \mathbf x ( u , v ) - \frac { 1 } { \lambda } N ( u , v ) \right ) _ { v } = 0 .
$$

Since

$$
| x ( u , v ) - y | ^ { 2 } = \frac { 1 } { \lambda ^ { 2 } } ,
$$

all points of V are contained in a sphere of center y and radius 1 / | λ | . This proves the proposition locally, that is, for a neighborhood of

a point p ∈ S . To complete the proof we observe that, since S is connected, given any otherpoint r ∈ S , thereexistsacontinuouscurve α :[0 , 1] → S with α( 0 ) = p , α( 1 ) = r . For each point α(t) ∈ S of this curve there exists a neighborhood V t in S contained in a sphere or in a plane and such that α − 1 (V t ) is an open interval of [0 , 1]. The union   α − 1 (V t ) , t ∈ [0 , 1], covers [0 , 1] and since [0 , 1] is a closed interval, it is covered by ﬁnitely many elements of the family { α − 1 (V t ) } (cf. the Heine-Borel theorem, Prop. 6 of the appendix to Chap. 2). Thus, α( [0 , 1] ) is covered by a ﬁnite number of the neighborhoods V t .

If the points of one of these neighborhoods are on a plane, all the others will be on the same plane. Since r is arbitrary, all the points of S belong to this plane.

If the points of one of these neighborhoods are on a sphere, the same argument shows that all points on S belong to a sphere, and this completes the proof. Q.E.D.

DEFINITION 9. Let p be a point in S . An asymptotic direction of S at p is a direction of T p ( S ) for which the normal curvature is zero. An asymptotic curve of S is a regular connected curve C ⊂ S such that for each p ∈ C the tangent line of C at p is an asymptotic direction.

It follows at once from the deﬁnition that at an elliptic point there are no asymptotic directions.

A useful geometric interpretation of the asymptotic directions is given by means of the Dupin indicatrix, which we shall now describe.

Let p be a point in S . The Dupin indicatrix at p is the set of vectors w of T p (S) such that II p (w) = ± 1. TowritetheequationsoftheDupinindicatrixinamoreconvenientform,let

(ξ,η) be the Cartesian coordinates of T p (S) in the orthonormal basis { e 1 ,e 2 } , where e 1 and e 2 are eigenvectors of dN p . Given w ∈ T p (S) , let ρ and θ

[Page 167]

be “polar coordinates” deﬁned by w = ρv , with | v | = 1 and v = e 1 cos θ + e 2 sin θ , if ρ  = 0. By Euler’s formula,

$$
\pm 1 = I I _ { p } ( w ) & = p ^ { 2 } I I _ { p } ( v ) \\ & = k _ { 1 } \rho ^ { 2 } \cos ^ { 2 } \theta + k _ { 2 } \rho ^ { 2 } \sin ^ { 2 } \theta \\ & = k _ { 1 } \xi ^ { 2 } + k _ { 2 } \eta ^ { 2 } , \\ \xi e _ { \ } + n e _ { \ } T h u s \, \text { the coordinates } ( \xi _ { \ } n ) \text { of a point of }
$$

where w = ξe 1 + ηe 2 . Thus, the coordinates (ξ,η) of a point of the Dupin indicatrix satisfy the equation

$$
k _ { 1 } \xi ^ { 2 } + k _ { 2 } \eta ^ { 2 } = \pm 1 ;
$$

hence, the Dupin indicatrix is a union of conics in T p (S) . We notice that the normal curvature along the direction determined by w is k n (v) = II p (v) = ± ( 1 /ρ 2 ) . For an elliptic point, the Dupin indicatrix is an ellipse ( k 1 and k 2 have the

For an elliptic point, the Dupin indicatrix is an ellipse ( k 1 and k 2 have the same sign); this ellipse degenerates into a circle if the point is an umbilical nonplanar point (k 1 = k 2 /negationslash= 0 ) .

is therefore made up of two hyperbolas with a common pair of asymptotic lines (Fig. 3-13).Along the directions of the asymptotes, the normal curvature is zero; they are therefore asymptotic directions. This justiﬁes the terminology and shows that a hyperbolic point has exactly two asymptotic directions.

![image 38](<images/imageFile38.png>)

e

2

e

2

q

r

q

r

p

p

e

1

e

1

Elliptic point

Hyperbolic point

Figure 3-13. The Dupin indicatrix.

For a parabolic point, one of the principal curvatures is zero, and the Dupin indicatrix degenerates into a pair of parallel lines. The common direction of these lines is the only asymptotic direction at the given point.

InExample5ofSec. 3-3weshallshowaninterestingpropertyoftheDupin indicatrix.

Closely related with the concept of asymptotic direction is the concept of conjugate directions, which we shall now deﬁne.

DEFINITION 10. Let p be a point on a surface S . Two nonzero vectors w 1 , w 2 ∈ T p ( S ) are conjugate if   dN p ( w 1 ), w 2   =   w 1 , dN p ( w 2 )   = 0 .

[Page 168]

Two directions r 1 , r 2 at p are conjugate if a pair of nonzero vectors w 1 , w 2 parallel to r 1 and r 2 , respectively, are conjugate.

It is immediate to check that the deﬁnition of conjugate directions does not depend on the choice of the vectors w 1 and w 2 on r 1 and r 2 .

It follows from the deﬁnition that the principal directions are conjugate and that an asymptotic direction is conjugate to itself. Furthermore, at a nonplanar umbilic, every orthogonal pair of directions is a pair of conjugate directions, and at a planar umbilic each direction is conjugate to any other direction.

Let us assume that p ∈ S is not an umbilical point, and let { e 1 ,e 2 } be the orthonormal basis of T p (S) determined by dN p (e 1 ) = − k 1 e 1 , dN p (e 2 ) = − k 2 e 2 . Let θ and ϕ be the angles that a pair of directions r 1 and r 2 make with e 1 . We claim that r 1 and r 2 are conjugate if and only if

$$
k _ { 1 } \cos \theta \cos \varphi = - k _ { 2 } \sin \theta \sin \varphi .
$$

In fact, r 1 and r 2 are conjugate if and only if the vectors

$$
w _ { 1 } = e _ { 1 } \cos \theta + e _ { 2 } \sin \theta , \quad w _ { 2 } = e _ { 1 } \cos \varphi + e _ { 2 } \sin \varphi
$$

are conjugate. Thus,

$$
0 = \langle d N _ { p } ( w _ { 1 } ) , w _ { 2 } \rangle = - k _ { 1 } \cos \theta \cos \varphi - k _ { 2 } \sin \theta \sin \varphi .
$$

Hence, condition (2) follows.

When both k 1 and k 2 are nonzero (i.e., p is either an elliptic or a hyperbolic point), condition (2) leads to a geometric construction of conjugate directions in terms of the Dupin indicatrix at p . We shall describe the construction at an elliptic point, the situation at a hyperbolic point being similar. Let r be a straight line through the origin of T p (S) and consider the intersection points q 1 , q 2 of r with the Dupin indicatrix (Fig. 3-14). The tangent lines of the

![In the diagram, there is a circle labeled as circle \( \omega \) with a center point \( \omega \) at the top of the circle. The circle is divided into two parts by two radii \( r_1 \) and \( r_2 \). The center of the circle is located at the intersection of the two radii.](<images/imageFile39.png>)

r

q

1

r'

e

2

j

q

e

1

q

2

Figure 3-14. Construction of conjugate directions.

[Page 169]

# EXERCISES

- 1. Show that at a hyperbolic point, the principal directions bisect the asymptotic directions.
- 2. Show that if a surface is tangent to a plane along a curve, then the points of this curve are either parabolic or planar.
- 3. Let C ⊂ S be a regular curve on a surface S with Gaussian curvature K > 0. Show that the curvature k of C at p satisﬁes


$$
| k | \geq \min ( | k _ { 1 } | , | k _ { 2 } | ) ,
$$

where k 1 and k 2 are the principal curvatures of S at p .

4. Assume that a surface S has the property that | k 1 | ≤ 1, | k 2 | ≤ 1 everywhere. Is it true that the curvature k of a curve on S also satisﬁes | k | ≤ 1? 5. Show that the mean curvature H at p S is given by

Show that the mean curvature H at p ∈ S is given by

$$
H & = \frac { 1 } { \pi } \int _ { 0 } ^ { \pi } k _ { n } ( \theta ) \, d \theta , \\ \\
$$

where k n (θ) is the normal curvature at p along a direction making an angle θ with a ﬁxed direction.

6. Show that the sum of the normal curvatures for any pair of orthogonal directions, at a point p ∈ S , is constant. 7. Show that if the mean curvature is zero at a nonplanar point, then this

Show that if the mean curvature is zero at a nonplanar point, then this point has two orthogonal asymptotic directions.

8. Describe the region of the unit sphere covered by the image of the Gauss map of the following surfaces:

Paraboloid of revolution z = x 2 + y 2 .

Hyperboloid of revolution x 2 + y 2 -z 2 = 1.

Catenoid x 2 + y 2 = cosh 2 z .

Prove that

a. The image N ◦ α by the Gauss map N : S → S 2 of a parametrized regular curve α : I → S which contains no planar or parabolic points is a parametrized regular curve on the sphere S 2 (called the spherical image of α ).

[Page 170]

b. If C = α(I) is a line of curvature, and k is its curvature at p , then

$$
k = | k _ { n } k _ { N } | ,
$$

where k n is the normal curvature at p along the tangent line of C and k N is the curvature of the spherical image N(C) ⊂ S 2 at N(p) . Assume that the osculating plane of a line of curvature , which

- 10. C ⊂ S is nowhere tangent to an asymptotic direction, makes a constant angle with the tangent plane of S along C . Prove that C is a plane curve.
- 11. Let p be an elliptic point of a surface S , and let r and r ′ be conjugate directions at p . Let r vary in T p (S) and show that the minimum of the angle of r with r ′ is reached at a unique pair of directions in T p (S) that are symmetric with respect to the principal directions.
- 12. Let p be a hyperbolic point of a surface S , and let r be a direction in T p (S) . Describeandjustifyageometricconstructiontoﬁndtheconjugate direction r ′ of r in terms of the Dupin indicatrix (cf. the construction at the end of Sec. 3-2).


*13. ( Theorem of Beltrami-Enneper. ) Prove that the absolute value of the torsion τ at a point of an asymptotic curve, whose curvature is nowhere zero, is given by √

$$
| \tau | = \sqrt { - K } ,
$$

where K is the Gaussian curvature of the surface at the given point.

*14. If the surface S 1 intersects the surface S 2 along the regular curve C , then the curvature k of C at p ∈ C is given by 2 2 2 2

$$
k ^ { 2 } \sin ^ { 2 } \theta = \lambda _ { 1 } ^ { 2 } + \lambda _ { 2 } ^ { 2 } - 2 \lambda _ { 1 } \lambda _ { 2 } \cos \theta , \\
$$

where λ 1 and λ 2 are the normal curvatures at p , along the tangent line to C , of S 1 and S 2 , respectively, and θ is the angle made up by the normal vectors of S 1 and S 2 at p .

15. ( Theorem of Joachimstahl. ) Suppose that S 1 and S 2 intersect along a regular curve C and make an angle θ(p) , p ∈ C .Assume that C is a line of curvature of S 1 . Prove that θ(p) is constant if and only if C is a line of curvature of S 2 .

*16. Show that the meridians of a torus are lines of curvature.

17. Show that if H ≡ 0 on S and S has no planar points, then the Gauss map N : S → S 2 has the following property:

$$
\langle d N _ { p } ( w _ { 1 } ) , d N _ { p } ( w _ { 2 } ) \rangle = - K ( p ) \langle w _ { 1 } , w _ { 2 } \rangle \\
$$

for all p ∈ S and all w 1 ,w 2 ∈ T p (S) . Show that the above condition implies that the angle of two intersecting curves on S and the angle of their spherical images (cf. Exercise 9) are equal up to a sign.

[Page 171]

*18. Let λ 1 ,...,λ m be the normal curvatures at p ∈ S along directions making angles 0 , 2 π/m,...,(m − 1 ) 2 π/m with a principal direction, m > 2. Prove that

$$
\lambda _ { 1 } + \dots + \lambda _ { m } = m H ,
$$

where H is the mean curvature at p .

*19. Let C ⊂ S be a regular curve in S . Let p ∈ C and α(s) be a parametrization of C in p by arc length so that α( 0 ) = p . Choose in T p (S) an orthonormal positive basis { t,h } , where t = α ′ ( 0 ) . The geodesic torsion τ g of C ⊂ S at p is deﬁned by

$$
\tau _ { g } = \left \langle \frac { d N } { d s } ( 0 ) , h \right \rangle .
$$

Prove that

- a. τ g = (k 1 − k 2 ) cos ϕ sin ϕ , where ϕ is the angle from e 1 to t and t is the unit tangent vector corresponding to the principal curvature k 1 .
- b. If τ is the torsion of C , n is the (principal) normal vector of C and cos θ =   N,n   , then dθ τ τ .

$$
\frac { d \theta } { d s } = \tau - \tau _ { g } .
$$

- c. The lines of curvature of S are characterized by having geodesic torsion identically zero.


*20. ( Dupin’s Theorem. ) Three families of surfaces are said to form a triply orthogonal system in an open set U ⊂ R 3 if a unique surface of each familypassesthrougheachpoint p ∈ U andifthethreesurfacesthatpass through p are pairwise orthogonal. Use part c of Exercise 19 to prove Dupin’s theorem: The surfaces of a triply orthogonal system intersect each other in lines of curvature .

# 3-3. The Gauss Map in Local Coordinates

In the preceding section, we introduced some concepts related to the local behavior of the Gauss map. To emphasize the geometry of the situation, the deﬁnitions were given without the use of a coordinate system. Some simple examples were then computed directly from the deﬁnitions; this procedure, however, is inefﬁcient in handling general situations. In this section, we shall obtaintheexpressionsofthesecondfundamentalformandofthedifferentialof theGaussmapinacoordinatesystem.Thiswillgiveusasystematicmethodfor computingspeciﬁcexamples. Moreover, thegeneralexpressionsthusobtained are essential for a more detailed investigation of the concepts introduced above.

[Page 172]

All parametrizations x : U ⊂ R 2 → S considered in this section are assumed to be compatible with the orientation N of S ; that is, in x (U) ,

$$
N = \frac { { \mathbf x } _ { u } \wedge { \mathbf x } _ { v } } { | { \mathbf x } _ { u } \wedge { \mathbf x } _ { v } | } .
$$

$$
-
$$

Let x (u, v) be a parametrization at a point p ∈ S of a surface S , and let α(t) = x (u(t),v(t)) beaparametrizedcurveon S , with α( 0 ) = p . Tosimplify the notation, we shall make the convention that all functions to appear below denote their values at the point p .

The tangent vector to α(t) at p is α ′ = x u u ′ + x v v ′ and

$$
d N ( \alpha ^ { \prime } ) = N ^ { \prime } ( u ( t ) , v ( t ) ) = N _ { u } u ^ { \prime } + N _ { v } v ^ { \prime } .
$$

$$
-
$$

Since N u and N v belong to T p (S) , we may write

and therefore,

$$
N _ { u } & = a _ { 1 1 } x _ { u } + a _ { 2 1 } x _ { v } , \\ N _ { v } & = a _ { 1 2 } x _ { u } + a _ { 2 2 } x _ { v } ,
$$

hence,

$$
d N ( \alpha ^ { \prime } ) = ( a _ { 1 1 } u ^ { \prime } + a _ { 1 2 } v ^ { \prime } ) \mathbf x _ { u } + ( a _ { 2 1 } u ^ { \prime } + a _ { 2 2 } v ^ { \prime } ) \mathbf x _ { v } ;
$$

$$
d N \left ( _ { v ^ { \prime } } ^ { u ^ { \prime } } \right ) = \begin{pmatrix} a _ { 1 1 } & a _ { 1 2 } \\ a _ { 2 1 } & a _ { 2 2 } \end{pmatrix} \left ( _ { v ^ { \prime } } ^ { u ^ { \prime } } \right ) .
$$

This shows that in the basis { x u , x v } , dN is given by the matrix (a ij ) , i,j = 1 , 2. Notice that this matrix is not necessarily symmetric, unless { x u , x v } is an orthonormal basis. On the other hand, the expression of the second fundamental form in the

On the other hand, the expression of the second fundamental form in the basis { x u , x v } is given by

$$
I I _ { p } ( \alpha ^ { \prime } ) & = - \langle d N ( \alpha ^ { \prime } ) , \alpha ^ { \prime } \rangle = - \langle N _ { u } u ^ { \prime } + N _ { v } v ^ { \prime } , \mathbf x _ { u } u ^ { \prime } + \mathbf x _ { v } v ^ { \prime } \rangle \\ & = e ( u ^ { \prime } ) ^ { 2 } + 2 f u ^ { \prime } v ^ { \prime } + g ( v ^ { \prime } ) ^ { 2 } ,
$$

where, since   N, x u   =   N, x v   = 0,

$$
e & = - \langle N _ { u } , x _ { u } \rangle = \langle N , x _ { u u } \rangle , \\ f & = - \langle N _ { v } , x _ { u } \rangle = \langle N , x _ { u v } \rangle = \langle N , x _ { v u } \rangle = - \langle N _ { u } , x _ { v } \rangle , \\ g & = - \langle N _ { v } , x _ { v } \rangle = \langle N , x _ { v v } \rangle .
$$

[Page 173]

We shall now obtain the values of a ij in terms of the coefﬁcients e,f,g . From Eq. (1), we have

$$
- f & = \langle N _ { u } , \mathbf x _ { v } \rangle = a _ { 1 1 } F + a _ { 2 1 } G , \\ - f & = \langle N _ { v } , \mathbf x _ { u } \rangle = a _ { 1 2 } E + a _ { 2 2 } F , \\ - e & = \langle N _ { u } , \mathbf x _ { u } \rangle = a _ { 1 1 } E + a _ { 2 1 } F , \\ - g & = \langle N _ { v } , \mathbf x _ { v } \rangle = a _ { 1 2 } F + a _ { 2 2 } G , \\
$$

where E,F , and G are the coefﬁcients of the ﬁrst fundamental form in the basis { x u , x v } (cf. Sec. 2-5). Relations (2) may be expressed in matrix form by

$$
- \begin{pmatrix} e & f \\ f & g \end{pmatrix} = \begin{pmatrix} a _ { 1 1 } & a _ { 2 1 } \\ a _ { 1 2 } & a _ { 2 2 } \end{pmatrix} \begin{pmatrix} E & F \\ F & G \end{pmatrix} ;
$$

hence, or From Eq. (3) we immediately obtain

$$
\begin{pmatrix} a _ { 1 1 } & a _ { 2 1 } \\ a _ { 1 2 } & a _ { 2 2 } \end{pmatrix} = - \begin{pmatrix} e & f \\ f & g \end{pmatrix} \begin{pmatrix} E & F \\ F & G \end{pmatrix} ^ { - 1 } ,
$$

where ( ) − 1 means the inverse matrix of ( ). It is easily checked that

$$
\begin{pmatrix} E & F \\ F & G \end{pmatrix} ^ { - 1 } = \frac { 1 } { E G - F ^ { 2 } } \begin{pmatrix} G & - F \\ - F & E \end{pmatrix} ,
$$

whence the following expressions for the coefﬁcients (a ij ) of the matrix of dN in the basis { x u , x v } :

$$
a _ { 1 1 } & = \frac { \ f F - e G } { E G - F ^ { 2 } } , \\ a _ { 1 2 } & = \frac { g F - f G } { E G - F ^ { 2 } } , \\ a _ { 2 1 } & = \frac { e F - f E } { E G - F ^ { 2 } } , \\ a _ { 2 2 } & = \frac { \ f F - g E } { E G - F ^ { 2 } } .
$$

For completeness, it should be mentioned that relations (1), with the above values, are known as the equations of Weingarten .

[Page 174]

$$
K = \det ( a _ { i j } ) = \frac { e g - f ^ { 2 } } { E G - F ^ { 2 } } . \\
$$

To compute the mean curvature, we recall that − k 1 , − k 2 are the eigenvalues of dN . Therefore, k 1 and k 2 satisfy the equation

$$
d N ( v ) = - k v = - k I v \quad \text {for some } v \in T _ { p } ( S ) , v \neq 0 ,
$$

where I is the identity map. It follows that the linear map dN + kI is not invertible; hence, it has zero determinant. Thus,

$$
\det \left ( \begin{matrix} a _ { 1 1 } + k & a _ { 1 2 } \\ a _ { 2 1 } & a _ { 2 2 } + k \end{matrix} \right ) = 0
$$

$$
k ^ { 2 } + k ( a _ { 1 1 } + a _ { 2 2 } ) + a _ { 1 1 } a _ { 2 2 } - a _ { 2 1 } a _ { 1 2 } = 0 .
$$

Since k 1 and k 2 are the roots of the above quadratic equation, we conclude that

$$
H & = \frac { 1 } { 2 } ( k _ { 1 } + k _ { 2 } ) = - \frac { 1 } { 2 } ( a _ { 1 1 } + a _ { 2 2 } ) = \frac { 1 } { 2 } \frac { e G - 2 f F + g E } { E G - F ^ { 2 } } ; \\
$$

hence,

$$
k ^ { 2 } - 2 H k + K = 0 ,
$$

and therefore,

$$
k = H \pm \sqrt { H ^ { 2 } - K } . \\ \intertext { o n , \text { it follows that if we choose } k _ { 1 } ( q ) \geq k _ { 2 } ( q ) , \ q \in S , }
$$

From this relation, it follows that if we choose k 1 (q) ≥ k 2 (q) , q ∈ S , then the functions k 1 and k 2 are continuous in S . Moreover, k 1 and k 2 are differentiable in S , except perhaps at the umbilical points (H 2 = K) of S . In the computations of this chapter, it will be convenient to write for short

In the computations of this chapter, it will be convenient to write for short

$$
\langle u \wedge v , w \rangle = ( u , v , w ) \quad \text {for any } u , v , w \in R ^ { 3 } .
$$

We recall that this is merely the determinant of the 3 × 3 matrix whose columns (or lines) are the components of the vectors u,v,w in the canonical basis of R 3 .

Example 1. We shall compute the Gaussian curvature of the points of the torus covered by the parametrization (cf. Example 6 of Sec. 2-2)

[Page 175]

x

$$
\mathbf x ( u , v ) = ( ( a + r \cos u ) \cos v , ( a + r \cos u ) \sin v , r \sin u ) , \\ 0 < u < 2 \pi , \quad 0 < v < 2 \pi .
$$

For the computation of the coefﬁcients e,f,g , we need to know N (and thus x u and x v ), x uu , x uv , and x vv :

x u = ( − r sin u cos v, − r sin u sin v,r cos u), x v = ( − (a + r cos u) sin v,(a + r cos u) cos v, 0 ), x uu = ( − r cos u cos v, − r cos u sin v, − r sin u), x uv = (r sin u sin v, − r sin u cos v, 0 ), x vv = ( − (a + r cos u) cos v, − (a + r cos u) sin v, 0 ).

vv = ( -(a + r u) v, -(a + r u) v,

From these, we obtain

$$
E & = \langle x _ { u } , x _ { u } \rangle = r ^ { 2 } , \quad F = \langle x _ { u } , x _ { v } \rangle = 0 , \\ G & = \langle x _ { v } , x _ { v } \rangle = ( a + r \cos u ) ^ { 2 } .
$$

$$
^ { \prime } _ { 2 } =
$$

$$
G = \langle x _ { v } , x _ { v } \rangle = ( a + r \cos u ) ^ { 2 } .
$$

Introducing the values just obtained in e =   N, x uu   , we have, since | x u ∧ x v | = √ EG − F 2 ,

$$
e = \left \langle \frac { \mathbf x _ { u } \wedge \mathbf x _ { v } } { | \mathbf x _ { u } \wedge \mathbf x _ { v } | } , \mathbf x _ { u u } \right \rangle = \frac { ( \mathbf x _ { u } , \mathbf x _ { v } , \mathbf x _ { u u } ) } { \sqrt { E G - F ^ { 2 } } } = \frac { r ^ { 2 } ( a + r \cos u ) } { r ( a + r \cos u ) } = r . \\
$$

Similarly, we obtain

$$
( x _ { u } , x _ { v } , x _ { u v }
$$

$$
f & = \frac { ( x _ { u } , x _ { v } , x _ { u v } ) } { r ( a + r \cos u ) } = 0 , \\ g & = \frac { ( x _ { u } , x _ { v } , x _ { v v } ) } { r ( a + r \cos u ) } = \cos u ( a + r \cos u ) . \\ \intertext { c e r } K = ( e e - f ^ { 2 } ) / ( F G - F ^ { 2 } ) \text { we have that }
$$

$$
u ) .
$$

Finally, since K = ( eg − f 2 )/( EG − F 2 ) , we have that

$$
K = \frac { \cos u } { r ( a + r \cos u ) } . \\ \cdot _ { s f u }
$$

From this expression, it follows that K = 0 along the parallels u = π/ 2 and u = 3 π/ 2; the points of such parallels are therefore parabolic points. In the region of the torus given by π/ 2 < u < 3 π/ 2, K is negative (notice that r > 0 and a > r ); the points in this region are therefore hyperbolic points. In the region given by 0 < u < π/ 2 or 3 π/ 2 < u < 2 π , the curvature is positive and the points are elliptic points (Fig. 3-15).

As an application of the expression for the second fundamental form in coordinates, we shall prove a proposition which gives information about the

[Page 176]

![The image depicts a diagram involving a circular and a square-like object. The diagram is labeled as Rotation Axis and Generating Circle. The diagram is divided into two parts: the left side and the right side. **Left Side:** - The left side of the diagram shows a circle labeled K with a radius of 0. - The center of the circle is marked as K=0. - The center of the circle is marked as K0. - The center of the circle is marked as T. - The center of the circle is marked as T0. - The center of the circle is marked as T. - The center of the circle is marked as T0. - The center of the circle is marked as T. - The center of the circle is marked as T0. - The center of the circle is marked as](<images/imageFile40.png>)

Rotation axis

axis

Generating circle

circle

0

0

K < 0

K = 0

p

0

0

K > 0

0

K < 0

K > 0

T

(

)

T p (

T

0

K = 0

Figure 3-15

position of a surface in the neighborhood of an elliptic or a hyperbolic point, relative to the tangent plane at this point. For instance, if we look at an elliptic point of the torus of Example 1, we ﬁnd that the surface lies on one side of the tangent plane at such a point (see Fig. 3-15). On the other hand, if p is a hyperbolic point of the torus T and V ⊂ T is any neighborhood of p , we can ﬁnd points of V on both sides of T p (S) , however small V may be. This example reﬂects a general local fact that is described in the following proposition.

PROPOSITION 1. Let p ∈ S be an elliptic point of a surface S . Then there exists a neighborhood V of p in S such that all points in V belong to the same side of the tangent plane T p ( S ) . Let p ∈ S be a hyperbolic point. Then in each neighborhood of p there exist points of S in both sides of T p ( S ) .

Proof . Let x (u,v) be a parametrization in p , with x ( 0 , 0 ) = p . The distance d from a point q = x (u,v) to the tangent plane T p (S) is given by (Fig. 3-16)

$$
d = \langle x ( u , v ) - x ( 0 , 0 ) , N ( p ) \rangle .
$$

Since x (u,v) is differentiable, we have Taylor’s formula:

$$
x ( u , v ) = x ( 0 , 0 ) + x _ { u } u + x _ { v } v + \frac { 1 } { 2 } ( x _ { u u } u ^ { 2 } + 2 x _ { u v } u v + x _ { v v } v ^ { 2 } ) + \bar { R } ,
$$

where the derivatives are taken at ( 0 , 0 ) and the remainder ¯ R satisﬁes the condition

$$
\lim _ { ( u , v ) \to ( 0 , 0 ) } \frac { \bar { R } } { u ^ { 2 } + v ^ { 2 } } = 0 .
$$

[Page 177]

![In the diagram, there is a right triangle labeled as \( \triangle ABC \) with the right angle at point \( P \). The base of the triangle is \( \text{base} = 2 \) and the height is \( \text{height} = 2 \) units. The base of the triangle is \( \text{base} = 2 \) and the height is \( \text{height} = 2 \) units. The point \( P \) is the midpoint of the base \( \text{base} = 2 \) and the point \( Q \) is the midpoint of the base \( \text{base} = 2 \) and the point \( R \) is the midpoint of the base \( \text{base} = 2 \) and the point \( S \) is the midpoint of the base \( \](<images/imageFile41.png>)

S

(

)

N

p

x(

)

u,υ

x(0,0)

p

d

(

)

T p

S

Figure 3-16

It follows that

$$
d & = \langle x ( u , v ) - x ( 0 , 0 ) , \, N ( p ) \rangle \\ & = \frac { 1 } { 2 } \{ x _ { u v } , \, N ( p ) \rangle u ^ { 2 } + 2 \langle x _ { u v } , \, N ( p ) \rangle u v + \langle x _ { v v } , \, N ( p ) \rangle v ^ { 2 } \} + R \\ & = \frac { 1 } { 2 } ( e u ^ { 2 } + 2 f u v + g v ^ { 2 } ) + R = \frac { 1 } { 2 } I I _ { p } ( w ) + R , \\
$$

where w = x u u + x v v , R =   ¯ R,N(p)   , and lim w → 0 (R/ | w | 2 ) = 0. For an elliptic point p, II p (w) has a ﬁxed sign. Therefore, for

all (u,v) sufﬁciently near p , d has the same sign as II p (w) ; that is, all such (u,v) belong to the same side of T p (S) .

For a hyperbolic point p , in each neighborhood of p there exist points (u,v) and ( ¯ u, ¯ v) such that II p (w/ | w | ) and II p ( ¯ w/ | ¯ w | ) have opposite signs (here ¯ w = x u ¯ u + x v ¯ v ); such points belong therefore to distinct sides of T p (S) . Q.E.D.

No such statement as Prop. 1 can be made in a neighborhood of a parabolic or a planar point. In the above examples of parabolic and planar points (cf. Examples 3 and 6 of Sec. 3-2) the surface lies on one side of the tangent plane and may have a line in common with this plane. In the following examples we shall show that an entirely different situation may occur.

Example 2. The “monkey saddle” (see Fig. 3-17) is given by

$$
x = u , \ \ y = v , \ \ z = u ^ { 3 } - 3 v ^ { 2 } u .
$$

Adirect computation shows that at ( 0 , 0 ) the coefﬁcients of the second fundamental form are e = f = g = 0; the point ( 0 , 0 ) is therefore a planar point. In any neighborhood of this point, however, there are points in both sides of its tangent plane.

[Page 178]

z

![The image depicts two diagrams, labeled as Figure 3-17 and Figure 3-18, both illustrating the same set of waveforms. Both diagrams have a similar structure, with a series of interconnected lines and points. The diagram on the left is labeled as Figure 3-17, and the diagram on the right is labeled as Figure 3-18. ### Diagram 3-17: #### Diagram 3-17: - **Title:** The title of the diagram is Figure 3-17. - **Description:** The diagram shows a series of interconnected lines and points. The lines are labeled as x, y, and z. - **Diagram 3-17:** The diagram shows a series of interconnected lines and points. The lines are labeled as x, y, and z. - **Diagram 3-18:** The diagram shows](<images/imageFile42.png>)

z

1

z = 1

y

3

y

z = y 3

x

x

Figure 3-17

Figure 3-18

Example 3. Consider the surface obtained by rotating the curve z = y 3 , − 1 < z < 1, about the line z = 1 (see Fig. 3-18).Asimple computation shows that the points generated by the rotation of the origin O are parabolic points. We shall omit this computation, because we shall prove shortly (Example 4) that the parallels and the meridians of a surface of revolution are lines of curvature; this, together with the fact that, for the points in question, the meridians (curves of the form y = x 3 ) have zero curvature and the parallel is a normal section, will imply the above statement.

Notice that in any neighborhood of such a parabolic point there exist points in both sides of the tangent plane.

The expression of the second fundamental form in local coordinates is particularly useful for the study of the asymptotic and principal directions. We ﬁrst look at the asymptotic directions.

Let x (u,v) be a parametrization at p ∈ S , with x ( 0 , 0 ) = p , and let e(u,v) = e , f(u,v) = f , and g(u,v) = g be the coefﬁcients of the second fundamental form in this parametrization.

We recall that (see Def. 9 of Sec. 3-2) a connected regular curve C in the coordinate neighborhood of x is an asymptotic curve if and only if for any parametrization α(t) = x (u(t),v(t)) , t ∈ I , of C we have II (α ′ (t)) = 0, for all t ∈ I , that is, if and only if 2 2

$$
e ( u ^ { \prime } ) ^ { 2 } + 2 f u ^ { \prime } v ^ { \prime } + g ( v ^ { \prime } ) ^ { 2 } = 0 , \quad t \in I . \\ \\ e ( u ^ { \prime } ) ^ { 2 } + 2 f u ^ { \prime } v ^ { \prime } + g ( v ^ { \prime } ) ^ { 2 } = 0 , \quad t \in I .
$$

Because of that, Eq. (7) is called the differential equation of the asymptotic curves. In the next section we shall give a more precise meaning to this expression. For the time being, we want to draw from Eq. (7) only the following useful conclusion: A necessary and sufﬁcient condition for a parametrization in a neighborhood of a hyperbolic point (eg − f 2 < 0) to be such that

[Page 179]

= = Infact, ifbothcurves u = const . , v = v(t) and u = u(t) , v = const . satisfy Eq. (7), we obtain e = g = 0. Conversely, if this last condition holds and f  = 0, Eq. (7) becomes fu ′ v ′ = 0, which is clearly satisﬁed by the coordinate lines.

We shall now consider the principal directions, maintaining the notations already established.

A connected regular curve C in the coordinate neighborhood of x is a line of curvature if and only if for any parametrization α(t) = x (u(t),v(t)) of C , t ∈ I , we have (cf. Prop. 3 of Sec. 3-2)

$$
d N ( \alpha ^ { \prime } ( t ) ) = \lambda ( t ) \alpha ^ { \prime } ( t ) .
$$

It follows that the functions u ′ (t),v ′ (t) satisfy the system of equations

$$
\frac { \ f F - e G } { E G - F ^ { 2 } } u ^ { \prime } + \frac { g F - f G } { E G - F ^ { 2 } } v ^ { \prime } & = \lambda u ^ { \prime } , \\ \frac { e F - f E } { E G - F ^ { 2 } } u ^ { \prime } + \frac { \ f F - g E } { E G - F ^ { 2 } } v ^ { \prime } & = \lambda v ^ { \prime } .
$$

$$
\frac { e F - f E } { E G - F ^ { 2 } } u ^ { \prime } + \frac { f F - g E } { E G - F ^ { 2 } } v ^ { \prime } = \lambda v ^ { \prime } . \\
$$

By eliminating λ in the above system, we obtain the differential equation of the lines of curvature ,

$$
( f E - e F ) ( u ^ { \prime } ) ^ { 2 } + ( g E - e G ) u ^ { \prime } v ^ { \prime } + ( g F - f G ) ( v ^ { \prime } ) ^ { 2 } = 0 ,
$$

which may be written, in a more symmetric way, as

$$
\begin{vmatrix} ( v ^ { \prime } ) ^ { 2 } & - u ^ { \prime } v ^ { \prime } & ( u ^ { \prime } ) ^ { 2 } \\ E & F & G \\ e & f & g \end{vmatrix} & = 0 . & & ( 8 ) \\ \intertext { t h a t h e p r i c p i a l d i c r i o n s a r e o r t h o g n a l $ 2 $ }
$$

  e f g   Using the fact that the principal directions are orthogonal to each other, it follows easily from Eq. (8) that a necessary and sufﬁcient condition for the coordinate curves of a parametrization to be lines of curvature in a neighborhood of a nonumbilical point is that F = f = 0.

Example 4 ( Surfaces of Revolution ). Consider a surface of revolution parametrized by (cf. Example 4 of Sec. 2-3; we have replaced f and g by ϕ and ψ , respectively)

$$
\mathbf x ( u , v ) = ( \varphi ( v ) \cos u , \varphi ( v ) \sin u , \psi ( v ) ) , \\ 0 < u < 2 \pi , \quad a < v < b , \quad \varphi ( v ) \neq 0 .
$$

[Page 180]

The coefﬁcients of the ﬁrst fundamental form are given by

$$
E = \varphi ^ { 2 } , \ \ F = 0 , \ \ G = ( \varphi ^ { \prime } ) ^ { 2 } + ( \psi ^ { \prime } ) ^ { 2 } .
$$

It is convenient to assume that the rotating curve is parametrized by arc length, that is, that

$$
( \varphi ^ { \prime } ) ^ { 2 } + ( \psi ^ { \prime } ) ^ { 2 } = G = 1 .
$$

The computation of the coefﬁcients of the second fundamental form is straightforward and yields

$$
e & = \frac { ( x _ { u } , x _ { v } , x _ { u u } ) } { \sqrt { E G - F ^ { 2 } } } = \frac { 1 } { \sqrt { E G - F ^ { 2 } } } \left | \begin{array} { c c c } - \varphi \sin u & \varphi ^ { \prime } \cos u & - \varphi \cos u \\ \varphi \cos u & \varphi ^ { \prime } \sin u & - \varphi \sin u \\ 0 & \psi ^ { \prime } & 0 \end{array} \right | \\ & = - \varphi \psi ^ { \prime } \\ & f = 0 , \\ & g = \psi ^ { \prime } \varphi ^ { \prime \prime } - \psi ^ { \prime \prime } \varphi ^ { \prime } . \\ & \text {Since } F = f = 0 , \text { we conclude that the parallels (v = const.) and the merid-}
$$

Since F = f = 0, we conclude that the parallels ( v = const .) and the meridians ( u = const . ) of a surface of revolution are lines of curvature of such a surface (this fact was used in Example 3).

Because

$$
K = \frac { e g - f ^ { 2 } } { E G - F ^ { 2 } } = - \frac { \psi ^ { \prime } ( \psi ^ { \prime } \varphi ^ { \prime \prime } - \psi ^ { \prime \prime } \varphi ^ { \prime } ) } { \varphi }
$$

and ϕ is always positive, it follows that the parabolic points are given by either ψ ′ = 0 (the tangent line to the generator curve is perpendicular to the axis of rotation) or ϕ ′ ψ ′′ − ψ ′ ϕ ′′ = 0 (the curvature of the generator curve is zero). Apoint which satisﬁes both conditions is a planar point, since these conditions imply that e = f = g = 0. It is convenient to put the Gaussian curvature in still another form. By

differentiating (ϕ ′ ) 2 + (ψ ′ ) 2 = 1 we obtain ϕ ′ ϕ ′′ = − ψ ′ ψ ′′ . Thus,

$$
K = - \frac { \psi ^ { \prime } ( \psi ^ { \prime } \varphi ^ { \prime \prime } - \psi ^ { \prime \prime } \varphi ^ { \prime } ) } { \varphi } = - \frac { ( \psi ^ { \prime } ) ^ { 2 } \varphi ^ { \prime \prime } + ( \varphi ^ { \prime } ) ^ { 2 } \varphi ^ { \prime \prime } } { \varphi } = - \frac { \varphi ^ { \prime \prime } } { \varphi } .
$$

Equation (9) is a convenient expression for the Gaussian curvature of a surface of revolution. It can be used, for instance, to determine the surfaces of revolution of constant Gaussian curvature (cf. Exercise 7).

To compute the principal curvatures, we first make the following general observation: If a parametrization of a regular surface is such that F = f = 0, then the principal curvatures are given by e/E and g/G . In fact, in this case, the Gaussian and the mean curvatures are given by (cf. Eqs. (4) and (5))

[Page 181]

$$
K = \frac { e g } { E G } , \ H = \frac { 1 } { 2 } \frac { e G + g E } { E G } .
$$

Since K is the product and 2 H is the sum of the principal curvatures, our assertion follows at once.

Thus, the principal curvatures of a surface of revolution are given by

$$
\frac { e } { E } = - \frac { \psi ^ { \prime } \varphi } { \varphi ^ { 2 } } = - \frac { \psi ^ { \prime } } { \varphi } , \quad \frac { g } { G } = \psi ^ { \prime } \varphi ^ { \prime \prime } - \psi ^ { \prime \prime } \varphi ^ { \prime } ;
$$

hence, the mean curvature of such a surface is

$$
H = \frac { 1 } { 2 } \frac { - \psi ^ { \prime } + \varphi ( \psi ^ { \prime } \varphi ^ { \prime \prime } - \psi ^ { \prime \prime } \varphi ^ { \prime } ) } { \varphi } .
$$

Example 5. Very often a surface is given as the graph of a differentiable function (cf. Prop. 1, Sec. 2-2) z = h(x,y) , where (x,y) belong to an open set U ⊂ R 2 . It is, therefore, convenient to have at hand formulas for the relevant concepts in this case. To obtain such formulas let us parametrize the surface by

$$
\mathbf x ( u , v ) = ( u , v , h ( u , v ) ) , \ \ ( u , v ) \in U ,
$$

where u = x , v = y . A simple computation shows that

$$
\mathbf x _ { u } = ( 1 , 0 , h _ { u } ) , \quad \mathbf x _ { v } = ( 0 , 1 , h _ { v } ) , \quad \mathbf x _ { u u } = ( 0 , 0 , h _ { u u } ) , \\ \mathbf x _ { u v } = ( 0 , 0 , h _ { u u } ) , \quad \mathbf x _ { v v } = ( 0 , 0 , h _ { v v } ) .
$$

Thus

$$
N ( x , y ) = \frac { ( - h _ { x } , - h _ { y } , 1 ) } { ( 1 + h _ { x } ^ { 2 } + h _ { y } ^ { 2 } ) ^ { 1 / 2 } }
$$

is a unit normal ﬁeld on the surface, and the coefﬁcients of the second fundamental form in this orientation are given by

$$
e & = \frac { h _ { x x } } { ( 1 + h _ { x } ^ { 2 } + h _ { y } ^ { 2 } ) ^ { 1 / 2 } } , \\ f & = \frac { h _ { x y } } { ( 1 + h _ { x } ^ { 2 } + h _ { y } ^ { 2 } ) ^ { 1 / 2 } } , \\ g & = \frac { h _ { y y } } { ( 1 + h _ { x } ^ { 2 } + h _ { y } ^ { 2 } ) ^ { 1 / 2 } } .
$$

[Page 182]

From the above expressions, any needed formula can be easily computed. For instance, from Eqs. (4) and (5) we obtain the Gaussian and mean curvatures:

$$
K & = \frac { h _ { x x } h _ { y y } - h _ { x y } ^ { 2 } } { ( 1 + h _ { x } ^ { 2 } + h _ { y } ^ { 2 } ) ^ { 2 } } , \\ 2 H & = \frac { ( 1 + h _ { x } ^ { 2 } ) h _ { y y } - 2 h _ { x } h _ { y } h _ { x y } + ( 1 + h _ { y } ^ { 2 } ) h _ { x x } } { ( 1 + h _ { x } ^ { 2 } + h _ { y } ^ { 2 } ) ^ { 3 / 2 } } . \\ \intertext { i s t i l a n o t h e r p a n g s m o r e i n t a n t e r a s o n t s u d y }
$$

There is still another, perhaps more important, reason to study surfaces given by z = h(x,y) . It comes from the fact that locally any surface is the graph of a differentiable function (cf. Prop. 3, Sec. 2-2). Given a point p of a surface S , we can choose the coordinate axis of R 3 so that the origin O of the coordinates is at p and the z axis is directed along the positive normal of S at p (thus, the xy plane agrees with T p (S) ). It follows that a neighborhood of p in S can be represented in the form z = h(x,y) , (x,y) ∈ U ⊂ R 2 , where U is an open set and h is a differentiable function (cf. Prop. 3, Sec. 2-2), with h( 0 , 0 ) = 0, h x ( 0 , 0 ) = 0, h y ( 0 , 0 ) = 0 (Fig. 3-19).

![In this image, we can see a diagram with a diagram of a cone. We can also see a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line, a line, a point, a line,](<images/imageFile43.png>)

z

x

0

S

y

0

y

y

z

0

Figure 3-19. Each point of S has aneighborhoodthatcanbewritten as z = h(x,y) .

x

x

z

The second fundamental form of S at p applied to the vector (x,y) ∈ R 2 becomes, in this case,

$$
h _ { x x } ( 0 , 0 ) x ^ { 2 } + 2 h _ { x y } ( 0 , 0 ) x y + h _ { y y } ( 0 , 0 ) y ^ { 2 } .
$$

In elementary calculus of two variables, the above quadratic form is known as the Hessian of h at ( 0 , 0 ) . Thus, the Hessian of h at ( 0 , 0 ) is the second fundamental form of S at p .

Let us apply the above considerations to give a geometric interpretation of the Dupin indicatrix. With the notation as above, let ǫ > 0 be a small number such that

[Page 183]

$$
C = \{ ( x , y ) \in T _ { p } ( S ) ; h ( x , y ) = \epsilon \}
$$

is a regular curve (we may have to change the orientation of the surface to achieve ǫ > 0). We want to show that if p is not a planar point, the curve C is “approximately” similar to the Dupin indicatrix of S at p (Fig. 3-20).

![In the image there is a diagram of a plane parallel to a cone. The cone is placed on a surface. There is a point labeled as P. There is a plane parallel to the cone. There is a point labeled as S.](<images/imageFile44.png>)

p

p

S

A plane parallel to T

(

)

T

S

p

p

S

Figure 3-20

To see this, let us assume further that the x and y axes are directed along the principal directions, with the x axis along the direction of maximum principal curvature. Thus, f = h xy ( 0 , 0 ) = 0 and

$$
k _ { 1 } ( p ) = \frac { e } { E } = h _ { x x } ( 0 , 0 ) , \quad k _ { 2 } ( p ) = \frac { g } { G } = h _ { y y } ( 0 , 0 ) .
$$

By developing h(x,y) into a Taylor’s expansion about ( 0 , 0 ) , and taking into account that h x ( 0 , 0 ) = 0 = h y ( 0 , 0 ) , we obtain

$$
h ( x , y ) & = \frac { 1 } { 2 } ( h _ { x x } ( 0 , 0 ) x ^ { 2 } + 2 h _ { x y } ( 0 , 0 ) x y + h _ { y y } ( 0 , 0 ) y ^ { 2 } ) + R \\ & = \frac { 1 } { 2 } ( k _ { 1 } x ^ { 2 } + k _ { 2 } y ^ { 2 } ) + R ,
$$

where

$$
\lim _ { ( x , y ) \to ( 0 , 0 ) } \frac { R } { x ^ { 2 } + y ^ { 2 } } = 0 .
$$

[Page 184]

Thus, the curve C is given by

$$
k _ { 1 } x ^ { 2 } + k _ { 2 } y ^ { 2 } + 2 R = 2 \epsilon .
$$

Now, if p is not a planar point, we can consider k 1 x 2 + k 2 y 2 = 2 ǫ as a ﬁrst-order approximation of C in a neighborhood of p . By using the similarity transformation, √ √

$$
x = \bar { x } \sqrt { 2 \epsilon } , \ \ y = \bar { y } \sqrt { 2 \epsilon } ,
$$

we have that k 1 x 2 + k 2 y 2 = 2 ǫ is transformed into the curve

$$
k _ { 1 } \bar { x } ^ { 2 } + k _ { 2 } \bar { y } ^ { 2 } = 1 ,
$$

which is the Dupin indicatrix at p . This means that if p is a nonplanar point, the intersection with S of a plane parallel to T p ( S ) and close to p is, in a ﬁrst-order approximation, a curve similar to the Dupin indicatrix at p.

If p is a planar point, this interpretation is no longer valid (cf. Exercise 11).

To conclude this section we shall give a geometrical interpretation of the Gaussian curvature in terms of the Gauss map N : S → S 2 . Actually, this was how Gauss himself introduced this curvature.

To do this, we ﬁrst need a deﬁnition.

Let S and ¯ S be two oriented regular surfaces. Let ϕ : S → ¯ S be a differentiable map and assume that for some p ∈ S , dϕ p is nonsingular. We say that ϕ is orientation-preserving at p if given a positive basis { w 1 ,w 2 } in T p (S) , then { dϕ p (w 1 ),dϕ p (w 2 ) } is a positive basis in T ϕ(p) ( ¯ S) . If { dϕ p (w 1 ),dϕ p (w 2 ) } is not a positive basis, we say that ϕ is orientation-reversing at p . 2 3

We now observe that both S and the unit sphere S are embedded in R . Thus, an orientation N on S induces an orientation N in S 2 . Let p ∈ S be such that dN p is nonsingular. Since for a basis { w 1 ,w 2 } in T p (S)

$$
d N _ { p } ( w _ { 1 } ) \wedge d N _ { p } ( w _ { 2 } ) = \det ( d N _ { p } ) ( w _ { 1 } \wedge w _ { 2 } ) = K w _ { 1 } \wedge w _ { 2 } ,
$$

the Gauss map N will be orientation-preserving at p ∈ S if K(p) > 0 and orientation-reversing at p ∈ S if K(p) < 0. Intuitively, this means the following (Fig. 3-21): An orientation of T p (S) induces an orientation of small closed curves in S around p ; the image by N of these curves will have the same or the opposite orientation to the initial one, depending on whether p is an elliptic or hyperbolic point, respectively.

To take this fact into account we shall make the convention that the area of the image by N of a region contained in a connected neighborhood V ⊂ S where K  = 0ispositiveif K > 0andnegativeif K < 0(since V isconnected, K does not change sign in V ).

Now we can state the promised geometric interpretation of the Gaussian curvature K , for K  = 0.

[Page 185]

4

![In this diagram, we can see a diagram of a circle. There are three points labeled as A, B and C. We can see a line labeled as O. We can see a point labeled as N. We can see a line labeled as V. We can see a point labeled as S. We can see a line labeled as E. We can see a point labeled as P. We can see a line labeled as W. We can see a point labeled as T. We can see a line labeled as T. We can see a point labeled as R. We can see a line labeled as R. We can see a point labeled as S. We can see a line labeled as S. We can see a point labeled as T. We can see a line labeled as T. We can see a point labeled as R. We can see a line labeled as R. We can see a point labeled as S. We can see a line labeled as S. We can see a](<images/imageFile45.png>)

1

2

4

3

3

2

1

0

N

4

2

3

1

0

N

4

2

3

1

Figure 3-21. The Gauss map preserves orientation at an elliptic point and reverses it at a hyperbolic point.

PROPOSITION 2. Let p be a point of a surface S such that the Gaussian curvature K ( p )  = 0 , and let V be a connected neighborhood of p where K does not change sign. Then

$$
K ( p ) = \lim _ { A \to 0 } \frac { A ^ { \prime } } { A } ,
$$

where A is the area of a region B ⊂ V containing p , A ′ is the area of the image of B by the Gauss map N: S → S 2 , and the limit is taken through a sequence of regions B n that converges to p , in the sense that any sphere around p contains all B n , for n sufﬁciently large.

Proof . The area A of B is given by (cf. Sec. 2-5)

$$
A & = \iint _ { R } | \mathbf x _ { u } \wedge \mathbf x _ { v } | \, d u \, d v , \\ & \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \
$$

[Page 186]

$$
A ^ { \prime } = \iint _ { R } | N _ { u } \wedge N _ { v } | \, d u \, d v . \\ \intertext { a $ d f i n t i o n $ of } K a n d t h o w a n d o w o n
$$

Using Eq. (1), the deﬁnition of K , and the above convention, we can write

$$
A ^ { \prime } = \iint _ { R } K | \mathbf x _ { u } \wedge \mathbf x _ { v } | \, d u \, d v . \\ \iintertext { a n t e d o n t i n g a l l } \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

Going to the limit and denoting also by R the area of the region R , we obtain

$$
G o i g t o t h e l i m t a n d e n t o i n g a l s o b y K t h e a r e a t o r t h e r g i o n K , w e o b t a i n g \\ \lim _ { A \to 0 } \frac { A ^ { \prime } } { A } = \lim _ { R \to 0 } \frac { A ^ { \prime } / R } { A / R } = \frac { \lim _ { R \to 0 } ( 1 / R ) \iint _ { R } K | x _ { u } \wedge x _ { v } | \, d u \, d v } { \lim ( 1 / R ) \iint _ { R } | x _ { u } \wedge x _ { v } | \, d u \, d v } \\ = \frac { K | x _ { u } \wedge x _ { v } | } { | x _ { u } \wedge x _ { v } | } = K \\ \intertext { l i n c t i o n t h e a r e v a h e u s d e t h e m e n v a l u e r o m e r f o d o u b l e integrams , a n d } \colon & \quad \vdots ;
$$

(notice that we have used the mean value theorem for double integrals), and this proves the proposition. Q.E.D.

Remark. Comparing the proposition with the expression of the curvature

$$
k = \lim _ { s \to 0 } \frac { \sigma } { s } \\
$$

of a plane curve C at p (here s is the arc length of a small segment of C containing p , and σ isthearclengthofitsimageintheindicatrixoftangents; cf. Exercise 3 of Sec. 1-5), we see that the Gaussian curvature K is the analogue, for surfaces, of the curvature k of plane curves.

# EXERCISES

1. Show that at the origin ( 0 , 0 , 0 ) of the hyperboloid z = axy we have K = − a 2 and H = 0. *2. Determinetheasymptoticcurvesandthelinesofcurvatureofthehelicoid

x = v cos u , y = v sin u , z = cu , and show that its mean curvature is zero.

*3. Determine the asymptotic curves of the catenoid

$$
\mathbf x ( u , v ) = ( \cosh v \cos u , \cosh v \sin u , v ) . \\
$$

4. Determine the asymptotic curves and the lines of curvature of z = xy . 5. Consider the parametrized surface (Enneper’s surface)

Consider the parametrized surface (Enneper's surface)

$$
\mathbf x ( u , v ) = \left ( u - \frac { u ^ { 3 } } { 3 } + u v ^ { 2 } , v - \frac { v ^ { 3 } } { 3 } + v u ^ { 2 } , u ^ { 2 } - v ^ { 2 } \right )
$$

[Page 187]

and show that

- a. The coefﬁcients of the ﬁrst fundamental form are

$$
E = G = ( 1 + u ^ { 2 } + v ^ { 2 } ) ^ { 2 } , \ \ F = 0 .
$$

- b. The coefﬁcients of the second fundamental form are

$$
e = 2 , \ \ g = - 2 , \ \ f = 0 .
$$

- c. The principal curvatures are

$$
k _ { 1 } = \frac { 2 } { ( 1 + u ^ { 2 } + v ^ { 2 } ) ^ { 2 } } , \quad k _ { 2 } = - \frac { 2 } { ( 1 + u ^ { 2 } + v ^ { 2 } ) ^ { 2 } } . \\ \intertext { l e n s o f c u r v a t u r e a t h e a r d i n d e p a t e c u r v e s }
$$

- d. The lines of curvature are the coordinate curves.
- e. The asymptotic curves are u + v = const . , u − v = const . ( A Surface with 1; the Pseudosphere. )


( A Surface with K ≡ -1; the Pseudosphere. )

C , which is such that the segment of the tangent line between the point of tangency and some line r in the plane, which does not meet the curve, is constantly equal to 1 (this curve is called the tractrix ; see Fig. 1-9).

- b. Rotate the tractrix C about the line r ; determine if the “surface” of revolution thus obtained (the pseudosphere ; see Fig. 3-22) is regular and ﬁnd out a parametrization in a neighborhood of a regular point.
- c. Show that the Gaussian curvature of any regular point of the pseudosphere is − 1. ( Surfaces of Revolution with Constant Curvature. ) cos


7. (ϕ(v) u, ϕ(v) sin u,ψ(v)) , ϕ  = 0 is given as a surface of revolution with constant Gaussian curvature K . To determine the functions ϕ and ψ , choose the parameter v in such a way that (ϕ ′ ) 2 + (ψ ′ ) 2 = 1 (geometrically, this means that v is the arc length of the generating curve (ϕ(v),ψ(v))) . Show that

- a. ϕ satisﬁes ϕ ′′ + Kϕ = 0 and ψ is given by ψ =     1 − (ϕ ′ ) 2 dv ; thus, 0 < u < 2 π , and the domain of v is such that the last integral makes sense.
- b. All surfaces of revolution with constant curvature K = 1 which intersect perpendicularly the plane xOy are given by


$$
\varphi ( v ) = C \cos v , \quad \psi ( v ) = \int _ { 0 } ^ { v } \sqrt { 1 - C ^ { 2 } \sin ^ { 2 } v } \, d v , \\ \text {where } C \text { is a constant } ( C = \varphi ( 0 ) ) , \text { Determine the domain of } v \text { and }
$$

[Page 188]

![In this image we can see a diagram of a tower.](<images/imageFile46.png>)

Figure 3-22. The pseudosphere.

> 1

![image 47](<images/imageFile47.png>)

C

= 1

Rotation

C

< 1

axis

C

Figure 3-23

c. All surfaces of revolution with constant curvature K = − 1 may be given by one of the following types:

- 1. ϕ(v) = C cosh v , ψ(v) =   v 0   1 − C 2 sinh 2 v dv .
- 2. ϕ(v) = C sinh v , ψ(v) =   v 0   1 − C 2 cosh 2 v dv . 3. ϕ(v) = e v , ψ(v) =   v 0 √ 1 − e 2 v dv . Determine the domain of v and draw the surface in the xz plane.


Determine the domain of v and draw a rough sketch of the profile of the surface in the xz plane.

- d. The surface of type 3 in part c is the pseudosphere of Exercise 6.
- e. The only surfaces of revolution with K ≡ 0 are the right circular cylinder, the right circular cone, and the plane.


8. ( Contact of Order ≥ 2 of Surfaces .) Two surfaces S and ¯ S , with a common point p , have contact of order ≥ 2 at p if there exist parametrizations x (u,v) and ¯ x (u,v) in p of S and ¯ S , respectively, such that

$$
\mathbf x _ { u } = \bar { \mathbf x } _ { u } , \quad \mathbf x _ { v } = \bar { \mathbf x } _ { v } , \quad \mathbf x _ { u u } = \bar { \mathbf x } _ { u u } , \quad \mathbf x _ { u v } = \bar { \mathbf x } _ { u v } , \quad \mathbf x _ { v v } = \bar { \mathbf x } _ { v v }
$$

[Page 189]

at p . Prove the following:

*a. Let S and ¯ S have contact of order ≥ 2 at p ; x : U → S and ¯ x : U → ¯ S be arbitrary parametrizations in p of S and ¯ S , respectively; and f : V ⊂ R 3 → R be a differentiable function in a neighborhood V of p in R 3 . Then the partial derivatives of order ≤ 2 of f ◦ ¯ x : U → R are zero in ¯ x − 1 (p) if and only if the partial derivatives of order ≤ 2 of f ◦ x : U → R are zero in x − 1 (p) . *b. Let S and ¯ S have contact of order 2 at p . Let z f (x,y) ,

≥ = z = ¯ f (x,y) be the equations, in a neighborhood of p , of S and ¯ S , respectively, where the xy plane is the common tangent plane at p = ( 0 , 0 ) . Then the function f (x,y) − ¯ f (x,y) has all partial derivatives of order ≤ 2, at ( 0 , 0 ) , equal to zero. c. Let p be a point in a surface S R 3 . Let Oxyz be a Cartesian coor-

⊂ dinate system for R 3 such that O = p and the xy plane is the tangent plane of S at p . Show that the paraboloid

$$
z = \frac { 1 } { 2 } ( x ^ { 2 } f _ { x x } + 2 x y f _ { x y } + y ^ { 2 } f _ { y y } ) , \quad ( ^ { * } )
$$

obtained by neglecting thirdand higher-order terms in the Taylor development around p = ( 0 , 0 ) , has contact of order ≥ 2 at p with S (the surface ( ∗ ) is called the osculating paraboloid of S at p ). If a paraboloid (the degenerate cases of plane and parabolic cylinder

*d. are included) has contact of order ≥ 2 with a surface S at p , then it is the osculating paraboloid of S at p .

e. If two surfaces have contact of order ≥ 2 at p , then the osculating paraboloids of S and ¯ S at p coincide. Conclude that the Gaussian and mean curvatures of S and ¯ S at p are equal. f. The notion of contact of order 2 is invariant by diffeomorphisms of

≥ R 3 ; that is, if S and ¯ S have contact of order ≥ 2 at p and ϕ : R 3 → R 3 is a diffeomorphism, then ϕ(S) and ϕ( ¯ S) have contact of order ≥ 2 at ϕ(p) .

g. If S and ¯ S have contact of order ≥ 2 at p , then

$$
\lim _ { r \to 0 } \frac { d } { r ^ { 2 } } = 0 ,
$$

where d is the length of the segment cut by the surfaces in a straight line normal to T p (S) = T p ( ¯ S) , which is at a distance r from p . Contact of Curves. ) Deﬁne contact of order ( integer 1) for

9. ( ≥ n n ≥ regular curves in R 3 with a common point p and prove that

[Page 190]

The notion of contact of order ≥ n is invariant by diffeomorphisms.

Two curves have contact of order ≥ 1 at p if and only if they are tangent at p .

10. ( Contact of Curves and Surfaces. ) A curve C and a surface S , which have a common point p , have contact of order ≥ n ( n integer ≥ 1) at p if there exists a curve ¯ C ⊂ S passing through p such that C and ¯ C have contact of order ≥ n at p . Prove that a. If 0 is a representation of a neighborhood of in

f (x,y,z) = p S and α(t) = (x(t),y(t),z(t)) is a parametrization of C in p , with α( 0 ) = p , then C and S have contact of order ≥ n if and only if df n

$$
f ( x ( 0 ) , y ( 0 ) , z ( 0 ) ) = 0 , \quad \frac { d f } { d t } = 0 , \dots , \frac { d ^ { n } f } { d t ^ { n } } = 0 ,
$$

where the derivatives are computed for t = 0.

- b. ≥ C at p , then this is the osculating plane of C at p .
- c. If a sphere has contact of order ≥ 3 with a curve C at p , and α(s) is a parametrization by arc length of this curve, with α( 0 ) = p , then the center of the sphere is given by


$$
\alpha ( 0 ) + \frac { 1 } { k } n + \frac { k ^ { \prime } } { k ^ { 2 } \tau } b .
$$

Such a sphere is called the osculating sphere of C at p .

- 11. Consider the monkey saddle S of Example 2. Construct the Dupin indicatrix at p = ( 0 , 0 , 0 ) using the deﬁnition of Sec. 3-2, and compare it with the curve obtained as the intersection of S with a plane parallel to T p (S) and close to p . Why are they not “approximately similar” (cf. Example 5 of Sec. 3-3)? Go through the argument of Example 5 of Sec. 3-3 and point out where it breaks down.
- 12. Consider the parametrized surface


$$
x ( u , v ) & = \left ( \sin u \cos v , \sin u \sin v , \cos u + \log \tan \frac { u } { 2 } + \varphi ( v ) \right ) , \\ \text {where $\varphi$ is a different function. Prove that}
$$

where ϕ is a differentiable function. Prove that

a. The curves v = const . are contained in planes which pass through the z axis and intersect the surface under a constant angle θ given by

$$
\cos \theta = \frac { \varphi ^ { \prime } } { \sqrt { 1 + ( \varphi ^ { \prime } ) ^ { 2 } } } . \\ \intertext { c o n s } \vcurves \ v = \text {const. are lines}
$$

  Conclude that the curves v = const . are lines of curvature of the surface.

[Page 191]

b. The length of the segment of a tangent line to a curve v = const . , determined by its point of tangency and the z axis, is constantly equal to 1. Conclude that the curves v = const . are tractrices (cf. Exercise 6).

13. Let F : R 3 → R 3 be the map (a similarity) deﬁned by F(p) = cp , p ∈ R 3 , c a positive constant. Let S ⊂ R 3 be a regular surface and set F(S) = ¯ S . Show that ¯ S is a regular surface, and ﬁnd formulas relating the Gaussian and mean curvatures, K and H , of S with the Gaussian and mean curvatures, ¯ K and ¯ H , of ¯ S . 14. Consider the surface obtained by rotating the curve y x 3 , 1 <x < 1,

= − about the line x = 1. Show that the points obtained by rotation of the origin ( 0 , 0 ) of the curve are planar points of the surface.

- *15. Give an example of a surface which has an isolated parabolic point p (that is, no other parabolic point is contained in some neighborhood of p ).
- *16. Show that a surface which is compact (i.e., it is bounded and closed in R 3 ) has an elliptic point.


- 17. Deﬁne Gaussian curvature for a nonorientable surface. Can you deﬁne mean curvature for a nonorientable surface?
- 18. Show that the Möbius strip of Fig. 3-1 can be parametrized by


$$
x ( u , v ) = \left ( \left ( 2 - v \sin \frac { u } { 2 } \right ) \sin u , \left ( 2 - v \sin \frac { u } { 2 } \right ) \cos u , v \cos \frac { u } { 2 } \right )
$$

and that its Gaussian curvature is

$$
K = - \frac { 1 } { \{ \frac { 1 } { 4 } v ^ { 2 } + ( 2 - v \sin ( u / 2 ) ) ^ { 2 } \} ^ { 2 } } .
$$

*19. Obtain the asymptotic curves of the one-sheeted hyperboloid x 2 + y 2 − z 2 = 1. 20. Determine the umbilical points of the elipsoid

Determine the umbilical points of the elipsoid

$$
\frac { x ^ { 2 } } { a ^ { 2 } } + \frac { y ^ { 2 } } { b ^ { 2 } } + \frac { z ^ { 2 } } { c ^ { 2 } } = 1 .
$$

*21. Let S be a surface with orientation N . Let V ⊂ S be an open set in S and let f : V ⊂ S → R be any nowhere-zero differentiable function in V . Let v 1 and v 2 be two differentiable (tangent) vector ﬁelds in V such that at each point of V , v 1 and v 2 are orthonormal and v 1 ∧ v 2 = N .

[Page 192]

a. Prove that the Gaussian curvature K of V is given by

$$
K = \frac { \langle d ( f N ) ( v _ { 1 } ) \wedge d ( f N ) ( v _ { 2 } ) , f N \rangle } { f ^ { 3 } } .
$$

The virtue of this formula is that by a clever choice of f we can often simplify the computation of K , as illustrated in part b.

b. Apply the above result to show that if f is the restriction of

to the ellipsoid

$$
\sqrt { \frac { x ^ { 2 } } { a ^ { 4 } } + \frac { y ^ { 2 } } { b ^ { 4 } } + \frac { z ^ { 2 } } { c ^ { 4 } } }
$$

$$
\frac { x ^ { 2 } } { a ^ { 2 } } + \frac { y ^ { 2 } } { b ^ { 2 } } + \frac { z ^ { 2 } } { c ^ { 2 } } = 1 ,
$$

then the Gaussian curvature of the ellipsoid is

$$
K = \frac { 1 } { a ^ { 2 } b ^ { 2 } c ^ { 2 } } \frac { 1 } { f ^ { 4 } } .
$$

22. ( The Hessian. ) Let h : S → R be a differentiable function on a surface S , and let p ∈ S be a critical point of h (i.e., dh p = 0). Let w ∈ T p (S) and let

$$
\alpha \colon ( - \epsilon , \epsilon ) \rightarrow S
$$

be a parametrized curve with α( 0 ) = p , α ′ ( 0 ) = w . Set 2

$$
H _ { p } h ( w ) = \frac { d ^ { 2 } ( h \circ \alpha ) } { d t ^ { 2 } } \Big | _ { t = 0 } . \\
$$

.

a. Let x : U → S be a parametrization of S at p , and show that (the fact that p is a critical point of h is essential here)

$$
H _ { p } h ( u ^ { \prime } \mathbf x _ { u } + v ^ { \prime } \mathbf x _ { v } ) = h _ { u u } ( p ) ( u ^ { \prime } ) ^ { 2 } + 2 h _ { u v } ( p ) u ^ { \prime } v ^ { \prime } + h _ { v v } ( p ) ( v ^ { \prime } ) ^ { 2 } . \\ \\ \intertext { t h e r } H _ { p } h ( u ^ { \prime } \mathbf x _ { u } + v ^ { \prime } \mathbf x _ { v } ) = h _ { u u } ( p ) ( u ^ { \prime } ) ^ { 2 } + 2 h _ { u v } ( p ) u ^ { \prime } v ^ { \prime } + h _ { v v } ( p ) ( v ^ { \prime } ) ^ { 2 } . \\
$$

Conclude that H p h : T p (S) → R is a well-deﬁned (i.e., it does not depend on the choice of x ) quadratic form on T p (S) . H p h is called the Hessian of h at p .

b. Let h : S → R be the height function of S relative to T p (S) ; that is, h(q) =   q − p,N(p)   , q ∈ S . Verify that p is a critical point of h and thus that the Hessian H p h is well deﬁned. Show that if w ∈ T p (S) , | w | = 1, then

H p h(w) = normal curvature at p in the direction of w .

Conclude that the Hessian at p of the height function relative to T p ( S ) is the second fundamental form of S at p.

[Page 193]

23. ( Morse Functions on Surfaces. ) A critical point p ∈ S of a differentiable function h : S → R is nondegenerate if the self-adjoint linear map A p h associated to the quadratic form H p h (cf. the appendix to Chap. 3) is nonsingular (here H p h is the Hessian of h at p ; cf. Exercise 22). Otherwise, p is a degenerate critical point. A differentiable function on S is a Morse function if all its critical points are nondegenerate. Let h r : S ⊂ R 3 → R be the distance function from S to r ; i.e., 3

$$
h _ { r } ( q ) = \sqrt { \langle q - r , q - r \rangle } , \quad q \in S , \quad r \in R ^ { 3 } , \quad r \notin S . \\ \intertext { a . \text { Show that } p \in S \text { is a critical point of } h , \text { if and only if the straight line } }
$$

- a. Show that p ∈ S is a critical point of h , if and only if the straight line pr is normal to S at p .
- b. Let p be a critical point of h r : S → R . Let w ∈ T p (S) , | w | = 1, and let α : ( − ǫ,ǫ) → S be a curve parametrized by arc length with α( 0 ) = p , α ′ ( 0 ) = w . Prove that 1


$$
H _ { p } h _ { r } ( w ) = \frac { 1 } { h _ { r } ( p ) } - k _ { n } ,
$$

where k n is the normal curvature at p along the direction of w . Conclude that the orthonormal basis { e 1 ,e 2 } , where e 1 and e 2 are along the principal directions of T p (S) , diagonalizes the self-adjoint linear map A p h r . Conclude further that p is a degenerate critical point of h r if and only if either h r (p) = 1 /k 1 or h r (p) = 1 /k 2 , where k 1 and k 2 are the principal curvatures at p .

c. Show that the set

$$
B & = \{ r \in R ^ { 3 } ; h _ { r } \text { is a Morse function} \} \\
$$

is a dense set in R 3 ; here dense in R 3 means that in each neighborhood of a given point of R 3 there exists a point of B ( this shows that on any regular surface there are “many” Morse functions ).

24. ( Local Convexity and Curvature ). A surface S ⊂ R 3 is locally convex at a point p ∈ S if there exists a neighborhood V ⊂ S of p such that V is contained in one of the closed half-spaces determined by T p (S) in R 3 . If, in addition, V has only one common point with T p (S) , then S is called strictly locally convex at p .

- a. Provethat S isstrictlylocallyconvexat p iftheprincipalcurvaturesof S at p are nonzero with the same sign (that is, the Gaussian curvature K(p) satisﬁes K(p) > 0).
- b. Prove that if S is locally convex at p , then the principal curvatures at p do not have different signs (thus, K(p) ≥ 0). c. To show that K 0 does not imply local convexity, con-


≥ sider the surface f (x,y) = x 3 ( 1 + y 2 ) , deﬁned in the open

[Page 194]

set U = { (x,y) ∈ R 2 ; y 2 < 1 2 } . Show that the Gaussian curvature of this surface is nonnegative on U and yet the surface is not locally convex at ( 0 , 0 ) ∈ U (a deep theorem, due to R. Sacksteder, implies that such an example cannot be extended to the entire R 2 if we insist on keeping the curvature nonnegative; cf. Remark 3 of Sec. 5-6).

*d. The example of part c is also very special in the following local sense. Let p be a point in a surface S , and assume that there exists a neighborhood V ⊂ S of p such that the principal curvatures on V do not have different signs (this does not happen in the example of part c). Prove that S is locally convex at p .

# 3-4. Vector Fields †

In this section we shall use the fundamental theorems of ordinary differential equations (existence, uniqueness, and dependence on the initial conditions) to prove the existence of certain coordinate systems on surfaces.

If the reader is willing to assume the results of Corollaries 2, 3, and 4 at the end of this section (which can be understood without reading the section), this material may be omitted on a ﬁrst reading.

We shall begin with a geometric presentation of the material on differential equations that we intend to use. 2

A vector ﬁeld in an open set U ⊂ R is a map which assigns to each q ∈ U a vector w(q) ∈ R 2 . The vector ﬁeld w is said to be differentiable if writing q = (x,y) and w(q) = (a(x,y),b(x,y)) , the functions a and b are differentiable functions in U .

Geometrically, the deﬁnition corresponds to assigning to each point (x,y) ∈ U a vector with coordinates a(x,y) and b(x,y) which vary differentiably with (x,y) (Fig. 3-24).

![The image depicts a diagram involving a circular loop with a labeled loop labeled as xy. The loop is connected to a point labeled as x, and the loop is connected to a point labeled as y. The loop is labeled as x and the point labeled as y are connected to a point labeled as z. The diagram includes several lines and points. The loop is connected to a point labeled as x, and the loop is connected to a point labeled as y. The loop is also connected to a point labeled as z, and the loop is connected to a point labeled as z. The diagram includes several lines and points. The loop is connected to a point labeled as x, and the loop is connected to a point labeled as y. The loop is also connected to a point labeled as z, and the loop is connected to a point labeled as z. The diagram includes several lines and points](<images/imageFile48.png>)

y

(

)

x,y

(

(

)

(

))

a

x,y

, b

x,y

x

0

Figure 3-24

In what follows we shall consider only differentiable vector ﬁelds. In Fig. 3-25 some examples of vector ﬁelds are shown.

†This section may be omitted on a ﬁrst reading.

[Page 195]

![In this image, we can see a diagram with some lines and points.](<images/imageFile49.png>)

(

)

w = (

x, y

(

)

w = (

y, -x

Figure 3-25

Given a vector ﬁeld w , it is natural to ask whether there exists a trajectory of this ﬁeld, that is, whether there exists a differentiable parametrized curve α(t) = (x(t),y(t)) , t ∈ I , such that α ′ (t) = w(α(t)) . For instance, a trajectory, passing through the point (x 0 ,y 0 ) , of the vector

For instance, a trajectory, passing through the point (x 0 , y 0 ) , of the vector field w(x,y) = (x, y) is the straight line α(t) = (x 0 e t , y 0 e t ) , t ∈ R , and a trajectory of w(x,y) = (y, -x) , passing through (x 0 , y 0 ) , is the circle β(t) = (r sin t, r cos t) , t ∈ R , r 2 = x 2 0 + y 2 0 .

In the language of ordinary differential equations, one says that the vector field w determines a system of differential equations ,

$$
\frac { d x } { d t } & = a ( x , y ) , \\ \frac { d y } { d t } & = b ( x , y ) ,
$$

and that a trajectory of w is a solution to Eq. (1).

The fundamental theorem of (local) existence and uniqueness of solutions of Eq. (1) is equivalent to the following statement on trajectories (in what follows, the letters I and J will denote open intervals of the line R , containing the origin 0 ∈ R ).

THEOREM 1. Let w be a vector ﬁeld in an open set U ⊂ R 2 . Given p ∈ U , there exists a trajectory α : I → U of w ( i.e., α ′ ( t ) = w (α( t )) , t ∈ I) with α( 0 ) = p . This trajectory is unique in the following sense: Any other trajectory β : J → U with β( 0 ) = p agrees with α in I ∩ J .

An important complement to Theorem 1 is the fact that the trajectory passing through p “varies differentiably with p .” This idea can be made precise as follows.

[Page 196]

THEOREM 2. Let w be a vector ﬁeld in an open set U ⊂ R 2 . For each p ∈ U there exist a neighborhood V ⊂ U of p , an interval I , and a mapping α : V × I → U such that

- 1. For a ﬁxed q ∈ V , the curve α( q , t ) , t ∈ I , is the trajectory of w passing through q ; that is,

$$
\alpha ( q , 0 ) = q , \quad \frac { \partial \alpha } { \partial t } ( q , t ) = w ( \alpha ( q , t ) ) .
$$

- 2. α is differentiable.


Geometrically Theorem 2 means that all trajectories which pass, for t = 0, in a certain neighborhood V of p may be “collected” into a single differentiable map. It is in this sense that we say that the trajectories depend differentiably on p (Fig. 3-26).

![In the diagram, there is a right triangle labeled as \( \triangle ABC \). Inside the triangle, there is a cylinder with a radius of 4 and a height of 9. The cylinder is positioned such that it is perpendicular to the base of the triangle.](<images/imageFile50.png>)

×

V

I

V

q

U

Figure 3-26

The map α is called the ( local ) ﬂow of w at p .

Theorems 1 and 2 will be assumed in this book; for a proof, one can consult, for instance, W. Hurewicz, Lectures on Ordinary Differential Equations , M.I.T. Press, Cambridge, Mass., 1958, Chap. 2. For our purposes, we need the following consequence of these theorems.

LEMMA. Let w be a vector ﬁeld in an open set U ⊂ R 2 and let p ∈ U be such that w ( p )  = 0. Then there exist a neighborhood W ⊂ U of p and a differentiable function f: W → R such that f is constant along each trajectory of w and df q  = 0 for all q ∈ W. Proof . Choose a Cartesian coordinate system in 2 such that 0 0

R p = ( , ) and w(p) is in the direction of the x axis. Let α : V × I → U be the local ﬂow at p , V ⊂ U , t ∈ I , and let ˜ α be the restriction of α to the rectangle

[Page 197]

$$
( V \times I ) \cap \{ ( x , y , t ) \in R ^ { 3 } ; x = 0 \} . \\
$$

(See Fig. 3-27.) By the deﬁnition of local ﬂow, d ˜ α p maps the unit vector of the t axis into w and maps the unit vector of the y axis into itself. Therefore, d ˜ α p is nonsingular. It follows that there exists a neighborhood W ⊂ U of p , where ˜ α − 1 is deﬁned and differentiable. The projection of ˜ α − 1 (x,y) onto the y axis is a differentiable function ξ = f (x,y) , which has the same value ξ for all points of the trajectory passing through ( 0 ,ξ) . Since d ˜ α p is nonsingular, W may be taken sufﬁciently small so that df q  = 0 for all q ∈ W . f is therefore the required function. Q.E.D.

t

![The image depicts a geometric figure involving a cylinder and a cylinder. The cylinder is a cylinder with a circular base and a circular top. The height of the cylinder is labeled as h and the radius of the base is labeled as r. The cylinder is positioned such that the top of the cylinder is at the top of the image and the bottom of the cylinder is at the bottom of the image. The diagram includes two lines, labeled as \( \text{AB} \) and \( \text{BC} \). These lines intersect at a point labeled as \( \text{D}\). The point \( \text{D}\) is located at the intersection of the two lines. The diagram also includes two points, labeled as \( \text{E} \) and \( \text{F}\). These points are located at the intersections of the lines \( \text{AB} \) and \( \text](<images/imageFile51.png>)

-1

(

)

–1 ˜ α

x,y

˜α

I

0

y

V

w

(

)

x,y

x

Figure 3-27

The function f of the above lemma is called a (local) ﬁrst integral of w in a neighborhood of p . For instance, if w(x,y) = (y, − x) is deﬁned in R 2 , a ﬁrst integral f : R 2 −{ ( 0 , 0 ) } → R is f (x,y) = x 2 + y 2 .

Closely associated with the concept of vector ﬁeld is the concept of ﬁeld of directions. 2

A ﬁeld of directions r in an open set U ⊂ R is a correspondence which assigns to each p ∈ U a line r(p) in R 2 passing through p . r is said to be differentiable at p ∈ U if there exists a nonzero differentiable vector ﬁeld w , deﬁned in a neighborhood V ⊂ U of p , such that for each q ∈ V , w(q)  = 0 is a basis of r(q) ; r is differentiable in U if it is differentiable for every p ∈ U . To each nonzero differentiable vector ﬁeld w in U ⊂ R 2 , there corresponds

To each nonzero differentiable vector field w in U ⊂ R 2 , there corresponds a differentiable field of directions given by r(p) = line generated by w(p) , p ∈ U .

By its very definition, each differentiable field of directions gives rise, locally, to a nonzero differentiable vector field. This, however, is not true

[Page 198]

globally, as is shown by the ﬁeld of directions in R 2 −{ ( 0 , 0 ) } given by the tangent lines to the curves of Fig. 3-28; any attempt to orient these curves in order to obtain a differentiable nonzero vector ﬁeld leads to a contradiction.

Aregularconnectedcurve C ⊂ U isan integralcurve ofaﬁeldofdirections r deﬁned in U ⊂ R 2 if r(q) is the tangent line to C at q for all q ∈ C . By what has been seen previously, it is clear that given a differentiable

ﬁeld of directions r in an open set U ⊂ R 2 , there passes, for each q ∈ U , an integral curve C of r ; C agrees locally with the trace of a trajectory through q of the vector ﬁeld determined in U by r . In what follows, we shall consider only differentiable ﬁelds of directions and shall omit, in general, the word differentiable.

![The image consists of a diagram with a series of interconnected lines. The lines are arranged in a vertical manner, with each line extending from the top to the bottom. The lines are connected in a way that they form a continuous structure. The lines are evenly spaced and appear to be made of a material that is not clearly visible. The diagram includes a few key elements: 1. **Lines**: There are multiple lines, each with a specific orientation. The lines are arranged in a vertical manner, with each line extending from the top to the bottom. 2. **Intersections**: There are multiple intersections between the lines. These intersections are not clearly defined, but they appear to be the points where the lines intersect. 3. **Lines and Points**: The lines are connected to each other, forming a continuous structure. The points on the lines are not clearly visible, but they are present. 4. **Color**: The lines are colored in a way that they are not](<images/imageFile52.png>)

Figure 3-28. A nonorientable ﬁeld of directions in R 2 −{ ( 0 , 0 ) } .

A natural way of describing a ﬁeld of directions is as follows. We say that two nonzero vectors w 1 and w 2 at q ∈ R 2 are equivalent if w 1 = λw 2 for some λ ∈ R , λ  = 0. Two such vectors represent the same straight line passing through q , and, conversely, if two nonzero vectors belong to the same straight line passing through q , they are equivalent. Thus, a ﬁeld of directions r on an open set U ⊂ R 2 can be given by assigning to each q ∈ U a pair of real numbers (r 1 ,r 2 ) (the coordinates of a nonzero vector belonging to r ), where we consider the pairs (r 1 ,r 2 ) and (λr 1 ,λr 2 ) , λ  = 0, as equivalent. In the language of differential equations, a ﬁeld of directions r is usually

In the language of differential equations, a field of directions r is usually given by

$$
a ( x , y ) \frac { d x } { d t } + b ( x , y ) \frac { d y } { d t } = 0 ,
$$

which simply means that at a point q = (x,y) we associate the line passing through q that contains the vector (b, − a) or any of its nonzero multiples (Fig. 3-29). The trace of the trajectory of the vector ﬁeld (b, − a) is an integral curve of r . Because the parametrization plays no role in the above considerations, it is often used, instead of Eq. (2), the expression

$$
a \, d x + b \, d y = 0 \\ f \, \right (
$$

with the same meaning as before.

[Page 199]

![The image depicts a graph that illustrates the relationship between the angle of a light source and the angle of a light source. The graph is a line graph with a single point labeled (x, y) where the point is located. The graph shows a general trend of increasing angle of the light source as the angle of the light source increases. The graph has a horizontal axis labeled x and a vertical axis labeled y. The x-axis is labeled with the values of the angle of the light source, ranging from 0 to 180 degrees. The y-axis is labeled with the values of the angle of the light source, ranging from 0 to 180 degrees. The graph shows a general trend of increasing angle of the light source as the angle of the light source increases. This trend is represented by a line that starts at a point (0, 0) and extends upwards to a point (180, 0).](<images/imageFile53.png>)

y

An integral

(

)

x,y

curve

(

)

b,–a )

x

0

r

Figure 3-29. The differential equation adx + bdy = 0.

The ideas introduced above belong to the domain of the local facts of R 2 , which depend only on the “differentiable structure” of R 2 . They can, therefore, be transported to a regular surface, without further difﬁculties, as follows.

DEFINITION 1. A vector ﬁeld w in an open set U ⊂ S of a regular surface S is a correspondence which assigns to each p ∈ U a vector w ( p ) ∈ T p ( S ) . The vector ﬁeld w is differentiable at p ∈ U if, for some parametrization x ( u , v ) at p , the functions a ( u , v ) and b ( u , v ) given by

$$
w ( p ) = a ( u , v ) x _ { u } + b ( u , v ) x _ { v }
$$

are differentiable functions at p ; it is clear that this deﬁnition does not depend on the choice of x .

We can deﬁne, similarly, trajectories, ﬁeld of directions, and integral curves. Theorems l and 2 and the lemma above extend easily to the present situation; up to a change of R 2 by S , the statements are exactly the same.

Example 1. Avectorﬁeldintheusualtorus T isobtainedbyparametrizing the meridians of T by arc length and deﬁning w(p) as the velocity vector of the meridian through p (Fig. 3-30). Notice that | w(p) | = 1 for all p ∈ T . It is left as an exercise (Exercise 2) to verify that w is differentiable.

Example 2. A similar procedure, this time on the sphere S 2 and using the semimeridians of S 2 , yields a vector ﬁeld w deﬁned in the sphere minus the two poles N and S . To obtain a vector ﬁeld deﬁned in the whole sphere,

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

[Page 238]

[Page 239]

[Page 240]

[Page 241]

[Page 242]

[Page 243]

[Page 244]

[Page 245]

[Page 246]

[Page 247]

[Page 248]

[Page 249]

[Page 250]

[Page 251]

[Page 252]

[Page 253]

[Page 254]

[Page 255]

[Page 256]

[Page 257]

[Page 258]

[Page 259]

[Page 260]

[Page 261]

[Page 262]

[Page 263]

[Page 264]

[Page 265]

[Page 266]

[Page 267]

[Page 268]

[Page 269]

[Page 270]

[Page 271]

[Page 272]

[Page 273]

[Page 274]

[Page 275]

[Page 276]

[Page 277]

[Page 278]

[Page 279]

[Page 280]

[Page 281]

[Page 282]

[Page 283]

[Page 284]

[Page 285]

[Page 286]

[Page 287]

[Page 288]

[Page 289]

[Page 290]

[Page 291]

[Page 292]

[Page 293]

[Page 294]

[Page 295]

[Page 296]

[Page 297]

[Page 298]

[Page 299]

[Page 300]

[Page 301]

[Page 302]

[Page 303]

[Page 304]

[Page 305]

[Page 306]

[Page 307]

[Page 308]

[Page 309]

[Page 310]

[Page 311]

[Page 312]

[Page 313]

[Page 314]

[Page 315]

[Page 316]

[Page 317]

[Page 318]

[Page 319]

[Page 320]

[Page 321]

[Page 322]

[Page 323]

[Page 324]

[Page 325]

[Page 326]

[Page 327]

[Page 328]

[Page 329]

[Page 330]

[Page 331]

[Page 332]

[Page 333]

[Page 334]

[Page 335]

[Page 336]

[Page 337]

[Page 338]

[Page 339]

[Page 340]

[Page 341]

[Page 342]

[Page 343]

[Page 344]

[Page 345]

[Page 346]

[Page 347]

[Page 348]

[Page 349]

[Page 350]

[Page 351]

[Page 352]

[Page 353]

[Page 354]

[Page 355]

[Page 356]

[Page 357]

[Page 358]

[Page 359]

[Page 360]

[Page 361]

[Page 362]

[Page 363]

[Page 364]

[Page 365]

[Page 366]

[Page 367]

[Page 368]

[Page 369]

[Page 370]

[Page 371]

[Page 372]

[Page 373]

[Page 374]

[Page 375]

[Page 376]

[Page 377]

[Page 378]

[Page 379]

[Page 380]

[Page 381]

[Page 382]

[Page 383]

[Page 384]

[Page 385]

[Page 386]

[Page 387]

[Page 388]

[Page 389]

[Page 390]

[Page 391]

[Page 392]

[Page 393]

[Page 394]

[Page 395]

[Page 396]

[Page 397]

[Page 398]

[Page 399]

[Page 400]

[Page 401]

To make the above heuristic argument rigorous we have to deﬁne a “continuous family of arcs joining two given arcs” and to show that such a family may be “lifted.”

DEFINITION 2. Let B ⊂ R 3 and let α 0 : [0 ,l ] → B , α 1 : [0 ,l ] → B be two arcs of B , joining the points

$$
p = \alpha _ { 0 } ( 0 ) = \alpha _ { 1 } ( 0 ) \ \ a n d \ \ q = \alpha _ { 0 } ( l ) = \alpha _ { 1 } ( l ) . \\
$$

We say that α 0 and α 1 are homotopic if there exists a continuous map H: [0 ,l ] × [0 , 1] → B such that 1. H s 0 s H s 1 s , s [0 ] .

( , ) = α 0 ( ), ( , ) = α 1 ( ) ∈ ,l 2. H ( 0 , t ) p , H (l, t ) q , t [0 , 1] .

H ( 0 , t ) = p , H (l, t ) = q , t ∈ [0 , 1] .

The map H is called a homotopy between α 0 and α 1 .

For every t ∈ [0 , 1], the arc α t : [0 ,l ] → B given by α t (s) = H(s,t) is called an arc of the homotopy H . Therefore, the homotopy is a family of arcs α t , t ∈ [0 , 1], which constitutes a continuous deformation of α 0 into α 1 (see Fig. 5-27) in such a way that the extremities p and q of the arcs α t remain ﬁxed during the deformation (condition 2).

q

![In this image, we can see a diagram of a cylinder. There are two lines, which are labeled as 'a' and 'b'. We can also see a diagram of a cylinder with a cylinder and a cylinder.](<images/imageFile54.png>)

l

α

t

α

α

1

0

H

p

0

1

t

Figure 5-27

The notion of lifting of homotopies is entirely analogous to that of lifting of arcs. Let π : ˜ B → B be a continuous map and let α 0 , α 1 : [0 ,l ] → B be two arcs of B joining the points p and q . Let H : [0 ,l ] × [0 , 1] → B be a homotopy between α 0 and α 1 . If there exists a continuous map

$$
\tilde { H } \colon [ 0 , l ] \times [ 0 , 1 ] & \to \tilde { B } \\ \\ \tilde { H } \colon [ \tilde { \sigma } , \tilde { \sigma } ] & \times [ 0 , 1 ]
$$

such that π ◦ ˜ H = H , we say that ˜ H is a lifting of the homotopy H , with origin at ˜ H( 0 , 0 ) = ˜ p ∈ ˜ B .

[Page 402]

We shall now show that a covering map has the property of lifting homotopies. Actually, we shall prove a more general proposition. Observe that a covering map π : ˜ B → B is a local homeomorphism and, furthermore, that every arc of B may be lifted into an arc of ˜ B . For the proofs of Props. 3, 4, and 5 below we shall use only these two properties of covering maps, and so, for future use, we shall state these propositions in this generality. Thus, we shall say that a continuous map π : ˜ B → B has the property of lifting arcs when every arc of B may be lifted. Notice that this implies that π maps ˜ B onto B .

PROPOSITION 3. Let B be arcwise connected and let π : ˜ B → B be a local homeomorphism with the property of lifting arcs. Let α 0 , α 1 : [0 ,l ] → B be two arcs of B joining the points p and q , let

$$
H \colon [ 0 , l ] \times [ 0 , 1 ] \to B
$$

be a homotopy between α 0 and α 1 , and let ˜ p ∈ ˜ B be a point of ˜ B such that π( ˜ p ) = p . Then there exists a unique lifting ˜ H of H with origin at ˜ p .

Proof . The proof of the uniqueness is entirely analogous to that of the lifting of arcs. Let ˜ H 1 and ˜ H 2 be two liftings of H with ˜ H 1 ( 0 , 0 ) = ˜ H 2 ( 0 , 0 ) = ˜ p . Then the set A of points (s,t) ∈ [0 ,l ] × [0 , 1] = Q such that ˜ H 1 (s,t) = ˜ H 2 (s,t) is nonempty and closed in Q . Since ˜ H 1 and ˜ H 2 are continuous and π is a local homeomorphism, A is open in Q . By connectedness of Q , A = Q ; hence, ˜ H 1 = ˜ H 2 . To prove the existence, let α t (s) = H(s,t) be an arc of the homotopy H .

To prove the existence, let αt (s) = H(s,t) be an arc of the homotopy H . Define ˜ H by

$$
\tilde { H } ( s , t ) = \tilde { \alpha } _ { t } ( s ) , \ \ s \in [ 0 , l ] , t \in [ 0 , 1 ] ,
$$

where ˜ α t is the lifting of α t , with origin at ˜ p . It is clear that

$$
\pi \circ \tilde { H } ( s , t ) & = \alpha _ { t } ( s ) = H ( s , t ) , \ \ s \in [ 0 , l ] , t \in [ 0 , 1 ] , \\ \tilde { H } ( 0 , 0 ) & = \tilde { \alpha } _ { 0 } ( 0 ) = \tilde { p } .
$$

$$
\tilde { H } ( 0 , 0 ) = \tilde { \alpha } _ { 0 } ( 0 ) = \tilde { p } .
$$

Let us now prove that ˜ H is continuous. Let (s 0 ,t 0 ) ∈ [0 ,l ] × [0 , 1]. Since π is a local homeomorphism, there exists a neighborhood V of ˜ H(s 0 ,t 0 ) such that the restriction π 0 of π to V is a homeomorphism onto a neighborhood U of H(s 0 ,t 0 ) . Let Q 0 ⊂ H − 1 (U) ⊂ [0 ,l ] × [0 , 1] be an open square given by

$$
S _ { 0 } - \epsilon < S < S _ { 0 } + \epsilon , \ \ t _ { 0 } - \epsilon < t < t _ { 0 } + \epsilon .
$$

It sufﬁces to prove that ˜ H restricted to Q 0 may be written as ˜ H = π − 1 0 ◦ H to conclude that ˜ H is continuous at (s 0 ,t 0 ) . Since (s 0 ,t 0 ) is arbitrary, ˜ H is continuous in [0 ,l ] × [0 , 1], as desired.

[Page 403]

For that, we observe that

$$
\pi _ { 0 } ^ { - 1 } ( H ( s _ { 0 } , t ) ) , \ \ t \in ( t _ { 0 } - \epsilon , t _ { 0 } + \epsilon ) ,
$$

is a lifting of the arc H(s 0 ,t) passing through ˜ H(s 0 ,t 0 ) . By uniqueness, π − 1 0 (H(s 0 ,t)) = ˜ H(s 0 ,t) . Since Q 0 is a square, for every (s 1 ,t 1 ) ∈ Q 0 there exists an arc H(s,t 1 ) in U , s ∈ (s 0 − ǫ,s 0 + ǫ) , which intersects the arc H(s 0 ,t) . Since π − 1 0 (H(s 0 ,t 1 )) = ˜ H(s 0 ,t 1 ) , the arc π − 1 0 (H(s,t 1 )) is the lifting of H(s,t 1 ) passing through ˜ H(s 0 ,t 1 ) . By uniqueness of the lifting, π − 1 0 (H(s,t 1 )) = ˜ H(s,t 1 ) ; hence, π − 1 0 (H(s 1 ,t 1 )) = ˜ H(s 1 ,t 1 ) . By the arbitrariness of (s 1 ,t 1 ) ∈ Q 0 we conclude that π − 1 0 (H(s,t)) = ˜ H(s,t) , (s,t) ∈ Q 0 which ends the proof. Q.E.D.

A consequence of Prop. 3 is the fact that if π : ˜ B → B is a covering map, then homotopic arcs of B are lifted into homotopic arcs of ˜ B . This may be expressed in a more general and precise way as follows.

PROPOSITION 4. Let π : ˜ B → B be a local homeomorphism with the property of lifting arcs. Let α 0 ,α 1 : [0 ,l ] → B be two arcs of B joining the points p and q and choose ˜ p ∈ ˜ B such that π( ˜ p ) = p . If α 0 and α 1 are homotopic, then the liftings ˜ α 0 and ˜ α 1 of α 0 and α 1 , respectively, with origin ˜ p , are homotopic.

Proof . Let H be the homotopy between α 0 and α 1 and let ˜ H be its lifting, with origin at ˜ p . We shall prove that ˜ H is a homotopy between ˜ α 0 and ˜ α 1 (see Fig. 5-28).

![In the diagram, there is a diagram of a cone. The cone has two points labeled as H and I. There is a line labeled as \(i\) that is perpendicular to the line \(i\).](<images/imageFile55.png>)

q

p

π

H

B

q

H

p

Figure 5-28

[Page 404]

In fact, by the uniqueness of the lifting of arcs,

$$
\tilde { H } ( s , 0 ) = \tilde { \alpha } _ { 0 } ( s ) , \ \tilde { H } ( s , 1 ) = \tilde { \alpha } _ { 1 } ( s ) , \ \ s \in [ 0 , l ] ,
$$

which veriﬁes condition 1 of Def. 2. Furthermore, ˜ H( 0 ,t) is the lifting of the “constant” arc H( 0 ,t) = p , with origin at ˜ p . By uniqueness,

$$
\tilde { H } ( 0 , t ) = \tilde { p } , \ \ t \in [ 0 , 1 ] .
$$

Similarly, ˜ H(l,t) is the lifting of H(l,t) = q , with origin at ˜ α 0 (l) = ˜ q ; hence,

$$
\tilde { H } ( l , t ) = \tilde { q } = \alpha _ { 1 } ( l ) , \ \ t \in [ 0 , 1 ] .
$$

Therefore, condition 2 of Def. 2 is veriﬁed, showing that ˜ H is a homotopy between ˜ α 0 and ˜ α 1 . Q.E.D.

Returning to the heuristic argument that led us to consider the concept of homotopy, we see that it still remains to explain what it is meant by a space without “holes.” Of course we shall take as a deﬁnition of such a space precisely that property which was used in the heuristic argument.

DEFINITION 3. An arcwise connected set B ⊂ R 3 is simply connected if given two points p , q ∈ B and two arcs α 0 : [0 ,l ] → B , α 1 : [0 ,l ] → B joining p to q , there exists a homotopy in B between α 0 and α 1 . In particular, any closed arc of B , α : [0 ,l ] → B (closed means that α( 0 ) = α(l) = p ), is homotopic to the “constant” arc α( s ) = p , s ∈ [0 ,l ] (in Exercise 5 it is indicated that this last property is actually equivalent to the ﬁrst one).

Intuitively, an arcwise connected set B is simply connected if every closed arc in B can be continuously deformed into a point. It is possible to prove that the plane and the sphere are simply connected but that the cylinder and the torus are not simply connected (cf. Exercise 5).

We may now state and prove an answer to question 2 of this section. This will come out as a corollary of the following proposition.

PROPOSITION 5. Let π : ˜ B → B be a local homeomorphism with the property of lifting arcs. Let ˜ B be arcwise connected and B simply connected. Then π is a homeomorphism.

Proof . The proof is essentially the same as that presented in the heuristic argument.

We need to prove that π is one-to-one. For this, let ˜ p 1 and ˜ p 2 be two points of ˜ B , with π( ˜ p 1 ) = π( ˜ p 2 ) = p . Since ˜ B is arcwise connected, there exists an arc ˜ α 0 of ˜ B , joining ˜ p 1 to ˜ p 2 . Then π ◦ ˜ α 0 = α 0 is a closed arc of B . Since B is simply connected, α 0 is homotopic to the constant arc α 1 (s) = p , s ∈ [0 ,l ]. By Prop. 4, ˜ α 0 is homotopic to the lifting ˜ α 1 of α 1 which has origin in p .

[Page 405]

Since ˜ α 1 is the constant arc joining the points ˜ p 1 and ˜ p 2 , we conclude that ˜ p 1 = ˜ p 2 . Q.E.D.

COROLLARY. Let π : ˜ B → B be a covering map, ˜ B arcwise connected, and B simply connected. Then π is a homeomorphism.

The fact that we proved Props. 3, 4, and 5 with more generality than was strictly necessary will allow us to give another answer to question 1, as described below.

Let π : ˜ B → B be a local homeomorphism with the property of lifting arcs, andassumethat ˜ B and B arelocally“well-behaved”(tobemadeprecise).Then π is, in fact, a covering map. 3

The required local properties are described as follows. Recall that B ⊂ R is locally arcwise connected if any neighborhood of each point contains an arcwise connected neighborhood (appendix to Chap. 5, Def. 12).

DEFINITION 4. B is locally simply connected if any neighborhood of each point contains a simply connected neighborhood.

In other words, B is locally simply connected if each point has arbitrarily small simply connected neighborhoods. It is clear that if B is locally simply connected, then B is locally arcwise connected.

We remark that a regular surface S is locally simply connected, since p ∈ S has arbitrarily small neighborhoods homeomorphic to the interior of a disk in the plane.

In the next proposition we shall need the following properties of a locally arcwise connected set B ⊂ R 3 (cf. the appendix to Chap. 5, Part D). The union of all arcwise connected subsets of B which contain a point p ∈ B is clearly an arcwise connected set A to be called the arcwise connected component of B containing p . Since B is locally arcwise connected, A is open in B . Thus, B can be written as a union B =   α A α of its connected components A α , which are open and pairwise disjoint. We also remark that a regular surface is locatJy arcwise connected. Thus,

in the proposition below, the hypotheses on B and ˜ B are satisﬁed when both B and ˜ B are regular surfaces.

PROPOSITION 6. Let π : ˜ B → B be a local homeomorphism with the property of lifting arcs. Assume that B is locally simply connected and that ˜ B is locally arcwise connected. Then π is a covering map.

Proof . Let p ∈ B and let V be a simply connected neighborhood of p in B . The set π − 1 (V ) is the union of its arcwise connected components; that is,

$$
\pi ^ { - 1 } ( V ) = \bigcup _ { \alpha } \tilde { V } _ { \alpha } ,
$$

[Page 406]

where the ˜ V α ’s are open, arcwise connected, and pairwise disjoint sets. Consider the restriction π : ˜ V α → V . If we show that π is a homeomorphism of ˜ V α onto V , π will satisfy the conditions of the deﬁnition of a covering map. We ﬁrst prove that π( ˜ V α ) V . In fact, π( ˜ V α ) V . Assume that there is a

= ⊂ point p ∈ V , p / ∈ π( ˜ V α ) . Then, since V is arcwise connected, there exists an arc α : [ a,b ] → V joining a point q ∈ π( ˜ V α ) to p . The lifting ˜ α : [ a,b ] → ˜ B of α with origin at ˜ q ∈ ˜ V α , where π( ˜ q) = q , is an arc in ˜ V α , since ˜ V α is an arcwise connected component of B . Therefore,

$$
\pi ( \tilde { \alpha } ( b ) ) = p \in \pi ( \tilde { V } _ { \alpha } ) ,
$$

which is a contradiction and shows that π( ˜ V α ) = V . Next, we observe that π : ˜ V α → V

is still a local homeomorphism, since ˜ V α is open. Furthermore, by the above, the map π : ˜ V α → V still has the property of lifting arcs. Therefore, we have satisﬁed the conditions of Prop. 5; hence, π is a homeomorphism. Q.E.D.

# B. The Hadamard Theorems

We shall now return to the question posed in the beginning of this section, namely, under what conditions is the local diffeomorphism exp p : T p (S) → S , where p is a point of a complete surface S of curvature K ≤ 0, a global diffeomorphism of T p (S) onto S . The following propositions, which serve to “break up” the given question into questions 1 and 2, yield an answer to the problem.

We shall need the following lemma.

LEMMA 1. Let S be a complete surface of curvature K ≤ 0 . Then exp p : T p ( S ) → S , p ∈ S , is length-increasing in the following sense: If u , w ∈ T p ( S ) , we have

$$
\langle ( d \ e x p _ { p } ) _ { u } ( w ) , ( d \ e x p _ { p } ) _ { u } ( w ) \rangle \geq \langle w , w \rangle ,
$$

where, as usual, w denotes a vector in ( T p ( S )) u that is obtained/rom w by the translation u .

Proof . For the case u = 0, the equality is trivially veriﬁed. Thus, let v = u/ | u | , u  = 0, and let γ : [0 ,l ] → S , l = | u | , be the geodesic

$$
\gamma ( s ) = \exp _ { p } s v , \ \ s \in [ 0 , l ] .
$$

By the Gauss lemma, we may assume that   w,v   = 0. Let J(s) = s(d exp p ) sv (w) be the Jacobi ﬁeld along γ given by Lemma 1 of Sec. 5-5. We know that J( 0 ) = 0, ( DJ / ds )( 0 ) = w , and   J(s) , γ ′ (s)   = 0, s ∈ [0 ,l ].

[Page 407]

Observe now that, since K ≤ 0 (cf. Eq. (1), Sec. 5-5),

$$
\frac { d } { d s } \left \langle J , \frac { D J } { d s } \right \rangle = \left \langle \frac { D J } { d s } , \frac { D J } { d s } \right \rangle + \left \langle J , \frac { D ^ { 2 } J } { d s ^ { 2 } } \right \rangle = \left | \frac { D J } { d s } \right | ^ { 2 } - K | J | ^ { 2 } \geq 0 . \\ \intertext { This implies that }
$$

This implies that

$$
\left \langle J , \frac { D J } { d s } \right \rangle \geq 0 ;
$$

hence,

$$
\frac { d } { d s } \left \langle \frac { D J } { d s } , \frac { D J } { d s } \right \rangle = 2 \left \langle \frac { D J } { d s } , \frac { D ^ { 2 } J } { d s ^ { 2 } } \right \rangle = - 2 K \left \langle \frac { D J } { d s } , J \right \rangle \geq 0 .
$$

It follows that

hence,

$$
\left \langle \frac { D J } { d s } , \frac { D J } { d s } \right \rangle \geq \left \langle \frac { D J } { d s } ( 0 ) , \frac { D J } { d s } ( 0 ) \right \rangle = \langle w , w \rangle = C ;
$$

$$
\frac { d ^ { 2 } } { d s ^ { 2 } } \langle J , J \rangle & = 2 \left \langle \frac { D J } { d s } , \frac { D J } { d s } \right \rangle + 2 \left \langle J , \frac { D ^ { 2 } J } { d s ^ { 2 } } \right \rangle \geq 2 \left \langle \frac { D J } { d s } , \frac { D J } { d s } \right \rangle \geq 2 C .
$$

By integrating both sides of the above inequality, we obtain

$$
\frac { d } { d s } \langle J , J \rangle \geq 2 C s + \left ( \frac { d } { d s } \langle J , J \rangle \right ) _ { s = 0 } = 2 C s + 2 \left \langle \frac { D J } { d s } ( 0 ) , J ( 0 ) \right \rangle = 2 C s .
$$

Another integration yields

$$
\langle J , J \rangle \geq C s ^ { 2 } + \langle J ( 0 ) , J ( 0 ) \rangle = C s ^ { 2 } .
$$

By setting s = l in the above expression and noticing C =   w,w   , we obtain

$$
\langle J ( l ) , J ( l ) \rangle \geq l ^ { 2 } \langle w , w \rangle .
$$

Since J(l) = l(d exp p ) lv (w) , we ﬁnally conclude that

$$
\langle ( d \exp _ { p } ) _ { l v } ( w ) , ( d \exp ) _ { l v } ( w ) \rangle \geq \langle w , w \rangle .
$$

For later use, it is convenient to establish the following consequence of the above proof.

COROLLARY ( of the proof ). Let K ≡ 0 . Then exp p : T p ( S ) → S , p ∈ S , is a local isometry.

[Page 408]

It sufﬁces to observe that if K ≡ 0, it is possible to substitute “ ≥ 0” by “ ≡ 0” in Eqs. (1), (2), and (3) of the above proof.

PROPOSITION 7. Let S be a complete surface with Gaussian curvature K ≤ 0 . Then the map exp p : T p ( S ) → S , p ∈ S , is a covering map.

Proof . Since we know that exp p is a local diffeomorphism, it sufﬁces (by Prop. 6) to show that exp p has the property of lifting arcs. Let : [0 ] be an arc in and also let be such that

α ,l → S S v ∈ T p (S) exp p v = α( 0 ) . Such a v exists since S is complete. Because exp p is a local diffeomorphism, there exists a neighborhood U of v in T p (S) such that exp p restricted to U is a diffeomorphism. By using exp − 1 p in exp p (U) , it is possible to deﬁne ˜ α in a neighborhood of 0. Now let A be the set of t ∈ [0 ,l ] such that ˜ α is deﬁned in [0 ,t ]. A is

nonempty, and if ˜ α(t 0 ) is deﬁned, then ˜ α is deﬁned in a neighborhood of t 0 ; that is, A is open in [0 ,l ]. Once we prove that A is closed in [0 ,l ], we have, by connectedness of [0 ,l ], that A = [0 ,l ] and α may be entirely lifted. The crucial point of the proof consists, therefore, in showing that A is

The crucial point of the proof consists, therefore, in showing that A is closed in [0 , l ]. For this, let t 0 ∈ [0 , l ] be an accumulation point of A and { t n } be a sequence with { t n } → t 0 , t n ∈ A , n = 1 , 2 , . . . . We shall first prove that ˜ α(tn ) has an accumulation point.

disk D of T p (S) , withcenter ˜ α( 0 ) , thereisan n 0 suchthat ˜ α(t n 0 )  ∈ D . Itfollows that the distance, in T p (S) , from ˜ α( 0 ) to ˜ α(t n ) becomes arbitrarily large. Since, by Lemma 1, exp p : T p (S) → S increases lengths of the vectors, we obtain, by setting d as the distance in T p (S) ,

$$
l _ { [ 0 , t _ { n } ] } & = \int _ { 0 } ^ { t _ { n } } | \alpha ^ { \prime } ( t ) | \, d t = \int _ { 0 } ^ { t _ { n } } | d \exp _ { p } ( \tilde { \alpha } ^ { \prime } ) | \, d t \\ & \geq \int _ { 0 } ^ { t _ { n } } | \tilde { \alpha } ^ { \prime } ( t ) | \, d t = d ( \tilde { \alpha } ( 0 ) , \tilde { \alpha } ( t _ { n } ) ) . \\ \intertext { i s t h a t h e l g h o w f a c h e w e n $ 0 $ a n d t . b e c h o m e s a r b i t r a i l }
$$

This implies that the length of α between 0 and t n becomes arbitrarily large, a contradiction that proves the assertion.

We shall denote by q an accumulation point of ˜ α(t n ) . Now let V be a neighborhood of q in T p (S) such that

the restriction of exp p to V is a diffeomorphism. Since q is an accumulation point of {˜ α(t n ) } , there exists an n 1 such that ˜ α(t n 1 ) ∈ V . Moreover, since α is continuous, there exists an open interval I ⊂ [0 ,l ], t 0 ⊂ I , such that α(I) ⊂ exp p (V ) = U . By using the restriction of exp − 1 p in U it is possible to deﬁne a lifting of α in I , with origin in ˜ α(t n 1 ) . Since exp p is a local diffeomorphism, this lifting coincides with ˜ α in [0 ,t 0 ) ∩ I and is therefore an extension of ˜ α to an interval containing t 0 . Thus, the set A is closed, and this ends the proof of Prop. 7.

[Page 409]

Remark 1. It should be noticed that the curvature condition K ≤ 0 was used only to guarantee that exp p : T p (S) → S is a length-increasing local diffeomorphism. Therefore, we have actually proved that if ϕ : S 1 → S 2 is a local diffeomorphism of a complete surface S 1 onto a surface S 2 , which is length-increasing, then ϕ is a covering map .

The following proposition, known as the Hadamard theorem, describes the topological structure of a complete surface with curvature K ≤ 0.

THEOREM 1 (Hadamard). Let S be a simply connected, complete surface, with Gaussian curvature K ≤ 0 . Then exp p : T p ( S ) → S , p ∈ S , is a diffeomorphism; that is, S is diffeomorphic to a plane.

Proof . By Prop. 7, exp p : T p (S) → S is a covering map. By the corollary of Prop. 5, exp p is a homeomorphism. Since exp p is a local diffeomorphism, its inverse map is differentiable, and exp p is a diffeomorphism. Q.E.D.

We shall now present another geometric application of the covering spaces, also known as the Hadamard theorem. Recall that a connected, compact, regular surface, with Gaussian curvature K > 0, is called an ovaloid (cf. Remark 2, Sec. 5-2).

THEOREM 2 (Hadamard). Let S be an ovaloid. Then the Gauss map N: S → S 2 is a dijfepmorphism. In particular, S is diffeomorphic to a sphere.

Proof . Since for every p ∈ S the Gaussian curvature of S , K = det ( dN p ) , is positive, N is a local diffeomorphism. By Prop. 1, N is a covering map. Since the sphere S 2 is simply connected, we conclude from the corollary of Prop. 5 that N : S → S 2 is a homeomorphism of S onto the unit sphere S 2 . Since N is a local diffeomorphism, its inverse map is differentiable. Therefore, N is a diffeomorphism. Q.E.D.

Remark 2. Actually, we have proved somewhat more. Since the Gauss map N is a diffeomorphism, each unit vector v of R 3 appears exactly once as a unit normal vector to S . Taking a plane normal to v , away from the surface, and displacing it parallel to itself until it meets the surface, we conclude that S lies on one side of each of its tangent planes. This is expressed by saying that an ovaloid S is locally convex . It can be proved from this that S is actually the boundary of a convex set (that is, a set K ⊂ R 3 such that the line segment joining any two points p , q ∈ K belongs entirely to K ).

Remark 3. The fact that compact surfaces with K > 0 are homeomorphic to spheres was extended to compact surfaces with K ≥ 0 by S. S. Chern and R. K. Lashof ('On the Total Curvature of Immersed Manifolds,' Michigan Math. J . 5 (1958), 5-12). A generalization for complete surfaces was first obtained by J. J. Stoker ('Über die Gestalt der positiv gekrümnten offenen Fläche,' Compositio Math. 3(1936), 58-89), who proved, among other things, the following: A complete surface with K > 0 is homeomorphic to a sphere or a plane . This result still holds for K ≥ 0 if one assumes that at some point K > 0 (for a proof and a survey of this problem, see M. do Carmo and E. Lima, 'Isometric Immersions with Non-negative Sectional Curvatures,' Boletim da Soc. Bras. Mat. 2 (1971), 9-22).

[Page 410]

# EXERCISES

1. Show that the map π : R → S 1 = { (x,y) ∈ R 2 ; x 2 + y 2 = 1 } that is given by π(t) = ( cos t, sin t) , t ∈ R , is a covering map. 2. Show that the map π : R 2 0 , 0 R 2 0 , 0 given by

Show that the map π : R 2 -{ 0 , 0 } → R 2 -{ 0 , 0 } given by

$$
\pi ( x , y ) & = ( x ^ { 2 } - y ^ { 2 } , 2 x y ) , \quad ( x , y ) \in R ^ { 2 } , \\
$$

is a two-sheeted covering map.

=

generated by the normals to the helix the z axis and let π : S − L → R 2 −{ 0 , 0 } (x,y) . Show that π is a covering map.

functions of a complex variable will have noticed that the map π in Exercise 2 is nothing but the map π(z) = z 2 from C −{ 0 } onto C −{ 0 } ; here C is the complex plane and z ∈ C . Generalize that by proving that the map π : C −{ 0 } → C −{ 0 } given by π(z) = z n is an n -sheeted covering map. 5. Let B R 3 be an arcwise connected set. Show that the following two

Let B ⊂ R 3 be an arcwise connected set. Show that the following two properties are equivalent (cf. Def. 3):

1. For any pair of points p , q ∈ B and any pair of arcs α 0 : [0 ,l ] → B , α 1 : [0 ,l ] → B , there exists a homotopy in B joining α 0 to α 1 . 2. For any p B and any arc α : [0 ,l ] B with α( 0 ) α(l) p

For any p ∈ B and any arc α : [0 , l ] → B with α( 0 ) = α(l) = p (that is, α is a closed arc with initial and end point p) there exists a homotopy joining α to the constant arc α(s) = p , s ∈ [0 , l ].

- 6. p 0 ∈ R ϕ t R → R t ∈ , by ϕ t (p) = tp 0 + ( 1 − t)p , p ∈ R 2 . Notice that ϕ 0 (p) = p , ϕ 1 (p) = p 0 . Thus, ϕ t is a continuous family of maps which starts with the identity map and ends with the constant map p 0 . Apply these considerations to prove that R 2 is simply connected.
- 7. a. Use stereographic projection and Exercise 6 to show that any closed arc on a sphere S 2 which omits at least one point of S 2 is homotopic to a constant arc.


[Page 411]

8. ( Klingenberg’sLemma .) Let S ⊂ R 3 beacompletesurfacewithGaussian curvature K ≤ K 0 , where K 0 is a nonnegative constant. Let p , q ∈ S and let γ 0 and γ 1 be two distinct geodesics joining p to q , with l(γ 0 ) ≤ l(γ 1 ) ; here l( ) denotes the length of the corresponding curve. Assume that γ 0 is homotopic to γ 1 ; i.e., there exists a continuous family of curves α t , t ∈ [0 , 1], joining p to q with α 0 = γ 0 , α 1 = γ 1 . The aim of this exercise is to prove that there exists a t 0 ∈ [0 , 1] such that

$$
l ( \gamma _ { 0 } ) + l ( \alpha _ { t _ { 0 } } ) \geq \frac { 2 \pi } { \sqrt { K _ { 0 } } } .
$$

(Thus, the homotopy has to pass through a “long” curve. See Fig. 5-29.) Assume that l(γ 0 ) < π/ √ K 0 (otherwise there is nothing to prove) and proceed as follows.

![The image consists of a diagram of a human body, specifically focusing on the human torso. The diagram is labeled with the following points: 1. **Vertebrae**: There are five vertebrae in the human body, which are the main parts of the spine. The vertebrae are connected to the spinal column, which is the main structure of the spine. 2. **Spinal Column**: The spinal column is a long, thin structure that connects the brain and the spinal cord. It is the central part of the spine and connects the brain to the spinal cord. 3. **Spinal Cord**: The spinal cord is a long, thin bundle of nerve fibers that runs from the brain to the spinal cord. It is responsible for transmitting signals from the brain to the body's organs and tissues. 4. **Spinal Plate**: The spinal plate is a flat, circular structure that surrounds the spinal column and protects the spinal cord. It is the outermost layer of the spine and helps](<images/imageFile56.png>)

p

q

γ

1

Figure 5-29. Klingenberg’s lemma.

γ

0

a. Use the ﬁrst comparison theorem (cf. Exercise 3, Sec. 5-5) to prove that exp p : T p (S) → S has no critical points in an open disk B of radius π/ √ K 0 about p .

[Page 412]

$$
l ( \gamma _ { 0 } ) + l ( \alpha _ { t ( \epsilon ) } ) \geq \frac { 2 \pi } { \sqrt { K _ { 0 } } } - 2 \epsilon .
$$

d. Choose in part c a sequence of ǫ ′ s , { ǫ n } → 0, and consider a converging subsequence of { t(ǫ n ) } . Conclude the existence of a curve α t 0 , t 0 ∈ [0 , 1], such that

$$
l ( \gamma _ { 0 } ) + l ( \alpha _ { t _ { 0 } } ) \geq \frac { 2 \pi } { \sqrt { K _ { 0 } } } .
$$

9. a. Use Klingenberg’s lemma to prove that if S is a complete, simply connected surface with K ≥ 0, then exp p : T p (S) → S is one-to-one. b. UsepartatogiveasimpleproofofHadamard’stheorem(Theorem1).

Usepart a to give a simple proof of Hadamard's theorem (Theorem 1).

*10. ( Synge’sLemma .)Werecallthatadifferentiableclosedcurveonasurface S is a differentiable map α : [0 ,l ] → S such that α and all its derivatives agree at 0 and l . Two differentiable closed curves α 0 , α 1 : [0 ,l ] → S are freely homotopic if there exists a continuous map H : [0 ,l ] × [0 , 1] → S such that H(s,O) = α 0 (s) , H(s,t) − α 1 (s) , s ∈ [0 ,l ]. The map H is called a free homotopy (the end points are not ﬁxed) between α 0 and α 1 . Assume that S is orientable and has positive Gaussian curvature. Prove that any simple closed geodesic on S is freely homotopic to a closed curve of smaller length.

11. Let S be a complete surface. A point p ∈ S is called a pole if every geodesic γ : [0 , ∞ ) → S with γ( 0 ) = p contains no point conjugate to p relative to γ . Use the techniques of Klingenberg’s lemma (Exercise 8) to prove that if S is simply connected and has a pole p , then exp p : T p (S) → S is a diffeomorphism.

# 5-7. Global Theorems for Curves: The Fary-Milnor Theorem

ln this section, some global theorems for closed curves will be presented. The main tool used here is the degree theory for continuous maps of the circle. To introduce the notion of degree, we shall use some properties of covering maps developed in Sec. 5-6.

[Page 413]

6π

2π

4π

![In this image, we can see a diagram with some lines and points.](<images/imageFile57.png>)

R

0

=

(0)

+2π

+4π

f

x

x

x

π

(

)

f

t

f  

f

=

(0)

f

p

t

(

)

f

t

0

1

l

s

Figure 5-30

Let S 1 = { (x,y) ∈ R 2 ; x 2 + y 2 = 1 } and let π : R → S 1 be the covering of S 1 by the real line R given by

$$
\pi ( x ) = ( \cos x , \sin x ) , \ \ x \in R .
$$

Let ϕ : S 1 → S 1 be a continuous map. The degree of ϕ is deﬁned as follows. We can think of the ﬁrst S 1 in the map ϕ : S 1 → S 1 as a closed interval [0 ,l ] with its end points 0 and l identiﬁed. Thus, ϕ can be thought of as a continuous map ϕ : [0 ,l ] → S 1 , with ϕ( 0 ) = ϕ(l) = p ∈ S 1 . Thus, ϕ is a closed arc at p in S 1 which, by Prop. 2 of Sec. 5-6, can be lifted into a unique arc ˜ ϕ :[0 ,l ] → R , starting at a point x ∈ R with π(x) = p . Since π( ˜ ϕ( 0 )) = π( ˜ ϕ(l)) , the difference ˜ ϕ(l) − ˜ ϕ( 0 ) isanintegralmultipleof2 π . Theintegerdeg ϕ givenby

$$
\tilde { \varphi } ( l ) - \tilde { \varphi } ( 0 ) = ( \deg \varphi ) 2 \pi
$$

is called the degree of ϕ .

Intuitively, deg ϕ is the number of times that ϕ : [0 ,l ] → S 1 “wraps” [0 ,l ] around S 1 (Fig. 5-30). Notice that the function ˜ ϕ : [0 ,l ] → R is a continuous determination of the positive angle that the ﬁxed vector ϕ( 0 ) − O makes with ϕ(t) − O , t ∈ [0 ,l) , O = ( 0 , 0 ) —e.g., the map π : S 1 → S 1 described in Example 4 of Sec. 5-6, Part A, has degree k .

We must show that the deﬁnition of degree is independent of the choices of p and x .

First, deg ϕ is independent of the choice of x . In fact, let x 1 > x be a point in R such that π(x 1 ) = p , and let ˜ ϕ 1 (t) = ˜ ϕ(t) + (x 1 − x) , t ∈ [0 ,l ]. Since x 1 − x is an integral multiple of 2 π , ˜ ϕ 1 is a lifting of ϕ starting at x 1 . By the uniqueness part of Prop. 2 of Sec. 5-6, ˜ ϕ 1 is the lifting of ϕ starling at x 1 . Since

$$
\tilde { \varphi } _ { 1 } ( l ) - \tilde { \varphi } _ { 1 } ( 0 ) = \tilde { \varphi } ( l ) - \tilde { \varphi } ( 0 ) = ( \deg \varphi ) 2 \pi ,
$$

the degree of ϕ is the same whether computed with x or with x 1 .

[Page 414]

Second, deg ϕ is independent of the choice of p ∈ S 1 . In fact, each point p 1 ∈ S 1 , except the antipodal point of p , belongs to a distinguished neighborhood U 1 of p . Choose x 1 , intheconnectedcomponentof π − 1 (U 1 ) containing x , such that π(x 1 ) = p 1 , and let ˜ ϕ 1 be the lifting of

$$
\varphi \colon [ 0 , l ] \to S ^ { 1 } , \varphi ( 0 ) = p _ { 1 } ,
$$

starting at x 1 . Clearly, | ˜ ϕ 1 ( 0 ) − ˜ ϕ( 0 ) | < 2 π . It follows from the stepwise process through which liftings are constructed (cf. the proof of Prop. 2, Sec. S-6) that | ˜ ϕ 1 (l) − ˜ ϕ 1 (l) < 2 π . Since both differences ˜ ϕ(l) − ˜ ϕ( 0 ) , ˜ ϕ 1 (l) − ˜ ϕ 1 ( 0 ) must be integral multiples of 2 π , their values are actually equal. By continuity, the conclusion also holds for the antipodal point of p , and this proves our claim.

The most important property of degree is its invariance under homotopy. More precisely, let ϕ 1 , ϕ 2 : S 1 → S 1 be continuous maps. Fix a point p ∈ S 1 , thus obtaining two closed arcs at p , ϕ 1 , ϕ 2 : [0 ,l ] → S 1 , ϕ 1 ( 0 ) = ϕ 2 ( 0 ) = p . If ϕ 1 and ϕ 2 are homotopic, then deg ϕ 1 = deg ϕ 2 . This follows immediately from the fact that (Prop. 4, Sec. 5-6) the liftings of ϕ 1 and ϕ 2 starting from a ﬁxed point x ∈ R are homotopic, and hence have the same end points. It should be remarked that if ϕ : [0 ,l ] → S 1 is differentiable, it determines

differentiable functions a = a(t) , b = b(t) , given by ϕ(t) = (a(t),b(t)) , which satisfy the condition a 2 + b 2 = 1. In this case, the lifting ˜ ϕ , starting at ˜ ϕ 0 = x , is precisely the differentiable function (cf. Lemma 1, Sec. 4-4). t

$$
\tilde { \varphi } ( t ) & = \tilde { \varphi } _ { 0 } + \int _ { 0 } ^ { t } ( a b ^ { \prime } - b a ^ { \prime } ) \, d t . \\ \vdots & \\ & \vdots \quad \, \sin ( a b ^ { \prime } - b a ^ { \prime } ) \, d t .
$$

Thisfollowsfromtheuniquenessoftheliftingandthefactthatcos ˜ ϕ(t) = a(t) , sin ˜ ϕ(t) = b(t) , ˜ ϕ( 0 ) = ˜ ϕ 0 . Thus, in the differentiable case, the degree of ϕ can be expressed by an integral,

$$
\deg \varphi = \frac { 1 } { 2 \pi } \int _ { 0 } ^ { l } \frac { d \tilde { \varphi } } { d t } \, d t . \\
$$

In the latter form, the notion of degree has appeared repeatedly in this book. For instance, when v : U ⊂ R 2 → R 2 , U ⊃ S 1 , is a vector ﬁeld, and ( 0 , 0 ) is its only singularity, the index of v at ( 0 , 0 ) (cf. Sec. 4-5, Application 7) may be interpreted as the degree of the map ϕ : S 1 → S 1 that is given by ϕ(p) = v(p)/ | v(p) | , p ∈ S 1 .

Before going into further examples, let us recall that a closed (differentiable) curve is a differentiable map α : [0 ,l ] → R 3 (or R 2 , if it is a plane curve) such that the components of α , together with all its derivatives, agree at 0 and l . The curve α is regular if α ′ (t)  = 0 for all t ∈ [0 ,l ], and α is simple if whenever t 1  = t 2 , t 1 ,t 2 ∈ [0 ,l) , then α(t 1 )  = α(t 2 ) . Sometimes it is

[Page 415]

Example 1 ( The Winding Number of a Curve ). Let α : [0 ,l ] → R 2 be a plane, continuous closed curve. Choose a point p 0 ∈ R 2 , p 0 / ∈ α( [0 ,l ] ) , and let ϕ : [0 ,l ] → S 1 be given by

$$
\varphi ( t ) = \frac { \alpha ( t ) - P _ { 0 } } { | \alpha ( t ) - P _ { 0 } | } , \quad t \in [ 0 , l ] . \\
$$

Clearly ϕ( 0 ) = ϕ(l) , and ϕ may be thought of as a map of S 1 into S 1 ; it is calledthe positionmap of α relativeto p 0 . Thedegreeof ϕ iscalledthe winding number (or the index) of the curve α relative to p 0 (Fig. 5-31).

![The diagram consists of a circle with a center at the top of the circle. Inside the circle, there are two points labeled as A and B. Point A is located on the circumference of the circle and point B is located on the circumference of the circle. There are two lines, labeled as l and p, that intersect at point S.](<images/imageFile58.png>)

(

)

α

t

β

(

) -

α

t

p

0

(

) -

α

t

p

0

p

0

1

S

Figure 5-31

Notice that by moving p 0 along an arc β which does not meet α( [0 ,l ] ) the winding number remains unchanged. Indeed, the position maps of α relative to any two points of β can clearly be joined by a homotopy. It follows that the winding number of α relative to q is constant when q runs in a connected component of R 2 − α( [0 ,l ] ) . 2

Example 2 ( The Rotation Index of a Curve ). Let α : [0 ,l ] → R be a regular plane closed curve, and let ϕ : [0 ,l ] → S 1 be given by

$$
\varphi ( t ) = \frac { \alpha ^ { \prime } ( t ) } { | \alpha ^ { \prime } ( t ) | } , \ t \in [ 0 , l ] . \\ \text {tangible and so} ( 0 ) = \varphi ( l ) \, \varphi _ { i } \, \text {so all} \, t
$$

Clearly ϕ is differentiable and ϕ( 0 ) = ϕ(l) . ϕ is called the tangent map of α , and the degree of ϕ is called the rotation index of α . Intuitively, the rotation index of a closed curve is the number of complete turns given by the tangent vector ﬁeld along the curve (Fig. 1-27, Sec. 1-7).

It is possible to extend the notion of rotation index to piecewise regular curves by using the angles at the vertices (see Sec. 4-5) and to prove that the rotation index of a simple, closed, piecewise regular curve is ± 1 (the theorem ofturningtangents).ThisfactisusedintheproofoftheGauss-Bonnettheorem.

[Page 416]

Later in this sect ion we shall prove a differentiable version of the theorem of turning tangents.

Our ﬁrst global theorem will be a differentiable version of the so-called Jordan curve theorem. For the proof we shall presume some familiarity with the material of Sec. 2-7.

THEOREM 1 (Differentiable Jordan Curve Theorem). Let α : [0 ,l ] → R 2 be a plane, regular, closed, simple curve. Then R 2 → α( [0 ,l ] ) has exactly two connected components, and α( [0 ,l ] )) is their common boundary.

Proof . Let N ǫ (α) be a tubular neighborhood of α( [0 ,l ] ) . This is constructedinthesamewayasthatusedforthetubularneighborhoodofacompact surface (cf. Sec. 2-7). We recall that N ǫ (α) is the union of open normal segments I ǫ (t) , with length 2 ǫ and center in α(t) . Clearly, N ǫ (α) − α( [0 ,l ] ) has two connected components T 1 and T 2 . Denote by w(p) the winding number of α relative to p ∈ R 2 − α( [0 ,l ] ) . The crucial point of the proof is to show that if both p 1 and p 2 belong to distinct connected components of N ǫ (α) − α( [0 ,l ] ) andtothesame I ǫ (t 0 ) , t 0 ∈ [0 ,l ], then w(p 1 ) − w(p 2 ) = ± 1, the sign depending on the orientation of α .

Choose points A = α(t 1 ) , D = α(t 2 ) , t 1 < t 0 < t 2 , so close to t 0 that the arc AD of α can be deformed homotopically onto the polygon ABCD of Fig. 5-32. Here BC is a segment of the tangent line at α(t) , and BA and CD are parallel to the normal line at α(t 0 ) . 2

Let us denote by β : [0 , ¯ l ] → R the curve obtained from α by replacing the arc AD by the polygon ABCD , and let us assume that β( 0 ) = β( ¯ l) = A and that β(t 3 ) = D . Clearly, w(p 1 ) and w(p 2 ) remain unchanged. 1

3 = 1 2

Let ϕ 1 of β relative p 1 , p 2 , respectively (cf. Example l), and let ˜ ϕ 1 , ˜ ϕ 2 : [0 , ¯ l ] → R be their liftings from a ﬁxed point, say 0 ∈ R . For convenience, let us assume the orientation of β to be given as in Fig. 5-32.

We ﬁrst remark that if t ∈ [ t 3 , ¯ l ], the distances from α(t) to both p 1 and p 2 remain bounded below by a number independent t , namely, the smallest of the two numbers dist( p 1 , Bd N ǫ (α) ) and dist( p 2 , Bd N ǫ (α) ). It follows that the angle of α(t) − p 1 with α(t) − p 2 tends uniformly to zero in (t 3 , ¯ l ] as p 1 approaches p 2 .

Now, it is clearly possible to choose p 1 and p 2 so close to each other that ˜ ϕ 1 (t 3 ) − ˜ ϕ 1 ( 0 ) = π − ǫ 1 , and ˜ ϕ 2 (t 3 ) − ˜ ϕ 2 ( 0 ) = − (π + ǫ 2 ) , with ǫ 1 and ǫ 2 smaller than π/ 3. Furthermore,

$$
2 \pi ( w ( p _ { 1 } ) - w ( p _ { 2 } ) ) & = ( \tilde { \varphi } _ { 1 } ( \bar { l } ) - \tilde { \varphi } _ { 1 } ( 0 ) - ( \tilde { \varphi } _ { 2 } ( \bar { l } ) - \tilde { \varphi } _ { 2 } ( 0 ) ) \\ & = \{ ( \tilde { \varphi } _ { 1 } - \tilde { \varphi } _ { 2 } ) ( \tilde { l } ) - ( \tilde { \varphi } _ { 1 } - \tilde { \varphi } _ { 2 } ) ( t _ { 3 } ) \} \\ & + \{ ( \tilde { \varphi } _ { 1 } - \tilde { \varphi } _ { 2 } ) ( t _ { 3 } ) - ( \tilde { \varphi } _ { 1 } - \tilde { \varphi } _ { 2 } ) ( 0 ) \} .
$$

$$
+ \{ ( \tilde { \varphi } _ { 1 } - \tilde { \varphi } _ { 2 } ) ( t _ { 3 } ) - ( \tilde { \varphi } _ { 1 } - \tilde { \varphi } _ { 2 } ) ( 0 ) \} .
$$

[Page 417]

Tubular

![The image depicts a geometric diagram involving a plane and a plane intersection. The diagram includes several points and lines, which are labeled as follows: 1. **Plane Intersection**: - The diagram shows a plane intersecting a plane at two points. - The plane is labeled as P and the plane is labeled as Q. 2. **Plane Intersection Point**: - The plane intersects the plane at point P. - The intersection point is labeled as P. 3. **Plane Intersection Point**: - The plane intersects the plane at point Q. - The intersection point is labeled as Q. 4. **Plane Intersection Point**: - The plane intersects the plane at point Q. - The intersection point is labeled as Q. 5. **Plane Intersection Point**: - The plane intersects the plane at point Q. - The intersection point is labeled as Q. 6. **Plane Intersection Point**:](<images/imageFile59.png>)

neighborhood

p

1

B

C

A

D

(

)

α

t

0

p

2

Orientation of the plane

p

1

C

B

=

(

) =

(

)

D

α

t

β

t

p

2

3

2

) =

(0)

=

(

β

A

α

t

1

(

)

α

t

Figure 5-32

By the above remark, the ﬁrst term can be made arbitrarily small, say equal to ǫ 1 < π/ 3, if p 1 is sufﬁciently close to p 2 . Thus,

$$
2 \pi ( w ( p _ { 1 } ) - w ( p _ { 2 } ) ) = \epsilon _ { 3 } + \pi - \epsilon _ { 1 } - ( - \pi - \epsilon _ { 2 } ) = 2 \pi + \epsilon ,
$$

where ǫ <π if p 1 is sufﬁciently close to p 2 . It follows that w(p 1 ) − w(p 2 ) = 1, as we had claimed.

It is now easy to complete the proof. Since w(p) is constant in each connected component of R 2 − α( [0 ,l ] ) = W , it follows from the above that there are at least two connected components in W . We shall show that there are exactly two such components.

In fact, let C be a connected component of W . Clearly Bd C  = φ and Bd C ⊂ α( [0 ,l ] ) . On the other hand, if p ∈ α( [0 ,l ] ) , there is a neighborhood of p that contains only points of α( [0 ,l ] ) , points of T 1 , and points of T 2 (T 1 and T 2 are the connected components of N ǫ (α) − α( [0 ,l ] )) . Thus, either T 1 or T 2 intersects C . Since C is a connected component, C ⊃ T 1 , or C ⊃ T 2 . Therefore, there are at most two (hence, exactly two) connected components of W . Denote them by C 1 and C 2 . The argument also shows that Bd C 1 = α( [ O,l ] ) = Bd C 2 . Q.E.D.

[Page 418]

The two connected components given by Theorem 1 can easily be distinguished. One starts from the observation that if p 0 is outside a closed disk D containing α( [0 ,l ] ) (since [0 ,l ] is compact, such a disk exists), then the winding number of α relative to p 0 is zero. This comes from the fact that the lines joining p 0 to α(t) , t ∈ [0 ,l ], are all within a region containing D and bounded by the two tangents from p 0 to the circle Bd D . Thus, the connected component with winding number zero is unbounded and contains all points outside a certain disk. Clearly the remaining connected component has winding number ± 1 and is bounded. It is usual to call them the exterior and the interior of α , respectively.

Remark 1. A useful complement to the above theorem, which was used in the applications of the Gauss-Bonnet theorem (Sec. 4-5), is the fact that the interior of α is homeomorphic to an open disk. Aproof of that can be found in J. J. Stoker, Differential Geometry , Wiley-Interscience, New York, 1969, pp. 43–45.

We shall now prove a differentiable version of the theorem of turning tangents.

THEOREM 2. Let β : [0 ,l ] → R 2 be a plane, regular, simple, closed curve. Then the rotation index of β is ± 1 (depending on the orientation of β ).

Proof . Consider a line that does not meet the curve and displace it parallel to itself until it is tangent to the curve. Denote by L (this position of the line and by p a point of tangency of the curve with L . Clearly the curve is entirely on one side of L (Fig. 5-33). Choose a new parametrization α : [0 ,l ] → R 2 for the curve so that α( 0 ) = p . Now let

$$
T = \{ ( t _ { 1 } , t _ { 2 } ) \in [ 0 , l ] \times [ 0 , l ] ; 0 \leq t _ { 1 } \leq t _ { 2 } \leq l \}
$$

be a triangle, and deﬁne a “secant map” ψ : T → S 1 by

$$
\psi ( t _ { 1 } , t _ { 2 } ) & = \frac { \alpha ( t _ { 2 } ) - \alpha ( t _ { 1 } ) } { | \alpha ( t _ { 2 } ) - \alpha ( t _ { 1 } ) | } \quad \text {for } t _ { 1 } \neq t _ { 2 } , ( t _ { 1 } , t _ { 2 } ) \in T - \{ ( 0 , l ) \} \\ \psi ( t , t ) & = \frac { \alpha ^ { \prime } ( t ) } { | \alpha ^ { \prime } ( t _ { 2 } ) | } , \quad \psi ( 0 , l ) = - \frac { \alpha ^ { \prime } ( 0 ) } { | \alpha ^ { \prime } ( 0 ) | } .
$$

$$
( t , t ) & = \frac { \alpha ( t ) } { | \alpha ^ { \prime } ( t _ { 2 } ) | } , \quad \psi ( 0 , l ) = - \frac { \alpha ^ { \prime } ( 0 ) } { | \alpha ^ { \prime } ( 0 ) | } . \\ \dot { \cdot } & \\ \dot { \cdot } & = 1 , \quad \dot { \psi } ( 0 , l ) = - \frac { 1 } { | \alpha ^ { \prime } ( 0 ) | } .
$$

Since α is regular, ψ is easily seen to be continuous. Let A = ( 0 , 0 ) , B = ( 0 ,l) , C = (l,l) be the vertices of the triangle T . Notice that ψ restricted to the side AC is the tangent map of α , the degree of which is the rotation number of α . Clearly (Fig. 5-33), the tangent map is homotopic to the restriction of ψ to the remaining sides AB and BC . Thus, we are reduced to show that the degree of the latter map is ± 1. Assume that the orientations of the plane and the curve are such that the

oriented angle from α ′ ( 0 ) to − α ′ ( 0 ) is π . Then the restriction of ψ to AB

[Page 419]

= (0,

)

![The image consists of a diagram with two main components. The diagram is a circle with a point labeled as O in the center. The diagram is labeled as O and has a line segment labeled as P that connects the point O to the center of the circle. The line segment P is a line segment that connects the point O to the center of the circle. The diagram also includes two other lines, labeled as A and B, which are parallel to the line segment P. These lines are connected to the point O and the center of the circle. The diagram is labeled as O and has a line segment labeled as P that connects the point O to the center of the circle. The line segment P is a line segment that connects the point O to the center of the circle. The diagram also includes two other lines, labeled as](<images/imageFile60.png>)

= (

,

)

B

l

C

l

l

(0, 0)

A

ψ

α´(0)

l

p

Figure 5-33

covers half of S 1 in the positive direction, and the restriction of ψ to BC covers the remaining half also in the positive direction (Fig. 5-33). Thus, the degree of ψ restricted to AB and BC is + 1. Reversing the orientation, we shall obtain − 1 for this degree, and this completes the proof. Q.E.D.

The theorem of turning tangents can be used to give a characterization of an important class of curves, namely the convex curves. 2

A plane, regular, closed curve α : [0 ,l ] → R is convex if, for each t ∈ [0 ,l ], the curve lies in one of the closed half-planes determined by the tangent lineat t (Fig. 5-34; cf. alsoSec. 1-7). If α issimple, convexitycanbeexpressed in terms of curvature. We recall that for plane curves, curvature always means the signed curvature (Sec. 1-5, Remark 1).

![In this image, we can see a diagram with some text and numbers.](<images/imageFile61.png>)

(a)

(b)

(c)

Convex curve

Nonconvex curves

Figure 5-34

[Page 420]

PROPOSITION 1. A plane, regular, closed curve is convex if and only if it is simple and its curvature k does not change sign.

Proof . Let ϕ : [0 ,l ] → S 1 be the tangent map of α and ˜ ϕ : [0 ,l ] → R be the lifting of ϕ starting at 0 ∈ R . We ﬁrst remark that the condition that k does not change sign is equivalent to the condition that ˜ ϕ is monotonic (nondecreasing if k ≥ 0, or nonincreasing if k ≤ 0). Now, suppose that α is simple and that k does not change sign. We can

orient the plane of the curve so that k ≥ 0. Assume that α is not convex.Then there exists t 0 ∈ [0 ,l ] such that points of α( [0 ,l ] ) can be found on both sides of the tangent line T at α(t 0 ) . Let n = n(t 0 ) be the normal vector at t 0 , and set

$$
h _ { n } ( t ) = \langle \alpha ( t ) - \alpha ( t _ { 0 } ) , n \rangle , \ \ t \in [ 0 , l ] .
$$

Since [0 ,l ] is compact and both sides of T contain points of the curve, the “height function” h n has a maximum at t 1  = t 0 and a minimum at t 2  = t 0 . The tangent vectors at the points t 0 ,t 1 ,t 2 are all parallel, so two of them, say α ′ (t 0 ) , α ′ (t 1 ) , have the same direction. It follows that ϕ(t 0 ) = ϕ(t 1 ) and, by Theorem 2 ( α is simple), ˜ ϕ(t 0 ) = ˜ ϕ(t 1 ) . Let us assume that t 1 > t 0 . By the above remark, ˜ ϕ is monotonic nondecreasing, and hence constant in [ t 0 ,t 1 ]. This means that α( [ t 0 ,t 1 ] ) ⊂ T . But this contradicts the choice of T and shows that α is convex.

Conversely, assume that α is convex. We shall leave it as an exercise to showthatif α isnotsimple, ataself-intersectionpoint(Fig.5-35(a)), ornearby it (Fig. 5-35(b)), the convexity condition is violated. Thus, α is simple.

![In the image, we can see a diagram with two circles. The circles are labeled as \( \sigma \) and \( \rho \). The diagram also includes a point labeled as \( \alpha \).](<images/imageFile62.png>)

3

1

4

2

(a)

(b)

Figure 5-35

We now assume that α is convex and that k changes sign in [0 ,l ]. Then there are points t 1 ,t 2 ∈ [0 ,l ], t 1 < t 2 , with ˜ ϕ(t 1 ) = ˜ ϕ(t 2 ) and ˜ ϕ not constant in [ t 1 ,t 2 ].

We shall show that this leads to a contradiction, thereby concluding the proof. By Theorem 2, there exists t 3 ∈ [0 ,l) with ϕ(t 3 ) = − ϕ(t 1 ) . By convexity, two of the three parallel tangent lines at α(t 1 ) , α(t 2 ),α(t 3 ) must coincide. Assume this to be the case for α(t 1 ) = p , α(t 3 ) = q , t 3 > t 1 . We claim that the arc of α between p and q is the line segment pq .

[Page 421]

In fact, assume that r  = q is the last point for which this arc is a line segment ( r may agree with p ). Since the curve lies in the same side of the line pq , it is easily seen that some tangent T near p will cross the segment pq in an interior point (Fig. 5-36). Then p and q lie on distinct sides of T . That is a contradiction and proves our claim.

![In this image, we can see a diagram. There are two lines, which are labeled as T and T. We can also see a graph.](<images/imageFile63.png>)

T

p

r

q

Figure 5-36

It follows that the coincident tangent lines have the same directions; that is, they are actually the tangent lines at α(t 1 ) and α(t 2 ) . Thus, ˜ ϕ is constant in [ t 1 ,t 2 ], and this contradiction proves that k does not change sign in [0 ,l ].

Q.E.D.

Remark 2. The condition that α is simple is essential to the proposition, as shown by the example of the curve in Fig. 5-34(c).

Remark 3. The proposition should be compared with Remarks 2 and 3 of Sec. 5-6; there it is stated that a similar situation holds for surfaces. It is to be noticed that, in the case of surfaces, the nonexistence of self-intersections is not an assumption but a consequence.

Remark 4. It can be proved that a plane, regular, closed curve is convex if and only if its interior is a convex set K ⊂ R 2 (cf. Exercise 4).

We shall now turn our attention to space curves. In what follows the word curve will mean a parametrized regular curve α : [0 ,l ] → R 3 with arc length s as parameter. If α is a plane curve, the curvature k(s) is the signed curvature of α (cf. Sec. 1-5); otherwise, k(s) is assumed to be positive for all s ∈ [0 ,l ]. It is convenient to call l

$$
\int _ { 0 } ^ { l } | k ( s ) | \, d s
$$

the total curvature of α .

Probably the best-known global theorem on space curves is the so-called Fencbel’s theorem.

THEOREM 3 (Feochel’s Theorem). The total curvature of a simple closed curve is ≥ 2 π , and equality holds if and only if the curve is a plane convex curve.

[Page 422]

Before going into the proof, we shall introduce an auxiliary surface which is also useful for the proof of Theorem 4.

The tube of radius r around the curve α is the parametrized surface

$$
\mathbf x ( s , v ) = \alpha ( s ) + r ( n \cos v + b \sin v ) , \ \ s \in [ 0 , l ] , v \in [ 0 , 2 \pi ] ,
$$

where n = n(s) and b = b(s) are the normal and the binormal vector of α , respectively. It is easily check that

$$
| x _ { s } \wedge x _ { v } | ^ { 2 } = E G - F ^ { 2 } = r ^ { 2 } ( 1 - r k \cos v ) ^ { 2 } .
$$

We assume that r is so small that rk 0 < I , where k 0 < max | k(s) | , s ∈ [0 ,l ]. Then x is regular, and a straightforward computation gives

$$
N & = - ( n \cos v + b \sin v ) , \\ x _ { s } \wedge x _ { v } & = r ( 1 - r k \cos v ) N , \\ N _ { s } \wedge N _ { v } & = k \cos v ( n \cos v + b \sin v ) = - k N \cos v \\ & = - \frac { k \cos v } { r ( 1 - r k \cos v ) } x _ { v } \wedge x _ { s } .
$$

$$
= - \frac { k \cos v } { r ( 1 - r k \cos v ) } x _ { v } \wedge x _ { s } .
$$

It follows that the Gaussian curvature K = K(s,v) of the tube is given by

$$
K ( s , v ) = - \frac { k \cos v } { r ( 1 - r k \cos v ) } . \\
$$

Notice that the trace T of x may have self-intersections. However, if α is simple, it is possible to choose r so small that this does not occur; we use the compactness of [0 ,l ] and proceed as in the case of a tubular neighborhood constructed in Sec. 2-7. If, in addition, α is closed, T is a regular surface homeomorphic to a torus, also called a tube around α . In what follows, we assume this to be the case.

Proof of Theorem 3 . Let T beatubearound α , andlet R ⊂ T betheregion of T where the Gaussian curvature of T is nonnegative. On the one hand,

$$
∫∫ R Kdσ = ∫∫ R K √ EG -F 2 ds dv = ∫ l 0 k ds ∫ 3 π/ 2 π/ 2 cos v dv = 2 ∫ l 0 k(s) ds .
$$

On the other hand, each half-line L through the origin of R 3 appears at least once as a normal direction of R . For if we take a plane P perpendicular to L such that P ∩ T = φ and move P parallel to itself toward T (Fig. 5-37), it will meet T for the ﬁrst time at a point where K ≥ 0.

[Page 423]

![The image consists of a diagram with a circular object and a straight line. The diagram is labeled as The diagram consists of a circle and a straight line. The circle is positioned at the top of the diagram and is connected to the straight line at the bottom. The straight line is positioned at the bottom of the diagram and is connected to the circle at the top.](<images/imageFile64.png>)

L

P

Figure 5-37

It follows that the Gauss map N of R covers the entire unit sphere S 2 at least once; hence,    R Kdσ ≥ 4 π . Therefore, the total curvature of α is ≥ 2 π , and we have proved the ﬁrst part of Theorem 3. Observe that the image of the Gauss map N restricted to each circle s =

Observe that the image of the Gauss map N restricted to each circle s = const. is one-to-one and that its image is a great circle /Gamma1 s ⊂ S 2 . We shall denote by /Gamma1 + s ⊂ /Gamma1 s the closed half-circle corresponding to points where K ≥ 0.

Assume that α is a plane convex curve. Then all /Gamma1 + s have the same end points p , q , and, by convexity, /Gamma1 s 1 ∩ /Gamma1 s 2 = { p } ∪ { q } for s 1 /negationslash= s 2 , s 1 , s 2 ∈ [0 , l) . Bythe first part of the theorem, it follows that ∫∫ R Kdσ = 4 π ; hence, the total curvature of α is equal to 2 π .

the theorem,    R Kdσ = 4 π . We claim that all Ŵ + s have the same end points p and q . Otherwise, there are two distinct great circles Ŵ s 1 ,Ŵ s 2 ,s 1 arbitrarily close to s 2 , that intersect in two antipodal points which are not in N(R ∩ Q) , where Q is the set of points in T with non positive curvature. It follows that there are two points of positive curvature which are mapped by N into a single

[Page 424]

By observing that the points of zero Gaussian curvature in T are the intersections of the binormal of α with T , we see that the binormal vector of α is parallel to the line pq . Thus, α is contained in a plane normal to this line.

We ﬁnally prove that α is convex. We may assume that α is so oriented that its rotation number is positive. Since the total curvature of α is 2 π , we have

$$
2 π l k ds l k ds .
$$

$$
= ∫ 0 | | ≥ ∫ 0 π,
$$

On the other hand,

$$
∫ J k ds ≥ 2
$$

where J = { s ∈ [0 ,l ] ; k(s) ≥ 0 } . This holds for any plane closed curve and follows from an argument entirely similar to the one used for R ⊂ T in the beginning of this proof. Thus,

$$
∫ l 0 k ds = ∫ l 0 | k | ds = 2 π.
$$

Therefore, k ≥ 0, and α is a plane convex curve. Q.E.D.

k ≥ α

Remark 5. It is not hard to see that the proof goes through even if α is not simple. The tube will then have self-intersections, but this is irrelevant to the argument. In the last step of the proof (the convexity of α ), one has to observe that we have actually shown that α is nonnegatively curved and that its rotation index is equal to 1. Looking back at the ﬁrst part of the proof of Prop. 1, one easily sees that this implies that α is convex.

We want to use the above method of proving Fenchel’s theorem to obtain a sharpening of this theorem which states that if a space curve is knotted (a concept to be deﬁned presently), then the total curvature is actually greater than 4 π . 3

A simple closed continuous curve C ⊂ R is unknotted if there exists a homotopy H : S 1 × I → R 3 , I = [0 , 1], such that

$$
H ( S ^ { 1 } \times \{ 0 \} ) & = S ^ { 1 } \\ H ( S ^ { 1 } \times \{ 1 \} ) & = C ; \\ \text {and} \quad H ( S ^ { 1 } \times \{ t \} ) & = C _ { t } \subset R ^ { 3 }
$$

$$
S ^ { 1 } \times \{ t \} ) = C _ { t } \subset R
$$

[Page 425]

![image 65](<images/imageFile65.png>)

Unknotted

![image 66](<images/imageFile66.png>)

Knotted

Figure 5-38

are homeomorphic to S 1 . Such a homotopy is called an isotopy ; an unknotted curve is then a curve isotopic to S 1 . When this is not the case, C is said to be knotted (Fig. 5-38).

THEOREM 4 (Fary-Milnor). The total curvature of a knotted simple closed curve is greater than 4 π .

Proof . Let C = α( [0 ,l ] ) , let T be a tube around α , and let R ⊂ T be the region of T where K ≥ 0. Let b = b(s) be the binormal vector of α , and let v ∈ R 3 be a unit vector, v  = ± b(s) , for all s ∈ [0 ,l ]. Let h v : [0 ,l ] → R be the height function of α in the direction of v ; that is, h v (s) =   α(s) − 0 ,v   , s ∈ [0 ,l ]. Clearly, s is a critical point of h v if and only if v is perpendicular to the tangent line at α(s) . Furthermore, at a critical point,

$$
\frac { d } { d s ^ { 2 } } ( h _ { v } ) = \left \langle \frac { d ^ { 2 } \alpha } { d s ^ { 2 } } , v \right \rangle = k \langle u , v \rangle \neq 0 , \\
$$

since: v  = ± b(s) for all s and k > 0. Thus, the critical points of h v are either maxima or minima.

Now, assume the total curvature of α to be smaller than or equal to 4 π . This means that

$$
\iint _ { R } K \, d \sigma = 2 \int k \, d s \leq 8 \pi . \\
$$

We claim that, for some v 0 / ∈ ± b( [0 ,l ] ) , h v 0 has exactly two critical points (since [0 ,l ] is compact, such points correspond to the maximum and minimum of h v 0 ) . Assume that the contrary is true. Then, for every v / ∈ b( [0 ,l ] ) , h v has at least three critical points. We shall assume that two of them are points of minima, s 1 and s 2 , the case of maxima being treated similarly.

Consider a plane P perpendicular to v such that P ∩ T = φ , and move it parallel to itself toward T . Either h v (s 1 ) = h v (s 2 ) or, say, h v (s 1 ) < h v (s 2 ) . In the ﬁrst case, P meets T at points q 1  = q 2 , and since v / ∈ b( [0 ,l ] ) , K(q 1 ) and K(q 2 ) are positive. In the second case, before meeting α(s 1 ) , P will meet T at a point q 1 with K(q 1 ) > 0. Consider a second plane ¯ P , parallel to and at a distance r above P ( r is the radius of the tube T ). Move ¯ P further up until it reaches α(s 2 ) ; then P will meet T at a point q 2  = q 1 (Fig. 5-39). Since s 2 is a point of minimum and v / ∈ b( [0 ,l ] ) , K(q 2 ) > 0. In any case, there are two

[Page 426]

(

)

![In the diagram, there is a diagram of a cylinder with a circular base and a circular top. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular top and a circular base. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular top and a circular base. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular top and a circular base. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular top and a circular base. The cylinder is depicted with a circular base and a circular top. The cylinder is depicted with a circular base and a circular](<images/imageFile67.png>)

h

s

2

v

r

P

P

q

2

P

r

P

q

(

)

1

s

h

1

v

Figure 5-39

S 2 . This contradicts the fact that    R Kdσ ≤ 8 π , and proves our claim. Let s 1 and s 2 be the critical points of h v 0 , and let P 1 and P 2 be planes perpendicular to v 0 and passing through α(s 1 ) and α(s 2 ) , respectively. Each plane parallel to v 0 and between P 1 and P 2 will meet C in exactly two points. Joining these pairs of points by line segments, we generate a surface bounded by C which is easily seen to be homeomorphic to a disk. Thus, C is unknotted, and this contradiction completes the proof. Q.E.D.

# EXERCISES

- 1. Determine the rotation indices of curves (a), (b), (c), and (d) in Fig. 5-40.
- 2. Let α(t) = (x(t),y(t)) , t ∈ [0 ,l ], be a differentiable plane closed curve. Let p 0 = (x 0 ,y 0 ) ∈ R 2 , (x 0 ,y 0 ) / ∈ α( [0 ,l ] ) , and deﬁne the functions


$$
a ( t ) & = \frac { x ( t ) - x _ { 0 } } { \{ ( x ( t ) - x _ { 0 } ) ^ { 2 } + ( y ( t ) - y _ { 0 } ) ^ { 2 } \} ^ { 1 / 2 } } , \\ b ( t ) & = \frac { y ( t ) - y _ { 0 } } { \{ ( x ( t ) - x _ { 0 } ) ^ { 2 } + ( y ( t ) - y _ { 0 } ) ^ { 2 } \} ^ { 1 / 2 } } .
$$

$$
b ( t ) = \frac { y ( t ) - y _ { 0 } } { \{ ( x ( t ) - x _ { 0 } ) ^ { 2 } + ( y ( t ) - y _ { 0 } ) ^ { 2 } \} ^ { 1 / 2 } } .
$$

a. Use Lemma 1 of Sec. 4-4 to show that the differentiable function

$$
\varphi ( t ) = \varphi _ { 0 } + \int _ { 0 } ^ { t } ( a b ^ { \prime } - b a ^ { \prime } ) \, d t , \quad a ^ { \prime } = \frac { d a } { d t } , b ^ { \prime } = \frac { d b } { d t } , \\ \intertext { i s a d e r m a t i o n of the angle that the r $ x $ i s makes with the position }
$$

[Page 427]

![In the image there are two circles with the same diameter.](<images/imageFile68.png>)

(b)

(a)

(c)

(d)

Figure 5-40

b. Use part a to show that when α is a differentiable closed plane curve, the winding number of α relative to p 0 is given by the integral

$$
w & = \frac { 1 } { 2 \pi } \int _ { 0 } ^ { l } ( a b ^ { \prime } - b a ^ { \prime } ) \, d t . \\ \\ \intertext { w = \frac { 1 } { 2 \pi } \int _ { 0 } ^ { l } ( a b ^ { \prime } - b a ^ { \prime } ) \, d t . } \\
$$

3. Let α : [0 ,l ] → R 2 and β : [0 ,l ] → R 2 be two differentiable plane closed curves, and let p 0 ∈ R 2 be a point such that p 0 / ∈ α( [0 ,l ] ) and p 0 / ∈ β( [0 ,l ] ) . Assume that, for each t ∈ [0 ,l ], the points α(t) and β(t) are closer than the points α(t) and p 0 ; i.e.,

$$
| \alpha ( t ) - \beta ( t ) | < | \alpha ( t ) - p _ { 0 } | .
$$

Use Exercise 2 to prove that the winding number of α relative to p 0 is equal to the winding number of β relative to p 0 .

4. a. Let C be a regular plane closed convex curve. Since C is simple, it determines, by the Jordan curve theorem, an interior region K ⊂ R 2 . Prove that K is a convex set (i.e., given p , q ∈ K , the segment of straight line pq is contained in K ; cf. Exercise 9, Sec. 1-7).

b. Conversely, let C be a regular plane curve (not necessarily closed), and assume that C is the boundary of a convex region. Prove that C is convex.

[Page 428]

5. Let C be a regular plane, closed, convex curve. By Exercise 4, the interior of C is a convex set K . Let p 0 ∈ K , p 0 / ∈ C . a. Show that the line which joins to an arbitrary point is not

Show that the line which joins p 0 to an arbitrary point q ∈ C is not tangent to C at q .

- b. Concludefrompartathattherotationindexof C isequaltothewinding number of C relative to p 0 .
- c. Obtain from part b a simple proof for the fact that the rotation index of a closed convex curve is ± 1. 3


6. Let α : [0 ,l ] → R be a regular closed curve parametrized by arc length. Assume that 0  = | k(s) | ≤ 1 for all s ∈ [0 ,l ]. Prove that l ≥ 2 π and that l = 2 π if and only if α is a plane convex curve. 7. ( Schur’s Theorem for Plane Curves .) Let α : [0 ,l ] R 2 and α : [0 ,l ]

→ ˜ → R 2 be two plane convex curves parametrized by arc length, both with the same length l . Denote by k and ˜ k the curvatures of α and ˜ α , respectively, and by d and ˜ d the lengths of the chords of α and ˜ α , respectively; i.e.,

$$
d ( s ) = | \alpha ( s ) - \alpha ( 0 ) | , \quad \tilde { d } ( s ) = | \tilde { \alpha } ( s ) - \tilde { \alpha } ( 0 ) | .
$$

Assume that k(s) ≥ ˜ k(s) , s ∈ [0 ,l ]. We want to prove that d(s) ≤ ˜ d(s) , s ∈ [0 ,l ] (i.e., if we stretch a curve, its chords become longer) and that equality holds for s ∈ [0 ,l ] if and only if the two curves differ by a rigid motion. We remark that the theorem can be extended to the case where ˜ α is a space curve and has a number of applications, Compare S. S. Chern [10].

The following outline may be helpful.

a. Fix a point s = s 1 . Put both curves α(s) = (x(s),y(s)) , ˜ α(s) = ( ˜ x(s), ˜ y(s)) inthelowerhalf-plane y ≤ 0sothat α( 0 ) , α(s 1 ) , ˜ α( 0 ) , and ˜ α(s 1 ) lie on the x axis and x(s 1 ) > x( 0 ) , ˜ x(s 1 ) > ˜ x( 0 ) (see Fig. 5-41). Let s 0 ∈ [0 ,s 1 ] be such that α ′ (s 0 ) is parallel to the x axis. Choose the function θ(s) which gives a differentiable determination of the angle that the x axis makes with α ′ (s) in such a way that θ(s 0 ) = 0. Show that, by convexity, − π ≤ θ ≤ π . b. Let ˜ θ(s) , ˜ θ(s 0 ) 0, be a differentiable determination of the angle

= that the x axis makes with α ′ (s) . (Notice that ˜ α ′ (s 0 ) may no longer be parallel to the x axis.) Prove that ˜ θ(s) ≤ θ(s) and use part a to conclude that

$$
d(s 1 ) = ∫ s 1 0 cos θ(s) ds ≤ ∫ s 1 0 cos ˜ θ(s) ds ≤ ˜ d(s 1 ).
$$

For the equality case, just trace back your steps and apply the uniqueness theorem for plane curves.

[Page 429]

y

![The image consists of a diagram with two lines and two points labeled as \( x \) and \( y \). The diagram is labeled as follows: - **Line \( x \)**: This line is a straight line with a positive slope. - **Point \( x \)**: This point is located at the top of the diagram. - **Point \( y \)**: This point is located at the bottom of the diagram. The diagram is labeled as follows: - **Line \( x \)**: This line is a straight line with a positive slope. - **Point \( x \)**: This point is located at the top of the diagram. - **Point \( y \)**: This point is located at the bottom of the diagram. The diagram is labeled as follows: - **Line \( x \)**: This line is a straight line with a positive slope.](<images/imageFile69.png>)

~

(

(

)

)

x

s

x

s

(0)

(0)

0

x

x

x

1

1

ө

ө

(

)

α

s

0

)

(

α

s

0

Figure 5-41

8. ( Stoker’s Theorem for Plane Curves .) Let α : R → R 2 be a regular plane curve parametrized by arc length. Assume that α satisﬁes the following conditions:

- 1. The curvature of α is strictly positive.
- 2. lim s → ± ∞ | α(s) | = ∞ ; that is, the curve extends to inﬁnity in both directions.
- 3. α has no self-intersections.


The goal of the exercise is to prove that the total curvature of α is ≤ π . The following indications may be helpful.Assume that the total curvature is > π and that α has no self-intersections. To obtain a contradiction, proceed as follows:

- a. Prove that there exist points, say, p = α( 0 ) , q = α(s 1 ) , s 1 > 0, such that the tangent lines T p , T q at the points p and q , respectively, are parallel and there exists no tangent line parallel to T p in the arc α( [0 ,s 1 ] ) .
- b. Show that as s increases, α(s) meets T p at a point, say, r (Fig. 5-42).


The arc α(( -∞ , 0 )) must meet Tp at a point t between p and r .

joining r to t , thus obtaining a closed curve C . Show that the rotation index of C is ≥ 2. Show that this implies that α has self-intersections, a contradiction.

*9. Let α : [0 ,l ] → S 2 be a regular closed curve on a sphere S 2 = { (x,y,z) ∈ R 3 ; x 2 + y 2 + z 2 = 1 } . Assume that α is parametrized by arc length and that the curvature k(s) is nowhere zero. Prove that

$$
∫ l 0 τ(s) ds = 0 .
$$

[Page 430]

![In this image, we can see a diagram with a circle and a line. There are two points named P and Q. We can see a line labeled as t. We can see a point named B. We can see a line labeled as T. We can see a line labeled as B. We can see a point named A. We can see a line labeled as T. We can see a point named C. We can see a line labeled as B. We can see a line labeled as T. We can see a point named D. We can see a line labeled as B. We can see a line labeled as T. We can see a point named C. We can see a line labeled as B. We can see a line labeled as T. We can see a point named D. We can see a line labeled as B. We can see a line labeled as T. We can see a point named A. We can see a line labeled as T. We can](<images/imageFile70.png>)

T

p

r

β

t

T

q

=

(0)

p

α

)

=

(s

q

α

1

Figure 5-42

# 5-8. Surfaces of Zero Gaussian Curvature

We have already seen (Sec. 4-6) that the regular surfaces with identically zero Gaussian curvature are locally isometric to the plane. ln this section, we shall look upon such surfaces from the point of view of their position in R 3 and prove the following global theorem.

THEOREM. Let S ⊂ R 3 be a complete surface with zero Gaussian curvature. Then S is a cylinder or a plane.

By deﬁnition, a cylinder is a regular surface S such that through each point p ∈ S there passes a unique line R(p) ⊂ S (the generator through p ) which satisﬁes the condition that if q  = p , then the lines R(p) and R(q) are parallel or equal.

It is a strange fact in the history of differential geometry that such a theorem was proved only somewhat late in its development. The ﬁrst proof came as a corollary of a theorem of P. Hartman and L. Nirenberg (“On Spherical Images Whose Jacobians Do Not Change Signs,” Amer. J. Math. 81 (1959), 901–920) dealing with a situation much more general than ours. Later, W. S. Massey (“Surfaces of Gaussian Curvature Zero in Euclidean Space,” Tohoku Math. J. 14 (1962), 73–79) and J. J. Stoker (“Developable Surfaces in the Large,” Comm. Pure and Appl. Math . 14 (1961), 627–635) obtained elementary and direct proofs of the theorem. The proof we present here is a modiﬁcation of

[Page 431]

(Added in 2016) Professor I. Sabitov informed me that this result was obtained by A.V. Pogorelov in 1956. It appeared under the title Extensions of the theorem of Gauss on spherical representation, in Dokl. Akad. Nauk. S.S.S.R. (N.S.) 111 (1956), 945–947. MR0087147.

We shall start with the study of some local properties of a surface of zero curvature. 3

Let S ⊂ R be a regular surface with Gaussian curvature K ≡ 0. Since K = k 1 k 2 , where k 1 and k 2 are the principal curvatures, the points of S are either parabolic or planar points. We denote by P the set of planar points and by U = S − P the set of parabolic points of S . P is closed in S . In fact, the points of P satisfy the condition that the

P is closed in S . In fact, the points of P satisfy the condition that the mean curvature H = 1 2 (k 1 + k 2 ) is zero. A point of accumulation of P has, by continuity of H , zero mean curvature; hence, it belongs to P . It follows that U = S -P is open in S .

An instructive example of the relations between the sets P and U is given in the following example.

Example 1. Consider the open triangle ABC and add to each side a cylindrical surface, with generators parallel to the given side (see Fig. 5-43). It is possible to make this construction in such a way that the resulting surface is a regular surface. For instance, to ensure regularity along the open segment BC , it sufﬁces that the section FG of the cylindrical band BCDE by a plane normal to BC is a curve of the form

$$
exp ( -1 x 2 ) .
$$

Observe that the vertices A , B , C of the triangle and the edges BE , CD , etc., of the cylindrical bands do not belong to S .

![In this image, we can see a diagram of a triangle. There are lines, points and a point labeled as E.](<images/imageFile71.png>)

E

G

D

B

F

A

C

Figure 5-43

[Page 432]

The surface S so constructed has curvature K ≡ 0. The set P is formed by the closed triangle ABC minus the vertices. Observe that P is closed in S but not in R 3 . The set U is formed by the points which are interior to the cylindrical bands. Through each point of U there passes a unique line which will never meet P . The boundary of P is formed by the open segments AB , BC , and CA .

In the following, we shall prove that the relevant properties of this example appear in the general case.

First, let p ∈ U . Since p is a parabolic point, one of the principal directions at p is an asymptotic direction, and there is no other asymptotic direction at p . We shall prove that the unique asymptotic curve that passes through p is a segment of a line.

PROPOSITION 1. The unique asymptotic line that passes through a paraholic point p ∈ U ⊂ S of a surface S of curvature K ≡ 0 is an (open) segment of a (straight) line in S .

Proof . Since p is not umbilical, it is possible to parametrize a neighborhood V ⊂ U of p by x (u,v) = x in such a way that the coordinate curves are lines of curvature. Suppose that v = const. is an asymptotic curve; that is, it has zero normal curvature. Then, by the theorem of Olinde Rodrigues (Sec. 3-2, Prop. 3), N u = 0 along v = const. Since through each point of the neighborhood V there passes a curve v = const., the relation N u = 0 holds for every point of V .

It follows that in V

$$
〈 x , N 〉 u = 〈 x u, N 〉 + 〈 x , Nu 〉 = 0 .
$$

Therefore, Remark. It is essential that K ≡ 0 in the above proposition. For instance, the upper parallel of a torus of revolution is an asymptotic curve formed by parabolic points and it is not a segment of a line.

$$
〈 x , N 〉 = ϕ(v), (1)
$$

where ϕ(v) is a differentiable function of v alone. By differentiating Eq. (1) with respect to v , we obtain

$$
〈 x , Nv 〉 = ϕ ′ (v). (2)
$$

On the other hand, N v is normal to N and different from zero, since the points of V are parabolic. Therefore, N and N v are linearly independent. Furthermore, N vu = N uv = 0 in V . We now observe that along the curve v = const . = v 0 the vector N(u) =

N 0 and N v (u) = (N v ) 0 = const . Thus, Eq. (1) implies that the curve x (u,v 0 ) belongs to a plane normal to the constant vector N 0 , and Eq. (2) implies that this curve belongs to a plane normal to the constant vector (N v ) 0 . Therefore, the curve is contained in the intersection of two planes (the intersection exists since N 0 and (N v ) 0 are linearly independent); hence, it is a segment of a line.

[Page 433]

Wearenowgoingtoseewhathappenswhenweextendthissegmentofline. The following proposition shows that (cf. Example 1) the extended line never meets the set P ; either it “ends” at a boundary point of S or stays indeﬁnitely in U .

It is convenient to use the following terminology. An asymptotic curve passing through a point p ∈ S is said to be maximal if it is not a proper subset of some asymptotic curve passing through p .

PROPOSITION 2 (Massey, loc. cit. ). Let r beamaximalasymptoticline passingthroughaparabolicpoint p ∈ U ⊂ S ofasurface S ofcurvature K ≡ 0 and let P ⊂ S be the set of planar points of S . Then r ∩ P = φ .

The proof of Prop. 2 depends on the following local lemma, for which we use the Mainardi-Codazzi equations (cf. Sec. 4-3).

LEMMA 1. Let s bethearclengthoftheasymptoticcurvepassingthrough a parabolic point p of a surface S of zero curvature and let H = H ( s ) be the mean curvature of S along this curve. Then, in U ,

$$
d 2 ds 2 ( 1 H ) = 0 .
$$

Proof of Lemma 1 . We introduce in a neighborhood V ⊂ U of p a system of coordinates (u,v) such that the coordinate curves are lines of curvature and the curves v = const . are the asymptotic curves of V . Let e , f , and g be the coefﬁcients of the second fundamental form in this parametrization. Since f = 0 and the curve v = const . , u = u(s) must satisfy the differential equation of the asymptotic curves

$$
e ( du ds ) 2 + 2 f du ds dv ds + g ( dv ds ) 2 = 0 ,
$$

we conclude that e = 0. Under these conditions, the mean curvature H is given by

$$
H = k 1 + k 2 2 = 1 2 ( e E + g G ) = 1 2 g G . (3)
$$

By introducing the values F = f = e = 0 in the Mainardi-Codazzi equations (Sec. 4-3, Eq. (7) and (7a)), we obtain

$$
0 = 1 2 gE v G , gu = 1 2 gGu G . (4)
$$

[Page 434]

From the ﬁrst equation of (4) it follows that E v = 0. Thus, E = E(u) is a function of u alone. Therefore, it is possible to make a change of parameters:

$$
¯ v = v, ¯ u = ∫ √ E(u) du .
$$

We shall still denote the new parameters by u and v . u now measures the arc length along v = const . , and thus E = 1. Inthenewparametrization (F = 0 ,E = 1 ) theexpressionfortheGaussian

In the new parametrization (F = 0 , E = 1 ) the expression for the Gaussian curvature is

$$
K = -1 √ G ( √ G)uu = 0 .
$$

Therefore,

$$
√ G = c 1 (v)u + c 2 (v), (5)
$$

where c 1 (v) and c 2 (v) are functions of v alone.

On the other hand, the second equation of (4) may be written (g  = 0 )

$$
gu g = 1 2 Gu √ G √ G = ( √ G)u √ G ;
$$

hence,

$$
g = c 3 (v) √ G, (6)
$$

where c 3 (v) is a function of v . By introducing Eqs. (5) and (6) into Eq. (3) we obtain

$$
H = 1 2 c 3 (v) √ G √ G √ G = 1 2 c 3 (v) c 1 (v)u + c 2 (v) .
$$

Finally, by recalling that u = s and differentiating the above expression with respect to s , we conclude that

$$
d 2 ds 2 ( 1 H ) = 0 , Q.E.D.
$$

Proof of Prop. 2 . Assume that the maximal asymptotic line r passing through p and parametrized by arc length s contains a point q ∈ P . Since r is connected and U is open, there exists a point p 0 of r , corresponding to s 0 , such that p 0 ∈ P and the points of r with s < s 0 belong to U .

[Page 435]

On the other hand, from Lemma 1, we conclude that along r and for s < s 0 ,

$$
H(s) = 1 as + b ,
$$

where a and b are constants. Since the points of P have zero mean curvature, we obtain 1

$$
H(p 0 ) = 0 = lim s → s 0 H(s) = lim s → s 0 1 as + b ,
$$

which is a contradiction and concludes the proof. Q.E.D.

Let now Bd (U) be the boundary of U in S ; that is, Bd (U) is the set of points p ∈ S such that every neighborhood of p in S contains points of U and points of S − U = P . Since U is open in S , it follows that Bd (U) ⊂ P . Furthermore, since the deﬁnition of a boundary point is symmetric in U and P , we have that

$$
Bd (U) = Bd (P).
$$

The following proposition shows that (just as in Example 1) the set Bd (U) = Bd (P) is formed by segments of straight lines.

PROPOSITION 3 (Massey). Let p ∈ Bd( U ) ⊂ S be a point of the boundary of the set U of parabolic points of a surface S of curvature K ≡ 0 . Then through p there passes a unique open segment of line C ( p ) ⊂ S . Furthermore, C ( p ) ⊂ Bd( U ) ; that is, the boundary of U is formed by segments of lines.

Proof . Let p ∈ Bd (U) . Since p is a limit point of U , it is possible to choose a sequence { p n } , p n ∈ U , with lim n →∞ p n = p . For every p n , let C(p n ) be the unique maximal asymptotic curve (open segment of a line) that passes through p n (cf. Prop. 1). We shall prove that, as n → ∞ , the directions of C(p n ) converge to a certain direction that does not depend on the choice of the sequence { p n } . In fact, let   ⊂ R 3 be a sufﬁciently small sphere around p . Since the

sphere   is compact, the points { q n } of intersection of C(p n ) with   have at least one point of accumulation q ∈   , which occurs simultaneously with its antipodal point. If there were another point of accumulation r besides q and its antipodal point, then through arbitrarily near points p n and p m there should pass asymptotic lines C(p n ) and C(p m ) making an angle greater than

$$
\theta = \frac { 1 } { 2 } \text {ang} ( p q , p r ) ,
$$

thus contradicting the continuity of asymptotic lines. It follows that the lines C(p n ) have a limiting direction. An analogous argument shows that this limiting direction does not depend on the chosen sequence { p n } with lim n →∞ p n = p , as previously asserted.

[Page 436]

Since the directions of C(p n ) converge and p n → p , the open segments of lines C(p n ) converge to a segment C(p) ⊂ S that passes through p . The segment C(p) does not reduce itself to the point p . Otherwise, since C(p n ) is maximal, p ∈ S would be a point of accumulation of the extremities of C(p n ) , which do not belong to S (cf. Prop. 2). By the same reasoning, the segment C(p) does not contain its extreme points.

Finally, we shall prove that C(p) ⊂ Bd (U) . In fact, if q ∈ C(p) , there exists a sequence

$$
\{ q _ { n } \} , q _ { n } \in C ( p _ { n } ) \subset U , \quad \text {with } \lim _ { n \to \infty } q _ { n } = q .
$$

Then q ∈ U ∪ Bd (U) .Assume that q / ∈ Bd (U) . Then q ∈ U , and, by the continuity of the asymptotic directions, C(p) is the unique asymptotic line that passes through q . This implies, by Prop. 2, that p ∈ U , which is a contradiction. Therefore, q ∈ Bd (U) , that is, C(p) ⊂ Bd (U) , and this concludes the proof. Q.E.D.

We are now in a position to prove the global result stated in the beginning of this section.

Proof of the Theorem .Assumethat S isnotaplane.Then(Sec. 3-2, Prop.4) S contains parabolic points. Let U be the (open) set of parabolic points of S and P be the (closed) set of planar points of S . We shall denote by int P , the interior of P , the set of points which have a neighborhood entirely contained in P . int P is an open set in S which contains only planar points. Therefore, each connected component of int P is contained in a plane (Sec. 3-2, Prop. 4).

We shall ﬁrst prove that if q ∈ S and q / ∈ int P , then through q there passes a unique line R(q) ⊂ S , and two such lines are either equal or do not intersect. In fact, when q ∈ U , then there exists a unique maximal asymptotic line r

passing through q . r is a segment of line (thus, a geodesic) and r ∩ P = φ (cf. Props. 1 and 2). By parametrizing r by arc length we see that r is not a ﬁnite segment. Otherwise, there exists a geodesic which cannot be extended to all values of the parameter, which contradicts the completeness of S . Therefore, r is an entire line R(q) , and since r ∩ P = φ , we conclude that R(q) ⊂ U . It follows that when p is another point of U , p / ∈ R(q) , then R(p) ∩ R(q) = φ . Otherwise, through the intersection point there should pass two asymptotic lines, which contradicts the asserted uniqueness.

On the other hand, if q ∈ Bd (U) = Bd (P) , then (cf. Prop. 3) through q there passes a unique open segment of line which is contained in Bd( U ). By the previous argument, this segment may be extended into an entire line R(q) ⊂ Bd (U) , and if p ∈ Bd (U) , p / ∈ R(q) , then R(p) ∩ R(q) = φ . Clearly, since U is open, if q ∈ U and p ∈ Bd (U) , then R(p) ∩ R(q) = φ .

Clearly, since U is open, if q ∈ U and p ∈ Bd (U) , then R(p) ∩ R(q) = φ . In this way, through each point of S -int P = U ∪ Bd (U) there passes a unique line contained in S -int P , and two such lines are either equal or do not intersect, as we claimed. We now claim that these lines are parallel to a fixed direction and we shall conclude that Bd (U)( = Bd (P)) is formed by parallel lines and that each connected component of int P is an open set of a plane, bounded by two parallel lines. Thus, through each point r ⊂ int P there passes a unique line R(t) ⊂ int P parallel to the common direction. It follows that through each point of S there passes a unique generator and that the generators are parallel, that is, S is a cylinder, as we wish.

[Page 437]

Toprovethatthelinespassingthroughthepointsof U ∪ Bd (U) areparallel, we shall proceed in the following way. Let q ∈ U ∪ Bd (U) and p ∈ U . Since S is connected, there exists an arc α : [0 ,l ] → S , with α( 0 ) = p , α(l) = q . The map exp p : T p (S) → S is a covering map (Prop. 7, Sec. 5-6) and a local isometry (corollary of Lemma 1, Sec. 5-6). Let ˜ α : [0 ,l ] → T p (S) be the lifting of α , with origin at the origin 0 ∈ T p (S) . For each ˜ α(t) , with exp p ˜ α(t) = α(t) ∈ U ∪ Bd (U) , let r t be the lifting of R(α(t)) with origin at ˜ α(t) . Since exp p is a local isometry, r t is a line in T p (S) . Furthermore, when , [0 ], the lines and are

α(t 1 )  = α(t 2 ) t 1 ,t 2 ∈ ,l r t 1 r t 2 parallel. In fact, if v ∈ r t 1 ∩ r t 2 , then

$$
\exp _ { p } ( v ) \in R ( \alpha ( t _ { 1 } ) ) \cap R ( \alpha ( t _ { 2 } ) ) , \\
$$

which is a contradiction. This proves our claim, and the theorem. Q.E.D.

# 5-9. Jacobi’s Theorems

It is a fundamental property of a geodesic γ (Sec. 4-6, Prop. 4) that when two points p and q of γ are sufﬁciently close, then γ minimizes the arc length between p and q . This means that the arc length of γ between p and q is smaller than or equal to the arc length of any curve joining p to q . Suppose now that we follow a geodesic γ starting from a point p . It is then natural to ask how far the geodesic γ minimizes arc length. In the case of a sphere, for instance, ageodesic γ (ameridian)startingfromapoint p minimizesarclength up to the ﬁrst conjugate point of p relative to γ (that is, up to the antipodal point of p ). Past the antipodal point of p , the geodesic stops being minimal, as we may intuitively see by the following considerations.

A geodesic joining two points p and q of a sphere may be thought of as a thread stretched over the sphere and joining the two given points. When the arc ⌢ pq is smaller than a semimeridian and the points p and q are kept ﬁxed, it is not possible to move the thread without increasing its length. On the other hand, when the arc ⌢ pq is greater than a semimeridian, a small displacement of the thread (with p and q ﬁxed) “loosens” the thread (see Fig. 5-44). In other words, when q is farther away than the antipodal point of p , it is possible to obtain curves joining p to q that are close to the geodesic arc ⌢ pq and are shorter than this arc. Clearly, this is far from being a mathematical argument.

In this section we shall begin the study of this question and prove a result, due to Jacobi, which may be roughly described as follows. A geodesic γ

[Page 438]

![In the image, we can see a diagram of a circle. Inside the circle, we can see a line labeled as p. There are some points marked on the circumference of the circle.](<images/imageFile72.png>)

p

q

q´

p´

Figure 5-44

starting from a point p minimizes arc length, relative to “neighboring” curves of γ , only up to the “ﬁrst” conjugate point of p relative to γ (more precise statements will be given later; see Theorems 1 and 2).

For simplicity, the surfaces in this section are assumed to be complete and the geodesics are parametrized by arc length.

We need some preliminary results.

The following lemma shows that the image by exp p : T p (S) → S of a segment of line of T p (S) with origin at O ∈ T p (S) (geodesic starting from p ) is minimal relative to the images by exp p of curves of T p (S) which join the extremities of this segment.

More precisely, let

$$
p \in S , \ u \in T _ { p } ( S ) , \ l = | u | \neq 0 ,
$$

and let ˜ γ : [0 ,l ] → T p (S) be the line of T p (S) given by

$$
\tilde { \gamma } ( s ) = s v , \ \ s \in [ 0 , l ] , \ \ v = \frac { u } { | u | } . \\ T \left ( S \right ) h _ { s } = d i f f _ { s } w i t i { h } _ { 1 } = \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \dots \
$$

Let ˜ α : [0 ,l ] → T p (S) be a differentiable parametrized curve of T p (S) , with ˜ α( 0 ) = 0, ˜ α(l) = u , and ˜ α(s)  = 0 if s  = 0. Furthermore, let (Fig. 5-45)

$$
\alpha ( s ) = \exp _ { p } \tilde { \alpha } ( s ) \ \text {and} \ \gamma ( s ) = \exp _ { p } \tilde { \gamma } ( s ) .
$$

LEMMA 1. With the above notation, we have

1. l(α) ≥ l(γ) , where l( ) denotes the arc length of the corresponding curve.

In addition, if ˜ α( s ) is not a critical point of exp p , s ∈ [0 ,l) ] , and if the traces of α and γ are distinct, then

2. l(α) > l(γ) .

[Page 439]

r

![The image depicts a geometric figure involving a right triangle and a right-angled triangle. The diagram is a right-angled triangle with the right angle at the vertex labeled as \( \theta \). The right angle is at the top of the triangle, and the right angle is at the bottom of the triangle. The triangle is a right-angled triangle with the right angle at the vertex. The right angle is at the top of the triangle, and the right angle is at the bottom of the triangle. The right angle is at the top of the triangle, and the right angle is at the bottom of the triangle. The diagram includes two lines, labeled \( \alpha \) and \( \beta \), which are perpendicular to the sides of the triangle. The line \( \alpha \) is drawn from the top left vertex of the triangle to the bottom right vertex of the triangle. The line \( \beta \) is drawn from the bottom left vertex of](<images/imageFile73.png>)

n

(

)

T

S

u

(s)

P

α

γ

v

0

α

S

exp p

p

γ

p

Figure 5-45

Proof . Let ˜ α(s)/ |˜ α(s) | = r , and let n be a unit vector of T p (S) , with   r,n   = 0. In the basis { r,n } of T p (S) we can write (Fig. 5-45)

$$
\tilde { \alpha } ^ { \prime } ( s ) = a r + b n ,
$$

where

By deﬁnition

$$
a & = \langle \tilde { \alpha } ^ { \prime } ( s ) , r \rangle , \\ b & = \langle \tilde { \alpha } ^ { \prime } ( s ) , n \rangle .
$$

$$
b = \langle \tilde { \alpha } ^ { \prime } ( s ) , n \rangle .
$$

$$
\alpha ^ { \prime } ( s ) & = ( d \exp _ { p } ) _ { \tilde { \alpha } ( s ) } ( \tilde { \alpha } ^ { \prime } ( s ) ) \\ & = a ( d \exp _ { p } ) _ { \tilde { \alpha } ( s ) } ( r ) + b ( d \exp _ { p } ) _ { \tilde { \alpha } ( s ) } ( n ) .
$$

Therefore, by using the Gauss lemma (cf. Sec. 5-5, Lemma 2) we obtain

where

It follows that

On the other hand,

$$
\langle \alpha ^ { \prime } ( s ) , \alpha ^ { \prime } ( s ) \rangle = a ^ { 2 } + c ^ { 2 } ,
$$

$$
c ^ { 2 } = b ^ { 2 } | ( d \exp _ { p } ) _ { \tilde { \alpha } ( s ) } ( n ) | ^ { 2 } .
$$

$$
\langle \alpha ^ { \prime } ( s ) , \alpha ^ { \prime } ( s ) \rangle \geq a ^ { 2 } .
$$

$$
\frac { d } { d s } \langle \tilde { \alpha } ( s ) , \tilde { \alpha } ( s ) \rangle ^ { 1 / 2 } = \frac { \langle \tilde { \alpha } ^ { \prime } ( s ) , \tilde { \alpha } ( s ) \rangle } { \langle \tilde { \alpha } ( s ) , \tilde { \alpha } ( s ) \rangle ^ { 1 / 2 } } = \langle \tilde { \alpha } ^ { \prime } ( s ) , r \rangle = a .
$$

[Page 440]

Therefore,

$$
l ( \alpha ) & = \int _ { 0 } ^ { l } \langle \alpha ^ { \prime } ( s ) , \alpha ^ { \prime } ( s ) \rangle ^ { 1 / 2 } \, d s \geq \int _ { 0 } ^ { l } a \, d s \\ & = \int _ { 0 } ^ { l } \frac { d } { d s } \langle \tilde { \alpha } ( s ) , \tilde { \alpha } ( s ) \rangle ^ { 1 / 2 } \, d s = | \tilde { \alpha } ( l ) | = l = l ( \gamma ) , \\ \intertext { d i s p o r e s } \, \text {with} \, \colon \, \text {part} \, 1 ,
$$

and this proves part 1.

To prove part 2, let us assume that l(α) = l(γ) . Then

$$
\int _ { 0 } ^ { l } \langle \alpha ^ { \prime } ( s ) , \alpha ^ { \prime } ( s ) \rangle ^ { 1 / 2 } \, d s = \int _ { 0 } ^ { l } a \, d s ,
$$

and since Since exp p is regular at the points of the line ˜ γ of Tp(S) , for each s ∈ [0 , l ] there exists a neighborhood Us of ˜ γ(s) such that exp p restricted to Us is a diffeomorphism. The family { Us } , s ∈ [0 , l ], covers ˜ γ( [0 , l ] ) , and, by compactness, it is possible to obtain a finite subfamily, say, U 1 , . . . , U n which still covers ˜ γ( [0 , l ] ) . It follows that we may divide the interval [0 , l ] by points

$$
\langle \alpha ^ { \prime } ( s ) , \alpha ^ { \prime } ( s ) \rangle ^ { 1 / 2 } \geq a ,
$$

the equality must hold in the last expression for every s ∈ [0 ,l ]. Therefore,

$$
c = | b | | ( d \exp _ { p } ) _ { \tilde { \alpha } ( s ) } ( n ) | = 0 .
$$

Since ˜ α(s) is not a critical point of exp p , we conclude that b ≡ 0. It follows that the tangent lines to the curve ˜ α all pass through the origin O of T p (s) . Thus, ˜ α is a line of T p (S) which passes through O . Since ˜ α(l) = ˜ γ(l) , the lines ˜ α and ˜ γ coincide, thus contradicting the assumption that the traces of α and γ are distinct. From this contradiction it follows that l(α) > l(γ) , which proves part 2 and ends the proof of the lemma. Q.E.D.

Wearenowinapositiontoprovethatifageodesicarccontainsnoconjugate points, it yields a local minimum for the arc length. More precisely, we have

THEOREM 1 (Jacobi). Let γ :[0 ,l ] → S , γ( 0 ) = p , beageodesicwithout conjugate points; that is, exp p : T p ( S ) → S is regular at the points of the line ˜ γ( s ) = s γ ′ ( 0 ) of T p ( S ) , s ∈ [0 ,l ] . Let h: [0 ,l ] × ( − ǫ,ǫ) → S be a proper variation of γ . Then

1. There exists a δ > 0 , δ ≤ ǫ , such that if t ∈ ( − δ,δ) ,

$$
L ( t ) \geq L ( 0 ) ,
$$

where L ( t ) is the length of the curve h t : [0 ,l ] → S that is given by h t ( s ) = h ( s , t ) . If, in addition, the trace of h t , is distinct from the trace of γ , L ( t ) > L ( 0 ) .

If, in addition, the trace of ht , is distinct from the trace of γ , L ( t ) > L ( 0 ) .

Proof . The proof consists essentially of showing that it is possible, for every t ∈ ( − δ,δ) , to lift the curve h t into a curve ˜ h t of T p (S) such that ˜ h t ( 0 ) = 0, ˜ h t (l) = ˜ γ(l) and then to apply Lemma 1.

[Page 441]

$$
0 = s _ { 1 } < s _ { 2 } < \cdots < s _ { n } < s _ { n + 1 } = l
$$

in such a way that ˜ γ( [ s i ,s i + 1 ] ) ⊂ U i , i = 1 ,...,n . Since h is continuous and [ s i ,s i + 1 ] is compact, there exists δ i > 0 such that

+ 1

$$
h ( [ s _ { i } , s _ { k + 1 } ] \times ( - \delta _ { i } , \delta _ { i } ) ) \subset \exp _ { p } ( U _ { i } ) = V _ { i } . \\
$$

Let δ = min (δ 1 ,...,δ n ) . For t ∈ ( − δ,δ) , the curve h t : [0 ,l ] → S may be lifted into a curve ˜ h t : [0 ,l ] → T p (S) , with origin ˜ h t ( 0 ) = 0, in the following way. Let s ∈ [ s 1 ,s 2 ]. Then 1

$$
\tilde { h } _ { t } ( s ) = \exp _ { p } ^ { - 1 } ( h _ { t } ( s ) ) ,
$$

where exp − 1 p is the inverse map of exp p : U 1 → V 1 . By applying the same technique we used for covering spaces (cf. Prop. 2, Sec. 5-6), we can extend ˜ h t for all s ∈ [0 ,l ] and obtain ˜ h t (l) = ˜ γ(l) . In this way, we conclude that γ(s) = exp p ˜ γ(s) and that h t (s) =

exp p ˜ h t (s) , t ∈ ( − δ,δ) , with ˜ h t ( 0 ) = 0, ˜ h t (l) = ˜ γ(l) . We then apply Lemma 1 to this situation and obtain the desired conclusions. Q.E.D.

Remark 1. A geodesic γ containing no conjugate points may well not be minimal relative to the curves which are not in a neighborhood of γ . Such a situation occurs, for instance, in the cylinder (which has no conjugate points), as the reader will easily verify by observing a closed geodesic of the cylinder.

Thissituationisrelatedtothefactthatconjugatepointsinformusonlyabout the differential of the exponential map, that is, about the rate of “spreading out” of the geodesics neighboring a given geodesic. On the other hand, the global behavior of the geodesics is controlled by the exponential map itself, which may not be globally one-to-one even when its differential is nonsingular everywhere.

Another example (this time simply connected) where the same fact occurs is in the ellipsoid, as the reader may verify by observing the ﬁgure of the ellipsoid in Sec. 5-5 (Fig. 5-19).

The study of the locus of the points for which the geodesics starting from p stop globally minimizing the arc length (called the cut locus of p ) is of fundamental importance for certain global theorems of differential geometry, but it will not be considered in this book.

We shall proceed now to prove that a geodesic γ containing conjugate points is not a local minimum for the arc length; that is, “arbitrarily near” to γ

[Page 442]

there exists a curve, joining its extreme points, the length of which is smaller than that of γ .

We shall need some preliminaries, the ﬁrst of which is an extension of the deﬁnition of variation of a geodesic to the case where piecewise differentiable functions are admitted.

DEFINITION 1. Let γ : [0 ,l ] → S be a geodesic of S and let

$$
h \colon [ 0 , l ] \times ( - \epsilon , \epsilon ) \to S \\
$$

be a continuous map with

$$
h ( s , 0 ) & = \gamma ( s ) , \ \ s \in [ 0 , l ] . \\
$$

h is said to be a broken variation of γ if there exists a partition

of [0 ,l ] such that

$$
0 = s _ { 0 } < s _ { 1 } < s _ { 2 } < \cdots < s _ { n - 1 } < s _ { n } = l \\
$$

$$
h \colon [ s _ { i } , s _ { i + 1 } ] \times ( - \epsilon , \epsilon ) & \to S , \quad i = 0 , 1 , \dots , n - 1 , \\
$$

is differentiable. The broken variation is said to be proper if h ( 0 , t ) = γ( 0 ) , h (l, t ) = γ(l) for every t ∈ ( − ǫ,ǫ) .

The curves h t (s) , s ∈ [0 ,l ], of the variation are now piecewise differentiable curves. The variational vector ﬁeld V (s) = (∂h/∂t)(s, 0 ) is a piecewise differentiable vector ﬁeld along γ ; that is, V : [0 ,l ] → R 3 is a continuous map, differentiable in each [ t i ,t i + 1 ]. The broken variation h is said to be orthogonal if   V (s),γ ′ (s)   = 0, s ∈ [0 ,l ]. In a way entirely analogous to that of Prop. 1 of Sec. 5-4, it is possible

to prove that a piecewise differentiable vector ﬁeld V along γ gives rise to a broken variation of γ , the variational ﬁeld of which is V . Furthermore, if

$$
V ( 0 ) = V ( l ) = 0 , \\
$$

the variation can be chosen to be proper.

Similarly, the function L : ( − ǫ,ǫ) → R (the arc length of a curve of the variation) is deﬁned by

$$
L ( t ) & = \sum _ { 0 } ^ { n - 1 } \int _ { s _ { i } } ^ { s _ { i + 1 } } \left | \frac { \partial h } { \partial s } ( s , t ) \right | d s \\ & = \int _ { 0 } ^ { l } \left | \frac { \partial h } { \partial s } ( s , t ) \right | d s . \\ \text {Sec. 5-4, each summand of this sum is 0} \, . \\ \text {Note: Therefore, } L \text { is differentiable in } ( - \delta , \delta )
$$

=   0   ∂s   By Lemma 1 of Sec. 5-4, each summand of this sum is differentiable in a neighborhood of 0. Therefore, L is differentiable in ( − δ,δ) if δ is sufﬁciently small.

[Page 443]

The expression of the second variation of the arc length (L ′′ ( 0 )) , for proper and orthogonal broken variations, is exactly the same as that obtained in Prop. 4 of Section 5-4, as may easily be veriﬁed. Thus, if V is a piecewise differentiable vector ﬁeld along a geodesic γ : [0 ,l ] → S such that

$$
\langle V ( s ) , \gamma ^ { \prime } ( s ) \rangle = 0 , \ \ S \in [ 0 , l ] , \ \ \text {and} \ \ V ( 0 ) = V ( l ) = 0 , \\
$$

we have

$$
L _ { V } ^ { ^ { \prime \prime } } ( 0 ) = \int _ { 0 } ^ { l } \left ( \left \langle \frac { D V } { d s } , \frac { D V } { d s } \right \rangle - K ( s ) \langle V ( s ) , V ( s ) \rangle \right ) d s . \\ \intertext { L e w l t w } N e w l t w \, \int _ { 0 } ^ { 0 } \, U _ { 1 } \, + \, S \, h e s \, a n d \, e x i n g e d s \, e n d \, l e t \, u s \, d a n t o \, b y \, \{ \, \{ \, \text {the} \, s e t \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \, \rangle \
$$

Now let γ : [0 ,l ] → S be a geodesic and let us denote by U the set of piecewise differentiable vector ﬁelds along γ which are orthogonal to γ ; that is, if V ∈ U , then   V (s),γ ′ (s)   = 0 for all s ∈ [0 ,l ]. Observe that U , with the natural operations of addition and multiplication by a real number, forms a vector space. Deﬁne a map I : U × U → R by l

$$
I ( V , W ) = \int _ { 0 } ^ { l } \left ( \left \langle \frac { D V } { d s } , \frac { D W } { d s } \right \rangle - K ( s ) \langle V ( s ) , W ( s ) \rangle \right ) d s , \\
$$

where V , W ∈ U . It is immediate

to verify that I is a symmetric bilinear map; that is, I is linear in each variable and I(V,W) = I(W,V ) . Therefore, I determines a quadratic form in U , given by I(V,V ) . This quadratic form is called the index form of γ .

Remark 2. The index form of a geodesic was introduced by M. Morse, who proved the following result. Let γ(s 0 ) be a conjugate point of γ( 0 ) = p , relative to the geodesic γ : [0 ,l ] → S , s 0 ∈ [0 ,l ]. The multiplicity of the conjugate point γ(s 0 ) is the dimension of the largest subspace E of T p (S) such that (d exp p ) γ(s 0 ) (u) = 0 for every u ∈ E . The index of a quadratic form Q : E → R in a vector space E is the maximum dimension of a subspace L of E such that Q(u) < 0, u ∈ L . With this terminology, the Morse index theorem is stated as follows: Let γ : [0 ,l ] → S be a geodesic. Then the index of the quadratic form I of γ is ﬁnite, and it is equal to the number of conjugate points to γ( 0 ) in γ(( 0 ,l ] ) , each one counted with its multiplicity . A proof of this theorem may be found in J. Milnor, Morse Theory, Annals of Mathematics Studies, Vol. 51, Princeton University Press, Princeton, N. J., 1963.

For our purposes we need only the following lemma.

LEMMA 2. Let V ∈ U be a Jacobi ﬁeld along a geodesic γ : [0 ,l ] → S and W ∈ U . Then DV DV

$$
I ( V , W ) = \left \langle \frac { D V } { d s } ( l ) , W ( l ) \right \rangle - \left \langle \frac { D V } { d s } ( 0 ) , W ( 0 ) \right \rangle .
$$

[Page 444]

Proof . By observing that

$$
\frac { d } { d s } \left \langle \frac { D V } { d s } , W \right \rangle = \left \langle \frac { D ^ { 2 } V } { d s ^ { 2 } } , W \right \rangle + \left \langle \frac { D V } { d s } , \frac { D W } { d s } \right \rangle ,
$$

we may write I in the form (cf. Remark 4, Sec. 5-4)

$$
I ( V , W ) = \left \langle \frac { D V } { d s } , W \right \rangle \Big | _ { 0 } ^ { l } - \int _ { 0 } ^ { l } \left ( \left \langle \frac { D ^ { 2 } V } { d s ^ { 2 } } + K ( s ) V ( s ) , W ( s ) \right \rangle \right ) d s .
$$

$$
& V , W ) = \left \langle \frac { D V } { d s } , W \right \rangle \Big | _ { 0 } ^ { l } - \int _ { 0 } ^ { l } \left ( \left \langle \frac { D ^ { 2 } V } { d s ^ { 2 } } + K ( s ) V ( s ) , W ( s ) \right \rangle \right ) d s . \\ & \text {fact that } V \text { is a Jacobian field orthogonal to } \gamma , \text { we conclude that the } \\
$$

From the fact that V is a Jacobi ﬁeld orthogonal to γ , we conclude that the integrand of the second term is zero. Therefore,

$$
I ( V , W ) = \left \langle \frac { D V } { d s } ( l ) , W ( l ) \right \rangle - \left \langle \frac { D V } { d s } ( 0 ) , W ( 0 ) \right \rangle . \quad Q . E . D .
$$

We are now in a position to prove:

THEOREM 2 (Jacobi). If we let γ : [0 ,l ] → S be a geodesic of S and we let γ( s 0 ) ∈ γ(( 0 ,l)) be a point conjugate to γ( 0 ) = p relative to γ , then there exists a proper broken variation h: [0 ,l ] × ( − ǫ,ǫ) → S of γ and a real number δ > 0 , δ ≤ ǫ , such that if t ∈ ( − δ,δ) , t  = 0 , we have L ( t ) < L ( 0 ) .

Proof . Since γ(s 0 ) is conjugate to p relative to γ , there exists a Jacobi ﬁeld J along γ , notidenticallyzero, with J( 0 ) = J(s 0 ) = 0. ByProp. 4ofSec. 5-5, it follows that   J(s),γ ′ (s)   = 0, s ∈ [0 ,l ]. Furthermore, ( DJ / ds )(s 0 )  = 0; otherwise, J(s) ≡ 0. Now let ¯ Z be a parallel vector ﬁeld along γ , with ¯ Z(s 0 ) = − ( DJ / ds )(s 0 ) ,

Now let ¯ Z be a parallel vector field along γ , with ¯ Z(s 0 ) = -( DJ / ds )(s 0 ) , and f : [0 , l ] → R be a differentiable function with f( 0 ) = f(l) = 0, f(s 0 ) = 1. Define Z(s) = f(s) ¯ Z(s) , s ∈ [0 , l ].

For each real number η > 0, define a vector field Yη along γ by

$$
Y _ { \eta } & = J ( s ) + \eta Z ( s ) , \quad s \in [ 0 , s _ { 0 } ] , \\ & = \eta Z ( s ) , \quad s \in [ s _ { 0 } , l ] .
$$

Y η is a piecewise differentiable vector ﬁeld orthogonal to γ . Since Y η ( 0 ) = Y η (l) = 0, it gives rise to a proper, orthogonal, broken variation of γ . We shall compute L ′′ ( 0 ) = I(Y η ,Y η ) . For the segment of geodesic between 0 and s 0 , we shall use the bilinearity

For the segment of geodesic between 0 and s 0 , we shall use the bilinearity of I and Lemma 2 to obtain

[Page 445]

$$
I _ { s _ { 0 } } ( Y _ { \eta } , Y _ { \eta } ) & = I _ { s _ { 0 } } ( J + \eta Z , \, J + \eta Z ) \\ & = I _ { s _ { 0 } } ( J , \, J ) + 2 \eta I _ { s _ { 0 } } ( J , \, Z ) + \eta ^ { 2 } I _ { s _ { 0 } } ( Z , \, Z ) \\ & = 2 \eta \left \langle \frac { D J } { d s } ( s _ { 0 } ) , \, Z ( s _ { 0 } ) \right \rangle + \eta ^ { 2 } I _ { s _ { 0 } } ( Z , \, Z ) \\ & = - 2 \eta \left | \frac { D J } { d s } ( s _ { 0 } ) \right | ^ { 2 } + \eta ^ { 2 } I _ { s _ { 0 } } ( Z , \, Z ) , \\ \intertext { i r e } I _ { s _ { 0 } } \, \text {indicates that the corresponding integral is taken between 0 and } \, 0 \, \text { and } \, I _ { s _ { 0 } } \, \text { } \, \intertext { s u n g } I \, \intertext { i n d o n e t h e i n g e r }
$$

= −   ds 0   + s 0 where I s 0 indicates that the corresponding integral is taken between 0 and s 0 . By using I to denote the integral between 0 and l and noticing that the integral is additive, we have

$$
I ( Y _ { \eta } , Y _ { \eta } ) = - 2 \eta \left | \frac { D J } { d s } ( s _ { 0 } ) \right | ^ { 2 } + \eta ^ { 2 } I ( Z , Z ) . \\ \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext { e n o w t h a t i f } \intertext
$$

η η = −   ds 0   + Observe now that if η = η 0 is sufﬁciently small, the above expression is negative. Therefore, by taking Y η 0 , we shall obtain a proper broken variation, with L ′′ ( 0 ) < 0. Since L ′ ( 0 ) = 0, this means that 0 is a point of local maximum for L ; that is, there exists δ > 0 such that if t ∈ ( − δ,δ) , t  = 0, then L(t) < L( 0 ) . Q.E.D.

Remark 3. Jacobi’s theorem is a particular case of the Morse index theorem, quoted in Remark 2. Actually, the crucial point of the proof of the index theorem is essentially an extension of the ideas presented in the proof of Theorem 2.

# EXERCISES

- 1. ( Bonnet’ s Theorem. ) Let S be a complete surface with Gaussian curvature K ≥ δ > 0. By Exercise 5 of Sec. 5-5, every geodesic γ : [0 , ∞ ) → S has a point conjugate to γ( 0 ) in the interval ( 0 ,π/ √ δ ]. Use Jacobi’s theorems to showthatthisimpliesthat S iscompactandthatthediameter p(S) ≤ π/ √ δ ( this gives a new proof of Bonnet’s theorem of Sec. 5-4).
- 2. ( Lines on Complete Surfaces .) A geodesic γ : ( −∞ , ∞ ) → S is called a


line if its length realizes the (intrinsic) distance between any two of its points.

- a. Showthatthrougheachpointofthecompletecylinder x 2 + y 2 = 1there passes a line.
- b. Assume that S is a complete surface with Gaussian curvature K > 0. Let γ : ( −∞ , ∞ ) → S be a geodesic on S and let J(s) be a Jacobi ﬁeld along γ given by   J( 0 ),γ ′ ( 0 )   = 0, | J( 0 ) | = 1, J ′ ( 0 ) = 0. Choose an orthonormal basis { e 1 ( 0 ) = γ ′ ( 0 ),e 2 ( 0 ) } at T γ( 0 ) (S) and extend it


[Page 446]

by parallel transport along γ to obtain a basis { e 1 (s),e 2 (s) } at each T γ( 0 ) (S) . Show that J(s) = u(s)e 2 (s) for some function u(s) and that the Jacobi equation for J is

$$
u ^ { \prime \prime } + K u = 0 , \ \ u ( 0 ) = 1 , \ \ u ^ { \prime } ( 0 ) = 0 . \quad ( * )
$$

c. Extend to the present situation the comparison theorem of part b of Exercise 3, Sec. 5-5. Use the fact that K > 0 to show that it is possible to choose ǫ > 0 sufﬁciently small so that

$$
u ( \epsilon ) > 0 , \ \ u ( - \epsilon ) > 0 , \ \ u ^ { \prime } ( \epsilon ) < 0 , \ \ u ^ { \prime } ( - \epsilon ) > 0 ,
$$

where u(s) is a solution of ( ∗ ) . Compare ( ∗ ) with

$$
v ^ { \prime \prime } ( s ) = 0 , \ \ v ( \epsilon ) = u ( \epsilon ) , \ \ v ^ { \prime } ( \epsilon ) = u ^ { \prime } ( \epsilon ) , \ \ \text {for } s \in [ \epsilon , \infty )
$$

and with

$$
w ^ { \prime \prime } ( s ) = 0 , \quad w ( - \epsilon ) = u ( - \epsilon ) , \quad w ^ { \prime } ( - \epsilon ) = u ^ { \prime } ( - \epsilon ) , \quad \text {for} \, s \in ( - \infty , - \epsilon ]
$$

to conclude that if s 0 is sufﬁciently large, then J(s) has two zeros in the interval ( − s 0 ,s 0 ) . Use the above to prove that a complete surface with positive Gaussian

Use the above to prove that a complete surface with positive Gaussian curvature contains no lines.

# 5-10. Abstract Surfaces; Further Generalizations

In Sec. 5-11, we shall prove a theorem, due to Hilbert, which asserts that there exists no complete regular surface in R 3 with constant negative Gaussian curvature.

Actually, the theorem is somewhat stronger. To understand the correct statement and the proof of Hilbert’s theorem, it will be convenient to introduce the notion of an abstract geometric surface which arises from the following considerations. 3

So far the surfaces we have dealt with are subsets S of R on which differentiable functions make sense. We deﬁned a tangent plane T p (S) at each p ∈ S and developed the differential geometry around p as the study of the variation of T p (S) . We have, however, observed that all the notions of the intrinsic geometry (Gaussian curvature, geodesics, completeness, etc.) only depended on the choice of an inner product on each T p (S) . If we are able to deﬁne abstractly (that is, with no reference to R 3 ) a set S on which differentiable functions make sense, we might eventually extend the intrinsic geometry to such sets.

The deﬁnition below is an outgrowth of our experience in Chap. 2. Historically, ittookalongtimetoappear, probablyduetothefactthatthefundamental

[Page 447]

DEFINITION 1. An abstract surface (differentiable manifold of dimension 2 ) is a set S together with a family of one-to-one maps x α : U α → S of open sets U α ⊂ R 2 into S such that 1. x U S .

  α α ( α ) = 2. For each pair α , β with x α ( U α ) ∩ x β ( U β ) = W  = φ , we have that x − 1 α ( W ) , x − 1 β ( W ) are open sets in R 2 , and x − 1 β ◦ x α , x − 1 α ◦ x β are differentiable maps (Fig. 5 46 ).

=

(

)∩

(

)

![In this image, we can see a diagram with a diagram of a chord and a chord. We can also see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord. We can see a diagram of a chord and a chord.](<images/imageFile74.png>)

W

x

U α

x

U p

α

β

S

p

x

-1

α

(

)

x

W

α

x

U α

β

-1

.

x

x

α

β

U β

-1

(

)

x

W

β

Figure 5-46

The pair (U α , x α ) with p ∈ x α (U α ) is called a parametrization (or coordinate system) of S around p . x α (U α ) is called a coordinate neighborhood , and if q = x α (u α ,v α ) ∈ S , we say that (u α ,v α ) are the coordinates of q in this coordinate system. The family { U α , x α } is called a differentiable structure for S . 1 2

We say that a set V ⊂ S is an open set if x − α (V ) is open in R for all α . It follows immediately from condition 2 that the “change of parameters”

is a diffeomorphism.

$$
x _ { \beta } ^ { - 1 } \circ x _ { \alpha } \colon x _ { \alpha } ^ { - 1 } ( W ) \rightarrow x _ { \beta } ^ { - 1 } ( W )
$$

Remark 1. It is sometimes convenient to add a further axiom to Def. 1 and say that the differentiable structure should be maximal relative to conditions 1 and 2. This means that the family { Uα, x α } is not properly contained in any other family of coordinate neighborhoods satisfying conditions 1 and 2.

[Page 448]

Acomparisonoftheabovedeﬁnitionwiththedeﬁnitionofaregularsurface in R 3 (Sec. 2-2, Def. 1)showsthatthemainpointistoincludethelawofchange of parameters (which is a theorem for surfaces in R 3 , cf. Sec. 2-3, Prop. 1) in the deﬁnition of an abstract surface. Since this was the property which allowed us to deﬁne differentiable functions on surfaces in R 3 (Sec. 2-3, Def. 1), we may set

DEFINITION 2. Let S 1 and S 2 be abstract surfaces. A map ϕ : S 1 → S 2 is differentiable at p ∈ S 1 if given a parametrization y : V ⊂ R 2 → S 2 around ϕ( p ) there exists a parametrization x : U ⊂ R 2 → S 1 around p such that ϕ( x ( U )) ⊂ y ( V ) and the map 1 2 2

$$
y ^ { - 1 } \circ \varphi \circ x \colon U \subset R ^ { 2 } & \to R ^ { 2 } \\
$$

is differentiable at x − 1 ( p ) . ϕ is differentiable on S 1 if it is differentiable at every p ∈ S 1 (Fig. 5 47 ).

It is clear, by condition 2, that this deﬁnition does not depend on the choices of the parametrizations. The map (1) is called the expression of ϕ in the parametrizations x , y .

![The image consists of a geometric figure with several points and lines. The points are labeled as \( P \), \( S \), \( \iota \), \( \iota \), \( \iota \), and \( \iota \). The line segment \( \iota \) is drawn from point \( P \) to point \( S \). The line segment \( \iota \) is a straight line. The line segment \( \iota \) intersects the line segment \( \iota \) at point \( \iota \).](<images/imageFile75.png>)

(

(

))

φ

U

x

(

)

U

x

(

)

φ

p

S

2

p

S

(

)

1

V

y

φ

y

x

-1

φ

y

x

°

°

V

U

Figure 5-47

[Page 449]

Thus, on an abstract surface it makes sense to talk about differentiable functions, andwehavegiventheﬁrststeptowardthegeneralizationofintrinsic geometry.

Example 1. Let S 2 = { (x,y,z) ∈ R 3 ; x 2 + y 2 + z 2 = 1 } be the unit sphere and let A : S 2 → S 2 be the antipodal map; i.e., A(x,y,z) = ( − x, − y, − z) . Let P 2 be the set obtained from S 2 by identifying p with A(p) and denote by π : S 2 → P 2 the natural map π(p) = { p,A(p) } . Cover S 2 with parametrizations x α : U α → S 2 such that x α (U α ) ∩ A ◦ x α (U α ) = φ . From the fact that S 2 is a regular surface and A is a diffeomorphism, it follows that P 2 together with the family { U α ,π ◦ x α } is an abstract surface, to be denoted again by P 2 . P 2 is called the real projective plane .

Example 2. Let T ⊂ R 3 be a torus of revolution (Sec. 2-2, Example 4) with center in ( 0 , 0 , 0 ) ∈ R 3 and Jet A : T → T be deﬁned by A(x,y,z) = ( − x, − y, − z) (Fig. 5-48). Let K be the quotient space of T by the equivalence relation p ∼ A(p) and denote by π : T → K the map π(p) = { p,A(p) } . Cover T with parametrizations x α : U α → T such that x α (U α ) ∩ A ◦ x α (U α ) = φ . As before, it is possible to prove that K with the family { U α ,π ◦ x α } is an abstract surface, which is called the Klein bottle .

![In the diagram, there is a circle with a center labeled as O. Inside the circle, there are two points labeled as A and B. A line is drawn from point A to point B. There are two points labeled as C and D.](<images/imageFile76.png>)

(

)

A

p

p

Figure 5-48

Now we need to associate a tangent plane to each point of an abstract surface S . It is again convenient to use our experience with surfaces in R 3 (Sec. 2-4). There the tangent plane was the set of tangent vectors at a point, a tangent vector at a point being deﬁned as the velocity at that point of a curve on the surface. Thus, we must deﬁne what the tangent vector of a curve on an abstract surface is. Since we do not have the support of R 3 , we must search for a characteristic property of tangent vectors to curves which is independent of R 3 .

Thefollowingconsiderationswillmotivatethedeﬁnitiontobegivenbelow. Let α : ( − ǫ,ǫ) → R 2 be a differentiable curve in R 2 , with α( 0 ) = p . Write

[Page 450]

α(t) = (u(t),v(t)) , t ∈ ( − ǫ,ǫ) , and α ′ ( 0 ) = (u ′ ( 0 ),v ′ ( 0 )) = w . Let f be a differentiable function deﬁned in a neighborhood of p . We can restrict f to α and write the directional derivative of f relative to w as follows:

$$
\frac { d ( f \circ \alpha ) } { d t } \Big | _ { t = 0 } & = \left ( \frac { \partial f } { \partial u } \frac { d u } { d t } + \frac { \partial f } { \partial v } \frac { d v } { d t } \right ) \Big | _ { t = 0 } = \left \{ u ^ { \prime } ( 0 ) \frac { \partial } { \partial u } + v ^ { \prime } ( 0 ) \frac { \partial } { \partial v } \right \} f . \\ \intertext { T h u s , the directional derivative in the direction of the vector w is an operator }
$$

dt   t = 0 =   ∂u dt + ∂v dt     t = 0 =   ∂u + ∂v   Thus, the directional derivative in the direction of the vector w is an operator on differentiable functions which depends only on w . This is the characteristic property of tangent vectors that we were looking for.

DEFINITION 3. A differentiable map α : ( − ǫ,ǫ) → S is called a curve on S . Assume that α( 0 ) = p and let D be the set of functions on S which are differentiable at p . The tangent vector to the curve α at t = 0 is the function α ′ ( 0 ) : D → R given by

$$
\alpha ^ { \prime } ( 0 ) ( f ) = \frac { d ( f \circ \alpha ) } { d t } \Big | _ { t = 0 } \, , \quad f \in D . \\ \intertext { a t a p o i n t p \in S i s t h e t a n g e n t v e c t o r a t t = 0 }
$$

= dt   t = 0 ∈ A tangent vector at a point p ∈ S is the tangent vector at t = 0 of some curve α : ( − ǫ,ǫ) → S with α( 0 ) = p .

$$
\alpha \colon ( - \epsilon , \epsilon ) \to S \text { with } \alpha ( 0 ) = \mathbf p .
$$

By choosing a parametrization x : U → S around p = x ( 0 , 0 ) we may express both the function f and the curve α in x by f(u,v) and (u(t),v(t)) , respectively. Therefore,

$$
\alpha ^ { \prime } ( 0 ) ( f ) & = \frac { d } { d t } ( f \circ \alpha ) \Big | _ { t = 0 } = \frac { d } { d t } ( f ( u ( t ) , v ( t ) ) ) \Big | _ { t = 0 } \\ & = u ^ { \prime } ( 0 ) \left ( \frac { \partial f } { \partial u } \right ) _ { 0 } + v ^ { \prime } ( 0 ) \left ( \frac { \partial f } { \partial v } \right ) _ { 0 } \\ & = \left \{ u ^ { \prime } ( 0 ) \left ( \frac { \partial } { \partial u } \right ) _ { 0 } + v ^ { \prime } ( 0 ) \left ( \frac { \partial } { \partial v } \right ) _ { 0 } \right \} ( f ) . \\ \intertext { s u g g e s , g i v e n d o r d i n a tes ( u , v ) a r o u n d p , t h a r w e d e n o t e b y ( \partial / a ) }
$$

This suggests, given coordinates (u,v) around p , that we denote by (∂/∂u) 0 the tangent vector at p which maps a function f into (∂f/∂u) 0 ; a similar meaning will be attached to the symbol (∂/∂v) 0 . We remark that (∂/∂u) 0 , (∂/∂v) 0 may be interpreted as the tangent vectors at p of the “coordinate curves”

$$
u \rightarrow \mathbf x ( u , 0 ) , \ \ v \rightarrow \mathbf x ( 0 , v ) ,
$$

respectively (Fig. 5-49).

From the above, it follows that the set of tangent vectors at p , with the usual operations for functions, is a two-dimensional vector space T p (S) to be called the tangent space of S at p . It is also clear that the choice of a parametrization

[Page 451]

![The image consists of a diagram with a geometric figure. The diagram includes a circle with a radius labeled as \( r \). Inside the circle, there is a point labeled as \( \omega \) and a point labeled as \( \gamma \). The point \( \omega \) is located at the center of the circle. The point \( \gamma \) is located at the center of the circle. The diagram also includes a line segment labeled as \( \alpha \) and a line segment labeled as \( \beta \). The line segment \( \alpha \) is a line segment that is perpendicular to the line segment \( \gamma \). The line segment \( \beta \) is a line segment that is perpendicular to the line segment \( \gamma \). The diagram also includes a point labeled as \( \kappa \) and a point labeled as \( \kappa \). The point \](<images/imageFile77.png>)

∂

∂

)

(

,

u

v

v

x

0

∂

∂

u

v

(

,

)

u

v

x

0

(

)

q

x

x

v = v 0

0

q

0

u

u = u 0

0

Figure 5-49

x : U → S around p determines an associated basis { (∂/∂u) q ,(∂/∂v) q } of T q (S) for any q ∈ x (U) . With the notion of tangent space, we can extend to abstract surfaces the

With the notion of tangent space, we can extend to abstract surfaces the definition of differential.

DEFINITION 4. Let S 1 and S 2 be abstract surfaces and let ϕ : S 1 → S 2 be a differentiable map. For each p ∈ S 1 and each w ∈ T p ( S 1 ) , consider a differentiable curve α : ( − ǫ,ǫ) → S 1 , with α( 0 ) = p , α ′ ( 0 ) = w . Set β = ϕ ◦ α . The map d ϕ p : T p ( S 1 ) → T p ( S 2 ) given by d ϕ p ( w ) = β ′ ( 0 ) is a well-deﬁned linear map, called the differential of ϕ at p .

The proof that dϕ p is well deﬁned and linear is exactly the same as the proof of Prop. 2 in Sec. 2-4.

We are now in a position to take the ﬁnal step in our generalization of the intrinsic geometry.

DEFINITION 5. A geometric surface (Riemannian manifold of dimension 2 ) is an abstract surface S together with the choice of an inner product   ,   p at each T p ( S ) , p ∈ S , which varies differentiably with p in the following sense. For some (and hence all) parametrization x : U → S around p , the functions

$$
E ( u , v ) = \left \langle \frac { \partial } { \partial u } , \frac { \partial } { \partial u } \right \rangle , \ \ F ( u , v ) = \left \langle \frac { \partial } { \partial u } , \frac { \partial } { \partial v } \right \rangle , \ \ G ( u , v ) = \left \langle \frac { \partial } { \partial v } , \frac { \partial } { \partial v } \right \rangle
$$

are differentiable functions in U . The inner product   ,   is often called a ( Riemannian ) metric on S .

It is now a simple matter to extend to geometric surfaces the notions of the intrinsic geometry. Indeed, with the functions E , F , G we define Christoffel symbols for S by system 2 of Sec. 4-3. Since the notions of intrinsic geometry were all defined in terms of the Christoffel symbols, they can now be defined in S .

[Page 452]

Thus, covariant derivatives of vector ﬁelds along curves are given by Eq. (1) of Sec. 4-4. The existence of parallel transport follows from Prop. 2 of Sec. 4-4, and a geodesic is a curve such that the ﬁeld of its tangent vectors has zero covariant derivative. Gaussian curvature can be either deﬁned by Eq. (5) of Sec. 4-3 or in terms of the parallel transport, as in done in Sec. 4-5.

That this brings into play some new and interesting objects can be seen by the following considerations. We shall start with an example related to Hilbert’s theorem.

Example 3. Let S = R 2 be a plane with coordinates (u,v) and deﬁne an inner product at each point q = (u,v) ∈ R 2 by setting

$$
\left \langle \frac { \partial } { \partial u } , \frac { \partial } { \partial u } \right \rangle _ { q } & = E = 1 , \quad \left \langle \frac { \partial } { \partial u } , \frac { \partial } { \partial v } \right \rangle _ { q } = F = 0 , \\ \left \langle \frac { \partial } { \partial v } , \frac { \partial } { \partial v } \right \rangle _ { q } & = G = e ^ { 2 u } . \\ \intertext { h i n n e r p r o d u c t i s a g e o m m e r t i c r a s f o r c e s }
$$

R 2 with this inner product is a geometric surface H called the hyperbolic plane . The geometry of H is different from the usual geometry of R 2 . For instance, the curvature of H is (Sec. 4-3, Exercise 1)

$$
K = - \frac { 1 } { 2 \sqrt { E G } } \left \{ \left ( \frac { E _ { v } } { \sqrt { E G } } \right ) _ { v } + \left ( \frac { G _ { u } } { \sqrt { E G } } \right ) _ { u } \right \} = - \frac { 1 } { 2 e ^ { u } } \left ( \frac { 2 e ^ { 2 u } } { e ^ { u } } \right ) _ { u } = - 1 . \\ A _ { u } \log _ { u } a _ { v } = \log _ { u } a _ { v } \log _ { v } a _ { u } \log _ { u } a _ { v } \log _ { v } a _ { u }
$$

Actually the geometry of H is an exact model for the non-Euclidean geometry of Lobachewski, in which all the axioms of Euclid, except the axiom of parallels, are assumed (cf. Sec. 4-5). To make this point clear, we shall compute the geodesics of H .

If we look at the differential equations for the geodesics when E = 1, F = 0 (Sec. 4-6, Exercise 2), we see immediately that the curves v = const . are geodesics. To ﬁnd the other ones, it is convenient to deﬁne a map

$$
\phi \colon H \to R _ { + } ^ { 2 } = \{ ( x , y ) \in R ^ { 2 } ; \, y > 0 \} \\
$$

by φ(u,v) = (v,e − u ) . It is easily seen that φ is differentiable and, since y > 0, that it has a differentiable inverse. Thus, φ is a diffeomorphism, and we can induce an inner product in R 2 + by setting

$$
\langle d \phi ( w _ { 1 } ) , d \phi ( w _ { 2 } ) \rangle _ { \phi ( q ) } & = \langle w _ { 1 } , w _ { 2 } \rangle _ { q } . \\
$$

To compute this inner product, we observe that

$$
\frac { \partial } { \partial x } = \frac { \partial } { \partial v } , \ \frac { \partial } { \partial y } = - e ^ { u } \frac { \partial } { \partial u } ,
$$

[Page 453]

hence,

$$
\left \langle \frac { \partial } { \partial x } , \frac { \partial } { \partial x } \right \rangle = e ^ { 2 u } = \frac { 1 } { y ^ { 2 } } , \quad \left \langle \frac { \partial } { \partial x } , \frac { \partial } { \partial y } \right \rangle = 0 , \quad \left \langle \frac { \partial } { \partial y } , \frac { \partial } { \partial y } \right \rangle = \frac { 1 } { y ^ { 2 } } . \\ \\ P ^ { 2 } \quad ; \dot { y } _ { 1 } \dot { x } \colon \dot { y } \colon \\
$$

R 2 + with this inner product is isometric to H , and it is sometimes called the Poincaré half-plane .

To determine the geodesics of H , we work with the Poincaré half-plane and make two further coordinate changes.

First, ﬁx a point (x 0 , 0 ) and set (Fig. 5-50)

$$
x - x _ { 0 } = \rho \cos \theta , \ \ y = \rho \sin \theta ,
$$

Parallels to

![The image presents a geometric figure involving a circle and several lines. Let's break down the components of the image: 1. **Circle**: The central object in the image is a circle. The circle is depicted as a closed arc with a center point labeled as \( \omega \). 2. **Lines**: - **Line 1**: This line is a chord of the circle. It is drawn from the center of the circle to the left side of the circle. - **Line 2**: This line is a chord of the circle. It is drawn from the center of the circle to the right side of the circle. - **Line 3**: This line is a chord of the circle. It is drawn from the center of the circle to the left side of the circle. 3. **Angles**: - **Angles 1 and 2**: These lines intersect at a point labeled as \( \omega \). - **](<images/imageFile78.png>)

through p

γ

p

p

γ

ρ

θ

x

0

Figure 5-50

0 < θ < π , 0 < ρ < +∞ . This is a diffeomorphism of R 2 + into itself, and

$$
\left \langle \frac { \partial } { \partial \rho } , \frac { \partial } { \partial \rho } \right \rangle = \frac { 1 } { \rho ^ { 2 } \sin ^ { 2 } \theta } , \quad \left \langle \frac { \partial } { \partial \rho } , \frac { \partial } { \partial \theta } \right \rangle = 0 , \quad \left \langle \frac { \partial } { \partial \theta } , \frac { \partial } { \partial \theta } \right \rangle = \frac { 1 } { \sin ^ { 2 } \theta } . \\
$$

Next, consider the diffeomorphism of R 2 + given by (we want to change θ into a parameter that measures the arc length along ρ = const . ) θ

$$
\rho _ { 1 } = \rho , \ \theta _ { 1 } = \int _ { 0 } ^ { \theta } \frac { 1 } { \sin \theta } \, d \theta ,
$$

which yields

$$
\left \langle \frac { \partial } { \partial \rho _ { 1 } } , \frac { \partial } { \partial \rho _ { 1 } } \right \rangle = \frac { 1 } { \rho _ { 1 } ^ { 2 } \sin ^ { 2 } \theta } , \quad \left \langle \frac { \partial } { \partial \rho _ { 1 } } , \frac { \partial } { \partial \theta _ { 1 } } \right \rangle = 0 , \quad \left \langle \frac { \partial } { \partial \theta _ { 1 } } , \frac { \partial } { \partial \theta _ { 1 } } \right \rangle = 1 .
$$

[Page 454]

By looking again at the differential equations for the geodesics (F = 0, G = 1 ) , we see that ρ 1 = ρ = const . are geodesics. (Another way of ﬁnding the geodesics of R 2 + is given in Exercise 8.)

Collecting our observations, we conclude that the lines and the half-circles which are perpendicular to the axis y > 0 are geodesics of the Poincaré halfplane R 2 + . These are all the geodesics of R 2 + , since through each point q ∈ R 2 + andeachdirectionissuingfrom q therepasseseitheracircletangenttothatline and normal to the axis y = 0 or a vertical line (when the direction is vertical). The geometric surface R 2 is complete; that is, geodesics can be deﬁned

+ for all values of the parameter. The proof of this fact will be left as an exercise (Exercise 7; cf. also Exercise 6). 2

It is now easy to see, if we deﬁne a straight line of R + to be a geodesic, that all the axioms of Euclid but the axiom of parallels hold true in this geometry. The axiom of parallels in the Euclidean plane P asserts that from a point not in a straight line r ⊂ P one can draw a unique straight line r ′ ⊂ P that does not meet r . Actually, in R 2 + , from a point not in a geodesic γ we can draw an inﬁnite number of geodesics which do not meet γ .

The question then arises whether such a surface can be found as a regular surface in R 3 . The natural context for this question is the following deﬁnition.

DEFINITION 6. A differentiable map ϕ : S → R 3 of an abstract surface S into R 3 is an immersion if the differential d ϕ p : T p ( S ) → T p ( R 3 ) is injective. If, in addition, S has a metric   ,   and

$$
\langle d \varphi _ { p } ( v ) , d \varphi _ { p } ( w ) \rangle _ { \varphi ( p ) } & = \langle v , w \rangle _ { p } , \ \ v , w \in T _ { p } ( S ) , \\ \vdots & \, _ { L , \, 1 } \quad \vdots \quad _ { \vdots } \quad \vdots \quad _ { p } .
$$

ϕ is said to be an isometric immersion .

Notice that the ﬁrst inner product in the above relation is the usual inner product of R 3 , whereas the second one is the given Riemannian metric on S . This means that in an isometric immersion, the metric “induced” by R 3 on S agrees with the given metric on S .

Hilbert’stheorem, tobeprovedinSec. 5-11, statesthatthereisnoisometric immersion into R 3 of the complete hyperbolic plane. In particular, one cannot ﬁnd a model of the geometry of Lobachewski as a regular surface in R 3 . 3

Actually, there is no need to restrict ourselves to R . The above deﬁnition of isometric immersion makes perfect sense when we replace R 3 by R 4 or, for that matter, by an arbitrary R n . Thus, we can broaden our initial question, and ask: For what values of n is there an isometric immersion of the complete hyperbolic plane into R n ? Hilbert’s theorem say that n ≥ 4.As far as we know, the case n = 4 is still unsettled. Thus, the introduction of abstract surfaces brings in new objects and

Thus, the introduction of abstract surfaces brings in new objects and illuminates our view of important questions.

In the rest of this section, we shall explore in more detail some of the ideas just introduced and shall show how they lead naturally to further important

[Page 455]

Let us look into further examples.

Example 4. Let R 2 be a plane with coordinates (x,y) and T m,n : R 2 → R 2 be the map (translation) T m,n (x,y) = (x + m,y + n) , where m and n are integers. Deﬁneanequivalencerelationin R 2 by (x,y) ∼ (x 1 ,y 1 ) ifthereexist integers m , n such that T m,n (x,y) = (x 1 ,y 1 ) . Let T be the quotient space of R 2 by this equivalence relation, and let π : R 2 → T be the natural projection map π(x,y) = { T m,n (xy) ; all integers m , n } . Thus, in each open unit square whose vertices have integer coordinates, there is only one representative of T , and T may be thought of as a closed square with opposite sides identiﬁed. (See Fig. 5-51. Notice that all points of R 2 denoted by x represent the same point p in T .) 2 2 2

Let i α : U α ⊂ R → R be a family of parametrizations of R , where i α is the identity map, such that U α ∩ T m,n (U α ) = φ for all m , n . Since T m,n is a diffeomorphism, it is easily checked that the family (U α ,π ◦ i α ) is a differentiable structure for T . T is called a (differentiable) torus . From the very

![The diagram shows a diagram of a metal object with a circular cross-section. The object is labeled as T and has a circular base. The object has a circular cross-section with a central point. The object is labeled as x and has a circular base. The object is labeled as O and has a circular cross-section with a central point. The object is labeled as x and has a circular base. The object is labeled as O and has a circular cross-section with a central point. The object is labeled as x and has a circular base. The object is labeled as O and has a circular cross-section with a central point. The object is labeled as x and has a circular base. The object is labeled as O and has a circular cross-section with a central point. The object is labeled as x and has a circular base. The object is labeled as O](<images/imageFile79.png>)

y

x

0

π

T

p

[Page 456]

Now notice that T m,n is an isometry of R 2 and introduce a geometric (Riemannian) structure on T as follows. Let p ∈ T and v ∈ T p (T ) . Let q 1 ,q 2 ∈ R 2 and w 1 ,w 2 ∈ R 2 be such that π(q 1 ) = π(q 2 ) = p and dπ q 1 (w 1 ) = dπ q 2 (w 2 ) = v . Then q 1 ∼ q 2 ; hence, there exists T m,n such that T m,n (q 1 ) = q 2 , d(T m,n ) q 1 (w 1 ) = w 2 . Since T m,n is an isometry, | w 1 | = | w 2 | . Now, deﬁne the length of v in T p (T ) by | v | = | dπ q (w 1 ) | = | w 1 | . By what we have seen. this is well deﬁned. Clearly this gives rise to an inner product   ,   p , on T p (T ) for each p ∈ T . Since this is essentially the inner product of R 2 and π is a local diffeomorphism,   ,   p , varies differentiably with p . Observe that the coefﬁcients of the ﬁrst fundamental form of T , in any of

the parametrizations of the family { U α ,π ◦ i α } are E = G = 1, F = 0. Thus, this torus behaves locally like a Euclidean space. For instance, its Gaussian curvature is identically zero (cf. Exercise 1, Sec. 4-3). This accounts for the name ﬂat torus , which is usually given to T with the inner product just described. 3

Clearly the ﬂat torus cannot be isometrically immersed in R , since, by compactness, it would have a point of positive curvature (cf. Exercise 16, Sec. 3-3, or Lemma 2, Sec. 5-2). However, it can be isometrically immersed in R 4 . 2 4

In fact, let F : R → R be given by

$$
F ( x , y ) = \frac { 1 } { 2 \pi } ( \cos 2 \pi x , \sin 2 \pi x , \cos 2 \pi y , \sin 2 \pi y ) .
$$

$$
= \frac { 1 } { 2 \pi } 0
$$

Since F(x + m,y + n) = F(x,y) for all m , n , we can deﬁne a map ϕ : T → R 4 by ϕ(p) = F(q) , where q ∈ π − 1 (p) . Clearly, ϕ ◦ π = F , and since π : R 2 → T is a local diffeomorphism, ϕ is differentiable. Furthermore, the rank of dϕ is equal to the rank of dF , which is easily computed to be 2. Thus, ϕ is an immersion. To see that the immersion is isometric, we ﬁrst observe that if e 1 = ( 1 , 0 ) , e 2 = ( 0 , 1 ) are the vectors of the canonical basis in R 2 , the vectors dπ q (e 1 ) = f 1 , dπ q (e 2 ) = f 2 , q ∈ R 2 , form a basis for T π(q) (T ) . By deﬁnition of the inner product on T ,   f i ,f j   =   e i ,e j   , i,j = 1 , 2. Next, we compute

〈 〉 = 〈 〉 =

$$
\frac { \partial F } { \partial r } = d F ( e _ { 1 } ) = ( - \sin 2 \pi x , \cos 2 \pi x , 0 , 0 ) ,
$$

$$
\frac { \partial F } { \partial x } & = d F ( e _ { 1 } ) = ( - \sin 2 \pi x , \cos 2 \pi x , 0 , 0 ) , \\ \frac { \partial F } { \partial y } & = d F ( e _ { 2 } ) = ( 0 , 0 , - \sin 2 \pi y , \cos 2 \pi y ) ,
$$

and obtain that

$$
\langle d F ( e _ { i } ) , d F ( e _ { j } ) \rangle = \langle e _ { i } , e _ { j } \rangle = \langle f _ { i } , f _ { j } \rangle .
$$

[Page 457]

$$
\langle d \varphi ( f _ { i } ) , d \varphi ( f _ { j } ) \rangle = \langle d \varphi ( d \pi ( e _ { i } ) ) , d \varphi ( d \pi ( e _ { j } ) ) \rangle = \langle f _ { i } , f _ { j } \rangle .
$$

It follows that ϕ is an isometric immersion, as we had asserted.

It should be remarked that the image ϕ(S) of an immersion ϕ : S → R n may have self-intersections. In the previous example, ϕ : T → R 4 is one-to-one, and furthermore ϕ is a homeomorphism onto its image.It is convenient to use the following terminology.

DEFINITION 7. Let S be an abstract surface. A differentiable map ϕ : S → R n is an embedding if ϕ is an immersion and a homeomorphism onto its image.

For instance, a regular surface in R 3 can be characterized as the image of an abstract surface S by an embedding ϕ : S → R 3 . This means that only those abstract surfaces which can be embedded in R 3 could have been detected in our previous study of regular surfaces in R 3 . That this is a serious restriction can be seen by the example below.

Example 5. Weﬁrstremarkthatthedeﬁnitionoforientability(cf. Sec.2-6, Def. 1) can be extended, without changing a single word, to abstract surfaces. Now consider the real projective plane P 2 of Example 1. We claim that P 2 is nonorientable.

To prove this, we ﬁrst make the following general observation. Whenever an abstract surface S contains an open set M diffeomorphic to a Möbius strip (Sec. 2-6, Example 3), it is nonorientable. Otherwise, there exists a family of parametrizations covering S with the property that all coordinate changes have positive Jacobian; the restriction of such a family to M will induce an orientation on M which is a contradiction. 2 2

Now, P is obtained from the sphere S by identifying antipodal points. Consider on S 2 a thin strip B made up of open segments of meridians whose centers lay on half an equator (Fig. 5-52). Under identiﬁcation of antipodal points, B clearly becomes an open Möbius strip in P 2 . Thus, P 2 is nonorientable.

![image 80](<images/imageFile80.png>)

[Page 458]

Byasimilarargument, itcanbeshownthattheKleinbottle K ofExample2 is also nonorientable. In general, whenever a regular surface S ⊂ R 3 is symmetric relative to the origin of R 3 , identiﬁcation of symmetric points gives rise to a nonorientable abstract surface. 3

It can be proved that a compact regular surface in R is orientable (cf. Remark 2, Sec. 2-7). Thus, P 2 and K cannot be embedded in R 3 , and the same happens to the compact nonorientable surfaces generated as above. Thus, we miss quite a number of surfaces in R 3 . 2 4

P and K can, however, be embedded in R . For the Klein bottle K , consider the map G : R 2 → R 4 given by

$$
G ( u , v ) = \left ( ( r \cos v + a ) \cos u , \, ( r \cos v + a ) \sin u , \\ r \sin v \cos \frac { u } { 2 } , r \sin v \sin \frac { u } { 2 } \right ) . \\ \intertext { i n t a t G ( u , v ) = G ( u + 2 m \pi \, \ ? n \pi - v ) \, w h e r e \, m \, a n d \, n \, a r e \, i n t e }
$$

Notice that G(u,v) = G(u + 2 mπ, 2 nπ − v) , where m and n are integers. Thus, G induces a map ψ of the space obtained from the square

$$
[ 0 , 2 \pi ] \times [ 0 , 2 \pi ] \subset R ^ { 2 }
$$

by ﬁrst reﬂecting one of its sides in the center of this side and then identifying opposite sides (see Fig. 5-53). That this is the Klein bottle, as deﬁned in Example 2, can be seen by throwing away an open half of the torus in which antipodal points are being identiﬁed and observing that both processes lead to the same surface (Fig. 5-53).

![The image depicts a geometric figure with a series of interconnected circles and lines. The circles are arranged in a circular pattern, with each circle connected to the next by lines. The circles are interconnected by lines, forming a continuous loop. The lines are not straight, but rather curved, indicating that the circles are not perfectly straight. The image includes a series of arrows pointing from one circle to another. These arrows are labeled with the letter K and L and are pointing in different directions. The arrows are connected to the circles, indicating that they are part of a larger geometric figure. The image also includes a series of arrows pointing from one circle to another. These arrows are labeled with the letter M and are pointing in different directions. The arrows are connected to the circles, indicating that they are part of a larger geometric figure. The image also includes a series of arrows pointing from one circle to another. These arrows are labeled with the letter N](<images/imageFile81.png>)

Klein bottle

immersed in R 3

with self-intersections

[Page 459]

Thus, ψ is a map of K into R 4 . Observe further that

$$
G ( u + 4 m \pi , v + 2 m \pi ) = G ( u , v ) .
$$

It follows that G = ψ ◦ π 1 ◦ π , where π : R 2 → T is essentially the natural projection on the torus T (cf. Example 4) and π 1 : T → K corresponds to identifying “antipodal” points in T . By the deﬁnition of the differentiable structures on T and K , π and π 1 are local diffeomorphisms. Thus, ψ : K → R 4 is differentiable, and the rank of dψ is the same as the rank of dG . The latter is easily computed to be 2; hence, ψ is an immersion. Since K is compact and ψ is one-to-one, ψ − 1 is easily seen to be continuous in ϕ(K) . Thus, ψ is an embedding, as we wished. 2 3 4

For the projective plane P , consider the map F : R → R given by

$$
F ( x , y , z ) = ( x ^ { 2 } - y ^ { 2 } , x y , x z , y z ) .
$$

Let S 2 ⊂ R 3 be the unit sphere with center in the origin of R 3 . It is clear that the restriction ϕ = F/S 2 is such that ϕ(p) = ϕ( − p) . Thus, ϕ induces a map

$$
\tilde { \varphi } \colon P ^ { 2 } \to R ^ { 4 } \ \text { by } \ \tilde { \varphi } ( \{ p , - p \} ) = \varphi ( p ) .
$$

To see that ϕ (hence, ˜ ϕ ) is an immersion, consider the parametrization x of S 2 given by x (x,y) = (x,y, +   1 − x 2 − y 2 , where x 2 + y 2 ≤ 1. Then ϕ ◦ x (x,y) = (x 2 − y 2 , xy , xD , yD ), D = 1 − x 2 − y 2 .

$$
\varphi \circ x ( x , y ) & = ( x ^ { 2 } - y ^ { 2 } , x y , x D , y D ) , \quad D = \sqrt { 1 - x ^ { 2 } - y ^ { 2 } } . \\ \intertext { It is easily checked that the matrix of d ( \varphi \circ x ) \ has rank $ 2$. $ Thus, \, \tilde { \varphi } $ is an }
$$

It is easily checked that the matrix of d(ϕ ◦ x ) has rank 2. Thus, ˜ ϕ is an immersion.

To see that ˜ ϕ is one-to-one, set

$$
x ^ { 2 } - y ^ { 2 } = a , \ \ x y = b , \ \ x z = c , \ \ y z = d .
$$

It sufﬁces to show that, under the condition x 2 + y 2 + z 2 = 1, the above equationshaveonlytwosolutionswhichareoftheform (x,y,z) and ( − x, − y, − z) . In fact, we can write

$$
x ^ { 2 } d & = b c , \quad y ^ { 2 } c = b d , \\ z ^ { 2 } b & = c d , \quad x ^ { 2 } - y ^ { 2 } = a , \\ x ^ { 2 } + y ^ { 2 } + z ^ { 2 } & = 1 \\
$$

where the ﬁrst three equations come from the last three equations of (2).

Now, if one of the numbers b,c,d is nonzero, the equations in (3) will give x 2 , y 2 , and z 2 , and the equations in (2) will determine the sign of two coordinates, once given the sign of the remaining one. If b = c = d = 0, the equations in (2) and the last equation of (3) show that exactly two coordinates

[Page 460]

˜ By compactness, ϕ is an embedding, and that concludes the example.

Ifwelookbacktothedeﬁnitionofabstractsurface, weseethatthenumber2 has played no essential role. Thus, we can extend that deﬁnition to an arbitrary n and, as we shall see presently, this may be useful.

DEFINITION 1a. A differentiable manifold of dimension n is a set M together with a family of one-to-one maps x α : U α → M of open sets U α ⊂ R n into M such that

⋃ α x α ( U α ) = M .

, β with x α ( U α ) ∩ x β ( U β ) = W  = φ , we have that x − 1 α ( W ) , x − 1 β ( W ) are open sets in R n and that x − 1 β ◦ x α , x − 1 α ◦ x β are differentiable maps.

3. The family { U α , x α } is maximal relative to conditions 1 and 2 . A family x satisfying conditions 1 and 2 is called a

{ U α , α } differentiable structure on M . Given a differentiable structure on M we can easily complete it intoamaximal one by adding toit all possibleparametrizations that, together with some parametrization of the family { U α , x α } , satisfy condition 2. Thus, with some abuse of language, we may say that a differentiable manifold is a set together with a differentiable structure.

Remark. A family of open sets can be deﬁned in M by the following requirement: V ⊂ M is an open set if for every α , x − 1 α (V ∩ x α (U α )) is an open set in R n . The readers with some knowledge of point set topology will notice that such a family deﬁnes a natural topology on M . In this topology, the maps x α are continuous and the sets x α (U α ) are open in M . In some deeper theorems on manifolds, it is necessary to impose some conditions on the natural topology of M .

The deﬁnitions of differentiable maps and tangent vector carry over, word by word, to differentiable manifolds. Of course, the tangent space is now an n -dimensional vector space. The deﬁnitions of differential and orientability also extend straightforwardly to the present situation.

Inthefollowingexampleweshallshowhowquestionsontwo-dimensional manifolds lead naturally into the consideration of higher-dimensional manifolds.

Example 6. ( The Tangent Bundle ). Let S be an abstract surface and let T (S) = { (p,w) , p ∈ S , w ∈ T p (S) } . We shall show that the set T (S) can be givenadifferentiablestructure(ofdimension4)tobecalledthe tangentbundle of S .

[Page 461]

Let { U α , x α } be a differentiable structure for S . We shall denote by (u α ,v α ) the coordinates of U α , and by { ∂/∂u α ,∂/∂v α } the associated bases in the tangent planes of x α (U α ) . For each α , deﬁne a map y α : U α × R 2 → T (S) by

$$
y _ { \alpha } ( u _ { \alpha } , v _ { \alpha } , x , y ) = \left ( x _ { \alpha } ( u _ { \alpha } , v _ { \alpha } ) , x \frac { \partial } { \partial u _ { \alpha } } + y \frac { \partial } { \partial v _ { \alpha } } \right ) , \quad ( x , y ) \in R ^ { 2 } . \\ \\
$$

$$
-
$$

Geometrically, this means that we shall take as coordinates of a point (p,w) ∈ T (S) the coordinates u α ,v α of p plus the coordinates of w in the basis { ∂/∂u α ,∂/∂v α } . We shall show that { U α × R 2 , y α } is a differentiable structure for T (S) .

We shall show that { Uα × R 2 , y α } is a differentiable structure for T (S) . Since ⋃ α x α(Uα) = S and (d x α)q(R 2 ) = T x α (q)(S) , q ∈ Uα , we have that

$$
\bigcup _ { \alpha } y _ { \alpha } ( U _ { \alpha } \times R ^ { 2 } ) = T ( S ) , \\ \intertext { u n t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y } } \intertext { i t i g h s c r { y
$$

and that veriﬁes condition 1 of Def. 1a. Now let

$$
( p , w ) \in \mathbf y _ { \alpha } ( U _ { \alpha } \times R ^ { 2 } ) \cap \mathbf y _ { \beta } ( U _ { \beta } \times R ^ { 2 } ) .
$$

Then

$$
( p , w ) = ( \mathbf x _ { \alpha } ( q _ { \alpha } ) , d \mathbf x _ { \alpha } ( w _ { \alpha } ) ) = ( \mathbf y _ { \beta } ( q _ { \beta } ) , d \mathbf x _ { \beta } ( w _ { \beta } ) ) ,
$$

where q α ∈ U α , q β ∈ U β , w α ,w β ∈ R 2 . Thus,

$$
y _ { \beta } ^ { - 1 } \circ y _ { \alpha } ( q _ { \alpha } , w _ { \alpha } ) & = y _ { \beta } ^ { - 1 } ( x _ { \alpha } ( q _ { \alpha } ) , d x _ { \alpha } ( w _ { \alpha } ) ) \\ & = ( ( x _ { \beta } ^ { - 1 } \circ x _ { \alpha } ) ( q _ { \alpha } ) , d ( x _ { \beta } ^ { - 1 } \circ x _ { \alpha } ) ( w _ { \alpha } ) ) .
$$

Since x − 1 β ◦ x α is differentiable, so is d( x − 1 β ◦ x α ) . It follows that y − 1 β ◦ y α is differentiable, and that veriﬁes condition 2 of Def. 1a.

The tangent bundle of S is the natural space to work with when one is dealing with second-order differential equations on S . For instance, the equations of a geodesic on a geometric surface S can be written, in a coordinate neighborhood, as (cf. Sec. 4-7)

$$
u ^ { \prime \prime } & = f _ { 1 } ( u , v , u ^ { \prime } , v ^ { \prime } ) , \\ v ^ { \prime \prime } & = f _ { 2 } ( u , v , u ^ { \prime } , v ^ { \prime } ) .
$$

$$
= f _ { 2 } (
$$

The classical “trick” of introducing new variables x = u ′ , y = v ′ to reduce the above to the ﬁrst-order system

$$
x ^ { \prime } & = f _ { 1 } ( u , v , x , y ) , \\ y ^ { \prime } & = f _ { 2 } ( u , v , x , y ) , \\ u ^ { \prime } & = f _ { 3 } ( u , v , x , y ) , \\ v ^ { \prime } & = f _ { 4 } ( u , v , x , y )
$$

[Page 462]

may be interpreted as bringing into consideration the tangent bundle T (S) , with coordinates (u,v,x,y) and as looking upon the geodesics as trajectories of a vector ﬁeld given locally in T (S) by (4). It can be shown that such a vector ﬁeld is well deﬁned in the entire T (S) ; that is, in the intersection of two coordinate neighborhoods, the vector ﬁelds given by (4) agree. This ﬁeld (or rather its trajectories) is called the geodesic ﬂow on T (S) . It is a very natural object to work with when studying global properties of the geodesics on S .

By looking back to Sec. 4-7, it will be noticed that we have used, in a disguised form, the manifold T (S) . Since we were interested only in local properties, wecouldgetalongwithacoordinateneighborhood(whichisessentially an open set of R 4 ). However, even this local work becomes neater when the notion of tangent bundle is brought into consideration.

Of course, we can also deﬁne the tangent bundle of an arbitrary n dimensional manifold. Except for notation, the details are the same and will be left as an exercise.

We can also extend the deﬁnition of a geometric surface to an arbitrary dimension.

DEFINITION 5a. A Riemannian manifold is an n -dimensional differentiable manifold M together with a choice, for each p ∈ M , of an inner product   ,   p in T p ( M ) that varies differentiably with p in the following sense. For some (hence, all) parametrization x α : U α → M with p ∈ x α ( U α ) , the functions

$$
g _ { i j } ( u _ { 1 } \dots , u _ { n } ) = \left \langle \frac { \partial } { \partial u _ { i } } , \frac { \partial } { \partial u _ { j } } \right \rangle , \ \ i , j = 1 , \dots , n ,
$$

are differentiable at x − 1 α ( p ) ; here ( u 1 ,..., u n ) are the coordinates of U α ⊂ R n .

The differentiable family {    p ,p ∈ M } is called a Riemannian structure (or Riemannian metric) for M .

Notice that in the case of surfaces we have used the traditional notation g 11 = E , g 12 = g 21 = F , g 22 = G . The extension of the notions of the intrinsic geometry to Riemannian

manifolds is not so straightforward as in the case of differentiable manifolds.

First, we must deﬁne a notion of covariant derivative for Riemannian manifolds. For this, let x : U → M be a parametrization with coordinates (u 1 ,...,u n ) and set x i = ∂/∂u i . Thus, g ij =   x i , x j   . We want to deﬁne the covariant derivative D w v of a vector ﬁeld v relative

to a vector ﬁeld w . We would like D w v to have the properties we are used to and that have shown themselves to be effective in the past. First, it should have the distributive properties of the old covariant derivative. Thus, if u , v , w are vector ﬁelds on M and f , g are differentiable functions on M , we want

$$
D _ { f u + g w } ( v ) = f D _ { u } v + g D _ { w } v ,
$$

[Page 463]

$$
D _ { u } ( f v + g w ) = f D _ { u } v + \frac { \partial f } { \partial u } v + g D _ { u } w + \frac { \partial g } { \partial u } w ,
$$

where ∂f/∂u , forinstance, isafunctionwhosevalueat p ∈ M isthederivative (f ◦ α) ′ ( 0 ) of the restriction of f to a curve α : ( − ǫ,ǫ) → M , α( 0 ) = p , α ′ ( 0 ) = u . Equations (5) and (6) show that the covariant derivative D is entirely

Equations (5) and (6) show that the covariant derivative D is entirely determined once we know its values on the basis vectors

$$
D _ { x _ { i } } x _ { j } = \sum _ { k = 1 } ^ { n } \Gamma _ { i j } ^ { k } x _ { k } , \quad i , j , k = 1 , \dots , n , \\ \\ \intertext { s c . i . } \intertext { s c . j . } \intertext { d x _ { i } } \intertext { s c . k . }
$$

where the coefﬁcients Ŵ k ij arc functions yet to be determined. k k

Second, we want the Ŵ ij to be symmetric in i and j(Ŵ ij = Ŵ k ji ) ; that is,

$$
D _ { x _ { i } } x _ { j } = D _ { x _ { j } } x _ { i } \ \text { for all } i , j .
$$

Third, we want the law of products to hold; that is,

$$
\frac { \partial } { \partial u _ { k } } \langle x _ { i } , x _ { j } \rangle = \langle D _ { x _ { k } } x _ { i } , x _ { j } \rangle + \langle x _ { i } , D _ { x _ { k } } x _ { j } \rangle .
$$

From Eqs. (7) and (8), it follows that

$$
\frac { \partial } { \partial u _ { k } } \langle x _ { i } x _ { j } \rangle + \frac { \partial } { \partial u _ { i } } \langle x _ { j } , x _ { k } \rangle - \frac { \partial } { \partial u _ { j } } \langle x _ { k } , x _ { i } \rangle = 2 \langle D _ { x _ { i } } x _ { k } , x _ { j } \rangle ,
$$

or, equivalently,

$$
\frac { \partial } { \partial u _ { k } } g _ { i j } + \frac { \partial } { \partial u _ { i } } g _ { j k } - \frac { \partial } { \partial u _ { j } } g _ { k i } = 2 \sum _ { i } \Gamma _ { i k } ^ { i } g _ { i j } . \\ \\
$$

Since det (g ij )  = 0, we can solve the last system, and obtain the Ŵ k ij as functions of the Riemannian metric g ij and its derivatives (the reader should compare the system above with system (2) of Sec. 4-3). If we think of g ij as a matrix and write its inverse as g ij , the solution of the above system is

$$
\Gamma _ { i j } ^ { k } = \frac { 1 } { 2 } \sum _ { l } g ^ { k l } \left ( \frac { \partial g _ { i l } } { \partial u _ { j } } + \frac { \partial g _ { j l } } { \partial u _ { i } } - \frac { \partial g _ { i j } } { \partial u _ { l } } \right ) . \\ \\ \Gamma _ { i j } \colon = \frac { 1 } { 2 } \sum _ { l } g ^ { k l } \left ( \frac { \partial g _ { i l } } { \partial u _ { j } } + \frac { \partial g _ { j l } } { \partial u _ { i } } - \frac { \partial g _ { i j } } { \partial u _ { l } } \right ) . \\ \\ \Gamma _ { i j }
$$

Thus, given a Riemannian structure for M, there exists a unique covariant derivative on M (also called the Levi-Civita connection of the given Riemannian structure) satisfying Eqs. (5)–(8).

Starting from the covariant derivative, we can deﬁne parallel transport, geodesics, geodesic curvature, the exponential map, completeness, etc.

[Page 464]

The deﬁnitions are exactly the same as those we have given previously. The notion of curvature, however, requires more elaboration. The following concept, due to Riemann, is probably the best analogue in Riemannian geometry of the Gaussian curvature.

Let p ∈ M and let σ ⊂ T p (M) be a two-dimensional subspace of the tangent space T p (M) . Consider all those geodesics of M that start from p and are tangent to σ . From the fact that the exponential map is a local diffeomorphism at the origin of T p (M) , it can be shown that small segments of such geodesics make up an abstract surface S containing p . S has a natural geometric structure induced by the Riemannian structure of M . The Gaussian curvature of S at p is called the sectional curvature K(p,σ) of M at p along σ .

It is possibletoformalizethesectionalcurvatureintermsoftheLevi-Civita connection but that is too technical to be described here. We shall only mention that most of the theorems in this chapter can be posed as natural questions in Riemannian geometry. Some of them are true with little or no modiﬁcation of the given proofs. (The Hopf-Rinow theorem, the Bonnet theorem, the ﬁrst Hadamard theorem, and the Jacobi theorems are all in this class.) Some others, however, require further assumptions to hold true (the second Hadamard theorem, for instance) and were seeds for further developments.

A full development of the above ideas would lead us into the realm of Riemannian geometry. We must stop here and refer the reader to the bibliography at the end of the book.

# EXERCISES

- 1. Introduce a metric on the projective plane P 2 (cf. Example 1) so that the natural projection π : S 2 → P 2 is a local isometry. What is the (Gaussian) curvature of such a metric?
- 2. ( The Inﬁnite Möbius Strip .) Let


$$
C = \{ ( x , y , z ) \in R ^ { 3 } ; x ^ { 2 } + y ^ { 2 } = 1 \} \\
$$

be a cylinder and A : C → C be the map (the antipodal map) A(x,y,z) = ( − x, − y, − z) . Let M be the quotient of C by the equivalence relation p ∼ A(p) , and let π : C → M be the map π(p) = { p,A(p) } , p ∈ C . a. Show that can be given a differentiable structure so that is a local

Show that M can be given a differentiable structure so that π is a local diffeomorphism ( M is then called the infinite Möbius strip ).

- b. Prove that M is nonorientable.
- c. Introduce on M a Riemannian metric so that π is a local isometry. What is the curvature of such a metric?


3. a. Show that the projection π : S 2 → P 2 from the sphere onto the projective plane has the following properties: (1) π is continuous and

[Page 465]

π(S 2 ) = P 2 ; (2) each point p ∈ P 2 has a neighborhood U such that π − 1 (U) = V 1 ∪ V 2 , where V 1 and V 2 are disjoint open subsets of S 2 , and the restriction of π to each V i , i = 1 , 2, is a homeomorphism onto U . Thus, π satisﬁes formally the conditions for a covering map (see Sec. 5-6, Def. 1) with two sheets. Because of this, we say that S 2 is an orientable double covering of P 2 .

b. Show that, in this sense, the torus T is an orientable double covering of the Klein bottle K (cf. Example 2) and that the cylinder is an orientable double covering of the inﬁnite Möbius strip (cf. Exercise 2).

4. ( The Orientable Double Covering ). This exercise gives a general construction for the orientable double covering of a nonorientable surface. Let S be an abstract, connected, nonorientable surface. For each p ∈ S , consider the set B of all bases of T p (S) and call two bases equivalent if they are related by a matrix with positive determinant. This is clearly an equivalence relation and divides B into two disjoint sets (cf. Sec. 1-4). Let O p be the quotient space of B by this equivalence relation. O p has two elements, and each element O p ∈ O p is an orientation of T p (S) (cf. Sec. 1-4).Let ˜ S be the set

$$
\tilde { S } = \{ ( p , O _ { p } ) ; p \in S ; O _ { p } \in \mathfrak { D } _ { p } \} .
$$

To give ˜ S a differentiable structure, let { U α , x α } be the maximal differentiable structure of S and deﬁne ˜ x α : U α → ˜ S by

$$
\tilde { \mathbf X } _ { \alpha } ( u _ { \alpha } , v _ { \alpha } ) = \left ( \mathbf X _ { \alpha } ( u _ { \alpha } , v _ { \alpha } ) , \left [ \frac { \partial } { \partial u _ { \alpha } } , \frac { \partial } { \partial v _ { \alpha } } \right ] \right ) ,
$$

where (u α ,v α ) ∈ U α and [ ∂/∂u α ,∂/∂v α ] denotes the element of O p determined by the basis { ∂/∂u α ,∂/∂v α } . Show that a. x is a differentiable structure on and that with such a

{ U α , ˜ α } ˜ S ˜ S differentiable structure is an orientable surface.

b. The map π : ˜ S → S given by π(p,O p ) = p is a differentiable surjective map. Furthermore, each point p ∈ S has a neighborhood U such that π − 1 (U) = V 1 ∪ V 2 , where V 1 and V 2 are disjoint open subsets of ˜ S and π restricted to each V i , i = 1 , 2, is a diffeomorphism onto U . Because of this, ˜ S is called an orientable double covering of S .

5. Extend the Gauss-Bonnet theorem (see Sec. 4-5) to orientable geometric surfaces and apply it to prove the following facts:

a. There is no Riemannian metric on an abstract surface T diffeomorphic to a torus such that its curvature is positive (or negative) at all points of T .

[Page 466]

b. Let T and S 2 be abstract surfaces diffeomorphic to the torus and the sphere, respectively, and let ϕ : T → S 2 be a differentiable map. Then ϕ has at least one critical point, i.e., a point p ∈ T such that det (dϕ p ) = 0. Consider the upper half-plane 2 (cf. Example 3) with the metric

Consider the upper half-plane R 2 + (cf. Example 3) with the metric

$$
E ( x , y ) = 1 , \ \ F ( x , y ) = 0 , \ \ G ( x , y ) = \frac { 1 } { y } , \ \ ( x , y ) \in R _ { + } ^ { 2 } .
$$

Show that the lengths of vectors become arbitrarily large as we approach the boundary of R 2 + and yet the length of the vertical segment

$$
x = 0 , \ \ 0 < \epsilon \leq y \leq 1 , \\ 0 \subsetneq 1 \ 1 \ \ 0 \leq 1 , \quad 0 \colon \colon
$$

approaches 2 as /epsilon1 → 0. Conclude that such a metric is not complete.

*7. Prove that the Poincaré half-plane (cf. Example 3) is a complete geometric surface. Conclude that the hyperbolic plane is complete.

8. Another way of ﬁnding the geodesics of the Poincaré half-plane (cf. Example 3) is to use the Euler-Lagrange equation for the corresponding variational problem (cf. Exercise 4, Sec. 5-4). Since we know that the vertical lines are geodesics, we can restrict ourselves to geodesics of the form y = y(x) . Thus, we must look for the critical points of the integral (F = 0 ) 1 (y ′ ) 2

$$
& \int \sqrt { E + G ( y ^ { \prime } ) ^ { 2 } } \, d x = \int \sqrt { \frac { 1 + ( y ^ { \prime } ) ^ { 2 } } { y } } \, d x , \\ = G = 1 / y ^ { 2 } , \, \text {Use Exercise 4. Sec. 5-4, to show that the}
$$

since E = G = 1 /y 2 . Use Exercise 4, Sec. 5-4, to show that the solution to this variational problem is a family of circles of the form

$$
( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} \\ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 1 } k _ { 1 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } + y ^ { 2 } = k _ { 2 } ^ { 2 } , \ \ k _ { 1 } , k _ { 2 } = \text {const.} } a _ { 2 } k _ { 2 } = 0 , \ \intertext { ( x + k _ { 1 } ) ^ { 2 } +
$$

9. Let ˜ S and S be connected geometric surfaces and let π : ˜ S → S be a surjective differentiable map with the following property: For each p ∈ S , there exists a neighborhood U of p such that π − 1 (U) =   α V α , where the V α ’s are open disjoint subsets of ˜ S and π restricted to each V α is an isometry onto U (thus, π is essentially a covering map and a local isometry).

Prove that S is complete if and only if ˜ S is complete.

Is the metric on the infinite Möbius strip, introduced in Exercise 2, part c, a complete metric?

10. ( Kazdan-Wamer’s Results .)

a. Let a metric on R 2 be given by

$$
E ( x , y ) = 1 , \ \ F ( x , y ) = 0 , \ \ G ( x , y ) > 0 , \ \ ( x , y ) \in R ^ { 2 } .
$$

[Page 467]

Show that the curvature of this metric is given by

$$
\frac { \partial ^ { 2 } ( \sqrt { G } ) } { \partial x ^ { 2 } } + K ( x , y ) \sqrt { G } = 0 . \quad ( * )
$$

b. Conversely, given a function K(x,y) on R 2 , regard y as a parameter and let √ G be the solution of ( ∗ ) with the initial conditions

$$
\sqrt { G } ( x _ { 0 } , y ) = 1 , \quad \frac { \partial \sqrt { G } } { \partial x } ( x _ { 0 } , y ) = 0 .
$$

Prove that G is positive in a neighborhood of (x 0 ,y) and thus deﬁnes a metric in this neighborhood. This shows that every differentiable function is locally the curvature of some (abstract) metric .

*c. Assume that K(x,y) ≤ 0 for all (x,y) ∈ R 2 . Show that the solution of part b satisﬁes

$$
\sqrt { G ( x , y ) } \geq \sqrt { G ( x _ { 0 } , y ) } = 1 \quad \text {for all } x . \\ G ( x , y ) \text { defines a metric on all of } R ^ { 2 } . \, \text {Prove also that this}
$$

Thus, G(x,y) deﬁnes a metric on all of R 2 . Prove also that this metric is complete. This shows that any nonpositive differentiable function on R 2 isthecurvatureofsomecompletemetricon R 2 . Ifwedonotinsist on the metric being complete, the result is true for any differentiable function K on R 2 . Compare J. Kazdan and F. Warner, “Curvature Functions for Open 2-Manifolds,” Ann. of Math. 99 (1974), 203–219, where it is also proved that the condition on K given in Exercise 2 of Sec. 5-4 is necessary and sufﬁcient for the metric to be complete.

# 5-11. Hilbert’s Theorem

Hilbert’s theorem can be stated as follows.

THEOREM. A complete geometric surface S with constant negative curvature cannot be isometrically immersed in R 3 .

Remark 1. Hilbert’s theorem was ﬁrst treated in D. Hilbert, “Über Flächen von konstanter Gausscher Krümung,” Trans. Amer. Math. Soc. 2 (1901), 87–99. A different proof was given shortly after by E. Holmgren, “Sur les surfaces à courbure constante negative,” C. R. Acad. Sci. Paris 134 (1902), 740–743. The proof we shall present here follows Hilbert’s original ideas. The local part is essentially the same as in Hilbert’s paper; the global part, however, is substantially different. We want to thank J. A. Scheinkman for helping us to work out this proof.

[Page 468]

We shall start with some observations. By multiplying the inner product by a constant factor, we may assume that the curvature K ≡ − 1. Moreover, since exp p : T p (S) → S is a local diffeomorphism (corollary of the theorem of Sec. 5-5), it induces an inner product in T p (S) . Denote by S ′ the geometric surface T p (S) withthisinnerproduct. If ψ : S → R 3 isanisometricimmersion, the same holds for ϕ = ψ ◦ exp p : S ′ → R 3 . Thus, we are reduced to proving that there exists no isometric immersion ϕ : S ′ − R 3 of a plane S ′ with an inner product such that K ≡ − 1.

# LEMMA 1. The area of S ′ is inﬁnite.

Proof . We shall prove that S ′ is (globally) isometric to the hyperbolic plane H . Since the area of the latter is (cf. Example 3, Sec. 5-10)

$$
\int _ { - \infty } ^ { + \infty } \int _ { - \infty } ^ { + \infty } e ^ { u } \, d u \, d v = \infty ,
$$

this will prove the lemma.

Let p ∈ H , p ′ ∈ S ′ , and choose a linear isometry ψ : T p (H) → T p ′ (S ′ ) between their tangent spaces. Deﬁne a map ϕ : H → S ′ by ϕ = exp p ◦ ψ ◦ exp − 1 p . Since each point of H is joined to p by a unique minimal geodesic, ϕ is well deﬁned.

We now use polar coordinates (p,θ) and (p ′ ,θ ′ ) around p and p ′ , respectively, requiring that ϕ maps the axis θ = 0 into the axis θ ′ = 0. By the results of Sec. 4-6, ϕ preserves the ﬁrst fundamental form; hence, it is locally an isometry. By using the remark made after Hadamard’s theorem, we conclude that ϕ is a covering map. Since S ′ is simply connected, ϕ is a homeomorphism, and hence a (global) isometry. Q.E.D.

For the rest of this section we shall assume that there exists an isometric immersion ϕ : S ′ → R 3 , where S ′ is a geometric surface homeomorphic to a plane and with K ≡ − 1. Toavoidthedifﬁcultiesassociatedwithpossibleself-intersectionsof ϕ(S ′ ) ,

we shall work with S ′ and use the immersion ϕ to induce on S ′ the local extrinsic geometry of ϕ(S ′ ) ⊂ R 3 . More precisely, since ϕ is an immersion, for each p ∈ S ′ there exists a neighborhood V ′ ⊂ S ′ of p such that the restriction ϕ | V ′ = ˜ ϕ is a diffeomorphism. At each ˜ ϕ(q) ∈ ˜ ϕ(V ′ ) , there exist, for instance, two asymptotic directions. Through ˜ ϕ , these directions induce two directions at q ∈ S ′ , which will be called the asymptotic directions on S ′ at q . In this way, it makes sense to talk about asymptotic curves on S ′ , and the same procedure can be applied to any other local entity of ϕ(S ′ ) .

We now recall that the coordinate curves of a parametrization constitute a Tchebyshef net if the opposite sides of any quadrilateral formed by them have equal length (cf. Exercise 7, Sec. 2-5). If this is the case, it is possible to reparametrize the coordinate neighborhood in such a way that E = 1,

[Page 469]

LEMMA 2. For each p ∈ S ′ there is a parametrization x : U ⊂ R 2 → S ′ , p ∈ x ( U ) , such that the coordinate curves of x are the asymptotic curves of x ( U ) = V ′ and form a Tchebyshef net (we shall express this by saying that the asymptotic curves of V ′ form a Tchebyshef net) .

Proof . Since K < 0, a neighborhood V ′ ⊂ S ′ of p can be parametrized by x (u,v) in such a way that the coordinate curves of x are the asymptotic curves of V ′ . Thus, if e , f , and g are the coefﬁcients of the second fundamental form of S ′ in this parametrization, we have e = g = 0. Notice that we are using the above convention of referring to the second fundamental form of S ′ rather than the second fundamental form of ϕ(S ′ ) ⊂ R 3 . Now ϕ(V ′ ) ⊂ R 3 , we have

Now ϕ(V ′ ) ⊂ R 3 , we have

$$
N _ { u } \wedge N _ { v } = K ( \mathbf x _ { u } \wedge \mathbf x _ { v } ) ;
$$

u ∧ hence, setting D = √ EG − F 2 ,

$$
( N \wedge N _ { v } ) _ { u } - ( N \wedge N _ { u } ) _ { v } = 2 ( N _ { u } \wedge N _ { v } ) = 2 K D N .
$$

Furthermore,

$$
N \wedge N _ { u } & = \frac { 1 } { D } \{ ( x _ { u } \wedge x _ { v } ) \wedge N _ { u } \} = \frac { 1 } { D } \{ \langle x _ { u } , N _ { u } \rangle x _ { v } - \langle x _ { v } , N _ { u } \rangle x _ { u } \} \\ & = \frac { 1 } { D } ( f x _ { u } - e x _ { v } ) ,
$$

and, similarly,

$$
N \wedge N _ { v } = \frac { 1 } { D } ( g x _ { u } - f x _ { v } ) .
$$

Since K = − 1 = − (f 2 /D 2 ) and e = g = 0, we obtain

$$
N \wedge N _ { u } = \pm { x } _ { u } , \ \ N \wedge N _ { v } = \pm { x } _ { v } ;
$$

hence Proof . Let ( ¯ u, ¯ v) be the coordinates of V ′ . By the argument of Lemma 2 the coordinate curves form a Tchebysbef net. Thus, it is possible to reparametrize V ′ by, say, (u, v) so that E = G = 1 and F = cos θ . Let R be a quadrilateral that is formed by the coordinate curves with vertices (u 1 , v 1 ), (u 2 , v 1 ), (u 2 , v 2 ), (u 1 , v 2 ) and interior angles α 1 , α 2 , α 3 , α 4 , respectively (Fig. 5-54). Since E = G = 1, F = cos θ , and θuv = sin θ , we obtain

$$
2 K D N = - 2 D N = \pm { x } _ { u v } \pm { x } _ { v u } = \pm 2 { x } _ { u v } .
$$

It follows that x uv is parallel to N ; hence, E v = 2   x uv , x u   = 0 and G u = 2   x uv , x v   = 0. But E v = G u = 0 implies (Sec. 2-5, Exercise 7) that the coordinate curves form a Tchebysbef net. Q.E.D.

LEMMA 3. Let V ′ ⊂ S ′ be a coordinate neighborhood of S ′ such that the coordinate curves are the asymptotic curves in V ′ . Then the area A of any quadrilateral formed by the coordinate curves is smaller than 2 π .

[Page 470]

$$
A & = \int _ { R } d A = \int _ { R } \sin \theta \, d u \, d v = \int _ { R } \theta _ { u v } \, d u \, d v \\ & = \theta ( u _ { 1 } , v _ { 1 } ) - \theta ( u _ { 2 } , v _ { 1 } ) \theta + \theta ( u _ { 2 } , v _ { 2 } ) - \theta ( u _ { 1 } , v _ { 2 } ) \\ & = \alpha _ { 1 } + \alpha _ { 3 } - ( \pi - \alpha _ { 2 } ) - ( \pi - \alpha _ { 4 } ) = \sum _ { i = 1 } ^ { 4 } \alpha _ { i } - 2 \pi < 2 \pi ,
$$

$$
= \alpha _ { 1 } + \alpha _ { 3 } - ( \pi - \alpha _ { 2 } ) - ( \pi - \alpha _ { 4 } ) = \sum _ { i = 1 } ^ { 4 } \alpha _ { i } - 2 \pi \, < 2 \pi , \\ \text {since } \alpha _ { i } < \pi .
$$

=

u

u

![The image is a geometric figure, specifically a diagram of a parallelogram. The diagram consists of a parallelogram with vertices labeled as A, B, C, and D. The vertices are connected by lines, forming a right angle at vertex A. The parallelogram is oriented such that the diagonals of the parallelogram bisect each other at right angles. The diagram is labeled as follows: - A is the top-left vertex of the parallelogram. - B is the top-right vertex of the parallelogram. - C is the bottom-left vertex of the parallelogram. - D is the bottom-right vertex of the parallelogram. The diagonals of the parallelogram are labeled as follows: - A: Line segment AB - B: Line segment BC - C: Line segment CD - D: Line segment AD The diagram is drawn with a straight line, which](<images/imageFile82.png>)

=

u

u

1

2

(

,

)

u

v

(

,

)

1

2

u

v

2

2

a

=

v

v

a

3

2

4

R

a

a

1

2

=

v

v

1

(

(

,

)

,

)

u

u

v

v

1

1

2

1

Figure 5-54

So far the considerations have been local. We shall now deﬁne a map x : R 2 → S ′ and show that x is a parametrization for the entire S ′ . The map x is deﬁned as follows (Fig. 5-55). Fix a point O ∈ S ′ and choose

orientations on the asymptotic curves passing through O . Make a deﬁnite choice of one of these asymptotic curves, to be called a 1 , and denote the other oneby a 2 . Foreach (s,t) ∈ R 2 , layoffon a 1 alengthequalto s startingfrom O . Let p ′ bethepointthusobtained. Through p ′ therepasstwoasymptoticcurves, one of which is a 1 . Choose the other one and give it the orientation obtained by the continuous extension, along a 1 , of the orientation of a 2 . Over this oriented asymptotic curve lay off a length equal to t starting from p ′ . The point so obtained is x (s,t) . 2

x (s,t) is well deﬁned for all (s,t) ∈ R . In fact, if x (s, 0 ) is not deﬁned, there exists s 1 such that a 1 (s) is deﬁned for all s < s 1 but not for s = s 1 . Let q = lim s → s 1 a 1 (s) . By completeness, q ∈ S ′ . By using Lemma 2, we see that a 1 (s 1 ) is deﬁned, which is a contradiction and shows that x (s, 0 ) is

[Page 471]

![The image presents a diagram involving a right triangle, labeled as \( \triangle ABC \). The diagram includes two points labeled \( \alpha \) and \( \beta \) on the right side of the triangle. The diagram is labeled as \( \triangle ABC \). The diagram consists of two lines, \( \alpha \) and \( \beta \), which are parallel to each other. The line \( \alpha \) is drawn from \( \alpha \) to the right side of the triangle, while the line \( \beta \) is drawn from \( \beta \) to the left side of the triangle. The diagram also includes two points labeled \( \gamma \) and \( \chi \) on the right side of the triangle. The diagram is labeled as \( \triangle ABC \). The diagram is labeled as \( \triangle ABC \).](<images/imageFile83.png>)

(

,

)

x

s

t

t

a

2

a

p

1

1

0

Figure 5-55

s

t ∈ R Now we must show that x is a parametrization of S ′ . This will be done through a series of lemmas.

LEMMA 4. For a ﬁxed t , the curve x ( s , t ) , −∞ < s < ∞ , is an asymptotic curve with s as arc length.

Proof . For each point x (s ′ ,t ′ ) ∈ S ′ , there exists by Lemma 2 a “rectangular” neighborhood (that is, of the form t a < t < t b , s a < s < s b ) such that the asymptotic curves of this neighborhood form a Tchebyshef net. We ﬁrst remark that if for some t 0 ,t a < t 0 < t b , the curve x (s,t 0 ) , s a < s < s b , is an asymptotic curve, then we know the same holds for every curve x (s, ¯ t) , t a < ¯ t < t b . In fact, the point x (s, ¯ t) is obtained by laying off a segment of length ¯ t from x (s, 0 ) which is equivalent to laying off a segment of length ¯ t − t 0 from x (s,t 0 ) . Since the asymptotic curves form a Tchebyshef net in this neighborhood, the assertion follows.

Now, let x (s 1 ,t 1 ) ∈ S ′ be an arbitrary point. By compactness of the segment x (s 1 ,t) , 0 ≤ t ≤ t 1 , it is possible to cover it by a ﬁnite number of rectangular neighborhoods such that the asymptotic curves of each of them form a Tchebyshef net (Fig. 5-56). Since x (s, 0 ) is an asymptotic curve, we iterate the previous remark and show that x (s,t 1 ) is an asymptotic curve in a neighborhood of s 1 . Since (s 1 ,t 1 ) was arbitrary, the assertion of the lemma follows. Q.E.D.

# LEMMA 5. x is a local diffeomorphism.

Proof . This follows from the fact that on the one hand x (s 0 ,t) , x (s,t 0 ) are asymptotic curves parametrized by arc length, and on the other hand S ′ can be locally parametrized in such a way thai the coordinate curves are the asymptotic curves of S ′ and E = G = 1. Thus, x agrees locally with such a parametrization. Q.E.D.

[Page 472]

(

,

)

![In this image, we can see a diagram with a graph. The graph is labeled as \( x \) and \( y \).](<images/imageFile84.png>)

s

t

x

1

1

0

a

1

Figure 5-56

LEMMA 6. x is surjective.

Proof . Let Q = x (R 2 ) . Since x is a local diffeomorphism, Q is open in S ′ . We also remark that if p ′ = x (s 0 ,t 0 ) , then the two asymptotic curves which pass through p ′ are entirely contained in Q .

Let us assume that Q  = S ′ . Since S ′ is connected, the boundary Bd Q  = φ . Let p ∈ Bd Q . Since Q is open in S ′ , p / ∈ Q . Now consider a rectangular neighborhood R of p in which the asymptotic curves form a Tchebyshef net (Fig. 5-57). Let q ∈ Q ∩ R . Then one of the asymptotic curves through q intersects one of the asymptotic curves through p . By the above remark, this is a contradiction. Q.E.D.

![image 85](<images/imageFile85.png>)

q

Q

p

R

Figure 5-57

We now claim that x is a global diffeomorphism. Since x is a surjective local diffeomorphism, it sufﬁces to show x has the property of lifting arcs and apply Prop. 6 of Sec. 5-6 (Covering Spaces ... ) to conclude that x is a covering map. Since R 2 is simply connected, this will prove our claim.

To show that x has the property of lifting arcs we use a Proposition that is presented here without proof (For a proof, see Elon Lima, Fundamental Groups and Covering Spaces, A K Peters, Natick, Massachusetts, see p. 144): ... Let x : R 2 → S ′ be a surjective local diffeomorphism. Assume that x is a closed map (i.e., the image of a closed set is closed). Then x has the property of lifting arcs . That x is closed follows from the way it is deﬁned.

This completes the proof of our claim.

[Page 473]

The proof of Hilbert’s theorem now follows easily.

Proof of the Theorem . Assume the existence of an isometric immersion ψ : S → R 3 , where S is a complete surface with K ≡ − 1. Let p ∈ S and denote by S ′ the tangent plane T p (S) endowed with the metric induced by exp p : T p (S) → S . Then ϕ = ψ ◦ exp p : S ′ → R 3 is an isometric immersion and Lemmas 5 and 6 plus the text after them show the existence of a parametrization x : R 2 → S ′ of the entire S ′ such that the coordinate curves of x are the asymptotic curves of S ′ (Lemma 4). Thus, we can cover S ′ by a union of “coordinate quadrilaterals” Q n , with Q n ⊂ Q n + 1 . By Lemma 3, the area of each Q n is smaller than 2 π . On the other hand, by Lemma 1, the area of S ′ is unbounded. This is a contradiction and concludes the proof. Q.E.D.

Remark 2. Hilbert’s theorem was generalized by N. V. Eﬁmov, “Appearance of Singularities on Surfaces of Negative Curvature,” Math. Sb. 106 (1954). A.M.S. Translations. Series 2, Vol. 66, 1968, 154–190, who proved the following conjecture of Cohn-Vossen: Let S be a complete surface with curvature K satisfying K ≤ δ < 0. Then there exists no isometric immersion of S into R 3 . Eﬁmov’s proof is very long, and a shorter proof would be desirable.

An excellent exposition of Eﬁmov’s proof can be found in a paper by T. Klotz Milnor, “Eﬁmov’s Theorem About Complete Immersed Surfaces of NegativeCurvature,” AdvancesinMathematics 8(1972), 474–543. Thispaper also contains another proof of Hilbert’s theorem which holds for surfaces of class C 2 .

For further details on immersion of the hyperbolic plane see M. L. Cromov and V. A. Rokblin, “Embeddings and Immersions in Riemannian Geometry,” Russian Math. Sureys (1970), 1–57, especially p. 15.

# EXERCISES

1. ( Stoke’s Remark. ) Let S be a complete geometric surface. Assume that the Gaussian curvature K satisﬁes K ≤ δ < 0. Show that there is no isometric immersion ϕ : S → R 3 such that the absolute value of the mean curvature H is bounded. This proves Eﬁmov’s theorem quoted in Remark 2 with the additional condition on the mean curvature. The following outline may be useful:

a. Assume such a ϕ exists and consider the Gauss map N : ϕ(S) ⊂ R 3 → S 2 , where S 2 is the unit sphere. Since K  = 0 everywhere, N induces a newmetric(, ) on S byrequiringthat N ◦ ϕ : S → S 2 bealocalisometry. Choosecoordinateson S sothattheimagesby ϕ ofthecoordinatecurves are lines of curvature of ϕ(S) . Show that the coefﬁcients of the new metric in this coordinate system are

$$
g _ { 1 1 } = ( k _ { 1 } ) ^ { 2 } E , \ \ g _ { 1 2 } = 0 , \ \ g _ { 2 2 } = ( k _ { 2 } ) ^ { 2 } G ,
$$

[Page 474]

where E,F( = 0 ) , and G are the coefﬁcients of the initial metric in the same system.

- b. Show that there exists a constant M > 0 such that k 2 1 < M , k 2 2 < M . Use the fact that the initial metric is complete to conclude that the new metric is also complete.
- c. Use part b to show that S is compact; hence, it has points with positive curvature, a contradiction.


2. The goal of this exercise is to prove that there is no regular complete surface of revolution S in R 3 with K ≤ δ < 0 (this proves Eﬁmov’s theorem for surfaces of revolution). Assume the existence of such an S ⊂ R 3 . a. Prove that the only possible forms for the generating curve of are

S those in Fig. 5-58(a) and (b), where the meridian curve goes to inﬁnity in both directions. Notice that in Fig. 5-58(b) the lower part of the meridian is asymptotic to the z axis.

b. Parametrize the generating curve (ϕ(s),ψ(s)) by arc length s ∈ R so that ψ( 0 ) = 0. Use the relations ϕ ′′ + Kϕ = 0 (cf. Example 4, Sec. 3-3, Eq. (9)) and K ≤ δ < 0 to conclude that there exists a point s 0 ∈ [0 , +∞ ) such that (ϕ ′ (s 0 )) 2 = 1 . c. Show that each of the three possibilities to continue the meridian

(ϕ(s),ψ(s)) of S past the point p 0 = (ϕ(s 0 ),ψ(s 0 )) (described in Fig. 5-58(c) as I, II, and III) leads to a contradiction. Thus, S is not complete.

3. ( T.K.Milnor’sProofofHilbert’sTheorem. ) Let S beaplanewithacomplete metric g 1 such that its curvature K ≡ − 1. Assume that there exists an

z

![In this image, we can see a diagram with a diagram of a circle and a diagram of a line. We can also see a diagram of a circle and a diagram of a line.](<images/imageFile86.png>)

z

z

III

II

p

0

I

= 0

= 0

s

s

y

y

y

0

0

0

(a)

(b)

(c)

Figure 5-58

[Page 475]

isometric immersion ϕ : S → R 3 . To obtain a contradiction, proceed as follows:

a. ConsidertheGaussmap N : ϕ(S) ⊂ R 3 → S 2 and let g 2 bethemetricon S obtained by requiring that N ◦ ϕ : S → S 2 be a local isometry. Choose local coordinates on S so that the images by ϕ of the coordinate curves are the asymptotic curves of ϕ(S) . Show that, in such a coordinate system, g 1 can be written as

$$
d u ^ { 2 } + 2 \cos \theta \, d u \, d v + d v ^ { 2 }
$$

and that g 2 can be written as

$$
d u ^ { 2 } - 2 \cos \theta \, d u \, d v + d v ^ { 2 } .
$$

- b. Prove that g 3 = 1 2 (g 1 + g 2 ) is a metric on S with vanishing curvature. Use the fact that g 1 is a complete metric and 3 g 3 ≥ g 1 to conclude that the metric g 3 is complete.
- c. Prove that the plane with the metric g 3 is globally isometric to the standard (Euclidean) plane R 2 . Thus, there is an isometry ϕ : S → R 2 . Prove further that ϕ maps the asymptotic curves of S , parametrized by arclength, intoarectangularsystemofstraightlinesin R 2 , parametrized by arc length.
- d. Use the global coordinate system on S given by part c, and obtain a contradiction as in the proof of Hilbert’s theorem in the text.


[Page 476]

# Appendix Point-Set Topology of Euclidean Spaces

In Chap. 5 we have used more freely some elementary topological properties of R n . The usual properties of compact and connected subsets of R n , as they appear in courses of advanced calculus, are essentially all that is needed. For completeness, we shall make a brief presentation of this material here, with proofs. We shall assume the material of the appendix to Chap. 2, Part A, and the basic properties of real numbers.

# A. Preliminaries

Here we shall complete in some points the material of the appendix to Chap. 2, Part A. n n

In what follows U ⊂ R will denote an open set in R . The index i varies in the range 1 , 2 ,...,m,..., and if p = (x 1 ,...,x n ) , q = (y 1 ,...,y n ) , | p − q | will denote the distance from p to q ; that is,

$$
| p - q | ^ { 2 } = \sum _ { j } ( x _ { j } - y _ { j } ) ^ { 2 } , \ \ j = 1 , \dots , n .
$$

DEFINITION 1. A sequence p 1 ,..., p i ,... ∈ R n converges to p 0 ∈ R n if given ǫ > 0 , there exists an index i 0 of the sequence such that p 1 ∈ B ǫ ( p 0 ) for all i > i 0 . In this situation, p 0 is the limit of the sequence { p 1 } , and this is denoted by { p i } → p 0 .

Convergence is related to continuity by the following proposition.

PROPOSITION 1. A map F: U ⊂ R n → F m is continuous at p 0 ∈ U if and only if for each converging sequence { p i } → p 0 in U , the sequence { F ( p i ) } converges to F ( p 0 ) .

[Page 477]

Proof . Assume F to be continuous at p 0 and let ǫ > 0 be given. By continuity, there exists δ > 0 such that F(B δ (p 0 )) ⊂ B ǫ (F(p 0 )) . Let { p 1 } be a sequence in U , with { p i } → p 0 ∈ U . Then there exists in correspondence with δ an index i 0 such that p i ∈ B δ (p 0 ) for i > i 0 . Thus, for i > i 0 ,

$$
F ( p _ { i } ) \in F ( B _ { \delta } ( p _ { 0 } ) ) \subset B _ { \epsilon } ( F ( p _ { 0 } ) ) ,
$$

which implies that { F(p 1 ) } → F(p 0 ) . Suppose now that F is not continuous

at p 0 . Then there exists a number ǫ > 0 such that for every δ > 0 can ﬁnd a point p ∈ B δ (p 0 ) , with F(p) / ∈ B ǫ (F(p 0 )) . Fix this ǫ , and set δ = 1 , 1 / 2 ,..., 1 /i,... , thus obtaining a sequence { p i } which converges to p 0 . However, since F(p i ) / ∈ B ǫ (F(p 0 )) , the sequence { F(p i ) } does not converge to F(p 0 ) . Q.E.D. n n

DEFINITION 2. A point p ∈ R is a limit point of a set A ⊂ R if every neighborhood of p in R n contains one point of A distinct from p .

To avoid some confusion with the notion of limit of a sequence, a limit point is sometimes called a cluster point or an accumulation point.

Deﬁnition2isequivalenttosayingthateveryneighborhood V of p contains inﬁnitely many points of A . In fact, let q 1  = p be the point of A given by the deﬁnition, and consider a ball B ǫ (p) ⊂ V so that q 1 / ∈ B ǫ (p) . Then there is a point q 2  = p , q 2 ∈ A ∩ B ǫ (p) . By repeating this process, we obtain a sequence { q i } in V , where the q 1 ∈ A are all distinct. Since { q t } → p , the argument also shows that p is a limit point of A if and only if p is the limit of some sequence of distinct points in A .

Example 1. The sequence 1 , 1 / 2 , 1 / 3 ,..., 1 /i,... converges to 0. The sequence 3 / 2 , 4 / 3 ,... , i + 1 /i,... converges to 1. The “intertwined” sequence 1 , 3 / 2 , 1 / 2 , 4 / 3 , 1 / 3 ,...,, 1 + ( 1 /i), 1 /i,... does not converge and has two limit points, namely 0 and 1 (Fig. A5-l).

1

3

1

1

4

![image 87](<images/imageFile87.png>)

0

4

2

2

3

2

1

3

Figure A5-1

It should be observed that the limit p 0 of a converging sequence has the property that any neighborhood of p 0 contains all but a ﬁnite number of points of the sequence, whereas a limit point p of a set has the weaker property that any neighborhood of p contains inﬁnitely many points of the set. Thus, a sequence which contains no constant subsequence is convergent if and only if, as a set, it contains only one limit point.

Aninterestingexampleisgivenbytherationalnumbers Q . Itcanbeproved that Q is countable; that is, it can be made into a sequence. Since arbitrarily

[Page 478]

DEFINITION 3. A set F ⊂ R n is closed if every limit point of F belongs to F . The closure of A ⊂ R n denoted by ¯ A , is the union of A with its limit points.

Intuitively, F is closed if it contains the limit of all its convergent sequences, or, in other words, it is invariant under the operation of passing to the limit.

It is obvious that the closure of a set is a closed set. It is convenient to make the convention that the empty set φ is both open and closed.

There is a very simple relation between open and closed sets.

PROPOSITION 2. F ⊂ R n is closed if and only if the complement R n − F of F is open.

Proof . Assume F to be closed and let p ∈ R n − F . Since p is not a limit point of F , there exists a ball B ǫ (p) which contains no points of F . Thus, B ǫ ⊂ R n − F ; hence R n − F is open. Conversely, supposethat R n − F isopenandthat p isalimitpointof F . We

want to prove that p ∈ F . Assume the contrary. Then there is a ball B ǫ (p) ⊂ R n − F . This implies that B ǫ (p) contains no point of F and contradicts the fact that p is a limit point of F . Q.E.D.

Continuity can also be expressed in terms of closed sets, which is a consequence of the following fact.

PROPOSITION 3. A map F: U ⊂ R n → R m is continuous if and only if for each open set V ⊂ R m , F − 1 ( V ) is an open set. m m

Proof . Assume F to be continuous and let V ⊂ R be an open set in R . If F − 1 (V ) = φ , there is nothing to prove, since we have set the convention that the empty set is open. If F − 1 (V )  = φ , let p ∈ F − 1 (V ) . Then F(p) ∈ V , and since V is open, there exists a ball B ǫ (F(p)) ⊂ V . By continuity of F , there exists a ball B δ (p) such that

$$
F ( B _ { \delta } ( p ) ) \subset B _ { \epsilon } ( F ( p ) ) \subset V .
$$

Thus, Bδ(p) ⊂ F -1 (V ) ; hence, F -1 (V ) is open.

open set V ⊂ R m . Let p ∈ U and ǫ > 0 be given. Then A = F − 1 (B ǫ (F(p))) is open. Thus, there exists δ > 0 such that B δ (p) ⊂ A . Therefore,

$$
F ( B _ { \delta } ( p ) ) \subset F ( A ) \subset B _ { \epsilon } ( F ( p ) ) ;
$$

[Page 479]

COROLLARY. F: U ⊂ R n → R m is continuous if and only if for every closed set A ⊂ R m , F − 1 ( A ) is a closed set.

Example 2. Proposition 3 and its corollary give what is probably the best way of describing open and closed subsets of R n . For instance, let f : R 2 → R be given by f (x,y) = (x 2 /a 2 ) − (y 2 /b 2 ) − 1. Observe that f is continuous, 0 ∈ R is a closed set in R , and ( 0 , +∞ ) is an open set in R . Thus, the set

$$
F _ { 1 } = \{ ( x , y ) ; \, f ( x , y ) = 0 \} = f ^ { - 1 } ( 0 )
$$

is closed in R 2 , and the sets

$$
0 \} ,
$$

$$
U _ { 1 } & = \{ ( x , y ) ; \, f ( x , y ) > 0 \} , \\ U _ { 2 } & = \{ ( x , y ) ; \, f ( x , y ) < 0 \} \\
$$

are open in R 2 . On the other hand, the set

$$
A & = \{ ( x , y ) \in R ^ { 2 } , x ^ { 2 } + y ^ { 2 } < 1 \} \\ & \quad \cup \{ ( x , y ) \in R ^ { 2 } ; x ^ { 2 } + y ^ { 2 } = 1 , x > 0 , y > 0 \} \\
$$

is neither open nor closed (Fig. A5-2).

![The image depicts a geometric figure with four labeled sides and four angles. The figure is a right triangle, as indicated by the right angle at the top. The sides of the triangle are labeled as follows: 1. The hypotenuse (the side opposite the right angle) is labeled as u. 2. The side opposite the right angle (the side opposite the right angle) is labeled as u. 3. The side adjacent to the right angle (the side adjacent to the right angle) is labeled as u. 4. The side opposite the angle (the angle) is labeled as u. 5. The angle opposite the right angle (the angle) is labeled as F. 6. The angle opposite the left angle (the angle) is labeled as F. 7. The angle opposite the right angle (the angle) is labeled as F. 8. The angle opposite the left angle (the angle) is labeled](<images/imageFile88.png>)

F

F

1

1

U

2

U

U

1

1

Figure A5-2

![image 89](<images/imageFile89.png>)

A

The last example suggests the following deﬁnition.

DEFINITION 4. Let A ⊂ R n . The boundary Bd A of A is the set of points p in R n such that every neighborhood of p contains points in A and points in R n − A . 2 2

Thus, if A is the set of Example 2, Bd A is the circle x + y = 1. Clearly, A ⊂ R n is open if and only if no point of Bd A belongs to A , and B ⊂ R n is closed if and only if all points of Bd B belong to B .

[Page 480]

Now we want to recall a basic property of the real numbers. We need some deﬁnitions.

DEFINITION 5. A subset A ⊂ R of the real line R is bounded above if there exists M ∈ R such that M ≥ a for all a ∈ A . The number M is called an upper bound for A . When A is bounded above, a supremum or a least upper bound of A , sup A (or l.u.b. A ) is an upper bound M which satisﬁes the following condition: Given ǫ > 0 , there exists a ∈ A such that M − ǫ < a . By changing the sign of the above inequalities, we deﬁne similarly a lower bound for A and an inﬁmum (or a greatest lower bound ) of A , inf A (or g.l.b. A ).

AXIOM OF COMPLETENESS OF REALNUMBERS. Let A ⊂ R be nonempty and bounded above (below). Then there exists supA (inf A ).

There are several equivalent ways of expressing the basic property of completeness of the real-number system. We have chosen the above, which, although not the most intuitive, is probably the most effective one.

It is convenient to set the following convention. If A ⊂ R is not bounded above (below), we say that sup A = +∞ (inf A = −∞ ). With this convention the above axiom can be stated as follows: Every nonempty set of real numbers has a sup and an inf.

Example 3. The sup of the set ( 0 , 1 ) is 1, which does not belong to the set. The sup of the set

$$
B & = \{ x \in R ; 0 < x < 1 \} \cup \{ 2 \} \\ \\
$$

is 2. The point 2 is an isolated point of B ; that is, it belongs to B but is not a limit point of B . Observe that the greatest limit point of B is 1, which is not sup B . However, if a bounded set has no isolated points, its sup is certainly a limit point of the set.

One important consequence of the completeness of the real numbers is the following “intrinsic” characterization of convergence, which is actually equivalent to completeness (however, we shall not prove that).

LEMMA 1. Call a sequence { x i } of real numbers a Cauchy sequence if given ǫ > 0 , there exists i 0 such that | x i , x j | < ǫ for all i , j > i 0 . A sequence is convergent if and only if it is a Cauchy sequence.

Proof . Let { x i } → x 0 . Then, if ǫ > 0 is given, there exists i 0 such that | x i − x 0 | < ǫ/ 2 for i > i 0 . Thus, for i,j > i 0 , we have

$$
| x _ { i } - x _ { j } | \leq | x _ { i } - x _ { 0 } | + | x _ { j } - x _ { 0 } | < \epsilon ; \\
$$

hence, { x i } is a Cauchy sequence. Conversely, let { x i }

Conversely, let { xi } be a Cauchy sequence. The set { xi } is clearly a bounded set. Let a 1 = inf { x } , b 1 = sup { xi } . Either, one of these points is a limit point of { xi } and then { xi } converges to this point, or both are isolated points of the set { xi } . In the latter case, consider the set of points in the open interval (a 1 , b 1 ) , and let a 2 and b 2 be its inf and sup, respectively. Proceeding in this way, we obtain that either { xi } converges or there are two bounded sequences a 1 < a 2 < · · · and b 1 > b 2 > · · · . Let a = sup { ai } and b = inf { bi } . Since { xi } is a Cauchy sequence, a = b , and this common value x 0 is the unique limit point of { xi } . Thus, { xi } → x 0 . Q.E.D.

[Page 481]

This form of completeness extends naturally to Euclidean spaces.

DEFINITION 6. A sequence { p i } , p i ∈ R n , is a Cauchy sequence if given ǫ > 0 , there exists an index i 0 such that the distance | p i − p j | < ǫ for all i , j > i 0 .

PROPOSITION 4. A sequence { p i } , p i ∈ R n , converges if and only if it is a Cauchy sequence.

Proof . A convergent sequence is clearly a Cauchy sequence (see the argument in Lemma 1). Conversely, let { p i } be a Cauchy sequence, and consider its projection on the j axis of R n , j = 1 ,...,n . This gives a sequence of real numbers { x ji } which, since the projection decreases distances, is again a Cauchy sequence. By Lemma 1, { x ji } → x j 0 . It follows that { p i } → p 0 = { x 10 ,x 20 ,...,x n 0 } . Q.E.D.

# B. Connected Sets

DEFINITION 7. Acontinuous curve α : [a , b] → A ⊂ R n is called an arc in A joining α( a ) to α( b ) .

DEFINITION 8. A ⊂ R n is arcwise connected if, given two points p , q ∈ A , there exists an arc in A joining p to q .

Earlier in the book we have used the word connected to mean arcwise connected (Sec. 2-2). Since we were considering only regular surfaces, this can be justiﬁed, as will be done presently. For a general subset of R n , however, the notion of arcwise connectedness is much too restrictive, and it is more convenient to use the following deﬁnition.

DEFINITION 9. A ⊂ R n is connected when it is not possible to write A = U 1 ∪ U 2 , where U 1 and U 2 are nonempty open sets in A and U 1 ∩ U 2 = φ .

Intuitively, this means that it is impossible to decompose A into disjoint pieces. For instance, the sets U 1 and F 1 in Example 2 are not connected. By taking the complements of U 1 and U 2 , we see that we can replace the word “open” by “closed” in Def. 10.

[Page 482]

PROPOSITION 5. Let A ⊂ R n be connected and let B ⊂ A be simultaneously open and closed in A . Then either B = φ or B = A .

Proof . Supposethat B  = φ and B  = A andwrite A = B ∪ (A − B) . Since B is closed in A , A − B is open in A . Thus, A is a union of disjoint, nonvoid, open sets, namely B and A − B . This contradicts the connectedness of A . Q.E.D.

Q.E.D.

The next proposition shows that the continuous image of a connected set is connected.

PROPOSITION 6. Let F: A ⊂ R n → R m be continuous and A be connected. Then F ( A ) is connected.

Proof . Assume that F(A) is not connected. Then F(A) = U 1 ∪ U 2 , where U 1 and U 2 are disjoint, nonvoid, open sets in F(A) . Since F is continuous, F − 1 (U 1 ) , F − 1 (U 2 ) are also disjoint, nonvoid, open sets in A . Since A = F − 1 (U 1 ) ∪ F − 1 (U 2 ) , this contradicts the connectedness of A . Q.E.D.

For the purposes of this section, it is convenient to extend the deﬁnition of interval as follows:

DEFINITION 10. An interval of the real line R is any of the sets a < x < b , a ≤ x ≤ b , a < x ≤ b , a ≤ x < b , x ∈ R . The cases a = b , a = −∞ , b = +∞ are not excluded, so that an interval may be a point, a half-line, or R itself.

PROPOSITION 7. A ⊂ R is connected if and only if A is an interval.

Proof . Let A ⊂ R be an interval and assume that A is not connected. We shall arrive at a contradiction.

Since A is not connected, A = U 1 ∪ U 2 , where U 1 and U 2 are nonvoid, disjoint, and open in A . Let a 1 ∈ U 1 , b 1 ∈ U 2 and assume that a 1 < b 1 . By dividing the closed interval [ a 1 ,b 1 ] = I 1 by the midpoint (a 1 + b 1 )/ 2, we obtain two intervals, one of which, to be denoted by I 2 , has one of its end points in U 1 and the other end point in U 2 . Considering the midpoint of I 2 and proceeding as before, we obtain an interval I 3 ⊂ I 2 ⊂ I 1 . Thus, we obtain a family of closed intervals I 1 ⊃ I 2 ⊃ ··· ⊃ I n ⊃ ··· whose lengths approach zero. Let us rewrite I i = [ c i ,d i ]. Then c 1 ≤ c 2 ≤ ··· ≤ c n ≤ ··· , and d 1 ≥ d 2 ≥ ··· ≥ d n ≥ ··· . Let c = sup { c 1 } and d = inf { d i } . Since d 1 − c i is arbitrarily small, c = d . Furthermore, any neighborhood of c contains some I i for i sufﬁcientlylarge.Thus, c isalimitpointofboth U 1 and U 2 . Since U 1 and U 2 are closed, c ∈ U 1 ∩ U 2 , and that contradicts the disjointness of U 1 and U 2 . Conversely, assumethat A isconnected. If A hasasingleelement, A istriv-

Conversely, assume that A is connected. If A has a single element, A is trivially an interval. Suppose that A has at least two elements, and let a = inf A , b = sup A , a /negationslash= b . Clearly, A ⊂ [ a, b ]. We shall show that (a, b) ⊂ A , and that implies that A is an interval. Assume the contrary; that is, there exists t , a < t < b , such that t / ∈ A . The sets A ∩ ( -∞ , t ) = V 1 , A ∩ (t, +∞ ) = V 2 are open in A = V 1 ∪ V 2 . Since A is connected, one of these sets, say, V 2 is empty. Since b ∈ (t, +∞ ) , this implies both that b / ∈ A and b is not a limit point of A . This contradicts the fact that b = sup A . In the same way, if V 1 = φ , we obtain a contradiction with the fact that a = inf A . Q.E.D.

[Page 483]

PROPOSITION 8. Let f: A ⊂ R n → R be continuous and A be connected. Assume that f ( q )  = 0 for all q ∈ A . Then f does not change sign in A .

Proof . ByProp. 6, f(A) ⊂ R isconnected. ByProp. 7, f(A) isaninterval. By hypothesis, f(A) does not contain zero. Thus, the points in f(A) all have the same sign. Q.E.D.

PROPOSITION 9. Let A ⊂ R n be arcwise connected. Then A is connected.

Proof . Assume that A is not connected. Then A = U 1 ∪ U 2 , where U 1 , U 2 are nonvoid, disjoint, open sets in A . Let p ∈ U 1 , q ∈ U 2 . Since A is arcwisc connected, there is an arc α : [ a,b ] → A joining p to q . Since α is continuous, B = α( [ a,b ] ) ⊂ A is connected. Set V 1 = B ∩ U 1 , V 2 = B ∩ U 2 . Then B = V 1 ∪ V 2 , where V 1 and V 2 are nonvoid, disjoint, open sets in B , and that is a contradiction. Q.E.D.

The converse is, in general, not true. However, there is an important special case where the converse holds.

DEFINITION 11. A set A ⊂ R n is locally arcwise connected if for each p ∈ A and each neighborhood V of p in A there exists all arcwise connected neighborhood U ⊂ V of p in A .

Intuitively, this means that each point of A has arbitrarily small arcwise connected neighborhoods. A simple example of a locally arcwise connected set in R 3 is a regular surface. In fact, for each p ∈ S and each neighborhood W of p in R 3 , there exists a neighborhood V ⊂ W of p in R 3 such that V ∩ S is homeomorphic to an open disk in R 2 ; since open disks are arcwise connected, each neighborhood W ∩ S of p ∈ S contains an arcwise connected neighborhood.

The next proposition shows that our usage of the word connected for arcwise connected surfaces was entirely justiﬁed.

PROPOSITION 10. Let A ⊂ R n bealocallyarcwiseconnectedset. Then A is connected if and only if it is arcwise connected.

[Page 484]

Proof . Half of the statement has already been proved in Prop. 9. Now assume that A is connected. Let p ∈ A and let A 1 be the set of points in A that can be joined to p by some arc in A . We claim that A 1 is open in A .

In fact, let q ∈ A 1 and let α : [ a,b ] → A be the arc joining p to q . Since A is locally arcwise connected, there is a neighborhood V of q in A such that q can be joined to any point r ∈ V by an arc β : [ b,c ] → V (Fig. A5-3). It follows that the arc in A ,

$$
\alpha \circ \beta = \begin{cases} \alpha ( t ) , & t \in [ a , b ] , \\ \beta ( t ) , & t \in [ b , c ] , \end{cases} \\ .
$$

joins q to r , and this proves our claim.

![In this image we can see a diagram.](<images/imageFile90.png>)

p

V

A

r

q

Figure A5-3

By a similar argument, we prove that the complement of A 1 is also open in A . Thus, A 1 is both open and closed in A . Since A is locally arcwise connected, A 1 is not empty. Since A is connected, A 1 = A . Q.E.D.

Example 4. A set may be arcwise connected and yet fail to be locally arcwise connected . For instance, let A ⊂ R 2 be the set made up of vertical lines passing through ( 1 /n, 0 ) , n = 1 ,..., plus the x and y axis. A is clearly arcwise connected, but a small neighborhood of ( 0 ,y) , y  = 0, is not arcwise connected. This comes from the fact that although there is a “long” arc joining any two points p , q ∈ A , there may be no short arc joining these points (Fig. A5-4).

# C. Compact Sets

DEFINITION 12. A set A ⊂ R n is bounded if it is contained in some ball of R n . A set K ⊂ R n is compact if it is closed and bounded.

[Page 485]

![In this image, we can see a diagram with a diagram of a cylinder and a diagram of a cylinder. We can also see a diagram of a cylinder and a diagram of a cylinder.](<images/imageFile91.png>)

y

(0,

)

y

q

p

x

0

1/4

1/3

1/2

1

Figure A5-4

We have already met compact sets in Sec. 2-7. For completeness, we shall prove here properties 1 and 2 of compact sets, which were assumed in Sec. 2-7.

DEFINITION 13. An open cover of a set A ⊂ R n is a family of open sets { U α } , α ∈ a such that   α U α ⊃ A . When there are only ﬁnitely many U α in the family, we say that the cover is ﬁnite . If the subfamily { U β } , β ∈ B ⊂ a , still covers A , that is,   β U β ⊃ A , we say that { U β } is a subcover of { U α } . PROPOSITION 11. For a set K ⊂ R n the following assertions are

PROPOSITION 11. For a set K ⊂ R n the following assertions are equivalent:

- 1. K is compact.
- 2. (Heine-Borel) . Every open cover of K has a ﬁnite subcover.
- 3. (Bolzano-Weierstrass) . Every inﬁnite subset of K has a limit point in K .


Proof . We shall prove 1 =⇒ 2 =⇒ 3 =⇒ 1.

the compact K , and assume that { U α } hasnoﬁnitesubcover.Weshallshowthatthisleadstoacontradiction. Since K is compact, it is contained in a closed rectangular region

$$
B = \{ ( x _ { 1 } , \dots , x _ { n } ) \in R ^ { n } ; a _ { j } \leq x _ { j } \leq b _ { j } , \ \ j = 1 , \dots , n \} .
$$

Let us divide B by the hyperplanes x j = (a j + b j )/ 2 (for instance, if K ⊂ R 2 , B is a rectangle, and we are dividing B into 2 2 = 4 rectangles). We thus obtain 2 n smaller closed rectangular regions. By hypothesis, at least one of these regions, to be denoted by B 1 , is such that B 1 ∩ K is not covered by a ﬁnite number of open sets of { U α } . We now divide B 1 in a similar way, and,

[Page 486]

![The image presents a geometric figure consisting of a circle and several points. The circle is positioned in the center of the image. The circle has a diameter that is labeled as B and is marked as the diameter of the circle. The center of the circle is marked as C. There are two points labeled as A and B on the circumference of the circle. Point A is located on the circumference of the circle and is marked as the center of the circle. Point B is located on the circumference of the circle and is marked as the midpoint of the circumference. The diagram includes several lines and points. The lines are labeled as follows: - Line segment AB is drawn from point A to point B. - Line segment BC is drawn from point B to point C. - Line segment AC is drawn from point A to point B.](<images/imageFile92.png>)

B

B

3

4

B

B

1

B

2

K

Figure A5-5

$$
B _ { 1 } \supset B _ { 2 } \supset \dots \supset B _ { i } \supset \dots
$$

which is such that no B i ∩ K is covered by a ﬁnite number of open sets of { U α } and the length of the largest side of B i converges to zero.

We claim that there exists p ∈ ∩ B i . In fact, by projecting each B i on the j axis of R n , j = l,...,n , we obtain a sequence of closed intervals

$$
[ a _ { j 1 } , b _ { j 1 } ] \supset [ a _ { j 2 } , b _ { j 2 } ] \supset \cdots \supset [ a _ { j i } , b _ { j i } ] \supset \cdots .
$$

Since (b ji − a ji ) is arbitrarily small, we see that

$$
a _ { j } = \sup \{ a _ { j i } \} = \inf \{ b _ { j i } \} = b _ { j } ;
$$

$$
a _ { j } \in \bigcap _ { i } [ a _ { j i } , b _ { j i } ] . \\ \\ \intertext { a _ { j } \in \bigcap _ { i } [ a _ { j i } , b _ { j i } ] . } \\
$$

Thus, p = (a 1 ,...,a n ) ∈   i B i , as we claimed. Now, any neighborhood of p contains some B i for i sufﬁciently large; hence, it contains inﬁnitely many points of K . Thus, p is a limit point of K , and since K is closed, p ∈ K . Let U 0 be an element of the family { U α } which contains p . Since U 0 is open, there exists a ball B ǫ (p) ⊂ U 0 . On the other hand, for i sufﬁciently large, B i ⊂ B ǫ (p) ⊂ U 0 . This contradicts the fact that no B i ∩ K can be covered by a ﬁnite number of U α ’s and proves that 1 =⇒ 2. 2 =⇒ 3.Assume that A ⊂ K is an inﬁnite subset of K and that no point of

2 =⇒ 3. Assume that A ⊂ K is an infinite subset of K and that no point of K is a limit point of A . Then it is possible, for each p ∈ K , p / ∈ A , to choose a neighborhood Vp of p such that Vp ∩ A = φ and for each q ∈ A to choose a neighborhood Wq of q such that Wq ∩ A = q . Thus, the family { Vp, Wp } , p ∈ K -A , q ∈ A , is an open cover of K . Since A is infinite and the omission of any Wq of the family leaves the point q uncovered, the family { Vp, Wq } has no finite subcover. This contradicts assertion 2.

[Page 487]

3 =⇒ 1: We have to show that K is closed and bounded. K is closed, because if p is a limit point of K , by considering concentric balls B 1 /i (p) = B i , weobtainasequence p 1 ∈ B 1 − B 2 , p 2 ∈ B 2 − B 3 ,...,p i ∈ B i − B i + 1 ,... which has p as a limit point. By assertion 3, p ∈ K . K is bounded. Otherwise, by considering concentric balls B i (p) , of radius

1 , 2 ,...,i,..., we will obtain a sequence p 1 ∈ B 1 , p 2 ∈ B 2 − B 1 ,... , p i ∈ B i − B i − 1 ,... with no limit point. This proves that 3 =⇒ 1. Q.E.D.

The next proposition shows that a continuous image of a compact set is compact.

PROPOSITION 12. Let F: K ⊂ R n → R m be continuous and let K be compact. Then F ( K ) is compact.

Proof . If F(K) is ﬁnite, it is trivially compact. Assume that F(K) is not ﬁnite and consider an inﬁnite subset { F(p α ) } ⊂ F(K) , p α ∈ K . Clearly the set { p α } ⊂ K is inﬁnite and has, by compactness, a limit point q ∈ K . Thus, there exists a sequence p 1 ,...,p i ,..., → q , p i ∈ { p α } . By the continuity of F , the sequence F(p i ) → F(q) ∈ F(K) (Prop. 1). Thus, { F(p α ) } has a limit point F(q) ∈ F(K) ; hence, F(K) is compact. Q.E.D.

The following is probably the most important property of compact sets.

PROPOSITION 13. Let f: K ⊂ R n → R be a continuous function deﬁned on a compact set K . Then there exists p 1 , p 2 ∈ K such that

$$
f ( p _ { 2 } ) \leq f ( p ) \leq f ( p _ { 1 } ) \ \ f o r \ a l l \ p \in K ;
$$

that is, f reaches a maximum at p 1 and a minimum at p 2 .

Proof . We shall prove the existence of p 1 ; the case of minimum can be treated similarly.

By Prop. 12, f (K) is compact, and hence closed and bounded. Thus, there exists sup f (K) = x 1 . Since f (K) is closed, x 1 ∈ f (K) . It follows that there exists p 1 ∈ K with x 1 = f (p 1 ) . Clearly, f (p) ≤ f (p 1 ) = x 1 for all p ∈ K . Q.E.D.

Q.E.D.

Although we shall make no use of it, the notion of uniform continuity ﬁts so naturally in the present context that we should say a few words about it. n m

A map F : A ⊂ R → R is uniformly continuous in A if given ǫ > 0, there exists δ > 0 such that F(B δ (p)) ⊂ B ǫ (F(p)) for all p ∈ A . Formally, the difference between this deﬁnition and that of (simple) con-

Formally, the difference between this definition and that of (simple) continuity is the fact that here, given /epsilon1 , the number δ is the same for all p ∈ B , whereas in simple continuity, given /epsilon1 , the number δ may vary with p . Thus, uniform continuity is a global, rather than a local, notion.

[Page 488]

It is an important fact that on compact sets the two notions agree. More precisely, let F: K ⊂ R n → R m be continuous and K be compact . Then F is uniformly continuous in K.

The proof of this fact is simple if we recall the notion of the Lebesgue number of an open cover, introduced in Sec. 2-7. In fact, given ǫ > 0, there existsforeach p ∈ K anumber δ(p) > 0suchthat F(B δ(p) (p)) ⊂ B ǫ/ 2 (F(p)) . The family { B δ(p) (p),p ∈ K } is an open cover of K . Let δ > 0 be

the Lebesgue number of this family (Sec. 2-7, property 3). If q ∈ B δ (p) , p ∈ K , then q and p belong to some element of the open cover. Thus, | F(p) − F(q) | < ǫ . Since q is arbitrary, F(B δ (p)) ⊂ B ǫ (F(p)) . This shows that δ satisﬁes the deﬁnition of uniform continuity, as we wished.

# D. Connected Components

When a set is not connected, it may be split into its connected components. To make this idea precise, we shall ﬁrst prove the following proposition.

PROPOSITION 14. Let C α ⊂ R n be a family of connected sets such that

$$
\bigcap _ { \alpha } C _ { \alpha } \neq \phi . \\ \\ \intertext { l } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext { a } \intertext {
$$

Then ⋃ α C α = C is a connected set.

where U 1 and U 2 are nonvoid, disjoint, opensetsin C , andthatsomepoint p ∈   α C α belongsto U 1 . Let q ∈ U 2 . Since C =   α C α and p ∈   α C α , there exists some C α such that p,q ∈ C α . Then C α ∩ U 1 and C α ∩ U 2 are nonvoid, disjoint, open sets in C α . This contradicts the connectedness of C α and shows that C is connected.

Q.E.D.

DEFINITION 14. Let A ⊂ R n and p ∈ A . The union of all connected subsets of A which contain p is called the connected component of A containing p .

By Prop. 14, a connected component is a connected set. Intuitively the connected component of A containing p ∈ A is the largest connected subset of A (that is, it is contained in no other connected subset of A that contains p ).

A connected component of a set A is always closed in A . This is a consequence of the following proposition.

PROPOSITION 15. Let C ⊂ A ⊂ R n be a connected set. Then the closure ¯ C of C in A is connected.

[Page 489]

Proof . Let us suppose that ¯ C = U 1 ∪ U 2 , where U 1 , U 2 are nonvoid, disjoint, open sets in ¯ C . Since ¯ C ⊃ C , the sets C ∩ U 1 = V 1 , C ∩ U 2 = V 2 are openin C , disjoint, and V 1 ∪ V 2 = C .Weshallshowthat V 1 and V 2 arenonvoid, thus reaching a contradiction with the connectedness of C .

Let p ∈ U 1 . Since U 1 is open in ¯ C , there exists a neighborhood W of p in A such that W ∩ ¯ C ⊂ U 1 . Since p is a limit of C , there exists q ∈ W ∩ C ⊂ W ∩ ¯ C ⊂ U 1 . Thus, q ∈ C ∩ U 1 = V 1 , and V 1 is not empty. In a similar way, it can be shown that V 2 is not empty. Q.E.D.

COROLLARY. A connected component C ⊂ A ⊂ R n of a set A is closed in A .

In fact, if ¯ C  = C , there exists a connected subset of A , namely ¯ C , which contains C properly. This contradicts the maximality of the connected component C .

In some special cases, a connected component of set A is also an open set in A .

PROPOSITION 16. Let C ⊂ A ⊂ R n be a connected component of a locally arcwise connected set A . Then C is open in A .

Proof . Let p ∈ C ∈ A . Since A is locally arcwise connected, there exists an arcwise connected neighborhood V of p in A . By Prop. 9, V is connected. Since C is maximal, C ⊃ V ; hence, C is open in A . Q.E.D

# E. Closed Maps

Here we follow Lima E., Fundamental Groups and Covering Spaces, A.K. Peters, translated from the Portuguese by Jonas Gomes, Natick, Massachusetts, 2003, p. 201.

DEFINITION. Let ˜ X and X be topological spaces and f : ˜ X → X be a map; the map f is called closed if it takes closed sets in ˜ X into closed sets in X .

PROPOSITION. A necessary and sufﬁcient condition for f : ˜ X → X to be a closed map is that given x ∈ X and an open set ˜ U ⊃ f − 1 (x) in ˜ X , there exists an open set U in X such that x ∈ U and f − 1 (U) ⊂ ˜ U .

Proof . The condition is necessary. For, if f is closed, f ( ˜ X − ˜ U) is closed in X . Since it does not contain x , there exists an open set U ∋ x so that U ∩ f ( ˜ X − ˜ U)  = ∅ . It follows that f − 1 (U) ⊂ ˜ U , which is the condition in the Proposition.

The condition is sufﬁcient. For if we assume the condition, let F ⊂ ˜ X be a closed set in ˜ X . Choose x  ∈ f (F) . Then F ∩ f − 1 (x) = ∅ . Hence the open set

[Page 490]

˜ U = (X − F) contains f − 1 (x) . It follows that there exists an open set U ∋ x such that f − 1 (U) ⊂ ˜ U . This implies that U ∩ f (F)  = ∅ , i.e., f (F) is closed in X .

Remark. Should f − 1 be a map, the condition of the proposition would say that f − 1 is continuous; notice that f − 1 (x) is not a point in X but it is, in general, a set.

[Page 491]

# Bibliography and Comments

The basic work of differential geometry of surfaces is Gauss’ paper “Disquisitiones generales circa superﬁcies curvas,” Comm. Soc. Göttingen Bd6, 1823–1827. Therearetranslationsintoseverallanguages, forinstance,

1. Gauss, K. F., General Investigations of Curved Surfaces , Raven Press, New York, 1965.

We believe that the reader of this book is now in a position to try to understand that paper. Patience and open-mindedness will be required, but the experience is most rewarding.

The classical source of differential geometry of surfaces is the four-volume treatise of Darboux:

2. Darboux, G., Théorie des Surfaces , Gauthier-Villars, Paris, 1887, 1889, 1894, 1896. There exists a reprint published by Chelsea Publishing Co., Inc., New York.

This is a hard reading for beginners. However, beyond the wealth of information, there are still many unexplored ideas in this book that make it worthwhile to come to it from time to time.

The most inﬂuential classical text in the English language was probably

3. Eisenhart, L. P., A Treatise on the Differential Geometry of Curves and Surfaces , Ginn and Company, Boston, 1909, reprinted by Dover, New York, 1960.

An excellent presentation of some intuitive ideas of classical differential geometry can be found in Chap. 4 of

[Page 492]

4. Hilbert, D., and S. Cohn-Vossen, Geometry and Imagination , Chelsea Publishing Company, Inc., New York, 1962 (translation of a book in German, ﬁrst published in 1932).

Below we shall present, in chronological order, a few other textbooks. They are more or less pitched at about the level of the present book. A more complete list can be found in [9], which, in addition, contains quite a number of global theorems.

- 5. Struik, D. J., Lectures on Classical Differential Geometry , AddisonWesley, Reading, Mass., 1950.
- 6. Pogorelov, A. V., Differential Geometry , Noordhoff, Groningen, Netherlands, 1958.
- 7. Willmore, T. J., An Introduction to Differential Geometry , Oxford University Press, Inc., London 1959.
- 8. O’Neill, B., Elementary Differential Geometry , Academic Press, New York, 1966.
- 9. Stoker, J. J., Differential Geometry , Wiley-Interscience, New York, 1969.


A clear and elementary exposition of the method of moving frames, not treated in the present book, can be found in [8]. Also, more details on the theory of curves, treated brieﬂy here, can be found in [5], [6], and [9].

Although not textbooks, the following references should be included. Reference [10] is a beautiful presentation of some global theorems on curves and surfaces, and [11] is a set of notes which became a classic on the subject.

- 10. Chern, S. S., Curves and Surfaces in Euclidean Spaces , Studies in Global Geometry and Analysis, MAA Studies in Mathematics, The Mathematical Association of America, 1967.
- 11. Hopf, H., Differential Geomentry in the Large , Lecture Notes in Mathematics, No. 1000, Part Two, pp. 76–187, Springer, 1989.


For more advanced reading, one should probably start by learning something of differentiable manifolds and Lie groups. For instance,

- 12. Spivak, M., A Comprehensive Introduction to Differential Geometry , Vol. 1, Brandeis University, 1970.
- 13. Warner, F., Foundations of Differentiable Manifolds and Lie Groups , Scott, Foresman, Glenview, Ill., 1971.


Reference [12] is a delightful-reading. Chapters 1–4 of [13] provide a short and efﬁcient account of the basics of the subject.

After that, there is a wide choice of reading material, depending on the reader’s tastes and interests. Below we include a possible choice, by no means unique. In [17] and [18] one can ﬁnd extensive lists of books and papers.

[Page 493]

- 14. Berger, M., P. Gauduchon, and E. Mazet, Le Spectre d’une Variété Riemannienne , Lecture Notes 194, Springer, Berlin, 1971.
- 15. Bishop, R. L., and R. J. Crittenden, Geometry of Manifolds , Academic Press, New York, 1964.
- 16. Cheeger, J., and D. Ebin, Comparison Theorems in Riemannian Geometry , North-Holland, Amsterdam, 1974.
- 17. Helgason, S., Differential Geometry and Symmetric Spaces , Academic Press, New York, 1963.
- 18. Kobayashi, S., and K. Nomizu, Foundations of Differential Geometry , Vols. I and II, Wiley-Interscience, New York, 1963 and 1969,
- 19. Gromoll, D., Klingenberg, W. and W. Meyer, Riemannsche Geometrie im Grossen , Lecture Notes 55, Springer-Verlag, Berlin, 1968.
- 20. Lawson, B., Lectures on Minimal Submanifolds , Monograﬁas de Matemática, IMPA, Rio de Janeiro, 1973.
- 21. Milnor, J., Morse Theory , Princeton University Press, Princeton, N. J., 1963.
- 22. Spivak, M., A Comprehensive Introduction to Differential Geometry , Vol. I to V, Publish or Perish, Inc., 2005.


[Page 494]

# Hints and Answers

# SECTION 1-3

2. a. α(t) = (t − sin t, 1 − cos t) ; see Fig. 1-7. Singular points: t = 2 πn , where n is any integer.

7. b. Applythemeanvaluetheoremtoeachofthefunctions x,y,z toprove that the vector (α(t + h) − α(t + k))/(h − k) converges to the vector α ′ (t) as h,k → 0 . Since α ′ (t)  = 0, the line determined by α(t + h) , α(t + k) converges to the line determined by α ′ (t) . 8. By the deﬁnition of integral, given ǫ > 0, there exists a δ ′ > 0 such that

By the definition of integral, given /epsilon1 > 0, there exists a δ ′ > 0 such that if | P | < δ ′ , then

$$
\left | \left ( \int _ { a } ^ { b } | \alpha ^ { \prime } ( t ) | d t \right ) - \sum ( t _ { i } - t _ { i - 1 } ) | \alpha ^ { \prime } ( t _ { i } ) | \right | & < \frac { \epsilon } { 2 } . \\ \intertext { h e r o w h a n d , s i n c e \alpha ^ { \prime } i s u n i f r o m i l y c o n t i n u o u s i n [ a , b ] , g i v e n \epsilon } \colon \text {exists } \delta ^ { \prime \prime } \succ 0 \, \text {such that if } t _ { i } \ s \in [ a , b ] \text { with } | t _ { i } - s | < \delta ^ { \prime \prime } \text { then }
$$

      a | |   −   i − i − 1 | i |   2 On theotherhand, since α ′ isuniformlycontinuousin[ a,b ], given ǫ > 0, there exists δ ′′ > 0 such that if t,s ∈ [ a,b ] with | t − s | < δ ′′ , then

$$
| \alpha ^ { \prime } ( t ) - \alpha ^ { \prime } ( s ) | & < \epsilon / 2 ( b - a ) . \\
$$

Set δ = min (δ ′ ,δ ′′ ) . Then if | P | < δ , we obtain, by using the mean value theorem for vector functions,

$$
\text {theorem for vector functions,} \\ & \quad \left | \sum | \alpha ( t _ { i - 1 } ) - \alpha ( t _ { i } ) | - \sum ( t _ { i - 1 } - t _ { i } ) | \alpha ^ { \prime } ( t _ { i } ) | \right | \\ & \leq \left | \sum ( t _ { i - 1 } - t _ { i } ) \sup _ { s _ { i } } | \alpha ^ { \prime } ( s _ { i } ) | - \sum ( t _ { i - 1 } - t _ { i } ) | \alpha ^ { \prime } ( t _ { i } ) | \right | \\ & \leq \left | \sum ( t _ { i - 1 } - t _ { i } ) \sup | \alpha ^ { \prime } ( s _ { i } ) - \alpha ^ { \prime } ( t _ { i } ) | \right | \leq \frac { \epsilon } { 2 } ,
$$

[Page 495]

where t i − 1 ≤ s i ≤ t i . Together with the above, this gives the required inequality.

# SECTION 1-4

- 2. Let the points p 0 = (x 0 ,y 0 ,z 0 ) and p = (x,y,z) belong to the plane P . Then ax 0 + by 0 + cz 0 + d = 0 = ax + by + cz + d . Thus, a(x − x 0 ) + b(y − y 0 ) + c(z − z 0 ) = 0. Since the vector (x − x 0 ,y − y 0 ,z − z 0 ) is parallel to P , the vector (a,b,c) is normal to P . Given a point p = (x,y,z) ∈ P , the distance ρ from the plane P to the origin O is given by ρ = | p | cos θ = (p · v)/ | v | , where θ is the angle of Op with the normal vector v . Since p · v = − d ,

$$
\rho = \frac { p \cdot v } { | v | } = - \frac { d } { | v | } .
$$

- 3. This is the angle of their normal vectors.
- 4. Two planes are parallel if and only if their normal vectors are parallel.


- 6. v 1 and v 2 are both perpendicular to the line of intersection. Thus, v 1 ∧ v 2 is parallel to this line.
- 7. A plane and a line are parallel when a normal vector to the plane is perpendicular to the direction of the line.
- 8. Thedirectionofthecommonperpendiculartothegivenlinesisthedirection of u ∧ v . The distance between these lines is obtained by projecting the vector r = (x 0 − x 1 ,y 0 − y 1 ,z 0 − z 1 ) onto the common perpendicular. Such a projection is clearly the inner product of r with the unit vector (u ∧ v)/ | u ∧ v | .


# SECTION 1-5

2. Use the fact that α ′ = t , α ′′ = kn , α ′′′ = kn ′ + k ′ n = − k 2 t + k ′ n − kτb . 4. Differentiate α(s) λ(s)n(s) const . , obtaining

Differentiate α(s) + λ(s)n(s) = const . , obtaining

$$
( 1 - \lambda k ) t + \lambda ^ { \prime } n - \lambda \tau b = 0 .
$$

It follows that τ = 0 (the curve is contained in a plane) and that λ = const . = 1 /k . a. Parametrize α by arc length.

a. Parametrize α by arc length.

b. Parametrize α by arc length s . The normal lines at s 1 and s 2 are

$$
\beta _ { 1 } ( t ) = \alpha ( s _ { 1 } ) + t n ( s _ { 1 } ) , \quad \beta _ { 2 } ( \tau ) = \alpha ( s _ { 2 } ) + \tau n ( s _ { 2 } ) , \quad t \in R , \tau \in R ,
$$

[Page 496]

respectively. Their point of intersection will be given by values of t and τ such that

$$
\frac { \alpha ( s _ { 2 } ) - \alpha ( s _ { 1 } ) } { s _ { 2 } - s _ { 1 } } = \frac { t n ( s _ { 1 } ) - \tau n ( s _ { 2 } ) } { s _ { 2 } - s _ { 1 } } .
$$

Take the inner product of the above with α ′ (s 1 ) to obtain 1 = ( − lim τ) s 2 → s 1 ·  α ′ (s 1 ),n ′ (s 1 )   . It follows that τ converges to 1 /k as s 2 → s 1 . prove that the condition is necessary, differentiate three times

To prove that the condition is necessary, differentiate three times

| α(s) | = const . , obtaining α(s) = − Rn + R ′ Tb . For the sufﬁciency, differentiate β(s) = α(s) + Rn − R ′ Tb , obtaining

$$
\beta ^ { \prime } ( s ) = t + R ( - k t - \tau b ) + R ^ { \prime } n - ( T R ^ { \prime } ) ^ { \prime } b - R n = - ( R ^ { \prime } \tau + ( T R ^ { \prime } ) ^ { \prime } ) b .
$$

On the other hand, by differentiating R 2 + ( TR ′ ) 2 = const . , one obtains

+ =

$$
0 = 2 R R ^ { \prime } + 2 ( T R ^ { \prime } ) ( T R ^ { \prime } ) = \frac { 2 R ^ { \prime } } { \tau } ( R \tau + ( T R ^ { \prime } ) ^ { \prime } ) ,
$$

since k ′  = 0 and τ  = 0. Hence, β(s) is a constant p 0 , and

$$
| \alpha ( s ) - p _ { 0 } | ^ { 2 } = R ^ { 2 } + ( T R ^ { \prime } ) ^ { 2 } = c o n s t .
$$

15. Since b ′ = τn is known, | τ | = | b ′ | . Then, up to a sign, n is determined. Since t = n ∧ b and the curvature is positive and given by t ′ = kn , the curvature can also be determined.

curvature can also be determined.

16. First show that

$$
\frac { \prime } { 2 } = a ( s ) .
$$

$$
\frac { n \wedge n ^ { \prime } \cdot n ^ { \prime \prime } } { | n ^ { \prime } | ^ { 2 } } = \frac { \left ( \frac { k } { \tau } \right ) ^ { ^ { \prime } } } { \left ( \frac { k } { \tau } \right ) ^ { ^ { 2 } } + 1 } = a ( s ) \\
$$

Thus,   a(s)ds = arctan (k/τ) ; hence, k/τ can be determined; since k is positive, this also gives the sign of τ . Furthermore, | n ′ | 2 = |− kt − τb | 2 = k 2 + τ 2 is also known. Together with k/τ , this sufﬁces to determine k 2 and τ 2 .

to determine k and τ .

17. a. Let a be the unit vector of the ﬁxed direction and let θ be the constant angle. Then t · a = cos θ = const . , which differentiated gives n · a = 0. Thus, a = t cos θ + b sin θ , which differentiated gives k cos θ + τ sin θ = 0, or k/τ = − tan θ = const. Conversely,

[Page 497]

if k/τ = const . = − tan θ = − ( sin θ/ cos θ) , we can retrace our steps, obtaining that t cos θ + b sin θ is a constant vector a . Thus, t · a = cos θ = const. Fromtheargumentofparta, itfollowsimmediatelythat t a const .

b. · = implies that n · a = 0; the last condition means that n is parallel to a plane normal to a . Conversely, if n · a = 0, then (dt/ds) · a = 0; hence, t · a = const.

hence, t · a = const.

c. it follows that t · a = const . implies that b · a = const. Conversely, if b · a = const . , by differentiation we ﬁnd that n · a = 0. a. Parametrize α by arc length s and differentiate α α rn with

a. Parametrize by arc length and differentiate

¯ = + respect to s , obtaining

$$
\frac { d \bar { \alpha } } { d s } = ( 1 - r k ) t + r ^ { \prime } n - r \tau b
$$

$$
- r \tau b .
$$

Since d ¯ α/ds is tangent to ¯ α , (d ¯ α/ds) · n = 0; hence, r ′ = Parametrize α by arc length s , and denote by s and t the

0.

b. ¯ ¯ arc length and the unit tangent vector of ¯ α . Since d ¯ t/ds = (d ¯ t/d ¯ s)(d ¯ s/ds) , we obtain that d d t dt

$$
\frac { d } { d s } ( t \cdot \bar { t } ) = t \cdot \frac { d \bar { t } } { d s } + \frac { d t } { d s } \cdot \bar { t } = 0 ;
$$

$$
=
$$

hence, t · ¯ t = const . = cos θ . Thus, by using that ¯ α = α + rn , we have

we have

$$
\cos \theta = \bar { t } \cdot t & = \frac { d \bar { \alpha } } { d s } \frac { d s } { d \bar { s } } \cdot t = \frac { d s } { d \bar { s } } ( 1 - r k ) , \\ | \sin \theta | = | \bar { t } \wedge t | & = \left | \frac { d s } { d \bar { s } } ( ( t + r n ^ { \prime } ) \wedge t \right | = \left | \frac { d s } { d \bar { s } } r \tau \right | .
$$

$$
d s \ d s \quad d s \\ | \sin \theta | = | \bar { t } \wedge t | = \left | \frac { d s } { d \bar { s } } ( ( t + r n ^ { \prime } ) \wedge t \right | = \left | \frac { d s } { d \bar { s } } r \tau \right | . \\ \intertext { \text {from these two relations, it follows that} } 1 \ r k
$$

| | = | ¯ ∧ | =   d ¯ s + From these two relations, it follows that

$$
\frac { 1 - r k } { r \tau } = \text {const.} = \frac { B } { r } .
$$

Thus, setting r = A , we finally obtain that Ak + Bτ = 1.

deﬁne ¯ α = α + rn . Then, by again using the relation, we obtain

$$
\frac { d \bar { \alpha } } { d s } = ( 1 - r k ) t - r \tau b = \tau ( B t - r b ) .
$$

$$
r b ) .
$$

Thus, a unit vector ¯ t of ¯ α is (Bt − rb)/ √ B 2 + r 2 = ¯ t . It follows that d ¯ t/ds = ((Bk − rτ)/ √ B 2 + r 2 )n . Therefore, ¯ n(s) = ± n(s) and the normal lines of ¯ α and α at s agree. Thus, α is a Bertrand curve.

[Page 498]

c. Assume the existence of two distinct Bertrand mates ¯ α = α + ¯ rn , ˜ α = α + ˜ rn . By part b there exist constants c 1 and c 2 so that 1 − ¯ rk = c 1 ( ¯ rτ) , 1 − ¯ rk = c 2 ( ¯ rτ) . Clearly, c 1  = c 2 . Differentiating these expressions, we obtain k ′ = τ ′ c 1 , k ′ = τ ′ c 2 , respectively. This implies that k ′ = τ ′ = 0. Using the uniqueness part of the fundamental theorem of the local theory of curves, it is easy to see that the circular helix is the only such curve.

# SECTION 1-6

1. Assume that s = 0, and consider the canonical form around s = 0. By condition 1, P must be of the form z = cy , or y = 0. The plane y = 0 is the rectifying plane, which does not satisfy condition 2. Observe now that if | s | is sufﬁciently small, y(s) > 0, and z(s) has the same sign as s . By condition 2, c = z/y is simultaneously positive and negative. Thus, P is the plane z = 0. 2. a. Consider the canonical form of α(s) (x(s),y(s),z(s)) in a neigh-

= borhood of s = 0. Let ax + by + cz = 0 be the plane that passes through α( 0 ) , α( 0 + h 1 ) , α( 0 + h 2 ) . Deﬁne a function F(s) = ax(s) + by(s) + cz(s) and notice that F( 0 ) = F(h 1 ) = F(h 2 ) = 0. Use the canonical form to show that F ′ ( 0 ) = a , F ′′ ( 0 ) = bk . Use the mean value theorem (twice) to show that as h 1 , h 2 → 0, then a → 0 and b → 0. Thus, as h 1 , h 2 → 0 the plane ax + by + cz = 0 approaches the plane z = 0, that is, the osculating plane.

# SECTION 1-7

- 1. No. Use the isoperimetric inequality.
- 2. Let S 1 be a circle such that AB is a chord of S 1 and one of the two arcs α and β determined by A and B on S 1 , say α , has length l . Consider the piecewise C 1 closed curve (see Remark 2 after Theorem 1) formed by β and C . Let β be ﬁxed and C vary in the family of all curves joining A to B with length l . By the isoperimetric inequality for piecewise C 1 curves, the curve of the family that bounds the largest area is S 1 . Since β is ﬁxed, the arc of circle α is the solution to our problem.


4. Choose coordinates such that the center O is at p and the x and y axes are directed along the tangent and normal vectors at p , respectively. Parametrize C by arc length, α(s) = (x(s),y(s)) , and assume that α( 0 ) = p . Consider the (ﬁnite) Taylor’s expansion 2

$$
\alpha ( s ) = \alpha ( 0 ) + \alpha ^ { \prime } ( 0 ) s + \alpha ^ { \prime \prime } ( 0 ) \frac { s ^ { 2 } } { 2 } + R ,
$$

[Page 499]

where lim s → 0 R/s 2 = 0. Let k be the curvature of α at s = 0, and obtain

$$
x ( s ) = s + R _ { x } , \ \ y ( s ) = \pm \frac { k s ^ { 2 } } { 2 } + R _ { y } ,
$$

where R = (R x ,R y ) and the sign depends on the orientation of α . Thus,

$$
| k | = \lim _ { s \to 0 } \frac { 2 | y ( s ) | } { s ^ { 2 } } = \lim _ { d \to 0 } \frac { 2 h } { d ^ { 2 } } .
$$

5. Let O be the center of the disk D . Shrink the boundary of D through a family of concentric circles until it meets the curve C at a point p . Use Exercise 4 to show that the curvature k of C at p satisﬁes | k | ≥ 1 /r . 8. Since α is simple, we have, by the theorem of turning tangents,

Since α is simple, we have, by the theorem of turning tangents,

$$
\int _ { 0 } ^ { t } k ( s ) \, d s & = \theta ( l ) - \theta ( 0 ) = 2 \pi . \\
$$

Since k(s) ≤ c , we obtain

$$
2 \pi = \int _ { 0 } ^ { l } k ( s ) \, d s & \leq c \int _ { 0 } ^ { l } d s = c l . \\ \\
$$

9. We ﬁrst observe that the intersection of convex sets is a convex set. Since the curve is convex, each tangent line determines a half-plane that contains the curve. The intersection all such half-planes is a convex set K ′ which contains the set K bounded by the curve. Also K ′ ⊂ K , for if q ′ ⊂ K ′ , q ′  ∈ K , the segment q ′ p ′ , q ′ ∈ K ′ , p ′ ∈ K ⊂ K ′ is contained in K ′ by convexity, and meets the curve. This is easily seen to yield a contradiction.

11. Observe that the area bounded by H is greater than or equal to the area bounded by C and that the length of H is smaller than or equal to the length of C . Expand H through a family of curves parallel to H (Exercise 6) until its length reaches the length of C . Since the area either remains the same or has been further increased in this process, we obtain aconvexcurve H ′ withthesamelengthas C butboundinganareagreater than or equal to the area of C .

$$
M _ { 1 } & = \int _ { 0 } ^ { 2 \pi } \left ( \int _ { 0 } ^ { 1 / 2 } d p \right ) \, d \theta = \pi , \\ M _ { 2 } & = \int _ { 0 } ^ { 2 \pi } \left ( \int _ { 0 } ^ { 1 } d p \right ) \, d \theta = 2 \pi .
$$

$$
1 2 .
$$

$$
M _ { 2 } = \int _ { 0 } ^ { 2 \pi } \left ( \int _ { 0 } ^ { 1 } d p \right ) d \theta = 2 \pi .
$$

(See Fig. 1-40.) Thus, M 1 /M 2 = 1 2 .

[Page 500]

# SECTION 2-2

5. Yes.

11. b. To see that x is one-to-one, observe that from z one obtains ± u . Since cosh v > 0, the sign of u is the same as the sign of x . Thus, sinh v (and hence v ) is determined.

x (u, v) = ( sinh u cos v, sinh u sin v, cosh v).

= =

Eliminate t in the equations x/a = y/t = -(z -t)/t of the line joining p(t) ( 0 , 0 , t ) to q(t) (a, t, 0 ) .

3 for plane curves and apply the argument of Example 5.

18. For the ﬁrst part, use the inverse function theorem. To determine F , set u = ρ 2 , v = tan ϕ , w = tan 2 θ . Write x = f (ρ,θ) cos ϕ , y = f (ρ,θ) sin ϕ , where f is to be determined. Then

$$
\frac { f ^ { 2 } } { \tau ^ { 2 } } = \tan ^ { 2 } \theta .
$$

$$
x ^ { 2 } + y ^ { 2 } + z ^ { 2 } = f ^ { 2 } + z ^ { 2 } = \rho ^ { 2 } , \quad \frac { f ^ { 2 } } { z ^ { 2 } } = \tan ^ { 2 } \theta .
$$

It follows that f = ρ sin θ , z = ρ cos θ . Therefore,

f = ρ θ z = ρ θ

$$
v , w ) = \left ( \frac { \sqrt { u w } } { \sqrt { ( 1 + w ) ( 1 + v ^ { 2 } ) } } , \frac { v \sqrt { u w } } { \sqrt { ( 1 + w ) ( 1 + v ^ { 2 } ) } } , \frac { \sqrt { u } } { \sqrt { 1 + w } } \right ) .
$$

$$
F ( u , v , w ) = \left ( \frac { \sqrt { u w } } { \sqrt { ( 1 + w ) ( 1 + v ^ { 2 } ) } } , \frac { v \sqrt { u w } } { \sqrt { ( 1 + w ) ( 1 + v ^ { 2 } ) } } , \frac { \sqrt { u } } { \sqrt { 1 + w } } \right ) .
$$

19. No. For C , observe that no neighborhood in R 2 of a point in the vertical arc can be written as the graph of a differentiable function. The same argument applies to S .

# SECTION 2-3

Since A 2 = identity, A = A -1 .

d is the restriction to S of a function d : R 3 → R :

$$
d ( x , y , z ) = \{ ( x - x _ { 0 } ) ^ { 2 } + ( y - y _ { 0 } ) ^ { 2 } + ( z - z _ { 0 } ) ^ { 2 } \} ^ { 1 / 2 } , \\ ( x , y , z ) \neq ( x _ { 0 } , y _ { 0 } , z _ { 0 } ) .
$$

8.

If p = (x,y,z) , F(p) lies in the intersection with H of the line t → (tx,ty,z) , t > 0. Thus,

$$
F ( p ) = \left ( \frac { \sqrt { 1 + z ^ { 2 } } } { \sqrt { x ^ { 2 } + y ^ { 2 } } } x , \frac { \sqrt { 1 + z ^ { 2 } } } { \sqrt { x ^ { 2 } + y ^ { 2 } } } y , z \right ) . \\ R ^ { 3 } \minus t h e z \, \alpha i s . \, T h e n \, F \colon U \subset R ^ { 3 } \to R ^ { 3 } \, \text {as define}
$$

Let U be R 3 minus the z axis. Then F : U ⊂ R 3 → R 3 as deﬁned above is differentiable.

is differentiable.

[Page 501]

−{ } To prove that F is differentiable at N , consider the stereographic projection π S from the south pole S = ( 0 , 0 , − 1 ) and set Q = π S ◦ F ◦ π − 1 S : U ⊂ C → C (of course, we are identifying the plane z = 1 with C ). Show that π N ◦ π − 1 S : C −{ 0 } → C is given by π N ◦ π − 1 S (ζ) = 1 / ¯ ζ . Conclude that n

$$
Q ( \zeta ) = \frac { \zeta ^ { n } } { \bar { a } _ { 0 } + \bar { a } _ { 1 } \zeta + \cdots + \bar { a } _ { n } \zeta ^ { n } } ;
$$

hence, Q is differentiable at ζ = 0. Thus, F = π − 1 S ◦ Q ◦ π S is differentiable at N .

# SECTION 2-4

1. Let α(t) = (x(t),y(t),z(t)) be a curve on the surface passing through p 0 = (x 0 ,y 0 ,z 0 ) for t = 0. Thus, f(x(t),y(t),z(t)) = 0; hence, f x x ′ ( 0 ) + f y y ′ ( 0 ) + f z z ′ ( 0 ) = 0, where all derivatives are computed at p 0 . This means that all tangent vectors at p 0 are perpendicular to the vector (f x ,f y ,f z ) , and hence the desired equation.

4. Denote by f ′ the derivative of f (y/x) with respect to t = y/x . Then z x = f − (y/x)f ′ , z y = f ′ . Thus, the equation of the tangent plane at (x 0 ,y 0 ) is z = x 0 f + (f − (y 0 /x 0 )f ′ )(x − x 0 ) + f ′ (y − y 0 ) , where the functions are computed at (x 0 ,y 0 ) . It follows that if x = 0, y = 0, then z = 0. 12. For the orthogonality, consider, for instance, the ﬁrst two surfaces. Their

normals are parallel to the vectors ( 2 x − a, 2 y, 2 z) , ( 2 x, 2 y − b, 2 z) . In the intersection of these surfaces, ax = by ; introduce this relation in the inner product of the above vectors to show that this inner product is zero.

13. a. Let α(t) be a curve on S with α( 0 ) = p , α ′ ( 0 ) = w . Then

$$
d f _ { p } ( w ) = \frac { d } { d t } ( \langle \alpha ( t ) - p _ { 0 } , \alpha ( t ) - p _ { 0 } \rangle ^ { 1 / 2 } ) | _ { t = 0 } = \frac { \langle w , p - p _ { 0 } \rangle } { | p - p _ { 0 } | } .
$$

It follows that p is a critical point of f if and only if   w,p − p 0   = 0 for all w ∈ T p (S) .

[Page 502]

The condition for the surfaces f(t 1 ) = 1, f(t 2 ) = 1 to be orthogonal is

$$
f _ { x } ( t _ { 1 } ) f _ { x } ( t _ { 2 } ) + f _ { y } ( t _ { 1 } ) f _ { v } ( t _ { 2 } ) + f _ { z } ( t _ { 1 } ) f _ { z } ( t _ { 2 } ) = 0 .
$$

This reduces to

$$
\frac { x ^ { 2 } } { ( a - t _ { 1 } ) ( a - t _ { 2 } ) } + \frac { y ^ { 2 } } { ( b - t _ { 1 } ) ( b - t _ { 2 } ) } + \frac { z ^ { 2 } } { ( c - t _ { 1 } ) ( c - t _ { 2 } ) } = 0 , \\ \text {which follows from the fact that} \ t _ { 1 } + t _ { 2 } \text { and } f ( t _ { 1 } ) - f ( t _ { 2 } ) = 0
$$

which follows from the fact that t 1 /negationslash= t 2 and f(t 1 ) -f(t 2 ) = 0.

17. S 1 is given by f (x,y,z) = 0 and S 2 by g(x,y,z) = 0 in a neighborhood of p ; here 0 is a regular value of the differentiable functions f and g . In this neighborhood of p , S 1 ∩ S 2 is given as the inverse image of ( 0 , 0 ) of the map F : R 3 → R 2 : F(q) = (f(q),g(q)) . Since S 1 and S 2 intersect transversally, the normal vectors (f x ,f y ,f z ) and (g x ,g y ,g z ) are linearly independent. Thus, ( 0 , 0 ) is a regular value of F and S 1 ∩ S 2 is a regular curve (cf. Exercise 17, Sec. 2-2).

20. The equation of the tangent plane at (x 0 ,y 0 ,z 0 ) is

$$
\frac { x x _ { 0 } } { a ^ { 2 } } + \frac { y y _ { 0 } } { b ^ { 2 } } + \frac { z z _ { 0 } } { c ^ { 2 } } = 1 .
$$

The line through O and perpendicular to the tangent plane is given by

$$
\frac { x a ^ { 2 } } { x _ { 0 } } = \frac { y b ^ { 2 } } { y _ { 0 } } = \frac { z c ^ { 2 } } { z _ { 0 } } .
$$

From the last expression, we obtain

$$
\frac { x ^ { 2 } a ^ { 2 } } { x x _ { 0 } } = \frac { y ^ { 2 } b ^ { 2 } } { y y _ { 0 } } = \frac { z ^ { 2 } c ^ { 2 } } { z z _ { 0 } } = \frac { a ^ { 2 } x ^ { 2 } + b ^ { 2 } y ^ { 2 } + c ^ { 2 } z ^ { 2 } } { x x _ { 0 } + y y _ { 0 } + z z _ { 0 } } . \\ \intertext { t h o s o m o x p r a c i o n }
$$

From the same expression, and taking into account the equation of the ellipsoid, we obtain

$$
\frac { x x _ { 0 } } { x _ { 0 } ^ { 2 } / a ^ { 2 } } = \frac { y y _ { 0 } } { y _ { 0 } ^ { 2 } / b ^ { 2 } } = \frac { z z _ { 0 } } { z _ { 0 } ^ { 2 } / c ^ { 2 } } = \frac { x x _ { 0 } + y y _ { 0 } + z z _ { 0 } } { 1 } .
$$

Again from the same expression and using the equation of the tangent plane, we obtain

$$
\frac { x ^ { 2 } } { ( x _ { 0 } x ) / a ^ { 2 } } = \frac { y ^ { 2 } } { ( y _ { 0 } y ) / b ^ { 2 } } = \frac { z ^ { 2 } } { ( z _ { 0 } z ) / c ^ { 2 } } = \frac { x ^ { 2 } + y ^ { 2 } + z ^ { 2 } } { 1 } .
$$

[Page 503]

The right-hand sides of the three last equations are therefore equal, and hence the asserted equation.

- 21. Imitate the proof of Prop. 9 of the appendix to Chap. 2.
- 22. Let r be the ﬁxed line which is met by the normals of S and let p ∈ S . The plane P 1 , which contains p and r , contains all the normals to S at the points of P 1 ∩ S . Consider a plane P 2 passing through p and perpendicular to r . Since the normal through p meets r , P 2 is transversal to T p (S) ; hence, P 2 ∩ S is a regular plane curve C in a neighborhood of p (cf. Exercise 17, Sec. 2-4). Furthermore P 1 ∩ P 2 is perpendicular to T p (S) ∩ P 2 ; hence, P 1 ∩ P 2 is normal to C . It follows that the normals of C all pass through a ﬁxed point q = r ∩ P 2 ; hence, C is contained in a circle (cf. Exercise 4, Sec. 1-5). Thus, every p ∈ S has a neighborhood contained in some surface of revolution with axis r .


# SECTION 2-5

8. Since ∂E/∂v = 0, E = E(u) is a function of u alone. Set ¯ u =   √ E du . Similarly, G = G(v) is a function of v alone, and we can set ¯ v =   √ Gdv . Thus, ¯ u and ¯ v measurearclengthsalongthecoordinatecurves, whence ¯ E = ¯ G = 1, ¯ F = cos θ . 9. Parametrize the generating curve by arc length.

Parametrize the generating curve by arc length.

# SECTION 3-2

13. Since the osculating plane is normal to N , N ′ = τn and, therefore, τ 2 = | N ′ | 2 = k 2 1 cos 2 θ + k 2 2 sin 2 θ , where θ is the angle of e 1 with the tangent to the curve. Since the direction is asymptotic, we obtain cos 2 θ and sin 2 θ as functions of k 1 and k 2 , which substituted in the expression above yields τ 2 = − k 1 k 2 . 14. By setting λ 1 λ 1 N 2 and λ 2 λ 2 N 1 we have that

By setting λ 1 = λ 1 N 2 and λ 2 = λ 2 N 1 we have that

$$
| \lambda _ { 1 } - \lambda _ { 2 } | & = k | \langle n , N _ { 1 } \rangle N _ { 2 } - \langle n , N _ { 2 } \rangle N _ { 1 } | \\ & = \sqrt { \lambda _ { 1 } ^ { 2 } + \lambda _ { 2 } ^ { 2 } - 2 \lambda _ { 1 } \lambda _ { 2 } \cos \theta } . \\
$$

On the other hand,

$$
| \sin \theta | & = | N _ { 1 } \wedge N _ { 2 } | = | n \wedge ( N _ { 1 } \wedge N _ { 2 } ) | \\ & = | \langle n , N _ { 2 } \rangle N _ { 1 } - \langle n , N _ { 1 } \rangle N _ { 2 } | .
$$

16. Intersect the torus by a plane containing its axis and use Exercise 15.

[Page 504]

$$
\sigma ( \theta ) = 1 + \cos ^ { 2 } \theta + \cdots + \cos ^ { 2 } ( m - 1 ) \theta = \frac { m } { 2 } ,
$$

which may be proved by observing that

$$
\sigma ( \theta ) = \frac { 1 } { 4 } \left ( \sum _ { v = - ( m - 1 ) } ^ { v = m - 1 } e ^ { 2 v i \theta } + 2 m + 1 \right ) \\
$$

and that the expression under the summation sign is the sum of a geometric progression, which yields

$$
\frac { \sin ( 2 m \theta - \theta ) } { \sin \theta } = - 1 .
$$

19. a. Express t and h in the basis { e 1 ,e 2 } given by the principal directions, and compute   dN(t),h   . b. Differentiate cos θ N,n , use that dN(t) k t τ h , and

Differentiate cos θ = 〈 N,n 〉 , use that dN(t) = -kn t + τgh , and observe that 〈 N,b 〉 = 〈 h, N 〉 = sin θ , where b is the binormal vector.

20. geodesic torsions of C 1 = S 2 ∩ S 3 relative to S 2 and S 3 are equal; it will be denoted by τ 1 . Similarly, τ 2 denotes the geodesic torsion of C 2 = S 1 ∩ S 3 and τ 3 that of S 1 ∩ S 2 . Use the deﬁnition of τ g to show that, since C 1 ,C 2 ,C 3 are pairwise orthogonal, τ 1 + τ 2 = 0, τ 2 + τ 3 = 0, τ 3 + τ 1 = 0. It follows that τ 1 = τ 2 = τ 3 = 0.

# SECTION 3-3

2. Asymptotic curves: u = const . , v = const . Lines of curvature:

$$
& \log ( v + \sqrt { v ^ { 2 } + c ^ { 2 } } ) \pm u = c o n s t . \\ u - v = c o n s t .
$$

u + v = const . u -v = const .

axis and a normal to r as the x axis, we have that √ 2

$$
z ^ { \prime } = \frac { \sqrt { 1 - x ^ { 2 } } } { x } .
$$

By setting x = sin θ , we obtain 2

$$
z ( \theta ) = \int \frac { \cos ^ { 2 } \theta } { \sin \theta } \, d \theta = \log \tan \frac { \theta } { 2 } + \cos \theta + C . \\ \pi ( 2 ) = 0 \, \text {then} \, C = 0
$$

If z(π/ 2 ) = 0, then C = 0.

[Page 505]

8. a. The assertion is clearly true if x = x 1 and ¯ x = ¯ x 1 are parametrizations that satisfy the deﬁnition of contact. If x and ¯ x are arbitrary, observe that x = x 1 ◦ h , where h is the change of coordinates. It follows that the partial derivatives of f ◦ x = f ◦ x 1 ◦ h are linear combinations of the partial derivatives of f ◦ x 1 . Therefore, they become zero with the latter ones.

b. Introduce parametrizations x (x,y) = (x,y,f(x,y)) and ¯ x (x,y) = (x,y, ¯ f (x,y)) , and deﬁne a function h(x,y,z) = f (x,y) − z . Observe that h ◦ x = 0 and h ◦ ¯ x = f − ¯ f . It follows from part a, applied the function h , that f − ¯ f has partial derivatives of order ≤ 2 equal to zero at ( 0 , 0 ) .

d. Sincecontactoforder ≥ 2impliescontactoforder ≥ 1, theparaboloid passesthrough p andistangenttothesurfaceat p . Bytakingtheplane T p (S) as the xy plane, the equation of the paraboloid becomes

$$
\bar { f } ( x , y ) = a x ^ { 2 } + 2 b x y + c y ^ { 2 } + d x + e y .
$$

Let z = f (x,y) be the representation of the surface in the plane T p (S) . By using part b, we obtain that d = c = 0, a = 1 2 f xx , b = f xy , c = 1 2 f yy . there exists such an example, it may locally be written in the form

If there exists such an example, it may locally be written in the form z = f(x, y) , with f( 0 , 0 ) = 0, fx( 0 , 0 ) = fy( 0 , 0 ) = 0. The given conditions require that f 2 xx + f 2 yy /negationslash= 0 at ( 0 , 0 ) and that fxx fyy -f 2 xy = 0 if and only if (x, y) = ( 0 , 0 ) .

a function of x alone and β(y) is a function of y alone, we verify that α xx = cos x , β yy = cos y satisfy the conditions above. It follows that

$$
f ( x , y ) = \cos x + \cos y + x y - 2
$$

is such an example.

16. Takeaspherecontainingthesurfaceanddecreaseitsradiuscontinuously. Study the normal sections at the point (or points) where the sphere meets the surface for the ﬁrst time.

19. Show that the hyperboloid contains two one-parameter families of lines which are necessarily the asymptotic lines. To ﬁnd such families of lines, write the equation of the hyperboloid as

$$
( x + z ) ( x - z ) = ( 1 - y ) ( 1 + y )
$$

and show that, for each k  = 0, the line x + z = k( 1 + y) , x − z = ( 1 /k)( 1 − y) belongs to the surface.

[Page 506]

$$
\left \langle \frac { d ( f N ) } { d t } \wedge \frac { d \alpha } { d t } , N \right \rangle = 0
$$

for every curve α(t) = (x(t),y(t),z(t)) on the surface. Assume that z  = 0, multiplythisequationby z/c 2 , andeliminate z and dz/dt (observe that the equation holds for every tangent vector on the surface). Four umbilical points are found, namely,

$$
y = 0 , \quad x ^ { 2 } = a ^ { 2 } \frac { a ^ { 2 } - b ^ { 2 } } { a ^ { 2 } - c ^ { 2 } } , \quad z ^ { 2 } = c ^ { 2 } \frac { b ^ { 2 } - c ^ { 2 } } { a ^ { 2 } - c ^ { 2 } } . \\ \quad \cdot \quad \cdot \quad 0 , \quad 0 , \quad \cdot \quad \cdot \quad 1 , \quad \cdot \quad \cdot \quad 1 , \quad \cdot \quad \cdot \quad 1 , \quad \cdot \quad \cdot \quad 0
$$

The hypothesis z = 0 does not yield any further umbilical points.

a. Let dN (v 1 ) = av 1 + bv 2 , dN (v 2 ) = cv 1 + dv 2 . A direct computation yields

$$
\langle d ( f N ) ( v _ { 1 } ) \wedge d ( f N ) ( v _ { 2 } ) , f N \rangle = f ^ { 3 } \det ( d N ) .
$$

b. Show that fN = (x/a 2 ,y/b 2 ,z/c 2 ) = W , and observe that

$$
d ( \alpha _ { 1 } ) = \left ( \frac { \alpha _ { i } } { a ^ { 2 } } , \frac { \beta _ { i } } { b ^ { 2 } } , \frac { \gamma _ { i } } { c ^ { 2 } } \right ) , \quad \text {where } v _ { 1 } = ( \alpha _ { i } , \beta _ { i } , \gamma _ { i } ) ,
$$

i = 1 , 2. By choosing v 1 so that v 1 ∧ v 2 = N , conclude that

$$
\langle d ( f N ) ( v _ { 1 } ) \wedge d f ( N ) ( v _ { 2 } ) , f N \rangle = \frac { \langle W , X \rangle } { a ^ { 2 } b ^ { 2 } c ^ { 2 } } \frac { 1 } { f } ,
$$

where X = (x, y, z) , and therefore 〈 W,X 〉 = 1.

24. d. O is at p ∈ S , the xy plane agrees with T p (S) , and the positive direction of the z axis agrees with the orientation of S at p . Furthermore, choose the x and y axes in T p (S) along the principal directions at p . If V is sufﬁciently small, it can then be represented as the graph of a differentiable function 2

$$
z = f ( x , y ) , \ ( x , y ) \in D \subset R ^ { 2 } ,
$$

where D is an open disk in R 2 and

$$
f _ { x } ( 0 , 0 ) = f _ { y } ( 0 , 0 ) = f _ { x y } ( 0 , 0 ) = 0 , \ f _ { x x } ( 0 , 0 ) = k _ { 1 } , \ f _ { y y } ( 0 , 0 ) = k _ { 2 } .
$$

We can assume, without loss of generality, that k 1 ≥ 0 and k 2 ≥ 0 on D , and we want to prove that f (x,y) ≥ 0 on D .

[Page 507]

Assume that, for some ( ¯ x, ¯ y) ∈ D , f ( ¯ x, ¯ y) < 0. Consider the function h 0 (t) = f (t ¯ x,t ¯ y) , 0 ≤ t ≤ 1. Since h ′ 0 ( 0 ) = 0, there exists a t 1 , 0 ≤ t 1 ≤ 1, such that h ′′ 0 (t 1 ) < 0, Let p 1 = (t 1 ¯ x,t 1 ¯ y,f (t 1 ¯ x,t 1 ¯ y)) ∈ S , and consider the height function h 1 of V relative to the tangent plane T p 1 (S) at p 1 . Restricted to the curve α(t) = (t ¯ x,t ¯ y,f (t ¯ x,t ¯ y)) , this height function is h 1 (t) =   α(t) − p 1 ,N 1   , where N 1 is the unit normal vector at p 1 . Thus, h ′′ 1 (t) =   α ′′ (t),N 1   , and, at t = t 1 ,

$$
h _ { 1 } ^ { \prime \prime } ( t _ { 1 } ) = \langle ( 0 , 0 , h _ { 0 } ^ { \prime \prime } ( t _ { 1 } ) ) , ( - f _ { x } ( p _ { 1 } ) , - f _ { y } ( p _ { 1 } ) , 1 ) \rangle = h _ { 0 } ^ { \prime \prime } ( t _ { 1 } ) < 0 .
$$

But h ′′ 1 (t 1 ) =   α ′′ (t 1 ),N 1   is, up to a positive factor, the normal curvature at p 1 , in the direction of α ′ (t 1 ) . This is a contradiction.

# SECTION 3-4

c.

Reduce the problem to the fact that if λ is an irrationa1 number and m and n run through the integers, the set { λm + n } is dense in the real line. To prove the last assertion, it sufﬁces to show that the set { λm + n } has arbitrarily small positive elements. Assume the contrary, show that the greatest lower bound of the positive elements of { λm + n } still belongs to that set, and obtain a contradiction. Consider the set α : I U of trajectories of w , with α ( 0 ) p , and

⋃ = αi ∈ Ii

Consider the set { αi : Ii → U } of trajectories of w , with αi ( 0 ) = p , and set I = i Ii . By uniqueness, the maximal trajectory α : I → U may be defined by setting α(t) (t) , where t .

For every , there exist a neighborhood of and an interval

( − ǫ,ǫ) , ǫ > 0, such that the trajectory α(t) , with α( 0 ) = q , is deﬁned in ( − ǫ,ǫ) . By compactness, it is possible to cover S with a ﬁnite number of such neighborhoods. Let ǫ 0 = minimum of the corresponding ǫ ’s. If α(t) is deﬁned for t < t 0 and is not deﬁned for t 0 , take t 1 ∈ ( 0 ,t 0 ) , with | t 0 − t 1 | < ǫ 0 / 2. Consider the trajectory β(t) of w , with β(t 1 ) = α(t 1 ) , and obtain a contradiction.

# SECTION 4-2

3. The “only if” part is immediate.To prove the “if” part, let

[Page 508]

6. Parametrize α by arc length s in a neighborhood of t 0 . Construct in the plane a curve with curvature k = k(s) and apply Exercise 5. 8. Set 0 ( 0 , 0 , 0 ) , G( 0 ) p 0 , and G(p) p 0 F(p) . Then F : R 3 R 3

= = − = → is a map such that F( 0 ) = 0 and | F(p) | = | G(p) − G( 0 ) | = | p | . This implies that F preserves the inner product of R 3 . Thus, it maps the basis

$$
\{ ( 1 , 0 , 0 ) = f _ { 1 } , ( 0 , 1 , 0 ) = f _ { 2 } , ( 0 , 0 , 1 ) = f _ { 3 } \}
$$

onto an orthonormal basis, and if p =   a i f i , i = 1 , 2 , 3, then F(p) =   α i F(f i ) . Therefore, F is linear. a. Since F is distance-preserving and the arc length of a differentiable

∑ 11. a. Since F is distance-preserving and the arc length of a differentiable curve is the limit of the lengths of inscribed polygons, the restriction F | S preserves the arc length of a curve in S .

Consider the isometry of an open strip of the plane onto a cylinder minus a generator.

12. The restriction of F(x,y,z) = (x, − y, − z) to C is an isometry of C (cf. Exercise 11), the ﬁxed points of which are ( 1 , 0 , 0 ) and ( − 1 , 0 , 0 ) . 17. The loxodromes make a constant angle with the meridians of the sphere.

Under Mercator’s projection (see Exercise 16) the meridians go into parallel straight lines in the plane. Since Mercator’s projection is conformal, the loxodromes also go into straight lines. Thus, the sum of the interior angles of the triangle in the sphere is the same as the sum of the interior angles of a rectilinear plane triangle.

# SECTION 4-4

6. Use the fact that the absolute value of the geodesic curvature is the absolute value of the projection onto the tangent plane of the usual curvature.

- 8. Use Exercise 1, part b, and Prop. 4 of Sec. 3-2.
- 9. Usethefactthatthemeridiansaregeodesicsandthattheparalleltransport preserves angles.


10. Apply the relation k 2 g + k 2 n = k 2 and the Meusnier theorem to the projecting cylinder.

12. Parametrize a neighborhood of p ∈ S in such a way that the two families of geodesics are coordinate curves (Corollary 1, Sec. 3-4). Show that this implies that F = 0, E v = 0 = G u . Make a change of parameters to obtain that ¯ F = 0, ¯ E = ¯ G = 1. 13. Fix two orthogonal unit vectors v(p) and w(p) in T (S) and parallel

[Page 509]

directions of these vectors are tangent to the coordinate curves, which are then geodesics. Apply Exercise 12.

16. Parametrize a neighborhood of p ∈ S in such a way that the lines of curvature are the coordinate curves and that v = const . are the asymptotic curves. It follows that e v = 0, and from the Mainardi-Codazzi equations, we conclude that E v = 0. This implies that the geodesic curvature of v = const . is zero. For the example, look at the upper parallel or the torus.

- 18. Use Clairaut’s relation (cf. Example 5).
- 19. Substitute in Eq. (4) the Christoffel symbols by their values as functions of E , F , and G and differentiate the expression of the ﬁrst fundamental form:

$$
1 = E ( u ^ { \prime } ) ^ { 2 } + 2 F u ^ { \prime } v ^ { \prime } + G ( v ^ { \prime } ) ^ { 2 } .
$$

- 20. Use Clairaut’s relation.


# SECTION 4-5

4. b. Observe that the map x = ¯ x , y = ( ¯ y) 5 , z = ( ¯ z) 3 gives a homeomorphism of the sphere x 2 + y 2 + z 2 = 1 onto the surface ( ¯ x) 2 + ( ¯ y) 10 + ( ¯ z) 6 = 1. 6. a. Restrict v to the curve α(t) ( cos t, sin t) , t [0 , 2 π ]. The angle

a. Restrict v to the curve α(t) = ( cos t, sin t) , t ∈ [0 , 2 π ]. The angle that v(t) forms with the x axis is t . Thus, 2 πI = 2 π ; hence, I = 1.

= ∈ obtain v(t) = ( cos 2 t − sin 2 t, − 2cos t sin t) = ( cos2 t, − sin 2 t) . Thus, I = − 2.

# SECTION 4-6

8. Let (ρ,θ) be a system of geodesic polar coordinates such that its pole is one of the vertices of   and one of the sides of   corresponds to θ = 0. Let the two other sides be given by θ = θ 0 and ρ = h(θ) . Since the vertex that corresponds to the pole does not belong to the coordinate neighborhood, take a small circle of radius ǫ around the pole. Then

$$
\iint _ { \Delta } K \sqrt { G } \, d \rho \, d \theta = \int _ { 0 } ^ { \theta _ { 0 } } d \theta \left ( \lim _ { \epsilon \to 0 } \int _ { \epsilon } ^ { h ( \theta ) } K \sqrt { G } \, d \rho \right ) .
$$

[Page 510]

Observing that K √ G = − ( √ G) ρρ and that lim ǫ → 0 ( √ G) ρ = 1, we have that the limit enclosed in parentheses is given by

$$
1 - \frac { \partial ( \sqrt { G } ) } { \partial \rho } ( h ( \theta ) , \theta ) .
$$

By using Exercise 7, we obtain

$$
\text {By using EXCEPT} \, , \text {we obtain} \\ \iint _ { \Delta } K \sqrt { G } \, d \rho \, d \theta = \int _ { 0 } ^ { \theta _ { 0 } } d \theta - \int _ { 0 } ^ { \theta _ { 0 } } d \varphi \\ = \alpha _ { 3 } - ( \pi - \alpha _ { 2 } - \alpha _ { 1 } ) = \sum _ { 1 } ^ { 3 } \alpha _ { i } - \pi . \\ \text {c. For K} \equiv 0 , \text {the problem is trivial. For K} > 0 , \text {use part b. For K} <
$$

$$
\pi _ { ^ { * } }
$$

12. c. For K ≡ 0, the problem is trivial. For K > 0, use part b. For K < 0, consider a coordinate neighborhood V of the pseudosphere (cf. Exercise 6, part b, Sec. 3-3), parametrized by polar coordinates (ρ,θ) ; that is, E = 1 , F = 0, G = sinh 2 ρ . Compute the geodesics of V ; it is convenient to use the change of coordinates tanh ρ = 1 /w , ρ  = 0, θ = θ , so that 1 1

$$
1 \intertext { 1 } G = 1
$$

$$
E & = \frac { 1 } { ( w ^ { 2 } - 1 ) ^ { 2 } } , \quad G = \frac { 1 } { w ^ { 2 } - 1 } , \quad F = 0 , \\ \Gamma _ { 1 1 } ^ { 1 } & = - \frac { 2 w } { w ^ { 2 } - 1 } , \quad \Gamma _ { 1 2 } ^ { 1 } = - \frac { w } { w ^ { 2 } - 1 } , \quad \Gamma _ { 2 2 } ^ { 1 } = w ,
$$

$$
\Gamma _ { 1 1 } ^ { 1 } = - \frac { 2 w } { w ^ { 2 } - 1 } , \quad \Gamma _ { 1 2 } ^ { 1 } = - \frac { w } { w ^ { 2 } - 1 } , \quad \Gamma _ { 2 2 } ^ { 1 } = w , \\ \text {one other Christoffel symbols are zero. It follows that the}
$$

and the other Christoffel symbols are zero. It follows that the nonradial geodesics satisfy the equation (d 2 w/dθ 2 ) + w = 0, where w = w(θ) . Thus, w = A cos θ + B sin θ ; that is

A tanh ρ cos θ + B tanh ρ sin θ = 1 . 2

Therefore, the map of V into R given by

ξ = tanh ρ cos θ, η = tanh ρ sin θ,

(ξ,η) ∈ R 2 , is a geodesic mapping. Deﬁne x ϕ − 1 : ϕ(U) R 2 S .

13. b. = ⊂ → Let v = v(u) be a geodesic in U . Since ϕ is a geodesic mapping and the geodesics of R 2 are lines, then d 2 v/du 2 ≡ 0. By bringing this condition into part a, the required result is obtained.

c. Equation (a) is obtained from Eq. (5) of Sec. 4-3 using part b. From Eq. (5a) of Sec. 4-3 together with part b we have

$$
K F & = ( \Gamma _ { 1 2 } ^ { 1 } ) _ { u } - 2 ( \Gamma _ { 1 2 } ^ { 2 } ) _ { v } + \Gamma _ { 1 2 } ^ { 2 } \Gamma _ { 1 2 } ^ { 1 } . \\
$$

By interchanging u and v in the expression above and subtracting the results, we obtain (Ŵ 1 12 ) u = (Ŵ 2 12 ) v , whence Eq. (b). Finally,

[Page 511]

d. By differentiating Eq. (a) with respect to v , Eq. (b) with respect to u , and subtracting the results, we obtain

$$
E K _ { v } - F K _ { u } = - K ( E _ { v } - F _ { u } ) + K ( - F \Gamma _ { 1 2 } ^ { 2 } + E \Gamma _ { 1 2 } ^ { 1 } ) .
$$

By taking into account the values of Ŵ k ij , the expression above yields

$$
E K _ { v } - F K _ { u } = - K ( E _ { v } - F _ { u } ) + K ( E _ { v } - F _ { u } ) = 0 .
$$

Similarly, from Eqs. (c) and (d) we obtain FK v − GK u = 0, whence K v = K u = 0.

# SECTION 4-7

1. Consider an orthonormal basis { e 1 ,e 2 } at T α( 0 ) (S) and take the parallel transport of e 1 and e 2 along α , obtaining an orthonormal basis { e 1 (t),e 2 (t) } at each T α(t) (S) . Set w(α(t)) = w 1 (t)e 1 (t) + w 2 (t)e 2 (t) . Then D y w = w ′ 1 ( 0 )e 1 + w ′ 2 ( 0 )e 2 and the second member is the velocity of the curve w 1 (t)e 1 + w 2 (t)e 2 in T p (S) at t = 0. 2. b. Show that if (t 1 ,t 2 ) I is small and does not contain “break points

⊂ of α ,” then the tangent vector ﬁeld of α((t 1 ,t 2 )) can be extended to a vector ﬁeld y in a neighborhood of α((t 1 ,t 2 )) . Thus, by restricting v and w to α , property 3 becomes

$$
\frac { d } { d t } \langle v ( t ) , w ( t ) \rangle = \left \langle \frac { D v } { d t } , w \right \rangle + \left \langle v , \frac { D w } { d t } \right \rangle , \\
$$

which implies that parallel transport in α | (t 1 ,t 2 ) is an isometry. By compactness, thiscanbeextendedtotheentire I . Conversely, assume that parallel transport is an isometry. Let α be the trajectory of y through a point p ∈ S . Restrict v and w to α . Choose orthonormal basis { e 1 (t),e 2 (t) } as in the solution of Exercise 1, and set v(t) = v 1 e 1 + v 2 e 2 , w(t) = w 1 e 1 + w 2 e 2 . Then property 3 becomes the “product rule”:

$$
\frac { d } { d t } \left ( \sum _ { i } v _ { i } w _ { i } \right ) = \sum _ { i } \frac { d v _ { i } } { d t } w _ { i } + \sum _ { i } v _ { i } \frac { d w _ { i } } { d t } , \quad i = 1 , 2 . \\ \\ \intertext { d t } \intertext { d i } \intertext { d w } \intertext { d h } \intertext { d w } \intertext { d h }
$$

c. Let D be given and choose an orthogonal parametrization x (u,v) . Let y = y 1 x u + y 2 x v , w = w 1 x u + w 2 x v . From properties 1, 2, and 3, it follows that D y w is determined by the knowledge of D x u x u ,

[Page 512]

D x u x v , D x v x v . Set D x u x u = A 1 11 x u + A 2 11 x v , D x u x v = A 1 12 x u + A 2 12 x v , D x v x v = A 1 22 x u + A 2 22 x v . From property 3 it follows that the A k ij satisfy the same equations as the Ŵ k ij (cf. Eq. (2), Sec. 4-3). Thus, A k ij = Ŵ k ij , which proves that D y v agrees with the operation “Take the usual derivative and project it onto the tangent plane.”

# 3. a. Observe that

$$
d x _ { ( 0 , t ) } ( 1 , 0 ) & = \left ( \frac { \partial x } { \partial s } \right ) _ { s = 0 } = \frac { d } { d s } \gamma ( s , \alpha ( t ) , v ( t ) ) \Big | _ { s = 0 } = v ( t ) , \\ d x _ { ( 0 , t ) } ( 0 , 1 ) & = \left ( \frac { \partial x } { \partial t } \right ) _ { s = 0 } = \alpha ^ { \prime } ( t ) . \\
$$

$$
v ( t ) ,
$$

b. Use the fact that x is a local diffeomorphism to cover the compact

set I with a family of open intervals in which x is one-to-one. Use the Heine-Borel theorem and the Lebesgue number of the covering (cf. Sec. 2-7) to globalize the result.

c. To show that F = 0, we compute (cf. property 4 of Exercise 2)

$$
\frac { d } { d s } F = \frac { d } { d s } \left \langle \frac { \partial x } { \partial s } , \frac { \partial x } { \partial t } \right \rangle = \left \langle \frac { D } { \partial s } \frac { \partial x } { \partial s } , \frac { \partial x } { \partial t } \right \rangle + \left \langle \frac { \partial x } { \partial s } , \frac { D } { \partial s } \frac { \partial x } { \partial t } \right \rangle = \left \langle \frac { \partial x } { \partial s } , \frac { D } { \partial t } \frac { \partial x } { \partial s } \right \rangle ,
$$

because the vector ﬁeld ∂ x /∂s is parallel along t = const . Since

$$
0 = \frac { d } { d t } \left \langle \frac { \partial x } { \partial s } , \frac { \partial x } { \partial s } \right \rangle = 2 \left \langle \frac { D } { \partial t } \frac { \partial x } { \partial s } , \frac { \partial x } { \partial s } \right \rangle ,
$$

F does not depend on s . Since F( 0 ,t) = 0, we have F = 0. This is a consequence of the fact that F 0.

This is a consequence of the fact that F = 0.

a. Use Schwarz's inequality,

$$
\left ( \int _ { a } ^ { b } f g \, d t \right ) ^ { 2 } \leq \int _ { a } ^ { b } f ^ { 2 } \, d t \int _ { a } ^ { b } g ^ { 2 } \, d t ,
$$

with f ≡ 1 and g = | dα/dt | . By noticing that E(t) l

5. a. =   0 { (∂u/∂v) 2 + G(γ(v,t),v) } dv , we obtain (we write γ(v,t) = u(v,t) , for convenience)

$$
E ^ { \prime } ( t ) = \int _ { 0 } ^ { l } \left \{ 2 \frac { \partial u } { \partial v } \frac { \partial ^ { 2 } u } { \partial v \partial t } + \frac { \partial G } { \partial u } u ^ { \prime } \right \} d v .
$$

$$
\L ) = \int _ { 0 } ^ { l } \left \{ 2 \frac { \partial u } { \partial v } \frac { \partial ^ { 2 } u } { \partial v \partial t } + \frac { \partial G } { \partial u } u ^ { \prime } \right \} d v .
$$

0, we have proved the

Since, for t = 0, ∂u/∂v = 0 and ∂G/∂u = ﬁrst part.

[Page 513]

Furthermore,

$$
E ^ { \prime \prime } ( t ) = \int _ { 0 } ^ { l } \left \{ 2 \left ( \frac { \partial ^ { 2 } u } { \partial v \partial t } \right ) ^ { 2 } + 2 \frac { \partial u } { \partial v } \frac { \partial ^ { 3 } u } { \partial v \partial ^ { 2 } t } + \frac { \partial ^ { 2 } G } { \partial u ^ { 2 } } ( u ^ { \prime } ) ^ { 2 } + \frac { \partial G } { \partial u } u ^ { \prime \prime } \right \} d v .
$$

Hence, by using G uu = − 2 K √ G and noting that √ G = 1 for t = 0, we obtain l 2

$$
E ^ { \prime \prime } ( 0 ) = 2 \int _ { 0 } ^ { l } \left \{ \left ( \frac { d \eta } { d v } \right ) ^ { 2 } - K \eta ^ { 2 } \right \} \, d v .
$$

6. b. Choose ǫ > 0 and coordinates in R 3 ⊃ S so that ϕ(ρ,ǫ) = q . Consider the points (ρ,ǫ) = r 0 , (ρ,ǫ + 2 π sin β) = r 1 ,...,(ρ,ǫ + 2 πk sin β) = r k . Taking ǫ sufﬁciently small, we see that the line segments r 0 r 1 ,..., r 0 r k belong to V if 2 πk sin β < π (Fig. 4-49). Since ϕ is a local isometry, the images of these segments will be geodesics joining q to q , which are clearly broken at q (Fig. 4-49).

c. It must be proved that each geodesic γ : [0 ,l ] → S with γ( 0 ) = γ(l) = q is the image by ϕ of one of the line segments r 0 r 1 ,..., r 0 r k referred to in part b. For some neighborhood U ⊂ V of r 0 , the restriction ϕ | U = ˜ ϕ is an isometry. Thus, ˜ ϕ − 1 ◦ γ is a segment of a half-line L starting at r 0 . Since ϕ(L) is a geodesic which agrees with γ( [0 ,l ] ) in an open interval, it agrees with γ where γ is deﬁned. Since γ(l) = q , L passes through one of the points r i , i = 1 ,...,k , say r j , and so γ is the image of r 0 r j .

# SECTION 5-2

3. a. Use therelation ϕ ′′ = − Kϕ toobtain (ϕ ′ 2 + Kϕ 2 ) ′ = K ′ ϕ 2 . Integrate both sides of the last relation and use the boundary conditions of the statement.

# SECTION 5-3

5. Assume that every Cauchy sequence in d converges and let γ(s) be a geodesic parametrized by arc length. Suppose, by contradiction, that γ(s) is deﬁned for s < s 0 but not for s = s 0 . Choose a sequence { s n } → s 0 . Thus, given ǫ > 0, there exists n 0 such that if n,m > n 0 , | s n − s m | < ǫ . Therefore,

$$
d ( \gamma ( s _ { m } ) , \gamma ( s _ { n } ) ) & \leq | s _ { n } - s _ { m } | < \epsilon \\ \\ \intertext { d ( \gamma ( s _ { m } ) , \gamma ( s _ { n } ) ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { m } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \intertext { d ( s _ { n } ) } \
$$

and { γ(sn) } is a Cauchy sequence in d . Let { γ(sn) } → p 0 ∈ S and let W be a neighborhood of p 0 as given by Prop. 1 of Sec. 4-7. If m,n are sufficiently large, the small geodesic joining γ(sm) to γ(sn) clearly agrees with γ . Thus, γ can be extended through p 0 , a contradiction.

[Page 514]

0 Conversely, assume that S is complete and let { p n } be a Cauchy sequence in d of points on S . Since d is greater than or equal to the Euclidean distance ¯ d , { p n } is a Cauchy sequence in ¯ d . Thus, { p n } converges to p 0 ∈ R 3 . Assume, by contradiction, that p 0  ∈ S . Since a Cauchy sequence is bounded, given ǫ > 0 there exists an index n 0 such that, for all n > n 0 , the distance d(p n 0 ,p n ) < ǫ . By the Hopf-Rinow theorem, there is a minimal geodesic γ n joining p n 0 to p n with length < ǫ . As n → ∞ , γ n tends to a minimal geodesic γ with length ≤ ǫ . Parametrize γ by arc length s . Then, since p 0  ∈ S , γ is not deﬁned for s = ǫ . This contradicts the completeness of S . Let p be a sequence of points on S such that d(p,p ) . Since

6. { n } n → ∞ S is complete, there is a minimal geodesic γ n (s) (parametrized by arc length) joining p to p n with γ n ( 0 ) = p . The unit vectors γ ′ n ( 0 ) have a limit point v on the (compact) unit sphere of T p (S) . Let γ(s) = exp p sv , s ≥ 0. Then γ(s) is a ray issuing from p . To see this, notice that, for a ﬁxed s 0 and n sufﬁciently large, lim n →∞ γ n (s 0 ) = γ(s 0 ) . This follows from the continuous dependence of geodesics from the initial conditions. Furthermore, since d is continuous,

$$
\lim _ { n \to \infty } d ( p , \gamma _ { n } ( s _ { 0 } ) ) = d ( p , \gamma ( s _ { 0 } ) ) .
$$

But if n is large enough, d(p,γ n (s 0 )) = s 0 . Thus, d(p,γ(s 0 )) = s 0 , and γ is a ray.

- 8. Firstshowthatif d and ¯ d denotetheintrinsicdistancesof S and ¯ S , respectively, then d(p,q) ≥ c ¯ d(ϕ(p),ϕ(q)) for all p,q ∈ S . Now let { p n } be a Cauchy sequence in d of points on S . By the initial remark, { ϕ(p n ) } is a Cauchysequencein ¯ d . Since ¯ S iscomplete, { ϕ(p n ) } → ϕ(p 0 ) . Since ϕ − 1 is continuous, { p n } → p 0 . Thus, every Cauchy sequence in d converges; hence S is complete (cf. Exercise 5).
- 9. ϕ is one-to-one : Assume, by contradiction, that p 1  = p 2 ∈ S 1 are such that ϕ(p 1 ) = ϕ(p 2 ) = q . Since S 1 is complete, there is a minimal geodesic γ joining p 1 to p 2 . Since ϕ is a local isometry, ϕ ◦ γ is a geodesic joining q to itself with the same length as γ . Any point distinct from q on ϕ ◦ γ can be joined to q by two geodesics, a contradiction. ϕ is onto : Since ϕ is a local diffeomorphism, ϕ(S 1 ) ⊂ S 2 is an open set


in S 2 . We shall prove that ϕ(S 1 ) is also closed in S 2 ; since S 2 is connected, this will imply that ϕ(S 1 ) = S 2 . If ϕ(S 1 ) is not closed in S 2 , there exists a sequence { ϕ(p n ) } , p n ∈ S 1 , such that { ϕ(p n ) } → p 0 ∈ ϕ(S 1 ) . Thus, { ϕ(p n ) } is a nonconverging Cauchy sequence in ϕ(S 1 ) . Since ϕ is a oneto-one local isometry, { p n } is a nonconverging Cauchy sequence in S 1 , a contradiction to the completeness of S 1 .

[Page 515]

10. a. Since

and

$$
\frac { d } { d t } ( h \circ \varphi ( t ) ) = \frac { d } { d t } \langle \varphi ( t ) , v \rangle = \langle \varphi ^ { \prime } ( t ) , v \rangle = \langle \text {grad} \, h , v \rangle
$$

$$
\frac { d } { d t } ( h \circ \varphi ( t ) ) = d h ( \varphi ^ { \prime } ( t ) ) = d h ( \text {grad} \, h ) = \langle \text {grad} \, h , \text {grad} \, h \rangle ,
$$

we conclude, by equating the last members of the above relations, that | grad h | ≤ 1. Assume that ϕ(t) is deﬁned for t < t 0 but not for t t 0 . Then there

Assume that is defined for but not for . Then there

exists a sequence { t n } → t 0 such that the sequence { ϕ(t n ) } does not converge. If m and n are sufﬁciently large, we use part a to obtain

$$
o ( t _ { m } ) ) & \leq \int _ { t _ { n } } ^ { t _ { m } } | \text {grad} \, h ( \varphi ( t ) ) | \, d t \leq | t _ { m } - t _ { n } | , \\
$$

$$
d ( \varphi ( t _ { m } ) , \varphi ( t _ { m } ) ) \leq \left ( \begin{array} { c | c } | \text {grad} \, h ( \varphi ( t ) ) | \, d t \leq | t _ { m } - t _ { n } | , \end{array} \right )
$$

where d is the intrinsic distance of S . This implies that { ϕ(t n ) } is a nonconverging Cauchy sequence in d , a contradiction to the completeness of S .

# SECTION 5-4

2. Assume that

$$
\lim _ { r \to \infty } ( \inf _ { x ^ { 2 } + y ^ { 2 } \geq r } K ( x , y ) ) = 2 c > 0 .
$$

Then there exists R > 0 such that if (x,y)  ∈ D , where

$$
D = \{ ( x , y ) \in R ^ { 2 } ; x ^ { 2 } + y ^ { 2 } < R ^ { 2 } \} ,
$$

then K(x,y) ≥ c . Thus, by taking points outside the disk D , we can obtain arbitrarily large disks where K(x,y) ≥ c > 0. This is easily seen to contradict Bonnet’s theorem.

# SECTION 5-5

3. b. Assume that a > b and set s = b in relation ( ∗ ) . Use the initial conditions and the facts v ′ (b) < 0, u(b) > 0, uv ≥ 0 in [0 ,b ] to obtain a contradiction.

a contradiction.

c. From [ uv ′ − vu ′ ] s 0 ≥ 0, one obtains v ′ /v ≥ u ′ /u ; that is, ( log v) ′ ≥ ( log u) ′ . Now, let 0 < s 0 ≤ s ≤ a , and integrate the last inequality between s 0 and s to obtain

[Page 516]

$$
\log v ( s ) - \log v ( s _ { 0 } ) & \geq \log u ( s ) - \log u ( s _ { 0 } ) ; \\
$$

that is, v(s)/u(s) ≥ v(s 0 )/u(s 0 ) . Next, observe that ′

$$
\lim _ { s _ { 0 } \to 0 } \frac { v ( s _ { 0 } ) } { u ( s _ { 0 } ) } = \lim _ { s _ { 0 } \to 0 } \frac { v ^ { \prime } ( s _ { 0 } ) } { u ^ { \prime } ( s _ { 0 } ) } = 1 .
$$

Thus, v(s) ≥ u(s) for all s ∈ [0 , a) .

Suppose, by contradiction, that 0 for all 0 ]. By using

Eq. ( ∗ ) of Exercise 3, part b (with ˜ K = L and s = s 0 ), we obtain s 0

$$
\int _ { 0 } ^ { s _ { 0 } } ( K - L ) u v \, d s + u ( s _ { 0 } ) v ^ { \prime } ( s _ { 0 } ) - u ( 0 ) v ^ { \prime } ( 0 ) = 0 . \\ \intertext { s u m e } \text { for instance } \text { that } u ( s ) > 0 \text { and } v ( s ) < 0 \text { on } ( 0 , s - 1 ) \text { .}
$$

Assume, for instance, that u(s) > 0 and v(s) < 0 on ( 0 ,s 0 ]. Then v ′ ( 0 ) < 0 and v ′ (s 0 ) > 0. Thus, the ﬁrst term of the above sum is ≥ 0 and the two remaining terms are > 0, a contradiction.All the other cases can be treated similarly.

8. Let v be the vector space of Jacobi ﬁelds J along γ with the property

that J(l) = 0. v is a two-dimensional vector space. Since γ(l) is not conjugate to γ( 0 ) , the linear map θ : v → T γ( 0 ) (S) given by θ(J) = J( 0 ) is injective, and hence, for dimensional reasons, an isomorphism. Thus, there exists J ∈ v with J( 0 ) = w 0 . By the same token, there exists a Jacobi ﬁeld ¯ J along γ with ¯ J( 0 ) = 0, ¯ J(l) = w 1 . The required Jacobi ﬁeld is given by J + ¯ J .

# SECTION 5-6

10. Let γ : [0 ,l ] → S be a simple closed geodesic on S and let v( 0 )

∈ T γ( 0 ) (S) be such that | v( 0 ) | = 1,   v( 0 ),γ ′ ( 0 )   = 0. Take the parallel transport v(s) of v( 0 ) along γ . Since S is orientable, v(l) = v( 0 ) and v deﬁnes a differentiable vector ﬁeld along γ . Notice that v is orthogonal to γ and that Dv/ds = 0, s ∈ [0 , 1 ) . Deﬁne a variation (with free end points) h : [0 ,l) × ( − ǫ,ǫ) → S by

$$
h ( s , t ) = \exp _ { \gamma ( s ) } t v ( s ) . \\
$$

Check that, for t small, the curves of the variation h t (s) = h(s,t) are closed. Extend the formula for the second variation of arc length to the present case, and show that

$$
L _ { v } ^ { \prime \prime } ( 0 ) = - \int _ { 0 } ^ { t } K d s < 0 . \\ \intertext { s r . } \text {then all curves } h \left ( s \right ) \text { for } t \text { small }
$$

Thus, γ(s) is longer than all curves h t (s) for t small, say, | t | < δ ≤ ǫ . By changing the parameter t into t/δ , we obtain the required homotopy.

[Page 517]

# SECTION 5-7

9. Use the notion of geodesic torsion τ g of a curve on a surface (cf. Exercise 19, Sec. 3-2). Since

$$
\frac { d \theta } { d s } = \tau - \tau _ { g } ,
$$

where cos θ =   N,n   and the curve is closed and smooth, we obtain

$$
\int _ { 0 } ^ { l } \tau \, d s - \int _ { 0 } ^ { l } \tau _ { s } \, d s & = 2 \pi n , \\ \\ \\ \\ \\ \\ \\
$$

where n is an integer. But on the sphere, all curves are lines of curvature. Since the lines of curvature are characterized by having vanishing geodesic torsion (cf. Exercise 19, Sec. 3-2), we have

$$
\int _ { 0 } ^ { l } \tau \, d s & = 2 \pi n . \\ \\
$$

Since every closed curve on a sphere is homotopic to zero, the integer n is easily seen to be zero.

# SECTION 5-10

7. We have only to show that the geodesics γ(s) parametrized by arc length which approach the boundary of R 2 + are deﬁned for all values of the parameter s . If the contrary were true, such a geodesic would have a ﬁnite length l , say, from a ﬁxed point p 0 . But for the circles of R 2 + that are geodesics, we have

$$
l = \left | \lim _ { \epsilon \to 0 } \int _ { \theta _ { 0 } > \pi / 2 } ^ { \epsilon } \frac { d \theta } { \sin \theta } \right | \geq \left | \lim _ { \epsilon \to 0 } \int _ { \theta _ { 0 } > \pi / 2 } ^ { \epsilon } \frac { \cos \theta d \theta } { \sin \theta } \right | = \infty , \\ \intertext { a n d the s a m e h o l d s for the v e r t i cal l n e s of R _ { + } ^ { 2 } . } \mathbf c . \int o r p o r e { t h e m i t h e r c i s o m p l e t a n t i o n s f i r t a t i t d o m i n a t e s } .
$$

∣ ∣ ∣ and the same holds for the vertical lines of R 2 + .

10. ﬁrst that it dominates the Euclidean metric on R 2 . Thus, if a sequence is a Cauchy sequence in the given metric, it is also a Cauchy sequence in the Euclidean metric. Since the Euclidean metric is complete, such a sequence converges. It follows that the given metric is complete (cf. Exercise 1, Sec. 5-3).

[Page 518]

[Page 519]

# Index

|Acceleration vector, 350 Accumulation point, 461|Bonnet, O., 268|
|---|---|
|Accumulation point, 461|Bonnet's theorem, 358, 429|
|Angle:|Boundary of a set, 463|
|between two surfaces, 89 external, 269 interior, 278|Braunmühl, A., 369 Buck, R. C., 45, 100, 133|
|Antipodal map, 82|Calabi, E., 359|
|Arc, 465 regular, 269|Catenary, 25 (Ex. 8) Catenoid, 224|
|in polar coordinates, 26 (Ex. 11) reparametrization by, 23|asymptotic curves of, 170 (Ex. 3) local isometry of, with a helicoid, 216 (Ex. 14), 226 as a minimal surface, 204|
|Area, 100 geometric definition of, 117 of a graph, 102 (Ex. 5) oriented, 16 (Ex. 10), 168 of surface of revolution, 103 (Ex. 11)|Cauchy-Crofton formula, 42 Cauchy sequence, 464 in the intrinsic distance, 342 (Ex. 5) Chain rule, 93 (Ex. 24), 127, 131|
|Area-preserving diffeomorphisms, 233 (Ex. 18), 234 (Ex. 20)|Chern, S. S., 323 and Lashof, R., 393|
|Asymptotic curve, 150 Asymptotic direction, 150|Christoffel symbols, 235 in normal coordinates, 299 (Ex. 4) for a surface of revolution, 236|
|Beltrami-Enneper, theorem of, 154 (Ex. 13)|Clairaut's relation, 260|
|Beltrami's theorem on geodesic mappings,|Closed plane curve, 32|
|301 (Ex. 12)|Closed set, 462|
|Bertrand curve, 27|Closure of a set, 462|
|Bertrand mate, 27|Compact set, 114,|
| |468|
|Binormal line, 20|Comparison theorems, 374 (Ex. 3)|
| |Compatibility equations, 239|
|Binormal vector, 18 Bolzano-Weierstrass theorem, 115, 126, 469|Complete surface, 331|


[Page 520]

|Cone, 66, 67 (Ex. 3), 333|Cross product, 13|
|---|---|
|geodesics of, 312 (Ex. 6)|Curvature:|
|local isometry of, with plane, 226|Gaussian, 148, 158 ( see also Gaussian|
|as a ruled surface, 192 Conformal map, 229|curvature)|
|Conformal map, 229|geodesic, 251, 256|
|local, 229, 233 (Ex. 14)|lines of, 147|
|of planes, 233 (Ex. 15)|differential equations of, 163|
|of spheres into planes, 233 (Ex. 16)|mean, 148, 158, 166|
|of spheres into planes, 233 (Ex. 16)|vector, 203|
|Conjugate locus, 368|normal, 143|
|Conjugate locus, 368|of a plane curve, 22|
|Conjugate minimal surfaces, 216 (Ex. 14)|principal, 146|
|Conjugate points, 368|radius of, 20|
|Kneser criterion for, 376 (Ex. 7)|sectional, 448|
|Connected, 465|of a space curve, 17|
|arcwise, 465|in arbitrary parameters,|
|locally, 467|26 (Ex. 12)|
|component, 472|Curve:|
|simply|asymptotic, 150|
|locally, 389|differential equations for, 162|
|Conoid, 213 (Ex. 5)|maximal, 417|
|Conoid, 213 (Ex. 5)|of class C k , 10 (Ex. 7)|
|Contact of curves and surfaces, 174 (Ex. 10)|closed, 32|
|Contact of surfaces, 94 (Ex. 27), 172 (Ex. 8)|continuous, 399|
|Contact of surfaces, 94 (Ex. 27), 172 (Ex. 8)|piecewise regular, 269|
|Continuous map, 122|simple, 32|
|uniformly, 471|coordinate, 55|
|Convergence, 460|divergent, 342 (Ex. 7)|
|in the intrinsic distance, 341 (Ex. 4)|knotted, 409|
|Convex curve, 39|level, 104 (Ex. 14)|
|Convex hull, 50 (Ex. 11)|parametrized, 3|
|Convex neighborhood, 307 existence of, 309|piecewise differentiable, 334 piecewise regular, 247|
|Convex set, 50 (Ex. 9)|regular, 6|
|Convexity and curvature, 41, 177 (Ex. 24), 393, 403|piecewise C 1 , 37 simple, 10 (Ex. 7)|
|Coordinate curves, 55|Cut locus, 425|
|Coordinate neighborhood, 55|Cycloid, 7|
|Coordinate system, 55|Cylinder, 67 (Ex. 1)|
|Courant, R., 117|ﬁrst fundamental form of, 96|
|Covariant derivative, 241|isometries of, 232 (Ex. 12)|
|algebraic value of, 251|local isometry of, with plane, 222|
|expression of, 242|normal sections of, 146|
|properties of, 310 (Ex.|as a ruled surface, 192|
|2)|Darboux trihedron, 264 (Ex. 14)|
|in terms of parallel transport, 310 (Ex. 1)| |
|number of sheets of, 384|Degree of a map, 397 Developable surface, 197, 213 (Ex. 3)|
|orientable double, 449 (Exs. 3, 4)|classification of, 197 as the envelope of a family of tangent|
|Critical point, 60, 92 (Ex. 13) 23)|planes, 198|
|nondegenerate, 177 (Ex.|tangent plane of a,|
|Critical value, 60|6)|
| |213 (Ex.|


[Page 521]

|Diffeomorphism, 76|Exponential map, 288|
|---|---|
|area-preserving, 233 (Exs. 18, 19)|differentiability of, 289|
|local, 89| |
|orientation-preserving, 168 orientation-reversing,|Faces of a triangulation, 275|
|Differentiable function, 75, 83 (Ex. 9),|Fary-Milnor Theorem, 409|
|84 (Ex. 13), 126|Fenchel’s theorem, 405|
|Differentiable manifold, 444|Fermi coordinates, 311 (Ex. 3)|
|Differentiable map, 75, 128, 432|Field of directions, 181|
|Differentiable structure, 431, 444|differential equation of, 182|
|Differential of a map, 89, 128|integral curves of, 182|
|Direction:|Field of unit normal vectors, 107|
|asymptotic, 150|First fundamental form, 94|
|principal, 146|Flat torus, 440|
| |Focal surfaces, 214 (Ex. 9)|
|Directions:|Folium of Descartes, 9 (Ex. 5)|
|conjugate, 152 field of, 181|Frenet trihedron, 20|
|Directrix of a ruled surface, 191|Frenet trihedron, 20|
|Distance on a surface, 335|Function:|
|Distribution parameter, 195|analytic, 209|
| |component, 122|
|do Carmo, M. and E. Lima, 394|continuous, 121|
|Domain, 99 Dot product, 4|differentiable, 75, 126|
|Dupin indicatrix, 150|harmonic, 204|
|geometric|height, 75|
|interpretation of, 166 Dupin's theorem on triply orthogonal|Morse, 177 (Ex. 23)|
|systems, 155|Fundamental theorem for the local theory of|
|Edges of a triangulation, 275|Fundamental theorem for the local theory|
|Eﬁmov, N. V., 457| |
| |surfaces, 239, 317|
|Eigenvalue, 219| |
|Eigenvector, 219|Gauss-Bonnet theorem (global), 277 application of, 280|
|Ellipsoid, 63, 82 (Ex. 4), 93 (Ex. 20) conjugate locus of, 266|application of, 280 Gauss-Bonnet theorem (local), 272|
|first fundamental form of, 102 (Ex. 1)|Gauss formula, 238|
|21)|240 (Ex.|
|Gaussian curvature of, 176 (Ex. 12)|in orthogonal coordinates, 1) Gauss lemma, 292|
|parametrization of, 69 (Ex. umbilical points of, 175|Gauss map, 138|
|Embedding, 441|Gauss theorem egregium, 237|
|of the projective plane into R 4 , 443|Gaussian curvature, 148, 158|
|of the torus into R 4 , 441|geometric interpretation of, 168|
|of the torus into R 4 , 441|for graphs of differentiable functions,|
|Energy of a curve, 311 (Ex. 4)|166|
|Enneper's surface, 170 (Ex. 3)|in terms of parallel transport, 274|
|as a minimal surface, 208|Genus of a surface, 276|
|Envelope of a family of tangent|Geodesic:|
|planes, 198, (Ex. 8), 215 (Ex. 10), 247, 313 (Ex.|circles, 291|
|Euclid's fifth axiom, 283, 436, 438|coordinates, 311 (Ex. 3)|
|Euler formula, 147|curvature, 251, 256|
|Euler-Lagrange equation, 371 Euler-Poincaré characteristic, 275|flow, 446 mapping, 300 (Ex. 11)|
|Evolute, 24 (Ex. 7)|parallels, 311 (Ex. 3)|


[Page 522]

|Geodesic: ( Cont. )|Hilbert’s theorem, 451 Holmgren, E., 451|
|---|---|
|polar coordinates, 290|Holmgren, E., 451|
|first fundamental form in, 291|Holonomy group, 302 (Ex. 13)|
|Gaussian curvature in, 292|Homeomorphism, 125|
|geodesics in, 300 (Ex. 7)|Homotopy of arcs, 385|
|torsion, 155 (Ex. 19), 264 (Ex. 14)|Homotopy of arcs, 385|
|Geodesics, 312|free, 396 (Ex. 10)|
|of a cone, 312 (Ex. 6)|lifting of, 385|
|of a cylinder, 249, 250|Hopf, H. and W. Rinow, 331, 359|
|differential equations of, 257|Hopf-Rinow's theorem, 338|
|existence of, 257|Hopf's theorem on surfaces with H = const.,|
|minimal, 307, 337|237 (Ex. 4)|
|minimizing properties of, 296|Hurewicz, W., 180|
|of a paraboloid of revolution, 261-262|Hyperbolic paraboloid (saddle surface),|
|of the Poincaré half-plane, 437, 438,|69 (Ex. 11), Fig. 3-7|
|450 (Ex. 8)|asymptotic curves of, 187|
|radial, 291|first fundamental form of, 102 (Ex. 1)|
|as solutions to a variational problem, 351|Gauss map of, 141|
|of a sphere, 249|parametrization of, 69 (Ex. 11)|
|of surfaces of revolution, 258-261,|as a ruled surface, 196|
|362 (Ex. 5)|Hyperbolic plane, 436|
|Gluck, H., 42|Hyperboloid of one sheet, 90 (Ex. 2), Fig. 3-34|
|Gradient on surfaces, 104 (Ex. 14)|Gauss map of, 153 (Ex. 8)|
|Graph of a differentiable function, 60|as a ruled surface, 193, 212 (Ex. 2)|
|area of, 102 (Ex. 5)|Hyperboloid of two sheets, 63|
|mean curvature of, 166|first fundamental form of, 102 (Ex. 1)|
|mean curvature of, 166|parametrization of, 69 (Ex. 13), 102 (Ex. 1)|
|second fundamental form of, 166 (Ex. 3)| |
|tangent plane of, 90|Immersion, 438|
|Green, L., 369|isometric, 438|
|Gromov, M. L., and V. A. Rokhlin, 457|Index form of a geodesic, 427|
|Group of isometries, 232 (Ex. 9)|Index of a vector field, 283|
|Hadamard’s theorem on complete surfaces with|Infimum (g.l.b.), 464|
|K ≤ O, 393, 396 (Ex. 9)|Integral curve, 182|
|Hadamard’s theorem on ovaloids, 393|Intermediate value theorem, 126|
|Hartman, P. and L. Nirenberg, 414|Intrinsic geometry, 220, 238, 241|
|Heine-Borel theorem, 115, 126|Intrinsic geometry, 220, 238, 241 133|
|Helicoid, 96|Inverse function theorem,|
|asymptotic curves of, 170 (Ex. 2)|Inversion, 123|
|distribution parameter of, 212 (Ex. 1)|Isometry, 221|
|generalized, 103 (Ex. 13), 189 (Ex. 6)|linear, 231 (Ex. 7)|
|line of striction of, 212 (Ex. 1)|local, 222|
|lines of curvature of, 170 (Ex. 2)|in local coordinates, 223, 231 (Ex. 2)|
|local isometry of, with a catenoid,|of tangent surfaces to planes, 231 (Ex.|
|216 (Ex. 14), 226|Isoperimetric inequality, 34|
|as a minimal surface, 206|for geodesic circles, 300 (Ex. 9) Isothermal coordinates, 204,|
|as the only minimal ruled surface, 207|230 13(b))|
|tangent plane of, 91 (Ex. 9)|for minimal surfaces, 216 (Ex.|
|Helix,| |
|generalized, 27 (Ex. 17)|Jacobi equation, 364 Jacobi ﬁeld, 363|
|Hessian, 166, 176 (Ex. 22)|Jacobi field, 363|
|Hilbert, D., 451|on a sphere, 368|


[Page 523]

|Jacobian determinant, 130|Mean curvature vector, 203|
|---|---|
|Jacobian matrix, 130|Mercator projection, 233 (Ex. 16), 234 (Ex. 20) Meridian, 79|
|Jacobi’s theorems on conjugate points, 424, 428|Meridian, 79|
|Jacobi's theorems on conjugate points, 424, 428|Meusnier theorem, 144|
|Joachimstahl, theorem of, 154 (Ex. 15)|Milnor, T. Klotz, 457|
|Jordan curve theorem, 400|Minding's theorem, 292|
| |Minimal surfaces, 200|
|Kazdan, J. and F. Warner, 451 Klein bottle, 433|Gauss map of, 216 (Ex. 13)|
|Klein bottle, 433|Gauss map of, 216 (Ex. 13)|
|embedding of, into R 4 , 442, 443|isothermal parameters on, 204,|
|non-orientability of, 442|216 (Ex. 13(b))|
|Klingenberg's lemma, 395 (Ex. 8)|of revolution, 205|
|Kneser criterion for conjugate points,|ruled, 207|
|376 (Ex. 7)|as solutions to a variational problem, 202|
|Knotted curve, 409|Möbius strip, 108|
| |Gaussian curvature of, 175 (Ex. 18)|
|Lashof, R. and S. S. Chern, 393|infinite, 448 (Ex. 2)|
|Lebesgue number of a family, 115|nonorientability of, 110, 112 (Exs. 1, 7)|
|Levi-Civita connection, 447|parametrization of, 108|
|Lifting:|Monkey saddle, 161, 174 (Ex. 11)|
|of an arc, 382|Morse index theorem, 427|
|of a homotopy, 385| |
|property of, arcs, 386|Neighborhood, 121, 124 convex, 307|
|Lima, E. and M. do Carmo, 394|convex, 307|
|Limit point, 461|coordinate, 55|
|Limit of a sequence, 460|distinguished, 378|
|Line of curvature, 147|normal, 289|
|Liouville:|Nirenberg, L. and P. Hartman, 414|
|surfaces of, 266|Norm of a vector, 4|
|surfaces of, 266|Normal:|
|Local canonical form of a curve, 28|coordinates, 290 curvature, 143|
|Locally convex, 177 (Ex. 24), 393 strictly, 177 (Ex. 24)|indicatrix, 281|
|Logarithmic spiral, 9|line, 89|
|Loxodromes of a sphere, 99, 233|plane to a curve, 20|
| |principal, 20|
|Mainardi-Codazzi equations, 238|section, 144|
|Mangoldt, H., 369|vector to a curve, 18|
|Map:|vector to a surface, 89|
|antipodal, 82 (Ex. 1)| |
|conformal, 229|Olinde Rodrigues, theorem of, 147|
|linear, 232 (Ex. 13)|Open set, 120|
|continuous, 122|Orientation:|
|covering, 377|change of, for curves, 7|
|differentiable, 75, 128, 432|for curves, 112 (Ex. 6) n|
|distance-preserving, 232 (Ex. 8)|positive, of R , 12|
|exponential, 287|for surfaces, 106, 138|
|Gauss, 138|of a vector space, 12|
|geodesic, 300 (Ex. 11)|Oriented: 2|
|self-adjoint linear, 217|area in R , 16 (Ex. 10)|
|Massey, W., 414|positively, boundary of a simple region, 271|
|Mean curvature, 148, 158, 166|positively, simple closed plane curve, 33|


[Page 524]

|Oriented: ( Cont. ) surface, 106, 109 volume in R 3 , 17 (Ex. 11)|osculating, 18, 30, 31 (Ex. 1), 31 (Ex. 2) real projective, 433 rectifying, 20|
|---|---|
|Orthogonal:| |
|families of curves, 105 (Ex. 15), 184, 189 (Ex. 6) fields of directions, 184, 188 (Ex. 4), 188 (Ex. 5) parametrization, 98, 186|Planes, one-parameter family of tangent, 215 (Ex. 10), 313 (Ex. 7) Plateau’s problem, 203 Poincaré half-plane, 437|
| |tangent, 86|
|projection, 82 (Ex. 2), 123 transformation, 24 (Ex. 6), 231 (Ex. 7) Osculating: circle to a curve, 31 (Ex. 2b) paraboloid to a surface, 173 (Ex. 8(c)) plane to a curve, 18, 30, 31 (Ex. 1), 31 sphere to a curve, 174 (Ex. 10(c)) Osserman's theorem, 211, 343 (Ex. 11) Ovaloid, 328, 393|geodesics of, 438, 450 (Ex. 8) Poincaré's theorem on indices of a vector field, 286 Point: accumulation, 461 central, 194 conjugate, 368 critical, 60, 92 (Ex. 13) elliptic, 148 hyperbolic, 148|
| |Pole, 396 (Ex. 11) Principal: curvature, 146|
|existence and uniqueness of, 245, geometric construction of, 247 vector field, 244 79 Parameter: of a curve, 4 distribution, 195|normal, 20 Product: cross, 13 dot, 4 inner, 4 vector, 13|
|Parameters: change of, for curves, 85 (Ex. 15) change of, for surfaces, 72 isothermal, 230|Mercator, 233 (Ex. 16), 234 (Ex. 20) stereographic, 69 (Ex. 16), 231 (Ex. 4) Projective plane, 433 embedding of, into R 4 , 443 nonorientability of, 441 orientable double covering of, 449 (Ex. Pseudo-sphere, 171 (Ex. 6)|
|216 (Ex. 13(b)) of a surface, 55|Radius of curvature, Ray, 342 (Ex. 6)|
|existence of, 230 existence of, for minimal surfaces,| |
| |20|
|Parametrization by asymptotic curves, 187 by lines of curvature, 188|Rectifying plane, 20 envelope of, 314 (Ex. 7(b))|
|Parallels: geodesic, 311 (Ex. 3(d)) of a surface of revolution, 79| |
|orthogonal, 98 existence of, 186|Region, 99 bounded, 99|
|of a surface of revolution,| |
| |simple, 271|
|hyperbolic, 436|Projection, 82 (Ex. 2), 123|
| |3)|
|Partition, 10 (Ex. 8), 116|regular, 275|
|Plane:| |
|normal, 20|simple, 271 Regular: curve, 70 (Ex. 17), 77|


[Page 525]

|parametrized curve, 6|of a parametrized surface, 80|
|---|---|
|parametrized surface, 80|of a vector ﬁeld, 283|
|surface, 54|Smooth function, 2|
|value, 60,|Soap ﬁlms, 202|
|94 (Ex. 28)|Sphere, 57|
|inverse image of, 61, 94 (Ex. 28)|conjugate locus on, 368–369|
|Reparametrization by arc length, 23|as double covering of projective plane, 448|
|Riemannian:|(Ex. 2)|
|manifold, 446|ﬁrst fundamental form of, 98|
|covariant derivative on, 447|Gauss map of, 139|
|metric, 446|geodesics of, 249|
|on abstract surfaces, 435|isometries of, 232 (Ex. 11), 267 (Ex. 23)|
|structure, 447|isothermal parameters on, 231 (Ex. 4)|
|Rigid motion, 24 (Ex. 6), 44|Jacobi ﬁeld on, 368|
|Rigidity of the sphere, 323|orientability of, 106|
|Rinow, W. and H. Hopf, 331, 359|parametrizations of, 57–60, 69 (Ex. 16)|
|Rokhlin, V. A. and M. L. Gromov, 457|rigidity of, 323|
|Rotation, 77, 88|stereographic projection of, 69 (Ex. 16)|
|Rotation axis, 79|Spherical image, 153 (Ex. 9), 283|
|Rotation index of a curve, 39, 399|Stereographic projection, 69 (Ex. 16),|
|Ruled surface, 191|231 (Ex. 4)|
|central points of, 194|Stoker, J. J., 393, 414|
|directrix of, 191|Stoker’s remark on Eﬁmov’s theorem,|
|distribution parameter of, 195|457 (Ex. 1)|
|Gaussian curvature of, 195|Stoker’s theorem for plane curves, 413 (Ex. 8)|
|noncylindrical, 193|Striction, line of, 194|
| |Sturm’s oscillation theorem, 376 (Ex. 6)|
|rulings of, 191|Supremum (l.u.b.), 464|
|Ruling, 191|Surface:|
|Samelson, H., 116|complete, 331|
|Santaló, L., 47|connected, 63|
|Scherk's minimal surface, 210|developable, 197, 213 (Ex. 3)|
|Schneider, R., 56|focal, 214 (Ex. 9)|
|Schur's theorem for plane curves, 412 (Ex.|geometric, 435|
|413 (Ex. 8)|of Liouville, 266|
|Second fundamental form, 143|minimal, 200|
|Set:|parametrized, 80|
|arcwise connected, 465|regular, 80|
|bounded, 114|regular, 80|
|closed, 462|of revolution ( see Surfaces of revolution)|
|compact, 114, 468|rigid, 323|
|connected, 465|ruled ( see Ruled surface)|
|convex, 50 (Ex. 9)|tangent, 81|
|locally simply connected, 389|Surfaces of revolution, 79|
|open, 120|area of, 103 (Ex. 11)|
|simply connected, 388|area-preserving maps of, 234 (Ex. 20)|
|Similarity, 301 (Ex. 11)|Christoffel symbols, 236|
|Similitude, 190 (Ex. 9), 232 (Ex. 13)|conformal maps of, 234 (Ex. 20)|
|Simple region, 271|with constant curvature, 171 (Ex. 7), 326|
|Singular point:|extended, 80|
|of a parametrized curve,|164|
|6|Gaussian curvature of, 164|


[Page 526]

|Surfaces of revolution ( Cont. ) geodesics of, 258–261|Tubular:|
|---|---|
|geodesics of, 258-261|neighborhood, 112,|
|isometries of, 232 (Ex. 10) mean curvature of , 165|406 surfaces, 91 (Ex. 10), 406|
|parametrization of, 79|Umbilical point, 149|
|principal curvatures of, 165|Uniformly continuous map, 471|
|Symmetry, 77, 123|Unit normal vector, 89|
|Synge’s lemma, 396 (Ex. 10)| |
| |Variation:|
|Tangent:|ﬁrst, of arc length, 350|
|bundle, 444|second, of arc length, 357|
|indicatrix, 24 (Ex. 3), 37|second, of energy for simple geodesics,|
|line to a curve, 6|312 (Ex. 5)|
|map of a curve, 399|Variations:|
|plane, 86, 90 (Exs. 1, 3)|broken, 426|
|of abstract surfaces, 435|calculus of, 360-362 (Exs. 4, 5)|
|strong, 10 (Ex. 7)|of curves, 345|
|surface, 81|orthogonal, 351|
|vector to a curve, 2|proper, 345|
|vector to a regular surface, 85|of simple geodesics, 312 200|
|vector to a regular surface, 85|of surfaces,|
|weak, 10 (Ex. 7)|Vector:|
|Tangents, theorem of turning, 270, 402|acceleration, 350|
|Tchebyshef net, 102 (Exs. 3, 4), 240 (Ex. 5), 452|norm of, 4|
|Tissot's theorem, 190 (Ex. 9)|norm of, 4|
|Topological properties of surfaces, 275|tangent ( see Tangent, vector)|
|Torsion:|velocity, 2|
|in an arbitrary parametrization, 26 (Ex. 12)|Vector field along a curve, 243|
|geodesic, 155 (Ex. 19), 264 (Ex. 14)|covariant derivative of, 243|
|in a parametrization by arc length, 26 (Ex. 12)|parallel, 244|
|sign of, 29|variational, 344|
|Torus, 64|Vector field along a map, 348|
|abstract, 439|Vector field on a plane, 178|
|area of, 101 flat, 440|local first integral of, 181 local flow of, 180|
|Gaussian curvature of, 159|trajectories of, 179|
|implicit equation of, 65|Vector field on a surface, 183, 241|
|as orientable double covering of Klein bottle,|covariant derivative of, 241|
|449 (Ex. 3)|derivative of a function relative to,|
|parametrization of, 67 curvature, 405|189 (Ex. 7) of,|
|Total|maximal trajectory 190 (Ex. 11)|
|Trace of a parametrized curve, 2 Trace of a parametrized surface, 80|singular point of, 283 Vertex:|
|Translation, 24 (Ex. 6)|the four, theorem, 39 of a plane curve,|
| |39|
|Transversal intersection,|Vertices of a triangulation, 275|
|93 (Ex. 17)|Vertices of a piecewise regular curve, 269|
|Triangle on a surface, 275 geodesic, 267, 282| |
|free mobility of small, 300 (Ex. 8) Triangulation, 275|Warner, F. and J. Kazdan, 451 Weingarten, equations of, 157|
|Trihedron:| |
|Darboux, 264 (Ex. 14)|Winding number, 399|
|Frenet, 20| |


[Page 527]

[Page 528]

[Page 529]

# DIFFERENTIAL GEOMETRY OF CURVES & SURFACES

# MANFREDO P DO CARMO

O ne of the most widely used texts in its ﬁeld, this volume   introduces the differential geometry of curves and surfaces in both local and global aspects. The presentation departs from the traditional approach with its more extensive use of elementary linear algebra and its emphasis on basic geometrical facts rather than machinery or random details. Many examples and exercises enhance the clear, well-written exposition, along with hints and answers to some of the problems.

The treatment begins with a chapter on curves, followed by explorations of regular surfaces, the geometry of the Gauss map, the intrinsic geometry of surfaces, and global differential geometry. Suitable for advanced undergraduates and graduate students of mathematics, this text’s prerequisites include an undergraduate course in linear algebra and some familiarity with the calculus of several variables. For this second edition, the author has corrected, revised, and updated the entire volume.

Dover revised and updated republication of the edition originally published by Prentice-Hall, Inc., Englewood Cliffs, New Jersey, 1976.

$29.95 USA

ISBN-13:

ISBN-10:

PRINTED IN THE USA

978-0-486-80699-0

0-486-80699-5

5 2 9 9 5

9 780486 806990

