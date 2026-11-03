"use strict";
/* Zero-dependency Franctxt v1 parser and canonical content identity.
 * Uses BigInt to keep signed 64-bit integers and rationals exact.
 */
const crypto = require("node:crypto");
const HEADER = "franctxt 1";
const DOMAIN = Buffer.from("franctxt/1\0", "ascii");
const MAX = (1n << 63n) - 1n;
const KEY = /^[a-z][a-z0-9]*(?:[._-][a-z0-9]+)*$/;
const INT = /^-?(?:0|[1-9][0-9]*)$/;
const RAT = /^(-?(?:0|[1-9][0-9]*))\/([1-9][0-9]*)$/;

function reject(message) { throw new Error("Franctxt v1: " + message); }
function checkAscii(text, where) {
  for (let i = 0; i < text.length; ++i) {
    const c = text.charCodeAt(i);
    if (c > 127 || !(c === 9 || c === 10 || c === 13 || (c >= 32 && c <= 126))) {
      reject(where + ": non-ASCII or forbidden control byte");
    }
  }
}
function checkKey(key) {
  if (key.length > 63 || !KEY.test(key)) reject("invalid key " + key);
}
function integer(text) {
  if (!INT.test(text)) reject("invalid integer " + text);
  const value = BigInt(text);
  if (value < -MAX || value > MAX) reject("integer exceeds signed v1 range");
  return value;
}
function gcd(x, y) {
  while (y !== 0n) { const rest = x % y; x = y; y = rest; }
  return x;
}
function rational(n, d) {
  if (d <= 0n || d > MAX || n < -MAX || n > MAX) reject("rational out of range");
  const g = gcd(n < 0n ? -n : n, d);
  return Object.freeze({ __franctxtRational: true, n: n / g, d: d / g });
}
function parseValue(text) {
  if (text === "true") return true;
  if (text === "false") return false;
  if (text === "null") return null;
  if (text.startsWith('"') && text.endsWith('"') && text.length >= 2) {
    const value = text.slice(1, -1);
    checkAscii(value, "string");
    if (value.length > 255 || value.includes('"') || value.includes("\\") ||
        value.includes("\n") || value.includes("\r") || value.includes("\t")) {
      reject("v1 string has an unsupported escape or length");
    }
    return value;
  }
  const match = RAT.exec(text);
  if (match) {
    const n = integer(match[1]), d = BigInt(match[2]);
    return rational(n, d);
  }
  return integer(text);
}
function formatValue(value) {
  if (value === true) return "true";
  if (value === false) return "false";
  if (value === null) return "null";
  if (typeof value === "bigint") {
    if (value < -MAX || value > MAX) reject("integer out of range");
    return value.toString();
  }
  if (typeof value === "number" && Number.isSafeInteger(value)) {
    return formatValue(BigInt(value));
  }
  if (typeof value === "string") {
    checkAscii(value, "string");
    if (value.length > 255 || value.includes('"') || value.includes("\\") ||
        value.includes("\n") || value.includes("\r") || value.includes("\t")) {
      reject("v1 string contains forbidden character");
    }
    return '"' + value + '"';
  }
  if (value && value.__franctxtRational === true) {
    if (typeof value.n !== "bigint" || typeof value.d !== "bigint") reject("bad rational");
    const reduced = rational(value.n, value.d);
    return String(reduced.n) + "/" + String(reduced.d);
  }
  reject("unsupported value " + typeof value);
}
function parse(source) {
  const text = Buffer.isBuffer(source) ? source.toString("utf8") : source;
  if (typeof text !== "string") reject("input is not text");
  checkAscii(text, "document");
  if (Buffer.byteLength(text, "ascii") > 2047) reject("document exceeds 2047 bytes");
  const lf = text.replace(/\r\n/g, "\n");
  if (lf.includes("\r")) reject("bare CR line endings forbidden");
  const lines = lf.split("\n");
  if (!lines.length || lines[0].trim() !== HEADER) reject("missing first-line header");
  const result = new Map();
  lines.slice(1).forEach((line, index) => {
    const item = line.trim();
    if (!item || item.startsWith("#")) return;
    const pos = item.indexOf("=");
    if (pos < 0) reject("line " + (index + 2) + " missing =");
    const key = item.slice(0, pos).trim();
    const raw = item.slice(pos + 1).trim();
    checkKey(key);
    if (result.has(key)) reject("duplicate key " + key);
    result.set(key, parseValue(raw));
  });
  return result;
}
function canonical(entries) {
  if (!(entries instanceof Map)) reject("canonical() requires a Map");
  const keys = Array.from(entries.keys()).sort();
  const lines = [HEADER];
  for (const key of keys) {
    checkKey(key);
    lines.push(key + " = " + formatValue(entries.get(key)));
  }
  const result = Buffer.from(lines.join("\n") + "\n", "ascii");
  if (result.length > 2047) reject("canonical document exceeds 2047 bytes");
  return result;
}
function normalized(source) { return canonical(parse(source)); }
function digest(source) {
  const data = source instanceof Map ? canonical(source) : normalized(source);
  const value = crypto.createHash("sha256").update(DOMAIN).update(data).digest("hex");
  return "sha256:" + value;
}
function validateKernel(entries) {
  if (entries.get("schema") !== "francos.kernel.v1" ||
      entries.get("system.name") !== "FrancOS") reject("kernel schema/name mismatch");
  for (const [key, lo, hi] of [
    ["memory.page-size", 4096n, 4096n],
    ["memory.heap-size", 0n, 4194304n],
    ["scheduler.max-tasks", 0n, 2n],
  ]) {
    const value = entries.get(key);
    if (typeof value !== "bigint" || value < lo || value > hi) reject("kernel constraint " + key);
  }
  if (!["bios", "uefi"].includes(entries.get("boot.default"))) reject("invalid boot.default");
  if (typeof entries.get("network.enabled") !== "boolean") reject("network.enabled not boolean");
  if (!["none", "e1000"].includes(entries.get("network.driver"))) reject("bad network.driver");
  if (entries.get("network.enabled") && entries.get("network.driver") === "none")
    reject("network.enabled with no driver");
  const parent = entries.get("history.parent");
  if (parent !== null && (typeof parent !== "string" ||
      !/^sha256:[0-9a-f]{64}$/.test(parent))) reject("invalid parent digest");
}
function verifyParent(child, parent) {
  return parse(child).get("history.parent") === digest(parent);
}
module.exports = {
  HEADER, parse, canonical, normalized, digest, rational,
  parseValue, formatValue, validateKernel, verifyParent,
};
