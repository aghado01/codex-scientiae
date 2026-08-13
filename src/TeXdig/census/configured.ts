/**
 * Configured declaration evidence from pinned unified-latex-ctan records.
 *
 * Physical summons and provider candidates remain ordered, many-valued facts.
 * Chronological load/idempotence and collision handling belong to the binding
 * interpreter; this module never collapses them into a final name map.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { CensusEntity, SignatureEvidence, SourceSpan } from "../core/types.ts";
import type { Dependencies } from "../core/loader.ts";
import type { ConfiguredSummonSite } from "./parse-latex.ts";

export interface ConfiguredDecl {
  package: string;
  namespace: "control-sequence" | "environment";
  name: string;
  signature: SignatureEvidence;
  site: SourceSpan;
}

export interface ConfiguredChannel {
  /** Every physical summon target, including repeats, in source inventory order. */
  summons: ConfiguredSummonSite[];
  /** Provider-qualified declaration candidates; same-name providers coexist. */
  declarations: ConfiguredDecl[];
  /** Distinct requested packages with no pinned record, in first-sighting order. */
  unresolvedPackages: string[];
}

export function ctanSignatureEvidence(
  pkg: string,
  name: string,
  info: { signature?: string; argumentParser?: unknown } | undefined
): SignatureEvidence {
  if (info?.argumentParser !== undefined) {
    return {
      state: "custom-parser",
      detail: `unified-latex-ctan/${pkg}/${name}`,
    };
  }
  // In the pinned CTAN records, an entry without either a signature or a
  // custom parser is the package's declaration of a zero-argument construct.
  return { state: "known", spec: info?.signature ?? "" };
}

export function buildConfiguredChannel(
  summons: readonly ConfiguredSummonSite[],
  deps: Dependencies
): ConfiguredChannel {
  const declarations: ConfiguredDecl[] = [];
  const unresolvedPackages: string[] = [];
  const seenPackages = new Set<string>();

  for (const summon of summons) {
    const pkg = summon.packageName;
    if (pkg === "latex2e" || seenPackages.has(pkg)) continue;
    seenPackages.add(pkg);

    const macroRecord = deps.ctan.macroInfo[pkg];
    const envRecord = deps.ctan.environmentInfo[pkg];
    if (!macroRecord && !envRecord) {
      unresolvedPackages.push(pkg);
      continue;
    }

    for (const name of Object.keys(macroRecord || {}).sort()) {
      declarations.push({
        package: pkg,
        namespace: "control-sequence",
        name,
        signature: ctanSignatureEvidence(pkg, name, macroRecord?.[name]),
        site: summon.siteSpan,
      });
    }
    for (const name of Object.keys(envRecord || {}).sort()) {
      declarations.push({
        package: pkg,
        namespace: "environment",
        name,
        signature: ctanSignatureEvidence(pkg, name, envRecord?.[name]),
        site: summon.siteSpan,
      });
    }
  }

  declarations.sort((left, right) =>
    left.package < right.package ? -1 : left.package > right.package ? 1
      : left.namespace < right.namespace ? -1 : left.namespace > right.namespace ? 1
        : left.name < right.name ? -1 : left.name > right.name ? 1 : 0
  );
  return { summons: [...summons], declarations, unresolvedPackages };
}

/** Mint provider-qualified physical/configuration evidence for used names. */
export function mintConfiguredEntities(
  channel: ConfiguredChannel,
  usedMacroNames: ReadonlySet<string>,
  usedEnvNames: ReadonlySet<string>
): CensusEntity[] {
  const entities: CensusEntity[] = [];

  for (const declaration of channel.declarations) {
    const used = declaration.namespace === "control-sequence"
      ? usedMacroNames.has(declaration.name)
      : usedEnvNames.has(declaration.name);
    if (!used) continue;

    const argumentSpec = declaration.signature.state === "known" && declaration.signature.spec
      ? declaration.signature.spec
      : undefined;
    if (declaration.namespace === "control-sequence") {
      entities.push({
        id: `ent:macro-definition@configured/${declaration.package}:${declaration.name}`,
        kind: "macro-definition",
        definedName: declaration.name,
        declarationCommand: "configured",
        dialect: "configured",
        argumentSpec,
        signature: declaration.signature,
        configuredPackage: declaration.package,
        elaborable: false,
        context: "unknown",
        activation: "configured",
        span: declaration.site,
        spanProvenance: "parser",
        witnesses: [{
          witness: "configured",
          instrument: "unified-latex-ctan",
          span: declaration.site,
          spanRole: "summon-anchor",
          detail: declaration.package,
        }],
        agreement: "agreed",
        agreementBasis: "configured-declaration",
      });
    } else {
      entities.push({
        id: `ent:environment-definition@configured/${declaration.package}:${declaration.name}`,
        kind: "environment-definition",
        definedName: declaration.name,
        declarationCommand: "configured",
        mechanism: "configured",
        argumentSpec,
        signature: declaration.signature,
        configuredPackage: declaration.package,
        context: "unknown",
        activation: "configured",
        span: declaration.site,
        spanProvenance: "parser",
        witnesses: [{
          witness: "configured",
          instrument: "unified-latex-ctan",
          span: declaration.site,
          spanRole: "summon-anchor",
          detail: declaration.package,
        }],
        agreement: "agreed",
        agreementBasis: "configured-declaration",
      });
    }
  }

  return entities;
}
