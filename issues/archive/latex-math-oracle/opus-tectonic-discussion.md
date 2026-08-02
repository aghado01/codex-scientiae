so im curious to understand tectonic option better. its free and its about latex->pdf. it would seem to upend some of my current dependencies but also how does it work for my purposes

Good question to dig into before committing the brief's "open decision." Let me ground it in what you actually have rather than talk in generalities — checking your current render dependency and whether any TeX engine is already on PATH.

Checked for existing TeX engines and current render dependency
Grounding fact first, because it reframes the whole question: you have no TeX engine at all right now — no tectonic, no pdflatex, no xelatex. Your only diagram renderer is node-tikzjax, a WASM TeX that does tikzpicture/tikzcd and nothing else. So tectonic wouldn't be replacing a working LaTeX compiler; it'd be giving you your first one. That changes "upends my dependencies" from swap to fill a hole.

How tectonic works
Four mechanisms, and the second and third are the ones that make it fit a vendored-portable repo:

Single self-contained binary (Rust, ~tens of MB). No sprawling install tree. tectonic doc.tex → doc.pdf. It's the whole toolchain in one file.
XeTeX engine under the hood — not pdfTeX. Unicode/OpenType-native. This is the one caveat, below.
On-demand package fetching from a "bundle." Instead of a multi-GB TeX Live, tectonic ships with a pointer to a bundle = a frozen TeX Live snapshot. The first time a document \usepackages something, tectonic pulls just that package from the bundle into a local cache; every compile after is offline from cache. The bundle being a pinned snapshot is what makes builds reproducible.
Auto multi-pass. It reruns itself to resolve references/TOC — no latexmk, no "run it twice" dance.
It's MIT-licensed, free, and has Windows binaries (cache lands under %LOCALAPPDATA%).

How it slots into your pipeline
It's the "LaTeX compiler" my oracle-images brief left as the open decision, and it's complementary to MuPDF, not competing with it:

extract diagram env (+ replayed preamble/macros) → tectonic → cropped PDF → MuPDF-WASM → PNG
Tectonic does compile (LaTeX→PDF); MuPDF-WASM (already vendored, used by the pig lane) does rasterize (PDF→PNG). One compile path + one raster path handles every diagram type uniformly — tikz, tikzcd, xy-pic, pstricks, chemfig — plus \includegraphics of EPS/PDF assets (tectonic compiles those in). That's exactly the xy-pic gap and the PNG-everywhere requirement, solved by one engine instead of a per-package zoo.

What it upends
before after
removes the need for a full TeX Live (which you don't have; painful on the fragile portable env) —
retires (optionally) node-tikzjax as the diagram renderer tectonic subsumes it — renders tikz and everything tikzjax can't
adds — vendored tectonic binary + a local bundle (a .tar of the frozen TeX subset)
Vendoring the binary + a local bundle is the same pattern as your PdfPig DLLs and the MuPDF WASM — so it fits the portable philosophy rather than fighting it. You'd likely keep tikzjax only as a zero-network fallback, and even that becomes redundant once the local bundle makes tectonic offline too.

The one real caveat — XeTeX vs pdfTeX
Your papers are pdfTeX-origin (Producer strings, per the pig recon), and tectonic is XeTeX. For your actual use case this barely matters: you're compiling standalone snippets (just the diagram env), and tikz/xy/commutative-diagram packages are engine-agnostic — they render identically under XeTeX. Where the difference would bite is if you later tried whole-paper render-back (compile the entire source → PDF → diff against the real PDF, the falsifiability gate the pdfdig/mathdig briefs park). There, pdfTeX-native TeX Live would reproduce the original more faithfully. So: tectonic is the clean choice for diagram → PNG; revisit the engine question only if/when you want full-paper render-back.

And for determinism (your regenerable-everything ethos): default tectonic fetches over the network, which is neither offline nor reproducible. Point it at a local bundle (--bundle <local.tar> or a Tectonic.toml) with a pre-warmed cache, and it becomes both — the config that belongs in a codex vendored tool.

Bottom line
For "render every LaTeX diagram to PNG faithfully, offline, reproducibly," tectonic is a strong fit and lighter than the TeX Live alternative — a single vendored binary + local bundle, feeding your existing MuPDF rasterizer. Its only asterisk (XeTeX) is irrelevant to snippet rendering and only surfaces if you later chase whole-paper render-back.

Want me to fold this into the oracle-images brief — resolve the "open decision" toward tectonic with the local-bundle/vendoring plan and the XeTeX-caveat scoped to snippet-only — so the decision's recorded when you circle back to that lane? I'd leave it as your call to actually vendor it.

what confuses me is that we are going from latex to PDF when i thought the whole advantage of latex was avoiding the PDF intermediary entirely to get to the end goal of a markdown math faithful document. i worry that the tectonic route corrupts my oracle

That worry is exactly the right one to hold onto — oracle integrity is the whole game — but it rests on a conflation worth pulling apart, because once you see the split, tectonic lands on the safe side of the line you're protecting.

Two populations, two paths — and they never mix
A LaTeX paper isn't one kind of content. It's two, and "avoid the PDF" is true for one and meaningless for the other:

1. Math, prose, structure — the text-native content. $E = mc^2$, \begin{equation}, \section{}. This has a faithful markdown-text form, so the oracle transcribes it source → markdown, directly, no PDF, no rasterization. This is what "avoid the PDF intermediary" is about, and tectonic never touches it. Your architecture already enforces this split: latex-ingest.ps1 does the text transcription; tikz-render.ps1 is a separate shim that only ever sees diagram environments. Tectonic replaces the shim, not the transcriber.

2. Diagrams — tikzpicture, xymatrix. A commutative diagram is a picture. Markdown has no syntax for "arrow from A to B, curving, labeled f." There is no faithful markdown-text form for it. So it has exactly three fates in your output: dropped (today's xy-pic behavior — silent loss), rendered to an image, or... nothing else. Rendering is not a corruption you're introducing; it's the only faithful option for content that was never text to begin with. And you already do it — tikzjax renders tikz to SVG right now.

The line between the two populations is precisely: "does markdown have a faithful text form for this?" Math: yes → transcribe (no PDF). Diagram: no → render (image). Tectonic only ever operates below that line.

Why this isn't the lossy cliff pdfdig fights
The thing pdfdig battles is pixels → meaning — decompiling an already-rendered PDF back into structure. That's lossy because structure was destroyed in rendering. Tectonic runs the opposite direction: meaning → pixels, compiling source forward. In your own inflection-point framing, forward rendering is the information-monotone direction. And rasterizing a diagram loses nothing markdown could have kept, because a picture has no markdown-representable structure to lose in the first place.

The proof that this principle is sound: you'd never render the equations to images — because equations do have a text form, and imaging them would throw away searchable, AST-able structure. And the oracle doesn't. Same rule, applied consistently, sends math to transcription and diagrams to rendering.

The one way tectonic could corrupt the oracle — and the invariant that forbids it
Your instinct is protecting against a real failure mode, just a different one: scope creep. If someone ran tectonic on the whole paper → PDF, then extracted markdown from that PDF, that would corrupt the oracle — you'd be running pig-style decompilation on the oracle's own output and discarding the source-faithful transcription. That is the thing to never do.

So the boundary to write into the brief as a hard invariant:

Tectonic renders extracted diagram snippets to images, and its output feeds only the image slot. It never touches the text/math transcription path, and diagram PNGs never round-trip back into the markdown body text. The math oracle stays source → markdown, forever.

With that boundary, tectonic is architecturally incapable of reaching the content you're worried about.

And the reframe that should settle it
Right now your oracle silently drops all 11 xymatrix diagrams from 2210's ground truth. That is a corruption of the oracle today — missing content masquerading as complete. Tectonic doesn't add a lossy step; it fixes an existing one, by rendering the diagrams your only current engine can't. Faithfulness goes up, not down.

(One nuance for completeness: a subset of diagrams — grid-like commutative diagrams — could someday be transcribed as text-native math (mathjax \begin{CD}/structured) rather than imaged, which would be even more faithful for that subset. But that's the deferred 2-D-structure frontier, and it's pdfdig/mathdig's geometry work, not the oracle's. Image-now for the genuinely-pictorial majority; transcribe-maybe-later for the arrays. It's not a reason to withhold tectonic.)

Want me to fold the two-populations framing and that boundary invariant into latex-oracle-images.md, so the "why rendering doesn't corrupt the oracle" reasoning is preserved alongside the tectonic decision?
