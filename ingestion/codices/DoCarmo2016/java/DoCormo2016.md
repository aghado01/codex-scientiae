[Page 1]

![image 1](<DoCormo2016_images/imageFile1.png>)

# DIFFERENTIAL GEOMETRY OF CURVES & SURFACES

Revised & Updated (Second Edition)

Manfredo P. do Carmo

###### Contents

Preface to the Second Edition xi Preface xiii Some Remarks on Using this Book xv

- 1. Curves 1

- 1-1 Introduction 1
- 1-2 Parametrized Curves 2
- 1-3 Regular Curves; Arc Length 6
- 1-4 The Vector Product in R3 12
- 1-5 The Local Theory of Curves Parametrized by Arc Length 17
- 1-6 The Local Canonical Form 28
- 1-7 Global Properties of Plane Curves 31


- 2. Regular Surfaces 53


- 2-1 Introduction 53
- 2-2 Regular Surfaces; Inverse Images of Regular Values 54
- 2-3 Change of Parameters; Differentiable Functions on Surface 72
- 2-4 The Tangent Plane; The Differential of a Map 85
- 2-5 The First Fundamental Form; Area 94
- 2-6 Orientation of Surfaces 105
- 2-7 A Characterization of Compact Orientable Surfaces 112
- 2-8 A Geometric Deﬁnition of Area 116 Appendix: A Brief Review of Continuity and Differentiability 120


###### ix

[Page 10]

x Contents

###### 3. The Geometry of the Gauss Map 136

- 3-1 Introduction 136
- 3-2 The Deﬁnition of the Gauss Map and Its Fundamental Properties 137
- 3-3 The Gauss Map in Local Coordinates 155
- 3-4 Vector Fields 178
- 3-5 Ruled Surfaces and Minimal Surfaces 191 Appendix: Self-Adjoint Linear Maps and Quadratic Forms 217


###### 4. The Intrinsic Geometry of Surfaces 220

- 4-1 Introduction 220
- 4-2 Isometries; Conformal Maps 221
- 4-3 The Gauss Theorem and the Equations of Compatibility 235
- 4-4 Parallel Transport. Geodesics. 241
- 4-5 The Gauss-Bonnet Theorem and Its Applications 267
- 4-6 The Exponential Map. Geodesic Polar Coordinates 287
- 4-7 Further Properties of Geodesics; Convex Neighborhoods 302 Appendix: Proofs of the Fundamental Theorems of the Local Theory of Curves and Surfaces 315


###### 5. Global Differential Geometry 321

- 5-1 Introduction 321
- 5-2 The Rigidity of the Sphere 323
- 5-3 Complete Surfaces. Theorem of Hopf-Rinow 331
- 5-4 First and Second Variations of Arc Length; Bonnet’s Theorem 344
- 5-5 Jacobi Fields and Conjugate Points 363
- 5-6 Covering Spaces; The Theorems of Hadamard 377
- 5-7 Global Theorems for Curves: The Fary-Milnor Theorem 396
- 5-8 Surfaces of Zero Gaussian Curvature 414
- 5-9 Jacobi’s Theorems 421
- 5-10 Abstract Surfaces; Further Generalizations 430
- 5-11 Hilbert’s Theorem 451 
- Appendix: Point-Set Topology of Euclidean Spaces 460


Bibliography and Comments 475

Hints and Answers 478

Index 503

[Page 11]

###### xi

[Page 12]

[Page 13]

# Preface

This book is an introduction to the differential geometry of curves and surfaces, both in its local and global aspects. The presentation differs from the traditional ones by a more extensive use of elementary linear algebra and by a certain emphasis placed on basic geometrical facts, rather than on machinery or random details.

We have tried to build each chapter of the book around some simple and fundamental idea. Thus, Chapter 2 develops around the concept of a regular surface in R3; when this concept is properly developed, it is probably the best model for differentiable manifolds. Chapter 3 is built on the Gauss normal map and contains a large amount of the local geometry of surfaces in R3. Chapter 4 uniﬁes the intrinsic geometry of surfaces around the concept of covariant derivative; again, our purpose was to prepare the reader for the basic notion of connection in Riemannian geometry. Finally, in Chapter 5, we use the ﬁrst and second variations of arc length to derive some global properties of surfaces. Near the end of Cbapter 5 (Sec. 5-10), we show how questions on surface theory, and the experience of Chapters 2 and 4, lead naturally to the consideration of differentiable manifolds and Riemannian metrics.


To maintain the proper balance between ideas and facts, we have presented a large number of examples that are computed in detail. Furthermore, a reasonable supply of exercises is provided. Some factual material of classical differential geometry found its place in these exercises. Hints or answers are given for the exercises that are starred.

The prerequisites for reading this book are linear algebra and calculus. From linear algebra, only the most basic concepts are needed, and a standard undergraduate course on the subject should sufﬁce. From calculus, a certain familiarity with calculus of several variables (including the statement

###### xiii

[Page 14]

xiv Preface

of the implicit function theorem) is expected. For the reader’s convenience, we have tried to restrict our references to R. C. Buck, Advanced Calculus, New York: McGraw-Hill, 1965 (quoted as Buck, Advanced Calculus). A certain knowledge of differential equations will be useful but it is not required.

This book is a free translation, with additional material, of a book and a set of notes, both published originally in Portuguese. Were it not for the enthusiasm and enormous help of Blaine Lawson, this book would not have comeintoEnglish.AlargepartofthetranslationwasdonebyLenyCavalcante. I am also indebted to my colleagues and students at IMPA for their comments and support. In particular, Elon Lima read part of the Portuguese version and made valuable comments.

Robert Gardner, Jürgen Kern, Blaine Lawson, and Nolan Wallach read criticallytheEnglishmanuscriptandhelpedmetoavoidseveralmistakes, both in English and Mathematics. Roy Ogawa prepared the computer programs for some beautiful drawings that appear in the book (Figs. 1-3, 1-8, 1-9, 1-10, 1-11, 3-45 and 4-4). Jerry Kazdan devoted his time generously and literally offered hundreds of suggestions for the improvement of the manuscript. This ﬁnal form of the book has beneﬁted greatly from his advice. To all these people—and to Arthur Wester, Editor of Mathematics at Prentice-Hall, and Wilson Góes at IMPA—I extend my sincere thanks.

Rio de Janeiro Manfredo P. do Carmo

[Page 15]

###### Some Remarks on Using This Book

We tried to prepare this book so it could be used in more than one type of differential geometry course. Each chapter starts with an introduction that describes the material in the chapter and explains how this material will be used later in the book. For the reader’s convenience, we have used footnotes to point out the sections (or parts thereof) that can be omitted on a ﬁrst reading.

Although there is enough material in the book for a full-year course (or a topics course), we tried to make the book suitable for a ﬁrst course on differential geometry for students with some background in linear algebra and advanced calculus.

For a short one-quarter course (10 weeks), we suggest the use of the following material: Chapter 1: Secs. 1-2, 1-3, 1-4, 1-5 and one topic of Sec. 1-7—2 weeks. Chapter 2: Secs. 2-2 and 2-3 (omit the proofs), Secs. 2-4 and 2-5—3 weeks. Chapter 3: Secs. 3-2 and 3-3—2 weeks. Chapter 4:

- Secs. 4-2 (omit conformal maps and Exercises 4, 13–18, 20), 4-3 (up to Gauss theorema egregium), 4-4 (u p to Prop. 4; omit Exercises 12, 13, 16, 18–21), 4-5 (up to the local Gauss-Bonnet theorem; include applications (b) and (f))3 weeks.


The 10-week program above is on a pretty tight schedule. A more relaxed alternativeistoallowmoretimefortheﬁrstthreechaptersandtopresentsurvey lectures, on the last week of the course, on geodesics, the Gauss theorema egregium, and the Gauss-Bonnet theorem (geodesics can then be deﬁned as curves whose osculating planes contain the normals to the surface).

###### xv

[Page 16]

xvi Some Remarks on Using This Book

Inaone-semestercourse, theﬁrstalternativecouldbetaughtmoreleisurely and the instructor could probably include additional material (for instance,

- Secs. 5-2 and 5-10 (partially), or Secs. 4-6, 5-3 and 5-4). Please also note that an asterisk attached to an exercise does not mean the


exercise is either easy or hard. It only means that a solution or hint is provided at the end of the book. Second, we have used for parametrization a bold-faced x and that might become clumsy when writing on the blackboard. Thus we have reserved the capital X as a suggested replacement.

Where letter symbols that would normally be italic appear in italic context, the letter symbols are set in roman. This has been done to distinguish these symbols from the surrounding text.

[Page 17]

![image 3](<DoCormo2016_images/imageFile3.png>)

## 1 Curves

###### 1-1. Introduction

The differential geometry ofcurves and surfaces has two aspects. One, which may be called classical differential geometry, started with the beginnings of calculus. Roughly speaking, classical differential geometry is the study of local properties of curves and surfaces. By local properties we mean those properties which depend only on the behavior of the curve or surface in the neighborhood of a point. The methods which have shown themselves to be adequate in the study ofsuch propertiesarethe methods ofdifferential calculus. Because of this, the curves and surfaces considered in differential geometry will be defined by functions which can be differentiated a certain number of times.

The other aspect is the so-called global differential geometry. Here one studies the influence ofthe local properties on the behavior ofthe entire curve or surface. We shall come back to this aspect of differential geometry later in the book.

Perhaps the most interesting and representative part of classical differential geometry is the study of surfaces. However, some local properties of curves appear naturally while studying surfaces. We shall therefore use this first chapter for a brief treatment of curves.

The chapter has been organized in such a way that a reader interested mostly in surfaces can read only Sees. 1-2 through 1-5. Sections 1-2 through 1-4 contain essentially introductory material (parametrized curves, arc length, vector product), which will probably be known from other courses and is included here for completeness. Section 1-5 is the heart of the chapter and

1

[Page 18]

contains the material of curves needed for the study of surfaces. For those wishing to go a bit further on the subject of curves, we have included Secs. 1-6 and 1-7.

###### 1-2. Parametrized Curves

We denote by R3 the set of triples (x,y,z) of real numbers. Our goal is to characterize certain subsets of R3 (to be called curves) that are, in a certain sense, one-dimensional and to which the methods of differential calculus can be applied. A natural way of deﬁning such subsets is through differentiable functions. We say that a real function of a real variable is differentiable (or smooth) if it has, at all points, derivatives of all orders (which are automatically continuous). A ﬁrst deﬁnition of curve, not entirely satisfactory but sufﬁcient for the purposes of this chapter, is the following.

DEFINITION. A parametrized differentiable curve is a differentiable map α: I → R3 of an open interval I = (a,b) of the real line R into R3.†

The word differentiable in this deﬁnition means that α is a correspondence which maps each t ∈ I into a point α(t) = (x(t),y(t),z(t)) ∈ R3 in such a waythatthefunctionsx(t),y(t),z(t)aredifferentiable. Thevariablet iscalled the parameter of the curve. The word interval is taken in a generalized sense, so that we do not exclude the cases a = −∞, b = +∞.

If we denote by x′(t) the ﬁrst derivative of x at the point t and use similar notations for the functions y and z, the vector (x′(t),y′(t),z′(t)) = α′(t) ∈ R3 is called the tangent vector (or velocity vector) of the curve α at t. The image set α(I) ⊂ R3 is called the trace of α. As illustrated by Example 5 below, one should carefully distinguish a parametrized curve, which is a map, from its trace, which is a subset of R3.

A warning about terminology. Many people use the term “inﬁnitely differentiable” for functions which have derivatives of all orders and reserve the word “differentiable” to mean that only the existence of the ﬁrst derivative is required. We shall not follow this usage.

Example 1. The parametrized differentiable curve given by

α(t) = (a cost,a sin t,bt), t ∈ R,

has as its trace in R3 a helix of pitch 2πb on the cylinder x2 +y2 = a2. The parameter t here measures the angle which the x axis makes with the line joining the origin 0 to the projection of the point α(t) over the xy plane (see Fig. 1-1).

†In italic context, letter symbols will not be italicized so they will be clearly distinguished from the surrounding text.

[Page 19]

z

α´(t) α(t)

y

x

0

t

0

y

x

###### Figure 1-1 Figure 1-2

- Example 2. The map α: R → R2 given by α(t) = (t3,t2), t ∈ R, is a

parametrized differentiable curve which has Fig. 1-2 as its trace. Notice that α′(0) = (0,0); that is, the velocity vector is zero for t = 0.

- Example 3. The map α: R → R2 given by α(t) = (t3 −4t,t2 −4),

t ∈ R, is a parametrized differentiable curve (see Fig. 1-3). Notice that α(2) = α(−2) = (0,0); that is, the map α is not one-to-one.

x 0

y

x 0

y

Figure 1-3 Figure 1-4

- Example 4. The map α: R → R2 given by α(t) = (t,|t|), t ∈ R, is not


a parametrized differentiable curve, since |t| is not differentiable at t = 0 (Fig. 1-4).

[Page 20]

Example 5. The two distinct parametrized curves

α(t) = (cost,sin t), β(t) = (cos2t,sin 2t),

where t ∈ (0−ǫ,2π +ǫ), ǫ > 0, have the same trace, namely, the circle x2 +y2 = 1. Notice that the velocity vector of the second curve is the double of the ﬁrst one (Fig. 1-5).

α´(t)

β´(t) x

y

0

###### Figure 1-5

We shall now recall brieﬂy some properties of the inner (or dot) product of vectors in R3. Let u = (u1,u2,u3) ∈ R3 and deﬁne its norm (or length) by

|u| = ?u21 +u22 +u23.

Geometrically, |u| is the distance from the point (u1,u2,u3) to the origin 0 = (0,0,0). Now, let u = (u1,u2,u3) and v = (v1,v2,v3) belong to R3, and let θ, 0 ≤ θ ≤ π, be the angle formed by the segments 0u and 0v. The inner product u·v is deﬁned by (Fig. 1-6)

u·v = |u||v|cosθ. The following properties hold:

- 1. Assume that u and v are nonzero vectors. Then u·v = 0 if and only if u is orthogonal to v.
- 2. u·v = v ·u.
- 3. λ(u·v) = λu·v = u·λv.
- 4. u·(v +w) = u·v +u·w.


A useful expression for the inner product can be obtained as follows. Let e1 = (1,0,0), e2 = (0,1,0), and e3 = (0,0,1). It is easily checked

[Page 21]

z

v cos θ

v

v1

u2

u1

u3

u

y

x

0

θ

v3 v2

###### Figure 1-6

that ei ·ej = 1 if i = j and that ei ·ej = 0 if i ?= j, where i,j = 1, 2, 3. Thus, by writing

u = u1e1 +u2e2 +u3e3, v = v1e1 +v2e2 +v3e3, and using properties 2 to 4, we obtain

u·v = u1v1 +u2v2 +u3v3.

From the above expression it follows that if u(t) and v(t), t ∈ I, are differentiable curves, then u(t)·v(t) is a differentiable function, and

d dt

(u(t)·v(t)) = u′(t)·v(t)+u(t)·v′(t).

###### EXERCISES

- 1. Find a parametrized curve α(t) whose trace is the circle x2 +y2 = 1 such that α(t) runs clockwise around the circle with α(0) = (0,1).
- 2. Let α(t) be a parametrized curve which does not pass through the origin. If α(t0) is a point of the trace of α closest to the origin and α′(t0) ?= 0, show that the position vector α(t0) is orthogonal to α′(t0).
- 3. A parametrized curve α(t) has the property that its second derivative α′′(t) is identically zero. What can be said about α?
- 4. Let α: I → R3 be a parametrized curve and let v ∈ R3 be a ﬁxed vector. Assume that α′(t) is orthogonal to v for all t ∈ I and that α(0) is also orthogonal to v. Prove that α(t) is orthogonal to v for all t ∈ I.


[Page 22]

- 5. Let α: I → R3 be a parametrized curve, with α′(t) ?= 0 for all t ∈ I. Show that |α(t)| is a nonzero constant if and only if α(t) is orthogonal to α′(t) for all t ∈ I.


###### 1-3. Regular Curves; Arc Length

Let α: I → R3 be a parametrized differentiable curve. For each t ∈ I where α′(t) ?= 0, there is a well-deﬁned straight line, which contains the point α(t) and the vector α′(t). This line is called the tangent line to α at t. For the study of the differential geometry of a curve it is essential that there exists such a tangent line at every point. Therefore, we call any point t where α′(t) = 0 asingularpoint ofα andrestrictourattentiontocurveswithoutsingularpoints. Notice that the point t = 0 in Example 2 of Sec. 1-2 is a singular point.

DEFINITION. A parametrized differentiable curve α: I → R3 is said to be regular if α′(t) ?= 0 for all t ∈ I.

From now on we shall consider only regular parametrized differentiable curves (and, for convenience, shall usually omit the word differentiable).

Given t0 ∈ I, the arc length of a regular parametrized curve α: I → R3, from the point t0, is by deﬁnition

s(t) = ? t t0

|α′(t)|dt,

where

|α′(t)| = ?

(x′(t))2 +(y′(t))2 +(z′(t))2

is the length of the vector α′(t). Since α′(t) ?= 0, the arc length s is a differentiable function of t and ds/dt = |α′(t)|.

In Exercise 8 we shall present a geometric justiﬁcation for the above deﬁnition of arc length.

It can happen that the parameter t is already the arc length measured from some point. In this case, ds/dt = 1 = |α′(t)|; that is, the velocity vector has constant length equal to 1. Conversely, if |α′(t)| ≡ 1, then

s = ? t t0

dt = t −t0;

i.e., t is the arc length of α measured from some point.

To simplify our exposition, we shall restrict ourselves to curves parametrized by arc length; we shall see later (see Sec. 1-5) that this restriction is not essential. In general, it is not necessary to mention the origin of the

[Page 23]

arc length s, since most concepts are deﬁned only in terms of the derivatives of α(s).

It is convenient to set still another convention. Given the curve α parametrized by arc length s ∈ (a,b), we may consider the curve β deﬁned in (−b,−a) by β(−s) = α(s), which has the same trace as the ﬁrst one but is described in the opposite direction. We say, then, that these two curves differ by a change of orientation.

###### EXERCISES

- 1. Show that the tangent lines to the regular parametrized curve α(t) = (3t,3t2,2t3) make a constant angle with the line y = 0, z = x.
- 2. Acircular disk of radius 1 in the plane xy rolls without slipping along the x axis. The ﬁgure described by a point of the circumference of the disk is called a cycloid (Fig. 1-7).

x

y

t

l 0

Figure 1-7. The cycloid.

*a. Obtain a parametrized curve α: R → R2 the trace of which is the

cycloid, and determine its singular points.

b. Compute the arc length of the cycloid corresponding to a complete

rotation of the disk.

- 3. Let0A = 2a bethediameterofacircleS1 and0y andAV bethetangents to S1 at 0 and A, respectively. Ahalf-line r is drawn from 0 which meets the circle S1 at C and the line AV at B. On 0B mark off the segment 0p = CB. If we rotate r about 0, the point p will describe a curve called the cissoid of Diocles. By taking 0A as the x axis and 0Y as the y axis, prove that


- a. The trace of


α(t) = ?

2at2 1+t2

,

2at3

1+t2?, t ∈ R, is the cissoid of Diocles (t = tan θ; see Fig. 1-8).

[Page 24]

- b. The origin (0,0) is a singular point of the cissoid.
- c. As t → ∞, α(t) approaches the line x = 2a, and α′(t) → 0,2a. Thus, as t → ∞, the curve and its tangent approach the line x = 2a; we say that x = 2a is an asymptote to the cissoid.


- 4. Let α: (0,π) → R2 be given by


α(t) = ?sin t,cost +log tan

t 2?,

where t is the angle that the y axis makes with the vector α′(t). The trace of α is called the tractrix (Fig. 1-9). Show that

y V

B

A

S1

0 x

C p

θ

2a

r

α(t)

l

l

0

x

t

l

t

y

Figure 1-8. The cissoid of Diocles. Figure 1-9. The tractrix.

- a. α is a differentiable parametrized curve, regular except at t = π/2.
- b. The length of the segment of the tangent of the tractrix between the point of tangency and the y axis is constantly equal to 1.


- 5. Let α: (−1,+∞) → R2 be given by


α(t) = ?

3at 1+t3

,

3at2 1+t3?.

[Page 25]

Prove that:

- a. For t = 0, α is tangent to the x axis.
- b. As t → +∞, α(t) → (0,0) and α′(t) → (0,0).
- c. Take the curve with the opposite orientation. Now, as t → −1, the curve and its tangent approach the line x +y +a = 0.


The ﬁgure obtained by completing the trace of α in such a way that it becomes symmetric relative to the line y = x is called the folium of Descartes (see Fig. 1-10).

x

0

a

a

y

Figure 1-10. Folium of Descartes.

- 6. Let α(t) = (aebt cost,aebt sin t), t ∈ R, a and b constants, a > 0, b < 0, be a parametrized curve.


- a. Showthatast → +∞, α(t)approachestheorigin0, spiralingaround it (because of this, the trace of α is called the logarithmic spiral; see Fig. 1-11).
- b. Show that α′(t) → (0,0) as t → +∞ and that


lim

t→+∞

? t

t0

|α′(t)|dt

is ﬁnite; that is, α has ﬁnite arc length in [t0,∞).

[Page 26]

t

y

x

Figure 1-11. Logarithmic spiral.

- 7. A map α: I → R3 is called a curve of class Ck if each of the coordinate functions in the expression α(t) = (x(t),y(t),z(t)) has continuous derivatives up to order k. If α is merely continuous, we say that α is of class C0. Acurve α is called simple if the map α is one-to-one. Thus, the curve in Example 3 of Sec. 1-2 is not simple.


Let α: I → R3 be a simple curve of class C0. We say that α has a weak tangent at t = t0 ∈ I if the line determined by α(t0 +h) and α(t0) has a limit position when h → 0. We say that α has a strong tangent at t = t0 if the line determined by α(t0 +h) and α(t0 +k) has a limit position when h,k → 0. Show that

a. α(t) = (t3,t2), t ∈ R, has a weak tangent but not a strong tangent at

t = 0.

- *b. If α: I → R3 is of class C1 and regular at t = t0, then it has a strong tangent at t = t0.

c. The curve given by

α(t) = ?

(t2,t2), t ≥ 0, (t2,−t2), t ≤ 0,

is of class C1 but not of class C2. Draw a sketch of the curve and its tangent vectors.

- *8. Let α: I → R3 be a differentiable curve and let [a,b] ⊂ I be a closed interval. For every partition


a = t0 < t1 < ··· < tn = b

[Page 27]

of [a,b], consider the sum

?n i=1 |α(ti)−α(ti−1)| = l(α,P), where P

stands for the given partition. The norm |P| of a partition P is deﬁned as |P| = max(ti −ti−1),i = 1,...,n.

Geometrically, l(α,P) is the length of a polygon inscribed in α([a,b]) with vertices in α(ti) (see Fig. 1-12). The point of the exercise is to show that the arc length of α([a,b]) is, in some sense, a limit of lengths of inscribed polygons.

α(tn–1)

α(ti)

α(tn)

- α(t0)

α

- α(t1) α(t2)


###### Figure 1-12

Prove that given ǫ > 0 there exists δ > 0 such that if |P| < δ then

?

? b

a

|α′(t)|dt −l(α,P)? < ǫ.

- 9. a. Let α:I → R3 beacurveofclassC0 (cf. Exercise7). Usetheapproximation by polygons described in Exercise 8 to give a reasonable deﬁnition of arc length of α.

b. (A Nonrectiﬁable Curve.) The following example shows that, with any reasonable deﬁnition, the arc length of a C0 curve in a closed interval may be unbounded. Let α: [0,1] → R2 be given as α(t) = (t,t sin(π/t)) if t ?= 0, and α(0) = (0,0). Show, geometrically, that thearclengthoftheportionofthecurvecorrespondingto1/(n +1) ≤

t ≤ 1/n is at least 2/(n+ 21). Use this to show that the length of the curve in the interval 1/N ≤ t ≤ 1 is greater than 2

?N

n=1 1/(n+1), and thus it tends to inﬁnity as N → ∞.

- 10. (Straight Lines as Shortest.) Let α: I → R3 be a parametrized curve. Let [a,b] ⊂ I and set α(a) = p, α(b) = q.


- a. Show that, for any constant vector v, |v| = 1,


(q −p)·v = ? b

a

α′(t)·v dt ≤ ? b

a

|α′(t)|dt.

[Page 28]

- b. Set


v =

q −p |q −p|

and show that

|α(b)−α(a)| ≤ ? b

a

|α′(t)|dt;

that is, the curve of shortest length from α(a) to α(b) is the straight line joining these points.

###### 1-4. The Vector Product in R3

In this section, we shall present some properties of the vector product in R3. They will be found useful in our later study of curves and surfaces.

It is convenient to begin by reviewing the notion of orientation of a vector space. Two ordered bases e = {ei} and f = {fi}, i = 1,...,n, of an n-dimensional vector space V have the same orientation if the matrix of change of basis has positive determinant. We denote this relation by e ∼ f . From elementary properties of determinants, it follows that e ∼ f is an equivalence relation; i.e., it satisﬁes

- 1. e ∼ e.
- 2. If e ∼ f , then f ∼ e.
- 3. If e ∼ f , f ∼ g, then e ∼ g.


The set of all ordered bases of V is thus decomposed into equivalence classes (theelementsofagivenclassarerelatedby∼)whichbyproperty3aredisjoint. Since the determinant of a change of basis is either positive or negative, there are only two such classes.

Each of the equivalence classes determined by the above relation is called an orientation of V . Therefore, V has two orientations, and if we ﬁx one of them arbitrarily, the other one is called the opposite orientation.

In the case V = R3, there exists a natural ordered basis e1 = (1,0,0), e2 = (0,1,0), e3 = (0,0,1), and we shall call the orientation corresponding to this basis the positive orientation of R3, the other one being the negative orientation (of course, this applies equally well to any Rn). We also say that a given ordered basis of R3 is positive (or negative) if it belongs to the positive (or negative) orientation of R3. Thus, the ordered basis e1,e3,e2 is a negative basis, since the matrix which changes this basis into e1,e2,e3 has determinant equal to −1.

[Page 29]

We now come to the vector product. Let u,v ∈ R3. The vector product of u and v (in that order) is the unique vector u∧v ∈ R3 characterized by

(u∧v)·w = det(u,v,w) for all w ∈ R3.

Here det(u,v,w) means that if we express u,v, and w in the natural basis {ei},

u = ?

uiei, v = ?

viei, w = ?

wiei, i = 1,2,3,

then

det(u,v,w) =

?

- u1 u2 u3
- v1 v2 v3
- w1 w2 w3?


,

where |aij| denotes the determinant of the matrix (aij). It is immediate from the deﬁnition that

u∧v =

?

- u2 u3
- v2 v3?


e1 −

?

- u1 u3
- v1 v3?


e2 +

?

- u1 u2
- v1 v2?


###### e3. (1)

Remark. It is also very frequent to write u∧v as u×v and refer to it as the cross product.

The following properties can easily be checked (actually they just express the usual properties of determinants):

- 1. u∧v = −v ∧u (anticommutativity).
- 2. u∧v depends linearly on u and v; i.e., for any real numbers a,b, we have

(au+bw)∧v = au∧v +bw ∧v.

- 3. u∧v = 0 if and only if u and v are linearly dependent.
- 4. (u∧v)·u = 0, (u∧v)·v = 0. It follows from property 4 that the vector product u∧v ?= 0 is normal to


- a plane generated by u and v. To give a geometric interpretation of its norm and its direction, we proceed as follows.


First, we observe that (u∧v)·(u∧v) = |u∧v|2 > 0. This means that the determinant of the vectors u,v,u∧v is positive; that is, {u,v,u∧v} is a positive basis.

[Page 30]

Next, we prove the relation

(u∧v)·(x ∧y) =

?

- u·x v ·x
- u·y v ·y?


,

where u,v,x,y are arbitrary vectors. This can easily be done by observing that both sides are linear in u,v,x,y. Thus, it sufﬁces to check that

(ei ∧ej)·(ek ∧el) =

? for all i,j,k,l = 1,2,3. This is a straightforward veriﬁcation. It follows that |u∧v|2 =

- ei ·ek ej ·ek
- ei ·el ej ·el?


?

- u·u u·v
- u·v v ·v?


= |u|2|v|2(1−cos2 θ) = A2,

whereθ istheangleofuandv, andAistheareaoftheparallelogramgenerated by u and v.

In short, the vector product of u and v is a vector u∧v perpendicular to a plane spanned by u and v, with a norm equal to the area of the parallelogram generated by u and v and a direction such that {u,v,u∧v} is a positive basis (Fig. 1-13).

v sin θ

|2<br><br>π|
|---|


θ

v

u

u ^ v

###### Figure 1-13

The vector product is not associative. In fact, we have the following identity:

(u∧v)∧w = (u·w)v −(v ·w)u, (2)

which can be proved as follows. First we observe that both sides are linear in u,v,w; thus, the identity will be true if it holds for all basis vectors. This last veriﬁcation is, however, straightforward; for instance,

[Page 31]

(e1 ∧e2)∧e1 = e2 = (e1 ·e1)e2 −(e2 ·e1)e1.

Finally, let u(t) = (u1(t),u2(t),u3(t)) and v(t) = (v1(t),v2(t),v3(t)) be differentiable maps from the interval (a,b) to R3, t ∈ (a,b). It follows immediately from Eq. (1) that u(t)∧v(t) is also differentiable and that

d dt

(u(t)∧v(t)) =

du dt ∧v(t)+u(t)∧

dv dt

.

Vector products appear naturally in many geometrical constructions.Actually, most of the geometry of planes and lines in R3 can be neatly expressed in terms of vector products and determinants. We shall review some of this material in the following exercises.

###### EXERCISES

1. Check whether the following bases are positive:

- a. The basis {(1,3),(4,2)} in R2.
- b. The basis {(1,3,5),(2,3,7),(4,8,3)} in R3.


- *2. AplaneP containedinR3 isgivenbytheequationax +by +cz +d = 0. Show that the vector v = (a,b,c) is perpendicular to the plane and that |d|/√a2 +b2 +c2 measures the distance from the plane to the origin (0,0,0).

- *3. Determine the angle of intersection of the two planes 5x +3y + 2z −4 = 0 and 3x +4y −7z = 0.
- *4. Given two planes aix +biy +ciz +di = 0, i = 1,2, prove that a necessary and sufﬁcient condition for them to be parallel is


- a1

- a2 =


- b1

- b2 =


c1 c2

,

where the convention is made that if a denominator is zero, the corresponding numerator is also zero (we say that two planes are parallel if they either coincide or do not intersect).

5. Showthatanequationofaplanepassingthroughthreenoncolinearpoints

p1 = (x1,y1,z1), p2 = (x2,y2,z2), p3 = (x3,y3,z3) is given by (p −p1)∧(p −p2)·(p −p3) = 0,

where p = (x,y,z) is an arbitrary point of the plane and p −p1, for instance, means the vector (x −x1,y −y1,z −z1).

[Page 32]

- *6. Given two nonparallel planes aix +biy +ciz +di = 0, i = 1,2, show that their line of intersection may be parametrized as

x −x0 = u1t, y −y0 = u2t, z −z0 = u3t,

where (x0,y0,z0) belongs to the intersection and u = (u1,u2,u3) is the vector product u = v1 ∧v2, vi = (ai,bi,ci), i = 1,2.

- *7. Prove that a necessary and sufﬁcient condition for the plane ax +by +cz +d = 0

and the line x −x0 = u1t, y −y0 = u2t, z −z0 = u3t to be parallel is au1 +bu2 +cu3 = 0.

- *8. Prove that the distance ρ between the nonparallel lines


x −x0 = u1t, y −y0 = u2t, z −z0 = u3t, x −x1 = v1t, y −y1 = v2t, z −z1 = v3t

is given by

ρ =

|(u∧v)·r| |u∧v|

,

where u=(u1,u2,u3),v =(v1,v2,v3),r =(x0 −x1,y0 −y1,z0 −z1).

- 9. Determine the angle of intersection of the plane 3x +4y +7z +8 = 0 and the line x −2 = 3t, y −3 = 5t, z −5 = 9t.
- 10. The natural orientation of R2 makes it possible to associate a sign to the area A of a parallelogram generated by two linearly independent vectors u,v ∈ R2. To do this, let {ei}, i = 1,2, be the natural ordered basis of R2, and write u = u1e1 +u2e2, v = v1e1 +v2e2. Observe the matrix relation


?

- u·u u·v
- v ·u v ·v


? = ?

- u1 u2
- v1 v2


??

- u1 v1
- u2 v2


?

and conclude that

A2 =

?

- u1 u2
- v1 v2?


2

.

Since the last determinant has the same sign as the basis {u,v}, we can say that A is positive or negative according to whether the orientation of {u,v} is positive or negative. This is called the oriented area in R2.

[Page 33]

- 11. a. Show that the volume V of a parallelepiped generated by three linearly independent vectors u,v,w ∈ R3 is given by V = |(u∧v)·w|, and introduce an oriented volume in R3.

b. Prove that

V 2 =

?

- u·u u·v u·w
- v ·u v ·v v ·w
- w ·u w ·v w ·w?


.

- 12. Given the vectors v ?= 0 and w, show that there exists a vector u such that u∧v = w if and only if v is perpendicular to w. Is this vector u uniquely determined? If not, what is the most general solution?
- 13. Let u(t) = (u1(t),u2(t),u3(t)) and v(t) = (v1(t),v2(t),v3(t)) be differentiable maps from the interval (a,b) into R3. If the derivatives u′(t) and v′(t) satisfy the conditions

u′(t) = au(t)+bv(t), v′(t) = cu(t)−av(t),

wherea,b,andc areconstants, showthatu(t)∧v(t)isaconstantvector.

- 14. Find all unit vectors which are perpendicular to the vector (2,2,1) and parallel to the plane determined by the points (0,0,0), (1,−2,1), (−1,1,1).


###### 1-5. The Local Theory of Curves Parametrized by Arc Length

This section contains the main results of curves which will be used in the later parts of the book.

Let α: I = (a,b) → R3 be a curve parametrized by arc length s. Since the tangent vector α′(s) has unit length, the norm |α′′(s)| of the second derivative measurestherateofchangeoftheanglewhichneighboringtangentsmakewith the tangent at s. |α′′(s)| gives, therefore, a measure of how rapidly the curve pulls away from the tangent line at s, in a neighborhood of s (see Fig. 1-14). This suggests the following deﬁnition.

DEFINITION. Let α: I → R3 be a curve parametrized by arc length s ∈ I. The number |α′′(s)| = k(s) is called the curvature of α at s.

If α is a straight line, α(s) = us +v, where u and v are constant vectors (|u| = 1), then k ≡ 0. Conversely, if k = |α′′(s)| ≡ 0, then by integration α(s) = us +v, and the curve is a straight line.

[Page 34]

α´´(s)

α´´(s)

α´´(s)

α´(s)

α´(s)

α´(s)

###### Figure 1-14

Notice that by a change of orientation, the tangent vector changes its direction; that is, if β(−s) = α(s), then

dβ d(−s)

(−s) = −

dα ds

(s).

Therefore, α′′(s) and the curvature remain invariant under a change of orientation.

At points where k(s) ?= 0, a unit vector n(s) in the direction α′′(s) is well deﬁned by the equation α′′(s) = k(s)n(s). Moreover, α′′(s) is normal to α′(s), because by differentiating α′(s)·α′(s) = 1 we obtain α′′(s)·α′(s) = 0. Thus, n(s) is normal to α′(s) and is called the normal vector at s. The plane determined by the unit tangent and normal vectors, α′(s) and n(s), is called the osculating plane at s. (See Fig. 1-15.)

At points where k(s) = 0, the normal vector (and therefore the osculating plane) is not deﬁned (cf. Exercise 10). To proceed with the local analysis of curves, we need, in an essential way, the osculating plane. It is therefore convenient to say that s ∈ I is a singular point of order 1 if α′′(s) = 0 (in this context, the points where α′(s) = 0 are called singular points of order 0).

In what follows, we shall restrict ourselves to curves parametrized by arc length without singular points of order 1. We shall denote by t(s) = α′(s) the unit tangent vector of α at s. Thus, t′(s) = k(s)n(s).

The unit vector b(s) = t(s)∧n(s) is normal to the osculating plane and will be called the binormal vector at s. Since b(s) is a unit vector, the length |b′(s)| measures the rate of change of the neighboring osculating planes with

[Page 35]

t b

n

n b

t

###### Figure 1-15

the osculating plane at s; that is, |b′(s)| measures how rapidly the curve pulls away from the osculating plane at s, in a neighborhood of s (see Fig. 1-15).

To compute b′(s) we observe that, on the one hand, b′(s) is normal to b(s) and that, on the other hand,

b′(s) = t′(s)∧n(s)+t(s)∧n′(s) = t(s)∧n′(s);

that is, b′(s) is normal to t(s). It follows that b′(s) is parallel to n(s), and we may write

b′(s) = τ(s)n(s)

for some function τ(s). (Warning: Many authors write −τ(s) instead of our τ(s).)

DEFINITION. Let α: I → R3 be a curve parametrized by arc length s such that α′′(s) ?= 0, s ∈ I. The number τ(s) deﬁned by b′(s) = τ(s)n(s) is called the torsion of α at s.

If α is a plane curve (that is, α(I) is contained in a plane), then the plane of the curve agrees with the osculating plane; hence, τ ≡ 0. Conversely, if τ ≡ 0 (and k ?= 0), we have that b(s) = b0 = constant, and therefore

(α(s)·b0)′ = α′(s)·b0 = 0.

It follows that α(s)·b0 = constant; hence, α(s) is contained in a plane normal to b0. The condition that k ?= 0 everywhere is essential here. In Exercise 10 we shall give an example where τ can be deﬁned to be identically zero and yet the curve is not a plane curve.

In contrast to the curvature, the torsion may be either positive or negative. The sign of the torsion has a geometric interpretation, to be given later (Sec. 1-6).

[Page 36]

Notice that by changing orientation the binormal vector changes sign, since

- b = t ∧n. It follows that b′(s), and, therefore, the torsion, remain invariant under a change of orientation.


Let us summarize our position. To each value of the parameter s, we have associated three orthogonal unit vectors t(s),n(s),b(s). The trihedron thus formed is referred to as the Frenet trihedron at s. The derivatives t′(s) = kn, b′(s) = τn of the vectors t(s) and b(s), when expressed in the basis {t,n,b}, yieldgeometricalentities(curvaturek andtorsionτ)whichgiveusinformation about the behavior of α in a neighborhood of s.

The search for other local geometrical entities would lead us to compute n′(s). However, since n = b ∧t, we have

n′(s) = b′(s)∧t(s)+b(s)∧t′(s) = −τb −kt, and we obtain again the curvature and the torsion.

For later use, we shall call the equations

t′ = kn, n′ = −kt −τb, b′ = τn.

the Frenet formulas (we have omitted the s, for convenience). In this context, the following terminology is usual. The tb plane is called the rectifying plane, and the nb plane the normal plane. The lines which contain n(s) and b(s) and pass through α(s) are called the principal normal and the binormal, respectively. The inverse R = 1/k of the curvature is called the radius of curvature at s. Of course, a circle of radius r has radius of curvature equal to r, as one can easily verify.

Physically, we can think of a curve in R3 as being obtained from a straight line by bending (curvature) and twisting (torsion). After reﬂecting on this construction, we are led to conjecture the following statement, which, roughly speaking, shows that k and τ describe completely the local behavior of the curve.

FUNDAMENTAL THEOREM OF THE LOCAL THEORY OF CURVES.Givendifferentiablefunctions k(s) > 0and τ(s), s ∈ I, thereexists a regular parametrized curve α: I → R3 such that s is the arc length, k(s) is the curvature, and τ(s) is the torsion of α. Moreover, any other curve α¯, satisfying the same conditions, differs from α by a rigid motion; that is, there exists an orthogonal linear map ρ of R3, with positive determinant, and a vector c such that α¯ = ρ ◦α +c.

The above statement is true. A complete proof involves the theorem of existence and uniqueness of solutions of ordinary differential equations and will be given in the appendix to Chap. 4. A proof of the uniqueness, up to

[Page 37]

rigid motions, of curves having the same s, k(s), and τ(s) is, however, simple and can be given here.

Proof of the Uniqueness Part of the Fundamental Theorem. We ﬁrst remark that arc length, curvature, and torsion are invariant under rigid motions; that means, for instance, that if M: R3 → R3 is a rigid motion and α = α(t) is a parametrized curve, then

? b

a

?

dα dt ? dt = ? b

a

?

d(M◦α) dt ? dt.

That is plausible, since these concepts are deﬁned by using inner or vector productsofcertainderivatives(thederivativesareinvariantundertranslations, and the inner and vector products are expressed by means of lengths and angles of vectors, and thus also invariant under rigid motions). A careful checking can be left as an exercise (see Exercise 6).

Now, assume that two curves α = α(s) and α¯ = α(s)¯ satisfy the conditions k(s) = k(s)¯ and τ(s) = τ(s)¯ , s ∈ I. Let t0,n0,b0 and t¯0,n¯0,b¯0 be the Frenet trihedrons at s = s0 ∈ I of α and α¯, respectively. Clearly, there is a rigid motion which takes α(s¯ 0) into α(s0) and t¯0,n¯0,b¯0 into t0,n0,b0. Thus, after performing this rigid motion on α¯, we have that α(s¯ 0) = α(s0) and that the Frenet trihedrons t(s),n(s),b(s) and t(s),¯ n(s),¯ b(s)¯ of α and α¯, respectively, satisfy the Frenet equations:

dt ds = kn

dt¯ ds = kn¯

dn ds = −kt −τb

dn¯ ds = −kt¯−τn¯

db ds = τn

db¯ ds = τn,¯

with t(s0) = t(s¯ 0), n(s0) = n(s¯ 0), b(s0) = b(s¯ 0).

We now observe, by using the Frenet equations, that d ds{|t −t¯|2 +|n−n¯|2 +|b −b¯|2}

- 1

- 2


= ?t −t,¯ t′ −t¯′?+?b −b,b¯ ′ −b¯′?+?n−n,n¯ ′ −n¯′?

= k?t −t,n¯ −n¯?+τ?b −b,n¯ −n¯?−k?n−n,t¯ −t¯? −τ?n−n,b¯ −b¯?

= 0

for all s ∈ I. Thus, the above expression is constant, and, since it is zero for s = s0, it is identically zero. It follows that t(s) = t(s),n(s)¯ = n(s),b(s)¯ = b(s)¯ for all s ∈ I. Since

[Page 38]

dα ds = t = t¯ =

dα¯ ds

,

we obtain (d/ds)(α −α)¯ = 0. Thus, α(s) = α(s)¯ +a, where a is a constant vector. Since α(s0) = α(s¯ 0), we have a = 0; hence, α(s) = α(s)¯ for all s ∈ I.

###### Q.E.D.

Remark 1. In the particular case of a plane curve α: I → R2, it is possible to give the curvature k a sign. For that, let {e1,e2} be the natural basis (see Sec. 1-4) of R2 and deﬁne the normal vector n(s), s ∈ I, by requiring the basis {t(s),n(s)} to have the same orientation as the basis {e1,e2}. The curvature k is then deﬁned by

dt ds = kn

and might be either positive or negative. It is clear that |k| agrees with the previous deﬁnition and that k changes sign when we change either the orientation of α or the orientation of R2 (Fig. 1-16).

t

k < 0

k > 0

t

e1

n e2

n

###### Figure 1-16

It should also be remarked that, in the case of plane curves (τ ≡ 0), the proof of the fundamental theorem, refered to above, is actually very simple (see Exercise 9).

Remark 2. Given a regular parametrized curve α: I → R3 (not necessarily parametrized by arc length), it is possible to obtain a curve β: J → R3 parametrized by arc length which has the same trace as α. In fact, let

s = s(t) = ? t t0

|α′(t)|dt, t,t0 ∈ I.

[Page 39]

Since ds/dt = |α′(t)| ?= 0, the function s = s(t) has a differentiable inverse t = t(s), s ∈ s(I) = J, where, by an abuse of notation, t also denotes the inverse function s−1 of s. Now set β = α ◦t: J → R3. Clearly, β(J) = α(I) and |β′(s)| = |(α′(t)·(dt/ds)| = 1. This shows that β has the same trace as α andisparametrizedbyarclength. Itisusualtosaythatβ isareparametrization of α(I) by arc length.

Thisfactallowsustoextendalllocalconceptspreviouslydeﬁnedtoregular curves with an arbitrary parameter. Thus, we say that the curvature k(t) of α: I → R3 at t ∈ I is the curvature of a reparametrization β: J → R3 of α(I) by arc length at the corresponding point s = s(t). This is clearly independent of the choice of β and shows that the restriction, made at the end of Sec. 1-3, of considering only curves parametrized by arc length is not essential.

In applications, it is often convenient to have explicit formulas for the geometrical entities in terms of an arbitrary parameter; we shall present some of them in Exercise 12.

###### EXERCISES

Unless explicity stated, α: I → R3 is a curve parametrized by arc length s, with curvature k(s) ?= 0, for all s ∈ I.

1. Given the parametrized curve (helix)

α(s) = ?

a cos

s c

,a sin

s c

,b

s c?

, s ∈ R,

where c2 = a2 +b2,

- a. Show that the parameter s is the arc length.
- b. Determine the curvature and the torsion of α.
- c. Determine the osculating plane of α.
- d. Show that the lines containing n(s) and passing through α(s) meet the z axis under a constant angle equal to π/2.
- e. Show that the tangent lines to α make a constant angle with the z axis.


- *2. Show that the torsion τ of α is given by


τ(s) = −

α′(s)∧α′′(s)·α′′′(s) |k(s)|2

.

3. Assume that α(I) ⊂ R2 (i.e., α is a plane curve) and give k a sign as in the text. Transport the vectors t(s) parallel to themselves in such a way that the origins of t(s) agree with the origin of R2; the end points of t(s) then describe a parametrized curve s → t(s) called the indicatrix

[Page 40]

of tangents of α. Let θ(s) be the angle from e1 to t(s) in the orientation of R2. Prove (a) and (b) (notice that we are assuming that k ?= 0).

- a. The indicatrix of tangents is a regular parametrized curve.
- b. dt/ds = (dθ/ds)n, that is, k = dθ/ds.


- *4. Assume that all normals of a parametrized curve pass through a ﬁxed point. Prove that the trace of the curve is contained in a circle.

- 5. A regular parametrized curve α has the property that all its tangent lines pass through a ﬁxed point.

- a. Prove that the trace of α is a (segment of a) straight line.
- b. Does the conclusion in part a still hold if α is not regular?


- 6. A translation by a vector v in R3 is the map A: R3 → R3 that is given by A(p) = p +v, p ∈ R3. A linear map ρ: R3 → R3 is an orthogonal transformation when ρu·ρv = u·v for all vectors u, v ∈ R3. A rigid motion in R3 is the result of composing a translation with an orthogonal transformation with positive determinant (this last condition is included because we expect rigid motions to preserve orientation).


- a. Demonstrate that the norm of a vector and the angle θ between two vectors, 0 ≤ θ ≤ π, are invariant under orthogonal transformations with positive determinant.
- b. Show that the vector product of two vectors is invariant under orthogonal transformations with positive determinant. Is the assertion still true if we drop the condition on the determinant?
- c. Show that the arc length, the curvature, and the torsion of a parametrized curve are (whenever deﬁned) invariant under rigid motions.


- *7. Let α: I → R2 be a regular parametrized plane curve (arbitrary parameter), and deﬁne n = n(t) and k = k(t) as in Remark 1. Assume that k(t) ?= 0, t ∈ I. In this situation, the curve


β(t) = α(t)+

1 k(t)

n(t), t ∈ I,

is called the evolute of α (Fig. 1-17).

- a. Show that the tangent at t of the evolute of α is the normal to α at t.
- b. Consider the normal lines of α at two neighboring points t1,t2, t1 ?= t2. Let t1 approach t2 and show that the intersection points of the normals converge to a point on the trace of the evolute of α.


[Page 41]

α β

###### Figure 1-17

- 8. The trace of the parametrized curve (arbitrary parameter) α(t) = (t,cosh t), t ∈ R,

is called the catenary.

- a. Show that the signed curvature (cf. Remark 1) of the catenary is

k(t) =

1 cosh2 t

.

- b. Show that the evolute (cf. Exercise 7) of the catenary is β(t) = (t −sinh t cosh t,2cosh t).


- 9. Given a differentiable function k(s), s ∈ I, show that the parametrized plane curve having k(s) = k as curvature is given by


α(s) = ?? cosθ(s)ds +a,? sin θ(s)ds +b?,

where

θ(s) = ? k(s)ds +ϕ,

and that the curve is determined up to a translation of the vector (a,b) and a rotation of the angle ϕ.

[Page 42]

- 10. Consider the map

α(t) =

⎧ ⎪⎨

⎪⎩

(t,0,e−1/t2), t > 0 (t,e−1/t2,0), t < 0 (0,0,0), t = 0

- a. Prove that α is a differentiable curve.
- b. Prove that α is regular for all t and that the curvature k(t) ?= 0, for t ?= 0, t ?= ±?

2/3, and k(0) = 0.

- c. Show that the limit of the osculating planes as t → 0, t > 0, is the planey = 0butthatthelimitoftheosculatingplanesast → 0, t < 0, istheplanez = 0(thisimpliesthatthenormalvectorisdiscontinuous at t = 0 and shows why we excluded points where k = 0).
- d. Show that τ can be deﬁned so that τ ≡ 0, even though α is not a plane curve.


- 11. One often gives a plane curve in polar coordinates by ρ = ρ(θ), a ≤ θ ≤ b.

- a. Show that the arc length is ? b

a

?

ρ2 +(ρ′)2 dθ, where the prime denotes the derivative relative to θ.

- b. Show that the curvature is


k(θ) =

2(ρ′)2 −ρρ′′ +ρ2 {(ρ′)2 +ρ2}3/2

.

- 12. Let α: I → R3 be a regular parametrized curve (not necessarily by arc length) and let β: J → R3 be a reparametrization of α(I) by the


arc length s = s(t), measured from t0 ∈ I (see Remark 2). Let t = t(s) be the inverse function of s and set dα/dt = α′, d2α/dt2 = α′′, etc. Prove that

- a. dt/ds = 1/|α′|, d2t/ds2 = −(α′ ·α′′/|α′|4).
- b. The curvature of α at t ∈ I is

k(t) =

|α′ ∧α′′| |α′|3

.

- c. The torsion of α at t ∈ I is


τ(t) = −

(α′ ∧α′′)·α′′′ |α′ ∧α′′|2

.

[Page 43]

- d. If α: I → R2 is a plane curve α(t) = (x(t),y(t)), the signed curvature (see Remark 1) of α at t is


k(t) =

x′y′′ −x′′y′ ((x′)2 +(y′)2)3/2

.

- *13. Assume that τ(s) ?= 0 and k′(s) ?= 0 for all s ∈ I. Show that a necessary and sufﬁcient condition for α(I) to lie on a sphere is that

R2 +(R′)2T 2 = const.,

where R = 1/k, T = 1/τ, and R′ is the derivative of R relative to s. 14. Let α: (a,b) → R2 be a regular parametrized plane curve. Assume that there exists t0, a < t0 < b, such that the distance |α(t)| from the origin to the trace of α will be a maximum at t0. Prove that the curvature k of α at t0 satisﬁes |k(t0)| ≥ 1/|α(t0)|.

- *15. Show that the knowledge of the vector function b = b(s) (binormal vector) of a curve α, with nonzero torsion everywhere, determines the curvature k(s) and the absolute value of the torsion τ(s) of α.
- *16. Showthattheknowledgeofthevectorfunctionn = n(s)(normalvector) of a curve α, with nonzero torsion everywhere, determines the curvature k(s) and the torsion τ(s) of α.

17. In general, a curve α is called a helix if the tangent lines of α make a constant angle with a ﬁxed direction. Assume that τ(s) ?= 0, s ∈ I, and prove that:

- *a. α is a helix if and only if k/τ = const.
- *b. α is a helix if and only if the lines containing n(s) and passing through α(s) are parallel to a ﬁxed plane.
- *c. α is a helix if and only if the lines containing b(s) and passing through α(s) make a constant angle with a ﬁxed direction.


d. The curve

α(s) = ?

a c ? sin θ(s)ds,

a c ? cosθ(s)ds,

- b

- c


s?,

where c2 = a2 +b2, is a helix, and that k/τ = a/b.

- *18. Let α: I → R3 be a parametrized regular curve (not necessarily by arc length) with k(t) ?= 0, τ(t) ?= 0, t ∈ I. The curve α is called a Bertrand curve if there exists a curve α¯: I → R3 such that the normal lines of α and α¯ at t ∈ I are equal. In this case, α¯ is called a Bertrand mate of α, and we can write


α(t)¯ = α(t)+rn(t).

[Page 44]

Prove that

- a. r is constant.
- b. α is a Bertrand curve if and only if there exists a linear relation Ak(t)+Bτ(t) = 1, t ∈ I,

where A,B are nonzero constants and k and τ are the curvature and torsion of α, respectively.

- c. If α has more than one Bertrand mate, it has inﬁnitely many Bertrand mates. This case occurs if and only if α is a circular helix.


###### 1-6. The Local Canonical Form†

One of the most effective methods of solving problems in geometry consists of ﬁnding a coordinate system which is adapted to the problem. In the study of local properties of a curve, in the neighborhood of the point s, we have a natural coordinate system, namely the Frenet trihedron at s. It is therefore convenient to refer the curve to this trihedron.

Let α: I → R3 be a curve parametrized by arc length without singular points of order 1. We shall write the equations of the curve, in a neighborhood of s0, using the trihedron t(s0),n(s0),b(s0) as a basis for R3. We may assume, without loss of generality, that s0 = 0, and we shall consider the (ﬁnite) Taylor expansion

α(s) = α(0)+sα′(0)+

s2 2

α′′(0)+

s3 6

α′′′(0)+R,

where lim

s→0

R/s3 = 0. Since α′(0) = t, α′′(0) = kn, and

α′′′(0) = (kn)′ = k′n+kn′ = k′n−k2t −kτb, we obtain

α(s)−α(0) = ?s −

k2s3 3! ?t +?

s2k 2 +

s3k′ 3! ?n−

s3 3!

kτb +R,

where all terms are computed at s = 0.

Let us now take the system Oxyz in such a way that the origin O agrees with α(0) and that t = (1,0,0), n = (0,1,0), b = (0,0,1). Under these conditions, α(s) = (x(s),y(s),z(s)) is given by

†This section may be omitted on a ﬁrst reading.

[Page 45]

1-6. The Local Canonical Form 29

- x(s) = s −

k2s3 6 +Rx,

- y(s) =

k 2

s2 +

k′s3 6 +Ry,

- z(s) = −


kτ 6

s3 +Rz,

###### (1)

where R = (Rx,Ry,Rz). The representation (1) is called the local canonical form of α, in a neighborhood of s = 0. In Fig. 1-18 is a rough sketch of the projections of the trace of α, for s small, in the tn,tb, and nb planes.

n n

t n

b t

b

Projection over the plane t n

Projection over the plane n b

Projection over the plane t b

b

t

###### Figure 1-18

Below we shall describe some geometrical applications of the local canonical form. Further applications will be found in the Exercises.

A ﬁrst application is the following interpretation of the sign of the torsion. Fromthethirdequationof(1)itfollowsthatifτ < 0ands issufﬁcientlysmall, then z(s) increases with s. Let us make the convention of calling the “positive side” of the osculating plane that side toward which b is pointing. Then, since z(0) = 0, when we describe the curve in the direction of increasing arc length, the curve will cross the osculating plane at s = 0, pointing toward the positive

[Page 46]

side (see Fig. 1-19). If, on the contrary, τ > 0, the curve (described in the direction of increasing arc length) will cross the osculating plane pointing to the side opposite the positive side.

Negative torsion Positive torsion

###### Figure 1-19

The helix of Exercise 1 of Sec. 1-5 has negative torsion. An example of a curve with positive torsion is the helix

α(s) = ?

a cos

s c

,a sin

s c

,−b

s c?

obtained from the ﬁrst one by a reﬂection in the xz plane (see Fig. 1-19).

Remark. It is also usual to deﬁne torsion by b′ = −τn. With such a deﬁnition, the torsion of the helix of Exercise 1 becomes positive.

Another consequence of the canonical form is the existence of a neighborhood J ⊂ I of s = 0 such that α(J) is entirely contained in the one side of the rectifying plane toward which the vector n is pointing (see Fig. 1-18). In fact, since k > 0, we obtain, for s sufﬁciently small, y(s) ≥ 0, and y(s) = 0 if and only if s = 0. This proves our claim.

As a last application of the canonical form, we mention the following property of the osculating plane. The osculating plane at s is the limit position of the plane determined by the tangent line at s and the point α(s +h) when h → 0. To prove this, let us assume that s = 0. Thus, every plane containing the tangent at s = 0 is of the form z = cy or y = 0. The plane y = 0 is the rectifying plane that, as seen above, contains no points near α(0) (except α(0) itself) and that may therefore be discarded from our considerations. The condition for the plane z = cy to pass through α(s +h) is (s = 0)

c =

z(h) y(h) =

−

k 6

τh3 +···

k 2

h2 +

k2 6

h3 +···

.

Letting h → 0, we see that c → 0. Therefore, the limit position of the plane z(s) = c(h)y(s) is the plane z = 0, that is, the osculating plane, as we wished.

[Page 47]

###### EXERCISES

*1. Let α: I → R3 be a curve parametrized by arc length with curvature k(s) ?= 0, s ∈ I. Let P be a plane satisfying both of the following conditions:

- 1. P contains the tangent line at s.
- 2. Given any neighborhood J ⊂ I of s, there exist points of α(J) in both sides of P.


Prove that P is the osculating plane of α at s.

- 2. Let α: I → R3 be a curve parametrized by arc length, with curvature k(s) ?= 0, s ∈ I. Show that

*a. The osculating plane at s is the limit position of the plane passing

through α(s), α(s +h1), α(s +h2) when h1,h2 → 0.

b. The limit position of the circle passing through α(s), α(s +h1), α(s +h2) when h1, h2 → 0 is a circle in the osculating plane at s, the center of which is on the line that contains n(s) and the radius of which is the radius of curvature 1/k(s); this circle is called the osculating circle at s.

- 3. Show that the curvature k(t) ?= 0 of a regular parametrized curve α: I → R3 is the curvature at t of the plane curve π ◦α, where π is the normal projection of α over the osculating plane at t.


###### 1-7. Global Properties of Plane Curves†

In this section we want to describe some results that belong to the global differential geometry of curves. Even in the simple case of plane curves, the subject already offers examples of nontrivial theorems and interesting questions. To develop this material here, we must assume some plausible facts without proofs; we shall try to be careful by stating these facts precisely. Although we want to come back later, in a more systematic way, to global differential geometry (Chap. 5), we believe that this early presentation of the subject is both stimulating and instructive.

This section contains three topics in order of increasing difﬁculty: (A) the isoperimetric inequality, (B) the four-vertex theorem, and (C) the Cauchy-Crofton formula. The topics are entirely independent, and some or all of them can be omitted on a ﬁrst reading.

A differentiable function on a closed interval [a,b] is the restriction of a differentiable function deﬁned on an open interval containing [a,b].

†This section may be omitted on a ﬁrst reading.

[Page 48]

A closed plane curve is a regular parametrized curve α: [a,b] → R2 such that α and all its derivatives agree at a and b; that is,

α(a) = α(b), α′(a) = α′(b), α′′(a) = α′′(b),....

The curve α is simple if it has no further self-intersections; that is, if t1,t2 ∈ [a,b), t1 ?= t2, then α(t1) ?= α(t2) (Fig. 1-20).

(a) A simple closed curve (b) A (nonsimple) closed curve

###### Figure 1-20

(a) A simple closed curve C on a torus T; C bounds no region on T.

T

C

(b) C is positively oriented.

Interior of C

C

###### Figure 1-21

We usually consider the curve α: [0,l] → R2 parametrized by arc length s; hence, l is the length of α. Sometimes we refer to a simple closed curve C, meaning the trace of such an object. The curvature of α will be taken with a sign, as in Remark 1 of Sec. 1-5 (see Fig. 1-20).

We assume that a simple closed curve C in the plane bounds a region of this plane that is called the interior of C. This is part of the so-called Jordan curve theorem (a proof will be given in Sec. 5-7, Theorem 1), which does not hold, for instance, for simple curves on a torus (the surface of a doughnut;

[Page 49]

see Fig. 1-21(a)). Whenever we speak of the area bounded by a simple closed curve C, we mean the area of the interior of C. We assume further that the parameter of a simple closed curve can be so chosen that if one is going along the curve in the direction of increasing parameters, then the interior of the curve remains to the left (Fig. l-21(b)). Such a curve will be called positively oriented.

###### A. The Isoperimetric Inequality

This is perhaps the oldest global theorem in differential geometry and is related to the following (isoperimetric) problem. Of all simple closed curves in the plane with a given length l, which one bounds the largest area? In this form, the problem was known to the Greeks, who also knew the solution, namely, the circle. A satisfactory proof of the fact that the circle is a solution to the isoperimetric problem took, however, a long time to appear. The main reason seems to be that the earliest proofs assumed that a solution should exist. It was only in 1870 that K. Weierstrass pointed out that many similar questions did not have solutions and gave a complete proof of the existence of a solution to the isoperimetric problem. Weierstrass’ proof was somewhat hard, in the sense that it was a corollary of a theory developed by him to handle problems of maximizing (or minimizing) certain integrals (this theory is called calculus of variations and the isoperimetric problem is a typical example of the problems it deals with). Later, more direct proofs were found. The simple proof we shall present is due to E. Schmidt (1939). For another direct proof and further bibliography on the subject, one may consult Reference [10] in the Bibliography.

We shall make use of the following formula for the area A bounded by a positively oriented simple closed curve α(t) = (x(t),y(t)), where t ∈ [a,b] is an arbitrary parameter:

A = −? b

a

y(t)x′(t)dt = ? b

a

x(t)y′(t)dt =

1 2 ? b

a

(xy′ −yx′)dt (1)

Notice that the second formula is obtained from the ﬁrst one by observing that ? b

a

xy′ dt = ? b

a

(xy)′ dt −? b

a

x′y dt = [xy(b)−xy(a)]−? b

a

x′y dt

= −? b

a

x′y dt,

since the curve is closed. The third formula is immediate from the ﬁrst two.

To prove the ﬁrst formula in Eq. (1), we consider initially the case of Fig. 1-22 where the curve is made up of two straight-line segments parallel to the y axis and two arcs that can be written in the form

[Page 50]

f1

f2 t = t3

t = a, t = b

- t = t1
- t = t2


y

x 0 x0 x1

###### Figure 1-22

y = f1(x) and y = f2(x),x ∈ [x0,x1],f1 > f2. Clearly, the area bounded by the curve is

A = ? x

1

x0

f1(x)dx −? x

1

x0

f2(x)dx.

Since the curve is positively oriented, we obtain, with the notation of Fig. l-22,

A = −? t

1

a

y(t)x′(t)dt −? t

3

t2

y(t)x′(t)dt = −? b

a

y(t)x′(t)dt,

since x′(t) = 0 along the segments parallel to the y axis. This proves Eq. (1) for this case.

To prove the general case, it must be shown that it is possible to divide the region bounded by the curve into a ﬁnite number of regions of the above type. This is clearly possible (Fig. 1-23) if there exists a straight line E in the plane such that the distance ρ(t) of α(t) to this line is a function with ﬁnitely many critical points (a critical point is a point where ρ′(t) = 0). The last assertion is true, but we shall not go into its proof. We shall mention, however, that Eq. (1) can also be obtained by using Stokes’ (Green’s) theorem in the plane (see Exercise 15).

THEOREM 1 (The Isoperimetric Inequality). LetCbeasimpleclosed plane curve with length l, and let A be the area of the region bounded by C. Then

l2 −4πA ≥ 0, (2) and equality holds if and only if C is a circle.

Proof. Let E and E′ be two parallel lines which do not meet the closed curve C, and move them together until they ﬁrst meet C. We thus obtain two parallel tangent lines to C, L and L′, so that the curve is entirely contained

[Page 51]

in the strip bounded by L and L′. Consider a circle S1 which is tangent to both L and L′ and does not meet C. Let O be the center of S1 and take a coordinate system with origin at O and the x axis perpendicular to L and L′ (Fig. 1-24). Parametrize C by arc length, α(s) = (x(s),y(s)), so that it is positively oriented and the tangency points of L and L′ are s = 0 and s = s1, respectively.

y

E

0

x

α(t)

ρ(t)

###### Figure 1-23

E´ L´ L E C

s = 0

s = s1

S1

x

y

2r

0

α

α

###### Figure 1-24

[Page 52]

We can assume that the equation of S1 is α(s)¯ = (x(s),¯ y(s))¯ = (x(s),y(s)),s¯ ∈ [0,l].

Let 2r be the distance between L and L′. By using Eq. (1) and denoting by A¯ the area bounded by S1, we have

A = ? l

0

xy′ ds, A¯ = πr2 = −? l

0

yx¯ ′ ds.

Thus,

A+πr2 = ? l

0

(xy′ −yx¯ ′)ds ≤ ? l

0

?

(xy′ −yx¯ ′)2 ds

≤ ? l

0

?

(x2 +y¯2)((x′)2 +(y′)2)ds = ? l

0

?x¯2 +y¯2 ds

= lr,

###### (3)

where we used that the inner product of two vectors v1 and v2 satisﬁes |(v1 ·v2)|2 ≤ |(v1)|2|(v2)|2. (3′)

Later in the proof, we will need that equality holds in (3′) if and only if one vector is a multiple of the other.

We now notice the fact that the geometric mean of two positive numbers is smaller than or equal to their arithmetic mean, and equality holds if and only if they are equal. lt follows that

√

A

√

πr2 ≤ 12(A+πr2) ≤ 12lr. (4) Therefore, 4πAr2 ≤ l2r2, and this gives Eq. (2).

Now, assume that equality holds in Eq. (2). Then equality must hold everywhere in Eqs. (3) and (4). From the equality in Eq. (4) it follows that A = πr2. Thus, l = 2πr and r does not depend on the choice of the direction of L. Furthermore, equality in Eq. (3) implies that

(x,y)¯ = λ(y′,−x′) that is,

λ =

- x

- y′ =


y¯ x′ = ?

x2 +y¯2 ?

(y′)2 +(x′)2

= ±r.

Thus, x = ±ry′. Since r does not depend on the choice of the direction of L, we can interchange x and y in the last relation and obtain y = ±rx′. Thus,

[Page 53]

x2 +y2 = r2((x′)2 +(y′)2) = r2

and C is a circle, as we wished. Q.E.D.

Remark 1. It is easily checked that the above proof can be applied to C1 curves, that is, curves α(t) = (x(t),y(t)), t ∈ [a,b], for which we require only that the functions x(t), y(t) have continuous ﬁrst derivatives (which, of course, agree at a and b if the curve is closed).

Remark2.Theisoperimetricinequalityholdstrueforawideclassofcurves. Directproofshavebeenfoundthatworkaslongaswecandeﬁnearclengthand area for the curves under consideration. For the applications, it is convenient to remark that the theorem holds for piecewise C1 curves, that is, continuous curves that are made up by a ﬁnite number of C1 arcs. These curves can have a ﬁnite number of corners, where the tangent is discontinuous (Fig. 1-25).

A piecewise C1curve Figure 1-25

###### B. The Four-Vertex Theorem

We shall need further general facts on plane closed curves. Let α: [0,l] → R2 be a plane closed curve given by α(s) = (x(s),y(s)). Since s is the arc length, the tangent vector t(s) = (x′(s),y′(s)) has unit length. It is convenient to introduce the tangent indicatrix t: [0,l] → R2 that is given by t(s) = (x′(s),y′(s)); this is a differentiable curve, the trace of which is contained in a circle of radius 1 (Fig. 1-26). Observe that the velocity vector of the tangent indicatrix is

dt ds = (x′′(s),y′′(s))

= α′′(s) = kn,

where n is the normal vector, oriented as in Remark 2 of Sec. 1-5, and k is the curvature of α.

[Page 54]

y

t(s)

t(s)

t'(s) = kn

n(s)

x

θ θ 0

###### Figure 1-26

Let θ(s), 0 < θ(s) < 2π, be the angle that t(s) makes with the x axis; that is, x′(s) = cosθ(s), y′(s) = sin θ(s). Since

θ(s) = arctan

y′(s) x′(s)

,

θ = θ(s) is locally well deﬁned (that is, it is well deﬁned in a small interval about each s) as a differentiable function and

dt ds =

d ds

(cosθ,sin θ)

= θ′(−sin θ,cosθ) = θ′n.

This means that θ′(s) = k(s) and suggests deﬁning a global differentiable function θ: [0,l] → R by

θ(s) = ? s

0

k(s)ds.

Since

θ′ = k = x′y′′ −x′′y′ = ?arctan

y′ x′

?′ ,

thisglobalfunctionagrees, uptoconstants, withthepreviouslocallydeﬁnedθ. Intuitively, θ(s) measures the total rotation of the tangent vector, that is, the total angle described by the point t(s) on the tangent indicatrix, as we run the curve α from 0 to s. Since α is closed, this angle is an integer multiple I of

2π; that is, ? l

o

k(s)ds = θ(l)−θ(0) = 2πI.

The integer I is called the rotation index of the curve α.

[Page 55]

In Fig. 1-27 are some examples of curves with their rotation indices. Observe that the rotation index changes sign when we change the orientation of the curve. Furthermore, the deﬁnition is so set that the rotation index of a positively oriented simple closed curve is positive.

An important global fact about the rotation index is given in the following theorem, which will be proved later in the book (Sec. 5-7, Theorem 2).

THE THEOREM OF TURNING TANGENTS. The rotation index of a simple closed curve is ±1, where the sign depends on the orientation of the curve.

A regular, plane (not necessarily closed) curve α: [a,b] → R2 is convex if, for all t ∈ [a,b], the trace α([a,b]) of α lies entirely on one side of the closed half-plane determined by the tangent line at t (Fig. 1-28).

Avertex of a regular plane curve α: [a,b] → R2 is a point t ∈ [a,b] where k′(t) = 0. For instance, an ellipse with unequal axes has exactly four vertices, namely the points where the axes meet the ellipse (see Exercise 3). It is an interesting global fact that this is the least number of vertices for all closed convex curves.

###### THEOREM 2 (The Four-Vertex Theorem). A simple closed convex

curve has at least four vertices. Before starting the proof, we need a lemma. LEMMA. Let α: [0,l] → R2 be a plane closed curve parametrized by arc

length and let A, B, and C be arbitrary real numbers. Then ? l

0

(Ax +By +C)

dk ds

ds = 0, (5)

where the functions x = x(s), y = y(s) are given by α(s) = (x(s),y(s)), and k is the curvature of α.

Proof of the Lemma. Recall that there exists a differentiable function θ: [0,l] → R such that x′(s) = cosθ,y′(s) = sin θ. Thus, k(s) = θ′(s) and

x′′ = −ky′, y′′ = kx′. Therefore, since the functions involved agree at 0 and l, ? l

0

k′ ds = 0, ? l 0

xk′ ds = −? l

0

kx′ ds = −? l

0

y′′ ds = 0, ? l 0

yk′ ds = −? l

0

ky′ ds = ? l

0

x′′ ds = 0. Q.E.D.

[Page 56]

Curve

Curve

Tangent indicatrix

Tangent indicatrix

s = 0

s = 0

s = 0

s = 0

I = 1

I = 0

I = 2

I = –1

###### Figure 1-27

[Page 57]

Convex curves

Nonconvex curves

###### Figure 1-28

Proof of the Theorem. Parametrize the curve by arc length, α: [0,l] → R2. Since k = k(s) is a continuous function on the closed interval [0,l], it reaches a maximum and a minimum on [0,l] (this is a basic fact in real functions; a proof can be found, for instance, in the appendix to Chap. 5, Prop. 13). Thus, α has at least two vertices, α(s1) = p and α(s2) = q. Let L be the straight line passing through p and q, and let β and γ be the two arcs of α which are determined by the points p and q.

We claim that each of these arcs lies on a deﬁnite side of L. Otherwise, it meets L in a point r distinct from p and q (Fig. 1-29(a)). By convexity, and since p, q, r are distinct points on C, the tangent line at the intermediate point, say p, has to agree with L. Again, by convexity, this implies that L is tangent to C at the three points p, q, and r. But then the tangent to a point near p (the intermediate point) will have q and r on distinct sides, unless the whole segment rq of L belongs to C (Fig. 1-29(b)). This implies that k = 0 at p and q. Since these are points of maximum and minimum for k, k ≡ 0 on C, a contradiction.

Let Ax +By +C = 0 be the equation of L. If there are no further vertices, k′(s) keeps a constant sign on each of the arcs β and γ. We can then arrange the signs of all the coefﬁcients A,B,C so that the integral in Eq. (5) is positive. This contradiction shows that there is a third vertex and that k′(s) changes sign on β or γ, say, on β. Since p and q are points of maximum and minimum, k′(s) changes sign twice on β. Thus, there is a fourth vertex. Q.E.D.

The four-vertex theorem has been the subject of many investigations. The theorem also holds for simple, closed (not necessarily convex) curves, but the proof is harder. For further literature on the subject, see Reference [10].

[Page 58]

p

r

q

L

γ

β

(a)

p r q

L

(b)

###### Figure 1-29

Later (Sec. 5-7, Prop. 1) we shall prove that a plane closed curve is convex if and only if it is simple and can be oriented so that its curvature is positive or zero. From that, and the proof given above, we see that we can reformulate the statement of the four-vertex theorem as follows. The curvature function of a closed convex curve is (nonnegative and) either constant or else has at least two maxima and two minima. It is then natural to ask whether such curvature functions do characterize the convex curves. More precisely, we can ask the following question. Let k: [a,b] → R be a differentiable nonnegative function such that k agrees, with all its derivatives, at a and b. Assume that k is either constant or else has at least two maxima and two minima. Is there a simple closed curve α: [a,b] → R2 such that the curvature of α at t is k(t)?

For the case where k(t) is strictly positive, H. Gluck answered the above question afﬁrmatively (see H. Gluck, “The Converse to the Four Vertex Theorem,” L’Enseignement Mathématique T. XVII, fasc. 3–4 (1971), 295–309). His methods, however, do not apply to the case k ≥ 0.

###### C. The Cauchy-Crofton Formula

Our last topic in this section will be dedicated to ﬁnding a theorem which, roughly speaking, describes the following situation. Let C be a regular curve in the plane. We look at all straight lines in the plane that meet C and assign to each such line a multiplicity which is the number of its intersection points with C (Fig. 1-30).

We ﬁrst want to ﬁnd a way of assigning a measure to a given subset of straight lines in the plane. It should not be too surprising that this is possible. After all, we assign a measure (area) to point subsets of the plane. Once we realize that a straight line can be determined by two parameters (for instance,

[Page 59]

n = 2

n = 1

n = 3

n = 4

C

y

p

L

x 0

θ

Figure 1-30. n is the multiplicity of the corresponding straight line.

Figure 1-31. L is determined by p and θ.

p and θ in Fig. 1-31), we can think of the straight lines in the plane as points in a region of a certain plane. Thus, what we want is to ﬁnd a “reasonable” way of measuring “areas” in such a plane.

Having chosen this measure, we want to apply it and ﬁnd the measure of the set of straight lines (counted with multiplicities) which meet C. The result is quite interesting and can be stated as follows.

THEOREM 3 (The Cauchy-Crofton Formula). Let C be a regular plane curve with length l. The measure of the set of straight lines (counted with multiplicities) which meet C is equal to 2l.

Before going into the proof we must deﬁne what we mean by a reasonable measureinthesetofstraightlinesintheplane. First, letuschooseaconvenient system of coordinates for such a set.Astraight line L in the plane is determined by a unit vector v = (cosθ,sin θ) normal to L and the inner product p = v ·α = x cosθ +y sin θ of v with the position vector α = (x,y) of L. Notice thattodetermineLintermsoftheparameters(p,θ), wemustidentify(p,θ) ∼ (p,θ +2kπ), k an integer, and also identify (p,θ) ∼ (−p,θ±π).

Thus we can replace the set of all straight lines in the plane by the set

L = {(p,θ) ∈ R2;(p,θ) ∼ (p,θ +2kπ) and (p,θ) ∼ (−p,θ±π)}.

We will show that, up to a choice of units, there is only one reasonable measure in this set.

To decide what we mean by reasonable, let us look more closely at the usual measure of areas in R2. We need a deﬁnition.

[Page 60]

ArigidmotioninR2 isamapF:R2 → R2 givenby(x,¯ y)¯ → (x,y), where (Fig. 1-32)

0

p = (x, y)

p = (x, y)

a

b

φ

###### Figure 1-32

- x = a +x¯ cosϕ −y¯ sin ϕ
- y = b +x¯ sin ϕ +y¯ cosϕ.


###### (6)

Now, to deﬁne the area of a set S ⊂ R2 we consider the double integral ??

S

dx dy;

that is, we integrate the “element of area” dx dy over S. When this integral exists in some sense, we say that S is measurable and deﬁne the area of S as the value of the above integral. From now on, we shall assume that all the integrals involved in our discussions do exist.

Notice that we could have chosen some other element of area, say, xy2 dx dy. The reason for the choice of dx dy is that, up to a factor, this is the only element of area that is invariant under rigid motions. More precisely, we have the following proposition.

PROPOSITION 1. Let f(x,y) be a continuous function deﬁned in R2. For any set S ⊂ R2, deﬁne the area A of S by

A(S) = ??

S

f(x,y)dx dy

(of course, we are considering only those sets for which the above integral exists). Assume that A is invariant under rigid motions; that is, if S is any set and S¯ = F−1(S), where F is the rigid motion (6), we have

A(S¯) = ??

S¯

f(x¯,y¯)dx d¯ y¯ = ??

S

f(x,y)dx dy = A(S).

Then f(x,y) = const.

[Page 61]

Proof. We recall the formula for change of variables in multiple integrals (Buck, Advanced Calculus, p. 301, or Exercise 15 of this section):

??

S

f (x,y)dx dy = ??

S¯

f (x(x,¯ y),y(¯ x,¯ y))¯

∂(x,y) ∂(x,¯ y)¯

dx¯ dy.¯ (7)

Here, x = x(x,¯ y)¯ , y = y(x,¯ y)¯ are functions with continuous partial derivatives which deﬁne the transformation of variables T : R2 → R2, S¯ = T −1(S), and

∂(x,y) ∂(x,¯ y)¯ =

?

∂x

- ∂x¯

- ∂x

- ∂y¯


- ∂y ∂x¯


∂y ∂y¯

?

is the Jacobian of the transformation T . In our particular case, the transformation is the rigid motion (6) and the Jacobian is

∂(x,y) ∂(x,¯ y)¯ =

?

cosϕ −sin ϕ sin ϕ cosϕ?

= 1.

By using this fact and Eq. (7), we obtain ??

S¯

f (x(x,¯ y),y(¯ x,¯ y))d¯ x¯ dy¯ = ??

S¯

f (x,¯ y)d¯ x¯ dy.¯

Since this is true for all S, we have f (x(x,¯ y),y(¯ x,¯ y))¯ = f (x,¯ y).¯

We now use the fact that for any pair of points (x,y), (x,¯ y)¯ in R2 there exists a rigid motion F such that F(x,¯ y)¯ = (x,y). Thus,

f (x,y) = (f ◦F)(x,¯ y)¯ = f (x,¯ y),¯ and f (x,y) = const., as we wished. Q.E.D.

Remark 3. The above proof rests upon two facts: ﬁrst, that the Jacobian of a rigid motion is 1, and, second, that the rigid motions are transitive on points of the plane; that is, given two points in the plane there exists a rigid motion taking one point into the other.

With these preparations, we can ﬁnally deﬁne a measure in the set L. We ﬁrst observe that the rigid motion (6) induces a transformation on L. In fact, Eq. (6) maps the line x cosθ +y sin θ = p into the line

[Page 62]

x¯ cos(θ −ϕ)+y¯ sin(θ −ϕ) = p −a cosθ −b sin θ. This means that the transformation induced by Eq. (6) on L is

p¯ = p −a cosθ −b sin θ, θ¯ = θ −ϕ.

It is easily checked that the Jacobian of the above transformation is 1 and that such transformations are also transitive on the set of lines in the plane. We then deﬁne the measure of a set S ⊂ L as

??

S

dp dθ.

In the same way as in Prop. 1, we can then prove that this is, up to a constant factor, the only measure on L that is invariant under rigid motions. This measure is, therefore, as reasonable as it can be. We can now sketch a proof of Theorem 3.

Sketch of Proof of Theorem 3. First assume that the curve C is a segment of astraightlinewithlengthl. Sinceourmeasureisinvariantunderrigidmotions, we can assume that the coordinate system has its origin 0 in the middle point of C and that the x axis is in the direction of C. Then the measure of the set of straight lines that meet C is (Fig. 1-33)

?? dp dθ = ? 2π

0

?? |cosθ|(l/2)

0

dp? dθ = ? 2π

0

l 2|cosθ|dθ = 2l.

y

l x 2

0 θ

y

x

l 2

θ

###### Figure 1-33

Next, let C be a polygonal line composed of a ﬁnite number of segments Ci with length li(

?

li = l). Let n = n(p,θ) be the number of intersection

[Page 63]

points of the straight line (p,θ) with C. Then, by summing up the results for each segment Ci, we obtain

?? ndp dθ = 2

?

i

li = 2l, (8)

which is the Cauchy-Crofton formula for a polygonal line.

Finally, by a limiting process, it is possible to extend the above formula to any regular curve, and this will prove Theorem 3. Q.E.D.

It should be remarked that the general ideas of this topic belong to a branch of geometry known under the name of integral geometry. A survey of the subject can be found in L. A. Santaló, “Integral Geometry,” in Studies in Global Geometry and Analysis, edited by S. S. Chern, The Mathematical Association of America, 1967, 147–193.

The Cauchy-Crofton formula can be used in many ways. For instance, if a curve is not rectiﬁable (see Exercise 9, Sec. 1-3) but the left-hand side of Eq. (8) has a meaning, this can be used to deﬁne the “length” of such a curve. Equation (8) can also be used to obtain an efﬁcient way of estimating lengths of curves. Indeed, a good approximation for the integral in Eq. (8) is given as follows.† Consider a family of parallel straight lines such that two consecutive lines are at a distance r. Rotate this family by angles of π/4,2π/4,3π/4 in order to obtain four families of straight lines. Let n be the number of intersection points of a curve C with all these lines. Then

- 1

- 2


nr

π 4

is an approximation to the integral

- 1

- 2 ?? ndp dθ = length of C


and therefore gives an estimate for the length of C. To have an idea of how good this estimate can be, let us work out an example.

Example. Figure 1-34 is a drawing of an electron micrograph of a circular DNAmolecule and we want to estimate its length. The four families of straight lines at a distance of 7 millimeters and angles of π/4 are drawn over the picture (a more practical way would be to have this family drawn once and for all on

†I am grateful to Robert Gardner (1939–1998) for suggesting this application and the example that follows.

[Page 64]

| | | | | | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |
| | | | | | | | | | | | | | |


Figure 1-34. Reproduced from H. Ris and B. C. Chandler, Cold Spring Harbor Symp. Quant. Biol. 28, 2 (1963), with permission.

transparent paper). The number of intersection points is found to be 153. Thus,

- 1

- 2


n

π 4 =

1 2

153

3.14 4 ∼ 60.

Since the reference line in the picture represents l micrometer (=10−6 meter) and measures, in our scale, 25 millimeters, r = 257 , and thus the length of this DNA molecule, from our values, is approximately

60?

7 25? = 16.8 micrometers.

The actual value is 16.3 micrometers.

###### EXERCISES

- *1. Is there a simple closed curve in the plane with length equal to 6 feet and bounding an area of 3 square feet?
- *2. Let AB be a segment of straight line and let l > length of AB. Show that the curve C joining A and B, with length l, and such that together with AB bounds the largest possible area is an arc of a circle passing through A and B (Fig. 1-35).


[Page 65]

A B

C

h

d

p

L

C

T

###### Figure 1-35 Figure 1-36

3. Compute the curvature of the ellipse

x = a cost, y = b sin t, t ∈ [0,2π],a ?= b,

and show that it has exactly four vertices, namely, the points (a,0), (−a,0), (0,b), (0,−b).

- *4. Let C be a plane curve and let T be the tangent line at a point p ∈ C. Draw a line L parallel to the normal line at p and at a distance d of p (Fig. 1-36). Let h be the length of the segment determined on L by C and T (thus, h is the “height” of C relative to T ). Prove that

|k(p)| = lim

d→0

2h d2

,

where k(p) is the curvature of C at p.

- *5. If a closed plane curve C is contained inside a disk of radius r, prove that there exists a point p ∈ C such that the curvature k of C at p satisﬁes |k| ≥ 1/r.


- 6. Let α(s), s ∈ [0,l] be a closed convex plane curve positively oriented. The curve

β(s) = α(s)−rn(s),

where r is a positive constant and n is the normal vector, is called a parallel curve to α (Fig. 1-37). Show that

- a. Length of β = length of α +2πr.
- b. A(β) = A(α)+rl +πr2.
- c. kβ(s) = kα(s)/(1+rkα(s)).


For (a)-(c), A( ) denotes the area bounded by the corresponding curve, and kα,kβ are the curvatures of α and β, respectively.

- 7. Let α: R → R2 be a plane curve deﬁned in the entire real line R.Assume that α does not pass through the origin 0 = (0,0) and that both


lim

t→+∞

|α(t)| = ∞ and lim

t→−∞

|α(t)| = ∞.

[Page 66]

n

n

r

r

β

α

###### Figure 1-37

- a. Prove that there exists a point t0 ∈ R such that |α(t0)| ≤ |α(t)| for all t ∈ R.
- b. Show, by an example, that the assertion in part a is false if one does not assume that both limt→+∞ |α(t)| = ∞ and limt→−∞ |α(t)| = ∞.


8.*a. Let α(s), s ∈ [0,l], be a plane simple closed curve. Assume that the curvature k(s) satisﬁes 0 < k(s) ≤ c, where c is a constant (thus, α is less curved than a circle of radius 1/c). Prove that

length of α ≥

2π c

.

b. In part a replace the assumption of being simple by “α has rotation

index N.” Prove that

length of α ≥

2πN c

.

- *9. Aset K ⊂ R2 is convex if given any two points p, q ∈ K the segment of straight line pq is contained in K (Fig. 1-38). Prove that a simple closed convex curve bounds a convex set.

10. Let C be a convex plane curve. Prove geometrically that C has no self-

intersections.

- *11. Given a nonconvex simple closed plane curve C, we can consider its convex hull H (Fig. 1-39), that is, the boundary of the smallest convex set containing the interior of C. The curve H is formed by arcs of C and by the segments of the tangents to C that bridge “the nonconvex gaps” (Fig. 1-39). It can be proved that H is a C1 closed convex curve. Use this to show that, in the isoperimetric problem, we can restrict ourselves to convex curves.
- *12. Consider a unit circle S1 in the plane. Show that the ratio M1/M2 = 21, where M2 is the measure of the set of straight lines in the plane that meet S1 and M1 is the measure of all such lines that determine in S1 a chord


[Page 67]

K

q

p

H

C

###### Figure 1-38 Figure 1-39

|y|1<br><br>θ|
|---|---|
|0| |


x

p

S1 √3

p

C

p'

T'

###### Figure 1-40 Figure 1-41

of length > √3. Intuitively, this ratio is the probability that a straight line that meets S1 determines in S1 a chord longer than the side of an equilateral triangle inscribed in S1 (Fig. 1-40).

- 13. Let C be an oriented plane closed curve with curvature k > 0. Assume that C has at least one point p of self-intersection. Prove that

- a. There is a point p′ ∈ C such that the tangent line T ′ at p′ is parallel to some tangent at p.
- b. The rotation angle of the tangent in the positive arc of C made up by pp′p is > π (Fig. 1-41).
- c. The rotation index of C is ≥ 2.


- 14. a. Show that if a straight line L meets a closed convex curve C, then either L is tangent to C or L intersects C in exactly two points.


b. Use part a to show that the measure of the set of lines that meet C

(without multiplicities) is equal to the length of C.

[Page 68]

- 15. Green’s theorem in the plane is a basic fact of calculus and can be stated as follows. Let a simple closed plane curve be given by α(t) = (x(t),y(t)), t ∈ [a,b]. Assume that α is positively oriented, let C be its trace, and let R be the interior of C. Let p = p(x,y), q = q(x,y) be


real functions with continuous partial derivatives px,py,qx,qy. Then ??

R

(qx −py)dx dy = ?

C

?p

dx dt +q

dy dt ? dt, (9)

where in the second integral it is understood that the functions p and q are restricted to α and the integral is taken between the limits t = a and t = b. In parts a and b below we propose to derive, from Green’s theorem, a formula for the area of R and the formula for the change of variables in double integrals (cf. Eqs. (1) and (7) in the text).

- a. Set q = x and p = −y in Eq. (9) and conclude that

A(R) = ??

R

dx dy =

- 1

- 2 ? b


a

?x(t)

dy dt −y(t)

dx dt ? dt.

- b. Let f(x,y) be a real function with continuous partial derivatives and T : R2 → R2 be a transformation of coordinates given by the functions x = x(u,v), y = y(u,v), which also admit continuous partial


derivatives. Choose in Eq. (9) p = 0 and q so that qx = f . Apply successively Green’s theorem, the map T, and Green’s theorem again to obtain

??

R

f (x,y)dx dy

= ?

C

q dy = ?

T −1(C)

(q ◦T )(yuu′(t)+yvv′(t))dt

= ??

T −1(R)

?

∂ ∂u

((q ◦T )yv)−

∂ ∂v

((q ◦T )yu)? du dv. Show that

∂ ∂u

(q(x(u,v),y(u,v))yv)−

∂ ∂v

(q(x(u,v),y(u,v))yu)

= f(x(u,v),y(u,v))(xuyv −xvyu) = f

∂(x,y) ∂(u,v)

.

Putthattogetherwiththeaboveandobtainthetransformationformula for double integrals:

??

R

f (x,y)dx dy = ??

T −1(R)

f(x(u,v),y(u,v))

∂(x,y) ∂(u,v)

du dv.

[Page 69]

# 2 Regular Surfaces

###### 2-1. Introduction

Inthischapter, weshallbeginthestudyofsurfaces. Whereasintheﬁrstchapter we used mainly elementary calculus of one variable, we shall now need some knowledge of calculus of several variables. Speciﬁcally, we need to know some facts about continuity and differentiability of functions and maps in R2 and R3. What we need can be found in any standard text of advanced calculus, for instance, Buck Advanced Calculus; we have included a brief review of some of this material in an appendix to Chap. 2.

- In Sec. 2-2 we shall introduce the basic concept of a regular surface in R3.

In contrast to the treatment of curves in Chap. 1, regular surfaces are deﬁned as sets rather than maps. The goal of Sec. 2-2 is to describe some criteria that are helpful in trying to decide whether a given subset of R3 is a regular surface.

- In Sec. 2-3 we shall show that it is possible to deﬁne what it means for a


function on a regular surface to be differentiable, and in Sec. 2-4 we shall show that the usual notion of differential in R2 can be extended to such functions. Thus, regular surfaces in R3 provide a natural setting for two-dimensional calculus.

Of course, curves can also be treated from the same point of view, that is, as subsets of R3 which provide a natural setting for one-dimensional calculus. We shall mention them brieﬂy in Sec. 2-3.

Sections 2-2 and 2-3 are crucial to the rest of the book. A beginner may ﬁnd the proofs in these sections somewhat difﬁcult. If so, the proofs can be omitted on a ﬁrst reading.

In Sec. 2-5 we shall introduce the ﬁrst fundamental form, a natural instrument to treat metric questions (lengths of curves, areas of regions, etc.) on

###### 53

[Page 70]

a regular surface. This will become a very important issue when we reach Chap. 4.

Sections 2-6 through 2-8 are optional on a ﬁrst reading. In Sec. 2-6, we shall treat the idea of orientation on regular surfaces. This will be needed in Chaps. 3 and 4. For the beneﬁt of those who omit this section, we shall review the notion of orientation at the beginning of Chap. 3.

###### 2-2. Regular Surfaces; Inverse Images of Regular Values†

In this section we shall introduce the notion of a regular surface in R3. Roughly speaking, a regular surface in R3 is obtained by taking pieces of a plane, deforming them, and arranging them in such a way that the resulting ﬁgure has no sharp points, edges, or self-intersections and so that it makes sense to speak of a tangent plane at points of the ﬁgure. The idea is to deﬁne a set that is, in a certain sense, two-dimensional and that also is smooth enough so that the usual notions of calculus can be extended to it. By the end of Sec. 2-4, it should be completely clear that the following deﬁnition is the right one.

DEFINITION 1. A subset S ⊂ R3 is a regular surface if, for each p ∈ S, there exists a neighborhood V in R3 and a map x: U → V ∩S of an open set U ⊂ R2 onto V ∩S ⊂ R3 such that (Fig. 2-1)

z

0

y

x

V

C

V ∩ S

S

x

(u, υ)

υ

u U

p

(x(u, υ), y(u, υ), z(u, υ))

###### Figure 2-1

- 1. x is differentiable. This means that if we write x(u,v) = (x(u,v),y(u,v),z(u,v)), (u,v) ∈ U,


†Proofs in this section may be omitted on a ﬁrst reading.

[Page 71]

the functions x(u,v),y(u,v),z(u,v) have continuous partial derivatives of all orders in U.

- 2. x is a homeomorphism. Since x is continuous by condition 1, this means that x has an inverse x−1: V ∩S → U which is continuous.
- 3. (The regularity condition.) For each q ∈ U, the differential dxq: R2 → R3 is one-to-one.†


We shall explain condition 3 in a short while. Themappingxiscalledaparametrizationorasystemof (local)coordinates

in (a neighborhood of) p. The neighborhood V ∩S of p in S is called a coordinate neighborhood.

To give condition 3 a more familiar form, let us compute the matrix of the linear map dxq in the canonical bases e1 = (1,0), e2 = (0,1) of R2 with coordinates (u,v) and f1 = (1,0,0), f2 = (0,1,0), f3 = (0,0,1) of R3, with coordinates (x,y,z).

Let q = (u0,v0). The vector e1 is tangent to the curve u → (u,v0) whose image under x is the curve

u −→ (x(u,v0),y(u,v0),z(u,v0)).

This image curve (called the coordinate curve v = v0) lies on S and has at x(q) the tangent vector (Fig. 2-2)

coordinate curves

###### ∂x

∂u

S

dxq

υ u = u0

υ = υ0

u

e2 q

0

e1

f3

f2 f1

∂υ

∂x x(q)

###### Figure 2-2

†In italic context, letter symbols are roman so they can be distinguished from the surrounding text.

[Page 72]

?

∂x ∂u

,

∂y ∂u

,

∂z ∂u? =

∂x ∂u

,

where the derivatives are computed at (u0,v0) and a vector is indicated by its components in the basis {f1,f2,f3}. By the deﬁnition of differential (appendix to Chap. 2, Def. 1),

dxq(e1)?

∂x ∂u

,

∂y ∂u

,

∂z ∂u? =

∂x ∂u

.

Similarly, using the coordinate curve u = u0 (image by x of the curve v → (u0,v)), we obtain

dxq(e2) = ?

∂x ∂v

,

∂y ∂v

,

∂z ∂v? =

∂x ∂v

.

Thus, the matrix of the linear map dxq in the referred basis is

dxq =

⎛

⎜ ⎝

- ∂x ∂u

∂x ∂v

- ∂y ∂u

∂y ∂v

- ∂z ∂u


∂z ∂v

⎞

⎟ ⎠

.

Condition 3 of Def. 1 may now be expressed by requiring the two column vectors of this matrix to be linearly independent; or, equivalently, that the vector product ∂x/∂u∧∂x/∂v ?= 0; or, in still another way, that one of the minors of order 2 of the matrix of dxq, that is, one of the Jacobian determinants

∂(x,y) ∂(u,v) =

?

- ∂x ∂u

∂x ∂v

- ∂y ∂u


∂y ∂v

?

,

∂(y,z) ∂(u,v)

,

∂(x,z) ∂(u,v)

,

be different from zero at q.

Remark 1. Deﬁnition 1 deserves a few comments. First, in contrast to our treatment of curves in Chap. 1, we have deﬁned a surface as a subset S of R3, and not as a map. This is achieved by covering S with the traces of parametrizations which satisfy conditions 1, 2, and 3.

Condition 1 is very natural if we expect to do some differential geometry on S. The one-to-oneness in condition 2 has the purpose of preventing selfintersections in regular surfaces. This is clearly necessary if we are to speak

[Page 73]

about, say, the tangent plane at a point p ∈ S (see Fig. 2-3(a)). The continuity of the inverse in condition 2 has a more subtle purpose which can be fully understood only in the next section. For the time being, we shall mention that this condition is essential to proving that certain objects deﬁned in terms of a parametrization do not depend on this parametrization but only on the set S itself. Finally, as we shall show in Sec. 2.4, condition 3 will guarantee the existence of a “tangent plane” at all points of S (see Fig. 2-3(b)).

(a) (b)

p

p

Figure2-3. Somesituationstobeavoidedinthedeﬁnitionofaregularsurface.

Example 1. Let us show that the unit sphere

S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} is a regular surface.

We ﬁrst verify that the map x1: U ⊂ R2 → R3 given by

x1(x,y) = (x,y,+?

1−(x2 +y2)), (x,y) ∈ U,

where R2 = {(x,y,z) ∈ R3;z = 0} and U = {(x,y) ∈ R2;x2 +y2 < 1}, is a parametrization of S2. Observe that x1(U) is the (open) part of S2 above the xy plane.

Since x2 +y2 < 1, the function +?

1−(x2 +y2) has continuous partial derivatives of all orders. Thus, x1 is differentiable and condition 1 holds.

Condition 3 is easily veriﬁed, since

∂(x,y) ∂(x,y) ≡ 1.

To check condition 2, we observe that x1 is one-to-one and that x−1

1 is the restriction of the (continuous) projection π(x,y,z) = (x,y) to the set x1(U). Thus, x−1

1 is continuous in x1(U).

[Page 74]

We shall now cover the whole sphere with similar parametrizations as follows. We deﬁne x2: U ⊂ R2 → R3 by

x2(x,y) = (x,y,−?

1−(x2 +y2)),

check that x2 is a parametrization, and observe that x1(U)∪x2(U) covers S2 minus the equator

{(x,y,z) ∈ R3;x2 +y2 = 1,z = 0}. Then, using the xz and zy planes, we deﬁne the parametrizations

x3(x,z) = (x,+?

1−(x2 +z2),z), x4(x,z) = (x,−?

- 1−(x2 +z2),z),

x5(y,z) = (+?

- 1−(y2 +z2),y,z),


x6(y,z) = (−?

1−(y2 +z2),y,z),

which, together with x1 and x2, cover S2 completely (Fig. 2-4) and show that S2 is a regular surface.

y

z

x

S2

0

###### Figure 2-4

For most applications, it is convenient to relate parametrizations to the geographical coordinates on S2. Let V = {(θ,ϕ);0 < θ < π,0 < ϕ < 2π} and let x: V → R3 be given by

x(θ,ϕ) = (sin θ cosϕ,sin θ sin ϕ,cosθ).

[Page 75]

θ

φ

z

x y

###### Figure 2-5

Clearly, x(V ) ⊂ S2. We shall prove that x is a parametrization of S2. θ is usually called the colatitude (the complement of the latitude) and ϕ the longitude (Fig. 2-5).

It is clear that the functions sin θ cosϕ,sin θ sin ϕ,cosθ have continuous partial derivatives of all orders; hence, x is differentiable. Moreover, in order that the Jacobian determinants

- ∂(x,y) ∂(θ,ϕ) = cosθ sin θ,

- ∂(y,z) ∂(θ,ϕ) = sin2 θ cosϕ, ∂(x,z) ∂(θ,ϕ) = −sin2 θ sin ϕ


vanish simultaneously, it is necessary that cos2 θ sin2 θ +sin4 θ cos2 ϕ +sin4 θ sin2 ϕ = sin2 θ = 0. This does not happen in V , and so conditions 1 and 3 of Def. 1 are satisﬁed. Next, we observe that given (x,y,z) ∈ S2 −C, where C is the semicircle C = {(x,y,z) ∈ S2;y = 0,x ≥ 0},

θ is uniquely determined by θ = cos−1 z, since 0 < θ < π. By knowing θ, we ﬁnd sin ϕ and cosϕ from x = sin θ cosϕ, y = sin θ sin ϕ, and this determines ϕ uniquely (0 < ϕ < 2π). It follows that x has an inverse x−1. To complete the veriﬁcation of condition 2, we should prove that x−1 is continuous. However, since we shall soon prove (Prop. 4) that this veriﬁcation is

[Page 76]

not necessary provided we already know that the set S is a regular surface, we shall not do that here.

We remark that x(V ) only omits a semicircle of S2 (including the two poles) and that S2 can be covered with the coordinate neighborhoods of two parametrizations of this type.

In Exercise 16 we shall indicate how to cover S2 with another useful set of coordinate neighborhoods.

Example 1 shows that deciding whether a given subset of R3 is a regular surface directly from the deﬁnition may be quite tiresome. Before going into further examples, we shall present two propositions which will simplify this task. Proposition 1 shows the relation which exists between the deﬁnition of a regular surface and the graph of a function z = f (x,y). Proposition 2 uses the inverse function theorem and relates the deﬁnition of a regular surface with the subsets of the form f (x,y,z) = constant.

PROPOSITION 1. If f: U → R is a differentiable function in an open set U of R2, then the graph of f, that is, the subset of R3 given by (x,y,f(x,y)) for (x,y) ∈ U, is a regular surface.

Proof. It sufﬁces to show that the map x: U → R3 given by

x(u,v) = (u,v,f(u,v))

is a parametrization of the graph whose coordinate neighborhood covers every point of the graph. Condition 1 is clearly satisﬁed, and condition 3 also offers no difﬁculty since ∂(x,y)/∂(u,v) ≡ 1. Finally, each point (x,y,z) of the graph is the image under x of the unique point (u,v) = (x,y) ∈ U. x is therefore one-to-one, and since x−1 is the restriction to the graph of f of the (continuous) projection of R3 onto the xy plane, x−1 is continuous.

Q.E.D. Before stating Prop. 2, we shall need a deﬁnition.

DEFINITION 2. Given a differentiable map F: U ⊂ Rn → Rm deﬁned in an open set U of Rn we say that p ∈ U is a critical point of F if the differential dFp: Rn → Rm is not a surjective (or onto) mapping. The image F(p) ∈ Rm of a critical point is called a critical value of F. A point of Rm which is not a critical value is called a regular value of F.

The terminology is evidently motivated by the particular case in which f : U ⊂ R → R is a real-valued function of a real variable. A point x0 ∈ U is critical if f ′(x0) = 0, that is, if the differential dfx

0

carries all the vectors in R to the zero vector (Fig. 2-6). Notice that any point a ?∈ f (U) is trivially a regular value of f .

If f : U ⊂ R3 → R is a differentiable function, then dfp applied to the vector(1,0,0)isobtainedbycalculatingthetangentvectoratf (p)tothecurve

[Page 77]

y

- f(x0)
- f(x1)


y = f(x)

dfx1(υ)

dfx0(υ)

Critical value

0

Regular value

Critical point

x0

w υ x1

x

###### Figure 2-6

x −→ f (x,y0,z0). It follows that

dfp(1,0,0) =

∂f ∂x

(x0,y0,z0) = fx

and analogously that

dfp(0,1,0) = fy, dfp(0,0,1) = fz.

We conclude that the matrix of dfp in the basis (1,0,0),(0,1,0),(0,0,1) is given by

dfp = (fx,fy,fz).

Note, in this case, that to say that dfp is not surjective is equivalent to saying that fx = fy = fz = 0 at p. Hence, a ∈ f (U) is a regular value of f : U ⊂ R3 → R if and only if fx,fy, and fz do not vanish simultaneously at any point in the inverse image

f −1(a) = {(x,y,z) ∈ U: f (x,y,z) = a}.

PROPOSITION 2. If f: U ⊂ R3 → R is a differentiable function and a ∈ f(U) is a regular value of f, then f−1(a) is a regular surface in R3.

Proof. Let p = (x0,y0,z0) be a point of f −1(a). Since a is a regular value of f, it is possible to assume, by renaming the axes if necessary, that fz ?= 0 at p. We deﬁne a mapping F: U ⊂ R3 → R3 by

[Page 78]

F(x,y,z) = (x,y,f(x,y,z)),

and we indicate by (u,v,t) the coordinates of a point in R3 where F takes its values. The differential of F at p is given by

dFp =

⎛ ⎜ ⎝

1 0 0 0 1 0

fx fy fz

⎞ ⎟ ⎠,

whence

det(dFp) = fz ?= 0.

We can therefore apply the inverse function theorem (cf. the appendix to Chap. 2), which guarantees the existence of neighborhoods V of p and W of F(p) such that F: V → W is invertible and the inverse F−1: W → V is differentiable (Fig. 2-7). It follows that the coordinate functions of F−1, i.e., the functions

x = u, y = v, z = g(u,v,t), (u,v,t) ∈ W,

f–1(a)∩ V z

x

0

V p

t

a

f = a

w

υ

u

F( p)

F

y

###### Figure 2-7

are differentiable. In particular, z = g(u,v,a) = h(x,y) is a differentiable function deﬁned in the projection of V onto the xy plane. Since

F(f−1(a)∩V ) = W ∩{(u,v,t);t = a},

we conclude that the graph of h is f−1(a)∩V . By Prop. 1, f−1(a)∩V is a coordinate neighborhood of p. Therefore, every p ∈ f−1(a) can be covered by a coordinate neighborhood, and so f−1(a) is a regular surface. Q.E.D.

[Page 79]

Remark 2. The proof consists essentially of using the inverse function theorem “to solve for z” in the equation f (x,y,z) = a, which can be done in a neighborhood of p if fz(p) ?= 0. This fact is a special case of the general implicit function theorem, which follows from the inverse function theorem and is, in fact, equivalent to it.

Example 2. The ellipsoid

x2 a2 +

y2 b2 +

z2 c2 = 1

is a regular surface. In fact, it is the set f−1(0) where

f (x,y,z) =

x2 a2 +

y2 b2 +

z2 c2 −1

is a differentiable function and 0 is a regular value of f . This follows from the fact that the partial derivatives fx = 2x/a2, fy = 2y/b2, fz = 2z/c2 vanish simultaneously only at the point (0,0,0), which does not belong to f−1(0). This example includes the sphere as a particular case (a = b = c = 1).

The examples of regular surfaces presented so far have been connected subsets of R3. A surface S ⊂ R3 is said to be connected if any two of its points can be joined by a continuous curve in S. In the deﬁnition of a regular surface we made no restrictions on the connectedness of the surfaces, and the following example shows that the regular surfaces given by Prop. 2 may not be connected.

Example 3. The hyperboloid of two sheets −x2 −y2 +z2 = 1 is a regular surface, since it is given by S = f−1(0), where 0 is a regular value of f (x,y,z) = −x2 −y2 +z2 −1 (Fig. 2-8). Note that the surface S is not connected; that is, given two points in two distinct sheets (z > 0 and z < 0) it is not possible to join them by a continuous curve α(t) = (x(t),y(t),z(t)) contained in the surface; otherwise, z changes sign and, for some t0, we have z(t0) = 0, which means that α(t0) ?∈ S.

Incidentally, the argument of Example 3 may be used to prove a property of connected surfaces that we shall use repeatedly. If f: S ⊂ R3 → R is a nonzero continuous function deﬁned on a connected surface S, then f does not change sign on S.

To prove this, we use the intermediate value theorem (appendix to Chap. 2, Prop. 4). Assume, by contradiction, that f (p) > 0 and f (q) < 0 for some points p,q ∈ S. Since S is connected, there exists a continuous curve α: [a,b] → S with α(a) = p, α(b) = q. By applying the intermediate value theorem to the continuous function f ◦α: [a,b] → R, we ﬁnd that there exists c ∈ (a,b) with f ◦α(c) = 0; that is, f is zero at α(c), a contradiction.

[Page 80]

z

x

y 0

Figure 2-8. A nonconnected surface: −y2 −x2 +z2 = 1.

Example 4. The torus T is a “surface” generated by rotating a circle S1 of radius r about a straight line belonging to the plane of the circle and at a distance a > r away from the center of the circle (Fig. 2-9).

a+r

z

x υ

u

r O y

###### Figure 2-9

[Page 81]

Let S1 be the circle in the yz plane with its center in the point (0,a,0). Then S1 is given by (y −a)2 +z2 = r2, and the points of the ﬁgure T obtained by rotating this circle about the z axis satisfy the equation

z2 = r2 −(

?

x2 +y2 −a)2. Therefore, T is the inverse image of r2 by the function f (x,y,z) = z2 +(

?

x2 +y2 −a)2. This function is differentiable for (x,y) ?= (0,0), and since

∂f ∂z = 2z,

∂f ∂y =

2y(

?

x2 +y2 −a) ?

x2 +y2

,

∂f ∂x =

2x(

?

x2 +y2 −a) ?

x2 +y2

,

r2 is a regular value of f. It follows that the torus T is a regular surface.

Proposition 1 says that the graph of a differentiable function is a regular surface. The following proposition provides a local converse of this; that is, any regular surface is locally the graph of a differentiable function.

PROPOSITION 3. Let S ⊂ R3 be a regular surface and p ∈ S. Then there exists a neighborhood V of p in S such that V is the graph of a differentiable function which has one of the following three forms: z = f(x,y), y = g(x,z), x = h(y,z).

Proof. Let x: U ⊂ R2 → S be a parametrization of S in p, and write x(u,v) = (x(u,v),y(u,v),z(u,v)),(u,v) ∈ U. By condition 3 of Def. 1, one of the Jacobian determinants

∂(x,y) ∂(u,v)

,

∂(y,z) ∂(u,v)

,

∂(z,x) ∂(u,v)

is not zero at x−1(p) = q.

Suppose ﬁrst that (∂(x,y)/∂(u,v))(q) ?= 0, and consider the map π ◦x: U → R2, where π is the projection π(x,y,z) = (x,y). Then π ◦x(u,v) = (x(u,v),y(u,v)), and, since (∂(x,y)/∂(u,v))(q) ?= 0, we can apply the inverse function theorem to guarantee the existence of neighborhoods V1 of q, V2 of π ◦x(q) such that π ◦x maps V1 diffeomorphically onto V2 (Fig. 2-10). It follows that π restricted to x(V1) = V is one-to-one and that there is a differentiable inverse (π ◦x)−1: V2 → V1. Observe that, since x is a homeomorphism, V is a neighborhood of p in S. Now, if we compose

[Page 82]

υ

0

x

z

y u

x

(π°x)–1

π

U

V = x(V1) V1

V2

q p

###### Figure 2-10

the map (π ◦x)−1: (x,y) → (u(x,y),v(x,y)) with the function (u,v) → z(u,v), we ﬁnd that V is the graph of the differentiable function z = z(u(x,y),v(x,y)) = f (x,y), and this settles the ﬁrst case.

The remaining cases can be treated in the same way, yielding x = h(y,z) and y = g(x,z). Q.E.D.

The next proposition says that if we already know that S is a regular surface and we have a candidate x for a parametrization, we do not have to check that x−1 is continuous, provided that the other conditions hold. This remark was used in Example 1.

PROPOSITION 4. Let p ∈ S be a point of a regular surface S and let x: U ⊂ R2 → R3 be a map with p ∈ x(U) ⊂ S such that conditions 1 and 3 of Def. 1 hold. Assume that x is one-to-one. Then x−1 is continuous.

Proof. We begin by proceeding in a way similar to the proof of Proposition 3. Write x(u,v) = (x(u,v),y(u,v),z(u,v)), (u,v) ∈ U, and let q ∈ U. By conditions 1 and 3, we can assume, interchanging the coordinate axis if necessary, that ∂(x,y)/∂(u,v)(q) ?= 0. Let π: R3 → R2 be the projection π(x,y,z) = (x,y). By the inverse function theorem, we obtain neighborhoods V1 of q in U and V2 of π ◦x(q) in R2 such that π ◦x applies V1 diffeomorphically onto V2.

Assume now that x is bijective. Then, restricted to x(V1),x−1 = (π ◦x)−1 ◦π (Fig. 2.10). Thus x−1, as a composition of continuous maps, is continuous.

Q.E.D. Example 5. The one-sheeted cone C, given by

z = +?

x2 +y2, (x,y) ∈ R2,

[Page 83]

is not a regular surface. Observe that we cannot conclude this from the fact alone that the “natural” parametrization

(x,y) → (x,y,+?

x2 +y2) is not differentiable; there could be other parametrizations satisfying Def. 1.

To show that this is not the case, we use Prop. 3. If C were a regular surface, it would be, in a neighborhood of (0,0,0) ∈ C, the graph of a differentiable function having one of three forms: y = h(x,z), x = g(y,z), z = f (x,y). The two ﬁrst forms can be discarded by the simple fact that the projections of C over the xz and yz planes are not one-to-one. The last form would have to agree, in a neighborhood of (0,0,0), with z = +?

x2 +y2. Since z = +?

x2 +y2 is not differentiable at (0,0), this is impossible.

Example 6. A parametrization for the torus T of Example 4 can be given by (Fig. 2-9)

x(u,v) = ((r cosu+a)cosv,(r cosu+a)sin v,r sin u), where 0 < u < 2π, 0 < v < 2π.

Condition 1 of Def. 1 is easily checked, and condition 3 reduces to a straightforward computation, which is left as an exercise. Since we know that T is a regular surface, condition 2 is equivalent, by Prop. 4, to the fact that x is one-to-one.

To prove that x is one-to-one, we ﬁrst observe that sin u = z/r; also, if

?

x2 +y2 ≤ a, then π/2 ≤ u ≤ 3π/2, and if

?

x2 +y2 ≥ a, then either 0 < u ≤ π/2 or 3π/2 ≤ u < 2π. Thus, given (x,y,z), this determines u, 0 < u < 2π, uniquely. By knowing u, x, and y we ﬁnd cosv and sin v. This determines v uniquely, 0 < v < 2π. Thus, x is one-to-one.

It is easy to see that the torus can be covered by three such coordinate neighborhoods.

###### EXERCISES†

- 1. Show that the cylinder {(x,y,z) ∈ R3;x2 +y2 = 1} is a regular surface, and ﬁnd parametrizations whose coordinate neighborhoods cover it.
- 2. Is the set {(x,y,z) ∈ R3;z = 0 and x2 +y2 ≤ 1} a regular surface? Is the set {(x,y,z) ∈ R3;z = 0, and x2 +y2 < 1} a regular surface?
- 3. Show that the two-sheeted cone, with its vertex at the origin, that is, the set {(x,y,z) ∈ R3;x2 +y2 −z2 = 0}, is not a regular surface.


†Those who have omitted the proofs in this section should also omit Exercises 17–19.

[Page 84]

- 4. Let f (x,y,z) = z2. Prove that 0 is not a regular value of f and yet that f −1(0) is a regular surface.


- *5. Let P = {(x,y,z) ∈ R3;x = y} (a plane) and let x: U ⊂ R2 → R3 be given by


x(u,v) = (u+v,u+v,uv),

where U = {(u,v) ∈ R2;u > v}. Clearly, x(U) ⊂ P. Is x a parametrization of P?

- 6. Give another proof of Prop. 1 by applying Prop. 2 to h(x,y,z) = f (x,y)−z.
- 7. Let f (x,y,z) = (x +y +z −1)2.

- a. Locate the critical points and critical values of f .
- b. For what values of c is the set f (x,y,z) = c a regular surface?
- c. Answer the questions of parts a and b for the function f (x,y,z) = xyz2.


- 8. Let x(u,v) be as in Def. 1. Verify that dxq: R2 → R3 is one-to-one if and only if

∂x ∂u ∧

∂x ∂v ?= 0.

- 9. Let V be an open set in the xy plane. Show that the set {(x,y,z) ∈ R3;z = 0 and (x,y) ∈ V }

is a regular surface.

- 10. Let C be a ﬁgure “8” in the xy plane and let S be the cylindrical surface over C (Fig. 2-11); that is,


S = {(x,y,z) ∈ R3;(x,y) ∈ C}.

Is the set S a regular surface?

S

###### Figure 2-11

[Page 85]

- 11. Show that the set S = {(x,y,z) ∈ R3;z = x2 −y2} is a regular surface and check that parts a and b are parametrizations for S:

a. x(u,v) = (u+v,u−v,4uv),(u,v) ∈ R2.

*b. x(u,v) = (ucosh v,usinh v,u2),(u,v) ∈ R2,u ?= 0.

Which parts of S do these parametrizations cover?

- 12. Show that x: U ⊂ R2 → R3 given by x(u,v) = (a sin ucosv,b sin usin v,c cosu), a,b,c ?= 0,


where 0 < u < π, 0 < v < 2π, is a parametrization for the ellipsoid x2 a2 +

y2 b2 +

z2 c2 = 1.

Describe geometrically the curves u = const. on the ellipsoid.

- *13. Find a parametrization for the hyperboloid of two sheets {(x,y,z) ∈ R3;−x2 −y2 +z2 = 1}.

14. A half-line [0,∞) is perpendicular to a line E and rotates about E from a given initial position while its origin 0 moves along E. The movement is such that when [0,∞) has rotated through an angle θ, the origin is at a distance d = sin2(θ/2) from its initial position on E. Verify that by removing the line E from the image of the rotating line we obtain a regular surface. If the movement were such that d = sin(θ/2), what else would need to be excluded to have a regular surface?

- *15. Let two points p(t) and q(t) move with the same speed, p starting from (0,0,0) and moving along the z axis and q starting at (a,0,0), a ?= 0, and moving parallel to the y axis. Show that the line through p(t) and q(t) describes a set in R3 given by y(x −a)+zx = 0. Is this a regular surface?


- 16. One way to deﬁne a system of coordinates for the sphere S2, given by x2 +y2 +(z −1)2 = 1, is to consider the so-called stereographic projection π: S2 ∼ {N} → R2 which carries a point p = (x,y,z) of the sphere S2 minus the north pole N = (0,0,2) onto the intersection of the xy plane with the straight line which connects N to p (Fig. 2-12). Let (u,v) = π(x,y,z), where(x,y,z) ∈ S2 ∼ {N}and(u,v) ∈ xy plane.


- a. Show that π−1: R2 → S2 is given by


π−1

⎧

⎪⎨

⎪⎩

- x =

4u u2 +v2 +4

,

- y =

4v u2 +v2 +4

,

- z =


2(u2 +v2) u2 +v2 +4

.

[Page 86]

z

p

y x ̟(p)

N

(0,0,1)

0

0

0

0

0

0

Figure 2-12. The stereographic projection.

- b. Show that it is possible, using stereographic projection, to cover the sphere with two coordinate neighborhoods.


- 17. Deﬁne a regular curve in analogy with a regular surface. Prove that


- a. The inverse image of a regular value of a differentiable function f : U ⊂ R2 → R

is a regular plane curve. Give an example of such a curve which is not connected.

- b. The inverse image of a regular value of a differentiable map F: U ⊂ R3 → R2


is a regular curve in R3. Show the relationship between this proposition and the classical way of deﬁning a curve in R3 as the intersection of two surfaces.

*c. The set C = {(x,y) ∈ R2;x2 = y3} is not a regular curve.

- *18. Suppose that f (x,y,z) = u = const., g(x,y,z) = v = const., h(x,y,z) = w = const.,


describe three families of regular surfaces and assume that at (x0,y0,z0) the Jacobian

∂(f,g,h) ∂(x,y,z) ?= 0.

[Page 87]

y

p = (0, –1)

Horizontal scale distinct from vertical scale

q = (1/π, 0) 0 x

###### Figure 2-13

Prove that in a neighborhood of (x0,y0,z0) the three families will be described by a mapping F(u,v,w) = (x,y,z) of an open set of R3 into R3, where a local parametrization for the surface of the family f (x,y,z) = u, for example, is obtained by setting u = const. in this mapping. DetermineF forthecasewherethethreefamiliesofsurfacesare

- f (x,y,z) = x2 +y2 +z2 = u = const.; (spheres with center (0,0,0));
- g(x,y,z) =

y x = v = const.; (planes through the z axis);

- h(x,y,z) =


x2 +y2 z2 = w = const.; (cones with vertex at (0,0,0)).

- *19. Let α: (−3,0) → R2 be deﬁned by (Fig. 2-13)


α(t)

⎧

⎪⎨

⎪⎩

= (0,−(t +2)), if t ∈ (−3,−1),

= regular parametrized curve joining p = (0,−1) to q = ?

1 π

,0?,

if t ∈ ?−1,−

1 π ?,

= ?−t,sin

1 t ?, if t ∈ ?−

1 π

,0?.

It is possible to deﬁne the curve joining p to q so that all the derivatives of α are continuous at the corresponding points and α has no self-intersections. Let C be the trace of α.

- a. Is C a regular curve?
- b. Let a normal line to the plane R2 run through C so that it describes a “cylinder” S. Is S a regular surface?


[Page 88]

###### 2-3. Change of Parameters; Differentiable Functions on Surface†

Differential geometry is concerned with those properties of surfaces which depend on their behavior in a neighborhood of a point. The deﬁnition of a regular surface given in Sec. 2-2 is adequate for this purpose. According to this deﬁnition, each point p of a regular surface belongs to a coordinate neighborhood. The points of such a neighborhood are characterized by their coordinates, and we should be able, therefore, to deﬁne the local properties which interest us in terms of these coordinates.

For example, it is important that we be able to deﬁne what it means for a function f : S → R to be differentiable at a point p of a regular surface S. A natural way to proceed is to choose a coordinate neighborhood of p, with coordinates u,v, and say that f is differentiable at p if its expression in the coordinates u and v admits continuous partial derivatives of all orders.

The same point of S can, however, belong to various coordinate neighborhoods (in the sphere of Example 1 of Sec. 2-2 any point of the interior of the ﬁrst octant belongs to three of the given coordinate neighborhoods). Moreover, other coordinate systems could be chosen in a neighborhood of p (the points referred to on the sphere could also be parametrized by geographical coordinates or by stereographic projection; cf. Exercise 16, Sec. 2-2). For the above deﬁnition to make sense, it is necessary that it does not depend on the chosen system of coordinates. In other words, it must be shown that when p belongs to two coordinate neighborhoods, with parameters (u,v) and (ξ,η), it is possible to pass from one of these pairs of coordinates to the other by means of a differentiable transformation.

The following proposition shows that this is true.

PROPOSITION 1 (Change of Parameters). Let p be a point of a regular surface S, and let x: U ⊂ R2 → S, y: V ⊂ R2 → S be two parametrizations of S such that p ∈ x(U)∩y(V) = W. Then the “change of coordinates” h = x−1 ◦y: y−1(W) → x−1(W) (Fig. 2-14) is a diffeomorphism; that is, h is differentiable and has a differentiable inverse h−1.

In other words, if x and y are given by

x(u,v) = (x(u,v),y(u,v),z(u,v)), (u,v) ∈ U, y(ξ,η) = (x(ξ,η),y(ξ,η),z(ξ,η)), (ξ,η) ∈ V,

then the change of coordinates h, given by u = u(ξ,η), v = v(ξ,η), (ξ,η) ∈ y−1(W),

†Proofs in this section may be omitted on a ﬁrst reading.

[Page 89]

ξ

r

η y–1(W)

0

y

V

z

W

p

y

S

x(U)

y(V)

F

x

x

t

u

U

0

q

υ

x–1(W )

###### Figure 2-14

has the property that the functions u and v have continuous partial derivatives of all orders, and the map h can be inverted, yielding

ξ = ξ(u,v), η = η(u,v), (u,v) ∈ x−1(W), where the functions ξ and η also have partial derivatives of all orders. Since

∂(u,v) ∂(ξ,η) ·

∂(ξ,η) ∂(u,v) = 1,

this implies that the Jacobian determinants of both h and h−1 are nonzero everywhere.

Proof of Prop. 1. h = x−1 ◦y is a homeomorphism, since it is composed of homeomorphisms (cf. the appendix to Chap. 2, Prop. 3). It is not possible to conclude, by an analogous argument, that h is differentiable, since x−1 is deﬁned in an open subset of S, and we do not yet know what is meant by a differentiable function on S.

We proceed in the following way. Let r ∈ y−1(W) and set q = h(r). Since x(u,v) = (x(u,v),y(u,v),z(u,v)) is a parametrization, we can assume, by renaming the axes if necessary, that

[Page 90]

∂(x,y) ∂(u,v)

(q) ?= 0.

We extend x to a map F: U ×R → R3 deﬁned by F(u,v,t) = (x(u,v),y(u,v),z(u,v)+t), (u,v) ∈ U,t ∈ R.

Geometrically, F maps a vertical cylinder C over U into a “vertical cylinder” overx(U)bymappingeachsectionofC withheightt intothesurfacex(u,v)+ te3, where e3 is the unit vector of the z axis (Fig. 2-14).

It is clear that F is differentiable and that the restriction F|U ×{0} = x. Calculating the determinant of the differential dFq, we obtain

?

- ∂x ∂u

∂x ∂v

0

- ∂y ∂u

∂y ∂v

0

- ∂z ∂u


∂z ∂v

1?

=

∂(x,y) ∂(u,v)

(q) ?= 0.

It is possible therefore to apply the inverse function theorem, which guarantees the existence of a neighborhood M of x(q) in R3 such that F−1 exists and is differentiable in M.

By the continuity of y, there exists a neighborhood N of r in V such that y(N) ⊂ M (appendix to Chap. 2, Prop. 2). Notice that, restricted to N, h|N = F−1 ◦y|N is a composition of differentiable maps. Thus, we can apply the chain rule for maps (appendix to Chap. 2, Prop. 8) and conclude that h is differentiable at r. Since r is arbitrary, h is differentiable on y−1(W).

Exactly the same argument can be applied to show that the map h−1 is differentiable, and so h is a diffeomorphism. Q.E.D.

We shall now give an explicit deﬁnition of what is meant by a differentiable function on a regular surface.

DEFINITION 1. Let f: V ⊂ S → R be a function deﬁned in an open subset V of a regular surface S. Then f is said to be differentiable at p ∈ V if, for some parametrization x: U ⊂ R2 → S with p ∈ x(U) ⊂ V, the composition f ◦x: U ⊂ R2 → R is differentiable at x−1(p). f is differentiable in V if it is differentiable at all points of V.

It follows immediately from the last proposition that the deﬁnition given does not depend on the choice of the parametrization x. In fact, if y: V ⊂

- R2 → S is another parametrization with p ∈ y(V ), and if h = x−1 ◦y, then f ◦y = f ◦x ◦h is also differentiable, whence the asserted independence.


Remark 1. We shall frequently make the notational abuse of indicating f and f ◦x by the same symbol f(u,v), and say that f(u,v) is the expression

[Page 91]

of f in the system of coordinates x. This is equivalent to identifying x(U) with U and thinking of (u,v), indifferently, as a point of U and as a point of

- x(U) with coordinates (u,v). From now on, abuses of language of this type will be used without further comment.


Example 1. Let S be a regular surface and V ⊂ R3 be an open set such that S ⊂ V . Let f : V ⊂ R3 → R beadifferentiablefunction. Thentherestriction of f to S is a differentiable function on S. In fact, for any p ∈ S and any parametrization x: U ⊂ R2 → S in p, the function f ◦x: U → R is differentiable. In particular, the following are differentiable functions:

- 1. The height function relative to a unit vector v ∈ R3, h: S → R, given by h(p) = p ·v, p ∈ S, where the dot denotes the usual inner product in R3. h(p) is the height of p ∈ S relative to a plane normal to v and passing through the origin of R3 (Fig. 2-15).

h(p)

p

υ 0

Figure 2-15

- 2. The square of the distance from a ﬁxed point p0 ∈ R3, f (p) = |p −p0|2, p ∈ S. The need for taking the square comes from the fact that the distance |p −p0| is not differentiable at p = p0.


Remark 2. The proof of Prop. 1 makes essential use of the fact that the inverse of a parametrization is continuous. Since we need Prop. 1 to be able to deﬁne differentiable functions on surfaces (a vital concept), we cannot dispose ofthisconditioninthedeﬁnitionofaregularsurface(cf. Remark1ofSec.2-2).

The deﬁnition of differentiability can be easily extended to mappings between surfaces. A continuous map ϕ: V1 ⊂ S1 → S2 of an open set V1 of a regular surface S1 to a regular surface S2 is said to be differentiable at p ∈ V1 if, given parametrizations

x1: U1 ⊂ R2 → S1 x2: U2 ⊂ R2 → S2, with p ∈ x1(U) and ϕ(x1(U1)) ⊂ x2(U2), the map

x−1

2 ◦ϕ ◦x1: U1 → U2 is differentiable at q = x−1

1 (p) (Fig. 2-16).

[Page 92]

S1

S2 p

x1

x2

υ1 x2–1 ○ φ ○ x1

υ2

u2

u1 0

0

φ

φ(p)

###### Figure 2-16

In other words, ϕ is differentiable if when expressed in local coordinates as ϕ(u1,v1) = (ϕ1(u1,v1),ϕ2(u1,v1)) the functions ϕ1 and ϕ2 have continuous partial derivatives of all orders.

The proof that this deﬁnition does not depend on the choice of parametrizations is left as an exercise.

We should mention that the natural notion of equivalence associated with differentiability is the notion of diffeomorphism. Two regular surfaces S1 and

- S2 are diffeomorphic if there exists a differentiable map ϕ: S1 → S2 with a differentiable inverse ϕ−1: S2 → S1. Such a ϕ is called a diffeomorphism from S1 to S2. The notion of diffeomorphism plays the same role in the study of regular surfaces that the notion of isomorphism plays in the study of vector spaces or the notion of congruence plays in Euclidean geometry. In other words, from the point of view of differentiability, two diffeomorphic surfaces are indistinguishable.


Example 2. If x: U ⊂ R2 → S is a parametrization, x−1: x(U) → R2 is differentiable. In fact, for any p ∈ x(U) and any parametrization y: V ⊂ R2 → S in p, we have that x−1 ◦y: y−1(W) → x−1(W), where

W = x(U)∩y(V ),

isdifferentiable.ThisshowsthatU andx(U)arediffeomorphic(i.e., everyregular surface is locally diffeomorphic to a plane) and justiﬁes the identiﬁcation made in Remark 1.

[Page 93]

Example 3. Let S1 and S2 be regular surfaces.Assume that S1 ⊂ V ⊂ R3, where V is an open set of R3, and that ϕ: V → R3 is a differentiable map such that ϕ(S1) ⊂ S2. Then the restriction ϕ|S1: S1 → S2 is a differentiable map. In fact, given p ∈ S1 and parametrizations x1: U1 → S1, x2: U2 → S2, with p ∈ x1(U1) and ϕ(x1(U1)) ⊂ x2(U2), we have that the map

x−1

2 ◦ϕ ◦x1: U1 → U2 is differentiable. The following are particular cases of this general example:

- 1. Let S be symmetric relative to the xy plane; that is, if (x,y,z) ∈ S, then also (x,y,−z) ∈ S. Then the map σ: S → S, which takes p ∈ S into its symmetrical point, is differentiable, since it is the restriction to S of σ: R3 → R3, σ(x,y,z) = (x,y,−z). This, of course, generalizes to surfaces symmetric relative to any plane of R3.
- 2. Let Rz,θ: R3 → R3 be the rotation of angle θ about the z axis, and let S ⊂ R3 be a regular surface invariant by this rotation; i.e., if p ∈ S, Rz,θ(p) ∈ S. Then the restriction Rz,θ: S → S is a differentiable map.
- 3. Let ϕ: R3 → R3 be given by ϕ(x,y,z) = (xa,yb,zc), where a,b, and c are nonzero real numbers. ϕ is clearly differentiable, and the restriction ϕ|S2 is a differentiable map from the sphere


S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} into the ellipsoid

?(x,y,z) ∈ R3;

x2 a2 +

y2 b2 +

z2 c2 = 1?

(cf. Example 6 of the appendix to Chap. 2).

Remark 3. Proposition 1 implies (cf. Example 2) that a parametrization x: U ⊂ R2 → S is a diffeomorphism of U onto x(U). Actually, we can now characterize the regular surfaces as those subsets S ⊂ R3 which are locally diffeomorphic to R2; that is, for each point p ∈ S, there exists a neighborhood V of p in S, an open set U ⊂ R2, and a map x: U → V , which is a diffeomorphism. This pretty characterization could be taken as the starting point of a treatment of surfaces (see Exercise 13).

At this stage we could return to the theory of curves and treat them from the point of view of this chapter, i.e., as subsets of R3. We shall mention only certain fundamental points and leave the details to the reader.

The symbol I will denote an open interval of the line R. A regular curve in R3 is a subset C ⊂ R3 with the following property: For each point p ∈ C there is a neighborhood V of p in R3 and a differentiable homeomorphism

[Page 94]

α(t)

α

α΄(t)

p

t I

V

C

Figure 2-17. A regular curve.

α: I ⊂ R → V ∩C such that the differential dαt is one-to-one for each t ∈ I (Fig. 2-17).

It is possible to prove (Exercise 15) that the change of parameters is given (as with surfaces) by a diffeomorphism. From this fundamental result, it is possible to decide when a given property obtained by means of a parametrization is independent of that parametrization. Such a property will then be a local property of the set C.

For example, it is shown that the arc length, deﬁned in Chap. 1, is independent of the parametrization chosen (Exercise 15) and is, therefore, a property of the set C. Since it is always possible to locally parametrize a regular curve C by arc length, the properties (curvature, torsion, etc.) determined by means of this parametrizaion are local properties of C. This shows that the local theory of curves developed in Chap. 1 is valid for regular curves.

Sometimes a surface is deﬁned by displacing a certain regular curve in a speciﬁed way. This occurs in the following example.

Example 4 (Surfaces of Revolution). Let S ⊂ R3 be the set obtained by rotating a regular connected plane curve C about an axis in the plane which does not meet the curve; we shall take the xz plane as the plane of the curve and the z axis as the rotation axis. Let

x = f (v), z = g(v), a < v < b, f(v) > 0,

be a parametrization for C and denote by u the rotation angle about the z axis. Thus, we obtain a map

x(u,v) = (f(v)cosu,f(v)sin u,g(v))

[Page 95]

u

x

y

z

Rotation axis

Meridian

Parallel

(f(υ), g(υ))

Figure 2-18. A surface of revolution.

from the open set U = {(u,v) ∈ R2;0 < u < 2π,a < v < b} into S (Fig. 2-18).

We shall soon see that x satisﬁes the conditions for a parametrization in the deﬁnition of a regular surface. Since S can be entirely covered by similar parametrizations, it follows that S is a regular surface which is called a surface of revolution. The curve C is called the generating curve of S, and the z axis is the rotation axis of S. The circles described by the points of C are called the parallels of S, and the various positions of C on S are called the meridians of S.

To show that x is a parametrization of S we must check conditions 1, 2, and 3 of Def. 1, Sec. 2-2. Conditions 1 and 3 are straightforward, and we leave them to the reader. To show that x is a homeomorphism, we ﬁrst show that x is one-to-one. In fact, since (f(v),g(v)) is a parametrization of C, given z and x2 +y2 = (f(v))2, we can determine v uniquely. Thus, x is one-to-one.

We remark that, again because (f(v),g(v)) is a parametrization of C, v is a continuous function of z and of

?

x2 +y2 and thus a continuous function of (x,y,z).

To prove that x−1 is continuous, it remains to show that u is a continuous function of (x,y,z). To see this, we ﬁrst observe that if u ?= π, we obtain, since f (v) ?= 0,

tan

u 2 =

sin

u 2

cos

u 2

=

2sin

u 2

cos

u 2

2cos2

u 2

=

sin u 1+cosu

=

y f (v) 1+

x f (v)

=

y x +?

x2 +y2

;

[Page 96]

hence,

u = 2tan−1 y x +?

x2 +y2

.

Thus, if u ?= π, u is a continuous function of (x,y,z). By the same token, if u is in a small interval about π, we obtain

u = 2cotan−1 y −x +?

x2 +y2

.

Thus, u is a continuous function of (x,y,z). This shows that x−1 is continuous and completes the veriﬁcation.

Remark 4. There is a slight problem with our deﬁnition of surface of revolution. If C ⊂ R2 is a closed regular plane curve which is symmetric relative to an axis r of R3, then, by rotating C about r, we obtain a surface which can be proved to be regular and should also be called a surface of revolution (when C is a circle and r contains a diameter of C, the surface is a sphere). To ﬁt it in our deﬁnition, we would have to exclude two of its points, namely, the points where r meets C. For technical reasons, we want to maintain the previous terminology and shall call the latter surfaces extended surfaces of revolution.

Aﬁnal comment should now be made on our deﬁnition of surface. We have chosen to deﬁne a (regular) surface as a subset of R3. If we want to consider global, as well as local, properties of surfaces, this is the correct setting. The reader might have wondered, however, why we have not deﬁned surface simplyasaparametrizedsurface, asinthecaseofcurves.Thiscanbedone, and in fact a certain amount of the classical literature in differential geometry was presented that way. No serious harm is done as long as only local properties are considered. However, basic global concepts, like orientation (to be treated in Secs. 2-6 and 3-1), have to be omitted, or treated inadequately, with such an approach.

In any case, the notion of parametrized surface is sometimes useful and should be included here.

DEFINITION 2. A parametrized surface x: U ⊂ R2 → R3 is a differentiable map x from an open set U ⊂ R2 into R3. The set x(U) ⊂ R3 is called the trace of x. x is regular if the differential dxq: R2 → R3 is one-to-one for all q ∈ U (i.e., the vectors ∂x/∂u, ∂x/∂v are linearly independent for all q ∈ U). A point p ∈ U where dxp is not one-to-one is called a singular point of x.

Observe that a parametrized surface, even when regular, may have selfintersections in its trace.

[Page 97]

Example 5. Let α: I → R3 be a nonplanar regular parametrized curve. Deﬁne

x(t,v) = α(t)+vα′(t), (t,v) ∈ I ×R. x is a parametrized surface called the tangent surface of α (Fig. 2-19).

Figure 2-19. The tangent surface.

Assume now that the curvature k(t), t ∈ I, of α is nonzero for all t ∈ I,

and restrict the domain of x to U = {(t,v) ∈ I ×R;v ?= 0}. Then ∂x ∂t = α′(t)+vα′′(t),

∂x ∂v = α′(t)

and

∂x ∂t ∧

∂x ∂v = vα′′(t)∧α′(t) ?= 0, (t,v) ∈ U,

since, for all t, the curvature (cf. Exercise 12 of Sec. 1-5)

k(t) =

|α′′(t)∧α′(t)| |α′(t)|3

is nonzero. It follows that the restriction x: U → R3 is a regular parametrized surface, the trace of which consists of two connected pieces whose common boundary is the set α(I).

[Page 98]

The following proposition shows that we can extend the local concepts and properties of differential geometry to regular parametrized surfaces.

PROPOSITION 2. Let x: U ⊂ R2 → R3 be a regular parametrized surface and let q ∈ U. Then there exists a neighborhood V of q in R2 such that

- x(V) ⊂ R3 is a regular surface. Proof. This is again a consequence of the inverse function theorem. Write


x(u,v) = (x(u,v),y(u,v),z(u,v)).

By regularity, we can assume that (∂(x,y)/∂(u,v))(q) ?= 0. Deﬁne a map F: U ×R → R3 by

F(u,v,t) = (x(u,v),y(u,v),z(u,v)+t), (u,v) ∈ U,t ∈ R. Then

det(dFq) =

∂(x,y) ∂(u,v)

(q) ?= 0.

By the inverse function theorem, there exist neighborhoods W1 of q and W2 of F(q) such that F: W1 → W2 is a diffeomorphism. Set V = W1 ∩U and observe that the restriction F|V = x|V . Thus, x(V ) is diffeomorphic to V , and hence a regular surface. Q.E.D.

###### EXERCISES†

###### *1. Let S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} be the unit sphere and let A: S2 → S2 be the (antipodal) map A(x,y,z) = (−x,−y,−z). Prove that A is a diffeomorphism.

- 2. Let S ⊂ R3 be a regular surface and π: S → R2 be the map which takes each p ∈ S into its orthogonal projection over R2 = {(x,y,z) ∈ R3; z = 0}. Is π differentiable?
- 3. Show that the paraboloid z = x2 +y2 is diffeomorphic to a plane.
- 4. Construct a diffeomorphism between the ellipsoid


x2 a2 +

y2 b2 +

z2 c2 = 1

and the sphere x2 +y2 +z2 = 1.

###### *5. Let S ⊂ R3 be a regular surface, and let d: S → R be given by d(p) = |p −p0|, where p ∈ S, p0 ?= R3, p0 ?∈ S; that is, d is the distance from p to a ﬁxed point p0 not in S. Prove that d is differentiable.

†Those who have omitted the proofs of this section should also omit Exercises 13–16.

[Page 99]

- 6. Prove that the deﬁnition of a differentiable map between surfaces does not depend on the parametrizations chosen.
- 7. Prove that the relation “S1 is diffeomorphic to S2” is an equivalence relation in the set of regular surfaces.


- *8. Let S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} and H = {(x,y,z) ∈ R3; x2 +y2 −z2 = 1}. DenotebyN = (0,0,1)andS = (0,0,−1)thenorth and south poles of S2, respectively, and let F:S2 −{N}∪{S}→H be deﬁned as follows: For each p ∈ S2 −{N}∪{S} let the perpendicular from p to the z axis meet 0z at q. Consider the half-line l starting at q and containing p. Then F(p) = l ∩H (Fig. 2-20). Prove that F is differentiable.


F(p)

S

y

z

x

N q

p

l 0

###### Figure 2-20

- 9. a. Deﬁne the notion of differentiable function on a regular curve. What does one need to prove for the deﬁnition to make sense? Do not prove it now. If you have not omitted the proofs in this section, you will be asked to do it in Exercise 15.

b. Show that the map E: R → S1 = {(x,y) ∈ R2;x2 +y2 = 1} given

by

E(t) = (cost,sin t), t ∈ R,

is differentiable (geometrically, E “wraps” R around S1).

- 10. Let C be a plane regular curve which lies in one side of a straight line r of the plane and meets r at the points p,q (Fig. 2-21). What conditions should C satisfy to ensure that the rotation of C about r generates an extended (regular) surface of revolution?


[Page 100]

r

p

q

C

###### Figure 2-21

- 11. Prove that the rotations of a surface of revolution S about its axis are diffeomorphisms of S.
- 12. Parametrized surfaces are often useful to describe sets ? which are regular surfaces except for a ﬁnite number of points and a ﬁnite number of lines. For instance, let C be the trace of a regular parametrized curve α: (a,b) → R3 which does not pass through the origin O = (0,0,0). Let ? be the set generated by the displacement of a straight line l passing through a moving point p ∈ C and the ﬁxed point 0 (a cone with vertex 0; see Fig. 2-22).


0

C

###### Figure 2-22

a. Find a parametrized surface x whose trace is ?. b. Find the points where x is not regular. c. What should be removed from ? so that the remaining set is a regular

surface?

- *13. Show that the deﬁnition of differentiability of a function f : V ⊂ S → R giveninthetext(Def. 1)isequivalenttothefollowing: f isdifferentiable in p ∈ V if it is the restriction to V of a differentiable function deﬁned


[Page 101]

in an open set of R3 containing p. (Had we started with this deﬁnition of differentiability, we could have deﬁned a surface as a set which is locally diffeomorphic to R2; see Remark 3.)

- 14. Let A ⊂ S be a subset of a regular surface S. Prove that A is itself a regular surface if and only if A is open in S; that is, A = U ∩S, where U is an open set in R3.
- 15. Let C be a regular curve and let α: I ⊂ R → C, β: J ⊂ R → C be two parametrizations of C in a neighborhood of p ∈ α(I)∩β(J) = W. Let


h = α−1 ◦β: β−l(W) → α−l(W)

be the change of parameters. Prove that a. h is a diffeomorphism. b. The absolute value of the arc length of C in W does not depend on

which parametrization is chosen to deﬁne it, that is,

?

? t

t0

|α′(t)|dt? = ?

? τ

τ0

|β′(τ)|dτ?, t = h(τ),t ∈ I,τ ∈ J.

- *16. Let R2 = {(x,y,z) ∈ R3;z = −1} be identiﬁed with the complex plane C by setting (x,y,−1) = x +iy = ζ ∈ C. Let P: C → C be the complex polynomial


P(ζ) = a0ζn +a1ζn−1 +···+an, a0 ?= 0,ai ∈ C,i = 0,...,n.

Denote by πN the stereographic projection of S2 = {(x,y,z) ∈ R3; x2 +y2 +z2 = 1} from the north pole N = (0,0,1) onto R2. Prove that the map F: S2 → S2 given by

F(p) = πN−1 ◦P ◦πN(p), if p ∈ S2 −{N}, F(N) = N

is differentiable.

###### 2-4. The Tangent Plane;The Differential of a Map

In this section we shall show that condition 3 in the deﬁnition of a regular surface S guarantees that for every p ∈ S the set of tangent vectors to the parametrized curves of S, passing through p, constitutes a plane.

By a tangent vector to S, at a point p ∈ S, we mean the tangent vector α′(0) of a differentiable parametrized curve α: (−ǫ,ǫ) → S with α(0) = p.

[Page 102]

PROPOSITION 1. Let x: U ⊂ R2 → S be a parametrization of a regular surface S and let q ∈ U. The vector subspace of dimension 2,

dxq(R2) ⊂ R3, coincides with the set of tangent vectors to S at x(q).

Proof. Let w be a tangent vector at x(q), that is, let w = α′(0), where α: (−ǫ,ǫ) → x(U) ⊂ S is differentiable and α(0) = x(q). By Example 2 of Sec. 2-3, the curve β = x−1 ◦α: (−ǫ,ǫ) → U is differentiable. By deﬁnition of the differential (appendix to Chap. 2, Def. 1), we have dxq(β′(0)) = w. Hence, w ∈ dxq(R2) (Fig. 2-23).

–¨ 0 ¨

α

α

x S υ

q

u

β'(0)

w = α'(0)

p = α(0)

Tp(S)

###### Figure 2-23

On the other hand, let w = dxq(v), where v ∈ R2. It is clear that v is the velocity vector of the curve γ: (−ǫ,ǫ) → U given by

γ(t) = tv +q, t ∈ (−ǫ,ǫ).

By the deﬁnition of the differential, w = α′(0), where α = x ◦γ. This shows that w is a tangent vector. Q.E.D.

By the above proposition, the plane dxq(R2), which passes through x(q) = p, does not depend on the parametrization x. This plane will be called the tangent plane to S at p and will be denoted by Tp(S). The choice of the parametrization x determines a basis {(∂x/∂u)(q),(∂x/∂v)(q)} of Tp(S), called the basis associated to x. Sometimes it is convenient to write ∂x/∂u = xu and ∂x/∂v = xv.

[Page 103]

The coordinates of a vector w ∈ Tp(S) in the basis associated to a parametrization x are determined as follows. w is the velocity vector α′(0) of a curve α = x ◦β, where β: (−ǫ,ǫ) → U is given by β(t) = (u(t),v(t)), with β(0) = q = x−1(p). Thus,

α′(0) =

d dt

(x ◦β)(0) =

d dt

x(u(t),v(t))(0)

= xu(q)u′(0)+xv(q)v′(0) = w.

Thus, in the basis {xu(q),xv(q)}, w has coordinates (u′(0),v′(0)), where (u(t),v(t)) is the expression, in the parametrization x, of a curve whose velocity vector at t = 0 is w.

With the notion of a tangent plane, we can talk about the differential of a (differentiable) map between surfaces. Let S1 and S2 be two regular surfaces and let ϕ: V ⊂ S1 → S2 be a differentiable mapping of an open set V of S1 into S2. If p ∈ V , we know that every tangent vector w ∈ Tp(S1) is the velocity vector α′(0) of a differentiable parametrized curve α: (−ǫ,ǫ) → V with α(0) = p. The curve β = ϕ ◦α is such that β(0) = ϕ(p), and therefore β′(0) is a vector of Tϕ(p)(S2) (Fig. 2-24).

¨

–¨

0

α

w

p

φ φ(p)

dφp(w)

S1 S2

###### Figure 2-24

PROPOSITION 2. In the discussion above, given w, the vector β′(0) does not depend on the choice of α. The map dϕp: Tp(S1) → Tϕ(p)(S2) deﬁned by dϕp(w) = β′(0) is linear.

Proof. The proof is similar to the one given in Euclidean spaces (cf. Prop. 7, appendix to Chap. 2). Let x(u,v), x¯(u,¯ v)¯ be parametrizations in neighborhoods of p and ϕ(p), respectively. Suppose that ϕ is expressed in these coordinates by

ϕ(u,v) = (ϕ1(u,v),ϕ2(u,v)) and that α is expressed by

α(t) = (u(t),v(t)), t ∈ (−ǫ,ǫ).

[Page 104]

Then β(t) = (ϕ1(u(t),v(t)),ϕ2(u(t),v(t))), and the expression of β′(0) in the basis {¯xu¯,x¯v¯} is

β′(0) = ?

∂ϕ1 ∂u

u′(0)+

∂ϕ1 ∂v

v′(0),

∂ϕ2 ∂u

u′(0)+

∂ϕ2 ∂v

v′(0)?.

The relation above shows that β′(0) depends only on the map ϕ and the coordinates (u′(0),v′(0)) of w in the basis {xu,xv}. β′(0) is therefore independent of α. Moreover, the same relation shows that

β′(0) = dϕp(w) =

⎛ ⎜ ⎝

- ∂ϕ1 ∂u

∂ϕ1 ∂v

- ∂ϕ2 ∂u


∂ϕ2 ∂v

⎞ ⎟ ⎠

⎛ ⎜ ⎝

- u′(0)
- v′(0)


⎞ ⎟ ⎠;

that is, dϕp is a linear mapping of Tp(S1) into Tϕ(p)(S2) whose matrix in the bases {xu,xv} of Tp(S1) and {¯xu¯,x¯v¯} of Tϕ(p)(S2) is just the matrix given above. Q.E.D.

The linear map dϕp deﬁned by Prop. 2 is called the differential of ϕ at p ∈ S1. In a similar way we deﬁne the differential of a (differentiable) function f : U ⊂ S → R at p ∈ U as a linear map dfp: Tp(S) → R. We leave the details to the reader.

Example 1. Let v ∈ R3 be a unit vector and let h: S → R, h(p) = v ·p, p ∈ S, be the height function deﬁned in Example 1 of Sec. 2-3. To compute dhp(w), w ∈ Tp(S), choose a differentiable curve α: (−ǫ,ǫ) → S with α(0) = p, α′(0) = w. Since h(α(t)) = α(t)·v, we obtain

dhp(w) =

d dt

h(α(t))|t=0 = α′(0)·v = w ·v.

Example 2. Let S2 ⊂ R3 be the unit sphere

S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1}

and let Rz,θ: R3 → R3 be the rotation of angle θ about the z axis. Then Rz,θ restricted to S2 is a differentiable map of S2 (cf. Example 3 of Sec. 2-3). We shall compute (dRz,θ)p(w), p ∈ S2, w ∈ Tp(S2). Let α: (−ǫ,ǫ) → S2 be a differentiable curve with α(0) = p, α′(0) = w. Then, since Rz,θ is linear,

(dRz,θ)p(w) =

d dt

(Rz,θ ◦α(t))t=0 = Rz,θ(α′(0)) = Rz,θ(w).

Observe that Rz,θ leaves the north pole N = (0,0,1) ﬁxed, and that (dRz,θ)N: TN(S2) → TN(S2) is just a rotation of angle θ in the plane TN(S2).

[Page 105]

In retrospect, what we have been doing up to now is extending the notions of differential calculus in R2 to regular surfaces. Since calculus is essentially a local theory, we deﬁned an entity (the regular surface) which locally was a plane, up to diffeomorphisms, and this extension then became natural. It might be expected therefore that the basic inverse function theorem extends to differentiable mappings between surfaces.

We shall say that a mapping ϕ: U ⊂ S1 → S2 is a local diffeomorphism at p ∈ U if there exists a neighborhood V ⊂ U of p such that ϕ restricted to V is a diffeomorphism onto an open set ϕ(V ) ⊂ S2. In these terms, the version of the inverse of function theorem for surfaces is expressed as follows.

PROPOSITION 3. If S1 andS2 areregularsurfacesandϕ:U ⊂ S1 →S2 is a differentiable mapping of an open set U ⊂ S1 such that the differential dϕp of ϕ at p ∈ U is an isomorphism, then ϕ is a local diffeomorphism at p.

TheproofisanimmediateapplicationoftheinversefunctiontheoreminR2 and will be left as an exercise.

Of course, all other concepts of calculus, like critical points, regular values, etc., do extend naturally to functions and maps deﬁned on regular surfaces.

The tangent plane also allows us to speak of the angle of two intersecting surfaces at a point of intersection.

Given a point p on a regular surface S, there are two unit vectors of R3 that are normal to the tangent plane Tp(S); each of them is called a unit normal vector at p. The straight line that passes through p and contains a unit normal vectoratp iscalledthenormalline atp. Theangle oftwointersectingsurfaces at an intersection point p is the angle of their tangent planes (or their normal lines) at p (Fig. 2-25).

S1 ∩ S2

p

S1

S2

Tp(S2)

Tp(S1)

###### Figure 2-25

By ﬁxing a parametrization x: U ⊂ R2 → S at p ∈ S, we can make a deﬁnite choice of a unit normal vector at each point q ∈ x(U) by the rule

N(q) =

xu ∧xv |xu ∧xv|

(q).

[Page 106]

Thus, we obtain a differentiable map N: x(U) → R3. We shall see later (Secs. 2-6 and 3-1) that it is not always possible to extend this map differentiably to the whole surface S.

Before leaving this section, we shall make some observations on questions of differentiability.

The deﬁnition given for a regular surface requires that the parametrization be of class C∞, that is, that they possess continuous partial derivatives of all orders. For questions in differential geometry we need in general the existence and continuity of the partial derivatives only up to a certain order, which varies with the nature of the problem (very rarely do we need more than four derivatives).

For example, the existence and continuity of the tangent plane depends only on the existence and continuity of the ﬁrst partial derivatives. It could happen, therefore, that the graph of a function z = f (x,y) admits a tangent plane at every point but is not sufﬁciently differentiable to satisfy the deﬁnition of a regular surface. This occurs in the following example.

Example 3. Consider the graph of the function z = ?3

(x2 +y2)2, generated by rotating the curve z = x4/3 about the z axis. Since the curve is symmetric relative to the z axis and has a continuous derivative which vanishes at the origin, it is clear that the graph of z = ?3

(x2 +y2)2 admits the xy plane as a tangent plane at the origin. However, the partial derivative zxx does not exist at the origin, and the graph considered is not a regular surface

- as deﬁned above (see Prop. 3 of Sec. 2-2).


We do not intend to get involved with this type of question. The hypothesis C∞ in the deﬁnition was adopted precisely to avoid the study of the minimal conditions of differentiability required in each particular case. These nuances have their place, but they can eventually obscure the geometric nature of the problems treated here.

###### EXERCISES

*1. Show that the equation of the tangent plane at (x0,y0,z0) of a regular surface given by f (x,y,z) = 0, where 0 is a regular value of f , is

fx(x0,y0,z0)(x −x0)+fy(x0,y0,z0)(y −y0)+fz(x0,y0,z0)(z −z0)

= 0.

2. Determine the tangent planes of x2 +y2 −z2 = 1 at the points (x,y,0)

and show that they are all parallel to the z axis.

3. Show that the equation of the tangent plane of a surface which is the graph of a differentiable function z = f (x,y), at the point p0 = (x0,y0), is given by

[Page 107]

z = f (x0,y0)+fx(x0,y0)(x −x0)+fy(x0,y0)(y −y0).

Recall the deﬁnition of the differential df of a function f : R2 → R and show that the tangent plane is the graph of the differential dfp.

- *4. Show that the tangent planes of a surface given by z = xf (y/x), x ?= 0, where f is a differentiable function, all pass through the origin (0,0,0).


- 5. If a coordinate neighborhood of a regular surface can be parametrized in the form

x(u,v) = α1(u)+α2(v),

where α1 and α2 are regular parametrized curves, show that the tangent planesalongaﬁxedcoordinatecurveofthisneighborhoodareallparallel to a line.

- 6. Let α: I → R3 bearegularparametrizedcurvewitheverywherenonzero curvature. Consider the tangent surface of α (Example 5 of Sec. 2-3)

x(t,v) = α(t)+vα′(t), t ∈ I,v ?= 0.

Show that the tangent planes along the curve x(const.,v) are all equal.

- 7. Let f : S → R be given by f (p) = |p −p0|2, where p ∈ S and p0 is a ﬁxed point of R3 (see Example 1 of Sec. 2-3). Show that dfp(w) = 2w ·(p −p0), w ∈ Tp(S).
- 8. Prove that if L: R3 → R3 is a linear map and S ⊂ R3 is a regular surface invariant under L, i.e., L(S) ⊂ S, then the restriction L|S is a differentiable map and

dLp(w) = L(w), p ∈ S,w ∈ Tp(S).

- 9. Show that the parametrized surface x(u,v) = (v cosu,v sin u,au), a ?= 0,

is regular. Compute its normal vector N(u,v) and show that along the coordinate line u = u0 the tangent plane of x rotates about this line in such a way that the tangent of its angle with the z axis is proportional to the inverse of the distance v(= ?

x2 +y2) of the point x(u0,v) to the z axis.

- 10. (Tubular Surfaces.) Let α: I → R3 be a regular parametrized curve with nonzero curvature everywhere and arc length as parameter. Let


x(s,v) = α(s)+r(n(s)cosv +b(s)sin v), r = const. ?= 0,s ∈ I,

be a parametrized surface (the tube of radius r around α), where n is the normal vector and b is the binormal vector of α. Show that, when x is regular, its unit normal vector is

[Page 108]

N(s,v) = −(n(s)cosv +b(s)sin v).

- 11. Show that the normals to a parametrized surface given by x(u,v) = (f(u)cosv,f(u)sin v,g(u)), f(u) ?= 0,g′ ?= 0,


all pass through the z axis.

- *12. Show that each of the equations (a,b,c ?= 0)

x2 +y2 +z2 = ax, x2 +y2 +z2 = by, x2 +y2 +z2 = cz

deﬁne a regular surface and that they all intersect orthogonally.

13. A critical point of a differentiable function f : S → R deﬁned on a

regular surface S is a point p ∈ S such that dfp = 0.

*a. Let f : S → R be given by f (p) = |p −p0|, p ∈ S, p0 ?∈ S (cf. Exercise 5, Sec. 2-3). Show that p ∈ S is a critical point of f if and only if the line joining p to p0 is normal to S at p.

b. Let h: S → R be given by h(p) = p ·v, where v ∈ R3 is a unit vector (cf. Example 1, Sec. 2-3). Show that p ∈ S is a critical point of f if and only if v is a normal vector of S at p.

- *14. Let Q be the union of the three coordinate planes x = 0,y = 0,z = 0. Let p = (x,y,z) ∈ R3 −Q.


- a. Show that the equation in t, x2

a −t +

y2 b −t +

z2

c −t ≡ f (t) = 1, a > b > c > 0, has three distinct real roots: t1,t2,t3.

- b. Show that for each p ∈ R3 −Q, the sets given by f (t1)−1 = 0, f (t2)−1 = 0, f (t3)−1 = 0 are regular surfaces passing through p which are pairwise orthogonal.


- 15. Showthatifallnormalstoaconnectedsurfacepassthroughaﬁxedpoint, the surface is contained in a sphere.
- 16. Let w be a tangent vector to a regular surface S at a point p ∈ S and let x(u,v) and x¯(u,¯ v)¯ be two parametrizatioos at p. Suppose that the expressions of w in the bases associated to x(u,v) and x¯(u,¯ v)¯ are


w = α1xu +α2xv and

w = β1x¯u¯ +β2xv¯.

[Page 109]

Show that the coordinates of w are related by

- β1 = α1

∂u¯ ∂u +α2

∂u¯ ∂v

- β2 = α1


∂v¯ ∂u +α2

∂v¯ ∂v

,

where u¯ = u(u,¯ v) and v¯ = v(u,v)¯ are the expressions of the change of coordinates.

- *17. Two regular surfaces S1 and S2 intersect transversally if whenever p ∈ S1 ∩S2 then Tp(S1) ?= Tp(S2). Prove that if S1 intersects S2 transversally, then S1 ∩S2 is a regular curve.

18. Prove that if a regular surface S meets a plane P in a single point p, then

this plane coincides with the tangent plane of S at p.

19. Let S ⊂ R3 be a regular surface and P ⊂ R3 be a plane. If all points of S are on the same side of P, prove that P is tangent to S at all points of P ∩S.

- *20. Show that the perpendicular projections of the center (0,0,0) of the ellipsoid

x2 a2 +

y2 b2 +

z2 c2 = 1

onto its tangent planes constitute a regular surface given by {(x,y,z) ∈ R3;(x2 +y2 +z2)2 = a2x2 +b2y2 +c2z2}−{(0,0,0)}.

- *21. Let f : S → R be a differentiable function on a connected regular surface S. Assume that dfp = 0 for all p ∈ S. Prove that f is constant on S.
- *22. Prove that if all normal lines to a connected regular surface S meet a ﬁxed straight line, then S is a piece of a surface of revolution.


- 23. Prove that the map F: S2 → S2 deﬁned in Exercise 16 of Sec. 2-3 has only a ﬁnite number of critical points (see Exercise 13).
- 24. (Chain Rule.) Show that if ϕ: S1 → S2 and ψ: S2 → S3 are differentiable maps and p ∈ S1, then

d(ψ ◦ϕ)p = dψϕ(p) ◦dϕp.

- 25. Prove that if two regular curves C1 and C2 of a regular surface S are tangent at a point p ∈ S, and if ϕ: S → S is a diffeomorphism, then ϕ(C1) and ϕ(C2) are regular curves which are tangent at ϕ(p).
- 26. Show that if p is a point of a regular surface S, it is possible, by a convenient choice of the (x,y,z) coordinates, to represent a neighborhood


[Page 110]

- of p in S in the form z = f (x,y) so that f (0,0) = 0, fx(0,0) = 0, fy(0,0) = 0. (This is equivalent to taking the tangent plane to S at p as the xy plane.)
- 27. (Theory of Contact.) Two regular surfaces, S and S¯, in R3, which have a point p in common, are said to have contact of order ≥ 1 at p if there exist parametrizations with the same domain x(u,v), x¯(u,v) at p of S

and S¯, respectively, such that xu = x¯u and xv = x¯v at p. If, moreover, some of the second partial derivatives are different at p, the contact is said to be of order exactly equal to 1. Prove that

- a. The tangent plane Tp(S) of a regular surface S at the point p has contact of order ≥ 1 with the surface at p.
- b. If a plane has contact of order ≥ 1 with a surface S at p, then this plane coincides with the tangent plane to S at p.
- c. Two regular surfaces have contact of order ≥ 1 if and only if they have a common tangent plane at p, i.e., they are tangent at p.
- d. If two regular surfaces S and S¯ of R3 have contact of order ≥ 1 at p and if F: R3 → R3 is a diffeomorphism of R3, then the images F(S) and F(S)¯ are regular surfaces which have contact of order ≥ 1 at f (p) (that is, the notion of contact of order ≥ 1 is invariant under diffeomorphisms).
- e. If two surfaces have contact of order ≥ 1 at p, then limr→0(d/r) = 0, where d is the length of the segment which is determined by the intersections with the surfaces of some parallel to the common normal, at a distance r from this normal.


- 28. a. Deﬁne regular value for a differentiable function f : S → R on a regular surface S.


b. Show that the inverse image of a regular value of a differentiable

function on a regular surface S is a regular curve on S.

###### 2-5. The First Fundamental Form; Area

So far we have looked at surfaces from the point of view of differentiability. In this section we shall begin the study of further geometric structures carried by the surface. The most important of these is perhaps the ﬁrst fundamental form, which we shall now describe.

The natural inner product of R3 ⊃ S induces on each tangent plane Tp(S) of a regular surface S an inner product, to be denoted by ? , ?p: If w1,w2 ∈ Tp(S) ⊂ R3, then ?w1,w2?p is equal to the inner product of w1 and

- w2 as vectors in R3. To this inner product, which is a symmetric bilinear form


[Page 111]

(i.e., ?w1,w2? = ?w2,w1? and ?w1,w2? is linear in both w1 and w2), there corresponds a quadratic form Ip: Tp(S) → R given by

Ip(w) = ?w,w?p = |w|2 ≥ 0. (1)

DEFINITION 1. The quadratic form Ip on Tp(S), deﬁned by Eq. (1), is called the ﬁrst fundamental form of the regular surface S ⊂ R3 at p ∈ S.

Therefore, the ﬁrst fundamental form is merely the expression of how the surface S inherits the natural inner product of R3. Geometrically, as we shall see in a while, the ﬁrst fundamental form allows us to make measurements on the surface (lengths of curves, angles of tangent vectors, areas of regions) without referring back to the ambient space R3 where the surface lies.

We shall now express the ﬁrst fundamental form in the basis {xu,xv} associated to a parametrization x(u,v) at p. Since a tangent vector w ∈ Tp(S) is the tangent vector to a parametrized curve α(t) = x(u(t),v(t)), t ∈ (−ǫ,ǫ), with p = α(0) = x(u0,v0), we obtain

Ip(α′(0)) = ?α′(0),α′(0)?p

= ?xuu′ +xvv′,xuu′ +xvv′?p

= ?xu,xu?p(u′)2 +2?xu,xv?pu′v′ +?xv,xv?p(v′)2

= E(u′)2 +2Fu′v′ +G(v′)2, where the values of the functions involved are computed for t = 0, and

- E(u0,v0) = ?xu,xu?p,
- F(u0,v0) = ?xu,xv?p,
- G(u0,v0) = ?xv,xv?p


are the coefﬁcients of the ﬁrst fundamental form in the basis {xu,xv} of Tp(S). By letting p run in the coordinate neighborhood corresponding to x(u,v) we obtain functions E(u,v),F(u,v),G(u,v) which are differentiable in that neighborhood.

From now on we shall drop the subscript p in the indication of the inner product ? , ?p or the quadratic form Ip when it is clear from the context which point we are referring to. It will also be convenient to denote the natural inner product of R3 by the same symbol ? , ? rather than the previous dot.

Example 1. A coordinate system for a plane P ⊂ R3 passing through p0 = (x0,y0,z0) and containing the orthonormal vectors w1 = (a1,a2,a3),

- w2 = (b1,b2,b3) is given as follows: x(u,v) = p0 +uw1 +vw2, (u,v) ∈ R2.


To compute the ﬁrst fundamental form for an arbitrary point of P we observe that xu = w1, xv = w2; since w1 and w2 are unit orthogonal vectors, the functions E,F,G are constant and given by

[Page 112]

E = 1, F = 0, G = 1.

In this trivial case, the ﬁrst fundamental form is essentially the Pythagorean theorem in P; i.e., the square of the length of a vector w which has coordinates a,b in the basis {xu,xv} is equal to a2 +b2.

Example 2. The right cylinder over the circle x2 +y2 = 1 admits the parametrization x: U → R3, where (Fig. 2-26)

x(u,v) = (cosu,sin u,v),

U = {(u,v) ∈ R2; 0 < u < 2π, −∞ < v < ∞}.

p

z

υ

u

y

- x

0

Figure 2-26

To compute the ﬁrst fundamental form, we notice that

xu = (−sin u,cosu,0), xv = (0,0,1), and therefore

E = sin2 u+cos2 u = 1, F = 0, G = 1.

We remark that, although the cylinder and the plane are distinct surfaces, we obtain the same result in both cases. We shall return to this subject later (Sec. 4-2).

Example 3. Consider a helix that is given by (see Example 1, Sec. 1-2) (cosu,sin u,au). Through each point of the helix, draw a line parallel to the

- xy plane and intersecting the z axis. The surface generated by these lines is called a helicoid and admits the following parametrization:


x(u,v) = (v cosu,v sin u,au), 0 < u < 2π, −∞ < v < ∞.

- x applies an open strip with width 2π of the uv plane onto that part of the helicoid which corresponds to a rotation of 2π along the helix (Fig. 2-27).


[Page 113]

Figure 2-27. The helicoid.

The veriﬁcation that the helicoid is a regular surface is straightforward and left to the reader.

The computation of the coefﬁcients of the ﬁrst fundamental form in the above parametrization gives

E(u,v) = v2 +a2, F(u,v) = 0, G(u,v) = 1.

As we mentioned before, the importance of the ﬁrst fundamental form I comes from the fact that by knowing I we can treat metric questions on a regular surface without further references to the ambient space R3. Thus, the arc length s of a parametrized curve α: I → S is given by

s(t) = ? t

o

|α′(t)|dt = ? t

o

?

I(α′(t))dt.

In particular, if α(t) = x(u(t),v(t)) is contained in a coordinate neighborhood corresponding to the parametrization x(u,v), we can compute the arc length of α between, say, 0 and t by

s(t) = ? t

0

?

E(u′)2 +2Fu′v′ +G(v′)2 dt. (2)

Also, the angle θ under which two parametrized regular curves α: I → S, β: I → S intersect at t = t0 is given by

cosθ =

?α′(t0),β′(t0)? |α′(t0)||β′(t0)|

.

[Page 114]

Inparticular, theangleϕ ofthecoordinatecurvesofaparametrizationx(u,v)is

cosϕ =

?xu,xv? |xu||xv|

=

F √EG;

it follows that the coordinate curves of a parametrization are orthogonal if and only if F(u,v) = 0 for all (u, v). Such a parametrization is called an orthogonal parametrization.

Remark. Because of Eq. (2), many mathematicians talk about the “element” of arc length, ds of S, and write

ds2 = E du2 +2F du dv +Gdv2,

meaning that if α(t) = x(u(t),v(t)) is a curve on S and s = s(t) is its arc length, then

?

ds dt ?2 = E ?

du dt ?2 +2F

du dt

dv dt +G?

dv dt ?2 .

Example 4. We shall compute the ﬁrst fundamental form of a sphere

- at a point of the coordinate neighborhood given by the parametrization (cf. Example 1, Sec. 2-2)


x(θ,ϕ) = (sin θ cosϕ,sin θ sin ϕ,cosθ). First, observe that

xθ(θ,ϕ) = (cosθ cosϕ,cosθ sin ϕ,−sin θ), xϕ(θ,ϕ) = (−sin θ sin ϕ,sin θ cosϕ,0).

Hence,

- E(θ,ϕ) = ?xθ,xθ? = 1,
- F(θ,ϕ) = ?xθ,xϕ? = 0,
- G(θ,ϕ) = ?xϕ,xϕ? = sin2 θ.


Thus, if w is a tangent vector to the sphere at the point x(θ,ϕ), given in the basis associated to x(θ,ϕ) by

w = axθ +bxϕ, then the square of the length of w is given by

|w|2 = I(w) = Ea2 +2Fab +Gb2 = a2 +b2 sin2 θ.

[Page 115]

As an application, let us determine the curves in this coordinate neighborhood of the sphere which make a constant angle β with the meridians ϕ = const. These curves are called loxodromes (rhumb lines) of the sphere.

We may assume that the required curve α(t) is the image by x of a curve (θ(t),ϕ(t)) of the θϕ plane. At the point x(θ,ϕ) where the curve meets the meridian ϕ = const., we have

cosβ =

?xθ,α′(t)? |xθ||α′(t)|

=

θ′ ?

(θ′)2 +(ϕ′)2 sin2 θ

,

since in the basis {xθ,xϕ}, the vector α′(t) has coordinates (θ′,ϕ′) and the vector xθ has coordinates (1,0). It follows that

(θ′)2 tan2 β −(ϕ′)2 sin2 θ = 0 or

θ′ sin θ = ±

ϕ′ tan β

,

whence, by integration, we obtain the equation of the loxodromes

log tan ?

θ 2? = ±(ϕ +c)cotan β,

where the constant of integration c is to be determined by giving one point x(θ0,ϕ0) through which the curve passes.

Another metric question that can be treated by the ﬁrst fundamental form is the computation (or deﬁnition) of the area of a bounded region of a regular surface S.A(regular) domain of S is an open and connected subset of S such that its boundary is the image in S of a circle by a differentiable homeomorphism which is regular (that is, its differential is nonzero) except at a ﬁnite number of points.Aregion of S is the union of a domain with its boundary (Fig. 2-28). A region of S ⊂ R3 is bounded if it is contained in some ball of R3.

Boundary of R

S

R

###### Figure 2-28

[Page 116]

Let Q be a compact region in R2 that is contained in a coordinate neighborhood x: U → S. Then x(Q) = R is a bounded region in S.

Thefunction |xu ∧xv|, deﬁnedin U, measurestheareaoftheparallelogram generated by the vectors xu and xv. We ﬁrst show that the integral

?

Q

|xu ∧xv|du dv

does not depend on the parametrization x.

In fact, let x¯: U¯ ⊂ R2 → S be another parametrization with R ⊂ x¯(U)¯ and set Q¯ = x¯−1(R). Let ∂(u,v)/∂(u,¯ v)¯ be the Jacobian of the change of parameters h = x−1 ◦x¯. Then

??

Q¯

|¯xu¯ ∧x¯v¯|dud¯ v¯ = ??

Q¯

|xu ∧xv|?

∂(u,v) ∂(u,¯ v)¯ ? dud¯ v¯

= ??

Q

|xu ∧xv|du dv,

wherethelastequalitycomesfromthetheoremofchangeofvariablesinmultiple integrals (cf. BuckAdvanced Calculus, p. 304). The asserted independence is therefore proved and we can make the following deﬁnition.

DEFINITION 2. LetR ⊂ Sbeaboundedregionofaregularsurfacecontainedinthecoordinateneighborhoodoftheparametrizationx: U ⊂ R2 → S. The positive number

??

Q

|xu ∧xv|du dv = A(R), Q = x−1(R),

is called the area of R.

There are several geometric justiﬁcations for such a deﬁnition, and one of them will be presented in Sec. 2-8.

It is convenient to observe that |xu ∧xv|2 +?xu ·xv?2 = |xu|2 ·|xv|2, which shows that the integrand of A(R) can be written as |xu ∧xv| = ?

EG −F2.

Weshouldalsoremarkthat, inmostexamples, therestrictionthattheregion R is contained in some coordinate neighborhood is not very serious, because there exist coordinate neighborhoods which cover the entire surface except for some curves, which do not contribute to the area.

[Page 117]

Example 5. Let us compute the area of the torus of Example 6, Sec. 2-2. For that, we consider the coordinate neighborhood corresponding to the parametrization

x(u,v) = ((a +r cosu)cosv,(a +r cosu)sin v,r sin u),

0 < u < 2π, 0 < v < 2π,

which covers the torus, except for a meridian and a parallel. The coefﬁcients of the ﬁrst fundamental form are

E = r2, F = 0, G = (r cosu+a)2; hence, ?

EG −F2 = r(r cosu+a).

Now, consider the region Rǫ obtained as the image by x of the region Qǫ (Fig. 2-29) given by (ǫ > 0 and small),

Qǫ = {(u,v) ∈ R2;0+ǫ ≤ u ≤ 2π −ǫ,0+ǫ ≤ v ≤ 2π −ǫ}. Using Def. 2, we obtain

A(Rǫ) = ??

Qǫ

r(r cosu+a)du dv

= ? 2π−ǫ

0+ǫ

(r2 cosu+ra)du ? 2π−ǫ

0+ǫ

dv

= r2(2π −2ǫ)(sin(2π −ǫ)−sin ǫ)+ra(2π −2ǫ)2. Letting ǫ → 0 in the above expression, we obtain

A(T ) = lim

ǫ→0

A(Rǫ) = 4π2ra.

є

2є

0

2є є

υ

Qє

u

x

x

z

y

0

2π

2π

є

є

###### Figure 2-29

[Page 118]

This agrees with the value found by elementary calculus, say, by using the theorem of Pappus for the area of surfaces of revolution (cf. Exercise 11).

###### EXERCISES

- 1. Compute the ﬁrst fundamental forms of the following parametrized surfaces where they are regular:

- a. x(u,v) = (a sin ucosv,b sin usin v,c cosu); ellipsoid.
- b. x(u,v) = (aucosv,busin v,u2); elliptic paraboloid.
- c. x(u,v) = (aucosh v,businh v,u2); hyperbolic paraboloid.
- d. x(u,v) = (a sinh ucosv,b sinh usin v,c cosh u); hyperboloid of two sheets.


- 2. Let x(ϕ,θ) = (sin θ cosϕ,sin θ sin ϕ,cosθ) be a parametrization of the unit sphere S2. Let P be the plane x = z cotan α, 0 < α < π, and β be the

acute angle which the curve P ∩S2 makes with the semimeridian ϕ = ϕ0. Compute cosβ.

- 3. Obtain the ﬁrst fundamental form of the sphere in the parametrization given by stereographic projection (cf. Exercise 16, Sec. 2-2).
- 4. Given the parametrized surface

x(u,v) = (ucosv,usin v,log cosv +u), −

π 2

< v <

π 2

,

show that the two curves x(u,v1), x(u,v2) determine segments of equal lengths on all curves x(u,const.).

- 5. Show that the area A of a bounded region R of the surface z = f (x,y) is

A = ??

Q

?

1+fx2 +fy2 dx dy, where Q is the normal projection of R onto the xy plane.

- 6. Show that


x(u,v) = (usin α cosv,usin α sin v,ucosα)

0 < u < ∞, 0 < v < 2π, α = const.,

is a parametrization of the cone with 2α as the angle of the vertex. In the corresponding coordinate neighborhood, prove that the curve

x(c exp(v sin α cotan β),v), c = const.,β = const.,

intersects the generators of the cone (v = const.) under the constant angle β.

[Page 119]

- 7. The coordinate curves of a parametrization x(u,v) constitute a Tchebyshef net if the lengths of the opposite sides of any quadrilateral formed by them are equal. Show that a necessary and sufﬁcient condition for this is


∂E ∂v =

∂G ∂u = 0.

- *8. ProvethatwheneverthecoordinatecurvesconstituteaTchebyshefnet(see Exercise 7) it is possible to reparametrize the coordinate neighborhood in such a way that the new coefﬁcients of the ﬁrst fundamental form are

E = 1, F = cosθ, G = 1, where θ is the angle of the coordinate curves.

- *9. Show that a surface of revolution can always be parametrized so that E = E(v), F = 0, G = 1.


- 10. Let P = {(x,y,z) ∈ R3;z = 0} be the xy plane and let x: U → P be a parametrization of P given by

x(ρ,θ) = (ρ cosθ,ρ sin θ), where

U = {(ρ,θ) ∈ R2;ρ > 0,0 < θ < 2π}.

Compute the coefﬁcients of the ﬁrst fundamental form of P in this parametrization.

- 11. Let S be a surface of revolution and C its generating curve (cf. Example 4, Sec. 2-3). Let s be the arc length of C and denote by ρ = ρ(s) the distance to the rotation axis of the point of C corresponding to s.

- a. (Pappus’Theorem.) Show that the area of S is

2π ? l

0

ρ(s)ds,

where l is the length of C.

- b. Apply part a to compute the area of a torus of revolution.


- 12. Show that the area of a regular tube of radius r around a curve α (cf. Exercise 10, Sec. 2-4) is 2πr times the length of α.
- 13. (Generalized Helicoids.) Anatural generalization of both surfaces of revolution and helicoids is obtained as follows. Let a regular plane curve C, which does not meet an axis E in the plane, be displaced in a rigid screw motion about E, that is, so that each point of C describes a helix (or circle)


[Page 120]

with E as axis. The set S generated by the displacement of C is called a generalized helicoid with axis E and generator C. If the screw motion is a pure rotation about E,S is a surface of revolution; if C is a straight line perpendicular to E,S is (a piece of) the standard helicoid (cf. Example 3).

Choose the coordinate axes so that E is the z axis and C lies in the yz plane. Prove that

- a. If (f(s),g(s)) is a parametrization of C by arc length s, a < s < b, f (s) > 0, then x: U → S, where

U = {(s,u) ∈ R2;a < s < b,0 < u < 2π} and

x(s,u) = (f(s)cosu,f(s)sin u,g(s)+cu), c = const., is a parametrization of S. Conclude that S is a regular surface.

- b. The coordinate lines of the above parametrization are orthogonal (i.e., F = 0) if and only if x(U) is either a surface of revolution or (a piece of) the standard helicoid.


- 14. (Gradient on Surfaces.) The gradient of a differentiable function f : S → R is a differentiable map grad f : S → R3 which assigns to each point p ∈ S a vector grad f (p) ∈ Tp(S) ⊂ R3 such that


?gradf(p),v?p = dfp(v) for all v ∈ Tp(S). Show that

- a. If E,F,G are the coefﬁcients of the ﬁrst fundamental form in a parametrization x: U ⊂ R2 → S, then grad f on x(U) is given by

gradf =

fuG−fvF EG −F2

xu +

fvE −fuF EG −F2

xv. In particular, if S = R2 with coordinates x,y,

gradf = fxe1 +fye2,

where {e1,e2} is the canonical basis of R2 (thus, the deﬁnition agrees with the usual deﬁnition of gradient in the plane).

- b. If you let p ∈ S be ﬁxed and v vary in the unit circle |v| = 1 in Tp(s),

then dfp(v) is maximum if and only if v = gradf/|gradf | (thus, grad f (p) gives the direction of maximum variation of f at p).

- c. If grad f ?= 0 at all points of the level curve C = {q ∈ S;f (q) = const.}, then C is a regular curve on S and grad f is normal to C at all points of C.


[Page 121]

- 15. (Orthogonal Families of Curves.)


a. Let E,F,G be the coefﬁcients of the ﬁrst fundamental form of a regular surface S in the parametrization x: U ⊂ R2 → S. Let ϕ(u,v) = const. and ψ(u,v) = const. be two families of regular curves on x(U) ⊂ S (cf. Exercise 28, Sec. 2-4). Prove that these two families are orthogonal (i.e., whenever two curves of distinct families meet, their tangent lines are orthogonal) if and only if

Eϕvψv −F(ϕuψv +ϕvψu)+Gϕuψu = 0.

b. Apply part a to show that on the coordinate neighborhood x(U) of the

helicoid of Example 3 the two families of regular curves v cosu = const., v ?= 0,

(v2 +a2)sin2 u = const., v ?= 0, u ?= π, are orthogonal.

###### 2-6. Orientation of Surfaces†

In this section we shall discuss in what sense, and when, it is possible to orient a surface. Intuitively, since every point p of a regular surface S has a tangent plane Tp(S), the choice of an orientation of Tp(S) induces an orientation in a neighborhood of p, that is, a notion of positive movement along sufﬁciently small closed curves about each point of the neighborhood (Fig. 2-30). If it is possible to make this choice for each p ∈ S so that in the intersection of any two neighborhoods the orientations coincide, then S is said to be orientable. If this is not possible, S is called nonorientable.

We shall now make these ideas precise. By ﬁxing a parametrization x(u,v) of a neighborhood of a point p of a regular surface S, we determine an orientation of the tangent plane Tp(S), namely, the orientation of the associated ordered basis {xu,xv}. If p belongs to the coordinate neighborhood of another parametrization x¯(u,¯ v)¯ , the new basis {¯xu¯,x¯v¯} is expressed in terms of the ﬁrst one by

x¯u¯ = xu

∂u ∂u¯ +xv

∂v ∂u¯

,

xv¯ = xu

∂u ∂v¯ +xv

∂v ∂v¯

,

whereu = u(u,¯ v)¯ andv = v(u,¯ v)¯ aretheexpressionsofthechangeofcoordinates.Thebases{xu,xv}and{¯xu¯,x¯v¯}determine, therefore, thesameorientation of Tp(S) if and only if the Jacobian

†This section may be omitted on a ﬁrst reading.

[Page 122]

p

S

Tp(S)

###### Figure 2-30

∂(u,v) ∂(u,¯ v)¯

of the coordinate change is positive.

DEFINITION 1. A regular surface S is called orientable if it is possible to cover it with a family of coordinate neighborhoods in such a way that if a point p ∈ S belongs to two neighborhoods of this family, then the change of coordinates has positive Jacobian at p. The choice of such a family is called an orientation of S, and S, in this case, is called oriented. If such a choice is not possible, the surface is called nonorientable.

- Example 1. A surface which is the graph of a differentiable function (cf.

Sec. 2-2, Prop. 1) is an orientable surface. In fact, all surfaces which can be covered by one coordinate neighborhood are trivially orientable.

- Example 2. The sphere is an orientable surface. Instead of proceeding


to a direct calculation, let us resort to a general argument. The sphere can be covered by two coordinate neighborhoods (using stereographic projection; see Exercise 16 of Sec. 2-2), with parameters (u,v) and (u,¯ v)¯ , in such a way that the intersection W of these neighborhoods (the sphere minus two points) is a connected set. Fix a point p in W. If the Jacobian of the coordinate change at p is negative, we interchange u and v in the ﬁrst system, and the Jacobian becomes positive. Since the Jacobian is different from zero in W and positive at p ∈ W, it follows from the connectedness of W that the Jacobianiseverywherepositive. Thereexists, therefore, afamilyofcoordinate neighborhoods satisfying Def. 1, and so the sphere is orientable.

[Page 123]

By the argument just used, it is clear that if a regular surface can be covered by two coordinate neighborhoods whose intersection is connected, then the surface is orientable.

Before presenting an example of a nonorientable surface, we shall give a geometric interpretation of the idea of orientability of a regular surface in R3.

As we have seen in Sec. 2-4, given a system of coordinates x(u,v) at p, we have a deﬁnite choice of a unit normal vector N at p by the rule

N =

xu ∧xv |xu ∧xv|

(p). (1)

Taking another system of local coordinates x¯(u,¯ v)¯ at p, we see that

x¯u¯ ∧x¯v¯ = (xu ∧xv)

∂(u,v) ∂(u,¯ v)¯

###### , (2)

where ∂(u,v)/∂(u,¯ v)¯ is the Jacobian of the coordinate change. Hence, N will preserve its sign or change it, depending on whether ∂(u,v)/∂(u,¯ v)¯ is positive or negative, respectively.

By a differentiable ﬁeld of unit normal vectors on an open set U ⊂ S, we shall mean a differentiable map N: U → R3 which associates to each q ∈ U a unit normal vector N(q) ∈ R3 to S at q.

PROPOSITION 1. A regular surface S ⊂ R3 is orientable if and only if there exists a differentiable ﬁeld of unit normal vectors N: S → R3 on S.

Proof. IfS isorientable, itispossibletocoveritwithafamilyofcoordinate neighborhoods so that, in the intersection of any two of them, the change of coordinates has a positive Jacobian. At the points p = x(u,v) of each neighborhood, we deﬁne N(p) = N(u,v) by Eq. (1). N(p) is well deﬁned, sinceifp belongstotwocoordinateneighborhoods, withparameters(u,v)and (u,¯ v)¯ , the normal vector N(u,v) and N(u,¯ v)¯ coincide by Eq. (2). Moreover, by Eq. (1), the coordinates of N(u,v) in R3 are differentiable functions of (u,v), and thus the mapping N: S → R3 is differentiable, as desired.

On the other hand , let N: S → R3 be a differentiable ﬁeld of unit normal vectors, and consider a family of connected coordinate neighborhoods covering S. For the points p = x(u,v) of each coordinate neighborhood x(U), U ⊂ R2, it is possible, by the continuity of N and, if necessary, by interchanging u and v, to arrange that

N(p) =

xu ∧xv |xu ∧xv|

.

In fact, the inner product

?N(p),

xu ∧xv |xu ∧xv|

? = f (p) = ±1

[Page 124]

is a continuous function on x(U). Since x(U) is connected, the sign of f is constant. If f = −1, we interchange u and v in the parametrization, and the assertion follows.

Proceeding in this manner with all the coordinate neighborhoods, we have thatintheintersectionofanytwoofthem, say, x(u,v)andx¯(u,¯ v)¯ , theJacobian

∂(u,v) ∂(u,¯ v)¯

is certainly positive; otherwise, we would have

xu ∧xv |xu ∧xv|

= N(p) = −

x¯u¯ ∧x¯v¯ |¯xu¯ ∧x¯v¯|

= −N(p),

which is a contradiction. Hence, the given family of coordinate neighborhoods after undergoing certain interchanges of u and v satisﬁes the conditions of Def. 1, and S is, therefore, orientable. Q.E.D.

Remark. As the proof shows, we need only to require the existence of a continuous unit vector ﬁeld on S for S to be orientable. Such a vector ﬁeld will be automatically differentiable.

Example 3. We shall now describe an example of a nonorientable surface, the so-called Möbius strip. This surface is obtained (see Fig. 2-31) by considering the circle S1 given by x2 +y2 = 4 and the open segment AB given in the yz plane by y = 2, |z| < 1. We move the center C of AB along S1 and turn AB about C in the Cz plane in such a manner that when C has passed through an angle u, AB has rotated by an angle u/2. When c completes one trip around the circle, AB returns to its initial position, with its end points inverted.

- A A

z

y

x

u

2

u

- A
- B


0

2

C

- B


B π

|4|
|---|


π/4

###### Figure 2-31

[Page 125]

From the point of view of differentiability, it is as if we had identiﬁed the opposite (vertical) sides of a rectangle giving a twist to the rectangle so that each point of the side AB was identiﬁed with its symmetric point (Fig. 2-31).

It is geometrically evident that the Möbius strip M is a regular, nonorieotable surface. In fact, if M were orientable, there would exist a differentiable ﬁeld N: M → R3 of unit normal vectors. Taking these vectors along the circle x2 +y2 = 4 we see that after making one trip the vector N returns to its original position as −N, which is a contradiction.

We shall now give an analytic proof of the facts mentioned above. A system of coordinates x: U → M for the Möbius strip is given by

x(u,v) = ??

2−v sin

u 2?

sin u,

?

2−v sin

u 2?

cosu,v cos

u 2?

,

where 0 < u < 2π and −1 < v < 1. The corresponding coordinate neighborhood omits the points of the open interval u = 0. Then by taking the origin of the u’s at the x axis, we obtain another parametrization x¯(u,¯ v)¯ given by

- x = ?2−v¯ sin ?

π 4 +

u¯ 2??cosu,¯

- y = −?2−v¯ sin ?

π 4 +

u¯ 2??sin u,¯

- z = v¯ cos?


π 4 +

u¯ 2?,

whose coordinate neighborhood omits the interval u = π/2. These two coordinate neighborhoods cover the Möbius strip and can be used to show that it is a regular surface.

Observe that the intersection of the two coordinate neighborhoods is not connected but consists of two connected components:

- W1 = ?

x(u,v):

π 2

< u < 2π

?

,

- W2 = ?


x(u,v): 0 < u <

π 2 ?

. The change of coordinates is given by

- u¯ = u−

π 2

- v¯ = v


⎫ ⎬

⎭

in W1,

and

- u¯ =

3π 2 +u

- v¯ = −v


⎫ ⎬

⎭

in W2.

[Page 126]

It follows that

∂(u,¯ v)¯ ∂(u,v) = 1 > 0 in W1

and that

∂(u,¯ v)¯ ∂(u,v) = −1 < 0 in W2.

To show that the Möbius strip is nonorientable, we suppose that it is possible to deﬁne a differentiable ﬁeld of unit normal vectors N: M → R3. Interchanging u and v if necessary, we can assume that

N(p) =

xu ∧xv |xu ∧xv|

for any p in the coordinate neighborhood of x(u,v). Analogously, we may assume that

N(p) =

x¯u¯ ∧x¯v¯ |¯xu¯ ∧x¯v¯|

at all points of the coordinate neighborhood of x¯(u,¯ v)¯ . However, the Jacobian of the change of coordinates must be −1 in either W1 or W2 (depending on what changes of the type u → v,u¯ → v¯ has to be made). If p is a point of that component of the intersection, then N(p) = −N(p), which is a contradiction.

We have already seen that a surface which is the graph of a differentiable function is orientable. We shall now show that a surface which is the inverse image of a regular value of a differentiable function is also orientable. This is one of the reasons it is relatively difﬁcult to construct examples of nonorientable, regular surfaces in R3.

PROPOSITION 2. If a regular surface is given by S = {(x,y,z) ∈ R3; f(x,y,z) = a}, where f: U ⊂ R3 → R is differentiable and a is a regular value of f, then S is orientable.

Proof. Given a point (x0,y0,z0) = p ∈ S, consider the parametrized curve (x(t),y(t),z(t)), t ∈ I, on S passing through p for t = t0. Since the curve is on S, we have

f(x(t),y(t),z(t)) = a

for all t ∈ I. By differentiating both sides of this expression with respect to t, we see that at t = t0

fx(p)?

dx dt ?

t0

+fy(p)?

dy dt ?

t0

+fz(p)?

dz dt ?

t0

= 0.

[Page 127]

This shows that the tangent vector to the curve at t = t0 is perpendicular to the vector (fx,fy,fz) at p. Since the curve and the point are arbitrary, we conclude that

N(x,y,z) = ?

fx ?

fx2 +fy2 +fz2

,

fy ?

fx2 +fy2 +fz2

,

fz ?

fx2 +fy2 +fz2

?

is a differentiable ﬁeld of unit normal vectors on S. Together with Prop. 1, this implies that S is orientable as desired. Q.E.D.

A ﬁnal remark. Orientation is deﬁnitely not a local property of a regular surface. Locally, every regular surface is diffeomorphic to an open set in the plane, and hence orientable. Orientation is a global property, in the sense that it involves the whole surface. We shall have more to say about global properties later in this book (Chap. 5).

###### EXERCISES

- 1. Let S be a regular surface covered by coordinate neighborhoods V1and V2. Assume that V1 ∩V2 has two connected components, W1,W2, and that the Jacobian of the change of coordinates is positive in W1 and negative in W2. Prove that S is nonorientable.
- 2. Let S2 be an orientable regular surface and ϕ: S1 → S2 be a differentiable map which is a local diffeomorphism at every p ∈ S1. Prove that S1 is orientable.
- 3. Is it possible to give a meaning to the notion of area for a Möbius strip? If so, set up an integral to compute it.
- 4. Let S be an orientable surface and let {Uα} and {Vβ} be two families of

coordinate neighborhoods which cover S (that is,

?

Uα = S =

?

Vβ) and satisfytheconditionsofDef. 1(thatis, ineachofthefamilies, thecoordinate changes have positive Jacobian). We say that {Uα} and {Vβ} determine the same orientation of S if the union of the two families again satisﬁes the conditions of Def. 1.

Prove that a regular, connected, orientable surface can have only two distinct orientations.

- 5. Let ϕ: S1 → S2 be a diffeomorphism.


- a. Show that S1 is orientable if and only if S2 is orientable (thus, orientability is preserved by diffeomorphisms).
- b. Let S1 and S2 be orientable and oriented. Prove that the diffeomorphism ϕ induces an orientation in S2. Use the antipodal map of the sphere (Exercise 1, Sec. 2-3) to show that this orientation may be distinct


[Page 128]

(cf. Exercise 4) from the initial one (thus, orientation itself may not be preserved by diffeomorphisms; note, however, that if S1 and S2 are connected, a diffeomorphism either preserves or “reverses” the orientation).

- 6. Deﬁne the notion of orientation of a regular curve C ⊂ R3, and show that if C is connected, there exist at most two distinct orientations in the sense of Exercise 4 (actually there exist exactly two, but this is harder to prove).
- 7. Show that if a regular surface S contains an open set diffeomorphic to a Möbius strip, then S is nonorientable.


###### 2-7. A Characterization of Compact Orientable Surfaces†

The converse of Prop. 2 of Sec. 2-6, namely, that an orientable surface in R3 is the inverse image of a regular value of some differentiable function, is true and nontrivial to prove. Even in the particular case of compact surfaces (deﬁned in this section), the proof is instructive and offers an interesting example of a global theorem in differential geometry. This section will be dedicated entirely to the proof of this converse statement.

Let S ⊂ R3 be an orientable surface. The crucial point of the proof consists of showing that one may choose, on the normal line through p ∈ S, an open interval Ip around p of length, say, 2ǫp (ǫp varies with p) in such a way that if p ?= q ∈ S, then Ip ∩Iq = φ. Thus, the union

?

Ip, p ∈ S, constitutes an open set V of R3, which contains S and has the property that through each point of V there passes a unique normal line to S; V is then called a tubular neighborhood of S (Fig. 2-32).

V

S

q

Iq

є(p) p

Ip

є(q)

Figure 2-32. A tubular neighborhood.

Let us assume, for the moment, the existence of a tubular neighborhood V of an orientable surface S. We can then deﬁne a function g: V → R as follows: Fix an orientation for S. Observe that no two segments IP and Iq, p ?= q, of the tubular neighborhood V intersect. Thus, through each point P ∈ V there passes a unique normal line to S which meets S at a point p; by deﬁnition, g(P) is the distance from p to P, with a sign given by the

†This section may be omitted on a ﬁrst reading.

[Page 129]

directionoftheunitnormalvectoratp. Ifwecanprovethatg isadifferentiable function and that 0 is a regular value of g, we shall have that S = g−1(0), as we wished to prove.

We shall now start the proof of the existence of a tubular neighborhood of an orientable surface. We shall ﬁrst prove a local version of this fact; that is, we shall show that for each point p of a regular surface there exists a neighborhood of p which has a tubular neighborhood.

PROPOSITION 1. Let S be a regular surface and x: U → S be a parametrization of a neighborhood of a point p = x(u0,v0) ∈ S. Then there exists a neighborhood W ⊂ x(U) of p in S and a number ǫ > 0 such that the segments of the normal lines passing through points q ∈ W, with center at q and length 2ǫ, are disjoint (that is, W has a tubular neighborhood).

Proof. Consider the map F: U ×R → R3 given by

F(u,v;t) = x(u,v)+tN(u,v), (u,v) ∈ U, t ∈ R, where N(u,v) = (Nx,Ny,Nz) is the unit normal vector at

x(u,v) = (x(u,v),y(u,v),z(u,v)).

Geometrically, F maps the point (u,v;t) of the “cylinder” U ×R in the point of the normal line to S at a distance t from x(u,v). F is clearly differentiable and its Jacobian at t = 0 is given by

?

∂x

- ∂u

∂y ∂u

∂z ∂u

∂x

- ∂v


∂y ∂v

∂z ∂v

Nx Ny Nz ?

= |xu ∧xv| ?= 0.

By the inverse function theorem, there exists a parallelepiped in U ×R, say,

u0 −δ < u < u0 +δ, v0 −δ < v < v0 +δ, −ǫ < t < ǫ,

restricted to which F is one-to-one. But this means that in the image W by F of the rectangle

u0 −δ < u < u0 +δ, v0 −δ < v < v0 +δ

the segments of the normal lines with centers q ∈ W and of length < 2ǫ do not meet. Q.E.D.

At this point, it is convenient to observe the following. The fact that the function g: V → R, deﬁned above by assuming the existence of a tubular

[Page 130]

neighborhood V, is differentiable and has 0 as a regular value is a local fact and can be proved at once.

PROPOSITION 2. Assume the existence of a tubular neighborhood V ⊂ R3 of an orientable surface S ⊂ R3, and choose an orientation for S. Then the function g: V → R, deﬁned as the oriented distance from a point of V to the foot of the unique normal line passing through this point, is differentiable and has zero as a regular value.

Proof. Let us look again at the map F: U ×R → R3 deﬁned in Prop. 1, where we now assume that the parametrization x is compatible with the given orientation. Denoting by x,y,z the coordinates of F(u,v,t) = x(u,v)+ tN(u,v) we can write

F(u,v,t) = (x(u,v,t),y(u,v,t),z(u,v,t)).

Since the Jacobian ∂(x,y,z)/∂(u,v,t) is different from zero at t = 0, we can invert F in some parallelepiped Q,

u0 −δ < u < u0 +δ, v0 −δ < v < v0 +δ, −ǫ < t < ǫ, to obtain a differentiable map

F−1(x,y,z) = (u(x,y,z),v(x,y,z),t(x,y,z)),

where (x,y,z) ∈ F(Q) ⊂ V . But the restriction to F(Q) of the function g: V → R in the statement of Prop. 2 is precisely t = t(x,y,z). Thus, g is differentiable. Furthermore, 0 is a regular value of t; otherwise

∂t ∂x =

∂t ∂y =

∂t ∂z = 0

for some point where t = 0; hence, the differential dF−1 would be singular for t = 0, which is a contradiction. Q.E.D.

To pass from the local to the global, that is, to prove the existence of a tubularneighborhoodofanentireorientablesurface, weneedsometopological arguments.Weshallrestrictourselvestocompactsurfaces, whichweshallnow deﬁne.

Let A be a subset of R3. We say that p ∈ R3 is a limit point of A if every neighborhood of p in R3 contains a point of A distinct from p. A is said to be closed if it contains all its limit points. A is bounded if it is contained in some ball of R3. If A is closed and bounded, it is called a compact set.

Thesphereandthetorusarecompactsurfaces.Theparaboloidofrevolution z = x2 +y2, (x,y) ∈ R2, is a closed surface, but, being unbounded, it is not a compact surface. The disk x2 +y2 < 1 in the plane and the Möbius strip are bounded but not closed and therefore are noncompact.

[Page 131]

We shall need some properties of compact subsets of R3, which we shall now state. The distance between two points p,q ∈ R3 will be denoted by d(p,q).

###### PROPERTY 1 (Bolzano-Weierstrass). Let A ⊂ R3 be a compact set.

Then every inﬁnite subset of A has at least one limit point in A.

###### PROPERTY 2 (Heine-Borel). Let A ⊂ R3 be a compact set and {Uα} be

a family of open sets of A such that

?

α Uα ⊃ A. Then it is possible to choose a ﬁnite number Uk1,Uk2,...,Ukn of Uα such that

?

Uki ⊃ A, i = 1,...,n.

PROPERTY 3 (Lebesgue). Let A ⊂ R3 be a compact set and {Uα} a family of open sets of A such that

?

α Uα = A. Then there exists a number δ > 0 (the Lebesgue number of the family {Uα}) such that whenever two points p,q ∈ A are at a distance d(p,q) < δ then p and q belong to some Uα.

Properties 1 and 2 are usually proved in courses of advanced calculus. For completeness, we shall now prove Property 3. Later in this book (appendix to Chap. 5), we shall treat compact sets in Rn in a more systematic way and shall present proofs of Properties 1 and 2.

Proof of Property 3. Let us assume that there is no δ > 0 satisfying the conditions in the statement; that is, given 1/n there exist points pn and qn such that d(pn,qn) < 1/n but pn and qn do not belong to the same open set of the family {Uα}. Setting n = 1,2,..., we obtain two inﬁnite sets of points {pn} and {qn} which, by Property 1, have limit points p and q, respectively. Since d(pn,qn) < 1/n, we may choose these limit points in such a way that p = q. But p ∈ Uα for some α, because p ∈ A =

?

α Uα, and since Uα is an open set, there is an open ball Bǫ(p), with center in p, such that Bǫ(p) ⊂ Uα. Since p is a limit point of {pn} and {qn}, there exist, for n sufﬁciently large, points pn and qn in Bǫ(p) ⊂ Uα; that is, pn and qn belong to the same Uα, which is a contradiction. Q.E.D.

Using Properties 2 and 3, we shall now prove the existence of a tubular neighborhood of an orientable compact surface.

PROPOSITION 3. LetS ⊂ R3 bearegular, compact, orientablesurface. Then there exists a number ǫ > 0 such that whenever p,q ∈ S the segments of the normal lines of length 2ǫ, centered in p and q, are disjoint (that is, S has a tubular neighborhood).

Proof. By Prop. 1, for each p ∈ S there exists a neighborhood Wp and a number ǫp > 0 such that the proposition holds for points of Wp with ǫ = ǫp. Letting p run through S, we obtain a family {Wp} with

?

p∈S Wp = S. By compactness (Property 2), it is possible to choose a ﬁnite number of the Wp’s,

[Page 132]

say, W1,...,Wk (corresponding to ǫ1,...,ǫk) such that

?

Wi = S, i = 1,...,k. We shall show that the required ǫ is given by

ǫ < min ?ǫ1,...,ǫk,

δ 2?,

where δ is the Lebesgue number of the family {Wi} (Property 3).

In fact, let two points p,q ∈ S. If both belong to some Wi, i = 1,...,k, the segments of the normal lines with centers in p and q and length 2ǫ do not meet, since ǫ < ǫi. If p and q do not belong to the same Wi, then d(p,q) ≥ δ; were the segments of the normal lines, centered in p and q and of length 2ǫ, to meet at point Q ∈ R3, we would have

2ǫ ≥ d(p,Q)+d(Q,q) ≥ d(p,q) ≥ δ, which contradicts the deﬁnition of ǫ. Q.E.D.

Putting together Props. 1, 2, and 3, we obtain the following theorem, which is the main goal of this section.

THEOREM. Let S ⊂ R3 be a regular compact orientable surface. Then there exists a differentiable function g: V → R, deﬁned in an open set

- V ⊂ R3, with V ⊃ S (precisely a tubular neighborhood of S), which has zero as a regular value and is such that S = g−1(0).


- Remark 1. It is possible to prove the existence of a tubular neighborhood

of an orientable surface, even if the surface is not compact; the theorem is true, therefore, without the restriction of compactness. The proof is, however, more technical. In this general case, the ǫ(p) > 0 is not constant as in the compact case but may vary with p.

- Remark 2. It is possible to prove that a regular compact surface in R3 is


orientable; the hypothesis of orientability in the theorem (the compact case) is therefore unnecessary. A proof of this fact can be found in H. Samelson, “Orientability of Hypersurfaces in Rn,” Proc. A.M.S. 22 (1969), 301–302.

###### 2-8. A Geometric Deﬁnition of Area†

In this section we shall present a geometric justiﬁcation for the deﬁnition of area given in Sec. 2-5. More precisely, we shall give a geometric deﬁnition of area and shall prove that in the case of a bounded region of a regular surface such a deﬁnition leads to the formula given for the area in Sec. 2-5.

To deﬁne the area of a region R ⊂ S we shall start with a partition P of R into a ﬁnite number of regions Ri, that is, we write R =

?

i Ri, where the intersection of two such regions Ri is either empty or made up of boundary

†This section may be omitted on a ﬁrst reading.

[Page 133]

Ri

Ri

Ri N pi

S R

###### Figure 2-33

points of both regions (Fig. 2-33). The diameter of Ri is the supremum of the distances (in R3) of any two points in Ri; the largest diameter of the Ri’s of a given partition P is called the norm μ of P. If we now take a partition of each Ri, we obtain a second partition of R, which is said to reﬁne P.

Given a partition

R = ?

i

Ri

of R, we choose arbitrarily points pi ∈ Ri and project Ri onto the tangent plane at pi in the direction of the normal line at pi; this projection is denoted by R¯i and its area by A(R¯i). The sum

?

i A(R¯i) is an approximation of what we understand intuitively by the area of R.

If, by choosing partitions P1,...,Pn,... more and more reﬁned and such that the norm μn of Pn converges to zero, there exists a limit of

?

i A(R¯i) and this limit is independent of all choices, then we say that R has an area A(R) deﬁned by

A(R) = lim μn→0?

i

A(R¯i).

An instructive discussion of this deﬁnition can be found in R. Courant, Differential and Integral Calculus, Vol. II, Wiley-Interscience, New York, 1936, p. 311.

We shall show that a bounded region of a regular surface does have an area. We shall restrict ourselves to bounded regions contained in a coordinate neighborhood and shall obtain an expression for the area in terms of the coefﬁcients of the ﬁrst fundamental form in the corresponding coordinate system.

PROPOSITION. Let x: U → S be a coordinate system in a regular surface S and let R = x(Q) be a bounded region of S contained in x(U). Then R has an area given by

A(R) = ??

Q

|xu ∧xv|du dv.

[Page 134]

Proof. Consider a partition, R =

?

i Ri, of R. Since R is bounded and closed(hence, compact), wecanassumethatthepartitionissufﬁcientlyreﬁned sothatanytwonormallinesofRi areneverorthogonal. Infact, becausethenormal lines vary continuously in S, there exists for each p ∈ R a neighborhood of p in S where any two normals are never orthogonal; these neighborhoods constitute a family of open sets covering R, and considering a partition of R the norm of which is smaller than the Lebesgue number of the covering (Sec. 2-7, Property 3 of compact sets), we shall satisfy the required condition.

Fix a region Ri of the partition and choose a point pi ∈ Ri = x(Qi). We want to compute the area of the normal projection R¯i of Ri onto the tangent plane at pi. To do this, consider a new system of axes pix¯y¯z¯ in R3, obtained from Oxyz by a translation Opi, followed by a rotation which takes the z axis into the normal line at pi in such a way that both systems have the same orientation (Fig. 2-34). In the new axes, the parametrization can be written

x¯(u,v) = (x(u,v),¯ y(u,v),¯ z(u,v)),¯

where the explicit form of x¯(u,v) does not interest us; it is enough to know that the vector x¯(u,v) is obtained from the vector x(u,v) by a translation followed by an orthogonal linear map.

x

y

z

p

x

z

y

0

###### Figure 2-34

We observe that ∂(x,¯ y)/∂(u,v)¯ ?= 0 in Qi; otherwise, the z¯ component of some normal vector in Ri is zero and there are two orthogonal normal lines in Ri, a contradiction of our assumptions.

The expression of A(R¯i) is given by A(R¯i) = ??

R¯i

dx¯ dy.¯

Since ∂(x,¯ y)/∂(u,v)¯ ?= 0, we can consider the change of coordinates x¯ = x(u,v)¯ , y¯ = y(u,v)¯ and transform the above expression into

A(R¯i) = ??

Qi

∂(x,¯ y)¯ ∂(u,v)

du dv.

[Page 135]

We remark now that, at pi, the vectors x¯u and x¯v belong to the x¯y¯ plane; therefore,

∂z¯ ∂u =

∂z¯ ∂v = 0 at pi;

hence,

?

∂(x,¯ y)¯ ∂(u,v)? = ?

∂x¯ ∂u ∧

∂x¯ ∂v? at pi.

It follows that

?

∂(x,¯ y)¯ ∂(u,v)?−?

∂x¯ ∂u ∧

∂x¯ ∂v? = ǫi(u,v), (u,v) ∈ Qi,

where ǫi(u,v) is a continuous function in Qi with ǫi(x−1(pi)) = 0. Since the length of a vector is preserved by translations and orthogonal linear maps, we obtain

?

∂x ∂u ∧

∂x ∂v? = ?

∂x¯ ∂u ∧

∂x¯ ∂v? = ?

∂(x,¯ y)¯ ∂(u,v)?−ǫi(u,v).

Now let Mi and mi be the maximum and the minimum of the continuous function ǫi(u,v) in the compact region Qi; thus,

mi ≤ ?

∂(x,¯ y)¯ ∂(u,v)?−?

∂x ∂u ∧

∂x ∂v? ≤ Mi;

hence,

mi ??

Qi

du dv ≤ A(R¯i)−??

Qi

?

∂x ∂u ∧

∂x ∂v? du dv ≤ Mi ??

Qi

du dv.

Doing the same for all Ri, we obtain ?

i

miA(Qi) ≤ ?

i

A(R¯i)−??

Q

|xu ∧xv|du dv ≤ ?

i

MiA(Qi).

Now, reﬁne more and more the given partition in such a way that the norm μ → 0. Then Mi → mi. Therefore, there exists the limit of

?

iA(R¯i), given by

A(R) = ??

Q

?

∂x ∂u ∧

∂x ∂v? du dv,

which is clearly independent of the choice of the partitions and of the point pi in each partition. Q.E.D.

[Page 136]

###### Appendix A Brief Review of Continuity and Differentiability

Rn will denote the set of n-tuples (x1,...,xn) of real numbers. Although we use only the cases R1 = R,R2, and R3, the more general notion of Rn uniﬁes the deﬁnitions and brings in no additional difﬁculties; the reader may think in R2 or R3, if he wishes so. In these particular cases, we shall use the following more traditional notation: x or t for R, (x,y) or (u,v) for R2, and (x,y,z) for R3.

###### A. Continuity in Rn

We start by making precise the notion of a point being ǫ-close to a given point p0 ∈ Rn.

Aball (or open ball) in Rn with center p0 = (x10,...,xn0) and radius ǫ > 0 is the set

Bǫ(p0) = {(x1,...,xn) ∈ Rn;(x1 −x10)2 +···+(xn −xn0)2 < ǫ2}.

Thus, in R,Bǫ(p0) is an open interval with center p0 and length 2ǫ; in R2, Bǫ(p0) is the interior of a disk with center p0 and radius ǫ; in R3, Bǫ(p0) is the interior of a region bounded by a sphere of center p0 and radius ǫ (see Fig. A2-1).

A set U ⊂ Rn is an open set if for each p ∈ U there is a ball Bǫ(p) ⊂ U; intuitively this means that points in U are entirely surrounded by points of U, or that points sufﬁciently close to points of U still belong to U.

For instance, the set {(x,y) ∈ R2;a < x < b,c < y < d}

###### 120

[Page 137]

P0

R

P0

є P0

є

є

R2

R3

###### Figure A2-1

is easily seen to be open in R2. However, if one of the strict inequalities, say x < b, is replaced by x ≤ b, the set is no longer open; no ball with center at the point (b,(d +c)/2), which belongs to the set, can be contained in the set (Fig. A2-2).

It is convenient to say that an open set in Rn containing a point p ∈ Rn is

a neighborhood of p. From now on, U ⊂ Rn will denote an open set in Rn. We recall that a real function f : U ⊂ R → R of a real variable is contin-

uous at x0 ∈ U if given an ǫ > 0 there exists a δ > 0 such that if |x −x0| < δ, then

d

c

d

c

a b a b

###### Figure A2-2

[Page 138]

|f (x)−f (x0)| < ǫ.

Similarly, a real function f : U ⊂ R2 → R of two real variables is continuous at (x0,y0) ∈ U if given an ǫ > 0 there exists a δ > 0 such that if (x −x0)2 +(y −y0)2 < δ2, then

|f (x,y)−f (x0,y0)| < ǫ.

The notion of ball uniﬁes these deﬁnitions as particular cases of the following general concept:

A map F: U ⊂ Rn → Rm is continuous at p ∈ U if given ǫ > 0, there exists a δ > 0 such that

F(Bδ(p)) ⊂ Bǫ(F(p)).

In other words, F is continuous at p if points arbitrarily close to F(p) are images of points sufﬁciently close to p. It is easily seen that in the particular cases of n = 1,2 and m = 1, this agrees with the previous deﬁnitions. We say that F is continuous in U if F is continuous for all p ∈ U (Fig. A2-3).

R3

R2

F

p

F(Bδ(p)) B¨(F(p))

Bδ(p)

F(p)

###### Figure A2-3

Given a map F: U ⊂ Rn → Rm, we can determine m functions of n variables as follows. Let p = (x1,...,xn) ∈ U and f (p) = (y1,...,ym). Then we can write

y1 = f1(x1,...,xn),...,ym = fm(x1,...,xn). The functions fi: U → R, i = 1,...,m, are the component functions of F.

[Page 139]

Example 1 (Symmetry). Let F: R3 → R3 be the map which assigns to each p ∈ R3 the point which is symmetric to p with respect to the origin O ∈ R3. Then F(p) = −p, or

F(x,y,z) = (−x,−y,−z), and the component functions of F are

f1(x,y,z) = −x, f2(x,y,z) = −y, f3(x,y,z) = −z.

Example 2 (Inversion). LetF:R2 −{(0,0)} → R2 bedeﬁnedasfollows. Denote by |p| the distance to the origin (0,0) = O of a point p ∈ R2. By deﬁnition, F(p), p ?= 0, belongs to the half-line Op and is such that |F(p)|· |p| = 1. Thus, F(p) = p/|p|2, or

F(x,y) = ?

x x2 +y2

,

y

x2 +y2?, (x,y) ?= (0,0), and the component functions of F are

f1(x,y) =

x x2 +y2

, f2(x,y) =

y x2 +y2

.

Example 3 (Projection). Let π: R3 → R2 be the projection π(x,y,z) = (x,y). Then f1(x,y,z) = x,f2(x,y,z) = y.

The following proposition shows that the continuity of the map F is equivalent to the continuity of its component functions.

PROPOSITION 1. F: U ⊂ Rn → Rm is continuous if and only if each component function fi: U ⊂ Rn → R, i = 1,...,m, is continuous.

Proof. Assume that F is continuous at p ∈ U. Then given ǫ > 0, there exists δ > 0 such that F(Bδ(p)) ⊂ Bǫ(F(p)). Thus, if q ∈ Bδ(p), then

F(q) ∈ Bǫ(F(p)), that is,

(f1(q)−f1(p))2 +···+(fm(q)−fm(p))2 < ǫ2,

which implies that, for each i = 1,...,m, |fi(q)−fi(p)| < ǫ. Therefore, givenǫ > 0thereexistsδ > 0suchthatifq ∈ Bδ(p), then|fi(q)−fi(p)| < ǫ. Hence, each fi is continuous at p.

Conversely, let fi, i = 1,...,m, be continuous at p. Then given ǫ > 0 there exists δi > 0 such that if q ∈ Bδi(p), then |fi(q)−fi(p)| < ǫ/√m. Set δ < min δi and let q ∈ Bδ(p). Then

(f1(q)−f1(p))2 +···+(fm(q)−fm(p))2 < ǫ2, and hence, the continuity of F at p. Q.E.D.

It follows that the maps in Examples 1, 2, and 3 are continuous.

[Page 140]

Example 4. Let F: U ⊂ R → Rm. Then

F(t) = (x1(t),...,xm(t)), t ∈ U.

This is usually called a vector-valued function, and the component functions of F are the components of the vector F(t) ∈ Rm. When F is continuous, or, equivalently, the functions xi(t), i = 1,...,m, are continuous, we say that F is a continuous curve in Rm.

In most applications, it is convenient to express the continuity in terms of neighborhoods instead of balls.

PROPOSITION 2. A map F: U ⊂ Rn → Rm is continuous at p ∈ U if and only if, given a neighborhood V of F(p) in Rm there exists a neighborhood

- W of p in Rn such that F(W) ⊂ V.


Proof. Assume that F is continuous at p. Since V is an open set containing F(p), it contains a ball Bǫ(F(p)) for some ǫ > 0. By continuity, there exists a ball Bδ(p) = W such that

F(W) = F(Bδ(p)) ⊂ Bǫ(F(p)) ⊂ V, and this proves that the condition is necessary.

Conversely, assume that the condition holds. Let ε > 0 be given and set V = Bǫ(F(p)). By hypothesis, there exists a neighborhood W of p in Rn such that F(W) ⊂ V . Since W is open, there exists a ball Bδ(p) ⊂ W. Thus,

F(Bδ(p)) ⊂ F(W) ⊂ V = Bǫ(F(p)), and hence the continuity of F at p. Q.E.D.

The composition of continuous maps yields a continuous map. More precisely, we have the following proposition.

PROPOSITION 3. Let F: U ⊂ Rn → Rm and G: V ⊂ Rm → Rk be continuous maps, where U and V are open set such that F(U) ⊂ V. Then G ◦F: U ⊂ Rn → Rk is a continuous map.

Proof. Let p ∈ U and let W1 be a neighborhood of G◦F(p) in Rk. By continuity of G, there is a neighborhood Q of F(p) in Rm with G(Q) ⊂ W1. By continuity of F, there is a neighborhood W2 of (p) in Rn with F(W2) ⊂ Q. Thus,

G◦F(W2) ⊂ G(Q) ⊂ W1, and hence the continuity of G◦F. Q.E.D.

It is often necessary to deal with maps deﬁned on arbitrary (not necessarily open)setsofRn.Toextendthepreviousideastothissituation, weshallproceed

- as follows.


[Page 141]

Let F: A ⊂ Rn → Rm be a map, where A is an arbitrary set in Rn. We say that F is continuous at p ∈ A if given a neighborhood V of F(p) in Rm, there exists a neighborhood W of p in Rn such that F(W ∩A) ⊂ V . For this reason, it is convenient to call W ∩A a neighborhood of p in A. The set B ⊂ A is open if, for each point p ∈ B, there exists a neighborhood of p in A entirely contained in B.

W W ∩ A

W ∩ A

A

A

W

Figure A2-4

Example 5. Let

E = ?(x,y,z) ∈ R3;

x2 a2 +

y2 b2 +

z2 c2 = 1?

be an ellipsoid, and let π: R3 → R2 be the projection of Example 3. Then the restriction of π to E is a continuous map from E to R2.

We say that a continuous map F: A ⊂ Rn → Rn is a homeomorphism onto F(A) if F is one-to-one and the inverse F−1: F(A) ⊂ Rn → Rn is continuous. In this case A and F(A) are homeomorphic sets.

Example 6. Let F: R3 → R3 be given by

F(x,y,z) = (xa,yb,zc). F is clearly continuous, and the restriction of F to the sphere S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1}

is a continuous map F˜: S2 → R3. Observe that F(S˜ 2) = E, where E is the ellipsoid of Example 5. It is also clear that F is one-to-one and that

F−1(x,y,z) = ?x a

,

y b

,

z c?

.

Thus, F˜−1 = F−1|E is continuous. Therefore, F˜ is a homeomorphism of the sphere S2 onto the ellipsoid E.

[Page 142]

Finally, we want to describe two properties of real continuous functions deﬁned on a closed interval [a,b],

[a,b] = {x ∈ R;a ≤ x ≤ b}

(Props. 4 and 5 below), and an important property of the closed interval [a,b] itself. They will be used repeatedly in this book.

- PROPOSITION 4 (The Intermediate Value Theorem). Letf:[a,b] → R be a continuous function deﬁned on the closed interval [a,b]. Assume that f(a) and f(b) have opposite signs; that is, f(a)f(b) < 0. Then there exists a point c ∈ (a,b) such that f(c) = 0.
- PROPOSITION 5. Let f: [a,b] be a continuous function deﬁned in the closed interval [a,b]. Then f reaches its maximum and its minimum in [a,b]; that is, there exist points x1, x2 ∈ [a,b] such that f(x1) < f(x) < f(x2) for all x ∈ [a,b].
- PROPOSITION 6 (Heine-Borel). Let [a,b] be a closed interval and let Iα, α ∈ A, be a collection of open intervals such that


?

α Iα ⊃ [a,b]. Then it is possible to choose a ﬁnite number Ik1,Ik2,...,Ikn of Iα such that

?

ki Iki ⊃ [a,b], i = 1,...,n.

These propositions are standard theorems in courses on advanced calculus, and we shall not prove them here. However, proofs are provided in the appendix to Chap. 5 (Props. 8, 13, and 11, respectively).

###### B. Differentiability in Rn

Let f : U ⊂ R → R. The derivative f′(x0) of f at x0 ∈ U is the limit (when it exists)

f ′(x0) = lim h→0

f (x0 +h)−f (x0) h

, x0 +h ∈ U.

Whenf hasderivativesatallpointsofaneighborhoodV ofx0, wecanconsider the derivative of f′: V → R at x0, which is called the second derivative f ′′(x0) of f at x0, and so forth. f is differentiable at x0 if it has continuous derivatives of all orders at x0. f is differentiable in U if it is differentiable at all points in U.

Remark. We use the word differentiable for what is sometimes called inﬁnitely differentiable (or of class C∞). Our usage should not be confused with the usage of elementary calculus, where a function is called differentiable if its ﬁrst derivative exists.

[Page 143]

Let F: U ⊂ R2 → R. The partial derivative of f with respect to x at (x0,y0) ∈ U, denoted by (∂f/∂x)(x0,y0), is (when it exists) the derivative at x0 of the function of one variable: x → f (x,y0). Similarly, the partial derivative with respect to y at (x0,y0), (∂f/∂y)(x0,y0), is deﬁned as the derivative at y0 of y → f (x0,y). When f has partial derivatives at all points ofaneighborhoodV of(x0,y0), wecanconsiderthesecondpartialderivatives at (x0,y0):

∂

- ∂x ?

∂f ∂x ? =

∂2f ∂x2

,

∂ ∂x ?

∂f ∂y ? =

∂2f ∂x∂y

, ∂

- ∂y ?


∂f ∂x ? =

∂2f ∂y∂x

,

∂ ∂y ?

∂f ∂y ? =

∂2f ∂y2

,

and so forth. f is differentiable at (x0,y0) if it has continuous partial derivatives of all orders at (x0,y0). f is differentiable in U if it is differentiable at all points of U. We sometimes denote partial derivatives by

∂f ∂x = fx,

∂f ∂y = fy,

∂2f ∂x2 = fxx,

∂2f ∂x∂y = fxy,

∂2f ∂y2 = fyy.

It is an important fact that when f is differentiable the partial derivatives of f are independent of the order in which they are performed; that is,

∂2f ∂x∂y =

∂2f ∂y∂x

,

∂3f ∂2x∂y =

∂3f ∂x∂y∂x

, etc.

The deﬁnitions of partial derivatives and differentiability are easily

extendedtofunctionsf :U ⊂ Rn → R. Forinstance, (∂f/∂x3)(x10,x20,...,xn0) is the derivative of the function of one variable

x3 → f (x10,x20,x3,x40,...,xn0).

A further important fact is that partial derivatives obey the so-called chain rule. For instance, if x = x(u,v), y = y(u,v), z = z(u,v) are real differentiablefunctionsinU ⊂ R2 andf (x,y,z)isarealdifferentiablefunctioninR3, then the composition f(x(u,v),y(u,v),z(u,v)) is a differentiable function in U, and the partial derivative of f with respect to, say, u is given by

∂f ∂u =

∂f ∂x

∂x ∂u +

∂f ∂y

∂y ∂u +

∂f ∂z

∂z ∂u

.

[Page 144]

We are now interested in extending the notion of differentiability to maps F: U ⊂ Rn → Rm. We say that F is differentiable at p ∈ U if its component functions are differentiable at p; that is, by writing

F(x1,...,xn) = (f1(x1,...,xn),...,fm(x1,...,xn)), thefunctionsfi, i = 1,...,m, havecontinuouspartialderivativesofallorders

- at p. F is differentiable in U if it is differentiable at all points in U. For the case m = 1, this repeats the previous deﬁnition. For the case n = 1,


we obtain the notion of a (parametrized) differentiable curve in Rm. In Chap. 1, we have already seen such an object in R3. For our purposes, we need to extend the deﬁnition of tangent vector of Chap. 1 to the present situation. A tangent vector to a map α: U ⊂ R → Rm at t0 ∈ U is the vector in Rm

α′(t0) = (x1′(t0),...,xm′ (t0)). Example 7. Let F: U ⊂ R2 → R3 be given by

F(u,v) = (cosucosv,cosusin v,cos2 v), (u,v) ∈ U. The component functions of F, namely,

f1(u,v) = cosucosv, f2(u,v) = cosusin v, f3(u,v) = cos2 v

have continuous partial derivatives of all orders in U. Thus, F is differentiable in U.

Example 8. Let α: U ⊂ R → R4 be given by

α(t) = (t4,t3,t2,t), t ∈ U.

Then α is a differentiable curve in R4, and the tangent vector to α at t is α′(t) = (4t3,3t2,2t,1).

Example 9. Given a vector w ∈ Rm and a point p0 ∈ U ⊂ Rm, we can alwaysﬁndadifferentiablecurveα:(−ǫ,ǫ) → U withα(0) = p0 andα′(0) = w. Simply deﬁne α(t) = p0 +tw, t ∈ (−ǫ,ǫ). By writing p0 = (x10,...,xm0) and w = (w1,...,wm), the component functions of α are xi(t) = xi0 +twi, i = 1,...,m. Thus, α is differentiable, α(0) = p0 and

α′(0) = (x1′(0),...,xm′ (0)) = (w1,...,wm) = w.

We shall now introduce the concept of differential of a differentiable map. It will play an important role in this book.

DEFINITION 1. Let F: U ⊂ Rn → Rm be a differentiable map. To each p ∈ U we associate a linear map dFp: Rn → Rm which is called the differential of F at p and is deﬁned as follows. Let w ∈ Rn and let α: (−ǫ,ǫ) → U

[Page 145]

be a differentiable curve such that α(0) = p, α′(0) = w. By the chain rule, the curve β = F◦α: (−ǫ,ǫ) → Rm is also differentiable. Then (Fig. A2-5)

dFp(w) = β′(0).

u

u

p

α w

0

F

F ◦ α = β

y

z

dFp(w)

F(p)

x

є

–є

###### Figure A2-5

PROPOSITION 7. The above deﬁnition of dFp does not depend on the choice of the curve which passes through p with tangent vector w, and dFp is, in fact, a linear map.

Proof. To simplify notation, we work with the case F: U ⊂ R2 → R3. Let (u,v) be coordinates in R2 and (x,y,z) be coordinates in R3. Let e1 = (1,0), e2 = (0,1) be the canonical basis in R2 and f1 = (1,0,0), f2 = (0,1,0), f3 = (0,0,1) be the canonical basis in R3. Then we can write α(t) = (u(t),v(t)), t ∈ (−ǫ,ǫ),

α′(0) = w = u′(0)e1 +v′(0)e2,

F(u,v) = (x(u,v),y(u,v),z(u,v)), and

β(t) = F ◦α(t) = (x(u(t),v(t)),y(u(t),v(t)),z(u(t),v(t))).

[Page 146]

Thus, using the chain rule and taking the derivatives at t = 0, we obtain

β′(0) = ?

∂x ∂u

du dt +

∂x ∂v

dv dt ?f1 +?

∂y ∂u

du dt +

∂y ∂v

dv dt ?f2

+?

∂z ∂u

du dt +

∂z ∂v

dv dt ?f3

=

⎛

⎜ ⎝

- ∂x ∂u

∂x ∂v

- ∂y ∂u

∂y ∂v

- ∂z ∂u


∂z ∂v

⎞

⎟ ⎠

⎛

⎜ ⎝

- du dt

- dv dt


⎞

⎟ ⎠

= dFp(w).

This shows that dFp is represented, in the canonical bases of R2 and R3, by a matrix which depends only on the partial derivatives at p of the component functions x,y,z of F. Thus, dFp is a linear map, and clearly dFp(w) does not depend on the choice of α.

The reader will have no trouble in extending this argument to the more general situation. Q.E.D.

The matrix of dFp: Rn → Rm in the canonical bases of Rn and Rm, that is, the matrix (∂fi/∂xj), i = 1,...,m, j = 1,...,n, is called the Jacobian matrix of F at p. When n = m, this is a square matrix and its determinant is called the Jacobian determinant; it is usual to denote it by

det ?

∂fi ∂xj ? =

∂(f1,...,fn) ∂(x1,...,xn)

.

Remark. There is no agreement in the literature regarding the notation for the differential. It is also of common usage to call dFp the derivative of F at p and to denote it by F′(p).

Example 10. Let F: R2 → R2 be given by

F(x,y) = (x2 −y2,2xy), (x,y) ∈ R2. F is easily seen to be differentiable, and its differential dFp at p = (x,y) is

dFp = ?

- 2x −2y
- 2y 2x


?.

For instance, dF(1,1)(2,3) = (−2,10).

One of the advantages of the notion of differential of a map is that it allows us to express many facts of calculus in a geometric language. Consider,

[Page 147]

for instance, the following situation: Let F: U ⊂ R2 →R3, G: V ⊂ R3 →R2 be differentiable maps, where U and V are open sets such that F(U) ⊂ V . Let us agree on the following set of coordinates,

U ⊂ R2 −−−−F → V ⊂ R3 −−−−G → R2 (u,v) (x,y,z) (ξ,η)

and let us write

- F(u,v) = (x(u,v),y(u,v),z(u,v)),
- G(x,y,z) = (ξ(x,y,z),η(x,y,z)).


Then

G◦F(u,v) = (ξ(x(u,v),y(u,v),z(u,v)),η(x(u,v),y(u,v),z(u,v))),

and, by the chain rule, we can say that G◦F is differentiable and compute the partial derivatives of its component functions. For instance,

∂ξ ∂u =

∂ξ ∂x

∂x ∂u +

∂ξ ∂y

∂y ∂u +

∂ξ ∂z

∂z ∂u

.

Now, a simple way of expressing the above situation is by using the following general fact.

PROPOSITION 8 (The Chain Rule for Maps). Let F: U ⊂ Rn → Rm and G: V ⊂ Rm → Rk be differentiable maps, where U and V are open sets such that F(U) ⊂ V. Then G ◦F: U → Rk is a differentiable map, and

d(G ◦F)p = dGF(p) ◦dFp, p ∈ U.

Proof. The fact that G◦F is differentiable is a consequence of the chain rule for functions. Now, let w1 ∈ Rn be given and let us consider a curve α: (−ǫ2,ǫ2) → U, with α(0) = p, α′(0) = w1. Set dFp(w1) = w2 and observe that dGF(p)(w2) = (d/dt)(G◦F ◦α)|t=0. Then

d(G◦F)p(w1) =

d dt

(G◦F ◦α)t=0 = dGF(p)(w2) = dGF(p) ◦dFp(w1).

###### Q.E.D.

Notice that, for the particular situation we were considering before, the relation d(G◦F)p = dGF(p) ◦dFp is equivalent to the following product of Jacobian matrices,

[Page 148]

⎛

⎜ ⎝

∂ξ ∂u

∂ξ ∂v

∂η ∂u

∂η ∂v

⎞

⎟ ⎠

=

⎛

⎜ ⎝

∂ξ ∂x

∂ξ ∂y

∂ξ ∂z

∂η ∂x

∂η ∂y

∂η ∂z

⎞

⎟ ⎠

⎛

⎜ ⎝

- ∂x ∂u

∂x ∂v

- ∂y ∂u

∂y ∂v

- ∂z ∂u


∂z ∂v

⎞

⎟ ⎠

,

whichcontainstheexpressionsofallpartialderivatives∂ξ/∂u, ∂ξ/∂v, ∂η/∂u, ∂η/∂v. Thus, thesimpleexpressionofthechainruleformapsembodiesagreat deal of information on the partial derivatives of their component functions.

An important property of a differentiable function f : (a,b) ⊂ R → R deﬁned in an open interval (a,b) is that if f ′(x) ≡ 0 on (a,b), then f is constant on (a,b). This generalizes for differentiable functions of several variables as follows.

We say that an open set U ⊂ Rn is connected if give two points p,q ∈ U thereexistsacontinuousmapα:[a,b] → U suchthatα(a) = p andα(b) = q. This means that two points of U can be joined by a continuous curve in U or that U is made up of one single “piece.”

PROPOSITION 9. Let f: U ⊂ Rn → R be a differentiable function deﬁned on a connected open subset U of Rn. Assume that dfp: Rn → R is zero at every point p ∈ U. Then f is constant on U.

Proof. Let p ∈ U and let Bδ(p) ⊂ U be an open ball around p and contained in U. Any point q ∈ Bǫ(p) can be joined to p by the “radial” segment β: [0,1] → U, where β(t) = tq +(1−t)p, t ∈ [0,1] (Fig. A2-6). Since U is open, we can extend β to (0−ǫ,1+ǫ). Now, f ◦β: (0−ǫ,1+ǫ) → R is a function deﬁned in an open interval, and

d(f ◦β)t = (df ◦dβ)t = 0,

a

δ p

q

Bδ( p)

r

b

α

U

###### Figure A2-6

[Page 149]

since df ≡ 0. Thus,

d dt

(f ◦β) = 0

for all t ∈ (0−ǫ,1+ǫ), and hence (f ◦β) = const. This means that f (β(0)) = f (p) = f (β(1)) = f (q); that is, f is constant on Bδ(p).

Thus, the proposition is proved locally; that is, each point of U has a neighborhood such that f is constant on that neighborhood. Notice that so far we have not used the connectedness of U. We shall need it now to show that these constants are all the same.

Let r be an arbitrary point of U. Since U is connected, there exists a continuous curve α: [a,b] → U, with α(a) = p, α(b) = r. The function f ◦ α: [a,b] → R is continuous in [a,b]. By the ﬁrst part of the proof, for each

- t ∈ [a,b], there exists an interval It, open in [a,b], such that f ◦α is constant


on It. Since

?

t It = [a,b], we can apply the Heine-Borel theorem (Prop. ?6). Thus, we can choose a ﬁnite number I1,...,Ik of the intervals It so that

i Ii = [a,b], i = 1,...,k. We can assume, by renumbering the intervals, if necessary, that two consecutive intervals overlap. Thus, f ◦α is constant in the union of two consecutive intervals. It follows that f is constant on [a,b]; that is,

f (α(a)) = f (p) = f (α(b)) = f (r). Since r is arbitrary, f is constant on U. Q.E.D.

One of the most important theorems of differential calculus is the so-called inverse function theorem, which, in the present notation, says the following. (Recall that a linear map A is an isomorphism if the matrix of A is invertible.)

INVERSE FUNCTION THEOREM. Let F: U ⊂ Rn → Rn be a differentiable mapping and suppose that at p ∈ U the differential dFp: Rn → Rn is an isomorphism. Then there exists a neighborhood V of p in U and a neighborhood W of F(p) in Rn such that F: V → W has a differentiable inverse F−1: W → V .

A differentiable mapping F: V ⊂ Rn → W ⊂ Rn, where V and W are open sets, is called a diffeomorphism of V with W if F has a differentiable inverse. Theinversefunctiontheoremassertsthatifatapointp ∈ U thedifferential dFp is an isomorphism, then F is a diffeomorphism in a neighborhood of p. In other words, an assertion about the differential of F at a point implies a similar assertion about the behavior of F in a neighborhood of the point.

This theorem will be used repeatedly in this book. A proof can be found, for instance, in Buck, Advanced Calculus, p. 285.

Example 11. Let F: R2 → R2 be given by

F(x,y) = (ex cosy,ex sin y), (x,y) ∈ R2.

[Page 150]

The component functions of F, namely, u(x,y) = ex cosy, v(x,y) = ex sin y, have continuous partial derivatives of all orders. Thus, F is differentiable.

It is instructive to see, geometrically, how F transforms curves of the xy plane. For instance, the vertical line x = x0 is mapped into the circle

- u = ex


0 cosy, v = ex

0 sin y of radius ex

0, and the horizontal line y = y0 is mapped into the half-line u = ex cosy0, v = ex sin y0 with slope tan y0. It follows that (Fig. A2-7)

y

0

x = x0

y = y0 y0

ex0

u

v

0

dF (x

0,y0)(1,0)

x

(x0,y0) (1,0)

(0,1)

###### Figure A2-7

dF(x0,y0)(1,0) =

d dx

(ex cosy0,ex sin y0)|x=x0

= (ex0 cosy0,ex0 sin y0), dF(x0,y0)(0,1) =

d dy

(ex0 cosy,ex0 sin y)|y=y0

= (−ex0 sin y0,ex0 cosy0). This can be most easily checked by computing the Jacobian matrix of F,

dF(x,y) =

⎛ ⎜ ⎝

- ∂u ∂x

∂u ∂y

- ∂v ∂x


∂v ∂y

⎞ ⎟ ⎠ =

⎛ ⎜ ⎝

ex cosy −ex sin y

ex sin y ex cosy

⎞ ⎟ ⎠,

and applying it to the vectors (1, 0) and (0, 1) at (x0,y0).

We notice that the Jacobian determinant det(dF(x,y)) = ex ?= 0, and thus dFp is nonsingular for all p = (x,y) ∈ R2 (this is also clear from the previous geometric considerations). Therefore, we can apply the inverse function theorem to conclude that F is locally a diffeomorphism.

[Page 151]

Observe that F(x,y) = F(x,y +2π). Thus, F is not one-to-one and has no global inverse. For each p ∈ R2, the inverse function theorem gives neighborhoods V of p and W of F(p) so that the restriction F: V → W is a diffeomorphism. In our case, V may be taken as the strip {−∞ < x < ∞,0 <

- y < 2π} and W as R2 −{(0,0)}. However, as the example shows, even if the conditionsofthetheoremaresatisﬁedeverywhereandthedomainofdeﬁnition of F is very simple, a global inverse of F may fail to exist.


[Page 152]

3 The Geometry of the

Gauss Map

###### 3-1. Introduction

As we have seen in Chap. 1, the consideration of the rate of change of the tangent line to a curve C led us to an important geometric entity, namely, the curvature of C. In this chapter we shall extend this idea to regular surfaces; that is, we shall try to measure how rapidly a surface S pulls away from the tangent plane Tp(S) in a neighborhood of a point p ∈ S. This is equivalent to measuring the rate of change at p of a unit normal vector ﬁeld N on a neighborhood of p. As we shall see shortly, this rate of change is given by a linear map on Tp(S) which happens to be self-adjoint (see the appendix to Chap. 3). A surprisingly large number of local properties of S at p can be derived from the study of this linear map.

In Sec. 3-2, we shall introduce the relevant deﬁnitions (the Gauss map, principal curvatures and principal directions, Gaussian and mean curvatures, etc.) without using local coordinates. In this way, the geometric content of the deﬁnitions is clearly brought up. However, for computational as well as for theoreticalpurposes, itisimportanttoexpressallconceptsinlocalcoordinates. This is taken up in Sec. 3-3.

Sections 3-2 and 3-3 contain most of the material of Chap. 3 that will be used in the remaining parts of this book. The few exceptions will be explicitly pointed out. For completeness, we have proved the main properties of selfadjoint linear maps in the appendix to Chap. 3. Furthermore, for those who have omitted Sec. 2-6, we have included a brief review of orientation for surfaces at the beginning of Sec. 3-2.

###### 136

[Page 153]

Section 3-4 contains a proof of the fact that at each point of a regular surface there exists an orthogonal parametrization, that is, a parametrization such that its coordinate curves meet orthogonally. The techniques used here are interesting in their own right and yield further results. However, for a short course it might be convenient to assume these results and omit the section.

In Sec. 3-5 we shall take up two interesting special cases of surfaces, namely, the ruled surfaces and the minimal surfaces. They are treated independently so that one (or both) of them can be omitted on a ﬁrst reading.

###### 3-2. The Deﬁnition of the Gauss Map and Its Fundamental Properties

We shall begin by brieﬂy reviewing the notion of orientation for surfaces.

As we have seen in Sec. 2-4, given a parametrization x: U ⊂ R2 → S of a regular surface S at a point p ∈ S, we can choose a unit normal vector at each point of x(U) by the rule

N(q) =

xu ∧xv |xu ∧xv|

(q), q ∈ x(U).

Thus, we have a differentiable map N: x(U) → R3 that associates to each q ∈ x(U) a unit normal vector N(q).

More generally, if V ⊂ S is an open set in S and N: V → R3 is a differentiable map which associates to each q ∈ V a unit normal vector at q, we say that N is a differentiable ﬁeld of unit normal vectors on V.

It is a striking fact that not all surfaces admit a differentiable ﬁeld of unit normal vectors deﬁned on the whole surface. For instance, on the Möbius strip of Fig. 3-1 one cannot deﬁne such a ﬁeld. This can be seen intuitively by

Figure 3-1. The Möbius strip.

[Page 154]

going around once along the middle circle of the ﬁgure: After one turn, the vector ﬁeld N would come back as −N, a contradiction to the continuity of N. Intuitively, one cannot, on the Möbius strip, make a consistent choice of a deﬁnite “side”; moving around the surface, we can go continuously to the “other side” without leaving the surface.

We shall say that a regular surface is orientable if it admits a differentiable ﬁeld of unit normal vectors deﬁned on the whole surface; the choice of such a ﬁeld N is called an orientation of S.

For instance, the Möbius strip referred to above is not an orientable surface. Of course, every surface covered by a single coordinate system (for instance, surfaces represented by graphs of differentiable functions) is trivially orientable. Thus, every surface is locally orientable, and orientation is deﬁnitely a global property in the sense that it involves the whole surface.

An orientation N on S induces an orientation on each tangent space Tp(S), p ∈ S, as follows. Deﬁne a basis {v,w} ⊂ Tp(S) to be positive if ?v ∧w,N? is positive. It is easily seen that the set of all positive bases of Tp(S) is an orientation for Tp(S) (cf. Sec. 1-4).

Further details on the notion of orientation are given in Sec. 2-6. However, for the purpose of Chaps. 3 and 4, the present description will sufﬁce.

Throughout this chapter, S will denote a regular orientable surface in which an orientation (i.e., a differentiable ﬁeld of unit normal vectors N) has been chosen; this will be simply called a surface S with an orientation N.

DEFINITION 1. Let S ⊂ R3 be a surface with an orientation N. The map N: S → R3 takes its values in the unit sphere

S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1}

The map N: S → S2, thus deﬁned, is called the Gauss map of S (Fig. 3-2).†

It is straightforward to verify that the Gauss map is differentiable. The differential dNp of N at p ∈ S is a linear map from Tp(S) to TN(p)(S2). Since Tp(S) and TN(p)(S2) are the same vector spaces, dNp can be looked upon as a linear map on Tp(S).

The linear map dNp: Tp(S) → Tp(S) operates as follows. For each parametrized curve α(t) in S with α(0) = p, we consider the parametrized curve N ◦α(t) = N(t) in the sphere S2; this amounts to restricting the normal vector N to the curve α(t). The tangent vector N′(0) = dNp(α′(0)) is a vector in Tp(S) (Fig. 3-3). It measures the rate of change of the normal vector N, restricted to the curve α(t), at t = 0. Thus, dNp measures how N pulls

†In italic context, letter symbols set in roman rather than italics.

[Page 155]

S

S2

p

N N(p)

N(p)

Figure 3-2. The Gauss map.

N(t)

a(t)

N(p)

p

aÄ(0) = υ

###### Figure 3-3

away from N(p) in a neighborhood of p. In the case of curves, this measure is given by a number, the curvature. In the case of surfaces, this measure is characterized by a linear map.

- Example 1. For a plane P given by ax +by +cz +d = 0, the unit normal vector N = (a,b,c)/√a2 +b2 +c2 is constant, and therefore dN ≡ 0 (Fig. 3-4).

- Example 2. Consider the unit sphere


S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1}. If α(t) = (x(t),y(t),z(t)) is a parametrized curve in S2, then 2xx′ +2yy′ +2zz′ = 0,

[Page 156]

N

a

Figure 3-4. Plane: dNp = 0.

which shows that the vector (x,y,z) is normal to the sphere at the point (x,y,z). Thus, N¯ = (x,y,z) and N = (−x,−y,−z) are ﬁelds of unit normal vectors in S2. We ﬁx an orientation in S2 by choosing N = (−x,−y,−z) as a normal ﬁeld. Notice that N points toward the center of the sphere.

Restricted to the curve α(t), the normal vector

N(t) = (−x(t),−y(t),−z(t)) is a vector function of t, and therefore

dN(x′(t),y′(t),z′(t)) = N′(t) = (−x′(t),−y′(t),−z′(t));

that is, dNp(v) = −v for all p ∈ S2 and all v ∈ Tp(S2). Notice that with the choice of N¯ as a normal ﬁeld (that is, with the opposite orientation) we would have obtained dN¯p(v) = v (Fig. 3-5).

p

υ

a

N

–

Figure 3-5. Unit sphere: dN¯p(v) = v.

[Page 157]

Example 3. Consider the cylinder {(x,y,z) ∈ R3;x2 +y2 = 1}. By an argument similar to that of the previous example, we see that N¯ = (x,y,0) and N = (−x,−y,0) are unit normal vectors at (x,y,z). We ﬁx an orientation by choosing N = (−x,−y,0) as the normal vector ﬁeld.

By considering a curve (x(t),y(t),z(t)) contained in the cylinder, that is, with (x(t))2 +(y(t))2 = 1, we are able to see that, along this curve, N(t) = (−x(t),−y(t),0) and therefore

dN(x′(t),y′(t),z′(t)) = N′(t) = (−x′(t),−y′(t),0).

We conclude the following: If v is a vector tangent to the cylinder and parallel to the z axis, then

dN(v) = 0 = 0v;

if w is a vector tangent to the cylinder and parallel to the xy plane, then dN(w) = −w (Fig. 3-6). It follows that the vectors v and w are eigenvectors of dN with eigenvalues 0 and −1, respectively (see the appendix to Chap. 3).

z

υ

N

x

y

w

###### Figure 3-6

Example 4. Let us analyze the point p = (0,0,0) of the hyperbolic paraboloid z = y2 −x2. For this, we consider a parametrization x(u,v) given by

x(u,v) = (u,v,v2 −u2),

and compute the normal vector N(u,v). We obtain successively

xu = (1,0,−2u), xv = (0,1,2v),

N =

⎛ ⎜ ⎝

u ?

u2 +v2 + 41

, −v

?

u2 +v2 + 41

,

1 2

?

u2 +v2 + 41

⎞ ⎟ ⎠.

[Page 158]

Notice that at p = (0,0,0) xu and xv agree with the unit vectors along the x and y axes, respectively. Therefore, the tangent vector at p to the curve α(t) = x(u(t),v(t)), with α(0) = p, has, in R3, coordinates (u′(0),v′(0),0) (Fig. 3-7). Restricting N(u,v) to this curve and computing N′(0), we obtain

N′(0) = (2u′(0),−2v′(0),0),

z

x

y

Figure 3-7 and therefore, at p,

dNp(u′(0),v′(0),0) = (2u′(0),−2v′(0),0).

It follows that the vectors (1,0,0) and (0,1,0) are eigenvectors of dNp with eigenvalues 2 and −2, respectively.

Example 5. The method of the previous example, applied to the point p = (0,0,0) of the paraboloid z = x2 +ky2, k > 0, shows that the unit vectors of the x axis and the y axis are eigenvectors of dNp, with eigenvalues 2 and 2k, respectively (assuming that N is pointing outwards from the region bounded by the paraboloid).

An important fact about dNp is contained in the following proposition. PROPOSITION 1. The differential dNp: Tp(S) → Tp(S) of the Gauss

map is a self-adjoint linear map (cf. the appendix to Chap. 3).

Proof. Since dNp is linear, it sufﬁces to verify that ?dNp(w1),w2? = ?w1,dNp(w2)? for a basis {w1,w2} of Tp(S). Let x(u,v) be a parametrization of S at p and {xu,xv} the associated basis of Tp(S). If α(t) = x(u(t),v(t)) is a parametrized curve in S, with α(0) = p, we have

dNp(α′(0)) = dNp(xuu′(0)+xvv′(0))

=

d dt

N(u(t),v(t))?

t =0

= Nuu′(0)+Nvv′(0);

[Page 159]

in particular, dNp(xu) = Nu and dNp(xv) = Nv. Therefore, to prove that dNp is self-adjoint, it sufﬁces to show that

?Nu,xv? = ?xu,Nv?.

To sec this, take the derivatives of ?N,xu? = 0 and ?N,xv? = 0, relative to v and u, respectively, and obtain

?Nv,xu?+?N,xuv? = 0, ?Nu,xv?+?N,xvu? = 0.

Thus,

?Nu,xv? = −?N,xuv? = ?Nv,xu?. Q.E.D.

The fact that dNp: Tp(S) → Tp(S) is a self-adjoint linear map allows us to associate to dNp a quadratic form Q in Tp(S), given by Q(v) = ?dNp(v),v?, v ∈ Tp(S) (cf. the appendix to Chap. 3). To obtain a geometric interpretation of this quadratic form, we need a few deﬁnitions. For reasons that will be clear shortly, we shall use the quadratic form −Q.

- DEFINITION 2. The quadratic form IIp, deﬁned in Tp(S) by IIp(v) =

−?dNp(v),v? is called the second fundamental form of S at p.

- DEFINITION 3. Let C be a regular curve in S passing through p ∈ S,


k the curvature of C at p, and cosθ = ?n,N?, where n is the normal vector to C and N is the normal vector to S at p. The number kn = k cosθ is then called the normal curvature of C ⊂ S at p.

In other words, kn is the length of the projection of the vector kn over the normal to the surface at p, with a sign given by the orientation N of S at p (Fig. 3-8).

N

p

C

S

n

kn

kn

q

###### Figure 3-8

[Page 160]

Remark. The normal curvature of C does not depend on the orientation of C but changes sign with a change of orientation for the surface.

To give an interpretation of the second fundamental form IIp, consider a regular curve C ⊂ S parametrized by α(s), where s is the arc length of C, and with α(0) = p. If we denote by N(s) the restriction of the normal vector N to the curve α(s), we have ?N(s),α′(s)? = 0. Hence,

?N(s),α′′(s)? = −?N′(s),α′(s)?. Therefore,

IIp(α′(0)) = −?dNp(α′(0)),α′(0)?

= −?N′(0),α′(0)? = ?N(0),α′′(0)?

= ?N,kn?(p) = kn(p). In other words, the value of the second fundamental form IIp for a unit vector

- v ∈ Tp(S) is equal to the normal curvature of a regular curve passing through p and tangent to v. In particular, we obtained the following result.


PROPOSITION 2 (Meusnier). All curves lying on a surface S and having at a given point p ∈ S the same tangent line have at this point the same normal curvatures.

The above proposition allows us to speak of the normal curvature along a given direction at p. It is convenient to use the following terminology. Given a unit vector v ∈ Tp(S), the intersection of S with the plane containing v and N(p)iscalledthenormalsectionofS atp alongv (Fig. 3-9). Inaneighborhood of p, a normal section of S at p is a regular plane curve on S whose normal vector n at p is ±N(p) or zero; its curvature is therefore equal to the absolute value of the normal curvature along v at p. With this terminology, the above

C

υ

Normal section at p along υ

p

Cn

N

Figure 3-9. Meusnier theorem: C and Cn have the same normal curvature at p along v.

[Page 161]

proposition says that the absolute value of the normal curvature at p of a curve α(s) is equal to the curvature of the normal section of S at p along α′(0).

Example 6. Consider the surface of revolution obtained by rotating the curve z = y4 about the z axis (Fig. 3-10). We shall show that at p = (0,0,0) the differential dNp = 0. To see this, we observe that the curvature of the curve z = y4 at p is equal to zero. Moreover, since the xy plane is a tangent plane to the surface at p, the normal vector N(p) is parallel to the z axis. Therefore, any normal section at p is obtained from the curve z = y4 by rotation; hence, it has curvature zero. It follows that all normal curvatures are zero at p, and thus dNp = 0.

0

z

x

y

N z = y4

###### Figure 3-10

Example 7. In the plane of Example 1, all normal sections are straight lines; hence, all normal curvatures are zero. Thus, the second fundamental form is identically zero at all points. This agrees with the fact that dN ≡ 0.

In the sphere S2 of Example 2, with N as orientation, the normal sections through a point p ∈ S2 are circles with radius 1 (Fig. 3-11). Thus, all normal curvatures are equal to 1, and the second fundamental form is IIp(v) = 1 for all p ∈ S2 and all v ∈ Tp(S) with |v| = 1.

S2

p

N

Figure 3-11. Normal sections on a sphere.

[Page 162]

In the cylinder of Example 3, the normal sections at a point p vary from a circle perpendicular to the axis of the cylinder to a straight line parallel to the axis of the cylinder, passing through a family of ellipses (Fig. 3-12). Thus, the normal curvatures varies from 1 to 0. It is not hard to see geometrically that 1 is the maximum and 0 is the minimum of the normal curvature at p.

p

Figure 3-12. Normal sections on a cylinder.

However, an application of the theorem on quadratic forms of the appendix to Chap. 3 gives a simple proof of that. In fact, as we have seen in Example 3, the vectors w and v (corresponding to the directions of the normal curvatures 1 and 0, respectively) are eigenvectors of dNp with eigenvalues −1 and 0, respectively. Thus, the second fundamental form takes up its extreme values in these vectors, as we claimed. Notice that this procedure allows us to check that such extreme values are l and 0.

We leave it to the reader to analyze the normal sections at the point p = (0,0,0) of the hyperbolic paraboloid of Example 4.

Let us come back to the linear map dNp. The theorem of the appendix to Chap. 3 shows that for each p ∈ S there exists an orthonormal basis {e1,e2} of Tp(S) such that dNp(e1) = −k1e1, dNp(e2) = −k2e2. Moreover, k1 and k2 (k1 ≥ k2) are the maximum and minimum of the second fundamental form IIp restricted to the unit circle of Tp(S); that is, they are the extreme values of the normal curvature at p.

DEFINITION 4. The maximum normal curvature k1 and the minimum normalcurvaturek2 arecalledtheprincipalcurvaturesatp; thecorresponding directions, that is, the directions given by the eigenvectors e1,e2, are called principal directions at p.

For instance, in the plane all directions at all points are principal directions. The same happens with a sphere. In both cases, this comes from the fact that

[Page 163]

the second fundamental form at each point, restricted to the unit vectors, is constant (cf. Example 7); thus, all directions are extremals for the normal curvature.

In the cylinder of Example 3, the vectors v and w give the principal directions at p, corresponding to the principal curvatures 0 and 1, respectively. In the hyperbolic paraboloid of Example 4, the x and y axes are along the principal directions with principal curvatures −2 and 2, respectively.

DEFINITION 5. If a regular connected curve C on S is such that for all p ∈ C the tangent line of C is a principal direction at p, then C is said to be a line of curvature of S.

PROPOSITION 3 (Olinde Rodrigues). A necessary and sufﬁcient condition for a connected regular curve C on S to be a line of curvature of S is that

N′(t) = λ(t)α′(t),

for any parametrization α(t) of C, where N(t) = N ◦α(t) and λ(t) is a differentiable function of t. In this case, −λ(t) is the (principal) curvature along α′(t).

Proof. It sufﬁces to observe that if α′(t) is contained in a principal direction, then α′(t) is an eigenvector of dN and

dN(α′(t)) = N′(t) = λ(t)α′(t). The converse is immediate. Q.E.D.

The knowledge of the principal curvatures at p allows us to compute easily the normal curvature along a given direction of Tp(S). In fact, let v ∈ Tp(S) with |v| = 1. Since e1 and e2 form an orthonormal basis of Tp(S), we have

v = e1 cosθ +e2 sin θ,

where θ is the angle from e1 to v in the orientation of Tp(S). The normal curvature kn along v is given by

kn = IIp(v) = −?dNp(v),v?

= −?dNp(e1 cosθ +e2 sin θ),e1 cosθ +e2 sin θ?

= ?e1k1 cosθ +e2k2 sin θ,e1 cosθ +e2 sin θ?

= k1 cos2 θ +k2 sin2 θ.

The last expression is known classically as the Euler formula; actually, it is just the expression of the second fundamental form in the basis {e1,e2}.

[Page 164]

Given a linear map A: V → V of a vector space of dimension 2 and given a basis {v1,v2} of V , we recall that

determinant of A = a11a22 −a12a21, trace of A = a11 +a22,

where (aij) is the matrix of A in the basis {v1,v2}. It is known that these numbers do not depend on the choice of the basis {v1,v2} and are, therefore, attached to the linear map A.

In our case, the determinant of dN is the product (−k1)(−k2) = k1k2 of the principal curvatures, and the trace of dN is the negative −(k1 +k2) of the sum of principal curvatures. If we change the orientation of the surface, the determinant does not change (the fact that the dimension is even is essential here); the trace, however, changes sign.

DEFINITION 6. Let p ∈ S and let dNp: Tp(S) → Tp(S) be the differential of the Gauss map. The determinant of dNp is the Gaussian curvature K of S at p. The negative of half of the trace of dNp is called the mean curvature H of S at p.

In terms of the principal curvatures we can write

K = k1k2, H =

k1 +k2 2

.

DEFINITION 7. A point of a surface S is called

- 1. Elliptic if det(dNp) > 0.
- 2. Hyperbolic if det(dNp) < 0.
- 3. Parabolic if det(dNp) = 0, with dNp ?= 0.
- 4. Planar if dNp = 0.


It is clear that this classiﬁcation does not depend on the choice of the orientation.

At an elliptic point the Gaussian curvature is positive. Both principal curvatures have the same sign, and therefore all curves passing through this point have their normal vectors pointing toward the same side of the tangent plane. The points of a sphere are elliptic points. The point (0, 0, 0) of the paraboloid

- z = x2 +ky2, k > 0 (cf. Example 5), is also an elliptic point. At a hyperbolic point, the Gaussian curvature is negative. The principal


curvatures have opposite signs, and therefore there are curves through p whose normal vectors at p point toward any of the sides of the tangent plane at p. The point (0, 0, 0) of the hyperbolic paraboloid z = y2 −x2 (cf. Example 4) is a hyperbolic point.

At a parabolic point, the Gaussian curvature is zero, but one of the principal curvatures is not zero. The points of a cylinder (cf. Example 3) are parabolic points.

[Page 165]

Finally, at a planar point, all principal curvatures are zero. The points of a plane trivially satisfy this condition. A nontrivial example of a planar point was given in Example 6.

DEFINITION 8. If at p ∈ S, k1 = k2, then p is called an umbilical point of S; in particular, the planar points (k1 = k2 = 0) are umbilical points.

All the points of a sphere and a plane are umbilical points. Using the method of Example 6, we can verify that the point (0, 0, 0) of the paraboloid z = x2 +y2 is a (nonplanar) umbilical point.

We shall now prove the interesting fact that the only surfaces made up entirely of umbilical points are essentially spheres and planes.

PROPOSITION 4. If all points of a connected surface S are umbilical points, then S is either contained in a sphere or in a plane.

Proof. Let p ∈ S and let x(u,v) be a parametrization of S at p such that the coordinate neighborhood V is connected.

Since each q ∈ V is an umbilical point, we have, for any vector w = a1xu +a2xv in Tq(S),

dN(w) = λ(q)w, where λ = λ(q) is a real differentiable function in V .

We ﬁrst show that λ(q) is constant in V . For that, we write the above equation as

Nua1 +Nva2 = λ(xua1 +xva2); hence, since w is arbitrary,

- Nu = λxu,
- Nv = λxv.


Differentiatingtheﬁrstequationinv andthesecondoneinuandsubtracting the resulting equations, we obtain

λuxv −λvxu = 0. Since xu and xv are linear independent, we conclude that λu = λv = 0 for all q ∈ V . Since V is connected, λ is constant in V , as we claimed.

If λ ≡ 0, Nu = Nv = 0 and therefore N = N0 = constant in V . Thus, ?x(u,v),N0?u = ?x(u,v),N0?v = 0; hence,

?x(u,v),N0? = const., and all points x(u,v) of V belong to a plane.

[Page 166]

If λ ?= 0, then the point x(u,v)−(1/λ)N(u,v) = y(u,v) is ﬁxed, because

?x(u,v)−

1 λ

N(u,v)?

u

= ?x(u,v)−

1 λ

N(u,v)?

v

= 0.

Since

|x(u,v)−y|2 =

1 λ2

,

all points of V are contained in a sphere of center y and radius 1/|λ|.

This proves the proposition locally, that is, for a neighborhood of a point p ∈ S. To complete the proof we observe that, since S is connected, given any otherpointr ∈ S, thereexistsacontinuouscurveα:[0,1] → S withα(0) = p, α(1) = r. For each point α(t) ∈ S of this curve there exists a neighborhood Vt in S contained in a sphere or in a plane and such that α−1(Vt) is an open interval of [0,1]. The union

?

α−1(Vt), t ∈ [0,1], covers [0,1] and since [0,1] is a closed interval, it is covered by ﬁnitely many elements of the family {α−1(Vt)} (cf. the Heine-Borel theorem, Prop. 6 of the appendix to Chap. 2). Thus, α([0,1]) is covered by a ﬁnite number of the neighborhoods Vt.

If the points of one of these neighborhoods are on a plane, all the others will be on the same plane. Since r is arbitrary, all the points of S belong to this plane.

If the points of one of these neighborhoods are on a sphere, the same argument shows that all points on S belong to a sphere, and this completes the proof. Q.E.D.

DEFINITION 9. Let p be a point in S. An asymptotic direction of S at p is a direction of Tp(S) for which the normal curvature is zero. An asymptotic curve of S is a regular connected curve C ⊂ S such that for each p ∈ C the tangent line of C at p is an asymptotic direction.

It follows at once from the deﬁnition that at an elliptic point there are no asymptotic directions.

A useful geometric interpretation of the asymptotic directions is given by means of the Dupin indicatrix, which we shall now describe.

Let p be a point in S. The Dupin indicatrix at p is the set of vectors w of Tp(S) such that IIp(w) = ±1.

TowritetheequationsoftheDupinindicatrixinamoreconvenientform,let (ξ,η) be the Cartesian coordinates of Tp(S) in the orthonormal basis {e1,e2}, where e1 and e2 are eigenvectors of dNp. Given w ∈ Tp(S), let ρ and θ

[Page 167]

be “polar coordinates” deﬁned by w = ρv, with |v| = 1 and v = e1 cosθ + e2 sin θ, if ρ ?= 0. By Euler’s formula,

±1 = IIp(w) = p2IIp(v)

= k1ρ2 cos2 θ +k2ρ2 sin2 θ

= k1ξ2 +k2η2,

where w = ξe1 +ηe2. Thus, the coordinates (ξ,η) of a point of the Dupin indicatrix satisfy the equation

k1ξ2 +k2η2 = ±1; (1)

hence, the Dupin indicatrix is a union of conics in Tp(S). We notice that the normal curvature along the direction determined by w is kn(v) = IIp(v) = ±(1/ρ2).

For an elliptic point, the Dupin indicatrix is an ellipse (k1 and k2 have the same sign); this ellipse degenerates into a circle if the point is an umbilical nonplanar point (k1 = k2 ?= 0).

For a hyperbolic point, k1 and k2 have opposite signs. The Dupin indicatrix is therefore made up of two hyperbolas with a common pair of asymptotic lines (Fig. 3-13).Along the directions of the asymptotes, the normal curvature is zero; they are therefore asymptotic directions. This justiﬁes the terminology and shows that a hyperbolic point has exactly two asymptotic directions.

p

p

Elliptic point Hyperbolic point

e2

e2

e1 e1

r q r

q

Figure 3-13. The Dupin indicatrix.

For a parabolic point, one of the principal curvatures is zero, and the Dupin indicatrix degenerates into a pair of parallel lines. The common direction of these lines is the only asymptotic direction at the given point.

InExample5ofSec. 3-3weshallshowaninterestingpropertyoftheDupin indicatrix.

Closely related with the concept of asymptotic direction is the concept of conjugate directions, which we shall now deﬁne.

DEFINITION 10. Let p be a point on a surface S. Two nonzero vectors w1,w2 ∈ Tp(S) are conjugate if ?dNp(w1),w2? = ?w1,dNp(w2)? = 0.

[Page 168]

Two directions r1, r2 at p are conjugate if a pair of nonzero vectors w1, w2 parallel to r1 and r2, respectively, are conjugate.

It is immediate to check that the deﬁnition of conjugate directions does not depend on the choice of the vectors w1 and w2 on r1 and r2.

It follows from the deﬁnition that the principal directions are conjugate and that an asymptotic direction is conjugate to itself. Furthermore, at a nonplanar umbilic, every orthogonal pair of directions is a pair of conjugate directions, and at a planar umbilic each direction is conjugate to any other direction.

Let us assume that p ∈ S is not an umbilical point, and let {e1,e2} be the orthonormal basis of Tp(S) determined by dNp(e1) = −k1e1, dNp(e2) = −k2e2. Let θ and ϕ be the angles that a pair of directions r1 and r2 make with e1. We claim that r1 and r2 are conjugate if and only if

k1 cosθ cosϕ = −k2 sin θ sin ϕ. (2) In fact, r1 and r2 are conjugate if and only if the vectors

w1 = e1 cosθ +e2 sin θ, w2 = e1 cosϕ +e2 sin ϕ are conjugate. Thus,

0 = ?dNp(w1),w2? = −k1 cosθ cosϕ −k2 sin θ sin ϕ. Hence, condition (2) follows.

When both k1 and k2 are nonzero (i.e., p is either an elliptic or a hyperbolic point), condition (2) leads to a geometric construction of conjugate directions in terms of the Dupin indicatrix at p. We shall describe the construction at an elliptic point, the situation at a hyperbolic point being similar. Let r be a straight line through the origin of Tp(S) and consider the intersection points q1, q2 of r with the Dupin indicatrix (Fig. 3-14). The tangent lines of the

q

j

e1

e2

q2

q1

r r'

Figure 3-14. Construction of conjugate directions.

[Page 169]

Dupin indicatrix at q1 and q2 are parallel, and their common direction r′ is conjugate to r. We shall leave the proofs of these assertions to the Exercises (Exercise 12).

###### EXERCISES

- 1. Show that at a hyperbolic point, the principal directions bisect the asymptotic directions.
- 2. Show that if a surface is tangent to a plane along a curve, then the points of this curve are either parabolic or planar.
- 3. Let C ⊂ S be a regular curve on a surface S with Gaussian curvature K > 0. Show that the curvature k of C at p satisﬁes

|k| ≥ min(|k1|,|k2|), where k1 and k2 are the principal curvatures of S at p.

- 4. Assume that a surface S has the property that |k1| ≤ 1, |k2| ≤ 1 everywhere. Is it true that the curvature k of a curve on S also satisﬁes |k| ≤ 1?
- 5. Show that the mean curvature H at p ∈ S is given by

H =

1 π ? π

0

kn(θ)dθ,

where kn(θ) is the normal curvature at p along a direction making an angle θ with a ﬁxed direction.

- 6. Show that the sum of the normal curvatures for any pair of orthogonal directions, at a point p ∈ S, is constant.
- 7. Show that if the mean curvature is zero at a nonplanar point, then this point has two orthogonal asymptotic directions.
- 8. Describe the region of the unit sphere covered by the image of the Gauss map of the following surfaces:

- a. Paraboloid of revolution z = x2 +y2.
- b. Hyperboloid of revolution x2 +y2 −z2 = 1.
- c. Catenoid x2 +y2 = cosh2 z.


- 9. Prove that


- a. The image N ◦α by the Gauss map N: S → S2 of a parametrized regular curve α: I → S which contains no planar or parabolic points is a parametrized regular curve on the sphere S2 (called the spherical image of α).


[Page 170]

- b. If C = α(I) is a line of curvature, and k is its curvature at p, then k = |knkN|,


where kn is the normal curvature at p along the tangent line of C and kN is the curvature of the spherical image N(C) ⊂ S2 at N(p).

- 10. Assume that the osculating plane of a line of curvature C ⊂ S, which is nowhere tangent to an asymptotic direction, makes a constant angle with the tangent plane of S along C. Prove that C is a plane curve.
- 11. Let p be an elliptic point of a surface S, and let r and r′ be conjugate directions at p. Let r vary in Tp(S) and show that the minimum of the angle of r with r′ is reached at a unique pair of directions in Tp(S) that are symmetric with respect to the principal directions.
- 12. Let p be a hyperbolic point of a surface S, and let r be a direction in


Tp(S). Describeandjustifyageometricconstructiontoﬁndtheconjugate direction r′ of r in terms of the Dupin indicatrix (cf. the construction at the end of Sec. 3-2).

- *13. (Theorem of Beltrami-Enneper.) Prove that the absolute value of the torsion τ at a point of an asymptotic curve, whose curvature is nowhere zero, is given by

|τ| =

√

−K, where K is the Gaussian curvature of the surface at the given point.

- *14. If the surface S1 intersects the surface S2 along the regular curve C, then the curvature k of C at p ∈ C is given by

k2 sin2 θ = λ21 +λ22 −2λ1λ2 cosθ,

where λ1 and λ2 are the normal curvatures at p, along the tangent line to C, of S1 and S2, respectively, and θ is the angle made up by the normal vectors of S1 and S2 at p.

15. (Theorem of Joachimstahl.) Suppose that S1 and S2 intersect along a regular curve C and make an angle θ(p), p ∈ C.Assume that C is a line

- of curvature of S1. Prove that θ(p) is constant if and only if C is a line
- of curvature of S2.


- *16. Show that the meridians of a torus are lines of curvature.


17. Show that if H ≡ 0 on S and S has no planar points, then the Gauss map

N: S → S2 has the following property: ?dNp(w1),dNp(w2)? = −K(p)?w1,w2?

for all p ∈ S and all w1,w2 ∈ Tp(S). Show that the above condition implies that the angle of two intersecting curves on S and the angle of their spherical images (cf. Exercise 9) are equal up to a sign.

[Page 171]

- *18. Let λ1,...,λm be the normal curvatures at p ∈ S along directions making angles 0,2π/m,...,(m−1)2π/m with a principal direction, m > 2. Prove that

λ1 +···+λm = mH, where H is the mean curvature at p.

- *19. Let C ⊂ S be a regular curve in S. Let p ∈ C and α(s) be a parametriza-

tion of C in p by arc length so that α(0) = p. Choose in Tp(S) an orthonormal positive basis {t,h}, where t = α′(0). The geodesic torsion τg of C ⊂ S at p is deﬁned by

τg = ?

dN ds

(0),h?.

Prove that

- a. τg = (k1 −k2)cosϕ sin ϕ, where ϕ is the angle from e1 to t and t is the unit tangent vector corresponding to the principal curvature k1.
- b. If τ is the torsion of C, n is the (principal) normal vector of C and

cosθ = ?N,n?, then

dθ ds = τ −τg.

- c. The lines of curvature of S are characterized by having geodesic torsion identically zero.


- *20. (Dupin’s Theorem.) Three families of surfaces are said to form a triply orthogonal system in an open set U ⊂ R3 if a unique surface of each familypassesthrougheachpointp ∈ U andifthethreesurfacesthatpass through p are pairwise orthogonal. Use part c of Exercise 19 to prove Dupin’s theorem: The surfaces of a triply orthogonal system intersect each other in lines of curvature.


###### 3-3. The Gauss Map in Local Coordinates

In the preceding section, we introduced some concepts related to the local behavior of the Gauss map. To emphasize the geometry of the situation, the deﬁnitions were given without the use of a coordinate system. Some simple examples were then computed directly from the deﬁnitions; this procedure, however, is inefﬁcient in handling general situations. In this section, we shall obtaintheexpressionsofthesecondfundamentalformandofthedifferentialof theGaussmapinacoordinatesystem.Thiswillgiveusasystematicmethodfor computingspeciﬁcexamples. Moreover, thegeneralexpressionsthusobtained are essential for a more detailed investigation of the concepts introduced above.

[Page 172]

All parametrizations x: U ⊂ R2 → S considered in this section are assumed to be compatible with the orientation N of S; that is, in x(U),

N =

xu ∧xv |xu ∧xv|

.

Let x(u,v) be a parametrization at a point p ∈ S of a surface S, and let α(t) = x(u(t),v(t))beaparametrizedcurveonS, withα(0) = p. Tosimplify the notation, we shall make the convention that all functions to appear below denote their values at the point p.

The tangent vector to α(t) at p is α′ = xuu′ +xvv′ and

dN(α′) = N′(u(t),v(t)) = Nuu′ +Nvv′. Since Nu and Nv belong to Tp(S), we may write

- Nu = a11xu +a21xv,
- Nv = a12xu +a22xv,


###### (1)

and therefore,

dN(α′) = (a11u′ +a12v′)xu +(a21u′ +a22v′)xv; hence,

dN ?

u′ v′

? = ?

a11 a12 a21 a22

??

- u′
- v′


?.

This shows that in the basis {xu,xv}, dN is given by the matrix (aij), i,j = 1,2. Notice that this matrix is not necessarily symmetric, unless {xu,xv} is an orthonormal basis.

On the other hand, the expression of the second fundamental form in the basis {xu,xv} is given by

IIp(α′) = −?dN(α′),α′? = −?Nuu′ +Nvv′,xuu′ +xvv′?

= e(u′)2 +2f u′v′ +g(v′)2,

where, since ?N,xu? = ?N,xv? = 0,

- e = −?Nu,xu? = ?N,xuu?,
- f = −?Nv,xu? = ?N,xuv? = ?N,xvu? = −?Nu,xv?,
- g = −?Nv,xv? = ?N,xvv?.


[Page 173]

We shall now obtain the values of aij in terms of the coefﬁcients e,f,g. From Eq. (1), we have

−f = ?Nu,xv) = a11F +a21G, −f = ?Nv,xu) = a12E +a22F,

−e = ?Nu,xu) = a11E +a21F, −g = ?Nv,xv) = a12F +a22G,

###### (2)

where E,F, and G are the coefﬁcients of the ﬁrst fundamental form in the basis {xu,xv} (cf. Sec. 2-5). Relations (2) may be expressed in matrix form by

−?

e f f g

? = ?

- a11 a21
- a12 a22


??

E F F G

?; (3)

hence,

?

a11 a21 a12 a22

? = −?

e f f g

??

E F F G

?−1 ,

where ( )−1 means the inverse matrix of ( ). It is easily checked that ?

E F F G

?−1 =

1 EG−F2

?

G −F −F E

?,

whence the following expressions for the coefﬁcients (aij) of the matrix of dN in the basis {xu,xv}:

- a11 =

fF −eG EG −F2

,

- a12 =


gF −fG EG −F2

,

- a21 =

eF −fE EG −F2

,

- a22 =


fF −gE EG −F2

.

For completeness, it should be mentioned that relations (1), with the above values, are known as the equations of Weingarten.

[Page 174]

From Eq. (3) we immediately obtain

K = det(aij) =

eg −f2 EG −F2

###### . (4)

To compute the mean curvature, we recall that −k1,−k2 are the eigenvalues of dN. Therefore, k1 and k2 satisfy the equation

dN(v) = −kv = −kIv for some v ∈ Tp(S),v ?= 0,

where I is the identity map. It follows that the linear map dN +kI is not invertible; hence, it has zero determinant. Thus,

det ?

a11 +k a12 a21 a22 +k

? = 0

or

k2 +k(a11 +a22)+a11a22 −a21a12 = 0.

Since k1 and k2 are the roots of the above quadratic equation, we conclude that

H =

- 1

- 2


(k1 +k2) = −

- 1

- 2


(a11 +a22) =

- 1

- 2


eG −2fF +gE

EG −F2 ; (5) hence,

k2 −2Hk +K = 0, and therefore,

k = H±?

H2 −K. (6)

From this relation, it follows that if we choose k1(q) ≥ k2(q), q ∈ S, then the functions k1 and k2 are continuous in S. Moreover, k1 and k2 are differentiable in S, except perhaps at the umbilical points (H2 = K) of S.

In the computations of this chapter, it will be convenient to write for short ?u∧v,w? = (u,v,w) for any u,v,w ∈ R3.

We recall that this is merely the determinant of the 3×3 matrix whose columns (or lines) are the components of the vectors u,v,w in the canonical basis of R3.

Example 1. We shall compute the Gaussian curvature of the points of the torus covered by the parametrization (cf. Example 6 of Sec. 2-2)

[Page 175]

x(u,v) = ((a +r cosu)cosv,(a +r cosu)sin v,r sin u),

0 < u < 2π, 0 < v < 2π.

For the computation of the coefﬁcients e,f,g, we need to know N (and thus xu and xv), xuu, xuv, and xvv:

xu = (−r sin ucosv,−r sin usin v,r cosu), xv = (−(a +r cosu)sin v,(a +r cosu)cosv,0),

xuu = (−r cosucosv,−r cosusin v,−r sin u), xuv = (r sin usin v,−r sin ucosv,0), xvv = (−(a +r cosu)cosv,−(a +r cosu)sin v,0).

From these, we obtain

E = ?xu,xu? = r2, F = ?xu,xv? = 0, G = ?xv,xv? = (a +r cosu)2.

Introducing the values just obtained in e = ?N,xuu?, we have, since |xu ∧xv| =

√EG−F2,

e = ?

xu ∧xv |xu ∧xv|

,xuu? =

(xu,xv,xuu) √EG −F2 =

r2(a +r cosu) r(a +r cosu) = r.

Similarly, we obtain

- f =

(xu,xv,xuv) r(a +r cosu) = 0,

- g =


(xu,xv,xvv)

r(a +r cosu) = cosu(a +r cosu). Finally, since K = (eg −f2)/(EG −F2), we have that

K =

cosu r(a +r cosu)

.

From this expression, it follows that K = 0 along the parallels u = π/2 and u = 3π/2; the points of such parallels are therefore parabolic points. In the region of the torus given by π/2 < u < 3π/2, K is negative (notice that r > 0 and a > r); the points in this region are therefore hyperbolic points. In the region given by 0 < u < π/2 or 3π/2 < u < 2π, the curvature is positive and the points are elliptic points (Fig. 3-15).

As an application of the expression for the second fundamental form in coordinates, we shall prove a proposition which gives information about the

[Page 176]

p

Tp(T)

T

K < 0 K > 0 K > 0

K = 0

K = 0

Generating circle

Rotation axis

K < 0

###### Figure 3-15

position of a surface in the neighborhood of an elliptic or a hyperbolic point, relative to the tangent plane at this point. For instance, if we look at an elliptic point of the torus of Example 1, we ﬁnd that the surface lies on one side of the tangent plane at such a point (see Fig. 3-15). On the other hand, if p is a hyperbolic point of the torus T and V ⊂ T is any neighborhood of p, we can ﬁnd points of V on both sides of Tp(S), however small V may be. This example reﬂects a general local fact that is described in the following proposition.

PROPOSITION 1. Let p ∈ S be an elliptic point of a surface S. Then there exists a neighborhood V of p in S such that all points in V belong to the same side of the tangent plane Tp(S). Let p ∈ S be a hyperbolic point. Then in each neighborhood of p there exist points of S in both sides of Tp(S).

Proof. Let x(u,v) be a parametrization in p, with x(0,0) = p. The distance d from a point q = x(u,v) to the tangent plane Tp(S) is given by (Fig. 3-16)

d = ?x(u,v)−x(0,0),N(p)?.

Since x(u,v) is differentiable, we have Taylor’s formula:

x(u,v) = x(0,0)+xuu+xvv + 12(xuuu2 +2xuvuv +xvvv2)+R,¯

where the derivatives are taken at (0,0) and the remainder R¯ satisﬁes the condition

lim

(u,v)→(0,0)

R¯ u2 +v2 = 0.

[Page 177]

Tp(S)

N(p)

x(u,υ)

d

p = x(0,0)

S

###### Figure 3-16

It follows that d = ?x(u,v)−x(0,0),N(p)?

= 12{xuu,N(p)?u2 +2?xuv,N(p)?uv +?xvv,N(p)?v2}+R

= 21(eu2 +2fuv +gv2)+R = 21IIp(w)+R, where w = xuu+xvv, R = ?R,N(p)¯ ?, and limw→0(R/|w|2) = 0.

For an elliptic point p,IIp(w) has a ﬁxed sign. Therefore, for all (u,v) sufﬁciently near p, d has the same sign as IIp(w); that is, all such (u,v) belong to the same side of Tp(S).

For a hyperbolic point p, in each neighborhood of p there exist points (u,v) and (u,¯ v)¯ such that IIp(w/|w|) and IIp(w/¯ |w¯ |) have opposite signs (here w¯ = xuu¯ +xvv¯); such points belong therefore to distinct sides of Tp(S).

###### Q.E.D.

No such statement as Prop. 1 can be made in a neighborhood of a parabolic or a planar point. In the above examples of parabolic and planar points (cf. Examples 3 and 6 of Sec. 3-2) the surface lies on one side of the tangent plane and may have a line in common with this plane. In the following examples we shall show that an entirely different situation may occur.

Example 2. The “monkey saddle” (see Fig. 3-17) is given by

x = u, y = v, z = u3 −3v2u.

Adirect computation shows that at (0,0) the coefﬁcients of the second fundamental form are e = f = g = 0; the point (0,0) is therefore a planar point. In any neighborhood of this point, however, there are points in both sides of its tangent plane.

[Page 178]

x

y

z

x

z = y3

z = 1

y

z

###### Figure 3-17 Figure 3-18

Example 3. Consider the surface obtained by rotating the curve z = y3, −1 < z < 1, about the line z = 1 (see Fig. 3-18).Asimple computation shows that the points generated by the rotation of the origin O are parabolic points. We shall omit this computation, because we shall prove shortly (Example 4) that the parallels and the meridians of a surface of revolution are lines of curvature; this, together with the fact that, for the points in question, the meridians (curves of the form y = x3) have zero curvature and the parallel is a normal section, will imply the above statement.

Notice that in any neighborhood of such a parabolic point there exist points in both sides of the tangent plane.

The expression of the second fundamental form in local coordinates is particularly useful for the study of the asymptotic and principal directions. We ﬁrst look at the asymptotic directions.

Let x(u,v) be a parametrization at p ∈ S, with x(0,0) = p, and let e(u,v) = e, f(u,v) = f , and g(u,v) = g be the coefﬁcients of the second fundamental form in this parametrization.

We recall that (see Def. 9 of Sec. 3-2) a connected regular curve C in the coordinate neighborhood of x is an asymptotic curve if and only if for any parametrization α(t) = x(u(t),v(t)), t ∈ I, of C we have II(α′(t)) = 0, for all t ∈ I, that is, if and only if

e(u′)2 +2fu′v′ +g(v′)2 = 0, t ∈ I. (7)

Because of that, Eq. (7) is called the differential equation of the asymptotic curves. In the next section we shall give a more precise meaning to this expression. For the time being, we want to draw from Eq. (7) only the following useful conclusion: A necessary and sufﬁcient condition for a parametrization in a neighborhood of a hyperbolic point (eg − f2 < 0) to be such that

[Page 179]

the coordinate curves of the parametrization are asymptotic curves is that

- e = g = 0. Infact, ifbothcurvesu = const., v = v(t)andu = u(t), v = const.satisfy

Eq. (7), we obtain e = g = 0. Conversely, if this last condition holds and

- f ?= 0, Eq. (7) becomes fu′v′ = 0, which is clearly satisﬁed by the coordinate lines.


We shall now consider the principal directions, maintaining the notations already established.

A connected regular curve C in the coordinate neighborhood of x is a line of curvature if and only if for any parametrization α(t) = x(u(t),v(t)) of C, t ∈ I, we have (cf. Prop. 3 of Sec. 3-2)

dN(α′(t)) = λ(t)α′(t). It follows that the functions u′(t),v′(t) satisfy the system of equations

fF −eG EG −F2

u′ +

gF −fG EG −F2

v′ = λu′, eF −fE EG −F2

u′ +

fF −gE EG −F2

v′ = λv′.

By eliminating λ in the above system, we obtain the differential equation of the lines of curvature,

(fE −eF)(u′)2 +(gE −eG)u′v′ +(gF −fG)(v′)2 = 0, which may be written, in a more symmetric way, as

?

(v′)2 −u′v′ (u′)2 E F G e f g ?

= 0. (8)

Using the fact that the principal directions are orthogonal to each other, it follows easily from Eq. (8) that a necessary and sufﬁcient condition for the coordinate curves of a parametrization to be lines of curvature in a neighborhood of a nonumbilical point is that F = f = 0.

Example 4 (Surfaces of Revolution). Consider a surface of revolution parametrized by (cf. Example 4 of Sec. 2-3; we have replaced f and g by ϕ and ψ, respectively)

x(u,v) = (ϕ(v)cosu,ϕ(v)sin u,ψ(v)),

0 < u < 2π, a < v < b, ϕ(v) ?= 0.

[Page 180]

The coefﬁcients of the ﬁrst fundamental form are given by E = ϕ2, F = 0, G = (ϕ′)2 +(ψ′)2.

It is convenient to assume that the rotating curve is parametrized by arc length, that is, that

(ϕ′)2 +(ψ′)2 = G = 1.

The computation of the coefﬁcients of the second fundamental form is straightforward and yields

- e =

(xu,xv,xuu) √EG −F2 =

1 √EG −F2 ?

−ϕ sin u ϕ′ cosu −ϕ cosu ϕ cosu ϕ′ sin u −ϕ sin u

0 ψ′ 0 ?

= −ϕψ′

- f = 0,
- g = ψ′ϕ′′ −ψ′′ϕ′.


Since F = f = 0, we conclude that the parallels (v = const.) and the meridians (u = const.) of a surface of revolution are lines of curvature of such a surface (this fact was used in Example 3).

Because

K =

eg −f2 EG −F2 = −

ψ′(ψ′ϕ′′ −ψ′′ϕ′) ϕ

and ϕ is always positive, it follows that the parabolic points are given by either ψ′ = 0 (the tangent line to the generator curve is perpendicular to the axis of rotation) or ϕ′ψ′′ −ψ′ϕ′′ = 0 (the curvature of the generator curve is zero). Apoint which satisﬁes both conditions is a planar point, since these conditions imply that e = f = g = 0.

It is convenient to put the Gaussian curvature in still another form. By differentiating (ϕ′)2 +(ψ′)2 = 1 we obtain ϕ′ϕ′′ = −ψ′ψ′′. Thus,

K = −

ψ′(ψ′ϕ′′ −ψ′′ϕ′) ϕ = −

(ψ′)2ϕ′′ +(ϕ′)2ϕ′′ ϕ = −

ϕ′′ ϕ

###### . (9)

Equation (9) is a convenient expression for the Gaussian curvature of a surface of revolution. It can be used, for instance, to determine the surfaces of revolution of constant Gaussian curvature (cf. Exercise 7).

To compute the principal curvatures, we ﬁrst make the following general observation: If a parametrization of a regular surface is such that F = f = 0,

[Page 181]

then the principal curvatures are given by e/E and g/G. In fact, in this case, the Gaussian and the mean curvatures are given by (cf. Eqs. (4) and (5))

K =

eg EG

, H =

- 1

- 2


eG +gE EG

.

Since K is the product and 2H is the sum of the principal curvatures, our assertion follows at once.

Thus, the principal curvatures of a surface of revolution are given by

e E = −

ψ′ϕ ϕ2 = −

ψ′ ϕ

,

g G = ψ′ϕ′′ −ψ′′ϕ′; (10)

hence, the mean curvature of such a surface is

H =

1 2

−ψ′ +ϕ(ψ′ϕ′′ −ψ′′ϕ′) ϕ

###### . (11)

Example 5. Very often a surface is given as the graph of a differentiable function (cf. Prop. 1, Sec. 2-2) z = h(x,y), where (x,y) belong to an open set U ⊂ R2. It is, therefore, convenient to have at hand formulas for the relevant concepts in this case. To obtain such formulas let us parametrize the surface by

x(u,v) = (u,v,h(u,v)), (u,v) ∈ U, where u = x, v = y. A simple computation shows that

xu = (1,0,hu), xv = (0,1,hv), xuu = (0,0,huu), xuv = (0,0,huu), xvv = (0,0,hvv). Thus

N(x,y) =

(−hx,−hy,1) (1+h2x +h2y)1/2

is a unit normal ﬁeld on the surface, and the coefﬁcients of the second fundamental form in this orientation are given by

- e =

hxx (1+h2x +h2y)1/2

,

- f =

hxy (1+h2x +h2y)1/2

,

- g =


hyy (1+h2x +h2y)1/2

.

[Page 182]

From the above expressions, any needed formula can be easily computed. For instance, from Eqs. (4) and (5) we obtain the Gaussian and mean curvatures:

K =

hxxhyy −h2xy (1+h2x +h2y)2

,

2H =

(1+h2x)hyy −2hxhyhxy +(1+h2y)hxx (1+h2x +h2y)3/2

.

There is still another, perhaps more important, reason to study surfaces given by z = h(x,y). It comes from the fact that locally any surface is the graph of a differentiable function (cf. Prop. 3, Sec. 2-2). Given a point p of a surface S, we can choose the coordinate axis of R3 so that the origin O of the coordinates is at p and the z axis is directed along the positive normal of S at p (thus, the xy plane agrees with Tp(S)). It follows that a neighborhood of p in S can be represented in the form z = h(x,y), (x,y) ∈ U ⊂ R2, where U is an open set and h is a differentiable function (cf. Prop. 3, Sec. 2-2), with h(0,0) = 0, hx(0,0) = 0, hy(0,0) = 0 (Fig. 3-19).

x

x

y

y

y

S

0

z

z

x

0

0

z Figure 3-19. Each point of S has aneighborhoodthatcanbewritten as z = h(x,y).

The second fundamental form of S at p applied to the vector (x,y) ∈ R2 becomes, in this case,

hxx(0,0)x2 +2hxy(0,0)xy +hyy(0,0)y2.

In elementary calculus of two variables, the above quadratic form is known as the Hessian of h at (0,0). Thus, the Hessian of h at (0,0) is the second fundamental form of S at p.

Let us apply the above considerations to give a geometric interpretation of the Dupin indicatrix. With the notation as above, let ǫ > 0 be a small number such that

[Page 183]

C = {(x,y) ∈ Tp(S);h(x,y) = ǫ}

is a regular curve (we may have to change the orientation of the surface to achieve ǫ > 0). We want to show that if p is not a planar point, the curve C is “approximately” similar to the Dupin indicatrix of S at p (Fig. 3-20).

A plane parallel to Tp(S)

p

p

p

S

S

###### Figure 3-20

To see this, let us assume further that the x and y axes are directed along the principal directions, with the x axis along the direction of maximum principal curvature. Thus, f = hxy(0,0) = 0 and

k1(p) =

e E = hxx(0,0), k2(p) =

g G = hyy(0,0).

By developing h(x,y) into a Taylor’s expansion about (0,0), and taking into account that hx(0,0) = 0 = hy(0,0), we obtain

h(x,y) = 12(hxx(0,0)x2 +2hxy(0,0)xy +hyy(0,0)y2)+R

= 21(k1x2 +k2y2)+R, where

lim

(x,y)→(0,0)

R x2 +y2 = 0.

[Page 184]

Thus, the curve C is given by k1x2 +k2y2 +2R = 2ǫ.

Now, if p is not a planar point, we can consider k1x2 +k2y2 = 2ǫ as a ﬁrst-order approximation of C in a neighborhood of p. By using the similarity transformation,

x = x¯

√2ǫ, y = y¯

√2ǫ, we have that k1x2 +k2y2 = 2ǫ is transformed into the curve k1x¯2 +k2y¯2 = 1,

which is the Dupin indicatrix at p. This means that if p is a nonplanar point, the intersection with S of a plane parallel to Tp(S) and close to p is, in a ﬁrst-order approximation, a curve similar to the Dupin indicatrix at p.

If p is a planar point, this interpretation is no longer valid (cf. Exercise 11). To conclude this section we shall give a geometrical interpretation of the

Gaussian curvature in terms of the Gauss map N: S → S2. Actually, this was how Gauss himself introduced this curvature.

To do this, we ﬁrst need a deﬁnition. Let S and S¯ be two oriented regular surfaces. Let ϕ: S → S¯ be a differentiable map and assume that for some p ∈ S, dϕp is nonsingular. We say that ϕ is orientation-preserving at p if given a positive basis {w1,w2} in Tp(S), then {dϕp(w1),dϕp(w2)} is a positive basis in Tϕ(p)(S)¯ . If {dϕp(w1),dϕp(w2)} is not a positive basis, we say that ϕ is orientation-reversing at p.

We now observe that both S and the unit sphere S2 are embedded in R3. Thus, an orientation N on S induces an orientation N in S2. Let p ∈ S be such that dNp is nonsingular. Since for a basis {w1,w2} in Tp(S)

dNp(w1)∧dNp(w2) = det(dNp)(w1 ∧w2) = Kw1 ∧w2,

the Gauss map N will be orientation-preserving at p ∈ S if K(p) > 0 and orientation-reversing at p ∈ S if K(p) < 0. Intuitively, this means the following (Fig. 3-21): An orientation of Tp(S) induces an orientation of small closed curves in S around p; the image by N of these curves will have the same or the opposite orientation to the initial one, depending on whether p is an elliptic or hyperbolic point, respectively.

To take this fact into account we shall make the convention that the area of the image by N of a region contained in a connected neighborhood V ⊂ S whereK ?= 0ispositiveifK > 0andnegativeifK < 0(sinceV isconnected, K does not change sign in V ).

Now we can state the promised geometric interpretation of the Gaussian curvature K, for K ?= 0.

[Page 185]

4

3

1 2 3

4

N

4

3

2

2

0

4

1

3

0

1

1

2

N

- Figure 3-21. The Gauss map preserves orientation at an elliptic point and reverses it at a hyperbolic point.


PROPOSITION 2. Let p be a point of a surface S such that the Gaussian curvature K(p) ?= 0, and let V be a connected neighborhood of p where K does not change sign. Then

K(p) = lim

A→0

A′ A

,

where A is the area of a region B ⊂ V containing p, A′ is the area of the image of B by the Gauss map N: S → S2, and the limit is taken through a sequence of regions Bn that converges to p, in the sense that any sphere around p contains all Bn, for n sufﬁciently large.

Proof. The area A of B is given by (cf. Sec. 2-5)

A = ??

R

|xu ∧xv|dudv,

where x(u,v) is a parametrization in p, whose coordinate neighborhood contains V (V can be assumed to be sufﬁciently small) and R is the region in the uv plane corresponding to B. The area A′ of N(B) is

[Page 186]

A′ = ??

R

|Nu ∧Nv|dudv. Using Eq. (1), the deﬁnition of K, and the above convention, we can write A′ = ??

R

K|xu ∧xv|dudv. (12) Going to the limit and denoting also by R the area of the region R, we obtain

lim

A→0

A′ A = lim

R→0

A′/R A/R =

lim

R→0

(1/R)??

R

K|xu ∧xv|dudv lim

R→0

(1/R)??

R

|xu ∧xv|dudv

=

K|xu ∧xv| |xu ∧xv|

= K

(notice that we have used the mean value theorem for double integrals), and this proves the proposition. Q.E.D.

Remark. Comparing the proposition with the expression of the curvature k = lim

s→0

σ s

of a plane curve C at p (here s is the arc length of a small segment of C containingp, andσ isthearclengthofitsimageintheindicatrixoftangents; cf. Exercise 3 of Sec. 1-5), we see that the Gaussian curvature K is the analogue, for surfaces, of the curvature k of plane curves.

###### EXERCISES

1. Show that at the origin (0,0,0) of the hyperboloid z = axy we have

K = −a2 and H = 0.

- *2. Determinetheasymptoticcurvesandthelinesofcurvatureofthehelicoid x = v cosu, y = v sin u, z = cu, and show that its mean curvature is zero.
- *3. Determine the asymptotic curves of the catenoid x(u,v) = (cosh v cosu,cosh v sin u,v).


- 4. Determine the asymptotic curves and the lines of curvature of z = xy.
- 5. Consider the parametrized surface (Enneper’s surface)


x(u,v) = ?u−

u3 3 +uv2,v −

v3 3 +vu2,u2 −v2?

[Page 187]

and show that

- a. The coefﬁcients of the ﬁrst fundamental form are E = G = (1+u2 +v2)2, F = 0.
- b. The coefﬁcients of the second fundamental form are e = 2, g = −2, f = 0.
- c. The principal curvatures are

k1 =

2 (1+u2 +v2)2

, k2 = −

2 (1+u2 +v2)2

.

- d. The lines of curvature are the coordinate curves.
- e. The asymptotic curves are u+v = const., u−v = const.


- 6. (A Surface with K ≡ −1; the Pseudosphere.)

*a. Determine an equation for the plane curve C, which is such that the segment of the tangent line between the point of tangency and some line r in the plane, which does not meet the curve, is constantly equal to 1 (this curve is called the tractrix; see Fig. 1-9).

- b. Rotate the tractrix C about the line r; determine if the “surface” of revolution thus obtained (the pseudosphere; see Fig. 3-22) is regular and ﬁnd out a parametrization in a neighborhood of a regular point.
- c. Show that the Gaussian curvature of any regular point of the pseudosphere is −1.


- 7. (Surfaces of Revolution with Constant Curvature.) (ϕ(v)cosu, ϕ(v)sin u,ψ(v)), ϕ ?= 0 is given as a surface of revolution with constant Gaussian curvature K. To determine the functions ϕ and ψ, choose the parameter v in such a way that (ϕ′)2 +(ψ′)2 = 1 (geometrically, this means that v is the arc length of the generating curve (ϕ(v),ψ(v))). Show that


- a. ϕ satisﬁes ϕ′′ +Kϕ = 0 and ψ is given by ψ =

? ?

1−(ϕ′)2 dv; thus, 0 < u < 2π, and the domain of v is such that the last integral makes sense.

- b. All surfaces of revolution with constant curvature K = 1 which intersect perpendicularly the plane xOy are given by


ϕ(v) = C cosv, ψ(v) = ? v

0

?

1−C2 sin2 v dv,

where C is a constant (C = ϕ(0)). Determine the domain of v and draw a rough sketch of the proﬁle of the surface in the xz plane for

[Page 188]

C > 1

C < 1

Rotation C = 1 axis

###### Figure 3-22. The pseudosphere. Figure 3-23

the cases C = 1, C > 1, C < 1. Observe that C = 1 gives a sphere (Fig. 3-23).

c. All surfaces of revolution with constant curvature K = −1 may be

given by one of the following types:

- 1. ϕ(v) = C cosh v,

ψ(v) =

? v 0

?

1−C2 sinh2 v dv.

- 2. ϕ(v) = C sinh v,

ψ(v) =

? v 0

?

1−C2 cosh2 v dv.

- 3. ϕ(v) = ev,


ψ(v) =

? v 0

√1−e2v dv.

Determine the domain of v and draw a rough sketch of the proﬁle of the surface in the xz plane.

d. The surface of type 3 in part c is the pseudosphere of Exercise 6. e. The only surfaces of revolution with K ≡ 0 are the right circular

cylinder, the right circular cone, and the plane.

- 8. (Contact of Order ≥ 2 of Surfaces.) Two surfaces S and S¯, with a common point p, have contact of order ≥ 2 at p if there exist parametrizations x(u,v) and x¯(u,v) in p of S and S¯, respectively, such that


xu = x¯u, xv = x¯v, xuu = x¯uu, xuv = x¯uv, xvv = x¯vv

[Page 189]

at p. Prove the following:

- *a. Let S and S¯ have contact of order ≥ 2 at p; x: U → S and x¯: U → S¯ be arbitrary parametrizations in p of S and S¯, respectively; and f : V ⊂ R3 → R be a differentiable function in a neighborhood V of p in R3. Then the partial derivatives of order ≤ 2 of f ◦x¯: U → R are zero in x¯−1(p) if and only if the partial derivatives of order ≤ 2 of f ◦x: U → R are zero in x−1(p).
- *b. Let S and S¯ have contact of order ≥ 2 at p. Let z = f (x,y), z = f (x,y)¯ be the equations, in a neighborhood of p, of S and S¯, respectively, where the xy plane is the common tangent plane at p = (0,0). Then the function f (x,y)−f (x,y)¯ has all partial derivatives of order ≤ 2, at (0,0), equal to zero.

c. Let p be a point in a surface S ⊂ R3. Let Oxyz be a Cartesian coordinate system for R3 such that O = p and the xy plane is the tangent plane of S at p. Show that the paraboloid

z = 21(x2fxx +2xyfxy +y2fyy), (*)

obtained by neglecting third- and higher-order terms in the Taylor development around p = (0,0), has contact of order ≥ 2 at p with S (the surface (∗) is called the osculating paraboloid of S at p).

- *d. If a paraboloid (the degenerate cases of plane and parabolic cylinder are included) has contact of order ≥ 2 with a surface S at p, then it is the osculating paraboloid of S at p.


- e. If two surfaces have contact of order ≥ 2 at p, then the osculating paraboloids of S and S¯ at p coincide. Conclude that the Gaussian and mean curvatures of S and S¯ at p are equal.
- f. The notion of contact of order ≥ 2 is invariant by diffeomorphisms of R3; that is, if S and S¯ have contact of order ≥ 2 at p and ϕ: R3 → R3 is a diffeomorphism, then ϕ(S) and ϕ(S)¯ have contact of order ≥ 2 at ϕ(p).
- g. If S and S¯ have contact of order ≥ 2 at p, then


lim

r→0

d r2 = 0,

where d is the length of the segment cut by the surfaces in a straight line normal to Tp(S) = Tp(S)¯ , which is at a distance r from p.

- 9. (Contact of Curves.) Deﬁne contact of order ≥ n (n integer ≥ 1) for regular curves in R3 with a common point p and prove that


[Page 190]

- a. The notion of contact of order ≥ n is invariant by diffeomorphisms.
- b. Two curves have contact of order ≥ 1 at p if and only if they are tangent at p.


- 10. (Contact of Curves and Surfaces.) A curve C and a surface S, which have a common point p, have contact of order ≥ n (n integer ≥ 1) at p if there exists a curve C¯ ⊂ S passing through p such that C and C¯ have contact of order ≥ n at p. Prove that

- a. If f (x,y,z) = 0 is a representation of a neighborhood of p in S and α(t) = (x(t),y(t),z(t)) is a parametrization of C in p, with α(0) = p, then C and S have contact of order ≥ n if and only if

f (x(0),y(0),z(0)) = 0,

df dt = 0,...,

dnf

dtn = 0, where the derivatives are computed for t = 0.

- b. If a plane has contact of order ≥ 2 with a curve C at p, then this is the osculating plane of C at p.
- c. If a sphere has contact of order ≥ 3 with a curve C at p, and α(s) is a parametrization by arc length of this curve, with α(0) = p, then the center of the sphere is given by


α(0)+

1 k

n+

k′ k2τ

b. Such a sphere is called the osculating sphere of C at p.

- 11. Consider the monkey saddle S of Example 2. Construct the Dupin indicatrix at p = (0,0,0) using the deﬁnition of Sec. 3-2, and compare it with the curve obtained as the intersection of S with a plane paral-

lel to Tp(S) and close to p. Why are they not “approximately similar” (cf. Example 5 of Sec. 3-3)? Go through the argument of Example 5 of Sec. 3-3 and point out where it breaks down.

- 12. Consider the parametrized surface


x(u,v) = ?

sin ucosv,sin usin v,cosu+log tan

u 2 +ϕ(v)

?

, where ϕ is a differentiable function. Prove that

- a. The curves v = const. are contained in planes which pass through the z axis and intersect the surface under a constant angle θ given by


cosθ =

ϕ′ ?

1+(ϕ′)2

.

Conclude that the curves v = const. are lines of curvature of the surface.

[Page 191]

- b. The length of the segment of a tangent line to a curve v = const., determined by its point of tangency and the z axis, is constantly equal to 1. Conclude that the curves v = const. are tractrices (cf. Exercise 6).


- 13. Let F: R3 → R3 be the map (a similarity) deﬁned by F(p) = cp, p ∈ R3, c a positive constant. Let S ⊂ R3 be a regular surface and set F(S) = S¯. Show that S¯ is a regular surface, and ﬁnd formulas relating the Gaussian and mean curvatures, K and H, of S with the Gaussian and mean curvatures, K¯ and H¯ , of S¯.
- 14. Consider the surface obtained by rotating the curve y =x3, −1<x <1, about the line x = 1. Show that the points obtained by rotation of the origin (0,0) of the curve are planar points of the surface.


- *15. Give an example of a surface which has an isolated parabolic point p (that is, no other parabolic point is contained in some neighborhood of p).
- *16. Show that a surface which is compact (i.e., it is bounded and closed in R3) has an elliptic point.

- 17. Deﬁne Gaussian curvature for a nonorientable surface. Can you deﬁne mean curvature for a nonorientable surface?
- 18. Show that the Möbius strip of Fig. 3-1 can be parametrized by


x(u,v) = ??

2−v sin

u 2?

sin u,

?

2−v sin

u 2?

cosu,v cos

u 2?

and that its Gaussian curvature is

K = −

1 {14v2 +(2−v sin(u/2))2}2

.

- *19. Obtain the asymptotic curves of the one-sheeted hyperboloid x2 +y2 − z2 = 1.

20. Determine the umbilical points of the elipsoid

x2 a2 +

y2 b2 +

z2 c2 = 1.

- *21. Let S be a surface with orientation N. Let V ⊂ S be an open set in S and let f : V ⊂ S → R be any nowhere-zero differentiable function in V . Let v1 and v2 be two differentiable (tangent) vector ﬁelds in V such that at each point of V , v1 and v2 are orthonormal and v1 ∧v2 = N.


[Page 192]

- a. Prove that the Gaussian curvature K of V is given by

K =

?d(fN)(v1)∧d(fN)(v2),fN? f 3

.

The virtue of this formula is that by a clever choice of f we can often simplify the computation of K, as illustrated in part b.

- b. Apply the above result to show that if f is the restriction of


?

x2 a4 +

y2 b4 +

z2 c4

to the ellipsoid

x2 a2 +

y2 b2 +

z2 c2 = 1,

then the Gaussian curvature of the ellipsoid is K =

1 a2b2c2

1 f 4

.

- 22. (The Hessian.) Let h: S → R be a differentiable function on a surface S,


and let p ∈ S be a critical point of h (i.e., dhp = 0). Let w ∈ Tp(S) and let

α: (−ǫ,ǫ) → S be a parametrized curve with α(0) = p, α′(0) = w. Set

Hph(w) =

d2(h◦α) dt2 ?

t=0

.

- a. Let x: U → S be a parametrization of S at p, and show that (the fact that p is a critical point of h is essential here)

Hph(u′xu +v′xv) = huu(p)(u′)2 +2huv(p)u′v′ +hvv(p)(v′)2.

Conclude that Hph: Tp(S) → R is a well-deﬁned (i.e., it does not depend on the choice of x) quadratic form on Tp(S). Hph is called the Hessian of h at p.

- b. Let h: S → R be the height function of S relative to Tp(S); that is, h(q) = ?q −p,N(p)?, q ∈ S. Verify that p is a critical point of h and


thus that the Hessian Hph is well deﬁned. Show that if w ∈ Tp(S), |w| = 1, then

Hph(w) = normal curvature at p in the direction of w.

Conclude that the Hessian at p of the height function relative to Tp(S) is the second fundamental form of S at p.

[Page 193]

- 23. (Morse Functions on Surfaces.) A critical point p ∈ S of a differentiable function h: S → R is nondegenerate if the self-adjoint linear map Aph associated to the quadratic form Hph (cf. the appendix to Chap. 3) is nonsingular (here Hph is the Hessian of h at p; cf. Exercise 22). Otherwise, p is a degenerate critical point. A differentiable function on S is a Morse function if all its critical points are nondegenerate. Let hr: S ⊂ R3 → R be the distance function from S to r; i.e.,

hr(q) = ??q −r,q −r?, q ∈ S, r ∈ R3, r ?∈ S.

- a. Show that p ∈ S is a critical point of h, if and only if the straight line pr is normal to S at p.
- b. Let p be a critical point of hr: S → R. Let w ∈ Tp(S), |w| = 1, and let α: (−ǫ,ǫ) → S be a curve parametrized by arc length with α(0) = p, α′(0) = w. Prove that

Hphr(w) =

1 hr(p) −kn,

where kn is the normal curvature at p along the direction of w. Conclude that the orthonormal basis {e1,e2}, where e1 and e2 are along the principal directions of Tp(S), diagonalizes the self-adjoint linear map Aphr. Conclude further that p is a degenerate critical point of hr if and only if either hr(p) = 1/k1 or hr(p) = 1/k2, where k1 and k2 are the principal curvatures at p.

- c. Show that the set B = {r ∈ R3;hr is a Morse function}


is a dense set in R3; here dense in R3 means that in each neighborhood of a given point of R3 there exists a point of B (this shows that on any regular surface there are “many” Morse functions).

- 24. (Local Convexity and Curvature). A surface S ⊂ R3 is locally convex at a point p ∈ S if there exists a neighborhood V ⊂ S of p such that V is contained in one of the closed half-spaces determined by Tp(S) in R3. If, in addition, V has only one common point with Tp(S), then S is called strictly locally convex at p.


- a. ProvethatS isstrictlylocallyconvexatp iftheprincipalcurvaturesof S at p are nonzero with the same sign (that is, the Gaussian curvature K(p) satisﬁes K(p) > 0).
- b. Prove that if S is locally convex at p, then the principal curvatures at p do not have different signs (thus, K(p) ≥ 0).
- c. To show that K ≥ 0 does not imply local convexity, consider the surface f (x,y) = x3(1+y2), deﬁned in the open


[Page 194]

set U = {(x,y) ∈ R2;y2 < 21}. Show that the Gaussian curvature of this surface is nonnegative on U and yet the surface is not locally

convex at (0,0) ∈ U (a deep theorem, due to R. Sacksteder, implies that such an example cannot be extended to the entire R2 if we insist on keeping the curvature nonnegative; cf. Remark 3 of Sec. 5-6).

*d. The example of part c is also very special in the following local sense. Let p be a point in a surface S, and assume that there exists a neighborhood V ⊂ S of p such that the principal curvatures on V do not have different signs (this does not happen in the example of part c). Prove that S is locally convex at p.

###### 3-4. Vector Fields†

In this section we shall use the fundamental theorems of ordinary differential equations (existence, uniqueness, and dependence on the initial conditions) to prove the existence of certain coordinate systems on surfaces.

If the reader is willing to assume the results of Corollaries 2, 3, and 4 at the end of this section (which can be understood without reading the section), this material may be omitted on a ﬁrst reading.

We shall begin with a geometric presentation of the material on differential equations that we intend to use.

A vector ﬁeld in an open set U ⊂ R2 is a map which assigns to each

- q ∈ U a vector w(q) ∈ R2. The vector ﬁeld w is said to be differentiable if writing q = (x,y) and w(q) = (a(x,y),b(x,y)), the functions a and b are differentiable functions in U.


Geometrically, the deﬁnition corresponds to assigning to each point (x,y) ∈ U a vector with coordinates a(x,y) and b(x,y) which vary differentiably with (x,y) (Fig. 3-24).

y

x 0

(x,y)

(a(x,y), b(x,y))

###### Figure 3-24

In what follows we shall consider only differentiable vector ﬁelds. In Fig. 3-25 some examples of vector ﬁelds are shown.

†This section may be omitted on a ﬁrst reading.

[Page 195]

w = (y, –x) w = (x, y)

###### Figure 3-25

Given a vector ﬁeld w, it is natural to ask whether there exists a trajectory of this ﬁeld, that is, whether there exists a differentiable parametrized curve α(t) = (x(t),y(t)), t ∈ I, such that α′(t) = w(α(t)).

For instance, a trajectory, passing through the point (x0,y0), of the vector ﬁeld w(x,y) = (x,y) is the straight line α(t) = (x0et,y0et), t ∈ R, and a trajectory of w(x,y) = (y,−x), passing through (x0,y0), is the circle β(t) = (r sin t,r cost), t ∈ R, r2 = x02 +y02.

In the language of ordinary differential equations, one says that the vector ﬁeld w determines a system of differential equations,

dx dt = a(x,y), dy dt = b(x,y),

###### (1)

and that a trajectory of w is a solution to Eq. (1).

The fundamental theorem of (local) existence and uniqueness of solutions of Eq. (1) is equivalent to the following statement on trajectories (in what follows, the letters I and J will denote open intervals of the line R, containing the origin 0 ∈ R).

THEOREM 1. Let w be a vector ﬁeld in an open set U ⊂ R2. Given p ∈ U, there exists a trajectory α: I → U of w (i.e., α′(t) = w(α(t)), t ∈ I) with α(0) = p. This trajectory is unique in the following sense: Any other trajectory β: J → U with β(0) = p agrees with α in I ∩J.

An important complement to Theorem 1 is the fact that the trajectory passing through p “varies differentiably with p.” This idea can be made precise

- as follows.


[Page 196]

THEOREM 2. Let w be a vector ﬁeld in an open set U ⊂ R2. For each p ∈ U there exist a neighborhood V ⊂ U of p, an interval I, and a mapping α: V ×I → U such that

- 1. For a ﬁxed q ∈ V, the curve α(q,t), t ∈ I, is the trajectory of w passing through q; that is,

α(q,0) = q,

∂α ∂t

(q,t) = w(α(q,t)).

- 2. α is differentiable.


Geometrically Theorem 2 means that all trajectories which pass, for t = 0, in a certain neighborhood V of p may be “collected” into a single differentiable map. It is in this sense that we say that the trajectories depend differentiably on p (Fig. 3-26).

U

V

V×I

q

###### Figure 3-26

The map α is called the (local) ﬂow of w at p. Theorems 1 and 2 will be assumed in this book; for a proof, one can consult, for instance, W. Hurewicz, Lectures on Ordinary Differential Equations, M.I.T. Press, Cambridge, Mass., 1958, Chap. 2. For our purposes, we need the following consequence of these theorems.

LEMMA. Let w be a vector ﬁeld in an open set U ⊂ R2 and let p ∈ U be such that w(p) ?= 0. Then there exist a neighborhood W ⊂ U of p and a differentiable function f: W → R such that f is constant along each trajectory of w and dfq ?= 0 for all q ∈ W.

Proof. Choose a Cartesian coordinate system in R2 such that p = (0,0) and w(p) is in the direction of the x axis. Let α: V ×I → U be the local ﬂow

- at p, V ⊂ U, t ∈ I, and let α˜ be the restriction of α to the rectangle


[Page 197]

(V ×I)∩{(x,y,t) ∈ R3;x = 0}.

(See Fig. 3-27.) By the deﬁnition of local ﬂow, dα˜p maps the unit vector of the t axis into w and maps the unit vector of the y axis into itself. Therefore, dα˜p is nonsingular. It follows that there exists a neighborhood W ⊂ U of p, where α˜−1 is deﬁned and differentiable. The projection of α˜−1(x,y) onto the y axis is a differentiable function ξ = f (x,y), which has the same value ξ for all points of the trajectory passing through (0,ξ). Since dα˜p is nonsingular, W may be taken sufﬁciently small so that df q ?= 0 for all q ∈ W. f is therefore the required function. Q.E.D.

I

y

t

V

0

w

x

–1(x,y)

(x,y)

α˜

˜α

###### Figure 3-27

The function f of the above lemma is called a (local) ﬁrst integral of w in a neighborhood of p. For instance, if w(x,y) = (y,−x) is deﬁned in R2, a ﬁrst integral f : R2 −{(0,0)} → R is f (x,y) = x2 +y2.

Closely associated with the concept of vector ﬁeld is the concept of ﬁeld of directions.

A ﬁeld of directions r in an open set U ⊂ R2 is a correspondence which assigns to each p ∈ U a line r(p) in R2 passing through p. r is said to be differentiable at p ∈ U if there exists a nonzero differentiable vector ﬁeld w, deﬁned in a neighborhood V ⊂ U of p, such that for each q ∈ V , w(q) ?= 0 is a basis of r(q); r is differentiable in U if it is differentiable for every p ∈ U.

To each nonzero differentiable vector ﬁeld w in U ⊂ R2, there corresponds a differentiable ﬁeld of directions given by r(p) = line generated by w(p),

- p ∈ U. By its very deﬁnition, each differentiable ﬁeld of directions gives rise,


locally, to a nonzero differentiable vector ﬁeld. This, however, is not true

[Page 198]

globally, as is shown by the ﬁeld of directions in R2 −{(0,0)} given by the tangent lines to the curves of Fig. 3-28; any attempt to orient these curves in order to obtain a differentiable nonzero vector ﬁeld leads to a contradiction.

AregularconnectedcurveC ⊂ U isanintegralcurveofaﬁeldofdirections

- r deﬁned in U ⊂ R2 if r(q) is the tangent line to C at q for all q ∈ C. By what has been seen previously, it is clear that given a differentiable


ﬁeld of directions r in an open set U ⊂ R2, there passes, for each q ∈ U, an integral curve C of r; C agrees locally with the trace of a trajectory through

- q of the vector ﬁeld determined in U by r. In what follows, we shall consider only differentiable ﬁelds of directions and shall omit, in general, the word differentiable.


Figure 3-28. A nonorientable ﬁeld of directions in R2 −{(0,0)}.

A natural way of describing a ﬁeld of directions is as follows. We say that two nonzero vectors w1 and w2 at q ∈ R2 are equivalent if w1 = λw2 for some λ ∈ R, λ ?= 0. Two such vectors represent the same straight line passing through q, and, conversely, if two nonzero vectors belong to the same straight line passing through q, they are equivalent. Thus, a ﬁeld of directions r on an open set U ⊂ R2 can be given by assigning to each q ∈ U a pair of real numbers (r1,r2) (the coordinates of a nonzero vector belonging to r), where we consider the pairs (r1,r2) and (λr1,λr2), λ ?= 0, as equivalent.

In the language of differential equations, a ﬁeld of directions r is usually given by

a(x,y)

dx dt +b(x,y)

dy dt = 0, (2)

which simply means that at a point q = (x,y) we associate the line passing through q that contains the vector (b,−a) or any of its nonzero multiples (Fig. 3-29). The trace of the trajectory of the vector ﬁeld (b,−a) is an integral curve of r. Because the parametrization plays no role in the above considerations, it is often used, instead of Eq. (2), the expression

a dx +b dy = 0 with the same meaning as before.

[Page 199]

(x,y)

(b,–a) 0

x

y

r

An integral curve

Figure 3-29. The differential equation adx +bdy = 0.

The ideas introduced above belong to the domain of the local facts of R2, which depend only on the “differentiable structure” of R2. They can, therefore, be transported to a regular surface, without further difﬁculties, as follows.

DEFINITION 1. A vector ﬁeld w in an open set U ⊂ S of a regular surface S is a correspondence which assigns to each p ∈ U a vector w(p) ∈ Tp(S). The vector ﬁeld w is differentiable at p ∈ U if, for some parametrization x(u,v) at p, the functions a(u,v) and b(u,v) given by

w(p) = a(u,v)xu +b(u,v)xv

are differentiable functions at p; it is clear that this deﬁnition does not depend on the choice of x.

We can deﬁne, similarly, trajectories, ﬁeld of directions, and integral curves. Theorems l and 2 and the lemma above extend easily to the present situation; up to a change of R2 by S, the statements are exactly the same.

- Example 1. AvectorﬁeldintheusualtorusT isobtainedbyparametrizing the meridians of T by arc length and deﬁning w(p) as the velocity vector of the meridian through p (Fig. 3-30). Notice that |w(p)| = 1 for all p ∈ T . It is left as an exercise (Exercise 2) to verify that w is differentiable.
- Example 2. A similar procedure, this time on the sphere S2 and using the semimeridians of S2, yields a vector ﬁeld w deﬁned in the sphere minus the two poles N and S. To obtain a vector ﬁeld deﬁned in the whole sphere,


[Page 200]

###### Figure 3-30 Figure 3-31

reparametrize all the semimeridians by the same parameter t, −1 < t < 1, and deﬁne v(p) = (1−t2)w(p) for p ∈ S2 −{N}∪{S} and v(N) = v(S) = 0 (Fig. 3-31).

Example 3. Let S = {(x,y,z) ∈ R3;z = x2 −y2} be the hyperbolic paraboloid. The intersection with S of the planes z = const. ?= 0 determines a family of curves {Cα} such that through each point of S −{(0,0,0)} there passes one curve Cα. The tangent lines to such curves give a differentiable ﬁeld of directions r on S −{(0,0,0)}. We want to ﬁnd a ﬁeld of directions

- r′ on S −{(0,0,0)} that is orthogonal to r at each point and to determine the integral curves of r′. r′ is called the orthogonal ﬁeld to r, and its integral curves are called the orthogonal family of r (cf. Exercise 15, Sec. 2-5).


We begin by parametrizing S by

x(u,v) = (u,v,u2 −v2), u = x, v = y.

The family {Cα} is given by u2 −v2 = const. ?= 0 (or rather by the image under x of this set). If u′xu +v′xv is a tangent vector of a regular parametrization of some curve Cα, we obtain, by differentiating u2 −v2 = const.,

2uu′ −2vv′ = 0.

Thus, (u′,v′) = (−v,−u). It follows that r is given, in the parametrization x, by the pair (v,u) or any of its nonzero multiples.

Now, let (a(u,v),b(u,v)) be an expression for the orthogonal ﬁeld r′, in the parametrization x. Since

E = 1+4u2, F = −4uv, G = 1+4v2, and r′ is orthogonal to r at each point, we have

Eav +F(bv +au)+Gbu = 0

[Page 201]

or

(1+4u2)av −4uv(bv +au)+(1+4v2)bu = 0. It follows that

va +ub = 0. (3)

This determines the pair (a,b) at each point, up to a nonzero multiple, and hence the ﬁeld r′.

To ﬁnd the integral curves of r′, let u′xu +v′xv be a tangent vector of some regular parametrization of an integral curve of r′. Then (u′,v′) satisﬁes

- Eq. (3); that is, vu′ +uv′ = 0


or

uv = const.

It follows that the orthogonal family of {Cα} is given by the intersections with S of the hyperbolic cylinders xy = const. ?= 0.

The main result of this section is the following theorem.

THEOREM. Let w1 and w2 be two vector ﬁelds in an open set U ⊂ S, which are linearly independent at some point p ∈ U. Then it is possible to parametrize a neighborhood V ⊂ U of p in such a way that for each q ∈ V the coordinate curves of this parametrization passing through q are tangent to the lines determined by w1(q) and w2(q).

Proof. Let W be a neighborhood of p where the ﬁrst integrals f1 and f2 of w1 and w2, respectively, are deﬁned. Deﬁne a map ϕ: W → R2 by

ϕ(q) = (f1(q),f2(q)), q ∈ W. Since f1 is constant on the trajectories of w1 and (df 1) ?= 0, we have at p dϕp(w1) = ((df 1)p(w1),(df 2)p(w1)) = (0,a),

- where a = (df 2)p(w1) ?= 0, since w1 and w2 are linearly independent. Similarly,

dϕp(w2) = (b,0),

- where b = (df 1)p(w2) ?= 0. It follows that dϕp is nonsingular, and hence that ϕ is a local diffeomor-


phism. There exists, therefore, a neighborhood U¯ ⊂ R2 of ϕ(p) which is mapped diffeomorphically by x = ϕ−1 onto a neighborhood V = x(U)¯ of p; that is, x is a parametrization of S at p, whose coordinate curves

f1(q) = const., f2(q) = const., are tangent at q to the lines determined by w1(q),w2(q), respectively. Q.E.D.

[Page 202]

It should be remarked that the theorem does not imply that the coordinate curves can be so parametrized that their velocity vectors are w1(q) and w2(q). The statement of the theorem applies to the coordinate curves as regular (point set) curves; more precisely, we have

COROLLARY 1. Given two ﬁelds of directions r and r′ in an open set U ⊂ S such that at p ∈ U, r(p) ?= r′(p), there exists a parametrization x in a neighborhood of p such that the coordinate curves of x are the integral curves of r and r′.

A ﬁrst application of the above theorem is the proof of the existence of an orthogonal parametrization at any point of a regular surface.

COROLLARY 2. For all p ∈ S there exists a parametrization x(u,v) in a neighborhood V of p such that the coordinate curves u = const., v = const. intersect orthogonally for each q ∈ V (such an x is called an orthogonal parametrization).

Proof. Consider an arbitrary parametrization x¯: U¯ → S at p, and deﬁne two vector ﬁelds w1 = x¯u¯, w2 = −(F/¯ E)¯ x¯u¯ +x¯v¯ in x¯(U)¯ , where E,¯ F,¯ G¯ are the coefﬁcients of the ﬁrst fundamental form in x¯. Since w1(q),w2(q) are orthogonal vectors, for each q ∈ x¯(U)¯ , an application of the theorem yields the required parametrization. Q.E.D.

Asecond application of the theorem (more precisely, of Corollary 1) is the existence of coordinates given by the asymptotic and principal directions. As we have seen in Sec. 3-3, the asymptotic curves are solutions of

e(u′)2 +2fu′v′ +g(v′)2 = 0.

In a neighborhood of a hyperbolic point p, we have eg −f2 < 0. Rotate the plane uv so that e(p) > 0. Then the left-hand side of the above equation can be decomposed into two distinct linear factors, yielding

(Au′ +Bv′)(Au′ +Dv′) = 0, (4) where the coefﬁcients are determined by

A2 = e, A(B +D) = 2f, BD = g. The above system of equations has real solutions, since eg −f2 < 0. Thus,

- Eq. (4) gives rise to two equations:


Au′ +Bv′ = 0, (4a) Au′ +Dv′ = 0. (4b)

Each of these equations determines a differentiable ﬁeld of directions (for instance, Eq. (4a) determines the direction r which contains the nonzero

[Page 203]

vector (B,−A)), and at each point of the neighborhood in question the directions given by Eqs. (4a) and (4b) are distinct. By applying Corollary 1, we see that it is possible to parametrize a neighborhood of p in such a way that the coordinate curves are the integral curves of Eqs. (4a) and (4b). In other words,

COROLLARY 3. Let p ∈ S be a hyperbolic point of S. Then it is possible to parametrize a neighborhood of p in such a way that the coordinate curves of this parametrization are the asymptotic curves of S.

Example 4. Analmosttrivialexample, butonewhichillustratesthemechanism of the above method, is given by the hyperbolic paraboloid z = x2 −y2. As usual we parametrize the entire surface by

x(u,v) = (u,v,u2 −v2). A simple computation shows that

e =

2 (1+4u2 +4v2)1/2

, f = 0, g = −

2 (1+4u2 +4v2)1/2

.

Thus, the equation of the asymptotic curves can be written as

2 (1+4u2 +4v2)1/2

((u′)2 −(v′)2) = 0,

which can be factored into two linear equations and give the two ﬁelds of directions:

r1: u′ +v′ = 0, r2: u′ −v′ = 0.

The integral curves of these ﬁelds of directions are given by the two families of curves:

r1: u+v = const., r2: u−v = const.

Now, the functions f1(u,v) = u+v, f2(u,v) = u−v are clearly ﬁrst integrals of the vector ﬁelds associated to r1 and r2, respectively. Thus, by setting

u¯ = u+v, v¯ = u−v,

we obtain a new parametrization for the entire surface z = x2 −y2 in which the coordinate curves are the asymptotic curves of the surface.

In this particular case, the change of parameters holds for the entire surface. In general, it may fail to be globally one-to-one, even if the whole surface consists only of hyperbolic points.

[Page 204]

Similarly, in a neighborhood of a nonumbilical point of S, it is possible to decompose the differential equation of the lines of curvature into distinct linear factors. By an analogous argument we obtain

COROLLARY 4. Let p ∈ S be a nonumbilical point of S. Then it is possible to parametrize a neighborhood of p in such a way that the coordinate curves of this parametrization are the lines of curvature of S.

###### EXERCISES

- 1. Prove that the differentiability of a vector ﬁeld does not depend on the choice of a coordinate system.
- 2. Prove that the vector ﬁeld obtained on the torus by parametrizing all its meridians by arc length and taking their tangent vectors (Example 1) is differentiable.
- 3. Prove that a vector ﬁeld w deﬁned on a regular surface S ⊂ R3 is differentiable if and only if it is differentiable as a map w: S → R3.
- 4. Let S be a surface and x: U → S be a parametrization of S. Then a(u,v)u′ +b(u,v)v′ = 0,

where a and b are differentiable functions, determines a ﬁeld of directions r on x(U), namely, the correspondence which assigns to each x(u,v) the straight line containing the vector bxu −axv. Show that a necessary and sufﬁcient condition for the existence of an orthogonal ﬁeld r′ on x(U) (cf. Example 3) is that both functions

Eb −Fa, Fb −Ga

are nowhere simultaneously zero (here E, F, and G are the coefﬁcients of the ﬁrst fundamental form in x) and that r′ is then determined by

(Eb −Fa)u′ +(Fb −Ga)v′ = 0.

- 5. Let S be a surface and x: U → S be a parametrization of S. If ac −b2 < 0, show that


a(u,v)(u′)2 +2b(u,v)u′v′ +c(u,v)(v′)2 = 0

can be factored into two distinct equations, each of which determines a ﬁeld of directions on x(U) ⊂ S. Prove that these two ﬁelds of directions are orthogonal if and only if

Ec −2Fb +Ga = 0.

[Page 205]

z

α

r

υ

y u r

x

0

###### Figure 3-32

- 6. A straight line r meets the z axis and moves in such a way that it makes a constant angle α ?= 0 with the z axis and each of its points describes a helix of pitch c ?= 0 about the z axis. The ﬁgure described by r is the trace of the parametrized surface (see Fig. 3-32)

x(u,v) = (v sin α cosu,v sin α sin u,v cosα +cu).

x is easily seen to be a regular parametrized surface (cf. Exercise 13, Sec. 2-5). Restrict the parameters (u,v) to an open set U so that x(U) = S is a regular surface (cf. Prop. 2, Sec. 2-3).

- a. Findtheorthogonalfamily(cf. Example3)tothefamilyofcoordinate curves u = const.
- b. Use the curves u = const. and their orthogonal family to obtain an orthogonal parametrization for S. Show that in the new parameters (u,¯ v)¯ the coefﬁcients of the ﬁrst fundamental form are


G¯ = 1, F¯ = 0, E¯ = {c2 +(v¯ −cu¯ cosα)2}sin2 α.

- 7. Deﬁne the derivative w(f) of a differentiable function f: U ⊂ S → R relative to a vector ﬁeld w in U by


w(f)(q) =

d dt

(f ◦α)?

t=0

, q ∈ U,

where α: I → S is a curve such that α(0) = q, α′(0) = w(q). Prove that

- a. w is differentiable in U if and only if w(f) is differentiable for all differentiable f in U.


[Page 206]

- b. Let λ and μ be real numbers and g: U ⊂ S → R be a differentiable function on U; then


w(λf +μf ) = λw(f)+μw(f), w(fg) = w(f)g +fw(g).

- 8. Showthatifw isadifferentiablevectorﬁeldonasurfaceS andw(p) ?= 0 for some p ∈ S, then it is possible to parametrize a neighborhood of p by x(u,v) in such a way that xu = w.
- 9. a. Let A: V → W be a nonsingular linear map of vector spaces V and W of dimension 2 and endowed with inner products ?, ? and (, ), respectively. A is a similitude if there exists a real number λ ?= 0

such that (Av1,Av2) = λ?v1,v2? for all vectors v1,v2 ∈ V . Assume that A is not a similitude and show that there exists a unique pair of orthonormal vectors e1 and e2 in V such that Ae1,Ae2 are orthogonal in W.

b. Use part a to prove Tissot’s theorem: Let ϕ: U1 ⊂ S1 → S2 be a diffeomorphism from a neighborhood U1 of a point p of a surface S1 into a surface S2. Assume that the linear map dϕ is nowhere a similitude. Then it is possible to parametrize a neighborhood of p in S1 by an orthogonal parametrization x1: U → S1 in such a way that ϕ ◦x1 = x2: U → S2 is also an orthogonal parametrization in a neighborhood of ϕ(p) ∈ S2.

- 10. Let T be the torus of Example 6 of Sec. 2-2 and deﬁne a map ϕ: R2 → T by


ϕ(u,v) = ((r cosu+a)cosv,(r cosu+a)sin v,r sin u),

where u and v are the Cartesian coordinates of R2. Let u = at, v = bt be a straight line in R2, passing by (0,0) ∈ R2, and consider the curve in T α(t) = ϕ(at,bt). Prove that

a. ϕ is a local diffeomorphism. b. The curve α(t) is a regular curve; α(t) is a closed curve if and only

if b/a is a rational number.

*c. If b/a is irrational, the curve α(t) is dense in T ; that is, in each

neighborhood of a point p ∈ T there exists a point of α(t).

- *11. Use the local uniqueness of trajectories of a vector ﬁeld w in U ⊂ S to prove the following result. Given p ∈ U, there exists a unique trajectory α:I → U ofw, withα(0) = p, whichismaximal inthefollowingsense: Any other trajectory β: J → U, with β(0) = p, is the restriction of α to J (i.e., J ⊂ I and α|J = β).


[Page 207]

- *12. Prove that if w is a differentiable vector ﬁeld on a compact surface S and α(t) is the maximal trajectory of w with α(0) = p ∈ S, then α(t) is deﬁned for all t ∈ R.


13. Construct a differentiable vector ﬁeld on an open disk of the plane (which is not compact) such that a maximal trajectory α(t) is not deﬁned for all t ∈ R (this shows that the compactness condition of Exercise 12 is essential).

###### 3-5. Ruled Surfaces and Minimal Surfaces†

In differential geometry one ﬁnds quite a number of special cases (surfaces of revolution, parallel surfaces, ruled surfaces, minimal surfaces, etc.) which may either become interesting in their own right (like minimal surfaces), or giveabeautifulexampleofthepowerandlimitationsofdifferentiablemethods in geometry. According to the spirit of this book, we have so far treated these special cases in examples and exercises.

It might be useful, however, to present some of these topics in more detail. We intend to do that now. We shall use this section to develop the theory of ruled surfaces and to give an introduction to the theory of minimal surfaces. Throughout the section it will be convenient to use the notion of parametrized surface deﬁned in Sec. 2-3.

If the reader wishes so, the entire section or one of its topics may be omitted. Except for a reference to Sec. A in Example 6 of Sec. B, the two topics are independent and their results will not be used in any essential way in this book.

###### A. Ruled Surfaces

A (differentiable) one-parameter family of (straight) lines {α(t),w(t)} is a correspondence that assigns to each t ∈ I a point α(t) ∈ R3 and a vector w(t) ∈ R3, w(t) ?= 0, so that both α(t) and w(t) depend differentiably on t. For each t ∈ I, the line Lt which passes through α(t) and is parallel to w(t) is called the line of the family at t.

Given a one-parameter family of lines {α(t),w(t)}, the parametrized surface

x(t,v) = α(t)+vw(t), t ∈ I, v ∈ R,

is called the ruled surface generated by the family {α(t),w(t)}. The lines Lt are called the rulings, and the curve α(t) is called a directrix of the surface x. Sometimes we use the expression ruled surface to mean the trace of x.

†This section may be omitted on a ﬁrst reading.

[Page 208]

It should be noticed that we also allow x to have singular points, that is, points (t,v) where xt ∧xv = 0.

Example 1. The simplest examples of ruled surfaces are the tangent surfaces to a regular curve (cf. Example 4, Sec. 2-3), the cylinders and the cones. A cylinder is a ruled surface generated by a one-parameter family of lines {α(t),w(t)}, t ∈ I, where α(I) is contained in a plane P and w(t) is parallel to a ﬁxed direction in R3 (Fig. 3-33(a)). A cone is a ruled surface generated by a family {α(t),w(t)}, t ∈ I, where α(I) ⊂ P and the rulings Lt all pass through a point p ?∈ P (Fig. 3-33(b)).

P

w

P

p

(a) (b)

α(I)

w(t)

α(I)

###### Figure 3-33

Example 2. Let S1 be the unit circle x2 +y2 = 1 in the xy plane, and let α(s)beaparametrizationofS1 byarclength. Foreachs, letw(s) = α′(s)+e3, where e3 is the unit vector of the z axis (Fig. 3-34). Then

x(s,v) = α(s)+v(α′(s)+e3)

x2 + y2 – z2 = 1

e3

w(s)

α'(s) α(s)

x

y

z

0

Figure 3-34. x2 +y2 −z2 = 1 as a ruled surface.

[Page 209]

is a ruled surface. It can be put into a more familiar form if we write

x(s,v) = (coss −v sin s,sin s +v coss,v)

and notice that x2 +y2 −z2 = 1+v2 −v2 = 1. This shows that the trace of x is a hyperboloid of revolution.

It is interesting to observe that if we take w(s) = −α′(s)+e3, we again obtain the same surface. This shows that the hyperboloid of revolution has two sets of rulings.

We have deﬁned ruled surfaces in such a way that allows the appearance of singularities. This is necessary if we want to include tangent surfaces and cones. We shall soon show, at least for ruled surfaces that satisfy some reasonable condition, that the singularities of such a surface (if any) will concentrate along a curve of this surface.

We shall now start the study of general ruled surfaces. We can assume, without loss of generality, that |w(t)| = 1, t ∈ I. To be able to develop the theory, we need the nontrivial assumption that w′(t) ?= 0 for all t ∈ I. If the zeros of w′(t) are isolated, we can divide our surface into pieces such that the theory can be applied to each of them. However, if the zeros of w′(t) have cluster points, the situation may become complicated and will not be treated here.

The assumption w′(t) ?= 0, t ∈ I, is usually expressed by saying that the ruled surface x is noncylindrical.

Unless otherwise stated, we shall assume that

x(t,v) = α(t)+vw(t) (1)

is a noncylindrical ruled surface with |w(t)| = 1, t ∈ I. Notice that the assumption |w(t)| ≡ 1 implies that ?w(t),w′(t)? = 0 for all t ∈ I.

We ﬁrst want to ﬁnd a parametrized curve β(t) such that ?β′(t),w′(t)? = 0, t ∈ I, and β(t) lies on the trace of x; that is,

β(t) = α(t)+u(t)w(t), (2)

for some real-valued function u = u(t). Assuming the existence of such a curve β, one obtains

β′ = α′ +u′w +uw′; hence, since ?w,w′? = 0,

0 = ?β′,w′? = ?α′,w′?+u?w′,w′?. It follows that u = u(t) is given by

u = −

?α′,w′? ?w′,w′?

(3) Thus, if we deﬁne β(t) by Eqs. (2) and (3), we obtain the required curve.

[Page 210]

We shall now show that the curve β does not depend on the choice of the directrix α for the ruled surface. β is then called the line of striction, and its points are called the central points of the ruled surface.

To prove our claim, let α¯ be another directrix of the ruled surface; that is, let, for all (t,v),

x(t,v) = α(t)+vw(t) = α(t)¯ +sw(t) (4) for some function s = s(v). Then, from Eqs. (2) and (3) we obtain

β −β¯ = (α −α)¯ +

?¯α′ −α′,w′? ?w′,w′?

w,

where β¯ is the line of striction corresponding to α¯. On the other hand, Eq. (4) implies that

α −α¯ = (s −v)w(t). Thus,

β −β¯ = ?(s −v)+

?(v −s)w′,w′? ?w′,w′?

?w = 0,

since ?w,w′? = 0. This proves our claim.

We now take the line of striction as the directrix of the ruled surface and write it as follows:

x(t,u) = β(t)+uw(t). (5) With this choice, we have

xt = β′ +uw′, xu = w and

xt ∧xu = β′ ∧w +uw′ ∧w.

Since ?w′,w? = 0 and ?w′,β′? = 0, we conclude that β′ ∧w = λw′ for some function λ = λ(t). Thus,

|xt ∧xu|2 = |λw′ +uw′ ∧w|2

= λ2|w′|2 +u2|w′|2 = (λ2 +u2)|w′|2.

It follows that the only singular points of the ruled surface (5) are along the line of striction u = 0, and they will occur if and only if λ(t) = 0. Observe also that

λ =

(β′,w,w′) |w′|2

,

where, as usual, (β′,w,w′) is a short for ?β′ ∧w,w′?.

[Page 211]

Let us compute the Gaussian curvature of the surface (5) at its regular points. Since

xtt = β′′ +uw′′, xtu = w′, xuu = 0,

we have, for the coefﬁcients of the second fundamental form,

g = 0, f =

(xt,xu,xut) |xt ∧xu|

=

(β′,w,w′) |xt ∧xu|

;

hence (since g = 0 we do not need the value of e to compute K),

K =

eg −f2 EG −F2 = −

λ2|w′|4 (λ2 +u2)2|w′|4

= −

λ2 (λ2 +u2)2

###### . (6)

This shows that, at regular points, the Gaussian curvature K of a ruled surface satisﬁes K ≤ 0, and K is zero only along those rulings which meet the line of striction at a singular point.

Equation (6) allows us to give a geometric interpretation of the (regular) central points of a ruled surface. Indeed, the points of a ruling, except perhaps the central point, are regular points of the surface. If λ ?= 0, the function |K(u)| is a continuous function on the ruling and, by Eq. (6), the central point is characterized by the fact that |K(u)| has a maximum there.

ForanothergeometricalinterpretationofthelineofstrictionseeExercise4. We also remark that the curvature K takes up the same values at points on

a ruling that are symmetric relative to the central point (this justiﬁes the name central).

The function λ(t) is called the distribution parameter of x. Since the line of striction is independent of the choice of the directrix, it follows that the same holds for λ. If x is regular, we have the following interpretation of λ. The normal vector to the surface at (t,u) is

N(t,u) =

xt ∧xu |xt ∧xu|

=

λw′ +uw′ ∧w √λ2 +u2|w′|

.

On the other hand (λ ?= 0),

N(t,0) =

w′ |w′|

λ |λ|

Therefore, if θ is the angle formed by N(t,u) and N(t,0),

tan θ =

u |λ|

###### . (7)

Thus, if θ is the angle which the normal vector at a point of a ruling makes with the normal vector at the central point of this ruling, then tan θ is proportional

[Page 212]

to the distance between these two points, and the coefﬁcient of proportionality is the inverse of the distribution parameter.

Example 3. Let S be the hyperbolic paraboloid z = kxy, k ?= 0. To show that S is a ruled surface, we observe that the lines y = z/tk, x = t, for each t ?= 0 belong to S. If we take the intersection of this family of lines with the plane z = 0, we obtain the curve x = t, y = 0, z = 0. Taking this curve as directrix and vectors w(t) parallel to the lines y = z/tk, x = t, we obtain

α(t) = (t,0,0), w(t) =

(0,1,kt) √1+k2t2

.

This gives a ruled surface (Fig. 3-35)

x(t,v) = α(t)+vw(t) = ?t,

v √1+k2t2

,

vkt √1+k2t2

?, t ∈ R,v ∈ R,

the trace of which clearly agrees with S.

z

y

x

l

t

1

θ

t

Figure 3-35. z = xy as a ruled surface.

Since α′(t) = (1,0,0), we obtain that the line of striction is α itself. The distribution parameter is

λ =

1 k

.

We also remark that the tangent of the angle θ which w(t) makes with w(0) is tan θ = tk.

The last remark leads to an interesting general property of a ruled surface. If we consider the family of normal vectors along a ruling of a regular ruled

[Page 213]

surface, this family generates another ruled surface. By Eq. (7) and the last remark, the latter surface is exactly the hyperbolic paraboloid z = kxy, where 1/k is the value of the distribution parameter at the chosen ruling.

Among the ruled surfaces, the developables play a distinguished role. Let us start again with an arbitrary ruled surface (not necessarily non-cylindrical)

x(t,v) = α(t)+vw(t), (8)

generated by the family {α(t),w(t)} with |w(t)| ≡ 1. The surface (8) is said to be developable if

(w,w′,α′) ≡ 0. (9)

To ﬁnd a geometric interpretation for condition (9), we shall compute the Gaussian curvature of a developable surface at a regular point. Acomputation entirely similar to the one made to obtain Eq. (6) gives

g = 0, f =

(w,w′,α′) |xt ∧xv|

.

By condition (9), f ≡ 0; hence,

K =

eg −f2 EG −F2 ≡ 0.

This implies that, at regular points, the Gaussian curvature of a developable surface is identically zero.

For another geometric interpretation of a developable surface, see Exercise 6.

We can now distinguish two nonexhaustive cases of developable surfaces:

- 1. w(t)∧w′(t) ≡ 0. This implies that w′(t) ≡ 0. Thus, w(t) is constant and the ruled surface is a cylinder over a curve obtained by intersecting the cylinder with a plane normal to w(t).
- 2. w(t)∧w′(t) ?= 0 for all t ∈ I. In this case w′(t) ?= 0 for all t ∈ I. Thus, the surface is noncylindrical, and we can apply our previous work. Thus, we can determine the line of striction (2) and check that the distribution parameter


λ =

(β′,w,w′) |w′|2

###### ≡ 0. (10)

Therefore, the line of striction will be the locus of singular points of the developable surface. If β′(t) ?= 0 for all t ∈ I, it follows from Eq. (10) and the fact that ?β′,w′? ≡ 0 that w is parallel to β′. Thus, the ruled surface is the tangent surface of β. If β′(t) = 0 for all t ∈ I, then the line of striction is a point, and the ruled surface is a cone with vertex at this point.

[Page 214]

Of course, the above cases do not exhaust all possibilities.As usual, if there is a clustering of zeros of the functions involved, the analysis may become rather complicated. At any rate, away from these cluster points, a developable surface is a union of pieces of cylinders, cones, and tangent surfaces.

As we have seen, at regular points, the Gaussian curvature of a developable surface is identically zero. In Sec. 5-8 we shall prove a sort of global converse to this which implies that a regular surface S ⊂ R3 which is closed as a subset of R3 and has zero Gaussian curvature is a cylinder.

Example 4 (The Envelope of the Family of Tangent Planes Along a Curve of a Surface). Let S be a regular surface and α = α(s) a curve on S parametrized by arc length.Assume that α is nowhere tangent to an asymptotic direction. Consider the ruled surface

x(s,v) = α(s)+v

N(s)∧N′(s) |N′(s)|

###### , (11)

where by N(s) we denote the unit normal vector of S restricted to the curve α(s) (since α′(s) is not an asymptotic direction, N′(s) ?= 0 for all s). We shall show that x is a developable surface which is regular in a neighborhood of v = 0 and is tangent to S along v = 0. Before that, however, let us give a geometric interpretation of the surface x.

Consider the family {Tα(s)(S)} of tangent planes to the surface S along the curve α(s). If ?s is small, the two planes Tα(s)(S) and Tα(s+?s)(S) of the family will intersect along a straight line parallel to the vector

N(s)∧N(s +?s) ?s

.

If we let ?s go to zero, this straight line will approach a limiting position parallel to the vector

lim

?s→0

N(s)∧N(s +?s) ?s = lim

?s→0

N(s)∧

(N(s +?s)−N(s)) ?s

= N(s)∧N′(s).

This means intuitively that the rulings of x are the limiting positions of the intersection of neighboring planes of the family {Tα(s)(S)}. x is called the envelope of the family of tangent planes of S along α(s) (Fig. 3-36).

For instance, if α is a parametrization of a parallel of a sphere S2, then the envelope of tangent planes of S2 along α is either a cylinder, if the parallel is an equator, or a cone, if the parallel is not an equator (Fig. 3-37).

[Page 215]

α(s)

α(s+∆s)

N(s) ∧ N(s + ∆s)

Tα(s + ∆s) (s)

s Tα(s)(s)

###### Figure 3-36

| | |
|---|---|
| | |
| | |


Nonequatorial parallel

Equator

Figure 3-37. Envelopes of families of tangent planes along parallels of a sphere.

To show that x is a developable surface, we shall check that condition (9) holds for x. In fact, by a straightforward computation, we obtain

?

N ∧N′ |N′|

∧?

N ∧N′ |N′|

?′ ,α′? = ?

N ∧N′ |N′|

∧

(N ∧N′)′ |N′|

,α′?

=

1 |N′|2

??N ∧N′,N′′?N,α′? = 0.

This proves our claim.

[Page 216]

We shall now prove that x is regular in a neighborhood of v = 0 and that it is tangent to S along α. In fact, at v = 0, we have

xs ∧xv = α′ ∧

(N ∧N′) |N′|

= ?N′,α′?

N |N′|

= −?N,α′′?

N |N′|

= −

(knN) |N′|

,

where kn = kn(s) is the normal curvature of α. Since kn(s) is nowhere zero, this shows that x is regular in a neighborhood of v = 0 and that the unit normal vector of x at x(s,0) agrees with N(s). Thus, x is tangent to S along v = 0, and this completes the proof of our assertions.

We shall summarize our conclusions as follows. Let α(s) be a curve parametrized by arc length on a surface S and assume that α is nowhere tangent to an asymptotic direction. Then the envelope (11) of the family of tangent planes to S along α is a developable surface, regular in a neighborhood of α(s) and tangent to S along α(s).

###### B. Minimal Surfaces

A regular parametrized surface is called minimal if its mean curvature vanishes everywhere. A regular surface S ⊂ R3 is minimal if each of its parametrizations is minimal.

Toexplainwhyweusethewordminimalforsuchsurfaces, weneedtointroduce the notion of a variation. Let x: U ⊂ R2 → R3 be a regular parametrized surface. Choose a bounded domain D ⊂ U (cf. Sec. 2-5) and a differentiable function h: D¯ → R, where D¯ is the union of the domain D with its boundary ∂D. The normal variation of x(D)¯ , determined by h, is the map (Fig. 3-38) given by,

ϕ: D¯ ×(−ǫ,ǫ) → R3 ϕ(u,v,t) = x(u,v)+th(u,v)N(u,v), (u,v) ∈ D,t¯ ∈ (−ǫ,ǫ). For each ﬁxed t ∈ (−ǫ,ǫ), the map xt: D → R3

x′(u,v) = ϕ(u,v,t) is a parametrized surface with

∂xt

- ∂u = xu +thNu +thuN, ∂xt

- ∂v = xv +thNv +thvN.


[Page 217]

hN

thN –thN 0

(x + thN)(D)

(x – thN)(D)

x(D)

Figure 3-38. A normal variation of x(D).

Thus, if we denote by Et, Ft, Gt the coefﬁcients of the ﬁrst fundamental form of xt, we obtain

Et = E +th(?xu,Nu?+?xu,Nu?)+t2h2?Nu,Nu?+t2huhu, Ft = F +th(?xu,Nv?+?xv,Nu?)+t2h2?Nu,Nv?+t2huhv, Gt = G+th(?xv,Nv?+?xv,Nv?)+t2h2?Nv,Nv?+t2hvhv.

By using the fact that

?xu,Nu? = −e, ?xu,Nv?+?xv,Nu? = −2f, ?xv,Nv? = −g and that the mean curvature H is (Sec. 3-3, Eq. (5))

H =

1 2

Eg −2fF +Ge EG −F2

, we obtain

EtGt −(F′)2 = EG −F2 −2th(Eg −2FJ +Ge)+R

= (EG −F2)(1−4thH)+R, where limt→0(R/t) = 0.

It follows that if ǫ is sufﬁciently small, xt is a regular parametrized surface. Furthermore, the area A(t) of xt(D)¯ is

A(t) = ?

D¯

?

EtGt −(Ft)2 dudv

= ?

D¯

?

1−4thH +R¯

?

EG −F2 du dv,

where R¯ = R/(EG −F2). It follows that if ǫ is small, A is a differentiable function and its derivative at t = 0 is

A′(0) = −?

D¯

2hH

?

EG −F2 du dv (12)

[Page 218]

We are now prepared to justify the use of the word minimal in connection with surfaces with vanishing mean curvature.

PROPOSITION 1. Let x: U → R3 be a regular parametrized surface and let D ⊂ U be a bounded domain in U. Then x is minimal if and only if A′(0) = 0 for all such D and all normal variations of x(D)¯ .

Proof. If x is minimal, H ≡ 0 and the condition is clearly satisﬁed. Conversely, assume that the condition is satisﬁed and that H(q) ?= 0 for some q ∈ D. Choose h: D¯ → R such that h(q) = H(q), hH > 0, and h is identically zero outside a small neighborhood of q. Then A′(0) < 0 for the variation determined by this h, and that is a contradiction. Q.E.D.

Thus, any bounded region x(D)¯ of a minimal surface x is a critical point for the area function of any normal variation of x(D)¯ . It should be noticed that this critical point may not be a minimum and that this makes the word minimal seem somewhat awkward. It is, however, a time-honored terminology which was introduced by Lagrange (who ﬁrst deﬁned a minimal surface) in 1760.

Minimalsurfacesareusuallyassociatedwithsoapﬁlmsthatcanbeobtained by dipping a wire frame into a soap solution and withdrawing it carefully. If the experiment is well performed, a soap ﬁlm is obtained that has the same frame as a boundary. It can be shown by physical considerations that the ﬁlm will assume a position where at its regular points the mean curvature is zero. In this way we can “manufacture” beautiful minimal surfaces, such as the one in Fig. 3-39.

###### Figure 3-39

Remark 1. It should be pointed out that not all soap ﬁlms are minimal surfaces according to our deﬁnition. We have assumed minimal surfaces to be regular (we could have assumed some isolated singular points, but to go beyond that would make the treatment much less elementary). However, soap

[Page 219]

###### Figure 3-40

ﬁlms can be formed, for instance, using a cube as a frame (Fig. 3-40), that have singularities along lines.

Remark 2. The connection between minimal surfaces and soap ﬁlms motivated the celebrated Plateau’s problem (Plateau was a Belgian physicist who made careful experiments with soap ﬁlms around 1850). The problem can be roughly described as follows: to prove that for each closed curve C ⊂ R3 there exists a surface S of minimum area with C as boundary. To make the problem precise (which curves and surfaces are allowed and what is meant by C being a boundary of S) is itself a nontrivial part of the problem.Aversion of Plateau’s problem was solved simultaneously by Douglas and Radó in 1930. Further versions (and generalizations of the problem for higher dimensions) have inspired the creation of mathematical entities which include at least as many things as soap-like ﬁlms. We refer the interested reader to the Chap. 2 of Lawson [20] (references are at the end of the book) for further details and a recent bibliography of Plateau’s problem.

It will be convenient to introduce, for an arbitrary parametrized regular surface, the mean curvature vector deﬁned by H = HN. The geometrical meaning of the direction of H can be obtained from Eq. (12). Indeed, if we choose h = H, we have, for this particular variation,

A′(0) = −2?

D¯

?H,H??

EG −F2 du dv < 0.

This means that if we deform x(D¯ ) in the direction of the vector H, the area is initially decreasing.

The mean curvature vector has another interpretation which we shall now pursue, since it has important implications for the theory of minimal surfaces.

[Page 220]

A regular parametrized surface x = x(u,v) is said to be isothermal if ?xu,xu? = ?xv,xv? and ?xu,xv) = 0.

PROPOSITION 2. Let x = x(u,v) be a regular parametrized surface and assume that x is isothermal. Then

xuu +xvv = 2λ2H, where λ2 = ?xu,xu? = ?xv,xv?.

Proof. Since x is isothermal, ?xu,xu? = ?xv,xv? and ?xu,xv? = 0. By differentiation, we obtain

?xuu,xu? = ?xvu,xv? = −?xu,xvv?. Thus,

- ?xuu +xvv,xu? = 0. Similarly,
- ?xuu +xvv,xv? = 0. It follows that xuu +xvv is parallel to N. Since x is isothermal, H =


- 1

- 2


g +e λ2

.

Thus,

2λ2H = g +e = ?N,xuu +xvv?; hence,

###### xuu +xvv = 2λ2H. Q.E.D.

The Laplacian ?f of a differentiable function f : U ⊂ R2 → R is deﬁned by ?f = (∂2f/∂u2)+(∂2f/∂v2), (u,v) ∈ U. We say that f is harmonic in U if ?f = 0. From Prop. 2, we obtain

COROLLARY: Let x(u,v) = (x(u,v),y(u,v),z(u,v)) be a parametrized surface and assume that x is isothermal. Then x is minimal if and only if its coordinate functions x, y, z are harmonic.

Example 5. The catenoid, given by x(u,v) = (a cosh v cosu,a cosh v sin u,av),

0 < u < 2π, −∞ < v < ∞.

This is the surface generated by rotating the catenary y = a cosh(z/a) about the z axis (Fig. 3-41). It is easily checked that E = G = a2 cosh2 v,F = 0,

[Page 221]

a

z

x

y

y = a cosh(z/a)

###### Figure 3-41

and that xuu +xvv = 0. Thus, the catenoid is a minimal surface. It can be characterized as the only surface of revolution which is minimal.

The last assertion can be proved as follows. We want to ﬁnd a curve y = f (x) such that, when rotated about the x axis, it describes a minimal surface. Since the parallels and the meridians of a surface of revolution are lines of curvature of the surface (Sec. 3-3, Example 4), we must have that the curvature of the curve y = f (x) is the negative of the normal curvature of the circle generatedbythepointf (x)(bothareprincipalcurvatures). Sincethecurvature of y = f (x) is

y′′ (1+(y′)2)3/2

and the normal curvature of the circle is the projection of its usual curvature (=1/y) over the normal N to the surface (see Fig. 3-42), we obtain

y′′ (1+(y′)2)3/2 = −

1 y

cosϕ.

y y = f(x)

0

q

q

j

N

y

x

###### Figure 3-42

[Page 222]

But −cosϕ = cosθ (see Fig. 3-42), and since tan θ = y′, we obtain y′′ (1+(y′)2)3/2 =

1 y

1 (1+(y′)2)1/2 as the equation to be satisﬁed by the curve y = f (x).

Clearly, there exists a point x where f′(x) ?= 0. Let us work in a neighborhood of this point where f′ ?= 0. Multiplying both members of the above equation by 2y′, we obtain,

2y′′y′ 1+(y′)2 =

2y′ y

.

Setting 1+(y′)2 = z (hence, 2y′′y′ = z′), we have

z′ z =

2y′ y

,

which, by integration, gives (k is a constant)

log z = log y2 +log k2 = log(yk)2 or

1+(y′)2 = z = (yk)2. The last expression can be written

k dy ?

(yk)2 −1 = k dx, which, again by integration, gives (c is a constant)

cosh−1(yk) = kx +c or

y =

1 k

cosh(kx +c).

Thus, in the neighborhood of a point where f′ ?= 0, the curve y = f (x) is a catenary. But then y′ can only be zero at x = 0, and if the surface is to be connected, it is by continuity a catenoid, as we claimed.

Example 6 (The Helicoid). (cf. Example 3, Sec. 2-5.) x(u,v) = (a sinh v cosu,a sinh v sin u,au).

It is easily checked that E = G = a2 cosh2 v,F = 0, and xuu +xvv = 0. Thus, the helicoid is a minimal surface. It has the additional property that

[Page 223]

it is the only minimal surface, other than the plane, which is also a ruled surface.

We can give a proof of the last assertion if we assume that the zeros of the Gaussian curvature of a minimal surface are isolated (for a proof, see, for instance, the survey of Osserman quoted at the end of this section, p. 76). Granted this, we shall proceed as follows.

Assume that the surface is not a plane. Then in some neighborhood W of the surface the Gaussian curvature K is strictly negative. Since the mean curvature is zero, W is covered by two families of asymptotic curves which intersect orthogonally. Since the rulings are asymptotic curves and the surface is not a plane, we can choose a point q ∈ W such that the asymptotic curve, other than the ruling, passing through q has nonzero torsion τ =

√

−K at q. Since the osculating plane of an asymptotic curve is the tangent plane to the surface, there is a neighborhood V ⊂ W such that the rulings of V are principal normals to the family of twisted asymptotic curves (Fig. 3-43). It is an interesting exercise in curves to prove that this can occur if and only if the twisted curves are circular helices (cf. Exercise 18, Sec. 1-5). Thus, V is a part of a helicoid. Since the torsion of a circular helix is constant, we easily see that the whole surface is part of a helicoid, as we claimed.

The helicoid and the catenoid were discovered in 1776 by Meusnier, who also proved that Lagrange’s deﬁnition of minimal surfaces as critical points of a variational problem is equivalent to the vanishing of the mean curvature. For a long time, they were the only known examples of minimal surfaces. Only in 1835 did Scherk ﬁnd further examples, one of which is described

t

n

q w

Nonrectilinear asymptotic curves

###### Figure 3-43

[Page 224]

in Example 8. In Exercise 14, we shall describe an interesting connection between the helicoid and the catenoid.

Example 7 (Enneper’s Minimal Surface). Enneper’s surface is the parametrized surface

x(u,v) = ?u−

u3 3 +uv2,v −

v3 3 +vu2,u2 −v2?, (u,v) ∈ R2,

which is easily seen to be minimal (Fig. 3-44). Notice that by changing (u,v) into (−v,u) we change, in the surface, (x,y,z) into (−y,x,−z). Thus, if we perform a positive rotation of π/2 about the z axis and follow it by a symmetry in the xy plane, the surface remains invariant.

An interesting feature of Enneper’s surface is that it has self-intersections. This can be shown by setting u = ρ cosθ, v = ρ sin θ and writing

x(ρ,θ) = ?ρ cosθ −

ρ3 3

cos3θ,ρ sin θ +

ρ3 3

sin 3θ,ρ2 cos2θ?.

y

z

x

Figure 3-44. Enneper’s surface. Reproduced, with modiﬁcations, from K. Leichtweiss, “Minimalﬂächen im Grossen,” Überblicke Math. 2 (1969), 7–49, Fig. 4, with permission.

[Page 225]

Thus, if x(ρ1,θ1) = x(ρ2,θ2), a straightforward computation shows that

x2 +y2 = ρ12 +

ρ16 9 −cos4θ1

2ρ14 3

- = ?ρ1 +

ρ13 3 ?2 −

4 3

(ρ12 cos2θ1)2

- = ?ρ2 +


ρ23 3 ?2 −

4 3

(ρ22 cos2θ2)2.

Hence, since ρ12 cos2θ1 = ρ22 cos2θ2, we obtain

ρ1 +

ρ13 3 = ρ2 +

ρ23 3

,

which implies that ρ1 = ρ2. It follows that cos2θ1 = cos2θ2. If, for instance, ρ1 = ρ2 and θ1 = 2π −θ2, we obtain from

y(ρ1,θ1) = y(ρ2,θ2)

that y = −y. Hence, y = 0; that is, the points (ρ1,θ1) and (ρ2,θ2) belong to the curve sin θ +(ρ2/3)sin 3θ = 0. Clearly, for each point (ρ,θ) belonging to this curve, the point (ρ,2π −θ) also belongs to it, and

x(ρ,θ) = x(ρ,2π −θ),z(ρ,θ) = z(ρ,2π −θ).

Thus, the intersection of the surface with the plane y = 0 is a curve along which the surface intersects itself.

Similarly, it can be shown that the intersection of the surface with the plane x = 0 is also a curve of self-intersection (this corresponds to the case ρ1 = ρ2, θ1 = π −θ2). It is easily seen that they are the only self-intersections of Enneper’s surface.

I want to thank Alcides Lins Neto for having worked out this example in order to draw a ﬁrst sketch of Fig. 3-44.

Before going into the next example, we shall establish a useful relation between minimal surfaces and analytic functions of a complex variable. Let C denote the complex plane, which is, as usual, identiﬁed with R2 by setting ζ = u+iv, ζ ∈ C, (u,v) ∈ R2. We recall that a function f : U ⊂ C → C is analytic when, by writing

[Page 226]

f (ζ) = f1(u,v)+if2(u,v),

the real functions f1 and f2 have continuous partial derivatives of ﬁrst order which satisfy the so-called Cauchy-Riemann equations:

∂f1 ∂u =

∂f2 ∂v

,

∂f1 ∂v = −

∂f2 ∂u

.

Now let x: U ⊂ R2 → R3 be a regular parametrized surface and deﬁne complex functions ϕ1, ϕ2, ϕ3 by

ϕ1(ζ) =

∂x ∂u −i

∂x ∂v

, ϕ2(ζ) =

∂y ∂u −i

∂y ∂v

, ϕ3(ζ) =

∂z ∂u −i

∂z ∂v

,

where x,y, and z are the component functions of x.

LEMMA. x is isothermal if and only if ϕ12 +ϕ22 +ϕ32 ≡ 0. If this last condition is satisﬁed, x is minimal if and only if ϕ1, ϕ2, and ϕ3 are analytic functions.

Proof. By a simple computation, we obtain that

ϕ12 +ϕ22 +ϕ32 = E −G+2iF, whence the ﬁrst part of the lemma. Furthermore, xuu +xvv = 0 if and only if

∂ ∂u ?

∂x ∂u? = −

∂ ∂v ?

∂x ∂v ?,

∂ ∂u ?

∂y ∂u? = −

∂ ∂v ?

∂y ∂v?,

∂ ∂u ?

∂z ∂u? = −

∂ ∂v ?

∂z ∂v?,

which give one-half of the Cauchy-Riemann equations for ϕ1, ϕ2, ϕ3. Since the other half is automatically satisﬁed, we conclude that xuu +xvv = 0 if and only if ϕ1, ϕ2, and ϕ3 are analytic. Q.E.D.

Example 8 (Scherk’s Minimal Surface). This is given by

x(u,v) = ?arg

ζ +i ζ −i

,arg

ζ +1 ζ −1

,log ?

ζ2 +1 ζ2 −1?

?,

ζ ?= ±1,ζ ?= ±i, where ζ = u+iv, and arg ζ is the angle that the real axis makes with ζ.

[Page 227]

We easily compute that

arg

ζ +i ζ −i = tan−1 2u

u2 +v2 −1

,

arg

ζ +1 ζ −1 = tan−1 −2v

u2 +v2 −1 log ?

ζ2 +1 ζ2 −1? =

- 1

- 2


log

(u2 −v2 +1)2 +4u2v2 (u2 −v2 −1)2 +4u2v2;

hence,

ϕ1 =

∂x ∂u −i

∂x ∂v = −

2 1+ζ2

, ϕ2 = −

2i 1−ζ2

, ϕ3 =

4ζ 1−ζ4

.

Since ϕ12 +ϕ22 +ϕ32 ≡ 0 and ϕ1, ϕ2, and ϕ3 are analytic, x is an isothermal parametrization of a minimal surface.

It is easily seen from the expressions of x,y, and z that

z = log

cosy cosx

.

This representation shows that Scherk’s surface is deﬁned on the chessboard pattern of Fig. 3-45 (except at the vertices of the squares, where the surface is actually a vertical line).

Minimalsurfacesareperhapsthebest-studiedsurfacesindifferentialgeometry, and we have barely touched the subject.Avery readable introduction can be found in R. Osserman, A Survey of Minimal Surfaces, Van Nostrand Mathematical Studies, Van Nostrand Reinhold, New York, 1969. The theory has developed into a rich branch of differential geometry in which interesting and nontrivial questions are still being investigated. It has deep connections with analytic functions of complex variables and partial differential equations. As a rule, the results of the theory have the charming quality that they are easy to visualize and very hard to prove. To convey to the reader some ﬂavor of the subject we shall close this brief account by stating without proof one striking result.

THEOREM (Osserman). Let S ⊂ R3 be a regular, closed (as a subset of R3) minimal surface in R3 which is not a plane. Then the image of the Gauss map N: S → S2 is dense in the sphere S2 (that is, arbitrarily close to any point of S2 there is a point of N(S) ⊂ S2).

A proof of this theorem can be found in Osserman’s survey, quoted above. Actually, the theorem is somewhat stronger in that it applies to complete surfaces, a concept to be deﬁned in Sec. 5-3.

[Page 228]

| | | | |
|---|---|---|---|
| |–π 2| | |
|– π– 2| |π– 2<br><br>0| |
| | | | |


(a) (b)

–π π

(c)

Figure 3-45. Scherk’s surface.

###### EXERCISES

- 1. Show that the helicoid (cf. Example 3, Sec. 2-5) is a ruled surface, its line of striction is the z axis, and its distribution parameter is constant.
- 2. Show that on the hyperboloid of revolution x2 +y2 −z2 = 1, the parallel of least radius is the line of striction, the rulings meet it under a constant angle, and the distribution parameter is constant.


[Page 229]

- 3. Let α: I → S ⊂ R3 be a curve on a regular surface S and consider the ruled surface generated by the family {α(t),N(t)}, where N(t) is the normal to the surface at α(t). Prove that α(I) ⊂ S is a line of curvature in S if and only if this ruled surface is developable.
- 4. Assume that a noncylindrical ruled surface x(t,v) = α(t)+vw(t), |w| = 1,

is regular. Let w(t1), w(t2) be the directions of two rulings of x and let x(t1,v1), x(t2,v2) be the feet of the common perpendicular to these two rulings. As t2 → t1, these points tend to a point x(t1,v)¯ . To determine (t1,v)¯ prove the following:

- a. Theunitvectorofthecommonperpendicularconvergestoaunitvector tangent to the surface at (t1,v)¯ . Conclude that, at (t1,v)¯ ,

?w′ ∧w,N) = 0.

- b. v¯ = −(?α′,w′?/?w′,w′?).


Thus, (t1,v)¯ is the central point of the ruling through t1, and this gives another interpretation of the line of striction (assumed nonsingular).

- 5. A right conoid is a ruled surface whose rulings Lt intersect perpendicularly at ﬁxed axis r which does not meet the directrix α: I → R3.

a. Find a parametrization for the right conoid and determine a condition

that implies it to be noncyliodrical.

b. Given a noncylindrical right conoid, ﬁnd the line of striction and the

distribution parameter.

- 6. Let x(t,v) = α(t)+vw(t)

be a developable surface. Prove that at a regular point we have ?Nv,xv? = ?Nv,xt? = 0.

Concludethat the tangentplaneofadevelopablesurfaceisconstantalong (the regular points of) a ﬁxed ruling.

- 7. Let S be a regular surface and let C ⊂ S be a regular curve on S, nowhere tangent to an asymptotic direction. Consider the envelope of the family of tangent planes of S along C. Prove that the direction of the ruling that passesthroughapointp ∈ C isconjugatetothetangentdirectionofC atp.
- 8. Show that if C ⊂ S2 is a parallel of unit sphere S2, then the envelope of tangent planes of S2 along C is either a cylinder, if C is an equator, or a cone, if C is not an equator.


[Page 230]

- 9. (Focal Surfaces.) Let S be a regular surface without parabolic or umbilical points. Let x: U → S be a parametrization of S such that the coordinate curves are lines of curvature (if U is small, this is no restriction. cf. Corollary 4, Sec. 3-4). The parametrized surfaces

y(u,v) = x(u,v)+ρ1N(u,v), z(u,v) = x(u,v)+ρ2N(u,v),

where ρ1 = 1/k1, ρ2 = 1/k2, are called focal surfaces of x(U) (or surfaces of centers of x(U); this terminology comes from the fact that y(u,v), for instance, is the center of the osculating circle (cf. Sec. 1-6, Exercise 2) of the normal section at x(u,v) corresponding to the principal curvature k1). Prove that

- a. If (k1)u and (k2)v are nowhere zero, then y and z are regular parametrized surfaces.
- b. At the regular points, the directions on a focal surface corresponding to the principal directions on x(U) are conjugate. That means, for instance, thatyu andyv areconjugatevectorsiny(U)forall(u,v) ∈ U.
- c. A focal surface, say y, can be constructed as follows: Consider the line of curvature x(u,const.) on x(U), and construct the developable surface generated by the normals of x(U) along the curve x(u,const.) (cf. Exercise3).Thelineofstrictionofsuchadevelopableliesony(U), andasx(u,const.)describesx(U), thislinedescribesy(U)(Fig. 3-46).


- 10. Example 4 can be generalized as follows. A one-parameter differentiable family of planes {α(t),N(t)} is a correspondence which assigns to each t ∈ I apointα(t) ∈ R3 andaunitvectorN(t) ∈ R3 insuchawaythatboth α, andN aredifferentiablemaps.Afamily{α(t),N(t)}, t ∈ I, issaidtobe a family of tangent planes if α′(t) ?= 0, N′(t) ?= 0, and ?α′(t),N(t)? = 0 for all t ∈ I.


- a. Give a proof that a differentiable one-parameter family of tangent planes {α(t),N(t)} determines a differentiable one-parameter family of lines {α(t),(N ∧N′)/|N′|} which generates a developable surface

x(t,v) = α(t)+v

N ∧N′ |N′|

. (∗)

The surface (∗) is called the envelope of the family {α(t),N(t)}.

- b. Prove that if α′(t)∧(N(t)∧N′(t)) ?= 0 for all t ∈ I, then the envelope (∗) is regular in a neighborhood of v = 0, and the unit normal vector of x at (t,0) is N(t).
- c. Let α = α(s) be a curve in R3 parametrized by arc length. Assume that the curvature k(s) and the torsion τ(s) of α are nowhere zero.


[Page 231]

x(u,υ)

y(u,υ)

ρ1

S

Figure 3-46. Construction of a focal surface.

Prove that the family of osculating planes {α(s),b{s)} is a oneparameter differentiable family of tangent planes and that the envelope of this family is the tangent surface to α(s) (cf. Example 5, Sec. 2-3).

- 11. Let x = x(u,v) be a regular parametrized surface. A parallel surface to x is a parametrized surface


y(u,v) = x(u,v)+aN(u,v), where a is a constant.

- a. Prove that yu ∧yv = (1−2Ha +Ka2)(xu ∧xv), where K and H are the Gaussian and mean curvatures of x, respectively.
- b. Prove that at the regular points, the Gaussian curvature of y is


K 1−2Ha +Ka2 and the mean curvature of y is

H −Ka 1−2Ha +Ka2

.

[Page 232]

- c. Let a surface x have constant mean curvature equal to c ?= 0 and consider the parallel surface to x at a distance 1/2c. Prove that this parallel surface has constant Gaussian curvature equal to 4c2.


- 12. Prove that there are no compact (i.e., bounded and closed in R3) minimal surfaces.
- 13. a. Let S be a regular surface without umbilical points. Prove that S is a minimal surface if and only if the Gauss map N: S → S2 satisﬁes, for all p ∈ S and all w1, w2 ∈ Tp(S),

?dNp(w1),dNp(w2)?N(p) = λ(p)?w1,w2?p,

where λ(p) ?= 0 is a number which depends only on p.

b. Let x: U → S2 be a parametrization of the unit sphere S2 by stereographic projection. Consider a neighborhood V of a point p of the minimal surface S in part a such that N: S → S2 restricted to V is a diffeomorphism (since K(p) = det(dNp) ?= 0, such a V exists by the inverse function theorem). Prove that the parametrization y = N−1 ◦ x: U → S is isothermal (this gives a way of introducing isothermal parametrizations on minimal surfaces without planar points).

- 14. When two differentiable functions f , g: U ⊂ R2 → R satisfy the Cauchy-Riemann equations


∂f ∂u =

∂g ∂v

,

∂f ∂v = −

∂g ∂u

,

they are easily seen to be harmonic; in this situation, f and g are said to be harmonic conjugate. Let x and y be isothermal parametrizations of minimal surfaces such that their component functions are pairwise harmonic conjugate; thenxandyarecalledconjugateminimalsurfaces. Provethat

- a. The helicoid and the catenoid are conjugate minimal surfaces.
- b. Given two conjugate minimal surfaces, x and y, the surface

z = (cost)x +(sin t)y (*)

is again minimal for all t ∈ R.

- c. All surfaces of the one-parameter family (∗) have the same fundamen-


tal form: E = ?xu,xu? = ?yv,yv?, F = 0, G = ?xv,xv? = ?yu,yu?.

Thus, any two conjugate minimal surfaces can be joined through a one-parameter family of minimal surfaces, and the ﬁrst fundamental form of this family is independent of t.

[Page 233]

Appendix Self-Adjoint Linear

Maps and Quadratic Forms

In this appendix, V will denote a vector space of dimension 2, endowed with an inner product ? , ?. All that follows can be easily extended to a ﬁnite n-dimensional vector space, but for the sake of simplicity, we shall treat only the case n = 2.

We say that a linear map A: V → V is self-adjoint if ?Av,w? = ?v,Aw? for all v,w ∈ V .

Notice that if {e1,e2} is an orthonormal basis for V and (αij), i,j = 1,2, is the matrix of A relative to that basis, then

?Aej,ei? = αij = ?ej,Aei? = ?Aei,ej? = αji;

that is, the matrix (αij) is symmetric.

To each self-adjoint linear map we associate a map B: V ×V → R deﬁned by

B(v,w) = ?Av,w?.

B is clearly bilinear; that is, it is linear in both v and w. Moreover, the fact that A is self-adjoint implies that B(v,w) = B(w,v); that is, B is a bilinear symmetric form in V .

Conversely, if B is a bilinear symmetric form in V , we can deﬁne a linear map A: V → V by ?Av,w? = B(v,w) and the symmetry of B implies that A is self-adjoint.

On the other hand, to each symmetric, bilinear form B in V , there corresponds a quadratic form Q in V given by

Q(v) = B(v,v), v ∈ V,

###### 217

[Page 234]

and the knowledge of Q determines B completely, since B(u,v) = 21[Q(u+v)−Q(u)−Q(v)].

Thus, a one-to-one correspondence is established between quadratic forms in V and self-adjoint linear maps of V .

The goal of this appendix is to prove that (see the theorem below) given a self-adjoint linear map A: V → V , there exists an orthonormal basis for V such that relative to that basis the matrix of A is a diagonal matrix. Furthermore, the elements on the diagonal are the maximum and the minimum of the corresponding quadratic form restricted to the unit circle of V .

LEMMA. If the function Q(x,y) = ax2 +2bxy +cy2, restricted to the unit circle x2 +y2 = 1, has a maximum at the point (1,0), then b = 0.

Proof. Parametrize the circle x2 +y2 = 1 by x = cost, y = sin t, t ∈ (0−ǫ,2π +ǫ). Thus, Q, restricted to that circle, becomes a function of t:

Q(t) = a cos2 t +2b cost sin t +c sin2 t. Since Q has a maximum at the point (1,0) we have

?

dQ dt ?

t=0

= 2b = 0.

Hence, b = 0 as we wished. Q.E.D.

PROPOSITION. Given a quadratic form Q in V, there exists an orthonormal basis {e1,e2} of V such that if v ∈ V is given by v = xe1 +ye2, then

Q(v) = λ1x2 +λ2y2,

where λ1 and λ2 are the maximum and minimum, respectively, of Q on the unit circle |v| = 1.

Proof. Let λ1 be the maximum of Q on the unit circle |v| = 1, and let e1 be a unit vector with Q(e1) = λ1. Such an e1 exists by continuity of Q on the compact set |v| = 1. Let e2 be a unit vector that is orthogonal to e1, and set λ2 = Q(e2). We shall show that the basis {e1,e2} satisﬁes the conditions of the proposition.

Let B be the symmetric bilinear form that is associated to Q and set v = xe1 +ye2. Then

Q(v) = B(v,v) = B(xe1 +ye2,xe1 +ye2)

= λ1x2 +2bxy +λ2y2,

where b = B(e1,e2). By the lemma, b = 0, and it only remains to prove that λ2 is the minimum of Q in the circle |v| = 1. This is immediate because, for

[Page 235]

Appendix: Linear Maps and Quadratic Forms 219

any v = xe1 +ye2 with x2 +y2 = 1, we have that

Q(v) = λ1x2 +λ2y2 ≥ λ2(x2 +y2) = λ2, since λ2 ≤ λ1. Q.E.D.

We say that a vector v ?= 0 is an eigenvector of a linear map A: V → V if Av = λv for some real number λ; λ is then called an eigenvalue of A.

THEOREM. Let A: V → V be a self-adjoint linear map. Then there existsanorthonormalbasis{e1,e2}of Vsuchthat A(e1) = λ1e1, A(e2) = λ2e2 (that is, e1 and e2 are eigenvectors, and λ1, λ2 are eigenvalues of A). In the basis {e1,e2}, the matrix of A is clearly diagonal and the elements λ1, λ2, λ1 ≥ λ2, on the diagonal are the maximum and the minimum, respectively, of the quadratic form Q(v) = ?Av,v? on the unit circle of V.

Proof. Consider the quadratic form Q(v) = ?Av,v?. By the proposition above, there exists an orthonormal basis {e1,e2} of V , with Q(e1) = λ1, Q(e2) = λ2 ≤ λ1, where λ1 and λ2 are the maximum and minimum, respectively, of Q in the unit circle. It remains, therefore, to prove that

A(e1) = λ1e1, A(e2) = λ2(e2).

Since B(e1,e2) = ?Ae1,e2? = 0 (by the lemma) and e2 ?= 0, we have that either Ae1 is parallel to e1 or Ae1 = 0. If Ae1 is parallel to e1, then Ae1 = αe1, and since ?Ae1,e1? = λ1 = ?αe1,e2? = α, we conclude that Ae1 = λ1e1; if Ae1 = 0, then λ1 = ?Ae1,e1? = 0, and Ae1 = 0 = λ1e1. Thus, we have in any case that Ae1 = λ1e1.

Now using the fact that

B(e1,e2) = ?Ae2,e1? = 0 and that

?Ae2,e2? = λ2, we can prove in the same way that Ae2 = λ2e2. Q.E.D.

Remark. The extension of the above results to an n-dimensional vector space, n > 2, requires only the following precaution. In the previous proposition, we choose the maximum λ1 = Q(e1) of Q in the unit sphere, and then show that Q restricts to a quadratic form Q1 in the subspace V1 orthogonal to e1. We choose for λ2 = Q1(e2) the maximum of Q1 in the unit sphere of V1, and so forth.

[Page 236]

4 The Intrinsic Geometry

of Surfaces

###### 4-1. Introduction

In Chap. 2 we introduced the ﬁrst fundamental form of a surface S and showed how it can be used to compute simple metric concepts on S (length, angle, area, etc.). The important point is that such computations can be made without “leaving” the surface, once the ﬁrst fundamental form is known. Because of this, these concepts are said to be intrinsic to the surface S.

The geometry of the ﬁrst fundamental form, however, does not exhaust itselfwiththesimpleconceptsmentionedabove.Asweshallseeinthischapter, many important local properties of a surface can be expressed only in terms of the ﬁrst fundamental form. The study of such properties is called the intrinsic geometry of the surface. This chapter is dedicated to intrinsic geometry.

- In Sec. 4-2 we shall deﬁne the notion of isometry, which essentially makes

precise the intuitive idea of two surfaces having “the same” ﬁrst fundamental forms.

- In Sec. 4-3 we shall prove the celebrated Gauss formula that expresses the


Gaussian curvature K as a function of the coefﬁcients of the ﬁrst fundamental form and its derivatives. This means that K is an intrinsic concept, a very striking fact if we consider that K was deﬁned using the second fundamental form.

In Sec. 4-4 we shall start a systematic study of intrinsic geometry. It turns out that the subject can be uniﬁed through the concept of covariant derivative of a vector ﬁeld on a surface. This is a generalization of the usual derivative of a vector ﬁeld on the plane and plays a fundamental role throughout the chapter.

###### 220

[Page 237]

Section 4-5 is devoted to the Gauss-Bonnet theorem both in its local and global versions. This is probably the most important theorem of this book. Even in a short course, one should make an effort to reach Sec. 4-5.

- In Sec. 4-6 we shall deﬁne the exponential map and use it to introduce two special coordinate systems, namely, the normal coordinates and the geodesic polar coordinates.
- In Sec. 4-7 we shall take up some delicate points on the theory of geodesics which were left aside in the previous sections. For instance, we shall prove the existence, for each point p of a surface S, of a neighborhood of p in S which is a normal neighborhood of all its points (the deﬁnition of normal neighborhood isgiveninSec. 4-6). ThisresultandarelatedoneareusedinChap. 5; however, it is probably convenient to assume them and omit Sec. 4-7 on a ﬁrst reading. We shall also prove the existence of convex neighborhoods, but this is used nowhere else in the book.


###### 4-2. Isometries; Conformal Maps

Examples 1 and 2 of Sec. 2-5 display an interesting peculiarity. Although the cylinder and the plane are distinct surfaces, their ﬁrst fundamental forms are “equal” (at least in the coordinate neighborhoods that we have considered). This means that insofar as intrinsic metric questions are concerned (length, angle, area), the plane and the cylinder behave locally in the same way. (This is intuitively clear, since by cutting a cylinder along a generator we may unroll it onto a part of a plane.) In this chapter we shall see that many other important concepts associated to a regular surface depend only on the ﬁrst fundamental formandshouldbeincludedinthecategoryofintrinsicconcepts. Itistherefore convenient that we formulate in a precise way what is meant by two regular surfaces having equal ﬁrst fundamental forms.

S and S¯ will always denote regular surfaces. DEFINITION 1. A diffeomorphism ϕ: S → S¯ is an isometry if for all

- p ∈ S and all pairs w1,w2 ∈ Tp(S) we have ?w1,w2?p = ?dϕp(w1),dϕp(w2)?ϕ(p).


The surfaces S and S¯ are then said to be isometric.

In other words, a diffeomorphism ϕ is an isometry if the differential dϕ preserves the inner product. It follows that, dϕ being an isometry,

Ip(w) = ?w,w?p = ?dϕp(w),dϕp(w)?ϕ(p) = Iϕ(p)(dϕp(w))

for all w ∈ Tp(S). Conversely, if a diffeomorphism ϕ preserves the ﬁrst fundamental form, that is,

Ip(w) = Iϕ(p)(dϕp(w)) for all w ∈ Tp(S),

[Page 238]

then

2?w1,w2? = Ip(w1 +w2)−Ip(w1)−Ip(w2)

= Iϕ(p)(dϕp(w1 +w2))−Iϕ(p)(dϕp(w1))−Iϕ(p)(dϕp(w2))

= 2?dϕp(w1),dϕp(w2)?, and ϕ is, therefore, an isometry.

DEFINITION 2. A map ϕ: V → S¯ of a neighborhood V of p ∈ S is a local isometry at p if there exists a neighborhood V¯ of ϕ(p) ∈ S¯ such that ϕ: V → V¯ is an isometry. If there exists a local isometry into S¯ at every p ∈ S, the surface S is said to be locally isometric to S¯. S and S¯ are locally isometric if S is locally isometric to S¯ and S¯ is locally isometric to S.

It is clear that if ϕ: S → S¯ is a diffeomorphism and a local isometry for every p ∈ S, then ϕ is an isometry (globally). It may, however, happen that twosurfacesarelocallyisometricwithoutbeing(globally)isometric, asshown in the following example.

Example 1. Let ϕ be a map of the coordinate neighborhood x¯(U) of the cylinder given in Example 2 of Sec. 2-5 into the plane x(R2) of Example 1 of Sec. 2-5, deﬁned by ϕ = x ◦x¯−1 (we have changed x to x¯ in the parametrization of the cylinder). Then ϕ is a local isometry. In fact, each vector w, tangent to the cylinder at a point p ∈ x¯(U), is tangent to a curve x¯(u(t),v(t)), where (u(t),v(t)) is a curve in U ⊂ R2. Thus, w can be written as

w = x¯uu′ +x¯vv′. On the other hand, dϕ(w) is tangent to the curve ϕ(x¯(u(t),v(t))) = x(u(t),v(t)). Thus, dϕ(w) = xuu′ +xvv′. Since E = E,F¯ = F,G¯ = G¯ , we obtain Ip(w) = E(u¯ ′)2 +2Fu¯ ′v′ +G(v¯ ′)2

= E(u′)2 +2Fu′v′ +G(v′)2 = Iϕ(p)(dϕp(w)),

as we claimed. It follows that the cylinder x2 +y2 = 1 is locally isometric to a plane.

The isometry cannot be extended to the entire cylinder because the cylinder is not even homeomorphic to a plane. A rigorous proof of the last assertion would take us too far aﬁeld, but the following intuitive argument may give an idea of the proof. Any simple closed curve in the plane can be shrunk continuously into a point without leaving the plane (Fig. 4-1). Such a property

[Page 239]

|P<br><br>p<br><br>C<br><br>|
|---|


C´

S

Figure 4-1. C ⊂ P can be shrunk continuously into p without leaving P.The same does not hold for C′ ⊂ S.

would certainly be preserved under a homeomorphism. But a parallel of the cylinder (Fig. 4-1) does not have that property, and this contradicts the existence of a homeomorphism between the plane and the cylinder.

Beforepresentingfurtherexamples, weshallgeneralizetheargumentgiven above to obtain a criterion for local isometry in terms of local coordinates.

PROPOSITION 1. Assume the existence of parametrizations x: U → S and x¯: U → S¯ such that E = E¯, F = F¯, G = G¯ in U. Then the map ϕ = x¯ ◦x−1: x(U) → S¯ is a local isometry.

Proof. Let p ∈ x(U) and w ∈ Tp(S). Then w is tangent to a curve x(α(t)) at t = 0, where α(t) = (u(t),v(t)) is a curve in U; thus, w may be written (t = 0)

w = xuu′ +xvv′.

By deﬁnition, the vector dϕp(w) is the tangent vector to the curve x¯ ◦x−1 ◦ x(α(t)), i.e., to the curve x¯(α(t)) at t = 0 (Fig. 4-2). Thus,

dϕp(w) = x¯uu′ +x¯vv′.

Since

Ip(w) = E(u′)2 +2Fu′v′ +G(v′)2, Iϕ(p)(dϕp(w)) = E(u¯ ′)2 +2Fu¯ ′v′ +G(v¯ ′)2,

we conclude that Ip(w) = Iϕ(p)(dϕp(w)) for all p ∈ x(U) and all w ∈ Tp(S); hence, ϕ is a local isometry. Q.E.D.

[Page 240]

S

S

- w

x°α

α

U

- x


φ = ¯x° x–1

dφp(w)

¯x ° α

¯

¯x

###### Figure 4-2

Example 2. Let S be a surface of revolution and let x(u,v) = (f(v)cosu,f(v)sin u,g(v)),

a < v < b, 0 < u < 2π, f (v) > 0,

be a parametrization of S (cf. Example 4, Sec. 2-3). The coefﬁcients of the ﬁrst fundamental form of S in the parametrization x are given by

E = (f(v))2, F = 0, G = (f ′(v))2 +(g′(v))2. In particular, the surface of revolution of the catenary,

x = a cosh v, z = av, −∞ < v < ∞, has the following parametrization:

x(u,v) = (a cosh v cosu,a cosh v sin u,av),

0 < u < 2π, −∞ < v < ∞, relative to which the coefﬁcients of the ﬁrst fundamental form are

E = a2 cosh2 v, F = 0, G = a2(1+sinh2 v) = a2 cosh2 v.

This surface of revolution is called the catenoid (see Fig. 4-3). We shall show that the catenoid is locally isometric to the helicoid of Example 3, Sec. 2-5.

A parametrization for the helicoid is given by

x¯(u,¯ v)¯ = (v¯ cosu,¯ v¯ sin u,a¯ u),¯ 0 < u¯ < 2π,−∞ < v¯ < ∞.

[Page 241]

y

z

0

x

Figure 4-3. The catenoid.

Let us make the following change of parameters: u¯ = u, v¯ = a sinh v, 0 < u < 2π,−∞ < v < ∞, which is possible since the map is clearly one-to-one, and the Jacobian

∂(u,¯ v)¯ ∂(u,v) = a cosh v

is nonzero everywhere. Thus, a new parametrization of the helicoid is

x¯(u,v) = (a sinh v cosu,a sinh v sin u,au),

relative to which the coefﬁcients of the ﬁrst fundamental form are given by E = a2 cosh2 v, F = 0, G = a2 cosh2 v.

Using Prop. 1, we conclude that the catenoid and the helicoid are locally isometric.

Figure 4-4 gives a geometric idea of how the isometry operates; it maps “one turn” of the helicoid (coordinate neighborhood corresponding to

- 0 < u < 2π) into the catenoid minus one meridian.


Remark 1. The isometry between the helicoid and the catenoid has already appeared in Chap. 3 in the context of minimal surfaces; cf. Exercise 14, Sec. 3-5.

[Page 242]

Example 3. We shall prove that the one-sheeted cone (minus the vertex)

z = +k

?

x2 +y2, (x,y) ?= (0,0),

is locally isometric to a plane. The idea is to show that a cone minus a generator can be “rolled” onto a piece of a plane.

(a) (b)

(c) (d)

Figure 4-4. Isometric deformation of helicoid to catenoid. (a) Phase 1. (b) Phase 2. (c) Phase 3. (d) Phase 4.

[Page 243]

(e) (f)

(g)

Figure 4-4. (e) Phase 5. (f) Phase 6. (g) Phase 7.

Let U ⊂ R2 be the open set given in polar coordinates (ρ,θ) by 0 < ρ < ∞, 0 < θ < 2π sin α,

where 2α (0 < 2α < π) is the angle at the vertex of the cone (i.e., where cotan α = k), and let f : U → R3 be the map (Fig. 4-5)

f (ρ,θ) = ?ρ sin α cos?

θ sin α?,ρ sin α sin ?

θ

sin α?,ρ cosα?. It is clear that f (U) is contained in the cone because

k

?

x2 +y2 = cotan α?ρ2 sin2 α = ρ cosα = z.

[Page 244]

sin α

2π sin α

α

z

x

y

F ρ

0

U

θ

θ

###### Figure 4-5

Furthermore, when θ describes the interval (0,2π sin α), θ/sin α describes the interval (0,2π). Thus, all points of the cone except the generator θ = 0 are covered by f (U).

It is easily checked that f and df are one-to-one in U; therefore, f is a diffeomorphism of U onto the cone minus a generator.

We shall now show that f is an isometry. In fact, U may be thought of as a regular surface, parametrized by

x¯(ρ,θ) = (ρ cosθ,ρ sin θ,0), 0 < ρ < ∞,0 < θ < 2π sin α. The coefﬁcients of the ﬁrst fundamental form of U in this parametrization are E¯ = 1, F¯ = 0, G¯ = ρ2.

On the other hand, the coefﬁcients of the ﬁrst fundamental form of the cone in the parametrization F ◦x¯ are

E = 1, F = 0, G = ρ2. From Prop. 1 we conclude that F is a local isometry, as we wished.

Remark 2. The fact that we can compute lengths of curves on a surface S by using only its ﬁrst fundamental form allows us to introduce a notion of “intrinsic” distance for points in S. Roughly speaking, we deﬁne the (intrinsic) distance d(p,q) between two points of S as the inﬁmum of the length of curves on S joining p and q. (We shall go into that in more detail in Sec. 5-3.) This distance is clearly greater than or equal to the distance ?p −q? of p to

- q as points in R3 (Fig. 4-6). We shall show in Exercise 3 that the distance d is invariant under isometries; that is, if ϕ: S → S¯ is an isometry, then d(p,q) = d(ϕ(p),ϕ(q)),p,q ∈ S.


[Page 245]

q

p

S

###### Figure 4-6

The notion of isometry is the natural concept of equivalence for the metric properties of regular surfaces. In the same way as diffeomorphic surfaces are equivalent from the point of view of differentiability, so isometric surfaces are equivalent from the metric viewpoint.

It is possible to deﬁne further types of equivalence in the study of surfaces. From our point of view, diffeomorphisms and isometries are the most important. However, when dealing with problems associated with analytic functions of complex variables, it is important to introduce the conformal equivalence, which we shall now discuss brieﬂy.

DEFINITION 3. A diffeomorphism ϕ: S → S¯ is called a conformal map if for all p ∈ S and all v1,v2 ∈ Tp(S) we have

?dϕp(v1),dϕp(v2)? = λ2(p)?v1,v2?p,

where λ2 is a nowhere-zero differentiable function on S; the surfaces S and S¯ are then said to be conformal. A map ϕ: V → S¯ of a neighborhood V of p ∈ S into S¯ is a local conformal map at p if there exists a neighborhood V¯ of ϕ(p) such that ϕ: V → V¯ is a conformal map. If for each p ∈ S, there exists a local conformal map at p, the surface S is said to be locally conformal to S¯.

The geometric meaning of the above deﬁnition is that the angles (but not necessarilythelengths)arepreservedbyconformalmaps. Infact, letα:I → S and β: I → S be two curves in S which intersect at, say, t = 0. Their angle θ at t = 0 is given by

cosθ =

?α′,β′? |α′||β′|

, 0 ≤ θ ≤ π.

A conformal map ϕ: S → S¯ maps these curves into curves ϕ ◦α: I → S¯, ϕ ◦β: I → S¯, which intersect for t = 0, making an angle θ¯ given by

cosθ¯ =

?dϕ(α′),dϕ(β′)? |dϕ(α′)||dϕ(β′)|

=

λ2?α′,β′? λ2|α′||β′|

= cosθ,

as we claimed. It is not hard to prove that this property characterizes the locally conformal maps (Exercise 14).

[Page 246]

The following proposition is the analogue of Prop. 1 for conformal maps, and its proof is also left as an exercise.

PROPOSITION 2. Let x: U → S and x¯: U → S¯ be parametrizations such that E = λ2E¯, F = λ2F¯, G = λ2G¯ in U, where λ2 is a nowhere-zero differentiable function in U. Then the map ϕ = x¯ ◦x−1: x(U) → S¯ is a local conformal map.

Local conformality is easily seen to be a transitive relation; that is, if S1 is locally conformal to S2 and S2 is locally conformal to S3, then S1 is locally conformal to S3.

The most important property of conformal maps is given by the following

theorem, which we shall not prove. THEOREM. Any two regular surfaces are locally conformal. The proof is based on the possibility of parametrizing a neighborhood of

any point of a regular surface in such a way that the coefﬁcients of the ﬁrst fundamental form are

E = λ2(u,v) > 0, F = 0, G = λ2(u,v).

Such a coordinate system is called isothermal. Once the existence of an isothermal coordinate system of a regular surface S is assumed, S is clearly locally conformal to a plane, and by composition locally conformal to any other surface.

The proof that there exist isothermal coordinate systems on any regular surface is delicate and will not be taken up here. The interested reader may consult L. Bers, Riemann Surfaces, New York University, Institute of Mathematical Sciences, New York, 1957–1958, pp. 15–35.

Remark 3. Isothermal parametrizations already appeared in Chap. 3 in the context of minimal surfaces; cf. Prop. 2 and Exercise 13 of Sec. 3-5.

###### EXERCISES

- 1. Let F: U ⊂ R2 → R3 be given by


F(u,v) = (usin α cosv,usin α sin v,ucosα), (u,v) ∈ U = {(u,v) ∈ R2;u > 0}, α = const.

- a. Prove that F is a local diffeomorphism of U onto a cone C with the vertex at the origin and 2α as the angle of the vertex.
- b. Is F a local isometry?


[Page 247]

- 2. Prove the following “converse” of Prop. 1: Let ϕ: S → S¯ be an isometry and x: U → S a parametrization at p ∈ S; then x¯ = ϕ ◦x is a parametrization at ϕ(p) and E = E¯, F = F¯, G = G¯ .


- *3. Show that a diffeomorphism ϕ: S → S¯ is an isometry if and only if the arc length of any parametrized curve in S is equal to the arc length of the image curve by ϕ.

- 4. Use the stereographic projection (cf. Exercise 16, Sec. 2-2) to show that the sphere is locally conformal to a plane.
- 5. Let α1: I → R3, α2: I → R3 be regular parametrized curves, where the parameter is the arc length. Assume that the curvatures k1 of α1 and k2 of α2 satisfy k1(s) = k2(s) ?= 0, s ∈ I. Let


x1(s,v) = α1(s)+vα1′(s), x2(s,v) = α2(s)+vα2′(s)

be their (regular) tangent surfaces (cf. Example 5, Sec. 2-3) and let V be aneighborhood of (s0,v0)suchthat x1(V ) ⊂ R3, x2(V ) ⊂ R3 are regular surfaces (cf. Prop. 2, Sec. 2-3). Prove that x1 ◦x−1

2 : x2(V ) → x1(V ) is an isometry.

- *6. Let α: I → R3 be a regular parametrized curve with k(t) ?= 0, t ∈ I. Let x(t,v) be its tangent surface. Prove that, for each (t0,v0) ∈ I × (R −{0}), there exists a neighborhood V of (t0,v0) such that x(V ) is isometric to an open set of the plane (thus, tangent surfaces are locally isometric to planes).

7. Let V and W be (n-dimensional) vector spaces with inner products denoted by ?, ? and let F: V → W be a linear map. Prove that the following conditions are equivalent:

- a. ?F(v1),F(v2)? = ?v1,v2? for all v1,v2 ∈ V .
- b. |F(v)| = |v| for all v ∈ V .
- c. If {v1,...,vn} is an orthonormal basis in V , then {F(v1),...,F(vn)} is an orthonormal basis in W.
- d. There exists an orthonormal basis {v1,...,vn} in V such that {F(v1),...,F(vn)} is an orthonormal basis in W.


If any of these conditions is satisﬁed, F is called a linear isometry of V into W. (When W = V , a linear isometry is often called an orthogonal transformation.)

- *8. Let G: R3 → R3 be a map such that


|G(p)−G(q)| = |p −q| for all p,q ∈ R3

[Page 248]

(that is, G is a distance-preserving map). Prove that there exists p0 ∈ R3 and a linear isometry (cf. Exercise 7) F of the vector space R3 such that

G(p) = F(p)+p0 for all p ∈ R3.

- 9. Let S1,S2, and S3 be regular surfaces. Prove that

a. If ϕ: S1 → S2 is an isometry, then ϕ−1: S2 → S1 is also an isometry. b. If ϕ: S1 → S2, ψ: S2 → S3 are isometries, then ψ ◦ϕ: S1 → S3 is an

isometry.

This implies that the isometries of a regular surface S constitute in a natural way a group, called the group of isometries of S.

- 10. Let S be a surface of revolution. Prove that the rotations about its axis are isometries of S.
- 11. a. Let S ⊂ R3 be a regular surface and let F: R3 → R3 be a distance-preserving diffeomorphism of R3 (see Exercise 8) such that F(S) ⊂ S. Prove that the restriction of F to S is an isometry of S.


- b. Use part a to show that the group of isometries (see Exercise 10) of the unit sphere x2 +y2 +z2 = 1 contains the group of orthogonal linear transformations of R3 (it is actually equal; see Exercise 23, Sec. 4-4).
- c. Give an example to show that there are isometries ϕ: S1 → S2 which cannot be extended into distance-preserving maps F: R3 → R3.


- *12. Let C = {(x,y,z) ∈ R3;x2 +y2 = 1} be a cylinder. Construct an isometry ϕ: C → C such that the set of ﬁxed points of ϕ, i.e., the set {p ∈ C;ϕ(p) = p}, contains exactly two points.


- 13. Let V and W be (n-dimensional) vector spaces with inner products ?, ?. Let G: V → W be a linear map. Prove that the following conditions are equivalent:


- a. There exists a real constant λ ?= 0 such that ?G(v1),G(v2)? = λ2?v1,v2? for all v1,v2 ∈ V.
- b. There exists a real constant λ > 0 such that |G(v)| = λ|v| for all v ∈ V.
- c. There exists an orthonormal basis {v1,...,vn} of V such that {G(v1),...,G(vn)} is an orthogonal basis of W and, also, the vectors G(vi), i = 1,...,n, have the same (nonzero) length.


If any of these conditions is satisﬁed, G is called a linear conformal map (or a similitude).

[Page 249]

- 14. We say that a differentiable map ϕ: S1 → S2 preserves angles when for every p ∈ S1 and every pair v1,v2 ∈ Tp(S1) we have

cos(v1,v2) = cos(dϕp(v1),dϕp(v2)). Prove that ϕ is locally conformal if and only if it preserves angles.

- 15. Let ϕ: R2 → R2 be given by ϕ(x,y) = (u(x,y),v(x,y)), where u and v are differentiable functions that satisfy the Cauchy-Riemann equations

ux = vy, uy = −vx.

Show that ϕ is a local conformal map from R2 −Q into R2, where Q = {(x,y) ∈ R2;u2x +u2y = 0}.

- 16. Let x: U ⊂ R2 → R3, where


U = {(θ,ϕ) ∈ R2;0 < θ < π,0 < ϕ < 2π}, x(θ,ϕ) = (sin θ cosϕ,sin θ sin ϕ,cosθ),

be a parametrization of the unit sphere S2. Let log tan 21θ = u, ϕ = v,

and show that a new parametrization of the coordinate neighborhood x(U) = V can be given by

y(u,v) = (sech ucosv,sech usin v,tanh u).

Prove that in the parametrization y the coefﬁcients of the ﬁrst fundamental form are

E = G = sech2u, F = 0.

Thus, y−1: V ⊂ S2 → R2 is a conformal map which takes the meridians and parallels of S2 into straight lines of the plane. This is called Mercator’s projection.

- *17. Consider a triangle on the unit sphere so that its sides are made up of segments of loxodromes (i.e., curves which make a constant angle with the meridians; cf. Example 4, Sec. 2-5), and do not contain poles. Prove that the sum of the interior angles of such a triangle is π.


- 18. A diffeomorphism ϕ: S → S¯ is said to be area-preserving if the area of any region R ⊂ S is equal to the area of ϕ(R). Prove that if ϕ is area-preserving and conformal, then ϕ is an isometry.
- 19. Let S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} be the unit sphere and C = {(x,y,z) ∈ R3;x2 +y2 = 1} be the circumscribed cylinder. Let


ϕ: S2 −{(0,0,1)∪(0,0,−1)} = M → C

[Page 250]

be a map deﬁned as follows. For each p ∈ M, the line passing through p and perpendicular to 0z meets 0z at the point q. Let l be the half-line starting from q and containing p (Fig. 4-7). By deﬁnition, ϕ(p) = C ∩l.

q

z

p

l

φ( p)

0

###### Figure 4-7

Prove that ϕ is an area-preserving diffeomorphism.

- 20. Let x: U ⊂ R2 → S be the parametrization of a surface of revolution S: x(u,v) = (f(v)cosu,f(v)sin u,g(v)), f(v) > 0,


U = {(u,v) ∈ R2;0 < u < 2π,a < v < b}.

- a. Show that the map ϕ: U → R2 given by

ϕ(u,v) = ?u,? ?

(f ′(v))2 +(g′(v))2 f (v)

dv?

is a local diffeomorphism.

- b. Use part a to prove that a surface of revolution S is locally conformal to a plane in such a way that each local conformal map θ: V ⊂ S → R2 takes the parallels and the meridians of the neighborhood V into an orthogonal system of straight lines in θ(V ) ⊂ R2. (Notice that this generalizes Mercator’s projection of Exercise 16.)
- c. Show that the map ψ: U → R2 given by

ψ(u,v) = ?u,? f (v)

?

(f ′(v))2 +(g′(v))2 dv? is a local diffeomorphism.

- d. Use part c to prove that for each point p of a surface of revolution S there exists a neighborhood V ⊂ S and a map θ¯: V → R2 of V into a plane that is area-preserving.


[Page 251]

###### 4-3. The Gauss Theorem and the Equations of Compatibility

The properties of Chap. 3 were obtained from the study of the variation of the tangent plane in a neighborhood of a point. Proceeding with the analogy with curves, we are going to assign to each point of a surface a trihedron (the analogue of Frenet’s trihedron) and study the derivatives of its vectors.

S will denote, as usual, a regular, orientable, and oriented surface. Let x: U ⊂ R2 → S be a parametrization in the orientation of S. It is possible to assign to each point of x(U) a natural trihedron given by the vectors xu, xv, and N. The study of this trihedron will be the subject of this section.

By expressing the derivatives of the vectors xu,xv, and N in the basis {xu,xv,N}, we obtain

xuu = Ŵ111xu +Ŵ211xv +L1N, xuv = Ŵ112xu +Ŵ212xv +L2N, xvu = Ŵ121xu +Ŵ221xv +L¯2N, xvv = Ŵ122xu +Ŵ222xv +L3N,

Nu = a11xu +a21xv, Nv = a12xu +a22xv,

###### (1)

where the aij, i,j = 1,2, were obtained in Chap. 3 and the other coefﬁcients are to be determined. The coefﬁcients Ŵkij, i,j,k = 1,2, are called the Christoffel symbols of S in the parametrization x. Since xuv = xvu, we conclude that Ŵ112 = Ŵ121 and Ŵ212 = Ŵ221; that is, the Christoffel symbols are symmetric relative to the lower indices.

By taking the inner product of the ﬁrst four relations in (1) with N, we immediately obtain L1 = e, L2 = L¯2 = f , L3 = g, where e,f,g are the coefﬁcients of the second fundamental form of S.

To determine the Christoffel symbols, we take the inner product of the ﬁrst four relations with xu and xv, obtaining the system

?

Ŵ111E +Ŵ211F = ?xuu,xu? = 12Eu, Ŵ111F +Ŵ211G = ?xuu,xv? = Fu − 21Ev,

?

Ŵ112E +Ŵ212F = ?xuv,xu? = 21Ev, Ŵ112F +Ŵ212G = ?xuv,xv? = 12Gu,

?

- Ŵ122E +Ŵ222F = ?xvv,xu? = Fv − 21Gu,

- Ŵ122F +Ŵ222G = ?xvv,xv? = 12Gv.


###### (2)

Note that the above equations have been grouped into three pairs of equations and that for each pair the determinant of the system is EG −F2 ?= 0.

[Page 252]

Thus, it is possible to solve the above system and to compute the Christoffel symbols in terms of the coefﬁcients of the ﬁrst fundamental form, E, F, G, and their derivatives. We shall not obtain the explicit expressions of the Ŵkij, since it is easier to work in each particular case with the system (2). (See Example 1 below.) However, the following consequence of the fact that we can solve the system (2) is very important: All geometric concepts and properties expressed in terms of the Christoffel symbols are invariant under isometries.

Example 1. We shall compute the Christoffel symbols for a surface of revolution parametrized by (cf. Example 4, Sec. 2-3)

x(u,v) = {f (v)cosu,f(v)sin u,g(v)), f(v) ?= 0. Since

E = (f(v))2, F = 0, G = {f ′(v))2 +(g′(v))2, we obtain

Eu = 0, Ev = 2ff′, Fu = Fv = 0, Gu = 0,

Gv = 2(f′f ′′ +g′g′′),

where prime denotes derivative with respect to v. The ﬁrst two equations of the system (2) then give

Ŵ111 = 0, Ŵ211 = −

ff′ (f ′)2 +(g′)2

.

Next, the second pair of equations in system (2) yield

Ŵ112 =

ff ′ f 2

, Ŵ212 = 0. Finally, from the last two equations in system (2) we obtain Ŵ122 = 0, Ŵ222 =

f ′f ′′ +g′g′′ (f ′)2 +(g′)2

.

As we have just seen, the expressions of the derivatives of xu,xv, and N in the basis {xu,xv,N} involve only the knowledge of the coefﬁcients of the ﬁrst and second fundamental forms of S.Away of obtaining relations between these coefﬁcients is to consider the expressions

(xuu)v −(xuv)u = 0, (xvv)u −(xvu)v = 0,

Nuv −Nvu = 0.

###### (3)

[Page 253]

By introducing the values of (1), we may write the above relations in the form

- A1xu +B1xv +C1N = 0,
- A2xu +B2xv +C2N = 0,
- A3xu +B3xv +C3N = 0,


###### (3a)

where Ai,Bi,Ci, i = 1,2,3, are functions of E,F,G,e,f,g and of their derivatives. Since the vectors xu,xv,N are linearly independent, (3a) implies that there exist nine relations:

Ai = 0, Bi = 0, Ci = 0, i = 1,2,3.

As an example, we shall determine the relations A1 = 0, B1 = 0, C1 = 0. By using the values of (1), the ﬁrst of the relations (3) may be written

Ŵ111xuv +Ŵ211xvv +eNv +(Ŵ111)vxu +(Ŵ211)vxv +evN

= Ŵ112xuu +Ŵ212xvu +f Nu +(Ŵ112)uxu +(Ŵ212)uxv +fuN.

###### (4)

By using (1) again and equating the coefﬁcients of xv, we obtain Ŵ111Ŵ212 +Ŵ211Ŵ222 +ea22 +(Ŵ211)v

= Ŵ112Ŵ211 +Ŵ212Ŵ212 +f a21 +(Ŵ212)u. Introducing the values of aij already computed (cf. Sec. 3-3) it follows that (Ŵ212)u −(Ŵ211)v +Ŵ112Ŵ211 +Ŵ212Ŵ212 −Ŵ211Ŵ222 −Ŵ111Ŵ212

= −E

eg −f2 EG −F2

= −EK. (5)

At this point it is convenient to interrupt our computations in order to draw attention to the fact that the above equation proves the following theorem, due to K. F. Gauss.

THEOREMA EGREGIUM (Gauss). The Gaussian curvature K of a surface is invariant by local isometries.

In fact if x: U ⊂ R2 → S is a parametrization at p ∈ S and if ϕ: V ⊂ S −S¯, where V ⊂ x(U) is a neighborhood of p, is a local isometry at p, then y = ϕ ◦x is a parametrization of S¯ at ϕ(p). Since ϕ is an isometry, the coefﬁcients of the ﬁrst fundamental form in the parametrizations x and y agree at corresponding points q and ϕ(q), q ∈ V ; thus, the corresponding Christoffel symbols also agree. By Eq. (5), K can be computed at a point as a function of

[Page 254]

the Christoffel symbols in a given parametrization at the point. It follows that K(q) = K(ϕ(q)) for all q ∈ V .

The above expression, which yields the value of K in terms of the coefﬁcients of the ﬁrst fundamental form and its derivatives, is known as the Gauss formula. It was ﬁrst proved by Gauss in a famous paper [1].

The Gauss theorem is considered, by the extension of its consequences, one of the most important facts of differential geometry. For the moment we shall mention only the following corollary.

As was proved in Sec. 4-2, a catenoid is locally isometric to a helicoid. It follows from the Gauss theorem that the Gaussian curvatures are equal at corresponding points, a fact which is geometrically nontrivial.

Actually, it is a remarkable fact that a concept such as the Gaussian curvature, the deﬁnition of which made essential use of the position of a surface in the space, does not depend on this position but only on the metric structure (ﬁrst fundamental form) of the surface.

We shall see in the next section that many other concepts of differential geometryareinthesamesettingastheGaussiancurvature; thatis, theydepend only on the ﬁrst fundamental form of the surface. It thus makes sense to talk about a geometry of the ﬁrst fundamental form, which we call intrinsic geometry, since it may be developed without any reference to the space that contains the surface (once the ﬁrst fundamental form is given).

†With an eye to a further geometrical result we come back to our computations. By equating the coefﬁcients of xu in (4), we see that the relation A1 = 0 may be written in the form

(Ŵ112)u −(Ŵ111)v +Ŵ212Ŵ112 −Ŵ211Ŵ122 = FK. (5a)

By equating also in Eq. (4) the coefﬁcients of N, we obtain C1 = 0 in the form

ev −fu = eŴ112 +f (Ŵ212 −Ŵ111)−gŴ211. (6)

Observe that relation (5a) is (when F ?= 0) merely another form of the Gauss formula (5).

By applying the same process to the second expression of (3), we obtain that both the equations A2 = 0 and B2 = 0 give again the Gauss formula (5). Furthermore, C2 = 0 is given by

fv −gu = eŴ122 +f (Ŵ222 −Ŵ112)−gŴ212. (6a) Finally, the same process can be applied to the last expression of (3), yielding that C3 = 0 is an identity and that A3 = 0 and B3 = 0 are again Eqs. (6) and (6a). Equations (6) and (6a) are called Mainardi-Codazzi equations.

†The rest of this section will not be used until Chap. 5. If omitted, Exercises 7 and 8 should also be omitted.

[Page 255]

The Gauss formula and the Mainardi-Codazzi equations are known under the name of compatibility equations of the theory of surfaces.

A natural question is whether there exist further relations of compatibility between the ﬁrst and the second fundamental forms besides those already obtained. The theorem stated below shows that the answer is negative. In other words, by successive derivations or any other process we would obtain no further relations among the coefﬁcients E, F, G, e, f , g and their derivatives. Actually, thetheoremismoreexplicitandassertsthattheknowledgeoftheﬁrst and second fundamental forms determines a surface locally. More precisely,

THEOREM (Bonnet). Let E, F, G, e, f, g be differentiable functions, deﬁned in an open set V ⊂ R2, with E > 0 and G > 0. Assume that the given functions satisfy formally the Gauss and Mainardi-Codazzi equations and that EG −F2 > 0. Then, for every q ∈ V there exists a neighborhood U ⊂ V of q and a diffeomorphism x: U → x(U) ⊂ R3 such that the regular surface x(U) ⊂ R3 has E, F, G and e, f, g as coefﬁcients of the ﬁrst and second fundamental forms, respectively. Furthermore, if U is connected and if

x:¯ U → x¯(U) ⊂ R3

is another diffeomorphism satisfying the same conditions, then there exist a translation T and a proper linear orthogonal transformation ρ in R3 such that x¯ = T ◦ρ ◦x.

A proof of this theorem may be found in the appendix to Chap. 4. For later use, it is convenient to observe how the Mainardi-Codazzi equations simplify when the coordinate neighborhood contains no umbilical points and the coordinate curves are lines of curvature (F = 0 = f ). Then, Eqs. (6) and (6a) may be written

ev = eŴ112 −gŴ211, gu = gŴ212 −eŴ122. By taking into consideration that F = 0 implies that

Ŵ211 = −

1 2

Ev G

, Ŵ112=

1 2

Ev E

,

Ŵ122 = −

- 1

- 2


Gu E

, Ŵ212=

1 2

Gu G

,

we conclude that the Mainardi-Codazzi equations take the following form:

ev =

Ev 2 ? e E +

g G?

###### , (7)

gu =

Gu 2 ? e E +

g G?

###### . (7a)

[Page 256]

###### EXERCISES

- 1. Show that if x is an orthogonal parametrization, that is, F = 0, then

K = −

1 2√EG ??

Ev √EG?

v

+?

Gu √EG?

u

?.

- 2. Show that if x is an isothermal parametrization, that is, E = G = λ(u,v) and F = 0, then

K = −

- 1

- 2λ


?(log λ),

where ?ϕ denotes the Laplacian (∂2ϕ/∂u2)+(∂2ϕ/∂v2) of the function ϕ. Conclude that when E = G = (u2 +v2 +c)−2 and F = 0, then K = const. = 4c.

- 3. Verify that the surfaces

x(u,v) = (ucosv,usin v,log u), u > 0 x¯(u,v) = (ucosv,usin v,v),

have equal Gaussian curvature at the points x(u,v) and x¯(u,v) but that the mapping x¯ ◦x−1 is not an isometry. This shows that the “converse” of the Gauss theorem is not true.

- 4. Show that no neighborhood of a point in a sphere may be isometrically mapped into a plane.
- 5. If the coordinate curves form a Tchebyshef net (cf. Exercises 7 and 8, Sec. 2-5), then E = G = 1 and F = cosθ. Show that in this case

K = −

θuv sin θ

.

- 6. Show that there exists no surface x(u,v) such that E = G = 1, F = 0 and e = 1, g = −1, f = 0.
- 7. Does there exist a surface x = x(u,v) with E = 1, F = 0, G = cos2 u and e = cos2 u, f = 0, g = 1?
- 8. Compute the Christoffel symbols for an open set of the plane

- a. In Cartesian coordinates.
- b. In polar coordinates.


Use the Gauss formula to compute K in both cases.

- 9. Justify why the surfaces below are not pairwise locally isometric:


- a. Sphere.
- b. Cylinder.
- c. Saddle z = x2 −y2.


[Page 257]

###### 4-4. Parallel Transport. Geodesics.

We shall now proceed to a systematic exposition of the intrinsic geometry. Todisplaytheintuitivemeaningoftheconcepts, weshalloftengivedeﬁnitions and interpretations involving the space exterior to the surface. However, we shall prove in each case that the concepts to be introduced depend only on the ﬁrst fundamental form.

We shall start with the deﬁnition of covariant derivative of a vector ﬁeld, which is the analogue for surfaces of the usual differentiation of vectors in the plane. We recall that a (tangent) vector ﬁeld in an open set U ⊂ S of a regular surface S is a correspondence w that assigns to each p ∈ U a vector w(p) ∈ Tp(S). The vector ﬁeld w is differentiable at p if, for some parametrization x(u,v) in p, the components a and b of w = axu +bxv in the basis {xu,xv} are differentiable functions at p. The vector ﬁeld w is differentiable in U if it is differentiable for every p ∈ U.

DEFINITION 1. Let w be a differentiable vector ﬁeld in an open set U ⊂ S and p ∈ U. Let y ∈ Tp(S). Consider a parametrized curve

α: (−ǫ,ǫ) → U,

with α(0) = p and α′(0) = y, and let w(t), t ∈ (−ǫ,ǫ), be the restriction of the vector ﬁeld w to the curve α. The vector obtained by the normal projection of (dw/dt)(0) onto the plane Tp(S) is called the covariant derivative at p of the vector ﬁeld w relative to the vector y. This covariant derivative is denoted by (Dw/dt)(0) or (Dyw)(p) (Fig. 4-8).

The above deﬁnition makes use of the normal vector of S and of a particular curve α, tangent to y at p. To show that covariant differentiation is a concept

N

p

Tp(S) S

w

y = α´(0)

dw dt

Dw dt

Figure 4-8. The covariant derivative.

[Page 258]

of the intrinsic geometry and that it does not depend on the choice of the curve α, we shall obtain its expression in terms of a parametrization x(u,v) of S in p.

Let x(u(t),v(t)) = α(t) be the expression of the curve α and let

w(t) = a(u(t),v(t))xu +b(u(t),v(t))xv

= a(t)xu +b(t)xv, be the expression of w(t) in the parametrization x(u,v). Then dw

dt = a(xuuu′ +xuvv′)+b(xvuu′ +xvvv′)+a′xu +b′xv, where prime denotes the derivative with respect to t.

Since Dw/dt is the component of dw/dt in the tangent plane, we use the expressions in (1) of Sec. 4-3 for xuu, xuv, and xvv and, by dropping the normal component, we obtain

Dw dt = (a′ +Ŵ111au′ +Ŵ112av′ +Ŵ112bu′ +Ŵ122bv′)xu

+(b′ +Ŵ211au′ +Ŵ212av′ +Ŵ212bu′ +Ŵ222bv′)xv.

###### (1)

Expression (1) shows that Dw/dt depends only on the vector (u′,v′) = y and not on the curve α. Furthermore, the surface makes its appearance in Eq. (1)throughtheChristoffelsymbols, thatis, throughtheﬁrstfundamentalform. Our assertions are, therefore, proved.

If, in particular, S is a plane, we know that it is possible to ﬁnd a parametrization in such a way that E = G = 1 and F = 0. A quick inspection of the equations that give the Christoffel symbols shows that in this case the Ŵkij become zero. In this case, it follows from Eq. (1) that the covariant derivative agrees with the usual derivative of vectors in the plane (this can also be seen geometrically from Def. 1). The covariant derivative is, therefore, a generalization of the usual derivative of vectors in the plane.

Another consequence of Eq. (1) is that the deﬁnition of covariant derivative may be extended to a vector ﬁeld which is deﬁned only at the points of a parametrized curve. To make this point clear, we need some deﬁnitions.

DEFINITION 2. A parametrized curve α: [0,l] → S is the restriction to [0,l] of a differentiable mapping of (0−ǫ,l +ǫ), ǫ > 0, into S. If α(0) = p and α(l) = q, we say that α joins p to q. α is regular if α′(t) ?= 0 for t ∈ [0,l].

Inwhatfollowsitwillbeconvenienttousethenotation[0,l] = I whenever the speciﬁcation of the end point l is not necessary.

[Page 259]

DEFINITION 3. Let α: I → S be a parametrized curve in S. A vector ﬁeld w along α is a correspondence that assigns to each t ∈ I a vector

w(t) ∈ Tα(t)(S).

The vector ﬁeld w is differentiable at t0 ∈ I if for some parametrization x(u,v) in α(t0) the components a(t), b(t) of w(t) = axu +bxv are differentiable functions of t at t0. w is differentiable in I if it is differentiable for every t ∈ I.

An example of a (differentiable) vector ﬁeld along α is given by the ﬁeld α′(t) of the tangent vectors of α (Fig. 4-9).

α´(t)

α(t)

Figure 4-9. The ﬁeld of tangent vectors along a curve α.

DEFINITION 4. Let w be a differentiable vector ﬁeld along α: I → S. The expression (1) of (Dw/dt)(t), t ∈ I, is well deﬁned and is called the covariant derivative of w at t.

From a point of view external to the surface, in order to obtain the covariant derivative of a ﬁeld w along α: I → S at t ∈ I we take the usual derivative (dw/dt)(t)ofw int andprojectthisvectororthogonallyontothetangentplane Tα(t)(S). It follows that when two surfaces are tangent along a parametrized curve α the covariant derivative of a ﬁeld w along α is the same for both surfaces.

If α(t) is a curve on S, we can think of it as the trajectory of a point which is moving on the surface. α′(t) is then the speed and α′′(t) the acceleration of α. The covariant derivative Dα′/dt of the ﬁeld α′(t) is the tangential component of the acceleration α′′(t). Intuitively Dα′/dt is the acceleration of the point α(t) “as seen from the surface S.”

[Page 260]

DEFINITION 5. A vector ﬁeld w along a parametrized curve α: I → S is said to be parallel if Dw/dt = 0 for every t ∈ I.

In the particular case of the plane, the notion of parallel ﬁeld along a parametrized curve reduces to that of a constant ﬁeld along the curve; that is, the length of the vector and its angle with a ﬁxed direction are constant (Fig. 4-10). Those properties are partially reobtained on any surface as the following proposition shows.

|w<br><br>α<br><br>P|
|---|


###### Figure 4-10

PROPOSITION 1. Let w and v be parallel vector ﬁelds along α: I → S. Then ?w(t),v(t)? is constant. In particular, |w(t)| and |v(t)| are constant, and the angle between v(t) and w(t) is constant.

Proof. To say that the vector ﬁeld w is parallel along α means that dw/dt is normal to the plane which is tangent to the surface at α(t); that is,

?v(t),w′(t)? = 0, t ∈ I. On the other hand, v′(t) is also normal to the tangent plane at α(t). Thus,

?v(t),w(t)?′ = ?v′(t),w(t)?+?v(t),w′(t)? = 0; that is, ?v(t),w(t)? = constant. Q.E.D.

Of course, on an arbitrary surface parallel ﬁelds may look strange to our R3 intuition. For instance, the tangent vector ﬁeld of a meridian (parametrized by arc length) of a unit sphere S2 is a parallel ﬁeld on S2 (Fig. 4-11). In fact, since the meridian is a great circle on S2, the usual derivative of such a ﬁeld is normal to S2. Thus, its covariant derivative is zero.

Thefollowingpropositionshowsthatthereexistparallelvectorﬁeldsalong a parametrized curve α(t) and that they are completely determined by their values at a point t0.

[Page 261]

α

α˝

α´

Figure 4-11. Parallel ﬁeld on a sphere.

PROPOSITION 2. Let α: I → S be a parametrized curve in S and let

w0 ∈ Tα(t0)(S), t0 ∈ I. Then there exists a unique parallel vector ﬁeld w(t) along α(t), with w(t0) = w0.

An elementary proof of Prop. 2 will be given later in this section. Those who are familiar with the material of Sec. 3-4 will notice, however, that the proof is an immediate consequence of the theorem of existence and uniqueness of differential equations.

Proposition 2 allows us to talk about parallel transport of a vector along a parametrized curve.

DEFINITION 6. Let α: I → S be a parametrized curve and w0 ∈ Tα(t0)(S), t0 ∈ I. Let w be the parallel vector ﬁeld along α, with w(t0) = w0. The vector w(t1), t1 ∈ I, is called the parallel transport of w0 along α at the point t1.

It should be remarked that if α: I → S, t ∈ I, is regular, then the parallel transport does not depend on the parametrization of α(I). As a matter of fact, if β: J → S, σ ∈ J is another regular parametrization for α(I), it follows from Eq. (1) that

Dw dσ =

Dw dt

dt dσ

, t ∈ I,σ ∈ J.

Since dt/dσ ?= 0, w(t) is parallel if and only if w(σ) is parallel.

Proposition 1 contains an interesting property of the parallel transport. Fix two points p,q ∈ S and a parametrized curve α: I → S with α(0) = p, α(1) = q. Denote by Pα: Tp(S) → Tq(S) the map that assigns to each v ∈ Tp(S) its parallel transport along α at q. Proposition 1 says that this map is a linear isometry.

[Page 262]

AnotherinterestingpropertyoftheparalleltransportisthatiftwosurfacesS and S¯ aretangentalongaparametrizedcurve α andw0 isavectorof Tα(t0)(S) = Tα(t0)(S)¯ , then w(t) is the parallel transport of w0 relative to the surface S if and only if w(t) is the parallel transport of w0 relative to S¯. Indeed, the covariant derivative Dw/dt of w is the same for both surfaces. Since the parallel transport is unique, the assertion follows.

The above property will allow us to give a simple and instructive example of parallel transport.

Example 1. LetC beaparallelofcolatitudeϕ (seeFig. 4-12)ofanoriented unit sphere and let w0 be a unit vector, tangent to C at some point p of C. Let us determine the parallel transport of w0 along C, parametrized by arc length s, with s = 0 at p.

ψ

C p

0

φ

w0

O

orientation

s = 0

t(s)

w(s)

w0

2π sin ψ

θ

###### Figure 4-12 Figure 4-13

Consider the cone which is tangent to the sphere along C. The angle ψ at the vertex of this cone is given by ψ = (π/2)−ϕ. By the above property, the problem reduces to the determination of the parallel transport of w0, along C, relative to the tangent cone.

Theconeminusonegeneratoris, however, isometrictoanopensetU ⊂ R2 (cf. Example 3, Sec. 4-2), given in polar coordinates by

0 < p < +∞, 0 < θ < 2π sin ψ.

Since in the plane the parallel transport coincides with the usual notion, we obtain, for a displacement s of p, corresponding to the central angle θ (see Fig. 4-13) that the oriented angle formed by the tangent vector t(s) with the parallel transport w(s) is given by 2π −θ.

It is sometimes convenient to introduce the notion of a “broken curve,” which can be expressed as follows.

[Page 263]

DEFINITION 7. Amapα:[0,l] → S isaparametrizedpiecewiseregular curve if α is continuous and there exists a subdivision

0 = t0 < t1 < ··· < tk < tk+1 = l

of the interval [0,l] in such a way that the restriction α|[ti,ti+1], i = 0,...,k, is a parametrized regular curve. Each α|[ti,ti+1] is called a regular arc of α.

The notion of parallel transport can be easily extended to parametrized piecewise regular curves. If, say, the initial value w0 lies in the interval [ti,ti+1], we perform the parallel transport in the regular arc α|[ti,ti+1] as usual; if ti+1 ?= l, we take w(ti+1) as the initial value for the parallel transport in the next arc α|[ti+1,ti+2], and so forth.

Example 2.† The previous example is a particular case of an interesting geometric construction of the parallel transport. Let C be a regular curve on a surface S and assume that C is nowhere tangent to an asymptotic direction. Consider the envelope of the family of tangent planes of S along C (cf. Example 4, Sec. 3-5). In a neighborhood of C, this envelope is a regular surface ? which is tangent to S along C. (In Example 1, ? can be taken as a ribbon around C on the cone which is tangent to the sphere along C.) Thus, the parallel transport along C of any vector w ∈ Tp(S), p ∈ S, is the same whether we consider it relative to S or to ?. Furthermore, ? is a developable surface; hence, its Gaussian curvature is identically zero.

Now, we shall prove later in this book (Sec. 4-6, theorem of Minding) that a surface of zero Gaussian curvature is locally isometric to a plane. Thus, we canmapaneighborhoodV ⊂ ? ofp intoaplaneP byanisometryϕ:V → P. To obtain the parallel transport of w along V ∩C, we take the usual parallel transport in the plane of dϕp(w) along ϕ(C) and pull it back to ? by dϕ (Fig. 4-14).

This gives a geometric construction for the parallel transport along small arcs of C. We leave it as an exercise to show that this construction can be extended stepwise to a given arc of C. (Use the Heine-Borel theorem and proceed as in the case of broken curves.)

Theparametrizedcurvesγ:I → R2 ofaplanealongwhichtheﬁeldoftheir tangent vectors γ′(t) is parallel are precisely the straight lines of that plane. The parametrized curves that satisfy an analogous condition for a surface are called geodesics.

DEFINITION 8. A nonconstant, parametrized curve γ: I → S is said to be geodesic at t ∈ I if the ﬁeld of its tangent vectors γ′(t) is parallel along γ at t; that is,

†This example uses the material on ruled surfaces of Sec. 3-5.

[Page 264]

dφp(w)

φ(V)

S

p

C

∑

w

V

φ

φ(p)

Figure 4-14. Parallel transport along C.

Dγ′(t) dt = 0;

γ is a parametrized geodesic if it is geodesic for all t ∈ I.

By Prop. 1, we obtain immediately that |γ′(t)| = const. = c ?= 0. Therefore, we may introduce the arc length s = ct as a parameter, and we conclude that the parameter t of a parametrized geodesic γ is proportional to the arc length of γ.

Observethataparametrizedgeodesicmayadmitself-intersections. (Example 6 will illustrate this; see Fig. 4-20.) However, its tangent vector is never zero, and thus the parametrization is regular.

The notion of geodesic is clearly local. The previous considerations allow us to extend the deﬁnition of geodesic to subsets of S that are regular curves.

DEFINITION 8a. A regular connected curve C in S is said to be a geodesic if, for every p ∈ C, the parametrization α(s) of a coordinate

[Page 265]

neighborhood of p by the arc length s is a parametrized geodesic; that is, α′(s) is a parallel vector ﬁeld along α(s).

Observe that every straight line contained in a surface satisﬁes Def. 8a. From a point of view exterior to the surface S, Def. 8a is equivalent to saying that α′′(s) = kn is normal to the tangent plane, that is, parallel to the normal to the surface. In other words, a regular curve C ⊂ S (k ?= 0) is a geodesic if and only if its principal normal at each point p ∈ C is parallel to the normal to S at p.

The above property can be used to identify some geodesics geometrically, as shown in the examples below.

Example 3. The great circles of a sphere S2 are geodesics. Indeed, the great circles C are obtained by intersecting the sphere with a plane that passes through the center O of the sphere. The principal normal at a point p ∈ C lies in the direction of the line that connects p to O because C is a circle of center O. Since S2 is a sphere, the normal lies in the same direction, which veriﬁes our assertion.

Laterinthissectionweshallprovethegeneralfactthatforeachpointp ∈ S and each direction in Tp(S) there exists exactly one geodesic C ⊂ S passing through p and tangent to this direction. For the case of the sphere, through each point and tangent to each direction there passes exactly one great circle, which, as we proved before, is a geodesic. Therefore, by uniqueness, the great circles are the only geodesics of a sphere.

Example 4. For the right circular cylinder over the circle x2 +y2 = 1, it is clear that the circles obtained by the intersection of the cylinder with planes that are normal to the axis of the cylinder are geodesics. That is so because the principal normal to any of its points is parallel to the normal to the surface at this point.

On the other hand, by the observation after Def. 8a the straight lines of the cylinder (generators) are also geodesics.

To verify the existence of other geodesics on the cylinder C we shall consider a parametrization (cf. Example 2, Sec. 2-5)

x(u,v) = (cosu,sin u,v)

of the cylinder in a point p ∈ C, with x(0,0) = p. In this parametrization, a neighborhood of p in a curve Ŵ is expressed by x(u(s),v(s)), where s is the arc length of Ŵ. As we saw previously (cf. Example 1, Sec. 4-2), x is a local isometry which maps a neighborhood U of (0,0) of the uv plane into the cylinder. Since the condition of being a geodesic is local and invariant by isometries, the curve (u(s),v(s)) must be a geodesic in U passing through (0,0). Butthegeodesicsoftheplanearethestraightlines.Therefore, excluding the cases already obtained,

[Page 266]

u(s) = as, v(s) = bs, a2 +b2 = 1.

lt follows that when a regular curve Ŵ (which is neither a circle or a line) is a geodesic of the cylinder it is locally of the form (Fig. 4-15)

(cosas,sin as,bs),

and thus it is a helix. In this way, all the geodesics of a right circular cylinder are determined.

Geodesic Local

isometry

|(0,0)|
|---|


x

Figure 4-15. Geodesics on a cylinder.

Observethatgiventwopointsonacylinderwhicharcnotinacircleparallel to the xy plane, it is possible to connect them through an inﬁnite number of helices. This fact means that two points of a cylinder may in general be connected through an inﬁnite number of geodesics, in contrast to the situation in the plane. Observe that such a situation may occur only with geodesics that make a “complete turn,” since the cylinder minus a generator is isometric to a plane (Fig. 4-16).

p

q

Figure 4-16. Two geodesics on a cylinder joining p and q.

Proceeding with the analogy with the plane, we observe that the lines, that is, the geodesics of a plane, are also characterized as regular curves of curvature zero. Now, the curvature of an oriented plane curve is given by the

[Page 267]

absolute value of the derivative of the unit vector ﬁeld tangent to the curve, associated to a sign which denotes the concavity of the curve in relation to the orientation of the plane (cf. Sec. 1-5, Remark 1). To take the sign into consideration, it is convenient to introduce the following deﬁnition.

DEFINITION 9. Let w be a differentiable ﬁeld of unit vectors along a parametrized curve α: I → S on an oriented surface S. Since w(t), t ∈ I, is a unit vector ﬁeld, (dw/dt)(t) is normal to w(t), and therefore

Dw dt = λ(N ∧w(t)).

The real number λ = λ(t), denoted by [Dw/dt], is called the algebraic value of the covariant derivative of w at t.

Observe that the sign of [Dw/dt] depends on the orientation of S and that [Dw/dt] = ?dw/dt,N ∧w?.

We should also make the general remark that, from now on, the orientation of S will play an essential role in the concepts to be introduced. The careful reader will have noticed that the deﬁnitions of parallel transport and geodesic do not depend on the orientation of S. In constrast, the geodesic curvature, to be deﬁned below, changes its sign with a change of orientation of S.

Weshallnowdeﬁne, foracurveinasurface, aconceptwhichisananalogue of the curvature of plane curves.

DEFINITION 10. Let C be an oriented regular curve contained in an oriented surface S, and let α(s) be a parametrization of C, in a neighborhood of p ∈ S, by the arc length s. The algebraic value of the covariant derivative [Dα′(s)/ds] = kg of α′(s) at p is called the geodesic curvature of C at p.

The geodesics which are regular curves are thus characterized as curves whose geodesic curvature is zero.

From a point of view external to the surface, the absolute value of the geodesic curvature kg of C at p is the absolute value of the tangential component of the vector α′′(s) = kn, where k is the curvature of C at p and n is the normal vector of C at p. Recalling that the absolute value of the normal component of the vector kn is the absolute value of the normal curvature kn of C ⊂ S in p, we have immediately (Fig. 4-17)

k2 = kg2 +kn2.

For instance, the absolute value of the geodesic curvature kg of a parallel C of colatitude ϕ in a unit sphere S2 can be computed from the relation (see Fig. 4-18)

[Page 268]

N

α′

Dα′

α˝

ds

kn

S

###### Figure 4-17

C sin φ

π/2–φ 1

kg = cotan φ

Figure 4-18. Geodesic curvature of a parallel on a unit sphere.

1

sin2 ϕ = kn2 +kg2 = 1+kg2; that is,

kg2 = cotan2ϕ.

The sign of kg depends on the orientations of S2 and C.

A further consequence of that external interpretation is that when two surfaces are tangent along a regular curve C, the absolute value of the geodesic curvature of C is the same relatively to any of the two surfaces.

Remark. The geodesic curvature of C ⊂ S changes sign when we change the orientation of either C or S.

[Page 269]

We shall now obtain an expression for the algebraic value of the covariant derivative (Prop. 3 below). For that we need some preliminaries.

Letv andw betwodifferentiablevectorﬁeldsalongtheparametrizedcurve

- α: I → S, with |v(t)| = |w(t)| = 1, t ∈ I. We want to deﬁne a differentiable function ϕ: I → R in such a way that ϕ(t), t ∈ I, is a determination of the angle from v(t) to w(t) in the orientation of S. For that, we consider the differentiablevectorﬁeldv¯ alongα, deﬁnedbytheconditionthat{v(t),v(t)¯ }is an orthonormal positive basis for every t ∈ I. Thus, w(t) may be expressed as


w(t) = a(t)v(t)+b(t)v(t),¯

where a and b are differentiable functions in I and a2 +b2 = 1. Lemma 1 below shows that by ﬁxing a determination ϕ0 of the angle from

- v(t0) to w(t0) it is possible to “extend it” differentiably in I, and this yields the desired function.


LEMMA 1. Let a and b be differentiable functions in I with a2 +b2 = 1 and ϕ0 be such that a(t0) = cosϕ0, b(t0) = sin ϕ0. Then the differentiable function

ϕ = ϕ0 +? t t0

(ab′ −ba′)dt

is such that cosϕ(t) = a(t), sin ϕ(t) = b(t), t ∈ I, and ϕ(t0) = ϕ0. Proof. It sufﬁces to show that the function

(a −cosϕ)2 +(b −sin ϕ)2 = 2−2(a cosϕ +b sin ϕ)

is identically zero, or that

A = a cosϕ +b sin ϕ = 1.

By using the fact that aa′ = −bb′ and the deﬁnition of ϕ, we easily obtain

A′ = −a(sin ϕ)ϕ′ +b(cosϕ)ϕ′ +a′ cosϕ +b′ sin ϕ

= −b′(sin ϕ)(a2 +b2)−a′(cosϕ)(a2 +b2)

+a′ cosϕ +b′ sin ϕ = 0.

Therefore, A(t) = const., and since A(t0) = 1, the lemma is proved. Q.E.D.

We may now relate the covariant derivative of two unit vector ﬁelds along a curve to the variation of the angle that they form.

[Page 270]

LEMMA 2. Let v and w be two differentiable vector ﬁelds along the curve

- α: I → S, with |w(t)| = |v(t)| = 1,t ∈ I. Then


?

Dw dt ?−?

Dv dt ? =

dϕ dt

,

where ϕ is one of the differentiable determinations of the angle from v to w, as given by Lemma 1.

Proof. We ﬁrst prove the Lemma for ϕ ?= 0. Since ?v,w? = cosϕ we obtain

?v′,w?+?v,w′? = −sin ϕϕ′, (2) hence

?Dv/dt,w?+?v,Dw/dt? = sin ϕϕ′. But

?Dv/dt,w?+?λN ∧v,w? = [Dv/dt] < N ∧v,w?. Thus, we can write the left-hand side of (2) as

?Dv/dt,w?+?v,Dw/dt? = [Dv/dt] < N ∧v,w?+[Dw,dt]?v,N ∧w?

= ([Dv/dt]−[Dw,dt]) < N ∧v,w?. It follows that

([Dv/dt]−[Dw/dt])sin ϕ = sin ϕϕ′ and this proves the Lemma for ϕ ?= 0.

If ϕ = 0 at p, either ϕ ≡ 0 in a neighborhood U of p, or there exists a sequence (pn) → p with ϕ(pn) ?= 0. In the ﬁrst case, ϕ′ ≡ 0 in U, v = w and the Lemma holds trivially. In the second case, the Lemma holds by continuity.

###### Q.E.D.

An immediate consequence of the above lemma is the following observation. Let C be a regular oriented curve on S, α(s) a parametrization by the arc length s of C at p ∈ C, and v(s) a parallel ﬁeld along α(s). Then, by taking

- w(s) = α′(s), we obtain


kg(s) = ?

Dα′(s) ds ? =

dϕ ds

.

In other words, the geodesic curvature is the rate of change of the angle that the tangent to the curve makes with a parallel direction along the curve. In the case of the plane, the parallel direction is ﬁxed and the geodesic curvature reduces to the usual curvature.

We are now able to obtain the promised expression for the algebraic value of the covariant derivative. Whenever we speak of a parametrization of an

[Page 271]

oriented surface, this parametrization is assumed to be compatible with the given orientation.

PROPOSITION 3. Let x(u,v) be an orthogonal parametrization (that is, F = 0)ofaneighborhoodofanorientedsurface S, andw(t)beadifferentiable ﬁeld of unit vectors along the curve x(u(t),v(t)). Then

?

Dw dt ? =

- 1

- 2√EG ?Gu


dv dt −Ev

du dt ?+

dϕ dt

,

where ϕ(t) is the angle from xu to w(t) in the given orientation.

Proof. Let e1 = xu/√E, e2 = xv/√G be the unit vectors tangent to the coordinate curves. Observe that e1 ∧e2 = N, where N is the given orientation of S. By using Lemma 2, we may write

?

Dw dt ? = ?

De1 dt ?+

dϕ dt

,

where e1(t) = e1(u(t),v(t)) is the ﬁeld e1 restricted to the curve x(u(t),v(t)). Now

?

De1 dt ? = ?

de1 dt

,N ∧e1? = ?

de1 dt

,e2? = ?(e1)u,e2?

du dt +?(e1)v,e2?

dv dt

.

On the other hand, since F = 0, we have

?xuu,xv? = −12Ev, and therefore

?(e1)u,e2? = ??

xu √E

?

u

,

xv √G

? = −

- 1

- 2


Ev √EG

.

Similarly,

?(e1)v,e2? =

- 1

- 2


Gu √EG

.

By introducing these relations in the expression of [Dw/dt], we ﬁnally obtain ?

Dw dt ? =

- 1

- 2√EG ?Gu


dv dt −Ev

dv dt ?+

dϕ dt

,

which completes the proof. Q.E.D.

As an application of Prop. 3, we shall prove the existence and uniqueness of the parallel transport (Prop. 2).

[Page 272]

Proof of Prop. 2. Let us assume initially that the parametrized curve α: I → S is contained in a coordinate neighborhood of an orthogonal parametrization x(u,v). Then, with the notations of Prop. 3, the condition of parallelism for the ﬁeld w becomes

dϕ dt = −

1 2√EG ?Gu

dv dt −Ev

du dt ? = B(t).

Denoting by ϕ0 a determination of the oriented angle from xu to w0, the ﬁeld w is entirely determined by

ϕ = ϕ0 +? t t0

B(t)dt,

which proves the existence and uniqueness of w in this case.

If α(I) is not contained in a coordinate neighborhood, we shall use the compactness of I to divide α(I) into a ﬁnite number of parts, each contained in a coordinate neighborhood. By using the uniqueness of the ﬁrst part of the proof in the nonempty intersections of these pieces, it is easy to extend the result to the present case. Q.E.D.

Afurther application of Prop. 3 is the following expression for the geodesic curvature, known as Liouville’s formula.

PROPOSITION 4 (Liouville). Let α(s) be a parametrization by arc length of a neighborhood of a point p ∈ S of a regular oriented curve C on an oriented surface S. Let x(u,v) be an orthogonal parametrization of S in p and ϕ(s) be the angle that xu makes with α′(s) in the given orientation. Then

kg = (kg)1 cosϕ +(kg)2 sin ϕ +

dϕ ds

,

where (kg)1 and (kg)2 are the geodesic curvatures of the coordinate curves v = const. and u = const. respectively.

Proof. By setting w = α′(s) in Prop. 3, we obtain

kg =

1 2√EG ?Gu

dv ds −Ev

du ds ?+

dϕ ds

.

Along the coordinate curve v = const. u = u(s), we have dv/ds = 0 and du/ds = 1/√E; therefore,

(kg)1 = −

Ev 2E√G

.

Similarly,

(kg)2 =

Gu 2G√E

.

[Page 273]

By introducing these relations in the above formula for kg, we obtain kg = (kg)1

√

E

du ds +(kg)2

√

G

dv ds +

dϕ ds

. Since

√

E

du ds = ?α′(s),

xu √E

? = cosϕ and √

G

dv ds = sin ϕ,

we ﬁnally arrive at

kg = (kg)1 cosϕ +(kg)2 sin ϕ +

dϕ ds

, as we wished. Q.E.D.

We shall now introduce the equations of a geodesic in a coordinate neighborhood. For that, let γ: I → S be a parametrized curve of S and let x(u,v) be a parametrization of S in a neighborhood V of γ(t0), t0 ∈ I. Let J ⊂ I be an open interval containing t0 such that γ(J) ⊂ V . Let x(u(t),v(t)), t ∈ J, be the expression of γ: J → S in the parametrization x. Then, the tangent vector ﬁeld γ′(t),t ∈ J, is given by

w = u′(t)xu +v′(t)xv.

Therefore, the fact that w is parallel is equivalent to the system of differential equations

- u′′ +Ŵ111(u′)2 +2Ŵ112u′v′ +Ŵ122(v′)2 = 0,
- v′′ +Ŵ211(u′)2 +2Ŵ212u′v′ +Ŵ222(v′)2 = 0,


###### (4)

obtained from Eq. (1) by making a = u′ and b = v′, and equating to zero the coefﬁcients of xu and xv.

In other words, γ: I → S is a geodesic if and only if system (4) is satisﬁed for every interval J ⊂ I such that γ(J) is contained in a coordinate neighborhood. The system (4) is known as the differential equations of the geodesics of S.

An important consequence of the fact that the geodesics are characterized by the system (4) is the following proposition.

PROPOSITION 5. Given a point p ∈ S and a vector w ∈ Tp(S), w ?= 0, there exist an ǫ > 0 and a unique parametrized geodesic γ: (−ǫ,ǫ) → S such that γ(0) = p,γ′(0) = w.

In Sec. 4-7 we shall show how Prop. 5 may be derived from theorems on vector ﬁelds.

Remark. The reason for taking w ?= 0 in Prop. 5 comes from the fact that we have excluded the constant curves in the deﬁnition of parametrized geodesics (cf. Def. 8).

[Page 274]

We shall use the rest of this section to give some geometrical applications of the differential equations (4). This material can be omitted if the reader wants to do so. In this case, Exercises 18, 20, and 21 should also be omitted.

Example 5. We shall use system (4) to study locally the geodesics of a surface of revolution (cf. Example 4, Sec. 2-3) with the parametrization

x = f (v)cosu, y = f (v)sin u, z = g(v). By Example 1 of Sec. 4-3, the Christoffel symbols are given by

Ŵ111 = 0, Ŵ211 = −

ff′ (f′)2 +(g′)2

, Ŵ112 =

ff ′ f 2

,

Ŵ212 = 0, Ŵ122 = 0, Ŵ222 =

f ′f ′′ +g′g′′ (f′)2 +(g′)2

. With the values above, system (4) becomes

u′′ +

2ff ′ f 2

u′v′ = 0,

v′′ −

ff′ (f′)2 +(g′)2

(u′)2 +

f ′f ′′ +g′g′′ (f ′)2 +(g′)2

(v′)2 = 0.

###### (4a)

We are going to obtain some conclusions from these equations.

First, as expected, the meridians u = const. and v = v(s), parametrized by arc length s, are geodesics. Indeed, the ﬁrst equation of (4a) is trivially satisﬁed by u = const. The second equation becomes

v′′ +

f ′f ′′ +g′g′′ (f ′)2 +(g′)2

(v′)2 = 0.

Sincetheﬁrstfundamentalformalongthemeridianu = const.v = v(s)yields ((f′)2 +(g′)2)(v′)2 = 1, we conclude that

(v′)2 =

1 (f ′)2 +(g′)2

.

Therefore, by derivation, 2v′v′′ = −

2(f ′f ′′ +g′g′′) ((f′)2 +(g′)2)2

v′ = −

2(f ′f ′′ +g′g′′) (f′)2 +(g′)2

(v′)3, or, since v′ ?= 0,

v′′ = −

f ′f ′′ +g′g′′ (f ′)2 +(g′)2

(v′)2;

that is, along the meridian the second of the equations (4a) is also satisﬁed, which shows that in fact the meridians are geodesics.

[Page 275]

Now we are going to determine which parallels v = const. u = u(s), parametrized by arc length, are geodesics. The ﬁrst of the equations (4a) gives u′ = const. and the second becomes

ff ′ (f ′)2 +(g′)2

(u′)2 = 0.

In order that the parallel v = const.,u = u(s) be a geodesic it is necessary that u′ ?= 0. Since (f′)2 +(g′)2 ?= 0 and f ?= 0, we conclude from the above equation that f′ = 0.

Inotherwords, anecessaryconditionforaparallelofasurfaceofrevolution to be a geodesic is that such a parallel be generated by the rotation of a point of the generating curve where the tangent is parallel to the axis of revolution

- (Fig. 4-19). This condition is clearly sufﬁcient, since it implies that the normal line of the parallel agrees with the normal line to the surface (Fig. 4-19).


Geodesic

Geodesic

Not a geodesic

###### Figure 4-19

We shall obtain for further use an interesting geometric consequence from the ﬁrst of the equations (4a), known as Clairaut’s relation. Observe that the ﬁrst of the equations (4a) may be written as

(f2u′)′ = f2u′′ +2ff′u′v′ = 0; hence,

f 2u′ = const. = c.

[Page 276]

On the other hand, the angle θ, 0 ≤ θ ≤ π/2, of a geodesic with a parallel that intersects it is given by

cosθ =

|?xu,xuu′ +xvv′?| |xu|

= |f u′|,

where {xu,xv} is the associated basis to the given parametrization. Since f = r is the radius of the parallel at the intersection point, we obtain Clairaut’s relation:

r cosθ = const. = |c|.

In the next example we shall show how useful this relation is. See also Exercises 18, 20, and 21.

Finally, we shall show that system (4a) may be integrated by means of primitives. Let u = u(s),v = v(s) be a geodesic parametrized by arc length, which we shall assume not to be a meridian or a parallel of the surface. The ﬁrst of the equations (4a) is then written as f2u′ = const. = c ?= 0.

Observe initially that the ﬁrst fundamental form along (u(s),v(s)),

1 = f2 ?

du ds ?2 +((f′)2 +(g′)2)?

dv ds ?2 , (5)

together with the ﬁrst of the equations (4a), is equivalent to the second of the equations (4a). In fact, by substituting f2u′ = c in Eq. (5), we obtain

?

dv ds ?2 ((f′)2 +(g′)2) = −

c2 f 2 +1;

hence, by differentiating with respect to s,

2

dv ds

d2v ds2

((f′)2 +(g′)2)+?

dv ds ?2 (2f′f ′′ +2g′g′′)

dv ds =

2ff ′c2 f 4

dv ds

,

which is equivalent to the second equation of (4a), since (u(s),v(s)) is not a parallel. (Of course the geodesic may be tangent to a parallel which is not a geodesic and then v′(s) = 0. However, Clairaut’s relation shows that this happens only at isolated points.)

On the other hand, since c ?= 0 (because the geodesic is not a meridian), we have u′(s) ?= 0. It follows that we may invert u = u(s), obtaining s = s(u), and therefore v = v(s(u)). By multiplying Eq. (5) by (ds/du)2, we obtain

[Page 277]

?

ds du?2 = f2 +((f′)2 +(g′)2)?

dv ds

ds du?2 ,

or, by using the fact that (ds/du)2 = f4/c2,

f2 = c2 +c2

(f′)2 +(g′)2 f 2 ?

dv du ?2 ,

that is,

dv du =

1 c

f ?

f 2 −c2

(f ′)2 +(g′)2; hence,

u = c ?

1 f

?

(f ′)2 +(g′)2 f 2 −c2

dv +const. (6)

which is the equation of a segment of a geodesic of a surface of revolution which is neither a parallel nor a meridian.

Example 6. We are going to show that any geodesic of a paraboloid of revolution z = x2 +y2 which is not a meridian intersects itself an inﬁnite number of times.

Let p0 be a point of the paraboloid and let P0 be the parallel of radius r0 passing through p0. Let γ be a parametrized geodesic passing through p0 and making an angle θ0 with P0. Since, by Clairaut’s relation,

r cosθ = const. = |c|, 0 ≤ θ ≤

π 2

, we conclude that θ increases with r.

Therefore, if we follow in the direction of the increasing parallels, θ increases. Itmayhappenthatinsomerevolutionsurfacesγ approachesasymptotically a meridian. We shall show in a while that such is not the case with a paraboloid of revolution. That is, the geodesic γ intersects all the meridians, and therefore it makes an inﬁnite number of turns around the paraboloid.

On the other hand, if we follow the direction of decreasing parallels, the angle θ decreases and approaches the value 0, which corresponds to a parallel of radius |c| (observe that if θ0 ?= 0, |c| < r). We shall prove later in this book that no geodesic of a surface of revolution can be asymptotic to a parallel which is not itself a geodesic (Sec. 4-7). Since no parallel of the paraboloid is a geodesic, the geodesic γ is actually tangent to the parallel of radius |c| at the pointp1. Because1isamaximumforcosθ, thevalueofr willincreasestarting from p1. We are, therefore, in the same situation as before. The geodesic will go around the paraboloid an inﬁnite number of turns, in the direction of the

[Page 278]

p0

p1

r0

p0

###### Figure 4-20

increasing r’s, and it will clearly intersect the other branch inﬁnitely often

- (Fig. 4-20).


Observe that if θ0 = 0, the initial situation is that of the point p1. It remains to show that when r increases, the geodesic γ meets all the meridians of the paraboloid. Observe initially that the geodesic cannot be tangent to a meridian. Otherwise, it would coincide with the meridian by the uniqueness part of Prop. 5. Since the angle θ increases with r, if γ did not cut all the meridians, it would approach asymptotically a meridian, say M.

Let us assume that this is the case and let us choose a system of local coordinates for the paraboloid z = x2 +y2, given by

x = v cosu, y = v sin u, z = v2, 0 < v < +∞, 0 < u < 2π,

in such a way that the corresponding coordinate neighborhood contains M as u = u0. By hypothesis u → u0 when v → ∞. On the other hand, the equation of the geodesic y in this coordinate system is given by (cf. Eq. (6)), Example 5 and choose an orientation on γ such that c > 0)

u = c ?

1 v

?

1+4v2 v2 −c2

dv +const. > c ?

dv

v +const., since

1+4v2 v2 −c2

> 1.

It follows from the above inequality that as v → ∞, u increases beyond any value, which contradicts the fact that γ approaches M asymptotically. Therefore, γ intersects all the meridians, and this completes the proof of the assertion made at the beginning of this example.

[Page 279]

###### EXERCISES

- 1. a. Show that if a curve C ⊂ S is both a line of curvature and a geodesic, then C is a plane curve.

b. Show that if a (nonrectilinear) geodesic is a plane curve, then it is a

line of curvature.

c. Give an example of a line of curvature which is a plane curve and not

a geodesic.

- 2. Prove that a curve C ⊂ S is both an asymptotic curve and a geodesic if and only if C is a (segment of a) straight line.
- 3. Show, without using Prop. 5, that the straight lines are the only geodesics of a plane.
- 4. Let v and w be vector ﬁelds along a curve α: I → S. Prove that d dt?v(t),w(t)? = ?

Dv dt

,w(t)?+?v(t),

Dw dt ?.

- 5. Consider the torus of revolution generated by rotating the circle (x −a)2 +z2 = r2, y = 0,


about the z axis (a > r > 0). The parallels generated by the points (a +r,0), (a −r,0), (a,r) are called the maximum parallel, the minimum parallel, and the upper parallel, respectively. Check which of these parallels is

- a. A geodesic.
- b. An asymptotic curve.
- c. A line of curvature.


- *6. Compute the geodesic curvature of the upper parallel of the torus of Exercise 5.

7. Intersect the cylinder x2 +y2 = 1 with a plane passing through the x

axis and making an angle θ, 0 < θ < π/2, with the xy plane.

- a. Show that the intersecting curve is an ellipse C.
- b. Compute the absolute value of the geodesic curvature of C in the cylinder at the points where C meets their principal axes.


- *8. Show that if all the geodesics of a connected surface are plane curves, then the surface is contained in a plane or a sphere.
- *9. Consider two meridians of a sphere C1 and C2 which make an angle ϕ at the point p1. Take the parallel transport of the tangent vector w0 of C1, along C1 and C2, from the initial point p1 to the point p2 where the two


[Page 280]

- meridians meet again, obtaining, respectively, w1 and w2. Compute the angle from w1 to w2.
- *10. Show that the geodesic curvature of an oriented curve C ⊂ S at a point p ∈ C is equal to the curvature of the plane curve obtained by projecting C onto the tangent plane Tp(S) along the normal to the surface at p.

11. State precisely and prove: The algebraic value of the covariant derivative

is invariant under orientation-preserving isometries.

- *12. We say that a set of regular curves on a surface S is a differentiable family of curves on S if the tangent lines to the curves of the set make up a differentiable ﬁeld of directions (see Sec. 3-4). Assume that a surface S admits two differentiable orthogonal families of geodesics. Prove that the Gaussian curvature of S is zero.
- *13. Let V be a connected neighborhood of a point p of a surface S, and assume that the parallel transport between any two points of V does not depend on the curve joining these two points. Prove that the Gaussian curvature of V is zero.


- 14. Let S be an oriented regular surface and let α: I → S be a curve parametrized by arc length. At the point p = α(s) consider the three unit vectors (the Darboux trihedron) T (s) = α′(s),N(s) = the normal vector to S at p, V (s) = N(s)∧T (s). Show tbat

dT ds = 0+aV +bN,

dV ds = −aT +0+cN, dN ds = −bT −cV +0,

where a = a(s),b = b(s),c = c(s),s ∈ I. The above formulas are the analogues of Frenet’s formulas for the trihedron T,V,N. To establish the geometrical meaning of the coefﬁcients, prove that

- a. c = −?dN/ds,V ?; conclude from this that α(I) ⊂ S is a line of curvature if and only if c ≡ 0 (-c is called the geodesic torsion of α; cf. Exercise 19, Sec. 3-2).
- b. b is the normal curvature of α(I) ⊂ S at p.
- c. a is the geodesic curvature of α(I) ⊂ S at p.


- 15. Let p0 be a pole of a unit sphere S2 and q,r be two points on the corresponding equator in such a way that the meridians p0q and p0r make an angle θ at p0. Consider a unit vector v tangent to the meridian p0q at p0, and take the parallel transport of v along the closed curve


[Page 281]

p0 θ v

r q

###### Figure 4-21

made up by the meridian p0q, the parallel qr, and the meridian rp0 (Fig. 4-21).

a. Determine the angle of the ﬁnal position of v with v. b. Do the same thing when the points r,q instead of being on the equator

are taken on a parallel of colatitude ϕ (cf. Example 1).

- *16. Let p be a point of an oriented surface S and assume that there is a neighborhood of p in S all points of which are parabolic. Prove that the (unique)asymptoticcurvethroughp isanopensegmentofastraightline. Give an example to show that the condition of having a neighborhood of parabolic points is essential.

17. Let α: I → R3 be a curve parametrized by arc length s, with nonzero curvature and torsion. Consider the parametrized surface (Sec. 2-3)

x(s,v) = α(s)+vb(s), s ∈ I,−ǫ < v < ǫ,ǫ > 0,

where b is the binormal vector of α. Prove that if ǫ is small, x(I × (−ǫ,ǫ)) = S is a regular surface over which α(I) is a geodesic (thus, every curve is a geodesic on the surface generated by its binormals).

- *18. Consider a geodesic which starts at a point p in the upper part (z > 0) of a hyperboloid of revolution x2 +y2 −z2 = 1 and makes an angle θ with the parallel passing through p in such a way that cosθ = 1/r, where r is the distance from p to the z axis. Show that by following the geodesic in the direction of decreasing parallels, it approaches asymptotically the parallel x2 +y2 = 1, z = 0 (Fig. 4-22).
- *19. Showthatwhenthedifferentialequations(4)ofthegeodesicsarereferred to the arc length then the second equation of (4) is, except for the coordinate curves, a consequence of the ﬁrst equation of (4).
- *20. Let T be a torus of revolution which we shall assume to be parametrized by (cf. Example 6, Sec. 2-2)


[Page 282]

z

r

p

y

x

θ

0

###### Figure 4-22

x(u,v) = ((r cosu+a)cosv,(r cosu+a)sin v,r sin u). Prove that

- a. If a geodesic is tangent to the parallel u = π/2, then it is entirely contained in the region of T given by

−

π 2 ≤ u ≤

π 2

.

- b. A geodesic that intersects the parallel u = 0 under an angle θ (0 < θ < π/2) also intersects the parallel u = π if


cosθ <

a −r a +r

.

- 21. Surfaces of Liouville are those surfaces for which it is possible to obtain a system of local coordinates x(u,v) such that the coefﬁcients of the ﬁrst fundamental form are written in the form


E = G = U +V, F = 0,

where U = U(u) is a function of u alone and V = V (v) is a function of v alone. Observe that the surfaces of Liouville generalize the surfaces of revolution and prove that (cf. Example 5)

a. ThegeodesicsofasurfaceofLiouvillemaybeobtainedbyintegration

in the form ?

du √U −c = ±?

dv √V +c +c1,

where c and c1 are constants that depend on the initial conditions.

[Page 283]

b. If θ, 0 ≤ θ ≤ π/2, is the angle which a geodesic makes with the

curve v = const., then U sin2 θ −V cos2 θ = const.

(Notice that this is the analogue of Clairaut’s relation for the surfaces of Liouville.)

- 22. Let S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} and let p ∈ S2. For each piecewiseregularparametrizedcurveα:[0,l] → S2 withα(0) = α(l) = p, let Pα: Tp(S2) → Tp(S2) be the map which assigns to each v ∈ Tp(S2) its parallel transport along α back to p. By Prop. 1, Pα is an isometry. Prove that for every rotation R of Tp(S) there exists an α such that R = Pα.
- 23. Show that the isometries of the unit sphere S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1}


are the restrictions to S2 of the linear orthogonal transformations of R3.

###### 4-5. The Gauss-Bonnet Theorem and Its Applications

In this section, we shall present the Gauss-Bonnet theorem and some of its consequences. The geometry involved in this theorem is fairly simple, and the difﬁculty of its proof lies in certain topological facts. These facts will be presented without proofs.

The Gauss-Bonnet theorem is probably the deepest theorem in the differential geometry of surfaces. A ﬁrst version of this theorem was presented by Gauss in a famous paper [1] and deals with geodesic triangles on surfaces (that is, triangles whose sides are arcs of geodesics). Roughly speaking, it asserts that the excess over π of the sum of the interior angles ϕ1,ϕ2,ϕ3 of a geodesic triangle T is equal to the integral of the Gaussian curvature K over T ; that is (Fig. 4-23),

?3

i=1

ϕi −π = ??

T

Kdσ.

For instance, if K ≡ 0, we obtain that

?

ϕi = π, an extension of Thales’ theorem of high school geometry to surfaces of zero curvature.Also, if K ≡ 1, we obtain that

?

ϕi −π = area (T ) > 0. Thus, on a unit sphere, the sum of the interior angles of any geodesic triangle is greater than π, and the excess over π is exactly the area of T . Similarly, on the pseudosphere (Exercise 6, Sec. 3-3) the sum of the interior angles of any geodesic triangle is smaller than π (Fig. 4-24).

[Page 284]

T

S

Geodesic

Geodesic

Geodesic

φ1 φ2 φ3

Figure 4-23. A geodesic triangle.

φ1 φ2

φ3

K ≡ −1, ∑ φi < π K ≡ −1, ∑ φi > π

φ3

- φ1
- φ2


###### Figure 4-24

The extension of the theorem to a region bounded by a nongeodesic simple curve (see Eq. (1) below) is due to O. Bonnet. To extend it even further, say, to compact surfaces, some topological considerations will come into play. Actually, one of the most important features of the Gauss-Bonnet theorem is that it provides a remarkable relation between the topology of a compact surface and the integral of its curvature (see Corollary 2 below).

We shall now begin the details of a local version of the Gauss-Bonnet theorem. We need a few deﬁnitions.

Let α: [0,l] → S be a continuous map from the closed interval [0,l] into the regular surface S. We say that α is a simple, closed, piecewise regular, parametrized curve if

- 1. α(0) = α(l).
- 2. t1 ?= t2,t1,t2 ∈ [0,l), implies that α(t1) ?= α(t2).


[Page 285]

- 3. There exists a subdivision 0 = t0 < t1 < ··· < tk < tk+1 = l,


of (0,l] such that α is differentiable and regular in each (ti,ti+1),i = 0,...,k.

Intuitively, this means that α is a closed curve (condition 1) without selfintersections (condition 2), which fails to have a well-deﬁned tangent line only at a ﬁnite number of points (condition 3).

The points α(ti),i = 0,...,k, are called the vertices of α and the traces α([ti,ti+1]) are called the regular arcs of α. It is usual to call the trace α([0,l]) of α, a closed piecewise regular curve.

By the condition of regularity, for each vertex α(ti) there exist the limit from tile left, i.e., for t < ti

lim

t→ti

α′(t) = α′(ti −0) ?= 0,

and the limit from the right, i.e., for t > ti, lim

t→ti

α′(t) = α′(ti +0) ?= 0.

Assume now that S is oriented and let |θi|,0 ≤ |θi| < π, be the smallest determination of the angle from α′(ti −0) to α′(ti +0). If |θi| ?= π, we give θi the sign of the determinant (α′(ti −0),α′(ti +0),N). This means that if the vertex α(ti) is not a “cusp” (Fig. 4-25), the sign of θi is given by the orientation of S. The signed angle θi,−π < θi < π, is called the external angle at the vertex α(ti).

In the case that α(ti) is a cusp, i.e., |θi| = π, we choose the sign of θi as follows. Let the closed simple curve α be contained in the image of a conformal parametrization with a given orientation, and assume that α(ti) is a cusp. Choose coordinate axis x0y, with α(ti) = 0, in the given orientation,

α(tj)

α(ti)

θj > 0

θi < 0

###### Figure 4-25

[Page 286]

R

0 0

y

g

g

f

f

x

x

y

α

θ = π

θ = –π

Figure 4-26. The sign of the external angle in the case of a cusp.

and assume further that the part of α arriving at α(ti) is pointing towards the negative part of the axis 0x (and, of course, the part of α leaving α(ti) is pointing to the positive part of the axis 0x).

For small ε > 0, the part of α arriving at α(ti), and near it, is given by a function f(x) = y, 0 < x < ?, and the part of α leaving ti, and near it, is given by a function g(x) = y, 0 < x < ?. If f > 0 and g < 0, we set θ(ti) = π and if f < 0 and g > 0, we set θ(ti) = −π. This settles the question of the angle at a cusp.

Let α: [0,l] → x(U) ⊂ S be a simple closed, piecewise regular, parametrized curve, with vertices α(ti) and external angles θi,i = 0,...,k.

Let ϕi: [ti,ti+1] → R be differentiable functions which measure at each t ∈ [ti,ti+1] the positive angle from xu to α?(t) (cf. Lemma 1, Sec. 4-4).

The ﬁrst topological fact that we shall present without proofs is the following.

THEOREM (of Turning Tangents). With the above notation we have for plane curves

?k

i=0

(ϕi(ti+1)−ϕi(ti))+

?k

i=0

θi = ±2π,

where the sign plus or minus depends on the orientation of α.

The theorem states that the total variation of the angle of the tangent vector to α with a given direction plus the “jumps” at the vertices is equal to 2π.

An elegant proof of this theorem has been given by H. Hopf, Compositio Math. 2 (1935), 50–62. For the case where α has no vertices, Hopf’s proof can be found in Sec. 5-7 (Theorem 2) of this book. It should be noted that Hopf’s proof is for plane curves.

###### . This settles the question of the angle at a cusp.

[Page 287]

Before stating the local version of the Gauss-Bonnet theorem we still need some terminology.

Let S be an oriented surface. A region R ⊂ S (union of a connected open set with its boundary) is called a simple region if R is homeomorphic to a disk and the boundary ∂R of R is the trace of a simple, closed, piecewise regular, parametrizedcurveα:I → S. Wesaythenthatα ispositivelyoriented if for each α(t), belonging to a regular arc, the positive orthogonal basis {α′(t),h(t)}satisﬁestheconditionthath(t)“pointstoward”R; moreprecisely, for any curve β: I → R with β(0) = α(t) and β′(0) ?= α′(t), we have that ?β′(0),h(t)? > 0. Intuitively, this means that if one is walking on the curve α in the positive direction and with one’s head pointing to N, then the region R remains to the left (Fig. 4-27). It can be shown that one of the two possible orientations of α makes it positively oriented.

h(t) β

R

N

α

α'(t) α(t) = β(0)

β'(0)

Figure 4-27. A positively oriented boundary curve.

Now let x: U ⊂ R2 → S be a parametrization of S compatible with its orientation and let R ⊂ x(U) be a bounded region of S. If f is a differentiable function on S, then it is easily seen that the integral

??

x−1(R)

f(u,v)

?

EG −F2 dudv

does not depend on the parametrization x, chosen in the class of orientation of x. (The proof is the same as in the deﬁnition of area; cf. Sec. 2-5.) This integral has, therefore, a geometrical meaning and is called the integral of f over the region R. It is usual to denote it by

??

R

f dσ.

[Page 288]

With these deﬁnitions, we now state the

GAUSS-BONNETTHEOREM (Local). Let x: U → S be an isothermal parametrization (i.e., F = 0, E = G = λ2(u,v)). See Sec. 4.2 after Prop. 2) of an oriented surface S, where U ⊂ R2 is homeomorphic to an open disk and x is compatible with the orientation of S.

Let R ⊂ x(U) be a simple region of S and let α: I → S be such that ∂R = α(I). Assume that α is positively oriented, parametrized by arc length s, and let α(s0),...,α(sk) and θ0,...,θk be, respectively, the vertices and the external angles of α. Then

?k

i=0

? s

i+1

si

kg(S)ds+??

R

K dσ +

?k

i=0

θi = 2π, (1)

where kg(s) is the geodesic curvature of the regular arcs of α and K is the Gaussian curvature of S.

Remark. The restriction that the region R be contained in the image set of an isothermal parametrization is needed only to simplify the proof and to be abletousethetheoremofturningtangents.Asweshallseelater(Corollary1of the global Gauss-Bonnet theorem) the above result still holds for any simple region of a regular surface. This is quite plausible, since Eq. (1) does not involve in any way a particular parametrization.†

Proof. Let u = u(s),v = v(s) be the expression of α in the parametrization x. By using Prop. 3 of Sec. 4-4, we have

kg(s) =

1 2√EG ?Gu

dv ds −Ev

du ds ?+

dϕi ds

,

where ϕi = ϕi(s) is a differentiable function which measures the positive angle from xu to α′(s) in [si,si+1]. By integrating the above expression in every interval [si,si+1] and adding up the results,

?k

i=0

? s

i+1

si

kg(s)ds =

?k

i=0

? s

i+1

si

?

Gu 2√EG

dv ds −

Ev 2√EG

du ds ?ds

+

?k

i=0

? s

i+1

si

dϕi ds

ds.

Now we use the Gauss-Green theorem in the uv plane which states the following: If P(u,v) and Q(u,v) are differentiable functions in a simple region A ⊂ R2, tire boundary of which is given by u = u(s),v = v(s), then

†If the truth of this assertion is assumed, applications 2 and 6 given below can be presented now.

[Page 289]

?k

i=0

? s

i+1

si

?P

du ds +Q

dv ds ?ds = ??

A

?

∂Q ∂u −

∂P ∂v ?dudv.

It follows that ?k

i=0

? s

i+1

si

kg(s)ds = ??

x−1(R)

??

Ev 2√EG?

v

+?

Gu 2√EG?

u

?dudv

+

?k

i=0

? s

i+1

si

dϕi ds

ds.

To be able to use the theorem of turning tangents, we must assume that our parametrization is isothermal, that is, in addition to F = 0, we have that E = G = λ(u,v) > 0. In this case,

?

Ev 2√EG?

v

+?

Gu 2√EG?

u

=

- 1

- 2 ??


λv λ ?

v

+?

λu λ ?

u

?

=

- 1

- 2λ{(log λ)vv +(log λ)uu}λ


=

- 1

- 2λ


(?log λ)λ = −Kλ,

where, in the last equality we have used the Exercise 2 of Section 4-3. By integratingtheaboveexpressioninthedomainofthecoordinateneighborhood, we obtain

?k

i=0

? s

i+1

si

kg(s)ds = −??

R

Kλdudv +?

i

? s

i+1

si

dϕi ds

ds

On the other hand, by the theorem of turning tangents, ?k

i=0

? s

i+1

si

dϕi ds

ds =

?k

i=0

(ϕi(si+1)−ϕi(si))

= ±2π −

?k

i=0

θi.

Since the curve α is positively oriented, the sign should be plus, as can easily be seen in the particular case of the circle in a plane.

By putting these facts together, we obtain ?k

i=0

? s

i+1

si

kg(s)ds +??

R

K dσ +

?k

i=0

###### θi = 2π. Q.E.D.

[Page 290]

Before going into a global version of the Gauss-Bonnet theorem, we would like to show how the techniques used in the proof of this theorem may also be used to give an interpretation of the Gaussian curvature in terms of parallelism.

To do that, let x: U → S be an isothermal parametrization at a point p ∈ S, and let R ⊂ x(U) be a simple region without vertices, containing p in its interior. Let α: [0,l] → x(U) be a curve parametrized by arc length s such that the trace of α is the boundary of R. Let w0 be a unit vector tangent to S at α(0) and let w(s),s ∈ [0,l], be the parallel transport of w0 along α (Fig. 4-28). By using Prop. 3 of Sec. 4-4 and the Gauss-Green theorem in the uv plane, we obtain

0 = ? l

0

?

Dw ds ?ds

= ? l

0

1 2√EG ?Gu

dv ds −Ev

du ds ?ds +? l

0

dϕ ds

ds

= −??

R

K dσ +ϕ(l)−ϕ(0),

R

p

w(s) α(0)

w(l)

w0 α ∆φ

###### Figure 4-28

where ϕ = ϕ(s) is a differentiable determination of the angle from xu to w(s). It follows that ϕ(l)−ϕ(0) = ?ϕ is given by

?ϕ = ??

R

K dσ. (2)

Now, ?ϕ does not depend on the choice of w0, and it follows from the expression above that ?ϕ does not depend on the choice of α(0) either. By taking the limit (in the sense of Prop. 2, Sec. 3-3)

lim

R→p

?ϕ A(R) = K(p),

where A(R) denotes the area of the region R, we obtain the desired interpretation of K.

[Page 291]

To globalize the Gauss-Bonnet theorem, we need further topological preliminaries.

Let S be a regular surface. A connected region R ⊂ S is said to be regular if R is compact and its boundary ∂R is the ﬁnite union of (simple) closed piecewise regular curves which do not intersect (the region in Fig. 4-29(a) is regular, but that in Fig. 4-29(b) is not). For convenience, we shall consider a compact surface as a regular region, the boundary of which is empty.

(a) (b)

###### Figure 4-29

Asimple region which has only three vertices with external angles αi ?= 0, i = l,2,3, is called a triangle.

A triangulation of a regular region R ⊂ S is a ﬁnite family J of triangles Ti,= 1,...,n, such that

1.

?n i=1 Ti = R.

2. If Ti ∩Tj ?= φ, then Ti ∩Tj is either a common edge of Ti and Tj or a common vertex of Ti and Tj.

Given a triangulation J of a regular region R ⊂ S of a surface S, we shall denote by F the number of triangles (faces), by E the number of sides (edges), and by V the number of vertices of the triangulation. The number

F −E +V = χ is called the Euler-Poincaré characteristic of the triangulation.

The following propositions are presented without proofs. An exposition of these facts may be found, for instance, in L. Ahlfors and L. Sario, Riemann Surfaces, Princeton University Press, Princeton, N.J., 1960, Chap. 1.

PROPOSITION 1. Every regular region of a regular surface admits a triangulation.

[Page 292]

PROPOSITION 2. Let S be an oriented surface and {xα},α ∈ A, a family of parametrizations compatible with the orientation of S. Let R ⊂ S be a regular region of S. Then there is a triangulation of J of R such that every triangle T ∈ J is contained in some coordinate neighborhood of the family {xα}. Furthermore, if the boundary of every triangle of J is positively oriented, adjacent triangles determine opposite orientations in the common edge (Fig. 4-30).

###### Figure 4-30

PROPOSITION 3. If R ⊂ S is a regular region of a surface S, the EulerPoincaré characteristic does not depend on the triangulation of R. It is convenient, therefore, to denote it by χ(R).

The latter proposition shows that the Euler-Poincaré characteristic is a topological invariant of the regular region R. For the sake of the applications of the Gauss-Bonnet theorem, we shall mention the important fact that this invariant allows a topological classiﬁcation of the compact surfaces in R3.

It should be observed that a direct computation shows that the EulerPoincaré characteristic of the sphere is 2, that of the torus (sphere with one “handle”; see Fig. 4-31) is zero, that of the double torus (sphere with two handles) is −2, and, in general, that of the n-torus (sphere with n handles) is −2(n−1).

Thefollowingpropositionshowsthatthislistexhaustsallcompactsurfaces in R3.

PROPOSITION 4. Let S ⊂ R3 be a compact connected surface; then one of the values 2,0,−2,...,−2n,.... is assumed by the Euler-Poincaré characteristic χ(S). Furthermore, if S′ ⊂ R3 is another compact surface and χ(S) = χ(S′), then S is homeomorphic to S′.

Inotherwords, everycompactconnectedsurfaceS ⊂ R3 ishomeomorphic to a sphere with a certain number g of handles. The number

g =

2−χ(S) 2 is called the genus of S.

Finally, let R ⊂ S be a regular region of an oriented surface S and let J be a triangulation of R such that every triangle Tj ∈ J,j = 1,...,k, is

[Page 293]

Sphere χ = 2

Torus 2-Torus

Sphere with one handle χ = 0 Sphere with two handles χ = –2

###### Figure 4-31

contained in a coordinate neighborhood xj(Uj) of a family of parametrizations {xα},α ∈ A, compatible with the orientation of S. Let f be a differentiable function on S. The following proposition shows that it makes sense to talk about the integral of f over the region R.

PROPOSITION 5. With the above notation, the sum

?k

j=1

??

x−1

j (Tj)

f(ui,vj)

?

EjGj −F2j duj dvj

does not depend on the triangulation J or on the family {xj} of parametrizations of S.

This sum has, therefore, a geometrical meaning and is called the integral of f over the regular region R. It is usually denoted by

??

R

f dσ.

We are now in a position to state and prove the

GLOBAL GAUSS-BONNET THEOREM. Let R ⊂ S be a regular region of an oriented surface and let C1,...,Cn be the closed, simple, piecewise regular curves which form the boundary ∂R of R. Suppose that each Ci is positively oriented and let θ1,...,θp be the set of all external angles of the curves C1,...,Cn. Then

?n

i=1

?

ci

kg(s)ds+??

R

K dσ +

?p

l=1

θl = 2πχ(R),

[Page 294]

where s denotes the arc length of Ci, and the integral over Ci means the sum of integrals in every regular arc of Ci.

Proof. Consider a triangulation J of the region R such that every triangle Tj is contained in a coordinate neighborhood of a family of isothermal parametrizations compatible with the orientation of S. Such a triangulation exists by Prop. 2. Furthermore, if the boundary of every triangle of J is positivelyoriented, weobtainoppositeorientationsintheedgeswhicharecommon to adjacent triangles (Fig. 4-32).

| |
|---|


###### Figure 4-32

By applying to every triangle the local Gauss-Bonnet theorem and adding up the results we obtain, using Prop. 5 and the fact that each “interior” side is described twice in opposite orientations,

?

i

?

ci

kg(s)ds +??

R

K dσ +

?F,3

j,k=1

θjk = 2πF,

where F denotes the number of triangles of J, and θj1,θj2,θj3 are the external angles of the triangle Tj.

We shall now introduce the interior angles of the triangle Tj, given by ϕjk = π −θjk. Thus,

?

j,k

θjk = ?

j,k

π −?

j,k

ϕjk = 3πF −?

j,k

ϕjk.

We shall use the following notation:

Ee = number of external edges of J, Ei = number of internal edges of J, Ve = number of external vertices of J, Vi = number of internal vertices of J.

[Page 295]

Since the curves Ci are closed, Ee = Ve. Furthermore, it is easy to show by induction that

3F = 2Ei +Ee and therefore that

?

j,k

θjk = 2πEi +πEe −?

j,k

ϕjk.

We observe now that the external vertices may be either vertices of some curve Ci or vertices introduced by the triangulation. We set Ve = Vec +Vet, where Vec is the number of vertices of the curves Ci and Vet is the number of external vertices of the triangulation which are not vertices of some curve Ci. Since the sum of angles around each internal vertex is 2π, we obtain

?

j,k

θjk = 2πEi +πEe −2πVi −πVet −?

l

(π −θi).

By adding πEe to and subtracting it from the expression above and taking into consideration that Ee = Ve, we conclude that

?

j,k

θjk = 2πEi +2πEe −2πVi −πVe −πVet −πVec +?

l

θi

= 2πE −2πV +?

i

θi.

By putting things together, we ﬁnally obtain ?n

i=1

?

Ci

kg(s)ds +??

R

K dσ +

?p

i=1

θl = 2π(F −E +V )

= 2πχ(R). Q.E.D. Since the Euler-Poincaré characteristic of a simple region is clearly 1, we

obtain (cf. Remark 1)

COROLLARY 1. If R is a simple region of S, then

?k

i=0

? s

i+1

si

kg(s)ds+??

R

K dσ +

?k

i=0

θi = 2π.

By taking into account the fact that a compact surface may be considered as a region with empty boundary, we obtain

[Page 296]

COROLLARY 2. Let S be an orientable compact surface; then

??

s

K dσ = 2πχ(S).

Corollary 2 is most striking. We have only to think of all possible shapes ofasurfacehomeomorphictoaspheretoﬁnditverysurprisingthatineachcase the curvature function distributes itself in such a way that the “total curvature,” i.e.,

??

K dσ, is the same for all cases.

We shall present some applications of the Gauss-Bonnet theorem below. For these applications (and for the exercises at the end of the section), it is convenient toassumeabasicfact ofthetopologyoftheplane(the Jordan curve theorem) which we shall use in the following form: Every closed piecewise regular curve in the plane (thus without self-intersections) is the boundary of a simple region.

1. A compact surface of positive curvature is homeomorphic to a sphere. The Euler-Poincaré characteristic of such a surface is positive and the

sphere is the only compact surface of R3 which satisﬁes this condition.

2. Let S be an orientable surface of negative or zero curvature. Then two geodesics γ1 and γ2 which start from a point p ∈ S cannot meet again at a point q ∈ S in such a way that the traces of γ1 and γ2 constitute the boundary of a simple region R of S.

Assume that the contrary is true. By the Gauss-Bonnet theorem (R is simple) ??

R

K dσ +θ1 +θ2 = 2π,

where θ1 and θ2 are the external angles of the region R. Since the geodesics γ1 and γ2 cannot be mutually tangent, we have θi < π,i = 1,2. On the other hand, K ≤ 0, whence the contradiction.

When θ1 = θ2 = 0, the traces of the geodesics γ1 and γ2 constitute a simple closed geodesic of S (that is, a closed regular curve which is a geodesic). It follows that on a surface of zero or negative curvature, there exists no simple closed geodesic which is a boundary of a simple region of S.

3. Let S be a surface diffeomorphic (i.e., there exists a differentiable map which has a differentiable inverse) to a cylinder with Gaussian curvature K < 0. Then S has at most one simple closed geodesic.

Suppose that S contains one simple closed geodesic Ŵ. By application 2, and since there is a diffeomorphism ϕ of S with a plane P minus one point q ∈ P,ϕ(Ŵ) is the boundary of a simple region of P containing q.

Assume now that S contains another simple closed geodesic Ŵ′. We claim that Ŵ′ does not intersect Ŵ. Otherwise, the arcs of ϕ(Ŵ) and ϕ(Ŵ′) between

[Page 297]

φ(Γ′)

Γ′

Γ

φ(Γ) r2

φ

r2

r1 r1

q

###### Figure 4-33

two “consecutive” intersection points, r1 and r2, would be the boundary of a simple region, contradicting application 2 (see Fig. 4-33). We can now apply the Gauss-Bonnet theorem to the region R bounded by two simple, non-intersecting geodesics Ŵ and Ŵ′ of S. Since χ(R) = 0, we obtain

??

ϕ−1(R)

K dσ = 2πχ(R) = 0,

which is a contradiction, since K < 0.

4. If there exist two simple closed geodesics Ŵ1 and Ŵ2 on a compact, connected surface S of positive curvature, then Ŵ1 and Ŵ2 intersect.

By application 1, S is homeomorphic to a sphere. If Ŵ1 and Ŵ2 do not intersect, then the set formed by Ŵ1 and Ŵ2 is the boundary of a region R, the Euler-Poincaré characteristic of which is χ(R) = 0. By the Gauss-Bonnet theorem,

??

R

K dσ = 0,

which is a contradiction, since K > 0.

5. We shall prove the following result, due to Jacobi: Let α: I → R3 be a closed, regular, parametrized curve with nonzero curvature. Assume that the curve described by the normal vector n(s) in the unit sphere S2 (the normal indicatrix) is simple. Then n(I) divides S2 in two regions with equal areas.

We may assume that α is parametrized by arc length. Let s¯ denote the arc length of the curve n = n(s) on S2. The geodesic curvature k¯g of n(s) is

k¯g = ?¨n,n∧n˙?,

[Page 298]

where the dots denote differentiation with respect to s¯. Since

n˙ =

dn ds

ds ds¯ = (−kt −τb)

ds ds¯

,

n¨ = (−kt −τb)

d2s ds¯2 +(−k′t −τ′b)?

ds ds¯?2 −(k2 +τ2)n?

ds ds¯?2 ,

and ?

ds ds¯?2 =

1 k2 +τ2

,

we obtain

k¯g = ?n∧n,˙ n¨? =

ds ds¯?(kb −τt),n¨? = ?

ds ds¯?3 (−kτ′ +k′τ)

= −

τ′k −k′τ k2 +τ2

ds ds¯ = −

d ds

tan−1

?τ k ? ds ds¯

.

Thus, by applying the Gauss-Bonnet theorem to one of the regions R bounded by n(I) and using the fact that K ≡ 1, we obtain

2π = ?

R

K dσ +?

∂R

k¯g ds¯ = ?

R

dσ = area of R.

Since the area of S2 is 4π, the result follows.

6. Let T be a geodesic triangle (that is, the sides of T are geodesics) in an oriented surface S. Assume that Gauss curvature K does not change sign in T . Let θ1,θ2,θ3 be the external angles of T and let ϕ1 = π −θ1, ϕ2 = π −θ2,ϕ3 = π −θ3 beitsinteriorangles. BytheGauss-Bonnettheorem,

??

T

K dσ +

?3

i=1

θi = 2π.

Thus,

??

T

K dσ = 2π −

?3

i=1

(π −ϕi) = −π +

?3

i=1

ϕi.

It follows that the sum of the interior angles,

?3

i=1 ϕi, of a geodesic triangle is

- 1. Equal to π if K = 0.
- 2. Greater than π if K > 0.
- 3. Smaller than π if K < 0.


[Page 299]

Furthermore, the difference

?3

i=1 ϕi −π (the excess of T ) is given precisely by

??

T K dσ. If K ?= 0 on T , this is the area of the image N(T ) of T by the Gauss map N: S → S2 (cf. Eq. (12), Sec. 3-3). This was the form in which Gauss himself stated his theorem: The excess of a geodesic triangle T is equal to the area of its spherical image N(T).

The above fact is related to a historical controversy about the possibility of proving Euclid’s ﬁfth axiom (the axiom of the parallels), from which it follows that the sum of the interior angles of any triangle is equal to π. By considering thegeodesicsasstraightlines, itispossibletoshowthatthesurfacesofconstant negative curvature constitute a (local) model of a geometry where Euclid’s axiomshold, exceptfortheﬁfthandtheaxiomwhichguaranteesthepossibility ofextendingstraightlinesindeﬁnitely.Actually, Hilbertshowedthattheredoes not exist in R3 a surface of constant negative curvature, the geodesics of which can be extended indeﬁnitely (the pseudosphere of Exercise 6, Sec. 3-3, has an edge of singular points). Therefore, the surfaces of R3 with constant negative Gaussian curvature do not yield a model to test the independence of the ﬁfth axiom alone. However, by using the notion of abstract surface, it is possible to bypass this inconvenience and to build a model of geometry where all of Euclid’s axioms but the ﬁfth are valid. This axiom is, therefore, independent of the others.

In Sees. 5-10 and 5-11, we shall prove the result of Hilbert just quoted and shall describe the abstract model of a non-Euclidean geometry.

7. Vector ﬁelds on surfaces.† Let v be a differentiable vector ﬁeld on an oriented surface S. We say that p ∈ S is a singular point of v if v(p) = 0. The singular point p is isolated if there exists a neighborhood V of p in S such that v has no singular points in V other than p.

To each isolated singular point p of a vector ﬁeld v, we shall associate an integer, the index of v, deﬁned as follows. Let x: U → S be an orthogonal parametrization at p = x(0,0) compatible with the orientation of S, and let α: [0,l] → S be a simple, closed, positively-oriented piecewise regular parametrized curve such that α([0,l]) ⊂ x(U) is the boundary of a simple region R containing p as its only singular point. Let v = v(t),t ∈ [0,l], be the restriction of v along α, and let ϕ = ϕ(t) be some differentiable determination of the angle from xu to v(t), given by Lemma 1 of Sec. 4-4 (which can easily be extended to piecewise regular curves). Since α is closed, there is an integer I deﬁned by

2πI = ϕ(l)−ϕ(0) = ? l

0

dϕ dt

dt.

I is called the index of v at p.

†This application requires the material of Sec. 3-4. If omitted, then Exercises 6–9 of this section should also be omitted.

[Page 300]

We must show that this deﬁnition is independent of the choices made, the ﬁrst one being the parametrization x. Let w0 ∈ Tα(0)(S) and let w(t) be the parallel transport of w0 along α. Let ψ(t) be a differentiable determination of the angle from xu to w(t). Then, as we have seen in the interpretation of K in terms of parallel transport (cf. Eq. (2)),

ψ(l)−ψ(0) = ??

R

K dσ.

By subtracting the above relations, we obtain ??

R

K dσ −2πI = (ψ −ϕ)(l)−(ψ −ϕ)(0) = ?(ψ −ϕ) (3)

Since ψ −ϕ does not depend on xu, the index I is independent of the parametrization x.

Theproofthattheindexdoesnotdependonthechoiceofα ismoretechnical (although rather intuitive) and we shall only sketch it.

Let α0 and α1 be two curves as in the deﬁnition of index and let us show that the index of v is the same for both curves. We ﬁrst suppose that the traces of α0 and α1 do not intersect. Then there is a homeomorphism of the region bounded by the traces of α0 and α1 onto a region of the plane bounded by two concentric circles C0 and C1 (an annulus). Since we can obtain a family of concentric circles Ct which depend continuously on t and deform C0 into C1, we obtain a family of curves αt, which depend continuously on t and deform α0 into α1 (Fig. 4-34). Denote by It the index of v computed with the curve αt. Now, since the index is an integral, It depends continuously on t, t ∈ [0,1]. Being an integer, It is constant under this deformation, and I0 = I1, as we wished. If the traces of α0 and α1 intersect, we choose a curve sufﬁciently small so that its trace has no intersection with both α0 and α1 and then apply the previous result.

It should be noticed that the deﬁnition of index can still be applied when p is not a singular point of v. It turns out, however, that the index is then zero.

U

x

S

p C1

α1

C0 Ct α0

φ

x (U)

###### Figure 4-34

[Page 301]

This follows from the fact that, since I does not depend on xu, we can choose xu to be v itself; thus, ϕ(t) ≡ 0.

In Fig. 4-35 we show some examples of indices of vector ﬁelds in the xy plane which have (0, 0) as a singular point. The curves that appear in the drawings are the trajectories of the vector ﬁelds.

v = (–x, –y) I = 1

v = (–y, x) I = 1

v = (–x, y) I = –1

I = –3

###### Figure 4-35

Now, let S ⊂ R3 be an oriented, compact surface and v a differentiable vector ﬁeld with only isolated singular points. We remark that they are ﬁnite in number. Otherwise, by compactness (cf. Sec. 2-7, Property 1), they have a limit point which is a nonisolated singular point. Let {xα} be a family of orthogonal parametrizations compatible with the orientation of S. Let J be a triangulation of S such that

- 1. Every triangle T ∈ J is contained in some coordinate neighborhood of the family {xα}.
- 2. Every T ∈ J contains at most one singular point.
- 3. TheboundaryofeveryT ∈ Jcontainsnosingularpointsandispositively oriented.


If we apply Eq. (3) to every triangle T ∈ J, sum up the results, and take into account that the edge of each T ∈ J appears twice with opposite orientations, we obtain

??

s

K dσ −2π

?k

i=1

Ii = 0,

where Ii is the index of the singular point pi,i = 1,...,k. Joining this with the Gauss-Bonnet theorem (cf. Corollary 2), we ﬁnally arrive at

?

Ii =

- 1

- 2π ??


S

K dσ = χ(S).

[Page 302]

Thus, we have proved the following:

POINCARÉ’S THEOREM. The sum of the indices of a differentiable vector ﬁeld v with isolated singular points on a compact surface S is equal to the Euler-Poincaré characteristic of S.

This is a remarkable result. It implies that

?

Ii does not depend on v but only on the topology of S. For instance, in any surface homeomorphic to a sphere, all vector ﬁelds with isolated singularities must have the sum of their indices equal to 2. In particular, no such surface can have a differentiable vector ﬁeld without singular points.

###### EXERCISES

- 1. Let S ⊂ R3 be a regular, compact, connected, orientable surface which is not homeomorphic to a sphere. Prove that there are points on S where the Gaussian curvature is positive, negative, and zero.
- 2. Let T be a torus of revolution. Describe the image of the Gauss map of T and show, without using the Gauss-Bonnet theorem, that

??

T

K dσ = 0.

Compute the Euler-Poincaré characteristic of T and check the above result with the Gauss-Bonnet theorem.

- 3. Let S ⊂ R3 be a regular compact surface with K > 0. Let Ŵ ⊂ S be a simple closed geodesic in S, and let A and B be the regions of S which have Ŵ as a common boundary. Let N: S → S2 be the Gauss map of S. Prove that N(A) and N(B) have the same area.
- 4. Compute the Euler-Poincaré characteristic of

a. An ellipsoid.

*b. The surface S = {(x,y,z) ∈ R3;x2 +y10 +z6 = 1}.

- 5. Let C be a parallel of colatitude ϕ on an oriented unit sphere S2, and let w0 be a unit vector tangent to C at a point p ∈ C (cf. Example 1, Sec. 4-4).


Take the parallel transport of w0 along C and show that its position, after a completeturn, makesanangle?ϕ = 2π(1−cosϕ)withtheinitialposition w0. Check that

lim

R→p

?ϕ A = 1 = curvature of S2,

where A is the area of the region R of S2 bounded by C.

[Page 303]

- 6. Show that (0, 0) is an isolated singular point and compute the index at (0, 0) of the following vector ﬁelds in the plane:

- *a. v = (x,y). b. v = (−x,y). c. v = (x,−y).
- *d. v = (x2 −y2,−2xy). e. v = (x3 −3xy2,y3 −3x2y).


- 7. Can it happen that the index of a singular point is zero? If so, give an example.
- 8. Prove that an orientable compact surface S ⊂ R3 has a differentiable vector ﬁeld without singular points if and only if S is homeomorphic to a torus.
- 9. Let C be a regular closed simple curve on a sphere S2. Let v be a differentiable vector ﬁeld on S2 with isolated singularities such that the trajectories of v are never tangent to C. Prove that each of the two regions determined by C contains at least one singular point of v.


###### 4-6. The Exponential Map. Geodesic Polar Coordinates

In this section we shall introduce some special coordinate systems with an eye toward their geometric applications. The natural way of introducing such coordinates is by means of the exponential map, which we shall now describe.

As we learned in Sec. 4-4, Prop. 5, given a point p of a regular surface S and a nonzero vector v ∈ Tp(S) there exists a unique parametrized geodesic γ: (−ǫ,ǫ) → S, with γ(0) = p and γ′(0) = v. To indicate the dependence of this geodesic on the vector v, it is convenient to denote it by γ(t,v) = γ.

LEMMA 1. If the geodesic γ(t,v) is deﬁned for t ∈ (−ǫ,ǫ), then the geodesic γ(t,λv), λ ∈ R, λ > 0, is deﬁned for t ∈ (−ǫ/λ,ǫ/λ), and γ(t,λv) = γ(λt,v).

Proof. Let α: (−ǫ/λ,ǫ/λ) → S be a parametrized curve deﬁned by α(t) = γ(λt). Then α(0) = γ(0),α′(0) = λγ′(0), and, by the linearity of D (cf. Eq. (1), Sec. 4-4),

Dα′(t)α′(t) = λ2Dγ′(t)γ′(t) = 0.

If follows that α is a geodesic with initial conditions γ(0),λγ′(0), and by uniqueness

α(t) = γ(t,λv) = γ(λt,v) Q.E.D.

[Page 304]

Intuitively, Lemma 1 means that since the speed of a geodesic is constant, we can go over its trace within a prescribed time by adjusting our speed appropriately.

We shall now introduce the following notation. If v ∈ Tp(S),v ?= 0, is such that γ(|v|,v/|v|) = γ(1,v) is deﬁned, we set

expp(v) = γ(1,v) and expp(0) = p.

Geometrically, the construction corresponds to laying off (if possible) a length equal to |v| along the geodesic that passes through p in the direction of v; the point of S thus obtained is denoted by expp(v) (Fig. 4-36).

p

u

expp(u)

Tp(S2)

p S

u

Tp(S)

###### Figure 4-36 Figure 4-37

For example, expp(v) is deﬁned on the unit sphere S2 for every v ∈ Tp(S2). The points of the circles of radii π,3π,...,(2n+1)π are mapped into the point q, the antipodal point of p. The points of the circles of radii 2π,4π,...,2nπ are mapped back into p.

On the other hand, on the regular surface C formed by the one-sheeted

cone minus the vertex, expp(v) is not deﬁned for a vector v ∈ Tp(C) in the direction of the meridian that connects p to the vertex, when |v| ≥ d and d is the distance from p to the vertex (Fig. 4-37).

If, in the example of the sphere, we remove from S2 the antipodal point of

p, then expp(v) is deﬁned only in the interior of a disk of Tp(S2) of radius π and center in the origin.

The important point is that expp is always deﬁned and differentiable in some neighborhood of the origin of Tp(S).

PROPOSITION 1. Given p ∈ S there exists an ǫ > 0 such that expp is deﬁned and differentiable in the interior Bǫ of a disk of radius ǫ of Tp(S), with center in the origin.

[Page 305]

Proof. It is clear that for every direction of Tp(S) it is possible, by Lemma 1, to take v sufﬁciently small so that the interval of deﬁnition of γ(t,v) contains 1, and thus γ(1,v) = expp(v) is deﬁned. To show that this reduction can be made uniformly in all directions, we need the theorem of the dependence of a geodesic on its initial conditions (see Sec. 4-7) in the following form: Given p ∈ S there exist numbers ǫ1 > 0,ǫ2 > 0 and a differentiable map

γ: (−ǫ2,ǫ2)×Bǫ1 → S

such that, for v ∈ Bǫ1,v ?= 0,t ∈ (−ǫ2,ǫ2), the curve γ(t,v) is the geodesic of S with γ(0,v) = p,γ′(0,v) = v, and for v = 0,γ(t,0) = p.

From this statement and Lemma 1, our assertion follows. In fact, since γ(t,v) is deﬁned for |t| < ǫ2,|v| < ǫ1, we obtain, by setting λ = ǫ2/2 in Lemma 1, that γ(t,(ǫ2/2)v) is deﬁned for |t| < 2,|v| < ǫ1. Therefore, by taking a disk Bǫ ⊂ Tp(S), with center at the origin and radius ǫ < ǫ1ǫ2/2, we have that γ(1,w) = expp w,w ∈ Bǫ, is deﬁned. The differentiability of expp in Bǫ follows from the differentiability of γ. Q.E.D.

An important complement to this result is the following: PROPOSITION 2. expp: Bǫ ⊂ Tp(S) → S is a diffeomorphism in a

neighborhood U ⊂ B, of the origin 0 of Tp(S).

Proof. We shall show that the differential d(expp) is nonsingular at 0 ∈ Tp(S). To do this, we identify the space of tangent vectors to Tp(S) at 0 with Tp(S) itself. Consider the curve α(t) = tv,v ∈ Tp(S). It is obvious that α(0) = 0 and α′(0) = v. The curve (expp ◦α)(t) = expp(tv) has at t = 0 the tangent vector

d dt

(expp(tv))?

t=0

=

d dt

(γ(t,v))?

t=0

= v.

It follows that

(d expp)0 = v,

which shows that d expp is nonsingular at 0. By applying the inverse function theorem (cf. Prop. 3, Sec. 2-4), we complete the proof of the proposition.

###### Q.E.D.

It is convenient to call V ⊂ S a normal neighborhood of p ∈ S if V is the image V = expp(U) of a neighborhood U of the origin of Tp(S) restricted to which expp is a diffeomorphism.

Since the exponential map at p ∈ S is a diffeomorphism on U, it may be used to introduce coordinates in V . Among the coordinate systems thus introduced, the most usual are

[Page 306]

Tp(S)

expp(ρ,θ) (ρ,θ)

ρ

L p

l S

A radial geodesic

A geodesic circle

θ

Figure 4-38. Polar coordinates.

- 1. The normal coordinates which correspond to a system of rectangular coordinates in the tangent plane Tp(S).
- 2. The geodesic polar coordinates which correspond to polar coordinates in the tangent plane Tp(S) (Fig. 4-38).


We shall ﬁrst study the normal coordinates, which are obtained by choosing in the plane Tp(S),p ∈ S, two orthogonal unit vectors e1 and e2. Since expp : U → V ⊂ S is a diffeomorphism, it satisﬁes the conditions for a parametrization in p. If q ∈ V , then q = expp(w), where w = ue1 +ve2 ∈ U, and we say that q has coordinates (u,v). It is clear that the normal coordinates thus obtained depend on the choice of e1,e2.

In a system of normal coordinates centered in p, the geodesics that pass

through p are the images by expp of the lines u = at,v = bt which pass through the origin of Tp(S). Observe also that at p the coefﬁcients of the ﬁrst fundamentalforminsuchasystemaregivenbyE(p) = G(p) = 1,F(p) = 0.

Now we shall proceed to the geodesic polar coordinates. Choose in the plane Tp(S),p ∈ S, a system of polar coordinates (ρ,θ) where ρ is the polar radius and θ,0 < θ < 2π, is the polar angle, the pole of which is the origin 0 of Tp(S). Observe that the polar coordinates in the plane are not deﬁned in the closed half-line l which corresponds to θ = 0. Set expp(l) = L.

[Page 307]

Since expp : U −l → V −L is still a diffeomorphism, we may parametrize the points of V −L by the coordinates (ρ,θ), which are called geodesic polar coordinates.

We shall use the following terminology. The images by expp : U → V of circles in U centered in 0 will be called geodesic circles of V , and the images of expp of the lines through 0 will be called radial geodesics of V . In V −L these are the curves ρ = const. and θ = const., respectively.

We shall now determine the coefﬁcients of the ﬁrst fundamental form in a system of geodesic polar coordinates.

PROPOSITION 3. Let x: U −l → V −L be a system of geodesic polar coordinates (ρ,θ). Then the coefﬁcients E = E(ρ,θ),F = F(ρ,θ), and G = G(ρ,θ) of the ﬁrst fundamental form satisfy the conditions

E = 1, F = 0, lim

ρ→0

G = 0, lim

ρ→0

(

√G)ρ = 1.

Proof. By deﬁnition of the exponential map, ρ measures the arc length along the curve θ = const. It follows immediate that E = 1.

To prove that F = 0, we ﬁrst prove that Fρ = 0. Since ?∂ρ∂x, ∂θ∂x? = F, we obtain

Fρ = ?

∂2x ∂ρ2

,

∂x ∂θ ?+?

∂x ∂ρ

,

∂2x

∂θ∂ρ ?. Since θ = const. is a geodesic, we have

Fρ = ?

∂x ∂ρ

,

∂ ∂θ ?

∂x ∂ρ ??

=

- 1

- 2


∂ ∂θ +?

∂x ∂ρ

,

∂x ∂ρ ? = 0,

as we claimed. Thus F(ρ,θ) does not depend on ρ.

For each q ∈ V , we shall denote by α(σ) the geodesic circle that passes throughq, whereσ ∈ [0,2π](ifq = p,α(σ)istheconstantcurveα(σ) = p). We shall denote by γ(s), where s is the arc length of γ, the radial geodesic that passes through q. With this notation we may write

F(ρ,θ) = ?

dα dσ

,

dγ ds ?.

The coefﬁcient F(ρ,θ) is not deﬁned at p. However, if we ﬁx the radial geodesic θ = const., the second member of the above equation is deﬁned for every point of this geodesic. Since at p,α(σ) = p, that is, dα/dσ = 0, we obtain

lim

ρ→0

F(ρ,θ) = lim

ρ→0

?

dα dσ

,

dγ ds ? = 0.

Together with the fact that F does not depend on ρ, this implies that F = 0.

[Page 308]

To prove the last assertion of the proposition, we choose a system of normal

coordinates (u,¯ v)¯ in p in such a way that the change of coordinates is given by u¯ = ρ cosθ, v¯ = ρ sin θ, ρ ?= 0, 0 < θ < 2π. By recalling that

?

EG −F2 = ?E¯G¯ −F2

∂(u,¯ v)¯ ∂(ρ,θ)

,

where ∂(u,¯ v)/∂(ρ,θ)¯ is the Jacobian of the change of coordinates and E,¯ F,¯ G¯ , are the coefﬁcients of the ﬁrst fundamental form in the normal coordinates (u,¯ v)¯ , we have

√

G = ρ

?E¯G¯ −F¯2, ρ ?= 0. (1)

Since at p,E¯ = G¯ = 1,F¯ = 0 (the normal coordinates are deﬁned at p), we conclude that

lim

ρ→0

√

G = 0, lim

ρ→0

(

√

G)ρ = 1, which concludes the proof of the proposition. Q.E.D.

Remark 1. ThegeometricmeaningofthefactthatF = 0isthatinanormal neighborhoodthefamilyofgeodesiccirclesisorthogonaltothefamilyofradial geodesics. This fact is known as the Gauss lemma.

We shall now present some geometrical applications of the geodesic polar coordinates.

First, we shall study the surfaces of constant Gaussian curvature. Since in a polar system E = 1 and F = 0, the Gaussian curvature K can be written

K = −

(√G)ρρ √G

.

√G(ρ,θ)This expressionshould satisfymay ifbeweconsideredwant theassurfacethe differentialto have (inequationthe coordinatewhich neighborhood in question) curvature K(ρ,θ). If K is constant, the above expression, or, equivalently,

(

√

G)ρρ +K

√

G = 0, (2)

is a linear differential equation of second order with constant coefﬁcients. We shall prove

THEOREM (Minding). Any two regular surfaces with the same constant Gaussian curvature are locally isometric. More precisely, let S1,S2 be two regular surfaces with the same constant curvature K. Choose points

[Page 309]

p1 ∈ S1,p2 ∈ S2, and orthonormal basis {el,e2} ⊂ Tp1(S1),{f1,f2} ⊂ Tp2(S2). ThenthereexistneighborhoodsV1 ofp1,V2 ofp2 andanisometryψ:V1 → V2 such that dψ(e1) = f1,dψ(e2) = f2.

Proof. Let us ﬁrst consider Eq. (2) and study separately the cases (1) K = 0, (2) K > 0, and (3) K < 0.

1. If K = 0,(√G)ρρ = 0. Thus, (√G)ρ = g(θ), where g(θ) is a function of θ. Since

lim

ρ→0

(

√

G)ρ = 1,

we conclude that (√G)ρ ≡ 1. Therefore, √G = ρ +f (θ), where f (θ) is a function of θ. Since

f (θ) = lim

ρ→0

√

G = 0,

we ﬁnally have, in this case, E = 1, F = 0, G(ρ,θ) = ρ2.

2. If K > 0, the general solution of Eq. (2) is given by √

G = A(θ)cos(

√

Kρ)+B(θ)sin(

√

Kρ),

where A(θ) and B(θ) are functions of θ. That this expression is a solution of Eq. (2) is easily veriﬁed by differentiation.

Since limρ→0 √G = 0, we obtain A(θ) = 0. Thus,

(

√

G)ρ = B(θ)

√

K cos(

√

Kρ), and since lim

ρ→0

(√G)ρ = 1, we conclude that

B(θ) =

1 √K

.

Therefore, in this case, E = 1, F = 0, G =

1 K

sin2(

√

Kρ).

3. Finally, if K < 0, the general solution of Eq. (2) is √

G = A(θ)cosh(√

−Kρ)+B(θ)sinh(√

−Kρ). By using the initial conditions, we verify that in this case

E = 1, F = 0, G =

1 −K

sinh2(√

−Kρ).

We are now prepared to prove Minding’s theorem. Let V1 and V2 be normal neighborhoods of p1 and p2, respectively. Let ϕ be the linear isometry of

[Page 310]

Tp1(S1) onto Tp2(S2) given by ϕ(e1) = f1,ϕ(e2) = f2. Take a polar coordinate system (ρ,θ) in Tp1(S1) with axis l and set L1 = expp

1

(l),L2 = expp

2

(ϕ(l)). Let ψ: V1 → V2 be deﬁned by

ψ = expp

2 ◦ϕ ◦exp−1

p1 . We claim that ψ is the required isometry.

In fact, the restriction ψ¯ of ψ to V1 −L1 maps a polar coordinate neighborhood with coordinates (ρ,θ) centered in p1 into a polar coordinate neighborhood with coordinates (ρ,θ) centered in p2. By the above study of Eq. (2), the coefﬁcients of the ﬁrst fundamental forms at corresponding points are equal. By Prop. 1 of Sec. 4-2, ψ¯ is an isometry. By continuity, ψ still preserves inner products at points of L1 and thus is an isometry. It is immediate to check that dψ(e1) = f1,dψ(e2) = f2, and this concludes the proof.

###### Q.E.D.

Remark 2. In the case that K is not constant but maintains its sign, the expression √GK = −(√G)ρρ has a nice intuitive meaning. Consider the arc length L(ρ) of the curve ρ = const. between two close geodesics θ = θ0 and θ = θ1:

L(ρ) = ? θ

1

θ0

?

G(ρ,θ)dθ.

Assume that K < 0. Since

lim ρ→0?√

G

?

ρ

= 1 and

?√

G

?

ρρ

= −K

√

G > 0,

the function L(ρ) behaves as in Fig. 4-39(a). This means that L(ρ) increases with ρ; that is, as ρ increases, the geodesics θ = θ0 and θ = θ1 get farther and farther apart (of course, we must remain in the coordinate neighborhood in question).

On the other hand, if K > 0,L(ρ) behaves as in Fig. 4-39(b). The geodesics θ = θ0 and θ = θ1 may (case I) or may not (case II) come closer together after a certain value of ρ, and this depends on the Gaussian curvature. For instance, in the case of a sphere two geodesics which leave from a pole start coming closer together after the equator (Fig. 4-40).

In Chap. 5 (Secs. 5-4 and 5-5) we shall come back to this subject and shall make this observation more precise.

Another application of the geodesic polar coordinates consists of a geometrical interpretation of the Gaussian curvature K.

[Page 311]

L L(ρ)

ρ

0

L

L(ρ)

ρ

0

(a) K < 0 (b) K > 0

- I
- II


Figure 4-39. Spreading of close geodesics in a normal neighborhood.

###### Figure 4-40

To do this, we ﬁrst observe that the expression of K in geodesic polar coordinates (ρ,θ), with center p ∈ S, is given by

K = −

(√G)ρρ √G

,

and therefore

∂3(√G) ∂ρ3 = −K(

√

G)ρ −Kρ(

√

G).

Thus, recalling that

lim

ρ→0

√

G = 0,

we obtain

−K(p) = lim

ρ→0

∂3√G ∂ρ3

.

[Page 312]

On the other hand, by deﬁning √G and its successive derivatives with respect to ρ at p by its limit values (cf. Eq. (1)), we may write

√

G(ρ,θ) =

√

G(0,θ)+ρ(

√

G)ρ(0,θ)+

ρ2 2!

(

√

G)ρρ(0,θ)

+

ρ3 3!

(

√

G)ρρρ(0,θ)+R(ρ,θ)

where

lim

ρ→0

R(ρ,θ) ρ3 = 0,

uniformly in θ. By substituting in the above expression the values already known, we obtain

√

G(ρ,θ) = ρ −

ρ3 3!

K(ρ)+R.

With this value for √G, we compute the arc length L of a geodesic circle of radius ρ = r:

L = lim

ǫ→0

? 2π−ǫ

0+ǫ

√

G(r,θ)dθ = 2πr −

π 3

r3K(p)+R1,

where

lim

r→0

R1 r3 = 0.

It follows that

K(p) = lim

r→0

3 π

2πr −L r3

,

which gives an intrinsic interpretation of K(p) in terms of the radius r of a geodesic circle Sr(p) around p and the arc lengths L and 2πr of Sr(P) and exp−1

p (Sr(p)), respectively. An interpretation of K(p) involving the area of the region bounded by

Sr(p) is easily obtained by the above process (see Exercise 3).

As a last application of the geodesic polar coordinates, we shall study some minimal properties of geodesics. A fundamental property of a geodesic is the fact that, locally, it minimizes arc length. More precisely, we have

PROPOSITION 4. Let p be a point on a surface S. Then, there exists a neighborhood W ⊂ S of p such that if γ: I → W is a parametrized geodesic

[Page 313]

with γ(0) = p,γ(t1) = q,t1 ∈ I, and α: [0,t1] → S is a parametrized regular curve joining p to q, we have

lγ ≤ lα,

where lα denotes the length of the curve α. Moreover, if lr = lα, then the trace of γ coincides with the trace of α between p and q.

Proof. Let V be a normal neighborhood of p, and let W¯ be the closed region bounded by a geodesic circle of radius r contained in V . Let (ρ,θ) be geodesic polar coordinates in W¯ −L centered in p.

W

q L

p

α

###### Figure 4-41

We ﬁrst consider the case where α([0,t1]) ⊂ W (Fig. 4-41). Let 0 < β0 < β1 < t1. Since α has ﬁnite length, we can choose L so that α([β0,β1]) intersects L only at a ﬁnite number of points, say τ1 < τ2 < ··· < τk−1. Set β0 = τ0, β1 = τk and write α(t) = (ρ(t),β(t)) in each interval (τi,τi+1), i = 0,...,k −1. Observe that

?

(ρ′)2 +G(θ′)2 ≥ ?

(ρ′)2

and equality holds in (τi,τi+1) if and only if θ′ = 0, i.e., θ = const. in (τi,τi+1). We claim that the length of α between β0 and β1 is greater than or equal to |ρ(β1)−ρ(β0)| and that equality holds if and only if α is a radial geodesic θ = const. with a parametrization ρ(t), where ρ′(t) > 0.

To see this, notice that such a length is given by the (convergent) improper integral

?k+1

i=0

? τ

i+1

τi

?

(ρ′)2 +G(θ′)2 dt ≥ ?

i

? τ

i+1

τi

?

(ρ′)2 dt

= ?

i

? τ

i+1

τi

|ρ′|dt ≥ |ρ(β1)−ρ(β2)|.

Furthermore, equalities hold in the above if and only if ρ′(t) > 0 and θ(t) = const. on each interval (τi,τi+1), that is, α(τi) and α(τi+1) are actually on a radial geodesic. This proves our claim.

[Page 314]

The proof of the Proposition 4 for the case where α([p0,t1]) ⊂ W follows immediately from the above claim by letting β0 → 0 and β1 → t1.

Suppose ﬁnally that α([0,t1]) is not entirely contained in W. Let t0 ∈ [0,t1] be the ﬁrst value for which α(t0) = x belongs to the boundary of W. Let γ be the radial geodesic px and let α be the restriction of the curve α to the interval [0,t0]. It is clear then that lα ≥ lα (see Fig. 4-42).

W

x

q

p

V

α

γ

α

###### Figure 4-42

By the previous argument, lα¯ ≥ lγ¯. Since q is a point in the interior of W¯ , lγ¯ > lγ. We conclude that lα > lγ, which ends the proof. Q.E.D.

- Remark 3. For simplicity, we have proved the proposition for regular curves. However, it still holds for piecewise regular curves (cf. Def. 7, Sec. 4-4); the proof is entirely analogous and will be left as an exercise.
- Remark 4. The proof also shows that the converse of the last assertion of


- Prop. 4 holds true. However, this converse does not generalize to piecewise regular curves.


The previous proposition is not true globally, as is shown by the example of the sphere. Two nonantipodal points of a sphere may be connected by two meridians of unequal lengths and only the smaller one satisﬁes the conclusions of the proposition. In other words, a geodesic, if sufﬁciently extended, may not be the shortest path between its end points. The following proposition shows, however, that when a regular curve is the shortest path between any two of its points, this curve is necessarily a geodesic.

PROPOSITION 5. Let α: I → S be a regular parametrized curve with a parameter proportional to arc length. Suppose that the arc length of α between any two points t, τ ∈ I, is smaller than or equal to the arc length of any regular parametrized curve joining α(t) to α(τ). Then α is a geodesic.

Proof. Let t0 ∈ I be an arbitrary point of I and let W be the neighborhood of α(t0) = p given by Prop. 4. Let q = α(t1) ∈ W. From the case of equality in Prop. 4, it follows that α is a geodesic in (t0,t1). Otherwise α would have,

[Page 315]

betweent0 andt1, alengthgreaterthantheradialgeodesicjoiningα(t0)toα(t1), a contradiction to the hypothesis. Since α is regular, we have, by continuity, that α still is a geodesic in t0. Q.E.D.

###### EXERCISES

- 1. Prove that on a surface of constant curvature the geodesic circles have constant geodesic curvature.
- 2. Show that the equations of the geodesics in geodesic polar coordinates (E = 1,F = 0) are given by

ρ′′ −

1 2

Gρ(θ′)2 = 0

θ′′ +

Gρ G

ρ′θ′ +

1 2

Gθ G

(θ′)2 = 0.

- 3. If p is a point of a regular surface S, prove that

K(p) = lim

r→0

12 π

πr2 −A r4

,

whereK(p)istheGaussiancurvatureofS atp,r istheradiusofageodesic circleSr(p)centeredinp, andAistheareaoftheregionboundedbySr(p).

- 4. Show that in a system of normal coordinates centered in p, all the Christoffel symbols are zero at p.
- 5. For which of the pair of surfaces given below does there exist a local isometry?

- a. Torus of revolution and cone.
- b. Cone and sphere.
- c. Cone and cylinder.


- 6. Let S be a surface, let p be a point of S, and let S1(p) be a geodesic circle around p, sufﬁciently small to be contained in a normal neighborhood. Let r and s be two points of S1(p), and C be an arc of S1(p) between


r and s. Consider the curve exp−1

p (C) ⊂ Tp(S). Prove that S1(p) can be chosen sufﬁciently small so that

- a. If K > 0, then l(exp−1

p (C)) > l(C), where l( ) denotes the arc length of the corresponding curve.

- b. If K < 0, then l(exp−1


p (C)) < l(C).

[Page 316]

- 7. Let (ρ,θ) be a system of geodesic polar coordinates (E = 1,F = 0) on a surface, and let γ(ρ(s),θ(s)) be a geodesic that makes an angle ϕ(s) with the curves θ = const. For deﬁniteness, the curves θ = const. are oriented in the sense of increasing ρ’s and ϕ is measured from θ = const. to γ in the orientation given by the parametrization (ρ,θ). Show that


dϕ ds +(

√

G)ρ

dθ ds = 0.

*8. (Gauss Theorem on the Sum of the Internal Angles of a “Small” Geodesic Triangle.) Let ? be a geodesic triangle (that is, its sides are segments of geodesics) on a surface S. Assume that ? is sufﬁciently small to be contained in a normal neighborhood of some of its vertices. Prove directly (i.e., without using the Gauss-Bonnet theorem) that

??

?

K dA = ? 3

?

i=1

αi?−π,

where K is the Gaussian curvature of S, and 0 < αi < π,i = 1,2,3, are the internal angles of the triangle ?.

- 9. (A Local Isoperimetric Inequality for Geodesic Circles.) Let p ∈ S and let Sr(p) be a geodesic circle of center p and radius r. Let L be the arc length of Sr(p) and A be the area of the region bounded by Sr(p). Prove that

4πA−L2 = π2r4K(p)+R, where K(p) is the Gaussian curvature of S at p and lim

r→0

R r4 = 0.

Thus, if K(p) > 0 (or < 0) and r is small, 4πA−L2 > 0 (or < 0). (Compare the isoperimetric inequality of Sec. 1-7.)

- 10. Let S be a connected surface and let ϕ,ψ: S → S be two isometries of S. Assume that there exists a point p ∈ S such that ϕ(p) = ψ(p)

and dϕp(v) = dψp(v) for all v ∈ Tp(S). Prove that ϕ(q) = ψ(q) for all q ∈ S.

- 11. A diffeomorphism ϕ: S1 → S2 is said to be a geodesic mapping if for every geodesic C ⊂ S1 of S1, the regular curve ϕ(C) ⊂ S2 is a geodesic of S2. If U is a neighborhood of p ∈ S1, then ϕ: U → S2 is said to be a local geodesic mapping in p if there exists a neighborhood V of ϕ(p) in S2 such that ϕ: U → V is a geodesic mapping.


[Page 317]

- a. Show that if ϕ: S1 → S2 is both a geodesic and a conformal mapping, then ϕ is a similarity; that is,

?v,w?p = λ?dϕp(v),dϕp(w)?ϕ(p), p ∈ S1,v,w ∈ Tp(S1), where λ is constant.

- b. Let S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} be the unit sphere, S− = {(x,y,z) ∈ S2;z < 0} be its lower hemisphere, and P be the plane z = −1. Prove that the map (central projection) ϕ: S− → P which takes a point p ∈ S− to the intersection of P with the line that connects p to the center of S2 is a geodesic mapping.


*c. Show that a surface of constant curvature admits a local geodesic

mapping into the plane for every p ∈ S.

- 12. (Beltrami’s Theorem.) In Exercise 11, part c, it was shown that a surface S of constant curvature K admits a local geodesic mapping in the plane for every p ∈ S. To prove the converse (Beltrami’s theorem)—If a regular connected surface S admits for every p ∈ S a local geodesic mapping into the plane, then S has constant curvature, the following assertions should be proved:


a. If v = v(u) is a geodesic, in a coordinate neighborhood of a surface parametrized by (u,v), which does not coincide with u = const., then

d2v du2 = Ŵ122 ?

dv du ?3 +(2Ŵ112 −Ŵ222)?

dv du ?2 +(Ŵ111 −2Ŵ212)

dv du −Ŵ211.

- *b. If S admits a local geodesic mapping ϕ: V → R2 of a neighborhood V of a point p ∈ S into the plane R2, then it is possible to parametrize the neighborhood V by (u,v) in such a way that

Ŵ122 = Ŵ211 = 0, Ŵ222 = 2Ŵ112, Ŵ111 = 2Ŵ212.

- *c. If there exists a geodesic mapping of a neighborhood V of p ∈ S into a plane, then the curvature K in V satisﬁes the relations

- KE = Ŵ212Ŵ212 −(Ŵ212)u (a)
- KF = Ŵ112Ŵ212 −(Ŵ212)v (b)
- KG = Ŵ112Ŵ112 −(Ŵ112)v (c) KF = Ŵ212Ŵ112 −(Ŵ112)u (d)


- *d. If there exists a geodesic mapping of a neighborhood V of p ∈ S into a plane, then the curvature K in V is constant.


e. Use the above, and a standard argument of connectedness, to prove

Beltrami’s theorem.

[Page 318]

- 13. (The Holonomy Group.) Let S be a regular surface and p ∈ S. For each piecewise regular parametrized curve α: [0,l] → S with α(0) = α(l) = p, let Pα: Tp(S) → Tp(S) be the map which assigns to each v ∈ Tp(S) its parallel transport along α back to p. By Prop. 1 of Sec. 4-4, Pα is a linear isometry of Tp(S). If β: [l,l¯] is another piecewise regular parametrized curvewithβ(l) = β(l)¯ = p, deﬁnethecurveβ ◦α:[0,l¯] → S byrunning successively ﬁrst α and then β; that is, β ◦α(s) = α(s) if s ∈ [0,l], and β ◦α(s) = β(s) if s ∈ [l,l¯].


- a. Consider the set

Hp(S) = {Pα: Tp(S) → Tp(S);all α joining p to p},

where α is piecewise regular. Deﬁne in this set the operation Pβ ◦Pα = Pβ◦α; that is, Pβ ◦Pα is the usual composition of performing ﬁrst Pα and then Pβ. Prove that, with this operation, Hp(S) is a group (actually, a subgroup of the group of linear isometries of Tp(S)). Hp(S) is called the holonomy group of S at p.

- b. Show that the holonomy group at any point of a surface homeomorphic to a disk with K ≡ 0 reduces to the identity.
- c. Prove that if S is connected, the holonomy groups Hp(S) and Hq(S) at two arbitrary points p,q ∈ S are isomorphic. Thus, we can talk about the (abstract) holonomy group of a surface.
- d. Prove that the holonomy group of a sphere is isomorphic to the group of 2×2 rotation matrices (cf. Exercise 22, Sec. 4-4).


###### 4-7. Further Properties of Geodesics; Convex Neighborhoods†

In this section we shall show how certain facts on geodesics (in particular,

- Prop. 5 of Sec. 4-4) follow from the general theorem of existence, uniqueness, and dependence on the initial condition of vector ﬁelds.


The geodesics in a parametrization x(u,v) are given by the system

u′′ +Ŵ111(u′)2 +2Ŵ112u′v′ +Ŵ122(v′)2 = 0, v′′ +Ŵ211(u′)2 +2Ŵ212u′v′ +Ŵ222(v′)2 = 0,

###### (1)

†This section may be omitted on a ﬁrst reading. Propositions 1 and 2 (the statements of which can be understood without reading the section) are, however, used in Chap. 5.

[Page 319]

where the Ŵkij are functions of the local coordinates u and v. By setting u′ = ξ and v′ = η, we may write the above system in the general form

ξ′ = F1(u,v,ξ,η), η′ = F2(u,v,ξ,η), u′ = F3(u,v,ξ,η), v′ = F4(u,v,ξ,η),

###### (2)

where F3(u,v,ξ,η) = ξ, F4(u,v,ξ,η) = η.

It is convenient to use the following notation: (u,v,ξ,η) will denote a point of R4 which will be thought of as the Cartesian product R4 = R2 ×R2; (u,v) will denote a point of the ﬁrst factor and (ξ,η) a point of the second factor.

The system (2) is equivalent to a vector ﬁeld in an open set of R4 which is deﬁned in a way entirely analogous to vector ﬁelds in R2 (cf. Sec. 3-4). The theorem of existence and uniqueness of trajectories (Theorem 1, Sec. 3-4) still holds in this case (actually, the theorem holds for Rn; cf. S. Lang, Analysis I, Addison-Wesley, Reading, Mass., 1968, pp. 383–386) and is stated as follows:

Given the system (2) in an open set U ⊂ R4 and given a point (u0,v0,ξ0,η0) ∈ U there exists a unique trajectory α: (−ǫ,ǫ) → U of Eq. (2), with α(0) = (u0,v0,ξ0,η0).

To apply this result to a regular surface S, we should observe that, given a parametrization x(u,v) in p ∈ S, of coordinate neighborhood V , the set of pairs (q,v), q ∈ V , v ∈ Tq(S), may be identiﬁed to an open set V ×R2 = U ⊂ R4. For that, we identify each Tq(S),q ∈ V , with R2 by means of the basis {xu,xv}. Whenever we speak about differentiability and continuity in the set of pairs (q,v) we mean the differentiability and continuity induced by this identiﬁcation.

Assuming the above theorem, the proof of Prop. 5 of Sec. 4-4 is trivial. Indeed, the equations of the geodesics in the parametrization x(u,v) in p ∈ S yield a system of the form (2) in U ⊂ R4. The fundamental theorem implies then that given a point q = (u0,v0) ∈ V and a nonzero tangent vector v = (ξ0,η0) ∈ Tq(S) there exists a unique parametrized geodesic

γ = π ◦α: (−ǫ,ǫ) → V in V (where π(q,v) = q is the projection V ×R2 → V ).

The theorem of the dependence on the initial conditions for the vector ﬁeld deﬁned by Eq. (2) is also important. It is essentially the same as that

[Page 320]

for the vector ﬁelds of R2: Given a point p = (u0,v0,ξ0,η0) ∈ U, there exist a neighborhood V = V1 ×V2 of p (where V1 is a neighborhood of (u0,v0) and V2 is a neighborhood of (ξ0,η0)), an open interval I, and a differentiable mapping α: I ×V1 ×V2 → U such that, for ﬁxed (u,v,ξ,η) = (q,v) ∈ V, then α(t,q,v), t ∈ I, is the trajectory of (2) passing through (q,v).

To apply this statement to a regular surface S, we introduce a parametrization in p ∈ S, with coordinate neighborhood V , and identify, as above, the set of pairs (q,v), q ∈ V , v ∈ Tq(S), with V ×R2. Taking as the initial condition the pair (p,0), we obtain an interval (−ǫ2,ǫ2), a neighborhood V1 ⊂ V of p in S, a neighborhood V2 of the origin in R2, and a differentiable map

γ: (−ǫ2,ǫ2)×V1 ×V2 → V such that if (q,v) ∈ V1 ×V2,v ?= 0, the curve

t → γ(t,q,v), t ∈ (−ǫ2,ǫ2),

is the geodesic of S satisfying γ(0,q,v) = q,γ′(0,q,v) = v, and if v = 0, this curve reduces to the point q. Here γ = π ◦α, where π(q,v) = q is the projection U = V ×R2 → V and α is the map given above.

Back in the surface, the set V1 ×V2 is of the form {(q,v),q ∈ V1,v ∈ Vq(0) ⊂ Tq(S)},

where Vq(0) denotes a neighborhood of the origin in Tq(S). Thus, if we restrict γ to (−ǫ2,ǫ2)×{p}×V2, we can choose {p}×V2 = Bǫ1 ⊂ Tp(S), and obtain

THEOREM 1. Given p ∈ S there exist numbers ǫ1 > 0,ǫ2 > 0 and a differentiable map

γ: (−ǫ2,ǫ2)×Bǫ1 → S, Bǫ1 ⊂ Tp(S)

such that for v ∈ Bǫ1,v ?= 0,t ∈ (−ǫ2,ǫ2) the curve t → γ(t,v) is the geodesic of S with γ(0,v) = p,γ′(0,v) = v, and for v = 0,γ(t,0) = p.

This result was used in the proof of Prop. 1 of Sec. 4-6. The above theorem corresponds to the case where p is ﬁxed. To handle the general case, let us denote by Br(q) the domain bounded by a (small) geodesic circle of radius r and center q, and by B¯r(q) the union of Br(q) with its boundary.

Let ǫ > 0 be such that B¯ǫ(p) ⊂ V1. Let Bδ(q)(0) ⊂ V¯q(0) be the largest open disk in the set V¯q(0) formed by the union of Vq(0) with its limit points, and set ǫ1 = inf δ(q),q ∈ B¯ǫ(p). Clearly, ǫ > 0. Thus, the set

U = {(q,v);q ∈ Bǫ(p),v ∈ Bǫ1(0) ⊂ Tq(S)} is contained in V1 ×V2, and we obtain

[Page 321]

Theorem 1a. Given p ∈ S, there exist positive numbers ǫ,ǫ1,ǫ2 and a differentiable map

γ: (−ǫ2,ǫ2)×U → S, where

U = {(q,v);q ∈ Bǫ(p),v ∈ Bǫ1(0) ⊂ Tq(S)}, such that γ(t,q,0) = q, and for v ?= 0 the curve

t → γ(t,q,v), t ∈ (−ǫ2,ǫ2) is the geodesic of S with γ(0,q,v) = q,γ′(0,q,v) = v.

LetusapplyTheorem1atoobtainthefollowingreﬁnementoftheexistence of normal neighborhoods.

PROPOSITION 1. Given p ∈ S there exist a neighborhood W of p in S and a number δ > 0 such that for every q ∈ W,expq is a diffeomorphism on Bδ(0) ⊂ Tq(S) and expq(Bδ(0)) ⊃ W; that is, W is a normal neighborhood of all its points.

Proof. Let V be a coordinate neighborhood of p. Let ǫ,ǫ1,ǫ2 and γ: (−ǫ1,ǫ2)×U → V be as in Theorem 1a. By choosing ǫ1 < ǫ2, we can make sure that, for (q,v) ∈ U,expq(v) = γ(|v|,q, |vv|) is well deﬁned. Thus, we can deﬁne a differentiable map ϕ: U → V ×V by

ϕ(q,v) = (q,expq(v)).

We ﬁrst show that dϕ is nonsingular at (p,0). For that, we investigate how ϕ transforms the curves in U given by

t → (p,tw), t → (α(t),0),

where w ∈ Tp(S) and α(t) is a curve in S with α(0) = p. Observe that the tangent vectors of these curves at t = 0 are (0,w) and (α′(0),0), respectively. Thus,

dϕ(p,0)(0,w) =

d dt

(p,expp(wt))

t=0

= (0,w),

dϕ(p,0)(α′(0),0) =

d dt

(α(t),expα(t)(0))?

t=0

= (α′(0),α′(0)),

and dϕ(p,0) takes linearly independent vectors into linearly independent vectors. Hence, dϕ(p,0) is nonsingular.

[Page 322]

It follows that we can apply the inverse function theorem, and conclude the existence of a neighborhood V of (p,0) in U such that ϕ maps V diffeomorphically onto a neighborhood of (p,p) in V ×V . Let U ⊂ Bǫ(p) and δ > 0 be such that

V = {(q,v) ∈ U;q ∈ U,v ∈ Bδ(0) ⊂ Tq(S)}. Finally, let W ⊂ U be a neighborhood of p such that W ×W ⊂ ϕ(V). We claim that δ and W thus obtained satisfy the statement of the theorem.

In fact, since ϕ is a diffeomorphism in V,expq is a diffeomorphism in Bδ(0), q ∈ W. Furthermore, if q ∈ W, then

ϕ({q}×Bδ(0)) ⊃ {q}×W, and, by deﬁnition of ϕ, expq(Bδ(0)) ⊃ W. Q.E.D.

Remark 1. From the previous proposition, it follows that given two points q1,q2 ∈ W there exists a unique geodesic γ of length less than δ joining q1 and q2. Furthermore, the proof also shows that γ “depends differentiably” on q1 and q2 in the following sense: Given (q1,q2) ∈ W ×W, a unique v ∈ Tq1(S) is determined (precisely, the v given by ϕ−1(q1,q2) = (q1,v)) which depends differentiably on (q1,q2) and is such that γ′(0) = v.

One of the applications of the previous result consists of proving that a curve which locally minimizes arc length cannot be “broken.” More precisely, we have

PROPOSITION 2. Let α: I → S be a parametrized, piecewise regular curve such that in each regular arc the parameter is proportional to the arc length. Suppose that the arc length between any two of its points is smaller than or equal to the arc length of any parametrized regular curve joining these points. Then α is a geodesic; in particular, α is regular everywhere.

Proof. Let 0=t0 ≤t1 ≤ ··· ≤tk ≤ tk+1 = l be a subdivision of [0,l] = I in such a way that α|[ti,ti+1],i = 0,...,k, is regular. By Prop. 5 of Sec. 4-6, α is geodesic at the points of (ti,ti+1). To prove that α is geodesic in ti, consider the neighborhood W, given by Prop. 1, of α(ti). Let q1 = α(ti −ǫ),q2 = α(ti +ǫ),ǫ > 0, be two points of W, and let γ be the radial geodesic of Bδ(q1) joining q1 to q2 (Fig. 4-43). By Prop. 4 of Sec. 4-6, extended to the piecewise regular curves, l(γ) ≤ l(α) between q1 and q2. Together with the hypothesis of the proposition, this implies that l(γ) = l(α). Thus, again by Prop. 4 of Sec. 4-6, the traces of γ and α coincide. Therefore, α is geodesic in ti, which ends the proof. Q.E.D.

In Example 6 of Sec. 4-4 we have used the following fact: A geodesic γ(t) of a surface of revolution cannot be asymptotic to a parallel P0 which is not

[Page 323]

itself a geodesic. As a further application of Prop. 1, we shall sketch a proof of this fact (the details can be ﬁlled in as an exercise).

Assume the contrary to the above statement, and let p be a point in the parallel P0. Let W and δ be the neighborhood and the number given by Prop. 1, and let q ∈ P0 ∩W,q ?= p. Because γ(t) is asymptotic to P0, the point p is a limit of points γ(ti), where {ti} → ∞, and the tangents of γ at ti converge to the tangent of P0 at p. By Remark 1, the geodesic γ(t)¯ with length smaller than δ joining p to q must be tangent to P0 at p. By Clairaut’s relation (cf. Example 5, Sec. 4-4), a small arc of γ(t)¯ around p will be in the region of W where γ(t) lies. It follows that, sufﬁciently close to p, there is a pair of points in W joined by two geodesics of length smaller than δ (see Fig. 4-44). This is a contradiction and proves our claim.

W

q1

q2

α(ti) γ

p0 p q

γ

γ

###### Figure 4-43 Figure 4-44

One natural question about Prop. 1 is whether the geodesic of length less than δ which joins two points q1,q2 of W is contained in W. lf this is the case for every pair of points in W, we say that W is convex.

We say that a parametrized geodesic joining two points is minimal if its length is smaller than or equal to that of any other parametrized piecewise regular curve joining these two points.

When W is convex, we have by Prop. 4 (see also Remark 3) of Sec. 4-6 that the geodesic γ joining q1 ∈ W to q2 ∈ W is minimal. Thus, in this case, we may say that any two points of W are joined by a unique minimal geodesic in W. In general, however, W is not convex.

We shall now prove that W can be so chosen that it becomes convex. The crucial point of the proof is the following proposition, which is interesting in its own right. As usual, we denote by Br(p) the interior of the region bounded by a geodesic circle Sr(p) of radius r and center p.

PROPOSITION 3. For each point p ∈ S there exists a positive number ǫ with the following property: If a geodesic γ(t) is tangent to the geodesic circle Sr(p),r < ǫ, at γ(0), then, for t ?= 0 small, γ(t) lies outside Br(p) (Fig. 4-45).

[Page 324]

γ(0)

γ

Br(p)

Sr(p) p

r<¨

###### Figure 4-45

Proof. Let W be the neighborhood of p given by Prop. l. For each pair (q,v),q ∈ W,v ∈ Tq(S),|v| = 1, consider the geodesic γ(t,q,v) and set, for a ﬁxed pair (q,v) (Fig. 4-46),

exp−1

p γ(t,q,v) = u(t), F(t,q,v) = |u(t)|2 = F(t).

Thus, foraﬁxed(q,v),F(t)isthesquareofthedistanceofthepointγ(t,q,v) to p. Clearly, F(t,q,v) is differentiable. Observe that F(t,p,v) = |vt|2.

Now denote by U1 the set

U1 = {(q,v);q ∈ W,v ∈ Tq(S),|v| = 1}, and deﬁne a function Q: U1 → R by

Q(q,v) =

∂2F ∂t2 ?

t=0

.

u'(t)

u(t)

u(0) p

q

u

W

γ(t)

Tp(S) expp–1(q) expp

expp–1(γ(t)) 0

###### Figure 4-46

[Page 325]

Since F is differentiable, Q is continuous. Furthermore, since ∂F

∂t = 2?u(t),u′(t)?, ∂2F

∂t2 = 2?u(t),u′′(t)?+2?u′(t),u′(t)?, and at (p,v)

u′(t) = v, u′′(t) = 0, we obtain

Q(p,v) = 2|v|2 = 2 > 0 for all v ∈ Tp(S),|v| = 1.

It follows, by continuity, that there exists a neighborhood V ⊂ W such that Q(q,v) > 0 for all q ∈ V and v ∈ Tq(S) with |v| = 1. Let ǫ > 0 be such that Bǫ(p) ⊂ V . We claim that this ǫ satisﬁes the statement of the proposition.

In fact, let r < ǫ and let γ(t,q,v) be a geodesic tangent to Sr(p) at γ(0) = q. By introducing geodesic polar coordinates around p, we see that ?u(0),u′(0)? = 0 (see Fig. 4-47). Thus, ∂F/∂t(0) = 0. Since F(0,q,v) = r2, and (∂2F/∂t2)(0) > 0, we have that F(t) > r2 for t ?= 0 small; hence, γ(t) is outside Br(p). Q.E.D.

Tp(S)

u(0) 0 p

q

c

u

γ

expp

u'(0)

r

###### Figure 4-47

We can now prove

PROPOSITION 4 (Existence of Convex Neighborhoods). For each point p ∈ S there exists a number c > 0 such that Bc(p) is convex; that is, any two points of Bc(p) can be joined by a unique minimal geodesic in Bc(p).

Proof. Let ǫ be given as in Prop. 3. Choose δ and W in Prop. 1 in such a way that δ < ǫ/2. Choose c < δ and such that Bc(p) ⊂ W. We shall prove that Bc(p) is convex.

[Page 326]

Let q1,q2 ∈ Bc(p) and let γ: I → S be the geodesic with length less that δ < ǫ/2 joining q1 to q2. γ(I) is clearly contained in Bǫ(p), and we want to prove that γ(I) is contained in Bc(p). Assume the contrary. Then there is a point m ∈ Bǫ(p) where the maximum distance r of γ(I) to p is attained (Fig. 4-48). In a neighborhood of m, the points of γ(I) will be in Br(p). But this contradicts Prop. 3. Q.E.D.

δ

m

q1 q2

¨

Figure 4-48

###### EXERCISES

*1. Let y and w be differentiable vector ﬁelds on an open set U ⊂ S. Let p ∈ S andletα:I → U beacurvesuchthatα(0) = p,α′(0) = y. Denote by Pα,t: Tα(0)(S) → Tα(t)(S) the parallel transport along α from α(0) to α(t),t ∈ I. Prove that

(Dyw)(p) =

d dt

(Pα,t−1(w(α(t))))?

t=0

,

wherethesecondmemberisthevelocityvectorofthecurveP−1

α,t (w(α(t))) in Tp(S) at t = 0. (Thus, the notion of covariant derivative can be derived from the notion of parallel transport.)

2. a. Show that the covariant derivative has the following properties. Let v,w, and y be differentiable vector ﬁelds in U ⊂ S,f : U → R be a differentiablefunctioninS,y(f )bethederivativeoff inthedirection of y (cf. Exercise 7, Sec. 3-4), and λ,μ be real numbers. Then

- 1. Dy(λv +μw) = λDy(v)+μDγ(w); Dλy+μv(w) = λDy(w)+μDv(w).
- 2. Dy(fv) = y(f )v +f Dy(v);Dfy(v) = f Dy(v).
- 3. y(?v,w?) = ?Dyv,w?+?v,Dyw?.
- 4. Dxvxu = Dxuxv, where x(u,v) is a parametrization of S.


[Page 327]

- *b. Show that property 3 is equivalent to the fact that the parallel transport along a given piecewise regular parametrized curve α: I → S joining

two points p,q ∈ S is an isometry between Tp(S) and Tq(S). Show that property 4 is equivalent to the symmetry of the lower indices of the Christoffel symbols.

- *c. Let U(U) be the space of (differentiable) vector ﬁelds in U ⊂ S and let D: U×U → U (where we denote D(y,v) = Dy(v)) be a map satisfying properties 1-4. Verify that Dy(v) coincides with the covariant derivative of the text. (In general, a D satisfying properties 1 and 2 is called a connection in U. The point of the exercise is to prove that on a surface with a given scalar product there exists a unique connection with the additional properties 3 and 4).


*3. Let α: I = [0,l] → S be a simple, parametrized, regular curve. Consider a unit vector ﬁeld v(t) along α, with ?α′(t),v(t)? = 0 and a mapping x: R ×I → S given by

x(s,t) = expα(t)(sv(t)), s ∈ R,t ∈ I.

- a. Show that x is differentiable in a neighborhood of I in R ×I and that dx is nonsingular in (0,t),t ∈ I.
- b. Show that there exists ǫ > 0 such that x is one-to-one in the rectangle t ∈ I,|s| < ǫ.
- c. Show that in the open set t ∈ (0,l),|s| < ǫ, x is a parametrization of S, the coordinate neighborhood of which contains α((0,l)). The coordinates thus obtained are called geodesic coordinates (or Fermi’s coordinates) of basis α. Show that in such a system F = 0,E = 1. Moreover, if α is a geodesic parametrized by the arc length, G(0,t) = 1 and Gs(0,t) = 0.
- d. Establish the following analogue of the Gauss lemma (Remark 1 after Prop. 3, Sec. 4-6). Let α: I → S be a regular parametrized curve and let γt(s),t ∈ I, be a family of geodesics parametrized by


arc length s and given by; γt(0) = α(t),{γ′

t (0),α′(t)} is a positive orthogonal basis. Then, for a ﬁxed s¯, sufﬁciently small, the curve t → γt(s),t¯ ∈ I, intersects all γt orthogonally (such curves are called geodesic parallels).

- 4. The energy E of a curve α: [a,b] → S is deﬁned by


E(α) = ? b

a

|α′(t)|2dt.

*a. Show that (I(α))2 ≤ (b −a)E(α) and that equality holds if and only

if t is proportional to the arc length.

[Page 328]

b. Conclude from part a that if γ: [a,b] → S is a minimal geodesic with γ(a) = p,γ(b) = q, then for any curve α: [a,b] → S, joining p to q, we have E(γ) ≤ E(α) and equality holds if and only if α is a minimal geodesic.

- 5. Let γ: [0,l] → S be a simple geodesic, parametrized by arc length, and denote by u and v the Fermi coordinates in a neighborhood of γ([0,l]) which is given as u = 0 (cf. Exercise 3). Let u = γ(v,t) be a family of curves depending on a parameter t,−ǫ < t < ǫ such that γ is differentiable and

γ(0,t) = γ(0) = p, γ(l,t) = γ(l) = q, γ(v,0) = γ(v) ≡ 0.

Such a family is called a variation of γ keeping the end points p and q ﬁxed. Let E(t) be the energy of the curve γ(v,t) (cf. Exercise 4); that is,

E(t) = ? l

0

?

∂γ ∂v

(v,t)?2dv.

*a. Show that

E′(0) = 0,

1 2

E′′(0) = ? l

0

??

dη dv?2 −Kη2?dv,

where η(v) = ∂γ/∂t|t=0, K = K(v) is the Gaussian curvature along γ, and denotes the derivative with respect to t (the above formulas are called the ﬁrst and second variations, respectively, of the energy of γ; a more complete treatment of these formulas, including the case where γ is not simple, will be given in Sec. 5-4).

b. Conclude from part a that if K ≤ 0, then any simple geodesic γ: [0,l] → S is minimal relatively to the curves sufﬁciently close to γ and joining γ(0) to γ(l).

- 6. Let S be the cone z = k


?

x2 +y2,k > 0,(x,y) ?= (0,0), and let V ⊂ R2 be the open set of R2 given in polar coordinates by 0 < ρ < ∞,0 < θ < 2πnsin β, where cotan β = k and n is the largest integer such that 2πnsin β < 2π (cf. Example 3, Sec. 4-2). Let ϕ: V → S be the map

ϕ(ρ,θ) = ?ρ sin β cos?

θ sin β ?,ρ sin β sin ?

θ sin β ?,ρ cosβ?.

- a. Prove that ϕ is a local isometry.


[Page 329]

x

y

z

β q

0

j

(ρ,є+ 2π sin β) = r1

2π sin β

(ρ,є) = r0

###### Figure 4-49

- b. Let q ∈ S. Assume that β < π/6 and let k be the largest integer such that 2πk sin β < π. Prove that there exist at least k geodesics that leaving from q return to q. Show that these geodesics are broken at q and that, therefore, none of them is a closed geodesic (Fig. 4-49).


*c. Under the conditions of part b, prove that there are exactly k such

geodesics.

- 7. Let α: I −R3 be a parametrized regular curve. For each t ∈ I, let P(t) ⊂ R3 be a plane through α(t) which contains α′(t). When the unit normal vector N(t) of P(t) is a differentiable function of t and N′(t) ?= 0,t ∈ I, we say that the map t → {α(t),N(t)} is a differentiable family of tangent planes. Given such a family, we determine a parametrized surface (cf. Def. 2, Sec. 2-3) by


x(t,v) = α(t)+v

N(t)∧N′(t) |N′(t)|

.

The parametrized surface x is called the envelope of the family {α(t),N(t)} (cf. Example 4, Sec. 3-5).

- a. Let S be an oriented surface and let γ: I → S be a geodesic parametrized by arc length with k(s) ?= 0 and τ(s) ?= 0,s ∈ I. Let N(s) be the unit normal vector of S along γ. Prove that the envelope of the family of tangent planes {γ(s),N(s)} is regular in a neighborhood of γ, has Gaussian curvature K ≡ 0, and is tangent to S along γ. (Thus, we have obtained a surface locally isometric to the plane which contains γ as a geodesic.)
- b. Let α: I → R3 be a curve parametrized by arc length with k(s) ?= 0 and τ(s) ?= 0,s ∈ I, and let {α(s),n(s)} be the family of its rectifying planes. Prove that the envelope of this family is regular in a


[Page 330]

neighborhood of α, has Gaussian curvature K = 0, and contains α as a geodesic. (Thus, every curve is a geodesic in the envelope of its rectifying planes; since this envelope is locally isometric to the plane, this justiﬁes the name rectifying plane.)

- 8. (Free Mobility of Small Geodesic Triangles.) Let S be a surface of con-


stant Gaussian curvature. Choose points p1,p′

1 ∈ S and let V,V ′ be convex neighborhoods of p1,p′

1, respectively. Choose geodesic triangles p1,p2,p3 in V (geodesic means that the sides p⌢1p2,p⌢2p3,p⌢3p1 are geodesic arcs) in v and p′

1,p′

2,p′

3 in V ′ in such a way that

- l(p1,p2) = l(p1′,p2′),
- l(p2,p3) = l(p2′,p3′),
- l(p3,p1) = l(p3′,p1′)


(here l denotes the length of a geodesic arc). Show that there exists an isometry θ: V → V ′ which maps the ﬁrst triangle onto the second. (This is the local version, for surfaces of constant curvature, of the theorem of high school geometry that any two triangles in the plane with equal corresponding sides are congruent.)

[Page 331]

###### Appendix Proofs of the Fundamental Theorems of the Local Theory of Curves and Surfaces

In this appendix we shall show how the fundamental theorems of existence and uniqueness of curves and surfaces (Secs. 1-5 and 4-2) may be obtained from theorems on differential equations.

Proof of the Fundamental Theorem of the Local Theory of Curves (cf.

statement in Sec. 1-5). The starting point is to observe that Frenet’s equations dt ds = kn,

dn ds = −kt −τb, db ds = τn

###### (1)

may be considered as a differential system in I ×R9, dξ1 ds = f1(s,ξ1,...,ξ9)

. dξ9

ds = f9(s,ξ1,...,ξ9)

⎫ ⎪⎬

⎪⎭

, s ∈ I, (1a)

where (ξ1,ξ2,ξ3) = t, (ξ4,ξ5,ξ6) = n, (ξ7,ξ8,ξ9) = b, and fi, i = 1,...,9, are linear functions (with coefﬁcients that depend on s) of the coordinates ξi.

In general, a differential system of type (1a) cannot be associated to a “steady” vector ﬁeld (as in Sec. 3-4). At any rate, a theorem of existence and uniqueness holds in the following form:

###### 315

[Page 332]

Given initial condition s0 ∈ I, (ξ1)0,...,(ξ9)0, there exist an open interval J ⊂ I containing s0 and a unique differentiable mapping α: J → R9, with

α(s0) = ((ξ1)0,...,(ξ9)0) and α′(s) = (f1,...,f9),

where each fi, i = 1,...,9, is calculated in (s,α(s)) ∈ J ×R9. Furthermore, if the system is linear, J = I (cf. S. Lang, Analysis I,Addison-Wesley, Reading, Mass., 1968, pp. 383–386).

It follows that given an orthonormal, positively oriented trihedron {t0,n0,b0} in R3 and a value s0 ∈ I, there exists a family of trihedrons {t(s),n(s),b(s)}, s ∈ I, with t(s0) = t0, n(s0) = n0, b(s0) = b0.

We shall ﬁrst show that the family {t(s),n(s),b(s)} thus obtained remains orthonormal for every s ∈ I. In fact, by using the system (1) to express the derivatives relative to s of the six quantities

?t,n?, ?t,b?, ?n,b?, ?t,t?, ?n,n?, ?b,b?

as functions of these same quantities, we obtain the system of differential equations

d ds?t,n? = k?n,n?−k?t,t?−τ?t,b?, d ds?t,b? = k?n,b?+τ?t,n?, d ds?n,b? = −k?t,b?−τ?b,b?+τ?n,n?,

d ds?t,t? = 2k?t,n?,

d ds?n,n? = −2k?n,t?−2τ?n,b?,

d ds?b,b? = 2τ?b,n?.

It is easily checked that ?t,n? ≡ 0, ?t,b? ≡ 0, ?n,b? ≡ 0, t2 ≡ 1,n2 ≡ 1,b2 ≡ 1,

is a solution of the above system with initial conditions 0, 0, 0, 1, 1, 1. By uniqueness, the family {t(s),n(s),b(s)} is orthonormal for every s ∈ I, as we claimed.

From the family {t(s),n(s),b(s)} it is possible to obtain a curve by setting

α(s) = ? t(s)ds, s ∈ I,

[Page 333]

where by the integral of a vector we understand the vector function obtained by integrating each component. It is clear that α′(s) = t(s) and that α′′(s) = kn. Therefore, k(s) is the curvature of α at s. Moreover, since

α′′′(s) = k′n+kn′ = k′n−k2t −kτb, the torsion of α will be given by (cf. Exercise 12, Sec. 1-5) −

?α ∧α′′,α′′′? k2 = −

?t ∧kn,(−k2t +k′n−kτb)?

k2 = τ; α is, therefore, the required curve.

We still have to show that α is unique up to translations and rotations of R3. Let α¯: I → R3 be another curve with k(s)¯ = k(s) and τ(s)¯ = τ(s), s ∈ I, and let {t¯0,n¯0,b¯0} be the Frenet trihedron of α¯ at s0. It is clear that by a translation A and a rotation ρ it is possible to make the trihedron {t¯0,n¯0,b¯0} coincide with the trihedron {t0,n0,b0} (both trihedrons are positive). By applying the uniqueness part of the above theorem on differential equations, we obtain the desired result. Q.E.D.

Proof of the Fundamental Theorem of the Local Theory of Surfaces (cf. statement in Sec. 4-3). The idea of the proof is the same as the one above; that is, we search for a family of trihedrons {xu,xv,N}, depending on u and v, which satisﬁes the system

xuu = Ŵ111xu +Ŵ211xv +eN, xuv = Ŵ112xu +Ŵ212xv +f N = xvu, xvv = Ŵ122xu +Ŵ222xv +gN,

Nu = a11xu +a21xv, Nv = a121 xu +a22xv,

###### (2)

wherethecoefﬁcientsŴkij, aij, i,j,k = 1,2, areobtainedfromE,F,G,e,f,g as if it were on a surface.

The above equations deﬁne a system of partial differential equations in V ×R9,

(ξ1)u = f1(u,v,ξ1,...,ξ9),

. (ξ9)v = f15(u,v,ξ1,...,ξ9),

###### (2a)

where ξ = (ξ1,ξ2,ξ3) = xu, η = (ξ4,ξ5,ξ6) = xv, ζ = (ξ7,ξ8,ξ9) = N, and fi = 1,...,15, are linear functions of the coordinates ξj, j = 1,...,9, with coefﬁcients that depend on u and v.

[Page 334]

In contrast to what happens with ordinary differential equations, a system oftype(2a)isnotintegrable, ingeneral. Forthecaseinquestion, theconditions which guarantee the existence and uniqueness of a local solution, for given initial conditions, are

ξuv = ξvu, ηuv = ηvu, ζuv = ζvu.

A proof of this assertion is found in J. Stoker, Differential Geometry, Wiley Interscience, New York, 1969, Appendix B.

As we have seen in Sec. 4-3, the conditions of integrability are equivalent to the equations of Gauss and Mainardi-Codazzi, which are, by hypothesis, satisﬁed. Therefore, the system (2a) is integrable.

Let {ξ,η,ζ} be a solution of (2a) deﬁned in a neighborhood of (u0,v0) ∈ V , with the initial conditions ξ(u0,v0) = ξ0, η(u0,v0) = η0, ζ(u0,v0) = ζ0. Clearly, it is possible to choose the initial conditions in such a way that

ξ02 = E(u0,v0), η02 = G(u0,v0),

?ξ0,η0? = F(u0,v0), ζ02 = 1, ?ξ0,ζ0? = ?η0,ζ0? = 0.

###### (3)

With the given solution we form a new system,

xu = ξ, xv = η,

###### (4)

which is clearly integrable, since ξv = ηu. Let x: V¯ → R3 be a solution of (4), deﬁned in a neighborhood V¯ of (u0,v0), with x(u0,v0) = p0 ∈ R3. We shall show that by contracting V¯ and interchanging v and u, if necessary, x(V )¯ is the required surface.

We shall ﬁrst show that the family {ξ,η,ζ}, which is a solution of (2a), has the following property. For every (u,v) where the solution is deﬁned, we have

ξ2 = E, η2 = G,

?ξ,η? = F ζ2 = 1,

?ξ,ζ? = ?η,ζ? = 0.

###### (5)

Indeed, by using (2) to express the partial derivatives of ξ2, η2, ζ2, ?ξ,η?, ?ξ,ζ?, ?η,ζ?

[Page 335]

as functions of these same 6 quantities, we obtain a system of 12 partial differential equations:

(ξ2)u = B1(ξ2,η2,...,?η,ζ?), (ξ2)v = B2(ξ2,η2,...,?ξ,ζ?),

. (η,ζ)v = B12(ξ2,η2,...,?η,ζ?).

###### (6)

Since (6) was obtained from (2a), it is clear (and may be checked directly) that

(6) is integrable and that

ξ2 = E, η2 = G,

?η,ξ? = F, ζ2 = 1, ?ξ,ζ? = ?η,ζ? = 0

is a solution of (6), with the initial conditions (3). By uniqueness, we obtain our claim.

It follows that

|xu ∧xv|2 = xu2xv2 −?xu,xv?2 = EG −F2 > 0. Therefore, if x: V¯ → R3 is given by

x(uv) = (x(u,v),y(u,v),z(u,v)), (u,v) ∈ V ,¯

one of the components of xu ∧xv, say ∂(x,y)/∂(u,v), is different from zero in (u0,v0). Therefore, we may invert the system formed by the two ﬁrst component functions of x, in a neighborhood U ⊂ V¯ of (u0,v0), to obtain a map F(x,y) = (u,v). By restricting x to U, the mapping x: U → R3 is one-to-one, and its inverse x−1 = F ◦π (where π is the projection of R3 on the xy plane) is continuous. Therefore, x: U → R3 is a differentiable homeomorphism with xu ∧xv ?= 0; hence, x(U) ⊂ R3 is a regular surface.

From (5) it follows immediately that E,F,G are the coefﬁcients of the ﬁrst fundamental form of x(U) and that ζ is a unit vector normal to the surface. Interchanging v and u, if necessary, we obtain

ζ =

xu ∧xv |xu ∧xv|

= N.

From this, the coefﬁcients of the second fundamental form of x(u,v) are computed by (2), yielding

?ζ,xuu? = e, ?ζ,xuv? = f, ?ζ,xvv? = g,

[Page 336]

which shows that those coefﬁcients are e,f,g and concludes the ﬁrst part of the proof.

It remains to show that if U is connected, x is unique up to translations and rotations of R3. To do this, let x¯: U → R3 be another regular surface with E¯ = E, F¯ = F, G¯ = G, e¯ = e, f¯ = f , and g¯ = g. Since the ﬁrst and second fundamental forms are equal, it is possible to bring the trihedron

{¯xu(u0,v0),x¯v(u0,v0),N(u¯ 0,v0)} into coincidence with the trihedron

{xu(u0,v0),xv(u0,v0),N(u0,v0)} by means of a translation A and a rotation ρ.

The system (1a) is satisﬁed by the two solutions.

ξ = xu, η = xv, ζ = N; ξ = x¯u, η = x¯v, ζ = N.¯

Since both solutions coincide in (u0,v0), we have by uniqueness that

xu = x¯u, xv = x¯v, N = N,¯ (7)

in a neighborhood of (u0,v0). On the other hand, the subset of U where (7) holds is, by continuity, closed. Since U is connected, (7) holds for every (u,v) ∈ U.

From the ﬁrst two equations of (7) and the fact that U is connected, we conclude that

x(u,v) = x¯(u,v)+C,

where C is a constant vector. Since x(u0,v0) = x¯(u0,v0), we have that C = 0, which completes the proof of the theorem. Q.E.D.

[Page 337]

- 5 Global Differential


Geometry

###### 5-1. Introduction

The goal of this chapter is to provide an introduction to global differential geometry. We have already met global theorems (the characterization of compact orientable surfaces in Sec. 2-7 and the Gauss-Bonnet theorem in Sec. 4-5 are some examples). However, they were more or less encountered in passing, our main task being to lay the foundations of the local theory of regular surfaces in R3. Now, with that out of the way, we can start a more systematic study of global properties.

Global differential geometry deals with the relations between local and global (in general, topological) properties of curves and surfaces. We tried to minimize the requirements from topology by restricting ourselves to subsets of Euclidean spaces. Only the most elementary properties of connected and compact subsets of Euclidean spaces were used. For completeness, this material is presented with proofs in an appendix to Chap. 5.

In using this chapter, the reader can make a number of choices, and with this in mind, we shall now present a brief section-by-section description of the chapter. At the end of this introduction, a dependence table of the various sections will be given.

- In Sec. 5-2 we shall prove that the sphere is rigid; that is, if a connected, compact, regular surface S ⊂ R3 is isometric to a sphere, then S is a sphere. Except as a motivation for Sec. 5-3, this section is not used in the book.
- In Sec. 5-3 we shall introduce the notion of a complete surface as a natural setting for global theorems. We shall prove the basic Hopf-Rinow theorem,


###### 321

[Page 338]

which asserts the existence of a minimal geodesic joining any two points of a complete surface.

- In Sec. 5-4 we shall derive the formulas for the ﬁrst and second variations

of arc length. As an application, we shall prove Bonnet’s theorem: A complete surface with Gaussian curvature positive and bounded away from zero is compact.

- In Sec. 5-5 we shall introduce the important notion of a Jacobi ﬁeld along


a geodesic γ which measures how rapidly the geodesics near γ pull away from γ. We shall prove that if the Gaussian curvature of a complete surface S is nonpositive, then expp: Tp(S) → S is a local diffeomorphism.

This raises the question of ﬁnding conditions for a local diffeomorphism to be a global diffeomorphism, which motivates the introduction of covering spaces in Sec. 5-6. Part A of Sec. 5-6 is entirely independent of the previous sections. In Part B we shall prove two theorems due to Hadamard: (1) If S is complete and simply connected and the Gaussian curvature of S is nonpositive, thenS isdiffeomorphictoaplane. (2)IfS iscompactandhaspositive Gaussian curvature, then the Gauss map N: S → S2 is a diffeomorphism; in particular, S is diffeomorphic to a sphere.

- In Sec. 5-7 we shall present some global theorems for curves. This section

depends only on Part A of Sec. 5-6.

- In Sec. 5-8 we shall prove that a complete surface in R3 with vanishing

Gaussian curvature is either a plane or a cylinder.

- In Sec. 5-9 we shall prove the so-called Jacobi theorem: A geodesic arc is


minimal relative to neighboring curves with the same end points if and only if such an arc contains no conjugate points.

| | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |
| | | | | | | | | | |


5–2 5–3

5–3

5–4 5–5 5–6A 5–6B

For Sec.

OneneedsSec.

5–7 5–8 5–9 5–10 5–11

- 5–4
- 5–5
- 5–6A


- 5–6B
- 5–7
- 5–8
- 5–9
- 5–10
- 5–11


[Page 339]

- In Sec. 5-10 we shall introduce the notion of abstract surface and extend to

such surfaces the intrinsic geometry of Chap. 4. Except for the Exercises, this section is entirely independent of the previous sections. At the end of the section, we shall mention possible further generalizations, such as differentiable manifolds and Riemannian manifolds.

- In Sec. 5-11 we shall prove Hilbert’s theorem, which implies that there


exists no complete regular surface in R3 with constant negative Gaussian curvature.

In the accompanying diagram we present a dependence table of the sections of this chapter. For instance, for Sec. 5-11 one needs Secs. 5-3, 5-4, 5-5, 5-6, and 5-10; for Sec. 5-7, one needs Part A of Sec. 5-6; for Sec. 5-8 one needs Secs. 5-3, 5-4, and 5-5 and Part A of Sec. 5-6.

###### 5-2. The Rigidity of the Sphere

It is perhaps convenient to begin with a typical, although simple, example of a global theorem. We choose the rigidity of the sphere.

We shall prove that the sphere is rigid in the following sense. Let ϕ: ? → S be an isometry of a sphere ? ⊂ R3 onto a regular surface S = ϕ(?) ⊂ R3. Then S is a sphere. Intuitively, this means that it is not possible to deform a sphere made of a ﬂexible but inelastic material.

Actually, we shall prove the following theorem. THEOREM 1. Let S be a compact, connected, regular surface with

constant Gaussian curvature K. Then S is a sphere.

The rigidity of the sphere follows immediately from Theorem 1. In fact, let ϕ: ? → S be an isometry of a sphere ? onto S. Then ϕ(?) = S has constant curvature, since the curvature is invariant under isometrics. Furthermore, ϕ(?) = S is compact and connected as a continuous image of the compact and connected set ? (appendix to Chap. 5, Props. 6 and 12). It follows from Theorem 1 that S is a sphere.

The ﬁrst proof of Theorem 1 is due to H. Liebmann (1899). The proof we shall present here is a modiﬁcation by S. S. Chern of a proof given by D. Hilbert (S. S. Chern, “Some New Characterizations of the Euclidean Sphere,” Duke Math. J. 12 (1945), 270–290; and D. Hilbert, Grundlagen der Geometrie, 3rd ed., Leipzig, 1909, Appendix 5).

Remark 1. It should be noticed that there are surfaces homeomorphic to a sphere which are not rigid. An example is given in Fig. 5-1. We replace the plane region P of the surface S in Fig. 5-1 by a “bump” inwards so that the resulting surface S′ is still regular. The surface S′′ formed with the “symmetric bump” is isometric to S′, but there is no linear orthogonal transformation that takes S′ into S′′. Thus, S′ is not rigid.

[Page 340]

P

S'

S

###### Figure 5-1

We recall the following convention. We choose the principal curvatures k1 and k2 so that k1(q) ≥ k2(q) for every q ∈ S. In this way we obtain k1 and k2 as continuous functions in S which are differentiable except, perhaps, at the umbilical points (k1 = k2) of S.

The proof of Theorem 1 is based on the following local lemma, for which we shall use the Mainardi-Codazzi equations (Sec. 4-3).

LEMMA 1. Let S be a regular surface and p ∈ S a point of S satisfying the following conditions:

- 1. K(p) > 0; that is, the Gaussian curvature in p is positive.
- 2. p is simultaneously a point of local maximum for the function k1 and a


point of local minimum for the function k2 (k1 ≥ k2). Then p is an umbilical point of S. Proof. Let us assume that p is not an umbilical point and obtain a

contradiction.

If p is not an umbilical point of S, it is possible to parametrize a neighborhood of p by coordinates (u,v) so that the coordinate lines are lines of curvature (Sec. 3-4). In this situation, F = f = 0, and the principal curvatures are given by e/E, g/G. Since the point p is not umbilical, we may assume, by interchanging u and v if necessary, that in a neighborhood of p

k1 =

e E

, k2 =

g G

###### . (1)

In the coordinate system thus obtained, the Mainardi-Codazzi equations are written as (Sec. 4-3, Eqs. (7) and (7a))

ev =

Ev 2

(k1 +k2), (2)

gu =

Gu 2

(k1 +k2). (3)

[Page 341]

By differentiating the ﬁrst equation of (1) with respect to v and using Eq. (2), we obtain

E(k1)v =

Ev 2

(−k1 +k2). (4)

Similarly, by differentiating the second equation of (1) with respect to u and using Eq. (3),

G(k2)u =

Gu 2

(k1 −k2). (5)

On the other hand, when F = 0, the Gauss formula for K reduces to (Sec. 4-3, Exercise 1)

K = −

1 2√EG

??

Ev √EG?

v

+?

Gu √EG?

u

?;

hence,

−2KEG = Evv +Guu +MEv +NGu, (6)

where M = M(u,v) and N = N(u,v) are functions of (u,v), the expressions of which are immaterial for the proof. The same remark applies to M¯ , N¯ , M˜ , and N˜ , to be introduced below.

From Eqs. (4) and (5) we obtain expressions for Ev and Gu which, after being differentiated and introduced in Eq. (6), yield

−2KEG = −

2E k1 −k2

(k1)vv +

2G k1 −k2

(k2)uu +M(k¯ 1)v +N(k¯ 2)u;

hence,

−2(k1 −k2)KEG = −2E(k1)vv +2G(k2)uu +M(k˜ 1)v +N(k˜ 2)u. (7)

SinceK > 0andk1 > k2 atp, theﬁrstmemberofEq.(7)isstrictlynegative at p. Since k1 reaches a local maximum at p and k2 reaches a local minimum at p, we have

(k1)v = 0, (k2)u = 0, (k1)vv ≤ 0, (k2)uu ≥ 0

at p. However, this implies that the second member of Eq. (7) is positive or zero, which is a contradiction. This concludes the proof of Lemma 1. Q.E.D.

It should be observed that no contradiction arises in the proof if we assume that k1 has a local minimum and k2 has a local maximum at p. Actually, such a situation may happen on a surface of positive curvature without p being an umbilical point, as shown in the following example.

[Page 342]

Example 1. Let S be a surface of revolution given by (cf. Sec. 3-3, Example 4)

x = ϕ(v)cosu, y = ϕ(v)sin u, z = ψ(v), 0 < u < 2π, where

ϕ(v) = C cosv, C > 1, ψ(v) = ? ?

1−C2 sin2 v dv, ψ(0) = 0.

We take |v| < sin−1(1/C), so that ψ(v) is deﬁned. By using expressions already known (Sec. 3-3, Example 4), we obtain

E = C2 cos2 v, F = 0, G = 1,

- e = −C cosv

??

1−C2 sin2 v

?

,

- f = 0,
- g = −


C cosv ?

1−C2 sin2 v

;

hence,

k1 =

e E = −?

1−C2 sin2 v C cosv

, k2 =

g G = −

C cosv ?

1−C2 sin2 v

.

Therefore, S has curvature K = k1k2 = 1 > 0, positive and constant (cf. Exercise 7, Sec. 3-3).

Itiseasilyseenthatk1 > k2 everywhereinS, sinceC > 1. Therefore, S has no umbilical points. Furthermore, since k1 = −(1/C) for v = 0, and

k1 = −?

1−C2 sin2 v C cosv

> −

1 C

for v ?= 0,

we conclude that k1 reaches a minimum (and therefore k2 reaches a maximum, since K = 1) at the points of the parallel v = 0.

Incidentally, this example shows that the assumption of compactness in Theorem 1 is essential, since the surface S (see Fig. 5-2) has constant positive curvature but is not a sphere.

In the proof of Theorem 1 we shall use the following fact, which we establish as a lemma.

[Page 343]

###### Figure 5-2

LEMMA 2. A regular compact surface S ⊂ R3 has at least one elliptic point.

Proof. Since S is compact, S is bounded. Therefore, there are spheres of R3, centered in a ﬁxed point O ∈ R3, such that S is contained in the interior of the region bounded by any of them. Consider the set of all such spheres. Let r be the inﬁmum of their radii and let ? ⊂ R3 be a sphere of radius r centered in O. It is clear that ? and S have at least one common point, say p. The tangent plane to ? at p has only the common point p with S, in a neighborhood of p. Therefore, ? and S are tangent at p. By observing the normal sections at p, it is easy to conclude that any normal curvature of S at p is greater than or equal to the corresponding curvature of ? at p. Therefore, KS(p) ≥ K?(p) > 0, and p is an elliptic point, as we wished. Q.E.D.

Proof of Theorem 1. Since S is compact, there is an elliptic point, by Lemma 2. Because K is constant, K > 0 in S.

By compactness, the continuous function k1 on S reaches a maximum at a point p ∈ S (appendix to Chap. 5, Prop. 13). Since K = k1k2 is a positive constant, k2 isadecreasingfunctionofk1, and, therefore, itreachesaminimum at p. It follows from Lemma 1 that p is an umbilical point; that is, k1(p) = k2(p).

Now let q be any given point of S. Since we assumed k1(q) ≥ k2(q) we have that

k1(p) ≥ k1(q) ≥ k2(q) ≥ k2(p) = k1(p). Therefore, k1(q) = k2(q) for every q ∈ S.

It follows that all the points of S are umbilical points and, by Prop. 4 of Sec. 3-2, S is contained in a sphere or a plane. Since K > 0, S is contained in a sphere ?. By compactness, S is closed in ?, and since S is a regular surface, S is open in ?. Since ? is connected and S is open and closed in ?, S = ? (appendix to Chap. 5, Prop. 5).

Therefore, the surface S is a sphere. Q.E.D.

[Page 344]

Observe that in the proof of Theorem 1 the assumption that K = k1k2 is constant is used only to guarantee that k2 is a decreasing function of k1. The same conclusion follows if we assume that the mean curvature H = 1 2(k1 +k2) is constant. This allows us to state

THEOREM 1a. Let S be a regular, compact, and connected surface with Gaussian curvature K > 0 and mean curvature H constant. Then S is a sphere.

The proof is entirely analogous to that of Theorem 1. Actually, the argument applies whenever k2 = f (k1), where f is a decreasing function of k1. More precisely, we have

THEOREM 1b. Let S be a regular, compact, and connected surface of positive Gaussian curvature. If there exists a relation k2 = f(k1) in S, where f is a decreasing function of k1, k1 ≥ k2, then S is a sphere.

Remark 2. The compact, connected surfaces in R3 for which the Gaussian curvature K > 0 are called ovaloids. Therefore Theorem 1a may be stated as follows: An ovaloid of constant mean curvature is a sphere.

On the other hand, it is a simple consequence of the Gauss-Bonnet theorem that an ovaloid is homeomorphic to a sphere (cf. Sec. 4-5, application 1). H. Hopf proved that Theorem 1a still holds with the following (stronger) statement: A regular surface of constant mean curvature that is homeomorphic to a sphere is a sphere. A theorem due to A. Alexandroff extends this result further by replacing the condition of being homeomorphic to a sphere by compactness: A regular, compact, and connected surface of constant mean curvature is a sphere.

An exposition of the above-mentioned results can be found in Hopf [11]. (References are listed at the end of the book.)

Remark 3. The rigidity of the sphere may be obtained as a consequence of a general theorem of rigidity on ovaloids. This theorem, due to Cohn-Vossen, states the following: Two isometric ovaloids differ by an orthogonal linear transformation of R3. A proof of this result may be found in Chern [10].

Theorem 1 is a typical result of global differential geometry, that is, information on local entities (in this case, the curvature) together with weak global hypotheses (in this case, compactness and connectedness) imply strong restrictions on the entire surface (in this case, being a sphere). Observe that the only effect of the connectedness is to prevent the occurrence of two or more spheres in the conclusion of Theorem 1. On the other hand, the hypothesis of compactness is essential in several ways, one of its functions being to ensure that we obtain an entire sphere and not a surface contained in a sphere.

[Page 345]

###### EXERCISES

- 1. Let S ⊂ R3 be a compact regular surface and ﬁx a point p0 ∈ R3, p0 ∈/ S. Let d: S → R be the differentiable function deﬁned by d(q) = 12|q −p0|2, q ∈ S. Since S is compact, there exists q0 ∈ S such that d(q0) ≥ d(q) for all q ∈ S. Prove that q0 is an elliptic point of S (this gives another proof of Lemma 2).

- 2. Let S ⊂ R3 be a regular surface with Gaussian curvature K > 0 and without umbilical points. Prove that there exists no point on S where H is a maximum and K is a minimum.
- 3. (Kazdan-Warner’s Remark.) Let S ⊂ R3 be an extended compact surface of revolution (cf. Remark 4, Sec. 2-3) obtained by rotating the curve

α(s) = (0,ϕ(s),ψ(s)),

parametrizedbyarclength s ∈ [0,l], aboutthe z axis. Here ϕ(0)=ϕ(l)=0 and ϕ(s) > 0 for all s ∈ [0,l]. The regularity of S at the poles implies further that ϕ′(0) = 1, ϕ′(l) = −1 (cf. Exercise 10, Sec. 2-3). We also know that the Gaussian curvature of S is given by K = −ϕ′′(s)/ϕ(s) (cf. Example 4, Sec. 3-3).

*a. Prove that

? t

0

K′ϕ2 ds = 0, K′ =

dK ds

.

b. Conclude from part a that there exists no compact (extended) surface of

revolution in R3 with monotonic increasing curvature.

The following exercise outlines a proof of Hopf’s theorem: A regular surface with constant mean curvature which is homeomorphic to a sphere is a sphere (cf. Remark 2). Hopf’s main idea has been used over and over again in recent work. The exercise requires some elementary facts on functions of complex variables.

- 4. Let U ⊂ R3 be an open connected subset of R2 and let x: U → S be an isothermal parametrization (i.e., E = G, F = 0; cf. Sec. 4-2) of a regular surface S. We identify R2 with the complex plane C by setting u+iv = ζ, (u,v) ∈ R2, ζ ∈ C. ζ is called the complex parameter corresponding to x. Let φ: x(U) → C be the complex-valued function given by


φ(ζ) = φ(u,v) =

e −g 2 −if = φ1 +iφ2,

where e, f , g are the coefﬁcients of the second fundamental form of S.

[Page 346]

- a. Show that the Mainardi-Codazzi equations (cf. Sec. 4-3) can be written, in the isothermal parametrization x, as

?

e −g 2 ?

u

+fv = EHu, ?

e −g 2 ?

v

−fu = −EHv

and conclude that the mean curvature H of x(U) ⊂ S is constant if and only if φ is an analytic function of ζ (i.e., (φ1)u = (φ2)v, (φ1)v = −(φ2)u).

- b. Deﬁne the “complex derivative” ∂

∂ζ =

1 2 ?

∂ ∂u −i

∂ ∂v?,

and prove that φ(ζ) = −2?xζ,Nζ?, where by xζ, for instance, we mean the vector with complex coordinates

xζ = ?

∂x ∂ζ

,

∂y ∂ζ

,

∂z ∂ζ ?.

- c. Let f : U ⊂ C → V ⊂ C be a one-to-one complex function given by f (u+iv) = x +iy = η. Show that (x,y) are isothermal parameters on S (i.e., η is a complex parameter on S) if and only if f is analytic and f′(ζ) ?= 0, ζ ∈ U. Let y = x ◦f−1 be the correspond-

ing parametrization and deﬁne ψ(η) = −2?yη,Nη?. Show that on x(U)∩y(V ),

φ(ζ) = ψ(η)?

∂η ∂ζ ?2 . (∗)

- d. Let S2 be the unit sphere of R3. Use the stereographic projection (cf. Exercise 16, Sec. 2-2) from the poles N = (0,0,1) and S = (0,0,−1) to cover S2 by the coordinate neighborhoods of two (isothermal) complex parameters, ζ and η, with ζ(S) = 0 and η(N) = 0, in such a way that in the intersection W of these coordinate neighborhoods (the sphere minus the two poles) η = ζ−1. Assume that there exists on each coordinate neighborhood analytic functions ϕ(ζ), ψ(η) such that (∗) holds in W. Use Liouville’s theorem to prove that ϕ(ζ) ≡ 0 (hence, ψ(η) ≡ 0).
- e. Let S ⊂ R3 be a regular surface with constant mean curvature homeomorphic to a sphere. Assume that there exists a conformal diffeomorphism ϕ: S → S2 of S onto the unit sphere S2 (this is a consequence of the uniformization theorem for Riemann surfaces and will be assumed here). Let ζ˜ and η˜ be the complex parameters corresponding under ϕ to the parameters ζ and η of S2 given in part d. By part a, the function φ(ζ)˜ = ((e −g)/2)−if is analytic. The similar function ψ(η)˜ is also


[Page 347]

analytic, and by part c they are related by (∗). Use part d to show that φ(ζ)˜ ≡ 0 (hence, ψ(η)˜ ≡ 0). Conclude that S is made up of umbilical points and hence is a sphere. This proves Hopf’s theorem.

###### 5-3. Complete Surfaces. Theorem of Hopf-Rinow

All the surfaces to be considered from now on will be regular and connected, except when otherwise stated.

The considerations at the end of Sec. 5-2 have shown that in order to obtain global theorems we require, besides the connectedness, some global hypothesis to ensure that the surface cannot be “extended” further as a regular surface. It is clear that the compactness serves this purpose. However, it would be useful to have a hypothesis weaker than compactness which could still have the same effect. That would allow us to expect global theorems in a more general situation than that of compactness.

Amorepreciseformulationoftheconceptthatasurfacecannotbeextended is given in the following deﬁnition.

DEFINITION 1. A regular (connected) surface S is said to be extendable if there exists a regular (connected) surface S¯ such that S ⊂ S¯ as a proper subset. If there exists no such S¯, S said to be nonextendable.

Unfortunately, the class of nonextendable surfaces is much too large to allow interesting results. A more adequate hypothesis is given by

DEFINITION 2. A regular surface S is said to be complete when for every point p ∈ S, any parametrized geodesic γ: [0,ǫ) → S of S, starting from p = γ(0), may be extended into a parametrized geodesic γ˜: R → S, deﬁned on the entire line R.

In other words, S is complete when for every p ∈ S the mapping expp : Tp(S) → S (Sec. 4-6) is deﬁned for every v ∈ Tp(S).

We shall prove later (Prop. 1) that every complete surface is nonextendable and that there exist nonextendable surfaces which are not complete (Example 1). Therefore, the hypothesis of completeness is stronger than that of nonextendability. Furthermore, we shall prove (Prop. 5) that every closed surface in R3 is complete; that is, the hypothesis of completeness is weaker than that of compactness.

The object of this section is to prove that given two points p, q ∈ S of a complete surface S there exists a geodesic joining p to q which is minimal (that is, its length is smaller than or equal to that of any other curve joining p to q). This fundamental result was ﬁrst proved by Hopf and Rinow (H. Hopf, W. Rinow, “Über den Begriff der vollständigen differentialgeometriscben Flächen,” Comm. Math. Helv. 3 (1931), 209–225). This theorem is the main

[Page 348]

reason why the complete surfaces are more adequate for differential geometry than the nonextendable ones.

Let us now look at some examples. The plane is clearly a complete surface. The cone minus the vertex is a noncomplete surface, since by extending a generator (which is a geodesic) sufﬁciently we reach the vertex, which does not belong to the surface.Asphere is a complete surface, since its parametrized geodesics(thetracesofwhicharethegreatcirclesofthesphere)maybedeﬁned for every real value. The cylinder is also a complete surface since its geodesics are circles, lines, and helices, which are deﬁned for all real values.

On the other hand, a surface S −{p} obtained by removing a point p from a complete surface S is not complete. In fact, a geodesic γ of S should pass through p. By taking a point q, nearby p on γ (Fig. 5-3), there exists a parametrized geodesic of S −{p} that starts from q and cannot be extended through p (this argument will be given in detail in Prop. 1). Thus, a sphere minus a point and a cylinder minus a point are not complete surfaces.

p

q

###### Figure 5-3

PROPOSITION 1. A complete surface S is nonextendable.

Proof. LetusassumethatS isextendableandobtainacontradiction.Tosay thatS isextendablemeansthatthereexistsaregular(connected)surfaceS¯ with S ⊂ S¯. Since S is a regular surface, S is open in S¯. The boundary (appendix to Chap. 5, Def. 4) Bd S of S in S¯ is nonempty; otherwise S¯ = S ∪(S¯ −S) would be the union of two disjoint open sets S and S¯ −S, which contradicts the connectedness of S¯ (appendix to Chap. 5, Def. 10). Therefore, there exists a point p ∈ Bd S, and since S is open in S¯, p ∈/ S.

Let V¯ ⊂ S¯ be a neighborhood of p in S¯ such that every q ∈ V¯ may be joined to p by a unique geodesic of S¯ (Sec. 4-6, Prop. 2). Since p ∈ Bd S, someq0 ∈ V¯ belongstoS. Letγ¯:[0,1] → S¯ beageodesicofS, withγ(¯ 0) = p and γ(¯ 1) = q0. It is clear that α: [0,ǫ) → S, given by α(t) = γ(¯ 1−t), is a geodesic of S, with α(0) = q0, the extension of which to the line R would pass through p for t = 1 (Fig. 5-4). Since p ∈/ S, this geodesic cannot be extended, which contradicts the hypothesis of completeness and concludes the proof. Q.E.D.

[Page 349]

S

p

q0

α

V

S

###### Figure 5-4 Figure 5-5

The converse of Prop. 1 is false, as shown in the following example. Example 1. When we remove the vertex p0 from the one-sheeted cone

given by

z = ?

x2 +y2, (x,y) ∈ R2,

we obtain a regular surface S. S is not complete since the generators cannot be extended for every value of the arc length without reaching the vertex.

Let us show that S is nonextendable by assuming that S ⊂ S¯, where S¯ ?= S is a regular surface, and by obtaining a contradiction. The argument consists of showing that the boundary of S in S¯ reduces to the vertex p0 and that there exists a neighborhood W¯ of p0 in S¯ such that W¯ −{p0} ⊂ S. But this contradicts the fact that the cone (vertex p0 included) is not a regular surface in p0 (Sec. 2-2, Example 5).

First, we observe that the only geodesic of S, starting from a point p ∈ S, that cannot be extended for every value of the parameter is the meridian (generator) that passes through p (see Fig. 5-5). This fact may easily be seen by using, for example, Clairaut’s relation (Sec. 4-4, Example 5) and will be left as an exercise (Exercise 2).

Now let p ∈ Bd S, where Bd S denotes the boundary of S in S¯ (as we have seen in Prop. 1, Bd S ?= φ). Since S is an open set in S¯, p ∈/ S. Let V¯ be a neighborhood of p in S¯ such that every point of V¯ may be joined to p by a unique geodesic of S¯ in V¯ . Since p ∈ Bd S, there exists q ∈ V¯ ∩S. Let γ¯ be a geodesic of S¯ joining p to q. Because S is an open set in S¯, γ¯ agrees with a geodesic γ of S in a neighborhood of q. Let p0 be the ﬁrst point of γ¯ that does not belong to S. By the initial observation, γ¯ is a meridian and p0 is the vertex of S. Furthermore, p0 = p; otherwise there would exist a neighborhood of p that does not contain p0. By repeating the argument for that neighborhood,

[Page 350]

we obtain a vertex different from p0, which is a contradiction. It follows that Bd S reduces to the vertex p0.

Now let W¯ be a neighborhood of p0 in S¯ such that any two points of W¯ may be joined by a geodesic of S¯ (Sec. 4-7, Prop. 1). We shall prove that W¯ −{p0} ⊂ S. In fact, the points of γ belong to S. On the other hand, a point

- r ∈ W¯ which does not belong to γ or to its extension may be joined to a point


t of γ, t ?= p0, t ∈ W¯ , by a geodesic α, different from γ (see Fig. 5-6). By the initial observation, every point of α, in particular r, belongs to S. Finally, the points of the extension of γ, except p0, also belong to S; otherwise, they would belong to the boundary of S which we have proved to be made up only of p0.

r

γ

q

α

W

t

p0

V

###### Figure 5-6

In this way, our assertions are completely proved. Thus, S is nonextendable and the desired example is obtained.

For what follows, it is convenient to introduce a notion of distance between two points of S which depends only on the intrinsic geometry of S and not on the way S is immersed in R3 (cf. Remark 2, Sec. 4-2). Observe that, since S ⊂ R3, it is possible to deﬁne a distance between two points of S as the distance between these two points in R3. However, this distance depends on the second fundamental form, and, thus, it is not adequate for the purposes of this chapter.

We need some preliminaries. A continuous mapping α: [a,b] → S of a closed interval [a,b] ⊂ R of the line R into the surface S is said to be a parametrized, piecewise differentiable curve joining α(a) to α(b) if there exists a partition of [a,b] by points a = t0 < t1 < t2 < ··· < tk < tk+1 = b suchthatα isdifferentiablein[ti,ti+1], i = 0,...,k. The length l(α) of α is deﬁned as

l(α) =

?k

l=0

? t

i+1

ti

|α′(t)|dt.

[Page 351]

PROPOSITION 2. Given two points p,q ∈ S of a regular (connected) surface S, there exists a parametrized piecewise differentiable curve joining p to q.

Proof. Since S is connected, there exists a continuous curve α: [a,b] → S with α(a) = p, α(b) = q. Let t ∈ [a,b] and let It be an open interval in [a,b], containing t, such that α(It) is contained in a coordinate neighborhood of α(t). The union ∪It, t ∈ [a,b] covers [a,b] and, by compactness, a ﬁnite number I1,...,In still covers [a,b]. Therefore, it is possible to decompose I by points a = t0 < t1 < ··· < tk < tk+1 = b in such a way that [ti,ti+1] is contained in some Ij, j = 1,...,n. Thus, α(ti,ti+1) is contained in a coordinate neighborhood.

Since p = α(t0) and α(t1) lie in a same coordinate neighborhood x(U) ⊂ S, it is possible to join them by a differentiable curve, namely, the image by x of a differentiable curve in U ⊂ R2 joining x−1(α(t0)) to x−1(α(t1)). By this process, we join α(ti) to α(ti+1), i = 0,...,k, by a differentiable curve. This gives a piecewise differentiable curve, joining p = α(t0) and q = α(tk+1), and concludes the proof of the proposition.

###### Q.E.D.

Now let p, q ∈ S be two points of a regular surface S. We denote by αp,q a parametrized, piecewise differentiable curve joining p to q and by l(αp,q) its length. Proposition 2 shows that the set of all such αp,q is not empty. Thus, we can set the following:

DEFINITION 3. The (intrinsic) distance d(p,q) from the point p ∈ S to the point q ∈ S is the number

d(p,q) = inf l(αp,q), where the inf is taken over all piecewise differentiable curves joining p to q.

PROPOSITION 3. The distance d deﬁned above has the following properties,

- 1. d(p,q) = d(q,p),
- 2. d(p,q)+d(q,r) ≥ d(p,r),
- 3. d(p,q) ≥ 0,
- 4. d(p,q) = 0 if and only if p = q,


where p, q, r are arbitrary points of S. Proof. Property 1 is immediate, since each parametrized curve α: [a,b] → S,

with α(a) = p, α(b) = q, gives rise to a parametrized curve α˜: [a,b] → S, deﬁned by α(t)˜ = α(a −t +b). It is clear that α(a)˜ = q, α(b)˜ = p, and l(αp,q) = l(α˜p,q).

[Page 352]

- Property 2 follows from the fact that when A and B are sets of real numbers and A ⊆ B then inf A ≥ inf B.
- Property 3 follows from the fact that the inﬁmum of positive numbers is positive or zero.


Let us now prove property 4. Let p = q. Then, by taking the constant curve α: [a,b] → S, given by α(t) = p, t ∈ [a,b], we get l(α) = 0; hence, d(p,q) = 0.

To prove that d(p,q) = 0 implies that p = q we proceed as follows. Let us assume that d(p,q) = inf l(αp,q) = 0 and p ?= q. Let V be a neighborhood of p in S, with q ∈/ V , and such that every point of V may be joined to p by a unique geodesic in V . Let Br(p) ⊂ V be the region bounded by a geodesic circle of radius r, centered in p, and contained in V . By deﬁnition of inﬁmum, given ǫ > 0, 0 < ǫ < r, there exists a parametrized, piecewise differentiable curve α: [a,b] → S joining p to q and with l(α) < ǫ. Since α([a,b]) is connected and q ∈/ Br, there exists a point t0 ∈ [a,b] such that α(t0) belongs to the boundary of Br(p). It follows that l(α) ≥ r > ǫ, which is a contradiction. Therefore, p = q, and this concludes the proof of the proposition. Q.E.D.

COROLLARY. |d(p,r)−d(r,q)| ≤ d(p,q). It sufﬁces to observe that

d(p,r) ≤ d(p,q)+d(q,r), d(r,q) ≤ d(r,p)+d(p,q);

hence,

−d(p,q) ≤ d(p,r)−d(r,q) ≤ d(p,q).

PROPOSITION 4. If we let p0 ∈ S be a point of S, then the function f: S → R given by f(p) = d(p0,p), p ∈ S, is continuous on S.

Proof. We have to show that for each p ∈ S, given ǫ > 0, there exists δ > 0 such that if q ∈ Bδ(p)∩S, where Bδ(p) ⊂ R3 is an open ball of R3 centeredatp andofradiusδ, then|f (p)−f (q)|=|d(p0,p)−d(p0,q)| < ǫ.

Let ǫ′ < ǫ be such that the exponential map expp = Tp(S) → S is a diffeomorphism in the disk Bǫ′(0) ⊂ Tp(S), where 0 is the origin of Tp(S), and set exp(Bǫ′(0)) = V . Clearly, V is an open set in S; hence, there exists an open ball Bδ(p) in R3 such that Bδ(p)∩S ⊂ V . Thus, if q ∈ Bδ(p)∩S,

|d(p0,p)−d(p0,q)| ≤ d(p,q) < ǫ′ < ǫ, which completes the proof. Q.E.D.

Remark 1. The readers with an elementary knowledge of topology will notice that Prop. 3 shows that the function d: S ×S → R gives S the structure of a metric space. On the other hand, as a subset of a metric space, S ⊂ R3 has

[Page 353]

an induced metric d¯. It is an important fact that these two metrics determine the same topology, that is, the same family of open sets in S. This follows from the fact that expp : U ⊂ Tp(S) → S is a local diffeomorphism, and its proof is analogous to that of Prop. 4.

Having ﬁnished the preliminaries, we may now make the following observation.

PROPOSITION 5. A closed surface S ⊂ R3 is complete.

Proof. Let γ: [0,ǫ) → S be a parametrized geodesic of S, γ(0) = p ∈ S, which we may assume, without loss of generality, to be parametrized by arc length. We need to show that it is possible to extend γ to a geodesic γ¯: R → S, deﬁned on the entire line R. Observe ﬁrst that when γ(s¯ 0), s0 ∈ R, is deﬁned, then, by the theorem of existence and uniqueness of geodesics (Sec. 4-4, Prop. 5), it is possible to extend γ¯ to a neighborhood of s0 in R. Therefore, the set of all s ∈ R where γ¯ is deﬁned is open in R. If we can prove that this set is closed in R (which is connected), it will be possible to deﬁne γ¯ for all of R, and the proof will be completed.

Let us assume that γ¯ is deﬁned for s < s0 and let us show that γ¯ is deﬁned for s = s0. Consider a sequence {sn} → s0, with sn < s0, n = 1,2,....

We shall ﬁrst prove that the sequence { ¯γ(sn)} converges in S. In fact, given ǫ > 0, there exists n0 such that if n,m > n0, then |sn −sm| < ǫ. Denote by d¯ the distance in R3, and observe that if p, q ∈ S, then d(p,q)¯ ≤ d(p,q). Thus,

d(¯ γ(s¯ n),γ(s¯ m)) ≤ d(γ(s¯ n),γ(s¯ m)) ≤ |sn −sm| < ǫ,

where the second inequality comes from the deﬁnition of d and the fact that |sn −sm| is equal to the arc length of the curve γ¯ between sn and sm. It follows that { ¯γ(sn)} is a Cauchy sequence in R3; hence, it converges to a point q ∈ R3 (appendix to Chap. 5, Prop. 4). Since q is a limit point of { ¯γ(sn))} and S is closed, q ∈ S, which proves our assertion.

Now let W and δ be the neighborhood of q and the number given by Prop. l of Sec. 4-7. Let γ(s¯ n), γ(s¯ m) ∈ W be points such that |sn −sm| < δ, and let γ be the unique geodesic with l(γ) < δ joining γ(s¯ n) to γ(s¯ m). Clearly, γ¯ agrees with γ. Since expγ(s¯

m) is a diffeomorphism in Bδ(0) and expγ(s¯

m)(Bδ(0)) ⊃ W, γ extends γ¯ beyond q. Thus, γ¯ is deﬁned at s = s0,

which completes the proof. Q.E.D. COROLLARY. A compact surface is complete. Remark 2. The converse of Prop. 5 does not hold. For instance, a right

cylinder erected over a plane curve that is asymptotic to a circle is easily seen to be complete but not closed (Fig. 5-7).

We say that a geodesic γ joining two points p,q ∈ S is minimal if its length l(γ) is smaller than or equal to the length of any piecewise regular curve

[Page 354]

p1

p2

p

Figure 5-7. A complete nonclosed surface. Figure 5-8

joining p to q (cf. Sec. 4-7). This is equivalent to saying that l(γ) = d(p,q), since, given a piecewise differentiable curve α joining p to q, we can ﬁnd a piecewise regular curve joining p to q that is shorter (or at least not longer) than α. The proof of the last assert ion is left as an exercise.

Observe that a minimal geodesic may not exist, as shown in the following example.

LetS2 −{p}bethesurfaceformedbythesphereS2 minusthepointp ∈ S2. By taking, on the meridian that passes through p, two points p1 and p2, symmetric relative to p and sufﬁciently near to p, we see that there exists no minimal geodesic joining p1 to p2 in the surface S2 −{p} (see Fig. 5-8).

On the other hand, there may exist an inﬁnite number of minimal geodesics joining two points of a surface, as happens, for example, with two antipodal pointsofasphere; allthemeridiansthatjointheseantipodalpointsareminimal geodesics.

The main result of this section is that in a complete surface there always exists a minimal geodesic joining two given points.

THEOREM 1 (Hopf-Rinow). Let S be a complete surface. Given two points p, q ∈ S, there exists a minimal geodesic joining p to q.

Proof. Let r = d(p,q) be the distance between the points p and q. Let Bδ(0) ⊂ Tp(S) be a disk of radius δ, centered in the origin 0 of the tangent plane Tp(S) and contained in a neighborhood U ⊂ Tp(S) of 0, where expp is a diffeomorphism. Let Bδ(p) = expp(Bδ(0)). Observe that the boundary Bd Bδ(p) = ? is compact since it is the continuous image of the compact set Bd Bδ(0) ⊂ Tp(S).

If x ∈ ?, the continuous function d(x,q) reaches a minimum at a point x0 of the compact set ?. The point x0 may be written as

x0 = expp(δv), |v| = l,v ∈ Tp(S).

[Page 355]

x

δ p

γ

q

x0 ∑

###### Figure 5-9

Let γ be the geodesic parametrized by arc length, given by (see Fig. 5-9)

γ(s) = expp(sv).

Since S is complete, γ is deﬁned for every s ∈ R. In particular, γ is deﬁned in the interval [0,r]. If we show that γ(r) = q, then γ must be a geodesic joining p to q which is minimal, since l(γ) = r = d(p,q), and this will conclude the proof.

To prove this, we shall show that if s ∈ [δ,r], then

d(γ(s),q) = r −s. (1) Equation (1) implies, for s = r, that γ(r) = q, as desired.

To prove Eq. (1), we shall ﬁrst show that it holds for s = δ. Now the set A = {s ∈ [δ,r]; where Eq. (1) holds} is clearly closed in [0,r]. Next we show that if s0 ∈ A and s0 < r, then Eq. (1) holds for S0 +δ′, where δ′ > 0 and δ′ is sufﬁciently small. It follows that A = [δ,r] and that Eq. (1) will be proved.

We shall now show that Eq. (1) holds for s = δ. In fact, since every curve joining p to q intersects ?, we have, denoting by x an arbitrary point of ?,

d(p,q) = inf

α

l(αp,q) = inf x∈?

{inf

α

l(αp,x)+inf

α

l(αx,q)}

= inf

x∈?

(d(p,x)+d(x,q)) = inf

x∈?

(δ +d(x,q))

= δ +d(x0,q). Hence,

d(γ(δ),q) = r −δ, which is Eq. (1) for s = δ.

Now we shall show that if Eq. (1) holds for s0 ∈ [δ,r], then. for δ′ > 0 and sufﬁciently small, it holds for s0 +δ′.

Let Bδ′(0) be a disk in the tangent plane Tγ(s0)(S), centered in the origin 0 of this tangent plane and contained in a neighborhood U′, where expγ(s

0) is a diffeomorphism. Let Bδ′(γ(s0)) = expγ(s

0) Bδ′(0) and ?′ = Bd (Bδ′(γ(s0)). If x′ ∈ ?′, the continuous function d(x′,q) reaches a minimum at x′

0 ∈ ?′ (see Fig. 5-10). Then, as previously,

[Page 356]

p

γ

γ(s0)

δ´

∑´

q

x0´

###### Figure 5-10

d(γ(s0),q) = inf

x′∈?′

{d(γ(s0),x′)+d(x′,q)}

= δ′ +d(x0′,q). Since Eq. (1) holds in s0, we have that d(γ(s0),q) = r −s0. Therefore,

d(x0′,q) = r −s0 −δ′. (2) Furthermore, since

d(p,x0′) ≥ d(p,q)−d(q,x0′), we obtain from Eq. (2)

d(p,x0′) ≥ r −(r −s0)+δ′ = s0 +δ′.

Observe now that the curve that goes from p to γ(s0) through γ and from γ(s0) to x′

0 through a geodesic radius of Bδ′(γ(s0)) has length exactly equal to

- s0 +δ′. Since d(p,x′


0) ≥ s0 +δ′, this curve, which joins p to x′

0, has minimal length. It follows (Sec. 4-7, Prop. 2) that it is a geodesic, and hence regular in all its points. Therefore, it should coincide with γ; hence, x′

0 = γ(s0 +δ′). Thus, Eq. (2) may be written as

d(γ(s0 +δ′),q) = r −(s0 +δ′), which is Eq. (1) for s = s0 +δ′.

This proves our assertion and concludes the proof. Q.E.D. COROLLARY 1. Let S be complete. Then for every point p ∈ S the map

expp: Tp(S) → S is onto S.

This is true because if q ∈ S and d(p,q) = r, then q = expp rv, where v = γ′(0) is the tangent vector of a minimal geodesic γ parametrized by the arc length and joining p to q.

COROLLARY 2. Let S be complete and bounded in the metric d (that is, there exists r > 0 such that d(p,q) < r for every pair p, q ∈ S). Then S is compact.

[Page 357]

Proof. By ﬁxing p ∈ S, the fact that S is bounded implies the existence of aclosedballB ⊂ Tp(S)ofradiusr, centeredattheorigin0ofthetangentplane Tp(S), suchthatexpp(B) = expp(Tp(S)). Bythefactthatexpp isonto, wehave S = expp(Tp(S)) = expp(B). Since B is compact and expp is continuous, we conclude that S is compact. Q.E.D.

From now on, the metric notions to be used will refer, except when otherwise stated, to the distance d in Def. 3. For instance, the diameter ρ(S) of a surface S is, by deﬁnition,

ρ(s) = sup

p,q∈S

d(p,q).

With this deﬁnition, the diameter of a unit sphere S2 is ρ(S2) = π.

###### EXERCISES

- 1. Let S ⊂ R3 be a complete surface and let F ⊂ S be a nonempty, closed subset of S such that the complement S −F is connected. Show that S −F is a non-complete regular surface.
- 2. Let S be the one-sheeted cone of Example 1. Show that, given p ∈ S, the only geodesic of S that passes through p and cannot be extended for every value of the parameter is the meridian of S through p.
- 3. Let S be the one-sheeted cone of Example 1. Use the isometry of Example3ofSec.4-2toshowthatanytwopointsp, q ∈ S (seeFig.5-11) can be joined by a minimal geodesic on S.
- 4. We say that a sequence {pn} of points on a regular surface S ⊂ R3 converges to a point p0 ∈ S in the (intrinsic) distance d if given ǫ > 0 there


α

2π sin α

Isometry

###### Figure 5-11

[Page 358]

exists an index n0 such that n ≥ n0 implies that d(pn,p0) > ǫ. Prove that a sequence {pn} of points in S converges in d to p0 ∈ S if and only if {pn} converges to p0 as a sequence of points in R3 (i.e., in the Euclidean distance).

- *5. Let S ⊂ R3 be a regular surface. A sequence {pn} of points on S is a Cauchy sequence in the (intrinsic) distance d if given ǫ > 0 there exists

an index n0 such that when n, m ≥ n0 then d(pn,pm) < ǫ. Prove that S is complete if and only if every Cauchy sequence on S converges to a point in S.

- *6. Ageodesic γ: [0,∞) → S on a surface S is a ray issuing from γ(0) if it realizes the (intrinsic) distance between γ(0) and γ(s) for all s ∈ [0,∞). Let p be a point on a complete, noncompact surface S. Prove that S contains a ray issuing from p.

7. A divergent curve on S is a differentiable map α: [0,∞) → S such that foreverycompactsubsetK ⊂ S thereexistsat0 ∈ (0,∞)withα(t) ∈/ K for t > t0 (i.e., α “leaves” every compact subset of S). The length of a divergent curve is deﬁned as

lim

t→∞

? t

0

|α′(t)|dt.

Prove that S ⊂ R3 is complete if and only if the length of every divergent curve is unbounded.

- *8. Let S and S¯ be regular surfaces and let ϕ: S → S¯ be a diffeomorphism. Assume that S¯ is complete and that a constant c > 0 exists such that

Ip(v) ≥ cI¯ϕ(p)(dϕp(v))

for all p ∈ S and all v ∈ Tp(S), where I and I¯ denote the ﬁrst fundamental forms of S and S¯, respectively. Prove that S is complete.

- *9. Let S1 ⊂ R3 be a (connected) complete surface and S2 ⊂ R3 be a connected surface such that any two points of S2 can be joined by a unique geodesic. Let ϕ: S1 → S2 be a local isometry. Prove that ϕ is a global isometry.
- *10. LetS ∈ R3 beacompletesurface. Fixaunitvectorv ∈ R3 andleth:S → R betheheightfunctionh(p) = ?p,v?, p ∈ S.Werecallthatthegradient of h is the (tangent) vector ﬁeld grad h on S deﬁned by


?grad h(p),w?p = dhp(w) for all w ∈ Tp(S)

(cf. Exercise 14, Sec. 2-5). Let α(t) be a trajectory of grad h; i.e., α(t) is a curve on S such that α′(t) = grad h(α(t)). Prove that

- a. |grad h(p)| ≤ 1 for all p ∈ S.
- b. A trajectory α(t) of grad h is deﬁned for all t ∈ R.


[Page 359]

The following exercise presumes the material of Sec. 3-5, part, B and an elementary knowledge of functions of complex variables.

11. (Osserman’s Lemma.) Let D1 = {ζ ∈ C;|ζ| ≤ 1} be the unit disk in the complex plane C. As usual, we identify C ≈ R2 by ζ = u+iv. Let x: D1 → R3 be an isothermal parametrization of a minimal surface x(D1) ⊂ R3. This means (cf. Sec. 3-5, Part B) that

?xu,xu? = ?xv,xv?, ?xu,xv? = 0 and (the minimality condition) that

xuu +xvv = 0.

Assume that the unit normal vectors of x(D1) omit a neighborhood of a unit sphere. More precisely, assume that for some vector w ∈ R3, |w| = 1, there exists an ǫ > 0 such that

?xu,w?2 |xu|2

≥ ǫ2 and ?xv,w?2 |xv|2

≥ ǫ2. (∗)

The goal of the exercise is to prove that x(D) is not a complete surface. (This is the crucial step in the proof of Osserman’s theorem quoted at the end of Sec. 3-5.) Proceed as follows:

- a. Deﬁne ϕ: D1 → C by ϕ(u,v) = ϕ(ζ) = ?xu,w?+i?xv,w?.

Show that the minimality condition implies that ϕ is analytic.

- b. Deﬁne θ: D1 → C by

θ(ζ) = ? ζ

0

ϕ(ζ)dζ = η.

By part a, θ is an analytic function. Show that θ(0) = 0 and that the condition (∗) implies that θ′(ζ) ?= 0. Thus, in a neighborhood of 0, θ has an analytic inverse θ−1. Use Liouville’s theorem to show that θ−1 cannot be analytically extended to all of C.

- c. By part b there is a disk DR = {η ∈ C;|η| ≤ R}


and a point η0, with |η0| = R, such that θ−1 is analytic in D and cannot be analytically extended to a neighborhood of η0 (Fig. 5-12).

[Page 360]

D1

DR

ζ plane η plane

θ

1

α

η0

###### Figure 5-12

Let L be the segment of DR that joins η0 to 0; i.e., L = {tη0 ∈ C;0 ≤ t ≤ 1}. Set α = θ−1(L) and show that the arc length l of x(α) is

l = ?

α

?2?xu,xv???

du dt ?2 +?

dv dt ?2?dt

≤

1 ǫ ?

α

??xu,w?2 +?xv,w?2|dζ| =

1 ǫ ?

α

|ϕ(ζ)||dζ|

=

R ǫ

< +∞. Use Exercise 7 to conclude that x(D) is not complete.

###### 5-4. First and Second Variations of Arc Length; Bonnet’s Theorem

The goal of this section is to prove that a complete surface S with Gaussian curvature K ≥ δ > 0 is compact (Bonnet’s theorem).

The crucial point of the proof is to show that if K ≥ δ > 0, a geodesic γ joining two arbitrary points p, q ∈ S and having length l(γ) > π/√δ is no longer minimal; that is, there exists a parametrized curve joining p and q, the length of which is smaller than l(γ).

Once this is proved, it follows that every minimal geodesic has length l ≤ π/√δ; thus, S is bounded in the distance d. Since S is complete, S is compact (Corollary 2, Sec. 5-3). We remark that, in addition, we obtain an estimate for the diameter of S, namely, ρ(S) ≤ π/√δ.

To prove the above point, we need to compare the arc length of a parametrized curve with the arc length of “neighboring curves.” For this,

[Page 361]

we shall introduce a number of ideas which are useful in other problems of differential geometry. Actually, these ideas are adaptations to the purposes of differential geometry of more general concepts found in calculus of variations. No knowledge of calculus of variations will be assumed.

In this section, S will denote a regular (not necessarily complete) surface. We shall begin by making precise the idea of neighboring curves of a given

curve.

DEFINITION 1. Let α: [0,l] → S be a regular parametrized curve, where the parameter s ∈ [0,l] is the arc length. A variation of α is a differentiable map h: [0,l]×(−ǫ,ǫ) ⊂ R2 → S such that

h(s,0) = α(s), s ∈ (0,l].

For each t ⊂ (−ǫ,ǫ), the curve ht: [0,l] → S, given by ht(s) = h(s,t), is called a curve of the variation h. A variation h is said to be proper if

h(0,t) = α(0), h(l,t) = α(l), t ∈ (−ǫ,ǫ).

Intuitively, avariationofα isafamilyht ofcurvesdependingdifferentiably on a parameter t ∈ (−ǫ,ǫ) and such that h0 agrees with α (Fig. 5-13). The condition of being proper means that all curves ht have the same initial point α(0) and the same end point α(l).

It is convenient to adopt the following notation. The parametrized curves in R2 given by

s → (s,t0), t → (s0,t),

S V

q p

h

l

ε

–ε

| |
|---|
| |
| |
| |


0

###### Figure 5-13

[Page 362]

pass through the point p0 = (s0,t0) ∈ R2 and have (1, 0) and (0, 1) as tangent vectors at (s0,t0). Let h: [0,l]×(−ǫ,ǫ) ⊂ R2 → S be a differentiable map and let p0 ∈ [0,l]×(−ǫ,ǫ). Then dhp0(1,0) is the tangent vector to the curve s → h(s,t0) at h(p0), and dhp0(0,1) is the tangent vector to the curve

- t → h(s0,t) at h(p0). We shall denote


dhp0(1,0) =

∂h ∂s

(p0),

dhp0(0,1) =

∂h ∂t

(p0).

We recall (cf. Sec. 4-4, Def. 3) that a vector ﬁeld w along a curve α: I → S is a correspondence that assigns to each t ∈ I a vector w(t) tangent to the surface S at α(t). Thus, ∂h/∂s and ∂h/∂t are differentiable tangent vector ﬁelds along α.

It follows that a variation h of α determines a differentiable vector ﬁeld V (s) along α by

V (s) =

∂h ∂t

(s,0), S ∈ [0,l].

V is called the variational vector ﬁeld of h; we remark that if h is proper, then V (0) = V (l) = 0.

This terminology is justiﬁed by the following proposition.

PROPOSITION 1. If we let V(s) be a differentiable vector ﬁeld along a parametrized regular curve α: [0,l] → S then there exists a variation h: [0,l]×(−ǫ,ǫ) → S of α such that V(s) is the variational vector ﬁeld of h. Furthermore, if V(0) = V(l) = 0, then h can be chosen to be proper.

Proof. We ﬁrst show that there exists a δ > 0 such that if |v| < δ, v ∈ Tα(s)(S), then expα(s) v is well deﬁned for all s ∈ [0,l]. In fact, for each p ∈ α([0,l]) ⊂ S consider the neighborhood Wp (a normal neighborhood of all of its points) and the number δp > 0 given by Prop. 1 of Sec. 4-7. The union

?

p Wp covers α([0,l]) and, by compactness, a ﬁnite number of them, say, W1,...,Wn still covers α([0,l]). Set δ = min(δ1,...,δn), where δi is the number corresponding to the neighborhood Wi, i = 1,...,n. It is easily seen that δ satisﬁes the above condition.

Now let M = maxs∈[0,l] |V (s)|, ǫ < δ/M, and deﬁne

h(s,t) = expα(t) tV (s), s ∈ [0,l], t ∈ (−ǫ,ǫ). h is clearly well deﬁned. Furthermore, since

expα(s) tV (s) = γ(1,α(s),tV (s)),

where γ is the (differentiable) map of Theorem 1 of Sec. 4-7 (i.e., for t ?= 0, and V (s) ?= 0, γ(1,α(s),tV (s)) is the geodesic γ with initial conditions

[Page 363]

γ(0) = α(s), γ′(0) = V (s)), h is differentiable. It is immediately checked that h(s,0) = α(s). Finally, the variational vector ﬁeld of h is given by

∂h ∂t

(s,0) = dh(s,0)(0,1) =

d dt

(expα(s) tV (s))?

t=0

=

d dt

γ(1,α(s),tV (s))?

t=0

=

d dt

γ(t,α(s),V (s))?

t=0

= V (s),

and it is clear, by the deﬁnition of h, that if V (0) = V (l) = 0, then h is proper.

Q.E.D. We want to compare the arc length of α(= h0) with the arc length of ht.

Thus, we deﬁne a function L: (−ǫ,ǫ) → R by

L(t) = ? l

0

?

∂h ∂s

(s,t)?ds, t ∈ (−ǫ,ǫ). (1)

The study of L in a neighborhood of t = 0 will inform us of the “arc length behavior” of curves neighboring α.

We need some preliminary lemmas. LEMMA 1. The function L deﬁned by Eq. (1) is differentiable in a neigh-

borhood of t = 0; in such a neighborhood, the derivative of L may be obtained by differentiation under the integral sign.

Proof. Since α: [0,l] → S is parametrized by arc length,

?

∂h ∂s ? = ?

∂h ∂s

(s,0)? = 1.

It follows, by compactness of [0,l], that there exists a δ > 0, δ ≤ ǫ, such that

?

∂h ∂s

(s,t)? ?= 0, s ∈ [0,l], |t| < δ.

Since the absolute value of a nonzero differentiable function is differentiable, the integrand of Eq. (1) is differentiable for |t| < δ. By a classical theorem of calculus (see R. C. Buck, Advanced Calculus, 1965, p. 120), we conclude that L is differentiable for |t| < δ and that

L′(t) = ? l

0

∂ ∂t ?

∂h ∂s

(s,t)?ds. Q.E.D.

Lemmas 2, 3, and 4 below have some independent interest.

[Page 364]

LEMMA 2. Let w(t) be a differentiable vector ﬁeld along the parametrizedcurveα:[a,b] → S andletf:[a,b] → R beadifferentiablefunction. Then

D dt

(f(t)w(t)) = f(t)

DW dt +

df dt

w(t).

Proof. It sufﬁces to use the fact that the covariant derivative is the tangential component of the usual derivative to conclude that (here ( )T denotes the tangential component of ( ))

D dt

(fw) = ?

df dt

w +f

dw dt ?

T

=

df dt

w +f ?

dw dt ?

T

=

df dt

w +f

Dw dt

###### . Q.E.D.

LEMMA 3. Let v(t) and w(t) be differentiable vector ﬁelds along the parametrized curve α: [a,b] → S. Then

d dt?v(t),w(t)? = ?

DV dt

,w(t)?+?v(t),

DW

dt ?. Proof. Using the remarks of the above proof, we obtain

d dt?v,w? = ?

dv dt

,w?+?v,

dw dt ? = ??

dv dt ?

T

,w?+?v,?

dw dt ?

T

?

= ?

Dv dt

,w?+?v,

Dw dt ?. Q.E.D.

Before stating the next lemma it is convenient to introduce the following terminology. Let h: [0,l]×(−ǫ,ǫ) → S be a differentiable map. A differentiable vector ﬁeld along h is a differentiable map

V : [0,l]×(−ǫ,ǫ) → T (S) ⊂ R3

such that V (s,t) ∈ Th(s,t)(S) for each (s,t) ∈ [0,l]×(−ǫ,ǫ). This generalizes the deﬁnition of a differentiable vector ﬁeld along a parametrized curve (Sec. 4-4, Def. 2).

For instance, the vector ﬁelds (∂h/∂s)(s,t) and, (∂h/∂t)(s,t), introduced above, are vector ﬁelds along h.

If we restrict V (s,t) to the curves s = const., t = const., we obtain vector ﬁelds along curves. In this context, the notation (DV/∂t)(s,t) means the covariant derivative, at the point (s,t), of the restriction of V (s,t) to the curve s = const.

[Page 365]

LEMMA 4. Let h: [0,l]×(−ǫ,ǫ) ⊂ R2 → S be a differentiable mapping. Then

D ∂s

∂h ∂t

(s,t) =

D ∂t

∂h ∂s

(s,t).

Proof. Let x: U → S be a parametrization of S at the point h(s,t), with parameters u, v, and let

u = h1(s,t), v = h2(s,t) be the expression of h in this parametrization. Under these conditions, when (s,t) ∈ h−1(x(U)) = W, the curve h(s,t0) may be expressed by

u = h1(s,t0), v = h2(s,t0). Since (∂h/∂s)(s0,t0) is tangent to the curve h(s,t0) at s = s0, we have that

∂h ∂s

(s0,t0) =

∂h1 ∂s

(s0,t0)xu +

∂h2 ∂s

(s0,t0)xv.

By the arbitrariness of (s0,t0) ∈ W, we conclude that ∂h ∂s =

∂h1 ∂s

xu +

∂h2 ∂s

xv,

where we omit the indication of the point (s,t) for simplicity of notation. Similarly,

∂h ∂t =

∂h1 ∂t

xu +

∂h2 ∂t

xv.

We shall now compute the covariant derivatives (D/∂s)(∂h/∂t) and (D/∂t)(∂h/∂s) using the expression of the covariant derivative in terms of the Christoffel symbols Ŵijk (Sec. 4-4, Eq. (1)) and obtain the asserted equality. For instance, the coefﬁcient of xu in both derivatives is given by

∂2h1 ∂s∂t +Ŵ111

∂h1 ∂t

∂h1 ∂s +Ŵ121

∂h1 ∂t

∂h2 ∂s +Ŵ121

∂h2 ∂t

∂h1 ∂s +Ŵ221

∂h2 ∂t

∂h2 ∂s

.

The equality of the coefﬁcients of xv may be shown in the same way, thus concluding the proof. Q.E.D.

We are now in a position to compute the ﬁrst derivative of L at t = 0 and obtain

PROPOSITION 2. Let h: [0,l]×(−ǫ,ǫ) be a proper variation of the curve α: [0,l] → S and let V(s) = (∂h/∂t)(s,0), s ∈ (0,l], be the variational vector ﬁeld of h. Then

L′(0) = −? l

0

?A(s),V(s)?ds, (2) where A(s) = (D/∂s)(∂h/∂s)(s,0).

[Page 366]

Proof. If t belongs to the interval (−δ,δ) given by Lemma 1, then

L′(t) = ? l

0

?

d dt ?

∂h ∂s

,

∂h ∂s ?1/2?ds.

By applying Lemmas 3 and 4, we obtain

L′(t) = ? 0

l

?

D ∂t

∂h ∂s

,

∂h ∂s ?

?

∂h ∂s ?

ds = ? l

0

?

D ∂s

∂h ∂t

,

∂h ∂s ?

?

∂h ∂s ?

ds.

Since |(∂h/∂s)(s,0)| = 1, we have that

L′(0) = ? l

0

?

D ∂s

∂h ∂t

,

∂h ∂s ?ds,

where the integrand is calculated at (s,0), which is omitted for simplicity of notation.

According to Lemma 3, ∂ ∂s ?

∂h ∂s

,

∂h ∂t ? = ?

D ∂s

∂h ∂s

,

∂h ∂t ?+?

∂h ∂s

,

D ∂s

∂h ∂t ?.

Therefore,

L′(0) = ? l

0

∂ ∂s ?

∂h ∂s

,

∂h ∂t ?ds −? l

0

?

D ∂s

∂h ∂s

,

∂h ∂t ?ds

= −? l

0

?

D ∂s

∂h ∂s

,

∂h ∂t ?ds,

since (∂h/∂t)(0,0) = (∂h/∂t)(l,0) = 0, due to the fact that the variation is proper. By recalling the deﬁnitions of A(s) and V (s), we may write the last expression in the form

L′(0) = −? l

0

?A(s),V (s)?ds. Q.E.D.

Remark 1. The vector A(s) is called the acceleration vector of the curve α, and its norm is nothing but the absolute value of the geodesic curvature of α. Observe that L′(0) depends only on the variational ﬁeld V (s) and not on the variation h itself. Expression (2) is usually called the formula for the ﬁrst variation of the arc length of the curve α.

[Page 367]

Remark 2. The condition that h is proper was only used at the end of the proof in order to eliminate the terms

?

∂h ∂s

,

∂h ∂t ?(l,0)−?

∂h ∂s

,

∂h ∂t ?(0,0).

Therefore, if h is not proper, we obtain a formula which is similar to Eq. (2) and contains these additional boundary terms.

An interesting consequence of Prop. 2 is a characterization of the geodesics as solutions of a “variational problem.” More precisely,

PROPOSITION 3. A regular parametrized curve α: [0,l] → S, where the parameter s ∈ [0,l] is the arc length of α, is a geodesic if and only if, for every proper variation h: [0,l]×(−ǫ,ǫ) → S of α, L′(0) = 0.

Proof. The necessity is trivial since the acceleration vector A(s) = (D/∂s)(∂α/∂s) of a geodesic α is identically zero. Therefore, L′(0) = 0 for every proper variation.

Suppose now that L′(0) = 0 for every proper variation of α and consider a vector ﬁeld V (s) = f(s)A(s), where f : [0,l] → R is a real differentiable function, with f (s) ≥ 0, f (0) = f (l) = 0, and A(s) is the acceleration vector of α. By constructing a variation corresponding to V (s), we have

L′(0) = −? l

0

?f(s)A(s),A(s)?ds

= −? l

0

f (s)|A(s)|2 ds = 0.

Therefore, since f (s)|A(s)|2 ≥ 0, we obtain f (s)|A(s)|2 ≡ 0.

We shall prove that the above relation implies that A(s) = 0, s ∈ [0,l]. In fact, if |A(s0)| ?= 0, s0 ∈ (0,l), there exists an interval I = (s0 −ǫ,s0 +ǫ) such that |A(s)| ?= 0 for s ∈ I. By choosing f such that f (s0) > 0, we contradict f (s0)|A(s0)| = 0. Therefore, |A(s)| = 0 when s ∈ (0,l). By continuity, A(0) = A(l) = 0 as asserted.

Since the acceleration vector of α is identically zero, α is geodesic.

###### Q.E.D.

From now on, we shall only consider proper variations of geodesics γ: [0,l] → S, parametrized by arc length; that is, we assume L′(0) = 0. To simplify the computations, we shall restrict ourselves to orthogonal variations; that is, we shall assume that the variational ﬁeld V (s) satisﬁes the

[Page 368]

condition ?V (s),γ′(s)? = 0, s ∈ [0,l]. To study the behavior of the function L in a neighborhood of 0 we shall compute L′′(0).

For this computation, we need some lemmas that relate the Gaussian curvature to the covariant derivative.

LEMMA 5. Let x: U → S be a parametrization at a point p ∈ S of a regular surface S, with parameters u, v, and let K be the Gaussian curvature of S. Then

D ∂v

D ∂u

xu −

D ∂u

D ∂v

xu = K(xu ∧xv)∧xu.

Proof. By observing that the covariant derivative is the component of the usual derivative in the tangent plane, we have that (Sec. 4-3)

D ∂u

xu = Ŵ111 xu +Ŵ112 xv.

By applying to the above expression the formula for the covariant derivative (Sec. 4-4, Eq. (1)), we obtain

D ∂v ?

D ∂u

xu? = {(Ŵ111 )v +Ŵ121 Ŵ111 +Ŵ221 Ŵ112 }xu

+{(Ŵ112 )v +Ŵ122 Ŵ111 +Ŵ222 Ŵ112 }xv. We verify, by means of a similar computation, that

D ∂u ?

D ∂v

xu? = {(Ŵ121 )u +Ŵ121 Ŵ111 +Ŵ121 Ŵ122 }xu

+{(Ŵ122 )u +Ŵ112 Ŵ121 +Ŵ122 Ŵ122 }xv. Therefore,

D ∂v

D ∂u

xu −

D ∂u

D ∂v

xu = {(Ŵ111 )v −(Ŵ121 )u +Ŵ221 Ŵ112 −Ŵ121 Ŵ122 }xu

+{(Ŵ112 )v −(Ŵ122 )u +Ŵ122 Ŵ111 +Ŵ222 Ŵ112 −Ŵ112 Ŵ121 −Ŵ122 Ŵ122 }xv.

We now use the expressions of the curvature in terms of Christoffel symbols (Sec. 4-3, Eqs. (5) and (5a) and conclude that

D ∂v

D ∂u

xu −

D ∂u

D ∂v

xu = −FKxu +EKxv

= K{?xu,xu?xv −?xu,xv?xu}

= K(xu ∧xv)∧xu. Q.E.D.

[Page 369]

LEMMA 6. Let h: [0,l]×(−ǫ,ǫ) → S be a differentiable mapping and let V(s,t), (s,t) ∈ [0,l]×(−ǫ,ǫ), be a differentiable vector ﬁeld along h. Then

D ∂t

D ∂s

V −

D ∂s

D ∂t

V = K(s,t)?

∂h ∂s ∧

∂h ∂t ?∧V,

where K(s,t) is the curvature of S at the point h(s,t). Proof. Let x(u,v) be a system of coordinates of S around h(s,t) and let V (s,t) = a(s,t)xu +b(s,t)xv

be the expression of V (s,t) = V in this system of coordinates. By Lemma 2, we have

D ∂s

V =

D ∂s

(axu +bxv)

= a

D ∂s

xu +b

D ∂s

xv +

∂a ∂s

xu +

∂b ∂s

xv.

Therefore,

D ∂t

D ∂s

V = a

D ∂t

D ∂s

xu +b

D ∂t

D ∂s

xv +

∂a ∂s

D ∂t

###### xu

+

∂b ∂s

D ∂t

xv +

∂a ∂t

D ∂s

xu +

∂b ∂t

D ∂s

xv +

∂2a ∂t∂s

xu +

∂2b ∂t∂s

xv.

By a similar computation, we obtain a formula for (D/∂s)(D/∂t)V , which is given by interchanging s and t in the last expression. It follows that

D ∂t

D ∂s

V −

D ∂s

D ∂t

V = a ?

D ∂t

D ∂s

xu −

D ∂s

D ∂t

xu?

+b ?

D ∂t

D ∂s

xv −

D ∂s

D ∂t

###### xv?. (3)

To compute (D/∂t)(D/∂s)xu, we shall take the expression of h,

u = h1(s,t), v = h2(s,t), in the parametrization x(u,v) and write

xu(u,v) = xu(h1(s,t),h2(s,t)) = xu.

[Page 370]

Since the covariant derivative (D/∂s)xu is the projection onto the tangent plane of the usual derivative (d/ds)xu, we have

D ∂s

xu = ?

d ds

xu?

T

= ?xuu

∂h1 ∂s +xuv

∂h2 ∂s ?

T

=

∂h1 ∂s {xuu}T +

∂h2 ∂s {xuv}T

=

∂h1 ∂s

D ∂u

xu +

∂h2 ∂s

D ∂v

xu,

where T denotes the projection of a vector onto the tangent plane. With the same notation, we obtain

D ∂t

D ∂s

xu = ?

d dt ?

∂h1 ∂s

D ∂u

xu +

∂h2 ∂s

D ∂v

xu??

T

=

∂2h1 ∂t∂s

D ∂u

xu +

∂2h2 ∂t∂s

D ∂v

xu +

∂h1 ∂s ?

∂h1 ∂t

D ∂u

D ∂u

xu +

∂h2 ∂t

D ∂v

D ∂u

xu?

+

∂h2 ∂s ?

∂h1 ∂t

D ∂u

D ∂v

xu +

∂h2 ∂t

D ∂v

D ∂u

xu?.

In a similar way, we obtain (D/∂s)(D/∂t)xu, which is given by interchanging s and t in the above expression. It follows that

D ∂t

D ∂s

xu −

D ∂s

D ∂t

xu =

∂h2 ∂s

∂h1 ∂t ?

D ∂u

D ∂v

xu −

D ∂v

D ∂u

xu?

+

∂h1 ∂s

∂h2 ∂t ?

D ∂v

D ∂u

xu −

D ∂u

D ∂v

xu?

= ??

D ∂v

D ∂u

xu −

D ∂u

D ∂v

xu?, where

? = ?

∂h1 ∂s

∂h2 ∂t −

∂h2 ∂s

∂h1 ∂t ?.

By replacing xu for xv, in the last expression, we obtain

D ∂t

D ∂s

xv −

D ∂s

D ∂t

xv = ??

D ∂v

D ∂u

xv −

D ∂u

D ∂v

xv?.

By introducing the above expression in Eq. (3) and using Lemma 5, we conclude that

D ∂t

D ∂s

V −

D ∂s

D ∂t

V = a?K(xu ∧xv)∧xu +b?K(xu ∧xv)∧xv

= K(?xu ∧xv)∧(axu +bxv).

[Page 371]

On the other hand, as we saw in the proof of Lemma 4,

∂h ∂s =

∂h1 ∂s

xu +

∂h2 ∂s

xv,

∂h ∂t =

∂h1 ∂t

xu +

∂h2 ∂t

xv;

hence,

∂h ∂s ∧

∂h ∂t = ?xu ∧xv.

Therefore,

D ∂t

D ∂s

V −

D ∂s

D ∂t

V = K ?

∂h ∂s ∧

∂h ∂t ?∧V. Q.E.D.

We are now in a position to compute L′′(0). PROPOSITION 4. Let h: [0,l]×(−ǫ,ǫ) → S be a proper orthogonal

variation of a geodesic γ: [0,l] → S parametrized by the arc length s ∈ [0,l]. Let V(s) = (∂h/∂t)(s,0) be the variational vector ﬁeld of h. Then

L′′(0) = ? l

0

?

?

D ∂s

V(s)?

2

−K(s)|V(s)|2?ds, (4)

where K(s) = K(s,0) is the Gaussian curvature of S at γ(s) = h(s,0). Proof. As we saw in the proof of Prop. 2,

L′(t) = ? l

0

?

D ∂s

∂h ∂t

,

∂h ∂s ?

?

∂h ∂s

,

∂h ∂s ?1/2 ds

for t belonging to the interval (−δ,δ) given by Lemma 1. By differentiating the above expression, we obtain

L′′(t) = ? l

0

?

d dt ?

D ∂s

∂h ∂t

,

∂h ∂s ???

∂h ∂s

,

∂h ∂s ?1/2

?

∂h ∂s

,

∂h ∂s ? ds

−? l

0

??

D ∂s

∂h ∂t

,

∂h ∂s ??2

?

∂h ∂s ?

3/2 ds.

[Page 372]

Observe now that for t = 0, |(∂h/∂s)(s,0)| = 1. Furthermore,

d ds ?

∂h ∂s

,

∂h ∂t ? = ?

D ∂s

∂h ∂s

,

∂h ∂t ?+?

∂h ∂s

,

D ∂s

∂h ∂t ?.

Since γ is a geodesic, (D/∂s)(∂h/∂s) = 0 for t = 0, and since the variation is orthogonal,

?

∂h ∂s

,

∂h ∂t ? = 0 for t = 0.

It follows that

L′′(0) = ? l

0

d dt ?

D ∂s

∂h ∂t

,

∂h ∂s ?ds, (5)

where the integrand is calculated at (s,0).

Let us now transform the integrand of Eq. (5) into a more convenient expression. Observe ﬁrst that

d dt ?

D ∂s

∂h ∂t

,

∂h ∂s ? = ?

D ∂t

D ∂s

∂h ∂t

,

∂h ∂s ?+?

D ∂s

∂h ∂t

,

D ∂t

∂h ∂s ?

= ?

D ∂t

D ∂s

∂h ∂t

,

∂h ∂s ?−?

D ∂s

D ∂t

∂h ∂t

,

∂h ∂s ?

+?

D ∂s

D ∂t

∂h ∂t

,

∂h ∂s ?+?

D ∂s

∂h ∂t ?

2

.

On the other hand, for t = 0,

d ds ?

D ∂t

∂h ∂t

,

∂h ∂s ? = ?

D ∂s

D ∂t

∂h ∂t

,

∂h ∂s ?,

since (D/∂s)(∂h/∂s)(s,0) = 0, owing to the fact that γ is a geodesic. Moreover, by using Lemma 6 plus the fact that the variation is orthogonal, we obtain (for t = 0)

?

D ∂t

D ∂s

∂h ∂t

,

∂h ∂s ?−?

D ∂s

D ∂t

∂h ∂t

,

∂h ∂s ? = K(s)??

∂h ∂s ∧

∂h ∂t ?∧

∂h ∂t

,

∂h ∂s ?

= −K(s)?|V (s)|2

∂h ∂s

,

∂h ∂s ?

= −K|V (s)|2.

[Page 373]

By introducing the above values in Eq. (5), we have

L′′(0) = ? l

0

?−K(s)|V (s)|2 +?

D ∂s

V (s)?

2

?ds

+?

D ∂t

∂h ∂t

,

∂h ∂s ?(l,0)−?

D ∂t

∂h ∂t

,

∂h ∂s ?(0,0).

Finally, since the variation is proper, (∂h/∂t)(0,t) = (∂h/∂t)(l,t) = 0, t ∈ (−δ,δ). Thus,

L′′(0) = ? l

0

?

?

D ∂s

V (s)?

2

−K|V (s)|2?ds. Q.E.D.

- Remark 3. Expression (4) is called the formula for the second variation of

the arc length of γ. Observe that it depends only on the variational ﬁeld of h and not on the variation h itself. Sometimes it is convenient to indicate this dependence by writing L′′

v(0).

- Remark 4. It is often convenient to have the formula (4) for the second


variation written as follows:

L′′(0) = −? l

0

?

D2V

ds2 +KV,V ?ds. (4a) Equation (4a) comes from Eq. (4), by noticing that V (0) = V (l) = 0 and that

d ds ?V,

DV ds ? = ?

DV ds

,

DV ds ?+?V,

D2V

ds2 ?. Thus,

? l

0

??

DV ds

,

DV ds ?−K?V,V ??ds = ??V,

DV ds ??l

0 −? l

0

?

D2V ds2 +KV,V ?ds

= −? l

0

?

D2V ds2 +KV,V ?ds.

The second variation L′′(0) of the arc length is the tool that we need to prove the crucial step in Bonnet’s theorem, which was mentioned in the beginning of this section. We may now prove

[Page 374]

THEOREM 1 (Bonnet). Let the Gaussian curvature K of a complete surface S satisfy the condition

K ≥ δ > 0. Then S is compact and the diameter ρ of S satisﬁes the inequality ρ ≤

π √δ

.

Proof. Since S is complete, given two points p, q ∈ S, there exists, by the Hopf-Rinow theorem, a minimal geodesic γ of S joining p to q. We shall prove that the length l = d(p,q) of this geodesic satisﬁes the inequality

l ≤

π √δ

.

We shall assume that l > π/√δ and consider a variation of the geodesic γ: [0,l] → S, deﬁned as follows. Let w0 be a unit vector of Tγ(0)(S) such that ?w0,γ′(0)? = 0 and let w(s), s ∈ [0,l], be the parallel transport of w0 along γ. It is clear that |w(s)| = 1 and that ?w(s),γ′(s)? = 0, s ∈ [0,l]. Consider the vector ﬁeld V (s) deﬁned by

V (s) = w(s)sin

π l

s, s ∈ (0,l].

Since V (0) = V (l) = 0 and ?V (s),γ′(s)? = 0, the vector ﬁeld V (s) determines a proper, orthogonal variation of γ. By Prop. 4,

L′′v(0) = ? l

0

?

?

D ∂s

V (s)?

2

−K(s)|V (s)|2?ds.

Since w(s) is a parallel vector ﬁeld,

D ∂s

V (s) = ?π l

cos

π l

s

?

w(s).

Thus, since l > π/√δ, so that K ≥ δ > π2/l2, we obtain

L′′v(0) = ? l

0

?

π2 l2

cos2

π l

s −K sin2

π l

s?ds

< ? l

0

π2 l2 ?

cos2

π l

s −sin2

π l

s

?

ds

=

π2 l2 ? l

0

cos

2π l

s ds = 0.

Therefore, there exists a variation of γ for which L′′(0) < 0. However, since γ is a minimal geodesic, its length is smaller than or equal to that

[Page 375]

of any curve joining p to q. Thus, for every variation of γ we should have L′(0) = 0 and L′′(0) ≥ 0. We obtained therefore a contradiction, which shows that l = d(p,q) ≤ π/√δ, as we asserted.

Since d(p,q) ≤ π/√δ for any two given points of S, we have that S is bounded and that its diameter p ≤ π/√δ. Moreover, since S is complete and bounded, S is compact. Q.E.D.

Remark 5. ThechoiceofthevariationV (s) = w(s)sin(π/l)s intheabove proof may be better understood if we look at the second variation in the form (4a) of Remark 4. Since K > π2/l2, we can write

L′′V(0) = −? l

0

?V,

D2V ds2 +

π2 l2

V ?ds −? l

0

?K −

π2 l2 ?|V |2 ds

< −? l

0

?V,

D2V ds2 +

π2 l2

V ? ds.

Now it is easy to guess that the above V (s) makes the last integrand equal to zero; hence, L′′

V(0) < 0.

Remark 6. The hypothesis K ≥ δ > 0 may not be weakened to K > 0. In fact, the paraboloid

{(x,y,z) ∈ R3;z = x2 +y2}

has Gaussian curvature K > 0, is complete, and is not compact. Observe that the curvature of the paraboloid tends toward zero when the distance of the point (x,y) ∈ R2 to the origin (0, 0) becomes arbitrarily large (cf. Remark 8 below).

- Remark 7. The estimate of the diameter ρ ≤ π/√δ given by Bonnet’s

theorem is the best possible, as shown by the example of the unit sphere: K ≡ 1 and ρ = π.

- Remark 8. The ﬁrst proof of the above theorem was obtained by


O. Bonnet, “Sur quelques propriétés des lignes géodésiques,” C.R.Ac. Sc. Paris XL (1850), 1331, and “Note sur les lignes géodésiques,” ibid. XLI (1851), 32. A formulation of the theorem in terms of complete surfaces is found in the article of Hopf-Rinow quoted in the previous section. Actually, it is not necessary that K be bounded away from zero but only that it not approach zero too fast. See E. Calabi, “On Ricci Curvature and Geodesics,” Duke Math. J. 34 (1967), 667–676; or R. Schneider, “Konvexe Flächen mit langsam abnehmender Krümmung,” Archiv der Math. 23 (1972), 650–654 (cf. also Exercise 2 below).

[Page 376]

###### EXERCISES

1. Is the converse of Bonnet’s theorem true; i.e., if S is compact and has

diameter ρ ≤ π/√δ, is K ≥ δ?

*2. (Kazdan-Warner’s Remark. cf. Exercise 10, Sec. 5-10.) Let S = {z = f (x,y); (x,y) ∈ R2} be a complete noncompact regular surface. Show that

lim

r→∞

( inf

x2+y2≥r

K(x,y)) ≤ 0.

- 3. a. Derive a formula for the ﬁrst variation of arc length without assuming that the variation is proper.

- b. Let S be a complete surface. Let γ(s), s ∈ R, be a geodesic on S and let d(s) be the distance d(γ(s),p) from γ(s) to a point p ∈ S not in the trace of γ. Show that there exists a point s0 ∈ R such that d(s0) ≤ d(s) for all s ∈ R and that the geodesic Ŵ joining p to γ(s0) is perpendicular to γ (Fig. 5-14).

p Γ

γ(s)

γ(s0)

Figure 5-14

- c. Assume further that S is homeomorphic to a plane and has Gaussian curvature K ≤ 0. Prove that s0 (hence, Ŵ) is unique.


- 4. (Calculus of Variations.) Geodesics are particular cases of solutions to variational problems. In this exercise, we shall discuss some points of a simple, although quite representative, variational problem. In the next exercise we shall make some applications of the ideas presented here.


Let y = y(x), x ∈ [x1,x2] be a differentiable curve in the xy plane and let a variation of y be given by a differentiable map y = y(x,t), t ∈ (−ǫ,ǫ). Here y(x,0) = y(x) for all x ∈ [x1,x2], and y(x1,t) = y(x1),y(x2,t) = y(x2) for all t ∈ (−ǫ,ǫ) (i.e., the end points of the variation are ﬁxed). Consider the integral

[Page 377]

I(t) = ? x

2

x1

F(x,y(x,t),y′(x,t))dx, t ∈ (−ǫ,ǫ),

where F(x,y,y′) is a differentiable function of three variables and y′ = ∂y/∂x. The problem of ﬁnding the critical points of I(t) is called a variational problem with integrand F.

- a. Assume that the curve y = y(x) is a critical point of I(t) (i.e., dI/dt = 0 for t = 0). Use integration by parts to conclude that (I˙ = dI/dt)

I(t)˙ = ? x

2

x1

?Fy

∂y ∂t +Fy′

∂y′ ∂t ?dx

= ?

∂y ∂t

Fy′?x

2

x1

+? x

2

x1

∂y ∂t ?Fy −

d dx

Fy′?dx.

Then, by using the boundary conditions, obtain

0 = I(˙ 0) = ? x

2

x1

?η ?Fy −

d dx

Fy′??dx, (∗)

where η = (∂y/∂t)(x,0). (The function η corresponds to the variational vector ﬁeld or y(x,t).)

- b. Prove that if I(˙ 0) = 0 for all variations with ﬁxed end points (i.e., for all η in (∗) with η(x1) = η(x2) = 0), then

Fy −

d dx

Fy′ = 0. (∗∗)

Equation(∗∗)iscalledtheEuler-Lagrangeequationforthevariational problem with integrand F.

- c. Show that if F does not involve explicitly the variable x, i.e., F =


F(y,y′), then, by differentiating y′Fy′ −F, and using (∗∗) we obtain that

y′Fy′ −F = const.

- 5. (Calculus of Variations; Applications.)


- a. (Surfaces of Revolution of LeastArea.) Let S be a surface of revolution


obtained by rotating the curve y = f (x), x ∈ [x1,x2], about the x axis. Suppose that S has least area among all surfaces of revolution generatedbycurvesjoining(x1,f(x1))to(x2,f(x2)). Thus, y = f (x) minimizes the integral (cf. Exercise 11, Sec. 2-5)

[Page 378]

I(t) = ? x

2

x1

y

?

1+(y′)2 dx

forallvariationsy(x,t)ofy withﬁxedendpoints y(x1), y(x2). Bypart

- b of Exercise 4, F(y,y′) = y


?

1+(y′)2 satisﬁes the Euler-Lagrange equation (∗∗). Use part c of Exercise 4 to obtain that

y′Fy′ −F = −

y ?

1+(y′)2

= −

1 c

, c = const.;

hence,

y =

1 c

cosh(cx +c1), c1 = const.

Conclude that if there exists a regular surface of revolution of least area connecting two given parallel circles, this surface is the catenoid which contains the two given circles as parallels.

b. (Geodesics of Surfaces of Revolution.) Let x(u,v) = (f(v)cosu,f(v)sin u,g(v))

be a parametrization of a surface of revolution S. Let u = u(v) be the equation of a geodesic of S which is neither a parallel nor a meridian. Then u = u(v) is a critical point for the arc length integral (F = 0)

? ?

E(u′)2 +Gdv, u′ =

du dv

.

Since E = f2, G = (f ′)2 +(g′)2, we see that the Euler-Lagrange equation for this variational problem is

Fu −

d dv

Fu′ = 0, F = ?

f 2(u′)2 +(f′)2 +(g′)2.

Notice that F does not depend on u. Thus, (d/dv)Fu′ = 0, and

c = const. = Fu′ =

u′f 2 ?

f 2(u′)2 +(f′)2 +(g′)2

.

From this, obtain the following equation for the geodesic u = u(v) (cf. Example 5, Sec. 4-4):

u = c ?

1 f

?

(f ′)2 +(g′)2 f 2 −c2

dv +const.

[Page 379]

###### 5-5. Jacobi Fields and Conjugate Points

In this section we shall explore some details of the variational techniques which were used to prove Bonnet’s theorem.

We are interested in obtaining information on the behavior of geodesics neighboring a given geodesic γ. The natural way to proceed is to consider variations of γ which satisfy the further condition that the curves of the variation are themselves geodesics. The variational ﬁeld of such a variation gives an idea of how densely the geodesics are distributed in a neighborhood of γ.

To simplify the exposition we shall assume that the surfaces are complete, although this assumption may be dropped with further work. The notation γ: [0,l] → S will denote a geodesic parametrized by arc length on the complete surface S.

DEFINITION 1. Let γ: [0,l] → S be a parametrized geodesic on S and let h: [0,l]×(−ǫ,ǫ) → S be a variation of γ such that for every t ∈ (−ǫ,ǫ) the curve ht(s) = h(s,t), s ∈ [0,l], is a parametrized geodesic (not necessarily parametrized by arc length). The variational ﬁeld (∂h/∂t)(s,0) = J(s) is called a Jacobi ﬁeld along γ.

A trivial example of a Jacobi ﬁeld is given by the ﬁeld γ′(s), s ∈ [0,l], of tangent vectors to the geodesic γ. In fact, by taking h(s,t) = γ(s +t), we have

J(s) =

∂h ∂t

(s,0) =

dγ ds

.

We are particularly interested in studying the behavior of the geodesics neighboring γ: [0,l] → S, which start from γ(0). Thus, we shall consider variations h: [0,l]×(−ǫ,ǫ) → S that satisfy the condition h(0,t) = γ(0), t ∈ (−ǫ,ǫ). Therefore, the corresponding Jacobi ﬁeld satisﬁes the condition J(0) = 0 (see Fig. 5-15).

γ

S

Geodesics

J(s)

p

###### Figure 5-15

[Page 380]

Before presenting a nontrivial example of a Jacobi ﬁeld, we shall prove that such a ﬁeld may be characterized by an analytical condition.

PROPOSITION 1. Let J(s) be a Jacobi ﬁeld along γ: [0,l] → S, s ∈ [0,l]. Then J satisﬁes the so-called Jacobi equation

D ds

D ds

J(s)+K(s)(γ′(s)∧J(s))∧γ′(s) = 0, (1) where K(s) is the Gaussian curvature of S at γ(s).

Proof. By the deﬁnition of J(s), there exists a variation h: [0,l]×(−ǫ,ǫ) → S

of γ such that (∂h/∂t)(s,0) = J(s) and ht(s) is a geodesic, t ∈ (−ǫ,ǫ). It follows that (D/∂s)(∂h/∂s)(s,t) = 0. Therefore,

D ∂t

D ∂s

∂h ∂s

(s,t) = 0, (s,t) ∈ [0,l]×(−ǫ,ǫ). On the other hand, by using Lemma 6 of Sec. 5-4 we have

D ∂t

D ∂s

∂h ∂s =

D ∂s

D ∂t

∂h ∂s +K(s,t)?

∂h ∂s ∧

∂h ∂t ?∧

∂h ∂s = 0.

Since (D/∂t)(∂h/∂s) = (D/∂s)(∂h/∂t), we have, for t = 0,

D ∂s

D ∂s

J(s)+K(s)(γ′(s)∧J(s))∧γ′(s) = 0. Q.E.D.

To draw some consequences from Prop. 1, it is convenient to put the Jacobi equation (1) in a more familiar form. For that, let e1(0) and e2(0) be unit orthogonal vectors in the tangent plane Tγ(0)(S) and let e1(s) and e2(s) be the parallel transport of e1(0) and e2(0), respectively, along γ(s).

Assume that

J(s) = a1(s)e1(s)+a2(s)e2(s)

for some functions a1 = a1(s), a2 = a2(s). Then, by using Lemma 2 of the last section and omitting s for notational simplicity, we obtain

D ∂s

J = a1′e1 +a2′e2,

D ∂s

D ∂s

J = a1′′e1 +a2′′e2. On the other hand, if we write

(γ′ ∧J)∧γ′ = λ1e1 +λ2e2,

[Page 381]

we have

λ1e1 +λ2e2 = (γ′ ∧(a1e1 +a2e2))∧γ′

= a1(γ′ ∧e1)∧γ′ +a2(γ′ ∧e2)∧γ′. Therefore, by setting ?(γ′ ∧ei)∧γ′,ej? = αij, i,j = 1,2, we obtain

λ1 = a1α11 +a2α21, λ2 = a1α12 +a2α22. It follows that Eq. (1) may be written

a1′′ +K(α11a1 +α21a2) = 0, a2′′ +K(α12a1 +α22a2) = 0,

###### (1a)

where all the elements are functions of s. Note that (1a) is a system of linear, second-order differential equations. The solutions (a1(s),a2(s)) = J(s) of such a system are deﬁned for every s ∈ [0,l] and constitute a vector space. Moreover, a solution J(s) of (1a) (or (1)) is completely determined by the initial conditions J(0),(DJ/∂s)(0), and the space of the solutions has 2×2 = 4 dimensions.

One can show that every vector ﬁeld J(s) along a geodesic γ: [0,l] → S which satisﬁes Eq. (1) is, in fact, a Jacobi ﬁeld. Since we are interested only in Jacobi ﬁelds J(s) which satisfy the condition J(0) = 0, we shall prove the proposition only for this particular case.

We shall use the following notation. Let Tp(S), p ∈ S, be the tangent plane to S at point p, and denote by (Tp(S))v the tangent space at v of Tp(S) considered as a surface in R3. Since expp: Tp(S) → S,

d(expp)v: (Tp(S))v → Texpp(v)(S).

We shall frequently make the following notational abuse: If v, w ∈ Tp(S), then w denotes also the vector of (Tp(S))v obtained from w by a translation of vector v (see Fig. 5-16). This is equivalent to identifying the spaces Tp(S) and (Tp(S))v by the translation of vector v.

LEMMA 1. Let p ∈ S and choose v,w ∈ Tp(S), with |v| = 1. Let γ: [0,l] → S be the geodesic on S given by

γ(s) = expp(sv), s ∈ [0,l]. Then, the vector ﬁeld J(s) along γ given by

J(s) = s(d expp)sv(w), s ∈ (0,l], is a Jacobi ﬁeld. Furthermore, J(0) = 0, (DJ/ds)(0) = w.

[Page 382]

w

0

P

γ

S

w

v

expp(v)

expp

TpS

(d expp)v

(d expp)v(w)

###### Figure 5-16

Proof. Let t → v(t), t ∈ (−ǫ,ǫ), be a parametrized curve in Tp(S) such thatv(0) = v and(dv/dt)(0) = w. (Observethatwearemakingthenotational abuse mentioned above.) Deﬁne (see Fig. 5-17)

h(s,t) = expp(sv(t)), t ∈ (−ǫ,ǫ),s ∈ [0,l]. The mapping h is obviously differentiable, and the curves s → ht(s) =

h(s,t) are the geodesics s → expp(sv(t)). Therefore, the variational ﬁeld of h is a Jacobi ﬁeld along γ.

To compute the variational ﬁeld (∂h/∂t)(s,0), observe that the curve of Tp(S), s = s0, t = t, is given by t → s0v(t) and that the tangent vector to this curve at the point t = 0 is

s0

dv dt

(0) = s0w. It follows that

∂h ∂t

(s,0) = (d expp)sv(sw) = s(d expp)sv(w).

The vector ﬁeld J(s) = s(d expp)sv(w) is, therefore, a Jacobi ﬁeld. It is immediate to check that J(0) = 0. To verify the last assertion of the lemma, we compute the covariant derivative of the above expression (cf. Lemma 2, Sec. 5-4), obtaining

[Page 383]

w

0

w = v´(0)

v(0) = v

v(t)

sv(t)

Tp(S)

expp

P

S

γ

###### Figure 5-17

D ∂s

s(d expp)sv(w) = (d expp)sv(w)+s

D ∂s

(d expp)sv(w). Hence, at s = 0,

DJ ∂s

(0) = (d expp)0(w) = w. Q.E.D.

PROPOSITION 2. If we let J(s) be a differentiable vector ﬁeld along γ: [0,l] → S, s ∈ [0,l], satisfying the Jacobi equation (1), with J(0) = 0, then J(s) is a Jacobi ﬁeld along γ.

Proof. Let w = (DJ/ds)(0) and v = γ′(0). By Lemma 1, there exists a Jacobi ﬁeld s(d expp)sv(w) = J(s)¯ , s ∈ [0,l], satisfying

J(¯ 0) = 0,?

DJ¯ ds ?(0) = w.

Then, J and J¯ are two vector ﬁelds satisfying the system (1) with the same initial conditions. By uniqueness, J(s) = J(s)¯ , s ∈ [0,l]; hence, J is a Jacobi ﬁeld. Q.E.D.

We are now in a position to present a nontrivial example of a Jacobi ﬁeld. Example. Let S2 = {(x,y,z) ∈ R3;x2 +y2 +z2 = 1} be the unit sphere

and x(θ,ϕ) be a parametrization at p ∈ S, by the colatitude θ and the longitude ϕ (Sec. 2-2, Example 1). Consider on the parallel θ = π/2 the segment between ϕ0 = π/2 and ϕ1 = 3π/2. This segment is a geodesic γ, which we

[Page 384]

Figure 5-18. A Jacobi ﬁeld on a sphere.

assume to be parametrized by ϕ −ϕ0 = s. Let w(s) be the parallel transport along γ of a vector w(0) ∈ Tγ(0)(S), with |w(0)| = 1 and ?w(0),γ′(0)? = 0. We shall prove that the vector ﬁeld (see Fig. 5-18)

J(s) = (sin s)w(s), s ∈ [0,π], is a Jacobi ﬁeld along γ.

In fact, since J(0) = 0, it sufﬁces to verify that J satisﬁes Eq. (1). By using the fact that K = 1 and w is a parallel ﬁeld we obtain, sucessively,

DJ ds = (coss)w(s),

D ds

DJ ds = (−sin s)w(s),

D ds

DJ ds +K(γ′ ∧J)∧γ′ = (−sin s)w(s)+(sin s)w(s) = 0,

which shows that J is a Jacobi ﬁeld. Observe that J(π) = 0.

DEFINITION 2. Let γ: [0,l] → S be a geodesic of S with γ(0) = p. We say that the point q = γ(s0), s0 ∈ [0,l], is conjugate to p relative to the geodesic γ if there exists a Jacobi ﬁeld J(s) which is not identically zero along γ with J(0) = J(s0) = 0.

As we saw in the previous example, given a point p ∈ S2 of a unit sphere S2, its antipodal point is conjugate to p along any geodesic that starts from p. However, theexampleofthesphereisnottypical. Ingeneral, givenapointp of a surface S, the “ﬁrst” conjugate point q to p varies as we change the direction of the geodesic passing through p and describes a parametrized curve. The trace of such a curve is called the conjugate locus to p and is denoted by C(p).

[Page 385]

p

C(p)

Figure 5-19. The conjugate locus of an ellipsoid.

Figure 5-19 shows the situation for the ellipsoid, which is typical. The geodesics starting from a point p are tangent to the curve C(p) in such a way that when a geodesic γ¯ near γ approaches γ, then the intersection point of γ¯ and γ approaches the conjugate point q of p relative to γ. This situation was expressed in classical terminology by saying that the conjugate point is the point of intersection of two “inﬁnitely close” geodesics.

- Remark 1. The fact that, in the sphere S2, the conjugate locus of each point p ∈ S2 reduces to a single point (the antipodal point of p) is an exceptional situation. In fact, it can be proved that the sphere is the only such surface (cf. L. Green, “Aufwiedersehenﬂäche,” Ann. Math. 78 (1963), 289–300).
- Remark 2. The conjugate locus of the general ellipsoid was determined by A. Braunmühl, “Geodätische Linien auf dreiachsigen Flächen zweiten Grades,” Math. Ann. 20 (1882), 557–586. Compare also H. Mangoldt, “Geodätische Linien auf positiv gekrümmten Flächen,” Crelles Journ. 91 (1881), 23–52.


A useful property of Jacobi ﬁelds J along γ: [0,l] → S is the fact that when J(0) = J(l) = 0, then

?J(s),γ′(s)? = 0

for every s ∈ [0,l].Actually, this is a consequence of the following properties of Jacobi ﬁelds.

PROPOSITION 3. Let J1(s) and J2(s) be Jacobi ﬁelds along γ: [0,l] → S, s ∈ [0,l]. Then

?

DJ1 ds

,J2(s)?−?J1(s),

DJ2 ds ? = const.

[Page 386]

Proof. It sufﬁces to differentiate the expression of the statement and apply Prop. 1 (s is omitted for notational convenience):

d ds ??

DJ1 ds

,J2?−?J1,

DJ2 ds ??

= ?

D ds

DJ1 ds

,J2?−?J1,

D ds

DJ2 ds ?+?

DJ1 ds

,

DJ2 ds ?−?

DJ1 ds

,

DJ2 ds ?

= −K{?γ′ ∧J1)∧γ′,J2?−?(γ′ ∧J2)∧γ′,J1?} = 0. Q.E.D. PROPOSITION 4. Let J(s) be a Jacobi ﬁeld along γ: [0,l] → S, with

?J(s1),γ′(s1)? = ?J(s2),γ′(s2)? = 0, s1,s2 ∈ [0,l],s1 ?= s2. Then

?J(s),γ′(s)? = 0, s ∈ [0,l].

Proof. We set J1(s) = J(s) and J2(s) = γ′(s) (which is a Jacobi ﬁeld) in the previous proposition and obtain

?

DJ ds

,γ′(s)? = const. = A.

Therefore,

d ds?J(s),γ′(s)? = ?

DJ ds

,γ′(s)? = A;

hence,

?J(s),γ′(s)? = As +B, where B is a constant. Since the linear expression As +B is zero for s1,

- s2 ∈ [0,l], s1 ?= s2, it is identically zero. Q.E.D.


COROLLARY. Let J(s) be a Jacobi ﬁeld along γ: [0,l] → S, with J(0) = J(l) = 0. Then ?J(s),γ′(s)? = 0, s ∈ [0,l].

We shall now show that the conjugate points may be characterized by the behavior of the exponential map. Recall that when ϕ: S1 → S2 is a differentiable mapping of the regular surface S1 into the regular surface S2, a point p ∈ S1 is said to be a critical point of ϕ if the linear map

dϕp: Tp(S1) → Tϕ(p)(S2) is singular, that is, if there exists v ∈ Tp(S1), v ?= 0, with dϕp(v) = 0.

PROPOSITION 5. Let p, q ∈ S be two points of S and let γ: [0,l] → S be a geodesic joining p = γ(0) to q = expp(lγ′(0)). Then q is conjugate

[Page 387]

to p relative to γ if and only if v = lγ′(0) is a critical point of expp: Tp(S) → S.

Proof. As we saw in Lemma 1, for every w ∈ Tp(S) (which we identify with (Tp(S))v) there exists a Jacobi ﬁeld J(s) along γ with

J(0) = 0,

DJ ds

(0) = w and J(l) = l{(d expp)v(w)}.

If v ∈ Tp(S) is a critical point of expp, there exists w ∈ Tp(S))v, w ?= 0, with (d expp)v(w) = 0. This implies that the above vector ﬁeld J(s) is not identically zero and that J(0) = J(l) = 0; that is, γ(l) is conjugate to γ(0) relative to γ.

Conversely, if q = γ(l) is conjugate to p = γ(0) relative to γ, there exists a Jacobi ﬁeld J(s)¯ , not identically zero, with J(¯ 0) = J(l)¯ = 0. Let (DJ/¯ ds)(0) = w ?= 0. ByconstructingaJacobiﬁeldJ(s)asabove, weobtain, by uniqueness, J(s)¯ = J(s). Since

J(l) = l{(d expp)v(w)} = J(l)¯ = 0,

we conclude that (d expp)v(w) = 0, with w ?= 0. Therefore v is a critical point of expp. Q.E.D.

The fact that Eq. (1) of Jacobi ﬁelds involves the Gaussian curvature K of S is an indication that the “spreading out” of the geodesics which start from a point p ∈ S is closely related to the distribution of the curvature in S (cf. Remark 2, Sec. 4-6). It is an elementary fact that two neighboring geodesics starting from a point p ∈ S initially pull apart. In the case of a sphere or an ellipsoid (K > δ > 0) they reapproach each other and become tangent to the conjugate locus C(p). In the case of a plane they never get closer again. The following theorem shows that an “inﬁnitesimal version” of the situation for the plane occurs in surfaces of negative or zero curvature. (See Remark 3 after the proof of the theorem.)

THEOREM 1. Assume that the Gaussian curvature K of a surface S satisﬁes the condition K ≤ 0. Then, for every p ∈ S, the conjugate locus of p is empty. In short, a surface of curvature K ≤ 0 does not have conjugate points.

Proof. Let p ∈ S and let γ: [0,l] → S be a geodesic of S with γ(0) = p. Assume that there exists a nonvanishing Jacobi ﬁeld J(s), with J(0) = J(l) = 0. We shall prove that this gives a contradiction.

[Page 388]

In fact, since J(s) is a Jacobi ﬁeld and J(0) = J(l) = 0, we have, by the corollary of Prop. 4, that ?J(s),γ′(s)? = 0, s ∈ [0,l]. Therefore,

D ds

DJ ds +KJ = 0,

?

D ds

DJ ds

,J? = −K?J,J? ≥ 0, since K ≤ 0.

It follows that d ds ?

DJ ds

,J? = ?

D ds

DJ ds

,J?+?

DJ ds

,

DJ ds ? ≥ 0.

Therefore, the function ?DJ/ds,J? does not decrease in the interval [0,l]. Since this function is zero for s = 0 and s = l, we conclude that

?

DJ ds

,J(s)? = 0, s ∈ [0,l]. Finally, by observing that

d ds?J,J? = 2?

DJ ds

,J? = 0,

wehave|J|2 = const. SinceJ(0) = 0, weconcludethat|J(s)| = 0, s ∈ [0,l]; that is, J is identically zero in [0,l]. This is a contradiction. Q.E.D.

Remark 3. The theorem does not assert that two geodesics starting from a given point will never meet again. Actually, this is false, as shown by the closed geodesics of a cylinder, the curvature of which is zero. The assertion is not true even if we consider geodesics that start from a given point with “nearby directions.” It sufﬁces to consider a meridian of the cylinder and to observe that the helices that follow directions nearby that of the meridian meet this meridian. What the proposition asserts is that the intersection point of two “neighboring” geodesics goes to “inﬁnity” as these geodesics approach each other (this is precisely what occurs in the cylinder). In a classical terminology we can say that two "inﬁnitely close" geodesics never meet. In this sense, the theorem is an inﬁnitesimal version of the situation for the plane.

An immediate consequence of Prop. 5, the above theorem, and the inverse function theorem is the following corollary.

COROLLARY. Assume the Gaussian curvature K of S to be negative or zero. Then for every p ∈ S, the mapping

expp: Tp(s) → S is a local diffeomorphism.

[Page 389]

We shall use later the following lemma, which generalizes the fact that, in a normal neighborhood of p, the geodesic circles are orthogonal to the radial geodesics (Sec. 4-6, Prop. 3 and Remark 1).

LEMMA 2 (Gauss). Let p ∈ S be a point of a (complete) surface S and let u ∈ Tp(S) and w ∈ (Tp(S))u. Then

?u,w? = ?(d expp)u(u),(d expp)u(w)?, where the identiﬁcation Tp(S) ≈ (Tp(S))u is being used.

Proof. Let l = |u|, v = u/|u| and let γ: [0,l] → S be a geodesic of S given by

γ(s) = expp(sv), s ∈ [0,l].

Then γ′(0) = v. Furthermore, if we consider the curves s → sv in Tp(S) which passes through u for s = l with tangent vector v (see Fig. 5-20), we obtain

γ′(l) =

d ds

(expp sv)?

s=l

= (d expp)u(v).

w

v u

p

γ

0

expp

(d expp)u(w)

(d expp)u(v)

###### Figure 5-20

Consider now a Jacobi ﬁeld J along γ, given by J(0)=0, (DJ/ds)(0)=w (cf. Lemma 1). Then, since γ(s) is a geodesic,

d ds?γ′(s),J(s)? = ?γ′(s),

DJ ds ?,

and since J is a Jacobi ﬁeld,

d ds ?γ′(s),

DJ ds ? = ?γ′(s),

D2J ds2 ? = 0.

[Page 390]

It follows that

d ds?γ′(s),J(s)? = ?γ′(s),

DJ

ds ? = const. = C; (2) hence (since J(0) = 0)

?γ′(s),J(s)? = Cs. (3) To compute the constant C, sets equal to l in Eq. (3). By Lemma 1,

J(l) = l(d expp)u(w). Therefore,

Cl = ?γ′(l),J(l)? = ?(d expp)u(v),l(d expp)u(w)?. From Eq. (2) we conclude that

?γ′(l),

DJ ds

(l)? = C = ?γ′(0),

DJ ds

(0)? = ?v,w?.

By using the value of C, we obtain from the above expression ?u,w? = ?(d expp)u(u),(d expp)u(w)?. Q.E.D.

###### EXERCISES

- 1. a. Let γ: [0,l] → S be a geodesic parametrized by arc length on a surface S and let J(s) be a Jacobi ﬁeld along γ with J(0) = 0, ?J′(0),γ′(0)? = 0. Prove that ?J(s),γ′(s)? = 0 for all s ∈ [0,l].

b. Assume further that |J′(0)| = 1. Take the parallel transport of e1(0) = γ′(0) and of e2(0) = J′(0) along γ and obtain orthonormal bases {e1(s),e2(s)} for all Tγ(s)(S), s ∈ [0,l]. By part a, J(s) = u(s)e2(s) for some function u = u(s). Show that the Jacobi equation for J can be written as

u′′(s)+K(s)u(s) = 0, with initial conditions u(0) = 0, u′(0) = 1.

- 2. Show that the point p = (0,0,0) of the paraboloid z = x2 +y2 has no conjugate point relative to a geodesic γ(s) with γ(0) = p.
- 3. (TheComparisonTheorems.) LetS andS˜ becompletesurfaces. Letp ∈ S,


p˜ ∈ S˜ andchoosealinearisometryi:Tp(S) → Tp˜(S)˜ . Letγ:[0,∞) → S be a geodesic on S with γ(0) = p, |γ′(0)| = 1, and let J(s) be a Jacobi ﬁeld along γ with J(0) = 0, ?J′(0),γ′(0)? = 0, |J′(0)| = 1. By using

[Page 391]

s

p

i

J

Tp(S)

J΄(0)

|J΄(0)<br><br>S<br><br>p<br><br>T~p(S)<br><br>~<br><br>~<br><br>~|
|---|


γ΄(0)

γ

J γ

~

~

###### Figure 5-21

the linear isometry i, construct a geodesic γ˜: [0,∞) → S˜ with γ(˜ 0) = p˜, γ˜′(0) = i(γ′(0)), and a Jacobi ﬁeld J˜ along γ˜ with J(˜ 0) = 0, J˜′(0) = i(J′(0)) (Fig. 5-21). Below we shall describe two theorems (which are essentially geometric interpretations of the classical Sturm comparison theorems) that allow us to compare the Jacobi ﬁelds J and J˜ from a “comparison hypothesis” on the curvatures of S and S˜.

a. Use Exercise 1 to show that J(s) = v(s)e2(s), J(s)˜ = u(s)e˜2(s), where u = u(s), v = v(s) are differentiable functions, and e2(s) (respectively, e˜2(s)) is the parallel transport along γ (respectively, γ˜) of J′(0) (respectively, J˜′(0)). Conclude that the Jacobi equations for J and J˜ are

v′′(s)+K(s)v(s) = 0, v(0) = 0,v′(0) = 1, u′′(s)+K(s)u(s) = 0, u(0) = 0,u′(0) = 1,

respectively, where K and K˜ denote the Gaussian curvatures of S and S˜.

- *b. Assume that K(s) ≤ K(s)˜ , s ∈ [0,∞]. Show that


0 = ? s

0

{u(v′′ +Kv)−v(u′′ +Ku)˜ }ds

= [uv′ −vu′]s0 +? s

0

(K −K)uv˜ ds.

###### (∗)

[Page 392]

Conclude that if a is the ﬁrst zero of u in (0,∞) (i.e., u(a) = 0 and u(s) > 0 in (0,a)) and b is the ﬁrst zero of v in (0,∞), then b ≥ a. Thus, if K(s) ≤ K˜ (s) for all s, the ﬁrst conjugate point of p relative to γ does not occur before the ﬁrst conjugate point of p˜ relative to γ˜. This is called the ﬁrst comparison theorem.

- *c. Assume that K(s) ≤ K(s)˜ , s ∈ [0,a). Use (∗) and the fact that u and v


arepositivein(0,a)toobtainthat[uv′ −vu′]s0 ≥ 0. Usethisinequality to show that v(s) ≥ u(s) for all s ∈ (0,a). Thus, if K(s) ≤ K˜ (s) for all s before the ﬁrst conjugate point of γ˜, then |J(s)| ≥ |J˜(s)| for all such s. This is called the second comparison theorem (of course, this includes the ﬁrst one as a particular case; we have separated the ﬁrst case because it is easier and because it is the one that we use more often).

d. Prove that in part c the equality v(s) = u(s) holds for all s ∈ [0,a) if

and only if K(s) = K(s)˜ , s ∈ [0,a).

- 4. Let S be a complete surface with Gaussian curvature K ≤ K0, where K0 is a positive constant. Compare S with a sphere S2(K0) with curvature K0 (that is, set, in Exercise 3, S˜ = S2(K0) and use the ﬁrst comparison theorem, Exercise 3, part b) to conclude that any geodesic γ: [0,∞) → S on S has no point conjugate to γ(0) in the interval (0,π/√K0).

- 5. Let S be a complete surface with K ≥ K1 > 0, where K is the Gaussian curvature of S and K1 is a constant. Prove that every geodesic γ: [0,∞) → S has a point conjugate to γ(0) in the interval (0,π/√K1].


*6. (Sturm’s Oscillation Theorem.) The following slight generalization of the ﬁrst comparison theorem (Exercise 3, part b) is often useful. Let S be a complete surface and γ: [0,∞) → S be a geodesic in S. Let J(s) be a Jacobi ﬁeld along γ with J(0) = J(s0) = 0, s0 ∈ (0,∞) and J(s) ?= 0, fors ∈ (0,s0).Thus, J(s)isanormalﬁeld(corollaryofProp.4). Itfollows that J(s) = v(s)e2(s), where v(s) is a solution of

v′′(s)+K(s)v(s) = 0, s ∈ [0,∞),

and e2(s) is the parallel transport of a unit vector at Tγ(0)(S) normal to γ′(0). Assume that the Gaussian curvature K(s) of S satisﬁes K(s) ≤ L(s), where L is a differentiable function on [0,∞). Prove that any solution of

u′′(s)+L(s)u(s) = 0, s ∈ [0,∞),

has a zero in the interval (0,s0] (i.e., there exists s1 ∈ (0,s0] with u(s1) = 0).

7. (Kneser Criterion for Conjugate Points.) Let S be a complete surface and let γ: [0,∞) → S be a geodesic on S with γ(0) = p. Let K(s) be the Gaussian curvature of S along γ. Assume that

[Page 393]

? ∞

t

K(s)ds ≤

1 4(t +1)

for all t ≥ 0 (∗)

in the sense that the integral converges and is bounded as indicated.

- a. Deﬁne

w(t) = ? ∞

t

K(s)ds +

1 4(t +1)

, t ≥ 0,

and show that w′(t)+(w(t))2 ≤ −K(t).

- b. Set, for t ≥ 0, w′(t)+(w(t))2 = −L(t) (so that L(t) ≥ K(t)) and deﬁne

v(t) = exp?? t

0

w(s)ds?, t ≥ 0.

Show that v′′(t)+L(t)v(t) = 0, v(0) = 1, v′(0) = 0.

- c. Notice that v(t) > 0 and use the Sturm oscillation theorem (Exercise 6) to show that there is no Jacobi ﬁeld J(s) along γ(s) with


J(0) = 0 and J(s0) = 0, s0 ∈ (0,∞). Thus, if (∗) holds, there is no point conjugate to p along γ.

*8. Let γ: [0,l] → S be a geodesic on a complete surface S, and assume that γ(l) is not conjugate to γ(0). Let w0 ∈ Tγ(0)(S) and w1 ∈ Tγ(l)(S). Prove that there exists a unique Jacobi ﬁeld J(s) along γ with J(0) = w0, J(l) = w1.

9. Let J(s) be a Jacobi ﬁeld along a geodesic γ: [0,l] → S such that ?J(0),γ′(0)? = 0 and J′(0) = 0. Prove that ?J(s),γ′(s)? = 0 for all s ∈ [0,l].

###### 5-6. Covering Spaces;The Theorems of Hadamard

We saw in the last section that when the curvature K of a complete surface S satisﬁes the condition K ≤ 0 then the mapping expp : Tp(S) → S, p ∈ S, is a local diffeomorphism. It is natural to ask when this local diffeomorphism is a global diffeomorphism. It is convenient to put this question in a more general setting for which we need the notion of covering space.

###### A. Covering Spaces

DEFINITION 1. Let B˜ and B be subsets of R3. We say that π: B˜ → B is a covering map if

- 1. π is continuous and π(B˜) = B.


[Page 394]

- 2. Each point p ∈ B has a neighborhood U in B (to be called a distinguished neighborhood of p) such that


π−1(U) = ?

α

Vα,

where the Vα’s are pairwise disjoint open sets such that the restriction of π to Vα is a homeomorphism of Vα onto U.

B˜ is then called a covering space of B. Example 1. Let P ⊂ R3 be a plane of R3. By ﬁxing a point q0 ∈ P and

two orthogonal unit vectors e1, e2 ∈ P, with origin in q0, every point q ∈ P is characterized by coordinates (u,v) = q given by

q −u0 = ue1 +ve2.

NowletS = {(x,y,z) ∈ R3;x2 +y2 = 1}betherightcircularcylinderwhose axis is the z axis, and let π: P → S be the map deﬁned by

π(u,v) = (cosu,sin u,v)

(the geometric meaning of this map is to wrap t he plane P around the cylinder S an inﬁnite number of times; see Fig. 5-22).

u0– π u0 u0+ π

r

p

(u0,v0)

###### Figure 5-22

We shall prove that π is a covering map. We ﬁrst observe that when (u0,v0) ∈ P, the mapping π restricted to the band

R = {(u,v) ∈ P;u0 −π ≤ u ≤ u0 +π}

covers S entirely.Actually, π restricted to the interior of R is a parametrization of S, the coordinate neighborhood of which covers S minus a generator. It follows that π is continuous (actually, differentiable) and that π(P) = S, thus verifying condition 1.

[Page 395]

To verify condition 2, let p ∈ S and U = S −r, where r is the generator opposite to the generator passing through p. We shall prove that U is a distinguished neighborhood of p.

Let (u0,v0) ∈ P be such that π(u0,v0) = p and choose for Vn the band given by

Vn = {(u,v) ∈ P;u0 +(2n−1)π < u < u0 +(2n+1)π}, n = 0,±1,±2,....

It is immediate to verify that if n ?= m, then Vn ∩Vm = φ and that

?

n Vn = π−1(U). Moreover, by the initial observation, π restricted to any Vn is a homeomorphism onto U. It follows that U is a distinguished neighborhood of

- p. This veriﬁes condition 2 and shows that the plane P is a covering space of the cylinder S.

Example 2. Let H be the helix

H = {(x,y,z) ⊂ R3;x = cost,y = sin t;z = bt,t ∈ R} and let

S1 = {(x,y,0) ∈ R3;x2 +y2 = 1} be a unit circle. Let π: H → S1 be deﬁned by

π(x,y,z) = (x,y,0). We shall prove that π is a covering map (see Fig. 5-23).

q

p

π

Figure 5-23

Itisclearthatπ iscontinuousandthatπ(H) = S1.Thisveriﬁescondition1. To verify condition 2, let p ∈ S1. We shall prove that U = S1 −{q}, where

- q ∈ S1 is the point symmetric to p, is a distinguished neighborhood of p. In fact, let t0 ∈ R be such that


[Page 396]

π(cost0,sin t0,bt0) = p. Let us take for Vn the arc of the helix corresponding to the interval

(t0 +(2n−1)π,t0 +(2n+1)π) ⊂ R, n = 0,±1,±2,.... Then it is easy to show that π−1(U) =

?

n Vn, that the Vn’s are pairwise disjoint, and that π restricted to Vn is a homeomorphism onto U. This veriﬁes condition 2 and concludes the example.

Now, let π: B˜ → B be a covering map. Since π(B)˜ = B, each point p˜ ∈ B˜ is such that p˜ ∈ π−1(p) for some p ∈ B. Therefore, there exists a neighborhood Vα of p˜ such that π restricted to Vα is a homeomorphism. It follows that π is a local homeomorphism. The following example shows, however, that there exist local homeomorphisms which are not covering maps.

Before presenting the example it should be observed that if U is a distinguished neighborhood of p, then every neighborhood U¯ of p such that U¯ ⊂ U is again a distinguished neighborhood of p. Since π−1(U)¯ ⊂

?

α Vα and the Vα are pairwise disjoint, we obtain

π−1(U)¯ = ?

α

Wα,

where the sets Wα = π−1(U)¯ ∩Vα still satisfy the disjointness condition 2 of Def. 1. In this way, when dealing with distinguished neighborhoods, we may restrict ourselves to “small” neighborhoods.

Example 3. Consider in Example 2 a segment H˜ of the helix H corresponding to the interval (π,4π) ⊂ R. It is clear that the restriction π˜ of π to this opensegmentofhelixisstillalocalhomeomorphismandthat π(˜ H)˜ = S1. However, no neighborhood of

π(cos3π,sin 3π,b3π) = (−1,0,0) = p ∈ S1

can be a distinguished neighborhood. In fact, by taking U sufﬁciently small, π˜ −1(U) = V1 ∪V2, where V1 is the segment of helix corresponding to t ∈ (π,π +ǫ) and V2 is the segment corresponding to t ∈ (3π −ǫ,3π +ǫ). Now π˜ restricted to V1 is not a homeomorphism onto U since π(V˜ 1) does not even contain p. It follows that π˜ : H˜ → S is a local homeomorphism onto S1 but not a covering map.

We may now rephrase the question we posed in the beginning of this section in the following more general form: Under what conditions is a local homeomorphism a global homeomorphism?

The notion of covering space allows us to break up this question into two questions as follows:

- 1. Under what conditions is a local homeomorphism a covering map?


[Page 397]

- 2. Under what conditions is a covering map a global homeomorphism? A simple answer to question 1 is given by the following proposition.


PROPOSITION 1. Letπ:B˜ → Bbealocalhomeomorphism, B˜ compact and B connected. Then π is a covering map.

Proof. Since π is a local homeomorphism π(B)˜ ⊂ B is open in B. Moreover, by the continuity of π, π(B)˜ is compact, and hence closed in B. Since π(B)˜ ⊂ B is open and closed in the connected set B, π(B)˜ = B. Thus condition 1 of Def. 1 is veriﬁed.

To verify condition 2, let b ∈ B. Then π−1(b) ⊂ B˜ is ﬁnite. Otherwise, it wouldhavealimitpointq˜ ∈ B˜ whichwouldcontradictthefactthat π:B˜ → B is a local homeomorphism. Therefore, we may write π−1(b) = {b˜1,...,b˜k}.

Let Wi be a neighborhood of b˜i, i = 1,...,k, such that the restriction of π to Wi is a homeomorphism (π is a local homeomorphism). Since π−1(b) is ﬁnite, it is possible to choose the Wi’s sufﬁciently small so that they are pairwise disjoint. Since B˜ is compact and π is continuous the image by π of a closed set in B˜ is a closed set in B. It follows that there exists a neighborhood U of b such that U ⊂

?i

π(Wi) and π−1(U) ⊂ ∪iWi (see Fig. 5-24 and the Proposition in Section E of the appendix to the present chapter). By setting Vi = π−1U ∩Wi, we have that

π−1(U) = ?

i

Vi

and that the Vi’s are pairwise disjoint. Moreover, the restriction of π to Vi is clearly a homeomorphism onto U. It follows that U is a distinguished neighborhoodofp.Thisveriﬁescondition2andconcludestheproof. Q.E.D.

W3

W2

B

W1 π

b3

b2

b1

###### Figure 5-24

[Page 398]

When B˜ is not compact there are few useful criteria for asserting that a local homeomorphism is a covering map. A special case will be treated later. For this special case as well as for a treatment of question 2 we need to return to covering spaces.

Themostimportantpropertyofacoveringmapisthepossibilityof“lifting” into B˜ continuous curves of B. To be more precise we shall introduce the following terminology.

Let B ⊂ R3. Recall that a continuous mapping α: [0,l] → B,[0,l] ⊂ R, is called an arc of B (see the appendix to Chap. 5, Def. 8). Now, let B˜ and B be subsets of R3. Let π: B˜ → B be a continuous map and α: [0,l] → B be an arc of B. If there exists an arc of B˜,

α˜: [0,l] → B,˜

with π ◦α˜ = α, α˜ is said to be a lifting of α with origin in α(˜ 0) ∈ B˜. The situation is described in the accompanying diagram.

B˜

π

?? [0,l] α ??

α˜

??????????

B

With the above terminology a fundamental property of covering spaces is expressed by the following proposition of existence and uniqueness.

PROPOSITION 2. Let π: B˜ → B be a covering map, α: [0,l] → B an arc in B, and p˜0 ∈ B˜ a point of B˜ such that π(p˜0) = α(0) = p0. Then there exists a unique lifting α˜: [0,l] → B˜ of α with origin at p˜0, that is, with α(˜ 0) = p˜0.

Proof. We ﬁrst prove the uniqueness. Let α,˜ β˜: [0,l] → B˜ be two liftings

- of α with origin at p˜0. Let A ⊂ [0,l] be the set of points t ∈ [0,l] such that α(t)˜ = β(t)˜ . A is nonempty and clearly closed in [0,l].


We shall prove that A is open in [0,l]. Suppose that α(t)˜ = β(t)˜ = p˜. Consider a neighborhood V of p˜ in which π is a homeomorphism. Since α˜ and β˜ are continuous maps, there exists an open interval It ⊂ [0,l] containing

- t such that α(I˜ t) ⊂ V and β(I˜ t) ⊂ V . Since π ◦α˜ = π ◦β˜ and π is a homeomorphism in V , α˜ = β˜ in It, and thus A is open. It follows that A = [0,l], and the two liftings coincide for every t ∈ (0,l].


Weshallnowprovetheexistence. Sinceα iscontinuous, foreveryα(t) ∈ B there exists an interval It ⊂ [0,l] containing t such that α(It) is contained in a distinguished neighborhood α(t). The family It, t ∈ [0,l], is an open covering of [0,l] that, by compactness of [0,l], admits a ﬁnite subcovering, say, I0,...,In.

[Page 399]

V0

U0

p

p0

p2○

p1○

π

###### Figure 5-25

Assume that 0 ∈ I0. (If it did not, we would change the enumeration of the intervals.) Since α(I0) is contained in a distinguished neighborhood U0 of p, there exists a neighborhood V0 of p˜0 such that the restriction π0 of π to V0 is a homeomorphism onto U0. We deﬁne, for t ∈ I0 (see Fig. 5-25),

α(t)˜ = π0−1 ◦α(t), where π0−1 is the inverse map in U0 of the homeomorphism π0. It is clear that

α(˜ 0) = p˜0, π ◦α(t)˜ = α(t), t ∈ I0.

Suppose now that I1 ∩I0 ?= φ (otherwise we would change the order of the intervals). Let t1 ∈ I1 ∩I0. Since α(I1) is contained in a distinguished neighborhood U1 of α(t1), we may deﬁne a lifting of α in I1 with origin at α(t˜ 1). By uniqueness, this arc agrees with α˜ in I1 ∩I0, and, therefore, it is an extension of α˜ to I0 ∪I1. Proceeding in this manner, we build an arc α˜[0,l] → B˜ such that α(˜ 0) = p˜0 and π ◦α(t)˜ = α(t), t ∈ [0,l]. Q.E.D.

An interesting consequence of the arc lifting property of a covering map π: B˜ → B is the fact that when B is arcwise connected there exists a one-toone correspondence between the sets π−1(p) and π−1(q), where p and q are two arbitrary points of B. In fact, if B is arcwise connected, there exists an arc α: [0,l] → B, with α(0) = p and α(l) = q. For every p˜ ∈ π−1(p), there is a lifting α˜p: [0,l] → B˜, with α˜p(0) = p˜. Now deﬁne ϕ: π−1(p) → π−1(q) by ϕ(p)˜ = α˜p(l); that is, let ϕ(p)˜ be the extremity of the lifting of α with origin p˜. By the uniqueness of the lifting, ϕ is a one-to-one correspondence as asserted.

It follows that the “number” of points of π−1(p), p ∈ B, does not depend on p when B is arcwise connected. If this number is ﬁnite, it is called the

[Page 400]

number of sheets of the covering. If π−1(p) is not ﬁnite, we say that the covering is inﬁnite. Examples 1 and 2 are inﬁnite coverings. Observe that when B˜ is compact the covering is always ﬁnite.

###### Example 4. Let

S1 = {(x,y) ∈ R2;x = cost,y = sin t,t ∈ R} be the unit circle and deﬁne a map π: S1 → S1 by

π(cost,sin t)−(coskt,sin kt),

where k is a positive integer and t ∈ R. By the inverse function theorem, π is a local diffeomorphism, and hence a local homeomorphism. Since S1 is compact, Prop. l can be applied. Thus, π: S1 → S1 is a covering map.

Geometrically, π wraps the ﬁrst S1 k times onto the second S1. Notice that the inverse image of a point p ∈ S1 contains exactly k points. Thus, π is a k-sheeted covering of S1.

For the treatment of question 2 we also need to make precise some intuitive ideas which arise from the following considerations. In order that a covering map π: B˜ → B be a homeomorphism it sufﬁces that it is a one-to-one map. Therefore, we shall have to ﬁnd a condition which ensures that when two points p˜1, p˜2 of B˜ project by π onto the same point

p = π(p˜1) = π(p˜2)

of B, this implies that p˜1 = p˜2. We shall assume B˜ to be arcwise connected and project an arc α˜ of B˜, which joins p˜1 to p˜2, onto the closed arc α of B, which joins p to p (see Fig. 5-26). If B does not have “holes” (in a sense to be made precise), it is possible to “deform α continuously to the point p.” That is, there exists a family of arcs αt, continuous in t, t ∈ [0,1], with α0 = α and α1 equal to the constant arc p. Since α˜ is a lifting of α, it is natural to expect that the arcs αt may also be lifted in a family α˜t, continuous in t, t ∈ [0,l], with α0 = α˜. It follows that α˜1 is a lifting of the constant arc p and, therefore, reduces to a single point. On the other hand, α˜1 joins p˜1 to p˜2 and hence we conclude that p˜1 = p˜2.

p2

p

p1

αt αt α α

###### Figure 5-26

[Page 401]

To make the above heuristic argument rigorous we have to deﬁne a “continuous family of arcs joining two given arcs” and to show that such a family may be “lifted.”

DEFINITION 2. Let B ⊂ R3 and let α0: [0,l] → B, α1: [0,l] → B be two arcs of B, joining the points

p = α0(0) = α1(0) and q = α0(l) = α1(l).

We say that α0 and α1 are homotopic if there exists a continuous map H: [0,l]×[0,1] → B such that

- 1. H(s,0) = α0(s),H(s,1) = α1(s), s ∈ [0,l].
- 2. H(0,t) = p,H(l,t) = q, t ∈ [0,1]. The map H is called a homotopy between α0 and α1.


For every t ∈ [0,1], the arc αt: [0,l] → B given by αt(s) = H(s,t) is called an arc of the homotopy H. Therefore, the homotopy is a family of arcs αt, t ∈ [0,1], which constitutes a continuous deformation of α0 into α1 (see Fig. 5-27) in such a way that the extremities p and q of the arcs αt remain ﬁxed during the deformation (condition 2).

| | | | | | |
|---|---|---|---|---|---|


H

0 t

l

1

q

p

α1 α0

αt

###### Figure 5-27

The notion of lifting of homotopies is entirely analogous to that of lifting of arcs. Let π: B˜ → B be a continuous map and let α0, α1: [0,l] → B be two arcs of B joining the points p and q. Let H: [0,l]×[0,1] → B be a homotopy between α0 and α1. If there exists a continuous map

H˜ : [0,l]×[0,1] → B˜

such that π ◦H˜ = H, we say that H˜ is a lifting of the homotopy H, with origin at H(˜ 0,0) = p˜ ∈ B˜.

[Page 402]

We shall now show that a covering map has the property of lifting homotopies. Actually, we shall prove a more general proposition. Observe that a covering map π: B˜ → B is a local homeomorphism and, furthermore, that every arc of B may be lifted into an arc of B˜. For the proofs of Props. 3, 4, and 5 below we shall use only these two properties of covering maps, and so, for future use, we shall state these propositions in this generality. Thus, we shall say that a continuous map π: B˜ → B has the property of lifting arcs when every arc of B may be lifted. Notice that this implies that π maps B˜ onto B.

PROPOSITION 3. Let B be arcwise connected and let π: B˜ → B be a local homeomorphism with the property of lifting arcs. Let α0, α1: [0,l] → B be two arcs of B joining the points p and q, let

H: [0,l]×[0,1] → B

be a homotopy between α0 and α1, and let p˜ ∈ B˜ be a point of B˜ such that π(p˜) = p. Then there exists a unique lifting H˜ of H with origin at p˜.

Proof. The proof of the uniqueness is entirely analogous to that of the lifting of arcs. Let H˜1 and H˜2 be two liftings of H with H˜1(0,0) = H˜2(0,0) = p˜. Then the set A of points (s,t) ∈ [0,l]×[0,1] = Q such that H˜1(s,t) = H˜2(s,t) is nonempty and closed in Q. Since H˜1 and H˜2 are continuous and π is a local homeomorphism, A is open in Q. By connectedness of Q, A = Q; hence, H˜1 = H˜2.

To prove the existence, let αt(s) = H(s,t) be an arc of the homotopy H. Deﬁne H˜ by

H(s,t)˜ = α˜t(s), s ∈ [0,l],t ∈ [0,1], where α˜t is the lifting of αt, with origin at p˜. It is clear that

π ◦H(s,t)˜ = αt(s) = H(s,t), s ∈ [0,l],t ∈ [0,1], H(˜ 0,0) = α˜0(0) = p.˜

Let us now prove that H˜ is continuous. Let (s0,t0) ∈ [0,l]×[0,1]. Since π is a local homeomorphism, there exists a neighborhood V of H(s˜ 0,t0) such that the restriction π0 of π to V is a homeomorphism onto a neighborhood U of H(s0,t0). Let Q0 ⊂ H−1(U) ⊂ [0,l]×[0,1] be an open square given by

S0 −ǫ < S < S0 +ǫ, t0 −ǫ < t < t0 +ǫ.

It sufﬁces to prove that H˜ restricted to Q0 may be written as H˜ = π0−1 ◦H to conclude that H˜ is continuous at (s0,t0). Since (s0,t0) is arbitrary, H˜ is continuous in [0,l]×[0,1], as desired.

[Page 403]

For that, we observe that

π0−1(H(s0,t)), t ∈ (t0 −ǫ,t0 +ǫ),

is a lifting of the arc H(s0,t) passing through H(s˜ 0,t0). By uniqueness, π0−1(H(s0,t)) = H(s˜ 0,t). Since Q0 is a square, for every (s1,t1) ∈ Q0 there exists an arc H(s,t1) in U, s ∈ (s0 −ǫ,s0 +ǫ), which intersects the arc H(s0,t). Since π0−1(H(s0,t1)) = H(s˜ 0,t1), the arc π0−1(H(s,t1)) is the lifting of H(s,t1) passing through H(s˜ 0,t1). By uniqueness of the lifting, π0−1(H(s,t1)) = H(s,t˜ 1); hence, π0−1(H(s1,t1)) = H(s˜ 1,t1). By the arbitrariness of (s1,t1) ∈ Q0 we conclude that π0−1(H(s,t)) = H(s,t)˜ , (s,t) ∈ Q0 which ends the proof. Q.E.D.

A consequence of Prop. 3 is the fact that if π: B˜ → B is a covering map, then homotopic arcs of B are lifted into homotopic arcs of B˜. This may be expressed in a more general and precise way as follows.

PROPOSITION 4. Let π: B˜ → B be a local homeomorphism with the property of lifting arcs. Let α0,α1: [0,l] → B be two arcs of B joining the points p and q and choose p˜ ∈ B˜ such that π(p˜) = p. If α0 and α1 are homotopic, then the liftings α˜0 and α˜1 of α0 and α1, respectively, with origin p˜, are homotopic.

Proof. Let H be the homotopy between α0 and α1 and let H˜ be its lifting, with origin at p˜. We shall prove that H˜ is a homotopy between α˜0 and α˜1 (see Fig. 5-28).

| |
|---|
| |
| |
| |


H

p q

B q

π

H

p

###### Figure 5-28

[Page 404]

In fact, by the uniqueness of the lifting of arcs, H(s,˜ 0) = α˜0(s), H(s,˜ 1) = α˜1(s), s ∈ [0,l],

which veriﬁes condition 1 of Def. 2. Furthermore, H(˜ 0,t) is the lifting of the “constant” arc H(0,t) = p, with origin at p˜. By uniqueness,

H(˜ 0,t) = p,˜ t ∈ [0,1]. Similarly, H(l,t)˜ is the lifting of H(l,t) = q, with origin at α˜0(l) = q˜; hence, H(l,t)˜ = q˜ = α1(l), t ∈ [0,1].

Therefore, condition 2 of Def. 2 is veriﬁed, showing that H˜ is a homotopy between α˜0 and α˜1. Q.E.D.

Returning to the heuristic argument that led us to consider the concept of homotopy, we see that it still remains to explain what it is meant by a space without “holes.” Of course we shall take as a deﬁnition of such a space precisely that property which was used in the heuristic argument.

DEFINITION 3. An arcwise connected set B ⊂ R3 is simply connected if given two points p, q ∈ B and two arcs α0: [0,l] → B, α1: [0,l] → B joining p to q, there exists a homotopy in B between α0 and α1. In particular, any closed arc of B, α: [0,l] → B (closed means that α(0) = α(l) = p), is homotopic to the “constant” arc α(s) = p, s ∈ [0,l] (in Exercise 5 it is indicated that this last property is actually equivalent to the ﬁrst one).

Intuitively, an arcwise connected set B is simply connected if every closed arc in B can be continuously deformed into a point. It is possible to prove that the plane and the sphere are simply connected but that the cylinder and the torus are not simply connected (cf. Exercise 5).

We may now state and prove an answer to question 2 of this section. This will come out as a corollary of the following proposition.

PROPOSITION 5. Let π: B˜ → B be a local homeomorphism with the property of lifting arcs. Let B˜ be arcwise connected and B simply connected. Then π is a homeomorphism.

Proof. The proof is essentially the same as that presented in the heuristic argument.

We need to prove that π is one-to-one. For this, let p˜1 and p˜2 be two points of B˜, with π(p˜1) = π(p˜2) = p. Since B˜ is arcwise connected, there exists an arc α˜0 of B˜, joining p˜1 to p˜2. Then π ◦α˜0 = α0 is a closed arc of B. Since B is simply connected, α0 is homotopic to the constant arc α1(s) = p, s ∈ [0,l]. By Prop. 4, α˜0 is homotopic to the lifting α˜1 of α1 which has origin in p.

[Page 405]

Since α˜1 is the constant arc joining the points p˜1 and p˜2, we conclude that p˜1 = p˜2. Q.E.D.

COROLLARY. Let π: B˜ → B be a covering map, B˜ arcwise connected, and B simply connected. Then π is a homeomorphism.

The fact that we proved Props. 3, 4, and 5 with more generality than was strictly necessary will allow us to give another answer to question 1, as described below.

Let π: B˜ → B be a local homeomorphism with the property of lifting arcs, andassumethatB˜ andB arelocally“well-behaved”(tobemadeprecise).Then π is, in fact, a covering map.

The required local properties are described as follows. Recall that B ⊂ R3 is locally arcwise connected if any neighborhood of each point contains an arcwise connected neighborhood (appendix to Chap. 5, Def. 12).

DEFINITION 4. B is locally simply connected if any neighborhood of each point contains a simply connected neighborhood.

In other words, B is locally simply connected if each point has arbitrarily small simply connected neighborhoods. It is clear that if B is locally simply connected, then B is locally arcwise connected.

We remark that a regular surface S is locally simply connected, since p ∈ S has arbitrarily small neighborhoods homeomorphic to the interior of a disk in the plane.

In the next proposition we shall need the following properties of a locally arcwise connected set B ⊂ R3 (cf. the appendix to Chap. 5, Part D). The union of all arcwise connected subsets of B which contain a point p ∈ B is clearly an arcwise connected set A to be called the arcwise connected component of B containing p. Since B is locally arcwise connected, A is open in B. Thus, B can be written as a union B =

?

α Aα of its connected components Aα, which are open and pairwise disjoint.

We also remark that a regular surface is locatJy arcwise connected. Thus, in the proposition below, the hypotheses on B and B˜ are satisﬁed when both B and B˜ are regular surfaces.

PROPOSITION 6. Let π: B˜ → B be a local homeomorphism with the property of lifting arcs. Assume that B is locally simply connected and that B˜ is locally arcwise connected. Then π is a covering map.

Proof. Let p ∈ B and let V be a simply connected neighborhood of p in B. The set π−1(V ) is the union of its arcwise connected components; that is,

π−1(V ) = ?

α

V˜α,

[Page 406]

where the V˜α’s are open, arcwise connected, and pairwise disjoint sets. Consider the restriction π: V˜α → V . If we show that π is a homeomorphism of V˜α onto V , π will satisfy the conditions of the deﬁnition of a covering map.

We ﬁrst prove that π(V˜α) = V . In fact, π(V˜α) ⊂ V . Assume that there is a point p ∈ V , p ∈/ π(V˜α). Then, since V is arcwise connected, there exists an arc α: [a,b] → V joining a point q ∈ π(V˜α) to p. The lifting α˜: [a,b] → B˜

- of α with origin at q˜ ∈ V˜α, where π(q)˜ = q, is an arc in V˜α, since V˜α is an arcwise connected component of B. Therefore,


π(α(b))˜ = p ∈ π(V˜α), which is a contradiction and shows that π(V˜α) = V .

Next, we observe that π: V˜α → V is still a local homeomorphism, since V˜α is open. Furthermore, by the above, the map π: V˜α → V still has the property of lifting arcs. Therefore, we have satisﬁed the conditions of Prop. 5; hence, π is a homeomorphism. Q.E.D.

###### B. The Hadamard Theorems

We shall now return to the question posed in the beginning of this section,

namely, under what conditions is the local diffeomorphism expp : Tp(S) → S, where p is a point of a complete surface S of curvature K ≤ 0, a global

diffeomorphism of Tp(S) onto S. The following propositions, which serve to “break up” the given question into questions 1 and 2, yield an answer to the problem.

We shall need the following lemma. LEMMA 1. Let S be a complete surface of curvature K ≤ 0. Then

expp: Tp(S) → S, p ∈ S, is length-increasing in the following sense: If u, w ∈ Tp(S), we have

?(d expp)u(w),(d expp)u(w)? ≥ ?w,w?,

where, as usual, w denotes a vector in (Tp(S))u that is obtained/rom w by the translation u.

Proof. For the case u = 0, the equality is trivially veriﬁed. Thus, let v = u/|u|, u ?= 0, and let γ: [0,l] → S, l = |u|, be the geodesic

γ(s) = expp sv, s ∈ [0,l].

By the Gauss lemma, we may assume that ?w,v? = 0. Let J(s) = s(d expp)sv(w) be the Jacobi ﬁeld along γ given by Lemma 1 of Sec. 5-5. We know that J(0) = 0, (DJ/ds)(0) = w, and ?J(s), γ′(s)? = 0, s ∈ [0,l].

[Page 407]

Observe now that, since K ≤ 0 (cf. Eq. (1), Sec. 5-5),

d ds ?J,

DJ ds ? = ?

DJ ds

,

DJ ds ?+?J,

D2J ds2 ? = ?

DJ ds ?

2

−K|J|2 ≥ 0.

This implies that ?J,

DJ ds ? ≥ 0;

hence,

d ds ?

DJ ds

,

DJ ds ? = 2?

DJ ds

,

D2J ds2 ? = −2K ?

DJ ds

,J? ≥ 0. (1)

It follows that ?

DJ ds

,

DJ ds ? ≥ ?

DJ ds

(0),

DJ ds

(0)? = ?w,w? = C; (2)

hence,

d2 ds2?J,J? = 2?

DJ ds

,

DJ ds ?+2?J,

D2J ds2 ? ≥ 2?

DJ ds

,

DJ

ds ? ≥ 2C. (3) By integrating both sides of the above inequality, we obtain

d ds?J,J? ≥ 2Cs +?

d ds?J,J??

s=0

= 2Cs +2?

DJ ds

(0),J(0)? = 2Cs.

Another integration yields

?J,J? ≥ Cs2 +?J(0),J(0)? = Cs2. By setting s = l in the above expression and noticing C = ?w,w?, we obtain ?J(l),J(l)? ≥ l2?w,w?.

Since J(l) = l(d expp)lv(w), we ﬁnally conclude that ?(d expp)lv(w),(d exp)lv(w)? ≥ ?w,w?. Q.E.D.

For later use, it is convenient to establish the following consequence of the above proof.

COROLLARY (of the proof). Let K ≡ 0. Then expp: Tp(S) → S, p ∈ S, is a local isometry.

[Page 408]

It sufﬁces to observe that if K ≡ 0, it is possible to substitute “≥ 0” by “≡ 0” in Eqs. (1), (2), and (3) of the above proof.

PROPOSITION 7. Let S be a complete surface with Gaussian curvature K ≤ 0. Then the map expp: Tp(S) → S, p ∈ S, is a covering map.

Proof. Since we know that expp is a local diffeomorphism, it sufﬁces (by Prop. 6) to show that expp has the property of lifting arcs.

Let α: [0,l] → S be an arc in S and also let v ∈ Tp(S) be such that expp v = α(0). Such a v exists since S is complete. Because expp is a local diffeomorphism, there exists a neighborhood U of v in Tp(S) such that expp restricted to U is a diffeomorphism. By using exp−1

p in expp(U), it is possible to deﬁne α˜ in a neighborhood of 0.

Now let A be the set of t ∈ [0,l] such that α˜ is deﬁned in [0,t]. A is nonempty, and if α(t˜ 0) is deﬁned, then α˜ is deﬁned in a neighborhood of t0; that is, A is open in [0,l]. Once we prove that A is closed in [0,l], we have, by connectedness of [0,l], that A = [0,l] and α may be entirely lifted.

The crucial point of the proof consists, therefore, in showing that A is closed in [0,l]. For this, let t0 ∈ [0,l] be an accumulation point of A and {tn} be a sequence with {tn} → t0, tn ∈ A, n = 1,2,.... We shall ﬁrst prove that α(t˜ n) has an accumulation point.

Assumethat α(t˜ n)hasnoaccumulationpointin Tp(S). Then, givenaclosed diskD ofTp(S), withcenterα(˜ 0), thereisann0 suchthatα(t˜ n0) ?∈ D. Itfollows that the distance, in Tp(S), from α(˜ 0) to α(t˜ n) becomes arbitrarily large. Since, by Lemma 1, expp : Tp(S) → S increases lengths of the vectors, we obtain, by setting d as the distance in Tp(S),

l[0,tn] = ? t

n

0

|α′(t)|dt = ? t

n

0

|d expp(α˜′)|dt

≥ ? t

n

0

|˜α′(t)|dt = d(α(˜ 0),α(t˜ n)).

This implies that the length of α between 0 and tn becomes arbitrarily large, a contradiction that proves the assertion.

We shall denote by q an accumulation point of α(t˜ n). Now let V be a neighborhood of q in Tp(S) such that the restriction of expp to V is a diffeomorphism. Since q is an accumulation point of {˜α(tn)}, there exists an n1 such that α(t˜ n1) ∈ V . Moreover, since α is continuous, there exists an open interval I ⊂ [0,l], t0 ⊂ I, such that α(I) ⊂ expp(V ) = U. By using the restriction of exp−1

p in U it is possible to deﬁne a lifting of α in I, with origin in α(t˜ n1). Since expp is a local diffeomorphism, this lifting coincides with α˜ in [0,t0)∩I and is therefore an extension of α˜ to an interval containing t0. Thus, the set A is closed, and this ends the proof of Prop. 7.

###### Q.E.D.

[Page 409]

Remark 1. It should be noticed that the curvature condition K ≤ 0 was used only to guarantee that expp : Tp(S) → S is a length-increasing local diffeomorphism. Therefore, we have actually proved that if ϕ: S1 → S2 is a local diffeomorphism of a complete surface S1 onto a surface S2, which is length-increasing, then ϕ is a covering map.

The following proposition, known as the Hadamard theorem, describes the topological structure of a complete surface with curvature K ≤ 0.

THEOREM 1 (Hadamard). Let S be a simply connected, complete sur-

face, with Gaussian curvature K ≤ 0. Then expp: Tp(S) → S, p ∈ S, is a diffeomorphism; that is, S is diffeomorphic to a plane.

Proof. By Prop. 7, expp : Tp(S) → S is a covering map. By the corollary of Prop. 5, expp is a homeomorphism. Since expp is a local diffeomorphism, its inverse map is differentiable, and expp is a diffeomorphism. Q.E.D.

We shall now present another geometric application of the covering spaces, also known as the Hadamard theorem. Recall that a connected, compact, regular surface, with Gaussian curvature K > 0, is called an ovaloid (cf. Remark 2, Sec. 5-2).

THEOREM 2 (Hadamard). Let S be an ovaloid. Then the Gauss map N: S → S2 is a dijfepmorphism. In particular, S is diffeomorphic to a sphere.

Proof. Since for every p ∈ S the Gaussian curvature of S, K = det(dNp), is positive, N is a local diffeomorphism. By Prop. 1, N is a covering map. Since the sphere S2 is simply connected, we conclude from the corollary of Prop. 5 that N: S → S2 is a homeomorphism of S onto the unit sphere S2. Since N is a local diffeomorphism, its inverse map is differentiable. Therefore, N is a diffeomorphism. Q.E.D.

- Remark 2. Actually, we have proved somewhat more. Since the Gauss map N is a diffeomorphism, each unit vector v of R3 appears exactly once as a unit normal vector to S. Taking a plane normal to v, away from the surface, and displacing it parallel to itself until it meets the surface, we conclude that S lies on one side of each of its tangent planes. This is expressed by saying that an ovaloid S is locally convex. It can be proved from this that S is actually the boundary of a convex set (that is, a set K ⊂ R3 such that the line segment joining any two points p, q ∈ K belongs entirely to K).
- Remark 3. The fact that compact surfaces with K > 0 are homeomorphic to spheres was extended to compact surfaces with K ≥ 0 by S. S. Chern and R. K. Lashof (“On the Total Curvature of Immersed Manifolds,” Michigan Math. J. 5 (1958), 5–12). A generalization for complete surfaces was ﬁrst obtained by J. J. Stoker (“Über die Gestalt der positiv gekrümnten offenen


[Page 410]

Fläche,” CompositioMath. 3(1936), 58–89), whoproved, amongotherthings, the following: A complete surface with K > 0 is homeomorphic to a sphere

- or a plane. This result still holds for K ≥ 0 if one assumes that at some point K > 0(foraproofandasurveyofthisproblem, seeM.doCarmoandE.Lima, “Isometric Immersions with Non-negative Sectional Curvatures,” Boletim da Soc. Bras. Mat. 2 (1971), 9–22).


###### EXERCISES

- 1. Show that the map π: R → S1 = {(x,y) ∈ R2;x2 +y2 = 1} that is given by π(t) = (cost,sin t), t ∈ R, is a covering map.
- 2. Show that the map π: R2 −{0,0} → R2 −{0,0} given by π(x,y) = (x2 −y2,2xy), (x,y) ∈ R2,

is a two-sheeted covering map.

- 3. Let S be the helicoid generated by the normals to the helix (cost,sin t,bt). Denote by L the z axis and let π: S −L → R2 −{0,0} be the projection π(x,y,z) = (x,y). Show that π is a covering map.
- 4. Those who are familiar with functions of a complex variable will have noticed that the map π in Exercise 2 is nothing but the map π(z) = z2 from C−{0} onto C−{0}; here C is the complex plane and z ∈ C. Generalize that by proving that the map π: C−{0} → C−{0} given by π(z) = zn is an n-sheeted covering map.
- 5. Let B ⊂ R3 be an arcwise connected set. Show that the following two properties are equivalent (cf. Def. 3):

- 1. For any pair of points p, q ∈ B and any pair of arcs α0: [0,l] → B, α1: [0,l] → B, there exists a homotopy in B joining α0 to α1.
- 2. For any p ∈ B and any arc α: [0,l] → B with α(0) = α(l) = p (that is, α is a closed arc with initial and end point p) there exists a homotopy joining α to the constant arc α(s) = p, s ∈ [0,l].


- 6. Fix a point p0 ∈ R2 and deﬁne a family of maps ϕt: R2 → R2, t ∈ [0,1], by ϕt(p) = tp0 +(1−t)p, p ∈ R2. Notice that ϕ0(p) = p, ϕ1(p) = p0. Thus, ϕt is a continuous family of maps which starts with the identity map and ends with the constant map p0. Apply these considerations to prove that R2 is simply connected.
- 7. a. Use stereographic projection and Exercise 6 to show that any closed arc on a sphere S2 which omits at least one point of S2 is homotopic to a constant arc.


- b. Show that any closed arc on S2 is homotopic to a closed arc in S2 which omits at least one point.


[Page 411]

- c. Conclude from parts a and b that S2 is simply connected. Why is part b necessary?


- 8. (Klingenberg’sLemma.) LetS ⊂ R3 beacompletesurfacewithGaussian curvature K ≤ K0, where K0 is a nonnegative constant. Let p, q ∈ S and let γ0 and γ1 be two distinct geodesics joining p to q, with l(γ0) ≤ l(γ1); here l( ) denotes the length of the corresponding curve. Assume that γ0 is homotopic to γ1; i.e., there exists a continuous family of curves αt, t ∈ [0,1], joining p to q with α0 = γ0, α1 = γ1. The aim of this exercise is to prove that there exists a t0 ∈ [0,1] such that


l(γ0)+l(αt0) ≥

2π √K0

.

(Thus, the homotopy has to pass through a “long” curve. See Fig. 5-29.) Assume that l(γ0) < π/√K0 (otherwise there is nothing to prove) and proceed as follows.

γ1 p q

γ0 Figure 5-29. Klingenberg’s lemma.

- a. Use the ﬁrst comparison theorem (cf. Exercise 3, Sec. 5-5) to prove that expp: Tp(S) → S has no critical points in an open disk B of radius π/√K0 about p.

- b. Show that, for t small, it is possible to lift the curve αt into the tangent


plane Tp(S); i.e., there exists a curve α˜t joining exp−1

p (p) = 0 to exp−1

p (q) = q˜ and such that expp ◦α˜t = αt.

[Page 412]

- c. Show that the lifting in part b cannot be deﬁned for all t ∈ [0,1]. Conclude that for every ǫ > 0 there exists a t(ǫ) such that αt(ǫ) can be lifted into α˜t(ǫ) and α˜t(ǫ) contains points at a distance < ǫ from the boundary of B. Thus,

l(γ0)+l(αt(ǫ)) ≥

2π √K0 −2ǫ.

- d. Choose in part c a sequence of ǫ′s, {ǫn} → 0, and consider a converging subsequence of {t(ǫn)}. Conclude the existence of a curve αt0, t0 ∈ [0,1], such that


l(γ0)+l(αt0) ≥

2π √K0

.

- 9. a. Use Klingenberg’s lemma to prove that if S is a complete, simply connected surface with K ≥ 0, then expp : Tp(S) → S is one-to-one.


b. UsepartatogiveasimpleproofofHadamard’stheorem(Theorem1).

*10. (Synge’sLemma.)Werecallthatadifferentiableclosedcurveonasurface S is a differentiable map α: [0,l] → S such that α and all its derivatives agree at 0 and l. Two differentiable closed curves α0, α1: [0,l] → S are freely homotopic if there exists a continuous map H: [0,l]×[0,1] → S such that H(s,O) = α0(s), H(s,t)−α1(s), s ∈ [0,l]. The map H is called a free homotopy (the end points are not ﬁxed) between α0 and α1. Assume that S is orientable and has positive Gaussian curvature. Prove that any simple closed geodesic on S is freely homotopic to a closed curve of smaller length.

11. Let S be a complete surface. A point p ∈ S is called a pole if every geodesic γ: [0,∞) → S with γ(0) = p contains no point conjugate to p relative to γ. Use the techniques of Klingenberg’s lemma (Exercise 8) to prove that if S is simply connected and has a pole p, then expp : Tp(S) → S is a diffeomorphism.

###### 5-7. Global Theorems for Curves: The Fary-Milnor Theorem

ln this section, some global theorems for closed curves will be presented. The main tool used here is the degree theory for continuous maps of the circle. To introduce the notion of degree, we shall use some properties of covering maps developed in Sec. 5-6.

[Page 413]

x = f (0)

f

R 2π

π

f(t)

f(t)

6π 0

0 l

t

x+2π x+4π

s1

f p = f (0)

4π

###### Figure 5-30

Let S1 = {(x,y) ∈ R2; x2 +y2 = 1} and let π: R → S1 be the covering of S1 by the real line R given by

π(x) = (cosx,sin x), x ∈ R.

Let ϕ: S1 → S1 be a continuous map. The degree of ϕ is deﬁned as follows. We can think of the ﬁrst S1 in the map ϕ: S1 → S1 as a closed interval [0,l] with its end points 0 and l identiﬁed. Thus, ϕ can be thought of as a continuous map ϕ: [0,l] → S1, with ϕ(0) = ϕ(l) = p ∈ S1. Thus, ϕ is a closed arc at p in

- S1 which, by Prop. 2 of Sec. 5-6, can be lifted into a unique arc ϕ˜:[0,l]→R, starting at a point x ∈ R with π(x) = p. Since π(ϕ(˜ 0)) = π(ϕ(l))˜ , the differenceϕ(l)˜ −ϕ(˜ 0)isanintegralmultipleof2π. Theintegerdegϕ givenby


ϕ(l)˜ −ϕ(˜ 0) = (deg ϕ)2π is called the degree of ϕ.

Intuitively, deg ϕ is the number of times that ϕ: [0,l] → S1 “wraps” [0,l] around S1 (Fig. 5-30). Notice that the function ϕ˜: [0,l] → R is a continuous determination of the positive angle that the ﬁxed vector ϕ(0)−O makes with ϕ(t)−O, t ∈ [0,l), O = (0,0)—e.g., the map π: S1 → S1 described in Example 4 of Sec. 5-6, Part A, has degree k.

We must show that the deﬁnition of degree is independent of the choices of p and x.

First, deg ϕ is independent of the choice of x. In fact, let x1 > x be a point in R such that π(x1) = p, and let ϕ˜1(t) = ϕ(t)˜ +(x1 −x), t ∈ [0,l]. Since x1 −x is an integral multiple of 2π, ϕ˜1 is a lifting of ϕ starting at x1. By the uniqueness part of Prop. 2 of Sec. 5-6, ϕ˜1 is the lifting of ϕ starling at x1. Since

ϕ˜1(l)−ϕ˜1(0) = ϕ(l)˜ −ϕ(˜ 0) = (deg ϕ)2π, the degree of ϕ is the same whether computed with x or with x1.

[Page 414]

Second, deg ϕ is independent of the choice of p ∈ S1. In fact, each point

- p1 ∈ S1, except the antipodal point of p, belongs to a distinguished neighborhoodU1 ofp. Choosex1, intheconnectedcomponentofπ−1(U1)containingx, such that π(x1) = p1, and let ϕ˜1 be the lifting of


ϕ: [0,l] → S1,ϕ(0) = p1,

starting at x1. Clearly, | ˜ϕ1(0)−ϕ(˜ 0)| < 2π. It follows from the stepwise process through which liftings are constructed (cf. the proof of Prop. 2, Sec. S-6) that | ˜ϕ1(l)−ϕ˜1(l) < 2π. Since both differences ϕ(l)˜ −ϕ(˜ 0), ϕ˜1(l)−ϕ˜1(0) must be integral multiples of 2π, their values are actually equal. By continuity, the conclusion also holds for the antipodal point of p, and this proves our claim.

The most important property of degree is its invariance under homotopy. More precisely, let ϕ1, ϕ2: S1 → S1 be continuous maps. Fix a point p ∈ S1, thus obtaining two closed arcs at p, ϕ1, ϕ2: [0,l] → S1, ϕ1(0) = ϕ2(0) = p. If ϕ1 and ϕ2 are homotopic, then deg ϕ1 = deg ϕ2. This follows immediately from the fact that (Prop. 4, Sec. 5-6) the liftings of ϕ1 and ϕ2 starting from a ﬁxed point x ∈ R are homotopic, and hence have the same end points.

It should be remarked that if ϕ: [0,l] → S1 is differentiable, it determines differentiable functions a = a(t), b = b(t), given by ϕ(t) = (a(t),b(t)), which satisfy the condition a2 +b2 = 1. In this case, the lifting ϕ˜, starting at ϕ˜0 = x, is precisely the differentiable function (cf. Lemma 1, Sec. 4-4).

ϕ(t)˜ = ϕ˜0 +? t

0

(ab′ −ba′)dt.

Thisfollowsfromtheuniquenessoftheliftingandthefactthatcosϕ(t)˜ = a(t), sin ϕ(t)˜ = b(t), ϕ(˜ 0) = ϕ˜0. Thus, in the differentiable case, the degree of ϕ can be expressed by an integral,

deg ϕ =

1 2π ? l

0

dϕ˜ dt

dt.

In the latter form, the notion of degree has appeared repeatedly in this book. For instance, when v: U ⊂ R2 → R2, U ⊃ S1, is a vector ﬁeld, and (0,0) is its only singularity, the index of v at (0,0) (cf. Sec. 4-5, Application 7) may be interpreted as the degree of the map ϕ: S1 → S1 that is given by ϕ(p) = v(p)/|v(p)|, p ∈ S1.

Before going into further examples, let us recall that a closed (differentiable) curve is a differentiable map α: [0,l] → R3 (or R2, if it is a plane curve) such that the components of α, together with all its derivatives, agree at 0 and l. The curve α is regular if α′(t) ?= 0 for all t ∈ [0,l], and α is simple if whenever t1 ?= t2, t1,t2 ∈ [0,l), then α(t1) ?= α(t2). Sometimes it is

[Page 415]

convenient to assume that α is merely continuous; in this case, we shall say explicitly that α is a continuous closed curve.

Example 1 (The Winding Number of a Curve). Let α: [0,l] → R2 be a plane, continuous closed curve. Choose a point p0 ∈ R2, p0 ∈/ α([0,l]), and let ϕ: [0,l] → S1 be given by

ϕ(t) =

α(t)−P0 |α(t)−P0|

, t ∈ [0,l].

Clearly ϕ(0) = ϕ(l), and ϕ may be thought of as a map of S1 into S1; it is calledthepositionmapofα relativetop0. Thedegreeofϕ iscalledthewinding number (or the index) of the curve α relative to p0 (Fig. 5-31).

α(t)

α(t) – p0 α(t) – p0

β

p0

S1

###### Figure 5-31

Notice that by moving p0 along an arc β which does not meet α([0,l]) the winding number remains unchanged. Indeed, the position maps of α relative to any two points of β can clearly be joined by a homotopy. It follows that the winding number of α relative to q is constant when q runs in a connected component of R2 −α([0,l]).

Example 2 (The Rotation Index of a Curve). Let α: [0,l] → R2 be a regular plane closed curve, and let ϕ: [0,l] → S1 be given by

ϕ(t) =

α′(t) |α′(t)|

, t ∈ [0,l].

Clearly ϕ is differentiable and ϕ(0) = ϕ(l). ϕ is called the tangent map of α, and the degree of ϕ is called the rotation index of α. Intuitively, the rotation index of a closed curve is the number of complete turns given by the tangent vector ﬁeld along the curve (Fig. 1-27, Sec. 1-7).

It is possible to extend the notion of rotation index to piecewise regular curves by using the angles at the vertices (see Sec. 4-5) and to prove that the rotation index of a simple, closed, piecewise regular curve is ±1 (the theorem ofturningtangents).ThisfactisusedintheproofoftheGauss-Bonnettheorem.

[Page 416]

Later in this sect ion we shall prove a differentiable version of the theorem of turning tangents.

Our ﬁrst global theorem will be a differentiable version of the so-called Jordan curve theorem. For the proof we shall presume some familiarity with the material of Sec. 2-7.

THEOREM 1 (Differentiable Jordan Curve Theorem). Let α: [0,l] → R2 be a plane, regular, closed, simple curve. Then R2 → α([0,l]) has exactly two connected components, and α([0,l])) is their common boundary.

Proof. Let Nǫ(α) be a tubular neighborhood of α([0,l]). This is constructedinthesamewayasthatusedforthetubularneighborhoodofacompact surface (cf. Sec. 2-7). We recall that Nǫ(α) is the union of open normal segments Iǫ(t), with length 2ǫ and center in α(t). Clearly, Nǫ(α)−α([0,l]) has two connected components T1 and T2. Denote by w(p) the winding number of α relative to p ∈ R2 −α([0,l]). The crucial point of the proof is to show that if both p1 and p2 belong to distinct connected components of Nǫ(α)−α([0,l])andtothesameIǫ(t0), t0 ∈ [0,l], thenw(p1)−w(p2) = ±1, the sign depending on the orientation of α.

Choose points A = α(t1), D = α(t2), t1 < t0 < t2, so close to t0 that the arc AD of α can be deformed homotopically onto the polygon ABCD of Fig. 5-32. Here BC is a segment of the tangent line at α(t), and BA and CD are parallel to the normal line at α(t0).

Let us denote by β: [0,l¯] → R2 the curve obtained from α by replacing the arc AD by the polygon ABCD, and let us assume that β(0) = β(l)¯ = A and that β(t3) = D. Clearly, w(p1) and w(p2) remain unchanged.

Let ϕ1,ϕ2: [0,l¯] → S1 be the position maps of β relative p1, p2, respectively (cf. Example l), and let ϕ˜1,ϕ˜2: [0,l¯] → R be their liftings from a ﬁxed point, say 0 ∈ R. For convenience, let us assume the orientation of β to be given as in Fig. 5-32.

We ﬁrst remark that if t ∈ [t3,l¯], the distances from α(t) to both p1 and

- p2 remain bounded below by a number independent t, namely, the smallest of the two numbers dist(p1, Bd Nǫ(α)) and dist(p2, Bd Nǫ(α)). It follows that the angle of α(t)−p1 with α(t)−p2 tends uniformly to zero in (t3,l¯] as p1 approaches p2.


Now, it is clearly possible to choose p1 and p2 so close to each other that ϕ˜1(t3)−ϕ˜1(0) = π −ǫ1, and ϕ˜2(t3)−ϕ˜2(0) = −(π +ǫ2), with ǫ1 and ǫ2 smaller than π/3. Furthermore,

2π(w(p1)−w(p2)) = (ϕ˜1(l)¯ −ϕ˜1(0)−(ϕ˜2(l)¯ −ϕ˜2(0))

= {(ϕ˜1 −ϕ˜2)(l)˜ −(ϕ˜1 −ϕ˜2)(t3)}

+{(ϕ˜1 −ϕ˜2)(t3)−(ϕ˜1 −ϕ˜2)(0)}.

[Page 417]

|B|p1|
|---|---|
|A|D|


α(t0)

α(t)

p2

p2

p1

B

C

C

D = α(t2) = β(t3) A = α(t1) = β(0)

Tubular neighborhood

Orientation of the plane

A

###### Figure 5-32

By the above remark, the ﬁrst term can be made arbitrarily small, say equal to ǫ1 < π/3, if p1 is sufﬁciently close to p2. Thus,

2π(w(p1)−w(p2)) = ǫ3 +π −ǫ1 −(−π −ǫ2) = 2π +ǫ,

where ǫ <π if p1 is sufﬁciently close to p2. It follows that w(p1)−w(p2)=1, as we had claimed.

It is now easy to complete the proof. Since w(p) is constant in each connected component of R2 −α([0,l]) = W, it follows from the above that there are at least two connected components in W. We shall show that there are exactly two such components.

In fact, let C be a connected component of W. Clearly Bd C ?= φ and Bd C ⊂ α([0,l]). On the other hand, if p ∈ α([0,l]), there is a neighborhood of p that contains only points of α([0,l]), points of T1, and points of T2 (T1 and T2 are the connected components of Nǫ(α)−α([0,l])). Thus, either T1 or T2 intersects C. Since C is a connected component, C ⊃ T1, or C ⊃ T2. Therefore, there are at most two (hence, exactly two) connected components of W. Denote them by C1 and C2. The argument also shows that Bd C1 = α([O,l]) = Bd C2. Q.E.D.

[Page 418]

The two connected components given by Theorem 1 can easily be distinguished. One starts from the observation that if p0 is outside a closed disk D containing α([0,l]) (since [0,l] is compact, such a disk exists), then the winding number of α relative to p0 is zero. This comes from the fact that the lines joining p0 to α(t), t ∈ [0,l], are all within a region containing D and bounded by the two tangents from p0 to the circle Bd D. Thus, the connected component with winding number zero is unbounded and contains all points outside a certain disk. Clearly the remaining connected component has winding number ±1 and is bounded. It is usual to call them the exterior and the interior of α, respectively.

Remark 1. A useful complement to the above theorem, which was used in the applications of the Gauss-Bonnet theorem (Sec. 4-5), is the fact that the interior of α is homeomorphic to an open disk. Aproof of that can be found in J. J. Stoker, Differential Geometry, Wiley-Interscience, New York, 1969, pp. 43–45.

We shall now prove a differentiable version of the theorem of turning tangents.

THEOREM 2. Let β: [0,l] → R2 be a plane, regular, simple, closed curve. Then the rotation index of β is ±1 (depending on the orientation of β).

Proof. Consider a line that does not meet the curve and displace it parallel to itself until it is tangent to the curve. Denote by L (this position of the line and by p a point of tangency of the curve with L. Clearly the curve is entirely on one side of L (Fig. 5-33). Choose a new parametrization α: [0,l] → R2 for the curve so that α(0) = p. Now let

T = {(t1,t2) ∈ [0,l]×[0,l];0 ≤ t1 ≤ t2 ≤ l} be a triangle, and deﬁne a “secant map” ψ: T → S1 by

ψ(t1,t2) =

α(t2)−α(t1) |α(t2)−α(t1)|

for t1 ?= t2,(t1,t2) ∈ T −{(0,l)}

ψ(t,t) =

α′(t) |α′(t2)|

, ψ(0,l) = −

α′(0) |α′(0)|

.

Since α is regular, ψ is easily seen to be continuous. Let A = (0,0), B = (0,l), C = (l,l) be the vertices of the triangle T . Notice that ψ restricted to the side AC is the tangent map of α, the degree of which is the rotation number of α. Clearly (Fig. 5-33), the tangent map is homotopic to the restriction of ψ to the remaining sides AB and BC. Thus, we are reduced to show that the degree of the latter map is ±1.

Assume that the orientations of the plane and the curve are such that the oriented angle from α′(0) to −α′(0) is π. Then the restriction of ψ to AB

[Page 419]

α´(0)

A = (0, 0)

ψ

B = (0, l) C = (l, l)

p

l

###### Figure 5-33

covers half of S1 in the positive direction, and the restriction of ψ to BC covers the remaining half also in the positive direction (Fig. 5-33). Thus, the degree of ψ restricted to AB and BC is +1. Reversing the orientation, we shall obtain −1 for this degree, and this completes the proof. Q.E.D.

The theorem of turning tangents can be used to give a characterization of an important class of curves, namely the convex curves.

A plane, regular, closed curve α: [0,l] → R2 is convex if, for each t ∈ [0,l], the curve lies in one of the closed half-planes determined by the tangent lineatt (Fig. 5-34; cf. alsoSec. 1-7). Ifα issimple, convexitycanbeexpressed in terms of curvature. We recall that for plane curves, curvature always means the signed curvature (Sec. 1-5, Remark 1).

(a) (b) (c)

Convex curve Nonconvex curves

###### Figure 5-34

[Page 420]

PROPOSITION 1. A plane, regular, closed curve is convex if and only if it is simple and its curvature k does not change sign.

Proof. Let ϕ: [0,l] → S1 be the tangent map of α and ϕ˜: [0,l] → R be the lifting of ϕ starting at 0 ∈ R. We ﬁrst remark that the condition that k does not change sign is equivalent to the condition that ϕ˜ is monotonic (nondecreasing if k ≥ 0, or nonincreasing if k ≤ 0).

Now, suppose that α is simple and that k does not change sign. We can orient the plane of the curve so that k ≥ 0. Assume that α is not convex.Then there exists t0 ∈ [0,l] such that points of α([0,l]) can be found on both sides of the tangent line T at α(t0). Let n = n(t0) be the normal vector at t0, and set

hn(t) = ?α(t)−α(t0),n?, t ∈ [0,l].

Since [0,l] is compact and both sides of T contain points of the curve, the “height function” hn has a maximum at t1 ?= t0 and a minimum at t2 ?= t0. The tangent vectors at the points t0,t1,t2 are all parallel, so two of them, say α′(t0), α′(t1), have the same direction. It follows that ϕ(t0) = ϕ(t1) and, by Theorem 2 (α is simple), ϕ(t˜ 0) = ϕ(t˜ 1). Let us assume that t1 > t0. By the above remark, ϕ˜ is monotonic nondecreasing, and hence constant in [t0,t1]. This means that α([t0,t1]) ⊂ T . But this contradicts the choice of T and shows that α is convex.

Conversely, assume that α is convex. We shall leave it as an exercise to showthatifα isnotsimple, ataself-intersectionpoint(Fig.5-35(a)), ornearby it (Fig. 5-35(b)), the convexity condition is violated. Thus, α is simple.

(a) (b)

2

4

3 1

###### Figure 5-35

We now assume that α is convex and that k changes sign in [0,l]. Then there are points t1,t2 ∈ [0,l], t1 < t2, with ϕ(t˜ 1) = ϕ(t˜ 2) and ϕ˜ not constant in [t1,t2].

We shall show that this leads to a contradiction, thereby concluding the proof. By Theorem 2, there exists t3 ∈ [0,l) with ϕ(t3) = −ϕ(t1). By convexity, two of the three parallel tangent lines at α(t1), α(t2),α(t3) must coincide. Assume this to be the case for α(t1) = p, α(t3) = q, t3 > t1. We claim that the arc of α between p and q is the line segment pq.

[Page 421]

In fact, assume that r ?= q is the last point for which this arc is a line segment (r may agree with p). Since the curve lies in the same side of the line pq, it is easily seen that some tangent T near p will cross the segment pq in an interior point (Fig. 5-36). Then p and q lie on distinct sides of T . That is a contradiction and proves our claim.

p r

T

q

###### Figure 5-36

It follows that the coincident tangent lines have the same directions; that is, they are actually the tangent lines at α(t1) and α(t2). Thus, ϕ˜ is constant in [t1,t2], and this contradiction proves that k does not change sign in [0,l].

###### Q.E.D.

- Remark 2. The condition that α is simple is essential to the proposition, as

shown by the example of the curve in Fig. 5-34(c).

- Remark 3. The proposition should be compared with Remarks 2 and 3 of

Sec. 5-6; there it is stated that a similar situation holds for surfaces. It is to be noticed that, in the case of surfaces, the nonexistence of self-intersections is not an assumption but a consequence.

- Remark 4. It can be proved that a plane, regular, closed curve is convex if


and only if its interior is a convex set K ⊂ R2 (cf. Exercise 4).

We shall now turn our attention to space curves. In what follows the word curve will mean a parametrized regular curve α: [0,l] → R3 with arc length s as parameter. If α is a plane curve, the curvature k(s) is the signed curvature of α (cf. Sec. 1-5); otherwise, k(s) is assumed to be positive for all s ∈ [0,l].

It is convenient to call ? l

0

|k(s)|ds

the total curvature of α.

Probably the best-known global theorem on space curves is the so-called Fencbel’s theorem.

THEOREM 3 (Feochel’s Theorem). The total curvature of a simple closed curve is ≥ 2π, and equality holds if and only if the curve is a plane convex curve.

[Page 422]

Before going into the proof, we shall introduce an auxiliary surface which is also useful for the proof of Theorem 4.

The tube of radius r around the curve α is the parametrized surface

x(s,v) = α(s)+r(ncosv +b sin v), s ∈ [0,l],v ∈ [0,2π],

where n = n(s) and b = b(s) are the normal and the binormal vector of α, respectively. It is easily check that

|xs ∧xv|2 = EG−F2 = r2(1−rk cosv)2.

We assume that r is so small that rk0 < I, where k0 < max |k(s)|, s ∈ [0,l]. Then x is regular, and a straightforward computation gives

N = −(ncosv +b sin v), xs ∧xv = r(1−rk cosv)N,

Ns ∧Nv = k cosv(ncosv +b sin v) = −kN cosv

= −

k cosv r(1−rk cosv)

xv ∧xs.

It follows that the Gaussian curvature K = K(s,v) of the tube is given by

K(s,v) = −

k cosv r(1−rk cosv)

.

Notice that the trace T of x may have self-intersections. However, if α is simple, it is possible to choose r so small that this does not occur; we use the compactness of [0,l] and proceed as in the case of a tubular neighborhood constructed in Sec. 2-7. If, in addition, α is closed, T is a regular surface homeomorphic to a torus, also called a tube around α. In what follows, we assume this to be the case.

Proof of Theorem 3. LetT beatubearoundα, andletR ⊂ T betheregion of T where the Gaussian curvature of T is nonnegative. On the one hand,

??

R

Kdσ = ??

R

K

?

EG−F2 ds dv

= ? l

0

k ds ? 3π/2

π/2

cosv dv = 2? l

0

k(s)ds.

On the other hand, each half-line L through the origin of R3 appears at least once as a normal direction of R. For if we take a plane P perpendicular to L such that P ∩T = φ and move P parallel to itself toward T (Fig. 5-37), it will meet T for the ﬁrst time at a point where K ≥ 0.

[Page 423]

L

P

###### Figure 5-37

It follows that the Gauss map N of R covers the entire unit sphere S2 at least once; hence,

??

R Kdσ ≥ 4π. Therefore, the total curvature of α is ≥ 2π, and we have proved the ﬁrst part of Theorem 3.

Observe that the image of the Gauss map N restricted to each circle s = const. isone-to-oneandthatitsimageisagreatcircleŴs ⊂ S2. Weshalldenote by Ŵ+

s ⊂ Ŵs the closed half-circle corresponding to points where K ≥ 0. Assume that α is a plane convex curve. Then all Ŵ+

s have the same end

pointsp, q, and, byconvexity, Ŵs1 ∩Ŵs2 = {p}∪{q}fors1 ?= s2,s1,s2 ∈ [0,l). By the ﬁrst part of the theorem, it follows that

??

R Kdσ = 4π; hence, the total curvature of α is equal to 2π.

Assume now that the total curvature of α is equal to 2π. By the ﬁrst part of the theorem,

??

R Kdσ = 4π. We claim that all Ŵ+

s have the same end points p and q. Otherwise, there are two distinct great circles Ŵs1,Ŵs2,s1 arbitrarily close to s2, that intersect in two antipodal points which are not in N(R ∩Q), where Q is the set of points in T with non positive curvature. It follows that there are two points of positive curvature which are mapped by N into a single

[Page 424]

point of S2. Since N is a local diffeomorphism at such points and each point of S2 is the image of at least one point of R, we conclude that

??

R Kσ > 4π, a contradiction.

By observing that the points of zero Gaussian curvature in T are the intersections of the binormal of α with T , we see that the binormal vector of α is parallel to the line pq. Thus, α is contained in a plane normal to this line.

We ﬁnally prove that α is convex. We may assume that α is so oriented that its rotation number is positive. Since the total curvature of α is 2π, we have

2π = ? l

0

|k|ds ≥ ? l

0

k ds.

On the other hand, ?

J

k ds ≥ 2π,

where J = {s ∈ [0,l];k(s) ≥ 0}. This holds for any plane closed curve and follows from an argument entirely similar to the one used for R ⊂ T in the beginning of this proof. Thus,

? l

0

k ds = ? l

0

|k|ds = 2π.

Therefore, k ≥ 0, and α is a plane convex curve. Q.E.D.

Remark 5. It is not hard to see that the proof goes through even if α is not simple. The tube will then have self-intersections, but this is irrelevant to the argument. In the last step of the proof (the convexity of α), one has to observe that we have actually shown that α is nonnegatively curved and that its rotation index is equal to 1. Looking back at the ﬁrst part of the proof of Prop. 1, one easily sees that this implies that α is convex.

We want to use the above method of proving Fenchel’s theorem to obtain a sharpening of this theorem which states that if a space curve is knotted (a concept to be deﬁned presently), then the total curvature is actually greater than 4π.

A simple closed continuous curve C ⊂ R3 is unknotted if there exists a homotopy H: S1 ×I → R3, I = [0,1], such that

H(S1 ×{0}) = S1 H(S1 ×{1}) = C; and H(S1 ×{t}) = Ct ⊂ R3

is homeomorphic to S1 for all t ∈ [0,1]. Intuitively, this means that C can be deformed continuously onto the circle S1 so that all intermediate positions

[Page 425]

Unknotted Knotted Figure 5-38

are homeomorphic to S1. Such a homotopy is called an isotopy; an unknotted curve is then a curve isotopic to S1. When this is not the case, C is said to be knotted (Fig. 5-38).

THEOREM 4 (Fary-Milnor). The total curvature of a knotted simple closed curve is greater than 4π.

Proof. Let C = α([0,l]), let T be a tube around α, and let R ⊂ T be the region of T where K ≥ 0. Let b = b(s) be the binormal vector of α, and let v ∈ R3 be a unit vector, v ?= ±b(s), for all s ∈ [0,l]. Let hv: [0,l] → R be the height function of α in the direction of v; that is, hv(s) = ?α(s)−0,v?, s ∈ [0,l]. Clearly, s is a critical point of hv if and only if v is perpendicular to the tangent line at α(s). Furthermore, at a critical point,

d ds2

(hv) = ?

d2α ds2

,v? = k?u,v? ?= 0,

since: v ?= ±b(s) for all s and k > 0. Thus, the critical points of hv are either maxima or minima.

Now, assume the total curvature of α to be smaller than or equal to 4π. This means that ??

R

K dσ = 2? k ds ≤ 8π.

We claim that, for some v0 ∈/ ±b([0,l]), hv0 has exactly two critical points (since [0,l] is compact, such points correspond to the maximum and minimum

of hv0). Assume that the contrary is true. Then, for every v ∈/ b([0,l]), hv has at least three critical points. We shall assume that two of them are points of

minima, s1 and s2, the case of maxima being treated similarly.

Consider a plane P perpendicular to v such that P ∩T = φ, and move it parallel to itself toward T . Either hv(s1) = hv(s2) or, say, hv(s1) < hv(s2). In the ﬁrst case, P meets T at points q1 ?= q2, and since v ∈/ b([0,l]), K(q1) and K(q2) are positive. In the second case, before meeting α(s1), P will meet T at a point q1 with K(q1) > 0. Consider a second plane P¯, parallel to and at a distance r above P (r is the radius of the tube T ). Move P¯ further up until it reaches α(s2); then P will meet T at a point q2 ?= q1 (Fig. 5-39). Since s2 is a point of minimum and v ∈/ b([0,l]), K(q2) > 0. In any case, there are two

[Page 426]

| | | | |
|---|---|---|---|
| | | | |


r

q2

q1

P

P

P

P r

hv(s2)

hv(s1)

###### Figure 5-39

distinct points in T with K > 0 that are mapped by N into a single point of

- S2. This contradicts the fact that


??

R Kdσ ≤ 8π, and proves our claim.

Let s1 and s2 be the critical points of hv0, and let P1 and P2 be planes perpendicular to v0 and passing through α(s1) and α(s2), respectively. Each plane parallel to v0 and between P1 and P2 will meet C in exactly two points. Joining these pairs of points by line segments, we generate a surface bounded by C which is easily seen to be homeomorphic to a disk. Thus, C is unknotted, and this contradiction completes the proof. Q.E.D.

###### EXERCISES

- 1. Determine the rotation indices of curves (a), (b), (c), and (d) in Fig. 5-40.
- 2. Let α(t) = (x(t),y(t)), t ∈ [0,l], be a differentiable plane closed curve. Let p0 = (x0,y0) ∈ R2, (x0,y0) ∈/ α([0,l]), and deﬁne the functions


- a(t) =

x(t)−x0 {(x(t)−x0)2 +(y(t)−y0)2}1/2

,

- b(t) =


y(t)−y0 {(x(t)−x0)2 +(y(t)−y0)2}1/2

.

- a. Use Lemma 1 of Sec. 4-4 to show that the differentiable function


ϕ(t) = ϕ0 +? t

0

(ab′ −ba′)dt, a′ =

da dt

,b′ =

db dt

,

is a determination of the angle that the x axis makes with the position vector (α(t)−p0)/|α(t)−p0|.

[Page 427]

(a) (b)

(c) (d)

###### Figure 5-40

- b. Use part a to show that when α is a differentiable closed plane curve, the winding number of α relative to p0 is given by the integral


w =

1 2π ? l

0

(ab′ −ba′)dt.

- 3. Let α: [0,l] → R2 and β: [0,l] → R2 be two differentiable plane closed

curves, and let p0 ∈ R2 be a point such that p0 ∈/ α([0,l]) and p0 ∈/ β([0,l]). Assume that, for each t ∈ [0,l], the points α(t) and β(t) are closer than the points α(t) and p0; i.e.,

|α(t)−β(t)| < |α(t)−p0|.

Use Exercise 2 to prove that the winding number of α relative to p0 is equal to the winding number of β relative to p0.

- 4. a. Let C be a regular plane closed convex curve. Since C is simple, it determines, by the Jordan curve theorem, an interior region K ⊂ R2. Prove that K is a convex set (i.e., given p, q ∈ K, the segment of straight line pq is contained in K; cf. Exercise 9, Sec. 1-7).


b. Conversely, let C be a regular plane curve (not necessarily closed), and assume that C is the boundary of a convex region. Prove that C is convex.

[Page 428]

- 5. Let C be a regular plane, closed, convex curve. By Exercise 4, the interior of C is a convex set K. Let p0 ∈ K, p0 ∈/ C.

- a. Show that the line which joins p0 to an arbitrary point q ∈ C is not tangent to C at q.
- b. ConcludefrompartathattherotationindexofC isequaltothewinding number of C relative to p0.
- c. Obtain from part b a simple proof for the fact that the rotation index of a closed convex curve is ±1.


- 6. Let α: [0,l] → R3 be a regular closed curve parametrized by arc length. Assume that 0 ?= |k(s)| ≤ 1 for all s ∈ [0,l]. Prove that l ≥ 2π and that l = 2π if and only if α is a plane convex curve.
- 7. (Schur’s Theorem for Plane Curves.) Let α: [0,l] → R2 and α˜: [0,l] → R2 be two plane convex curves parametrized by arc length, both with the same length l. Denote by k and k˜ the curvatures of α and α˜, respectively, and by d and d˜ the lengths of the chords of α and α˜, respectively; i.e.,


d(s) = |α(s)−α(0)|, d(s)˜ = |˜α(s)−α(˜ 0)|.

Assume that k(s) ≥ k(s)˜ , s ∈ [0,l]. We want to prove that d(s) ≤ d(s)˜ , s ∈ [0,l] (i.e., if we stretch a curve, its chords become longer) and that equality holds for s ∈ [0,l] if and only if the two curves differ by a rigid motion. We remark that the theorem can be extended to the case where α˜ is a space curve and has a number of applications, Compare S. S. Chern [10].

The following outline may be helpful.

- a. Fix a point s = s1. Put both curves α(s) = (x(s),y(s)), α(s)˜ = (x(s),˜ y(s))˜ inthelowerhalf-planey ≤ 0sothatα(0), α(s1), α(˜ 0), and α(s˜ 1) lie on the x axis and x(s1) > x(0), x(s˜ 1) > x(˜ 0) (see Fig. 5-41). Let s0 ∈ [0,s1] be such that α′(s0) is parallel to the x axis. Choose the function θ(s) which gives a differentiable determination of the angle

that the x axis makes with α′(s) in such a way that θ(s0) = 0. Show that, by convexity, −π ≤ θ ≤ π.

- b. Let θ(s)˜ , θ(s˜ 0) = 0, be a differentiable determination of the angle that the x axis makes with α′(s). (Notice that α˜′(s0) may no longer be parallel to the x axis.) Prove that θ(s)˜ ≤ θ(s) and use part a to conclude that


d(s1) = ? s

1

0

cosθ(s)ds ≤ ? s

1

0

cosθ(s)˜ ds ≤ d(s˜ 1).

For the equality case, just trace back your steps and apply the uniqueness theorem for plane curves.

[Page 429]

y

0 x(0)

α(s0)

x(s1) x(0) x

α(s0)

x(s1) ө ө

~

###### Figure 5-41

- 8. (Stoker’s Theorem for Plane Curves.) Let α: R → R2 be a regular plane curve parametrized by arc length. Assume that α satisﬁes the following conditions:


- 1. The curvature of α is strictly positive.
- 2. lim s→±∞

|α(s)| = ∞; that is, the curve extends to inﬁnity in both directions.

- 3. α has no self-intersections.


The goal of the exercise is to prove that the total curvature of α is ≤ π.

The following indications may be helpful.Assume that the total curvature is > π and that α has no self-intersections. To obtain a contradiction, proceed as follows:

- a. Prove that there exist points, say, p = α(0), q = α(s1), s1 > 0, such that the tangent lines Tp, Tq at the points p and q, respectively, are parallel and there exists no tangent line parallel to Tp in the arc α([0,s1]).
- b. Show that as s increases, α(s) meets Tp at a point, say, r (Fig. 5-42).
- c. The arc α((−∞,0)) must meet Tp at a point t between p and r.
- d. Complete the arc tpqr of α with an arc β without self-intersections joining r to t, thus obtaining a closed curve C. Show that the rotation index of C is ≥ 2. Show that this implies that α has self-intersections, a contradiction.


*9. Let α: [0,l] → S2 be a regular closed curve on a sphere S2 = {(x,y,z) ∈ R3; x2 +y2 +z2 = 1}. Assume that α is parametrized by arc length and that the curvature k(s) is nowhere zero. Prove that

? l

0

τ(s)ds = 0.

[Page 430]

Tp

Tq

β r t

p = α(0)

q = α(s1)

Figure 5-42

###### 5-8. Surfaces of Zero Gaussian Curvature

We have already seen (Sec. 4-6) that the regular surfaces with identically zero Gaussian curvature are locally isometric to the plane. ln this section, we shall look upon such surfaces from the point of view of their position in R3 and prove the following global theorem.

THEOREM. Let S ⊂ R3 be a complete surface with zero Gaussian curvature. Then S is a cylinder or a plane.

By deﬁnition, a cylinder is a regular surface S such that through each point

- p ∈ S there passes a unique line R(p) ⊂ S (the generator through p) which satisﬁes the condition that if q ?= p, then the lines R(p) and R(q) are parallel or equal.


It is a strange fact in the history of differential geometry that such a theorem was proved only somewhat late in its development. The ﬁrst proof came as a corollary of a theorem of P. Hartman and L. Nirenberg (“On Spherical Images Whose Jacobians Do Not Change Signs,” Amer. J. Math. 81 (1959), 901–920) dealing with a situation much more general than ours. Later, W. S. Massey (“Surfaces of Gaussian Curvature Zero in Euclidean Space,” Tohoku Math.

- J. 14 (1962), 73–79) and J. J. Stoker (“Developable Surfaces in the Large,” Comm. Pure and Appl. Math. 14 (1961), 627–635) obtained elementary and direct proofs of the theorem. The proof we present here is a modiﬁcation of


[Page 431]

Massey’s proof. It should be remarked that Stoker’s paper contains a slightly more general theorem.

(Added in 2016) Professor I. Sabitov informed me that this result was obtained by A.V. Pogorelov in 1956. It appeared under the title Extensions of the theorem of Gauss on spherical representation, in Dokl. Akad. Nauk. S.S.S.R. (N.S.) 111 (1956), 945–947. MR0087147.

We shall start with the study of some local properties of a surface of zero curvature.

Let S ⊂ R3 be a regular surface with Gaussian curvature K ≡ 0. Since

- K = k1k2, where k1 and k2 are the principal curvatures, the points of S are either parabolic or planar points. We denote by P the set of planar points and by U = S −P the set of parabolic points of S.


P is closed in S. In fact, the points of P satisfy the condition that the

mean curvature H = 12(k1 +k2) is zero. A point of accumulation of P has, by continuity of H, zero mean curvature; hence, it belongs to P. It follows that

U = S −P is open in S.

An instructive example of the relations between the sets P and U is given in the following example.

Example 1. Consider the open triangle ABC and add to each side a cylindrical surface, with generators parallel to the given side (see Fig. 5-43). It is possible to make this construction in such a way that the resulting surface is a regular surface. For instance, to ensure regularity along the open segment BC, it sufﬁces that the section FG of the cylindrical band BCDE by a plane normal to BC is a curve of the form

exp?−

1 x2?.

Observe that the vertices A, B, C of the triangle and the edges BE, CD, etc., of the cylindrical bands do not belong to S.

A

B

F

C

D

G

E

###### Figure 5-43

[Page 432]

The surface S so constructed has curvature K ≡ 0. The set P is formed by the closed triangle ABC minus the vertices. Observe that P is closed in S but not in R3. The set U is formed by the points which are interior to the cylindrical bands. Through each point of U there passes a unique line which will never meet P. The boundary of P is formed by the open segments AB, BC, and CA.

In the following, we shall prove that the relevant properties of this example appear in the general case.

First, let p ∈ U. Since p is a parabolic point, one of the principal directions at p is an asymptotic direction, and there is no other asymptotic direction at p. We shall prove that the unique asymptotic curve that passes through p is a segment of a line.

PROPOSITION 1. The unique asymptotic line that passes through a paraholic point p ∈ U ⊂ S of a surface S of curvature K ≡ 0 is an (open) segment of a (straight) line in S.

Proof. Since p is not umbilical, it is possible to parametrize a neighborhood V ⊂ U of p by x(u,v) = x in such a way that the coordinate curves are lines of curvature. Suppose that v = const. is an asymptotic curve; that is, it has zero normal curvature. Then, by the theorem of Olinde Rodrigues (Sec. 3-2, Prop. 3), Nu = 0 along v = const. Since through each point of the neighborhood V there passes a curve v = const., the relation Nu = 0 holds for every point of V .

It follows that in V

?x,N?u = ?xu,N?+?x,Nu? = 0. Therefore,

?x,N? = ϕ(v), (1)

where ϕ(v) is a differentiable function of v alone. By differentiating Eq. (1) with respect to v, we obtain

?x,Nv? = ϕ′(v). (2)

On the other hand, Nv is normal to N and different from zero, since the points of V are parabolic. Therefore, N and Nv are linearly independent. Furthermore, Nvu = Nuv = 0 in V .

We now observe that along the curve v = const. = v0 the vector N(u) = N0 and Nv(u) = (Nv)0 = const. Thus, Eq. (1) implies that the curve x(u,v0) belongs to a plane normal to the constant vector N0, and Eq. (2) implies that this curve belongs to a plane normal to the constant vector (Nv)0. Therefore, the curve is contained in the intersection of two planes (the intersection exists since N0 and (Nv)0 are linearly independent); hence, it is a segment of a line.

###### Q.E.D.

[Page 433]

Remark. It is essential that K ≡ 0 in the above proposition. For instance, the upper parallel of a torus of revolution is an asymptotic curve formed by parabolic points and it is not a segment of a line.

Wearenowgoingtoseewhathappenswhenweextendthissegmentofline. The following proposition shows that (cf. Example 1) the extended line never meets the set P; either it “ends” at a boundary point of S or stays indeﬁnitely in U.

It is convenient to use the following terminology. An asymptotic curve passing through a point p ∈ S is said to be maximal if it is not a proper subset of some asymptotic curve passing through p.

PROPOSITION 2 (Massey, loc. cit.). Letr beamaximalasymptoticline passingthroughaparabolicpointp ∈ U ⊂ SofasurfaceSofcurvatureK ≡ 0 and let P ⊂ S be the set of planar points of S. Then r ∩P = φ.

The proof of Prop. 2 depends on the following local lemma, for which we use the Mainardi-Codazzi equations (cf. Sec. 4-3).

LEMMA 1. Letsbethearclengthoftheasymptoticcurvepassingthrough a parabolic point p of a surface S of zero curvature and let H = H(s) be the mean curvature of S along this curve. Then, in U,

d2 ds2 ?

1 H? = 0.

Proof of Lemma 1. We introduce in a neighborhood V ⊂ U of p a system of coordinates (u,v) such that the coordinate curves are lines of curvature and the curves v = const. are the asymptotic curves of V . Let e, f , and g be the coefﬁcients of the second fundamental form in this parametrization. Since f = 0 and the curve v = const., u = u(s) must satisfy the differential equation of the asymptotic curves

e ?

du ds ?2 +2f

du ds

dv ds +g ?

dv ds ?2 = 0,

we conclude that e = 0. Under these conditions, the mean curvature H is given by

H =

k1 +k2 2 =

1 2 ? e

E +

g G? =

- 1

- 2


g G

###### . (3)

By introducing the values F = f = e = 0 in the Mainardi-Codazzi equations (Sec. 4-3, Eq. (7) and (7a)), we obtain

0 =

1 2

gEv G

, gu =

- 1

- 2


gGu G

###### . (4)

[Page 434]

From the ﬁrst equation of (4) it follows that Ev = 0. Thus, E = E(u) is a function of u alone. Therefore, it is possible to make a change of parameters:

v¯ = v, u¯ = ? ?

E(u)du.

We shall still denote the new parameters by u and v. u now measures the arc length along v = const., and thus E = 1.

Inthenewparametrization(F = 0,E = 1)theexpressionfortheGaussian curvature is

K = −

1 √G

(

√

G)uu = 0.

Therefore,

√

G = c1(v)u+c2(v), (5)

where c1(v) and c2(v) are functions of v alone. On the other hand, the second equation of (4) may be written (g ?= 0)

gu g =

- 1

- 2


Gu √G√G =

(√G)u

√G ; hence,

g = c3(v)

√

###### G, (6)

where c3(v) is a function of v. By introducing Eqs. (5) and (6) into Eq. (3) we obtain

H =

- 1

- 2


c3(v) √G

√G √G =

- 1

- 2


c3(v) c1(v)u+c2(v)

.

Finally, by recalling that u = s and differentiating the above expression with respect to s, we conclude that

d2 ds2 ?

1 H ? = 0, Q.E.D.

Proof of Prop. 2. Assume that the maximal asymptotic line r passing through p and parametrized by arc length s contains a point q ∈ P. Since r is connected and U is open, there exists a point p0 of r, corresponding to s0, such that p0 ∈ P and the points of r with s < s0 belong to U.

[Page 435]

On the other hand, from Lemma 1, we conclude that along r and for s < s0, H(s) =

1 as +b

,

where a and b are constants. Since the points of P have zero mean curvature, we obtain

H(p0) = 0 = lim s→s0

H(s) = lim

s→s0

1 as +b

,

which is a contradiction and concludes the proof. Q.E.D.

Let now Bd(U) be the boundary of U in S; that is, Bd(U) is the set of points p ∈ S such that every neighborhood of p in S contains points of U and points of S −U = P. Since U is open in S, it follows that Bd(U) ⊂ P. Furthermore, since the deﬁnition of a boundary point is symmetric in U and P, we have that

Bd(U) = Bd(P).

The following proposition shows that (just as in Example 1) the set Bd(U) = Bd(P) is formed by segments of straight lines.

PROPOSITION 3 (Massey). Let p ∈ Bd(U) ⊂ S be a point of the boundary of the set U of parabolic points of a surface S of curvature K ≡ 0. Then through p there passes a unique open segment of line C(p) ⊂ S. Furthermore, C(p) ⊂ Bd(U); that is, the boundary of U is formed by segments of lines.

Proof. Let p ∈ Bd(U). Since p is a limit point of U, it is possible to choose a sequence {pn}, pn ∈ U, with limn→∞ pn = p. For every pn, let C(pn) be the unique maximal asymptotic curve (open segment of a line) that passes through pn (cf. Prop. 1). We shall prove that, as n → ∞, the directions of C(pn) converge to a certain direction that does not depend on the choice of the sequence {pn}.

In fact, let ? ⊂ R3 be a sufﬁciently small sphere around p. Since the sphere ? is compact, the points {qn} of intersection of C(pn) with ? have at least one point of accumulation q ∈ ?, which occurs simultaneously with its antipodal point. If there were another point of accumulation r besides q and its antipodal point, then through arbitrarily near points pn and pm there should pass asymptotic lines C(pn) and C(pm) making an angle greater than

θ = 12ang(pq,pr),

thus contradicting the continuity of asymptotic lines. It follows that the lines C(pn) have a limiting direction. An analogous argument shows that this limiting direction does not depend on the chosen sequence {pn} with limn→∞ pn = p, as previously asserted.

[Page 436]

Since the directions of C(pn) converge and pn → p, the open segments of lines C(pn) converge to a segment C(p) ⊂ S that passes through p. The segment C(p) does not reduce itself to the point p. Otherwise, since C(pn) is maximal, p ∈ S would be a point of accumulation of the extremities of C(pn), which do not belong to S (cf. Prop. 2). By the same reasoning, the segment C(p) does not contain its extreme points.

Finally, we shall prove that C(p) ⊂ Bd(U). In fact, if q ∈ C(p), there exists a sequence

{qn},qn ∈ C(pn) ⊂ U, with lim n→∞

qn = q.

Then q ∈ U ∪Bd(U).Assume that q ∈/ Bd(U). Then q ∈ U, and, by the continuity of the asymptotic directions, C(p) is the unique asymptotic line that passes through q. This implies, by Prop. 2, that p ∈ U, which is a contradiction. Therefore, q ∈ Bd(U), that is, C(p) ⊂ Bd(U), and this concludes the proof. Q.E.D.

We are now in a position to prove the global result stated in the beginning of this section.

Proof of the Theorem.AssumethatS isnotaplane.Then(Sec. 3-2, Prop.4) S contains parabolic points. Let U be the (open) set of parabolic points of S and P be the (closed) set of planar points of S. We shall denote by int P, the interior of P, the set of points which have a neighborhood entirely contained in P. int P is an open set in S which contains only planar points. Therefore, each connected component of int P is contained in a plane (Sec. 3-2, Prop. 4).

We shall ﬁrst prove that if q ∈ S and q ∈/ int P, then through q there passes a unique line R(q) ⊂ S, and two such lines are either equal or do not intersect.

In fact, when q ∈ U, then there exists a unique maximal asymptotic line r passing through q. r is a segment of line (thus, a geodesic) and r ∩P = φ (cf. Props. 1 and 2). By parametrizing r by arc length we see that r is not a ﬁnite segment. Otherwise, there exists a geodesic which cannot be extended to all values of the parameter, which contradicts the completeness of S. Therefore, r is an entire line R(q), and since r ∩P = φ, we conclude that R(q) ⊂ U. It follows that when p is another point of U, p ∈/ R(q), then R(p)∩R(q) = φ. Otherwise, through the intersection point there should pass two asymptotic lines, which contradicts the asserted uniqueness.

On the other hand, if q ∈ Bd(U) = Bd(P), then (cf. Prop. 3) through

- q there passes a unique open segment of line which is contained in Bd(U). By the previous argument, this segment may be extended into an entire line R(q) ⊂ Bd(U), and if p ∈ Bd(U), p ∈/ R(q), then R(p)∩R(q) = φ.


Clearly, since U is open, if q ∈ U and p ∈ Bd(U), then R(p)∩R(q) = φ. In this way, through each point of S −int P = U ∪Bd(U) there passes a unique line contained in S −int P, and two such lines are either equal or do not intersect, as we claimed. We now claim that these lines are parallel to

[Page 437]

a ﬁxed direction and we shall conclude that Bd(U)(= Bd(P)) is formed by parallel lines and that each connected component of int P is an open set of a plane, bounded by two parallel lines. Thus, through each point r ⊂ int P there passes a unique line R(t) ⊂ int P parallel to the common direction. It follows that through each point of S there passes a unique generator and that the generators are parallel, that is, S is a cylinder, as we wish.

ToprovethatthelinespassingthroughthepointsofU ∪Bd(U)areparallel, we shall proceed in the following way. Let q ∈ U ∪Bd(U) and p ∈ U. Since S is connected, there exists an arc α: [0,l] → S, with α(0) = p, α(l) = q. The map expp: Tp(S) → S is a covering map (Prop. 7, Sec. 5-6) and a local isometry (corollary of Lemma 1, Sec. 5-6). Let α˜: [0,l] → Tp(S) be the lifting of α, with origin at the origin 0 ∈ Tp(S). For each α(t)˜ , with expp α(t)˜ = α(t) ∈ U ∪Bd(U), let rt be the lifting of R(α(t)) with origin at α(t)˜ . Since expp is a local isometry, rt is a line in Tp(S).

Furthermore, when α(t1) ?= α(t2), t1,t2 ∈ [0,l], the lines rt1 and rt2 are parallel. In fact, if v ∈ rt1 ∩rt2, then

expp(v) ∈ R(α(t1))∩R(α(t2)), which is a contradiction. This proves our claim, and the theorem. Q.E.D.

###### 5-9. Jacobi’s Theorems

It is a fundamental property of a geodesic γ (Sec. 4-6, Prop. 4) that when two points p and q of γ are sufﬁciently close, then γ minimizes the arc length between p and q. This means that the arc length of γ between p and q is smaller than or equal to the arc length of any curve joining p to q. Suppose now that we follow a geodesic γ starting from a point p. It is then natural to ask how far the geodesic γ minimizes arc length. In the case of a sphere, for instance, ageodesicγ(ameridian)startingfromapointp minimizesarclength up to the ﬁrst conjugate point of p relative to γ (that is, up to the antipodal point of p). Past the antipodal point of p, the geodesic stops being minimal, as we may intuitively see by the following considerations.

A geodesic joining two points p and q of a sphere may be thought of as a thread stretched over the sphere and joining the two given points. When the arc pq⌢ is smaller than a semimeridian and the points p and q are kept ﬁxed, it is not possible to move the thread without increasing its length. On the other hand, when the arcpq⌢ is greater than a semimeridian, a small displacement of the thread (with p and q ﬁxed) “loosens” the thread (see Fig. 5-44). In other words, when q is farther away than the antipodal point of p, it is possible to obtain curves joining p to q that are close to the geodesic arc pq⌢ and are shorter than this arc. Clearly, this is far from being a mathematical argument.

In this section we shall begin the study of this question and prove a result, due to Jacobi, which may be roughly described as follows. A geodesic γ

[Page 438]

p

p´

q

q´

###### Figure 5-44

starting from a point p minimizes arc length, relative to “neighboring” curves of γ, only up to the “ﬁrst” conjugate point of p relative to γ (more precise statements will be given later; see Theorems 1 and 2).

For simplicity, the surfaces in this section are assumed to be complete and the geodesics are parametrized by arc length.

We need some preliminary results.

The following lemma shows that the image by expp : Tp(S) → S of a segment of line of Tp(S) with origin at O ∈ Tp(S) (geodesic starting from p) is minimal relative to the images by expp of curves of Tp(S) which join the extremities of this segment.

More precisely, let

p ∈ S, u ∈ Tp(S), l = |u| ?= 0, and let γ˜: [0,l] → Tp(S) be the line of Tp(S) given by

γ(s)˜ = sv, s ∈ [0,l], v =

u |u|

.

Let α˜: [0,l] → Tp(S) be a differentiable parametrized curve of Tp(S), with α(˜ 0) = 0, α(l)˜ = u, and α(s)˜ ?= 0 if s ?= 0. Furthermore, let (Fig. 5-45)

α(s) = expp α(s)˜ and γ(s) = expp γ(s).˜

LEMMA 1. With the above notation, we have

1. l(α) ≥ l(γ), where l( ) denotes the arc length of the corresponding curve.

In addition, if α(˜ s) is not a critical point of expp, s ∈ [0,l)], and if the traces of α and γ are distinct, then

2. l(α) > l(γ).

[Page 439]

n

r

u

v

γ

γ

α(s)

TP(S)

0

expp

p

α S

###### Figure 5-45

Proof. Let α(s)/˜ |˜α(s)| = r, and let n be a unit vector of Tp(S), with ?r,n? = 0. In the basis {r,n} of Tp(S) we can write (Fig. 5-45)

α˜′(s) = ar +bn, where

a = ?˜α′(s),r?, b = ?˜α′(s),n?.

By deﬁnition

α′(s) = (d expp)α(s)˜ (α˜′(s))

= a(d expp)α(s)˜ (r)+b(d expp)α(s)˜ (n). Therefore, by using the Gauss lemma (cf. Sec. 5-5, Lemma 2) we obtain

?α′(s),α′(s)? = a2 +c2, where

c2 = b2|(d expp)α(s)˜ (n)|2. It follows that

?α′(s),α′(s)? ≥ a2.

On the other hand, d ds?˜α(s),α(s)˜ ?1/2 =

?˜α′(s),α(s)˜ ? ?˜α(s),α(s)˜ ?1/2

= ?˜α′(s),r? = a.

[Page 440]

Therefore,

l(α) = ? l

0

?α′(s),α′(s)?1/2 ds ≥ ? l

0

a ds

= ? l

0

d ds?˜α(s),α(s)˜ ?1/2 ds = |˜α(l)| = l = l(γ),

and this proves part 1. To prove part 2, let us assume that l(α) = l(γ). Then

? l

0

?α′(s),α′(s)?1/2 ds = ? l

0

a ds,

and since

?α′(s),α′(s)?1/2 ≥ a, the equality must hold in the last expression for every s ∈ [0,l]. Therefore, c = |b||(d expp)α(s)˜ (n)| = 0.

Since α(s)˜ is not a critical point of expp, we conclude that b ≡ 0. It follows that the tangent lines to the curve α˜ all pass through the origin O of Tp(s). Thus, α˜ is a line of Tp(S) which passes through O. Since α(l)˜ = γ(l)˜ , the lines α˜ and γ˜ coincide, thus contradicting the assumption that the traces of α and γ are distinct. From this contradiction it follows that l(α) > l(γ), which proves part 2 and ends the proof of the lemma. Q.E.D.

Wearenowinapositiontoprovethatifageodesicarccontainsnoconjugate points, it yields a local minimum for the arc length. More precisely, we have

THEOREM 1 (Jacobi). Letγ:[0,l] → S, γ(0) = p, beageodesicwithout conjugate points; that is, expp: Tp(S) → S is regular at the points of the line γ(˜ s) = sγ′(0) of Tp(S), s ∈ [0,l]. Let h: [0,l]×(−ǫ,ǫ) → S be a proper variation of γ. Then

- 1. There exists a δ > 0, δ ≤ ǫ, such that if t ∈ (−δ,δ), L(t) ≥ L(0),

where L(t) is the length of the curve ht: [0,l] → S that is given by ht(s) = h(s,t).

- 2. If, in addition, the trace of ht, is distinct from the trace of γ, L(t) > L(0).


Proof. The proof consists essentially of showing that it is possible, for every t ∈ (−δ,δ), to lift the curve ht into a curve h˜t of Tp(S) such that h˜t(0) = 0, h˜t(l) = γ(l)˜ and then to apply Lemma 1.

[Page 441]

Since expp is regular at the points of the line γ˜ of Tp(S), for each s ∈ [0,l] there exists a neighborhood Us of γ(s)˜ such that expp restricted to Us is a diffeomorphism. The family {Us}, s ∈ [0,l], covers γ(˜ [0,l]), and, by compactness, it is possible to obtain a ﬁnite subfamily, say, U1,...,Un which still covers γ(˜ [0,l]). It follows that we may divide the interval [0,l] by points

0 = s1 < s2 < ··· < sn < sn+1 = l

in such a way that γ(˜ [si,si+1]) ⊂ Ui, i = 1,...,n. Since h is continuous and [si,si+1] is compact, there exists δi > 0 such that

h([si,sk+1]×(−δi,δi)) ⊂ expp(Ui) = Vi.

Let δ = min(δ1,...,δn). For t ∈ (−δ,δ), the curve ht: [0,l] → S may be lifted into a curve h˜t: [0,l] → Tp(S), with origin h˜t(0) = 0, in the following way. Let s ∈ [s1,s2]. Then

h˜t(s) = exp−1

p (ht(s)), where exp−1

p is the inverse map of expp: U1 → V1. By applying the same technique we used for covering spaces (cf. Prop. 2, Sec. 5-6), we can extend h˜t for all s ∈ [0,l] and obtain h˜t(l) = γ(l)˜ .

In this way, we conclude that γ(s) = expp γ(s)˜ and that ht(s) =

expp h˜t(s), t ∈ (−δ,δ), with h˜t(0) = 0, h˜t(l) = γ(l)˜ . We then apply Lemma 1 to this situation and obtain the desired conclusions. Q.E.D.

Remark 1. A geodesic γ containing no conjugate points may well not be minimal relative to the curves which are not in a neighborhood of γ. Such a situation occurs, for instance, in the cylinder (which has no conjugate points), as the reader will easily verify by observing a closed geodesic of the cylinder.

Thissituationisrelatedtothefactthatconjugatepointsinformusonlyabout the differential of the exponential map, that is, about the rate of “spreading out” of the geodesics neighboring a given geodesic. On the other hand, the global behavior of the geodesics is controlled by the exponential map itself, which may not be globally one-to-one even when its differential is nonsingular everywhere.

Another example (this time simply connected) where the same fact occurs is in the ellipsoid, as the reader may verify by observing the ﬁgure of the ellipsoid in Sec. 5-5 (Fig. 5-19).

The study of the locus of the points for which the geodesics starting from p stop globally minimizing the arc length (called the cut locus of p) is of fundamental importance for certain global theorems of differential geometry, but it will not be considered in this book.

We shall proceed now to prove that a geodesic γ containing conjugate points is not a local minimum for the arc length; that is, “arbitrarily near” to γ

[Page 442]

there exists a curve, joining its extreme points, the length of which is smaller than that of γ.

We shall need some preliminaries, the ﬁrst of which is an extension of the deﬁnition of variation of a geodesic to the case where piecewise differentiable functions are admitted.

DEFINITION 1. Let γ: [0,l] → S be a geodesic of S and let

h: [0,l]×(−ǫ,ǫ) → S be a continuous map with

h(s,0) = γ(s), s ∈ [0,l]. h is said to be a broken variation of γ if there exists a partition

0 = s0 < s1 < s2 < ··· < sn−1 < sn = l of [0,l] such that

h: [si,si+1]×(−ǫ,ǫ) → S, i = 0,1,...,n −1,

is differentiable. The broken variation is said to be proper if h(0,t) = γ(0), h(l,t) = γ(l) for every t ∈ (−ǫ,ǫ).

The curves ht(s), s ∈ [0,l], of the variation are now piecewise differentiable curves. The variational vector ﬁeld V (s) = (∂h/∂t)(s,0) is a piecewise differentiable vector ﬁeld along γ; that is, V : [0,l] → R3 is a continuous map, differentiable in each [ti,ti+1]. The broken variation h is said to be orthogonal if ?V (s),γ′(s)? = 0, s ∈ [0,l].

In a way entirely analogous to that of Prop. 1 of Sec. 5-4, it is possible to prove that a piecewise differentiable vector ﬁeld V along γ gives rise to a broken variation of γ, the variational ﬁeld of which is V . Furthermore, if

V (0) = V (l) = 0, the variation can be chosen to be proper.

Similarly, the function L: (−ǫ,ǫ) → R (the arc length of a curve of the variation) is deﬁned by

L(t) =

?n−1

0

? s

i+1

si

?

∂h ∂s

(s,t)?ds

= ? l

0

?

∂h ∂s

(s,t)?ds.

By Lemma 1 of Sec. 5-4, each summand of this sum is differentiable in a neighborhood of 0. Therefore, L is differentiable in (−δ,δ) if δ is sufﬁciently small.

[Page 443]

The expression of the second variation of the arc length (L′′(0)), for proper and orthogonal broken variations, is exactly the same as that obtained in Prop. 4 of Section 5-4, as may easily be veriﬁed. Thus, if V is a piecewise differentiable vector ﬁeld along a geodesic γ: [0,l] → S such that

?V (s),γ′(s)? = 0, S ∈ [0,l], and V (0) = V (l) = 0, we have

L′′V(0) = ? l

0

??

DV ds

,

DV ds ?−K(s)?V (s),V (s)??ds.

Now let γ: [0,l] → S be a geodesic and let us denote by U the set of piecewise differentiable vector ﬁelds along γ which are orthogonal to γ; that is, if V ∈ U, then ?V (s),γ′(s)? = 0 for all s ∈ [0,l]. Observe that U, with the natural operations of addition and multiplication by a real number, forms a vector space. Deﬁne a map I: U×U → R by

I(V,W) = ? l

0

??

DV ds

,

DW

ds ?−K(s)?V (s),W(s)??ds, where V , W ∈ U.

It is immediate to verify that I is a symmetric bilinear map; that is, I is linear in each variable and I(V,W) = I(W,V ). Therefore, I determines a quadratic form in U, given by I(V,V ). This quadratic form is called the index form of γ.

Remark 2. The index form of a geodesic was introduced by M. Morse, who proved the following result. Let γ(s0) be a conjugate point of γ(0) = p, relative to the geodesic γ: [0,l] → S, s0 ∈ [0,l]. The multiplicity of the conjugate point γ(s0) is the dimension of the largest subspace E of Tp(S) such that (d expp)γ(s0)(u) = 0 for every u ∈ E. The index of a quadratic form Q: E → R in a vector space E is the maximum dimension of a subspace L of E such that Q(u) < 0, u ∈ L. With this terminology, the Morse index theorem is stated as follows: Let γ: [0,l] → S be a geodesic. Then the index of the quadratic form I of γ is ﬁnite, and it is equal to the number of conjugate points to γ(0) in γ((0,l]), each one counted with its multiplicity. A proof of this theorem may be found in J. Milnor, Morse Theory, Annals of Mathematics Studies, Vol. 51, Princeton University Press, Princeton, N. J., 1963.

For our purposes we need only the following lemma. LEMMA 2. Let V ∈ U be a Jacobi ﬁeld along a geodesic γ: [0,l] → S

and W ∈ U. Then I(V,W) = ?

DV ds

(l),W(l)?−?

DV ds

(0),W(0)?.

[Page 444]

Proof. By observing that

d ds ?

DV ds

,W? = ?

D2V ds2

,W?+?

DV ds

,

DW ds ?,

we may write I in the form (cf. Remark 4, Sec. 5-4)

I(V,W) = ?

DV ds

,W?

?

l

0

−? l

0

??

D2V ds2 +K(s)V (s),W(s)??ds.

From the fact that V is a Jacobi ﬁeld orthogonal to γ, we conclude that the integrand of the second term is zero. Therefore,

I(V,W) = ?

DV ds

(l),W(l)?−?

DV ds

(0),W(0)?. Q.E.D.

We are now in a position to prove:

THEOREM 2 (Jacobi). If we let γ: [0,l] → S be a geodesic of S and we let γ(s0) ∈ γ((0,l)) be a point conjugate to γ(0) = p relative to γ, then there exists a proper broken variation h: [0,l]×(−ǫ,ǫ) → S of γ and a real number δ > 0, δ ≤ ǫ, such that if t ∈ (−δ,δ), t ?= 0, we have L(t) < L(0).

Proof. Since γ(s0) is conjugate to p relative to γ, there exists a Jacobi ﬁeld J alongγ, notidenticallyzero, withJ(0) = J(s0) = 0. ByProp. 4ofSec. 5-5, it follows that ?J(s),γ′(s)? = 0, s ∈ [0,l]. Furthermore, (DJ/ds)(s0) ?= 0; otherwise, J(s) ≡ 0.

Now let Z¯ be a parallel vector ﬁeld along γ, with Z(s¯ 0) = −(DJ/ds)(s0), and f : [0,l] → R be a differentiable function with f (0) = f (l) = 0, f (s0) = 1. Deﬁne Z(s) = f (s)Z(s)¯ , s ∈ [0,l].

For each real number η > 0, deﬁne a vector ﬁeld Yη along γ by

Yη = J(s)+ηZ(s), s ∈ [0,s0],

= ηZ(s), s ∈ [s0,l].

Yη is a piecewise differentiable vector ﬁeld orthogonal to γ. Since Yη(0) = Yη(l) = 0, it gives rise to a proper, orthogonal, broken variation of γ. We shall compute L′′(0) = I(Yη,Yη).

For the segment of geodesic between 0 and s0, we shall use the bilinearity of I and Lemma 2 to obtain

[Page 445]

Is0(Yη,Yη) = Is0(J +ηZ,J +ηZ)

= Is0(J,J)+2ηIs0(J,Z)+η2Is0(Z,Z)

= 2η ?

DJ ds

(s0),Z(s0)?+η2Is0(Z,Z)

= −2η ?

DJ ds

(s0)?

2

+η2Is0(Z,Z),

where Is0 indicates that the corresponding integral is taken between 0 and s0. By using I to denote the integral between 0 and l and noticing that the integral

is additive, we have

I(Yη,Yη) = −2η ?

DJ ds

(s0)?

2

+η2I(Z,Z).

Observe now that if η = η0 is sufﬁciently small, the above expression is

negative. Therefore, by taking Yη0, we shall obtain a proper broken variation, with L′′(0) < 0. Since L′(0) = 0, this means that 0 is a point of local max-

imum for L; that is, there exists δ > 0 such that if t ∈ (−δ,δ), t ?= 0, then L(t) < L(0). Q.E.D.

Remark 3. Jacobi’s theorem is a particular case of the Morse index theorem, quoted in Remark 2. Actually, the crucial point of the proof of the index theorem is essentially an extension of the ideas presented in the proof of Theorem 2.

###### EXERCISES

- 1. (Bonnet’s Theorem.) Let S be a complete surface with Gaussian curvature K ≥ δ > 0. By Exercise 5 of Sec. 5-5, every geodesic γ: [0,∞) → S has a point conjugate to γ(0) in the interval (0,π/√δ]. Use Jacobi’s theorems to showthatthisimpliesthatS iscompactandthatthediameterp(S) ≤ π/√δ (this gives a new proof of Bonnet’s theorem of Sec. 5-4).

- 2. (Lines on Complete Surfaces.) A geodesic γ: (−∞,∞) → S is called a line if its length realizes the (intrinsic) distance between any two of its points.


- a. Showthatthrougheachpointofthecompletecylinderx2 +y2 = 1there passes a line.
- b. Assume that S is a complete surface with Gaussian curvature K > 0. Let γ: (−∞,∞) → S be a geodesic on S and let J(s) be a Jacobi ﬁeld along γ given by ?J(0),γ′(0)? = 0, |J(0)| = 1, J′(0) = 0. Choose an orthonormal basis {e1(0) = γ′(0),e2(0)} at Tγ(0)(S) and extend it


[Page 446]

by parallel transport along γ to obtain a basis {e1(s),e2(s)} at each Tγ(0)(S). Show that J(s) = u(s)e2(s) for some function u(s) and that the Jacobi equation for J is

u′′ +Ku = 0, u(0) = 1, u′(0) = 0. (∗)

- c. Extend to the present situation the comparison theorem of part b of Exercise 3, Sec. 5-5. Use the fact that K > 0 to show that it is possible to choose ǫ > 0 sufﬁciently small so that

u(ǫ) > 0, u(−ǫ) > 0, u′(ǫ) < 0, u′(−ǫ) > 0, where u(s) is a solution of (∗). Compare (∗) with

v′′(s) = 0, v(ǫ) = u(ǫ), v′(ǫ) = u′(ǫ), for s ∈ [ǫ,∞) and with

w′′(s) = 0, w(−ǫ) = u(−ǫ), w′(−ǫ) = u′(−ǫ), for s ∈ (−∞,−ǫ]

to conclude that if s0 is sufﬁciently large, then J(s) has two zeros in the interval (−s0,s0).

- d. Use the above to prove that a complete surface with positive Gaussian curvature contains no lines.


###### 5-10. Abstract Surfaces; Further Generalizations

In Sec. 5-11, we shall prove a theorem, due to Hilbert, which asserts that there exists no complete regular surface in R3 with constant negative Gaussian curvature.

Actually, the theorem is somewhat stronger. To understand the correct statement and the proof of Hilbert’s theorem, it will be convenient to introduce the notion of an abstract geometric surface which arises from the following considerations.

So far the surfaces we have dealt with are subsets S of R3 on which differentiable functions make sense. We deﬁned a tangent plane Tp(S) at each p ∈ S and developed the differential geometry around p as the study of the variation of Tp(S). We have, however, observed that all the notions of the intrinsic geometry (Gaussian curvature, geodesics, completeness, etc.) only depended on the choice of an inner product on each Tp(S). If we are able to deﬁne abstractly (that is, with no reference to R3) a set S on which differentiable functions make sense, we might eventually extend the intrinsic geometry to such sets.

The deﬁnition below is an outgrowth of our experience in Chap. 2. Historically, ittookalongtimetoappear, probablyduetothefactthatthefundamental

[Page 447]

role of the change of parameters in the deﬁnition of a surface in R3 was not clearly understood.

DEFINITION 1. An abstract surface (differentiable manifold of dimension 2) is a set S together with a family of one-to-one maps xα: Uα → S of open sets Uα ⊂ R2 into S such that

- 1.

?

α xα(Uα) = S.

- 2. For each pair α, β with xα(Uα)∩xβ(Uβ) = W ?= φ, we have that


xα−1(W), x−1

β (W) are open sets in R2, and x−1

β ◦xα,xα−1 ◦xβ are differentiable maps (Fig. 5-46).

W = xα(Uα )∩ xβ(Up)

xα

xβ

S

Uα

x–1α(W)

xβ–1(W)

x–1α . xβ

Uβ

p

###### Figure 5-46

The pair (Uα,xα) with p ∈ xα(Uα) is called a parametrization (or coordinate system) of S around p. xα(Uα) is called a coordinate neighborhood, and if q = xα(uα,vα) ∈ S, we say that (uα,vα) are the coordinates of q in this coordinate system. The family {Uα,xα} is called a differentiable structure for S.

We say that a set V ⊂ S is an open set if xα−1(V ) is open in R2 for all α. It follows immediately from condition 2 that the “change of parameters”

x−1

β ◦xα: x−1

α (W) → x−1

β (W) is a diffeomorphism.

Remark 1. It is sometimes convenient to add a further axiom to Def. 1 and say that the differentiable structure should be maximal relative to

[Page 448]

conditions 1 and 2. This means that the family {Uα,xα} is not properly contained in any other family of coordinate neighborhoods satisfying conditions 1 and 2.

Acomparisonoftheabovedeﬁnitionwiththedeﬁnitionofaregularsurface inR3 (Sec. 2-2, Def. 1)showsthatthemainpointistoincludethelawofchange of parameters (which is a theorem for surfaces in R3, cf. Sec. 2-3, Prop. 1) in the deﬁnition of an abstract surface. Since this was the property which allowed us to deﬁne differentiable functions on surfaces in R3 (Sec. 2-3, Def. 1), we may set

DEFINITION 2. Let S1 and S2 be abstract surfaces. A map ϕ: S1 → S2 is differentiable at p ∈ S1 if given a parametrization y: V ⊂ R2 → S2 around ϕ(p) there exists a parametrization x: U ⊂ R2 → S1 around p such that ϕ(x(U)) ⊂ y(V) and the map

y−1 ◦ϕ ◦x: U ⊂ R2 → R2 (1)

is differentiable at x−1(p). ϕ is differentiable on S1 if it is differentiable at every p ∈ S1 (Fig. 5-47).

It is clear, by condition 2, that this deﬁnition does not depend on the choices of the parametrizations. The map (1) is called the expression of ϕ in the parametrizations x, y.

U

x

y

y(V)

x(U)

p

y–1°φ°x

φ(x(U))

φ(p)

S1

S2

V

φ

###### Figure 5-47

[Page 449]

Thus, on an abstract surface it makes sense to talk about differentiable functions, andwehavegiventheﬁrststeptowardthegeneralizationofintrinsic geometry.

- Example 1. Let S2 = {(x,y,z) ∈ R3; x2 +y2 +z2 = 1} be the unit sphere and let A: S2 → S2 be the antipodal map; i.e., A(x,y,z) = (−x,−y,−z). Let P2 be the set obtained from S2 by identifying p with A(p) and denote by π: S2 → P2 the natural map π(p) = {p,A(p)}. Cover S2 with parametrizations xα: Uα → S2 such that xα(Uα)∩A◦xα(Uα) = φ. From the fact that S2 is a regular surface and A is a diffeomorphism, it follows that P2 together with the family {Uα,π ◦xα} is an abstract surface, to be denoted again by P2. P2 is called the real projective plane.
- Example 2. Let T ⊂ R3 be a torus of revolution (Sec. 2-2, Example 4) with center in (0,0,0) ∈ R3 and Jet A: T → T be deﬁned by A(x,y,z) = (−x,−y,−z) (Fig. 5-48). Let K be the quotient space of T by the equivalence relation p ∼ A(p) and denote by π: T → K the map π(p) = {p,A(p)}. Cover T with parametrizations xα: Uα → T such that xα(Uα)∩A◦xα(Uα) = φ. As before, it is possible to prove that K with the family {Uα,π ◦xα} is an abstract surface, which is called the Klein bottle.


A (p)

p

###### Figure 5-48

Now we need to associate a tangent plane to each point of an abstract surface S. It is again convenient to use our experience with surfaces in R3 (Sec. 2-4). There the tangent plane was the set of tangent vectors at a point, a tangent vector at a point being deﬁned as the velocity at that point of a curve on the surface. Thus, we must deﬁne what the tangent vector of a curve on an abstract surface is. Since we do not have the support of R3, we must search for a characteristic property of tangent vectors to curves which is independent of R3.

Thefollowingconsiderationswillmotivatethedeﬁnitiontobegivenbelow. Let α: (−ǫ,ǫ) → R2 be a differentiable curve in R2, with α(0) = p. Write

[Page 450]

α(t) = (u(t),v(t)), t ∈ (−ǫ,ǫ), and α′(0) = (u′(0),v′(0)) = w. Let f be a differentiable function deﬁned in a neighborhood of p. We can restrict f to α and write the directional derivative of f relative to w as follows:

d(f ◦α) dt ?

t=0

= ?

∂f ∂u

du dt +

∂f ∂v

dv dt ?

?

t=0

= ?u′(0)

∂ ∂u +v′(0)

∂ ∂v?f.

Thus, the directional derivative in the direction of the vector w is an operator on differentiable functions which depends only on w. This is the characteristic property of tangent vectors that we were looking for.

DEFINITION 3. A differentiable map α: (−ǫ,ǫ) → S is called a curve on S. Assume that α(0) = p and let D be the set of functions on S which are differentiable at p. The tangent vector to the curve α at t = 0 is the function α′(0): D → R given by

α′(0)(f) =

d(f ◦α) dt ?

t=0

, f ∈ D.

A tangent vector at a point p ∈ S is the tangent vector at t = 0 of some curve α: (−ǫ,ǫ) → S with α(0) = p.

By choosing a parametrization x: U → S around p = x(0,0) we may express both the function f and the curve α in x by f(u,v) and (u(t),v(t)), respectively. Therefore,

α′(0)(f) =

d dt

(f ◦α)?

t=0

=

d dt

(f(u(t),v(t)))?

t=0

= u′(0)?

∂f ∂u?

0

+v′(0)?

∂f ∂v ?

0

= ?u′(0)?

∂ ∂u?

0

+v′(0)?

∂ ∂v?

0

?(f).

This suggests, given coordinates (u,v) around p, that we denote by (∂/∂u)0 the tangent vector at p which maps a function f into (∂f/∂u)0; a similar meaning will be attached to the symbol (∂/∂v)0. We remark that (∂/∂u)0, (∂/∂v)0 may be interpreted as the tangent vectors at p of the “coordinate curves”

u → x(u,0), v → x(0,v), respectively (Fig. 5-49).

From the above, it follows that the set of tangent vectors atp, with the usual operations for functions, is a two-dimensional vector space Tp(S) to be called the tangent space of S at p. It is also clear that the choice of a parametrization

[Page 451]

v

v = v0

u = u0

q

u

x

x(u0,v)

x(u,v0)

x(q)

0

∂ ∂v

∂ ∂u

###### Figure 5-49

x: U → S around p determines an associated basis {(∂/∂u)q,(∂/∂v)q} of Tq(S) for any q ∈ x(U).

With the notion of tangent space, we can extend to abstract surfaces the deﬁnition of differential.

DEFINITION 4. Let S1 and S2 be abstract surfaces and let ϕ: S1 → S2 be a differentiable map. For each p ∈ S1 and each w ∈ Tp(S1), consider a differentiable curve α: (−ǫ,ǫ) → S1, with α(0) = p, α′(0) = w. Set β = ϕ ◦α. The map dϕp: Tp(S1) → Tp(S2) given by dϕp(w) = β′(0) is a well-deﬁned linear map, called the differential of ϕ at p.

The proof that dϕp is well deﬁned and linear is exactly the same as the proof of Prop. 2 in Sec. 2-4.

We are now in a position to take the ﬁnal step in our generalization of the intrinsic geometry.

DEFINITION 5. A geometric surface (Riemannian manifold of dimension 2) is an abstract surface S together with the choice of an inner product ? , ?p at each Tp(S), p ∈ S, which varies differentiably with p in the following sense. For some (and hence all) parametrization x: U → S around p, the functions

E(u,v) = ?

∂ ∂u

,

∂ ∂u?, F(u,v) = ?

∂ ∂u

,

∂ ∂v?, G(u,v) = ?

∂ ∂v

,

∂ ∂v?

are differentiable functions in U. The inner product ? , ? is often called a (Riemannian) metric on S.

It is now a simple matter to extend to geometric surfaces the notions of the intrinsic geometry. Indeed, with the functions E, F, G we deﬁne Christoffel

[Page 452]

symbols for S by system 2 of Sec. 4-3. Since the notions of intrinsic geometry were all deﬁned in terms of the Christoffel symbols, they can now be deﬁned in S.

Thus, covariant derivatives of vector ﬁelds along curves are given by Eq. (1) of Sec. 4-4. The existence of parallel transport follows from Prop. 2 of Sec. 4-4, and a geodesic is a curve such that the ﬁeld of its tangent vectors has zero covariant derivative. Gaussian curvature can be either deﬁned by Eq. (5) of Sec. 4-3 or in terms of the parallel transport, as in done in Sec. 4-5.

That this brings into play some new and interesting objects can be seen by the following considerations. We shall start with an example related to Hilbert’s theorem.

Example 3. Let S = R2 be a plane with coordinates (u,v) and deﬁne an inner product at each point q = (u,v) ∈ R2 by setting

?

∂ ∂u

,

∂ ∂u?

q

= E = 1, ?

∂ ∂u

,

∂ ∂v?

q

= F = 0, ?

∂ ∂v

,

∂ ∂v?

q

= G = e2u.

- R2 with this inner product is a geometric surface H called the hyperbolic plane. The geometry of H is different from the usual geometry of R2. For instance, the curvature of H is (Sec. 4-3, Exercise 1)


K = −

- 1

- 2√EG ??


Ev √EG

?

v

+?

Gu √EG?

u

? = −

- 1

- 2eu ?


2e2u eu ?

u

= −1.

Actually the geometry of H is an exact model for the non-Euclidean geometry of Lobachewski, in which all the axioms of Euclid, except the axiom of parallels, are assumed (cf. Sec. 4-5). To make this point clear, we shall compute the geodesics of H.

If we look at the differential equations for the geodesics when E = 1,

- F = 0 (Sec. 4-6, Exercise 2), we see immediately that the curves v = const. are geodesics. To ﬁnd the other ones, it is convenient to deﬁne a map


φ: H → R+2 = {(x,y) ∈ R2;y > 0} by φ(u,v) = (v,e−u). It is easily seen that φ is differentiable and, since y > 0, that it has a differentiable inverse. Thus, φ is a diffeomorphism, and we can induce an inner product in R+2 by setting

?dφ(w1),dφ(w2)?φ(q) = ?w1,w2?q. To compute this inner product, we observe that

∂ ∂x =

∂ ∂v

,

∂ ∂y = −eu

∂ ∂u

,

[Page 453]

hence,

?

∂ ∂x

,

∂ ∂x ? = e2u =

1 y2

, ?

∂ ∂x

,

∂ ∂y ? = 0, ?

∂ ∂y

,

∂ ∂y ? =

1 y2

.

R+2 with this inner product is isometric to H, and it is sometimes called the Poincaré half-plane.

To determine the geodesics of H, we work with the Poincaré half-plane and make two further coordinate changes.

First, ﬁx a point (x0,0) and set (Fig. 5-50) x −x0 = ρ cosθ, y = ρ sin θ,

p

γ

x0

ρ

θ

Parallels to γ through p

###### Figure 5-50

0 < θ < π, 0 < ρ < +∞. This is a diffeomorphism of R+2 into itself, and ?

∂ ∂ρ

,

∂ ∂ρ ? =

1 ρ2 sin2 θ

, ?

∂ ∂ρ

,

∂ ∂θ ? = 0, ?

∂ ∂θ

,

∂ ∂θ ? =

1 sin2 θ

.

Next, consider the diffeomorphism of R+2 given by (we want to change θ into a parameter that measures the arc length along ρ = const.)

ρ1 = ρ, θ1 = ? θ

0

1 sin θ

dθ,

which yields ?

∂ ∂ρ1

,

∂ ∂ρ1? =

1 ρ12 sin2 θ

, ?

∂ ∂ρ1

,

∂ ∂θ1? = 0, ?

∂ ∂θ1

,

∂ ∂θ1? = 1.

[Page 454]

By looking again at the differential equations for the geodesics (F = 0,

- G = 1), we see that ρ1 = ρ = const. are geodesics. (Another way of ﬁnding


the geodesics of R+2 is given in Exercise 8.)

Collecting our observations, we conclude that the lines and the half-circles which are perpendicular to the axis y > 0 are geodesics of the Poincaré halfplane R+2 . These are all the geodesics of R+2 , since through each point q ∈ R+2 andeachdirectionissuingfrom q therepasseseitheracircletangenttothatline and normal to the axis y = 0 or a vertical line (when the direction is vertical).

The geometric surface R+2 is complete; that is, geodesics can be deﬁned for all values of the parameter. The proof of this fact will be left as an exercise (Exercise 7; cf. also Exercise 6).

It is now easy to see, if we deﬁne a straight line of R+2 to be a geodesic, that all the axioms of Euclid but the axiom of parallels hold true in this geometry. The axiom of parallels in the Euclidean plane P asserts that from a point not in a straight line r ⊂ P one can draw a unique straight line r′ ⊂ P that does not meet r. Actually, in R+2 , from a point not in a geodesic γ we can draw an inﬁnite number of geodesics which do not meet γ.

The question then arises whether such a surface can be found as a regular surface in R3. The natural context for this question is the following deﬁnition.

DEFINITION 6. A differentiable map ϕ: S → R3 of an abstract surface

- S into R3 is an immersion if the differential dϕp: Tp(S) → Tp(R3) is injective. If, in addition, S has a metric ? , ? and


?dϕp(v),dϕp(w)?ϕ(p) = ?v,w?p, v,w ∈ Tp(S), ϕ is said to be an isometric immersion.

Notice that the ﬁrst inner product in the above relation is the usual inner product of R3, whereas the second one is the given Riemannian metric on S. This means that in an isometric immersion, the metric “induced” by R3 on S agrees with the given metric on S.

Hilbert’stheorem, tobeprovedinSec. 5-11, statesthatthereisnoisometric immersion into R3 of the complete hyperbolic plane. In particular, one cannot ﬁnd a model of the geometry of Lobachewski as a regular surface in R3.

Actually, there is no need to restrict ourselves to R3. The above deﬁnition of isometric immersion makes perfect sense when we replace R3 by R4 or, for that matter, by an arbitrary Rn. Thus, we can broaden our initial question, and ask: For what values of n is there an isometric immersion of the complete hyperbolic plane into Rn? Hilbert’s theorem say that n ≥ 4.As far as we know, the case n = 4 is still unsettled.

Thus, the introduction of abstract surfaces brings in new objects and illuminates our view of important questions.

In the rest of this section, we shall explore in more detail some of the ideas just introduced and shall show how they lead naturally to further important

[Page 455]

generalizations. This part will not be needed for the understanding of the next section.

Let us look into further examples.

Example 4. Let R2 be a plane with coordinates (x,y) and Tm,n: R2 → R2 be the map (translation) Tm,n(x,y) = (x +m,y +n), where m and n are integers. DeﬁneanequivalencerelationinR2 by(x,y) ∼ (x1,y1)ifthereexist integers m, n such that Tm,n(x,y) = (x1,y1). Let T be the quotient space of R2 by this equivalence relation, and let π: R2 → T be the natural projection map π(x,y) = {Tm,n(xy); all integers m, n}. Thus, in each open unit square whose vertices have integer coordinates, there is only one representative of T , and T may be thought of as a closed square with opposite sides identiﬁed. (See Fig. 5-51. Notice that all points of R2 denoted by x represent the same point p in T .)

Let iα: Uα ⊂ R2 → R2 be a family of parametrizations of R2, where iα is the identity map, such that Uα ∩Tm,n(Uα) = φ for all m, n. Since Tm,n is a diffeomorphism, it is easily checked that the family (Uα,π ◦iα) is a differentiable structure for T . T is called a (differentiable) torus. From the very

x

T p

π

0

y

###### Figure 5-51. The torus.

[Page 456]

deﬁnition of the differentiable structure on T , π: R2 → T is a differentiable map and a local diffeomorphism (the construction made in Fig. 5-51 indicates that T is diffeomorphic to the standard torus in R3).

Now notice that Tm,n is an isometry of R2 and introduce a geometric (Riemannian) structure on T as follows. Let p ∈ T and v ∈ Tp(T ). Let q1,q2 ∈ R2 and w1,w2 ∈ R2 be such that π(q1) = π(q2) = p and dπq1(w1) = dπq2(w2) = v. Then q1 ∼ q2; hence, there exists Tm,n such that Tm,n(q1) = q2, d(Tm,n)q1(w1) = w2. Since Tm,n is an isometry, |w1| = |w2|. Now, deﬁne the length of v in Tp(T ) by |v| = |dπq(w1)| = |w1|. By what we have seen. this is well deﬁned. Clearly this gives rise to an inner product ? , ?p, on Tp(T ) for each p ∈ T . Since this is essentially the inner product of R2 and π is a local diffeomorphism, ? , ?p, varies differentiably with p.

Observe that the coefﬁcients of the ﬁrst fundamental form of T , in any of the parametrizations of the family {Uα,π ◦iα} are E = G = 1, F = 0. Thus, this torus behaves locally like a Euclidean space. For instance, its Gaussian curvature is identically zero (cf. Exercise 1, Sec. 4-3). This accounts for the name ﬂat torus, which is usually given to T with the inner product just described.

Clearly the ﬂat torus cannot be isometrically immersed in R3, since, by compactness, it would have a point of positive curvature (cf. Exercise 16, Sec. 3-3, or Lemma 2, Sec. 5-2). However, it can be isometrically immersed in R4.

In fact, let F: R2 → R4 be given by

F(x,y) =

1 2π

(cos2πx,sin 2πx,cos2πy,sin 2πy).

Since F(x +m,y +n) = F(x,y) for all m, n, we can deﬁne a map ϕ: T → R4 by ϕ(p) = F(q), where q ∈ π−1(p). Clearly, ϕ ◦π = F, and since π: R2 → T is a local diffeomorphism, ϕ is differentiable. Furthermore, the rank of dϕ is equal to the rank of dF, which is easily computed to be 2. Thus, ϕ is an immersion. To see that the immersion is isometric, we ﬁrst observe that if e1 = (1,0), e2 = (0,1) are the vectors of the canonical basis in R2, the vectors dπq(e1) = f1, dπq(e2) = f2, q ∈ R2, form a basis for Tπ(q)(T ). By deﬁnition of the inner product on T , ?fi,fj? = ?ei,ej?, i,j = 1,2. Next, we compute

∂F

- ∂x = dF(e1) = (−sin 2πx,cos2πx,0,0), ∂F

- ∂y = dF(e2) = (0,0,−sin 2πy,cos2πy),


and obtain that

?dF(ei),dF(ej)? = ?ei,ej? = ?fi,fj?.

[Page 457]

Thus,

?dϕ(fi),dϕ(fj)? = ?dϕ(dπ(ei)),dϕ(dπ(ej))? = ?fi,fj?. It follows that ϕ is an isometric immersion, as we had asserted.

It should be remarked that the image ϕ(S) of an immersion ϕ: S → Rn may have self-intersections. In the previous example, ϕ: T → R4 is one-to-one, and furthermore ϕ is a homeomorphism onto its image.It is convenient to use the following terminology.

DEFINITION 7. Let S be an abstract surface. A differentiable map ϕ: S → Rn is an embedding if ϕ is an immersion and a homeomorphism onto its image.

For instance, a regular surface in R3 can be characterized as the image of an abstract surface S by an embedding ϕ: S → R3. This means that only those abstract surfaces which can be embedded in R3 could have been detected in our previous study of regular surfaces in R3. That this is a serious restriction can be seen by the example below.

Example 5. Weﬁrstremarkthatthedeﬁnitionoforientability(cf. Sec.2-6, Def. 1) can be extended, without changing a single word, to abstract surfaces. Now consider the real projective plane P2 of Example 1. We claim that P2 is nonorientable.

To prove this, we ﬁrst make the following general observation. Whenever an abstract surface S contains an open set M diffeomorphic to a Möbius strip (Sec. 2-6, Example 3), it is nonorientable. Otherwise, there exists a family of parametrizations covering S with the property that all coordinate changes have positive Jacobian; the restriction of such a family to M will induce an orientation on M which is a contradiction.

Now, P2 is obtained from the sphere S2 by identifying antipodal points. Consider on S2 a thin strip B made up of open segments of meridians whose centers lay on half an equator (Fig. 5-52). Under identiﬁcation of antipodal points, B clearly becomes an open Möbius strip in P2. Thus, P2 is nonorientable.

Figure 5.52. The projective plane contains a Möbius strip.

[Page 458]

Byasimilarargument, itcanbeshownthattheKleinbottle K ofExample2 is also nonorientable. In general, whenever a regular surface S ⊂ R3 is symmetric relative to the origin of R3, identiﬁcation of symmetric points gives rise to a nonorientable abstract surface.

It can be proved that a compact regular surface in R3 is orientable (cf. Remark 2, Sec. 2-7). Thus, P2 and K cannot be embedded in R3, and the same happens to the compact nonorientable surfaces generated as above. Thus, we miss quite a number of surfaces in R3.

P2 and K can, however, be embedded in R4. For the Klein bottle K, consider the map G: R2 → R4 given by

G(u,v) = ?(r cosv +a)cosu,(r cosv +a)sin u,

r sin v cos

u 2

,r sin v sin

u 2?.

Notice that G(u,v) = G(u+2mπ,2nπ −v), where m and n are integers. Thus, G induces a map ψ of the space obtained from the square

[0,2π]×[0,2π] ⊂ R2

by ﬁrst reﬂecting one of its sides in the center of this side and then identifying opposite sides (see Fig. 5-53). That this is the Klein bottle, as deﬁned in Example 2, can be seen by throwing away an open half of the torus in which antipodal points are being identiﬁed and observing that both processes lead to the same surface (Fig. 5-53).

| | |
|---|---|


Klein bottle immersed in R3 with self-intersections

###### Figure 5-53

[Page 459]

Thus, ψ is a map of K into R4. Observe further that G(u+4mπ,v +2mπ) = G(u,v).

It follows that G = ψ ◦π1 ◦π, where π: R2 → T is essentially the natural projection on the torus T (cf. Example 4) and π1: T → K corresponds to identifying “antipodal” points in T . By the deﬁnition of the differentiable structures on T and K, π and π1 are local diffeomorphisms. Thus, ψ: K → R4 is differentiable, and the rank of dψ is the same as the rank of dG. The latter is easily computed to be 2; hence, ψ is an immersion. Since K is compact and ψ is one-to-one, ψ−1 is easily seen to be continuous in ϕ(K). Thus, ψ is an embedding, as we wished.

For the projective plane P2, consider the map F: R3 → R4 given by F(x,y,z) = (x2 −y2,xy,xz,yz).

Let S2 ⊂ R3 be the unit sphere with center in the origin of R3. It is clear that the restriction ϕ = F/S2 is such that ϕ(p) = ϕ(−p). Thus, ϕ induces a map

ϕ˜: P2 → R4 by ϕ(˜ {p,−p}) = ϕ(p).

To see that ϕ (hence, ϕ˜) is an immersion, consider the parametrization x of S2 given by x(x,y) = (x,y,+?

1−x2 −y2, where x2 +y2 ≤ 1. Then ϕ ◦x(x,y) = (x2 −y2,xy,xD,yD), D = ?

1−x2 −y2.

It is easily checked that the matrix of d(ϕ ◦x) has rank 2. Thus, ϕ˜ is an immersion.

To see that ϕ˜ is one-to-one, set x2 −y2 = a, xy = b, xz = c, yz = d. (2)

It sufﬁces to show that, under the condition x2 +y2 +z2 = 1, the above equationshaveonlytwosolutionswhichareoftheform(x,y,z)and(−x,−y,−z). In fact, we can write

x2d = bc, y2c = bd, z2b = cd, x2 −y2 = a,

x2 +y2 +z2 = 1

###### (3)

where the ﬁrst three equations come from the last three equations of (2).

Now, if one of the numbers b,c,d is nonzero, the equations in (3) will give x2, y2, and z2, and the equations in (2) will determine the sign of two coordinates, once given the sign of the remaining one. If b = c = d = 0, the equations in (2) and the last equation of (3) show that exactly two coordinates

[Page 460]

will be zero, the remaining one being ±1. In any case, the solutions have the required form, and ϕ˜ is one-to-one.

By compactness, ϕ is an embedding, and that concludes the example. Ifwelookbacktothedeﬁnitionofabstractsurface, weseethatthenumber2

has played no essential role. Thus, we can extend that deﬁnition to an arbitrary n and, as we shall see presently, this may be useful.

DEFINITION 1a. A differentiable manifold of dimension n is a set M together with a family of one-to-one maps xα: Uα → M of open sets Uα ⊂ Rn into M such that

- 1.

?

α

xα(Uα) = M.

- 2. For each pair α, β with xα(Uα)∩xβ(Uβ) = W ?= φ, we have that

xα−1(W), x−1

β (W) are open sets in Rn and that x−1

β ◦xα, xα−1 ◦xβ are differentiable maps.

- 3. The family {Uα,xα} is maximal relative to conditions 1 and 2.


A family {Uα,xα} satisfying conditions 1 and 2 is called a differentiable structure on M. Given a differentiable structure on M we can easily complete it intoamaximal one by adding toit all possibleparametrizations that, together with some parametrization of the family {Uα,xα}, satisfy condition 2. Thus, with some abuse of language, we may say that a differentiable manifold is a set together with a differentiable structure.

Remark. A family of open sets can be deﬁned in M by the following

requirement: V ⊂ M is an open set if for every α, xα−1(V ∩xα(Uα)) is an open set in Rn. The readers with some knowledge of point set topology will

notice that such a family deﬁnes a natural topology on M. In this topology, the maps xα are continuous and the sets xα(Uα) are open in M. In some deeper theorems on manifolds, it is necessary to impose some conditions on the natural topology of M.

The deﬁnitions of differentiable maps and tangent vector carry over, word by word, to differentiable manifolds. Of course, the tangent space is now an n-dimensional vector space. The deﬁnitions of differential and orientability also extend straightforwardly to the present situation.

Inthefollowingexampleweshallshowhowquestionsontwo-dimensional manifolds lead naturally into the consideration of higher-dimensional manifolds.

Example 6. (The Tangent Bundle). Let S be an abstract surface and let

- T (S) = {(p,w), p ∈ S, w ∈ Tp(S)}. We shall show that the set T (S) can be givenadifferentiablestructure(ofdimension4)tobecalledthetangentbundle of S.


[Page 461]

Let {Uα,xα} be a differentiable structure for S. We shall denote by (uα,vα) the coordinates of Uα, and by {∂/∂uα,∂/∂vα} the associated bases in the tangent planes of xα(Uα). For each α, deﬁne a map yα: Uα ×R2 → T (S) by

yα(uα,vα,x,y) = ?xα(uα,vα),x

∂ ∂uα +y

∂ ∂vα ?, (x,y) ∈ R2.

Geometrically, this means that we shall take as coordinates of a point (p,w) ∈ T (S) the coordinates uα,vα of p plus the coordinates of w in the basis {∂/∂uα,∂/∂vα}.

We shall show that {Uα ×R2,yα} is a differentiable structure for T (S). Since

?

α xα(Uα) = S and (dxα)q(R2) = Txα(q)(S), q ∈ Uα, we have that ?

α

yα(Uα ×R2) = T (S),

and that veriﬁes condition 1 of Def. 1a. Now let

(p,w) ∈ yα(Uα ×R2)∩yβ(Uβ ×R2). Then

(p,w) = (xα(qα),dxα(wα)) = (yβ(qβ),dxβ(wβ)), where qα ∈ Uα, qβ ∈ Uβ, wα,wβ ∈ R2. Thus,

y−1

β ◦yα(qα,wα) = y−1

β (xα(qα),dxα(wα))

= ((x−1

β ◦xα)(qα),d(x−1

β ◦xα)(wα)). Since x−1

β ◦xα is differentiable, so is d(x−1

β ◦xα). It follows that y−1

β ◦yα is differentiable, and that veriﬁes condition 2 of Def. 1a.

The tangent bundle of S is the natural space to work with when one is dealing with second-order differential equations on S. For instance, the equations of a geodesic on a geometric surface S can be written, in a coordinate neighborhood, as (cf. Sec. 4-7)

u′′ = f1(u,v,u′,v′), v′′ = f2(u,v,u′,v′).

The classical “trick” of introducing new variables x = u′, y = v′ to reduce the above to the ﬁrst-order system

x′ = f1(u,v,x,y), y′ = f2(u,v,x,y),

- u′ = f3(u,v,x,y),
- v′ = f4(u,v,x,y)


###### (4)

[Page 462]

may be interpreted as bringing into consideration the tangent bundle T (S), with coordinates (u,v,x,y) and as looking upon the geodesics as trajectories of a vector ﬁeld given locally in T (S) by (4). It can be shown that such a vector ﬁeld is well deﬁned in the entire T (S); that is, in the intersection of two coordinate neighborhoods, the vector ﬁelds given by (4) agree. This ﬁeld (or rather its trajectories) is called the geodesic ﬂow on T (S). It is a very natural object to work with when studying global properties of the geodesics on S.

By looking back to Sec. 4-7, it will be noticed that we have used, in a disguised form, the manifold T (S). Since we were interested only in local properties, wecouldgetalongwithacoordinateneighborhood(whichisessentially an open set of R4). However, even this local work becomes neater when the notion of tangent bundle is brought into consideration.

Of course, we can also deﬁne the tangent bundle of an arbitrary ndimensional manifold. Except for notation, the details are the same and will be left as an exercise.

We can also extend the deﬁnition of a geometric surface to an arbitrary dimension.

DEFINITION 5a. A Riemannian manifold is an n-dimensional differentiable manifold M together with a choice, for each p ∈ M, of an inner product ? , ?p in Tp(M) that varies differentiably with p in the following sense. For some (hence, all) parametrization xα: Uα → M with p ∈ xα(Uα), the functions

gij(u1 ...,un) = ?

∂ ∂ui

,

∂ ∂uj?, i,j = 1,...,n,

are differentiable at xα−1(p); here (u1,...,un) are the coordinates of Uα ⊂ Rn.

The differentiable family {? ?p,p ∈ M} is called a Riemannian structure (or Riemannian metric) for M.

Notice that in the case of surfaces we have used the traditional notation g11 = E, g12 = g21 = F, g22 = G.

The extension of the notions of the intrinsic geometry to Riemannian manifolds is not so straightforward as in the case of differentiable manifolds.

First, we must deﬁne a notion of covariant derivative for Riemannian manifolds. For this, let x: U → M be a parametrization with coordinates (u1,...,un) and set xi = ∂/∂ui. Thus, gij = ?xi,xj?.

We want to deﬁne the covariant derivative Dwv of a vector ﬁeld v relative to a vector ﬁeld w. We would like Dwv to have the properties we are used to and that have shown themselves to be effective in the past. First, it should have the distributive properties of the old covariant derivative. Thus, if u, v,

- w are vector ﬁelds on M and f , g are differentiable functions on M, we want Dfu+gw(v) = fDuv +gDwv, (5)


[Page 463]

Du(fv +gw) = fDuv +

∂f ∂u

v +gDuw +

∂g ∂u

###### w, (6)

where∂f/∂u, forinstance, isafunctionwhosevalueatp ∈ M isthederivative (f ◦α)′(0) of the restriction of f to a curve α: (−ǫ,ǫ) → M, α(0) = p, α′(0) = u.

Equations (5) and (6) show that the covariant derivative D is entirely determined once we know its values on the basis vectors

Dxixj =

?n

k=1

Ŵijk xk, i,j,k = 1,...,n,

where the coefﬁcients Ŵijk arc functions yet to be determined. Second, we want the Ŵijk to be symmetric in i and j(Ŵijk = Ŵjik ); that is,

Dxixj = Dxjxi for all i,j. (7) Third, we want the law of products to hold; that is,

∂

∂uk ?xi,xj? = ?Dxkxi,xj?+?xi,Dxkxj?. (8) From Eqs. (7) and (8), it follows that

∂ ∂uk ?xixj?+

∂ ∂ui ?xj,xk?−

∂

∂uj ?xk,xi? = 2?Dxixk,xj?, or, equivalently,

∂ ∂uk

gij +

∂ ∂ui

gjk −

∂ ∂uj

gki = 2

?

i

Ŵiki gij.

Since det(gij) ?= 0, we can solve the last system, and obtain the Ŵijk as functions of the Riemannian metric gij and its derivatives (the reader should compare the system above with system (2) of Sec. 4-3). If we think of gij as a matrix and write its inverse as gij, the solution of the above system is

Ŵijk =

- 1

- 2 ? l


gkl ?

∂gil ∂uj +

∂gjl ∂ui −

∂gij ∂ul ?.

Thus, given a Riemannian structure for M, there exists a unique covariant derivative on M (also called the Levi-Civita connection of the given Riemannian structure) satisfying Eqs. (5)–(8).

Starting from the covariant derivative, we can deﬁne parallel transport, geodesics, geodesic curvature, the exponential map, completeness, etc.

[Page 464]

The deﬁnitions are exactly the same as those we have given previously. The notion of curvature, however, requires more elaboration. The following concept, due to Riemann, is probably the best analogue in Riemannian geometry of the Gaussian curvature.

Let p ∈ M and let σ ⊂ Tp(M) be a two-dimensional subspace of the tangent space Tp(M). Consider all those geodesics of M that start from p and are tangent to σ. From the fact that the exponential map is a local diffeomorphism at the origin of Tp(M), it can be shown that small segments of such geodesics make up an abstract surface S containing p. S has a natural geometric structure induced by the Riemannian structure of M. The Gaussian curvature of S at p is called the sectional curvature K(p,σ) of M at p along σ.

It is possibletoformalizethesectionalcurvatureintermsoftheLevi-Civita connection but that is too technical to be described here. We shall only mention that most of the theorems in this chapter can be posed as natural questions in Riemannian geometry. Some of them are true with little or no modiﬁcation of the given proofs. (The Hopf-Rinow theorem, the Bonnet theorem, the ﬁrst Hadamard theorem, and the Jacobi theorems are all in this class.) Some others, however, require further assumptions to hold true (the second Hadamard theorem, for instance) and were seeds for further developments.

A full development of the above ideas would lead us into the realm of Riemannian geometry. We must stop here and refer the reader to the bibliography at the end of the book.

###### EXERCISES

- 1. Introduce a metric on the projective plane P2 (cf. Example 1) so that the natural projection π: S2 → P2 is a local isometry. What is the (Gaussian) curvature of such a metric?
- 2. (The Inﬁnite Möbius Strip.) Let C = {(x,y,z) ∈ R3;x2 +y2 = 1}

be a cylinder and A: C → C be the map (the antipodal map) A(x,y,z) = (−x,−y,−z). Let M be the quotient of C by the equivalence relation p ∼ A(p), and let π: C → M be the map π(p) = {p,A(p)}, p ∈ C.

- a. Show that M can be given a differentiable structure so that π is a local diffeomorphism (M is then called the inﬁnite Möbius strip).
- b. Prove that M is nonorientable.
- c. Introduce on M a Riemannian metric so that π is a local isometry. What is the curvature of such a metric?


- 3. a. Show that the projection π: S2 → P2 from the sphere onto the projective plane has the following properties: (1) π is continuous and


[Page 465]

π(S2) = P2; (2) each point p ∈ P2 has a neighborhood U such that π−1(U) = V1 ∪V2, where V1 and V2 are disjoint open subsets of S2, and the restriction of π to each Vi, i = 1,2, is a homeomorphism onto U. Thus, π satisﬁes formally the conditions for a covering map (see Sec. 5-6, Def. 1) with two sheets. Because of this, we say that S2 is an orientable double covering of P2.

b. Show that, in this sense, the torus T is an orientable double covering of the Klein bottle K (cf. Example 2) and that the cylinder is an orientable double covering of the inﬁnite Möbius strip (cf. Exercise 2).

- 4. (The Orientable Double Covering). This exercise gives a general construction for the orientable double covering of a nonorientable surface. Let S be an abstract, connected, nonorientable surface. For each p ∈ S,

consider the set B of all bases of Tp(S) and call two bases equivalent if they are related by a matrix with positive determinant. This is clearly an equivalence relation and divides B into two disjoint sets (cf. Sec. 1-4). Let Op be the quotient space of B by this equivalence relation. Op has two elements, and each element Op ∈ Op is an orientation of Tp(S) (cf. Sec. 1-4).Let S˜ be the set

S˜ = {(p,Op);p ∈ S;Op ∈ Op}.

To give S˜ a differentiable structure, let {Uα,xα} be the maximal differentiable structure of S and deﬁne x˜α: Uα → S˜ by

x˜α(uα,vα) = ?xα(uα,vα),?

∂ ∂uα

,

∂ ∂vα ??,

where (uα,vα) ∈ Uα and [∂/∂uα,∂/∂vα] denotes the element of Op determined by the basis {∂/∂uα,∂/∂vα}. Show that

a. {Uα,x˜α} is a differentiable structure on S˜ and that S˜ with such a

differentiable structure is an orientable surface.

b. The map π: S˜ → S given by π(p,Op) = p is a differentiable surjective map. Furthermore, each point p ∈ S has a neighborhood U such that π−1(U) = V1 ∪V2, where V1 and V2 are disjoint open subsets of S˜ and π restricted to each Vi, i = 1,2, is a diffeomorphism onto U. Because of this, S˜ is called an orientable double covering of S.

- 5. Extend the Gauss-Bonnet theorem (see Sec. 4-5) to orientable geometric surfaces and apply it to prove the following facts:


- a. There is no Riemannian metric on an abstract surface T diffeomorphic to a torus such that its curvature is positive (or negative) at all points of T .


[Page 466]

- b. Let T and S2 be abstract surfaces diffeomorphic to the torus and the sphere, respectively, and let ϕ: T → S2 be a differentiable map. Then ϕ has at least one critical point, i.e., a point p ∈ T such that det(dϕp) = 0.


- 6. Consider the upper half-plane R+2 (cf. Example 3) with the metric


E(x,y) = 1, F(x,y) = 0, G(x,y) =

1 y

, (x,y) ∈ R+2 .

Show that the lengths of vectors become arbitrarily large as we approach the boundary of R+2 and yet the length of the vertical segment

x = 0, 0 < ǫ ≤ y ≤ 1,

approaches 2 as ǫ → 0. Conclude that such a metric is not complete. *7. Prove that the Poincaré half-plane (cf. Example 3) is a complete geometric

surface. Conclude that the hyperbolic plane is complete.

- 8. Another way of ﬁnding the geodesics of the Poincaré half-plane (cf. Example 3) is to use the Euler-Lagrange equation for the corresponding variational problem (cf. Exercise 4, Sec. 5-4). Since we know that the vertical lines are geodesics, we can restrict ourselves to geodesics of the form y = y(x). Thus, we must look for the critical points of the integral (F = 0)

? ?

E +G(y′)2 dx = ? ?

1+(y′)2 y

dx,

since E = G = 1/y2. Use Exercise 4, Sec. 5-4, to show that the solution to this variational problem is a family of circles of the form

(x +k1)2 +y2 = k22, k1,k2 = const.

- 9. Let S˜ and S be connected geometric surfaces and let π: S˜ → S be a surjective differentiable map with the following property: For each p ∈ S,

there exists a neighborhood U of p such that π−1(U) =

?

αVα, where the Vα’s are open disjoint subsets of S˜ and π restricted to each Vα is an isometry onto U (thus, π is essentially a covering map and a local isometry).

- a. Prove that S is complete if and only if S˜ is complete.
- b. Is the metric on the inﬁnite Möbius strip, introduced in Exercise 2, part c, a complete metric?


- 10. (Kazdan-Wamer’s Results.)


- a. Let a metric on R2 be given by E(x,y) = 1, F(x,y) = 0, G(x,y) > 0, (x,y) ∈ R2.


[Page 467]

Show that the curvature of this metric is given by ∂2(√G)

∂x2 +K(x,y)

√

G = 0. (∗)

- b. Conversely, given a function K(x,y) on R2, regard y as a parameter and let √G be the solution of (∗) with the initial conditions


√

G(x0,y) = 1,

∂√G ∂x

(x0,y) = 0.

Prove that G is positive in a neighborhood of (x0,y) and thus deﬁnes a metric in this neighborhood. This shows that every differentiable function is locally the curvature of some (abstract) metric.

*c. Assume that K(x,y) ≤ 0 for all (x,y) ∈ R2. Show that the solution

of part b satisﬁes ?

G(x,y) ≥ ?

G(x0,y) = 1 for all x.

Thus, G(x,y) deﬁnes a metric on all of R2. Prove also that this metric is complete. This shows that any nonpositive differentiable function onR2 isthecurvatureofsomecompletemetriconR2. Ifwedonotinsist on the metric being complete, the result is true for any differentiable function K on R2. Compare J. Kazdan and F. Warner, “Curvature Functions for Open 2-Manifolds,” Ann. of Math. 99 (1974), 203–219, where it is also proved that the condition on K given in Exercise 2 of Sec. 5-4 is necessary and sufﬁcient for the metric to be complete.

###### 5-11. Hilbert’s Theorem

Hilbert’s theorem can be stated as follows.

THEOREM. A complete geometric surface S with constant negative curvature cannot be isometrically immersed in R3.

Remark 1. Hilbert’s theorem was ﬁrst treated in D. Hilbert, “Über Flächen von konstanter Gausscher Krümung,” Trans. Amer. Math. Soc. 2 (1901), 87–99. A different proof was given shortly after by E. Holmgren, “Sur les surfaces à courbure constante negative,” C. R. Acad. Sci. Paris 134 (1902), 740–743. The proof we shall present here follows Hilbert’s original ideas. The local part is essentially the same as in Hilbert’s paper; the global part, however, is substantially different. We want to thank J. A. Scheinkman for helping us to work out this proof.

[Page 468]

We shall start with some observations. By multiplying the inner product by a constant factor, we may assume that the curvature K ≡ −1. Moreover, since expp : Tp(S) → S is a local diffeomorphism (corollary of the theorem of Sec. 5-5), it induces an inner product in Tp(S). Denote by S′ the geometric surfaceTp(S)withthisinnerproduct. Ifψ:S → R3 isanisometricimmersion, the same holds for ϕ = ψ ◦expp : S′ → R3. Thus, we are reduced to proving that there exists no isometric immersion ϕ: S′ −R3 of a plane S′ with an inner product such that K ≡ −1.

LEMMA 1. The area of S′ is inﬁnite. Proof. We shall prove that S′ is (globally) isometric to the hyperbolic

plane H. Since the area of the latter is (cf. Example 3, Sec. 5-10) ? +∞

−∞

? +∞

−∞

eu du dv = ∞,

this will prove the lemma.

Let p ∈ H, p′ ∈ S′, and choose a linear isometry ψ: Tp(H) → Tp′(S′) between their tangent spaces. Deﬁne a map ϕ: H → S′ by ϕ = expp ◦ψ ◦ exp−1

p . Since each point of H is joined to p by a unique minimal geodesic, ϕ is well deﬁned.

We now use polar coordinates (p,θ) and (p′,θ′) around p and p′, respectively, requiring that ϕ maps the axis θ = 0 into the axis θ′ = 0. By the results of Sec. 4-6, ϕ preserves the ﬁrst fundamental form; hence, it is locally an isometry. By using the remark made after Hadamard’s theorem, we conclude that ϕ is a covering map. Since S′ is simply connected, ϕ is a homeomorphism, and hence a (global) isometry. Q.E.D.

For the rest of this section we shall assume that there exists an isometric immersion ϕ: S′ → R3, where S′ is a geometric surface homeomorphic to a plane and with K ≡ −1.

Toavoidthedifﬁcultiesassociatedwithpossibleself-intersectionsofϕ(S′), we shall work with S′ and use the immersion ϕ to induce on S′ the local extrinsic geometry of ϕ(S′) ⊂ R3. More precisely, since ϕ is an immersion, for each p ∈ S′ there exists a neighborhood V ′ ⊂ S′ of p such that the restriction ϕ|V ′ = ϕ˜ is a diffeomorphism. At each ϕ(q)˜ ∈ ϕ(V˜ ′), there exist, for instance, two asymptotic directions. Through ϕ˜, these directions induce two directions at q ∈ S′, which will be called the asymptotic directions on S′ at q. In this way, it makes sense to talk about asymptotic curves on S′, and the same procedure can be applied to any other local entity of ϕ(S′).

We now recall that the coordinate curves of a parametrization constitute a Tchebyshef net if the opposite sides of any quadrilateral formed by them have equal length (cf. Exercise 7, Sec. 2-5). If this is the case, it is possible to reparametrize the coordinate neighborhood in such a way that E = 1,

[Page 469]

F = cosθ, G = 1, where θ is the angle formed by the coordinate curves, (Sec. 2-5, Exercise 8). Furthermore, in this situation, K = −(θuv/sin θ) (Sec. 4-3, Exercise 5).

LEMMA 2. For each p ∈ S′ there is a parametrization x: U ⊂ R2 → S′, p ∈ x(U), such that the coordinate curves of x are the asymptotic curves of x(U) = V′ and form a Tchebyshef net (we shall express this by saying that the asymptotic curves of V′ form a Tchebyshef net).

Proof. Since K < 0, a neighborhood V ′ ⊂ S′ of p can be parametrized by x(u,v) in such a way that the coordinate curves of x are the asymptotic curves of V ′. Thus, if e, f , and g are the coefﬁcients of the second fundamental form of S′ in this parametrization, we have e = g = 0. Notice that we are using the above convention of referring to the second fundamental form of S′ rather than the second fundamental form of ϕ(S′) ⊂ R3.

Now ϕ(V ′) ⊂ R3, we have

Nu ∧Nv = K(xu ∧xv); hence, setting D =

√EG−F2,

(N ∧Nv)u −(N ∧Nu)v = 2(Nu ∧Nv) = 2KDN. Furthermore,

N ∧Nu =

1 D{(xu ∧xv)∧Nu} =

1 D{?xu,Nu?xv −?xv,Nu?xu}

=

1 D

(f xu −exv), and, similarly,

N ∧Nv =

1 D

(gxu −f xv). Since K = −1 = −(f2/D2) and e = g = 0, we obtain

N ∧Nu = ±xu, N ∧Nv = ±xv; hence

2KDN = −2DN = ±xuv±xvu = ±2xuv.

It follows that xuv is parallel to N; hence, Ev = 2?xuv,xu? = 0 and Gu = 2?xuv,xv? = 0. But Ev = Gu = 0 implies (Sec. 2-5, Exercise 7) that the coordinate curves form a Tchebysbef net. Q.E.D.

LEMMA 3. Let V′ ⊂ S′ be a coordinate neighborhood of S′ such that the coordinate curves are the asymptotic curves in V′. Then the area A of any quadrilateral formed by the coordinate curves is smaller than 2π.

[Page 470]

Proof. Let (u,¯ v)¯ be the coordinates of V ′. By the argument of Lemma 2 the coordinate curves form a Tchebysbef net. Thus, it is possible to reparametrize V ′ by, say, (u,v) so that E = G = 1 and F = cosθ. Let R be a quadrilateral that is formed by the coordinate curves with vertices (u1,v1),(u2,v1),(u2,v2),(u1,v2) and interior angles α1, α2, α3, α4, respectively (Fig. 5-54). Since E = G = 1, F = cosθ, and θuv = sin θ, we obtain

A = ?

R

dA = ?

R

sin θ du dv = ?

R

θuv du dv

= θ(u1,v1)−θ(u2,v1)θ +θ(u2,v2)−θ(u1,v2)

= α1 +α3 −(π −α2)−(π −α4) =

?4

i=1

αi −2π < 2π,

since αi < π. Q.E.D.

u = u1 u = u2

v = v2

v = v1

(u1,v2)

(u2,v2)

(u1,v1) (u2,v1)

R a1 a2

a4 a3

###### Figure 5-54

So far the considerations have been local. We shall now deﬁne a map

- x: R2 → S′ and show that x is a parametrization for the entire S′. The map x is deﬁned as follows (Fig. 5-55). Fix a point O ∈ S′ and choose


orientations on the asymptotic curves passing through O. Make a deﬁnite choice of one of these asymptotic curves, to be called a1, and denote the other onebya2. Foreach(s,t) ∈ R2, layoffona1 alengthequaltos startingfromO.

- Let p′ bethepointthusobtained. Throughp′ therepasstwoasymptoticcurves, one of which is a1. Choose the other one and give it the orientation obtained by the continuous extension, along a1, of the orientation of a2. Over this oriented asymptotic curve lay off a length equal to t starting from p′. The point so obtained is x(s,t).

x(s,t) is well deﬁned for all (s,t) ∈ R2. In fact, if x(s,0) is not deﬁned, there exists s1 such that a1(s) is deﬁned for all s < s1 but not for s = s1.

- Let q = lims→s1 a1(s). By completeness, q ∈ S′. By using Lemma 2, we see that a1(s1) is deﬁned, which is a contradiction and shows that x(s,0) is


[Page 471]

a2

a1

s

t

x(s,t)

p1 0

###### Figure 5-55

deﬁned for all s ∈ R. With the same argument we show that x(s,t) is deﬁned for all t ∈ R.

Now we must show that x is a parametrization of S′. This will be done through a series of lemmas.

LEMMA 4. For a ﬁxed t, the curve x(s,t), −∞ < s < ∞, is an asymptotic curve with s as arc length.

Proof. For each point x(s′,t′) ∈ S′, there exists by Lemma 2 a “rectangular” neighborhood (that is, of the form ta < t < tb, sa < s < sb) such that the asymptotic curves of this neighborhood form a Tchebyshef net. We ﬁrst remark that if for some t0,ta < t0 < tb, the curve x(s,t0), sa < s < sb, is an asymptotic curve, then we know the same holds for every curve x(s,t)¯ , ta < t¯ < tb. In fact, the point x(s,t)¯ is obtained by laying off a segment of length t¯ from x(s,0) which is equivalent to laying off a segment of length t¯−t0 from x(s,t0). Since the asymptotic curves form a Tchebyshef net in this neighborhood, the assertion follows.

Now, let x(s1,t1) ∈ S′ be an arbitrary point. By compactness of the segment x(s1,t), 0 ≤ t ≤ t1, it is possible to cover it by a ﬁnite number of rectangular neighborhoods such that the asymptotic curves of each of them form a Tchebyshef net (Fig. 5-56). Since x(s,0) is an asymptotic curve, we iterate the previous remark and show that x(s,t1)is an asymptotic curve in a neighborhood of s1. Since (s1,t1) was arbitrary, the assertion of the lemma follows. Q.E.D.

LEMMA 5. x is a local diffeomorphism.

Proof. This follows from the fact that on the one hand x(s0,t), x(s,t0) are asymptotic curves parametrized by arc length, and on the other hand S′ can be locally parametrized in such a way thai the coordinate curves are the asymptotic curves of S′ and E = G = 1. Thus, x agrees locally with such a parametrization. Q.E.D.

[Page 472]

0

a1

x (s1,t1)

###### Figure 5-56

LEMMA 6. x is surjective. Proof. Let Q = x(R2). Since x is a local diffeomorphism, Q is open in S′.

We also remark that if p′ = x(s0,t0), then the two asymptotic curves which pass through p′ are entirely contained in Q.

Let us assume that Q ?= S′. Since S′ is connected, the boundary Bd Q ?= φ. Let p ∈ Bd Q. Since Q is open in S′, p ∈/ Q. Now consider a rectangular neighborhood R of p in which the asymptotic curves form a Tchebyshef net (Fig. 5-57). Let q ∈ Q∩R. Then one of the asymptotic curves through q intersects one of the asymptotic curves through p. By the above remark, this is a contradiction. Q.E.D.

R

- p
- q


Q

###### Figure 5-57

We now claim that x is a global diffeomorphism. Since x is a surjective local diffeomorphism, it sufﬁces to show x has the property of lifting arcs and apply Prop. 6 of Sec. 5-6 (Covering Spaces...) to conclude that x is a covering map. Since R2 is simply connected, this will prove our claim.

To show that x has the property of lifting arcs we use a Proposition that is presented here without proof (For a proof, see Elon Lima, Fundamental Groups and Covering Spaces, A K Peters, Natick, Massachusetts, see p. 144): ... Let x: R2 → S′ be a surjective local diffeomorphism. Assume that x is a closed map (i.e., the image of a closed set is closed). Then x has the property of lifting arcs. That x is closed follows from the way it is deﬁned.

This completes the proof of our claim.

[Page 473]

The proof of Hilbert’s theorem now follows easily.

Proof of the Theorem. Assume the existence of an isometric immersion ψ: S → R3, where S is a complete surface with K ≡ −1. Let p ∈ S and denote by S′ the tangent plane Tp(S) endowed with the metric induced by expp : Tp(S) → S. Then ϕ = ψ ◦expp : S′ → R3 is an isometric immersion and Lemmas 5 and 6 plus the text after them show the existence of a parametrization x: R2 → S′ of the entire S′ such that the coordinate curves of x are the asymptotic curves of S′ (Lemma 4). Thus, we can cover S′ by a union of “coordinate quadrilaterals” Qn, with Qn ⊂ Qn+1. By Lemma 3, the area of each Qn is smaller than 2π. On the other hand, by Lemma 1, the area of S′ is unbounded. This is a contradiction and concludes the proof. Q.E.D.

Remark 2. Hilbert’s theorem was generalized by N. V. Eﬁmov, “Appearance of Singularities on Surfaces of Negative Curvature,” Math. Sb. 106 (1954). A.M.S. Translations. Series 2, Vol. 66, 1968, 154–190, who proved the following conjecture of Cohn-Vossen: Let S be a complete surface with curvature K satisfying K ≤ δ < 0. Then there exists no isometric immersion of

- S into R3. Eﬁmov’s proof is very long, and a shorter proof would be desirable. An excellent exposition of Eﬁmov’s proof can be found in a paper by
- T. Klotz Milnor, “Eﬁmov’s Theorem About Complete Immersed Surfaces of NegativeCurvature,” AdvancesinMathematics8(1972), 474–543. Thispaper also contains another proof of Hilbert’s theorem which holds for surfaces of class C2.


For further details on immersion of the hyperbolic plane see M. L. Cromov and V. A. Rokblin, “Embeddings and Immersions in Riemannian Geometry,” Russian Math. Sureys (1970), 1–57, especially p. 15.

###### EXERCISES

- 1. (Stoke’s Remark.) Let S be a complete geometric surface. Assume that the Gaussian curvature K satisﬁes K ≤ δ < 0. Show that there is no isometric immersion ϕ: S → R3 such that the absolute value of the mean curvature H is bounded. This proves Eﬁmov’s theorem quoted in Remark 2 with the additional condition on the mean curvature. The following outline may be useful:


- a. Assume such a ϕ exists and consider the Gauss map N: ϕ(S) ⊂ R3 → S2, where S2 is the unit sphere. Since K ?= 0 everywhere, N induces a newmetric(, ) onS byrequiringthatN ◦ϕ:S → S2 bealocalisometry. ChoosecoordinatesonS sothattheimagesbyϕ ofthecoordinatecurves are lines of curvature of ϕ(S). Show that the coefﬁcients of the new metric in this coordinate system are


g11 = (k1)2E, g12 = 0, g22 = (k2)2G,

[Page 474]

where E,F(= 0), and G are the coefﬁcients of the initial metric in the same system.

- b. Show that there exists a constant M > 0 such that k12 < M, k22 < M. Use the fact that the initial metric is complete to conclude that the new metric is also complete.
- c. Use part b to show that S is compact; hence, it has points with positive curvature, a contradiction.


- 2. The goal of this exercise is to prove that there is no regular complete surface of revolution S in R3 with K ≤ δ < 0 (this proves Eﬁmov’s theorem for surfaces of revolution). Assume the existence of such an S ⊂ R3.

- a. Prove that the only possible forms for the generating curve of S are those in Fig. 5-58(a) and (b), where the meridian curve goes to inﬁnity in both directions. Notice that in Fig. 5-58(b) the lower part of the meridian is asymptotic to the z axis.
- b. Parametrize the generating curve (ϕ(s),ψ(s)) by arc length s ∈ R so that ψ(0) = 0. Use the relations ϕ′′ +Kϕ = 0 (cf. Example 4, Sec. 3-3, Eq. (9)) and K ≤ δ < 0 to conclude that there exists a point s0 ∈ [0,+∞) such that (ϕ′(s0))2 = 1.
- c. Show that each of the three possibilities to continue the meridian


(ϕ(s),ψ(s)) of S past the point p0 = (ϕ(s0),ψ(s0)) (described in Fig. 5-58(c) as I, II, and III) leads to a contradiction. Thus, S is not complete.

- 3. (T.K.Milnor’sProofofHilbert’sTheorem.) LetS beaplanewithacomplete metric g1 such that its curvature K ≡ −1. Assume that there exists an


z

y 0

s = 0

z

y 0

s = 0

z

y 0

p0

I

II

III

(a) (b) (c)

###### Figure 5-58

[Page 475]

isometric immersion ϕ: S → R3. To obtain a contradiction, proceed as follows:

- a. ConsidertheGaussmapN: ϕ(S) ⊂ R3 → S2 and letg2 bethemetricon S obtained by requiring that N ◦ϕ: S → S2 be a local isometry. Choose local coordinates on S so that the images by ϕ of the coordinate curves are the asymptotic curves of ϕ(S). Show that, in such a coordinate system, g1 can be written as

du2 +2cosθ du dv +dv2 and that g2 can be written as

du2 −2cosθ du dv +dv2.

- b. Prove that g3 = 21(g1 +g2) is a metric on S with vanishing curvature. Use the fact that g1 is a complete metric and 3g3 ≥ g1 to conclude that the metric g3 is complete.

- c. Prove that the plane with the metric g3 is globally isometric to the standard (Euclidean) plane R2. Thus, there is an isometry ϕ: S → R2. Prove further that ϕ maps the asymptotic curves of S, parametrized by arclength, intoarectangularsystemofstraightlinesinR2, parametrized by arc length.
- d. Use the global coordinate system on S given by part c, and obtain a contradiction as in the proof of Hilbert’s theorem in the text.


[Page 476]

Appendix Point-Set Topology of

Euclidean Spaces

In Chap. 5 we have used more freely some elementary topological properties of Rn. The usual properties of compact and connected subsets of Rn, as they appear in courses of advanced calculus, are essentially all that is needed. For completeness, we shall make a brief presentation of this material here, with proofs. We shall assume the material of the appendix to Chap. 2, Part A, and the basic properties of real numbers.

###### A. Preliminaries

Here we shall complete in some points the material of the appendix to Chap. 2, Part A.

In what follows U ⊂ Rn will denote an open set in Rn. The index i varies in the range 1,2,...,m,..., and if p = (x1,...,xn), q = (y1,...,yn), |p −q| will denote the distance from p to q; that is,

|p −q|2 = ?

j

(xj −yj)2, j = 1,...,n.

DEFINITION 1. A sequence p1,...,pi,... ∈ Rn converges to p0 ∈ Rn if given ǫ > 0, there exists an index i0 of the sequence such that p1 ∈ Bǫ(p0) for all i > i0. In this situation, p0 is the limit of the sequence {p1}, and this is denoted by {pi} → p0.

Convergence is related to continuity by the following proposition. PROPOSITION 1. A map F: U ⊂ Rn → Fm is continuous at p0 ∈ U

if and only if for each converging sequence {pi} → p0 in U, the sequence {F(pi)} converges to F(p0).

###### 460

[Page 477]

Proof. Assume F to be continuous at p0 and let ǫ > 0 be given. By continuity, there exists δ > 0 such that F(Bδ(p0)) ⊂ Bǫ(F(p0)). Let {p1} be a sequence in U, with {pi} → p0 ∈ U. Then there exists in correspondence with δ an index i0 such that pi ∈ Bδ(p0) for i > i0. Thus, for i > i0,

F(pi) ∈ F(Bδ(p0)) ⊂ Bǫ(F(p0)), which implies that {F(p1)} → F(p0).

Suppose now that F is not continuous at p0. Then there exists a number ǫ > 0 such that for every δ > 0 can ﬁnd a point p ∈ Bδ(p0), with F(p) ∈/ Bǫ(F(p0)). Fix this ǫ, and set δ = 1,1/2,...,1/i,..., thus obtaining a sequence {pi} which converges to p0. However, since F(pi) ∈/ Bǫ(F(p0)), the sequence {F(pi)} does not converge to F(p0). Q.E.D.

DEFINITION 2. A point p ∈ Rn is a limit point of a set A ⊂ Rn if every neighborhood of p in Rn contains one point of A distinct from p.

To avoid some confusion with the notion of limit of a sequence, a limit point is sometimes called a cluster point or an accumulation point.

Deﬁnition2isequivalenttosayingthateveryneighborhoodV ofp contains inﬁnitely many points of A. In fact, let q1 ?= p be the point of A given by the deﬁnition, and consider a ball Bǫ(p) ⊂ V so that q1 ∈/ Bǫ(p). Then there is a point q2 ?= p, q2 ∈ A∩Bǫ(p). By repeating this process, we obtain a sequence {qi} in V , where the q1 ∈ A are all distinct. Since {qt} → p, the argument also shows that p is a limit point of A if and only if p is the limit of some sequence of distinct points in A.

Example 1. The sequence 1,1/2,1/3,...,1/i,... converges to 0. The sequence 3/2,4/3,..., i +1/i,... converges to 1. The “intertwined” sequence 1,3/2,1/2,4/3,1/3,...,,1+(1/i),1/i,... does not converge and has two limit points, namely 0 and 1 (Fig. A5-l).

0

1 4

1 3 3

- 1 1

4

- 2 2 2


3

###### Figure A5-1

It should be observed that the limit p0 of a converging sequence has the property that any neighborhood of p0 contains all but a ﬁnite number of points of the sequence, whereas a limit point p of a set has the weaker property that any neighborhood of p contains inﬁnitely many points of the set. Thus,

- a sequence which contains no constant subsequence is convergent if and only if, as a set, it contains only one limit point.


Aninterestingexampleisgivenbytherationalnumbers Q. Itcanbeproved that Q is countable; that is, it can be made into a sequence. Since arbitrarily

[Page 478]

near any real number there are rational numbers, the set of limit points of the sequence Q is the real line R.

DEFINITION 3. A set F ⊂ Rn is closed if every limit point of F belongs to F. The closure of A ⊂ Rn denoted by A¯ , is the union of A with its limit points.

Intuitively, F is closed if it contains the limit of all its convergent sequences, or, in other words, it is invariant under the operation of passing to the limit.

It is obvious that the closure of a set is a closed set. It is convenient to make

the convention that the empty set φ is both open and closed. There is a very simple relation between open and closed sets. PROPOSITION 2. F ⊂ Rn is closed if and only if the complement Rn −F

of F is open.

Proof. Assume F to be closed and let p ∈ Rn −F. Since p is not a limit point of F, there exists a ball Bǫ(p) which contains no points of F. Thus, Bǫ ⊂ Rn −F; hence Rn −F is open.

Conversely, supposethatRn −F isopenandthatp isalimitpointofF. We want to prove that p ∈ F. Assume the contrary. Then there is a ball Bǫ(p) ⊂ Rn −F. This implies that Bǫ(p) contains no point of F and contradicts the fact that p is a limit point of F. Q.E.D.

Continuity can also be expressed in terms of closed sets, which is a consequence of the following fact.

PROPOSITION 3. A map F: U ⊂ Rn → Rm is continuous if and only if for each open set V ⊂ Rm, F−1(V) is an open set.

Proof. Assume F to be continuous and let V ⊂ Rm be an open set in Rm. If F−1(V ) = φ, there is nothing to prove, since we have set the convention that the empty set is open. If F−1(V ) ?= φ, let p ∈ F−1(V ). Then F(p) ∈ V , and since V is open, there exists a ball Bǫ(F(p)) ⊂ V . By continuity of F, there exists a ball Bδ(p) such that

F(Bδ(p)) ⊂ Bǫ(F(p)) ⊂ V. Thus, Bδ(p) ⊂ F−1(V ); hence, F−1(V ) is open.

Assume now that F−1(V ) is open for every open set V ⊂ Rm. Let p ∈ U and ǫ > 0 be given. Then A = F−1(Bǫ(F(p))) is open. Thus, there exists δ > 0 such that Bδ(p) ⊂ A. Therefore,

F(Bδ(p)) ⊂ F(A) ⊂ Bǫ(F(p)); hence, F is continuous in p. Q.E.D.

[Page 479]

COROLLARY. F: U ⊂ Rn → Rm is continuous if and only if for every closed set A ⊂ Rm, F−1(A) is a closed set.

Example 2. Proposition 3 and its corollary give what is probably the best way of describing open and closed subsets of Rn. For instance, let f : R2 → R be given by f (x,y) = (x2/a2)−(y2/b2)−1. Observe that f is continuous, 0 ∈ R is a closed set in R, and (0,+∞) is an open set in R. Thus, the set

F1 = {(x,y);f (x,y) = 0} = f −1(0) is closed in R2, and the sets

U1 = {(x,y);f (x,y) > 0}, U2 = {(x,y);f (x,y) < 0}

are open in R2. On the other hand, the set A = {(x,y) ∈ R2,x2 +y2 < 1}

∪{(x,y) ∈ R2;x2 +y2 = 1,x > 0,y > 0} is neither open nor closed (Fig. A5-2).

A

U1 U1

U2

F1 F1

###### Figure A5-2

The last example suggests the following deﬁnition. DEFINITION 4. Let A ⊂ Rn. The boundary Bd A of A is the set of

points p in Rn such that every neighborhood of p contains points in A and points in Rn −A.

Thus, if A is the set of Example 2, Bd A is the circle x2 +y2 = 1. Clearly, A ⊂ Rn is open if and only if no point of Bd A belongs to A, and B ⊂ Rn is closed if and only if all points of Bd B belong to B.

[Page 480]

Now we want to recall a basic property of the real numbers. We need some deﬁnitions.

DEFINITION 5. A subset A ⊂ R of the real line R is bounded above if there exists M ∈ R such that M ≥ a for all a ∈ A. The number M is called an upper bound for A. When A is bounded above, a supremum or a least upper bound of A, sup A (or l.u.b. A) is an upper bound M which satisﬁes the following condition: Given ǫ > 0, there exists a ∈ A such that M −ǫ < a. By changing the sign of the above inequalities, we deﬁne similarly a lower bound for A and an inﬁmum (or a greatest lower bound) of A, inf A (or g.l.b. A).

AXIOM OF COMPLETENESS OF REALNUMBERS. Let A ⊂ R be nonempty and bounded above (below). Then there exists supA (inf A).

There are several equivalent ways of expressing the basic property of completeness of the real-number system. We have chosen the above, which, although not the most intuitive, is probably the most effective one.

It is convenient to set the following convention. If A ⊂ R is not bounded above (below), we say that sup A = +∞ (inf A = −∞). With this convention the above axiom can be stated as follows: Every nonempty set of real numbers has a sup and an inf.

Example 3. The sup of the set (0,1) is 1, which does not belong to the set. The sup of the set

B = {x ∈ R;0 < x < 1}∪{2}

is 2. The point 2 is an isolated point of B; that is, it belongs to B but is not a limit point of B. Observe that the greatest limit point of B is 1, which is not sup B. However, if a bounded set has no isolated points, its sup is certainly a limit point of the set.

One important consequence of the completeness of the real numbers is the following “intrinsic” characterization of convergence, which is actually equivalent to completeness (however, we shall not prove that).

LEMMA 1. Call a sequence {xi} of real numbers a Cauchy sequence if given ǫ > 0, there exists i0 such that |xi,xj| < ǫ for all i,j > i0. A sequence is convergent if and only if it is a Cauchy sequence.

Proof. Let {xi} → x0. Then, if ǫ > 0 is given, there exists i0 such that |xi −x0| < ǫ/2 for i > i0. Thus, for i,j > i0, we have

|xi −xj| ≤ |xi −x0|+|xj −x0| < ǫ; hence, {xi} is a Cauchy sequence.

Conversely, let {xi} be a Cauchy sequence. The set {xi} is clearly a bounded set. Let a1 = inf{x}, b1 = sup{xi}. Either, one of these points is a limit point

[Page 481]

of {xi} and then {xi} converges to this point, or both are isolated points of the set {xi}. In the latter case, consider the set of points in the open interval (a1,b1), and let a2 and b2 be its inf and sup, respectively. Proceeding in this way, we obtain that either {xi} converges or there are two bounded sequences

- a1 < a2 < ··· and b1 > b2 > ···. Let a = sup{ai} and b = inf{bi}. Since {xi} is a Cauchy sequence, a = b, and this common value x0 is the unique limit point of {xi}. Thus, {xi} → x0. Q.E.D.


This form of completeness extends naturally to Euclidean spaces. DEFINITION 6. A sequence {pi}, pi ∈ Rn, is a Cauchy sequence if given

ǫ > 0, there exists an index i0 such that the distance |pi −pj| < ǫ for all i,j > i0.

PROPOSITION 4. A sequence {pi}, pi ∈ Rn, converges if and only if it is a Cauchy sequence.

Proof. A convergent sequence is clearly a Cauchy sequence (see the argument in Lemma 1). Conversely, let {pi} be a Cauchy sequence, and consider its projection on the j axis of Rn, j = 1,...,n. This gives a sequence of real numbers {xji} which, since the projection decreases distances, is again a Cauchy sequence. By Lemma 1, {xji} → xj0. It follows that {pi} → p0 = {x10,x20,...,xn0}. Q.E.D.

###### B. Connected Sets

- DEFINITION 7. Acontinuous curve α: [a,b] → A ⊂ Rn is called an arc in A joining α(a) to α(b).
- DEFINITION 8. A ⊂ Rn is arcwise connected if, given two points p,q ∈ A, there exists an arc in A joining p to q.


Earlier in the book we have used the word connected to mean arcwise connected (Sec. 2-2). Since we were considering only regular surfaces, this can be justiﬁed, as will be done presently. For a general subset of Rn, however, the notion of arcwise connectedness is much too restrictive, and it is more convenient to use the following deﬁnition.

DEFINITION 9. A ⊂ Rn is connected when it is not possible to write

- A = U1 ∪U2, where U1 and U2 are nonempty open sets in A and U1 ∩U2 = φ.


Intuitively, this means that it is impossible to decompose A into disjoint pieces. For instance, the sets U1 and F1 in Example 2 are not connected. By taking the complements of U1 and U2, we see that we can replace the word “open” by “closed” in Def. 10.

[Page 482]

PROPOSITION 5. Let A ⊂ Rn be connected and let B ⊂ A be simultaneously open and closed in A. Then either B = φ or B = A.

Proof. SupposethatB ?= φ andB ?= AandwriteA = B ∪(A−B). Since

- B is closed in A, A−B is open in A. Thus, A is a union of disjoint, nonvoid, open sets, namely B and A−B. This contradicts the connectedness of A.


###### Q.E.D.

The next proposition shows that the continuous image of a connected set is connected.

PROPOSITION 6. Let F: A ⊂ Rn → Rm be continuous and A be connected. Then F(A) is connected.

Proof. Assume that F(A) is not connected. Then F(A) = U1 ∪U2, where

- U1 and U2 are disjoint, nonvoid, open sets in F(A). Since F is continuous, F−1(U1), F−1(U2) are also disjoint, nonvoid, open sets in A. Since A = F−1(U1)∪F−1(U2), this contradicts the connectedness of A. Q.E.D.

For the purposes of this section, it is convenient to extend the deﬁnition of interval as follows:

DEFINITION 10. An interval of the real line R is any of the sets a < x < b, a ≤ x ≤ b, a < x ≤ b, a ≤ x < b, x ∈ R. The cases a = b, a = −∞, b = +∞ are not excluded, so that an interval may be a point, a half-line, or R itself.

PROPOSITION 7. A ⊂ R is connected if and only if A is an interval. Proof. Let A ⊂ R be an interval and assume that A is not connected. We

shall arrive at a contradiction.

Since A is not connected, A = U1 ∪U2, where U1 and U2 are nonvoid, disjoint, and open in A. Let a1 ∈ U1, b1 ∈ U2 and assume that a1 < b1. By dividing the closed interval [a1,b1] = I1 by the midpoint (a1 +b1)/2, we obtain two intervals, one of which, to be denoted by I2, has one of its end points in U1 and the other end point in U2. Considering the midpoint of I2 and proceeding as before, we obtain an interval I3 ⊂ I2 ⊂ I1. Thus, we obtain a family of closed intervals I1 ⊃ I2 ⊃ ··· ⊃ In ⊃ ··· whose lengths approach zero. Let us rewrite Ii = [ci,di]. Then c1 ≤ c2 ≤ ··· ≤ cn ≤ ···, and d1 ≥ d2 ≥ ··· ≥ dn ≥ ···. Let c = sup{c1} and d = inf{di}. Since d1 −ci is arbitrarily small, c = d. Furthermore, any neighborhood of c contains some Ii fori sufﬁcientlylarge.Thus, c isalimitpointofbothU1 andU2. SinceU1 and

- U2 are closed, c ∈ U1 ∩U2, and that contradicts the disjointness of U1 and U2. Conversely, assumethatAisconnected. IfAhasasingleelement, Aistriv-


ially an interval. Suppose that A has at least two elements, and let a = inf A,

- b = supA, a ?= b. Clearly, A ⊂ [a,b]. We shall show that (a,b) ⊂ A, and that implies that A is an interval. Assume the contrary; that is, there exists t,


[Page 483]

a < t < b, such that t ∈/ A. The sets A∩(−∞,t) = V1, A∩(t,+∞) = V2 are open in A = V1 ∪V2. Since A is connected, one of these sets, say, V2 is empty. Since b ∈ (t,+∞), this implies both that b ∈/ A and b is not a limit pointofA. Thiscontradictsthefactthatb = supA. Inthesameway, ifV1 = φ, we obtain a contradiction with the fact that a = inf A. Q.E.D.

PROPOSITION 8. Let f: A ⊂ Rn → R be continuous and A be connected. Assume that f(q) ?= 0 for all q ∈ A. Then f does not change sign in A.

Proof. ByProp. 6, f(A) ⊂ R isconnected. ByProp. 7, f(A)isaninterval. By hypothesis, f(A) does not contain zero. Thus, the points in f(A) all have the same sign. Q.E.D.

PROPOSITION 9. Let A ⊂ Rn be arcwise connected. Then A is connected.

Proof. Assume that A is not connected. Then A = U1 ∪U2, where U1,

- U2 are nonvoid, disjoint, open sets in A. Let p ∈ U1, q ∈ U2. Since A is arcwisc connected, there is an arc α: [a,b] → A joining p to q. Since α is continuous, B = α([a,b]) ⊂ A is connected. Set V1 = B ∩U1, V2 = B ∩U2. Then B = V1 ∪V2, where V1 and V2 are nonvoid, disjoint, open sets in B, and that is a contradiction. Q.E.D.

The converse is, in general, not true. However, there is an important special case where the converse holds.

DEFINITION 11. A set A ⊂ Rn is locally arcwise connected if for each

- p ∈ A and each neighborhood V of p in A there exists all arcwise connected neighborhood U ⊂ V of p in A.


Intuitively, this means that each point of A has arbitrarily small arcwise connected neighborhoods. A simple example of a locally arcwise connected set in R3 is a regular surface. In fact, for each p ∈ S and each neighborhood W of p in R3, there exists a neighborhood V ⊂ W of p in R3 such that

- V ∩S is homeomorphic to an open disk in R2; since open disks are arcwise connected, each neighborhood W ∩S of p ∈ S contains an arcwise connected neighborhood.


The next proposition shows that our usage of the word connected for arcwise connected surfaces was entirely justiﬁed.

PROPOSITION 10. LetA ⊂ Rn bealocallyarcwiseconnectedset. Then A is connected if and only if it is arcwise connected.

[Page 484]

Proof. Half of the statement has already been proved in Prop. 9. Now assume that A is connected. Let p ∈ A and let A1 be the set of points in A that can be joined to p by some arc in A. We claim that A1 is open in A.

In fact, let q ∈ A1 and let α: [a,b] → A be the arc joining p to q. Since A is locally arcwise connected, there is a neighborhood V of q in A such that

- q can be joined to any point r ∈ V by an arc β: [b,c] → V (Fig. A5-3). It follows that the arc in A,


α ◦β = ?

α(t), t ∈ [a,b], β(t), t ∈ [b,c],

joins q to r, and this proves our claim.

A

p

q

r

V

###### Figure A5-3

By a similar argument, we prove that the complement of A1 is also open in A. Thus, A1 is both open and closed in A. Since A is locally arcwise connected, A1 is not empty. Since A is connected, A1 = A. Q.E.D.

Example 4. A set may be arcwise connected and yet fail to be locally arcwise connected . For instance, let A ⊂ R2 be the set made up of vertical lines passing through (1/n,0), n = 1,..., plus the x and y axis. A is clearly arcwise connected, but a small neighborhood of (0,y), y ?= 0, is not arcwise connected. This comes from the fact that although there is a “long” arc joining any two points p, q ∈ A, there may be no short arc joining these points

- (Fig. A5-4).


###### C. Compact Sets

DEFINITION 12. A set A ⊂ Rn is bounded if it is contained in some ball of Rn. A set K ⊂ Rn is compact if it is closed and bounded.

[Page 485]

x 0 1/4 1/3 1/2 1

(0, y)

y

q

p

###### Figure A5-4

We have already met compact sets in Sec. 2-7. For completeness, we shall prove here properties 1 and 2 of compact sets, which were assumed in Sec. 2-7.

DEFINITION 13. An open cover of a set A ⊂ Rn is a family of open sets {Uα}, α ∈ a such that

?

α Uα ⊃ A. When there are only ﬁnitely many Uα in the family, we say that the cover is ﬁnite. If the subfamily {Uβ}, β ∈ B ⊂ a, still covers A, that is,

?

β Uβ ⊃ A, we say that {Uβ} is a subcover of {Uα}.

PROPOSITION 11. For a set K ⊂ Rn the following assertions are equivalent:

- 1. K is compact.
- 2. (Heine-Borel). Every open cover of K has a ﬁnite subcover.
- 3. (Bolzano-Weierstrass). Every inﬁnite subset of K has a limit point in K.


Proof. We shall prove 1 =⇒ 2 =⇒ 3 =⇒ 1. 1 =⇒ 2: Let {Uα}, α ∈ a, be an open cover of the compact K, and assume

that{Uα}hasnoﬁnitesubcover.Weshallshowthatthisleadstoacontradiction. Since K is compact, it is contained in a closed rectangular region

B = {(x1,...,xn) ∈ Rn;aj ≤ xj ≤ bj, j = 1,...,n}. Let us divide B by the hyperplanes xj = (aj +bj)/2 (for instance, if K ⊂ R2,

- B is a rectangle, and we are dividing B into 22 = 4 rectangles). We thus obtain 2n smaller closed rectangular regions. By hypothesis, at least one of these regions, to be denoted by B1, is such that B1 ∩K is not covered by a ﬁnite number of open sets of {Uα}. We now divide B1 in a similar way, and,


[Page 486]

| | | |B1|B<br><br>K|
|---|---|---|---|---|
|B2| | | | |
| | | | | |
| | | | | |
| | | | | |
| | | | | |


B3 B4

###### Figure A5-5

by repeating the process, we obtain a sequence of closed rectangular regions

- (Fig. A5-5) B1 ⊃ B2 ⊃ ··· ⊃ Bi ⊃ ···


which is such that no Bi ∩K is covered by a ﬁnite number of open sets of {Uα} and the length of the largest side of Bi converges to zero.

We claim that there exists p ∈ ∩Bi. In fact, by projecting each Bi on the j axis of Rn, j = l,...,n, we obtain a sequence of closed intervals

[aj1,bj1] ⊃ [aj2,bj2] ⊃ ··· ⊃ [aji,bji] ⊃ ··· . Since (bji −aji) is arbitrarily small, we see that

aj = sup{aji} = inf{bji} = bj; hence,

aj ∈ ?

i

[aji,bji].

Thus, p = (a1,...,an) ∈

?

i Bi, as we claimed.

Now, any neighborhood of p contains some Bi for i sufﬁciently large; hence, it contains inﬁnitely many points of K. Thus, p is a limit point of K, and since K is closed, p ∈ K. Let U0 be an element of the family {Uα} which contains p. Since U0 is open, there exists a ball Bǫ(p) ⊂ U0. On the other hand, for i sufﬁciently large, Bi ⊂ Bǫ(p) ⊂ U0. This contradicts the fact that no Bi ∩K can be covered by a ﬁnite number of Uα’s and proves that 1 =⇒ 2.

2 =⇒ 3.Assume that A ⊂ K is an inﬁnite subset of K and that no point of K is a limit point of A. Then it is possible, for each p ∈ K, p ∈/ A, to choose a neighborhood Vp of p such that Vp ∩A = φ and for each q ∈ A to choose

[Page 487]

a neighborhood Wq of q such that Wq ∩A = q. Thus, the family {Vp,Wp}, p ∈ K −A, q ∈ A, is an open cover of K. Since A is inﬁnite and the omission of any Wq of the family leaves the point q uncovered, the family {Vp,Wq} has no ﬁnite subcover. This contradicts assertion 2.

3 =⇒ 1: We have to show that K is closed and bounded. K is closed, because if p is a limit point of K, by considering concentric balls B1/i(p) = Bi, weobtainasequencep1 ∈ B1 −B2, p2 ∈ B2 −B3,...,pi ∈ Bi −Bi+1,... which has p as a limit point. By assertion 3, p ∈ K.

K is bounded. Otherwise, by considering concentric balls Bi(p), of radius 1,2,...,i,..., we will obtain a sequence p1 ∈ B1, p2 ∈ B2 −B1,..., pi ∈ Bi −Bi−1,... with no limit point. This proves that 3 =⇒ 1. Q.E.D.

The next proposition shows that a continuous image of a compact set is compact.

PROPOSITION 12. Let F: K ⊂ Rn → Rm be continuous and let K be compact. Then F(K) is compact.

Proof. If F(K) is ﬁnite, it is trivially compact. Assume that F(K) is not ﬁnite and consider an inﬁnite subset {F(pα)} ⊂ F(K), pα ∈ K. Clearly the set {pα} ⊂ K is inﬁnite and has, by compactness, a limit point q ∈ K. Thus, there exists a sequence p1,...,pi,...,→ q, pi ∈ {pα}. By the continuity of F, the sequence F(pi) → F(q) ∈ F(K) (Prop. 1). Thus, {F(pα)} has a limit point F(q) ∈ F(K); hence, F(K) is compact. Q.E.D.

The following is probably the most important property of compact sets. PROPOSITION 13. Let f: K ⊂ Rn → R be a continuous function

deﬁned on a compact set K. Then there exists p1,p2 ∈ K such that

f(p2) ≤ f(p) ≤ f(p1) for all p ∈ K; that is, f reaches a maximum at p1 and a minimum at p2.

Proof. We shall prove the existence of p1; the case of minimum can be treated similarly.

By Prop. 12, f (K) is compact, and hence closed and bounded. Thus, there exists sup f (K) = x1. Since f (K) is closed, x1 ∈ f (K). It follows that there exists p1 ∈ K with x1 = f (p1). Clearly, f (p) ≤ f (p1) = x1 for all p ∈ K.

###### Q.E.D.

Although we shall make no use of it, the notion of uniform continuity ﬁts so naturally in the present context that we should say a few words about it.

A map F: A ⊂ Rn → Rm is uniformly continuous in A if given ǫ > 0, there exists δ > 0 such that F(Bδ(p)) ⊂ Bǫ(F(p)) for all p ∈ A.

Formally, the difference between this deﬁnition and that of (simple) continuity is the fact that here, given ǫ, the number δ is the same for all p ∈ B,

[Page 488]

whereas in simple continuity, given ǫ, the number δ may vary with p. Thus, uniform continuity is a global, rather than a local, notion.

It is an important fact that on compact sets the two notions agree. More precisely, let F: K ⊂ Rn → Rm be continuous and K be compact. Then F is uniformly continuous in K.

The proof of this fact is simple if we recall the notion of the Lebesgue number of an open cover, introduced in Sec. 2-7. In fact, given ǫ > 0, there existsforeachp ∈ K anumberδ(p) > 0suchthatF(Bδ(p)(p)) ⊂ Bǫ/2(F(p)).

The family {Bδ(p)(p),p ∈ K} is an open cover of K. Let δ > 0 be the Lebesgue number of this family (Sec. 2-7, property 3). If q ∈ Bδ(p), p ∈ K, then q and p belong to some element of the open cover. Thus, |F(p)−F(q)| < ǫ. Since q is arbitrary, F(Bδ(p)) ⊂ Bǫ(F(p)). This shows that δ satisﬁes the deﬁnition of uniform continuity, as we wished.

###### D. Connected Components

When a set is not connected, it may be split into its connected components. To make this idea precise, we shall ﬁrst prove the following proposition.

PROPOSITION 14. Let Cα ⊂ Rn be a family of connected sets such that

?

α

Cα ?= φ.

Then

?

α Cα = C is a connected set.

Proof. Assume that C = U1 ∪U2, where U1 and U2 are nonvoid, disjoint, opensetsinC, andthatsomepointp ∈

?

α Cα belongstoU1. Letq ∈ U2. Since

- C =


?

α Cα and p ∈

?

α Cα, there exists some Cα such that p,q ∈ Cα. Then

- Cα ∩U1 and Cα ∩U2 are nonvoid, disjoint, open sets in Cα. This contradicts the connectedness of Cα and shows that C is connected.


###### Q.E.D.

DEFINITION 14. Let A ⊂ Rn and p ∈ A. The union of all connected subsets of A which contain p is called the connected component of A containing p.

By Prop. 14, a connected component is a connected set. Intuitively the connected component of A containing p ∈ A is the largest connected subset of A (that is, it is contained in no other connected subset of A that contains p).

A connected component of a set A is always closed in A. This is a consequence of the following proposition.

PROPOSITION 15. Let C ⊂ A ⊂ Rn be a connected set. Then the closure C¯ of C in A is connected.

[Page 489]

Proof. Let us suppose that C¯ = U1 ∪U2, where U1, U2 are nonvoid, disjoint, open sets in C¯. Since C¯ ⊃ C, the sets C ∩U1 = V1, C ∩U2 = V2 are openinC, disjoint, andV1 ∪V2 = C.WeshallshowthatV1 andV2 arenonvoid, thus reaching a contradiction with the connectedness of C.

Let p ∈ U1. Since U1 is open in C¯, there exists a neighborhood W of p in A such that W ∩C¯ ⊂ U1. Since p is a limit of C, there exists q ∈ W ∩C ⊂ W ∩C¯ ⊂ U1. Thus, q ∈ C ∩U1 = V1, and V1 is not empty. In a similar way, it can be shown that V2 is not empty. Q.E.D.

COROLLARY. A connected component C ⊂ A ⊂ Rn of a set A is closed in A.

In fact, if C¯ ?= C, there exists a connected subset of A, namely C¯, which contains C properly. This contradicts the maximality of the connected component C.

In some special cases, a connected component of set A is also an open set in A.

PROPOSITION 16. Let C ⊂ A ⊂ Rn be a connected component of a locally arcwise connected set A. Then C is open in A.

Proof. Let p ∈ C ∈ A. Since A is locally arcwise connected, there exists an arcwise connected neighborhood V of p in A. By Prop. 9, V is connected. Since C is maximal, C ⊃ V ; hence, C is open in A. Q.E.D

###### E. Closed Maps

Here we follow Lima E., Fundamental Groups and Covering Spaces, A.K. Peters, translated from the Portuguese by Jonas Gomes, Natick, Massachusetts, 2003, p. 201.

DEFINITION. Let X˜ and X be topological spaces and f : X˜ → X be a map; the map f is called closed if it takes closed sets in X˜ into closed sets in X.

PROPOSITION. A necessary and sufﬁcient condition for f : X˜ → X to be a closed map is that given x ∈ X and an open set U˜ ⊃ f −1(x) in X˜ , there exists an open set U in X such that x ∈ U and f −1(U) ⊂ U˜ .

Proof. The condition is necessary. For, if f is closed, f (X˜ −U)˜ is closed in X. Since it does not contain x, there exists an open set U ∋ x so that U ∩f (X˜ −U)˜ ?= ∅. It follows that f−1(U) ⊂ U˜ , which is the condition in the Proposition.

The condition is sufﬁcient. For if we assume the condition, let F ⊂ X˜ be a closed set in X˜ . Choose x ?∈ f (F). Then F ∩f−1(x) = ∅. Hence the open set

[Page 490]

U˜ = (X −F) contains f−1(x). It follows that there exists an open set U ∋ x such that f −1(U) ⊂ U˜ . This implies that U ∩f (F) ?= ∅, i.e., f (F) is closed in X.

Remark. Should f−1 be a map, the condition of the proposition would say that f−1 is continuous; notice that f−1(x) is not a point in X but it is, in general, a set.

[Page 491]

###### Bibliography and Comments

The basic work of differential geometry of surfaces is Gauss’ paper “Disquisitiones generales circa superﬁcies curvas,” Comm. Soc. Göttingen Bd6, 1823–1827. Therearetranslationsintoseverallanguages, forinstance,

1. Gauss, K. F., General Investigations of Curved Surfaces, Raven Press,

New York, 1965.

We believe that the reader of this book is now in a position to try to understand that paper. Patience and open-mindedness will be required, but the experience is most rewarding.

The classical source of differential geometry of surfaces is the four-volume treatise of Darboux:

2. Darboux, G., Théorie des Surfaces, Gauthier-Villars, Paris, 1887, 1889, 1894, 1896. There exists a reprint published by Chelsea Publishing Co., Inc., New York.

This is a hard reading for beginners. However, beyond the wealth of information, there are still many unexplored ideas in this book that make it worthwhile to come to it from time to time.

The most inﬂuential classical text in the English language was probably

3. Eisenhart, L. P., A Treatise on the Differential Geometry of Curves and Surfaces, Ginn and Company, Boston, 1909, reprinted by Dover, New York, 1960.

An excellent presentation of some intuitive ideas of classical differential geometry can be found in Chap. 4 of

###### 475

[Page 492]

476 Bibliography and Comments

4. Hilbert, D., and S. Cohn-Vossen, Geometry and Imagination, Chelsea Publishing Company, Inc., New York, 1962 (translation of a book in German, ﬁrst published in 1932).

Below we shall present, in chronological order, a few other textbooks. They are more or less pitched at about the level of the present book. A more complete list can be found in [9], which, in addition, contains quite a number of global theorems.

- 5. Struik, D. J., Lectures on Classical Differential Geometry, AddisonWesley, Reading, Mass., 1950.
- 6. Pogorelov, A. V., Differential Geometry, Noordhoff, Groningen, Netherlands, 1958.
- 7. Willmore, T. J., An Introduction to Differential Geometry, Oxford University Press, Inc., London 1959.
- 8. O’Neill, B., Elementary Differential Geometry, Academic Press, New York, 1966.
- 9. Stoker, J. J., Differential Geometry, Wiley-Interscience, New York, 1969.


A clear and elementary exposition of the method of moving frames, not treated in the present book, can be found in [8]. Also, more details on the theory of curves, treated brieﬂy here, can be found in [5], [6], and [9].

Although not textbooks, the following references should be included. Reference [10] is a beautiful presentation of some global theorems on curves and surfaces, and [11] is a set of notes which became a classic on the subject.

- 10. Chern, S. S., Curves and Surfaces in Euclidean Spaces, Studies in Global Geometry and Analysis, MAA Studies in Mathematics, The Mathematical Association of America, 1967.
- 11. Hopf, H., Differential Geomentry in the Large, Lecture Notes in Mathematics, No. 1000, Part Two, pp. 76–187, Springer, 1989.


For more advanced reading, one should probably start by learning something of differentiable manifolds and Lie groups. For instance,

12. Spivak, M., A Comprehensive Introduction to Differential Geometry,

Vol. 1, Brandeis University, 1970.

13. Warner, F., Foundations of Differentiable Manifolds and Lie Groups,

Scott, Foresman, Glenview, Ill., 1971.

Reference [12] is a delightful-reading. Chapters 1–4 of [13] provide a short and efﬁcient account of the basics of the subject.

After that, there is a wide choice of reading material, depending on the reader’s tastes and interests. Below we include a possible choice, by no means unique. In [17] and [18] one can ﬁnd extensive lists of books and papers.

[Page 493]

Bibliography and Comments 477

- 14. Berger, M., P. Gauduchon, and E. Mazet, Le Spectre d’une Variété Riemannienne, Lecture Notes 194, Springer, Berlin, 1971.
- 15. Bishop, R. L., and R. J. Crittenden, Geometry of Manifolds, Academic Press, New York, 1964.
- 16. Cheeger, J., and D. Ebin, Comparison Theorems in Riemannian Geometry, North-Holland, Amsterdam, 1974.
- 17. Helgason, S., Differential Geometry and Symmetric Spaces, Academic Press, New York, 1963.
- 18. Kobayashi, S., and K. Nomizu, Foundations of Differential Geometry, Vols. I and II, Wiley-Interscience, New York, 1963 and 1969,
- 19. Gromoll, D., Klingenberg, W. and W. Meyer, Riemannsche Geometrie im Grossen, Lecture Notes 55, Springer-Verlag, Berlin, 1968.
- 20. Lawson, B., Lectures on Minimal Submanifolds, Monograﬁas de Matemática, IMPA, Rio de Janeiro, 1973.
- 21. Milnor, J., Morse Theory, Princeton University Press, Princeton, N. J., 1963.
- 22. Spivak, M., A Comprehensive Introduction to Differential Geometry, Vol. I to V, Publish or Perish, Inc., 2005.


[Page 494]

###### Hints and Answers

###### SECTION 1-3

2. a. α(t) = (t −sin t,1−cost); see Fig. 1-7. Singular points: t = 2πn,

where n is any integer.

- 7. b. Applythemeanvaluetheoremtoeachofthefunctionsx,y,ztoprove that the vector (α(t +h)−α(t +k))/(h−k) converges to the vector α′(t) as h,k → 0. Since α′(t) ?= 0, the line determined by α(t +h), α(t +k) converges to the line determined by α′(t).
- 8. By the deﬁnition of integral, given ǫ > 0, there exists a δ′ > 0 such that


if |P| < δ′, then

?

?? b

a

|α′(t)|dt?−?

(ti −ti−1)|α′(ti)|? <

ǫ 2

.

Ontheotherhand, sinceα′ isuniformlycontinuousin[a,b], givenǫ > 0, there exists δ′′ > 0 such that if t,s ∈ [a,b] with |t −s| < δ′′, then

|α′(t)−α′(s)| < ǫ/2(b −a).

Set δ = min(δ′,δ′′). Then if |P| < δ, we obtain, by using the mean value theorem for vector functions,

?

?|α(ti−1)−α(ti)|−?

(ti−1 −ti)|α′(ti)|?

≤ ?

?

(ti−1 −ti)sup

si

|α′(si)|−?

(ti−1 −ti)|α′(ti)|?

≤ ?

?

(ti−1 −ti)sup

si

|α′(si)−α′(ti)|? ≤

ǫ 2

, 478

[Page 495]

where ti−1 ≤ si ≤ ti. Together with the above, this gives the required inequality.

###### SECTION 1-4

- 2. Let the points p0 = (x0,y0,z0) and p = (x,y,z) belong to the plane P. Then ax0 +by0 +cz0 +d = 0 = ax +by +cz +d. Thus, a(x −x0)+ b(y −y0)+c(z −z0) = 0. Since the vector (x −x0,y −y0,z −z0) is parallel to P, the vector (a,b,c) is normal to P. Given a point p = (x,y,z) ∈ P, the distance ρ from the plane P to the origin O is given by ρ = |p|cosθ = (p ·v)/|v|, where θ is the angle of Op with the normal vector v. Since p ·v = −d,

ρ =

p ·v |v|

= −

d |v|

.

- 3. This is the angle of their normal vectors.
- 4. Two planes are parallel if and only if their normal vectors are parallel.


- 6. v1 and v2 are both perpendicular to the line of intersection. Thus, v1 ∧v2 is parallel to this line.
- 7. A plane and a line are parallel when a normal vector to the plane is perpendicular to the direction of the line.
- 8. Thedirectionofthecommonperpendiculartothegivenlinesisthedirection of u∧v. The distance between these lines is obtained by projecting


the vector r = (x0 −x1,y0 −y1,z0 −z1) onto the common perpendicular. Such a projection is clearly the inner product of r with the unit vector (u∧v)/|u∧v|.

###### SECTION 1-5

2. Use the fact that α′ = t, α′′ = kn, α′′′ = kn′ +k′n = −k2t +k′n−kτb.

4. Differentiate α(s)+λ(s)n(s) = const., obtaining (1−λk)t +λ′n−λτb = 0.

It follows that τ = 0 (the curve is contained in a plane) and that λ = const. = 1/k.

7. a. Parametrize α by arc length. b. Parametrize α by arc length s. The normal lines at s1 and s2 are

β1(t) = α(s1)+tn(s1), β2(τ) = α(s2)+τn(s2), t ∈ R,τ ∈ R,

[Page 496]

respectively. Their point of intersection will be given by values of t and τ such that

α(s2)−α(s1) s2 −s1 =

tn(s1)−τn(s2) s2 −s1

.

Take the inner product of the above with α′(s1) to obtain 1 = (−lim τ)s2→s1 ·?α′(s1),n′(s1)?. It follows that τ converges to 1/k as s2 → s1.

13. To prove that the condition is necessary, differentiate three times |α(s)|2 = const., obtaining α(s) = −Rn+R′Tb. For the sufﬁciency, differentiate β(s) = α(s)+Rn−R′Tb, obtaining

β′(s) = t +R(−kt −τb)+R′n−(TR′)′b −Rn = −(R′τ +(TR′)′)b.

On the other hand, by differentiating R2 +(TR′)2 = const., one obtains

0 = 2RR′ +2(TR′)(TR′) =

2R′ τ

(Rτ +(TR′)′),

since k′ ?= 0 and τ ?= 0. Hence, β(s) is a constant p0, and

|α(s)−p0|2 = R2 +(TR′)2 = const.

- 15. Since b′ = τn is known, |τ| = |b′|. Then, up to a sign, n is determined. Since t = n∧b and the curvature is positive and given by t′ = kn, the curvature can also be determined.
- 16. First show that

n∧n′ ·n′′ |n′|2

=

?

k τ ?′

?

k τ ?2 +1

= a(s).

Thus,

?

a(s)ds = arctan(k/τ); hence, k/τ can be determined; since k is positive, this also gives the sign of τ. Furthermore, |n′|2 = |−kt −τb|2 = k2 +τ2 is also known. Together with k/τ, this sufﬁces to determine k2 and τ2.

- 17. a. Let a be the unit vector of the ﬁxed direction and let θ be the constant angle. Then t ·a = cosθ = const., which differentiated gives n·a = 0. Thus, a = t cosθ +b sin θ, which differentiated gives k cosθ +τ sin θ = 0, or k/τ = −tan θ = const. Conversely,


[Page 497]

if k/τ = const. = −tan θ = −(sin θ/cosθ), we can retrace our steps, obtaining that t cosθ +b sin θ is a constant vector a. Thus, t ·a = cosθ = const.

- b. Fromtheargumentofparta, itfollowsimmediatelythatt ·a = const. implies that n·a = 0; the last condition means that n is parallel to a plane normal to a. Conversely, if n·a = 0, then (dt/ds)·a = 0; hence, t ·a = const.
- c. From the argument of part a, it follows that t ·a = const. implies that b ·a = const. Conversely, if b ·a = const., by differentiation we ﬁnd that n·a = 0.


- 18. a. Parametrize α by arc length s and differentiate α¯ = α +rn with respect to s, obtaining


dα¯ ds = (1−rk)t +r′n−rτb.

Since dα/ds¯ is tangent to α¯, (dα/ds)¯ ·n = 0; hence, r′ = 0.

- b. Parametrize α by arc length s, and denote by s¯ and t¯ the arc length and the unit tangent vector of α¯. Since dt/ds¯ = (dt/d¯ s)(d¯ s/ds)¯ , we


obtain that

d ds

(t ·t)¯ = t ·

dt¯ ds +

dt ds ·t¯ = 0;

hence, t ·t¯ = const. = cosθ. Thus, by using that α¯ = α +rn, we have

cosθ = t¯·t =

dα¯ ds

ds ds¯ ·t =

ds ds¯

(1−rk),

|sin θ| = |t¯∧t| = ?

ds ds¯

((t +rn′)∧t? = ?

ds ds¯

rτ?. From these two relations, it follows that

1−rk rτ = const. =

B r

.

Thus, setting r = A, we ﬁnally obtain that Ak +Bτ = 1. Conversely, let this last relation hold, set A = r, and deﬁne

α¯ = α +rn. Then, by again using the relation, we obtain

dα¯ ds = (1−rk)t −rτb = τ(Bt −rb).

Thus, a unit vector t¯ of α¯ is (Bt −rb)/√B2 +r2 = t¯. It follows that dt/ds¯ = ((Bk −rτ)/√B2 +r2)n. Therefore, n(s)¯ = ±n(s) and the normal lines of α¯ and α at s agree. Thus, α is a Bertrand curve.

[Page 498]

- c. Assume the existence of two distinct Bertrand mates α¯ = α +rn¯ , α˜ = α +rn˜ . By part b there exist constants c1 and c2 so that 1−rk¯ = c1(rτ)¯ , 1−rk¯ = c2(rτ)¯ . Clearly, c1 ?= c2. Differentiating these expressions, we obtain k′ = τ′c1, k′ = τ′c2, respectively. This implies that k′ = τ′ = 0. Using the uniqueness part of the fundamental theorem of the local theory of curves, it is easy to see that the circular helix is the only such curve.


###### SECTION 1-6

- 1. Assume that s = 0, and consider the canonical form around s = 0. By condition 1, P must be of the form z = cy, or y = 0. The plane y = 0 is the rectifying plane, which does not satisfy condition 2. Observe now that if |s| is sufﬁciently small, y(s) > 0, and z(s) has the same sign as s. By condition 2, c = z/y is simultaneously positive and negative. Thus, P is the plane z = 0.
- 2. a. Consider the canonical form of α(s) = (x(s),y(s),z(s)) in a neighborhood of s = 0. Let ax +by +cz = 0 be the plane that passes through α(0), α(0+h1), α(0+h2). Deﬁne a function F(s) = ax(s)+by(s)+cz(s) and notice that F(0) = F(h1) = F(h2) = 0. Use the canonical form to show that F′(0) = a, F′′(0) = bk. Use the mean value theorem (twice) to show that as h1, h2 → 0, then a → 0 and b → 0. Thus, as h1, h2 → 0 the plane ax +by +cz = 0 approaches the plane z = 0, that is, the osculating plane.


###### SECTION 1-7

- 1. No. Use the isoperimetric inequality.
- 2. Let S1 be a circle such that AB is a chord of S1 and one of the two arcs α and β determined by A and B on S1, say α, has length l. Consider the piecewise C1 closed curve (see Remark 2 after Theorem 1) formed by β and C. Let β be ﬁxed and C vary in the family of all curves joining A to B with length l. By the isoperimetric inequality for piecewise C1 curves, the curve of the family that bounds the largest area is S1. Since β is ﬁxed, the arc of circle α is the solution to our problem.


4. Choose coordinates such that the center O is at p and the x and y axes are directed along the tangent and normal vectors at p, respectively. Parametrize C by arc length, α(s) = (x(s),y(s)), and assume that α(0) = p. Consider the (ﬁnite) Taylor’s expansion

α(s) = α(0)+α′(0)s +α′′(0)

s2 2 +R,

[Page 499]

where lims→0 R/s2 = 0. Let k be the curvature of α at s = 0, and obtain

x(s) = s +Rx, y(s) = ±

ks2 2 +Ry,

where R = (Rx,Ry) and the sign depends on the orientation of α. Thus,

|k| = lim

s→0

2|y(s)| s2 = lim

d→0

2h d2

.

5. Let O be the center of the disk D. Shrink the boundary of D through a family of concentric circles until it meets the curve C at a point p. Use Exercise 4 to show that the curvature k of C at p satisﬁes |k| ≥ 1/r.

- 8. Since α is simple, we have, by the theorem of turning tangents, ? t

0

k(s)ds = θ(l)−θ(0) = 2π.

Since k(s) ≤ c, we obtain

2π = ? l

0

k(s)ds ≤ c ? l

0

ds = cl.

- 9. We ﬁrst observe that the intersection of convex sets is a convex set. Since the curve is convex, each tangent line determines a half-plane that contains the curve. The intersection all such half-planes is a convex set K′ which contains the set K bounded by the curve. Also K′ ⊂ K, for if q′ ⊂ K′, q′ ?∈ K, the segment q′p′, q′ ∈ K′, p′ ∈ K ⊂ K′ is contained in K′ by convexity, and meets the curve. This is easily seen to yield a contradiction.


- 11. Observe that the area bounded by H is greater than or equal to the area bounded by C and that the length of H is smaller than or equal to the length of C. Expand H through a family of curves parallel to H (Exercise 6) until its length reaches the length of C. Since the area either remains the same or has been further increased in this process, we obtain aconvexcurveH′ withthesamelengthasC butboundinganareagreater than or equal to the area of C.
- 12. M1 = ? 2π


0

?? 1/2

0

dp? dθ = π,

M2 = ? 2π

0

?? 1

0

dp? dθ = 2π.

(See Fig. 1-40.) Thus, M1/M2 = 21.

[Page 500]

###### SECTION 2-2

5. Yes.

- 11. b. To see that x is one-to-one, observe that from z one obtains ±u. Since cosh v > 0, the sign of u is the same as the sign of x. Thus, sinh v (and hence v) is determined.


- 13. x(u,v) = (sinh ucosv,sinh usin v,cosh v).


15. Eliminate t in the equations x/a = y/t = −(z −t)/t of the line joining

p(t) = (0,0,t) to q(t) = (a,t,0).

- 17. c. Extend Prop. 3 for plane curves and apply the argument of Example 5.
- 18. For the ﬁrst part, use the inverse function theorem. To determine F, set u = ρ2, v = tan ϕ, w = tan2 θ. Write x = f (ρ,θ)cosϕ, y = f (ρ,θ)sin ϕ, where f is to be determined. Then

x2 +y2 +z2 = f2 +z2 = ρ2,

f 2 z2 = tan2 θ.

It follows that f = ρ sin θ, z = ρ cosθ. Therefore,

F(u,v,w) = ? √uw √(1+w)(1+v2)

,

v√uw √(1+w)(1+v2)

,

√u √1+w

?.

- 19. No. For C, observe that no neighborhood in R2 of a point in the vertical arc can be written as the graph of a differentiable function. The same argument applies to S.


###### SECTION 2-3

1. Since A2 = identity, A = A−1.

5. d is the restriction to S of a function d: R3 → R:

d(x,y,z) = {(x −x0)2 +(y −y0)2 +(z −z0)2}1/2, (x,y,z) ?= (x0,y0,z0).

8. If p = (x,y,z), F(p) lies in the intersection with H of the line t →

(tx,ty,z), t > 0. Thus,

F(p) = ? √1+z2

?

x2 +y2

x,

√1+z2 ?

x2 +y2

y,z?.

Let U be R3 minus the z axis. Then F: U ⊂ R3 → R3 as deﬁned above is differentiable.

[Page 501]

13. If f is such a restriction, f is differentiable (Example 1). To prove the converse, let x: U → R3 be a parametrization of S in p. As in Prop. 1, extend x to F: U ×R → R3. Let W be a neighborhood of p in R3 on which F−1 is a diffeomorphism. Deﬁne g: W → R by g(q) = f ◦x ◦π ◦F−1(q), q ∈ W, where π: U ×R → U is the natural projection. Then g is differentiable, and the restriction g|W ∩S = f .

- 16. F is differentiable in S2 −{N} as a composition of differentiable maps. To prove that F is differentiable at N, consider the stereographic projection πS from the south pole S = (0,0,−1) and set Q = πS ◦F ◦ πS−1: U ⊂ C → C (of course, we are identifying the plane z = 1 with


C). Show that πN ◦πS−1: C−{0} → C is given by πN ◦πS−1(ζ) = 1/ζ¯. Conclude that

Q(ζ) =

ζn a¯0 +a¯1ζ +···+a¯nζn;

hence, Q is differentiable at ζ = 0. Thus, F = πS−1 ◦Q◦πS is differentiable at N.

###### SECTION 2-4

1. Let α(t) = (x(t),y(t),z(t)) be a curve on the surface passing through p0 = (x0,y0,z0) for t = 0. Thus, f(x(t),y(t),z(t)) = 0; hence, fxx′(0)+fyy′(0)+fzz′(0) = 0, where all derivatives are computed at p0. This means that all tangent vectors at p0 are perpendicular to the vector (fx,fy,fz), and hence the desired equation.

4. Denote by f′ the derivative of f (y/x) with respect to t = y/x. Then zx = f −(y/x)f′, zy = f′. Thus, the equation of the tangent plane at (x0,y0) is z = x0f +(f −(y0/x0)f ′)(x −x0)+f′(y −y0), where the functions are computed at (x0,y0). It follows that if x = 0, y = 0, then z = 0.

- 12. For the orthogonality, consider, for instance, the ﬁrst two surfaces. Their normals are parallel to the vectors (2x −a,2y,2z), (2x,2y −b,2z). In the intersection of these surfaces, ax = by; introduce this relation in the inner product of the above vectors to show that this inner product is zero.
- 13. a. Let α(t) be a curve on S with α(0) = p, α′(0) = w. Then


dfp(w) =

d dt

(?α(t)−p0,α(t)−p0?1/2)|t=0 =

?w,p −p0? |p −p0|

.

It follows that p is a critical point of f if and only if ?w,p −p0? = 0 for all w ∈ Tp(S).

[Page 502]

- 14. a. f (t) is continuous in the interval (−∞,c), and limt→−∞ f (t) = 0, limt→c,t<c f (t) = +∞. Thus, for some t1 ∈ (−∞,c), f (t1) = 1. By similar arguments, we ﬁnd real roots t2 ∈ (c,b), t3 ∈ (b,a).


b. The condition for the surfaces f (t1) = 1, f (t2) = 1 to be orthogonal

is

fx(t1)fx(t2)+fy(t1)fv(t2)+fz(t1)fz(t2) = 0. This reduces to

x2 (a −t1)(a −t2) +

y2 (b −t1)(b −t2) +

z2

(c −t1)(c −t2) = 0, which follows from the fact that t1 ?= t2 and f (t1)−f (t2) = 0.

- 17. Since every surface is locally the graph of a differentiable function, S1 is given by f (x,y,z) = 0 and S2 by g(x,y,z) = 0 in a neighborhood of p; here 0 is a regular value of the differentiable functions f and g. In this neighborhood of p, S1 ∩S2 is given as the inverse image of (0,0) of the map F: R3 → R2: F(q) = (f(q),g(q)). Since S1 and S2 intersect transversally, the normal vectors (fx,fy,fz) and (gx,gy,gz) are linearly independent. Thus, (0,0) is a regular value of F and S1 ∩S2 is a regular curve (cf. Exercise 17, Sec. 2-2).


- 20. The equation of the tangent plane at (x0,y0,z0) is


xx0 a2 +

yy0 b2 +

zz0 c2 = 1. The line through O and perpendicular to the tangent plane is given by xa2 x0 =

yb2 y0 =

zc2 z0

.

From the last expression, we obtain x2a2 xx0 =

y2b2 yy0 =

z2c2 zz0 =

a2x2 +b2y2 +c2z2 xx0 +yy0 +zz0

.

From the same expression, and taking into account the equation of the ellipsoid, we obtain

xx0 x02/a2 =

yy0 y02/b2 =

zz0 z02/c2 =

xx0 +yy0 +zz0 1

.

Again from the same expression and using the equation of the tangent plane, we obtain

x2 (x0x)/a2 =

y2 (y0y)/b2 =

z2 (z0z)/c2 =

x2 +y2 +z2 1

.

[Page 503]

The right-hand sides of the three last equations are therefore equal, and hence the asserted equation.

- 21. Imitate the proof of Prop. 9 of the appendix to Chap. 2.
- 22. Let r be the ﬁxed line which is met by the normals of S and let p ∈ S. The plane P1, which contains p and r, contains all the normals to S at the points of P1 ∩S. Consider a plane P2 passing through p and perpendicular to r. Since the normal through p meets r, P2 is transversal to Tp(S); hence, P2 ∩S is a regular plane curve C in a neighborhood of p (cf. Exercise 17, Sec. 2-4). Furthermore P1 ∩P2 is perpendicular to Tp(S)∩P2; hence, P1 ∩P2 is normal to C. It follows that the normals of C all pass through a ﬁxed point q = r ∩P2; hence, C is contained in a circle (cf. Exercise 4, Sec. 1-5). Thus, every p ∈ S has a neighborhood contained in some surface of revolution with axis r.


###### SECTION 2-5

- 8. Since ∂E/∂v = 0, E = E(u) is a function of u alone. Set u¯ =

? √E du.

Similarly,? √Gdv.Thus,G = G(v)u¯ andv¯ismeasurearclengthsalongthecoordinatecurves,a function of v alone, and we can set v¯ = whence E¯ = G¯ = 1, F¯ = cosθ.

- 9. Parametrize the generating curve by arc length.


###### SECTION 3-2

13. Since the osculating plane is normal to N, N′ = τn and, therefore, τ2 =

|N′|2 = k12 cos2 θ +k22 sin2 θ, where θ is the angle of e1 with the tangent to the curve. Since the direction is asymptotic, we obtain cos2 θ and

sin2 θ as functions of k1 and k2, which substituted in the expression above yields τ2 = −k1k2.

14. By setting λ1 = λ1N2 and λ2 = λ2N1 we have that

|λ1 −λ2| = k|?n,N1?N2 −?n,N2?N1|

= ?λ21 +λ22 −2λ1λ2 cosθ. On the other hand,

|sin θ| = |N1 ∧N2| = |n∧(N1 ∧N2)|

= |?n,N2?N1 −?n,N1?N2|.

16. Intersect the torus by a plane containing its axis and use Exercise 15.

[Page 504]

- 18. Use the fact that if θ = 2π/m, then

σ(θ) = 1+cos2 θ +···+cos2(m−1)θ =

m 2

, which may be proved by observing that

σ(θ) =

1 4

? v=m−1

?

v =−(m−1)

e2viθ +2m+1?

and that the expression under the summation sign is the sum of a geometric progression, which yields

sin(2mθ −θ) sin θ = −1.

- 19. a. Express t and h in the basis {e1,e2} given by the principal directions, and compute ?dN(t),h?.

b. Differentiate cosθ = ?N,n?, use that dN(t) = −knt +τgh, and observethat?N,b? = ?h,N? = sin θ, whereb isthebinormalvector.

- 20. Let S1,S2, and S3 be the surfaces that pass through p. Show that the geodesic torsions of C1 = S2 ∩S3 relative to S2 and S3 are equal; it will be denoted by τ1. Similarly, τ2 denotes the geodesic torsion of C2 = S1 ∩S3 and τ3 that of S1 ∩S2. Use the deﬁnition of τg to show that, since C1,C2,C3 are pairwise orthogonal, τ1 +τ2 = 0, τ2 +τ3 = 0, τ3 +τ1 = 0. It follows that τ1 = τ2 = τ3 = 0.


###### SECTION 3-3

- 2. Asymptotic curves: u = const., v = const. Lines of curvature: log(v +?

v2 +c2)±u = const.

- 3. u+v = const. u−v = const.


6. a. By taking the line r as the z axis and a normal to r as the x axis, we

have that

z′ =

√1−x2 x

. By setting x = sin θ, we obtain

z(θ) = ?

cos2 θ sin θ

dθ = log tan

θ 2 +cosθ +C.

If z(π/2) = 0, then C = 0.

[Page 505]

8. a. The assertion is clearly true if x = x1 and x¯ = x¯1 are parametrizations that satisfy the deﬁnition of contact. If x and x¯ are arbitrary, observe that x = x1 ◦h, where h is the change of coordinates. It follows that the partial derivatives of f ◦x = f ◦x1 ◦h are linear combinations of the partial derivatives of f ◦x1. Therefore, they become zero with the latter ones.

b. Introduce parametrizations x(x,y) = (x,y,f(x,y)) and x¯(x,y) = (x,y,f (x,y))¯ , and deﬁne a function h(x,y,z) = f (x,y)−z. Observe that h◦x = 0 and h◦x¯ = f −f¯. It follows from part a, applied the function h, that f −f¯ has partial derivatives of order ≤ 2 equal to zero at (0,0).

d. Sincecontactoforder≥2impliescontactoforder≥1, theparaboloid passesthroughp andistangenttothesurfaceatp. Bytakingtheplane Tp(S) as the xy plane, the equation of the paraboloid becomes

f (x,y)¯ = ax2 +2bxy +cy2 +dx +ey.

Let z = f (x,y) be the representation of the surface in the plane Tp(S). By using part b, we obtain that d = c = 0, a = 12fxx, b = fxy, c = 21fyy.

- 15. If there exists such an example, it may locally be written in the form z = f (x,y), with f (0,0) = 0, fx(0,0) = fy(0,0) = 0. The given con-

ditions require that fxx2 +fyy2 ?= 0 at (0,0) and that fxxfyy −fxy2 = 0 if and only if (x,y) = (0,0).

By setting, tentatively, f (x,y) = α(x)+β(y)+xy, where α(x) is a function of x alone and β(y) is a function of y alone, we verify that αxx = cosx, βyy = cosy satisfy the conditions above. It follows that

f (x,y) = cosx +cosy +xy −2 is such an example.

- 16. Takeaspherecontainingthesurfaceanddecreaseitsradiuscontinuously. Study the normal sections at the point (or points) where the sphere meets the surface for the ﬁrst time.


- 19. Show that the hyperboloid contains two one-parameter families of lines which are necessarily the asymptotic lines. To ﬁnd such families of lines, write the equation of the hyperboloid as


(x +z)(x −z) = (1−y)(1+y)

and show that, for each k ?= 0, the line x +z = k(1+y), x −z = (1/k)(1−y) belongs to the surface.

[Page 506]

- 20. Observe that (x/a2,y/b2,z/c2) = fN for some function f and that an umbilical point satisﬁes the equation

?

d(fN) dt ∧

dα dt

,N? = 0

for every curve α(t) = (x(t),y(t),z(t)) on the surface. Assume that z ?= 0, multiplythisequationbyz/c2, andeliminatezanddz/dt (observe that the equation holds for every tangent vector on the surface). Four umbilical points are found, namely,

y = 0, x2 = a2

a2 −b2 a2 −c2

, z2 = c2

b2 −c2 a2 −c2

.

The hypothesis z = 0 does not yield any further umbilical points.

- 21. a. Let dN(v1) = av1 +bv2, dN(v2) = cv1 +dv2. A direct computation yields


?d(fN)(v1)∧d(fN)(v2),fN? = f3 det(dN).

b. Show that fN = (x/a2,y/b2,z/c2) = W, and observe that

d(fN)(v1) = ?

αi a2

,

βi b2

,

γi c2?, where v1 = (αi,βi,γi),

i = 1,2. By choosing v1 so that v1 ∧v2 = N, conclude that

?d(fN)(v1)∧df (N)(v2),fN? =

?W,X? a2b2c2

1 f

,

where X = (x,y,z), and therefore ?W,X? = 1.

24. d. Choose a coordinate system in R3 so that the origin O is at p ∈ S, the xy plane agrees with Tp(S), and the positive direction of the z axis agrees with the orientation of S at p. Furthermore, choose the x and y axes in Tp(S) along the principal directions at p. If V is sufﬁciently small, it can then be represented as the graph of a differentiable function

z = f (x,y), (x,y) ∈ D ⊂ R2, where D is an open disk in R2 and

fx(0,0) = fy(0,0) = fxy(0,0) = 0, fxx(0,0) = k1, fyy(0,0) = k2.

We can assume, without loss of generality, that k1 ≥ 0 and k2 ≥ 0 on D, and we want to prove that f (x,y) ≥ 0 on D.

[Page 507]

Assume that, for some (x,¯ y)¯ ∈ D, f (x,¯ y)¯ < 0. Consider the function h0(t) = f (tx,t¯ y)¯ , 0 ≤ t ≤ 1. Since h′

0(0) = 0, there exists a t1, 0 ≤ t1 ≤ 1, such that h′′

0(t1) < 0, Let p1 = (t1x,t¯ 1y,f (t¯ 1x,t¯ 1y))¯ ∈ S, and consider the height function h1 of V relative to the tangent plane Tp1(S) at p1. Restricted to the curve α(t) = (tx,t¯ y,f (t¯ x,t¯ y))¯ , this height function is h1(t) = ?α(t)−p1,N1?, where N1 is the unit normal vector at p1. Thus, h′′

1(t) = ?α′′(t),N1?, and, at t = t1,

h′′1(t1) = ?(0,0,h′′0(t1)),(−fx(p1),−fy(p1),1)? = h′′0(t1) < 0. But h′′

1(t1) = ?α′′(t1),N1? is, up to a positive factor, the normal curvature at p1, in the direction of α′(t1). This is a contradiction.

###### SECTION 3-4

- 10. c. Reduce the problem to the fact that if λ is an irrationa1 number and m and n run through the integers, the set {λm+n} is dense in the real line. To prove the last assertion, it sufﬁces to show that the set {λm+n} has arbitrarily small positive elements. Assume the contrary, show that the greatest lower bound of the positive elements of {λm+n} still belongs to that set, and obtain a contradiction.
- 11. Consider the set {αi: Ii → U} of trajectories of w, with αi(0) = p, and

set I =

?

i Ii. By uniqueness, the maximal trajectory α: I → U may be deﬁned by setting α(t) = αi(t), where t ∈ Ii.

- 12. For every q ∈ S, there exist a neighborhood U of q and an interval (−ǫ,ǫ), ǫ > 0, such that the trajectory α(t), with α(0) = q, is deﬁned in (−ǫ,ǫ). By compactness, it is possible to cover S with a ﬁnite number of such neighborhoods. Let ǫ0 = minimum of the corresponding ǫ’s. If α(t) is deﬁned for t < t0 and is not deﬁned for t0, take t1 ∈ (0,t0), with |t0 −t1| < ǫ0/2. Consider the trajectory β(t) of w, with β(t1) = α(t1), and obtain a contradiction.


###### SECTION 4-2

3. The “only if” part is immediate.To prove the “if” part, let p ∈ S and v ∈ Tp(S), v ?= 0. Consider a curve α: (−ǫ,ǫ) → S, with α′(0) = v. We claim that |dϕp(α′(0))| = |α′(0)|. Otherwise, say, |dϕp(α′(0))| > |α′(0)|, and in a neighborhood J of 0 in (−ǫ,ǫ), we have |dϕα(t)(α′(t))| > |α′(t)|. This implies that the length of ϕ ◦α(J) is greater than the length of α(J), a contradiction.

[Page 508]

6. Parametrize α by arc length s in a neighborhood of t0. Construct in the

plane a curve with curvature k = k(s) and apply Exercise 5.

8. Set 0=(0,0,0), G(0)=p0, and G(p)−p0 =F(p). Then F: R3 → R3 is a map such that F(0) = 0 and |F(p)| = |G(p)−G(0)| = |p|. This implies that F preserves the inner product of R3. Thus, it maps the basis

{(1,0,0) = f1,(0,1,0) = f2,(0,0,1) = f3} onto an orthonormal basis, and if p =

? ? aifi, i = 1,2,3, then F(p) = αiF(fi). Therefore, F is linear.

- 11. a. Since F is distance-preserving and the arc length of a differentiable curve is the limit of the lengths of inscribed polygons, the restriction F|S preserves the arc length of a curve in S.

c. Consider the isometry of an open strip of the plane onto a cylinder

minus a generator.

- 12. The restriction of F(x,y,z) = (x,−y,−z) to C is an isometry of C (cf. Exercise 11), the ﬁxed points of which are (1,0,0) and (−1,0,0).


- 17. The loxodromes make a constant angle with the meridians of the sphere. Under Mercator’s projection (see Exercise 16) the meridians go into parallel straight lines in the plane. Since Mercator’s projection is conformal, the loxodromes also go into straight lines. Thus, the sum of the interior angles of the triangle in the sphere is the same as the sum of the interior angles of a rectilinear plane triangle.


###### SECTION 4-4

6. Use the fact that the absolute value of the geodesic curvature is the absolute value of the projection onto the tangent plane of the usual curvature.

- 8. Use Exercise 1, part b, and Prop. 4 of Sec. 3-2.
- 9. Usethefactthatthemeridiansaregeodesicsandthattheparalleltransport preserves angles.
- 10. Apply the relation kg2 +kn2 = k2 and the Meusnier theorem to the projecting cylinder.


- 12. Parametrize a neighborhood of p ∈ S in such a way that the two families of geodesics are coordinate curves (Corollary 1, Sec. 3-4). Show that

this implies that F = 0, Ev = 0 = Gu. Make a change of parameters to obtain that F¯ = 0, E¯ = G¯ = 1.

- 13. Fix two orthogonal unit vectors v(p) and w(p) in Tp(S) and parallel transport them to each point of V . Two differentiable, orthogonal, unit vector ﬁelds are thus obtained. Parametrize V in such a way that the


[Page 509]

directions of these vectors are tangent to the coordinate curves, which are then geodesics. Apply Exercise 12.

16. Parametrize a neighborhood of p ∈ S in such a way that the lines of curvature are the coordinate curves and that v = const. are the asymptotic curves. It follows that ev = 0, and from the Mainardi-Codazzi equations, we conclude that Ev = 0. This implies that the geodesic curvature of v = const. is zero. For the example, look at the upper parallel or the torus.

- 18. Use Clairaut’s relation (cf. Example 5).
- 19. Substitute in Eq. (4) the Christoffel symbols by their values as functions of E, F, and G and differentiate the expression of the ﬁrst fundamental form:

1 = E(u′)2 +2Fu′v′ +G(v′)2.

- 20. Use Clairaut’s relation.


###### SECTION 4-5

4. b. Observe that the map x = x¯, y = (y)¯ 5, z = (z)¯ 3 gives a homeomorphism of the sphere x2 +y2 +z2 = 1 onto the surface (x)¯ 2 +(y)¯ 10 + (z)¯ 6 = 1.

6. a. Restrict v to the curve α(t) = (cost,sin t), t ∈ [0,2π]. The angle

that v(t) forms with the x axis is t. Thus, 2πI = 2π; hence, I = 1.

d. By restricting v to the curve α(t) = (cost,sin t), t ∈ [0,2π], we obtain v(t) = (cos2 t −sin2 t,−2cost sin t) = (cos2t,−sin 2t). Thus, I = −2.

###### SECTION 4-6

8. Let (ρ,θ) be a system of geodesic polar coordinates such that its pole is one of the vertices of ? and one of the sides of ? corresponds to θ = 0. Let the two other sides be given by θ = θ0 and ρ = h(θ). Since the vertex that corresponds to the pole does not belong to the coordinate neighborhood, take a small circle of radius ǫ around the pole. Then

??

?

K

√

Gdρ dθ = ? θ

0

0

dθ ?lim

ǫ→0

? h(θ)

ǫ

K

√

Gdρ?.

[Page 510]

Observing that K√G = −(√G)ρρ and that limǫ→0(√G)ρ = 1, we have that the limit enclosed in parentheses is given by

1−

∂(√G) ∂ρ

(h(θ),θ). By using Exercise 7, we obtain

??

?

K

√

Gdρ dθ = ? θ

0

0

dθ −? θ

0

0

dϕ

= α3 −(π −α2 −α1) =

?3

1

αi −π.

- 12. c. For K ≡ 0, the problem is trivial. For K > 0, use part b. For K < 0, consider a coordinate neighborhood V of the pseudosphere (cf. Exercise 6, part b, Sec. 3-3), parametrized by polar coordinates (ρ,θ); that is, E = 1 , F = 0, G = sinh2 ρ. Compute the geodesics of V ; it is convenient to use the change of coordinates tanh ρ = 1/w, ρ ?= 0, θ = θ, so that

E =

1 (w2 −1)2

, G =

1 w2 −1

, F = 0,

Ŵ111 = −

2w w2 −1

, Ŵ121 = −

w w2 −1

, Ŵ221 = w,

and the other Christoffel symbols are zero. It follows that the nonradial geodesics satisfy the equation (d2w/dθ2)+w = 0, where w = w(θ). Thus, w = Acosθ +B sin θ; that is

Atanh ρ cosθ +B tanh ρ sin θ = 1. Therefore, the map of V into R2 given by

ξ = tanh ρ cosθ, η = tanh ρ sin θ, (ξ,η) ∈ R2, is a geodesic mapping.

- 13. b. Deﬁne x = ϕ−1: ϕ(U) ⊂ R2 → S. Let v = v(u) be a geodesic in U. Since ϕ is a geodesic mapping and the geodesics of R2 are lines, then d2v/du2 ≡ 0. By bringing this condition into part a, the required result is obtained.


c. Equation (a) is obtained from Eq. (5) of Sec. 4-3 using part b. From

Eq. (5a) of Sec. 4-3 together with part b we have

KF = (Ŵ121 )u −2(Ŵ122 )v +Ŵ122 Ŵ121 . By interchanging u and v in the expression above and subtracting the results, we obtain (Ŵ121 )u = (Ŵ122 )v, whence Eq. (b). Finally,

[Page 511]

Eqs. (c) and (d) are obtained from Eqs. (a) and (b), respectively, by interchanging u and v.

d. By differentiating Eq. (a) with respect to v, Eq. (b) with respect to u,

and subtracting the results, we obtain

EKv −FKu = −K(Ev −Fu)+K(−FŴ122 +EŴ121 ). By taking into account the values of Ŵijk , the expression above yields EKv −FKu = −K(Ev −Fu)+K(Ev −Fu) = 0.

Similarly, from Eqs. (c) and (d) we obtain FKv −GKu = 0, whence Kv = Ku = 0.

###### SECTION 4-7

- 1. Consider an orthonormal basis {e1,e2} at Tα(0)(S) and take the parallel transport of e1 and e2 along α, obtaining an orthonormal basis {e1(t),e2(t)} at each Tα(t)(S). Set w(α(t)) = w1(t)e1(t)+w2(t)e2(t).

Then Dyw = w′

1(0)e1 +w′

2(0)e2 and the second member is the velocity of the curve w1(t)e1 +w2(t)e2 in Tp(S) at t = 0.

- 2. b. Show that if (t1,t2) ⊂ I is small and does not contain “break points of α,” then the tangent vector ﬁeld of α((t1,t2)) can be extended to a vector ﬁeld y in a neighborhood of α((t1,t2)). Thus, by restricting v and w to α, property 3 becomes


d dt ?v(t),w(t)? = ?

Dv dt

,w?+?v,

Dw dt ?,

which implies that parallel transport in α|(t1,t2) is an isometry. By compactness, thiscanbeextendedtotheentireI. Conversely, assume that parallel transport is an isometry. Let α be the trajectory of y through a point p ∈ S. Restrict v and w to α. Choose orthonormal basis {e1(t),e2(t)} as in the solution of Exercise 1, and set v(t) = v1e1 +v2e2, w(t) = w1e1 +w2e2. Then property 3 becomes the “product rule”:

d dt

?

?

i

viwi? = ?

i

dvi dt

wi +?

i

vi

dwi dt

, i = 1,2.

c. Let D be given and choose an orthogonal parametrization x(u,v). Let y = y1xu +y2xv, w = w1xu +w2xv. From properties 1, 2, and 3, it follows that Dyw is determined by the knowledge of Dxuxu,

[Page 512]

Dxuxv, Dxvxv. Set Dxuxu = A111xu +A211xv, Dxuxv = A112xu +A212xv, Dxvxv = A122xu +A222xv. From property 3 it follows that the Akij satisfy the same equations as the Ŵijk (cf. Eq. (2), Sec. 4-3). Thus, Akij = Ŵijk , which proves that Dyv agrees with the operation “Take the usual derivative and project it onto the tangent plane.”

- 3. a. Observe that

dx(0,t)(1,0) = ?

∂x ∂s ?

s=0

=

d ds

γ(s,α(t),v(t))?

s=0

= v(t),

dx(0,t)(0,1) = ?

∂x ∂t ?

s=0

= α′(t).

- b. Use the fact that x is a local diffeomorphism to cover the compact set I with a family of open intervals in which x is one-to-one. Use the Heine-Borel theorem and the Lebesgue number of the covering (cf. Sec. 2-7) to globalize the result.
- c. To show that F = 0, we compute (cf. property 4 of Exercise 2)
- d


ds

F =

d ds ?

∂x ∂s

,

∂x ∂t ? = ?

D ∂s

∂x ∂s

,

∂x ∂t ?+?

∂x ∂s

,

D ∂s

∂x ∂t ? = ?

∂x ∂s

,

D ∂t

∂x ∂s ?,

because the vector ﬁeld ∂x/∂s is parallel along t = const. Since

0 =

d dt ?

∂x ∂s

,

∂x ∂s ? = 2?

D ∂t

∂x ∂s

,

∂x ∂s ?,

F does not depend on s. Since F(0,t) = 0, we have F = 0. d. This is a consequence of the fact that F = 0.

- 4. a. Use Schwarz’s inequality, ?? b

a

fg dt?2 ≤ ? b

a

f 2 dt ? b

a

g2 dt,

with f ≡ 1 and g = |dα/dt|.

- 5. a. By noticing that E(t) =


? l

0{(∂u/∂v)2 +G(γ(v,t),v)}dv, we obtain (we write γ(v,t) = u(v,t), for convenience)

E′(t) = ? l

0

?2

- ∂u

- ∂v


∂2u ∂v∂t +

∂G ∂u

u′?dv.

Since, for t = 0, ∂u/∂v = 0 and ∂G/∂u = 0, we have proved the ﬁrst part.

[Page 513]

Furthermore,

E′′(t) = ? l

0

?2?

∂2u ∂v∂t ?2 +2

∂u ∂v

∂3u ∂v∂2t +

∂2G ∂u2

(u′)2 +

∂G ∂u

u′′?dv.

Hence, by using Guu = −2K√G and noting that √G = 1 for t = 0, we obtain

E′′(0) = 2? l

0

??

dη dv?2 −Kη2? dv.

- 6. b. Choose ǫ > 0 and coordinates in R3 ⊃ S so that ϕ(ρ,ǫ) = q. Consider the points (ρ,ǫ) = r0, (ρ,ǫ +2π sin β) = r1,...,(ρ,ǫ + 2πk sin β) = rk. Taking ǫ sufﬁciently small, we see that the line segments r0r1,...,r0rk belong to V if 2πk sin β < π (Fig. 4-49). Since ϕ is a local isometry, the images of these segments will be geodesics joining q to q, which are clearly broken at q (Fig. 4-49).


c. It must be proved that each geodesic γ: [0,l] → S with γ(0) = γ(l) = q is the image by ϕ of one of the line segments r0r1,...,r0rk referred to in part b. For some neighborhood U ⊂ V of r0, the restriction ϕ|U = ϕ˜ is an isometry. Thus, ϕ˜−1 ◦γ is a segment of a half-line L starting at r0. Since ϕ(L) is a geodesic which agrees with γ([0,l]) in an open interval, it agrees with γ where γ is deﬁned. Since γ(l) = q, L passes through one of the points ri, i = 1,...,k, say rj, and so γ is the image of r0rj.

###### SECTION 5-2

3. a. Usetherelationϕ′′ = −Kϕ toobtain(ϕ′2 +Kϕ2)′ = K′ϕ2. Integrate both sides of the last relation and use the boundary conditions of the statement.

###### SECTION 5-3

- 5. Assume that every Cauchy sequence in d converges and let γ(s) be a geodesic parametrized by arc length. Suppose, by contradiction, that γ(s) is deﬁned for s < s0 but not for s = s0. Choose a sequence {sn} → s0. Thus, given ǫ > 0, there exists n0 such that if n,m > n0, |sn −sm| < ǫ. Therefore,


d(γ(sm),γ(sn)) ≤ |sn −sm| < ǫ

and {γ(sn)} is a Cauchy sequence in d. Let {γ(sn)} → p0 ∈ S and let W be a neighborhood of p0 as given by Prop. 1 of Sec. 4-7. If m,n

[Page 514]

are sufﬁciently large, the small geodesic joining γ(sm) to γ(sn) clearly agrees with γ. Thus, γ can be extended through p0, a contradiction.

Conversely, assume that S is complete and let {pn} be a Cauchy sequence in d of points on S. Since d is greater than or equal to the Euclidean distance d¯, {pn} is a Cauchy sequence in d¯. Thus, {pn} converges to p0 ∈ R3. Assume, by contradiction, that p0 ?∈ S. Since a Cauchy sequence is bounded, given ǫ > 0 there exists an index n0 such that, for all n > n0, the distance d(pn0,pn) < ǫ. By the Hopf-Rinow theorem, there is a minimal geodesic γn joining pn0 to pn with length < ǫ. As n → ∞, γn tends to a minimal geodesic γ with length ≤ ǫ. Parametrize γ by arc length s. Then, since p0 ?∈ S, γ is not deﬁned for s = ǫ. This contradicts the completeness of S.

- 6. Let {pn} be a sequence of points on S such that d(p,pn) → ∞. Since S is complete, there is a minimal geodesic γn(s) (parametrized by arc


length) joining p to pn with γn(0) = p. The unit vectors γ′

n(0) have a limit point v on the (compact) unit sphere of Tp(S). Let γ(s) = expp sv, s ≥ 0. Then γ(s) is a ray issuing from p. To see this, notice that, for

a ﬁxed s0 and n sufﬁciently large, limn→∞ γn(s0) = γ(s0). This follows from the continuous dependence of geodesics from the initial conditions. Furthermore, since d is continuous,

lim

n→∞

d(p,γn(s0)) = d(p,γ(s0)).

But if n is large enough, d(p,γn(s0)) = s0. Thus, d(p,γ(s0)) = s0, and γ is a ray.

- 8. Firstshowthatifd andd¯ denotetheintrinsicdistancesofS andS¯, respectively, then d(p,q) ≥ cd(ϕ(p),ϕ(q))¯ for all p,q ∈ S. Now let {pn} be a Cauchy sequence in d of points on S. By the initial remark, {ϕ(pn)} is a Cauchysequenceind¯. SinceS¯ iscomplete, {ϕ(pn)} → ϕ(p0). Sinceϕ−1 is continuous, {pn} → p0. Thus, every Cauchy sequence in d converges; hence S is complete (cf. Exercise 5).
- 9. ϕ is one-to-one: Assume, by contradiction, that p1 ?= p2 ∈ S1 are such that ϕ(p1) = ϕ(p2) = q. Since S1 is complete, there is a minimal geodesic γ joining p1 to p2. Since ϕ is a local isometry, ϕ ◦γ is a geodesic joining q to itself with the same length as γ. Any point distinct from q on ϕ ◦γ can be joined to q by two geodesics, a contradiction.


ϕ is onto: Since ϕ is a local diffeomorphism, ϕ(S1) ⊂ S2 is an open set in S2. We shall prove that ϕ(S1) is also closed in S2; since S2 is connected, this will imply that ϕ(S1) = S2. If ϕ(S1) is not closed in S2, there exists a sequence {ϕ(pn)}, pn ∈ S1, such that {ϕ(pn)} → p0 ∈ ϕ(S1). Thus, {ϕ(pn)} is a nonconverging Cauchy sequence in ϕ(S1). Since ϕ is a oneto-one local isometry, {pn} is a nonconverging Cauchy sequence in S1,

- a contradiction to the completeness of S1.


[Page 515]

- 10. a. Since


d dt

(h◦ϕ(t)) =

d dt?ϕ(t),v? = ?ϕ′(t),v? = ?grad h,v?

and

d dt

(h◦ϕ(t)) = dh(ϕ′(t)) = dh(grad h) = ?grad h,grad h?,

we conclude, by equating the last members of the above relations, that |grad h| ≤ 1.

- b. Assume that ϕ(t) is deﬁned for t < t0 but not for t = t0. Then there exists a sequence {tn} → t0 such that the sequence {ϕ(tn)} does not converge. If m and n are sufﬁciently large, we use part a to obtain


d(ϕ(tm),ϕ(tm)) ≤ ? t

m

tn

|grad h(ϕ(t))|dt ≤ |tm −tn|,

where d is the intrinsic distance of S. This implies that {ϕ(tn)} is a nonconverging Cauchy sequence in d, a contradiction to the completeness of S.

###### SECTION 5-4

- 2. Assume that

lim

r→∞

( inf

x2+y2≥r

K(x,y)) = 2c > 0.

Then there exists R > 0 such that if (x,y) ?∈ D, where D = {(x,y) ∈ R2;x2 +y2 < R2},

then K(x,y) ≥ c. Thus, by taking points outside the disk D, we can obtain arbitrarily large disks where K(x,y) ≥ c > 0. This is easily seen to contradict Bonnet’s theorem.

SECTION 5-5

- 3. b. Assume that a > b and set s = b in relation (∗). Use the initial conditions and the facts v′(b) < 0, u(b) > 0, uv ≥ 0 in [0,b] to obtain a contradiction.


c. From [uv′ −vu′]s0 ≥ 0, one obtains v′/v ≥ u′/u; that is, (log v)′ ≥ (log u)′. Now, let 0 < s0 ≤ s ≤ a, and integrate the last inequality between s0 and s to obtain

[Page 516]

log v(s)−log v(s0) ≥ log u(s)−log u(s0); that is, v(s)/u(s) ≥ v(s0)/u(s0). Next, observe that

lim

s0→0

v(s0) u(s0) = lim

s0→0

v′(s0) u′(s0) = 1.

Thus, v(s) ≥ u(s) for all s ∈ [0,a).

6. Suppose, by contradiction, that u(s) ?= 0 for all s ∈ (0,s0]. By using

Eq. (∗) of Exercise 3, part b (with K˜ = L and s = s0), we obtain ? s

0

0

(K −L)uv ds +u(s0)v′(s0)−u(0)v′(0) = 0.

Assume, for instance, that u(s) > 0 and v(s) < 0 on (0,s0]. Then v′(0) < 0 and v′(s0) > 0. Thus, the ﬁrst term of the above sum is ≥ 0 and the two remaining terms are > 0, a contradiction.All the other cases can be treated similarly.

8. Let v be the vector space of Jacobi ﬁelds J along γ with the property that J(l) = 0. v is a two-dimensional vector space. Since γ(l) is not conjugate to γ(0), the linear map θ: v → Tγ(0)(S) given by θ(J) = J(0) is injective, and hence, for dimensional reasons, an isomorphism. Thus, there exists J ∈ v with J(0) = w0. By the same token, there exists a Jacobi ﬁeld J¯ along γ with J(¯ 0) = 0, J(l)¯ = w1. The required Jacobi ﬁeld is given by J +J¯.

###### SECTION 5-6

10. Let γ: [0,l] → S be a simple closed geodesic on S and let v(0) ∈ Tγ(0)(S) be such that |v(0)| = 1, ?v(0),γ′(0)? = 0. Take the parallel transport v(s) of v(0) along γ. Since S is orientable, v(l) = v(0) and v deﬁnes a differentiable vector ﬁeld along γ. Notice that v is orthogonal to γ and that Dv/ds = 0, s ∈ [0,1). Deﬁne a variation (with free end points) h: [0,l)×(−ǫ,ǫ) → S by

h(s,t) = expγ(s) tv(s).

Check that, for t small, the curves of the variation ht(s) = h(s,t) are closed. Extend the formula for the second variation of arc length to the present case, and show that

L′′v(0) = −? t

0

Kds < 0.

Thus, γ(s) is longer than all curves ht(s) for t small, say, |t| < δ ≤ ǫ. By changing the parameter t into t/δ, we obtain the required homotopy.

[Page 517]

###### SECTION 5-7

- 9. Use the notion of geodesic torsion τg of a curve on a surface (cf. Exercise 19, Sec. 3-2). Since

dθ ds = τ −τg,

where cosθ = ?N,n? and the curve is closed and smooth, we obtain ? l

0

τ ds −? l

0

τg ds = 2πn,

where n is an integer. But on the sphere, all curves are lines of curvature. Since the lines of curvature are characterized by having vanishing geodesic torsion (cf. Exercise 19, Sec. 3-2), we have

? l

0

τ ds = 2πn.

Since every closed curve on a sphere is homotopic to zero, the integer n is easily seen to be zero.

SECTION 5-10

7. We have only to show that the geodesics γ(s) parametrized by arc length

which approach the boundary of R+2 are deﬁned for all values of the parameter s. If the contrary were true, such a geodesic would have a

ﬁnite length l, say, from a ﬁxed point p0. But for the circles of R+2 that are geodesics, we have

l = ?lim

ǫ→0

? ǫ

θ0>π/2

dθ sin θ ? ≥ ?lim

ǫ→0

? ǫ

θ0>π/2

cosθdθ

sin θ ? = ∞, and the same holds for the vertical lines of R+2 .

- 10. c. To prove that the metric is complete, notice ﬁrst that it dominates the Euclidean metric on R2. Thus, if a sequence is a Cauchy sequence in the given metric, it is also a Cauchy sequence in the Euclidean metric. Since the Euclidean metric is complete, such a sequence converges. It follows that the given metric is complete (cf. Exercise 1, Sec. 5-3).


[Page 518]

[Page 519]

###### Index

Acceleration vector, 350 Accumulation point, 461 Angle:

between two surfaces, 89 external, 269 interior, 278

Antipodal map, 82 Arc, 465

regular, 269

Arc length, 6 in polar coordinates, 26 (Ex. 11) reparametrization by, 23

Area, 100 geometric deﬁnition of, 117 of a graph, 102 (Ex. 5) oriented, 16 (Ex. 10), 168 of surface of revolution, 103 (Ex. 11)

Area-preserving diffeomorphisms, 233 (Ex. 18),

234 (Ex. 20) Asymptotic curve, 150 Asymptotic direction, 150

Ball, 120 Beltrami-Enneper, theorem of, 154 (Ex. 13) Beltrami’s theorem on geodesic mappings, 301

(Ex. 12) Bertrand curve, 27 Bertrand mate, 27 Binormal line, 20 Binormal vector, 18 Bolzano-Weierstrass theorem, 115, 126, 469

Bonnet, O., 268 Bonnet’s theorem, 358, 429 Boundary of a set, 463 Braunmühl, A., 369 Buck, R. C., 45, 100, 133

Calabi, E., 359 Catenary, 25 (Ex. 8) Catenoid, 224

asymptotic curves of, 170 (Ex. 3) local isometry of, with a helicoid,

216 (Ex. 14), 226

as a minimal surface, 204 Cauchy-Crofton formula, 42 Cauchy sequence, 464

in the intrinsic distance, 342 (Ex. 5) Chain rule, 93 (Ex. 24), 127, 131 Chern, S. S., 323

and Lashof, R., 393 Christoffel symbols, 235 in normal coordinates, 299 (Ex. 4) for a surface of revolution, 236

Cissoid of Diocles, 7 (Ex. 3) Clairaut’s relation, 260 Closed plane curve, 32 Closed set, 462 Closure of a set, 462 Compact set, 114, 468 Comparison theorems, 374 (Ex. 3) Compatibility equations, 239 Complete surface, 331

###### 503

[Page 520]

Cone, 66, 67 (Ex. 3), 333 geodesics of, 312 (Ex. 6) local isometry of, with plane, 226 as a ruled surface, 192

Conformal map, 229 linear, 232 (Ex. 13) local, 229, 233 (Ex. 14)

of planes, 233 (Ex. 15) of spheres into planes, 233 (Ex. 16)

Conjugate directions, 152 Conjugate locus, 368 Conjugate minimal surfaces, 216 (Ex. 14) Conjugate points, 368

Kneser criterion for, 376 (Ex. 7) Connected, 465

arcwise, 465

locally, 467 component, 472 simply

locally, 389 Connection, 311 (Ex. 2), 447 Conoid, 213 (Ex. 5) Contact of curves, 173 (Ex. 9) Contact of curves and surfaces, 174 (Ex. 10) Contact of surfaces, 94 (Ex. 27), 172 (Ex. 8) Continuous map, 122

uniformly, 471 Convergence, 460

in the intrinsic distance, 341 (Ex. 4) Convex curve, 39 Convex hull, 50 (Ex. 11) Convex neighborhood, 307

existence of, 309 Convex set, 50 (Ex. 9) Convexity and curvature, 41, 177 (Ex. 24),

393, 403 Coordinate curves, 55 Coordinate neighborhood, 55 Coordinate system, 55 Courant, R., 117 Covariant derivative, 241

algebraic value of, 251 along a curve, 243 expression of, 242 properties of, 310 (Ex. 2) in terms of parallel transport, 310 (Ex. 1)

Covering space, 377 number of sheets of, 384 orientable double, 449 (Exs. 3, 4)

Critical point, 60, 92 (Ex. 13)

nondegenerate, 177 (Ex. 23) Critical value, 60

Cross product, 13 Curvature:

Gaussian, 148, 158 (see also Gaussian

curvature) geodesic, 251, 256 lines of, 147

differential equations of, 163 mean, 148, 158, 166 vector, 203 normal, 143 of a plane curve, 22 principal, 146 radius of, 20 sectional, 448 of a space curve, 17

in arbitrary parameters, 26 (Ex. 12)

Curve:

asymptotic, 150 differential equations for, 162 maximal, 417

of class Ck, 10 (Ex. 7) closed, 32

continuous, 399 piecewise regular, 269 simple, 32

coordinate, 55 divergent, 342 (Ex. 7) knotted, 409 level, 104 (Ex. 14) parametrized, 3

piecewise differentiable, 334 piecewise regular, 247 regular, 6

piecewise C1, 37 simple, 10 (Ex. 7)

Cut locus, 425 Cycloid, 7 Cylinder, 67 (Ex. 1)

ﬁrst fundamental form of, 96 isometries of, 232 (Ex. 12) local isometry of, with plane, 222 normal sections of, 146 as a ruled surface, 192

Darboux trihedron, 264 (Ex. 14) Degree of a map, 397 Developable surface, 197, 213 (Ex. 3)

classiﬁcation of, 197 as the envelope of a family of tangent

planes, 198 tangent plane of a, 213 (Ex. 6)

[Page 521]

Diffeomorphism, 76 area-preserving, 233 (Exs. 18, 19) local, 89

orientation-preserving, 168 orientation-reversing, 168

Differentiable function, 75, 83 (Ex. 9),

84 (Ex. 13), 126 Differentiable manifold, 444 Differentiable map, 75, 128, 432 Differentiable structure, 431, 444 Differential of a map, 89, 128 Direction:

asymptotic, 150 principal, 146

Directions: conjugate, 152 ﬁeld of, 181

Directrix of a ruled surface, 191 Distance on a surface, 335 Distribution parameter, 195 do Carmo, M. and E. Lima, 394 Domain, 99 Dot product, 4 Dupin indicatrix, 150

geometric interpretation of, 166 Dupin’s theorem on triply orthogonal

systems, 155

Edges of a triangulation, 275 Eﬁmov, N. V., 457 Eigenvalue, 219 Eigenvector, 219 Ellipsoid, 63, 82 (Ex. 4), 93 (Ex. 20)

conjugate locus of, 266 ﬁrst fundamental form of, 102 (Ex. 1) Gaussian curvature of, 176 (Ex. 21) parametrization of, 69 (Ex. 12) umbilical points of, 175

Embedding, 441 of the Klein bottle into R4, 442 of the projective plane into R4, 443 of the torus into R4, 441 Energy of a curve, 311 (Ex. 4) Enneper’s surface, 170 (Ex. 3) as a minimal surface, 208

Envelope of a family of tangent planes, 198, 213

(Ex. 8), 215 (Ex. 10), 247, 313 (Ex. 7) Euclid’s ﬁfth axiom, 283, 436, 438 Euler formula, 147 Euler-Lagrange equation, 371 Euler-Poincaré characteristic, 275 Evolute, 24 (Ex. 7)

Exponential map, 288 differentiability of, 289

Faces of a triangulation, 275 Fary-Milnor Theorem, 409 Fenchel’s theorem, 405 Fermi coordinates, 311 (Ex. 3) Field of directions, 181

differential equation of, 182 integral curves of, 182

Field of unit normal vectors, 107 First fundamental form, 94 Flat torus, 440 Focal surfaces, 214 (Ex. 9) Folium of Descartes, 9 (Ex. 5) Frenet formulas, 20 Frenet trihedron, 20 Function:

analytic, 209 component, 122 continuous, 121 differentiable, 75, 126 harmonic, 204 height, 75 Morse, 177 (Ex. 23)

Fundamental theorem for the local theory of curves, 20, 315 Fundamental theorem for the local theory of surfaces, 239, 317

Gauss-Bonnet theorem (global), 277

application of, 280 Gauss-Bonnet theorem (local), 272 Gauss formula, 238

in orthogonal coordinates, 240 (Ex. 1) Gauss lemma, 292 Gauss map, 138 Gauss theorem egregium, 237 Gaussian curvature, 148, 158

geometric interpretation of, 168 for graphs of differentiable functions,

166

in terms of parallel transport, 274 Genus of a surface, 276 Geodesic:

circles, 291 coordinates, 311 (Ex. 3) curvature, 251, 256 ﬂow, 446 mapping, 300 (Ex. 11) parallels, 311 (Ex. 3)

[Page 522]

Geodesic: (Cont.)

polar coordinates, 290 ﬁrst fundamental form in, 291 Gaussian curvature in, 292 geodesics in, 300 (Ex. 7) torsion, 155 (Ex. 19), 264 (Ex. 14)

Geodesics, 312 of a cone, 312 (Ex. 6) of a cylinder, 249, 250 differential equations of, 257 existence of, 257 minimal, 307, 337 minimizing properties of, 296 of a paraboloid of revolution, 261–262 of the Poincaré half-plane, 437, 438,

450 (Ex. 8) radial, 291 as solutions to a variational problem, 351 of a sphere, 249 of surfaces of revolution, 258–261,

362 (Ex. 5) Gluck, H., 42 Gradient on surfaces, 104 (Ex. 14) Graph of a differentiable function, 60

area of, 102 (Ex. 5) Gaussian curvature of, 166 mean curvature of, 166 second fundamental form of, 166 tangent plane of, 90 (Ex. 3)

Green, L., 369 Gromov, M. L., and V. A. Rokhlin, 457 Group of isometries, 232 (Ex. 9)

Hadamard’s theorem on complete surfaces with

K ≤ O, 393, 396 (Ex. 9) Hadamard’s theorem on ovaloids, 393 Hartman, P. and L. Nirenberg, 414 Heine-Borel theorem, 115, 126 Helicoid, 96

asymptotic curves of, 170 (Ex. 2) distribution parameter of, 212 (Ex. 1) generalized, 103 (Ex. 13), 189 (Ex. 6) line of striction of, 212 (Ex. 1) lines of curvature of, 170 (Ex. 2) local isometry of, with a catenoid,

216 (Ex. 14), 226 as a minimal surface, 206 as the only minimal ruled surface, 207 tangent plane of, 91 (Ex. 9)

Helix, 2, 23 (Ex. 1)

generalized, 27 (Ex. 17) Hessian, 166, 176 (Ex. 22) Hilbert, D., 451

Hilbert’s theorem, 451 Holmgren, E., 451 Holonomy group, 302 (Ex. 13) Homeomorphism, 125 Homotopic arcs, 385 Homotopy of arcs, 385 free, 396 (Ex. 10) lifting of, 385

Hopf, H. and W. Rinow, 331, 359 Hopf-Rinow’s theorem, 338 Hopf’s theorem on surfaces with H = const.,

237 (Ex. 4) Hurewicz, W., 180 Hyperbolic paraboloid (saddle surface),

69 (Ex. 11), Fig. 3-7 asymptotic curves of, 187 ﬁrst fundamental form of, 102 (Ex. 1) Gauss map of, 141 parametrization of, 69 (Ex. 11) as a ruled surface, 196

Hyperbolic plane, 436 Hyperboloid of one sheet, 90 (Ex. 2), Fig. 3-34

Gauss map of, 153 (Ex. 8) as a ruled surface, 193, 212 (Ex. 2)

Hyperboloid of two sheets, 63 ﬁrst fundamental form of, 102 (Ex. 1) parametrization of, 69 (Ex. 13), 102 (Ex. 1)

Immersion, 438

isometric, 438 Index form of a geodesic, 427 Index of a vector ﬁeld, 283 Inﬁmum (g.l.b.), 464 Integral curve, 182 Intermediate value theorem, 126 Intrinsic distance, 228, 335 Intrinsic geometry, 220, 238, 241 Inverse function theorem, 133 Inversion, 123 Isometry, 221

linear, 231 (Ex. 7) local, 222

in local coordinates, 223, 231 (Ex. 2) of tangent surfaces to planes, 231 (Ex. 6)

Isoperimetric inequality, 34

for geodesic circles, 300 (Ex. 9) Isothermal coordinates, 204, 230

for minimal surfaces, 216 (Ex. 13(b))

Jacobi equation, 364 Jacobi ﬁeld, 363

on a sphere, 368

[Page 523]

Jacobian determinant, 130 Jacobian matrix, 130 Jacobi’s theorem on the normal indicatrix, 281 Jacobi’s theorems on conjugate points, 424, 428 Joachimstahl, theorem of, 154 (Ex. 15) Jordan curve theorem, 400

Kazdan, J. and F. Warner, 451 Klein bottle, 433

embedding of, into R4, 442, 443 non-orientability of, 442

Klingenberg’s lemma, 395 (Ex. 8) Kneser criterion for conjugate points,

376 (Ex. 7) Knotted curve, 409

Lashof, R. and S. S. Chern, 393 Lebesgue number of a family, 115 Levi-Civita connection, 447 Lifting:

of an arc, 382 of a homotopy, 385 property of, arcs, 386

Lima, E. and M. do Carmo, 394 Limit point, 461 Limit of a sequence, 460 Line of curvature, 147 Liouville:

formula of, 256 surfaces of, 266

Local canonical form of a curve, 28 Locally convex, 177 (Ex. 24), 393

strictly, 177 (Ex. 24) Logarithmic spiral, 9 Loxodromes of a sphere, 99, 233

Mainardi-Codazzi equations, 238 Mangoldt, H., 369 Map:

antipodal, 82 (Ex. 1) conformal, 229

linear, 232 (Ex. 13) continuous, 122 covering, 377 differentiable, 75, 128, 432 distance-preserving, 232 (Ex. 8) exponential, 287 Gauss, 138 geodesic, 300 (Ex. 11) self-adjoint linear, 217

Massey, W., 414 Mean curvature, 148, 158, 166

Mean curvature vector, 203 Mercator projection, 233 (Ex. 16), 234 (Ex. 20) Meridian, 79 Meusnier theorem, 144 Milnor, T. Klotz, 457 Minding’s theorem, 292 Minimal surfaces, 200

conjugate, 216 (Ex. 14) Gauss map of, 216 (Ex. 13) isothermal parameters on, 204,

216 (Ex. 13(b)) of revolution, 205 ruled, 207 as solutions to a variational problem, 202

Möbius strip, 108 Gaussian curvature of, 175 (Ex. 18) inﬁnite, 448 (Ex. 2) nonorientability of, 110, 112 (Exs. 1, 7) parametrization of, 108

Monkey saddle, 161, 174 (Ex. 11) Morse index theorem, 427

Neighborhood, 121, 124 convex, 307 coordinate, 55 distinguished, 378 normal, 289

Nirenberg, L. and P. Hartman, 414 Norm of a vector, 4 Normal:

coordinates, 290 curvature, 143 indicatrix, 281 line, 89 plane to a curve, 20 principal, 20 section, 144 vector to a curve, 18 vector to a surface, 89

Olinde Rodrigues, theorem of, 147 Open set, 120 Orientation:

change of, for curves, 7 for curves, 112 (Ex. 6) positive, of Rn, 12 for surfaces, 106, 138 of a vector space, 12

Oriented: area in R2, 16 (Ex. 10) positively, boundary of a simple region, 271 positively, simple closed plane curve, 33

[Page 524]

Oriented: (Cont.) surface, 106, 109 volume in R3, 17 (Ex. 11)

Orthogonal: families of curves, 105 (Ex. 15), 184, 189 (Ex. 6) ﬁelds of directions, 184, 188 (Ex. 4),

188 (Ex. 5) parametrization, 98, 186 projection, 82 (Ex. 2), 123 transformation, 24 (Ex. 6), 231 (Ex. 7)

Osculating: circle to a curve, 31 (Ex. 2b) paraboloid to a surface, 173 (Ex. 8(c)) plane to a curve, 18, 30, 31 (Ex. 1), 31 (Ex. 2) sphere to a curve, 174 (Ex. 10(c)) Osserman’s theorem, 211, 343 (Ex. 11) Ovaloid, 328, 393

Paraboloid of revolution, 82 (Ex. 3) conjugate points on, 374 (Ex. 2) Gauss map of, 142 geodesics of, 261

Parallel: curves, 49 (Ex. 6) surfaces, 215 (Ex. 11) transport, 245

existence and uniqueness of, 245, 255 geometric construction of, 247

vector ﬁeld, 244

Parallels: geodesic, 311 (Ex. 3(d)) of a surface of revolution, 79

Parameter: of a curve, 4 distribution, 195

Parameters: change of, for curves, 85 (Ex. 15) change of, for surfaces, 72 isothermal, 230

existence of, 230 existence of, for minimal surfaces, 216 (Ex. 13(b))

Parametrization of a surface, 55 by asymptotic curves, 187 by lines of curvature, 188 orthogonal, 98

existence of, 186 Partition, 10 (Ex. 8), 116 Plane:

hyperbolic, 436 normal, 20

osculating, 18, 30, 31 (Ex. 1), 31 (Ex. 2) real projective, 433 rectifying, 20 tangent, 86

Planes, one-parameter family of tangent, 215

(Ex. 10), 313 (Ex. 7) Plateau’s problem, 203 Poincaré half-plane, 437

completeness of, 450 (Ex. 7) geodesics of, 438, 450 (Ex. 8)

Poincaré’s theorem on indices of a vector ﬁeld, 286

Point: accumulation, 461 central, 194 conjugate, 368 critical, 60, 92 (Ex. 13) elliptic, 148 hyperbolic, 148 isolated, 464 limit, 461 parabolic, 148 umbilical, 149

Pole, 396 (Ex. 11) Principal:

curvature, 146 direction, 146 normal, 20

Product: cross, 13 dot, 4 inner, 4 vector, 13

Projection, 82 (Ex. 2), 123 Mercator, 233 (Ex. 16), 234 (Ex. 20) stereographic, 69 (Ex. 16), 231 (Ex. 4)

Projective plane, 433 embedding of, into R4, 443 nonorientability of, 441 orientable double covering of, 449 (Ex. 3)

Pseudo-sphere, 171 (Ex. 6)

Radius of curvature, 20 Ray, 342 (Ex. 6) Rectifying plane, 20

envelope of, 314 (Ex. 7(b)) Region, 99

bounded, 99 regular, 275 simple, 271

Regular: curve, 70 (Ex. 17), 77

[Page 525]

parametrized curve, 6 parametrized surface, 80 surface, 54 value, 60,

94 (Ex. 28) inverse image of, 61, 94 (Ex. 28)

Reparametrization by arc length, 23 Riemannian:

manifold, 446

covariant derivative on, 447 metric, 446

on abstract surfaces, 435

structure, 447 Rigid motion, 24 (Ex. 6), 44 Rigidity of the sphere, 323 Rinow, W. and H. Hopf, 331, 359 Rokhlin, V. A. and M. L. Gromov, 457 Rotation, 77, 88 Rotation axis, 79 Rotation index of a curve, 39, 399 Ruled surface, 191

central points of, 194 directrix of, 191 distribution parameter of, 195 Gaussian curvature of, 195 line of striction of, 194 noncylindrical, 193 rulings of, 191

Ruling, 191

Samelson, H., 116 Santaló, L., 47 Scherk’s minimal surface, 210 Schneider, R., 56 Schur’s theorem for plane curves, 412 (Ex. 7),

413 (Ex. 8) Second fundamental form, 143 Set:

arcwise connected, 465 bounded, 114 closed, 462 compact, 114, 468 connected, 465 convex, 50 (Ex. 9) locally simply connected, 389 open, 120 simply connected, 388

Similarity, 301 (Ex. 11) Similitude, 190 (Ex. 9), 232 (Ex. 13) Simple region, 271 Singular point:

of a parametrized curve, 6

of a parametrized surface, 80 of a vector ﬁeld, 283

Smooth function, 2 Soap ﬁlms, 202 Sphere, 57

conjugate locus on, 368–369 as double covering of projective plane, 448

(Ex. 2) ﬁrst fundamental form of, 98 Gauss map of, 139 geodesics of, 249 isometries of, 232 (Ex. 11), 267 (Ex. 23) isothermal parameters on, 231 (Ex. 4) Jacobi ﬁeld on, 368 orientability of, 106 parametrizations of, 57–60, 69 (Ex. 16) rigidity of, 323 stereographic projection of, 69 (Ex. 16)

Spherical image, 153 (Ex. 9), 283 Stereographic projection, 69 (Ex. 16),

231 (Ex. 4) Stoker, J. J., 393, 414 Stoker’s remark on Eﬁmov’s theorem,

457 (Ex. 1) Stoker’s theorem for plane curves, 413 (Ex. 8) Striction, line of, 194 Sturm’s oscillation theorem, 376 (Ex. 6) Supremum (l.u.b.), 464 Surface:

abstract, 431 complete, 331 connected, 63 developable, 197, 213 (Ex. 3) focal, 214 (Ex. 9) geometric, 435 of Liouville, 266 minimal, 200 parametrized, 80

regular, 80 regular, 54 of revolution (see Surfaces of revolution) rigid, 323 ruled (see Ruled surface) tangent, 81

Surfaces of revolution, 79 area of, 103 (Ex. 11) area-preserving maps of, 234 (Ex. 20) Christoffel symbols, 236 conformal maps of, 234 (Ex. 20) with constant curvature, 171 (Ex. 7), 326 extended, 80 Gaussian curvature of, 164

[Page 526]

Surfaces of revolution (Cont.) geodesics of, 258–261 isometries of, 232 (Ex. 10) mean curvature of , 165 parametrization of, 79 principal curvatures of, 165

Symmetry, 77, 123 Synge’s lemma, 396 (Ex. 10)

Tangent: bundle, 444 indicatrix, 24 (Ex. 3), 37 line to a curve, 6 map of a curve, 399 plane, 86, 90 (Exs. 1, 3)

of abstract surfaces, 435 strong, 10 (Ex. 7) surface, 81 vector to an abstract surface, 433 vector to a curve, 2 vector to a regular surface, 85 weak, 10 (Ex. 7)

Tangents, theorem of turning, 270, 402 Tchebyshef net, 102 (Exs. 3, 4), 240 (Ex. 5), 452 Tissot’s theorem, 190 (Ex. 9) Topological properties of surfaces, 275 Torsion:

in an arbitrary parametrization, 26 (Ex. 12) geodesic, 155 (Ex. 19), 264 (Ex. 14) in a parametrization by arc length, 26 (Ex. 12) sign of, 29

Torus, 64 abstract, 439 area of, 101 ﬂat, 440 Gaussian curvature of, 159 implicit equation of, 65 as orientable double covering of Klein bottle,

449 (Ex. 3) parametrization of, 67 Total curvature, 405 Trace of a parametrized curve, 2 Trace of a parametrized surface, 80 Tractrix, 8 (Ex. 4) Translation, 24 (Ex. 6) Transversal intersection, 93 (Ex. 17) Triangle on a surface, 275

geodesic, 267, 282

free mobility of small, 300 (Ex. 8) Triangulation, 275 Trihedron:

Darboux, 264 (Ex. 14) Frenet, 20

Tubular: neighborhood, 112, 406 surfaces, 91 (Ex. 10), 406

Umbilical point, 149 Uniformly continuous map, 471 Unit normal vector, 89

Variation: ﬁrst, of arc length, 350 second, of arc length, 357 second, of energy for simple geodesics,

312 (Ex. 5)

Variations: broken, 426 calculus of, 360–362 (Exs. 4, 5) of curves, 345 orthogonal, 351 proper, 345 of simple geodesics, 312 of surfaces, 200

Vector: acceleration, 350 length of, 4 norm of, 4 tangent (see Tangent, vector) velocity, 2

Vector ﬁeld along a curve, 243 covariant derivative of, 243 parallel, 244 variational, 344

Vector ﬁeld along a map, 348 Vector ﬁeld on a plane, 178

local ﬁrst integral of, 181 local ﬂow of, 180 trajectories of, 179

Vector ﬁeld on a surface, 183, 241 covariant derivative of, 241 derivative of a function relative to,

189 (Ex. 7) maximal trajectory of, 190 (Ex. 11) singular point of, 283

Vertex: the four, theorem, 39 of a plane curve, 39

Vertices of a piecewise regular curve, 269 Vertices of a triangulation, 275

Warner, F. and J. Kazdan, 451 Weingarten, equations of, 157 Winding number, 399

[Page 527]

[Page 528]

[Page 529]

![image 4](<DoCormo2016_images/imageFile4.png>)

ISBN-13: ISBN-10:

978-0-486-80699-0 0-486-80699-5

9 780486 806990

5 2 9 9 5

$29.95 USA

WWW.DOVERPUBLICATIONS.COM

MATHEMATICS

##### O

ne of the most widely used texts in its ﬁeld, this volume

introduces the differential geometry of curves and surfaces in both local and global aspects. The presentation departs from the traditional approach with its more extensive use of elementary linear algebra and its emphasis on basic geometrical facts rather than machinery or random details. Many examples and exercises enhance the clear, well-written exposition, along with hints and answers to some of the problems.

The treatment begins with a chapter on curves, followed by explorations of regular surfaces, the geometry of the Gauss map, the intrinsic geometry of surfaces, and global differential geometry. Suitable for advanced undergraduates and graduate students of mathematics, this text’s prerequisites include an undergraduate course in linear algebra and some familiarity with the calculus of several variables. For this second edition, the author has corrected, revised, and updated the entire volume.

Dover revised and updated republication of the edition originally published by Prentice-Hall, Inc., Englewood Cliffs, New Jersey, 1976.

CoverdesignbyJohnM.Alves
