from pathlib import Path

p = Path(__file__).resolve().parents[1] / "TN2020.md"
lines = p.read_text(encoding="utf-8").splitlines()
new = (
    "Herein, the second equality follows from definition, "
    "$p(\\Delta_k \\mid \\mathcal{M}_i, g) = \\Delta_{k \\mid \\mathcal{M}_i}$, since the directionality "
    "of a reaction is directly known from the model. Eq. (2) shows where the 'averaging' in BMA comes from: "
    "the probability $p(\\Delta_k \\mid g)$ is the average of $\\Delta_{k \\mid \\mathcal{M}_i}$, weighted "
    "with the posterior probability of the model, $p(\\mathcal{M}_i \\mid g)$. To calculate averaged reaction "
    "direction probabilities, the probability $p(\\mathcal{M}_i \\mid g)$ for each model out of the model family "
    "$\\{\\mathcal{M}_i\\}_i$ is to be determined. To calculate these probabilities Bayes' theorem is employed, "
    "analogous to Eq. (1), but for models rather than the fluxes. Since each model $\\mathcal{M}_i$ relies on "
    "associated fluxes $h_i$, we marginalize over the models' flux spaces. Combining Bayes' theorem and "
    "marginalization (Wasserman, 2013), then leads to the expression for the posterior probability of the model "
    "$\\mathcal{M}_i$:"
)
for i, line in enumerate(lines):
    if line.startswith("Herein, the second equality"):
        lines[i] = new
        print("fixed", i + 1)
        break
p.write_text("\n".join(lines) + "\n", encoding="utf-8")
