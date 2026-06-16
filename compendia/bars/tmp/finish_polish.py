"""Finish MRA2015 appendices + WLK2008 prose polish."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# --- WLK2008 ---
wlk = ROOT / "WLK2008.md"
text = wlk.read_text(encoding="utf-8")

old_21 = """From we obtain fitted values for selected and these, in turn, may be used to produce a draw $\\phi^{(g)}$ from the posterior distribution of any characteristic $\\phi = \\phi(f)$ (such as the value at which the maximum of $f(t)$ occurs). Thus, the key output of BARS is the

$$
\\det \\text {of vectors} \\, ^ { f ^ { \\prime } } = \\left ( \\sqrt { g } \\left ( t _ { 1 } \\right ) , f ^ { ( g ) } ( t _ { 2 } ) , \\dots , f ^ { ( g ) } ( t _ { p } ) \\right ) \\text {for MC/CM iterates} \\, g = 1 , \\dots , G , \\text { each}
$$

being a vector of fits along a grid that suitably covers the interval $[A, B]$. The user may sample from the posterior distribution of any functional $\\phi$ simply by evaluating

. For instance, a sample from the posterior distribution of the location of the

maximum of $f(t)$ is obtained by finding the location of the maximum of for each $g$. This latter computation is performed in a suitable post-processing environment such as S or R . MCMC convergence may be assessed by standard methods (Gelman, Carlin, Stern, and Rubin 2004, Section 11.6) though this remains a topic of general research interest (Fan, Brooks, and Gelman 2006)."""

new_21 = """From $\\beta_\\xi^{(g)}$ we obtain fitted values $f^{(g)}(\\tilde{t}) = \\sum_h b_{\\xi,h}(\\tilde{t})\\,\\beta_{\\xi,h}^{(g)}$ for selected $\\tilde{t}$, and these, in turn, may be used to produce a draw $\\phi^{(g)}$ from the posterior distribution of any characteristic $\\phi = \\phi(f)$ (such as the value at which the maximum of $f(t)$ occurs). Thus, the key output of BARS is the set of vectors

$$
\\tilde{f}^{(g)} = \\left(f^{(g)}(\\tilde{t}_1), f^{(g)}(\\tilde{t}_2), \\ldots, f^{(g)}(\\tilde{t}_p)\\right)
$$

for MCMC iterates $g = 1, \\ldots, G$, each $\\tilde{f}^{(g)}$ being a vector of fits along a grid $\\tilde{t}_1, \\tilde{t}_2, \\ldots, \\tilde{t}_p$ that suitably covers the interval $[A, B]$. The user may sample from the posterior distribution of any functional $\\phi$ simply by evaluating $\\phi^{(g)} = \\phi(\\tilde{f}^{(g)})$. For instance, a sample from the posterior distribution of the location of the maximum of $f(t)$ is obtained by finding the location of the maximum of $\\tilde{f}^{(g)}$ for each $g$. This latter computation is performed in a suitable post-processing environment such as S or R. MCMC convergence may be assessed by standard methods (Gelman, Carlin, Stern, and Rubin 2004, Section 11.6) though this remains a topic of general research interest (Fan, Brooks, and Gelman 2006)."""

if old_21 not in text:
    raise SystemExit("WLK2008 §2.1 block not found")
text = text.replace(old_21, new_21, 1)

text = text.replace("We next elaboarate on each of these steps.", "We next elaborate on each of these steps.")

text = re.sub(
    r"- c\. In the normal case, is produced by a draw from the relevant multivariate normal distribution of the posterior of β ξ conditionally on ξ = ξ \( g \) , obtained analytically\.",
    r"- c. In the normal case, $\\beta_\\xi^{(g)}$ is produced by a draw from the relevant multivariate normal distribution of the posterior of $\\beta_\\xi$ conditionally on $\\xi = \\xi^{(g)}$, obtained analytically.",
    text,
    count=1,
)
text = text.replace(
    "- d. After is drawn from the conditional posterior, fits may be obtained.",
    "- d. After $\\beta_\\xi^{(g)}$ is drawn from the conditional posterior, fits may be obtained.",
)
text = text.replace("Ater MCMC terminates,", "After MCMC terminates,")

wlk.write_text(text, encoding="utf-8")
print("WLK2008.md updated")

# --- MRA2015 appendices ---
app = ROOT / "references" / "MRA2015.appendices.md"
text = app.read_text(encoding="utf-8")

# A.1 §1 θ + note (replace from #### 1 through end of second $$ block before - 2.)
marker_start = "#### 1. Sampling θ\n\n"
marker_end = "\n\n- 2. Sampling σ 2 b\n"
start = text.index(marker_start) + len(marker_start)
end = text.index(marker_end, start)

a1_theta = r"""$$
\begin{aligned}
p(\theta \mid \sigma_\epsilon^2, \sigma_b^2, y) &\propto p(y \mid \beta, b, \sigma_\epsilon^2)\, p(b \mid \sigma_b^2)\, p(\beta) \\
&\propto \exp\left\{ -\frac{1}{2\sigma_\epsilon^2} \|y - T\theta\|^2 \right\} \exp\left\{ -\frac{1}{2\sigma_b^2} b' b \right\} \exp\left\{ -\frac{1}{2\sigma_\beta^2} \beta' \beta \right\} \\
&= \exp\left\{ -\frac{1}{2\sigma_\epsilon^2} (y' y - 2\theta' T' y + \theta' T' T \theta) - \frac{1}{2}\theta' D^{-1} \theta \right\} \\
&= \exp\left\{ \frac{1}{\sigma_\epsilon^2} \theta' T' y - \frac{1}{2}\theta' \left[ \frac{1}{\sigma_\epsilon^2} T' T + D^{-1} \right] \theta \right\}.
\end{aligned}
$$

Note that $\Sigma_\theta = \left(\frac{1}{\sigma_\epsilon^2} T' T + D^{-1}\right)^{-1} = \sigma_\epsilon^2 (T' T + \sigma_\epsilon^2 D^{-1})^{-1}$. By solving for $\mu_\theta$, i.e., $\Sigma_\theta^{-1} \mu_\theta = \frac{1}{\sigma_\epsilon^2} T' y \Rightarrow \mu_\theta = \frac{1}{\sigma_\epsilon^2} \Sigma_\theta T' y$.
"""

text = text[:start] + a1_theta + text[end:]

# A.1 §3 σ²_ε
marker_start = "- 3. Sampling σ 2 glyph[epsilon1]\n\n"
marker_end = "\n\n### A.2 BAPS Sampling Scheme\n"
start = text.index(marker_start) + len(marker_start)
end = text.index(marker_end, start)

a1_sigma_eps = r"""#### 3. Sampling $\sigma_\epsilon^2$

$$
\begin{aligned}
p(\sigma_\epsilon^2 \mid y, \beta, b) &\propto p(y \mid \beta, b, \sigma_\epsilon^2)\, p(\sigma_\epsilon^2) \\
&\propto (\sigma_\epsilon^2)^{-\frac{n}{2}} \exp\left\{ -\frac{1}{2\sigma_\epsilon^2} \|y - T\theta\|^2 \right\} \times (\sigma_\epsilon^2)^{-(A_\epsilon + 1)} \exp\left\{ -\frac{B_\epsilon}{\sigma_\epsilon^2} \right\} \\
&= (\sigma_\epsilon^2)^{-\left(\frac{n}{2} + A_\epsilon + 1\right)} \exp\left\{ -\frac{1}{\sigma_\epsilon^2} \left[ \frac{1}{2}\|y - T\theta\|^2 + B_\epsilon \right] \right\}.
\end{aligned}
$$
"""

text = text[:start] + a1_sigma_eps + text[end:]

# A.3 §1 Whittle θ
marker_start = "#### 1. Sampling θ\n\n"
# second occurrence (A.3)
idx = text.index("### A.3 Whittle Sampling Scheme")
start = text.index(marker_start, idx) + len(marker_start)
marker_end = "\n\nwhere c m is the m th row of C .\n\nPartial derivatives:"
end = text.index(marker_end, start)

a3_theta = r"""$$
\begin{aligned}
p(\theta \mid I, C) &\propto p(I \mid \theta)\, p(\theta) \\
&\propto \prod_{m=1}^{M} \exp\left\{ c_m' \theta - I_m(\omega)\, \exp(c_m' \theta) \right\} \times \exp\left\{ -\frac{1}{2}\theta' \Lambda \theta \right\},
\end{aligned}
$$
"""

text = text[:start] + a3_theta + text[end:]

# A.3 partial derivatives
marker_start = "Partial derivatives:\n\n"
start = text.index(marker_start, idx) + len(marker_start)
marker_end = "\n\nwhere ∗ is the entrywise product"
end = text.index(marker_end, start)

a3_partials = r"""$$
\begin{aligned}
\log p(\theta \mid I, C) &= \sum_{m=1}^{M} \left[ c_m' \theta - I_m(\omega)\, \exp(c_m' \theta) \right] - \frac{1}{2}\theta' \Lambda \theta \\
\frac{\partial \log p(\theta \mid I, C)}{\partial \theta} &= \sum_{m=1}^{M} \left[ c_m - I_m(\omega)\, \exp(c_m' \theta)\, c_m \right] - \Lambda \theta \\
\frac{\partial^2 \log p(\theta \mid I, C)}{\partial \theta \partial \theta'} &= -\sum_{m=1}^{M} \left[ I_m(\omega)\, \exp(c_m' \theta)\, c_m c_m' \right] - \Lambda.
\end{aligned}
$$

Vectorized partial derivatives:

$$
\begin{aligned}
\log p(\theta \mid I, C) &= \mathbf{1}'(C\theta) - \mathbf{1}'\bigl(\exp(C\theta) \odot I\bigr) - \frac{1}{2}\theta' \Lambda \theta \\
\frac{\partial \log p(\theta \mid I, C)}{\partial \theta} &= C'(\mathbf{1} - I \odot \exp(C\theta)) - \Lambda \theta \\
\frac{\partial^2 \log p(\theta \mid I, C)}{\partial \theta \partial \theta'} &= -C' \operatorname{diag}\bigl(I_m(\omega)\, \exp(C\theta)\bigr)\, C - \Lambda,
\end{aligned}
$$

"""

text = text[:start] + a3_partials + text[end:]
text = text.replace(
    "where ∗ is the entrywise product of two matrices of the same dimension.",
    "where $\\odot$ is the entrywise product of two vectors of the same dimension.",
)

# A.3.2 b_gamma partial derivatives (corrupted block)
old_bgamma = """Partial derivatives:

$$
P a r t i a l \\ d e r i v a t i v e s \\colon \\\\ \\log p ( b _ { \\gamma } | \\gamma , b , \\eta , \\delta ) \\ = \\ \\frac { 1 } { 2 } \\sum _ { j = 1 } ^ { K _ { \\kappa } } z _ { \\gamma _ { j } } ^ { \\prime } b _ { \\gamma } - \\frac { 1 } { 2 } \\delta \\sum _ { j = 1 } ^ { K _ { \\kappa } } b _ { j } ^ { 2 } \\exp \\{ z _ { \\gamma _ { j } } ^ { \\prime } b _ { \\gamma } \\} - \\frac { 1 } { 2 } \\eta b _ { \\gamma } ^ { \\prime } b _ { \\gamma } \\\\ \\frac { \\partial \\log p ( b _ { \\gamma } | \\gamma , b , \\eta , \\delta ) } { \\partial b _ { \\gamma } } \\ = \\ \\frac { 1 } { 2 } Z _ { \\gamma _ { 1 } } ^ { \\prime } 1 - \\frac { 1 } { 2 } \\delta \\sum _ { j = 1 } ^ { K _ { \\kappa } } b _ { j } ^ { 2 } \\exp \\{ z _ { \\gamma _ { j } } ^ { \\prime } b _ { \\gamma } \\} z _ { \\gamma _ { j } } - \\eta b _ { \\gamma } \\\\ \\frac { \\partial ^ { 2 } \\log p ( b _ { \\gamma } | \\gamma , b , \\eta , \\delta ) } { \\partial b _ { \\gamma } \\partial b _ { \\gamma } ^ { \\prime } } \\ = \\ - \\frac { 1 } { 2 } \\delta \\sum _ { j = 1 } ^ { K _ { \\kappa } } b _ { j } ^ { 2 } \\exp \\{ z _ { \\gamma _ { j } } ^ { \\prime } b _ { \\gamma } \\} z _ { \\gamma _ { j } } z _ { \\gamma _ { j } } ^ { \\prime } - \\eta I _ { K _ { \\imath } + q } \\\\ \\text {where } z _ { \\gamma _ { j } } \\text { is the } \\text {th row of } Z _ { \\gamma _ { j } } \\text { .} \\text {Propose a new value } b _ { \\kappa } ^ { * } \\text { from } N ( \\hat { b } _ { \\gamma , \\hat { \\Sigma } _ { h } } ) \\text { , where}
$$

where z γ j is the j th row of Z γ . Propose a new value b ∗ γ from N ( ˆ b γ , ˆ Σ b γ ) , where ˆ b γ = arg max b γ log p ( b γ | γ , b ,η,δ ) and"""

new_bgamma = """Partial derivatives:

$$
\\begin{aligned}
\\log p(b_\\gamma \\mid \\gamma, b, \\eta, \\delta) &= \\frac{1}{2}\\sum_{j=1}^{K_\\kappa} z_{\\gamma_j}' b_\\gamma - \\frac{1}{2}\\delta\\sum_{j=1}^{K_\\kappa} b_j^2 \\exp\\{z_{\\gamma_j}' b_\\gamma\\} - \\frac{1}{2}\\eta b_\\gamma' b_\\gamma \\\\
\\frac{\\partial \\log p(b_\\gamma \\mid \\gamma, b, \\eta, \\delta)}{\\partial b_\\gamma} &= \\frac{1}{2} Z_\\gamma' \\mathbf{1} - \\frac{1}{2}\\delta\\sum_{j=1}^{K_\\kappa} b_j^2 \\exp\\{z_{\\gamma_j}' b_\\gamma\\} z_{\\gamma_j} - \\eta b_\\gamma \\\\
\\frac{\\partial^2 \\log p(b_\\gamma \\mid \\gamma, b, \\eta, \\delta)}{\\partial b_\\gamma \\partial b_\\gamma'} &= -\\frac{1}{2}\\delta\\sum_{j=1}^{K_\\kappa} b_j^2 \\exp\\{z_{\\gamma_j}' b_\\gamma\\} z_{\\gamma_j} z_{\\gamma_j}' - \\eta I_{K_\\ell+q},
\\end{aligned}
$$

where $z_{\\gamma_j}$ is the $j$th row of $Z_\\gamma$. Propose a new value $b_\\gamma^*$ from $N(\\hat{b}_\\gamma, \\hat{\\Sigma}_{b_\\gamma})$, where $\\hat{b}_\\gamma = \\arg\\max_{b_\\gamma} \\log p(b_\\gamma \\mid \\gamma, b, \\eta, \\delta)$ and"""

if old_bgamma not in text:
    raise SystemExit("A.3.2 b_gamma partials block not found")
text = text.replace(old_bgamma, new_bgamma, 1)

# Fence B.1
b1_start = "### B.1 Bayesian Penalized Splines Code\n\n"
b1_end = "\n\n### B.2 BAPS Code\n"
s = text.index(b1_start) + len(b1_start)
e = text.index(b1_end, s)
b1_code = text[s:e].strip()
if not b1_code.startswith("```"):
    text = text[:s] + "```r\n" + b1_code + "\n```\n" + text[e:]

# Fence B.2
b2_start = "### B.2 BAPS Code\n\n"
b2_end = "\n\n### B.3 BAPS Code (Whittle estimate)\n"
s = text.index(b2_start) + len(b2_start)
e = text.index(b2_end, s)
b2_code = text[s:e].strip()
if not b2_code.startswith("```"):
    text = text[:s] + "```r\n" + b2_code + "\n```\n" + text[e:]

app.write_text(text, encoding="utf-8")
print("MRA2015.appendices.md updated")
