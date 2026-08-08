# ive already tried to institutionalize codepoint safety in codex-scientiae, which you can see under this workspace. lets review the src places where that has teeth and for any gaps. the project doesn't use python much directly, even though there's a venv, but it does currently involve alot of powershell and c#

## Findings

1. **P1 — UTF-8 handling silently replaces invalid data.** Most PowerShell paths construct `UTF8Encoding(false)`, while C# uses `Encoding.UTF8`; both default to replacement fallbacks. Malformed UTF-8 or an unpaired surrogate becomes U+FFFD, even though the project treats U+FFFD as evidence of corruption. For example, bytes `61 C3 28 62` decode as `a�(b` instead of failing. This affects the JSONL chokepoint and many ingestion, MCP, audit, and persistence paths.

   Use `new UTF8Encoding(false, true)` for authoritative corpus/protocol boundaries and add malformed-byte plus lone-surrogate canaries. If legacy input must be repairable, give it an explicit, observable permissive lane rather than using replacement globally.

::code-comment{title="[P1] UTF-8 silently manufactures U+FFFD" body="UTF8Encoding(false) uses replacement fallbacks. Malformed input bytes and unpaired UTF-16 surrogates are silently converted to U+FFFD, contradicting the invariant that U+FFFD indicates destroyed data. Centralize a strict UTF-8 instance using new UTF8Encoding(false, true), with any permissive legacy ingestion made explicit and observable." file="D:/aghado01/codex-scientiae/src/shared/jsonl.ps1" start=121 priority=1}

2. **P1 — supposedly stable anchors vary between processes.** [`md-anchor.ps1`](D:/aghado01/codex-scientiae/src/shared/md-anchor.ps1:22) uses `string.GetHashCode()`. .NET deliberately randomizes string hashing per process. Five fresh PowerShell processes produced five different anchors for `😀`. This breaks regenerated links for punctuation- or emoji-only headings. The existing test only repeats the call inside one process.

::code-comment{title="[P1] Anchor fallback is process-randomized" body="String.GetHashCode() is randomized per process, so headings that slug to empty receive different anchors after restart. Hash explicitly encoded UTF-8 with a stable algorithm such as SHA-256 and truncate the digest; add a cross-process test using an emoji-only heading." file="D:/aghado01/codex-scientiae/src/shared/md-anchor.ps1" start=22 priority=1}

3. **P2 — supplementary-plane math characters are not considered single glyphs.** [`md-math.ps1`](D:/aghado01/codex-scientiae/src/md-postprocess/md-math.ps1:82) equates `.Length -eq 1` with one character and later casts the first UTF-16 code unit to `char`. Thus `𝕏` has length 2 and fails both the glyph and strong-math classifiers, despite SMP mathematical alphabets being part of the project’s glyph gauntlet.

::code-comment{title="[P2] UTF-16 length rejects SMP math glyphs" body="String.Length counts UTF-16 code units, so a single supplementary-plane symbol such as 𝕏 has length 2 and is rejected here and by Test-StrongMath. Decode exactly one System.Text.Rune and classify Rune.GetUnicodeCategory; compare weak-symbol exclusions using Rune.Value." file="D:/aghado01/codex-scientiae/src/md-postprocess/md-math.ps1" start=82 priority=2}

4. **P2 — mask rebasing can split a surrogate pair.** [`Move-Mask`](D:/aghado01/codex-scientiae/src/shared/masks.ps1:248) and `Limit-Mask` create new offsets without access to the destination text, so they bypass `New-Mask -Over`, which performs surrogate-boundary snapping. Moving `[0,1)` by two into `a𝔼b` produces `[2,3)`, beginning on the low surrogate.

::code-comment{title="[P2] Rebasing bypasses scalar-boundary enforcement" body="This rebuilds the mask using only a numeric length, so a valid local boundary can become an invalid destination boundary inside a surrogate pair. Accept the destination text and normalize with -Over, or formally require and validate scalar-safe destination offsets. Add an SMP pincer/rebasing test." file="D:/aghado01/codex-scientiae/src/shared/masks.ps1" start=252 priority=2}

## Where the safeguards already have teeth

The strongest part is the C# core:

- [`TextTopology.cs`](D:/aghado01/codex-scientiae/src/doccer/Core/TextTopology.cs:160) enumerates `Rune` values rather than pretending UTF-16 code units are characters.
- [`TextMaster.cs`](D:/aghado01/codex-scientiae/src/doccer/Core/TextMaster.cs:88) rejects spans splitting surrogate pairs.
- Its fingerprint intentionally hashes raw UTF-16 code units, preserving distinctions between malformed surrogate sequences.
- Regex-derived claims are validated against the master before admission.
- JSONL indices, reader slices, TOC offsets, and surgical Markdown repairs are byte-addressed rather than mixing byte and UTF-16 coordinates.
- Culture-invariant regex behavior and ordinal comparisons are explicitly tested.

Verification was clean: 61 focused PowerShell tests passed across encoding, masks, anchors, math-register, and reader-MCP, plus all 1,500 C# contract checks. No files were changed.

# is this something worth institutionalizing/persisting as an env var in my user-scoped setup ? for consistency across clients and processes that aren't being served by the powershell_exec

Yes—`PYTHONUTF8=1` is worth standardizing across your portable client launchers. I’d prefer launcher-level persistence over Windows user-global scope, because it avoids changing unrelated Python applications.

Recommended:

```text
PYTHONUTF8=1
PYTHONIOENCODING=utf-8
```

- `PYTHONUTF8=1` makes UTF-8 Python’s default encoding, including cases where wrappers omit `encoding=`. [Python documentation](https://docs.python.org/3.12/using/cmdline.html#envvar-PYTHONUTF8)
- `PYTHONIOENCODING=utf-8` explicitly controls Python’s own standard streams. Your Antigravity launcher already sets this, but the others do not.
- Explicit `encoding="utf-8"` should remain at subprocess boundaries because Python otherwise uses its text-wrapper default. [Python subprocess documentation](https://docs.python.org/3.12/library/subprocess.html)

For PowerShell, there is no equivalent environment variable that universally forces UTF-8. PowerShell 7 already defaults file output to UTF-8 without BOM, while `$OutputEncoding` and `[Console]::OutputEncoding` are process/session settings. [PowerShell encoding documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_character_encoding?view=powershell-7.6)

So my recommendation is:

- Add both Python variables to the shared portable launcher environment.
- Keep explicit encoding in Python wrappers.
- Configure PowerShell encoding in shared profiles or process preludes.
- Avoid global `chcp 65001`, `LANG`, or a custom “UTF-8” variable; they don’t reliably govern redirected subprocess pipes.
