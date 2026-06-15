#!/usr/bin/env python3
"""Second-pass fixes for HTR2005.md."""

from __future__ import annotations

import re
from pathlib import Path

TARGET = Path(__file__).resolve().parents[1] / "HTR2005.md"


def main() -> None:
    text = TARGET.read_text(encoding="utf-8")

    text = re.sub(
        r"\n\^1 Note that we are not claiming.*?\n\n\^2 More generally.*?\n\n\^3 For notational.*?\n\n",
        "\n\n",
        text,
        flags=re.DOTALL,
    )

    repls = [
        (
            "We assume or model f as piecewise constant. Consider k segments with segment boundaries $0=t_0<t_1<\\cdots<t_{k-1}<t_k=n$ , i.e.",
            "We assume or model $f$ as piecewise constant. Consider $k$ segments with segment boundaries $0=t_0<t_1<\\cdots<t_{k-1}<t_k=n$, i.e.",
        ),
        (
            "The corresponding standard “conjugate” prior on the means µ q for each segment q is also Gauss",
            "The corresponding standard “conjugate” prior on the means $\\mu_q$ for each segment $q$ is also Gaussian",
        ),
        (
            "Or even simpler, use the estimated global mean and variance (28), and in-segment variance (30)",
            "Or even simpler, use the estimated global mean and variance (29), and in-segment variance (30)",
        ),
        (
            "If y would belong to a single segment, i.e. the y t were i.i.d. with variance",
            "If $y$ would belong to a single segment, i.e. the $y_t$ were i.i.d. with variance",
        ),
        (
            "Summing over all k segments and boundaries",
            "Summing over all $k$ segments and boundaries",
        ),
        (
            "as long as ν and ρ parameterize mean and variance.",
            "as long as $\\nu$ and $\\rho$ parameterize mean and variance.",
        ),
        (
            "where β is the quartile of the one time with itself convolved",
            "where $\\beta$ is the quartile of the one-time-with-itself convolved",
        ),
        (
            "Use of quartiles for estimating σ is robust",
            "Use of quartiles for estimating $\\sigma$ is robust",
        ),
    ]
    for old, new in repls:
        text = text.replace(old, new)

    old_sigma = r"""\begin{aligned}
\sigma^{2} & = \frac{1} {2 ( n - 1)} \left \{E \left [ \sum _{t = 1}^{n - 1} ( y _{t + 1} - y _{t})^{2} \right ] - \sum _{m = 1}^{k - 1} ( \mu _{m + 1} - \mu _{m})^{2} \right \} \\
& = \frac{1} {2 ( n - 1)} E \left [ \sum _{t = 1}^{n - 1} ( y _{t + 1} - y _{t})^{2} \right ] \cdot \left [ 1 - O \left ( \frac{k} {n} \frac{\rho^{2}} {\sigma^{2}} \right)\right ]
\end{aligned}"""
    new_sigma = r"""\begin{aligned}
\sigma^2 &= \frac{1}{2(n-1)}\left\{\mathbb{E}\left[\sum_{t=1}^{n-1}(y_{t+1}-y_t)^2\right] - \sum_{m=1}^{k-1}(\mu_{m+1}-\mu_m)^2\right\} \\
&= \frac{1}{2(n-1)}\mathbb{E}\left[\sum_{t=1}^{n-1}(y_{t+1}-y_t)^2\right]\cdot\left[1 - O\left(\frac{k}{n}\frac{\rho^2}{\sigma^2}\right)\right]
\end{aligned}"""
    text = text.replace(old_sigma, new_sigma)

    old_hm = r"""$$
(\hat{\nu}, \hat{\rho})\approx \arg\max_{(\nu,\rho)} \prod_{t = 1}^{n} P(y_t \mid \hat{\sigma}, \nu, \rho)\quad \text{with} \\
P(y_t \mid \sigma, \nu, \rho) = \int P(y_t \mid \mu, \sigma)\, P(\mu \mid \nu, \rho)\, d\mu \tag{30}
$$

The in-segment variance $\hat{\sigma}$ 2 can be estimated similarly to the last paragraph considering data differences and ignoring segment boundaries:
$$
\hat{\sigma} \approx \arg\max_{\sigma} \prod_{t = 1}^{n - 1} P(y_{t + 1} - y_t \mid \sigma)\quad \text{with} \\
P(y_{t + 1} - y_t = \Delta \mid \sigma)\approx \int_{- \infty}^{\infty} P(y_{t + 1} = a + \Delta \mid \mu,\sigma)\, P(y_t = a \mid \mu,\sigma)\, da \tag{31}
$$
Note that the last expression is independent of the segment level (this was the whole reason for considering data differences) and exact iff y t and y t +1 belong to the same segment. In general (beyond the exponential family) ($\hat{\nu}$, $\hat{\rho}$, $\hat{\sigma}$ ) can only be determined numerically.
Using median and quartile."""
    new_hm = r"""$$
(\hat{\nu}, \hat{\rho}) \approx \arg\max_{(\nu,\rho)} \prod_{t=1}^{n} P(y_t \mid \hat{\sigma}, \nu, \rho) \quad \text{with}
$$

$$
P(y_t \mid \sigma, \nu, \rho) = \int P(y_t \mid \mu, \sigma)\, P(\mu \mid \nu, \rho)\, d\mu \tag{31}
$$

The in-segment variance $\hat{\sigma}^2$ can be estimated similarly to the last paragraph considering data differences and ignoring segment boundaries:

$$
\hat{\sigma} \approx \arg\max_{\sigma} \prod_{t=1}^{n-1} P(y_{t+1} - y_t \mid \sigma) \quad \text{with}
$$

$$
P(y_{t+1} - y_t = \Delta \mid \sigma) \approx \int_{-\infty}^{\infty} P(y_{t+1} = a + \Delta \mid \mu, \sigma)\, P(y_t = a \mid \mu, \sigma)\, da \tag{32}
$$

Note that the last expression is independent of the segment level (this was the whole reason for considering data differences) and exact iff $y_t$ and $y_{t+1}$ belong to the same segment. In general (beyond the exponential family) $(\hat{\nu}, \hat{\rho}, \hat{\sigma})$ can only be determined numerically.

Using median and quartile."""
    text = text.replace(old_hm, new_hm)

    old8 = r"""## 8 The Algorithm
The computation of A , L , R , E , C , B , $\hat{t}$ p , µ r m , F , and $\mu'$ t r by the formulas/recursions derived in Section 5, are straightforward. In (16) one should compute the product, or in (26), (27), (28) the sum, incrementally from j ❀ j +1. Similarly $\mu'$ t r should be computed incrementally by t − 1 n
$$
\widehat{\mu_{t + 1}^{'r}} = \widehat{\mu_t^{'r}} - \sum_{i = 0}^{t - 1} F_{it}^r + \sum_{j = t + 1}^{n} F_{tj}^r
$$
Typically r =0 , 1 , 2. In this way, all quantities can be computed in time $O(k_{\max} n^2)$ and space $O(n^2)$. Space can be reduced to $O(k_{\max} n)$ by computing A on-the-fly in the various expressions at the cost of a slowdown by a constant factor. Table 1 contains the algorithm in pseudo-C code. The complete code including examples and data is available at [Hut05a]. Since A 0 , L , R , and E can be exponentially large in n , i.e. huge or tiny, actually their logarithm has to be computed and stored. In the expressions, the logarithm is pulled in by log( x · y )=log( x )+log( y ) and log( x + y )= log( x )+log(1+exp(log( y ) − log( x )) for x>y and similarly for x<y . Instead of A r ij we have to compute A r ij /A 0 ij by pulling the denominator into the integral.
## 9 Synthetic Examples"""
    new8 = r"""## 8 The Algorithm

The computation of $A$, $L$, $R$, $E$, $C$, $B$, $\hat{t}_p$, $\widehat{\mu_m^r}$, $F$, and $\widehat{\mu_t^{'r}}$ by the formulas/recursions derived in Section 5 are straightforward. In (16) one should compute the product, or in (26), (27), (28) the sum, incrementally from $j \leadsto j+1$. Similarly $\widehat{\mu_t^{'r}}$ should be computed incrementally by

$$
\widehat{\mu_{t+1}^{'r}} = \widehat{\mu_t^{'r}} - \sum_{i=0}^{t-1} F_{it}^r + \sum_{j=t+1}^{n} F_{tj}^r
$$

Typically $r=0,1,2$. In this way, all quantities can be computed in time $O(k_{\max} n^2)$ and space $O(n^2)$. Space can be reduced to $O(k_{\max} n)$ by computing $A$ on-the-fly in the various expressions at the cost of a slowdown by a constant factor. Table 1 contains the algorithm in pseudo-C code. The complete code including examples and data is available at [Hut05a]. Since $A^0$, $L$, $R$, and $E$ can be exponentially large in $n$, i.e. huge or tiny, actually their logarithm has to be computed and stored. In the expressions, the logarithm is pulled in by $\log(x \cdot y)=\log(x)+\log(y)$ and $\log(x+y)=\log(x)+\log(1+\exp(\log(y)-\log(x)))$ for $x>y$ and similarly for $x<y$. Instead of $A_{ij}^r$ we have to compute $A_{ij}^r/A_{ij}^0$ by pulling the denominator into the integral.

## 9 Synthetic Examples"""
    text = text.replace(old8, new8)

    text = text.replace("one may iteratively improve them.\n## 8", "one may iteratively improve them.\n\n## 8")

    TARGET.write_text(text, encoding="utf-8")
    print(f"Wrote {TARGET} ({len(text.splitlines())} lines)")


if __name__ == "__main__":
    main()
