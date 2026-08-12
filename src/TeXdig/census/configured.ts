/**
 * TeXdig configured-signature channel.
 *
 * The document names its packages and class (\usepackage, \documentclass);
 * the pinned unified-latex-ctan records declare what those packages define.
 * Matching records are injected into the pass-2 signature registry, and every
 * injected signature the document actually USES is minted as a
 * `configured`-dialect definition entity — declared evidence anchored to the
 * in-document site that summoned the package. A configured signature that
 * never fires is not a site and mints nothing.
 *
 * Precedence: configured layers merge FIRST; document-discovered definitions
 * overwrite them (the paper always wins over the package). `latex2e` is the
 * parser's own baseline vocabulary, not a summons — never treated as
 * configured.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { SourceSpan, CensusEntity } from "../core/types.ts";
import type { Dependencies } from "../core/loader.ts";
import type { SignatureRegistry } from "./parse-latex.ts";

interface ConfiguredDecl {
  package: string;
  signature?: string;
  site: SourceSpan;
}

export interface ConfiguredChannel {
  /** Registry layer to merge beneath document-discovered signatures. */
  registry: SignatureRegistry;
  /** Injected macro signatures by defined name, for post-parse minting. */
  macroDecls: Map<string, ConfiguredDecl>;
  /** Injected environment signatures by environment name. */
  envDecls: Map<string, ConfiguredDecl>;
  /** Requested packages with no ctan record — knowable-later, recorded for the summary. */
  unresolvedPackages: string[];
}

export function buildConfiguredChannel(
  requestedPackages: Map<string, SourceSpan>,
  deps: Dependencies
): ConfiguredChannel {
  const channel: ConfiguredChannel = {
    registry: { macros: {}, environments: {} },
    macroDecls: new Map(),
    envDecls: new Map(),
    unresolvedPackages: [],
  };

  for (const [pkg, site] of requestedPackages) {
    if (pkg === "latex2e") continue; // baseline vocabulary, not a summons
    const macroRecord = deps.ctan.macroInfo[pkg];
    const envRecord = deps.ctan.environmentInfo[pkg];
    if (!macroRecord && !envRecord) {
      channel.unresolvedPackages.push(pkg);
      continue;
    }
    if (macroRecord) {
      for (const [name, info] of Object.entries(macroRecord)) {
        if (info && info.signature) {
          channel.registry.macros[name] = { signature: info.signature };
        }
        channel.macroDecls.set(name, { package: pkg, signature: info?.signature, site });
      }
    }
    if (envRecord) {
      for (const [name, info] of Object.entries(envRecord)) {
        if (info && info.signature) {
          channel.registry.environments[name] = { signature: info.signature };
        }
        channel.envDecls.set(name, { package: pkg, signature: info?.signature, site });
      }
    }
  }

  return channel;
}

/**
 * Mint configured-dialect definition entities for the declared names the
 * census actually witnessed in use. Ids use the `configured/{package}` pseudo-
 * source locator (span addresses do not identify declarations that have no
 * span of their own); the entity span anchors the summoning site.
 */
export function mintConfiguredEntities(
  channel: ConfiguredChannel,
  usedMacroNames: Set<string>,
  usedEnvNames: Set<string>,
  documentDefinedMacros: Set<string>,
  documentDefinedEnvs: Set<string>
): CensusEntity[] {
  const entities: CensusEntity[] = [];

  for (const [name, decl] of channel.macroDecls) {
    if (!usedMacroNames.has(name)) continue;
    if (documentDefinedMacros.has(name)) continue; // the paper's own definition wins
    entities.push({
      id: `ent:macro-definition@configured/${decl.package}:${name}`,
      kind: "macro-definition",
      definedName: name,
      dialect: "configured",
      signatureRaw: decl.signature || undefined,
      elaborable: false,
      span: decl.site,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "configured",
          instrument: "unified-latex-ctan",
          span: decl.site,
          detail: decl.package,
        },
      ],
      agreement: "agreed",
    });
  }

  for (const [name, decl] of channel.envDecls) {
    if (!usedEnvNames.has(name)) continue;
    if (documentDefinedEnvs.has(name)) continue;
    entities.push({
      id: `ent:environment-definition@configured/${decl.package}:${name}`,
      kind: "environment-definition",
      definedName: name,
      mechanism: "configured",
      signatureRaw: decl.signature || undefined,
      span: decl.site,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "configured",
          instrument: "unified-latex-ctan",
          span: decl.site,
          detail: decl.package,
        },
      ],
      agreement: "agreed",
    });
  }

  return entities;
}
