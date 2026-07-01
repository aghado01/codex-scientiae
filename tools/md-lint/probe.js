const { lint } = require("markdownlint/promise");
(async () => {
  const bad = "#no space\n\n\n## Heading\ntext with trailing   \n";
  const res = await lint({ strings: { doc: bad }, config: { default: true, MD013: false } });
  const issues = (res.doc || res.content?.doc || []).map(e => ({ line: e.lineNumber, rule: (e.ruleNames||[]).join("/"), desc: e.ruleDescription, detail: e.errorDetail }));
  console.log(JSON.stringify({ shapeKeys: Object.keys(res), issues }, null, 2));
})();
