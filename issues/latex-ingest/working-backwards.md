# i think the way to investigate things like this are to work backwards from various late stage steps that are trying to post-hoc resolve something or fix something and trace backwards asking the question if this check should even be necessary if the pipeline were to address the underlying issue upstream and make it a non-issue downstream. kind of an abductive reasoning proble

The method pays off immediately. Tracing back from the sentinel:

**Observation:** md-bundle counts surviving `@@…@@` in shipped markdown.

**How could one survive?** `Restore-LatexMath` has exactly two exits, and both are silent:

```powershell
for ($pass = 0; $pass -lt 8 -and ($Text -match '@@L(?:MATH|DISP)\d+@@'); $pass++) {
    $Text = [regex]::Replace($Text, '@@L(?:MATH|DISP)\d+@@', { param($m)
        if ($script:LtxMathStore.Contains($m.Value)) { $script:LtxMathStore[$m.Value] } else { $m.Value } })
}
return $Text
```

Nesting deeper than 8 → loop exits with placeholders intact. Placeholder not in the store → left verbatim. Either way the function returns as if it succeeded.

**Is either cause inherent?** No. Both are invariants of a store _this code entirely controls_ — it created every placeholder and knows the nesting depth. Nothing about author LaTeX forces a leak.

**So it's category 1: removable.** And the sharpest part — **the function already knows it failed.** Its own loop condition is evaluated on exit; if placeholders remain after 8 passes, `$Text -match '@@…@@'` is still true at that moment. The information exists and is discarded, and then reconstructed 400 lines downstream by counting the damage in the output.

The fix is a few lines at the restore boundary: if placeholders remain, that's a converter bug — throw, or flag it into the run record. The downstream sentinel then becomes what it should have been, a backstop against "impossible," rather than the primary detector.

Worth noting the scope is wider than this one function: there are **five placeholder families** — `ALG`, `VERB`, `LMATH`/`LDISP`, `FIGSLOT`, `EPSSLOT` — each created by its own store, and I've only traced one restore path. None of them has a completeness check that I found. Same trace on the other four is the obvious next step, and I'd expect the same answer, though I haven't verified it and shouldn't assume.

Your framing generalizes past this too: **a guard is evidence about its upstream.** When the upstream cause is internal state the pipeline owns, the guard is misplaced detection. When it's genuinely external — malformed author input, a missing figure file — it's real defense and belongs where it is. That's a clean discriminator, and unlike my regex scan it gives an answer you can act on rather than a list to eyeball.

Want me to take the restore-boundary assertion and trace the other four families? It's small, and it converts the sentinel from primary detection into a backstop — which is the shape you want before the sentinel gate gets rebuilt into the standalone lane.

---

# Not so fast. Malformed author is a property of the source. We don't need to wait until markdown to detect or handle that. Trace the others and then lets collect into another brief under latex-ingest issues

Written to [issues/latex-ingest/guards-and-placeholders-20260731.md](issues/latex-ingest/guards-and-placeholders-20260731.md), committed as `fd2ad0b5`.

## The finding the trace produced

All five placeholder families restore the **same wrong direction**:

```
ALG      foreach ($id in $script:AlgStore.Keys)  { $T.Replace($id, …) }
VERB     foreach ($id in $script:VerbStore.Keys) { $T.Replace($id, …) }
FIGSLOT  foreach ($j in $pdfJobs)                { $Markdown.Replace($j.ph, …) }
EPSSLOT  foreach ($j in $epsJobs)                { $Markdown.Replace($j.ph, …) }
LMATH    bounded 8-pass regex loop, store lookup per hit
```

Every one is **store-driven** — it establishes _"every stored item was written out."_ The invariant that matters is **text-driven** — _"no placeholder remains."_ Those aren't the same statement, and store-driven restoration is structurally blind to the gap: a placeholder in the text but missing from its store is never visited, never replaced, never reported.

Which means the md-bundle sentinel is **the only text-driven check in the entire pipeline**, and it's at the very end. That's not five bugs, it's one direction error repeated five times, with the detection displaced to the last possible moment.

Two extra silent exits on top: `Restore-LatexMath` bounds at 8 passes and falls through on a store miss — **and its own exit condition already evaluates the failure**, then discards it and returns success. `FIGSLOT`/`EPSSLOT` restores sit inside blocks gated on the render harness, so a false guard leaks every slot at once.

## On your correction

It changed the brief's structure, not just a sentence. I'd written three dispositions with "legitimate late defense" as a real category; your point collapses it to two — _detected when knowable_, or _detected later than knowable_ — and the origin of the fault is irrelevant. That's what makes the method decidable rather than a judgement call, so it's stated as §1.1 rather than buried.

I also recorded the mechanical sweep's results in §5 with its reach explicitly bounded, so nobody redoes it: 51 source-directed vs 0 output-directed body mutations, `md-cleanup.ps1` dead with zero callers, and the `Build-LabelMaps` overwrite invisible to all of it.

§4 lists the next guards worth the same treatment. The first is one I wrote today — `if ($at -lt 0) { continue }` in the subject index — which is a defensive skip standing in for the question "why could this lookup fail?" Fresh specimen of the exact habit.
