# artifacts/

Regenerable build and run output. Everything here is disposable by design: deleting the whole
directory must cost nothing but the time to rebuild.

## The rule

**Every write is scoped under a module or process-name subfolder.** Nothing writes a bare
`artifacts/bin`, `artifacts/obj`, `artifacts/out` or similar. This directory is shared by every
process that emits regenerable output — .NET builds, test runs, publish staging, the npm cache,
tectonic, latex-ingest, math-render — so an unscoped top-level `bin/` collides with all of them and
makes it impossible to clear one module's output without disturbing the rest.

```text
artifacts/{module}/bin/{project}/     .NET build output      (automatic — see below)
artifacts/{module}/obj/{project}/     .NET intermediates     (automatic — see below)
artifacts/node/npm-cache/             a module-scoped tool cache
artifacts/publish/{module}/           process-first grouping
artifacts/tests/{module}/             process-first grouping
```

Module-first and process-first are both fine. What matters is that the **first** path segment under
`artifacts/` names a module or a process, never an output kind.

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
