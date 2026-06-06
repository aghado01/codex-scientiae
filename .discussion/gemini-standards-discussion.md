## Standard

wrap=none: This is the most important flag for RAG/LLM ingestion. By default,

Format gfm over markdown: GitHub Flavored Markdown guarantees that the code blocks (which will contain all your Lean 4 syntax) are fenced with standard triple backticks, and that tables are rendered cleanly. Standard Markdown often falls back to 4-space indentation for code, which can cause parsing errors when building your prompt contexts.

## Advanced math expressions

You are absolutely right. When you cross the threshold into advanced mathematics, standard plain text and basic Unicode completely fall apart. You _need_ a specialized typesetting engine like LaTeX or KaTeX to preserve structural rigor and prevent ambiguity.

Standard text is fundamentally one-dimensional. It evaluates left-to-right. But complex math—like multiline integrals, nested sums, or information geometry metrics—is inherently two-dimensional. It relies on spatial hierarchy to communicate scope and bounds.

If you try to flatten a complex expression into standard text, you end up with an unreadable, deeply nested nightmare of parentheses. For example, trying to read or write a core theorem in flat text is a great way to introduce parsing errors for both humans and machines. But when you use proper mathematical syntax, the structural meaning becomes explicitly clear:

$$\int \!\!\! \int_D \left( \frac{\partial Q}{\partial x} - \frac{\partial P}{\partial y} \right) dx dy = \oint_{\partial D} (P dx + Q dy)$$

This is the exact same principle that applies to building a robust AST for structured document ingestion or an interval algebra engine. If your semantic model tries to treat a block of equations as standard text, it goes structurally blind. The grammar of the representation has to strictly enforce the bounds of the operation, otherwise the meaning is lost in the translation. You need that unambiguous rigor whether you are rendering it visually for human eyes with KaTeX, or verifying the underlying logic with a formal theorem prover.

### The Renderer vs. The Syntax

It helps to draw a sharp line here: **KaTeX is a rendering engine, not a syntax standard.** KaTeX simply takes standard LaTeX string literals and paints them onto an HTML canvas for human eyes.

But your LLM doesn't have eyes. It doesn't read the rendered pixels of a fraction; it reads the underlying text tokens.

For an LLM audience—whether it's me, GPT-4, or Claude—the undisputed, native tongue of mathematics is **Standard Markdown enriched with raw LaTeX math environments**.

Specifically, you want the **`tex_math_dollars`** extension standard, which uses single dollars for inline math and double dollars for display blocks:

- **Inline:** `Let $x$ be a continuous variable...`
- **Block:** ```markdown
  $$ \int_a^b f(x) dx = F(b) - F(a)$$

```


```

Here is why this is the absolute ideal standard for your `codex-scientiae` corpus.

### 1. The Training Distribution

LLMs are heavily trained on ArXiv preprints, Jupyter Notebooks, and GitHub repositories. In all three of those domains, math is explicitly encoded using `$` and `$$` delimiters wrapping standard LaTeX commands. When you feed an LLM a prompt containing `\frac{\partial}{\partial x}`, it mathematically "understands" the relationship between the numerator and denominator precisely because it has seen that exact syntax sequence millions of times across advanced physics and computer science datasets.

### 2. Token Efficiency

LaTeX is incredibly dense. If you try to represent a matrix using HTML tables or ASCII art, you waste hundreds of tokens on structural formatting (like `<tr><td>` or spaces/pipes), which dilutes the semantic weight of the context window.

A LaTeX matrix is lightweight and structurally unambiguous to the model:
`\begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix}`

### 3. Avoiding KaTeX-Specific Macros

Because KaTeX is designed for the web, it supports several non-standard macros and HTML-injection commands (like `\htmlClass` or specific color styling) that are irrelevant to the underlying math. You want to strip all of that out. The LLM does not care if the integral sign is rendered in blue; it only cares about the bounds of the integration. Pure LaTeX syntax keeps the corpus semantically clean.

### Configuring Pandoc for the Math Standard

Since you are using Pandoc in your PowerShell ingestion pipeline to build `codex-scientiae`, you need to ensure it treats math correctly. Pandoc is brilliant at identifying math embedded in HTML (whether it was rendered by MathJax, KaTeX, or native MathML) and converting it back into raw LaTeX strings for the Markdown output.

To guarantee you get the LLM-friendly `$` and `$$` syntax, you should configure your Pandoc format string in your script like this:

`gfm+tex_math_dollars`

This tells Pandoc: _"Output standard GitHub Flavored Markdown, but when you encounter mathematical structures, do not try to approximate them with Unicode text. Wrap them in raw LaTeX dollar signs."_

If you standardize your `codex-scientiae` pipeline around `gfm+tex_math_dollars`, you are serving the math to the LLM exactly how it expects to read it, preserving all of the two-dimensional spatial rigor without sacrificing any token efficiency.

What is the primary source of the math you are pulling into the corpus right now? Is it mostly coming from rendered HTML documentation, or are you pulling in raw LaTeX files directly?

### The Renderer vs. The Syntax

It helps to draw a sharp line here: **KaTeX is a rendering engine, not a syntax standard.** KaTeX simply takes standard LaTeX string literals and paints them onto an HTML canvas for human eyes.

But your LLM doesn't have eyes. It doesn't read the rendered pixels of a fraction; it reads the underlying text tokens.

For an LLM audience—whether it's me, GPT-4, or Claude—the undisputed, native tongue of mathematics is **Standard Markdown enriched with raw LaTeX math environments**.

Specifically, you want the **`tex_math_dollars`** extension standard, which uses single dollars for inline math and double dollars for display blocks:

- **Inline:** `Let $x$ be a continuous variable...`
- **Block:** ```markdown
  $$ \int_a^b f(x) dx = F(b) - F(a)$$

```


```

Here is why this is the absolute ideal standard for your `codex-scientiae` corpus.

### 1. The Training Distribution

LLMs are heavily trained on ArXiv preprints, Jupyter Notebooks, and GitHub repositories. In all three of those domains, math is explicitly encoded using `$` and `$$` delimiters wrapping standard LaTeX commands. When you feed an LLM a prompt containing `\frac{\partial}{\partial x}`, it mathematically "understands" the relationship between the numerator and denominator precisely because it has seen that exact syntax sequence millions of times across advanced physics and computer science datasets.

### 2. Token Efficiency

LaTeX is incredibly dense. If you try to represent a matrix using HTML tables or ASCII art, you waste hundreds of tokens on structural formatting (like `<tr><td>` or spaces/pipes), which dilutes the semantic weight of the context window.

A LaTeX matrix is lightweight and structurally unambiguous to the model:
`\begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix}`

### 3. Avoiding KaTeX-Specific Macros

Because KaTeX is designed for the web, it supports several non-standard macros and HTML-injection commands (like `\htmlClass` or specific color styling) that are irrelevant to the underlying math. You want to strip all of that out. The LLM does not care if the integral sign is rendered in blue; it only cares about the bounds of the integration. Pure LaTeX syntax keeps the corpus semantically clean.

### Configuring Pandoc for the Math Standard

Since you are using Pandoc in your PowerShell ingestion pipeline to build `codex-scientiae`, you need to ensure it treats math correctly. Pandoc is brilliant at identifying math embedded in HTML (whether it was rendered by MathJax, KaTeX, or native MathML) and converting it back into raw LaTeX strings for the Markdown output.

To guarantee you get the LLM-friendly `$` and `$$` syntax, you should configure your Pandoc format string in your script like this:

`gfm+tex_math_dollars`

This tells Pandoc: _"Output standard GitHub Flavored Markdown, but when you encounter mathematical structures, do not try to approximate them with Unicode text. Wrap them in raw LaTeX dollar signs."_

If you standardize your `codex-scientiae` pipeline around `gfm+tex_math_dollars`, you are serving the math to the LLM exactly how it expects to read it, preserving all of the two-dimensional spatial rigor without sacrificing any token efficiency.

## Human viewing

It is absolutely fine, and honestly, highly recommended to use this standard for preview. If you are building a knowledge corpus, you need to be able to audit exactly what the LLM is reading to ensure the structural integrity survived the pipeline.

Here is the slight catch with `gfm+tex_math_dollars`: because it is optimized for the LLM's underlying token stream, the raw text files will just display the literal `$` and `$$` characters wrapping the LaTeX syntax.

To actually get the beautifully typeset, human-readable KaTeX/MathJax rendering on your screen without altering the underlying files, you just need a Markdown viewer that natively supports math environments.

Since you are already set up in VS Code for the Lean 4 environment, you have two incredibly clean paths to preview the corpus:

- **The VS Code Native Path:** Install the **Markdown Preview Enhanced** extension. It is a zero-friction addition to your current editor. You just open any of your generated `.md` files, pop open the preview pane, and it automatically renders all the `$$` blocks into perfectly formatted KaTeX. It keeps your workflow entirely contained within the editor you are already using for the proofs.
- **The Dedicated Vault Path:** If you want a separate, dedicated reading interface for `codex-scientiae` outside of your code editor, **Obsidian** is the gold standard. It operates entirely on local, flat Markdown files and natively supports `tex_math_dollars` rendering out of the box with zero configuration. It won't touch or corrupt your files; it just gives you a highly performant GUI to read and search them.

Both options leave the raw, LLM-friendly text completely untouched while giving you the visual clarity of a rendered math paper.

Do you want to kick off that PowerShell Pandoc script to generate the corpus first, or would you rather test the VS Code preview rendering on a single sample file to verify the output?
