# uv and Python toolchain recipe

This recipe restores the Python lane without using an ambient Python or uv installation. `pin.json`
records the uv release archives and digests for supported Windows architectures. `.python-version`
selects the uv-managed Python release, `pyproject.toml` declares dependencies, and `uv.lock` fixes the
complete environment.

```pwsh
./brewery/uv/restore-uv.ps1
```

The restore performs this sequence:

1. download and verify the pinned uv archive inside `artifacts/uv/restore/`;
2. publish `uv.exe` to the ignored `packages/uv/` shelf;
3. install the pinned managed Python under `packages/python/`;
4. synchronize `.venv` from `uv.lock`;
5. copy the verified uv executable into `.venv` for runtime use;
6. verify the runtime dependency group and procurement MCP registration;
7. generate the repository MCP registrations with absolute local paths.

Successful restore scratch is removed. The uv package cache remains under `artifacts/uv/cache/` and is
disposable. Failed restore scratch remains under its compact runstamp for diagnosis. Neither activation nor
an ambient `uv`, `python`, `pip`, or `PATH` lookup is part of the lifecycle.

The generated MCP command is the repository-local uv executable:

```text
<repo>/.venv/Scripts/uv.exe run --project <repo> --locked --no-sync --no-dev --offline scientiae-procurement
```

`requirements.txt` is a generated runtime-only compatibility export. Change dependencies in
`pyproject.toml`, refresh `uv.lock`, and regenerate the export with the command recorded in its header.

The current bootstrap archive set supports Windows x64 and Windows ARM64. Adding a platform requires an
official release artifact, its verified SHA-256 digest, extraction support, and a platform gate.
