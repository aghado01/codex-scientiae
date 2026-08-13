/**
 * Canonical deposited-source-tree fingerprint projection.
 *
 * The witness format is shared with procurement and jsonl_engine:
 * `path\0bytes\0sha256\n`, ordered by ordinal UTF-16 path comparison.
 * Callers measure each file once and pass the resulting byte facts here.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import crypto from "node:crypto";

export interface SourceFingerprintRecord {
  path: string;
  bytes: number;
  sha256: string;
}

/** JavaScript relational comparison is ordinal over UTF-16 code units. */
export function compareSourcePaths(left: string, right: string): number {
  return left < right ? -1 : left > right ? 1 : 0;
}

export function computeSourceTreeSha256(
  records: readonly SourceFingerprintRecord[]
): string {
  const ordered = [...records].sort((left, right) => compareSourcePaths(left.path, right.path));
  const digest = crypto.createHash("sha256");

  for (const record of ordered) {
    if (!Number.isSafeInteger(record.bytes) || record.bytes < 0) {
      throw new Error(`Invalid byte length for source-tree path '${record.path}'`);
    }
    if (!/^[0-9a-f]{64}$/.test(record.sha256)) {
      throw new Error(`Invalid sha256 for source-tree path '${record.path}'`);
    }
    if (record.path.includes("\0")) {
      throw new Error("Source-tree path contains NUL");
    }
    digest.update(`${record.path}\0${record.bytes}\0${record.sha256}\n`, "utf8");
  }

  return digest.digest("hex");
}
