// tikz-svg.js — batch TikZ/tikz-cd -> SVG via node-tikzjax (wasm TeX + dvi2svg).
//
// One node invocation renders a whole paper's diagrams (wasm init is the expensive part).
// stdin/argv contract, mirroring katex-check.js's role as the PS-orchestrated worker:
//
//   node tikz-svg.js <jobs.json> <outdir>
//
// jobs.json: { "jobs": [ { "id": "diagram-1", "source": "\\begin{tikzpicture}...\\end{tikzpicture}",
//                          "tikzLibraries": "cd,arrows.meta", "texPackages": {"tikz-cd": ""},
//                          "preamble": "\\tikzset{...}" } ] }
//
// Per-job fault isolation: a diagram that fails to compile reports {ok:false,error} and never kills
// the batch. Output: <outdir>/<id>.svg per success; a JSON report on stdout.

const fs = require('fs');
const path = require('path');

async function main() {
  const [jobsPath, outDir] = process.argv.slice(2);
  if (!jobsPath || !outDir) {
    console.error('usage: node tikz-svg.js <jobs.json> <outdir>');
    process.exit(2);
  }
  const mod = require('node-tikzjax');
  const tex2svg = mod.default || mod;
  const { jobs } = JSON.parse(fs.readFileSync(jobsPath, 'utf8'));
  fs.mkdirSync(outDir, { recursive: true });

  const report = [];
  for (const job of jobs) {
    try {
      let source = job.source || '';
      if (!/\\begin\{document\}/.test(source)) {
        source = '\\begin{document}\n' + source + '\n\\end{document}';
      }
      const opts = {
        showConsole: false,
        texPackages: job.texPackages || {},
        tikzLibraries: job.tikzLibraries || '',
        addToPreamble: job.preamble || '',
        embedFontCss: true,   // self-contained SVG: renders on GitHub without external font fetches
      };
      const svg = await tex2svg(source, opts);
      const file = path.join(outDir, job.id + '.svg');
      fs.writeFileSync(file, svg, 'utf8');
      report.push({ id: job.id, ok: true, bytes: svg.length });
    } catch (e) {
      report.push({ id: job.id, ok: false, error: String(e && e.message ? e.message : e).slice(0, 500) });
    }
  }
  process.stdout.write(JSON.stringify({ total: jobs.length, ok: report.filter(r => r.ok).length, results: report }));
}

main().catch(e => { console.error(String(e)); process.exit(1); });
