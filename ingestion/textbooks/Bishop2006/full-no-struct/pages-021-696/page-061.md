[Page 61]

Figure 1.25 An example of a loss matrix with elements L kj for the cancer treatment problem. The rows correspond to the true class, whereas the columns correspond to the assignment of class made by our decision criterion.

$$
\begin{smallmatrix} & & \text {cancer } & \text {normal} \\ \text {cancer } & ( \begin{array} { c c c } & 0 & & 1 0 0 0 \\ & & 1 & & 0 \end{array} ) \end{smallmatrix}
$$

# 1.5.2 Minimizing the expected loss

For many applications, our objective will be more complex than simply minimizing the number of misclassiﬁcations. Let us consider again the medical diagnosis problem. We note that, if a patient who does not have cancer is incorrectly diagnosed as having cancer, the consequences may be some patient distress plus the need for further investigations. Conversely, if a patient with cancer is diagnosed as healthy, the result may be premature death due to lack of treatment. Thus the consequences of these two types of mistake can be dramatically different. It would clearly be better to make fewer mistakes of the second kind, even if this was at the expense of making more mistakes of the ﬁrst kind.

We can formalize such issues through the introduction of a loss function , also called a cost function , which is a single, overall measure of loss incurred in taking any of the available decisions or actions. Our goal is then to minimize the total loss incurred. Note that some authors consider instead a utility function , whose value they aim to maximize. These are equivalent concepts if we take the utility to be simply the negative of the loss, and throughout this text we shall use the loss function convention. Suppose that, for a new value of x , the true class is C k and that we assign x to class C j (where j may or may not be equal to k ). In so doing, we incur some level of loss that we denote by L kj , which we can view as the k,j element of a loss matrix . For instance, in our cancer example, we might have a loss matrix of the form shown in Figure 1.25. This particular loss matrix says that there is no loss incurred if the correct decision is made, there is a loss of 1 if a healthy patient is diagnosed as having cancer, whereas there is a loss of 1000 if a patient having cancer is diagnosed as healthy.

The optimal solution is the one which minimizes the loss function. However, the loss function depends on the true class, which is unknown. For a given input vector x , our uncertainty in the true class is expressed through the joint probability distribution p ( x , C k ) and so we seek instead to minimize the average loss, where the average is computed with respect to this distribution, which is given by

$$
\mathbb { E } [ L ] & = \sum _ { k } \sum _ { j } \int _ { \mathcal { R } _ { j } } L _ { k j } p ( x , \mathcal { C } _ { k } ) \, d x . & ( 1 . 8 0 ) \\ \intertext { h o s i g n a d o n d e n d o n t y t o n t a l l e f t h e d o c i a t i o n r a g i o n s \mathcal { T } } & \mathcal { R } = \mathcal { O } .
$$

Each x can be assigned independently to one of the decision regions R j . Our goal is to choose the regions R j in order to minimize the expected loss (1.80), which implies that for each x we should minimize k L kj p ( x , C k ) . As before, we can use the product rule p ( x , C k ) = p ( C k | x ) p ( x ) to eliminate the common factor of p ( x ) . Thus the decision rule that minimizes the expected loss is the one that assigns each
