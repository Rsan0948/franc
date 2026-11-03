"use strict";
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const ft = require("../index.js");
const base = path.resolve(__dirname, "../examples");
const canon = fs.readFileSync(path.join(base, "kernel.franctxt"));
const alt = fs.readFileSync(path.join(base, "kernel_alternate.franctxt"));
assert.deepEqual(ft.canonical(ft.parse(canon)), canon);
assert.deepEqual(ft.canonical(ft.parse(alt)), canon);
assert.equal(ft.digest(canon), ft.digest(alt));
assert.equal(ft.parse(canon).get("math.ratio").n, 1n);
assert.equal(ft.parse(canon).get("math.ratio").d, 3n);
assert.equal(ft.parse(canon).get("memory.page-size"), 4096n);
assert.equal(ft.parse(canon).get("network.enabled"), false);
assert.equal(ft.parse(canon).get("history.parent"), null);
ft.validateKernel(ft.parse(canon));
const optional = ft.parse(canon);
optional.delete("history.parent");
ft.validateKernel(optional);
const bad = ft.parse(canon);
bad.set("network.enabled", true);
bad.set("network.driver", "none");
assert.throws(() => ft.validateKernel(bad));
for (const input of [
  "franctxt 2\nx = 1\n",
  "franctxt 1\nx = 1\nx = 1\n",
  "franctxt 1\nx = 01\n",
  "franctxt 1\nx = 9223372036854775808\n",
  "franctxt 1\nx = 1/0\n",
  "franctxt 1\nx = 1.5\n",
  "franctxt 1\nx = \"a\\nb\"\n",
  "franctxt 1\nx = \"a\\\\nb\"\n",
  "franctxt 1\nx = 1\rbroken\n",
  "franctxt 1\nbad..key = 5\n",
]) {
  assert.throws(() => ft.parse(input), input);
}
const old = ft.canonical(new Map([["x", 42n]]));
const child = ft.canonical(new Map([["history.parent", ft.digest(old)]]));
assert.equal(ft.verifyParent(child, old), true);
assert.equal(ft.verifyParent(child, canon), false);
process.stdout.write("PASS: independent JavaScript Franctxt v1 parser, canonicalization and hash\n");
