Full report (agy lanes A+B plus triage addendum) is committed at agy-procurement-review-20260812.md

What needs attention (ranked)
Three tests are silently inert on Windows — test_acquisition.py:802 and test_local_import.py:281/:186-199 degrade to happy-path asserts via try/except OSError: pass with no skip marker, so the pinning/symlink invariants they name never execute here yet report green. test_materialization.py:510 shows the correct house pattern to convert them to. (My probe cleared the fourth suspect, :755 — it runs its real branch.)
validate_deposit_slug itself has no direct test despite being the single guard carrying the whole slug story — because the MCP DepositSlug pattern advertises PORTABLE_LEAF_PATTERN but runtime-enforces a weaker regex that admits ../CON. No reachable traversal exists, but tighten the StringConstraints — it's free.
HttpClient.get follows redirects unconfined (follow_redirects=True, no scheme/host check) while the README reads as transport-wide — and OpenAlex sends its API key as a query parameter. Confine or re-scope. Related: content-encoding on an artifact response silently disables the truncation check; refusing it outright would close that.
Five hand-rolled copies of the cancellation shield (plus \_require_current ×4, \_same_directory_generation ×3, \_is_reparse ×4, portable-leaf ×2) — all settle correctly, but they've drifted in shape (Exception vs BaseException, default vs dedicated executor). Consolidate.
Six of 16 MCP tools are never invoked through the protocol in tests — including all three acquisition tools, the only route to PLAN_ARTIFACT.

C:\Users\azrie\AppData\Local\Temp\pytest-of-azrie is ACL-poisoned — bare pytest throws 273 phantom setup errors for anyone on this box until you delete/repair it (workaround baked into the report: --basetemp).
