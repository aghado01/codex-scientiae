# gemini-notes — external feedback, NOTES ONLY

> **Status: notes, no more no less.** Raw external review (Gemini, 2026-07-17) of the
> truffle XGBoost engine decision, deposited verbatim by the user. NOT a spec, NOT
> adopted wholesale: the code sketches below contain known defects (unstable per-node
> sort breaking training determinism, float accumulators, shallow monotone-constraint
> handling — see corrections). The adopted subset + corrections live in
> [design-notes.md](design-notes.md) §Engine decision → Implementation notes; that
> section governs. Its closing determinism question was good and is answered there
> (§Determinism contract).

---

The semi-supervised architecture you have outlined is a highly effective structural approach. Using HDBSCAN to establish local typographic canonicalization while delegating cross-document generalization to a supervised tree ensemble neatly isolates document-specific scaling from global semantic rules.

Because your design requires a zero-dependency C# implementation tailored for a specific feature space, you can bypass the heavy abstractions found in generalized libraries like ML.NET.

Here is a reference architecture and pseudocode for building a custom, hardware-accelerated GBDT kernel in C#.

### I. Core Data Structures

To maximize cache locality and hardware acceleration during both the `train` and `score` phases, the tree should be represented as a flat, contiguous array of structs. Relying exclusively on primitive numeric types for traversal avoids the overhead of object references or intermediate string conversions.

```csharp
namespace CodexSci.Xgboost
{
    // A flat array of these structs represents a single tree.
    public struct TreeNode
    {
        public int LeftChild;    // Index in the tree array (-1 if leaf)
        public int RightChild;   // Index in the tree array (-1 if leaf)
        public int FeatureIndex; // Which feature to split on
        public float SplitValue; // Threshold for the split
        public float LeafValue;  // Weight/Score if this is a leaf
        public bool IsLeaf;
    }

    public class RegressionTree
    {
        public TreeNode[] Nodes;

        // Fast traversal using primitive types
        public float Predict(float[] features)
        {
            int curr = 0;
            while (!Nodes[curr].IsLeaf)
            {
                if (features[Nodes[curr].FeatureIndex] < Nodes[curr].SplitValue)
                    curr = Nodes[curr].LeftChild;
                else
                    curr = Nodes[curr].RightChild;
            }
            return Nodes[curr].LeafValue;
        }
    }
}

```

### II. The Exact-Greedy Split Engine

Since your corpus is small, an exact-greedy split search is the appropriate path. The core algorithm relies on the first-order ($g_i$) and second-order ($h_i$) gradients of the loss function.

For a given node, you iterate over every feature. For each feature, you sort the instances, and linearly scan to find the split that maximizes the gain, calculated using L2 regularization ($\lambda$) and tree complexity penalty ($\gamma$):

$$Gain = \frac{1}{2} \left[ \frac{G_L^2}{H_L + \lambda} + \frac{G_R^2}{H_R + \lambda} - \frac{(G_L + G_R)^2}{H_L + H_R + \lambda} \right] - \gamma$$

Here is the algorithmic skeleton for calculating that split:

```csharp
public struct SplitCandidate
{
    public int FeatureIndex;
    public float SplitValue;
    public float MaxGain;
    public float LeftWeight;
    public float RightWeight;
}

public SplitCandidate FindBestSplit(
    int[] instanceIndices,
    float[][] featureMatrix,
    float[] g,
    float[] h,
    float lambda,
    float gamma,
    float minChildWeight)
{
    float G = 0, H = 0;
    foreach(int i in instanceIndices) { G += g[i]; H += h[i]; }

    SplitCandidate best = new SplitCandidate { MaxGain = 0f };
    int numFeatures = featureMatrix[0].Length;

    for (int f = 0; f < numFeatures; f++)
    {
        // 1. Sort instances by the current feature value
        Array.Sort(instanceIndices, (a, b) => featureMatrix[a][f].CompareTo(featureMatrix[b][f]));

        float GL = 0, HL = 0;

        // 2. Exact-greedy linear scan
        for (int i = 0; i < instanceIndices.Length - 1; i++)
        {
            int idx = instanceIndices[i];

            // Apply sample weight discounting natively in the gradient accumulation
            GL += g[idx];
            HL += h[idx];

            float GR = G - GL;
            float HR = H - HL;

            // Enforce min_child_weight constraint (H < threshold)
            if (HL < minChildWeight || HR < minChildWeight) continue;

            // Ensure we only split between distinct feature values
            if (featureMatrix[instanceIndices[i]][f] == featureMatrix[instanceIndices[i + 1]][f])
                continue;

            float gain = 0.5f * (
                (GL * GL) / (HL + lambda) +
                (GR * GR) / (HR + lambda) -
                (G * G) / (H + lambda)
            ) - gamma;

            if (gain > best.MaxGain)
            {
                best.MaxGain = gain;
                best.FeatureIndex = f;
                best.SplitValue = (featureMatrix[instanceIndices[i]][f] + featureMatrix[instanceIndices[i + 1]][f]) / 2.0f;
                best.LeftWeight = -GL / (HL + lambda);
                best.RightWeight = -GR / (HR + lambda);
            }
        }
    }
    return best;
}

```

### III. Addressing the Truffle-Specific Constraints

To fully implement the constraints you outlined for the engine, the following adjustments are required within the training loop:

- **Softmax Multiclass:** Instead of a single tree per iteration, you will train $K$ trees per iteration (where $K$ is the number of typographic roles). The gradients ($g_i$) and hessians ($h_i$) are calculated dynamically based on the cross-entropy loss against the softmax probabilities of the current ensemble's predictions.
- **Sample Weights:** Because you are using the HDBSCAN membership probability to discount certain lines, simply multiply the raw gradients and hessians by the sample weight before passing them into the `FindBestSplit` function. The math scales naturally.

- **Monotone Constraints:** To enforce rules like "P(heading) is non-decreasing in size-rank", you must track the weight limits during tree construction. If a split violates the constraint (e.g., the right child's predicted weight is lower than the left child's weight when it should be higher), you either penalize the gain to force the algorithm to choose a different split or clamp the leaf weights to the parent's value.

Given that your target `model.json` serves as the full dumped ensemble requiring byte-identical determinism on the same input, how are you planning to structure the `System.Text.Json` serialization configuration to guarantee floating-point precision and ordering consistency across runs?
