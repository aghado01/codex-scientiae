[Page 6]

![This is an image of a graph. There are five categories on the x-axis, which are named as follows: (a) Itsy Bitsy Spider, (b) Row Row Your Boat, (c) London Bridge, (d) The Emperor's New Clothes, and (e) Alice in Wonderland. There are five categories on the y-axis, which are named as follows: (a) Little Red-Cap, (b) Row Row Your Boat, (c) London Bridge, (d) The Emperor's New Clothes, and (e) Alice in Wonderland. There are five categories on the x-axis, which are named as follows: (a) The Emperor's New Clothes, (b) Little Red-Cap, (c) London Bridge, (d) The Emperor's New Clothes, and (e) Alice in Wonderland. There are five categories on the y-axis, which are named as follows: (](<SIFTS/imageFile14.png>)

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)





















1 2 3 SIFTS (dimension 1)

2 4 SIF (dimension 1)

2 4 SIFTS (dimension 1)

1 2 3 SIF (dimension 1)

2 4 SIF (dimension 1)

2 4 SIFTS (dimension 1)





















(a) Itsy Bitsy Spider

(b) Row Row Row Your Boat

(c) London Bridge

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)

SIF (dimension 0)

SIFTS (dimension 0)


0.5


1.5


0.5


1.5


0.5


1.5


0.5


1.5


0.5


1.5


0.5


1.5

0.5 1 SIF (dimension 1)

0.5 1 SIFTS (dimension 1)

0.5 1 SIF (dimension 1)

0.5 1 SIFTS (dimension 1)

0.5 1 SIF (dimension 1)

0.5 1 SIFTS (dimension 1)


0.5


1.5


0.5


1.5


0.5


1.5


0.5


1.5


0.5


1.5


0.5


1.5

(d) The Emperor’s New Clothes

(e) Little Red-Cap

(f) Alice in Wonderland

Figure 1: Persistent homology on nursery rhymes and other stories



| 1.38 (.01) |
|---|







Table 1: Statistics on child vs. adolescent writing. Entries signiﬁcantly different from child are marked by ∗

when the ﬁrst hole in H 1 forms. If there is no hole we set ∗ = π/ 2 , the largest angular distance possible.

The ﬁrst two columns in Table 1 show a marked difference between child vs. adolescent writing. Only 87% of child essays have holes while all adolescent essays do ( p = 0 . 01 , Fisher’s test). The average child essay has 3 holes while adolescent has 17.6 ( p = 10 − 55 , t -test). First hole appears earlier in adolescent ( p = 0 . 01 , t -test).

One has reason to suspect that the homology differs solely because adolescent essays are about twice as long. We thus create a third “adolescent truncated” data set, where we keep the ﬁrst 11 sentences in each adolescent essay to match child writing. This perhaps removed many later tie-backs in the essays. The third column in Table 1, however, still shows some differences compared to child writing: more truncated adolescent essays contain holes ( p = 0 . 03 , Fisher’s test). On average a truncated essay has one more hole ( p = 0 . 03 , t test). But the ﬁrst-birth ∗ is no longer signiﬁcantly different ( p = 0 . 2 , t -test).

We conclude that persistent homology detects signiﬁcant differences between child and adolescent writing using only structural features. The point is not that classifying the two classes requires such sophisticated machinery – simpler features such as word usage probably sufﬁce. Rather, our experiment shows that there is useful information in homology. Incorporating such information into existing text representation for NLP tasks such as discourse structure modeling or parsing can potentially enhance these tasks. This remains future work.

## 4 Discussion: Merely Counting Repeats?

Our nursery rhyme examples may give the impression that persistent homology computed by SIFTS is simply ﬁnding repeated ( -close) text units. After all, in a document x 1 x 2 x 3 where x 1 ,x 2 ,x 3 are within of each other and represents long sequence of mutually dissimilar units, SIFTS will identify exactly two independent holes: x 1 x 2 where x 2 ties back to x 1 , and similarly x 2 x 3 . k such repeats of x will generate k − 1 holes. It seems one can just count k the number of repeats to get the Betti number β 1 = k − 1 . This impression is incomplete. Consider the document

x 1 x 2 x 3 y z x 4 depicted on left, where y and z are distant. The SIFTS time skeleton is in red. There are k = 4 repeats of x but β 1 = 1 not 3, since the x ’s form a 3-simplex (yellow). x x x

![image 15](<SIFTS/imageFile15.png>)












x 13



Perhaps such problem can be dealt with by preprocessing, where one merges contiguous units within ? Surely with x 1 x 2 x 3 merged into a super unit x , we can using counting again to detect two repeats x ,x 4 and correctly infer one hole. However, consider another document x 1 x 2 ...x 13 on the right, where all contiguous unit pairs are within (the short diagonal length). The preprocessing will merge all units into a single super unit, thus incorrectly predicting 0 holes. In contrast, SIFTS can correctly identify the two holes. Homology is not just counting repeated text units.

The barcodes in this paper were computed with the javaPlex software [ Tausz et al. , 2011 ] . Our data and SIF, SIFTS code is online at http://pages.cs.wisc.edu/ ∼ jerryzhu/publications.html. Acknowledgments: I thank Kevyn Collins-Thompson for dis-

cussions on corpora, the anonymous reviewers for helpful comments, and the support of NSF IIS-0953219, IIS-1216758, IIS1148012, IIS-0916038.
