from pathlib import Path
import re

p = Path(__file__).resolve().parents[1] / "HTR2005.md"
text = p.read_text(encoding="utf-8")

replacement = '''### Table 1: Regression algorithm in pseudo C code

`EstGauss(y,n)` and `EstGeneral(y,n,α,β)` compute from data $(y_1,\\ldots,y_n)$ estimates for $\\nu$, $\\rho$, $\\sigma$, and the single-segment evidence $A_{ij}^0$ with moments $A_{ij}^1$, $A_{ij}^2$. `[y]` is the sorted data array; `Grid` is the numerical integration grid.

**EstGauss(y,n)**

```
ν = (1/n) Σ_t y_t
ρ² = (1/(n-1)) Σ_t (y_t - ν)²
σ² = (1/(2(n-1))) Σ_t (y_{t+1} - y_t)²
for i = 0..n:
  for j = i+1..n:
    compute A⁰_ij, A¹_ij, A²_ij from (25)-(27)
return (A[][], ν, ρ, σ)
```

**EstGeneral(y,n,α,β)** uses quartile estimates (32)-(34) and grid integration for non-Gaussian $P$.

**Regression(A,n,k_max)** computes $E$, $C_k$, $\\hat{k}$, $B_i$, $\\hat{t}_p$, $\\hat{\\mu}_p^r$, and $\\hat{\\mu}_t^{\\prime r}$ via the $L$, $R$, and $F$ recursions in Section 5.

'''

text, n = re.subn(
    r"### Table 1: Regression algorithm in pseudo C code\n.*?\n\n!\[",
    replacement + "\n![",
    text,
    count=1,
    flags=re.DOTALL,
)
print("table replaced", n)
p.write_text(text, encoding="utf-8")
