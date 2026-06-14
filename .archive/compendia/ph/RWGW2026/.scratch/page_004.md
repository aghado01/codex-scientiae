[Page 4]

![In this image there is a diagram, there are some text boxes, there are some pictures, there is some text, there is a watermark.](<RWGW2026/imageFile1.png>)

Multiscale Sheaf Laplacian embedding

Auxiliary Features

Protein Structure

Surface area

Partial charge


Solvation free energy

Secondary structure

Wild

Harmonic and nonharmonic spectra

Machine

Learning

Mutant

Protein Sequence

Sequence~based embedding

Seq1: LEAGALQ.

AEGPSDIPD

ESM-2 transformer

Seq2: LEAGASQ.

AEGPSDIPD

Figure 1: Illustration of the Persistent Sheaf Laplacian (PSL) neural network (SheafLapNet) workflow. The framework predicts mutation-induced stability and solubility changes by integrating multi-scale protein representations. For each input protein structure, the feature generation pipeline extracts three distinct components: (1) sequence-based embeddings derived from pretrained protein Transformer models, (2) topological features computed via the PSL framework, and (3) auxiliary physicochemical features. These three sets of features are concatenated to form the input of the neural network for the prediction task.

## 2 Results

## 2.1 Overview of SheafLapNet

Figure 1 outlines the workflow of SheafLapNet. As a standard machine learning model, SheafLapNet extracts features from protein structure and uses a neural network to predict mutation-induced stability and solubility changes upon mutation. The workflow begins with 3D protein structures from datasets, with corresponding mutant structures generated using the Jackal software [56]. The feature generation process consists of three components: sequence features from pretrained protein Transformer, topological features from persistent Sheaf Laplacians, and auxiliary physicochemical features. For topological features, atom subsets around the mutational site are extracted from both wild-type and mutant proteins to form element-specific subcomplexes. These subcomplexes are utilized to compute the harmonic and nonharmonic spectra of sheaf Laplacians under a structural filtration, creating a Sheaf Laplacian embedding that characterizes atom-atom interactions across multiple scales. For sequence features, the FASTA sequences of the wild-type and mutant proteins are extracted from the complex and input into the pretrained Transformer models. The derived latent space embeddings are used as the sequence features. For physicochemical features, we consider the atom-level properties such as partial charge, elec-
