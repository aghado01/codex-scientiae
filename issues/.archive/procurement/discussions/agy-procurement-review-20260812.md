# agy — procurement redevelopment review (lanes A + B)

**Date:** 2026-08-12 · **Mode:** read-only · **Agent:** agy (adjutant to the primary review agent)
**Trees:** `src/procurement/**` (54 modules, 10,566 lines), `src/mcp-servers/procurement_mcp/**` (12 modules, 485 lines)
**Evidence base:** `scratch/procurement-review/pytest-main.txt` (429 passed / 10 skipped / 140 subtests), `pytest-collect.txt` (439 collected), full source read of both trees, `issues/procurement/**`, `src/logistics/*.ps1`

---

## Executive summary

1. The redevelopment is **structurally sound**: every strong README claim I tested holds, and the `jsonl_engine` boundary is unusually clean — procurement re-implements nothing the engine owns.
2. Both of the primary's open questions resolve **in the implementation's favour**. The cancellation seam is safe: `acquire`, `import`, and `materialize` each carry their own `asyncio.shield`-and-settle wrapper, so no un-awaited thread can write after a reported cancellation.
3. The slug-traversal seam is likewise safe: the MCP `DepositSlug` regex *is* permissive as observed, but all seven client-supplied slug routes reach `validate_deposit_slug` before any filesystem touch. **No unguarded route exists.**
4. What survives from those two is a **contract-honesty** issue — the server advertises `PORTABLE_LEAF_PATTERN` and enforces something weaker — and **five separate copies** of the cancellation shield that have drifted apart.
5. The single largest real finding is duplication with **behavioral drift**: `_require_current` ×4, `_same_directory_generation` ×3, `_is_reparse` ×4 (two variants disagree on `S_ISLNK`), portable-leaf policy ×2, shield ×5.
6. One claim is **narrower than its prose**: redirect confinement and HTTPS-only are enforced in `download_to` only. `HttpClient.get` runs with `follow_redirects=True` and no host or scheme check — and OpenAlex sends its API key as a query parameter.
7. Test coverage is strong where it counts (extraction, materialization, acquisition) and thin at the edges: `download_to`'s five pre-flight guards, `RequestPolicy` validation, and redirect-count exhaustion have no tests at all.
8. **6 of 16 MCP tools are never invoked** by any test — including all three acquisition tools, the only reachable route to the `PLAN_ARTIFACT` capability.
9. The 10 reported skips are benign: 6 are symlink-privilege, and the one genuinely paired POSIX/Windows case (`test_documents.py:117`↔`:130`) is a model to copy.
10. **The more serious skip problem is invisible in the skip census**: four tests silently degrade to a happy-path assertion on Windows via `try/except OSError: pass`, so the invariants they name are never exercised here — yet they report as passed.
11. `test_materialization.py:510-515` already shows the correct pattern (branch on `os.name`, assert the Windows outcome). Three tests in the acquisition and local-import lanes should be converted to match.
12. Gap census is clean: **zero** TODO/FIXME/HACK/XXX markers in either tree, no unreachable provider capability, and no `None`-backed tool in the default composition.
13. Sci-Hub is declaration-only and the route for a DOI-only paper is local-import; that deferral is stated in README prose but has **no tracked brief**. Crossref's absence is entirely silent.
14. The PowerShell logistics lane is **complementary, not conflicting** — both lanes publish `article.json` and `inventory.jsonl` through the same `jsonl_engine` verbs. `latex-source-batch.ps1` holds one capability the Python lane lacks.
15. Highest-value follow-ups, in order: convert the four silently-degrading tests; decide the `DepositSlug` contract; confine or re-scope `HttpClient.get` redirects; consolidate the five shields; test `validate_deposit_slug` directly.

---

# Lane A — tests & coverage

Scope read: 54 modules under `src/procurement/**` and 12 under `src/mcp-servers/procurement_mcp/**`; 18 test files under `tests/procurement/`, 2 under `tests/mcp-servers/procurement_mcp/`, plus the `tests/jsonl_engine/` witnesses reached by materialization.

## A1 — Coverage census

### Test-file weights (from `pytest-collect.txt`)

| Test file | Collected |
|---|---|
| `tests/procurement/test_materialization.py` | 26 |
| `tests/procurement/test_acquisition.py` | 22 |
| `tests/procurement/test_providers.py` | 14 |
| `tests/procurement/test_metadata_service.py` | 14 |
| `tests/procurement/test_http.py` | 14 |
| `tests/procurement/test_provider_catalog.py` | 13 |
| `tests/procurement/test_composition.py` | 12 |
| `tests/procurement/test_source_extraction.py` | 10 |
| `tests/procurement/test_storage_kernel.py` | 9 |
| `tests/procurement/test_models.py` | 9 |
| `tests/procurement/test_local_import.py` | 8 |
| `tests/procurement/test_identifiers.py` | 7 |
| `tests/procurement/test_discovery_service.py` | 6 |
| `tests/procurement/test_source_latex.py` | 5 |
| `tests/procurement/test_catalog_service.py` | 4 |
| `tests/mcp-servers/procurement_mcp/test_registration.py` | 4 |
| `tests/procurement/test_package_layout.py` | 2 |
| `tests/mcp-servers/procurement_mcp/test_server.py` | 2 |
| `tests/procurement/test_source_tree.py` | 1 |
| `tests/procurement/test_source_contracts.py` | 1 |

### Module → covering tests → depth

Depth key: **direct-unit** = a test imports and drives the module's own API; **via-service** = only reached through a caller; **thin** = imported directly but only one narrow behavior asserted.

| Module (lines) | Covering test files | Depth |
|---|---|---|
| `transport/http.py` (617) | `test_http.py` (14), `test_acquisition.py::TestStreamedDownloads` (5, `:584–746`) | direct-unit |
| `providers/arxiv.py` (366) | `test_providers.py::TestArxivProvider` (3), `test_acquisition.py:415` | direct-unit |
| `providers/zenodo.py` (415) | `test_providers.py::TestZenodoProvider` (3), `test_acquisition.py:498` | direct-unit |
| `providers/openalex.py` (338) | `test_providers.py` + `TestProviderMetadataEvidence` | direct-unit |
| `providers/semanticscholar.py` (275) | `test_providers.py` | direct-unit |
| `providers/base.py` (185), `catalog.py` (194) | `test_provider_catalog.py` (13), `test_discovery_service.py`, `test_metadata_service.py` | direct-unit |
| `providers/factory.py` (227), `builtin.py` (47) | `test_composition.py:75`, `:143` | direct-unit |
| `providers/scihub.py` (20) | `test_composition.py:88,104,125` | direct-unit (module is a declaration only) |
| `storage/roots.py` (259) | `test_storage_kernel.py:134–214` (5), `test_catalog_service.py`, `test_local_import.py:204` | direct-unit |
| `storage/acquisitions.py` (430) | `test_acquisition.py:369–1098`, `test_local_import.py`, `test_materialization.py` | direct-unit |
| `storage/source_deposits.py` (565) | `test_materialization.py` only (constructed at `:131`); `test_package_layout.py:40` names it | **via-service** |
| `storage/article.py` (102) | `test_materialization.py:418,499` (injected as a callable) | **via-service** |
| `storage/catalogs.py` (76) | `test_catalog_service.py` (4), `test_materialization.py` | direct-unit |
| `storage/documents.py` (53) | `test_storage_kernel.py:215–258` (4) | direct-unit |
| `storage/schemas.py` (41) | `test_metadata_service.py:112` | thin |
| `source/extraction.py` (512) | `test_source_extraction.py` (10 tests, ~35 subtests) | direct-unit (strongest lane) |
| `source/latex.py` (423) | `test_source_latex.py` (5), `test_source_extraction.py:108,146` | direct-unit |
| `source/tree.py` (290) | `test_source_tree.py` (1), `test_source_contracts.py`, `test_source_extraction.py` | **thin** |
| `source/_safety.py` (188) | no direct importer; reached via `extraction`/`latex`/`local_import` — **see reconciliation R1** | via-service (path rules: direct-unit) |
| `source/findings.py` (107) | `test_materialization.py:869` | direct-unit |
| `source/contracts.py` (55) | `test_source_contracts.py` (1) | thin |
| `operations/acquisition.py` (438) | `test_acquisition.py:976–1140` | direct-unit |
| `operations/local_import.py` (407) | `test_local_import.py` (8) | direct-unit |
| `operations/materialization.py` (385) | `test_materialization.py` (26) | direct-unit |
| `operations/metadata.py` (335) | `test_metadata_service.py` (14) | direct-unit |
| `operations/discovery.py` (142) | `test_discovery_service.py` (6) | direct-unit |
| `operations/catalogs.py` (75) | `test_catalog_service.py` (4) | direct-unit |
| `domain/metadata.py` (428), `works.py` (314), `discovery.py` (124), `base.py` (98) | `test_models.py`, `test_metadata_service.py`, `test_storage_kernel.py` | direct-unit |
| `domain/acquisition/planning.py` (332) | `test_acquisition.py:210,330,352` | direct-unit |
| `domain/acquisition/receipts.py` (208), `_schema.py` (141) | `test_acquisition.py:225,369,393` | direct-unit |
| `domain/materialization.py` (220) | `test_materialization.py:956,963` | direct-unit |
| `domain/deposits.py` (79) | only `PORTABLE_LEAF_PATTERN` imported (`test_server.py:32`); `validate_deposit_slug` reached transitively — **see reconciliation R2** | **thin** |
| `domain/providers.py` (51) | `test_provider_catalog.py`, `test_composition.py` | via-service |
| `composition.py` (288) | `test_composition.py` (12) | direct-unit |
| `configuration/models.py` (115) | `test_composition.py:179–235` | direct-unit |
| `configuration/loader.py` (26) | `test_composition.py:69` — default path only | **thin** |
| `identifiers.py` (170) | `test_identifiers.py` (7) | direct-unit |
| `application.py` (51) | `test_server.py:334,754`; `test_composition.py:129` | via-service |
| `errors.py` (69), `limits.py` (6) | asserted on throughout | via-service |
| `procurement_mcp/server.py` (74) | `test_registration.py` (4) | direct-unit |
| `procurement_mcp/tools/*` (413) | `test_registration.py:208` pins name+description+schema fingerprints for all 16; `test_server.py` invokes 10 | mixed |
| `procurement_mcp/runtime.py` (29) | `finish_sync` happy path via three catalog/metadata tools | **thin** |
| `procurement_mcp/contracts.py` (66) | schema fingerprints + `test_server.py:704,714` | direct-unit |
| `procurement_mcp/__main__.py` (6) | none | **untested** |

### Uncovered / thin spots, ranked by unwitnessed risk

**1. `transport/http.py` `download_to` pre-flight guards — all five untested (CONFIRMED).**
No test asserts `http.py:409` (`download_to requires an active PinnedPublicationRoot`), `:414` (`requires at least one allowed host`), `:416` (`private download path already exists`), or `:422` (`unsupported download hash algorithm`). Verified by grepping those literals across `tests/` — the only hits are unrelated PowerShell suites and `test_source_extraction.py:408`. Risk: an empty `allowed_hosts` tuple would silently disable host confinement, and nothing pins that it is refused.

**2. Redirect-loop exhaustion and missing `Location` — untested (CONFIRMED).**
`http.py:462–470` raises for an omitted `Location` and for exceeding `max_redirects`. Grepping `redirect|Location|max_redirects` across `tests/` yields only the three redirect tests at `test_acquisition.py:585, 618, 642`, none of which chains more than one hop. Risk: an unbounded or malformed redirect chain is a confinement bypass with no witness.

**3. `RequestPolicy.__post_init__` validation — untested (CONFIRMED).** `http.py:86–94` rejects negative intervals, `max_attempts < 1`, negative backoff, and `max_decoded_body_bytes < 1`. No test constructs an invalid policy. Risk: a nonsensical policy silently disables retry or capping.

**4. `procurement_mcp/tools/*` — 6 of 16 tools never invoked (CONFIRMED).**
`test_registration.py:19–151` pins name, description, and input/output schema fingerprints for all 16, but `call_tool(...)` across both MCP test files reaches only `discover_search`, `prepare_source_deposit_metadata`, `prepare_article_metadata_by_doi`, `list_local_import_inboxes`, `import_local_artifact`, `materialize_source_deposit`, `list_article_catalogs`, `inspect_article_catalog`, `rebuild_article_inventory`, `list_procurement_providers`. Never executed through the protocol: **`discover_related`, `resolve_reference`, `get_work`, `plan_artifact_acquisition`, `acquire_artifact`, `get_acquisition_receipt`**. Risk: the three acquisition tools' argument marshalling (`tools/acquisition.py:38,58`) is unwitnessed end-to-end. **See reconciliation R4** — lane B raises this one's severity.

**5. Every tool's "service is not configured" branch — untested (CONFIRMED).** `tools/acquisition.py:33,53,71,82,96` and siblings raise `RuntimeError` when the application lacks a service. `RecordingApplication` (`test_registration.py:187`) supplies only `local_import`, but no test calls a tool whose service is absent.

**6. `runtime.finish_sync` cancellation branch — untested (CONFIRMED).** `runtime.py:17–22` settles the worker thread before re-raising `CancelledError`. No MCP test cancels a tool call. **See reconciliation R3.**

**7. `source/_safety.py` has no direct test file (CONFIRMED, refined).** See reconciliation R1: the path-portability half is well covered; only the reparse/symlink refusal branches at `_safety.py:75,94` are unwitnessed on Windows.

**8. `storage/source_deposits.py` (565 lines) is the largest via-service-only module (CONFIRMED).** Only `test_materialization.py:131` constructs it. Its internals (lease, private-tree sweep, generation checks) are asserted through materialization outcomes at `test_materialization.py:461,478,526` rather than at its own API.

**9. `source/tree.py` (290 lines) has one dedicated test (CONFIRMED).** `test_source_tree.py` collects exactly one test, cross-checking against `jsonl_engine.deposit._fingerprint_tree`. Fingerprint agreement is pinned; traversal edge cases are not.

**10. `configuration/loader.py` error path untested (INFERRED).** `test_composition.py:69` calls `load_settings()` with no argument; `ConfigurationError` at `loader.py:24` is unwitnessed. Low risk.

**11. `domain/deposits.py::validate_deposit_slug` has no direct test (CONFIRMED).** **Severity raised by lane B — see reconciliation R2.**

**12. `procurement_mcp/__main__.py` untested.** Six lines, stdio entrypoint. Negligible.

**13. `HttpClient.get` redirect behavior is untested entirely (CONFIRMED, surfaced by lane B).** All three redirect tests target `download_to`. Nothing exercises the metadata-request redirect path, which lane B §B1.5 shows is unconfined.

## A2 — Skip audit

Ten skips, all in `tests/jsonl_engine/**` except one. Two distinct classes.

### Class 1 — Symlink-privilege skips (6 of 10). Runtime `skipTest`, not a platform pairing.

| Reported at | Guard | Invariant unverified |
|---|---|---|
| `test_deposit.py:1013` | `skipTest` at `:1022` | article-route deposit refuses a symlinked `article.json` target |
| `test_deposit.py:1083` | `skipTest` at `:1093` | deposit refuses a symlinked provider-metadata target |
| `test_documents.py:101` | `skipTest` at `:111` | `pin_child` rejects a redirecting directory leaf |
| `test_inventory_catalog.py:510` | `skipTest` at `:517` | inventory refuses a `symbolic link or reparse point` entry |
| `test_publication.py:54` | `skipTest` at `:66` | nested access rejects a redirecting directory component |
| `test_publication.py:346` | `skipTest` at `:357` | publication refuses a `link, reparse point` destination |

**Does a Windows-alternate witness exist? Partially — CONFIRMED.** `tests/jsonl_engine/test_inventory_catalog.py:48–62` defines `_create_directory_junction` using `mklink /J`, which needs no privilege, and drives it at `:82` and `:101`. Those did **not** appear in the skip list, so they ran here. The reparse-point defense **is** witnessed on Windows — but only for the *pinned-root ancestor* path in `inventory_catalog`.

The gap: the junction technique is used in exactly one file. The five other reparse/symlink refusals have **no** junction-based counterpart and are unwitnessed on this host, despite reparse points being a Windows-native attack surface. `procurement/source/_safety.py:75,94` is in the same position with no witness at all.

### Class 2 — Explicit `skipIf(os.name == "nt")` (4 of 10).

There are exactly two `skipUnless(os.name == "nt")` tests in the whole tree: `test_documents.py:130` and `test_concurrency.py:148`. That bounds the pairing question.

| Skip | Reason text | Windows-alternate witness? |
|---|---|---|
| `test_documents.py:117` | "Windows holds the named route against replacement" | **YES — genuinely paired.** `test_documents.py:130` `@skipUnless(os.name == "nt")` asserts `PermissionError` on `os.rename` at `:139–140`, then that the rename succeeds after `__exit__` at `:143–144`. The model pairing. |
| `test_documents.py:198` | "POSIX route replacement witness" | **NO paired test.** Defensible — the precondition is unreachable on Windows *because* `:130` holds — but the dependency is never stated. |
| `test_publication.py:382` | "Windows retains the article route against replacement" | **NO paired test.** The claim in the reason string is asserted only at the root level in `test_documents.py:130`, not for the article route. |
| `tests/procurement/test_catalog_service.py:86` | "Windows retained roots block route replacement" | **NO paired test.** The one procurement-owned skip. `InventoryCatalogError, "retained generation"` (`:96–99`) has no Windows execution and no Windows-side assertion that the replacement is impossible. |

**Mechanism backing the claims (CONFIRMED).** `src/jsonl_engine/publication.py:445` opens each pinned directory with share mode `0x0001 | 0x0002` and the inline comment *"READ | WRITE sharing; deliberately no DELETE sharing"*. That is why `os.rename` on a pinned directory raises `PermissionError` on Windows.

### The larger A2 finding: silently self-disabling tests that emit no skip

Four tests take a `try: os.rename(...) except OSError: pass` fallback and then assert the **happy path** instead of the invariant. They report as passed, so they are invisible in the 10-skip census.

**(a) `tests/procurement/test_acquisition.py:802` — CONFIRMED inert on Windows.**
```
842                    try:
843                        os.rename(target, displaced)
844                    except OSError:
845                        # Windows retains the configured and item directories without delete
846                        # sharing. POSIX may rename them, but all file I/O remains descriptor-relative.
847                        pass
...
854                    if swapped:
855                        with self.assertRaisesRegex(
856                            AcquisitionConflictError,
857                            "retained directory generation",
858                        ):
...
861                    else:
862                        result = await asyncio.wait_for(task, timeout=2)
863                        self.assertEqual(result.outcomes[0].status, "acquired")
```
Both subtests target directories held by an active pin — `staging` and `staging/2008.10579v1` (pinned via `root.pin_child(slug)` at `storage/acquisitions.py:418` for the whole download). With no DELETE sharing the rename raises, `swapped` stays `False`, and only `status == "acquired"` is asserted.

**(b) `tests/procurement/test_local_import.py:281`** — same shape at `:317–322`, same `else: assert result.outcomes[0].status == "acquired"` at `:344–345`. CONFIRMED inert for `item`; INFERRED inert for `inbox` (retained by `storage/roots.py:156` for the application lifetime).

**(c) `tests/procurement/test_local_import.py:186–192` and `:195–199`** — `linked.symlink_to(...)` wrapped in `except OSError: pass`. Both symlink-confinement assertions skipped without a marker. These are the only tests that would drive `_safety.py`'s reparse/symlink refusals.

**(d) `tests/procurement/test_acquisition.py:755`** — same shape at `:772–778` with a `blocked` fallback at `:798–800`. **UNCERTAIN** whether inert here: the rename fires inside the mocked `pin_child` *before* the child is pinned, so it should succeed on Windows and the real assertion should fire. Not settleable read-only.

**The contrast that makes this a defect rather than a doctrine:** `tests/procurement/test_materialization.py:510–515` and `:558–563` face the identical situation and handle it correctly:
```
510    if os.name == "nt":
511        result = asyncio.run(materializer.materialize(request()))
512        assert result.status == "deposited"
513        assert replacement.blocked is True
514        assert replacement.swapped is False
515        assert not (layout.catalog_root / "retired-document").exists()
```
That pins "the replacement was refused by the OS" as a positive claim. The four tests above pin nothing.

## A3 — Test-quality spot-check (5 behaviors)

### 1. `article.json` is published last — **strong; asserts the mechanism.**
`test_materialization.py:404`. Injects a failure into the article-publication step only (`:414–418`), then:
```
437        assert archive.is_file()
438        assert metadata_path.is_file()
439        assert tree_main.is_file()
440        assert not (document / "article.json").exists()
441        assert not [name for name in os.listdir(document) if name.endswith(".tmp")]
```
and on re-run, byte- **and mtime-identical** components:
```
452        assert article_publication.calls == 2
453        for path, (raw, modified) in frozen.items():
454            assert path.read_bytes() == raw
455            assert path.stat().st_mtime_ns == modified
457        assert article["validation"]["publication"] == "recovered-existing-tree"
```
`mtime_ns` equality is the decisive line — a rewrite-with-same-bytes would pass a content check and fail this one.

### 2. Destination no-replace — **strong; asserts refusal plus non-mutation.**
`test_materialization.py:832`, parametrized over `("archive", "tree")`:
```
851        before = conflict.read_bytes() if conflict.is_file() else (conflict / "main.tex").read_bytes()
852        with pytest.raises(SourceMaterializationError, match="conflict"):
...
857        after = conflict.read_bytes() if conflict.is_file() else (conflict / "main.tex").read_bytes()
858        assert after == before
859        assert not (document / "article.json").exists()
```
Refusal *and* byte-preservation of the occupant *and* absence of the sentinel. Receipt-level counterpart at `test_local_import.py:147–150`; mechanism at `storage/acquisitions.py:298–305`.

### 3. Generation pinning across a transaction — **the weakest of the five on this platform.**
`test_acquisition.py:755` asserts the mechanism properly:
```
794            self.assertIsNotNone(caught)
796            self.assertIn("changed while its generation was pinned", str(caught))
797            self.assertEqual(list((staging / "paper").iterdir()), [])
```
— the `_same_directory_generation` check at `storage/acquisitions.py:420–423`, plus no residue. But it sits behind `if swapped:` with an `else: self.assertTrue(blocked)` escape at `:798–800`, and I could not confirm which branch runs.

Its sibling `test_acquisition.py:802` is CONFIRMED to take the escape, leaving only `self.assertEqual(result.outcomes[0].status, "acquired")` (`:863`). The pinning witnesses that *do* execute here are `test_materialization.py:510–515` and `:558–563`.

### 4. Bounded and hash-checked download — **strong, with one real gap.**
```
test_http.py:317        with self.assertRaisesRegex(ProviderPayloadError, "decoded-body limit"):
test_http.py:318            asyncio.run(exercise())
test_http.py:319        self.assertFalse(UnreadBody.iterated)
```
`assertFalse(UnreadBody.iterated)` is decisive: the declared-length rejection at `http.py:326–334` fires *before* the body stream is touched. Post-decode bounding at `test_http.py:274–293`; worker-write chunking at `:80–81`.

Hashing at `test_acquisition.py:610–611`:
```
610            self.assertEqual(result.sha256, hashlib.sha256(PDF).hexdigest())
611            self.assertEqual(dict(result.digests)["md5"], hashlib.md5(PDF).hexdigest())
```
across a redirect hop, with `:612` asserting credential redaction. No-residue at `:700`.

**Gap:** the truncation check compares against `declared_length` (`http.py:532–535`), skipped entirely when `content-encoding` is present (`:503`). No test covers a compressed, truncated download.

### 5. Local-import byte validation — **strong; asserts refusal, residue, and non-mutation.**
`test_local_import.py:134`:
```
142    assert first.outcomes[0].status == "acquired"
143    assert second.outcomes[0].status == "already-present"
147    with pytest.raises(AcquisitionConflictError, match="bytes conflict"):
149    assert (staging / "manual-paper" / "acquisition.json").read_bytes() == before
150    assert not (staging / "manual-paper" / ".download.part").exists()
```
Complemented by `:153` (three refusal classes, then `assert not list(staging.rglob(...))` at `:165–166`) and `:212`. Caveat: the *physical* confinement half (`:169`) has its symlink cases silently skipped here.

---

# Lane B — claims, duplication, gaps

## B1 — README claim verification

### B1.1 — `article.json` published last — **HOLDS, with one precision**

`operations/materialization.py:_publish` order: extraction (`:243`) → inspection (`:248`) → archive copy (`:262`) → PDF copy (`:280`) → metadata bundle (`:302`) → tree install (`:310`) → **article deposit (`:317`)**. Only two reads follow:
```
336            item.assert_current()
337            acquisition_root.assert_current()
```
**CONFIRMED.** Precision: `_publish` has a `finally` after the sentinel —
```
357        finally:
358            item.discard_tree_stage(candidate)
```
an unlink of transaction-owned scratch (`_require_tree_stage` at `source_deposits.py:289-298` refuses anything not `is_transaction_scratch`). "Nothing **observable** is written after it" holds; "nothing is written after it" does not. README line 119 covers this.

### B1.2 — Destination no-replace — **HOLDS for all four components**

| Component | Guard | Verdict |
|---|---|---|
| `{slug}.tar.gz` | `copy_file_no_clobber` (`materialization.py:262`), failure → `SourceMaterializationError` at `:270-273` | CONFIRMED |
| `{slug}-tex/` | `publish_directory` then `except FileExistsError: publication = "recovered-existing-tree"` (`source_deposits.py:377-379`), plus byte-identity re-inspection at `:404-408` — an existing tree is adopted *only if* `tree_sha256` matches | CONFIRMED |
| PDF copy | `copy_file_no_clobber` (`materialization.py:280`); no-receipt case refuses a pre-existing PDF at `:294-297` | CONFIRMED |
| `inventory.jsonl` | `operations/catalogs.py:65-72` passes `force` to `jsonl_engine.build_inventory` with `publication_root=descriptor.publication_root` | CONFIRMED |

`force=True` as sole replacement inside a pinned generation: `catalogs.py:68-72` supplies the pinned root on both paths; `test_catalog_service.py:80-82` witnesses `ValueError, "force=True"`.

### B1.3 — Generation pinning — **HOLDS in the live flow; two latent unpinned branches**

- Byte transfer: `download_to` requires `PinnedPublicationRoot` (`http.py:408-410`), re-checks currency at `:536`, writes via `publication_root.open_file` (`:148`).
- Hashing/validation: `_measure_pinned_file` (`storage/acquisitions.py:89-144`) brackets with `_require_current` at `:96`/`:143` and cross-checks named-vs-opened dev/ino at `:107-115`, `:127-142`.
- Recovery: `AcquisitionItem.recover` (`:311-361`) entirely through `self.publication_root`.
- Publication: `publish_download` → `publication_root.publish(..., overwrite=False)` (`:301`).

**Two unpinned fallbacks reachable by API, not by the flow:**
```
storage/acquisitions.py:154        if publication_root is not None:
                          155            return _measure_pinned_file(publication_root, path)
                          156        return _measure_file(Path(path))
```
`_measure_file` (`:53-86`) opens by fresh path — the re-resolution the claim excludes. Same at `operations/acquisition.py:43-49`. Every in-tree caller passes a root (`acquisitions.py:232`, `operations/acquisition.py:396,419,422,433`). **CONFIRMED for the flow; INFERRED hazard** — `measure_artifact_file` exports `publication_root` as optional, defaulting to `None`.

### B1.4 — Plans never cross the MCP boundary — **HOLDS**

`ArtifactPlanSummary` (`planning.py:289-316`) projects only `kind`, `target_leaf`, `payload_kind`, `candidate_count: int`, `provider_checksum: bool`, `maximum_bytes`. No `url`, no `candidates`, no `allowed_hosts`.

`acquire_artifact` re-plans server-side: `operations/acquisition.py:205` `plan = await self.plan(request)`.

Enumerating every parameter of all 16 tools, the complete client-supplied type set is `DepositSlug`, `NonEmptyIdentifier`/`ProviderName`, `MainTexPath`, `list[ArtifactKind]`, `SourceMetadataInput`, `RelatedKind`, `StartOffset`, `SearchLimit`, `RelatedLimit`, `bool`, `list[ProviderName]`. **No URL, plan, absolute destination, or storage root is accepted anywhere.** CONFIRMED.

`list_article_catalogs` / `inspect_article_catalog` *return* `catalog_directory` (`contracts.py:41`, `:54`) — outbound host-path disclosure, asymmetric with `LocalImportInboxCatalog` which deliberately withholds paths (`test_local_import.py:357`).

### B1.5 — HTTPS-only + redirect confinement — **HOLDS for downloads; DOES NOT hold for metadata requests**

**Plan time:**
```
planning.py:156        @field_validator("url", mode="before")
            158        def _validate_url(cls, value: object) -> str:
            159            return _safe_http_url(value, label="candidate URL")
```
with `is_safe_artifact_url` (`:64-73`) allowing `https` or loopback `http` only, rejecting credentialed URLs (`:70`); `_initial_host_is_allowed` (`:173-178`) pins the first hop.

**Transfer time — re-checked every hop, before the request is built:**
```
http.py:435                    if previous_scheme == "https" and scheme == "http":
        436                        raise ProviderHttpError(
        437                            "artifact redirect attempted an HTTPS-to-HTTP downgrade at "
        440                    if not is_safe_artifact_url(str(current_url)) or host not in allowed:
        441                        raise ProviderHttpError(
        442                            "artifact route left its allowed hosts or safe transport at "
```
with `follow_redirects=False` at `:455`.

**Does every provider download path go through it?** Yes — `download_to` has exactly one caller: `operations/acquisition.py:320`. CONFIRMED.

**The gap.** `HttpClient.get` sends without a redirect argument:
```
http.py:273                response = await self._client.send(request, stream=True)
```
and the owned client is:
```
http.py:242        self._client = client or httpx.AsyncClient(follow_redirects=True)
```
`composition.py:90` takes that default. So `get_json` / `get_document` / `get_text` — used by all four adapters (`openalex.py:91`, `semanticscholar.py:101`, `zenodo.py:132`, `arxiv.py:116,253`) — follow redirects to arbitrary hosts and schemes with no safe-URL check and no allowed-hosts set. **CONFIRMED.**

README line 91 sits in the `AcquisitionService` paragraph so it is arguably download-scoped, but reads as a transport property. Concrete exposure: OpenAlex sends `api_key` as a query parameter (`openalex.py:89-90`), and query strings survive a relative redirect. `_evidence_url` (`:568-579`) redacts it from error text, not from the wire. **INFERRED** on exploitability; **CONFIRMED** that no scheme or host check exists there.

### B1.6 — Bounded during streaming, SHA-256 local, provider integrity — **HOLDS; only Zenodo supplies evidence**

```
http.py:508                if declared_length is not None and declared_length > policy.max_decoded_body_bytes:
        517                async for chunk in response.aiter_bytes(chunk_size=_DOWNLOAD_CHUNK_BYTES):
        518                    total += len(chunk)
        519                    if total > policy.max_decoded_body_bytes:
        520                        raise ProviderPayloadError(
```
An **absent** Content-Length leaves `declared_length = None` (`:502-507`) and `:519` still fires; a **lying understated** one cannot exceed the cap because `:519` counts actual bytes; an overstated one is caught at `:532-535`. CONFIRMED. Metadata parallel at `_bounded_response` (`:313-368`) with pre-consumption rejection at `:326-334`.

Narrow hole: `:503` skips `declared_length` when `content-encoding` is present, disabling the truncation check for compressed artifact responses. The cap still holds.

**SHA-256 measured locally.** Digested per chunk at `http.py:161-162`, then re-measured from disk:
```
operations/acquisition.py:394        size, digest = measure_artifact_file(
                          398        if size != download.bytes or digest != download.sha256:
                          399            raise AcquisitionError("downloaded file changed before payload validation")
```
The receipt digest is a post-write disk measurement. CONFIRMED.

**Which providers supply native integrity evidence? Zenodo only.** `zenodo.py:339` (`checksum`) and `:340-343` (`expected_bytes` from `files[].size`). arXiv supplies neither — reading all three `PlannedArtifact` constructions (`arxiv.py:299-318`, `:322-336`, `:340-354`), no `checksum=` or `expected_bytes=` appears. OpenAlex / Semantic Scholar / Sci-Hub have no `PLAN_ARTIFACT`.

**On mismatch:**
```
operations/acquisition.py:408        if payload.checksum is not None:
                          409            digests = dict(download.digests)
                          410            if digests.get(payload.checksum.algorithm) != payload.checksum.digest:
                          411                raise AcquisitionError(
                          412                    f"downloaded {payload.kind} does not match its provider checksum"
```
Caught at `:344`, appended to `errors`, partial unlinked at `:346-348`, **next candidate tried**. All-fail → `status="error"` (`:250-257`) and **no receipt form published**. CONFIRMED.

### B1.7 — Lock, validation, hashing, publication outside the MCP event loop — **HOLDS**

`AcquisitionService` runs every filesystem operation on a dedicated single-thread executor: lease acquisition (`__aenter__` at `:128` submits `_context.__enter__`, where `FileLock.acquire()` lives — `storage/acquisitions.py:462`), recovery (`:214`), validation (`:228`, `:275`, `:330`), publication (`:261`). Hashing off-loop at `:330` and `http.py:161-162`. Witnessed by `test_acquisition.py:869` and `test_http.py:83` (asserting `loop_thread[0] != fsync_threads[0]` at `:127`). CONFIRMED.

### B1.8 — Cancellation seam — **RESOLVED: every mutating service has its own shield**

The primary's premise about call shape is accurate but the conclusion does not follow. Each service implements its own shield at its own executor boundary:

| Tool | Service entry | Executor site(s) | Shield |
|---|---|---|---|
| `acquire_artifact` | `AcquisitionService.acquire` (`operations/acquisition.py:202`) | `_submit` → `loop.run_in_executor(self._executor, ...)` (`:105-107`), used by `__aenter__` (`:128`), `run` (`:117`), `__aexit__` (`:155`) | `run` at `:117-125`; `__aenter__` at `:130-142` |
| `import_local_artifact` | `LocalImportService.import_artifact` (`local_import.py:143`) | `loop.run_in_executor(None, ...)` (`:147`) — **default** executor | `:149-155` |
| `materialize_source_deposit` | `SourceMaterializationService.materialize` (`materialization.py:64`) | `asyncio.to_thread` in `_run_sync` (`:115`), used at `:70`, `:75`, `:105` | `:117-123` |
| (download worker) | `_WorkerDownloadSink._run` (`http.py:122-145`) | `loop.run_in_executor(self._executor, ...)` (`:118-120`) | `:129-145` |
| `inspect`/`rebuild`/`by-doi` | `finish_sync` (`runtime.py:11-22`) | `asyncio.to_thread` (`:14`) | `:16-22` |

All five share the pattern:
```
materialization.py:117            return await asyncio.shield(task)
                  118        except asyncio.CancelledError:
                  119            try:
                  120                await task
                  121            except Exception:
                  122                pass
                  123            raise
```
**Answer: no, an un-awaited thread cannot keep writing while the request reports cancelled.** The coroutine awaits the worker to completion before re-raising, so the transaction reaches its boundary first. `AcquisitionService` also shuts its executor down with `wait=True` (`:158`) and runs the matching `__exit__` on a cancelled entry (`:138`) so the lease is not orphaned. CONFIRMED, witnessed by `test_acquisition.py:916` and `test_local_import.py:227`, both asserting `not task.done()` immediately after `task.cancel()`.

Three residual notes, none a defect:
1. `_WorkerDownloadSink._run` (`http.py:126-145`) is a more elaborate variant with a `while True` re-await loop; the divergence is uncommented.
2. `LocalImportService` uses the **shared default** executor where acquisition uses a dedicated one. Sizing consideration, not correctness.
3. `runtime.py:20` catches `except Exception` while `operations/acquisition.py:123` catches `except BaseException`. A non-`Exception` `BaseException` from the shielded worker would propagate instead of `CancelledError`.

### B1.9 — Slug traversal seam — **RESOLVED: permissive at MCP, but every route reaches `validate_deposit_slug` before any filesystem touch**

The primary's reading is exactly right:
```
contracts.py:16        StringConstraints(min_length=1, pattern=r'^[^<>:"/\\|?*\x00-\x1f]+$'),
            17        WithJsonSchema(
            18            {"type": "string", "minLength": 1, "pattern": PORTABLE_LEAF_PATTERN},
```
The runtime validator admits `..`, `CON`, `LPT1`, trailing-dot/space names; `PORTABLE_LEAF_PATTERN` is advertised but never enforced by pydantic. CONFIRMED.

The strict guard is `domain/deposits.py:26-37`:
```
31        if not value or value in (".", "..") or value[-1] in (" ", "."):
33        if any(ord(char) < 32 or char in _INVALID_PORTABLE_LEAF for char in value):
35        if value.split(".", 1)[0].upper() in _WINDOWS_RESERVED_LEAVES:
```

| Argument | Route | Guard | Verdict |
|---|---|---|---|
| `get_acquisition_receipt.deposit_slug` | `tools/acquisition.py:72` → `AcquisitionService.inspect` (`operations/acquisition.py:288`) → `self._store.transaction(deposit_slug, create=False)` | `storage/acquisitions.py:388` `slug = validate_deposit_slug(slug)` — **line 1**, before `root.absolute(slug)` at `:391` | **GUARDED** |
| `prepare_article_metadata_by_doi.acquisition_slug` | `tools/metadata.py:49` → same | `acquisitions.py:388` | **GUARDED** |
| `import_local_artifact.inbox`/`.leaf`/`.deposit_slug` | `tools/acquisition.py:98-102` → `LocalImportRequest` | `local_import.py:61-64` `@field_validator("inbox","leaf","deposit_slug", mode="before")` → `validate_deposit_slug`; second guard `source_root.direct_leaf(source)` at `:332` | **GUARDED ×2** |
| `materialize_source_deposit.acquisition_slug` | `tools/materialization.py:37` → `SourceMaterializationRequest` → `_read_acquisition` → `transaction(slug, create=False)` | request-model validation (witnessed: `test_materialization.py:927` `"../escape"` → `ValidationError`), plus `acquisitions.py:388`, plus `source_deposits.py:458` and `:105` | **GUARDED ×3** |
| `materialize_source_deposit.catalog` | → `self._catalogs.resolve(catalog)` (`source_deposits.py:446`) | Not a path component — `ProcurementRootCatalog.resolve` (`storage/roots.py:200-222`) is a `dict.get` on `(kind, name.strip().casefold())` | **N/A — logical name** |
| `prepare_source_deposit_metadata.deposit_slug` | `tools/metadata.py:27` → `MetadataService.collect` | **No filesystem touch on this route.** Re-enters the filesystem only via `publish_metadata`, checked against `self.slug` (`source_deposits.py:263`), validated at `:105` | **N/A / GUARDED downstream** |
| `inspect_article_catalog.catalog`, `rebuild_article_inventory.catalog` | `tools/catalogs.py:50,69` → `ArticleCatalogRoots.resolve` → `ProcurementRootCatalog.resolve` | same `dict.get` | **N/A — logical name** |
| `plan_artifact_acquisition` / `acquire_artifact` | slug is server-minted (`arxiv.py:288`, `zenodo.py:282` `artifact_slug(...)`) | `planning.py:242-245` `_portable_slug` → `validate_deposit_slug`; `:261-263` requires `deposit_slug == artifact_slug(provider, identifier)` | **GUARDED, server-minted** |

**No route is unguarded.** `validate_deposit_slug` has eleven enforcement sites (`deposits.py:47`, `local_import.py:64,75,119`, `acquisitions.py:206,271,388`, `source_deposits.py:105,458`, `planning.py:200,245`). CONFIRMED.

What survives is a **contract-honesty issue, not a reachable traversal**: the server advertises a schema it does not enforce. A pre-validating client and a non-validating one get different errors from the same input. Tightening `StringConstraints(pattern=...)` to `PORTABLE_LEAF_PATTERN` costs nothing behaviorally. Whether the divergence is deliberate (keeping the error message in the domain layer) is not settleable read-only. **Reachable-path answer: none.**

### B1.10 — Explicit-DOI identity checked against API *and* LaTeX — **HOLDS**

1. **Against API results** — `materialization.py:201-205`: `if metadata.identity_anchor != request.identity_anchor: raise ... "resolved API metadata does not match the requested bibliographic identity"`.
2. **Against the LaTeX closure** — `_assert_declared_identity` (`:360-382`):
```
377            canonical = normalize_doi(declared)
378            if canonical != metadata.identity_anchor.value:
379                raise SourceMaterializationError(
380                    f"LaTeX source DOI {canonical!r} conflicts with explicit metadata DOI "
```
plus refusal of a syntactically invalid declared DOI (`:372-376`). Called at `:258`, **before** the first copy at `:262`.
3. **Against reused evidence** — `read_metadata` (`source_deposits.py:174-182`).

**No best-effort mode:** `:194-200` raises rather than degrading; `:206-209` refuses a metadata-free publication carrying a bundle; `MetadataMode` is a closed `Literal` and `:102-103` marks the third branch unreachable. CONFIRMED.

### B1.11 — First sentinel freezes metadata mode and PDF inclusion — **HOLDS**

`source_deposits.py:185-245`:
```
215            article_mode: MetadataMode = (
216                "required" if "metadata_resolution" in article["evidence"] else "omit"
217            )
218            if article_mode != requested_mode:
219                raise SourceMaterializationError(
220                    f"existing article.json uses metadata mode {article_mode!r}, not {requested_mode!r}"
```
```
230            article_has_pdf = any(
231                form.get("role") == "pdf-source" for form in article["source_forms"]
232            )
233            if article_has_pdf != receipt_has_pdf:
236                raise SourceMaterializationError(
237                    "article.json freezes PDF inclusion at first publication: "
```
The mode is derived from the **published sentinel's own evidence block**, so it cannot drift. Called pre-transaction (`materialization.py:75-83`) and inside the pinned generation (`:187-192`).

**Cannot orphan a PDF:** `materialization.py:294-297`. **Cannot mutate an existing article:** copies are no-clobber (`:262`, `:280`), the bundle is create-only (`source_deposits.py:272`, and `:256-261` returns the existing bundle unchanged), the tree is atomic-or-byte-verified (`:404-408`). CONFIRMED.

### B1.12 — Tar terminator, zero-only padding, limits before writing — **HOLDS**

```
extraction.py:100                if len(terminator) != 2 * tarfile.BLOCKSIZE or any(terminator):
             102                    "source tar archive lacks a canonical two-zero-block terminator"
             107                    "source tar archive contains nonzero data after its first "
             108                    "canonical terminator"
```
plus block-alignment at `:95-96`, checked in **both** passes (`:179`, `:255`). Witnessed by `test_source_extraction.py:248` across five malformed-tail subtests (`:262-276`).

`_plan_tar_handle` (`:116-179`) is a complete enumeration pass that writes nothing:
```
130                    if len(plans) >= limits.max_entries:
138                    if member.size < 0 or member.size > limits.max_member_bytes:
143                    if member.size > limits.max_extracted_bytes - extracted_bytes:
156                        relative = _portable_relative(      # → max_path_bytes / max_component_bytes
```
Only then does `_extract_tar_handle` (`:189`) open outputs. `max_extracted_bytes` is cumulative, so many small members cannot collectively exceed it. CONFIRMED.

Precision: `extract_pinned` writes the inflated gzip payload to transaction-owned scratch (`:356`, `:375`) *before* the tar plan, bounded by `max_archive_bytes` on the compressed input (`:363-367`) and a running `max_gzip_payload_bytes` check (`:377-385`). The zip-bomb case is closed; "before writing" is true of the extracted *tree*, not every byte.

## B2 — Duplication of functionality

### B2.1 — Intra-package: five primitives re-implemented per module

| Primitive | Sites | Delta |
|---|---|---|
| **`_require_current`** (try `assert_current()` / catch `RuntimeError` / raise domain error "no longer names its retained directory generation") | `storage/acquisitions.py:44-50`, `operations/local_import.py:42-48`, `storage/source_deposits.py:63-69`, `transport/http.py:35-41` (`_require_download_root`) | **4 copies.** Bodies identical; only the raised type differs. Message byte-identical in three of four. |
| **`_same_directory_generation`** (dev/ino → birthtime → ctime) | `storage/acquisitions.py:32-41`, `source/_safety.py:49-60`, `storage/source_deposits.py:41-52` (`_same_directory`) | **3 copies, ~10 lines each, logically identical.** |
| **`_is_reparse`** | `storage/acquisitions.py:28-29`, `source/_safety.py:25-26`, `storage/source_deposits.py:35-38`, `operations/local_import.py:288-291` (`_is_link_or_reparse`) | **4 copies, and they disagree.** Two test only `st_file_attributes & 0x400`; two also test `S_ISLNK`. `acquisitions.py:99` and `:358` use the attribute-only version without a separate `S_ISLNK` test. **Behavioral divergence, not just duplication.** |
| **Portable-leaf rule** | `domain/deposits.py:13-18` + `validate_deposit_slug:26-37` vs `source/_safety.py:16-21` + `_portable_leaf:107-121` | **2 implementations of one policy**, duplicated constants. They diverge: `_portable_leaf` also rejects surrogates (`:110`) and enforces UTF-8/UTF-16 length bounds (`:117-121`); `validate_deposit_slug` does neither. |
| **Shield-a-worker-future** | `operations/acquisition.py:109-125`, `operations/local_import.py:146-155`, `operations/materialization.py:112-123`, `transport/http.py:122-145`, `procurement_mcp/runtime.py:11-22` | **5 copies**, three behavioral variants (see B1.8). |
| **SHA-256 streaming** | `storage/acquisitions.py:61-63`, `:116-118`, `operations/local_import.py:369-378`, `transport/http.py:150,161-163`, `source/extraction.py:357,369` | **5 sites**, each fused with a different integrity contract — less objectionable, but the 1 MiB chunk constant is separately defined four times. |
| **Lock handling** | `storage/acquisitions.py:392-399`, `storage/source_deposits.py:460-467` | **2 near-identical copies**, differing only in message. |
| **Path confinement** | Owned once by `jsonl_engine` (`direct_leaf`, `open_file`, `stat_leaf`, `pin_child`), consistently delegated. `_safety.py` adds archive-member confinement — a different job. | **Clean.** |

Path confinement and HTTP retry policy are each owned once. Generation-currency checking, reparse detection, portable-leaf policy, cancellation shielding, and lease acquisition are re-implemented 2–5 times, and in three of those the copies have **drifted behaviorally**. That drift is the risk, not the line count.

### B2.2 — Against `jsonl_engine`: no re-implementation found

| Job | Owner | Procurement's role |
|---|---|---|
| Atomic no-replace publish | `jsonl_engine.publication` (`publish`, `publish_directory`, `copy_file_no_clobber`) | Consumed at `acquisitions.py:301`, `source_deposits.py:377`, `materialization.py:262,280` |
| Directory pinning | `PinnedPublicationRoot` (`jsonl_engine/publication.py:301`) | `ProcurementRootCatalog` is a *lifetime and namespace* layer over it |
| Inventory building | `jsonl_engine.inventory_catalog.build_inventory` / `discover_article_paths` | `operations/catalogs.py:53,68` delegates directly; the docstring "Delegate named catalog operations to jsonl_engine" (`:35`) is literally true |
| Sentinel validation | `jsonl_engine.kinds.article.ArticleManifest` | `source_deposits.py:116-119` instantiates it; `read_article` (`:135-156`) only wraps errors |
| Article publication | `jsonl_engine.deposit.deposit_article` | `storage/article.py:95`; the local contribution is the **metadata extension** (`:20-78`), a genuine extension point |
| Scratch naming | `jsonl_engine.sidecar.temp_write_path` / `is_transaction_scratch` | `source_deposits.py:293,317`, `extraction.py:356` |
| Deposit slug rules | **procurement** (`domain/deposits.py`) | Not owned by jsonl_engine; no duplicate there |

**CONFIRMED: procurement does not re-implement anything jsonl_engine owns.** Near-miss: `MAX_CATALOG_CHILDREN` is imported (`source_deposits.py:15`) rather than redefined.

### B2.3 — Cross-lane vs `src/logistics/*.ps1`: complementary front-ends onto one engine

**Both lanes publish through the same engine verb.**
- Python: `storage/article.py:10` `from jsonl_engine.deposit import ... deposit_article`, called at `:95`.
- PowerShell: `src/logistics/latex-source.ps1:1247` `Invoke-JsonlEngineCommand -Verb 'deposit'`, inside `Invoke-JsonlEngineArticleDeposit` (`:1187`), composed by `New-LatexSourceDeposit` (`:1378`).

**Both rebuild inventory through the same engine verb.**
- Python: `operations/catalogs.py:68` `build_inventory(...)`.
- PowerShell: `inventory-catalog.ps1` header — *"publish inventory.jsonl through the jsonl_engine `build-inventory` verb. An existing inventory.jsonl is refused unless -Force is set"* — the same force semantics as `catalogs.py:65`.

`article.json` and `inventory.jsonl` have **one shape, owned by jsonl_engine**. **There is no convention conflict to resolve.** CONFIRMED.

Per-file:
- **`latex-source-deposit.ps1`** — a 6-line shim: `. "$PSScriptRoot/latex-source.ps1"`, header *"Compatibility importer… Prefer: . ./src/logistics/latex-source.ps1"*. **Superseded within its own lane.** Destination state: delete once callers move.
- **`inventory-catalog.ps1`** — same job, same verb, same force rule as `ArticleCatalogService`. **Redundant at the capability level**, but it is the PowerShell lane's only path to that verb. Keep only if PowerShell callers must rebuild without a Python runtime.
- **`latex-source-batch.ps1`** — header: *"Discovers arXiv-shaped source archives under a catalog root (loose tarballs or per-child deposits), normalizes each… then runs New-LatexSourceDeposit."* **Complementary, not superseded**: `SourceMaterializationService` consumes *one existing* `acquisition.json` (`materialization.py:70-73`) and cannot ingest a never-receipted tarball. This discovery-and-normalize front-end has no Python counterpart.

**One cross-lane interaction to flag.** `deposit_procurement_article` installs the metadata extension only when a bundle is present:
```
storage/article.py:93        if kwargs.get("metadata_json") is not None:
                  94            kwargs["metadata_extension"] = get_procurement_article_metadata_extension()
```
The PowerShell lane never supplies one, so a PS-minted `article.json` has no `evidence.metadata_resolution` — the exact key `source_deposits.py:215-217` reads to derive the frozen mode. **A PowerShell-minted sentinel is therefore seen by the Python lane as permanently `"omit"`**, and a later `materialize_source_deposit` with `metadata_mode="required"` on that slug fails at `:218-221`. Arguably correct, but an undocumented coupling: the freeze is inherited from whichever lane published first. CONFIRMED.

### B2.4 — Provider adapters: transport factored once; the call wrapper copy-pasted three times

**Factored correctly:** retry, backoff, rate limiting, `Retry-After`, status classification, body capping, and credential redaction live once in `transport/http.py` (`get` `:252-311`, `_bounded_response` `:313-368`, `_retry_after_seconds` `:594-610`, `_evidence_url` `:568-579`). **No per-adapter retry loop exists anywhere.** Paging is genuinely provider-shaped (OpenAlex cursor vs Zenodo page/size vs S2 offset) and correctly not abstracted.

**Copy-pasted — ≥9 identical lines, three times:**
```
openalex.py:91            payload = await self._http.get_json(
            92                f"{self._base_url}/{path.lstrip('/')}",
            93                params=query,
            94                headers=self._headers,
            95                rate_key=self.name,
            96                policy=self._policy,
            97            )
            98            if not isinstance(payload, Mapping):
            99                raise ProviderPayloadError("OpenAlex returned a non-object JSON payload")
           100            return payload
```
```
semanticscholar.py:101            payload = await self._http.get_json(
                  102                f"{base}/{path.lstrip('/')}",
                  103                params=params,
                  104                headers=self._request_headers(),
                  105                rate_key=self.name,
                  106                policy=self._policy,
                  107            )
                  108            if not isinstance(payload, Mapping):
                  109                raise ProviderPayloadError("Semantic Scholar returned a non-object JSON payload")
                  110            return payload
```
```
zenodo.py:132            payload = await self._http.get_json(
         133                url,
         134                params=params,
         135                headers=self._headers,
         136                rate_key=self.name,
         137                policy=self._policy,
         138            )
         139            if not isinstance(payload, Mapping):
         140                raise ProviderPayloadError("Zenodo returned a non-object JSON payload")
         141            return payload
```

**Second block, 5 lines, three times** — `RequestPolicy` construction in `__init__`: `openalex.py:79-83`, `zenodo.py:123-127` (identical), `semanticscholar.py:79-85` (same three kwargs + `backoff_seconds=1.0`, `retry_rate_limits=True`).

**Drift this creates:** Semantic Scholar is the only adapter opting into `retry_rate_limits=True` (`semanticscholar.py:84`), and `composition.py:100-107` rebuilds policies for `PLAN_ARTIFACT` providers **without** carrying `retry_rate_limits` or `backoff_seconds` forward. Adapter-declared and composition-declared policies are two independent constructions of the same object that do not agree on which knobs exist. CONFIRMED.

## B3 — Gap census

### B3.1 — Sci-Hub: declaration-only; the gap is **silent** in `issues/procurement/`

`providers/scihub.py` is 20 lines: `capabilities=frozenset()`, `roles=frozenset({ProviderRole.ARTIFACT_ACCESS})`. No `plan_artifact`, no `get_metadata`, no fetch. `test_composition.py:125` asserts `assertNotIn("plan_artifact", descriptors["scihub"].capabilities)`.

Yet the identity plumbing is built out: `domain/deposits.py:66-69` has a `scihub` branch requiring a complete DOI; `identifiers.py` mints scihub slugs; `test_metadata_service.py:256` and `:344` cover access-only fallback behavior.

**Intended route for a DOI-only paper.** No provider holds `Capability.PLAN_ARTIFACT` for it (`operations/acquisition.py:186` requires it; only arXiv and Zenodo hold it), so `acquire_artifact` is unavailable. The only byte-ingestion path is **`import_local_artifact`** — a human downloads and drops the file in a configured inbox; `prepare_article_metadata_by_doi` supplies bibliography. README line 136 states this: *"A PDF can currently be imported, receipted, and used as the human basis for an explicit DOI lookup."* If the file is a PDF rather than a LaTeX tarball, no `article.json` can be minted (line 137). **CONFIRMED: local_import only; PDF-only stops short of the sentinel.**

**Tracked?** `issues/procurement/` holds exactly three briefs — `arxiv-async/autowake-background-process.md`, `arxiv-async/sockets-httphandler-fetch-engine.md`, `browser-fetcher/playwright-web-acquisition-brief.md`. **No Sci-Hub brief.** Grepping `issues/` returns only prior-generation `.archive/` documents. **Stated in README prose (lines 74-75, 136-139) and in the MCP instructions (`server.py:19`), but untracked.**

### B3.2 — The old PowerShell lane's four capabilities

| Old capability | Python lane status | Stated or silent? |
|---|---|---|
| **Async fetch jobs + status registry** | **Deliberately absent.** README line 96: *"Background jobs remain deferred until the synchronous operations have a separate lifecycle contract."* | **STATED** and **tracked** — both `arxiv-async` briefs ("Status: brief / not built"). Note both describe the **codex-arxiv PowerShell MCP**, not the Python lane, so they document the old design rather than a Python roadmap item. |
| **HTML artifact fetch for arXiv** | **Present, not a gap.** `arxiv.py:338-355` plans `html` against `{artifact_base_url}/html/{id}`; `zenodo.py:344-373` from `files[]`; validated at `operations/acquisition.py:424` → `_validate_html` (`:426-438`). | N/A — see B3.5 for what happens afterward |
| **Crossref / OpenAlex DOI fact-finding** | **Split.** OpenAlex DOI resolution present (`openalex.py:108-121`; `MetadataService.collect_by_doi`). **Crossref has no adapter** — grepping both trees for `crossref` / `api.crossref` / `CrossrefProvider` returns zero hits. | **SILENT.** Crossref appears nowhere in either README, in `configs/defaults.json` provider keys, or in `issues/procurement/`. |
| **Mirror-rotating Sci-Hub fetch** | Absent (B3.1). | **STATED in README prose, SILENT in `issues/`.** |

### B3.3 — TODO / FIXME / HACK / XXX / REVIEW

**Zero across both trees.** Grepping `src/procurement` for `TODO|FIXME|HACK|XXX|REVIEW|NotImplemented|deferred|not yet` returns two hits, both README prose (`README.md:96`, `:137`). `src/mcp-servers/procurement_mcp` returns **no matches at all**. The only in-code markers are three `# pragma: no cover` on genuinely closed branches (`operations/acquisition.py:212`, `materialization.py:102`, `source_deposits.py:185`), each with a one-line justification. CONFIRMED clean.

### B3.4 — Dead surface: none in either direction

**Capabilities → tools.** Checking `providers/catalog.py:18-25` against the registered 16:

| Capability | Reachable via |
|---|---|
| `SEARCH` | `discover_search` |
| `GET_WORK` | `get_work` |
| `CITATIONS` / `REFERENCES` / `RECOMMENDATIONS` | `discover_related` |
| `RESOLVE` | `resolve_reference` |
| `METADATA` | `prepare_source_deposit_metadata` |
| `PLAN_ARTIFACT` | `plan_artifact_acquisition`, `acquire_artifact` |

**No capability is unreachable.** CONFIRMED.

**Tools → `None` services.** `composition.py:145-155` wires all four optional services non-`None`:
```
151            acquisition=acquisition_service,
152            local_import=local_import_service,
153            catalogs=catalog_service,
154            materialization=materialization_service,
```
`ProcurementApplication` declares them `| None = None` (`application.py:27-30`) only to permit injected/partial applications (as `test_registration.py:187` does). **In the default composition no tool has a `None` backing service.** The `is None` guards are defense against injection, not dead surface.

The one dead-ish thing: `providers/scihub.py` declares `capabilities=frozenset()` — a pure identity record with no reachable operation, by design (`test_composition.py:104,125`).

### B3.5 — `ArtifactKind`: three forms, all plannable, one with no consumer

`ArtifactKind = Literal["source", "pdf", "html"]` (`planning.py:21`); `PayloadKind = Literal["gzip", "pdf", "html"]` (`:22`).

| Provider | source | pdf | html |
|---|---|---|---|
| **arXiv** (`arxiv.py:296-355`) | ✅ two candidates | ✅ one candidate | ✅ one candidate (`else` branch `:338-355`), planned unconditionally |
| **Zenodo** (`zenodo.py:292-373`) | ✅ | ✅ | ✅ — all conditional on a `files[]` match; absence/ambiguity → `UnavailableArtifact` (`:294-310`) |
| OpenAlex / Semantic Scholar / Sci-Hub | — | — | — (no `PLAN_ARTIFACT`) |

**No form is advertised but unplannable — but `html` is terminal.** Once acquired and receipted it goes nowhere:
- `SourceMaterializationService._forms` (`materialization.py:142-152`) requires `source` (`:143-146`) and tolerates only an optional `pdf` (`:149-151`). An `html` form is silently ignored.
- `LocalImportService._classify` (`local_import.py:313-318`) accepts only `%PDF-` and gzip magic; **HTML cannot be locally imported at all** — an asymmetry between the two ingestion routes.
- `_FORM_ORDER` (`storage/acquisitions.py:25`) does include `"html": 2`, so it is a first-class receipt form.

`html` is acquirable, receiptable, ordered — then inert. Whether that is staging for a future profile (parallel to the stated PDF-profile plan) or a dangling form is not settleable read-only. **The README never mentions `html` at all.** That silence is the reportable part.

---

## Reconciliation — what changed between lanes

**R1 — `source/_safety.py` depth upgraded (lane A finding #7).** Lane A recorded it as via-service-only. Lane B's call-graph read refines this: `_portable_relative` / `_portable_leaf` **are** driven directly through `extraction.py:156` by `test_source_extraction.py:289` and `:336` (twelve invalid-path subtests plus four collision cases), and `_plain_directory` / `_regular_file` happy paths are driven through the unpinned entries at `extraction.py:278,280`, `latex.py:316`, and `tree.py:251`. **Only the reparse/symlink *rejection* branches (`_safety.py:75,94`) are unwitnessed**, and only because the tests that would drive them are the silently-skipped ones at `test_local_import.py:186-199`. Net: the module is better covered than lane A implied; the residual gap is narrower and sharper.

**R2 — `domain/deposits.py` severity raised (lane A finding #11).** Lane A listed the untested `validate_deposit_slug` at position 11 of 13. Lane B §B1.9 shows it is the **single guard** stopping `..`, `CON`, and trailing-dot names on all seven client-supplied MCP slug routes, with eleven enforcement sites across five modules — and that the MCP layer above it deliberately does not enforce the equivalent. An untested guard carrying that much load belongs **above** the `download_to` pre-flight guards. Revised priority: this is the highest-value coverage gap in the review.

**R3 — `finish_sync` cancellation gap narrowed but sharpened (lane A finding #6).** Lane A reported the MCP shield as an untested re-implementation of a capability-layer guarantee. Lane B found **four more** shields of the same shape, and the three capability-layer ones **are** tested (`test_acquisition.py:916`, `test_local_import.py:227`). So the untested one is `runtime.py` alone — and it is the variant that catches `except Exception` (`:20`) where `operations/acquisition.py:123` catches `except BaseException`. The gap is smaller than lane A implied and more specific: it is the one copy whose catch clause differs from its siblings.

**R4 — the six never-invoked MCP tools matter more than lane A said (finding #4).** Lane A noted the coverage gap neutrally. Lane B §B3.4 establishes that `plan_artifact_acquisition` and `acquire_artifact` are the **only** reachable route to `Capability.PLAN_ARTIFACT`, held by both artifact providers. These are not speculative surface — they are the sole protocol path to the acquisition capability, and no test drives them end-to-end.

**R5 — a new coverage gap surfaced by lane B, added as lane A finding #13.** `HttpClient.get`'s redirect behavior is untested entirely: all three redirect tests (`test_acquisition.py:585,618,642`) target `download_to`. Lane B §B1.5 shows `get` runs with `follow_redirects=True` and no host or scheme check, so the untested path is also the unconfined one.

**No lane-A finding was withdrawn.** Findings #1, #2, #3, #5, #8, #9, #10, #12 stand unchanged, and lane B independently confirmed the `content-encoding` truncation bypass that lane A had flagged only as untested (§B1.6).

---

## Questions for the primary

**From lane A (coverage and skips)**

1. **Is the silent-fallback test pattern intentional?** `test_acquisition.py:842-847`, `test_local_import.py:317-322`, and `test_local_import.py:186-199` degrade to a happy-path assertion on Windows without emitting a skip, while `test_materialization.py:510` handles the identical situation by asserting the Windows outcome. If the materialization form is house style, three tests need conversion. Highest-value finding in lane A; it is a policy call, not a fact.
2. **`test_acquisition.py:755` — does it run or escape here?** My reading is that the item directory is not yet pinned when the mocked `pin_child` renames it, so `swapped` should be `True` and the real assertion should fire. Not settleable read-only; a one-line probe would.
3. **Should the junction technique (`test_inventory_catalog.py:48`) be extended?** It proves reparse coverage is achievable without privilege on this host. Extending it to `_safety.py:75,94` and the five unwitnessed `jsonl_engine` reparse checks looks cheap, but it is a scope decision.
4. **Were the six never-invoked MCP tools deliberately registration-only?** See R4 — they are the only route to `PLAN_ARTIFACT`.
5. **Was `download_to`'s guard set (`http.py:408-422`) meant to be contract-tested, or is it defense-in-depth behind `composition.py`?** The empty-`allowed_hosts` case disables host confinement outright.

**From lane B (claims, duplication, gaps)**

6. **Is the `contracts.py` `DepositSlug` divergence deliberate?** No traversal is reachable, but the server advertises `PORTABLE_LEAF_PATTERN` and enforces a weaker regex. Tightening `StringConstraints(pattern=...)` costs nothing behaviorally. Was the loose pattern chosen so errors surface from the domain layer rather than pydantic?
7. **Should `HttpClient.get` be redirect-confined too?** README line 91 reads as a transport-wide guarantee but is only true of `download_to`. `follow_redirects=True` at `http.py:242` plus no scheme check at `:273` means metadata requests — carrying `api_key` as a query parameter for OpenAlex (`openalex.py:89-90`) — follow redirects unconstrained. Scoping bug in the prose, or a missing guard?
8. **Is the `content-encoding` truncation bypass intended?** `http.py:503` skips `declared_length` for compressed responses, disabling the truncation check at `:532` (the cap still holds). Deliberate, because Content-Length describes compressed bytes — or an oversight?
9. **Which of the five cancellation shields is canonical?** All settle correctly, but they differ in three ways: `BaseException` vs `Exception`, dedicated vs default executor, and the `while True` re-await variant unique to `http.py:126-145`. Consolidating would also close the `_require_current` ×4 and `_same_directory_generation` ×3 duplication in the same pass.
10. **The `_is_reparse` divergence is the one duplication I would call a latent bug.** `acquisitions.py:28-29` and `_safety.py:25-26` check only the Windows attribute bit; `source_deposits.py:35-38` and `local_import.py:288-291` also check `S_ISLNK`. Call sites `acquisitions.py:99` and `:358` use the attribute-only version without a separate `S_ISLNK` test. Is a POSIX symlink there excluded by an upstream guard I did not find, or is that a hole?
11. **What is `html` for?** Both artifact providers plan it, the receipt orders it, nothing consumes it, and the README never mentions it. Staging for a future profile, or a form to remove from `ArtifactKind` until it has a consumer?
12. **Should Crossref and Sci-Hub get tracked briefs?** Both absences are real; both are stated only in README prose. `issues/procurement/` currently holds three briefs, all describing the **old codex-arxiv PowerShell MCP** rather than the Python lane — so the Python lane's own deferrals have no tracker at all.
13. **`latex-source-batch.ps1` has a capability the Python lane lacks** — discovering and normalizing loose, never-receipted tarballs into deposit shape. `SourceMaterializationService` requires an existing `acquisition.json`. Is a "receipt an already-present tarball" path planned, or is the PS batch script the permanent home for that job?
14. **The PS-lane / Python-lane metadata-mode coupling:** a PowerShell-minted `article.json` carries no `evidence.metadata_resolution`, so `source_deposits.py:215-217` freezes it as `"omit"` permanently. Intended, or should the freeze distinguish "published without metadata" from "published by a lane that cannot emit metadata"?
15. **Are `catalog_directory` fields intentional outbound disclosure?** `contracts.py:41,54` return host paths to the client, while `LocalImportInboxCatalog` deliberately withholds them (`test_local_import.py:357` asserts the inbox path never appears in the schema). Deliberate asymmetry?

**Scope note**

16. `tests/jsonl_engine/` was in scope for witnessing procurement behaviors, but I audited only the seven files reachable from the skip list and the materialization path — not its 152 tests on their own terms. Say the word if the primary wants that tree censused too.

---

# Primary-agent addendum — triage, verifications, and verdicts

*Appended by the primary review agent after independent verification. agy worked read-only; the
primary ran the suite, probed pin semantics empirically, and spot-verified the sharpest claims.*

## Corrections to agy findings

- **Q10 `_is_reparse` divergence — REFUTED as a latent bug; stands as consolidation hygiene.**
  The upstream guard agy hypothesized exists, twice over. `stat_leaf`/`stat_path` resolve through
  jsonl_engine's `os.stat(..., follow_symlinks=False)` (`src/jsonl_engine/publication.py:804-805`),
  so at `acquisitions.py:99`/`:358` a POSIX symlink presents `S_ISLNK` mode and fails the paired
  `not stat.S_ISREG(...)` clause before `_is_reparse` is consulted; file opens additionally use
  `O_NOFOLLOW` (`publication.py:948`) with dev/ino identity cross-checks (`acquisitions.py:106-115`).
  No reachable hole. The four divergent copies remain worth consolidating so the invariant is
  self-evident rather than emergent.
- **A1 #1 / Q5 phrasing — "empty `allowed_hosts` disables host confinement" is wrong as written.**
  `http.py:413-414` refuses an empty set (`download_to requires at least one allowed host`), and
  `RetrievalCandidate.allowed_hosts` carries `min_length=1` at the contract. The correct finding is
  narrower: the guard exists and is untested.

## Empirical settlements (pin-semantics probe, this host)

Probe: pin a staging root via `PinnedPublicationRoot`, then rename (a) an unpinned child and (b) the
pinned root itself. Result: child rename **succeeds**; root rename **blocked**.

- `test_acquisition.py:755` therefore takes `swapped=True` and **its real assertion runs on
  Windows** — agy's Q2 hypothesis confirmed, test is healthy.
- `test_acquisition.py:802` (both subtests) and `test_local_import.py:281` rename pinned targets and
  are **confirmed inert on Windows**, as agy found. With `:186-199` (symlink cases), the
  silent-fallback set is exactly three tests, not four.

## Verdicts on the open questions

| Q | Verdict |
|---|---|
| 1 | Real defect class. Convert the three inert tests to the `test_materialization.py:510` pattern (branch on `os.name`, assert the Windows outcome positively). |
| 2 | Settled healthy (probe above). |
| 3 | Yes — extend the junction technique to `_safety.py:75,94` and the five unwitnessed jsonl_engine reparse checks; it is the only way this host ever executes those branches. |
| 4 | Add at least one protocol-path test driving `plan_artifact_acquisition`/`acquire_artifact` against an injected provider — they are the sole route to `PLAN_ARTIFACT`. |
| 5 | Guards exist (correction above); add the five cheap contract tests. |
| 6 | Tighten `contracts.py` `DepositSlug` `StringConstraints` to `PORTABLE_LEAF_PATTERN`. Costless, makes the advertised contract honest; domain guard stays as depth. |
| 7 | Both: re-scope the README sentence to downloads, and add a cheap https-or-loopback check to `HttpClient.get` for non-loopback hosts. The OpenAlex `api_key` query parameter (`openalex.py:89-90`, confirmed) makes unconfined metadata redirects worth closing even if practical exploitability is low. |
| 8 | Recommend refusing `content-encoding` on artifact `download_to` responses outright — artifact routes serve opaque binaries, and refusal makes the truncation check universal. |
| 9 | Consolidate the five shields into one helper (natural home: a small `procurement/concurrency.py` or the transport module), adopting `BaseException` catch semantics; fold `_require_current` ×4 and `_same_directory_generation` ×3 into shared primitives in the same pass. |
| 10 | Refuted as bug (above); consolidate for legibility only. |
| 11 | `html` reads as deliberate staging for the future HTML/PDF profile family, but the README's total silence on it is a documentation gap — one sentence fixes it. |
| 12 | Yes: mint `issues/procurement/` briefs for the Sci-Hub DOI-access route and the Crossref resolver so the Python lane's deferrals are tracked somewhere other than prose. The three existing briefs all describe the retired PowerShell MCP. |
| 13 | User decision. Note the capability precisely: batch ingestion of never-receipted tarballs lives only in `latex-source-batch.ps1`; a Python "receipt an already-present tarball" path would subsume it. |
| 14 | Document the coupling (PS-minted sentinel freezes as `omit` forever). The behavior is arguably correct; the surprise is the silence. |
| 15 | Low risk on a local single-user MCP; recommend either aligning catalog responses with the inbox no-paths convention or recording the asymmetry as deliberate. |
| 16 | Declined for this review; jsonl_engine deserves its own pass. |

## Primary-agent findings outside agy's lanes

- **Environment: `C:\Users\azrie\AppData\Local\Temp\pytest-of-azrie` is ACL-poisoned** (WinError 5
  on mkdir). Bare `pytest` fails 273 tests at setup on this machine; the green run required
  `--basetemp`. Until the directory is deleted/repaired, every agent and human here will see a
  phantom-red suite. Suggested fix (user to run): remove that directory, or export
  `PYTEST_ADDOPTS=--basetemp=<repo>\scratch\pytest-tmp` in the user environment.
- **Suite ground truth (this review, 2026-08-13): 429 passed / 10 skipped / 140 subtests, 34.8s,
  exit 0** with `--basetemp scratch\procurement-review\pytest-tmp`.
- **MCP registration is pending**: `scientiae-procurement` has a pyproject entry point and README
  run instructions but no entry in `.mcp.json` (which currently holds only para-agent) nor in
  user-level config. Presumed deliberate mid-migration; flagging so it lands on a checklist.
- **Stale editable-install residue**: `src/procurement/__pycache__/` still holds `models` and
  `payloads` bytecode from the pre-split monolith (git-ignored, harmless; delete at leisure).
- **Config asymmetries (minor)**: `LocalInboxSettings.name` is slug-validated while
  `CatalogSettings.name` is not; inbox-name uniqueness is enforced in both the model validator and
  composition, catalog uniqueness only in composition. `DiscoveryService.related` hardcodes
  `"openalex"`/`"semanticscholar"` defaults rather than deriving from configuration.
- **Old-lane retirement is complete**: no `arxiv.ps1`/`scholar-*`/`scihub-get.ps1` under `src/`,
  no `_inbox` references anywhere, `ingestion/{staging,imports,inventory}` coherent end-to-end.

## Recommended action order

1. Convert the three silently-inert tests (Q1) and add the junction-based reparse witnesses (Q3).
2. Tighten `DepositSlug` (Q6) and directly test `validate_deposit_slug` (report R2).
3. Confine or re-scope `HttpClient.get` redirects (Q7); refuse artifact `content-encoding` (Q8).
4. Consolidate shield + currency + reparse + portable-leaf primitives (Q9/Q10).
5. Protocol-path tests for the acquisition tools (Q4) and `download_to` pre-flight guards (Q5).
6. Mint the Sci-Hub and Crossref deferral briefs; add the `html` sentence to the README (Q11/Q12).
7. Register `scientiae-procurement` in `.mcp.json` when ready; fix the poisoned pytest temp dir.
