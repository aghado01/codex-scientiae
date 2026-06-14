import os

workspace = r"c:\Users\azrie\PDenv\UserGithub\codex-scientiae"
page_path = os.path.join(workspace, r"ingestion\compendia\ph\AL2026\.scratch\page_069.md")
manifest_path = os.path.join(workspace, r"ingestion\compendia\ph\AL2026\.scratch\manifest_069.md")

with open(page_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

def get_block(start_line, end_line):
    return "".join(lines[start_line-1:end_line])

fixes = [
    {
        "raw": get_block(3, 3).strip('\n'),
        "fix": r"By Theorem 4.7, there exists a multiplicity matrix \( g \) for \( I \) of the form"
    },
    {
        "raw": get_block(9, 9).strip('\n'),
        "fix": r"Notice that the last column of \( g_2 \) is the linear combination of its first two columns, hence we may take another morphism \( \tilde{g} \) in \( \mathbb{k}[P] \) given by"
    },
    {
        "raw": get_block(15, 15).strip('\n'),
        "fix": r"such that \( \operatorname{rank} M(g) - \operatorname{rank} M(g_2) = \operatorname{rank} M(\tilde{g}) - \operatorname{rank} M(\tilde{g}_2) \). This shows that the new morphism \( \tilde{g} \) is also a multiplicity matrix for \( I \)."
    },
    {
        "raw": get_block(19, 32).strip('\n'),
        "fix": r"![image 18](<AL2026/imageFile18.png>)" + "\n\n" + r"and define the order-preserving map \( \zeta : Z \to P \) by"
    },
    {
        "raw": get_block(38, 38).strip('\n'),
        "fix": r"Then \( \zeta \) essentially covers \( P \). Indeed, we have the following equality:"
    },
    {
        "raw": get_block(44, 44).strip('\n'),
        "fix": r"Hence by Theorem 4.16 it suffices to compute \( \bar{d}_{R(M)}(R(V_I)) = d_{R(M_j)}(V_Z) \). Now, because"
    },
    {
        "raw": get_block(46, 162).strip('\n'),
        "fix": r"![image 19](<AL2026/imageFile19.png>)" + "\n\n" + r"we conclude that \( d_M(V_P) = 1 \)."
    },
    {
        "raw": get_block(164, 164).strip('\n'),
        "fix": r"We highlight that in the example above, finding a new multiplicity matrix \( \tilde{g} \) for \( I \) is crucial for finding the zigzag poset \( Z \). Indeed, we first notice that \( \zeta \) does not cover the original choice of \( g \) given in (6.84). Next, it is straightforward to verify from Definition 4.10 that the following order-preserving map \( \zeta' : Z' \to P \) covers both \( g \) and \( \tilde{g} \):"
    }
]

with open(manifest_path, "r", encoding="utf-8") as f:
    manifest_lines = f.readlines()

manifest_lines = manifest_lines[:36]

with open(manifest_path, "w", encoding="utf-8") as f:
    f.writelines(manifest_lines)
    f.write("## REPAIR_PROSE\n")
    for fix in fixes:
        f.write("- RAW: ```\n")
        f.write(fix["raw"] + "\n")
        f.write("```\n")
        f.write("  FIX: ```\n")
        f.write(fix["fix"] + "\n")
        f.write("```\n")

print("Done")
