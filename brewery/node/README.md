# Node dependency recipe

This directory is the canonical npm project for reusable third-party Node
dependencies. `package.json` declares the dependencies Codex Scientiae chooses;
`package-lock.json` records their complete resolved graph.

The payload is materialized under `packages/node/node_modules`, not here:

```powershell
./brewery/node/restore-node.ps1
```

The restore recipe stages generated copies of `package.json` and
`package-lock.json` beside the payload because `npm ci` requires its manifest and
lock in the installation prefix. Those copies are ignored; edit only the files in
this recipe directory.

To refresh dependency versions deliberately, update `package.json`, regenerate
this directory's lock with npm, review the lock diff, and run the restore recipe.
Routine restoration uses `npm ci` and must not rewrite the canonical lock.
