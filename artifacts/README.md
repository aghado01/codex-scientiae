# artifacts/

Regenerable build and run output. Everything here is disposable by design: deleting the whole
directory must cost nothing but the time to rebuild.

## The rule

**Every write is scoped under a module or process-name subfolder.** Nothing writes a bare
`artifacts/bin`, `artifacts/obj`, `artifacts/publish` or similar. This directory is shared by every
process that emits regenerable output — .NET builds, test runs, publish staging, the npm cache,
tectonic, latex-ingest, math-render — so an unscoped top-level `bin/` collides with all of them and
makes it impossible to clear one module's output without disturbing the rest.

The operating-system user temp tree, including `%LOCALAPPDATA%\Temp` on Windows, is not a project
scratch fallback. Repository test entrypoints require `TEMP`, `TMP`, and `TMPDIR` to identify one declared
job directory below this root. Caller-created test runs use `artifacts/test-runs/YYYYMMDD_HHmmss[_NN]`;
adapters consume that absolute address and never allocate their own runstamp.

The first path segment names a **module** or a **process**, never an output kind. Which of the two
applies follows from what produced the output:

- **Every stage of one module's own build belongs to that module** — compile, intermediates, and
  publish staging all sit together under `artifacts/{module}/`, so one module's entire working
  footprint is one deletable directory. Output kinds are the *second* segment, never the first.
- **A process bucket is for cross-cutting run output** that is not a stage of any one module's
  build, such as test runs of lanes that have no brewery recipe.

```text
artifacts/{module}/bin/{project}/     .NET build output       (automatic — see below)
artifacts/{module}/obj/{project}/     .NET intermediates      (automatic — see below)
artifacts/{module}/publish/           publish staging, pre-release
artifacts/node/npm-cache/             a module-scoped tool cache
artifacts/tests/{lane}/               cross-cutting run output
```

## Nothing is delivered from here

`artifacts/` is working output only, and every path in it is disposable. A payload that other parts
of the repo actually consume is **released** to `packages/{module}/` — same module scoping, but a
tracked destination with a real lifetime. The module's `build-*.ps1` owns that hand-off: it stages
the publish under `artifacts/{module}/publish/`, verifies the expected payload is present, and only
then moves it into `packages/{module}/`. `packages/doccer/` is the worked example. Never point a
consumer at a path under `artifacts/`.

## How it is enforced

For .NET, automatically. `Directory.Build.props` at the repository root sets `BaseOutputPath` and
`BaseIntermediateOutputPath` to `artifacts\{module}\{bin,obj}\{project}\`, deriving the module from
the project's own directory name — which under the `brewery/{module}/**` layout is exactly the
module it belongs to. A new project added under `brewery/` therefore lands in the right place with
no per-project configuration, and sibling projects of one module (for example `Doccer`,
`Doccer.Cli` and `Doccer.Tests`) share one module folder. Override with
`/p:ArtifactsModule=<name>` on the command line if a project's directory is not its module.

Scripts and tools that write here scope themselves; `brewery/*/build-*.ps1` and
`brewery/node/restore-node.ps1` are the worked examples.

This file is the only tracked content under `artifacts/`.
