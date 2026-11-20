import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import test from "node:test";
import { runInNewContext } from "node:vm";

const landing = new URL("../", import.meta.url);
const catalog = JSON.parse(readFileSync(new URL("logo-catalog.json", landing), "utf8"));
const chooser = readFileSync(new URL("chooser.js", landing), "utf8");

// Run the browser script with its catalog supplied locally. UI events and
// network loading are outside these tests of the downloadable outputs.
const control = {
  dataset: {},
  addEventListener() {},
  querySelector: () => ({ textContent: "" }),
};
const messages = {
  shapeName: (shape) => shape,
  shapeRestricted: () => "",
  shapeUnverified: () => "",
  appearanceName: (appearance) => appearance,
  appearanceFallback: () => "",
};
const generate = runInNewContext(chooser + `
  (catalog, ids, appearance, shape) => {
    assertCatalog(catalog);
    state.byId = new Map(catalog.map(provider => [provider.id, provider]));
    state.selectedIds = ids;
    state.requestedAppearance = appearance;
    state.requestedShape = shape;
    const manifest = buildManifest(buildDart());
    return { manifest, handoff: buildAgentHandoff(manifest) };
  }
`, {
  URL,
  window: { siteI18n: { locale: "en", chooserMessages: messages }, addEventListener() {} },
  document: {
    baseURI: "https://example.test/landing/",
    querySelector: () => control,
    querySelectorAll: () => [],
  },
  fetch: () => new Promise(() => {}),
});

test("each archive export includes the hash of its selected PNG member", () => {
  const ids = catalog.map(provider => provider.id);
  for (const appearance of ["providerDefault", "light", "dark"]) {
    const { manifest, handoff } = generate(catalog, ids, appearance, "rounded");
    for (const { id, logo } of manifest.providers) {
      if (!logo.archive) continue;
      const bytes = readFileSync(new URL(logo.previewPath, landing));
      const hash = createHash("sha256").update(bytes).digest("hex");
      assert.equal(logo.archive.memberSha256, hash, `${id} / ${appearance}`);
      assert.ok(handoff.includes(`Archive member SHA-256: ${hash}`));
    }
  }
});

test("schema 2 preserves source-page routes and emits labelled wide logo ratios", () => {
  const ids = ["notion", "facebook", "instagram", "steam", "zoom"];
  for (const shape of ["rounded", "pill", "circle"]) {
    const { manifest } = generate(catalog, ids, "providerDefault", shape);
    assert.equal(manifest.schemaVersion, 2);
    for (const { id, logo, rendering } of manifest.providers) {
      if (id === "steam" || id === "zoom") {
        assert.equal(logo.downloadMethod, "direct");
        assert.equal(
          manifest.integration.dart.includes(`logoAspectRatio: ${rendering.logoAspectRatio},`),
          shape !== "circle",
        );
      } else {
        assert.equal(logo.downloadMethod, "source-page");
        assert.equal(logo.downloadUrl, null);
        assert.match(logo.sourcePage, /^https:\/\//);
      }
    }
  }
});

test("JSON and text handoffs connect an existing loading state to isLoading", () => {
  const { manifest, handoff } = generate(catalog, ["google"], "light", "rounded");
  assert.match(manifest.integration.instruction, /isLoading/);
  assert.match(handoff, /isLoading/);
});
