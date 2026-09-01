"""Figures for the Harness token-economics paper. All data from the Harness V2
leadership eval report (n=22 prompts, 6 models, baseline frozen 2026-06-07)."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 9,
    "axes.titlesize": 9.5,
    "axes.labelsize": 9,
    "xtick.labelsize": 8.2,
    "ytick.labelsize": 8.2,
    "legend.fontsize": 8.2,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "figure.dpi": 200,
})

V1C, V2C = "#9aa0a6", "#2f5fd0"   # gray for V1, accent blue for V2
GAIN, LOSS = "#216130", "#7e2b2f"

# ---------------- data (from the eval report) ----------------
models  = ["Sonnet 4.6", "Gemini 3.1", "Flash 3.5", "Qwen 3.6", "GLM 5.1", "Palmyra X6"]
cost_v1 = np.array([0.24, 0.19, 0.18, 0.16, 0.21, 0.25])
cost_v2 = np.array([0.15, 0.13, 0.07, 0.09, 0.11, 0.12])
lat_v1  = np.array([52, 49, 60, 44, 47, 50])
lat_v2  = np.array([31, 29, 27, 29, 29, 26])
caps    = ["MSA", "GDR", "CNG", "PLY", "MCP", "PRN", "VOX", "IMG"]
q_v1 = np.array([
    [.95, .80, .80, .75, .78, .62, .88, .70],   # Sonnet
    [.94, .78, .78, .72, .75, .60, .87, .68],   # Gemini
    [.93, .75, .76, .70, .70, .56, .86, .66],   # Flash
    [.92, .74, .72, .66, .65, .52, .85, .62],   # Qwen
    [.93, .76, .77, .71, .72, .58, .86, .69],   # GLM
    [.95, .79, .80, .76, .78, .64, .88, .71]])  # Palmyra
q_v2 = np.array([
    [.97, .90, .87, .82, .88, .72, .92, .78],
    [.95, .85, .84, .77, .82, .64, .90, .75],
    [.94, .82, .80, .69, .66, .54, .89, .66],
    [.93, .80, .68, .62, .50, .45, .87, .58],
    [.95, .83, .83, .76, .66, .57, .89, .75],
    [.97, .91, .88, .84, .88, .74, .92, .80]])

# ---------------- Fig 1: headline ----------------
fig, axes = plt.subplots(1, 3, figsize=(7.0, 2.15), constrained_layout=True)
panels = [("Cost per task", 0.21, 0.12, "$%.2f", "-41%"),
          ("Wall-clock per task", 48, 27, "%ds", "-44%"),
          ("Tokens per task", 14.2, 8.8, "%.1fk", "-38%")]
for ax, (title, a, b, fmt, d) in zip(axes, panels):
    bars = ax.bar([0, 1], [a, b], width=0.62, color=[V1C, V2C])
    ax.set_xticks([0, 1]); ax.set_xticklabels(["Baseline", "Harness"])
    ax.set_title(title, pad=8)
    for x, v in zip([0, 1], [a, b]):
        ax.text(x, v, " " + fmt % v, ha="center", va="bottom", fontsize=8.4)
    ax.text(1, b * 0.45, d, ha="center", color="white", fontweight="bold", fontsize=9.5)
    ax.set_ylim(0, a * 1.22); ax.set_yticks([])
    for s in ["left"]: ax.spines[s].set_visible(False)
fig.savefig("figures/fig1_headline.pdf"); plt.close(fig)

# ---------------- Fig 2: per-model efficiency ----------------
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(7.0, 2.7), constrained_layout=True)
x = np.arange(len(models)); w = 0.38
for ax, v1, v2, ylab, fmt in [(ax1, cost_v1, cost_v2, "USD per task", "$%.2f"),
                              (ax2, lat_v1, lat_v2, "seconds per task", "%d")]:
    ax.bar(x - w/2, v1, w, color=V1C, label="Baseline")
    ax.bar(x + w/2, v2, w, color=V2C, label="Writer Harness")
    for xi, (a, b) in enumerate(zip(v1, v2)):
        ax.text(xi + w/2, b, "-%d%%" % round(100 * (1 - b / a)),
                ha="center", va="bottom", fontsize=7.6, color=GAIN, fontweight="bold")
    ax.set_xticks(x); ax.set_xticklabels([m.replace(" ", "\n") for m in models])
    ax.set_ylabel(ylab)
ax1.set_title("Cost per task"); ax2.set_title("Median wall-clock per task")
ax1.legend(frameon=False, loc="upper left", ncols=1)
fig.savefig("figures/fig2_permodel.pdf"); plt.close(fig)

# ---------------- Fig 3: quality parity scatter ----------------
fig, ax = plt.subplots(figsize=(4.5, 4.1), constrained_layout=True)
mcolors = ["#2f5fd0", "#7a44c9", "#2e9e6b", "#d07a2f", "#c94444", "#111111"]
mks = ["o", "s", "^", "D", "v", "*"]
for i, m in enumerate(models):
    ax.scatter(q_v1[i], q_v2[i], s=46 if mks[i] == "*" else 30, marker=mks[i],
               color=mcolors[i], label=m, alpha=0.88, zorder=3,
               edgecolors="white", linewidths=0.5)
lim = (0.40, 1.0)
ax.plot(lim, lim, color="#c9c9ce", lw=1, zorder=1)
ax.fill_between(lim, lim, [1.0, 1.0], color="#dcf0e0", alpha=0.5, zorder=0)
ax.fill_between(lim, [0.40, 0.40], lim, color="#f9dcde", alpha=0.45, zorder=0)
ax.text(0.435, 0.955, "Harness better", fontsize=8, color=GAIN)
ax.text(0.80, 0.435, "Harness worse", fontsize=8, color=LOSS)
ax.set_xlim(lim); ax.set_ylim(lim)
ax.set_xlabel("Capability score under baseline")
ax.set_ylabel("Capability score under harness")
ax.legend(frameon=False, loc="upper left", fontsize=7.6, handletextpad=0.2,
          borderaxespad=0.1, labelspacing=0.3)
fig.savefig("figures/fig3_parity.pdf"); plt.close(fig)

# ---------------- Fig 4: harness leverage ----------------
qbar1, qbar2 = q_v1.mean(axis=1), q_v2.mean(axis=1)
dq = qbar2 - qbar1
fig, ax = plt.subplots(figsize=(4.7, 3.0), constrained_layout=True)
for i, m in enumerate(models):
    ax.scatter(qbar1[i], dq[i], s=70 if mks[i] == "*" else 46, marker=mks[i],
               color=mcolors[i], zorder=3, edgecolors="white", linewidths=0.6)
    if m == "Flash 3.5":
        ax.annotate(m, (qbar1[i] - 0.004, dq[i] - 0.002), fontsize=7.8, ha="right")
    elif m == "GLM 5.1":
        ax.annotate(m, (qbar1[i] + 0.004, dq[i] - 0.011), fontsize=7.8)
    else:
        ax.annotate(m, (qbar1[i] + 0.004, dq[i] + 0.004), fontsize=7.8)
b, a = np.polyfit(qbar1, dq, 1)
xs = np.linspace(qbar1.min() - 0.01, qbar1.max() + 0.01, 20)
ax.plot(xs, a + b * xs, color="#c9c9ce", lw=1, ls="--", zorder=1)
ax.axhline(0, color="#e2e2e6", lw=0.8)
r = np.corrcoef(qbar1, dq)[0, 1]  # reported in caption/text as r = 0.99
ax.set_xlabel("Mean capability score under baseline")
ax.set_ylabel(r"Harness leverage  $\Delta\bar{q}$  (harness $-$ baseline)")
fig.savefig("figures/fig4_leverage.pdf"); plt.close(fig)

# ---------------- Fig 5: replay-growth schematic ----------------
k = np.arange(1, 13)
S, m = 1.2, 0.9          # system prompt ktok, mean per-turn payload ktok
naive = k * S + (k * (k - 1) / 2) * m
managed = k * S + np.minimum((k * (k - 1) / 2) * m, (k - 1) * 1.6 * m)
fig, ax = plt.subplots(figsize=(4.7, 2.7), constrained_layout=True)
ax.plot(k, naive, color=LOSS, lw=1.8, label="Naive replay: $O(k^2)$")
ax.plot(k, managed, color=V2C, lw=1.8, label="Harness-managed context: $O(k)$")
ax.fill_between(k, managed, naive, color="#f9dcde", alpha=0.5)
ax.text(9.1, 44, "token maxing\nregion", fontsize=8, color=LOSS, ha="center")
ax.set_xlabel("Agent turns $k$")
ax.set_ylabel("Cumulative input tokens (illustrative, k-tok)")
ax.legend(frameon=False, loc="upper left")
fig.savefig("figures/fig5_replay.pdf"); plt.close(fig)

# ---------------- Fig 6: fleet economics ----------------
n = np.linspace(0, 2.0, 50)  # million tasks / month
fig, ax = plt.subplots(figsize=(4.7, 2.8), constrained_layout=True)
ax.plot(n, 0.21 * n, color=V1C, lw=1.8, label="Baseline blended ($0.21/task)")
ax.plot(n, 0.12 * n, color=V2C, lw=1.8, label="Harness blended ($0.12/task)")
ax.fill_between(n, 0.12 * n, 0.21 * n, color="#dcf0e0", alpha=0.6)
ax.annotate("$90k/month at 1M tasks\n($1.08M/year)", xy=(1.0, 0.165), xytext=(1.08, 0.31),
            fontsize=8.2, color=GAIN,
            arrowprops=dict(arrowstyle="-", color=GAIN, lw=0.8))
ax.set_xlabel("Agent tasks per month (millions)")
ax.set_ylabel("LLM spend ($M / month)")
ax.legend(frameon=False, loc="upper left")
fig.savefig("figures/fig6_fleet.pdf"); plt.close(fig)

# sanity: derived numbers used in the text
print("capability means V1:", np.round(qbar1, 3))
print("capability means V2:", np.round(qbar2, 3))
print("delta:", np.round(dq, 3), " r =", round(r, 3))
print("q/$ V1:", np.round(qbar1 / cost_v1, 2))
print("q/$ V2:", np.round(qbar2 / cost_v2, 2))
print("q/$ gain %:", np.round(100 * (qbar2 / cost_v2) / (qbar1 / cost_v1) - 100, 1))
print("agg q/$: ", 0.78/0.21, "->", 0.81/0.12, "=", round(100*((0.81/0.12)/(0.78/0.21)-1),1), "%")
print("completions per Mtok:", round(0.78/14200*1e6,1), "->", round(0.81/8800*1e6,1))

# ---------------- fig7: two-zone prompt anatomy ----------------
fig, ax = plt.subplots(figsize=(6.6, 3.4))
zones = [  # (label, height, cached, breakpoints)
    ("TOOL SCHEMAS  (full catalog, ~35 tools)", 0.9, True,  ["C1"]),
    ("STABLE SYSTEM PROMPT  (identity, contracts)", 0.7, True, ["C2"]),
    ("CHECKPOINT SUMMARIES  (if ever compacted)", 0.55, True, []),
    ("DURABLE TRANSCRIPT  (append-only turns)", 1.5, True, ["C3", "C4"]),
    ("VOLATILE TAIL — rebuilt every turn:  datetime · files · plan · reminders · voice", 0.85, False, []),
]
BLUE_FILL, BLUE_EDGE = "#e4ebf9", "#2f5fd0"
GRAY_FILL, GRAY_EDGE = "#f1f1f1", "#9aa0a6"
y = 0.0
tops, bottoms = [], []
for label, h, cached, bps in reversed(zones):
    fc, ec = (BLUE_FILL, BLUE_EDGE) if cached else (GRAY_FILL, GRAY_EDGE)
    hatch = None if cached else "///"
    ax.add_patch(plt.Rectangle((0, y), 6.0, h, facecolor=fc, edgecolor=ec,
                               lw=1.1, hatch=hatch, zorder=2))
    ax.text(0.18, y + h/2, label, va="center", ha="left", fontsize=8.1,
            color="#222222", zorder=3)
    for j, bp in enumerate(bps):
        by = y + h * (0.5 if len(bps) == 1 else (0.3 + 0.4*j))
        ax.add_patch(plt.Rectangle((5.78, by-0.09), 0.34, 0.18, facecolor=BLUE_EDGE,
                                   edgecolor="none", zorder=4))
        ax.text(5.95, by, bp, va="center", ha="center", fontsize=6.6,
                color="white", zorder=5, fontweight="bold")
    if cached: tops.append(y + h); bottoms.append(y)
    y += h
prefix_lo, prefix_hi = min(bottoms), max(tops)
tail_hi = prefix_lo
ax.annotate("", xy=(6.55, prefix_hi), xytext=(6.55, prefix_lo),
            arrowprops=dict(arrowstyle="-", color=BLUE_EDGE, lw=1.4))
ax.text(6.7, (prefix_lo+prefix_hi)/2,
        "byte-stable prefix\ncached at $\\approx$0.1$\\times$ read price\n(99.9% of prompt tokens\non identical-prefix call)",
        va="center", ha="left", fontsize=7.6, color=BLUE_EDGE)
ax.annotate("", xy=(6.55, tail_hi), xytext=(6.55, 0),
            arrowprops=dict(arrowstyle="-", color=GRAY_EDGE, lw=1.4))
ax.text(6.7, tail_hi/2, "volatile tail\nnever cached;\nbreakpoints refused here",
        va="center", ha="left", fontsize=7.6, color="#555555")
ax.set_xlim(-0.1, 9.6); ax.set_ylim(-0.15, y + 0.15)
ax.axis("off")
fig.tight_layout()
fig.savefig("figures/fig7_prompt.pdf")
plt.close(fig)
print("fig7 written")
