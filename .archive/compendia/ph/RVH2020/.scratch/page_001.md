[Page 1]

# Phase Transitions in Nonlinear Filtering ∗

Patrick Rebeschini † Ramon van Handel ‡

## Abstract

It has been established under very general conditions that the ergodic properties of Markov processes are inherited by their conditional distributions given partial information. While the existing theory provides a rather complete picture of classical filtering models, many infinite-dimensional problems are outside its scope. Far from being a technical issue, the infinite-dimensional setting gives rise to surprising phenomena and new questions in filtering theory. The aim of this paper is to discuss some elementary examples, conjectures, and general theory that arise in this setting, and to highlight connections with problems in statistical mechanics and ergodic theory. In particular, we exhibit a simple example of a uniformly ergodic model in which ergodicity of the filter undergoes a phase transition, and we develop some qualitative understanding as to when such phenomena can and cannot occur. We also discuss closely related problems in the setting of conditional Markov random fields.

Keywords: filtering in infinite dimension; conditional ergodicity & mixing; phase transitions. AMS MSC 2010: 37A50; 60G35; 60K35; 82B26; 82B44.

## 1 Introduction

Let \( (X_k, Y_k)_{k \ge 0} \) be a bivariate Markov chain. Such a model represents the setting of partial information: it is presumed that only \( (Y_k)_{k \ge 0} \) can be observed, while \( (X_k)_{k \ge 0} \) defines the unobserved dynamics. In order to understand the behavior of the unobserved process given the observations, it is natural to ‘lift’ the unobserved dynamics to the level of conditional distributions, that is, to investigate the nonlinear filter

\[
\pi_k := P[X_k \in \cdot \mid Y_1, \dots, Y_k].
\]

Under standard assumptions on the observation structure (cf. section 2), the process \( (\pi_k)_{k \ge 0} \) is itself a measure-valued Markov chain. The fundamental question that arises in this setting is to understand in what manner the probabilistic structure of the model \( (X_k, Y_k)_{k \ge 0} \) ‘lifts’ to the conditional distributions \( (\pi_k)_{k \ge 0} \).

Of particular interest in this context is the behavior of ergodic properties under conditioning. It is natural to suppose that the ergodic properties of \( (X_k, Y_k)_{k \ge 0} \) will be inherited by the filter \( (\pi_k)_{k \ge 0} \): for example, if \( X_k \) forgets its initial condition as \( k \to \infty \), then the optimal mean-square estimate of \( X_k \) (and therefore the filter \( \pi_k \)) should intuitively possess the same property. Such a conclusion was already conjectured by Blackwell as early as

∗ Supported in part by NSF grant CAREER-DMS-1148711 and by the ARO through a PECASE award.

† Yale University, 17 Hillhouse Avenue, New Haven, CT 06520. E-mail: patrick.rebeschini@yale.edu

‡ Sherrerd Hall, Princeton University, Princeton, NJ 08544. E-mail: rvan@princeton.edu
