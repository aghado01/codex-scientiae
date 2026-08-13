/**
 * Dynamic dependency loader for unified-latex and latex-utensils.
 *
 * Resolves packages from an explicitly provided --deps directory path
 * (e.g. packages/node/node_modules) using createRequire.
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import { createRequire } from "node:module";
import path from "node:path";

export interface UnifiedLatexParser {
  parse(source: string): any;
}

export interface Dependencies {
  parse: {
    getParser(options?: any): UnifiedLatexParser;
    parse(source: string): any;
  };
  visit: {
    visit(ast: any, visitor: any): void;
    CONTINUE: symbol;
    SKIP: symbol;
    EXIT: symbol;
  };
  match: {
    macro(node: any, name?: string): boolean;
    environment(node: any, name?: string): boolean;
    math(node: any): boolean;
    comment(node: any): boolean;
    string(node: any): boolean;
    whitespace(node: any): boolean;
    group(node: any): boolean;
  };
  macros: {
    listNewcommands(ast: any): { name: string; signature: string; body: any[]; definition: any }[];
    expandMacrosExcludingDefinitions(tree: any, macros: { name: string; body: any[] }[]): void;
    createMacroExpander(substitution: any[]): (macro: any) => any[];
  };
  /**
   * Serializer for DERIVED content (expansion output has no raw stream to
   * slice). Source slices stay raw-stream-only; printRaw never renders them.
   */
  printRaw: {
    printRaw(node: any): string;
  };
  /** Per-package signature records from the pinned unified-latex-ctan module. */
  ctan: {
    macroInfo: Record<string, Record<string, { signature?: string; argumentParser?: unknown }>>;
    environmentInfo: Record<string, Record<string, { signature?: string; argumentParser?: unknown }>>;
  };
  utensils: {
    bibtexParser: {
      parse(source: string): any;
      isEntry(node: any): boolean;
      isStringEntry(node: any): boolean;
      isPreambleEntry(node: any): boolean;
      isTextStringValue(node: any): boolean;
      isNumberValue(node: any): boolean;
      isAbbreviationValue(node: any): boolean;
      isConcatValue(node: any): boolean;
    };
    /** Position-precise pegjs LaTeX parser — the census's backfill instrument. */
    latexParser: {
      parse(source: string, options?: any): any;
    };
  };
}

let loadedDeps: Dependencies | null = null;
let loadedDepsRoot: string | null = null;

export function loadDependencies(depsRoot: string): Dependencies {
  const resolvedRoot = path.resolve(depsRoot);
  if (loadedDeps && loadedDepsRoot === resolvedRoot) {
    return loadedDeps;
  }

  // Use a dummy file path inside the deps directory to establish require context
  const req = createRequire(path.join(resolvedRoot, "index.js"));

  const parse = req("@unified-latex/unified-latex-util-parse");
  const visit = req("@unified-latex/unified-latex-util-visit");
  const match = req("@unified-latex/unified-latex-util-match");
  const macros = req("@unified-latex/unified-latex-util-macros");
  const ctan = req("@unified-latex/unified-latex-ctan");
  const printRaw = req("@unified-latex/unified-latex-util-print-raw");
  const utensils = req("latex-utensils");

  loadedDeps = {
    parse,
    visit,
    match,
    macros,
    ctan,
    printRaw,
    utensils,
  };
  loadedDepsRoot = resolvedRoot;
  return loadedDeps;
}
