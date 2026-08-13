/**
 * TeXdig configured-signature channel.
 *
 * The document names its packages and class (\usepackage, \documentclass);
 * the pinned unified-latex-ctan records declare what those packages define.
 * Matching records provide declaration evidence for later occurrence-level
 * attachment. They are not injected into the physical census parser: binding
 * order, scope, and source occurrences cannot be represented by one final
 * signature map. A configured declaration the document uses is minted as a
 * summon-anchored entity; an unused declaration mints no entity. Same-name
 * document declarations do not suppress configured evidence here: shadowing
 * is chronological and scope-sensitive, so it belongs to the occurrence-aware
 * binding cut.
 *
 * `latex2e` is the parser's baseline vocabulary, not a package summons.
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
  /** Signature evidence retained for occurrence-level attachment. */
  registry: SignatureRegistry;
  /** Declared macro signatures by defined name, for post-parse minting. */
  macroDecls: Map<string, ConfiguredDecl>;
  /** Declared environment signatures by environment name. */
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
  usedEnvNames: Set<string>
): CensusEntity[] {
  const entities: CensusEntity[] = [];

  for (const [name, decl] of channel.macroDecls) {
    if (!usedMacroNames.has(name)) continue;
    entities.push({
      id: `ent:macro-definition@configured/${decl.package}:${name}`,
      kind: "macro-definition",
      definedName: name,
      dialect: "configured",
      argumentSpec: decl.signature || undefined,
      elaborable: false,
      context: "unknown",
      activation: "configured",
      span: decl.site,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "configured",
          instrument: "unified-latex-ctan",
          span: decl.site,
          spanRole: "summon-anchor",
          detail: decl.package,
        },
      ],
      agreement: "agreed",
      agreementBasis: "configured-declaration",
    });
  }

  for (const [name, decl] of channel.envDecls) {
    if (!usedEnvNames.has(name)) continue;
    entities.push({
      id: `ent:environment-definition@configured/${decl.package}:${name}`,
      kind: "environment-definition",
      definedName: name,
      mechanism: "configured",
      argumentSpec: decl.signature || undefined,
      context: "unknown",
      activation: "configured",
      span: decl.site,
      spanProvenance: "parser",
      witnesses: [
        {
          witness: "configured",
          instrument: "unified-latex-ctan",
          span: decl.site,
          spanRole: "summon-anchor",
          detail: decl.package,
        },
      ],
      agreement: "agreed",
      agreementBasis: "configured-declaration",
    });
  }

  return entities;
}
