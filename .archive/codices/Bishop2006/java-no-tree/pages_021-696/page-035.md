[Page 35]

and is simply “the probability of X”. These two simple rules form the basis for all of the probabilistic machinery that we use throughout this book.

From the product rule, together with the symmetry property p(X,Y ) = p(Y,X), we immediately obtain the following relationship between conditional probabilities

p(X|Y )p(Y ) p(X)

p(Y |X) =

(1.12)

which is called Bayes’ theorem and which plays a central role in pattern recognition and machine learning. Using the sum rule, the denominator in Bayes’ theorem can be expressed in terms of the quantities appearing in the numerator

p(X) =

Y

p(X|Y )p(Y ). (1.13)

We can view the denominator in Bayes’ theorem as being the normalization constant required to ensure that the sum of the conditional probability on the left-hand side of (1.12) over all values of Y equals one.

In Figure 1.11, we show a simple example involving a joint distribution over two variables to illustrate the concept of marginal and conditional distributions. Here a ﬁnite sample of N = 60 data points has been drawn from the joint distribution and is shown in the top left. In the top right is a histogram of the fractions of data points having each of the two values of Y . From the deﬁnition of probability, these fractions would equal the corresponding probabilities p(Y ) in the limit N → ∞. We can view the histogram as a simple way to model a probability distribution given only a ﬁnite number of points drawn from that distribution. Modelling distributions from data lies at the heart of statistical pattern recognition and will be explored in great detail in this book. The remaining two plots in Figure 1.11 show the corresponding histogram estimates of p(X) and p(X|Y = 1).

Let us now return to our example involving boxes of fruit. For the moment, we shall once again be explicit about distinguishing between the random variables and their instantiations. We have seen that the probabilities of selecting either the red or the blue boxes are given by

p(B = r) = 4/10 (1.14) p(B = b) = 6/10 (1.15)

respectively. Note that these satisfy p(B = r) + p(B = b) = 1.

Now suppose that we pick a box at random, and it turns out to be the blue box. Then the probability of selecting an apple is just the fraction of apples in the blue box which is 3/4, and so p(F = a|B = b) = 3/4. In fact, we can write out all four conditional probabilities for the type of fruit, given the selected box

p(F = a|B = r) = 1/4 (1.16) p(F = o|B = r) = 3/4 (1.17) p(F = a|B = b) = 3/4 (1.18) p(F = o|B = b) = 1/4. (1.19)
