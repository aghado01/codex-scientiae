```LinkedIn

LightOn just made the expensive parser cheaper than the bad one.

Every team with millions of pages made the same call: use the cheap parser, accept the messy text. Not because anyone thought it was fine. Because a real model on every page didn't pencil out at scale.

That trade just stopped being a trade.

𝐋𝐢𝐠𝐡𝐭𝐎𝐧𝐎𝐂𝐑-𝟐 is a 1B end-to-end vision-language model that turns PDFs, scans and tables into ordered text. No multi-stage pipeline. No detector, no layout model, no reading-order heuristic stapled together.

1️⃣ Under $0.01 per 1,000 pages on a single H100
2️⃣ 5.71 pages/sec, about 493,000 pages a day, on one GPU
3️⃣ 83.2 on olmOCR-Bench, at ~9× smaller than competing approaches
4️⃣ 3.3× faster than Chandra, 1.7× faster than OlmOCR, 5× faster than dots.ocr
5️⃣ Apache-2.0. 11 languages. Tables, receipts, forms, math, multi-column

The messy text wasn't a technical compromise. It was a budget decision. And every retrieval bug downstream of it got debugged as a retrieval bug, reranked, re-embedded, re-chunked, for years.

Structure your parser throws away, retrieval never gets back. No embedder recovers a table that arrived as a flat string.

Model + paper in the comments.
```

```Comments

Paper: https://arxiv.org/abs/2601.14251

Hugging Face models: https://huggingface.co/lightonai/LightOnOCR-2-1B

Demo: https://huggingface.co/spaces/lightonai/LightOnOCR-2-1B-Demo

Blog: https://huggingface.co/blog/lightonai/lightonocr-2


LightOnOCR: A 1B End-to-End Multilingual Vision-Language Model for State-of-the-Art OCR

```
