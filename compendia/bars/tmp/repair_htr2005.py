#!/usr/bin/env python3
"""Deep content repair for compendia/bars/HTR2005.md."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "HTR2005.md"


def main() -> None:
    text = TARGET.read_text(encoding="utf-8")

    # --- §1 Introduction: complete truncated ML paragraph ---
    old_ml = (
        "An additional penalty term has to be added to the likelihood in\n\n"
        "Advantages of Bayesian regression."
    )
    new_ml = (
        "An additional penalty term has to be added to the likelihood in order to determine "
        "the correct number of segments. The most principled penalty is the Bayesian Information "
        "Criterion [Sch78, KW95]. Since it can be biased towards too simple [Wea99] or too complex "
        "[Pic05] models, in practice often a heuristic penalty is used. An interesting heuristic, "
        "based on the curvature of the log-likelihood as a function of the number of segments, has "
        "been used in [Pic05]. Our Bayesian regressor is a natural response to penalized ML. Many "
        "other regressors exist; too numerous to list them all. Another closely related work to ours "
        "is Bayesian bin density estimation by Endres and Földiák [EF05], who also average over all "
        "boundary locations, but in the context of density estimation.\n\n"
        "Advantages of Bayesian regression."
    )
    text = text.replace(old_ml, new_ml)

    # --- §1 Advantages: integrate footnote 1, remove marker ---
    old_adv = (
        "Finally, Bayes often works well in practice, and provably so if the model assumptions are valid.^1 We can also extract"
    )
    new_adv = (
        "Finally, Bayes often works well in practice, and provably so if the model assumptions are valid. "
        "Note that we are not claiming here that BPCR works better than the other mentioned approaches. "
        "In a certain sense Bayes is optimal if the prior is 'true'. Practical superiority likely depends "
        "on the type of application. A comparison for micro-array data is in progress [KH06]. The major "
        "aim of this paper is to derive an efficient algorithm, and demonstrate the gains of BPCR beyond "
        "bare PC-regression, e.g. the (predictive) regression curve (which is better than local smoothing "
        "which wiggles more and blurs jumps). We can also extract"
    )
    text = text.replace(old_adv, new_adv)

    # --- §2 Setup: integrate footnotes 2–3, remove standalone lines ---
    old_setup = (
        'where each $y_i \\in \\mathbb{R}$ resulted from a noisy "measurement", i.e. we assume that the $y_i$ are independently (e.g. Gaussian) distributed with means $\\mu\'_i$ and variances ${\\sigma\'}^2_i$.^2 The data likelihood is therefore^3\n\n'
        "$$\n"
        "\\text{likelihood}: \\quad P(y \\mid \\mu', \\sigma') := \\prod_{i=1}^{n} P(y_i \\mid \\mu'_i, \\sigma'_i) \\tag{1}\n"
        "$$\n\n"
        "^1 Note that we are not claiming here that BPCR works better than the other mentioned approaches. In a certain sense Bayes is optimal if the prior is 'true'. Practical superiority likely depends on the type of application. A comparison for micro-array data is in progress [KH06]. The major aim of this paper is to derive an efficient algorithm, and demonstrate the gains of BPCR beyond bare PC-regression, e.g. the (predictive) regression curve (which is better than local smoothing which wiggles more and blurs jumps).\n\n"
        "^2 More generally, $\\mu'_i$ and $\\sigma'_i$ are location and scale parameters of a symmetric distribution.\n\n"
        "^3 For notational and verbal simplicity we will not distinguish between probabilities of discrete variables and densities of continuous variables.\n\n"
    )
    new_setup = (
        'where each $y_i \\in \\mathbb{R}$ resulted from a noisy "measurement" '
        "(more generally, $\\mu'_i$ and $\\sigma'_i$ are location and scale parameters of a symmetric distribution), "
        "i.e. we assume that the $y_i$ are independently (e.g. Gaussian) distributed with means $\\mu'_i$ and variances "
        "${\\sigma'}^2_i$. For notational and verbal simplicity we will not distinguish between probabilities of discrete "
        "variables and densities of continuous variables. The data likelihood is therefore\n\n"
        "$$\n"
        "\\text{likelihood}: \\quad P(y \\mid \\mu', \\sigma') := \\prod_{i=1}^{n} P(y_i \\mid \\mu'_i, \\sigma'_i) \\tag{1}\n"
        "$$\n\n"
    )
    text = text.replace(old_setup, new_setup)

    # --- §2 piecewise constant set notation ---
    text = text.replace(
        "i.e. f is constant on { t q − 1 +1 ,..,t q } for each 0 <q ≤ k . If the noise within each segment is the same, we have",
        "i.e. $f$ is constant on $\\{t_{q-1}+1, \\ldots, t_q\\}$ for each $0 < q \\leq k$. If the noise within each segment is the same, we have",
    )
    text = text.replace(
        "We first consider the case in which the variances of all segments coincide, i.e. σ q = σ ∀ q . Our goal is to estimate the segment levels $\\mu=(\\mu_1,\\ldots,\\mu_k)$, boundaries $t=(t_0,\\ldots,t_k)$, and their number k . Bayesian regression proceeds in assuming a prior for these quantities of interest . We model the segment levels by a broad (e.g. Gaussian) distribution with mean ν and variance $\\rho^2$ .",
        "We first consider the case in which the variances of all segments coincide, i.e. $\\sigma_q = \\sigma$ for all $q$. Our goal is to estimate the segment levels $\\mu=(\\mu_1,\\ldots,\\mu_k)$, boundaries $t=(t_0,\\ldots,t_k)$, and their number $k$. Bayesian regression proceeds in assuming a prior for these quantities of interest. We model the segment levels by a broad (e.g. Gaussian) distribution with mean $\\nu$ and variance $\\rho^2$.",
    )
    text = text.replace(
        "We regard the global variance $\\rho^2$ and mean ν of µ and the in-segment variance $\\sigma^2$ as fixed hyper-parameters, and notationally suppress them in the following.",
        "We regard the global variance $\\rho^2$ and mean $\\nu$ of $\\mu$ and the in-segment variance $\\sigma^2$ as fixed hyper-parameters, and notationally suppress them in the following.",
    )
    text = text.replace(
        "MAP over continuous parameters ( µ ) is problematic, since it is not reparametrization invariant. This is particularly dangerous if MAP is across different dimensions ( k ), since then even a linear transformation ( µ ❀ α µ ) scales the posterior (density) exponentially in k (by α k ). This severely influences the maximum over k , i.e. the estimated number of segments. The mean of µ does not have this problem. On the other hand, the mean of t makes only sense for fixed (e.g. MAP) k . The most natural solution is to proceed in stages similar to as the prior (3) has been formed.",
        "MAP over continuous parameters ($\\mu$) is problematic, since it is not reparametrization invariant. This is particularly dangerous if MAP is across different dimensions ($k$), since then even a linear transformation ($\\mu \\mapsto \\alpha\\mu$) scales the posterior (density) exponentially in $k$ (by $\\alpha^k$). This severely influences the maximum over $k$, i.e. the estimated number of segments. The mean of $\\mu$ does not have this problem. On the other hand, the mean of $t$ makes sense only for fixed (e.g. MAP) $k$. The most natural solution is to proceed in stages similar to how the prior (3) has been formed.",
    )

    # --- §3 boundaries prose ---
    text = text.replace(
        "Second, for each boundary t q its posterior and MAP, given the MAP estimate of k",
        "Second, for each boundary $t_q$ its posterior and MAP, given the MAP estimate of $k$",
    )
    text = text.replace(
        "Different estimates of t q (e.g. the mean or MAP based on the joint t posterior) will be discussed later.",
        "Different estimates of $t_q$ (e.g. the mean or MAP based on the joint $t$ posterior) will be discussed later.",
    )

    # --- §4 segment boundaries stray text ---
    text = text.replace(
        "Since there are ( n − 1 k − 1 ) ways of placing the k − 1 inner boundaries (ordered and without repetition) on (1 ,...,n − 1), we have n − 1\n\n\n$$",
        "Since there are $\\binom{n-1}{k-1}$ ways of placing the $k-1$ inner boundaries (ordered and without repetition) on $(1, \\ldots, n-1)$, we have\n\n\n$$",
    )
    text = text.replace(
        "We now discuss some (purely exemplary) choices for the data noise and priors on µ and k .",
        "We now discuss some (purely exemplary) choices for the data noise and priors on $\\mu$ and $k$.",
    )
    text = text.replace(
        "The corresponding standard \"conjugate\" prior on the means µ q for each segment q is also Gauss",
        "The corresponding standard \"conjugate\" prior on the means $\\mu_q$ for each segment $q$ is also Gaussian",
    )

    # --- §5 L/R recursion prose and debris ---
    text = text.replace(
        "That is (apart from binomial factors) the evidence of y 0 j with k +1 segments equals the evidence of y 0 h with k segments times the single-segment evidence of y hj , summed over all locations h of boundary k . The recursion starts with L 1 j = A 0 0 j , or more conveniently with L 0 j = δ j 0 . We also need a right recursion for r =0, j = n , p − l =1, m − p = k : n − k n − k\n\n\n$$",
        "That is (apart from binomial factors) the evidence of $y_{0j}$ with $k+1$ segments equals the evidence of $y_{0h}$ with $k$ segments times the single-segment evidence of $y_{hj}$, summed over all locations $h$ of boundary $k$. The recursion starts with $L_{1j} = A_{0j}^0$, or more conveniently with $L_{0j} = \\delta_{j0}$. We also need a right recursion for $r=0$, $j=n$, $p-l=1$, $m-p=k$:\n\n\n$$",
    )
    text = text.replace(
        "The recursion starts with R 1 n = A 0 in , or more conveniently with R 0 i = δ in .",
        "The recursion starts with $R_{1n} = A_{in}^0$, or more conveniently with $R_{0i} = \\delta_{in}$.",
    )

    # --- §5 segment boundary estimate ---
    text = text.replace(
        "$$\n\\hat{t} _{p} \\, \\colon = \\, \\arg\\max_{h} P(t _{p} = h \\mid y , \\hat{k})\\, = \\, \\arg\\max_{h} \\{B _{p h} \\} \\, = \\, \\arg\\max_{h} \\{L _{p h} R _{\\hat{k} - p , h} \\}\n$$",
        "$$\n\\hat{t}_p := \\arg\\max_{h} P(t_p = h \\mid y, \\hat{k}) = \\arg\\max_{h} \\{B_{ph}\\} = \\arg\\max_{h} \\{L_{ph} R_{\\hat{k}-p,h}\\} \\tag{21}\n$$",
    )

    # --- §5 regression curve paragraph ---
    old_reg = (
        "Regression curve. Recursion (15) allows in principle to compute the regression curve E [ $\\mu'$ t | y ] by deﬁning ( L r =1 t ) kj and ( R r =1 t ) ki analogous to L kj and R ki , but this procedure needs O ( n 3 ) space and O ( k max n 3 ) time, one O ( n ) worse than our target performance. We reduce probabilities of $\\mu'$ t to probabilities of µ m : We exploit the fact that in every segmentation, $\\mu'$ t lies in some segment. Let this (unique) segment be m with (unique) boundaries i = t m − 1 <t ≤ t m = j . Then $\\mu'$ t = µ m . Summing now over all such segments we get"
    )
    new_reg = (
        "Regression curve. Recursion (5) allows in principle to compute the regression curve $\\mathbb{E}[\\mu'_t \\mid y]$ by defining $(L_t^{r=1})_{kj}$ and $(R_t^{r=1})_{ki}$ analogous to $L_{kj}$ and $R_{ki}$, but this procedure needs $O(n^3)$ space and $O(k_{\\max} n^3)$ time, one $O(n)$ worse than our target performance. We reduce probabilities of $\\mu'_t$ to probabilities of $\\mu_m$: We exploit the fact that in every segmentation, $\\mu'_t$ lies in some segment. Let this (unique) segment be $m$ with (unique) boundaries $i = t_{m-1} < t \\leq t_m = j$. Then $\\mu'_t = \\mu_m$. Summing now over all such segments we get"
    )
    text = text.replace(old_reg, new_reg)

    text = text.replace(
        "By fixing t p in (13) we arrived at (19). Similarly, dividing the data into three parts and fixing t l and t m we can derive",
        "By fixing $t_p$ in (12) we arrived at (19). Similarly, dividing the data into three parts and fixing $t_l$ and $t_m$ we can derive",
    )
    text = text.replace(
        "Setting l = m − 1, integrating over µ 0 l and µ mk , dividing by ( n − 1 k − 1 ) P ( y | k ), and inserting into (23), we get",
        "Setting $l = m-1$, integrating over $\\mu_{0l}$ and $\\mu_{mk}$, dividing by $\\binom{n-1}{k-1} P(y \\mid k)$, and inserting into (23), we get",
    )

    # Fix duplicate equation tag: F formula becomes (25) in regression section — renumber Gaussian block
    text = text.replace(
        "F_{ij}^r : = \\frac{1}{L_{\\hat{k}n}} \\sum_{m = 1}^{\\hat{k}} L_{m - 1,i}\\, A_{ij}^r\\, R_{\\hat{k} - m,j} \\tag{24}",
        "F_{ij}^r := \\frac{1}{L_{\\hat{k}n}} \\sum_{m = 1}^{\\hat{k}} L_{m - 1,i}\\, A_{ij}^r\\, R_{\\hat{k} - m,j} \\tag{25}",
    )
    text = text.replace(
        "While segment boundaries and values make sense only for fixed k (we chose $\\hat{k}$), the regression curve $\\hat{\\mu}$ ′ t could actually be averaged over all k instead of fixing k = $\\hat{k}$ .",
        "While segment boundaries and values make sense only for fixed $k$ (we chose $\\hat{k}$), the regression curve $\\hat{\\mu}'_t$ could actually be averaged over all $k$ instead of fixing $k = \\hat{k}$.",
    )

    # Renumber Gaussian equations 25->26, 26->27, 27->28
    text = text.replace(
        "P(y_{ij} \\mid t_{m - 1,m}) = A_{ij}^0 = \\frac{\\exp\\!\\left\\{\\frac{1}{2\\sigma^2}\\left[\\frac{(\\sum_t (y_t - \\nu))^2}{d + \\sigma^2/\\rho^2} - \\sum_t (y_t - \\nu)^2\\right]\\right\\}}{(2\\pi\\sigma^2)^{d/2}(1 + d\\rho^2/\\sigma^2)^{1/2}} \\tag{25}",
        "P(y_{ij} \\mid t_{m - 1,m}) = A_{ij}^0 = \\frac{\\exp\\!\\left\\{\\frac{1}{2\\sigma^2}\\left[\\frac{(\\sum_t (y_t - \\nu))^2}{d + \\sigma^2/\\rho^2} - \\sum_t (y_t - \\nu)^2\\right]\\right\\}}{(2\\pi\\sigma^2)^{d/2}(1 + d\\rho^2/\\sigma^2)^{1/2}} \\tag{26}",
    )
    text = text.replace(
        "A_{ij}^1 & = A_{ij}^0 \\cdot \\frac{\\rho^2(\\sum_t y_t) + \\sigma^2\\nu}{d\\rho^2 + \\sigma^2} \\tag{26}",
        "A_{ij}^1 & = A_{ij}^0 \\cdot \\frac{\\rho^2(\\sum_t y_t) + \\sigma^2\\nu}{d\\rho^2 + \\sigma^2} \\tag{27}",
    )
    text = text.replace(
        "\\mathrm{Var}[\\mu_m \\mid y_{ij}, t_{m - 1,m}] & = \\frac{A_{ij}^2}{A_{ij}^0} - \\left(\\frac{A_{ij}^1}{A_{ij}^0}\\right)^2 = \\left[\\frac{d}{\\sigma^2} + \\frac{1}{\\rho^2}\\right]^{- 1} \\approx \\frac{\\sigma^2}{d} \\tag{27}",
        "\\mathrm{Var}[\\mu_m \\mid y_{ij}, t_{m - 1,m}] & = \\frac{A_{ij}^2}{A_{ij}^0} - \\left(\\frac{A_{ij}^1}{A_{ij}^0}\\right)^2 = \\left[\\frac{d}{\\sigma^2} + \\frac{1}{\\rho^2}\\right]^{- 1} \\approx \\frac{\\sigma^2}{d} \\tag{28}",
    )

    # Update cross-refs in §6-7 for renumbered equations
    text = text.replace("(26) and (27)", "(27) and (28)")
    text = text.replace("Expressions (28)", "Expressions (29)")
    text = text.replace("in-segment variance (29)", "in-segment variance (30)")
    text = text.replace("better estimates than (29)", "better estimates than (30)")
    text = text.replace("one may use (29) as an initial", "one may use (30) as an initial")
    text = text.replace("see e.g. (25)", "see e.g. (26)")
    text = text.replace("in (25), (26), (27)", "in (26), (27), (28)")
    text = text.replace("Expressions (28) are the standard", "Expressions (29) are the standard")

    # Fix hyper-parameter estimate tags
    text = text.replace(
        "\\hat{\\nu} \\approx \\frac{1}{n} \\sum_{t = 1}^{n} y_{t} \\quad \\text{and} \\quad \\hat{\\rho}^{2} \\approx \\frac{1}{n - 1} \\sum_{t = 1}^{n} (y_{t} - \\hat{\\nu})^{2}\n$$",
        "\\hat{\\nu} \\approx \\frac{1}{n} \\sum_{t = 1}^{n} y_{t} \\quad \\text{and} \\quad \\hat{\\rho}^{2} \\approx \\frac{1}{n - 1} \\sum_{t = 1}^{n} (y_{t} - \\hat{\\nu})^{2} \\tag{29}\n$$",
    )
    text = text.replace(
        "\\hat{\\sigma}^{2} \\approx \\frac{1} {2 ( n - 1)} \\sum _{t = 1}^{n - 1} ( y _{t + 1} - y _{t})^{2}\n$$",
        "\\hat{\\sigma}^{2} \\approx \\frac{1}{2(n-1)} \\sum_{t=1}^{n-1} (y_{t+1} - y_t)^2 \\tag{30}\n$$",
    )

    # --- §7 OCR and unicode fixes ---
    text = text.replace("greed hill-climbing", "greedy hill-climbing")
    text = text.replace("eﬃciency", "efficiency")
    text = text.replace("deﬁning", "defining")
    text = text.replace("diﬀerence", "difference")
    text = text.replace("iﬀ", "iff")
    text = text.replace("inﬁnite", "infinite")

    text = text.replace(
        "Hyper-Bayes and Hyper-ML. The developed regression model still contains three (hyper)parameters, the global variance $\\rho^2$ and mean $\\nu$ of $\\mu$, and the in-segment variance $\\sigma^2$. If they are not known, a proper Bayesian treatment would be to assume a hyper-prior over them and integrate them out. Since we do not expect a significant influence of the hyper-prior (as long as chosen reasonable) on the quantities of interest, one could more easy proceed in an empirical Bayesian way and choose the parameters such that the evidence $P(y \\mid \\sigma, \\nu, \\rho)$ is maximized (\"hyper-ML\"). (We restored the till now omitted dependency on the hyper-parameters).\n\nExhaustive (grid) search for the hyper-ML parameters is expensive. For data which is indeed noisy piecewise constant, $P(y \\mid \\sigma, \\nu, \\rho)$ is typically unimodal 4 in $(\\sigma, \\nu, \\rho)$ and the global maximum can be found more efficiently by greedy hill-climbing, but even this may cost a factor of 10 to 1000 in efficiency. Below we present a very simple and excellent heuristic for choosing $(\\sigma, \\nu, \\rho)$.",
        "Hyper-Bayes and Hyper-ML. The developed regression model still contains three (hyper)parameters, the global variance $\\rho^2$ and mean $\\nu$ of $\\mu$, and the in-segment variance $\\sigma^2$. If they are not known, a proper Bayesian treatment would be to assume a hyper-prior over them and integrate them out. Since we do not expect a significant influence of the hyper-prior (as long as chosen reasonable) on the quantities of interest, one could more easily proceed in an empirical Bayesian way and choose the parameters such that the evidence $P(y \\mid \\sigma, \\nu, \\rho)$ is maximized (\"hyper-ML\"). (We restored the till now omitted dependency on the hyper-parameters).\n\nExhaustive (grid) search for the hyper-ML parameters is expensive. For data which is indeed noisy piecewise constant, $P(y \\mid \\sigma, \\nu, \\rho)$ is typically unimodal in $(\\sigma, \\nu, \\rho)$ and the global maximum can be found more efficiently by greedy hill-climbing, but even this may cost a factor of 10 to 1000 in efficiency. Below we present a very simple and excellent heuristic for choosing $(\\sigma, \\nu, \\rho)$.",
    )

    old_footnote4 = (
        "4 A little care is necessary with the in-segment variance $\\sigma^2$. If we set it (extremely close) to zero, all segments will consist of a single data point $y_i$ with (close to) infinite evidence (see e.g. (26)). Assuming $k_{\\max} < n$ eliminates this unwished maximum. Greedy hill-climbing with proper initialization will also not be fooled.\n\nThis overestimates"
    )
    new_footnote4 = (
        "This overestimates"
    )
    text = text.replace(old_footnote4, new_footnote4)

    # Insert footnote 4 content as parenthetical after unimodal sentence - already handled by removing standalone

    text = text.replace(
        "Estimate of in-segment variance $\\sigma^2$ . At first there seems little hope of estimating the in-segment variance $\\sigma^2$ from y without knowing the segmentation",
        "Estimate of in-segment variance $\\sigma^2$. At first there seems little hope of estimating the in-segment variance $\\sigma^2$ from $y$ without knowing the segmentation",
    )

    # Clean expectation equations in §7
    text = text.replace(
        "$$\nE \\left[ \\frac{1} {n} \\sum _{t = 1}^{n} ( y _{t} - \\mu _{1})^{2} \\right] = \\sigma^{2} = \\frac{1} {2 ( n - 1)} E \\left[ \\sum _{t = 1}^{n - 1} ( y _{t + 1} - y _{t})^{2} \\right]\n$$",
        "$$\n\\mathbb{E}\\left[\\frac{1}{n}\\sum_{t=1}^{n}(y_t - \\mu_1)^2\\right] = \\sigma^2 = \\frac{1}{2(n-1)}\\mathbb{E}\\left[\\sum_{t=1}^{n-1}(y_{t+1} - y_t)^2\\right]\n$$",
    )
    text = text.replace(
        "i.e. instead of estimating $\\sigma^2$ by the squared deviation of the y t from their mean, we can also estimate $\\sigma^2$ from the average squared difference of successive y t .",
        "i.e. instead of estimating $\\sigma^2$ by the squared deviation of the $y_t$ from their mean, we can also estimate $\\sigma^2$ from the average squared difference of successive $y_t$.",
    )
    text = text.replace(
        "$$\nE \\sum _{t = t _{m - 1} + 1}^{t _{m} - 1} ( y _{t + 1} - y _{t})^{2} = 2 ( t _{m} - t _{m - 1} - 1)\\sigma^{2} \\quad \\text{and} \\quad E ( y _{t _{m} + 1} - y _{t _{m}})^{2} = 2 \\sigma^{2} + ( \\mu _{m + 1} - \\mu _{m})^{2}\n$$",
        "$$\n\\mathbb{E}\\sum_{t=t_{m-1}+1}^{t_m-1}(y_{t+1} - y_t)^2 = 2(t_m - t_{m-1} - 1)\\sigma^2 \\quad \\text{and} \\quad \\mathbb{E}(y_{t_m+1} - y_{t_m})^2 = 2\\sigma^2 + (\\mu_{m+1} - \\mu_m)^2\n$$",
    )
    text = text.replace(
        "The last expression holds, since there are k boundaries in n data items, and the ratio between the variance of µ to the in-segment variance is $\\rho^2$ /$\\sigma^2$ .",
        "The last expression holds, since there are $k$ boundaries in $n$ data items, and the ratio between the variance of $\\mu$ to the in-segment variance is $\\rho^2/\\sigma^2$.",
    )
    text = text.replace(
        "If there are not too many segments ( k ≪ n ) and the regression problem is hard (high noise ρ < ∼ σ ), this is a very good estimate. In case of low noise ( ρ ≫ σ ), regression is very easy, and a crude estimate of $\\sigma^2$ is sufficient. If there are many segments, $\\hat{\\sigma}$ 2 tends to overestimate $\\sigma^2$",
        "If there are not too many segments ($k \\ll n$) and the regression problem is hard (high noise $\\rho \\lesssim \\sigma$), this is a very good estimate. In case of low noise ($\\rho \\gg \\sigma$), regression is very easy, and a crude estimate of $\\sigma^2$ is sufficient. If there are many segments, $\\hat{\\sigma}^2$ tends to overestimate $\\sigma^2$",
    )
    text = text.replace(
        "which then can be used to compute an improved estimate of $\\hat{\\sigma}$ 2 , and possibly iterate.",
        "which then can be used to compute an improved estimate of $\\hat{\\sigma}^2$, and possibly iterate.",
    )

    # Hyper-ML block formatting
    text = text.replace(
        "If mean and variance do not exist or the distribution is quite heavy-tailed, we need other estimates. The \"ideal\" hyper-ML estimates may be approximated as follows. If we assume that each data point lies in its own segment, we get\n\n\n$$\n(\\hat{\\nu}, \\hat{\\rho})\\approx \\arg\\max_{(\\nu,\\rho)} \\prod_{t = 1}^{n} P(y_t \\mid \\hat{\\sigma}, \\nu, \\rho)\\quad \\text{with} \\\\\nP(y_t \\mid \\sigma, \\nu, \\rho) = \\int P(y_t \\mid \\mu, \\sigma)\\, P(\\mu \\mid \\nu, \\rho)\\, d\\mu \\tag{30}\n$$\n\nThe in-segment variance $\\hat{\\sigma}$ 2 can be estimated similarly to the last paragraph considering data differences and ignoring segment boundaries:\n$$\n\\hat{\\sigma} \\approx \\arg\\max_{\\sigma} \\prod_{t = 1}^{n - 1} P(y_{t + 1} - y_t \\mid \\sigma)\\quad \\text{with} \\\\\nP(y_{t + 1} - y_t = \\Delta \\mid \\sigma)\\approx \\int_{- \\infty}^{\\infty} P(y_{t + 1} = a + \\Delta \\mid \\mu,\\sigma)\\, P(y_t = a \\mid \\mu,\\sigma)\\, da \\tag{31}\n$$\nNote that the last expression is independent of the segment level (this was the whole reason for considering data differences) and exact iff y t and y t +1 belong to the same segment. In general (beyond the exponential family) ($\\hat{\\nu}$, $\\hat{\\rho}$, $\\hat{\\sigma}$ ) can only be determined numerically.\nUsing median and quartile.",
        "If mean and variance do not exist or the distribution is quite heavy-tailed, we need other estimates. The \"ideal\" hyper-ML estimates may be approximated as follows. If we assume that each data point lies in its own segment, we get\n\n\n$$\n(\\hat{\\nu}, \\hat{\\rho}) \\approx \\arg\\max_{(\\nu,\\rho)} \\prod_{t=1}^{n} P(y_t \\mid \\hat{\\sigma}, \\nu, \\rho) \\quad \\text{with}\n$$\n\n$$\nP(y_t \\mid \\sigma, \\nu, \\rho) = \\int P(y_t \\mid \\mu, \\sigma)\\, P(\\mu \\mid \\nu, \\rho)\\, d\\mu \\tag{31}\n$$\n\nThe in-segment variance $\\hat{\\sigma}^2$ can be estimated similarly to the last paragraph considering data differences and ignoring segment boundaries:\n\n$$\n\\hat{\\sigma} \\approx \\arg\\max_{\\sigma} \\prod_{t=1}^{n-1} P(y_{t+1} - y_t \\mid \\sigma) \\quad \\text{with}\n$$\n\n$$\nP(y_{t+1} - y_t = \\Delta \\mid \\sigma) \\approx \\int_{-\\infty}^{\\infty} P(y_{t+1} = a + \\Delta \\mid \\mu, \\sigma)\\, P(y_t = a \\mid \\mu, \\sigma)\\, da \\tag{32}\n$$\n\nNote that the last expression is independent of the segment level (this was the whole reason for considering data differences) and exact iff $y_t$ and $y_{t+1}$ belong to the same segment. In general (beyond the exponential family) $(\\hat{\\nu}, \\hat{\\rho}, \\hat{\\sigma})$ can only be determined numerically.\n\nUsing median and quartile.",
    )

    # Quartile section
    text = text.replace(
        "Using median and quartile. We present some simpler estimates based on median and quartiles. Let [ y ] be the data vector y , but sorted in ascending order. Then, item [ y ] αn (where the index is assumed to be rounded up to the next integer) is the α -quantile of empirical distribution y . In particular [ y ] n/ 2 is the median of y . It is a consistent (and robust to outliers) estimator of the mean segment level\n$$\n\\hat{\\nu} \\approx [ y ] _{n / 2}\n$$\nif noise and segment levels have symmetric distributions. Further, half of the data points lie in the interval [ a,b ], where a :=[ y ] n/ 4 is the first and b :=[ y ] 3 n/ 4 is the last quartile of y . So, using (30), $\\hat{\\rho}$ should be estimated such that\n$$\nP(a \\leq y _{t} \\leq b \\mid \\sigma , \\hat{\\nu} , \\hat{\\rho})\\ \\stackrel {!} {\\approx} \\frac{1} {2}\n$$\nIgnoring data noise (assuming σ ≈ 0), we get\n$$\n\\hat{\\rho} \\approx \\frac{[ y ] _{3 n / 4} - [ y ] _{n / 4}} {2 \\alpha} \\quad \\text{with} \\alpha = 1 \\text{for Cauchy and} \\alpha \\doteq 0 . 6 7 4 4 \\text{for Gauss,}\n$$\nwhere α is the quartile of the standard Cauchy/Gauss/other segment prior. For the data noise σ we again consider the differences ∆ t := y t +1 − y t . Using (31), $\\hat{\\sigma}$ should be estimated such that !\n$$\nP(a' \\leq y_{t + 1} - y_t \\leq b' \\mid \\hat{\\sigma})\\stackrel{!}{\\approx} \\frac{1}{2}\n$$\nwhere a ′ =[ ∆ ] n/ 4 and b ′ =[ ∆ ] 3 n/ 4 ≈− a ′ . One can show that",
        "Using median and quartile. We present some simpler estimates based on median and quartiles. Let $[y]$ be the data vector $y$, but sorted in ascending order. Then, item $[y]_{\\alpha n}$ (where the index is assumed to be rounded up to the next integer) is the $\\alpha$-quantile of empirical distribution $y$. In particular $[y]_{n/2}$ is the median of $y$. It is a consistent (and robust to outliers) estimator of the mean segment level\n\n$$\n\\hat{\\nu} \\approx [y]_{n/2} \\tag{33}\n$$\n\nif noise and segment levels have symmetric distributions. Further, half of the data points lie in the interval $[a,b]$, where $a := [y]_{n/4}$ is the first and $b := [y]_{3n/4}$ is the last quartile of $y$. So, using (31), $\\hat{\\rho}$ should be estimated such that\n\n$$\nP(a \\leq y_t \\leq b \\mid \\sigma, \\hat{\\nu}, \\hat{\\rho}) \\stackrel{!}{\\approx} \\frac{1}{2}\n$$\n\nIgnoring data noise (assuming $\\sigma \\approx 0$), we get\n\n$$\n\\hat{\\rho} \\approx \\frac{[y]_{3n/4} - [y]_{n/4}}{2\\alpha} \\quad \\text{with } \\alpha = 1 \\text{ for Cauchy and } \\alpha \\doteq 0.6744 \\text{ for Gauss} \\tag{34}\n$$\n\nwhere $\\alpha$ is the quartile of the standard Cauchy/Gauss/other segment prior. For the data noise $\\sigma$ we again consider the differences $\\Delta_t := y_{t+1} - y_t$. Using (32), $\\hat{\\sigma}$ should be estimated such that\n\n$$\nP(a' \\leq y_{t+1} - y_t \\leq b' \\mid \\hat{\\sigma}) \\stackrel{!}{\\approx} \\frac{1}{2}\n$$\n\nwhere $a' = [\\Delta]_{n/4}$ and $b' = [\\Delta]_{3n/4} \\approx -a'$. One can show that",
    )
    text = text.replace(
        "where β is the quartile of the one time with itself convolved standard Cauchy/Gauss/other (noise) distribution. Use of quartiles for estimating σ is robust to the \"outliers\" caused by the segment boundaries, so yields better estimates than (30) if noise is low. Again, if the estimates are really not sufficient, one may iteratively improve them.\n## 8 The Algorithm",
        "where $\\beta$ is the quartile of the one-time-with-itself convolved standard Cauchy/Gauss/other (noise) distribution. Use of quartiles for estimating $\\sigma$ is robust to the \"outliers\" caused by the segment boundaries, so yields better estimates than (30) if noise is low. Again, if the estimates are really not sufficient, one may iteratively improve them.\n\n## 8 The Algorithm\n",
    )

    # --- §8 Algorithm paragraph ---
    old_alg = (
        "## 8 The Algorithm\n"
        "The computation of A , L , R , E , C , B , $\\hat{t}$ p , µ r m , F , and $\\mu'$ t r by the formulas/recursions derived in Section 5, are straightforward. In (16) one should compute the product, or in (25), (26), (27) the sum, incrementally from j ❀ j +1. Similarly $\\mu'$ t r should be computed incrementally by t − 1 n\n"
        "$$\n"
        "\\widehat{\\mu_{t + 1}^{'r}} = \\widehat{\\mu_t^{'r}} - \\sum_{i = 0}^{t - 1} F_{it}^r + \\sum_{j = t + 1}^{n} F_{tj}^r\n"
        "$$\n"
        "Typically r =0 , 1 , 2. In this way, all quantities can be computed in time $O(k_{\\max} n^2)$ and space $O(n^2)$. Space can be reduced to $O(k_{\\max} n)$ by computing A on-the-fly in the various expressions at the cost of a slowdown by a constant factor. Table 1 contains the algorithm in pseudo-C code. The complete code including examples and data is available at [Hut05a]. Since A 0 , L , R , and E can be exponentially large in n , i.e. huge or tiny, actually their logarithm has to be computed and stored. In the expressions, the logarithm is pulled in by log( x · y )=log( x )+log( y ) and log( x + y )= log( x )+log(1+exp(log( y ) − log( x )) for x>y and similarly for x<y . Instead of A r ij we have to compute A r ij /A 0 ij by pulling the denominator into the integral.\n"
        "## 9 Synthetic Examples"
    )
    new_alg = (
        "## 8 The Algorithm\n\n"
        "The computation of $A$, $L$, $R$, $E$, $C$, $B$, $\\hat{t}_p$, $\\widehat{\\mu_m^r}$, $F$, and $\\widehat{\\mu_t^{'r}}$ by the formulas/recursions derived in Section 5 are straightforward. In (16) one should compute the product, or in (26), (27), (28) the sum, incrementally from $j \\leadsto j+1$. Similarly $\\widehat{\\mu_t^{'r}}$ should be computed incrementally by\n\n"
        "$$\n"
        "\\widehat{\\mu_{t+1}^{'r}} = \\widehat{\\mu_t^{'r}} - \\sum_{i=0}^{t-1} F_{it}^r + \\sum_{j=t+1}^{n} F_{tj}^r\n"
        "$$\n\n"
        "Typically $r=0,1,2$. In this way, all quantities can be computed in time $O(k_{\\max} n^2)$ and space $O(n^2)$. Space can be reduced to $O(k_{\\max} n)$ by computing $A$ on-the-fly in the various expressions at the cost of a slowdown by a constant factor. Table 1 contains the algorithm in pseudo-C code. The complete code including examples and data is available at [Hut05a]. Since $A^0$, $L$, $R$, and $E$ can be exponentially large in $n$, i.e. huge or tiny, actually their logarithm has to be computed and stored. In the expressions, the logarithm is pulled in by $\\log(x \\cdot y)=\\log(x)+\\log(y)$ and $\\log(x+y)=\\log(x)+\\log(1+\\exp(\\log(y)-\\log(x)))$ for $x>y$ and similarly for $x<y$. Instead of $A_{ij}^r$ we have to compute $A_{ij}^r/A_{ij}^0$ by pulling the denominator into the integral.\n\n"
        "## 9 Synthetic Examples"
    )
    text = text.replace(old_alg, new_alg)

    # --- Missing figure image refs ---
    text = text.replace(
        "\n\nFigure 5: [GH: high Gaussian noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).\n\n\nFigure 6:",
        "\n\n![Figure 5: [GH: high Gaussian noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).](<HTR2005/imageFile5.png>)\n\nFigure 5: [GH: high Gaussian noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).\n\n![Figure 6: [GH: high Gaussian noise] data with Bayesian regression $\\pm 1$ std. deviation.](<HTR2005/imageFile6.png>)\n\nFigure 6:",
    )
    text = text.replace(
        "\n\nFigure 9: [CH: high Cauchy noise] data.\n\n![Figure 10:",
        "\n\n![Figure 9: [CH: high Cauchy noise] data.](<HTR2005/imageFile9.png>)\n\nFigure 9: [CH: high Cauchy noise] data.\n\n![Figure 10:",
    )

    # --- §10 Miscellaneous fixes ---
    text = text.replace(
        "While using the variance of ∆ as estimate for $\\hat{\\sigma}$ tends to overestimate σ for low noise",
        "While using the variance of $\\Delta$ as estimate for $\\hat{\\sigma}$ tends to overestimate $\\sigma$ for low noise",
    )
    text = text.replace(
        "Consider, for instance, the three segment medium Gaussian noise data y GM from Figure 2. Table 2 shows that $\\log E(\\mathrm{GM})$ = − 48, while $\\log E(\\mathrm{GMwC})$= − 70, i.e. the odds that y GM has Cauchy rather than Gaussian noise is tiny $e^{48-70}<10^{-9}$ , and similarly the odds that y CM has Gaussian rather than Cauchy noise is $e^{127-160}<10^{-14}$",
        "Consider, for instance, the three segment medium Gaussian noise data $y_{\\mathrm{GM}}$ from Figure 2. Table 2 shows that $\\log E(\\mathrm{GM}) = -48$, while $\\log E(\\mathrm{GMwC}) = -70$, i.e. the odds that $y_{\\mathrm{GM}}$ has Cauchy rather than Gaussian noise is tiny $e^{48-70}<10^{-9}$, and similarly the odds that $y_{\\mathrm{CM}}$ has Gaussian rather than Cauchy noise is $e^{127-160}<10^{-14}$",
    )
    text = text.replace(
        "log-evidences would be − 398 and − 406",
        "log-evidences would be $-398$ and $-406$",
    )
    text = text.replace(
        "rather than the marginals t p separately",
        "rather than the marginals $t_p$ separately",
    )
    text = text.replace(
        "In the last column we indicated the confidence C $\\hat{k}$ ( C $\\hat{k}$ − 1 ,C $\\hat{k}$ +1 ) of BPCR in the estimate $\\hat{k}$ . For clean data (GL,GM,CL,GM) it is certain",
        "In the last column we indicated the confidence $C_{\\hat{k}}$ ($C_{\\hat{k}-1}$, $C_{\\hat{k}+1}$) of BPCR in the estimate $\\hat{k}$. For clean data (GL, GM, CL, CM) it is certain",
    )

    # --- §11 Extensions ---
    text = text.replace(
        "The core Regression( A ,n,k max ) algorithm does not care where the in-segment evidence matrix and moments A come from.",
        "The core `Regression(A,n,k_max)` algorithm does not care where the in-segment evidence matrix and moments $A$ come from.",
    )
    text = text.replace(
        "this simply corresponds to a discrete prior on µ and leads naturally to a Grid sum (rather than by need) as in EstGeneral().",
        "this simply corresponds to a discrete prior on $\\mu$ and leads naturally to a grid sum (rather than by need) as in `EstGeneral()`.",
    )
    text = text.replace(
        "If each segment can have its own (unknown) variance $\\sigma^2$ m , we can assume some prior over σ m and average (16) (which depends on σ m , notationally suppressed) additionally over σ m . Possibly P ( σ m | ... ) depends on some hyper-parameter that now has to be estimated instead of σ ; all the better if not.",
        "If each segment can have its own (unknown) variance $\\sigma_m^2$, we can assume some prior over $\\sigma_m$ and average (16) (which depends on $\\sigma_m$, notationally suppressed) additionally over $\\sigma_m$. Possibly $P(\\sigma_m \\mid \\ldots)$ depends on some hyper-parameter that now has to be estimated instead of $\\sigma$; all the better if not.",
    )
    text = text.replace(
        "We simply choose likelihood and prior for a single segment and compute its evidence A 0 ij . This is all what Regression() needs",
        "We simply choose likelihood and prior for a single segment and compute its evidence $A_{ij}^0$. This is all `Regression()` needs",
    )
    text = text.replace(
        "Piecewise linear (or other) continuous regression is more complicated. Assume that µ p in (12) does not denote the level of the whole segment p , but its level at the right boundary, which together with µ p − 1 determines the linear function in segment p . Only after fixing µ p , left and right side decouple. So the recursion analogous to (15) now involves a quantity Q which in addition to ( i,j ) also depends on ( µ l ,µ m ). This functional recursion may approximately be solved by discretizing { ( µ l ,µ m ) ∈ IR 2 } , or by approximating Q by a 2-dimensional Gaussian in ( µ l ,µ m ) and storing only the 2 means and the 2 × 2 covariance matrix for each ( i,j ). The following two simpler heuristic approaches may work sufficiently well in practice: One could ignore the continuity constraint when determining the boundaries, and only take them into account in the subsequent (much simpler) regression problem with known boundaries. Another possibility is to consider instead of the continuous piecewise linear function f its piecewise constant derivative f ′ , i.e. use BPCR on ∆ t and finally integrate the result.",
        "Piecewise linear (or other) continuous regression is more complicated. Assume that $\\mu_p$ in (12) does not denote the level of the whole segment $p$, but its level at the right boundary, which together with $\\mu_{p-1}$ determines the linear function in segment $p$. Only after fixing $\\mu_p$, left and right side decouple. So the recursion analogous to (5) now involves a quantity $Q$ which in addition to $(i,j)$ also depends on $(\\mu_l, \\mu_m)$. This functional recursion may approximately be solved by discretizing $\\{(\\mu_l, \\mu_m) \\in \\mathbb{R}^2\\}$, or by approximating $Q$ by a 2-dimensional Gaussian in $(\\mu_l, \\mu_m)$ and storing only the 2 means and the $2 \\times 2$ covariance matrix for each $(i,j)$. The following two simpler heuristic approaches may work sufficiently well in practice: One could ignore the continuity constraint when determining the boundaries, and only take them into account in the subsequent (much simpler) regression problem with known boundaries. Another possibility is to consider instead of the continuous piecewise linear function $f$ its piecewise constant derivative $f'$, i.e. use BPCR on $\\Delta_t$ and finally integrate the result.",
    )
    text = text.replace(
        "If all segments have the same distribution, we could non-parametrically estimate a single density for the differences ∆ and then deconvolve the density (e.g. by FFT − 1 ( FFT(density)), and henceforth use this as prior for σ in EstGeneral()).",
        "If all segments have the same distribution, we could non-parametrically estimate a single density for the differences $\\Delta$ and then deconvolve the density (e.g. by $\\mathrm{FFT}^{-1}(\\sqrt{\\mathrm{FFT}(\\mathrm{density})})$), and henceforth use this as prior for $\\sigma$ in `EstGeneral()`.",
    )
    text = text.replace(
        "boundary t k is often practically independent of where t k ± 2 , t k ± 3 , etc. are placed. This suggests to break the whole data set into smaller overlapping pieces, where each piece should be long enough to contain at least four segments. Then boundaries t piece 2 ,...,t piece k − 2 of each piece are used",
        "boundary $t_k$ is often practically independent of where $t_{k\\pm 2}$, $t_{k\\pm 3}$, etc. are placed. This suggests breaking the whole data set into smaller overlapping pieces, where each piece should be long enough to contain at least four segments. Then boundaries $t_2^{\\mathrm{piece}}, \\ldots, t_{k-2}^{\\mathrm{piece}}$ of each piece are used",
    )

    # Add care note about sigma=0 after hyper-ML paragraph
    sigma_note = (
        "Below we present a very simple and excellent heuristic for choosing $(\\sigma, \\nu, \\rho)$.\n\n"
        "Estimate of global mean and variance"
    )
    sigma_note_replacement = (
        "Below we present a very simple and excellent heuristic for choosing $(\\sigma, \\nu, \\rho)$. "
        "A little care is necessary with the in-segment variance $\\sigma^2$: if we set it (extremely close) to zero, "
        "all segments will consist of a single data point $y_i$ with (close to) infinite evidence (see e.g. (26)). "
        "Assuming $k_{\\max} < n$ eliminates this unwished maximum. Greedy hill-climbing with proper initialization "
        "will also not be fooled.\n\n"
        "Estimate of global mean and variance"
    )
    text = text.replace(sigma_note, sigma_note_replacement)

    # Fix segment boundaries ref (13)->(12) in boundary section
    text = text.replace(
        "Then (13) and (14) reduce to the l.h.s. and r.h.s. of",
        "Then (12) and (14) reduce to the l.h.s. and r.h.s. of",
    )

    # Normalize ligature deﬁning globally
    text = text.replace("deﬁn", "defin")

    TARGET.write_text(text, encoding="utf-8")
    print(f"Wrote {TARGET} ({len(text.splitlines())} lines)")


if __name__ == "__main__":
    main()
