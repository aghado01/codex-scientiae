# uv and Python toolchain recipe

This recipe restores the Python lane without using an ambient Python or uv installation. `pin.json`
records the uv release archives and digests for supported Windows architectures. `.python-version`
selects the uv-managed Python release. The venv package graph is pinned at the repository root:
`pyproject.toml` declares runtime dependencies, `uv.lock` freezes the resolved graph, and
`requirements.txt` is the generated compatibility export. `restore-uv.ps1` is the cold-start path
that materializes `.venv` from that lock. A live `uv pip install` into an existing environment is
not the pin; a clone on another machine only sees what this recipe restores.

```pwsh
./brewery/uv/restore-uv.ps1
```

The restore performs this sequence:

1. download and verify the pinned uv archive inside `artifacts/uv/restore/`;
2. publish `uv.exe` to the ignored `packages/uv/` shelf;
3. install the pinned managed Python under `packages/python/`;
4. synchronize `.venv` from `uv.lock`;
5. remove any obsolete uv executable previously copied into `.venv`;
6. verify the runtime dependency group and procurement MCP registration;
7. generate project-root-relative MCP registrations.

Successful restore scratch is removed. The uv package cache remains under `artifacts/uv/cache/` and is
disposable. Failed restore scratch remains under its compact runstamp for diagnosis. Neither activation nor
an ambient `uv`, `python`, `pip`, or `PATH` lookup is part of the lifecycle.

The generated MCP command is the repository-local uv executable:

```text
./packages/uv/uv.exe run --project . --locked --no-sync --no-dev --offline scientiae-procurement
```

`packages/uv/uv.exe` is the sole uv executable authority. `.venv` contains the synchronized Python project
environment and does not contain a copied uv runtime.

`requirements.txt` is a generated runtime-only compatibility export. Change dependencies in
`pyproject.toml`, refresh `uv.lock`, and regenerate the export with the command recorded in its header.

The current bootstrap archive set supports Windows x64 and Windows ARM64. Adding a platform requires an
official release artifact, its verified SHA-256 digest, extraction support, and a platform gate.
