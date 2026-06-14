[Page 1]

# Spatiotemporal Persistence Landscapes

Martina Flammer ∗ , † , Knut Hüper ∗

{martina.flammer,knut.hueper}@uni-wuerzburg.de

December 17, 2024

# Abstract

A method to apply and visualize persistent homology of time series is proposed. The method captures persistent features in space and time, in contrast to the existing procedures, where one usually chooses one while keeping the other fixed. An extended zigzag module that is built from a time series is defined. This module combines ideas from zigzag persistent homology and multiparameter persistent homology. Persistence landscapes are defined for the case of extended zigzag modules using a recent generalization of the rank invariant (Kim, Mémoli, 2021). This new invariant is called spatiotemporal persistence landscapes . Under certain finiteness assumptions, spatiotemporal persistence landscapes are a family of functions that take values in Lebesgue spaces, endowing the space of persistence landscapes with a distance. Stability of this invariant is shown with respect to an adapted interleaving distance for extended zigzag modules. Being an invariant that takes values in a Banach space, spatiotemporal persistence landscapes can be used for statistical analysis as well as for input to machine learning algorithms.

Keywords: zigzag persistent homology, persistence landscapes, interleaving distance, spatiotemporal filtration, time series analysis

# 1 Introduction

Topological Data Analysis (TDA) is a branch of applied mathematics that arose in the early 2000s. The aim of TDA is to utilize topological methods to obtain information from high-dimensional and noisy datasets. So far, it has been successfully applied to a broad variety of real world data, for example biological/biomedical applications [1,13,19,25,30], financial data [14,15], dynamical systems [16,23,26,39] and robotics [2,31], to name just a few.

One of the most important methods in TDA is persistent homology, which is based on the algebraic topological concept of homology. The initial idea behind homology was to characterize shapes by their holes. Mathematically, holes are described by a sequence of homology groups that contain the information about the p -dimensional holes. The generators of zeroth homology group correspond to the connected components of the topological space, the first homology group describes loops and tunnels, the second voids, and the higher homology groups describe higher dimensional holes. Given point cloud data, persistent homology tracks the homology of that data across several spatial scales and in

∗ Institute of Mathematics, Julius-Maximilians-Universität Würzburg, Germany †

Center for Signal Analysis of Complex Systems, Ansbach University of Applied Sciences, Germany
