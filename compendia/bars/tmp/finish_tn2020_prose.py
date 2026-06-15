#!/usr/bin/env python3
"""Holistic prose repair for TN2020.md."""

from __future__ import annotations

import re
from pathlib import Path

DOC = Path(__file__).resolve().parents[1] / "TN2020.md"


def main() -> None:
    text = DOC.read_text(encoding="utf-8")

    # Remove page markers
    text = re.sub(r"\n\[Page \d+\]\n", "\n", text)

    # Ligatures and hyphenation
    text = text.replace("ﬁelds", "fields")
    text = text.replace("ﬁeld", "field")
    text = text.replace("ﬂux", "flux")
    text = text.replace("conﬁguration", "configuration")
    text = text.replace("speciﬁcation", "specification")
    text = text.replace("unior", "uni- or bi-")
    text = text.replace("uniand", "uni- and")
    text = text.replace("singleand", "single- and")
    text = text.replace("intraand", "intra- and")
    text = text.replace("interor", "inter- or")
    text = text.replace("intermodel", "inter-model")
    text = text.replace("Backand", "Back- and")
    text = text.replace("highperformance", "high-performance")
    text = text.replace("overparameterized", "over-parameterized")

    # Stray OCR fragments
    text = re.sub(r"account\. 13\n", "account.\n", text)
    text = re.sub(r"known\. 13\n", "known.\n", text)
    text = re.sub(r"from 13 C ", "from $^{13}$C ", text)
    text = re.sub(r"\bC MFA\b", r"$^{13}$C MFA", text)

    # Abstract
    text = text.replace(
        "proceed uni- or bi-directionally, using $^{13}$C labeling",
        "proceed uni- or bidirectionally, using $^{13}$C labeling",
    )

    # §1 ensemble citations
    old = (
        "Sampling approaches tie hand-crafted model classes to available data to make joint "
        "inferences with the ensuing model ensembles. These ensemble methods"
    )
    new = (
        "Sampling approaches tie hand-crafted model classes to available data to make joint "
        "inferences with the ensuing model ensembles (Kuepfer et al., 2007; Liu et al., 2015; "
        "Miskovic and Hatzimanikatis, 2011; Tran et al., 2008). These ensemble methods"
    )
    text = text.replace(old, new)

    # §2.1
    text = text.replace(
        "using a computational model M i of cell metabolism",
        r"using a computational model $\mathcal{M}_i$ of cell metabolism",
    )
    text = text.replace(
        "given that the model M i and the inferred fluxes h are correct",
        r"given that the model $\mathcal{M}_i$ and the inferred fluxes $h$ are correct",
    )
    text = text.replace(
        "with respect to a particular model M i , which is chosen",
        r"with respect to a particular model $\mathcal{M}_i$, which is chosen",
    )
    text = text.replace(
        "Precisely, a C MFA model M i is composed",
        r"Precisely, a $^{13}$C MFA model $\mathcal{M}_i$ is composed",
    )

    # §2.2 opening
    text = text.replace(
        "An underlying assumption of Eq. (1) is that the chosen model M i is equipped",
        r"An underlying assumption of Eq. (1) is that the chosen model $\mathcal{M}_i$ is equipped",
    )
    text = text.replace(
        "instead of one single model M i , we consider the model, M , to be a random variable",
        r"instead of one single model $\mathcal{M}_i$, we consider the model, $\mathcal{M}$, to be a random variable",
    )
    text = text.replace(
        "Each model M i is associated with a set of flux parameters h i .",
        r"Each model $\mathcal{M}_i$ is associated with a set of flux parameters $h_i$.",
    )
    text = text.replace(
        "is denoted $p(D k \\mid g)$ , where D k is a binary random variable",
        r"is denoted $p(\Delta_k \mid g)$, where $\Delta_k$ is a binary random variable",
    )
    text = text.replace(
        "For a single model M i ; D k jM i is 0 or 1 depending on whether the k th reaction is uni- or bi-directional, respectively ( D k is fully determined by outcomes of M ). The posterior probability $p(D k \\mid g)$ relates to in how many of the models in the family $\\{\\mathcal{M}_i\\}_i$",
        r"For a single model $\mathcal{M}_i$, $\Delta_{k \mid \mathcal{M}_i}$ is 0 or 1 depending on whether the $k$th reaction is uni- or bidirectional, respectively ($\Delta_k$ is fully determined by outcomes of $\mathcal{M}$). The posterior probability $p(\Delta_k \mid g)$ relates to in how many of the models in the family $\{\mathcal{M}_i\}_i$",
    )
    text = text.replace(
        "To calculate $p(D k \\mid g)$ , we first introduce how $p(D k \\mid g)$ is expressed",
        r"To calculate $p(\Delta_k \mid g)$, we first introduce how $p(\Delta_k \mid g)$ is expressed",
    )
    text = text.replace(
        "relates to the single models M i with their associated fluxes h i .",
        r"relates to the single models $\mathcal{M}_i$ with their associated fluxes $h_i$.",
    )
    text = text.replace(
        "the probability of the k th reaction to be bidirectional, $p(D k \\mid g)$ , is averaged over its bidirectionality probabilities determined for all single models M i in the model family, D k jM i ,",
        r"the probability of the $k$th reaction to be bidirectional, $p(\Delta_k \mid g)$, is averaged over its bidirectionality probabilities determined for all single models $\mathcal{M}_i$ in the model family, $\Delta_{k \mid \mathcal{M}_i}$,",
    )

    # Eq (5) lead-in
    text = text.replace(
        "Inserting Eq. (3) into Eq. (2) (and recognizing that the normalizing constants are identical), yields the expression for the\n\n$$",
        "Inserting Eq. (3) into Eq. (2) (and recognizing that the normalizing constants are identical), yields the expression for the probability of the $k$th reaction to be bidirectional for the model family $\\{\\mathcal{M}_i\\}_i$:\n\n$$",
    )

    text = text.replace(
        "For the combined posterior probability distribution $p(h i ; M i \\mid g)$ Bayes' theorem gives:",
        r"For the combined posterior probability distribution $p(\nu, \chi_i, \mathcal{M}_i \mid g)$ Bayes' theorem gives:",
    )

    text = text.replace(
        "evaluation of $p(D k \\mid g)$ in Eq. (5)",
        r"evaluation of $p(\Delta_k \mid g)$ in Eq. (5)",
    )
    text = text.replace(
        "To approximate the posterior $p(D k \\mid g)$ we use MCMC",
        r"To approximate the posterior $p(\Delta_k \mid g)$ we use MCMC",
    )

    # §2.2.1
    text = text.replace(
        "for the average fluxes (average with respect to the prior $p(h_i \\mid \\mathcal{M}_i)$), rather than for the optimal flux values).",
        r"for the average fluxes (average with respect to the prior $p(h_i \mid \mathcal{M}_i)$, rather than for the optimal flux values).",
    )

    # §3 MCMC / MH block
    old_mh = (
        "Then, to approximate the posterior probability of the reaction bidirectionality, $p(\\Delta_k \\mid g)$, samples from the target distribution $p(h_i, \\mathcal{M}_i \\mid g)$ are generated by MCMC. According to the law of large numbers, the average over these samples converges to the desired expected value in the limit of large sample size. In MCMC, samples are generated by constructing a Markov Chain, which induces a series of evolving states h t ; i , with stationary distribution equal to the desired target distribution. To create a Markov Chain with target distribution $p(h i ; M i \\mid g)$ , the Metropolis-Hastings (MH) algorithm is used ( Brooks et al. , 2011 ). The MH algorithm is defined by a Markov\n\nFor single-model target distributions"
    )
    new_mh = (
        "Then, to approximate the posterior probability of the reaction bidirectionality, $p(\\Delta_k \\mid g)$, samples from the target distribution $p(\\nu, \\chi_i, \\mathcal{M}_i \\mid g)$ are generated by MCMC. According to the law of large numbers, the average over these samples converges to the desired expected value in the limit of large sample size. In MCMC, samples are generated by constructing a Markov Chain, which induces a series of evolving states $(\\nu^t, \\chi_i^t)$, with stationary distribution equal to the desired target distribution. To create a Markov Chain with target distribution $p(\\nu, \\chi_i, \\mathcal{M}_i \\mid g)$, the Metropolis-Hastings (MH) algorithm is used (Brooks et al., 2011). The MH algorithm is defined by a Markov Chain-inducing transition density $g$ and an acceptance/rejection criterion, which corrects the induced Markov Chain to have the desired stationary distribution.\n\n"
        "For single-model target distributions"
    )
    text = text.replace(old_mh, new_mh)

    text = text.replace(
        "represented by fluxes h i , using the binary indicator variable D k .",
        r"represented by fluxes $h_i$, using the binary indicator variable $\Delta_k$.",
    )
    text = text.replace(
        "henceforth, we denote the net and exchange fluxes of model $\\mathcal{M}_i$, $\\nu$ and $\\chi_i$, respectively. Here, as D k , the net fluxes are void of the subscript i because they are present in all models of the family $\\{\\mathcal{M}_i\\}_i$ , while the subscript i for the exchange fluxes i stresses that these are specific to one model M i . Notice that only inference about the shared entities (net fluxes and reaction bidirectionalities D k ) is possible for the whole model family.",
        r"henceforth, we denote the net and exchange fluxes of model $\mathcal{M}_i$, $\nu$ and $\chi_i$, respectively. Here, as $\Delta_k$, the net fluxes are void of the subscript $i$ because they are present in all models of the family $\{\mathcal{M}_i\}_i$, while the subscript $i$ for the exchange fluxes $\chi_i$ stresses that these are specific to one model $\mathcal{M}_i$. Notice that only inference about the shared entities (net fluxes $\nu$ and reaction bidirectionalities $\Delta_k$) is possible for the whole model family.",
    )
    text = text.replace(
        "is sampling from the joint posterior distribution $p(; i ; M i \\mid g)$ in Eq. (4) .",
        r"is sampling from the joint posterior distribution $p(\nu, \chi_i, \mathcal{M}_i \mid g)$ in Eq. (4).",
    )

    # §3.1
    text = text.replace(
        "is the transition density g for sampling from the joint posterior distribution $p(; i ; M i \\mid g)$ . This RJMCMC transition density g consists of two densities: the density g p for model-specific flux exploration updating the flux vectors ; i ( intra-model jumping ), and the density g m for model space exploration updating the exchange fluxmodel pair i ; M i ( inter-model jumping ). Notice that, for both g p and g m , i only contains the exchange fluxes that are part of M i ,",
        r"is the transition density $g$ for sampling from the joint posterior distribution $p(\nu, \chi_i, \mathcal{M}_i \mid g)$. This RJMCMC transition density $g$ consists of two densities: the density $g_p$ for model-specific flux exploration updating the flux vectors $\nu$, $\chi_i$ (intra-model jumping), and the density $g_m$ for model space exploration updating the exchange flux-model pair $\chi_i$, $\mathcal{M}_i$ (inter-model jumping). Notice that, for both $g_p$ and $g_m$, $\chi_i$ only contains the exchange fluxes that are part of $\mathcal{M}_i$,",
    )
    text = text.replace(
        "then an inter- or intra-model sample is drawn from the selected distribution (Algorithm 1, L5, 14).\n\nDepending on whether",
        "then an inter- or intra-model sample is drawn from the selected distribution (Algorithm 1, L5, 14).\n\n"
        "The proposed states (indicated by superscript $\\star$) are then accepted or rejected according to given criteria, following the standard MH scheme. In our case, two rejection criteria are posed, one for inter- and one for intra-model jumping. The rejection criteria depend on the transition densities $g_m$, $g_p$ of the proposed states, the likelihood $p(g \\mid \\nu, \\chi_i, \\mathcal{M}_i)$, as well as the prior $p(\\nu, \\chi_i, \\mathcal{M}_i)$ (Algorithm 1, L6, 15 using the shorthand $z(\\nu, \\chi_i, \\mathcal{M}_i) = p(g \\mid \\nu, \\chi_i, \\mathcal{M}_i) \\cdot p(\\nu, \\chi_i, \\mathcal{M}_i)$). Depending on whether",
    )

    # §3.2.1
    text = text.replace(
        "The transition density g p operates on the net fluxes , that take values in continuous space",
        r"The transition density $g_p$ operates on the net fluxes $\nu$, that take values in continuous space",
    )
    text = text.replace(
        "to update the flux states ; i .",
        r"to update the flux states $\nu$, $\chi_i$.",
    )

    # Algorithm image
    text = re.sub(
        r"!\[The image is a page from a document.*?\]\(TN2020/imageFile2\.png\)",
        "![Algorithm 1: RJMCMC algorithm for $^{13}$C MFA](images/TN2020/imageFile2.png)",
        text,
        flags=re.DOTALL,
    )

    # §3.2.2 inter-model density
    old_gm = (
        "To achieve high acceptance rates, the proposed transition density g m ð ? j ; M ? j j t ; t ; i ; M t ; i Þ nullifies exchange fluxes that are close to zero. This leads to only small changes in the simulated labeling fractions and, therefore, small changes in the value of z ð ; i ; M i Þ , the product of the likelihood and the prior, implicating high acceptance rates. Therefore, the probability to deactivate the k th reaction of state t is set to ð t ; i ; k = max ð t ; i ; k ÞÞ b with b > 0 controlling the deactivation rate (Algorithm 2, L4). Here, a high (low) value for b gives a high (low) deactivation rate. Notice that, after convergence of the sampler, the policy of increasing the deactivation probability for near-zero fluxes has no effect on the produced posterior, since the increased probability is matched by an increase in MH rejections.\n\n"
        "For activating reactions, no heuristic, similar to the one used for reaction deactivation, is possible, since all non-active exchange fluxes are 0. Therefore, the activation probability $c \\in [0,1]$ is introduced and the probability for a reaction unidirectional in M t ; i to become bidirectional in M ? j , is set to c (Algorithm 2, L14). Due to so-called dimensionality matching ( Green, 1995 ), the activated exchange fluxes cannot be initialized with the value 0, but must be given a random value from some continuous distribution. Therefore, an activation distribution p act ð ? j ; k Þ is introduced, from which the values of activated exchange fluxes are sampled (Algorithm 2, L16).\n\n"
        "An important aspect of the MH algorithm is that it requires both the forward probability of the proposed state g m ð ? j ; M ? j j t ; t ; i ; M t ; i Þ and the backward probability of the current state g m ð t ; i ; M t ; i j t ; ? j ; M ? j Þ , when jumping from the current model M t ; i to the proposed model M ? j (Algorithm 1, L6). This means, that the changes in bidirectionality have to be tracked. To this end, four index sets are introduced:\n\n"
        "- 1. L deact : indices of the reactions that switch from bidirectional in M t ; i to unidirectional in M ? j j (Algorithm 2, L6),\n"
        "- 2. L inc : indices of reactions that are bidirectional in both models (Algorithm 2, L8),\n"
        "- 3. L act : indices of reactions that switch from unidirectional in M t ; i to bidirectional in M ? j (Algorithm 2, L16),\n"
        "- 4. L exc : indices of reactions that are unidirectional in both models (Algorithm 2, L18)."
    )
    new_gm = (
        "To achieve high acceptance rates, the proposed transition density $g_m(\\nu^{j\\star}, \\mathcal{M}^{j\\star} \\mid \\nu^t, \\chi_i^t, \\mathcal{M}_i^t)$ nullifies exchange fluxes that are close to zero. This leads to only small changes in the simulated labeling fractions and, therefore, small changes in the value of $z(\\nu, \\chi_i, \\mathcal{M}_i)$, the product of the likelihood and the prior, implicating high acceptance rates. Therefore, the probability to deactivate the $k$th reaction of state $t$ is set to $(\\chi_{i,k}^t / \\max_j \\chi_{i,j}^t)^\\beta$ with $\\beta > 0$ controlling the deactivation rate (Algorithm 2, L4). Here, a high (low) value for $\\beta$ gives a high (low) deactivation rate. Notice that, after convergence of the sampler, the policy of increasing the deactivation probability for near-zero fluxes has no effect on the produced posterior, since the increased probability is matched by an increase in MH rejections.\n\n"
        "For activating reactions, no heuristic, similar to the one used for reaction deactivation, is possible, since all non-active exchange fluxes are 0. Therefore, the activation probability $\\gamma \\in [0,1]$ is introduced and the probability for a reaction unidirectional in $\\mathcal{M}_i^t$ to become bidirectional in $\\mathcal{M}^{j\\star}$, is set to $\\gamma$ (Algorithm 2, L14). Due to so-called dimensionality matching (Green, 1995), the activated exchange fluxes cannot be initialized with the value 0, but must be given a random value from some continuous distribution. Therefore, an activation distribution $p_{\\mathrm{act}}(\\chi_{j,k}^{\\star})$ is introduced, from which the values of activated exchange fluxes are sampled (Algorithm 2, L16).\n\n"
        "An important aspect of the MH algorithm is that it requires both the forward probability of the proposed state $g_m(\\nu^{j\\star}, \\mathcal{M}^{j\\star} \\mid \\nu^t, \\chi_i^t, \\mathcal{M}_i^t)$ and the backward probability of the current state $g_m(\\nu^t, \\chi_i^t, \\mathcal{M}_i^t \\mid \\nu^t, \\chi^{j\\star}, \\mathcal{M}^{j\\star})$, when jumping from the current model $\\mathcal{M}_i^t$ to the proposed model $\\mathcal{M}^{j\\star}$ (Algorithm 1, L6). This means, that the changes in bidirectionality have to be tracked. To this end, four index sets are introduced:\n\n"
        "- 1. $\\mathcal{L}_{\\mathrm{deact}}$: indices of the reactions that switch from bidirectional in $\\mathcal{M}_i^t$ to unidirectional in $\\mathcal{M}^{j\\star}$ (Algorithm 2, L6),\n"
        "- 2. $\\mathcal{L}_{\\mathrm{inc}}$: indices of reactions that are bidirectional in both models (Algorithm 2, L8),\n"
        "- 3. $\\mathcal{L}_{\\mathrm{act}}$: indices of reactions that switch from unidirectional in $\\mathcal{M}_i^t$ to bidirectional in $\\mathcal{M}^{j\\star}$ (Algorithm 2, L16),\n"
        "- 4. $\\mathcal{L}_{\\mathrm{exc}}$: indices of reactions that are unidirectional in both models (Algorithm 2, L18)."
    )
    text = text.replace(old_gm, new_gm)

    # §3.3
    text = text.replace(
        "### 3.3 Implementation details\n\nAlgorithm 2:",
        "### 3.3 Implementation details\n\n"
        "The presented RJMCMC algorithm for reaction direction inference from labeling data was implemented in C++.\n\n"
        "Algorithm 2:",
    )
    text = text.replace(
        "emerging from the flux-model pairs h i ; M i .",
        r"emerging from the flux-model pairs $h_i$, $\mathcal{M}_i$.",
    )
    text = text.replace(
        "For computations, the (de)activation parameters b and c were set to 0.1. As activation distribution pact a normal distribution was used, truncated to ½ 0 ; 1  , with zero mean and standard deviation 0.1.",
        r"For computations, the (de)activation parameters $\beta$ and $\gamma$ were set to 0.1. As activation distribution $p_{\mathrm{act}}$ a normal distribution was used, truncated to $[0,1]$, with zero mean and standard deviation 0.1.",
    )
    text = text.replace(
        "as long as extreme choice are avoided (such as b = 1 or c = 1).",
        r"as long as extreme choices are avoided (such as $\beta = 1$ or $\gamma = 1$).",
    )

    # §4
    text = text.replace("8 6 2", "8 ± 2")
    text = text.replace("854 6 128", "854 ± 128")
    text = text.replace("LCMS/MS", "LC-MS/MS")
    text = text.replace(
        "[U13 C]and unlabeled glucose",
        "[U-$^{13}$C]- and unlabeled glucose",
    )
    text = text.replace(
        "100% [1,213 C]-glucose",
        "100% [1,2-$^{13}$C]-glucose",
    )
    text = text.replace(
        "bidirectional for the [1,213 C]-glucose tracer",
        "bidirectional for the [1,2-$^{13}$C]-glucose tracer",
    )
    text = text.replace(
        "information gain of the expensive [1,213 C]-glucose tracer",
        "information gain of the expensive [1,2-$^{13}$C]-glucose tracer",
    )

    # Fig 1
    text = re.sub(
        r"!\[The image is a bar chart.*?\]\(TN2020/imageFile3\.png\)\n\nFig\. 1\. Metabolic network.*?\n",
        (
            "![Fig. 1: Posterior bidirectionality probabilities for the E. coli network](images/TN2020/imageFile3.png)\n\n"
            "Fig. 1. Metabolic network of the central carbon metabolism of *E. coli* used in this study. "
            "Potentially bidirectional reactions are divided in *de facto* uni- and bidirectional reactions, "
            "indicating their bidirectionality in the reference solution. The bars show the posterior probability "
            "of the reactions being bidirectional, for two CLE scenarios: a 20/80 mix of [U-$^{13}$C]- and "
            "[$^{12}$C]-glucose and 100% [1,2-$^{13}$C]-glucose labeling. Flux names written in bold correspond "
            "to the *de facto* unidirectional reactions of the reference flux map. A probability of 0.5 means that "
            "no information whether a reaction is uni- or bidirectional is contained in the measurements. The "
            "specification of the network model, including atom transitions, constraints and measurements is given "
            "in Supplementary Information S.1\n\n"
        ),
        text,
        flags=re.DOTALL,
    )

    # Acknowledgements before References link - insert before ## 5 or at end
    if "## Acknowledgements" not in text:
        ack = (
            "\n## Acknowledgements\n\n"
            "The authors are thankful to Johnjoe McFadden for insightful discussions about Ockham's Razor "
            "and its relation to BMA, and to Wolfgang Wiechert for excellent working conditions at the IBG-1.\n\n"
            "### Funding\n\n"
            "A.T. was supported by Grant No. ERA-IB-14-81 DYNAMICS.\n\n"
            "*Conflict of Interest*: none declared.\n"
        )
        text = text.replace("\n## 5 Conclusion", ack + "\n## 5 Conclusion")

    DOC.write_text(text, encoding="utf-8")
    print("Wrote", DOC)


if __name__ == "__main__":
    main()
