Good, I have the full picture. Here's the complete inventory:

---

## Inventory: Unicode Artifact Distribution in Grimmet.md

### Group A — Ligatures (simple global `.Replace()`)

| Codepoint          | Char          | Occurrences | Fix    |
| ------------------ | ------------- | ----------- | ------ |
| U+FB01             | `ﬁ`           | **441**     | → `fi` |
| U+FB02             | `ﬂ`           | **45**      | → `fl` |
| U+FB00/03/04/05/06 | ff/ffi/ffl/st | 0           | —      |

---

### Group B — U+00A8 ¨ (standalone diaeresis), 34 occurrences / 27 lines

| Garbled pattern       | Count | Correct form                                              |
| --------------------- | ----- | --------------------------------------------------------- |
| `Birkhauser,¨`        | 6     | `Birkhäuser,`                                             |
| `fur¨`                | 2     | `für`                                                     |
| `Lowner¨`             | 2     | `Löwner`                                                  |
| `Haggstr¨ om`         | 2     | `Häggström`                                               |
| `Frohlich,¨`          | 2     | `Fröhlich,`                                               |
| `Jossang,¨`           | 2     | `Jøssang,` (Norwegian ø — uncertain, verify)              |
| `Gebiete¨`            | 2     | `Gebiete` (displaced ¨ from `für`, just remove)           |
| `L¨owner`             | 1     | `Löwner`                                                  |
| `Lo¨wner`             | 1     | `Löwner`                                                  |
| `Martin-Lof,¨`        | 1     | `Martin-Löf,`                                             |
| `Seppal¨ ainen,¨`     | 1     | `Seppäläinen,` (two ¨ consumed)                           |
| `Polynomidentit¨aten` | 1     | `Polynomidentitäten`                                      |
| `Gartner–Ellis¨`      | 1     | `Gärtner–Ellis`                                           |
| `Uber¨`               | 1     | `Über`                                                    |
| `Maes¨`               | 1     | `Maes` (no umlaut; ¨ is displaced artifact)               |
| `chkeitstheorie¨`     | 1     | `chkeitstheorie` (remove; part of larger fused-word line) |

---

### Group C — U+00B4 ´ (standalone acute), 79 occurrences / 57 lines

Majority in bibliography. Patterns:

| Garbled pattern       | Count | Correct                                         |
| --------------------- | ----- | ----------------------------------------------- |
| `Kotecky,´`           | 13    | `Kotecký,`                                      |
| `Probabilites´`       | 7     | `Probabilités`                                  |
| `Ete´`                | 4     | `Été`                                           |
| `Poincare,´`          | 4     | `Poincaré,`                                     |
| `Miracle-Sole,´`      | 4     | `Miracle-Solé,`                                 |
| `enyi´`               | 5     | `Rényi` (part of Erdős–Rényi cluster)           |
| `Probabilit´`         | 3     | `Probabilités` (partial overlap w/ above)       |
| `Pisztora, A.´`       | 3     | `Pisztora, Á.`                                  |
| `Bollobas,´`          | 3     | `Bollobás,`                                     |
| `Sanz-Sole´`          | 2     | `Sanz-Solé`                                     |
| `Couronne,´`          | 2     | `Couronne,` (remove; French surname, no accent) |
| `Percolation et Mod´` | 1     | `Percolation et Modèle`                         |
| `Fernandez´`          | 1     | `Fernández`                                     |
| `Shlosman, [220].´`   | 1     | `Shlosman, [220].` (stray; remove)              |
| `series´`             | 1     | `séries`                                        |
| `Seances´`            | 1     | `Séances`                                       |
| `Theorique´`          | 1     | `Théorique`                                     |
| `Academie´`           | 1     | `Académie`                                      |
| `Mathematique´`       | 1     | `Mathématique`                                  |
| `Zahradn´`            | 1     | `Zahradník` (Czech name — ík)                   |
| `Rucinski,´`          | 1     | `Ruciński,`                                     |
| `Saint Flour´`        | 1     | `Saint-Flour` (remove ´)                        |
| ~22 remaining         | —     | Likely overlaps or fused-word context           |

---

### Group D — U+02DD ˝ (double acute), 6 occurrences / 5 lines

All the same pattern:

| Garbled          | Fix                                             |
| ---------------- | ----------------------------------------------- |
| `Erdos–R˝ enyi´` | `Erdős–Rényi` (ő = double-acute o; é = acute e) |

---

### Groups E–H — Small/exact fixes

| Codepoint     | Char | Count | Garbled                     | Fix                   |
| ------------- | ---- | ----- | --------------------------- | --------------------- |
| U+02DC        | `˜`  | 1     | `Magalhaes,˜`               | `Magalhães,`          |
| U+02D8        | `˘`  | 2     | `Sina˘ı`                    | `Sinaĭ`               |
| U+02C7        | `ˇ`  | 3     | `Cernˇ y,´` / `Nesetˇ ˇril` | `Černý,` / `Nešetřil` |
| grave `` ` `` | —    | 1     | `` `a diverses ``           | `à diverses`          |

---

**Total artifacts: ~602 occurrences across all groups**
**Complexity breakdown:**

- **Trivial global** (Groups A): 486 occurrences, 2 patterns
- **Pattern-level regex** (Groups B, C): ~113 occurrences, ~35 distinct string→string replacements, all in bibliography except a handful in body text
- **Near-exact one-offs** (Groups D–H): ~13 occurrences, 6 patterns
