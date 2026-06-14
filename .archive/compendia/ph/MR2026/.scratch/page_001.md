[Page 1]

# Persistent Entropy as a Detector of Phase Transitions

Matteo Rucco ruccomatteo@gmail.com

08/02/2026

## Abstract

Persistent entropy (PE) is an information-theoretic summary statistic of persistence barcodes that has been widely used in numerical and experimental studies to detect regime changes in complex systems. Despite its empirical success, a general theoretical understanding of when and why persistent entropy reliably detects phase transitions has remained limited, particularly in settings where data and learned representations are inherently stochastic.

In this work, we establish a general, model-independent theorem providing sufficient conditions under which persistent entropy provably separates two phases. We formulate a probabilistic framework in which, for each system size N and control parameter λ , observational data define a random persistence diagram D N ( λ ) in a standard diagram metric space. Assuming (i) convergence in probability of persistence diagrams to deterministic limits on either side of a critical value λ c , and (ii) a macroscopic feature separation condition—namely the presence of at least one persistent bar with lifetime bounded away from zero in one phase and only vanishingly short bars in the other—we show that persistent entropy exhibits an asymptotically non-vanishing gap across phases. The result relies only on continuity of PE along the convergent diagram sequence (or under mild regularization or lifetime truncation), and is therefore broadly applicable across data modalities, filtrations, and homological degrees.

To bridge asymptotic theory and finite-time computations, we introduce a dynamical operationalization based on topological stabilization: a topological transition time defined via the stabilization of a chosen topological statistic on a sliding window, and a probability-based estimator of critical parameters within a finite observation horizon. We validate the framework on three classes of systems: (i) the Kuramoto synchronization transition, (ii) the Vicsek order–disorder transition in collective motion, and (iii) neural network training dynamics across multiple datasets and architectures, where training loss acts as an effective control parameter. Across all experiments, stabilization of persistent entropy and collapse of variability across realizations provide robust numerical signatures of convergence toward low-complexity limiting persistence diagrams, in agreement with the theorem’s mechanism.

## 1 Introduction

Phase transitions are among the most fundamental phenomena in the study of complex systems, marking qualitative reorganizations of collective behavior induced by variations of control parameters. In classical statistical physics, phase transitions are traditionally characterized through the emergence or disappearance of local order parameters within the Landau symmetry-breaking paradigm. However, many contemporary systems of interest—including coupled oscillators, active matter, biological collectives, and data-driven dynamical models—exhibit high-dimensional, noisy, and heterogeneous dynamics for which suitable order parameters may be unknown, difficult to define, or strongly model-dependent. This has motivated the search for alternative, model-agnostic descriptors capable of capturing global structural changes associated with phase transitions.
