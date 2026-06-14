from pathlib import Path
import re

p = Path(__file__).resolve().parents[1] / "HTR2005.md"
text = p.read_text(encoding="utf-8")

clean_integral = r"""$$
A_{ij}^r = \left(\frac{1}{\sqrt{2\pi}\,\sigma}\right)^d \frac{1}{\sqrt{2\pi}\,\rho} \int_{-\infty}^{\infty} \exp\!\left(-\frac{1}{2\sigma^2}\sum_{t=i+1}^{j}(y_t-\mu_m)^2 - \frac{1}{2\rho^2}(\mu_m-\nu)^2\right) \mu_m^r\, d\mu_m
$$"""

def repl_gauss(_m: re.Match[str]) -> str:
    return clean_integral


text, n = re.subn(
    r"\$\$\nA _ \{ i j \} \^ \{ r \}.*?(?:\\dot \{ \\phi \}[\s\\colon\{\}_a-z]*)+\n\$\$",
    repl_gauss,
    text,
    flags=re.DOTALL,
)
print("gaussian integral", n)

text = text.replace("FILL_ME_IN\n\n", "").replace("FILL_ME_IN\n", "").replace("FILL_ME_IN", "")

old = (
    "where $\\Sigma_t$ runs from $i+1$ to $j$.\n\n\n$$"
)
new = (
    "where $\\Sigma_t$ runs from $i+1$ to $j$. The mean/variance is just the weighted average "
    "of the mean/variance of $y_{ij}$ and $\\mu_m$. One may prefer to use the segment prior only "
    "for determining $A_{ij}^0$, but use the unbiased estimators ($\\approx$) for the moments. "
    "Higher moments $A_{ij}^r$ can also be computed from the central moments\n\n\n$$"
)
text = text.replace(old, new)

p.write_text(text, encoding="utf-8")
print("wrote", p)
