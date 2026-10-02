const resetTimers = new WeakMap();
const copyStateVersions = new WeakMap();
const copyRequestVersions = new WeakMap();

function translated(key, fallback) {
  return window.siteI18n?.t(key) ?? fallback;
}
const providerPracticalSummaries = {
  facebook:
    "Prefer the SDK-rendered control for web login. The general logo pack is not a login-button template, and separate login-asset dimensions remain unverified.",
  github:
    "GitHub lists integration identification as an allowed example but broadly reserves trademark rights. Confirm the current permission scope before redistributing an asset.",
  microsoft:
    "The package bundles Microsoft's separately supplied official symbol. Prefer a complete official SVG or PNG when the full control is required.",
  x:
    "Do not treat publishing-button guidance as authentication guidance. No current login-specific visual specification was verified.",
  line:
    "The renderer uses LINE's verified white foreground and state values. Use the official template when exact complete-control geometry is required.",
  discord:
    "The Blurple package treatment is an unofficial adaptation. Do not present it as a verified Discord OAuth-button specification.",
  linkedin:
    "Use an approved download and never describe OIDC sign-in as real-world identity verification. A current login-button visual specification was not verified.",
  slack:
    "Prefer the official generator. If you build a custom control, preserve the exact wording, documented dimensions, logo spacing, and visibility rules.",
  twitch:
    "Access to general brand assets does not establish permission for login use. Confirm the current asset and permission terms separately.",
  spotify:
    "The full logo does not fit the common 24 px slot. Do not extend general integration guidance into an authentication-button specification.",
  steam:
    "Use one of the three complete official PNG controls for the matching browser sign-in context. Modification and package redistribution remain unverified.",
  reddit:
    "The OrangeRed package treatment is unofficial. Current login-control specifications and redistribution permission were not verified.",
  dropbox:
    "Do not treat the Tab or bare glyph as a login-icon specification. Only general brand composition guidance was verified.",
  gitlab:
    "Download availability and permission are different. Avoid modification, recombination, or implied affiliation, and confirm an applicable license before logo use.",
  bitbucket:
    "Choose the app or attribution logo for its documented context. The shared circular treatment conflicts with guidance against extra containers.",
  paypal:
    "The newsroom PNGs were not verified as authentication UI assets, and the current login documentation did not expose extractable visual rules.",
  telegram:
    "Prefer the generated control, OIDC library, or official native SDK instead of reconstructing a button from a standalone logo.",
  instagram:
    "Use current official assets without altering or translating the Instagram name. Do not present the professional-account API as general consumer login.",
  wechat:
    "Prefer the official JavaScript-rendered QR login surface. Its style option is not evidence for this package's circular button.",
  pinterest:
    "Use the supplied badge only in its documented context. Presence-marketing calls to action are not authentication wording.",
  snapchat:
    "Use the documented “Log in with Snapchat” wording and official Ghost asset without making the surrounding app look like Snapchat.",
  vk:
    "The renderer follows the documented custom-button colors, sizing, and opacity states. Prefer OneTap when the provider-rendered control is required.",
  weibo:
    "Use the official configurator and recheck the fixed sizes and current SDK suitability before production use.",
  qq:
    "Prefer the current OAuth flow and official UI material. General-logo minimum sizes do not define every QQ Login control.",
  epicGames:
    "No public reusable sign-in asset or visual specification was verified. Use only artwork supplied for the application's actual Epic agreement.",
  playstation:
    "Public terms confirm account linking but not a general identity-provider control. Use only approved partner artwork and wording.",
  nintendo:
    "No generally available Nintendo Account login control was verified. Obtain the exact flow and artwork from the applicable Nintendo program.",
  xbox:
    "Do not substitute Microsoft-account artwork or a brand-green preset. Xbox title integrations should use the required GDK or partner UI.",
  zoom:
    "Describe the real action as connecting or authorizing Zoom unless a separate login contract exists. No external OAuth-button specification was verified.",
  kakao:
    "The renderer uses documented Kakao colors and a package-selected 16 px label for the default button size. It is not the official complete control; shared shape overrides are custom treatments.",
  naver:
    "The renderer uses verified Naver foreground, sizing, and spacing values. Use an official complete asset when exact full-button composition is required.",
  google:
    "Prefer Google Identity Services or an official complete SVG or PNG. Do not describe the shared widget as equivalent to Google's rendered control.",
  apple:
    "Prefer the system button on Apple platforms and the official generated or JavaScript control elsewhere. Do not reconstruct a standalone Apple logo.",
  tiktok:
    "Use the official Logo and Button pack for an approved Login Kit integration. The pack's availability is not a blanket redistribution license.",
  notion:
    "Use connection wording such as “Add to Notion” or “Connect Notion.” Public OAuth docs do not establish a generic sign-in control or reusable login asset.",
};
const providerEvidenceLabels = {
  en: {
    signInButton: "Official sign-in guidance",
    generalBrand: "General brand guidance",
    unverified: "No public visual spec",
  },
  ko: {
    signInButton: "공식 로그인 안내 있음",
    generalBrand: "일반 브랜드 안내",
    unverified: "공개 시각 규격 미확인",
  },
};
const arrangementDefinitions = {
  vertical: {
    index: "01 / vertical",
    indexKo: "01 / 세로",
    title: "Vertical rounded",
    titleKo: "세로 둥근 사각형",
    note:
      "Vertical lists default to rounded buttons and stretch labelled items to one equal width.",
    noteKo:
      "세로 목록은 둥근 사각형이 기본이며, 레이블 버튼을 같은 너비로 맞춥니다.",
    direction: "vertical",
    providers: [
      { id: "google", label: "Sign in with Google", labelKo: "Google 로그인" },
      { id: "kakao", label: "Login with Kakao", labelKo: "카카오 로그인" },
      { id: "naver", label: "Continue with Naver", labelKo: "네이버 로그인" },
    ],
    code: `SocialButtonList.vertical(
  items: [
    SocialButton(
      social: Social.google,
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.kakao,
      onPressed: startKakaoSignIn,
    ),
    SocialButton(
      social: Social.naver,
      onPressed: startNaverSignIn,
    ),
  ],
)`,
  },
  pill: {
    index: "02 / vertical pill",
    indexKo: "02 / 세로 알약형",
    title: "Vertical pill",
    titleKo: "세로 알약형",
    note:
      "Set the shared pill shape once; every button inherits it without repeating visual options.",
    noteKo:
      "목록에 공통 알약형을 한 번 지정하면 모든 버튼이 같은 모양을 상속합니다.",
    direction: "vertical",
    providers: [
      { id: "line", label: "Log in with LINE", labelKo: "LINE 로그인", shape: "pill" },
      { id: "kakao", label: "Login with Kakao", labelKo: "카카오 로그인", shape: "pill" },
      { id: "naver", label: "Continue with Naver", labelKo: "네이버 로그인", shape: "pill" },
    ],
    code: `SocialButtonList.vertical(
  shape: SocialButtonShape.pill,
  spacing: 12,
  items: [
    SocialButton(
      social: Social.line,
      onPressed: startLineSignIn,
    ),
    SocialButton(
      social: Social.kakao,
      onPressed: startKakaoSignIn,
    ),
    SocialButton(
      social: Social.naver,
      onPressed: startNaverSignIn,
    ),
  ],
)`,
  },
  horizontal: {
    index: "03 / horizontal",
    indexKo: "03 / 가로",
    title: "Horizontal circle",
    titleKo: "가로 원형",
    note:
      "Horizontal lists default to circles and wrap onto another run when available width runs out.",
    noteKo:
      "가로 목록은 원형이 기본이며 공간이 부족하면 다음 줄로 넘어갑니다.",
    direction: "horizontal",
    providers: [
      { id: "google", label: "Google", labelKo: "Google", shape: "circle" },
      { id: "apple", label: "Apple", labelKo: "Apple", shape: "circle" },
      { id: "kakao", label: "Kakao", labelKo: "Kakao", shape: "circle" },
      { id: "line", label: "LINE", labelKo: "LINE", shape: "circle" },
    ],
    code: `SocialButtonList.horizontal(
  spacing: 8,
  items: [
    SocialButton(
      social: Social.google,
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.apple,
      onPressed: startAppleSignIn,
    ),
    SocialButton(
      social: Social.kakao,
      onPressed: startKakaoSignIn,
    ),
    SocialButton(
      social: Social.line,
      onPressed: startLineSignIn,
    ),
  ],
)`,
  },
  mixed: {
    index: "04 / explicit overrides",
    indexKo: "04 / 개별 재정의",
    title: "Explicit overrides",
    titleKo: "개별 버튼 재정의",
    note:
      "A button's explicit shape and size win over list values; an explicit circle stays square in a vertical list.",
    noteKo:
      "버튼에 직접 지정한 모양과 크기가 목록 값보다 우선하며, 원형은 세로 목록에서도 정사각형을 유지합니다.",
    direction: "vertical",
    providers: [
      { id: "google", label: "Sign in with Google", labelKo: "Google 로그인" },
      {
        id: "kakao",
        label: "Login with Kakao",
        labelKo: "카카오 로그인",
        shape: "pill",
        large: true,
      },
      { id: "apple", label: "Apple", labelKo: "Apple", shape: "circle" },
    ],
    code: `SocialButtonList.vertical(
  shape: SocialButtonShape.rounded,
  size: 48,
  spacing: 12,
  items: [
    SocialButton(
      social: Social.google,
      onPressed: startGoogleSignIn,
    ),
    SocialButton(
      social: Social.kakao,
      shape: SocialButtonShape.pill,
      size: 56,
      onPressed: startKakaoSignIn,
    ),
    SocialButton(
      social: Social.apple,
      shape: SocialButtonShape.circle,
      onPressed: startAppleSignIn,
    ),
  ],
)`,
  },
};

function renderArrangementPreview(container, definition) {
  const isKorean = document.body.dataset.locale === "ko";
  const list = document.createElement("div");
  list.className =
    definition.direction === "horizontal"
      ? "selected-arrangement-list selected-arrangement-list--horizontal"
      : "selected-arrangement-list";

  for (const provider of definition.providers) {
    const button = document.createElement("div");
    button.className = `specimen-button specimen-button--${provider.id}`;
    if (provider.shape) {
      button.classList.add(`specimen-button--${provider.shape}`);
    }
    if (provider.large) {
      button.classList.add("specimen-button--large");
    }

    const logo = document.createElement("span");
    logo.className = "specimen-logo";
    logo.setAttribute("aria-hidden", "true");

    const image = document.createElement("img");
    image.src = `../assets/social/${provider.id}.png`;
    image.alt = "";
    image.width = 24;
    image.height = 24;
    logo.append(image);
    button.append(logo);

    if (provider.shape === "circle") {
      button.setAttribute(
        "aria-label",
        isKorean ? provider.labelKo : provider.label,
      );
    } else {
      const label = document.createElement("span");
      label.textContent = isKorean ? provider.labelKo : provider.label;
      button.append(label);
    }

    list.append(button);
  }

  container.replaceChildren(list);
}

function activateArrangement(name) {
  const definition = arrangementDefinitions[name];
  const isKorean = document.body.dataset.locale === "ko";
  const group = document.querySelector("[data-arrangement-group]");
  const code = document.querySelector("[data-arrangement-code]");
  const preview = document.querySelector("[data-arrangement-preview]");
  if (!definition || !group || !code || !preview) return;

  group.querySelectorAll("[data-arrangement]").forEach((button) => {
    const selected = button.dataset.arrangement === name;
    button.classList.toggle("is-selected", selected);
    button.setAttribute("aria-pressed", String(selected));
  });

  document.querySelector("[data-arrangement-index]").textContent =
    isKorean ? definition.indexKo : definition.index;
  document.querySelector("[data-arrangement-title]").textContent =
    isKorean ? definition.titleKo : definition.title;
  document.querySelector("[data-arrangement-note]").textContent =
    isKorean ? definition.noteKo : definition.note;
  code.textContent = definition.code;
  code.classList.remove("is-selected");
  renderArrangementPreview(preview, definition);
}

function setCopyState(button, state, label, message) {
  const labelElement = button.querySelector(".copy-button__label");
  const statusElement = button
    .closest(".copy-control")
    .querySelector(".copy-status");
  const version = (copyStateVersions.get(button) ?? 0) + 1;
  copyStateVersions.set(button, version);

  button.classList.add("is-swapping");
  requestAnimationFrame(() => {
    if (copyStateVersions.get(button) !== version) return;
    button.classList.remove(
      "is-copying",
      "is-copied",
      "is-failed",
      "is-swapping",
    );
    button.classList.add(`is-${state}`);
    labelElement.textContent = label;
    statusElement.textContent = message;
    statusElement.dataset.state =
      state === "copied" ? "success" : state === "failed" ? "error" : "";
  });
}

function selectForManualCopy(target) {
  const selection = window.getSelection();
  const range = document.createRange();

  selection.removeAllRanges();
  range.selectNodeContents(target);
  selection.addRange(range);
  target.closest("pre").focus();
}

function scheduleReset(button) {
  const existingTimer = resetTimers.get(button);
  if (existingTimer) {
    window.clearTimeout(existingTimer);
  }

  const timer = window.setTimeout(() => {
    setCopyState(button, "ready", button.dataset.defaultLabel, "");
    resetTimers.delete(button);
  }, 2400);
  resetTimers.set(button, timer);
}

async function copyTarget(button) {
  const target = document.getElementById(button.dataset.copyTarget);
  const copyName = button.dataset.copyName;
  const requestVersion = (copyRequestVersions.get(button) ?? 0) + 1;
  copyRequestVersions.set(button, requestVersion);

  if (!target) {
    setCopyState(
      button,
      "failed",
      translated("copy.missingLabel", "Unavailable"),
      translated("copy.missing", "Copy source is missing."),
    );
    scheduleReset(button);
    return;
  }

  setCopyState(
    button,
    "copying",
    translated("copy.copying", "Copying…"),
    "",
  );

  try {
    if (!navigator.clipboard?.writeText) {
      throw new Error("Clipboard API unavailable");
    }

    await navigator.clipboard.writeText(target.textContent);
    if (copyRequestVersions.get(button) !== requestVersion) return;
    window.getSelection()?.removeAllRanges();
    setCopyState(
      button,
      "copied",
      translated("copy.copied", "Copied"),
      translated(
        button.dataset.copySuccessKey,
        `${copyName} copied to clipboard.`,
      ),
    );
  } catch {
    if (copyRequestVersions.get(button) !== requestVersion) return;
    selectForManualCopy(target);
    setCopyState(
      button,
      "failed",
      translated("copy.failed", "Select text"),
      translated(
        "copy.failure",
        "Copy failed. The source text is selected; copy it manually.",
      ),
    );
  }

  scheduleReset(button);
}

document.querySelectorAll("[data-copy-target]").forEach((button) => {
  button.dataset.defaultLabel = button
    .querySelector(".copy-button__label")
    .textContent;
  button.addEventListener("click", () => copyTarget(button));
});

window.addEventListener("languagechange", () => {
  document.querySelectorAll("[data-copy-target]").forEach((button) => {
    const timer = resetTimers.get(button);
    if (timer) window.clearTimeout(timer);
    resetTimers.delete(button);
    copyStateVersions.set(button, (copyStateVersions.get(button) ?? 0) + 1);
    copyRequestVersions.set(
      button,
      (copyRequestVersions.get(button) ?? 0) + 1,
    );
    button.classList.remove(
      "is-copying",
      "is-copied",
      "is-failed",
      "is-swapping",
    );
    button.dataset.defaultLabel = button.querySelector(
      ".copy-button__label",
    ).textContent;
    const status = button.closest(".copy-control").querySelector(".copy-status");
    status.textContent = "";
    status.dataset.state = "";
  });
});

document.querySelectorAll("[data-arrangement]").forEach((button) => {
  button.addEventListener("click", () => {
    activateArrangement(button.dataset.arrangement);
  });
});

if (document.querySelector("[data-arrangement-group]")) {
  activateArrangement("vertical");
}

function openProviderDetail(target, { focus = false } = {}) {
  if (
    !(target instanceof HTMLDetailsElement) ||
    !target.classList.contains("provider-detail")
  ) {
    return;
  }

  target.open = true;
  window.setTimeout(() => {
    window.scrollTo({
      top: target.getBoundingClientRect().top + window.scrollY,
      behavior: "instant",
    });
    if (focus) {
      target.querySelector("summary")?.focus({ preventScroll: true });
    }
  }, 0);
}

function openProviderFromHash() {
  const id = decodeURIComponent(window.location.hash.slice(1));
  if (!id) return;
  openProviderDetail(document.getElementById(id));
}

document
  .querySelectorAll('.provider-index a[href^="#"]')
  .forEach((providerLink) => {
    providerLink.addEventListener("click", () => {
      const id = decodeURIComponent(providerLink.hash.slice(1));
      openProviderDetail(document.getElementById(id), { focus: true });
    });
  });

window.addEventListener("hashchange", openProviderFromHash);

if (document.documentElement.lang === "en") {
  document.querySelectorAll(".provider-detail").forEach((provider) => {
    const summary = providerPracticalSummaries[provider.id];
    const body = provider.querySelector(".provider-detail__body");
    if (!summary || !body || body.querySelector(".provider-practical")) return;

    const practical = document.createElement("p");
    practical.className = "provider-practical";

    const label = document.createElement("strong");
    label.textContent = "Practical summary:";
    practical.append(label, ` ${summary}`);
    body.prepend(practical);
  });
}

const evidenceLabels =
  providerEvidenceLabels[document.documentElement.lang] ??
  providerEvidenceLabels.en;
document.querySelectorAll(".provider-detail").forEach((provider) => {
  const badge = provider.querySelector(".evidence-badge");
  const taxonomy = badge?.textContent.trim();
  if (badge && taxonomy && evidenceLabels[taxonomy]) {
    badge.textContent = evidenceLabels[taxonomy];
  }
});

openProviderFromHash();
