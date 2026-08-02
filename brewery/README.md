layout: `brewery/{package/tool/dependency}/**`

includes both first-party and third-party

## What a recipe writes, and where

A brewery directory holds the *recipe* — thin `.csproj` files, `build-*.ps1` scripts, restore
helpers. First-party source stays under `src/{tool}`; the recipe only says how to compile it.

Working output goes to `artifacts/`, never beside the source, and every stage of a module's build
is scoped under that module: `artifacts/{module}/bin/{project}/`, `.../obj/{project}/`, and
`.../publish/` for pre-release staging. One module's entire working footprint is therefore one
deletable directory. The bin and obj halves are automatic — `Directory.Build.props` at the
repository root derives the module from the project's own directory name, so a `.csproj` placed at
`brewery/{module}/` needs no output-path configuration at all, and every project of one module
shares one folder. Scripts scope themselves the same way; see `artifacts/README.md` for the rule
and `brewery/node/restore-node.ps1` for a non-.NET example.

Release payloads — the binaries other parts of the repo consume — are **released** to
`packages/{module}/`, never delivered from `artifacts/`. The module's `build-*.ps1` owns the
hand-off: harness first, then publish into `artifacts/{module}/publish/`, verify the expected
payload is present, and only then move it into `packages/{module}/`. `build-doccer.ps1` refuses
staging and package targets outside those two roots.

`packages/` is ignored in its entirety: it holds only regenerated or re-fetched payloads, and a
clean clone starts without it. Every shelf there must therefore be reproducible from a recipe in
this directory.

## Recipes not yet written

Two shelves predate that rule. Both were built outside this repository and vendored as finished
binaries, so neither has a recipe yet and neither survives a clean clone. Both are re-obtainable
from upstream at the versions that were in use, recorded here so the pin is not lost with the
binary:

| Shelf | Vendored version | Upstream |
|---|---|---|
| `packages/tectonic` | `0.16.9+20260504` | tectonic-typesetting GitHub releases |
| `packages/pdfpig` | `0.1.14` | NuGet `UglyToad.PdfPig` (+ `.Core`, `.Fonts`, `.Tokenization`, `.Tokens`, `.DocumentLayoutAnalysis`) |

Until `restore-tectonic.ps1` and `restore-pdfpig.ps1` exist, treat the working-tree copies as the
only ones and do not delete them.
