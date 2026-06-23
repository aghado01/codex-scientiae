# **Developer Brief: MCP Encoding Robustness & Parser Compatibility**

> **RESOLUTION (2026-06-22).** Acted on after a code audit. The brief's root-cause framing was
> partly a misdiagnosis: **the MCP server's protocol channel was already UTF-8-safe** — `mcp-server.ps1`
> pins a no-BOM UTF-8 `StreamWriter`/`StreamReader` on stdin/stdout. The `ﬁ`-ligature crashes were in
> the agents' *own* scratch Python/pwsh (e.g. `get_titles.py`), not in the server or pipeline. The real
> cause was that post-`finalize` stages weren't exposed as tools, forcing agents into the console.
>
> - **Rec 1 (console code page):** DONE as belt-and-suspenders — added `[Console]::Input/OutputEncoding =
>   UTF8` to the startup block. It does **not** fix the channel (already safe); it protects any *child*
>   process the server spawns from inheriting cp1252.
> - **Rec 2 (subprocess `PYTHONUTF8`):** **N/A** — `preprocess.ps1` and the pipeline are pure PowerShell;
>   nothing shells out to python. No subprocess to configure.
> - **Rec 3 (`.StartsWith` null-safety):** **N/A** — the only `.StartsWith` in `src/` is on a guaranteed-
>   non-null string; `md-repair.ps1` already uses null-safe `-match` throughout.
> - **The actual fix** (separate work): exposed the later stages as tools — `publish`, `repair_headings`,
>   `update_doc_contents`, `splice_md` — so agents stop dropping to the console. That removes the surface
>   where these encoding/parser potholes occurred. See the closing sections of `src/PROCEDURE.md`.

## **Overview**
During the Vladislav Voroninski corpus ingestion process, several failures occurred when running scripts and querying chunks containing non-ASCII typographic ligatures (such as the `ﬁ` ligature, `\ufb01`). These failures stemmed from Windows terminal session defaults (using ANSI/OEM `cp1252` encoding) crashing during stdout/stderr serialization, alongside minor PowerShell parser nuances.

This brief outlines a detailed implementation plan to update the **Restoration Membrane** MCP source code to enforce Unicode/UTF-8 boundaries and improve parser resiliency across all target environments.

---

## **Proposed Source Code Updates**

### **1. Enforce UTF-8 in the Hosting Console Session**
We must guarantee that the parent console session hosting the MCP server is configured for UTF-8 output encoding, independent of standard stream redirects. 

**Target File**: [src/mcp-server.ps1](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/src/mcp-server.ps1)

We will update the startup block (around [L215-L218](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/src/mcp-server.ps1#L215-L218)) to explicitly configure the console output encoding page to UTF-8:

```diff
 # --- own the protocol channel at the .NET level, pinned to UTF-8 (no BOM) ---
 # Redirected std streams on Windows otherwise default to the ANSI/OEM code page, which collapses
 # SMP Unicode (𝔼, surrogate pairs) and accented glyphs to '?'/U+FFFD on both read and write. We
 # take explicit ownership before any frame moves: a UTF-8 reader on stdin, a UTF-8 auto-flushing
 # writer on stdout, and we point the ambient Console.Out at stderr so a stray host write from a
 # dot-sourced lib lands in the log, never mid-frame on stdout.
+
+# Force active console codepage and output stream encoding to UTF-8 (65001)
+[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
+[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
+
 $utf8 = [System.Text.UTF8Encoding]::new($false)                                   # no BOM
 $script:Rpc = [System.IO.StreamWriter]::new([Console]::OpenStandardOutput(), $utf8); $script:Rpc.AutoFlush = $true
 $script:In  = [System.IO.StreamReader]::new([Console]::OpenStandardInput(),  $utf8)
```

---

### **2. Configure Subprocess Environments for UTF-8**
If the MCP server or its scripts invoke external tools (such as Python helper scripts or CLI executables), we must ensure their execution environment inherits UTF-8 flags to prevent them from falling back to `cp1252`.

**Target File**: [src/preprocess.ps1](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/src/preprocess.ps1) (and any other process-launching scripts)

* **Enforce Environment Variables**: Before calling external processes, configure the environment scope:
```powershell
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"
```

---

### **3. Harden Parser Logic against Null/Empty Values**
PowerShell methods (like `.StartsWith()`) throw a `NullReferenceException` if called on a null reference. To prevent this, we should pivot to native PowerShell operator matching or null-checks.

**Target File**: [src/md-cleanup.ps1](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/src/md-cleanup.ps1)

Update any string analysis logic:
```diff
-if ($line.StartsWith("# ")) {
+if ($line -and $line.StartsWith("# ")) {
```
Or use the native `-like` operator which is null-safe:
```powershell
if ($line -like '# *') {
```

---

### **4. Document Host Launcher Requirements**
Update client installation instructions to ensure parent shell launches are clean and do not inject profile outputs.

**Target File**: [src/SETUP.md](file:///C:/Users/azrie/PDenv/UserGithub/codex-scientiae/src/SETUP.md)

Under the launching arguments, emphasize the usage of `-NoProfile` and setting output encoding:
```markdown
### Windows Launch Command
When configuring the client MCP connection, ensure the command uses `-NoProfile` and executes in a UTF-8 session:
```json
"mcpServers": {
  "codex-membrane": {
    "command": "pwsh",
    "args": [
      "-NoProfile",
      "-Command",
      "$OutputEncoding = [System.Text.Encoding]::UTF8; & 'C:/path/to/src/mcp-server.ps1'"
    ]
  }
}
```
