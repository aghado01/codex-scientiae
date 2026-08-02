layout: `brewery/{package/tool/dependency}/**`

includes both first-party and third-party

## What a recipe writes, and where

A brewery directory holds the *recipe* — thin `.csproj` files, `build-*.ps1` scripts, restore
helpers. First-party source stays under `src/{tool}`; the recipe only says how to compile it.

Build output goes to `artifacts/`, never beside the source, and is always scoped by module:
`artifacts/{module}/bin/{project}/` and `artifacts/{module}/obj/{project}/`. This is automatic —
`Directory.Build.props` at the repository root derives the module from the project's own directory
name, so a `.csproj` placed at `brewery/{module}/` needs no output-path configuration at all, and
every project of one module shares one folder. Scripts that write to `artifacts/` scope themselves
the same way; see `artifacts/README.md` for the rule and `brewery/node/restore-node.ps1` for a
non-.NET example.

Release payloads — the binaries other parts of the repo consume — are published to
`packages/{module}/` by the module's `build-*.ps1`, which stages through `artifacts/` first and
refuses targets outside those two roots.
