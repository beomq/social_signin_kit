const CATALOG_URL = "logo-catalog.json";
const DEFAULT_SELECTION = ["google", "apple", "kakao"];
const APP_ASSET_DIRECTORY = "assets/social";
const DEFAULT_RUNTIME_LOGO_SIZE = 24;
const DEFAULT_RUNTIME_BUTTON_SIZE = 48;
const SHAPES = ["rounded", "pill", "circle"];
const APPEARANCES = ["providerDefault", "light", "dark"];
const CAPABILITY_STATES = new Set(["supported", "restricted", "unverified"]);

const copyResetTimers = new WeakMap();

let locale = window.siteI18n.locale;
let text = window.siteI18n.chooserMessages;

const elements = {
  catalogStatus: document.querySelector("[data-catalog-status]"),
  providerGrid: document.querySelector("[data-provider-grid]"),
  selectionStatus: document.querySelector("[data-selection-status]"),
  emptyFeedback: document.querySelector("[data-empty-feedback]"),
  preview: document.querySelector("[data-live-preview]"),
  dartCode: document.querySelector("[data-dart-code]"),
  agentHandoff: document.querySelector("[data-agent-handoff]"),
  manifestPreview: document.querySelector("[data-manifest-preview]"),
  copyAgent: document.querySelector("[data-copy-agent]"),
  copyDart: document.querySelector("[data-copy-dart]"),
  downloadJson: document.querySelector("[data-download-json]"),
  downloadText: document.querySelector("[data-download-text]"),
  exportStatus: document.querySelector("[data-export-status]"),
  orderStatus: document.querySelector("[data-order-status]"),
  shapeGuidance: document.querySelector("[data-shape-guidance]"),
  appearanceGuidance: document.querySelector("[data-appearance-guidance]"),
};

const state = {
  catalog: [],
  byId: new Map(),
  selectedIds: [],
  direction: "vertical",
  requestedShape: "rounded",
  requestedAppearance: "light",
  itemAppearances: new Map(),
};

const dragSession = {
  pointerId: null,
  providerId: null,
  startIds: [],
  control: null,
};

function isPreviewDragging() {
  return dragSession.pointerId !== null;
}

function assertCatalog(catalog) {
  if (!Array.isArray(catalog) || catalog.length !== 35) {
    throw new Error("logo-catalog.json must contain exactly 35 entries");
  }

  const ids = new Set();
  for (const entry of catalog) {
    const requiredEntryFields = [
      "id",
      "name",
      "background",
      "foreground",
      "label",
      "asset",
    ];
    for (const field of requiredEntryFields) {
      if (entry[field] == null) {
        throw new Error(`Missing ${field} for a catalog entry`);
      }
    }

    const requiredAssetFields = [
      "preview",
      "download",
      "format",
      "sha256",
      "source",
      "license",
      "official",
      "conditions",
    ];
    for (const field of requiredAssetFields) {
      if (entry.asset[field] == null) {
        throw new Error(`Missing asset.${field} for ${entry.id}`);
      }
    }

    for (const field of [
      "identificationUse",
      "transformation",
      "redistribution",
      "sources",
      "checkedOn",
    ]) {
      if (entry.asset.conditions[field] == null) {
        throw new Error(`Missing asset.conditions.${field} for ${entry.id}`);
      }
    }

    if (!entry.label.en || !entry.label.ko) {
      throw new Error(`Missing localized label for ${entry.id}`);
    }
    if (ids.has(entry.id)) {
      throw new Error(`Duplicate provider id: ${entry.id}`);
    }
    if (
      entry.asset.archive &&
      (!entry.asset.archive.member || !entry.asset.archive.memberSha256)
    ) {
      throw new Error(`Incomplete asset.archive for ${entry.id}`);
    }
    if (
      entry.asset.format === "zip" &&
      (!entry.asset.archiveMember || !entry.asset.archiveSha256)
    ) {
      throw new Error(`Incomplete ZIP metadata for ${entry.id}`);
    }
    if (
      entry.rendering != null &&
      (!Number.isFinite(entry.rendering.logoSize) ||
        entry.rendering.logoSize <= 0 ||
        entry.rendering.logoSize > DEFAULT_RUNTIME_BUTTON_SIZE)
    ) {
      throw new Error(`Invalid rendering.logoSize for ${entry.id}`);
    }
    if (entry.capabilities != null) {
      const capabilities = entry.capabilities;
      if (
        !Array.isArray(capabilities.appearances) ||
        capabilities.appearances.some(
          (appearance) => !APPEARANCES.includes(appearance),
        )
      ) {
        throw new Error(`Invalid capabilities.appearances for ${entry.id}`);
      }
      for (const shape of SHAPES) {
        const status = capabilities.shapes?.[shape];
        if (status != null && !CAPABILITY_STATES.has(status)) {
          throw new Error(
            `Invalid capabilities.shapes.${shape} for ${entry.id}`,
          );
        }
      }
      if (
        capabilities.sources != null &&
        (!Array.isArray(capabilities.sources) ||
          capabilities.sources.some((source) => typeof source !== "string"))
      ) {
        throw new Error(`Invalid capabilities.sources for ${entry.id}`);
      }
    }
    ids.add(entry.id);
  }
}

function providerCapabilities(provider) {
  const raw = provider.capabilities;
  const appearances = Array.isArray(raw?.appearances)
    ? raw.appearances.filter((appearance) => APPEARANCES.includes(appearance))
    : ["providerDefault"];
  if (!appearances.includes("providerDefault")) {
    appearances.unshift("providerDefault");
  }

  return {
    appearances,
    shapes: Object.fromEntries(
      SHAPES.map((shape) => [
        shape,
        CAPABILITY_STATES.has(raw?.shapes?.[shape])
          ? raw.shapes[shape]
          : "unverified",
      ]),
    ),
    shapeReasons: raw?.shapeReasons ?? {},
    sources: Array.isArray(raw?.sources) ? [...raw.sources] : [],
  };
}

function localizedReason(provider, shape) {
  const reason = providerCapabilities(provider).shapeReasons?.[shape];
  if (typeof reason === "string") return reason;
  return reason?.[locale] || reason?.en || text.reasonUnavailable;
}

function selectedProviders() {
  return state.selectedIds.map((id) => state.byId.get(id)).filter(Boolean);
}

function shapeAssessment(shape) {
  const providers = selectedProviders();
  return {
    restricted: providers.filter(
      (provider) => providerCapabilities(provider).shapes[shape] === "restricted",
    ),
    unverified: providers.filter(
      (provider) => providerCapabilities(provider).shapes[shape] === "unverified",
    ),
    supported: providers.filter(
      (provider) => providerCapabilities(provider).shapes[shape] === "supported",
    ),
  };
}

function effectiveShape() {
  return state.requestedShape;
}

function requestedProviderAppearance() {
  return state.requestedAppearance;
}

function supportsAppearance(provider, appearance) {
  return providerCapabilities(provider).appearances.includes(appearance);
}

function effectiveListAppearance() {
  if (state.requestedAppearance === "providerDefault") {
    return "providerDefault";
  }
  return selectedProviders().some((provider) =>
    supportsAppearance(provider, state.requestedAppearance),
  )
    ? state.requestedAppearance
    : "providerDefault";
}

function effectiveProviderAppearance(provider) {
  const requested =
    state.itemAppearances.get(provider.id) || requestedProviderAppearance();
  return supportsAppearance(provider, requested)
    ? requested
    : providerCapabilities(provider).appearances[0];
}

function effectiveProviderAsset(provider) {
  const appearance = effectiveProviderAppearance(provider);
  const variant = provider.asset.variants?.[appearance];
  if (variant) return variant;
  const style =
    provider.appearanceStyles?.[appearance] ||
    provider.appearances?.[appearance];
  return typeof style?.asset === "object" && style.asset !== null
    ? style.asset
    : provider.asset;
}

function providerVisual(provider) {
  const appearance = effectiveProviderAppearance(provider);
  const variant =
    appearance === "providerDefault"
      ? null
      : provider.appearanceStyles?.[appearance] ||
        provider.appearances?.[appearance];
  const assetVariant = provider.asset.variants?.[appearance];
  const preview = assetVariant
    ? assetVariant.preview
    : typeof variant?.asset === "string"
      ? variant.asset
      : effectiveProviderAsset(provider).preview;
  return {
    appearance,
    background: variant?.background || provider.background,
    foreground: /^#[0-9a-f]{8}$/i.test(
      variant?.foreground || provider.foreground,
    )
      ? `#${(variant?.foreground || provider.foreground).slice(3)}${(
          variant?.foreground || provider.foreground
        ).slice(1, 3)}`
      : variant?.foreground || provider.foreground,
    border: variant?.border || null,
    preview,
    logoColor: assetVariant ? null : variant?.logoColor || null,
  };
}

function providerLabel(provider) {
  return provider.label[locale] || provider.label.en;
}

function callbackName(id) {
  const pascal = id
    .replace(/([a-z0-9])([A-Z])/g, "$1 $2")
    .split(/[^a-zA-Z0-9]+/)
    .filter(Boolean)
    .map((part) => part[0].toUpperCase() + part.slice(1))
    .join("");
  return `handle${pascal}Pressed`;
}

function appAssetPath(id) {
  return `${APP_ASSET_DIRECTORY}/${id}.png`;
}

function runtimeLogoSize(provider) {
  return provider.rendering?.logoSize ?? DEFAULT_RUNTIME_LOGO_SIZE;
}

function scaledLogoSize(provider, containerSize) {
  return (
    (runtimeLogoSize(provider) / DEFAULT_RUNTIME_BUTTON_SIZE) * containerSize
  );
}

function createLogo(provider, size, source = provider.asset.preview) {
  const image = document.createElement("img");
  image.src = source;
  image.alt = "";
  image.width = size;
  image.height = size;
  image.style.inlineSize = `${size}px`;
  image.style.blockSize = `${size}px`;
  image.decoding = "async";
  return image;
}

function renderProviderGrid() {
  const fragment = document.createDocumentFragment();

  for (const provider of state.catalog) {
    const label = document.createElement("label");
    label.className = "provider-choice";
    label.dataset.providerId = provider.id;
    label.style.setProperty("--provider-background", provider.background);
    label.style.setProperty("--provider-foreground", provider.foreground);

    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.value = provider.id;
    checkbox.checked = state.selectedIds.includes(provider.id);
    checkbox.addEventListener("change", () => {
      if (checkbox.checked) {
        state.selectedIds.push(provider.id);
      } else {
        state.selectedIds = state.selectedIds.filter((id) => id !== provider.id);
      }
      renderAll();
    });

    const logo = document.createElement("span");
    logo.className = "provider-choice__logo";
    logo.append(createLogo(provider, scaledLogoSize(provider, 32)));

    const identity = document.createElement("span");
    identity.className = "provider-choice__identity";
    const name = document.createElement("strong");
    name.textContent = provider.name;
    const provenance = document.createElement("small");
    provenance.textContent = provider.asset.official
      ? text.officialAsset
      : text.thirdPartyAsset;
    identity.append(name, provenance);

    const check = document.createElement("span");
    check.className = "provider-choice__check";
    check.setAttribute("aria-hidden", "true");
    check.textContent = "✓";

    label.append(checkbox, logo, identity, check);
    fragment.append(label);
  }

  elements.providerGrid.replaceChildren(fragment);
}

function syncProviderGrid() {
  elements.providerGrid
    .querySelectorAll('input[type="checkbox"]')
    .forEach((checkbox) => {
      checkbox.checked = state.selectedIds.includes(checkbox.value);
    });
}

function syncPreviewOrderMetadata() {
  const items = [
    ...elements.preview.querySelectorAll("[data-preview-id]"),
  ];
  items.forEach((item, index) => {
    const provider = state.byId.get(item.dataset.previewId);
    item.setAttribute("aria-posinset", String(index + 1));
    item.setAttribute("aria-setsize", String(items.length));
    const control = item.querySelector(".preview-reorder-button");
    control?.setAttribute(
      "aria-label",
      text.reorderButton(
        providerLabel(provider),
        index + 1,
        items.length,
      ),
    );
  });
}

function syncPreviewDomOrder() {
  for (const id of state.selectedIds) {
    const item = elements.preview.querySelector(
      `[data-preview-id="${CSS.escape(id)}"]`,
    );
    if (item) elements.preview.append(item);
  }
  syncPreviewOrderMetadata();
}

function movePreviewItem(id, nextIndex, announce = true) {
  const currentIndex = state.selectedIds.indexOf(id);
  if (currentIndex < 0) return false;

  const nextIds = [...state.selectedIds];
  nextIds.splice(currentIndex, 1);
  const boundedIndex = Math.max(0, Math.min(nextIndex, nextIds.length));
  nextIds.splice(boundedIndex, 0, id);
  if (nextIds.every((value, index) => value === state.selectedIds[index])) {
    return false;
  }

  state.selectedIds = nextIds;
  syncPreviewDomOrder();
  updateExportState();
  if (announce) {
    const provider = state.byId.get(id);
    elements.orderStatus.textContent = text.movedTo(
      provider.name,
      boundedIndex + 1,
      nextIds.length,
    );
  }
  return true;
}

function keyboardMovePreviewItem(event, id) {
  const offsets = {
    ArrowUp: -1,
    ArrowLeft: -1,
    ArrowDown: 1,
    ArrowRight: 1,
  };
  const offset = offsets[event.key];
  if (!offset) return;
  event.preventDefault();
  const currentIndex = state.selectedIds.indexOf(id);
  const nextIndex = currentIndex + offset;
  if (nextIndex < 0 || nextIndex >= state.selectedIds.length) return;
  movePreviewItem(id, nextIndex);
}

function visualInsertionIndex(clientX, clientY, draggedId) {
  const entries = state.selectedIds
    .filter((id) => id !== draggedId)
    .map((id, index) => {
      const item = elements.preview.querySelector(
        `[data-preview-id="${CSS.escape(id)}"]`,
      );
      return item ? { id, index, rect: item.getBoundingClientRect() } : null;
    })
    .filter(Boolean);
  if (entries.length === 0) return 0;

  if (state.direction === "vertical") {
    const match = entries.find(({ rect }) => clientY < rect.top + rect.height / 2);
    return match ? match.index : entries.length;
  }

  const rows = [];
  for (const entry of entries) {
    let row = rows.find(
      ({ top, bottom }) =>
        entry.rect.top < bottom - 1 && entry.rect.bottom > top + 1,
    );
    if (!row) {
      row = {
        top: entry.rect.top,
        bottom: entry.rect.bottom,
        entries: [],
      };
      rows.push(row);
    }
    row.top = Math.min(row.top, entry.rect.top);
    row.bottom = Math.max(row.bottom, entry.rect.bottom);
    row.entries.push(entry);
  }

  const row = rows.reduce((closest, candidate) => {
    const distance =
      clientY < candidate.top
        ? candidate.top - clientY
        : clientY > candidate.bottom
          ? clientY - candidate.bottom
          : 0;
    return !closest || distance < closest.distance
      ? { ...candidate, distance }
      : closest;
  }, null);
  const rowEntries = [...row.entries].sort(
    (left, right) => left.rect.left - right.rect.left,
  );
  const match = rowEntries.find(
    ({ rect }) => clientX < rect.left + rect.width / 2,
  );
  return match ? match.index : rowEntries.at(-1).index + 1;
}

function restoreDragStartOrder() {
  state.selectedIds = [...dragSession.startIds];
  syncPreviewDomOrder();
  updateExportState();
}

function finishPreviewDrag({ cancelled = false } = {}) {
  if (!isPreviewDragging()) return;
  const { pointerId, providerId, control } = dragSession;
  const provider = state.byId.get(providerId);
  if (cancelled) restoreDragStartOrder();

  dragSession.pointerId = null;
  dragSession.providerId = null;
  dragSession.startIds = [];
  dragSession.control = null;
  elements.preview.classList.remove("is-reordering");
  elements.preview
    .querySelectorAll(".preview-item.is-dragging")
    .forEach((item) => item.classList.remove("is-dragging"));
  if (control?.hasPointerCapture(pointerId)) {
    control.releasePointerCapture(pointerId);
  }
  control?.focus({ preventScroll: true });

  const position = state.selectedIds.indexOf(providerId) + 1;
  elements.orderStatus.textContent = cancelled
    ? text.dragCancelled(provider.name)
    : text.dragDropped(provider.name, position, state.selectedIds.length);
}

function beginPreviewDrag(event, id, control) {
  if (!event.isPrimary || event.button !== 0 || isPreviewDragging()) return;
  event.preventDefault();
  dragSession.pointerId = event.pointerId;
  dragSession.providerId = id;
  dragSession.startIds = [...state.selectedIds];
  dragSession.control = control;
  control.focus({ preventScroll: true });
  control.setPointerCapture(event.pointerId);
  control.closest(".preview-item")?.classList.add("is-dragging");
  elements.preview.classList.add("is-reordering");
  const provider = state.byId.get(id);
  elements.orderStatus.textContent = text.dragStarted(
    provider.name,
    state.selectedIds.indexOf(id) + 1,
    state.selectedIds.length,
  );
}

function wirePreviewReorderButton(control, provider) {
  control.classList.add("preview-reorder-button");
  control.dataset.dragId = provider.id;
  control.setAttribute(
    "aria-keyshortcuts",
    "ArrowUp ArrowDown ArrowLeft ArrowRight Escape",
  );
  control.setAttribute("aria-describedby", "preview-reorder-hint");
  control.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && isPreviewDragging()) {
      event.preventDefault();
      finishPreviewDrag({ cancelled: true });
      return;
    }
    keyboardMovePreviewItem(event, provider.id);
  });
  control.addEventListener("pointerdown", (event) => {
    beginPreviewDrag(event, provider.id, control);
  });
  control.addEventListener("pointermove", (event) => {
    if (
      dragSession.pointerId !== event.pointerId ||
      dragSession.providerId !== provider.id
    ) {
      return;
    }
    event.preventDefault();
    movePreviewItem(
      provider.id,
      visualInsertionIndex(event.clientX, event.clientY, provider.id),
      false,
    );
  });
  control.addEventListener("pointerup", (event) => {
    if (dragSession.pointerId !== event.pointerId) return;
    event.preventDefault();
    finishPreviewDrag();
  });
  control.addEventListener("pointercancel", (event) => {
    if (dragSession.pointerId === event.pointerId) {
      finishPreviewDrag({ cancelled: true });
    }
  });
  control.addEventListener("lostpointercapture", () => {
    if (dragSession.control === control) finishPreviewDrag();
  });
}

function renderPreview() {
  const fragment = document.createDocumentFragment();
  elements.preview.className = `chooser-preview chooser-preview--${state.direction}`;
  const shape = effectiveShape();

  state.selectedIds.forEach((id, index) => {
    const provider = state.byId.get(id);
    const visual = providerVisual(provider);
    const item = document.createElement("div");
    item.className = `preview-item preview-item--${shape}`;
    item.dataset.previewId = id;
    item.setAttribute("role", "listitem");
    item.setAttribute("aria-posinset", String(index + 1));
    item.setAttribute("aria-setsize", String(state.selectedIds.length));

    const button = document.createElement("button");
    button.type = "button";
    button.className = `generated-button generated-button--${shape}`;
    button.style.setProperty("--provider-background", visual.background);
    button.style.setProperty("--provider-foreground", visual.foreground);
    button.style.setProperty(
      "--provider-border",
      visual.border || visual.foreground,
    );
    button.setAttribute(
      "aria-label",
      text.reorderButton(
        providerLabel(provider),
        index + 1,
        state.selectedIds.length,
      ),
    );
    button.dataset.effectiveAppearance = visual.appearance;

    const logo = document.createElement("span");
    logo.className = "generated-button__logo";
    const logoSize = runtimeLogoSize(provider);
    logo.style.inlineSize = `${logoSize}px`;
    logo.style.blockSize = `${logoSize}px`;
    logo.append(createLogo(provider, logoSize, visual.preview));
    button.append(logo);

    if (shape !== "circle") {
      const label = document.createElement("span");
      label.textContent = providerLabel(provider);
      button.append(label);
    }

    wirePreviewReorderButton(button, provider);
    item.append(button);
    const appearance = document.createElement("select");
    appearance.className = "preview-item__appearance";
    appearance.setAttribute(
      "aria-label",
      `${provider.name}: ${locale === "ko" ? "서비스 외형" : "appearance"}`,
    );
    const availableAppearances = providerCapabilities(provider).appearances;
    for (const [value, label] of [
      ["providerDefault", locale === "ko" ? "제공자 기본값" : "Provider default"],
      ["light", locale === "ko" ? "라이트" : "Light"],
      ["dark", locale === "ko" ? "다크" : "Dark"],
    ]) {
      if (!supportsAppearance(provider, value)) continue;
      const option = document.createElement("option");
      option.value = value;
      option.textContent = label;
      appearance.append(option);
    }
    appearance.value = visual.appearance;
    appearance.disabled = availableAppearances.length === 1;
    appearance.addEventListener("change", () => {
      state.itemAppearances.set(id, appearance.value);
      renderAll();
    });
    item.append(appearance);
    fragment.append(item);
  });

  if (state.selectedIds.length === 0) {
    const empty = document.createElement("p");
    empty.className = "chooser-preview__empty";
    empty.textContent = text.noSelection;
    fragment.append(empty);
  }

  elements.preview.replaceChildren(fragment);
}

function capabilityDisclosure(list) {
  const details = document.createElement("details");
  details.className = "capability-details";
  const summary = document.createElement("summary");
  summary.textContent = text.supportConditions;
  details.append(summary, list);
  return details;
}

function renderCapabilityGuidance() {
  const effective = effectiveShape();
  const shapeList = document.createElement("ul");
  shapeList.className = "capability-list";

  for (const shape of SHAPES) {
    const input = document.querySelector(
      `input[name="shape"][value="${shape}"]`,
    );
    const assessment = shapeAssessment(shape);
    input.disabled = false;
    input.checked = shape === effective;

    const item = document.createElement("li");
    item.dataset.capabilityState = assessment.restricted.length
      ? "restricted"
      : assessment.unverified.length
        ? "unverified"
        : "supported";
    if (assessment.restricted.length) {
      item.textContent = text.shapeRestricted(
        text.shapeName(shape),
        assessment.restricted
          .map(
            (provider) =>
              `${provider.name}: ${localizedReason(provider, shape)}`,
          )
          .join("; "),
      );
    } else if (assessment.unverified.length) {
      item.textContent = text.shapeUnverified(
        text.shapeName(shape),
        assessment.unverified.map((provider) => provider.name).join(", "),
      );
    } else {
      item.textContent = text.shapeSupported(text.shapeName(shape));
    }
    shapeList.append(item);
  }

  const restrictedShapes = SHAPES.filter(
    (shape) => shapeAssessment(shape).restricted.length,
  );
  const unverifiedShapes = SHAPES.filter(
    (shape) => shapeAssessment(shape).unverified.length,
  );
  const shapeSummary = document.createElement("p");
  shapeSummary.className = "capability-summary";
  if (restrictedShapes.length) {
    const providers = [
      ...new Set(
        restrictedShapes.flatMap((shape) =>
          shapeAssessment(shape).restricted.map((provider) => provider.name),
        ),
      ),
    ];
    shapeSummary.textContent = text.shapeGroupRestricted(
      restrictedShapes.map((shape) => text.shapeName(shape)).join(", "),
      providers.join(", "),
    );
  } else if (unverifiedShapes.length) {
    shapeSummary.textContent = text.shapeGroupUnverified(
      unverifiedShapes.map((shape) => text.shapeName(shape)).join(", "),
    );
  } else {
    shapeSummary.textContent = text.shapeGroupSupported;
  }

  const shapeDetails = capabilityDisclosure(shapeList);
  if (effective !== state.requestedShape) {
    const fallback = document.createElement("p");
    fallback.className = "capability-fallback";
    fallback.textContent = text.shapeFallback(
      text.shapeName(state.requestedShape),
      text.shapeName(effective),
    );
    elements.shapeGuidance.replaceChildren(fallback, shapeSummary, shapeDetails);
  } else {
    elements.shapeGuidance.replaceChildren(shapeSummary, shapeDetails);
  }

  const appearanceList = document.createElement("ul");
  appearanceList.className = "capability-list";
  const providers = selectedProviders();
  const lightInput = document.querySelector('input[name="appearance"][value="light"]');
  if (!document.querySelector('input[name="appearance"][value="providerDefault"]')) {
    const label = lightInput.parentElement.cloneNode(true);
    const input = label.querySelector("input");
    input.value = "providerDefault";
    input.checked = false;
    input.addEventListener("change", () => {
      state.requestedAppearance = input.value;
      renderAll();
    });
    lightInput.parentElement.before(label);
  }
  const availableAppearances = ["providerDefault", "light", "dark"].filter(
    (appearance) => providers.some((provider) => supportsAppearance(provider, appearance)),
  );
  if (providers.length && !availableAppearances.includes(state.requestedAppearance)) {
    state.requestedAppearance = availableAppearances[0];
  }
  for (const appearance of ["providerDefault", "light", "dark"]) {
    const input = document.querySelector(
      `input[name="appearance"][value="${appearance}"]`,
    );
    const unsupported = providers.filter(
      (provider) => !supportsAppearance(provider, appearance),
    );
    const supportedCount = providers.length - unsupported.length;
    input.parentElement.hidden = providers.length > 0 && supportedCount === 0;
    const caption = input.parentElement.querySelector("span");
    caption.removeAttribute("data-i18n");
    caption.textContent = text.appearanceName(appearance);
    input.disabled =
      appearance !== "providerDefault" &&
      providers.length > 0 &&
      supportedCount === 0;
    input.checked = appearance === state.requestedAppearance;

    const item = document.createElement("li");
    if (unsupported.length === 0) {
      item.dataset.capabilityState = "supported";
      item.textContent = text.appearanceSupported(
        text.appearanceName(appearance),
      );
    } else if (supportedCount === 0) {
      item.dataset.capabilityState = "restricted";
      item.textContent = text.appearanceUnavailable(
        text.appearanceName(appearance),
        unsupported.map((provider) => provider.name).join(", "),
      );
    } else {
      item.dataset.capabilityState = "mixed";
      item.textContent = text.appearanceMixed(
        text.appearanceName(appearance),
        supportedCount,
        providers.length,
        unsupported.map((provider) => provider.name).join(", "),
      );
    }
    appearanceList.append(item);
  }

  const effectiveAppearance = effectiveListAppearance();
  const requestedAppearance = state.requestedAppearance;
  const requestedUnsupported = providers.filter(
    (provider) => !supportsAppearance(provider, requestedAppearance),
  );
  const appearanceSummary = document.createElement("p");
  appearanceSummary.className = "capability-summary";
  if (providers.length === 0) {
    appearanceSummary.textContent = text.appearanceGroupEmpty;
  } else if (requestedUnsupported.length === 0) {
    appearanceSummary.textContent = text.appearanceGroupSupported(
      text.appearanceName(requestedAppearance),
    );
  } else if (requestedUnsupported.length === providers.length) {
    appearanceSummary.textContent = text.appearanceGroupUnavailable(
      text.appearanceName(requestedAppearance),
    );
  } else {
    appearanceSummary.textContent = text.appearanceGroupMixed(
      text.appearanceName(requestedAppearance),
      providers.length - requestedUnsupported.length,
      providers.length,
    );
  }
  const appearanceDetails = capabilityDisclosure(appearanceList);
  if (effectiveAppearance !== state.requestedAppearance) {
    const fallback = document.createElement("p");
    fallback.className = "capability-fallback";
    fallback.textContent = text.appearanceGlobalFallback(
      text.appearanceName(state.requestedAppearance),
      text.appearanceName(effectiveAppearance),
    );
    elements.appearanceGuidance.replaceChildren(
      fallback,
      appearanceSummary,
      appearanceDetails,
    );
  } else {
    elements.appearanceGuidance.replaceChildren(
      appearanceSummary,
      appearanceDetails,
    );
  }
}

function buildDart() {
  if (state.selectedIds.length === 0) return "";

  const constructor =
    state.direction === "vertical"
      ? "SocialButtonList.vertical"
      : "SocialButtonList.horizontal";
  const shape = effectiveShape();
  const appearance = effectiveListAppearance();
  const items = state.selectedIds
    .map((id) => {
      const provider = state.byId.get(id);
      const callback = callbackName(id);
      return `    SocialButton(
      social: Social.${id},
      logo: '${appAssetPath(id)}',
      appearance: SocialButtonAppearance.${effectiveProviderAppearance(provider)},
      onPressed: ${callback},
    )`;
    })
    .join(",\n");

  return `import 'package:flutter/widgets.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

${constructor}(
  shape: SocialButtonShape.${shape},
  appearance: SocialButtonAppearance.${appearance},
  locale: const Locale('${locale}'),
  spacing: ${state.direction === "vertical" ? 12 : 8},
  items: [
${items},
  ],
)`;
}

function assetManifest(provider) {
  const asset = effectiveProviderAsset(provider);
  const visual = providerVisual(provider);
  const { variants, ...originalAsset } = provider.asset;
  const variantAppearance =
    variants?.[visual.appearance] === asset ? visual.appearance : null;
  const previewUrl = new URL(asset.preview, document.baseURI).href;
  const downloadUrl = new URL(asset.download, document.baseURI).href;
  const logo = {
    previewPath: asset.preview,
    previewUrl,
    sourcePage: asset.source,
    catalogDownload: asset.download,
    downloadUrl,
    localDownload: /^https?:\/\/(?:localhost|127\.0\.0\.1)(?::|\/)/.test(
      downloadUrl,
    ),
    sourceFormat: asset.format,
    catalogSha256: asset.sha256,
    downloadSha256: asset.archiveSha256 || asset.sha256,
    sourceSha256: asset.sha256,
    license: asset.license,
    official: asset.official,
    savePath: appAssetPath(provider.id),
    provenance: {
      originalAsset,
      variantAppearance,
      ...(variantAppearance ? { variantAsset: { ...asset } } : {}),
    },
  };

  if (asset.archive) {
    logo.archive = { ...asset.archive };
  } else if (asset.archiveMember) {
    logo.archive = {
      member: asset.archiveMember,
      memberSha256: asset.sha256,
    };
  }
  if (asset.rasterization) {
    logo.rasterization = { ...asset.rasterization };
  }
  logo.conditions = { ...asset.conditions };

  return {
    id: provider.id,
    name: provider.name,
    label: { ...provider.label },
    background: provider.background,
    foreground: provider.foreground,
    rendering: {
      logoSize: runtimeLogoSize(provider),
    },
    capabilities: providerCapabilities(provider),
    ...(provider.appearances
      ? {
          appearances: Object.fromEntries(
            Object.entries(provider.appearances).map(([name, values]) => [
              name,
              { ...values },
            ]),
          ),
        }
      : {}),
    requestedAppearance:
      state.itemAppearances.get(provider.id) || requestedProviderAppearance(),
    effectiveAppearance: visual.appearance,
    effectiveAppearanceStyle: {
      background: visual.background,
      foreground: visual.foreground,
      ...(visual.border ? { border: visual.border } : {}),
      previewAsset: visual.preview,
    },
    logo,
    callbackPlaceholder: callbackName(provider.id),
  };
}

function buildCapabilityWarnings() {
  const warnings = [];
  const shape = effectiveShape();
  if (shapeAssessment(shape).restricted.length) {
    const blockers = shapeAssessment(state.requestedShape).restricted;
    warnings.push({
      code: "shape-custom",
      requested: state.requestedShape,
      effective: shape,
      providers: blockers.map((provider) => ({
        id: provider.id,
        name: provider.name,
        reason: localizedReason(provider, state.requestedShape),
        sources: providerCapabilities(provider).sources,
      })),
      message: text.shapeRestricted(
        text.shapeName(shape),
        blockers.map((provider) => `${provider.name}: ${localizedReason(provider, shape)}`).join("; "),
      ),
    });
  }

  const unverified = shapeAssessment(shape).unverified;
  if (unverified.length) {
    warnings.push({
      code: "shape-unverified",
      shape,
      providers: unverified.map((provider) => ({
        id: provider.id,
        name: provider.name,
        sources: providerCapabilities(provider).sources,
      })),
      message: text.shapeUnverified(
        text.shapeName(shape),
        unverified.map((provider) => provider.name).join(", "),
      ),
    });
  }

  for (const provider of selectedProviders()) {
    const requested = requestedProviderAppearance();
    const effective = effectiveProviderAppearance(provider);
    if (requested === effective) continue;
    warnings.push({
      code: "appearance-fallback",
      provider: provider.id,
      requested,
      effective,
      sources: providerCapabilities(provider).sources,
      message: `${provider.name}: ${text.appearanceFallback(
        text.appearanceName(requested),
        text.appearanceName(effective),
      )}`,
    });
  }
  return warnings;
}

function buildManifest(dartCode) {
  const providers = state.selectedIds.map((id) =>
    assetManifest(state.byId.get(id)),
  );

  return {
    schemaVersion: 1,
    purpose: "social_signin_kit consuming-app handoff",
    package: {
      name: "social_signin_kit",
      publication: "unpublished",
      dependencyInstruction:
        "Resolve the existing local checkout or dependency already available to the app. Do not invent a pub.dev version or a hosted Git URL.",
    },
    layout: {
      direction: state.direction,
      requestedShape: state.requestedShape,
      shape: effectiveShape(),
      requestedAppearance: state.requestedAppearance,
      appearance: effectiveListAppearance(),
      locale,
      order: [...state.selectedIds],
    },
    warnings: buildCapabilityWarnings(),
    rasterization: {
      target: "PNG",
      runtimeSvgDependency: false,
      instruction:
        "Rasterize SVG sources only, using explicit logo.rasterization metadata and an existing available conversion tool. When preserveColors is true, preserve original SVG fills without recoloring. Preserve direct PNG files and PNG archive members byte-for-byte with their original dimensions, transparency, and padding.",
    },
    providers,
    pubspec: {
      instruction:
        "Register these exact consuming-app asset paths under flutter.assets.",
      paths: providers.map((provider) => provider.logo.savePath),
      yaml: `flutter:\n  assets:\n${providers
        .map((provider) => `    - ${provider.logo.savePath}`)
        .join("\n")}`,
    },
    integration: {
      instruction:
        "Replace each callback placeholder with the app's existing login or connect function. If the app already has a loading state, use it to pass null while busy; do not invent a new state requirement for this snippet. Do not generate fake OAuth, token, redirect, or authentication-success code.",
      dart: dartCode,
    },
  };
}

function buildAgentHandoff(manifest) {
  const assetSteps = manifest.providers
    .map((provider, index) => {
      const logo = provider.logo;
      const archive = logo.archive
        ? `\n   - Archive member: ${logo.archive.member}\n   - Archive member SHA-256: ${logo.archive.memberSha256}`
        : "";
      const rasterization =
        logo.sourceFormat === "svg"
          ? logo.rasterization
            ? `\n   - SVG rasterization metadata: ${JSON.stringify(logo.rasterization)}`
            : "\n   - SVG rasterization metadata: MISSING. Do not guess dimensions or color; report the catalog error instead of converting."
          : logo.archive
            ? "\n   - PNG handling: preserve the extracted PNG byte-for-byte, including its original dimensions, transparency, and padding."
            : "\n   - PNG handling: preserve the downloaded PNG byte-for-byte, including its original dimensions, transparency, and padding.";
      return `${index + 1}. ${provider.name} (${provider.id})
   - Source page: ${logo.sourcePage}
   - Local preview PNG: ${logo.previewUrl}
   - Catalog download value: ${logo.catalogDownload}
   - Download: ${logo.downloadUrl}
   - Same-machine-only download: ${String(logo.localDownload)}
   - Source format: ${logo.sourceFormat}
   - Download SHA-256: ${logo.downloadSha256}
   - Selected source SHA-256: ${logo.sourceSha256}
   - License: ${logo.license}
   - Provider-supplied original: ${String(logo.official)} (source identity, not permission or approval)
   - Runtime logo footprint: ${provider.rendering.logoSize} logical pixels inside the package's default 48 logical-pixel button
   - Requested appearance: ${provider.requestedAppearance}
   - Effective appearance: ${provider.effectiveAppearance}
   - Appearance and shape capability sources: ${provider.capabilities.sources.join(", ") || "none recorded"}
   - Recorded use conditions: ${JSON.stringify(logo.conditions)}
   - Save PNG to: ${logo.savePath}${archive}${rasterization}`;
    })
    .join("\n\n");

  const warnings = manifest.warnings.length
    ? manifest.warnings
        .map((warning) => `- [${warning.code}] ${warning.message}`)
        .join("\n")
    : `- ${text.noCapabilityWarnings}`;

  return `Integrate the selected social login design into the current Flutter app.

Package:
- social_signin_kit is unpublished.
- Resolve the existing local checkout or dependency already available to this app.
- Do not invent a pub.dev version or a hosted Git URL.
- Do not modify the package repository.

Selected design:
- Direction: ${manifest.layout.direction}
- Requested shape: ${manifest.layout.requestedShape}
- Effective shape: ${manifest.layout.shape}
- Requested list appearance: ${manifest.layout.requestedAppearance}
- Effective list appearance: ${manifest.layout.appearance}
- Locale: ${manifest.layout.locale} (matches the preview; omit the explicit locale only if the app should inherit its own locale)
- Provider order: ${manifest.layout.order.join(", ")}

Capability warnings:
${warnings}

Logo assets:
${assetSteps}

Asset procedure:
Review each logo.conditions and its source URLs for identification use, transformation, and package redistribution separately. Unresolved terms are neither permission nor a prohibition; report them explicitly. Do not claim provider approval or legal clearance from the source flag.
1. Download each selected appearance's canonical source above. logo.provenance records the original catalog asset and selected variant separately; use logo.downloadUrl and its checks, not the original asset, for the effective logo.
2. Verify logo.downloadSha256 against the downloaded file.
3. If logo.archive is present, extract only logo.archive.member and verify logo.archive.memberSha256 against that extracted member.
4. Prefer the canonical download. The local preview PNG is available for exact visual matching when its URL is reachable. A localhost or 127.0.0.1 URL works only on the same machine.
5. For Kakao, if the same-machine local download is unavailable, reuse the existing social_signin_kit package-cache logo or the equivalent deployed-site PNG. Do not substitute a KakaoTalk chat mark or another lookalike.
6. For SVG sources only, require and apply logo.rasterization exactly with an existing conversion tool. Its canvas dimensions and rendering mode are authoritative. When preserveColors is true, keep original SVG fills and do not recolor; otherwise use its explicit color. Do not add flutter_svg or another runtime SVG dependency by default.
7. For direct PNG downloads and PNG archive members, copy the verified PNG unchanged to the exact save path. Do not rescale, normalize, recolor, crop, repad, or place it on a new canvas; original byte layout and padding are part of the selected design.
8. Register only these exact paths in pubspec.yaml:

${manifest.pubspec.yaml}

Dart:
\`\`\`dart
${manifest.integration.dart}
\`\`\`

Integration rules:
- Use the selected shape and effective appearance shown in the Dart. Preserve custom-shape warnings and provider source conditions; a preview is not evidence of provider approval. Do not synthesize a light/dark inversion.
- Keep each item's explicit appearance when it differs from the list request; providerDefault is the safe fallback for unsupported light/dark appearances.
- Treat unverified shape choices as usable package styling, not provider approval and not a prohibition.
- Replace callback placeholders with the app's existing login or connect functions.
- If the app already has a loading state, use it to pass null while busy. Do not add an undeclared state variable just to use this snippet.
- Do not create fake OAuth, token, redirect, or authentication-success code.
- Keep loading, duplicate-request prevention, errors, tokens, and navigation in the app.
- Add or update focused tests for provider order, layout, shape, asset paths, disabled state, and callback wiring.
- Run the app's focused tests, fvm flutter analyze, and its affected build or real entry point.
- Report changed files, exact asset sources and hashes, conversion commands, verification results, and authentication behavior actually exercised.
- Do not claim provider login works unless the real authentication flow was exercised.`;
}

function updateExportState() {
  const hasSelection = state.selectedIds.length > 0;
  for (const control of [
    elements.copyAgent,
    elements.copyDart,
    elements.downloadJson,
    elements.downloadText,
  ]) {
    control.disabled = !hasSelection;
  }

  elements.emptyFeedback.hidden = hasSelection;
  elements.selectionStatus.textContent = hasSelection
    ? text.selected(state.selectedIds.length)
    : text.empty;

  const dartCode = buildDart();
  const manifest = buildManifest(dartCode);
  const handoff = hasSelection ? buildAgentHandoff(manifest) : "";
  elements.dartCode.textContent = dartCode || text.noSelection;
  elements.agentHandoff.value = handoff;
  elements.manifestPreview.textContent = hasSelection
    ? JSON.stringify(manifest, null, 2)
    : text.noSelection;

  return { dartCode, manifest, handoff };
}

function renderAll(measuring = false) {
  syncProviderGrid();
  renderCapabilityGuidance();
  renderPreview();
  updateExportState();
  if (!measuring) window.siteI18n.refreshGeometry();
}

window.addEventListener("geometrylocale", ({ detail }) => {
  locale = detail.locale;
  text = window.siteI18n.messagesFor(detail.locale);
  if (isPreviewDragging()) return;
  renderAll(true);
});

function setCopyButtonState(button, stateName, label) {
  const labelElement = button.querySelector(".copy-button__label");
  button.classList.remove("is-copied", "is-failed");
  if (stateName) button.classList.add(`is-${stateName}`);
  labelElement.textContent = label;

  const existingTimer = copyResetTimers.get(button);
  if (existingTimer) window.clearTimeout(existingTimer);
  const timer = window.setTimeout(() => {
    button.classList.remove("is-copied", "is-failed");
    labelElement.textContent = button.dataset.defaultLabel;
    copyResetTimers.delete(button);
  }, 2400);
  copyResetTimers.set(button, timer);
}

async function copyText(button, value, successMessage, fallbackTarget) {
  if (!value) {
    elements.exportStatus.textContent = text.copyUnavailable;
    return;
  }

  const requestLocale = locale;
  try {
    if (!navigator.clipboard?.writeText) {
      throw new Error("Clipboard API unavailable");
    }
    await navigator.clipboard.writeText(value);
    if (locale !== requestLocale) return;
    setCopyButtonState(
      button,
      "copied",
      window.siteI18n.t("copy.copied"),
    );
    elements.exportStatus.textContent = successMessage;
  } catch {
    if (locale !== requestLocale) return;
    const details = fallbackTarget.closest("details");
    if (details) details.open = true;
    if (fallbackTarget instanceof HTMLTextAreaElement) {
      fallbackTarget.focus();
      fallbackTarget.select();
    } else {
      const range = document.createRange();
      const selection = window.getSelection();
      range.selectNodeContents(fallbackTarget);
      selection.removeAllRanges();
      selection.addRange(range);
      fallbackTarget.closest("pre")?.focus();
    }
    setCopyButtonState(
      button,
      "failed",
      window.siteI18n.t("copy.failed"),
    );
    elements.exportStatus.textContent = text.copyFailed;
  }
}

function download(filename, content, type) {
  if (!content) {
    elements.exportStatus.textContent = text.downloadUnavailable;
    return;
  }
  const blob = new Blob([content], { type });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = filename;
  document.body.append(anchor);
  anchor.click();
  anchor.remove();
  URL.revokeObjectURL(url);
}

document.querySelector("[data-preview-toggle]").addEventListener("click", (event) => {
  const toggle = event.currentTarget;
  const collapsed = document.querySelector("#preview-panel").classList.toggle("is-collapsed");
  toggle.setAttribute("aria-expanded", String(!collapsed));
  toggle.dataset.i18n = collapsed
    ? "chooser.preview.expand"
    : "chooser.preview.collapse";
  toggle.textContent = window.siteI18n.t(toggle.dataset.i18n);
  window.siteI18n.refreshGeometry();
});

document.querySelectorAll('input[name="direction"]').forEach((input) => {
  input.addEventListener("change", () => {
    state.direction = input.value;
    renderAll();
  });
});

document.querySelectorAll('input[name="shape"]').forEach((input) => {
  input.addEventListener("change", () => {
    state.requestedShape = input.value;
    renderAll();
  });
});

document.querySelectorAll('input[name="appearance"]').forEach((input) => {
  input.addEventListener("change", () => {
    state.requestedAppearance = input.value;
    renderAll();
  });
});

for (const button of [elements.copyAgent, elements.copyDart]) {
  button.dataset.defaultLabel = button.querySelector(
    ".copy-button__label",
  ).textContent;
}

window.addEventListener("languagechange", ({ detail }) => {
  locale = detail.locale;
  text = window.siteI18n.chooserMessages;
  for (const button of [elements.copyAgent, elements.copyDart]) {
    window.clearTimeout(copyResetTimers.get(button));
    copyResetTimers.delete(button);
    button.classList.remove("is-copied", "is-failed");
    button.dataset.defaultLabel = button.querySelector(
      ".copy-button__label",
    ).textContent;
  }
  elements.exportStatus.textContent = "";
  elements.orderStatus.textContent = "";
  elements.catalogStatus.textContent =
    elements.catalogStatus.dataset.state === "error"
      ? text.catalogError
      : state.catalog.length
        ? text.catalogReady(state.catalog.length)
        : text.loading;
  renderProviderGrid();
  renderAll();
});

elements.copyAgent.addEventListener("click", () => {
  const { handoff } = updateExportState();
  copyText(elements.copyAgent, handoff, text.copied, elements.agentHandoff);
});

elements.copyDart.addEventListener("click", () => {
  const { dartCode } = updateExportState();
  copyText(elements.copyDart, dartCode, text.dartCopied, elements.dartCode);
});

elements.downloadJson.addEventListener("click", () => {
  const { manifest } = updateExportState();
  download(
    "social-login-buttons-manifest.json",
    state.selectedIds.length ? `${JSON.stringify(manifest, null, 2)}\n` : "",
    "application/json",
  );
});

elements.downloadText.addEventListener("click", () => {
  const { handoff } = updateExportState();
  download(
    "social-login-buttons-agent-handoff.txt",
    handoff ? `${handoff}\n` : "",
    "text/plain",
  );
});

async function loadCatalog() {
  elements.catalogStatus.textContent = text.loading;
  try {
    const response = await fetch(CATALOG_URL);
    if (!response.ok) {
      throw new Error(`Catalog request failed: ${response.status}`);
    }
    const catalog = await response.json();
    assertCatalog(catalog);
    state.catalog = catalog;
    state.byId = new Map(catalog.map((provider) => [provider.id, provider]));
    state.selectedIds = DEFAULT_SELECTION.filter((id) => state.byId.has(id));
    elements.catalogStatus.textContent = text.catalogReady(catalog.length);
    renderProviderGrid();
    renderAll();
  } catch (error) {
    console.error(error);
    elements.catalogStatus.textContent = text.catalogError;
    elements.catalogStatus.dataset.state = "error";
    elements.providerGrid.replaceChildren();
    updateExportState();
  }
}

loadCatalog();
