# Codex Scientiae - Repository of Bound Knowledge

This repository contains structured corpora of long-form reference material.
Each collection should be entered from its local `CONTENTS.md` file when one exists.
This README is only the top-level map; deeper chapter and section navigation lives inside each collection.

## Core concepts

### The target audience

The goal of codex-scientiae is to bind knowledge reproducibly and reliably in a format and encoding that is optimised in various ways for LLM consumption, to enable effective, token efficient, high-capacity reasoning over mathematically and scientifically dense subject matter in order to drive accurate implementation and synthesis in other projects. In particular, adapting cutting-edge work that will often be published after training cut-offs of models.

### The Math Channel

Also known as the "math register" — the currently under-specified notion of a lexically invariant, renderable (Katex), standard that is targeted and which all ingestion workflows converge on for capturing math semantics in markdown deliverables that would be consistent across document sources. The purpose of this canonicalization is to enable highly consistent tokenization of mathematical detail for any given model across documents by mapping variable source encodings to a single convergent standard, including mapping glyphs to katex control sequences and standardizing katex control sequences and syntax.

Its an evolving target spec that is being developed iteratively in the living document `issues/math-register/math-register-spec.md`. Preferred nomenclature is currently fluid, but the concept, goal and purpose is what is important.

### The Latent Manuscript

A core thesis of codex-Scientiae and its document ingestion workflows is that variable research publication source materials (across publishers, standards, formats) can be surjectively mapped to a canonical universal latent manuscript archetype. The latent manuscript can be viewed abstractly as a graph, with projections as a tree, with the reading order of the document determining a specific sequential traversal of the graph. The concept is still under development, but with an emerging spec that informs current and future development in this project.
